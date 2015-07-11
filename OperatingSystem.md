<a href='Hidden comment: 
Here we can use asdoc to document the source code.
So the rule is to document the side notes in the wiki page.

/* more in depth informations: http://code.google.com/p/redtamarin/wiki/OperatingSystem */
'></a>

# About #
Provides informations about the Operating System.

**class:** `avmplus::OperatingSystem`

**product:** redtamarin 0.3

**since:** 0.3.0



---


# Properties #

## name ##
```
public static function get name():String
```
The OS kernel name.

**note:**<br>
Returns the <code>sysname</code> property from <code>uname()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>username</h2>
<pre><code>public static function get username():String<br>
</code></pre>
The current user name logged in the OS.<br>
<br>
<b>note:</b><br>
The same as using <code>getlogin()</code> from <a href='C_unistd.md'>C.unistd</a>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>nodename</h2>
<pre><code>public static function get nodename():String<br>
</code></pre>
Name of this node on the network.<br>
<br>
<b>note:</b><br>
Returns the <code>nodename</code> property from <code>uname()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<br>
<h2>hostname</h2>
<pre><code>public static function get hostname():String<br>
</code></pre>
The host name of the local computer.<br>
<br>
<b>note:</b><br>
The same as using <code>gethostname()</code> from <a href='C_unistd.md'>C.unistd</a>.<br>
The <code>nodename</code> and <code>hostname</code> are in general the same<br>
but depending on the OS configuration could be different (hence two different properties).<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<br>
<h2>release</h2>
<pre><code>public static function get release():String<br>
</code></pre>
Current release level of the OS.<br>
<br>
<b>note:</b><br>
Returns the <code>release</code> property from <code>uname()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<br>
<h2>version</h2>
<pre><code>public static function get version():String<br>
</code></pre>
Current version level of this release of the OS.<br>
<br>
<b>note:</b><br>
Returns the <code>version</code> property from <code>uname()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<br>
<h2>machine</h2>
<pre><code>public static function get machine():String<br>
</code></pre>
Name of the hardware type the system is running on.<br>
<br>
<b>note:</b><br>
Returns the <code>machine</code> property from <code>uname()</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<br>
<h2>vendor</h2>
<pre><code>public static function get vendor():String<br>
</code></pre>
Name of the vendor (commercial) or distributor (non-commercial) of this OS.<br>
<br>
<b>note:</b><br>
Can returns "Microsoft", "Apple", "Linux", etc.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<br>
<h2>vendorName</h2>
<pre><code>public static function get vendorName():String<br>
</code></pre>
Name of the OS provided by the vendor/distributor.<br>
<br>
<b>note:</b><br>
Can returns "Mac OS X", "Ubuntu", "Windows", "Windows 95", "Windows 98",<br>
"Windows ME", "Windows NT", "Windows XP", "Windows 2000", "Windows Vista",<br>
"Windows 7", "Windows Server 2003", "Windows Server 2003 <code>R2</code>",<br>
"Windows Server 2008", "Windows Server 2008 <code>R2</code>", etc.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>vendorVersion</h2>
<pre><code>public static function get vendorVersion():String<br>
</code></pre>
Version of the OS provided by the vendor/distributor.<br>
<br>
<b>note:</b><br>
Each vendors have their own logic so this version number "format" can vary a lot,<br>
<br>
for OS X it can returns "10.1", "10.5.2", "10.6.1", etc.<br>
<br>
for Windows it can returns "3.1", "4", "5.0", "5.1", "6.0", etc.<br>
also for Windows, the bugfix number is the major service pack number, 0 if no service pack<br>
example:<br>
Windows XP Professional Service Pack 3<br>
would return "5.1.3"<br>
<br>
for Ubuntu it can returns "8.04", etc.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>vendorDescription</h2>
<pre><code>public static function get vendorDescription():String<br>
</code></pre>
Description of the OS provided by the vendor/distributor,<br>
or the empty string if not defined.<br>
<br>
<b>note:</b><br>
Again each vendors have their own logic so we tried to "standardize" a format<br>
<pre><code>{Vendor} {VendorName} {VendorVersion} [desc. or version] ({CodeName} [version] {build})<br>
</code></pre>
for Windows you will get something like "Microsoft Windows 7 Home Premium (Vienna 6.1 build 2600)"<br>
<br>
for OS X you will get something like "Apple Mac OS X 10.5.1 (Leopard build 9B18)"<br>
<br>
for Ubuntu you will get something like "Linux Ubuntu 8.04.4 LTS (hardy)"<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>codename</h2>
<pre><code>public static function get codename():String<br>
</code></pre>
Codename of this OS, or "Unknown" if not defined.<br>
<br>
<b>note:</b><br>
for Windows can returns "Detroit", "Chicago", "Memphis", "Whistler", "Memphis NT",<br>
"Longhorn", "Longhorn Server", "Vienna", etc.<br>
<br>
for OS X can returns "Cheetah", "Puma", "Jaguar", "Panther", "Tiger", "Leopard", "Snow Leopard", etc.<br>
<br>
for Ubuntu can returns "hardy", etc.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>language</h2>
<pre><code>public static function get language():String<br>
</code></pre>
The OS language.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.OperatingSystem;<br>
<br>
trace( "language = " + OperatingSystem.language ); //language = en<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>country</h2>
<pre><code>public static function get country():String<br>
</code></pre>
The OS country.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.OperatingSystem;<br>
<br>
trace( "country = " + OperatingSystem.country ); //country = GB<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>locale</h2>
<pre><code>public static function get locale():String<br>
</code></pre>
The OS locale as <code>language[_country]</code>.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.OperatingSystem;<br>
<br>
trace( "locale = " + OperatingSystem.locale ); //locale = en_GB<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>codepage</h2>
<pre><code>public static function get codepage():String<br>
</code></pre>
The OS code page.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import avmplus.OperatingSystem;<br>
<br>
trace( "codepage = " + OperatingSystem.codepage ); //codepage = UTF-8<br>
</code></pre>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h1>Methods</h1>

<h2>reboot</h2>
<font color='red'>not implemented</font><br>
<pre><code>public function reboot():void<br>
</code></pre>
Definition test.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>shutdown</h2>
<font color='red'>not implemented</font><br>
<pre><code>public function shutdown():void<br>
</code></pre>
Definition test.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<hr />