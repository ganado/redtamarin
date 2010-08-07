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

    CErrnoClass::CErrnoClass(VTable *cvtable)
    : ClassClosure(cvtable)
    {
        createVanillaPrototype();
    }

    CErrnoClass::~CErrnoClass()
    {
        
    }

    int CErrnoClass::get_EDOM()
    {
        return EDOM;
    }
    
    int CErrnoClass::get_EILSEQ()
    {
        return EILSEQ;
    }
    
    int CErrnoClass::get_ERANGE()
    {
        return ERANGE;
    }

    int CErrnoClass::get_EPERM()
    {
        return EPERM;
    }

    int CErrnoClass::get_ENOENT()
    {
        return ENOENT;
    }

    int CErrnoClass::get_ESRCH()
    {
        return ESRCH;
    }

    int CErrnoClass::get_EINTR()
    {
        return EINTR;
    }

    int CErrnoClass::get_EIO()
    {
        return EIO;
    }

    int CErrnoClass::get_ENXIO()
    {
        return ENXIO;
    }

    int CErrnoClass::get_E2BIG()
    {
        return E2BIG;
    }

    int CErrnoClass::get_ENOEXEC()
    {
        return ENOEXEC;
    }

    int CErrnoClass::get_EBADF()
    {
        return EBADF;
    }

    int CErrnoClass::get_ECHILD()
    {
        return ECHILD;
    }

    int CErrnoClass::get_EAGAIN()
    {
        return EAGAIN;
    }

    int CErrnoClass::get_ENOMEM()
    {
        return ENOMEM;
    }

    int CErrnoClass::get_EACCES()
    {
        return EACCES;
    }

    int CErrnoClass::get_EFAULT()
    {
        return EFAULT;
    }

    int CErrnoClass::get_EBUSY()
    {
        return EBUSY;
    }

    int CErrnoClass::get_EEXIST()
    {
        return EEXIST;
    }

    int CErrnoClass::get_EXDEV()
    {
        return EXDEV;
    }

    int CErrnoClass::get_ENODEV()
    {
        return ENODEV;
    }

    int CErrnoClass::get_ENOTDIR()
    {
        return ENOTDIR;
    }

    int CErrnoClass::get_EISDIR()
    {
        return EISDIR;
    }

    int CErrnoClass::get_EINVAL()
    {
        return EINVAL;
    }

    int CErrnoClass::get_ENFILE()
    {
        return ENFILE;
    }

    int CErrnoClass::get_EMFILE()
    {
        return EMFILE;
    }

    int CErrnoClass::get_ENOTTY()
    {
        return ENOTTY;
    }

    int CErrnoClass::get_EFBIG()
    {
        return EFBIG;
    }

    int CErrnoClass::get_ENOSPC()
    {
        return ENOSPC;
    }

    int CErrnoClass::get_ESPIPE()
    {
        return ESPIPE;
    }

    int CErrnoClass::get_EROFS()
    {
        return EROFS;
    }

    int CErrnoClass::get_EMLINK()
    {
        return EMLINK;
    }

    int CErrnoClass::get_EPIPE()
    {
        return EPIPE;
    }

    int CErrnoClass::get_EDEADLK()
    {
        return EDEADLK;
    }

    int CErrnoClass::get_ENAMETOOLONG()
    {
        return ENAMETOOLONG;
    }

    int CErrnoClass::get_ENOLCK()
    {
        return ENOLCK;
    }

    int CErrnoClass::get_ENOSYS()
    {
        return ENOSYS;
    }

    int CErrnoClass::get_ENOTEMPTY()
    {
        return ENOTEMPTY;
    }


    int CErrnoClass::get_errno()
    {
        return errno;
    }
    
    void CErrnoClass::set_errno(int value)
    {
        errno = value;
    }


}
