forward
global type w_calendar4day1_us from window
end type
type dw_cal from fw_u_dwo within w_calendar4day1_us
end type
end forward

global type w_calendar4day1_us from window
integer width = 955
integer height = 776
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
event pfe_postopen ( )
dw_cal dw_cal
end type
global w_calendar4day1_us w_calendar4day1_us

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
s_calendar	istr_calendar

window	iw_parent
fw_u_dwo	iwo_parent

String	is_getfocused = '', is_org4syntax

boolean	ib_org4syntax = false, ib_getdate = false, ib_doubleclicked=false

Long	il_prevcolor = 0, il_selectcolor = RGB(0,0,0)

Date	id_dateselected
end variables

forward prototypes
public function string of_getload4style (fw_u_dwo ldw_target)
public function integer of_drawmonth (integer ai_year, integer ai_month)
public function integer of_getdaysinmonth (integer ai_year, integer ai_month)
public function integer of_setparentdate (string as_dateselected)
public function integer of_selectdate (integer ai_day)
public function integer of_selectdate (string as_cell)
end prototypes

public function string of_getload4style (fw_u_dwo ldw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

string ls_processing, ls_style

ls_processing = ldw_target.describe("datawindow.processing")
choose case long(ls_processing)
	case 0
		//freeform인 경우 : detail band height가 dw control의 height의 2.5배 미만(만약 Header가 있는경우를 대비)
		long ll_detailheight, ll_dwcontrolheight, ll_headerheight
		
		ll_headerheight = long(ldw_target.describe("Datawindow.Header.Height"))
		ll_detailheight = long(ldw_target.describe("Datawindow.Detail.Height"))
		ll_dwcontrolheight = ldw_target.Height
		
		if ll_headerheight > pixelstounits(10, ypixelstounits!) then
			ls_style = "tabular"
		elseif ll_detailheight * 2.2 < ll_dwcontrolheight then
			ls_style = "tabular"
		else
			ls_style = "freeform"
		end if
	case 1
		ls_style = 'grid'
	case 2
		ls_style = 'label'
	case 3
		ls_style = 'graph'
	case 4
		ls_style = 'crosstab'
	case 5
		ls_style = 'composite'
	case 6
		ls_style = 'ole'
	case 7
		ls_style = 'richText'
	case 8
		ls_style = 'treevew'
	case 9
		ls_style = 'treeviewwithgrid'
	Case Else
		ls_style = 'etc'
end choose

return ls_style
end function

public function integer of_drawmonth (integer ai_year, integer ai_month);ads_jTier	lds_hol

String	ls_syntax = '', ls_error, ls_sqlsyntax
integer	li_daysinmonth, li_empty, li_lastdaynum, i, lR, li_hol
date		ld_firstday, ld_today, ld_calday

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = gnv_vari.is_sys_id
gnv_extfunc.biznode11te(114, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

If ib_org4syntax	Then
	dw_cal.create(is_org4syntax, ls_error)
	If len(ls_error) > 0 then
		messagebox('of_drawmonth() org create error', ls_error)
		Return -1
	End If
End If

lds_hol = CREATE ads_jTier

ls_sqlsyntax = " SELECT t1.YMD " + &
               "      , t1.YMD_SEQ " + &
               "   FROM FW_CALENDAR t1 " + &
               "      , SZX0HL      hl " + &
               "  WHERE t1.YMD       LIKE '" + string (ai_year) + TRIM (string (ai_month,'00')) + "%' " + &
               "    AND t1.SYS_ID    = 'SY' " + &
               "    AND hl.NATION_CD = 'US' " + &
               "    AND hl.HOLI_YMD  = TO_DATE(t1.YMD,'yyyymmdd') "

lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_hol, 'sqlm')

li_daysinmonth	= of_getdaysinmonth(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)

li_empty = daynumber(ld_firstday)
IF	li_empty=1 THEN li_empty += 7

// save current year & month
dw_cal.reset()
dw_cal.insertrow(0)
dw_cal.setitem(1, 'year', ai_year)
dw_cal.setitem(1, gnv_extfunc.istr_node4value.cstr09, ai_month)
dw_cal.setitem(1, gnv_extfunc.istr_node4value.cstr15, li_empty)

// setitem cell1 ~ cell42 
For i = 1 to li_daysinmonth
	dw_cal.setitem(1, 'cell' + string(i + li_empty - 1), string(i))
	ld_calday = date(ai_year, ai_month, i)
	ls_syntax += 'cell' + string(i + li_empty - 1) + '.tag="' + string(ld_calday, 'yyyy-mm-dd') + '"~r~n'

	IF ib_getdate  Then
		IF iwo_parent.dynamic EVENT ue_getdate (string (ld_calday,'yyyy.mm.dd'))=1  Then
			ls_syntax += 'cell' + string(i + li_empty - 1) + '.color=56320~r~n'
			CONTINUE
		End IF
	End IF

	IF	NOT (daynumber(ld_calday)=1 OR daynumber(ld_calday)=7)	Then
		li_hol = lds_hol.FIND ("#1='" + string (ld_calday,'yyyymmdd') + "'", 1, lR)
		IF	li_hol=0	Then
			ls_syntax += 'cell' + string(i + li_empty - 1) + '.Color="' + string(rgb(15,15,15)) + '"~r~n'
		Else
			CHOOSE CASE lds_hol.getitemstring (li_hol, 2)
				CASE '7'
					ls_syntax += 'cell' + string(i + li_empty - 1) + '.Color="' + string(rgb(35,120,195)) + '"~r~n'
				CASE ELSE
					ls_syntax += 'cell' + string(i + li_empty - 1) + '.Color="' + string(rgb(255,0,0)) + '"~r~n'
			END CHOOSE
		End IF
	End IF
Next

date	ld_prev_fr, ld_prev_to
Long	ll_prev_month, ll_gapnum, ll_fr_num

If li_empty > 1 Then
	ll_gapnum  = li_empty - 1
	ld_prev_fr = relativedate (ld_firstday, -ll_gapnum)
	ld_prev_to = relativedate (ld_firstday, -1)
	ll_fr_num  = day (ld_prev_fr) - 1
	ll_prev_month	= month (ld_prev_fr)
	for i = 1 to ll_gapnum
		dw_cal.setitem(1, 'cell' + string(i), string(ll_fr_num + i))
		ld_today	= RelativeDate(date(ai_year, ai_month, 15), -30)
		ld_today = date(long(string(ld_today, 'yyyy')), long(string(ld_today, 'mm')),  (ll_fr_num + i))
		ls_syntax += 'cell' + string(i) + '.tag="' + string(ld_today, 'yyyy-mm-dd') + '"~r~n'
		ls_syntax += 'cell' + string(i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next
End If

ll_gapnum = 42 - li_daysinmonth - fw_f_nvll(ll_gapnum, 0)
If ll_gapnum > 0 Then
	li_lastdaynum = 42 - ll_gapnum
	for i = 1 to ll_gapnum
		dw_cal.setitem(1, 'cell' + string(li_lastdaynum + i), string(i))
		ld_today	= RelativeDate(date(ai_year, ai_month, 15), 30)
		ld_today = date(long(string(ld_today, 'yyyy')), long(string(ld_today, 'mm')), i)
		ls_syntax += 'cell' + string(li_lastdaynum + i) + '.tag="' + string(ld_today, 'yyyy-mm-dd') + '"~r~n'
		ls_syntax += 'cell' + string(li_lastdaynum + i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next	
End If
ls_error = dw_cal.Modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_drawmonth() error1', ls_error)
	Return -1
End If

ib_org4syntax = true

return 0
end function

public function integer of_getdaysinmonth (integer ai_year, integer ai_month);if isnull(ai_year)  then return -1
if isnull(ai_month) then return -1

integer li_days[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
integer li_daysinmonth

li_daysinmonth = li_days[ai_month]
if ai_month = 2 then
	if (mod(ai_year, 4) = 0 and mod(ai_year, 100) <> 0) or mod(ai_year,400) = 0 then
		li_daysinmonth = 29
	end if
end if

return li_daysinmonth
end function

public function integer of_setparentdate (string as_dateselected);IF NOT IsValid(iwo_parent)            THEN RETURN -1
IF Len(TRIM(istr_calendar.as_col1))=0 THEN RETURN -1

STRING   ls_text_date

ls_text_date = string (as_dateselected, '@@@@-@@-@@')

iwo_parent.SETROW (istr_calendar.al_row)
iwo_parent.SetColumn (istr_calendar.as_col1)

iwo_parent.SetText (ls_text_date)
IF iwo_parent.ACCEPTTEXT( )=-1 THEN RETURN -1

RETURN 1
end function

public function integer of_selectdate (integer ai_day);integer	li_firstdaynum

li_firstdaynum = dw_cal.getitemnumber(1, 'firstdaynum')

// deselect
If is_getfocused<>'' Then	
	dw_cal.modify(is_getfocused + ".border=0")
	dw_cal.modify(is_getfocused + ".Font.height='-9'")
	dw_cal.modify(is_getfocused + ".Font.Weight='400'")
	dw_cal.modify(is_getfocused + ".Color='" + string (il_prevcolor) + "'")
End If

is_getfocused = 'cell' + string(li_firstdaynum + ai_day - 1)
il_prevcolor = Long(dw_cal.Describe(is_getfocused + ".Color"))
dw_cal.modify(is_getfocused + ".border=4")
dw_cal.modify(is_getfocused + ".Font.height='-11'")
dw_cal.modify(is_getfocused + ".Font.Weight='700'")
dw_cal.modify(is_getfocused + ".Color='" + string (il_selectcolor) + "'")

Return 0
end function

public function integer of_selectdate (string as_cell);integer	li_firstdaynum

li_firstdaynum = dw_cal.getitemnumber(1, 'firstdaynum')

// deselect
If is_getfocused <> '' Then	
	dw_cal.modify(is_getfocused + ".border=0")
	dw_cal.modify(is_getfocused + ".Font.height='-9'")
	dw_cal.modify(is_getfocused + ".Font.Weight='400'")
	dw_cal.modify(is_getfocused + ".Color='" + String(il_prevcolor) + "'")
End If

is_getfocused = as_cell
il_prevcolor = Long(dw_cal.Describe(is_getfocused + ".Color"))
dw_cal.modify(is_getfocused + ".border=4")
dw_cal.modify(is_getfocused + ".Font.height='-11'")
dw_cal.modify(is_getfocused + ".Font.Weight='700'")
dw_cal.modify(is_getfocused + ".Color='" + String(il_selectcolor) + "'")

Return 0
end function

on w_calendar4day1_us.create
this.dw_cal=create dw_cal
this.Control[]={this.dw_cal}
end on

on w_calendar4day1_us.destroy
destroy(this.dw_cal)
end on

event open;istr_calendar = message.powerobjectparm
If not isvalid(istr_calendar) Then
	Messagebox('Notice(fw_w_calendarday1)', '잘못된 달력 오브젝트 호출입니다')
	Return
End If

iw_parent = istr_calendar.w_obj
If IsValid(istr_calendar.dw_obj1) THEN iwo_parent = istr_calendar.dw_obj1

powerobject lpo_parent
userobject	luo
tab			ltab

STRING	ls_type

LONG	ll_xpos, ll_ypos, add_x

// 부모 컨트롤의 X, Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
Do While isvalid(lpo_parent)
	Choose Case lpo_parent.typeof()
		Case tab!
			ltab = lpo_parent
			ll_xpos += ltab.x
			ll_ypos += ltab.y
		Case userobject!
			luo = lpo_parent
			ll_xpos += luo.x
			ll_ypos += luo.y
		Case window!
			ls_type = fw_f_nvls(iw_parent.Dynamic of_getwindowtype(), '')
			If Pos(ls_type, 'main') > 0 Then
				ll_xpos += gw_mdi.st_mdiclient.x
				ll_ypos += gw_mdi.st_mdiclient.y
			End If
			Exit
	End Choose
	lpo_parent = lpo_parent.getparent()
Loop
If Not isvalid(iw_parent) Then
	messagebox('Notice(fw_w_calendarday)', '부모 윈도우를 찾을 수 없습니다.')
	return
End If

// 오브젝트의 타입에 따라 달력 위치를 조절합니다.
STRING	ls_date, ls_yyyy

DATE	ld_date

If This.of_getload4style(iwo_parent)='freeform'	Then
	If iwo_parent.titlebar	Then
		ll_ypos += iwo_parent.y + Long(iwo_parent.describe (istr_calendar.as_col1 + ".y")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) + Pixelstounits(27, YPixelstounits!)
		ll_xpos += iwo_parent.x + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Pixelstounits(3, YPixelstounits!)
	Else
		ll_ypos += iwo_parent.y + Long(iwo_parent.describe (istr_calendar.as_col1 + ".y")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) + Pixelstounits(2, YPixelstounits!)
		ll_xpos += iwo_parent.x + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x"))
	End If
Else
	//<임시> 스크롤 바를 사용해 위치가 달라져도 달력은 기존 위치에 출력 : 테스트 화면 6060, 2600
	add_x = iwo_parent.pointerx() + Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
	//add_x = Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
	IF	ll_xpos + add_x < 0	Then
		ll_xpos += Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) - Pixelstounits(2, XPixelstounits!)
	Else
		ll_xpos += add_x
	End IF
	ll_ypos += Long(istr_calendar.dw_obj1.y) + (Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) / 2) + iwo_parent.pointery()
End If
// 부모 윈도우 크기에 맞게 달력 위치 조정합니다.  - gw_mdi.uo_xpmenu.width
//<임시> 화면을 벗어났을 때 너무 많이 안쪽으로 들어오게되어 수정 : 테스트 화면 6060
IF string (f_nvl(iw_parent.Dynamic of_getwindowtype(), ''))='response'	Then
	IF ll_xpos + THIS.width > iw_parent.workspacewidth()   THEN ll_xpos -= (ll_xpos + This.width - iw_parent.workspacewidth())
	IF ll_ypos + THIS.height > iw_parent.workspaceheight() THEN ll_ypos -= (ll_ypos + This.height - iw_parent.workspaceheight())
Else
	If ll_xpos + This.width > gw_mdi.width THEN ll_xpos -= Long(iwo_parent.describe (istr_calendar.as_col1 + ".width"))
	If ll_ypos + This.height > iw_parent.workspaceheight() Then
		If iwo_parent.titlebar = true Then
			ll_ypos -= (This.height + Pixelstounits(23, YPixelstounits!))
		Else
			ll_ypos -= This.height
		End If
	End If
End IF
This.x = ll_xpos
This.y = ll_ypos

Choose Case lower(left(iwo_parent.describe(istr_calendar.as_col1 + ".ColType"), 5))
	Case "char(", "char"
		ls_date = iwo_parent.getitemstring(istr_calendar.al_row, istr_calendar.as_col1)
		ls_date = string(ls_Date, '@@@@/@@/@@')
		If isdate(ls_date) Then
			If Pos(ls_date, '9999') > 0 Then
				ls_yyyy = String(today(), 'yyyy')
				ls_date = ls_yyyy + mid(ls_date, 5, 6)
			End If
			id_dateselected = date(ls_date)
		End If
	Case "date"
		ld_date = iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col1)
		If not isnull(ld_date) and ld_date > 1900-01-01 Then
			id_dateselected = ld_date
		End If
	Case "datet"
		ld_date = date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col1))
		If not isnull(ld_date) and ld_date > 1900-01-01 Then
			id_dateselected = ld_date
		End If
	Case Else
		messagebox('Notice', '문자 or 날자 타입 컬럼에만 달력 오브젝트를 사용가능 합니다')
		return
