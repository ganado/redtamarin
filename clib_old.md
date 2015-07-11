## Introduction ##

From the beginning, redtamarin added a bit of support for C-like functions and packages.

We were calling that "a more or less standard C library" ;).

Now, as we want to do the right thing, we want to provide as much support as possible, put things at the right place and avoid shortcuts if possible.

The main principle still is the same

if you have this in **C**
```
//C
#include <stdlib.h>

//char *getenv( const char *name );
char *test = getenv("HOME");
```

then you can have this in **AS3**
```
//AS3
import C.stdlib.*;

//public function getenv( name:String ):String;
var test:String = getenv( "HOME" );
```

<br />
<br />
these are the main reasons to do that

  1. in general, C give you a low-level universal access to things<br />wether you know `chmod` on the command line or you used `mkdir()` in PHP, Python, etc.<br />you already used a bit of **C** somewhere.
  1. building uppon this kind of low-level you can build bigger things<br />in our case we will reuse `mkdir()` to define `FileSystem.makeDirectory()`<br />maybe you want to build your own API or do things a bit differently<br />if only you had access to `mkdir()`...well you have access!!
  1. A C library help to port to AS3 other kind of libraries,<br />either duplicate something you have seen done in Python or Ruby, etc<br />or easily port a C code example to AS3.
  1. Those C libraries are mainly functions and are easily portable and sharable<br />(we know from our experience with maashaack **core** package)
  1. it helps at the same time C developers coming to AS3<br />and AS3 developers learning/reusing C.

<br />
But let's be clear, we are not saying we giving you a way to compile C to AS3 (if you need that use ANE or CrossBridge).

No, what we are saying is that we give you a way to integrates "C style programming and functionalities" into your AS3 program.

It is not perfect and have limitations, but when you want to build things for the command line and the server side it can come very handy.

<br />

## What do we support exactly ? ##

We plan to support

The **C standard library**
  * **ANSI C** (C89)
  * **ISO C** (C90)

with those headers:
  * `<assert.h>`
  * `<ctype.h>`
  * `<errno.h>`
  * `<float.h>`
  * `<limits.h>`
  * `<locale.h>`
  * `<math.h>`
  * `<setjmp.h>`
  * `<signal.h>`
  * `<stdarg.h>`
  * `<stddef.h>`
  * `<stdio.h>`
  * `<stdlib.h>`
  * `<string.h>`
  * `<time.h>`

and

The **C POSIX Library**
  * **POSIX**.1

with those headers
  * `<cpio.h>`
  * `<dirent.h>`
  * `<fcntl.h>`
  * `<grp.h>`
  * `<netdb.h>`
  * `<pthread.h>`
  * `<pwd.h>`
  * `<spawn.h>`
  * `<sys/ipc.h>`
  * `<sys/mman.h>`
  * `<sys/msg.h>`
  * `<sys/sem.h>`
  * `<sys/stat.h>`
  * `<sys/time.h>`
  * `<sys/types.h>`
  * `<sys/utsname.h>`
  * `<sys/wait.h>`
  * `<tar.h>`
  * `<termios.h>`
  * `<unistd.h>`
  * `<utime.h>`

and some non-standard things

All that represent the **clib** or **The C Standard Library for AS3**.

<br />

We will unlikely support 100% of C, simply because things work differently in AS3, but in general we will make our best effort to have a library that make sens to use.

<br />

## Level of support ##

First, let's explain the basic.

This library is contained in the **C** package<br />
and is in favour of an AS3 syntax.

in **C**
```
#include <stdlib.h>
#include <sys/stat.h>
```

in  **AS3**
```
import C.stdlib.*;
import C.sys.stat.*;
```

<br />

Those C packages will mainly define
<br />

**constants** and/or **macros**

```
package C.errno
{
    /**
     * Argument list too long.
     *
     * @langversion 3.0
     * @playerversion AVM 0.4
     */
    public const E2BIG:int = 7;
}
```

in some cases hardcoded for a common behaviour


```
package C.limits
{
    /**
     * Maximum number of bytes the implementation will store as a pathname.
     *
     * @langversion 3.0
     * @playerversion AVM 0.4
     */
    [native("::avmshell::CLimitsClass::get_PATH_MAX")]
    public native function get PATH_MAX():int;
}
```

