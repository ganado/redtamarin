## Introduction ##

Because the [tamarin-central](http://hg.mozilla.org/tamarin-central) and [tamarin-redux](http://hg.mozilla.org/tamarin-redux) repositories use [Mercurial](http://mercurial.selenic.com/) and that we prefer to work with Subversion
we need to have a special setup.

On another google project [redshell](http://code.google.com/p/redshell/) we sync every week with the tamarin-redux repository, here why:
  * we want to use google code ([look at this](http://code.google.com/p/redshell/source/list))
  * it allow us to send back back patches to the Tamarin project
  * it allow us to semi-automate an `hg archive + svn commit`

So, ~~each week (in general every sunday)~~ in a regular basis, we override this path [/svn/tamarin-redux](http://redtamarin.googlecode.com/svn/tamarin-redux/) with the content of redshell.

We try to stay in sync with the last official releases made by Adobe, for example, if Adobe release AIR 2.0, then we probably sync right after that.

Also, we need to be in sync with ASC (ActionScript Compiler)<br>
so we're checking a subpath of the <a href='http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK'>Adobe Flex SDK</a> the<br>
<a href='http://opensource.adobe.com/svn/opensource/flex/sdk/trunk/modules/asc'>/modules/asc</a>.<br>
<br>
<h2>Project structure</h2>

here what you will obtain after a checkout (see <a href='Code101.md'>get the code</a>)<br>
<pre><code><br>
* = external repositories<br>
<br>
  ..<br>
   |_ .gclient<br>
   |_ redtamarin<br>
           |_ build<br>
           |     |_ ...<br>
           |<br>
           |_ build.xml<br>
           |_ changelog.txt<br>
           |_ DEPS<br>
           |_ license.txt<br>
           |_ src<br>
               |_ asc<br>
               |   |_ ...                &lt;- */trunk/modules/asc (Flex SDK)<br>
               |<br>
               |_ tamarin                &lt;- /redtamarin-root/ (eg. single files)<br>
                   |_ api<br>
                   |   |_ clib           &lt;- /api/clib/trunk/<br>
                   |<br>
                   |_ as3<br>
                   |   |_ avmglue        &lt;- */platform/avmglue/trunk/src/ (maashaack)<br>
                   |   |_ clib           &lt;- */platform/clib/trunk/src/ (maashaack)<br>
                   |<br>
                   |_ axscript           &lt;- /tamarin-redux/axscript/<br>
                   |_ build              &lt;- /tamarin-redux/build/<br>
                   |_ configure.py              <br>
                   |_ core               &lt;- /tamarin-redux/core/<br>
                   |_ doc                &lt;- /tamarin-redux/doc/<br>
                   |_ Doxyfile                  <br>
                   |_ esc                &lt;- /tamarin-redux/esc/<br>
                   |_ eval               &lt;- /tamarin-redux/eval/<br>
                   |_ extensions         &lt;- /trunk/extensions/<br>
                   |_ localization       &lt;- /tamarin-redux/localization/<br>
                   |_ manifest.mk             <br>
                   |_ MMgc               &lt;- /tamarin-redux/MMgc/<br>
                   |_ nanojit            &lt;- /tamarin-redux/nanojit/<br>
                   |_ other-licenses     &lt;- /tamarin-redux/other-licenses/<br>
                   |_ pcre               &lt;- /tamarin-redux/pcre/<br>
                   |_ platform           &lt;- /trunk/platform/<br>
                   |_ shell              &lt;- /trunk/shell/<br>
                   |_ tests              &lt;- /tamarin-redux/tests/<br>
                   |_ utils              &lt;- /tamarin-redux/utils/<br>
                   |_ VMPI               &lt;- /trunk/VMPI/<br>
                   |_ vprof              &lt;- /tamarin-redux/vprof/<br>
<br>
</code></pre>

As you can see, we work on a very small part of the original Tamarin project.<br>
<br>
Because our goal is to add native implementations, we mainly need to work with: extensions, platform, shell and VMPI.<br>
<br>
All the other directories are directly checked out from <code>/tamarin-redux</code> which allow us to sync and update frequently from the original tamarin-redux.<br>
<br>
And as we work at the API level, we also added 2 directories: <code>/tamarin/api</code> and <code>/tamarin/as3</code>.<br>
<br>
<code>/tamarin/api</code> contains the C/C++ implementations of the API.<br>
<br>
<code>/tamarin/as3</code> contains the AS3 implementations of the API and are hosted on <a href='http://code.google.com/p/maashaack'>maashaack</a>.<br>
<br>
And finally, with a structure like this we can use Ant to automate the build and other things.<br>
<br>
now hopefully when you will <a href='http://code.google.com/p/redtamarin/source/browse/#svn/trunk'>browse the trunk</a>
you will understand why it list only four directories ;).<br>
<br>
<br>
<h2>misc</h2>

All our AS3 source code reside on <a href='http://code.google.com/p/maashaack'>maashaack</a>.<br>
<br>
You will find the different AS3 projects related to redtamarin under the <a href='http://code.google.com/p/maashaack/source/browse/#svn/platform'>/platform</a> directory.<br>
<br>
For more informations you can consult<br>
<ul><li><a href='http://code.google.com/p/maashaack/wiki/OverView#Platform'>Documentation/Overview#Platform</a>
</li><li>the <a href='http://code.google.com/p/maashaack/wiki/avmglue'>avmglue</a> project<br>
</li><li>the <a href='http://code.google.com/p/maashaack/wiki/swfinfos'>swfinfos</a> tool<br>
</li><li>the <a href='http://code.google.com/p/maashaack/wiki/flashdoc'>flashdoc</a> tool<br>
</li><li>the <a href='http://code.google.com/p/maashaack/wiki/soldump'>soldump</a> tool<br>
</li><li>etc.