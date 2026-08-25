forward
global type w_response1st5cn from w_response1st
end type
type p_print from pf_u_imagebutton within w_response1st5cn
end type
type p_delete from pf_u_imagebutton within w_response1st5cn
end type
type p_new from pf_u_imagebutton within w_response1st5cn
end type
type p_close from pf_u_imagebutton within w_response1st5cn
end type
type p_cancel from pf_u_imagebutton within w_response1st5cn
end type
type p_ok from pf_u_imagebutton within w_response1st5cn
end type
type p_preview from pf_u_imagebutton within w_response1st5cn
end type
type p_update from pf_u_imagebutton within w_response1st5cn
end type
type p_excel from pf_u_imagebutton within w_response1st5cn
end type
type dw_cond from fw_u_dwo within w_response1st5cn
end type
type p_clear from pf_u_imagebutton within w_response1st5cn
end type
type p_modify from pf_u_imagebutton within w_response1st5cn
end type
type p_retrieve from pf_u_imagebutton within w_response1st5cn
end type
type p_tempsave from pf_u_imagebutton within w_response1st5cn
end type
type p_collect from pf_u_imagebutton within w_response1st5cn
end type
type p_select from pf_u_imagebutton within w_response1st5cn
end type
type p_find from pf_u_imagebutton within w_response1st5cn
end type
type p_execu from pf_u_imagebutton within w_response1st5cn
end type
type p_enroll from pf_u_imagebutton within w_response1st5cn
end type
end forward

global type w_response1st5cn from w_response1st
boolean controlmenu = false
event wue_ok ( )
p_print p_print
p_delete p_delete
p_new p_new
p_close p_close
p_cancel p_cancel
p_ok p_ok
p_preview p_preview
p_update p_update
p_excel p_excel
dw_cond dw_cond
p_clear p_clear
p_modify p_modify
p_retrieve p_retrieve
p_tempsave p_tempsave
p_collect p_collect
p_select p_select
p_find p_find
p_execu p_execu
p_enroll p_enroll
end type
global w_response1st5cn w_response1st5cn

type variables

end variables

forward prototypes
public function string of_thisname ()
end prototypes

public function string of_thisname ();return 'w_response1st1te'

end function

on w_response1st5cn.create
int iCurrent
call super::create
this.p_print=create p_print
this.p_delete=create p_delete
this.p_new=create p_new
this.p_close=create p_close
this.p_cancel=create p_cancel
this.p_ok=create p_ok
this.p_preview=create p_preview
this.p_update=create p_update
this.p_excel=create p_excel
this.dw_cond=create dw_cond
this.p_clear=create p_clear
this.p_modify=create p_modify
this.p_retrieve=create p_retrieve
this.p_tempsave=create p_tempsave
this.p_collect=create p_collect
this.p_select=create p_select
this.p_find=create p_find
this.p_execu=create p_execu
this.p_enroll=create p_enroll
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_print
this.Control[iCurrent+2]=this.p_delete
this.Control[iCurrent+3]=this.p_new
this.Control[iCurrent+4]=this.p_close
this.Control[iCurrent+5]=this.p_cancel
this.Control[iCurrent+6]=this.p_ok
this.Control[iCurrent+7]=this.p_preview
this.Control[iCurrent+8]=this.p_update
this.Control[iCurrent+9]=this.p_excel
this.Control[iCurrent+10]=this.dw_cond
this.Control[iCurrent+11]=this.p_clear
this.Control[iCurrent+12]=this.p_modify
this.Control[iCurrent+13]=this.p_retrieve
this.Control[iCurrent+14]=this.p_tempsave
this.Control[iCurrent+15]=this.p_collect
this.Control[iCurrent+16]=this.p_select
this.Control[iCurrent+17]=this.p_find
this.Control[iCurrent+18]=this.p_execu
this.Control[iCurrent+19]=this.p_enroll
end on

on w_response1st5cn.destroy
call super::destroy
destroy(this.p_print)
destroy(this.p_delete)
destroy(this.p_new)
destroy(this.p_close)
destroy(this.p_cancel)
destroy(this.p_ok)
destroy(this.p_preview)
destroy(this.p_update)
destroy(this.p_excel)
destroy(this.dw_cond)
destroy(this.p_clear)
destroy(this.p_modify)
destroy(this.p_retrieve)
destroy(this.p_tempsave)
destroy(this.p_collect)
destroy(this.p_select)
destroy(this.p_find)
destroy(this.p_execu)
destroy(this.p_enroll)
end on

type ln_tempbutton from w_response1st`ln_tempbutton within w_response1st5cn
end type

type ln_tempstart from w_response1st`ln_tempstart within w_response1st5cn
end type

type ln_templeft from w_response1st`ln_templeft within w_response1st5cn
end type

type ln_cond_start from w_response1st`ln_cond_start within w_response1st5cn
end type

type ln_tempright from w_response1st`ln_tempright within w_response1st5cn
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_response1st5cn
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_response1st5cn
end type

type p_print from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 2199
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_print.jpg"
end type

type p_delete from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 919
integer y = 28
integer width = 229
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_delete.jpg"
end type

type p_new from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 690
integer y = 28
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_add.jpg"
end type

type p_close from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 3342
integer y = 28
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;Close(Parent)
end event

type p_cancel from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 2985
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

type p_ok from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 2734
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

type p_preview from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 1957
integer y = 28
integer width = 302
integer height = 96
integer taborder = 50
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_compreview.jpg"
end type

type p_update from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 1586
integer y = 28
integer width = 229
integer height = 96
integer taborder = 50
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;Parent.PostEvent("wue_update")
end event

type p_excel from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 146
integer y = 28
integer width = 229
integer height = 96
integer taborder = 50
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_excel.jpg"
end type

type dw_cond from fw_u_dwo within w_response1st5cn
boolean visible = false
integer x = 50
integer y = 156
integer width = 82
integer height = 164
integer taborder = 20
string dataobject = "d_cond_dw1line"
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

type p_clear from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 297
integer y = 28
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_reset1.jpg"
end type

type p_modify from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 1408
integer y = 28
integer width = 229
integer height = 96
integer taborder = 50
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_revise.jpg"
end type

type p_retrieve from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer y = 28
integer width = 229
integer height = 96
integer taborder = 20
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_lookup.jpg"
end type

event clicked;call super::clicked;Parent.PostEvent("wue_retrieve2ready")
end event

type p_tempsave from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 1125
integer y = 28
integer width = 302
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_tempsave.jpg"
end type

type p_collect from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 1742
integer y = 28
integer width = 229
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_collect.jpg"
end type

type p_select from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 2432
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_select.jpg"
end type

type p_find from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 393
integer y = 28
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_find.jpg"
end type

type p_execu from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 475
integer y = 28
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_execu.jpg"
end type

type p_enroll from pf_u_imagebutton within w_response1st5cn
boolean visible = false
integer x = 562
integer y = 32
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_enrolment.jpg"
end type

