from v0.4 redtamarin have gone to a huge refactor<br>
the motto basically is "do the right thing now, don't postpone it"<br>
<br>
<h2>v0.4 series</h2>

<h3>v0.4 2R00-???? - codename: Ginza (next)</h3>
<ul><li>start new libraries programmed in AS3<br>
<ul><li>implement network libraries like HTTP, URL, TELNET, FTP, etc.<br>
</li><li>implement compression libraries: ZIP, TAR/GZIP, BZ2, LZMA<br>
</li><li>implement more of AVMGlue: SharedObject reader/writer (.SOL)<br>
</li></ul></li><li>adapt <b>astuce</b> to the new API<br>
<ul><li>run unit tests on the command line<br>
</li><li>as a library (ABC)<br>
</li><li>as a command line tool (EXE)<br>
</li><li>start to write unit tests for all those libraries<br>
</li><li>integrate the tool in the SDK<br>
</li></ul></li><li>port/integrate <b>abcdump</b> to the SDK<br>
</li><li>port/integrate <b>abcdis</b> to the SDK<br>
</li><li>implement a basic event loop<br>
</li><li>implement a headless flash player<br>
</li><li>review all the encoding to support fully UTF-8 on stdin/stderr/stdout<br>
</li><li>more to come etc.</li></ul>

<h3>v0.4 1R00-???? - codename: Akihabara (active)</h3>
<ul><li>new build system - <b>done</b>
<ul><li>driven by Ant and cross platform<br>
</li><li>publish clean and complete documentation<br>
</li><li>publish redshell exe for Windows / Mac OS X / Linux<br>
<ul><li>release, debug, debug debugger<br>
</li><li>32bit and 64bit<br>
</li></ul></li></ul></li><li>updated to latest tamarin-redux - <b>done</b>
<ul><li>Proxy class<br>
</li><li>AMF serialisation<br>
</li><li>Workers<br>
</li><li>etc.<br>
</li></ul></li><li>refactor all the API - <b>in the work</b>
<ul><li><b>CLIB</b> C Standard Library for AS3<br>provide implementations of <b>ISO C / ANSI C</b> and <b>POSIX</b> C libraries<br>to use them in the context of ActionScript 3.0<br>
</li><li><b>RNL</b> RedTamarin Native Library<br>provides system level libraries: file system, sockets, databases, etc.<br>not 100% will be implemented, we focus mainly on socket and file system<br>
</li><li><b>AVMGlue</b> Flash Platform Glue Library<br>provides implementation of the Flash Platform API (FPAPI, eg. Flash Player and AIR)<br>not 100% will be implemented for this release but at least mock/fake class will be available with API versioning<br>
</li></ul></li><li>tools - <b>in the work</b>
<ul><li><b>RedTamarin SDK</b><br>install all the tools, define environment variables, documentations, etc.<br>
</li><li><b>redshell</b><br>our runtime based on avmshell<br>embed all the API: CLIB, RNL and AVMGlue<br> can run AS3 file, ABC file, SWF file<br>
</li><li><b>redbean</b><br>make tool using AS3 syntax<br>compiler tool reusing asc.jar, asc2.jar, etc.<br>produce ABC file, SWF file, EXE file<br>
</li><li><b>as3distro</b><br>package management util<br>allow to distribute and install libraries as: AS, ABC, SWC, EXE