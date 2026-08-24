forward
global type eon_mobile_geolocation from nonvisualobject
end type
end forward

global type eon_mobile_geolocation from nonvisualobject
event oe_locationchanged ( decimal dec_longitude,  decimal dec_latitude,  decimal dec_altitude,  decimal dec_accuracy,  decimal dec_altitudeaccuracy,  decimal dec_heading,  decimal dec_speed,  datetime dt_timestamp )
event oe_error ( )
end type
global eon_mobile_geolocation eon_mobile_geolocation

type variables




end variables

forward prototypes
public function integer of_isenabled ()
public function integer of_open (integer ai_locationaccuracy, integer ai_distancefilter)
public function integer of_close ()
public function integer of_getcurrentposition (ref eon_mobile_str_coordinates astr_coordinates)
end prototypes

event oe_locationchanged(decimal dec_longitude, decimal dec_latitude, decimal dec_altitude, decimal dec_accuracy, decimal dec_altitudeaccuracy, decimal dec_heading, decimal dec_speed, datetime dt_timestamp);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_geolocation::oe_locationchanged
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
end event

event oe_error();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_geolocation::oe_error
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
end event

public function integer of_isenabled ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocation::of_isenabled
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
return -1
end function

public function integer of_open (integer ai_locationaccuracy, integer ai_distancefilter);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocation::of_open
//------------------------------------------------------------------------------
// Description: 
// Gets the current position and opens the geolocation function.
//	Supported on mobile client only.		
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
return -1
end function

public function integer of_close ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocation::of_close
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
return -1
end function

public function integer of_getcurrentposition (ref eon_mobile_str_coordinates astr_coordinates);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_geolocation::of_getcurrentposition
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
//										The latitude and longitude positioning accuracy
//						decimal{2}	dec_altitude
//										The altitude value of the current position.
//						decimal{2}	dec_altitudeaccuracy
//										The altitude positioning accuracy.
//						decimal{2}	dec_heading
//										The degrees clockwise from true north (0 to 359.99 degrees).
//						decimal{2}	dec_speed
//										The displacement velocity(m/sec).
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

return -1
end function

on eon_mobile_geolocation.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_geolocation.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

