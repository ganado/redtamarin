/* -*- Mode: C++; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4 -*- */
/* vi: set ts=4 sw=4 expandtab: (add to ~/.vimrc: set modeline modelines=5) */
/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is [Open Source Virtual Machine.].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2004-2006
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail.com>.
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

#include "avmshell.h"

namespace avmshell
{

    //
    // SocketObject
    //

    SocketObject::SocketObject(VTable* vtable, ScriptObject* delegate, int sockd)
        : ScriptObject(vtable, delegate)
    {
        if( sockd == -1 )
        {
            //printf( "SocketObject ctor, default=%i\n", sockd );
            _socket = Platform::GetInstance()->createSocket();
        }
        else
        {
            //printf( "SocketObject ctor, custom=%i\n", sockd );
            _socket = Platform::GetInstance()->createSocketFrom( sockd );
        }
        
        _buffer = toplevel()->byteArrayClass()->constructByteArray();
        _buffer->set_length(0);
    }

    SocketObject::~SocketObject()
    {
        Platform::GetInstance()->destroySocket(_socket);
        _socket = NULL;
        _buffer->clear();
        _buffer = NULL;
    }

    int SocketObject::get_descriptor()
    {
        return _socket->GetDescriptor();
    }

    int SocketObject::get__type()
    {
        return _socket->GetType();
    }

    bool SocketObject::get_blocking()
    {
        return _socket->GetBlocking();
    }
    
    void SocketObject::set_blocking(bool value)
    {
        _socket->SetBlocking(value);
    }

    bool SocketObject::get_reuseAddress()
    {
        return _socket->GetReuseAddress();
    }

    void SocketObject::set_reuseAddress(bool value)
    {
        _socket->SetReuseAddress(value);
    }

    bool SocketObject::get_broadcast()
    {
        return _socket->GetBroadcast();
    }

    void SocketObject::set_broadcast(bool value)
    {
        _socket->SetBroadcast(value);
    }
    
    int SocketObject::get_receiveTimeout()
    {
        return _socket->GetReceiveTimeout();
    }
    
    void SocketObject::set_receiveTimeout(int value)
    {
        _socket->SetReceiveTimeout(value);
    }

    int SocketObject::get_sendTimeout()
    {
        return _socket->GetSendTimeout();
    }

    void SocketObject::set_sendTimeout(int value)
    {
        _socket->SetSendTimeout(value);
    }


    ByteArrayObject *SocketObject::_getBuffer()
    {
        return _buffer;
    }

    void SocketObject::_setNoSigPipe()
    {
        _socket->SetNoSigPipe();
    }

    bool SocketObject::_isValid()
    {
        return _socket->IsValid();
    }

    int SocketObject::_isReadable(int timeout)
    {
        return _socket->isReadable(timeout);
    }
    
    int SocketObject::_isWritable(int timeout)
    {
        return _socket->isWritable(timeout);
    }
    
    int SocketObject::_isExceptional(int timeout)
    {
        return _socket->isExceptional(timeout);
    }
    
    void SocketObject::_customSocket(int family, int socktype, int protocol)
    {
        Platform::GetInstance()->destroySocket(_socket);
        _socket = Platform::GetInstance()->createCustomSocket(family, socktype, protocol);
    }
    
    bool SocketObject::_connect(Stringp host, Stringp port)
    {
        if(!host) {
            toplevel()->throwArgumentError(kNullArgumentError, "host");
        }

        if(!port) {
            toplevel()->throwArgumentError(kNullArgumentError, "port");
        }
        
        StUTF8String hostUTF8(host);
        StUTF8String portUTF8(port);
        return _socket->Connect(hostUTF8.c_str(), portUTF8.c_str());
    }

    bool SocketObject::_close()
    {
        return _socket->Shutdown();
    }

