forward
global type w_ja010h1 from wt_vertole
end type
type cb_pj from pf_u_commandbutton within w_ja010h1
end type
type cb_1 from pf_u_commandbutton within w_ja010h1
end type
end forward

global type w_ja010h1 from wt_vertole
boolean eb_rowchangewait = true
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
cb_pj cb_pj
cb_1 cb_1
end type
global w_ja010h1 w_ja010h1

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

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

IF	gaa.corp_gr='2402'	Then
	SELECT JUNYONG_YMD
	  INTO :ldt
	  FROM SZX0AA aa
	 WHERE aa.corp_gr = :gaa.corp_gr;

	dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)
Else
	dw_c.object.ymd [1] = idt_workdate
End IF
end event

on w_ja010h1.create
int iCurrent
call super::create
this.cb_pj=create cb_pj
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_pj
this.Control[iCurrent+2]=this.cb_1
end on

on w_ja010h1.destroy
call super::destroy
destroy(this.cb_pj)
destroy(this.cb_1)
end on

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event open;icmdbutton = { cb_pj }
call super::open
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja010h1
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja010h1
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja010h1
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja010h1
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja010h1
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja010h1
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja010h1
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja010h1
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja010h1
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja010h1
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja010h1
end type

type uo_navi from wt_vertole`uo_navi within w_ja010h1
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja010h1
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja010h1
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja010h1
end type

type p_close from wt_vertole`p_close within w_ja010h1
end type

type p_excel from wt_vertole`p_excel within w_ja010h1
end type

type p_print from wt_vertole`p_print within w_ja010h1
end type

type p_delete from wt_vertole`p_delete within w_ja010h1
end type

type p_update from wt_vertole`p_update within w_ja010h1
end type

type p_input from wt_vertole`p_input within w_ja010h1
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja010h1
end type

type p_clear from wt_vertole`p_clear within w_ja010h1
end type

type p_copy from wt_vertole`p_copy within w_ja010h1
end type

type dw_c from wt_vertole`dw_c within w_ja010h1
string title = "조회일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertole`btn_update within w_ja010h1
end type

type st_count from wt_vertole`st_count within w_ja010h1
end type

type dw_list from wt_vertole`dw_list within w_ja010h1
boolean visible = true
string dataobject = "d_szm0ia"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sec_cd | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::doubleclicked;call super::doubleclicked;IF	dwo.name='work_gb'	Then
	CHOOSE CASE gaa.corp_gr
		CASE '2201'
			gnv_rolemenu.of_setopensheet('00118')
		CASE '2202'
			gnv_rolemenu.of_setopensheet('00236')
		CASE ELSE
			gnv_rolemenu.of_setopensheet('00236')
	END CHOOSE
End IF
end event

type st_move from wt_vertole`st_move within w_ja010h1
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja010h1
boolean eb_onepage = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;DATETIME	ldt_job_dt, ldt_run_dt
STRING	ls_user_nm

DEC	ldc_err

ldt_job_dt = dw_c.object.ymd [1]

IF gaa.CORP_GR='2402' AND STRING (ldt_job_dt,'yyyymmdd')>'20241230'  Then
   SELECT NVL(COUNT(*),0)
     INTO :ldc_err
     FROM (SELECT t1.FUND_CD
                , SUM(t1.SIGA_AEK)  AS NAV
                , 0                 AS SUN_JASAN_AEK
             FROM UZM0UI t1
                , SZM0IA ia
            WHERE t1.CORP_GR       = :gaa.CORP_GR
              AND t1.ymd           = :ldt_job_dt
              AND ia.CORP_GR       = t1.CORP_GR
              AND ia.fund_cd       = t1.fund_cd
              AND ia.fst_seolj_ymd <= :ldt_job_dt
              AND NVL(ia.haeji_ymd, :ldt_job_dt + 1)  > :ldt_job_dt
            GROUP BY t1.fund_cd
           UNION ALL
           SELECT t1.fund_cd
                , 0
                , t1.sun_jasan_aek
             FROM SKT0GI t1
                , SZM0IA ia
            WHERE t1.CORP_GR       = :gaa.CORP_GR
              AND t1.ymd           = :ldt_job_dt
              AND t1.work_gb       = 'A'
              AND ia.CORP_GR       = t1.CORP_GR
              AND ia.fund_cd       = t1.fund_cd
              AND ia.fst_seolj_ymd <= :ldt_job_dt
              AND NVL(ia.haeji_ymd, :ldt_job_dt + 1)  > :ldt_job_dt) tt 
    GROUP BY tt.fund_cd
    HAVING NVL(SUM(TT.NAV),0) <> NVL(SUM(TT.SUN_JASAN_AEK),0) ;

   ldc_err = SQLCA.GETITEMDECIMAL (1)

   IF ldc_err>0   Then
      SELECT MAX(dt)
        INTO :ldt_run_dt
        FROM GIJUN_GA_COM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.ymd     = :ldt_job_dt ;

      ldt_run_dt = SQLCA.GETITEMDATETIME (1)

      SELECT MAX(u1.USER_NM)
        INTO :ls_user_nm
        FROM GIJUN_GA_COM t1
           , FW_USER_MST  u1
       WHERE t1.CORP_GR    = :gaa.CORP_GR
         AND t1.ymd        = :ldt_job_dt
         AND t1.dt         = :ldt_run_dt
         AND u1.CORP_GR    IN ('2200', t1.CORP_GR)
         AND u1.enc_e_mail = TO_ENCRYPTS(t1.userid) ;

      ls_user_nm = SQLCA.GETITEMSTRING (1)

      MESSAGEBOX ('원장생성', '최종작업자 ' + ls_user_nm + '(이)가 원장생성을 ' + STRING (ldt_run_dt, 'HH:mm:ss') &
                  + '에 작업했습니다.~r~n~r~n최종 LOAD자료 반영을 위해 원장생성 작업을 다시 하십시오.')
   END IF
END IF

UF_FILEOPEN ('rd_ja010h1.mrd', &
             'ymd[' + STRING(dw_c.object.ymd [1], 'yyyy.mm.dd') + '] ' + &
             'fund_cd[' + dw_list.object.fund_cd [row] + ']')
end event

type rb_onepage from wt_vertole`rb_onepage within w_ja010h1
boolean enabled = false
boolean checked = true
end type

