forward
global type w_ja035d from wt_list
end type
end forward

global type w_ja035d from wt_list
integer ii_dddw_width2 = 300
string is_date_nation = "US"
string is_init_value = "G11"
end type
global w_ja035d w_ja035d

type variables
INT	itr_seq = 0
ads_jTier   ids_code
end variables

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
IF PosA ('G12,G17',ia_value [1]) > 0   Then
   f_visible (dw_list, FALSE, 'jusu')
   dw_list.object.aek_t.TEXT = '현금배당액'
ELSE
   dw_list.object.aek_t.TEXT = '주식배당액'
END IF
IF PosA ('G16,G17',ia_value [1])>0 THEN ids_code.retrieve (gaa.CORP_GR, ia_value [1], dw_c.object.ymd [1])
IF ib_manageData AND ia_value [1] = 'G11' Then
   IF F_MESSAGEBOX ('XLS0','') = 1  Then
      dw_list.POST EVENT ue_load ()
      dw_list.POST EVENT retrieveend (0)
      RETURN
   END IF
END IF
dw_list.retrieve (gaa.CORP_GR,dw_c.object.ymd [1],ia_value [1],f_nvl (dw_c.object.rcd [1],'%'))
end event

on w_ja035d.create
int iCurrent
call super::create
end on

on w_ja035d.destroy
call super::destroy
end on

event close;call super::close;DESTROY ids_code
end event

event wue_lastopen;call super::wue_lastopen;ids_code = CREATE ads_jTier
ids_code.DataObject = 'd_ja035d_code'
ids_code.SetTransObject (SQLCA)

dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035d
end type

type ln_templeft from wt_list`ln_templeft within w_ja035d
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035d
end type

type ln_temptop from wt_list`ln_temptop within w_ja035d
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035d
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035d
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035d
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035d
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035d
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035d
end type

type ln_tempright from wt_list`ln_tempright within w_ja035d
end type

type uo_navi from wt_list`uo_navi within w_ja035d
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035d
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035d
end type

type st_top_rect from wt_list`st_top_rect within w_ja035d
end type

type p_close from wt_list`p_close within w_ja035d
end type

type p_excel from wt_list`p_excel within w_ja035d
end type

type p_print from wt_list`p_print within w_ja035d
end type

type p_delete from wt_list`p_delete within w_ja035d
end type

type p_update from wt_list`p_update within w_ja035d
end type

type p_input from wt_list`p_input within w_ja035d
end type

type p_retrieve from wt_list`p_retrieve within w_ja035d
end type

type p_clear from wt_list`p_clear within w_ja035d
end type

type p_copy from wt_list`p_copy within w_ja035d
end type

type dw_c from wt_list`dw_c within w_ja035d
string tag = "권리대상 종목선택"
string title = "영업일자@권리구분@권리락종목"
string dataobject = "dc_ymd_dddw_xx"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt

CHOOSE CASE DWO.NAME
   CASE 'ymd'
      ldt = DATETIME (DATE (MidA (data,1,10)))

      IF ldt >= idt_workdate OR gaa.aams Then
         ib_manageData   = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035D'")
      ELSE
         ib_manageData   = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035D' and szx0gc.tr_cd in (select tr_cd from syt0yg where corp_gr=':corp_gr' and tr_ymd='" + MidA (data, 1, 10) + "')")
      END IF
   CASE 'rcd'
      Object.tag_text.TEXT = '(' + Object.currency [1] + ')'
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035D'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0YG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_SJA035D')
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

type btn_update from wt_list`btn_update within w_ja035d
end type

type st_count from wt_list`st_count within w_ja035d
end type

type dw_list from wt_list`dw_list within w_ja035d
string dataobject = "d_ja035d"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;itr_seq = ROWCOUNT
IF ib_manageData=FALSE OR ROWCOUNT >0 OR POS ('G11,G12',dw_c.object.dddw [1])=0 THEN RETURN

DATETIME	ldt_ymd
STRING	ls_fund_cd, ls_fund_nm, ls_trustee, ls_jm_cd, ls_jm_nm, ls_currency, ls_pyunga_join, ls_sqlsyntax

DEC	ldc_jusu, ldc_tax_per
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
               "      , t1.tr_bfil_jusu " + &
               "      , mm.tax_per " + &
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
               "  ORDER BY t1.jm_cd " + &
               "         , t1.fund_cd "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

