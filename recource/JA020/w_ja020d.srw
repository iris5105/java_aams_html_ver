forward
global type w_ja020d from wt_list
end type
end forward

global type w_ja020d from wt_list
string is_init_value = "F65"
end type
global w_ja020d w_ja020d

type variables
Decimal  idc_tax_rt

end variables

on w_ja020d.create
int iCurrent
call super::create
end on

on w_ja020d.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
dw_c.object.cut_gb [1] = 'Y'

// 장외거래세율
SELECT  NVL (sebu_cd_efnm,'0.005')
  INTO  :idc_tax_rt
FROM    szx0gr t1
WHERE   t1.gr_cd   = '95'
  AND   t1.sebu_cd = '02';

idc_tax_rt = SQLCA.getitemnumber (1)
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], ia_value [1], f_nvl (dw_c.object.xx_jm_cd [1],'%'))
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja020d
end type

type ln_templeft from wt_list`ln_templeft within w_ja020d
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja020d
end type

type ln_temptop from wt_list`ln_temptop within w_ja020d
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja020d
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja020d
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja020d
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja020d
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja020d
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja020d
end type

type ln_tempright from wt_list`ln_tempright within w_ja020d
end type

type uo_navi from wt_list`uo_navi within w_ja020d
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja020d
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja020d
end type

type st_top_rect from wt_list`st_top_rect within w_ja020d
end type

type p_close from wt_list`p_close within w_ja020d
end type

type p_excel from wt_list`p_excel within w_ja020d
end type

type p_print from wt_list`p_print within w_ja020d
end type

type p_delete from wt_list`p_delete within w_ja020d
end type

type p_update from wt_list`p_update within w_ja020d
end type

type p_input from wt_list`p_input within w_ja020d
end type

type p_retrieve from wt_list`p_retrieve within w_ja020d
end type

type p_clear from wt_list`p_clear within w_ja020d
end type

type p_copy from wt_list`p_copy within w_ja020d
end type

type dw_c from wt_list`dw_c within w_ja020d
integer y = 152
integer height = 328
string dataobject = "d_ja020d"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN

CHOOSE CASE dwo.name
   CASE 'tr_ymd'
      IF DateTime (Date (MidA (data,1,10)))>=idt_workdate   Then
         ib_manageData = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020D'")
         Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='"+Object.dddw [1]+"'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020D' and szx0gc.tr_cd in (select tr_cd from sjt0cy where corp_gr=':corp_gr' and tr_ymd='"+MidA (data, 1, 10)+"')")
      End IF
      Object.koscom_cd [row] = null_s
      Object.xx_koscom_cd [row] = null_s
      Object.xx_jm_cd [row] = null_s
      Object.tr_co_cd [row] = null_s
      Object.xx_tr_co_cd [row] = null_s
      Object.sj_jm [row] = null_s
      Object.xx_sj_jm [row] = null_s
   CASE 'dddw'
      Object.koscom_cd [row] = null_s
      Object.xx_koscom_cd [row] = null_s
      Object.xx_jm_cd [row] = null_s
      Object.tr_co_cd [row] = null_s
      Object.xx_tr_co_cd [row] = null_s
      Object.sj_jm [row] = null_s
      Object.xx_sj_jm [row] = null_s
END CHOOSE
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'koscom_cd'
      IF ib_manageData  Then
         rs_Where = "danc_gb IN ('A','C','D','X')"
      Else
         rs_Where = "jm_cd in (select jm_cd from sjt0cy where tr_ymd='" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
   CASE 'tr_co_cd'
      IF ib_manageData  Then
         rs_Where = "tr_gb in ('1','2','8')"
      Else
         rs_Where = "tr_co_cd in (select tr_co_cd from sjt0cy where tr_ymd='" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
   CASE 'sj_jm'
		// 예탁된 비상장이 있어 비상장 추가
      rs_Where = "danc_gb IN ('A','B','C','D') And balh_co='" + Object.balh_co [1] + "'"
END CHOOSE

RETURN 1
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    sjt0cy t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :rs_ymd
  AND   t1.tr_cd   IN ( select tr_cd
                          from szx1pt ta
                        where  ta.obj_id = 'w_sjue050' )
  AND   ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA020D'")
end event

type btn_update from wt_list`btn_update within w_ja020d
end type

type st_count from wt_list`st_count within w_ja020d
end type

type dw_list from wt_list`dw_list within w_ja020d
integer y = 496
integer height = 2268
string dataobject = "d_ja020d1"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;IF rowcount>0 OR ib_manageData=FALSE OR f_null (dw_c.object.xx_jm_cd [1])	Then
   RETURN
