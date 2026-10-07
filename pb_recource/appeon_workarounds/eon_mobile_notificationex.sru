forward
global type eon_mobile_notificationex from eon_mobile_notification
end type
end forward

global type eon_mobile_notificationex from eon_mobile_notification
end type
global eon_mobile_notificationex eon_mobile_notificationex

forward prototypes
public function integer of_removemessage (long al_handle)
public function long of_addmessage (string as_title, string as_message)
public function long of_addmessage (string as_message)
end prototypes

public function integer of_removemessage (long al_handle);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_notificationex::of_removemessage
//------------------------------------------------------------------------------
// Description: 
//			Removes a notification from the notification bar. 
//			Supported on mobile client only.
// 
// Arguments:
//		value    long    al_handle
//		Specifies the handle of the notification, which is created by the of_addmessage() function. 
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2012-12
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(al_handle) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_removemessage(al_handle)
	else	
		li_return = -1
	end if
end if

return li_return
end function

public function long of_addmessage (string as_title, string as_message);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_notificationex::of_addmessage
//------------------------------------------------------------------------------
// Description: 
//		Sends a notification to the notification bar. 
//		Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_title
//					The title to be displayed on the notification bar.
//					This parameter takes effect on the Android device only. On the iOS device, this parameter will be ignored,
//					and the title is always the application name, which means if your app runs in Appeon Workspace, the title will be "AppoenMobile"; 
//					if your app is a native app packaged via the Appeon Developer Package tool, the title will be whatever specified in the App Name field when packaged.
//		value    string    as_message
//					The message to be displayed on the notification bar.
//	
// Returns: long
//					>0 - Return the current notification handle if sending notification successfully.  
//					     of_removemessage function can use this handle to delete the notification.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
long ll_return
if isnull(as_title) or isnull(as_message) then
	ll_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		ll_return = super::of_addmessage(as_title,as_message)
	else	
		ll_return = -1
	end if
end if
return ll_return
end function

public function long of_addmessage (string as_message);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_notificationex::of_addmessage
//------------------------------------------------------------------------------
// Description: 
//		Sends a notification to the notification bar. 
//		Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_message
//					The message to be displayed on the notification bar.
//	
// Returns: long
//					>0 - Return the current notification handle if sending notification successfully.  
//					     of_removemessage function can use this handle to delete the notification.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
long ll_return
string ls_title

if isnull(as_message) then
	ll_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		ls_title = ""
		ll_return = super::of_addmessage(ls_title,as_message)
	else	
		ll_return = -1
	end if
end if
return ll_return
end function

on eon_mobile_notificationex.create
call super::create
end on

on eon_mobile_notificationex.destroy
call super::destroy
end on

