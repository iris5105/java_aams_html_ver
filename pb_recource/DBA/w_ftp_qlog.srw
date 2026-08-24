forward
global type w_ftp_qlog from w_response_s
end type
end forward

global type w_ftp_qlog from w_response_s
integer width = 5742
integer height = 2656
string title = "LOG 조회"
end type
global w_ftp_qlog w_ftp_qlog

type variables
str_parameter  istr
end variables

on w_ftp_qlog.create
call super::create
end on

on w_ftp_qlog.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;istr = Message.PowerObjectParm
end event

type ln_tempbutton from w_response_s`ln_tempbutton within w_ftp_qlog
end type

type ln_tempstart from w_response_s`ln_tempstart within w_ftp_qlog
end type

type ln_templeft from w_response_s`ln_templeft within w_ftp_qlog
end type

type ln_cond_start from w_response_s`ln_cond_start within w_ftp_qlog
end type

type ln_tempright from w_response_s`ln_tempright within w_ftp_qlog
end type

type ln_cond1_yline from w_response_s`ln_cond1_yline within w_ftp_qlog
end type

type ln_dw1_yline from w_response_s`ln_dw1_yline within w_ftp_qlog
end type

type dw_view from w_response_s`dw_view within w_ftp_qlog
integer width = 5637
integer height = 2500
string dataobject = "d_ftp_qlog"
boolean hscrollbar = false
end type

event dw_view::ue_retrieve;call super::ue_retrieve;parent.title = istr.str[3]
retrieve (istr.str[1], istr.dt[1], istr.str[2])
end event

