
import avmplus.System;
import avmplus.FileSystem;
import avmplus.Socket;
import flash.utils.ByteArray;
import C.stdlib.*;
import C.unistd.*;
import C.socket.*;
import C.errno.*;

var sock:Socket = new Socket();
//var sock:Socket = new Socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
    sock.reuseAddress = true;

if( !sock.valid )
{
    trace( "Socket creation Failed!" );
    System.exit( EXIT_FAILURE );
}

sock.bind( 3333, "127.0.0.1" );

if( !sock.bound )
{
    trace( "Unable to bind socket!" );
    System.exit( EXIT_FAILURE );
}

sock.listen( 1 );

if( !sock.listening )
{
    trace( "Unable to listen on socket!" );
    System.exit( EXIT_FAILURE );
}

trace( "Waiting for incoming connections..." );
var sock2:Socket = sock.accept();
trace( "Client connected!" );


//set timeout to max 5 seconds
sock.sendTimeout = 1;

var message:String = "Welcome to the server!";
var bytes:ByteArray = FileSystem.readByteArray( "data.bin" );

try
{
    //sock2.send( message );
    sock2.sendBinary( bytes );
}
catch( e:Error )
{
    trace( e );
    if( e.errorID == ETIMEDOUT )
    {
        trace( "send() timed out" );
        sock2.close();
        sock.close();
        System.exit( EXIT_FAILURE );
    }
}


sock2.close();
sock.close();
System.exit( EXIT_SUCCESS );


