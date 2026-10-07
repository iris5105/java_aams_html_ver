forward
global type u_plan from u_ancestor
end type
type u3_title from fw_u_dw2title within u_plan
end type
type u2_title from fw_u_dw2title within u_plan
end type
type d2_calendar from fw_u_dwo within u_plan
end type
type d1_calendar from fw_u_dwo within u_plan
end type
type u1_title from fw_u_dw2title within u_plan
end type
type d3_calendar from fw_u_dwo within u_plan
end type
end forward

global type u_plan from u_ancestor
integer width = 1797
integer height = 3232
boolean setsheetcolor = true
event fwe_retrieve ( )
u3_title u3_title
u2_title u2_title
d2_calendar d2_calendar
d1_calendar d1_calendar
u1_title u1_title
d3_calendar d3_calendar
end type
global u_plan u_plan

type variables
Public:
	DateTime	idt_ymd
	STRING	is_ymd = ''

Private:
	STRING	ToolTipDatadwo	= ''	// ToolTipData
end variables

forward prototypes
public subroutine of_init ()
public function long of_getmax4xpos ()
end prototypes

public subroutine of_init ();
end subroutine

public function long of_getmax4xpos ();RETURN pixelstounits (UnitsToPixels (1797+60, XUnitsToPixels!), XPixelsToUnits!)
end function

on u_plan.create
int iCurrent
call super::create
this.u3_title=create u3_title
this.u2_title=create u2_title
this.d2_calendar=create d2_calendar
this.d1_calendar=create d1_calendar
this.u1_title=create u1_title
this.d3_calendar=create d3_calendar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.u3_title
this.Control[iCurrent+2]=this.u2_title
this.Control[iCurrent+3]=this.d2_calendar
this.Control[iCurrent+4]=this.d1_calendar
this.Control[iCurrent+5]=this.u1_title
this.Control[iCurrent+6]=this.d3_calendar
end on

on u_plan.destroy
call super::destroy
destroy(this.u3_title)
destroy(this.u2_title)
destroy(this.d2_calendar)
destroy(this.d1_calendar)
destroy(this.u1_title)
destroy(this.d3_calendar)
end on

type u3_title from fw_u_dw2title within u_plan
integer y = 2060
integer width = 823
integer taborder = 30
end type

on u3_title.destroy
call fw_u_dw2title::destroy
end on

type u2_title from fw_u_dw2title within u_plan
integer y = 1036
integer width = 823
integer taborder = 10
end type

on u2_title.destroy
call fw_u_dw2title::destroy
end on

type d2_calendar from fw_u_dwo within u_plan
integer x = 9
integer y = 1124
integer width = 1774
integer height = 760
integer taborder = 20
boolean bringtotop = true
string dataobject = "dc_plan"
boolean border = false
boolean livescroll = false
boolean ibdesign4role = false
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_fund_default_change = false
boolean eb_range_delcopy = false
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;u2_title.st_title.text = MID (Object.as_ym [1],1,4) +'년 ' + MID(Object.as_ym [1],5,2) + '월'
If rowcount < 6 Then Insertrow(0)
IF rowcount=6	THEN height=760 + 132	ELSE height=760
end event

event mousemove;string	ls_obj, ls_objdesc, ls_rowdata, ls_temp
string	ls_syntax, ls_errmsg

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj = 'datawindow' Then Return

ls_temp = left(ls_obj, 3)
IF	pos ('sun,mon,tue,wed,thu,fri,sat',ls_temp)>0	Then
//	IF	f_notnull (GetItemstring(row, ls_temp + '_schedule'))	Then
		is_ymd = Object.as_ym [1] + This.GetItemstring(row, ls_temp + '_ymd')
		idt_ymd = datetime (date (string (is_ymd,'@@@@.@@.@@')))
//	Else
//		is_ymd = null_s
//		idt_ymd = null_dt
//	End IF
End IF

ls_temp = right(ls_obj, 3)
If not(fw_f_nvls(ls_temp, '') = 'ymd') Then Return
ls_temp = This.GetItemstring(row, left(ls_obj, 3) + '_schedule')
If not(fw_f_nvls(ls_temp, '') = 'check') Then
	ls_syntax	= ls_obj + '.tooltip.enabled="0"'
	ls_errmsg	= This.Modify(ls_syntax)
	If fw_f_nvls(ls_errmsg, '') <> '' then
		Messagebox('User schedule Tooltip enabled 0 error', ls_errmsg)
	end If
	ToolTipDatadwo = ''
	Return
