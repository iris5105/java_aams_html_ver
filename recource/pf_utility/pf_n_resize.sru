forward
global type pf_n_resize from nonvisualobject
end type
end forward

global type pf_n_resize from nonvisualobject
event type integer pfc_resize ( unsignedlong aul_sizetype,  integer ai_newwidth,  integer ai_newheight )
end type
global pf_n_resize pf_n_resize

type variables
Public:
// Predefined resize constants.
Constant String FIXEDRIGHT =  'FixedToRight'
Constant String FIXEDBOTTOM = 'FixedToBottom'
Constant String FIXEDRIGHTBOTTOM = 'FixedToRight&Bottom'
Constant String SCALE = 'Scale'
Constant String SCALERIGHT = 'ScaleToRight'
Constant String SCALEBOTTOM = 'ScaleToBottom'
Constant String SCALERIGHTBOTTOM = 'ScaleToRight&Bottom'
Constant String FIXEDRIGHT_SCALEBOTTOM = 'FixedToRight&ScaleToBottom'
Constant String FIXEDBOTTOM_SCALERIGHT = 'FixedToBottom&ScaleToRight'

Protected:
constant string  DRAGOBJECT = 'dragobject!'
constant string  LINE = 'line!'
constant string  OVAL = 'oval!'
constant string  RECTANGLE = 'rectangle!'
constant string  ROUNDRECTANGLE = 'roundrectangle!'
constant string  MDICLIENT = 'mdiclient!'

long 	il_parentminimumwidth=0
long	il_parentminimumheight=0
long	il_parentprevwidth=-1
long	il_parentprevheight=-1

integer	ii_rounding = 5

pf_n_resizeattrib inv_registered[]

end variables

forward prototypes
public function integer of_unregister (windowobject awo_control)
public function integer of_register (windowobject awo_control, string as_method)
public function integer of_setminsize (integer ai_minwidth, integer ai_minheight)
public function integer of_SetOrigSize (integer ai_width, integer ai_height)
public function integer of_register (windowobject awo_control, integer ai_movex, integer ai_movey, integer ai_scalewidth, integer ai_scaleheight)
protected function integer of_register (windowobject awo_control, boolean ab_scale, integer ai_movex, integer ai_movey, integer ai_scalewidth, integer ai_scaleheight)
protected function string of_typeof (windowobject awo_control)
public function integer of_getminmaxpoints (windowobject awo_control[], ref integer ai_min_x, ref integer ai_min_y, ref integer ai_max_x, ref integer ai_max_y)
protected function integer of_resize (integer ai_newwidth, integer ai_newheight)
public function string of_getresizemethod (readonly windowobject awo_control)
public function integer of_autoresizeregister (readonly graphicobject ago_parent)
public subroutine of_setsplit4position ()
end prototypes

event pfc_resize;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  resize
//
//	Description:
//	Send resize notification to services.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
Return of_Resize(ai_newwidth, ai_newheight)
end event

public function integer of_unregister (windowobject awo_control);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_UnRegister	
//
//	Access:  		public
//
//	Arguments:		
//	awo_control		The control to unregister.
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Unregister a control that was previously registered.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 6.0	Changed to support for weighted movement and sizing of controls.
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
integer			li_upperbound
integer			li_cnt
integer			li_registered_slot

//Check parameters
If IsNull(awo_control) or (not IsValid(awo_control)) Then
	Return -1
End If

//Confirm that the user object has already been initialized
If il_parentprevheight=-1 And il_parentprevwidth=-1 Then
	Return -1
End If

//Get the current UpperBound
li_upperbound = UpperBound (inv_registered[])

//Find the registered object
li_registered_slot = 0
For li_cnt = 1 to li_upperbound
	If inv_registered[li_cnt].wo_control = awo_control Then
		li_registered_slot = li_cnt
		exit
	End If
Next

//If the control was not previously registered, return
//an error code.
If li_registered_slot = 0 Then
	Return -1
End If

//Unregister the control
SetNull(inv_registered[li_registered_slot].wo_control)
inv_registered[li_registered_slot].s_typeof = ''
inv_registered[li_registered_slot].b_movex = False
inv_registered[li_registered_slot].i_movex = 0
inv_registered[li_registered_slot].b_movey = False
inv_registered[li_registered_slot].i_movey = 0
inv_registered[li_registered_slot].b_scalewidth = False
inv_registered[li_registered_slot].i_scalewidth = 0
inv_registered[li_registered_slot].b_scaleheight = False
inv_registered[li_registered_slot].i_scaleheight = 0

Return 1
end function

public function integer of_register (windowobject awo_control, string as_method);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_Register
//
//	Access:  		public
//
//	Arguments:		
//	awo_control		The window object being registered.
//	as_method		The desired resize/move method.
//						Valid values are:
//						 'FixedToRight'
//						 'FixedToBottom'
//						 'FixedToRight&Bottom'
//						 'Scale'
//						 'ScaleToRight'
//						 'ScaleToBottom'
//						 'ScaleToRight&Bottom'
//						 'FixedToRight&ScaleToBottom'
//						 'FixedToBottom&ScaleToRight'
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Register a control which needs to either be moved or resized
//						when the parent object is resized. 
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	6.0	Changed to use constants for checking resize method.
// 6.0	Changed to support for weighted movement and sizing of controls.
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
constant integer FULL_PERCENT= 100

integer	li_movex, li_movey
integer	li_scalewidth, li_scaleheight
boolean	lb_scale = False

//Check parameters
If IsNull(awo_control) or (not IsValid(awo_control)) or IsNull(as_method) Then
	Return -1
End If

//Translate and finish validating parameteters
Choose Case Lower(as_method)
	Case Lower(FIXEDRIGHT)
		li_movex = FULL_PERCENT
	Case Lower(FIXEDBOTTOM)
		li_movey = FULL_PERCENT
	Case Lower(FIXEDRIGHTBOTTOM)
		li_movex = FULL_PERCENT
		li_movey = FULL_PERCENT
	Case Lower(SCALE)
		lb_scale = True
	Case Lower(SCALERIGHT)
		li_scalewidth = FULL_PERCENT
	Case Lower(SCALEBOTTOM)
		li_scaleheight = FULL_PERCENT
	Case Lower(SCALERIGHTBOTTOM)
		li_scalewidth = FULL_PERCENT
		li_scaleheight = FULL_PERCENT
	Case Lower(FIXEDRIGHT_SCALEBOTTOM)
		li_movex = FULL_PERCENT
		li_scaleheight = FULL_PERCENT
	Case Lower(FIXEDBOTTOM_SCALERIGHT)
		li_movey = FULL_PERCENT
		li_scalewidth = FULL_PERCENT
Case Else
		Return -1
End Choose

