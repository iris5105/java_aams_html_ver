forward
global type w_ja032a from wt_listdetail
end type
type dw_port from u_dw within w_ja032a
end type
type cb_recom from pf_u_commandbutton within w_ja032a
end type
type st_port from pf_u_splitbar_vertical within w_ja032a
end type
end forward

global type w_ja032a from wt_listdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
dw_port dw_port
cb_recom cb_recom
st_port st_port
end type
global w_ja032a w_ja032a

type variables
LONG	pRow
STRING	is_mangi
end variables

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
is_mangi = ''
dw_list.retrieve (gaa.CORP_GR, dw_c.object.ymd [1])
IF	f_notnull (is_mangi) THEN f_messagebox ('INFO', is_mangi)
end event

on w_ja032a.create
int iCurrent
call super::create
this.dw_port=create dw_port
this.cb_recom=create cb_recom
this.st_port=create st_port
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_port
this.Control[iCurrent+2]=this.cb_recom
this.Control[iCurrent+3]=this.st_port
end on

on w_ja032a.destroy
call super::destroy
destroy(this.dw_port)
destroy(this.cb_recom)
destroy(this.st_port)
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event ue_wpage_modified;IF	dw_list.uf_isModified ()=FALSE And dw_port.uf_isModified ()=FALSE And dw_detail.uf_isModified ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_update;IF dw_list.ACCEPTTEXT ()=-1 OR dw_port.ACCEPTTEXT ()=-1 OR dw_detail.ACCEPTTEXT ()=-1  Then
   F_MESSAGEBOX ('W006', '')
   RETURN -1
END IF

IF EVENT ue_wpage_modified () Then
   IF uf_UpdateCommit (dw_list, dw_detail)=-1 THEN RETURN -1
   IF uf_UpdateCommit (dw_port)=-1 THEN RETURN -1
END IF

commitJ ()
RETURN 1
end event

event ue_setenabled;call super::ue_setenabled;dw_port.of_dw2subbtn ({'p_load','p_save','p_input','p_copy','p_delete','p_priorpage','p_nextpage','p_firstpage','p_lastpage'}, false)
dw_port.of_dw2subbtn ({'p_save','p_input','p_copy','p_delete','p_excel'}, true)
end event

event wue_postopen;call super::wue_postopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_clear;call super::wue_clear;dw_port.uf_clear ()
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032a
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032a
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032a
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032a
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032a
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032a
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032a
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032a
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032a
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032a
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032a
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032a
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032a
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032a
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032a
end type

type p_close from wt_listdetail`p_close within w_ja032a
end type

type p_excel from wt_listdetail`p_excel within w_ja032a
end type

type p_print from wt_listdetail`p_print within w_ja032a
end type

type p_delete from wt_listdetail`p_delete within w_ja032a
end type

type p_update from wt_listdetail`p_update within w_ja032a
end type

type p_input from wt_listdetail`p_input within w_ja032a
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032a
end type

event p_retrieve::clicked;call super::clicked;IF	ib_managedata	Then
   dw_port.uf_protect (0, dw_port.ia_protect [1])
Else
   dw_port.uf_protect (0, dw_port.ia_protect [2])
End IF
end event

type p_clear from wt_listdetail`p_clear within w_ja032a
end type

type p_copy from wt_listdetail`p_copy within w_ja032a
end type

type dw_c from wt_listdetail`dw_c within w_ja032a
string title = "기준일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] = idt_workdate)
cb_recom.enabled = ib_managedata
RETURN true
end event

type btn_update from wt_listdetail`btn_update within w_ja032a
end type

type st_count from wt_listdetail`st_count within w_ja032a
end type

type dw_list from wt_listdetail`dw_list within w_ja032a
string dataobject = "d_ja032a1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

DATETIME	ldt

DEC	ldc_rt
LONG	ll