end If
ls_objdesc = left(ls_obj, 3) + '_desc'
choose case lower(This.Describe(ls_obj + ".Type"))
	case 'column'
		If ToolTipDatadwo = ls_obj + 'data' + string(row) Then Return
		gnv_extfunc.of_setinitializationapi()
		gnv_extfunc.istr_node4value.cstr01	= ls_objdesc
		gnv_extfunc.biznode1te(135, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		ls_rowdata = This.Describe(gnv_extfunc.is_nodevalue + gnv_extfunc.istr_node4value.cstr01 + ") ', " + string(row) + ")")		
		gnv_extfunc.istr_node4value.cstr01	= ls_obj
		gnv_extfunc.istr_node4value.cstr02	= ls_rowdata
		gnv_extfunc.biznode11te(107, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
		ls_syntax = gnv_extfunc.istr_node4value.cstr11
		ls_errmsg	= This.Modify(ls_syntax)
		If fw_f_nvls(ls_errmsg, '') <> '' then
			Messagebox('User schedule Tooltip enabled 1 error', ls_errmsg)
			Return
		end If
		ToolTipDatadwo = ls_obj + 'data' + string(row)
end choose
end event

event clicked;call super::clicked;LONG	ll
FOR  ll = 1  TO  rowcount ()
	d1_calendar.object.clickday [ll] = '000000'
	IF	f_notnull (is_ymd) THEN Object.clickday [ll] = is_ymd
	d3_calendar.object.clickday [ll] = '000000'
NEXT
post event fwe_retrieve ()
end event

type d1_calendar from fw_u_dwo within u_plan
integer x = 9
integer y = 100
integer width = 1774
integer height = 760
integer taborder = 20
boolean bringtotop = true
string dataobject = "dc_plan"
boolean border = false
boolean livescroll = false
boolean ibdesign4role = false
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_fund_default_change = false
boolean eb_range_delcopy = false
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;u1_title.st_title.text = MID (Object.as_ym [1],1,4) +'년 ' + MID(Object.as_ym [1],5,2) + '월'
If rowcount < 6 Then Insertrow(0)
IF rowcount=6	THEN height=760 + 132	ELSE height=760
end event

event mousemove;string	ls_obj, ls_objdesc, ls_rowdata, ls_temp
string	ls_syntax, ls_errmsg

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj = 'datawindow' Then Return

ls_temp = left(ls_obj, 3)
IF	pos ('sun,mon,tue,wed,thu,fri,sat',ls_temp)>0	Then
//	IF	f_notnull (GetItemstring(row, ls_temp + '_schedule'))	Then
		is_ymd = Object.as_ym [1] + This.GetItemstring(row, ls_temp + '_ymd')
		idt_ymd = datetime (date (string (is_ymd,'@@@@.@@.@@')))
//	Else
//		is_ymd = null_s
//		idt_ymd = null_dt
//	End IF
End IF

ls_temp = right(ls_obj, 3)
If not(fw_f_nvls(ls_temp, '') = 'ymd') Then Return
ls_temp = This.GetItemstring(row, left(ls_obj, 3) + '_schedule')
If not(fw_f_nvls(ls_temp, '') = 'check') Then
	ls_syntax	= ls_obj + '.tooltip.enabled="0"'
	ls_errmsg	= This.Modify(ls_syntax)
	If fw_f_nvls(ls_errmsg, '') <> '' then
		Messagebox('User schedule Tooltip enabled 0 error', ls_errmsg)
	end If
	ToolTipDatadwo = ''
	Return
end If
ls_objdesc = left(ls_obj, 3) + '_desc'
choose case lower(This.Describe(ls_obj + ".Type"))
	case 'column'
		If ToolTipDatadwo = ls_obj + 'data' + string(row) Then Return
		gnv_extfunc.of_setinitializationapi()
		gnv_extfunc.istr_node4value.cstr01	= ls_objdesc
		gnv_extfunc.biznode1te(135, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		ls_rowdata = This.Describe(gnv_extfunc.is_nodevalue + gnv_extfunc.istr_node4value.cstr01 + ") ', " + string(row) + ")")		
		gnv_extfunc.istr_node4value.cstr01	= ls_obj
		gnv_extfunc.istr_node4value.cstr02	= ls_rowdata
		gnv_extfunc.biznode11te(107, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
		ls_syntax = gnv_extfunc.istr_node4value.cstr11
		ls_errmsg	= This.Modify(ls_syntax)
		If fw_f_nvls(ls_errmsg, '') <> '' then
			Messagebox('User schedule Tooltip enabled 1 error', ls_errmsg)
			Return
		end If
		ToolTipDatadwo = ls_obj + 'data' + string(row)
end choose
end event

event clicked;LONG	ll
FOR  ll = 1  TO  rowcount ()
	IF	f_notnull (is_ymd) THEN Object.clickday [ll] = is_ymd
	d2_calendar.object.clickday [ll] = '000000'
	d3_calendar.object.clickday [ll] = '000000'
NEXT
post event fwe_retrieve ()
end event

type u1_title from fw_u_dw2title within u_plan
integer y = 12
integer width = 823
integer taborder = 20
end type

on u1_title.destroy
call fw_u_dw2title::destroy
end on

event constructor;call super::constructor;st_title.textcolor = 13762560
end event

type d3_calendar from fw_u_dwo within u_plan
integer x = 9
integer y = 2148
integer width = 1774
integer height = 760
integer taborder = 10
boolean bringtotop = true
string dataobject = "dc_plan"
boolean border = false
boolean livescroll = false
boolean ibdesign4role = false
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean eb_fund_default_change = false
boolean eb_range_delcopy = false
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;u3_title.st_title.text = MID (Object.as_ym [1],1,4) +'년 ' + MID(Object.as_ym [1],5,2) + '월'
If rowcount < 6 Then Insertrow(0)
IF rowcount=6	THEN height=760 + 132	ELSE height=760
end event

event mousemove;string	ls_obj, ls_objdesc, ls_rowdata, ls_temp
string	ls_syntax, ls_errmsg

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj = 'datawindow' Then Return

ls_temp = left(ls_obj, 3)
IF	pos ('sun,mon,tue,wed,thu,fri,sat',ls_temp)>0	Then
//	IF	f_notnull (GetItemstring(row, ls_temp + '_schedule'))	Then
		is_ymd = Object.as_ym [1] + This.GetItemstring(row, ls_temp + '_ymd')
		idt_ymd = datetime (date (string (is_ymd,'@@@@.@@.@@')))
//	Else
//		is_ymd = null_s
//		idt_ymd = null_dt
//	End IF
End IF

ls_temp = right(ls_obj, 3)
If not(fw_f_nvls(ls_temp, '') = 'ymd') Then Return
ls_temp = This.GetItemstring(row, left(ls_obj, 3) + '_schedule')
If not(fw_f_nvls(ls_temp, '') = 'check') Then
	ls_syntax	= ls_obj + '.tooltip.enabled="0"'
	ls_errmsg	= This.Modify(ls_syntax)
	If fw_f_nvls(ls_errmsg, '') <> '' then
		Messagebox('User schedule Tooltip enabled 0 error', ls_errmsg)
	end If
	ToolTipDatadwo = ''
	Return
end If
ls_objdesc = left(ls_obj, 3) + '_desc'
choose case lower(This.Describe(ls_obj + ".Type"))
	case 'column'
		If ToolTipDatadwo = ls_obj + 'data' + string(row) Then Return
		gnv_extfunc.of_setinitializationapi()
		gnv_extfunc.istr_node4value.cstr01	= ls_objdesc
		gnv_extfunc.biznode1te(135, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
		ls_rowdata = This.Describe(gnv_extfunc.is_nodevalue + gnv_extfunc.istr_node4value.cstr01 + ") ', " + string(row) + ")")		
		gnv_extfunc.istr_node4value.cstr01	= ls_obj
		gnv_extfunc.istr_node4value.cstr02	= ls_rowdata
		gnv_extfunc.biznode11te(107, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)
		ls_syntax = gnv_extfunc.istr_node4value.cstr11
		ls_errmsg	= This.Modify(ls_syntax)
		If fw_f_nvls(ls_errmsg, '') <> '' then
			Messagebox('User schedule Tooltip enabled 1 error', ls_errmsg)
			Return
		end If
		ToolTipDatadwo = ls_obj + 'data' + string(row)
end choose
end event

event clicked;call super::clicked;LONG	ll
FOR  ll = 1  TO  rowcount ()
	d1_calendar.object.clickday [ll] = '000000'
	d2_calendar.object.clickday [ll] = '000000'
	IF	f_notnull (is_ymd) THEN Object.clickday [ll] = is_ymd
NEXT
post event fwe_retrieve ()
end event

