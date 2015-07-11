Everything you need to know on how to use redtamarin<br>
aka "I don't want to compile C/C++/Java, I just want to write AS code dammit".<br>
<br>
<h3>First Thing First</h3>

The project is named <b>redtamarin</b>, but you end up using an executable named <b>redshell</b>.<br>
<br>
So what is this "shell" thingy ?<br>
<br>
The same you can have the Flash Player as a plugin on the browser (or the standalone flash projector) that can take a <code>*.swf</code> file and play it, you have the <code>redshell</code> that can take either a <code>*.swf</code> or <code>*.abc</code> files and execute them.<br>
<br>
WHAT ? redshell can play <code>*.swf</code> files ?<br>
<br>
yes, but don't get too excited, redshell can play only the <code>*.abc</code> parts inside the <code>*.swf</code>.<br>
<br>
See it like that, either you want to execute only one <code>*.abc</code>, and so you pass it directly to redshell,<br>
or you want to execute numerous <code>*.abc</code> one after another, and then you pass a <code>*.swf</code> file that act as a container for those different <code>*.abc</code> files.<br>
<br>
Also you can run <code>*.as</code> files with redshell, but here again there are some limitations.<br>
<br>
Assuming you are an AS3 developer, here the workflow you get with redtamarin<br>
<ul><li>you compile your <code>*.as</code> files using the redtamarin API (or not) into one or more <code>*.abc</code> file(s)<br>
</li><li>compile, test, unit test, etc. ...  rinse and repeat<br>
</li><li>once you are happy with it, you can distribute<br>
<ul><li>an abc file that can be used as a library (like a swc if you prefer)<br>
</li><li>redshell + your abc file<br>
</li><li>redshell + your swf file (containing different abc files)<br>
</li><li>your file exe (redshell embedding the abc file)<br>
</li><li>your file exe (redshell embedding a swf file that contains different abc files)<br>
<b>you can generate different executable (for Windows, OS X, Linux, etc.)</li></ul></li></ul></b>

Ultimately, your goal is to produce a command-line executable that you code in AS3.<br>
<br>
<h3>etc.</h3>


<h3>Who 's talking about it ?</h3>

One strange thing with redtamarin is that I didn't promoted it much and still it reached 600+ downloads.<br>
<br>
I talk a little bit about it on twitter (you can follow me if you want <a href='http://twitter.com/#!/zwetan'>@zwetan</a>).<br>
<br>
Here some different articles and blog post mentioning redtamarin:<br>
<br>
<ul><li><a href='http://stackoverflow.com/questions/1056056/is-it-possible-to-create-a-command-line-swf'>Is it possible to create a 'command line' swf?</a> (stackoverflow)<br>
</li><li><a href='http://stackoverflow.com/questions/717329/server-side-action-script-3-0'>Server side Action Script 3.0</a> (stackoverflow)<br>
</li><li><a href='http://memmie.lenglet.name/flash/actionscript/font-streaming'>Font streaming</a>
</li><li><a href='http://labs.influxis.com/?p=598'>Project Variant and a question to the community.</a>
</li><li><a href='http://blog.48bits.com/2010/02/15/debuggeando-codigo-jiteado-de-actionscript/'>Debuggeando código JITeado de ActionScript</a> (Debugging ActionScript JITed code)<br>
</li><li><a href='http://www.la-digitale.com/index/redtamarin'>Cibler Redtamarin avec Flashdevelop</a> (fr)<br>
</li><li><a href='http://blog.eversonalves.com.br/2011/02/05/command-line-scripts-in-actionscript-with-classes-using-redtamarin/'>Command line scripts in actionscript with classes using redtamarin</a>
</li><li><a href='http://blog.bk-zen.com/2011/03/28/453/'>Redtamarin やろうぜ！(東京てら子14資料)</a>
</li><li><a href='http://www.flasher.ru/forum/blog.php?b=423'>redtamarin Что это за зверь?</a>
</li><li><a href='http://www.bobsgear.com/display/ts/Introduction+To+Programming+-+Writing+Hammurabi+In+Actionscript+With+Redtamarin'>Introduction To Programming - Writing Hammurabi In Actionscript With Redtamarin</a></li></ul>

Note that I'm always very interested to read or know about user stories or usage of redtamarin os if you have some not listed here you can send me an email (my username (at) gmail (dot) com).