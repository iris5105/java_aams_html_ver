forward
global type w_ja060c from wt_listole
end type
type rb_1 from pf_u_radiobutton within w_ja060c
end type
type rb_2 from pf_u_radiobutton within w_ja060c
end type
type rb_3 from pf_u_radiobutton within w_ja060c
end type
type rb_4 from pf_u_radiobutton within w_ja060c
end type
type cb_pdf from pf_u_commandbutton within w_ja060c
end type
type cb_1 from pf_u_commandbutton within w_ja060c
end type
type cbx_1 from pf_u_checkbox within w_ja060c
end type
type cb_folder from pf_u_commandbutton within w_ja060c
end type
type gb_1 from pf_u_groupbox within w_ja060c
end type
end forward

global type w_ja060c from wt_listole
boolean eb_retrievewait = true
string is_find = "fund_cd=~'~'"
boolean ib_managedata = true
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
cb_pdf cb_pdf
cb_1 cb_1
cbx_1 cbx_1
cb_folder cb_folder
gb_1 gb_1
end type
global w_ja060c w_ja060c

type variables
STRING	is_ym

DateTime idt_fr, idt_to
end variables

on w_ja060c.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.cb_pdf=create cb_pdf
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.cb_folder=create cb_folder
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.cb_pdf
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.cb_folder
this.Control[iCurrent+9]=this.gb_1
end on

on w_ja060c.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.cb_pdf)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.cb_folder)
destroy(this.gb_1)
end on

event wue_lastopen;call super::wue_lastopen;STRING	ls_yyyy

SELECT  TO_CHAR(add_months(now(), -2),'yyyy')
  INTO  :ls_yyyy
FROM    dual;

ls_yyyy = SQLCA.getitemstring (1)

dw_c.object.yyyy [1] = ls_yyyy

CHOOSE CASE string (idt_workdate, 'mm')
   CASE '02' to '04'
      rb_1.checked = TRUE
      rb_1.EVENT Clicked ()
   CASE '05' to '07'
      rb_2.checked = TRUE
      rb_2.EVENT Clicked ()
   CASE '08' to '10'
      rb_3.checked = TRUE
      rb_3.EVENT Clicked ()
   CASE Else
      rb_4.checked = TRUE
      rb_4.EVENT Clicked ()
END CHOOSE
end event

event wue_retrieve;call super::wue_retrieve;rb_1.Enabled = FALSE
rb_2.Enabled = FALSE
rb_3.Enabled = FALSE
rb_4.Enabled = FALSE

cb_1.of_setenabled (TRUE)

is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (gaa.corp_gr, idt_fr, idt_to)
end event

event wue_clear;call super::wue_clear;rb_1.Enabled = TRUE
rb_2.Enabled = TRUE
rb_3.Enabled = TRUE
rb_4.Enabled = TRUE

cb_1.of_setenabled (FALSE)
cb_pdf.of_setenabled (FALSE)
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_listole`lb_dirlist within w_ja060c
end type

type ln_templeft from wt_listole`ln_templeft within w_ja060c
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja060c
end type

type ln_temptop from wt_listole`ln_temptop within w_ja060c
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja060c
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja060c
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja060c
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja060c
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja060c
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja060c
end type

type ln_tempright from wt_listole`ln_tempright within w_ja060c
end type

type uo_navi from wt_listole`uo_navi within w_ja060c
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja060c
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja060c
end type

type st_top_rect from wt_listole`st_top_rect within w_ja060c
end type

type p_close from wt_listole`p_close within w_ja060c
end type

type p_excel from wt_listole`p_excel within w_ja060c
end type

type p_print from wt_listole`p_print within w_ja060c
end type

type p_delete from wt_listole`p_delete within w_ja060c
end type

type p_update from wt_listole`p_update within w_ja060c
end type

type p_input from wt_listole`p_input within w_ja060c
end type

type p_retrieve from wt_listole`p_retrieve within w_ja060c
end type

type p_clear from wt_listole`p_clear within w_ja060c
end type

type p_copy from wt_listole`p_copy within w_ja060c
end type

type dw_c from wt_listole`dw_c within w_ja060c
string tag = "AAMS@aams.kr 메일로 발송"
string title = "발송년도"
string dataobject = "dc_yyyy"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
IF rb_1.Checked   Then
   rb_1.EVENT clicked ()
ElseIF rb_2.Checked THEN
   rb_2.EVENT clicked ()
ElseIF rb_3.Checked THEN
   rb_3.EVENT clicked ()
Else
   rb_4.EVENT clicked ()
End IF
end event

