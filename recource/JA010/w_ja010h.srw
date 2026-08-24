forward
global type w_ja010h from wt_vertole
end type
type cb_rd1 from pf_u_commandbutton within w_ja010h
end type
type cb_xls from commandbutton within w_ja010h
end type
type cb_pdf from pf_u_commandbutton within w_ja010h
end type
type cb_rd3 from commandbutton within w_ja010h
end type
type cb_rd4 from pf_u_commandbutton within w_ja010h
end type
type cb_pj from pf_u_commandbutton within w_ja010h
end type
type cb_folder from pf_u_commandbutton within w_ja010h
end type
type cb_xls2 from pf_u_commandbutton within w_ja010h
end type
end forward

global type w_ja010h from wt_vertole
boolean eb_rowchangewait = true
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
cb_rd1 cb_rd1
cb_xls cb_xls
cb_pdf cb_pdf
cb_rd3 cb_rd3
cb_rd4 cb_rd4
cb_pj cb_pj
cb_folder cb_folder
cb_xls2 cb_xls2
end type
global w_ja010h w_ja010h

forward prototypes
public subroutine wf_xls2_2201 ()
public subroutine wf_xls2_2202 ()
end prototypes

public subroutine wf_xls2_2201 ();DateTime  ldt_ymd

LONG	r, c, ll

STRING	ls_file, ls_jm_cd, ls_danc_gb, ls_jm_nm, ls_gb = '', ls_clip

DEC	ldc_sise, ldc_sangj_jusu, ldc_jusu, ldc_aek, ldc_pyunga, ldc_merge

OLEObject   obj_excel, lSheet

ldt_ymd = dw_c.object.ymd [1]

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.xlsx + '투핸즈 COMPLIANCE(' + string(ldt_ymd,'yyyymmdd') + ').xls'
IF NOT FileExists (ls_file) THEN FileDelete (ls_file)

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.WorkBooks.OPEN (gnv_vari.basepath + '\통합 문서1.xlsm', 0, TRUE) // 읽기전용

obj_excel.Worksheets.Add
lSheet = obj_excel.Application.ActiveSheet
lSheet.Name = '박종인보유점검'

lSheet.cells(1, 1).Value = '소속'
lSheet.cells(1, 2).Value = '종목명'
lSheet.cells(1, 3).Value = '코드'
lSheet.cells(1, 4).Value = '수량'
lSheet.cells(1, 5).Value = '매입단가'
lSheet.cells(1, 6).Value = '매입금액'
lSheet.cells(1, 7).Value = '종가'
lSheet.cells(1, 8).Value = '평가금액'
lSheet.cells(1, 9).Value = '시가대비~r~n보유비율'

lSheet.Columns('A:C').NumberFormatLocal = '@'
lSheet.Columns('D:H').NumberFormatLocal = '#,##0'
lSheet.Columns('I:I').NumberFormatLocal = '0.00'

STRING	ls_sqlsyntax

LONG	lR, lj

ls_sqlsyntax = " SELECT  t1.jm_cd " + &
               "       , jj.danc_gb " + &
               "       , t1.jm_nm " + &
               "       , t1.sise " + &
               "       , jj.sangj_jusu " + &
               "       , sum(t1.aekm) " + &
               "       , sum(t1.chui_aek) " + &
               "       , sum(t1.siga_aek) " + &
               " FROM    uzm0ui t1 " + &
               "       , sjm0jj jj " + &
               " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
               "   AND   t1.ymd      = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND   t1.fund_cd  IN ('1401','1520','1521') " + &
               "   AND   t1.siga_aek != 0 " + &
               "   AND   t1.jm_gr    = '3' " + &
               "   AND   jj.jm_cd    = t1.jm_cd " + &
               " GROUP BY  t1.jm_cd " + &
               "         , jj.danc_gb " + &
               "         , t1.jm_nm " + &
               "         , t1.sise " + &
               "         , jj.sangj_jusu " + &
               " ORDER BY  jj.danc_gb " + &
               "         , t1.jm_cd "

r = 2
lSheet.Rows('1:1').HorizontalAlignment = 3
lSheet.Columns('C:C').HorizontalAlignment = 3
lSheet.Columns('A:I').Font.Name = "맑은 고딕"
lSheet.Columns('A:I').Font.Size = 10

lSheet.Range('A1:I1').Borders.LineStyle = 1
lSheet.Range('A1:I1').Borders.Weight = 2
lSheet.Range('A1:I1').Borders(12).Weight = 1

ldc_merge = 0
ls_clip = ''

lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
FOR  lj = 1  TO  lR
   ls_jm_cd       = gds.getitemstring (lj, 1)
	ls_danc_gb     = gds.getitemstring (lj, 2)
	ls_jm_nm       = gds.getitemstring (lj, 3)
	ldc_sise       = gds.getitemnumber (lj, 4)
	ldc_sangj_jusu = gds.getitemnumber (lj, 5)
	ldc_jusu       = gds.getitemnumber (lj, 6)
	ldc_aek        = gds.getitemnumber (lj, 7)
	ldc_pyunga     = gds.getitemnumber (lj, 8)

   IF ls_gb<>ls_danc_gb Then
      IF ldc_merge>0 Then
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
      End IF
      ls_gb = ls_danc_gb
      ldc_merge = r
      lSheet.cells(r, 1).Value = IIF(ls_danc_gb='A','KOSPI','KOSDAQ')
   End IF
   ls_clip += ls_jm_nm + '~t'
   ls_clip += ls_jm_cd + '~t'
   ls_clip += string(ldc_jusu) + '~t'
   ls_clip += string(ldc_aek / ldc_jusu) + '~t'
   ls_clip += string(ldc_aek) + '~t'
   ls_clip += string(ldc_sise) + '~t'
   ls_clip += string(ldc_pyunga) + '~t'
   ls_clip += string(f_nvl(ldc_pyunga / (ldc_sangj_jusu * ldc_sise) * 100,'')) + '~r~n'
   r ++