uf_reset ()

FOR  lm = 1  TO  lR
    ls_fund_cd  = lds_jtier.GETITEMSTRING (lm, 1)
    ls_fund_nm  = lds_jtier.GETITEMSTRING (lm, 2)
    ls_trustee  = lds_jtier.GETITEMSTRING (lm, 3)
    ls_jm_cd    = lds_jtier.GETITEMSTRING (lm, 4)
    ls_jm_nm    = lds_jtier.GETITEMSTRING (lm, 5)
    ls_currency = lds_jtier.GETITEMSTRING (lm, 6)
    ldc_jusu    = lds_jtier.GETITEMNUMBER (lm, 7)
    ldc_tax_per = lds_jtier.GETITEMNUMBER (lm, 8)

   SELECT TO_CHAR(:ldt_ymd,'yyyymmdd') || '-' || join_seq.nextval
     INTO :ls_pyunga_join
     FROM DUAL ;

   ls_pyunga_join = SQLCA.GETITEMSTRING (1)

   ll = insertrow (0)
   
   Object.CORP_GR [ll]     = gaa.CORP_GR
   Object.p_visible [ll]   = 1
   Object.tr_ymd [ll]      = ldt_ymd
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

SELECT TO_CHAR(:idt_workdate,'yyyymmdd') || '-' || join_seq.nextval
  INTO :ls_pyunga_join
  FROM DUAL ;

ls_pyunga_join = SQLCA.GETITEMSTRING (1)

itr_seq ++

uf_SetColumn ('tr_ymd', STRING (dw_c.object.ymd [1]))
uf_SetColumn ('tr_cd', dw_c.object.dddw [1])
uf_SetColumn ('tr_seq', STRING (itr_seq))
uf_SetColumn ('hwakj_ymd', STRING (dw_c.object.ymd [1]))
uf_SetColumn ('bs_type', '0')
uf_SetColumn ('pyunga_join', ls_pyunga_join)

lRow = GETROW ()
IF lRow > 0 Then
   uf_SetColumn ('fund_cd', Object.fund_cd [lRow])
   uf_SetColumn ('fund_nm', Object.fund_nm [lRow])

   SetColumn ('trustee')
ELSE
   SetColumn ('fund_cd')
END IF

RETURN 0
end event

event dw_list::ue_load;call super::ue_load;//OLEOBJECT  xlapp, xlsub
//
//LONG	ret, r, ll
//
//STRING	ls_tr, ls_ymd, ls_yj_cd, ls_nm, ls_currency
//DATETIME	ldt
//
//ldt   = dw_c.object.ymd [1]
//ls_tr = dw_c.object.dddw [1]
//
//// Create the oleobject variable xlapp
//xlApp = CREATE OLEOBJECT
//
//// CONNECT to Excel and check the return code
//ret = xlApp.ConnectToObject ("", "excel.application")// 현재 실행되어 있는 엑셀 Connect
//IF ret < 0  Then
//   F_MESSAGEBOX ('XLS1', STRING (ret))
//   RETURN
//END IF
//
//// Make Excel visible
//xlApp.Application.VISIBLE = TRUE
//
//xlsub = xlapp.Application.ActiveSheet
//
//uf_SetColumn ('tr_ymd', STRING (ldt))
//uf_SetColumn ('tr_cd', ls_tr)
//
//FOR  r = 1  TO  9999
//   IF ls_tr = 'G25'  Then
//      IF TRIM (STRING (xlsub.cells (r,7).VALUE)) <> '730'   Then
//         IF f_null (xlsub.cells (r,7).VALUE) Then
//            EXIT
//         ELSE
//            CONTINUE
//         END IF
//      END IF
//   END IF
//
//   ls_ymd   = TRIM (STRING (xlsub.cells (r, 2).VALUE))
//   ls_yj_cd = TRIM (STRING (xlsub.cells (r, 5).VALUE))
//   IF f_null (ls_yj_cd) THEN EXIT
//
//   ls_nm = TRIM (STRING (xlsub.cells (r, 6).VALUE))
//
//   IF ls_ymd = STRING (ldt,'yyyymmdd') Then
//      SELECT jm_nm
//           , currency
//        INTO :ls_nm
//           , :ls_currency
//        FROM SYM0YA t1
//       WHERE t1.CORP_GR = :gaa.CORP_GR
//         AND t1.jm_cd   = :ls_yj_cd ;
//      
//      ls_nm       = SQLCA.GETITEMSTRING (1)
//      ls_currency = SQLCA.GETITEMSTRING (2)
//      
//      IF SQLCA.SQLCode() <> 0 Then
//         F_MESSAGEBOX ('I002', STRING (r) + '번째 자료의 (' + ls_yj_cd + ') 종목코드를 확인하십시오.')
//         EXIT
//      END IF
//
//      ll = insertrow (0)
//		
//      Object.CORP_GR [ll]     = gaa.CORP_GR
//      Object.p_visible [ll]   = 1
//      Object.yj_cd [ll]       = ls_yj_cd
//      Object.xx_yj_cd [ll]    = ls_nm
//      Object.xx_currency [ll] = ls_currency
//      Object.hwakj_ymd [ll]   = ldt
//      Object.hwakj_jusu [ll]  = dec (xlsub.cells (r, 13).VALUE)
//      Object.aek [ll]         = dec (xlsub.cells (r, 16).VALUE)
//      Object.tax_aek [ll]     = dec (xlsub.cells (r, 21).VALUE)
//      Object.won_aek [ll]     = dec (xlsub.cells (r, 17).VALUE)
//      Object.hwakj_per [ll]   = dec (xlsub.cells (r, 22).VALUE)
//   END IF
//NEXT
//
//// clean up
//xlapp.DISCONNECTOBJECT ()
//DESTROY xlapp
//
//xlsub.DISCONNECTOBJECT ()
//DESTROY xlsub
//
//wf_setenabled ()
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_trustee

