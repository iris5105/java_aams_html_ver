forward
global type w_ja035e from wt_list
end type
end forward

global type w_ja035e from wt_list
integer ii_dddw_width2 = 300
integer ii_rcd_width = 500
string is_date_nation = "US"
string is_init_value = "G31"
end type
global w_ja035e w_ja035e

type variables
ads_jTier	ids_code
end variables

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
IF PosA ('G32,G36',ia_value [1])>0 THEN ids_code.retrieve (gaa.corp_gr, ia_value [1], dw_c.object.ymd [1])
CHOOSE CASE ia_value [1]
	CASE 'G92'
		dw_list.uf_dataobject ('d_ja035e_g92', FALSE)
	CASE ELSE
		dw_list.uf_dataobject ('d_ja035e', FALSE)
END CHOOSE
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1], f_nvl (dw_c.object.rcd [1],'%'))
end event

on w_ja035e.create
int iCurrent
call super::create
end on

on w_ja035e.destroy
call super::destroy
end on

event close;call super::close;DESTROY ids_code
end event

event wue_lastopen;call super::wue_lastopen;ids_code = CREATE ads_jTier
ids_code.DataObject = 'd_ja035e_code'
ids_code.SetTransObject (SQLCA)

dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
CHOOSE CASE ia_value [1]
	CASE 'G92'
		dw_list.uf_dataobject ('d_ja035e_g92', FALSE)
	CASE ELSE
		dw_list.uf_dataobject ('d_ja035e', FALSE)
END CHOOSE
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035e
end type

type ln_templeft from wt_list`ln_templeft within w_ja035e
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035e
end type

type ln_temptop from wt_list`ln_temptop within w_ja035e
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035e
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035e
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035e
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035e
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035e
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035e
end type

type ln_tempright from wt_list`ln_tempright within w_ja035e
end type

type uo_navi from wt_list`uo_navi within w_ja035e
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035e
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035e
end type

type st_top_rect from wt_list`st_top_rect within w_ja035e
end type

type p_close from wt_list`p_close within w_ja035e
end type

type p_excel from wt_list`p_excel within w_ja035e
end type

type p_print from wt_list`p_print within w_ja035e
end type

type p_delete from wt_list`p_delete within w_ja035e
end type

type p_update from wt_list`p_update within w_ja035e
end type

type p_input from wt_list`p_input within w_ja035e
end type

type p_retrieve from wt_list`p_retrieve within w_ja035e
end type

type p_clear from wt_list`p_clear within w_ja035e
end type

type p_copy from wt_list`p_copy within w_ja035e
end type

type dw_c from wt_list`dw_c within w_ja035e
string tag = "권리대상 종목선택"
string title = "영업일자@권리구분@권리락종목"
string dataobject = "dc_ymd_dddw_xx"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt

CHOOSE CASE dwo.name
   CASE 'ymd'
      ldt = datetime (date (MidA (data,1,10)))

      IF ldt>=idt_workdate Then
         ib_manageData = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035E'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035E' and szx0gc.tr_cd in (select tr_cd from syt0yg where corp_gr=':corp_gr' and tr_ymd='"+MidA (data, 1, 10)+"')")
      End IF
   CASE 'rcd'
      Object.tag_text.TEXT = '(' + Object.currency [1] + ')'
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035E'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0YG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_SJA035E')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'rcd'
      rs_Where = "jm.ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
      RETURN 13
END CHOOSE
RETURN 1
end event

type btn_update from wt_list`btn_update within w_ja035e
end type

type st_count from wt_list`st_count within w_ja035e
end type

type dw_list from wt_list`dw_list within w_ja035e
string dataobject = "d_ja035e_g92"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;IF ib_manageData=FALSE OR ROWCOUNT>0 OR POS ('G31,G35',dw_c.object.dddw [1])=0 THEN RETURN

DEC   ldc_jusu, ldc_tax_per
LONG  ll, lR, lm

DATETIME ldt_ymd

STRING   ls_fund_cd, ls_fund_nm, ls_trustee, ls_jm_cd, ls_jm_nm, ls_currency, ls_pyunga_join
STRING   ls_sqlsyntax

