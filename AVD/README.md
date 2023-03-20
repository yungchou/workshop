# Implementing Azure Virtual Desktop in the enterprise

Contoso Healthcare, headquartered in Los Angeles, California, is a national healthcare provider with a network of affiliate hospitals and doctor’s offices located throughout North America. These locations continue to grow through acquisition.  The nature of their business requires a high level of security of personal identifiable information (PII) for their employees.

Contoso currently has approximately 250 workstations within their environment with business applications for non-clinical users from the Developer, Finance, and Knowledge departments. Contoso is currently supporting existing data centers in California and Northern Virginia with VMware for the server control plane and a partial deployment of Citrix virtual desktop infrastructure. These locations are connected with a private WAN connection and a backup VPN over broadband.  

August 2022

## Target audience

- Infrastructure Specialists
- Cloud Solution Architects
- Account Technology Specialists

## Abstracts

### Workshop

In this workshop, you will gain experience designing solutions for Azure Virtual Desktop utilizing Microsoft 365 and Azure technologies.

The following components will need to be determined as part of the solutions. The first will consist of Microsoft 365 subscription that will be required to deliver the security requirements, Azure Active Directory, applications, and Windows licensing to users. Next, the Azure infrastructure that is required to support the Azure Virtual Desktop environment will need to be configured. Finally, the networking requirements will need to be determined for connectivity to the current on-premises infrastructure for application servers, and proper access to the user desktops and on-premises network with high security and limited latency.

At the end of this workshop, you will be better able to leverage various Microsoft 365 and Azure technologies together to build a secure, complex and robust Azure Virtual Desktop infrastructure.

### Whiteboard design session

In the whiteboard design session, you will work in groups to design an Azure Virtual Desktop solution using Microsoft 365 and Azure technologies. Your solution will consider the necessary Microsoft 365 subscription required for Windows 10 Enterprise multi-user licensing, as well as the Azure Active Directory and security needs for a healthcare provider.  You will need to determine how to connect Azure to the current VMware and Citrix on-premises infrastructure and the connections needed to connect this infrastructure to Azure for application access. Finally, you will need to design the Azure Virtual Desktop solution utilizing Azure virtual machines with availability and scalability to handle 24x7 operations without performance degradation.

At the end of the whiteboard design session, you will be better able to design a solution that leverages Microsoft 365 and Azure technologies together to build a secure and robust Azure Virtual Desktop infrastructure.

Continue to the [Whiteboard design session](https://github.com/microsoft/MCW-Implementing-Azure-Virtual-Desktop-in-the-enterprise/tree/main/Whiteboard%20design%20session) documents folder.

### Hands-on lab

In this hands-on lab, you will implement an Azure Virtual Desktop (AVD) infrastructure and learn how to set up a working AVD environment end-to-end in a typical Enterprise model. At the end of the lab, attendees will have deployed an Azure Active Directory Tenant with Azure AD Connect to an Active Directory Domain Controller running in Azure. You will also deploy the Azure infrastructure for the Azure Virtual Desktop Tenant(s), Host Pool(s), and session host(s). Then you will connect to an AVD session utilizing different supported devices and browsers. You will publish desktops and remote apps. Finally, you will configure user profiles and FSLogics with Azure file shares. Finally, you will configure monitoring and security for the Azure Virtual Desktop infrastructure and understand the steps to manage the gold images.

At the end of this hands-on lab, you will be better able to build a secure and robust Azure Virtual Desktop infrastructure.

Continue to the [Hands-on lab](https://github.com/microsoft/MCW-Implementing-Azure-Virtual-Desktop-in-the-enterprise/tree/main/Hands-on%20lab) documents folder.

## Azure services and related products

- Azure Virtual Desktop
- Microsoft 365
- Azure Active Directory
- Azure Networking
- Azure Virtual Machines

## Related references

- [MCW](https://microsoftcloudworkshop.com)

## Help & Support

We welcome feedback and comments from Microsoft SMEs & learning partners who deliver MCWs.  

***Having trouble?***

- First, verify you have followed all written lab instructions (including the Before the Hands-on lab document).
- Next, submit an issue with a detailed description of the problem.
- Do not submit pull requests. Our content authors will make all changes and submit pull requests for approval.

If you are planning to present a workshop, *review and test the materials early*! We recommend at least two weeks prior.

### Please allow 5 - 10 business days for review and resolution of issues.
