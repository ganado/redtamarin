<a href='Hidden comment: 
Here we can use asdoc to document the source code.
So the rule is to document the side notes in the wiki page.

/* more in depth informations: http://code.google.com/p/redtamarin/wiki/System */
'></a>

# About #
Represents the currently running application and the avmshell runtime.

**class:** `avmplus::System`

**product:** redtamarin 0.3

**since:** 0.3.0



---


# Constants #

## argv ##
```
public static const argv:Array
```
Contains the arguments passed to the program.

**note:**<br>
Initialised by the private native function <code>getArgv()</code>.<br>
Compared to C++ argv, <code>argv[0]</code> is not included<br>
but saved in <code>programFilename</code>.<br>
<br>
<b>usage:</b><br>
<pre><code>redshell.exe myprogram.abc -- -arg1 -arg2 arg3<br>
</code></pre>
when you are running an <code>*.abc</code> file with the avmshell<br>
you need to use <code>--</code> followed by the command line arguments.<br>
<br>
<pre><code>myprogram.exe -arg1 -arg2 arg3<br>
</code></pre>
when you are running an independent executable (avmshell embedding an <code>*.abc</code> file)<br>
you pass directly the command line arguments (like any other exe).<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>startupDirectory</h2>
<pre><code>public static const startupDirectory:String<br>
</code></pre>
The original directory when the application started.<br>
<br>
<b>note:</b><br>
Initialised by the private native function <code>getStartupDirectory()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h1>Properties</h1>

<h2>apiVersion</h2>
<pre><code>public native static function get apiVersion():int;<br>
</code></pre>
Return the value passed to -api at launch<br>
(or the default value, if -api was not specified).<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "API version : " + System.apiVersion ); //API version : 673<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>apiAlias</h2>
<pre><code>public static function get apiAlias():String<br>
</code></pre>
Returns the alias name of the api version.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "API alias : " + System.apiAlias ); //API alias : AIR_2_7<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>pid</h2>
<pre><code>public static function get pid():int<br>
</code></pre>
Returns the current process id.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "pid = " + System.pid ); //pid = 75665<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>profile</h2>
<pre><code>public static function get profile():Profile<br>
public static function set profile( value:Profile ):void<br>
</code></pre>
Returns or Defines the current profile.<br>
<br>
<b>note:</b><br>
Initialised by toplevel to <code>System.profile = new RedTamarinProfile();</code>.<br>
Any classes extending <code>Profile</code> downcast to the <code>Profile</code> type.<br>
<br>
<b>example:</b> change the default profile<br>
<pre><code>import avmplus.System;<br>
import avmplus.profiles.FlashPlayerProfile;<br>
<br>
System.profile = new FlashPlayerProfile();<br>
</code></pre>

<b>example:</b> change some properties of the profile (to run some unit tests for ex)<br>
<pre><code>import avmplus.System;<br>
<br>
System.profile.language = "fr";<br>
System.profile.touchscreenType = "finger";<br>
System.profile.supportsAccelerometer = true;<br>
</code></pre>


<b>since:</b> 0.3.1<br>
<br>
<br>
<h2>stdout</h2>
<pre><code>public static var stdout:StandardStream = new StandardStreamOut();<br>
</code></pre>
Standard Output.<br>
<br>
<b>example:</b> display an image under CGI<br>
<pre><code>import avmplus.System;<br>
import avmplus.FileSystem;<br>
import flash.utils.ByteArray;<br>
<br>
var img:ByteArray = FileSystem.readByteArray( "image.png" );<br>
System.stdout.writeBinary( img ); <br>
//TODO<br>
System.exit(0);<br>
</code></pre>

<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>stderr</h2>
<pre><code>public static var stderr:StandardStream = new StandardStreamErr();<br>
</code></pre>
Standard Error.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>stdin</h2>
<pre><code>public static var stdin:StandardStream = new StandardStreamIn();<br>
</code></pre>
Standard Input.<br>
<br>
<b>example:</b> read post data with CGI<br>
<pre><code>import avmplus.System;<br>
import flash.utils.ByteArray;<br>
import C.stdlib.*;<br>
<br>
var postSize:int = int( getenv("CONTENT_LENGTH") );<br>
<br>
if( postSize &gt; 0 )<br>
{<br>
    var postData:ByteArray = System.stdin.read( postSize );<br>
    //...<br>
}<br>
//...<br>
</code></pre>

