Here a small tutorial from start to finnish<br>
to get you started writing code for redtamarin in<br>
<ul><li>Flex Builder 3.0<br>
</li><li>Flash Builder 4.0<br>
</li><li>Flash Builder 4.5</li></ul>


<h2>Introduction</h2>

You still need to do the default <a href='GettingStarted.md'>Getting Started</a> tasks<br>
<ul><li><a href='GettingStarted#Download_the_shell.md'>Download the shell</a>
</li><li><a href='GettingStarted#Download_the_component.md'>Download the component</a>
</li><li><a href='GettingStarted#Build_the_tools.md'>Build the tools</a></li></ul>

<br>
<br>
<h2>Define a workspace</h2>

Because redtamarin is not your default Flex Builder project,<br>
I would advise you to create an Eclipse workspace dedicated to redtamarin development.<br>
<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/redtamarin_workspace.png' />

Each Eclipse workspace have a <code>.metadata</code> folder containing various settings,<br>
here with one of the tools we have built, we gonna inject a bunch of external tools into this folder.<br>
<br>
Here what we have by default<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/tools_default.png' />

run EclipseExternalTools<br>
<pre><code>$ ./EclipseExternalTools /work/Demos/redtamarin<br>
</code></pre>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/running_EclipseExternalTools.png' />

if you go into the folder <code>.metadata/.plugins/org.eclipse.debug.core/.launches/</code><br>
you will see that list of scripts we just added<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/eclipse_list_launches.png' />

Now, close Flex Builder and restart it.<br>
<br>
<br>
<br>
<h2>Edit our tools first</h2>

Let's open the external tools<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/open_external_tools.png' />

On the top left, you should see our list of tools<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/List_of_external_tools.png' />

Now, open the external tools favorite<br>
and add all the tools (eg. click "Organize favorites...")<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/add_external_tools_to_favorites.png' />

Select the order that you prefer with "move up", "move down", etc.<br>
<br>
And now, let's see our tools<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/List_of_tools.png' />

Here a summary of those tools<br>
<table><thead><th> <b>tool</b>  </th><th> <b>description</b> </th><th> <b>alternative to</b> </th></thead><tbody>
<tr><td> ASC_compile  </td><td> compile an <code>*.as</code> file with ASC </td><td> Flex Builder MXMLC compiler </td></tr>
<tr><td> redshell_debug </td><td> run an <code>*.abc</code> file with redshell_d </td><td> Debug button          </td></tr>
<tr><td> redshell_run </td><td> run an <code>*.abc</code> file with redshell </td><td> Run button            </td></tr>
<tr><td> make_projector </td><td> take an <code>*.abc</code> or <code>*.swf</code> file and create an executable </td><td> n/a                   </td></tr>
<tr><td> dump_api     </td><td> take an <code>*.abc</code> or <code>*.swf</code> file and dump the API </td><td> n/a                   </td></tr>
<tr><td> dump_infos   </td><td> take an <code>*.abc</code> or <code>*.swf</code> file and dump the infos </td><td> n/a                   </td></tr>
<tr><td> extract_abc  </td><td> take a <code>*.swf</code> file and dump all the <code>*.abc</code> files </td><td> n/a                   </td></tr></tbody></table>


<br>
<br>
<h2>Our first project</h2>

Create an ActionScript project<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/create_actionscript.png' />

and name it "test"<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/create_test_project.png' />

edit the Library path and remove any default SWC reference<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/clean_library_path.png' />

by default you will get this error<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/default_Sprite_error.png' />

that's normal, under redtamarin there is no Sprite class (well.. not yet, another tutorial for that).<br>
<br>
So, to deactivate this error, and a bunch of other errors, you need to edit your project properties<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/edit_project_properties.png' />

in the Builders section on the left, deselect "Flex", and confirm by clicking "OK"<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/remove_flex_builder.png' />


As it is, you disabled some Flex Builder options and settings, but nothing can work yet.<br>
<br>
You need to create two directories in your project<br>
<ul><li><b>bin</b>, where you gonna drag n drop the results of <a href='GettingStarted#Build_the_tools.md'>Build the tools</a>
</li><li><b>lib-swc</b> (or any other name), where you gonna drop the <code>redtamarin.swc</code> (from <a href='GettingStarted#Download_the_component.md'>Download the component</a>)</li></ul>

You should obtain this directory structure<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/project_directory_structure.png' />

Edit again your project properties<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/edit_project_properties.png' />

And in Library path add the <b>lib-swc</b> folder<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/add_swc_folder.png' />

In details that gives<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/swc_folder_details.png' />

Now, clean up the default code that Flex Builder created in <code>test.as</code> to start from fresh<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/start_from_fresh.png' />

