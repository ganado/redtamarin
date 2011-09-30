
/* USAGE

   $ ./make.sh
   then run in 2 different terminal window
   ./redshell tcp_server.abc
   and
   ./redshell tcp_client.abc
   
   misc about WIN32:
   - the client always start by detecting a
     "SocketError: Operation would block",
     this is because of the non-blocking socket
   - 
   
   1) CTRL+C in the client window
      the server will detect a "SocketError: Connection reset by peer"
   
   2) CTRL+C in the server window
      the client will detect a "SocketError: Connection reset by peer"
*/

import avmplus.System;
import avmplus.Socket;
import C.stdlib.*;
import C.unistd.*;
import C.errno.*;

var sock:Socket = new Socket();

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

// we go in non-blocking mode
sock.blocking = false;

//loop
var message:String;
var err:int;
var receiving:Boolean = false;
for(;;)
{
    try
    {
        message = sock.receiveAll();
        receiving = true;
    }
    catch( e:Error )
    {
        err = e.errorID;
        
        if( err != 0 ) { trace( e ); }
        
        if( (err != EWOULDBLOCK) && (err != 0) )
        {
            trace( e );
            trace( "Server disconnected!" );
            sock.close();
            break;
        }
        
        if( receiving && (err == 0) )
        {
            trace( "Server disconnected!" );
            sock.close();
            break;
        }
        
    }

    sleep( 1000 );
}

sock.close();
System.exit( EXIT_SUCCESS );