End Choose

// 일자 설정
If isnull(id_dateselected) or id_dateselected = 1900-01-01 Then
	id_dateselected = today()
End If

IF	iwo_parent.dynamic EVENT ue_getdate (string (id_dateselected,'yyyy.mm.dd'))=-1	Then
	dw_cal.object.p_today.filename = "..\img\controls\u_calendar\btn_today3.jpg"
	ib_getdate = FALSE
Else
	dw_cal.object.p_today.filename = "..\img\controls\u_calendar\btn_today3b.jpg"
	ib_getdate = TRUE
End IF

is_org4syntax = dw_cal.Describe("DataWindow.Syntax")

// 달력 DRAW
This.of_drawmonth(year(id_dateselected), month(id_dateselected))
This.of_selectdate(day(id_dateselected))

// 풀다운 형태로 윈도우가 오픈됩니다.
If gnv_vari.getclienttype='PB'	Then
	This.width	= dw_cal.width + Pixelstounits(1, XPixelstounits!)
	This.height	= dw_cal.height + Pixelstounits(1, YPixelstounits!)
Else
	// Child 윈도우 사이즈가 파워빌더와 달라 사이즈 저장함(2013R2 기준)
	This.width	= dw_cal.width - Pixelstounits(8, XPixelstounits!)
	This.height	= dw_cal.height - Pixelstounits(9, YPixelstounits!)
