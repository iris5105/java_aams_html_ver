forward
global type u_ja020q from utt_listole
end type
end forward

global type u_ja020q from utt_listole
boolean tb_rowchangewait = true
boolean tbtabpageselected = false
end type
global u_ja020q u_ja020q

on u_ja020q.create
call super::create
end on

on u_ja020q.destroy
call super::destroy
end on

type ln_temptop from utt_listole`ln_temptop within u_ja020q
end type

type ln_tempstart from utt_listole`ln_tempstart within u_ja020q
end type

type ln_templeft from utt_listole`ln_templeft within u_ja020q
end type

type ln_cond_start from utt_listole`ln_cond_start within u_ja020q
end type

type ln_tempright from utt_listole`ln_tempright within u_ja020q
end type

type ln_cond1_yline from utt_listole`ln_cond1_yline within u_ja020q
end type

type ln_dw1_yline from utt_listole`ln_dw1_yline within u_ja020q
end type

type ln_tempbutton from utt_listole`ln_tempbutton within u_ja020q
end type

type dw_pagelist from utt_listole`dw_pagelist within u_ja020q
end type

type ole_rd from utt_listole`ole_rd within u_ja020q
integer y = 24
integer height = 2816
boolean eb_onepage = true
boolean eb_openpagerd = true
end type

type st_move from utt_listole`st_move within u_ja020q
end type

type rb_onepage from utt_listole`rb_onepage within u_ja020q
end type

