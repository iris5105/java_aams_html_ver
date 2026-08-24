forward
global type eon_appeon_resize from nonvisualobject
end type
end forward

global type eon_appeon_resize from nonvisualobject
end type
global eon_appeon_resize eon_appeon_resize

type variables
Public:
boolean  ib_init
boolean ib_zoom = false
boolean ib_fontresize = false
boolean ib_stopall = false
int  ii_borderwidth,ii_borderheight
int ii_fonttype = 1// 1,use height;2,use width;3, Use the min; 4, Use the max
int  ii_type = 1  //1, Use the rate of height to zoom datawindow; 2, Use the rate of width to zoom datawindow; 3, Use the min; 4, Use the max
decimal{3} idec_maxrate
checkbox     icbx_obj
radiobutton    irb_obj
commandbutton icb_obj
picturebutton ipb_obj
datepicker  idp_obj
monthcalendar imc_obj
treeview  itv_obj
dropdownpicturelistbox  iddplb_obj
listbox  ilb_obj
picturelistbox iplb_obj
listview ilv_obj
dropdownlistbox iddlb_obj
groupbox igb_obj
editmask iem_obj
multilineedit imle_obj
singlelineedit isle_obj
statichyperlink ishl_obj
statictext ist_obj
datawindow  idw_obj
line         iln_obj
oval        iov_obj
rectangle   irec_obj
roundrectangle  irrec_obj
userobject   iuo_obj
tab         it_obj
mdiclient              imdi_obj

Protected:
constant string  DRAGOBJECT = 'dragobject!'
constant string  LINE = 'line!'
constant string  OVAL = 'oval!'
constant string  RECTANGLE = 'rectangle!'
constant string  ROUNDRECTANGLE = 'roundrectangle!'
constant string  MDICLIENT = 'mdiclient!'



end variables

forward prototypes
public function string of_typeof (windowobject awo_control)
public function string of_gettag (windowobject awo)
public subroutine of_init (userobject au_uo, integer ai_width, integer ai_height, boolean ab_recursion)
public subroutine of_init (window aw_window, boolean ab_recursion)
public subroutine of_init_object (windowobject awo, integer ai_parentwidth, integer ai_parentheight, boolean ab_recursion)
public function boolean of_resizable (windowobject awo)
public subroutine of_stringtoarray (string as_input, ref string as_array[], string as_flag)
public subroutine of_stop (windowobject awo)
public subroutine of_start (windowobject awo)
public function boolean of_registered (windowobject awo)
public subroutine of_fontresize (boolean ab_resize, integer ai_type)
public subroutine of_zoom (boolean ab_zoom, integer ai_type)
public subroutine of_resize (userobject au_uo, integer ai_newwidth, integer ai_newheight, boolean ab_recursion)
public subroutine of_resize (window aw_window, integer ai_newwidth, integer ai_newheight, boolean ab_recursion)
public subroutine of_init (userobject au_uo, boolean ab_recursion)
public subroutine of_resize (datawindow adw, integer ai_newwidth, integer ai_newheight, decimal ad_maxrate)
public subroutine of_resize (datawindow adw, integer ai_newwidth, integer ai_newheight, boolean ab_zoom, integer ai_type, decimal ad_maxrate)
public subroutine of_getscale (string as_input, ref string as_flag, ref string as_xscale, ref string as_yscale, ref string as_wscale, ref string as_hscale)
public subroutine of_getscale (string as_input, ref string as_flag, ref string as_xscale, ref string as_yscale, ref string as_wscale, ref string as_hscale, ref string as_width, ref string as_height)
public subroutine of_getscale (string as_input, ref string as_flag, ref string as_xscale, ref string as_yscale, ref string as_wscale, ref string as_hscale, ref string as_width, ref string as_height, ref string as_fontsize)
public subroutine of_init_object (windowobject awo, decimal ad_xscale, decimal ad_yscale, decimal ad_wscale, decimal ad_hscale)
public subroutine of_pause ()
public subroutine of_recover ()
public subroutine of_zoom (boolean ab_zoom, integer ai_type, decimal adec_rate)
public function long of_orginterval_x (windowobject awo)
public function long of_orginterval_y (windowobject awo)
public function long of_orginterval_w (windowobject awo)
public function long of_orginterval_h (windowobject awo)
public subroutine of_setflag (windowobject awo, string as_flag)
public subroutine of_internal_resize (ref dragobject awo, string as_flag, integer ai_newwidth, integer ai_newheight, string as_xbl, string as_ybl, string as_wbl, string as_hbl)
public subroutine of_init_object (windowobject awo, boolean ab_recursion)
end prototypes

public function string of_typeof (windowobject awo_control);//////////////////////////////////////////////////////////////////////////////
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
//10 Added new controls monthcalendar!
//11 Added new datatype windowobject!,new controls  datepicker!
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//Check parameters
//If IsNull(awo_control) or (not IsValid(awo_control)) Then
//	messagebox('','1')
//	Return '!'
//End If

//Validate and set typeof value
Choose Case awo_control.TypeOf()
	Case  checkbox!, commandbutton!, datawindow!, dropdownlistbox!, dropdownpicturelistbox!, &
			editmask!, graph!, groupbox!, hprogressbar!, hscrollbar!, htrackbar!, listbox!,  &
			listview!, multilineedit!, olecontrol!, olecustomcontrol!, omcontrol!, omcustomcontrol!,  &
			omembeddedcontrol!, picture!, picturebutton!, picturehyperlink!, picturelistbox!,  &
			radiobutton!, richtextedit!, singlelineedit!, statichyperlink!, statictext!,  &
			tab!, treeview!, userobject!, vprogressbar!, vscrollbar!, vtrackbar!, monthcalendar!, datepicker!, inkpicture!

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

public function string of_gettag (windowobject awo);string ls_tag
long ll_pos
ls_tag = awo.tag

ll_pos = pos(ls_tag,'/')

do while ll_pos > 0
	ls_tag = mid(ls_tag,ll_pos+1)
	ll_pos = pos(ls_tag,'/')
loop


return ls_tag
end function

