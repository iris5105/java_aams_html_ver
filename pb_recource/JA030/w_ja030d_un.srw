forward
global type w_ja030d_un from wt_list
end type
end forward

global type w_ja030d_un from wt_list
boolean eb_retrievewait = true
string is_init_value = "K11"
end type
global w_ja030d_un w_ja030d_un

on w_ja030d_un.create
int iCurrent
call super::create
end on

on w_ja030d_un.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
dw_c.object.gu [1] = 0
end event

event wue_retrieve;call super::wue_retrieve;IF dw_c.object.gu [1]=0  Then
   dw_List.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], dw_c.object.dddw [1], f_nvl (dw_c.object.fund_cd [1],'%'))
Else
   dw_List.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], dw_c.object.dddw [1], dw_c.object.cj_cd [1])
End IF
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja030d_un
end type

type ln_templeft from wt_list`ln_templeft within w_ja030d_un
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030d_un
end type

type ln_temptop from wt_list`ln_temptop within w_ja030d_un
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030d_un
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030d_un
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030d_un
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030d_un
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030d_un
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030d_un
end type

type ln_tempright from wt_list`ln_tempright within w_ja030d_un
end type

type uo_navi from wt_list`uo_navi within w_ja030d_un
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030d_un
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030d_un
end type

type st_top_rect from wt_list`st_top_rect within w_ja030d_un
end type

type p_close from wt_list`p_close within w_ja030d_un
end type

type p_excel from wt_list`p_excel within w_ja030d_un
end type

type p_print from wt_list`p_print within w_ja030d_un
end type

type p_delete from wt_list`p_delete within w_ja030d_un
end type

type p_update from wt_list`p_update within w_ja030d_un
end type

type p_input from wt_list`p_input within w_ja030d_un
end type

type p_retrieve from wt_list`p_retrieve within w_ja030d_un
end type

type p_clear from wt_list`p_clear within w_ja030d_un
end type

type p_copy from wt_list`p_copy within w_ja030d_un
end type

type dw_c from wt_list`dw_c within w_ja030d_un
string dataobject = "d_ja030d_un"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA030D'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

STRING	ls_tr_cd

ls_tr_cd = Object.dddw [1]

SELECT  1
  INTO  :li_ret
FROM    sct0cg t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :rs_ymd
  AND   t1.tr_cd   = :ls_tr_cd
  AND   ROWNUM = 1;
  li_ret = SQLCA.getitemnumber (1)

RETURN  li_ret
end event

event dw_c::ue_valid;call super::ue_valid;ia_value [1] = Object.dddw[1]
ib_manageData = (uf_initdate ('inputdate') <= Object.tr_ymd[1])
RETURN TRUE
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;DateTime   ldt

ldt = Object.tr_ymd [1]

CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_addrow = '%,전체,,'
      rs_where = "nvl(t1.haeji_ymd,'" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "') >= '" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "'"
      RETURN 2
   CASE 'cj_cd'

      RETURN 2
END CHOOSE
RETURN 1
end event

type btn_update from wt_list`btn_update within w_ja030d_un
end type

type st_count from wt_list`st_count within w_ja030d_un
end type

type dw_list from wt_list`dw_list within w_ja030d_un
string dataobject = "d_ja030d1"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime    ldt_tr_ymd

STRING	ls_jm_cd, ls_tr_co_cd

DEC	ld_aekm

ldt_tr_ymd = dw_c.object.tr_ymd [1]
ls_jm_cd   = Object.cj_cd [1]

