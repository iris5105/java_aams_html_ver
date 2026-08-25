forward
global type w_exam4calendar1 from w_window1st5cn
end type
type em_day1 from pf_u_editmask within w_exam4calendar1
end type
type p_emday1 from pf_u_picture within w_exam4calendar1
end type
type em_month1 from pf_u_editmask within w_exam4calendar1
end type
type p_month1 from pf_u_picture within w_exam4calendar1
end type
type st_emday1 from pf_u_statictext within w_exam4calendar1
end type
type st_1 from pf_u_statictext within w_exam4calendar1
end type
type st_2 from pf_u_statictext within w_exam4calendar1
end type
type em_f_dt from pf_u_editmask within w_exam4calendar1
end type
type dw_1 from fw_u_dwo within w_exam4calendar1
end type
type em_t_dt from pf_u_editmask within w_exam4calendar1
end type
type st_mark1 from pf_u_statictext within w_exam4calendar1
end type
type st_3 from pf_u_statictext within w_exam4calendar1
end type
type st_4 from pf_u_statictext within w_exam4calendar1
end type
type em_f_mon from pf_u_editmask within w_exam4calendar1
end type
type em_t_mon from pf_u_editmask within w_exam4calendar1
end type
type p_month2 from pf_u_picture within w_exam4calendar1
end type
type p_emday2 from pf_u_picture within w_exam4calendar1
end type
end forward

global type w_exam4calendar1 from w_window1st5cn
string title = "전체기능구현"
em_day1 em_day1
p_emday1 p_emday1
em_month1 em_month1
p_month1 p_month1
st_emday1 st_emday1
st_1 st_1
st_2 st_2
em_f_dt em_f_dt
dw_1 dw_1
em_t_dt em_t_dt
st_mark1 st_mark1
st_3 st_3
st_4 st_4
em_f_mon em_f_mon
em_t_mon em_t_mon
p_month2 p_month2
p_emday2 p_emday2
end type
global w_exam4calendar1 w_exam4calendar1

on w_exam4calendar1.create
int iCurrent
call super::create
this.em_day1=create em_day1
this.p_emday1=create p_emday1
this.em_month1=create em_month1
this.p_month1=create p_month1
this.st_emday1=create st_emday1
this.st_1=create st_1
this.st_2=create st_2
this.em_f_dt=create em_f_dt
this.dw_1=create dw_1
this.em_t_dt=create em_t_dt
this.st_mark1=create st_mark1
this.st_3=create st_3
this.st_4=create st_4
this.em_f_mon=create em_f_mon
this.em_t_mon=create em_t_mon
this.p_month2=create p_month2
this.p_emday2=create p_emday2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_day1
this.Control[iCurrent+2]=this.p_emday1
this.Control[iCurrent+3]=this.em_month1
this.Control[iCurrent+4]=this.p_month1
this.Control[iCurrent+5]=this.st_emday1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.em_f_dt
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.em_t_dt
this.Control[iCurrent+11]=this.st_mark1
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.em_f_mon
this.Control[iCurrent+15]=this.em_t_mon
this.Control[iCurrent+16]=this.p_month2
this.Control[iCurrent+17]=this.p_emday2
end on

on w_exam4calendar1.destroy
call super::destroy
destroy(this.em_day1)
destroy(this.p_emday1)
destroy(this.em_month1)
destroy(this.p_month1)
destroy(this.st_emday1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_f_dt)
destroy(this.dw_1)
destroy(this.em_t_dt)
destroy(this.st_mark1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_f_mon)
destroy(this.em_t_mon)
destroy(this.p_month2)
destroy(this.p_emday2)
end on

event wue_postopen;call super::wue_postopen;dw_cond.InsertRow(0)
dw_cond.Object.dt_date[1] = string(today(),'yyyymmdd')
dw_cond.Object.f_dt[1] = string(today(),'yyyymmdd')
dw_cond.Object.t_dt[1] = string(today(),'yyyymmdd')

dw_cond.Object.dt_month[1] = string(today(),'yyyymm')
dw_cond.Object.f_mon[1] = string(today(),'yyyymm')
dw_cond.Object.t_mon[1] = string(today(),'yyyymm')

