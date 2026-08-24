forward
global type w_ja035k from wt_list
end type
end forward

global type w_ja035k from wt_list
integer ii_dddw_width2 = 450
string is_date_nation = "US"
string is_init_value = "J61"
end type
global w_ja035k w_ja035k

type variables
STRING	is_fund_cd, is_jm_cd, is_jm_nm, is_currency, is_acct_nm

DEC	idc_trans_rt
end variables

forward prototypes
public function long uf_fund_cd (datetime arg_tr_ymd, string arg_tr_co_cd, string arg_acct_no)
public function long uf_gyulje_jm (string arg_currency)
public function long uf_jm_cd (string arg_jm_cd, string arg_xx_jm_cd, string arg_isin_cd, string arg_currency)
public subroutine uf_syt1ld_yesu (datetime arg_ymd, string arg_fund_cd, string arg_currency, decimal arg_tr_aek, decimal arg_won_aek)
public function long uf_trans_rt (datetime arg_gijun_ymd, string arg_currency)
end prototypes

public function long uf_fund_cd (datetime arg_tr_ymd, string arg_tr_co_cd, string arg_acct_no);DATETIME	ldt

SELECT MAX(open_ymd)
  INTO :ldt
  FROM SZX2MA t1
 WHERE t1.CORP_GR     = :gaa.CORP_GR
   AND t1.fund_cd IS NOT NULL
   AND t1.tr_co_cd    = :arg_tr_co_cd
   AND t1.enc_acct_no = TO_ENCRYPTS(:arg_acct_no)
   AND :arg_tr_ymd    Between open_ymd AND close_ymd ;
  ldt = SQLCA.getitemdatetime (1)
IF f_null (ldt)   Then
   SELECT MAX(open_ymd)
     INTO :ldt
     FROM SZX2MA t1
    WHERE t1.CORP_GR     = :gaa.CORP_GR
      AND t1.fund_cd IS NOT NULL
      AND t1.tr_co_cd    = :arg_tr_co_cd
      AND t1.enc_acct_no = TO_ENCRYPTS(:arg_acct_no)
      AND t1.open_ymd    <= :arg_tr_ymd ;
     ldt = SQLCA.getitemdatetime (1)
END IF

is_fund_cd = ''
is_acct_nm = ''

SELECT fund_cd
     , acct_nm
  INTO :is_fund_cd
     , :is_acct_nm
  FROM SZX2MA t1
 WHERE t1.CORP_GR     = :gaa.CORP_GR
   AND t1.tr_co_cd    = :arg_tr_co_cd
   AND t1.enc_acct_no = TO_ENCRYPTS(:arg_acct_no)
   AND t1.open_ymd    = :ldt ;
  is_fund_cd = SQLCA.GETITEMSTRING (1)
  is_acct_nm = SQLCA.GETITEMSTRING (2)

IF SQLCA.sqlcode () = 100  Then
   RETURN 100
ELSE
   IF f_null (is_fund_cd)  Then
      RETURN 99
   ELSE
      RETURN SQLCA.sqlcode ()
   END IF
END IF
end function

public function long uf_gyulje_jm (string arg_currency);is_jm_cd    = ''
is_jm_nm    = ''
is_currency = ''

SELECT jm_cd
     , jm_nm
     , currency
  INTO :is_jm_cd
     , :is_jm_nm
     , :is_currency
  FROM SYM0YA t1
 WHERE t1.CORP_GR    = :gaa.CORP_GR
   AND t1.currency   = :arg_currency
   AND t1.sanghw_ymd >= :idt_workdate
   AND t1.gyulje_jm  = 'Y' ;
	
is_jm_cd    = SQLCA.GETITEMSTRING (1)
is_jm_nm    = SQLCA.GETITEMSTRING (2)
is_currency = SQLCA.GETITEMSTRING (3)

RETURN SQLCA.sqlcode ()
end function

public function long uf_jm_cd (string arg_jm_cd, string arg_xx_jm_cd, string arg_isin_cd, string arg_currency);is_jm_cd    = ''
is_jm_nm    = ''
is_currency = ''

