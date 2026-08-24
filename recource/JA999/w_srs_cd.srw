forward
global type w_srs_cd from wt_vertdetail
end type
end forward

global type w_srs_cd from wt_vertdetail
boolean eb_retrievewait = true
boolean ib_managedata = false
end type
global w_srs_cd w_srs_cd

type variables
STRING	is_call_put
end variables

on w_srs_cd.create
int iCurrent
call super::create
end on

on w_srs_cd.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (dw_c.object.rcd [1])
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_srs_cd
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_srs_cd
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_srs_cd
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_srs_cd
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_srs_cd
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_srs_cd
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_srs_cd
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_srs_cd
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_srs_cd
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_srs_cd
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_srs_cd
end type

type uo_navi from wt_vertdetail`uo_navi within w_srs_cd
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_srs_cd
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_srs_cd
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_srs_cd
end type

type p_close from wt_vertdetail`p_close within w_srs_cd
end type

type p_excel from wt_vertdetail`p_excel within w_srs_cd
end type

type p_print from wt_vertdetail`p_print within w_srs_cd
end type

type p_delete from wt_vertdetail`p_delete within w_srs_cd
end type

type p_update from wt_vertdetail`p_update within w_srs_cd
end type

type p_input from wt_vertdetail`p_input within w_srs_cd
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_srs_cd
end type

type p_clear from wt_vertdetail`p_clear within w_srs_cd
end type

type p_copy from wt_vertdetail`p_copy within w_srs_cd
end type

type dw_c from wt_vertdetail`dw_c within w_srs_cd
string title = "종가기준일@해외주식종목"
string dataobject = "dc_xx_ymd"
end type

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;rs_addrow = '%,전체,'
RETURN 51
end event

type btn_update from wt_vertdetail`btn_update within w_srs_cd
end type

type st_count from wt_vertdetail`st_count within w_srs_cd
end type

type dw_list from wt_vertdetail`dw_list within w_srs_cd
string dataobject = "d_srs_cd1"
string setlist4rowpointcolor = "gijun_stkprc_yn=Y=b"
boolean eb_range_delcopy = true
boolean eb_new_false = true
end type

event dw_list::ue_protect;call super::ue_protect;IF	GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified!	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event dw_list::ue_copyrow;call u_dw::ue_copyrow
RETURN 0
end event

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;STRING	ls_cd

ls_cd = Object.srs_cd [currentrow]

is_call_put = LEFT (MID (ls_cd, POS (ls_cd,' ')), 2)

RETURN 0
end event

event dw_list::itemchanged_next;call super::itemchanged_next;STRING	ls_jm_cd, ls_expr
DEC	ldc_stkprc
IF f_notnull (Object.expr_date [row]) AND f_num(Object.stkprc [row])>0  Then
   ls_expr    = Object.expr_date [row]
   ls_jm_cd   = Object.blbg_tckr [row]
   ldc_stkprc = Object.stkprc [row]

   SELECT CASE WHEN TO_CHAR (TO_DATE(:ls_expr,'yyyymmdd'),'w')='3' THEN ''
                                                                   ELSE TO_CHAR (TO_DATE (:ls_expr,'yyyymmdd'),'w')
          END || :ls_jm_cd || SRS_MM || SUBSTR (:ls_expr,3,2) || :is_call_put || F_N0(:ldc_stkprc,0,1)
     INTO :ls_jm_cd
     FROM SZX0YM t1
    WHERE t1.YMD_GB = 'M'
      AND t1.YMD_ID = SUBSTR(:ls_expr,5,2) ;

   Object.srs_cd [row] = SQLCA.GETITEMSTRING (1)
END IF
end event

event dw_list::ue_delete;call u_dw::ue_delete
RETURN 0
end event

type dw_detail from wt_vertdetail`dw_detail within w_srs_cd
string dataobject = "d_srs_cd2"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.srs_cd [iRow], idt_workdate)
end event

type st_move from wt_vertdetail`st_move within w_srs_cd
boolean leftmaxsizefixed = true
end type

