## Introduction ##

A **C library** in AS3 is a bit of a challenge, there is some things you can translate and other things you can't.

Most of those libraries are implemented within a single C++ native class but we consider the AS3 class internal and static.

## Documentation ##

Here few things to know on how those libs are documented.

Because we are defining libraries for Tamarin we can not really<br>
use asdoc to document the source code (well.. we use it a bit).<br>
<br>
So the rule is to document everything in the wiki pages.<br>
<br>
<b>The general rule:</b>

Everything you see in the wiki pages is considered a native implementations,<br>
you can access it in AS3 but the code doing the real work is in C/C++.<br>
<br>
If you don't see it in the wiki pages, that means either we decided to ignore it<br>
and it is unlikely to be implemented.<br>
<br>
<b>Here some special case:</b>

<font color='blue'>not native</font><br>
that means this particular code is implemented in AS3.<br>
<br>
<font color='red'>not implemented</font><br>
that means this particular code is planed for implementation but not implemented yet.<br>
<br>
<font color='orange'>blocking</font><br>
that means the function is blocking (eg. block the flow of the program).<br>
<br>
<br>
Off course, if you don't see something that should be implemented or<br>
see something wrongly documented, etc.  <a href='http://code.google.com/p/redtamarin/issues/entry'>please create an issue</a>.<br>
<br>
<h2>Default package</h2>

Everything that is considered being a C library include reside in the <code>C.*</code> root package.<br>
<br>
We use the name of include for the package containing the internal class definition and the function definition.<br>
<br>
For example, with <code>stdlib.h</code>
<ul><li>the name of the package will be <code>C.stdlib.*</code>
</li><li>the internal class definition will be <code>internal class __stdlib</code>
</li><li>and we will declare the functions at the package level <code>public function abort() {}</code></li></ul>

<h2>Library setup</h2>

Here the AS3 basic setup for <code>stdlib.h</code>

<pre><code>package C.stdlib<br>
{<br>
    <br>
    [native(cls="::avmshell::StdlibClass", methods="auto")]<br>
    internal class __stdlib<br>
    {<br>
        public native static function get EXIT_SUCCESS():int;<br>
        public native static function get EXIT_FAILURE():int;<br>
<br>
        public native static function abort():void;                    //void abort(void);<br>
        public native static function exit( status:int = 0 ):void;     //void exit(int status);<br>
        public native static function __system( command:String ):int;  //int system(const char *s);<br>
    }<br>
    <br>
    /** Success termination code. */<br>
    public const EXIT_SUCCESS:int = __stdlib.EXIT_SUCCESS;<br>
<br>
    /** Failure termination code.*/<br>
    public const EXIT_FAILURE:int = __stdlib.EXIT_FAILURE;<br>
    <br>
    /**<br>
     * Cause abnormal program termination.<br>
     */<br>
    public function abort():void<br>
    {<br>
        __stdlib.abort();<br>
    }<br>
    <br>
    /**<br>
     * Terminate program execution.<br>
     */<br>
    public function exit( status:int = 0 ):void<br>
    {<br>
        __stdlib.exit( status );<br>
    }<br>
<br>
    /**<br>
     * Issue a command.<br>
     */<br>
    public function system( command:String ):int<br>
    {<br>
        return __stdlib.__system( command );<br>
    }   <br>
}<br>
</code></pre>


The usage is pretty simple<br>
<pre><code>import C.stdlib.*;<br>
<br>
if( myprogram.ending )<br>
{<br>
    exit( EXIT_SUCCESS );<br>
}<br>
<br>
</code></pre>

so why are we defining it like that ?<br>
<br>
in short, because it's easier in Tamarin to link a native class to an AS3 class instead of linking each function to a particular C++ function call.<br>
<br>
Yes, it add a bit of overhead (the function redirection) when you call a function, but really it is small that you would probably never notice it (in term of speed).<br>
<br>
<h2>Constants</h2>

