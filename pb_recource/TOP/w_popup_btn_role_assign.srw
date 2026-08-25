forward
global type w_popup_btn_role_assign from w_response_s
end type
type p_close from pf_u_imagebutton within w_popup_btn_role_assign
end type
type btn_update from pf_u_commandbutton within w_popup_btn_role_assign
end type
type p_update from pf_u_imagebutton within w_popup_btn_role_assign
end type
end forward

global type w_popup_btn_role_assign from w_response_s
string title = "버튼권한관리"
p_close p_close
btn_update btn_update
p_update p_update
end type
global w_popup_btn_role_assign w_popup_btn_role_assign

type variables
str_parameter  sp
LONG	il_view
end variables

on w_popup_btn_role_assign.create
int iCurrent
call super::create
this.p_close=create p_close
this.btn_update=create btn_update
this.p_update=create p_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_close
this.Control[iCurrent+2]=this.btn_update
this.Control[iCurrent+3]=this.p_update
end on

on w_popup_btn_role_assign.destroy
call super::destroy
destroy(this.p_close)
destroy(this.btn_update)
destroy(this.p_update)
end on

event open;call super::open;sp = Message.PowerObjectParm
end event

event wue_confirmupdate4close;IF	dw_view.AcceptText ()=-1       THEN RETURN 1
IF	dw_view.uf_isModified ()=FALSE THEN RETURN 0   //변경된 자료가 없다.

CHOOSE CASE f_messageBox ('W005', inv_menu.is_pgm_nm)
   CASE 1 // Update_OK
      IF	EVENT wue_update ()=-1 THEN RETURN 1
   CASE 2 // Update_PASS
      rollbackJ ()
	CASE 3
      RETURN 1
END CHOOSE

RETURN 0
end event

event wue_update;call super::wue_update;IF	dw_view.AcceptText ()=-1	Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	dw_view.uf_isModified ()	Then
   IF	dw_view.uf_update ()=FALSE THEN RETURN -1
   IF	gaa.admin THEN gw_mdi.setmicrohelp (string (Now ()) + ' -> ' + TAG + ' commit')
End IF
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_popup_btn_role_assign
end type

type ln_tempstart from w_response_s`ln_tempstart within w_popup_btn_role_assign
end type

type ln_templeft from w_response_s`ln_templeft within w_popup_btn_role_assign
end type

type ln_cond_start from w_response_s`ln_cond_start within w_popup_btn_role_assign
end type

type ln_tempright from w_response_s`ln_tempright within w_popup_btn_role_assign
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_popup_btn_role_assign
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_popup_btn_role_assign
end type