public subroutine of_init (userobject au_uo, integer ai_width, integer ai_height, boolean ab_recursion);Integer li_controls,i
Long ll_width,ll_height
String ls_xscale,ls_yscale,ls_wscale,ls_hscale,ls_textsize,ls_width,ls_height,ls_parentw,ls_parenth,ls_x,ls_y
String ls_register,ls_resize,ls_flag
long ll_index
ls_register = '1'
ls_resize = '1'
ls_flag = '1111'
dragobject ldo_obj
windowobject lwo
userobject luo_tmp
datawindow ldw_obj
if isnull(ai_width) or isnull(ai_height) or ai_width = 0 or ai_height = 0 then return
ll_width=ai_width
ll_height=ai_height
ls_parentw=string(ai_width)
ls_parenth=string(ai_height)
ib_init = true
li_controls=upperbound(au_uo.control[])
FOR i=1 TO li_controls
	lwo = au_uo.control[i]
	if of_registered(lwo) then continue
	CHOOSE CASE of_typeof(au_uo.control[i])
		CASE DRAGOBJECT
			ldo_obj=au_uo.control[i]
			ls_width = string(ldo_obj.width)
			ls_height = string(ldo_obj.height)
			ls_x = string(ldo_obj.x)
			ls_y = string(ldo_obj.y)
			CHOOSE CASE au_uo.control[i].typeof()
				CASE tab!
					it_obj=ldo_obj
					ls_xscale=string(round(it_obj.x/ll_width,3))
					ls_yscale=string(round(it_obj.y/ll_height,3))
					ls_wscale=string(round(it_obj.width/ll_width,3))
					ls_hscale=string(round(it_obj.height/ll_height,3))
					ls_textsize = string(it_obj.textsize)
					it_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+it_obj.tag
					if ab_recursion then
						for ll_index = 1 to upperbound(it_obj.control)
							luo_tmp = it_obj.control[ll_index]
							of_init(luo_tmp,it_obj.width,it_obj.height,true)
						next
					end if
				CASE userobject!
					iuo_obj=ldo_obj
					ls_xscale=string(round(iuo_obj.x/ll_width,3))
					ls_yscale=string(round(iuo_obj.y/ll_height,3))
					ls_wscale=string(round(iuo_obj.width/ll_width,3))
					ls_hscale=string(round(iuo_obj.height/ll_height,3))
					iuo_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+iuo_obj.tag
					luo_tmp =  iuo_obj
					if ab_recursion then
						of_init(luo_tmp,luo_tmp.width,luo_tmp.height,true)
					end if
				CASE 	datawindow!
					ldw_obj =ldo_obj
					ls_xscale=string(round(ldw_obj.x/ll_width,3))
					ls_yscale=string(round(ldw_obj.y/ll_height,3))
					ls_wscale=string(round(ldw_obj.width/ll_width,3))
					ls_hscale=string(round(ldw_obj.height/ll_height,3))
					ldw_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+string(ldw_obj.width)+'/'+string(ldw_obj.height)+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ldw_obj.tag
				CASE checkbox!
					icbx_obj = ldo_obj
					ls_xscale=string(round(icbx_obj.x/ll_width,3))
					ls_yscale=string(round(icbx_obj.y/ll_height,3))
					ls_wscale=string(round(icbx_obj.width/ll_width,3))
					ls_hscale=string(round(icbx_obj.height/ll_height,3))
					ls_width = string(icbx_obj.width)
					ls_height = string(icbx_obj.height)
					ls_textsize = string(icbx_obj.textsize)
					icbx_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+icbx_obj.tag
				CASE radiobutton!
					irb_obj = ldo_obj
					ls_xscale=string(round(irb_obj.x/ll_width,3))
					ls_yscale=string(round(irb_obj.y/ll_height,3))
					ls_wscale=string(round(irb_obj.width/ll_width,3))
					ls_hscale=string(round(irb_obj.height/ll_height,3))
					ls_width = string(irb_obj.width)
					ls_height = string(irb_obj.height)
					ls_textsize = string(irb_obj.textsize)
					irb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irb_obj.tag
				CASE commandbutton!
					icb_obj = ldo_obj
					ls_xscale=string(round(icb_obj.x/ll_width,3))
					ls_yscale=string(round(icb_obj.y/ll_height,3))
					ls_wscale=string(round(icb_obj.width/ll_width,3))
					ls_hscale=string(round(icb_obj.height/ll_height,3))
					ls_width = string(icb_obj.width)
					ls_height = string(icb_obj.height)
					ls_textsize = string(icb_obj.textsize)
					icb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+icb_obj.tag
				CASE picturebutton!
					ipb_obj = ldo_obj
					ls_xscale=string(round(ipb_obj.x/ll_width,3))
					ls_yscale=string(round(ipb_obj.y/ll_height,3))
					ls_wscale=string(round(ipb_obj.width/ll_width,3))
					ls_hscale=string(round(ipb_obj.height/ll_height,3))
					ls_width = string(ipb_obj.width)
					ls_height = string(ipb_obj.height)
					ls_textsize = string(ipb_obj.textsize)
					ipb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ipb_obj.tag
				CASE datepicker!
					idp_obj = ldo_obj
					ls_xscale=string(round(idp_obj.x/ll_width,3))
					ls_yscale=string(round(idp_obj.y/ll_height,3))
					ls_wscale=string(round(idp_obj.width/ll_width,3))
					ls_hscale=string(round(idp_obj.height/ll_height,3))
					ls_width = string(idp_obj.width)
					ls_height = string(idp_obj.height)
					ls_textsize = string(idp_obj.textsize)
					idp_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+idp_obj.tag
				CASE monthcalendar!
					imc_obj = ldo_obj
					ls_xscale=string(round(imc_obj.x/ll_width,3))
					ls_yscale=string(round(imc_obj.y/ll_height,3))
					ls_wscale=string(round(imc_obj.width/ll_width,3))
					ls_hscale=string(round(imc_obj.height/ll_height,3))
					ls_width = string(imc_obj.width)
					ls_height = string(imc_obj.height)
					ls_textsize = string(imc_obj.textsize)
					imc_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imc_obj.tag
				CASE treeview!
					itv_obj = ldo_obj
					ls_xscale=string(round(itv_obj.x/ll_width,3))
					ls_yscale=string(round(itv_obj.y/ll_height,3))
					ls_wscale=string(round(itv_obj.width/ll_width,3))
					ls_hscale=string(round(itv_obj.height/ll_height,3))
					ls_width = string(itv_obj.width)
					ls_height = string(itv_obj.height)
					ls_textsize = string(itv_obj.textsize)
					itv_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+itv_obj.tag
				CASE dropdownpicturelistbox!
					iddplb_obj = ldo_obj
					ls_xscale=string(round(iddplb_obj.x/ll_width,3))
					ls_yscale=string(round(iddplb_obj.y/ll_height,3))
					ls_wscale=string(round(iddplb_obj.width/ll_width,3))
					ls_hscale=string(round(iddplb_obj.height/ll_height,3))
					ls_width = string(iddplb_obj.width)
					ls_height = string(iddplb_obj.height)
					ls_textsize = string(iddplb_obj.textsize)
					iddplb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iddplb_obj.tag
				CASE picturelistbox!
					iplb_obj = ldo_obj
					ls_xscale=string(round(iplb_obj.x/ll_width,3))
					ls_yscale=string(round(iplb_obj.y/ll_height,3))
					ls_wscale=string(round(iplb_obj.width/ll_width,3))
					ls_hscale=string(round(iplb_obj.height/ll_height,3))
					ls_width = string(iplb_obj.width)
					ls_height = string(iplb_obj.height)
					ls_textsize = string(iplb_obj.textsize)
					iplb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iplb_obj.tag
				CASE listview!
					ilv_obj = ldo_obj
					ls_xscale=string(round(ilv_obj.x/ll_width,3))
					ls_yscale=string(round(ilv_obj.y/ll_height,3))
					ls_wscale=string(round(ilv_obj.width/ll_width,3))
					ls_hscale=string(round(ilv_obj.height/ll_height,3))
					ls_width = string(ilv_obj.width)
					ls_height = string(ilv_obj.height)
					ls_textsize = string(ilv_obj.textsize)
					ilv_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ilv_obj.tag
				CASE dropdownlistbox!
					iddlb_obj = ldo_obj
					ls_xscale=string(round(iddlb_obj.x/ll_width,3))
					ls_yscale=string(round(iddlb_obj.y/ll_height,3))
					ls_wscale=string(round(iddlb_obj.width/ll_width,3))
					ls_hscale=string(round(iddlb_obj.height/ll_height,3))
					ls_width = string(iddlb_obj.width)
					ls_height = string(iddlb_obj.height)
					ls_textsize = string(iddlb_obj.textsize)
					iddlb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iddlb_obj.tag
				CASE listbox!
					ilb_obj = ldo_obj
					ls_xscale=string(round(ilb_obj.x/ll_width,3))
					ls_yscale=string(round(ilb_obj.y/ll_height,3))
					ls_wscale=string(round(ilb_obj.width/ll_width,3))
					ls_hscale=string(round(ilb_obj.height/ll_height,3))
					ls_width = string(ilb_obj.width)
					ls_height = string(ilb_obj.height)
					ls_textsize = string(ilb_obj.textsize)
					ilb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ilb_obj.tag
				CASE groupbox!
					igb_obj = ldo_obj
					ls_xscale=string(round(igb_obj.x/ll_width,3))
					ls_yscale=string(round(igb_obj.y/ll_height,3))
					ls_wscale=string(round(igb_obj.width/ll_width,3))
					ls_hscale=string(round(igb_obj.height/ll_height,3))
					ls_width = string(igb_obj.width)
					ls_height = string(igb_obj.height)
					ls_textsize = string(igb_obj.textsize)
					igb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+igb_obj.tag
				CASE editmask!
					iem_obj = ldo_obj
					ls_xscale=string(round(iem_obj.x/ll_width,3))
					ls_yscale=string(round(iem_obj.y/ll_height,3))
					ls_wscale=string(round(iem_obj.width/ll_width,3))
					ls_hscale=string(round(iem_obj.height/ll_height,3))
					ls_width = string(iem_obj.width)
					ls_height = string(iem_obj.height)
					ls_textsize = string(iem_obj.textsize)
					iem_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iem_obj.tag
				CASE multilineedit!
					imle_obj = ldo_obj
					ls_xscale=string(round(imle_obj.x/ll_width,3))
					ls_yscale=string(round(imle_obj.y/ll_height,3))
					ls_wscale=string(round(imle_obj.width/ll_width,3))
					ls_hscale=string(round(imle_obj.height/ll_height,3))
					ls_width = string(imle_obj.width)
					ls_height = string(imle_obj.height)
					ls_textsize = string(imle_obj.textsize)
					imle_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imle_obj.tag
				CASE singlelineedit!
					isle_obj = ldo_obj
					ls_xscale=string(round(isle_obj.x/ll_width,3))
					ls_yscale=string(round(isle_obj.y/ll_height,3))
					ls_wscale=string(round(isle_obj.width/ll_width,3))
					ls_hscale=string(round(isle_obj.height/ll_height,3))
					ls_width = string(isle_obj.width)
					ls_height = string(isle_obj.height)
					ls_textsize = string(isle_obj.textsize)
					isle_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+isle_obj.tag
				CASE statichyperlink!
					ishl_obj = ldo_obj
					ls_xscale=string(round(ishl_obj.x/ll_width,3))
					ls_yscale=string(round(ishl_obj.y/ll_height,3))
					ls_wscale=string(round(ishl_obj.width/ll_width,3))
					ls_hscale=string(round(ishl_obj.height/ll_height,3))
					ls_width = string(ishl_obj.width)
					ls_height = string(ishl_obj.height)
					ls_textsize = string(ishl_obj.textsize)
					ishl_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ishl_obj.tag
				CASE statictext!
					ist_obj = ldo_obj
					ls_xscale=string(round(ist_obj.x/ll_width,3))
					ls_yscale=string(round(ist_obj.y/ll_height,3))
					ls_wscale=string(round(ist_obj.width/ll_width,3))
					ls_hscale=string(round(ist_obj.height/ll_height,3))
					ls_width = string(ist_obj.width)
					ls_height = string(ist_obj.height)
					ls_textsize = string(ist_obj.textsize)
					ist_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ist_obj.tag
				CASE ELSE
					ls_xscale=string(round(ldo_obj.x/ll_width,3))
					ls_yscale=string(round(ldo_obj.y/ll_height,3))
					ls_wscale=string(round(ldo_obj.width/ll_width,3))
					ls_hscale=string(round(ldo_obj.height/ll_height,3))
					ldo_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ldo_obj.tag
			END CHOOSE
		CASE LINE
			iln_obj=au_uo.control[i]
			ls_xscale=string(round(iln_obj.beginx/ll_width,3))
			ls_yscale=string(round(iln_obj.beginy/ll_height,3))
			ls_wscale=string(round(iln_obj.endx/ll_width,3))
			ls_hscale=string(round(iln_obj.endy/ll_height,3))
			ls_x = string(iln_obj.beginx)
			ls_y = string(iln_obj.beginy)
			ls_width = string(iln_obj.endx)
			ls_height = string(iln_obj.endy)
			iln_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iln_obj.tag
		CASE OVAL
			iov_obj = au_uo.control[i]
			ls_xscale=string(round(iov_obj.x/ll_width,3))
			ls_yscale=string(round(iov_obj.y/ll_height,3))
			ls_wscale=string(round(iov_obj.width/ll_width,3))
			ls_hscale=string(round(iov_obj.height/ll_height,3))
			ls_x = string(iov_obj.x)
			ls_y = string(iov_obj.y)
			ls_width = string(iov_obj.width)
			ls_height = string(iov_obj.height)
			iov_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iov_obj.tag
		CASE RECTANGLE
			irec_obj = au_uo.control[i]
			ls_xscale=string(round(irec_obj.x/ll_width,3))
			ls_yscale=string(round(irec_obj.y/ll_height,3))
			ls_wscale=string(round(irec_obj.width/ll_width,3))
			ls_hscale=string(round(irec_obj.height/ll_height,3))
			ls_x = string(irec_obj.x)
			ls_y = string(irec_obj.y)
			ls_width = string(irec_obj.width)
			ls_height = string(irec_obj.height)
			irec_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irec_obj.tag
		CASE ROUNDRECTANGLE
			irrec_obj = au_uo.control[i]
			ls_xscale=string(round(irrec_obj.x/ll_width,3))
			ls_yscale=string(round(irrec_obj.y/ll_height,3))
			ls_wscale=string(round(irrec_obj.width/ll_width,3))
			ls_hscale=string(round(irrec_obj.height/ll_height,3))
			ls_x = string(irrec_obj.x)
			ls_y = string(irrec_obj.y)
			ls_width = string(irrec_obj.width)
			ls_height = string(irrec_obj.height)
			irrec_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irrec_obj.tag
		CASE MDICLIENT
			imdi_obj = au_uo.control[i]
			ls_xscale=string(round(imdi_obj.x/ll_width,3))
			ls_yscale=string(round(imdi_obj.y/ll_height,3))
			ls_wscale=string(round(imdi_obj.width/ll_width,3))
			ls_hscale=string(round(imdi_obj.height/ll_height,3))
			ls_x = string(imdi_obj.x)
			ls_y = string(imdi_obj.y)
			ls_width = string(imdi_obj.width)
			ls_height = string(imdi_obj.height)
			imdi_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imdi_obj.tag
	END CHOOSE
NEXT

end subroutine

public subroutine of_init (window aw_window, boolean ab_recursion);//
Integer li_controls,i
Long ll_width,ll_height
String ls_xscale,ls_yscale,ls_wscale,ls_hscale,ls_textsize,ls_width,ls_height
string ls_register,ls_resize,ls_flag
string ls_x,ls_y,ls_parentw,ls_parenth
ls_register = '1'
ls_resize = '1'
ls_flag = "1111"
long ll_index
windowobject lwo
dragobject ldo_obj
userobject luo_tmp
datawindow  ldw_obj
//ll_width=aw_window.width 
//ll_height=aw_window.height
ii_borderwidth = aw_window.width - aw_window.workspacewidth()
ii_borderheight = aw_window.height - aw_window.workspaceheight()
ll_width=aw_window.workspacewidth()
ll_height=aw_window.workspaceheight()
ls_parentw = string(ll_width)
ls_parenth = string(ll_height)
ib_init = true
li_controls=upperbound(aw_window.control[])

