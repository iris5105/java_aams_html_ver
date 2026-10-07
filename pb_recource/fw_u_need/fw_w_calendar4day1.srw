forward
global type fw_w_calendar4day1 from window
end type
type dw_cal from datawindow within fw_w_calendar4day1
end type
end forward

global type fw_w_calendar4day1 from window
integer width = 955
integer height = 776
windowtype windowtype = child!
long backcolor = 16777215
event wue_postopen ( )
dw_cal dw_cal
end type
global fw_w_calendar4day1 fw_w_calendar4day1

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
fw_s_calendar		istr_calendar

window				iw_parent
windowobject		iwo_parent
DWObject			idwobj
String				is_getfocused	= ''
String				is_org4syntax	= ''
boolean			ib_org4syntax	= false
Long				il_prevcolor		= 0
Long				il_selectcolor	= RGB(0,0,0)
Date				id_dateselected
end variables

forward prototypes
public function string of_getload4style (datawindow ldw_target)
public function integer of_getdaysinmonth (integer ai_year, integer ai_month)
public subroutine of_highlightcolumn ()
public function integer of_movefocusedcolumn (string as_direction)
public function integer of_setparentdate (string as_dateselected)
public function integer of_selectdate (string as_cell)
public function integer of_selectdate (integer ai_day)
public subroutine of_drawmonth_1sub (integer ai_year, integer ai_month)
public subroutine of_drawmonth (integer ai_year, integer ai_month)
public subroutine of_selectdate (integer ai_year, integer ai_month, integer ai_day)
end prototypes

event wue_postopen();// 달력 DRAW
This.of_drawmonth(year(id_dateselected), month(id_dateselected))
Post of_selectdate(day(id_dateselected))

dw_cal.setfocus()
end event

public function string of_getload4style (datawindow ldw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

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

public function integer of_getdaysinmonth (integer ai_year, integer ai_month);if isnull(ai_year) then return -1
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

public subroutine of_highlightcolumn ();
end subroutine

public function integer of_movefocusedcolumn (string as_direction);if is_getfocused = '' then return -1

integer li_colseq
integer li_year, li_month

li_colseq = integer(mid(is_getfocused, 5))

choose case as_direction
	case 'up'
		li_colseq -= 7
	case 'down'
		li_colseq += 7
	case 'left'
		li_colseq --
	case 'right'
		li_colseq ++
end choose

choose case li_colseq
	case is < 1
		li_year = dw_cal.getitemnumber(1, 'year')
		li_month = dw_cal.getitemnumber(1, 'month')
		
		li_month --
		if li_month = 0 then
			li_year --
			li_month = 12
		end if
		
		of_drawmonth(li_year, li_month)
		li_colseq += 42

	case is > 42
		li_year = dw_cal.getitemnumber(1, 'year')
		li_month = dw_cal.getitemnumber(1, 'month')
		
		li_month ++
		if li_month > 12 then
			li_year ++
			li_month = 1
		end if
		
		of_drawmonth(li_year, li_month)
		li_colseq -= 42
end choose

// deselect
dw_cal.modify(is_getfocused + ".border=0")
dw_cal.modify(is_getfocused + ".Font.height='-9'")

// select
is_getfocused = 'cell' + string(li_colseq)

dw_cal.modify(is_getfocused + ".border=4")
dw_cal.modify(is_getfocused + ".Font.height='-11'")
dw_cal.setredraw(true)

return 0

end function

public function integer of_setparentdate (string as_dateselected);if isnull(iwo_parent) or not isvalid(iwo_parent) then return -1

date ld_selected
ld_selected = date(string(as_dateselected, '@@@@-@@-@@'))
if isnull(ld_selected) or ld_selected = 1900-01-01 then return -1

choose case iwo_parent.typeof()
	case editmask!
		editmask lem_parent
		lem_parent = iwo_parent
		
		choose case lem_parent.maskdatatype
			case datemask!, datetimemask!
				lem_parent.text = string(ld_selected, lem_parent.mask)
				lem_parent.PostEvent('Modified')
			case stringmask!
				lem_parent.text = as_dateselected
				lem_parent.PostEvent('Modified')
			case else
				return -1
		end choose
		
		// 파라다이스는 이벤트 호출하면 안 됨
		//lem_parent.post event modified()
		
	case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent
		
		choose case lower(left(ldw_parent.describe(string(idwobj.name) + ".ColType"), 5))
			case "char(", "char"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj.name), as_dateselected)
			case "date", "datet"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj.name), ld_selected)
			case else
				return -1
		end choose
		
		// 파라다이스는 이벤트 호출하면 안 됨
		//ldw_parent.post event itemchanged(istr_calendar.al_row, istr_calendar.dwo_obj, as_dateselected)
