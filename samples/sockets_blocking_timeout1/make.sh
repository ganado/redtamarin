#!/bin/bash

java -jar asc.jar -AS3 -strict -import builtin.abc -import shell_toplevel.abc  tcp_client.as
java -jar asc.jar -AS3 -strict -import builtin.abc -import shell_toplevel.abc  tcp_server.as