IF f_notnull (arg_jm_cd)   Then
   SELECT jm_cd
        , jm_nm
        , currency
     INTO :is_jm_cd
        , :is_jm_nm
        , :is_currency
     FROM SYM0YA t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND t1.jm_cd   = :arg_jm_cd ;
   is_jm_cd    = SQLCA.GETITEMSTRING (1)
   is_jm_nm    = SQLCA.GETITEMSTRING (2)
   is_currency = SQLCA.GETITEMSTRING (3)

ELSEIF f_notnull (arg_isin_cd)   Then
   SELECT jm_cd
        , jm_nm
        , currency
     INTO :is_jm_cd
        , :is_jm_nm
        , :is_currency
     FROM SYM0YA t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND t1.isin_cd = :arg_isin_cd ;

   is_jm_cd    = SQLCA.GETITEMSTRING (1)
   is_jm_nm    = SQLCA.GETITEMSTRING (2)
   is_currency = SQLCA.GETITEMSTRING (3)
ELSE
   SELECT jm_cd
        , jm_nm
        , currency
     INTO :is_jm_cd
        , :is_jm_nm
        , :is_currency
     FROM SYM0YA t1
    WHERE t1.CORP_GR             = :gaa.CORP_GR
      AND t1.currency            LIKE :arg_currency
      AND REPLACE(t1.jm_nm,' ')  = REPLACE(:arg_xx_jm_cd,' ','') ;
      
   is_jm_cd    = SQLCA.GETITEMSTRING (1)
   is_jm_nm    = SQLCA.GETITEMSTRING (2)
   is_currency = SQLCA.GETITEMSTRING (3)
END IF
RETURN SQLCA.sqlcode ()
end function

public subroutine uf_syt1ld_yesu (datetime arg_ymd, string arg_fund_cd, string arg_currency, decimal arg_tr_aek, decimal arg_won_aek);STRING	ls_currency

ls_currency = arg_currency
IF arg_currency='원화' THEN ls_currency = 'KRW'

UPDATE SYT1LD_YESU
   SET cur_aek  = :arg_tr_aek
     , won_aek  = :arg_won_aek
 WHERE CORP_GR  = :gaa.CORP_GR
   AND fund_cd  = :arg_fund_cd
   AND ymd      = :arg_ymd
   AND currency = upper(:ls_currency) ;
  
IF SQLCA.sqlnrows() = 0 Then
   INSERT INTO SYT1LD_YESU
   VALUES ( :gaa.CORP_GR
          , :arg_ymd
          , :arg_fund_cd
          , upper(:ls_currency) 
          , :arg_tr_aek
          , :arg_won_aek
          , NULL
          ) ;
END IF
commitJ ();
end subroutine

public function long uf_trans_rt (datetime arg_gijun_ymd, string arg_currency);idc_trans_rt = 0

SELECT gijun_rt
  INTO :idc_trans_rt
  FROM SYX1HY t1
 WHERE t1.CORP_GR   = :gaa.CORP_GR
   AND t1.gijun_ymd = f_open_ymd(:arg_gijun_ymd,'-')
   AND t1.currency  = :arg_currency ;

idc_trans_rt = SQLCA.GETITEMNUMBER (1)

RETURN SQLCA.sqlcode ()
end function

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035k.create
int iCurrent
call super::create
end on

on w_ja035k.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035k
end type

type ln_templeft from wt_list`ln_templeft within w_ja035k
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035k
end type

type ln_temptop from wt_list`ln_temptop within w_ja035k
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035k
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035k
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035k
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035k
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035k
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035k
end type

type ln_tempright from wt_list`ln_tempright within w_ja035k
end type

type uo_navi from wt_list`uo_navi within w_ja035k
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035k
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035k
end type

type st_top_rect from wt_list`st_top_rect within w_ja035k
end type

type p_close from wt_list`p_close within w_ja035k
end type

type p_excel from wt_list`p_excel within w_ja035k
end type

type p_print from wt_list`p_print within w_ja035k
end type

type p_delete from wt_list`p_delete within w_ja035k
end type

type p_update from wt_list`p_update within w_ja035k
end type

