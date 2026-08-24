forward
global type w_ja035n from wt_list
end type
end forward

global type w_ja035n from wt_list
string is_date_nation = "US"
string is_init_value = "E72"
end type
global w_ja035n w_ja035n

type variables
DateTime idt_ymd
end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035n.create
int iCurrent
call super::create
end on

on w_ja035n.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035n
end type

type ln_templeft from wt_list`ln_templeft within w_ja035n
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035n
end type

type ln_temptop from wt_list`ln_temptop within w_ja035n
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035n
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035n
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035n
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035n
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035n
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035n
end type

type ln_tempright from wt_list`ln_tempright within w_ja035n
end type

type uo_navi from wt_list`uo_navi within w_ja035n
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035n
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035n
end type

type st_top_rect from wt_list`st_top_rect within w_ja035n
end type

type p_close from wt_list`p_close within w_ja035n
end type

type p_excel from wt_list`p_excel within w_ja035n
end type

type p_print from wt_list`p_print within w_ja035n
end type

type p_delete from wt_list`p_delete within w_ja035n
end type

type p_update from wt_list`p_update within w_ja035n
end type

type p_input from wt_list`p_input within w_ja035n
end type

type p_retrieve from wt_list`p_retrieve within w_ja035n
end type

type p_clear from wt_list`p_clear within w_ja035n
end type

type p_copy from wt_list`p_copy within w_ja035n
end type

type dw_c from wt_list`dw_c within w_ja035n
string tag = "거래비용, 발생비용은 2달전 말일기준 출금"
string title = "영업일자@거래코드"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'tr_ymd'
      IF DATETIME (DATE (MidA (data,1,10))) >= idt_workdate Then
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035N'")
      ELSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035N' and szx0gc.tr_cd in (select tr_cd from syt0ma where tr_ymd='" + MidA (data, 1, 10) + "')")
      END IF
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035N'")
end event

event dw_c::ue_valid;call super::ue_valid;DATETIME	ldt_f_value

ib_managedata = (object.ymd [1] >= idt_workdate)

idt_ymd = object.ymd [1]

SELECT F_OPEN_YMD( :idt_ymd, '+1' )
  INTO :ldt_f_value
FROM   DUAL;
ldt_f_value = SQLCA.getitemdatetime (1)

IF ib_manageData And Object.dddw [1]<>'E72' THEN idt_ymd = ldt_f_value

RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0MA t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_SJA035N')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035n
end type

type st_count from wt_list`st_count within w_ja035n
end type

