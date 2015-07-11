## Introduction ##

You can go in a lot of details about why a system deal with Unicode this or that way,
all the nifty differences between codepages, UCS2, UCS4, UTF-8, UTF-16, UTF-32, etc.

The bottom line is you want to be able to handle different locale in a nice and easy way,
wether to read a file name in japanese, write some text in french with accents, or create/read directories in greek.

On the server side is even more important, all the browsers and HTML pages are supposed to work in UTF-8,
and from my personal experience PHP is a pain, Python is a joy, and databases is yet another problem.

## The Good ##

Tamarin by default already deal with most of the problems, you can create Latin1, UTF-8 and UTF-16 strings,
you even have a UnicodeUtils that tell you if a UTF-8 sring is valid, convert from UTF-8 to UTF-16, etc.

In fact, it is so well done, that even without changes, you could write
```
trace( "となりのトトロ" );
```

and it would just work, it would output a nice `となりのトトロ`.

Well... in most systems, but not on Windows.

The good thing is for Linux and Mac OS X those systems adopted a "all UTF-8" approach,
so fi your string encoding can deal with UTF-8 for ex, then all the rest follow without a fuss,
you can do something like
```
mkdir( "となりのトトロ" );
```

it will just works.

## The Bad ##

Windows is a problem on itself, it does not work like that at all.

There, the concept of "all UTF-8" is not present at all, you are first and foremost using the codepage and the locale of the system defaults.

### The C++ easy part ###

by default you use **char** to works with ANSI characters (narrow chars)<br>
and you use <b>wchar_t</b> to works with Unicode characters (wide chars).<br>
<br>
In Tamarin we do have our own <b>wchar</b> type<br>
<pre><code>/* wchar is our version of wchar_t, since wchar_t is different sizes<br>
 on different platforms, but we want to use UTF-16 uniformly. */<br>
typedef uint16_t wchar;<br>
</code></pre>

When we create strings internally we use the type <b>Stringp</b> and some macros<br>
<pre><code>Stringp name; //our string variable<br>
<br>
StUTF8String nameUTF8(name); //macro to make it a UTF-8 string<br>
nameUTF8.c_str() //return a char type<br>
<br>
StUTF16String nameUTF16(name); //macro to make it a UTF-16 string<br>
nameUTF16.c_str() //return a wchar type<br>
</code></pre>


<h3>The C++ difficult part</h3>

The difficult is mainly Windows.<br>
<br>
The C-Runtime Library, that we use to implement POSIX under Windows, use different functions depending if you <b>UNICODE</b> or not.<br>
<br>
for example <b>mkdir()</b>
<pre><code>int _mkdir( const char *dirname );<br>
<br>
int _wmkdir( const wchar_t *dirname );<br>
</code></pre>

In our case, we can directly replace <b>wchar_t</b> by <b>wchar</b>.<br>
<br>
Now, the main problem is to translate from <b>char</b> to <b>wchar</b> and vise versa.<br>
<br>
So, for our own POSIX system we basically implements <b>VMPI_mkdir()</b>

wether you are under Windows, Mac OS X or Linux the function signature is the same<br>
<pre><code>int VMPI_mkdir( const char *path, int mode )<br>
</code></pre>

in our API we would call it like that<br>
<pre><code>    int CSysStatClass::mkdir(Stringp path, int mode)<br>
    {<br>
        if (!path) {<br>
            toplevel()-&gt;throwArgumentError(kNullArgumentError, "path");<br>
        }<br>
<br>
        StUTF8String pathUTF8(path);<br>
        return VMPI_mkdir(pathUTF8.c_str(), mode);<br>
    }<br>
</code></pre>

in short<br>
<ul><li>we take a <b>Stringp</b>
</li><li>make it a UTF-8 string<br>
</li><li>pass the <b>char</b> type</li></ul>

So, our main problem is from the inside of <b>VMPI_mkdir()</b> we need to<br>
<ul><li>convert a <b>char</b> to a <b>wchar</b>
</li><li>use the wide char Unicode function<br>
</li><li>and do that only under Windows</li></ul>

Here how you would do it without thinking of the Unicode<br>
<pre><code>int VMPI_mkdir(const char *path, int mode)<br>
{<br>
    (void)mode;<br>
    return _mkdir( path );<br>
}<br>
</code></pre>

And here how to make it work with Unicode<br>
<pre><code>int VMPI_mkdir(const char *path, int mode)<br>
{<br>
    (void)mode;<br>
<br>
    int size_needed = MultiByteToWideChar( CP_UTF8, 0, path, -1, NULL, 0 );<br>
<br>
    if( size_needed != 0 )<br>
    {<br>
        wchar* wpath = new wchar[size_needed];<br>
        int result = MultiByteToWideChar( CP_UTF8, 0, path, -1, wpath, size_needed );<br>
        return _wmkdir( wpath );<br>
    }<br>
    else<br>
    {<br>
        return -1;<br>
    }<br>
}<br>
</code></pre>

