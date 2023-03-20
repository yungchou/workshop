param($password,
    $dbsource,
    $defaultDnsDomain = "contoso.com",
    $defaultDomain = $dnsDomain)

Start-Transcript "C:\deploy-sqlvm-log.txt"

# Check domain status
If ((Get-CimInstance  -ClassName Win32_computersystem).domain -notmatch "\.") {
    Write-Warning "This computer ($($env:COMPUTERNAME)) is not a member of a domain!"
}

# Set up data disk
Write-Output "Setting up data disk"
$disk = Get-Disk | where-object PartitionStyle -eq "RAW"
$disk | Initialize-Disk -PartitionStyle MBR -PassThru -confirm:$false
$partition = $disk | New-Partition -UseMaximumSize -DriveLetter F
$partition | Format-Volume -Confirm:$false -Force

# Failover clustering
Write-Output "Installing failover clustering"
Install-WindowsFeature -Name "Failover-Clustering" `
                       -IncludeManagementTools `
                       -IncludeAllSubFeature

Install-WindowsFeature RSAT-Clustering-PowerShell

# DB folders
Write-Output "Creating folders"
$logs = "F:\Logs"
$data = "F:\Data"
$backups = "F:\Backup" 
[system.io.directory]::CreateDirectory($logs)
[system.io.directory]::CreateDirectory($data)
[system.io.directory]::CreateDirectory($backups)

Write-Output "Starting SQL"

# Make sure SQL Service is started
# Restart the SQL Server service
Write-Output "Restart SQL"
Restart-Service -Name "MSSQLSERVER" -Force
Start-Sleep -Seconds 90

# Setup the data, backup and log directories as well as mixed mode authentication
Write-Output "Set up data, backup and log directories in SQL, plus mixed-mode auth"
Import-Module "sqlps" -DisableNameChecking
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
$sqlesq = new-object ('Microsoft.SqlServer.Management.Smo.Server') Localhost
$sqlesq.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
$sqlesq.Settings.DefaultFile = $data
$sqlesq.Settings.DefaultLog = $logs
$sqlesq.Settings.BackupDirectory = $backups
$sqlesq.Alter() 

# Restart the SQL Server service
Write-Output "Restart SQL"
Restart-Service -Name "MSSQLSERVER" -Force

# Re-enable the sa account and set a new password to enable login
Write-Output "Re-enable 'sa' account, and set password to $password"
Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER LOGIN sa ENABLE" 
Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER LOGIN sa WITH PASSWORD = '$password'"

#Add local administrators group as sysadmin
Write-Output "Add local admins as sysadmin"
Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "CREATE LOGIN [BUILTIN\Administrators] FROM WINDOWS"
Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER SERVER ROLE sysadmin ADD MEMBER [BUILTIN\Administrators]"

# Build Firewall Rules for SQL & AOG
Write-Output "Firewall rules"
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow 
New-NetFirewallRule -DisplayName "SQL AG Endpoint" -Direction Inbound -Protocol TCP -LocalPort 5022 -Action allow 
New-NetFirewallRule -DisplayName "SQL AG Load Balancer Probe Port" -Direction Inbound -Protocol TCP -LocalPort 59999 -Action allow

# For secondary servers, we skip restoring the DB. So check first if server name is SQLVM1
if (($env:COMPUTERNAME) -eq "SQLVM1") {
    # Get the Contoso Insurance database backup 
    $dbdestination = "D:\ContosoInsurance.bak"
    Write-Output "Download $dbsource to $dbdestination"
    #Invoke-WebRequest $dbsource -OutFile $dbdestination
    powershell -ExecutionPolicy Unrestricted "[Net.ServicePointManager]::SecurityProtocol = 'Tls12'; Invoke-WebRequest -uri  $dbsource -OutFile $dbdestination"

    # Restore the database from the backup
    Write-Output "Restore the database from backup"
    $mdf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("ContosoInsurance", "F:\Data\ContosoInsurance.mdf")
    $ldf = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("ContosoInsurance_Log", "F:\Logs\ContosoInsurance.ldf")
    Restore-SqlDatabase -ServerInstance Localhost -Database ContosoInsurance `
                        -BackupFile $dbdestination -RelocateFile @($mdf,$ldf) -ReplaceDatabase

    # Put the database into full recovery and run a backup (required for SQL AG)
    Write-Output "Put into full recovery and run backup"
    Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER DATABASE ContosoInsurance SET RECOVERY FULL"
    Backup-SqlDatabase -ServerInstance Localhost -Database ContosoInsurance
} else {
    Write-Output "Secondar server, no database restored"
}

Write-Output "All done"

Stop-Transcript