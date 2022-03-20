![Ban russia](https://user-images.githubusercontent.com/3737076/157340096-9527a333-faab-47c0-9714-adb6725fb4b3.png)

# bearhunter

This tool is about to remove Russian footprint from your codebase. iOS community must push Russians to STOP WAR.

## Installation

### Homebrew
```shell
brew install aashvetsov/formulae/bearhunter
```

### Make

```shell
cd <bearhunter sourcecode folder>
git clone https://github.com/aashvetsov/bearhunter.git
make install
```

## Basic Usage

In case if your project uses Cocoapods - run the following commands before bearhuntercli usage

```shell
cd <sourcecode folder>
pod install --repo-update
```

For any other(s) dependency managers any extra steps are not required

```shell
bearhuntercli -p <sourcecode folder>
```
or
```shell
bearhuntercli --path <sourcecode folder>
```