aDS_jTier   lds_jtier

ldt_ymd     = dw_c.object.ymd [1]
ls_jm_cd    = dw_c.object.rcd [1]
ls_currency = dw_c.object.currency [1]

ls_sqlsyntax = " SELECT t1.fund_cd   " + &
                "      , t3.fund_nm   " + &
                "      , t1.trustee   " + &
                "      , t1.jm_cd   " + &
                "      , t2.jm_nm   " + &
                "      , t1.currency   " + &
                "      , t1.tr_bfil_jusu + NVL(t1.RIGHT_JUSU,0)   " + &
                "      , mm.tax_per   " + &
                "   FROM SYM0YZ t1 " + &
                "      , SYM0YA t2 " + &
                "      , SZM0IA t3 " + &
                "      , SYX2MM mm " + &
                "  WHERE t1.CORP_GR  = '" + gaa.corp_gr + "' " + &
                "    AND t1.ymd      = '" + STRING(ldt_ymd,'yyyy.mm.dd') + "' " + &
                "    AND t1.jm_cd    = '" + ls_jm_cd + "' " + &
                "    AND t2.CORP_GR  = t1.CORP_GR " + &
                "    AND t2.jm_cd    = t1.jm_cd " + &
                "    AND t2.currency = '" + ls_currency + "' " + &
                "    AND t2.jasan_gb = '1' " + &
                "    AND t3.CORP_GR  = t1.CORP_GR " + &
                "    AND t3.fund_cd  = t1.fund_cd " + &
                "    AND mm.CORP_GR  = t1.CORP_GR " + &
                "    AND mm.trustee  = t1.trustee " + &
                "  ORDER BY t1.jm_cd, t1.fund_cd "

lR = SQLCA.sql2ds (parent.classname( ), ls_sqlsyntax, lds_jtier,'xml')

FOR  lm = 1  TO  lR
    ls_fund_cd  = lds_jtier.GETITEMSTRING (lm,1)
    ls_fund_nm  = lds_jtier.GETITEMSTRING (lm,2)
    ls_trustee  = lds_jtier.GETITEMSTRING (lm,3)
    ls_jm_cd    = lds_jtier.GETITEMSTRING (lm,4)
    ls_jm_nm    = lds_jtier.GETITEMSTRING (lm,5)
    ls_currency = lds_jtier.GETITEMSTRING (lm,6)
    ldc_jusu    = lds_jtier.GETITEMNUMBER (lm,7)
    ldc_tax_per = lds_jtier.GETITEMNUMBER (lm,8)

   SELECT TO_CHAR(:ldt_ymd,'yyyymmdd') || '-' || join_seq.nextval
     INTO :ls_pyunga_join
     FROM DUAL ;

   ls_pyunga_join = SQLCA.GETITEMSTRING (1)

   ll = insertrow (0)

   Object.CORP_GR [ll]     = gaa.CORP_GR
   Object.p_visible [ll]   = 1
   Object.tr_ymd [ll]      = dw_c.object.ymd [1]
   Object.tr_cd [ll]       = dw_c.object.dddw [1]
   Object.fund_cd [ll]     = ls_fund_cd
   Object.fund_nm [ll]     = ls_fund_nm
   Object.trustee [ll]     = ls_trustee
   Object.yj_cd [ll]       = ls_jm_cd
   Object.xx_yj_cd [ll]    = ls_jm_nm
   Object.currency [ll]    = ls_currency
   Object.hwakj_ymd [ll]   = ldt_ymd
   Object.hwakj_jusu [ll]  = ldc_jusu
   Object.tax_per [ll]     = ldc_tax_per
   Object.pyunga_join [ll] = ls_pyunga_join
NEXT
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;STRING	ls_pyunga_join

LONG	lRow

SELECT  TO_CHAR(:idt_workdate,'yyyymmdd') || '-' || join_seq.nextval
  INTO  :ls_pyunga_join
FROM    dual;

ls_pyunga_join = SQLCA.getitemstring (1)

uf_SetColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_SetColumn ('tr_cd', dw_c.object.dddw [1])
uf_SetColumn ('hwakj_ymd', string (dw_c.object.ymd [1]))
uf_SetColumn ('bs_type', '0')
uf_SetColumn ('pyunga_join', ls_pyunga_join)