em_day1.text = string(today(),'yyyy.mm.dd')
em_f_dt.text = string(today(),'yyyy.mm.dd')
em_t_dt.text = string(today(),'yyyy.mm.dd')

em_month1.text = string(today(),'yyyy.mm')
em_f_mon.text = string(today(),'yyyy.mm')
em_t_mon.text = string(today(),'yyyy.mm')

dw_cond.SetFocus()
end event

event wue_retrieve;call super::wue_retrieve;dw_1.retrieve()
end event

event open;call super::open;//// Resize 등록
//This.of_setresize(True)
//inv_Resize.of_Register(p_close, "FixedToRight")
////inv_Resize.of_Register(ole_ie, "ScaleToRight&Bottom")
end event

event wue_update;call super::wue_update;Return of_update({dw_1})
end event

type ln_templeft from w_window1st5cn`ln_templeft within w_exam4calendar1
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_exam4calendar1
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_exam4calendar1
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_exam4calendar1
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_exam4calendar1
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_exam4calendar1
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_exam4calendar1
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_exam4calendar1
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_exam4calendar1
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_exam4calendar1
end type

type uo_navi from w_window1st5cn`uo_navi within w_exam4calendar1
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_exam4calendar1
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_exam4calendar1
end type

type p_close from w_window1st5cn`p_close within w_exam4calendar1
end type

type p_excel from w_window1st5cn`p_excel within w_exam4calendar1
boolean visible = true
end type

event p_excel::clicked;call super::clicked;//fw_s_xlsx	lstr_xlsx

//lstr_xlsx.w_obj	= iw_parent
//lstr_xlsx.pic_obj	= This
//lstr_xlsx.dw_obj	= idw_u

//OpenWithParm(fw_w_xlsx, lstr_xlsx)

///* 한컴 프린트 있을때는 사용가능 */
//window lwActiveSheet
//long llPrintJob
//
//lwActiveSheet = gw_mdi.GetActiveSheet()
//
//If IsValid(lwActiveSheet) Then
//	llPrintJob = PrintOpen( )
//	
//	Print (llPrintJob, lwActiveSheet.Title)
//	lwActiveSheet.Print (llPrintJob, 1000, PrintY(llPrintJob)+500, 9000, 6500)
//	
//	PrintClose(llPrintJob)
//End If
//
end event

type p_print from w_window1st5cn`p_print within w_exam4calendar1
boolean visible = true
end type

event p_print::clicked;call super::clicked;fw_s_parent	lstr_parent

lstr_parent.w_obj	= iw_parent
lstr_parent.dw_obj	= idw_u

OpenWithParm(fw_w_dw2preview, lstr_parent)
end event

type p_delete from w_window1st5cn`p_delete within w_exam4calendar1
end type

type p_update from w_window1st5cn`p_update within w_exam4calendar1
end type

type p_input from w_window1st5cn`p_input within w_exam4calendar1
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_exam4calendar1
end type

type p_clear from w_window1st5cn`p_clear within w_exam4calendar1
end type

type dw_cond from w_window1st5cn`dw_cond within w_exam4calendar1
integer height = 272
string dataobject = "d_exam4calendar1_c1"
boolean ibsettransobject = true
boolean setfocusdw = true
boolean setedittoken = true
boolean designcache = true
end type

event dw_cond::clicked;call super::clicked;Choose Case dwo.name
	Case 'p_day1'
		fw_f_calendardwo4day1(iw_iwindow, This, This.Object.dt_date, row)
	Case 'p_day2'
		fw_f_calendardwo4day2(iw_iwindow, This, This.Object.f_dt, This.Object.t_dt, row)
	Case 'p_month1'
		fw_f_calendardwo4mon1(iw_iwindow, This, This.Object.dt_month, row)
	Case 'p_month2'
		fw_f_calendardwo4mon2(iw_iwindow, This, This.Object.f_mon, This.Object.t_mon, row)
End Choose
end event

type em_day1 from pf_u_editmask within w_exam4calendar1
integer x = 2766
integer y = 196
integer height = 92
integer taborder = 110
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean ibbelong2cond = true
end type

