forward
global type w_popup_sjm0jj_history from w_response_s
end type
end forward

global type w_popup_sjm0jj_history from w_response_s
end type
global w_popup_sjm0jj_history w_popup_sjm0jj_history

on w_popup_sjm0jj_history.create
call super::create
end on

on w_popup_sjm0jj_history.destroy
call super::destroy
end on

type ln_tempbutton from w_response_s`ln_tempbutton within w_popup_sjm0jj_history
end type

type ln_tempstart from w_response_s`ln_tempstart within w_popup_sjm0jj_history
end type

type ln_templeft from w_response_s`ln_templeft within w_popup_sjm0jj_history
end type

type ln_cond_start from w_response_s`ln_cond_start within w_popup_sjm0jj_history
end type

type ln_tempright from w_response_s`ln_tempright within w_popup_sjm0jj_history
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_popup_sjm0jj_history
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_popup_sjm0jj_history
end type

type dw_view from w_response_s`dw_view within w_popup_sjm0jj_history
string dataobject = "d_sjm0jj_history"
end type

event dw_view::ue_retrieve;call super::ue_retrieve;retrieve (Message.StringParm)
end event

