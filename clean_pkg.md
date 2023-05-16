# Package.xml cleanup

- Remove items with items like: engine.d lds.d  


- In the terminal go to the folder with package.xml

## macOS


- Comment them out
```
PAT='engine.d'; find . -type f -print0 | xargs -0     sed -i "" "s/\(<members>\)\($PAT\)\(<\/members>\)/<\!-- \1\2\3 -->/"
PAT='lds.d'; find . -type f -print0 | xargs -0     sed -i "" "s/\(<members>\)\($PAT\)\(<\/members>\)/<\!-- \1\2\3 -->/"


```
---

## Linux

- Comment them out

```

PAT='engine.d'; find . -type f -print0 | xargs -0     sed -i "" "s/\(<members>\)\($PAT\)\(<\/members>\)/<\!-- \1\2\3 -->/"
PAT='lds.d'; find . -type f -print0 | xargs -0     sed -i "" "s/\(<members>\)\($PAT\)\(<\/members>\)/<\!-- \1\2\3 -->/"


```

- Comment the entire tag 
```
# TAG='div'; find . -type f -print0 | xargs -0  sed -i "s|<$TAG>|<!--&|; s|</$TAG>|&-->|" 

```

