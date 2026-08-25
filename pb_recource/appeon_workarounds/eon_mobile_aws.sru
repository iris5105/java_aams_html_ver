forward
global type eon_mobile_aws from nonvisualobject
end type
end forward

global type eon_mobile_aws from nonvisualobject
end type
global eon_mobile_aws eon_mobile_aws

forward prototypes
public function integer of_getassistivetouchmode ()
public function integer of_setassistivetouchmode (integer ai_mode)
public function integer of_getapporientation ()
public function integer of_setapporientation (integer ai_mode)
public function integer of_log (integer ai_level, string as_info)
public function integer of_getassistivetouchbtnvisible ()
public function integer of_setassistivetouchbtnvisible (integer ai_mode)
public function integer of_settitlebarvisible (integer ai_mode)
public function integer of_gettitlebarvisible ()
public function integer of_getappinfo (ref string as_appname, ref string as_appurl)
public function integer of_getversion (ref string as_version)
public function integer of_clearlog ()
public function integer of_getapprotationlock ()
public function integer of_setapprotationlock (integer ai_mode)
public function integer of_getcloseappiconvisible ()
public function integer of_getwindowlisticonvisible ()
public function integer of_setwindowlisticonvisible (integer ai_mode)
public function integer of_sendmail (eon_mobile_str_mailcontent astr_content, string as_recipient[], string as_cc[], string as_bcc[], string as_attachmentfile[])
public function integer of_getdwmousemovemode ()
public function integer of_setdwmousemovemode (integer ai_mode)
public function integer of_setcloseappiconvisible (integer ai_mode, string as_title, string as_message)
public function integer of_getworkspaceheight ()
public function integer of_getworkspacewidth ()
public function long of_setlongpressinterval (long al_interval)
end prototypes

public function integer of_getassistivetouchmode ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getassistivetouchmode
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
return -1
end function

