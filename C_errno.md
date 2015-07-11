# Implementation #

**Errno.h** is a special case

in itself the implementation is not hard as this header define mainly a list of constants

but the problem is that those constants vary depending on the systems,<br>
there are huge difference in WIN32 vs POSIX.<br>
<br>
System Error Codes<br>
<b>equivalence table</b>

<b>base errors</b>
<table><thead><th> <b>Number</b> </th><th> <b>Linux (errno.h)</b> </th><th> <b>Windows (errno.h)</b> </th><th> <b>(comment)</b> </th></thead><tbody>
<tr><td> 1             </td><td> EPERM                  </td><td> EPERM                    </td><td>                  </td></tr>
<tr><td> 2             </td><td> ENOENT                 </td><td> ENOENT                   </td><td>                  </td></tr>
<tr><td> 3             </td><td> ESRCH                  </td><td> ESRCH                    </td><td>                  </td></tr>
<tr><td> 4             </td><td> EINTR                  </td><td> EINTR                    </td><td>                  </td></tr>
<tr><td> 5             </td><td> EIO                    </td><td> EIO                      </td><td>                  </td></tr>
<tr><td> 6             </td><td> ENXIO                  </td><td> ENXIO                    </td><td>                  </td></tr>
<tr><td> 7             </td><td> E2BIG                  </td><td> E2BIG                    </td><td>                  </td></tr>
<tr><td> 8             </td><td> ENOEXEC                </td><td> ENOEXEC                  </td><td>                  </td></tr>
<tr><td> 9             </td><td> EBADF                  </td><td> EBADF                    </td><td>                  </td></tr>
<tr><td> 10            </td><td> ECHILD                 </td><td> ECHILD                   </td><td>                  </td></tr>
<tr><td> 11            </td><td> EAGAIN                 </td><td> EAGAIN                   </td><td>                  </td></tr>
<tr><td> 12            </td><td> ENOMEM                 </td><td> ENOMEM                   </td><td>                  </td></tr>
<tr><td> 13            </td><td> EACCES                 </td><td> EACCES                   </td><td>                  </td></tr>
<tr><td> 14            </td><td> EFAULT                 </td><td> EFAULT                   </td><td>                  </td></tr>
<tr><td> 15            </td><td> ENOTBLK                </td><td>                          </td><td> missing          </td></tr>
<tr><td> 16            </td><td> EBUSY                  </td><td> EBUSY                    </td><td>                  </td></tr>
<tr><td> 17            </td><td> EEXIST                 </td><td> EEXIST                   </td><td>                  </td></tr>
<tr><td> 18            </td><td> EXDEV                  </td><td> EXDEV                    </td><td>                  </td></tr>
<tr><td> 19            </td><td> ENODEV                 </td><td> ENODEV                   </td><td>                  </td></tr>
<tr><td> 20            </td><td> ENOTDIR                </td><td> ENOTDIR                  </td><td>                  </td></tr>
<tr><td> 21            </td><td> EISDIR                 </td><td> EISDIR                   </td><td>                  </td></tr>
<tr><td> 22            </td><td> EINVAL                 </td><td> EINVAL                   </td><td> Secure CRT only  </td></tr>
<tr><td> 23            </td><td> ENFILE                 </td><td> ENFILE                   </td><td>                  </td></tr>
<tr><td> 24            </td><td> EMFILE                 </td><td> EMFILE                   </td><td>                  </td></tr>
<tr><td> 25            </td><td> ENOTTY                 </td><td> ENOTTY                   </td><td>                  </td></tr>
<tr><td> 26            </td><td> ETXTBSY                </td><td> ETXTBSY (139)            </td><td>                  </td></tr>
<tr><td> 27            </td><td> EFBIG                  </td><td> EFBIG                    </td><td>                  </td></tr>
<tr><td> 28            </td><td> ENOSPC                 </td><td> ENOSPC                   </td><td>                  </td></tr>
<tr><td> 29            </td><td> ESPIPE                 </td><td> ESPIPE                   </td><td>                  </td></tr>
<tr><td> 30            </td><td> EROFS                  </td><td> EROFS                    </td><td>                  </td></tr>
<tr><td> 31            </td><td> EMLINK                 </td><td> EMLINK                   </td><td>                  </td></tr>
<tr><td> 32            </td><td> EPIPE                  </td><td> EPIPE                    </td><td>                  </td></tr>
<tr><td> 33            </td><td> EDOM                   </td><td> EDOM                     </td><td>                  </td></tr>
<tr><td> 34            </td><td> ERANGE                 </td><td> ERANGE                   </td><td> Secure CRT only  </td></tr></tbody></table>

