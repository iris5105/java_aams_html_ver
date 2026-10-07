forward
global type eon_mobile_mapex from eon_mobile_map
end type
end forward

global type eon_mobile_mapex from eon_mobile_map
end type
global eon_mobile_mapex eon_mobile_mapex

type variables
eon_mobile_str_annotation istr_clickedannotation
string is_errortext
integer ii_errorcode
end variables

forward prototypes
public function integer of_open (eon_mobile_str_mapoption astr_mapoption)
public function integer of_addannotation (ref eon_mobile_str_annotation astr_annotation, boolean ab_move)
public function integer of_addresstocoordinate (string as_address, ref decimal dec_longitude, ref decimal adec_latitude)
public function long of_close ()
public function integer of_coordinatetoaddress (decimal dec_longitude, decimal adec_latitude, ref string as_address)
public function integer of_refresh (eon_mobile_str_mapoption astr_mapoption)
public function integer of_removeallannotation ()
public function integer of_removeannotation (eon_mobile_str_annotation astr_annotation)
public function integer of_selectannotation (eon_mobile_str_annotation astr_annotation)
public function integer of_removeannotation (long al_id)
public function integer of_selectannotation (long al_id)
end prototypes

public function integer of_open (eon_mobile_str_mapoption astr_mapoption);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_open
//------------------------------------------------------------------------------
// Description: 
// Opens the map at a specified location.
//	Supported on mobile client only.		
// 
// Arguments:
//		value			 eon_mobile_str_mapoption     astr_mapoption.
//						 Sets the map options. 
//
//    			Variable list of the eon_mobile_str_mapoption struct
//						boolean	b_locatetocurrentlocation
//									Sets the initail location after loading the map.
//									If it is true, the map automatically locates to the current location.
//									If it is false, the map automatically locates to the location according to 
//                         the dec_latitude and dec_longitude arguments.
//						boolean	b_allowmove
//									Sets Whether the user can move the map. 									
//						boolean	b_allowzoom
//									Sets Whether the user can zoom the map. 				
//						decimal{6}	dec_latitude
//										Sets the latitue of a location after loading the map, the value is valid only when b_locatetocurrentlocation is false.					
//						decimal{6}	dec_longitude
//										Sets the longitude of a location after loading the map, the value is valid only when b_locatetocurrentlocation is false.					
//						integer	i_mapaccuracy
//									Sets the map display accuracy (in meters).
//						integer	i_maptype
//									Sets the type of the map.
//									0 - Map.
//									1 - Satellite.
//									2 - Mixed.
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

if isnull(astr_mapoption) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_open(astr_mapoption,istr_clickedannotation)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_addannotation (ref eon_mobile_str_annotation astr_annotation, boolean ab_move);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_addannotation
//------------------------------------------------------------------------------
// Description: 
// Adds an annotation into the map.
//	Supported on mobile client only.		
// 
// Arguments:
//		reference eon_mobile_str_annotation     astr_annotation
//					The annotation to be added.
//
//    			Variable list of the eon_mobile_str_annotation struct
//						decimal{6}	dec_latitude
//										The latitude value of the annotation.
//						decimal{6}	dec_longitude
//										The longitude value of the annotation.
//						integer	i_pincolor
//									The color of the annotation.
//									0 - Red
//									1 - Green
//									2 - Purple
//						string 	s_pinimage
//									The user defined picture for the annotation.
//						string	s_subtitle
//									The sub title of the annotation.
//						string	s_title
//									The title of the annotation.
//						long 		l_id
//									The unique identifier of the annotation
//						
//		value    boolean		ab_move
//					Sets whether to automatically move the map, so that the newly added annotation can be seen.
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
long ll_id
if isnull(astr_annotation) or isnull(ab_move) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		ll_id = super:: of_addannotation(astr_annotation,ab_move)
		if ll_id>0 then
			astr_annotation.l_id = ll_id
			li_return = 1
		else
			li_return = -1
		end if   
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_addresstocoordinate (string as_address, ref decimal dec_longitude, ref decimal adec_latitude);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_addresstocoordinate
//------------------------------------------------------------------------------
// Description: 
// Converts the address information into corresponding latitude and longitude information.
//	Supported on mobile client only.		
// 
// Arguments:
//		value        string     as_address, the address information. 
//		reference    decimal    dec_longitude, the longitude information. 
//		reference    decimal    adec_latitude, the latitude information. 	
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

