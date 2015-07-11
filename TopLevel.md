# About #

Represents the top level definitions (that you can use without using an **import**).

**package:** (anonymous package)

**product:** redtamarin 0.3

**since:** 0.3.0



---


# Methods #

## getClassByName ##
```
public function getClassByName( name:String, domain:Domain = null ):Class
```
Returns the class reference from a string class name.

**note:**<br>
this function is essential for when we run code with<br>
<ul><li>running scripts<br><code>./redshell file.as</code>
</li><li>read-eval-print mode<br><code>./redshell -repl</code>
</li><li>eval() call from within the API<br><code>System.eval( source )</code></li></ul>

in all those cases you can not use the <code>import</code> statement for fully qualified name<br>
<code>import avmplus.System; //will not work</code>

but you can use the <code>import</code> statement for non qualified name<br>
<code>import avmplus.*; //will work</code>

also you can call functions declared at the anonymous package level<br>
(that's why you can call <code>getClassByName()</code> without the need of an import).<br>
<br>
To invoke classes defined in <code>builtin.abc</code> and <code>toplevel.abc</code><br>
or any other <code>*.abc</code> loaded in memory for that matter<br>
in the shell you can use this workaround<br>
<pre><code>var sys:* = getClassByName( "avmplus.System" );<br>
trace( sys.argv ); //for System.argv<br>
</code></pre>

this workaround will also work for when you have an ambiguity in the class name<br>
(eg. 2 classes with the same name in a different package that you want to import)<br>
<pre><code>var sys:*  = getClassByName( "avmplus.System" );<br>
var fsys:* = getClassByName( "flash.system.System" );<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>loadLibrary</h2>
<pre><code>public function loadLibrary( name:String, domain:Domain = null  ):void<br>
</code></pre>
Load an external library into memory.<br>
<br>
TODO (more documentation).<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<h2>print</h2>
<pre><code>public function print( ...s )<br>
</code></pre>
Writes arguments to the command line and returns to the line.<br>
<br>
<b>note:</b><br>
nonstandard extensions to ECMAScript.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>trace</h2>
<pre><code>public function trace( ...s )<br>
</code></pre>
Writes arguments to the command line and returns to the line.<br>
<br>
<b>note:</b><br>
nonstandard Flash Player extensions.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>readLine</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function readLine():String<br>
</code></pre>
Waits and returns all the characters entered by the user.<br>
<br>
<b>since:</b> 0.3.0