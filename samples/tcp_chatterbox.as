
import avmplus.System;
import avmplus.OperatingSystem;
import avmplus.Socket;
import C.socket.*;
import C.unistd.*;

include "chatter_data.as";
include "chatterbox.as";

trace( "max connection queue = " + Socket.maxConnectionQueue );
trace( "max concurrent connection = " + Socket.maxConcurrentConnection );

Socket.prototype.record = function() {};
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

var onesec:int = 1000;
var twosec:int = 2000;
var fivesec:int = 5000;
var tensec:int = 10000;
var hundredthsec:int = 100;
var tenthsec:int = 10;

var run:Boolean = true;
var connections:Array = [];
    connections.push( server );

var conninfos:Array = [];
    conninfos.push( {name:"server"} );

var removeClient:Function = function( id:int ):void
{
    connections.splice( id, 1 );
    var clientname:String = getClientName(id);
    if( clientname != "" )
    {
        trace( ">> remote client["+id+"] ("+clientname+") disconnected" );
        conninfos.splice( id, 1 );
    }
    else
    {
        trace( ">> remote client["+id+"] disconnected" );
    }
}

var broadcastToEveryone:Function = function( id:int, message:String ):void
{
    var current:Socket;
    var i:uint;
    
    for( i = 0; i<connections.length; i++ )
    {
        if( i == id ) { continue; }

        current = connections[i];

        if( current == server ) { continue; }

        //trace( "send [" + i + "]: " + message );
        if( current.valid && current.writable )
        {
            try
            {
                current.send( message );
            }
            catch( e:Error )
            {
                trace( ">> caught " + e.toString() );
                removeClient(i);
            }
            
        }
        else
        {
            removeClient(i);
        }
    }
}

var getClientName:Function = function( id:int ):String
{
    if( id == 0) { return "server"; }
    
    if( conninfos[id] && conninfos[id][name] )
    {
        return conninfos[id][name];
    }

    return "";
}

trace( "---- server loop" );
var selected:Socket;
var client:Socket;
var data:String;
var command:String;
var message:String;
var clientname:String;
var singlechat:String;
var multichat:String;
var tmp:Array;
var i:uint;

