forward
global type eon_mobile_webviewex from eon_mobile_webview
end type
end forward

global type eon_mobile_webviewex from eon_mobile_webview
end type
global eon_mobile_webviewex eon_mobile_webviewex

type variables
string is_errortext
integer ii_errorcode
end variables

forward prototypes
public function integer of_cangoback ()
public function integer of_cangoforward ()
public function integer of_goback ()
public function integer of_goforward ()
public function integer of_loadlocalfile (string as_filepath)
public function integer of_loadhtmlstring (string as_htmlstring)
public function integer of_reload ()
public function integer of_runjavascript (string as_strjs, ref string as_strret)
public function integer of_startloading (string as_url)
public function integer of_stoploading ()
end prototypes

public function integer of_cangoback ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_cangoback
//------------------------------------------------------------------------------
// Description: 
// Indicates whether the user can move backward.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 0 - Unable to move backward.
//					 1 - Able to move backward.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_cangoback()
else
	li_return = -1
end if

return li_return
end function

public function integer of_cangoforward ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_cangoforward
//------------------------------------------------------------------------------
// Description: 
// Indicates whether the user can move forward.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 0 - Unable to move forward.
//					 1 - Able to move forward.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_cangoforward()
else
	li_return = -1
end if

return li_return

end function

public function integer of_goback ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_goback
//------------------------------------------------------------------------------
// Description: 
// Loads the previous location in the back-forward list.
// Supported on mobile client only.
//
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_goback()
else
	li_return = -1
end if

return li_return

end function

public function integer of_goforward ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_goforward
//------------------------------------------------------------------------------
// Description: 
// Loads the next location in the back-forward list.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_goforward()
else
	li_return = -1
end if

return li_return

end function

public function integer of_loadlocalfile (string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_loadlocalfile
//------------------------------------------------------------------------------
// Description: 
// Loads and displays the local file.
// Supported on mobile client only.		
// 
// Arguments: 
//		value    					string		as_filepath
//									The path of the local file which you want to load.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if (trim(as_filepath)="" or isnull(as_filepath) or ( not FileExists (as_filepath ))) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_loadlocalfile(as_filepath)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_loadhtmlstring (string as_htmlstring);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_loadhtmlstring
//------------------------------------------------------------------------------
// Description: 
// Loads the string of the HTML page. Only HTM or HTML file is supported.
// Supported on mobile client only.		
// 
// Arguments: (None)
//			value    				string		as_htmlstring
//									The string of the HTML page which you want to load.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if (trim(as_htmlstring)="" or isnull(as_htmlstring) ) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_loadhtmlstring(as_htmlstring)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_reload ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_reload
//------------------------------------------------------------------------------
// Description: 
// Reloads the current page.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_reload()
else
	li_return = -1
end if

return li_return

end function

public function integer of_runjavascript (string as_strjs, ref string as_strret);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_runjavascript
//------------------------------------------------------------------------------
// Description: 
// Runs the JavaScript code snippet.
// Supported on mobile client only.		
// 
// Arguments: 
//		value    					string		as_strjs
//									The script which you want to run.
//		reference   				string     as_strret
//									The result of running script.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return
string ls_strret

if isnull(as_strjs) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_runjavascript(as_strjs,as_strret)
	else
		li_return = -1
	end if
end if

if li_return = -1 then
	as_strret= ls_strret
end if

return li_return
end function

public function integer of_startloading (string as_url);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_startloading
//------------------------------------------------------------------------------
// Description: 
// Starts the loading of the page.
// Supported on mobile client only.		
// 
// Arguments: 
//		value    					string		as_url
//										The URL of the page which you want to load.
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(as_url) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_startloading(as_url)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_stoploading ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webviewex::of_stoploading
//------------------------------------------------------------------------------
// Description: 
// Stops the loading of the current page.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_stoploading()
else
	li_return = -1
end if

return li_return

end function

on eon_mobile_webviewex.create
call super::create
end on

on eon_mobile_webviewex.destroy
call super::destroy
end on

event oe_error;call super::oe_error;//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webviewex::oe_error
//------------------------------------------------------------------------------
// Description: 
// Occurs when there is any error in this functionality.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
end event

event oe_loadend;call super::oe_loadend;//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webviewex::oe_loadend
//------------------------------------------------------------------------------
// Description: 
// Occurs when the of_startloading function finishes loading the page.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
end event

event oe_loadstart;call super::oe_loadstart;//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webviewex::oe_loadstart
//------------------------------------------------------------------------------
// Description: 
// Occurs when the of_startloading function starts loading the page.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-03
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================


end event

event oe_jscallbackappeon;call super::oe_jscallbackappeon;//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webviewex::oe_jscallbackappeon
//------------------------------------------------------------------------------
// Description: 
// 	Triggered automatically when the Web page loaded into the eon_mobile_webview object fires a call to the callbackappeon(as_data)
//	JavaScript function. So this event and the callbackappeon (as_data) JavaScript function can be utilized as communication 	bridge 
//   between the Web page and the Appeon Mobile app.
//Supported on mobile client only.		
//
// 	Arguments: 
//		 string as_data:     Receives the string passed in by the parameter of the callbackappeon JavaScript function. If the value is not
//								a string, it  will be automatically converted to a string before passed in.
//
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2015-11
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
end event

