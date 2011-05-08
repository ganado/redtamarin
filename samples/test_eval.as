
/* note:
   compile test_eval.as to test_eval.abc
   $ java -jar asc.jar -import builtin.abc -import toplevel.abc test_eval.as
   then run
   $ ./redshell test_eval.abc
   and redshell will dynamically load and execute user_script.as
*/

import avmplus.System;
import avmplus.FileSystem;

var source:String = FileSystem.read( "user_script.as" );
avmplus.System.eval( source );


