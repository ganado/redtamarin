| **important:** this project is under heavy changes, consider this wiki page obsolete |
|:-------------------------------------------------------------------------------------|

## v0.5 ##

  * Socket, SocketServer implementations
  * SharedObject (read/write) implementation
  * LocalConnection implementation

release: (TBD)

tags: n/a

## v0.4 ##

  * first shot at an event system
  * more flash platform APIs implementation
    * try to implement Proxy flash\_proxy
  * full system info
    * "Mac OS X 10.5.1" instead of "Macintosh"


release: (TBD)

tags: n/a


## v0.3 ##

  * sync with last Tamarin (support for swf, eval, etc.)
  * utilities to work with ABC, SWF, SWC, etc.
  * redshell as3 lib as a SWC
  * tools
    * extract ABC from SWF
    * inject ABC into SWF
    * etc.
  * exe tools to replace the build scripts
  * File I/O API
    * low level fopen etc.
    * high level API as AIR
  * executable API
    * more than just system()
    * make different tests with pipe etc.
    * copy what JSDB do with Stream =)
  * more C libs

maybe:
  * replace avmshell.cpp by a redshell.cpp
  * ant automated build
    * reuse command lines test in pythong from Tamarin

release: (TBD)

tags: n/a

## v0.2.5 ##

  * all flash platform APIs (most as mock / empty classes)
  * locale/language detection
  * executable path (`argv[0]`)
  * [ASTUce CLI](http://code.google.com/p/astuce/source/browse/#svn/cli/trunk) is build on redshell 0.2.5

release: 13/01/2009

tags:
[redtamarin 0.2.5](http://redtamarin.googlecode.com/svn/tags/0.2.5) [redshell AS3 0.2.5](http://redtamarin.googlecode.com/svn/as3/redshell/tags/0.2.5)

## v0.2 ##

  * sync with Tamarin 703:2cee46be9ce0
  * cleaner code
  * some flash platform APIs
  * release for Windows, OS X and Linux
  * separate subproject **redshell as3 library**

release: 05/01/2009

tags: [redtamarin 0.2.0](http://redtamarin.googlecode.com/svn/tags/0.2.0) [redshell AS3 0.2.0](http://redtamarin.googlecode.com/svn/as3/redshell/tags/0.2.0)


## v0.1 ##

  * basic C libs stdlib, unistd
  * release for Windows and OS X

release: 28/08/2008

tags: n/a