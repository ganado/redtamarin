<a href='Hidden comment: 
Here we can use asdoc to document the source code.
So the rule is to document the side notes in the wiki page.

/* more in depth informations: http://code.google.com/p/redtamarin/wiki/Socket */
'></a>

# About #
Provides methods to create client and server sockets.

**class:** `avmplus::Socket`

**product:** redtamarin 0.3

**since:** 0.3.0

**note:**
  * everything is blocking by default (since 0.3.2 you can be unblocking) , and synchronous
  * `SIGPIPE` is disabled by default, and `EPIPE` error is thrown instead
  * support Stream (TCP) and Datagram (UDP) sockets
  * no support for IP v6
  * no support for events

**references:**
  * [wikipedia Berkeley sockets](http://en.wikipedia.org/wiki/Berkeley_sockets)
  * [wikipedia Internet socket](http://en.wikipedia.org/wiki/Internet_socket)
  * [wikipedia File descriptor](http://en.wikipedia.org/wiki/File_descriptor)



---

# Statics #

## isSupported ##
```
public native static function isSupported():Boolean;
```
Indicates if sockets are supported by the system.

**since:** 0.3.2


## getErrorMessage ##
```
public static function getErrorMessage( e:int ):String
```
Returns the error message string from a socket error number.

**note:**<br>
there are slight difference between POSIX and WIN32<br>
and this method allow to compensate for that.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>version</h2>
<pre><code>public native static function get version():String;<br>
</code></pre>
The socket version.<br>
<br>
<b>note:</b><br>
Under POSIX will returns "Berkeley sockets"<br>
and under WIN32 will returns "Winsock 2.2"<br>
or "Winsock 2.1" or "Winsock 2.0" or ""Winsock 1.1"<br>
or "Winsock 1.0" or just "Winsock"<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>lastError</h2>
<pre><code>public native static function get lastError():int;<br>
</code></pre>
The last socket error.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>localAddresses</h2>
<pre><code>public static function get localAddresses():Array<br>
</code></pre>
The list of local IP addresses.<br>
<br>
<b>note:</b><br>
Most of the time you will have at least two addresses:<br>
one for the loopback interface (127.0.0.1)<br>
and at least one for an external network interface.<br>
<br>
It is not at all uncommon for a single machine to have multiple network interfaces:<br>
modem, ethernet, wifi, firewire, etc.<br>
<br>
The loopback interface lets two programs running on a single machine<br>
talk to each other without involving hardware drivers.<br>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>maxConnectionQueue</h2>
<pre><code>public static function get maxConnectionQueue():uint<br>
</code></pre>
The maximum backlog queue length supported by the OS for each socket.<br>
<br>
<b>note:</b><br>
Reuse <code>SOMAXCONN</code> from <a href='C_socket.md'>C.socket</a>.<br>
<br>
Usually the value is between <code>0</code> and <code>255</code>, and depending on the system can be quite hard to change,<br>
see <a href='http://antohe.tripod.com/apache_surv/asg12.htm#E70E140'>Apache Server Survival Guide - Listen Backlog (SOMAXCONN)</a><br>
<br>
From my personal tests<br>
<ul><li>under OS X 10.6, <code>SOMAXCONN = 128</code>
</li><li>under Windows XP SP3, <code>SOMAXCONN = 5</code> (winsock.h) and  <code>SOMAXCONN = 2147483647</code> (eg. <code>0x7fffffff</code> winsock2.h)<br>
</li><li>under Ubuntu 8.04 desktop, <code>SOMAXCONN = 128</code></li></ul>

We advise to use <b>128</b> if the OS support it.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>maxConcurrentConnection</h2>
<pre><code>public native static function get maxConcurrentConnection():int;<br>
</code></pre>
The maximum concurrent connections supported by the OS.<br>
<br>
<b>note:</b><br>
To create a server with concurrent connections we use the properties<br>
<code>readable</code> and <code>writable</code>, which under the hood use the <code>select()</code> function.<br>
<br>
The maximum number of socket descriptors that the <code>select()</code> function can use<br>
is determined by the <code>FD_SETSIZE</code> macro.<br>
<br>
From my personal tests<br>
<ul><li>under OS X 10.6, <code>FD_SETSIZE = 1024</code>
</li><li>under Windows XP SP3, <code>FD_SETSIZE = 64</code> (both winsock.h and winsock2.h)<br>
</li><li>under Ubuntu 8.04 desktop, <code>FD_SETSIZE = 1024</code></li></ul>

To overcome this limitation, we redefined the macro to <code>FD_SETSIZE = 4096</code> for all systems,<br>
see <a href='http://tangentsoft.net/wskfaq/advanced.html#64sockets'>Winsock Programmer’s FAQ 4.9 - What are the “64 sockets” limitations?</a>.<br>
see also <a href='http://support.microsoft.com/kb/111855'>Maximum Number of Sockets an Application Can Use</a>.<br>
<br>
So, yes in theory and depending of your server hardware (RAM), you could create a socket server<br>
with up to 4096 simultaneous connections, but we didn't do any real tests about it.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />
<h1>Properties</h1>

<h2>descriptor</h2>
<pre><code>public native function get descriptor():int;<br>
</code></pre>
The socket descriptor.<br>
<br>
<b>note:</b><br>
With POSIX a socket descriptor is of the type <code>int</code><br>
and with WIN32 a socket descriptor is of the type <code>HANDLE</code><br>
here we took the approach to use <code>int</code> everywhere.<br>
<br>
You can not create a <code>[Socket object]</code> out of an <code>int</code><br>
consider here the descriptor as a "unique identifier".<br>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>valid</h2>
<pre><code>public function get valid():Boolean<br>
</code></pre>
Indicates if the socket is valid.<br>
<br>
<b>note:</b><br>
A <code>valid</code> socket is a socket with a positive descriptor,<br>
all <code>invalid</code> sockets have a descriptor of <code>-1</code>.<br>
<br>
How do you get an invalid socket ?<br>
either when you close the socket, the underlying handle is destroyed<br>
and so its descriptor is set to <code>-1</code><br>
or something wrong happened during the socket instantiation<br>
which will results also in a descriptor set to <code>-1</code>.<br>

<b>since:</b> 0.3.0<br>
<br>
<h2>readable</h2>
<pre><code>public function get readable():Boolean<br>
</code></pre>
Indicates if the socket is ready for reading.<br>
<br>
<b>note:</b><br>
this property call under the hood the <code>select()</code> function with a timeout of <code>0 seconds</code>,<br>
that means that this is <b>non-blocking</b>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>readableTimeout</h2>
<pre><code>public var readableTimeout:uint = 0;<br>
</code></pre>
Defines the timeout (in seconds) for the readable test.<br>
<br>
<b>note:</b><br>
By default, <code>readableTimeout</code> is set to <code>0</code>.<br>
<br>
This will change the timeout of the <code>select()</code> function.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>writable</h2>
<pre><code>public function get writable():Boolean<br>
</code></pre>
Indicates if the socket is ready for writing.<br>
<br>
<b>note:</b><br>
this property call under the hood the <code>select()</code> function with a timeout of <code>0 seconds</code>,<br>
that means that this is <b>non-blocking</b>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>writableTimeout</h2>
<pre><code>public var writableTimeout:uint = 0;<br>
</code></pre>
Defines the timeout (in seconds) for the writable test.<br>
<br>
<b>note:</b><br>
By default, <code>writableTimeout</code> is set to <code>0</code>.<br>
<br>
This will change the timeout of the <code>select()</code> function.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>connected</h2>
<pre><code>public function get connected():Boolean<br>
</code></pre>
Indicates if the socket is connected.<br>
<br>
<b>note:</b><br>
By default a socket instance have no states,<br>
from there you can call methods to make this socket<br>
either a client or a server.<br>
<br>
Calling <a href='#connect.md'>connect()</a> will make the socket a client<br>
and will change the connected state to <code>true</code>.<br>
<br>
Calling <a href='#bind.md'>bind()</a> then <a href='#listen.md'>listen()</a> will make the socket a server<br>
but will not change the connected state.<br>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>bound</h2>
<pre><code>public function get bound():Boolean<br>
</code></pre>
Indicates if the socket is bound.<br>
<br>
<b>note:</b><br>
Calling <a href='#bind.md'>bind()</a> will change the bound state to <code>true</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>listening</h2>
<pre><code>public function get listening():Boolean<br>
</code></pre>
Indicates if the socket is listening.<br>
<br>
<b>note:</b><br>
Calling <a href='#listen.md'>listen()</a> will change the listening state to <code>true</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>type</h2>
<pre><code>public function get type():String<br>
</code></pre>
Returns the type of the socket.<br>
<br>
<b>note:</b><br>
The type can be one of those values: "raw", "stream", "datagram" or "invalid".<br>
When the type is "invalid" that means either the socket could not construct<br>
or that the socket has been destroyed.<br>
<br>
see <a href='#Socket.md'>Socket()</a> constructor for more details.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>blocking</h2>
<pre><code>public native function get blocking():Boolean;<br>
public native function set blocking( value:Boolean ):void;<br>
</code></pre>
Indicates if the socket is blocking or non-blocking.<br>
<br>
<b>note:</b><br>
By default, <code>blocking</code> is set to <code>true</code>.<br>
<br>
TODO (explain how much different blockign and non-blocking sockets are)<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>reuseAddress</h2>
<pre><code>public native function get reuseAddress():Boolean;<br>
public native function set reuseAddress( value:Boolean ):void;<br>
</code></pre>
Indicates if the socket address can be reused.<br>
<br>
<b>note:</b><br>
By default, <code>reuseAddress</code> is set to <code>false</code>.<br>
<br>
When you use <a href='#bind.md'>bind()</a> to create a server<br>
sometimes you can encounter the error "Address already in use".<br>
This can happen because a previously bound socket is still hanging<br>
around in the kernel and is hogging the port.<br>
<br>
You can either wait for it to clear (about a minute),<br>
or set <code>reuseAddress</code> to <code>true</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>broadcast</h2>
<pre><code>public native function get broadcast():Boolean;<br>
public native function set broadcast( value:Boolean ):void;<br>
</code></pre>
Indicates if the socket can broadcast.<br>
<br>
<b>note:</b><br>
By default, <code>broadcast</code> is set to <code>false</code>.<br>
<br>
This option set to <code>true</code> will enable an UDP socket client<br>
(only UDP, not TCP, and only IP v4)<br>
to send data to multiple hosts at the same time.<br>
<br>
For more details see <a href='http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#broadcast'>Beej's Guide to Network Programming - 7.6. Broadcast Packets</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receiveTimeout</h2>
<pre><code>public native function get receiveTimeout():int;<br>
public native function set receiveTimeout( value:int ):void;<br>
</code></pre>
Defines the timeout (in seconds) for the receive functions.<br>
<br>
<b>note:</b><br>
By default, <code>receiveTimeout</code> is set to <code>0</code>.<br>
<br>
This set the <code>SO_RCVTIMEO</code> socket option.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>sendTimeout</h2>
<pre><code>public native function get sendTimeout():int;<br>
public native function set sendTimeout( value:int ):void;<br>
</code></pre>
Defines the timeout (in seconds) for the send functions.<br>
<br>
<b>note:</b><br>
By default, <code>sendTimeout</code> is set to <code>0</code>.<br>
<br>
This set the <code>SO_SNDTIMEO</code> socket option.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<h2>logs</h2>
<pre><code>public function get logs():Array<br>
</code></pre>
Returns the session logs for this socket.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>local</h2>
<pre><code>public function get local():String<br>
</code></pre>
Local socket address and port.<br>
<br>
<b>note:</b><br>
Returns a string formated as "address:port".<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>peer</h2>
<pre><code>public function get peer():String<br>
</code></pre>
Peer socket address and port.<br>
<br>
<b>note:</b><br>
Returns a string formated as "address:port".<br>
<br>
The "peer" is the remote connection point oft his socket.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />
<h1>Methods</h1>

<h2>isClient</h2>
<pre><code>public function isClient():Boolean<br>
</code></pre>
Indicates if the socket is a TCP client.<br>
<br>
<b>note:</b><br>
To be a "client" the socket need to be of the <b>Stream</b> type<br>
and of the <code>connected</code> state.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>isServer</h2>
<pre><code>public function isServer():Boolean<br>
</code></pre>
Indicates if the socket is a TCP server.<br>
<br>
<b>note:</b><br>
To be a "server" the socket need to be of the <b>Stream</b> type<br>
and of the <code>bound</code> and <code>listening</code> state.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>Socket</h2>
<pre><code>public function Socket( family:int = -1, socktype:int = -1, protocol:int = -1 )<br>
</code></pre>
The Socket constructor.<br>
<br>
<b>note:</b><br>
Calls the <code>onConstruct()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
Without arguments will create a Stream (TCP) socket by default.<br>
<br>
To create another type of socket, reuse the constants defined in <a href='C_socket.md'>C.socket</a><br>
here how to create a Datagram (UDP) socket<br>
<pre><code>import avmplus.Socket;<br>
import C.socket.*;<br>
<br>
var udp:Socket = new Socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP );<br>
</code></pre>

When a socket is destroyed it calls the the <code>onDestruct()</code> function.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>connect</h2>
<pre><code>public function connect( host:String, port:int ):void<br>
</code></pre>
Connect a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onConnect()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>close</h2>
<pre><code>public function close():void<br>
</code></pre>
Close a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onDisconnect()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>send</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function send( data:String, flags:int = 0 ):void<br>
</code></pre>
Send a string message on a connected socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onSend()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
Internally we loop trough the <code>data.length</code> to be sure the full data is sent, like a <code>sendAll()</code>.<br>
<br>
For more details see <a href='http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#sendall'>Beej's Guide to Network Programming - 7.3. Handling Partial send()s</a><br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTROUTE </td><td> Send without using routing tables </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font><br> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>sendBinary</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function sendBinary( data:ByteArray, flags:int = 0 ):void<br>
</code></pre>
Send a binary message on a connected socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onSend()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
Internally we loop trough the <code>data.length</code> to be sure the full data is sent, like a <code>sendAll()</code>.<br>
<br>
For more details see <a href='http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#sendall'>Beej's Guide to Network Programming - 7.3. Handling Partial send()s</a><br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTROUTE </td><td> Send without using routing tables </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font><br> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>sendTo</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function sendTo( host:String, port:int, data:String, flags:int = 0 ):void<br>
</code></pre>
Send a string message on a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onSend()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
The full data is sent in one packet, nothing guarantee that all the data is transfered.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTROUTE </td><td> Send without using routing tables </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font><br> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>sendBinaryTo</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function sendBinaryTo( host:String, port:int, data:ByteArray, flags:int = 0 ):void<br>
</code></pre>
Send a binary message on a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onSend()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
The full data is sent in one packet, nothing guarantee that all the data is transfered.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTROUTE </td><td> Send without using routing tables </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font><br> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receive</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function receive( buffer:uint = 1024, flags:int = 0 ):String<br>
</code></pre>
Receive part of a string message from a connected socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onReceive()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
The data is received fragmented by the size of the <code>buffer</code>.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_PEEK     </td><td> Leave received data in queue </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_WAITALL  </td><td> Attempt to fill the read buffer </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receiveAll</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function receiveAll( buffer:uint = 1024, flags:int = 0 ):String<br>
</code></pre>
Receive all of a string message from a connected socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onReceiveAll()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
The method loop till all the fragments are received.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_PEEK     </td><td> Leave received data in queue </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_WAITALL  </td><td> Attempt to fill the read buffer </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receiveBinary</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function receiveBinary( buffer:uint = 1024, flags:int = 0 ):ByteArray<br>
</code></pre>
Receive part of a binary message from a connected socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onReceive()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
The data is received fragmented by the size of the <code>buffer</code>.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_PEEK     </td><td> Leave received data in queue </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_WAITALL  </td><td> Attempt to fill the read buffer </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receiveBinaryAll</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function receiveBinaryAll( buffer:uint = 1024, flags:int = 0 ):ByteArray<br>
</code></pre>
Receive all of a binary message from a connected socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onReceiveAll()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
The method loop till all the fragments are received.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_PEEK     </td><td> Leave received data in queue </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_WAITALL  </td><td> Attempt to fill the read buffer </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receiveFrom</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function receiveFrom( buffer:uint = 512, flags:int = 0 ):String<br>
</code></pre>
Receive a string message from a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onReceive()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
Receive as much data as the <code>buffer</code> allows.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_PEEK     </td><td> Leave received data in queue </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_WAITALL  </td><td> Attempt to fill the read buffer </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>receiveBinaryFrom</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function receiveBinaryFrom( buffer:uint = 512, flags:int = 0 ):ByteArray<br>
</code></pre>
Receive a binary message from a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onReceive()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
Receive as much data as the <code>buffer</code> allows.<br>
<br>

<b>supported flags:</b>
<table><thead><th> <b>Flags</b> </th><th> <b>Description</b> </th><th> <b>POSIX</b> </th><th> <b>WIN32</b> </th></thead><tbody>
<tr><td> MSG_DONTWAIT </td><td> Enables non-blocking operation </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
<tr><td> MSG_OOB      </td><td> Out-of-band data   </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_PEEK     </td><td> Leave received data in queue </td><td> yes          </td><td> yes          </td></tr>
<tr><td> MSG_WAITALL  </td><td> Attempt to fill the read buffer </td><td> yes          </td><td> <font color='red'>no</font> </td></tr>
see <a href='http://code.google.com/p/redtamarin/wiki/C_socket#Socket_messages'>Socket messages</a> in C.socket</tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>bind</h2>
<pre><code>public function bind( port:uint, host:String = "" ):Boolean<br>
</code></pre>
Bind a name to a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onBind()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
By default, if you don't provide a <code>host</code> parameter,<br>
it will try to bind to the loopback address (<code>127.0.0.1</code>).<br>
<br>
You can only <code>bind()</code>to a local adress, see <a href='#localAddresses.md'>localAddresses</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>listen</h2>
<pre><code>public function listen( backlog:uint = 0 ):Boolean<br>
</code></pre>
Listen for socket connections and limit the queue of incoming connections.<br>
<br>
<b>note:</b><br>
Calls the <code>onListen()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
By default, if you don't provide a <code>backlog</code> parameter,<br>
the server will discard queued incoming connections (eg. <code>backlog=0</code>).<br>
<br>
The maximum <code>backlog</code> queue you can use can be found in <a href='#maxConnectionQueue.md'>maxConnectionQueue</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>accept</h2>
<font color='orange'>blocking</font><br>
<pre><code>public function accept():Socket<br>
</code></pre>
Accept a new connection on a socket.<br>
<br>
<b>note:</b><br>
Calls the <code>onAccept()</code> function (see <a href='#Callbacks.md'>Callbacks</a> section).<br>
<br>
If you need to be able to accept simultaneous connections,<br>
you will have to create a loop and test the <a href='#readable.md'>readable</a>/<a href='#writable.md'>writable</a><br>
properties of the sockets.<br>
<br>
See the examples in the <a href='Examples_Socket.md'>socket programming guide</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />
<h1>Callbacks</h1>

You can customize (overwrite,add more, remove, etc.) any callbacks<br>
see <a href='http://code.google.com/p/redtamarin/wiki/Examples_Socket#Events_and_Logs'>socket programming guide - Events and Logs</a>.<br>

<h2>log</h2>
<pre><code>prototype.log = function( message:String ):void<br>
{<br>
    this._logs.push( message );<br>
}<br>
</code></pre>
Save a log message.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>output</h2>
<pre><code>prototype.output = function( message:String ):void<br>
{<br>
    trace( message );<br>
}<br>
</code></pre>
Display a message.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>recordLogOnly</h2>
<pre><code>prototype.recordLogOnly = function( message:String ):void<br>
{<br>
    message = "Socket (" + this.descriptor + "): " + message;<br>
    this.log( message );<br>
}<br>
</code></pre>
Record only a to the logs.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>recordOutputOnly</h2>
<pre><code>prototype.recordOutputOnly = function( message:String ):void<br>
{<br>
    message = "Socket (" + this.descriptor + "): " + message;<br>
    this.output( message );<br>
}<br>
</code></pre>
Record only to the output.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>recordAll</h2>
<pre><code>prototype.recordAll = function( message:String ):void<br>
{<br>
    message = "Socket (" + this.descriptor + "): " + message;<br>
    this.log( message );<br>
    this.output( message );<br>
}<br>
</code></pre>
Record both to the logs and to the output.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>record</h2>
<pre><code>prototype.record = prototype.recordAll;<br>
</code></pre>
Default function to <b>record</b> a message.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onConstruct</h2>
<pre><code>prototype.onConstruct = function():void<br>
{<br>
    this.record( this.type + " socket created." );<br>
}<br>
</code></pre>
When a socket instance is created..<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onDestruct</h2>
<pre><code>prototype.onDestruct = function():void<br>
{<br>
    this.record( this.type + " socket destroyed." );<br>
}<br>
</code></pre>
When the socket instance is destroyed.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onConnect</h2>
<pre><code>prototype.onConnect = function():void<br>
{<br>
    this.record( "[" + this.local + "] connected to [" + this.peer + "]." );<br>
}<br>
</code></pre>
When the socket connect to a peer.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onDisconnect</h2>
<pre><code>prototype.onDisconnect = function( message:String = "" ):void<br>
{<br>
    if( message != "" ) { this.record( message ); }<br>
    if( this.isClient() )<br>
    {<br>
        this.record( "Disconnected from [" + this.peer + "]." );<br>
    }<br>
    else if( this.isServer() )<br>
    {<br>
        this.record( "[" + this.local + "] stop listening, unbound and disconnected." );<br>
    }<br>
}<br>
</code></pre>
When the socket disconnect from the peer.<br>
<br>
<b>note:</b><br>
The disconnection can be one of two things<br>
<ul><li>the remote client disconnected<br>
</li><li>the local socket closed</li></ul>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onSend</h2>
<pre><code>prototype.onSend = function( data:Number ):void<br>
{<br>
    this.record( "Sent " + data + " bytes." );<br>
}<br>
</code></pre>
When the socket send all the data.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onReceive</h2>
<pre><code>prototype.onReceive = function( data:Number ):void<br>
{<br>
    this.record( "Received " + data + " bytes." );<br>
}<br>
</code></pre>
When the socket receive data fragments.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onReceiveAll</h2>
<pre><code>prototype.onReceiveAll = function( data:Number ):void<br>
{<br>
    this.record( "Received all " + data + " bytes." );<br>
}<br>
</code></pre>
When the socket receive all the data.<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onBind</h2>
<pre><code>prototype.onBind = function( port:uint ):void<br>
{<br>
    var info:String = String(port);<br>
<br>
    if( this.local != "" ) { info = this.local; }<br>
<br>
    this.record( "Bound to [" + info + "]." );<br>
}<br>
</code></pre>
When the socket bind to an interface.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onListen</h2>
<pre><code>prototype.onListen = function( backlog:uint ):void<br>
{<br>
    this.record( "[" + this.local + "] listening (backlog=" + backlog + ")." );<br>
}<br>
</code></pre>
When the socket listen (and so become a server).<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>onAccept</h2>
<pre><code>prototype.onAccept = function( id:int ):void<br>
{<br>
    this.record( "[" + this.local + "] accept connection from [" + id + "]." );<br>
}<br>
</code></pre>
When the socket accept another socket connection.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />