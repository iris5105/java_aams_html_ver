forward
global type w_ja031j from wt_listole
end type
type cb_xls from pf_u_commandbutton within w_ja031j
end type
type cb_ga191 from pf_u_commandbutton within w_ja031j
end type
type cb_flder from pf_u_commandbutton within w_ja031j
end type
end forward

global type w_ja031j from wt_listole
cb_xls cb_xls
cb_ga191 cb_ga191
cb_flder cb_flder
end type
global w_ja031j w_ja031j

type variables
STRING	is_ym
end variables

event wue_lastopen;call super::wue_lastopen;SELECT TO_CHAR(ADD_MONTHS(f_workdate(:gaa.corp_gr), -1), 'yyyymm') INTO :is_ym FROM DUAL ;

is_ym = SQLCA.GETITEMSTRING (1)

dw_c.object.ym [1] = is_ym
end event

on w_ja031j.create
int iCurrent
call super::create
this.cb_xls=create cb_xls
this.cb_ga191=create cb_ga191
this.cb_flder=create cb_flder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_xls
this.Control[iCurrent+2]=this.cb_ga191
this.Control[iCurrent+3]=this.cb_flder
end on

on w_ja031j.destroy
call super::destroy
destroy(this.cb_xls)
destroy(this.cb_ga191)
destroy(this.cb_flder)
end on

type lb_dirlist from wt_listole`lb_dirlist within w_ja031j
end type

type ln_templeft from wt_listole`ln_templeft within w_ja031j
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja031j
end type

type ln_temptop from wt_listole`ln_temptop within w_ja031j
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja031j
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja031j
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja031j
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja031j
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja031j
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja031j
end type

type ln_tempright from wt_listole`ln_tempright within w_ja031j
end type

type uo_navi from wt_listole`uo_navi within w_ja031j
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja031j
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja031j
end type

type st_top_rect from wt_listole`st_top_rect within w_ja031j
end type

type p_close from wt_listole`p_close within w_ja031j
end type

type p_excel from wt_listole`p_excel within w_ja031j
end type

type p_print from wt_listole`p_print within w_ja031j
end type

type p_delete from wt_listole`p_delete within w_ja031j
end type

type p_update from wt_listole`p_update within w_ja031j
end type

type p_input from wt_listole`p_input within w_ja031j
end type

type p_retrieve from wt_listole`p_retrieve within w_ja031j
end type

type p_clear from wt_listole`p_clear within w_ja031j
end type

type p_copy from wt_listole`p_copy within w_ja031j
end type

type dw_c from wt_listole`dw_c within w_ja031j
string title = "기준년월"
string dataobject = "dc_dddw_ym"
end type

type btn_update from wt_listole`btn_update within w_ja031j
end type

type st_count from wt_listole`st_count within w_ja031j
end type

type dw_list from wt_listole`dw_list within w_ja031j
string dataobject = "d_ja031j"
end type

event dw_list::rowfocuschanged;//
end event

event dw_list::rowfocuschanging;//
end event

type st_move from wt_listole`st_move within w_ja031j
end type

type ole_rd from wt_listole`ole_rd within w_ja031j
integer y = 348
integer height = 2416
integer ii_pagetype = 2
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;BOOLEAN	lb_cre = true
STRING	ls_ym, la_args [], ls_msg

LONG	ll_ga

cb_xls.enabled = true
cb_ga191.enabled = true

ls_ym = dw_c.object.ym [1]
IF	ls_ym>=is_ym OR gaa.admin	Then
	 SELECT COUNT(*)
		INTO :ll_ga
		FROM GA t1
	  WHERE CORP_GR = :gaa.CORP_GR
		 AND ym      = :ls_ym ;

	ll_ga = SQLCA.GETITEMNUMBER (1)
	IF ll_ga > 0   Then
		IF F_MESSAGEBOX ('I002','생성자료가 있습니다.~r~n다시 생성 하시겠습니까?')=2 THEN lb_cre = false
	END IF

	IF lb_cre   Then
		la_args [1] = gaa.CORP_GR
		la_args [2] = ls_ym
		SQLCA.SP_CALL (THIS, 'SR_JA031J ( ?, ? )', la_args[], ls_msg)
	END IF
End IF

UF_FILEOPEN ('RD_JA031J.mrd', 'ym[' + ls_ym + ']')
end event

type rb_onepage from wt_listole`rb_onepage within w_ja031j
end type

