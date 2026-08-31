### Aliases

New-Alias -Name l -Value Get-ChildItem

New-Alias -Name ga -Value Get-Alias

New-Alias -Name info -Value Get-PnPSite 

New-Alias -Name cl -Value clear

New-Alias -Name spexit -Value Disconnect-PnPOnline

New-Alias -Name  exexit disconnect-ExchangeOnline

New-Alias -Name clip Set-Clipboard


function Connect-PnP {
    param(
        [Parameter(Mandatory)]
        [string]$SiteName
    )

    $url = "https://ucblaw.sharepoint.com/sites/$SiteName"

    Connect-PnPOnline `
        -Url $url `
        -Interactive `
        -ClientId "23a59291-9134-42f2-8e9a-f944c6e82529"
}

function Get-doclibs {
    Get-PnPList |
    Where-Object {
        $_.BaseTemplate -eq 101 -and
        -not $_.Hidden
    } |
    Select-Object Title
}

function excon {
     Connect-ExchangeOnline -UserPrincipalName thilbert@clinical.law.berkeley.edu -LoadCmdletHelp
}

function getpro { 
    Get-Content $PROFILE 
}
function gfx {
    param ($fxname)
    Get-Content Function:\"$fxname"ds
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

# Initiate oh-my-posh with the specified configuration file
oh-my-posh init pwsh --config /Users/tom/.config/ohmyposh/pwsh/themes/omp-pwsh.json | Invoke-Expression 




