function setTimeZone() {
  
    Write-Host "Select a TimeZone:"
    Write-Host "1. Mountain Standard Time"
    Write-Host "2. Eastern Standard Time"

    # Get user selection
    $selection = Read-Host "Enter the number of your choice"

    switch ($selection) {
        "1" { $timeZone = "Mountain Standard Time" }
        "2" { $timeZone = "Eastern Standard Time" }
        default { 
            Write-Error "Invalid selection. Exiting."
            return
        }
    }

    # Prompt for CSV path
    $path = Read-Host "Enter full path to CSV file containing users"



    $date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

    $logPath = "${date}_BatchTimeZone.txt"
    Start-Transcript -Path $logPath -Append

   

    if (-not (Test-Path $path)) {
        Throw "CSV file not found at path: $Path"
        return
    }

    $users = Import-Csv -Path $path

    if (-not ($users[0].PSObject.Properties.Name -contains "UserName")) {
        Throw "CSV does not contain a 'UserName' column."
    }

    foreach ($user in $users) {
        $userName = $user.UserName

        try {
            Set-MailboxRegionalConfiguration -Identity $userName -TimeZone $timeZone
            $regional = Get-MailboxRegionalConfiguration -Identity $userName
            $regional | Format-Table Identity, TimeZone
            Write-Host "Successfully set timezone for $userName to $timeZone"
        }
        catch {
           Write-Warning "⚠ Failed to process $userName. Error: $_" 
        }



    }

    Stop-Transcript


}