    int SocketObject::_send(ByteArrayObject *data, int flags)
    {
        if(!data) {
            toplevel()->throwArgumentError(kNullArgumentError, "data");
        }

        const void *bytes = &(data->GetByteArray())[0];
        int sent      = 0;
        int totalSent = 0;
        int bytesleft = data->get_length();
        
        while( totalSent < bytesleft ) {
            sent = _socket->Send( (const char *)bytes+totalSent, bytesleft, flags);
            if(sent == -1) {
                break;
            }
            totalSent += sent;
            bytesleft -= sent;
        }

        return sent;
    }

    int SocketObject::_sendTo(Stringp host, Stringp port, ByteArrayObject *data, int flags)
    {
        if(!host) {
            toplevel()->throwArgumentError(kNullArgumentError, "host");
        }

        if(!port) {
            toplevel()->throwArgumentError(kNullArgumentError, "port");
        }

        if(!data) {
            toplevel()->throwArgumentError(kNullArgumentError, "data");
        }

        StUTF8String hostUTF8(host);
        StUTF8String portUTF8(port);
        
        const void *bytes = &(data->GetByteArray())[0];
        int sent  = 0;
        int total = data->get_length();

        sent = _socket->SendTo( hostUTF8.c_str(), portUTF8.c_str(), (const char *)bytes, total, flags);
        //printf( "sendto data is %i bytes\n", total );
        //printf( "sendto sent %i bytes\n", sent );
        
        return sent;
    }
    
    int SocketObject::_receive(int buffer, int flags)
    {
        int result = 0;
        //char data[buffer];
        char *data = new char[buffer];

        _buffer->clear(); //reset the buffer before reading
        
        result = _socket->Receive(data, buffer, flags);
        
        if(result > 0) {
            //printf("recv - Bytes received: %i\n", result);
            _buffer->GetByteArray().Write( data, result );
        }

        delete [] data;
        return result;
    }
    
    int SocketObject::_receiveFrom(int buffer, int flags)
    {
        int result = 0;
        //char data[buffer];
        char *data = new char[buffer];

        _buffer->clear(); //reset the buffer before reading
        
        result = _socket->ReceiveFrom(data, buffer, flags);
        
        if(result > 0) {
            //printf("recvfrom - Bytes received: %d\n", result);
            _buffer->GetByteArray().Write( data, result );
        }

        delete [] data;
        return result;
    }
    
    bool SocketObject::_bind(Stringp host, const int port)
    {
        if(!host) {
            toplevel()->throwArgumentError(kNullArgumentError, "host");
        }

        StUTF8String hostUTF8(host);
        
        return _socket->Bind( hostUTF8.c_str(), port );
    }

    bool SocketObject::_listen(int backlog)
    {
        return _socket->Listen( backlog );
    }


    SocketObject* SocketObject::_accept()
    {
        int sd = _socket->Accept();
        //printf( "socket->Accept sd=%i\n", sd );
        
        SocketClass* sckc  = (SocketClass*)toplevel()->getBuiltinExtensionClass(NativeID::abcclass_avmplus_Socket);
        SocketObject* scko = sckc->constructSocket(sd);
        
        return scko;
    }


    //
    // SocketClass
    //

    SocketClass::SocketClass(VTable *vtable)
        : ClassClosure(vtable)
    {
        createVanillaPrototype();
    }
    
    ScriptObject* SocketClass::createInstance(VTable* ivtable, ScriptObject* prototype)
    {
        return SocketObject::create(ivtable->gc(), ivtable, prototype, -1);
    }

    SocketObject* SocketClass::constructSocket()
    {
        VTable* ivtable = this->ivtable();
        return (SocketObject*)SocketObject::create(ivtable->gc(), ivtable, prototypePtr(), -1);
    }

    SocketObject* SocketClass::constructSocket(int sd)
    {
        VTable* ivtable = this->ivtable();
        return (SocketObject*)SocketObject::create(ivtable->gc(), ivtable, prototypePtr(), sd);
    }

    int SocketClass::get_lastError()
    {
        return Platform::GetInstance()->getLastSocketError();
    }

    int SocketClass::get_maxConcurrentConnection()
    {
        return Platform::GetInstance()->getMaxSelectDescriptor();
    }

}
