forward
global type w_ja010o from wt_list
end type
type cb_1 from pf_u_commandbutton within w_ja010o
end type
end forward

global type w_ja010o from wt_list
cb_1 cb_1
end type
global w_ja010o w_ja010o

type variables

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.rcd [1])
cb_1.enabled = true
end event

on w_ja010o.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_ja010o.destroy
call super::destroy
destroy(this.cb_1)
end on

event wue_clear;call super::wue_clear;cb_1.enabled = false
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja010o
end type

type ln_templeft from wt_list`ln_templeft within w_ja010o
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja010o
end type

type ln_temptop from wt_list`ln_temptop within w_ja010o
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja010o
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja010o
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja010o
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja010o
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja010o
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja010o
end type

type ln_tempright from wt_list`ln_tempright within w_ja010o
end type

type uo_navi from wt_list`uo_navi within w_ja010o
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja010o
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja010o
end type

type st_top_rect from wt_list`st_top_rect within w_ja010o
end type

type p_close from wt_list`p_close within w_ja010o
end type

type p_excel from wt_list`p_excel within w_ja010o
end type

type p_print from wt_list`p_print within w_ja010o
end type

type p_delete from wt_list`p_delete within w_ja010o
end type

type p_update from wt_list`p_update within w_ja010o
end type

type p_input from wt_list`p_input within w_ja010o
end type

type p_retrieve from wt_list`p_retrieve within w_ja010o
end type

type p_clear from wt_list`p_clear within w_ja010o
end type

type p_copy from wt_list`p_copy within w_ja010o
end type

type dw_c from wt_list`dw_c within w_ja010o
string title = "기준일자@관리번호"
string dataobject = "dc_xx_ymd"
end type

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;RETURN 2
end event

type btn_update from wt_list`btn_update within w_ja010o
end type

type st_count from wt_list`st_count within w_ja010o
end type

type dw_list from wt_list`dw_list within w_ja010o
string dataobject = "d_ja010o1"
boolean eb_copy_false = true
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE 'coll_start'
      Object.coll_end [row] = f_add_months (datetime(date(MID (data,1,10))), 6, null_dt)
END CHOOSE
end event

event dw_list::retrieverow;call super::retrieverow;IF	f_null (Object.jm_cd [row])	Then
	Object.corp_gr [row]    = gaa.corp_gr
	Object.ymd [row]        = dw_c.object.ymd [1]
	Object.fund_cd [row]    = Object.jm_fund_cd [row]
	Object.jm_cd [row]      = Object.jm_jm_cd [row]
	Object.coll_start [row] = Object.jm_start [row]
	Object.coll_end   [row] = Object.jm_end [row]
	SetItemStatus (row, 0, Primary!, New!)
	SetItemStatus (row, 0, Primary!, NotModified!)
End IF
end event

type cb_1 from pf_u_commandbutton within w_ja010o
integer x = 3104
integer y = 192
integer width = 654
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string text = "신용/대출잔고LOAD"
end type

event clicked;call super::clicked;OLEObject   xlapp, xlsub

LONG	ret, r = 1, ll

STRING	ls_path, ls_name, ls_koscom_cd

// Create the oleobject variable xlapp
xlApp = CREATE OLEObject

IF GetFileOpenName ("담보잔액 엑셀파일 선택", ls_path, ls_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", gaa.excel, 2)<>1 THEN RETURN

ret = xlApp.ConnectToNewObject ("excel.application")
IF ret<0 Then
   f_messageBox ('XLS1', string(ret))
   RETURN
End IF
xlApp.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
xlApp.Application.Visible = FALSE
xlApp.windowstate = 2
xlsub = xlApp.Application.ActiveSheet

f_loadingchart (TRUE)
DO WHILE TRUE
   r ++
   ls_koscom_cd = TRIM (string (xlsub.cells (r,1).Value))
   IF f_null (ls_koscom_cd) THEN EXIT
   IF POS (ls_koscom_cd,'(A')>0 And POS (string (xlsub.cells (r,2).Value),'담보')>0 Then
      ls_koscom_cd = f_replace ((MID (ls_koscom_cd, POS (ls_koscom_cd,'(A') + 2)),')','')
   Else
      CONTINUE
   End IF

   ll = dw_list.FIND ("koscom_cd = '" + ls_koscom_cd + "'", 1, dw_list.rowcount ())
   IF ll>0  Then
      dw_list.setrow (ll)
      dw_list.scrolltorow (ll)
      dw_list.object.coll_jusu [ll] = f_num (xlsub.cells (r,3).value)
      IF f_null (dw_list.object.coll_start [ll])	Then
			dw_list.object.coll_start [ll] = dw_c.object.ymd [1]
			dw_list.object.coll_end [ll] = f_add_months (dw_c.object.ymd [1], 6, null_dt)
		End IF
      dw_list.object.collateral [ll] = f_num (xlsub.cells (r,9).value)
      dw_list.object.coll_status [ll] = 'load'
   End IF
LOOP
// 신용/담보대출 clear
FOR ll = dw_list.rowcount ()  TO  1  STEP -1
	IF	dw_list.object.coll_status [ll]='jango'	Then
		dw_list.deleterow (ll)
	End IF
NEXT
f_loadingchart (FALSE)

f_messageBox ('INFO', '신용/대출잔액 Load가 완료되었습니다.')
end event

