
import avmplus.System;
import avmplus.Socket;
import C.stdlib.*;
import C.socket.*;

var sock:Socket = new Socket();
//var sock:Socket = new Socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );

if( !sock.valid )
{
    trace( "Socket creation Failed!" );
    System.exit( EXIT_FAILURE );
}

sock.connect( "127.0.0.1", 3333 );

if( !sock.connected )
{
    trace( "Failed to establish connection with server" );
    System.exit( EXIT_FAILURE );
}

var message:String = sock.receive();
trace( message );

sock.close();
System.exit( EXIT_SUCCESS );