CHOOSE CASE DWO.NAME
   CASE 'jm_per'
		IF	dec (data)>50	Then
			RETURN uf_itemerr (row, dwo.name, '종목비중은 50%를 초과 할 수 없습니다.')
		End IF
      ldt = Object.tr_ymd [row]

      SELECT gijun_rt
        INTO :ldc_rt
        FROM SYX1HY t1
       WHERE t1.CORP_GR   = :gaa.CORP_GR
         AND t1.GIJUN_YMD = :ldt
         AND t1.CURRENCY  = 'USD' ;

      IF SQLCA.SQLCode () <> 0   Then
         ldc_rt = 0
      ELSE
         ldc_rt = SQLCA.GETITEMNUMBER (1)
      END IF

      Object.usd_wonbon_aek [row] = truncate (Object.wonbon_aek [row] / ldc_rt / 100,0) * 100
		FOR  ll = 1  TO  dw_port.ROWCOUNT ()
			dw_port.object.usd_tuja [ll] = 0
		NEXT
		IF	dw_port.object.jm_per [pRow]>0	Then
			dw_port.object.usd_tuja [pRow] = round (round(Object.usd_wonbon_aek [row], 2) * dw_port.object.jm_per [pRow] / 100, 2)
			FOR  ll = 1  TO  dw_detail.ROWCOUNT ()
				dw_detail.object.usd_tuja [ll] = round (dw_port.object.usd_tuja [pRow] / dw_detail.ROWCOUNT (), 2)
			NEXT
		End IF
END CHOOSE
end event

event dw_list::rowfocuschanged_if;iRow = currentrow

dw_port.setredraw (false)
dw_port.uf_reset ()
dw_port.event ue_retrieve ()

uf_enabled (eb_rowchangewait, false)
dw_detail.setredraw (false)
dw_detail.uf_reset ()
dw_detail.event ue_retrieve ()
dw_detail.setredraw (true)
uf_enabled (eb_rowchangewait, true)

RETURN 0
end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF	dw_port.uf_update ()=FALSE OR AncestorReturnValue=1 THEN RETURN 1
RETURN 0
end event

event dw_list::ue_insertstart;IF dw_port.uf_update ()=FALSE   THEN RETURN 1
IF dw_detail.uf_update ()=FALSE THEN RETURN 1

uf_setcolumn ('corp_gr', gaa.corp_gr)
uf_setcolumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setcolumn ('del', 'N')
uf_setcolumn ('p_visible', '1')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF	GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified!	Then
	Object.p_visible [row] = 1
Else
	Object.p_visible [row] = 0
End IF
f_dw_resetstatus (THIS, row, {'p_visible'})
end event

event dw_list::retrieveend;call super::retrieveend;IF rowcount=0 THEN dw_port.uf_retrieveend ('detail', 0, FALSE)
end event

event dw_list::ue_delete;DATETIME	ldt
STRING	ls_fund

ldt     = dw_c.object.ymd [1]
ls_fund = Object.fund_cd [iRow]

Object.del [iRow] = 'Y'

DELETE FROM USPM
 WHERE CORP_GR = :gaa.CORP_GR
   AND YMD     = :ldt
   AND FUND_CD = :ls_fund ;

DELETE FROM USPM_PORT
 WHERE CORP_GR = :gaa.CORP_GR
   AND TYMD    = :ldt
   AND FUND_CD = :ls_fund ;

uf_UpdateCommit (THIS)
Post Event wue_retrieve()
 
RETURN 1
end event

