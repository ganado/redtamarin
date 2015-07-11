<a href='Hidden comment: 
Because we are defining libraries for Tamarin we can not really use asdoc to document the source code.
So the rule is to document everything in the wiki page.
Yeah it sucks because we have to sync by hand, we"ll try to automate it later.

on the source code file, we use only one comment

/* documentation: http://code.google.com/p/redtamarin/wiki/C_stdlib */
'></a>

# About #
Standard library definitions.

**package:** `C.stdlib.*`

**product:** redtamarin 0.3

**since:** 0.3.0

**references:**
  * http://www.dinkumware.com/manuals/default.aspx?manual=compleat&page=stdlib.html
  * http://en.wikipedia.org/wiki/Stdlib.h


---

# Constants #

| **EXIT\_SUCCESS** | Success termination code. |
|:------------------|:--------------------------|
| **EXIT\_FAILURE** | Failure termination code. |

**since:** 0.3.0



---

# Functions #

## abort ##
```
public function abort():void
```
Cause abnormal program termination.

**since:** 0.3.0


## atexit ##
<font color='red'>not implemented</font><br>
<pre><code>public function atexit( fn:Function ):void<br>
</code></pre>
Add a function to be executed on exit.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>exit</h2>
<pre><code>public function exit( status:int = -1 ):void<br>
</code></pre>
Terminate program execution.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getenv</h2>
<pre><code>public function getenv( name:String ):String<br>
</code></pre>
Retrieve an environment variable.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import C.stdlib.*;<br>
<br>
var home:String = getenv( "HOME" );<br>
trace( "user home: " + home ); //user home: /Users/somebody<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>setenv</h2>
<pre><code>public function setenv( name:String, value:String, overwrite:Boolean = false ):int<br>
</code></pre>
Add or change an environment variable.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>unsetenv</h2>
<pre><code>public function unsetenv( name:String ):int<br>
</code></pre>
Remove an environment variable.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>realpath</h2>
<pre><code>public function realpath( path:String ):String<br>
</code></pre>
Resolve a pathname.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>system</h2>
<pre><code>public function system( command:String ):int<br>
</code></pre>
Issue a command.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<hr />