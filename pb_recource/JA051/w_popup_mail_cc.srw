forward
global type w_popup_mail_cc from w_response1st
end type
type dw_1 from fw_u_dwo within w_popup_mail_cc
end type
type p_close from pf_u_imagebutton within w_popup_mail_cc
end type
end forward

global type w_popup_mail_cc from w_response1st
integer x = 837
integer y = 852
integer width = 1915
integer height = 2484
string title = "발송 할 메일주소 등록"
long backcolor = 16777215
dw_1 dw_1
p_close p_close
end type
global w_popup_mail_cc w_popup_mail_cc

type variables
str_parameter	istr

STRING	ia_cc[]
end variables

on w_popup_mail_cc.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.p_close=create p_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.p_close
end on

on w_popup_mail_cc.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.p_close)
end on

event open;call super::open;istr = Message.PowerObjectParm
f_get_array (istr.str[1], ',', ia_cc)
end event

event key;CHOOSE CASE key
   CASE KeyEscape!, KeyEnter!
      CLOSE (THIS)
END CHOOSE
end event

event close;call super::close;LONG	ll, ll_row

STRING	ls_name, ls_cc = ''

dw_1.accepttext ()

ll_row = dw_1.rowcount ()
FOR  ll = 1  TO  ll_row
	IF	f_notnull (dw_1.object.send_cc [ll])	Then
		IF	ls_cc=''	Then
			ls_cc = dw_1.object.send_cc [ll]
		Else
			ls_cc += ',' + dw_1.object.send_cc [ll]
		End IF
	End IF
NEXT
ls_cc = f_replace (ls_cc, '~r', '')
ls_cc = f_replace (ls_cc, '~n', '')
istr.str[1] = ls_cc
CloseWithReturn (THIS, istr)
end event

event wue_lastopen;call super::wue_lastopen;LONG	ll

dw_1.reset ()
FOR  ll = 1  TO  UPPERBOUND (ia_cc)
	dw_1.insertrow (0)
	dw_1.object.send_cc [ll] = TRIM (ia_cc [ll])
NEXT
dw_1.uf_setrow (1, true)
dw_1.of_dw2subbtn ({'p_excel','p_input','p_copy','p_delete'}, true)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_popup_mail_cc
end type

type ln_tempstart from w_response1st`ln_tempstart within w_popup_mail_cc
end type

type ln_templeft from w_response1st`ln_templeft within w_popup_mail_cc
end type

type ln_cond_start from w_response1st`ln_cond_start within w_popup_mail_cc
end type

type ln_tempright from w_response1st`ln_tempright within w_popup_mail_cc
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_popup_mail_cc
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_popup_mail_cc
end type

type dw_1 from fw_u_dwo within w_popup_mail_cc
integer x = 123
integer y = 128
integer width = 1673
integer height = 2192
integer taborder = 30
string dataobject = "d_mail_cc"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean setfocusdw = true
boolean setedittoken = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0011110000"
boolean ibsetlist4excelclip = true
end type

event oue_subbtn_delete;call super::oue_subbtn_delete;deleterow (getrow ())
end event

event oue_subbtn_input;call super::oue_subbtn_input;LONG	ll
ll = insertrow (0)
dw_1.post setfocus ()
post setrow (ll)
end event

event oue_subbtn_copy;call super::oue_subbtn_copy;LONG	ll_row, ll_copyrow

ll_row = getrow ()
ll_copyrow = rowcount() + 1

selectrow (ll_row, false)
RowsCopy (ll_row, ll_row,  Primary!, THIS, ll_copyrow, Primary!)

dw_1.post setfocus ()
post setrow (ll_copyrow)
end event

event oue_subbtn_excel;call super::oue_subbtn_excel;f_xlsx (THIS, '__' + dataobject, '발신참조주소 관리', '', '', '', '')
end event

type p_close from pf_u_imagebutton within w_popup_mail_cc
integer x = 123
integer y = 24
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;Close(Parent)
end event