type dw_detail from wt_listdetail`dw_detail within w_ja032a
integer x = 2789
integer width = 2642
string dataobject = "d_ja032a3"
string islist4subbtnauth = "0011010000"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;IF dw_port.ROWCOUNT ()>0	Then
	IF	dw_port.object.tt [pRow]='A'	Then
		uf_dataobject ('d_ja032a3a', FALSE)
	Else
		uf_dataobject ('d_ja032a3', FALSE)
	End IF
	retrieve (gaa.CORP_GR, dw_list.object.tr_ymd [iRow], dw_list.object.fund_cd [iRow], dw_port.object.port_num [pRow])
End IF
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;LONG	ll, lcol

uf_setcolumn ('ymd', string(dw_list.object.tr_ymd [iRow]))
uf_setcolumn ('fund_cd', dw_list.object.fund_cd [iRow])
IF	pRow>0 THEN uf_setcolumn ('port_num', dw_port.object.port_num [pRow])
uf_setcolumn ('tuja_amt', '0')
uf_setcolumn ('col', string (getrow () + 1))

POST setcolumn ('yj_cd')

RETURN 0
end event

event dw_detail::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1

LONG	ll

CHOOSE CASE dwo.name
	CASE 'yj_cd'
      FOR  ll = 1  TO  rowcount ()
         IF ROW <> ll AND data = Object.yj_cd [ll] Then
            RETURN   uf_itemerr (ROW, DWO.NAME, '동일한 종목이 등록되어 있습니다.~r~n순번을 조정 하십시오.')
         END IF
      NEXT
		gaa.jm_cd = data
	CASE 'col'
		FOR  ll = 1  TO  rowcount ()
			IF row=ll THEN CONTINUE
			IF Object.col [ll]>=dec (data) THEN Object.col [ll] = Object.col [ll] + 1
		NEXT
//	CASE 'target_return_per'
//		IF	f_messagebox ('INFO2', '일괄 적용하시겠습니까?')=1	Then
//			FOR  ll = 1  TO  rowcount ()
//				IF row=ll THEN CONTINUE
//				Object.target_return_per [ll] = dec (data)
//			NEXT
//		End IF
END CHOOSE

end event

event dw_detail::doubleclicked;LONG	ll
CHOOSE CASE dwo.name
	CASE 'col_t'
		FOR  ll = 1  TO  rowcount ()
			Object.col [ll] = ll
		NEXT
		RETURN
	CASE 'usd_tuja_t'
		IF	dw_port.rowcount ()=0 THEN RETURN
		FOR  ll = 1  TO  rowcount ()
			Object.usd_tuja [ll] = round (dw_port.object.usd_tuja [pRow] / rowcount (),2)
		NEXT
		RETURN
END CHOOSE
call super::doubleclicked
end event

event dw_detail::rowfocuschanged_if;call super::rowfocuschanged_if;gaa.jm_cd = Object.yj_cd [currentrow]
RETURN 0
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE dw_port.object.tt [pRow]
	CASE '1' to '9'
		RETURN 1
	CASE ELSE
		RETURN 81
END CHOOSE
end event

type st_move from wt_listdetail`st_move within w_ja032a
string bottomdragobject = "dw_detail;dw_port;st_port"
end type

type dw_port from u_dw within w_ja032a
integer x = 50
integer y = 1476
integer width = 2693
integer height = 1288
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ja032a2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0011110000"
string setlist4rowpointcolor = "p_visible=0=c"
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;IF	rowcount=0 THEN dw_detail.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.fund_cd [iRow], dw_list.object.tr_ymd [iRow], dw_list.object.jm_per [iRow])
end event

event ue_insertstart;call super::ue_insertstart;IF dw_detail.uf_update ()=FALSE THEN RETURN 1

LONG	ll, ll_port = 0

uf_setcolumn ('tymd', string(dw_list.object.tr_ymd [iRow]))
uf_setcolumn ('fund_cd', dw_list.object.fund_cd [iRow])
FOR  ll = 1  TO  rowcount ()
	ll_port = MAX (ll_port, dec (Object.port_num [ll]))
NEXT
ll_port ++
uf_setcolumn ('port_num', TRIM (string (ll_port)))
uf_setcolumn ('tt', '5')
uf_setcolumn ('price_per', '2')

POST setcolumn ('port_num')

RETURN 0
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tt', '', '', 1, '')
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;LONG	ll

pRow = currentrow

dw_detail.setredraw (false)
dw_detail.uf_reset ()
dw_detail.event ue_retrieve ()

IF	iRow>0 And currentrow>0	Then
	IF	Object.usd_tuja [currentrow]=0 And Object.jm_per [currentrow]>0	Then
		Object.usd_tuja [currentrow] = round (round(dw_list.object.usd_wonbon_aek [iRow], 2) * Object.jm_per [currentrow] / 100, 2)
		FOR  ll = 1  TO  dw_detail.ROWCOUNT ()
			dw_detail.object.usd_tuja [ll] = round (Object.usd_tuja [currentrow] / dw_detail.ROWCOUNT (), 2)
		NEXT
	End IF