type cb_pj from pf_u_commandbutton within w_ja010h1
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

type cb_1 from pf_u_commandbutton within w_ja010h1
integer x = 1125
integer y = 188
integer width = 686
integer height = 100
integer taborder = 110
boolean bringtotop = true
string text = "보유자산종합엑셀생성"
end type

event clicked;call super::clicked;DATETIME ldt

STRING   ls_s1, ls_s2, ls_s3, ls_sun_jasan, ls_file

F_LOADINGRETRIEVE (TRUE)

ldt = dw_c.object.ymd [1]

//RICO에는 TYPE_GB가 6인 계좌도 출력 요청.
//SELECT TO_CHAR (NVL(SUM(sun_jasan_siga_aek),0))
//  INTO :ls_sun_jasan
//  FROM UZM0UI t1
// WHERE t1.CORP_GR = :gaa.CORP_GR
//   AND t1.ymd     = :ldt
//   AND t1.type_gb NOT IN ('5','6','X') ;
//
//ls_sun_jasan = SQLCA.GETITEMSTRING (1)

ls_s1   = '종합.xls'
ls_file = gaa.xlsx + ls_s1
IF gaa.CORP_GR='2402' Then
	
	SELECT TO_CHAR (NVL(SUM(sun_jasan_siga_aek),0))
	  INTO :ls_sun_jasan
	  FROM UZM0UI t1
	 WHERE t1.CORP_GR = :gaa.CORP_GR
		AND t1.ymd     = :ldt
		AND t1.type_gb NOT IN ('5','X') ;

	ls_sun_jasan = SQLCA.GETITEMSTRING (1)


   ole_rd.UF_FILEOPEN ('rd_ja010h_00_2402.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + '] sun_jasan[' + ls_sun_jasan + ']')
ELSE

	SELECT TO_CHAR (NVL(SUM(sun_jasan_siga_aek),0))
	  INTO :ls_sun_jasan
	  FROM UZM0UI t1
	 WHERE t1.CORP_GR = :gaa.CORP_GR
		AND t1.ymd     = :ldt
		AND t1.type_gb NOT IN ('5','6','X') ;

	ls_sun_jasan = SQLCA.GETITEMSTRING (1)
	
   ole_rd.UF_FILEOPEN ('rd_ja010h_00.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + '] sun_jasan[' + ls_sun_jasan + ']')
END IF;
sleep (1)
ole_rd.uf_xls (ls_file)

ls_s2   = '주식비중.xls'
ls_file = gaa.xlsx + ls_s2
IF gaa.CORP_GR='2402' Then
	ole_rd.UF_FILEOPEN ('rd_ja010h_jm_2402.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
ELSE
	ole_rd.UF_FILEOPEN ('rd_ja010h_jm.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
END IF;
sleep (1)
ole_rd.uf_xls (ls_file)

ls_s3   = '예수금.xls'
ls_file = gaa.xlsx + ls_s3

IF GAA.CORP_GR = '2402' THEN
	ole_rd.UF_FILEOPEN ('rd_ja010h_01_2402.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
ELSE
	ole_rd.UF_FILEOPEN ('rd_ja010h_01.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
END IF;
sleep (1)
ole_rd.uf_xls (ls_file)

ls_file = gaa.xlsx + '고객계약금+월별평가금(' + string (ldt,'yyyymmdd') + ').xls'
IF GAA.CORP_GR = '2402' THEN
	ole_rd.UF_FILEOPEN ('rd_ja010h_deposit_2402.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
ELSE
	ole_rd.UF_FILEOPEN ('rd_ja010h_deposit.mrd', 'ymd[' + string (ldt,'yyyy.mm.dd') + ']')
END IF;
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

