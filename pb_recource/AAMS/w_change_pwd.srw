forward
global type w_change_pwd from w_response_s
end type
type cb_ok from pf_u_commandbutton within w_change_pwd
end type
type cb_close from pf_u_commandbutton within w_change_pwd
end type
type cb_init from pf_u_commandbutton within w_change_pwd
end type
type st_msg from statictext within w_change_pwd
end type
end forward

global type w_change_pwd from w_response_s
integer width = 1938
integer height = 1120
string title = "비밀번호 변경(v.20250205)"
boolean controlmenu = false
boolean center = true
cb_ok cb_ok
cb_close cb_close
cb_init cb_init
st_msg st_msg
end type
global w_change_pwd w_change_pwd

type variables
str_parameter	sp
end variables

on w_change_pwd.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_close=create cb_close
this.cb_init=create cb_init
this.st_msg=create st_msg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_init
this.Control[iCurrent+4]=this.st_msg
end on

on w_change_pwd.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_close)
destroy(this.cb_init)
destroy(this.st_msg)
end on

event open;inv_menu = create n_menu
inv_menu.is_pgm_nm = this.title
iw_parent = This
if ibconfirmerrorlogs4stats = true then gnv_vari.iwerror2window = this
fw_f_getiehandlebyposition(This)
This.Post Event wue_postinst() // Call Post ancestor object clear 1st
This.Post Event wue_postopen() // Call Post Open Event

sp = message.powerobjectparm

IF	sp.bo [1]	Then
	cb_ok.visible = false
	cb_init.visible = true
	f_setprotect (dw_view, true, { 'current_pwd','chg_pwd','check_chg_pwd' })
End IF

IF	sp.str [3]='~r~n변경할 비밀번호를 입력하십시오.'	Then
	f_setprotect (dw_view, true, { 'current_pwd' })
End IF

IF	f_null (sp.str [3])	Then
	this.height = 852 + 100
Else
	st_msg.text = sp.str [3]
	this.height = 1040 + 100
End IF

dw_view.settransobject (sqlca)
dw_view.POST EVENT ue_Retrieve ()
dw_view.POST SetFocus ()

end event

event close;//
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_change_pwd
end type

type ln_tempstart from w_response_s`ln_tempstart within w_change_pwd
end type

type ln_templeft from w_response_s`ln_templeft within w_change_pwd
end type

type ln_cond_start from w_response_s`ln_cond_start within w_change_pwd
end type

type ln_tempright from w_response_s`ln_tempright within w_change_pwd
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_change_pwd
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_change_pwd
end type

type dw_view from w_response_s`dw_view within w_change_pwd
integer width = 1833
integer height = 676
string dataobject = "d_change_pwd"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
boolean applydesign = false
boolean eb_null_line = true
string is_encrypts = "enc_pw"
end type

event dw_view::ue_retrieve;call super::ue_retrieve;retrieve (sp.str [2])
end event

event dw_view::mousemove;//
end event

event dw_view::itemchanged;CHOOSE CASE dwo.name
	CASE 'current_pwd'
		IF Object.pw [1]<>data  Then
		   RETURN uf_itemerr (row, dwo.name, '기존 비밀번호가 맞지 않습니다.')
		End IF
END CHOOSE
end event

type cb_ok from pf_u_commandbutton within w_change_pwd
integer x = 1051
integer y = 716
integer width = 311
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string text = "변경"
end type

event clicked;call super::clicked;IF f_null (dw_view.object.chg_pwd [1]) OR f_null (dw_view.object.check_chg_pwd [1])	Then
	f_messageBox ('ERR', '변경 비밀번호가 입력되지 않았습니다.')
	RETURN
End IF

IF	st_msg.text='~r~n변경할 비밀번호를 입력하십시오.'	Then
	IF	dw_view.object.pw [1]<>dw_view.object.current_pwd [1]	Then
		f_messageBox ('ERR', '기존 비밀번호가 맞지 않습니다.')
		RETURN
	End IF
End IF

IF dw_view.object.chg_pwd [1]<>dw_view.object.check_chg_pwd [1]	Then
	f_messageBox ('ERR', '변경할 비밀번호와 비밀번호 확인이 맞지 않습니다.')
	RETURN
End IF
	
dw_view.object.pw [1]     = dw_view.object.chg_pwd [1]
dw_view.object.pw_cnt [1] = 0
dw_view.object.pw_chg [1] = f_sysdate ('')
dw_view.update ()
commitJ ()

f_messageBox ('INFO', '패스워드 변경이 완료되었습니다.')
CLOSE (parent)
end event

type cb_close from pf_u_commandbutton within w_change_pwd
integer x = 1376
integer y = 716
integer width = 311
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "닫기"
end type

event clicked;call super::clicked;CLOSE (parent)
end event

type cb_init from pf_u_commandbutton within w_change_pwd
boolean visible = false
integer x = 1051
integer y = 716
integer width = 311
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "초기화"
end type

event clicked;call super::clicked;STRING	ls_id

ls_id = dw_view.object.e_mail [1]
ls_id = LEFT (ls_id, POS (ls_id, '@') - 1)

dw_view.object.pw [1]     = ls_id
dw_view.object.pw_cnt [1] = 0
dw_view.object.pw_chg [1] = f_sysdate ('')
dw_view.update ()
commitJ ()

F_MESSAGEBOX ('INFO', '아이디( ' + ls_id + ' )로 패스워드가 초기화 되었습니다.')
CLOSE (parent)
end event

type st_msg from statictext within w_change_pwd
integer x = 46
integer y = 836
integer width = 1833
integer height = 156
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 255
long backcolor = 553648127
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

