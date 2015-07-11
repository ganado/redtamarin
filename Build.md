### Introduction ###

Basically we follow the same process than Tamarin<br>
see <a href='https://developer.mozilla.org/En/Tamarin/Tamarin_Build_Documentation'>Tamarin Build Documentation</a>.<br>
<br>
But we got all that wrapped up in a nice Ant build to automate a couple of things.<br>
<br>
<h3>Dependencies</h3>

<ul><li>you need a 64bit Operating System to build everything<br>the build will work on a 32bit system but you will noo be able to build 64bit targets,<br>nor the SDK (as it requires both 32bit and 64bit targets), etc.<br>
</li><li>you need Python 2.6+<br>
</li><li>you need Ant 1.8+<br>
</li><li>see <a href='Coders.md'>Coders</a> for the special requirements on OS X / Linux / Windows</li></ul>

We build under those OS<br>
<ul><li>Mac OS X 10.8 64bit<br>
</li><li>Windows 7 Ultimate 64bit<br>
</li><li>Ubuntu 10.04 64bit</li></ul>

<h3>Supported Operating System</h3>

We don't plan to support<br>
<ul><li>Windows 2000<br>
</li><li>Mac PPC<br>
</li><li>Windows CE<br>
</li><li>Android<br>
</li><li>etc.</li></ul>

but in general<br>
<br>
the OSX binaries should work under<br>
<ul><li>Mac OS X 10.6<br>
</li><li>Mac OS X 10.7<br>
</li><li>Mac OS X 10.8</li></ul>

the Windows binaries should work under<br>
<ul><li>Windows XP<br>
</li><li>Windows Vista<br>
</li><li>Windows 7</li></ul>

the Linux binaries should work under<br>
<ul><li>Ubuntu<br>
</li><li>CentOS<br>
</li><li>Debian</li></ul>

if a very demanded/popular OS is missing for whatever reason<br>
we should be able to add another OS target to the build<br>
but with no guarantees<br>
<br>
think of it like that:<br>
there are more chances to put effort into supporting a special Ubuntu Kernel running on AWS<br>
than to support an obscure Linux PPC I patched the kernel myself that 3 person use on the planet.<br>
<br>
<h3>Usage</h3>

<h3>Versioning and Tag</h3>

We have changed the way we use the "build number"<br>
<br>
before we could use<br>
<pre><code>version = major . minor . build . revision<br>
</code></pre>

now we use only<br>
<pre><code>version = major . minor<br>
</code></pre>

and we use a tag<br>
<pre><code>tag = serie | cycle | build<br>
</code></pre>

for example:<br>
<pre><code>redtamarin-0.4-1R086<br>
</code></pre>

that's redtamarin<br>
<ul><li><b>version</b> 0.4<br>
</li><li><b>serie</b> 1<br>
</li><li><b>cycle</b> R<br>
</li><li><b>build</b> 086</li></ul>


here the basic rules<br>
<ul><li>each time you build, the build number increase to a maximum of <b>999</b>
</li><li>if the build reach <b>999</b> then we reset it to <b>000</b> and increase the <b>cycle</b> to the next letter<br>
</li><li>if the cycle reach <b>Z</b> then we reset the cycle to the letter <b>A</b> and increase the <b>serie</b></li></ul>

here what you could get<br>
<pre><code>0.4-1R086<br>
0.4-1R087<br>
0.4-1R088<br>
0.4-1R089<br>
...<br>
0.4-1R999<br>
0.4-1S000<br>
0.4-1S001<br>
0.4-1S002<br>
0.4-1S003<br>
...<br>
0.4-1S999<br>
0.4-1T000<br>
0.4-1U000<br>
0.4-1V000<br>
...<br>
0.4-1Z000<br>
...<br>
0.4-2A000<br>
0.4-2B000<br>
...<br>
etc.<br>
</code></pre>

we consider the version and the tag independent of each other<br>
after a suffisant amount of features we could decide to increase the <b>serie</b> and/or the <b>cycle</b> to create new tag<br>
after another suffisant amount of features we could decide to increase the version number instead.<br>
<br>
<br>
<b>Why ?</b>

from v0.4 to reach v1.0 we want an "agile" way to tag our releases<br>
<ul><li>we don't want a v0.23<br>
</li><li>v0.9 will be right before v1.0<br>
</li><li>but we know we can not reach v1.0 in only 7 releases<br>
</li><li>we gonna need many more "intermediary" releases<br>
</li><li>the tag is just here to show if you are "before" or "after"<br>eg. <b>X</b> is newer than <b>R</b><br>and <b>3F</b> is newer than <b>1X</b>
</li><li>you can technically build 25974 times per <b>serie</b>
</li><li>when you build on different OS it's easier to use a tag than a build or revision number<br>eg. wether you are on OSX/Linux/Windows that's the same tag for everyone</li></ul>

