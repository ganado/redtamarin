
/* USAGE

   $ ./make.sh
   then run in 2 different terminal window
   ./redshell tcp_server.abc
   and
   ./redshell tcp_client.abc
   
   misc about WIN32:
   - the client always start by detecting a
     "SocketError: Operation would block" (EWOULDBLOCK),
     this is because of the non-blocking socket
   - 

   misc about POSIX
   - the client always start by detecting a
     "SocketError: Resource temporarily unavailable" (EAGAIN),
     this is because of the non-blocking socket
   
   1) CTRL+C in the client window

      WIN32:
      the server will detect a "SocketError: Connection reset by peer"

      POSIX:
      the server will detect a "SocketError: Broken pipe"
   
   2) CTRL+C in the server window

      WIN32:
      the client will detect a "SocketError: Connection reset by peer"

      POSIX:
      the client will detect a "Connection closed by remote peer"
      
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
sock.receiveTimeout = 5;

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
        
        if( (err != EWOULDBLOCK) && (err != EAGAIN) && (err != 0) )
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

    if( !sock.valid || !sock.connected )
    {
        trace( "Server disconnected!" );
        sock.close();
        break;
    }

    sleep( 1000 );
}

sock.close();
System.exit( EXIT_SUCCESS );


