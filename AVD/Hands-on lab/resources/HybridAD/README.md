# Azure Active Directory Hybrid Lab
## Creates an AD VM with Azure AD Connect installed
## Quick Start

Based on the [AAD Hybrid Lab deployment](https://github.com/PeterR-msft/M365WVDWS) from Peter R.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2FMCW-Implementing-Azure-Virtual-Desktop-in-the-enterprise%2Fmain%2FHands-on%20lab%2Fresources%2FHybridAD%2Fdeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>

## Details
* Deploys the following infrastructure:
 * Virtual Network
  * 1 subnet
  * 1 Network Security Groups
    * AD - permits AD traffic, RDP incoming to network; limits DMZ access
  * Public IP Address
  * AD VM
	* DSC installs AD
    * Test users are created
    * Azure Active Directory Connect is installed and available to configure.

## Notes
* The NSG is defined for reference, but is isn't production-ready as holes are also opened for RDP, and public IPs are allocated
* One VM size is specified for all VMs


## NOTICE/WARNING
* This template is explicitly designed for a lab/classroom environment. A few compromises were made, especially with regards to credential passing to DSC, that WILL result in clear text passwords being left behind in the DSC package folders, Azure log folders, and system event logs on the resulting VMs. 