type btn_update from wt_listole`btn_update within w_ja060c
end type

type st_count from wt_listole`st_count within w_ja060c
end type

type dw_list from wt_listole`dw_list within w_ja060c
boolean visible = true
string dataobject = "d_ja060c1"
string setlist4fontpointcolor = "send_status=2=a"
string setlist4rowpointcolor = "send_status=1=a;send_status=2=b"
boolean eb_null_line = false
string is_encrypts = "enc_e_mail"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_fund

DATETIME	ldt_re

DEC	ldc

ls_fund = Object.fund_cd [row]
ldt_re  = Object.re_seolj_ymd [row]

CHOOSE CASE DWO.NAME
   CASE 'bungi_stock_maesu'
      IF Object.wonbon_aek [row]>0 THEN Object.bungi_stock_turnover_rt [row] = (f_num (data) + f_num (Object.bungi_stock_maedo [row])) / 2 / Object.wonbon_aek [row]
   CASE 'bungi_stock_maedo'
      IF Object.wonbon_aek [row]>0 THEN Object.bungi_stock_turnover_rt [row] = (f_num (data) + f_num (Object.bungi_stock_maesu [row])) / 2 / Object.wonbon_aek [row]
   CASE 'stock_mm_aek'
      IF Object.wonbon_aek [row]>0 THEN Object.stock_turnover_rt [row] = f_num (data) / 2 / Object.wonbon_aek [row]
   CASE 'bungi_bond_susu'
      Object.bungi_bond_fee [row] = dec (data) + f_num (Object.bungi_bond_tax [row])
      SELECT NVL(SUM(bungi_bond_susu),0) + NVL(SUM(bungi_stock_susu),0)
        INTO :ldc
        FROM SICS_FUND t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     Between :ldt_re AND :idt_to - 1
         AND t1.fund_cd = :ls_fund ;

      ldc = SQLCA.GETITEMNUMBER (1)

      Object.susu [row] = dec (data) + ldc
      Object.fee [row]  = f_num (Object.sbosu [row]) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])

   CASE 'bungi_bond_tax'
      Object.bungi_bond_fee [row] = f_num (Object.bungi_bond_susu [row]) + dec (data)
      SELECT NVL(SUM(bungi_bond_tax),0) + NVL(SUM(bungi_stock_tax),0)
        INTO :ldc
        FROM SICS_FUND t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     Between :ldt_re AND :idt_to - 1
         AND t1.fund_cd = :ls_fund ;

      ldc = SQLCA.GETITEMNUMBER (1)

      Object.tax [row] = dec (data) + ldc
      Object.fee [row] = f_num (Object.sbosu [row]) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])

   CASE 'bungi_stock_susu'
      Object.bungi_stock_fee [row] = dec (data) + f_num (Object.bungi_stock_tax [row])
      SELECT NVL(SUM(bungi_bond_susu),0) + NVL(SUM(bungi_stock_susu),0)
        INTO :ldc
        FROM SICS_FUND t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     Between :ldt_re AND :idt_to - 1
         AND t1.fund_cd = :ls_fund ;

      ldc = SQLCA.GETITEMNUMBER (1)

      Object.susu [row] = dec (data) + ldc
      Object.fee [row]  = f_num (Object.sbosu [row]) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])

   CASE 'bungi_stock_tax'
      Object.bungi_stock_fee [row] = f_num (Object.bungi_stock_susu [row]) + dec (data)
      SELECT NVL(SUM(bungi_bond_tax),0) + NVL(SUM(bungi_stock_tax),0)
        INTO :ldc
        FROM SICS_FUND t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     Between :ldt_re AND :idt_to - 1
         AND t1.fund_cd = :ls_fund ;

      ldc = SQLCA.GETITEMNUMBER (1)

      Object.tax [row] = dec (data) + ldc
      Object.fee [row] = f_num (Object.sbosu [row]) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])

   CASE 'bungi_sbosu'
      SELECT NVL(SUM(bungi_sbosu),0)
        INTO :ldc
        FROM SICS_FUND t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     Between :ldt_re AND :idt_to - 1
         AND t1.fund_cd = :ls_fund ;

      ldc = SQLCA.GETITEMNUMBER (1)

      Object.sbosu [row] = dec (data) + ldc
      Object.fee [row]   = f_num (Object.sbosu [row]) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])

   CASE 'bungi_tsusu'
      SELECT NVL(SUM(bungi_tsusu),0)
        INTO :ldc
        FROM SICS_FUND t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     Between :ldt_re AND :idt_to - 1
         AND t1.fund_cd = :ls_fund ;

      ldc                = SQLCA.GETITEMNUMBER (1)
      Object.tsusu [row] = dec (data) + ldc
      Object.fee [row]   = f_num (Object.sbosu [row]) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])

   CASE 'tsusu'
      Object.fee [row] = dec (data) + f_num (Object.sbosu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])
   CASE 'sbosu'
      Object.fee [row] = dec (data) + f_num (Object.tsusu [row]) + f_num (Object.susu [row]) + f_num (Object.tax [row])
   CASE 'susu'
      Object.fee [row] = dec (data) + f_num (Object.tsusu [row]) + f_num (Object.sbosu [row]) + f_num (Object.tax [row])
   CASE 'tax'
      Object.fee [row] = dec (data) + f_num (Object.tsusu [row]) + f_num (Object.sbosu [row]) + f_num (Object.susu [row])
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mg_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::doubleclicked;LONG	ll

STRING	ls_fund_cd, ls_email

str_parameter  sp

IF row>0 THEN ls_fund_cd = Object.fund_cd [row]

IF LEFT (dwo.name,5)='suik_' And f_notnull (ls_fund_cd)  Then
   sp.dt [1] = Object.ymd [row]
   sp.dt [2] = Object.b_1m [row]
   sp.dt [3] = Object.b_3m [row]
   sp.dt [4] = Object.b_6m [row]
   sp.dt [5] = Object.b_9m [row]
   sp.dt [6] = Object.b_1y [row]

   sp.str [1] = ls_fund_cd
   sp.str [2] = Object.xx_fund_cd [row]
   OpenwithParm (w_ja060c_popup, sp)
   RETURN
End IF

CHOOSE CASE dwo.name
   CASE 'stock_mm_aek_t'
      FOR  ll = 1  TO  rowcount ()
         IF Object.wonbon_aek [ll]>0   Then
            IF (f_num (Object.bungi_stock_maesu [ll]) + f_num (Object.bungi_stock_maedo [ll]))=0   Then
               Object.bungi_stock_turnover_rt [ll] = 0
            Else
               Object.bungi_stock_turnover_rt [ll] = (f_num (Object.bungi_stock_maesu [ll]) + f_num (Object.bungi_stock_maedo [ll])) / 2 / Object.wonbon_aek [ll]
            End IF
            IF f_num (Object.stock_mm_aek [ll])=0  Then
               Object.stock_turnover_rt [ll] = 0
            Else
               Object.stock_turnover_rt [ll] = f_num (Object.stock_mm_aek [ll]) / 2 / Object.wonbon_aek [ll]
            End IF
         End IF
      NEXT
      RETURN
   CASE 'bymd'
      IF f_notnull (Object.bymd [row]) Then
         IF f_messageBox ('I002','발송취소 하시겠습니까?')=1   Then
            Object.bymd [row] = null_dt
            uf_protect (row, ia_protect [1])
         End IF
      End IF
      RETURN
END CHOOSE
CALL super::doubleclicked
end event

event dw_list::clicked;LONG	ll
CHOOSE CASE dwo.name
	CASE 'chk_t'
		IF	FIND ("chk='1'", 1, rowcount ())=0	Then
			FOR ll = 1 TO rowcount ()
				IF	cbx_1.checked	Then
					Object.chk [ll] = IIF (f_notnull (Object.e_mail [ll]) And Object.send_status [ll]='0', '1', '0')
				Else
					Object.chk [ll] = '1'
				End IF
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		Else
			FOR ll = 1 TO rowcount ()
				Object.chk [ll] = '0'
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		End IF
		RETURN
END CHOOSE
call super::clicked
end event

event dw_list::retrieveend;call super::retrieveend;LONG	ll

cbx_1.enabled = false
cb_pdf.text = 'PDF생성'
FOR  ll = 1  TO  rowcount
	IF	f_notnull (Object.e_mail [ll])	Then
		cbx_1.enabled = true
		cb_pdf.text = 'PDF메일발송'
		EXIT
	End IF
NEXT
cb_pdf.of_setenabled (TRUE)
cbx_1.checked = cbx_1.enabled

end event

type st_move from wt_listole`st_move within w_ja060c
end type

