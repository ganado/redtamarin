## Introduction ##

from [verifier.txt](http://hg.mozilla.org/tamarin-redux/file/d8b78be5b40f/doc/verifier.txt)
```
ABC (originally for Action Block Code) is the language executed by the AVM (ActionScript 
Virtual Machine of Tamarin). The full definition of ABC includes a specification of its 
syntax, static semantics and runtime behavior.
```

from [Adobe dev connection - the ABC format](http://learn.adobe.com/wiki/display/AVM2/4.+The+ActionScript+Byte+Code+(abc)+format)
```
Syntactically complete sections of ActionScript code are processed by a compiler into ActionScript Byte Code
segments. These segments are described by the abcFile structure, which is defined below.
The abcFile structure is the unit of loading and execution used by the AVM2.

The abcFile structure describes the interpretation of a block of 8-bit bytes. Despite the name, the contents
of an abcFile does not need to be read from a file in the file system; it can be generated dynamically by a
run-time compiler or other tools. The use of the word "file" is historical.

The abcFile structure comprises primitive data, structured data, and arrays of primitive and structured data.
The following sections describe all the data formats.

Primitive data include integers and floating-point numbers encoded in various ways.

Structured data, including the abcFile itself, are presented here using a C-like structural notation,
with individual named fields. Fields within this structure are in reality just sequences of bytes that are
interpreted according to their type. The fields are stored sequentially without any padding or alignment.
```


## Ressources ##

**links:**
  * [ABC bytecode documentation](http://hg.mozilla.org/tamarin-redux/raw-file/tip/doc/bytecode/html/index.html)
  * [abcsx](http://github.com/propella/abcsx) ActionScript Byte Code assembler/disassembler in PLT Scheme and Gauche.
  * [as3abc](http://github.com/claus/as3abc) Low level Actionscript 3 library to parse, create, modify and publish ABC files.
  * [scheme-abc](http://github.com/mzp/scheme-abc) Scheme compiler for ActionScript3 Bytecode/Flash
  * [Shibuya.abc](http://wiki.libspark.org/wiki/Shibuya.abc_1) (custom avmshell to serve `*.abc` files server side)

**documents:**
  * (PDF) [Optimizing ActionScript Bytecode using LLVM](http://llvm.org/devmtg/2009-10/Petersen_OptimizingActionScriptBytecode.pdf) by Scott Petersen (Adobe)
  * (PDF) [Steal this Code - Decompiling SWFs for fun and profit](http://dougmccune.com/flex/FOTB_Decompiling_Doug_McCune.pdf) by [Doug McCune](http://dougmccune.com/blog/)
  * (PDF) [An Assembler for AVM2 using S-Expression](http://www.vpri.org/pdf/m2009010_for_avm2.pdf) by [Takashi Yamamiya](http://propella.blogspot.com/)
  * (PDF) [Shibuya.abc presentation](http://www.be-interactive.org/works/Shibuya.abc-1/Shibuya.abc-1.pdf) by [Shindo Yoshihiro](http://www.be-interactive.org/index.php?itemid=343)