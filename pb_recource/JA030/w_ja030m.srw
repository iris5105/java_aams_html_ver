forward
global type w_ja030m from wt_list
end type
end forward

global type w_ja030m from wt_list
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
end type
global w_ja030m w_ja030m

type variables
STRING	is_corp_gr
end variables

event wue_retrieve;call super::wue_retrieve;is_corp_gr = dw_c.object.dddw [1]
IF is_corp_gr<>'%' THEN dw_List.SetFilter ("sanghw_ymd >= date('" + string (f_add_months (idt_workdate,-12,null_dt), 'yyyy.mm.dd') + "')")
dw_list.retrieve (is_corp_gr, idt_workdate)
end event

on w_ja030m.create
int iCurrent
call super::create
end on

on w_ja030m.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' }) ; f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '%,전체,', 1, '')
dw_c.object.dddw [1] = gaa.corp_gr
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja030m
end type

type ln_templeft from wt_list`ln_templeft within w_ja030m
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030m
end type

type ln_temptop from wt_list`ln_temptop within w_ja030m
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030m
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030m
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030m
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030m
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030m
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030m
end type

type ln_tempright from wt_list`ln_tempright within w_ja030m
end type

type uo_navi from wt_list`uo_navi within w_ja030m
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030m
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030m
end type

type st_top_rect from wt_list`st_top_rect within w_ja030m
end type

type p_close from wt_list`p_close within w_ja030m
end type

type p_excel from wt_list`p_excel within w_ja030m
end type

type p_print from wt_list`p_print within w_ja030m
end type

type p_delete from wt_list`p_delete within w_ja030m
end type

type p_update from wt_list`p_update within w_ja030m
end type

type p_input from wt_list`p_input within w_ja030m
end type

type p_retrieve from wt_list`p_retrieve within w_ja030m
end type

type p_clear from wt_list`p_clear within w_ja030m
end type

type p_copy from wt_list`p_copy within w_ja030m
end type

type dw_c from wt_list`dw_c within w_ja030m
string title = "운용사"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_valid;call super::ue_valid;CHOOSE CASE Object.dddw [1]
   CASE '%'
      dw_List.uf_dataobject ('d_ja030m2', FALSE)
      F_DDDWCTL (dw_List, 'corp_gr', gaa.corp_gr, '', 1, "corp_gr LIKE '%'")
      F_DDDWCTL (dw_List, 'cash_cd', gaa.corp_gr, '', 1, "sebu_cd='90'")
      F_DDDWCTL (dw_List, 'sutak_cd', gaa.corp_gr, '', 9, "corp_gr LIKE '%'")
   CASE ELSE
      dw_List.uf_dataobject ('d_ja030m1', FALSE)
      F_DDDWCTL (dw_List, 'cash_cd', gaa.corp_gr, '', 1, "sebu_cd in ('70','90')")
      F_DDDWCTL (dw_List, 'sutak_cd', Object.dddw [1], '%,전체,', 1, '')
END CHOOSE
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja030m
end type

type st_count from wt_list`st_count within w_ja030m
end type

type dw_list from wt_list`dw_list within w_ja030m
string dataobject = "d_ja030m2"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt

CHOOSE CASE dwo.name
   CASE 'balh_ymd'
      ldt = datetime (date (MidA (data,1,10)))

      SELECT  f_open_ymd (last_day (:ldt), '+1')
        INTO  :ldt
      FROM    dual;

		ldt = SQLCA.getitemdatetime (1)

      Object.sanghw_ymd [row] = ldt

   CASE 'pyom_iyul_per'
      Object.pyom_iyul [row] = dec (data) / 100.0
      Object.meib_suik_rt [row] = dec (data) / 100.0
      IF dw_c.object.dddw [1]='%'   Then
         Object.hj_nm [row] = '예금(' + data + '%)'
      Else
         Object.hj_nm [row] = describe("Evaluate('LookupDisplay(cash_cd)'," + string (row) + ")") + '(' + data + '%)'
      End IF
END CHOOSE
end event

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;IF dw_c.object.dddw [1]='%' THEN f_dddw_filter (THIS, 'sutak_cd', "key='" + Object.corp_gr [currentrow] + "'")
RETURN 0
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF parent.EVENT wue_confirmupdate4close ()=1 THEN RETURN 1
IF getrow ()>0 Then
   uf_setcolumn ('corp_gr', Object.corp_gr [getrow ()])
   uf_setcolumn ('cash_cd', Object.cash_cd [getrow ()])
   uf_setcolumn ('sutak_cd', Object.sutak_cd [getrow ()])
Else
   uf_setcolumn ('corp_gr', is_corp_gr)
   uf_setcolumn ('cash_cd', '90')
   uf_setcolumn ('sutak_cd', '%')
End IF

DateTime ldt2

uf_setcolumn ('balh_ymd', string (idt_workdate))
uf_setcolumn ('sanghw_ymd', '2099.12.31')

POST SetColumn ('balh_ymd')

RETURN 0
end event

event dw_list::ue_copyrowset;call super::ue_copyrowset;DateTime ldt_f, ldt_t

ldt_f = Object.balh_ymd [row]
ldt_t = Object.sanghw_ymd [row]

SELECT  ADD_MONTHS(:ldt_f, trunc(months_between(:ldt_t, :ldt_f)))
      , f_open_ymd(to_date(to_char(add_months(:ldt_t, trunc(months_between(:ldt_t, :ldt_f))),'yyyymm') || to_char(:ldt_f,'dd'),'yyyymmdd'), '+')
  INTO  :ldt_f
      , :ldt_t
FROM    dual;

ldt_f = SQLCA.getitemdatetime (1)
ldt_t = SQLCA.getitemdatetime (2)

Object.balh_ymd [row] = ldt_f
Object.sanghw_ymd [row] = ldt_t
Object.jm_cd [row] = null_s
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_yy, ls_mm, ls_jm_cd

LONG	ll, ll_seq

FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 0, Primary!)=NewModified! And f_null (Object.jm_cd [ll])   Then
      is_corp_gr = Object.corp_gr [ll]
      ls_yy = f_get_id_dae ('Y', string (Object.balh_ymd [ll], 'yyyy'))
      ls_mm = f_get_id_dae ('M',string (Object.balh_ymd [ll], 'mm'))

      ls_jm_cd = 'KR9'+ ls_yy +  ls_mm + string (Object.balh_ymd [ll],'dd') + Object.cash_cd [ll] + '___'

      SELECT  NVL(MAX(SUBSTR(JM_CD,10,2)),0) + 1
        INTO  :ll_seq
      FROM    shm0hj t1
      WHERE   t1.corp_gr = :is_corp_gr
        AND   t1.jm_cd   LIKE :ls_jm_cd;
		
		ll_seq = SQLCA.getitemnumber (1)

      Object.jm_cd [ll] = f_jm_check (LEFT (ls_jm_cd,9) + string (ll_seq,'00'))
   End IF
NEXT
end event

event dw_list::clicked;LONG	ll

DateTime ldt

IF dwo.NAME='fseq_t' OR dwo.NAME='fseq_all'  Then  // 전체선택
   SelectRow (0, FALSE)
   SELECT  f_open_ymd(now() + 7 - to_char(now(),'d'), '+')
     INTO  :ldt
   FROM    dual;

	ldt = SQLCA.getitemdatetime (1)

   FOR  ll = 1  TO  rowcount ()
      IF Object.sanghw_ymd [ll]=ldt THEN SelectRow (ll, TRUE)
   NEXT
	uf_setrange (true)

   RETURN
End IF
CALL super::clicked
end event

