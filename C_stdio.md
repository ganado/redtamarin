<a href='Hidden comment: 
Because we are defining libraries for Tamarin we can not really use asdoc to document the source code.
So the rule is to document everything in the wiki page.
Yeah it sucks because we have to sync by hand, we"ll try to automate it later.

on the source code file, we use only one comment

/* documentation: http://code.google.com/p/redtamarin/wiki/C_stdio */
'></a>

# About #
Input and Output operations on streams and files.

**package:** `C.stdio.*`

**product:** redtamarin 0.3

**since:** 0.3.0

**references:**
  * http://www.dinkumware.com/manuals/default.aspx?manual=compleat&page=stdio.html
  * http://en.wikipedia.org/wiki/Stdio.h


---

# Constants #

| **FILENAME\_MAX** | Maximum size in bytes of the longest filename string that the implementation guarantees can be opened. |
|:------------------|:-------------------------------------------------------------------------------------------------------|
| **PATH\_MAX**     | Maximum number of bytes in a pathname.                                                                 |

**since:** 0.3.0



---

# Functions #

## remove ##
```
public function remove( filename:String ):int
```
Remove a file.

**note:**<br>
under WIN32, you can get a "File Permission Denied" if you try to remove a directory path<br>
you should instead use <code>rmdir()</code> in <a href='http://code.google.com/p/redtamarin/wiki/C_unistd#rmdir'>C.unistd</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>rename</h2>
<pre><code>public function rename( oldname:String, newname:String ):int<br>
</code></pre>
Rename a file.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<hr />