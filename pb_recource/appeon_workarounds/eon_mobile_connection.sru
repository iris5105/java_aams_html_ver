forward
global type eon_mobile_connection from nonvisualobject
end type
end forward

global type eon_mobile_connection from nonvisualobject
end type
global eon_mobile_connection eon_mobile_connection

forward prototypes
public function integer of_getconnectioninfo ()
end prototypes

public function integer of_getconnectioninfo ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_connection::of_getconnectionInfo
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
return -1
end function

on eon_mobile_connection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_connection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

