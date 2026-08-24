forward
global type w_plan4u_pop from w_response_s
end type
type cb_1 from pf_u_commandbutton within w_plan4u_pop
end type
type cb_2 from pf_u_commandbutton within w_plan4u_pop
end type
type cb_3 from pf_u_commandbutton within w_plan4u_pop
end type
end forward

global type w_plan4u_pop from w_response_s
integer width = 2089
integer height = 804
boolean titlebar = false
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type
global w_plan4u_pop w_plan4u_pop

type variables
fw_s_home		istr_home
end variables

on w_plan4u_pop.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
end on

on w_plan4u_pop.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event wue_update;call super::wue_update;IF dw_view.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF

IF	dw_view.modifiedcount ()>0 OR dw_view.deletedcount ()>0	Then
	IF	dw_view.UPDATE ()=-1	Then	// update Error
		RETURN -1
	End IF
	CommitJ ()
	IF SQLCA.sqlcode ()<>0 THEN RETURN -1
End If

RETURN 1
end event

event wue_lastopen;call super::wue_lastopen;STRING	ls_ymd

LONG	ll_rtn

ls_ymd	= istr_home.ymd

ll_rtn = dw_view.retrieve(iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_sys_id, istr_home.str [1], ls_ymd)

If ll_rtn = 0 Then
	dw_view.event ue_insert(0)
End If
end event

event wue_postopen;call super::wue_postopen;istr_home = Message.PowerObjectParm
end event

event closequery;LONG	ll_rtn

IF dw_view.uf_ismodified() Then
	ll_rtn = messageBox ('INFO', '변경사항이 있습니다. 저장하시겠습니까?', Information!, YesNoCancel!)
	IF ll_rtn = 1 Then
		IF event wue_update() = -1 Then
			IF messageBox ('ERROR', '저장 중 오류가 발생하였습니다. 종료하시겠습니까?', Information!, OKCancel!) = 1 THEN RETURN 0 ELSE RETURN 1
		Else
			post closewithreturn (this, 'save')
			RETURN 1
		End IF
	ElseIF ll_rtn = 2 Then
		RETURN 0
	Else
		RETURN 1
	End IF
End IF

RETURN 0
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_plan4u_pop
end type

type ln_tempstart from w_response_s`ln_tempstart within w_plan4u_pop
end type

type ln_templeft from w_response_s`ln_templeft within w_plan4u_pop
end type

type ln_cond_start from w_response_s`ln_cond_start within w_plan4u_pop
end type

type ln_tempright from w_response_s`ln_tempright within w_plan4u_pop
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_plan4u_pop
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_plan4u_pop
end type

type dw_view from w_response_s`dw_view within w_plan4u_pop
integer width = 1979
integer height = 632
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_planuser_pop_1"
boolean hscrollbar = false
boolean vscrollbar = false
boolean applydesign = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
end type

event dw_view::updatestart;call super::updatestart;dwitemstatus	ldwstatus

LONG	ll_rcnt, ll_row

ll_rcnt = rowcount()

Do While ll_row <= ll_rcnt
	ll_row = getnextmodified(ll_row, Primary!)
	IF ll_row > 0 THEN
		ldwstatus = getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus
			Case NewModified!
				setItem(ll_row, 'sys_id',		gnv_vari.is_sys_id)
				setItem(ll_row, 'user_id',		istr_home.str [1])
				setItem(ll_row, 'ymd',			istr_home.ymd)
				setItem(ll_row, 'reg_id',		gnv_vari.is_user_id)
				setItem(ll_row, 'reg_dt',		fw_f_getymdhh24miss4s())
				setItem(ll_row, 'upd_id',		gnv_vari.is_user_id)
				setItem(ll_row, 'upd_dt',		fw_f_getymdhh24miss4s())
			Case DataModified!
				setItem(ll_row, 'upd_id',		gnv_vari.is_user_id)
				setItem(ll_row, 'upd_dt',		fw_f_getymdhh24miss4s())
		End CHoose
	ELSE
		ll_row = ll_rcnt + 1
	END IF
LOOP

end event

event oue_setupdatecheck;call super::oue_setupdatecheck;STRING	ls_temp

LONG	NbrRows, ll_row=0

NbrRows = RowCount()

If NbrRows = 0 Then
	messagebox( "ERROR", "No data available.")
	Return 1
End If


DO WHILE ll_row <= NbrRows
	ll_row = GetNextModIfied(ll_row, Primary!)
	
	If ll_row > 0 Then
		ls_temp = fw_f_nvls(getItemString(ll_Row, 'description'), '')
		If Len(ls_temp) = 0 Then
			Messagebox("ERROR", "Please Register Description!")
			Return -1
		End If
	Else
		ll_row = NbrRows + 1
	End If
Loop

Return 1
end event

event dw_view::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('ymd', string (istr_home.ymd))
uf_setcolumn ('corp_gr', iif (gaa.aams, '2200', gaa.corp_gr))
uf_setcolumn ('importance', '1')

RETURN 0
end event

type cb_1 from pf_u_commandbutton within w_plan4u_pop
integer x = 1161
integer y = 676
integer width = 283
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "저장"
end type

event clicked;call super::clicked;dw_view.AcceptText()
IF event wue_update()=1 THEN closewithreturn (parent, 'save')
end event

type cb_2 from pf_u_commandbutton within w_plan4u_pop
integer x = 1746
integer y = 676
integer width = 283
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "닫기"
end type

event clicked;call super::clicked;dw_view.AcceptText()
close (parent)
end event

type cb_3 from pf_u_commandbutton within w_plan4u_pop
integer x = 1454
integer y = 676
integer width = 283
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "삭제"
end type

event clicked;call super::clicked;dw_view.AcceptText()
dw_view.deleterow (1)
event wue_update()
closewithreturn (parent, 'save')
end event

