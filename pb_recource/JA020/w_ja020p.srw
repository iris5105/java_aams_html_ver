forward
global type w_ja020p from wt_listole
end type
end forward

global type w_ja020p from wt_listole
end type
global w_ja020p w_ja020p

on w_ja020p.create
int iCurrent
call super::create
end on

on w_ja020p.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;DATETIME ldt
STRING	ls_se

SELECT LISTAGG (SERIES_GB || '-' || SERIES_NM, ', ')
     , :idt_workdate - 1
  INTO :ls_se
     , :ldt
  FROM SZX0SE t1
 WHERE corp_gr = :gaa.corp_gr
   AND dp_used = '1'
 ORDER BY SERIES_GB;

ls_se = SQLCA.getitemstring (1)

dw_c.modify ("tag_text.text='계좌관리그룹 - " + ls_se + "'")

dw_c.object.ymd [1] = SQLCA.getitemdatetime (2)
end event

type lb_dirlist from wt_listole`lb_dirlist within w_ja020p
end type

type ln_templeft from wt_listole`ln_templeft within w_ja020p
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja020p
end type

type ln_temptop from wt_listole`ln_temptop within w_ja020p
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja020p
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja020p
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja020p
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja020p
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja020p
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja020p
end type

type ln_tempright from wt_listole`ln_tempright within w_ja020p
end type

type uo_navi from wt_listole`uo_navi within w_ja020p
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja020p
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja020p
end type

type st_top_rect from wt_listole`st_top_rect within w_ja020p
end type

type p_close from wt_listole`p_close within w_ja020p
end type

type p_excel from wt_listole`p_excel within w_ja020p
end type

type p_print from wt_listole`p_print within w_ja020p
end type

type p_delete from wt_listole`p_delete within w_ja020p
end type

type p_update from wt_listole`p_update within w_ja020p
end type

type p_input from wt_listole`p_input within w_ja020p
end type

type p_retrieve from wt_listole`p_retrieve within w_ja020p
end type

type p_clear from wt_listole`p_clear within w_ja020p
end type

type p_copy from wt_listole`p_copy within w_ja020p
end type

type dw_c from wt_listole`dw_c within w_ja020p
string tag = "계좌관리그룹 -"
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listole`btn_update within w_ja020p
end type

type st_count from wt_listole`st_count within w_ja020p
end type

type dw_list from wt_listole`dw_list within w_ja020p
end type

type st_move from wt_listole`st_move within w_ja020p
end type

type ole_rd from wt_listole`ole_rd within w_ja020p
integer y = 348
integer height = 2416
boolean eb_openpagerd = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;ole_rd.uf_fileopen ('rd_ja020p.mrd', &
						  'ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + ']' )

end event

type rb_onepage from wt_listole`rb_onepage within w_ja020p
end type

