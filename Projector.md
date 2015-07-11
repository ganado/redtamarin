### Introduction ###

A projector is a command-line executable that embed an `*.abc` file with the avmshell (or redshell in our case).

This the **MOST IMPORTANT** feature for redtamarin as it allows to create a single executable and so distribute easily your programs.

With Flash a projector has the following workflow:
  * you create a `*.swf` file
  * you open this `*.swf` with the Standalone Flash Player
  * from the menu `File/Create Projector ...`
  * save

this basically merge the Flash Player `*.exe` and the `*.swf` into one executable.

With Tamarin it is basically the same thing but with some subtle differences.

You can only generate a projector with [ASC](ASC.md)

for example
```
$ java -jar asc.jar -AS3 -import builtin.abc -import shell_toplevel.abc -exe redshell testcli.as
```

the `-exe` option
```
-exe <avmplus path> = emit an EXE file (projector)
```

this will create a `testcli.abc` and a `testcli.exe`

the `testcli.exe` merge the `redshell` executable and the `testcli.abc`

This is cool and all but we end up with some issues
  * ASC can not generate a projector from a `*.swf` file
  * the default `avmshell` is more a tool to test the AVM<br>and focus less on executing projectors<br>even if there are plenty of support funtions to do that</li></ul>

### Details ###

What would happen if Adobe decided to remove projector support ?<br>
Then we could run only <code>*.abc</code> files via the shell and that would suck money balls.<br>
<br>
So, to avoid that, let's learn how all this is working :).<br>
<br>
In the ASC source code<br>
<a href='http://opensource.adobe.com/svn/opensource/flex/sdk/trunk/modules/asc/src/java/macromedia/asc/embedding/Compiler.java'>/src/macromedia/asc/embedding/Compiler.java</a><br>
you have a <code>createProjector()</code> function<br>
<pre><code>    static void createProjector(String avmplus_exe, String pathspec, String scriptname, ByteList bytes)<br>
    {<br>
    	BufferedInputStream exe_in = null;<br>
    	BufferedOutputStream exe_out = null;<br>
    	int bytesWritten = 0;<br>
    	<br>
    	try<br>
    	{<br>
    		exe_in = new BufferedInputStream(new FileInputStream(new File(avmplus_exe)));<br>
    		<br>
    		int abc_length = bytes.size();<br>
    		<br>
    		int avmplus_exe_length = exe_in.available();<br>
    		byte avmplus_exe_bytes[] = new byte[avmplus_exe_length];<br>
    		exe_in.read(avmplus_exe_bytes);<br>
    		    		<br>
    		exe_out = new BufferedOutputStream(new FileOutputStream(new File(pathspec, scriptname + ".exe")));<br>
    		<br>
    		exe_out.write(avmplus_exe_bytes);<br>
    		bytesWritten += avmplus_exe_bytes.length;<br>
    		<br>
    		exe_out.write(bytes.toByteArray());<br>
    		bytesWritten += abc_length;<br>
<br>
    		byte header[] = new byte[8];<br>
    		header[0] = 0x56;<br>
    		header[1] = 0x34;<br>
    		header[2] = 0x12;<br>
    		header[3] = (byte) 0xFA;<br>
    		header[4] = (byte) (abc_length &amp; 0xFF);<br>
    		header[5] = (byte) ((abc_length&gt;&gt;8) &amp; 0xFF);<br>
    		header[6] = (byte) ((abc_length&gt;&gt;16) &amp; 0xFF);<br>
    		header[7] = (byte) ((abc_length&gt;&gt;24) &amp; 0xFF);<br>
    		exe_out.write(header);<br>
    		<br>
    		bytesWritten += 8;<br>
    		<br>
    		exe_out.flush();<br>
    	}<br>
		catch (IOException ex)<br>
		{<br>
			ex.printStackTrace();<br>
		}<br>
		finally<br>
		{<br>
			if (exe_in != null)<br>
			{<br>
				try<br>
				{<br>
					exe_in.close();<br>
				}<br>
				catch (IOException ex)<br>
				{<br>
				}<br>
			}<br>
			if (exe_out != null)<br>
			{<br>
				try<br>
				{<br>
					exe_out.close();<br>
				}<br>
				catch (IOException ex)<br>
				{<br>
				}<br>
			}<br>
		}<br>
	<br>
		System.err.println(scriptname + ".exe, " + bytesWritten + " bytes written");<br>
	}<br>
</code></pre>

in the Tamarin source code<br>
<a href='http://code.google.com/p/redtamarin/source/browse/tamarin-redux/shell/ShellCore.cpp?r=710'>/tamarin-redux/shell/ShellCore.cpp</a><br>
you have <code>executeProjector()</code>, <code>isValidProjectorFile()</code>
<pre><code>    // Run a known projector file<br>
    int ShellCore::executeProjector(char *executablePath)<br>
    {<br>
        AvmAssert(isValidProjectorFile(executablePath));<br>
<br>
        uint8_t header[8];<br>
<br>
        FileInputStream file(executablePath);<br>
<br>
        file.seek(file.length() - 8);<br>
        file.read(header, 8);<br>
<br>
        int abcLength = (header[4]     |<br>
                         header[5]&lt;&lt;8  |<br>
                         header[6]&lt;&lt;16 |<br>
                         header[7]&lt;&lt;24);<br>
<br>
        ScriptBuffer code = newScriptBuffer(abcLength);<br>
        file.seek(file.length() - 8 - abcLength);<br>
        file.read(code.getBuffer(), abcLength);<br>
<br>
        return handleArbitraryExecutableContent(code, executablePath);<br>
    }<br>
