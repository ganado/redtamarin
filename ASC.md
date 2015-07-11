### Introduction ###

The ActionScript Compiler, or **ASC**, is available as a component from the open source [Flex SDK](http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK).

Written in Java, and distributed as a Jar file (asc.jar),<br>
it allows to compile <code>*.as</code> source code to an <code>*.abc</code> file (<a href='ABC.md'>ActionScript Byte Code</a>),<br>
or to a <code>*.swf</code> file, or to an executable file.<br>
<br>
<h3>Options</h3>

<pre><code>ActionScript 3.0 for AVM+<br>
version 1.0 build cyclone<br>
Copyright (c) 2003-2007 Adobe Systems Incorporated<br>
Copyright (c) 1998-2003 Mountain View Compiler Company<br>
All rights reserved<br>
<br>
Usage:<br>
  asc {-AS3|-ES|-d|-f|-h|-i|-import &lt;filename&gt;|-in &lt;filename&gt;|-m|-p}* filespec<br>
  -AS3 = use the AS3 class based object model for greater performance and better error reporting<br>
  -ES = use the ECMAScript edition 3 prototype based object model to allow dynamic overriding of prototype properties<br>
  -d = emit debug info into the bytecode<br>
  -f = print the flow graph to standard out<br>
  -h = print this message<br>
  -i = write intermediate code to the .il file<br>
  -import &lt;filename&gt; = make the packages in the<br>
       specified file available for import<br>
  -in &lt;filename&gt; = include the specified filename<br>
       (multiple -in arguments allowed)<br>
  -m = write the avm+ assembly code to the .il file<br>
  -p = write parse tree to the .p file<br>
  -md = emit metadata information into the bytecode<br>
  -warnings = warn on common actionscript mistakes<br>
  -strict = treat undeclared variable and method access as errors<br>
  -sanity = system-independent error/warning output -- appropriate for sanity testing<br>
  -log = redirect all error output to a logfile<br>
  -exe &lt;avmplus path&gt; = emit an EXE file (projector)<br>
  -swf classname,width,height[,fps] = emit a SWF file<br>
  -language = set the language for output strings {EN|FR|DE|IT|ES|JP|KR|CN|TW}<br>
  -optimize = produced an optimized abc file<br>
  -config ns::name=value = define a configuration value in the namespace ns<br>
  -use &lt;namespace&gt; = automatically use a namespace when compiling this code<br>
  -avmtarget &lt;vm version number&gt; = emit bytecode for a specific VM version, 1 is AVM1, 2 is AVM2, etc<br>
  -api &lt;version&gt; = compile program as a specfic version between 660 and 670<br>
</code></pre>

<h3>Usage</h3>

with helloworld.as<br>
<pre><code>trace( "hello world" );<br>
</code></pre>

a very basic usage<br>
<pre><code>$ java -jar asc.jar -AS3 -import builtin.abc -import toplevel.abc helloworld.as<br>
helloworld.abc, 127 bytes written<br>
</code></pre>


When you need to compile "system" libraries you will need more options<br>
<pre><code>$ java -jar asc.jar -abcfuture -builtin -apiversioning -import builtin.abc<br>
   shell_toplevel.as Domain.as ByteArray.as ...<br>
</code></pre>

or<br>
<pre><code>$ java -ea -DAS3 -DAVMPLUS -classpath asc.jar macromedia.asc.embedding.ScriptCompiler<br>
   -abcfuture -builtin -apiversioning -import builtin.abc -out shell_toplevel<br>
   shell_toplevel.as Domain.as ByteArray.as ...<br>
</code></pre>

<h3>Misc.</h3>

In the futur we will try to provide an <code>asc.exe</code> made with redtamarin<br>
that will add the following features<br>
<ul><li>act as a wrapper, detect if Java is installed<br>
</li><li>detect the <code>asc.jar</code>, if not found install or download it from the internet<br>
</li><li>support wildcard includes, eg. <code>asc -import builtin.abc src/*.as main.as</code>
</li><li>etc.</li></ul>

<h3>Ressources</h3>

<b>links:</b>
<ul><li><a href='http://opensource.adobe.com/svn/opensource/flex/sdk/sandbox/asc-redux/'>asc-redux repository</a> (Adobe)<br>
</li><li><a href='https://github.com/apache/flex-sdk/tree/master/modules/asc'>asc module</a> (Apache Flex)