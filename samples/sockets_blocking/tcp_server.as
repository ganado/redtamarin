
import avmplus.System;
import avmplus.Socket;
import C.stdlib.*;
import C.socket.*;

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

var tmpsock:Socket;
while( !tmpsock && !tmpsock.valid )
{
    trace( "Waiting for incoming connections..." );
    tmpsock = sock.accept();
}
var sock2:Socket = tmpsock;
trace( "Client connected!" );

var message:String = "Welcome to the server!";
sock2.send( message );

sock2.close();
sock.close();
System.exit( EXIT_SUCCESS );


