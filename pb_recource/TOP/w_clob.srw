forward
global type w_clob from w_response1st
end type
type mle_1 from u_mle within w_clob
end type
type rte_function from pf_u_richtextedit within w_clob
end type
type cb_cancel from pf_u_commandbutton within w_clob
end type
type cb_ok from pf_u_commandbutton within w_clob
end type
end forward

global type w_clob from w_response1st
integer x = 823
integer y = 360
integer width = 3621
integer height = 2476
string title = "상세입력"
boolean controlmenu = false
string icon = "Asterisk!"
boolean righttoleft = true
mle_1 mle_1
rte_function rte_function
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_clob w_clob

type variables

end variables

on w_clob.create
int iCurrent
call super::create
this.mle_1=create mle_1
this.rte_function=create rte_function
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.rte_function
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
end on

on w_clob.destroy
call super::destroy
destroy(this.mle_1)
destroy(this.rte_function)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;call super::open;STRING	la_data [], ls_new = ''

LONG	ll, ll_data

IF f_null (Message.StringParm)   Then
   mle_1.ReplaceText ('■ ')
Else
   IF POS (Message.StringParm,'~r~n')>0   Then
      mle_1.ReplaceText (Message.StringParm)
   Else
      ll_data = f_get_array (Message.StringParm, '~n', la_data)
      FOR  ll = 1  TO  ll_data
         ls_new	+= la_data [ll] + '~r~n'
      NEXT
      mle_1.ReplaceText (ls_new)
   End IF
End IF

mle_1.POST SetFocus ()

f_memo ('function history', rte_function)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_clob
end type

type ln_tempstart from w_response1st`ln_tempstart within w_clob
end type

type ln_templeft from w_response1st`ln_templeft within w_clob
end type

type ln_cond_start from w_response1st`ln_cond_start within w_clob
end type

type ln_tempright from w_response1st`ln_tempright within w_clob
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_clob
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_clob
end type

type mle_1 from u_mle within w_clob
integer x = 50
integer y = 24
integer width = 3520
integer height = 2228
integer taborder = 10
integer textsize = -11
boolean enabled = true
borderstyle borderstyle = stylebox!
end type

event getfocus;//
end event

type rte_function from pf_u_richtextedit within w_clob
integer x = 64
integer y = 2272
integer width = 2647
integer height = 80
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long init_backcolor = 553648127
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_cancel from pf_u_commandbutton within w_clob
integer x = 3127
integer y = 2268
integer width = 407
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "취 소"
end type

event clicked;call super::clicked;CloseWithReturn (Parent, 'cancel')
end event

type cb_ok from pf_u_commandbutton within w_clob
integer x = 2725
integer y = 2268
integer width = 407
integer taborder = 20
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저 장"
end type

event clicked;call super::clicked;CloseWithReturn (Parent, mle_1.Text)
end event

