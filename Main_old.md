Welcome to the **redtamarin** project.

[list all the wiki pages](http://code.google.com/p/redtamarin/w/list)

Simply put, redtamarin is based on the [Tamarin](http://www.mozilla.org/projects/tamarin/) project
(eg. the Flash Player Virtual Machine) and allow to run AS3 code on the command-line.

But because Tamarin only support the AS3 builtins (Object, Array, etc.),
redtamarin add numerous native functionalities, so you can test if your program
run under Windows or Linux, or read/write files, or send data with sockets, etc.

Put another way, if Adobe AIR allow you to build desktop executable with a GUI,
redtamarin allow you to build desktop/server executable with a CLI.

### Mission Statement ###

**To support the use of the AS3 language for cross-platform command-line executable,
as single exe either for the desktop or the server, as scripts for automation,
as tools for the Flash Platform community.**



### Status ###

  * this project started because I'm a fan of [JSDB](http://www.jsdb.org) but I prefer to write my code in AS3
  * then I thought why not make something like AIR but for the command-line
  * I started a bit shy in my corner without promoting the project at all, but it appears 600+ people downloaded it
  * getting somewhat better at C/C++ and having a huge needs for command-line tools in AS3 I started to rethink the project
  * I'm now completely dedicated (if not obsessed) to implement a lot of functionalities
  * there has been a drop of activity between october and december 2010 (new job)

### Goals ###

  * the short goal of the project is to provide most of the C standard library (ANSI and POSIX) to an ActionScript environment. - **DONE**
  * the medium goal is to provide specialized libraries to use sockets or database like SQLite etc.
    * FileSystem API **DONE** (adding even more)
    * OperatingSystem API **DONE**
    * basic socket (stream, datagram, broadcast, client, server) **DONE**
    * (more to come)
  * the long term goal is to provide a native API that replicate some part of the Flash Player and Adobe Integrated Runtime ([AIR](http://www.adobe.com/products/air/)) API
  * I'm bad a documenting, so I'll try this time to document on the go and provide example for all the APIs
  * some people contact me by email, when I can, I add features related to their needs

### Sync ###

here the list of sync from the http://code.google.com/p/redshell project, which is a mirror of tamarin-redux
  * **25/07/2010** tamarin-redux-e07844ed9e
  * **26/12/2010** tamarin-redux-d8b78be5b40f
  * **26/12/2011** tamarin-redux-6fee29500342



### History ###

At first I was using a mixed system to update from Mercurial and then sync to a local subversion repository and then sync to the google code project, then later I was using another mixed system that was mixing directories from both the Tamarin mercurial repo and this project SVN repo, both were not practical, hard to update.

Also, messing a little too much with the Tamarin source code, I ended up having dirty C/C++ code.

Since the Tamarin release **703:2cee46be9ce0** ([02/12/2008](https://developer.mozilla.org/En/Tamarin/Tamarin_Releases)), I decided to make it cleaner.

Now from redtamarin v0.2, the source code of Tamarin is fully sync'ed in this project repository, and as the C/C++ is better organized, update etc. should stay clean in the  futur :). **<-- this has failed big time**

As of **25/07/2010** redtamarin have taken a completely different approach
  * now we use the [redshell](http://code.google.com/p/redshell/) project to stay in sync' with [tamarin-redux](http://hg.mozilla.org/tamarin-redux) (sync is done ~~every week~~ more often :p)
  * from redshell, we do an `hg archive` and overwrite the `/tamarin-redux` directory, see [this change](http://code.google.com/p/redtamarin/source/detail?r=252) for example.
  * etc. (TODO explain the other changes)

The code is currently tested and compiled on those systems:
  * Mac OS X 10.6.2
  * Windows XP SP3
  * Linux Ubuntu 8.04.3 Desktop
  * more to come (especially 64bit versions)

**contributors welcome!**, even if it just compiling on your system :)<br>
send an email <code>[my username] @ gmail (dot) com</code>