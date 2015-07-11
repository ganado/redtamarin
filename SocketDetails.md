## Introduction ##

Everything you wanted to know about socket implementation details in redtamarin.


## Details ##

You would think that something like sockets have been standardised for many years by now,
well ... not exactly.

We are basically fighting 2 battles on the same front:
  * stay cross platform
  * allow a socket server to handle thousands of clients simultaneously

Some people could decide is not worthy to have this kind of goals
but then I would kindly remember them that redtamarin has a clear
mission statement: **support the use of the AS3 language for cross-platform**.

Because of that, I can not (and don't want) to allow certain features
only for Linux, or only for Windows, or any particular Operating System;
sure the C++ implementation can change per system but the API on the AS3 side
has to be the same for every systems.


### Cross platform sockets ###

Basically you can describe the problem [like this guy did](http://poincare101.blogspot.co.uk/2012/03/experiences-in-go-ing.html)<br>

<pre>
And, the worst problem I faced was of sockets. Non-blocking, multi-plexed and<br>
cross-platform socket support with C is basically non-existent (unless I wanted to use<br>
libev or libevent, which has documentation scattered across the internet in small chunks).<br>
With C++, there are many choices, such as Boost.Asio (basically no documentation),<br>
ACE and ICE (this one I'm genuinely excited about, but, I hate their specialized object<br>
format crap I have to deal with).<br>
</pre>


When I started to implement <code>avmplus.Socket</code> I based the code on two things<br>
<ul><li><a href='http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html'>Beej's Guide to Network Programming</a>
</li><li><a href='http://code.google.com/codesearch#OAMlx_jo-ck/src/v8/src/platform.h&exact_package=chromium&l=626'>Chromium sockets</a></li></ul>

Even if Beej's guide can be considered outdated it was the straightforward approach and tone that I needed to really understand socket programming.<br>
<br>
To avoid reinventing the wheel I looked at a lot of different socket implementations in C++ that work both for Linux and Windows,<br>
I would not say the Chromium implementation was the perfect one, but the fact it was based on an abstract class with 2 separate implementation was fitting well the Tamarin VMPI model and I could patch what was "missing" with what I was learning from other inputs.<br>
<br>
But just there you realize Windows world and Linux world clashes quite hard, so pretty soon I had also to refer to the<br>
<a href='http://tangentsoft.net/wskfaq/'>Winsock Programmer’s FAQ</a>.<br>
<br>
At the end you obtain an API based on 3 layers<br>
<pre><code>//1st layer: VMPI implementation<br>
/src/tamarin/shell<br>
    |_ Socket.h         &lt;- abstract class<br>
    |_ PosixSocket.h    &lt;- POSIX implementation<br>
    |_ PosixSocket.cpp<br>
    |_ WinSocket.h      &lt;- WIN32 implementation<br>
    |_ WinSocket.cpp<br>
<br>
//2nd layer: Tamarin native class C++ implementation<br>
/src/tamarin/api/shell<br>
    |_ SocketClass.h<br>
    |_ SocketClass.cpp<br>
<br>
//3rd layer:  Tamarin native class AS3 implementation<br>
/src/tamarin/as3/shell/avmplus<br>
    |_ Socket.as <br>
<br>
</code></pre>

The hardest part in all those layers is to balance how much in each layer you implement stuff so the final user (you!) has enough freedom to work with the API.<br>
<br>
So if you compare <a href='http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/Socket.html'>`flash.net::Socket`</a> with <code>avmplus::Socket</code>, not saying that I did a better job than Adobe, but I kept my focus on giving as much low level access to the socket as possible,<br>
and so if you compare the two <code>avmplus::Socket</code> is much more lower level which is at the same time good and bad.<br>
<br>
It's bad because you don't have all the luxuries of <code>flash.net::Socket</code>, no events, not based on <code>IDataOutput</code>/<code>IDataInput</code>, much less example on the web, etc.<br>
<br>
it's good because with <code>avmplus::Socket</code> you can fully re-implements <code>flash.net::Socket</code> (without the need to have access to the native source code),<br>
and it does not stop there, you can also fully implements <code>flash.net::DatagramSocket</code>, <code>flash.net::ServerSocket</code>, etc.<br>
<br>
And it could be considered "better" as you can fully copy C/C++ socket examples and apply them in AS3.<br>
<br>
for example, let's implement a basic TCP server as shown here <a href='http://en.wikipedia.org/wiki/Berkeley_sockets#Server'>http://en.wikipedia.org/wiki/Berkeley_sockets#Server</a>
<pre><code>//server.as<br>
import avmplus.System;<br>
import avmplus.Socket;<br>
import C.stdlib.*;<br>
import C.socket.*;<br>
<br>
var SocketFD:Socket = new Socket();<br>
//you could also use<br>
//var SocketFD:Socket = new Socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );<br>
<br>
if( !SocketFD.valid )<br>
{<br>
    trace( "can not create socket" );<br>
    System.exit( EXIT_FAILURE );<br>
}<br>
<br>
SocketFD.bind( 1100 );<br>
if( !SocketFD.bound )<br>
{<br>
    trace( "error bind failed" );<br>
    SocketFD.close();<br>
    System.exit( EXIT_FAILURE );<br>
}<br>
<br>
SocketFD.listen( 10 );<br>
if( !SocketFD.listening )<br>
{<br>
    trace( "error listen failed" );<br>
    SocketFD.close();<br>
    System.exit( EXIT_FAILURE );<br>
}<br>
<br>
<br>
var ConnectFD:Socket;<br>
for(;;)<br>
{<br>
    ConnectFD = SocketFD.accept();<br>
<br>
    if( !ConnectFD.valid )<br>
    {<br>
        trace( "error accept failed" );<br>
        SocketFD.close();<br>
        System.exit( EXIT_FAILURE );<br>
    }<br>
<br>
    /* perform read write operations ...<br>
    var data:String = ConnectFD.receive( buff ); */<br>
<br>
    ConnectFD.close();<br>
<br>
    if( Socket.lastError &gt; 0 )<br>
    {<br>
        trace( Socket.getErrorMessage( Socket.lastError ) );<br>
        System.exit( EXIT_FAILURE );<br>
    }<br>
}<br>
<br>
System.exit( EXIT_SUCCESS );<br>
<br>
</code></pre>

you could test it like that<br>
<pre><code>$ java -jar asc.jar -AS3 -strict -import builtin.abc -import toplevel.abc server.a<br>
./redshell_d server.abc<br>
</code></pre>

and use netcat for the client<br>
<pre><code>$ nc -v -v 127.0.0.1 1100<br>
localhost [127.0.0.1] 1100 (mctp) open<br>
 sent 0, rcvd 0<br>
<br>
$ nc -v -v 127.0.0.1 1100<br>
localhost [127.0.0.1] 1100 (mctp) open<br>
 sent 0, rcvd 0<br>
<br>
</code></pre>

in the output you will see<br>
<pre><code>Socket (4): stream socket created.<br>
Socket (4): Bound to [127.0.0.1:1100].<br>
Socket (4): [127.0.0.1:1100] listening (backlog=10).<br>
Socket (5): stream socket created.<br>
Socket (5): [127.0.0.1:62838] connected to [127.0.0.1:1100].<br>
Socket (4): [127.0.0.1:1100] accept connection from [5].<br>
Socket (5): Terminated.<br>
Socket (5): Disconnected from [127.0.0.1:1100].<br>
Socket (5): stream socket destroyed.<br>
Socket (5): stream socket created.<br>
Socket (5): [127.0.0.1:62840] connected to [127.0.0.1:1100].<br>
Socket (4): [127.0.0.1:1100] accept connection from [5].<br>
Socket (5): Terminated.<br>
Socket (5): Disconnected from [127.0.0.1:1100].<br>
Socket (5): stream socket destroyed.<br>
^C<br>
</code></pre>


Here what turned out pretty well in the implementation<br>
<ul><li>most if not all of the <a href='http://en.wikipedia.org/wiki/Berkeley_sockets'>Berkely sockets</a> function map to a Class<br>
</li><li>it works exactly the same cross platform (at least Windows, Linux Ubuntu-like, OSX; probably more but I lack ressources to test more systems)<br>
</li><li>the API does not hide too many stuff in the background but it still make things simpler than writing it in C</li></ul>

But even with that I had to make hard choices<br>
<br>
simply because of the difference between C/C++ and AS3<br>
for example, a lot of berkely sockets function return an integer and need to be passed a <code>struct sockaddr_in</code> as arguments<br>
and I decided to avoid that, in most case for functions like <code>connect()</code>, <code>bind()</code>, <code>listen()</code>, it makes thing easier for the user<br>
in other cases for functions like <code>recv()</code>, <code>send()</code> it makes things harder for the implementer<br>
<br>
in short, if some function returns <code>-1</code> to show something went wrong, I just return a boolean<br>
<br>
Things got more interesting with functions like <code>recv()</code><br>
so what does this function ?<br>
<a href='http://pubs.opengroup.org/onlinepubs/007904975/functions/recv.html'>recv - receive a message from a connected socket</a>

here its signature<br>
<pre><code>ssize_t recv(int socket, void *buffer, size_t length, int flags);<br>
</code></pre>

the problem is about the <b>return value</b><br>
<pre>
Upon successful completion, recv() shall return the length of the message in bytes.<br>
If no messages are available to be received and the peer has performed an orderly shutdown, recv() shall return 0.<br>
Otherwise, -1 shall be returned and errno set to indicate the error.<br>
</pre>

That's where the 3 layers are important<br>
<br>
on VMPI<br>
<pre><code>    int PosixSocket::Receive(char* data, int len, int flags) const<br>
    {<br>
        int status = recv(_socket, data, len, flags);<br>
        return status;<br>
    }<br>
<br>
    int WinSocket::Receive(char* data, int len, int flags) const<br>
    {<br>
        int status = recv(_socket, data, len, flags);<br>
        return status;<br>
    }<br>
</code></pre>

the implementation is the same and really basic, really the methods of the class are mainly wrappers for Berkeley sockets function.<br>
<br>
<br>
in C++<br>
<pre><code>    int SocketObject::_receive(int buffer, int flags)<br>
    {<br>
        int result = 0;<br>
        char *data = new char[buffer];<br>
<br>
        _buffer-&gt;clear(); //reset the buffer before reading<br>
        <br>
        result = _socket-&gt;Receive(data, buffer, flags);<br>
        <br>
        if(result &gt; 0) {<br>
            _buffer-&gt;GetByteArray().Write( data, result );<br>
        }<br>
<br>
        delete [] data;<br>
        return result;<br>
    }<br>
</code></pre>

<code>_buffer</code> is private to the API and used to store the received data<br>
that way the data can be retrieved later and this method can still returns an integer.<br>
<br>
based on <a href='http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#sendrecv'>http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#sendrecv</a><br>
"recv() returns the number of bytes actually read into the buffer, or -1 on error (with errno set, accordingly.)<br>
<br>
Wait! recv() can return 0. This can mean only one thing: the remote side has closed the connection on you! A return value of 0 is recv()'s way of letting you know this has occurred."<br>
<br>
So the only thing I do is to check if the return value is bigger than zero,<br>
if <code>yes</code> I write the data to the buffer, if <code>no</code> I just do nothing about it<br>
yes I don't but the logic of dealing with the return value in the C++ part of the class<br>
<br>
<br>
in AS3<br>
<pre><code>        private native function _receive( buffer:int, flags:int = 0 ):int;<br>
<br>
        public function receive( buffer:uint = 1024, flags:int = 0 ):String<br>
        {<br>
            if( !connected ) { return; }<br>
            <br>
            if( buffer &lt; _MIN_BUFFER ) { _throwReceiveBufferError(); }<br>
<br>
            var data:String = "";<br>
            var result:int  = _receive( buffer, flags );<br>
            <br>
            if( result == 0 ) { _remoteClose(); }<br>
<br>
            if( result &lt;= -1 ) { _throwSocketError( lastError ); }<br>
<br>
            var _buffer:ByteArray = _getBuffer();<br>
                _buffer.position = 0;<br>
            data += _buffer.readUTFBytes( result );<br>
            <br>
            this.onReceive( data.length );<br>
            return data;<br>
        }<br>
</code></pre>

Here we play on 2 things<br>
<ul><li>a native method <code>_receive()</code>
</li><li>a public method <code>receive()</code></li></ul>

As you can see, the logic is all here<br>
<ul><li>if the socket is not connect we can abort right away<br>
</li><li>if the custom buffer has been set to a wrong value we send an error<br>
</li><li>if the <code>_receive()</code> return value is zero, we know the remote party closed so we call <code>_remoteClose()</code>
</li><li>if the <code>_receive()</code> return value is <code>-1</code>, we know there is an error and we throw an error<br>
</li><li>and if everything went well, we just get back our private buffer data with <code>_getBuffer()</code>
</li><li>we even use a callback <code>this.onReceive( data.length );</code>
</li><li>and finally simply returns the data</li></ul>

All that are hard choices,and yes it could have been done differently, and no there are real reasons why it has been implemented this way.<br>
<br>
So yes, I could have done all the logic of dealing with the return value in C++, so why do it in AS3 ?<br>
<ul><li>less prone to errors (much harder to debug C++ than AS3)<br>
</li><li>easier to test<br>
</li><li>easier to change<br>
</li><li>maybe slightly slower if you test performance in microseconds</li></ul>

That's the whole purpose of those 3 layers<br>
<ul><li>VMPI is here only to abstract the difference of implementations for different operating systems<br>
</li><li>C++ code are here only to give access to those native functions<br>
</li><li>AS3 glue everything and define the API</li></ul>

In short, I do the strict minimum in C/C++ and do all the rest in AS3.<br>
<br>
And let's say I make an implementation error on the AS3 side, you can fix it before I do,<br>
for example like that<br>
<pre><code>package avmplus<br>
{<br>
    public class Socket2 extends Socket<br>
    {<br>
        public override function receive( buffer:uint = 1024, flags:int = 0 ):String<br>
        {<br>
            //change stuff here<br>
        }<br>
    }<br>
}<br>
</code></pre>
I'm not sure anyone need this but if you have to go that lower level you can in theory.<br>
<br>
Another hard choice was to provide some kind of callback without an event system in place in redtamarin,<br>
you can read more about it here <a href='http://code.google.com/p/redtamarin/wiki/Examples_Socket#Events_and_Logs'>Socket Events and Logs</a>,<br>
yes by default all socket activity is logged, you can easily remove it if it gets in your way,<br>
and more interestingly you can hook your own events or callbacks to replace it<br>
(this is also where AS3 shine where you can use the prototype to customize a class).<br>
<br>
TODO<br>
show how all that helped or influenced the implementation of <code>flash.net:Socket</code> in the lib <a href='http://code.google.com/p/maashaack/wiki/avmglue'>avmglue</a>.<br>
<br>
TODO<br>
give more details on some operating system differences (file descriptor vs SOCKET, etc.)<br>
<br>
<br>
<h3>Socket server</h3>

If you thought making cross platform choices were hard, making choice about the server side of sockets is even harder.<br>
<br>
First of all, there is no fucking standard working for every operating systems,<br>
the differences between Berkeley sockets and Winsock are small potatoes compared to the huge depth of differences you can find when you try to deal will simultaneous connections.<br>
<br>
OK, let's starts the big rant...<br>

If you're on Linux, you have <code>fork()</code>, and combined with sockets it allow you to isolate each client connections per threads and keep a rather simple code.<br>
<br>
But there is no <code>fork()</code> on Windows, hard choice: I can not use <code>fork()</code>, period. No, I will not implement <code>fork()</code> in redtamarin and say "oh it works only for Linux".<br>
<br>
So, one solution would be to define VMPI way of doing threads that would work for any systems: Linux, OSX, Windows, etc.<br>
but wait ... is using multithreading really the best solution to support concurrency ?<br>
<br>
let's read <a href='http://drdobbs.com/open-source/184405553'>I/O Multiplexing &amp; Scalable Socket Servers</a> from Dr Dobb's<br>
here we learn that<br>
<ul><li>"the thread-pooling model" is simple to implement<br>
</li><li>"one file descriptor is added to a worker thread for the lifetime of the connection"<br>
</li><li>"Using a single connection per thread lets the data buffer be local on the thread stack"</li></ul>

with those "drawback to thread pools"<br>
<ul><li>"The number of threads an OS can create per process"<br>
</li><li>"The time it takes to switch between worker threads (context switching)"<br>
</li><li>"Worker threads are I/O bound"</li></ul>

mainly that "depending on the OS and hardware, the thread-pooling model reaches the point of diminishing returns around 500 concurrent worker threads.",<br>
and that sorry is not good enough in my book, 500 concurrent connections ? that sucks!<br>
<br>
And then the article explains all the goodness of <b>I/O multiplexing</b>
<pre>
I/O multiplexing, on the other hand, enables an application to overlap<br>
its I/O processing with the completion of I/O operations.<br>
Applications manage overlapped I/O by processing socket handles<br>
(client connections) through events that are sent from the kernel to the application.<br>
These notify the application that I/O has completed.<br>
By using an event-based mechanism, each worker thread can process I/O<br>
from multiple clients while the underlying driver waits for I/O to complete.<br>
<br>
An application's ability to process I/O from many clients per thread is preferential<br>
to having one client per worker thread. With one client per thread, context switches<br>
must occur each time the application needs to process I/O from another client.<br>
Adding multiple clients per worker thread enables a server application to handle a<br>
significantly larger number of clients, processing I/O for each client as soon as it is<br>
made ready by the OS. Each client is still I/O bound, but the threads are free to<br>
process any I/O available. The number of worker threads used to process the I/O<br>
should also be considerably smaller than the number used in the thread-pool model.<br>
A simple function to calculate the number of worker threads is worker threads= 2*n<br>
where n is the number of CPUs in the server running the application.<br>
</pre>

and that little nugget<br>
<pre>
Operating systems differ in their native support for I/O multiplexing<br>
and the effectiveness of each implementation:<br>
<br>
* UNIX-based operating systems share similar support for<br>
I/O multiplexing through the use of signals,<br>
select(), and poll() APIs, and a new device /dev/poll.<br>
<br>
* Windows supports asynchronous I/O through select(),<br>
various Windows APIs, and I/O completion ports.<br>
<br>
* Java has native I/O multiplexing in the 1.4.1 SDK through<br>
the selector API. Unfortunately, the selector API is limited<br>
to processing 64 clients per instance of the selector class.<br>
<br>
The most efficient mechanisms for I/O multiplexing<br>
are /dev/poll for UNIX and I/O completion ports on Windows.<br>
</pre>

So by the end of the article you can read <b>Cross-Platform I/O Multiplexing Abstraction</b>,<br>
and that's basically what I want to implement for a truly efficient socket server in redtamarin,<br>
but it's not there yet.<br>
<br>
Here basically the problem: almost every operating system do it differently, some will use <code>select()</code>, other will use <code>poll()</code>, some will have <code>poll()</code> as a wrapper around <code>select()</code>, and then there is also <code>epoll()</code>, and <code>/dev/poll</code>, and <code>kqueue()</code>, and realtime signals, and I/O completion ports, etc.<br>
<br>
For a much detailled explanation of the problem please read <a href='http://www.kegel.com/c10k.html'>The C10K problem</a>.<br>
<br>
TODO<br>
talk about libevent, then libev<br>
talk about why not investigate threads<br>
talk about why select() is cross platform<br>
talk about the limit of file descriptors<br>
explain the choices...