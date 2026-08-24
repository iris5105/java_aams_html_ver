forward
global type eon_mobile_image from nonvisualobject
end type
end forward

global type eon_mobile_image from nonvisualobject
end type
global eon_mobile_image eon_mobile_image

forward prototypes
public function integer of_createimagewithoptions (blob ablb_sourcefile, string as_targetfile, eon_mobile_str_imageoption astr_imageoption, ref eon_mobile_str_imageinfo astr_imageinfo)
public function integer of_createimagewithoptions (string as_sourcefile, string as_targetfile, eon_mobile_str_imageoption astr_imageoption, ref eon_mobile_str_imageinfo astr_imageinfo)
end prototypes

public function integer of_createimagewithoptions (blob ablb_sourcefile, string as_targetfile, eon_mobile_str_imageoption astr_imageoption, ref eon_mobile_str_imageinfo astr_imageinfo);//========================================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Function: eon_mobile_image::of_createimagewithoptions
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Description:
//		Generates the target image.
//		Supported on mobile client only.			
// Arguments:
//		value    blob    ablb_sourcefile
//			The source file of the image (Blob data)
//		value    string    as_targetfile
//			The location and file name of the generated target image. When file name is empty,
//			no image will be generated, only the blob data will be generated, and if 
///		b_returnblob is false, the function will return an argument error.
//		value   eon_mobile_str_imageoption  astr_imageoption 
//			The arguments for generating the target image
//    			Variable list of the eon_mobile_str_imageoption struct
//						long		l_width				The width of the target image
//						long		l_height				The height of the target image
//						integer	i_quality			The quality of the target image: [1, 10]. 10 indicates 
//															the original quality. If it is a different number other 
// 														than 10, it indicates the quality of the target image and 
//															only jpg format will be supported and i_imagetype will  
//															be ignored.
//						double	dbl_filesize		When dbl_filesize (same as Blob, unit is BYTE) is greater
//															than zero, dbl_quality will be ignored, and the image quality 
//															will be automatically adjusted according to the value of i_loopstep,
//															therefore only JPG image type will be supported.
//						integer	i_loopstep			The percentage of the quality loss during compression: [1-9]. The 
//															number indicates the percentage level that the quality will be reduced by.
//						boolean	b_aspectfit			Keep the aspect ratio during compression. When it is true, keep the aspect 
//															ratio. If the width aspect ratio (the target image width divided by the source image width)
//															is less than the height aspect ratio (the target image height divided by the source image
//															height), then the width aspect ratio will be used as the compression ratio, otherwise,
//															the height aspect ratio will be used as the compression ratio. 
//						boolean	b_returnblob		Whether to return the indicator of the blob data
//						boolean	b_grayimage			Whether to gray out the target image
//						boolean	b_existoverwrite	Whether to overwrite the existing file
//						integer	i_imagetype			The supported image file type: JPG, PNG
//						boolean  b_scalefit			the image will be generated at the size of the content area (the image will be scaled to fill up
//															the content area, possibly anamorphically); when false, the image will be generated at the size
//															specified by l_width and l_height and will not be scaled.
//
//		reference   eon_mobile_str_imageinfo    astr_imageinfo
//			the information of the generated target image
//    			Variable list of the eon_mobile_str_imageinfo struct
//						long		l_width				The width of the target image
//						long		l_height				The height of the target image
//						integer	i_quality			The quality of the target image: [1, 10]. 10 indicates 
//															the original quality. If it is a different number other 
// 														than 10, it indicates the quality of the image and 
//															only jpg format will be supported and i_imagetype will  
//															be ignored.
//						double	dbl_filesize		the size of the target image
//						blob     ablb_filedata     the data of the target image, only when b_returnblob of eon_mobile_str_imageoption is true,
//															there is value of ablb_filedata.
// 		Returns: integer
//			   1 - Successful.
//              0 - Unknown error.
//             -1 - Invalid file location.
//             -2 - Argument error.
//             -3 - Failed to load the source image file.
//             -4 - Failed to save the thumbnail image file.
//             -5 - Failed to compress the image to the specified size.
//             -6 - Insufficient memory.
//             -7 - File already exists.
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-01
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//========================================================================================
return -1
end function

public function integer of_createimagewithoptions (string as_sourcefile, string as_targetfile, eon_mobile_str_imageoption astr_imageoption, ref eon_mobile_str_imageinfo astr_imageinfo);//==============================================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Function: eon_mobile_image::of_createimagewithoptions
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Description:
//		Generates the target image.
//		Supported on mobile client only.			
// Arguments:
//		value    string    as_sourcefile
//			The location and the source file name.
//		value    string    as_targetfile
//			The location and file name of the generated target image. When file name is empty,
//			no image will be generated, only the blob data will be generated, and if 
///		b_returnblob is false, the function will return an argument error.
//		value   eon_mobile_str_imageoption  astr_imageoption 
//			The arguments for generating the target image
//    			Variable list of the eon_mobile_str_imageoption struct
//						long		l_width				The width of the target image
//						long		l_height				The height of the target image
//						integer	i_quality			The quality of the target image: [1, 10]. 10 indicates 
//															the original quality. If it is a different number other 
// 														than 10, it indicates the quality of the target image and 
//															only jpg format will be supported and i_imagetype will  
//															be ignored.
//						double	dbl_filesize		When dbl_filesize (same as Blob, unit is BYTE) is greater
//															than zero, dbl_quality will be ignored, and the image quality 
//															will be automatically adjusted according to the value of i_loopstep,
//															therefore only JPG image type will be supported.
//						integer	i_loopstep			The percentage of the quality loss during compression: [1-9]. The 
//															number indicates the percentage level that the quality will be reduced by.
//						boolean	b_aspectfit			Keep the aspect ratio during compression. When it is true, keep the aspect 
//															ratio. If the width aspect ratio (the target image width divided by the source image width)
//															is less than the height aspect ratio (the target image height divided by the source image
//															height), then the width aspect ratio will be used as the compression ratio, otherwise,
//															the height aspect ratio will be used as the compression ratio. 
//						boolean	b_returnblob		Whether to return the indicator of the blob data
//						boolean	b_grayimage			Whether to gray out the target image
//						boolean	b_existoverwrite	Whether to overwrite the existing file
//						integer	i_imagetype			The supported image file type: JPG, PNG
//						boolean  b_scalefit			the image will be generated at the size of the content area (the image will be scaled to fill up
//															the content area, possibly anamorphically); when false, the image will be generated at the size
//															specified by l_width and l_height and will not be scaled.
//
//		reference   eon_mobile_str_imageinfo    astr_imageinfo
//			the information of the generated target image
//    			Variable list of the eon_mobile_str_imageinfo struct
//						long		l_width				The width of the target image
//						long		l_height				The height of the target image
//						integer	i_quality			The quality of the target image: [1, 10]. 10 indicates 
//															the original quality. If it is a different number other 
// 														than 10, it indicates the quality of the image and 
//															only jpg format will be supported and i_imagetype will  
//															be ignored.
//						double	dbl_filesize		the size of the target image
//						blob     ablb_filedata  	the data of the target image, only when b_returnblob of eon_mobile_str_imageoption is true,
//															there is value of ablb_filedata.
// 		Returns: integer
//			   1 - Successful.
//              0 - Unknown error.
//             -1 - Invalid file location.
//             -2 - Argument error.
//             -3 - Failed to load the source image file.
//             -4 - Failed to save the thumbnail image file.
//             -5 - Failed to compress the image to the specified size.
//             -6 - Insufficient memory.
//             -7 - File already exists.
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-01
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================================
return -1
end function

on eon_mobile_image.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_image.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

