forward
global type eon_cjsonnodearray from nonvisualobject
end type
end forward

global type eon_cjsonnodearray from nonvisualobject
end type
global eon_cjsonnodearray eon_cjsonnodearray

forward prototypes
public function integer of_size ()
public subroutine of_cleararray ()
public subroutine of_append (eon_cjsonnode anvo_node)
public subroutine of_removebyindex (integer ai_index)
public subroutine of_insertatindex (integer ai_index, eon_cjsonnode anvo_node)
public subroutine of_insertatindex (integer ai_index, eon_cjsonnodearray anvo_nodearray)
public subroutine of_append (eon_cjsonnodearray anvo_nodearray)
public function eon_cjsonnodearray of_getarraynodebyindex (integer ai_index)
public function eon_cjsonnode of_getnodebyindex (integer ai_index)
public function long of_getlongbyindex (integer ai_index)
public function string of_getstringbyindex (integer ai_index)
public function double of_getdoublebyindex (integer ai_index)
public function boolean of_getboolbyindex (integer ai_index)
public function integer of_gettypebyindex (integer ai_index)
public function string of_tostring ()
public function boolean of_load (string as_jsonstring)
public subroutine of_append (any aa_keyvalue)
public subroutine of_insertatindex (integer ai_index, any aa_keyvalue)
end prototypes

public function integer of_size ();//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_size
//------------------------------------------------------------------------------
// Description: 
// 					Gets the total amount of the key values in eon_cjsonnodearray.
// 
// Arguments: (None)
//	
// Returns:  integer. 
//					The total amount of key values in the array. 
//					-1 - It is called in PowerBuilder, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
return -1
end function

public subroutine of_cleararray ();//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_cleararray
//------------------------------------------------------------------------------
// Description: 
// 					Clears the content of the current array. 
// 
// Arguments: (None)
//	
// Returns:   (None) 
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================

end subroutine

public subroutine of_append (eon_cjsonnode anvo_node);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_append
//------------------------------------------------------------------------------
// Description: 
//				Adds an eon_cjsonnode object at the end of the array.    
// 
// Arguments: 
// 	value		eon_cjsonnode	anvo_node
//				The eon_cjsonnode object to be added
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================

end subroutine

public subroutine of_removebyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_removebyindex
//------------------------------------------------------------------------------
// Description: 
//					Removes the key value specified by the index.    
// 
// Arguments: 
// 					value		integer	ai_index     The value of the index 
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================

end subroutine

public subroutine of_insertatindex (integer ai_index, eon_cjsonnode anvo_node);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_insertatindex
//------------------------------------------------------------------------------
// Description: 
//				Inserts an eon_cjsonnode object at the position specified by the index.      
// 
// Arguments: 
// 				value		integer	ai_index    The value of the index
// 				value		eon_cjsonnode	anvo_node
//				The eon_cjsonnode object to be inserted
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================



end subroutine

public subroutine of_insertatindex (integer ai_index, eon_cjsonnodearray anvo_nodearray);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_insertatindex
//------------------------------------------------------------------------------
// Description: 
//				Inserts an eon_cjsonnodearray object at the position specified by the index.     
// 
// Arguments: 
// 				value		integer	ai_index     The value of the index 
// 				value		eon_cjsonnodearray	anvo_nodearray
//				The eon_cjsonnodearray object to be inserted
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================



end subroutine

public subroutine of_append (eon_cjsonnodearray anvo_nodearray);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_append
//------------------------------------------------------------------------------
// Description: 
// 				Adds an eon_cjsonnodearray object at the end of the array. 
// 
// Arguments: 
// 	value		eon_cjsonnodearray	anvo_nodearray 
//				The eon_cjsonnodearray object to be added.
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================

end subroutine

public function eon_cjsonnodearray of_getarraynodebyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_getarraynodebyindex
//------------------------------------------------------------------------------
// Description: 
//				Gets the value (eon_cjsonnodearray object) specified by the index.   
// 
// Arguments: 
// 				value		integer	ai_index       The value of the index 
// Returns:   eon_cjsonnodearray 
//				 The value (eon_cjsonnodearray object)
//				 Null if the value is not an eon_cjsonnodearray object.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
eon_cjsonnodearray lobj_return

return lobj_return