Return of_Register(awo_control, lb_scale, li_movex, li_movey, li_scalewidth, li_scaleheight)
end function

public function integer of_setminsize (integer ai_minwidth, integer ai_minheight);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_SetMinSize
//
//	Access:  		public
//
//	Arguments:		
//	ai_minwidth		The minimum width for the parent object.
//	ai_minheight	The minimum height for the parent object.
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Sets the current object minimum size attributes.
//						Note: the service object needs to be initialized (of_SetOrigSize())
//						prior to	setting the Minimum size of the object.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

//Check parameters
If	IsNull(ai_minwidth) or IsNull(ai_minheight) Then
	Return -1
End If

//Confirm that the user object has already been initialized
If il_parentprevheight=-1 And il_parentprevwidth=-1 Then
	Return -1
End If

//Set the minimum values for the width and height
il_parentminimumwidth = ai_minwidth
il_parentminimumheight = ai_minheight

Return 1
end function

public function integer of_SetOrigSize (integer ai_width, integer ai_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_SetOrigSize
//
//	Access:  		public
//
//	Arguments:		
//	ai_width			The current width of the parent object.
//	ai_height		The current height of the parent object.
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Initializes the Resize object by setting the current object
//						size.
//						Note: the service object needs to be initialized (this function)
//						prior to	the registering (of_register()) of objects.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

//Check parameters
If IsNull(ai_width) or IsNull(ai_height) Then
	Return -1
End If

//Set the current width and height
il_parentprevwidth = ai_width
il_parentprevheight = ai_height

Return 1
end function

public function integer of_register (windowobject awo_control, integer ai_movex, integer ai_movey, integer ai_scalewidth, integer ai_scaleheight);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_Register
//
//	Access:  		public
//
//	Arguments:		
//	 awo_control	The window object being registered.
//  ai_movex			The percentage to move the object along the x axis.
//  ai_movey			The percentage to move the object along the y axis.
//  ai_scalewidth 	The percentage to scale the object along the x axis.
//  ai_scaleheight	The percentage to scale the object along the y axis.
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Register a control which needs to either be moved or resized
//						when the parent object is resized.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	6.0    Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
Return of_Register (awo_control, false, ai_movex, ai_movey, ai_scalewidth, ai_scaleheight)
end function

protected function integer of_register (windowobject awo_control, boolean ab_scale, integer ai_movex, integer ai_movey, integer ai_scalewidth, integer ai_scaleheight);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_Register
//
//	Access:  		public
//
//	Arguments:		
//	 awo_control		The window object being registered.
//  ab_scale			If the object should be registered as a Scale type.
//  ai_movex			The percentage to move the object along the x axis.
//  ai_movey			The percentage to move the object along the y axis.
//  ai_scalewidth 	The percentage to scale the object along the x axis.
//  ai_scaleheight	The percentage to scale the object along the y axis.
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Register a control which needs to either be moved or resized
//						when the parent object is resized.  The action taken on this
//						control depends on the four attributes: ai_movex, ai ai_movey,
//						ai_scalewidth, ai_scaleheight.
//						Note: the service object needs to be initialized (of_SetOrigSize())
//						prior to	any registering (this function) of objects.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	6.0    Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
dragobject		ldrg_cntrl
oval				loval_cntrl
line				ln_cntrl
rectangle		lrec_cntrl
roundrectangle	lrrec_cntrl

integer	li_x, li_y, li_width, li_height
integer	li_upperbound
integer	li_cnt
integer	li_slot_available
boolean	lb_movex = False, lb_movey = False
boolean	lb_scalewidth = False, lb_scaleheight = False

//Check parameters
If IsNull(awo_control) or Not IsValid(awo_control) or &
	IsNull(ab_scale) or &
	IsNull(ai_movex) or ai_movex<0 or ai_movex>100 or &
	IsNull(ai_movey) or ai_movey<0 or ai_movey>100 or &
	IsNull(ai_scalewidth) or ai_scalewidth<0 or ai_scalewidth>100 or & 
	IsNull(ai_scaleheight) or ai_scaleheight<0 or ai_scaleheight>100 Then
	Return -1
End If

//Translate parameteters.
If ab_scale Then
	ai_movex = 0
	ai_movey = 0
	ai_scalewidth = 0
	ai_scaleheight = 0
End If
lb_movex = (ai_movex > 0)
lb_movey = (ai_movey > 0)
lb_scalewidth = (ai_scalewidth > 0)
lb_scaleheight = (ai_scaleheight > 0)

//Confirm that the user object has already been initialized
If il_parentprevheight=-1 And il_parentprevwidth=-1 Then
	Return -1
End If

//Get the previous Bound
li_upperbound = UpperBound (inv_registered[])

//Determine if there is an open slot available other than a
//new entry on the array
li_slot_available = 0
For li_cnt = 1 to li_upperbound
	If IsNull(inv_registered[li_cnt].wo_control) Or &
		Not IsValid(inv_registered[li_cnt].wo_control) Then
		If li_slot_available = 0 Then
			//Get the first slot found
			li_slot_available = li_cnt
		End If
	Else
		//Check if control has already been registered
		If inv_registered[li_cnt].wo_control = awo_control Then
			Return -1
		End If
	End If
Next

//If an available slot was not found then create a new entry
If li_slot_available = 0 Then
	li_slot_available = li_upperbound + 1
End If

///////////////////////////////////////////////////////////////////////////////////////
//Register the new object
///////////////////////////////////////////////////////////////////////////////////////

//Validate and set typeof value
//Store the type of the control to speed access to its attributes
//Store the position and size of control
//Store a reference to the control
Choose Case of_TypeOf(awo_control)
	Case DRAGOBJECT
		ldrg_cntrl = awo_control
		inv_registered[li_slot_available].s_typeof = DRAGOBJECT
		choose case ldrg_cntrl.TypeOf()
			case datawindow!

				li_x = ldrg_cntrl.X
				li_y = ldrg_cntrl.Y
				li_width = ldrg_cntrl.Width
				li_height = ldrg_cntrl.Height
			case else
				li_x = ldrg_cntrl.X
				li_y = ldrg_cntrl.Y
				li_width = ldrg_cntrl.Width
				li_height = ldrg_cntrl.Height
		end choose
//		ldrg_cntrl = awo_control
//		inv_registered[li_slot_available].s_typeof = DRAGOBJECT
//		li_x = ldrg_cntrl.X
//		li_y = ldrg_cntrl.Y
//		li_width = ldrg_cntrl.Width
//		li_height = ldrg_cntrl.Height
	Case LINE
		ln_cntrl = awo_control
		inv_registered[li_slot_available].s_typeof = LINE		
		li_x = ln_cntrl.BeginX
		li_y = ln_cntrl.BeginY
		li_width = ln_cntrl.EndX
		li_height = ln_cntrl.EndY
	Case OVAL
		loval_cntrl = awo_control
		inv_registered[li_slot_available].s_typeof = OVAL			
		li_x = loval_cntrl.X
		li_y = loval_cntrl.Y
		li_width = loval_cntrl.Width
		li_height = loval_cntrl.Height		
	Case RECTANGLE
		lrec_cntrl = awo_control
		inv_registered[li_slot_available].s_typeof = RECTANGLE		
		li_x = lrec_cntrl.X
		li_y = lrec_cntrl.Y
		li_width = lrec_cntrl.Width
		li_height = lrec_cntrl.Height		
	Case ROUNDRECTANGLE
		lrrec_cntrl = awo_control
		inv_registered[li_slot_available].s_typeof = ROUNDRECTANGLE				
		li_x = lrrec_cntrl.X
		li_y = lrrec_cntrl.Y
		li_width = lrrec_cntrl.Width
		li_height = lrrec_cntrl.Height
	Case Else
		//An unknown control type has been encountered
		Return -1
End Choose

//Register the actual object
inv_registered[li_slot_available].wo_control = awo_control
inv_registered[li_slot_available].s_classname = awo_control.ClassName()

//Set the behavior attributes
inv_registered[li_slot_available].b_movex = lb_movex
inv_registered[li_slot_available].i_movex = ai_movex
inv_registered[li_slot_available].b_movey = lb_movey
inv_registered[li_slot_available].i_movey = ai_movey
inv_registered[li_slot_available].b_scalewidth = lb_scalewidth
inv_registered[li_slot_available].i_scalewidth = ai_scalewidth
inv_registered[li_slot_available].b_scaleheight = lb_scaleheight
inv_registered[li_slot_available].i_scaleheight = ai_scaleheight
inv_registered[li_slot_available].b_scale = ab_scale

//Set the initial position/size attributes
inv_registered[li_slot_available].r_x = li_x
inv_registered[li_slot_available].r_y = li_y
inv_registered[li_slot_available].r_width = li_width
inv_registered[li_slot_available].r_height = li_height

Return 1
end function

protected function string of_typeof (windowobject awo_control);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_TypeOf
//
//	Access:  		protected
//
//	Arguments:		
//	awo_control		The window object for which a type is needed.
//
//	Returns:  		string
//						Describes the type of the object.
//						'!' if an error occurs.
//
//	Description:  	Determines on the type of an object for the purposes of 
//						getting to its attributes.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 6.0	Changed to use new constants.
// 7.0	Added new controls hprogressbar!, htrackbar!, vprogressbar!,
//			vtrackbar!, picturehyperlink!, statichyperlink!
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

//Check parameters
If IsNull(awo_control) or (not IsValid(awo_control)) Then
	Return '!'
End If

//Validate and set typeof value
Choose Case awo_control.TypeOf()
	Case  checkbox!, commandbutton!, datawindow!, dropdownlistbox!, dropdownpicturelistbox!, &
			editmask!, graph!, groupbox!, hprogressbar!, hscrollbar!, htrackbar!, inkpicture!, listbox!,  &
			listview!, multilineedit!, olecontrol!, olecustomcontrol!, omcontrol!, omcustomcontrol!,  &
			omembeddedcontrol!, picture!, picturebutton!, picturehyperlink!, picturelistbox!,  &
			radiobutton!, richtextedit!, singlelineedit!, statichyperlink!, statictext!,  &
			tab!, treeview!, userobject!, vprogressbar!, vscrollbar!, vtrackbar!
		Return DRAGOBJECT
	Case  line!
		Return LINE
	Case  oval!
		Return OVAL
	Case  rectangle!
		Return RECTANGLE
	Case  roundrectangle!
		Return ROUNDRECTANGLE
	Case  mdiclient!
		Return MDICLIENT
End Choose

Return '!'
end function

public function integer of_getminmaxpoints (windowobject awo_control[], ref integer ai_min_x, ref integer ai_min_y, ref integer ai_max_x, ref integer ai_max_y);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_GetMinMaxPoints
//
//	Access:  		public
//
//	Arguments:		
//	awo_control[]	The control array for whom the Min and Max attributes are needed.
//	ai_min_x			The minimum X point found by looking at the X attributes of all
//							the controls on the control array (by reference).
//	ai_min_y			The minimum Y point found by looking at the X attributes of all
//							the controls on the control array (by reference).
//	ai_max_x			The maximum X point found by adding the X and Width attributes
//							of all the controls on the control array (by reference).
//	ai_max_y			The maximum Y point found by adding the Y and Height attributes
//							of all the controls on the control array (by reference).
//
//	Returns:  		integer
//						1 if it succeeds and?-1 if an error occurs.
//
//	Description:  	Determines the four extreme points of the controls within a 
//						control array by looking at the X, Y, Width, Height, BeginX, 
//						BeginY, EndX, EndY attributes.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 6.0	Changed to use new constants.
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
dragobject		ldrg_cntrl
oval				loval_cntrl
line				ln_cntrl
rectangle		lrec_cntrl
roundrectangle	lrrec_cntrl

integer			li_x, li_y, li_width, li_height, li_temp
integer			li_upperbound
integer			li_cnt

//Check arguments
If IsNull(awo_control) or IsNull(awo_control[]) or UpperBound(awo_control[])=0 Then
	Return -1
End If

//Initialize
ai_min_x=32767
ai_min_y=32767
ai_max_x=0
ai_max_y=0

//Get the Control upper bound
li_upperbound = UpperBound (awo_control[])

//Determine position of the right most and bottom most control.
For li_cnt = 1 to li_upperbound
	If IsValid(awo_control[li_cnt]) Then
		Choose Case of_TypeOf(awo_control[li_cnt])
			Case DRAGOBJECT
				//Set a reference to the control.
				ldrg_cntrl = awo_control[li_cnt]
				//Get the position, width, and height of the control.
				li_x = ldrg_cntrl.X
				li_y = ldrg_cntrl.Y
				li_width = ldrg_cntrl.Width
				li_height = ldrg_cntrl.Height
			Case LINE
				ln_cntrl = awo_control[li_cnt]
				li_x = ln_cntrl.BeginX
				li_y = ln_cntrl.BeginY
				li_width = ln_cntrl.EndX
				li_height = ln_cntrl.EndY
				//Correct for lines that may have the End points 
				//before to the Begin points.
				If li_width >= li_x Then
					li_width = li_width - li_x
				Else
					li_temp = li_x
					li_x = li_width
					li_width = li_temp - li_x
				End If	
				If li_height >= li_y Then
					li_height = li_height - li_y
				Else
					li_temp = li_y
					li_y = li_height
					li_height = li_temp - li_y
				End If
			Case OVAL
				loval_cntrl = awo_control[li_cnt]
				li_x = loval_cntrl.X
				li_y = loval_cntrl.Y
				li_width = loval_cntrl.Width
				li_height = loval_cntrl.Height		
			Case RECTANGLE
				lrec_cntrl = awo_control[li_cnt]
				li_x = lrec_cntrl.X
				li_y = lrec_cntrl.Y
				li_width = lrec_cntrl.Width
				li_height = lrec_cntrl.Height		
			Case ROUNDRECTANGLE
				lrrec_cntrl = awo_control[li_cnt]
				li_x = lrrec_cntrl.X
				li_y = lrrec_cntrl.Y
				li_width = lrrec_cntrl.Width
				li_height = lrrec_cntrl.Height
			Case MDICLIENT
				Continue
			Case Else
				//An unknown control type has been encountered
				Return -1
		End Choose
		
		//Determine the Min and Max points
		If li_x < ai_min_x Then ai_min_x = li_x
		If li_y < ai_min_y Then ai_min_y = li_y
		If li_x + li_width > ai_max_x Then ai_max_x = li_x + li_width
		If li_y + li_height > ai_max_y Then ai_max_y = li_y + li_height
		
	End If
Next

Return 1
end function

protected function integer of_resize (integer ai_newwidth, integer ai_newheight);//////////////////////////////////////////////////////////////////////////////
//	Protected Function:		of_Resize
//	Arguments:					ai_newwidth		The new width of the parent object.
//									ai_newheight	The new height of the parent object.
//	Returns:  					integer
//									1 if it succeeds and?-1 if an error occurs.
//	Description:  				Moves or resizes objects that were registered with the service.
//									Performs the actions that were requested via the
//									of_SetOrigSize() and of_Register functions.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History					Version
//									5.0		Initial version
// 									6.0		Changed to support for weighted movement and sizing of controls.
// 									6.0		Changed to use new constants.
//									8.0		Changed from Move for drawing objects to setting X and Y
//////////////////////////////////////////////////////////////////////////////
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//Note: For the line control: the width and height variables are
//										used to hold EndX and EndY attributes.
//////////////////////////////////////////////////////////////////////////////
//Temporary controls to get to attributes
dragobject		ldrg_cntrl
oval				loval_cntrl
line				lln_cntrl
rectangle		lrec_cntrl
roundrectangle	lrrec_cntrl

//Local variables
integer	li_upperbound, li_cnt
integer	li_x, li_y, li_width, li_height
integer	li_deltawidth, li_deltaheight

real	lr_ratiowidth, lr_ratioheight
real	lr_move_deltax, lr_move_deltay
real	lr_resize_deltawidth, lr_resize_deltaheight

//Confirm that the user object has already been initialized
If il_parentprevheight=-1 And il_parentprevwidth=-1 Then
	Return -1
End If

//Check the parameters
If IsNull(ai_newwidth) or IsNull(ai_newheight) Then
	return -1
End If

//Prevent the contents of the windows from resizing past the min width/height
If ai_newwidth < il_parentminimumwidth   Then ai_newwidth = il_parentminimumwidth
If ai_newheight < il_parentminimumheight Then ai_newheight = il_parentminimumheight

//Set the deltas/ratios for the width and height as compared to the previous size
li_deltawidth  = ai_newwidth  - il_parentprevwidth 
li_deltaheight = ai_newheight - il_parentprevheight
If il_parentprevwidth=0 Then il_parentprevwidth=1
If il_parentprevheight=0 Then il_parentprevheight=1	
lr_ratiowidth  = ai_newwidth  / il_parentprevwidth
lr_ratioheight = ai_newheight / il_parentprevheight

//Only continue if the size has changed
If li_deltawidth=0 And li_deltaheight=0 Then Return 1

//Set the new previous size
il_parentprevwidth = ai_newwidth
il_parentprevheight = ai_newheight

///////////////////////////////////////////////////////////////////////////////////////////////
// Loop through all registered controls - Moving and resizing as appropriate
///////////////////////////////////////////////////////////////////////////////////////////////

//Loop trough all controls
li_upperbound = UpperBound (inv_registered[])
For li_cnt = 1 to li_upperbound
	//Initialize variables
	li_x = 0
	li_y = 0 
	li_width = 0
	li_height = 0
	lr_move_deltax = 0	
	lr_move_deltay = 0
	lr_resize_deltawidth = 0	
	lr_resize_deltaheight = 0	
	SetNull(ldrg_cntrl)
	SetNull(loval_cntrl)
	SetNull(lln_cntrl)
	SetNull(lrec_cntrl)
	SetNull(lrrec_cntrl)
	
	If IsValid(inv_registered[li_cnt].wo_control) Then
		//Get attribute information from the appropriate control
		Choose Case inv_registered[li_cnt].s_typeof
			Case DRAGOBJECT
				ldrg_cntrl = inv_registered[li_cnt].wo_control
				li_x = ldrg_cntrl.X
				li_y = ldrg_cntrl.Y
				li_width = ldrg_cntrl.Width
				li_height = ldrg_cntrl.Height
			Case LINE
				// For the line control, the width and height variables 
				// are used to hold EndX and EndY attributes
				lln_cntrl = inv_registered[li_cnt].wo_control
				li_x = lln_cntrl.BeginX
				li_y = lln_cntrl.BeginY
				li_width = lln_cntrl.EndX
				li_height = lln_cntrl.EndY
			Case OVAL
				loval_cntrl = inv_registered[li_cnt].wo_control
				li_x = loval_cntrl.X
				li_y = loval_cntrl.Y
				li_width = loval_cntrl.Width
				li_height = loval_cntrl.Height	
			Case RECTANGLE
				lrec_cntrl = inv_registered[li_cnt].wo_control
				li_x = lrec_cntrl.X
				li_y = lrec_cntrl.Y
				li_width = lrec_cntrl.Width
				li_height = lrec_cntrl.Height
			Case ROUNDRECTANGLE
				lrrec_cntrl = inv_registered[li_cnt].wo_control			
				li_x = lrrec_cntrl.X
				li_y = lrrec_cntrl.Y
				li_width = lrrec_cntrl.Width
				li_height = lrrec_cntrl.Height				
			Case Else
				Return -1
		End Choose
		
		//Correct for any rounding or moving/resizing of objects trough
		//any other means
		If abs(inv_registered[li_cnt].r_x - li_x) > ii_rounding Then
			inv_registered[li_cnt].r_x = li_x
		End If				
		If abs(inv_registered[li_cnt].r_y - li_y) > ii_rounding Then
			inv_registered[li_cnt].r_y = li_y
		End If		
		If abs(inv_registered[li_cnt].r_width - li_width) > ii_rounding And &
		   li_width > inv_registered[li_cnt].i_widthmin Then
			inv_registered[li_cnt].r_width = li_width
		End If							
		If abs(inv_registered[li_cnt].r_height - li_height) > ii_rounding And &
		   li_height > inv_registered[li_cnt].i_heightmin Then
			inv_registered[li_cnt].r_height = li_height
		End If			
		
		//Define the deltas for this control:  Move and Resize
		If inv_registered[li_cnt].b_scale Then
			lr_move_deltax = (inv_registered[li_cnt].r_x * lr_ratiowidth) - inv_registered[li_cnt].r_x
			lr_move_deltay = (inv_registered[li_cnt].r_y * lr_ratioheight) - inv_registered[li_cnt].r_y
			lr_resize_deltawidth = (inv_registered[li_cnt].r_width * lr_ratiowidth) - inv_registered[li_cnt].r_width
			lr_resize_deltaheight = (inv_registered[li_cnt].r_height * lr_ratioheight) - inv_registered[li_cnt].r_height
		Else
			// Prevent the weighted value from being overriden.
			If inv_registered[li_cnt].b_movex And inv_registered[li_cnt].i_movex = 0 Then
				inv_registered[li_cnt].i_movex = 100
			End If
			If inv_registered[li_cnt].b_movey And inv_registered[li_cnt].i_movey = 0 Then
				inv_registered[li_cnt].i_movey = 100
			End If
			If inv_registered[li_cnt].b_scalewidth And inv_registered[li_cnt].i_scalewidth=0 Then
				inv_registered[li_cnt].i_scalewidth = 100
			End If
			If inv_registered[li_cnt].b_scaleheight And inv_registered[li_cnt].i_scaleheight=0 Then
				inv_registered[li_cnt].i_scaleheight = 100
			End If			
			
			// Support for weighted movement and sizing of controls.
			If inv_registered[li_cnt].b_movex Then 
				lr_move_deltax = li_deltawidth * inv_registered[li_cnt].i_movex / 100
			End If
			If inv_registered[li_cnt].b_movey Then 
				lr_move_deltay = li_deltaheight * inv_registered[li_cnt].i_movey / 100
			End If
			If inv_registered[li_cnt].b_scalewidth Then 
				lr_resize_deltawidth = li_deltawidth * inv_registered[li_cnt].i_scalewidth / 100
			End If
			If inv_registered[li_cnt].b_scaleheight Then 
				lr_resize_deltaheight = li_deltaheight * inv_registered[li_cnt].i_scaleheight /100
			End If
		End If

		//If appropriate move the control along the X and Y attribute.
		If lr_move_deltax <> 0 Or lr_move_deltay <> 0 Then	
			//Save the 'exact' X and Y attributes.
			inv_registered[li_cnt].r_x = inv_registered[li_cnt].r_x + lr_move_deltax		
			inv_registered[li_cnt].r_y = inv_registered[li_cnt].r_y + lr_move_deltay
			Choose Case inv_registered[li_cnt].s_typeof
				Case DRAGOBJECT
					ldrg_cntrl.Move (inv_registered[li_cnt].r_x, inv_registered[li_cnt].r_y)
				Case LINE
					//X moving
					lln_cntrl.BeginX = inv_registered[li_cnt].r_x
					inv_registered[li_cnt].r_width = inv_registered[li_cnt].r_width + lr_move_deltax					
					lln_cntrl.EndX = inv_registered[li_cnt].r_width
					//Y moving
					lln_cntrl.BeginY = inv_registered[li_cnt].r_y
					inv_registered[li_cnt].r_height = inv_registered[li_cnt].r_height + lr_move_deltay
					lln_cntrl.EndY = inv_registered[li_cnt].r_height					
				Case OVAL
					loval_cntrl.X = inv_registered[li_cnt].r_x
					loval_cntrl.Y = inv_registered[li_cnt].r_y
				Case RECTANGLE
					lrec_cntrl.X = inv_registered[li_cnt].r_x
					lrec_cntrl.Y = inv_registered[li_cnt].r_y
				Case ROUNDRECTANGLE
					lrrec_cntrl.X = inv_registered[li_cnt].r_x
					lrrec_cntrl.Y = inv_registered[li_cnt].r_y
			End Choose	
		End If /* Move */
		
		//If appropriate Resize the Width And Height of the control.
		//Performing one Resize instead of changing Width and Height individually.
		If lr_resize_deltawidth <> 0 Or lr_resize_deltaheight <> 0 Then		
			//Save the 'exact' Width and Height attributes.
			//IF inv_registered[li_cnt].s_typeof = DRAGOBJECT THEN ::CLIPBOARD(STRING(inv_registered[li_cnt].r_width) + '~r~n' + STRING(lr_resize_deltawidth))
			//IF inv_registered[li_cnt].r_width = 1641 THEN inv_registered[li_cnt].r_width = inv_registered[li_cnt].r_width - lr_resize_deltawidth
			inv_registered[li_cnt].r_width = inv_registered[li_cnt].r_width + lr_resize_deltawidth	
			inv_registered[li_cnt].r_height = inv_registered[li_cnt].r_height + lr_resize_deltaheight		
			Choose Case inv_registered[li_cnt].s_typeof
				Case DRAGOBJECT
					ldrg_cntrl.Resize (inv_registered[li_cnt].r_width, inv_registered[li_cnt].r_height)
					li_width = ldrg_cntrl.Width
					li_height = ldrg_cntrl.Height
				Case LINE
					lln_cntrl.EndX = inv_registered[li_cnt].r_width
				Case OVAL
					loval_cntrl.Resize (inv_registered[li_cnt].r_width, inv_registered[li_cnt].r_height)
					li_width = loval_cntrl.Width
					li_height = loval_cntrl.Height					
				Case RECTANGLE
					lrec_cntrl.Resize (inv_registered[li_cnt].r_width, inv_registered[li_cnt].r_height)
					li_width = lrec_cntrl.Width
					li_height = lrec_cntrl.Height	
				Case ROUNDRECTANGLE
					lrrec_cntrl.Resize (inv_registered[li_cnt].r_width, inv_registered[li_cnt].r_height)
					li_width = lrrec_cntrl.Width
					li_height = lrrec_cntrl.Height					
			End Choose		
			
			//Determine if the object does not support the requested Width or Height.
			//Used to determine if the object was resized by any other means.
			If li_width > inv_registered[li_cnt].r_width Then
				inv_registered[li_cnt].i_widthmin = li_width
			Else
				inv_registered[li_cnt].i_widthmin = 0
			End If
			If li_height > inv_registered[li_cnt].r_height Then
				inv_registered[li_cnt].i_heightmin = li_height
			Else
				inv_registered[li_cnt].i_heightmin = 0
			End If					
		End If /* Resize */

	End If /* If IsValid(inv_registered[li_cnt].wo_control) Then */

Next /* For li_cnt = 1 to li_upperbound */

Return 1
end function

public function string of_getresizemethod (readonly windowobject awo_control);// check parameter
if isnull(awo_control) then return '!'
if not isvalid(awo_control) then return '!'
if awo_control.triggerevent("oue_components") <> 1 then return '!'

boolean lb_fixedtoright
boolean lb_fixedtobottom
boolean lb_scaletoright
boolean lb_scaletobottom
string ls_method

// validate and set typeof value
choose case awo_control.typeof()
	case checkbox!
		pf_u_checkbox lcbx_control
		lcbx_control = awo_control
		lb_fixedtoright = lcbx_control.fixedtoright
		lb_fixedtobottom = lcbx_control.fixedtobottom
		lb_scaletoright = lcbx_control.scaletoright
		lb_scaletobottom = lcbx_control.scaletobottom
	case commandbutton!
		pf_u_commandbutton lcb_control
		lcb_control = awo_control
		lb_fixedtoright = lcb_control.fixedtoright
		lb_fixedtobottom = lcb_control.fixedtobottom
		lb_scaletoright = lcb_control.scaletoright
		lb_scaletobottom = lcb_control.scaletobottom
	case datawindow!
		fw_u_dwo ldw_control
		ldw_control = awo_control
		lb_fixedtoright = ldw_control.fixedtoright
		lb_fixedtobottom = ldw_control.fixedtobottom
		lb_scaletoright = ldw_control.scaletoright
		lb_scaletobottom = ldw_control.scaletobottom
	case dropdownlistbox!
		pf_u_dropdownlistbox lddlb_control
		lddlb_control = awo_control
		lb_fixedtoright = lddlb_control.fixedtoright
		lb_fixedtobottom = lddlb_control.fixedtobottom
		lb_scaletoright = lddlb_control.scaletoright
		lb_scaletobottom = lddlb_control.scaletobottom
	case dropdownpicturelistbox!
		pf_u_dropdownpicturelistbox lddplb_control
		lddplb_control = awo_control
		lb_fixedtoright = lddplb_control.fixedtoright
		lb_fixedtobottom = lddplb_control.fixedtobottom
		lb_scaletoright = lddplb_control.scaletoright
		lb_scaletobottom = lddplb_control.scaletobottom
	case graph!
		pf_u_graph lgr_control
		lgr_control = awo_control
		lb_fixedtoright = lgr_control.fixedtoright
		lb_fixedtobottom = lgr_control.fixedtobottom
		lb_scaletoright = lgr_control.scaletoright
		lb_scaletobottom = lgr_control.scaletobottom
	case groupbox!
		pf_u_groupbox lgbx_control
		lgbx_control = awo_control
		lb_fixedtoright = lgbx_control.fixedtoright
		lb_fixedtobottom = lgbx_control.fixedtobottom
		lb_scaletoright = lgbx_control.scaletoright
		lb_scaletobottom = lgbx_control.scaletobottom
	case hscrollbar!
		pf_u_hscrollbar lhsb_control
		lhsb_control = awo_control
		lb_fixedtoright = lhsb_control.fixedtoright
		lb_fixedtobottom = lhsb_control.fixedtobottom
		lb_scaletoright = lhsb_control.scaletoright
		lb_scaletobottom = lhsb_control.scaletobottom
//	case inkpicture!
//		pf_u_inkpicture linkp_controls
//		linkp_controls = awo_control
//		lb_fixedtoright = linkp_controls.fixedtoright
//		lb_fixedtobottom = linkp_controls.fixedtobottom
//		lb_scaletoright = linkp_controls.scaletoright
//		lb_scaletobottom = linkp_controls.scaletobottom
	case listbox!
		pf_u_listbox llb_control
		llb_control = awo_control
		lb_fixedtoright = llb_control.fixedtoright
		lb_fixedtobottom = llb_control.fixedtobottom
		lb_scaletoright = llb_control.scaletoright
		lb_scaletobottom = llb_control.scaletobottom
	case picturelistbox!
		pf_u_picturelistbox lplb_control
		lplb_control = awo_control
		lb_fixedtoright = lplb_control.fixedtoright
		lb_fixedtobottom = lplb_control.fixedtobottom
		lb_scaletoright = lplb_control.scaletoright
		lb_scaletobottom = lplb_control.scaletobottom
	case listview!
		pf_u_listview llv_control
		llv_control = awo_control
		lb_fixedtoright = llv_control.fixedtoright
		lb_fixedtobottom = llv_control.fixedtobottom
		lb_scaletoright = llv_control.scaletoright
		lb_scaletobottom = llv_control.scaletobottom
	case multilineedit!
		pf_u_multilineedit lmle_control
		lmle_control = awo_control
		lb_fixedtoright = lmle_control.fixedtoright
		lb_fixedtobottom = lmle_control.fixedtobottom
		lb_scaletoright = lmle_control.scaletoright
		lb_scaletobottom = lmle_control.scaletobottom
	case editmask!
		pf_u_editmask lem_control
		lem_control = awo_control
		lb_fixedtoright = lem_control.fixedtoright
		lb_fixedtobottom = lem_control.fixedtobottom
		lb_scaletoright = lem_control.scaletoright
		lb_scaletobottom = lem_control.scaletobottom
	case picture!
		choose case awo_control.dynamic of_thisname()
			case 'pf_u_imagebutton'
				pf_u_imagebutton lib_control
				lib_control = awo_control
				lb_fixedtoright = lib_control.fixedtoright
				lb_fixedtobottom = lib_control.fixedtobottom
				lb_scaletoright = lib_control.scaletoright
				lb_scaletobottom = lib_control.scaletobottom
//			case 'pf_u_texturebutton'
//				pf_u_texturebutton ltb_control
//				ltb_control = awo_control
//				lb_fixedtoright = ltb_control.fixedtoright
//				lb_fixedtobottom = ltb_control.fixedtobottom
//				lb_scaletoright = ltb_control.scaletoright
//				lb_scaletobottom = ltb_control.scaletobottom
			case else
				pf_u_picture lp_control
				lp_control = awo_control
				lb_fixedtoright = lp_control.fixedtoright
				lb_fixedtobottom = lp_control.fixedtobottom
				lb_scaletoright = lp_control.scaletoright
				lb_scaletobottom = lp_control.scaletobottom
		end choose
	case picturebutton!
		pf_u_picturebutton lpb_control
		lpb_control = awo_control
		lb_fixedtoright = lpb_control.fixedtoright
		lb_fixedtobottom = lpb_control.fixedtobottom
		lb_scaletoright = lpb_control.scaletoright
		lb_scaletobottom = lpb_control.scaletobottom
	case radiobutton!
		pf_u_radiobutton lrb_control
		lrb_control = awo_control
		lb_fixedtoright = lrb_control.fixedtoright
		lb_fixedtobottom = lrb_control.fixedtobottom
		lb_scaletoright = lrb_control.scaletoright
		lb_scaletobottom = lrb_control.scaletobottom
	case richtextedit!
		pf_u_richtextedit lrte_control
		lrte_control = awo_control
		lb_fixedtoright = lrte_control.fixedtoright
		lb_fixedtobottom = lrte_control.fixedtobottom
		lb_scaletoright = lrte_control.scaletoright
		lb_scaletobottom = lrte_control.scaletobottom
	case singlelineedit!
		pf_u_singlelineedit lsle_control
		lsle_control = awo_control
		lb_fixedtoright = lsle_control.fixedtoright
		lb_fixedtobottom = lsle_control.fixedtobottom
		lb_scaletoright = lsle_control.scaletoright
		lb_scaletobottom = lsle_control.scaletobottom
	case statictext!
		choose case awo_control.dynamic of_thisname()
			case 'pf_u_statictext'
				pf_u_statictext lst_control
				lst_control = awo_control
				lb_fixedtoright = lst_control.fixedtoright
				lb_fixedtobottom = lst_control.fixedtobottom
				lb_scaletoright = lst_control.scaletoright
				lb_scaletobottom = lst_control.scaletobottom
			case 'pf_u_titletext'
				pf_u_titletext ltt_control
				ltt_control = awo_control
				lb_fixedtoright = ltt_control.fixedtoright
				lb_fixedtobottom = ltt_control.fixedtobottom
				lb_scaletoright = ltt_control.scaletoright
				lb_scaletobottom = ltt_control.scaletobottom
			case 'pf_u_splitbar_horizontal'
				pf_u_splitbar_horizontal lsbh_control
				lsbh_control = awo_control
				lb_fixedtoright = lsbh_control.fixedtoright
				lb_fixedtobottom = lsbh_control.fixedtobottom
				lb_scaletoright = lsbh_control.scaletoright
				lb_scaletobottom = lsbh_control.scaletobottom
			case 'pf_u_splitbar_vertical'
				pf_u_splitbar_vertical lsbv_control
				lsbv_control = awo_control
				lb_fixedtoright = lsbv_control.fixedtoright
				lb_fixedtobottom = lsbv_control.fixedtobottom
				lb_scaletoright = lsbv_control.scaletoright
				lb_scaletobottom = lsbv_control.scaletobottom
		end choose
	case tab!
//		pf_u_tab lt_control
//		lt_control = awo_control
//		lb_fixedtoright = lt_control.fixedtoright
//		lb_fixedtobottom = lt_control.fixedtobottom
//		lb_scaletoright = lt_control.scaletoright
//		lb_scaletobottom = lt_control.scaletobottom
	case treeview!
		pf_u_treeview ltv_control
		ltv_control = awo_control
		lb_fixedtoright = ltv_control.fixedtoright
		lb_fixedtobottom = ltv_control.fixedtobottom
		lb_scaletoright = ltv_control.scaletoright
		lb_scaletobottom = ltv_control.scaletobottom
	case userobject!
		choose case awo_control.dynamic of_thisname()
			case 'pf_u_tab'
				pf_u_tab lut_control
				lut_control = awo_control
				lb_fixedtoright = lut_control.fixedtoright
				lb_fixedtobottom = lut_control.fixedtobottom
				lb_scaletoright = lut_control.scaletoright
				lb_scaletobottom = lut_control.scaletobottom
			case else
				u_ancestor luo_control
				luo_control = awo_control
				lb_fixedtoright = luo_control.fixedtoright
				lb_fixedtobottom = luo_control.fixedtobottom
				lb_scaletoright = luo_control.scaletoright
				lb_scaletobottom = luo_control.scaletobottom
		end choose
	case vscrollbar!
		pf_u_vscrollbar lvsb_control
		lvsb_control = awo_control
		lb_fixedtoright = lvsb_control.fixedtoright
		lb_fixedtobottom = lvsb_control.fixedtobottom
		lb_scaletoright = lvsb_control.scaletoright
		lb_scaletobottom = lvsb_control.scaletobottom
	case olecustomcontrol!
		choose case awo_control.dynamic of_thisname()
			case 'pf_u_webbrowser', 'pf_u_webeditor'
				pf_u_webbrowser lwb_control
				lwb_control = awo_control
				lb_fixedtoright = lwb_control.fixedtoright
				lb_fixedtobottom = lwb_control.fixedtobottom
				lb_scaletoright = lwb_control.scaletoright
				lb_scaletobottom = lwb_control.scaletobottom
			case 'fw_u_cht4browser'
				fw_u_cht4browser lwb_chtcontrol
				lwb_chtcontrol = awo_control
				lb_fixedtoright = lwb_chtcontrol.fixedtoright
				lb_fixedtobottom = lwb_chtcontrol.fixedtobottom
				lb_scaletoright = lwb_chtcontrol.scaletoright
				lb_scaletobottom = lwb_chtcontrol.scaletobottom
			case else
				pf_u_olecustomcontrol lolecc_control
				lolecc_control = awo_control
				lb_fixedtoright = lolecc_control.fixedtoright
				lb_fixedtobottom = lolecc_control.fixedtobottom
				lb_scaletoright = lolecc_control.scaletoright
				lb_scaletobottom = lolecc_control.scaletobottom
		end choose
	case olecontrol!
		pf_u_olecontrol lole_control
		lole_control = awo_control
		lb_fixedtoright = lole_control.fixedtoright
		lb_fixedtobottom = lole_control.fixedtobottom
		lb_scaletoright = lole_control.scaletoright
		lb_scaletobottom = lole_control.scaletobottom
	case line!
		pf_u_line lln_control
		lln_control = awo_control
		lb_fixedtoright = lln_control.fixedtoright
		lb_fixedtobottom = lln_control.fixedtobottom
		lb_scaletoright = lln_control.scaletoright
		lb_scaletobottom = lln_control.scaletobottom
	case oval!
		pf_u_oval lo_control
		lo_control = awo_control
		lb_fixedtoright = lo_control.fixedtoright
		lb_fixedtobottom = lo_control.fixedtobottom
		lb_scaletoright = lo_control.scaletoright
		lb_scaletobottom = lo_control.scaletobottom
	case rectangle!
		pf_u_rectangle lr_control
		lr_control = awo_control
		lb_fixedtoright = lr_control.fixedtoright
		lb_fixedtobottom = lr_control.fixedtobottom
		lb_scaletoright = lr_control.scaletoright
		lb_scaletobottom = lr_control.scaletobottom
	case roundrectangle!
		pf_u_roundrectangle lrr_control
		lrr_control = awo_control
		lb_fixedtoright = lrr_control.fixedtoright
		lb_fixedtobottom = lrr_control.fixedtobottom
		lb_scaletoright = lrr_control.scaletoright
		lb_scaletobottom = lrr_control.scaletobottom
	case else
		return '!'
End Choose

if lb_fixedtoright = true and lb_fixedtobottom = false and lb_scaletoright = false and lb_scaletobottom = false then
	ls_method = "FixedToRight"
elseif lb_fixedtoright = false and lb_fixedtobottom = true and lb_scaletoright = false and lb_scaletobottom = false then
	ls_method = "FixedToBottom"
elseif lb_fixedtoright = true and lb_fixedtobottom = true and lb_scaletoright = false and lb_scaletobottom = false then
	ls_method = "FixedToRight&Bottom"
elseif lb_fixedtoright = false and lb_fixedtobottom = false and lb_scaletoright = true and lb_scaletobottom = false then
	ls_method = "ScaleToRight"
elseif lb_fixedtoright = false and lb_fixedtobottom = false and lb_scaletoright = false and lb_scaletobottom = true then
	ls_method = "ScaleToBottom"
elseif lb_fixedtoright = false and lb_fixedtobottom = false and lb_scaletoright = true and lb_scaletobottom = true then
	ls_method = "ScaleToRight&Bottom"
elseif lb_fixedtoright = true and lb_fixedtobottom = false and lb_scaletoright = false and lb_scaletobottom = true then
	ls_method = "FixedToRight&ScaleToBottom"
elseif lb_fixedtoright = false and lb_fixedtobottom = true and lb_scaletoright = true and lb_scaletobottom = false then
	ls_method = "FixedToBottom&ScaleToRight"
elseif lb_fixedtoright = true and lb_fixedtobottom = true and lb_scaletoright = true and lb_scaletobottom = true then
	ls_method = "Scale"
end if

return ls_method

end function

public function integer of_autoresizeregister (readonly graphicobject ago_parent);integer	i
long		ll_k, ll_dwheightminus1value
string	ls_classname, ls_method

windowobject	lwo_control[]

window		lw_parent
datawindow	ldw_dw
userobject	luo_parent
object		lo_objtype
tab			ltab_temp, lt_control

choose case ago_parent.typeof()
	case window!
		lw_parent = ago_parent
		lwo_control = lw_parent.control
	case userobject!
		luo_parent = ago_parent
		lwo_control = luo_parent.control
	case else
		return -1
end choose

// 리사이즈 옵션 있는 오브젝트 자동 등록
for i = 1 to upperbound(lwo_control)
	ls_classname = lwo_control[i].classname()
	lo_objtype = lwo_control[i].typeof()
	choose case ls_classname
		case 'mdi_1'
			continue
	end choose
	
	// TAB 컨트롤은 파워빌더 특성 상 상속이 불가능 하기 때문에 
	// pf_u_tab 사용자 오브젝트에서 리사이즈 속성을 설정 합니다
	// Tabpage Resize
	if lo_objtype = tab! then
		ltab_temp = lwo_control[i]
		if pos(ltab_temp.dynamic classname(), 'tab_subpage') = 0 then
			for ll_k = 1 to upperbound(ltab_temp.control)
				this.of_autoresizeregister(ltab_temp.control[ll_k])
			next
		end if
		continue
	end if
	
	if lwo_control[i].triggerevent("oue_components") <> 1 then
		continue
	end if
	
	//dw title, sub button height resize.
	choose case lwo_control[i].TypeOf()
		case datawindow!
			ldw_dw = lwo_control[i]
			ll_dwheightminus1value = ldw_dw.dynamic of_dwheightminus1value()
			if ll_dwheightminus1value > 0 then
				ldw_dw.y += ll_dwheightminus1value
				ldw_dw.height -= ll_dwheightminus1value
			end if
		case statictext!
			if lwo_control[i].TriggerEvent('oue_components') = 1 then
				choose case lwo_control[i].dynamic of_thisname()
					case 'pf_u_splitbar_horizontal', 'pf_u_splitbar_vertical'
						lwo_control[i].PostEvent( 'oue_split4resize' )
				end choose
			end if
	end choose

	ls_method = this.of_getresizemethod(lwo_control[i])
	if isnull(ls_method) or len(ls_method) = 0 then continue

	// 탭 디자인용 유저 오브젝트인 경우 참조되는 탭을 리사이즈 합니다
	if lwo_control[i].dynamic of_thisname() = 'pf_u_tab' then
		lt_control = lwo_control[i].dynamic of_getreferencedtab()
		if isvalid(lt_control) then this.of_register(lt_control, ls_method)
	else
		this.of_register(lwo_control[i], ls_method)
	end if
next
end function

public subroutine of_setsplit4position ();dragobject		ldrg_cntrl
oval			loval_cntrl
line				lln_cntrl
rectangle		lrec_cntrl
roundrectangle	lrrec_cntrl

//Local variables
integer			li_upperbound
integer			li_cnt
integer			li_x, li_y, li_width, li_height
integer			li_deltawidth, li_deltaheight
real				lr_ratiowidth, lr_ratioheight
real				lr_move_deltax, lr_move_deltay
real				lr_resize_deltawidth, lr_resize_deltaheight

//Loop trough all controls
li_upperbound = UpperBound (inv_registered[])
For li_cnt = 1 to li_upperbound	
	//Initialize variables
	li_x = 0
	li_y = 0 
	li_width = 0
	li_height = 0
	lr_move_deltax = 0	
	lr_move_deltay = 0
	lr_resize_deltawidth = 0	
	lr_resize_deltaheight = 0	
	SetNull(ldrg_cntrl)
	SetNull(loval_cntrl)
	SetNull(lln_cntrl)
	SetNull(lrec_cntrl)
	SetNull(lrrec_cntrl)
	
	If IsValid(inv_registered[li_cnt].wo_control) Then		
		//Get attribute information from the appropriate control
		Choose Case inv_registered[li_cnt].s_typeof
			Case DRAGOBJECT
				ldrg_cntrl = inv_registered[li_cnt].wo_control
				li_x = ldrg_cntrl.X
				li_y = ldrg_cntrl.Y
				li_width = ldrg_cntrl.Width
				li_height = ldrg_cntrl.Height		
				
				inv_registered[li_cnt].r_x = li_x
				inv_registered[li_cnt].r_y = li_y
				inv_registered[li_cnt].r_width = li_width
				inv_registered[li_cnt].r_height = li_height
			Case Else
				Continue
		End Choose
	End If
Next /* For li_cnt = 1 to li_upperbound */
end subroutine

on pf_n_resize.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_resize.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  pfc_n_cst_resize
//
//	Description:
//	Resize service.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version - Claudio J. Quant
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////
end event

