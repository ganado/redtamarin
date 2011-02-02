
import avmplus.System;
import avmplus.Socket;
import C.socket.*;

var server:Socket = new Socket();
    server.reuseAddress = true;

//if( !server.bind( 3333, "192.168.0.2" ) )
if( !server.bind( 3333, "127.0.0.1" ) )
{
    trace( "could not bind to port 3333" );
    System.exit(1);
}

if( !server.listen() )
{
    trace( "could not listen" );
    System.exit(1);
}

var answer:String = "";
var buffer:uint = 2;

trace( "--- waiting for client to connect" );

var client:Socket = server.accept();

if( client.valid )
{
    client.send( "hello world\n" );

    trace( "--- waiting for client answer" );
    answer = client.receiveAll( buffer );
    trace( "client said \"" + answer + "\"" );
}



trace( "---- closing" );
client.close();
server.close();
trace( "server.connected = " + server.connected );
trace( "server.valid = " + server.valid );
trace( "client.connected = " + client.connected );
trace( "client.valid = " + client.valid );

trace( "EOF" );

