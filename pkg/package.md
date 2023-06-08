# package.xml

- Remove members in package.xml  with ```force__``` 

- In the terminal go to the folder where **package.xml** is present


- Comment them out
```
find . -type f -print0 | xargs -0     sed -i ""  "s/\(<members>\)\(force__.*\)\(<\/members>\)/<\!-- \1\2\3 -->/"

```
---

## Linux

- Comment them out
```
find . -type f -print0 | xargs -0     sed -i   "s/\(<members>\)\(force__.*\)\(<\/members>\)/<\!-- \1\2\3 -->/"

```

