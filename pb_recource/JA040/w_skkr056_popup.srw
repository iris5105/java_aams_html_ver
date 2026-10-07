forward
global type w_skkr056_popup from w_response_s
end type
end forward

global type w_skkr056_popup from w_response_s
integer width = 5486
integer height = 2656
string title = "  손익차등 펀드현황"
end type
global w_skkr056_popup w_skkr056_popup

type variables
str_parameter  istr
end variables

on w_skkr056_popup.create
call super::create
end on

on w_skkr056_popup.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;istr = Message.PowerObjectParm
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_skkr056_popup
end type

type ln_tempstart from w_response_s`ln_tempstart within w_skkr056_popup
end type

type ln_templeft from w_response_s`ln_templeft within w_skkr056_popup
end type

type ln_cond_start from w_response_s`ln_cond_start within w_skkr056_popup
end type

type ln_tempright from w_response_s`ln_tempright within w_skkr056_popup
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_skkr056_popup
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_skkr056_popup
end type

type dw_view from w_response_s`dw_view within w_skkr056_popup
integer width = 5381
integer height = 2500
string dataobject = "d_skkr056_popup"
end type

event dw_view::ue_retrieve;call super::ue_retrieve;retrieve (istr.str[1], istr.dt[1])
end event

event dw_view::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'above_gb', '', '', 1, '')
f_dddwctl (THIS, 'above_yn', '', '', 1, '')
end event

