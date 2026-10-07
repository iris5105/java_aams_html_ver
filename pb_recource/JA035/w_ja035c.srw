forward
global type w_ja035c from wt_list
end type
end forward

global type w_ja035c from wt_list
integer ii_rcd_width = 250
string is_date_nation = "US"
end type
global w_ja035c w_ja035c

type variables
LONG	il_tr_seq
end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1])
end event

on w_ja035c.create
int iCurrent
call super::create
end on

on w_ja035c.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035c
end type

type ln_templeft from wt_list`ln_templeft within w_ja035c
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035c
end type

type ln_temptop from wt_list`ln_temptop within w_ja035c
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035c
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035c
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035c
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035c
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035c
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035c
end type

type ln_tempright from wt_list`ln_tempright within w_ja035c
end type

type uo_navi from wt_list`uo_navi within w_ja035c
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035c
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035c
end type

type st_top_rect from wt_list`st_top_rect within w_ja035c
end type

type p_close from wt_list`p_close within w_ja035c
end type

type p_excel from wt_list`p_excel within w_ja035c
end type

type p_print from wt_list`p_print within w_ja035c
end type

type p_delete from wt_list`p_delete within w_ja035c
end type

type p_update from wt_list`p_update within w_ja035c
end type

type p_input from wt_list`p_input within w_ja035c
end type

type p_retrieve from wt_list`p_retrieve within w_ja035c
end type

type p_clear from wt_list`p_clear within w_ja035c
end type

type p_copy from wt_list`p_copy within w_ja035c
end type

type dw_c from wt_list`dw_c within w_ja035c
string title = "영업일자@거래코드"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'ymd'
      IF DATETIME (DATE (MID (data,1,10))) >= idt_workdate  Then
         ib_manageData   = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035C'")
      ELSE
         ib_manageData   = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035C' and szx0gc.tr_cd in (select tr_cd from syt0yh where corp_gr=':corp_gr' and tr_ymd='" + STRING (Object.ymd [1], 'yyyy.mm.dd') + "')")
      END IF
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035C'")
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0YH t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_SJA035C')
   AND ROWNUM = 1 ;
  li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035c
end type

type st_count from wt_list`st_count within w_ja035c
end type

