forward
global type eon_mobile_deviceex from eon_mobile_device
end type
end forward

global type eon_mobile_deviceex from eon_mobile_device
end type
global eon_mobile_deviceex eon_mobile_deviceex

forward prototypes
public function long of_getfreememory ()
public function integer of_getresolution (ref integer ai_height, ref integer ai_width)
public function integer of_getppi ()
public function long of_gettotalmemory ()
public function integer of_getdeviceid (ref string as_id)
public function integer of_getdevicetype (ref string as_type)
public function integer of_getdpi ()
public function integer of_getname (ref string as_name)
public function integer of_getorientation ()
public function integer of_getplatform (ref string as_platform)
public function integer of_getosversion (ref string as_version)
public function integer of_getstatusbarvisible ()
public function integer of_setstatusbarvisible (integer ai_mode)
end prototypes

public function long of_getfreememory ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getfreememory
//------------------------------------------------------------------------------
// Description: 
//			Gets the total number (in KB) of the device's current available free memory. 
//			Supported on mobile client only.		
// 
// Arguments:	None
//	
// Returns:  long
//					>0 - Returns the total number of the device free memory.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//-----------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

long ll_return

if appeongetclienttype() = "MOBILE" then
	ll_return = super::of_getfreememory()
else	
	ll_return = -1
end if

return ll_return
end function

public function integer of_getresolution (ref integer ai_height, ref integer ai_width);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getresolution
//------------------------------------------------------------------------------
// Description: 
//			Gets the device's resolution. 
//			Supported on mobile client only.		
// 
// Arguments:
//		reference    integer    ai_height
//										Returns the device's screen height (in pixels). 
//		reference    integer    ai_width
//										Returns the device's screen width (in pixels). 
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

if isnull(ai_height) or isnull(ai_width) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getresolution(ai_height,ai_width)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	ai_height = 0
	ai_width = 0
end if

return li_return
end function

public function integer of_getppi ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getppi
//------------------------------------------------------------------------------
// Description: 
//			Gets the device's PPI value. 
//			Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer
//					>0 - Return the device PPI value.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getppi()
else	
	li_return = -1
end if

return li_return
end function

public function long of_gettotalmemory ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_gettotalmemory
//------------------------------------------------------------------------------
// Description: 
//			Gets the total number (in KB) of the device memory. 
//			Supported on mobile client only.	
// 
// Arguments: None
//	
// Returns:  long
//					>0 - Return the total number of the device memory.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

long ll_return

if appeongetclienttype() = "MOBILE" then
	ll_return = super::of_gettotalmemory()
else	
	ll_return = -1
end if

return ll_return
end function

public function integer of_getdeviceid (ref string as_id);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getdeviceid
//------------------------------------------------------------------------------
// Description: 
//		Gets the device's unique identifier, which depends on the device manufacturer, product type, and operating system. 
//		Supported on mobile client only.	
// 
// Arguments:
//		reference    string    as_id
//		Returns the device unique identifier; returns empty string if it is called in PowerBuilder or Appeon Web or if there is any error. 
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

if isnull(as_id) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getdeviceid(as_id)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_id=""
end if

return li_return
end function

public function integer of_getdevicetype (ref string as_type);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getdevicetype
//------------------------------------------------------------------------------
// Description: 
// 	Gets the device type from the manufacturer.
//		Supported on mobile client only.	
// 
// Arguments:
//		reference    string    as_type
//		Returns the device type, e.g., "iPod touch", "iPhone", or "iPad". The value of device type is set by the manufacturer.
//		Returns empty string if it is called in PowerBuilder or Appeon Web or if there is any error.
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

if isnull(as_type) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getdevicetype(as_type)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_type=""
end if

return li_return
end function

public function integer of_getdpi ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getdpi
//------------------------------------------------------------------------------
// Description: 
//			Gets the device DPI value. 
//			Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns:  integer
//					>0 - Returns the device DPI value.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getdpi()
else	
	li_return = -1
end if

return li_return
end function

public function integer of_getname (ref string as_name);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getname
//------------------------------------------------------------------------------
// Description: 
// 	Gets the device's machine name. 
//		Supported on mobile client only.	
// 
// Arguments:
//		reference    string    as_name
//		Returns the device's machine name; returns empty string if it is called in PowerBuilder or Appeon Web, or if there is any error.
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

if isnull(as_name) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getname(as_name)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_name=""
end if

return li_return
end function

public function integer of_getorientation ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getorientation
//------------------------------------------------------------------------------
// Description: 
//			Detects if the device screen orientation is Landscape or Portrait. 
//			Supported on mobile client only.
// 
// Arguments: (None)
//	
// Returns:  integer
//					0 - Unknown.
//					1 - Portrait, Home button at the bottom.
//					2 - Portrait, Home button on the top.
//					3 - Landscape, Home button to the right.
//					4 - Landscape, Home button to the left. 
//				  -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2012-12
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getorientation()
else	
	li_return = -1
end if

return li_return
end function

public function integer of_getplatform (ref string as_platform);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getplatform
//------------------------------------------------------------------------------
// Description: 
//			Gets the device's OS name. 
//			Supported on mobile client only.	
// 
// Arguments:
//		reference    string    as_platform
//		Returns the device's OS name; e.g., returns "iPhone OS" if the device is iPhone, iPad, or iPod touch. The value of OS name is obtained from the mobile device.
//		Returns empty string if it is called in PowerBuilder or Appeon Web, or if there is any error.     
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

if isnull(as_platform) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getplatform(as_platform)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_platform=""
end if

return li_return

end function

public function integer of_getosversion (ref string as_version);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getosversion
//------------------------------------------------------------------------------
// Description: 
//			Gets the OS version. 
//			Supported on mobile client only.	
// 
// Arguments:
//		reference    string    as_version
//		Returns the device's OS version; e.g., returns "6.0" if the iOS version is 6.0; returns "6.0.1" if the iOS version is 6.0.1. The value of OS version is obtained from the mobile device.
//		Returns empty string if it is called in PowerBuilder or Appeon Web, or if there is any error.          
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

if isnull(as_version) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_getosversion(as_version)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_version=""
end if

return li_return
end function

public function integer of_getstatusbarvisible ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_getstatusbarvisible
//------------------------------------------------------------------------------
// Description: 
//		Detects if the system status bar is visible.
//		Supported on mobile client only.		
// 
// Arguments: None
//	
// Returns:	integer. 
//					 1 - The system status bar is visible.
//					 0 - The system status bar is invisible.
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
	li_return = super::of_getstatusbarvisible()
else	
	li_return = -1
end if

return li_return
end function

public function integer of_setstatusbarvisible (integer ai_mode);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_deviceex::of_setstatusbarvisible
//------------------------------------------------------------------------------
// Description: 
//		Sets whether the system status bar is visible.
//		Supported on mobile client only.	
// 
// Arguments:
//		value    integer    ai_mode
//					1 - Sets the system status bar to be visible.
//					0 - Sets the system status bar to be invisible.	
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
		li_return = super::of_setstatusbarvisible(ai_mode)
	else
		li_return = -1
	end if
end if

return li_return
end function

on eon_mobile_deviceex.create
call super::create
end on

on eon_mobile_deviceex.destroy
call super::destroy
end on

