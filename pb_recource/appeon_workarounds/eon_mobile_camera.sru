forward
global type eon_mobile_camera from nonvisualobject
end type
end forward

global type eon_mobile_camera from nonvisualobject
end type
global eon_mobile_camera eon_mobile_camera

forward prototypes
public function integer of_takefile (integer ai_filetype, boolean ab_allowedit, ref string as_filepath)
public function integer of_openalbums (ref string as_filepath)
end prototypes

public function integer of_takefile (integer ai_filetype, boolean ab_allowedit, ref string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_camera::of_takefile
//------------------------------------------------------------------------------
// Description: 
//		Opens the default camera application and uses it to take photo or video. 
//		Once the photo or video is taken, the camera application automatically closes with all the files saved in the album, and returns to the current application. 
//    The supported video file format is MOV, and the supported photo file format is JPG.
//    Supported on mobile client only.					
// 
// Arguments:
//		value			integer    ai_filetype
//		Sets the type of file to take.
//						1 - Take photo.
//						2 - Take video.
//
//		value        boolean    ab_allowedit
//		Sets if the file is editable after picture-taking. 
//
//		reference    string     as_filepath
//		Returns the full path pointing to the file in the sandbox cache directory.
//    The video and photo files will be saved into device's album, and will be copied to the cache directory of current application's sandbox; 
//    The files in this cache directory will be removed when the application exits.
//	
//	
// Returns: integer
//					 1 - Take photo successfully.
//					 2 - Take video successfully.
//					 0 - Cancel taking photo or video.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
as_filepath=""
return -1
end function

public function integer of_openalbums (ref string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_camera::of_openalbums
//------------------------------------------------------------------------------
// Description: 
//		Opens the album for the user to select a photo or video. 
//		Supported on mobile client only.		
// 
// Arguments:
//		reference    string     as_filepath
//		Returns the full path pointing to this file in the sandbox cache directory.
//    The selected video or photo file will be copied to the cache directory of current application's sandbox;
//		The files in this cache directory will be removed when the application exits.
//
// Returns: integer
//					 1 - Select a photo file successfully.
//					 2 - Select a video file successfully.
//					 0 - Cancel selecting file from the album.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
as_filepath =""
return -1 
end function

on eon_mobile_camera.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_camera.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

