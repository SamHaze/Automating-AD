# Program Name: userCreation.ps1
# Purpose: This script parses through a list of names, firstname then lastname, and creates an Active Directory user account with each name.
# Author: Sam
# Version: 1.1
# Date: 2024-06-18
# Update: Added error handling mechanisms to minimize downtime and ensure seamless operation.

# ------------------------------------------------------------------------- #
$PASSWORD_FOR_USERS = "P@ssw0rd"
$NAME_LIST_PATH = "C:\Users\$env:username\Desktop\New_Users.txt"
# ------------------------------------------------------------------------- #

# Function to log errors
function Log-Error {
    param (
        [string]$Message
    )
    Add-Content -Path "C:\Users\$env:username\Desktop\error_log.txt" -Value "$(Get-Date) - $Message"
}

# Convert the password for users to a secure string
try {
    $password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
} catch {
    Log-Error "Failed to convert password to secure string. Error: $_"
    exit 1
}

# Load the name list from the specified path
try {
    $NAME_LIST = Get-Content -Path $NAME_LIST_PATH
} catch {
    Log-Error "Failed to read name list from path: $NAME_LIST_PATH. Error: $_"
    exit 1
}

# Create a new organizational unit to hold the new users. e.g. "NewUsersOU"
try {
    New-ADOrganizationalUnit -Name NewUsersOU -Path "OU=departments,DC=mydomain,DC=com" -ProtectedFromAccidentalDeletion $false
} catch {
    Log-Error "Failed to create organizational unit 'NewUsersOU'. Error: $_"
    exit 1
}

foreach ($n in $NAME_LIST) {
    try {
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
                   -Path "OU=NewUsersOU,OU=departments,DC=mydomain,DC=com" `
                   -Enabled $true
    } catch {
        Log-Error "Failed to create user for name: $n. Error: $_"
        continue
    }
}

Write-Host "User creation process completed." -BackgroundColor Black -ForegroundColor Green