type cb_xls from pf_u_commandbutton within w_ja031j
integer x = 1467
integer y = 188
integer width = 544
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "보고서엑셀저장"
end type

event clicked;STRING	ls_gb, ls_ym, ls_file, ls_sheet

LONG	ll, lj, lR
LONG	ll_row, ll_sheet

OLEOBJECT   obj_excel, lSheet

ls_ym = dw_c.object.ym [1]

dw_list.uf_dataobject ('d_ja031j', false)
ll_row = dw_list.retrieve (gaa.CORP_GR, ls_ym)

obj_excel = CREATE OLEOBJECT

IF obj_excel.ConnectToNewObject ('Excel.Application') <> 0  Then   // 엑셀실행
   F_MESSAGEBOX ('XLS1', '')
   RETURN
END IF

ls_file = gaa.excel + '금감원보고서_' + ls_ym + '.xlsx'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      F_MESSAGEBOX ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   END IF
END IF

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.VISIBLE       = TRUE
obj_excel.Application.CutCopyMode   = FALSE
obj_excel.windowstate               = 3

obj_excel.workbooks.open (gnv_vari.basepath + '\금감원보고서.xlsx', 0, FALSE)// 읽기전용
lSheet = obj_excel.Application.ActiveSheet

ll_sheet = obj_excel.Application.Workbooks (1).worksheets.COUNT  // Sheet의 갯수 읽기

