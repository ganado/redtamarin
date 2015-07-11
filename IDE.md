| **important:** this project is under heavy changes, consider this wiki page obsolete |
|:-------------------------------------------------------------------------------------|

### Introduction ###

Yes you can code completion for your command-line projects :).

### using gedit ###

[download gedit](http://projects.gnome.org/gedit/)

With **gedit** you can add [AS3 syntax highlighting](http://live.gnome.org/Gedit/HighlighterAndBundles) and [word completion](http://live.gnome.org/GeditPlugins)<br>
ok, it's not completely ideal but it can get you going.<br>
<br>
<h3>Other IDE</h3>

Basically any text editor supporting AS3 syntax highlighting should be enougth, here a small list<br>
<ul><li><a href='http://www.flos-freeware.ch/notepad2.html'>Notepad 2</a> (Windows only)<br>
</li><li><a href='http://www.activestate.com/komodo-edit'>Komodo Edit</a> (Windows/OSX/Linux)<br>
</li><li><a href='http://smultron.sourceforge.net/'>Smultron</a> (OSX only)<br>
</li><li>etc.</li></ul>

Here a special mention for <a href='http://code.google.com/p/minibuilder/'>minibuilder</a>,<br>
an open source project which intend to support Tamarin AVM project (see <a href='http://code.google.com/p/minibuilder/wiki/AVMProject'>here</a> and <a href='http://code.google.com/p/minibuilder/wiki/AVM2ProjectStater'>here</a>).<br>
<br>
Yes I can admit, editing AS3 code for a custom AVM like redtmarin is a pain,<br>
most of the IDE out there think that by default you will use <code>playerglobal.swc</code><br>
and that is exactly what we are not using :p.<br>
<br>
<br>
<br>
<h3>using Flex Builder 3</h3>

<b>You only need to do this for the old version of redtamarin 0.2.5</b>

first create a workspace dedicated to this kind of project<br>
<br>
<pre><code>File/Switch Workspace/Other...<br>
</code></pre>

Under OS X I create a "Tamarin" workspace<br>
<pre><code>/code/Tamarin<br>
</code></pre>

Before creating any project you need to edit<br>
a config file, in the terminal go to your workspace directory<br>
<br>
<pre><code>$ cd /code/Tamarin<br>
</code></pre>

then go in this directory<br>
<pre><code>$ pwd<br>
/code/Tamarin<br>
$ cd .metadata/.plugins/com.adobe.flexbuilder.codemodel/extraClassPath/<br>
</code></pre>

here you will see a <code>Global.as</code> file<br>
<br>
you need to overwrite it<br>
<pre><code>$ rm Global.as<br>
$ touch Global.as<br>
</code></pre>

now in Flex Builder 3 create an ActionScript project<br>
<br>
you get this structure<br>
<pre><code>[projectname]<br>
   |_ bin-debug<br>
   |_ html-template<br>
   |_ src<br>
</code></pre>

from the Downloads tab use the most recent red zip<br>
(for ex: red_v0.1.0.102.zip) and unzip in your project<br>
to obtain that structure<br>
<br>
<pre><code>[projectname]<br>
   |_ bin<br>
       |_ asc.jar<br>
       |_ builtin.abc<br>
       |_ redshell<br>
       |_ redhsell.exe<br>
       |_ toplevel.abc<br>
   |_ bin-debug<br>
   |_ html-template<br>
   |_ src<br>
   |_ buildAndRun.bat<br>
   |_ buildAndRun.sh<br>
   |_ buildEXE.bat<br>
   |_ buildEXE.sh<br>
</code></pre>

now add the redshell AS3 library<br>
<br>
in your project create a <code>libs</code> directory<br>
<br>
and import the library from svn<br>
<br>
<pre><code>$ cd /code/Tamarin/[projectname]/libs<br>
$ svn co http://redtamarin.googlecode.com/svn/as3/redshell/trunk/src/ redshell<br>
</code></pre>

now your project structure should look like this<br>
<br>
<pre><code>[projectname]<br>
   |_ bin<br>
       |_ asc.jar<br>
       |_ builtin.abc<br>
       |_ redshell<br>
       |_ redhsell.exe<br>
       |_ toplevel.abc<br>
   |_ bin-debug<br>
   |_ html-template<br>
   |_ libs<br>
       |_ redshell<br>
            |_ actionscript.lang.as<br>
            |_ Array.as<br>
            |_ etc.<br>
   |_ src<br>
   |_ buildAndRun.bat<br>
   |_ buildAndRun.sh<br>
   |_ buildEXE.bat<br>
   |_ buildEXE.sh<br>
</code></pre>

now you need to configure your project<br>
<br>
go into the project properties<br>
<br>
in  <code>ActionScript build path</code>

on the tab <code>source path</code> add <code>libs/redshell</code>

on the tab <code>library path</code> remove any Flex SDK SWC<br>
<br>
in <code>Builders</code>

deselect the default <code>Flex</code>

and create your own builder, for ex <code>[projectname]_build</code>

for the <code>Location</code> use <code>${workspace_loc:/[projectname]/buildAndRun.sh}</code>

for the <code>Working directory</code> use <code>${workspace_loc:/[projectname]}</code>

for the <code>Arguments</code> use <code>${resource_loc}</code>

save<br>
<br>
create a basic <code>main.as</code> in the <code>src</code> folder<br>
<br>
for ex:<br>
<pre><code>import C.unistd.getcwd;<br>
<br>
trace( getcwd() );<br>
</code></pre>

now in Flex Builder, select the <code>main.as</code> tab<br>
and build the project<br>
<br>
in the console you should obtain<br>
<pre><code>main.abc, 138 bytes written<br>
/code/Tamarin/cwd_test<br>
</code></pre>

in this case I named my project <code>cwd_test</code>