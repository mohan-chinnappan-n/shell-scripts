// Replace 'YourPermissionSetName' with the actual name of the permission set
String permissionSetName = 'YourPermissionSetName';

// Query PermissionSetAssignment to get users assigned to the specified permission set
List<PermissionSetAssignment> permissionSetAssignments = [
    SELECT AssigneeId
    FROM PermissionSetAssignment
    WHERE PermissionSet.Name = :permissionSetName
];

// Extract User Ids from PermissionSetAssignment records
Set<Id> userIds = new Set<Id>();
for (PermissionSetAssignment psa : permissionSetAssignments) {
    userIds.add(psa.AssigneeId);
}

// Query User object to get user details
List<User> userList = new List<User>();
if (!userIds.isEmpty()) {
    userList = [SELECT Id, Name, Email
                FROM User
                WHERE Id IN :userIds];
}

// Display the user details
System.debug('Users assigned to permission set ' + permissionSetName + ':');
for (User user : userList) {
    System.debug('User Id: ' + user.Id + ', Name: ' + user.Name + ', Email: ' + user.Email);
}
