
/* USAGE

   $ ./make.sh
   then run in 2 different terminal window
   ./redshell tcp_server.abc
   and
   ./redshell tcp_client.abc
   
   Here this time we add timeout to the blocking example
   
   Scenario 1:
   on the client we set the receive timeout to 5 seconds
   on the server, once we are connected we force a timeout of 10 seconds
   on the client we catch the error and look for ETIMEDOUT
   
   try these:
   - comment out "sleep( 10 * 1000 );" on the server
   - on the client change the timeout to sock.receiveTimeout = 15;
*/

import avmplus.System;
import avmplus.Socket;
import C.stdlib.*;
import C.socket.*;
import C.errno.*;

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

//set timeout to max 5 seconds
sock.receiveTimeout = 5;

try
{
    var message:String = sock.receive();
    trace( message );
}
catch( e:Error )
{
    trace( e );
    if( e.errorID == ETIMEDOUT )
    {
        trace( "receive() timed out" );
        sock.close();
        System.exit( EXIT_FAILURE );
    }
}

sock.close();
System.exit( EXIT_SUCCESS );


