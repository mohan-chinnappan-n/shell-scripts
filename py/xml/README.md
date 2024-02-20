# How to combine 2 package.xml files

```bash
# get the script
curl -O https://raw.githubusercontent.com/mohan-chinnappan-n/shell-scripts/master/py/xml/combine_xml.py 
```

## First package.xml
- [Use package.xml generator tool](https://mohan-chinnappan-n5.github.io/pkg/pkg-gen.html)

- package1.xml


```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <version>56.0</version>

<types>
	<members>Green</members>
	<members>Blue</members>
	<name>ApexClass</name>
</types>

</Package>
```

- package2.xml


```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <version>56.0</version>

<types>
	<members>Green</members>
	<members>Blue</members>
	<name>ApexClass</name>
</types>


<types>
	<members>Greeness</members>
	<members></members>
	<name>CustomObject</name>
</types>

```