sometimes dynamically fetched from the current system

<br />

**functions**

```
package C.stdio
{
    /**
     * Rename a file.
     *
     * @langversion 3.0
     * @playerversion AVM 0.4
     */
    [native("::avmshell::CStdioClass::rename")]
    public native function rename( oldname:String, newname:String ):int;
}
```

that may or may not change the original C function signature

<br />

**classes**

```
package C.stdio
{
    /**
     * A structure containing information about a file.
     *
     * <p>
     * <b>FILE</b> is a type suitable for storing information for a file stream.
     * </p>
     *
     * @langversion 3.0
     * @playerversion AVM 0.4
     */
    [native(cls="::avmshell::CFILEClass", instance="::avmshell::CFILEObject", methods="auto")]
    public class FILE
    {
        //...
    }
}
```

used to replace **typedef** and/or **struct** so the C context can exchange **types** with the AS3 context

<br />

Here a usage example

if you have this in C
```
typedef FILE

typedef fpos_t

FILE *fopen(const char *filename, const char *mode);

int fgetpos(FILE *stream, fpos_t *pos);
```

you will use it like that in AS3
```
import C.errno.*;
import C.stdio.*;

var file:FILE = fopen( "foobar.txt", "w" );

var pos:fpos_t = new fpos_t();
var result:int = fgetpos( file, pos );

if( result != 0 )
{
    throw new CError( errno );
}
```

yep, it feels like C but it is still AS3.

<br />

Which lead us to our second more advanced part **what we will not support in general**.

Again, take it with a grain of salt, as said before it is unlikely we can have a 100% port of C into AS3.

See it as an API, we start with C signatures and we try to end up with AS3 signatures,
some times it make sens, some other time we have to improvise.

Here a small example:
```
//fgets - get a string from a stream
char *fgets(char *restrict s, int n, FILE *restrict stream);
```

ideally in AS3 we should end up with the same signature
```
function fgets( s:String, n:int, stream:FILE ):String;
```

but we ended up with
```
function fgets( n:int, stream:FILE ):String;
```

why ?<br />

the simple answer is C and AS3 doen't work with strings the same way

the longer answer is

in C you don't really have a string type per se, you have **char** type
```
char a = 'a';
```
this is only for one character

then you have **array of chars** (which is to be considered the "string" type)
```
char b[] = "hello world";
```

so strings in C are more of sequence of bytes terminated by NUL (`/0`)
and in fact you could write your string like that too
```
char c[] = { 'h', 'e', 'l', 'l', 'o', '\0' };
```

and finally you could also use pointers to write a string litteral
```
char *d = "world";
```

or write an array of strings
```
char *fruits[] = { "apple", "banana", "orange" };
```

Now with **fgets** we need to be able to allocate a char array when calling the function<br />
in C you would do
```
char s[100]; //allocate your string with 100 bytes
char *result; //pointer to get a string result

result = fgets(s, sizeof(s), stdin); // read 100 bytes from standard input
```

Let's read what **fgets** is supposed to do<br />
"The fgets() function shall read bytes from stream into the array pointed to by s, until n-1 bytes are read, or a `<newline>` is read and transferred to s, or an end-of-file condition is encountered. The string is then terminated with a null byte."

and as a return value<br />
"Upon successful completion, fgets() shall return s."

so, in C, our char array **s** is here to be able to write the data, and if all goes well we then return **s** into the pointer **result**,
so yeah **s** and **result** have the same value.

And this is why it is different in AS3.

First, we don't need to pass around a pointer to a char array to pre-allocate a string we want to return, we just return a damn string.<br />
Second, even if we wanted to do that, we can not really do that as our strings are passed by value and not by reference.
Third, what **fgets** really does at the API level ? read **n** length from a stream and return a string.

So, yeah, the **s** argument can simply go away as we don't need it<br />
in AS3 you would do
```
var result:String; //variable to get a string result

result = fgets( 100, stdin ); // read 100 bytes from standard input
```

