### Introduction ###

The ActionScript Compiler 2.0, or **ASC2**, has been introduced as part of the AIR 3.4/FP 11.4 SDK preview
and Flash Builder 4.7 Preview.

**ASC2** is now distributed with **Flash CC** (Flash C++ Compiler) and the **AIR SDK** (since AIR 3.6).

Written in Java, and distributed as a Jar file (asc2.jar), same as ASC<br>
it allows to compile <code>*.as</code> source code to an <code>*.abc</code> file (<a href='ABC.md'>ActionScript Byte Code</a>),<br>
or to a <code>*.swf</code> file, or to an executable file.<br>
<br>
<h3>Options</h3>

<pre><code>ActionScript 3.0 Compiler for AVM+<br>
Version 2.0.0 build 348281<br>
Copyright 2003-2012 Adobe Systems Incorporated. All rights reserved.<br>
<br>
usage: asc [-abcfuture] [-api &lt;version&gt;] [-AS3] [-avmtarget &lt;vm version<br>
       number&gt;] [-b] [-coach] [-config &lt;ns::name=value&gt;] [-d] [-doc]<br>
       [-ES] [-ES4] [-exe &lt;avmplus path&gt;] [-f] [-h] [-i] [-import<br>
       &lt;filename&gt;] [-in &lt;filename&gt;] [-inline] [-l] [-language &lt;lang&gt;]<br>
       [-le &lt;swc file&gt;] [-li &lt;swc file&gt;] [-log] [-m] [-md] [-merge]<br>
       [-movieclip] [-o] [-o2 &lt;name=value&gt;] [-optimize] [-out<br>
       &lt;basename&gt;] [-outdir &lt;output directory name&gt;] [-p] [-parallel]<br>
       [-removedeadcode] [-sanity] [-static] [-strict] [-swf<br>
       &lt;classname,width,height[,fps]&gt;] [-use &lt;namespace&gt;] [-warnings]<br>
       FILENAME...<br>
options:<br>
 -abcfuture                            future abc<br>
 -api &lt;version&gt;                        compile program as a specfic version between 660 and 670<br>
 -AS3                                  use the AS3 class based object model for greater performance and better error reporting<br>
 -avmtarget &lt;vm version number&gt;        emit bytecode for a target virtual machine version, 1 is AVM1, 2 is AVM2<br>
 -b                                    show bytes<br>
 -coach                                warn on common actionscript mistakes (deprecated)<br>
 -config &lt;ns::name=value&gt;              define a configuration value in the namespace ns<br>
 -d                                    emit debug info into the bytecode<br>
 -doc                                  emit asdoc info<br>
 -ES                                   use the ECMAScript edition 3 prototype based object model to allow dynamic overriding of prototype properties<br>
 -ES4                                  use ECMAScript 4 dialect<br>
 -exe &lt;avmplus path&gt;                   emit an exe file (projector)<br>
 -f                                    print the flow graph to standard out<br>
 -h,--help                             print this help message<br>
 -i                                    write intermediate code to the .il file<br>
 -import &lt;filename&gt;                    make the packages in the abc file available for import<br>
 -in &lt;filename&gt;                        include the specified source file<br>
 -inline                               turn on the inlining of functions<br>
 -l                                    show line numbers<br>
 -language &lt;lang&gt;                      set the language for output strings {EN|FR|DE|IT|ES|JP|KR|CN|TW}<br>
 -le,--libraryext &lt;swc file&gt;           import a swc as external library<br>
 -li,--library &lt;swc file&gt;              import a swc library<br>
 -log                                  redirect all error output to a logfile<br>
 -m                                    write the avm+ assembly code to the .il file<br>
 -md                                   emit metadata information into the bytecode<br>
 -merge                                merge the compiled source into a single output file<br>
 -movieclip                            make movieclip<br>
 -o,--O                                produce an optimized abc file<br>
 -o2,--O2 &lt;name=value&gt;                 optimizer configuration<br>
 -optimize                             produce an optimized abc file<br>
 -out &lt;basename&gt;                       Change the basename of the output file<br>
 -outdir &lt;output directory name&gt;       Change the directory of the output files<br>
 -p                                    write parse tree to the .p file<br>
 -parallel                             turn on 'paralle generation of method bodies' feature for Alchemy<br>
 -removedeadcode                       remove dead code when -optimize is set<br>
 -sanity                               system-independent error/warning output -- appropriate for sanity testing<br>
 -static                               use static semantics<br>
 -strict,--!                           treat undeclared variable and method access as errors<br>
 -swf &lt;classname,width,height[,fps]&gt;   emit a SWF file<br>
 -use &lt;namespace&gt;                      automatically use a namespace when compiling this code<br>
 -warnings                             warn on common actionscript mistakes<br>