type dw_view from w_response_s`dw_view within w_popup_btn_role_assign
integer y = 156
integer height = 1864
string dataobject = "fw_d_btn_role_assign_1"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
string is_resize_column = "role_desc"
end type

event dw_view::ue_retrieve;call super::ue_retrieve;il_view = retrieve(gnv_vari.is_sys_id, sp.str [1])
btn_update.enabled = (il_view > 0)
end event

event dw_view::doubleclicked;call super::doubleclicked;LONG	ll

IF	dwo.name='role_no'	Then
	IF	f_messageBox ('I002', Object.role_nm [row] + ' 권한으로 맞추겠습니다.')=1	Then
		FOR  ll = 1  TO  rowcount ()
			IF	ll<>row	Then
				Object.cancel_auth_yn [ll] = Object.cancel_auth_yn [row]
				Object.retrieve_auth_yn [ll] = Object.retrieve_auth_yn [row]
				Object.input_auth_yn [ll] = Object.input_auth_yn [row]
				Object.ext1_auth_yn [ll] = Object.ext1_auth_yn [row]
				Object.update_auth_yn [ll] = Object.update_auth_yn [row]
				Object.delete_auth_yn [ll] = Object.delete_auth_yn [row]
				Object.print_auth_yn [ll] = Object.print_auth_yn [row]
				Object.excel_auth_yn [ll] = Object.excel_auth_yn [row]
			End IF
		NEXT
	End IF
End IF
end event

event dw_view::itemchanged_next;call super::itemchanged_next;IF RIGHT (name,3)='_yn' Then
   IF name='update_auth_yn'   Then
      Object.cancel_auth_yn [row] = Object.update_auth_yn [row]
      Object.input_auth_yn [row] = Object.update_auth_yn [row]
      Object.ext1_auth_yn [row] = Object.update_auth_yn [row]
      Object.delete_auth_yn [row] = Object.update_auth_yn [row]
   End IF

   // 공통버튼 사용여부(Y/N)을 설정합니다.
   STRING	ls_cancel_auth_yn, ls_retrieve_auth_yn, ls_input_auth_yn, ls_ext1_auth_yn
   STRING	ls_update_auth_yn, ls_delete_auth_yn, ls_print_auth_yn, ls_excel_auth_yn, ls_execute_auth_yn

   ls_cancel_auth_yn    = f_nvl(Object.cancel_auth_yn [row],'')
   ls_retrieve_auth_yn  = f_nvl(Object.retrieve_auth_yn [row],'')
   ls_input_auth_yn     = f_nvl(Object.input_auth_yn [row],'')
   ls_ext1_auth_yn      = f_nvl(Object.ext1_auth_yn [row],'')
   ls_update_auth_yn    = f_nvl(Object.update_auth_yn [row],'')
   ls_delete_auth_yn    = f_nvl(Object.delete_auth_yn [row],'')
   ls_print_auth_yn     = f_nvl(Object.print_auth_yn [row],'')
   ls_excel_auth_yn     = f_nvl(Object.excel_auth_yn [row],'')
   ls_execute_auth_yn   = f_nvl(Object.execute_auth_yn [row],'')
   Object.comm_btn_auth_yn [row] = 'Y'
End IF
end event

event dw_view::clicked;call super::clicked;LONG		ll
STRING	ls_col, ls_yn

IF	RIGHT (dwo.name,4)='yn_t'	Then
	ls_col = LEFT (dwo.name, LEN(string (dwo.name)) - 2)
	ls_yn = 'N'
	FOR  ll = 1  TO  rowcount ()
		IF	getitemstring (ll, ls_col)='Y'	Then
			ls_yn = 'Y'
			EXIT
		End IF
	NEXT
	FOR  ll = 1  TO  rowcount ()
		setitem (ll, ls_col, IIF (ls_yn='N','Y','N'))
		Object.comm_btn_auth_yn [ll] = 'Y'
	NEXT
End IF
end event

type p_close from pf_u_imagebutton within w_popup_btn_role_assign
integer x = 3342
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;Close(Parent)
end event

type btn_update from pf_u_commandbutton within w_popup_btn_role_assign
integer x = 2747
integer y = 28
integer width = 325
integer height = 100
integer taborder = 10
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "저장버튼"
end type

event clicked;call super::clicked;STRING	ls_input = 'Y', ls_ext1 = 'Y', ls_delete = 'Y'

LONG	ll

IF sp.str[3]='true'	Then
	IF	UPPERBOUND (sp.bo)=3	Then
		ls_input = IIF (sp.bo[1], 'N', 'Y')
		ls_ext1 = IIF (sp.bo[2], 'N', 'Y')
		ls_delete = IIF (sp.bo[3], 'N', 'Y')
	End IF
	FOR  ll = 1  TO  il_view
		dw_view.object.input_auth_yn [ll] = ls_input
		dw_view.object.ext1_auth_yn [ll] = ls_ext1
		dw_view.object.delete_auth_yn [ll] = ls_delete
		dw_view.object.update_auth_yn [ll] = 'Y'
	NEXT
Else
	FOR  ll = 1  TO  il_view
		dw_view.object.input_auth_yn [ll] = 'N'
		dw_view.object.ext1_auth_yn [ll] = 'N'
		dw_view.object.delete_auth_yn [ll] = 'N'
		dw_view.object.update_auth_yn [ll] = 'N'
	NEXT
End IF

messageBox ('note', '저장버튼정리')
end event

type p_update from pf_u_imagebutton within w_popup_btn_role_assign
integer x = 3104
integer y = 28
integer width = 229
integer height = 96
integer taborder = 6
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;event wue_update ()
p_close.post event clicked ()
end event

