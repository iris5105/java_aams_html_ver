forward
global type w_clob_query from w_response1st
end type
type mle_1 from pf_u_multilineedit within w_clob_query
end type
end forward

global type w_clob_query from w_response1st
integer x = 823
integer y = 360
integer width = 3625
integer height = 2512
string title = "상세조회"
string icon = "Asterisk!"
mle_1 mle_1
end type
global w_clob_query w_clob_query

type variables

end variables

on w_clob_query.create
int iCurrent
call super::create
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
end on

on w_clob_query.destroy
call super::destroy
destroy(this.mle_1)
end on

event open;call super::open;STRING	la_data [], ls_new = ''

LONG	ll, ll_data

IF POS (Message.StringParm,'~r~n')>0   Then
   mle_1.ReplaceText (Message.StringParm)
Else
   ll_data = f_get_array (Message.StringParm, '~n', la_data)
   FOR  ll = 1  TO  ll_data
      ls_new   += la_data [ll] + '~r~n'
   NEXT
   mle_1.ReplaceText (ls_new)
End IF
end event

event key;IF key=KeyEscape! THEN CLOSE (THIS)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_clob_query
end type

type ln_tempstart from w_response1st`ln_tempstart within w_clob_query
end type

type ln_templeft from w_response1st`ln_templeft within w_clob_query
end type

type ln_cond_start from w_response1st`ln_cond_start within w_clob_query
end type

type ln_tempright from w_response1st`ln_tempright within w_clob_query
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_clob_query
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_clob_query
end type

type mle_1 from pf_u_multilineedit within w_clob_query
event key pbm_keydown
integer x = 50
integer y = 24
integer width = 3520
integer height = 2380
integer taborder = 10
integer textsize = -11
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylebox!
end type

event key;IF key=KeyEscape! THEN CLOSE (Parent)
end event

