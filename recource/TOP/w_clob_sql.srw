forward
global type w_clob_sql from w_response1st
end type
type mle_1 from pf_u_multilineedit within w_clob_sql
end type
end forward

global type w_clob_sql from w_response1st
integer x = 823
integer y = 360
integer width = 3616
integer height = 2524
string title = "상세조회"
string icon = "Asterisk!"
mle_1 mle_1
end type
global w_clob_sql w_clob_sql

type variables

end variables 

on w_clob_sql.create
int iCurrent
call super::create
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
end on

on w_clob_sql.destroy
call super::destroy
destroy(this.mle_1)
end on

event open;call super::open;STRING	ls_insert, ls_select, ls_onrecv, ls_rcv_table

TITLE = Message.StringParm

SELECT  sql_insert
      , sql_select
      , sql_onrecv
      , sql_rcv_table
  INTO  :ls_insert
      , :ls_select
      , :ls_onrecv
      , :ls_rcv_table
FROM    ksd_sql t1
WHERE   tr_code = :TITLE;

ls_insert	 = SQLCA.getitemstring (1)
ls_select	 = SQLCA.getitemstring (2)
ls_onrecv	 = SQLCA.getitemstring (3)
ls_rcv_table = SQLCA.getitemstring (4)

ls_select += " WHERE ymd='" + string (f_sysdate (''),'yyyy.mm.dd') + "' ORDER BY seq~r~n~r~n"

mle_1.ReplaceText (f_nvl (ls_insert,'')+'~r~n~r~n'+f_nvl (ls_select,'')+f_nvl (ls_onrecv,'')+'~r~n~r~n'+f_nvl (ls_rcv_table,''))
::Clipboard (f_nvl (ls_insert,'')+'~r~n~r~n'+f_nvl (ls_select,'')+f_nvl (ls_onrecv,'')+'~r~n~r~n'+f_nvl (ls_rcv_table,''))
end event

event key;IF key=KeyEscape! THEN CLOSE (THIS)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_clob_sql
end type

type ln_tempstart from w_response1st`ln_tempstart within w_clob_sql
end type

type ln_templeft from w_response1st`ln_templeft within w_clob_sql
end type

type ln_cond_start from w_response1st`ln_cond_start within w_clob_sql
end type

type ln_tempright from w_response1st`ln_tempright within w_clob_sql
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_clob_sql
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_clob_sql
end type

type mle_1 from pf_u_multilineedit within w_clob_sql
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

