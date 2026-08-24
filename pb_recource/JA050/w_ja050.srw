forward
global type w_ja050 from wt_listdetail
end type
type dw_1 from u_dw within w_ja050
end type
type cb_2 from pf_u_commandbutton within w_ja050
end type
type dw_2 from u_dw within w_ja050
end type
type cb_1 from pf_u_commandbutton within w_ja050
end type
type cbx_1 from pf_u_checkbox within w_ja050
end type
end forward

global type w_ja050 from wt_listdetail
boolean eb_direct_retrieve = true
integer ii_dddw_position = 1
boolean ib_managedata = false
dw_1 dw_1
cb_2 cb_2
dw_2 dw_2
cb_1 cb_1
cbx_1 cbx_1
end type
global w_ja050 w_ja050

type variables
STRING	is_corp_gr = '!@#$'
end variables

on w_ja050.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_2=create cb_2
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cbx_1
end on

on w_ja050.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cbx_1)
end on

event resize;CALL w_winpage::resize

dw_2.X = dw_List.X
dw_2.Y = dw_detail.Y
dw_2.height = height - dw_2.Y - 185

// List 크기에 따라 Detail 크기결정
dw_Detail.X = dw_2.X + dw_2.width + 40
dw_Detail.width = width - dw_detail.X - 125

dw_List.Width = TRUNCATE ((Width - dw_List.X - 125) * .55 , 0 )
dw_1.X = dw_List.X + dw_List.width + 40
dw_1.Y = dw_List.Y
dw_1.width = width - dw_1.X - 125
dw_1.height = dw_List.height
dw_1.Modify ("err_msg.width='" + string (dw_1.width - 100) + "'" )
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_gijunga_ymd ('-')
end event

event wue_retrieve;dw_list.retrieve (dw_c.object.ymd [1])
end event

event open;icmdbutton = { cb_2, cb_1 }
call super::open
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja050
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja050
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja050
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja050
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja050
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja050
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja050
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja050
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja050
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja050
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja050
end type

type uo_navi from wt_listdetail`uo_navi within w_ja050
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja050
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja050
end type

type p_close from wt_listdetail`p_close within w_ja050
end type

type p_excel from wt_listdetail`p_excel within w_ja050
end type

type p_print from wt_listdetail`p_print within w_ja050
end type

type p_delete from wt_listdetail`p_delete within w_ja050
end type

type p_update from wt_listdetail`p_update within w_ja050
end type

type p_input from wt_listdetail`p_input within w_ja050
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja050
end type

type p_clear from wt_listdetail`p_clear within w_ja050
end type

type p_copy from wt_listdetail`p_copy within w_ja050
end type

type dw_c from wt_listdetail`dw_c within w_ja050
string title = "기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listdetail`btn_update within w_ja050
end type

type st_count from wt_listdetail`st_count within w_ja050
end type

type dw_list from wt_listdetail`dw_list within w_ja050
string dataobject = "d_ja050_1"
boolean hscrollbar = false
end type

event dw_list::rowfocuschanged_if;IF currentrow <> getrow() THEN RETURN 1
iRow = currentrow

IF is_corp_gr<>Object.corp_gr [currentrow]   Then
   is_corp_gr = Object.corp_gr [currentrow]
   dw_1.reset ()
   dw_1.retrieve (is_corp_gr)
   dw_2.reset ()
   dw_2.retrieve (is_corp_gr)
End IF

dw_Detail.uf_reset ()
dw_Detail.EVENT ue_retrieve ()

RETURN 0
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'corp_gr', gaa.corp_gr, '', 1, '')
end event

event dw_list::retrieveend;call super::retrieveend;STRING	ls_pass, la_pass []

DateTime ldt

LONG	ll, lR

ldt = dw_c.object.ymd [1]

SELECT  LISTAGG (corp_gr||',최종 기준가계산일 : '||to_char (gijunga_ymd,'yyyy.mm.dd'),',') WITHIN GROUP (ORDER BY corp_gr)
  INTO  :ls_pass
FROM    szx0aa t1
WHERE   t1.gijunga_ymd >= :ldt
ORDER BY  t1.corp_gr;