type p_emday1 from pf_u_picture within w_exam4calendar1
integer x = 3173
integer y = 196
integer width = 105
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\ib_calendar.jpg"
end type

event clicked;call super::clicked;fw_f_calendarem4day1(iw_iwindow, em_day1)
end event

type em_month1 from pf_u_editmask within w_exam4calendar1
integer x = 2766
integer y = 300
integer height = 92
integer taborder = 120
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean ibbelong2cond = true
end type

type p_month1 from pf_u_picture within w_exam4calendar1
integer x = 3173
integer y = 300
integer width = 105
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\ib_calendar.jpg"
end type

event clicked;call super::clicked;fw_f_calendarem4mon1(iw_iwindow, em_month1)
end event

type st_emday1 from pf_u_statictext within w_exam4calendar1
integer x = 2469
integer y = 204
integer width = 283
integer height = 84
boolean bringtotop = true
string text = "일 선 택"
alignment alignment = right!
boolean setcondcolor = true
end type

type st_1 from pf_u_statictext within w_exam4calendar1
integer x = 2469
integer y = 308
integer width = 283
integer height = 84
boolean bringtotop = true
string text = "월 선 택"
alignment alignment = right!
boolean setcondcolor = true
end type

type st_2 from pf_u_statictext within w_exam4calendar1
integer x = 3328
integer y = 204
integer width = 283
integer height = 84
boolean bringtotop = true
string text = "일 기 간"
alignment alignment = right!
boolean setcondcolor = true
end type

type em_f_dt from pf_u_editmask within w_exam4calendar1
integer x = 3625
integer y = 196
integer height = 92
integer taborder = 120
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean ibbelong2cond = true
end type

type dw_1 from fw_u_dwo within w_exam4calendar1
integer x = 50
integer y = 456
integer width = 5381
integer height = 2308
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_exam4calendar1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
boolean settooltiphelp = true
boolean settooltipdata = true
boolean ibsetlist4clearselect = true
string setlist4rowpointcolor = "cmtotcd=SC1=a;cmtotcd=ZZZ=b;bonbcd=A2ZNB=c"
end type

type em_t_dt from pf_u_editmask within w_exam4calendar1
integer x = 4119
integer y = 196
integer height = 92
integer taborder = 130
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm.dd"
boolean ibbelong2cond = true
end type

type st_mark1 from pf_u_statictext within w_exam4calendar1
integer x = 4032
integer y = 196
integer width = 82
integer height = 92
boolean bringtotop = true
string text = "~~"
alignment alignment = center!
boolean setcondcolor = true
end type

type st_3 from pf_u_statictext within w_exam4calendar1
integer x = 3328
integer y = 308
integer width = 283
integer height = 84
boolean bringtotop = true
string text = "월 기 간"
alignment alignment = right!
boolean setcondcolor = true
end type

type st_4 from pf_u_statictext within w_exam4calendar1
integer x = 4032
integer y = 300
integer width = 82
integer height = 92
boolean bringtotop = true
string text = "~~"
alignment alignment = center!
boolean setcondcolor = true
end type

type em_f_mon from pf_u_editmask within w_exam4calendar1
integer x = 3625
integer y = 300
integer height = 92
integer taborder = 130
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean ibbelong2cond = true
end type

type em_t_mon from pf_u_editmask within w_exam4calendar1
integer x = 4119
integer y = 300
integer height = 92
integer taborder = 130
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean ibbelong2cond = true
end type

type p_month2 from pf_u_picture within w_exam4calendar1
integer x = 4526
integer y = 300
integer width = 105
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\ib_calendar.jpg"
end type

event clicked;call super::clicked;fw_f_calendarem4mon2(iw_iwindow, em_f_mon, em_t_mon)
end event

type p_emday2 from pf_u_picture within w_exam4calendar1
integer x = 4526
integer y = 196
integer width = 105
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\ib_calendar.jpg"
end type

event clicked;call super::clicked;fw_f_calendarem4day2(iw_iwindow, em_f_dt, em_t_dt)
end event