FOR ll = 1  TO  ll_sheet
   IF f_loadingyield ('exit') THEN EXIT

   ls_sheet = obj_excel.Application.Workbooks (1).worksheets (ll).NAME
   lSheet   = obj_excel.Application.Workbooks (1).worksheets (ll)
   lSheet.Activate
   lSheet.cells (3, 1).value = '회사 : ' + gaa.corp_nm + '               기준년월(일) : ' + mid (ls_ym, 1, 4) + '년' + mid (ls_ym, 5, 2) + '월'
   
   lR = 0
   FOR  lj = 1  TO  ll_row
      ls_gb = dw_list.object.c_01 [lj]
      IF ls_sheet<>ls_gb THEN CONTINUE

      IF ls_gb = 'GA179' OR ls_gb = 'GA186'  Then
         lR ++
         lSheet.cells (9 + lR, 2).value = dw_list.object.n_01 [lj]
         lSheet.cells (9 + lR, 3).value = dw_list.object.n_02 [lj]
         lSheet.cells (9 + lR, 4).value = dw_list.object.n_03 [lj]
         lSheet.cells (9 + lR, 5).value = dw_list.object.n_04 [lj]
      END IF

      IF ls_gb = 'GA180' OR ls_gb = 'GA187'  Then
         lR ++
         lSheet.cells (9 + lR, 3).value  = dw_list.object.n_01 [lj]
         lSheet.cells (9 + lR, 4).value  = dw_list.object.n_02 [lj]
         lSheet.cells (9 + lR, 5).value  = dw_list.object.n_03 [lj]
         lSheet.cells (11 + lR, 3).value = dw_list.object.n_01 [lj]
         lSheet.cells (11 + lR, 4).value = dw_list.object.n_02 [lj]
         lSheet.cells (11 + lR, 5).value = dw_list.object.n_03 [lj]
         lSheet.cells (15 + lR, 3).value = dw_list.object.n_01 [lj]
         lSheet.cells (15 + lR, 4).value = dw_list.object.n_02 [lj]
         lSheet.cells (15 + lR, 5).value = dw_list.object.n_03 [lj]
         lSheet.cells (17 + lR, 3).value = dw_list.object.n_01 [lj]
         lSheet.cells (17 + lR, 4).value = dw_list.object.n_02 [lj]
         lSheet.cells (17 + lR, 5).value = dw_list.object.n_03 [lj]
      END IF

      IF ls_gb = 'GA181'   Then
         lR ++
         lSheet.cells (10 + lR, 3).value  = dw_list.object.n_01 [lj]
         lSheet.cells (10 + lR, 4).value  = dw_list.object.n_02 [lj]
         lSheet.cells (10 + lR, 5).value  = dw_list.object.n_03 [lj]
         lSheet.cells (10 + lR, 6).value  = dw_list.object.n_04 [lj]
         lSheet.cells (10 + lR, 7).value  = dw_list.object.n_05 [lj]
         lSheet.cells (10 + lR, 8).value  = dw_list.object.n_06 [lj]
         lSheet.cells (10 + lR, 9).value  = dw_list.object.n_07 [lj]
         lSheet.cells (10 + lR, 10).value = dw_list.object.n_08 [lj]
         lSheet.cells (10 + lR, 11).value = dw_list.object.n_09 [lj]
         lSheet.cells (10 + lR, 12).value = dw_list.object.n_10 [lj]
         lSheet.cells (10 + lR, 13).value = 0
         lSheet.cells (10 + lR, 14).value = 0
         lSheet.cells (10 + lR, 15).value = dw_list.object.n_11 [lj]
         lSheet.cells (10 + lR, 16).value = dw_list.object.n_12 [lj]
         lSheet.cells (10 + lR, 17).value = dw_list.object.n_13 [lj]
         lSheet.cells (10 + lR, 18).value = dw_list.object.n_14 [lj]
         lSheet.cells (10 + lR, 19).value = dw_list.object.n_15 [lj]
         lSheet.cells (10 + lR, 20).value = dw_list.object.n_16 [lj]
         lSheet.cells (10 + lR, 21).value = dw_list.object.n_17 [lj]
         lSheet.cells (10 + lR, 22).value = dw_list.object.n_18 [lj]
         lSheet.cells (10 + lR, 23).value = dw_list.object.n_19 [lj]
         lSheet.cells (10 + lR, 24).value = dw_list.object.n_20 [lj]
      END IF

      IF ls_gb = 'GA182' OR ls_gb = 'GA189'  Then
         lR ++
         IF ls_gb='GA182' AND lR=6 THEN lR ++
         lSheet.cells (10 + lR, 2).value = dw_list.object.n_01 [lj]
         lSheet.cells (10 + lR, 3).value = dw_list.object.n_02 [lj]
         lSheet.cells (10 + lR, 4).value = dw_list.object.n_03 [lj]
         lSheet.cells (10 + lR, 5).value = dw_list.object.n_04 [lj]
      END IF

      IF ls_gb = 'GA188'   Then
         lR ++
         lSheet.cells (10 + lR, 3).value  = dw_list.object.n_01 [lj]
         lSheet.cells (10 + lR, 4).value  = dw_list.object.n_02 [lj]
         lSheet.cells (10 + lR, 5).value  = dw_list.object.n_03 [lj]
         lSheet.cells (10 + lR, 6).value  = dw_list.object.n_04 [lj]
         lSheet.cells (10 + lR, 7).value  = dw_list.object.n_05 [lj]
         lSheet.cells (10 + lR, 8).value  = dw_list.object.n_06 [lj]
         lSheet.cells (10 + lR, 9).value  = dw_list.object.n_07 [lj]
         lSheet.cells (10 + lR, 10).value = dw_list.object.n_08 [lj]
         lSheet.cells (10 + lR, 11).value = dw_list.object.n_09 [lj]
         lSheet.cells (10 + lR, 12).value = dw_list.object.n_10 [lj]
         lSheet.cells (10 + lR, 13).value = dw_list.object.n_11 [lj]
         lSheet.cells (10 + lR, 14).value = dw_list.object.n_12 [lj]
         lSheet.cells (10 + lR, 15).value = dw_list.object.n_13 [lj]
         lSheet.cells (10 + lR, 16).value = dw_list.object.n_14 [lj]
         lSheet.cells (10 + lR, 17).value = dw_list.object.n_15 [lj]
         lSheet.cells (10 + lR, 18).value = dw_list.object.n_16 [lj]
         lSheet.cells (10 + lR, 19).value = dw_list.object.n_17 [lj]
         lSheet.cells (10 + lR, 20).value = dw_list.object.n_18 [lj]
      END IF

      IF ls_gb = 'GA191'   Then
         lR = dw_list.object.n_03 [lj]
         
         lSheet.cells (lR, 4).value = dw_list.object.n_01 [lj]
         lSheet.cells (lR, 5).value = dw_list.object.n_02 [lj]
      END IF
   NEXT
NEXT

