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

#ifndef __avmshell_SocketClass__
#define __avmshell_SocketClass__

namespace avmshell
{
    
    class SocketObject : public ScriptObject
    {
    public:
        SocketObject(VTable* vtable, ScriptObject* delegate, int sockd);

        REALLY_INLINE static SocketObject* create(MMgc::GC* gc, VTable* ivtable, ScriptObject* delegate, int sockd)
        {
            return new (gc, ivtable->getExtraSize()) SocketObject(ivtable, delegate, sockd);
        }

        ~SocketObject();

        int get_descriptor();
        int get__type();
        bool get_blocking();
        void set_blocking(bool value);
        bool get_reuseAddress();
        void set_reuseAddress(bool value);
        bool get_broadcast();
        void set_broadcast(bool value);
        int get_receiveTimeout();
        void set_receiveTimeout(int value);
        int get_sendTimeout();
        void set_sendTimeout(int value);

        ByteArrayObject *_getBuffer();
        void _setNoSigPipe();
        bool _isValid();
        int _isReadable(int timeout);
        int _isWritable(int timeout);
        int _isExceptional(int timeout);
        void _customSocket(int family, int socktype, int protocol);
        bool _connect(Stringp host, Stringp port);
        bool _close();
        int _send(ByteArrayObject *data, int flags);
        int _sendTo(Stringp host, Stringp port, ByteArrayObject *data, int flags);
        int _receive(int buffer, int flags);
        int _receiveFrom(int buffer, int flags);
        bool _bind(Stringp host, const int port);
        bool _listen(int backlog);
        SocketObject* _accept();

    private:
        Socket* _socket;
        DRCWB(ByteArrayObject*) _buffer;
        
        DECLARE_SLOTS_SocketObject;
    };
    
    class SocketClass : public ClassClosure
    {
    public:
        SocketClass(VTable *vtable);
        ~SocketClass() { }

        SocketObject* constructSocket();
        SocketObject* constructSocket(int sd);
        
        ScriptObject* createInstance(VTable* ivtable, ScriptObject* delegate);

        bool isSupported();
        Stringp get_version();
        int get_lastError();
        int get_maxConcurrentConnection();

        DECLARE_SLOTS_SocketClass;
    };

}

#endif /* __avmshell_SocketClass__ */

