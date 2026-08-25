forward
global type eon_mobile_media from nonvisualobject
end type
end forward

global type eon_mobile_media from nonvisualobject
end type
global eon_mobile_media eon_mobile_media

forward prototypes
public function integer of_play (string as_filepath)
end prototypes

public function integer of_play (string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_media::of_play
//------------------------------------------------------------------------------
// Description: 
//		Uses the default media player application to play the media files.
//    The supported audio file formats are .aac, .mp3, .aiff, and .wav; the supported video file formats are .m4v, .mp4, and .mov.
//    Not all the media files with these suffixes can be played; if some media files cannot be played, they can be transcoded via iTunes.
//		Supported on mobile client only.		
// 
// Arguments:
//		value    string    as_filepath
//		Sets the full path of a media file to be played.
//
// Returns: integer
//					 1 - Play the media file successfully.
//					 0 - Cancel playing the media file.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//	
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
return -1
end function

on eon_mobile_media.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_media.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

