<a href='Hidden comment: 
Here we can use asdoc to document the source code.
So the rule is to document the side notes in the wiki page.

/* more in depth informations: http://code.google.com/p/redtamarin/wiki/StandardStream */
'></a>

# About #
Defines a Standard Stream (either stdout, stderr or stdin).

**interface** `avmplus::StandardStream`

**product:** redtamarin 0.3

**since:** 0.3.2


see: http://en.wikipedia.org/wiki/Standard_streams


---

# Methods #

## read ##
```
function read( length:uint = 0 ):String;
```
Reads the amount of `length` (or all) from the stream in text mode.

**since:** 0.3.2


## readBinary ##
```
function readBinary( length:uint = 0 ):ByteArray;
```
Reads the amount of `length` (or all) from the stream in binary mode.

**since:** 0.3.2


## write ##
```
function write( data:String ):void;
```
Writes string data to the stream in text mode.

**since:** 0.3.2



## writeBinary ##
```
function writeBinary( bytes:ByteArray ):void;
```
Writes binary data to the stream in binary mode.

**since:** 0.3.2



## toString ##
```
function toString():String;
```
Returns the stream type.

**since:** 0.3.2



---


# Implementations #

We have 3 classes implementing the 3 standard streams<br>
<code>StandardStreamOut</code> implements <b>stdout</b><br>
<code>StandardStreamErr</code> implements <b>stderr</b><br>
<code>StandardStreamIn</code> implements <b>stdin</b>

You don't need to instantiate those classes yourself as there are accessible as properties<br>
form the <code>System</code> class.<br>
see <a href='System#stdout.md'>System.stdout</a><br>
see <a href='System#stderr.md'>System.stderr</a><br>
see <a href='System#stdin.md'>System.stdin</a>


<code>StandardStreamOut</code> and <code>StandardStreamErr</code> will throw errors with the methods <code>read()</code> and <code>readBinary()</code>.<br>
<br>
<code>StandardStreamIn</code> will throw errors with the methods <code>write()</code> and <code>writeBinary()</code>.<br>
<br>
<br>
<br>

<h1>Details</h1>

You will need to use some functions in <a href='C_stdio.md'>C.stdio</a> for some special cases.<br>
<br>
<h2>Pipe and Redirection</h2>

see: <a href='http://en.wikipedia.org/wiki/Redirection_(computing'>http://en.wikipedia.org/wiki/Redirection_(computing</a>)<br>
<br>
<pre><code>command1 | command2<br>
</code></pre>
here the <code>pipe</code> will redirect the stdout of command1 to the stdin of command2<br>
<br>
Under POSIX, the terminal is smart enough to make the difference between <code>TEXT</code> and <code>BINARY</code> data.<br>
<br>
Under WIN32, the command prompt is a bit different, you have to tell him if you want <code>TEXT</code> or <code>BINARY</code> data.<br>
<br>
TODO<br>
