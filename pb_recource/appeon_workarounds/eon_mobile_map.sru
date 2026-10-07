forward
global type eon_mobile_map from userobject
end type
end forward

global type eon_mobile_map from userobject
integer width = 910
integer height = 560
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event oe_annotationclicked ( )
event oe_loadstart ( )
event oe_loadend ( )
event oe_error ( )
event oe_changed ( )
end type
global eon_mobile_map eon_mobile_map

forward prototypes
public function integer of_coordinatetoaddress (decimal dec_longitude, decimal adec_latitude, ref string as_address)
public function integer of_addresstocoordinate (string as_address, ref decimal dec_longitude, ref decimal adec_latitude)
public function integer of_refresh (eon_mobile_str_mapoption astr_mapoption)
public function long of_close ()
public function integer of_removeallannotation ()
public function integer of_removeannotation (eon_mobile_str_annotation astr_annotation)
public function integer of_selectannotation (eon_mobile_str_annotation astr_annotation)
protected function integer of_open (eon_mobile_str_mapoption astr_mapoption, ref eon_mobile_str_annotation astr_clickedannotation)
public function integer of_addannotation (ref eon_mobile_str_annotation astr_annotation, boolean ab_move)
end prototypes

event oe_annotationclicked();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_map::oe_annotationclicked
//------------------------------------------------------------------------------
// Description: 
// Occurs when the user clicks an annotation in the map.
//The information of the clicked annotation is stored to the istr_clickedannotation instance variable.
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

event oe_loadstart();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_map::oe_changed
//------------------------------------------------------------------------------
// Description: 
// Occurs when starting to load the map via the of_open function.
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

event oe_loadend();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_map::oe_changed
//------------------------------------------------------------------------------
// Description: 
// Occurs when finishing loading the map via the of_open function.
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

event oe_error();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_map::oe_changed
//------------------------------------------------------------------------------
// Description: 
// Occurs when there is any error in this functionality.
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

event oe_changed();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_map::oe_changed
//------------------------------------------------------------------------------
// Description: 
// Occurs when the viewable area of the map changes.
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

public function integer of_coordinatetoaddress (decimal dec_longitude, decimal adec_latitude, ref string as_address);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_coordinatetoaddress
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
as_address = ""

return -1
end function

public function integer of_addresstocoordinate (string as_address, ref decimal dec_longitude, ref decimal adec_latitude);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_addresstocoordinate
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

dec_longitude = 0
adec_latitude = 0
return -1
end function

public function integer of_refresh (eon_mobile_str_mapoption astr_mapoption);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_refresh
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
return -1
end function

public function long of_close ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_close
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
return -1
end function

public function integer of_removeallannotation ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_removeallannotation
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
return -1
end function

public function integer of_removeannotation (eon_mobile_str_annotation astr_annotation);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_removeannotation
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
return -1
end function

public function integer of_selectannotation (eon_mobile_str_annotation astr_annotation);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_selectannotation
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
return -1
end function

protected function integer of_open (eon_mobile_str_mapoption astr_mapoption, ref eon_mobile_str_annotation astr_clickedannotation);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_open
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
return -1
end function

public function integer of_addannotation (ref eon_mobile_str_annotation astr_annotation, boolean ab_move);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_map::of_addannotation
//------------------------------------------------------------------------------
// Description: 
// Adds an annotation into the map.
//	Supported on mobile client only.		
// 
// Arguments:
//		reference    eon_mobile_str_annotation     astr_annotation
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
return -1
end function

on eon_mobile_map.create
end on

on eon_mobile_map.destroy
end on

