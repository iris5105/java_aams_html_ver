forward
global type w_ja031h from wt_listole
end type
type cb_folder from pf_u_commandbutton within w_ja031h
end type
type cb_1 from commandbutton within w_ja031h
end type
end forward

global type w_ja031h from wt_listole
cb_folder cb_folder
cb_1 cb_1
end type
global w_ja031h w_ja031h

event wue_lastopen;call super::wue_lastopen;DATETIME ldt1, ldt2

SELECT trunc (:idt_workdate,'mm') - 1
     , ADD_MONTHS(trunc (:idt_workdate,'mm'), -12)
  INTO :ldt2
     , :ldt1
  FROM DUAL;

ldt2 = SQLCA.getitemdatetime (1)
ldt1 = SQLCA.getitemdatetime (2)

dw_c.object.fymd [1] = ldt1
dw_c.object.tymd [1] = ldt2
end event

on w_ja031h.create
int iCurrent
call super::create
this.cb_folder=create cb_folder
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_folder
this.Control[iCurrent+2]=this.cb_1
end on

on w_ja031h.destroy
call super::destroy
destroy(this.cb_folder)
destroy(this.cb_1)
end on

type lb_dirlist from wt_listole`lb_dirlist within w_ja031h
end type

type ln_templeft from wt_listole`ln_templeft within w_ja031h
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja031h
end type

type ln_temptop from wt_listole`ln_temptop within w_ja031h
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja031h
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja031h
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja031h
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja031h
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja031h
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja031h
end type

type ln_tempright from wt_listole`ln_tempright within w_ja031h
end type

type uo_navi from wt_listole`uo_navi within w_ja031h
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja031h
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja031h
end type

type st_top_rect from wt_listole`st_top_rect within w_ja031h
end type

type p_close from wt_listole`p_close within w_ja031h
end type

type p_excel from wt_listole`p_excel within w_ja031h
end type

type p_print from wt_listole`p_print within w_ja031h
end type

type p_delete from wt_listole`p_delete within w_ja031h
end type

type p_update from wt_listole`p_update within w_ja031h
end type

type p_input from wt_listole`p_input within w_ja031h
end type

type p_retrieve from wt_listole`p_retrieve within w_ja031h
end type

type p_clear from wt_listole`p_clear within w_ja031h
end type

type p_copy from wt_listole`p_copy within w_ja031h
end type

type dw_c from wt_listole`dw_c within w_ja031h
string title = "조회일자"
string dataobject = "dc_ftymd"
end type

type btn_update from wt_listole`btn_update within w_ja031h
end type

type st_count from wt_listole`st_count within w_ja031h
end type

type dw_list from wt_listole`dw_list within w_ja031h
end type

type st_move from wt_listole`st_move within w_ja031h
end type

type ole_rd from wt_listole`ole_rd within w_ja031h
integer y = 348
integer height = 2416
boolean eb_onepage = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;STRING	ls_s[] = {'일임수익률','일임재산 설정(운용) 및 해지내역','일임자산 설정 현황','일임계좌 주식 매매거래내역','일임계좌 채권 매매거래내역','일임계좌 CD(CP) 매매거래내역','일임자산 회전율 내역','공모주 취득 및 배정내역'}
STRING	ls_r[] = {'_s1.mrd','_s2.mrd','_s3.mrd','_s4.mrd','_s5.mrd','_s6.mrd','_s7.mrd','_s8.mrd'}, ls_file
STRING	ls_filename

LONG	ll

FOR  ll = 1  TO  8
	IF NOT FileExists (gaa.excel + ls_s [ll]) THEN FileDelete (gaa.excel + ls_s [ll])
NEXT

f_loadingretrieve (TRUE)

FOR  ll = 1  TO  8
	ls_filename = gaa.excel + ls_s [ll] + '.xls'
	IF	ll=1	Then
		uf_fileopen ('rd_ja031h_s1.mrd', 'ymd[' + string (dw_c.object.tymd [1],'yyyy.mm.dd') + ']')
	Else
		uf_fileopen ('rd_ja031h' + ls_r [ll], 'fymd[' + string (dw_c.object.fymd [1],'yyyy.mm.dd') + '] tymd[' + string (dw_c.object.tymd [1],'yyyy.mm.dd') + ']')
	End IF
	sleep (1)
   ole_rd.object.SetSaveExcelOption (1)
	IF	FileExists(ls_filename) THEN FileDelete(ls_filename)
   ole_rd.object.SaveAsXlsFile (ls_filename)
NEXT

IF	gfp.getprocesscount ('excel.exe')>0	Then
	messagebox('알림', '실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
	gfp.killprocess ('excel.exe')
End IF

OLEObject   obj_1, lSheet

obj_1 = CREATE oleobject
IF obj_1.ConnectToNewObject ('excel.application')<>0  Then // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF
obj_1.Application.displayalerts = FALSE
obj_1.Application.Visible = FALSE
obj_1.windowstate = 2
obj_1.WorkBooks.OPEN (gaa.pbr + 'kernel\통합 문서1.xlsm', 0, TRUE)
FOR  ll = 1  TO  8
	obj_1.WorkBooks.OPEN (gaa.excel + ls_s [ll] + '.xls', 0, TRUE)
NEXT

obj_1.Application.Run ("'통합 문서1.xlsm'!sheet_2402")

f_loadingretrieve (false)

ls_file = '운용현황(' + string (dw_c.object.fymd [1],'yyyymmdd') + '_' + string (dw_c.object.tymd [1],'yyyymmdd') + ').xls'

f_messageBox ('P000', '구간 운용현황 생성을 완료했습니다.~r~n저장폴더버튼을 클릭하여 ' + ls_file + ' 파일을 확인 하십시오.')

obj_1.windowstate = 3
obj_1.Application.Visible = true
obj_1.Application.ActiveWorkbook.SaveAs(gaa.excel + ls_file)
obj_1.Application.ActiveWorkbook.Saved = TRUE

DESTROY obj_1
end event

type rb_onepage from wt_listole`rb_onepage within w_ja031h
boolean enabled = false
boolean checked = true
end type

