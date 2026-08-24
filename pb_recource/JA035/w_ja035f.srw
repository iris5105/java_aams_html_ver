forward
global type w_ja035f from wt_list
end type
end forward

global type w_ja035f from wt_list
integer ii_dddw_width2 = 300
integer ii_rcd_width = 500
string is_date_nation = "US"
string is_init_value = "G53"
end type
global w_ja035f w_ja035f

type variables

end variables

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035f.create
int iCurrent
call super::create
end on

on w_ja035f.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035f
end type

type ln_templeft from wt_list`ln_templeft within w_ja035f
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035f
end type

type ln_temptop from wt_list`ln_temptop within w_ja035f
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035f
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035f
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035f
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035f
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035f
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035f
end type

type ln_tempright from wt_list`ln_tempright within w_ja035f
end type

type uo_navi from wt_list`uo_navi within w_ja035f
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035f
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035f
end type

type st_top_rect from wt_list`st_top_rect within w_ja035f
end type

type p_close from wt_list`p_close within w_ja035f
end type

type p_excel from wt_list`p_excel within w_ja035f
end type

type p_print from wt_list`p_print within w_ja035f
end type

type p_delete from wt_list`p_delete within w_ja035f
end type

type p_update from wt_list`p_update within w_ja035f
end type

type p_input from wt_list`p_input within w_ja035f
end type

type p_retrieve from wt_list`p_retrieve within w_ja035f
end type

type p_clear from wt_list`p_clear within w_ja035f
end type

type p_copy from wt_list`p_copy within w_ja035f
end type

type dw_c from wt_list`dw_c within w_ja035f
string tag = "변경전 종목을 선택하면 보유내역 생성"
string title = "영업일자@권리구분@변경전종목"
string dataobject = "dc_ymd_dddw_xx"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt

CHOOSE CASE DWO.NAME
   CASE 'ymd'
      ldt = DATETIME (DATE (MidA (data,1,10)))
      IF ldt >= idt_workdate  Then
         ib_manageData   = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035F'")
      ELSE
         ib_manageData   = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035F' and szx0gc.tr_cd in (select tr_cd from syt0yg where corp_gr=':corp_gr' and tr_ymd='" + MidA (data, 1, 10) + "')")
      END IF
   CASE 'rcd'
      Object.tag_text.TEXT = '(' + Object.currency [1] + ')'
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035F'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0YG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_SJA035F')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'rcd'
      rs_Where = "t2.ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
      RETURN 13
END CHOOSE
RETURN 1
end event

type btn_update from wt_list`btn_update within w_ja035f
end type

type st_count from wt_list`st_count within w_ja035f
end type

type dw_list from wt_list`dw_list within w_ja035f
string dataobject = "d_ja035f"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;IF f_null (dw_c.object.rcd [1]) THEN RETURN

DATETIME	ldt_ymd

STRING	ls_fund_cd, ls_fund_nm, ls_trustee, ls_jm_cd, ls_jm_nm, ls_currency, ls_pyunga_join
STRING	ls_sqlsyntax

DEC	ldc_jusu, ldc_aek, ldc_won

LONG	ll, lR, lm

aDS_jTier   lds_jtier

ldt_ymd     = dw_c.object.ymd [1]
ls_jm_cd    = dw_c.object.rcd [1]
ls_currency = dw_c.object.currency [1]

ls_sqlsyntax = " SELECT t1.fund_cd " + &
               "      , t3.fund_nm " + &
               "      , t1.trustee " + &
               "      , t1.jm_cd " + &
               "      , t2.jm_nm " + &
               "      , t1.currency " + &
               "      , NVL(t1.tr_bfil_jusu,0) + NVL(t1.tr_up_jusu,0) + NVL(t1.RIGHT_JUSU,0) " + &
               "      , NVL(t1.tr_bfil_chui_aek,0) + NVL(t1.tr_up_chui_aek,0) + NVL(t1.RIGHT_AEK,0) " + &
               "      , NVL(t1.won_bfil_chui_aek,0) + NVL(t1.won_up_chui_aek,0) + NVL(t1.RIGHT_WON_AEK,0) " + &
               "   FROM SYM0YZ t1 " + &
               "      , SYM0YA t2 " + &
               "      , SZM0IA t3 " + &
               "  WHERE t1.CORP_GR  = '" + gaa.corp_gr + "' " + &
               "    AND t1.ymd      = '" + STRING(ldt_ymd,'yyyy.mm.dd') + "' " + &
               "    AND t1.jm_cd    = '" + ls_jm_cd + "' " + &
               "    AND t2.CORP_GR  = t1.CORP_GR " + &
               "    AND t2.jm_cd    = t1.jm_cd " + &
               "    AND t2.currency = '" + ls_currency + "' " + &
               "    AND t2.jasan_gb = '1' " + &
               "    AND t3.CORP_GR  = t1.CORP_GR " + &
               "    AND t3.fund_cd  = t1.fund_cd " + &
               "  ORDER BY t1.jm_cd " + &
               "         , t1.fund_cd "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lm = 1  TO  lR
    ls_fund_cd  = lds_jtier.GETITEMSTRING (lm, 1)
    ls_fund_nm  = lds_jtier.GETITEMSTRING (lm, 2)
    ls_trustee  = lds_jtier.GETITEMSTRING (lm, 3)
    ls_jm_cd    = lds_jtier.GETITEMSTRING (lm, 4)
    ls_jm_nm    = lds_jtier.GETITEMSTRING (lm, 5)
    ls_currency = lds_jtier.GETITEMSTRING (lm, 6)
    ldc_jusu    = lds_jtier.GETITEMNUMBER (lm, 7)
    ldc_aek     = lds_jtier.GETITEMNUMBER (lm, 8)
    ldc_won     = lds_jtier.GETITEMNUMBER (lm, 9)

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
   Object.jusu [ll]        = ldc_jusu
   Object.aek [ll]         = ldc_aek
   Object.won_aek [ll]     = ldc_won
   Object.hwakj_ymd [ll]   = dw_c.object.ymd [1]
   Object.pyunga_join [ll] = ls_pyunga_join
   Object.end_tr_cd [ll]   = dw_c.object.dddw [1]
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

lRow = GetRow ()
IF lRow>0   Then
   uf_SetColumn ('fund_cd', Object.fund_cd [lRow])
   uf_SetColumn ('fund_nm', Object.fund_nm [lRow])

   SetColumn ('trustee')
Else
   SetColumn ('fund_cd')
End IF

uf_SetColumn ('end_tr_cd', dw_c.object.dddw [1])
uf_SetColumn ('end_ymd', string (dw_c.object.ymd [1]))

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'yj_cd'
      rs_Where = "t2.ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
      RETURN 11
END CHOOSE
RETURN 1
end event

event dw_list::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1
IF	dwo.name='g53_yj_cd'	Then
	LONG	ll, ll_cnt
	ll_cnt = rowcount ()
	FOR  ll = 1  to  ll_cnt
		IF	f_null (Object.g53_yj_cd [ll]) THEN Object.g43_yj_cd [ll] = data
	NEXT
End IF
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