type ole_rd from wt_listole`ole_rd within w_ja060c
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;DateTime  ldt

IF	gaa.customer_gr='자산운용'	then
	IF	dw_list.object.seolj_ymd [row]>idt_fr	Then
		ldt = dw_list.object.seolj_ymd [row]
	Else
		ldt = idt_fr
	End IF
Else
	IF	dw_list.object.re_seolj_ymd [row]>idt_fr	Then
		ldt = dw_list.object.re_seolj_ymd [row]
	Else
		ldt = idt_fr
	End IF
End IF
IF f_null (dw_list.object.b_3m [row])  Then
   IF idt_fr<dw_list.object.b_1m [row] THEN ldt = dw_list.object.b_1m [row]
Else
   IF idt_fr<dw_list.object.b_3m [row] THEN ldt = dw_list.object.b_3m [row]
End IF

STRING	ls_mrd

CHOOSE CASE gaa.corp_gr
	CASE '2201'
		IF	string (dw_list.object.ymd [row],'yyyymmdd')>='20240930'	Then
			ls_mrd = 'rd_ja060c_' + gaa.corp_gr + 'a.mrd'
		Else
			ls_mrd = 'rd_ja060c_' + gaa.corp_gr + '.mrd'
		End IF
	CASE ELSE
		//리코 : 2402
		IF	dw_list.object.series_gb [row]='1200'	Then
			ls_mrd = 'rd_ja060c_' + gaa.corp_gr + 'a.mrd'
		Else
			ls_mrd = 'rd_ja060c_' + gaa.corp_gr + '.mrd'
		End IF
END CHOOSE

uf_fileopen (ls_mrd, &
				'fund_cd[' + dw_list.object.fund_cd [row] + '] ' + &
				'ymd[' + string (dw_list.object.ymd [row],'yyyy.mm.dd') + '] ' + &
				'jasan_gijun_ymd[' + string (dw_list.object.jasan_gijun_ymd [row],'yyyymmdd') + '] ' + &
				'gigan[' + '보고기간 : ' + string (ldt,'yyyy. mm. dd') + '  -  ' + string (dw_list.object.ymd [row],'yyyy. mm. dd') + '] ' + &
				'fymd[' + string (ldt,'yyyymmdd') + '] ' + &
				'tymd[' + string (dw_list.object.ymd [row],'yyyymmdd') + ']' )

end event

type rb_onepage from wt_listole`rb_onepage within w_ja060c
end type

