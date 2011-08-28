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

#ifndef __avmshell_CErrnoClass__
#define __avmshell_CErrnoClass__

namespace avmshell
{

    class CErrnoClass : public ClassClosure
    {
    public:
        CErrnoClass(VTable* cvtable);
        ~CErrnoClass();

        int get_EDOM();
        int get_EILSEQ();
        int get_ERANGE();

        int get_EPERM();
        int get_ENOENT();
        int get_ESRCH();
        int get_EINTR();
        int get_EIO();
        int get_ENXIO();
        int get_E2BIG();
        int get_ENOEXEC();
        int get_EBADF();
        int get_ECHILD();
        int get_EAGAIN();
        int get_ENOMEM();
        int get_EACCES();
        int get_EFAULT();
        int get_EBUSY();
        int get_EEXIST();
        int get_EXDEV();
        int get_ENODEV();
        int get_ENOTDIR();
        int get_EISDIR();
        int get_EINVAL();
        int get_ENFILE();
        int get_EMFILE();
        int get_ENOTTY();
        int get_EFBIG();
        int get_ENOSPC();
        int get_ESPIPE();
        int get_EROFS();
        int get_EMLINK();
        int get_EPIPE();
        int get_EDEADLK();
        int get_ENAMETOOLONG();
        int get_ENOLCK();
        int get_ENOSYS();
        int get_ENOTEMPTY();

        int get_ENETDOWN();
        int get_ENETUNREACH();
        int get_ENETRESET();
        int get_ECONNABORTED();
        int get_ECONNRESET();
        int get_ENOBUFS();
        int get_EISCONN();
        int get_ENOTCONN();
        int get_ESHUTDOWN();
        int get_ETOOMANYREFS();
        int get_ETIMEDOUT();
        int get_ECONNREFUSED();
        
        int GetErrno();
        void SetErrno(int value);

        DECLARE_SLOTS_CErrnoClass;
    };

}

#endif /* __avmshell_CErrnoClass__ */

