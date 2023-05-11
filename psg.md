# PermissionSetGroup
- Remove PermissionSets with ```force__``` prefix/namespace in the PermissionSetGroups files
- macOS
```
find . -type f -print0 | xargs -0   sed -i ""   "s/<permissionSets>force__.*<\/permissionSets>//g"

```

- Linux
```
find . -type f -print0 | xargs -0   sed -i    "s/<permissionSets>force__.*<\/permissionSets>//g"

```
