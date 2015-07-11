## Introduction ##

In the Flash Community out there you have tons of AS3 libraries,<br>
and yeah <b>redtamarin</b> can use them, but you could face some bump on the road<br>
so here some infos and advices.<br>
<br>
<br>
<h2>Details</h2>

When you're working with the Flash IDE or Flash Builder (Flex Builder or Eclipse + FDT or Flash Develop, etc.<br>
things are easy as those IDE do a lot of work for you, and some you probably don't know (or don't want to know).<br>
<br>
When you're working with redtamarin, you do need to know the in-depth working of the compilers,<br>
the SWF format, the SWC format, etc.<br>
<br>
It's not that hard but you need to be aware of a couple of things.<br>
<br>
<b>Flash/AIR workflow</b>
<ul><li>I create project in the IDE<br>
</li><li>I need to reuse an AS3 library<br>
<ul><li>I drop a SWC and link it to the compiler<br>
</li><li>or I add the sources and add them to the compiler</li></ul></li></ul>

<b>redtamarin</b> as it is can not use a SWC library,<br>
even worst, you can not add a source directory like that<br>
you have to include every single <code>*.as</code> files.<br>
<br>
So here we have two choices<br>
<ul><li>deal only with <code>*.as</code> source code and include everything by hand<br>
</li><li>find a way to generate an <code>*.abc</code> library that we can reuse</li></ul>

<h2>Example with Box2D</h2>

Recently I got someone asking me about reusing <a href='http://box2dflash.sourceforge.net/'>Box2D</a> inside redtamarin<br>
which at first seems straightforward but in fact require a bit of cooking.<br>
<br>
The <b>use case</b> is to be able to calculate with box2d on the server instead of the client,<br>
and yes <b>redtamarin</b> is perfect for that, but you will need to a <code>box2d.abc</code> library.<br>
<br>
<br>
For those tests I used <a href='http://sourceforge.net/projects/box2dflash/files/box2dflash/Box2DFlashAS3_2.1a/Box2DFlashAS3%202.1a.zip/download'>Box2DFlashAS3 2.1a</a>.<br>
<br>
so here what we got in the zip file<br>
<pre><code>..<br>
  |_ Build<br>
    |_ FlashDevelop<br>
  |_ Docs<br>
  |_ Examples<br>
  |_ README.txt<br>
  |_ Source<br>
    |_ Box2D<br>
      |_ Collision<br>
      |_ Common<br>
      |_ Dynamics<br>
</code></pre>

The project provide the source code but no build or SWC.<br>
<br>
On the good side, the source code use only AS3 builtin classes and no Flash Player API classes<br>
(also why I took this project as a first example ;)).<br>
<br>
<br>
Let's start with a basic Ant build<br>
<pre><code>..<br>
  |_ Build<br>
    |_ FlashDevelop<br>
  |_ build.xml     &lt;-- here<br>
  |_ Docs<br>
  |_ Examples<br>
  |_ README.txt<br>
  |_ Source<br>
    |_ Box2D<br>
      |_ Collision<br>
      |_ Common<br>
      |_ Dynamics<br>
</code></pre>

<b>build.xml</b> test1<br>
<pre><code>&lt;?xml version="1.0" encoding="UTF-8"?&gt;<br>
<br>
&lt;project name="foobar" default="main" basedir="."&gt;<br>
<br>
    &lt;target name="clean"&gt;<br>
        &lt;delete dir="bin-component"/&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="define-constants"&gt;<br>
        &lt;property name="FLEX_HOME" value="/OpenSource/Flex/sdks/3.4.0" /&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="before" depends="define-constants,define-tasks"&gt;<br>
        &lt;mkdir dir="bin-component"/&gt;<br>
    &lt;/target&gt;<br>
<br>
<br>
<br>
    &lt;target name="define-tasks"&gt;<br>
        &lt;taskdef resource="flexTasks.tasks" classpath="${FLEX_HOME}/ant/lib/flexTasks.jar" /&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="main" depends="clean,before,build,after"&gt;<br>
    &lt;/target&gt;<br>
<br>
<br>
    &lt;target name="after"&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="build" depends="build-box2d-swc"&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="build-box2d-swc"&gt;<br>
<br>
        &lt;compc<br>
            output="bin-component/test.swc"<br>
            target-player="10.0"<br>
        &gt;<br>
            &lt;strict&gt;true&lt;/strict&gt;<br>
            &lt;optimize&gt;true&lt;/optimize&gt;<br>
            &lt;warnings&gt;true&lt;/warnings&gt;<br>
            &lt;verbose-stacktraces&gt;true&lt;/verbose-stacktraces&gt;<br>
            &lt;compute-digest&gt;false&lt;/compute-digest&gt;<br>
<br>
            &lt;source-path path-element="${basedir}/Source" /&gt;<br>
            &lt;include-sources dir="${basedir}/Source" includes="**/*.as" /&gt;<br>
        &lt;/compc&gt;<br>
<br>
    &lt;/target&gt;<br>
&lt;/project&gt;<br>
</code></pre>

here I keep things very simple<br>
<ul><li>I take into account only my OS (OS X)<br>
</li><li>use a quite old version of the Flex SDK (which I do know will work with redtamarin)<br>
</li><li>no special properties or automation or any sorts</li></ul>

the important part is<br>
<pre><code>&lt;source-path path-element="${basedir}/Source" /&gt;<br>
&lt;include-sources dir="${basedir}/Source" includes="**/*.as" /&gt;<br>
</code></pre>

we basically tell COMPC to look in the <code>Source</code> folder, grab everything and generate a SWC.<br>
<br>
Once we obtain the <code>test.swc</code> we can then analyze it.<br>
<br>
A SWC is just a ZIP file with a different extension, under OS X I just rename the file and unzip<br>
<pre><code>..<br>
  |_ test<br>
    |_ catalog.xml<br>
    |_ library.swf<br>