NEXT
lSheet.cells(2, 2).Select
::Clipboard (ls_clip)
lSheet.Paste()

IF	lR>0	Then
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
End IF

lSheet.Columns.AutoFit
lSheet.Rows.AutoFit


obj_excel.Worksheets.Add
lSheet = obj_excel.Application.ActiveSheet
lSheet.Name = '조영석보유점검'

lSheet.cells(1, 1).Value = '소속'
lSheet.cells(1, 2).Value = '종목명'
lSheet.cells(1, 3).Value = '코드'
lSheet.cells(1, 4).Value = '수량'
lSheet.cells(1, 5).Value = '매입단가'
lSheet.cells(1, 6).Value = '매입금액'
lSheet.cells(1, 7).Value = '종가'
lSheet.cells(1, 8).Value = '평가금액'
lSheet.cells(1, 9).Value = '시가대비~r~n보유비율'

lSheet.Columns('A:C').NumberFormatLocal = '@'
lSheet.Columns('D:H').NumberFormatLocal = '#,##0'
lSheet.Columns('I:I').NumberFormatLocal = '0.00'

ls_sqlsyntax = " SELECT  t1.jm_cd " + &
               "       , jj.danc_gb " + &
               "       , t1.jm_nm " + &
               "       , t1.sise " + &
               "       , jj.sangj_jusu " + &
               "       , sum(t1.aekm) " + &
               "       , sum(t1.chui_aek) " + &
               "       , sum(t1.siga_aek) " + &
               " FROM    uzm0ui t1 " + &
               "       , sjm0jj jj " + &
               " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
               "   AND   t1.ymd      = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND   t1.fund_cd  IN ('1405','1439','1501','1734') " + &
               "   AND   t1.siga_aek != 0 " + &
               "   AND   t1.jm_gr    = '3' " + &
               "   AND   jj.jm_cd    = t1.jm_cd " + &
               " GROUP BY  t1.jm_cd " + &
               "         , jj.danc_gb " + &
               "         , t1.jm_nm " + &
               "         , t1.sise " + &
               "         , jj.sangj_jusu " + &
               " ORDER BY  jj.danc_gb " + &
               "         , t1.jm_cd "

r = 2
lSheet.Rows('1:1').HorizontalAlignment = 3
lSheet.Columns('C:C').HorizontalAlignment = 3
lSheet.Columns('A:I').Font.Name = "맑은 고딕"
lSheet.Columns('A:I').Font.Size = 10

lSheet.Range('A1:I1').Borders.LineStyle = 1
lSheet.Range('A1:I1').Borders.Weight = 2
lSheet.Range('A1:I1').Borders(12).Weight = 1

ldc_merge = 0
ls_clip = ''

lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
FOR  lj = 1  TO  lR
   ls_jm_cd       = gds.getitemstring (lj, 1)
	ls_danc_gb     = gds.getitemstring (lj, 2)
	ls_jm_nm       = gds.getitemstring (lj, 3)
	ldc_sise       = gds.getitemnumber (lj, 4)
	ldc_sangj_jusu = gds.getitemnumber (lj, 5)
	ldc_jusu       = gds.getitemnumber (lj, 6)
	ldc_aek        = gds.getitemnumber (lj, 7)
	ldc_pyunga     = gds.getitemnumber (lj, 8)

   IF ls_gb<>ls_danc_gb Then
      IF ldc_merge>0 Then
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
      End IF
      ls_gb = ls_danc_gb
      ldc_merge = r
      lSheet.cells(r, 1).Value = IIF(ls_danc_gb='A','KOSPI','KOSDAQ')
   End IF
   ls_clip += ls_jm_nm + '~t'
   ls_clip += ls_jm_cd + '~t'
   ls_clip += string(ldc_jusu) + '~t'
   ls_clip += string(ldc_aek / ldc_jusu) + '~t'
   ls_clip += string(ldc_aek) + '~t'
   ls_clip += string(ldc_sise) + '~t'
   ls_clip += string(ldc_pyunga) + '~t'
   ls_clip += string(f_nvl(ldc_pyunga / (ldc_sangj_jusu * ldc_sise) * 100,'')) + '~r~n'
   r ++
NEXT
lSheet.cells(2, 2).Select
::Clipboard (ls_clip)
lSheet.Paste()

IF	lR>0	Then
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
End IF

lSheet.Columns.AutoFit
lSheet.Rows.AutoFit

obj_excel.Worksheets.Add
lSheet = obj_excel.Application.ActiveSheet
lSheet.Name = '김미숙보유점검'

lSheet.cells(1, 1).Value = '소속'
lSheet.cells(1, 2).Value = '종목명'
lSheet.cells(1, 3).Value = '코드'
lSheet.cells(1, 4).Value = '수량'
lSheet.cells(1, 5).Value = '매입단가'
lSheet.cells(1, 6).Value = '매입금액'
lSheet.cells(1, 7).Value = '종가'
lSheet.cells(1, 8).Value = '평가금액'
lSheet.cells(1, 9).Value = '시가대비~r~n보유비율'

