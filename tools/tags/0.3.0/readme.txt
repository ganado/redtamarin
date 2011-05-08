--------------------------------------------------------------------------------
redtamarin-tools
================

A set of tools to use with redtamarin


How to Build
-----
Grab the redtamarin runtime file for your system
  * redtamarin_0.3.0.940_WIN.zip
  * redtamarin_0.3.0.940_NIX.zip
  * redtamarin_0.3.0.940_OSX.zip

extract the zip content to the respective directory

  * for redtamarin_0.3.0.940_WIN.zip
    extract it to /build/red/win/

  * for redtamarin_0.3.0.940_NIX.zip
    extract it to /build/red/nix/

  * for redtamarin_0.3.0.940_OSX.zip
    extract it to /build/red/osx/

Go to the root of the project and run the ant build
$ ./ant

this should generate all the tools and dependencies in the /bin directory

--------
..
 |_ bin
     |_ abcdump               <- Displays the contents of abc or swf files
     |_ asc                   <- Executable wrapper for asc.jar
     |_ asc.ajr
     |_ builtin.abc
     |_ createprojector       <- Utility to create a projector
     |_ EclipseExternalTools  <- Utility to create Eclipse External Tools for redtmarin
     |_ redshell              <- redshell release
     |_ redshell_d            <- redshell debug
     |_ swfmake               <- Utility to stitch ABC files together into a single swf
     |_ toplevel.abc
     
--------


Usage
-----

Copy the /bin directory to your project

Create a new Eclipse or Flex Builder workspace, then run EclipseExternalTools
$ ./EclipseExternalTools /path/to/the/workspace
restart Flex Builder

Create a new ActionScript project in Flex Builder
add the /bin directory containing all the tools


Documentation
-------------

see
http://code.google.com/p/redtamarin/wiki/GettingStarted

or even better see
http://code.google.com/p/redtamarin/wiki/GettingStartedInShinyColor


--------------------------------------------------------------------------------