a bit more details<br>
<ul><li>we use first MultiByteToWideChar to calculate the size needed for the <b>wchar</b> buffer<br>
</li><li>if this return zero, the UTF-8 chain must contains some invalid chars<br>
</li><li>if not, then we create our <b>wchar</b> buffer with the size needed<br>
</li><li>then we call a second time MultiByteToWideChar, but this time we convert the <b>char</b> <code>path</code> to a <b>wchar</b> <code>wpath</code>
</li><li>we then use it with the function <i><b>wmkdir()</b></li></ul></i>

<h3>The Tamarin super easy part</h3>

With <b>Stringp</b> and the UTF8 and UTF16 macros you can make all that much simpler.<br>
<br>
The only catch is to do it one level upper than VMPI, because you can access those macros only from AvmCore<br>
and you want to keep basic type like <b>char</b> and <b>wchar</b> in the VMPI part.<br>
<br>
Now in VMPI we will add wide chars functions<br>
<pre><code>int VMPI_mkdir(const char *path, int mode)<br>
{<br>
    (void)mode;<br>
    return _mkdir( path );<br>
}<br>
<br>
int VMPI_mkdir16(const wchar *path, int mode)<br>
{<br>
    (void)mode;<br>
    return _wmkdir( path );<br>
}<br>
</code></pre>

pretty straightforward.<br>
<br>
now in our API, we just need to check for WIN32 and redirect the call accordingly<br>
<pre><code>    int CSysStatClass::mkdir(Stringp path, int mode)<br>
    {<br>
        if (!path) {<br>
            toplevel()-&gt;throwArgumentError(kNullArgumentError, "path");<br>
        }<br>
<br>
        #if AVMSYSTEM_WIN32<br>
            StUTF16String pathUTF16(path);<br>
            return VMPI_mkdir16(pathUTF16.c_str(), mode);<br>
        #elif<br>
            StUTF8String pathUTF8(path);<br>
            return VMPI_mkdir(pathUTF8.c_str(), mode);<br>
        #endif<br>
    }<br>
</code></pre>

Here we reuse the core strength of Tamarin which already do all the work for us,<br>
converting strings to UTF8, UTF16, checking for invalid chars, etc.<br>
<br>
On a function like <code>mkdir()</code> we can see a bit of advantages but not that much.<br>
<br>
Let's see with another function like <code>getenv()</code> where the conversion is more complex.<br>
<br>
let' set up VMPI<br>
<pre><code>const char *VMPI_getenv(const char *env)<br>
{<br>
    return getenv( env );<br>
}<br>
<br>
const wchar *VMPI_getenv16(const wchar *env)<br>
{<br>
    return _wgetenv( env );<br>
}<br>
</code></pre>

and now let's see the API implementation<br>
<pre><code>    /*static*/ Stringp CStdlibClass::getenv(ScriptObject* self, Stringp name)<br>
    {<br>
        AvmCore *core = self-&gt;core();<br>
        Toplevel* toplevel = self-&gt;toplevel();<br>
<br>
        if( !name )<br>
        {<br>
            toplevel-&gt;throwArgumentError(kNullArgumentError, "name");<br>
        }<br>
        <br>
        #if AVMSYSTEM_WIN32<br>
            StUTF16String nameUTF16(name);<br>
            const wchar * str = VMPI_getenv16( nameUTF16.c_str() );<br>
            <br>
            Stringp value = core-&gt;newStringUTF16( str );<br>
            StUTF8String valueUTF8(value);<br>
            return core-&gt;newStringUTF8( valueUTF8.c_str() );<br>
        #elif<br>
            StUTF8String nameUTF8(name);<br>
            const char * str = VMPI_getenv( nameUTF8.c_str() );<br>
            return core-&gt;newStringUTF8( str );<br>
        #endif<br>
    }<br>
</code></pre>

So here what's happening<br>
<ul><li>we first use <code>VMPI_getenv16()</code> with a <code>StUTF16String</code>
</li><li>but this return also a <code>StUTF16String</code>
</li><li>we could return a <b>Stringp</b> but the internal encoding would stay UTF16<br>
</li><li>so we convert this UTF16 string to a <code>StUTF8String</code>
</li><li>and we return a <b>Stringp</b> based on UTF8</li></ul>

Here the advantages are more obvious, it just take a couple of lines to convert from UTF8 to UTF16 to UTF8,<br>
if we had the same code with <code>MultiByteToWideChar</code> and <code>WideCharToMultiByte</code> we would have a more complex code<br>
and it would much prone to errors.<br>
<br>
Conclusion is we want to use <b>Stringp</b> with the UTF8 and UTF16 macros,<br>
it make our API calls a little less elegant but much more easier and straightforward.<br>
<br>
<h2>The Documents</h2>

<a href='http://www.utf8everywhere.org/'>UTF-8 Everywhere</a> for some general directives.<br>
<br>
<a href='http://alfps.wordpress.com/2011/11/22/unicode-part-1-windows-console-io-approaches/'>Unicode part 1: Windows console i/o approaches</a><br>
<a href='http://alfps.wordpress.com/2011/12/08/unicode-part-2-utf-8-stream-mode/'>Unicode part 2: UTF-8 stream mode</a>

