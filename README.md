Awake
===
![Code size](https://img.shields.io/github/languages/code-size/tr1ckyf0x/wakeonlan-ios) ![GitHub commit activity](https://img.shields.io/github/commit-activity/m/tr1ckyf0x/wakeonlan-ios) ![GitHub contributors](https://img.shields.io/github/contributors/tr1ckyf0x/wakeonlan-ios)

## Required tools
:mega:
**All tools are supposed to be installed system-wide.**
1. [XcodeGen](https://github.com/yonaskolb/XcodeGen)
2. [SwiftGen](https://github.com/SwiftGen/SwiftGen)
3. [SwiftLint](https://github.com/realm/SwiftLint)
4. [git-secret](https://git-secret.io) *(optionally, only if you have an access to secrets)*

## Build instructions
* #### Reveal secrets *(only for maintainers)*
```bash
git secret reveal
```

* #### Change the bundle identifier and code signing options in the `project.yml` *(optionally, if you do not have an access to secrets)*

* #### Generate project
Invoke the command in the project root
```bash
xcodegen generate
```
or use the script
```bash
generate_project.sh
```
Autogenerated files will be created before generating a project file.

* #### Open the generated `Wake on LAN.xcodeproj` and build the scheme `Wake on LAN`

## GPG key generation for git-secret *(only for maintainers)*

`gpg --full-generate-key`

```
Kind of key: RSA and RSA
Keysize: 4096
Key lifetime: 1 year
```

`gpg --armor --export your.email@address.com > public-key.gpg`

Send key to one of maintainers.