forward
global type eon_mobile_audio from nonvisualobject
end type
end forward

global type eon_mobile_audio from nonvisualobject
event oe_error ( )
end type
global eon_mobile_audio eon_mobile_audio

type variables

end variables

forward prototypes
public function integer of_play (string as_filepath)
public function integer of_stop ()
public function integer of_getstatus ()
public function integer of_pauseorresume ()
end prototypes

event oe_error();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_audio::oe_error
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
end event

public function integer of_play (string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audio::of_play
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
return -1
end function

public function integer of_stop ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audio::of_stop
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
return -1
end function

public function integer of_getstatus ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audio::of_getstatus
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
return -1
end function

public function integer of_pauseorresume ();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_audio::of_pauseorresume
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
return -1
end function

on eon_mobile_audio.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_audio.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

