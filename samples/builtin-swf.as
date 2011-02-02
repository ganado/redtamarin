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

/* Utility to create a SWC based on the builtin.

   Usage:
     builtin-swf abcfile
     abcfile        the builtin.abc file
   
   By default the name of the output file is the name of the input file.

   TODO:
   - dynamically generate the XML for the SWC
   - create a zip file

   note:
   
 */

package builtin-swc
{
    import avmplus.System;
    import avmplus.FileSystem;
    import flash.utils.ByteArray;
    
    var help:String = <x><![CDATA[
Usage:
 builtin-swc abcfile
 abcfile        the builtin.abc file
]]></x>.text()[0];

    var input_name:String   = "builtin.abc";
    var output_name:String  = "builtin.swf";

    var body:ByteArray = new ByteArray();
        body.endian = "littleEndian";
        body.writeByte( 2 << 3 );   // RECT: 2 bits per dim
        body.writeByte( 0 );        //   and they're all zero
        body.writeShort( 0 );       // framerate
        body.writeShort( 0 );       // framecount

    var s:String;
    var j:uint;
	s = input_names;
	
	var bytes:ByteArray = FileSystem.readByteArray( s );
	body.writeShort( (82 << 6) | 63 );  // DoABC, extended length
	body.writeUnsignedInt( bytes.length + 4 + s.length + 1 );
	body.writeUnsignedInt( 0 );         // flags
	for( j=0 ; j < s.length ; j++ )
	{
	    body.writeByte( s.charCodeAt(j) & 255 );
	}
	
	body.writeByte( 0 );
	body.writeBytes( bytes );
    
    body.writeShort( 0 );                   // End
    
    var numbytes = body.length + 8;

    if( compress ) { body.compress(); }
	
    var result = new ByteArray();
        result.endian = "littleEndian";
        result.writeByte( (compress ? 'C' : 'F').charCodeAt(0) );
        result.writeByte( 'W'.charCodeAt(0) );
        result.writeByte( 'S'.charCodeAt(0) );
        result.writeByte( 9 );
        result.writeUnsignedInt( numbytes );
        result.writeBytes( body );
    
    FileSystem.writeByteArray( output_name, result );
}
