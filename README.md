
# HelloID-Task-SA-Target-NTFS-FolderUpdatePermissions

## Prerequisites
- HelloID Directory Agent
- The HelloID Service account requires the following permissions:
  - Write Access on the folder ([NTFS permissions](https://docs.microsoft.com/en-us/iis/web-hosting/configuring-servers-in-the-windows-web-platform/configuring-share-and-ntfs-permissions#:~:text=To%20configure%20permissions%20for%20the%20folder%20structuree), so not Share permissions on the Share).
  - When applicable Write Access on the folder/share itself ([Share permissions](https://docs.microsoft.com/en-us/iis/web-hosting/configuring-servers-in-the-windows-web-platform/configuring-share-and-ntfs-permissions#:~:text=To%20configure%20permissions%20for%20the%20share), not NTFS permissions on the folder(s)).
- Some knowledge of NTFS file permissions



## Description
Managing permissions (ACL) for NTFS folders can be quite extensive, and the possibilities are very widespread. It is mostly recommended to use only Basic Permissions ['FullControl', 'Modify', 'ReadandExecute', 'Read', 'Write']. In addition to the ACL, you also need to take note of inheritance. The snippet uses the defaults when you set permissions in the UI, which is sufficient in most cases. More information can be found on the Microsoft docs: [Set-ACL-Cmlet](https://learn.microsoft.com/nl-nl/powershell/module/microsoft.powershell.security/set-acl?view=powershell-7.3),  [FileSystemAccessRule](https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=net-7.0) or [FileSystemRights Enum](https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemrights?view=net-7.0)

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties of the `Set-ACL` cmdlet, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "DisplayName": "Sales Department",
    "Identity": "Sales Department",
    "FileSystemRights": ["Read", "Write"],
    "Path": "\\\\contoso.local\\Storage\\Projects\\Sales",
    "Type": "Allow"
  }
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields. More about the cmdlet `Set-Acl` [See the Microsoft Docs page](https://learn.microsoft.com/nl-nl/powershell/module/microsoft.powershell.security/set-acl?view=powershell-7.3)

2. Verify if the provided parent folder exists

3. Calls the Set-Acl CmdLet to update the NTFS folder permissions
