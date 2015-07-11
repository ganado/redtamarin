## Introduction ##

What is a [Shell Script](http://en.wikipedia.org/wiki/Shell_script) ?
<pre>
A shell script is a script written for the shell, or command line interpreter, of an operating system.<br>
It is often considered a simple domain-specific programming language.<br>
Typical operations performed by shell scripts include file manipulation, program execution, and printing text.<br>
</pre>

In the Linux world most of shell scripts will use a [shebang](http://en.wikipedia.org/wiki/Shebang_(Unix))<br>
for ex:<br>
<pre><code>#!/bin/sh<br>
 <br>
clear<br>
ls -l -a<br>
</code></pre>

<br>
<br>

<h2>Making a wrapper shell script</h2>

let's say you have your script<br>
<b>hello.as</b>
<pre><code>trace( "hello world" );<br>
</code></pre>

that you would want to run directly as a shell script<br>
<br>
you could simply do that<br>
<b>hello</b>
<pre><code>#! /bin/sh<br>
<br>
/usr/share/redtamarin/redshell hello.as -- $@<br>
</code></pre>

don't forget to make the shell script executable<br>
<pre><code>$ sudo chmod +x hello<br>
</code></pre>

and then run it<br>
<pre><code>$ ./hello<br>
</code></pre>
when "hello" run, the shell will replace <code>$@</code> with any arguments you provided.<br>
<br>
<br>
<br>


<h2>Registering an extension as non-native binaries (Linux only)</h2>

Because this is a Linux-specific feature, we do not recommend that developers deploy this solution,<br>
as it would limit the portability of their scripts. (but yeah under a Linux distro this is so f*cking cool ;) )<br>
<br>
In short, this make use of <b>binfmt_misc</b>, here the introduction from <a href='http://www.kernel.org/doc/Documentation/binfmt_misc.txt'>the documentation</a>
<pre>
This Kernel feature allows you to invoke almost (for restrictions see below)<br>
every program by simply typing its name in the shell.<br>
This includes for example compiled Java(TM), Python or Emacs programs.<br>
<br>
To achieve this you must tell binfmt_misc which interpreter has to be invoked<br>
with which binary. Binfmt_misc recognises the binary-type by matching some bytes<br>
at the beginning of the file with a magic byte sequence (masking out specified<br>
bits) you have supplied. Binfmt_misc can also recognise a filename extension<br>
aka '.com' or '.exe'.<br>
</pre>


Let's do that all on the command line<br>
(in case of you have only SSH access to your server)<br>
<br>
download the file<br>
<pre><code>$ sudo wget http://redtamarin.googlecode.com/files/redtamarin_0.3.1.1049_NIX.zip<br>
</code></pre>

go to your home dir and unzip all to the /redtamarin dir<br>
<pre><code>$ cd ~<br>
$ sudo unzip -d redtamarin redtamarin_0.3.1.1049_NIX.zip<br>
</code></pre>

move it to <code>/usr/share</code>
<pre><code>$ sudo mv redtamarin /usr/share/redtamarin<br>
</code></pre>

you may need to make the shell executable<br>
<pre><code>$ cd /usr/share/redtamarin<br>
$ sudo chmod +x redshell<br>
$ sudo chmod +x redshell_d<br>
</code></pre>

and same for asc.jar<br>
<pre><code>$ sudo chmod +x asc.jar<br>
</code></pre>

mount binfmt_misc<br>
<pre><code>$ sudo mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc/<br>
</code></pre>

or automount on boot, add the following line to your <code>/etc/fstab</code>
<pre><code>none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0<br>
</code></pre>

register the extension <code>*.as3</code> as executable<br>
<pre><code>$ sudo echo ':AS3:E::as3::/usr/share/redtamarin/redshell_d:' &gt; /proc/sys/fs/binfmt_misc/register<br>
</code></pre>

if you obtain a "Permission Denied", see <a href='http://unix.stackexchange.com/questions/12949/sudo-nt-passing-after-redirection-operator'>sudo and redirection</a>  and try like that<br>
<pre><code>$ echo ':AS3:E::as3::/usr/share/redtamarin/redshell_d:' | sudo tee /proc/sys/fs/binfmt_misc/register<br>
</code></pre>


to unregister do that<br>
<pre><code>$ sudo echo -1 &gt; /proc/sys/fs/binfmt_misc/AS3<br>
</code></pre>
or<br>
<pre><code>$ echo -1 | sudo tee /proc/sys/fs/binfmt_misc/AS3<br>
</code></pre>

<b>note:</b><br>
we register the <code>*.as3</code> extension, you could register any <code>*.as</code>, or other extension you want<br>
here we felt that when you have a lot of code with the extension <code>*.as</code>, it feels better/safer to separate shell scripts as <code>*.as3</code>.<br>
<br>
to know the status of binfmt_misc<br>
<pre><code>$ sudo cat /proc/sys/fs/binfmt_misc/status<br>
</code></pre>
you should obtain "enabled" or "disabled"<br>
<br>
to disable binfmt_misc<br>
<pre><code>$ sudo echo 0 &gt; /proc/sys/fs/binfmt_misc/status<br>
</code></pre>
or<br>
<pre><code>$ echo 0 | sudo tee /proc/sys/fs/binfmt_misc/status<br>
</code></pre>

and to enable binfmt_misc<br>
<pre><code>$ sudo echo 1 &gt; /proc/sys/fs/binfmt_misc/status<br>
</code></pre>
or<br>
<pre><code>$ echo 1 | sudo tee /proc/sys/fs/binfmt_misc/status<br>
</code></pre>


you could also register an extension with a wrapper<br>
<br>
<b>abc-wrap.sh</b>
<pre><code>#! /bin/sh<br>
<br>
ABCNAME=$1<br>
shift<br>
/usr/share/redtamarin/redshell_d "${ABCNAME}" -- $@<br>
<br>
</code></pre>

<b>as3-wrap.sh</b>
<pre><code>#! /bin/sh<br>
<br>
AS3NAME=$1<br>
shift<br>
/usr/share/redtamarin/redshell_d "${AS3NAME}" -- $@<br>
<br>
</code></pre>

to register the wrappers do this<br>
<pre><code>$ sudo echo ':AS3:E::as3::/usr/share/redtamarin/as3-wrap.sh:' &gt; /proc/sys/fs/binfmt_misc/register<br>
$ sudo echo ':ABC:E::abc::/usr/share/redtamarin/abc-wrap.sh:' &gt; /proc/sys/fs/binfmt_misc/register<br>
</code></pre>
or<br>
<pre><code>$ echo ':AS3:E::as3::/usr/share/redtamarin/as3-wrap.sh:' | sudo tee /proc/sys/fs/binfmt_misc/register<br>
$ echo ':ABC:E::abc::/usr/share/redtamarin/abc-wrap.sh:' | sudo tee /proc/sys/fs/binfmt_misc/register<br>
</code></pre>



now let's make a test<br>
<b>hello.as3</b>
<pre><code>trace( "hello world" );<br>
</code></pre>

make the script executable<br>
<pre><code>$ chmod +x hello.as3<br>
</code></pre>

and then execute it<br>
<pre><code>$ ./hello.as3<br>
</code></pre>

<br>
<br>

<h2>Misc.</h2>

As it is, the <b>redshell</b> can execute plain text files or binary files<br>
<ul><li>plain text files: any "source code" file encoded as UTF-8<br>
<ul><li><code>*.as</code>, <code>*.as3</code>, etc.<br>
</li><li>you pass arguments like that<br><code>$ ./hello.as3 -- arg1 arg2 arg3</code>
</li><li>you can only use unqualified import<br>eg. <code>import avmplus.*</code>
</li></ul></li><li>binary files: any compiled file<br>
<ul><li><code>*.abc</code> file<br>
</li><li><code>*.swf</code> file (containing a group of <code>*.abc</code> files)<br>
</li><li>you pass arguments like that<br><code>$ ./hello.abc arg1 arg2 arg3</code>
</li><li>you can use both qualified and unqualified import