type cb_folder from pf_u_commandbutton within w_ja031h
integer x = 4672
integer y = 192
integer width = 457
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute (gaa.excel)
end event

type cb_1 from commandbutton within w_ja031h
boolean visible = false
integer x = 4558
integer width = 402
integer height = 120
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
boolean enabled = false
string text = "script"
end type

event clicked;OleObject lole_wsh

integer	li_rc
string	ls_mesg

lole_wsh = CREATE OleObject
li_rc = lole_wsh.ConnectToNewObject( "MSScriptControl.ScriptControl" )
IF	li_rc>=0	then
	lole_wsh.language = "VBScript"
	lole_wsh.AddCode('Sub RunExcelMacro()~r~n ' + &
			'Dim xlApp~r~n ' + &
			'Dim xlBook~r~n ' + &
			'If CheckAppOpen("excel.application")  Then~r~n ' + &
			'	Set xlApp = GetObject(, "Excel.Application")~r~n ' + &
			'Else~r~n ' + &
			'	Set  xlApp = CreateObject(,"Excel.Application")~r~n ' + &
			'End If~r~n ' + &
			'xlApp.visible = True~r~n ' + &
			'set xlBook = xlApp.Workbooks.Open ("일집계.xlsx", 0, True)~r~n ' + & 
			'xlApp.Quit()~r~n ' + &
			'xlBook = Nothing~r~n ' + &
			'xlApp = Nothing~r~n ' + &
			'End Sub~r~n ')
	
//	lole_wsh.AddCode('Sub RunExcelMacro()~r~n ' + &
//			'Dim xlApp~r~n ' + &
//			'Dim xlBook~r~n ' + &
//			'OleObject lole_wsh~r~n ' + &
//			'integer	li_rc~r~n ' + &
//			'string	ls_mesg ' + &
//			'Set xlApp = GetObject(, "Excel.Application")~r~n ' + &
//			'xlApp.visible = True~r~n ' + &
//			'set xlBook = xlApp.Workbooks.Open ("' + ls_s3 + '", 0, True)~r~n ' + &
//			'xlApp.Run "Windows("' + ls_s3 + '").Activate~r~n ' + &
//			'Sheets("Sheet1").Select~r~n ' + &
//			'Sheets("Sheet1").Name = "예수금"~r~n ' + &
//			'Range("B2:O2").Select~r~n ' + &
//			'Windows("' + ls_s2 + '").Activate~r~n ' + &
//			'Cells.Select~r~n ' + &
//			'Selection.Copy~r~n ' + &
//			'Windows("' + ls_s3 + '").Activate~r~n ' + &
//			'Sheets.Add After:=ActiveSheet~r~n ' + &
//			'ActiveSheet.Paste~r~n ' + &
//			'Sheets("Sheet1").Select~r~n ' + &
//			'Sheets("Sheet1").Name = "주식비중"~r~n ' + &
//			'Range("B1").Select~r~n ' + &
//			'Windows("' + ls_s1 + '").Activate~r~n ' + &
//			'Cells.Select~r~n ' + &
//			'Application.CutCopyMode = False~r~n ' + &
//			'Selection.Copy~r~n ' + &
//			'Windows("' + ls_s3 + '").Activate~r~n ' + &
//			'Sheets.Add After:=ActiveSheet~r~n ' + &
//			'ActiveSheet.Paste~r~n ' + &
//			'Sheets("Sheet2").Select~r~n ' + &
//			'Sheets("Sheet2").Name = "주식잔고"~r~n ' + &
//			'Range("B2:N2").Select~r~n ' + &
//			'Windows("' + ls_s2 + '").Activate~r~n ' + &
//			'ActiveWindow.Close ' + &
//			'Windows("' + ls_s1 + '").Activate~r~n ' + &
//			'ActiveWindow.Close~r~n ' + &
//			'Range("B2:N2").Select"~r~n ' + &
//			'xlApp.Quit()~r~n ' + &
//			'xlBook = Nothing~r~n ' + &
//			'xlApp = Nothing~r~n ' + &
//			'end function~r~n ')

	lole_wsh.Eval("RunExcelMacro")

	lole_wsh.DisconnectObject()
End IF

DESTROY	lole_wsh
end event

