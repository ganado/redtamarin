
import avmplus.System;
import avmplus.Socket;
import C.socket.*;

Socket.prototype.record = function() {};
//Socket.prototype.record = Socket.prototype.recordLogOnly;
var talker:Socket = new Socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP ); //UDP

var message:String = "hello listener\n";

trace( "--- sending message to listener" );
talker.sendTo( "127.0.0.1", 3333, message );
//talker.sendTo( "192.168.0.2", 3333, message );

trace( "talker.local = " + talker.local );
trace( "talker.peer = " + talker.peer );

trace( "---- closing" );
talker.close();
trace( "talker.valid = " + talker.valid );
trace( "logs:\n" + talker.logs.join("\n") );
trace( "EOF" );



