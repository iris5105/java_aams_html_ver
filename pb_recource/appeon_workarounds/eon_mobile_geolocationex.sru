forward
global type eon_mobile_geolocationex from eon_mobile_geolocation
end type
end forward

global type eon_mobile_geolocationex from eon_mobile_geolocation
end type
global eon_mobile_geolocationex eon_mobile_geolocationex

type variables
powerobject ipo_bindevent
string is_bindwithlocationchangedevent
string is_bindwitherrorevent
integer ii_errorcode
string	is_errortext
end variables

forward prototypes
protected subroutine of_triggerevent (string as_event)
public function integer of_register (powerobject apb_bind, string as_changedevent, string as_errorevent)
public function integer of_close ()
public function integer of_getcurrentposition (ref eon_mobile_str_coordinates astr_coordinates)
public function integer of_isenabled ()
public function integer of_open (integer ai_locationaccuracy, integer ai_distancefilter)
end prototypes

protected subroutine of_triggerevent (string as_event);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocationex::of_triggerevent
//------------------------------------------------------------------------------
// Description: 
// Triggers the object events bound with the eo_error or oe_locationchanged event.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_event
//								 The event name bound with eo_error or oe_locationchanged event
//	
// Returns:  (none).
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

if isvalid(ipo_bindevent)  and isnull(ipo_bindevent) = false and isnull(as_event) = false and trim(as_event)<> "" then
	ipo_bindevent.dynamic triggerevent(as_event)
end if
end subroutine

public function integer of_register (powerobject apb_bind, string as_changedevent, string as_errorevent);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocationex::of_register
//------------------------------------------------------------------------------
// Description: 
//	Registers the object and the event to be bound with the oe_error and oe_locationchanged events.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    powerobject    apb_bind
//					The object to be bound with the oe_error and oe_locationchanged event.
//		value    string         as_changedevent
//					The event to be bound with the oe_locationchanged event.
//		value    string         as_errorevent	
//					The event to be bound with the oe_error event.
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isvalid(apb_bind)= false or isnull(apb_bind) then	
		li_return =  -1		
else		
		ipo_bindevent = apb_bind
		is_bindwithlocationchangedevent = as_changedevent
		is_bindwitherrorevent = as_errorevent
		li_return =  1		
end if

return li_return
end function

public function integer of_close ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocationex::of_close
//------------------------------------------------------------------------------
// Description: 
// Closes the geolocation function.
//	Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return


if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_close()
else
	li_return = -1
end if


return li_return
end function

public function integer of_getcurrentposition (ref eon_mobile_str_coordinates astr_coordinates);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocationex::of_getcurrentposition
//------------------------------------------------------------------------------
// Description: 
// Gets the current position information.
//	Supported on mobile client only.		
// 
// Arguments:
//		reference    eon_mobile_str_coordinates    astr_coordinates	
//
//    			Variable list of the eon_mobile_str_coordinates struct
//						datetime		dt_timestamp
//										The timestamp to get the current position information.
//						decimal{6}	dec_latitude
//										The latitude value of the current position.
//						decimal{6}	dec_longitude
//										The longitude value of the current position.
//						decimal{2}	dec_accuracy
//										The latitude and longitude positioning accuracy.
//						decimal{2}	dec_altitude
//										The altitude value of the current position.
//						decimal{2}	dec_altitudeaccuracy
//										The altitude positioning accuracy.
//						decimal{2}	dec_heading
//										The degrees clockwise from true north (0 to 359.99 degrees).
//						decimal{2}	dec_speed
//										The displacement velocity (m/sec).
//
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return

if isnull(astr_coordinates) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_getcurrentposition(astr_coordinates)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_isenabled ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocationex::of_isenabled
//------------------------------------------------------------------------------
// Description: 
// Detects if the geolocation services can be used.
//	Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					 1 - Enabled.
//              0 - Disabled.
//					-1 - If it is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_isenabled()
else
	li_return = -1
end if

return li_return
end function

public function integer of_open (integer ai_locationaccuracy, integer ai_distancefilter);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocationex::of_open
//------------------------------------------------------------------------------
// Description: 
//     Opens the geolocation function.
//	    Supported on mobile client only.		
// 
// Arguments:
//		value    integer    ai_locationaccuracy.
//					Location accuracy update, recommended to use 0 or 1 for the automatic selection.
//					 0 - Automatically selects the optimal accuracy
//					 1 - Navigates to the optimal accuracy
//					>2 - Accuracy (in meters)
//
//		value    integer    ai_distancefilter
//					Location filter, used to control the location update message frequency (in meters).
//					 0 - Notifies by every update
//					>0 - Updates only when the location change exceeds this value
//
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(ai_locationaccuracy) or  isnull(ai_distancefilter) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_open(ai_locationaccuracy,ai_distancefilter)
	else
		li_return = -1
	end if
end if

return li_return
end function

on eon_mobile_geolocationex.create
call super::create
end on

on eon_mobile_geolocationex.destroy
call super::destroy
end on

event oe_locationchanged;call super::oe_locationchanged;//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_geolocationex::oe_locationchanged
//------------------------------------------------------------------------------
// Description: 
// Occurs when the latitude and longitude information changes.
//	Supported on mobile client only.		
// 
// Arguments: 
//		value  decimal dec_longitude.
//			The longitude value of the current position.
//		value  decimal dec_latitude.
//			The latitude value of the current position.
//		value  decimal dec_altitude.
//			The altitude value of the current position.
//		value  decimal dec_accuracy.
//			The latitude and longitude positioning accuracy.
//		value  decimal dec_altitudeaccuracy.
//			The altitude positioning accuracy.
//		value  decimal dec_heading.
//			The degrees clockwise from true north (0 to 359.99 degrees).
//		value  decimal dec_speed
//			The displacement velocity (m/sec).
//		value  datetime dt_timestamp.
//			The time stamp to get the current position information.
//
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
if isvalid(ipo_bindevent)  and isnull(ipo_bindevent) = false then
	if isnull(is_bindwithlocationchangedevent) = false and trim(is_bindwithlocationchangedevent)<> "" then
		of_triggerevent(is_bindwithlocationchangedevent)
	else
		ipo_bindevent.dynamic event oe_locationchanged(dec_longitude,  dec_latitude,  dec_altitude,  dec_accuracy,  dec_altitudeaccuracy,  dec_heading,  dec_speed,  dt_timestamp )
	end if
end if

end event

event oe_error;call super::oe_error;//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_geolocationex::oe_error
//------------------------------------------------------------------------------
// Description: 
// Occurs when there is any error in geolocation functionality.
//	Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

of_triggerevent(is_bindwitherrorevent)
end event