CHOOSE CASE dwo.name
	CASE "fund_cd"
		SELECT  (nvl(bfil_aekm,0) + nvl(meib_aekm,0) - nvl(medo_aekm,0) + nvl(msd_meib_aekm,0) - nvl(msd_medo_aekm,0) - nvl(jilg_aekm,0) - nvl(jilg_up_aekm,0) + nvl(jilg_dw_aekm,0)) / 10000
		 INTO  :ld_aekm
	  FROM    scm0cm t1
	  WHERE   t1.corp_gr = :gaa.corp_gr
		 AND   t1.ymd     = :ldt_tr_ymd
		 AND   t1.fund_cd = :data
		 AND   t1.jm_cd   = :ls_jm_cd;
		 ld_aekm = SQLCA.getitemnumber (1)

		SetItem (row, "boyu_aekm", ld_aekm)

		IF dw_c.object.dddw [1]='E38' THEN
			SELECT  mg_cd
			  INTO  :ls_tr_co_cd
			FROM    szm0ia t1
			WHERE   t1.corp_gr = :gaa.corp_gr
			  AND   t1.fund_cd = :data;
			  ls_tr_co_cd = SQLCA.getitemstring (1)
			
			SetItem (row, 'tr_co_cd', ls_tr_co_cd)
		End IF

	CASE "ccom_aekm"
		SetItem (row, "aekm", dec (data) * 10000)
		SetItem (row, "tr_aek", dw_list.object.danga [1] * dec (data))
END CHOOSE

Object.ija_aekm [row] = 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
      CASE 'fund_cd'
         rs_Where = "t1.jm_cd='" + dw_c.object.cj_cd [1] + "' and t1.ymd='" + string(dw_c.object.tr_ymd [1]) + "'"
         RETURN 11
END CHOOSE
RETURN 1
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt

LONG	ll, ll_num

STRING	ls_tr_cd, ls_fund_cd, ls_jm_cd

ldt = dw_c.object.tr_ymd [1]
ls_tr_cd = dw_c.object.dddw [1]
ls_fund_cd = dw_c.object.fund_cd [1]

ll_num = rowcount ()
FOR  ll = 1  TO  ll_num
   IF Object.ccom_aekm [ll]=0 Then
      f_dw_resetstatus (THIS, ll, null_a)

      ls_jm_cd = Object.cj_cd [ll]

      DELETE  sct0cg
      WHERE   corp_gr = :gaa.corp_gr
        AND   tr_ymd  = :ldt
        AND   tr_cd   = :ls_tr_cd
        AND   fund_cd = :ls_fund_cd
        AND   jm_cd   = :ls_jm_cd;
   Else
      IF f_null (Object.cj_cd [ll]) Then
         f_messagebox ("I000", string (ll) + " 행에서 종목코드 오류")
         RETURN 1
      End IF
   End IF
NEXT
end event

event dw_list::retrieveend;call super::retrieveend;IF rowcount>0 THEN RETURN

DateTime ldt

STRING	ls_fund_cd, ls_fund_nm, ls_jm_cd, ls_jm_nm, ls_buy_date, ls_tr_co_cd, ls_sqlsyntax

DEC	ldc_aekm, ldc_aek

LONG	ll, lR, lj

aDS_jTier	lds_jtier

ldt = dw_c.object.tr_ymd [1]
ls_fund_cd = dw_c.object.fund_cd [1]
ls_jm_cd = dw_c.object.cj_cd [1]