lSheet.Columns('A:C').NumberFormatLocal = '@'
lSheet.Columns('D:H').NumberFormatLocal = '#,##0'
lSheet.Columns('I:I').NumberFormatLocal = '0.00'

ls_sqlsyntax = " SELECT  t1.jm_cd " + &
               "       , jj.danc_gb " + &
               "       , t1.jm_nm " + &
               "       , t1.sise " + &
               "       , jj.sangj_jusu " + &
               "       , sum(t1.aekm) " + &
               "       , sum(t1.chui_aek) " + &
               "       , sum(t1.siga_aek) " + &
               " FROM    uzm0ui t1 " + &
               "       , sjm0jj jj " + &
               " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
               "   AND   t1.ymd      = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND   t1.fund_cd  IN ('1431','1701','1605','1708') " + &
               "   AND   t1.siga_aek != 0 " + &
               "   AND   t1.jm_gr    = '3' " + &
               "   AND   jj.jm_cd    = t1.jm_cd " + &
               " GROUP BY  t1.jm_cd " + &
               "         , jj.danc_gb " + &
               "         , t1.jm_nm " + &
               "         , t1.sise " + &
               "         , jj.sangj_jusu " + &
               " ORDER BY  jj.danc_gb " + &
               "         , t1.jm_cd "

r = 2
lSheet.Rows('1:1').HorizontalAlignment = 3
lSheet.Columns('C:C').HorizontalAlignment = 3
lSheet.Columns('A:I').Font.Name = "맑은 고딕"
lSheet.Columns('A:I').Font.Size = 10

lSheet.Range('A1:I1').Borders.LineStyle = 1
lSheet.Range('A1:I1').Borders.Weight = 2
lSheet.Range('A1:I1').Borders(12).Weight = 1

ldc_merge = 0
ls_clip = ''

lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
FOR  lj = 1  TO  lR
   ls_jm_cd       = gds.getitemstring (lj, 1)
	ls_danc_gb     = gds.getitemstring (lj, 2)
	ls_jm_nm       = gds.getitemstring (lj, 3)
	ldc_sise       = gds.getitemnumber (lj, 4)
	ldc_sangj_jusu = gds.getitemnumber (lj, 5)
	ldc_jusu       = gds.getitemnumber (lj, 6)
	ldc_aek        = gds.getitemnumber (lj, 7)
	ldc_pyunga     = gds.getitemnumber (lj, 8)

   IF ls_gb<>ls_danc_gb Then
      IF ldc_merge>0 Then
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
      End IF
      ls_gb = ls_danc_gb
      ldc_merge = r
      lSheet.cells(r, 1).Value = IIF(ls_danc_gb='A','KOSPI','KOSDAQ')
   End IF
   ls_clip += ls_jm_nm + '~t'
   ls_clip += ls_jm_cd + '~t'
   ls_clip += string(ldc_jusu) + '~t'
   ls_clip += string(ldc_aek / ldc_jusu) + '~t'
   ls_clip += string(ldc_aek) + '~t'
   ls_clip += string(ldc_sise) + '~t'
   ls_clip += string(ldc_pyunga) + '~t'
   ls_clip += string(f_nvl(ldc_pyunga / (ldc_sangj_jusu * ldc_sise) * 100,'')) + '~r~n'
   r ++
NEXT
lSheet.cells(2, 2).Select
::Clipboard (ls_clip)
lSheet.Paste()

IF	lR>0 And ldc_merge>0	Then
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
End IF

lSheet.Columns.AutoFit
lSheet.Rows.AutoFit


obj_excel.Worksheets.Add
lSheet = obj_excel.Application.ActiveSheet
lSheet.Name = '종합보유비율점검'

lSheet.cells(1, 1).Value = '소속'
lSheet.cells(1, 2).Value = '종목명'
lSheet.cells(1, 3).Value = '코드'
lSheet.cells(1, 4).Value = '수량'
lSheet.cells(1, 5).Value = '매입단가'
lSheet.cells(1, 6).Value = '매입금액'
lSheet.cells(1, 7).Value = '종가'
lSheet.cells(1, 8).Value = '평가금액'
lSheet.cells(1, 9).Value = '시가대비~r~n보유비율'

lSheet.Columns('A:C').NumberFormatLocal = '@'
lSheet.Columns('D:H').NumberFormatLocal = '#,##0'
lSheet.Columns('I:I').NumberFormatLocal = '0.00'

ls_sqlsyntax = " SELECT  t1.jm_cd " + &
               "       , jj.danc_gb " + &
               "       , t1.jm_nm " + &
               "       , t1.sise " + &
               "       , jj.sangj_jusu " + &
               "       , sum(t1.aekm) " + &
               "       , sum(t1.chui_aek) " + &
               "       , sum(t1.siga_aek) " + &
               " FROM    uzm0ui t1 " + &
               "       , sjm0jj jj " + &
               "       , szm0ia ia " + &
               " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
               "   AND   t1.ymd      = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND   t1.siga_aek != 0 " + &
               "   AND   t1.jm_gr    = '3' " + &
               "   AND   jj.jm_cd    = t1.jm_cd " + &
               "   AND   ia.corp_gr  = t1.corp_gr " + &
               "   AND   ia.fund_cd  = t1.fund_cd " + &
               "   AND   ia.type_gb  != 'X' " + &
               " GROUP BY  t1.jm_cd " + &
               "         , jj.danc_gb " + &
               "         , t1.jm_nm " + &
               "         , t1.sise " + &
               "         , jj.sangj_jusu " + &
               " HAVING SUM(t1.aekm) != 0 " + &
               " ORDER BY  jj.danc_gb " + &
               "         , t1.jm_cd "