</code></pre>

let's look into the <code>catalog.xml</code>
<pre><code>&lt;?xml version="1.0" encoding ="utf-8"?&gt;<br>
&lt;swc xmlns="http://www.adobe.com/flash/swccatalog/9"&gt;<br>
  &lt;versions&gt;<br>
    &lt;swc version="1.2" /&gt;<br>
    &lt;flex version="3.4.0" build="5348" /&gt;<br>
  &lt;/versions&gt;<br>
  &lt;features&gt;<br>
    &lt;feature-script-deps /&gt;<br>
    &lt;feature-files /&gt;<br>
  &lt;/features&gt;<br>
  &lt;libraries&gt;<br>
    &lt;library path="library.swf"&gt;<br>
      &lt;script name="Box2D/Dynamics/b2ContactManager" mod="1268167612000" signatureChecksum="1844657015" &gt;<br>
        &lt;def id="Box2D.Dynamics:b2ContactManager" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2Contact" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactFactory" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2ContactListener" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2ContactFilter" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2ContactPoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Fixture" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2DynamicTreeBroadPhase" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2Contact" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactFactory" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactEdge" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2ContactListener" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2ContactFilter" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2ContactPoint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Fixture" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:IBroadPhase" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2World" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      &lt;script name="Box2D/Collision/b2WorldManifold" mod="1263060828000" signatureChecksum="980784030" &gt;<br>
        &lt;def id="Box2D.Collision:b2WorldManifold" /&gt; <br>
        &lt;dep id="Box2D.Common:b2Settings" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2Manifold" type="e" /&gt; <br>
        &lt;dep id="__AS3__.vec:Vector" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="e" /&gt; <br>
        &lt;dep id="Math" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2Manifold" type="s" /&gt; <br>
        &lt;dep id="__AS3__.vec:Vector" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Transform" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Mat22" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      &lt;script name="Box2D/Dynamics/Contacts/b2ContactSolver" mod="1263242118000" signatureChecksum="3428585686" &gt;<br>
        &lt;def id="Box2D.Dynamics.Contacts:b2ContactSolver" /&gt; <br>
        &lt;dep id="Box2D.Common:b2Settings" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Math" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2WorldManifold" type="e" /&gt; <br>
        &lt;dep id="__AS3__.vec:Vector" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactConstraint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2PositionSolverManifold" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2TimeStep" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2WorldManifold" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2Manifold" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2ManifoldPoint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactConstraint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactConstraintPoint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2TimeStep" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2Contact" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision.Shapes:b2Shape" type="s" /&gt; <br>
        &lt;dep id="__AS3__.vec:Vector" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Mat22" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Fixture" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2PositionSolverManifold" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      &lt;script name="Box2D/Dynamics/Contacts/b2Contact" mod="1263419864000" signatureChecksum="2002497" &gt;<br>
        &lt;def id="Box2D.Dynamics.Contacts:b2Contact" /&gt; <br>
        &lt;dep id="Box2D.Common:b2Settings" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2TimeOfImpact" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2TOIInput" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision.Shapes:b2Shape" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactEdge" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2Manifold" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Sweep" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2TOIInput" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2ContactEdge" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision.Shapes:b2Shape" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2WorldManifold" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2ManifoldPoint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2Manifold" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2ContactListener" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Transform" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Fixture" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="s" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2ContactID" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      &lt;script name="Box2D/Dynamics/Contacts/b2PolygonContact" mod="1263244042000" signatureChecksum="980008010" &gt;<br>
        &lt;def id="Box2D.Dynamics.Contacts:b2PolygonContact" /&gt; <br>
        &lt;dep id="Box2D.Collision.Shapes:b2PolygonShape" type="e" /&gt; <br>
        &lt;dep id="Box2D.Collision:b2Collision" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Fixture" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Contacts:b2Contact" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      &lt;script name="Box2D/Dynamics/Joints/b2Joint" mod="1263057934000" signatureChecksum="1121016882" &gt;<br>
        &lt;def id="Box2D.Dynamics.Joints:b2Joint" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2PulleyJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2RevoluteJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2FrictionJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2PulleyJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2DistanceJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2FrictionJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2JointEdge" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common:b2Settings" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2PrismaticJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2MouseJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2LineJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2RevoluteJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2PrismaticJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2MouseJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2WeldJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2GearJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2WeldJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2GearJointDef" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2LineJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2DistanceJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2JointDef" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2TimeStep" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2JointEdge" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      &lt;script name="Box2D/Dynamics/Joints/b2GearJoint" mod="1263054058000" signatureChecksum="2379098960" &gt;<br>
        &lt;def id="Box2D.Dynamics.Joints:b2GearJoint" /&gt; <br>
        &lt;dep id="Box2D.Common:b2Settings" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2RevoluteJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2PrismaticJoint" type="e" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2Jacobian" type="e" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2RevoluteJoint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2PrismaticJoint" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Vec2" type="s" /&gt; <br>
        &lt;dep id="Box2D.Common.Math:b2Mat22" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2Jacobian" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2GearJointDef" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2Body" type="s" /&gt; <br>
        &lt;dep id="Box2D.Dynamics:b2TimeStep" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Box2D.Dynamics.Joints:b2Joint" type="i" /&gt; <br>
      &lt;/script&gt;<br>
      ...<br>
    &lt;/library&gt;<br>
  &lt;/libraries&gt;<br>
  &lt;files&gt;<br>
  &lt;/files&gt;<br>
&lt;/swc&gt;<br>
</code></pre>

Here the behaviour of COMPC is to generate a <code>&lt;script&gt;</code> tag for each classes,<br>
humm this could be annoying.<br>
<br>
Let's extract the <code>*.abc</code> file from <code>library.swf</code>
<pre><code>$ ./abcdump -a library.swf<br>
</code></pre>

