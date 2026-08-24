forward
global type w_run from wt_list
end type
type cb_run from pf_u_commandbutton within w_run
end type
type cb_1 from pf_u_commandbutton within w_run
end type
end forward

global type w_run from wt_list
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
boolean ib_managedata = false
cb_run cb_run
cb_1 cb_1
end type
global w_run w_run

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.aams), { 'dddw' }) ; f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, "")

dw_c.object.dddw [1] = gaa.corp_gr
dw_c.object.fymd [1] = f_gijunga_ymd ('-')
dw_c.object.tymd [1] = f_gijunga_ymd ('+')

IF	NOT gaa.aams THEN f_setprotect (dw_c, true, { 'dddw' })
end event

on w_run.create
int iCurrent
call super::create
this.cb_run=create cb_run
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_run
this.Control[iCurrent+2]=this.cb_1
end on

on w_run.destroy
call super::destroy
destroy(this.cb_run)
destroy(this.cb_1)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

type lb_dirlist from wt_list`lb_dirlist within w_run
end type

type ln_templeft from wt_list`ln_templeft within w_run
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_run
end type

type ln_temptop from wt_list`ln_temptop within w_run
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_run
end type

type ln_tempstart from wt_list`ln_tempstart within w_run
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_run
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_run
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_run
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_run
end type

type ln_tempright from wt_list`ln_tempright within w_run
end type

type uo_navi from wt_list`uo_navi within w_run
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_run
end type

type st_windelaytime from wt_list`st_windelaytime within w_run
end type

type st_top_rect from wt_list`st_top_rect within w_run
end type

type p_close from wt_list`p_close within w_run
end type

type p_excel from wt_list`p_excel within w_run
end type

type p_print from wt_list`p_print within w_run
end type

type p_delete from wt_list`p_delete within w_run
end type

type p_update from wt_list`p_update within w_run
end type

type p_input from wt_list`p_input within w_run
end type

type p_retrieve from wt_list`p_retrieve within w_run
end type

type p_clear from wt_list`p_clear within w_run
end type

type p_copy from wt_list`p_copy within w_run
end type

type dw_c from wt_list`dw_c within w_run
string title = "영업일자구간@작업회사"
string dataobject = "dc_ftymd_dddw"
end type

event dw_c::ue_valid;call super::ue_valid;DateTime ldt_inputdate, ldt, ldt_f, ldt_t

STRING	ls_corp_gr

ldt_inputdate = uf_initdate ('inputdate')

ls_corp_gr = Object.dddw [1]

ldt_f = Object.fymd [1]
ldt_t = Object.tymd [1]

// corp_gr을 조건에 있는것으로 주의 할 것.
SELECT  CASE WHEN gijunga_ymd>:ldt_f THEN :ldt_f ELSE f_open_ymd (:ldt_f,'-') END
      , CASE WHEN gijunga_ymd<=:ldt_t THEN :ldt_t ELSE f_open_ymd (hyun_ymd,'+1') - 1 END
  INTO  :ldt_f
      , :ldt_t
FROM    szx0aa t1
WHERE   corp_gr = :ls_corp_gr;

ldt_f = SQLCA.getitemdatetime (1)
ldt_t = SQLCA.getitemdatetime (2)

IF ldt_f<>Object.fymd [1] And NOT gaa.admin THEN Object.fymd [1] = ldt_f

SELECT F_OPEN_YMD (:idt_workdate, '+1')
  INTO :ldt
FROM   DUAL;

ldt = SQLCA.getitemdatetime (1)

IF Object.fymd [1]>Object.tymd [1]  Then
   f_messageBox ('I000', '작업 시작일이 종료일보다 큽니다.')
   RETURN FALSE
End IF

IF ldt_t>ldt And NOT gaa.admin	Then
	f_messageBox ('I000', '작업 종료일('+string (ldt_t,'yyyy.mm.dd')+')이 작업일('+string (idt_workdate,'yyyy.mm.dd')+')을 벗어났습니다.')
	Object.tymd [1] = idt_workdate
End IF

IF ldt_f<f_gijunga_ymd('-20') And NOT gaa.admin	Then
	f_messageBox ('I000', '작업 시작일이 작업 가능일을 이전 입니다.(작업의뢰)')
	RETURN FALSE
End IF
end event

event dw_c::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE 'dddw'
		dw_c.object.fymd [1] = f_gijunga_ymd ('')
		dw_c.object.tymd [1] = f_gijunga_ymd ('+')
	CASE 'tymd'
		DateTime	ldt

		ldt = datetime (date(MID (data,1,10)))

		SELECT  f_open_ymd (:ldt,'+1') - 1
		  INTO  :ldt
		FROM    dual;

		Object.tymd [1] = SQLCA.getitemdatetime (1)
END CHOOSE
end event

type btn_update from wt_list`btn_update within w_run
end type

type st_count from wt_list`st_count within w_run
end type

