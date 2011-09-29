
/* USAGE
   blocking and non-blocking stdin
   
   1) with ABC
   $ ./make.sh
   $ ./redshell stream.abc

   2) with AS
   $ ./redshell stream.as

   example of output:
    Non-Blocking input: (type 'q' to quit)
    a
    key = a
    b
    key = b
    c
    key = c
    d
    key = d
    q
    key = q
    --------
    Blocking input: ('ENTER' key to quit)
    hello
    input = hello
    --------
    all done
*/

import avmplus.*;
import flash.utils.*;
import C.unistd.*;
import C.stdio.*;


var run:Boolean = true
var key:String;
var i:int = 0;

//change the console stream mode to non-blocking
con_stream_mode(NONBLOCKING_ENABLE);

/* note:
   in non-blocking mode we don''t wait for the ENTER key to be pressed
   as soon as you type a letter on the stdin
   kbhit() detect it
   and then you can directly read 1 char from stdin to display it
*/
trace( "Non-Blocking input: (type 'q' to quit)" );
while( run )
{
    i=kbhit();
    sleep(100);
    
    if( i != 0 )
    {
        key = System.stdin.read( 1 );
        trace( "\nkey = " + key );
        if( key == "q" )
        {
            run = false;
        }
        i = 0;
    }
}
//change back the console stream mode to blocking
con_stream_mode(NONBLOCKING_DISABLE);
trace( "--------" );

/* note:
   in blocking mode we have to wait for the ENTER key to be pressed
   and because everything block we don't need to use kbhit()
*/
trace( "Blocking input: ('ENTER' key to quit)" );
var input:String = System.readLine();
trace( "input = " + input );
trace( "--------" );

trace( "all done" );