Those 2 pages explain the rest, eg. you need more than just converting char to wchar, you need also to deal with input encoding, output encoding, etc.<br>
<br>
<br>
<h2>The C Runtime Reference</h2>

Which functions do you have to supports ?<br>
<br>
<table><thead><th> <b>POSIX</b> </th><th> <b>Windows (narrow)</b> </th><th> <b>Windows (wide)</b> </th></thead><tbody>
<tr><td> stdlib.h     </td><td> </td><td> </td></tr>
<tr><td> <code>system</code> </td><td> <code>system</code>     </td><td> <code>_wsystem</code> </td></tr>
<tr><td> <code>getenv</code> </td><td> <code>getenv</code>     </td><td> <code>_wgetenv</code> </td></tr>
<tr><td> <code>setenv</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>unsetenv</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>putenv</code> </td><td> <code>_putenv</code>    </td><td> <code>_wputenv</code> </td></tr>
<tr><td> <code>atof</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>atoi</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>atol</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>atoll</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>mkdtemp</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>mkstemp</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>realpath</code> </td><td> <code>_fullpath</code>  </td><td> <code>_wfullpath</code> </td></tr>
<tr><td> <code>strtod</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>strtof</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>strtol</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>strtold</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>strtoll</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>strtoul</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>strtoull</code> </td><td>                         </td><td>                       </td></tr>
<tr><td>              </td><td>                         </td><td>                       </td></tr>
<tr><td> stdio.h      </td><td> </td><td> </td></tr>
<tr><td> <code>fopen</code> </td><td> <code>fopen</code>      </td><td> <code>_wfopen</code>  </td></tr>
<tr><td> <code>freopen</code> </td><td> <code>freopen</code>    </td><td> <code>_wfreopen</code> </td></tr>
<tr><td> <code>remove</code> </td><td> <code>remove</code>     </td><td> <code>_wremove</code> </td></tr>
<tr><td> <code>rename</code> </td><td> <code>rename</code>     </td><td> <code>_wrename</code> </td></tr>
<tr><td> <code>fputs</code> </td><td> <code>fputs</code>      </td><td> <code>_fputws</code>  </td></tr>
<tr><td> <code>perror</code> </td><td> <code>perror</code>     </td><td> <code>_wperror</code> </td></tr>
<tr><td> <code>popen</code> </td><td> <code>_popen</code>     </td><td> <code>_wpopen</code>  </td></tr>
<tr><td> <code>puts</code> </td><td> <code>puts</code>       </td><td> <code>_putws</code>   </td></tr>
<tr><td> <code>tempnam</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>tmpfile</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>tmpnam</code> </td><td>                         </td><td>                       </td></tr>
<tr><td>              </td><td>                         </td><td>                       </td></tr>
<tr><td> sys/stat.h   </td><td> </td><td> </td></tr>
<tr><td> <code>chmod</code> </td><td> <code>_chmod</code>     </td><td> <code>_wchmod</code>  </td></tr>
<tr><td> <code>lstat</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>mkdir</code> </td><td> <code>_mkdir</code>     </td><td> <code>_wmkdir</code>  </td></tr>
<tr><td> <code>stat</code> </td><td> <code>_stat</code>      </td><td> <code>_wstat</code>   </td></tr>
<tr><td>              </td><td>                         </td><td>                       </td></tr>
<tr><td> unistd.h     </td><td> </td><td> </td></tr>
<tr><td> <code>access</code> </td><td> <code>_access</code>    </td><td> <code>_waccess</code> </td></tr>
<tr><td> <code>chdir</code> </td><td> <code>_chdir</code>     </td><td> <code>_wchdir</code>  </td></tr>
<tr><td> <code>chown</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>crypt</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>encrypt</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>execl</code> </td><td> <code>_execl</code>     </td><td> <code>_wexecl</code>  </td></tr>
<tr><td> <code>execle</code> </td><td> <code>_execle</code>    </td><td> <code>_wexecle</code> </td></tr>
<tr><td> <code>execlp</code> </td><td> <code>_execlp</code>    </td><td> <code>_wexeclp</code> </td></tr>
<tr><td> <code>execv</code> </td><td> <code>_execv</code>     </td><td> <code>_wexecv</code>  </td></tr>
<tr><td> <code>execve</code> </td><td> <code>_execve</code>    </td><td> <code>_wexecve</code> </td></tr>
<tr><td> <code>execvp</code> </td><td> <code>_execvp</code>    </td><td> <code>_wexecvp</code> </td></tr>
<tr><td> <code>getcwd</code> </td><td> <code>_getcwd</code>    </td><td> <code>_wgetcwd</code> </td></tr>
<tr><td> <code>link</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>readlink</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>rmdir</code> </td><td> <code>_rmdir</code>     </td><td> <code>_wrmdir</code>  </td></tr>
<tr><td> <code>symlink</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>truncate</code> </td><td>                         </td><td>                       </td></tr>
<tr><td> <code>unlink</code> </td><td> <code>_unlink</code>    </td><td> <code>_wunlink</code> </td></tr>
<tr><td>              </td><td>                         </td><td>                       </td></tr>