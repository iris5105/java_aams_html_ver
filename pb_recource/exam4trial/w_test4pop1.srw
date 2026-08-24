forward
global type w_test4pop1 from w_response1st5ncn
end type
type cb_1 from pf_u_commandbutton within w_test4pop1
end type
type dw_1 from fw_u_dwo within w_test4pop1
end type
type st_emday1 from pf_u_statictext within w_test4pop1
end type
type em_day1 from pf_u_editmask within w_test4pop1
end type
type p_emday1 from pf_u_picture within w_test4pop1
end type
type dw_cond from fw_u_dwo within w_test4pop1
end type
end forward

global type w_test4pop1 from w_response1st5ncn
cb_1 cb_1
dw_1 dw_1
st_emday1 st_emday1
em_day1 em_day1
p_emday1 p_emday1
dw_cond dw_cond
end type
global w_test4pop1 w_test4pop1

on w_test4pop1.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.st_emday1=create st_emday1
this.em_day1=create em_day1
this.p_emday1=create p_emday1
this.dw_cond=create dw_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_emday1
this.Control[iCurrent+4]=this.em_day1
this.Control[iCurrent+5]=this.p_emday1
this.Control[iCurrent+6]=this.dw_cond
end on

on w_test4pop1.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.st_emday1)
destroy(this.em_day1)
destroy(this.p_emday1)
destroy(this.dw_cond)
end on

event wue_postopen;call super::wue_postopen;dw_cond.insertrow(0)
dw_1.insertrow(0)
end event

type ln_tempbutton from w_response1st5ncn`ln_tempbutton within w_test4pop1
end type

type ln_tempstart from w_response1st5ncn`ln_tempstart within w_test4pop1
end type

type ln_templeft from w_response1st5ncn`ln_templeft within w_test4pop1
end type

type ln_cond_start from w_response1st5ncn`ln_cond_start within w_test4pop1
end type

type ln_tempright from w_response1st5ncn`ln_tempright within w_test4pop1
end type

type ln_cond1_yline from w_response1st5ncn`ln_cond1_yline within w_test4pop1
end type

type ln_dw1_yline from w_response1st5ncn`ln_dw1_yline within w_test4pop1
end type

type p_print from w_response1st5ncn`p_print within w_test4pop1
integer x = 110
end type

type p_delete from w_response1st5ncn`p_delete within w_test4pop1
integer x = 110
end type

type p_new from w_response1st5ncn`p_new within w_test4pop1
integer x = 110
end type

type p_close from w_response1st5ncn`p_close within w_test4pop1
boolean visible = true
end type

type p_cancel from w_response1st5ncn`p_cancel within w_test4pop1
boolean visible = true
integer x = 3099
end type

event p_cancel::clicked;call super::clicked;messagebox('', 'cancel')
end event

type p_ok from w_response1st5ncn`p_ok within w_test4pop1
boolean visible = true
integer x = 2857
boolean ibdefault = true
end type

event p_ok::clicked;call super::clicked;messagebox('', 'default')
end event

type p_preview from w_response1st5ncn`p_preview within w_test4pop1
integer x = 110
end type

type p_update from w_response1st5ncn`p_update within w_test4pop1
integer x = 110
end type

type p_excel from w_response1st5ncn`p_excel within w_test4pop1
end type

type p_clear from w_response1st5ncn`p_clear within w_test4pop1
integer x = 110
end type

type p_modify from w_response1st5ncn`p_modify within w_test4pop1
integer x = 110
end type

type p_retrieve from w_response1st5ncn`p_retrieve within w_test4pop1
end type

type p_tempsave from w_response1st5ncn`p_tempsave within w_test4pop1
integer x = 110
end type

type p_collect from w_response1st5ncn`p_collect within w_test4pop1
integer x = 110
end type

type p_select from w_response1st5ncn`p_select within w_test4pop1
integer x = 110
end type

type p_find from w_response1st5ncn`p_find within w_test4pop1
end type

type p_execu from w_response1st5ncn`p_execu within w_test4pop1
end type

type p_enroll from w_response1st5ncn`p_enroll within w_test4pop1
end type

type cb_1 from pf_u_commandbutton within w_test4pop1
integer x = 2199
integer y = 28
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "닫기"
end type

event clicked;call super::clicked;close(parent)
end event

type dw_1 from fw_u_dwo within w_test4pop1
integer x = 50
integer y = 500
integer width = 2405
integer height = 900
integer taborder = 40
boolean bringtotop = true
string title = "안녕하세요"
string dataobject = "d_exam4all1_1"
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

event doubleclicked;call super::doubleclicked;Choose Case dwo.name
	Case 'tmp_no'
		fw_f_calendardwo4day1(iw_parent, This, dwo, row)
End Choose
end event

type st_emday1 from pf_u_statictext within w_test4pop1
integer x = 2469
integer y = 204
integer width = 283
integer height = 84
boolean bringtotop = true
string text = "일 선 택"
alignment alignment = right!
boolean setcondcolor = true
end type

type em_day1 from pf_u_editmask within w_test4pop1
integer x = 2766
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

type p_emday1 from pf_u_picture within w_test4pop1
integer x = 3173
integer y = 196
integer width = 105
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\ib_calendar.jpg"
end type

event clicked;call super::clicked;messagebox('', iw_parent.classname())
fw_f_calendarem4day1(iw_parent, em_day1)
end event

type dw_cond from fw_u_dwo within w_test4pop1
integer x = 50
integer y = 156
integer width = 2373
integer height = 276
integer taborder = 130
boolean bringtotop = true
string dataobject = "d_exam4calendar1_c1"
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

event clicked;call super::clicked;Choose Case dwo.name
	Case 'p_day1'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.dt_date, row)
	Case 'p_day2'
		fw_f_calendardwo4day2(iw_parent, This, This.Object.f_dt, This.Object.t_dt, row)
	Case 'p_month1'
		fw_f_calendardwo4mon1(iw_parent, This, This.Object.dt_month, row)
	Case 'p_month2'
		fw_f_calendardwo4mon2(iw_parent, This, This.Object.f_mon, This.Object.t_mon, row)
End Choose
end event

