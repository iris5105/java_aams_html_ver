forward
global type u_ja010m1_t2 from utt_listole
end type
end forward

global type u_ja010m1_t2 from utt_listole
string text = "재계약공문"
end type
global u_ja010m1_t2 u_ja010m1_t2

type variables
DateTime	td_gyul_ymd

String	ts_fund_cd
end variables

on u_ja010m1_t2.create
call super::create
end on

on u_ja010m1_t2.destroy
call super::destroy
end on

type ln_temptop from utt_listole`ln_temptop within u_ja010m1_t2
end type

type ln_tempstart from utt_listole`ln_tempstart within u_ja010m1_t2
end type

type ln_templeft from utt_listole`ln_templeft within u_ja010m1_t2
end type

type ln_cond_start from utt_listole`ln_cond_start within u_ja010m1_t2
end type

type ln_tempright from utt_listole`ln_tempright within u_ja010m1_t2
end type

type ln_cond1_yline from utt_listole`ln_cond1_yline within u_ja010m1_t2
end type

type ln_dw1_yline from utt_listole`ln_dw1_yline within u_ja010m1_t2
end type

type ln_tempbutton from utt_listole`ln_tempbutton within u_ja010m1_t2
end type

type dw_pagelist from utt_listole`dw_pagelist within u_ja010m1_t2
end type

type ole_rd from utt_listole`ole_rd within u_ja010m1_t2
integer y = 24
integer height = 2816
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;uf_fileopen ('rd_ja010m12_' + gaa.corp_gr + '.mrd' &
								, 'ymd[' + string(td_gyul_ymd,'yyyy.mm.dd') + '] fund_cd[' + ts_fund_cd + ']' )

end event

type st_move from utt_listole`st_move within u_ja010m1_t2
end type

type rb_onepage from utt_listole`rb_onepage within u_ja010m1_t2
end type

