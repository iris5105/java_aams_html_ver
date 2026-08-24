forward
global type eon_mobile_barcodeex from eon_mobile_barcode
end type
end forward

global type eon_mobile_barcodeex from eon_mobile_barcode
end type
global eon_mobile_barcodeex eon_mobile_barcodeex

forward prototypes
public function integer of_read (ref string as_data, ref integer ai_format)
public function integer of_create (string as_data, integer ai_format, ref string as_filepath)
public function blob of_getfiledata (string as_filepath)
public function integer of_create (string as_data, integer ai_format, ref string as_filepath, ref blob ablb_data)
end prototypes

public function integer of_read (ref string as_data, ref integer ai_format);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_barcodeex::of_read
//------------------------------------------------------------------------------
// Description: 
//		Reads the information of a barcode. 
//		Supported on mobile client only.
//
// Arguments:
//		reference	string	as_data
// 	Returns the data of a barcode. 
//
//		reference	integer	ai_format
//		Returns the format of barcode.
// 					 0 - unknown
//						 1 - EAN-2, GS1 2-digit add-on
//						 2 - EAN-5, GS1 5-digit add-on
//						 3 - EAN-8, EAN-8
//						 4 - UPC-E4
//						 5 - ISBN-10, from EAN-13
//						 6 - UPC-A 
//						 7 - EAN-13
//						 8 - ISBN-13, from EAN-13
//						 9 - COMPOSITE, EAN/UPC composite
//						 10 - Interleaved 2 of 5
//						 11 - CODE 128
//						 12 - CODE93
//						 13 - CODE39
//						 14 - ITF	
//						 20 - QR CODE
//						 21 - DataMatrix
//						 22 - AZTEC
//      
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2012-12
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================


integer li_return

if isnull(as_data) or isnull(ai_format) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_read(as_data,ai_format)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_data = ""
	ai_format = 0
end if

return li_return
end function

public function integer of_create (string as_data, integer ai_format, ref string as_filepath);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_barcodeex::of_create
//------------------------------------------------------------------------------
// Description: 
//		Generates the image for a barcode. 
//		Supported on mobile client only.
//
// Arguments:
//		string	as_data
// 	sets the data of a barcode. 
//
//		integer	ai_format
//		sets the format of a barcode.
// 					 0 - unknown
//						 1 - EAN-2, GS1 2-digit add-on
//						 2 - EAN-5, GS1 5-digit add-on
//						 3 - EAN-8, EAN-8
//						 4 - UPC-E4
//						 5 - ISBN-10, from EAN-13
//						 6 - UPC-A 
//						 7 - EAN-13
//						 8 - ISBN-13, from EAN-13
//						 9 - COMPOSITE, EAN/UPC composite
//						 10 - Interleaved 2 of 5
//						 11 - CODE 128
//						 12 - CODE93
//						 13 - CODE39
//						 14 - ITF	
//						 20 - QR CODE
//						 21 - DataMatrix
//						 22 - AZTEC
//
//		reference	string	as_filepath
// 	Returns the path of the generated barcode image.     
// Returns:  integer
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2012-12
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================


integer li_return

if isnull(as_data) or isnull(ai_format) or isnull(as_filepath)then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super::of_create(as_data,ai_format,as_filepath)
	else	
		li_return = -1
	end if
end if

if li_return = -1 then
	as_filepath = ""
end if

return li_return
end function

public function blob of_getfiledata (string as_filepath);// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_barcodeex::of_getfiledata
//------------------------------------------------------------------------------
// Description: 
// Reads data from the specified image file.
// 
// Arguments:
//               value    string    as_filepath,   The full path of the file you want to read.
//      
// Returns:  blob.
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================

blob lb_data, lb_temp
integer li_FileNum, li_loops,li_index, li_bytes_read
long ll_FLength

if trim(as_filepath)<>"" and FileExists (as_filepath ) then
         
         // Get the file length, and open the file
         ll_FLength = FileLength(as_filepath)
         li_FileNum = FileOpen(as_filepath, StreamMode!, read!, LockWrite!)
         
         if li_FileNum <> -1 then
                   // Determine how many times to call FileRead
                   IF ll_FLength > 32765 THEN     
                                       IF Mod(ll_FLength, 32765) = 0 THEN   
                                                        li_loops = ll_FLength/32765     
                                       ELSE     
                                                        li_loops = (ll_FLength/32765) + 1     
                                       END IF 
                   ELSE 
                                       li_loops = 1  
                   END IF
         
                   // Read the file                   
                   FOR li_index = 1 to li_loops      
                                       li_bytes_read = FileRead(li_FileNum, lb_temp)  
                                       lb_data = lb_data + lb_temp
                   NEXT
                   
                   //close the file
                   FileClose(li_FileNum)
                   
         end if
         
end if

return lb_data
end function

public function integer of_create (string as_data, integer ai_format, ref string as_filepath, ref blob ablb_data);// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_barcodeex::of_create
//------------------------------------------------------------------------------
// Description: 
//               Generates the image for a barcode. 
//               Supported on mobile client only.
//
// Arguments:
//               string        as_data
//    				sets the data of a barcode. 
//
//               integer     ai_format
//					sets the format of a barcode.
//                                           0 - unknown
//                                                     1 - EAN-2, GS1 2-digit add-on
//                                                     2 - EAN-5, GS1 5-digit add-on
//                                                     3 - EAN-8, EAN-8
//                                                     4 - UPC-E4
//                                                     5 - ISBN-10, from EAN-13
//                                                     6 - UPC-A 
//                                                     7 - EAN-13
//                                                     8 - ISBN-13, from EAN-13
//                                                     9 - COMPOSITE, EAN/UPC composite
//                                                     10 - Interleaved 2 of 5
//                                                     11 - CODE 128
//                                                     12 - CODE93
//                                                     13 - CODE39
//                                                     14 - ITF   
//                                                     20 - QR CODE
//                                                     21 - DataMatrix
//                                                     22 - AZTEC
//               reference          string        as_filepath
//					Returns the path of the generated barcode image.     
//               reference          bolb ablb_data
//					Returns the data of the generated barcode image.     
//
// Returns:  integer
//                                           1 - Success.
//                                           -1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:         APPEON            Date: 2014-01
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//==============================================================================


integer li_return
blob lblb_data

li_return = of_create(as_data,ai_format,as_filepath)

if li_return >0  then
         ablb_data = of_getfiledata(as_filepath) 
end if

if li_return < 1 then
         as_filepath = ""
         ablb_data = lblb_data
end if

return li_return
end function

on eon_mobile_barcodeex.create
call super::create
end on

on eon_mobile_barcodeex.destroy
call super::destroy
end on

