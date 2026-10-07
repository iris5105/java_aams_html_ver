forward
global type eon_logex from nonvisualobject
end type
end forward

global type eon_logex from nonvisualobject
end type
global eon_logex eon_logex

type variables
private:
appeonextfuncs invo_eonextfunc
eon_mobile_aws invo_eonmobaws


end variables

forward prototypes
public function integer of_clearlog ()
public function integer of_log (integer ai_level, string as_info)
public function integer of_log (string as_info)
end prototypes

public function integer of_clearlog ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_logex::of_clearlog
//------------------------------------------------------------------------------
// Description:
//		Clears the Appeon application log file on the client-side.
// 
// Arguments: None
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-06-25
//------------------------------------------------------------------------------
// Revision History: 
//				1.5   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = invo_eonmobaws.of_clearlog()
elseif appeongetclienttype() = "WEB" then	
	li_return = invo_eonextfunc.of_clearlog()
else
	li_return =-1
end if

return li_return
end function

public function integer of_log (integer ai_level, string as_info);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_logex::of_log
//------------------------------------------------------------------------------
// Description: 
//		Generates the Appeon application log file on the client-side.
//		Supported on mobile and web client.		
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
//					-1 - It is called in PowerBuilder, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-06-25
//------------------------------------------------------------------------------
// Revision History: 
//				1.5   Initial version
//==============================================================================

integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = invo_eonmobaws.of_log(ai_level,as_info)
elseif appeongetclienttype() = "WEB" then	
	li_return = invo_eonextfunc.of_log(ai_level,as_info)
else
	li_return =-1
end if

return li_return
end function

public function integer of_log (string as_info);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_logex::of_log
//------------------------------------------------------------------------------
// Description: 
//		Generates the Appeon application log file on the client-side.
//		Supported on mobile and web client.		
// 
// Arguments:
//		value    string     as_info
//					The log information. 	
//	
// Returns: integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder, or there is an error. 
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-06-25
//------------------------------------------------------------------------------
// Revision History: 
//				1.5   Initial version
//==============================================================================

return of_log(4,as_info)

end function

on eon_logex.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_logex.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor; invo_eonextfunc = create appeonextfuncs
 invo_eonmobaws = create eon_mobile_aws 
end event

