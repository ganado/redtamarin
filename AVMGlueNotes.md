## Introduction ##

AVMGlue is all about implementing the **Flash Player API** and **AIR API** so it can works under **redtamarin**.

Basically we have very few ideas about this source code because it is proprietary.

Those notes are here to gather help about implementing this API.


## Flash Platform documentation ##

[ActionScript® 3.0 Reference for the Adobe® Flash® Platform](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/) (we refer to it as **AS3LCR**).

The official Flash Platform documentation allow us to obtain the classes and methods signatures,
it's not the whole source code but it is a good base.

## Versioning ##

Those API need to be versioned, based on the [API Versioning in AVM](https://code.google.com/p/redshell/source/browse/doc/apiversioning.txt) doc and also on the AS3LCR.

the AVM2 rely on those different files
  * [api-versions.xml](https://code.google.com/p/redshell/source/browse/core/api-versions.xml)
  * [api-versions.as](https://code.google.com/p/redshell/source/browse/core/api-versions.as)
  * [api-versions.h](https://code.google.com/p/redshell/source/browse/core/api-versions.h)
  * [api-versions.cpp](https://code.google.com/p/redshell/source/browse/core/api-versions.cpp)
  * [api-versions.java](https://code.google.com/p/redshell/source/browse/core/api-versions.java)

From **api-versions.xml** we generate AS code that defines a compatibility matrix.

This code is embedded in the release of Flash runtime glue and used by
ASC and AVM to control the visibility of names in the API.

here and example on how it is used<br>
<a href='https://code.google.com/p/redshell/source/browse/core/ByteArray.as'>ByteArray.as</a>
<pre><code>package flash.utils<br>
{<br>
<br>
include "api-versions.as"<br>
<br>
public class ByteArray implements IDataInput, IDataOutput<br>
{<br>
<br>
    /**<br>
     * Compresses the byte array using the deflate compression algorithm.<br>
     * The entire byte array is compressed.<br>
     *<br>
     * @see #inflate()<br>
     * @playerversion Flash 10<br>
     * @playerversion AIR 1.5<br>
     * @langversion 3.0<br>
     *<br>
     * @playerversion Lite 4<br>
     */<br>
    [API(CONFIG::FP_10_0)]<br>
    public function deflate():void<br>
    {<br>
        _compress("deflate");<br>
    }<br>
<br>
}<br>
<br>
}<br>
</code></pre>


That basically means that the <code>deflate()</code> method in the <code>ByteArray</code> class is only visible from "Flash Player v10".<br>
<br>
Now there is a little trick we need to apply to make all that work, this <code>[API(CONFIG::FP_10_0)]</code> is only available to the builtin code,<br>
in your case we build 2 ABC: builtin.abc and shell_toplevel.abc based on how Tamarin works, our API are all declared in "shell_toplevel"<br>
and so we can not use the same versioning as we would do in the "builtin".<br>
<br>
There are 2 way to solve that:<br>
<ul><li>either we shadow the declarations into public vars<br><code>public const API_FP_10_0 = CONFIG::FP_10_0 - 660;</code>
</li><li>or we define our own set of variables<br><code>example here</code></li></ul>

in <b>/src/as3/</b> look at <a href='http://TODO'>Versioning.as</a>
<pre><code>public const AVMGLUE::FP_10_0<br>
</code></pre>

that's what we use<br>
<br>
for example: with <a href='http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/crypto/package.html#generateRandomBytes()'>flash.crypto.generateRandomBytes()</a>

we can not do this<br>
<pre><code>package flash.crypto<br>
{<br>
<br>
    /**<br>
     * Generates a sequence of random bytes.<br>
     * <br>
     * @playerversion Flash 11<br>
     * @playerversion AIR 3<br>
     * @langversion 3.0<br>
     */<br>
    [API(CONFIG::SWF_13,CONFIG::AIR_3_0)]<br>
    public function generateRandomBytes( numberRandomBytes:uint ):ByteArray<br>
    {<br>
        //...<br>
    }<br>
<br>
}<br>
</code></pre>

we have to do that<br>
<pre><code>package flash.crypto<br>
{<br>
<br>
    /**<br>
     * Generates a sequence of random bytes.<br>
     * <br>
     * @playerversion Flash 11<br>
     * @playerversion AIR 3<br>
     * @langversion 3.0<br>
     */<br>
    [API(AVMGLUE::SWF_13,AVMGLUE::AIR_3_0)]<br>
    public function generateRandomBytes( numberRandomBytes:uint ):ByteArray<br>
    {<br>
        //...<br>
    }<br>
<br>
}<br>
</code></pre>


also we need to compile our code with this special namespace<br>
<pre><code>			&lt;define name="CONFIG::debug" value="false"/&gt;<br>
			&lt;define name="CONFIG::release" value="true"/&gt;<br>
			&lt;define name="CONFIG::VMCFG_FLOAT" value="false" /&gt;<br>
			&lt;define name="AVMGLUE::REDTAMARIN" value="true" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_1_0"    value="661" /&gt;<br>
			&lt;define name="AVMGLUE::FP_10_0"    value="662" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_1_5"    value="663" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_1_5_1"  value="664" /&gt;<br>
			&lt;define name="AVMGLUE::FP_10_0_32" value="665" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_1_5_2"  value="666" /&gt;<br>
			&lt;define name="AVMGLUE::FP_10_1"    value="667" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_2_0"    value="668" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_2_5"    value="669" /&gt;<br>
			&lt;define name="AVMGLUE::FP_10_2"    value="670" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_2_6"    value="671" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_12"     value="672" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_2_7"    value="673" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_13"     value="674" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_0"    value="675" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_14"     value="676" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_1"    value="677" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_15"     value="678" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_2"    value="679" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_16"     value="680" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_3"    value="681" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_17"     value="682" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_4"    value="683" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_18"     value="684" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_5"    value="685" /&gt;<br>
			&lt;define name="AVMGLUE::SWF_19"     value="686" /&gt;<br>
			&lt;define name="AVMGLUE::AIR_3_6"    value="687" /&gt;<br>
			&lt;define name="AVMGLUE::VM_INTERNAL" value="688" /&gt;<br>
</code></pre>

<h2>Versioning support and update</h2>

As of now Tamarin and RedTamarin supports the following<br>
<pre><code>package<br>
{<br>
<br>
	AVMGLUE const AIR_1_0     = 661;<br>
	AVMGLUE const FP_10_0     = 662;<br>
	AVMGLUE const AIR_1_5     = 663;<br>
	AVMGLUE const AIR_1_5_1   = 664;<br>
	AVMGLUE const FP_10_0_32  = 665;<br>
	AVMGLUE const AIR_1_5_2   = 666;<br>
	AVMGLUE const FP_10_1     = 667;<br>
	AVMGLUE const AIR_2_0     = 668;<br>
	AVMGLUE const AIR_2_5     = 669;<br>
	AVMGLUE const FP_10_2     = 670;<br>
	AVMGLUE const AIR_2_6     = 671;<br>
	AVMGLUE const SWF_12      = 672;<br>
	AVMGLUE const AIR_2_7     = 673;<br>
	AVMGLUE const SWF_13      = 674;<br>
	AVMGLUE const AIR_3_0     = 675;<br>
	AVMGLUE const SWF_14      = 676;<br>
	AVMGLUE const AIR_3_1     = 677;<br>
	AVMGLUE const SWF_15      = 678;<br>
	AVMGLUE const AIR_3_2     = 679;<br>
	AVMGLUE const SWF_16      = 680;<br>
	AVMGLUE const AIR_3_3     = 681;<br>
	AVMGLUE const SWF_17      = 682;<br>
	AVMGLUE const AIR_3_4     = 683;<br>
	AVMGLUE const SWF_18      = 684;<br>
	AVMGLUE const AIR_3_5     = 685;<br>
	AVMGLUE const SWF_19      = 686;<br>
	AVMGLUE const AIR_3_6     = 687;<br>
	AVMGLUE const VM_INTERNAL = 688;<br>
<br>
}<br>
</code></pre>

to support more version we need to update the RedTamarin source code<br>
but we need to also update the ASC source code.<br>
<br>
<b>problem:</b><br>
to be able to compile the builtins we use a special older version of asc.jar,<br>
which is not the sources of asc.jar that we can find in the Apache Flex project<br>
so we would need to diff the 2 source code and update consequently<br>
possible but a bit of a pain.<br>
<br>
And same for asc2.jar which we don;t have officially the source code.<br>
<br>
<br>
<h2>Cross Compiling</h2>

<a href='http://crossgcc.rts-software.org/doku.php'>Cross Compilers for Mac OS X</a>

need to be tested, but if we could cross compile from OS X to Linux and Windows, we could generate all the exe in one go.<br>
<br>
Now, we need to be sure of the quality and performance (eg. does MS compilers compile better exe than GCC with MinGW?).<br>
<br>
<br>
<h2>mms.cfg / mm.cfg</h2>

Informations about mms.cfg, shared object paths, installer options, etc.<br>
<a href='http://www.adobe.com/devnet/flashplayer/articles/flash_player_admin_guide.html'>Adobe Flash Player Administration Guides</a><br>
<a href='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/flashplayer/pdfs/flash_player_11_9_admin_guide.pdf'>Adobe Flash Player 11.9 Administration Guide</a> (PDF)<br>
useful for when redtamarin will want to add same behaviour as flash player etc.<br>
<br>
some ref<br>
<ul><li><a href='http://jpauclair.net/2010/02/10/mmcfg-treasure/'>AS3 hidden treasure in the mm.cfg file. Revealing and documenting many Flash secrets!</a>
</li><li><a href='http://blog.coursevector.com/whistler'>.whistler – An AIR Trace Viewer</a></li></ul>

for ex:<br>
same as with <code>flash.trace.Trace</code>, if redshell find a <code>mm.cfg</code> file, try to follow the same behaviour as Flash Player / AIR.<br>
<br>
<h2>SharedObject</h2>

Long time ago as a fun side project I started to reverse engineer the LSO, the reading was working but that's it.<br>
<br>
I need to finnish this code to read/write LSO files, so it can reused to implement <code>flash.net.SharedObject</code>.<br>
<br>
few references:<br>
<ul><li><a href='http://en.wikipedia.org/wiki/Local_shared_object'>http://en.wikipedia.org/wiki/Local_shared_object</a>
</li><li><a href='http://epic.org/privacy/cookies/flash.html'>http://epic.org/privacy/cookies/flash.html</a>
</li><li><a href='http://solve.sourceforge.net/'>SolVE: Local Shared Object Viewer/Editor</a>
</li><li><a href='http://www.sephiroth.it/python/solreader.php'>Shared Object Reader</a>
</li><li><a href='http://blog.coursevector.com/minerva'>.minerva – An AIR Shared Object Editor</a></li></ul>


<b>note:</b> now with an AMF serialiser/deseiraliser in redtmarin it should go much faster, just need to work on the header.<br>
<br>
<br>
<h2>flash.trace.Trace</h2>

We already have the implementation, we just need to compare and document the difference of usage between Flash Player / AIR and RedTamarin.<br>
<br>
basic usage:<br>
<a href='http://www.eliatlas.com/blog/2011/02/27/as3-flash-trace-trace-hidden-class/'>AS3 flash.trace.Trace Hidden Class</a><br>
<a href='http://blog.sangupta.com/2011/08/magic-of-flashtracetrace.html'>Magic of flash.trace.Trace</a>

for ex:<br>
if someone edit <code>mm.cfg</code> it can generate traces in the flashlog.txt<br>
we could add a check in the redtamarin boot sequence and duplicate this behaviour.<br>
<br>
<br>
<h2>UTF-8 Encoding</h2>

For now, AS3 source code can use UTF-8, and most of stdout can output UTF-8,<br>
but we have some bugs to get UTF-8 from stdin.<br>
<br>
Also, some functions like <code>chdir()</code> would probably not work with UTF-8 and we need to test and fix that.<br>
<br>
<a href='http://www.utf8everywhere.org/'>UTF-8 Everywhere</a><br>
excellent article and notes about using and implementing UTF-8 in your software.<br>
<br>
<br>
<h2>POSIX dirent</h2>

<a href='http://www.softagalleria.net/dirent.php'>Dirent API for Microsoft Visual Studio</a><br>
an implementation of <code>&lt;dirent.h&gt;</code> for WIN32.<br>
<br>
Windows does not support <code>&lt;dirent.h&gt;</code> by default and we want to use it in a cross platform way,<br>
for the CLIB but also in the implementation of RNL.<br>
<br>
<br>
<h2>Linux Daemon</h2>

see <a href='http://www.ics.uzh.ch/~dpotter/howto/daemonize'>How to Daemonize in Linux</a>

<pre><code>#include &lt;stdio.h&gt;<br>
#include &lt;stdlib.h&gt;<br>
#include &lt;unistd.h&gt;<br>
#include &lt;sys/types.h&gt;<br>
#include &lt;sys/stat.h&gt;<br>
<br>
#define EXIT_SUCCESS 0<br>
#define EXIT_FAILURE 1<br>
<br>
static void daemonize(void)<br>
{<br>
    pid_t pid, sid;<br>
<br>
    /* already a daemon */<br>
    if ( getppid() == 1 ) return;<br>
<br>
    /* Fork off the parent process */<br>
    pid = fork();<br>
    if (pid &lt; 0) {<br>
        exit(EXIT_FAILURE);<br>
    }<br>
    /* If we got a good PID, then we can exit the parent process. */<br>
    if (pid &gt; 0) {<br>
        exit(EXIT_SUCCESS);<br>
    }<br>
<br>
    /* At this point we are executing as the child process */<br>
<br>
    /* Change the file mode mask */<br>
    umask(0);<br>
<br>
    /* Create a new SID for the child process */<br>
    sid = setsid();<br>
    if (sid &lt; 0) {<br>
        exit(EXIT_FAILURE);<br>
    }<br>
<br>
    /* Change the current working directory.  This prevents the current<br>
       directory from being locked; hence not being able to remove it. */<br>
    if ((chdir("/")) &lt; 0) {<br>
        exit(EXIT_FAILURE);<br>
    }<br>
<br>
    /* Redirect standard files to /dev/null */<br>
    freopen( "/dev/null", "r", stdin);<br>
    freopen( "/dev/null", "w", stdout);<br>
    freopen( "/dev/null", "w", stderr);<br>
}<br>
<br>
int main( int argc, char *argv[] ) {<br>
    daemonize();<br>
<br>
    /* Now we are a daemon -- do the work for which we were paid */<br>
<br>
<br>
    return 0;<br>
}<br>
</code></pre>

under Linux supports fully <code>getppid()</code>, <code>fork()</code>, <code>setsid()</code>, etc.<br>
even if half or not supported under Mac OS X and Windows.<br>
<br>
for example, under Windows<br>
<code>fork()</code> would return <code>-1</code><br>
see <a href='http://pubs.opengroup.org/onlinepubs/9699919799/functions/fork.html'>fork function</a><br>
"Otherwise, -1 shall be returned to the parent process, no child process shall be created, and errno shall be set to indicate the error."<br>
and we would set the <code>errno</code> to <code>ENOTSUP</code> (Not supported).<br>
<br>
Ideally, to respect our cross platform approach gives the tools to allow to create a "Windows Service"<br>
see <a href='http://en.wikipedia.org/wiki/Windows_service'>http://en.wikipedia.org/wiki/Windows_service</a><br>
also <a href='http://code.msdn.microsoft.com/windowsdesktop/CppWindowsService-cacf4948'>A basic Windows service in C++ </a>

Even better, have a class <code>Daemon</code> that creates daemons under Linux and services under Windows (see other for Mac OS X).<br>
<br>
<br>
<br>
<br>
<h2>uname</h2>

we need to implement <code>uname()</code> for Windows (already done)<br>
see <a href='https://code.google.com/p/redtamarin/source/browse/trunk/VMPI/WinPortUtils2.cpp?r=1245#479'>https://code.google.com/p/redtamarin/source/browse/trunk/VMPI/WinPortUtils2.cpp?r=1245#479</a>


<h2>Dynamically loaded library</h2>

see<br>
<a href='http://en.wikipedia.org/wiki/Dynamic_loading'>Wikipedia Dynamic_loading</a> (cross platform)<br>
<a href='http://en.wikipedia.org/wiki/Dynamic-link_library'>Wikipedia Dynamic-link_library</a> (windows only)<br>
<a href='http://tldp.org/HOWTO/Program-Library-HOWTO/dl-libraries.html'>DL libraries</a> (linux, mac)<br>
<a href='http://tldp.org/HOWTO/C++-dlopen/'>C++ dlopen mini HOWTO</a><br>


Adobe blog post listing linked libraries for Linux<br>
<a href='http://blogs.adobe.com/penguinswf/2006/09/librarian.html'>Librarian</a>
<pre><code>libdl.so.2<br>
libpthread.so.0<br>
libX11.so.6<br>
libXext.so.6<br>
libXt.so.6<br>
libfreetype.so.6<br>
libfontconfig.so.1<br>
libgtk-x11-2.0.so.0<br>
libgobject-2.0.so.0<br>
libglib-2.0.so.0<br>
libm.so.6<br>
libc.so.6<br>
<br>
...<br>
<br>
There are 2 more optional libraries:<br>
libasound.so (for ALSA audio I/O)<br>
and libssl.so (for certain SSL connections).<br>
<br>
If either library is not present, its representative features will be disabled.<br>
</code></pre>


Adobe blog post about cURL under Linux<br>
<a href='http://blogs.adobe.com/penguinswf/2008/08/curl_tradeoffs.html'>cURL Tradeoffs</a>
<pre><code>We will use dlopen() and dlsym() to load required functions from libcurl.so.4.<br>
If that library is not there, fall back to libcurl.so.3.<br>
</code></pre>


another Adobe blog post<br>
<a href='http://blogs.adobe.com/penguinswf/2006/07/api_review.html'>API Review</a>
<pre><code>General graphics: X11<br>
GUI elements (dialog boxes): GTK<br>
Audio I/O: ALSA<br>
Camera input: Video4Linux, API version 1<br>
Threads: POSIX threads<br>
non-HTTP Networking: BSD sockets<br>
SSL: OpenSSL<br>
IME: you know what? I don’t think we’ve settled on this one yet…<br>
</code></pre>

Even better, found a patch for Tamarin from fklockii at adobe =)<br>
<a href='http://hg.mozilla.org/users/fklockii_adobe.com/dlopen-patches/file/3eca1b256724/checkpoint-dlopen-play'>checkpoint-dlopen-play</a>

here the layout<br>
<pre><code>DynamicLibraryGlue.h<br>
DynamicLibraryGlue.cpp<br>
    |_ DynamicHandleClass<br>
    |_ DynamicHandleObject<br>
    |_ DynamicLibraryClass<br>
    |_ DynamicLibraryObject<br>
<br>
<br>
DynamicHandle.as<br>
----<br>
package avmshell<br>
{<br>
    <br>
    [native(cls="::avmshell::DynamicHandleClass", instance="::avmshell::DynamicHandleObject", methods="auto")]<br>
    public class DynamicHandle<br>
    {<br>
    <br>
    }<br>
    <br>
}<br>
----<br>
<br>
<br>
DynamicLibrary.as<br>
----<br>
package avmshell<br>
{<br>
    <br>
    [native(cls="::avmshell::DynamicLibraryClass", instance="::avmshell::DynamicLibraryObject", methods="auto")]<br>
    public class DynamicLibrary<br>
    {<br>
        public function DynamicLibrary() {}<br>
        public native function open(filename:String):void;<br>
        public native function close():void;<br>
        public function resolve(name:String):DynamicHandle<br>
        {<br>
            var dh:DynamicHandle = new DynamicHandle();<br>
            resolveWithin(name, dh);<br>
            return dh;<br>
        }<br>
        private native function resolveWithin(nm:String, dh:DynamicHandle):void;<br>
        public native function addUserSearchPath(path:String):void;<br>
        public native function removeUserSearchPath(path:String):void;<br>
        <br>
    }<br>
    <br>
}<br>
----<br>
<br>
</code></pre>



<h2>flashsupport.c</h2>

Little peek into how Linux support SSL, audio, and Video library<br>
<a href='http://www.kaourantin.net/2006/10/extending-reach-of-flash-player-on.html'>Extending the reach of the Flash Player on Linux</a><br>
<a href='http://www.kaourantin.net/flashplayer/flashsupport.c'>flashsupport.c</a><br>
good start for implementations =)<br>
<br>
<br>
<h2>headless flash player</h2>

implement a headless flash player with an event loop<br>
in short, we should be able to provide a basic global event loop with a simple implementation of EventDispatcher<br>
and some polling in a loop locked by a timer or simply the <code>sleep()</code> function.<br>
<br>
see <a href='EventLoopNotes.md'>Event Loop notes</a> for more details.<br>
<br>
<br>
<h2>Multimedias: image, sound, video</h2>

<a href='http://www.zdnet.com/blog/stewart/interview-with-mike-melanson-lead-engineer-on-the-linux-flash-player-team/96'>Interview with Mike Melanson, lead engineer on the Linux Flash Player team</a><br>
<a href='https://plus.google.com/115891738491519168693/about'>Mike Melanson google+</a><br>

<a href='http://wiki.multimedia.cx/'>The multimedia wiki</a><br>
wealth of resources for formats, codecs, etc.<br>
<ul><li><a href='http://wiki.multimedia.cx/index.php?title=PNG'>PNG</a>
</li><li><a href='http://wiki.multimedia.cx/index.php?title=H.264'>H264</a>
</li><li>etc.</li></ul>

<a href='http://multimedia.cx/eggs/'>Breaking Eggs And Making Omelettes</a> Topics On Multimedia Technology and Reverse Engineering<br>
<br>
<a href='http://guru.multimedia.cx/'>Lair Of The Multimedia Guru</a>


<h2>PNG</h2>

<a href='http://blog.kaourantin.net/?p=19'>PNG support in Flash Player 8</a><br>
<pre><code>we currently fully support:<br>
  IHDR Image header<br>
  IDAT Image data<br>
  PLTE Palette information<br>
  tRNS Transparency extension<br>
  gAMA Image gamma<br>
  IEND End of stream<br>
<br>
here are the chunk types we do NOT support<br>
  cHRM Primary chromaticities<br>
  sRGB Standard RGB color space<br>
  iCCP Embedded ICC profile<br>
  tEXt Textual data<br>
  zTXt Compressed textual data<br>
  iTXt International textual data<br>
  bKGD Background color<br>
  pHYs Physical pixel dimensions<br>
  sBIT Significant bits<br>
  sPLT Suggested palette<br>
  hIST Palette histogram<br>
  tIME Image last-modification time<br>
</code></pre>


<h2>Pixel Bender PBJ assembler and disassembler</h2>

<a href='http://www.kaourantin.net/2008/09/pixel-bender-pbj-files.html'>Pixel Bender .pbj files</a>

files:<br>
<ul><li><a href='http://www.kaourantin.net/source/pbjtools/apbj.cpp'>http://www.kaourantin.net/source/pbjtools/apbj.cpp</a>
</li><li><a href='http://www.kaourantin.net/source/pbjtools/dpbj.cpp'>http://www.kaourantin.net/source/pbjtools/dpbj.cpp</a>
</li><li><a href='http://www.kaourantin.net/source/pbjtools/apbj.zip'>http://www.kaourantin.net/source/pbjtools/apbj.zip</a>
</li><li><a href='http://www.kaourantin.net/source/pbjtools/dpbj.zip'>http://www.kaourantin.net/source/pbjtools/dpbj.zip</a></li></ul>

not a high priority but still good to have<br>
<br>
<br>
<br>
<h2>AGAL</h2>

AGAL - Adobe Graphics Assembly Language<br>
<br>
<a href='http://www.adobe.com/devnet/flashplayer/articles/what-is-agal.html'>What is AGAL</a><br>
<a href='http://blogs.adobe.com/flascc/2012/12/14/bringing-opengl-cc-code-to-the-web-with-flascc/'>Bringing OpenGL C/C++ code to the web with FlasCC</a>

<a href='https://github.com/adobe/glsl2agal'>glsl2agal GLSL To AGAL Compiler</a><br>
<a href='https://github.com/adobe/glsl2agal/tree/master/agalassembler'>AGAL assembler</a> (C++)<br>
<a href='https://github.com/adobe/glsl2agal/tree/master/agaloptimiser/src/com/adobe/AGALOptimiser'>AGAL optimiser</a> (AS3)<br>
<br>
<br>
<a href='http://www.bytearray.org/wp-content/projects/agalassembler/com.zip'>AGALMiniAssembler.as (original)</a><br>
<a href='https://github.com/PrimaryFeather/Starling-Framework/blob/master/starling/src/com/adobe/utils/AGALMiniAssembler.as'>AGALMiniAssembler.as (updated)</a>


more 3D stuff:<br>
<br>
PixarAnimationStudios / OpenSubdiv<br>
<a href='https://github.com/PixarAnimationStudios/OpenSubdiv'>Github OpenSubDiv</a><br>
<a href='http://graphics.pixar.com/opensubdiv/architecture.html'>OpenSubDiv Architecture</a>

<h2>RFC</h2>

We need to refer to Internet standards to implement some components<br>
<br>
Network protocols<br>
<ul><li>HTTP - Hypertext Transfer Protocol<br>
<ul><li><a href='http://tools.ietf.org/html/rfc1945'>RFC1945</a> Hypertext Transfer Protocol -- HTTP/1.0<br>
</li><li><a href='http://tools.ietf.org/html/rfc2616'>RFC2616</a> Hypertext Transfer Protocol -- HTTP/1.1<br>
</li><li><a href='http://tools.ietf.org/html/rfc6266'>RFC6266</a> Use of the Content-Disposition Header Field in the Hypertext Transfer Protocol (HTTP)<br>
</li><li><a href='http://tools.ietf.org/html/rfc6585'>RFC6585</a> Additional HTTP Status Codes<br>
</li><li><a href='http://tools.ietf.org/html/rfc2109'>RFC2109</a> HTTP State Management Mechanism<br>
</li><li><a href='http://tools.ietf.org/html/rfc2145'>RFC2145</a> Use and Interpretation of HTTP Version Numbers<br>
</li><li><a href='http://tools.ietf.org/html/rfc2069'>RFC2069</a> An Extension to HTTP : Digest Access Authentication<br>
</li></ul></li><li>HTTPS - Hypertext Transfer Protocol Secure<br>
<ul><li><a href='http://tools.ietf.org/html/rfc2817'>RFC2817</a> Upgrading to TLS Within HTTP/1.1<br>
</li><li><a href='http://tools.ietf.org/html/rfc2818'>RFC2818</a> HTTP Over TLS<br>
</li><li><a href='http://tools.ietf.org/html/rfc2231'>RFC2231</a> MIME Parameter Value and Encoded Word Extensions: Character Sets, Languages, and Continuations<br>
</li><li><a href='http://tools.ietf.org/html/rfc5987'>RFC5987</a> Character Set and Language Encoding for Hypertext Transfer Protocol (HTTP) Header Field Parameters<br>
</li></ul></li><li>SOAP - Simple Object Access Protocol<br>
<ul><li><a href='http://tools.ietf.org/html/rfc4227'>RFC4227</a> Using the Simple Object Access Protocol (SOAP) in Blocks Extensible Exchange Protocol (BEEP)<br>
</li></ul></li><li>UNC - Universal Naming Convention<br>
<ul><li><a href='http://tools.ietf.org/html/rfc3986'>RFC3986</a> Uniform Resource Identifier (URI): Generic Syntax<br>
</li><li><a href='http://tools.ietf.org/html/rfc3987'>RFC3987</a> Internationalized Resource Identifiers (IRIs)<br>
</li><li><a href='http://tools.ietf.org/html/rfc5785'>RFC5785</a> Defining Well-Known Uniform Resource Identifiers (URIs)<br>
</li><li><a href='http://tools.ietf.org/html/rfc3406'>RFC3406</a> Uniform Resource Names (URN) Namespace Definition Mechanisms<br>
</li><li><a href='http://tools.ietf.org/html/rfc4395'>RFC4395</a> Guidelines and Registration Procedures for New URI Schemes<br>
</li><li><a href='http://tools.ietf.org/html/rfc2397'>RFC2397</a> The "data" URL scheme<br>
</li><li><a href='http://tools.ietf.org/html/draft-crhertel-smb-url-12'>DRAFT-12</a> SMB File Sharing URI Scheme<br>
</li></ul></li><li>TCP/IP<br>
<ul><li><a href='http://tools.ietf.org/html/rfc791'>RFC791</a> INTERNET PROTOCOL<br>
</li><li><a href='http://tools.ietf.org/html/rfc1349'>RFC1349</a> Type of Service in the Internet Protocol Suite<br>
</li><li><a href='http://tools.ietf.org/html/rfc6864'>RFC6864</a> Updated Specification of the IPv4 ID Field<br>
</li><li><a href='http://tools.ietf.org/html/rfc793'>RFC793</a> TRANSMISSION CONTROL PROTOCOL<br>
</li><li><a href='http://tools.ietf.org/html/rfc3168'>RFC3168</a> The Addition of Explicit Congestion Notification (ECN) to IP<br>
</li><li><a href='http://tools.ietf.org/html/rfc6093'>RFC6093</a> On the Implementation of the TCP Urgent Mechanism<br>
</li><li><a href='http://tools.ietf.org/html/rfc6528'>RFC6528</a> Defending against Sequence Number Attacks<br>
</li><li><a href='http://tools.ietf.org/html/rfc1122'>RFC1122</a> Requirements for Internet Hosts -- Communication Layers<br>
</li><li><a href='http://tools.ietf.org/html/rfc6298'>RFC6298</a> Computing TCP's Retransmission Timer<br>
</li></ul></li><li>ICMP<br>
<ul><li><a href='http://tools.ietf.org/html/rfc792'>RFC792</a> INTERNET CONTROL MESSAGE PROTOCOL<br>
</li><li><a href='http://tools.ietf.org/html/rfc950'>RFC950</a> Internet Standard Subnetting Procedure<br>
</li><li><a href='http://tools.ietf.org/html/rfc4884'>RFC4884</a> Extended ICMP to Support Multi-Part Messages<br>
</li><li><a href='http://tools.ietf.org/html/rfc6633'>RFC6633</a> Deprecation of ICMP Source Quench Messages<br>
</li><li><a href='http://tools.ietf.org/html/rfc6918'>RFC</a> Formally Deprecating Some ICMPv4 Message Types<br>
</li></ul></li><li>TELNET<br>
<ul><li><a href='http://tools.ietf.org/html/rfc854'>RFC854</a> TELNET PROTOCOL SPECIFICATION<br>
</li><li><a href='http://tools.ietf.org/html/rfc855'>RFC855</a> TELNET OPTION SPECIFICATIONS<br>
</li><li><a href='http://tools.ietf.org/html/rfc5198'>RFC5198</a> Unicode Format for Network Interchange<br>
</li></ul></li><li>FTP<br>
<ul><li><a href='http://tools.ietf.org/html/rfc959'>RFC959</a> FILE TRANSFER PROTOCOL (FTP)<br>
</li><li><a href='http://tools.ietf.org/html/rfc2228'>RFC2228</a> FTP Security Extensions<br>
</li><li><a href='http://tools.ietf.org/html/rfc2640'>RFC2640</a> Internationalization of the File Transfer Protocol<br>
</li><li><a href='http://tools.ietf.org/html/rfc2773'>RFC2773</a> Encryption using KEA and SKIPJACK<br>
</li><li><a href='http://tools.ietf.org/html/rfc3659'>RFC3659</a> Extensions to FTP<br>
</li><li><a href='http://tools.ietf.org/html/rfc5797'>RFC5797</a> FTP Command and Extension Registry<br>
</li></ul></li><li>SMB<br>
</li><li>SSL / Security / Authorization<br>
<ul><li><a href='http://tools.ietf.org/html/rfc2617'>RFC2617</a> HTTP Authentication: Basic and Digest Access Authentication<br>
</li><li><a href='http://tools.ietf.org/html/rfc6101'>RFC6101</a> The Secure Sockets Layer (SSL) Protocol Version 3.0<br>
</li><li><a href='http://tools.ietf.org/html/rfc6176'>RFC6176</a> Prohibiting Secure Sockets Layer (SSL) Version 2.0<br>
</li><li><a href='http://tools.ietf.org/html/rfc5849'>RFC5849</a> The OAuth 1.0 Protocol<br>
</li><li><a href='http://tools.ietf.org/html/rfc6749'>RFC6749</a> The OAuth 2.0 Authorization Framework<br>
</li><li><a href='http://tools.ietf.org/html/rfc6750'>RFC6750</a> The OAuth 2.0 Authorization Framework: Bearer Token Usage<br>
</li></ul></li><li>MISC<br>
<ul><li><a href='http://tools.ietf.org/html/rfc5234'>RFC5234</a> Augmented BNF for Syntax Specifications: ABNF</li></ul></li></ul>

<a href='http://en.wikipedia.org/wiki/List_of_RFCs'>List of RFCs</a><br>
<a href='http://tools.ietf.org/rfc/index'>http://tools.ietf.org/rfc/index</a><br>
etc.<br>
<br>
Adobe protocols and specifications<br>
<ul><li>SWF<br>
<ul><li><a href='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/swf/pdf/swf-file-format-spec.pdf'>SWF 19</a> SWF File Format Specification (version 19) (PDF)<br>
</li><li><a href='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/swf/pdf/swf-file-format-spec-v10.pdf'>SWF 10</a> (PDF)<br>
</li></ul></li><li>AMF - Action Message Format<br>
<ul><li><a href='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/amf/pdf/amf-file-format-spec.pdf'>AMF spec</a> (PDF)<br>
</li></ul></li><li>RTMP - Real Time Messaging Protocol<br>
</li><li>RTMPT - RTMP tunneling via HTTP<br>
</li><li>RTMPS - RTMP tunneling via HTTPS<br>
</li><li>RTMFP<br>
<ul><li><a href='http://tools.ietf.org/html/rfc7016'>RFC7016</a> Adobe's Secure Real-Time Media Flow Protocol</li></ul></li></ul>



<h2>Reverse Engineering</h2>

Sometimes when there is no other way because we are stuck<br>
<br>
<b>Decompiling SWC</b>
<ul><li>playerglobal.swc<br>
</li><li>airglobal.swc</li></ul>

Why?: because most of the native classes in avmglue.abc also use AS3, at least we can get the AS3 part.<br>
<br>
various flash decompilers<br>
<ul><li><a href='http://www.buraks.com/asv/'>ActionScript Viewer</a> (imho the best)<br>
</li><li>tamarin-redux abcdump (good)<br>
</li><li>tamarin-redux abcdis (better)<br>
</li><li><a href='http://labs.adobe.com/technologies/swfinvestigator/'>Adobe SWF Investigator</a> (<a href='http://sourceforge.net/adobe/swfinvestigator/code/HEAD/tree/'>sources</a>)<br>
</li><li><a href='http://yogda.2ka.org/'>Yogda AVM2 workbench</a> interesting AVM2 Bytecode Assembler / Disassembler / Injector (sadly only WIN32)<br>
</li><li><a href='http://yogda.2ka.org/bytecodes'>Yogda AVM2 Library </a> example of bytecode usage in Tamarin<br>
</li><li><a href='http://www.swfwire.com/'>http://www.swfwire.com/</a> seem very good too and open source<br>
</li><li><a href='http://bruce-lab.blogspot.co.uk/2010_08_01_archive.html'>http://bruce-lab.blogspot.co.uk/2010_08_01_archive.html</a> (other stuff)</li></ul>

<b>Decompiling Java</b>
<ul><li>the best <a href='http://jd.benow.ca/'>http://jd.benow.ca/</a> (was <a href='http://java.decompiler.free.fr/'>http://java.decompiler.free.fr/</a>)<br>
</li><li>seriously there are no other <a href='http://en.wikipedia.org/wiki/Java_Decompiler'>Java Decompiler on Wikipedia</a></li></ul>

Why?: even if most compiler tools are open source we need to decompile particuliar versions of asc.jar and asc2.jar<br>
<br>
<b>Decompiling C/C++</b>
<ul><li><a href='http://www.blackhat.com/presentations/bh-dc-07/Sabanal_Yason/Paper/bh-dc-07-Sabanal_Yason-WP.pdf'>Reversing C++</a> (PDF) (by X-Force, Black Hat DC, Feb 2007)<br>
</li><li>more to add<br>
</li><li>todo<br>
</li><li>todo<br>
</li><li>todo