
/* USAGE

   1) with ABC
   $ ./make.sh
   $ ./redshell stream.abc >> test.png

   2) with AS
   $ ./redshell stream.as >> test.png

*/

import avmplus.*;
import flash.utils.*;
import C.stdio.*;

//change the console stream mode to binary
con_trans_mode(O_BINARY); //does nothing under POSIX, only works with WIN32

//read the file from current directory
var bytes = FileSystem.readByteArray( "help_programmer_001.png" );

//write to stdout the binary stream
System.stdout.writeBinary( bytes );

/* note:
   don't use a trace()/print() statement
   or it will garble the stdout output

   if you HAVE TO write something to the console use stderr as a workaround
   eg. System.stderr.write( "foobar\n" );
*/
//System.stderr.write( "wrote " + bytes.length + " bytes to stdout\n" );