<table><thead><th> <b>Number</b> </th><th> <b>Linux (errno.h)</b> </th><th> <b>Windows (errno.h)</b> </th><th> <b>(comment)</b> </th></thead><tbody>
<tr><td> 35            </td><td> EDEADLK                </td><td> EDEADLK (36)             </td><td> diff             </td></tr>
<tr><td> 36            </td><td> ENAMETOOLONG           </td><td> ENAMETOOLONG (38)        </td><td> diff             </td></tr>
<tr><td> 37            </td><td> ENOLCK                 </td><td> ENOLCK (39)              </td><td> diff             </td></tr>
<tr><td> 38            </td><td> ENOSYS                 </td><td> ENOSYS (40)              </td><td> diff             </td></tr>
<tr><td> 39            </td><td> ENOTEMPTY              </td><td> ENOTEMPTY (41)           </td><td> diff             </td></tr>
<tr><td> 40            </td><td> ELOOP                  </td><td> ELOOP (114)              </td><td> diff             </td></tr>
<tr><td> (41)          </td><td> EWOULDBLOCK = EAGAIN   </td><td> EWOULDBLOCK (140)        </td><td> diff             </td></tr>
<tr><td> 42            </td><td> ENOMSG                 </td><td> ENOMSG (122)             </td><td> diff             </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 1             </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> 50            </td><td> EPERM                  </td><td>                          </td><td>                  </td></tr>
<tr><td> (58)          </td><td> EDEADLOCK = EDEADLK    </td><td> EDEADLOCK = EDEADLK      </td><td>                  </td></tr>
<tr><td> 84            </td><td> EILSEQ                 </td><td> EILSEQ (42)              </td><td> diff             </td></tr></tbody></table>




<b>references:</b>
<ul><li><a href='http://www.dinkumware.com/manuals/default.aspx?manual=compleat&page=errno.html'>http://www.dinkumware.com/manuals/default.aspx?manual=compleat&amp;page=errno.html</a>
</li><li><a href='http://en.wikipedia.org/wiki/Errno.h'>http://en.wikipedia.org/wiki/Errno.h</a>
</li><li><a href='http://msdn.microsoft.com/en-GB/library/5814770t(v=vs.90).aspx'>errno Constants (VS2008)</a>
</li><li><a href='http://msdn.microsoft.com/en-GB/library/5814770t(v=vs.100).aspx'>errno Constants (VS2010)</a>
</li><li><a href='http://msdn.microsoft.com/en-us/library/windows/desktop/ms737828(v=vs.85).aspx'>Error Codes - errno, h_errno and WSAGetLastError</a>
</li><li><a href='http://msdn.microsoft.com/en-us/library/windows/desktop/ms681381(v=vs.85).aspx'>System Error Codes</a></li></ul>

<h1>About</h1>
System error numbers.<br>
<br>
<b>package:</b> <code>C.errno.*</code>

<b>product:</b> redtamarin 0.3<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<b>references:</b>
<ul><li><a href='http://www.dinkumware.com/manuals/default.aspx?manual=compleat&page=errno.html'>http://www.dinkumware.com/manuals/default.aspx?manual=compleat&amp;page=errno.html</a>
</li><li><a href='http://en.wikipedia.org/wiki/Errno.h'>http://en.wikipedia.org/wiki/Errno.h</a></li></ul>

<hr />
<h1>Constants</h1>

