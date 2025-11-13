function get-userDL {
    param(
        [Parameter(Mandatory)]
        [string]$UserName
    )
    $UserDLGroups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember $_.Identity -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -eq $userName }) } 
    return $UserDLGroups.PrimarySmtpAddress
}

function set-DlSkipPolicy {
    param(
        [Parameter(Mandatory)]
        [string]$UserName,
        [Parameter(Mandatory)]
        [string[]]$userGroups

    )
    foreach ($group in $userGroups) {
        $ruleName = "Skip DL self-sent emails to $group"
        $existingRule = Get-InboxRule -Mailbox $UserName -Erroraction SilentlyContinue | Where-Object { $_.Name -eq $ruleName }

        if (-not $existingRule) {
            Write-Host "Creating rule for : $group"
            New-InboxRule -Mailbox $userName -Name $ruleName -From $userName -SentTo $group -DeleteMessage $true -Force
        }
        else {
            Write-Host "Rule already exists for: $group"
        }
    }
}

function set-BatchDlSkipPolicy{
    param(
        [Parameter(Mandatory)]
        [string]$path
    )

    $users = Import-Csv -Path $path

    if (-not (Test-Path $Path)) {
    Throw "CSV file not found at path: $Path"
}

    foreach ($user in $users) {
    $userName = $user.UserName
    Write-Host "`nProcessing user: $userName"

    try {
        # Get distribution groups for the user
        $userGroups = Get-UserDL -UserName $userName

        if ($userGroups.Count -gt 0) {
            # Set inbox rules for each group
            Set-DLSkipPolicy -UserName $userName -UserGroups $userGroups
        } else {
            Write-Host "No distribution groups found for $userName"
        }
    }
    catch {
        Write-Warning "Failed to process $userName. Error: $_"
    }
}

}

