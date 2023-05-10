# JEST scripts


## Topics

- [Running Test coverage](#coverage)
- [Finding fake asserts](#fakefinder)

----
<a name='coverage'></a>


## Running JEST coverage

- Change to the sfdx project folder - folder with 	sfdx-project.json
    


```
yarn add -D @salesforce/sfdx-lwc-jest@spring22

```


## Run the test coverage

```
yarn run jest --coverage
```

```
yarn run v1.22.19
warning ../../package.json: No license field
$ /Users/mchinnappan/jest/testing1/node_modules/.bin/jest --coverage
Browserslist: caniuse-lite is outdated. Please run:
  npx browserslist@latest --update-db
  Why you should do it regularly: https://github.com/browserslist/browserslist#browsers-data-updating
 PASS  ./functions.test.js
  ✓ add  2 and 2 to equal to 4  (3 ms)
  ✓ subtract  10 - 2 to equal to 8  (1 ms)

--------------|---------|----------|---------|---------|-------------------
File          | % Stmts | % Branch | % Funcs | % Lines | Uncovered Line #s
--------------|---------|----------|---------|---------|-------------------
All files     |     100 |      100 |     100 |     100 |
 functions.js |     100 |      100 |     100 |     100 |
--------------|---------|----------|---------|---------|-------------------
Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
Snapshots:   0 total
Time:        0.729 s, estimated 1 s
Ran all test suites.
✨  Done in 4.35s.

```

<a name='fakefinder'></a>

## Finding fake asserts ```expect(1).toBe(1)``` in JEST test files

- Change to **lwc** folder in 

```bash

grep -irn 'expect(1).toBe(1)' *

```