end function

public function eon_cjsonnode of_getnodebyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_getnodebyindex
//------------------------------------------------------------------------------
// Description: 
//				Gets the value (eon_cjsonnode object) specified by the index.        
// 
// Arguments: 
// 				value		integer	ai_index        The value of the index 
// Returns:  eon_cjsonnode
//				The value (eon_cjsonnode).
//				Null if the value is not an eon_cjsonnode object.		
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
eon_cjsonnode lobj_return

return lobj_return

end function

public function long of_getlongbyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_getlongbyindex
//------------------------------------------------------------------------------
// Description: 
//				Gets the long value specified by the index.
// 
// Arguments: 
// 				value		integer	ai_index          The value of the index 
// Returns:	long 
//				The long value.
//				Null if the value is not a long.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
long ll_return

return ll_return

end function

public function string of_getstringbyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_getstringbyindex
//------------------------------------------------------------------------------
// Description: 
//				Gets the string value specified by the index.
// 
// Arguments: 
// 				value		integer	ai_index     The value of the index 
// Returns:   string
//				The string value.
//				Null if the value is not a string.						
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
string ls_return

return ls_return

end function

public function double of_getdoublebyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_getdoublebyindex
//------------------------------------------------------------------------------
// Description: 
//					Gets the double value specified by the index.        
// 
// Arguments: 
// 					value		integer	ai_index        The value of the index 
// Returns:      double
//				    The double value.
//				    Null if the value is not a double.					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
double ldbl_return

return ldbl_return

end function

public function boolean of_getboolbyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_getboolbyindex
//------------------------------------------------------------------------------
// Description: 
//					Gets the boolean value specified by the index.
// 
// Arguments: 
// 					value		integer	ai_index     The value of the index 
// Returns:      boolean
//				    The boolean value.
//				    Null if the value is not a boolean.					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
boolean lb_return

return lb_return

end function

public function integer of_gettypebyindex (integer ai_index);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_gettypebyindex
//------------------------------------------------------------------------------
// Description: 
//				Gets the data type of the key value specified by the index.
// 
// Arguments: 
// 				value		integer	ai_index     The value of the index 
// Returns:  integer
//					Data type of the key value
//					0 - NULL
//					1 - STRING
//					2 - NUMBER
//					3 - BOOL
//					4 - eon_cjsonnodearray
//					5 - eon_cjsonnode
//					-1 - Invalid value				
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
integer li_return

return li_return

end function

public function string of_tostring ();//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_tostring
//------------------------------------------------------------------------------
// Description: 
//				Converts the key values to the standard JSON-format array.
// 
// Arguments: 
//				 (None) 
// Returns:   
//				String		
//				The standard JSON-format array.	
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
string ls_return

return ls_return

end function

public function boolean of_load (string as_jsonstring);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_load
//------------------------------------------------------------------------------
// Description: 
//					Loads the JSON-format array.
// 
// Arguments: 
// 					value  String 	as_jsonstring   The JSON-format array 
// Returns:  		Boolean
//					true  - Loaded successfully.
//					false - Failed to load.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================
boolean lb_return

return lb_return

end function

public subroutine of_append (any aa_keyvalue);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_append
//------------------------------------------------------------------------------
// Description: 
// 				Adds a key value at the end of the array.
// 
// Arguments: 
// 	value		any	aa_keyvalue
//					The value to be added
//					Supported data types include long/boolean/string/double/eon_cjsonnode/eon_cjsonnodearray  
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================

end subroutine

public subroutine of_insertatindex (integer ai_index, any aa_keyvalue);//==============================================================================
// 
// Copyright ? 2001-2016 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_cjsonnodearray::of_insertatindex
//------------------------------------------------------------------------------
// Description: 
//				Inserts a key value at the position specified by the index.      
// 
// Arguments: 
// 				value		integer	ai_index      The value of the index 
// 				value		any	aa_keyvalue
//				The value to be inserted
//				Support data types include long/boolean/string/double/eon_cjsonnode/eon_cjsonnodearray  
// Returns:   (None) 
//					
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2016-03
//------------------------------------------------------------------------------
// Revision History: 
//                                  1.0   Initial version
//=============================================================================



end subroutine

on eon_cjsonnodearray.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_cjsonnodearray.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