FOR i=1 TO li_controls
	lwo = aw_window.control[i]
	if of_registered(lwo) then continue
	CHOOSE CASE of_typeof(aw_window.control[i])
		CASE DRAGOBJECT
			ldo_obj=aw_window.control[i]
			ls_width = string(ldo_obj.width)
			ls_height = string(ldo_obj.height)
			ls_x = string(ldo_obj.x)
			ls_y = string(ldo_obj.y)
			CHOOSE CASE aw_window.control[i].typeof()
				CASE tab!
					it_obj=ldo_obj
					ls_xscale=string(round(it_obj.x/ll_width,3))
					ls_yscale=string(round(it_obj.y/ll_height,3))
					ls_wscale=string(round(it_obj.width/ll_width,3))
					ls_hscale=string(round(it_obj.height/ll_height,3))
					ls_textsize = string(it_obj.textsize)
					it_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+it_obj.tag
					if ab_recursion then
						for ll_index = 1 to upperbound(it_obj.control)
							luo_tmp = it_obj.control[ll_index]
							of_init(luo_tmp,it_obj.width,it_obj.height,true)
						next
					end if
				CASE userobject!
					iuo_obj=ldo_obj
					ls_xscale=string(round(iuo_obj.x/ll_width,3))
					ls_yscale=string(round(iuo_obj.y/ll_height,3))
					ls_wscale=string(round(iuo_obj.width/ll_width,3))
					ls_hscale=string(round(iuo_obj.height/ll_height,3))
					iuo_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+iuo_obj.tag
					luo_tmp =  iuo_obj
					if ab_recursion then
						of_init(luo_tmp,luo_tmp.width,luo_tmp.height,true)
					end if
				CASE 	datawindow!
					ldw_obj =ldo_obj
					ls_xscale=string(round(ldw_obj.x/ll_width,3))
					ls_yscale=string(round(ldw_obj.y/ll_height,3))
					ls_wscale=string(round(ldw_obj.width/ll_width,3))
					ls_hscale=string(round(ldw_obj.height/ll_height,3))
					ldw_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+string(ldw_obj.width)+'/'+string(ldw_obj.height)+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ldw_obj.tag
				CASE checkbox!
					icbx_obj = ldo_obj
					ls_xscale=string(round(icbx_obj.x/ll_width,3))
					ls_yscale=string(round(icbx_obj.y/ll_height,3))
					ls_wscale=string(round(icbx_obj.width/ll_width,3))
					ls_hscale=string(round(icbx_obj.height/ll_height,3))
					ls_width = string(icbx_obj.width)
					ls_height = string(icbx_obj.height)
					ls_textsize = string(icbx_obj.textsize)
					icbx_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+icbx_obj.tag
				CASE radiobutton!
					irb_obj = ldo_obj
					ls_xscale=string(round(irb_obj.x/ll_width,3))
					ls_yscale=string(round(irb_obj.y/ll_height,3))
					ls_wscale=string(round(irb_obj.width/ll_width,3))
					ls_hscale=string(round(irb_obj.height/ll_height,3))
					ls_width = string(irb_obj.width)
					ls_height = string(irb_obj.height)
					ls_textsize = string(irb_obj.textsize)
					irb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irb_obj.tag
				CASE commandbutton!
					icb_obj = ldo_obj
					ls_xscale=string(round(icb_obj.x/ll_width,3))
					ls_yscale=string(round(icb_obj.y/ll_height,3))
					ls_wscale=string(round(icb_obj.width/ll_width,3))
					ls_hscale=string(round(icb_obj.height/ll_height,3))
					ls_width = string(icb_obj.width)
					ls_height = string(icb_obj.height)
					ls_textsize = string(icb_obj.textsize)
					icb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+icb_obj.tag
				CASE picturebutton!
					ipb_obj = ldo_obj
					ls_xscale=string(round(ipb_obj.x/ll_width,3))
					ls_yscale=string(round(ipb_obj.y/ll_height,3))
					ls_wscale=string(round(ipb_obj.width/ll_width,3))
					ls_hscale=string(round(ipb_obj.height/ll_height,3))
					ls_width = string(ipb_obj.width)
					ls_height = string(ipb_obj.height)
					ls_textsize = string(ipb_obj.textsize)
					ipb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ipb_obj.tag
				CASE datepicker!
					idp_obj = ldo_obj
					ls_xscale=string(round(idp_obj.x/ll_width,3))
					ls_yscale=string(round(idp_obj.y/ll_height,3))
					ls_wscale=string(round(idp_obj.width/ll_width,3))
					ls_hscale=string(round(idp_obj.height/ll_height,3))
					ls_width = string(idp_obj.width)
					ls_height = string(idp_obj.height)
					ls_textsize = string(idp_obj.textsize)
					idp_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+idp_obj.tag
				CASE monthcalendar!
					imc_obj = ldo_obj
					ls_xscale=string(round(imc_obj.x/ll_width,3))
					ls_yscale=string(round(imc_obj.y/ll_height,3))
					ls_wscale=string(round(imc_obj.width/ll_width,3))
					ls_hscale=string(round(imc_obj.height/ll_height,3))
					ls_width = string(imc_obj.width)
					ls_height = string(imc_obj.height)
					ls_textsize = string(imc_obj.textsize)
					imc_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imc_obj.tag
				CASE treeview!
					itv_obj = ldo_obj
					ls_xscale=string(round(itv_obj.x/ll_width,3))
					ls_yscale=string(round(itv_obj.y/ll_height,3))
					ls_wscale=string(round(itv_obj.width/ll_width,3))
					ls_hscale=string(round(itv_obj.height/ll_height,3))
					ls_width = string(itv_obj.width)
					ls_height = string(itv_obj.height)
					ls_textsize = string(itv_obj.textsize)
					itv_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+itv_obj.tag
				CASE dropdownpicturelistbox!
					iddplb_obj = ldo_obj
					ls_xscale=string(round(iddplb_obj.x/ll_width,3))
					ls_yscale=string(round(iddplb_obj.y/ll_height,3))
					ls_wscale=string(round(iddplb_obj.width/ll_width,3))
					ls_hscale=string(round(iddplb_obj.height/ll_height,3))
					ls_width = string(iddplb_obj.width)
					ls_height = string(iddplb_obj.height)
					ls_textsize = string(iddplb_obj.textsize)
					iddplb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iddplb_obj.tag
				CASE picturelistbox!
					iplb_obj = ldo_obj
					ls_xscale=string(round(iplb_obj.x/ll_width,3))
					ls_yscale=string(round(iplb_obj.y/ll_height,3))
					ls_wscale=string(round(iplb_obj.width/ll_width,3))
					ls_hscale=string(round(iplb_obj.height/ll_height,3))
					ls_width = string(iplb_obj.width)
					ls_height = string(iplb_obj.height)
					ls_textsize = string(iplb_obj.textsize)
					iplb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iplb_obj.tag
				CASE listview!
					ilv_obj = ldo_obj
					ls_xscale=string(round(ilv_obj.x/ll_width,3))
					ls_yscale=string(round(ilv_obj.y/ll_height,3))
					ls_wscale=string(round(ilv_obj.width/ll_width,3))
					ls_hscale=string(round(ilv_obj.height/ll_height,3))
					ls_width = string(ilv_obj.width)
					ls_height = string(ilv_obj.height)
					ls_textsize = string(ilv_obj.textsize)
					ilv_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ilv_obj.tag
				CASE dropdownlistbox!
					iddlb_obj = ldo_obj
					ls_xscale=string(round(iddlb_obj.x/ll_width,3))
					ls_yscale=string(round(iddlb_obj.y/ll_height,3))
					ls_wscale=string(round(iddlb_obj.width/ll_width,3))
					ls_hscale=string(round(iddlb_obj.height/ll_height,3))
					ls_width = string(iddlb_obj.width)
					ls_height = string(iddlb_obj.height)
					ls_textsize = string(iddlb_obj.textsize)
					iddlb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iddlb_obj.tag
				CASE listbox!
					ilb_obj = ldo_obj
					ls_xscale=string(round(ilb_obj.x/ll_width,3))
					ls_yscale=string(round(ilb_obj.y/ll_height,3))
					ls_wscale=string(round(ilb_obj.width/ll_width,3))
					ls_hscale=string(round(ilb_obj.height/ll_height,3))
					ls_width = string(ilb_obj.width)
					ls_height = string(ilb_obj.height)
					ls_textsize = string(ilb_obj.textsize)
					ilb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ilb_obj.tag
				CASE groupbox!
					igb_obj = ldo_obj
					ls_xscale=string(round(igb_obj.x/ll_width,3))
					ls_yscale=string(round(igb_obj.y/ll_height,3))
					ls_wscale=string(round(igb_obj.width/ll_width,3))
					ls_hscale=string(round(igb_obj.height/ll_height,3))
					ls_width = string(igb_obj.width)
					ls_height = string(igb_obj.height)
					ls_textsize = string(igb_obj.textsize)
					igb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+igb_obj.tag
				CASE editmask!
					iem_obj = ldo_obj
					ls_xscale=string(round(iem_obj.x/ll_width,3))
					ls_yscale=string(round(iem_obj.y/ll_height,3))
					ls_wscale=string(round(iem_obj.width/ll_width,3))
					ls_hscale=string(round(iem_obj.height/ll_height,3))
					ls_width = string(iem_obj.width)
					ls_height = string(iem_obj.height)
					ls_textsize = string(iem_obj.textsize)
					iem_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iem_obj.tag
				CASE multilineedit!
					imle_obj = ldo_obj
					ls_xscale=string(round(imle_obj.x/ll_width,3))
					ls_yscale=string(round(imle_obj.y/ll_height,3))
					ls_wscale=string(round(imle_obj.width/ll_width,3))
					ls_hscale=string(round(imle_obj.height/ll_height,3))
					ls_width = string(imle_obj.width)
					ls_height = string(imle_obj.height)
					ls_textsize = string(imle_obj.textsize)
					imle_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imle_obj.tag
				CASE singlelineedit!
					isle_obj = ldo_obj
					ls_xscale=string(round(isle_obj.x/ll_width,3))
					ls_yscale=string(round(isle_obj.y/ll_height,3))
					ls_wscale=string(round(isle_obj.width/ll_width,3))
					ls_hscale=string(round(isle_obj.height/ll_height,3))
					ls_width = string(isle_obj.width)
					ls_height = string(isle_obj.height)
					ls_textsize = string(isle_obj.textsize)
					isle_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+isle_obj.tag
				CASE statichyperlink!
					ishl_obj = ldo_obj
					ls_xscale=string(round(ishl_obj.x/ll_width,3))
					ls_yscale=string(round(ishl_obj.y/ll_height,3))
					ls_wscale=string(round(ishl_obj.width/ll_width,3))
					ls_hscale=string(round(ishl_obj.height/ll_height,3))
					ls_width = string(ishl_obj.width)
					ls_height = string(ishl_obj.height)
					ls_textsize = string(ishl_obj.textsize)
					ishl_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ishl_obj.tag
				CASE statictext!
					ist_obj = ldo_obj
					ls_xscale=string(round(ist_obj.x/ll_width,3))
					ls_yscale=string(round(ist_obj.y/ll_height,3))
					ls_wscale=string(round(ist_obj.width/ll_width,3))
					ls_hscale=string(round(ist_obj.height/ll_height,3))
					ls_width = string(ist_obj.width)
					ls_height = string(ist_obj.height)
					ls_textsize = string(ist_obj.textsize)
					ist_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ist_obj.tag
				CASE ELSE
					ls_xscale=string(round(ldo_obj.x/ll_width,3))
					ls_yscale=string(round(ldo_obj.y/ll_height,3))
					ls_wscale=string(round(ldo_obj.width/ll_width,3))
					ls_hscale=string(round(ldo_obj.height/ll_height,3))
					ldo_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ldo_obj.tag
			END CHOOSE
		CASE LINE
			iln_obj=aw_window.control[i]
			ls_xscale=string(round(iln_obj.beginx/ll_width,3))
			ls_yscale=string(round(iln_obj.beginy/ll_height,3))
			ls_wscale=string(round(iln_obj.endx/ll_width,3))
			ls_hscale=string(round(iln_obj.endy/ll_height,3))
			ls_x = string(iln_obj.beginx)
			ls_y = string(iln_obj.beginy)
			ls_width = string(iln_obj.endx)
			ls_height = string(iln_obj.endy)
			iln_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iln_obj.tag
		CASE OVAL
			iov_obj = aw_window.control[i]
			ls_xscale=string(round(iov_obj.x/ll_width,3))
			ls_yscale=string(round(iov_obj.y/ll_height,3))
			ls_wscale=string(round(iov_obj.width/ll_width,3))
			ls_hscale=string(round(iov_obj.height/ll_height,3))
			ls_x = string(iov_obj.x)
			ls_y = string(iov_obj.y)
			ls_width = string(iov_obj.width)
			ls_height = string(iov_obj.height)
			iov_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iov_obj.tag
		CASE RECTANGLE
			irec_obj = aw_window.control[i]
			ls_xscale=string(round(irec_obj.x/ll_width,3))
			ls_yscale=string(round(irec_obj.y/ll_height,3))
			ls_wscale=string(round(irec_obj.width/ll_width,3))
			ls_hscale=string(round(irec_obj.height/ll_height,3))
			ls_x = string(irec_obj.x)
			ls_y = string(irec_obj.y)
			ls_width = string(irec_obj.width)
			ls_height = string(irec_obj.height)
			irec_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irec_obj.tag
		CASE ROUNDRECTANGLE
			irrec_obj = aw_window.control[i]
			ls_xscale=string(round(irrec_obj.x/ll_width,3))
			ls_yscale=string(round(irrec_obj.y/ll_height,3))
			ls_wscale=string(round(irrec_obj.width/ll_width,3))
			ls_hscale=string(round(irrec_obj.height/ll_height,3))
			ls_x = string(irrec_obj.x)
			ls_y = string(irrec_obj.y)
			ls_width = string(irrec_obj.width)
			ls_height = string(irrec_obj.height)
			irrec_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irrec_obj.tag
		CASE MDICLIENT
			imdi_obj = aw_window.control[i]
			ls_xscale=string(round(imdi_obj.x/ll_width,3))
			ls_yscale=string(round(imdi_obj.y/ll_height,3))
			ls_wscale=string(round(imdi_obj.width/ll_width,3))
			ls_hscale=string(round(imdi_obj.height/ll_height,3))
			ls_x = string(imdi_obj.x)
			ls_y = string(imdi_obj.y)
			ls_width = string(imdi_obj.width)
			ls_height = string(imdi_obj.height)
			imdi_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imdi_obj.tag
	END CHOOSE
NEXT



end subroutine

public subroutine of_init_object (windowobject awo, integer ai_parentwidth, integer ai_parentheight, boolean ab_recursion);
Long ll_width,ll_height
String ls_xscale,ls_yscale,ls_wscale,ls_hscale,ls_textsize,ls_width,ls_height
string ls_register,ls_resize,ls_flag,ls_array[]
string ls_x,ls_y,ls_parentw,ls_parenth
ls_register = '1'
ls_resize = '1'
ls_flag = '1111'
long ll_index
if isnull(ai_parentwidth) or isnull(ai_parentheight) or ai_parentwidth = 0 or ai_parentheight = 0 then return
dragobject ldo_obj
userobject luo_tmp
datawindow  ldw_obj
window  lw_1
ll_width=ai_parentwidth
ll_height=ai_parentheight
ib_init = true