r = 2
lSheet.Rows('1:1').HorizontalAlignment = 3
lSheet.Columns('C:C').HorizontalAlignment = 3
lSheet.Columns('A:I').Font.Name = "맑은 고딕"
lSheet.Columns('A:I').Font.Size = 10

lSheet.Range('A1:I1').Borders.LineStyle = 1
lSheet.Range('A1:I1').Borders.Weight = 2
lSheet.Range('A1:I1').Borders(12).Weight = 1

ldc_merge = 0
ls_clip = ''

lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
FOR  lj = 1  TO  lR
   ls_jm_cd       = gds.getitemstring (lj, 1)
	ls_danc_gb     = gds.getitemstring (lj, 2)
	ls_jm_nm       = gds.getitemstring (lj, 3)
	ldc_sise       = gds.getitemnumber (lj, 4)
	ldc_sangj_jusu = gds.getitemnumber (lj, 5)
	ldc_jusu       = gds.getitemnumber (lj, 6)
	ldc_aek        = gds.getitemnumber (lj, 7)
	ldc_pyunga     = gds.getitemnumber (lj, 8)

   IF ls_gb<>ls_danc_gb Then
      IF ldc_merge>0 Then
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
      End IF
      ls_gb = ls_danc_gb
      ldc_merge = r
      lSheet.cells(r, 1).Value = IIF(ls_danc_gb='A','KOSPI','KOSDAQ')
   End IF
   ls_clip += ls_jm_nm + '~t'
   ls_clip += ls_jm_cd + '~t'
   ls_clip += string(ldc_jusu) + '~t'
   ls_clip += string(ldc_aek / ldc_jusu) + '~t'
   ls_clip += string(ldc_aek) + '~t'
   ls_clip += string(ldc_sise) + '~t'
   ls_clip += string(ldc_pyunga) + '~t'
   ls_clip += string(f_nvl(ldc_pyunga / (ldc_sangj_jusu * ldc_sise) * 100,'')) + '~r~n'
   r ++
NEXT
lSheet.cells(2, 2).Select
::Clipboard (ls_clip)
lSheet.Paste()

IF	lR>0	Then
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
	lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
	lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
End IF

lSheet.Columns.AutoFit
lSheet.Rows.AutoFit

obj_excel.Sheets('Sheet1').DELETE
obj_excel.Application.ActiveWorkbook.SaveAs (ls_file)
obj_excel.Application.ActiveWorkbook.Saved = TRUE
obj_excel.DisConnectObject()

f_loadingyield ('stop')
f_messageBox ('P000','COMPLIANCE 생성작업이 완료 되었습니다.')

DESTROY lSheet
DESTROY obj_excel
end subroutine

public subroutine wf_xls2_2202 ();DateTime  ldt_ymd

LONG	r, c, ll

STRING	ls_file, ls_jm_cd, ls_danc_gb, ls_jm_nm, ls_gb = '', ls_clip

DEC	ldc_sise, ldc_sangj_jusu, ldc_jusu, ldc_aek, ldc_pyunga, ldc_merge

OLEObject   obj_excel, lSheet

ldt_ymd = dw_c.object.ymd [1]

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.xlsx + '이언 COMPLIANCE(' + string(ldt_ymd,'yyyymmdd') + ').xls'
IF NOT FileExists (ls_file) THEN FileDelete (ls_file)

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.WorkBooks.OPEN (gnv_vari.basepath + '\통합 문서1.xlsx', 0, TRUE) // 읽기전용

obj_excel.Worksheets.Add
lSheet = obj_excel.Application.ActiveSheet
lSheet.Name = '박성진보유점검'

lSheet.cells(1, 1).Value = '소속'
lSheet.cells(1, 2).Value = '종목명'
lSheet.cells(1, 3).Value = '코드'
lSheet.cells(1, 4).Value = '수량'
lSheet.cells(1, 5).Value = '매입단가'
lSheet.cells(1, 6).Value = '매입금액'
lSheet.cells(1, 7).Value = '종가'
lSheet.cells(1, 8).Value = '평가금액'
lSheet.cells(1, 9).Value = '시가대비~r~n보유비율'

lSheet.Columns('A:C').NumberFormatLocal = '@'
lSheet.Columns('D:H').NumberFormatLocal = '#,##0'
lSheet.Columns('I:I').NumberFormatLocal = '0.00'

STRING	ls_sqlsyntax

LONG	lR, lj

ls_sqlsyntax = " SELECT  t1.jm_cd " + &
               "       , jj.danc_gb " + &
               "       , t1.jm_nm " + &
               "       , t1.sise " + &
               "       , jj.sangj_jusu " + &
               "       , sum(t1.aekm) " + &
               "       , sum(t1.chui_aek) " + &
               "       , sum(t1.siga_aek) " + &
               " FROM    uzm0ui t1 " + &
               "       , sjm0jj jj " + &
               " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
               "   AND   t1.ymd      = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND   t1.fund_cd  IN ('1901','1902','1903') " + &
               "   AND   t1.siga_aek != 0 " + &
               "   AND   t1.jm_gr    = '3' " + &
               "   AND   jj.jm_cd    = t1.jm_cd " + &
               " GROUP BY  t1.jm_cd " + &
               "         , jj.danc_gb " + &
               "         , t1.jm_nm " + &
               "         , t1.sise " + &
               "         , jj.sangj_jusu " + &
               " ORDER BY  jj.danc_gb " + &
               "         , t1.jm_cd "

