/* -*- mode: java -*- */
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is [Open Source Virtual Machine.].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2009
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Adobe AS3 Team
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

/* Utility to stitch ABC files together into a single swf.
 *
 * Usage:
 *
 *   swfmake [-c] [-o filename] abcfile ...
 *
 *   -o filename    defines the name of the output file
 *
 *   -c             creates a compressed swf
 *
 * By default the name of the output file is the name of the first abc
 * file with ".abc" replaced by ".swf", and the swf file is uncompressed.
 * 
 * If you don't want to list all the abc files, you can pass `*.abc`
 * and the program will grab all the abc files from the current directory.
 */

package swfmake
{
    import avmplus.System;
    import avmplus.FileSystem;
    import flash.utils.ByteArray;

    var input_names = [];
    var output_name = null;
    var compress    = undefined;

    var usage_abc:String = "Usage: avmshell swfmake.abc -- [-h] [-c] [-o filename] abcfile ...";
    var usage_exe:String = "Usage: swfmake [-h] [-c] [-o filename] abcfile ...";

    var help_msg:String = <![CDATA[
Utility to stitch ABC files together into a single swf.

Usage:
  swfmake [-h] [-c] [-o filename] abcfile ...

  -h             display this help

  -o filename    defines the name of the output file

  -c             creates a compressed swf

By default the name of the output file is the name of the first abc
file with ".abc" replaced by ".swf", and the swf file is uncompressed.

If you don't want to list all the abc files, you can pass `*.abc`
and the program will grab all the abc files from the current directory.

Examples:
  $ ./swfmake -c program.abc
  will join the abf file into the compressed SWF program.swf

  $ ./swfmake -o program.swf lib1.abc lib2.abc main.abc
  will join the 3 abc files into the non-compressed SWF file program.swf

  $ ./swfmake -o program.swf *.abc
  will join all the abc files in the current directory into the non-compressed SWF file program.swf
]]>;

    var i=0, j;
    var argc=System.argv.length;
    var argv=System.argv;
    var s;
    
    while( i < argc )
    {
	    s = argv[i];
	    
	    if( s == "-h" )
	    {
	        help();
	    }
	    else if( s == "-o" )
	    {
	        if (output_name != null || i+1 == argc)
	        {
	            usage();
	        }
		
	        output_name = argv[i+1];
	        i += 2;
	    }
	    else if( s == "-c" )
	    {
	        if(compress is Boolean)
	        {
	            usage();
	        }
		    
	        compress = true;
	        i++;
	    }
	    else if( s.charAt(0) == "-" )
	    {
	        help();
	    }
	    else
	    {
	        input_names.push(s);
	        i++;
	    }
    }

    if( !(compress is Boolean) )
    {
        compress = false;
    }

    if( (input_names.length == 1) && (input_names[0] == "*.abc") )
    {
        var list:Array = FileSystem.listFilesWithRegexp( ".", /.*\.abc$/, false );
        input_names = list;
    }
	
    if( input_names.length == 0 )
    {
        usage();
    }
	
    if( output_name == null )
    {
	    s = input_names[0];
	    if (s.match(/\.abc$/))
	    {
	        output_name = s.replace(/\.abc$/, ".swf");
	    }
	    else
	    {
	        output_name = s + ".swf";
	    }
    }

    var body = new ByteArray();
    body.endian = "littleEndian";
    body.writeByte(2 << 3);   // RECT: 2 bits per dim
    body.writeByte(0);        //   and they're all zero
    body.writeShort(0);       // framerate
    body.writeShort(0);       // framecount

    for( i=0 ; i < input_names.length ; i++ )
    {
	    s = input_names[i];
	    var bytes = FileSystem.readByteArray(s); //read the abc file
	    body.writeShort((82 << 6) | 63);  // DoABC, extended length
	    body.writeUnsignedInt(bytes.length + 4 + s.length + 1);
	    body.writeUnsignedInt(0);         // flags
	    for ( j=0 ; j < s.length ; j++ )
	    {
	        body.writeByte(s.charCodeAt(j) & 255);
	    }

	    body.writeByte(0);
	    body.writeBytes(bytes);
    }
    body.writeShort(0);                   // End
    
    var numbytes = body.length + 8;

    if( compress )
    {
        body.compress();
    }
	

    var result = new ByteArray();
    result.endian = "littleEndian";
    result.writeByte((compress ? 'C' : 'F').charCodeAt(0));
    result.writeByte('W'.charCodeAt(0));
    result.writeByte('S'.charCodeAt(0));
    result.writeByte(9);
    result.writeUnsignedInt(numbytes);
    result.writeBytes(body);

    //write the SWF file
    FileSystem.writeByteArray(output_name, result);
    System.exit(0);

    function usage( noexit:Boolean = false )
    {
        if( System.programFilename.indexOf( "swfmake" ) != -1 )
        {
            print( usage_exe );
        }
        else
        {
            print( usage_abc );
        }

	    if( !noexit )
	    {
	        System.exit(1);
	    }
    }

    function help()
    {
        usage( true );
        print( help_msg )
	    System.exit(1);
    }
}
