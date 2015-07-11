## Introduction ##

One of the main advantage of the Flash Platform is to be able to write your code in AS3 and have it running across different Operating Systems: Windows, OS X, Linux, Android, etc.

But for this to work you need to have your native implementation (in C/C++) dealing with the cross platform code.

Adobe do a pretty good job at that with Flash and AIR, and here the goal is to do the same with redtamarin.


## VMPI ##

The **Virtual Machine Platform Interface** (or Virtual Machine Porting Interface).

Before, we were using ifdef in native classes and it was kind of painful to maintain<br>
see <a href='http://code.google.com/p/redtamarin/source/browse/tags/0.2.5/src/extensions/StdlibClass.cpp#106'>http://code.google.com/p/redtamarin/source/browse/tags/0.2.5/src/extensions/StdlibClass.cpp#106</a>.<br>
<br>
But in the recent updates of Tamarin, Adobe introduced a more elegant way of doing it with <b>VMPI</b>.<br>
<br>
It basically works like that<br>
<br>
You have a common header <a href='http://code.google.com/p/redtamarin/source/browse/tamarin-redux/VMPI/VMPI.h'>VMPI.h</a>

that gonna fetch the platform header<br>
<pre><code>//...<br>
#if AVMSYSTEM_WIN32<br>
  #include "win32/win32-platform.h"<br>
#elif AVMSYSTEM_UNIX<br>
  #include "unix/unix-platform.h"<br>
#elif AVMSYSTEM_MAC<br>
  #include "mac/mac-platform.h"<br>
#elif AVMSYSTEM_SYMBIAN<br>
  #include "symbian/symbian-platform.h"<br>
#endif<br>
//...<br>
</code></pre>

<a href='http://code.google.com/p/redtamarin/source/browse/tamarin-redux/platform/win32/win32-platform.h'>win32-platform.h</a>
<pre><code>//...<br>
#define VMPI_memcpy         ::memcpy<br>
#define VMPI_memset         ::memset<br>
#define VMPI_memcmp         ::memcmp<br>
#define VMPI_memmove        ::memmove<br>
#define VMPI_memchr         ::memchr<br>
#define VMPI_strcmp         ::strcmp<br>
#define VMPI_strcat         ::strcat<br>
#define VMPI_strchr         ::strchr<br>
#define VMPI_strrchr        ::strrchr<br>
#define VMPI_strcpy         ::strcpy<br>
#define VMPI_strlen         ::strlen<br>
#define VMPI_strncat        ::strncat<br>
#define VMPI_strncmp        ::strncmp<br>
#define VMPI_strncpy        ::strncpy<br>
#define VMPI_strtol         ::strtol<br>
#define VMPI_strstr         ::strstr<br>
//...<br>
</code></pre>

<a href='http://code.google.com/p/redtamarin/source/browse/tamarin-redux/platform/mac/mac-platform.h'>mac-platform.h</a>
<pre><code>//...<br>
#define VMPI_memcpy         ::memcpy<br>
#define VMPI_memset         ::memset<br>
#define VMPI_memcmp         ::memcmp<br>
#define VMPI_memmove        ::memmove<br>
#define VMPI_memchr         ::memchr<br>
#define VMPI_strcmp         ::strcmp<br>
#define VMPI_strcat         ::strcat<br>
#define VMPI_strchr         ::strchr<br>
#define VMPI_strrchr        ::strrchr<br>
#define VMPI_strcpy         ::strcpy<br>
#define VMPI_strlen         ::strlen<br>
#define VMPI_strncat        ::strncat<br>
#define VMPI_strncmp        ::strncmp<br>
#define VMPI_strncpy        ::strncpy<br>
#define VMPI_strtol         ::strtol<br>
#define VMPI_strstr         ::strstr<br>
//...<br>
</code></pre>

this is for the basics, but <b>VMPI.h</b> define more common functions<br>
<pre><code>//...<br>
/**<br>
* This method should return the difference in milliseconds between local time and UTC<br>
* @return offset in milliseconds<br>
*/<br>
extern double       VMPI_getLocalTimeOffset();<br>
<br>
//...<br>
<br>
/**<br>
* This method is called to output log messages<br>
* The implementation of this method is platform-defined<br>
*  @param message NULL-terminated UTF8-encoded string<br>
* @return none<br>
*/<br>
extern void VMPI_log(const char* message);<br>
//...<br>
</code></pre>

which have their respective implementations in <b>WinPortUtils.cpp</b>, <b>PosixPortUtils.cpp</b>, etc.<br>
<br>
<a href='http://code.google.com/p/redtamarin/source/browse/tamarin-redux/VMPI/WinPortUtils.cpp'>WinPortUtils.cpp</a>
<pre><code>//...<br>
double VMPI_getLocalTimeOffset()<br>
{<br>
    TIME_ZONE_INFORMATION tz = UpdateTimeZoneInfo();<br>
    return -tz.Bias * 60.0 * 1000.0;<br>
}<br>
<br>
//...<br>
<br>
void VMPI_log(const char* message)<br>
{<br>
#ifndef UNDER_CE<br>
    ::OutputDebugStringA(message);<br>
#endif<br>
<br>
    if(logFunc)<br>
        logFunc(message);<br>
    else {<br>
        printf("%s",message);<br>
        fflush(stdout);<br>
    }<br>
}<br>
//...<br>
</code></pre>

<a href='http://code.google.com/p/redtamarin/source/browse/tamarin-redux/VMPI/PosixPortUtils.cpp'>PosixPortUtils.cpp</a>
<pre><code>//...<br>
double VMPI_getLocalTimeOffset()<br>
{<br>
    struct tm* t;<br>
    time_t current, localSec, globalSec;<br>
<br>
    // The win32 implementation ignores the passed in time<br>
    // and uses current time instead, so to keep similar<br>
    // behaviour we will do the same<br>
    time( &amp;current );<br>
<br>
    t = localtime( &amp;current );<br>
    localSec = mktime( t );<br>
<br>
    t = gmtime( &amp;current );<br>
    globalSec = mktime( t );<br>
<br>
    return double( localSec - globalSec ) * 1000.0;<br>
}<br>
<br>
//...<br>
<br>
void VMPI_log(const char* message)<br>
{<br>
    if(logFunc)<br>
        logFunc(message);<br>
    else<br>
        printf("%s",message);<br>
}<br>
//...<br>
</code></pre>


This end up being elegant and easy to maintain, and so if we want to add our own cross platform functionalities we need to keep using VMPI.<br>
<br>
<h2>How To add a common functionality</h2>

TODO<br>
<br>
<ul><li>step 1 - edit VMPI.h to add the common definition<br>
</li><li>step 2 - add the implementation in PosixPortUtils.cpp<br>
</li><li>step 3 - add the implementation in WinPortUtils.cpp<br>
</li><li>step 4 - test</li></ul>

notes:<br>
<ul><li>use basic types in VMPI like char, double, etc.<br>
</li><li>once in your native class you can use avmplus types like Stringp, Atom, etc.</li></ul>


<h2>Misc</h2>

Under WIN32, even if you compile in a cygwin environment, you should test both with cygwin and a basic command prompt as they don't always react the same ( <code>argv[0]</code>, path separator, environment variables, etc.).<br>
<br>
Also, if Mac OS X and Linux use both the PosixPortUtils.cpp, you still have to use either ifdef or another specialized include for special case (eg. MacDebugUtil.cpp).<br>
<br>
<h2>Cross Platform C/C++</h2>

Welcome to hell :)<br>
<br>
TODO<br>
<br>
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