## Introduction ##

see http://en.wikipedia.org/wiki/Event_loop
```
In computer science, the event loop, message dispatcher, message loop, message pump, or run loop
is a programming construct that waits for and dispatches events or messages in a program.
It works by making a request to some internal or external "event provider"
(which generally blocks the request until an event has arrived),
and then it calls the relevant event handler ("dispatches the event").
The event-loop may be used in conjunction with a reactor, if the event provider follows the file interface,
which can be selected or 'polled' (the Unix system call, not actual polling).
The event loop almost always operates asynchronously with the message originator.

When the event loop forms the central control flow construct of a program, as it often does,
it may be termed the main loop or main event loop.
This title is appropriate because such an event loop is at the highest level of control within the program.
```


To be able to implement and use the AS3 Event system in AVMGlue,
we need to define an Event Loop.

## Sync vs Async ##

By default, redtamarin is **synchronous** (or blocking).

A program run once and then terminate.

```
trace( "start of the program" );

// do stuff

trace( "end of the program" );
```

The only way to disturb this **continuous flow** is to use a blocking function,
which can block the flow indefinitely.

```
trace( "start of the program" );

// do stuff

sleep( 30 ); //block the flow for 30 seconds

// do more stuff

trace( "end of the program" );
```

<br>
<br>


To change this behaviour to <b>asynchronous</b> (or non-blocking)<br>
we need to create a global event loop that prevent the program to terminate<br>
and which can process events.<br>
<br>
<pre><code>while( true ) //prevent program termination<br>
{<br>
    // do stuff<br>
    process_events(); //poll<br>
    // do more stuff<br>
    sleep( 1 ); // buffer a little<br>
}<br>
</code></pre>

Yes, that's the irony, you have an infinite loop which is blocking your program from exiting to make it non-blocking.<br>
<br>
<br>
<h2>Copy the Flash/AIR event loop</h2>

Based on different posts and articles we can have a general idea on how this event loop is working with Flash/AIR.<br>
<br>
<a href='http://blog.kaourantin.net/?p=82'>Timing it right</a> by Tinic Uro (Adobe)<br>
<br>
<pre>
Until now the Flash Player has been using a poll based system.<br>
Poll based means that everything which happens in the player is served<br>
from a single thread and entry point using a periodic timer which polls the run-time.<br>
In pseudo code the top level function in the Flash Player looked like this<br>
</pre>

<pre><code>while ( sleep ( 1000/120 milliseconds ) ) {<br>
  // Every browser provides a different timer interval<br>
  ...<br>
  if ( timerPending ) { // AS2 Intervals, AS3 Timers<br>
    handleTimers();<br>
  }<br>
  if ( localConnectionPending ) {<br>
    handleLocalConnection();<br>
  }<br>
  if ( videoFrameDue ) {<br>
    decodeVideoFrame();<br>
  }<br>
  if ( audioBufferEmpty ) {<br>
    refillAudioBuffer();<br>
  }<br>
  if ( nextSWFFrameDue ) {<br>
    parseSWFFrame();<br>
    if ( actionScriptInSWFFrame ) {<br>
      executeActionScript();<br>
    }<br>
  }<br>
  if ( needsToUpdateScreen ) {<br>
    updateScreen();<br>
  }<br>
  ...<br>
}<br>
</code></pre>

note: <code>1000/120 milliseconds = 8.3333 milliseconds</code>

also<br>
<pre>
The periodic timer is not driven by the Flash Player, it is driven by the browser.<br>
In case of Internet Explorer there is an API for this purpose. In the case of Safari on OS X<br>
is it hard coded to 50 frames/sec.<br>
Every browser implements this slightly differently and things become very complex<br>
quickly once you go into details.<br>
This has been causing a lot of frustration among designers who could never count<br>
on a consistent cross platform behavior.<br>
</pre>

and from <a href='http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/Timer.html#delay'>Timer delay asdoc</a>
<pre>
A delay lower than 20 milliseconds is not recommended.<br>
Timer frequency is limited to 60 frames per second,<br>
meaning a delay lower than 16.6 milliseconds causes runtime problems.<br>
</pre>

We can extrapolate that Flash/AIR were using a sleep period of<br>
<code>1000/60 milliseconds = 16.666 milliseconds</code>