if of_registered(awo) then
	of_stringtoarray(awo.tag,ls_array,'/')
	ls_resize = ls_array[2]
	ls_flag = ls_array[3]
	awo.tag = of_gettag(awo)
end if
	CHOOSE CASE of_typeof(awo)
		CASE DRAGOBJECT
			ldo_obj=awo
			ls_width = string(ldo_obj.width)
			ls_height = string(ldo_obj.height)
			ls_x = string(ldo_obj.x)
			ls_y = string(ldo_obj.y)
			CHOOSE CASE awo.typeof()
				CASE tab!
					it_obj=ldo_obj
					ls_xscale=string(round(it_obj.x/ll_width,3))
					ls_yscale=string(round(it_obj.y/ll_height,3))
					ls_wscale=string(round(it_obj.width/ll_width,3))
					ls_hscale=string(round(it_obj.height/ll_height,3))
					ls_textsize = string(it_obj.textsize)
					it_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+it_obj.tag
					if ab_recursion then
						for ll_index = 1 to upperbound(it_obj.control)
							luo_tmp = it_obj.control[ll_index]
							of_init(luo_tmp,it_obj.width,it_obj.height,true)
						next
					end if
				CASE userobject!
					iuo_obj=ldo_obj
					ls_xscale=string(round(iuo_obj.x/ll_width,3))
					ls_yscale=string(round(iuo_obj.y/ll_height,3))
					ls_wscale=string(round(iuo_obj.width/ll_width,3))
					ls_hscale=string(round(iuo_obj.height/ll_height,3))
					iuo_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+iuo_obj.tag
					luo_tmp =  iuo_obj
					if ab_recursion then
						of_init(luo_tmp,luo_tmp.width,luo_tmp.height,true)
					end if
				CASE 	datawindow!
					ldw_obj =ldo_obj
					ls_xscale=string(round(ldw_obj.x/ll_width,3))
					ls_yscale=string(round(ldw_obj.y/ll_height,3))
					ls_wscale=string(round(ldw_obj.width/ll_width,3))
					ls_hscale=string(round(ldw_obj.height/ll_height,3))
					ldw_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+string(ldw_obj.width)+'/'+string(ldw_obj.height)+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ldw_obj.tag
				CASE checkbox!
					icbx_obj = ldo_obj
					ls_xscale=string(round(icbx_obj.x/ll_width,3))
					ls_yscale=string(round(icbx_obj.y/ll_height,3))
					ls_wscale=string(round(icbx_obj.width/ll_width,3))
					ls_hscale=string(round(icbx_obj.height/ll_height,3))
					ls_width = string(icbx_obj.width)
					ls_height = string(icbx_obj.height)
					ls_textsize = string(icbx_obj.textsize)
					icbx_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+icbx_obj.tag
				CASE radiobutton!
					irb_obj = ldo_obj
					ls_xscale=string(round(irb_obj.x/ll_width,3))
					ls_yscale=string(round(irb_obj.y/ll_height,3))
					ls_wscale=string(round(irb_obj.width/ll_width,3))
					ls_hscale=string(round(irb_obj.height/ll_height,3))
					ls_width = string(irb_obj.width)
					ls_height = string(irb_obj.height)
					ls_textsize = string(irb_obj.textsize)
					irb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irb_obj.tag
				CASE commandbutton!
					icb_obj = ldo_obj
					ls_xscale=string(round(icb_obj.x/ll_width,3))
					ls_yscale=string(round(icb_obj.y/ll_height,3))
					ls_wscale=string(round(icb_obj.width/ll_width,3))
					ls_hscale=string(round(icb_obj.height/ll_height,3))
					ls_width = string(icb_obj.width)
					ls_height = string(icb_obj.height)
					ls_textsize = string(icb_obj.textsize)
					icb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+icb_obj.tag
				CASE picturebutton!
					ipb_obj = ldo_obj
					ls_xscale=string(round(ipb_obj.x/ll_width,3))
					ls_yscale=string(round(ipb_obj.y/ll_height,3))
					ls_wscale=string(round(ipb_obj.width/ll_width,3))
					ls_hscale=string(round(ipb_obj.height/ll_height,3))
					ls_width = string(ipb_obj.width)
					ls_height = string(ipb_obj.height)
					ls_textsize = string(ipb_obj.textsize)
					ipb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ipb_obj.tag
				CASE datepicker!
					idp_obj = ldo_obj
					ls_xscale=string(round(idp_obj.x/ll_width,3))
					ls_yscale=string(round(idp_obj.y/ll_height,3))
					ls_wscale=string(round(idp_obj.width/ll_width,3))
					ls_hscale=string(round(idp_obj.height/ll_height,3))
					ls_width = string(idp_obj.width)
					ls_height = string(idp_obj.height)
					ls_textsize = string(idp_obj.textsize)
					idp_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+idp_obj.tag
				CASE monthcalendar!
					imc_obj = ldo_obj
					ls_xscale=string(round(imc_obj.x/ll_width,3))
					ls_yscale=string(round(imc_obj.y/ll_height,3))
					ls_wscale=string(round(imc_obj.width/ll_width,3))
					ls_hscale=string(round(imc_obj.height/ll_height,3))
					ls_width = string(imc_obj.width)
					ls_height = string(imc_obj.height)
					ls_textsize = string(imc_obj.textsize)
					imc_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imc_obj.tag
				CASE treeview!
					itv_obj = ldo_obj
					ls_xscale=string(round(itv_obj.x/ll_width,3))
					ls_yscale=string(round(itv_obj.y/ll_height,3))
					ls_wscale=string(round(itv_obj.width/ll_width,3))
					ls_hscale=string(round(itv_obj.height/ll_height,3))
					ls_width = string(itv_obj.width)
					ls_height = string(itv_obj.height)
					ls_textsize = string(itv_obj.textsize)
					itv_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+itv_obj.tag
				CASE dropdownpicturelistbox!
					iddplb_obj = ldo_obj
					ls_xscale=string(round(iddplb_obj.x/ll_width,3))
					ls_yscale=string(round(iddplb_obj.y/ll_height,3))
					ls_wscale=string(round(iddplb_obj.width/ll_width,3))
					ls_hscale=string(round(iddplb_obj.height/ll_height,3))
					ls_width = string(iddplb_obj.width)
					ls_height = string(iddplb_obj.height)
					ls_textsize = string(iddplb_obj.textsize)
					iddplb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iddplb_obj.tag
				CASE picturelistbox!
					iplb_obj = ldo_obj
					ls_xscale=string(round(iplb_obj.x/ll_width,3))
					ls_yscale=string(round(iplb_obj.y/ll_height,3))
					ls_wscale=string(round(iplb_obj.width/ll_width,3))
					ls_hscale=string(round(iplb_obj.height/ll_height,3))
					ls_width = string(iplb_obj.width)
					ls_height = string(iplb_obj.height)
					ls_textsize = string(iplb_obj.textsize)
					iplb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iplb_obj.tag
				CASE listview!
					ilv_obj = ldo_obj
					ls_xscale=string(round(ilv_obj.x/ll_width,3))
					ls_yscale=string(round(ilv_obj.y/ll_height,3))
					ls_wscale=string(round(ilv_obj.width/ll_width,3))
					ls_hscale=string(round(ilv_obj.height/ll_height,3))
					ls_width = string(ilv_obj.width)
					ls_height = string(ilv_obj.height)
					ls_textsize = string(ilv_obj.textsize)
					ilv_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ilv_obj.tag
				CASE dropdownlistbox!
					iddlb_obj = ldo_obj
					ls_xscale=string(round(iddlb_obj.x/ll_width,3))
					ls_yscale=string(round(iddlb_obj.y/ll_height,3))
					ls_wscale=string(round(iddlb_obj.width/ll_width,3))
					ls_hscale=string(round(iddlb_obj.height/ll_height,3))
					ls_width = string(iddlb_obj.width)
					ls_height = string(iddlb_obj.height)
					ls_textsize = string(iddlb_obj.textsize)
					iddlb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iddlb_obj.tag
				CASE listbox!
					ilb_obj = ldo_obj
					ls_xscale=string(round(ilb_obj.x/ll_width,3))
					ls_yscale=string(round(ilb_obj.y/ll_height,3))
					ls_wscale=string(round(ilb_obj.width/ll_width,3))
					ls_hscale=string(round(ilb_obj.height/ll_height,3))
					ls_width = string(ilb_obj.width)
					ls_height = string(ilb_obj.height)
					ls_textsize = string(ilb_obj.textsize)
					ilb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ilb_obj.tag
				CASE groupbox!
					igb_obj = ldo_obj
					ls_xscale=string(round(igb_obj.x/ll_width,3))
					ls_yscale=string(round(igb_obj.y/ll_height,3))
					ls_wscale=string(round(igb_obj.width/ll_width,3))
					ls_hscale=string(round(igb_obj.height/ll_height,3))
					ls_width = string(igb_obj.width)
					ls_height = string(igb_obj.height)
					ls_textsize = string(igb_obj.textsize)
					igb_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+igb_obj.tag
				CASE editmask!
					iem_obj = ldo_obj
					ls_xscale=string(round(iem_obj.x/ll_width,3))
					ls_yscale=string(round(iem_obj.y/ll_height,3))
					ls_wscale=string(round(iem_obj.width/ll_width,3))
					ls_hscale=string(round(iem_obj.height/ll_height,3))
					ls_width = string(iem_obj.width)
					ls_height = string(iem_obj.height)
					ls_textsize = string(iem_obj.textsize)
					iem_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iem_obj.tag
				CASE multilineedit!
					imle_obj = ldo_obj
					ls_xscale=string(round(imle_obj.x/ll_width,3))
					ls_yscale=string(round(imle_obj.y/ll_height,3))
					ls_wscale=string(round(imle_obj.width/ll_width,3))
					ls_hscale=string(round(imle_obj.height/ll_height,3))
					ls_width = string(imle_obj.width)
					ls_height = string(imle_obj.height)
					ls_textsize = string(imle_obj.textsize)
					imle_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imle_obj.tag
				CASE singlelineedit!
					isle_obj = ldo_obj
					ls_xscale=string(round(isle_obj.x/ll_width,3))
					ls_yscale=string(round(isle_obj.y/ll_height,3))
					ls_wscale=string(round(isle_obj.width/ll_width,3))
					ls_hscale=string(round(isle_obj.height/ll_height,3))
					ls_width = string(isle_obj.width)
					ls_height = string(isle_obj.height)
					ls_textsize = string(isle_obj.textsize)
					isle_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+isle_obj.tag
				CASE statichyperlink!
					ishl_obj = ldo_obj
					ls_xscale=string(round(ishl_obj.x/ll_width,3))
					ls_yscale=string(round(ishl_obj.y/ll_height,3))
					ls_wscale=string(round(ishl_obj.width/ll_width,3))
					ls_hscale=string(round(ishl_obj.height/ll_height,3))
					ls_width = string(ishl_obj.width)
					ls_height = string(ishl_obj.height)
					ls_textsize = string(ishl_obj.textsize)
					ishl_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ishl_obj.tag
				CASE statictext!
					ist_obj = ldo_obj
					ls_xscale=string(round(ist_obj.x/ll_width,3))
					ls_yscale=string(round(ist_obj.y/ll_height,3))
					ls_wscale=string(round(ist_obj.width/ll_width,3))
					ls_hscale=string(round(ist_obj.height/ll_height,3))
					ls_width = string(ist_obj.width)
					ls_height = string(ist_obj.height)
					ls_textsize = string(ist_obj.textsize)
					ist_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ist_obj.tag
				CASE ELSE
					ls_xscale=string(round(ldo_obj.x/ll_width,3))
					ls_yscale=string(round(ldo_obj.y/ll_height,3))
					ls_wscale=string(round(ldo_obj.width/ll_width,3))
					ls_hscale=string(round(ldo_obj.height/ll_height,3))
					ldo_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+ldo_obj.tag
			END CHOOSE
		
		CASE LINE
			iln_obj=awo
			ls_xscale=string(round(iln_obj.beginx/ll_width,3))
			ls_yscale=string(round(iln_obj.beginy/ll_height,3))
			ls_wscale=string(round(iln_obj.endx/ll_width,3))
			ls_hscale=string(round(iln_obj.endy/ll_height,3))
			ls_x = string(iln_obj.beginx)
			ls_y = string(iln_obj.beginy)
			ls_width = string(iln_obj.endx)
			ls_height = string(iln_obj.endy)
			iln_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iln_obj.tag
		CASE OVAL
			iov_obj = awo
			ls_xscale=string(round(iov_obj.x/ll_width,3))
			ls_yscale=string(round(iov_obj.y/ll_height,3))
			ls_wscale=string(round(iov_obj.width/ll_width,3))
			ls_hscale=string(round(iov_obj.height/ll_height,3))
			ls_x = string(iov_obj.x)
			ls_y = string(iov_obj.y)
			ls_width = string(iov_obj.width)
			ls_height = string(iov_obj.height)
			iov_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+iov_obj.tag
		CASE RECTANGLE
			irec_obj = awo
			ls_xscale=string(round(irec_obj.x/ll_width,3))
			ls_yscale=string(round(irec_obj.y/ll_height,3))
			ls_wscale=string(round(irec_obj.width/ll_width,3))
			ls_hscale=string(round(irec_obj.height/ll_height,3))
			ls_x = string(irec_obj.x)
			ls_y = string(irec_obj.y)
			ls_width = string(irec_obj.width)
			ls_height = string(irec_obj.height)
			irec_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irec_obj.tag
		CASE ROUNDRECTANGLE
			irrec_obj = awo
			ls_xscale=string(round(irrec_obj.x/ll_width,3))
			ls_yscale=string(round(irrec_obj.y/ll_height,3))
			ls_wscale=string(round(irrec_obj.width/ll_width,3))
			ls_hscale=string(round(irrec_obj.height/ll_height,3))
			ls_x = string(irrec_obj.x)
			ls_y = string(irrec_obj.y)
			ls_width = string(irrec_obj.width)
			ls_height = string(irrec_obj.height)
			irrec_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+irrec_obj.tag
		CASE MDICLIENT
			imdi_obj = awo
			ls_xscale=string(round(imdi_obj.x/ll_width,3))
			ls_yscale=string(round(imdi_obj.y/ll_height,3))
			ls_wscale=string(round(imdi_obj.width/ll_width,3))
			ls_hscale=string(round(imdi_obj.height/ll_height,3))
			ls_x = string(imdi_obj.x)
			ls_y = string(imdi_obj.y)
			ls_width = string(imdi_obj.width)
			ls_height = string(imdi_obj.height)
			imdi_obj.tag=ls_register+'/'+ls_resize+'/'+ls_flag+"/"+ls_xscale+'/'+ls_yscale+'/'+ls_wscale+'/'+ls_hscale+'/'+ls_width+'/'+ls_height+'/'+ls_x+'/'+ls_y+'/'+ls_parentw+'/'+ls_parenth+'/'+ls_textsize+'/'+imdi_obj.tag
	END CHOOSE




