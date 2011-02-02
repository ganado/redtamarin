
import avmplus.System;
import avmplus.OperatingSystem;
import avmplus.Socket;
import C.socket.*;
import C.unistd.*;

include "chatter_data.as";
include "chatterbox.as";

//Socket.prototype.record = function() {};
var client:Socket = new Socket();

client.connect( "127.0.0.1", 3333 );

var localname:String = stuff[ between(0, stuff.length-1) ] + between(0,100);
trace( "local name is [" + localname + "]" );

var onesec:int = 1000;
var twosec:int = 2000;
var run:Boolean = true;
var receive:String;
var input:String;

while( run && client.valid )
{

    if( every(between(10,30)) )
    {
        trace( "enter message:" );
        input = readLine();
        client.send( input );
    }

    if( client.readable )
    {
        trace( "client is readable" );
        receive = client.receiveAll();
        if( receive.length > 0 )
        {
            trace( "receive = " + receive );
        }
    }
    else if( client.writeable )
    {
        trace( "client is writeable" );
        //trace( "send message" );
        //client.send( "hello world");
    }

    sleep( onesec );
}


trace( "---- closing" );
client.close();
trace( "client.connected = " + client.connected );
trace( "client.valid = " + client.valid );

trace( "EOF" );



