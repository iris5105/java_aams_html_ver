forward
global type eon_offlineex from nonvisualobject
end type
end forward

global type eon_offlineex from nonvisualobject
end type
global eon_offlineex eon_offlineex

type variables
private:

eon_offline invo_eonupdate
boolean	is_checkupdate, is_checkdbupdate, is_dbupdate, is_appupdate

end variables

forward prototypes
public function integer of_checkappeonserver ()
public function integer of_applyupdate ()
public function integer of_checkupdate ()
public function integer of_applyupdate (boolean ab_showdialog)
public function integer of_applydbupdate ()
end prototypes

public function integer of_checkappeonserver ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline::of_checkappeonserver
//------------------------------------------------------------------------------
// Description:
//      Detects if the appeon sever is valid.
// 
// Arguments: none
//  
// Returns: integer
//       1 - The appeon sever is valid.
//      -1 - The appeon sever is not valid or Error in the checking of appeon sever or run it in the PB environment.
//      -2 - Unsupported feature in the WEB environment.
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================

long ll_ret

if appeongetclienttype() = "WEB" then return -2
ll_ret = invo_eonupdate.of_checkupdate( )
if ll_ret >= 0 then 
	return 1
else
	return -1
end if


end function

public function integer of_applyupdate ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline:: of_applyUpdate
//------------------------------------------------------------------------------
// Description:
//      Updates the current app from the server.
// 
// Arguments: none
//
// Returns: integer
//          1 - Success.
//		    	0 - Latest app and no need to update.
//         -1 - Failure or it is called in PowerBuilder.
//         -2 - It is called in Appeon Web and this operation is not supported.
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================

return of_applyupdate( false )


end function

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
//       0 - There is no update.
//       1 - There is an update only on the application.
//       2 - There is an update only on the DB file. 
//       3 - There are updates both on the DB file and application.
//      -1 - Failure in the update check or it is called in PowerBuilder.
//      -2 - It is called in Appeon Web and this operation is not supported.
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================


long ll_ret, ll_max =1, ll_test,i

if appeongetclienttype() = "WEB" then return -2
ll_ret = invo_eonupdate.of_checkupdate( ) 

if ll_ret>=0 then	
	is_checkupdate = true  
	is_checkdbupdate = true  
end if

if ll_ret <= 0 then 
	is_dbupdate = false
	is_appupdate = false 
	return ll_ret
elseif ll_ret > 64 then 
	is_dbupdate = true
	is_appupdate = true 
	return 3
elseif ll_ret = 64 then 
	is_dbupdate = true
	is_appupdate = false
	return 2
else
	is_dbupdate = false
	is_appupdate = true
	return 1
	
end if


end function

public function integer of_applyupdate (boolean ab_showdialog);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline:: of_applyUpdate
//------------------------------------------------------------------------------
// Description:
//      Updates the current app from the server.
// 
// Arguments: 
//       ab_showDialog boolean
//           True  - Displays the dialog box.
//           False - Do not display the dialog box.
//
// Returns: integer
//          1 - Success.
//          2 - User has clicked Cancel in the dialog box to not to update the app.
//          0 - Latest app and no need to update.
//         -1 - Failure or it is called in PowerBuilder.
//         -2 - It is called in Appeon Web and this operation is not supported.
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================

integer li_ret

if appeongetclienttype() = "WEB" then return -2
if ab_showDialog then
	li_ret =  messagebox("System info","After the app is updated, you need to restart the app to make the new version take effect. Please confirm your update.",Exclamation!, OKCancel!, 1)
	if li_ret = 2 then return 2
end if

SetPointer(HourGlass!)
if not (is_checkupdate and is_appupdate) then of_checkupdate()
is_checkupdate = false

SetPointer(Arrow!)

if is_appupdate then 
	li_ret = invo_eonupdate.of_applyupdate( 63)
	if li_ret >0 then is_appupdate = false
else
	li_ret = 0
end if

return li_ret

end function

public function integer of_applydbupdate ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_offline:: of_applyDBUpdate
//------------------------------------------------------------------------------
// Description:
//      Updates the database file of current app from the server.
// 
// Arguments: none
// Returns: integer
//          0 - The DB structure of the current application is the same as that in the server, and no need to update.
//          1 - Success.
//         -1 - Failure or it is called in PowerBuilder.
//         -2 - It is called in Appeon Web and this operation is not supported. 
//------------------------------------------------------------------------------
// Author:  APPEON      Date: 2013-07-23
//------------------------------------------------------------------------------
// Revision History: 
//              1.5   Initial version
//==============================================================================
integer		li_ret =0,li_inquir
String		ls_info

if appeongetclienttype() = "WEB" then return -2
	
if not (is_checkdbupdate and is_dbupdate) then of_checkupdate()
is_checkdbupdate =false	

if is_dbupdate then li_ret = invo_eonupdate.of_applyupdate( 64)

if li_ret >0 then is_dbupdate = false
return li_ret



end function

on eon_offlineex.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_offlineex.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_eonupdate = create eon_offline

is_checkupdate	=false
is_dbupdate		=false
is_appupdate	=false
end event

