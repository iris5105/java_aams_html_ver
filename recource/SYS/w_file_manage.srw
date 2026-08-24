forward
global type w_file_manage from w_response1st
end type
type uo_1 from u_file_manage within w_file_manage
end type
end forward

global type w_file_manage from w_response1st
integer width = 2917
integer height = 2208
string title = "첨부파일관리"
boolean controlmenu = false
uo_1 uo_1
end type
global w_file_manage w_file_manage

type variables
str_parameter sp
end variables

on w_file_manage.create
int iCurrent
call super::create
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_file_manage.destroy
call super::destroy
destroy(this.uo_1)
end on

event open;call super::open;sp = message.powerobjectparm
end event

event wue_lastopen;call super::wue_lastopen;uo_1.post event ue_init (sp.str [1], sp.str [2], sp.str [3])
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_file_manage
end type

type ln_tempstart from w_response1st`ln_tempstart within w_file_manage
end type

type ln_templeft from w_response1st`ln_templeft within w_file_manage
end type

type ln_cond_start from w_response1st`ln_cond_start within w_file_manage
end type

type ln_tempright from w_response1st`ln_tempright within w_file_manage
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_file_manage
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_file_manage
end type

type uo_1 from u_file_manage within w_file_manage
event destroy ( )
integer x = 27
integer height = 2096
integer taborder = 20
end type

on uo_1.destroy
call u_file_manage::destroy
end on

event ue_close;call super::ue_close;closewithreturn (parent, iif (uo_1.ib_changed, string (uo_1.dw_view.rowcount()), ''))
end event

