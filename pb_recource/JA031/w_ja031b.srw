forward
global type w_ja031b from wt_list
end type
end forward

global type w_ja031b from wt_list
boolean eb_direct_retrieve = true
end type
global w_ja031b w_ja031b

on w_ja031b.create
int iCurrent
call super::create
end on

on w_ja031b.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;STRING	ls_tr_co_cd, ls_tr_co_nm, ls_sqlsyntax

LONG	lRow, lRowCount, lR, ll

aDS_jTier	lds_jtier

lRowCount = dw_List.retrieve (gaa.corp_gr)

ls_sqlsyntax = "   SELECT  DISTINCT t1.tr_co_cd " &
             + "         , mm.tr_co_nm " &
             + "   FROM    ssm0km t1 " &
             + "         , szx0aa t2 " &
             + "         , ssx0kj t3 " &
             + "         , szx2mm mm " &
             + "   WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " &
             + "     AND   t2.corp_gr  = t1.corp_gr " &
             + "     AND   t2.hyun_ymd = t1.ymd " &
             + "     AND   t3.corp_gr  = t1.corp_gr " &
             + "     AND   t3.sj_cd    = t1.sj_cd " &
             + "     AND   t3.lsy_ymd  Between  trunc (t2.hyun_ymd,'mm') And LAST_DAY(t2.hyun_ymd) " &
             + "     AND   mm.corp_gr  = t1.corp_gr " &
             + "     AND   mm.tr_co_cd = t1.tr_co_cd "

lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  ll = 1  TO  lR
    ls_tr_co_cd = lds_jtier.getitemstring (ll, 1)
    ls_tr_co_nm = lds_jtier.getitemstring (ll, 2)

   lRow = dw_list.FIND ("tr_co_cd='" + ls_tr_co_cd + "'", 1, lRowCount)
   IF lRow=0   Then
      lRow = dw_list.EVENT ue_insert (0)
      dw_list.object.tr_co_cd [lRow] = ls_tr_co_cd
      dw_list.object.xx_tr_co_cd [lRow] = ls_tr_co_nm
   End IF
NEXT
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja031b
end type

type ln_templeft from wt_list`ln_templeft within w_ja031b
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja031b
end type

type ln_temptop from wt_list`ln_temptop within w_ja031b
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja031b
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja031b
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja031b
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja031b
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja031b
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja031b
end type

type ln_tempright from wt_list`ln_tempright within w_ja031b
end type

type uo_navi from wt_list`uo_navi within w_ja031b
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja031b
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja031b
end type

type p_close from wt_list`p_close within w_ja031b
end type

type p_excel from wt_list`p_excel within w_ja031b
end type

type p_print from wt_list`p_print within w_ja031b
end type

type p_delete from wt_list`p_delete within w_ja031b
end type

type p_update from wt_list`p_update within w_ja031b
end type

type p_input from wt_list`p_input within w_ja031b
end type

type p_retrieve from wt_list`p_retrieve within w_ja031b
end type

type p_clear from wt_list`p_clear within w_ja031b
end type

type p_copy from wt_list`p_copy within w_ja031b
end type

type dw_c from wt_list`dw_c within w_ja031b
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_list`btn_update within w_ja031b
end type

type st_count from wt_list`st_count within w_ja031b
end type

type dw_list from wt_list`dw_list within w_ja031b
integer y = 156
integer height = 2604
string dataobject = "d_ja031b1"
boolean eb_null_line = false
end type

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'susu_tr_co_cd', 'susu_tr_co_cd1'
      rs_where = "used='1' and tr_co_cd in (select tr_co_cd from ssm0ss where corp_gr=':corp_gr')"
END CHOOSE

RETURN 1
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('gr_cd', 'PP')

POST SetColumn ('tr_co_cd')

RETURN 0
end event