End IF

dw_detail.setredraw (true)
RETURN 0
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;IF	Object.tt [newrow]>='1' And Object.tt [newrow]<='9'	Then
	MODIFY ("usd_tuja_t.text='투자목표액~r~n(USD)'")
	dw_detail.MODIFY ("usd_tuja_t.text='투자목표액~r~n(USD)'")
	dw_detail.MODIFY ("stock_chui_t.text='주식취득액~r~n(USD)'")
Else
	MODIFY ("usd_tuja_t.text='투자목표액~r~n(KRW)'")
	dw_detail.MODIFY ("usd_tuja_t.text='투자목표액~r~n(KRW)'")
	dw_detail.MODIFY ("stock_chui_t.text='주식취득액~r~n(KRW)'")
End IF

IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copyrow;IF	rowcount ()=0 THEN RETURN -1
IF	AcceptText ()=-1	Then
	f_messageBox ('W006', '')
	RETURN -1
End IF
IF	uf_getrange ()	Then
	f_messageBox ('RANG', '복사')
	RETURN -1
End IF

IF dw_detail.uf_update ()=FALSE THEN RETURN -1

LONG	ll, lCount, lCopy, ll_port = 0

FOR  ll = 1  TO  rowcount ()
	ll_port = MAX (ll_port, dec (Object.port_num [ll]))
NEXT
ll_port ++

lCount = dw_detail.rowcount ()
IF	lCount>0	Then
   IF	f_messageBox ('W014','')=1	Then
      FOR  ll = 1  TO  lCount
         dw_detail.SetItemStatus (ll, 0, Primary!, New!)
         dw_detail.SetItemStatus (ll, 0, Primary!, NotModified!)
         dw_detail.Object.port_num [ll] = string (ll_port)
      NEXT
   Else
      dw_detail.uf_reset ()
   End IF
End IF

Enabled = FALSE

lCopy = rowcount() + 1

ll = getrow ()
selectrow (ll, false)
RowsCopy (ll, ll,  Primary!, THIS, lCopy, Primary!)

Object.port_num [lCopy] = string (ll_port)

uf_setrow (lCopy, TRUE)
Enabled = TRUE

POST SetFocus ()

RETURN 0
end event

event ue_delete;IF	rowcount ()=0 THEN RETURN -1
IF	uf_getrange ()	Then
	f_messageBox ('RANG','삭제')
	RETURN -1
End IF
IF	f_MessageBox ('W004', dw_Detail.Tag)=2 THEN RETURN 0	// delete Cancel

IF EVENT ue_deletestart ()=1 THEN RETURN -1
IF	dw_detail.uf_deleteall ()=-1 THEN RETURN -1

enabled = false
IF	deleterow (pRow)=-1	Then
	f_messageBox ('D000', TAG + '(no rollback)')
	RETURN -1
End IF
IF	pRow>rowcount () THEN pRow = rowcount ()
IF	pRow=0	Then
	IF	dw_detail.ibsetlist4subbtn THEN dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
Else
	uf_setrow (pRow, true)
	POST SetFocus ()
End IF
RETURN 1
end event

event itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

DATETIME	ldt_f, ldt_t

LONG	ll

