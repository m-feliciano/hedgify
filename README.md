# Useful PowerShell Scripts

## To learn more about PowerShell scripting, check out the following resources

- [Official Documentation](https://docs.microsoft.com/en-us/powershell/)

- [Mastering PowerShell Scripting - Fourth Edition](https://www.packtpub.com/product/mastering-powershell-scripting-fourth-edition/9781789536668)

- [Key-based authentication in OpenSSH for Windows](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)

### Initial Setup

```powershell
# Importing a module from a custom path, could be declared in the $PROFILE file
'C:\<custom path>\*' | Get-ChildItem -include '*.ps1' | Import-Module

# To set up a permanent env variable, use the following command (Don't ever use this for passwords)
[System.Environment]::SetEnvironmentVariable('NAME','user@ip', 'User');

# To get the value of an env variable
$env:NAME
```

### Copying a resource from a remote server (Copy-To-Remote.ps1)

```powershell
# Copying a file
Copy-From-Remote –Source E:\path\test.txt –Destination C:\path

# Copying a directory
Copy-From-Remote –Source E:\path\ –Destination .
```

### Copying a resource to a remote server (Copy-From-Remote.ps1)

```powershell
# Copying a file
Copy-To-Remote -Source C:\food\brazilian.zip -Destination E:\food\
```

### Searching for a command in the history (Find-History.ps1)

```powershell
Find-History -Pattern "Get-ChildItem*" -Limit 10
```