Why on earth are we using native getters instead of simply declaring an AS3 constant ?<br>
<br>
make sens<br>
<pre><code>public const EXIT_SUCCESS:int = 0;<br>
public const EXIT_FAILURE:int = 1;<br>
</code></pre>

look insane<br>
<pre><code>public const EXIT_SUCCESS:int = __stdlib.EXIT_SUCCESS; //public native static function get EXIT_SUCCESS():int;<br>
public const EXIT_FAILURE:int = __stdlib.EXIT_FAILURE;  //public native static function get EXIT_FAILURE():int;<br>
</code></pre>

So, yes we do it like that and yeah I can admit it looks insane but we have  good reason for that :).<br>
<br>
It is because how C works cross platform.<br>
<br>
It does not happen all the time, it is more or less standard, but sometimes for the same constant definition, depending on which OS you are compiling for, the value will be different.<br>
<br>
<a href='http://lkml.indiana.edu/hypermail/linux/kernel/0312.2/1241.html'>here a famous example by Linus Torvalds</a>
<pre><code>[...]<br>
- the original errno.h used different error numbers than "original UNIX"<br>
<br>
I know this because I cursed it later when it meant that doing things <br>
like binary emulation wasn't as trivial - you had to translate the <br>
error numbers.<br>
<br>
- same goes for "signal.h": while a lot of the standard signals are well <br>
documented (ie "SIGKILL is 9"), historically we had lots of confusion <br>
(ie I think "real UNIX" has SIGBUS at 10, while Linux didn't originally <br>
have any SIGBUS at all, and later put it at 7 which was originally <br>
SIGUNUSED.<br>
[...]<br>
</code></pre>

Our goal is to be cross platform, so instead on relying on the value, we are relying on the naming of the constant.<br>
<br>
We don't care if for whatever reason your favorite Linux distro define <code>EXIT_SUCCESS</code> as <code>-1</code> instead of the standard <code>0</code>,<br>
what we do care about is that we reuse the name <code>EXIT_SUCCESS</code> and its meaning <code>it is a successful exit of the program</code>.<br>
<br>
The overhead ? well ... not that much, on the AS3 side you can define a constant only once, and so as soon as you open the package the constant is defined by the call to the native getter, so yeah a little bit of overhead but this would happen only once.<br>
<br>
<h2>Package Level Definitions</h2>

In C you don't really have classes definitions, the <code>*.h</code> includes are like a bunch of functions put together (hey don't flame me if you're a C puriste),<br>
so the logic has been to do the same on the AS3 side, at the package level we declare more or less the same bunch of functions.<br>
<br>
The logic is if in C you include a header file and so have access to all the functions declared in that particular include,<br>
in AS3 if you open a package then you have access to all the functions declared in that particular package.<br>
<br>
In short, at the package level you have <b>function</b> and/or <b>constant</b>  definitions.<br>
<br>
<h2>Interaction with Other Libraries</h2>

If you need C definitions as helper for another native class implementation, adding them in the C libraries is the good thing to do.<br>
<br>
Example with sockets.<br>
<br>
we have <b>avmplus::Socket</b> which is a socket class implementation, but because this class may need some C definitions, we add them in the <b>C.socket</b> package.<br>
<br>
here a default socket<br>
<pre><code>import avmplus.Socket;<br>
<br>
var sock:Socket = new Socket();<br>
</code></pre>
this will create by default a stream socket (TCP protocol).<br>
<br>
if we need a custom socket<br>
<pre><code>import C.socket.*;<br>
import avmplus.Socket;<br>
<br>
var sock:Socket = new Socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP );<br>
</code></pre>
this will create a datagram socket (UDP protocol).<br>
<br>
You can see <code>C.socket.*</code> as a helper for the <b>Socket</b> class.<br>
<br>
<br>
<br>
<br>
<h2>The Other Stuff</h2>

<b>passing references, pointers</b><br>
not gonna happen, it is much much more simple to just pass and returns values.<br>
<br>
<b>returning struct</b><br>
it could happen, but for now we decided to not do that, we stick to builtin AS3 types.