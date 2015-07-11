## Introduction ##

Since redtamarin v0.3 we added a [Socket](Socket.md) class,<br>
and because programming socket can be complex,<br>
here a little guide with examples and howtos to get you started.<br>
<br>
Here some very good ressources we used for this guide<br>
<ul><li><a href='http://beej.us/guide/bgnet/'>Beej's Guide to Network Programming</a>
</li><li><a href='http://tangentsoft.net/wskfaq/'>Winsock Programmer’s FAQ</a>
</li><li><a href='http://www.faqs.org/faqs/unix-faq/programmer/faq/'>Unix Programming FAQ</a></li></ul>


<h2>Events and Logs</h2>

The <a href='Socket.md'>Socket</a> class is dynamic and define "logging" functions on its prototype.<br>
<br>
This allow you to override any of those functions depending on your needs.<br>
<br>
It's working like that<br>
<ul><li>for each action method, you have an event function defined on the prototype<br>for ex: <code>accept()</code> will call <code>onAccept()</code>
</li><li>all of these event functions call the <code>record()</code> function<br>
</li><li>the <code>record()</code> function dispatch a message to other functions like <code>log()</code>, <code>output()</code></li></ul>

here the different record mode you can define<br>
<ul><li><code>recordLogOnly()</code> (the default)<br>save the messages to an array<br>
</li><li><code>recordOutputOnly()</code><br>trace the messages to the output<br>
</li><li><code>recordAll()</code><br>save the messages and trace them to the output</li></ul>

here how you can change how the <code>record()</code> function works<br>
<pre><code>Socket.prototype.record = Socket.prototype.recordAll;<br>
var sock:Socket = new Socket();<br>
</code></pre>

to disable completely the <code>record()</code> function just bind to an anonymous function<br>
<pre><code>Socket.prototype.record = function() {};<br>
var sock:Socket = new Socket();<br>
</code></pre>

to have a custom record function, define your own and override<br>
<pre><code>import avmplus.FileSystem;<br>
import avmplus.Socket;<br>
<br>
Socket.prototype.recordCustom = function( message:String ):void<br>
{<br>
    message = "Socket (" + this.descriptor + "): " + message;<br>
    this.log( message );<br>
    this.output( message );<br>
<br>
    //custom<br>
    var file:String = "socketlogs.txt";<br>
    var data:String = "";<br>
    if( FileSystem.exists( file ) )<br>
    {<br>
        data = FileSystem.read( file );<br>
    }<br>
    data += message + "\n";<br>
    FileSystem.write( file, data );<br>
}<br>
<br>
Socket.prototype.record = Socket.prototype.recordCustom;<br>
<br>
var client:Socket = new Socket();<br>
</code></pre>

<h2>Local IP addresses</h2>

On most machine you will see at least two addresses<br>
<ul><li>one for the loopback interface <code>127.0.0.1</code>
</li><li>one for an external network interface</li></ul>

But you can have more: modem, ethernet, wifi, firewire, etc.<br>
<br>
We don't provide access to network interfaces, subnet mask, MAC addresses, etc.<br>
but the Socket class provide the static property <code>Socket.localAddresses</code><br>
which will list those addresses.<br>
<br>
We basically copied the example <a href='http://tangentsoft.net/wskfaq/examples/ipaddr.html'>Get the Local IP Address(es)</a><br>
from the Winsock Programmer’s FAQ.<br>
<br>
Here how we do it<br>
<pre><code>        public static function get localAddresses():Array<br>
        {<br>
            var addresses:Array = [];<br>
            var localhost:Array = gethostbyname( "localhost", true );<br>
            var hostname:Array  = gethostbyname( OperatingSystem.hostname, true );<br>
<br>
            if( localhost.length &gt; 0 )<br>
            {<br>
                addresses = addresses.concat( localhost );<br>
            }<br>
            <br>
            if( hostname.length &gt; 0 )<br>
            {<br>
                addresses = addresses.concat( hostname );<br>
            }<br>
            <br>
            return addresses;<br>
        }<br>
</code></pre>

We reuse <code>gethostbyname()</code> from <code>C.socket</code>,<br>
use the option to return numeric addresses<br>
then request "localhost" and the current hostname.<br>
<br>
Here a little test on my machine<br>
<pre><code>import avmplus.Socket;<br>
<br>
trace( "Local IP addresses:" );<br>
trace( Socket.localAddresses.join( "\n" ) );<br>
<br>
//output<br>
/*<br>
Local IP addresses:<br>
127.0.0.1<br>
192.168.0.2<br>
172.16.80.1<br>
192.168.212.1<br>
*/<br>
</code></pre>

Let's compare with what I obtain if I do a <code>ifconfig</code> under OS X (<code>ipconfig</code> under Windows)<br>
<pre><code>$ ifconfig<br>
lo0: flags=8049&lt;UP,LOOPBACK,RUNNING,MULTICAST&gt; mtu 16384<br>
	inet6 ::1 prefixlen 128 <br>
	inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1 <br>
	inet 127.0.0.1 netmask 0xff000000 <br>
en0: flags=8863&lt;UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST&gt; mtu 1500<br>
	ether 00:23:df:ff:07:22 <br>
	inet6 fe80::223:dfff:feff:722%en0 prefixlen 64 scopeid 0x4 <br>
	inet 192.168.0.2 netmask 0xffffff00 broadcast 192.168.0.255<br>
	media: autoselect (100baseTX &lt;full-duplex,flow-control&gt;)<br>
	status: active<br>
fw0: flags=8863&lt;UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST&gt; mtu 4078<br>
	lladdr d4:9a:20:ff:fe:cc:d5:6e <br>
	media: autoselect &lt;full-duplex&gt;<br>
	status: inactive<br>
vmnet1: flags=8863&lt;UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST&gt; mtu 1500<br>
	ether 00:50:56:c0:00:01 <br>
	inet 172.16.80.1 netmask 0xffffff00 broadcast 172.16.80.255<br>
vmnet8: flags=8863&lt;UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST&gt; mtu 1500<br>
	ether 00:50:56:c0:00:08 <br>
	inet 192.168.212.1 netmask 0xffffff00 broadcast 192.168.212.255<br>
</code></pre>

See, not only it shows my loopback IP, but also my IP on the ethernet interface (en0),<br>
it does not trace the firewire interface (fw0) as it is not active,<br>
and it traces two different IPs for the VM I'm running (vmnet1 and vmnet8).<br>
<br>
<br>
<br>
<h2>Other stuff</h2>