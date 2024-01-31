// Query all Permission Set Groups in the org
List<PermissionSetGroup> allPermissionSetGroups = [SELECT Id, Name
                                                   FROM PermissionSetGroup];

// Display Permission Set Groups and their associated Permission Sets with names and permissions
System.debug('List of Permission Set Groups and their associated Permission Sets with permissions:');
for (PermissionSetGroup group : allPermissionSetGroups) {
    System.debug('Permission Set Group Id: ' + group.Id + ', Name: ' + group.Name);

    // Query Permission Set Group Members to get associated Permission Sets with names
    List<PermissionSetGroupMember> groupMembers = [SELECT PermissionSetId, PermissionSet.Name
                                                   FROM PermissionSetGroupMember
                                                   WHERE PermissionSetGroupId = :group.Id];

    // Display Permission Sets in the group with names and permissions
    for (PermissionSetGroupMember member : groupMembers) {
        System.debug('  - Permission Set Id: ' + member.PermissionSetId + ', Name: ' + member.PermissionSet.Name);

        // Query Permission Set Permissions to get the list of permissions in the set
        List<PermissionSetPermission> permissions = [SELECT PermissionsRead, PermissionsEdit, PermissionsCreate, PermissionsDelete
                                                     FROM PermissionSetPermission
                                                     WHERE Parent.PermissionSetId = :member.PermissionSetId];

        // Display the list of permissions
        System.debug('    Permissions:');
        for (PermissionSetPermission permission : permissions) {
            System.debug('      Read: ' + permission.PermissionsRead + ', Edit: ' + permission.PermissionsEdit + ', Create: ' + permission.PermissionsCreate + ', Delete: ' + permission.PermissionsDelete);
        }
    }
}