type rb_1 from pf_u_radiobutton within w_ja060c
integer x = 1984
integer y = 200
integer width = 265
integer height = 96
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "1분기"
boolean setcondcolor = true
end type

event clicked;IF Checked   Then
   is_ym = dw_c.object.yyyy [1] + '03'
   SELECT  ADD_MONTHS(to_date(:is_ym,'yyyymm'), -2)
         , LAST_DAY(to_date(:is_ym,'yyyymm'))
     INTO  :idt_fr
         , :idt_to
   FROM    dual;
		
	idt_fr = SQLCA.getitemdatetime (1)
	idt_to = SQLCA.getitemdatetime (2)
End IF
end event

type rb_2 from pf_u_radiobutton within w_ja060c
integer x = 2245
integer y = 200
integer width = 265
integer height = 96
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "2분기"
boolean setcondcolor = true
end type

event clicked;IF Checked   Then
   is_ym = dw_c.object.yyyy [1] + '06'
   SELECT  ADD_MONTHS(to_date(:is_ym,'yyyymm'), -2)
         , LAST_DAY(to_date(:is_ym,'yyyymm'))
     INTO  :idt_fr
         , :idt_to
   FROM    dual;
		
	idt_fr = SQLCA.getitemdatetime (1)
	idt_to = SQLCA.getitemdatetime (2)
End IF
end event

type rb_3 from pf_u_radiobutton within w_ja060c
integer x = 2505
integer y = 200
integer width = 265
integer height = 96
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "3분기"
boolean setcondcolor = true
end type

event clicked;IF Checked   Then
   is_ym = dw_c.object.yyyy [1] + '09'
   SELECT  ADD_MONTHS(to_date(:is_ym,'yyyymm'), -2)
         , LAST_DAY(to_date(:is_ym,'yyyymm'))
     INTO  :idt_fr
         , :idt_to
   FROM    dual;
	
	idt_fr = SQLCA.getitemdatetime (1)
	idt_to = SQLCA.getitemdatetime (2)
End IF
end event

type rb_4 from pf_u_radiobutton within w_ja060c
integer x = 2766
integer y = 200
integer width = 265
integer height = 96
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "4분기"
boolean setcondcolor = true
end type

event clicked;IF Checked   Then
   is_ym = dw_c.object.yyyy [1] + '12'
   SELECT  ADD_MONTHS(to_date(:is_ym,'yyyymm'), -2)
         , LAST_DAY(to_date(:is_ym,'yyyymm'))
     INTO  :idt_fr
         , :idt_to
   FROM    dual;
	
	idt_fr = SQLCA.getitemdatetime (1)
	idt_to = SQLCA.getitemdatetime (2)