<h2>General errors</h2>
<table><thead><th> <b>EDOM</b> </th><th> Numerical argument out of domain. </th></thead><tbody>
<tr><td> <b>EILSEQ</b> </td><td> Illegal byte sequence.            </td></tr>
<tr><td> <b>ERANGE</b> </td><td> Result too large.                 </td></tr></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>POSIX Additional errors</h2>
<table><thead><th> <b>EPERM</b> </th><th> Operation not permitted. </th></thead><tbody>
<tr><td> <b>ENOENT</b> </td><td> No such file or directory. </td></tr>
<tr><td> <b>ESRCH</b> </td><td> No such process.         </td></tr>
<tr><td> <b>EINTR</b> </td><td> Interrupted system call. </td></tr>
<tr><td> <b>EIO</b>   </td><td> Input/output error.      </td></tr>
<tr><td> <b>ENXIO</b> </td><td> Device not configured.   </td></tr>
<tr><td> <b>E2BIG</b> </td><td> Argument list too long.  </td></tr>
<tr><td> <b>ENOEXEC</b> </td><td> Exec format error.       </td></tr>
<tr><td> <b>EBADF</b> </td><td> Bad file descriptor.     </td></tr>
<tr><td> <b>ECHILD</b> </td><td> No child processes.      </td></tr>
<tr><td> <b>EAGAIN</b> </td><td> Resource temporarily unavailable. </td></tr>
<tr><td> <b>ENOMEM</b> </td><td> Cannot allocate memory.  </td></tr>
<tr><td> <b>EACCES</b> </td><td> Permission denied.       </td></tr>
<tr><td> <b>EFAULT</b> </td><td> Bad address.             </td></tr>
<tr><td> <b>EBUSY</b> </td><td> Device / Resource busy.  </td></tr>
<tr><td> <b>EEXIST</b> </td><td> File exists.             </td></tr>
<tr><td> <b>EXDEV</b> </td><td> Cross-device link.       </td></tr>
<tr><td> <b>ENODEV</b> </td><td> Operation not supported by device. </td></tr>
<tr><td> <b>ENOTDIR</b> </td><td> Not a directory.         </td></tr>
<tr><td> <b>EISDIR</b> </td><td> Is a directory.          </td></tr>
<tr><td> <b>EINVAL</b> </td><td> Invalid argument.        </td></tr>
<tr><td> <b>ENFILE</b> </td><td> Too many open files in system. </td></tr>
<tr><td> <b>EMFILE</b> </td><td> Too many open files.     </td></tr>
<tr><td> <b>ENOTTY</b> </td><td> Inappropriate ioctl for device. </td></tr>
<tr><td> <b>EFBIG</b> </td><td> File too large.          </td></tr>
<tr><td> <b>ENOSPC</b> </td><td> No space left on device. </td></tr>
<tr><td> <b>ESPIPE</b> </td><td> Illegal seek.            </td></tr>
<tr><td> <b>EROFS</b> </td><td> Read-only file system.   </td></tr>
<tr><td> <b>EMLINK</b> </td><td> Too many links.          </td></tr>
<tr><td> <b>EPIPE</b> </td><td> Broken pipe.             </td></tr>
<tr><td> <b>EDEADLK</b> </td><td> Resource deadlock avoided. </td></tr>
<tr><td> <b>ENAMETOOLONG</b> </td><td> File name too long.      </td></tr>
<tr><td> <b>ENOLCK</b> </td><td> No locks available.      </td></tr>
<tr><td> <b>ENOSYS</b> </td><td> Function not implemented. </td></tr>
<tr><td> <b>ENOTEMPTY</b> </td><td> Directory not empty.     </td></tr></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<h2>Socket errors</h2>

