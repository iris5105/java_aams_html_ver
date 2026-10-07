forward
global type eon_offline from nonvisualobject
end type
end forward

global type eon_offline from nonvisualobject
end type
global eon_offline eon_offline

type variables

end variables

forward prototypes
public function integer of_checkupdate ()
public function integer of_setofflinemode (transaction atr_sql, boolean ab_offline)
public function integer of_applyupdate (integer ai_updatetype)
end prototypes

public function integer of_checkupdate ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline::of_checkupdate
//------------------------------------------------------------------------------
// Description:
//      Detects if there is any updated version of the current app on the server.
// 
// Arguments: none
//                 
// Returns: integer
//                0 - There is no update.
//			Application Config  - 0000001     	1
//			Connection Cache  - 0000010		2
//			INI File 			    	 - 0000100		4
//			Mobile UI				 - 0001000		8
//			Embedded SQL    	 - 0010000		16
//			DW SQL			   	 - 0100000		32
//			Database File	   	 - 1000000		64
//               -1 - Error in the update check or run it in the PB environment.
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================

return -1

end function

public function integer of_setofflinemode (transaction atr_sql, boolean ab_offline);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline::of_setOffLineMode
//------------------------------------------------------------------------------
// Description:
//      Set the specified transaction to Offline status or Online status.
// 
// Arguments: 
//				transaction - atr_sql      The (specified) transaction.
//  			boolean	   - ab_offline  The status to be set.
//											true - Offline status
//											false -Online status
//
// Returns: integer
//                  1 - Success.
//                 -1 - Failure or if the application runs in PowerBuilder..
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================

return -1

end function

public function integer of_applyupdate (integer ai_updatetype);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline:: of_applyUpdate
//------------------------------------------------------------------------------
// Description:
//      Updates the current app from the server.
// 
// Arguments: integer  ai_updatetype
//			Application Config  - 0000001     	1
//			Connection Cache  - 0000010		2
//			INI File 			    	 - 0000100		4
//			Mobile UI				 - 0001000		8
//			Embedded SQL    	 - 0010000		16
//			DW SQL			   	 - 0100000		32
//			Database File	   	 - 1000000		64
//                  
// Returns: integer
//                  1 - Success.
//                 -1 - Failure or run it in the PB environment.
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================

return -1
end function

on eon_offline.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_offline.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