in our case, we can not and don't want to reuse a periodic timer based on a browser API<br>
and we probably want to allow users to change the sleep period, so we will reuse (as in the pseudo code above)<br>
a hard coded sleep period.<br>
<br>
<pre><code>sleep period = 1000 / N = frequency of polling // N fps<br>
<br>
1000 / 120 =  8.333 // 120fps<br>
1000 /  60 = 16.666 //  60fps<br>
etc.<br>
</code></pre>

as a side note, the Flash player is limited to 60fps<br>
see <a href='http://www.tekool.net/blog/2008/05/27/overriding-flash-player-60fps-limit-in-firefox-up-to-950fps-as-silverlight-2-in-bubblemark/'>Overriding Flash player 60fps limit in Firefox</a>


Following the post we can see another way to implement this event loop<br>
<pre><code>while ( sleepuntil( nextEventTime  ) OR externalEventOccured() ) {<br>
  ...<br>
  if ( timerPending ) { // AS2 Intervals, AS3 Timers<br>
    handleTimers();<br>
    nextEventTime = nextTimerTime();<br>
  }<br>
  if ( localConnectionPending ) {<br>
    handleLocalConnection();<br>
    nextEventTime = min(nextEventTime , nextLocalConnectionTime());<br>
  }<br>
  if ( videoFrameDue ) {<br>
    decodeVideoFrame();<br>
    nextEventTime = min(nextEventTime , nextVideoFrameTime());<br>
  }<br>
  if ( audioBufferEmpty ) {<br>
    refillAudioBuffer();<br>
    nextEventTime = min(nextEventTime , nextAudioRebufferTime());<br>
  }<br>
  if ( nextSWFFrameDue ) {<br>
    parseSWFFrame();<br>
    if ( actionScriptInSWFFrame ) {<br>
      executeActionScript();<br>
    }<br>
    nextEventTime = min(nextEventTime , nextFrameTime());<br>
  }<br>
  if ( needsToUpdateScreen ) {<br>
    updateScreen();<br>
  }<br>
  ...<br>
}<br>
</code></pre>

with some rules<br>
<pre>
Visible:<br>
- SWF frame rates are limited and aligned to jiffies, i.e. 60 frames a second.<br>
(Note that Flash Playe 10.1 Beta 3 still has an upper limit of 120 which will be changed before the final release)<br>
- timers (AS2 Interval and AS3 Timers) are limited and aligned to jiffies.<br>
- local connections are limited and aligned to jiffies. That means a full round trip from one SWF to another<br>
will take at least 33 milliseconds. Some reports we get say it can be up to 40ms.<br>
- video is NOT aligned to jiffies and can play at any frame rate. This increases video playback fidelity.<br>
<br>
Invisible:<br>
- SWF frame rate is clocked down to 2 frames/sec.<br>
No rendering occurs unless the SWF becomes visible again.<br>
- timers (AS2 Interval and AS3 Timers) are clocked down to 2 a second.<br>
- local connections are clocked down to 2 a second.<br>
- video is decoded (not rendered or displayed) using idle CPU time only.<br>
- For backwards compatibility reasons we override the 2 frames/sec frame rate<br>
to 8 frames/sec when audio is playing.<br>
</pre>

<h2>Previous Work to Simulate an Event Loop in Tamarin</h2>

Previously in Tamarin you could see in <code>/test/performance/canaries/</code>

<a href='https://code.google.com/p/redshell/source/browse/test/performance/canaries/simpleflexapputil/playershell.as?spec=svn09c5c83eea908c195ce602623d78616612252afc&r=fec870a438a8054ec2028deffd990bcec067ba0f'>playershell.as</a> implemented by Dan Schaffer.<br>
<br>
see <a href='https://bugzilla.mozilla.org/show_bug.cgi?id=473985'>Bug 473985 - add interactive shell capabilities to canaries/simpleflexapputil/playershell.as</a>

from simpleflexapp.as<br>
<pre><code>include "simpleflexapputil/playershell.as"<br>
<br>
var start:int=new Date();<br>
<br>
loadabcfile("canaries/simpleflexapputil/avmglue_abc");<br>
loadabcfile("canaries/simpleflexapputil/hello_frame1_abc");<br>
<br>
objectsnames.push("_hello2_mx_managers_SystemManager");<br>
constructobject("0");<br>
dispatchevent("init 0");<br>
<br>
loadabcfile("canaries/simpleflexapputil/hello_frame2_abc");<br>
<br>
set("currentFrame 0 1");<br>
Stage.getInstance().dispatchEvent(new Event("render"));<br>
Stage.getInstance().dispatchEvent(new Event("render"));<br>
Stage.getInstance().dispatchEvent(new Event("render"));<br>
Stage.getInstance().dispatchEvent(new Event("render"));<br>
var totaltime:int=new Date()-start;<br>
<br>
showdisplaylist();<br>
<br>
print("metric time "+totaltime);<br>
</code></pre>

