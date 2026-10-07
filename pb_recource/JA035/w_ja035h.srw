forward
global type w_ja035h from wt_list
end type
end forward

global type w_ja035h from wt_list
string is_date_nation = "US"
end type
global w_ja035h w_ja035h

on w_ja035h.create
int iCurrent
call super::create
end on

on w_ja035h.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035h
end type

type ln_templeft from wt_list`ln_templeft within w_ja035h
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035h
end type

type ln_temptop from wt_list`ln_temptop within w_ja035h
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035h
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035h
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035h
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035h
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035h
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035h
end type

type ln_tempright from wt_list`ln_tempright within w_ja035h
end type

type uo_navi from wt_list`uo_navi within w_ja035h
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035h
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035h
end type

type st_top_rect from wt_list`st_top_rect within w_ja035h
end type

type p_close from wt_list`p_close within w_ja035h
end type

type p_excel from wt_list`p_excel within w_ja035h
end type

type p_print from wt_list`p_print within w_ja035h
end type

type p_delete from wt_list`p_delete within w_ja035h
end type

type p_update from wt_list`p_update within w_ja035h
end type

type p_input from wt_list`p_input within w_ja035h
end type

type p_retrieve from wt_list`p_retrieve within w_ja035h
end type

type p_clear from wt_list`p_clear within w_ja035h
end type

type p_copy from wt_list`p_copy within w_ja035h
end type

type dw_c from wt_list`dw_c within w_ja035h
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    syt0ys t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.ymd     = :rs_ymd
  AND   t1.tr_cd   = 'E2P'
  AND   ROWNUM = 1;
  li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035h
end type

type st_count from wt_list`st_count within w_ja035h
end type

type dw_list from wt_list`dw_list within w_ja035h
string dataobject = "d_ja035h"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'tr_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      RETURN 1
   CASE 'yj_cd'
      rs_Where += "jm_cd in (select jm_cd from sym0yz where corp_gr='" + gaa.corp_gr + "' and ymd='" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and fund_cd='" + Object.fund_cd [getrow ()] + "')"
END CHOOSE
RETURN 2
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('ymd', string (idt_workdate))
uf_setcolumn ('tr_ymd', string (idt_workdate))
uf_setcolumn ('tr_cd', 'E2P')
uf_setcolumn ('tr_seq', '1')
uf_setcolumn ('gyulje_ymd', string(idt_workdate))
uf_setcolumn ('gyulje_gb', 'Y')
uf_setcolumn ('bs_type', '0')

setcolumn ('fund_cd')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_jm_cd, ls_cur

LONG	ll_f_value

CHOOSE CASE DWO.NAME
   CASE 'gyulje_aek'
      ls_cur                = Object.currency [row]
      Object.sury_aek [row] = dec (data)
       SELECT F_CURRENCY_RT(:gaa.CORP_GR,:idt_workdate,:ls_cur) INTO :ll_f_value FROM DUAL;
      ll_f_value                  = SQLCA.GETITEMNUMBER (1)
      Object.won_gyulje_aek [row] = TRUNCATE (dec (data) * ll_f_value,0)

   CASE 'yj_cd'
      ls_cur = Object.currency [row]

      SELECT currency
        INTO :ls_cur
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :ls_cur ;
      IF SQLCA.sqlcode ()=0 THEN ls_cur = SQLCA.GETITEMSTRING (1)

      SELECT jm_cd
        INTO :ls_jm_cd
        FROM SYM0YA t1
       WHERE t1.CORP_GR   = :gaa.CORP_GR
         AND t1.currency  = :ls_cur
         AND t1.gyulje_jm = 'Y' ;
      IF SQLCA.sqlcode ()=0 THEN Object.gyulje_jm_cd [row] = SQLCA.GETITEMSTRING (1)

      Object.trustee [row] = ls_cur + '01'

   CASE 'trustee'
      SELECT currency
        INTO :ls_cur
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :data ;
      IF SQLCA.sqlcode ()=0 THEN ls_cur = SQLCA.GETITEMSTRING (1)

      SELECT jm_cd
        INTO :ls_jm_cd
        FROM SYM0YA t1
       WHERE t1.CORP_GR   = :gaa.CORP_GR
         AND t1.currency  = :ls_cur
         AND t1.gyulje_jm = 'Y' ;
      IF SQLCA.sqlcode ()=0 THEN Object.gyulje_jm_cd [row] = SQLCA.GETITEMSTRING (1)
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