type dw_list from wt_list`dw_list within w_ja035n
string dataobject = "d_ja035n"
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'currency', gaa.corp_gr, '', 1, "")
end event

event dw_list::retrieveend;IF NOT (ROWCOUNT = 0 AND ib_ManageData) OR dw_c.object.dddw [1] = 'E72' Then
   CALL super::retrieveend
   RETURN
END IF

DATETIME	ldt, ldt_haeji_ymd
STRING	ls_tr_cd, ls_fund, ls_nm, ls_trustee, ls_currency, ls_sqlsyntax

DEC	ldc_aek, ldc_won_aek, ldc_fcur_aek
LONG	lRow, lR, lj

aDS_jTier   lds_jtier

ls_tr_cd = dw_c.object.dddw [1]
ldt      = dw_c.object.ymd [1]

ls_sqlsyntax = " SELECT t1.fund_cd " + &
               "      , ia.fund_nm " + &
               "      , t1.trustee " + &
               "      , t1.currency " + &
               "      , ia.haeji_ymd " + &
               "      , NVL (t1.bfil_aek,0) + NVL (t1.up_aek,0) - NVL (t1.dw_aek,0) " + &
               "      , NVL (t1.won_bfil_aek,0) + NVL (t1.won_up_aek,0) - NVL (t1.won_dw_aek,0) " + &
               "      , NVL (t1.fcur_bfil_aek,0) + NVL (t1.fcur_up_aek,0) - NVL (t1.fcur_dw_aek,0) " + &
               "   FROM SYT0MC t1 " + &
               "      , SZM0IA ia " + &
               "  WHERE t1.CORP_GR = '" + gaa.corp_gr + "' " + &
               "    AND t1.tr_ymd  = LAST_DAY(ADD_MONTHS ('" + STRING(ldt,'yyyy.mm.dd') + "',-2)) " + &
               "    AND t1.tr_cd   = (CASE '" + ls_tr_cd + "' WHEN 'H21' THEN 'P40' WHEN 'H22' THEN 'P41' END) " + &
               "    AND ia.CORP_GR = t1.CORP_GR " + &
               "    AND ia.fund_cd = t1.fund_cd " + &
               "  ORDER BY t1.fund_cd " + &
               "         , t1.trustee " + &
               "         , t1.currency "

// ::clipboard (ls_sqlsyntax)
// messagebox('a',ls_sqlsyntax)

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_fund       = lds_jtier.GETITEMSTRING (lj, 1)
   ls_nm         = lds_jtier.GETITEMSTRING (lj, 2)
   ls_trustee    = lds_jtier.GETITEMSTRING (lj, 3)
   ls_currency   = lds_jtier.GETITEMSTRING (lj, 4)
   ldt_haeji_ymd = lds_jtier.getitemdatetime (lj,5)
   ldc_aek       = lds_jtier.GETITEMNUMBER (lj, 6)
   ldc_won_aek   = lds_jtier.GETITEMNUMBER (lj, 7)
   ldc_fcur_aek  = lds_jtier.GETITEMNUMBER (lj, 8)
   
   IF f_notnull (ldt_haeji_ymd)  Then
      SELECT NVL(SUM(NVL (t1.bfil_aek,0) + NVL (t1.up_aek,0) - NVL (t1.dw_aek,0)), 0)
           , NVL(SUM(NVL (t1.won_bfil_aek,0) + NVL (t1.won_up_aek,0) - NVL (t1.won_dw_aek,0)), 0)
           , NVL(SUM(NVL (t1.fcur_bfil_aek,0) + NVL (t1.fcur_up_aek,0) - NVL (t1.fcur_dw_aek,0)), 0)
        INTO :ldc_aek
           , :ldc_won_aek
           , :ldc_fcur_aek
        FROM SYT0MC t1
       WHERE t1.CORP_GR  = :gaa.CORP_GR
         AND t1.tr_ymd   = :idt_workdate
         AND t1.fund_cd  = :ls_fund
         AND t1.tr_cd    = (CASE :ls_tr_cd WHEN 'H21' THEN 'P40' WHEN 'H22' THEN 'P41' END)
         AND t1.trustee  = :ls_trustee
         AND t1.currency = :ls_currency ;
      
      ldc_aek      = SQLCA.GETITEMNUMBER (1)
      ldc_won_aek  = SQLCA.GETITEMNUMBER (2)
      ldc_fcur_aek = SQLCA.GETITEMNUMBER (3)
   END IF

   lRow = insertrow (0)
   
   Object.CORP_GR [lRow]      = gaa.CORP_GR
   Object.tr_ymd [lRow]       = dw_c.object.ymd [1]
   Object.tr_cd [lRow]        = dw_c.object.dddw [1]
   Object.fund_cd [lRow]      = ls_fund
   Object.xx_fund_cd [lRow]   = ls_nm
   Object.trustee [lRow]      = ls_trustee
   Object.currency [lRow]     = ls_currency
   Object.tr_seq [lRow]       = 1
   Object.gyulje_ymd [lRow]   = idt_ymd
   Object.bal_aek [lRow]      = ldc_aek
   Object.won_bal_aek [lRow]  = ldc_won_aek
   Object.fcur_bal_aek [lRow] = ldc_fcur_aek
   Object.tr_aek [lRow]       = ldc_aek
NEXT

CALL super::retrieveend
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt
STRING	ls

DEC	ldc_trans_rt

CHOOSE CASE DWO.NAME
   CASE 'trustee'
      SELECT currency
        INTO :ls
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :data ;
      IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
      
   CASE 'tr_aek'
      ldt = dw_c.object.ymd [1]
      ls  = Object.currency [row]
      IF f_notnull (ls) Then
         SELECT gijun_rt
           INTO :ldc_trans_rt
           FROM SYX1HY t1
          WHERE t1.CORP_GR   = :gaa.CORP_GR
            AND t1.gijun_ymd = :ldt
            AND t1.currency  = :ls ;
         IF SQLCA.SQLCode()=0 THEN Object.won_tr_aek [row] = truncate (dec (data) * SQLCA.GETITEMNUMBER (1),0)
      END IF
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('tr_seq', '1')
uf_setColumn ('gyulje_ymd', string (idt_ymd))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

