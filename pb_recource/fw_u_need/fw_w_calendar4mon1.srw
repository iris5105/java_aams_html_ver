forward
global type fw_w_calendar4mon1 from window
end type
type dw_cal from datawindow within fw_w_calendar4mon1
end type
end forward

global type fw_w_calendar4mon1 from window
integer width = 974
integer height = 624
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
event pfe_postopen ( )
dw_cal dw_cal
end type
global fw_w_calendar4mon1 fw_w_calendar4mon1

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
fw_s_calendar	istr_calendar

window			iw_parent
windowobject	iwo_parent
DWObject		idwobj
fw_n_animate	inv_dropdown

string			is_monthfocused
date			id_dateselected, id_monthselected

end variables

forward prototypes
public function string of_getload4style (datawindow ldw_target)
public function integer of_drawmonth (integer ai_year, integer ai_month)
public function integer of_getdaysinmonth (integer ai_year, integer ai_month)
public subroutine of_highlightcolumn ()
public function integer of_movefocusedcolumn (string as_direction)
public function integer of_setparentdate (string as_dateselected)
public function integer of_selectmonth (integer ai_month)
public function integer of_selectmonth (integer ai_year, integer ai_month, integer ai_day)
end prototypes

public function string of_getload4style (datawindow ldw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

string ls_processing, ls_style

ls_processing = ldw_target.describe("datawindow.processing")
choose case long(ls_processing)
	case 0
		//FreeForm인 경우 : detail band height가 dw control의 height의 2.5배 미만(만약 Header가 있는경우를 대비)
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
		ls_style = 'treeView'
	case 9
		ls_style = 'treeviewwithgrid'
	Case Else
		ls_style = 'etc'
end choose

return ls_style

end function

public function integer of_drawmonth (integer ai_year, integer ai_month);integer	li_daysinmonth, li_firstdaynum, i
date	ld_firstday

dw_cal.setredraw(false)
dw_cal.reset()
dw_cal.insertrow(0)

li_daysinmonth	= of_getdaysinmonth(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)
li_firstdaynum	= daynumber(ld_firstday)

// save current year & month
dw_cal.setitem(1, 'year', ai_year)
dw_cal.setitem(1, 'month', ai_month)
dw_cal.setitem(1, 'firstdaynum', li_firstdaynum)

// setitem cell1 ~ cell42 
for i = 1 to li_daysinmonth
	dw_cal.setitem(1, 'cell' + string(i + li_firstdaynum - 1), string(i))
next

dw_cal.setredraw(true)
Return 0

end function

public function integer of_getdaysinmonth (integer ai_year, integer ai_month);if isnull(ai_year) then return -1
if isnull(ai_month) then return -1

integer li_days[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
integer li_daysinmonth

li_daysinmonth = li_days[ai_month]
if ai_month = 2 then
	if (mod(ai_year, 4) = 0 and mod(ai_year, 100) <> 0) or mod(ai_year, 400) = 0 then
		li_daysinmonth = 29
	end if
end if

return li_daysinmonth

end function

public subroutine of_highlightcolumn ();
end subroutine

public function integer of_movefocusedcolumn (string as_direction);If is_monthfocused = '' Then Return -1

integer li_colseq
integer li_year, li_month

li_colseq = integer(mid(is_monthfocused, 8))

Choose Case as_direction
	Case 'up'
		li_colseq -= 6
	Case 'down'
		li_colseq += 6
	Case 'left'
		li_colseq --
	Case 'right'
		li_colseq ++
End Choose

Choose case li_colseq
	Case is < 1
		li_year = dw_cal.getitemnumber(1, 'year')
		li_month = dw_cal.getitemnumber(1, 'month')
		
		li_month --
		If li_month = 0 then
			li_year --
			li_month = 12
		End If		
		of_drawmonth(li_year, li_month)

	Case is > 12
		li_year = dw_cal.getitemnumber(1, 'year')
		li_month = dw_cal.getitemnumber(1, 'month')
		
		li_month ++
		If li_month > 12 then
			li_year ++
			li_month = 1
		End If		
		of_drawmonth(li_year, li_month)
		
	Case Else
		li_year	= dw_cal.getitemnumber(1, 'year')
		li_month	= li_colseq
		of_drawmonth(li_year, li_colseq)
End Choose

// to-be select month
is_monthfocused = 't_month' + string(li_month)

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
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj.name), left(as_dateselected, 6))
			case "date", "datet"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj.name), ld_selected)
			case else
				return -1
		end choose
		
		ldw_parent.post event itemchanged(istr_calendar.al_row, idwobj, left(as_dateselected, 6))