End If

dw_cal.setfocus()

This.Post Event pfe_postopen()
end event

type dw_cal from fw_u_dwo within w_calendar4day1_us
integer width = 951
integer height = 772
integer taborder = 10
string dataobject = "fw_d_calendarday1_us"
boolean border = false
end type

event clicked;if row=0 then return

String	ls_obj, ls_date
long		ll_monthcnt
integer	li_year, li_month, li_day
date		ld_today

ls_obj = string(dwo.name)
If fw_f_nvls(ls_obj, '')='' Then ls_obj = 'zzzzz'
// 일자 선택
if left(ls_obj, 4)="cell" then
	li_day = Long(right(this.describe(ls_obj + ".tag"), 2))
	if li_day>0 then parent.of_selectdate (ls_obj)
	return
End if

// 이전, 다음
If left(ls_obj, 5)='p_pre' or left(ls_obj, 6)='p_next'	then
	li_year = this.getitemnumber(row, 'year')
	li_month = this.getitemnumber(row, 'month')
	ll_monthcnt = li_year * 12 + li_month

	Choose Case ls_obj
		Case 'p_preyear'
			ll_monthcnt -= 12
		Case 'p_premonth'
			ll_monthcnt -= 1
		Case 'p_nextyear'
			ll_monthcnt += 12
		Case 'p_nextmonth'
			ll_monthcnt += 1
	End Choose

	ll_monthcnt --
	li_year = truncate(ll_monthcnt / 12, 0)
	li_month = mod(ll_monthcnt, 12) + 1
	is_getfocused = ''
	parent.setredraw (false)
	Parent.of_drawmonth(li_year, li_month)
	parent.setredraw (true)