LONG	ll
DEC	ldc_tax_per

CHOOSE CASE DWO.NAME
   CASE 'yj_cd'
      ls_trustee = Object.trustee [row]

      SELECT tax_per
        INTO :ldc_tax_per
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :ls_trustee ;
      IF SQLCA.SQLCode()=0 THEN Object.tax_per [row] = SQLCA.GETITEMNUMBER (1)

   CASE 'hwakj_per'
      IF dw_c.object.dddw [1] = 'G11'  Then
         FOR  ll = ROW  TO  rowcount ()
            IF Object.yj_cd [ll] = Object.yj_cd [row] Then
               Object.hwakj_per [ll] = dec (data)
               Object.jusu [ll]      = truncate (Object.hwakj_jusu [ll] * dec (data) / 100,0)
            ELSE
               EXIT
            END IF
         NEXT
      ELSEIF dw_c.object.dddw [1] = 'G12' Then
         FOR  ll = ROW  TO  rowcount ()
            IF Object.yj_cd [ll] = Object.yj_cd [row] Then
               Object.hwakj_per [ll] = dec (data)
            ELSE
               EXIT
            END IF
         NEXT
      END IF
   CASE 'aek'
      Object.tax_aek [row]    = truncate (dec (data) * Object.tax_per [row] / 100,2)
      Object.gyulje_aek [row] = dec (data) - F_NUM (Object.tax_aek [row])
   CASE 'tax_aek'
      Object.gyulje_aek [row] = F_NUM (Object.aek [row]) - dec (data)
   CASE 'gyulje_aek'
      Object.aek [row] = dec (data) + F_NUM (Object.tax_aek [row])
END CHOOSE
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'yj_cd'
      rs_Where = "t2.ymd = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
      RETURN 11
END CHOOSE
RETURN 1
end event

event dw_list::rbuttondown;IF POS ('G16,G17',dw_c.object.dddw [1])>0 And dwo.name='yj_cd' Then
   OpenwithParm (w_ja035d_code, parent)
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
   IF POS ('G16,G17',dw_c.object.dddw [1]) > 0  Then
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

event dw_list::ue_copyrowset;call super::ue_copyrowset;STRING	ls_pyunga_join

SELECT TO_CHAR(:idt_workdate,'yyyymmdd') || '-' || join_seq.nextval
  INTO :ls_pyunga_join
  FROM DUAL ;

ls_pyunga_join = SQLCA.GETITEMSTRING (1)

itr_seq ++
Object.tr_seq [row]      = itr_seq
Object.pyunga_join [row] = ls_pyunga_join
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