and here we obtain<br>
<pre><code>library.abc<br>
library1.abc<br>
library2.abc<br>
library3.abc<br>
library4.abc<br>
...<br>
library108.abc<br>
</code></pre>

WTF ? 109 <code>*.abc</code> files ???<br>
<br>
humm, let's inspect the SWF file<br>
<pre><code>$ ./swfinfo -p library.swf<br>
</code></pre>

we obtain<br>
<pre><code>[ SWC10 rect=(x=0, y=0, w=500, h=375), fps=24, frames=1, size=145.73 KB (unzipped=322.35 KB)<br>
  tag 0x45: FileAttributes | size: 4 B | ratio: 0.001%<br>
      |__   Use Direct Blit: false<br>
            Use GPU: false<br>
            Has Metadata: true<br>
            ActionScript 3: true<br>
            Use Network: true<br>
  tag 0x4d: Metadata | size: 459 B | ratio: 0.139%<br>
      |__   &lt;rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'&gt;<br>
            &lt;rdf:Description rdf:about='' xmlns:dc='http://purl.org/dc/elements/1.1'&gt;<br>
            &lt;dc:format&gt;application/x-shockwave-flash&lt;/dc:format&gt;<br>
            &lt;dc:title&gt;Adobe Flex 3 Application&lt;/dc:title&gt;<br>
            &lt;dc:description&gt;http://www.adobe.com/products/flex&lt;/dc:description&gt;<br>
            &lt;dc:publisher&gt;unknown&lt;/dc:publisher&gt;<br>
            &lt;dc:creator&gt;unknown&lt;/dc:creator&gt;<br>
            &lt;dc:language&gt;EN&lt;/dc:language&gt;<br>
            &lt;dc:date&gt;May 29, 2011&lt;/dc:date&gt;<br>
            &lt;/rdf:Description&gt;<br>
            &lt;/rdf:RDF&gt;<br>
  tag 0x40: EnableDebugger2 | size: 31 B | ratio: 0.009%<br>
  tag 0x3f: DebugID | size: 16 B | ratio: 0.005%<br>
  tag 0x41: ScriptLimits | size: 4 B | ratio: 0.001%<br>
      |__   max recursion: 1000<br>
            script timeout: 60<br>
  tag 0x09: SetBackgroundColor | size: 3 B | ratio: 0.001%<br>
      |__   hex: 0x869ca7<br>
            r=134, g=156, b=167<br>
  tag 0x29: ProductInfo | size: 26 B | ratio: 0.008%<br>
      |__   productId: 3 (Adobe Flex)<br>
            edition: 6 (None)<br>
            version: Flex SDK v3.4.0.5348<br>
            compile Date: Sun May 29 09:26:55 GMT+0100 2011<br>
  tag 0x52: DoABC2 | size: 3.32 KB | ratio: 1.031%<br>
  tag 0x52: DoABC2 | size: 2.86 KB | ratio: 0.888%<br>
  tag 0x52: DoABC2 | size: 10.34 KB | ratio: 3.207%<br>
  tag 0x52: DoABC2 | size: 5.32 KB | ratio: 1.651%<br>
  tag 0x52: DoABC2 | size: 1.37 KB | ratio: 0.424%<br>
  tag 0x52: DoABC2 | size: 4.75 KB | ratio: 1.472%<br>
  tag 0x52: DoABC2 | size: 5.25 KB | ratio: 1.628%<br>
  tag 0x52: DoABC2 | size: 2.60 KB | ratio: 0.805%<br>
  tag 0x52: DoABC2 | size: 11.70 KB | ratio: 3.630%<br>
  tag 0x52: DoABC2 | size: 807 B | ratio: 0.244%<br>
  tag 0x52: DoABC2 | size: 793 B | ratio: 0.240%<br>
  tag 0x52: DoABC2 | size: 850 B | ratio: 0.258%<br>
  tag 0x52: DoABC2 | size: 3.08 KB | ratio: 0.955%<br>
  tag 0x52: DoABC2 | size: 678 B | ratio: 0.205%<br>
  tag 0x52: DoABC2 | size: 1.11 KB | ratio: 0.344%<br>
  tag 0x52: DoABC2 | size: 2.10 KB | ratio: 0.651%<br>
  tag 0x52: DoABC2 | size: 1.75 KB | ratio: 0.543%<br>
  tag 0x52: DoABC2 | size: 8.87 KB | ratio: 2.752%<br>
  tag 0x52: DoABC2 | size: 695 B | ratio: 0.211%<br>
  tag 0x52: DoABC2 | size: 1.79 KB | ratio: 0.556%<br>
  tag 0x52: DoABC2 | size: 3.92 KB | ratio: 1.216%<br>
  tag 0x52: DoABC2 | size: 1.46 KB | ratio: 0.453%<br>
  tag 0x52: DoABC2 | size: 2.66 KB | ratio: 0.825%<br>
  tag 0x52: DoABC2 | size: 2.98 KB | ratio: 0.924%<br>
  tag 0x52: DoABC2 | size: 1.54 KB | ratio: 0.478%<br>
  tag 0x52: DoABC2 | size: 749 B | ratio: 0.227%<br>
  tag 0x52: DoABC2 | size: 648 B | ratio: 0.196%<br>
  tag 0x52: DoABC2 | size: 11.51 KB | ratio: 3.572%<br>
  tag 0x52: DoABC2 | size: 888 B | ratio: 0.269%<br>
  tag 0x52: DoABC2 | size: 1004 B | ratio: 0.304%<br>
  tag 0x52: DoABC2 | size: 1.14 KB | ratio: 0.353%<br>
  tag 0x52: DoABC2 | size: 945 B | ratio: 0.286%<br>
  tag 0x52: DoABC2 | size: 583 B | ratio: 0.177%<br>
  tag 0x52: DoABC2 | size: 2.21 KB | ratio: 0.687%<br>
  tag 0x52: DoABC2 | size: 4.88 KB | ratio: 1.515%<br>
  tag 0x52: DoABC2 | size: 6.15 KB | ratio: 1.908%<br>
  tag 0x52: DoABC2 | size: 1.22 KB | ratio: 0.378%<br>
  tag 0x52: DoABC2 | size: 1.69 KB | ratio: 0.526%<br>
  tag 0x52: DoABC2 | size: 742 B | ratio: 0.225%<br>
  tag 0x52: DoABC2 | size: 1.56 KB | ratio: 0.483%<br>
  tag 0x52: DoABC2 | size: 602 B | ratio: 0.182%<br>
  tag 0x52: DoABC2 | size: 20.45 KB | ratio: 6.344%<br>
  tag 0x52: DoABC2 | size: 712 B | ratio: 0.216%<br>
  tag 0x52: DoABC2 | size: 1.54 KB | ratio: 0.478%<br>
  tag 0x52: DoABC2 | size: 3.10 KB | ratio: 0.963%<br>
  tag 0x52: DoABC2 | size: 1.07 KB | ratio: 0.331%<br>
  tag 0x52: DoABC2 | size: 3.65 KB | ratio: 1.132%<br>
  tag 0x52: DoABC2 | size: 858 B | ratio: 0.260%<br>
  tag 0x52: DoABC2 | size: 10.68 KB | ratio: 3.314%<br>
  tag 0x52: DoABC2 | size: 5.15 KB | ratio: 1.598%<br>
  tag 0x52: DoABC2 | size: 1.35 KB | ratio: 0.420%<br>
  tag 0x52: DoABC2 | size: 836 B | ratio: 0.253%<br>
  tag 0x52: DoABC2 | size: 10.90 KB | ratio: 3.381%<br>
  tag 0x52: DoABC2 | size: 1.65 KB | ratio: 0.513%<br>
  tag 0x52: DoABC2 | size: 1.59 KB | ratio: 0.493%<br>
  tag 0x52: DoABC2 | size: 13.08 KB | ratio: 4.058%<br>
  tag 0x52: DoABC2 | size: 702 B | ratio: 0.213%<br>
  tag 0x52: DoABC2 | size: 5.72 KB | ratio: 1.774%<br>
  tag 0x52: DoABC2 | size: 644 B | ratio: 0.195%<br>
  tag 0x52: DoABC2 | size: 1.37 KB | ratio: 0.425%<br>
  tag 0x52: DoABC2 | size: 2.17 KB | ratio: 0.674%<br>
  tag 0x52: DoABC2 | size: 4.89 KB | ratio: 1.517%<br>
  tag 0x52: DoABC2 | size: 2.40 KB | ratio: 0.744%<br>
  tag 0x52: DoABC2 | size: 702 B | ratio: 0.213%<br>
  tag 0x52: DoABC2 | size: 1.11 KB | ratio: 0.344%<br>
  tag 0x52: DoABC2 | size: 679 B | ratio: 0.206%<br>
  tag 0x52: DoABC2 | size: 213 B | ratio: 0.065%<br>
  tag 0x52: DoABC2 | size: 2.42 KB | ratio: 0.750%<br>
  tag 0x52: DoABC2 | size: 727 B | ratio: 0.220%<br>
  tag 0x52: DoABC2 | size: 1.44 KB | ratio: 0.448%<br>
  tag 0x52: DoABC2 | size: 4.96 KB | ratio: 1.538%<br>
  tag 0x52: DoABC2 | size: 1.34 KB | ratio: 0.417%<br>
  tag 0x52: DoABC2 | size: 794 B | ratio: 0.241%<br>
  tag 0x52: DoABC2 | size: 711 B | ratio: 0.215%<br>
  tag 0x52: DoABC2 | size: 1008 B | ratio: 0.305%<br>
  tag 0x52: DoABC2 | size: 1.17 KB | ratio: 0.363%<br>
  tag 0x52: DoABC2 | size: 4.80 KB | ratio: 1.489%<br>
  tag 0x52: DoABC2 | size: 887 B | ratio: 0.269%<br>
  tag 0x52: DoABC2 | size: 1.09 KB | ratio: 0.340%<br>
  tag 0x52: DoABC2 | size: 765 B | ratio: 0.232%<br>
  tag 0x52: DoABC2 | size: 4.79 KB | ratio: 1.485%<br>
  tag 0x52: DoABC2 | size: 960 B | ratio: 0.291%<br>
  tag 0x52: DoABC2 | size: 5.06 KB | ratio: 1.569%<br>
  tag 0x52: DoABC2 | size: 883 B | ratio: 0.268%<br>
  tag 0x52: DoABC2 | size: 2.81 KB | ratio: 0.870%<br>
  tag 0x52: DoABC2 | size: 2.07 KB | ratio: 0.643%<br>
  tag 0x52: DoABC2 | size: 5.26 KB | ratio: 1.632%<br>
  tag 0x52: DoABC2 | size: 781 B | ratio: 0.237%<br>
  tag 0x52: DoABC2 | size: 764 B | ratio: 0.231%<br>
  tag 0x52: DoABC2 | size: 1.08 KB | ratio: 0.334%<br>
  tag 0x52: DoABC2 | size: 1.12 KB | ratio: 0.346%<br>
  tag 0x52: DoABC2 | size: 775 B | ratio: 0.235%<br>
  tag 0x52: DoABC2 | size: 2.57 KB | ratio: 0.797%<br>
  tag 0x52: DoABC2 | size: 570 B | ratio: 0.173%<br>
  tag 0x52: DoABC2 | size: 4.72 KB | ratio: 1.465%<br>
  tag 0x52: DoABC2 | size: 9.97 KB | ratio: 3.094%<br>
  tag 0x52: DoABC2 | size: 1.55 KB | ratio: 0.480%<br>
  tag 0x52: DoABC2 | size: 1.77 KB | ratio: 0.548%<br>
  tag 0x52: DoABC2 | size: 742 B | ratio: 0.225%<br>
  tag 0x52: DoABC2 | size: 2.64 KB | ratio: 0.818%<br>
  tag 0x52: DoABC2 | size: 667 B | ratio: 0.202%<br>
  tag 0x52: DoABC2 | size: 1.08 KB | ratio: 0.334%<br>
  tag 0x52: DoABC2 | size: 1.27 KB | ratio: 0.394%<br>
  tag 0x52: DoABC2 | size: 1.12 KB | ratio: 0.347%<br>
  tag 0x52: DoABC2 | size: 2.74 KB | ratio: 0.851%<br>
  tag 0x52: DoABC2 | size: 1.66 KB | ratio: 0.514%<br>
  tag 0x52: DoABC2 | size: 6.26 KB | ratio: 1.942%<br>
  tag 0x52: DoABC2 | size: 1.58 KB | ratio: 0.490%<br>
  tag 0x52: DoABC2 | size: 16.06 KB | ratio: 4.984%<br>
  tag 0x01: ShowFrame | size: 0 B | ratio: 0.000%<br>
  tag 0x00: End | size: 0 B | ratio: 0.000%<br>
 ]<br>
