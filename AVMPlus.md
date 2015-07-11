## Introduction ##

This API is specific to **redshell** (avmshell) running on the command-line.

In short, anything that is considered native goes into the **avmplus** AS3 package.


## Implementation ##

Tamarin provide **avmplus.System** and **avmplus.File**.

We updated and changed **avmplus.System**<br>
and removed <b>avmplus.File</b> (replaced by <b>avmplus.FileSystem</b>).<br>
<br>
<br>
And we plan to add more, for ex: <b>avmplus.Process</b>, <b>avmplus.Host</b>, etc.<br>
<br>
<br>
<b>Wishlist and/or priority:</b>

<ul><li>file system: add a complete set of features to deal with files, directories, paths, etc.<br>
</li><li>operating system: obtain detailled informations about the system<br>
</li><li>Socket: basic raw sockets, client and server<br>
</li><li>full support of stdin, stdout, stderr<br>
</li><li>process: controlling another executable and connecting to its stdin, stderr, stdout<br>
</li><li>IPC: Inter-Process Communication so we can implement native <b>LocalConnection</b></li></ul>


<h2>API</h2>

here a small map of the AVMPlus API<br>
<pre><code><br>
C<br>
  |_ stdlib<br>
  |    |_ ...<br>
  |<br>
  |_ unistd<br>
  |    |_ ...<br>
  |<br>
  |_ string<br>
  |    |_ ...<br>
  |<br>
  |_ errno<br>
  |    |_ ...<br>
  |<br>
  |_ stdio<br>
  |    |_ ...<br>
  |<br>
  |_ socket<br>
       |_ ...<br>
  <br>
<br>
avmplus<br>
  |_ System<br>
  |_ OperatingSystem<br>
  |_ FileSystem<br>
  |_ Socket<br>
  |_ Domain<br>
  |_ JObject<br>
  |<br>
  |_ debugger()<br>
  |<br>
  |_ profiles<br>
      |_ Profile<br>
<br>
flash<br>
  |_ utils<br>
  |    |_ Dictionary<br>
  |    |_ Endian<br>
  |<br>
  |_ sampler<br>
  |    |_ StackFrame<br>
  |    |_ Sample<br>
  |    |_ NewObjectSample<br>
  |    |_ DeleteObjectSample<br>
  |    |_ ...<br>
  |<br>
  |_ trace<br>
  |    |_ Trace<br>
  |<br>
  |_ system<br>
  |    |_ Capabilities<br>
<br>
(top level)<br>
  |_ ...<br>
<br>
</code></pre>


<h2>Limitation</h2>

Because we want redtamarin to stay a <a href='CrossPlatform.md'>cross platform</a> tool we may not implement some features specific to a particular Operating System.<br>
<br>
With some exceptions, for example, being able to access the Windows registry could be usefull.