# PermissionSetGroup

- Remove PermissionSets with ```force__``` prefix/namespace in the PermissionSetGroups files

- In the terminal go to permissionsets folder

- macOS
```
find . -type f -print0 | xargs -0   sed -i ""   "s/<permissionSets>force__.*<\/permissionSets>//g"

```

- Linux
```
find . -type f -print0 | xargs -0   sed -i    "s/<permissionSets>force__.*<\/permissionSets>//g"

```
