// List of PermissionSetGroup Names
List<String> permissionSetGroupNames = new List<String>{'PermissionSetGroup1', 'PermissionSetGroup2', 'PermissionSetGroup3'};

// Query for PermissionSetGroups and their assignments
List<PermissionSetGroup> permissionSetGroups = [SELECT Id, DeveloperName, (SELECT AssigneeId, Assignee.Name, Assignee.IsActive FROM PermissionSetGroupAssignments) FROM PermissionSetGroup WHERE DeveloperName IN :permissionSetGroupNames];

// Iterate through each PermissionSetGroup
for (PermissionSetGroup group : permissionSetGroups) {
    System.debug('Permission Set Group: ' + group.DeveloperName);
    
    // Iterate through each assignment
    for (PermissionSetGroupAssignment assignment : group.PermissionSetGroupAssignments) {
        // Check if the user is not active
        if (!assignment.Assignee.IsActive) {
            // Activate the user
            assignment.Assignee.IsActive = true;
            
            // Update the user
            try {
                update assignment.Assignee;
                System.debug('User ' + assignment.Assignee.Name + ' activated successfully.');
            } catch (Exception e) {
                System.debug('Error activating user ' + assignment.Assignee.Name + ': ' + e.getMessage());
            }
        } else {
            System.debug('User ' + assignment.Assignee.Name + ' is already active.');
        }
    }
}