<table><thead><th> <b>EWOULDBLOCK</b> </th><th> Operation would block. </th></thead><tbody>
<tr><td> <b>EINPROGRESS</b> </td><td> Operation now in progress. </td></tr>
<tr><td> <b>EALREADY</b>    </td><td> Operation already in progress. </td></tr>
<tr><td> <b>EDESTADDRREQ</b> </td><td> Destination address required. </td></tr>
<tr><td> <b>EMSGSIZE</b>    </td><td> Message too long.      </td></tr>
<tr><td> <b>EPROTOTYPE</b>  </td><td> Protocol wrong type for socket. </td></tr>
<tr><td> <b>ENOPROTOOPT</b> </td><td> Bad protocol option.   </td></tr>
<tr><td> <b>EADDRINUSE</b>  </td><td> Address already in use. </td></tr>
<tr><td> <b>EADDRNOTAVAIL</b> </td><td> Can't assign requested address. </td></tr></tbody></table>

<b>since:</b> 0.3.2<br>
<br>
<table><thead><th> <b>ENETDOWN</b> </th><th> Network is down. </th></thead><tbody>
<tr><td> <b>ENETUNREACH</b> </td><td> Network is unreachable. </td></tr>
<tr><td> <b>ENETRESET</b> </td><td> Network dropped connection on reset. </td></tr>
<tr><td> <b>ECONNABORTED</b> </td><td> Software caused connection abort. </td></tr>
<tr><td> <b>ECONNRESET</b> </td><td> Connection reset by peer. </td></tr>
<tr><td> <b>ENOBUFS</b>  </td><td> No buffer space available. </td></tr>
<tr><td> <b>EISCONN</b>  </td><td> Socket is already connected. </td></tr>
<tr><td> <b>ENOTCONN</b> </td><td> Socket is not connected. </td></tr>
<tr><td> <b>ESHUTDOWN</b> </td><td> Can't send after socket shutdown. </td></tr>
<tr><td> <b>ETOOMANYREFS</b> </td><td> Too many references: can't splice. </td></tr>
<tr><td> <b>ETIMEDOUT</b> </td><td> Operation timed out. </td></tr>
<tr><td> <b>ECONNREFUSED</b> </td><td> Connection refused. </td></tr></tbody></table>

<b>since:</b> 0.3.0<br>
<br>
<table><thead><th> <b>ELOOP</b> </th><th> Too many levels of symbolic links. </th></thead><tbody>
<tr><td> <b>EHOSTDOWN</b> </td><td> Host is down.                      </td></tr>
<tr><td> <b>EHOSTUNREACH</b> </td><td> No Route to Host.                  </td></tr></tbody></table>

<b>since:</b> 0.3.2<br>
<br>
<br>
<hr />
<h1>Functions</h1>

<h2>errno</h2>
<pre><code>public function get errno():int<br>
public function set errno( value:int ):void<br>
</code></pre>
Error return value.<br>
<br>
Designates an object that is assigned a value greater than zero on certain library errors.<br>
<br>
<b>example:</b> basic usage<br>
<pre><code>import C.errno.*;<br>
import C.string.*;<br>
import avmplus.FileSystem;<br>
<br>
var filename:String = "dummy_file";<br>
<br>
if( !FileSystem.exists( filename ) )<br>
{<br>
     trace( "errno = " + errno ); //errno = 2<br>
     trace( strerror( errno ) );  //No such file or directory<br>
}<br>
</code></pre>

<b>note:</b><br>
the system will not reset the error number for you<br>
for each <code>errno</code> you catch you will have to reset it<br>
<code>errno = 0</code>.<br>
<br>
<b>since:</b> 0.3.0<br>
<br>
<br>
<h2>getErrno</h2>
<pre><code>public function get errno():int<br>
</code></pre>
Function to get the Error value.<br>
<br>
<b>note:</b><br>
In some strange case <code>errno</code> as a getter/setter does not work<br>
so this function can be used as an alternative.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<h2>setErrno</h2>
<pre><code>public function setErrno( value:int ):void<br>
</code></pre>
Function to set the Error value.<br>
<br>
<b>note:</b><br>
In some strange case <code>errno</code> as a getter/setter does not work<br>
so this function can be used as an alternative.<br>
<br>
<b>since:</b> 0.3.2<br>
<br>
<br>
<hr />