forward
global type w_exam4filter1 from w_window1st5ncn
end type
type dw_1 from fw_u_dwo within w_exam4filter1
end type
type dw_11 from fw_u_dwo within w_exam4filter1
end type
type uo_filter from fw_u_dw4filter within w_exam4filter1
end type
type cb_1 from commandbutton within w_exam4filter1
end type
type cb_2 from commandbutton within w_exam4filter1
end type
end forward

global type w_exam4filter1 from w_window1st5ncn
dw_1 dw_1
dw_11 dw_11
uo_filter uo_filter
cb_1 cb_1
cb_2 cb_2
end type
global w_exam4filter1 w_exam4filter1

on w_exam4filter1.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_11=create dw_11
this.uo_filter=create uo_filter
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_11
this.Control[iCurrent+3]=this.uo_filter
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
end on

on w_exam4filter1.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_11)
destroy(this.uo_filter)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event wue_retrieve;call super::wue_retrieve;dw_1.SetTransObject( sqlca )

dw_1.Retrieve()
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw (dw_1, 'cmofcd', {'*'})
end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_exam4filter1
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_exam4filter1
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_exam4filter1
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_exam4filter1
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_exam4filter1
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_exam4filter1
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_exam4filter1
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_exam4filter1
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_exam4filter1
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_exam4filter1
end type

type uo_navi from w_window1st5ncn`uo_navi within w_exam4filter1
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_exam4filter1
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_exam4filter1
end type

type p_close from w_window1st5ncn`p_close within w_exam4filter1
end type

type p_excel from w_window1st5ncn`p_excel within w_exam4filter1
end type

type p_print from w_window1st5ncn`p_print within w_exam4filter1
end type

type p_delete from w_window1st5ncn`p_delete within w_exam4filter1
end type

type p_update from w_window1st5ncn`p_update within w_exam4filter1
end type

type p_input from w_window1st5ncn`p_input within w_exam4filter1
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_exam4filter1
end type

type p_clear from w_window1st5ncn`p_clear within w_exam4filter1
end type

type dw_1 from fw_u_dwo within w_exam4filter1
integer x = 50
integer y = 424
integer width = 5381
integer height = 2340
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_exam4filter1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
end type

event constructor;call super::constructor;This.Insertrow( 0 )
end event

type dw_11 from fw_u_dwo within w_exam4filter1
integer x = 50
integer y = 156
integer width = 5381
integer height = 164
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_cond_dw1line"
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

event constructor;call super::constructor;Insertrow(1)
end event

type uo_filter from fw_u_dw4filter within w_exam4filter1
integer x = 1371
integer y = 300
integer taborder = 110
boolean bringtotop = true
string referenceobject = "dw_1"
string setfalsecolumn = "yearly"
end type

on uo_filter.destroy
call fw_u_dw4filter::destroy
end on

event oue_setdddw;call super::oue_setdddw;fw_f_setdddw (dw_filter, 'cmofcd', {'*'})
end event

type cb_1 from commandbutton within w_exam4filter1
integer x = 2231
integer width = 402
integer height = 120
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "none"
end type

event clicked;//dw_1.object.yearly.visible = false

dw_1.of_setcolumnvisible('yearly', 0)
end event

type cb_2 from commandbutton within w_exam4filter1
integer x = 1897
integer width = 279
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "none"
end type

event clicked;messagebox('1', dw_1.describe("sethpbcasc_stc.visible"))
messagebox('2', dw_1.describe("sethpbcasc_stc.x"))
messagebox('3', dw_1.describe("sethpbcasc_stc.y"))
end event

