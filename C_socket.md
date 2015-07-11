<a href='Hidden comment: 
Because we are defining libraries for Tamarin we can not really use asdoc to document the source code.
So the rule is to document everything in the wiki page.
Yeah it sucks because we have to sync by hand, we"ll try to automate it later.

on the source code file, we use only one comment

/* documentation: http://code.google.com/p/redtamarin/wiki/C_socket */
'></a>

# About #
Socket constants and function helpers.

**package:** `C.socket.*`

**product:** redtamarin 0.3

**since:** 0.3.0

**references:**
  * http://en.wikipedia.org/wiki/Berkeley_sockets
  * http://pubs.opengroup.org/onlinepubs/007908799/xns/syssocket.h.html


---

# Constants #

## Socket types ##
| **SOCK\_RAW** | Raw Protocol Interface. |
|:--------------|:------------------------|
| **SOCK\_STREAM** | Byte-stream socket.     |
| **SOCK\_DGRAM** | Datagram socket.        |

**since:** 0.3.0

## Socket options ##
| **SO\_ACCEPTCONN** | Socket is accepting connections. |
|:-------------------|:---------------------------------|
| **SO\_BROADCAST**  | Transmission of broadcast messages is supported. |
| **SO\_DONTROUTE**  | Bypass normal routing.           |
| **SO\_KEEPALIVE**  | Connections are kept alive with periodic messages. |
| **SO\_OOBINLINE**  | Out-of-band data is transmitted in line. |
| **SO\_RCVBUF**     | Receive buffer size.             |
| **SO\_RCVTIMEO**   | Receive timeout.                 |
| **SO\_REUSEADDR**  | Reuse of local addresses is supported. |
| **SO\_SNDBUF**     | Send buffer size.                |
| **SO\_SNDTIMEO**   | Send timeout.                    |
| **SO\_TYPE**       | Socket type.                     |

**since:** 0.3.0

## Socket messages ##
| **MSG\_CTRUNC** | Control data truncated. |
|:----------------|:------------------------|
| **MSG\_DONTROUTE** | Send without using routing tables. |
| **MSG\_OOB**    | Out-of-band data.       |
| **MSG\_PEEK**   | Leave received data in queue. |
| **MSG\_TRUNC**  | Normal data truncated.  |
| **MSG\_WAITALL** | Attempt to fill the read buffer. |
| **MSG\_DONTWAIT** | Enables non-blocking operation; if the operation would block, EAGAIN is returned. |


**note:**<br>
About <code>MSG_DONTWAIT</code><br>
if <code>send()</code> would block because outbound traffic is clogged, have it return <code>EAGAIN</code>.<br>
This is like a "enable non-blocking just for this send."<br>

<b>since:</b> 0.3.0<br>
<br>
<h2>Socket domains</h2>
<table><thead><th> <b>AF_INET</b> </th><th> Internet domain sockets for use with IPv4 addresses. </th></thead><tbody>
<tr><td> <b>AF_INET6</b> </td><td> Internet domain sockets for use with IPv6 addresses. </td></tr>
<tr><td> <b>AF_UNSPEC</b> </td><td> Unspecified.                                         </td></tr></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<h2>Socket protocols</h2>
<table><thead><th> <b>IPPROTO_IP</b> </th><th> Internet protocol. </th></thead><tbody>
<tr><td> <b>IPPROTO_IPV6</b> </td><td> Internet Protocol Version 6. </td></tr>
<tr><td> <b>IPPROTO_ICMP</b> </td><td> Control message protocol. </td></tr>
<tr><td> <b>IPPROTO_RAW</b> </td><td> Raw IP Packets Protocol. </td></tr>
<tr><td> <b>IPPROTO_TCP</b> </td><td> Transmission control protocol. </td></tr>
<tr><td> <b>IPPROTO_UDP</b> </td><td> User datagram protocol. </td></tr></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<h2>Shutdown options</h2>
<table><thead><th> <b>SHUT_RD</b> </th><th> Disables further receive operations. </th></thead><tbody>
<tr><td> <b>SHUT_RDWR</b> </td><td> Disables further send and receive operations. </td></tr>
<tr><td> <b>SHUT_WR</b> </td><td> Disables further send operations.    </td></tr></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<h2>Misc.</h2>
<table><thead><th> <b>SOMAXCONN</b> </th><th> The maximum backlog queue length. </th></thead><tbody></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<hr />
<h1>Functions</h1>

<h2>gethostbyaddr</h2>
<pre><code>public function gethostbyaddr( addr:String, numeric:Boolean = false ):Array<br>
</code></pre>
Network host database function<br>
which returns a list of hostnames or IP addresses (<code>numeric=true</code>)<br>
by providing an IP address.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import C.socket.*;<br>
<br>
//first we want the origin IP<br>
trace( "origin: " + gethostbyname( "youtube.com", true ) ); //origin: 74.125.95.93,74.125.127.93<br>
<br>
//and now we can we can request with the IP address<br>
trace( "names: " + gethostbyaddr("74.125.95.93") ); //names: iw-in-f93.1e100.net,93.95.125.74.in-addr.arpa<br>
trace( "ips: " + gethostbyaddr("74.125.95.93", true) ); //ips: 74.125.95.93<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>gethostbyname</h2>
<pre><code>public function gethostbyname( hostname:String, numeric:Boolean = false ):Array<br>
</code></pre>
Network host database function<br>
which returns a list of hostnames or IP addresses (<code>numeric=true</code>)<br>
by providing a hostname.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import C.socket.*;<br>
<br>
trace( "names: " + gethostbyname("www.youtube.com") ); //names: youtube-ui.l.google.com,www.youtube.com<br>
trace( "ips: " + gethostbyname("www.youtube.com", true) ); //ips: 209.85.143.93,209.85.143.190,209.85.143.136,209.85.143.91<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getpeername</h2>
<pre><code>public function getpeername( descriptor:int ):String<br>
</code></pre>
Get the name of the peer socket.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getsockname</h2>
<pre><code>public function getsockname( descriptor:int ):String<br>
</code></pre>
Get the socket name.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />