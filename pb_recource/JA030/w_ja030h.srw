forward
global type w_ja030h from wt_list
end type
end forward

global type w_ja030h from wt_list
string is_init_value = "K30"
end type
global w_ja030h w_ja030h

on w_ja030h.create
int iCurrent
call super::create
end on

on w_ja030h.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], dw_c.object.dddw [1], f_nvl(dw_c.object.fund_cd [1],'%'))
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja030h
end type

type ln_templeft from wt_list`ln_templeft within w_ja030h
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030h
end type

type ln_temptop from wt_list`ln_temptop within w_ja030h
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030h
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030h
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030h
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030h
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030h
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030h
end type

type ln_tempright from wt_list`ln_tempright within w_ja030h
end type

type uo_navi from wt_list`uo_navi within w_ja030h
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030h
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030h
end type

type st_top_rect from wt_list`st_top_rect within w_ja030h
end type

type p_close from wt_list`p_close within w_ja030h
end type

type p_excel from wt_list`p_excel within w_ja030h
end type

type p_print from wt_list`p_print within w_ja030h
end type

type p_delete from wt_list`p_delete within w_ja030h
end type

type p_update from wt_list`p_update within w_ja030h
end type

type p_input from wt_list`p_input within w_ja030h
end type

type p_retrieve from wt_list`p_retrieve within w_ja030h
end type

type p_clear from wt_list`p_clear within w_ja030h
end type

type p_copy from wt_list`p_copy within w_ja030h
end type

type dw_c from wt_list`dw_c within w_ja030h
string dataobject = "d_ja030h"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA030H'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SHT0HG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT h1
                       WHERE obj_id = 'W_SJA030H')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN  li_ret
end event

event dw_c::ue_valid;call super::ue_valid;ia_value [1] = dw_c.object.dddw [1]
ib_manageData = (uf_initdate ('inputdate')<=Object.tr_ymd[1] OR gaa.admin)
RETURN TRUE
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'fund_cd'
      rs_addrow = '%,전체'
END CHOOSE
RETURN 1
end event

type btn_update from wt_list`btn_update within w_ja030h
end type

type st_count from wt_list`st_count within w_ja030h
end type

type dw_list from wt_list`dw_list within w_ja030h
string dataobject = "d_ja030h1"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE dwo.name
      CASE 'tr_aek'
			Object.mijigub_tax [row] = dec (data) - f_num (Object.jungsan_aek [row])
      CASE 'jungsan_aek'
			Object.mijigub_tax [row] = f_num (Object.tr_aek [row]) - dec (data)
      CASE 'aekm'
         Object.tr_aek [row] = Object.danga [row] / 10000 * dec (data)
END CHOOSE
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
	CASE 'fund_cd'
		rs_Where = "t1.jm_cd='" + dw_c.object.cj_cd [1] + "' and t1.ymd='" + string(dw_c.object.tr_ymd [1]) + "'"
		RETURN 11
END CHOOSE
RETURN 1
end event

event dw_list::updatestart;LONG	ll

FOR  ll = 1  TO  rowcount ()
   IF f_num (Object.aekm [ll])=0 THEN f_dw_resetstatus (THIS, ll, null_a)
NEXT

call super::updatestart
end event

event dw_list::retrieveend;call super::retrieveend;IF dw_c.object.fund_cd [1]<>'%' And rowcount=0  Then
   DateTime ldt

   STRING	ls_fund_cd, ls_fund_nm, ls_jm_cd, ls_jm_nm, ls_tr_co_cd, ls_ksd, ls_sqlsyntax

   DEC	ldc_aekm, ldc_aek

   LONG	ll, lR, lm

	aDS_jTier	lds_jtier

   ldt = dw_c.object.tr_ymd [1]
   ls_fund_cd = dw_c.object.fund_cd [1]

   ls_sqlsyntax = " SELECT  t1.fund_cd " &
                + "       , t2.fund_nm " &
                + "       , t2.mg_cd " &
                + "       , t1.jm_cd " &
                + "       , t3.hj_nm " &
                + "       , NVL(t1.bfil_aekm,0) " &
                + "       , NVL(t1.bfil_siga_aek,0) " &
                + "       , t3.ksd_jm_cd " &
                + " FROM    shm0hm t1 " &
                + "       , szm0ia t2 " &
                + "       , shm0hj t3 " &
                + " WHERE   t1.corp_gr          = '" + gaa.corp_gr + "' " &
                + "   AND   t1.ymd              = '" + string (ldt,'yyyy.mm.dd') + "' " &
                + "   AND   t1.fund_cd          = '" + ls_fund_cd + "' " &
                + "   AND   NVL(t1.bfil_aekm,0) > 0 " &
                + "   AND   t2.corp_gr          = t1.corp_gr " &
                + "   AND   t2.fund_cd          = t1.fund_cd " &
                + "   AND   t3.corp_gr          = t1.corp_gr " &
                + "   AND   t3.jm_cd            = t1.jm_cd " &
                + " ORDER BY  t1.jm_cd "

   lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

	FOR  lm = 1  TO  lR
		 ls_fund_cd  = lds_jtier.getitemstring (lm, 1)
		 ls_fund_nm  = lds_jtier.getitemstring (lm, 2)
		 ls_tr_co_cd = lds_jtier.getitemstring (lm, 3)
		 ls_jm_cd    = lds_jtier.getitemstring (lm, 4)
		 ls_jm_nm    = lds_jtier.getitemstring (lm, 5)
		 ldc_aekm    = lds_jtier.getitemnumber (lm, 6)
		 ldc_aek 	 = lds_jtier.getitemnumber (lm, 7)
		 ls_ksd      = lds_jtier.getitemstring (lm, 8)
	
      ll = insertrow (0)
      Object.corp_gr [ll] = gaa.corp_gr
      Object.tr_ymd [ll] = ldt
      Object.tr_cd [ll] = dw_c.object.dddw [1]
      Object.fund_cd [ll] = ls_fund_cd
      Object.xx_fund_cd [ll] = ls_fund_nm
      Object.jm_cd [ll] = ls_jm_cd
      Object.xx_jm_cd [ll] = ls_jm_nm
      Object.tr_co_cd [ll] = ls_tr_co_cd
      Object.bfil_aekm [ll] = ldc_aekm
      Object.bfil_siga_aek [ll] = ldc_aek
      Object.danga [ll] = ldc_aek / ldc_aekm * 10000
      Object.tr_aek [ll] = 0
      Object.susu_ga [ll] = 0
      Object.seq_no [ll] = 1001
      Object.jajun_gb [ll] = '3'
      Object.ksd_jm_cd [ll] = ls_ksd
	NEXT
End IF
end event

event dw_list::doubleclicked;call super::doubleclicked;IF	ib_managedata And (dwo.name='aekm' OR dwo.name='tr_aek')	Then
	Object.aekm [row] = Object.bfil_aekm [row]
	Object.tr_aek [row] = Object.bfil_siga_aek [row]
	Object.mijigub_tax [row] = 0
	Object.danga [row] = Object.tr_aek [row] / Object.aekm [row] * 10000
End IF
end event

