forward
global type w_dynamiccodesearch from w_response1st
end type
type cb_1 from pf_u_commandbutton within w_dynamiccodesearch
end type
type sle_1 from pf_u_singlelineedit within w_dynamiccodesearch
end type
type dw_codelist from fw_u_dwo within w_dynamiccodesearch
end type
type p_close from pf_u_imagebutton within w_dynamiccodesearch
end type
end forward

global type w_dynamiccodesearch from w_response1st
integer x = 837
integer y = 852
integer width = 1170
integer height = 2300
string title = "코드선택"
long backcolor = 16777215
boolean center = true
cb_1 cb_1
sle_1 sle_1
dw_codelist dw_codelist
p_close p_close
end type
global w_dynamiccodesearch w_dynamiccodesearch

type variables
u_DynamicCodeSearch iu_getCode

STRING   is_Filter = '', is_key = ''

INT   iRow = 0, icolcount
end variables

forward prototypes
public subroutine wf_setrow (fw_u_dwo dw, integer row)
public subroutine wf_setenabled ()
end prototypes

public subroutine wf_setrow (fw_u_dwo dw, integer row);IF row=0 Then
   iRow = 0
   dw.SelectRow (0, FALSE)
Else
   IF dw.GetRow ()=row  Then  // rowfocuschanged가 일어나지 않으므로
      dw.EVENT rowfocuschanged (row)
   Else
      dw.SetRow (row)
      dw.ScrollToRow (row)
   End IF
End IF
end subroutine

public subroutine wf_setenabled ();dw_codelist.of_dw2subbtn ({'p_excel'}, true)
end subroutine

on w_dynamiccodesearch.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_1=create sle_1
this.dw_codelist=create dw_codelist
this.p_close=create p_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.dw_codelist
this.Control[iCurrent+4]=this.p_close
end on

on w_dynamiccodesearch.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.dw_codelist)
destroy(this.p_close)
end on

event open;call super::open;str_dw_base	ldw

iu_getCode = Message.PowerObjectParm
iu_getCode.is_returnvalue = null_s

CHOOSE CASE iu_getCode.is_EditCase
	CASE 'upper'
		sle_1.TextCase = upper!
	CASE 'lower'
		sle_1.TextCase = lower!
	CASE ELSE
		sle_1.TextCase = anycase!
END CHOOSE

IF	POS (iu_getCode.is_title,'(조회전용)')>0	Then
	TITLE = f_replace (iu_getCode.is_title,'(조회전용)','')
	dw_codelist.ibsetlist4subbtn = true
	p_close.visible = true
	sle_1.visible = false
	cb_1.visible = false
ElseIF POS (iu_getCode.is_title,'명')>0	Then
	TITLE = f_replace (iu_getCode.is_title,'명','') + ' 코드 (더블클릭)선택'
ElseIF POS (iu_getCode.is_title,'코드')>0	Then
	TITLE = f_replace (iu_getCode.is_title,'코드','') + ' 코드 (더블클릭)선택'
Else
	TITLE = iu_getCode.is_title + '(더블클릭) 선택'
End IF

f_get_array (iu_getCode.is_HeaderName, '@', ldw.header_text)

ldw.resize = true
ldw.fseq = true
ldw.code_search = true	//code_search인 경우 column_width 지정없이 불필요한 컬럼 삭제

SQLCA.sql2dw (iu_getCode.is_sql, dw_codelist, ldw)

LONG	ll, lRow, lAdd, lc = 0, ll_rowcount, li_col, li_width, li_size = 0, li_col_width

STRING   la_data [], la_size []

f_get_array (iu_getCode.is_column_size, ':', la_size)

icolcount = integer (dw_codelist.object.DataWindow.Column.Count)
IF f_notnull (iu_getCode.is_addrow)	Then
   lAdd = f_get_array (iu_getCode.is_Addrow, ',', la_data)
   FOR  ll = 1  TO  lAdd
      lc ++
      IF lc=1 THEN lRow = dw_codelist.insertrow (1)
      dw_codelist.object.data [lRow, lc] = la_data [ll]
      IF lc=iColCount THEN lc = 0
   NEXT
   dw_codelist.SelectRow (0, FALSE)
   dw_codelist.SelectRow (1, TRUE)
