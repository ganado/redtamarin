
import avmplus.System;
import avmplus.Socket;
import C.stdlib.*;
import C.unistd.*;
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


sock.blocking = false;

//loop
var message:String;
var err:int;
for(;;)
{
    message = sock.receive();
    trace( message );

    err = Socket.lastError;
    if( (err != WOULDBLOCK) && (err != 0) )
    {
        trace( "error " + err );
        trace( "Server disconnected!" );
        sock.close();
        break;
    }

    sleep( 1000 );
}

sock.close();
System.exit( EXIT_SUCCESS );


