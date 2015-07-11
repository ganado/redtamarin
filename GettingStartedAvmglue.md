## Introduction ##

Avmglue is about being able to reuse AS3 code written for the Flash Player and AIR<br>
on the redshell command line.<br>
<br>
The goal of <code>avmglue.abc</code> is to replicate <code>playerglobal.swc</code> and <code>airglobal.swc</code>.<br>
<br>
See more informations:<br>
<ul><li><a href='http://code.google.com/p/redtamarin/wiki/API#Layer_1_:_Flash_Platform'>API Layer 1 : Flash Platform</a>
</li><li><a href='http://code.google.com/p/maashaack/wiki/avmglue'>the avmglue project page</a>
</li><li><a href='http://code.google.com/p/redtamarin/wiki/FlashPlatform'>Flash Platform API</a></li></ul>


you can <a href='http://code.google.com/p/maashaack/downloads/list'>download avmglue here</a>

Quickly put, redtamarin does not have the same native implementations as Flash or AIR,<br>
but we can emulate them.<br>
<br>
For ex, redtamarin define <code>getTimer()</code> in the <code>avmplus.System</code> class,<br>
and Flash/AIR define <code>getTimer()</code> in the <code>flash.utils</code> package.<br>
<br>
The role of <b>avmglue</b> is to make the redtamarin APi compatible with Flash/AIR,<br>
by providing an implementation<br>
<pre><code>package flash.utils<br>
{<br>
    import avmplus.System;<br>
    <br>
    public var getTimer:Function = function():int<br>
    {<br>
        return System.getTimer();<br>
    }<br>
}<br>
</code></pre>
same signature and behaviour as the FPAPI.<br>
<br>
or by providing a mock<br>
<pre><code>package flash.utils<br>
{<br>
    public var getTimer:Function = function():int<br>
    {<br>
        return 0;<br>
    }<br>
}<br>
</code></pre>
same signature as the FPAPI but no real code.<br>
<br>
That way if you already spent hours writing AS3 code to make it run in Flash or AIR<br>
by using <b>avmglue.abc</b> you should be able to compile your code directly for redtamarin,<br>
or at least have a very minimal code effort to port your already existing library for the command line.<br>
<br>
<table><thead><th> <b>Mind that avmglue is far from complete and the ideal situation described above is not there yet.</b> </th></thead><tbody></tbody></table>


<h2>Details</h2>

After following the <a href='GettingStarted.md'>getting started</a> instructions<br>
<br>
1. you will need to add <b>avmglue.swc</b> next to <b>redtamarin.swc</b>

for ex:<br>
<pre><code>..<br>
  |_ bin<br>
  |    |_ ...<br>
  |<br>
  |_ src<br>
  |   |_ ...<br>
  |<br>
  |_ lib-swc<br>
      |_ redtamarin.swc<br>
      |_ avmglue.swc<br>
</code></pre>
<br>
<br>

2. you will need to update your <b>bin</b> folder with <b>avmglue.abc</b>

<pre><code>..<br>
 |_ bin<br>
     |_ abcdump<br>
     |_ asc<br>
     |_ asc.ajr<br>
     |_ avmglue.abc     &lt;- here<br>
     |_ builtin.abc<br>
     |_ createprojector<br>
     |_ EclipseExternalTools<br>
     |_ redshell<br>
     |_ redshell_d<br>
     |_ swfmake<br>
     |_ toplevel.abc<br>
</code></pre>
<br>
<br>

3. and finally you will need to update your tools<br>
<br>
copy <b>ASC_compile</b> to <b>ASC_compile_avmglue</b>

update the task from<br>
<pre><code>Location: ${project_loc}/bin/asc<br>
Working Directory: ${project_loc}/bin/<br>
Arguments: -AS3 -strict -import builtin.abc -import toplevel.abc ${resource_loc}<br>
</code></pre>

to<br>
<pre><code>Location: ${project_loc}/bin/asc<br>
Working Directory: ${project_loc}/bin/<br>
Arguments: -AS3 -strict -import builtin.abc -import toplevel.abc -import avmglue.abc ${resource_loc}<br>
</code></pre>
<br>

copy <b>redshell_debug</b> to <b>redshell_debug_avmglue</b>

update the task from<br>
<pre><code>Location: ${project_loc}/bin/redshell_d<br>
Working Directory: ${project_loc}/src/<br>
Arguments: ${resource_loc}<br>
</code></pre>

to<br>
<pre><code>Location: ${project_loc}/bin/redshell_d<br>
Working Directory: ${project_loc}/src/<br>
Arguments: ../bin/avmglue.abc ${resource_loc}<br>
</code></pre>


<h2>Compiling</h2>

If you're dealing only with <code>*.abc</code> files, with <code>builtin.abc</code> and <code>toplevel.abc</code><br>
because those libs are already embedded in the redshell executable<br>
you don't need to embed those <code>*.abc</code> in your <code>program.abc</code>.<br>
<br>
With <code>avmglue.abc</code> it is different, there you HAVE TO embed it yourself,<br>
or your final <code>program.abc</code> will miss a library.<br>
<br>
The shells can run different <code>*.abc</code> files at the same time:<br>
<pre><code>$ ./redshell avmglue.abc program.abc<br>
</code></pre>

Doing like that is fine to run some tests when you're constantly compiling <code>program.abc</code>,<br>
but when you want to distribute your program it is less than ideal.<br>
<br>
<br>
You can compile a single <code>*.abc</code> if you build everything from sources<br>
(eg. your program but also avmglue), and then use ASC with the option <code>-exe</code> to emit an executable.<br>
<br>
The problem with that is that it defeat the purpose of distributing <code>avmglue.abc</code> as a library.<br>
<br>
<br>
What you want is<br>
<ul><li>compile your <code>program.abc</code>
</li><li>reuse <code>avmglue.abc</code> as it is<br>
</li><li>embed everything in one executable</li></ul>

Here how to do that: use <code>swfmake</code> and <code>createprojector</code>
<ul><li><code>swfmake</code> will allow you to stick different <code>*.abc</code> files in a <code>*.swf</code> file<br>
</li><li><code>createprojector</code> will allow you to build an exe by merging one of the shells with that <code>*.swf</code></li></ul>

<pre><code>$ ./swfmake -o program.swf -c avmglue.abc program.abc<br>
$ ./createprojector -exe redshell -o program program.swf<br>
</code></pre>

Also wether you are on OS X / Linux / Windows you will be able to create an executable for all the other systems<br>
<br>
by default I work under OS X, and so I run that to build an OS X executable<br>
<pre><code>$ ./swfmake -o program.swf -c avmglue.abc program.abc<br>
$ ./createprojector -exe redshell -o program program.swf<br>
</code></pre>

but from OS X, if I wanted to build a Windows exe, I could simply do that<br>
<pre><code>$ ./swfmake -o program.swf -c avmglue.abc program.abc<br>
$ ./createprojector -exe redshell.exe -o program.exe program.swf<br>
</code></pre>