End IF

STRING	ls_modify = '', ls_col

ll_rowcount = dw_codelist.rowcount ()
FOR  li_col = 1  TO  icolcount
   ls_col = dw_codelist.describe ('#' + string (li_col) + '.name')
//	IF dw_codelist.describe (ls_col + '.visible')='1'	Then
//		li_width = long (dw_codelist.describe (ls_col + '.width'))
//		IF	li_width>0	Then
//			li_width = dec (la_size [li_col]) * PixelsToUnits(7, XPixelsToUnits!)
//			ls_modify += ls_col + ".width='" + string (li_width) + "' "
//			li_size += li_width + PixelsToUnits(5, XPixelsToUnits!)
//		End IF
//	End IF
	IF dw_codelist.describe (ls_col + '.visible')='1'	Then
		li_col_width = long (dw_codelist.describe (ls_col + '.width'))
		li_width = li_col_width
		IF	li_col_width>0	Then
			FOR  ll = MIN (ll_rowcount,500)  TO  1  STEP -1
				IF f_notnull (dw_codelist.object.Data [ll, li_col])  Then
					li_width = MAX (li_width, LenA (string (dw_codelist.object.data [ll, li_col])) * PixelsToUnits(7, XPixelsToUnits!) + IIF (li_col=1,PixelsToUnits(14, XPixelsToUnits!),PixelsToUnits(7, XPixelsToUnits!)))
				End IF
			NEXT
			IF	li_width<>li_col_width THEN ls_modify += ls_col + ".width='" + string (li_width) + "' "
			li_size += li_width + PixelsToUnits(5, XPixelsToUnits!)
		End IF
	End IF
NEXT
li_size = li_size + 169 +  PixelsToUnits(2, XPixelsToUnits!)
CHOOSE CASE icolcount
	CASE 2
		li_size += PixelsToUnits(6, XPixelsToUnits!)
	CASE 3
		li_size += PixelsToUnits(4, XPixelsToUnits!)
	CASE 4
		li_size += PixelsToUnits(2, XPixelsToUnits!)
END CHOOSE
dw_codelist.width = li_size
IF	f_notnull (ls_modify) THEN dw_codelist.modify (ls_modify)

Width = dw_codelist.width + 146

IF	sle_1.visible	Then
	IF POS(lower(iu_getCode.is_sql), 'order by') = 0 Then
		STRING	ls_col_name
		ls_col_name = Upper(dw_codelist.Describe ( "#1.Name" ))
		dw_codelist.SetSort(ls_col_name + ' AS')
		dw_codelist.Sort()
		dw_codelist.uf_setrow(1, FALSE)
	End IF
	sle_1.Width = Width - cb_1.Width - 300
	cb_1.X = sle_1.X + sle_1.Width + 78

	pf_f_togglekoreng ('k')

	sle_1.POST SetFocus ()
	sle_1.text = iu_getCode.is_SearchDefault
End IF
end event

event key;CHOOSE CASE key
   CASE KeyEscape!
      CLOSE (THIS)
   CASE KeyEnter!
      IF NOT cb_1.Default And iRow>0   Then
         iu_getCode.codesearch_select_data = dw_codeList.object.data [iRow]
         iu_getCode.is_returnvalue = iu_getCode.codesearch_select_data [1]
         ::clipboard ('')
         CLOSE (THIS)
      End IF
END CHOOSE
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_dynamiccodesearch
end type

type ln_tempstart from w_response1st`ln_tempstart within w_dynamiccodesearch
end type

type ln_templeft from w_response1st`ln_templeft within w_dynamiccodesearch
end type

type ln_cond_start from w_response1st`ln_cond_start within w_dynamiccodesearch
end type

type ln_tempright from w_response1st`ln_tempright within w_dynamiccodesearch
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_dynamiccodesearch
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_dynamiccodesearch
end type

type cb_1 from pf_u_commandbutton within w_dynamiccodesearch
integer x = 722
integer y = 24
integer width = 334
integer height = 100
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "필터조회"
end type

event clicked;call super::clicked;STRING	ls_text

