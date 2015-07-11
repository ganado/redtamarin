## Introduction ##

Some personal notes about Tamarin, can be howto, recipe, things to remember, etc.


## I consider this code C/C++ ##

When you're a noob like me and try to find informations on the web,  forums etc.<br>
you will see two camps: the pure ANSI C crowd vs the pure C++ crowd<br>
and yes I understand that C and C++ are not the same thing.<br>
<br>
and it get even get worst when you include the different version of C, C89 vs C99,<br>
the different operating systems, C under Linux vs C under Windows, etc.<br>
<br>
to be honest, I don't give a shit<br>
I need my code to work with Tamarin without breaking it<br>
and still being cross-platform,<br>
so whatever Tamarin does, I will follow the same path.<br>
<br>
Now in the case of Tamarin, I consider the code to be C/C++, and here why<br>
<br>
Most of the time they keep the type used to the strict minimum,<br>
for ex if a C++ String could be used, a char array is used,<br>
or if a C++ vector could be used, again a char array is used,<br>
etc.<br>
<br>
My logic is that the guys from Adobe, Mozilla, etc. know a hell lot better than me about C/C++<br>
do they try to make things harder for the noob like me?<br>
no I don't think so<br>
so why they don't use things that to me look simpler ?<br>
it must have to do with cross platform portability and performance<br>
<br>
So, for things like VMPI, let's say the low-level stuff, even if things are structured as C++ classes,<br>
the underlying implementation is what I could call "pure C".<br>
<br>
And only when you arrive around native classes implementations that you can see<br>
more advanced types used, like <code>Stringp</code>, <code>ArrayObject</code>, etc.<br>
<br>
Yeah, depending at which "layer" you are working<br>
the code will feel C'ish or C++'ish<br>
hence why I call that C/C++.<br>
<br>
<br>
<h2>C++ Constructor(s) vs AS3 Constructor</h2>

Native classes can be a kind of special beast sometime,<br>
and here the constructor case is very very special.<br>
<br>
If you come from an AS3 background and you spend a bit of time<br>
researching how you can optimize your code, you probably heard<br>
Adobe telling you that you should keep your constructors "light"<br>
as "don't initialize too much code in your AS3 constructors".<br>
<br>
see <a href='Tamarin.md'>Tamarin</a> - Performance Tuning (slide 43)<br>
<pre><code> Interpret vs. JIT<br>
  * We make a simple "hotspot"-like decision about wether to interpret or JIT<br>
  * Initialization functions ($init, $cinit) are interpreted<br>
  * Everything else is JIT<br>
  * Upshot: Don't put performance-intensive code in class initialization<br>
</code></pre>

OK, that's one part of the story, here the second part from a C++ point of view.<br>
<br>
When you define a native class, you basically define 4 things<br>
<ul><li>a C++ base class, ex: <code>ByteArrayClass</code>
</li><li>a C++ instance class, ex: <code>ByteArrayObject</code>
</li><li>an AS3 class definition using the keyword <code>native</code>, ex: <code>ByteArray.as</code>
</li><li>an AS3 metadata that link the C++ definitions to the AS3 definition<br>
<pre><code>package flash.utils<br>
{<br>
    [native(cls="::avmshell::ByteArrayClass", instance="::avmshell::ByteArrayObject", methods="auto")]<br>
    public class ByteArray<br>
    {<br>
    //...<br>
    }<br>
}<br>
</code></pre></li></ul>


here some basic rules<br>
<ul><li>any static native AS3 definition will be associated with the base class (eg. <code>ByteArrayClass</code>)<br>
</li><li>any non-static native AS3 definition will be associated with the instance class (eg. <code>ByteArrayObject</code>)</li></ul>

So, for example, if you need only native static in an AS3 class, you just need one base class and you can forgot the instance class.<br>
<br>
And here the unspoken rules:<br>
<ul><li>the C++ base class <code>createInstance()</code> method is used to create an instance of the class<br>
</li><li>the C++ instance class constructor is independent of the AS3 constructor<br>
</li><li>the C++ instance class can have more than one constructor</li></ul>

So, for example, if you want from the AS3 constructor to pass custom arguments to the C++ side you will end up using a method.<br>
<br>
See for example the Bitmap and BitmapData class<br>
<pre><code>package flash.display<br>
{<br>
    public class Bitmap extends DisplayObject<br>
    {<br>
        public function Bitmap( bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false )<br>
        {<br>
            super();<br>
            ctor();<br>
        }<br>
<br>
        private native function ctor( bitmapData:BitmapData, pixelSnapping:String, smoothing:Boolean ):void;<br>
<br>
        //...<br>
<br>
    }<br>
}<br>
</code></pre>

<pre><code>package flash.display<br>
{<br>
    public class BitmapData implements IBitmapDrawable<br>
    {<br>
        public function Bitmap( width:int, height:int, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF )<br>
        {<br>
            super();<br>
            ctor();<br>
        }<br>
<br>
        private native function ctor( width:int, height:int, transparent:Boolean, fillColor:uint ):void;<br>
<br>
        //...<br>
<br>
    }<br>
}<br>
</code></pre>

The AS3 constructor does not map to the C++ class constructor.<br>
<br>
And with that, you can setup your native class with different constructors and/or optional constructors.<br>
<br>
<br>
<br>
<h2>Creating a ByteArray on the C++ side</h2>

obsolete<br>
<pre><code>ByteArrayObject* bytes;<br>
<br>
//you first need a ByteArray class that you instanciate from your nativeID definition<br>
ByteArrayClass *ba = (ByteArrayClass*)toplevel()-&gt;getBuiltinExtensionClass(NativeID::abcclass_flash_utils_ByteArray);<br>
<br>
//default arguments<br>
Atom args[1] = {nullObjectAtom};<br>
<br>
//then you build the ByteArray instance from a ScriptObject<br>
bytes = (ByteArrayObject*)AvmCore::atomToScriptObject(ba-&gt;construct(0, args));<br>
<br>
//not sure if this is necessary but seems safer to reset the ByteArray to zero<br>
bytes-&gt;setLength(0);<br>
</code></pre>

now you can do that (much much simpler)<br>
<pre><code>ByteArrayObject* bytes = toplevel-&gt;byteArrayClass()-&gt;constructByteArray();<br>
//always reset it to zero<br>
bytes-&gt;set_length(0);<br>
</code></pre>

the AS3 equivalent is<br>
<pre><code>var bytes:ByteArray = new ByteArray();<br>
</code></pre>



<h2>Quickly get the size of a native object</h2>

use <b>flash.sampler.getSize()</b>

for example<br>
<pre><code>import avmplus.Socket;<br>
import flash.sampler.*;<br>
<br>
var sock:Socket = new Socket();<br>
var size:Number = getSize( sock );<br>
trace( "socket = " + sock );<br>
trace( size + " bytes" );<br>
<br>
//output<br>
//socket = [object Socket]<br>
//1080 bytes<br>
</code></pre>