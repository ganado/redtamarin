## Introduction ##

One of the main advantage of the Flash Platform is to be able to write your code in AS3 and have it running across different Operating Systems: Windows, OS X, Linux, Android, etc.

But for this to work you need to have your native implementation (in C/C++) dealing with the cross platform code.

Adobe do a pretty good job at that with Flash and AIR, and gave us in Tamarin a pretty solid layout to do it too.

Here the goal is to keep doing that in **redtamarin**, it is a very high priority.


## Details ##

Here some basic rules and scopes.

We mainly support 3 Operating System
  * Windows
  * Mac OS X
  * Linux

Ideally we try to avoid implementing a native functionality that would work only in 1 Operating System,
but there are off course exceptions.

here 2 examples:

**fork()** will work with Mac OS X and Linux but not Windows<br>
in this particular case the Windows implementation should return an error message "not supported".<br>
<br>
<b>Windows Registry</b> will work only with Windows and not with Mac OS X or Linux<br>
this API should support a static property <code>WindowsRegistry.isSupported:Boolean</code>.<br>
<br>
<br>
<h2>The Virtual Machine Platform Interface</h2>

The <b>Virtual Machine Platform Interface</b> (or <b>VMPI</b>) is how Adobe engineers setup Tamarin,<br>
and we follow the same model for RedTamarin.<br>
<br>
Here the general idea:<br>
<ul><li>in the <b>platform</b> directory you have sub-directory per platform<br><b>mac</b>, <b>unix</b>, <b>win32</b>, etc.<br>
</li><li>in <b>VMPI</b> we define and/or implement a shared API by all those platforms:<br><code>VMPI_getenv()</code>, <code>VMPI_setenv()</code>, etc.<br>
</li><li>in the native classes (see the <b>api</b> directory) you can only use VMPI functions<br>when it comes to use Operating System API</li></ul>

basically instead of doing this<br>
<pre><code>#include &lt;stdlib.h&gt;<br>
<br>
Stringp SystemClass::getEnvironment(Stringp name)<br>
{<br>
    if (!name) {<br>
        toplevel()-&gt;throwArgumentError(kNullArgumentError, "name");<br>
    }<br>
<br>
    StUTF8String nameUTF8(name);<br>
    Stringp output = core()-&gt;newStringUTF8( "" );<br>
<br>
    char *result;<br>
    result = getenv( nameUTF8.c_str() );<br>
<br>
    output = output-&gt;append( core()-&gt;newStringUTF8( result ) );<br>
    return output;<br>
}<br>
</code></pre>

you're doing that<br>
<pre><code>Stringp SystemClass::getEnvironment(Stringp name)<br>
{<br>
    if (!name) {<br>
        toplevel()-&gt;throwArgumentError(kNullArgumentError, "name");<br>
    }<br>
<br>
    StUTF8String nameUTF8(name);<br>
    Stringp output = core()-&gt;newStringUTF8( "" );<br>
<br>
    char *result;<br>
    result = VMPI_getenv( nameUTF8.c_str() );<br>
<br>
    output = output-&gt;append( core()-&gt;newStringUTF8( result ) );<br>
    return output;<br>
}<br>
</code></pre>

here the main reasons why<br>
<ul><li>if a particular platform does not support the function call we can throw a "not supported" error from the VMPI function<br>
</li><li>we avoid to use a particular include, <code>VMPI.h</code> is used everywhere<br>
</li><li>we use the same function signatures and avoid to use if/else logic<br>
</li><li>if and when we adda new platform we don't have to rewrite the code of the native classes<br>
</li><li>we want to use POSIX even on handicapped platforms like Windows</li></ul>

<br>
<br>

<table><thead><th> see this document <a href='https://docs.google.com/spreadsheet/pub?key=0AjVfZaaIMWOcdEthZmtaUldiQ2V1UUl6UlUtVWo4c1E&output=html'>Cross Platform POSIX</a> (google spreadsheet) that illustrate which functions of POSIX are implemented in RedTamarin. </th></thead><tbody></tbody></table>

<br>
<br>

<h2>Cross Platform C/C++ References</h2>

Welcome to hell :)<br>
<br>
<h3>online references</h3>

