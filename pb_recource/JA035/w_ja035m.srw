forward
global type w_ja035m from wt_list
end type
end forward

global type w_ja035m from wt_list
string is_date_nation = "US"
string is_init_value = "E69"
end type
global w_ja035m w_ja035m

type variables

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035m.create
int iCurrent
call super::create
end on

on w_ja035m.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035m
end type

type ln_templeft from wt_list`ln_templeft within w_ja035m
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035m
end type

type ln_temptop from wt_list`ln_temptop within w_ja035m
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035m
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035m
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035m
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035m
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035m
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035m
end type

type ln_tempright from wt_list`ln_tempright within w_ja035m
end type

type uo_navi from wt_list`uo_navi within w_ja035m
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035m
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035m
end type

type st_top_rect from wt_list`st_top_rect within w_ja035m
end type

type p_close from wt_list`p_close within w_ja035m
end type

type p_excel from wt_list`p_excel within w_ja035m
end type

type p_print from wt_list`p_print within w_ja035m
end type

type p_delete from wt_list`p_delete within w_ja035m
end type

type p_update from wt_list`p_update within w_ja035m
end type

type p_input from wt_list`p_input within w_ja035m
end type

type p_retrieve from wt_list`p_retrieve within w_ja035m
end type

type p_clear from wt_list`p_clear within w_ja035m
end type

type p_copy from wt_list`p_copy within w_ja035m
end type

type dw_c from wt_list`dw_c within w_ja035m
string title = "영업일자@거래코드"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'ymd'
      IF DATETIME (DATE (MidA (data,1,10))) >= idt_workdate Then
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035M'")
      ELSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035M' and szx0gc.tr_cd in (select tr_cd from syt0ma where tr_ymd='" + MidA (data, 1, 10) + "')")
      END IF
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035M'")
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
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
                       WHERE ta.obj_id = 'W_SJA035M')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035m
end type

type st_count from wt_list`st_count within w_ja035m
end type

type dw_list from wt_list`dw_list within w_ja035m
string dataobject = "d_ja035m"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'currency', gaa.corp_gr, '', 1, "")
end event

event dw_list::retrieveend;IF NOT (rowcount =0 And ib_ManageData) OR dw_c.object.dddw [1]='E72'  Then
   CALL super::retrieveend
   RETURN
End IF

DateTime ldt

STRING	ls_tr_cd, ls_fund, ls_trustee, ls_currency, ls_sqlsyntax

DEC	ldc_aek, ldc_won_aek

LONG	lRow, lR, ll

aDS_jTier	lds_jtier

ls_tr_cd = dw_c.object.dddw [1]
ldt = dw_c.object.ymd [1]

ls_sqlsyntax = "   SELECT  fund_cd " &
             + "         , trustee " &
             + "         , currency " &
             + "         , NVL (bfil_aek,0) + nvl (up_aek,0) - nvl (dw_aek,0) " &
             + "         , NVL (won_bfil_aek,0) + nvl (won_up_aek,0) - nvl (won_dw_aek,0) " &
             + "   FROM    syt0mc t1 " &
             + "   WHERE   t1.corp_gr = '" + gaa.corp_gr + "' " &
             + "     AND   t1.tr_ymd  = '" + STRING(ldt,'yyyy.mm.dd') + "' " &
             + "     AND   t1.tr_cd   = (CASE '" + ls_tr_cd + "' WHEN 'H21' THEN 'P40' WHEN 'H22' THEN 'P41' END) " &
             + "   ORDER BY  fund_cd " &
             + "           , trustee " &
             + "           , currency "
				 
lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  ll = 1  TO  lR
    ls_fund     = lds_jtier.getitemstring (ll, 1)
    ls_trustee  = lds_jtier.getitemstring (ll, 2)
    ls_currency = lds_jtier.getitemstring (ll, 3)
    ldc_aek     = lds_jtier.getitemnumber (ll, 4)
    ldc_won_aek = lds_jtier.getitemnumber (ll, 5)

   uf_setColumn ('corp_gr', gaa.corp_gr)
   uf_setColumn ('fund_cd', ls_fund)
   uf_setColumn ('trustee', ls_trustee)
   uf_setColumn ('currency', ls_currency)
   uf_setColumn ('tr_seq', '1')
   uf_setColumn ('bal_aek', string (ldc_aek))
   uf_setColumn ('won_bal_aek', string (ldc_won_aek))

   lRow = EVENT ue_insert (0)
   Object.gyulje_ymd [lRow] = idt_workdate
   Object.tr_aek [lRow] = ldc_aek
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
      
   CASE 'tax_aek'
      ldt = dw_c.object.ymd [1]
      ls  = Object.currency [row]
      IF f_notnull (ls) Then
         SELECT gijun_rt
           INTO :ldc_trans_rt
           FROM SYX1HY t1
          WHERE t1.CORP_GR   = :gaa.CORP_GR
            AND t1.gijun_ymd = :ldt
            AND t1.currency  = :ls ;
         IF SQLCA.SQLCode()=0 THEN Object.won_tax_aek [row] = truncate (dec (data) * SQLCA.GETITEMNUMBER (1),0)
      END IF
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('tr_seq', '1')
uf_setColumn ('gyulje_ymd', string (idt_workdate))

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

