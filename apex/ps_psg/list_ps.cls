// Query all Permission Sets in the org
List<PermissionSet> allPermissionSets = [SELECT Id, Name FROM PermissionSet];

// Display the Permission Set details
System.debug('List of Permission Sets in the org:');
for (PermissionSet permissionSet : allPermissionSets) {
    System.debug('Permission Set Id: ' + permissionSet.Id + ', Name: ' + permissionSet.Name);
}