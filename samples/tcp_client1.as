
import avmplus.FileSystem;
import avmplus.Socket;
import C.socket.*;

Socket.prototype.recordCustom = function( message:String ):void
{
    message = "Socket (" + this.descriptor + "): " + message;
    this.log( message );
    this.output( message );

    //custom
    var file:String = "socketlogs.txt";
    var data:String = "";
    if( FileSystem.exists( file ) )
    {
        data = FileSystem.read( file );
    }
    data += message + "\n";
    FileSystem.write( file, data );
}

Socket.prototype.record = Socket.prototype.recordCustom;

var client:Socket = new Socket();

client.connect( "127.0.0.1", 3333 );
//client.connect( "192.168.0.2", 3333 );


trace( "--- waiting for server to answer" );
var answer:String = client.receive();
trace( "server said \"" + answer + "\"" );

trace( "--- sending message to server" );
var message:String = "hello server\n";

client.send( message );

trace( "---- waiting" );
while( client.connected )
{
    trace( "still connected ..." );
    answer = client.receive();
}

trace( "---- closing" );
client.close();
trace( "client.connected = " + client.connected );
trace( "client.valid = " + client.valid );

trace( "EOF" );