IF POS ('G32,G36',dw_c.object.dddw [1]) > 0  Then
	lRow = GetRow ()
	IF lRow>0   Then
		uf_SetColumn ('fund_cd', Object.fund_cd [lRow])
		uf_SetColumn ('fund_nm', Object.fund_nm [lRow])
	
		SetColumn ('trustee')
	Else
		SetColumn ('fund_cd')
	End IF
Else
	uf_SetColumn ('tr_seq', '1')
	uf_SetColumn ('fund_cd', '%')
	uf_SetColumn ('trustee', '%')

	SetColumn ('yj_cd')
End IF

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DEC   ldc_jusu, ldc_tax_per
LONG  ll, ll_jusu, lR, lm

DATETIME ldt_ymd

STRING   ls_fund_cd, ls_fund_nm, ls_trustee, ls_jm_cd, ls_jm_nm, ls_currency, ls_pyunga_join
STRING   ls_sqlsyntax

aDS_jTier   lds_jtier

CHOOSE CASE DWO.NAME
   CASE 'yj_cd'
      IF POS ('G31,G35',dw_c.object.dddw [1])>0 Then
         ldt_ymd    = dw_c.object.ymd [1]
         ls_fund_cd = Object.fund_cd [row]

         ls_sqlsyntax = " SELECT t1.fund_cd  " + &
                         "      , t3.fund_nm  " + &
                         "      , t1.trustee  " + &
                         "      , t1.jm_cd  " + &
                         "      , t2.jm_nm  " + &
                         "      , t1.currency  " + &
                         "      , t1.tr_bfil_jusu  " + &
                         "      , mm.tax_per  " + &
                         "   FROM SYM0YZ t1 " + &
                         "      , SYM0YA t2 " + &
                         "      , SZM0IA t3 " + &
                         "      , SYX2MM mm " + &
                         "  WHERE t1.CORP_GR  = '" + gaa.corp_gr + "' " + &
                         "    AND t1.fund_cd  != '" + ls_fund_cd + "' " + &
                         "    AND t1.ymd      = '" + STRING(ldt_ymd,'yyyy.mm.dd') + "' " + &
                         "    AND t1.jm_cd    = '" + data + "' " + &
                         "    AND t2.CORP_GR  = t1.CORP_GR " + &
                         "    AND t2.jm_cd    = t1.jm_cd " + &
                         "    AND t2.jasan_gb = '1' " + &
                         "    AND t3.CORP_GR  = t1.CORP_GR " + &
                         "    AND t3.fund_cd  = t1.fund_cd " + &
                         "    AND mm.CORP_GR  = t1.CORP_GR " + &
                         "    AND mm.trustee  = t1.trustee " + &
                         "  ORDER BY t1.jm_cd, t1.fund_cd "

         lR = SQLCA.sql2ds (parent.classname( ), ls_sqlsyntax, lds_jtier,'xml')

         FOR  lm = 1  TO  lR
             ls_fund_cd  = lds_jtier.GETITEMSTRING (lm,1)
             ls_fund_nm  = lds_jtier.GETITEMSTRING (lm,2)
             ls_trustee  = lds_jtier.GETITEMSTRING (lm,3)
             ls_jm_cd    = lds_jtier.GETITEMSTRING (lm,4)
             ls_jm_nm    = lds_jtier.GETITEMSTRING (lm,5)
             ls_currency = lds_jtier.GETITEMSTRING (lm,6)
             ldc_jusu    = lds_jtier.GETITEMNUMBER (lm,7)
             ldc_tax_per = lds_jtier.GETITEMNUMBER (lm,8)

            SELECT TO_CHAR(:ldt_ymd,'yyyymmdd') || '-' || join_seq.nextval
              INTO :ls_pyunga_join
              FROM DUAL ;

            ls_pyunga_join = SQLCA.GETITEMSTRING (1)

            ll                      = insertrow (0)
            Object.CORP_GR [ll]     = gaa.CORP_GR
            Object.p_visible [ll]   = 1
            Object.tr_ymd [ll]      = dw_c.object.ymd [1]
            Object.tr_cd [ll]       = dw_c.object.dddw [1]
            Object.tr_seq [ll]      = 1
            Object.fund_cd [ll]     = ls_fund_cd
            Object.fund_nm [ll]     = ls_fund_nm
            Object.trustee [ll]     = ls_trustee
            Object.yj_cd [ll]       = ls_jm_cd
            Object.xx_yj_cd [ll]    = ls_jm_nm
            Object.currency [ll]    = ls_currency
            Object.hwakj_ymd [ll]   = ldt_ymd
            Object.hwakj_jusu [ll]  = ldc_jusu
            Object.tax_per [ll]     = ldc_tax_per
            Object.pyunga_join [ll] = ls_pyunga_join
         NEXT
		ElseIF dw_c.object.dddw [1]<>'G92' THEN
         ls_trustee = Object.trustee [row]
         SELECT tax_per
           INTO :ldc_tax_per
           FROM SYX2MM t1
          WHERE t1.CORP_GR = :gaa.CORP_GR
            AND t1.trustee = :ls_trustee ;

         ldc_tax_per = SQLCA.GETITEMNUMBER (1)

         IF SQLCA.SQLCode( )=0 THEN Object.tax_per [row] = ldc_tax_per
      END IF
   CASE 'hwakj_per'
		IF dw_c.object.dddw [1]<>'G92' THEN
			ll_jusu = truncate (Object.hwakj_jusu [row] * dec (data) / 100,0)
			IF f_notnull (Object.aek [row])  Then
				Object.aek [row]     = truncate (ll_jusu * (Object.aek [row] / Object.jusu [row]),2)
				Object.tax_aek [row] = truncate (ll_jusu * (Object.tax_aek [row] / Object.jusu [row]),2)
			END IF
			Object.jusu [row] = ll_jusu
		End IF
   CASE 'aek'
      Object.tax_aek [row] = truncate (dec (data) * Object.tax_per [row] / 100,2)