end choose

return 1

end function

public function integer of_selectdate (string as_cell);integer	li_firstdaynum

li_firstdaynum = fw_f_nvll(dw_cal.getitemnumber(1, 'firstdaynum'), 0)

// deselect
If is_getfocused <> '' Then
	dw_cal.modify(is_getfocused + ".border=0")
	dw_cal.modify(is_getfocused + ".Font.height='-9'")
	dw_cal.modify(is_getfocused + ".Font.Weight='400'")
	dw_cal.modify(is_getfocused + ".Color='" + String(il_prevcolor) + "'")
End If

String	ls_syntax, ls_error
ls_syntax = ''
is_getfocused = as_cell
il_prevcolor = Long(dw_cal.Describe(is_getfocused + ".Color"))
ls_syntax += is_getfocused + ".border=4~r~n"
ls_syntax += is_getfocused + ".Font.height='-11'~r~n"
ls_syntax += is_getfocused + ".Font.Weight='700'~r~n"
ls_syntax += is_getfocused + ".Color='0'"

ls_error = dw_cal.Modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selectdate error1', ls_error)
	Return -1
End If
dw_cal.setRedraw( true )

Return 1

end function

public function integer of_selectdate (integer ai_day);integer	li_firstdaynum
li_firstdaynum = fw_f_nvll(dw_cal.getitemnumber(1, 'firstdaynum'), 0)

If is_getfocused <> '' Then
	dw_cal.modify(is_getfocused + ".border=0")
	dw_cal.modify(is_getfocused + ".Font.height='-9'")
	dw_cal.modify(is_getfocused + ".Font.Weight='400'")
	dw_cal.modify(is_getfocused + ".Color='" + String(il_prevcolor) + "'")
End If

String	ls_syntax, ls_error
ls_syntax = ''
is_getfocused = 'cell' + string(li_firstdaynum + ai_day -1)
il_prevcolor = Long(dw_cal.Describe(is_getfocused + ".Color"))
ls_syntax += is_getfocused + ".border=4~r~n"
ls_syntax += is_getfocused + ".Font.height='-11'~r~n"
ls_syntax += is_getfocused + ".Font.Weight='700'~r~n"
ls_syntax += is_getfocused + ".Color='0'"

ls_error = dw_cal.Modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selectdate error1', ls_error)
	Return -1
End If
dw_cal.setRedraw( true )
Return 1


end function

public subroutine of_drawmonth_1sub (integer ai_year, integer ai_month);string	ls_syntax1, ls_error
integer	li_daysinmonth, li_empty, li_lastdaynum, i, ll_daynum
date	ld_firstday, ld_today, ld_calday

li_daysinmonth	= of_getdaysinmonth(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)
li_empty		= daynumber(ld_firstday)

// save current year & month
dw_cal.setitem(1, 'year', ai_year)
dw_cal.setitem(1, gnv_extfunc.istr_node4value.cstr09, ai_month)
dw_cal.setitem(1, gnv_extfunc.istr_node4value.cstr15, li_empty)

