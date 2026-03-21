### Aliases

New-Alias -Name l -Value Get-ChildItem

New-Alias -Name ga -Value Get-Alias

New-Alias -Name info -Value Get-PnPSite 

New-Alias -Name cl -Value clear

New-Alias -Name spexit -Value Disconnect-PnPOnline

New-Alias -Name  exexit disconnect-ExchangeOnline

New-Alias -Name clip Set-Clipboard


# Download Site Pages
function pcopy {
    $pageUrl = Read-Host -Prompt "Enter page URL"
    $localPath = "$HOME/Desktop"
    #Grabs the filename string at end of URL
    if ($pageUrl -match ".*/(.+)$") {
        $fname = $matches[1]
    }
    Get-PnPFile -Url $pageUrl -Path $localPath -FileName "$fname" -AsFile
}

function excon {
     Connect-ExchangeOnline -UserPrincipalName thilbert@clinical.law.berkeley.edu -LoadCmdletHelp
}
function getpro { 
    Get-Content $PROFILE 
}
function gfx {
    param ($fxname)
    Get-Content Function:\"$fxname"
}
#* Get-Command -Name $fxname | Select-Object -ExpandProperty parameters
#* Show a command's parameters
function gcp {
    param ($commandName)
    get-command "$commandName" | Select-Object -ExpandProperty parameters
}
#* Show a command's parameter descriptions
function gcpd {
    param ($commandName)
    $params = (Get-Command "$commandName").Parameters.Values
    foreach ($param in $params) {
        [PSCustomObject]@{
            Name        = $param.Name
            Type        = $param.ParameterType.Name
            Required    = $param.IsMandatory
            Description = $param.HelpMessage
        }
    } Format-Table -AutoSize
}

function hs {
   Get-Content (Get-PSReadlineOption).HistorySavePath
}

function getuid {
     param (
    [Parameter(Mandatory=$true)]
    [string]$Prefix
)
    Connect-MgGraph -Scopes "User.Read.All"
    $user =  Get-MgUser -UserId "$Prefix@clinical.law.berkeley.edu"
    Write-Host "User Object ID: $($user.Id)" -ForegroundColor DarkGreen

}
function New-SecurityGroupPrompt {
    [CmdletBinding()]
    param ()

    # Prompt for group details
    $displayName = Read-Host "Enter the Display Name for the new security group"
    $description = Read-Host "Enter the Description for the group"

    # Generate a valid mailNickname
    $mailNickname = $displayName -replace '[^a-zA-Z0-9]', ''  # Remove non-alphanumerics
    if ($mailNickname[0] -match '\d') {
        $mailNickname = "grp" + $mailNickname  # Prefix if starts with digit
    }

    # Connect to Microsoft Graph (if not already connected)
    if (-not (Get-MgContext)) {
        Connect-MgGraph -Scopes "Group.ReadWrite.All"
    }

    # Create the security group
    try {
        $params = @{
            DisplayName     = $displayName
            Description     = $description
            MailEnabled     = $false
            SecurityEnabled = $true
            GroupTypes      = @()
            MailNickname    = $mailNickname
        }

        New-MgGroup @params

        Write-Host "✅ Security group '$displayName' created successfully with mailNickname '$mailNickname'." -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to create group: $($_.Exception.Message)" -ForegroundColor Red
    }
}


# # Initialize Starship at the end of your profile
# Invoke-Expression (&starship init powershell)

oh-my-posh init pwsh --config /Users/tom/.config/ohmyposh/pwsh/themes/omp-pwsh.json | Invoke-Expression 

function Get-M365GroupsOwnedByUser {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$UserPrefix
    )

    # Hard‑coded domain
    $Domain = "@clinical.law.berkeley.edu"

    # Construct full UPN
    $UserPrincipalName = "$UserPrefix$Domain"

    Write-Verbose "Checking Microsoft 365 Groups owned by $UserPrincipalName..."

    # Get all directory objects the user owns
    $ownedObjects = Get-MgUserOwnedObject -UserId $UserPrincipalName

    # Filter to Microsoft 365 Groups (Unified)
    $m365GroupIds = $ownedObjects |
        Where-Object {
            $_.AdditionalProperties['groupTypes'] -contains "Unified"
        } |
        Select-Object -ExpandProperty Id

    if (-not $m365GroupIds) {
        return
    }

    # Rehydrate each group and output a non-truncated DisplayName
    foreach ($groupId in $m365GroupIds) {
        Get-MgGroup -GroupId $groupId |
            Select-Object @{n='DisplayName';e={ $_.DisplayName }}
    }
}