about cross platform<br>
<ul><li><a href='http://www.crossplatformbook.com/posix.html'>Cross Platform POSIX.1</a>
</li><li><a href='http://patrakov.blogspot.co.uk/2008/10/porting-cc-code-from-unix-to-win32.html'>Porting C/C++ code from Unix to Win32</a>
</li><li><a href='https://code.google.com/p/msinttypes/'>https://code.google.com/p/msinttypes/</a><br>the project fills the absence of stdint.h and inttypes.h in Microsoft Visual Studio.<br>
</li><li><a href='https://developer.apple.com/library/mac/documentation/Porting/Conceptual/PortingUnix/background/background.html#//apple_ref/doc/uid/TP40002848-TPXREF101'>Porting UNIX/Linux Applications to OS X</a> (Mac Developer Library)<br>
</li><li><a href='http://fearthecow.net/guest/rosetta/'>Porting C/C++ to/from Win32 &amp; Unix - A C/C++ Rosetta Stone</a>
</li><li><a href='http://msdn.microsoft.com/en-us/library/y23kc048.aspx'>Porting from UNIX to Win32</a> (MSDN)<br>
</li><li><a href='http://www.ibm.com/developerworks/aix/library/au-porting/index.html'>Windows to UNIX porting, Part 1: Porting C/C++ sources</a> (IBM developerWorks)<br>
</li><li><a href='http://www.ibm.com/developerworks/aix/library/au-porting2/index.html'>Windows to UNIX porting, Part 2: Internals of porting C/C++ sources</a> (IBM developerWorks)</li></ul>

some interesting links<br>
<ul><li>C Reference Card (ANSI) <a href='http://www.usna.edu/EE/ee462/MANUALS/ansi-c-refcard-letter.pdf'>PDF</a>
</li><li><a href='http://www.cplusplus.com/'>http://www.cplusplus.com/</a>
</li><li><a href='http://www.parashift.com/c++-faq-lite/'>C++ FAQ LITE</a>
</li><li><a href='http://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html'>The GNU C Reference Manual</a>
</li><li>Optimizing software in C++: An optimization guide for Windows, Linux and Mac platforms <a href='http://www.agner.org/optimize/'>home</a> <a href='http://www.agner.org/optimize/optimizing_cpp.pdf'>PDF</a>
</li><li><a href='http://www.crossplatformbook.com/posix.html'>POSIX.1 API Support</a> (cross reference MacOS X, Linux, MS Visual C++ RTL, Cygwin, MinGW, and NSPR 4.3)<br>
</li><li><a href='http://www.unix.org/apis.html'>Unix98 API tables</a>
</li><li><a href='http://www.unix.org/version3/apis.html'>Unix03 (Single Unix Specification) API tables</a></li></ul>

some interesting books<br>
<ul><li><a href='http://publications.gbdirect.co.uk/c_book/'>The C Book</a> (free)<br>
</li><li><a href='http://beej.us/guide/bgc/'>Beej's Guide to C Programming</a> (free)<br>
</li><li><a href='http://crossplatformbook.com/'>Cross-Platform Development in C++</a> (not free)<br>
</li><li><a href='http://msdn.microsoft.com/en-us/library/ms811903.aspx'>MSDN UNIX Application Migration Guide</a> (free)<br>
</li><li><a href='http://beej.us/guide/bgnet/'>Beej's Guide to Network Programming</a> (free)<br>
</li><li><a href='http://beej.us/guide/bgipc/'>Beej's Guide to Unix Interprocess Communication</a> (free)<br>
</li><li><a href='http://beej.us/guide/bggdb/'>Beej's Quick Guide to GDB</a> (free)</li></ul>


most of the API implemented are double-checked and referenced with<br>
<ul><li><a href='http://www.open-std.org/JTC1/SC22/WG14/www/standards'>ISO/IEC 9899 - Programming languages - C</a> <a href='http://www.open-std.org/JTC1/SC22/WG14/www/docs/n1256.pdf'>PDF</a>
</li><li><a href='http://www.unix.org/single_unix_specification/'>The Single UNIX Specification Version 3 Interface</a>
</li><li><a href='http://msdn.microsoft.com/en-us/library/59ey50w6.aspx'>Microsoft Run-Time Library Reference</a>
</li><li><a href='http://www.dinkumware.com/manuals/default.aspx?manual=compleat&page=lib_over.html'>Dinkum Compleat Reference</a>