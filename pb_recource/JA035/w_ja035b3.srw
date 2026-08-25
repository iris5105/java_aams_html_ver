forward
global type w_ja035b3 from wt_list
end type
end forward

global type w_ja035b3 from wt_list
integer ii_dddw_width = 700
integer ii_rcd_width = 250
string is_date_nation = "US"
string is_init_value = "S10"
end type
global w_ja035b3 w_ja035b3

type variables

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035b3.create
int iCurrent
call super::create
end on

on w_ja035b3.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035b3
end type

type ln_templeft from wt_list`ln_templeft within w_ja035b3
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035b3
end type

type ln_temptop from wt_list`ln_temptop within w_ja035b3
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035b3
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035b3
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035b3
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035b3
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035b3
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035b3
end type

type ln_tempright from wt_list`ln_tempright within w_ja035b3
end type

type uo_navi from wt_list`uo_navi within w_ja035b3
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035b3
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035b3
end type

type st_top_rect from wt_list`st_top_rect within w_ja035b3
end type

type p_close from wt_list`p_close within w_ja035b3
end type

type p_excel from wt_list`p_excel within w_ja035b3
end type

type p_print from wt_list`p_print within w_ja035b3
end type

type p_delete from wt_list`p_delete within w_ja035b3
end type

type p_update from wt_list`p_update within w_ja035b3
end type

type p_input from wt_list`p_input within w_ja035b3
end type

type p_retrieve from wt_list`p_retrieve within w_ja035b3
end type

type p_clear from wt_list`p_clear within w_ja035b3
end type

type p_copy from wt_list`p_copy within w_ja035b3
end type

type dw_c from wt_list`dw_c within w_ja035b3
string title = "영업일자@매매구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035B3'")
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (object.ymd [1]>=idt_workdate or gnv_vari.is_user_id='yjs1992@hitel.net')
RETURN TRUE
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'ymd'
      IF datetime (date (MID (data,1,10)))>=idt_workdate Then
         ib_manageData = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035B3'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035B3' and szx0gc.tr_cd in (select tr_cd from syt0mg where corp_gr=':corp_gr' and tr_ymd='"+MID (data,1,10)+"')")
      End IF
END CHOOSE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

STRING	ls_tr_cd

ls_tr_cd = Object.dddw [1]

SELECT 1
  INTO :li_ret
  FROM SYT0MG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   = :ls_tr_cd
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035b3
end type

type st_count from wt_list`st_count within w_ja035b3
end type

