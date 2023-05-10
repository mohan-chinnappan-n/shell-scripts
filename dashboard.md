# Dashboard

## How to replace the runningUser in the given dashboard xml

## Topics

- [Using ENV variable](#env)
- [Hard-coded User](#hc)
- [Replace in all the files including files under the folders](#ipr)

---

- Input file
```
cat /tmp/db.xml
```

```xml
<Dashboard xmlns="http://soap.sforce.com/2006/04/metadata">
    <backgroundEndColor>#FFFFFF</backgroundEndColor>
    <backgroundFadeDirection>Diagonal</backgroundFadeDirection>
    <backgroundStartColor>#FFFFFF</backgroundStartColor>
    <chartTheme>light</chartTheme>
    <colorPalette>unity</colorPalette>
    <dashboardChartTheme>light</dashboardChartTheme>
    <dashboardColorPalette>unity</dashboardColorPalette>
    <!-- more items -->
   <isGridLayout>true</isGridLayout>
    <runningUser>USER1@email.com</runningUser>
    <textColor>#000000</textColor>
    <title>Vendor Intelligence</title>
    <titleColor>#000000</titleColor>
    <titleSize>12</titleSize>
</Dashboard>

```
---
### Using ENV variable
<a name='env'></a>
```bash
USER='ken@email.com'; cat /tmp/db.xml | sed "s/\(<runningUser>\)\(.*\)\(<\/runningUser>\)/\1${USER}\3/"
```
```xml
<Dashboard xmlns="http://soap.sforce.com/2006/04/metadata">
    <backgroundEndColor>#FFFFFF</backgroundEndColor>
    <backgroundFadeDirection>Diagonal</backgroundFadeDirection>
    <backgroundStartColor>#FFFFFF</backgroundStartColor>
    <chartTheme>light</chartTheme>
    <colorPalette>unity</colorPalette>
    <dashboardChartTheme>light</dashboardChartTheme>
    <dashboardColorPalette>unity</dashboardColorPalette>
    <!-- more items -->
   <isGridLayout>true</isGridLayout>
    <runningUser>ken@email.com</runningUser>
    <textColor>#000000</textColor>
    <title>Vendor Intelligence</title>
    <titleColor>#000000</titleColor>
    <titleSize>12</titleSize>
</Dashboard>

```
---


### Hard-coded User (dennis@email.com) 

<a name='hc'></a>

```bash
cat /tmp/db.xml | sed 's/\(<runningUser>\)\(.*\)\(<\/runningUser>\)/\1dennis@email.com\3/'
```
```xml
<Dashboard xmlns="http://soap.sforce.com/2006/04/metadata">
    <backgroundEndColor>#FFFFFF</backgroundEndColor>
    <backgroundFadeDirection>Diagonal</backgroundFadeDirection>
    <backgroundStartColor>#FFFFFF</backgroundStartColor>
    <chartTheme>light</chartTheme>
    <colorPalette>unity</colorPalette>
    <dashboardChartTheme>light</dashboardChartTheme>
    <dashboardColorPalette>unity</dashboardColorPalette>
    <!-- more items -->
   <isGridLayout>true</isGridLayout>
    <runningUser>dennis@email.com</runningUser>
    <textColor>#000000</textColor>
    <title>Vendor Intelligence</title>
    <titleColor>#000000</titleColor>
    <titleSize>12</titleSize>
</Dashboard>

```

---
<a name='ipr'></a>
### Replace in all the files including files under the folders

- on macOS
```bash
USER='ken@email.com'; find . -type f -print0 | xargs -0   sed -i ""  "s/\(<runningUser>\)\(.*\)\(<\/runningUser>\)/\1${USER}\3/"

```

- on Linux 
```bash
USER='ken@email.com'; find . -type f -print0 | xargs -0   sed -i   "s/\(<runningUser>\)\(.*\)\(<\/runningUser>\)/\1${USER}\3/"

```
