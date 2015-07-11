### Introduction ###

Tamarin is an open source virtual machine with just-in-time compilation (JIT) support intended to implement the fourth edition of the ECMAScript standard.

Tamarin was developed by Adobe for its ActionScript Virtual Machine (AVM2) used in Flash 9 and up, and later open sourced in 2006.

<pre>
The goal of the "Tamarin" project is to implement a high-performance,<br>
open source implementation of the !ActionScript™ 3 language,<br>
which is based upon and extends ECMAScript 3rd edition (ES3).<br>
<br>
ActionScript provides many extensions to the ECMAScript language,<br>
including packages, namespaces, classes, and optional strict typing of variables.<br>
"Tamarin" implements both a high-performance just-in-time compiler and interpreter.<br>
<br>
The Tamarin virtual machine is used within the Adobe® Flash® Player<br>
and is also being adopted for use by projects outside Adobe.<br>
<br>
The Tamarin just-in-time compiler (the "NanoJIT") is a collaboratively developed component<br>
used by both Tamarin and Mozilla TraceMonkey.<br>
The !ActionScript compiler is available as a component from the open source Flex SDK<br>
</pre>


Without Tamarin, redtamarin would not exists, so kudos to Adobe to have open sourced this fantastic project.

also from the [AVM2 wiki](http://learn.adobe.com/wiki/display/AVM2/1.1+Concepts)
<pre>
The AVM2 was designed to support the ActionScript (AS) 3.0 language,<br>
and for the remaining chapters it is assumed that the reader is aware of the terminology<br>
and concepts of the language.<br>
<br>
The following vocabulary and associated definitions are taken from the ActionScript 3.0 Language Specification<br>
and are presented only as a review of the material.<br>
For full details, refer to the language specification.<br>
<br>
Virtual Machine<br>
A virtual machine is a mechanism that takes as its input the description of a computation<br>
and that performs that computation. For the AVM2, the input is in the form of an ABC file,<br>
which contains compiled programs; these comprise constant data, instructions from the<br>
AVM2 instruction set, and various kinds of metadata.<br>
<br>
Script<br>
A script set of traits and an initializer method; a script populates a top-level<br>
environment with definitions and data.<br>
<br>
Bytecode, code<br>
Bytecode or code is a specification of computation in the form of a sequence of simple actions<br>
on the virtual machine state.<br>
<br>
Scope<br>
Scope is a mapping from names to locations, where no two names are the same.<br>
Scopes can nest, and nested scopes can contain bindings (associations between names and locations)<br>
that shadow the bindings of the nesting scope.<br>
<br>
Object<br>
An object is an unordered collection of named properties, which are containers that hold values.<br>
A value in ActionScript 3.0 is either an Object reference or one of the special values null or undefined.<br>
Namespace - Namespaces are used to control the visibility of a set of properties independent of the<br>
major structure of the program.<br>
<br>
Class<br>
A class is a named description of a group of objects. Objects are created from classes by instantiation.<br>
Inheritance - New classes can be derived from older classes by the mechanism known as inheritance<br>
or subclassing. The new class is called the derived class or subclass of the old class, and the old class<br>
is called the base class or superclass.<br>
<br>
Trait<br>
A trait is a fixed-name property shared by all objects that are instances of the same class;<br>
a set of traits expresses the type of an object.<br>
<br>
Method<br>
The word method is used with two separate meanings. One meaning is a method body, which is an<br>
object that contains code as well as data that belong to that code or that describe the code.<br>
The other meaning is a method closure, which is a method body together with a reference to the<br>
environment in which the closure was created.<br>
In this document, functions, constructors, ActionScript 3.0 class methods, and other objects that<br>
can be invoked are collectively referred to as method closures.<br>
<br>
Verification<br>
The contents of an ABC file undergo verification when the file is loaded into the AVM2.<br>
The ABC file is rejected by the verifier if it does not conform to the AVM2 Overview.<br>
Verification is described in 3. Loading, linking, verification, and execution.<br>
<br>
Just-in-Time (JIT) Compiler<br>
AVM2 implementations may contain an optional run-time compiler for transforming AVM2 instructions<br>
into processor-specific instructions. Although not an implementation requirement, employing a JIT<br>
compiler provides a performance benefit for many applications.<br>
</pre>

### Ressources ###

**links:**
  * [The Tamarin project](http://www.mozilla.org/projects/tamarin/) (Mozilla)
  * [ActionScript Virtual Machine 2 wiki](http://learn.adobe.com/wiki/display/AVM2/ActionScript+Virtual+Machine+2) (Adobe)
  * [mod-actionscript](http://code.google.com/p/mod-actionscript/) Apache module for running server-side ActionScript 3
  * [Tamarin software](http://en.wikipedia.org/wiki/Tamarin_(JavaScript_engine)) (Wikipedia)
  * [Comparison of application virtual machines](http://en.wikipedia.org/wiki/Comparison_of_application_virtual_machines) (Wikipedia)

**documents:**
  * (PDF) [Adobe Flash Player ActionScript Virtual Machine (Tamarin)](http://www.stanford.edu/class/ee380/Abstracts/061206-CPUBLISH_avm_tamrin_stanford_Dec6.pdf) by Rick Reitmaier (Adobe) ([video on YouTube](http://www.youtube.com/watch?v=lMSdoBqdeng))
  * (PDF) [AVM2 Overview](http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf) ([errata](https://wiki.mozilla.org/Tamarin::AVM2_Overview_Errata)) ([japanese translation](http://wiki.libspark.org/wiki/AVM2/Overview))
  * (PDF) [ActionScript 3.0 and AVM2: Performance Tuning](http://www.onflex.org/ACDS/AS3TuningInsideAVM2JIT.pdf) by Gary Grossman (Adobe)
  * (PDF) [AVM2 wiki export](http://learn.adobe.com/wiki/spaces/exportspace.action?key=AVM2) (Adobe)