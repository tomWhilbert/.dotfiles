### Aliases

New-Alias -Name ls -Value Get-ChildItem

New-Alias -Name ga -Value Get-Alias

New-Alias -Name info -Value Get-PnPSite 

New-Alias -Name cl -Value clear

New-Alias -Name spexit -Value Disconnect-PnPOnline

New-Alias -Name  exexit disconnect-ExchangeOnline

New-Alias -Name clip Set-Clipboard





# function spcon {
    #   param($site)
    #   Connect-PnPOnline -Url https://ucblaw.sharepoint.com/sites/"$site" -Interactive
# }

### New Connection methond using registered app and client id
function spcon {
    param($site)
    Connect-PnPOnline -Url https://ucblaw.sharepoint.com/sites/"$site" -Interactive -ClientId 23a59291-9134-42f2-8e9a-f944c6e82529
}

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

function gcf {
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