<b>example:</b> read stdin piped into an exectuable<br>
<pre><code>$ cat somefile.bin | ./redshell test.abc<br>
</code></pre>
or<br>
<pre><code>$ cat somefile.bin | ./test<br>
</code></pre>
the pipe <code>|</code> will pass the binary content to the stdin of the shell,<br>
here how to parse it<br>
<pre><code>import avmplus.System;<br>
import flash.utils.ByteArray;<br>
import C.stdio.*;<br>
<br>
//change the console stream mode to binary<br>
con_trans_mode(O_BINARY); //does nothing under POSIX, only needed with WIN32<br>
<br>
//read stdin buffer till EOF<br>
var bytes:ByteArray = System.stdin.readBinaryl(); <br>
<br>
trace( "total bytes received = " + bytes.length );<br>
</code></pre>

<b>since:</b> 0.3.2<br>
<br>
<br>

<h2>programFilename</h2>
<pre><code>public native static function get programFilename():String;<br>
</code></pre>
Returns the program filename.<br>
<br>
<b>note:</b><br>
Contains the value of <code>argv[0]</code>, it can be a full path or not.<br>
Depending on wether you need to retrieve the executable name only<br>
or the full path of the directory, or both<br>
you will have to do your own parsing with the value.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>shell</h2>
<pre><code>public static function get shell():String<br>
</code></pre>
Returns system default shell.<br>
<br>
<b>note:</b><br>
For WIN32 will returns the value of <code>%COMSPEC%</code>, eg. <code>C:\Windows\System32\cmd.exe</code>.<br>
<br>
for POSIX, will returns the  value of <code>$SHELL</code>, eg. <code>/bin/bash</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>swfVersion</h2>
<pre><code>public native static function get swfVersion():int;<br>
</code></pre>
Returns the value passed to -swfversion at launch<br>
(or the default value, if -swfversion was not specified).<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "SWF version : " + System.swfVersion ); //SWF version : 12<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>totalMemory</h2>
<pre><code>public native static function get totalMemory():Number;<br>
</code></pre>
Amount of real memory we've aqcuired from the OS.<br>
<br>
<b>note:</b><br>
The amount of memory (in bytes) currently in use that has been directly allocated by <code>redshell</code>.<br>
This property does not return all memory used by a <code>redshell</code> application<br>
or by the application (such as a projector).<br>
The <a href='#privateMemory.md'>System.privateMemory</a> property reflects all memory used by an application.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>freeMemory</h2>
<pre><code>public native static function get freeMemory():Number;<br>
</code></pre>
Part of <a href='#totalMemory.md'>totalMemory</a> we aren't using.<br>
<br>
<b>note:</b><br>
The amount of memory (in bytes) that is allocated to <code>redshell</code> and that is not in use.<br>
This unused portion of allocated memory (<a href='#totalMemory.md'>System.totalMemory</a>) fluctuates as garbage collection takes place.<br>
Use this property to monitor garbage collection.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>privateMemory</h2>
<pre><code>public native static function get privateMemory():Number;<br>
</code></pre>
Process wide size of resident private memory.<br>
<br>
<b>note:</b><br>
The entire amount of memory (in bytes) used by an application.<br>
This is the amount of resident private memory for the entire process.<br>
Developers should use this property to determine the entire memory consumption of an application.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>workingDirectory</h2>
<pre><code>public function get workingDirectory():String<br>
public function set workingDirectory( value:String ):void<br>
</code></pre>
Allows to get or set the current working directory of the application.<br>
<br>
<b>note:</b><br>
reuse <code>getcwd()</code> and <code>chdir()</code> from <a href='C_unistd.md'>C.unistd</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h1>Methods</h1>

<h2>eval</h2>
<pre><code>public native static function eval( source:String ):void;<br>
</code></pre>
Evaluates AS3 source code at runtime.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
import avmplus.FileSystem;<br>
<br>
var src:String = FileSystem.read( "test.as" );<br>
System.eval( src );<br>
</code></pre>