ls_pass = SQLCA.getitemstring (1)

f_get_array (ls_pass, ',', la_pass)

IF f_notnull (ls_pass)  Then
   f_get_array (ls_pass, ',', la_pass)
   FOR  ll = 1  TO  UPPERBOUND (la_pass)  STEP  2
      lR = dw_list.insertrow (0)
      dw_list.object.corp_gr [lR] = trim (la_pass [ll])
      dw_list.object.xx_fund_cd [lR] = trim (la_pass [ll + 1])
      dw_list.object.bcolor [lR] = 16443110
   NEXT
End IF

SELECT  LISTAGG (corp_gr||','||to_char (check_ymd,'yyyy.mm.dd')||'일 점검',',') WITHIN GROUP (ORDER BY corp_gr)
  INTO  :ls_pass
FROM    szx0aa t1
WHERE   t1.gijunga_ymd < :ldt;

ls_pass = SQLCA.getitemstring (1)

IF f_null (ls_pass) THEN RETURN

f_get_array (ls_pass, ',', la_pass)

FOR  ll = 1  TO  UPPERBOUND (la_pass)  STEP  2
   lR = insertrow (0)
   Object.corp_gr [lR] = la_pass [ll]
   Object.xx_fund_cd [lR] = la_pass [ll + 1]
   Object.bcolor [lR] = 12632256
NEXT

Sort ()
GroupCalc ()
uf_setrow(getselectedrow(0), FALSE)
end event

type dw_detail from wt_listdetail`dw_detail within w_ja050
string dataobject = "d_ja050_2"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;DatawindowChild  ldwc

LONG	ll_rowcount, ll_x, ll, ll_nest

STRING	la_dw[]

ads_jTier dw_dt
ads_jTier dw_comdw

dw_dt = Create ads_jTier
dw_comdw = Create ads_jTier

dw_detail.Modify ("Datawindow.processing=5")

la_dw = {'dw_1'}

dw_dt.dataobject = dw_detail.dataobject
dw_dt.settransobject(SQLCA)
ll_rowcount = dw_dt.retrieve (dw_list.object.corp_gr [iRow], dw_list.object.fund_cd [iRow], dw_list.object.xx_fund_cd [iRow], f_dddw_desc (dw_list, 'corp_gr', iRow))

dw_detail.reset()
FOR ll = 1 TO ll_rowcount
	dw_dt.rowscopy(ll_rowcount - ll + 1, ll_rowcount - ll + 1, Primary!, dw_detail, 1, Primary!)
	
	FOR ll_x = 1 to upperbound(la_dw)
		dw_detail.getChild(la_dw[ll_x], ldwc)
		dw_comdw.dataobject = dw_detail.describe(la_dw[ll_x] + '.dataobject')
		dw_comdw.settransobject (SQLCA)
		ll_nest = dw_comdw.retrieve (dw_detail.object.corp_gr [1], dw_list.object.fund_cd [iRow], dw_detail.object.gwamok [1])
		IF ll_nest > 0 Then
				dw_comdw.rowsmove (1, ll_nest, Primary!, ldwc, 1, Primary!)
				ldwc.resetupdate ()
		END IF
	NEXT
NEXT
dw_detail.resetupdate()

Destroy dw_comdw
Destroy dw_dt

dw_detail.event retrieveend (ll_rowcount)
end event

event dw_detail::clicked;CHOOSE CASE dwo.name
   CASE 'gwamok','gwamok_nm'
      str_parameter  sp

      sp.dt [1] = dw_c.object.ymd [1]

      sp.str [1] = dw_List.object.fund_cd [iRow]
      sp.str [2] = Object.gwamok [row]
      sp.str [3] = Object.gwamok_nm [row]
      sp.str [4] = dw_List.object.corp_gr [iRow]

      OpenwithParm (w_ja050_popup, sp)
END CHOOSE
end event

type st_move from wt_listdetail`st_move within w_ja050
string topdragobject = "dw_list;dw_1"
string bottomdragobject = "dw_detail;dw_2"
end type

