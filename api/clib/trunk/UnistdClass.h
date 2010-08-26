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

#ifndef __avmshell_UnistdClass__
#define __avmshell_UnistdClass__

namespace avmshell
{

    class UnistdClass : public ClassClosure
    {
    public:
        UnistdClass(VTable* cvtable);
        ~UnistdClass();

        int get_F_OK();
        int get_X_OK();
        int get_W_OK();
        int get_R_OK();

        int get_S_IFMT();
        int get_S_IFIFO();
        int get_S_IFCHR();
        int get_S_IFDIR();
        int get_S_IFBLK();
        int get_S_IFREG();
        int get_S_IFLNK();
        int get_S_IFSOCK();

        int get_S_IRWXU();
        int get_S_IRUSR();
        int get_S_IWUSR();
        int get_S_IXUSR();

        int get_S_IRWXG();
        int get_S_IRGRP();
        int get_S_IWGRP();
        int get_S_IXGRP();
        
        int get_S_IRWXO();
        int get_S_IROTH();
        int get_S_IWOTH();
        int get_S_IXOTH();

        int get_S_IREAD();
        int get_S_IWRITE();
        int get_S_IEXEC();
        

        int access(Stringp path, int mode);
        int chmod(Stringp path, int mode);
        Stringp getcwd();
        Stringp gethostname();
        int mkdir(Stringp path);
        int rmdir(Stringp path);



        DECLARE_SLOTS_UnistdClass;
    };

}

#endif /* __avmshell_UnistdClass__ */

