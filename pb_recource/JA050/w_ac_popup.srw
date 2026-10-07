forward
global type w_ac_popup from w_response_s
end type
end forward

global type w_ac_popup from w_response_s
integer width = 2793
integer height = 3292
string title = "Untitled"
boolean minbox = true
windowtype windowtype = popup!
boolean center = true
event ue_open ( )
end type
global w_ac_popup w_ac_popup

type variables
str_parameter  sp
end variables

event ue_open();STRING	ls_rt_key, ls_sr_err_msg, la_args[]

ls_rt_key = gaa.corp_gr + gnv_vari.is_user_id + f_sysdate_str ('hh24miss')

la_args[1] = gaa.corp_gr
la_args[2] = ls_rt_key
la_args[3] = string (sp.dt[1], 'yyyy.mm.dd')
la_args[4] = sp.str[1]
la_args[5] = '999'
SQLCA.SP_CALL( THIS, 'SR_AC_POPUP ( ?, ?, ?, ?, ? )', la_args[], ls_sr_err_msg )

dw_view.retrieve (ls_rt_key, '10101')
end event

event open;sp = Message.PowerObjectParm
TITLE = sp.str [1] + '(' + sp.str [2] + ') ' + string (sp.dt [1],'yyyy.mm.dd') + '일 분개장'

dw_view.SetTransObject (SQLCA)
dw_view.EVENT ue_dddw_retrieve ()

POST EVENT ue_open ()
end event

on w_ac_popup.create
call super::create
end on

on w_ac_popup.destroy
call super::destroy
end on

type ln_tempbutton from w_response_s`ln_tempbutton within w_ac_popup
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ac_popup
end type

type ln_templeft from w_response_s`ln_templeft within w_ac_popup
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ac_popup
end type

type ln_tempright from w_response_s`ln_tempright within w_ac_popup
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ac_popup
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ac_popup
end type

type dw_view from w_response_s`dw_view within w_ac_popup
integer width = 2693
integer height = 3148
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ac_popup"
end type

event dw_view::retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, FALSE)
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tr_cd', gaa.corp_gr, '', 1, '')
end event

