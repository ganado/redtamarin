## Introduction ##

If writing C/C++ on one Operating System can be hard,<br>
writing C/C++ for more than one Operating System is a bitch.<br>
<br>
And when you try to do that when you are a C/C++ noob<br>
it's like trying to make ice cube in a god damn fucking hell.<br>
<br>
So here some notes to keep my sanity :).<br>
<br>
Oh, and I will use <b>xp</b> each time I want to mention <b>cross-platform</b>.<br>
<br>
<h2>Resetting data in a char array</h2>

Let's say you want to receive data in a buffer (char array) and while in a loop reset the data<br>
<br>
first attempt<br>
<pre><code>char buffer[1024];<br>
<br>
buffer[0] = '\0';<br>
<br>
//your loop<br>
</code></pre>

this in theory should work everywhere, as a char array contain 1 char per index,<br>
if you set the first index to be null terminated, then another function should see your char array as empty<br>
<br>
well ...on some POSIX it is working like that, but not everywhere (not WIN32)<br>
<br>
so yeah you really HAVE TO clean it up the proper way<br>
<pre><code>char buffer[1024];<br>
<br>
memset( &amp;buffer, 0, sizeof(buffer) );<br>
<br>
//your loop<br>
</code></pre>


<h2>Socket Descriptor</h2>

Under POSIX a socket descriptor is just an <code>int</code>
<pre><code>#include &lt;sys/socket.h&gt;<br>
<br>
int socket(int domain, int type, int protocol);<br>
</code></pre>

But under Windows, Winsock use a typedef <code>SOCKET</code> defined as a <code>UINT_PTR</code>
<pre><code>SOCKET WSAAPI socket(<br>
  __in  int af,<br>
  __in  int type,<br>
  __in  int protocol<br>
);<br>
<br>
//...<br>
/*<br>
 * The new type to be used in all<br>
 * instances which refer to sockets.<br>
 */<br>
typedef UINT_PTR        SOCKET;<br>
</code></pre>

You can almost get away with it if you keep the descriptor as a private member<br>
in an abstract class <code>Socket</code>, and then use the correct type with <code>PosixSocket</code> for POSIX<br>
and <code>WinSocket</code> for WIN32.<br>
<br>
But, at one moment or another you will have to build your socket class<br>
by passing a socket descriptor as an argument<br>
and for that to happen you have to agree on a common type.<br>
<br>
Luckily, I found this post <a href='http://stackoverflow.com/questions/1953639/is-it-safe-to-cast-socket-to-int-under-win64'>Is it safe to cast SOCKET to int under Win64?</a><br>
which mention this comment from the openSSL source code<br>
<pre><code>/*<br>
 * Even though sizeof(SOCKET) is 8, it's safe to cast it to int, because<br>
 * the value constitutes an index in per-process table of limited size<br>
 * and not a real pointer.<br>
 */<br>
</code></pre>

and after some tests under Windows I can say:<br>
yes you can cast your <code>SOCKET</code> to <code>int</code>! (and vise versa)<br>
<br>
here an example<br>
<pre><code>    int WinSocket::Accept() const<br>
    {<br>
        if(!IsValid()) {<br>
            return NULL;<br>
        }<br>
        <br>
        SOCKET socket = accept(_socket, NULL, NULL);<br>
        return (int)socket; //UINT_PTR casted to int<br>
    }<br>
</code></pre>

(note: I need to test under Windows 64bit but I'm pretty confident it should work there too)