while( run && server.valid )
{
    
    
    for( i = 0; i<connections.length; i++ )
    {
        selected = connections[i];
        trace( "conn ["+i+"] / read:"+selected.readable+" - write:"+selected.writable);

        if( selected.readable )
        {
            //new connection / read data on server
            if( selected == server )
            {
                client = server.accept();
                if( !client.valid )
                {
                    trace( ">> Could not accept new client" );
                }
                else
                {
                    trace( ">> Accept new connection from " + client.local );
                    connections.push( client );
                }
            }
            else //read data from clients
            {
                try
                {
                    data = selected.receiveAll();
                }
                catch( e:Error )
                {
                    trace( ">> error receiving data from client" );
                    removeClient(i);
                }

                //not valid client
                if( !selected.valid )
                {
                    removeClient(i);
                }
                else //valid client
                {
                    //trace( ">> received " + data.length + " bytes from client" );

                    // ---- parse COMMAND ----
                    if( data.indexOf( ":" ) > -1 )
                    {
                        tmp = data.split( ":" );
                        command = tmp[0];
                        message = tmp[1];

                        switch( command )
                        {
                            case "say":
                            //trace( "client [" + i + "]" + ".say(" + "\"" + message + "\")" );
                            clientname = getClientName(i);
                            
                            if( clientname != "" )
                            {
                                message = clientname + ": " + message;
                                trace( message );
                            }
                            else
                            {
                                trace( "client " + i + ": " + message );
                            }
                            
                            
                            try
                            {
                                selected.send( "hello client [" + i + "]" );
                            }
                            catch( e:Error )
                            {
                                trace( ">> caught " + e.toString() );
                                removeClient(i);
                            }
                            break;

                            case "info":
                            trace( "client [" + i + "]" + ".info(" + "\"" + message + "\")" );
                            if( data.indexOf( ":" ) > -1 )
                            {
                                var tmp2:Array = message.split("=");
                                var name:String  = tmp2[0];
                                var value:String = tmp2[1];
                                if( !conninfos[i] )
                                {
                                    conninfos[i] = {};
                                }
                                conninfos[i][name] = value;
                            }
                            break;

                            case "all":
                            //trace( "client [" + i + "]" + ".all(" + "\"" + message + "\")" );
                            clientname = getClientName(i);
                            
                            if( clientname != "" )
                            {
                                message = clientname + ": " + message;
                                trace( "(all) " + message );
                            }
                            else
                            {
                                trace( "(all) client " + i + ": " + message );
                            }
                            
                            broadcastToEveryone( i, message );
                            break;

                            case "bye":
                            //trace( "client [" + i + "]" + ".bye()" );
                            clientname = getClientName(i);
                            message = "bye";
                            
                            if( clientname != "" )
                            {
                                message = clientname + ": " + message;
                                trace( message );
                            }
                            else
                            {
                                trace( "client " + i + ": " + message );
                            }
                            
                            
                            try
                            {
                                selected.send( "bye client [" + i + "]" );
                            }
                            catch( e:Error )
                            {
                                trace( ">> caught " + e.toString() );
                                removeClient(i);
                            }
                            //trace( ">> disconnecting client" );
                            
                            if( clientname != "" )
                            {
                                broadcastToEveryone( i, clientname + " disconnected ..." );
                            }
                            else
                            {
                                broadcastToEveryone( i, "client " + i + " disconnected ..." );
                            }
                            
                            selected.close();
                            connections.splice( i, 1 );
                            break;

                            case "shutdown":
                            //trace( "client [" + i + "]" + ".shutdown()" );
                            clientname = getClientName(i);
                            message = "shutdown the server";

                            if( clientname != "" )
                            {
                                message = clientname + ": " + message;
                                trace( message );
                            }
                            else
                            {
                                trace( "client " + i + ": " + message );
                            }

                            if( clientname != "" )
                            {
                                broadcastToEveryone( i, clientname + " shutdown the server ..." );
                            }
                            else
                            {
                                broadcastToEveryone( i, "client " + i + " shutdown the server ..." );
                            }
                            
                            server.close();
                            break;
                        }
                    }
                    else
                    {
                        trace( ">> UNKNOWN COMMAND - client [" + i + "] said \"" + data + "\"" );
                    }
                    // ---- parse COMMAND ---- EOF
                    
                } //valid client
                
            } //read data from clients
        } //readable

        if( selected.valid && selected.writable )
        {
            //write data to server
            if( selected == server )
            {
                trace( ">> can write to server" );
            }
            else //write data to clients
            {
                //trace( ">> can write to client [" + i + "]" );
                singlechat = chatter();
                //trace( ">> sending to ["+i+"]: " + singlechat );
                clientname = getClientName(i);
                
                if( clientname != "" )
                {
                    trace( "(" + clientname + ") server: " + singlechat );
                }
                else
                {
                    trace( "(client " + i + ") server: " + singlechat );
                }
                
                
                try
                {
                    selected.send( "server: " + singlechat );
                }
                catch( e:Error )
                {
                    trace( ">> caught " + e.toString() );
                    removeClient(i);
                }
            }
        }        

    } //for loop

    
    if( every(between(10,30)) )
    {
        multichat = chatter();
        trace( "(all) server: " + multichat );
        broadcastToEveryone( 0, multichat );
    }
    

    //trace( ">> elapsed " + elapsed() + "sec" );
    //sleep( fivesec ); //~0.5% CPU with 10 concurrent clients
    //sleep( twosec ); //~0.5% CPU with 10 concurrent clients
    sleep( onesec ); //~1% CPU with 10 concurrent clients
    //sleep( hundredthsec ); //~12% CPU with 10 concurrent clients
    //sleep( tenthsec ); //~50% CPU with 10 concurrent clients
    //no sleep //~40% CPU  with 10 concurrent clients - server can crash
}



trace( "---- closing" );
server.close();
trace( "server.connected = " + server.connected );
trace( "server.valid = " + server.valid );


trace( "EOF" );

