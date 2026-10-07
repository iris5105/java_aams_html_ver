forward
global type u_ja990a_t3 from utt_list
end type
end forward

global type u_ja990a_t3 from utt_list
string text = "업종코드"
end type
global u_ja990a_t3 u_ja990a_t3

on u_ja990a_t3.create
call super::create
end on

on u_ja990a_t3.destroy
call super::destroy
end on

type ln_temptop from utt_list`ln_temptop within u_ja990a_t3
end type

type ln_tempstart from utt_list`ln_tempstart within u_ja990a_t3
end type

type ln_templeft from utt_list`ln_templeft within u_ja990a_t3
end type

type ln_cond_start from utt_list`ln_cond_start within u_ja990a_t3
end type

type ln_tempright from utt_list`ln_tempright within u_ja990a_t3
end type

type ln_cond1_yline from utt_list`ln_cond1_yline within u_ja990a_t3
end type

type ln_dw1_yline from utt_list`ln_dw1_yline within u_ja990a_t3
end type

type ln_tempbutton from utt_list`ln_tempbutton within u_ja990a_t3
end type

type dw_pagelist from utt_list`dw_pagelist within u_ja990a_t3
string dataobject = "d_ja990a_t3"
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'upj_gb', gaa.corp_gr, '', 1, '')

end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;IF AncestorReturnVALUE=1 THEN RETURN 1

POST SetColumn ('upj_cd')

RETURN 0
end event

event dw_pagelist::ue_copyrowset;call super::ue_copyrowset;Object.t_ymd [row - 1] = w_winpage.idt_workdate
Object.f_ymd [row] = w_winpage.idt_workdate
Object.bigo [row] = null_s
end event

