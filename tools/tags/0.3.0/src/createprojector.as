/* -*- c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4 -*- */
/* vi: set ts=4 sw=4 expandtab: (add to ~/.vimrc: set modeline modelines=5) */
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
 * Portions created by the Initial Developer are Copyright (C) 2004-2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail.com>.
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

/* Utility to create a projector.

   Usage:
     createprojector [-exe avmshell] [-o filename] file
     file           a *.swf or *.abc file
     -exe avmshell  the avmshell executable to use
     -o filename    defines the name of the output file
   
   By default the avmshell used is "redshell".
   By default the name of the output file is the name of the input file.
   If the name of the output file conflict with an already existing file or directory
   we append "2" to the name, "file.exe" become "file2.exe" and "file" become "file2".

   TODO:
   - merge swfmake so we can enter more than one abc files (that will merge into a swf file)
   - extract file from projectors (flash projector or tamarin projector)
   - detect OS if only one projector
     eg. under WIN32 use redshell.exe, etc.
   - make the projector executable by default (chmod)
   - generate more than one projectors for cross-platform
     ex: -exe avmshell,avmshell.exe,avmshell.unix -o test
     generate: test, test.exe, test.unix
 */

package createprojector
{
    import avmplus.*;
    import flash.utils.*;
    import C.unistd.*;

    var help:String = <![CDATA[
Utility to create a projector.

Usage:
  createprojector [-exe avmshell] [-o filename] file

Options:
  file           a *.swf or *.abc file

  -exe avmshell  the avmshell executable to use

  -o filename    defines the name of the output file

   By default the avmshell used is "redshell".
   By default the name of the output file is the name of the input file.
   If the name of the output file conflict with an already existing file or directory
   we append "2" to the name, "file.exe" become "file2.exe" and "file" become "file2".

Examples:
  Create a WIN32 projector from a SWF file
  $ ./createprojector -exe redshell.exe program.swf

  Create an OSX projector from an ABC file and named "misc"
  $ ./createprojector -exe redshell -o misc main.abc
]]>;

    var input_name:String   = "";
    var output_name:String  = "";
    var avmshell_exe:String = "";


    var argc:uint  = System.argv.length;
    var argv:Array = System.argv;

    //parse command line
    var i:uint=0;
    var arg:String;
    while (i < argc)
    {
	    arg = argv[i];
	    
	    if( arg == "-o")
	    {
	        if( (output_name != "") || (i+1 == argc) ) { usage(); }
		    
	        output_name = argv[i+1];
	        i += 2;
	    }
	    else if( arg == "-exe" )
	    {
	        if( (avmshell_exe != "") || (i+1 == argc) ) { usage(); }
		    
	        avmshell_exe = argv[i+1];
	        i += 2;
	    }
	    else if( arg.charAt(0) == "-" )
	    {
	        usage();
	    }
	    else
	    {
	        if(input_name != "") { usage(); }
	        
	        input_name = arg;
	        i++;
	    }
    }

    //verify
    if( input_name == "" )
    {
        trace( "no input name provided." );
        usage();
    }
    
    if( !FileSystem.exists( input_name ) )
    {
        trace( "input file \"" + input_name + "\" does not exists." );
        usage();
    }

    if( avmshell_exe == "" )
    {
        if( FileSystem.exists( "redshell" ) )
        {
            avmshell_exe = "redshell";
        }
        else
        {
            trace( "No avmshell provided and \"redshell\" could not be found." )
            usage();
        }
    }
    if( !FileSystem.exists( avmshell_exe ) )
    {
        trace( "avmshell \"" + avmshell_exe + "\" does not exists." );
        usage();
    }

    var newext:String = "";
    if( OperatingSystem.vendor == "Microsoft" )
    {
        newext = ".exe";
    }
    
    if( output_name == "" )
    {
	    var s:String = input_name;
	    if( s.match(/\.abc$/))
	    {
	        output_name = s.replace(/\.abc$/, newext);
	    }
	    else if( s.match(/\.swf$/))
	    {
	        output_name = s.replace(/\.swf$/, newext);
	    }
	    else
	    {
	        output_name = s + ".exe";
	    }
    }

    //do the work
    var bytesWritten:int = 0;
    
    var exe_in:ByteArray = FileSystem.readByteArray( avmshell_exe );

    var file_in:ByteArray = FileSystem.readByteArray( input_name );
    var file_len:uint     = file_in.length;

    /* TODO:
       verify that file_in is a valid *.abc or *.swf file
    */
    
    var exe_out:ByteArray = new ByteArray();
        
        exe_out.writeBytes( exe_in );
        bytesWritten += exe_in.length;
        
        exe_out.writeBytes( file_in );
        bytesWritten += file_len;

    //projector signature
    var header:ByteArray = new ByteArray(); //always 8 bytes
        header.writeByte( 0x56 );
        header.writeByte( 0x34 );
        header.writeByte( 0x12 );
        header.writeByte( 0xFA );
        header.writeByte(  file_len      & 0xFF );
        header.writeByte( (file_len>>8)  & 0xFF );
        header.writeByte( (file_len>>16) & 0xFF);
        header.writeByte( (file_len>>24) & 0xFF );
        
        exe_out.writeBytes( header );
        bytesWritten += 8;
    
    if( FileSystem.exists( output_name ) )
    {
        var ext:String = FileSystem.getExtension( output_name );

        if( ext != "" )
        {
            output_name = output_name.replace( ext, "2"+ext );
        }
        else
        {
            output_name += "2";
        }
    }
    
    var written:Boolean = FileSystem.writeByteArray( output_name, exe_out );
    
    if( written )
    {
        trace( output_name + ", " + bytesWritten + " bytes written" );

        var mode:int = FileSystem.getFileMode( output_name );
        chmod( output_name, (mode | (S_IXUSR | S_IXGRP | S_IXOTH ) ) );
        System.exit(0);
    }
    else
    {
        trace( "Could not create \"" + output_name + "\"" );
        System.exit(1);
    }
    
    function usage():void
    {
	    trace( help );
	    System.exit(1);
    }
}