type dw_1 from u_dw within w_ja050
integer x = 4032
integer y = 228
integer width = 526
integer height = 548
integer taborder = 40
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_ja050_4"
boolean vscrollbar = true
end type

event doubleclicked;IF dwo.name='err_msg' Then
   STRING	ls

   LONG	lR, ll_cnt

   ll_cnt = rowcount ()
   ls = ''
   FOR  lR = 1  TO  ll_cnt
      ls += Object.err_msg [lR] + '~r~n'
   NEXT
   ::Clipboard (ls)
   f_microhelp (string (dwo.name) + ' -> ClipBoard에 복사완료')
End IF
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

type cb_2 from pf_u_commandbutton within w_ja050
integer x = 2231
integer y = 16
integer width = 457
integer taborder = 30
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string pointer = "AppStarting!"
string text = "진단처리"
end type

event clicked;STRING	la_args[], w_msg, ls_sqlsyntax, ls_corp_gr, ls_corp_nm

LONG	ll, lR

f_loadingyield ('start')

ls_sqlsyntax = " SELECT  CORP_GR " &
             + "       , COMPANY_NAME " &
             + " FROM    szx0aa aa " &
             + " WHERE   gijunga_ymd >= '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' " &
             + " ORDER BY  corp_gr "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, gds, 'xml')

FOR  ll = 1  TO  lR
   ls_corp_gr = gds.getitemString (ll, 1)
   ls_corp_nm = gds.getitemString (ll, 2)
	IF f_loadingyield ('exit') THEN EXIT

   w_msg = SPACE (200)
   la_args[1] = ls_corp_gr
   la_args[2] = string (dw_c.object.ymd[1], 'yyyy.mm.dd')
	IF	ls_corp_gr=gaa.corp_gr And cbx_1.checked	Then
	   la_args[3] = '1'
	Else
	   la_args[3] = '0'
	End IF
   la_args[4] = 'ref'
	SQLCA.singleconnection ()
   SQLCA.SP_CALL(THIS, 'SR_JA050 ( ?, ?, ?, ? )', la_args[], w_msg)
	w_msg	= f_nvl (SQLCA.getitemplsql (1), 'N')
   IF SQLCA.sqlcode()=-1  Then
      f_messageBox ('ORA0', '')  //서버의 물리적 오류 입니다.
      EXIT
   Else
      IF w_msg<>'Y'  Then
         f_loadingyield ('stop')
         f_messageBox ('ERR', w_msg)
         RETURN
      End IF
	End IF
	IF	f_get_error (ls_corp_gr)	Then
		f_loadingyield ('stop')
      f_messageBox ('INFO', ls_corp_nm + ' 자가진단 결과를 확인하십시오.')
		f_loadingyield ('start')
	End IF
NEXT

f_loadingyield ('stop')

cbx_1.checked = false
dw_list.retrieve (dw_c.object.ymd [1])
end event

type dw_2 from u_dw within w_ja050
integer x = 4055
integer y = 1484
integer width = 1285
integer height = 548
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_ja050_3"
boolean vscrollbar = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event doubleclicked;call super::doubleclicked;IF iRow=0 THEN RETURN
CHOOSE CASE dwo.name
   CASE 'gwamok','gwamok_nm'
      str_parameter  sp

      sp.dt [1] = dw_c.object.ymd [1]

      sp.str [1] = dw_List.object.fund_cd [iRow]
      sp.str [2] = Object.gwamok [row]
      sp.str [3] = Object.gwamok_nm [row]
      sp.str [4] = dw_List.object.corp_gr [iRow]

      OpenwithParm (w_ja050_popup, sp)
END CHOOSE
end event

type cb_1 from pf_u_commandbutton within w_ja050
integer x = 2702
integer y = 16
integer width = 457
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "결과요약"
end type

event clicked;call super::clicked;str_parameter sp

sp.dt[1] = dw_c.Object.ymd[1]

openwithparm (w_ja050_summary, sp)
end event

type cbx_1 from pf_u_checkbox within w_ja050
integer x = 1189
integer y = 196
integer width = 439
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "계정조정분개"
boolean setcondcolor = true
end type