<h3>How to Build the SDK</h3>

1. build all the binaries under windows<br>
<pre><code>build.32bit = true<br>
build.64bit = true<br>
build.release = true<br>
build.debug = true<br>
build.debugger = true<br>
</code></pre>

copy <b>bin-release/windows</b> to a shared drive<br>
<br>
<br>
2. build all the binaries under linux<br>
<pre><code>build.32bit = true<br>
build.64bit = true<br>
build.release = true<br>
build.debug = true<br>
build.debugger = true<br>
</code></pre>

copy <b>bin-release/linux</b> to a shared drive<br>
<br>
3. under OS X<br>
add the windows and linux binaries in your <b>bin-release</b> folder<br>
<br>
4. enable all the options to <b>true</b>
<pre><code>build.32bit = true<br>
build.64bit = true<br>
build.release = true<br>
build.debug = true<br>
build.debugger = true<br>
build.documentation = true<br>
build.components = true<br>
build.sdk = true<br>
</code></pre>

5. run the build<br>
<br>
here what will happen<br>
<br>
after all the darwin binaries have been generated<br>
your <b>bin-release</b> folder will look like that<br>
<pre><code>bin-release/<br>
├── darwin<br>
│   ├── 32<br>
│   │   ├── debug<br>
│   │   │   └── redshell_d<br>
│   │   ├── debugger<br>
│   │   │   └── redshell_dd<br>
│   │   └── release<br>
│   │       └── redshell<br>
│   └── 64<br>
│       ├── debug<br>
│       │   └── redshell_d<br>
│       ├── debugger<br>
│       │   └── redshell_dd<br>
│       └── release<br>
│           └── redshell<br>
├── linux<br>
│   ├── 32<br>
│   │   ├── debug<br>
│   │   │   └── redshell_d<br>
│   │   ├── debugger<br>
│   │   │   └── redshell_dd<br>
│   │   └── release<br>
│   │       └── redshell<br>
│   └── 64<br>
│       ├── debug<br>
│       │   └── redshell_d<br>
│       ├── debugger<br>
│       │   └── redshell_dd<br>
│       └── release<br>
│           └── redshell<br>
└── windows<br>
    ├── 32<br>
    │   ├── debug<br>
    │   │   └── redshell_d.exe<br>
    │   ├── debugger<br>
    │   │   └── redshell_dd.exe<br>
    │   └── release<br>
    │       └── redshell.exe<br>
    └── 64<br>
        ├── debug<br>
        │   └── redshell_d.exe<br>
        ├── debugger<br>
        │   └── redshell_dd.exe<br>
        └── release<br>
            └── redshell.exe<br>
</code></pre>

after that you will also have the <b>documentation</b> and <b>components</b>
<pre><code>bin-release/<br>
├── components<br>
├── darwin<br>
├── documentation<br>
├── linux<br>
└── windows<br>
<br>
</code></pre>

then the SDK build will bundle everything in the <b>bin-deploy</b> folder<br>
<pre><code>bin-deploy/<br>
└── redtamarin-0.4-1R086<br>
</code></pre>

and you will obtain a zip file<br>
<b>redtamarin-0.4-1R086.zip</b>


<h3>Documentation</h3>

<h4>building binaries</h4>

<b>build.32bit</b> = <code>true/false</code><br>
to build all the 32bit targets<br>
<br>
<b>build.64bit</b> = <code>true/false</code><br>
to build all the 64bit targets<br>
<br>
<b>build.release</b> = <code>true/false</code><br>
to build all the release targets<br>
<br>
<b>build.debug</b> = <code>true/false</code><br>
to build all the debug targets<br>
<br>
<b>build.debugger</b> = <code>true/false</code><br>
to build all the debug debugger targets<br>
<br>
<b><i>options:</i></b>

<b>build.cleanGenerated</b> = <code>true/false</code><br>
to regenerate all the tracers, the builtin abc/h/cpp, the shell_toplevel abc/h/cpp<br>
it will define the environment variable <b>AVMSHELL_TOOL</b> for you<br>
and assign one of the precompiled avmshell exe to it.<br>
<br>
<br>
<b>NOTE:</b><br>
setting all to true will build 6 binaries<br>
and can take quite some time (depending on the system ressources)<br>
(a good 30mn/1h/2h/etc....)<br>
<br>
If for example you just need to compile locally to test some stuff<br>
you don't need all options set to true, you could for ex<br>
<pre><code>build.32bit = true<br>
build.64bit = false<br>
build.release = false<br>
build.debug = true<br>
build.debugger = false<br>
</code></pre>
this will build a single binary (debug 32bit).<br>
<br>
<br>
<h4>building documentation</h4>