r = 2
lSheet.Rows('1:1').HorizontalAlignment = 3
lSheet.Columns('C:C').HorizontalAlignment = 3
lSheet.Columns('A:I').Font.Name = "맑은 고딕"
lSheet.Columns('A:I').Font.Size = 10

lSheet.Range('A1:I1').Borders.LineStyle = 1
lSheet.Range('A1:I1').Borders.Weight = 2
lSheet.Range('A1:I1').Borders(12).Weight = 1

ldc_merge = 0
ls_clip = ''

lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
FOR  lj = 1  TO  lR
   ls_jm_cd       = gds.getitemstring (lj, 1)
	ls_danc_gb     = gds.getitemstring (lj, 2)
	ls_jm_nm       = gds.getitemstring (lj, 3)
	ldc_sise       = gds.getitemnumber (lj, 4)
	ldc_sangj_jusu = gds.getitemnumber (lj, 5)
	ldc_jusu       = gds.getitemnumber (lj, 6)
	ldc_aek        = gds.getitemnumber (lj, 7)
	ldc_pyunga     = gds.getitemnumber (lj, 8)

   IF ls_gb<>ls_danc_gb Then
      IF ldc_merge>0 Then
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
      End IF
      ls_gb = ls_danc_gb
      ldc_merge = r
      lSheet.cells(r, 1).Value = IIF(ls_danc_gb='A','KOSPI','KOSDAQ')
   End IF
   ls_clip += ls_jm_nm + '~t'
   ls_clip += ls_jm_cd + '~t'
   ls_clip += string(ldc_jusu) + '~t'
   ls_clip += string(ldc_aek / ldc_jusu) + '~t'
   ls_clip += string(ldc_aek) + '~t'
   ls_clip += string(ldc_sise) + '~t'
   ls_clip += string(ldc_pyunga) + '~t'
   ls_clip += string(f_nvl(ldc_pyunga / (ldc_sangj_jusu * ldc_sise) * 100,'')) + '~r~n'
   r ++
NEXT
lSheet.cells(2, 2).Select
::Clipboard (ls_clip)
lSheet.Paste()

lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1

lSheet.Columns.AutoFit
lSheet.Rows.AutoFit


obj_excel.Worksheets.Add
lSheet = obj_excel.Application.ActiveSheet
lSheet.Name = '종합보유비율점검'

lSheet.cells(1, 1).Value = '소속'
lSheet.cells(1, 2).Value = '종목명'
lSheet.cells(1, 3).Value = '코드'
lSheet.cells(1, 4).Value = '수량'
lSheet.cells(1, 5).Value = '매입단가'
lSheet.cells(1, 6).Value = '매입금액'
lSheet.cells(1, 7).Value = '종가'
lSheet.cells(1, 8).Value = '평가금액'
lSheet.cells(1, 9).Value = '시가대비~r~n보유비율'

lSheet.Columns('A:C').NumberFormatLocal = '@'
lSheet.Columns('D:H').NumberFormatLocal = '#,##0'
lSheet.Columns('I:I').NumberFormatLocal = '0.00'

ls_sqlsyntax = " SELECT  t1.jm_cd " + &
               "       , jj.danc_gb " + &
               "       , t1.jm_nm " + &
               "       , t1.sise " + &
               "       , jj.sangj_jusu " + &
               "       , sum(t1.aekm) " + &
               "       , sum(t1.chui_aek) " + &
               "       , sum(t1.siga_aek) " + &
               " FROM    uzm0ui t1 " + &
               "       , sjm0jj jj " + &
               "       , szm0ia ia " + &
               " WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " + &
               "   AND   t1.ymd      = '" + string (ldt_ymd,'yyyy.mm.dd') + "' " + &
               "   AND   t1.siga_aek != 0 " + &
               "   AND   t1.jm_gr    = '3' " + &
               "   AND   jj.jm_cd    = t1.jm_cd " + &
               "   AND   ia.corp_gr  = t1.corp_gr " + &
               "   AND   ia.fund_cd  = t1.fund_cd " + &
               "   AND   ia.type_gb  != 'X' " + &
               " GROUP BY  t1.jm_cd " + &
               "         , jj.danc_gb " + &
               "         , t1.jm_nm " + &
               "         , t1.sise " + &
               "         , jj.sangj_jusu " + &
               " HAVING SUM(t1.aekm) != 0 " + &
               " ORDER BY  jj.danc_gb " + &
               "         , t1.jm_cd "

r = 2
lSheet.Rows('1:1').HorizontalAlignment = 3
lSheet.Columns('C:C').HorizontalAlignment = 3
lSheet.Columns('A:I').Font.Name = "맑은 고딕"
lSheet.Columns('A:I').Font.Size = 10

lSheet.Range('A1:I1').Borders.LineStyle = 1
lSheet.Range('A1:I1').Borders.Weight = 2
lSheet.Range('A1:I1').Borders(12).Weight = 1

ldc_merge = 0
ls_clip = ''