CHOOSE CASE dw_c.object.gu [1]
   CASE 0
      IF dw_c.object.fund_cd [1]<>'%'  Then
         ls_sqlsyntax = "            SELECT  t1.fund_cd " &
                      + "                  , t2.fund_nm " &
                      + "                  , t2.sutak_cd " &
                      + "                  , t1.jm_cd " &
                      + "                  , t3.cj_nm " &
                      + "                  , t1.buy_date " &
                      + "                  , NVL(t1.bfil_aekm,0) " &
                      + "                  , NVL(t1.bfil_siga_aek,0) " &
                      + "            FROM    scm0cm t1 " &
                      + "                  , szm0ia t2 " &
                      + "                  , scm0cj t3 " &
                      + "            WHERE   t1.corp_gr          = '" + gaa.corp_gr + "' " &
                      + "              AND   t1.ymd              = '" + string (ldt,'yyyy.mm.dd') + "' " &
                      + "              AND   t1.fund_cd          = '" + ls_fund_cd + "' " &
                      + "              AND   NVL(t1.bfil_aekm,0) > 0 " &
                      + "              AND   t2.corp_gr          = t1.corp_gr " &
                      + "              AND   t2.fund_cd          = t1.fund_cd " &
                      + "              AND   t3.corp_gr          = t1.corp_gr " &
                      + "              AND   t3.jm_cd            = t1.jm_cd " &
                      + "            ORDER BY  t1.jm_cd "
      Else
         RETURN
      End IF
   CASE 1
      ls_sqlsyntax = "         SELECT  t1.fund_cd " &
                   + "               , t2.fund_nm " &
                   + "               , t2.sutak_cd " &
                   + "               , t1.jm_cd " &
                   + "               , t3.cj_nm " &
                   + "               , t1.buy_date " &
                   + "               , NVL(t1.bfil_aekm,0) " &
                   + "               , NVL(t1.bfil_siga_aek,0) " &
                   + "         FROM    scm0cm t1 " &
                   + "               , szm0ia t2 " &
                   + "               , scm0cj t3 " &
                   + "         WHERE   t1.corp_gr          = '" + gaa.corp_gr + "' " &
                   + "           AND   t1.ymd              = '" + string (ldt,'yyyy.mm.dd') + "' " &
                   + "           AND   t1.jm_cd            = '" + ls_jm_cd + "' " &
                   + "           AND   NVL(t1.bfil_aekm,0) > 0 " &
                   + "           AND   t2.corp_gr          = t1.corp_gr " &
                   + "           AND   t2.fund_cd          = t1.fund_cd " &
                   + "           AND   t3.corp_gr          = t1.corp_gr " &
                   + "           AND   t3.jm_cd            = t1.jm_cd " &
                   + "         ORDER BY  t1.fund_cd "
END CHOOSE


lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_fund_cd  = lds_jtier.getitemString (lj, 1)
   ls_fund_nm  = lds_jtier.getitemString (lj, 2)
   ls_tr_co_cd = lds_jtier.getitemString (lj, 3)
   ls_jm_cd    = lds_jtier.getitemString (lj, 4)
   ls_jm_nm    = lds_jtier.getitemString (lj, 5)
   ls_buy_date = lds_jtier.getitemString (lj, 6)
   ldc_aekm    = lds_jtier.getitemnumber (lj, 7)
   ldc_aek     = lds_jtier.getitemnumber (lj, 8)

   ll = event ue_insert (0)
   Object.corp_gr [ll] = gaa.corp_gr
   Object.tr_ymd [ll] = ldt
   Object.tr_cd [ll] = dw_c.object.dddw [1]
   Object.fund_cd [ll] = ls_fund_cd
   Object.xx_fund_cd [ll] = ls_fund_nm
   Object.cj_cd [ll] = ls_jm_cd
   Object.xx_cj_cd [ll] = ls_jm_nm
   Object.buy_date [ll] = ls_buy_date
   Object.tr_co_cd [ll] = ls_tr_co_cd
   Object.aekm [ll] = ldc_aekm
   Object.boyu_aekm [ll] = ldc_aekm / 10000
   IF dw_c.object.dddw [1]='E42' Then
      Object.ccom_aekm [ll] = ldc_aekm / 10000
      Object.aekm [ll] = ldc_aekm
      Object.tr_aek [ll] = ldc_aek
   Else
      Object.ccom_aekm [ll] = 0
      Object.tr_aek [ll] = 0
   End IF
   Object.danga [ll] = ldc_aek / ldc_aekm * 10000
   Object.susu [ll] = 0
   Object.sudo_ymd [ll] = ldt
   Object.seq_no [ll] = 100001
   Object.jajun_gb [ll] = '1'
	
NEXT

end event

