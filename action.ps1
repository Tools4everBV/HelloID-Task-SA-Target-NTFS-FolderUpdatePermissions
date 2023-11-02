# HelloID-Task-SA-Target-NTFS-FolderUpdatePermissions
#####################################################
# Form mapping
$formObject = @{
    DisplayName      = $form.DisplayName
    Identity         = $form.Identity
    Path             = $form.Path
    FileSystemRights = $form.FileSystemRights
    Type             = $form.Type
}
try {
    Write-Information "Executing NTFS action: [FolderUpdatePermissions] for: [$($formObject.Path), $($formObject.DisplayName), $($formObject.FileSystemRights), $($formObject.Type)]"

    if (-not [System.IO.Directory]::Exists($formObject.Path)) {
        throw "Path [$($formObject.Path)] does not exits"
    }

    $ACL = Get-Acl -Path $formObject.Path
    $accessRule = [System.Security.AccessControl.FileSystemAccessRule]::new($formObject.Identity, $formObject.FileSystemRights, "ContainerInherit, ObjectInherit", "None", $formObject.Type)
    $ACL.SetAccessRuleProtection($false, $false)
    $ACL.SetAccessRule($accessRule)

    # # Code example of removing an existing rule.
    # $AclToRemove = $ACL.access | Where-Object { $_.IdentityReference -eq $formObject.Identity -and $_.AccessControlType -eq $formObject.Type }
    # $null = $ACL.RemoveAccessRule( $AclToRemove)

    $ACL | Set-Acl -Path $formObject.Path -ErrorAction Stop

    $auditLog = @{
        Action            = 'UpdateResource'
        System            = 'NTFS'
        TargetIdentifier  = $formObject.Path
        TargetDisplayName = $formObject.Path
        Message           = "NTFS action: [FolderUpdatePermissions] for: [$($formObject.Path), $($formObject.DisplayName), $($formObject.FileSystemRights), $($formObject.Type)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Information "NTFS action: [FolderUpdatePermissions] for: [$($formObject.Path), $($formObject.DisplayName), $($formObject.FileSystemRights), $($formObject.Type)] executed successfully"
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'UpdateResource'
        System            = 'NTFS'
        TargetIdentifier  = $formObject.Path
        TargetDisplayName = $formObject.Path
        Message           = "Could not execute NTFS action: [FolderUpdatePermissions] for: [$($formObject.Path), $($formObject.DisplayName), $($formObject.FileSystemRights), $($formObject.Type)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Error "Could not execute NTFS action: [FolderUpdatePermissions] for: [$($formObject.Path), $($formObject.DisplayName), $($formObject.FileSystemRights), $($formObject.Type)], error: $($ex.Exception.Message)"
}
#####################################################