if isnull(as_address) or isnull(dec_longitude) or isnull(adec_latitude) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_addresstocoordinate(as_address,dec_longitude,adec_latitude)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function long of_close ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_close
//------------------------------------------------------------------------------
// Description: 
// Closes the default map application.
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

public function integer of_coordinatetoaddress (decimal dec_longitude, decimal adec_latitude, ref string as_address);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_coordinatetoaddress
//------------------------------------------------------------------------------
// Description: 
// Converts the latitude and longitude information into the corresponding address information.
//	Supported on mobile client only.		
// 
// Arguments:
//		value        string     as_address, the address information. 
//		reference    decimal    dec_longitude, the longitude information. 
//		reference    decimal    adec_latitude, the latitude information. 	
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

if isnull(as_address) or isnull(dec_longitude) or isnull(adec_latitude) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_coordinatetoaddress(dec_longitude,adec_latitude,as_address)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_refresh (eon_mobile_str_mapoption astr_mapoption);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_refresh
//------------------------------------------------------------------------------
// Description: 
// Refreshes the map accroding to the astr_mapoption option.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    eon_mobile_str_mapoption    astr_mapoption	
//
//    			Variable list of the eon_mobile_str_mapoption struct
//						boolean	b_locatetocurrentlocation
//									Sets the current location after refreshing the map.
//									If it is true, the map automatically locate to the current location.
//									If it is false, the map automatically locate to the location according to 
//                         the dec_latitude and dec_longitude arguments.
//						boolean	b_allowmove
//									Sets Whether the user can move the map. 									
//						boolean	b_allowzoom
//									Sets Whether the user can zoom the map. 				
//						decimal{6}	dec_latitude
//										Sets the latitude of a location after refreshing the map, the value is valid only when b_locatetocurrentlocation is false.					
//						decimal{6}	dec_longitude
//										Set the longitude of a location after refreshing the map, the value is valid only when b_locatetocurrentlocation is false.					
//						integer	i_mapaccuracy
//									Sets the map display accuracy (in meters).
//						integer	i_maptype
//									Sets the type of the map.
//									0 - Map.
//									1 - Satellite.
//									2 - Mixed.
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

if isnull(astr_mapoption) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_refresh(astr_mapoption)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_removeallannotation ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_removeallannotation
//------------------------------------------------------------------------------
// Description: 
//	Removes all the annotations which are added by using the of_addannotation function.
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
	li_return = super:: of_removeallannotation()
else
	li_return = -1
end if


return li_return
end function

public function integer of_removeannotation (eon_mobile_str_annotation astr_annotation);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_removeannotation
//------------------------------------------------------------------------------
// Description: 
// Removes an annotation which is added by using the of_addannotation function.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    eon_mobile_str_annotation    astr_annotation	
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

if isnull(astr_annotation) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_removeannotation(astr_annotation)
	else
		li_return = -1
	end if
end if

return li_return

end function

public function integer of_selectannotation (eon_mobile_str_annotation astr_annotation);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_selectannotation
//------------------------------------------------------------------------------
// Description: 
// Selects an annotation which is added by using of_addannotation function.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    eon_mobile_str_annotation    astr_annotation	
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

if isnull(astr_annotation) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		li_return = super:: of_selectannotation(astr_annotation)
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_removeannotation (long al_id);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_removeannotation
//------------------------------------------------------------------------------
// Description: 
// Removes an annotation which is added by using the of_addannotation function.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    long    al_id	
//		The unique identifier of the annotation
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2013-12
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return
eon_mobile_str_annotation lstr_annotation
if isnull(al_id) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		lstr_annotation.l_id= al_id     
		li_return = of_removeannotation(lstr_annotation)
	else  
		li_return = -1
	end if
end if
return li_return
end function

public function integer of_selectannotation (long al_id);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_mapex::of_selectannotation
//------------------------------------------------------------------------------
// Description: 
// Selects an annotation which is added by using of_addannotation function.
//	Supported on mobile client only.		
// 
// Arguments:
//		value    long		al_id	
//							The unique identifier of the annotation
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
eon_mobile_str_annotation lstr_annotation

if isnull(al_id) then
	li_return = -1
else
	if appeongetclienttype() = "MOBILE" then
		lstr_annotation.l_id= al_id     
		li_return = of_selectannotation(lstr_annotation)
	else  
		li_return = -1
	end if
end if
return li_return
end function

on eon_mobile_mapex.create
call super::create
end on

on eon_mobile_mapex.destroy
call super::destroy
end on

