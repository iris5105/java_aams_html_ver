forward
global type fw_w_calendar4mon2 from window
end type
type p_tsync from pf_u_imagebutton within fw_w_calendar4mon2
end type
type p_fsync from pf_u_imagebutton within fw_w_calendar4mon2
end type
type p_close from pf_u_imagebutton within fw_w_calendar4mon2
end type
type dw_t from datawindow within fw_w_calendar4mon2
end type
type dw_f from datawindow within fw_w_calendar4mon2
end type
end forward

global type fw_w_calendar4mon2 from window
integer width = 2030
integer height = 624
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
boolean toolbarvisible = false
event pfe_postopen ( )
event wue_close4calendar ( )
p_tsync p_tsync
p_fsync p_fsync
p_close p_close
dw_t dw_t
dw_f dw_f
end type
global fw_w_calendar4mon2 fw_w_calendar4mon2

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
Protected:
	fw_n_custtiming		inv_idle4time
	double				ido_idle4time	= 0.3
	boolean			ib_obj4dwf	= false
	boolean			ib_obj4dwt	= false
	boolean			ib_obj4fsync= false
	boolean			ib_obj4tsync= false
	

Public:
	fw_s_calendar	istr_calendar
	
	window			iw_parent
	windowobject	iwo_parent1, iwo_parent2
	DWObject		idwobj1, idwobj2
	
	String			is_monthfocused_f
	Date			id_dateselected_f, id_monthselected_f
	String			is_monthfocused_t
	Date			id_dateselected_t, id_monthselected_t

end variables

forward prototypes
public function string of_getload4style (datawindow ldw_target)
public function integer of_drawmonth_f (integer ai_year, integer ai_month)
public function integer of_getdaysinmonth_f (integer ai_year, integer ai_month)
public subroutine of_highlightcolumn_f ()
public function integer of_movefocusedcolumn_f (string as_direction)
public function integer of_setparentdate_f (string as_dateselected)
public function integer of_selectmonth_f (integer ai_month)
public function integer of_selectmonth_f (integer ai_year, integer ai_month, integer ai_day)
public function integer of_drawmonth_t (integer ai_year, integer ai_month)
public function integer of_getdaysinmonth_t (integer ai_year, integer ai_month)
public function integer of_movefocusedcolumn_t (string as_direction)
public function integer of_selectmonth_t (integer ai_month)
public function integer of_selectmonth_t (integer ai_year, integer ai_month, integer ai_day)
public function integer of_setparentdate_t (string as_dateselected)
public subroutine of_setallsend4month ()
end prototypes

event wue_close4calendar();inv_idle4time.stop( )
If ib_obj4dwf = false and &
	ib_obj4dwt = false and &
	ib_obj4fsync= false and &
	ib_obj4tsync= false Then Post Close(this)
end event