public function integer of_setassistivetouchmode (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setassistivetouchmode
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

return -1
end function

public function integer of_getapporientation ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getapporientation
//------------------------------------------------------------------------------
// Description: 
//		Detects if the application currently running in Appeon Workspace screen 
//		orientation is Landscape or Portrait. 
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
return -1
end function

public function integer of_setapporientation (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setapporientation
//------------------------------------------------------------------------------
// Description: 
//		Sets the screen orientation of the application currently running in Appeon Workspace.
//		The screen orientation is set regardless of current screen rotation. 
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
return -1
end function

public function integer of_log (integer ai_level, string as_info);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_log
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
return -1
end function

public function integer of_getassistivetouchbtnvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getassistivetouchbtnvisible
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
return -1
end function

public function integer of_setassistivetouchbtnvisible (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setassistivetouchbtnvisible
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
return -1
end function

public function integer of_settitlebarvisible (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_settitlebarvisible
//------------------------------------------------------------------------------
// Description: 
//		Sets whether the Appeon WorkSpace title bar is visible or invisible. 
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Sets the title bar to be visible.
//					0 - Sets the title bar to be invisible, and displays the normal 
//						 view icon which when tapped can show the title bar again.
//					2 - Sets the title bar to be invisible, and displays no icon for
//						 showing the title bar.
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
return -1
end function

public function integer of_gettitlebarvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_gettitlebarvisible
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

return -1
end function

public function integer of_getappinfo (ref string as_appname, ref string as_appurl);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getappinfo
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
as_appname = ""
as_appurl = ""
return -1
end function

public function integer of_getversion (ref string as_version);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getversion
//------------------------------------------------------------------------------
// Description: 
//		Gets the version number of Appeon WorkSpace. 
//		Supported on mobile client only.		
// 
// Arguments:
//		reference    string		as_version
//		Returns the Appeon WorkSpace version number; returns empty string if it is 
//		called in PowerBuilder or Appeon Web or if there is any error. 
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
as_version=""
return -1
end function

public function integer of_clearlog ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_clearlog
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

return -1
end function

public function integer of_getapprotationlock ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getapprotationlock
//------------------------------------------------------------------------------
// Description: 
//               Detects if the screen orientation for the application currently
//					  running in Appeon Workspace is locked. 
//               Supported on mobile client only.
// 
// Arguments: None
//      
// Returns:       integer 
//							 1 - Locked.
//							 0 - Unlocked.
//							-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================
return -1

end function

public function integer of_setapprotationlock (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setapprotationlock
//------------------------------------------------------------------------------
// Description: 
//    Sets whether to lock the screen orientation of the application currently 
//		running in Appeon Workspace. 
//    The screen orientation will not change with the screen rotation.
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

return -1

end function

public function integer of_getcloseappiconvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getcloseappiconvisible
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
return -1
end function

public function integer of_getwindowlisticonvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getwindowlisticonvisible
//------------------------------------------------------------------------------
// Description: 
//		Detects if the window list icon is visible.
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
return -1
end function

public function integer of_setwindowlisticonvisible (integer ai_mode);//=================================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setwindowlisticonvisible
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
//=================================================================================
return -1
end function

public function integer of_sendmail (eon_mobile_str_mailcontent astr_content, string as_recipient[], string as_cc[], string as_bcc[], string as_attachmentfile[]);//============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_sendmail
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
//		value    string  as_recipient[], specifies the recipient list of the mail
//		value    string  as_cc[],  specifies the Cc recipient list of the mail
//		value    string  as_bcc[], specifies the Bcc recipient list of the mail
//		value    string  as_attachmentfile[]	attachment file path list
//	
// Returns:  integer.
//		 The following return values are effective for the iOS device only. On the Android device,
//		 0 will be returned under all circumstances, because the corresponding mail API from the Android
//		 SDK returns no standardized value.
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
//============================================================================
return -1
end function

public function integer of_getdwmousemovemode ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getdwmousemovemode
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
return -1
end function

public function integer of_setdwmousemovemode (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setdwmousemovemode
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
return -1
end function

public function integer of_setcloseappiconvisible (integer ai_mode, string as_title, string as_message);//========================================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setcloseappiconvisible
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
//========================================================================================
return -1
end function

public function integer of_getworkspaceheight ();//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getworkspaceheight
//------------------------------------------------------------------------------
// Description: 
//               Return the height of Appeon Workspace. 
//               Supported on mobile client only.               
// 
// Arguments: None
//      
// Returns: integer. 
//            The height of Appeon Workspace.
//            -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2015-07
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================
return -1
end function

public function integer of_getworkspacewidth ();//==============================================================================
// 
// Copyright ? 2001-2015 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_getworkspacewidth
//------------------------------------------------------------------------------
// Description: 
//               Return the width of Appeon Workspace. 
//               Supported on mobile client only.               
// 
// Arguments: None
//      
// Returns: integer. 
//           The width of Appeon Workspace.
//           -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2015-07
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================
return -1
end function

public function long of_setlongpressinterval (long al_interval);//===============================================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------------------------
// Function: eon_mobile_aws::of_setlongpressinterval
//------------------------------------------------------------------------------------------------
// Description: 
//               Sets the duration (in milliseconds) for a press before it is recognized as a long
//					  press. Once this long press duration is reached, the keyboard will be brought up 
//					  to display (by default, the keyboard pops up only when the user taps twice in the
//					  field of the DataWindow).
//               Supported on mobile client only.  	
// 
// Arguments:
//		value    long    al_interval
//					1 - Sets the duration in milliseconds. If it is set to a value smaller than 500 
//						 milliseconds, then 550 milliseconds will be used, because 500 milliseconds is 
//						 already used as the duration for the DataWindow drag & drop event.If this 
//						 function is not called, the default value that Appeon uses is 1500 milliseconds
//						 when long press will be recognized and keyboard will be displayed.
//	
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//------------------------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-04
//------------------------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//===============================================================================================

return -1
end function

on eon_mobile_aws.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_aws.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