Very interesting bit of code which allow us to see a glimpse of<br>
<ul><li>how to implement a custom EventDispatcher<br>
</li><li>how to run an event loop<br>
</li><li>even how to parse a SWF file and some of its tags (like DoABC)</li></ul>

<h2>Some of Our Implementations in the Past</h2>

EventDispatcher in AS2, see <a href='https://code.google.com/p/vegas/source/browse/AS2/trunk/src/vegas/events/'>https://code.google.com/p/vegas/source/browse/AS2/trunk/src/vegas/events/</a><br>
in particular <a href='https://code.google.com/p/vegas/source/browse/AS2/trunk/src/vegas/events/EventDispatcher.as'>EventDispatcher.as</a>

EventDispatcher in JS, see <a href='https://code.google.com/p/vegas/source/browse#svn%2FJS%2Ftrunk%2Fsrc%2Fsystem%2Fevents'>https://code.google.com/p/vegas/source/browse#svn%2FJS%2Ftrunk%2Fsrc%2Fsystem%2Fevents</a>!<br>
<br>
Yep, Marc did a great work implementing W3C DOM Events Level 2/3 in JS and AS2.<br>
<br>
<h2>Some of Others implementation</h2>

<a href='https://github.com/PrimaryFeather/Starling-Framework/blob/master/starling/src/starling/events/EventDispatcher.as'>Starling EventDispatcher.as</a>



<h2>More Documentation on the Flash Internals</h2>

<a href='http://www.senocular.com/flash/tutorials/orderofoperations/'>Order of Operations in ActionScript</a>

<a href='http://blog.johannest.com/2009/06/15/the-movieclip-life-cycle-revisited-from-event-added-to-event-removed_from_stage/'>The MovieClip life cycle revisited. From Event.ADDED to Event.REMOVED_FROM_STAGE</a>

from <code>http://www.alanklement.com/img/fp10_timeline.gif</code><br>
<img src='http://www.alanklement.com/img/fp10_timeline.gif' />

<a href='http://blog.joa-ebert.com/2010/10/03/opening-the-blackbox/'>Opening the Blackbox</a><br>
and see <a href='https://github.com/joa/apparat/blob/master/apparat-taas/src/main/scala/apparat/taas/frontend/abc/AbcFrontend.scala'>AbcFrontend.scala</a> for the list of interfaces to support<br>
<br>
<pre>
The playerglobal.swc contains all classes the Flash Player knows about.<br>
It should and it does with some minor differences. Of course it could be a bug on my end but some interfaces are missing.<br>
And they are suspicious since they cause/have special behaviour. Have a look at the AbcFrontend code.<br>
The Synthetic object contains part of the AST that is synthesized since those interfaces are missing in playerglobal.swc.<br>
</pre>
<pre><code>IBitmapDrawable<br>
IGraphicsFill<br>
IGraphicsData<br>
IGraphicsPath<br>
IGraphicsStroke<br>
IDynamicPropertyOutput<br>
IDataInput<br>
IDataOutput<br>
<br>
and flash.net<br>
IDataInput<br>
IDataOutput<br>
</code></pre>


<a href='http://tedpatrick.com/2005/07/19/flash-player-mental-model-the-elastic-racetrack/'>Flash Player Mental Model – The Elastic Racetrack</a><br>
<a href='http://tedpatrick.com/2008/04/18/flash-player-mental-model-the-elastic-racetrack-revisited/'>Flash Player Mental Model – The Elastic Racetrack Revisited</a><br>
<a href='http://www.craftymind.com/2008/04/18/updated-elastic-racetrack-for-flash-9-and-avm2/'>Updated ‘Elastic Racetrack’ for Flash 9 and AVM2</a>

<img src='http://www.craftymind.com/wp-content/uploads/2008/04/elasticracetrackexport.png' />

<img src='http://www.craftymind.com/wp-content/uploads/2008/04/marshalledsliceexport.png' />

