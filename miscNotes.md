# Introduction #

Tamarin is big, and while delving into it, trying to understand how things are connected together, I'll take some notes that might be helpfull for others (but mainly I write down all this for me :p).

## where to start ##

start with [avmplus.h](http://redtamarin.googlecode.com/svn/trunk/mozilla/js/tamarin/core/avmplus.h)
```
The avmplus::AvmCore class is the main entry point of the
AVM+ virtual machine, and is probably a good place to start
when trying to comprehend the codebase.
```

## as types in c++ ##

[AvmCore.h](http://redtamarin.googlecode.com/svn/trunk/mozilla/js/tamarin/core/AvmCore.h) define
  * OBJECT\_TYPE
  * CLASS\_TYPE
  * FUNCTION\_TYPE
  * ARRAY\_TYPE
  * STRING\_TYPE
  * NUMBER\_TYPE
  * INT\_TYPE
  * UINT\_TYPE
  * BOOLEAN\_TYPE
  * VOID\_TYPE
  * NULL\_TYPE
  * NAMESPACE\_TYPE

in many cases you want to pass an object without knowing its type
```
public native function test( obj:* ):String
```

but in the cpp you will need to test its type to avoid crash of the vm
```
Stringp TestClass::test(Atom obj)
{
    AvmCore* core = this->core();
    if( core->istype( obj, CLASS_TYPE ) )
    {
    ...
    }

}
```

## types correspondance ##

in [NativeFunction.h](http://redtamarin.googlecode.com/svn/trunk/mozilla/js/tamarin/core/NativeFunction.h) you can see this info


| AS type   | C++ type |
|:----------|:---------|
| Void      | Atom, if parameter, void if return type |
| Object    | Atom     |
| Boolean   | bool     |
| Number    | double   |
| String    | Stringp (String `*`) |
| Class     | ClassClosure`*` |
| MovieClip | MovieClipObject`*` (similar for any other class) |

## the special cases of Atom ##

An `Atom` is not just the `[object Object]`, see [AtomConstants.h](http://redtamarin.googlecode.com/svn/trunk/mozilla/js/tamarin/core/AtomConstants.h) for a full detail
```
The atom is a primitive value in ActionScript.  Since
ActionScript is a dynamically typed language, an atom can
belong to one of several types: null, undefined, number,
integer, string, boolean, object reference.
```

it's cool because you can do whicked dynamic stuff with it but it can be hard to debug in cpp where it's not dynamic.

## defining native errors ##

even if you define your error as a non-native class
```
    public dynamic class IOError extends Error
    {
        public function IOError( message:String = "" )
        {
            super( message );
        }
    }
```

if you want to be able to throw the error from C/C++
you need to define the error like that (in avmshell)
```
NATIVE_CLASS(abcclass_flash_errors_IOError, NativeErrorClass,   ErrorObject)
```