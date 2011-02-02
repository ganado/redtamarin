
import avmplus.System;
import avmplus.OperatingSystem;
import avmplus.Socket;
import C.socket.*;
import C.unistd.*;

include "chatter_data.as";

stuff.push( "poker" );
stuff.push( "silver" );
stuff.push( "marauder" );
stuff.push( "dark matter" );

phrases.push( "{name} just PWNed your ass!" );
phrases.push( "{user} is in da place" );
phrases.push( "surfing sockets on {hostname}" );
phrases.push( "{user} was not trolling, you were trolllllling my {hostname}!!" );

include "chatterbox.as";

brain.user     = stuff[ between(0, stuff.length-1) ];
brain.name     = brain.user + " " + between(0,100);
brain.hostname = "node" + between(0,1000);

Socket.prototype.record = function() {};
var client:Socket = new Socket();

client.connect( "127.0.0.1", 3333 );

var onesec:int = 1000;
var twosec:int = 2000;
var fivesec:int = 5000;
var tensec:int = 10000;
var hundredthsec:int = 100;
var tenthsec:int = 10;
var run:Boolean = true;
var receive:String;

while( run && client.valid )
{
    trace( "conn / read:"+client.readable+" - write:"+client.writable);
    
    if( elapsed() == 2 )
    {
        client.send( "say:hello server " + Math.random() );
    }

    if( elapsed() == 4 )
    {
        client.send( "info:name=" + brain.name );
    }

    if( every(between(10,30)) )
    {
        client.send( "all:hello everyone, I'm " + brain.name );
    }

    if( client.readable )
    {
        //trace( "client is readable" );
        try
        {
            receive = client.receiveAll();
        }
        catch( e:Error )
        {
            trace( ">> " + e.toString() );
            run = false;
            break;
        }
        

        if( receive <= 0 )
        {
            run = false;
            break;
        }
        
        if( receive.length > 0 )
        {
            //trace( "--------" );
            trace( receive );
            //trace( "--------" );
        }
    }

    if( client.writable )
    {
        //trace( "client is writable" );
        //trace( "send message" );
        //client.send( "hello world");
        if( every(between(10,30)) )
        {
            var chat:String = chatter();
            trace( "(all) " + brain.name + ": " + chat );
            client.send( "all:" + chat );
        }
    }

    if( client.exceptional )
    {
        trace( ">> exceptional condition found on socket" );
        run = false;
    }

    //trace( ">> elapsed " + elapsed() + "sec" );
    //sleep( fivesec );  //~0.1% CPU
    //sleep( twosec ); //~0.1% CPU
    sleep( onesec );  //~0.1% CPU
    //sleep( hundredthsec ); //~0.8% CPU
    //sleep( tenthsec ); //~5% CPU
    //no sleep //~40% CPU
}


trace( "---- closing" );
client.close();
trace( "client.connected = " + client.connected );
trace( "client.valid = " + client.valid );

trace( "EOF" );



