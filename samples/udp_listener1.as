
import avmplus.System;
import avmplus.Socket;
import C.socket.*;

Socket.prototype.record = function() {};
//Socket.prototype.record = Socket.prototype.recordLogOnly;
var listener:Socket = new Socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP ); //UDP
    listener.reuseAddress = true;

//if( !listener.bind( 3333, "127.0.0.1" ) )
if( !listener.bind( 3333, "0.0.0.0" ) )
{
    trace( "could not bind to port 3333" );
    System.exit(1);
}


var answer:String;

trace( "--- waiting for talker" );
while( listener.valid )
{
    answer = listener.receiveFrom( 512 );
    trace( "listener.local = " + listener.local );
    trace( "listener.peer = " + listener.peer );
    
    if( answer != null )
    {
        trace( "talker said :" );
        trace( "--------" );
        trace( answer );
        trace( "--------" );
        trace( "---- closing" );
        listener.close();
    }
}

trace( "listener.valid = " + listener.valid );
trace( "logs:\n" + listener.logs.join("\n") );
trace( "EOF" );

