forward
global type w_ja051a from wt_list
end type
end forward

global type w_ja051a from wt_list
boolean eb_direct_retrieve = true
end type
global w_ja051a w_ja051a

on w_ja051a.create
int iCurrent
call super::create
end on

on w_ja051a.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja051a
end type

type ln_templeft from wt_list`ln_templeft within w_ja051a
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja051a
end type

type ln_temptop from wt_list`ln_temptop within w_ja051a
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja051a
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja051a
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja051a
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja051a
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja051a
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja051a
end type

type ln_tempright from wt_list`ln_tempright within w_ja051a
end type

type uo_navi from wt_list`uo_navi within w_ja051a
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja051a
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja051a
end type

type p_close from wt_list`p_close within w_ja051a
end type

type p_excel from wt_list`p_excel within w_ja051a
end type

type p_print from wt_list`p_print within w_ja051a
end type

type p_delete from wt_list`p_delete within w_ja051a
end type

type p_update from wt_list`p_update within w_ja051a
end type

type p_input from wt_list`p_input within w_ja051a
end type

type p_retrieve from wt_list`p_retrieve within w_ja051a
end type

type p_clear from wt_list`p_clear within w_ja051a
end type

type p_copy from wt_list`p_copy within w_ja051a
end type

type dw_c from wt_list`dw_c within w_ja051a
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_list`btn_update within w_ja051a
end type

type st_count from wt_list`st_count within w_ja051a
end type

type dw_list from wt_list`dw_list within w_ja051a
integer y = 156
integer height = 2608
string dataobject = "d_ja051a1"
string setlist4fontpointcolor = "sr_flag=R=d"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('ftp_mode', 'ftp')
uf_setcolumn ('sr_flag', 'S')
uf_setcolumn ('ftp_port', '21')
uf_setcolumn ('ldir', '/data/icam/FTP_SEC')
uf_setcolumn ('rdir', '.')
uf_setcolumn ('lock_sec', '5')

setcolumn ('basenm')

RETURN 0
end event