</code></pre>

<h3>Improvements</h3>

<ul><li>Flash Builder 4.7 and the ASC 2.0 command-line compiler now share the same code model. This avoids duplicate representations of a program and means the IDE has an accurate representation of the language - matching the compiler.<br>
</li><li>A new multi-threaded architecture allows multiple files to be compiled at once, improving compilation time.<br>
</li><li>Better constant-folding and constant-propagation results in better performing code at runtime.<br>
</li><li>Reduces function overhead by removing unnecessary activation records.<br>
</li><li>Contains some demonstration byte-code optimizations for in-lining and dead code elimination.<br>
</li><li>Non-linear control flow added to AS3 through a new 'goto' keyword.<br>
</li><li>SWF 13 with LZMA compression is now supported.<br>
</li><li>A new symbol management system means Flash Builder 4.7 ActionScript workspaces that mix Flash and AIR projects should incrementally compile much faster.<br>
</li><li>ASC 2.0 based versions of fontswf, optimizer, swfdump and swcdepends command-line tools are available.<br>
</li><li>Font transcoding has been removed from <a href='Embed.md'>Embed</a> syntax. Fonts should be pre-transcoded and embedded as a SWF, which can be performed using a tool like fontswf or Flash Professional CS6.<br>
</li><li>Relative paths in source code (<a href='Embed.md'>Embed</a> assets, includes, etc...) resolve relatively from the including file. To specify a path relative from a source root, prefix your path with a forward slash '/'.<br>
</li><li>US English compiler error messages have been translated into French, Japanese, and Simplified Chinese. The locale is determined by the JVM and can be overridden using the -tools-locale configuration option.<br>
</li><li>Added support for inlining. When the inlining feature is enabled, the compiler will attempt to inline getters, setters and any functions which are decorated with <a href='Inline.md'>Inline</a> metadata.<br>
</li><li>Added support for fast memory opcodes</li></ul>


<h3>Usage</h3>

with helloworld.as<br>
<pre><code>trace( "hello world" );<br>
</code></pre>

a very basic usage<br>
<pre><code>$ java -jar asc2.jar -AS3 -import builtin.abc -import toplevel.abc helloworld.as<br>
helloworld.abc, 127 bytes written<br>
</code></pre>

When you need to compile "system" libraries you will need more options<br>
<pre><code>$ java -jar asc2.jar -abcfuture -import builtin.abc<br>
   shell_toplevel.as Domain.as ByteArray.as ...<br>
</code></pre>

compile an abc API compatible with AIR_2_0<br>
<pre><code>$ java -jar asc2.jar -AS3 -api 668 -import builtin.abc -import toplevel.abc helloworld.as<br>
helloworld.abc, 127 bytes written<br>
</code></pre>

<b>note:</b><br>
here the list of options for api (see: <a href='http://hg.mozilla.org/tamarin-redux/file/5571cf86fc68/core/api-versions.as'>api-versions.as</a>)<br>
<ul><li><b>660</b> = FP_9_0<br>
</li><li><b>661</b> = AIR_1_0<br>
</li><li><b>662</b> = FP_10_0<br>
</li><li><b>663</b> = AIR_1_5<br>
</li><li><b>664</b> = AIR_1_5_1<br>
</li><li><b>665</b> = FP_10_0_32<br>
</li><li><b>666</b> = AIR_1_5_2<br>
</li><li><b>667</b> = FP_10_1<br>
</li><li><b>668</b> = AIR_2_0<br>
</li><li><b>669</b> = AIR_2_5<br>
</li><li><b>670</b> = FP_10_2<br>
the rest is either not supported or asc2 documentation is not up to date ???</li></ul>

swc are now supported too :)<br>
<pre><code>$ java -jar asc2.jar -AS3 -import builtin.abc -import toplevel.abc -li logd.swc helloworld.as<br>
helloworld.abc, 127 bytes written<br>
</code></pre>

or<br>
<br>
<pre><code>$ java -cp asc2.jar com.adobe.flash.compiler.clients.ASC -help<br>
<br>
ActionScript 3.0 Compiler for AVM+<br>
Version 2.0.0 build 348281<br>
Copyright 2003-2012 Adobe Systems Incorporated. All rights reserved.<br>
...<br>
</code></pre>