</code></pre>

here what happened<br>
<ul><li>for each classes COMPC generated a <code>&lt;script&gt;</code> tag<br>
</li><li>for each <code>&lt;script&gt;</code> tag the SWF file create a <code>DoABC2</code> tag<br>
</li><li>for each <code>DoABC2</code> we get an <code>*.abc</code> file</li></ul>

Ok, the cool thing is we did not have to generate all the includes by hand<br>
but the extremely bad thing is now if we want to reuse that to compile with ASC<br>
our command line will look like that<br>
<pre><code>$ ./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import library.abc -import library1.abc -import library2.abc ... program.as<br>
</code></pre>

Ok, great so instead of <code>include Source/Box2D/SomeClass.as</code><br>
we moved the problem to <code>-import libraryXYZ.abc</code>, and it get worst<br>
as we have no idea in which orders the abc need to be declared and we probably<br>
gonna end up with some forward reference errors.<br>
<br>
Here the first advice<br>
<table><thead><th> <b>You want to create your includes by hand</b> </th></thead><tbody></tbody></table>

wether you are dealing with a program<br>
for ex: <a href='http://code.google.com/p/maashaack/source/browse/tools/swfinfo/trunk/src/swfinfo.as'>swfinfo</a>

or a library<br>
<br>
you want an <code>*.as</code> file that is here only to deal with the includes of other <code>*.as</code> files<br>
<br>
<b>WHY ?</b>
<ul><li>that's the only way to tell COMPC or other compilers to put everything in 1 abc file (or 1 <code>&lt;script&gt;</code> tag)<br>
</li><li>that's the only way to organize the order of those includes to avoid forward reference errors</li></ul>

