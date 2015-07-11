Will work with redtamarin v0.3.0+

## Download the shell ##

download one of the zip for your system (see [downloads](http://code.google.com/p/redtamarin/downloads/list) tab)

```
redtamarin_{version}_OSX.zip
or
redtamarin_{version}_NIX.zip
or
redtamarin_{version}_WIN.zip
```

unzip it, and you should get
```
..
 |_ redtamarin_0.3.0.940_OSX  <- for OS X
      |_ asc.jar
      |_ builtin.abc
      |_ changelog.txt
      |_ license.txt
      |_ readme.txt
      |_ redshell                          <- release version
      |_ redshell_d                        <- debugger version
      |_ toplevel.abc

```

## Download the component ##

download the zip (see [downloads](http://code.google.com/p/redtamarin/downloads/list) tab)
```
redtamarin_{version}_SWC.zip
```

In Flex Builder, copy `redtamarin.swc` somewhere (for ex: `/lib-swc/redtamarin.swc`, `/lib/redtamarin.swc`, etc.)

then in the project properties add the SWC in the library path,<br>
and voila you should get syntax completion.<br>
<br>
<h2>Build the tools</h2>

Now checkout the redtamarin-tools<br>
<pre><code>$ svn co http://redtamarin.googlecode.com/svn/tools/trunk redtamarin-tools<br>
</code></pre>

you will obtain this structure<br>
<pre><code>redtamarin-tools<br>
  |_ build<br>
  |    |_ ant<br>
  |    |_ red<br>
  |        |_ nix<br>
  |        |_ osx<br>
  |        |_ win<br>
  |<br>
  |_ src<br>
      |_ ...<br>
<br>
</code></pre>

extract the zip content to the respective directory<br>
<br>
<ul><li>for redtamarin_0.3.0.940_WIN.zip extract it to <b>/build/red/win/</b>
</li><li>for redtamarin_0.3.0.940_NIX.zip extract it to <b>/build/red/nix/</b>
</li><li>for redtamarin_0.3.0.940_OSX.zip extract it to <b>/build/red/osx/</b></li></ul>

Go to the root of the project and run the ant build<br>
<pre><code>$ ./ant<br>
</code></pre>

this should generate all the tools and dependencies in the /bin directory<br>
<pre><code>..<br>
 |_ bin<br>
     |_ abcdump               &lt;- Displays the contents of abc or swf files<br>
     |_ asc                   &lt;- Executable wrapper for asc.jar<br>
     |_ asc.ajr<br>
     |_ builtin.abc<br>
     |_ createprojector       &lt;- Utility to create a projector<br>
     |_ EclipseExternalTools  &lt;- Utility to create Eclipse External Tools for redtmarin<br>
     |_ redshell              &lt;- redshell release<br>
     |_ redshell_d            &lt;- redshell debug<br>
     |_ swfmake               &lt;- Utility to stitch ABC files together into a single swf<br>
     |_ toplevel.abc<br>
     <br>
</code></pre>


In an already existing or new Flex Builder workspace, run EclipseExternalTools<br>
<pre><code>$ ./EclipseExternalTools /path/to/the/workspace<br>
</code></pre>
restart Flex Builder.<br>
<br>
Copy the <code>/bin</code> directory to your project, created in this workspace.<br>
<br>
Create a new ActionScript project in Flex Builder 3 or Flash Builder 4, and you're good to go.<br>
<br>
<br>
Now, for more details and shiny screenshots you can follow <a href='GettingStartedInShinyColor.md'>Getting Started in Shiny Color</a>.