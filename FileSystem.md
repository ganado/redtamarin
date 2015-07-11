<a href='Hidden comment: 
Here we can use asdoc to document the source code.
So the rule is to document the side notes in the wiki page.

/* more in depth informations: http://code.google.com/p/redtamarin/wiki/FileSystem */
'></a>

# About #
Provides methods to access and manipulate computer files, directories, paths and data.

**class:** `avmplus::FileSystem`

**product:** redtamarin 0.3

**since:** 0.3.0

**note:**
  * this class replace `avmplus::File`
  * everything is blocking
  * no support for unicode filename yet (eg. WIN32 use `char` not `wchar`
  * it's pretty "raw", no optimizations of any kind (eg. directories traversal)
  * no support for symlink, alias, shortcut

**vocabulary:**
```
WIN32
  C:\user\docs\Letter.txt

POSIX
  /home/user/docs/Letter.txt 
```
  * **filename** : uniquely identify an entry (file or directory) stored on the file system<br>(also <b>path</b>, <b>filepath</b>, etc.)<br>
<ul><li><b>component</b> : a part of the <code>filename</code>
</li><li><b>root</b> : the first component of an absolute <code>filename</code>
</li><li><b>basename</b> : last component of a <code>filename</code>
</li><li><b>dirname</b> :  directory component of a <code>filename</code>
</li><li><b>extension</b> : the suffix part of the <code>basename</code> (in general starting with a <code>"."</code>)</li></ul>

here the different systems we have to support<br>
<pre><code>WIN32<br>
  C:\user\docs\Letter.txt<br>
  C:/user/docs/Letter.txt<br>
  A:Picture.jpg<br>
<br>
POSIX<br>
  /home/user/docs/Letter.txt<br>
  hostname:/directorypath/resource<br>
  smb://hostname/directorypath/resource<br>
<br>
UNC<br>
  \\ComputerName\SharedFolder\Resource<br>
<br>
UNCW (Long UNC)<br>
  \\?\UNC\ComputerName\SharedFolder\Resource<br>
  \\?\C:\File<br>
</code></pre>

<b>references:</b>
<ul><li><a href='http://en.wikipedia.org/wiki/File_system'>wikipedia File System</a>
</li><li><a href='http://en.wikipedia.org/wiki/Path_(computing)'>wikipedia Path</a>
</li><li><a href='http://en.wikipedia.org/wiki/Filename'>wikipedia FileName</a>
</li><li><a href='http://en.wikipedia.org/wiki/Filename_extension'>wikipedia Filename extension</a></li></ul>

<hr />

<h1>Constants</h1>

<h2>currentDirectory</h2>
<pre><code>public static const currentDirectory:String<br>
</code></pre>
A special path component meaning "this directory".<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>parentDirectory</h2>
<pre><code>public static const parentDirectory:String<br>
</code></pre>
A special path component meaning "the parent directory".<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>extensionSeparator</h2>
<pre><code>public static const extensionSeparator:String<br>
</code></pre>
The character used to identify a file extension.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h1>Properties</h1>

<h2>homeDirectory</h2>
<pre><code>public static function get homeDirectory():String<br>
</code></pre>
The user's directory.<br>
<br>
<b>note:</b><br>
Gives different results depending on the OS.<br>
<table><thead><th> OS </th><th> Path </th></thead><tbody>
<tr><td> Windows NT </td><td> <code>&lt;root&gt;\WINNT\Profiles\&lt;username&gt;</code> </td></tr>
<tr><td> Windows 2000/XP/2003 </td><td> <code>&lt;root&gt;\Documents and Settings\&lt;username&gt;</code> </td></tr>
<tr><td> Windows Vista/7 </td><td> <code>&lt;root&gt;\Users\&lt;username&gt;</code> </td></tr>
<tr><td> Mac OS X </td><td> <code>/Users/&lt;username&gt;</code> </td></tr>
<tr><td> Linux </td><td> <code>/home/&lt;username&gt;</code> </td></tr>
<tr><td> Unix-like </td><td> <code>/var/users/&lt;username&gt;</code> </td></tr>
<tr><td> Unix-like </td><td> <code>/u01/&lt;username&gt;</code> </td></tr>
<tr><td> Unix-like </td><td> <code>/usr/&lt;username&gt;</code> </td></tr>
<tr><td> Unix-like </td><td> <code>/user/&lt;username&gt;</code> </td></tr>
<tr><td> Unix-like </td><td> <code>/users/&lt;username&gt;</code> </td></tr></tbody></table>

For Windows, we will look for <code>%USERPROFILE%</code> as a standard.<br>
for OSX and Linux, we will look for <code>$HOME</code> as a standard,<br>
and if not found, then we will iterate for <code>/var/users/&lt;username&gt;</code> etc.<br>
and return the first existing directory or an empty string if nothing else found.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>rootDirectory</h2>
<pre><code>public static function get rootDirectory():String<br>
</code></pre>
The system root directory.<br>
<br>
<b>note:</b><br>
Gives different results depending on the OS.<br>
<br>
For WIN32, will returns the drive where the system is installed (usually <code>"C:\\"</code>).<br>
<br>
For POSIX, will always returns <code>"/"</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>drives</h2>
<pre><code>public static function get drives():Array<br>
</code></pre>
Returns an array of drives.<br>
<br>
<b>note:</b><br>
Will not work exactly the same between POSIX and WIN32<br>
<br>
with POSIX it will always returns an empty array, eg. <code>[  ]</code><br>
<br>
with WIN32 it will returns the <code>available</code> drives letter<br>
eg. <code>[ "C:", "D:" ]</code><br>
<code>available</code> does not necessary means <code>active</code>, you still need to test with <code>canAccess()</code><br>
to see if you can read a particular drive.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>lineEnding</h2>
<pre><code>public static function get lineEnding():String<br>
</code></pre>
The line-ending character sequence used by the host operating system.<br>
<br>
<b>note:</b><br>
WIN32 use <code>"\r\n"</code>.<br>
POSIX use <code>"\n"</code>.<br>
<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>separators</h2>
<pre><code>public static function get separators():Array<br>
</code></pre>
The character separators used by the operating system.<br>
<br>
<b>note:</b><br>
WIN32 use <code>"\"</code>, tolerant of <code>"/"</code>.<br>
POSIX use <code>"/"</code>.<br>
<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>pathSeparator</h2>
<pre><code>public static function get pathSeparator():String<br>
</code></pre>
The path separator used by the operating system.<br>
<br>
<b>note:</b><br>
WIN32 use <code>";"</code>.<br>
POSIX use <code>":"</code>.<br>
<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<hr />

<h1>Methods</h1>

<h2>exists</h2>
<pre><code>public native static function exists( filename:String ):Boolean;<br>
</code></pre>
Tests whether a <code>filename</code> exists.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.FileSystem;<br>
<br>
if( !FileSystem.exists( "/some/dummy/file" ) )<br>
{<br>
    //do something<br>
}<br>
else<br>
{<br>
    //do something else<br>
}<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>read</h2>
<pre><code>public native static function read( filename:String ):String;<br>
</code></pre>
Reads the file <code>filename</code> into memory and returns it as a String.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>write</h2>
<pre><code>public native static function write( filename:String, data:String ):void;<br>
</code></pre>
Writes the text <code>data</code> to the file <code>filename</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>readByteArray</h2>
<pre><code>public native static function readByteArray( filename:String ):ByteArray;<br>
</code></pre>
Reads the binary file <code>filename</code> into memory and returns it as a ByteArray.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>writeByteArray</h2>
<pre><code>public native static function writeByteArray( filename:String, bytes:ByteArray ):Boolean;<br>
</code></pre>
Writes the binary <code>bytes</code> to the file <code>filename</code> and returns true on success.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getFileMode</h2>
<pre><code>public native static function getFileMode( filename:String ):int;<br>
</code></pre>
Returns the <code>filename</code> mode.<br>
<br>
<b>note:</b><br>
Will not work exactly the same between POSIX and WIN32<br>
<br>
with POSIX you will want to get the file mode and then apply an additional mode,<br>
it's more granular as you can choose from <code>USR</code>, <code>GRP</code> and <code>OTH</code><br>
<pre><code>var mode:int = FileSystem.getFileMode( "myfile.txt" ); // -r--r--r--<br>
chmod( "myfile.txt", (mode | S_IWUSR ) );              // -rw-r--r--<br>
</code></pre>
<br>
with WIN32, you have only read or write access, and write imply read<br>
(you can not have a file write-only) and so by default we map<br>
the <code>USR</code> access to <code>GRP</code> and <code>OTH</code>
<pre><code>var mode:int = FileSystem.getFileMode( "myfile.txt" ); // -r--r--r--<br>
chmod( "myfile.txt", (mode | S_IWUSR ) );              // -rw-rw-rw-<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getFileSize</h2>
<pre><code>public native static function getFileSize( filename:String ):Number;<br>
</code></pre>
Returns the file <code>filename</code> size in bytes.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getDirectorySize</h2>
<pre><code>public static function getDirectorySize( filename:String, recursive:Boolean = true, includeHidden:Boolean = true ):Number<br>
</code></pre>
Returns the directory <code>filename</code> size in byte (adding all its files size)<br>
and if <code>recursive</code> add the size of any child directory.<br>
<br>
<b>note:</b><br>
By default will count the size of hidden entries (<code>includeHidden=true</code>).<br>
By default will count the size of all sub-directories (<code>recursive=true</code>),<br>
to get the size of the current file entries without the sub-directories you need to set <code>recursive=false</code>.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>//our directory structure<br>
/*<br>
test3<br>
  |_ .DS_Store<br>
  |_ Indie Game Design Do-s and Don't-s A Manifesto.pdf<br>
  |_ kamoshida20080315.pdf<br>
  |_ metaprog-100928014929-phpapp01.pdf<br>
  |_ nexusone-userguide.pdf<br>
  |_ NTFS-3G User Guide.pdf<br>
  |_ Obfuscation of The Standard XOR Encryption Algorithm.pdf<br>
  |_ others<br>
      |_ .DS_Store<br>
      |_ flash_player_10_security.pdf<br>
      |_ flash_player_6_security.pdf<br>
      |_ flash_player_7_security.pdf<br>
      |_ flash_player_8_security.pdf<br>
      |_ flash_player_9_security.pdf<br>
*/<br>
<br>
//we don't include hidden entries or sub-directories<br>
trace( "size = " + FileSystem.getDirectorySize( "test3", false, false ) + " bytes" ); //size = 15737563 bytes<br>
<br>
//we count the hidden entries but not the sub-directories<br>
trace( "size = " + FileSystem.getDirectorySize( "test3", false, true ) + " bytes" ); //size = 15743711 bytes<br>
<br>
//we count both the hidden entries and sub-directories - DEFAULT<br>
trace( "size = " + FileSystem.getDirectorySize( "test3", true, true ) + " bytes" ); //size = 19808855 bytes<br>
//OSX Get Info - Size: 19.8 MB on disk (19,808,855 bytes) for 12 items<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getLastModifiedTime</h2>
<pre><code>public native static function getLastModifiedTime( filename:String ):Date;<br>
</code></pre>
Returns the <code>filename</code> last modified time.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getBasenameFromPath</h2>
<pre><code>public static function getBasenameFromPath( filename:String ):String<br>
</code></pre>
Returns a filepath corresponding to the last path component of this<br>
<code>filename</code>, either a file or a directory.<br>
<br>
<b>note:</b><br>
If this <code>filename</code> already refers to the root directory,<br>
returns a filepath identifying the root directory;<br>
this is the only situation in which basename will return an absolute path.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getDirectoryFromPath</h2>
<pre><code>public static function getDirectoryFromPath( filename:String ):String<br>
</code></pre>
Returns the directory component of a <code>filename</code><br>
without the trailing path separator, or an empty string on error.<br>
<br>
<b>note:</b><br>
The function does not check for the existence of the path,<br>
so if it is passed a directory without the trailing <code>"\"</code>,<br>
it will interpret the last component of the path as a file and chomp it.<br>
<br>
This does not support relative paths.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getExtension</h2>
<pre><code>public static function getExtension( filename:String ):String<br>
</code></pre>
Returns the extension of <code>filename</code><br>
or an empty string if the file has no extension.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>canAccess</h2>
<pre><code>public static function canAccess( filename:String ):Boolean<br>
</code></pre>
Verify if we can access the <code>filename</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>canWrite</h2>
<pre><code> public static function canWrite( filename:String ):Boolean<br>
</code></pre>
Verify if we can write to the <code>filename</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>canRead</h2>
<pre><code>public static function canRead( filename:String ):Boolean<br>
</code></pre>
Verify if we can read the <code>filename</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>hasDriveLetter</h2>
<pre><code>public static function hasDriveLetter( filename:String ):Boolean<br>
</code></pre>
Tests if the <code>filename</code> contains a drive letter.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isRegularFile</h2>
<pre><code>public native static function isRegularFile( filename:String ):Boolean;<br>
</code></pre>
Test if the <code>filename</code> is a regular file.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isDirectory</h2>
<pre><code>public native static function isDirectory( filename:String ):Boolean;<br>
</code></pre>
Test if the <code>filename</code> is a directory.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isHidden</h2>
<pre><code>public static function isHidden( filename:String ):Boolean<br>
</code></pre>
Tests if the <code>filename</code> is considered <code>hidden</code> by the system.<br>
<br>
<b>note:</b><br>
Will not work exactly the same between POSIX, OSX and WIN32<br>
<br>
with POSIX a <code>filename</code> is considered hidden<br>
if the name start with a <code>.</code> (dot)<br>
<br>
with OSX a <code>filename</code> is considered hidden<br>
either if the name start with a <code>.</code> (dot)<br>
or the file attribute has the <code>hidden</code> flag.<br>
<br>
with WIN32 a filename` is considered hidden<br>
if there is a <code>hidden</code> flag in the file attributes.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isEmptyDirectory</h2>
<pre><code>public static function isEmptyDirectory( filename:String ):Boolean<br>
</code></pre>
Tests if the <code>filename</code> is an empty directory.<br>
<br>
<b>note:</b><br>
for both POSIX and WIN32 that means when listing files<br>
except <code>"."</code> (dot) and <code>".."</code>(dotdot), it returns no entry.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isSymbolicLink</h2>
<font color='red'>not implemented</font><br>
<pre><code>public native static function isSymbolicLink( path:String ):Boolean;<br>
</code></pre>
Test if the <code>filename</code> is a symbolic link.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isSeparator</h2>
<pre><code>public static function isSeparator( c:String ):Boolean<br>
</code></pre>
Tests if the character <code>c</code> is a separator.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isAbsolutePath</h2>
<pre><code>public static function isAbsolutePath( filename:String ):Boolean<br>
</code></pre>
Tests if <code>filename</code> is an absolute path.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isNotDotOrDotdot</h2>
<pre><code>public static function isNotDotOrDotdot( element:*, index:int, arr:Array ):Boolean<br>
</code></pre>
Utility function to filter out current directory "." and parent directory ".." from a file list.<br>
<br>
<b>note:</b><br>
You can not use the function by itself<br>
you need to pass it as an argument of <a href='#listFilesWithFilter.md'>listFilesWithFilter()</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>absolutePath</h2>
<pre><code>public static function absolutePath( filename:String ):String<br>
</code></pre>
Returns the absolute path of <code>filename</code>.<br>
<br>
<b>note:</b><br>
Reuse <code>realpath()</code> from <a href='C_stdlib.md'>C.stdlib</a>.<br>
Also the paths are normalized before getting their full path see <a href='#normalizePath.md'>normalizePath()</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>containsPath</h2>
<pre><code>public static function containsPath( parent:String, child:String ):Boolean<br>
</code></pre>
Returns true if <code>parent</code> contains <code>child</code>.<br>
Both paths are converted to absolute paths before doing the comparison.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>copyDirectory</h2>
<pre><code>public static function copyDirectory( origin:String, destination:String, overwrite:Boolean = false, includeHidden:Boolean = true, copyMode:Boolean = false ):Boolean<br>
</code></pre>
Recursively copy the content of an <code>origin</code> directory to a <code>destination</code> directory<br>
and returns true on success.<br>
<br>
<b>note:</b><br>
By default, does not <code>overwrite</code> the destination if it already exists.<br>
By default, does copy the hidden directories and files (<code>includeHidden=true</code>).<br>
By default, does not copy the directories and files mode (<code>copyMode=false</code>).<br>
<br>
If the <code>destination</code> does not exists it will be created (reuse <a href='#createDirectory.md'>createDirectory()</a>.<br>
<br>
If you need to copy only the files from a directory without recursively<br>
copying the sub-directories use <a href='#copyFiles.md'>copyFiles()</a>.<br>
<br>
Will throw errors if<br>
<ul><li>if the <code>origin</code> does not exists<br>
</li><li>if the <code>destination</code> already exists and <code>overwrite=false</code>
</li><li>if the <code>origin</code> is not a directory<br>
</li><li>if the <code>destination</code> already exists and is not a directory<br>
</li><li>if the <code>destination</code> is contained by the <code>origin</code></li></ul>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>copyFile</h2>
<pre><code>public static function copyFile( origin:String, destination:String, overwrite:Boolean = false, copyMode:Boolean = false ):Boolean<br>
</code></pre>
Copy an <code>origin</code> file to a <code>destination</code> file and returns true on success.<br>
<br>
<b>note:</b><br>
By default, does not <code>overwrite</code> the destination if it already exists.<br>
By default, does not copy the file mode (<code>copyMode=false</code>).<br>
<br>
This method does not distinguish between hidden and regular file.<br>
<br>
Will throw errors if<br>
<ul><li>if the <code>origin</code> does not exists<br>
</li><li>if the <code>destination</code> already exists and <code>overwrite=false</code>
</li><li>if the <code>origin</code> is a directory<br>
</li><li>if the <code>destination</code> exists and is a directory</li></ul>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>copyFiles</h2>
<pre><code>public static function copyFiles( origin:String, destination:String, filter:RegExp = null, overwrite:Boolean = false, includeHidden:Boolean = true, copyMode:Boolean = false ):Boolean<br>
</code></pre>
Copy all files matching the <code>filter</code> from directory <code>origin</code><br>
to <code>destination</code> directory and returns true on success.<br>
<br>
<b>note:</b><br>
By default, the regexp filter is <code>/.*/</code> (<code>filter=null</code> eg. all files).<br>
By default, does not <code>overwrite</code> the destination if it already exists.<br>
By default, does copy the hidden files (<code>includeHidden=true</code>).<br>
By default, does not copy the file mode (<code>copyMode=false</code>).<br>
<br>
Will throw errors if<br>
<ul><li>if the <code>origin</code> does not exists<br>
</li><li>if the <code>destination</code> does not exists<br>
</li><li>if the <code>origin</code> is not a directory<br>
</li><li>if the <code>destination</code> is not a directory</li></ul>

<b>example:</b> copy files using wildcards<br>
<pre><code>import avmplus.FileSystem;<br>
<br>
//will copy all the files ending by .abc in the current directory to the 'test5' directory<br>
trace( "copied = " + FileSystem.copyFiles( ".", "test5", /.*\.abc$/, true, true, true ) ); //copied = true<br>
</code></pre>
result<br>
<pre><code>//current directory<br>
-rw-r--r--   48036  8 Jan 20:04 builtin.abc<br>
-rw-r--r--   29259 17 Jan 11:30 shell_toplevel.abc<br>
-rw-r--r--   3543 11 Jan 06:49 test.abc<br>
-rw-r--r--   226 17 Jan 11:31 test_fs.abc<br>
-rw-r--r--   481 13 Jan 12:31 test_io.abc<br>
<br>
//test5 directory<br>
-rw-r--r--   48036 17 Jan 11:31 builtin.abc<br>
-rw-r--r--   29259 17 Jan 11:31 shell_toplevel.abc<br>
-rw-r--r--   3543 17 Jan 11:31 test.abc<br>
-rw-r--r--   226 17 Jan 11:31 test_fs.abc<br>
-rw-r--r--   481 17 Jan 11:31 test_io.abc<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>createDirectory</h2>
<pre><code>public static function createDirectory( filename:String ):Boolean<br>
</code></pre>
Creates the directory path from <code>filename</code>,<br>
iterates trough the path components and create the missing directories if needed.<br>
<br>
<b>note:</b><br>
Returns true on success, but what does it mean if it returns false ?<br>
In short, it means that <code>mkdir</code> failed, but it might have failed with <code>EEXIST</code>,<br>
or some other error due to the the directory appearing out of thin air.<br>
This can occur if two processes are trying to create the same file system tree<br>
at the same time.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>endsWithSeparator</h2>
<pre><code>public static function endsWithSeparator( filename:String ):Boolean<br>
</code></pre>
Tests if <code>filename</code> ends with a separator.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>ensureEndsWithSeparator</h2>
<pre><code>public static function ensureEndsWithSeparator( filename:String ):String<br>
</code></pre>
Returns <code>filename</code> ending with a separator.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>listFiles</h2>
<pre><code>public native static function listFiles( filename:String, directory:Boolean = false ):Array;<br>
</code></pre>
Returns an array of files or directories from <code>filename</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>listFilesWithFilter</h2>
<pre><code>public static function listFilesWithFilter( filename:String, filter:Function, directory:Boolean = false ):Array<br>
</code></pre>
Returns an array of files or directories from <code>filename</code><br>
filtered by a function.<br>
<br>
<b>note:</b><br>
the function should have the same signature as the one used for Array <code>filter()</code>, for ex:<br>
<pre><code>public static function isNotDotOrDotdot( element:*, index:int, arr:Array ):Boolean<br>
{<br>
    if( (element == currentDirectory) || (element == parentDirectory) )<br>
    {<br>
        return false;<br>
    }<br>
<br>
    return true;<br>
}<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>listFilesWithRegexp</h2>
<pre><code>public static function listFilesWithRegexp( filename:String, filter:RegExp, directory:Boolean = false ):Array<br>
</code></pre>
Returns an array of files or directories from <code>filename</code><br>
that matches the <code>filter</code> regular expression.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.FileSystem;<br>
<br>
//list all directories starting with "test"<br>
trace( FileSystem.listFilesWithRegexp( ".", /test*/, true ).join( "\n" ) );<br>
<br>
//list all files ending with extension "*.abc"<br>
trace( FileSystem.listFilesWithRegexp( ".", /.*\.abc$/, false ).join( "\n" ) );<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>move</h2>
<pre><code>public static function move( origin:String, destination:String, overwrite:Boolean = false ):Boolean<br>
</code></pre>
Moves an <code>origin</code> entry (file or directory) to a <code>destination</code> entry<br>
and returns true on success.<br>
<br>
<b>note:</b><br>
A move is the same as a rename, it reuses <code>rename()</code> from <a href='C_stdio.md'>C.stdio</a>.<br>
By default, does not <code>overwrite</code> the destination if it already exists.<br>
<br>
You can only moves <code>file to file</code> or <code>directory to directory</code>,<br>
in case of mismatch it will returns <code>false</code>.<br>
<br>
If a low-level <code>rename()</code> does not work and if the entry is a directory<br>
the method will try to do a <code>copyDirectory()</code> followed by a <code>removeDirectory()</code>.<br>
<br>
Will throw errors if<br>
<ul><li>if the <code>origin</code> does not exists<br>
</li><li>if the <code>destination</code> already exists and <code>overwrite=false</code></li></ul>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>normalizePath</h2>
<pre><code>public static function normalizePath( filename:String ):String<br>
</code></pre>
Normalizes the separators of the <code>filename</code>.<br>
<br>
<b>note:</b><br>
For POSIX, all <code>"\"</code> are replaced by <code>"/"</code>.<br>
for WIN32, all <code>"/"</code> are replaced by <code>"\"</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>remove</h2>
<pre><code>public static function remove( filename:String, recursive:Boolean = false ):void<br>
</code></pre>
Removes an entry (file or directory) from the file system.<br>
<br>
<b>note:</b><br>
it seems redundant to have <code>remove</code>, <code>removeFile</code>, <code>removeDirectory</code><br>
but not really, think of cases where we want to build a list of files and just go trough<br>
them deleting wether a file or directory<br>
<pre><code>import avmplus.FileSystem;<br>
<br>
//all files in this dir ending with *.abc<br>
var list1:Array = FileSystem.listFilesWithRegexp( ".", /.*\.abc$/, false );<br>
//all dir in this dir starting with "test"<br>
var list2:Array = FileSystem.listFilesWithRegexp( ".", /test*/, true );<br>
<br>
var list:Array = list1.concat( list2 );<br>
<br>
//we delete all of our entries wether dir or file<br>
for( var i:uint = 0; i&lt;list.length; i++ )<br>
{<br>
    FileSystem.remove(  list[i], true );<br>
}<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>removeFile</h2>
<pre><code>public static function removeFile( filename:String ):void<br>
</code></pre>
Removes a file entry from the file system.<br>
<br>
<b>note:</b><br>
If the entry is not a file will throw an error.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>removeDirectory</h2>
<pre><code>public static function removeDirectory( filename:String, recursive:Boolean = false ):void<br>
</code></pre>
Removes a directory entry from the file system,<br>
if <code>recursive=true</code> delete all child entries (files and directories) first.<br>
<br>
<b>note:</b><br>
If the entry is not a directory will throw an error.<br>
By default, if a directory is not empty it can not be deleted.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>stripTrailingSeparators</h2>
<pre><code>public static function stripTrailingSeparators( filename:String ):String<br>
</code></pre>
Remove trailing separators from the <code>filename</code>.<br>
<br>
<b>note:</b><br>
If the path is absolute, it will never be stripped any more than<br>
to refer to the absolute root directory, so <code>"////"</code> will become <code>"/"</code>, not <code>""</code>.<br>
<br>
A leading pair of a separators is never stripped, to support alternate roots.<br>
This is used to support UNC paths on Windows.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getFreeDiskSpace</h2>
<pre><code>public native static function getFreeDiskSpace( filename:String ):Number;<br>
</code></pre>
Returns the available disk space in bytes on the volume containing <code>filename</code>,<br>
or <code>-1</code> on failure.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getTotalDiskSpace</h2>
<pre><code>public native static function getTotalDiskSpace( filename:String ):Number;<br>
</code></pre>
Returns the total disk space in bytes on the volume containing <code>filename</code>,<br>
or <code>-1</code> on failure.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getUsedDiskSpace</h2>
<pre><code>public static function getUsedDiskSpace( filename:String ):Number<br>
</code></pre>
Returns the used disk space in bytes on the volume containing <code>filename</code>,<br>
or <code>-1</code> on failure.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />