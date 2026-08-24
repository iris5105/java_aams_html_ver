forward
global type eon_editmaskex from eon_editmask
end type
end forward

global type eon_editmaskex from eon_editmask
event type integer ue_setvertical ( integer ai_vertical )
end type
global eon_editmaskex eon_editmaskex

event type integer ue_setvertical(integer ai_vertical);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_editmaskex::ue_setvertical
//------------------------------------------------------------------------------
// Description: 
//      Sets the ii_vertical property for the object.
//      Supported on mobile and web client .               
// 
// Arguments: 
//        	 value  integer ai_vertical.
//				 The value of the vertical property for the object.
// Returns:  integer.     
//                  1 -  the object is centered vertically.
//                  0 -  the object is consistent with PowerBuilder.
//
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2016-05
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================

if appeongetclienttype() = "MOBILE" or appeongetclienttype()="WEB" then
	ii_vertical = ai_vertical
end if
return ii_vertical

end event

on eon_editmaskex.create
call super::create
end on

on eon_editmaskex.destroy
call super::destroy
end on

