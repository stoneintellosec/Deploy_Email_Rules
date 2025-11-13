# Distribution Group Self-Sent Email Rule Automation

This PowerShell script automates the creation of inbox rules for users to **delete emails they send to distribution groups** they are a member of. It is designed to simplify mailbox management and reduce clutter caused by self-sent messages to DLs.

---

## Features

- Retrieves all distribution groups a user is a member of.
- Creates an inbox rule for each group that deletes self-sent messages.
- Checks if the rule already exists to avoid duplication.
- Supports multiple groups per user.
- Supports batch processing for multiple users via CSV.

---

## Requirements

- Exchange Online PowerShell Module installed and connected.
- Appropriate permissions to run `Get-DistributionGroup`, `Get-DistributionGroupMember`, and `New-InboxRule` cmdlets.
- PowerShell 5.1 or later.

---

## Functions

### 1. `Get-UserDL`

Retrieves all distribution groups a user belongs to.

**Parameters:**

- `UserName` – The primary SMTP address of the user (mandatory).

**Example:**
```powershell
$userGroups = Get-UserDL -UserName "user@domain.com"
```

---

### 2. `Set-DLSkipPolicy`

Creates inbox rules for each distribution group to delete messages sent by the user.

**Parameters:**

- `UserName` – The user’s primary SMTP address (mandatory).  
- `UserGroups` – An array of distribution group SMTP addresses (mandatory).

**Example:**
```powershell
Set-DLSkipPolicy -UserName "user@domain.com" -UserGroups $userGroups
```

---

### 3. `set-BatchDlSkipPolicy`

Runs the inbox rule creation process for multiple users listed in a CSV file.

**Parameters:**

- `Path` – Path to a CSV file containing a column `UserName` with the email addresses of users (mandatory).

**CSV Example:**
```csv
UserName
user1@domain.com
user2@domain.com
user3@domain.com
```

**Usage Example:**
```powershell
set-BatchDlSkipPolicy -Path ".\Users.csv"
```

**How it works:**
1. Imports users from the specified CSV file.
2. Loops through each user.
3. Retrieves their distribution groups.
4. Creates inbox rules for each group if they don’t already exist.
5. Handles errors gracefully without stopping the batch process.

---

## Usage

1. Open PowerShell and connect to Exchange Online:
```powershell
Connect-ExchangeOnline -UserPrincipalName admin@domain.com
```

2. Load the script functions:
```powershell
. .\DLRules.ps1  # dot-source to import functions
```

3. Run the functions for a single user:
```powershell
$userName = "user@domain.com"
$userGroups = Get-UserDL -UserName $userName
Set-DLSkipPolicy -UserName $userName -UserGroups $userGroups
```

4. Run batch processing for multiple users from a CSV file:
```powershell
set-BatchDlSkipPolicy -Path ".\Users.csv"
```

---

## Notes

- Rules are created using `-Force` to avoid prompts.
- Existing rules with the same name are skipped.
- The script can be modified to **hide rules** in Outlook by adding `-HiddenFromUser` in the `New-InboxRule` cmdlet.
- Logging can be added for batch processing if needed.
- Ideal for automating self-sent email management for mult