<pre><code>$ java -cp asc2.jar com.adobe.flash.compiler.clients.COMPC -help<br>
<br>
Adobe SWC Component Compiler (compc)<br>
Version 2.0.0 build 348281<br>
Copyright 2004-2012 Adobe Systems Incorporated. All rights reserved.<br>
...<br>
</code></pre>

<pre><code>$ java -cp asc2.jar com.adobe.flash.compiler.clients.MXMLC -help<br>
<br>
Adobe ActionScript Compiler (mxmlc)<br>
Version 2.0.0 build 348281<br>
Copyright 2004-2012 Adobe Systems Incorporated. All rights reserved.<br>
...<br>
</code></pre>

yes, ASC2 contains all the compilers: ASC, COMPC and MXMLC<br>
hence the much bigger size<br>
<br>
<pre><code>asc.jar ~= 1.3MB<br>
asc2.jar ~= 17.4MB<br>
</code></pre>


<h3>Misc.</h3>

You can find <b>asc2.jar</b> in the Flash C++ Compiler SDK<br>
<br>
here<br>
<pre><code>/SDK/FlashCC 1.0/sdk/usr/lib/asc2.jar<br>
<br>
FlashCC 1.0/<br>
.<br>
├── License_en-US.html<br>
├── License_fr-FR.html<br>
├── README.html<br>
├── docs<br>
│   ├── …<br>
│<br>
├── samples<br>
│   ├── …<br>
│<br>
└── sdk<br>
    ├── usr<br>
    │   ├── bin<br>
    │   ├── include<br>
    │   ├── lib     &lt;== here<br>
    │   ├── libexec<br>
    │   └── share<br>
    └── ver.txt<br>
</code></pre>

or<br>
<br>
you can find <b>compiler.jar</b> in the latest AIR SDK (3.6 and 3.7)<br>
<br>
here<br>
<pre><code>/SDK/AIR/sdks/AIR_3_7_ASC2/lib/compiler.jar<br>
<br>
<br>
AIR_3_7_ASC2/<br>
.<br>
├── AIR\ SDK\ Readme.txt<br>
├── AIR\ SDK\ license.pdf<br>
├── air-sdk-description.xml<br>
├── airsdk.xml<br>
├── ant<br>
│   └── …<br>
│<br>
├── asdoc<br>
│   └── …<br>
│<br>
├── bin<br>
│   └── …<br>
│<br>
├── frameworks<br>
│   └── …<br>
│<br>
├── include<br>
│   └── …<br>
│<br>
├── lib      &lt;== here<br>
│   └── ...<br>
├── runtimes<br>
│   └── …<br>
│<br>
├── samples<br>
│   └── …<br>
│<br>
└── templates<br>
    └── …<br>
<br>
</code></pre>

use it like that<br>
<pre><code>$ java -cp compiler.jar com.adobe.flash.compiler.clients.ASC -help<br>
<br>
ActionScript 3.0 Compiler for AVM+<br>
Version 2.0.0 build 348281<br>
Copyright 2003-2012 Adobe Systems Incorporated. All rights reserved.<br>
...<br>
</code></pre>



<h3>Ressources</h3>

<b>links:</b>
<ul><li><a href='http://www.bytearray.org/?p=4789'>Introducing ASC 2.0</a> by Thibault Imbert (Adobe)<br>
</li><li><a href='http://helpx.adobe.com/flash-builder/actionscript-compiler-backward-compatibility.html'>ActionScript Compiler 2.0 Backward Compatibility</a> (Adobe Documentation)<br>
</li><li><a href='http://gotoandlearn.com/play.php?id=170'>Inlining Functions with ASC 2.0</a> by Lee Brimelow (Adobe)<br>
</li><li><a href='http://gaming.adobe.com/technologies/flascc/'>Flash C++ Compiler</a> (Adobe)<br>
</li><li><a href='http://www.adobe.com/devnet/air/air-sdk-download.html'>Download Adobe AIR SDK</a> (Adobe)<br>
</li><li><a href='http://obtw.wordpress.com/2013/04/03/making-bytearray-faster/'>Making ByteArray faster</a> by Romil Mittal (Adobe)</li></ul>

<b>documents:</b>
<ul><li>(PDF) <a href='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/flashplayer/pdfs/adobe-actionscript-compiler-20-release-notes.pdf'>ActionScript Compiler 2.0 release notes</a> (Adobe)