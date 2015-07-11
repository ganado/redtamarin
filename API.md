## Introduction ##

from v0.4 we have a brand new API design, here the context and rules.

  * we embed in the runtime (redshell) all core and essential libraries<br>so we can access them at all time without the need to load them first.<br>
<ul><li>we split our API in 3 distinct parts:<br>
<ul><li>CLIB: C libraries, the lowest level<br>
</li><li>RNL: Native libraries, system level<br>
</li><li>AVMGlue: framework libraries, high level<br>
</li></ul></li><li>any other code or libraries is user level<br>either constitute the main program or external library to load<br>
</li><li>by default we are synchronous, blocking and use function callbacks<br>
</li><li>we then provide options to allow the user to be asynchronous, non-blocking and use events<br>
</li><li>an API definition can have those states<br>
<ul><li>not implemented<br>
</li><li>not supported<br>
</li><li>stub/mock/fake implementation<br>
</li><li>implemented</li></ul></li></ul>

<h2>CLIB</h2>

The C Standard Library for AS3.<br>
<br>
Provides the <b>low-level</b> access to the system as if you were writing C code.<br>
<br>
This is based on <b>ISO C / ANSI C</b> and <b>POSIX</b>, the goal is to let developers<br>
work with standard C functions.<br>
<br>
Maybe you want to duplicate a C example you saw online to do a very special thing,<br>
or maybe you already know C and work with what you already know, etc.<br>
<br>
The idea is if you can do it in C, you will be able to do it with this API.<br>
<br>
But, off course, there are differences:<br>
<ul><li>it's way easier to manipulate strings in AS3 than in C<br>so all functions like <code>printf</code>, <code>scanf</code> are not supported.<br>
</li><li>because we run inside a Virtual Machine with Garbage Collection<br>we don't support functions related to the memory and buffer<br>for ex: <code>malloc()</code>, <code>free()</code>, etc. are not supported<br>
</li><li>because the <b>AVM2</b> has its own logic of workers<br>we do not support threads, semaphores, mutexes, etc. no <code>fork()</code>, no <code>pthread_create()</code>, no <code>sem_init()</code>
</li><li>most of the function signatures are adapted to AS3 syntax</li></ul>

<h3>RNL</h3>

The RedTamarin Native Library.<br>
<br>
Provides <b>native</b> access to the system in a convenient way.<br>
<br>
It focus on the file system, the operating system, sockets, processes, environments, databases, etc.<br>
<br>
This is where the most work on API occurs because we have to define something where we had nothing.<br>
<br>
Our focus is the following<br>
<ul><li>well named and organised classes<br> we will not use <code>fs</code> but <code>FileSystem</code> for example.<br>
</li><li>abstraction and lowest common denominator for cross platform implementation<br>we want all our native classes to work the same under different Operating System<br>(unless exception like the Windows Registry).<br>
</li><li>focus on the native parts, it's not the goal to duplicate here the <b>FPAPI</b><br>because we will implement the FPAPI anyway in AVMGlue.<br>
</li><li>provide all the "tools" that we or you can reuse to build more complex classes.</li></ul>


<h3>AVMGlue</h3>

The AVMGlue Library.<br>
(The name come from <code>avmglue.abc</code> used by Adobe to produce the Flash Player.)<br>
<br>
Provides an open source implementation of the <b>Flash Player API</b> and <b>AIR API</b><br>
(what we call the <b>FPAPI</b>: Flash Platform API).<br>
<br>
The goal is to let the developer use what he or she already knows from working with Flash or AIR.<br>
<br>
But as we are not building an open source Flash Player there are limitations<br>
<ul><li>we support from Flash Player 9 and later, not earlier versions<br>
</li><li>we support AS3, not AS2, not AS1<br>
</li><li>we support AMF3, not AMF0<br>
</li><li>it is not our goal to display graphics<br>even if you can use a <code>Sprite</code> or <code>Bitmap</code> class it will not show something on the screen.<br>
</li><li>it took more than 10 years for a talented team of Adobe engineers<br>to define and implement all those API, don't expect a 100% implementation for everything.<br>
</li><li>because we run on the command line and server side we may change slightly the FPAPI<br>some behaviours or rules could be completely different,<br>for ex it would make no sense to limit our API based on a security sandbox.</li></ul>


<h3>Special Cases</h3>

<b>Packages</b>
<ul><li>we consider the package <code>flash.*</code> reserved<br>used in Tamarin, the Flash Player and AIR API<br>
</li><li>we consider the package <code>avmplus.*</code> reserved<br>used in Tamarin, the Flash Player and AIR API<br>
</li><li>we consider the package <code>avm2.*</code> reserved<br>used in Tamarin, the Flash Player 11.6 and AIR API 3.6 and later<br>
</li><li>we consider the package <code>C.*</code> reserved<br>used for CLIB<br>
</li><li>we consider the package <code>shell.*</code> reserved<br>used for RNL</li></ul>

<b>Namespaces</b>
<ul><li>we consider the namespace <code>AS3</code> reserved<br>used in Tamarin, Flash Player and AIR<br>
</li><li>we consider the namespace <code>flash_proxy</code> reserved<br>used in Tamarin, Flash Player and AIR<br>
</li><li>we consider the namespace <code>object_proxy</code> reserved<br>used in the Flex SDK<br>
</li><li>we consider the namespace <code>mx_internal</code> reserved<br>used in the Flex SDK<br>
</li><li>we consider the namespace <code>mx_inner</code> reserved<br>used in the Flex SDK<br>
</li><li>we consider the namespace <code>flash10</code> reserved<br>used in old asdoc ?<br>
</li><li>we consider the namespace <code>AVM2</code> reserved<br>used for RedTamarin internals