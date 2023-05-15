# Package.xml cleanup

- Remove items with items like: engine.d ids.d  


- In the terminal go to the folder with package.xml

## macOS


- Comment them out
```
find . -type f -print0 | xargs -0     sed -i "" "s/\(<members>\)\(engine.d\)\(<\/members>\)/<\!-- \1\2\3 -->/"
find . -type f -print0 | xargs -0     sed -i "" "s/\(<members>\)\(ids.d\)\(<\/members>\)/<\!-- \1\2\3 -->/"



```
---

## Linux

```
- Comment them out

find . -type f -print0 | xargs -0     sed  "s/\(<members>\)\(engine.d\)\(<\/members>\)/<\!-- \1\2\3 -->/"
find . -type f -print0 | xargs -0     sed  "s/\(<members>\)\(ids.d\)\(<\/members>\)/<\!-- \1\2\3 -->/"