<img src='http://www.craftymind.com/wp-content/uploads/2008/04/framemarshalingexport.png' />


<a href='http://www.adobe.com/devnet/scout/articles/understanding-flashplayer-with-scout.html'>Understanding Flash Player with Adobe Scout</a>

this must be the most comprehensible and detailed article about the internals of the flash player :)<br>
<br>
<img src='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/scout/articles/understanding-flashplayer-with-scout/understanding-flashplayer-with-scout-fig04.png' />

<img src='http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/devnet/scout/articles/understanding-flashplayer-with-scout/understanding-flashplayer-with-scout-fig05.png' />

from that we know now that we'll need a <b>FrameTicker</b> class , a <b>GraphicRenderer</b> class (for <b>DisplayListRenderer</b>, <b>Stage3DRenderer</b>, etc.) and a <b>SWFLoader</b> class.<br>
<br>
<br>
<br>
<h2>How We Are Doing It</h2>

It's a work in progress, but here some basic rules<br>
<ul><li>try to do it in AS3 and not in C/C++<br>
</li><li>respect the Flash/AIR API signatures but allow us to use the <b>AVM2</b> namespace to add/access special stuff<br>
</li><li>starts simple then go more complex<br>
</li><li>define an <b>IEventLoop</b></li></ul>

So we start simple and gonna test only the Timer events<br>
<br>
<pre><code>package shell<br>
{<br>
    public interface IEventLoop<br>
    {<br>
        <br>
        function get frequency():uint;<br>
        function set frequency( value:uint ):void;<br>
        <br>
        function get timerPending():Boolean;<br>
        <br>
        function handleTimers():void;<br>
        <br>
        function start():void<br>
        function stop():void;<br>
    }<br>
}<br>
</code></pre>



our main loop should look like<br>
<pre><code>private function _loop():void<br>
{<br>
<br>
    while ( sleep ( 1000/frequency ) &amp;&amp; run )<br>
    {<br>
    <br>
        if( timerPending )<br>
        {<br>
            handleTimers();<br>
        }<br>
    <br>
    }<br>
<br>
}<br>
</code></pre>

we should be able to<br>
<ul><li>update the <b>frequency</b> dynamically<br>
</li><li>exit the loop manually at any time (eg. <code>run = false</code>)<br>
</li><li>exit the loop on an interrupt (eg. <code>abort()</code>, <code>exit()</code>, etc.)</li></ul>

We copy CrossBridge <code>AS3_GoAsync();</code> to kickstart the main event loop from RedTamarin.<br>
<br>
for example<br>
<pre><code>//if we do nothing, everything run sync/blocking<br>
<br>
//some stuff<br>
<br>
//the program will terminate<br>
<br>
----<br>
//if we want to be async and non-blocking<br>
import shell.Program;<br>
<br>
Program.goAsync(); //will run an implementation of IEventLoop<br>
<br>
//eg.<br>
//Program.loop = new DefaultLoop();<br>
//Program.loop.start();<br>
</code></pre>


<h2>If We Go Native</h2>

Different article about implementing event loop in C/C++<br>
<br>
<a href='http://cr.yp.to/docs/selfpipe.html'>The self-pipe trick</a>

<a href='http://www.win.tue.nl/~aeb/linux/lk/lk-12.html'>Handling of asynchronous events</a>

<a href='http://stackoverflow.com/questions/282176/waitpid-equivalent-with-timeout'>Waitpid equivalent with timeout?</a>

<a href='http://www.w3.org/TR/DOM-Level-3-Events/'>Document Object Model (DOM) Level 3 Events Specification</a>

<a href='http://www.w3.org/Library/'>Libwww - the W3C Protocol Library</a>

WebIDL<br>
<a href='http://dev.w3.org/2006/webapi/WebIDL/'>http://dev.w3.org/2006/webapi/WebIDL/</a><br>
<ul><li><a href='http://heycam.github.io/webidl/'>WebIDL specification</a>
</li><li><a href='https://github.com/heycam/webidl'>https://github.com/heycam/webidl</a></li></ul>

<a href='https://code.google.com/p/es-operating-system/wiki/CplusplusDOM'>C++ DOM API Introduction</a>

<a href='http://www.codeproject.com/Articles/18766/Create-Cross-platform-Thread-Independent-Event-Loo'>Create Cross-platform Thread-Independent Event Loops</a>