<br>
    /* static */<br>
    bool ShellCore::isValidProjectorFile(const char* filename)<br>
    {<br>
        FileInputStream file(filename);<br>
        uint8_t header[8];<br>
<br>
        if (!file.valid())<br>
            return false;<br>
<br>
        file.seek(file.length() - 8);<br>
        file.read(header, 8);<br>
<br>
        // Check the magic number<br>
        if (header[0] != 0x56 || header[1] != 0x34 || header[2] != 0x12 || header[3] != 0xFA)<br>
            return false;<br>
<br>
        return true;<br>
    }<br>
</code></pre>

here the structure of a projector<br>
<pre><code>    | executable bytes | abc bytes | projector header 8 bytes |<br>
</code></pre>

the important part is the projector header<br>
<pre><code>    | projector header |<br>
       |_ magic number = 0x56 0x34 0x12 0xFA<br>
       |_ abc packed length = LEN | LEN&lt;&lt;8 |  LEN&lt;&lt;16 | LEN&lt;&lt;24<br>
</code></pre>

how do we know if we are a projector ?<br>
<ul><li>read the last 8 bytes<br>
</li><li>the first 4 bytes is the magic number <code>0x56 0x34 0x12 0xFA</code>
</li><li>the following 4 bytes is the abc file length</li></ul>

how do we extract an abc file from a projector ?<br>
<ul><li>read the last 8 bytes<br>
</li><li>the first 4 bytes is the magic number <code>0x56 0x34 0x12 0xFA</code>
</li><li>the following 4 bytes is the abc file length<br>
</li><li>from the end of the executable minus 8 bytes, read the abc file length</li></ul>

and there is more :)<br>
<ul><li>it is the same principle and signature for a Flash projector<br>(yes you can easily extract a <code>*.swf</code> from a projector)<br>
</li><li>you are not limited to embed <code>*.abc</code>, you can also embed a <code>*.swf</code> file<br>Tamarin will extract the <code>*.swf</code> file the same way it extracts an <code>*.abc</code> file<br>and then will parse the <code>*.swf</code> file to extract all the contained <code>*.abc</code> files</li></ul>

<code>ShellCore.cpp</code> does support <code>*.abc</code> files AND <code>*.swf</code> files<br>
<pre><code>    int ShellCore::handleArbitraryExecutableContent(ScriptBuffer&amp; code, const char * filename)<br>
    {<br>
        setStackLimit();<br>
<br>
        TRY(this, kCatchAction_ReportAsError)<br>
        {<br>
            if (AbcParser::canParse(code) == 0) {<br>
                #ifdef VMCFG_VERIFYALL<br>
                if (config.verbose_vb &amp; VB_verify)<br>
                    console &lt;&lt; "ABC " &lt;&lt; filename &lt;&lt; "\n";<br>
                #endif<br>
<br>
                uint32_t api = this-&gt;getAPI(NULL);<br>
                handleActionBlock(code, 0, shell_toplevel, NULL, user_codeContext, api);<br>
            }<br>
            else if (isSwf(code)) {<br>
                #ifdef VMCFG_VERIFYALL<br>
                if (config.verbose_vb &amp; VB_verify)<br>
                    console &lt;&lt; "SWF " &lt;&lt; filename &lt;&lt; "\n";<br>
                #endif<br>
                handleSwf(filename, code, shell_toplevel, user_codeContext);<br>
            }<br>
            else {<br>
                console &lt;&lt; "unknown input format in file: " &lt;&lt; filename &lt;&lt; "\n";<br>
                return(1);<br>
            }<br>
        }<br>
        CATCH(Exception *exception)<br>
        {<br>
            TRY(this, kCatchAction_ReportAsError)<br>
            {<br>
                console &lt;&lt; string(exception-&gt;atom) &lt;&lt; "\n";<br>
            }<br>
            CATCH(Exception * e2)<br>
            {<br>
                (void)e2;<br>
                console &lt;&lt; "Sorry, an exception occurred but could not be reported\n";<br>
            }<br>
            END_CATCH<br>
            END_TRY<br>
<br>
            return 1;<br>
        }<br>
        END_CATCH<br>
        END_TRY<br>
<br>
        return 0;<br>
    }<br>
</code></pre>

From there, not only we will be able to generate a projector from AS3,<br>
but we will also be able to create a projector from a <code>*.swf</code> file<br>
and that means we can reuse <code>*.abc</code> files as libraries (kind of like a <code>*.swc</code>).<br>
<br>
TODO (talk about tools here)<br>
<br>
<b>createprojector</b><br>
see <a href='http://code.google.com/p/redtamarin/source/browse/samples/createprojector.as'>/samples/createprojector.as</a>
<pre><code>Usage:<br>
 createprojector [-exe avmshell] [-o filename] file<br>
 file           a *.swf or *.abc file<br>
 -exe avmshell  the avmshell executable to use<br>
 -o filename    defines the name of the output file<br>
</code></pre>


<h3>Special Case for OSX</h3>

under OSX you run executable as <code>.app</code><br>
and an <code>.app</code> file is basically a directory containing other files<br>
<br>
so to create a projector with the standalone flash player on OSX you need to do something a bit different<br>
<pre><code>1. option click your "Flash Player.app"<br>
2. select "Show Package Contents"<br>
3. in this path "Contents/Resources/"<br>
drop a swf file named "movie.swf"<br>
<br>
voila you got your projector for OSX<br>
</code></pre>



<h3>Misc.</h3>

Where to find the Flash Player projectors:<br>
<a href='http://kb2.adobe.com/cps/142/tn_14266.html'>Archived Flash Player versions</a>

example:<br>
<ul><li>unzip <code>flashplayer10r42_34_mac_sa_debug.app.zip</code>
</li><li>run <code>Flash Player.app</code>