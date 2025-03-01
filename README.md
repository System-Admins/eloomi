# Introduction
Welcome to the Eloomi PowerShell (SystemAdmins.Eloomi) module!

## :ledger: Index

- [About](#beginner-about)
- [Usage](#zap-usage)
  - [Installation](#electric_plug-installation)
  - [Commands](#package-commands)
  - [Cmdlets](#cmdlets)
    - [Send-EntraUserMfaStatusReport](#Send-EntraUserMfaStatusReport)
- [FAQ](#question-faq)

##  :beginner: About
This PowerShell module is a wrapper for the Eloomi API v1 (https://api.eloomi.io).
Currently it only provides interaction with field, groups and users.
At a later point (if needed) courses, playlists, events, categories and topics will be added.

## :zap: Usage
To get started with the Eloomi PowerShell module, simply follow the instructions outlined in the documentation provided in this repository. You'll find detailed guidance on installation, configuration, and usage, enabling you to seamlessly integrate the module into your existing workflows.

###  :electric_plug: Installation

Before installing the module, the following prerequisites must be fulfilled:

- [ ] **PowerShell 7** installed, [see this for more information](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5).
- [ ] A valid API generated from the Eloomi portal.

###  :package: Commands
1. To install the module and it dependencies, run the following in a PowerShell 7 session:

   ```powershell
   Install-Module -Name 'SystemAdmins.Eloomi' -Scope CurrentUser -Force;
   ```

2. Import the module dependencies in the PowerShell 7 session.

   ```powershell
   Import-Module -Name 'SystemAdmins.Eloomi' -Force;
   ```


## Cmdlets

### Cmdlet Name

#### Synopsis

.

#### Parameter(s)

| Type   | Parameter    | Description                                                  | Optional | Accepted Values |
| ------ | ------------ | ------------------------------------------------------------ | -------- | --------------- |
| TBD | TBD | TBD | True     | TBD |

#### Example(s)

.

```powershell

```

### Output

Void



## :question: FAQ

- **Why is it free?**

  Why shouldn't it be.