public function string of_getload4style (datawindow ldw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

string	ls_processing, ls_style

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

public function integer of_drawmonth_f (integer ai_year, integer ai_month);integer	li_daysinmonth, li_firstdaynum, i
date	ld_firstday

dw_f.setredraw(false)
dw_f.reset()
dw_f.insertrow(0)

li_daysinmonth	= of_getdaysinmonth_f(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)
li_firstdaynum	= daynumber(ld_firstday)

// save current year & month
dw_f.setitem(1, 'year', ai_year)
dw_f.setitem(1, 'month', ai_month)
dw_f.setitem(1, 'firstdaynum', li_firstdaynum)

// setitem cell1 ~ cell42
for i = 1 to li_daysinmonth
	dw_f.setitem(1, 'cell' + string(i + li_firstdaynum - 1), string(i))
next

dw_f.setredraw(true)
Return 0

end function

public function integer of_getdaysinmonth_f (integer ai_year, integer ai_month);if isnull(ai_year) then return -1
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

public subroutine of_highlightcolumn_f ();
end subroutine

public function integer of_movefocusedcolumn_f (string as_direction);If is_monthfocused_f = '' Then Return -1

integer li_colseq
integer li_year, li_month

li_colseq = integer(mid(is_monthfocused_f, 8))

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
		li_year = dw_f.getitemnumber(1, 'year')
		li_month = dw_f.getitemnumber(1, 'month')
		
		li_month --
		If li_month = 0 then
			li_year --
			li_month = 12
		End If		
		of_drawmonth_f(li_year, li_month)

	Case is > 12
		li_year = dw_f.getitemnumber(1, 'year')
		li_month = dw_f.getitemnumber(1, 'month')
		
		li_month ++
		If li_month > 12 then
			li_year ++
			li_month = 1
		End If		
		of_drawmonth_f(li_year, li_month)
		
	Case Else
		li_year	= dw_f.getitemnumber(1, 'year')
		li_month	= li_colseq
		of_drawmonth_f(li_year, li_colseq)
End Choose

// to-be select month
is_monthfocused_f = 't_month' + string(li_month)

dw_f.setredraw(true)

return 0

end function

public function integer of_setparentdate_f (string as_dateselected);If IsValid(istr_calendar.dw_obj) Then
	if isnull(idwobj1) or not isvalid(idwobj1) then return -1
End If
If IsValid(istr_calendar.em_obj1) Then
	if isnull(iwo_parent1) or not isvalid(iwo_parent1) then return -1
End If
date ld_selected
ld_selected = date(string(as_dateselected, '@@@@-@@-@@'))
if isnull(ld_selected) or ld_selected = 1900-01-01 then return -1

choose Case iwo_parent1.typeof()
	Case editmask!
		editmask lem_parent
		lem_parent = iwo_parent1
		
		choose Case lem_parent.maskdatatype
			Case datemask!, datetimemask!
				lem_parent.text = string(ld_selected, lem_parent.mask)
				lem_parent.PostEvent('Modified')
			Case stringmask!
				lem_parent.text = as_dateselected
				lem_parent.PostEvent('Modified')
			Case else
				return -1
		end choose
	Case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent1
		
		choose Case lower(left(ldw_parent.describe(string(idwobj1.name) + ".ColType"), 5))
			Case "char(", "char"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj1.name), left(as_dateselected, 6))
			Case "date", "datet"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj1.name), ld_selected)
			Case else
				return -1
		end choose
		
		ldw_parent.Post event itemchanged(istr_calendar.al_row, idwobj1, left(as_dateselected, 6))
end choose

return 1

end function

public function integer of_selectmonth_f (integer ai_month);is_monthfocused_f = 't_month' + string(ai_month)

return 0

end function

public function integer of_selectmonth_f (integer ai_year, integer ai_month, integer ai_day);integer li_day, li_firstdaynum

if dw_f.rowcount() = 0 then
	this.of_drawmonth_f(ai_year, ai_month)
end if

if dw_f.getitemnumber(1, 'year') <> ai_year or dw_f.getitemnumber(1, 'month') <> ai_month then
	this.of_drawmonth_f(ai_year, ai_month)
end if

return this.of_selectmonth_f(ai_month)

end function

public function integer of_drawmonth_t (integer ai_year, integer ai_month);integer	li_daysinmonth, li_firstdaynum, i
date	ld_firstday

dw_t.setredraw(false)
dw_t.reset()
dw_t.insertrow(0)

li_daysinmonth	= of_getdaysinmonth_t(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)
li_firstdaynum	= daynumber(ld_firstday)

// save current year & month
dw_t.setitem(1, 'year', ai_year)
dw_t.setitem(1, 'month', ai_month)
dw_t.setitem(1, 'firstdaynum', li_firstdaynum)

// setitem cell1 ~ cell42 
for i = 1 to li_daysinmonth
	dw_t.setitem(1, 'cell' + string(i + li_firstdaynum - 1), string(i))
next

dw_t.setredraw(true)
Return 0

end function

public function integer of_getdaysinmonth_t (integer ai_year, integer ai_month);if isnull(ai_year) then return -1
if isnull(ai_month) then return -1

