/* -*- c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4 -*- */
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

/* Utility to create Eclipse External Tools for redtmarin

   run this tool at the root of an Eclipse workspace
 */

import avmplus.FileSystem;
import avmplus.System;

var usage:String = <![CDATA[
Utility to create Eclipse External Tools for redtmarin

Usage:
  EclipseExternalTools path

Options:
  path   the root directory of an Eclipse worksapce

]]>;

function help()
{
    print( usage );
    System.exit(1);
}

if( System.argv.length != 1 )
{
    help();
}

var source_dir:String = System.argv[0];

if( !FileSystem.exists( source_dir ) )
{
    trace( "\""+source_dir+"\" does not exists." );
    help();
}

if( !FileSystem.isDirectory( source_dir ) )
{
    trace( "\""+source_dir+"\" is not a directory." );
    help();
}

source_dir = FileSystem.ensureEndsWithSeparator( source_dir );

var metadata_dir:String = source_dir + ".metadata";
var launch_dir:String   = source_dir + ".metadata/.plugins/org.eclipse.debug.core/.launches";

//ASC_compile.launch
var ASC_compile:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/asc"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="-AS3 -strict -import builtin.abc -import toplevel.abc ${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/bin/"/>
</launchConfiguration>]]>;

//dump_api.launch
var dump_api:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/abcdump"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="-api ${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/src/"/>
</launchConfiguration>]]>;

//dump_infos.launch
var dump_infos:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/abcdump"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="-i ${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/src/"/>
</launchConfiguration>]]>;

//extract_abc.launch
var extract_abc:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/abcdump"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="-a ${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/src/"/>
</launchConfiguration>]]>;

//make_projector.launch
var make_projector:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/createprojector"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="-exe ../bin/redshell ${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/src/"/>
</launchConfiguration>]]>;

//redshell_debug.launch
var redshell_debug:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/redshell_d"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/src/"/>
</launchConfiguration>]]>;

//redshell_run.launch
var redshell_run:String = <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<launchConfiguration type="org.eclipse.ui.externaltools.ProgramLaunchConfigurationType">
<booleanAttribute key="org.eclipse.debug.core.appendEnvironmentVariables" value="true"/>
<listAttribute key="org.eclipse.debug.ui.favoriteGroups">
<listEntry value="org.eclipse.ui.externaltools.launchGroup"/>
</listAttribute>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_LOCATION" value="${project_loc}/bin/redshell"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS" value="${resource_loc}"/>
<stringAttribute key="org.eclipse.ui.externaltools.ATTR_WORKING_DIRECTORY" value="${project_loc}/src/"/>
</launchConfiguration>]]>;

function createFile( name:String, data:String ):void
{
    trace( "Writing [" + name + "] ." );
    FileSystem.write( name, data );
}

function createLaunchFiles():void
{
    var dir:String = FileSystem.ensureEndsWithSeparator( launch_dir );

    createFile( dir+"ASC_compile.launch",    ASC_compile);
    createFile( dir+"dump_api.launch",       dump_api );
    createFile( dir+"dump_infos.launch",     dump_infos );
    createFile( dir+"extract_abc.launch",    extract_abc );
    createFile( dir+"make_projector.launch", make_projector );
    createFile( dir+"redshell_debug.launch", redshell_debug );
    createFile( dir+"redshell_run.launch",   redshell_run );
}

var created:Boolean = false;

if( FileSystem.exists( metadata_dir ) )
{
    if( FileSystem.exists( launch_dir ) )
    {
        createLaunchFiles();
        System.exit(0);
    }
    else
    {
        created = FileSystem.createDirectory( launch_dir );
        
        if( created )
        {
            createLaunchFiles();
            System.exit(0);
        }
    }
}
else
{
    created = FileSystem.createDirectory( launch_dir );
    
    if( created )
    {
        createLaunchFiles();
        System.exit(0);
    }
}

trace( "An error occured" );
System.exit(1);