type dw_list from wt_list`dw_list within w_run
string dataobject = "d_run"
string is_resize_column = "err_msg"
end type

type cb_run from pf_u_commandbutton within w_run
integer x = 2898
integer y = 192
integer width = 471
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "원장생성"
end type

event clicked;LONG	ll, ll_cnt, ldb_color, ll_color, lR
TIME	lt_start

BOOLEAN	lb_stop = false
STRING	ls_corp_gr, ls_msg, la_args[], ls_sqlsyntax, ls_err_msg, ls_board_text
Datetime	ldt


IF	dw_c.object.fymd [1]>dw_c.object.tymd [1]	Then
	f_messageBox ('SP00', '작업일을 확인 하십시오.')
	RETURN
End IF

lt_start = now ()

ls_corp_gr = dw_c.object.dddw[1]
ldt        = dw_c.object.fymd [1]

ll_cnt = dw_list.rowcount ()
DO WHILE TRUE
   IF ldt>dw_c.object.tymd [1] THEN EXIT

	f_microHelp (string (ldt,'yyyy.mm.dd') + '일 원장생성 작업중입니다...')
	FOR  ll = 1  TO  ll_cnt
		Yield ()
		dw_list.uf_setrow (ll, TRUE)
	
		la_args[1] = ls_corp_gr
		la_args[2] = string(ldt,'yyyy.mm.dd')
		la_args[3] = dw_list.object.pgm_id [ll]
		la_args[4] = gaa.login
		la_args[5] = 'ref'
		SQLCA.singleconnection ()
		SQLCA.SP_CALL (THIS, 'SR_EXEC ( ?, ?, ?, ?, ? )', la_args[], ls_msg)
		ls_msg = f_nvl (SQLCA.getitemplsql (1), 'N')
		IF SQLCA.sqlcode ()=-1  Then
			::clipboard (SQLCA.SQLErrText())
			f_messagebox ("ORA0", SQLCA.SQLErrText()) //서버의 물리적 오류 입니다.
			lb_stop = true
			EXIT
		End IF
		IF f_get_error (string (dw_c.object.dddw [1]))  Then
			::clipboard (ls_msg)
			dw_list.object.err_msg [ll] = ls_msg
			lb_stop = true
			EXIT
		End IF
	
		commitJ ();
		IF f_nvl (ls_msg,'N')='Y'  Then
			dw_list.object.flag [ll] = 'Y'
			IF	gaa.admin	Then
				dw_list.object.err_msg [ll] = dw_c.describe ("Evaluate('LookupDisplay(dddw)', 1)") + '(' + ls_corp_gr + ')...' + string (ldt,'yyyy.mm.dd') + '일 작업을 완료했습니다.'
			Else
				dw_list.object.err_msg [ll] = string (ldt,'yyyy.mm.dd') + '일 작업을 완료했습니다.'
			End IF
			dw_list.SelectRow (ll, FALSE)
		Else
			::clipboard (ls_msg)
			dw_list.object.err_msg [ll] = f_nvl (ls_msg,'null')
			f_messagebox ('SP00', dw_list.object.pgm_id [ll] + ' ' + dw_list.object.pgm_nm [ll] + '~r~n실행에러 메세지 = [' + f_nvl (ls_msg,'null') + ']')
			lb_stop = true
			EXIT
		End IF
		Beep (1)
	NEXT
	IF	lb_stop THEN EXIT

	SELECT  :ldt + 1
	  INTO  :ldt
	FROM    dual;

	ldt = SQLCA.getitemdatetime (1)
	dw_c.object.fymd [1] = ldt
LOOP

ldt = f_sysdate ('')

ls_sqlsyntax = " SELECT  DISTINCT err_msg " &
				 + "       , color " &
				 + " FROM    szx3ck t1 " &
				 + " WHERE   t1.corp_gr = '" + ls_corp_gr + "' " &
				 + "   AND   t1.proc    = 'skkp010' " &
				 + " ORDER BY  color " &
				 + "         , err_msg "

lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, gds, 'xml')

FOR  ll = 1  TO  lR
	ls_err_msg = gds.getitemString (ll, 1)
	ldb_color  = gds.getitemnumber (ll, 2)

	IF ll_color=-1 OR ll_color=ldb_color   Then
		ls_board_text += ls_err_msg + '~r~n'
	Else
		ls_board_text += '~r~n' + ls_err_msg + '~r~n'
	End IF
	ll_color  = ldb_color
NEXT

IF	ls_board_text<>'' THEN ::clipboard (ls_board_text)

f_messageBox ('END', '원장생성 작업~r~n~r~n실행시간 : ' + f_hhmmss (lt_start, now ()) + '~r~n' + ls_board_text)
end event

type cb_1 from pf_u_commandbutton within w_run
integer x = 3387
integer y = 192
integer width = 576
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "에러메세지CLEAR"
end type

event clicked;DELETE FROM WFRMERR;
commitJ ()
end event