lR = SQLCA.sql2ds (classname(), ls_sqlsyntax, gds, 'xml')
FOR  lj = 1  TO  lR
   ls_jm_cd       = gds.getitemstring (lj, 1)
	ls_danc_gb     = gds.getitemstring (lj, 2)
	ls_jm_nm       = gds.getitemstring (lj, 3)
	ldc_sise       = gds.getitemnumber (lj, 4)
	ldc_sangj_jusu = gds.getitemnumber (lj, 5)
	ldc_jusu       = gds.getitemnumber (lj, 6)
	ldc_aek        = gds.getitemnumber (lj, 7)
	ldc_pyunga     = gds.getitemnumber (lj, 8)

   IF ls_gb<>ls_danc_gb Then
      IF ldc_merge>0 Then
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
         lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
         lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1
      End IF
      ls_gb = ls_danc_gb
      ldc_merge = r
      lSheet.cells(r, 1).Value = IIF(ls_danc_gb='A','KOSPI','KOSDAQ')
   End IF
   ls_clip += ls_jm_nm + '~t'
   ls_clip += ls_jm_cd + '~t'
   ls_clip += string(ldc_jusu) + '~t'
   ls_clip += string(ldc_aek / ldc_jusu) + '~t'
   ls_clip += string(ldc_aek) + '~t'
   ls_clip += string(ldc_sise) + '~t'
   ls_clip += string(ldc_pyunga) + '~t'
   ls_clip += string(f_nvl(ldc_pyunga / (ldc_sangj_jusu * ldc_sise) * 100,'')) + '~r~n'
   r ++
NEXT
lSheet.cells(2, 2).Select
::Clipboard (ls_clip)
lSheet.Paste()

lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).MERGE
lSheet.Range('A'+string(ldc_merge)+':A'+string(r - 1)).Orientation = 255
lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.LineStyle = 1
lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders.Weight = 2
lSheet.Range('A'+string(ldc_merge)+':I'+string(r - 1)).Borders(12).Weight = 1

lSheet.Columns.AutoFit
lSheet.Rows.AutoFit

obj_excel.Sheets('Sheet1').DELETE
obj_excel.Application.ActiveWorkbook.SaveAs (ls_file)
obj_excel.Application.ActiveWorkbook.Saved = TRUE

f_loadingyield ('stop')
f_messageBox ('P000','COMPLIANCE 생성작업이 완료 되었습니다.')

obj_excel.DisConnectObject()

DESTROY lSheet
DESTROY obj_excel
end subroutine

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

on w_ja010h.create
int iCurrent
call super::create
this.cb_rd1=create cb_rd1
this.cb_xls=create cb_xls
this.cb_pdf=create cb_pdf
this.cb_rd3=create cb_rd3
this.cb_rd4=create cb_rd4
this.cb_pj=create cb_pj
this.cb_folder=create cb_folder
this.cb_xls2=create cb_xls2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_rd1
this.Control[iCurrent+2]=this.cb_xls
this.Control[iCurrent+3]=this.cb_pdf
this.Control[iCurrent+4]=this.cb_rd3
this.Control[iCurrent+5]=this.cb_rd4
this.Control[iCurrent+6]=this.cb_pj
this.Control[iCurrent+7]=this.cb_folder
this.Control[iCurrent+8]=this.cb_xls2
end on

on w_ja010h.destroy
call super::destroy
destroy(this.cb_rd1)
destroy(this.cb_xls)
destroy(this.cb_pdf)
destroy(this.cb_rd3)
destroy(this.cb_rd4)
destroy(this.cb_pj)
destroy(this.cb_folder)
destroy(this.cb_xls2)
end on

event wue_retrieve;call super::wue_retrieve;cb_xls.Enabled = TRUE
cb_pdf.Enabled = TRUE
is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_clear;call super::wue_clear;cb_xls.Enabled = FALSE
cb_pdf.Enabled = FALSE
end event

event open;icmdbutton = { cb_pj, cb_xls2 }
IF	gaa.corp_gr='2202' THEN cb_xls2.of_setvisible (false)
call super::open
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja010h
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja010h
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja010h
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja010h
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja010h
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja010h
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja010h
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja010h
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja010h
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja010h
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja010h
end type

type uo_navi from wt_vertole`uo_navi within w_ja010h
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja010h
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja010h
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja010h
end type

type p_close from wt_vertole`p_close within w_ja010h
end type

type p_excel from wt_vertole`p_excel within w_ja010h
end type

type p_print from wt_vertole`p_print within w_ja010h
end type

type p_delete from wt_vertole`p_delete within w_ja010h
end type

type p_update from wt_vertole`p_update within w_ja010h
end type

type p_input from wt_vertole`p_input within w_ja010h
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja010h
end type

type p_clear from wt_vertole`p_clear within w_ja010h
end type

type p_copy from wt_vertole`p_copy within w_ja010h
end type

type dw_c from wt_vertole`dw_c within w_ja010h
string title = "조회일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertole`btn_update within w_ja010h
end type

type st_count from wt_vertole`st_count within w_ja010h
end type

type dw_list from wt_vertole`dw_list within w_ja010h
boolean visible = true
string dataobject = "d_szm0ia"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sec_cd | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::doubleclicked;call super::doubleclicked;IF	dwo.name='work_gb'	Then
	gnv_rolemenu.of_setopensheet('00072')
//	CHOOSE CASE gaa.corp_gr
//		CASE '2201'
//			gnv_rolemenu.of_setopensheet('00118')
//		CASE '2202'
//			gnv_rolemenu.of_setopensheet('00072')
//		CASE ELSE
//			gnv_rolemenu.of_setopensheet('00236')
//	END CHOOSE
End IF
end event

