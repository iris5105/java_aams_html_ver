forward
global type w_ja060c_popup from w_response_s
end type
end forward

global type w_ja060c_popup from w_response_s
integer width = 2130
integer height = 912
string title = "Untitled"
event ue_open ( )
end type
global w_ja060c_popup w_ja060c_popup

type variables
LONG	iRow

str_parameter  sp
end variables

event ue_open();dw_view.retrieve (gaa.corp_gr, sp.str [1], sp.dt [1], sp.dt [2], sp.dt [3], sp.dt [4], sp.dt [5], sp.dt [6])
end event

on w_ja060c_popup.create
call super::create
end on

on w_ja060c_popup.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;sp = Message.PowerObjectParm
TITLE = sp.str [1] + ' ' + sp.str [2] + ' 수익률 상세내역'

dw_view.event ue_dddw_retrieve ()
POST EVENT ue_open ()
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_ja060c_popup
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ja060c_popup
end type

type ln_templeft from w_response_s`ln_templeft within w_ja060c_popup
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ja060c_popup
end type

type ln_tempright from w_response_s`ln_tempright within w_ja060c_popup
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ja060c_popup
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ja060c_popup
end type

type dw_view from w_response_s`dw_view within w_ja060c_popup
integer width = 2043
integer height = 784
boolean bringtotop = true
string dataobject = "d_ja060c_p1"
boolean eb_range_delcopy = false
end type

event dw_view::retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, FALSE)
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event losefocus;call super::losefocus;//
end event

