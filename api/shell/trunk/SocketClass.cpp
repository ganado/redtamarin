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

    SocketObject::SocketObject(VTable *vtable, ScriptObject *delegate, int sockd)
        : ScriptObject(vtable, delegate)
    {
        if( sockd == -1 )
        {
            socket = Platform::GetInstance()->createSocket();
        }
        else
        {
            socket = Platform::GetInstance()->createSocketFrom( sockd );
        }
        
        lastDataSent = 0;
        received_buffer[0] = '\0';

        ByteArrayClass *ba = (ByteArrayClass*)toplevel()->getBuiltinExtensionClass(NativeID::abcclass_flash_utils_ByteArray);
        Atom args[1] = {nullObjectAtom};
        received_binary = (ByteArrayObject*)AvmCore::atomToScriptObject(ba->construct(0, args));
        received_binary->setLength(0);
    }

    SocketObject::~SocketObject()
    {
        Platform::GetInstance()->destroySocket(socket);
        socket = NULL;
        lastDataSent = 0;
        received_buffer[0] = '\0';
        received_binary = NULL;
    }

    int SocketObject::get_lastDataSent()
    {
        return lastDataSent;
    }

    Stringp SocketObject::get_receivedBuffer()
    {
        return core()->newStringUTF8( received_buffer );
    }

    ByteArrayObject *SocketObject::get_receivedBinary()
    {
        return received_binary;
    }

    int SocketObject::get__type()
    {
        return socket->GetType();
    }

    bool SocketObject::get_reuseAddress()
    {
        return socket->GetReuseAddress();
    }

    void SocketObject::set_reuseAddress(bool value)
    {
        socket->SetReuseAddress(value);
    }

    bool SocketObject::get_broadcast()
    {
        return socket->GetBroadcast();
    }

    void SocketObject::set_broadcast(bool value)
    {
        socket->SetBroadcast(value);
    }
    


    bool SocketObject::isValid()
    {
        return socket->IsValid();
    }


    void SocketObject::_customSocket(int family, int socktype, int protocol)
    {
        Platform::GetInstance()->destroySocket(socket);
        socket = Platform::GetInstance()->createCustomSocket(family, socktype, protocol);
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
        return socket->Connect(hostUTF8.c_str(), portUTF8.c_str());
    }

    bool SocketObject::_close()
    {
        return socket->Shutdown();
    }

    int SocketObject::_send(Stringp data, int flags)
    {
        if(!data) {
            toplevel()->throwArgumentError(kNullArgumentError, "data");
        }

        StUTF8String dataUTF8(data);
        
        int totalSent = 0;
        int bytesleft = VMPI_strlen(dataUTF8.c_str());
        int sent      = 0;
        
        while( totalSent < bytesleft ) {
            sent = socket->Send( dataUTF8.c_str()+totalSent, bytesleft, flags);
            if(sent == -1) {
                lastDataSent = totalSent;
                break;
            }
            totalSent += sent;
            bytesleft -= sent;
        }
        
        return sent;
    }

    int SocketObject::_sendBinary(ByteArrayObject *data, int flags)
    {
        if(!data) {
            toplevel()->throwArgumentError(kNullArgumentError, "data");
        }
        
        const void *bytes = &(data->GetByteArray())[0];
        int totalSent = 0;
        int bytesleft = data->get_length();
        int sent      = 0;
        printf( "bytesleft = %i", bytesleft );
        
        while( totalSent < bytesleft ) {
            sent = socket->Send( (const char *)bytes+totalSent, bytesleft, flags);
            if(sent == -1) {
                lastDataSent = totalSent;
                break;
            }
            totalSent += sent;
            bytesleft -= sent;
        }

        return sent;
    }


    int SocketObject::_receive(int flags)
    {
        int result = 0;
        char buffer[1024];
        int len = 1024-1;

        //received_buffer[0] = '\0'; //reset the received buffer;
        VMPI_memset(&received_buffer, 0, sizeof(received_buffer));
        
        result = socket->Receive(buffer, len, flags);
        
        if(result > 0) {
            //printf("recv - Bytes received: %d\n", result);
            VMPI_memcpy( received_buffer, buffer, result );
        }
        
        return result;
    }

    int SocketObject::_receiveBinary(int flags)
    {
        int result = 0;
        char buffer[1024];
        int len = 1024-1;

        received_binary->setLength(0); //reset the received buffer
        
        result = socket->Receive(buffer, len, flags);

        if(result > 0) {
            //printf("recv - Bytes received: %d\n", result);
            received_binary->fill( buffer, result );
        }

        return result;
    }

    bool SocketObject::_bind(const int port)
    {
        return socket->Bind( port );
    }

    bool SocketObject::_listen(int backlog)
    {
        return socket->Listen( backlog );
    }


    SocketObject* SocketObject::_accept()
    {
        int sd = socket->Accept();
        
        SocketClass* sckc  = (SocketClass*)toplevel()->getBuiltinExtensionClass(NativeID::abcclass_avmplus_Socket);
        SocketObject *scko = sckc->newSocket(sd);
        
        return scko;
    }



    SocketClass::SocketClass(VTable *cvtable)
        : ClassClosure(cvtable)
    {
        createVanillaPrototype();
    }

    ScriptObject* SocketClass::createInstance(VTable *ivtable, ScriptObject *prototype)
    {
        return new (core()->GetGC(), ivtable->getExtraSize()) SocketObject(ivtable, prototype, -1);
    }

    SocketObject* SocketClass::newSocket()
    {
        VTable* ivtable = this->ivtable();
        SocketObject *so = new (core()->GetGC(), ivtable->getExtraSize())
            SocketObject(ivtable, prototypePtr(), -1);
        return so;
    }

    SocketObject* SocketClass::newSocket(int sd)
    {
        VTable* ivtable = this->ivtable();
        SocketObject *so = new (core()->GetGC(), ivtable->getExtraSize())
            SocketObject(ivtable, prototypePtr(), sd);
        return so;
    }

    int SocketClass::get_lastError()
    {
        return Platform::GetInstance()->lastSocketError();
    }

}