elseif left(ls_obj, 7)='t_month'	then	// 개별 월 버튼
	li_year = this.getitemnumber(row, 'year')
	li_month = integer(mid(ls_obj, 8))
	is_getfocused = ''
	parent.setredraw (false)
	parent.of_drawmonth(li_year, li_month)	
	parent.setredraw (true)
else
	// 닫기, 오늘, 선택 버튼 추가
	Choose Case ls_obj
		Case 't_close'
			post close(parent)
		Case 'p_today'
			ld_today = Today()
			li_year = year (ld_today)
			li_month = month (ld_today)
			IF	li_year=getitemnumber(row, 'year') And li_month=getitemnumber(row, 'month')	Then
				of_selectdate (day (ld_today))
			Else
				is_getfocused = ''
				parent.setredraw (false)
				parent.of_drawmonth(li_year, li_month)	
				of_selectdate (day (ld_today))
				parent.setredraw (true)
			End IF
	End Choose
end if
end event

event doubleclicked;if row=0 then return
if left(dwo.name, 4)<>'cell' then return
if is_getfocused='' then return

String	ls_date

ls_date = dw_cal.describe(is_getfocused + ".tag")
ls_date = fw_f_replaceall(ls_date, '-', '')

ib_doubleclicked = true
of_setparentdate(ls_date)
ib_doubleclicked = false

post Close(parent)
end event

event losefocus;// 포커스 잃는 경우 종료
IF ib_doubleclicked=false THEN post close(parent)
end event

event oue_keydown;CHOOSE CASE key
	CASE KeyEscape!
		post close(parent)
	CASE KeyEnter!
		if is_getfocused <> '' then
			String	ls_date			
			ls_date = dw_cal.describe(is_getfocused + ".tag")
			ls_date = fw_f_replaceall(ls_date, '-', '')
			of_setparentdate(ls_date)
			post close(parent)
		end if
END CHOOSE
end event

