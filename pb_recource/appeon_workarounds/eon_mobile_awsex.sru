forward
global type eon_mobile_awsex from eon_mobile_aws
end type
end forward

global type eon_mobile_awsex from eon_mobile_aws
end type
global eon_mobile_awsex eon_mobile_awsex

forward prototypes
public function integer of_log (string as_info)
public function integer of_getassistivetouchmode ()
public function integer of_getapporientation ()
public function integer of_log (integer ai_level, string as_info)
public function integer of_setassistivetouchmode (integer ai_mode)
public function integer of_setapporientation (integer ai_mode)
public function integer of_clearlog ()
public function integer of_setassistivetouchbtnvisible (integer ai_mode)
public function integer of_settitlebarvisible (integer ai_mode)
public function integer of_getversion (ref string as_version)
public function integer of_getappinfo (ref string as_appname, ref string as_appurl)
public function integer of_getassistivetouchbtnvisible ()
public function integer of_gettitlebarvisible ()
public function integer of_getapprotationlock ()
public function integer of_setapprotationlock (integer ai_mode)
public function integer of_sendmail (eon_mobile_str_mailcontent astr_content, string as_recipient[], string as_cc[], string as_bcc[], string as_attachmentfile[])
public function integer of_getcloseappiconvisible ()
public function integer of_getwindowlisticonvisible ()
public function integer of_setwindowlisticonvisible (integer ai_mode)
public function integer of_setcloseappiconvisible (integer ai_mode, string as_title, string as_message)
public function integer of_getdwmousemovemode ()
public function integer of_setdwmousemovemode (integer ai_mode)
public function integer of_getworkspaceheight ()
public function integer of_getworkspacewidth ()
public function long of_setlongpressinterval (long al_interval)
public function integer of_checkpermissionfornet (string as_workspaceid, string as_appname)
public function integer of_getworkspaceidappname (ref string as_workspaceid, ref string as_appname)
end prototypes

public function integer of_log (string as_info);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_log
//------------------------------------------------------------------------------
// Description: 
//		Adds the log information to the Appeon WorkSpace log, and the default logging level is info. 
//		Supported on mobile client only.		
// 
// Arguments:
//		value    string     as_info
//								  log information. 	
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return 

li_return = of_log(4,as_info)

return li_return
end function

public function integer of_getassistivetouchmode ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getassistivetouchmode
//------------------------------------------------------------------------------
// Description: 
//		Gets the current assistive touch mode.
//		Supported on mobile client only.	
//
// Arguments: None
//	
// Returns:	integer
//					 0 - The assistive touch mode is Left-click.
//					 1 - The assistive touch mode is Right-click.
//					 2 - The assistive touch mode is Drag.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getassistivetouchmode()
else
	li_return = -1
end if

return li_return
end function

public function integer of_getapporientation ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getapporientation
//------------------------------------------------------------------------------
// Description: 
//		Detects if the application currently running in Appeon Workspace screen orientation is Landscape or Portrait. 
//		Supported on mobile client only.	
// 
// Arguments: None
//	
// Returns:  integer
//					0 - Unknown.
//					1 - Portrait.
//					2 - Landscape.
//				  -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getapporientation()
else
	li_return = -1
end if

return li_return
end function

