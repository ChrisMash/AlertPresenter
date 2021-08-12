fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### unitTests
```
fastlane unitTests
```
Runs Unit tests and checks code coverage
### uiTests
```
fastlane uiTests
```
Runs specific set of UI tests
### allUITests
```
fastlane allUITests
```
Runs UI tests across all schemes, platforms and multiple OS versions
### checkDocs
```
fastlane checkDocs
```
Runs check for undocumented public APIs
### lint
```
fastlane lint
```
Runs linter to check for warnings
### allTests
```
fastlane allTests
```
Runs all tests

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
