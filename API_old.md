## Introduction ##

Because Tamarin define very few API, we decided to implement our own API.

Make no mistake, designing an API is a very hard task (maybe the hardest ?) and we'll probably not get it right (ever),
but to be able to offer native functionalities we needed anyway to provide a way for you (the developer) to access these native definitions.

Also, the AS3 language being already quite powerful with just few builtin classes, when you add native system call
you kind of multiply exponentially all the things you can do with the language.

So, instead of trying to target the perfect API, we will target a good enougth API and show you how you can write your own API, but off course if you like our API you can still use it :).

The following will hopefully explain clearly why we did things in a certain way.


## API Layers ##

There are different layers of implementations, from closer to the metal (native implementations) to AS3 wrapper code (around already existing AS3 code).

The code design is based on this idea
<pre>
If you don't like to use flash.net.URLLoader class for whatever reason<br>
we simply give you the tools to wrap your own class to suit your taste.<br>
</pre>

In short, that means we provide you `avmplus::FileSystem.write( filename, data )` and you can define `sys::File` which when initialized `new File( filename )` will write the file directly.


### Layer 0 : Lower Level ###

The Lower Level API, or **AVMAPI**, is a combination of the Builtins classes, the Standard C classes and the AVMPlus classes.

**for ex:** `C.stdlib.*` , `avmplus.FileSystem`, `avmplus.OperatingSystem`, etc.

those classes are
  * always compiled within redtamarin
> you need to -import file.abc to compile your code over the symbols
> but the file.abc is embeded by default in the redtamarin executable.
  * implement most of their functionalities as native
> the class definition is in AS3 but the implementation is in C/C++
  * cross-platform
> if we add a functionality it HAVE TO work on Windows, OS X, Linux, etc.
  * considered as "interfaces"
> if foobar class exists in v0.1, it will always be present in 0.2, 0.3, etc.
> at the very worst we will "add to it" but NEVER "remove from it"


### Layer 1 : Flash Platform ###

The Flash Platform API, or **FPAPI**, is based on the fact that most of our/your usage of the AS3 language is within the Flash Player host or the AIR host.

**for ex:** `flash.display.Sprite`, `flash.system.Capabilities`, `flash.filesystem.File`, etc.

Tamarin by default implement almost NONE of the FPAPI.

With redtamarin we took an hybrid approach
  * we have an AS3 project [avmglue](http://code.google.com/p/maashaack/wiki/avmglue) which define all the classes, packages, etc.
> of the FPAPI as mock objects (or dumb implementations if you prefer).
  * all those FPAPI are implemented with the versioning API
> we make the difference between FP\_9\_0, AIR\_1\_0, FP\_10\_0, AIR\_2\_0, etc.
> (HAVE TO compile with ASC.jar, but can still use asdoc)
  * on a case by case basis, and when we have the required lower level API to do so,
> we add a concrete implementation of the FPAPI in parallel of the mock implementation.
> For that, we use the Conditional Compilations `MOCK::API` and `REDTAMARIN::API`.
  * generates `*.abc` files that need to be included with your project

TODO

### Layer 2 : Any Other ###

Any other API, or for short `*API` (or "Any API"), ...

With enougth lower level API (being able to use sockets, connect to a DB like SQLite, etc.)<br>
we will be able to create "wrapper" for any other API.<br>
<br>
So for example if you like how <a href='http://en.wikipedia.org/wiki/CommonJS'>CommonJS</a> or Python or PHP are doing stuff,<br>
you will be able to reuse their API using an AS3 syntax.<br>
<br>
Here a small example with <a href='http://wiki.commonjs.org/wiki/Filesystem/A/0'>CommonJS Filesystem/A/0</a>
<pre><code>package fs<br>
{<br>
    import avmplus.FileSystem;<br>
    import C.unistd.chmod;<br>
<br>
    public function makeDirectory( path:String, permissions_opt:* ):void<br>
    {<br>
        FileSystem.createDirectory( path );<br>
        if( permissions_opt )<br>
        {<br>
            var permisssions:int = _translatePermissions( permissions_opt );<br>
            chmod( path, permissions );<br>
        }<br>
    }<br>
<br>
    public function workingDirectory():String<br>
    {<br>
        return FileSystem.workingDirectory;<br>
    }<br>
<br>
    public function changeWorkingDirectory( path:String ):void<br>
    {<br>
        FileSystem.workingDirectory = path;<br>
    }<br>
<br>
    public function exists( path:String ):Boolean<br>
    {<br>
        return FileSystem.exists( path );<br>
    }<br>
<br>
    public function isFile( path:String ):Boolean<br>
    {<br>
        return FileSystem.isRegularFile( path );<br>
    }<br>
}<br>
</code></pre>






TODO