<br>
<br>

Let's try another build to see if we can achieve that<br>
<br>
but first we want to generate those includes automatically<br>
(yeah because doing that by hand for 100s of classes is painfull)<br>
<br>
<b>generate.xml</b>
<pre><code>&lt;?xml version="1.0" encoding="UTF-8"?&gt;<br>
<br>
&lt;project name="foobar" default="main" basedir="."&gt;<br>
<br>
    &lt;target name="main"&gt;<br>
        &lt;fileset id="files" dir="Source" includes="**/*.as" /&gt;<br>
        &lt;pathconvert property="includes" pathsep='";${line.separator}include "' refid="files"&gt;<br>
            &lt;chainedmapper&gt;<br>
                &lt;globmapper from="${basedir}/Source/*" to="Source/*"/&gt;<br>
            &lt;/chainedmapper&gt;<br>
        &lt;/pathconvert&gt;<br>
        <br>
        &lt;concat destfile="includes.as"&gt;include "${includes}";${line.separator}&lt;/concat&gt;<br>
    &lt;/target&gt;<br>
<br>
&lt;/project&gt;<br>
</code></pre>

see why I like Ant  :) ?<br>
<br>
just run<br>
<pre><code>$ ant -f generate.xml<br>
</code></pre>

and it will generate this file<br>
<b>includes.as</b>
<pre><code>include "Source/Box2D/Collision/ClipVertex.as";<br>
include "Source/Box2D/Collision/Features.as";<br>
include "Source/Box2D/Collision/IBroadPhase.as";<br>
include "Source/Box2D/Collision/Shapes/b2CircleShape.as";<br>
include "Source/Box2D/Collision/Shapes/b2EdgeChainDef.as";<br>
include "Source/Box2D/Collision/Shapes/b2EdgeShape.as";<br>
include "Source/Box2D/Collision/Shapes/b2MassData.as";<br>
include "Source/Box2D/Collision/Shapes/b2PolygonShape.as";<br>
include "Source/Box2D/Collision/Shapes/b2Shape.as";<br>
include "Source/Box2D/Collision/b2AABB.as";<br>
include "Source/Box2D/Collision/b2Bound.as";<br>
include "Source/Box2D/Collision/b2BoundValues.as";<br>
include "Source/Box2D/Collision/b2BroadPhase.as";<br>
include "Source/Box2D/Collision/b2Collision.as";<br>
...<br>
</code></pre>

let slightly modify the build now<br>
<br>
<b>build.xml</b> test2<br>
<pre><code>&lt;?xml version="1.0" encoding="UTF-8"?&gt;<br>
<br>
&lt;project name="foobar" default="main" basedir="."&gt;<br>
<br>
    &lt;target name="clean"&gt;<br>
        &lt;delete dir="bin-component"/&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="define-constants"&gt;<br>
        &lt;property name="FLEX_HOME" value="/OpenSource/Flex/sdks/3.4.0" /&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="before" depends="define-constants,define-tasks"&gt;<br>
        &lt;mkdir dir="bin-component"/&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="define-tasks"&gt;<br>
        &lt;taskdef resource="flexTasks.tasks" classpath="${FLEX_HOME}/ant/lib/flexTasks.jar" /&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="main" depends="clean,before,build,after"&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="after"&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="build" depends="build-box2d-swc"&gt;<br>
    &lt;/target&gt;<br>
