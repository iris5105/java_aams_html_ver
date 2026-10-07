forward
global type fw_u_notice_check_t2 from utt_list
end type
end forward

global type fw_u_notice_check_t2 from utt_list
end type
global fw_u_notice_check_t2 fw_u_notice_check_t2

on fw_u_notice_check_t2.create
call super::create
end on

on fw_u_notice_check_t2.destroy
call super::destroy
end on

type ln_temptop from utt_list`ln_temptop within fw_u_notice_check_t2
end type

type ln_tempstart from utt_list`ln_tempstart within fw_u_notice_check_t2
end type

type ln_templeft from utt_list`ln_templeft within fw_u_notice_check_t2
end type

type ln_cond_start from utt_list`ln_cond_start within fw_u_notice_check_t2
end type

type ln_tempright from utt_list`ln_tempright within fw_u_notice_check_t2
end type

type ln_cond1_yline from utt_list`ln_cond1_yline within fw_u_notice_check_t2
end type

type ln_dw1_yline from utt_list`ln_dw1_yline within fw_u_notice_check_t2
end type

type ln_tempbutton from utt_list`ln_tempbutton within fw_u_notice_check_t2
end type

type dw_pagelist from utt_list`dw_pagelist within fw_u_notice_check_t2
string dataobject = "fw_d_board_doc_check_04"
boolean eb_null_line = false
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'corp_gr', gaa.corp_gr, '', 1, '')
end event

