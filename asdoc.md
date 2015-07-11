## Introduction ##

You can see some general info for [asdoc](https://code.google.com/p/maashaack/wiki/asdoc) on the maashaack wiki.

In our case, we need to heavily customise **asdoc** and technically "hack it" ;).


## Details ##

our main ant task<br />
`build/targets/documentation.xml`
```
		<asdoc output="${app.release}/documentation"
			templates-path="${basedir}/build/doc/templates/"
			warnings="false"
			strict="false"
			keep-xml="false"
			skip-xsl="false"
			restore-builtin-classes="true"
			failonerror="true"
			fork="true"
		>
			<load-config>${basedir}/build/doc/flex-config.xml</load-config>
			<define name="CONFIG::debug" value="false"/>
			<define name="CONFIG::release" value="true"/>
			<define name="CONFIG::VMCFG_FLOAT" value="false" />
```


**restore-builtin-classes** allow us to restore the documentation for the builtins like **Object**, **Array**, etc.

another trick is to use an empy<br />
`build/doc/flex-config.xml`
```
<?xml version="1.0"?>

<flex-config>
    <!-- Specifies absolutely nothing -->
</flex-config>
```

and finally we need to define some namespaces
```
<define name="CONFIG::debug" value="false"/>
<define name="CONFIG::release" value="true"/>
<define name="CONFIG::VMCFG_FLOAT" value="false" />
```

by default we don't want to support **float**, but if you changed that in the compilation you would need to change it too in the documentation.

after that you need to include each element you want to document
```
			<doc-sources path-element="${basedir}/src/core/builtin.as" />
			<doc-sources path-element="${basedir}/src/core/XML.as" />
			<doc-sources path-element="${basedir}/src/core/Math.as" />
			<doc-sources path-element="${basedir}/src/core/Error.as" />
                        etc.
```

Ideally, you would want to keep one definition per file, but asdoc can deal with multiple definitions per file
(very useful in our case for the C library).

another tricks is toward the end you will see
```
<package-description-file>${basedir}/build/doc/package.description.xml</package-description-file>
```

`build/doc/package.description.xml`
```
<overviews>
	<all-packages>
		<description><![CDATA[If you see it here you can use it.]]></description>
	</all-packages>
	<packages>
		<package name="C" >
			<shortDescription><![CDATA[C standard library.]]></shortDescription>
			<description><![CDATA[C standard library.]]></description>
		</package>
		<package name="C.errno" >
			<shortDescription><![CDATA[System error numbers.]]></shortDescription>
			<description><![CDATA[errno.h is a header file in the standard library of C programming language. It defines macros to report error conditions through error codes stored in a static location called errno.]]></description>
		</package>
		<package name="C.assert" >
			<shortDescription><![CDATA[Verify program assertion.]]></shortDescription>
			<description><![CDATA[assert.h is a header file in the standard library of the C programming language that defines the C preprocessor macro assert(). The macro implements an assertion, which can be used to verify assumptions made by the program and print a diagnostic message if this assumption is false.]]></description>
		</package>
		<package name="C.ctype" >
			<shortDescription><![CDATA[Character types.]]></shortDescription>
			<description><![CDATA[C character classification is an operation provided by a group of functions in the ANSI C Standard Library for the C programming language. These functions are used to test characters for membership in a particular class of characters, such as alphabetic characters, control characters, etc. Both single-byte, and wide characters are supported.]]></description>
		</package>
...
```

we use that to document the packages, formating sucks but I guess it's better than nothing.

All the other tricks and hacks happen in `build/doc/templates/`, there are too numerous to list just do a diff with a basic asdoc template.


## Conventions ##

use the tags
```
    /**
     * @langversion 3.0
     * @playerversion AVM 0.4
     */
```

`langversion 3.0` will translate to **Language Version : ActionScript 3.0**<br />
`playerversion AVM 0.4` will translate to **Runtime Versions : RedTamarin 0.4**<br />

Also you will see a little "monkey" icon next to the definition.

The rule is as follow:
  * if API is only for Flash Player, no icons
  * if API is for Flash Player and AIR, no icons
  * if API is only for AIR, use AIR icon
  * if API is only for RedTamarin, use "monkey" icon

## Examples ##

We can put a lot of examples.