End IF
end event

type cb_pdf from pf_u_commandbutton within w_ja060c
integer x = 3218
integer y = 192
integer width = 457
integer taborder = 70
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "PDF메일발송"
end type

event clicked;BLOB  lb_data

LONG  ll, ll_list

DATETIME ldt_ymd, ldt_bymd

STRING   ls_last     , ls_c1            , ls_c2     , ls_c3     , ls_c4  , ls_c5       
STRING   ls_body     , ls_title         , ls_exp    , ls_fs_cd  
STRING   ls_mail_body, ls_mail_from     , ls_mail_to, ls_mail_cc, ls_qkey
STRING   ls_fund_cd  , ls_fund_nm       , ls_to_addr, ls_file   , ls_host, ls_host_file
STRING   ls_local    , ls_up_filepath []

   SELECT NVL(POST,' ')
        , NVL(juso,' ')
        , NVL(e_mail,' ')
        , NVL(tel_no,' ')
        , NVL(fax_no,' ')
     INTO :ls_c1
        , :ls_c2
        , :ls_c3
        , :ls_c4
        , :ls_c5
     FROM SZX0AB t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND t1.ymd     = (SELECT MAX(ymd)
                          FROM SZX0AB ta
                         WHERE ta.CORP_GR = :gaa.CORP_GR);

ls_c1 = SQLCA.GETITEMSTRING (1)
ls_c2 = SQLCA.GETITEMSTRING (2)
ls_c3 = SQLCA.GETITEMSTRING (3)
ls_c4 = SQLCA.GETITEMSTRING (4)
ls_c5 = SQLCA.GETITEMSTRING (5)

//ls_last = '~r~n~r~n' + ls_c2 &
// + '~r~n' + ls_c3 &
// + '~r~nT. ' + ls_c4 + ' / F. ' + ls_c5 &
// + '~r~n~r~n발송된 이메일 주소는 발송전용이며, 문의사항은 회사 이메일 주소로 문의 바랍니다.~r~n~r~n'


ls_last = '~r~n~r~n' + ls_c2 &
 + '~r~n' + ls_c3 &
 + '~r~nT. ' + ls_c4 + ' / F. ' + ls_c5 &
 + '~r~n~r~n발송된 이메일 주소는 발송전용이며, 문의사항은 회사 이메일 주소로 문의 바랍니다.~r~n~r~n'


ls_title = '[' + gaa.corp_nm + ']' + dw_c.object.yyyy [1] + '년도 '
IF rb_1.Checked   THEN
   ls_title += '1분기 운용보고서'
   ls_host  = '/sendmail/' + dw_c.object.yyyy [1] + '1' + gaa.CORP_GR + '/'
ELSEIF rb_2.Checked  THEN
   ls_title += '2분기 운용보고서'
   ls_host  = '/sendmail/' + dw_c.object.yyyy [1] + '2' + gaa.CORP_GR + '/'
ELSEIF rb_3.Checked  THEN
   ls_title += '3분기 운용보고서'
   ls_host  = '/sendmail/' + dw_c.object.yyyy [1] + '3' + gaa.CORP_GR + '/'
ELSE
   ls_title += '4분기 운용보고서'
   ls_host  = '/sendmail/' + dw_c.object.yyyy [1] + '4' + gaa.CORP_GR + '/'
END IF

ez_n_http   lnv_http

lnv_http = CREATE ez_n_http

ll_list = dw_list.ROWCOUNT ( )
ll      = dw_list.FIND ("chk='1'", 1, ll_list)
IF ll=0   THEN
   F_MESSAGEBOX ('ERR', '선택항목이 없습니다.')
   RETURN
END IF

ls_fs_cd = dw_list.object.fund_cd [iRow]

IF gaa.CORP_GR='2402' THEN
   // 리코자산은 계좌별 인사말
   SELECT text
        , load_exp
     INTO :ls_body
        , :ls_exp
     FROM SPT1TX t1
    WHERE CORP_GR = :gaa.CORP_GR
      AND fs_gb   = 'F'
      AND fs_cd   = :ls_fs_cd
      AND ymd     = :idt_to
      AND text_gb = '00'
      AND ROWNUM = 1;
ELSE
   SELECT text
        , load_exp
     INTO :ls_body
        , :ls_exp
     FROM SPT1TX t1
    WHERE CORP_GR = :gaa.CORP_GR
      AND fs_gb   = 'F'
      AND fs_cd   = '%'
      AND ymd     = :idt_to
      AND text_gb = '00'
      AND ROWNUM = 1;