type p_input from wt_list`p_input within w_ja035k
end type

type p_retrieve from wt_list`p_retrieve within w_ja035k
end type

type p_clear from wt_list`p_clear within w_ja035k
end type

type p_copy from wt_list`p_copy within w_ja035k
end type

type dw_c from wt_list`dw_c within w_ja035k
string title = "영업일자@거래코드"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035K'")
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
RETURN TRUE
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'ymd'
      IF DATETIME (DATE (MID (data,1,10))) >= idt_workdate  Then
         ib_manageData   = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035K'")
      ELSE
         ib_manageData   = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035K' and szx0gc.tr_cd in (select tr_cd from syt0mg where corp_gr=':corp_gr' and tr_ymd='" + MidA (data, 1, 10) + "')")
      END IF
END CHOOSE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0MG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_SJA035K')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035k
end type

type st_count from wt_list`st_count within w_ja035k
end type

type dw_list from wt_list`dw_list within w_ja035k
string dataobject = "d_ja035k"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt_ymd
STRING	ls_jm_cd, ls_cur

LONG	ll_f_value

ldt_ymd = dw_c.object.ymd [1]

CHOOSE CASE DWO.NAME
   CASE 'trustee'
      SELECT currency
        INTO :ls_cur
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :data ;
      IF SQLCA.sqlcode ()=0 THEN ls_cur = SQLCA.GETITEMSTRING (1)
      Object.currency [row] = ls_cur

       SELECT F_CURRENCY_RT(:gaa.CORP_GR,:ldt_ymd,:ls_cur) INTO :ll_f_value FROM DUAL;
      Object.trans_rt [row] = SQLCA.GETITEMNUMBER (1)

      SELECT jm_cd
        INTO :ls_jm_cd
        FROM SYM0YA t1
       WHERE t1.CORP_GR   = :gaa.CORP_GR
         AND t1.currency  = :ls_cur
         AND t1.gyulje_jm = 'Y' ;
      IF SQLCA.sqlcode ()=0 THEN Object.gyulje_jm_cd [row] = SQLCA.GETITEMSTRING (1)
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'trustee', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'yj_cd'
      rs_Where = "currency='" + f_nvl (Object.currency [row],'') + "' and sj_gb='2' "
      IF MID (dw_c.object.dddw [1],1,1)='K'  Then
         rs_Where += "and jm_cd in (select jm_cd from sym0yz where corp_gr='" + gaa.corp_gr + "' and ymd='" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and fund_cd='" + Object.fund_cd [row] + "')"
      End IF
END CHOOSE
RETURN 1
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('bs_type', '0')
uf_setColumn ('tr_seq', '1')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::itemchanged_next;call super::itemchanged_next;LONG	ll

Object.tr_aek [row] = f_num (Object.tr_jusu [row]) * f_num (Object.tr_danga [row])
IF LEFT (dw_c.object.dddw [1],1)='K'	Then
	Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) - (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row]))
Else
	Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row]))
End IF
IF f_num (Object.trans_rt [row])>0  Then
   FOR  ll = row + 1  TO  rowcount ()
      IF f_num (Object.trans_rt [ll])=0   Then
         Object.trans_rt [ll] = Object.trans_rt [row]
         Object.won_gyulje_aek [ll] = truncate (Object.gyulje_aek [ll] * f_num (Object.trans_rt [ll]),0)
      End IF
   NEXT
End IF
IF f_notnull (Object.currency [row])   Then
   FOR  ll = row + 1  TO  rowcount ()
      IF f_null (Object.currency [ll]) THEN Object.currency [ll] = Object.currency [row]
   NEXT
End IF
IF f_notnull (Object.gyulje_jm_cd [row])  Then
   FOR  ll = row + 1  TO  rowcount ()
      IF f_null (Object.gyulje_jm_cd [ll]) THEN Object.gyulje_jm_cd [ll] = Object.gyulje_jm_cd [row]
   NEXT
End IF
IF f_num (Object.won_gyulje_aek [row])=0 THEN Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * f_num (Object.trans_rt [row]),0)
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

