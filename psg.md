# PermissionSetGroup

- Remove PermissionSets with ```force__``` prefix/namespace in the PermissionSetGroups files

- In the terminal go to permissionsets folder

## macOS
- Remove
```
find . -type f -print0 | xargs -0   sed -i ""   "s/<permissionSets>force__.*<\/permissionSets>//g"

```

- Comment them out
```
find . -type f -print0 | xargs -0     sed -i "" "s/\(<permissionSets>\)\(force__.*\)\(<\/permissionSets>\)/<\!-- <\1\2\3 -->/"


```
---

## Linux
- Remove
```
find . -type f -print0 | xargs -0   sed -i    "s/<permissionSets>force__.*<\/permissionSets>//g"

```
- Comment them out
```
find . -type f -print0 | xargs -0     sed -i  "s/\(<permissionSets>\)\(force__.*\)\(<\/permissionSets>\)/<\!-- <\1\2\3 -->/"

```

