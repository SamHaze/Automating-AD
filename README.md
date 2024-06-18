# Active Directory User Account Automation with PowerShell
<div align="center">
    <img src="https://github.com/SamHaze/Automating-AD/assets/131014255/eee32d10-00ef-4f5f-8830-4c75aff2bfa3" width="440" />
</div>

## Overview
This project demonstrates how to automate the creation of Active Directory user accounts using a PowerShell script. Instead of manually creating each user account, the script processes a list of names from a text file and generates user accounts efficiently. This approach saves time and reduces the potential for errors associated with manual account creation.

## Features
- Reads a list of names from a text file.
- Creates an organizational unit (OU) in Active Directory to store the new user accounts.
- Generates user accounts with specified attributes.
- Sets a default password for each user and requires password change at first login.
- Provides functionality to delete, enable, disable, and reset passwords for user accounts.

## Prerequisites
- Active Directory environment.
- PowerShell installed on your machine.
- A text file containing the list of names (`New_Users.txt`).

## Script Details
### Variables
- `$PASSWORD_FOR_USERS`: Sets the default password for the new user accounts.
- `$NAME_LIST`: Reads the list of names from the specified text file.

### Main Operations
1. **Convert Password to Secure String:**
   ```powershell
   $password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
   ```

2. **Create Organizational Unit:**
   ```powershell
   New-ADOrganizationalUnit -Name NewUsersOU -Path "OU=mydomain,DC=mydomain,DC=com" -ProtectedFromAccidentalDeletion $false
   ```

3. **Loop Through Name List and Create Users:**
   ```powershell
   foreach ($n in $NAME_LIST) {
       $first_name = $n.Split(" ")[0].ToLower()
       $last_name = $n.Split(" ")[1].ToLower()
       $username = "$($first_name.Substring(0,3))$($last_name)".ToLower()
       Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Green
       
       New-AdUser -AccountPassword $password `
                  -GivenName $first_name `
                  -Surname $last_name `
                  -DisplayName $username `
                  -Name $username `
                  -EmployeeID $username `
                  -ChangePasswordAtLogon $true `
                  -Path "OU=NewUsersOU,OU=mydomain,DC=mydomain,DC=com" `
                  -Enabled $true
   }
   ```

## Running the Script
1. Save the script as `userCreation.ps1` on your desktop.
2. Ensure the `New_Users.txt` file is also on your desktop.
3. Open PowerShell and navigate to your desktop.
4. Run the script:
   ```powershell
   ./userCreation.ps1
   ```

## Additional Commands
- **Delete a User Account:**
  ```powershell
  Remove-ADUser -Identity "Username" -Confirm:$false
  ```
- **Enable a User Account:**
  ```powershell
  Enable-ADAccount -Identity "Username"
  ```
- **Disable a User Account:**
  ```powershell
  Disable-ADAccount -Identity "Username"
  ```
- **Reset a User Account Password:**
  ```powershell
  Set-ADAccountPassword -Identity "Username" -Reset -NewPassword (ConvertTo-SecureString "NewPassword" -AsPlainText -Force)
  ```

## Conclusion
This project simplifies the process of creating and managing Active Directory user accounts using PowerShell.
By automating account creation, it ensures efficiency and accuracy, freeing up time for other administrative tasks.