I know, it sucks to do all those settings by hand, I'll try to come up with a way to automate that.<br>
<br>
Voila, you're ready to write your first redtamarin program :).<br>
<br>
<br>
<br>
<h2>Our first program</h2>

Because our tools run on the command line, it is also a good idea to display the console window<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/display_console.png' />

Let's write some code!<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/redtamarin_syntax_completion_1.png' />

yes, you're not dreaming<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/redtamarin_syntax_completion_2.png' />

there is full syntax completion support<br>
like a normal Flash/Flex project<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/redtamarin_syntax_completion_3.png' />

Now, let's compile the program!<br>
be sure to have <code>test.as</code> selected<br>
then click on the <b>ASC_compile</b> tool<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/tool_ASC_compile.png' />

and here the result<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/ASC_compile_result.png' />

the console tell us that we create a 116 bytes file,<br>
and you can see also on the left panel a new file: <code>test.abc</code>.<br>
<br>
Now, let's run the code!<br>
be sure to select <code>test.abc</code> on the left panel<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/select_test_abc.png' />

then click on the <b>redshell_run</b> tool<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/tool_redshell_run.png' />

and see the console output in all its glory<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/output_simple_test.png' />

the username result should off course reflect the username defined on your system =).<br>
<br>
That is very basic and I hope simple, but that's how you work with redtamarin:<br>
<ul><li>you compile one or more <code>*.as</code> file(s) to an <code>*.abc</code> file<br>
</li><li>you run one or more <code>*.abc</code> file(s) with the <code>redshell</code></li></ul>

<h2>More stuff you should know</h2>

Let's edit our code in a way that it will generate a runtime error<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/edit_the_code_to_create_an_error.png' />

Run the abc file with <b>redshell_run</b><br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/tool_redshell_run.png' />

here the result<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/error_with_redshell_run.png' />

<code>Error #1500</code> as it is not very helpful ...<br>
<br>
Let's run the abc file with <b>redshell_debug</b><br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/tool_redshell_debug.png' />

here the result<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/error_with_redshell_debug.png' />

<pre><code>Error: Error #1500: Error occurred opening file hello.txt<br>
        at avmplus:;FileSystem$/read()<br>
        at global$init()<br>
</code></pre>

much more useful, and that's why there is also a debug release of redshell as <b>redshell_d</b><br>
that's the only version that give you error details.<br>
<br>
<br>
Now, let's be crazy and write a class.<br>
<br>
And let's make an obvious syntax error and see what happen<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/syntax_error_at_compilation.png' />

yes, the compiler will tell you something is wrong and in red so you really can not miss it.<br>
<br>
<br>
So we spent few minutes writing a class, let's see a big screenshot<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/main_program_containing_class_and_main_entry_point.png' />

the same stuff as writing code for Flash<br>
<ul><li>you get the layout of the class on the left panel<br>
</li><li>you get syntax colorisation<br>
</li><li>you get syntax completion</li></ul>

the different stuff<br>
<ul><li>you can declare more than one definition per file<br>if you wanted you could declare 3/4 classes or more in the same file<br>
</li><li>your file name does not have to be same name as the class<br>
</li><li>your main class will not automatically run by itself, you have to explicitly run it<br>see under <code>//main entry point</code>
</li><li><code>trace()</code> will output wether you use the release or debug version of redshell</li></ul>

Now for a special thing related to Eclipse and command line,<br>
Eclipse console seems to not support an interactive mode,<br>
so if you use a <b>blocking</b> function the console will get stuck.<br>
<br>
For those case, you will have to run your program in a "real" console or terminal<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/use_external_console_for_interactive_program.png' />


But, depending on your coding style or what you program, putting it all in one file may not work for you,<br>
so let's see another way, we keep the main entry point in <code>test.as</code> but externalise the class Robot to its own <code>Robot.as</code> file<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/main_program_with_includes.png' />

Like good old AS1 you use includes, and usually include everything from your main file.<br>
<br>
But let's see what happen when we compile<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/main_program_with_includes_missing_import.png' />

<blockquote>Yes, including a file does not necessary import it, you have to use <code>import</code><br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/main_program_with_includes_and_import.png' /></blockquote>


Now, let's turn this simple program in an executable,<br>
select the abc file and click <b>make_projector</b><br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/tool_make_projector.png' />

here the result<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/make_projector_result.png' />

It created a <code>test2</code> executable, yes it should be named <code>test</code>,<br>
but because we already have a directory named <code>test</code><br>
the program <code>createprojector</code> altered the name to <code>test2</code>.<br>
<br>
And voila, a standalone executable containing both <code>redshell</code> and <code>test.abc</code> is generated<br>
<img src='http://redtamarin.googlecode.com/svn/gfx/gettingstarted/standalone_executable.png' />