<b>note:</b><br>
<code>eval()</code> have some limitations<br>
<ul><li>the execution scope is not shared<br>
<pre><code>import avmplus.System;<br>
<br>
var hello:String = "world"<br>
System.eval( "trace( hello );" ); //var hello is undefined in the scope of eval<br>
<br>
System.eval( "var test:uint = 123;" );<br>
trace( this["test"] ); //var test is undefined in the scope of the main script<br>
</code></pre>
</li><li>you can not use the <code>import</code> statement for fully qualified names<br>
<pre><code>import avmplus.System;<br>
<br>
var src:String = &lt;![CDATA[<br>
var sys:Class  = getClassByName( "avmplus.System" ); //workaround<br>
<br>
trace( "avmplus version = " + sys.getAvmplusVersion() );<br>
]]&gt;;<br>
System.eval( src );<br>
</code></pre>
</li><li>you can not use the <code>include</code> directive in an eval script<br>
</li><li>you can not declare a Class/Interface/namespace definitions in an eval script<br>
<br>
But <code>eval()</code> got some features too<br>
</li><li>you can use <code>import</code> for unqualified directives<br>
<pre><code>import avmplus.System;<br>
<br>
var src:String = &lt;![CDATA[<br>
import avmplus.*;<br>
trace( "avmplus version = " + System.getAvmplusVersion() );<br>
]]&gt;;<br>
System.eval( src );<br>
</code></pre>
</li><li>the <code>Domain</code> is shared, that means any definitions<br>or abc you load before calling <code>eval()</code> will be known to <code>eval()</code>
<pre><code>//if you compile your main script with avmglue.abc<br>
import avmplus.System;<br>
<br>
var src:String = &lt;![CDATA[<br>
var sys:Class  = getClassByName( "avmplus.System" );<br>
var fcap:Class = getClassByName( "flash.system.Capabilities" );<br>
<br>
trace( "avmplus version = " + sys.getAvmplusVersion() );<br>
trace( "os: " + fcap.os ); //will work<br>
]]&gt;;<br>
System.eval( src );<br>
</code></pre>
<pre><code>//if you compile your main script with avmglue.abc<br>
import avmplus.System;<br>
<br>
var src:String = &lt;![CDATA[<br>
//import avmplus.*; //attention here avmplus::System and flash.system::System will cause ambiguity<br>
import flash.system.*;<br>
<br>
trace( "os: " + Capabilities.os ); //will work<br>
]]&gt;;<br>
System.eval( src );<br>
</code></pre>
</li><li>the scope of packages and classes is shared,<br>eg. if you modify a class property in <code>eval()</code><br>your main script will have access to the changes.<br>
<pre><code>package test<br>
{<br>
	public class Something<br>
	{<br>
		public static var word:String = "hello world";<br>
	}<br>
}<br>
</code></pre>
<pre><code>import avmplus.System;<br>
<br>
include "test/Something.as";<br>
import test.Something;<br>
<br>
var src:String = &lt;![CDATA[<br>
var smthing:Class = getClassByName( "test.Something" );<br>
    smthing.word = "bonjour le monde";<br>
]]&gt;;<br>
<br>
trace( "Something.word = " + Something.word ); //hello world<br>
<br>
System.eval( src );<br>
<br>
trace( "Something.word = " + Something.word ); //bonjour le monde<br>
</code></pre>
</li><li>you can share the global <code>this</code>
<pre><code>_global.panda = "hello panda";<br>
trace( "eval koala = " + _global["koala"] );<br>
trace( "eval panda = " + _global["panda"] );<br>
</code></pre>
<pre><code>package<br>
{<br>
	public var _global:*;<br>
}<br>
<br>
_global = this;<br>
<br>
import avmplus.FileSystem;<br>
import avmplus.System;<br>
<br>
_global.koala = "hello koala";<br>
<br>
var source:String = FileSystem.read( "test2.as" );<br>
avmplus.System.eval( source );<br>
<br>
trace( "main panda = " + _global["panda"] );<br>
trace( "main koala = " + _global["koala"] );<br>
</code></pre></li></ul>

<ul><li>another use of the global <code>this</code>
<pre><code>_global.test456 = function():String<br>
{<br>
	return "456";<br>
}<br>
<br>
trace( "eval scope = " + _global.test456() );<br>
</code></pre>
<pre><code>package<br>
{<br>
	public var _global:*;<br>
}<br>
<br>
_global = this;<br>
<br>
import avmplus.FileSystem;<br>
import avmplus.System;<br>
<br>
var source:String = FileSystem.read( "test3.as" );<br>
avmplus.System.eval( source );<br>
<br>
trace( "main scope = " + this["test456"]() );<br>
trace( "main scope = " + _global["test456"]() );<br>
</code></pre></li></ul>

