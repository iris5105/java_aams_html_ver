forward
global type u_plan4u2sc from u_ancestor
end type
type uo_title from fw_u_dw2title within u_plan4u2sc
end type
type p_memo from pf_u_imagebutton within u_plan4u2sc
end type
type p_refresh from pf_u_imagebutton within u_plan4u2sc
end type
type em_ymd from pf_u_editmask within u_plan4u2sc
end type
type dw_calendar from u_dw within u_plan4u2sc
end type
end forward

global type u_plan4u2sc from u_ancestor
integer width = 2021
integer height = 1384
boolean setsheetcolor = true
event fwe_retrieve ( )
uo_title uo_title
p_memo p_memo
p_refresh p_refresh
em_ymd em_ymd
dw_calendar dw_calendar
end type
global u_plan4u2sc u_plan4u2sc

type variables
Private:
	String	is_ymd	= ''
	String	ToolTipDatadwo	= ''	//ToolTipData
end variables

forward prototypes
public subroutine of_init ()
end prototypes

public subroutine of_init ();
end subroutine

on u_plan4u2sc.create
int iCurrent
call super::create
this.uo_title=create uo_title
this.p_memo=create p_memo
this.p_refresh=create p_refresh
this.em_ymd=create em_ymd
this.dw_calendar=create dw_calendar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_title
this.Control[iCurrent+2]=this.p_memo
this.Control[iCurrent+3]=this.p_refresh
this.Control[iCurrent+4]=this.em_ymd
this.Control[iCurrent+5]=this.dw_calendar
end on

on u_plan4u2sc.destroy
call super::destroy
destroy(this.uo_title)
destroy(this.p_memo)
destroy(this.p_refresh)
destroy(this.em_ymd)
destroy(this.dw_calendar)
end on

event constructor;call super::constructor;datetime		ldt_date

ldt_date = fw_f_getymdhh24miss4d()
em_ymd.text = String( ldt_date, 'yyyy.mm' )

em_ymd.PostEvent('Modified')
end event

type uo_title from fw_u_dw2title within u_plan4u2sc
integer y = 12
integer taborder = 20
string istitletext = "schedule"
end type

on uo_title.destroy
call fw_u_dw2title::destroy
end on

type p_memo from pf_u_imagebutton within u_plan4u2sc
integer x = 1870
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\menu_save.jpg"
end type

event clicked;call super::clicked;/* delaytime start; windelaytime init */
//gnv_vari.windelaytime = 0 
//gnv_vari.windelaytime = cpu()

fw_f_setopensheet('00028')
end event

type p_refresh from pf_u_imagebutton within u_plan4u2sc
integer x = 1751
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_reset.jpg"
end type

event clicked;call super::clicked;dw_calendar.reset()
dw_calendar.SetTransObject( sqlca )
dw_calendar.retrieve(gnv_vari.is_sys_id, is_ymd, gaa.login)
end event

type em_ymd from pf_u_editmask within u_plan4u2sc
integer x = 1381
integer width = 357
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 19737901
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean spin = true
double increment = 1
string minmax = "2000~~3000"
end type

event getfocus;call super::getfocus;This.SelectText(6,2)
end event

event modified;call super::modified;is_ymd = em_ymd.text
is_ymd = fw_f_replaceall(is_ymd, '.', '')

p_refresh.PostEvent("Clicked")
end event

type dw_calendar from u_dw within u_plan4u2sc
integer y = 100
integer width = 2021
integer height = 1284
integer taborder = 10
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_u_plan4u2sc_1"
boolean ibdesign4role = false
boolean setfocusdw = false
boolean setedittoken = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
boolean ibsetlist4mouseovercolor = false
boolean eb_fund_default_change = false
boolean eb_range_delcopy = false
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;If rowcount < 6 Then Insertrow(0)
end event

event mousemove;string		ls_obj, ls_objdesc, ls_rowdata, ls_temp
string		ls_syntax, ls_errmsg

ls_obj = fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj = 'datawindow' Then Return
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
		ls_syntax = fw_f_replaceall(ls_syntax, "tooltip.tip='?", "tooltip.tip=' ")
		ls_errmsg	= This.Modify(ls_syntax)
		If fw_f_nvls(ls_errmsg, '') <> '' then
			Messagebox('User schedule Tooltip enabled 1 error', ls_errmsg)
			Return
		end If
		ToolTipDatadwo = ls_obj + 'data' + string(row)
end choose


end event

event rowfocuschanged;//
end event

event buttonup;//
end event

event doubleclicked;//
end event

event rbuttondown;//
end event

