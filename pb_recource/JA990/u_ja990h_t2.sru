forward
global type u_ja990h_t2 from utt_list
end type
end forward

global type u_ja990h_t2 from utt_list
string text = "채권종류"
end type
global u_ja990h_t2 u_ja990h_t2

on u_ja990h_t2.create
call super::create
end on

on u_ja990h_t2.destroy
call super::destroy
end on

type ln_temptop from utt_list`ln_temptop within u_ja990h_t2
end type

type ln_tempstart from utt_list`ln_tempstart within u_ja990h_t2
end type

type ln_templeft from utt_list`ln_templeft within u_ja990h_t2
end type

type ln_cond_start from utt_list`ln_cond_start within u_ja990h_t2
end type

type ln_tempright from utt_list`ln_tempright within u_ja990h_t2
end type

type ln_cond1_yline from utt_list`ln_cond1_yline within u_ja990h_t2
end type

type ln_dw1_yline from utt_list`ln_dw1_yline within u_ja990h_t2
end type

type ln_tempbutton from utt_list`ln_tempbutton within u_ja990h_t2
end type

type dw_pagelist from utt_list`dw_pagelist within u_ja990h_t2
string dataobject = "d_ja990h_t2"
end type

event dw_pagelist::ue_insertstart;call super::ue_insertstart;uf_setColumn ('bond_attr', iu_wpage.dw_c.object.dddw [1])
uf_setColumn ('bond_seq' , '1')

POST SetColumn ('bond_cd')

RETURN 0
end event