CHOOSE CASE DWO.NAME
   CASE 'mangi_ymd'
      ldt_f = dw_list.object.tr_ymd [iRow]
      ldt_t = DATETIME (DATE (MID (data,1,10)))

      SELECT f_days (:ldt_f, :ldt_t) INTO :ll FROM DUAL;
      Object.dt [row] = SQLCA.GETITEMNUMBER (1)

   CASE 'port_num'
      FOR  ll = 1  TO  rowcount ()
         IF ROW <> ll AND data = Object.port_num [ll] Then
            RETURN   uf_itemerr (ROW, DWO.NAME, '동일한 포트로 수정 또는 추가 할 수 없습니다.')
         END IF
      NEXT
      FOR  ll = 1  TO  dw_detail.ROWCOUNT ()
         dw_detail.object.port_num [ll] = data
      NEXT

   CASE 'tt'
		IF	dw_detail.rowcount ()>0	Then
			IF	data>='1' And data<='9'	Then
				IF	dw_detail.object.ovrs_excg_cd [1]='KRX' THEN RETURN uf_itemerr (row, dwo.name, 'KRX 종목이 이미 등록되어 해외 변동기준으로 변경 할 수 없습니다.')
			Else
				IF	dw_detail.object.ovrs_excg_cd [1]<>'KRX' THEN RETURN uf_itemerr (row, dwo.name, '해외종목이 이미 등록되어 KRX 변동기준으로 변경 할 수 없습니다.')
			End IF
		End IF
		
      ldt_f = dw_list.object.tr_ymd [iRow]
      ldt_t = Object.mangi_ymd [row]

      SELECT f_days (:ldt_f, :ldt_t) INTO :ll FROM DUAL;
      Object.dt [row] = SQLCA.GETITEMNUMBER (1)

   CASE 'jm_per'
		IF	Object.tt [row]>='1' And Object.tt [row]<='9'	Then
			Object.usd_tuja [row] = ROUND (dw_list.object.usd_wonbon_aek [iRow] * dec (data) / 100,2)
		Else
			Object.usd_tuja [row] = ROUND (dw_list.object.wonbon_aek [iRow] * dec (data) / 100,2)
		End IF
      FOR  ll = 1  TO  dw_detail.ROWCOUNT ()
         dw_detail.object.usd_tuja [ll] = ROUND (Object.usd_tuja [row] / dw_detail.ROWCOUNT (), 2)
      NEXT

   CASE 'usd_tuja'
      FOR  ll = 1  TO  dw_detail.ROWCOUNT ()
         dw_detail.object.usd_tuja [ll] = ROUND (dec (data) / dw_detail.ROWCOUNT (), 2)
      NEXT
END CHOOSE
end event

event rbuttondown;IF	row=0	Then
	uf_date_nation ('US')
Else
	IF	Object.tt [row]<='1' And Object.tt [row]<='9'	Then
		uf_date_nation ('US')
	Else
		uf_date_nation ('KR')
	End IF
End IF
call super::rbuttondown
end event

event buttonup;IF	row=0	Then
	uf_date_nation ('US')
Else
	IF	Object.tt [row]<='1' And Object.tt [row]<='9'	Then
		uf_date_nation ('US')
	Else
		uf_date_nation ('KR')
	End IF
End IF
call super::buttonup
end event

event ue_protect;call super::ue_protect;IF	string (Object.p_visible [row])='1'	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event retrieverow;call super::retrieverow;IF	Object.mangi_ymd [row]=dw_c.object.ymd [1] And ib_managedata THEN is_mangi += Object.port_num [row] + ' 포트가 당일 만기입니다.~r~n'
end event

type cb_recom from pf_u_commandbutton within w_ja032a
integer x = 1120
integer y = 188
integer width = 530
integer taborder = 120
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "변동성재계산"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;enabled = false

f_loadingretrieve (TRUE)

EVENT wue_update ()

STRING	p_msg = SPACE (200), la_args []

la_args [1] = gaa.CORP_GR
la_args [2] = STRING (dw_c.object.ymd[1], 'yyyy.mm.dd')
la_args [3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'SR_JA032A ( ?, ?, ? )', la_args[], p_msg)

f_loadingretrieve (false)

p_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')
IF LEFT (p_msg,1) <> 'Y'   Then
   F_MESSAGEBOX ('SP00', STRING (SQLCA.SQLDBCode) + '~r~n' + SQLCA.SQLErrText())
ELSE
	F_MESSAGEBOX ('P000', '변경된 조건으로 ' + MID (p_msg, 3) + ' 완료!!!')
END IF

p_retrieve.POST EVENT clicked ()
enabled = true
end event

type st_port from pf_u_splitbar_vertical within w_ja032a
integer x = 2757
integer y = 1448
integer height = 1316
boolean bringtotop = true
boolean setcondcolor = true
boolean leftmaxsizefixed = true
string leftdragobject = "dw_port"
string rightdragobject = "dw_detail"
end type

event constructor;call super::constructor;IF	dw_detail.zoominout THEN ii_rightmargin += PixelsToUnits(12, XPixelsToUnits!)
end event