end choose

return 1

end function

public function integer of_selectmonth (integer ai_month);is_monthfocused = 't_month' + string(ai_month)

return 0

end function

public function integer of_selectmonth (integer ai_year, integer ai_month, integer ai_day);integer li_day, li_firstdaynum

if dw_cal.rowcount() = 0 then
	this.of_drawmonth(ai_year, ai_month)
end if

if dw_cal.getitemnumber(1, 'year') <> ai_year or dw_cal.getitemnumber(1, 'month') <> ai_month then
	this.of_drawmonth(ai_year, ai_month)
end if

return this.of_selectmonth(ai_month)

end function

on fw_w_calendar4mon1.create
this.dw_cal=create dw_cal
this.Control[]={this.dw_cal}
end on

on fw_w_calendar4mon1.destroy
destroy(this.dw_cal)
end on

event open;istr_calendar = message.powerobjectparm
If not isvalid(istr_calendar) Then
	Messagebox('Notice(fw_w_calendarmon)', '잘못된 달력 오브젝트 호출입니다')
	Return
End If
iw_parent	= istr_calendar.w_obj
If IsValid(istr_calendar.dw_obj) Then
	iwo_parent	= istr_calendar.dw_obj
	idwobj		= istr_calendar.anyobj1
End If
If IsValid(istr_calendar.em_obj1) Then
	iwo_parent = istr_calendar.em_obj1
End If

powerobject	lpo_parent
Long			ll_xpos, ll_ypos

// 부모 컨트롤의 X,Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
do while isvalid(lpo_parent)
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
			String		ls_type
			ls_type = fw_f_nvls(iw_parent.Dynamic of_getwindowtype(), '')
			If Pos(ls_type,'main') > 0 Then
				ll_xpos += gw_mdi.st_mdiclient.x
				ll_ypos += gw_mdi.st_mdiclient.y
			End If
			Exit
	End Choose
	lpo_parent = lpo_parent.getparent()
Loop

If Not isvalid(iw_parent) Then
	messagebox('Notice(w_ea_calendarday)', '부모 윈도우를 찾을 수 없습니다.')
	return
End If

// 오브젝트의 타입에 따라 달력 위치를 조절합니다.
String	ls_date, ls_yyyy
Date		ld_date

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
			ll_xpos += ldw_parent.x + Long(idwobj.x)
			ll_ypos += ldw_parent.y + Long(idwobj.y) + Long(idwobj.height) + Pixelstounits(2, YPixelstounits!)
		Else
			ll_xpos += Long(istr_calendar.dw_obj.x) + Long(idwobj.x) + Long(idwobj.width) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
			ll_ypos += Long(istr_calendar.dw_obj.y) + (Long(idwobj.height) / 2) + ldw_parent.pointery()
		End If
		
		Choose Case lower(left(ldw_parent.describe(string(idwobj.name) + ".ColType"), 5))
			Case "char(", "char"
				ls_date = ldw_parent.getitemstring(istr_calendar.al_row, string(idwobj.name))
				ls_date = string(ls_Date, '@@@@/@@') + '/01'
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

If Not isvalid(inv_dropdown) Then inv_dropdown = Create fw_n_animate

// 부모 윈도우 크기에 맞게 달력 위치 조정합니다.  - gw_mdi.uo_xpmenu.width
//messagebox(string(ll_xpos + This.width), string(idwobj.width))
If ll_xpos + This.width > gw_mdi.width Then
	Choose Case iwo_parent.typeof()
		Case datawindow!
			ll_xpos -= This.width - Long(idwobj.width) - PixelsToUnits(1, xPixelsToUnits!)
		Case editmask!
			ll_xpos -= This.width - Long(istr_calendar.em_obj1.width) - PixelsToUnits(1, xPixelsToUnits!)
	End Choose