f_loadingyield ('stop')
TRY
   obj_excel.activeworkbook.SaveAS (ls_file)
   F_MESSAGEBOX ('INFO', ls_ym + '월 금감원보고서 생성작업이 완료 되었습니다.~r~n~r~n' + gaa.excel + '~r~n~r~nDirectory에서 자료를 확인하십시오.')
CATCH (runtimeerror er)
   F_MESSAGEBOX ('ERR', '파일이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
END TRY

obj_excel.DISCONNECTOBJECT ()
DESTROY obj_excel
end event

type cb_ga191 from pf_u_commandbutton within w_ja031j
integer x = 2062
integer y = 188
integer width = 530
integer taborder = 90
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "점검자료엑셀생성"
end type

event clicked;STRING	ls_ym, ls_fund_cd, ls_file

LONG	ll_row

OLEOBJECT   obj_xls, lSheet

ls_ym = dw_c.object.ym [1]

ls_file = gaa.excel + '금감원보고서_' + ls_ym + '(자료점검용).xls'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      F_MESSAGEBOX ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   END IF
END IF

dw_list.uf_dataobject ('d_ja031j_ga191', false)
ll_row = dw_list.retrieve (gaa.CORP_GR, ls_ym)
IF ll_row = 0  Then
   F_MESSAGEBOX ('INFO', '자료를 생성하십시오.')
   RETURN
END IF

SELECT LISTAGG (DISTINCT fund_cd,'@')
  INTO :ls_fund_cd
  FROM GA t1
 WHERE CORP_GR = :gaa.CORP_GR
   AND ym      = :ls_ym
   AND c_01    = 'GA191'
   AND fund_cd <> '%' ;

ls_fund_cd = SQLCA.GETITEMSTRING (1)

RegistrySet ("HKEY_CURRENT_USER\Software\Microsoft\VBA\GA191", "FUND", ls_fund_cd)

obj_xls = CREATE OLEOBJECT
IF obj_xls.ConnectToNewObject ('Excel.Application') <> 0 Then   // 엑셀실행
   F_MESSAGEBOX ('XLS1', '')
   RETURN
END IF

obj_xls.Application.displayalerts  = false
obj_xls.Application.VISIBLE        = TRUE
obj_xls.Application.ScreenUpdating = TRUE

obj_xls.workbooks.OPEN (gnv_vari.basepath + '\GA191.xlsm', 0, true)

obj_xls.Application.RUN ("'GA191.xlsm'!GA191_FUND")

BOOLEAN	lb_first

LONG	ll, lj, lR, ll_sheet

ll_sheet = obj_xls.Application.Workbooks (1).worksheets.COUNT  // Sheet의 갯수 읽기
FOR ll = 1  TO  ll_sheet
   ls_fund_cd = obj_xls.Application.Workbooks (1).worksheets (ll).NAME
   lSheet     = obj_xls.Application.Workbooks (1).worksheets (ll)
   lb_first   = true
   FOR  lj = 1  TO  ll_row
      IF dw_list.object.fund_cd [lj] = ls_fund_cd  Then
         IF lb_first Then
            lSheet.cells (3, 1).VALUE = '계좌 : ' + dw_list.object.fund_nm [lj] + '( ' + dw_list.object.fund_cd [lj] + ' )               기준년월(일) : ' + mid (ls_ym, 1, 4) + '년' + mid (ls_ym, 5, 2) + '월'
            lb_first                  = false
         END IF
         lR = dw_list.object.n_03 [lj]

         lSheet.cells (lR, 4).VALUE = dw_list.object.n_01 [lj]
         lSheet.cells (lR, 5).VALUE = dw_list.object.n_02 [lj]
      END IF
   NEXT
NEXT

obj_xls.Application.ActiveWorkbook.SaveAs (ls_file)
obj_xls.Application.ActiveWorkbook.Saved = TRUE

F_MESSAGEBOX ('INFO', ls_ym + '월 금감원보고서 생성작업이 완료 되었습니다.~r~n~r~n' + gaa.excel + '~r~n~r~nDirectory에서 자료를 확인하십시오.')

obj_xls.DISCONNECTOBJECT ()
DESTROY obj_xls
end event

type cb_flder from pf_u_commandbutton within w_ja031j
integer x = 2642
integer y = 188
integer width = 457
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute (gaa.excel)
end event