type dw_list from wt_list`dw_list within w_ja035c
string dataobject = "d_ja035c"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt
STRING	ls_currency

LONG	ll
DEC	ldc_rt

ldt = dw_c.object.ymd [1]

CHOOSE CASE DWO.NAME
   CASE 'fund_cd'
      FOR  ll = (ROW + 1)  TO  rowcount ()
         IF isNull (Object.fund_cd [ll]) OR Object.fund_cd [ll]=Object.fund_cd [row]   THEN Object.fund_cd [ll] = data
      NEXT
   CASE 'trustee'
      SELECT currency
        INTO :ls_currency
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :data ;

      ls_currency           = SQLCA.GETITEMSTRING (1)
      Object.currency [row] = ls_currency
      
        SELECT F_CURRENCY_RT(:gaa.CORP_GR,:ldt,:ls_currency) INTO :ldc_RT FROM DUAL;
      ldc_rt = SQLCA.GETITEMNUMBER (1)
      IF ldc_rt <> -1   Then
         Object.trans_rt [row]       = ldc_rt
         Object.won_gyulje_aek [row] = truncate (f_num (Object.gyulje_aek [row]) * ldc_rt,0)
      END IF
      
   CASE 'currency'
        SELECT F_CURRENCY_RT(:gaa.CORP_GR,:ldt,:data) INTO :ldc_rt FROM DUAL;
      ldc_rt = SQLCA.GETITEMNUMBER (1)
      IF ldc_rt <> -1   Then
         Object.trans_rt [row]       = ldc_rt
         Object.won_gyulje_aek [row] = truncate (f_num (Object.gyulje_aek [row]) * ldc_rt,0)
      END IF
      
   CASE 'gyulje_aek'
      Object.won_gyulje_aek [row] = Object.trans_rt [row] * dec (data)
   CASE 'trans_rt'
      Object.won_gyulje_aek [row] = Object.gyulje_aek [row] * dec (data)
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'currency', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;STRING	ls_cur

CHOOSE CASE GetColumnName ()
   CASE 'yj_cd'
      IF f_null (Object.currency [iRow])   Then
         ls_cur = Object.trustee [iRow]
      
         SELECT bank_cd
           INTO :ls_cur
           FROM SZX2MM t1
          WHERE t1.CORP_GR  = :gaa.CORP_GR
            AND t1.tr_co_cd = :ls_cur ;
         IF SQLCA.sqlcode ()=0 THEN ls_cur = SQLCA.GETITEMSTRING (1)
      ELSE
         ls_cur = Object.currency [iRow]
      END IF
      rs_Where = "currency='" + ls_cur + "'"
      RETURN 5
END CHOOSE
RETURN 1
end event

event dw_list::retrieveend;call super::retrieveend;LONG	ret, r, lRow

FOR  r = 1  TO  rowcount
	il_tr_seq = MAX (il_tr_seq, Object.tr_seq [r])
NEXT

IF dw_c.object.dddw [1] <> 'Z91' OR ib_manageData = FALSE   Then
   IF ROWCOUNT =0 THEN POST EVENT ue_insert (0)
   RETURN
END IF

IF F_MESSAGEBOX ('XLS0','')<>1 THEN RETURN

OLEOBJECT   xlapp, xlsub

STRING	ls_ymd, ls_fund_nm, ls_samu_jm_cd
STRING	ls_jm_cd, ls_jm_nm, ls_currency

uf_setColumn ('tr_ymd', STRING (dw_c.object.ymd [1]))
uf_setColumn ('gyulje_ymd', STRING (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('tr_seq', '1')

// Create the oleobject variable xlapp
xlApp = CREATE OLEOBJECT

// Connect to Excel and check the return code
ret = xlApp.ConnectToObject ("", "excel.application")// 현재 실행되어 있는 엑셀 Connect
IF ret < 0  Then
   F_MESSAGEBOX ('XLS1', STRING (ret))
   RETURN
END IF

// Make Excel visible
xlApp.Application.VISIBLE = TRUE

xlsub = xlapp.Application.ActiveSheet

FOR  r = 1  TO  9999
   ls_ymd        = TRIM (STRING (xlsub.cells (r, 1).VALUE))  ;  IF f_null (ls_ymd) THEN EXIT
   ls_fund_nm    = TRIM (STRING (xlsub.cells (r, 3).VALUE))
   ls_samu_jm_cd = TRIM (STRING (xlsub.cells (r, 4).VALUE))

   IF dec (xlsub.cells (r,8).VALUE) > 0   Then
      SELECT jm_cd
           , jm_nm
           , currency
        INTO :ls_jm_cd
           , :ls_jm_nm
           , :ls_currency
        FROM SYM0YA t1
       WHERE t1.CORP_GR  = :gaa.CORP_GR
         AND t1.jm_cd    = :ls_samu_jm_cd
         AND t1.jasan_gb = '5' ;

      ls_jm_cd    = SQLCA.GETITEMSTRING (1)
      ls_jm_nm    = SQLCA.GETITEMSTRING (2)
      ls_currency = SQLCA.GETITEMSTRING (3)

      lRow = insertrow (0)

      Object.CORP_GR [lRow]        = gaa.CORP_GR
      Object.p_visible [lRow]      = 1
      Object.xx_fund_cd [lRow]     = ls_fund_nm
      Object.yj_cd [lRow]          = ls_jm_cd
      Object.xx_yj_cd [lRow]       = ls_jm_nm
      Object.currency [lRow]       = ls_currency
      Object.gyulje_aek [lRow]     = dec (xlsub.cells (r, 8).VALUE)
      Object.won_gyulje_aek [lRow] = dec (xlsub.cells (r, 9).VALUE)

      ScrollToRow (lRow)
   END IF
NEXT

// clean up
xlapp.DISCONNECTOBJECT ()
DESTROY xlapp

xlsub.DISCONNECTOBJECT ()
DESTROY xlsub

wf_setenabled ()
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
il_tr_seq ++
uf_setColumn ('tr_seq', string (il_tr_seq))
uf_setColumn ('gyulje_ymd', string (dw_c.object.ymd [1]))

SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

