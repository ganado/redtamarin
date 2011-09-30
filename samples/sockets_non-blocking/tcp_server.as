
import avmplus.System;
import avmplus.Socket;
import C.stdlib.*;
import C.unistd.*;
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

// we go in non-blocking mode
sock.blocking = false;

//loop
var message:String = "Welcome to the server!";
var err:int;
for(;;)
{
    sock2.send( message );

    err = Socket.lastError;
    if( (err != EWOULDBLOCK) && (err != 0) )
    {
        trace( "error " + err );
        trace( "Client disconnected!" );
        sock2.close();
        sock.close();
        break;
    }

    sleep( 1000 );
}

sock2.close();
sock.close();
System.exit( EXIT_SUCCESS );


