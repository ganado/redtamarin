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

/* Utility to get files from the internet (with HTTP)

   Usage:
     httpget url
       url        the URL of the file to get

   By default the received will be saved in the current folder.

   Example:
     httpget http://www.test.com/path/file.pdf

   Note:
     https:// url will not work
     http://username:password@www.domain.com may not work
     any other protocol like ftp:// etc. will not work
*/

package samples
{

    import avmplus.System;
    import avmplus.Socket;
    import flash.utils.ByteArray;
    import C.string.*;

    public class httpget
    {

        public static function usage():void
        {
            trace( "Usage:" );
            trace( "  httpget url" );
            trace( "    url      the URL of the file to get" );
        }


        public static function GET( url:String ):ByteArray
        {
            var sock = new Socket();
            var data:ByteArray = new ByteArray();
            var part:ByteArray;

            var p:RegExp = new RegExp( "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)([\?]([^#]*))?(#(.*))?" , null );
            var r:Object = p.exec( url );

            var scheme:String    = "";
            var authority:String = "";
            var host:String      = "";
            var port:String      = "";
            var userinfos:String = "";
            var username:String  = "";
            var password:String  = "";
            var path:String      = "";
            var query:String     = "";
            var fragment:String  = "";

            //scheme
            if( r[1] && r[2] )
            {
                scheme = r[2];
            }

            if( scheme == "" )
            {
                scheme = "http";
            }

            if( scheme != "http" )
            {
                throw new Error( "httpget only support the HTTP protocol." );
            }
            
            //authority
            if( r[3] )
            {
                authority = r[4];
                
                //userinfo
                if( authority.indexOf( "@" ) > -1 )
                {
                    userinfos = authority.split( "@" )[0];
                    host = authority.split( "@" )[1];
                    
                    if( userinfos.indexOf( ":" ) != -1 )
                    {
                        username = userinfos.split( ":" )[0];
                        password = userinfos.split( ":" )[1];
                    }
                    else
                    {
                        username = userinfos;
                    }
                    
                }
                else
                {
                    host = authority;
                }
                
                //port
                if( host.indexOf( ":" ) > -1 )
                {
                    port = host.split( ":" )[1];
                    var i:int;
                    var c:String;
                    var validPort:Boolean = true;
                    
                    for( i=0; i<port.length; i++ )
                    {
                        c = port.charAt( i );
                        if( !(("0" <= c) && (c <= "9")) )
                        {
                            validPort = false;
                        }
                    }
                    
                    if( validPort )
                    {
                        host = host.split( ":" )[0];
                    }
                }
                
            }
            
            //path
            if( r[5] )
            {
                path = r[5];
            }
            
            //query
            if( r[6] )
            {
                query = r[7];
            }
            
            //fragment
            if( r[8] )
            {
                fragment = r[9];
            }

            var run:Boolean = true;

            var remote_port:uint = 80;

            if( port != "" )
            {
                remote_port = parseInt( port );
            }


            sock.connect( host, remote_port );

            //build request
            var get_request:String = "";
            switch( mode )
            {
                case "1.0":
                get_request  = "GET " + path + " HTTP/1.0\r\n";
                get_request += "\r\n";
                break;

                case "1.1":
                get_request  = "GET " + path + " HTTP/1.1\r\n";
                get_request += "Host: " + host + ":" + remote_port + "\r\n";
                get_request += "\r\n";
                break;
            }

            filepath = filetosave( path );

            if( sock.connected )
            {
                if( verbose ) { trace( get_request.split( "\r\n" ).join( "\n" ) ); }
                sock.send( get_request );
                trace( "Downloading ..." );
                
                while( run )
                {

                    part = sock.receiveBinary( 1024 ); //receive data by packet of 1024bytes
                    
                    if( part && (part.length > 0) )
                    {
                        //till we receive data
                        data.writeBytes( part ); //append the bytes
                    }
                    else
                    {
                        //trace( "null bytes" ); //we received ALL the data
                        run = false;
                    }
                
                }
                
            }
            else
            {
                throw new Error( "Could not connect to host \"" + host + "\" on port " + remote_port + ", reason: " + strerror( Socket.lastError ) );
            }

            sock.close();
            
            data.position = 0;
            return data; //all the bytes collected
        }

        public static function readLineFrom( data:ByteArray ):String
        {
            if( data.bytesAvailable == 0 ) { return null; }

            var start:uint = data.position;
            var bytes:ByteArray = new ByteArray();
            var found:Boolean = false;

            var char:int;
            while( data.bytesAvailable > 0 )
            {
                char = data.readByte();
                bytes.writeByte( char );

                if( char == 10 )
                {
                    found = true;
                    break;
                }
            }

            var line:String = null;
            if( found )
            {
                bytes.position = 0;
                line = bytes.readUTFBytes( bytes.length );
            }
            return line;
        }

        public static function parseMessage( raw:ByteArray ):void
        {
            header = "";
            body   = new ByteArray();

            raw.position = 0;
            var line:String;

            while( line != "\r\n" )
            {
                line = readLineFrom( raw );
                header += line;
            }

            var empty_pos:uint = raw.position;
            raw.readBytes( body );
        }

        public static function filetosave( str:String ):String
        {
            var name:String = "";
            var dot:uint = str.lastIndexOf( "." );
            var slash:uint = str.lastIndexOf( "/" );

            if( (dot > -1) && (slash > -1) )
            {
                name = str.substr( slash+1 );
            }

            //trace( "filetosave [" + name + "]" );
            return name;
        }


        public static var url:String;
        public static var header:String;
        public static var body:ByteArray;

        public static var mode:String = "1.1";
        public static var verbose:Boolean = false;
        public static var filepath:String;



        public static function main( args:Array ):void
        {
            var bytes:ByteArray;
            
            if( args.length > 0 )
            {
                url = args[0];
                bytes = GET( url );

                trace( "received " + bytes.length + " bytes" );

                parseMessage( bytes );

                var lines:Array = header.split( "\r\n" );
                if( lines[0].indexOf( "404" ) > -1 )
                {
                    trace( "An error occured - " + lines[0] );
                    if( verbose )
                    {
                        trace( header.split( "\r\n" ).join( "\n" ) );
                        body.position = 0;
                        if( body.length > 1024 )
                        {
                            trace( body.readUTFBytes( 1024 ) + " ..." );
                        }
                        else
                        {
                            trace( body.readUTFBytes( body.length ) );
                        }
                    }

                    trace( "nothing saved to disk." );
                    System.exit(1);
                }
                
                if( verbose )
                {
                    trace( header.split( "\r\n" ).join( "\n" ) );
                }
                
                trace( "saving \"" + filepath + "\" ("+body.length+" bytes) to disk." );

                body.writeFile( filepath );
                
                System.exit(0);

                
            }
            else
            {
                usage();
                System.exit(1);
            }
        }
    }
}

/* Main Entry Point */
import avmplus.System;
import samples.httpget;
httpget.main( System.argv );






 