END IF

ls_body = SQLCA.GETITEMSTRING (1)
ls_exp  = SQLCA.GETITEMSTRING (2)
IF NOT F_NULL (ls_exp)  THEN
   IF gaa.CORP_GR='2402' THEN
      // 리코자산은 계좌별 인사말
      SELECTBLOB load_file
        INTO :lb_data
        FROM SPT1TX t1
       WHERE CORP_GR = :gaa.CORP_GR
         AND fs_gb   = 'F'
         AND fs_cd   = :ls_fs_cd
         AND ymd     = :idt_to
         AND text_gb = '00';
      ls_file = string (idt_to, 'yyyy.mm') + '_CIO_Letters(' + ls_fs_cd + ').' + ls_exp
   ELSE
      SELECTBLOB load_file
        INTO :lb_data
        FROM SPT1TX t1
       WHERE CORP_GR = :gaa.CORP_GR
         AND fs_gb   = 'F'
         AND fs_cd   = '%'
         AND ymd     = :idt_to
         AND text_gb = '00';
      ls_file = string (idt_to, 'yyyy.mm') + '_CIO_Letters.' + ls_exp
   END IF
   IF SQLCA.SQLCode ( )=0 THEN
      mo_.Hex2File (gaa.pdf + ls_file, SQLCA.is_HexFile)

      ls_up_filepath [1] = gaa.pdf + ls_file
      IF lnv_http.of_http_up (ls_up_filepath, ls_host, true, false)<0 THEN
         MESSAGEBOX ('메일전송중단', '자료 저장 실패했습니다!!~r~n첨부파일 전송 오류')
         DESTROY lnv_http
         RETURN
      END IF
   ELSE
      MESSAGEBOX ('ERR', ' BLOB SELECT Error')
   END IF
END IF

IF gaa.CORP_GR='2402' THEN
   // 리코자산은 계좌별 시장현황
   SELECT text
        , load_exp
     INTO :ls_body
        , :ls_exp
     FROM SPT1TX t1
    WHERE CORP_GR = :gaa.CORP_GR
      AND fs_gb   = 'F'
      AND fs_cd   = :ls_fs_cd
      AND ymd     = :idt_to
      AND text_gb = '2A'
      AND ROWNUM = 1;

   ls_body = SQLCA.GETITEMSTRING (1)
   ls_exp  = SQLCA.GETITEMSTRING (2)
   IF NOT F_NULL (ls_exp)  THEN
      SELECTBLOB load_file
        INTO :lb_data
        FROM SPT1TX t1
       WHERE CORP_GR = :gaa.CORP_GR
         AND fs_gb   = 'F'
         AND fs_cd   = :ls_fs_cd
         AND ymd     = :idt_to
         AND text_gb = '2A';
      IF SQLCA.SQLCode ( )=0 THEN
         ls_file = string (idt_to, 'yyyy.mm') + '_시장현황(' + ls_fs_cd + ').' + ls_exp
         mo_.Hex2File (gaa.pdf + ls_file, SQLCA.is_HexFile)

         ls_up_filepath [2] = gaa.pdf + ls_file
         IF lnv_http.of_http_up (ls_up_filepath, ls_host, true, false)<0 THEN
            MESSAGEBOX ('메일전송중단', '자료 저장 실패했습니다!!~r~n첨부파일 전송 오류')
            DESTROY lnv_http
            RETURN
         END IF
      ELSE
         MESSAGEBOX ('ERR', ' BLOB SELECT Error')
      END IF
   END IF
END IF

