## Introduction ##

The **VMPI** is where we define native system calls in a cross-platform way.

```
src
.
├── AVMPI
│   └── ...
├── VMPI
│   ├── GenericPortUtils.cpp
│   ├── ...
│   ├── MacPortUtils.cpp
│   ├── PosixPortUtils.cpp
│   ├── PosixPortUtils2.cpp
│   ├── PosixSpecificUtils.cpp
│   ├── ...
│   ├── VMPI.h
│   ├── VMPI2.h
│   ├── ...
│   ├── WinPortUtils.cpp
│   ├── WinPortUtils2.cpp
│   └── ...
│
├── platform
│   ├── android
│   │   └── ...
│   ├── arm
│   │   └── ...
│   ├── mac
│   │   ├── ...
│   │   ├── mac-platform.h
│   │   ├── mac-platform2.h
│   │   └── manifest.mk
│   ├── symbian
│   │   └── ...
│   ├── system-selection.h
│   ├── unix
│   │   ├── ...
│   │   ├── unix-platform.h
│   │   └── unix-platform2.h
│   ├── win32
│   │   ├── ...
│   │   ├── win32-platform.h
│   │   └── win32-platform2.h
│   └── winrt
│       └── ...
│
└── ...
```

the simpler definition is as follow

**VMPI.h** will define "interfaces"

and depending on **system-selection.h**

a specific platform implementation of the VMPI interfaces will be compiled

either **mac-platform.h** and **MacPortUtils.cpp**,<br>
or <b>unix-platform.h</b> and <b>PosixPortUtils.cpp</b><br>
or <b>win32-platform.h</b> and <b>WinPortUtils.cpp</b><br>
etc.<br>
<br>
<br>
<h2>Implementation Details</h2>

Let's look at the <b>exit()</b> implementation<br>
<br>
<b>unix-platform.h</b>
<pre><code>#define VMPI_exit           ::exit<br>
</code></pre>

<b>win32-platform.h</b>
<pre><code>#define VMPI_exit    ::exit<br>
</code></pre>

In this case we define an alias and we don't even need to defien anything in <b>VMPI.h</b>


<br>
<br>

Let's look at the <b>getenv()</b> implementation<br>
<br>
<b>VMPI.h</b>
<pre><code>/**<br>
 * wrapper around getenv function, return's NULL on platforms with no env vars<br>
 * @return value of env var<br>
 */<br>
extern const char *VMPI_getenv(const char *name);<br>
</code></pre>

<b>WinPortUtils.cpp</b>
<pre><code>const char *VMPI_getenv(const char *env)<br>
{<br>
    const char *val = NULL;<br>
    (void)env;<br>
	// Environment variables are not available for Windows Store applications.<br>
#ifndef AVMSYSTEM_WINDOWSSTOREAPP<br>
#ifndef UNDER_CE<br>
    val = getenv(env);<br>
#endif<br>
#endif // AVMSYSTEM_WINDOWSSTOREAPP<br>
    return val;<br>
}<br>
</code></pre>

<b>PosixPortUtils.cpp</b>
<pre><code>const char *VMPI_getenv(const char *name)<br>
{<br>
    return getenv(name);<br>
}<br>
</code></pre>

most of the time Mac OS X will reuse the <code>PosixPortUtils.cpp</code>, but for special case you will find the implementation in <code>MacPortUtils.cpp</code>

In this case, we have to define the interface in <b>VMPI.h</b>
so the method signature end up being the same everywhere,<br>
but mainly to be able to "not call" a system function where we know it does not exists.<br>
<br>
<br>
<br>

Let's look at the <b>realpath()</b> implementation<br>
<br>
when you can see <b>2</b> it is just the headers that RedTamarin add<br>
<br>
<br>
<b>VMPI2.h</b>
<pre><code>/**<br>
 * wrapper around realpath function<br>
 * @return resolved path<br>
 */<br>
extern char *VMPI_realpath(char const *path);<br>
</code></pre>

<b>WinPortUtils2.cpp</b>
<pre><code>char *VMPI_realpath(char const *path)<br>
{<br>
    /* note:<br>
       if the path does not exists the path will still resolve<br>
       and does not set errno to ENOENT "No such file or directory"<br>
    */<br>
    char* full = NULL;<br>
    char* result = NULL;<br>
    <br>
    if( VMPI_access(path, F_OK) ) {<br>
        errno = ENOENT;<br>
        return NULL;<br>
    }<br>
    <br>
    //char *_fullpath( char *absPath, const char *relPath, size_t maxLength );<br>
    result = _fullpath( full, path, PATH_MAX );<br>
    <br>
    if( result != NULL ) {<br>
        return result;<br>
    }<br>
    <br>
    return NULL; <br>
}<br>
</code></pre>

<b>PosixPortUtils2.cpp</b>
<pre><code>char *VMPI_realpath(char const *path)<br>
{<br>
    char* full = NULL;<br>
    char* result = NULL;<br>
<br>
    result = realpath(path, full);<br>
    <br>
    if( result != NULL ) {<br>
        return result;<br>
    }<br>
    <br>
    return NULL;<br>
}<br>
</code></pre>

In this case, we have to define the interface in <b>VMPI2.h</b>
so the method signature end up being the same everywhere,<br>
so we can have 2 different implementations.<br>
<br>
You can see that the <i><b>realpath</b> under Windows is slightly different than the <b>realpath</b> under Linux/Mac.</i>


<h2>Usage</h2>

When we want one of our native class to do a system call as <b>exit()</b>, <b>getenv()</b>, <b>realpath()</b>, etc.<br>
<br>
we never call the native system call inside our native class<br>
but we do call a VMPI implemenation.<br>
<br>
<br>
<table><thead><th> when </th><th> system call </th></thead><tbody>
<tr><td> <b>NEVER</b> </td><td> <code>exit()</code> </td></tr>
<tr><td> <b>ALWAYS</b> </td><td> <code>VMPI_exit()</code> </td></tr>