<h4>building components</h4>

<h4>building SDK</h4>

<b>build.sdk</b> = <code>true/false</code><br>
to build and bundle the SDK for redistribution<br>
<br>
<b><i>options:</i></b>

<b>build.cleanBeforeDeploy</b> = <code>true/false</code><br>
to delete the "deploy" directory before generating the SDK files.<br>
<pre><code>#if you set it to false and generate multiple times the SDK<br>
<br>
#you will either merge the files in the same folder<br>
<br>
bin-deploy/<br>
└── redtamarin-0.4<br>
<br>
#or if you will create a new folder each time<br>
<br>
bin-deploy/<br>
└── redtamarin-0.4-1R086<br>
└── redtamarin-0.4-1R087<br>
└── redtamarin-0.4-1R088<br>
└── redtamarin-0.4-1R089<br>
└── etc.<br>
<br>
</code></pre>

<b>build.bundleSDK</b> = <code>true/false</code><br>
to bundle only the SDK files without trying to compile them first.<br>
<pre><code># compiling all the exe on a particular system can take 30mn or so<br>
# and if you have already created the binaries you just want to bundle them<br>
# without spending yet another 30mn recompiling them<br>
<br>
#with this option enabled<br>
<br>
#the SDK will take the files from<br>
<br>
bin-release/<br>
├── components<br>
├── darwin<br>
├── documentation<br>
├── linux<br>
└── windows<br>
<br>
#and bundle them into<br>
<br>
bin-deploy/<br>
└── redtamarin-0.4<br>
<br>
#which take about 2sec ;)<br>
</code></pre>

<b>build.tagSDK</b> = <code>true/false</code><br>
to add the build tag to the SDK name<br>
<pre><code># the difference between obtaining<br>
<br>
bin-deploy/<br>
└── redtamarin-0.4<br>
<br>
#or<br>
<br>
bin-deploy/<br>
└── redtamarin-0.4-1R086<br>
</code></pre>

<b>build.mergeRuntimesInSDK</b> = <code>true/false</code><br>
to merge different precompiled redshell exe into the files fo the SDK<br>
<pre><code>#you have mainly 3 cases<br>
<br>
#either you are compiling the binaries on the current OS AND building the SDK<br>
<br>
for ex, under OSX you will generate files in<br>
bin-release/<br>
└── darwin<br>
<br>
and reuse<br>
<br>
bin-release/<br>
├── linux<br>
└── windows<br>
<br>
#or you already got all your binaries and just want to bundle the SDK<br>
<br>
with any OS you will reuse the generated files from<br>
<br>
bin-release/<br>
├── darwin<br>
├── linux<br>
└── windows<br>
<br>
ok, there is a 3rd case where you would want to generate an SDK for only 1 OS<br>
but we don't want to do that, we don't want different SDK for different OS<br>
we want ONE SDK for ANY/ALL OS we support<br>
</code></pre>



<h3>Tamarin</h3>