st_count.VISIBLE    = TRUE
st_count.bringToTop = TRUE
FOR  ll = ll  TO  ll_list
   Yield ( )
   dw_list.selectrow (ll, FALSE)
   dw_list.scrolltoRow (ll)

   IF F_NOTNULL (dw_list.object.bymd [ll]) AND cbx_1.checked   THEN
      IF F_MESSAGEBOX ('I002','이미 발송한 자료입니다.~r~n확인 후 다시 발송하십시오.~r~n발송작업을 계속하시겠습니까?')=2 THEN EXIT
   END IF

   ldt_ymd    = dw_list.object.ymd [ll]
   ls_fund_cd = dw_list.object.fund_cd [ll]
   ls_fund_nm = dw_list.object.xx_fund_cd [ll]
   ls_to_addr = dw_list.object.e_mail [ll]
   ls_mail_cc = dw_list.object.mail_cc [ll]

   ls_local           = ls_fund_nm + '_' + ls_fund_cd + '.pdf'
   ls_up_filepath [1] = gaa.pdf + ls_local
   ole_rd.EVENT ue_retrieve (ll)
   ole_rd.uf_pdf (ls_up_filepath [1])

   ldt_bymd = F_SYSDATE ('')
   IF cbx_1.checked AND F_NOTNULL (ls_to_addr)  THEN
      IF lnv_http.of_http_up (ls_up_filepath, ls_host, true, false)<0 THEN
         rollbackJ ( );
         MESSAGEBOX ('메일전송중단', '자료 저장 실패했습니다!!~r~n첨부파일 전송 오류')
         DESTROY lnv_http
         st_count.VISIBLE = FALSE
         RETURN
      END IF

      CHOOSE CASE gaa.CORP_GR
         CASE '2202' // 이언투자자문
            ls_mail_body = dw_list.object.xx_fund_cd [ll] + '고객님~r~n' + ls_body + ls_last
         CASE ELSE
            ls_mail_body = ls_body + ls_last
      END CHOOSE
      ls_qkey = gaa.CORP_GR + ls_fund_cd + string (ldt_bymd, 'yyyymmddHHmmss')

      F_ST_COUNT (st_count, ls_qkey + '~r~n메일발송 : ', ll, ll_list)

      INSERT INTO MAIL_QLOG
      VALUES ( :ls_qkey
             , :gaa.CORP_GR
             , :ldt_bymd
             , :ls_fund_cd
             , :ls_fund_nm
             , :ls_up_filepath[1]
             , :ldt_ymd
             , 'aams.kr'
             , 'AAMS@aams.kr'
             , :ls_up_filepath[1]
             , 0
             );

      IF ls_file=''   THEN
         ls_host_file = ls_local
      ELSE
         ls_host_file = ls_file + ';' + ls_local
      END IF

      ls_mail_from = '"' + gaa.corp_nm + '" <AAMS@aams.kr>'
      ls_mail_to   = '"' + ls_fund_nm + '" <' + ls_to_addr + '>'

      INSERT INTO MAIL_Q
           ( MAIL_KEY
           , MAKE_DATE
           , MAIL_FROM
           , MAIL_TO
           , MAIL_CC
           , SUBJECT
           , CONTENT
           , PDFDIR
           , PDFFILES
           , STATUS
           )
      VALUES ( :ls_qkey
             , :ldt_ymd
             , :ls_mail_from
             , :ls_mail_to
             , :ls_mail_cc
             , :ls_title
             , :ls_mail_body
             , '/home/aams' || :ls_host
             , :ls_host_file
             , '0'
             );
      dw_list.object.mail_q [ll] = ls_qkey
   END IF
   dw_list.object.bymd [ll] = ldt_bymd
   dw_list.object.chk [ll]  = '0'

   uf_updateCommit (dw_List)

   IF ll<ll_list   THEN
      ll = dw_list.FIND ("chk='1'", ll + 1, ll_list) - 1
      IF ll<1 THEN EXIT
   END IF
NEXT
commitJ ( )
DESTROY lnv_http

F_MESSAGEBOX ('INFO', '자료발송을 완료했습니다.~r~n~r~n' + gaa.PDF + '~r~n~r~nDirectory에서 발송된 자료를 확인하십시오.')

st_count.VISIBLE = FALSE
end event

type cb_1 from pf_u_commandbutton within w_ja060c
boolean visible = false
integer x = 4521
integer y = 192
integer width = 544
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "PDF메일발송(OLD)"
end type

event clicked;str_new_mail mail

BOOLEAN	lb_pass = false

LONG	ll, ll_list, lf

STRING	ls_body, ls_rtn, ls_exp, ls_attach, ls_savefile

mail.title = '[' + gaa.corp_nm + ']' + dw_c.object.yyyy [1] + '년도 '
IF rb_1.Checked   Then
   mail.title += '1분기'
ElseIF rb_2.Checked  Then
   mail.title += '2분기'
ElseIF rb_3.Checked  Then
   mail.title += '3분기'
Else
   mail.title += '4분기'
End IF

mail.title += ' 운용보고서 '

SELECT  text
      , load_exp
  INTO  :ls_body
      , :ls_exp
FROM    spt1tx  t1
WHERE   corp_gr = :gaa.corp_gr
  AND   fs_gb   = 'F'
  AND   fs_cd   = '%'
  AND   ymd     = :idt_to
  AND   text_gb = '00';

ls_body  = SQLCA.getitemstring (1)
ls_exp   = SQLCA.getitemstring (2)