<br>
    &lt;target name="build-box2d-swc"&gt;<br>
<br>
        &lt;compc<br>
            output="bin-component/test.swc"<br>
            target-player="10.0"<br>
        &gt;<br>
            &lt;strict&gt;true&lt;/strict&gt;<br>
            &lt;optimize&gt;true&lt;/optimize&gt;<br>
            &lt;warnings&gt;true&lt;/warnings&gt;<br>
            &lt;verbose-stacktraces&gt;true&lt;/verbose-stacktraces&gt;<br>
            &lt;compute-digest&gt;false&lt;/compute-digest&gt;<br>
<br>
            &lt;source-path path-element="${basedir}/Source" /&gt;<br>
            &lt;include-sources dir="${basedir}" includes="includes.as" /&gt;<br>
        &lt;/compc&gt;<br>
        <br>
    &lt;/target&gt;<br>
&lt;/project&gt;<br>
</code></pre>

the difference is small but important<br>
<pre><code>&lt;include-sources dir="${basedir}" includes="includes.as" /&gt;<br>
</code></pre>

We tell COMPC to include only 1 file<br>
<br>
ok let's run it<br>
<pre><code>$ ant<br>
</code></pre>

and we obtain errors<br>
<pre><code>Buildfile: /Box2DFlashAS3 2.1a/build.xml<br>
<br>
clean:<br>
   [delete] Deleting directory /Box2DFlashAS3 2.1a/bin-component<br>
<br>
define-constants:<br>
<br>
define-tasks:<br>
<br>
before:<br>
    [mkdir] Created dir: /Box2DFlashAS3 2.1a/bin-component<br>
<br>
build-box2d-swc:<br>
    [compc] Loading configuration file /OpenSource/Flex/sdks/3.4.0/frameworks/flex-config.xml<br>
    [compc] /Box2DFlashAS3 2.1a/Source/Box2D/Dynamics/Joints/b2DistanceJoint.as(49): col: 38 Error: Forward reference to base class b2Joint.<br>
    [compc] <br>
    [compc] public class b2DistanceJoint extends b2Joint<br>
    [compc]                                      ^<br>
    [compc] <br>
    [compc] /Box2DFlashAS3 2.1a/Source/Box2D/Dynamics/Joints/b2FrictionJoint.as(45): col: 38 Error: Forward reference to base class b2Joint.<br>
    [compc] <br>
    [compc] public class b2FrictionJoint extends b2Joint<br>
    [compc]                                      ^<br>
    [compc] <br>
    [compc] /Box2DFlashAS3 2.1a/Source/Box2D/Dynamics/Joints/b2GearJoint.as(46): col: 34 Error: Forward reference to base class b2Joint.<br>
    [compc] <br>
    [compc] public class b2GearJoint extends b2Joint<br>
    [compc]                                  ^<br>
    [compc] <br>
<br>
BUILD FAILED<br>
/Box2DFlashAS3 2.1a/build.xml:48: compc task failed<br>
<br>
Total time: 6 seconds<br>
</code></pre>

By default you'll have much much more errors (here that was one of the last edit before everything was fixed)<br>
so what to do when you face a <code>Error: Forward reference to</code> ?<br>
go edit your <code>includes.as</code> file and just change the order of the include<br>
<br>
from<br>
<pre><code>...<br>
include "Source/Box2D/Dynamics/Joints/b2DistanceJoint.as";  &lt;-- forward reference to 'b2Joint' class<br>
include "Source/Box2D/Dynamics/Joints/b2DistanceJointDef.as";<br>
include "Source/Box2D/Dynamics/Joints/b2FrictionJoint.as";<br>
include "Source/Box2D/Dynamics/Joints/b2FrictionJointDef.as";<br>
include "Source/Box2D/Dynamics/Joints/b2GearJoint.as";<br>
include "Source/Box2D/Dynamics/Joints/b2GearJointDef.as";<br>
include "Source/Box2D/Dynamics/Joints/b2Jacobian.as";<br>
include "Source/Box2D/Dynamics/Joints/b2Joint.as";  &lt;-- problem<br>
...<br>
</code></pre>

to<br>
<pre><code>...<br>
include "Source/Box2D/Dynamics/Joints/b2Joint.as";  &lt;--- moved <br>
include "Source/Box2D/Dynamics/Joints/b2DistanceJoint.as"; &lt;--- no more problem<br>
include "Source/Box2D/Dynamics/Joints/b2DistanceJointDef.as";<br>
include "Source/Box2D/Dynamics/Joints/b2FrictionJoint.as";<br>
include "Source/Box2D/Dynamics/Joints/b2FrictionJointDef.as";<br>
include "Source/Box2D/Dynamics/Joints/b2GearJoint.as";<br>
include "Source/Box2D/Dynamics/Joints/b2GearJointDef.as";<br>
include "Source/Box2D/Dynamics/Joints/b2Jacobian.as";<br>
...<br>
</code></pre>

It will take few tests, but at the end everything will compile fine<br>
<pre><code>Buildfile: /Box2DFlashAS3 2.1a/build.xml<br>
<br>
clean:<br>
   [delete] Deleting directory /Box2DFlashAS3 2.1a/bin-component<br>
<br>
define-constants:<br>
<br>
define-tasks:<br>
<br>
before:<br>
    [mkdir] Created dir: /Box2DFlashAS3 2.1a/bin-component<br>
<br>
build-box2d-swc:<br>
    [compc] Loading configuration file /OpenSource/Flex/sdks/3.4.0/frameworks/flex-config.xml<br>
    [compc] /Box2DFlashAS3 2.1a/bin-component/test.swc (114137 bytes)<br>