If you want to build it "old school" without our ant build<br>
the Tamarin build is based on python scripts and make files<br>
<br>
you need to understand <b>configure.py</b>
<pre><code>$ configure.py --help<br>
--enable-abc-interp                 [=not enabled]<br>
--enable-allocation-sampler         [=not enabled]<br>
--enable-aot                        [=not enabled]<br>
--enable-arm-fpu                    [=not enabled]<br>
--enable-arm-hard-float             [=not enabled]<br>
--enable-arm-neon                   [=not enabled]<br>
--enable-arm-thumb                  [=not enabled]<br>
--enable-buffer-guard               [=not enabled]<br>
--enable-cache-gqcn                 [=not enabled]<br>
--enable-compilepolicy              [=not enabled]<br>
--enable-cpp -exceptions             [=not enabled]<br>
--enable-debug                      [=not enabled]<br>
--enable-debugger                   [=not enabled]<br>
--enable-debugger-stub              [=not enabled]<br>
--enable-epoc-emulator              [=not enabled]<br>
--enable-eval                       [=not enabled]<br>
--enable-exact-tracing              [=not enabled]<br>
--enable-float                      [=not enabled]<br>
--enable-halfmoon                   [=not enabled]<br>
--enable-heap-alloca                [=not enabled]<br>
--enable-heap-graph                 [=not enabled]<br>
--enable-interior-pointers          [=not enabled]<br>
--enable-interrupt-safepoint-poll   [=not enabled]<br>
--enable-jit                        [=not enabled]<br>
--enable-lzma-lib                   [=not enabled]<br>
--enable-memory-profiler            [=not enabled]<br>
--enable-methodenv-impl32           [=enabled]<br>
--enable-mmgc-interior-pointers     [=not enabled]<br>
--enable-mmgc-shared                [=not enabled]<br>
--enable-optimize                   [=not enabled]<br>
--enable-osr                        [=not enabled]<br>
--enable-override-global-new        [=not enabled]<br>
--enable-perfm                      [=not enabled]<br>
--enable-protect-jitmem             [=not enabled]<br>
--enable-safepoints                 [=not enabled]<br>
--enable-selectable-exact-tracing   [=not enabled]<br>
--enable-selftest                   [=not enabled]<br>
--enable-shared-gcheap              [=not enabled]<br>
--enable-shark                      [=not enabled]<br>
--enable-shell                      [=enabled]<br>
--enable-sin-cos-nonfinite          [=not enabled]<br>
--enable-swf12                      [=not enabled]<br>
--enable-swf13                      [=not enabled]<br>
--enable-swf14                      [=not enabled]<br>
--enable-swf15                      [=not enabled]<br>
--enable-swf16                      [=not enabled]<br>
--enable-swf17                      [=not enabled]<br>
--enable-swf18                      [=not enabled]<br>
--enable-swf19                      [=not enabled]<br>
--enable-swf20                      [=not enabled]<br>
--enable-sys-root-dir               [=not enabled]<br>
--enable-tamarin                    [=enabled]<br>
--enable-telemetry                  [=not enabled]<br>
--enable-telemetry-sampler          [=not enabled]<br>
--enable-threaded-interp            [=not enabled]<br>
--enable-use-system-malloc          [=not enabled]<br>
--enable-valgrind                   [=not enabled]<br>
--enable-vtune                      [=not enabled]<br>
--enable-wordcode-interp            [=not enabled]<br>
--enable-zlib-include-dir           [=not enabled]<br>
--enable-zlib-lib                   [=not enabled]<br>
--target=...                        [=None]<br>
--host=...                          [=None]<br>
--ignore_unknown_flags=...          [=False]<br>
--mac_sdk=...                       [=None]<br>
--mac_xcode=...                     [=None]<br>
--arm_arch=...                      [=armv7-a]<br>
</code></pre>

here few examples<br>
<pre><code>#create an objdir folder<br>
$ cd src<br>
$ mkdir _build<br>
$ cd _build<br>
<br>
#then configure<br>
<br>
#conf for a 32bit macintosh<br>
$ ../configure.py --target=i386-darwin<br>
<br>
#conf for a 32bit macintosh using the OSX 10.7 SDK<br>
$ ../configure.py --mac-sdk=107 --target=i386-darwin<br>
<br>
#conf for a 64bit macintosh<br>
$ ../configure.py --target=x86_64-darwin<br>
<br>
#conf for a 32bit macintosh with debug and debugger<br>
$ ../configure.py --target=i386-darwin --enable-debug --enable-debugger<br>
<br>
#conf for a 32bit windows<br>
$ ../configure.py --target=i386-windows<br>
<br>
#conf for a 64bit windows<br>
$ ../configure.py --target=x86_64-windows<br>
<br>
#etc...<br>
<br>
#then make it so<br>
$ make<br>
</code></pre>

if you want to modify the native classes in C++ and AS3<br>
you will need to use a compiled avmshell executable<br>
and declare it in your environment variables<br>
<br>
for ex under OS X<br>
<pre><code>$ pico ~/.profile<br>
<br>
#and add<br>
export AVMSHELL_TOOL="/path/to/avmshell"<br>
</code></pre>

you can not compile an original avmshell from redtamarin<br>
but you can find pre-compiled avmshells here<br>
<pre><code>build<br>
├── ant<br>
│   └── ...<br>
├── common.properties<br>
├── shell<br>
│   ├── darwin<br>
│   │   └── avmshell<br>
│   ├── linux<br>
│   │   └── avmshell<br>
│   └── windows<br>
│        └── avmshell.exe<br>
├── targets<br>
│   └── ...<br>
├── tasks<br>
│   └── ...<br>
└── version.properties<br>
</code></pre>