integer li_days[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
integer li_daysinmonth

li_daysinmonth = li_days[ai_month]
If ai_month = 2 then
	If (mod(ai_year, 4) = 0 and mod(ai_year, 100) <> 0) or mod(ai_year, 400) = 0 then
		li_daysinmonth = 29
	End If
End If

Return li_daysinmonth

end function

public function integer of_movefocusedcolumn_t (string as_direction);If is_monthfocused_t = '' Then Return -1

integer li_colseq
integer li_year, li_month

li_colseq = integer(mid(is_monthfocused_t, 8))

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
		li_year = dw_t.getitemnumber(1, 'year')
		li_month = dw_t.getitemnumber(1, 'month')
		
		li_month --
		If li_month = 0 then
			li_year --
			li_month = 12
		End If		
		of_drawmonth_t(li_year, li_month)

	Case is > 12
		li_year = dw_t.getitemnumber(1, 'year')
		li_month = dw_t.getitemnumber(1, 'month')
		
		li_month ++
		If li_month > 12 then
			li_year ++
			li_month = 1
		End If		
		of_drawmonth_t(li_year, li_month)
		
	Case Else
		li_year	= dw_t.getitemnumber(1, 'year')
		li_month	= li_colseq
		of_drawmonth_t(li_year, li_colseq)
End Choose

// to-be select month
is_monthfocused_t = 't_month' + string(li_month)

dw_t.setredraw(true)

return 0

end function

public function integer of_selectmonth_t (integer ai_month);is_monthfocused_t = 't_month' + string(ai_month)

return 0
end function

public function integer of_selectmonth_t (integer ai_year, integer ai_month, integer ai_day);integer li_day, li_firstdaynum

if dw_t.rowcount() = 0 then
	this.of_drawmonth_t(ai_year, ai_month)
end if

if dw_t.getitemnumber(1, 'year') <> ai_year or dw_t.getitemnumber(1, 'month') <> ai_month then
	this.of_drawmonth_t(ai_year, ai_month)
end if

return this.of_selectmonth_t(ai_month)

end function

public function integer of_setparentdate_t (string as_dateselected);If IsValid(istr_calendar.dw_obj) Then
	If isnull(idwobj2) or not isvalid(idwobj2) then Return -1
End If
If IsValid(istr_calendar.em_obj2) Then
	If isnull(iwo_parent2) or not isvalid(iwo_parent2) then Return -1
End If

date ld_selected
ld_selected = date(string(as_dateselected, '@@@@-@@-@@'))
if isnull(ld_selected) or ld_selected = 1900-01-01 then Return -1

Choose Case iwo_parent1.typeof()
	Case editmask!
		editmask	lem_parent
		lem_parent = iwo_parent2
		
		Choose Case lem_parent.maskdatatype
			Case datemask!, datetimemask!
				lem_parent.text = string(ld_selected, lem_parent.mask)
				lem_parent.PostEvent('Modified')
			Case stringmask!
				lem_parent.text = as_dateselected
				lem_parent.PostEvent('Modified')
			Case else
				Return -1
		End Choose		
	Case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent1

		Choose Case lower(left(ldw_parent.Describe(string(idwobj2.name) + ".ColType"), 5))
			Case "char(", "char"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj2.name), left(as_dateselected, 6))
			Case "date", "datet"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj2.name), ld_selected)
			Case else
				Return -1
		End Choose

		ldw_parent.Post event itemchanged(istr_calendar.al_row, idwobj2, left(as_dateselected, 6))
End Choose

Return 1
end function

public subroutine of_setallsend4month ();String	ls_ymd
Integer	li_year, li_month

li_year		= dw_f.getitemnumber(1, 'year')
li_month	= dw_f.getitemnumber(1, 'month')
ls_ymd		= string(li_year, '0000') + string(li_month, '00') + '01'
of_setparentdate_f(ls_ymd)

li_year		= dw_t.getitemnumber(1, 'year')
li_month	= dw_t.getitemnumber(1, 'month')
ls_ymd		= string(li_year, '0000') + string(li_month, '00') + '01'
of_setparentdate_t(ls_ymd)

Post Close(This)
end subroutine

on fw_w_calendar4mon2.create
this.p_tsync=create p_tsync
this.p_fsync=create p_fsync
this.p_close=create p_close
this.dw_t=create dw_t
this.dw_f=create dw_f
this.Control[]={this.p_tsync,&
this.p_fsync,&
this.p_close,&
this.dw_t,&
this.dw_f}
end on

on fw_w_calendar4mon2.destroy
destroy(this.p_tsync)
destroy(this.p_fsync)
destroy(this.p_close)
destroy(this.dw_t)
destroy(this.dw_f)
end on

event open;istr_calendar = message.powerobjectparm
If not isvalid(istr_calendar) Then
	Messagebox('Notice(fw_w_calendarmon)', '잘못된 달력 오브젝트 호출입니다')
	Return