ls_syntax1 = '' //초기화
// setitem cell1 ~ cell42 
For i = 1 to li_daysinmonth
	dw_cal.setitem(1, 'cell' + string(i + li_empty - 1), string(i))
	ld_calday = date(ai_year, ai_month,  i)
	ls_syntax1 += 'cell' + string(i + li_empty - 1) + '.tag="' + string(ld_calday, 'yyyy-mm-dd') + '"~r~n'
	ll_daynum	= daynumber(ld_calday)
	Choose Case ll_daynum
		Case 7
			ls_syntax1 += 'cell' + string(i + li_empty - 1) + '.Color="' + string(rgb(35,120,195)) + '"~r~n'
		Case 1
			ls_syntax1 += gnv_extfunc.istr_node4value.cstr07 + string(i + li_empty - 1) + '.Color="' + string(rgb(255,0,0)) + '"~r~n'
		Case Else
			ls_syntax1 += 'cell' + string(i + li_empty - 1) + '.Color="' + string(rgb(15,15,15)) + '"~r~n'
	End Choose	
Next

date	ld_prev_fr, ld_prev_to
Long	ll_prev_month, ll_gapnum, ll_fr_num
If li_empty > 1 Then
	ll_gapnum		= li_empty - 1
	ld_prev_fr		= relativedate (ld_firstday, -ll_gapnum)
	ld_prev_to		= relativedate (ld_firstday, -1)
	ll_fr_num		= day (ld_prev_fr) - 1
	ll_prev_month	= month (ld_prev_fr)
	for i = 1 to ll_gapnum
		dw_cal.setitem(1, 'cell' + string(i), string(ll_fr_num + i))
		ld_today = RelativeDate(date(ai_year, ai_month, 15), -30)
		ld_today = date(long(string(ld_today, 'yyyy')), long(string(ld_today, 'mm')),  (ll_fr_num + i))
		ls_syntax1 += 'cell' + string(i) + '.tag="' + string(ld_today, gnv_extfunc.istr_node4value.cstr06) + '"~r~n'
		ls_syntax1 += 'cell' + string(i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next
End If

ll_gapnum = 42 - li_daysinmonth - fw_f_nvll(ll_gapnum, 0)
If ll_gapnum > 0 Then
	li_lastdaynum = 42 - ll_gapnum
	for i = 1 to ll_gapnum
		dw_cal.setitem(1, 'cell' + string(li_lastdaynum + i), string(i))
		ld_today	= RelativeDate(date(ai_year, ai_month, 15), 30)
		ld_today 	= date(long(string(ld_today, 'yyyy')), long(string(ld_today, 'mm')), i)
		ls_syntax1 += 'cell' + string(li_lastdaynum + i) + '.tag="' + string(ld_today, gnv_extfunc.istr_node4value.cstr12) + '"~r~n'
		ls_syntax1 += 'cell' + string(li_lastdaynum + i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next	
End If

ls_error = dw_cal.Modify(ls_syntax1)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax1)
	messagebox('of_drawmonth() error1', ls_error)
	Return
End If

ib_org4syntax = true
dw_cal.setredraw(true)
end subroutine

public subroutine of_drawmonth (integer ai_year, integer ai_month);String	ls_syntax1, ls_error

dw_cal.setredraw(false)
If ib_org4syntax = true Then
	dw_cal.create(is_org4syntax, ls_error)
	If len(ls_error) > 0 then
		messagebox('of_drawmonth() org create error', ls_error)
		Return
	End If
End If
dw_cal.reset()
dw_cal.insertrow(0)

Post of_drawmonth_1sub(ai_year, ai_month)

end subroutine

public subroutine of_selectdate (integer ai_year, integer ai_month, integer ai_day);integer li_day
if dw_cal.rowcount() = 0 then
	this.of_drawmonth(ai_year, ai_month)
end if

if dw_cal.getitemnumber(1, 'year') <> ai_year or dw_cal.getitemnumber(1, 'month') <> ai_month then
	this.of_drawmonth(ai_year, ai_month)
end if

Post of_selectdate(ai_day)

end subroutine

on fw_w_calendar4day1.create
this.dw_cal=create dw_cal
this.Control[]={this.dw_cal}
end on

on fw_w_calendar4day1.destroy
destroy(this.dw_cal)
end on

event open;istr_calendar = message.powerobjectparm
If not isvalid(istr_calendar) Then
	Messagebox('Notice(fw_w_calendarday1)', '잘못된 달력 오브젝트 호출입니다')
	Return
End If

is_org4syntax = dw_cal.Describe("DataWindow.Syntax")
iw_parent = istr_calendar.w_obj
If IsValid(istr_calendar.dw_obj) Then
	iwo_parent	= istr_calendar.dw_obj
	idwobj		= istr_calendar.anyobj1
End If

If IsValid(istr_calendar.em_obj1) Then
	iwo_parent = istr_calendar.em_obj1
End If

powerobject lpo_parent
Long	ll_xpos, ll_ypos

// 부모 컨트롤의 X, Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
Do While isvalid(lpo_parent)
	Choose Case lpo_parent.typeof()
		Case tab!
			tab ltab
			ltab = lpo_parent
			ll_xpos += ltab.x
			ll_ypos += ltab.y
		Case userobject!
			userobject luo
			luo = lpo_parent
			ll_xpos += luo.x
			ll_ypos += luo.y
		Case window!
			String	ls_type
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

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = gnv_vari.is_sys_id
gnv_extfunc.biznode11te(114, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

// 오브젝트의 타입에 따라 달력 위치를 조절합니다.
String	ls_date, ls_yyyy
Date	ld_date

Choose Case iwo_parent.typeof()
	Case editmask!
		editmask lem
		lem = iwo_parent
		ll_xpos += lem.x
		ll_ypos += lem.y + lem.height
		
		ls_date = lem.text
		If isdate(ls_date) Then
			If Pos(ls_date, '9999') > 0 Then
				ls_yyyy = String(today(), 'yyyy')
				ls_date = ls_yyyy + mid(ls_date, 5, 6)
			End If
			id_dateselected = date(ls_date)
		End If		
	Case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent
		If This.of_getload4style(ldw_parent)  = 'freeform' Then
			If ldw_parent.titlebar = true Then
				ll_xpos += ldw_parent.x + Long(idwobj.x) + Pixelstounits(3, YPixelstounits!)
				ll_ypos += ldw_parent.y + Long(idwobj.y) + Long(idwobj.height) + Pixelstounits(29, YPixelstounits!)
			Else
				ll_xpos += ldw_parent.x + Long(idwobj.x)
				ll_ypos += ldw_parent.y + Long(idwobj.y) + Long(idwobj.height) + Pixelstounits(2, YPixelstounits!)
			End If
		Else
			ll_xpos += Long(istr_calendar.dw_obj.x) + Long(idwobj.x) - Pixelstounits(2, XPixelstounits!)
			ll_ypos += Long(istr_calendar.dw_obj.y) + (Long(idwobj.height) / 2) + ldw_parent.pointery()
		End If
		
		Choose Case lower(left(ldw_parent.describe(string(idwobj.name) + ".ColType"), 5))
			Case "char(", "char"
				ls_date = ldw_parent.getitemstring(istr_calendar.al_row, string(idwobj.name))
				ls_date = string(ls_Date, '@@@@/@@/@@')
				If isdate(ls_date) Then
					If Pos(ls_date, '9999') > 0 Then
						ls_yyyy = String(today(), 'yyyy')
						ls_date = ls_yyyy + mid(ls_date, 5, 6)
					End If
					id_dateselected = date(ls_date)
				End If
			Case "date"
				ld_date = ldw_parent.getitemdate(istr_calendar.al_row, string(idwobj.name))
				If not isnull(ld_date) and ld_date > 1900-01-01 Then
					id_dateselected = ld_date
				End If
			Case "datet"
				ld_date = date(ldw_parent.getitemdatetime(istr_calendar.al_row, string(idwobj.name)))
				If not isnull(ld_date) and ld_date > 1900-01-01 Then
					id_dateselected = ld_date
				End If
			Case Else
				messagebox('Notice', '문자 or 날자 타입 컬럼에만 달력 오브젝트를 사용가능 합니다')
				return
		End Choose
End Choose

// 부모 윈도우 크기에 맞게 달력 위치 조정합니다.  - gw_mdi.uo_xpmenu.width
//messagebox(string(ll_xpos + This.width), string(idwobj.width))
If ll_xpos + This.width > gw_mdi.width Then
	Choose Case iwo_parent.typeof()
		Case datawindow!
			ll_xpos -= This.width - Long(idwobj.width)
		Case editmask!
			ll_xpos -= This.width - Long(istr_calendar.em_obj1.width)
	End Choose
End If

If ll_ypos + This.height > iw_parent.workspaceheight() Then
	If ldw_parent.titlebar = true Then
		ll_ypos -= (This.height + Pixelstounits(27, YPixelstounits!))
	Else
		ll_ypos -= This.height
	End If
End If

This.x = ll_xpos
This.y = ll_ypos

If gnv_vari.getclienttype = 'WEB' Then This.Height -= pixelstounits(2, ypixelstounits!)

// 일자 설정
If isnull(id_dateselected) or id_dateselected = 1900-01-01 Then
	id_dateselected = today()
End If

Post event wue_postopen( )
end event

type dw_cal from datawindow within fw_w_calendar4day1
event ue_dwnkey pbm_dwnkey
integer width = 951
integer height = 772
integer taborder = 10
string dataobject = "fw_d_calendarday1"
boolean border = false
end type

event ue_dwnkey;CHOOSE CASE key
	CASE KeyHome!
		this.event clicked(0, 0, this.getrow(), this.object.p_nextyear)
	CASE KeyEnd!
		this.event clicked(0, 0, this.getrow(), this.object.p_preyear)
	CASE KeyPageUp!
		this.event clicked(0, 0, this.getrow(), this.object.p_nextmonth)
	CASE KeyPageDown!
		this.event clicked(0, 0, this.getrow(), this.object.p_premonth)
	CASE KeyRightArrow!
		of_movefocusedcolumn('right')
	CASE KeyLeftArrow!
		of_movefocusedcolumn('left')
	CASE KeyUpArrow!
		of_movefocusedcolumn('up')
	CASE KeyDownArrow!
		of_movefocusedcolumn('down')
	CASE KeyEscape!
		post close(parent)
	CASE KeyEnter!
		if is_getfocused <> '' then
			String		ls_date			
			ls_date = dw_cal.describe(is_getfocused + ".tag")
			ls_date = fw_f_replaceall(ls_date, '-', '')
			
			of_setparentdate(ls_date)
			post close(parent)
		end if
END CHOOSE

end event

event clicked;if row = 0 then return
String	ls_obj
long	ll_monthcnt
integer	li_year, li_month, li_day

ls_obj = string(dwo.name)
If fw_f_nvls(ls_obj, '') = '' Then ls_obj = 'zzzzz'
// 일자 선택
if left(ls_obj, 4) = "cell" then
	li_day = Long(right(this.describe(ls_obj + ".tag"), 2))
	if li_day > 0 then
		parent.of_selectdate(string(ls_obj))
	End if
	Return
End if

// 이전월, 다음월
If left(ls_obj, 5) = 'p_pre' or left(ls_obj, 6) = 'p_next' then
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
	Parent.of_drawmonth(li_year, li_month)
	Return
End If

// 닫기, 오늘, 선택 버튼 추가
Choose Case ls_obj
	Case 't_close'
		post close(parent)
		Return
	Case 'p_today'
		date ld_today
		ld_today = Today()
		of_selectdate(year(ld_today), month(ld_today), day(ld_today))
		Return
	Case 't_select'
		If is_getfocused = '' Then Return
		String		ls_date			
		ls_date = dw_cal.describe(is_getfocused + ".tag")
		ls_date = fw_f_replaceall(ls_date, '-', '')
		
		of_setparentdate(ls_date)
		Post Close(parent)
		Return
End Choose

// 개별 월 버튼
If left(ls_obj, 7) = 't_month' then
	li_year = this.getitemnumber(row, 'year')
	li_month = integer(mid(ls_obj, 8))
	parent.of_drawmonth(li_year, li_month)
	Return
End If
end event

event doubleclicked;if row = 0 then return
if left(dwo.name, 4) <> 'cell' then return
if is_getfocused = '' then return

String		ls_date			
ls_date = dw_cal.describe(is_getfocused + ".tag")
ls_date = fw_f_replaceall(ls_date, '-', '')

of_setparentdate(ls_date)

Post Close(parent)
end event

event losefocus;// 포커스 잃는 경우 종료
post close(parent)

end event

