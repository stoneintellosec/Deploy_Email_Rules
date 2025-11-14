# setTimeZone PowerShell Script

## Description
The `setTimeZone` script allows administrators to bulk update the **Exchange Online mailbox regional configuration** (timezone) for multiple users from a CSV file. Users can select a timezone from a simple numbered menu and specify a CSV of mailbox usernames.

The script logs all actions to a timestamped log file for auditing.

---

## Requirements
- PowerShell 5.1 or later (Windows)
- Exchange Online Management module (`ExchangeOnlineManagement`)
- Appropriate permissions to update mailbox regional settings
  - Usually requires Exchange Online admin or equivalent permissions

---

## CSV Format
The CSV file must have a column named `UserName` containing the mailbox identity (UPN or alias). Example:

```csv
UserName
jdoe@domain.com
jsmith@domain.com
```

---

## Timezone Options
When running the script, the user is prompted to select a timezone by number:

1. Eastern Standard Time  
2. Central Standard Time (Texas)  
3. Mountain Standard Time

---

## Usage

1. Open PowerShell and connect to Exchange Online:

```powershell
Connect-ExchangeOnline -UserPrincipalName admin@domain.com
```

2. Run the script:

```powershell
setTimeZone
```

3. Follow prompts:
   - Enter the number corresponding to the desired timezone
   - Enter the full path to the CSV file containing users

4. The script will:
   - Update each mailbox timezone
   - Output a table of `Identity` and `TimeZone` for each mailbox
   - Log all actions to a timestamped log file (e.g., `2025-11-14_13-30-00_BatchTimeZone.txt`)

---

## Notes
- Any mailbox that fails to update will be reported as a warning.
- Ensure the CSV contains valid mailbox identities.
- The script uses `Start-Transcript` to capture a full log of actions.
- Timezones are based on Microsoft’s recognized Exchange timezones.

---

## Example
```powershell
Select a TimeZone:
1. Eastern Standard Time
2. Central Standard Time (Texas)
3. Mountain Standard Time
Enter the number of your choice: 2
Enter full path to CSV file containing users: C:\Users\admins\users.csv
```

This will update all users in the CSV to **Central Standard Time (Texas)**.

