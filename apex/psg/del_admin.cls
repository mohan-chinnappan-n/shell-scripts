// Query all users with the Delegated Administrator permission
List<User> delegatedAdminUsers = [
    SELECT Id, Name, UserPermissions
    FROM User
    WHERE UserPermissions.DelegatedAdministrator = true
];

// Display the user details
System.debug('Users with Delegated Administrator permission:');
for (User user : delegatedAdminUsers) {
    System.debug('User Id: ' + user.Id + ', Name: ' + user.Name);
}

