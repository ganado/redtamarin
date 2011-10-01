
/* USAGE

   1) ABC
   $ ./java -jar asc.jar -AS3 -strict -import builtin.abc -import shell_toplevel.abc sysinfo.as
   ./redshell sysinfo.abc

   2) AS
   ./redshell sysinfo.as
   
*/

import avmplus.*;

trace( "             OperatingSystem.name = " + OperatingSystem.name );
trace( "         OperatingSystem.username = " + OperatingSystem.username );
trace( "         OperatingSystem.nodename = " + OperatingSystem.nodename );
trace( "         OperatingSystem.hostname = " + OperatingSystem.hostname );
trace( "          OperatingSystem.release = " + OperatingSystem.release );
trace( "          OperatingSystem.version = " + OperatingSystem.version );
trace( "          OperatingSystem.machine = " + OperatingSystem.machine );
trace( "           OperatingSystem.vendor = " + OperatingSystem.vendor );
trace( "       OperatingSystem.vendorName = " + OperatingSystem.vendorName );
trace( "    OperatingSystem.vendorVersion = " + OperatingSystem.vendorVersion );
trace( "OperatingSystem.vendorDescription = " + OperatingSystem.vendorDescription );
trace( "         OperatingSystem.codename = " + OperatingSystem.codename );


