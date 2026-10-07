forward
global type w_ja031c from wt_list
end type
end forward

global type w_ja031c from wt_list
integer ii_dddw_width = 750
string is_init_value = "S30"
end type
global w_ja031c w_ja031c

type variables
INT   ii_seq
end variables

on w_ja031c.create
int iCurrent
call super::create
end on

on w_ja031c.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;DateTime ldt

ldt = dw_c.object.ymd [1]
ia_value [1] = dw_c.object.dddw [1]

SELECT  NVL(max(tr_seq_no),0)
  INTO  :ii_seq
FROM    sst0wc t1
WHERE   t1.corp_gr  = :gaa.corp_gr
  AND   t1.tr_ymd   = :ldt
  AND   t1.tr_cd    = :ia_value[1]
  AND   t1.currency = 'KRW';

ii_seq = SQLCA.getitemnumber (1)

dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja031c
end type

type ln_templeft from wt_list`ln_templeft within w_ja031c
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja031c
end type

type ln_temptop from wt_list`ln_temptop within w_ja031c
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja031c
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja031c
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja031c
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja031c
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja031c
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja031c
end type

type ln_tempright from wt_list`ln_tempright within w_ja031c
end type

type uo_navi from wt_list`uo_navi within w_ja031c
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja031c
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja031c
end type

type st_top_rect from wt_list`st_top_rect within w_ja031c
end type

type p_close from wt_list`p_close within w_ja031c
end type

type p_excel from wt_list`p_excel within w_ja031c
end type

type p_print from wt_list`p_print within w_ja031c
end type

type p_delete from wt_list`p_delete within w_ja031c
end type

type p_update from wt_list`p_update within w_ja031c
end type

type p_input from wt_list`p_input within w_ja031c
end type

type p_retrieve from wt_list`p_retrieve within w_ja031c
end type

type p_clear from wt_list`p_clear within w_ja031c
end type

type p_copy from wt_list`p_copy within w_ja031c
end type

type dw_c from wt_list`dw_c within w_ja031c
string title = "영업일자@거래구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031C'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SST0WC t1
 WHERE t1.CORP_GR  = :gaa.CORP_GR
   AND t1.tr_ymd   = :rs_ymd
   AND t1.tr_cd    IN (SELECT tr_cd
                         FROM SZX1PT ta
                        WHERE ta.obj_id = 'W_JA031C')
   AND t1.currency = 'KRW'
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'ymd'
      IF datetime (date (MidA (data,1,10)))>=idt_workdate   Then
         ib_manageData = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031C'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031C' and szx0gc.tr_cd in (select tr_cd from sst0wc where corp_gr=':corp_gr' and tr_ymd='"+MidA (data, 1, 10)+"' and currency='KRW')")
      End IF
END CHOOSE
end event

type btn_update from wt_list`btn_update within w_ja031c
end type

type st_count from wt_list`st_count within w_ja031c
end type

type dw_list from wt_list`dw_list within w_ja031c
string dataobject = "d_ja031c"
end type

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_where = "fund_currency = 'KRW'"
   CASE 'tr_co_cd'
      rs_Where = "tr_gb in ('1','2','4') and used='1'"
END CHOOSE
RETURN 1
end event

event dw_list::ue_insertstart;call super::ue_insertstart;ii_seq ++
uf_SetColumn ("tr_ymd", string (dw_c.object.ymd [1]))
uf_SetColumn ("tr_cd", dw_c.object.dddw [1])
uf_SetColumn ("tr_seq_no", string (ii_seq))
uf_SetColumn ("trustee", 'KRW')
uf_SetColumn ("currency", 'KRW')

POST SetColumn ("fund_cd")

RETURN 0
end event

