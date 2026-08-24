forward
global type u_ja990e_t3 from utt_list
end type
end forward

global type u_ja990e_t3 from utt_list
string text = "계정그룹"
end type
global u_ja990e_t3 u_ja990e_t3

type variables
STRING	is_tr_cd
end variables

on u_ja990e_t3.create
call super::create
end on

on u_ja990e_t3.destroy
call super::destroy
end on

type ln_temptop from utt_list`ln_temptop within u_ja990e_t3
end type

type ln_tempstart from utt_list`ln_tempstart within u_ja990e_t3
end type

type ln_templeft from utt_list`ln_templeft within u_ja990e_t3
end type

type ln_cond_start from utt_list`ln_cond_start within u_ja990e_t3
end type

type ln_tempright from utt_list`ln_tempright within u_ja990e_t3
end type

type ln_cond1_yline from utt_list`ln_cond1_yline within u_ja990e_t3
end type

type ln_dw1_yline from utt_list`ln_dw1_yline within u_ja990e_t3
end type

type ln_tempbutton from utt_list`ln_tempbutton within u_ja990e_t3
end type

type dw_pagelist from utt_list`dw_pagelist within u_ja990e_t3
string dataobject = "d_ja990e_t3"
boolean eb_null_line = false
string is_resize_column = "xx_jeokyo_cd"
end type