type dw_list from wt_list`dw_list within w_ja035b3
string dataobject = "d_ja035b3"
end type

event dw_list::itemchanged;Datetime	ldt_ymd

STRING	ls_jm_cd, ls_currency

DECIMAL	ls_unit_aek

LONG	ll, ll_f_value

ldt_ymd = dw_c.object.ymd [1]

CHOOSE CASE dwo.name
   CASE 'fund_cd'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.fund_cd [ll]) THEN Object.fund_cd [ll] = data
      NEXT

   CASE 'yj_cd'
      FOR  ll = row + 1  TO  rowcount ()
            IF f_null (Object.yj_cd [ll]) THEN Object.yj_cd [ll] = data
      NEXT

      SELECT  unit_aek
       INTO  :ls_unit_aek
     FROM    sym0ya t1
     WHERE   t1.corp_gr = :gaa.corp_gr
       AND   t1.jm_cd   = :data;

		ls_unit_aek = SQLCA.getitemnumber (1)

      Object.unit_aek [row] = ls_unit_aek

   CASE 'trustee'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.trustee [ll]) THEN Object.trustee [ll] = data
      NEXT

      SELECT  currency
        INTO  :ls_currency
      FROM    syx2mm t1
      WHERE   t1.corp_gr = :gaa.corp_gr
        AND   t1.trustee = :data;

		ls_currency = SQLCA.getitemstring (1)

		SELECT F_CURRENCY_RT( :gaa.corp_gr, :ldt_ymd, :ls_currency )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)
      Object.currency [row] = ls_currency
      Object.trans_rt [row] = ll_f_value

      SELECT  jm_cd
        INTO  :ls_jm_cd
      FROM    sym0ya t1
      WHERE   t1.corp_gr   = :gaa.corp_gr
        AND   t1.currency  = :ls_currency
        AND   t1.gyulje_jm = 'Y';
		  
		ls_jm_cd = SQLCA.getitemstring (1)
		
      IF SQLCA.sqlcode ()=0 THEN Object.gyulje_jm_cd [row] = ls_jm_cd

   CASE 'tr_jusu'
      Object.tr_aek [row] = truncate (dec (data) * Object.tr_danga [row] * Object.unit_aek [row],2)
      Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row]))

   CASE 'tr_danga'
      Object.tr_aek [row] = truncate (dec (data) * Object.tr_jusu [row] * Object.unit_aek [row],2)
      Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row]))

   CASE 'tr_aek'
      Object.gyulje_aek [row] = f_num (data) + (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row]))

   CASE 'tr_tax'
//      IF dw_c.object.dddw [1]='S20' Then  Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) - (dec (data) + f_num (Object.tr_cost [row])) &
//      Else                                Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (dec (data) + f_num (Object.tr_cost [row]))
//     RETURN
      Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (dec (data) + f_num (Object.tr_cost [row]))

   CASE 'tr_cost'
         Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (f_num (Object.tr_tax [row]) + dec (data))


   CASE 'trans_rt'
      Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * dec (data),0)
      FOR  ll = row + 1  TO  rowcount ()
         IF f_num (Object.trans_rt [ll])=0 THEN Object.trans_rt [ll] = dec (data)
         Object.won_gyulje_aek [ll] = truncate (Object.gyulje_aek [ll] * dec (data),0)
      NEXT

   CASE 'currency'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.currency [ll]) THEN Object.currency [ll] = data
      NEXT

   CASE 'gyulje_jm_cd'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.gyulje_jm_cd [ll]) THEN Object.gyulje_jm_cd [ll] = data
      NEXT

   CASE 'won_gyulje_aek'
      Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * dec (data),0)
      RETURN
END CHOOSE

Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * f_num (Object.trans_rt [row]),0)
CALL super::itemchanged
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_co_cd', gaa.corp_gr, '', 1, "tr_gb in ('1','2')")
f_dddwctl (THIS, 'trustee', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'currency', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;STRING	ls_currency, ls_tr_cd, ls_sj_gb

IF f_null (Object.currency [getrow ()])   Then
   ls_currency = Object.trustee [getrow ()]

   SELECT  bank_cd
     INTO  :ls_currency
   FROM    szx2mm t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   tr_co_cd   = :ls_currency;
	  
	ls_currency = SQLCA.getitemstring (1)

Else
   ls_currency = Object.currency [getrow ()]
End IF

CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
		rs_Where = "nvl(haeji_ymd,'2999.12.31') > '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "'"
      RETURN 50
   CASE 'susu_tr_co_cd'
      rs_where = "used='1' and tr_co_cd in (select tr_co_cd from ssm0ss where corp_gr='" + gaa.corp_gr + "')"
   CASE 'yj_cd'
      IF POS ('E33,J93',dw_c.object.dddw [1])>0 Then
         rs_where = "currency='" + ls_currency + "'"
         RETURN 9
      Else
         ls_tr_cd = dw_c.object.dddw [1]

         SELECT  sebu_cd_efnm
           INTO  :ls_sj_gb
         FROM    szx0gr t1
         WHERE   t1.gr_cd   = 'B4'
           AND   t1.sebu_cd = :ls_tr_cd;

			ls_sj_gb = SQLCA.getitemstring (1)

         rs_where = "currency='" + ls_currency + "' and sj_gb='" + ls_sj_gb + "'"
      End IF
END CHOOSE
RETURN 3
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('tr_seq', '1')
uf_setColumn ('bs_type', '0')
uf_setColumn ('gyulje_ymd', string (dw_c.object.ymd [1]))
IF getrow ()>1 THEN uf_setColumn ('tr_co_cd', Object.tr_co_cd [getrow () - 1])

POST SetColumn ('tr_co_cd')

RETURN 0
end event

