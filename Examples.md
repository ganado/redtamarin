| **important:** this project is under heavy changes, consider this wiki page obsolete |
|:-------------------------------------------------------------------------------------|

## Introduction ##

Here you'll find some small code snippet to illustrate the use of redtamarin libraries.

The first goal of redtamarin is to allow people to use C functions from ActionScript

if in C you got
```
#include <stdlib.h>

char *home = getenv("HOME");

```

then in ActionScript you can do
```
import C.stdlib.*;

var home:String = getenv("HOME");

```


for people coming from C/C++, they should find the same function
they are used to (they can also check [AS3 language 101 for C/C++ coders](http://blogs.adobe.com/kiwi/2006/05/as3_language_101_for_cc_coders_1.html)).

for people coming from AS3, like me, they can have more system access
and have more fun.

The second goal of redtamarin is to add native objects like pipes, sockets, etc.
(more to come about that later)


## basic stuff ##

```
import avmplus.System;
import redtamarin.version;
trace( "hello world" );
trace( "avmplus v" + System.getAvmplusVersion() );
trace( "redtamarin v" + redtamarin.version );
```

technically I just added `(redshell)` to the avmplus version
as I don't change the VM itself but just add more functionalities.

the `redtamarin.version` is here so you can identify the API version,
which I should document in changes document soon.


## stdlib ##

system - Execute an external command.
```
import C.stdlib.system;
import avmplus.File;

var filename:String = "list.txt";

system( "ls > " + filename );

if( File.exists( filename ) )
    {
    trace( "-- " + filename + " --" );
    trace( File.read( filename ) );
    }
else
    {
    trace( filename + " not found" );
    }
```

setenv/getenv - Set/Retrieve an environment variable.
```
import C.stdlib.*;

trace( "FOOBAR: " + getenv("FOOBAR") );
setenv( "FOOBAR", "/foo/bar" );
trace( "FOOBAR: " + getenv("FOOBAR") );
```


## unistd ##

access - Determine accessibility of file.
```
import C.stdlib.system;
import C.unistd.*;

import avmplus.File;

var filename:String = "list.txt";

system( "ls > " + filename );

if( File.exists( filename ) )
    {
    trace( "-- " + filename + " --" );
    trace( "exists:     " + (access( filename, F_OK )==0?true:false) );
    trace( "can read:   " + (access( filename, R_OK )==0?true:false) );
    trace( "can write:  " + (access( filename, W_OK )==0?true:false) );
    }
else
    {
    trace( filename + " not found" );
    }
```

chdir - Change working directory.
```
import C.unistd.chdir;
import C.unistd.getcwd;

trace( "current working directory: " + getcwd() );
chdir( "/" );
trace( "current working directory: " + getcwd() );
```

sleep - Suspend execution for an interval of time.
```
import C.unistd.sleep;

trace( "sleep 5sec..." );
sleep( 5 ); //in seconds
trace( "...and wake up" );
```


getcwd - Get the pathname of the current working directory.
```
import C.unistd.getcwd;

trace( "current working directory: " + getcwd() );
```

gethostname - Get name of current host
```
import C.unistd.gethostname;

trace( "hostname: " + gethostname() );
```