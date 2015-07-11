### Introduction ###

Basically we follow the same process than Tamarin<br>
see <a href='https://developer.mozilla.org/En/Tamarin/Tamarin_Build_Documentation'>Tamarin Build Documentation</a>.<br>
<br>
But we got all that wrapped up in a nice Ant build to automate a couple of things.<br>
<br>
<br>
<h3>Ant</h3>

There is more than one type of build<br>
<br>
<h4>Local</h4>

The local build use <code>build.xml</code> and should be used when you edit/add/remove code/features/bugs/etc. locally.<br>
<br>
In short, it's what I use when I add features to redtamarin :).<br>
<br>
simple usage<br>
<pre><code>$ ant<br>
</code></pre>

The build will check if you have <code>asc.jar</code> available, if not, it will build it for you.<br>
<br>
The build will always run the <code>nativegen.py</code> on the <code>shell_toplevel.as</code>.<br>
<br>
And will finally run <code>make</code> from the <code>objdir-release</code>,<br>
if the <code>objdir-release</code> is not found, the build will run <code>configure.py</code> for you first.<br>
<br>
So, by default, it will build redtamarin as <b>release</b><br>
if an error occurs you will see the error message but not the stacktrace.<br>
<br>
If you want to build as <b>release-debugger</b> use<br>
<pre><code>$ ant -Dsetup=debugger<br>
</code></pre>
with that if an error occurs, on top of the error message you'll be able to see the stacktrace<br>
and you will be able to use options like <code>-Dastrace N</code>, <code>-Dverbose</code>, etc.<br>
<br>
and If you want to build as <b>debug-debugger</b> use<br>
<pre><code>$ ant -Dsetup=debug<br>
</code></pre>
almost the same as <b>release-debugger</b> but with that you'll be able to have even more debug infos.<br>
<br>
in case of doubt, you can easyly test your runtime version<br>
<pre><code>$ ./redshell -Dversion<br>
shell 1.4 release-debugger build cyclone<br>
features AVMSYSTEM_32BIT;AVMSYSTEM_UNALIGNED_INT_ACCESS;AVMSYSTEM_UNALIGNED_FP_ACCESS;<br>
AVMSYSTEM_LITTLE_ENDIAN;AVMSYSTEM_IA32;AVMSYSTEM_MAC;AVMFEATURE_DEBUGGER;<br>
AVMFEATURE_ALLOCATION_SAMPLER;AVMFEATURE_JIT;AVMFEATURE_ABC_INTERP;AVMFEATURE_EVAL;<br>
AVMFEATURE_PROTECT_JITMEM;AVMFEATURE_SHARED_GCHEAP;AVMFEATURE_STATIC_FUNCTION_PTRS;<br>
AVMFEATURE_MEMORY_PROFILER;AVMFEATURE_CACHE_GQCN;<br>
</code></pre>


<h4>Release</h4>

The release build use <code>release.xml</code> and should be used to produce a release of redtamarin.<br>
<br>
That's basically all the files that end up in a zip files for the download section.<br>
<br>
usage<br>
<pre><code>$ ant -f release.xml<br>
</code></pre>

This build will always generate asc.jar.<br>
<br>
This build will always run the <code>nativegen.py</code> on the <code>shell_toplevel.as</code>.<br>
<br>
This build will always generate a <b>release</b> version of redtamarin, eg. <b>redshell</b><br>
and also a <b>release-debugger</b> version, eg. <b>redshell_d</b>.<br>
<br>
<b>note:</b><br>
for now we keep things simple, so the <code>redshell</code> executable is always 32bit.<br>
Later, we will generate also 64bit versions.<br>
<br>
And finally, everything is packaged in a zip<br>
<pre><code>redtamarin_0.3.0.1234_WIN.zip<br>
redtamarin_0.3.0.1234_OSX.zip<br>
redtamarin_0.3.0.1234_NIX.zip<br>
</code></pre>


<h3>Misc.</h3>

<h4>file size</h4>
By default, the redtamarin executable is about 2MB, if you need a smaller executable<br>
there is <a href='http://upx.sourceforge.net/'>UPX</a>, the Ultimate Packer for eXecutables :).<br>
<br>
example:<br>
<pre><code>$ upx --brute -o redshell_c redshell<br>
....<br>
                       Ultimate Packer for eXecutables<br>
                          Copyright (C) 1996 - 2009<br>
UPX 3.04        Markus Oberhumer, Laszlo Molnar &amp; John Reiser   Sep 27th 2009<br>
<br>
        File size         Ratio      Format      Name<br>
   --------------------   ------   -----------   -----------<br>
   1983016 -&gt;    607419   30.63%   Mach/AMD64    redshell_c                    <br>
<br>
Packed 1 file.<br>
</code></pre>

Here, for example, the redshell executable is reduced to 600KB.<br>
<br>
note:<br>
for OSX, you can install it this way <code>$sudo port install upx</code>


<h4>shell</h4>

We always compile redtamarin with the eval option, so you may want to use <code>redshell</code> in bash scripts :).<br>
<br>
more infos<br>
TODO<br>
<br>
note:<br>
sadly <code>eval()</code> will work only with builtins, you can not use FileSystem, OperatingSystem, etc.<br>
<br>
<br>
<h4>server side</h4>

Technically you can use redtamarin right now as a CGI process on any server,<br>
wehn some API like MySQL and SQLite will be added I'll give more infos<br>
(and probably a whole wiki section just for the server side of things).<br>
<br>
TODO