end subroutine

public function boolean of_resizable (windowobject awo);string ls_tag,ls_flag[]
int li_pos
ls_tag = awo.tag
of_stringtoarray(ls_tag,ls_flag,'/')

if upperbound(ls_flag) <2 then
	return False
elseif ls_flag[2] = '1' then
	return true
else
	return false
end if


end function

public subroutine of_stringtoarray (string as_input, ref string as_array[], string as_flag);String ls_buff
Integer li_len,i

ls_buff = as_input

IF ls_buff='' OR isnull(ls_buff) THEN RETURN

i=1
li_len=len(ls_buff)

DO WHILE Pos(ls_buff,as_flag)<>0
	as_array[i]=Left(ls_buff,Pos(ls_buff,as_flag) - 1)
	i++
	li_len=Len(ls_buff)
	ls_buff=Right(ls_buff,li_len - (Pos(ls_buff,as_flag)))
LOOP

IF Trim(ls_buff)='' THEN
	i=i - 1
ELSE
	as_array[i]=ls_buff
END IF
end subroutine

public subroutine of_stop (windowobject awo);if not of_resizable(awo) then return

string ls_tag

ls_tag = awo.tag

ls_tag = left(ls_tag,2)+'0'+mid(ls_tag,4)

awo.tag = ls_tag
end subroutine

public subroutine of_start (windowobject awo);if  of_resizable(awo) then return
if  not ib_init then return

string ls_tag

ls_tag = awo.tag

ls_tag = left(ls_tag,2)+'1'+mid(ls_tag,4)

awo.tag = ls_tag
end subroutine

public function boolean of_registered (windowobject awo);string ls_tag,ls_flag[]
int li_pos
ls_tag = awo.tag
of_stringtoarray(ls_tag,ls_flag,'/')

if upperbound(ls_flag) <4 then
	return False
elseif ls_flag[1] = '1' then
	return true
else
	return false
end if
end function

public subroutine of_fontresize (boolean ab_resize, integer ai_type);ib_fontresize = ab_resize

ii_fonttype = ai_type
end subroutine

public subroutine of_zoom (boolean ab_zoom, integer ai_type);of_zoom(ab_zoom,ai_type,3)
end subroutine