End If
iw_parent	= istr_calendar.w_obj
If IsValid(istr_calendar.dw_obj) Then
	iwo_parent1	= istr_calendar.dw_obj
	idwobj1		= istr_calendar.anyobj1
	idwobj2		= istr_calendar.anyobj2
End If
If IsValid(istr_calendar.em_obj1) Then iwo_parent1 = istr_calendar.em_obj1
If IsValid(istr_calendar.em_obj2) Then iwo_parent2 = istr_calendar.em_obj2
inv_idle4time = Create fw_n_custtiming
inv_idle4time.Event oue_parentevent( this, "wue_close4calendar")

powerobject	lpo_parent
Long			ll_xpos, ll_ypos

// 부모 컨트롤의 X,Y 좌표를 구합니다.
lpo_parent = iwo_parent1.getparent()
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
Date	ld_date

Choose Case iwo_parent1.typeof()
	Case editmask!
		editmask lem1, lem2
		lem1 = iwo_parent1
		lem2 = iwo_parent2
		
		ll_xpos += lem1.x
		ll_ypos += lem1.y + lem1.height
		
		ls_date = lem1.text + '.01'
		If isdate(ls_date) Then
			If Pos(ls_date, '9999') > 0 Then
				ls_yyyy = String(today(), 'yyyy')
				ls_date = ls_yyyy + mid(ls_date, 5, 6)
			End If
			id_dateselected_f = date(ls_date)
		End If
		ls_date = lem2.text + '.01'
		If isdate(ls_date) Then
			If Pos(ls_date, '9999') > 0 Then
				ls_yyyy = String(today(), 'yyyy')
				ls_date = ls_yyyy + mid(ls_date, 5, 6)
			End If
			id_dateselected_t = date(ls_date)
		End If
	Case datawindow!
		datawindow ldw_parent		
		ldw_parent = iwo_parent1
		If This.of_getload4style(ldw_parent)  = 'freeform' Then
			ll_xpos += ldw_parent.x + Long(idwobj1.x)
			ll_ypos += ldw_parent.y + Long(idwobj1.y) + Long(idwobj1.height) + Pixelstounits(2, YPixelstounits!)
		Else
			ll_xpos += Long(istr_calendar.dw_obj.x) + Long(idwobj1.x) + Long(idwobj1.width) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
			ll_ypos += Long(istr_calendar.dw_obj.y) + (Long(idwobj1.height) / 2) + ldw_parent.pointery()
		End If
		
		Choose Case lower(left(ldw_parent.describe(string(idwobj1.name) + ".ColType"), 5))
			Case "char(", "char"
				ls_date = ldw_parent.getitemstring(istr_calendar.al_row, string(idwobj1.name))
				ls_date = string(ls_Date, '@@@@/@@') + '/01'
				If isdate(ls_date) Then
					If Pos(ls_date, '9999') > 0 Then
						ls_yyyy = String(today(), 'yyyy')
						ls_date = ls_yyyy + mid(ls_date, 5, 6)
					End If
					id_dateselected_f = date(ls_date)
				End If
				ls_date = ldw_parent.getitemstring(istr_calendar.al_row, string(idwobj2.name))
				ls_date = string(ls_Date, '@@@@/@@') + '/01'
				If isdate(ls_date) Then
					If Pos(ls_date, '9999') > 0 Then
						ls_yyyy = String(today(), 'yyyy')
						ls_date = ls_yyyy + mid(ls_date, 5, 6)
					End If
					id_dateselected_t = date(ls_date)
				End If
			Case "date"
				ld_date = ldw_parent.getitemdate(istr_calendar.al_row, string(idwobj1.name))
				If not isnull(ld_date) and ld_date > 1900-01-01 Then
					id_dateselected_f = ld_date
				End If
				ld_date = ldw_parent.getitemdate(istr_calendar.al_row, string(idwobj2.name))
				If not isnull(ld_date) and ld_date > 1900-01-01 Then
					id_dateselected_t = ld_date
				End If
			Case "datet"
				ld_date = date(ldw_parent.getitemdatetime(istr_calendar.al_row, string(idwobj1.name)))
				If not isnull(ld_date) and ld_date > 1900-01-01 Then
					id_dateselected_f = ld_date
				End If
				ld_date = date(ldw_parent.getitemdatetime(istr_calendar.al_row, string(idwobj2.name)))
				If not isnull(ld_date) and ld_date > 1900-01-01 Then
					id_dateselected_t = ld_date
				End If
			Case Else
				messagebox('Notice', '문자 or 날자 타입 컬럼에만 달력 오브젝트를 사용가능 합니다')
				return
		End Choose