IF NOT f_null (ls_exp)  Then
   BLOB	lb_data

   SELECTBLOB  load_file
     INTO  :lb_data
   FROM    spt1tx  t1
	WHERE   corp_gr = :gaa.corp_gr
	  AND   fs_gb   = 'F'
	  AND   fs_cd   = '%'
	  AND   ymd     = :idt_to
	  AND   text_gb = '00';
   IF SQLCA.SQLCode ()=0   Then
      ls_attach = gaa.pdf + string (idt_to,'yyyy.mm') + '_CIO_Letters.' + ls_exp
      mo_.Hex2File (ls_attach, SQLCA.is_HexFile)
   Else
      messagebox ('ERR', ' BLOB SELECT Error')
   End IF
End IF

ll_list = dw_list.rowcount ()
ll = dw_list.FIND ("chk='1'", 1, ll_list)
IF ll=0  Then
   f_messageBox ('ERR', '선택항목이 없습니다.')
   RETURN
End IF
FOR  ll = ll  TO  ll_list
   Yield ()
   dw_List.selectrow (ll, FALSE)

   ole_rd.EVENT ue_retrieve (ll)
	ls_savefile = gaa.pdf + dw_List.object.xx_fund_cd [ll] + '_' + is_ym + '(' + dw_List.object.fund_cd [ll] + ').pdf'
	ole_rd.uf_pdf (ls_savefile)

	IF	cbx_1.checked	Then
		IF f_notnull (dw_List.object.bymd [ll]) And lb_pass=false	Then
			IF f_messageBox ('I002','이미 발송한 자료입니다.~r~n확인 후 다시 발송하십시오.~r~n발송작업을 계속하시겠습니까?')=2 THEN EXIT
			lb_pass = true

		ElseIF NOT (dw_List.object.send_type [ll]='1' OR dw_List.object.send_type [ll]='2') Then
			f_messageBox ('ERR','발송 할 수 없는 자료입니다.~r~n확인 후 다시 발송하십시오.(send_type=1 or 2 확인)')
			IF ll<ll_list  Then
				ll = dw_list.FIND ("chk='1'", ll + 1, ll_list) - 1
				IF ll<1 THEN EXIT
			End IF
			CONTINUE
		End IF

		mail.gijun_ymd = dw_list.object.ymd [ll]
		mail.send_dt   = f_sysdate ('')
		mail.mail_gb   = 'F'
		mail.mail_cd   = dw_List.object.fund_cd [ll]
		mail.to_addr   = dw_List.object.e_mail [ll]
		mail.to_name   = dw_List.object.xx_fund_cd [ll]
		IF f_notnull (ls_attach)   Then
			mail.attach = ls_attach + ';' + ls_savefile
		Else
			mail.attach = ls_savefile
		End IF

		IF dw_List.object.send_type [ll]='1'   Then
			mail.body = ls_body
		Else
			mail.body = 'PB님이 담당하신 ' + dw_List.object.xx_fund_cd [ll] + '고객님 ' + ls_body + ' 자료를 첨부와 같이 발송해 드립니다.'
		End IF
		ls_rtn = f_new_smtp (gaa.corp_gr, mail, TRUE)
		IF ls_rtn<>'OK' THEN EXIT
	   dw_List.object.bymd [ll] = mail.send_dt
	End IF
	dw_list.object.chk [ll] = '0'
   uf_updateCommit (dw_List)
   IF ll<ll_list  Then
      ll = dw_list.FIND ("chk='1'", ll + 1, ll_list) - 1
      IF ll<1 THEN EXIT
   End IF
NEXT
IF ls_rtn='OK' Then
   f_messageBox ('INFO', '자료발송을 완료했습니다.~r~n~r~n'+gaa.PDF+'~r~n~r~nDirectory에서 발송된 자료를 확인하십시오.')
Else
   f_messageBox ('INFO', '자료발송에 실패했습니다.~r~n전송오류자료(ftp_log 확인):~r~n'+ls_rtn)
End IF
end event

type cbx_1 from pf_u_checkbox within w_ja060c
integer x = 3730
integer y = 196
integer width = 293
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "발송"
boolean checked = true
boolean setcondcolor = true
end type

event clicked;call super::clicked;IF	checked	Then
	cb_pdf.text = 'PDF메일발송'
Else
	cb_pdf.text = 'PDF생성'
End IF
end event

type cb_folder from pf_u_commandbutton within w_ja060c
integer x = 3982
integer y = 192
integer width = 457
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute (gaa.pdf)
end event

type gb_1 from pf_u_groupbox within w_ja060c
integer x = 1943
integer y = 160
integer width = 1097
integer height = 148
integer taborder = 40
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
boolean setcondcolor = true
end type