IF f_null (sle_1.TEXT)  Then
   dw_codeList.SetFilter ('')
Else
	ls_text = UPPER (sle_1.TEXT)
	
	//<임시> 한채투 노승갑대리 요청 2022.01.14 최태용
	IF dec (dw_codeList.object.DataWindow.Column.Count)>2 Then
	   dw_codeList.SetFilter ("Match(UPPER(#1), '" + ls_text + "') or Match(UPPER(#2), '" + ls_text + "') or Match(UPPER(#3), '" + ls_text + "')")
	Else
	   dw_codeList.SetFilter ("Match(UPPER(#1), '" + ls_text + "') or Match(UPPER(#2), '" + ls_text + "')")
	End IF
End IF
dw_codeList.Filter ()
dw_codeList.SetFocus ()

Default = FALSE
end event

type sle_1 from pf_u_singlelineedit within w_dynamiccodesearch
event ue_key pbm_keyup
integer x = 73
integer y = 32
integer width = 603
integer height = 92
integer taborder = 10
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
boolean autohscroll = false
boolean hideselection = false
end type

event ue_key;STRING  ls

LONG  lRowCount, lSelect

lRowCount = dw_codeList.rowcount ()

IF key=KeyDownArrow! Then
   lSelect = dw_codeList.GetSelectedRow (0) + 1
   IF lRowCount>0 THEN cb_1.Default = FALSE
Else
   IF TEXT=is_Filter THEN RETURN
   IF TEXT=''  Then
      is_Filter = ''
      dw_codeList.SetFilter ('')
      dw_codeList.Filter ()
      lRowCount = dw_codeList.rowcount ()
      IF is_key='' THEN iRow = 1 &
      Else              iRow = dw_codeList.Find ("#1='" + is_key + "'", 1, lRowCount)
      wf_setrow (dw_codeList, iRow)
      RETURN
   End IF
   is_Filter = TEXT ; lSelect = 1
   cb_1.Default = TRUE
End IF

IF dec (dw_codeList.object.DataWindow.Column.Count)>2 Then
   iRow = dw_codeList.Find ("Match(#1, '" + TEXT + "') or Match(#2, '" + TEXT + "') or Match(#3, '" + TEXT + "')", iif (lSelect>lRowCount,1,lSelect), lRowCount)
Else
   iRow = dw_codeList.Find ("Match(#1, '" + TEXT + "') or Match(#2, '" + TEXT + "')", iif (lSelect>lRowCount,1,lSelect), lRowCount)
End IF
wf_setrow (dw_codeList, iRow)
end event

type dw_codelist from fw_u_dwo within w_dynamiccodesearch
integer x = 50
integer y = 156
integer width = 1065
integer height = 2028
integer taborder = 30
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
string islist4subbtnauth = "0010000000"
end type

event doubleclicked;STRING ls = '', ls_col, ls_modify = ''

LONG  ll_rcount, li

CHOOSE CASE dwo.TYPE
   CASE 'column'
      iu_getCode.codesearch_select_data = Object.data [row]
      iu_getCode.is_returnvalue = iu_getCode.codesearch_select_data [1]
      ::clipboard ('')
      CLOSE (Parent)
END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;SelectRow (0, FALSE)
SelectRow (currentrow, TRUE)
IF currentrow=0 THEN RETURN
iRow = currentrow
is_key = dw_codeList.object.data [iRow, 1]
end event

event oue_keydown;IF key=KeyEnter! And iRow>0  Then
   iu_getCode.codesearch_select_data = Object.data [iRow]
   iu_getCode.is_ReturnValue = iu_getCode.codesearch_select_data [1]
   CLOSE (Parent)
End IF
end event

event oue_subbtn_excel;call super::oue_subbtn_excel;f_xlsx (THIS, '__' + iu_getCode.is_SearchColumn, f_nvl (iu_getCode.is_SearchColumn,'코드찾기'), '', '', '', '')

end event

type p_close from pf_u_imagebutton within w_dynamiccodesearch
boolean visible = false
integer x = 73
integer y = 24
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
boolean setbringtotop = true
end type

event clicked;call super::clicked;Close(Parent)
end event

