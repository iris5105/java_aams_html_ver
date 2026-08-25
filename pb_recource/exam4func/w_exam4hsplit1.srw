forward
global type w_exam4hsplit1 from w_window1st5ncn
end type
type dw_1 from fw_u_dwo within w_exam4hsplit1
end type
type uo_1 from fw_u_dw4hsplit within w_exam4hsplit1
end type
end forward

global type w_exam4hsplit1 from w_window1st5ncn
dw_1 dw_1
uo_1 uo_1
end type
global w_exam4hsplit1 w_exam4hsplit1

on w_exam4hsplit1.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.uo_1
end on

on w_exam4hsplit1.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.uo_1)
end on

event wue_retrieve;call super::wue_retrieve;dw_1.Retrieve()

//uo_hsplit.Post Event ue_dw_sync('shrtnm')
end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_exam4hsplit1
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_exam4hsplit1
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_exam4hsplit1
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_exam4hsplit1
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_exam4hsplit1
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_exam4hsplit1
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_exam4hsplit1
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_exam4hsplit1
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_exam4hsplit1
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_exam4hsplit1
end type

type uo_navi from w_window1st5ncn`uo_navi within w_exam4hsplit1
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_exam4hsplit1
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_exam4hsplit1
end type

type p_close from w_window1st5ncn`p_close within w_exam4hsplit1
end type

type p_excel from w_window1st5ncn`p_excel within w_exam4hsplit1
end type

type p_print from w_window1st5ncn`p_print within w_exam4hsplit1
end type

type p_delete from w_window1st5ncn`p_delete within w_exam4hsplit1
end type

type p_update from w_window1st5ncn`p_update within w_exam4hsplit1
end type

type p_input from w_window1st5ncn`p_input within w_exam4hsplit1
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_exam4hsplit1
end type

type p_clear from w_window1st5ncn`p_clear within w_exam4hsplit1
end type

type dw_1 from fw_u_dwo within w_exam4hsplit1
integer x = 50
integer y = 156
integer width = 5381
integer height = 2608
integer taborder = 80
string dataobject = "d_exam4hsplit1_1"
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean zoominout = true
boolean ibsetlist4hsplitscroll = true
end type

event constructor;call super::constructor;This.Insertrow( 0 )
end event

type uo_1 from fw_u_dw4hsplit within w_exam4hsplit1
integer x = 827
integer y = 312
integer taborder = 90
boolean bringtotop = true
boolean fixedtoright = true
string synchsplit4dw = "dw_1"
string synchsplit4obj = "shrtnm"
boolean objskip4column = true
end type

on uo_1.destroy
call fw_u_dw4hsplit::destroy
end on