public function integer of_log (integer ai_level, string as_info);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_log
//------------------------------------------------------------------------------
// Description: 
//		Adds log into the Appeon WorkSpace log. 
//		Supported on mobile client only.		
// 
// Arguments:
//		value    integer    ai_level
//					1 - FATAL level.
//					2 - ERROR level.
//					3 - WARNING level.
//					4 - INFO level.
//					5 - DEBUG level. 
//
//		value    string     as_info
//					The log information. 	
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(ai_level) or isnull(as_info)  then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_log(ai_level,as_info)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_setassistivetouchmode (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setassistivetouchmode
//------------------------------------------------------------------------------
// Description: 
//		Sets the assistive touch mode.
//		Supported on mobile client only.
//
// Arguments:
//		value    integer    ai_mode
//					0 - Sets to the Left-click mode.
//					1 - Sets to the Right-click mode.
//					2 - Sets to the Drag mode.
//
// Returns:  Integer.
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(ai_mode) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_setassistivetouchmode(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_setapporientation (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setapporientation
//------------------------------------------------------------------------------
// Description: 
//		Sets the screen orientation of the application currently running in Appeon Workspace. 
//    If of_setapprotationlock is executed to lock the application screen orientation before 
//		of_setapporientation is called, then of_setapporientaion will not take effect and return -1.
//		This functionality has no impact on the screen orientation of the device. 
//		Supported on mobile client only.		
// 
// Arguments:
//		value    integer    ai_mode	
//					1 - Sets screen orientation to Portrait.
//					2 - Sets screen orientation to Landscape.
//	
// Returns:  Integer.
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(ai_mode) then
	li_return =  -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_setapporientation(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_clearlog ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_clearlog
//------------------------------------------------------------------------------
// Description:
//		Clears the Appeon WorkSpace log information.
//		Supported on mobile client only.			
// 
// Arguments: None
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_clearlog()
else
	li_return = -1
end if

return li_return
end function

public function integer of_setassistivetouchbtnvisible (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setassistivetouchbtnvisible
//------------------------------------------------------------------------------
// Description: 
//		Sets whether the assistive touch bar is visible.
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Sets the assistive touch bar to be visible.
//					0 - Sets the assistive touch bar to be invisible.	
//	
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(ai_mode) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_setassistivetouchbtnvisible(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_settitlebarvisible (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_settitlebarvisible
//------------------------------------------------------------------------------
// Description: 
//		Sets whether the Appeon WorkSpace title bar is visible or invisible. 
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Sets the title bar to be visible.
//					0 - Sets the title bar to be invisible, and displays the normal view icon which when tapped can show the title bar again.
//					2 - Sets the title bar to be invisible, and displays no icon for showing the title bar.
//
// Returns:  Integer.
//					1 - Success.
//				  -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(ai_mode) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_settitlebarvisible(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_getversion (ref string as_version);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getversion
//------------------------------------------------------------------------------
// Description: 
//		Gets the version number of Appeon WorkSpace. 
//		Supported on mobile client only.		
// 
// Arguments:
//		reference    string		as_version
//		Returns the Appeon WorkSpace version number; returns empty string if it is called in PowerBuilder or Appeon Web or if there is any error. 
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(as_version) then
	li_return =  -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getversion(as_version)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_version = ""
end if

return li_return
end function

public function integer of_getappinfo (ref string as_appname, ref string as_appurl);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getappinfo
//------------------------------------------------------------------------------
// Description: 
//		Gets the information of the current application in Appeon WorkSpace.
//		Supported on mobile client only.		
// 
// Arguments:
//		reference    string		as_appname
//		Returns the name of the current application in Appeon WorkSpace;
//		returns empty string if it is called in PowerBuilder or Appeon Web or if there is any error. 
//
//		reference    string 		as_appurl
//		Returns the value of the "App URL" setting of the current application in Appeon WorkSpace;
//		returns empty string if it is called in PowerBuilder or Appeon Web or if there is any error.
//	
// Returns:  integer
//					 1 - Success.
//				  	-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(as_appname) or isnull(as_appurl) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getappinfo(as_appname,as_appurl)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_appname = ""
	as_appurl = ""
end if

return li_return
end function

public function integer of_getassistivetouchbtnvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getassistivetouchbtnvisible
//------------------------------------------------------------------------------
// Description: 
//		Detects if the assistive touch bar is visible.
//		Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns:	integer. 
//					 1 - The assistive touch bar is visible.
//					 0 - The assistive touch bar is invisible.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.				
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getassistivetouchbtnvisible()
else	
	li_return = -1
end if

return li_return
end function

public function integer of_gettitlebarvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_gettitlebarvisible
//------------------------------------------------------------------------------
// Description: 
//		Detects if the Appeon WorkSpace title bar is visible or invisible. 
//		Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns: integer. 
//					 1 - The title bar is visible.
//					 0 - The title bar is invisible but the normal view icon is visible.
//					 2 - The title bar is invisible and the normal view icon is invisible.
//					 -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_gettitlebarvisible()
else	
	li_return = -1
end if

return li_return
end function

public function integer of_getapprotationlock ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getapprotationlock
//------------------------------------------------------------------------------
// Description: 
//               Detects if the screen orientation for the application currently running in Appeon Workspace is locked. 
//               Supported on mobile client only.
// 
// Arguments: None
//      
// Returns:       integer 
// 						 1 - Locked.
//							 0 - Unlocked.
//							-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
         li_return = super::of_getapprotationlock()
else
         li_return = -1
end if

return li_return

end function

public function integer of_setapprotationlock (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setapprotationlock
//------------------------------------------------------------------------------
// Description: 
//    Sets whether to lock the screen orientation of the application currently running in Appeon Workspace. 
//    If of_setapprotationlock is executed to lock the application screen orientation before 
//		of_setapporientation is called, then of_setapporientaion will not take effect and return -1.
//    This functionality has no impact on the screen orientation of the device.
//    Supported on mobile client only.
// 
// Arguments:
//				 value    integer    ai_mode
//					1 - Locks the screen orientation of Appeon WorkSpace.
//					0 - UnLocks the screen orientation of Appeon WorkSpace.
//
// Returns:  Integer.
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================

integer li_return

if isnull(ai_mode) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		  li_return = super::of_setapprotationlock(ai_mode)
	else
		  li_return = -1
	end if
end if

return li_return

end function

public function integer of_sendmail (eon_mobile_str_mailcontent astr_content, string as_recipient[], string as_cc[], string as_bcc[], string as_attachmentfile[]);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_sendmail
//------------------------------------------------------------------------------
// Description: 
// Send a mail.
//	Only supported on mobile client.		
// 
// Arguments:
//		value    eon_mobile_str_mailcontent    astr_content
//
//    			Variable list of the eon_mobile_str_mailcontent struct
//						Integer s_subject, specifies the subject of the mail.
//						Integer s_notetext, specifies the content of the mail body.
//						Boolean b_html, sets if the mail format is HTML. 
//
//		value    string                        as_recipient[], specifies the recipient list of the mail
//		value    string                        as_cc[],  specifies the Cc recipient list of the mail
//		value    string                        as_bcc[], specifies the Bcc recipient list of the mail
//		value    string                        as_attachmentfile[]	attachment file path list
//	
// Returns:  integer.
//		 The following return values are effective for the iOS device only. On the Android device,
//		 0 will be returned under all circumstances, because the corresponding mail API from the Android SDK returns no standardized value.
//					 1 - Sent the mail successfully.
//					 0 - Cancelled sending the mail.
//					-1 - Failed to send the mail, or it is called in PowerBuilder or Appeon Web, or there is an error.
//					-2 - The mail account is not configured.
//					-100 - System error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(astr_content) or isnull(as_recipient)  then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_sendmail(astr_content, as_recipient, as_cc, as_bcc, as_attachmentfile)
	else	
		li_return = -1
	end if
end if


return li_return
end function

public function integer of_getcloseappiconvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getcloseappiconvisible
//------------------------------------------------------------------------------
// Description: 
//		Detects if the close app icon is visible or not.
//		Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns:	integer. 
//					 1 - The close app icon is visible.
//					 0 - The close app icon is invisible.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.				
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getcloseappiconvisible()
else
	li_return = -1
end if

return li_return
end function

public function integer of_getwindowlisticonvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getwindowlisticonvisible
//------------------------------------------------------------------------------
// Description: 
//		Detects if the window list icon is visible or not.
//		Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns:	integer. 
//					 1 - The window list icon is visible.
//					 0 - The window list icon is invisible.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.				
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getwindowlisticonvisible()
else
	li_return = -1
end if

return li_return
end function

public function integer of_setwindowlisticonvisible (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setwindowlisticonvisible
//------------------------------------------------------------------------------
// Description: 
//		Sets whether the window list icon is visible or not.
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Sets the window list icon to be visible.
//					0 - Sets the window list icon to be invisible.	
//	
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(ai_mode) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_setwindowlisticonvisible(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_setcloseappiconvisible (integer ai_mode, string as_title, string as_message);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setcloseappiconvisible
//------------------------------------------------------------------------------
// Description: 
//		Sets whether the close app icon is visible.
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Sets the close app icon to be visible.
//					0 - Sets the close app icon to be invisible.	
//		value    string    as_title
//					The title that displays in the dialog box which pops up when the Close App icon is tapped. 
//		value    string    as_message
//					The message that displays in the dialog box which pops up when the Close App icon is tapped. 
//					A Yes/No button will be displayed in the dialog box. When Yes is tapped, the app will be closed. 
//					When No is tapped, the app will not be closed and will continue running.
//					If as_message is null or blank, then no message box will be displayed and the app will be closed immediately.
//	
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(ai_mode) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_setcloseappiconvisible(ai_mode,as_title,as_message)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_getdwmousemovemode ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getdwmousemovemode
//------------------------------------------------------------------------------
// Description: 
//		Detects if the pbm_dwnmousemove event ID of DataWindow is supported.
//		Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns:	integer. 
//					 1 - Supported.
//					 0 - Unsupported.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.				
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getdwmousemovemode()
else
	li_return = -1
end if

return li_return
end function

public function integer of_setdwmousemovemode (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setdwmousemovemode
//------------------------------------------------------------------------------
// Description: 
//		Sets whether to support the pbm_dwnmousemove event ID of DataWindow.
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Supported.
//					0 - Unsupported.	
//	
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(ai_mode) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_setdwmousemovemode(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_getworkspaceheight ();//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getworkspaceheight
//------------------------------------------------------------------------------
// Description: 
//               Return the height of Appeon Workspace. 
//               Supported on mobile client only.               
// 
// Arguments: None
//      
// Returns: integer. 
//               The height of Appeon Workspace.
//               -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2015-07
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================
integer li_return
if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getworkspaceheight()
else
	li_return = -1
end if
return li_return
end function

public function integer of_getworkspacewidth ();//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getworkspacewidth
//------------------------------------------------------------------------------
// Description: 
//               Return the width of Appeon Workspace. 
//               Supported on mobile client only.               
// 
// Arguments: None
//      
// Returns: integer. 
//               The width of Appeon Workspace.
//               -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2015-07
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================
integer li_return
if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getworkspacewidth()
else
	li_return = -1
end if
return li_return
end function

public function long of_setlongpressinterval (long al_interval);//============================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_setlongpressinterval
//------------------------------------------------------------------------------------------------------------
// Description: 
//          Sets the duration (in milliseconds) for a press before it is recognized as a long press. 
//				Once this long press duration is reached, the keyboard will be brought up to display (by default, 
//				the keyboard pops up only when the user taps twice in the field of the DataWindow).
//          Supported on mobile client only.  	
// 
// Arguments:
//		value    long    al_interval
//					1 - Sets the duration in milliseconds. If it is set to a value smaller than 500 milliseconds, 
//						 then 550 milliseconds will be used, because 500 milliseconds is already used as the duration 
//						 for the DataWindow drag & drop event.If this function is not called, the default value that
//						 Appeon uses is 1500 milliseconds when long press will be recognized and keyboard will be displayed.
//	
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-04
//------------------------------------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//===============================================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_setlongpressinterval(al_interval)
else
	li_return = -1
end if

return li_return
end function

public function integer of_checkpermissionfornet (string as_workspaceid, string as_appname);//========================================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_checkpermissionfornet
//------------------------------------------------------------------------------
// Description: 
//               Checks if the app in Appeon Workspace has permissions to access the .NET/IIS server.
//               Supported on mobile client only.               
// 
// Arguments:
//               value    string    as_workspaceid
//               						ID of Appeon Workspace
//
//               value    string    as_appname
//               						Name of the application installed in Appeon Workspace
//      
// Returns:  integer
//               	-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//               	-2 - Server is not .NET/IIS server.
//              	-3 - Failed to get the application name from Appeon Workspace.
//              	-6 - Failed to execute AppeonDotNetComponent.of_ExecInterface.
//              	 1 - The app has permissions to access the server.
//              	20 - Appeon Workspace ID does not exist.
//              	10 - Appeon Workspace ID exists, but is disabled.
//              	11 - Appeon Workspace ID and the app is not associated.
//              	30 - Other reasons.		
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2016-07
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//========================================================================================

integer li_return
AppeonDotNetComponent lo_AppeonDotNetComponent
Any la_l[] 

IF appeongetclienttype() = "MOBILE" THEN
	li_return =  appeongetservertype()
	IF li_return = 2 THEN
		 li_return = of_getworkspaceidappname(as_workspaceid,as_appname)	
		 IF li_return = 1 THEN                
				la_l[1] = as_workspaceid 
				la_l[2] = as_appname
				lo_AppeonDotNetComponent = Create AppeonDotNetComponent
				lo_AppeonDotNetComponent.ComponentType = "4" 
				lo_AppeonDotNetComponent.TypeLib = "" 
				lo_AppeonDotNetComponent.ClassDescript = ""
				li_return = lo_AppeonDotNetComponent.of_ExecInterface("EonCheckAWSSecurity",la_l) 
				IF li_return = 0 THEN                              
					CHOOSE CASE string(lo_AppeonDotNetComponent.ReturnValue)
						CASE "0"
							li_return = 1
						CASE "1"
							li_return = 20
						CASE "2"
							li_return = 10		
						CASE "3"
							li_return = 11		 
						CASE "4"
							li_return = 30						
					END CHOOSE
				ELSE				
					li_return = -6
				END IF	
				DESTROY lo_AppeonDotNetComponent
		ELSE
				 li_return = -3 
		END IF
	ELSE
		li_return = -2
	END IF
ELSE
         li_return = -1
END IF

RETURN	li_return

end function

public function integer of_getworkspaceidappname (ref string as_workspaceid, ref string as_appname);//========================================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_awsex::of_getworkspaceidappname
//------------------------------------------------------------------------------
// Description: 
// 				Gets the Appeon Workspace ID and the name of the application currently running in 
// 				Appeon Workspace. The Appeon Workspace ID is based on the device's unique identifier 
// 				which depends on the device manufacturer, product type, and operating system.
// 				Supported on mobile client only.               
// 
// Arguments:
//             reference    string    as_workspaceid
//               					The Appeon Workspace ID
//
//             reference    string    as_appname
//               					The name of the application currently running in Appeon Workspace
//      
// Returns: integer
//						 1 - Success.
//						-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2016-07
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//========================================================================================
string ls_url
integer li_return
eon_mobile_device luo_eon_mobile_device

IF  appeongetclienttype() = "MOBILE" THEN
	IF trim(as_workspaceid)="" THEN
		luo_eon_mobile_device = CREATE eon_mobile_device
		li_return = luo_eon_mobile_device.of_getdeviceid(as_workspaceid)
		DESTROY luo_eon_mobile_device
		IF   li_return  = -1 THEN RETURN li_return
	END IF
	IF trim(as_appname)="" THEN
		li_return = of_getappinfo (as_appname, ls_url) 
	END IF
else
	li_return = -1	
END IF

RETURN li_return
end function

on eon_mobile_awsex.create
call super::create
end on

on eon_mobile_awsex.destroy
call super::destroy
end on