End Choose

// 부모 윈도우 크기에 맞게 달력 위치 조정합니다.  - gw_mdi.uo_xpmenu.width
//messagebox(string(ll_xpos + This.width), string(idwobj1.width))
If ll_xpos + This.width > gw_mdi.width Then
	Choose Case iwo_parent1.typeof()
		Case datawindow!
			ll_xpos -= This.width - Long(idwobj1.width)// - PixelsToUnits(1, xPixelsToUnits!)
		Case editmask!
			ll_xpos -= This.width - Long(istr_calendar.em_obj1.width)// - PixelsToUnits(1, xPixelsToUnits!)
	End Choose
End If
// 방향 설정
Integer li_direction
If ll_ypos + This.height > iw_parent.workspaceheight() Then
	ll_ypos -= This.height
End If

This.x = ll_xpos
This.y = ll_ypos

If gnv_vari.getclienttype = 'WEB' Then
	This.width += Pixelstounits(1, Xpixelstounits!)
	This.height -= Pixelstounits(2, YPixelstounits!)
End If

// 일자 설정
If isnull(id_dateselected_f) or id_dateselected_f = 1900-01-01 Then
	id_dateselected_f = today()
	id_dateselected_t = today()
End If

// 달력 DRAW
This.of_drawmonth_f(year(id_dateselected_f), month(id_dateselected_f))
This.of_selectmonth_f(month(id_dateselected_f))
This.of_drawmonth_t(year(id_dateselected_t), month(id_dateselected_t))
This.of_selectmonth_t(month(id_dateselected_t))

dw_f.setredraw(true)
dw_t.setredraw(true)
dw_f.setfocus()

This.Post Event pfe_postopen()
end event

type p_tsync from pf_u_imagebutton within fw_w_calendar4mon2
integer x = 965
integer y = 416
integer width = 96
integer height = 196
string picturename = "..\img\controls\u_icon4btn\btn_calender_to02.jpg"
end type

event clicked;call super::clicked;ib_obj4tsync= true
String		ls_ymd_t
Integer		li_year, li_month
li_year		= dw_t.getitemnumber(1, 'year')
li_month	= dw_t.getitemnumber(1, 'month')
of_drawmonth_f(li_year, li_month)
ls_ymd_t = string(li_year, '0000') + string(li_month, '00') + '01'
of_setparentdate_f(ls_ymd_t)
dw_f.setfocus()
end event

type p_fsync from pf_u_imagebutton within fw_w_calendar4mon2
integer x = 965
integer y = 212
integer width = 96
integer height = 196
string picturename = "..\img\controls\u_icon4btn\btn_calender_from02.jpg"
end type

event clicked;call super::clicked;ib_obj4fsync= true
String		ls_ymd_f
Integer		li_year, li_month
li_year		= dw_f.getitemnumber(1, 'year')
li_month	= dw_f.getitemnumber(1, 'month')
of_drawmonth_t(li_year, li_month)
ls_ymd_f = string(li_year, '0000') + string(li_month, '00') + '01'
of_setparentdate_t(ls_ymd_f)
dw_t.setfocus()
end event

type p_close from pf_u_imagebutton within fw_w_calendar4mon2
integer x = 965
integer y = 8
integer width = 96
integer height = 196
string picturename = "..\img\controls\u_icon4btn\btn_calender_stop02.jpg"
end type

event clicked;call super::clicked;Post Close(Parent)
end event