that's one way to do it, we could have done different like this
```
var s:Array = new Array(100); //allocate an array of 100 entries
vr result:String; // variable for a string result;

result = fgets( s, s.length, stdin ); // read 100 bytes from standard input
```
then **result** will contain a string and **s** will contain one char per index, eg.
```
result = "hello";
s = [ "h", "e", "l", "l", "o" ];
```

but that would be overkill if not useless.

And this is for one simple argument in one simple basic function.


Here some special cases and why we will not support them or why we will do things in a particular way

**1. pointers**

We do not support pointers because AS3 does not have real pointers.

We sill support passing objects by reference when it make sens.

<br />

**2. NULL**

in AS3 we have `null`, in C we have `NULL`, we consider them interchangeable to some extend.

Some C function on success return a pointer or NULL on failure,
the AVM2 can return different types of null: nullAtom, nullStringAtom, etc.
and rarely use the C `NULL` but in our case returning `NULL` instead of `nullAtom` works better.

<br />

**3. vectors**

We will not support returning the AS3 Vector type, we will use the Array type.

<br />

**4. print**

In general we will not support print functions as `printf()`, technically we could but we would rather not.

In AS3 we have something called `trace()`, that's our `printf()`, it is less powerful, can not redirect on different streams
and whatnot other features but it's there and it is what we use.

SO for now we will not support all the variants of printf or printf itself, maybe an AS3 implementation of printf later
as a formatting function but that would be it.

Oh yeah, if we receive enough hate mails about why we don't support **printf** in a C standard library we may change our mind.

<br />

**5. threads**

TODO

<br />

**6. memory**

In AS3, within the AVM2, we don't really need to plan for memory use
so any function dealing with memory would be a dangerous duplicate of what the AVM is doing in the "background".

Simply put, we don't want to support memory allocation/deallocation/etc. because the AVM2 already does that for us.

<br />

<br />

The following will details which level of support we provide per header or package.


<font color='orange'><b>ANSI C (C89) / ISO C (C90)</b></font>

### `<assert.h>` ###
<font color='red'>not implemented</font>

Ideally we would like to support it but we are not sure yet how.

This header only define one function `assert()`<br />
when used and called in C, it allows to assert than expression is valid<br />
and if not, will return the expression used and the line number where it happen and then call `abort()`.

We can not use the native `assert()` call "as is", but we could try to replicate its functionalities<br />
eg. returning the AS3 line where the assert was not valid and the expression string<br />
and instead of calling `abort()` maybe interrupt the code like a `throw error` ?


### `<ctype.h>` ###
<font color='green'>fully supported</font>

although we do not support the extensions `isalnum_l()`, `isalpha_l()`, `isascii_l()`, etc.

### `<errno.h>` ###
<font color='green'>fully supported</font>
<font color='blue'>some non standard</font>

**errno** being a very special macro in C, we used some tricks of our own in AS3.

In the AS3 side, **errno** is a constant of the type `ErrorNumber`.

This class `ErrorNumber` reuse 2 function calls `GetErrno()` and `SetErrno`
as getter / setter to read and write to **errno** on the C context.

The `valueOf()` return the integer value of **errno**, but the `toString()` return the string from `strerror()`.

It is usable and works well but the usage is a slightly bit different than in C.

Another bit of headache were the error constants that can be quite different between Windows and OS X / Linux,
and extremely different when it comes to sockets.

So far we opted to hardcode the constant with the Linux values and later will provide "conversion functions": from WIN32 to Linux and vise versa.


### `<float.h>` ###
<font color='red'>not supported</font>

The float header defines the minimum and maximum limits of floating-point number values.

It would be probably difficult to port its usage to an AS3 context, especially when the AVM2 redefine some types,
in particular of the context of **VMCFG\_FLOAT** which can gives access to the **float** and **float4** types on the AS3 side.


### `<limits.h>` ###
<font color='orange'>partially supported</font>

We support things like **NAME\_MAX** (Maximum number of bytes in a filename) because it can influence how you work with the file system etc.

But we will not support things like **CHARCLASS\_NAME\_MAX** (Maximum number of bytes in a character class name) as in AVM2/AS3 we roll with different rules.

### `<locale.h>` ###
<font color='red'>not implemented</font>

### `<math.h>` ###
<font color='red'>not implemented</font>