public subroutine of_resize (userobject au_uo, integer ai_newwidth, integer ai_newheight, boolean ab_recursion);//x: 0/no   1/scale  2/fixtoright  
//y: 0/no   1/scale  2/fixtobottom 
//width: 0/no   1/scale  2/scalefixtoright  3/scalefixtoleft 4/scaletoright 5/scaletoleft
//height: 0/no   1/scale  2/scalefixtobottom  3/scalefixtotop 4/scaletobottom 5/scaletotop
Integer li_controls,i
int  li_font
String ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize,ls_flag
decimal{6}  ld_rate
long ll_index,ll_interval
tab ltb_tmp
dragobject  ldo_obj
userobject luo_tmp
long ll_oldwidth
long ll_oldheight
//ai_newwidth = au_uo.width
//ai_newheight = au_uo.height
if ib_stopall then return
li_controls=upperbound(au_uo.Control[])
FOR i=1 TO li_controls
	ll_oldwidth = 0
	ll_oldheight = 0
	if not of_resizable(au_uo.control[i])   then continue
	CHOOSE CASE 	of_typeof(au_uo.control[i])
		CASE DRAGOBJECT
			ldo_obj = au_uo.control[i]
			CHOOSE CASE ldo_obj.TypeOf()
				CASE datawindow!
					idw_obj=ldo_obj
					of_getscale(idw_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height)
					of_internal_resize(idw_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldwidth = long(ls_width)
					ll_oldheight = long(ls_height)
					if ib_zoom then
						choose case ii_type
							case 1
								ld_rate = idw_obj.height/ll_oldheight
							case 2
								ld_rate = idw_obj.width/ll_oldwidth
							case 3
								ld_rate = min(idw_obj.width/ll_oldwidth,idw_obj.height/ll_oldheight)
							case 4
								ld_rate = max(idw_obj.width/ll_oldwidth,idw_obj.height/ll_oldheight)
						end choose
						if ld_rate > idec_maxrate then
							ld_rate = idec_maxrate
						end if
						if not isvalid(idw_obj.object) then continue
						if idw_obj.object.datawindow.processing = '3' or idw_obj.object.datawindow.processing = '6' or idw_obj.object.datawindow.processing = '7' then continue
						idw_obj.object.datawindow.zoom = string(integer(ld_rate * 100))	
					end if
				CASE tab!
					ltb_tmp=ldo_obj
					of_getscale(ltb_tmp.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ltb_tmp,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ltb_tmp.height/ll_oldheight
							case 2
								ld_rate = ltb_tmp.width/ll_oldwidth
							case 3
								ld_rate = min(ltb_tmp.width/ll_oldwidth,ltb_tmp.height/ll_oldheight)
							case 4
								ld_rate = max(ltb_tmp.width/ll_oldwidth,ltb_tmp.height/ll_oldheight)
						end choose
						ltb_tmp.textsize = Ceiling(li_font*ld_rate)
					end if	
					for ll_index = 1 to upperbound(ltb_tmp.control)
						luo_tmp = ltb_tmp.control[ll_index]
						if not isvalid(luo_tmp) then continue
						if ab_recursion then
							of_resize(luo_tmp,ltb_tmp.width,ltb_tmp.height,true)
						end if
					next					
				CASE userobject!
					iuo_obj=ldo_obj
					of_getscale(iuo_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					of_internal_resize(iuo_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					luo_tmp = iuo_obj
					if ab_recursion then
						of_resize(luo_tmp,luo_tmp.width,luo_tmp.height,true)
					end if
				CASE checkbox!
					icbx_obj = ldo_obj
					of_getscale(icbx_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(icbx_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = icbx_obj.height/ll_oldheight
							case 2
								ld_rate = icbx_obj.width/ll_oldwidth
							case 3
								ld_rate = min(icbx_obj.width/ll_oldwidth,icbx_obj.height/ll_oldheight)
							case 4
								ld_rate = max(icbx_obj.width/ll_oldwidth,icbx_obj.height/ll_oldheight)
						end choose
						icbx_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE radiobutton!
					irb_obj = ldo_obj
					of_getscale(irb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(irb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = irb_obj.height/ll_oldheight
							case 2
								ld_rate = irb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(irb_obj.width/ll_oldwidth,irb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(irb_obj.width/ll_oldwidth,irb_obj.height/ll_oldheight)
						end choose
						irb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE commandbutton!
					icb_obj = ldo_obj
					of_getscale(icb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(icb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = icb_obj.height/ll_oldheight
							case 2
								ld_rate = icb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(icb_obj.width/ll_oldwidth,icb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(icb_obj.width/ll_oldwidth,icb_obj.height/ll_oldheight)
						end choose
						icb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE picturebutton!
					ipb_obj = ldo_obj
					of_getscale(ipb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ipb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ipb_obj.height/ll_oldheight
							case 2
								ld_rate = ipb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ipb_obj.width/ll_oldwidth,ipb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ipb_obj.width/ll_oldwidth,ipb_obj.height/ll_oldheight)
						end choose
						ipb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE datepicker!
					idp_obj = ldo_obj
					of_getscale(idp_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(idp_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = idp_obj.height/ll_oldheight
							case 2
								ld_rate = idp_obj.width/ll_oldwidth
							case 3
								ld_rate = min(idp_obj.width/ll_oldwidth,idp_obj.height/ll_oldheight)
							case 4
								ld_rate = max(idp_obj.width/ll_oldwidth,idp_obj.height/ll_oldheight)
						end choose
						idp_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE monthcalendar!
					imc_obj = ldo_obj
					of_getscale(imc_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(imc_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = imc_obj.height/ll_oldheight
							case 2
								ld_rate = imc_obj.width/ll_oldwidth
							case 3
								ld_rate = min(imc_obj.width/ll_oldwidth,imc_obj.height/ll_oldheight)
							case 4
								ld_rate = max(imc_obj.width/ll_oldwidth,imc_obj.height/ll_oldheight)
						end choose
						imc_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE treeview!
					itv_obj = ldo_obj
					of_getscale(itv_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(itv_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = itv_obj.height/ll_oldheight
							case 2
								ld_rate = itv_obj.width/ll_oldwidth
							case 3
								ld_rate = min(itv_obj.width/ll_oldwidth,itv_obj.height/ll_oldheight)
							case 4
								ld_rate = max(itv_obj.width/ll_oldwidth,itv_obj.height/ll_oldheight)
						end choose
						itv_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE dropdownpicturelistbox!
					iddplb_obj = ldo_obj
					of_getscale(iddplb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iddplb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iddplb_obj.height/ll_oldheight
							case 2
								ld_rate = iddplb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iddplb_obj.width/ll_oldwidth,iddplb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iddplb_obj.width/ll_oldwidth,iddplb_obj.height/ll_oldheight)
						end choose
						iddplb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE picturelistbox!
					iplb_obj = ldo_obj
					of_getscale(iplb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iplb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iplb_obj.height/ll_oldheight
							case 2
								ld_rate = iplb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iplb_obj.width/ll_oldwidth,iplb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iplb_obj.width/ll_oldwidth,iplb_obj.height/ll_oldheight)
						end choose
						iplb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE listview!
					ilv_obj = ldo_obj
					of_getscale(ilv_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ilv_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ilv_obj.height/ll_oldheight
							case 2
								ld_rate = ilv_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ilv_obj.width/ll_oldwidth,ilv_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ilv_obj.width/ll_oldwidth,ilv_obj.height/ll_oldheight)
						end choose
						ilv_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE dropdownlistbox!
					iddlb_obj = ldo_obj
					of_getscale(iddlb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iddlb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iddlb_obj.height/ll_oldheight
							case 2
								ld_rate = iddlb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iddlb_obj.width/ll_oldwidth,iddlb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iddlb_obj.width/ll_oldwidth,iddlb_obj.height/ll_oldheight)
						end choose
						iddlb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE listbox!
					ilb_obj = ldo_obj
					of_getscale(ilb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ilb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ilb_obj.height/ll_oldheight
							case 2
								ld_rate = ilb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ilb_obj.width/ll_oldwidth,ilb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ilb_obj.width/ll_oldwidth,ilb_obj.height/ll_oldheight)
						end choose
						ilb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE groupbox!
					igb_obj = ldo_obj
					of_getscale(igb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(igb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = igb_obj.height/ll_oldheight
							case 2
								ld_rate = igb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(igb_obj.width/ll_oldwidth,igb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(igb_obj.width/ll_oldwidth,igb_obj.height/ll_oldheight)
						end choose
						igb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE editmask!
					iem_obj = ldo_obj
					of_getscale(iem_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iem_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iem_obj.height/ll_oldheight
							case 2
								ld_rate = iem_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iem_obj.width/ll_oldwidth,iem_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iem_obj.width/ll_oldwidth,iem_obj.height/ll_oldheight)
						end choose
						iem_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE multilineedit!
					imle_obj = ldo_obj
					of_getscale(imle_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(imle_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = imle_obj.height/ll_oldheight
							case 2
								ld_rate = imle_obj.width/ll_oldwidth
							case 3
								ld_rate = min(imle_obj.width/ll_oldwidth,imle_obj.height/ll_oldheight)
							case 4
								ld_rate = max(imle_obj.width/ll_oldwidth,imle_obj.height/ll_oldheight)
						end choose
						imle_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE singlelineedit!
					isle_obj = ldo_obj
					of_getscale(isle_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(isle_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = isle_obj.height/ll_oldheight
							case 2
								ld_rate = isle_obj.width/ll_oldwidth
							case 3
								ld_rate = min(isle_obj.width/ll_oldwidth,isle_obj.height/ll_oldheight)
							case 4
								ld_rate = max(isle_obj.width/ll_oldwidth,isle_obj.height/ll_oldheight)
						end choose
						isle_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE statichyperlink!
					ishl_obj = ldo_obj
					of_getscale(ishl_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ishl_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ishl_obj.height/ll_oldheight
							case 2
								ld_rate = ishl_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ishl_obj.width/ll_oldwidth,ishl_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ishl_obj.width/ll_oldwidth,ishl_obj.height/ll_oldheight)
						end choose
						ishl_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE statictext!
					ist_obj = ldo_obj
					of_getscale(ist_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ist_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ist_obj.height/ll_oldheight
							case 2
								ld_rate = ist_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ist_obj.width/ll_oldwidth,ist_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ist_obj.width/ll_oldwidth,ist_obj.height/ll_oldheight)
						end choose
						ist_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE ELSE
					of_getscale(ldo_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					of_internal_resize(ldo_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			END CHOOSE
		CASE LINE
			iln_obj=au_uo.control[i]
			of_getscale(iln_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						iln_obj.beginx=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.beginx = ai_newwidth - iln_obj.endx - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						iln_obj.beginy=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.beginy = ai_newheight - iln_obj.endy - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						iln_obj.endx=ai_newwidth*dec(ls_wbl)
					case '2'
						iln_obj.endx=ai_newwidth - iln_obj.beginx
					case '3'
						ll_interval = of_orginterval_x(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endx=ai_newwidth - ll_interval
						iln_obj.beginx = of_orginterval_w(iln_obj)
					case '4'
						iln_obj.endx=ai_newwidth - iln_obj.beginx
					case '5'
						ll_interval = of_orginterval_x(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endx=ai_newwidth - ll_interval
						iln_obj.beginx = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						iln_obj.endy=ai_newheight*dec(ls_hbl)
					case '2'
						iln_obj.endy=ai_newheight - iln_obj.beginy
					case '3'
						ll_interval = of_orginterval_y(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endy=ai_newheight - ll_interval
						iln_obj.beginy = of_orginterval_h(iln_obj)
					case '4'
						iln_obj.endy=ai_newheight - iln_obj.beginy
					case '5'
						ll_interval = of_orginterval_y(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endy=ai_newheight - ll_interval
						iln_obj.beginy = 0
			end choose
		CASE OVAL
			iov_obj = au_uo.control[i]
			of_getscale(iov_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			  
		     choose case mid(ls_flag,1,1)
					case '1'
						iov_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.x = ai_newwidth - iov_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						iov_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.y = ai_newheight - iov_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						iov_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						iov_obj.width=ai_newwidth - iov_obj.x
					case '3'
						ll_interval = of_orginterval_x(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.width=ai_newwidth - ll_interval
						iov_obj.x = of_orginterval_w(iov_obj)
					case '4'
						iov_obj.width=ai_newwidth - iov_obj.x
					case '5'
						ll_interval = of_orginterval_x(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.width=ai_newwidth - ll_interval
						iov_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						iov_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						iov_obj.height=ai_newheight - iov_obj.y
					case '3'
						ll_interval = of_orginterval_y(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.height=ai_newheight - ll_interval
						iov_obj.y = of_orginterval_h(iov_obj)
					case '4'
						iov_obj.height=ai_newheight - iov_obj.y
					case '5'
						ll_interval = of_orginterval_y(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.height=ai_newheight - ll_interval
						iov_obj.y = 0
			end choose
		CASE RECTANGLE
			irec_obj = au_uo.control[i]
			of_getscale(irec_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						irec_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.x = ai_newwidth - irec_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						irec_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.y = ai_newheight - irec_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						irec_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						irec_obj.width=ai_newwidth - irec_obj.x
					case '3'
						ll_interval = of_orginterval_x(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.width=ai_newwidth - ll_interval
						irec_obj.x = of_orginterval_w(irec_obj)
					case '4'
						irec_obj.width=ai_newwidth - irec_obj.x
					case '5'
						ll_interval = of_orginterval_x(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.width=ai_newwidth - ll_interval
						irec_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						irec_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						irec_obj.height=ai_newheight - irec_obj.y
					case '3'
						ll_interval = of_orginterval_y(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.height=ai_newheight - ll_interval
						irec_obj.y = of_orginterval_h(irec_obj)
					case '4'
						irec_obj.height=ai_newheight - irec_obj.y
					case '5'
						ll_interval = of_orginterval_y(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.height=ai_newheight - ll_interval
						irec_obj.y = 0
			end choose
		CASE ROUNDRECTANGLE
			irrec_obj = au_uo.control[i]
			of_getscale(irrec_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						irrec_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.x = ai_newwidth - irrec_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						irrec_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.y = ai_newheight - irrec_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						irrec_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						irrec_obj.width=ai_newwidth - irrec_obj.x
					case '3'
						ll_interval = of_orginterval_x(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.width=ai_newwidth - ll_interval
						irrec_obj.x = of_orginterval_w(irrec_obj)
					case '4'
						irrec_obj.width=ai_newwidth - irrec_obj.x
					case '5'
						ll_interval = of_orginterval_x(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.width=ai_newwidth - ll_interval
						irrec_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						irrec_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						irrec_obj.height=ai_newheight - irrec_obj.y
					case '3'
						ll_interval = of_orginterval_y(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.height=ai_newheight - ll_interval
						irrec_obj.y = of_orginterval_h(irrec_obj)
					case '4'
						irrec_obj.height=ai_newheight - irrec_obj.y
					case '5'
						ll_interval = of_orginterval_y(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.height=ai_newheight - ll_interval
						irrec_obj.y = 0
			end choose
		CASE MDICLIENT
			imdi_obj = au_uo.control[i]
			of_getscale(imdi_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						imdi_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.x = ai_newwidth - imdi_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						imdi_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.y = ai_newheight - imdi_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						imdi_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						imdi_obj.width=ai_newwidth - imdi_obj.x
					case '3'
						ll_interval = of_orginterval_x(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.width=ai_newwidth - ll_interval
						imdi_obj.x = of_orginterval_w(imdi_obj)
					case '4'
						imdi_obj.width=ai_newwidth - imdi_obj.x
					case '5'
						ll_interval = of_orginterval_x(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.width=ai_newwidth - ll_interval
						imdi_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						imdi_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						imdi_obj.height=ai_newheight - imdi_obj.y
					case '3'
						ll_interval = of_orginterval_y(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.height=ai_newheight - ll_interval
						imdi_obj.y = of_orginterval_h(imdi_obj)
					case '4'
						imdi_obj.height=ai_newheight - imdi_obj.y
					case '5'
						ll_interval = of_orginterval_y(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.height=ai_newheight - ll_interval
						imdi_obj.y = 0
			end choose
	END CHOOSE
NEXT



end subroutine

public subroutine of_resize (window aw_window, integer ai_newwidth, integer ai_newheight, boolean ab_recursion);//x: 0/no   1/scale  2/fixtoright  
//y: 0/no   1/scale  2/fixtobottom 
//width: 0/no   1/scale  2/scalefixtoright  3/scalefixtoleft 4/scaletoright 5/scaletoleft
//height: 0/no   1/scale  2/scalefixtobottom  3/scalefixtotop 4/scaletobottom 5/scaletotop
Integer li_controls,i
int  li_font
String ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize,ls_flag
decimal{6}  ld_rate
long ll_index,ll_interval
tab ltb_tmp
dragobject  ldo_obj
userobject luo_tmp
long ll_oldwidth
long ll_oldheight
//ai_newwidth = aw_window.width
//ai_newheight = aw_window.height
if ib_stopall then return
li_controls=upperbound(aw_window.Control[])
FOR i=1 TO li_controls
	ll_oldwidth = 0
	ll_oldheight = 0
	if not of_resizable(aw_window.control[i]) then continue
	CHOOSE CASE 	of_typeof(aw_window.control[i])
		CASE DRAGOBJECT
			ldo_obj = aw_window.control[i]
			CHOOSE CASE ldo_obj.TypeOf()
				CASE datawindow!
					idw_obj=ldo_obj
					of_getscale(idw_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height)
					of_internal_resize(idw_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldwidth = long(ls_width)
					ll_oldheight = long(ls_height)
					if ib_zoom then
						choose case ii_type
							case 1
								ld_rate = idw_obj.height/ll_oldheight
							case 2
								ld_rate = idw_obj.width/ll_oldwidth
							case 3
								ld_rate = min(idw_obj.width/ll_oldwidth,idw_obj.height/ll_oldheight)
							case 4
								ld_rate = max(idw_obj.width/ll_oldwidth,idw_obj.height/ll_oldheight)
						end choose
						if ld_rate > idec_maxrate then
							ld_rate = idec_maxrate
						end if
						if not isvalid(idw_obj.object) then continue
						if idw_obj.object.datawindow.processing = '3' or idw_obj.object.datawindow.processing = '6' or idw_obj.object.datawindow.processing = '7' then continue
						idw_obj.object.datawindow.zoom = string(integer(ld_rate * 100))	
					end if
				CASE tab!
					ltb_tmp=ldo_obj
					of_getscale(ltb_tmp.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ltb_tmp,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ltb_tmp.height/ll_oldheight
							case 2
								ld_rate = ltb_tmp.width/ll_oldwidth
							case 3
								ld_rate = min(ltb_tmp.width/ll_oldwidth,ltb_tmp.height/ll_oldheight)
							case 4
								ld_rate = max(ltb_tmp.width/ll_oldwidth,ltb_tmp.height/ll_oldheight)
						end choose
						ltb_tmp.textsize = Ceiling(li_font*ld_rate)
					end if	
					for ll_index = 1 to upperbound(ltb_tmp.control)
						luo_tmp = ltb_tmp.control[ll_index]
						if not isvalid(luo_tmp) then continue
						if ab_recursion then
							of_resize(luo_tmp,ltb_tmp.width,ltb_tmp.height,true)
						end if
					next					
				CASE userobject!
					iuo_obj=ldo_obj
					of_getscale(iuo_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					of_internal_resize(iuo_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					luo_tmp = iuo_obj
					if ab_recursion then
						of_resize(luo_tmp,luo_tmp.width,luo_tmp.height,true)
					end if
				CASE checkbox!
					icbx_obj = ldo_obj
					of_getscale(icbx_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(icbx_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = icbx_obj.height/ll_oldheight
							case 2
								ld_rate = icbx_obj.width/ll_oldwidth
							case 3
								ld_rate = min(icbx_obj.width/ll_oldwidth,icbx_obj.height/ll_oldheight)
							case 4
								ld_rate = max(icbx_obj.width/ll_oldwidth,icbx_obj.height/ll_oldheight)
						end choose
						icbx_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE radiobutton!
					irb_obj = ldo_obj
					of_getscale(irb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(irb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = irb_obj.height/ll_oldheight
							case 2
								ld_rate = irb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(irb_obj.width/ll_oldwidth,irb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(irb_obj.width/ll_oldwidth,irb_obj.height/ll_oldheight)
						end choose
						irb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE commandbutton!
					icb_obj = ldo_obj
					of_getscale(icb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(icb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = icb_obj.height/ll_oldheight
							case 2
								ld_rate = icb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(icb_obj.width/ll_oldwidth,icb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(icb_obj.width/ll_oldwidth,icb_obj.height/ll_oldheight)
						end choose
						icb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE picturebutton!
					ipb_obj = ldo_obj
					of_getscale(ipb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ipb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ipb_obj.height/ll_oldheight
							case 2
								ld_rate = ipb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ipb_obj.width/ll_oldwidth,ipb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ipb_obj.width/ll_oldwidth,ipb_obj.height/ll_oldheight)
						end choose
						ipb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE datepicker!
					idp_obj = ldo_obj
					of_getscale(idp_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(idp_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = idp_obj.height/ll_oldheight
							case 2
								ld_rate = idp_obj.width/ll_oldwidth
							case 3
								ld_rate = min(idp_obj.width/ll_oldwidth,idp_obj.height/ll_oldheight)
							case 4
								ld_rate = max(idp_obj.width/ll_oldwidth,idp_obj.height/ll_oldheight)
						end choose
						idp_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE monthcalendar!
					imc_obj = ldo_obj
					of_getscale(imc_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(imc_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = imc_obj.height/ll_oldheight
							case 2
								ld_rate = imc_obj.width/ll_oldwidth
							case 3
								ld_rate = min(imc_obj.width/ll_oldwidth,imc_obj.height/ll_oldheight)
							case 4
								ld_rate = max(imc_obj.width/ll_oldwidth,imc_obj.height/ll_oldheight)
						end choose
						imc_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE treeview!
					itv_obj = ldo_obj
					of_getscale(itv_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(itv_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = itv_obj.height/ll_oldheight
							case 2
								ld_rate = itv_obj.width/ll_oldwidth
							case 3
								ld_rate = min(itv_obj.width/ll_oldwidth,itv_obj.height/ll_oldheight)
							case 4
								ld_rate = max(itv_obj.width/ll_oldwidth,itv_obj.height/ll_oldheight)
						end choose
						itv_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE dropdownpicturelistbox!
					iddplb_obj = ldo_obj
					of_getscale(iddplb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iddplb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iddplb_obj.height/ll_oldheight
							case 2
								ld_rate = iddplb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iddplb_obj.width/ll_oldwidth,iddplb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iddplb_obj.width/ll_oldwidth,iddplb_obj.height/ll_oldheight)
						end choose
						iddplb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE picturelistbox!
					iplb_obj = ldo_obj
					of_getscale(iplb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iplb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iplb_obj.height/ll_oldheight
							case 2
								ld_rate = iplb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iplb_obj.width/ll_oldwidth,iplb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iplb_obj.width/ll_oldwidth,iplb_obj.height/ll_oldheight)
						end choose
						iplb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE listview!
					ilv_obj = ldo_obj
					of_getscale(ilv_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ilv_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ilv_obj.height/ll_oldheight
							case 2
								ld_rate = ilv_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ilv_obj.width/ll_oldwidth,ilv_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ilv_obj.width/ll_oldwidth,ilv_obj.height/ll_oldheight)
						end choose
						ilv_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE dropdownlistbox!
					iddlb_obj = ldo_obj
					of_getscale(iddlb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iddlb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iddlb_obj.height/ll_oldheight
							case 2
								ld_rate = iddlb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iddlb_obj.width/ll_oldwidth,iddlb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iddlb_obj.width/ll_oldwidth,iddlb_obj.height/ll_oldheight)
						end choose
						iddlb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE listbox!
					ilb_obj = ldo_obj
					of_getscale(ilb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ilb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ilb_obj.height/ll_oldheight
							case 2
								ld_rate = ilb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ilb_obj.width/ll_oldwidth,ilb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ilb_obj.width/ll_oldwidth,ilb_obj.height/ll_oldheight)
						end choose
						ilb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE groupbox!
					igb_obj = ldo_obj
					of_getscale(igb_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(igb_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = igb_obj.height/ll_oldheight
							case 2
								ld_rate = igb_obj.width/ll_oldwidth
							case 3
								ld_rate = min(igb_obj.width/ll_oldwidth,igb_obj.height/ll_oldheight)
							case 4
								ld_rate = max(igb_obj.width/ll_oldwidth,igb_obj.height/ll_oldheight)
						end choose
						igb_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE editmask!
					iem_obj = ldo_obj
					of_getscale(iem_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(iem_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = iem_obj.height/ll_oldheight
							case 2
								ld_rate = iem_obj.width/ll_oldwidth
							case 3
								ld_rate = min(iem_obj.width/ll_oldwidth,iem_obj.height/ll_oldheight)
							case 4
								ld_rate = max(iem_obj.width/ll_oldwidth,iem_obj.height/ll_oldheight)
						end choose
						iem_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE multilineedit!
					imle_obj = ldo_obj
					of_getscale(imle_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(imle_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = imle_obj.height/ll_oldheight
							case 2
								ld_rate = imle_obj.width/ll_oldwidth
							case 3
								ld_rate = min(imle_obj.width/ll_oldwidth,imle_obj.height/ll_oldheight)
							case 4
								ld_rate = max(imle_obj.width/ll_oldwidth,imle_obj.height/ll_oldheight)
						end choose
						imle_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE singlelineedit!
					isle_obj = ldo_obj
					of_getscale(isle_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(isle_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = isle_obj.height/ll_oldheight
							case 2
								ld_rate = isle_obj.width/ll_oldwidth
							case 3
								ld_rate = min(isle_obj.width/ll_oldwidth,isle_obj.height/ll_oldheight)
							case 4
								ld_rate = max(isle_obj.width/ll_oldwidth,isle_obj.height/ll_oldheight)
						end choose
						isle_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE statichyperlink!
					ishl_obj = ldo_obj
					of_getscale(ishl_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ishl_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ishl_obj.height/ll_oldheight
							case 2
								ld_rate = ishl_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ishl_obj.width/ll_oldwidth,ishl_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ishl_obj.width/ll_oldwidth,ishl_obj.height/ll_oldheight)
						end choose
						ishl_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE statictext!
					ist_obj = ldo_obj
					of_getscale(ist_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_textsize)
					of_internal_resize(ist_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					ll_oldheight = long(ls_height)
					ll_oldwidth = long(ls_width)
					li_font = integer(ls_textsize)
					if ib_fontresize then
						choose case ii_fonttype
							case 1
								ld_rate = ist_obj.height/ll_oldheight
							case 2
								ld_rate = ist_obj.width/ll_oldwidth
							case 3
								ld_rate = min(ist_obj.width/ll_oldwidth,ist_obj.height/ll_oldheight)
							case 4
								ld_rate = max(ist_obj.width/ll_oldwidth,ist_obj.height/ll_oldheight)
						end choose
						ist_obj.textsize = Ceiling(li_font*ld_rate)
					end if
				CASE ELSE
					of_getscale(ldo_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
					of_internal_resize(ldo_obj,ls_flag,ai_newwidth,ai_newheight,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			END CHOOSE
		CASE LINE
			iln_obj=aw_window.control[i]
			of_getscale(iln_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						iln_obj.beginx=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.beginx = ai_newwidth - iln_obj.endx - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						iln_obj.beginy=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.beginy = ai_newheight - iln_obj.endy - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						iln_obj.endx=ai_newwidth*dec(ls_wbl)
					case '2'
						iln_obj.endx=ai_newwidth - iln_obj.beginx
					case '3'
						ll_interval = of_orginterval_x(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endx=ai_newwidth - ll_interval
						iln_obj.beginx = of_orginterval_w(iln_obj)
					case '4'
						iln_obj.endx=ai_newwidth - iln_obj.beginx
					case '5'
						ll_interval = of_orginterval_x(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endx=ai_newwidth - ll_interval
						iln_obj.beginx = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						iln_obj.endy=ai_newheight*dec(ls_hbl)
					case '2'
						iln_obj.endy=ai_newheight - iln_obj.beginy
					case '3'
						ll_interval = of_orginterval_y(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endy=ai_newheight - ll_interval
						iln_obj.beginy = of_orginterval_h(iln_obj)
					case '4'
						iln_obj.endy=ai_newheight - iln_obj.beginy
					case '5'
						ll_interval = of_orginterval_y(iln_obj)
						if ll_interval = -1 then continue
						iln_obj.endy=ai_newheight - ll_interval
						iln_obj.beginy = 0
			end choose
		CASE OVAL
			iov_obj = aw_window.control[i]
			of_getscale(iov_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			  
		     choose case mid(ls_flag,1,1)
					case '1'
						iov_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.x = ai_newwidth - iov_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						iov_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.y = ai_newheight - iov_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						iov_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						iov_obj.width=ai_newwidth - iov_obj.x
					case '3'
						ll_interval = of_orginterval_x(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.width=ai_newwidth - ll_interval
						iov_obj.x = of_orginterval_w(iov_obj)
					case '4'
						iov_obj.width=ai_newwidth - iov_obj.x
					case '5'
						ll_interval = of_orginterval_x(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.width=ai_newwidth - ll_interval
						iov_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						iov_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						iov_obj.height=ai_newheight - iov_obj.y
					case '3'
						ll_interval = of_orginterval_y(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.height=ai_newheight - ll_interval
						iov_obj.y = of_orginterval_h(iov_obj)
					case '4'
						iov_obj.height=ai_newheight - iov_obj.y
					case '5'
						ll_interval = of_orginterval_y(iov_obj)
						if ll_interval = -1 then continue
						iov_obj.height=ai_newheight - ll_interval
						iov_obj.y = 0
			end choose
		CASE RECTANGLE
			irec_obj = aw_window.control[i]
			of_getscale(irec_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						irec_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.x = ai_newwidth - irec_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						irec_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.y = ai_newheight - irec_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						irec_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						irec_obj.width=ai_newwidth - irec_obj.x
					case '3'
						ll_interval = of_orginterval_x(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.width=ai_newwidth - ll_interval
						irec_obj.x = of_orginterval_w(irec_obj)
					case '4'
						irec_obj.width=ai_newwidth - irec_obj.x
					case '5'
						ll_interval = of_orginterval_x(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.width=ai_newwidth - ll_interval
						irec_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						irec_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						irec_obj.height=ai_newheight - irec_obj.y
					case '3'
						ll_interval = of_orginterval_y(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.height=ai_newheight - ll_interval
						irec_obj.y = of_orginterval_h(irec_obj)
					case '4'
						irec_obj.height=ai_newheight - irec_obj.y
					case '5'
						ll_interval = of_orginterval_y(irec_obj)
						if ll_interval = -1 then continue
						irec_obj.height=ai_newheight - ll_interval
						irec_obj.y = 0
			end choose
		CASE ROUNDRECTANGLE
			irrec_obj = aw_window.control[i]
			of_getscale(irrec_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						irrec_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.x = ai_newwidth - irrec_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						irrec_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.y = ai_newheight - irrec_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						irrec_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						irrec_obj.width=ai_newwidth - irrec_obj.x
					case '3'
						ll_interval = of_orginterval_x(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.width=ai_newwidth - ll_interval
						irrec_obj.x = of_orginterval_w(irrec_obj)
					case '4'
						irrec_obj.width=ai_newwidth - irrec_obj.x
					case '5'
						ll_interval = of_orginterval_x(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.width=ai_newwidth - ll_interval
						irrec_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						irrec_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						irrec_obj.height=ai_newheight - irrec_obj.y
					case '3'
						ll_interval = of_orginterval_y(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.height=ai_newheight - ll_interval
						irrec_obj.y = of_orginterval_h(irrec_obj)
					case '4'
						irrec_obj.height=ai_newheight - irrec_obj.y
					case '5'
						ll_interval = of_orginterval_y(irrec_obj)
						if ll_interval = -1 then continue
						irrec_obj.height=ai_newheight - ll_interval
						irrec_obj.y = 0
			end choose
		CASE MDICLIENT
			imdi_obj = aw_window.control[i]
			of_getscale(imdi_obj.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl)
			choose case mid(ls_flag,1,1)
					case '1'
						imdi_obj.x=ai_newwidth*dec(ls_xbl)
					case '2'
						ll_interval = of_orginterval_x(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.x = ai_newwidth - imdi_obj.width - ll_interval
			end choose
			choose case mid(ls_flag,2,1)
					case '1'
						imdi_obj.y=ai_newheight*dec(ls_ybl)
					case '2'
						ll_interval = of_orginterval_y(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.y = ai_newheight - imdi_obj.height - ll_interval
			end choose
			choose case mid(ls_flag,3,1)
					case '1'
						imdi_obj.width=ai_newwidth*dec(ls_wbl)
					case '2'
						imdi_obj.width=ai_newwidth - imdi_obj.x
					case '3'
						ll_interval = of_orginterval_x(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.width=ai_newwidth - ll_interval
						imdi_obj.x = of_orginterval_w(imdi_obj)
					case '4'
						imdi_obj.width=ai_newwidth - imdi_obj.x
					case '5'
						ll_interval = of_orginterval_x(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.width=ai_newwidth - ll_interval
						imdi_obj.x = 0
			end choose
			choose case mid(ls_flag,4,1)
					case '1'
						imdi_obj.height=ai_newheight*dec(ls_hbl)
					case '2'
						imdi_obj.height=ai_newheight - imdi_obj.y
					case '3'
						ll_interval = of_orginterval_y(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.height=ai_newheight - ll_interval
						imdi_obj.y = of_orginterval_h(imdi_obj)
					case '4'
						imdi_obj.height=ai_newheight - imdi_obj.y
					case '5'
						ll_interval = of_orginterval_y(imdi_obj)
						if ll_interval = -1 then continue
						imdi_obj.height=ai_newheight - ll_interval
						imdi_obj.y = 0
			end choose
	END CHOOSE
NEXT



end subroutine

public subroutine of_init (userobject au_uo, boolean ab_recursion);

of_init(au_uo,au_uo.width,au_uo.height,ab_recursion)
end subroutine

public subroutine of_resize (datawindow adw, integer ai_newwidth, integer ai_newheight, decimal ad_maxrate);long ll_oldwidth
long ll_oldheight
string ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_flag
decimal{6} ld_rate
of_getscale(adw.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height)
					
ll_oldwidth = long(ls_width)
ll_oldheight = long(ls_height)
adw.width = ai_newwidth
adw.height = ai_newheight
if ib_stopall then return
if ib_zoom then
	choose case ii_type
			case 1
				ld_rate = ai_newheight/ll_oldheight
			case 2
				ld_rate = ai_newwidth/ll_oldwidth
			case 3
				ld_rate = min(ai_newwidth/ll_oldwidth,ai_newheight/ll_oldheight)
			case 4
				ld_rate = max(ai_newwidth/ll_oldwidth,ai_newheight/ll_oldheight)
	end choose
	if ld_rate > ad_maxrate then
		ld_rate = ad_maxrate
	end if
	if not isvalid(adw.object) then return
	if adw.object.datawindow.processing = '3' or adw.object.datawindow.processing = '6' or adw.object.datawindow.processing = '7' then return
	adw.object.datawindow.zoom = string(integer(ld_rate * 100))	
end if
end subroutine

public subroutine of_resize (datawindow adw, integer ai_newwidth, integer ai_newheight, boolean ab_zoom, integer ai_type, decimal ad_maxrate);long ll_oldwidth
long ll_oldheight
string ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height,ls_flag
decimal{6} ld_rate
of_getscale(adw.tag,ls_flag,ls_xbl,ls_ybl,ls_wbl,ls_hbl,ls_width,ls_height)
					
ll_oldwidth = long(ls_width)
ll_oldheight = long(ls_height)
adw.width = ai_newwidth
adw.height = ai_newheight
if ib_stopall then return
if ab_zoom then
	choose case ai_type
			case 1
				ld_rate = ai_newheight/ll_oldheight
			case 2
				ld_rate = ai_newwidth/ll_oldwidth
			case 3
				ld_rate = min(ai_newwidth/ll_oldwidth,ai_newheight/ll_oldheight)
			case 4
				ld_rate = max(ai_newwidth/ll_oldwidth,ai_newheight/ll_oldheight)
	end choose
	if ld_rate > ad_maxrate then
		ld_rate = ad_maxrate
	end if
	if not isvalid(adw.object) then return
	if adw.object.datawindow.processing = '3' or adw.object.datawindow.processing = '6' or adw.object.datawindow.processing = '7' then return
	adw.object.datawindow.zoom = string(integer(ld_rate * 100))	
end if
end subroutine

public subroutine of_getscale (string as_input, ref string as_flag, ref string as_xscale, ref string as_yscale, ref string as_wscale, ref string as_hscale);//
string ls_array[]

of_stringtoarray(as_input,ls_array,'/')

if upperbound(ls_array) < 7 then return

as_flag = ls_array[3]
as_xscale = ls_array[4]
as_yscale = ls_array[5]
as_wscale = ls_array[6]
as_hscale = ls_array[7]
end subroutine

public subroutine of_getscale (string as_input, ref string as_flag, ref string as_xscale, ref string as_yscale, ref string as_wscale, ref string as_hscale, ref string as_width, ref string as_height);//
string ls_array[]

of_stringtoarray(as_input,ls_array,'/')

if upperbound(ls_array) < 9 then return

as_flag = ls_array[3]
as_xscale = ls_array[4]
as_yscale = ls_array[5]
as_wscale = ls_array[6]
as_hscale = ls_array[7]
as_width = ls_array[8]
as_height = ls_array[9]
end subroutine

public subroutine of_getscale (string as_input, ref string as_flag, ref string as_xscale, ref string as_yscale, ref string as_wscale, ref string as_hscale, ref string as_width, ref string as_height, ref string as_fontsize);//
string ls_array[]

of_stringtoarray(as_input,ls_array,'/')

if upperbound(ls_array) < 14 then return

as_flag = ls_array[3]
as_xscale = ls_array[4]
as_yscale = ls_array[5]
as_wscale = ls_array[6]
as_hscale = ls_array[7]
as_width = ls_array[8]
as_height = ls_array[9]
as_fontsize = ls_array[14]
end subroutine

public subroutine of_init_object (windowobject awo, decimal ad_xscale, decimal ad_yscale, decimal ad_wscale, decimal ad_hscale);
Long ll_width,ll_height
String ls_xscale,ls_yscale,ls_wscale,ls_hscale
string ls_array[]
string ls_tag
long ll_int
of_stringtoarray(awo.tag,ls_array,'/')
if upperbound(ls_array) > 3 then
	if ad_xscale > 0 then
		ls_xscale = string(ad_xscale)
		ls_array[4] = ls_xscale
	end if
	if ad_yscale > 0 then
		ls_yscale = string(ad_yscale)
		ls_array[5] = ls_yscale
	end if
	if ad_wscale > 0 then
		ls_wscale = string(ad_wscale)
		ls_array[6] = ls_wscale
	end if
	if ad_hscale > 0 then
		ls_hscale = string(ad_hscale)
		ls_array[7] = ls_hscale
	end if
	
	for ll_int = 1 to upperbound(ls_array)
		ls_tag += ls_array[ll_int]+"/"
	next
	
	ls_tag = mid(ls_tag,1,len(ls_tag) - 1)
	
	awo.tag = ls_tag
end if

end subroutine

public subroutine of_pause ();

ib_stopall = True
end subroutine

public subroutine of_recover ();

ib_stopall = false
end subroutine

public subroutine of_zoom (boolean ab_zoom, integer ai_type, decimal adec_rate);//

ib_zoom = ab_zoom
ii_type = ai_type
idec_maxrate = adec_rate

end subroutine

public function long of_orginterval_x (windowobject awo);string  ls_array[]
long ll_x,ll_parentw,ll_width,ll_return

of_stringtoarray(awo.tag,ls_array,'/')

if upperbound(ls_array) < 12 then return -1

ll_x = long(ls_array[10])
ll_width = long(ls_array[8])
ll_parentw = long(ls_array[12])
ll_return = ll_parentw - ll_width - ll_x
return ll_return
end function

public function long of_orginterval_y (windowobject awo);string  ls_array[]
long ll_y,ll_parenth,ll_height,ll_return

of_stringtoarray(awo.tag,ls_array,'/')

if upperbound(ls_array) < 13 then return -1

ll_y = long(ls_array[11])
ll_height = long(ls_array[9])
ll_parenth = long(ls_array[13])
ll_return = ll_parenth - ll_height - ll_y
return ll_return
end function

public function long of_orginterval_w (windowobject awo);string  ls_array[]
long ll_x,ll_parentw,ll_width,ll_return

of_stringtoarray(awo.tag,ls_array,'/')

if upperbound(ls_array) < 12 then return -1

ll_x = long(ls_array[10])
ll_width = long(ls_array[8])
ll_parentw = long(ls_array[12])
ll_return = ll_x
return ll_return
end function

public function long of_orginterval_h (windowobject awo);string  ls_array[]
long ll_y,ll_parenth,ll_height,ll_return

of_stringtoarray(awo.tag,ls_array,'/')

if upperbound(ls_array) < 13 then return -1

ll_y = long(ls_array[11])
ll_height = long(ls_array[9])
ll_parenth = long(ls_array[13])
ll_return =ll_y 
return ll_return
end function

public subroutine of_setflag (windowobject awo, string as_flag);//
string ls_array[]
string ls_tag
long ll_int
of_stringtoarray(awo.tag,ls_array,'/')

if upperbound(ls_array) < 3 then 
	Messagebox("Error",awo.classname()+" does not register")
	return
end if

ls_array[3] = as_flag

for ll_int = 1 to upperbound(ls_array)
	ls_tag += ls_array[ll_int]+"/"
next

ls_tag = mid(ls_tag,1,len(ls_tag) - 1)

awo.tag = ls_tag

end subroutine

public subroutine of_internal_resize (ref dragobject awo, string as_flag, integer ai_newwidth, integer ai_newheight, string as_xbl, string as_ybl, string as_wbl, string as_hbl);long ll_interval
choose case mid(as_flag,1,1)
		case '1'
			awo.x=ai_newwidth*dec(as_xbl)
		case '2'
			ll_interval = of_orginterval_x(awo)
			if ll_interval = -1 then return
			awo.x = ai_newwidth - awo.width - ll_interval
end choose
choose case mid(as_flag,2,1)
		case '1'
			awo.y=ai_newheight*dec(as_ybl)
		case '2'
			ll_interval = of_orginterval_y(awo)
			if ll_interval = -1 then return
			awo.y = ai_newheight - awo.height - ll_interval
end choose
choose case mid(as_flag,3,1)
		case '1'
			awo.width=ai_newwidth*dec(as_wbl)
		case '2'
			ll_interval = of_orginterval_x(awo)
			if ll_interval = -1 then return 
			awo.width=ai_newwidth - awo.x - ll_interval
		case '3'
			ll_interval = of_orginterval_x(awo)
			if ll_interval = -1 then return
			awo.width=ai_newwidth - ll_interval
			awo.x = of_orginterval_w(awo)
		case '4'
			awo.width=ai_newwidth - awo.x
		case '5'
			ll_interval = of_orginterval_x(awo)
			if ll_interval = -1 then return
			awo.width=ai_newwidth - ll_interval
			awo.x = 0
end choose
choose case mid(as_flag,4,1)
		case '1'
			awo.height=ai_newheight*dec(as_hbl)
		case '2'
			ll_interval = of_orginterval_y(awo)
			if ll_interval = -1 then return
			awo.height=ai_newheight - awo.y - ll_interval
		case '3'
			ll_interval = of_orginterval_y(awo)
			if ll_interval = -1 then return
			awo.height=ai_newheight - ll_interval
			awo.y = of_orginterval_h(awo)
		case '4'
			awo.height=ai_newheight - awo.y
		case '5'
			ll_interval = of_orginterval_y(awo)
			if ll_interval = -1 then return
			awo.height=ai_newheight - ll_interval
			awo.y = 0
end choose

end subroutine

public subroutine of_init_object (windowobject awo, boolean ab_recursion);userobject luo
tab ltb
window lw
long ll_parentw,ll_parenth

choose case awo.getparent().typeof()
                case userobject!
                                luo = awo.getparent()
                                ll_parentw = luo.width
                                ll_parenth = luo.height
                case tab!
                                ltb = awo.getparent()
                                ll_parentw = ltb.width
                                ll_parenth = ltb.height
                case window!
                                lw = awo.getparent()
                                ll_parentw = lw.width
                                ll_parenth = lw.height
end choose

of_init_object(awo,ll_parentw,ll_parenth,ab_recursion)
end subroutine

on eon_appeon_resize.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_appeon_resize.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