`src/as3/C/errno.as`
```
    /**
     * Last error number.
     *
     * <p>
     * A value is stored in <b>errno</b> by certain library functions when they detect errors.
     * </p>
     *
     * <p>
     * At program startup, the value stored is zero. Library functions store only values greater than zero.
     * Any library function can alter the value stored before return, whether or not they detect errors.
     * </p>
     *
     * <p>
     * Most functions indicate that they detected an error by returning a special value,
     * typically <code>NULL</code> for functions that return pointers, and <code>-1</code> for functions that return integers.
     * A few functions require the caller to preset errno to zero and test it afterwards to see if an error was detected.
     * </p>
     *
     * @example basic usage
     * <listing version="3.0">
     *  import C.errno.&#42;;
     *  import C.string.&#42;;
     *  import avmplus.FileSystem;
     *  
     *  var filename:String = "dummy_file";
     *  
     *  if( !FileSystem.exists( filename ) )
     *  {
     *      trace( "errno = " + int(errno) + " - " + errno ); //errno = 2 - No such file or directory
     *  }
     * </listing>
     *
     * @example ActionScript Error usage
     * <listing version="3.0">
     *  import C.errno.&#42;;
     *  import C.string.&#42;;
     *  import avmplus.FileSystem;
     *  
     *  var filename:String = "dummy_file";
     *  
     *  if( !FileSystem.exists( filename ) )
     *  {
     *      var e:CError = new CError( errno );
     *      trace( e ); //ENOENT: No such file or directory
     *  }
     * </listing>
     *
     * 
     * @example read errno
     * <listing version="3.0">
     *  import C.errno.&#42;;
     *  
     *  //let's assume that errno = 2;
     *  
     *  trace( errno ); //wil use the toString() method, output: No such file or directory
     *  
     *  trace( errno.value ); //return the value of errno as a int, output: 2
     *  
     *  trace( int(errno) ); //will cast the valueOf() to int, output: 2
     *  
     *  trace( errno.valueOf() ); //will return the valueOf(), output: 2
     *  
     *  trace( errno.toString() ); //will return the toString(), output: No such file or directory
     * </listing>
     * 
     * @example write errno
     * <listing version="3.0">
     *  import C.errno.&#42;;
     *  
     *  errno.value = 0; //reset errno
     *  
     * </listing>
     *
     * @langversion 3.0
     * @playerversion AVM 0.4
     *
     * @see ErrorNumber
     */
    public const errno:ErrorNumber = new ErrorNumber();
```

<br />
<br />

We can document packages even if asdoc doesn't take them into account.

`src/as3/C/stdio.as`
```
/**
* stdio.h - standard buffered input/output
* 
* @langversion 3.0
* @playerversion AVM 0.4
* 
* @see http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/stdio.h.html
*/
package C.stdio
{

    /**
     * Rename a file.
     *
     * <p>
     * The <code>rename()</code> function shall change the name of a file.
     * </p>
     * 
     * <p>
     * If the <code>rename()</code> function fails for any reason other than <code>EIO</code>,
     * any file named by <code>newname</code> shall be unaffected.
     * </p>
     *
     * @example usage
     * <listing>
     * import C.errno.&#42;;
     * import C.stdio.&#42;;
     * 
     * var result:int = rename( "/test/heelo.txt", "/test/world.txt" );
     * 
     * if( result &lt; 0 )
     * {
     *     trace( new CError( errno ) );
     * }
     * </listing>
     * 
     * @param oldname The pathname of the file to be renamed.
     * @param newname The new pathname of the file.
     * @return Upon successful completion, the <code>rename()</code> function shall return <code>0</code>.
     * Otherwise, it shall return <code>-1</code>, <code>errno</code> shall be set to indicate the error,
     * and neither the file named by <code>oldname</code> nor the file named by <code>newname</code> shall be changed or created.
     * 
     * @throws CError EACCES
     * @throws CError EBUSY
     * @throws CError EEXIST or ENOTEMPTY
     * @throws CError EINVAL
     * @throws CError EIO
     * @throws CError etc.
     *
     * @langversion 3.0
     * @playerversion AVM 0.4
     * 
     * @see http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
     * @see C.errno
     */
    [native("::avmshell::CStdioClass::rename")]
    public native function rename( oldname:String, newname:String ):int;

}
```

We do document the "C Error" that a C function can define in **errno**.