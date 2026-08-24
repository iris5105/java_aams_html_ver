forward
global type w_ja010q from wt_vertole
end type
end forward

global type w_ja010q from wt_vertole
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
string is_init_value = "1"
end type
global w_ja010q w_ja010q

type variables

end variables

event wue_retrieve;call super::wue_retrieve;is_find = "corp_gr='" + gaa.corp_gr + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_ja010q.create
int iCurrent
call super::create
end on

on w_ja010q.destroy
call super::destroy
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

SELECT JUNYONG_YMD
  INTO :ldt
  FROM SZX0AA aa
 WHERE aa.corp_gr = :gaa.corp_gr;

dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)

end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja010q
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja010q
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja010q
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja010q
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja010q
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja010q
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja010q
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja010q
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja010q
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja010q
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja010q
end type

type uo_navi from wt_vertole`uo_navi within w_ja010q
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja010q
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja010q
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja010q
end type

type p_close from wt_vertole`p_close within w_ja010q
end type

type p_excel from wt_vertole`p_excel within w_ja010q
end type

type p_print from wt_vertole`p_print within w_ja010q
end type

type p_delete from wt_vertole`p_delete within w_ja010q
end type

type p_update from wt_vertole`p_update within w_ja010q
end type

type p_input from wt_vertole`p_input within w_ja010q
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja010q
end type

event p_retrieve::clicked;call super::clicked;dw_c.Enabled = true
dw_List.uf_protect (0, dw_List.ia_protect [1])

end event

type p_clear from wt_vertole`p_clear within w_ja010q
end type

type p_copy from wt_vertole`p_copy within w_ja010q
end type

type dw_c from wt_vertole`dw_c within w_ja010q
boolean enabled = false
string title = "조회기준일"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertole`btn_update within w_ja010q
end type

type st_count from wt_vertole`st_count within w_ja010q
end type

type dw_list from wt_vertole`dw_list within w_ja010q
boolean visible = true
string dataobject = "d_ja010q"
boolean hscrollbar = true
boolean eb_null_line = false
end type

type st_move from wt_vertole`st_move within w_ja010q
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja010q
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;DATETIME ldt

IF isNull (dw_list.object.haeji_ymd [row])   Then
   IF dw_list.object.af_gyul_ymd [row]<dw_c.object.ymd [1]  Then
       ldt = dw_list.object.af_gyul_ymd [row]
    ELSE
       ldt = dw_c.object.ymd [1]
    END IF
ELSE
   ldt = dw_list.object.af [row]
END IF

UF_FILEOPEN ('rd_ja010q.mrd', &
             'fund_cd[' + STRING(dw_list.object.fund_cd [row]) + '] ' + &
             'ymd[' + STRING(ldt, 'yyyymmdd') + '] ' + &
             'bf[' + STRING(dw_list.object.bf_start [row], 'yyyy.mm.dd') + '] ' + &
             'af[' + STRING(ldt, 'yyyy.mm.dd') + ']')
end event

type rb_onepage from wt_vertole`rb_onepage within w_ja010q
end type