<b>since:</b> 0.3.1<br>
<br>
<br>
<h2>exec</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function exec( command:String ):int<br>
</code></pre>
Executes the specified command line and returns the status code.<br>
<br>
<b>note:</b><br>
Reuse <code>system()</code> from <a href='C_stdlib.md'>C.stdlib</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>exit</h2>
<pre><code>public static function exit( status:int = -1 ):void<br>
</code></pre>
Terminates the program execution.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import C.stdlib.*;<br>
import avmplus.System;<br>
<br>
var success:Boolean;<br>
<br>
//... some logic to define success is true or false<br>
<br>
if( success )<br>
{<br>
    System.exit( EXIT_SUCCESS );<br>
}<br>
else<br>
{<br>
    System.exit( EXIT_FAILURE );<br>
}<br>
</code></pre>

<b>note:</b><br>
Reuse <code>exit()</code> from <a href='C_stdlib.md'>C.stdlib</a>.<br>
If no arguments are passed will use <code>EXIT_SUCCESS</code> by default.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>popen</h2>
<font color='orange'>blocking</font><br>
<pre><code>public static function popen( command:String ):String<br>
</code></pre>
Executes the specified command line and returns the output.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( System.popen( "ping -c 3 www.google.com" ) );<br>
<br>
//output<br>
/*<br>
PING www.l.google.com (74.125.230.81): 56 data bytes<br>
64 bytes from 74.125.230.81: icmp_seq=0 ttl=57 time=13.421 ms<br>
64 bytes from 74.125.230.81: icmp_seq=1 ttl=57 time=13.054 ms<br>
64 bytes from 74.125.230.81: icmp_seq=2 ttl=57 time=12.545 ms<br>
<br>
--- www.l.google.com ping statistics ---<br>
3 packets transmitted, 3 packets received, 0.0% packet loss<br>
round-trip min/avg/max/stddev = 12.545/13.007/13.421/0.359 ms<br>
<br>
*/<br>
</code></pre>

<b>note:</b><br>
If the command fails to execute for some reason returns <code>null</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<h2>getAvmplusVersion</h2>
<pre><code>public native static function getAvmplusVersion():String;<br>
</code></pre>
Returns the current version of AVM+ in the form <code>"1.0 d100"</code>.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "AVMplus version : " + System.getAvmplusVersion() ); //AVMplus version : 1.4 cyclone<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getRedtamarinVersion</h2>
<pre><code>public static function getRedtamarinVersion():String<br>
</code></pre>
Returns the current version of the RedTamarin API.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "RedTamarin version : " + System.getRedtamarinVersion() ); //RedTamarin version : 0.3.0<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getFeatures</h2>
<pre><code>public native static function getFeatures():String;<br>
</code></pre>
Returns the compiled in features of AVM+.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "AVMplus features :" )<br>
trace( System.getFeatures().split( ";" ).join( "\n" ) );<br>
<br>
/* output:<br>
<br>
AVMplus features :<br>
AVMSYSTEM_32BIT<br>
AVMSYSTEM_UNALIGNED_INT_ACCESS<br>
AVMSYSTEM_UNALIGNED_FP_ACCESS<br>
AVMSYSTEM_LITTLE_ENDIAN<br>
AVMSYSTEM_IA32<br>
AVMSYSTEM_MAC<br>
AVMFEATURE_DEBUGGER<br>
AVMFEATURE_ALLOCATION_SAMPLER<br>
AVMFEATURE_JIT<br>
AVMFEATURE_ABC_INTERP<br>
AVMFEATURE_EVAL<br>
AVMFEATURE_PROTECT_JITMEM<br>
AVMFEATURE_SHARED_GCHEAP<br>
AVMFEATURE_STATIC_FUNCTION_PTRS<br>
AVMFEATURE_MEMORY_PROFILER<br>
AVMFEATURE_CACHE_GQCN<br>
AVMTWEAK_EXACT_TRACING<br>
<br>
*/<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getRunmode</h2>
<pre><code>public native static function getRunmode():String;<br>
</code></pre>
Returns the current runmode.<br>
<br>
<b>note:</b><br>
Can returns "mixed", "jitordie", "jit", "interp", "unknown".<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getTimer</h2>
<pre><code>public native static function getTimer():uint;<br>
</code></pre>
Returns the number of milliseconds that have elapsed<br>
since the AMV+ started.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>readLine</h2>
<font color='orange'>blocking</font><br>
<pre><code>public native static function readLine():String;<br>
</code></pre>
Waits and returns all the characters entered by the user.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
trace( "what is your name ?" );<br>
var input:String = System.readLine();<br>
trace( "your name is \"" + input + "\"" );<br>
<br>
/* input1:<br>
     totoro<br>
<br>
     output:<br>
     your name is "totoro"<br>
*/<br>
<br>
/* input2:<br>
    トトロ<br>
<br>
     output:<br>
     your name is "ããã"<br>
*/<br>
</code></pre>

