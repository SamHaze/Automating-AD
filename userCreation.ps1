#Program Name: userCreation.ps1
#Purpose: This script parses through a list of names, firstname then lastname, and creates an Active Directory user account with each name. 

# Edit These Variables In Your Own Script
# ------------------------------------------------------------------------- #
$PASSWORD_FOR_USERS = "P@ssw0rd"
$NAME_LIST = Get-Content -Path "C:\Users\$env:username\Desktop\New_Users.txt"
# ------------------------------------------------------------------------- #

#Convert the password for users to a string
$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

#Create a new organizational unit to hold the new users. I will name mine "NewUsersOU"
New-ADOrganizationalUnit -Name NewUsersOU -Path "OU=departments,DC=mydomain,DC=com" -ProtectedFromAccidentalDeletion $false

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
               -Path "OU=NewUsersOU,OU=departments,DC=mydomain,DC=com" `
               -Enabled $true
}