<br>
build:<br>
<br>
after:<br>
<br>
main:<br>
<br>
BUILD SUCCESSFUL<br>
Total time: 5 seconds<br>
</code></pre>

let's look into the <code>catalog.xml</code> again<br>
<pre><code>&lt;?xml version="1.0" encoding ="utf-8"?&gt;<br>
&lt;swc xmlns="http://www.adobe.com/flash/swccatalog/9"&gt;<br>
  &lt;versions&gt;<br>
    &lt;swc version="1.2" /&gt;<br>
    &lt;flex version="3.4.0" build="5348" /&gt;<br>
  &lt;/versions&gt;<br>
  &lt;features&gt;<br>
    &lt;feature-script-deps /&gt;<br>
    &lt;feature-files /&gt;<br>
  &lt;/features&gt;<br>
  &lt;libraries&gt;<br>
    &lt;library path="library.swf"&gt;<br>
      &lt;script name="Box2D/Collision/ClipVertex" mod="1306659030000" signatureChecksum="267677397" &gt;<br>
        &lt;def id="Box2D.Collision:ClipVertex" /&gt; <br>
        &lt;def id="Box2D.Collision:Features" /&gt; <br>
        &lt;def id="Box2D.Collision:IBroadPhase" /&gt; <br>
        &lt;def id="Box2D.Collision:b2AABB" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Bound" /&gt; <br>
        &lt;def id="Box2D.Collision:b2BoundValues" /&gt; <br>
        &lt;def id="Box2D.Collision:b2BroadPhase" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Collision" /&gt; <br>
        &lt;def id="Box2D.Collision:b2ContactID" /&gt; <br>
        &lt;def id="Box2D.Collision:b2ContactPoint" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Distance" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DistanceInput" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DistanceOutput" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DistanceProxy" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DynamicTree" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DynamicTreeBroadPhase" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DynamicTreeNode" /&gt; <br>
        &lt;def id="Box2D.Collision:b2DynamicTreePair" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Manifold" /&gt; <br>
        &lt;def id="Box2D.Collision:b2ManifoldPoint" /&gt; <br>
        &lt;def id="Box2D.Collision:b2OBB" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Pair" /&gt; <br>
        &lt;def id="Box2D.Collision:b2PairManager" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Point" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Proxy" /&gt; <br>
        &lt;def id="Box2D.Collision:b2RayCastInput" /&gt; <br>
        &lt;def id="Box2D.Collision:b2RayCastOutput" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Segment" /&gt; <br>
        &lt;def id="Box2D.Collision:b2SeparationFunction" /&gt; <br>
        &lt;def id="Box2D.Collision:b2Simplex" /&gt; <br>
        &lt;def id="Box2D.Collision:b2SimplexCache" /&gt; <br>
        &lt;def id="Box2D.Collision:b2SimplexVertex" /&gt; <br>
        &lt;def id="Box2D.Collision:b2TOIInput" /&gt; <br>
        &lt;def id="Box2D.Collision:b2TimeOfImpact" /&gt; <br>
        &lt;def id="Box2D.Collision:b2WorldManifold" /&gt; <br>
        &lt;def id="Box2D.Collision.Shapes:b2Shape" /&gt; <br>
        &lt;def id="Box2D.Collision.Shapes:b2CircleShape" /&gt; <br>
        &lt;def id="Box2D.Collision.Shapes:b2EdgeChainDef" /&gt; <br>
        &lt;def id="Box2D.Collision.Shapes:b2EdgeShape" /&gt; <br>
        &lt;def id="Box2D.Collision.Shapes:b2MassData" /&gt; <br>
        &lt;def id="Box2D.Collision.Shapes:b2PolygonShape" /&gt; <br>
        &lt;def id="Box2D.Common:b2Color" /&gt; <br>
        &lt;def id="Box2D.Common:b2Settings" /&gt; <br>
        &lt;def id="Box2D.Common:b2internal" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Mat22" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Mat33" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Math" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Sweep" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Transform" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Vec2" /&gt; <br>
        &lt;def id="Box2D.Common.Math:b2Vec3" /&gt; <br>
        ...<br>
        &lt;dep id="Math" type="e" /&gt; <br>
        &lt;dep id="flash.utils:Dictionary" type="e" /&gt; <br>
        &lt;dep id="Error" type="e" /&gt; <br>
        &lt;dep id="flash.utils:Dictionary" type="s" /&gt; <br>
        &lt;dep id="flash.display:Sprite" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
      &lt;/script&gt;<br>
    &lt;/library&gt;<br>
  &lt;/libraries&gt;<br>
  &lt;files&gt;<br>
  &lt;/files&gt;<br>
&lt;/swc&gt;<br>
</code></pre>

