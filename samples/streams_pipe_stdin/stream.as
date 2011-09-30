
/* USAGE

   1) with ABC
   $ ./make.sh
   $ cat help_programmer_001.png | ./redshell stream.abc

   2) with AS
   $ cat help_programmer_001.png | ./redshell stream.as

*/

import avmplus.*;
import flash.utils.*;
import C.stdio.*;

//change the console stream mode to binary
con_trans_mode(O_BINARY); //does nothing under POSIX, only works with WIN32

//read stdin binary stream
var bytes = System.stdin.readBinary();
trace( "total bytes received = " + bytes.length );

//save a copy of the stream to the current directory
FileSystem.writeByteArray( "sad_panda.png", bytes );


