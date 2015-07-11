everything you need to know to compile, setup, etc.

You will probably need to [Set up your development environment](http://code.google.com/p/maashaack/wiki/Tools) before being able to compile ASC, Tamarin, etc.


Here some additions for compiling C/C++

### Windows ###

You need to install **Microsoft Visual C++ 2008 Express Edition**<br>
<a href='http://www.microsoft.com/express/download/default.aspx'>http://www.microsoft.com/express/download/default.aspx</a>

It will also compile with <b>Microsoft Visual C++ 2010 Express Edition</b><br>
but the Tamarin team support only issues with the 2008 version.<br>
<br>
<br>
note:<br>
have a hotmail/msn account ready<br>
open VC++ and click help/register (use IE, chrome or firefox does not work)<br>
<br>
You need to install Mozilla Build <a href='http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/win32/MozillaBuildSetup-1.4.exe'>MozillaBuildSetup-1.4</a><br>
and add <code>C:\mozilla-build\msys\bin</code> to your environment variables<br>
see <a href='https://developer.mozilla.org/En/Developer_Guide/Build_Instructions/Windows_Prerequisites#MozillaBuild'>https://developer.mozilla.org/En/Developer_Guide/Build_Instructions/Windows_Prerequisites#MozillaBuild</a>

Configure cygwin bash to run VS C++ on the command line<br>
<br>
open your .bash_profile and add<br>
<pre><code># NOTE: The INCLUDE, LIB and LIBPATH must contain windows path information and separator and not cygwin paths.<br>
VS_HOME_PATH="/c/Program Files/Microsoft Visual Studio 9.0"<br>
VS_HOME="c:\Program Files\Microsoft Visual Studio 9.0"<br>
<br>
export PATH="$VS_HOME_PATH/Common7/IDE:$VS_HOME_PATH/VC/bin:$VS_HOME_PATH/Common7/Tools:$VS_HOME_PATH/VC/VCPackages:$PATH"<br>
export INCLUDE="$VS_HOME\VC\atlmfc\include;$VS_HOME\VC\include;C:\Program Files\Microsoft SDKs\Windows\v6.0A\Include;"<br>
export LIB="$VS_HOME\VC\atlmfc\lib;$VS_HOME\VC\lib;C:\Program Files\Microsoft SDKs\Windows\v6.0A\Lib"<br>
export LIBPATH="$VS_HOME\VC\atlmfc\lib;$VS_HOME\VC\lib;C:\Program Files\Microsoft SDKs\Windows\v6.0A\Lib"<br>
</code></pre>

misc:<br>
if you have limited RAM the build could end up with a fatal error, be sure to have at least 2GB of RAM (eg. for a VM setup).<br>
<br>
<br>
<h3>OS X</h3>

You need to install the Developer Tools (the 2nd install DVD) or you can download them here <a href='http://developer.apple.com/technologies/tools/'>http://developer.apple.com/technologies/tools/</a><br>
this will install Xcode, make, etc.<br>
<br>
<h3>Linux</h3>
(I'm testing on Ubuntu 8.04 so if you have another flavour adapt accordingly)<br>
<br>
You need to install <b>build-essential</b>
<pre><code>$ sudo apt-get install build-essential<br>
</code></pre>
(strangely this basic thing can be a stopper for more than one)<br>
<br>
after that all should go smooth.<br>
<br>
If <code>build.xml</code> or <code>release.xml</code> encounter a "Script not found" with Ant,<br>
get your Ant version, then <a href='http://ant.apache.org/bindownload.cgi'>download</a> the same version,<br>
an copy all the jars from <code>/lib</code> to <code>/usr/share/ant/lib</code>.<br>
<br>
For ex, with Ubuntu 8.04, I had by default Ant 1.7.0,<br>
from the <a href='http://archive.apache.org/dist/ant/binaries/'>old Ant releases</a> I downloaded <code>apache-ant-1.7.0-bin.zip</code><br>
and then (after extraction) <code>$sudo cp apache-ant-1.7.0-bin/lib/*.jar /usr/share/lib/</code>.