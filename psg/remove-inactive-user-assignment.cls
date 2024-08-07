//------------------------------------------------------------------
// Script to remove inactive user assignments in a given list of PSGs
// author: mohan chinnappan
//------------------------------------------------------------------

// Input: List of Permission Set Group Developer Names
List<String> permissionSetGroupDeveloperNames = new List<String>{
    'Permission_Set_Group_1',
    'Permission_Set_Group_2',
    'Permission_Set_Group_3'
};

// Fetch the Permission Set Groups
// example:     SELECT Id, DeveloperName FROM PermissionSetGroup WHERE DeveloperName IN ('Permission_Set_Group_1'. 'Permission_Set_Group_2') 
List<PermissionSetGroup> permissionSetGroups = [
    SELECT Id, DeveloperName 
    FROM PermissionSetGroup 
    WHERE DeveloperName IN :permissionSetGroupDeveloperNames
];

// Create a Set to hold the Permission Set Group IDs
Set<Id> psgIds = new Set<Id>();
for (PermissionSetGroup psg : permissionSetGroups) {
    psgIds.add(psg.Id);
}

// Query the Permission Set Group Assignments
List<PermissionSetAssignment> assignmentsToRemove = [
    SELECT Id, AssigneeId, PermissionSetGroupId 
    FROM PermissionSetAssignment 
    WHERE PermissionSetGroupId IN :psgIds
];

// Create a Set to identify inactive users
Set<Id> inactiveUserIds = new Set<Id>();

// Query all inactive users
List<User> inactiveUsers = [SELECT Id FROM User WHERE IsActive = false];
for (User user : inactiveUsers) {
    inactiveUserIds.add(user.Id);
}

// Collect assignments for inactive users
List<PermissionSetAssignment> assignmentsToDelete = new List<PermissionSetAssignment>();
for (PermissionSetAssignment assignment : assignmentsToRemove) {
    if (inactiveUserIds.contains(assignment.AssigneeId)) {
        assignmentsToDelete.add(assignment);
    }
}

// Delete assignments for inactive users
if (!assignmentsToDelete.isEmpty()) {
    delete assignmentsToDelete;
    System.debug('Deleted ' + assignmentsToDelete.size() + ' permission set assignments.');
} else {
    System.debug('No assignments to delete for inactive users.');
}
