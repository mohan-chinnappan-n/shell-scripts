// Query all Permission Set Groups in the org
List<PermissionSetGroup> allPermissionSetGroups = [SELECT Id, Name
                                                   FROM PermissionSetGroup];

// Display Permission Set Groups and their associated Permission Sets with names
System.debug('List of Permission Set Groups and their associated Permission Sets:');
for (PermissionSetGroup group : allPermissionSetGroups) {
    System.debug('Permission Set Group Id: ' + group.Id + ', Name: ' + group.Name);

    // Query Permission Set Group Members to get associated Permission Sets with names
    List<PermissionSetGroupMember> groupMembers = [SELECT PermissionSetId, PermissionSet.Name
                                                   FROM PermissionSetGroupMember
                                                   WHERE PermissionSetGroupId = :group.Id];

    // Display Permission Sets in the group with names
    for (PermissionSetGroupMember member : groupMembers) {
        System.debug('  - Permission Set Id: ' + member.PermissionSetId + ', Name: ' + member.PermissionSet.Name);
    }
}
