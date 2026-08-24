forward
global type eon_mobile_connectionex from eon_mobile_connection
end type
end forward

global type eon_mobile_connectionex from eon_mobile_connection
end type
global eon_mobile_connectionex eon_mobile_connectionex

forward prototypes
public function integer of_getconnectioninfo ()
end prototypes

public function integer of_getconnectioninfo ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_connectionex::of_getconnectionInfo
//------------------------------------------------------------------------------
// Description: 
// 		Gets the device's network connection information. 		
//			Supported on mobile client only.
// 
//	
// Returns:  integer
//					 0 - No connection.
//					 1 - Cell network.
//					 2 - Wi-Fi network.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2012-12
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super::of_getconnectionInfo()
else	
	li_return = -1
end if

return li_return
end function

on eon_mobile_connectionex.create
call super::create
end on

on eon_mobile_connectionex.destroy
call super::destroy
end on

