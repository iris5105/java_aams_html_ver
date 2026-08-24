forward
global type eon_mobile_cameraex from eon_mobile_camera
end type
end forward

global type eon_mobile_cameraex from eon_mobile_camera
end type
global eon_mobile_cameraex eon_mobile_cameraex

forward prototypes
public function integer of_takefile (eon_mobile_str_cameraoption astr_option, ref string as_filepath)
public function integer of_takefile (integer ai_filetype, boolean ab_allowedit, ref string as_filepath)
public function integer of_openalbums (ref string as_filepath)
public function integer of_takefile (eon_mobile_str_cameraoption astr_option, ref string as_filepath, ref blob ablb_data)
public function blob of_getfiledata (string as_filepath)
public function integer of_openalbums (ref string as_filepath, ref blob ablb_data)
public function integer of_takefile (integer ai_filetype, boolean ab_allowedit, ref string as_filepath, ref blob ablb_data)
end prototypes

public function integer of_takefile (eon_mobile_str_cameraoption astr_option, ref string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_takefile
//------------------------------------------------------------------------------
// Description: 
//		Opens the default camera application and uses it to take photo or video. 
//		Once the photo or video is taken, the camera application automatically closes with all the files saved in the 
//		album, and returns to the current application. 
//    The supported video file format is MOV, and the supported photo file format is JPG.
//    Supported on mobile client only.						
// 
// Arguments:
// 	value    eon_mobile_str_cameraoption    astr_option
//															 Sets the camera options.
//
//    			Variable list of the eon_mobile_str_cameraoption struct
//						Integer i_filetype				
//								  Sets the type of file to take. The camera application will be set to this type by default 
//								  when it is opened. Users can also manually switch the type in the camera application.
//								  1 - Take photo.
//							     2 - Take video.
//						Boolean	b_allowedit
//									Sets if the file is editable after picture-taking. 
//
//
//		reference    string  as_filepath
//		Returns the full path of the photo file or video file;
//		Returns empty string if the picture-taking is cancelled, or if there is any error.
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

integer li_return


li_return =  of_takefile(astr_option.i_filetype,astr_option.b_allowedit,as_filepath )

return li_return
end function

public function integer of_takefile (integer ai_filetype, boolean ab_allowedit, ref string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_takefile
//------------------------------------------------------------------------------
// Description: 
//		Opens the default camera application and uses it to take photo or video. 
//		Once the photo or video is taken, the camera application automatically closes with all the files saved in the 
//		album, and returns to the current application. 
//    The supported video file format is MOV, and the supported photo file format is JPG.
//    Supported on mobile client only.					
// 
// Arguments:
//		value			integer    ai_filetype
//		Sets the type of file to take. The camera application will be set to this type by default when it is opened. 
//		Users can also manually switch the type in the camera application.
//						1 - Takes photo.
//						2 - Takes video.
//
//		value        boolean    ab_allowedit
//		Sets if the file is editable after picture-taking. 
//
//		reference    string     as_filepath
//		Returns the full path pointing to the file in the sandbox cache directory.
//    The video and photo files will be saved into device's album, and will be copied to the cache directory of current 
//		application's sandbox; 
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

integer li_return

if isnull(ai_filetype) or isnull(ab_allowedit) or isnull(as_filepath) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_takefile(ai_filetype, ab_allowedit, as_filepath)
	else	
		li_return = -1
	end if
end if

if li_return < 1 then
	as_filepath=""
end if

return li_return
end function

public function integer of_openalbums (ref string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_openalbums
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

integer li_return

if isnull(as_filepath) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_openalbums(as_filepath)
	else	
		li_return = -1
	end if
end if

if li_return < 1 then
	as_filepath=""
end if

return li_return
end function

public function integer of_takefile (eon_mobile_str_cameraoption astr_option, ref string as_filepath, ref blob ablb_data);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_takefile
//------------------------------------------------------------------------------
// Description: 
//		Opens the default camera application and uses it to take photo or video. 
//		Once the photo or video is taken, the camera application automatically closes with all the files saved in the 
//		album, and returns to the current application. 
//    The supported video file format is MOV, and the supported photo file format is JPG.
//    Supported on mobile client only.						
// 
// Arguments:
// 	value    eon_mobile_str_cameraoption    astr_option
//															 Sets the camera options.
//
//    			Variable list of the eon_mobile_str_cameraoption struct
//						Integer i_filetype				
//								  Sets the type of file to take. The camera application will be set to this type by default 
//								  when it is opened. Users can also manually switch the type in the camera application.
//								  1 - Takes photo.
//							     2 - Takes video.
//						Boolean	b_allowedit
//									Sets if the file is editable after picture-taking. 
//
//		reference    string  as_filepath
//		Returns the full path of the photo file or video file;
//		Returns empty string if the picture-taking is cancelled, or if there is any error.
//
//		reference    blob  ablb_data
//		Returns the file data of the photo file or video file;
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

integer li_return
blob lblb_data

li_return =  of_takefile(astr_option.i_filetype,astr_option.b_allowedit,as_filepath )

if li_return >0  then
	ablb_data = of_getfiledata(as_filepath)	
end if

if li_return < 1 then
	as_filepath = ""
	ablb_data = lblb_data
end if

return li_return
end function

public function blob of_getfiledata (string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_getfiledata
//------------------------------------------------------------------------------
// Description: 
// Reads data from the specified image file.
// 
// Arguments:
//		value    string    as_filepath,	The full path of the file you want to read.
//	
// Returns:  blob.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-04
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

blob lb_data, lb_temp
integer li_FileNum, li_loops,li_index, li_bytes_read
long ll_FLength

if trim(as_filepath)<>"" and FileExists (as_filepath ) then
	
	// Get the file length, and open the file
	ll_FLength = FileLength(as_filepath)
	li_FileNum = FileOpen(as_filepath, TextMode!, read!, LockWrite!)
	
	if li_FileNum <> -1 then
		// Read the file		
		li_bytes_read = FileReadEx(li_FileNum, lb_data)	
		//close the file
		FileClose(li_FileNum)
	end if	
	
end if

return lb_data
end function

public function integer of_openalbums (ref string as_filepath, ref blob ablb_data);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_openalbums
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
//		reference    blob  ablb_data
//		Returns the file data of the photo file or video file;
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

integer li_return
blob lblb_data

li_return =  of_openalbums(as_filepath)

if li_return >0  then
	 ablb_data = of_getfiledata(as_filepath)	
end if

if li_return < 1 then
	as_filepath = ""
	ablb_data = lblb_data
end if


return li_return
end function

public function integer of_takefile (integer ai_filetype, boolean ab_allowedit, ref string as_filepath, ref blob ablb_data);// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_cameraex::of_takefile
//------------------------------------------------------------------------------
// Description: 
//		Opens the default camera application and uses it to take photo or video. 
//		Once the photo or video is taken, the camera application automatically closes with all the files saved in the 
//		album, and returns to the current application. 
//    The supported video file format is MOV, and the supported photo file format is JPG.
//    Supported on mobile client only.					
// 
// Arguments:
//		value			integer    ai_filetype
//		Sets the type of file to take. The camera application will be set to this type by default when it is opened. 
//		Users can also manually switch the type in the camera application.
//						1 - Takes photo.
//						2 - Takes video.
//
//		value        boolean    ab_allowedit
//		Sets if the file is editable after picture-taking. 
//
//		reference    string     as_filepath
//		Returns the full path pointing to the file in the sandbox cache directory.
//   	The video and photo files will be saved into device's album, and will be copied to the cache directory of current 
//		application's sandbox; 
//    	The files in this cache directory will be removed when the application exits.
//		reference    blob     ablb_data
//		Returns the file data of the photo file or video file;
// Returns: integer
//					 1 - Take photo successfully.
//					 2 - Take video successfully.
//					 0 - Cancel taking photo or video.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error. 
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

integer li_return
blob lblb_data
li_return = of_takefile(ai_filetype, ab_allowedit, as_filepath)

if li_return >0  then
	ablb_data = of_getfiledata(as_filepath)	
end if

if li_return < 1 then
	as_filepath = ""
	ablb_data = lblb_data
end if
return li_return
end function

on eon_mobile_cameraex.create
call super::create
end on

on eon_mobile_cameraex.destroy
call super::destroy
end on