### `<setjmp.h>` ###
<font color='red'>not supported</font>

The setjmp header is used for controlling low-level calls and returns to and from functions.

Which would be difficult (if not impossible) to adapt to AS3.

### `<signal.h>` ###
<font color='red'>not implemented</font>

### `<stdarg.h>` ###
<font color='red'>not supported</font>

The stdarg header defines several macros used to get the arguments in a function when the number of arguments is not known.

In an AS3 context we roll with different rules.

### `<stddef.h>` ###
<font color='red'>not supported</font>

The stddef header defines several standard definitions. Many of these definitions also appear in other headers.

We don't plan to support "pointers" in an AS3 context.

We don't plan to adapt the use of `sizeof()` into the AS3 context.

We plan to support wide char trough the `String` type.

### `<stdio.h>` ###
<font color='orange'>partially supported</font>

We do not support some extensions to ISO C.

**stdio locking functions** namely `flockfile()`, `ftrylockfile()` and `funlockfile()`  are not supported
because "These functions can be used by a thread to delineate a sequence of I/O statements that are executed as a unit.".

By extension we also don't support **stdio with explicit client locking** which implies no support for
`getc_unlocked()`, `getchar_unlocked()`, `putc_unlocked()`, and `putchar_unlocked()`.

`fmemopen()` and `open_memstream` are not supported.

We don't support all **print formatted output** namely `dprintf()`, `fprintf()`, `printf()`, `snprintf()`, and `sprintf()`,
as well as any functions that **convert formatted input** like `fscanf()`, `scanf()`, and `sscanf()`.

We don't support `fseeko()`/`ftello()`, use `fseek()`/`ftell()` instead (eg. the **off\_t** typedef is not that important).

`getline()` and `getdelim()` are not supported; it is easy in AS3 to to find delimiter or newline char in a string so we don't need native functions for that.
At best, we could implement in AS3 those function reusing `getc()`/`fgetc()`.

We don't support **command option parsing** namely `getopt()`, `optarg`, `opterr`, `optind`, and `optopt`
because our AS3 programs do not have to follow the rules of `main(int argc, char *argv[ ])`, you can access command line arguments as an Array
and do your own parsing.

`renameat()` is not supported, use `rename()` as equivalent function.

`setbuf()` is not supported, use `setvbuf()` instead as it got more options.

`tempnam()` is not supported, use `tmpnam()` or `tmpfile()` instead.

### `<stdlib.h>` ###
<font color='green'>fully supported</font>

### `<string.h>` ###
<font color='green'>fully supported</font>

### `<time.h>` ###
<font color='red'>not implemented</font>


<br />
<br />
<font color='orange'><b>POSIX.1</b></font>
### `<cpio.h>` ###
<font color='red'>not implemented</font>

### `<dirent.h>` ###
<font color='red'>not implemented</font>

### `<fcntl.h>` ###
<font color='red'>not implemented</font>

### `<grp.h>` ###
<font color='red'>not implemented</font>

### `<netdb.h>` ###
<font color='red'>not implemented</font>

### `<pthread.h>` ###
<font color='red'>not implemented</font>

### `<pwd.h>` ###
<font color='red'>not implemented</font>

### `<spawn.h>` ###
<font color='red'>not implemented</font>

### `<sys/ipc.h>` ###
<font color='red'>not implemented</font>

### `<sys/mman.h>` ###
<font color='red'>not implemented</font>

### `<sys/msg.h>` ###
<font color='red'>not implemented</font>

### `<sys/sem.h>` ###
<font color='red'>not implemented</font>

### `<sys/stat.h>` ###
<font color='red'>not implemented</font>

### `<sys/time.h>` ###
<font color='red'>not implemented</font>

### `<sys/types.h>` ###
<font color='red'>not implemented</font>

### `<sys/utsname.h>` ###
<font color='red'>not implemented</font>

### `<sys/wait.h>` ###
<font color='red'>not implemented</font>

### `<tar.h>` ###
<font color='red'>not implemented</font>

### `<termios.h>` ###
<font color='red'>not implemented</font>

### `<unistd.h>` ###
<font color='orange'>partially supported</font>

### `<utime.h>` ###
<font color='red'>not implemented</font>