type st_move from wt_vertole`st_move within w_ja010h
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja010h
boolean eb_onepage = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;DEC	ldc_coll

DATETIME	ldt_ymd

STRING	ls_fund_cd

ldt_ymd    = dw_list.object.ymd [row]
ls_fund_cd = dw_list.object.fund_cd [row]

SELECT NVL(SUM(1),0)
  INTO :ldc_coll
  FROM SJM0JM t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.ymd     = :ldt_ymd
   AND t1.fund_cd = :ls_fund_cd
   AND (coll_pass <> 0 OR coll_up <> 0 OR coll_dw <> 0) ;

ldc_coll = SQLCA.GETITEMNUMBER (1)

IF ldc_coll>0  Then
   UF_FILEOPEN ('rd_ja010h_coll.mrd', &
                'ymd[' + STRING(ldt_ymd, 'yyyy.mm.dd') + '] ' + &
                'bf_ymd[' + STRING(dw_list.object.bf_ymd [row], 'yyyy.mm.dd') + '] ' + &
                'fund_cd[' + ls_fund_cd + ']')
ELSE
   UF_FILEOPEN ('rd_ja010h.mrd', &
                'ymd[' + STRING(ldt_ymd, 'yyyy.mm.dd') + '] ' + &
                'bf_ymd[' + STRING(dw_list.object.bf_ymd [row], 'yyyy.mm.dd') + '] ' + &
                'fund_cd[' + ls_fund_cd + ']')
END IF
end event

type rb_onepage from wt_vertole`rb_onepage within w_ja010h
boolean enabled = false
boolean checked = true
end type

type cb_rd1 from pf_u_commandbutton within w_ja010h
integer x = 1102
integer y = 192
integer width = 457
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "합계현황생성"
end type

event clicked;DATETIME ldt

STRING   ls_s1, ls_s2, ls_s3, ls_sun_jasan, ls_file

F_LOADINGRETRIEVE (TRUE)

ldt = dw_c.object.ymd [1]

SELECT TO_CHAR (NVL(SUM(sun_jasan_siga_aek),0))
  INTO :ls_sun_jasan
  FROM UZM0UI t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.ymd     = :ldt
   AND t1.type_gb NOT IN ('5','6','X') ;

ls_sun_jasan = SQLCA.GETITEMSTRING (1)

ls_s1   = '종합.xls'
ls_file = gaa.xlsx + ls_s1
ole_rd.UF_FILEOPEN ('rd_ja010h_00.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + '] sun_jasan[' + ls_sun_jasan + ']')
sleep (1)
ole_rd.uf_xls (ls_file)

ls_s2   = '주식비중.xls'
ls_file = gaa.xlsx + ls_s2
ole_rd.UF_FILEOPEN ('rd_ja010h_jm.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
sleep (1)
ole_rd.uf_xls (ls_file)

ls_s3   = '예수금.xls'
ls_file = gaa.xlsx + ls_s3
ole_rd.UF_FILEOPEN ('rd_ja010h_01.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
sleep (1)
ole_rd.uf_xls (ls_file)

ls_file = gaa.xlsx + '고객계약금+월별평가금(' + string (ldt,'yyyymmdd') + ').xls'
ole_rd.UF_FILEOPEN ('rd_ja010h_deposit.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
sleep (1)
ole_rd.uf_xls (ls_file)

IF gfp.getprocesscount ('excel.exe')>0 Then
   MESSAGEBOX ('알림', '실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
   gfp.killprocess ('excel.exe')
END IF

OLEOBJECT   obj_1, lSheet

obj_1 = CREATE OLEOBJECT
IF obj_1.ConnectToNewObject ('excel.application')<>0  Then // 엑셀실행
   F_MESSAGEBOX ('XLS1', '')
   RETURN
END IF
obj_1.Application.displayalerts = FALSE
obj_1.Application.VISIBLE       = FALSE
obj_1.windowstate               = 2
obj_1.WorkBooks.OPEN (gaa.pbr + 'kernel\통합 문서1.xlsm', 0, TRUE)
obj_1.WorkBooks.OPEN (gaa.xlsx + ls_s1                  , 0, TRUE)
obj_1.WorkBooks.OPEN (gaa.xlsx + ls_s2                  , 0, TRUE)
lSheet = obj_1.Application.ActiveSheet
lSheet.SELECT
lSheet.Columns.AutoFit
lSheet.Rows.AutoFit
obj_1.WorkBooks.OPEN (gaa.xlsx + ls_s3, 0, TRUE)

obj_1.Application.RUN ("'통합 문서1.xlsm'!LineColor")

F_LOADINGRETRIEVE (false)

ls_file = F_REPLACE (gaa.corp_nm,'투자자문','') + ' 합계현황(' + string (ldt,'yyyymmdd') + ').xls'

F_MESSAGEBOX ('P000', '일 생성자료 종합, 주식비중, 예수금, 고객계약금+월별평가금 생성을 완료했습니다.~r~n저장폴더버튼을 클릭하여 ' + ls_file + ' 파일을 확인 하십시오.')

obj_1.windowstate         = 3
obj_1.Application.VISIBLE = true
obj_1.Application.ActiveWorkbook.SaveAs (gaa.xlsx + ls_file)
obj_1.Application.ActiveWorkbook.Saved = TRUE

DESTROY obj_1
end event

type cb_xls from commandbutton within w_ja010h
integer x = 3314
integer y = 192
integer width = 393
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
boolean enabled = false
string text = "엑셀저장"
end type

event clicked;long   ll, lOld

STRING	ls_savename

ll = dw_list.GetSelectedRow (0)
dw_list.uf_setrange (true)

DO WHILE TRUE
   ls_savename = gaa.xlsx + string(dw_c.object.ymd [1],'yyyymmdd') + '_' + dw_list.object.fund_nm [ll] + '(' + dw_list.object.fund_cd [ll] + ').xls'
   ole_rd.EVENT ue_retrieve (ll)
   ole_rd.uf_xls (ls_savename)

   dw_list.selectrow (ll, FALSE) ; lOld = ll
   ll = dw_list.GetSelectedRow (ll)
	IF ll=0 THEN EXIT
	dw_list.scrolltorow (ll)
	IF	ll=truncate (ll/10,0)*10 THEN sleep (3)
LOOP
dw_list.uf_setrow (lOld, TRUE)

f_messageBox ('INFO', '자료생성을 완료했습니다.~r~n~r~n' + gaa.xlsx + '~r~nDirectory에서 자료를 확인하십시오.')
end event

type cb_pdf from pf_u_commandbutton within w_ja010h
integer x = 3726
integer y = 192
integer width = 393
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "PDF저장"
end type

event clicked;LONG	ll, lOld

ll = dw_list.GetSelectedRow (0)
dw_list.uf_setrange (true)
DO WHILE TRUE
   ole_rd.EVENT ue_retrieve (ll)
	ole_rd.uf_pdf (gaa.xlsx + string(dw_c.object.ymd [1],'yyyymmdd') + '_' + dw_list.object.fund_nm [ll] + '(' + dw_list.object.fund_cd [ll] + ').pdf')

   dw_list.SelectRow (ll, FALSE) ; lOld = ll
   ll = dw_list.GetSelectedRow (ll)
	IF ll=0 THEN EXIT
	dw_list.scrolltorow (ll)
	IF	ll=truncate (ll/10,0)*10 THEN sleep (3)
LOOP
dw_list.uf_setrow (lOld, TRUE)

f_messageBox ('INFO', '자료생성을 완료했습니다.~r~n~r~n' + gaa.xlsx + '~r~nDirectory에서 자료를 확인하십시오.')
end event

type cb_rd3 from commandbutton within w_ja010h
integer x = 1568
integer y = 192
integer width = 544
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "년간수수료집계표"
end type

event clicked;ole_rd.UF_FILEOPEN ('rd_ja010h_year.mrd', 'title[' + string(dw_c.object.ymd [1],'yyyy년 매매수수료 집계표') + '] ' + &
                    'yyyy[' + string(dw_c.object.ymd [1],'yyyy') + ']'                                                                  )
ole_rd.uf_xlsx (gaa.xlsx + string (dw_c.object.ymd [1],'yyyy') + '년 매매수수료 집계표.xlsx')

F_MESSAGEBOX ('P000', string (dw_c.object.ymd [1],'yyyy') + '년 매매수수료 집계표 생성작업이 완료 되었습니다.~r~n~r~n장소확인 : ' + gaa.xlsx)
end event

type cb_rd4 from pf_u_commandbutton within w_ja010h
integer x = 2121
integer y = 192
integer width = 457
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "월간보수현황"
end type

event clicked;F_MESSAGEBOX ('INFO', '말일기준으로 자료를 출력합니다.')

ole_rd.UF_FILEOPEN ('rd_ja010h_bosu.mrd', 'title[' + string(dw_c.object.ymd [1],'yyyy"년 " mm') + '월 보수현황] ' + &
                    'ymd[' + string(dw_c.object.ymd [1],'yyyy.mm.dd') + ']')
ole_rd.uf_xlsx (gaa.xlsx + '월간 보수현황(' + string (dw_c.object.ymd [1],'yyyymm') + ').xlsx')

F_MESSAGEBOX ('P000', '고객별 월간 보수현황 생성작업이 완료 되었습니다.~r~n~r~n저장 위치확인 : ' + gaa.xlsx)
end event

type cb_pj from pf_u_commandbutton within w_ja010h
integer x = 2245
integer y = 16
integer width = 457
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "평잔재계산"
end type

event clicked;STRING	sMsg, la_args[]

IF	f_messagebox ('INFO2', dw_list.object.fund_nm [iRow] + '계좌 평잔 재계산 작업을 하시겠습니까?')=2 THEN RETURN

sMsg = space (200)
la_args [1] = gaa.corp_gr
la_args [2] = dw_list.object.fund_cd [iRow]
la_args [3] = string(dw_c.object.ymd[1],'yyyy.mm.dd')
SQLCA.singleconnection ()
SQLCA.SP_CALL (parent, 'SR_PYUNGJAN ( ?, ?, ? )', la_args[], sMsg)

f_messagebox ('INFO', '평잔 재계산 작업을 완료 했습니다.')

end event

type cb_folder from pf_u_commandbutton within w_ja010h
integer x = 4672
integer y = 192
integer width = 457
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute (gaa.xlsx)
end event

type cb_xls2 from pf_u_commandbutton within w_ja010h
integer x = 2729
integer y = 16
integer width = 457
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "COMPLIANCE"
end type

event clicked;CHOOSE CASE gaa.corp_gr
	CASE '2201'
		wf_xls2_2201 ()
	CASE '2202'
		wf_xls2_2202 ()
END CHOOSE
end event

