forward
global type eon_mobile_audioex from eon_mobile_audio
end type
end forward

global type eon_mobile_audioex from eon_mobile_audio
end type
global eon_mobile_audioex eon_mobile_audioex

type variables
PowerObject ipo_bindevent
String is_bindwitherrorevent
String is_errortext
Integer ii_errorcode
end variables

forward prototypes
public function integer of_play (string as_filepath)
public function integer of_stop ()
public function integer of_getstatus ()
public function integer of_register (powerobject apb_bind, string as_error)
public subroutine of_triggerevent (string as_event)
public function integer of_pauseorresume ()
end prototypes

public function integer of_play (string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audioex::of_play
//------------------------------------------------------------------------------
// Description: 
//	 Uses the default audio player application to play the audio file.
//   The supported audio file formats are .aac, .mp3, .aiff, and .wav.
//   Not all the audio files with these suffixes can be played; if some media files cannot be played, they should be transcoded first via iTunes.
//	 Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_filepath
//		Sets the full path of an audio file to be played.
//
// Returns: integer
//					 1 - The audio file is played successfully.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//	
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(as_filepath) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_play(as_filepath)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_stop ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audioex::of_stop
//------------------------------------------------------------------------------
// Description: 
//   Stops the audio file that is being played.
//	 Supported on mobile client only.		
// 
// Arguments: None
//
// Returns: integer
//					 1 - The audio file is stopped successfully.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_stop()
else
	li_return = -1
end if

return li_return

end function

public function integer of_getstatus ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audioex::of_getstatus
//------------------------------------------------------------------------------
// Description: 
//   Gets the current status of the audio file.
//   Supported on mobile client only.
// 
// Arguments: None
//
// Returns: integer
//					 0 - The audio file is stopped.
//					 1 - The audio file is being played.
//					 2 - The audio file is paused.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_getstatus()
else
	li_return = -1
end if

return li_return
end function

public function integer of_register (powerobject apb_bind, string as_error);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audioex::of_register
//------------------------------------------------------------------------------
// Description: 
//	 Registers the object and the event to be bound with the oe_error event.
//	 Supported on mobile client only.		
// 
// Arguments:
//		value    powerobject    apb_bind
//					The object to be bound with the oe_error event.
//		value    string         as_error
//					The event to be bound with the oe_error event.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isvalid(apb_bind)= false or isnull(apb_bind) then	
		li_return =  -1		
else		
		ipo_bindevent = apb_bind
		is_bindwitherrorevent = as_error		
		li_return =  1		
end if

return li_return
end function

public subroutine of_triggerevent (string as_event);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audioex::of_triggerevent
//------------------------------------------------------------------------------
// Description: 
//   Triggers the object event bound with the oe_error event.
//	 Supported on mobile client only.
// 
// Arguments:
//		value    string    as_event
//							 The event name bound with oe_error event.
//	
// Returns:  (None).
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

if isvalid(ipo_bindevent)  and isnull(ipo_bindevent) = false and isnull(as_event) = false and trim(as_event)<> "" then
	ipo_bindevent.dynamic triggerevent(as_event)
end if
end subroutine

public function integer of_pauseorresume ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audioex::of_pauseorresume
//------------------------------------------------------------------------------
// Description: 
//   Pauses the audio file that is being played or resumes playing it from where it stopped.
//	 Supported on mobile client only.
// 
// Arguments: None
//
// Returns: integer
//					 1 - The audio file is paused successfully.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	li_return = super:: of_pauseorresume()
else
	li_return = -1
end if

return li_return
end function

on eon_mobile_audioex.create
call super::create
end on

on eon_mobile_audioex.destroy
call super::destroy
end on

event oe_error;call super::oe_error;//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_audioex::oe_error
//------------------------------------------------------------------------------
// Description: 
//   Occurs when there is any error in this functionality.
//	 Supported on mobile client only.
// 
// Arguments: (None)
//	
// Returns: (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-08
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
of_triggerevent(is_bindwitherrorevent)
end event