<b>note:</b><br>
Read <b>stdin</b>.<br>
The function will stop when it encounters <code>\n</code> or <code>EOF</code>.<br>
Does not support Unicode characters.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>trace</h2>
<pre><code>public native static function trace( a:Array ):void;<br>
</code></pre>
Writes arguments to the command line and returns to the line.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
System.trace( ["hello world"] ); //hello world<br>
System.trace( ["トトロ"] ); //トトロ<br>
</code></pre>

<b>note:</b><br>
Write to <b>stdout</b>.<br>
Support Unicode characters.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>write</h2>
<pre><code>public native static function write( s:String ):void;<br>
</code></pre>
Writes a string to the command line.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.System;<br>
<br>
System.write( "hello" );<br>
System.write( " world" );<br>
System.write( "\n" ); //hello world<br>
System.write( "ト" );<br>
System.write( "ト" );<br>
System.write( "ロ" );<br>
System.write( "\n" ); //トトロ<br>
</code></pre>

<b>note:</b><br>
Write to <b>stdout</b>.<br>
Support Unicode characters.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>writeLine</h2>
<pre><code>public static function writeLine( s:String ):void<br>
</code></pre>
Writes a string to the command line and returns to the line.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getStdinLength</h2>
<pre><code>hack_sys native static function getStdinLength():Number;<br>
</code></pre>
Returns the length of the stdin buffer.<br>
<br>
<b>note:</b><br>
not meant to be used directly.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>stdinRead</h2>
<font color='orange'>blocking</font><br>
<pre><code>hack_sys native static function stdinRead( length:uint ):ByteArray;<br>
</code></pre>
Reads the length of <code>bytes</code> from stdin.<br>
<br>
<b>note:</b><br>
not meant to be used directly.<br>
If the length is bigger that the data in the actual buffer<br>
you may end up being "blocked" (eg. wait for more data coming into the buffer).<br>
<br>
You should use<code>System.stdin.read()</code> or<code>System.stdin.readBinary()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>stdinReadAll</h2>
<font color='orange'>blocking</font><br>
<pre><code>hack_sys native static function stdinReadAll():ByteArray;<br>
</code></pre>
Reads the stdin till EOF is reached.<br>
<br>
<b>note:</b><br>
not meant to be used directly.<br>
You should use<code>System.stdin.read()</code> or<code>System.stdin.readBinary()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>stdoutWrite</h2>
<pre><code>hack_sys native static function stdoutWrite( bytes:ByteArray ):void;<br>
</code></pre>
Writes <code>bytes</code> to the stdout.<br>
<br>
<b>note:</b><br>
not meant to be used directly.<br>
You should use<code>System.stdout.write()</code> or<code>System.stdout.writeBinary()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>stderrWrite</h2>
<pre><code>hack_sys native static function stderrWrite( bytes:ByteArray ):void;<br>
</code></pre>
Writes <code>bytes</code> to the stderr.<br>
<br>
<b>note:</b><br>
not meant to be used directly.<br>
You should use<code>System.stderr.write()</code> or<code>System.stderr.writeBinary()</code>.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>debugger</h2>
<pre><code>public native static function debugger():void;<br>
</code></pre>
Enters debugger.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isDebugger</h2>
<pre><code>public native static function isDebugger():Boolean;<br>
</code></pre>
Tests if the current program is compiled with debugger flags.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>forceFullCollection</h2>
<pre><code>public native static function forceFullCollection():void;<br>
</code></pre>
Initiate a garbage collection<br>
(future versions will not return before completed).<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>queueCollection</h2>
<pre><code>public native static function queueCollection():void;<br>
</code></pre>
Queue a garbage collection request.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>disposeXML</h2>
<pre><code>public native static function disposeXML( xml:XML ):void;<br>
</code></pre>
Makes the specified XML object immediately available for garbage collection.<br>
<br>
<b>note:</b><br>
This method will remove parent and child connections between<br>
all the nodes for the specified XML node.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />