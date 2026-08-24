forward
global type w_error_list from w_response1st
end type
type cb_print from pf_u_commandbutton within w_error_list
end type
type cb_1 from pf_u_commandbutton within w_error_list
end type
type dw_1 from fw_u_dwo within w_error_list
end type
end forward

global type w_error_list from w_response1st
integer width = 3058
integer height = 1688
string title = "상세정보"
cb_print cb_print
cb_1 cb_1
dw_1 dw_1
end type
global w_error_list w_error_list

type variables

end variables

on w_error_list.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_error_list.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event wue_postopen;call super::wue_postopen;STRING	ls_corp_gr
ls_corp_gr = message.stringParm
dw_1.SetTRansObject (SQLCA)
dw_1.retrieve (ls_corp_gr)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_error_list
end type

type ln_tempstart from w_response1st`ln_tempstart within w_error_list
end type

type ln_templeft from w_response1st`ln_templeft within w_error_list
end type

type ln_cond_start from w_response1st`ln_cond_start within w_error_list
end type

type ln_tempright from w_response1st`ln_tempright within w_error_list
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_error_list
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_error_list
end type

type cb_print from pf_u_commandbutton within w_error_list
integer x = 2565
integer y = 1476
integer width = 393
integer height = 92
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "인쇄"
end type

event clicked;dw_1.Print ()
end event

type cb_1 from pf_u_commandbutton within w_error_list
integer x = 2167
integer y = 1476
integer width = 393
integer height = 92
integer taborder = 30
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "확인"
boolean default = true
end type

event clicked;CLOSE (Parent)
end event

type dw_1 from fw_u_dwo within w_error_list
integer x = 50
integer y = 24
integer width = 2930
integer height = 1428
integer taborder = 10
string dataobject = "d_error_list"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event retrieveend;STRING   ls_data = ''

LONG  ll

FOR  ll = 1  TO  rowcount
   ls_data += string (dw_1.object.err_msg [ll]) + '~r~n'
NEXT
::Clipboard (ls_data)
rollbackJ ()
end event

