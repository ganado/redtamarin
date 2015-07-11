## Introduction ##

The goal is to provide a compatible API with the Flash Player and AIR runtime,
so you can literally copy/paste code to compile for redtamarin.


## Implementation ##

The Flash Platform API, or FPAPI for short, is implemented under the **avmglue** project.

You can found the [details](http://code.google.com/p/maashaack/wiki/avmglue) here, and the files here [/platform/avmglue](http://code.google.com/p/maashaack/source/browse/#svn/platform/avmglue/trunk/src) (hosted on maashaack)

Reusing the versioning API (in Tamarin and ASC) the goal is to provide a mock implementation of the FPAPI as a first step.

The next steps will depends on other native classes implemented in redtamarin.

For example, let's say we want to have a native implementation of `flash.system.Capabilities`.

default mock implementation
```
package flash.system
{
    public final class Capabilities
    {
    //...

    public static function get language():String
    {
        return "xu"; //other/unknown
    }

    //...
    }
}
```

native implementation
```
package flash.system
{
    import avmplus.Host;

    public final class Capabilities
    {
    //...

    public static function get language():String
    {
        return Host.language;
    }

    //...
    }
}
```

no native implementation will occurs in **Capabilities** itself, we will depends on the AVMPlus API **avmplus.Host** native class (or other classes).

That way, we can compile an **avmglue.abc** which either depends on nothing (pure AS3 mock implementation)
or depends on **shell\_toplevel.abc**, something that is already defined in the tamarin shell.

For you as a developer who want to reuse AS3 classes without rewriting part of the code for redtamarin you can just reuse your code as is
```
import flash.system.Capabilities;

if( Capabilities.language == "en" )
{
    //do stuff
}

```

Alternatively if you don't care about the FPAPI compatibility but still need to know the host language, you will be able to use what's defined in redtamarin

```
import C.stdlib.*;

if( getenv("LANG") == "en" )
{
    //do stuff
}

```
or
```
import avmplus.Host;

if( Host.language == "en" )
{
    //do stuff
}

```


TODO

## Limitation ##

**We will certainly not make a full native implementation of the whole FPAPI and certainly not make an open source flash player.**

We are not interested in display rendering, we want to keep **redshell** as a command-line tool.

So, yes you will be able to compile `class Main extends Sprite` and that will not break your code, but that does not mean we will support to display Sprites.

TODO