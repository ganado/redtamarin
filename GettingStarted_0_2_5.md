## redtamarin v0.2.5 ##

download this zip (see [downloads](http://code.google.com/p/redtamarin/downloads/list) tab), and unzip it, you should get

```
..
 |_ red_v0.1.0.100  <- version of redshell
      |_ bin
      |   |_ asc.jar
      |   |_ redshell     <- mac executable
      |   |_ redshell.exe <- win32 executable
      |   |_ redshell.nix <- linux executable
      |   |_ builtin.abc
      |   |_ toplevel.abc
      |_ buildAndRun.bat  <- for Windows
      |_ buildAndRun.sh   <- for OS X / Linux
      |_ buildEXE.bat     <- for Windows
      |_ buildEXE.sh      <- for OS X / Linux


```

write some code in `test.as`
```
import avmplus.System;
import avmplus.redtamarin;

trace( "hello world" );

trace( "avmplus v" + System.getAvmplusVersion() );
trace( "redtamarin v" + redtamarin.version );

```

and then build it and run it

on OS X and Linux
```
$ ./buildAndRun.sh test.as
```

on Windows
```
c:\> buildAndRun.bat test.as
```

both will output
```
test.abc, 123 bytes written
hello world
avmplus v1.0 cyclone
redtamarin v0.1.0.100
```

the `buildAndRun` just build an `*.abc` using asc.jar
then run it with the redshell executable

when you're happy with your tests,
you can then build both an OS X, Linux and Windows executable using `buildEXE` scripts

on OS X / Linux
```
$ ./buildEXE.sh test.as
```

on Windows
```
c:\> buildEXE.bat test.as
```

`test` will be the executable for OS X / Linux
(if you generate it from Windows you will need to make it executable under OS X / Linux using `chmod +x test`)

`test.exe` will be the executable for Windows

those executables merge the **redshell** executable with the `*.abc` file
and so have no dependencies.