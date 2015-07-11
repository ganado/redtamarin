<a href='Hidden comment: 
Because we are defining libraries for Tamarin we can not really use asdoc to document the source code.
So the rule is to document everything in the wiki page.
Yeah it sucks because we have to sync by hand, we"ll try to automate it later.

on the source code file, we use only one comment

/* documentation: http://code.google.com/p/redtamarin/wiki/C_stdlib */
'></a>

# About #
POSIX operating system API.

**package:** `C.unistd.*`

**product:** redtamarin 0.3

**since:** 0.3.0

**references:**
  * http://www.opengroup.org/onlinepubs/009695399/basedefs/unistd.h.html
  * http://en.wikipedia.org/wiki/Unistd.h


---

# Constants #

## Access ##
| **F\_OK**  | Check for existence. |
|:-----------|:---------------------|
| **X\_OK**  | Check for execute permission. |
| **W\_OK**  | Check for write permission. |
| **R\_OK**  | Check for read permission. |

**since:** 0.3.0

## File type ##
| **S\_IFMT**   | Type of file mask. |
|:--------------|:-------------------|
| **S\_IFIFO**   | Named pipe (fifo). |
| **S\_IFCHR**  | Character special (device). |
| **S\_IFDIR**  | Directory.         |
| **S\_IFBLK**  | Block special (device). |
| **S\_IFREG**  | Regular file.      |
| **S\_IFLNK**  | Symbolic link.     |
| **S\_IFSOCK** | Socket.            |

**since:** 0.3.0

## File mode ##
| **S\_IRWXU** | Read/Write/Execute mask for owner. |
|:-------------|:-----------------------------------|
| **S\_IRUSR** | Read permission for owner.         |
| **S\_IWUSR** | Write permission for owner.        |
| **S\_IXUSR** | Execute permission for owner.      |
| **S\_IRWXG** | Read/Write/Execute mask for group. |
| **S\_IRGRP** | Read permission for group.         |
| **S\_IWGRP** | Write permission for group.        |
| **S\_IXGRP** | Execute permission for group.      |
| **S\_IRWXO** | Read/Write/Execute mask for other. |
| **S\_IROTH** | Read permission for other.         |
| **S\_IWOTH** | Write permission for other.        |
| **S\_IXOTH** | Execute permission for other.      |
| **S\_IREAD** | Read permission for all (backward compatability). |
| **S\_IWRITE** | Write permission for all (backward compatability). |
| **S\_IEXEC** | Execute permission for all (backward compatability). |

**since:** 0.3.0



---

# Functions #

## access ##
```
public function access( path:String, mode:int ):int
```
Determine accessibility of a file.

**since:** 0.3.0


## chdir ##
```
public function chdir( path:String ):int
```
Change working directory.

**since:** 0.3.0

## chmod ##
```
public function chmod( path:String, mode:int ):int
```
Change mode of a file.

**note:**<br>
under WIN32 chmod is limited, you will only be able to set read or write at the user level<br>
<code>chmod( "myfile.txt", S_WRITE );</code><br>
will be the same as<br>
<code>chmod( "myfile.txt", (S_IWUSR | S_IWGRP | S_IWOTH ) );</code>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getcwd</h2>
<pre><code>public function getcwd():String<br>
</code></pre>
Get the pathname of the current working directory.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>gethostname</h2>
<pre><code>public function gethostname():String<br>
</code></pre>
Get the name of the current host.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getlogin</h2>
<pre><code>public function getlogin():String<br>
</code></pre>
Get the login name of the current user.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getpid</h2>
<pre><code>public function getpid():int<br>
</code></pre>
Get the process ID.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>mkdir</h2>
<pre><code>public function mkdir( path:String ):int<br>
</code></pre>
Make directory.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>rmdir</h2>
<pre><code>public function rmdir( path:String ):int<br>
</code></pre>
Remove directory.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>sleep</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function sleep( milliseconds:uint ):void<br>
</code></pre>
Suspend execution for an interval of time.<br>
<br>
<b>note:</b><br>
<code>sleep()</code> in C usually use seconds, here we are using milliseconds.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>unlink</h2>
<pre><code>public function unlink( path:String ):int<br>
</code></pre>
Remove a directory entry.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />