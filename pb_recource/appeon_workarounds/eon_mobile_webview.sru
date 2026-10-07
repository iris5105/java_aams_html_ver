forward
global type eon_mobile_webview from userobject
end type
end forward

global type eon_mobile_webview from userobject
integer width = 910
integer height = 560
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event oe_error ( )
event oe_loadend ( )
event oe_loadstart ( )
event oe_jscallbackappeon ( string as_data )
end type
global eon_mobile_webview eon_mobile_webview

forward prototypes
public function integer of_cangoback ()
public function integer of_cangoforward ()
public function integer of_goback ()
public function integer of_goforward ()
public function integer of_loadlocalfile (string as_filepath)
public function integer of_reload ()
public function integer of_runjavascript (string as_strjs, ref string as_strret)
public function integer of_startloading (string as_url)
public function integer of_stoploading ()
public function integer of_loadhtmlstring (string as_htmlstring)
end prototypes

event oe_error();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webview::oe_error
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

event oe_loadend();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webview::oe_loadend
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

event oe_loadstart();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webview::oe_loadstart
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

event oe_jscallbackappeon(string as_data);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_webview::oe_jscallbackappeon
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

public function integer of_cangoback ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_cangoback
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

return -1
end function

public function integer of_cangoforward ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_cangoforward
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
return -1
end function

public function integer of_goback ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_goback
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
return -1
end function

public function integer of_goforward ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_goforward
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
return -1
end function

public function integer of_loadlocalfile (string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_loadlocalfile
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
return -1
end function

public function integer of_reload ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_reload
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
return -1
end function

public function integer of_runjavascript (string as_strjs, ref string as_strret);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_runjavascript
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
as_strret =""
return -1
end function

public function integer of_startloading (string as_url);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_startloading
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
return -1

end function

public function integer of_stoploading ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_stoploading
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
return -1
end function

public function integer of_loadhtmlstring (string as_htmlstring);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_webview::of_loadhtmlstring
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
return -1
end function

on eon_mobile_webview.create
end on

on eon_mobile_webview.destroy
end on

