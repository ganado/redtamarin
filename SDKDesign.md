## Introduction ##

This is the design document for the RedTamarin Software Development Kit.

We follow the logic of the Flex SDK and the AIR SDK and make it our own
for the specific needs of building command line tools in AS3.

This SDK does not need to merge with any other Flex or AIR SDK.

This SDK is meant to run cross platform on Windows, Mac OS X and Linux.

This SDK does not depend on 3rd party distribution or package management tools like: Cygwin, Macports, AptGet, etc.


## Why a SDK ? ##

For a Flash developer, it is relatively easy to setup an IDE, and compile SWF and AIR files.

But when it come to compile ABC files using only [ASC} or [ASC2](ASC2.md) it can
become complicated to setup your IDE, deal with dependencies, multiple ABC libraries, etc.

In order to reduce as much as possible the "barrier to entry" we felt we needed a SDK,
simply put a set of files and tools that help to simplify and automate common tasks.


## Distributing the SDK ##

We will simply use a **zip** file to distribute the SDK.

We could make an installer (reusing redshell) or like the Apache Flex SDK make an AIR application to install the SDK but a zip file is simpler for a first start.

The only thing we will impose on this zip file is to reflect the version of the SDK

```
redtamarin-0.4.0.zip
redtamarin-0.4.0-1R00.zip
redtamarin-0.4.0-2R00.zip
redtamarin-0.4.1.zip
```


## Installing the SDK ##

Once the zip file is unzipped a single script should be able to install the SDK on the system.

Because we include all the different version of **redshell** within the zip we can rely on the redshell runtime to install this SDK.


for Windows
```
C:/> install_win.bat
```

for Mac OS X
```
$ install_mac.sh
```

for Linux
```
$ install_nix.sh
```

The installer is responsible to
  * create Environment variables
  * generate default executable for various tools
  * extract the documentation

## Files and folders structure ##

```
.
├── bin
│   ├── as3distro
│   ├── redbean
│   └── redshell
├── lib
│   └── asc.jar
├── lib-abc
│   └── redtamarin.abc
├── lib-swc
│   └── redtamarin.swc
├── runtimes
│   └── redshell
│       └── 32
│           ├── nix
│           │   ├── redshell
│           │   ├── redshell_d
│           │   └── redshell_dd
│           ├── mac
│           │   ├── redshell
│           │   ├── redshell_d
│           │   └── redshell_dd
│           └── win
│               ├── redshell.exe
│               ├── redshell_d.exe
│               └── redshell_dd.exe
└── tools
    ├── as3distro.abc
    └── redbean.abc
```

**notes**:
  * `/bin/redshell` is a copy of `/runtimes/redshell/32/mac/redshell` (or any other options)
  * `/bin/redshell` can be changed depending on your preferences
  * `redbean` will use the `redshell` from the path `/runtimes/redshell/...` not from `/bin/redshell`
  * `/tools` only store ABC files to generate EXE into `/bin`

## Platform Names ##

based on redtamarin `/src/platform` our platform names should be
  * **mac** for Mac OS X
    * replace **osx** that we were using before
    * for special case we can have **mac105** for OS X 10.5
  * **unix** for Linux
    * we will fall back to **nix** to keep 3 letters
  * **win32** for Windows
    * we will fall back to **win** to not confuse 32-bit and 64-bit

**API NOTE**
  * `Runtime.platform` should be available before `OperatingSystem.name` or any other
  * `Runtime.platform` should return "nix" or "mac" or "win"

## Environment Variables ##

**REDTAMARIN\_HOME** : the home (root) folder where the RedTamarin SDK is installed

**REDTAMARIN\_OPTS** : redtamarin default options
  * in fact global system options for **redshell**, could also be **REDSHELL\_OPTS**
  * ex: `REDTAMARIN_OPTS = "-swfversion 9 -api FP_9_0"`

**REDTAMARIN\_CONF** : the path of the redtamarin configuration file
  * win: `REDTAMARIN_CONF = "%APPDATA%\redtamarin\config.txt"`
  * mac: `REDTAMARIN_CONF = "~/.redtamarin/config"`
  * nix: `REDTAMARIN_CONF = "~/.redtamarin/config"`

**REDTAMARIN\_PATH** : allow to augment the default search path for library files (optional)

see:
  * http://docs.python.org/2/using/cmdline.html#environment-variables
  * http://www.mono-project.com/FAQ:_Technical
  * http://en.wikipedia.org/wiki/Environment_variable
  * http://en.wikipedia.org/wiki/Special_Folders

### ENV VARS under Windows ###

we should be able to use **setx.exe**

need to test if the tool is available under Windows XP, 2000, etc..

see:
  * http://stackoverflow.com/questions/3803581/setting-a-system-environment-variable-from-a-windows-batch-file
  * http://ss64.com/nt/setx.html


### ENV VARS under Macintosh and Linux ###

Both Mac and Linux should follow the same logic for env vars.

we should detect the following files in order
  * `~/.bashrc `
  * `~/.bash_profile`
  * `~/.bash_login`
  * `~/.profile`

depending on which file exists we should modify it

if no default file exists we should create `~/.profile`

never use the system wide `/etc/profile` or `/etc/environment`

see:
  * https://help.ubuntu.com/community/EnvironmentVariables
  * http://stackoverflow.com/questions/7501678/set-environment-variables-on-mac-os-x-lion