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

/* Utility to wrap asc.jar as an executale.
 */
 
import C.stdlib.getenv;
import avmplus.System;
import avmplus.FileSystem;
import avmplus.OperatingSystem;

var examples_POSIX:String = <![CDATA[
Examples:
  Build the *.abc for a simple program
  $ ./asc -AS3 -strict -optimize -import builtin.abc -import toplevel.abc program.as

  Build an executable for a simple program
  $ ./asc -AS3 -strict -optimize -import builtin.abc -import toplevel.abc -exe redshell program.as
]]>;

var examples_WIN32:String = <![CDATA[
Examples:
  Build the *.abc for a simple program
  C:/> asc.exe -AS3 -strict -optimize -import builtin.abc -import toplevel.abc program.as

  Build an executable for a simple program
  C:/> asc.exe -AS3 -strict -optimize -import builtin.abc -import toplevel.abc -exe redshell.exe program.as
]]>;

var search_asc:Boolean = true;
var asc_path:String = "";
var find_env:String = getenv( "ASC" );
var cur_dir:String  = FileSystem.ensureEndsWithSeparator( FileSystem.currentDirectory ) + "asc.jar";

//first, look in the current dir
if( search_asc && (cur_dir != "") )
{
    if( FileSystem.exists( cur_dir )  )
    {
        asc_path = cur_dir;
        search_asc = false;
    }
}

//then, look in the env var
if( search_asc && (find_env != "") )
{
    asc_path = find_env;
    search_asc = false;
}

if( search_asc )
{
    trace( "ERROR: could not find 'asc.jar' int the current directory or in $ASC environment variable" );
    System.exit(1);
}


var args:String = "";

if( System.argv.length > 0 )
{
    args = " " + System.argv.join( " " );
}

var output:String = System.popen( "java -jar " + asc_path + args );
System.write( output );

if( args == "" )
{
    switch( OperatingSystem.vendor )
    {
        case "Microsoft":
        trace( examples_WIN32 );
        break;

        case "Apple":
        case "Linux":
        default:
        trace( examples_POSIX );
    }
    
}

System.exit(0);





