## Introduction ##

See [Organization](Organization.md).

You will need the [gclient](http://code.google.com/p/maashaack/wiki/gclient) command-line tool to checkout the code.

## Details ##

to do a first checkout
```
$ gclient config https://redtamarin.googlecode.com/svn/configs/redtamarin
$ gclient update
```

gclient will iterate trough the different dependencies defined in `DEPS`<br>
and do a <code>svn checkout</code> per dependency.<br>
<br>
later to update the directories you just need to do<br>
<pre><code>$ gclient sync<br>
</code></pre>


if you are a committer, you need to enter a directory to update your changes<br>
<pre><code>$ cd src/tamarin/VMPI<br>
$ svn commit -m "updating VMPI"<br>
</code></pre>