type dw_t from datawindow within fw_w_calendar4mon2
event ue_dwnkey pbm_dwnkey
integer x = 1056
integer width = 969
integer height = 616
integer taborder = 20
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
		of_movefocusedcolumn_t('right')
	Case KeyLeftArrow!
		of_movefocusedcolumn_t('left')
	Case KeyUpArrow!
		of_movefocusedcolumn_t('up')
	Case KeyDownArrow!
		of_movefocusedcolumn_t('down')
	Case KeyEscape!
		post close(parent)
	Case KeyEnter!
		If is_monthfocused_f <> '' Then
			integer li_year, li_month, li_day
			
			li_year		= this.getitemnumber(this.getrow(), 'year')
			li_month	= this.getitemnumber(this.getrow(), 'month')
			li_day		= 1 //to-be integer(this.getitemstring(this.getrow(), is_getfocused))
			//if isnull(li_day) or li_day = 0 then return
			of_setparentdate_t(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
			Post Close(parent)
		End If
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
	Parent.of_drawmonth_t(li_year, li_month)
	
	Return
End If

// 개별 월 버튼
If left(dwo.name, 7) = 't_month' Then
	li_year	= this.getitemnumber(row, 'year')
	li_month = integer(mid(dwo.name, 8))
	of_selectmonth_t(li_month)
	Parent.of_drawmonth_t(li_year, li_month)
	
	li_year		= this.getitemnumber(row, 'year')
	li_month	= this.getitemnumber(row, 'month')
	li_day		= 1
	
	Return
End If
end event

event doubleclicked;If row = 0 Then return
If is_monthfocused_t = '' Then return
If left(dwo.name, 7) = 't_month' Then
	of_setallsend4month()
End If

//if row = 0 then return
//if is_monthfocused_t = '' then return
//If left(dwo.name, 7) = 't_month' Then
//	integer li_year, li_month, li_day
//	li_year		= this.getitemnumber(row, 'year')
//	li_month	= this.getitemnumber(row, 'month')
//	li_day		= 1
//	
//	of_setparentdate_t(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
//	Post Close(parent)
//End If
end event

event getfocus;ib_obj4dwt	= true
ib_obj4fsync = false
ib_obj4tsync = false
end event

event losefocus;ib_obj4dwt	= false
inv_idle4time.start( ido_idle4time )
end event

type dw_f from datawindow within fw_w_calendar4mon2
event ue_dwnkey pbm_dwnkey
integer width = 969
integer height = 616
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
		of_movefocusedcolumn_f('right')
	Case KeyLeftArrow!
		of_movefocusedcolumn_f('left')
	Case KeyUpArrow!
		of_movefocusedcolumn_f('up')
	Case KeyDownArrow!
		of_movefocusedcolumn_f('down')
	Case KeyEscape!
		post close(parent)
	Case KeyEnter!
		if is_monthfocused_f <> '' then
			integer li_year, li_month, li_day
			
			li_year		= this.getitemnumber(this.getrow(), 'year')
			li_month	= this.getitemnumber(this.getrow(), 'month')
			li_day		= 1 //to-be integer(this.getitemstring(this.getrow(), is_getfocused))
			//if isnull(li_day) or li_day = 0 then return
			of_setparentdate_f(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
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
	Parent.of_drawmonth_f(li_year, li_month)
	
	Return
End If

// 개별 월 버튼
If left(dwo.name, 7) = 't_month' Then
	li_year	= this.getitemnumber(row, 'year')
	li_month = integer(mid(dwo.name, 8))
	of_selectmonth_f(li_month)
	Parent.of_drawmonth_f(li_year, li_month)
	
	li_year		= this.getitemnumber(row, 'year')
	li_month	= this.getitemnumber(row, 'month')
	li_day		= 1
	
	Return
End If
end event

event doubleclicked;If row = 0 Then return
If is_monthfocused_f = '' Then return
If left(dwo.name, 7) = 't_month' Then
	of_setallsend4month()
End If

//if row = 0 then return
//if is_monthfocused_f = '' then return
//If left(dwo.name, 7) = 't_month' Then
//	integer li_year, li_month, li_day
//	li_year		= this.getitemnumber(row, 'year')
//	li_month	= this.getitemnumber(row, 'month')
//	li_day		= 1
//	
//	of_setparentdate_f(string(li_year, '0000') + string(li_month, '00') + string(li_day, '00'))
//	Post Close(parent)
//End If
end event

event getfocus;ib_obj4dwf	= true
ib_obj4fsync = false
ib_obj4tsync = false
end event

event losefocus;ib_obj4dwf	= false
inv_idle4time.start( ido_idle4time )
end event

