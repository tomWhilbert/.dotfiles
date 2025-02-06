### Aliases

New-Alias -Name ls -Value Get-ChildItem

New-Alias -Name ga -Value Get-Alias

New-Alias -Name info -Value Get-PnPSite 

New-Alias -Name cl -Value clear

New-Alias -Name spexit -Value Disconnect-PnPOnline

New-Alias -Name  exexit disconnect-ExchangeOnline


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
     Connect-ExchangeOnline -UserPrincipalName thilbert@clinical.law.berkeley.edu
}

function getpro { 
    Get-Content $PROFILE 
}