That's look good as now we have only one <code>&lt;script&gt;</code> tag that contains numerous <code>&lt;dep&gt;</code> tags.<br>
<br>
let's inspect the SWF file again<br>
<pre><code>[ SWC10 rect=(x=0, y=0, w=500, h=375), fps=24, frames=1, size=110.52 KB (unzipped=255.45 KB)<br>
  tag 0x45: FileAttributes | size: 4 B | ratio: 0.002%<br>
      |__   Use Direct Blit: false<br>
            Use GPU: false<br>
            Has Metadata: true<br>
            ActionScript 3: true<br>
            Use Network: true<br>
  tag 0x4d: Metadata | size: 459 B | ratio: 0.175%<br>
      |__   &lt;rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'&gt;<br>
            &lt;rdf:Description rdf:about='' xmlns:dc='http://purl.org/dc/elements/1.1'&gt;<br>
            &lt;dc:format&gt;application/x-shockwave-flash&lt;/dc:format&gt;<br>
            &lt;dc:title&gt;Adobe Flex 3 Application&lt;/dc:title&gt;<br>
            &lt;dc:description&gt;http://www.adobe.com/products/flex&lt;/dc:description&gt;<br>
            &lt;dc:publisher&gt;unknown&lt;/dc:publisher&gt;<br>
            &lt;dc:creator&gt;unknown&lt;/dc:creator&gt;<br>
            &lt;dc:language&gt;EN&lt;/dc:language&gt;<br>
            &lt;dc:date&gt;May 29, 2011&lt;/dc:date&gt;<br>
            &lt;/rdf:Description&gt;<br>
            &lt;/rdf:RDF&gt;<br>
  tag 0x40: EnableDebugger2 | size: 31 B | ratio: 0.012%<br>
  tag 0x3f: DebugID | size: 16 B | ratio: 0.006%<br>
  tag 0x41: ScriptLimits | size: 4 B | ratio: 0.002%<br>
      |__   max recursion: 1000<br>
            script timeout: 60<br>
  tag 0x09: SetBackgroundColor | size: 3 B | ratio: 0.001%<br>
      |__   hex: 0x869ca7<br>
            r=134, g=156, b=167<br>
  tag 0x29: ProductInfo | size: 26 B | ratio: 0.010%<br>
      |__   productId: 3 (Adobe Flex)<br>
            edition: 6 (None)<br>
            version: Flex SDK v3.4.0.5348<br>
            compile Date: Sun May 29 09:50:41 GMT+0100 2011<br>
  tag 0x52: DoABC2 | size: 254.87 KB | ratio: 99.777%<br>
  tag 0x01: ShowFrame | size: 0 B | ratio: 0.000%<br>
  tag 0x00: End | size: 0 B | ratio: 0.000%<br>
 ]<br>
</code></pre>

That's perfect, we see we have only one <code>DoABC2</code> tag<br>
<br>
so now if we try to extract the <code>*.abc</code> files<br>
<pre><code>$ ./abcdump -a library.swf<br>
</code></pre>

we obtain<br>
<pre><code>library.abc<br>
</code></pre>

one big juicy ABC file that contain all the classes,<br>
we just need to rename it to the name of the lib and we have <code>box2d.abc</code>

That now we can simply reuse like that<br>
<pre><code>$ ./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import box2d.abc program.as<br>
</code></pre>

It should work right ?<br>
<br>
well... not necessary<br>
<br>
now ASC will complain about the <code>Sprite</code> class it can not find<br>
and it's where <a href='GettingStartedAvmglue.md'>avmglue</a> come to the rescue.<br>
<br>
If you look again at the <code>catalog.xml</code> file, see those references at the end (look at the <a href='SWC.md'>SWC</a> format)<br>
<pre><code>...<br>
        &lt;dep id="Math" type="e" /&gt; <br>
        &lt;dep id="flash.utils:Dictionary" type="e" /&gt; <br>
        &lt;dep id="Error" type="e" /&gt; <br>
        &lt;dep id="flash.utils:Dictionary" type="s" /&gt; <br>
        &lt;dep id="flash.display:Sprite" type="s" /&gt; <br>
        &lt;dep id="AS3" type="n" /&gt; <br>
        &lt;dep id="Box2D.Common:b2internal" type="n" /&gt; <br>
        &lt;dep id="Object" type="i" /&gt; <br>
...<br>
</code></pre>

the <b>Math</b> class is part of the builtins so no problem here<br>
Tamarin already define <b>flash.utils:Dictionary</b> so again no problem<br>
but nobody define <b>flash.display:Sprite</b> and there you got an error.<br>
<br>
You have 2 ways of solving that<br>
<ul><li>either you define your own Sprite class (as a mock)<br>
</li><li>or you reuse <code>avmglue.abc</code> (which should define a Sprite class)</li></ul>

And remember that the order of definitions is important, it should look like that<br>
<pre><code>$ ./asc -AS3 -strict -import builtin.abc -import toplevel.abc -import avmglue.abc -import box2d.abc program.as<br>
</code></pre>

<br>

Agreed, is not as easy as using Flash but it's close<br>
<br>
<b>redtamarin workflow</b>
<ul><li>I create project in the IDE<br>
</li><li>I need to reuse an AS3 library<br>
<ul><li>I create a build to generate a SWC<br>
</li><li>I extract the ABC from the SWC<br>
</li><li>I reuse this ABC file instead of a SWC</li></ul></li></ul>

At the end the major problem will be with <code>avmglue.abc</code>,<br>
if an AS3 library use a lot of the Flash Player API (or AIR API)<br>
and <b>avmglue</b> does not support them yet, you will have to recreate<br>
those defintions.<br>
<br>
Here for a <code>Sprite</code> class, if we look how box2d use the class<br>
<pre><code>$ cd Source<br>
$ grep -R "Sprite" *<br>
<br>
Box2D/Dynamics/b2DebugDraw.as:import flash.display.Sprite;<br>
Box2D/Dynamics/b2DebugDraw.as:	public function SetSprite(sprite:Sprite) : void {<br>
Box2D/Dynamics/b2DebugDraw.as:	public function GetSprite() : Sprite {<br>
Box2D/Dynamics/b2DebugDraw.as:	b2internal var m_sprite:Sprite;<br>
</code></pre>

we can simply create a simple mock class<br>
<pre><code>package flash.display<br>
{<br>
    public class Sprite<br>
    {<br>
    }<br>
}<br>
</code></pre>
and it will solve the problem<br>
<ul><li>be sure to compile it in its own <code>glue.abc</code> and import it before you import <code>box2d.abc</code>
</li><li>yes no need to implement a real Sprite class, here it is used only as a reference (no need to declare methods etc.)<br>
</li><li>another solution would be to edit the box2d <code>b2DebugDraw</code> class and remove the <code>Sprite</code> reference<br>
</li><li>ideally <code>avmglue.abc</code> should already provide this kind of simple mock class