End IF

DateTime ldt

STRING	ls_jm_cd, ls_fund_cd, ls_fund_nm, ls_sqlsyntax

DEC	ldc_jusu, ldc_aek

LONG	lR, ll

aDS_jTier	lds_jtier

ldt = dw_c.object.tr_ymd [1]
ls_jm_cd = dw_c.object.xx_jm_cd [1]

ls_sqlsyntax = "   SELECT  t1.fund_cd " &
             + "         , t2.fund_nm " &
             + "         , NVL(t1.bfil_boyu_jusu,0) " &
             + "         , NVL(t1.bfil_chui_aek,0) " &
             + "   FROM    sjm0jm t1 " &
             + "         , szm0ia t2 " &
             + "   WHERE   t1.corp_gr = '" + gaa.corp_gr + "' " &
             + "     AND   t1.ymd     = '" + string (ldt,'yyyy.mm.dd') + "' " &
             + "     AND   t1.jm_cd   = '" + ls_jm_cd + "' " &
             + "     AND   t2.corp_gr = t1.corp_gr " &
             + "     AND   t2.fund_cd = t1.fund_cd "

INT   i

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR ll = 1 TO lR
	ls_fund_cd	= lds_jtier.getitemstring (ll, 1)
	ls_fund_nm	= lds_jtier.getitemstring (ll, 2)
	ldc_jusu		= lds_jtier.getitemnumber (ll, 3)
	ldc_aek		= lds_jtier.getitemnumber (ll, 4)
	
   i = insertrow (0)
   Object.corp_gr [i] 		= gaa.corp_gr
   Object.fund_cd [i] 		= ls_fund_cd
   Object.xx_fund_cd [i]	= ls_fund_nm
   Object.tr_ymd [i] 		= dw_c.object.tr_ymd [1]
   Object.tr_cd [i] 			= dw_c.object.dddw [1]
   Object.koscom_cd [i] 	= dw_c.object.koscom_cd [1]
   Object.jm_cd [i] 			= dw_c.object.xx_jm_cd [1]
   Object.tr_co_cd [i] 		= dw_c.object.tr_co_cd [1]
   Object.danga [i] 			= dw_c.object.danga [1]
   Object.xx_boyu_jusu [i] = ldc_jusu
   Object.cheng_jusu [i] 	= ldc_jusu
   IF dw_c.object.cut_gb [1]='Y' THEN Object.tax [i] = TRUNCATE ( (ldc_jusu * dw_c.object.danga [1]) * idc_tax_rt / 10,0) * 10 &
   Else                               Object.tax [i] = TRUNCATE ( (ldc_jusu * dw_c.object.danga [1]) * idc_tax_rt,0)
   Object.cheng_aek [i] = (ldc_jusu * dw_c.object.danga [1]) - Object.tax [i]
	Object.type_trench [i] = '00:'
	Object.bs_type [i] = 0
	IF	f_notnull (dw_c.object.sj_jm [1])	Then
		Object.sj_jm_cd [i] = dw_c.object.sj_jm [1]
		Object.kra_jusu [i] = ldc_jusu
		Object.kra_chui_aek [i] = ldc_aek
	End IF
NEXT
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN

CHOOSE CASE dwo.name
   CASE 'cheng_jusu'
      IF dw_c.object.cut_gb [1]='Y' THEN Object.tax [row] = TRUNCATE (f_num (data) * Object.danga [row] * idc_tax_rt / 10,0) * 10 &
      Else                               Object.tax [row] = TRUNCATE (f_num (data) * Object.danga [row] * idc_tax_rt,0)
      Object.cheng_aek [row] = dec (data) * Object.danga [row] - Object.tax [row]
   CASE 'tax'
      Object.cheng_aek [row] = Object.cheng_jusu [row] * Object.danga [row] - f_num (data)
END CHOOSE
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_Where = "t1.ymd='" + string (dw_c.object.tr_ymd [1]) + "' and t1.jm_cd='" + dw_c.object.xx_jm_cd [1] + "'"
      RETURN 10
END CHOOSE
RETURN 1
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.tr_ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('koscom_cd', dw_c.object.koscom_cd [1])
uf_setColumn ('jm_cd', dw_c.object.xx_jm_cd [1])
uf_setColumn ('danga', string (dw_c.object.danga [1]))
uf_setColumn ('tr_co_cd', dw_c.object.tr_co_cd [1])
uf_setColumn ('sj_jm_cd', dw_c.object.sj_jm [1])
uf_setColumn ('type_trench', '00:')
uf_setColumn ('bs_type', '0')

POST SetColumn ("fund_cd")

RETURN 0
end event

