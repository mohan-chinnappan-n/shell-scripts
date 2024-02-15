
/*
----------------------------------------------------------------------------------------------
 Apex anon script to active the users in the given list of Permission set Groups (PSG)
 
 author: mohan chinnappan

 run:

 sf mohanc tooling execute -u username -a activate_users_psg.cls
----------------------------------------------------------------------------------------------
*/

// fill in your psgs here:
 List<String> permissionSetGroupNames = new List<String>{'One_PSG', 'Two_PSG'};

 for (String psg : permissionSetGroupNames) {

    // Query PermissionSetAssignment to get users assigned to the specified permission set
    List<PermissionSetAssignment> permissionSetAssignments = [
        SELECT AssigneeId
        FROM PermissionSetAssignment
        WHERE PermissionSet.Name = :psg
    ];
    // Extract User Ids from PermissionSetAssignment records
    Set<Id> userIds = new Set<Id>();
    for (PermissionSetAssignment psa : permissionSetAssignments) {
        userIds.add(psa.AssigneeId);
    }

    // Query User object to get user details
    List<User> userList = new List<User>();
    if (!userIds.isEmpty()) {
        userList = [SELECT Id, Name, Email, IsActive
                    FROM User
                    WHERE Id IN :userIds AND
                    IsActive = false
                    ];
    }

    // Display the user details
    System.debug('Users assigned to permission set ' + psg + ':');
    for (User user : userList) {
        System.debug('User Id: ' + user.Id + ', Name: ' + user.Name + ', Email: ' + user.Email +  ', active: ' + user.IsActive  );
        user.IsActive = true;
    }
    update userlist; // bulkified
 }