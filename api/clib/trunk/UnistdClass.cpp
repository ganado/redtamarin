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

    UnistdClass::UnistdClass(VTable *cvtable)
    : ClassClosure(cvtable)
    {
        createVanillaPrototype();
    }

    UnistdClass::~UnistdClass()
    {
        
    }

    int UnistdClass::get_F_OK()
    {
        return F_OK;
    }
    
    int UnistdClass::get_X_OK()
    {
        return X_OK;
    }
    
    int UnistdClass::get_W_OK()
    {
        return W_OK;
    }
    
    int UnistdClass::get_R_OK()
    {
        return R_OK;
    }


    int UnistdClass::get_S_IFMT()
    {
        return S_IFMT;
    }

    int UnistdClass::get_S_IFIFO()
    {
        return S_IFIFO;
    }

    int UnistdClass::get_S_IFCHR()
    {
        return S_IFCHR;
    }

    int UnistdClass::get_S_IFDIR()
    {
        return S_IFDIR;
    }

    int UnistdClass::get_S_IFBLK()
    {
        return S_IFBLK;
    }

    int UnistdClass::get_S_IFREG()
    {
        return S_IFREG;
    }

    int UnistdClass::get_S_IFLNK()
    {
        return S_IFLNK;
    }

    int UnistdClass::get_S_IFSOCK()
    {
        return S_IFSOCK;
    }


    int UnistdClass::get_S_IRWXU()
    {
        return S_IRWXU;
    }

    int UnistdClass::get_S_IRUSR()
    {
        return S_IRUSR;
    }

    int UnistdClass::get_S_IWUSR()
    {
        return S_IWUSR;
    }

    int UnistdClass::get_S_IXUSR()
    {
        return S_IXUSR;
    }


    int UnistdClass::get_S_IRWXG()
    {
        return S_IRWXG;
    }

    int UnistdClass::get_S_IRGRP()
    {
        return S_IRGRP;
    }

    int UnistdClass::get_S_IWGRP()
    {
        return S_IWGRP;
    }

    int UnistdClass::get_S_IXGRP()
    {
        return S_IXGRP;
    }


    int UnistdClass::get_S_IRWXO()
    {
        return S_IRWXO;
    }

    int UnistdClass::get_S_IROTH()
    {
        return S_IROTH;
    }

    int UnistdClass::get_S_IWOTH()
    {
        return S_IWOTH;
    }

    int UnistdClass::get_S_IXOTH()
    {
        return S_IXOTH;
    }


    int UnistdClass::get_S_IREAD()
    {
        return S_IREAD;
    }
    
    int UnistdClass::get_S_IWRITE()
    {
        return S_IWRITE;
    }
    
    int UnistdClass::get_S_IEXEC()
    {
        return S_IEXEC;
    }




    int UnistdClass::access(Stringp path, int mode)
    {
        if (!path) {
            toplevel()->throwArgumentError(kNullArgumentError, "path");
        }
        
        StUTF8String pathUTF8(path);
        return VMPI_access(pathUTF8.c_str(), mode);
    }

    int UnistdClass::chmod(Stringp path, int mode)
    {
        if (!path) {
            toplevel()->throwArgumentError(kNullArgumentError, "path");
        }
        
        StUTF8String pathUTF8(path);
        return VMPI_chmod(pathUTF8.c_str(), mode);
    }

    Stringp UnistdClass::getcwd()
    {
        char path[256];
        VMPI_getcwd(path, (size_t)256);
        return core()->newStringUTF8( path );
    }

    Stringp UnistdClass::gethostname()
    {
        char hostname[256];
        VMPI_gethostname(hostname, (size_t)256);
        return core()->newStringUTF8( hostname );
    }

    Stringp UnistdClass::getlogin()
    {
        char username[256];
        VMPI_getUserName( username );
        return core()->newStringUTF8( username );
    }

    int UnistdClass::mkdir(Stringp path)
    {
        if (!path) {
            toplevel()->throwArgumentError(kNullArgumentError, "path");
        }
        
        StUTF8String pathUTF8(path);
        return VMPI_mkdir(pathUTF8.c_str());
    }
    
    int UnistdClass::rmdir(Stringp path)
    {
        if (!path) {
            toplevel()->throwArgumentError(kNullArgumentError, "path");
        }
        
        StUTF8String pathUTF8(path);
        return VMPI_rmdir(pathUTF8.c_str());
    }

    void UnistdClass::sleep(int milliseconds)
    {
        VMPI_sleep(milliseconds);
    }

}
