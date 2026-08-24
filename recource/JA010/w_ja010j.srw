forward
global type w_ja010j from wt_vertole
end type
end forward

global type w_ja010j from wt_vertole
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_find = "corp_gr=~'~'"
end type
global w_ja010j w_ja010j

on w_ja010j.create
int iCurrent
call super::create
end on

on w_ja010j.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;DateTime ldt

ldt = f_gijunga_ymd ('-')

dw_c.object.tymd [1] = ldt

SELECT  ADD_MONTHS (:ldt, -3) + 1
  INTO  :ldt
FROM    dual;

ldt = SQLCA.getitemdatetime (1)

dw_c.object.fymd [1] = ldt
end event

event wue_retrieve;call super::wue_retrieve;is_find = "corp_gr='" + gaa.corp_gr + "'"
IF	gaa.aams	Then
	dw_list.retrieve ('%', dw_c.object.tymd [1])
Else
	dw_list.retrieve (gaa.corp_gr, dw_c.object.tymd [1])
End IF
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("corp_gr='" + gaa.corp_gr + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja010j
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja010j
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja010j
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja010j
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja010j
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja010j
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja010j
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja010j
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja010j
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja010j
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja010j
end type

type uo_navi from wt_vertole`uo_navi within w_ja010j
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja010j
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja010j
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja010j
end type

type p_close from wt_vertole`p_close within w_ja010j
end type

type p_excel from wt_vertole`p_excel within w_ja010j
end type

type p_print from wt_vertole`p_print within w_ja010j
end type

type p_delete from wt_vertole`p_delete within w_ja010j
end type

type p_update from wt_vertole`p_update within w_ja010j
end type

type p_input from wt_vertole`p_input within w_ja010j
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja010j
end type

type p_clear from wt_vertole`p_clear within w_ja010j
end type

type p_copy from wt_vertole`p_copy within w_ja010j
end type

type dw_c from wt_vertole`dw_c within w_ja010j
string title = "조회일자구간"
string dataobject = "dc_ftymd"
end type

type btn_update from wt_vertole`btn_update within w_ja010j
end type

type st_count from wt_vertole`st_count within w_ja010j
end type

type dw_list from wt_vertole`dw_list within w_ja010j
boolean visible = true
string dataobject = "d_ja010j1"
end type

type st_move from wt_vertole`st_move within w_ja010j
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja010j
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;CHOOSE CASE dw_list.object.fund_cd [row]
   CASE '0'
      UF_FILEOPEN ('rd_ja010j_0.mrd', 'corp_gr[' + dw_list.object.CORP_GR [row] + '] ' + &
                   'title[' + gaa.corp_nm + ' 3개월 평잔현황] ' + &
                   'fymd[' + STRING(dw_c.object.fymd [1], 'yyyy.mm.dd') + '] tymd[' + STRING(dw_c.object.tymd [1], 'yyyy.mm.dd') + '] ')
   CASE '1'
      IF gaa.CORP_GR='2202'   Then
         UF_FILEOPEN ('rd_ja010j_2202.mrd', 'corp_gr[' + dw_list.object.CORP_GR [row] + '] ' + &
                      'title[' + dw_list.object.fund_nm [row] + ' 3개월 평잔현황] ' + &
                      'fymd[' + STRING(dw_c.object.fymd [1], 'yyyy.mm.dd') + '] tymd[' + STRING(dw_c.object.tymd [1], 'yyyy.mm.dd') + '] ')
      ELSE
         UF_FILEOPEN ('rd_ja010j_1.mrd', 'corp_gr[' + dw_list.object.CORP_GR [row] + '] ' + &
                      'title[' + dw_list.object.fund_nm [row] + ' 3개월 평잔현황] ' + &
                      'fymd[' + STRING(dw_c.object.fymd [1], 'yyyy.mm.dd') + '] tymd[' + STRING(dw_c.object.tymd [1], 'yyyy.mm.dd') + '] ')
      END IF
   CASE '2'
      UF_FILEOPEN ('rd_ja010j_2.mrd', 'corp_gr[' + dw_list.object.CORP_GR [row] + '] ' + &
                   'title[' + dw_list.object.fund_nm [row] + ' 3개월 평잔현황] ' + &
                   'fymd[' + STRING(dw_c.object.fymd [1], 'yyyy.mm.dd') + '] tymd[' + STRING(dw_c.object.tymd [1], 'yyyy.mm.dd') + '] ')
   CASE ELSE
      UF_FILEOPEN ('rd_ja010j_6.mrd', 'corp_gr[' + dw_list.object.CORP_GR [row] + '] ' + &
                   'title[' + dw_list.object.fund_nm [row] + ' 3개월 평잔현황] ' + &
                   'fund_cd[' + dw_list.object.fund_cd [row] + '] ' + &
                   'fymd[' + STRING(dw_c.object.fymd [1], 'yyyy.mm.dd') + '] tymd[' + STRING(dw_c.object.tymd [1], 'yyyy.mm.dd') + '] ')
END CHOOSE
end event

type rb_onepage from wt_vertole`rb_onepage within w_ja010j
end type

