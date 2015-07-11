<a href='Hidden comment: 
Because we are defining libraries for Tamarin we can not really use asdoc to document the source code.
So the rule is to document everything in the wiki page.
Yeah it sucks because we have to sync by hand, we"ll try to automate it later.

on the source code file, we use only one comment

/* documentation: http://code.google.com/p/redtamarin/wiki/C_string */
'></a>

# About #
String operations.

**package:** `C.string.*`

**product:** redtamarin 0.3

**since:** 0.3.0

**references:**
  * http://www.dinkumware.com/manuals/default.aspx?manual=compleat&page=string.html
  * http://en.wikipedia.org/wiki/String.h



---

# Functions #

## strerror ##
```
public function strerror( errnum:int ):String
```
Accepts an error number argument errnum and returns the corresponding message string.

**example:** basic usage
```
import C.string.*;

trace( "errno=2: " + strerror(2) ); //errno=2: No such file or directory
```

**since:** 0.3.0


## strlen ##
```
public function strlen( str:String ):uint
```
Find length of string.

**example:** basic usage
```
import C.string.*;

var word:String = "hello";
trace( "len: " + strlen(word) ); //len: 5
```

**since:** 0.3.0


## strmode ##
<font color='blue'>not native</font><br>
<pre><code>public function strmode( mode:int ):String<br>
</code></pre>
Returns a string describing file modes.<br>
<br>
Not part of the C standard lib, but part of GNU libc<br>
and pretty usefull function so we added it.<br>
<br>
<table><thead><th> char </th><th> meaning </th></thead><tbody>
<tr><td> -    </td><td> regular file </td></tr>
<tr><td> b    </td><td> block special file </td></tr>
<tr><td> c    </td><td> character special file </td></tr>
<tr><td> d    </td><td> directory </td></tr>
<tr><td> l    </td><td> symbolic link </td></tr>
<tr><td> n    </td><td> network special file (HP-UX) </td></tr>
<tr><td> p    </td><td> fifo (named pipe) </td></tr>
<tr><td> s    </td><td> socket  </td></tr>
<tr><td> ?    </td><td> some other file type </td></tr></tbody></table>

<b>example:</b> basic usage<br>
<pre><code>import C.string.*;<br>
<br>
//TODO<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<hr />