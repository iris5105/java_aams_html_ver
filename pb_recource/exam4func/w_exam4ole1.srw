forward
global type w_exam4ole1 from w_window1st5ole
end type
type cb_1 from commandbutton within w_exam4ole1
end type
end forward

global type w_exam4ole1 from w_window1st5ole
cb_1 cb_1
end type
global w_exam4ole1 w_exam4ole1

on w_exam4ole1.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_exam4ole1.destroy
call super::destroy
destroy(this.cb_1)
end on

type ln_templeft from w_window1st5ole`ln_templeft within w_exam4ole1
end type

type ln_tempbuttom from w_window1st5ole`ln_tempbuttom within w_exam4ole1
end type

type ln_temptop from w_window1st5ole`ln_temptop within w_exam4ole1
end type

type ln_tempbutton from w_window1st5ole`ln_tempbutton within w_exam4ole1
end type

type ln_tempstart from w_window1st5ole`ln_tempstart within w_exam4ole1
end type

type ln_cond1_yline from w_window1st5ole`ln_cond1_yline within w_exam4ole1
end type

type ln_dw1_yline from w_window1st5ole`ln_dw1_yline within w_exam4ole1
end type

type ln_cond2_yline from w_window1st5ole`ln_cond2_yline within w_exam4ole1
end type

type ln_dw2_yline from w_window1st5ole`ln_dw2_yline within w_exam4ole1
end type

type ln_tempright from w_window1st5ole`ln_tempright within w_exam4ole1
end type

type uo_navi from w_window1st5ole`uo_navi within w_exam4ole1
end type

type ln_temptop_shadow from w_window1st5ole`ln_temptop_shadow within w_exam4ole1
end type

type st_windelaytime from w_window1st5ole`st_windelaytime within w_exam4ole1
end type

type p_close from w_window1st5ole`p_close within w_exam4ole1
end type

type p_excel from w_window1st5ole`p_excel within w_exam4ole1
end type

type p_print from w_window1st5ole`p_print within w_exam4ole1
end type

type p_delete from w_window1st5ole`p_delete within w_exam4ole1
end type

type p_update from w_window1st5ole`p_update within w_exam4ole1
end type

type p_input from w_window1st5ole`p_input within w_exam4ole1
end type

type p_retrieve from w_window1st5ole`p_retrieve within w_exam4ole1
end type

type p_clear from w_window1st5ole`p_clear within w_exam4ole1
end type

type ole_web from w_window1st5ole`ole_web within w_exam4ole1
integer height = 2472
end type

type p_refresh from w_window1st5ole`p_refresh within w_exam4ole1
end type

type cb_1 from commandbutton within w_exam4ole1
integer x = 1509
integer y = 172
integer width = 402
integer height = 120
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "capture"
end type

event clicked;string	ls_ymd
ls_ymd = fw_f_getymdhh24miss4s()

gnv_vari.iserror2path1 = gnv_extfunc.of_getsystemtemppath() + '\' + ls_ymd + '.png'
gnv_extfunc.biz_setcapture4pngw(handle(gw_mdi),  gnv_vari.iserror2path1)
end event