END CHOOSE
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'yj_cd'
		IF	dw_c.object.dddw [1]<>'G92'	Then
	      rs_Where = "t2.ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
   	   RETURN 11
		End IF
END CHOOSE
RETURN 1
end event

event dw_list::rbuttondown;IF POS ('G32,G36',dw_c.object.dddw [1])>0 And dwo.name='yj_cd' Then
   OpenwithParm (w_ja035e_code, parent)
Else
   CALL super::rbuttondown
End IF
end event

event dw_list::updateend;call super::updateend;DATETIME	ldt_ymd, ldt_hwakj
STRING	ls_tr_cd, ls_fund, ls_jm, ls_trustee

LONG	ll
DEC	ldc_seq, ldc_bs_type

ldt_ymd = dw_c.object.ymd [1]

FOR  ll = rowcount ()  TO  1  STEP -1
   IF POS ('G32,G36',dw_c.object.dddw [1]) > 0  Then
      ls_tr_cd    = Object.tr_cd [ll]
      ldc_seq     = Object.tr_seq [ll]
      ls_fund     = Object.fund_cd [ll]
      ls_jm       = Object.jm_cd [ll]
      ldc_bs_type = Object.bs_type [ll]
      ls_trustee  = Object.trustee [ll]
      ldt_hwakj   = Object.hwakj_ymd [ll]

      UPDATE SYT0YG
         SET end_tr_cd = :ls_tr_cd
           , end_ymd   = :ldt_ymd
       WHERE CORP_GR   = :gaa.CORP_GR
         AND tr_ymd    = :ldt_ymd
         AND tr_cd     = :ls_tr_cd
         AND tr_seq    = :ldc_seq
         AND fund_cd   = :ls_fund
         AND jm_cd     = :ls_jm
         AND bs_type   = :ldc_bs_type
         AND trustee   = :ls_trustee
         AND hwakj_ymd = :ldt_hwakj ;
   END IF
NEXT
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

event dw_list::buttonup;IF POS ('G32,G36',dw_c.object.dddw [1])>0 And dwo.name='p_xx_yj_cd' Then
   OpenwithParm (w_ja035e_code, parent)
Else
   CALL super::buttonup
End IF
end event