End If
// 애니메이션 방향 설정
Integer li_direction
If ll_ypos + This.height > iw_parent.workspaceheight() Then
	ll_ypos -= This.height
	li_direction = inv_dropdown.BottomUp
Else
	li_direction = inv_dropdown.TopDown
End If

This.x = ll_xpos
This.y = ll_ypos
If gnv_vari.getclienttype = 'WEB' Then
	This.width += Pixelstounits(1, Xpixelstounits!)
	This.height -= Pixelstounits(2, YPixelstounits!)
End If
// 일자 설정
If isnull(id_dateselected) or id_dateselected = 1900-01-01 Then
	id_dateselected = today()
End If

// 달력 DRAW
This.of_drawmonth(year(id_dateselected), month(id_dateselected))
/* to-be */
this.of_selectmonth(month(id_dateselected))


dw_cal.setredraw(true)
dw_cal.setfocus()

This.Post Event pfe_postopen()
end event

type dw_cal from datawindow within fw_w_calendar4mon1
event ue_dwnkey pbm_dwnkey
integer width = 974
integer height = 620
integer taborder = 10
string dataobject = "fw_d_calendarmon1"
boolean border = false
end type

event ue_dwnkey;Choose Case key
	Case KeyHome!
		this.event clicked(0, 0, this.getrow(), this.object.p_nextyear)
	Case KeyEnd!
		this.event clicked(0, 0, this.getrow(), this.object.p_preyear)
	Case KeyPageUp!
		this.event clicked(0, 0, this.getrow(), this.object.p_nextmonth)
	Case KeyPageDown!
		this.event clicked(0, 0, this.getrow(), this.object.p_premonth)
	Case KeyRightArrow!
		of_movefocusedcolumn('right')
	Case KeyLeftArrow!
		of_movefocusedcolumn('left')
	Case KeyUpArrow!
		of_movefocusedcolumn('up')
	Case KeyDownArrow!
		of_movefocusedcolumn('down')
	Case KeyEscape!
		post close(parent)
	Case KeyEnter!
		if is_monthfocused <> '' then
			integer li_year, li_month, li_day
			
			li_year		= this.getitemnumber(this.getrow(), 'year')
			li_month	= this.getitemnumber(this.getrow(), 'month')
			li_day		= 1 //to-be integer(this.getitemstring(this.getrow(), is_getfocused))
			//if isnull(li_day) or li_day = 0 then return
			of_setparentdate(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
			post close(parent)
		end if
END Choose

end event

event clicked;If row = 0 Then return
If isnull(dwo) Then return

// 이전월, 다음월
Long	ll_monthcnt
Integer	li_month, li_year, li_day

If left(dwo.name, 5) = 'p_pre' or left(dwo.name, 6) = 'p_next' Then
	li_year		= this.getitemnumber(row, 'year')
	li_month	= this.getitemnumber(row, 'month')
	ll_monthcnt	= li_year * 12 + li_month

	Choose Case dwo.name
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

// 개별 월 버튼
If left(dwo.name, 7) = 't_month' Then
	li_year	= this.getitemnumber(row, 'year')
	li_month = integer(mid(dwo.name, 8))
	of_selectmonth(li_month)
	Parent.of_drawmonth(li_year, li_month)
	
	li_year		= this.getitemnumber(row, 'year')
	li_month	= this.getitemnumber(row, 'month')
	li_day		= 1
	
	Return
End If
end event

event doubleclicked;///* as-is */
//if row = 0 then return
//if left(dwo.name, 7) <> 't_month' then return
//if is_monthfocused = '' then return
//
//integer li_year, li_month, li_day
//
//li_year = this.getitemnumber(row, 'year')
//li_month = this.getitemnumber(row, 'month')
//li_day = 1 //integer(this.getitemstring(row, is_getfocused))
////if isnull(li_day) or li_day = 0 then return
//
//of_setparentdate(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
//
//post close(parent)
if row = 0 then return
if is_monthfocused = '' then return
If left(dwo.name, 7) = 't_month' Then
	integer li_year, li_month, li_day
	li_year		= this.getitemnumber(row, 'year')
	li_month	= this.getitemnumber(row, 'month')
	li_day		= 1
	
	of_setparentdate(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
	Post Close(parent)
End If
end event

event losefocus;// 포커스 잃는 경우 종료
Post Close(parent)

end event

