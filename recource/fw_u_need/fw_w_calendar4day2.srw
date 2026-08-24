forward
global type fw_w_calendar4day2 from window
end type
type p_tsync from pf_u_imagebutton within fw_w_calendar4day2
end type
type p_fsync from pf_u_imagebutton within fw_w_calendar4day2
end type
type p_close from pf_u_imagebutton within fw_w_calendar4day2
end type
type dw_t from datawindow within fw_w_calendar4day2
end type
type dw_f from datawindow within fw_w_calendar4day2
end type
end forward

global type fw_w_calendar4day2 from window
integer width = 2011
integer height = 776
windowtype windowtype = child!
long backcolor = 16777215
event wue_postopen ( )
event wue_close4calendar ( )
p_tsync p_tsync
p_fsync p_fsync
p_close p_close
dw_t dw_t
dw_f dw_f
end type
global fw_w_calendar4day2 fw_w_calendar4day2

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
	fw_s_calendar		istr_calendar
	
	window				iw_parent
	windowobject		iwo_parent1, iwo_parent2
	DWObject			idwobj1, idwobj2
	String				is_choosedate_f, is_choosedate_t
	String				is_org4syntax1	= ''
	boolean			ib_org4syntax1	= false
	String				is_org4syntax2	= ''
	boolean			ib_org4syntax2	= false
	Long				il_prevcolor_f	= 0
	Long				il_prevcolor_t	= 0
	Long				il_selectcolor	= RGB(0,0,0)
	date				id_dateselected_f, id_dateselected_t
end variables

forward prototypes
public function string of_getload4style (datawindow ldw_target)
public function integer of_getdaysinmonth_f (integer ai_year, integer ai_month)
public subroutine of_highlightcolumn_f ()
public function integer of_movefocusedcolumn_f (string as_direction)
public function integer of_setparentdate_f (string as_dateselected)
public function integer of_selectdate_f (string as_cell)
public function integer of_selectdate_f (integer ai_day)
public function integer of_getdaysinmonth_t (integer ai_year, integer ai_month)
public function integer of_movefocusedcolumn_t (string as_direction)
public function integer of_selectdate_t (integer ai_day)
public function integer of_selectdate_t (string as_cell)
public function integer of_setparentdate_t (string as_dateselected)
public subroutine of_setallsend4date ()
public subroutine of_drawmonth_t_1sub (integer ai_year, integer ai_month)
public subroutine of_drawmonth_f_1sub (integer ai_year, integer ai_month)
public subroutine of_drawmonth_f (integer ai_year, integer ai_month)
public subroutine of_drawmonth_t (integer ai_year, integer ai_month)
public subroutine of_selectdate_t (integer ai_year, integer ai_month, integer ai_day)
public subroutine of_selectdate_f (integer ai_year, integer ai_month, integer ai_day)
end prototypes

event wue_postopen();// 달력 DRAW
This.of_drawmonth_f(year(id_dateselected_f), month(id_dateselected_f))
Post of_selectdate_f(day(id_dateselected_f))
This.of_drawmonth_t(year(id_dateselected_t), month(id_dateselected_t))
Post of_selectdate_t(day(id_dateselected_t))

dw_f.setfocus()
end event

event wue_close4calendar();inv_idle4time.stop( )
If ib_obj4dwf = false and &
	ib_obj4dwt = false and &
	ib_obj4fsync= false and &
	ib_obj4tsync= false Then Post Close(this)
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

public function integer of_getdaysinmonth_f (integer ai_year, integer ai_month);//

if isnull(ai_year) then return -1
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

public subroutine of_highlightcolumn_f ();
end subroutine

public function integer of_movefocusedcolumn_f (string as_direction);if is_choosedate_f = '' then return -1

integer li_colseq
integer li_year, li_month

li_colseq = integer(mid(is_choosedate_f, 5))

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
		li_year = dw_f.getitemnumber(1, 'year')
		li_month = dw_f.getitemnumber(1, 'month')
		
		li_month --
		if li_month = 0 then
			li_year --
			li_month = 12
		end if
		
		of_drawmonth_f(li_year, li_month)
		li_colseq += 42

	case is > 42
		li_year = dw_f.getitemnumber(1, 'year')
		li_month = dw_f.getitemnumber(1, 'month')
		
		li_month ++
		if li_month > 12 then
			li_year ++
			li_month = 1
		end if
		
		of_drawmonth_f(li_year, li_month)
		li_colseq -= 42
end choose

// deselect
dw_f.modify(is_choosedate_f + ".border=0")
dw_f.modify(is_choosedate_f + ".Font.height='-9'")

// select
is_choosedate_f = 'cell' + string(li_colseq)

dw_f.modify(is_choosedate_f + ".border=4")
dw_f.modify(is_choosedate_f + ".Font.height='-11'")
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

choose case iwo_parent1.typeof()
	case editmask!
		editmask lem_parent
		lem_parent = iwo_parent1
		
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
	case datawindow!
		datawindow ldw_parent
		ldw_parent = iwo_parent1
		
		choose case lower(left(ldw_parent.describe(string(idwobj1.name) + ".ColType"), 5))
			case "char(", "char"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj1.name), as_dateselected)
			case "date", "datet"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj1.name), ld_selected)
			case else
				return -1
		end choose
end choose

return 1

end function

public function integer of_selectdate_f (string as_cell);integer	li_firstdaynum

li_firstdaynum = fw_f_nvll(dw_f.getitemnumber(1, 'firstdaynum'), 0)

// deselect
If is_choosedate_f <> '' Then
	dw_f.modify(is_choosedate_f + ".border=0")
	dw_f.modify(is_choosedate_f + ".Font.height='-9'")
	dw_f.modify(is_choosedate_f + ".Font.Weight='400'")
	dw_f.modify(is_choosedate_f + ".Color='" + String(il_prevcolor_f) + "'")
End If

String	ls_syntax, ls_error
ls_syntax = ''
is_choosedate_f = as_cell
il_prevcolor_f = Long(dw_f.Describe(is_choosedate_f + ".Color"))
ls_syntax += is_choosedate_f + ".border=4~r~n"
ls_syntax += is_choosedate_f + ".Font.height='-11'~r~n"
ls_syntax += is_choosedate_f + ".Font.Weight='700'~r~n"
ls_syntax += is_choosedate_f + ".Color='" + String(il_selectcolor) + "'"

ls_error = dw_f.modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selectdate error1', ls_error)
	Return -1
End If
Return 1
end function

public function integer of_selectdate_f (integer ai_day);integer	li_firstdaynum

li_firstdaynum = dw_f.getitemnumber(1, 'firstdaynum')

// deselect
If is_choosedate_f <> '' Then	
	dw_f.modify(is_choosedate_f + ".border=0")
	dw_f.modify(is_choosedate_f + ".Font.height='-9'")
	dw_f.modify(is_choosedate_f + ".Font.Weight='400'")
	dw_f.modify(is_choosedate_f + ".Color='" + String(il_prevcolor_f) + "'")
End If

String	ls_syntax, ls_error
ls_syntax = ''
is_choosedate_f = 'cell' + string(li_firstdaynum + ai_day - 1)
il_prevcolor_f = Long(dw_f.Describe(is_choosedate_f + ".Color"))
ls_syntax += is_choosedate_f + ".border=4~r~n"
ls_syntax += is_choosedate_f + ".Font.height='-11'~r~n"
ls_syntax += is_choosedate_f + ".Font.Weight='700'~r~n"
ls_syntax += is_choosedate_f + ".Color='" + String(il_selectcolor) + "'"

ls_error = dw_f.modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selectdate error1', ls_error)
	Return -1
End If
Return 1

end function

public function integer of_getdaysinmonth_t (integer ai_year, integer ai_month);if isnull(ai_year) then return -1
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

public function integer of_movefocusedcolumn_t (string as_direction);if is_choosedate_t = '' then return -1

integer li_colseq
integer li_year, li_month

li_colseq = integer(mid(is_choosedate_t, 5))

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
		li_year = dw_t.getitemnumber(1, 'year')
		li_month = dw_t.getitemnumber(1, 'month')
		
		li_month --
		if li_month = 0 then
			li_year --
			li_month = 12
		end if
		
		of_drawmonth_f(li_year, li_month)
		li_colseq += 42

	case is > 42
		li_year = dw_t.getitemnumber(1, 'year')
		li_month = dw_t.getitemnumber(1, 'month')
		
		li_month ++
		if li_month > 12 then
			li_year ++
			li_month = 1
		end if
		
		of_drawmonth_f(li_year, li_month)
		li_colseq -= 42
end choose

// deselect
dw_t.modify(is_choosedate_t + ".border=0")
dw_t.modify(is_choosedate_t + ".Font.height='-9'")

// select
is_choosedate_t = 'cell' + string(li_colseq)

dw_t.modify(is_choosedate_t + ".border=4")
dw_t.modify(is_choosedate_t + ".Font.height='-11'")
dw_t.setredraw(true)

return 0

end function

public function integer of_selectdate_t (integer ai_day);integer	li_firstdaynum

li_firstdaynum = dw_t.getitemnumber(1, 'firstdaynum')

// deselect
If is_choosedate_t <> '' Then	
	dw_t.modify(is_choosedate_t + ".border=0")
	dw_t.modify(is_choosedate_t + ".Font.height='-9'")
	dw_t.modify(is_choosedate_t + ".Font.Weight='400'")
	dw_t.modify(is_choosedate_t + ".Color='" + String(il_prevcolor_t) + "'")
End If

String	ls_syntax, ls_error
ls_syntax = ''
is_choosedate_t = 'cell' + string(li_firstdaynum + ai_day - 1)
il_prevcolor_t = Long(dw_t.Describe(is_choosedate_t + ".Color"))
ls_syntax += is_choosedate_t + ".border=4~r~n"
ls_syntax += is_choosedate_t + ".Font.height='-11'~r~n"
ls_syntax += is_choosedate_t + ".Font.Weight='700'~r~n"
ls_syntax += is_choosedate_t + ".Color='" + String(il_selectcolor) + "'"

ls_error = dw_t.modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selectdate error1', ls_error)
	Return -1
End If
Return 1


end function

public function integer of_selectdate_t (string as_cell);integer	li_firstdaynum

li_firstdaynum = fw_f_nvll(dw_t.getitemnumber(1, 'firstdaynum'), 0)

// deselect
If is_choosedate_t <> '' Then
	dw_t.modify(is_choosedate_t + ".border=0")
	dw_t.modify(is_choosedate_t + ".Font.height='-9'")
	dw_t.modify(is_choosedate_t + ".Font.Weight='400'")
	dw_t.modify(is_choosedate_t + ".Color='" + String(il_prevcolor_t) + "'")
End If

String	ls_syntax, ls_error
ls_syntax = ''
is_choosedate_t = as_cell
il_prevcolor_t = Long(dw_t.Describe(is_choosedate_t + ".Color"))
ls_syntax += is_choosedate_t + ".border=4~r~n"
ls_syntax += is_choosedate_t + ".Font.height='-11'~r~n"
ls_syntax += is_choosedate_t + ".Font.Weight='700'~r~n"
ls_syntax += is_choosedate_t + ".Color='" + String(il_selectcolor) + "'"

ls_error = dw_t.modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selectdate error1', ls_error)
	Return -1
End If
Return 1
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
		editmask lem_parent
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
		
		Choose Case lower(left(ldw_parent.describe(string(idwobj2.name) + ".ColType"), 5))
			Case "char(", "char"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj2.name), as_dateselected)
			Case "date", "datet"
				ldw_parent.setitem(istr_calendar.al_row, string(idwobj2.name), ld_selected)
			Case else
				Return -1
		End Choose
End Choose

Return 1

end function

public subroutine of_setallsend4date ();String		ls_date_f, ls_date_t
ls_date_f = dw_f.describe(is_choosedate_f + ".tag")
ls_date_f = fw_f_replaceall(ls_date_f, '-', '')
	
ls_date_t = dw_t.describe(is_choosedate_t + ".tag")
ls_date_t = fw_f_replaceall(ls_date_t, '-', '')

of_setparentdate_f(ls_date_f)
of_setparentdate_t(ls_date_t)

Post Close(This)
end subroutine

public subroutine of_drawmonth_t_1sub (integer ai_year, integer ai_month);String	ls_syntax1, ls_error
integer	li_daysinmonth, li_empty, li_lastdaynum, i, ll_daynum
date	ld_firstday, ld_today, ld_calday

li_daysinmonth	= of_getdaysinmonth_t(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)
li_empty		= daynumber(ld_firstday)

// save current year & month
dw_t.setitem(1, 'year', ai_year)
dw_t.setitem(1, gnv_extfunc.istr_node4value.cstr09, ai_month)
dw_t.setitem(1, gnv_extfunc.istr_node4value.cstr15, li_empty)

ls_syntax1 = '' //초기화
// setitem cell1 ~ cell42 
For i = 1 to li_daysinmonth
	dw_t.setitem(1, 'cell' + string(i + li_empty - 1), string(i))
	ld_calday = date(ai_year, ai_month,  i)
	ls_syntax1 += 'cell' + string(i + li_empty - 1) + '.tag="' + string(ld_calday, gnv_extfunc.istr_node4value.cstr12) + '"~r~n'
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
		dw_t.setitem(1, 'cell' + string(i), string(ll_fr_num + i))
		ld_today	= RelativeDate(date(ai_year, ai_month, 15), -30)
		ld_today = date(long(string(ld_today, 'yyyy')), long(string(ld_today, 'mm')),  (ll_fr_num + i))
		ls_syntax1 += 'cell' + string(i) + '.tag="' + string(ld_today, gnv_extfunc.istr_node4value.cstr06) + '"~r~n'
		ls_syntax1 += 'cell' + string(i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next
End If

ll_gapnum = 42 - li_daysinmonth - fw_f_nvll(ll_gapnum, 0)
If ll_gapnum > 0 Then
	li_lastdaynum = 42 - ll_gapnum
	for i = 1 to ll_gapnum
		dw_t.setitem(1, 'cell' + string(li_lastdaynum + i), string(i))
		ld_today	= RelativeDate(date(ai_year, ai_month, 15), 30)
		ld_today 	= date(long(string(ld_today, 'yyyy')), long(string(ld_today, 'mm')), i)
		ls_syntax1 += 'cell' + string(li_lastdaynum + i) + '.tag="' + string(ld_today, gnv_extfunc.istr_node4value.cstr12) + '"~r~n'
		ls_syntax1 += 'cell' + string(li_lastdaynum + i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next	
End If

ls_error = dw_t.Modify(ls_syntax1)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax1)
	messagebox('of_drawmonth() error1', ls_error)
	Return
End If

ib_org4syntax2 = true
dw_t.setredraw(true)
end subroutine

public subroutine of_drawmonth_f_1sub (integer ai_year, integer ai_month);String	ls_syntax1, ls_error
integer	li_daysinmonth, li_empty, li_lastdaynum, i, ll_daynum
date	ld_firstday, ld_foday, ld_calday

li_daysinmonth	= of_getdaysinmonth_f(ai_year, ai_month)
ld_firstday		= date(ai_year, ai_month, 1)
li_empty		= daynumber(ld_firstday)

// save current year & month
dw_f.setitem(1, 'year', ai_year)
dw_f.setitem(1, gnv_extfunc.istr_node4value.cstr09, ai_month)
dw_f.setitem(1, gnv_extfunc.istr_node4value.cstr15, li_empty)

ls_syntax1 = '' //초기화
// setitem cell1 ~ cell42 
For i = 1 to li_daysinmonth
	dw_f.setitem(1, 'cell' + string(i + li_empty - 1), string(i))
	ld_calday = date(ai_year, ai_month,  i)
	ls_syntax1 += 'cell' + string(i + li_empty - 1) + '.tag="' + string(ld_calday, gnv_extfunc.istr_node4value.cstr12) + '"~r~n'
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

date	ld_prev_fr, ld_prev_fo
Long	ll_prev_month, ll_gapnum, ll_fr_num
If li_empty > 1 Then
	ll_gapnum		= li_empty - 1
	ld_prev_fr		= relativedate (ld_firstday, -ll_gapnum)
	ld_prev_fo		= relativedate (ld_firstday, -1)
	ll_fr_num		= day (ld_prev_fr) - 1
	ll_prev_month	= month (ld_prev_fr)
	for i = 1 to ll_gapnum
		dw_f.setitem(1, 'cell' + string(i), string(ll_fr_num + i))
		ld_foday = RelativeDate(date(ai_year, ai_month, 15), -30)
		ld_foday = date(long(string(ld_foday, 'yyyy')), long(string(ld_foday, 'mm')),  (ll_fr_num + i))
		ls_syntax1 += 'cell' + string(i) + '.tag="' + string(ld_foday, gnv_extfunc.istr_node4value.cstr06) + '"~r~n'
		ls_syntax1 += 'cell' + string(i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next
End If

ll_gapnum = 42 - li_daysinmonth - fw_f_nvll(ll_gapnum, 0)
If ll_gapnum > 0 Then
	li_lastdaynum = 42 - ll_gapnum
	for i = 1 to ll_gapnum
		dw_f.setitem(1, 'cell' + string(li_lastdaynum + i), string(i))
		ld_foday	= RelativeDate(date(ai_year, ai_month, 15), 30)
		ld_foday 	= date(long(string(ld_foday, 'yyyy')), long(string(ld_foday, 'mm')), i)
		ls_syntax1 += 'cell' + string(li_lastdaynum + i) + '.tag="' + string(ld_foday, gnv_extfunc.istr_node4value.cstr12) + '"~r~n'
		ls_syntax1 += 'cell' + string(li_lastdaynum + i) + '.Color="' + string(rgb(128,128,128)) + '"~r~n'
	next	
End If

ls_error = dw_f.Modify(ls_syntax1)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax1)
	messagebox('of_drawmonth() error1', ls_error)
	Return
End If

ib_org4syntax1 = true
dw_f.setredraw(true)
end subroutine

public subroutine of_drawmonth_f (integer ai_year, integer ai_month);String	ls_syntax1, ls_error, ls_sqlsyntax
String	ls_ymd, ls_week_seq
integer	li_daysinmonth, li_empty, li_lastdaynum, i, ll_daynum
date	ld_firstday, ld_today, ld_calday

dw_f.setredraw(false)
If ib_org4syntax1 = true Then
	dw_f.create(is_org4syntax1, ls_error)
	If len(ls_error) > 0 then
		messagebox('of_drawmonth() org create error', ls_error)
		Return
	End If
End If
dw_f.reset()
dw_f.insertrow(0)

Post of_drawmonth_f_1sub(ai_year, ai_month)
end subroutine

public subroutine of_drawmonth_t (integer ai_year, integer ai_month);String	ls_syntax1, ls_error

dw_t.setredraw(false)
If ib_org4syntax2 = true Then
	dw_t.create(is_org4syntax2, ls_error)
	If len(ls_error) > 0 then
		messagebox('of_drawmonth() org create error', ls_error)
		Return
	End If
End If
dw_t.reset()
dw_t.insertrow(0)

Post of_drawmonth_t_1sub(ai_year, ai_month)
end subroutine

public subroutine of_selectdate_t (integer ai_year, integer ai_month, integer ai_day);integer li_day, li_firstdaynum

if dw_t.rowcount() = 0 then
	this.of_drawmonth_t(ai_year, ai_month)
end if

if dw_t.getitemnumber(1, 'year') <> ai_year or dw_t.getitemnumber(1, 'month') <> ai_month then
	this.of_drawmonth_t(ai_year, ai_month)
end if

Post of_selectdate_t(ai_day)

end subroutine

public subroutine of_selectdate_f (integer ai_year, integer ai_month, integer ai_day);integer li_day, li_firstdaynum

if dw_f.rowcount() = 0 then
	this.of_drawmonth_f(ai_year, ai_month)
end if

if dw_f.getitemnumber(1, 'year') <> ai_year or dw_f.getitemnumber(1, 'month') <> ai_month then
	this.of_drawmonth_f(ai_year, ai_month)
end if

Post of_selectdate_f(ai_day)

end subroutine

on fw_w_calendar4day2.create
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

on fw_w_calendar4day2.destroy
destroy(this.p_tsync)
destroy(this.p_fsync)
destroy(this.p_close)
destroy(this.dw_t)
destroy(this.dw_f)
end on

event open;istr_calendar = message.powerobjectparm
If not isvalid(istr_calendar) Then
	Messagebox('Notice(fw_w_calendarday2)', '잘못된 달력 오브젝트 호출입니다')
	Return
End If

is_org4syntax1 = dw_f.Describe("DataWindow.Syntax")
is_org4syntax2 = dw_t.Describe("DataWindow.Syntax")
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

powerobject		lpo_parent
Long				ll_xpos, ll_ypos
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
String		ls_date, ls_yyyy
Date		ld_date

Choose Case iwo_parent1.typeof()
	Case editmask!
		editmask lem1, lem2
		lem1 = iwo_parent1
		lem2 = iwo_parent2
		
		ll_xpos += lem1.x
		ll_ypos += lem1.y + lem1.height
		
		ls_date = lem1.text
		If isdate(ls_date) Then
			If Pos(ls_date, '9999') > 0 Then
				ls_yyyy = String(today(), 'yyyy')
				ls_date = ls_yyyy + mid(ls_date, 5, 6)
			End If
			id_dateselected_f = date(ls_date)
		End If		
		ls_date = lem2.text
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
			If ldw_parent.titlebar = true Then
				ll_xpos += ldw_parent.x + Long(idwobj1.x) + Pixelstounits(3, YPixelstounits!)
				ll_ypos += ldw_parent.y + Long(idwobj1.y) + Long(idwobj1.height) + Pixelstounits(29, YPixelstounits!)
			Else
				ll_xpos += ldw_parent.x + Long(idwobj1.x)
				ll_ypos += ldw_parent.y + Long(idwobj1.y) + Long(idwobj1.height) + Pixelstounits(2, YPixelstounits!)
			End If
		Else
			ll_xpos += Long(istr_calendar.dw_obj.x) + Long(idwobj1.x) - Pixelstounits(2, XPixelstounits!)
			ll_ypos += Long(istr_calendar.dw_obj.y) + (Long(idwobj1.height) / 2) + ldw_parent.pointery()
		End If
		
		Choose Case lower(left(ldw_parent.describe(string(idwobj1.name) + ".ColType"), 5))
			Case "char(", "char"
				ls_date = ldw_parent.getitemstring(istr_calendar.al_row, string(idwobj1.name))
				ls_date = string(ls_Date, '@@@@/@@/@@')
				If isdate(ls_date) Then
					If Pos(ls_date, '9999') > 0 Then
						ls_yyyy = String(today(), 'yyyy')
						ls_date = ls_yyyy + mid(ls_date, 5, 6)
					End If
					id_dateselected_f = date(ls_date)
				End If
				ls_date = ldw_parent.getitemstring(istr_calendar.al_row, string(idwobj2.name))
				ls_date = string(ls_Date, '@@@@/@@/@@')
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
//messagebox(string(ll_xpos + This.width), string(idwobj.width))
If ll_xpos + This.width > gw_mdi.width Then
	Choose Case iwo_parent1.typeof()
		Case datawindow!
			ll_xpos -= This.width - Long(idwobj1.width)
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

If gnv_vari.getclienttype = 'WEB' Then
	This.width += Pixelstounits(1, Xpixelstounits!)
	This.height -= Pixelstounits(2, YPixelstounits!)
End If	

// 일자 설정
If isnull(id_dateselected_f) or id_dateselected_f = 1900-01-01 Then
	id_dateselected_f = today()
	id_dateselected_t = today()
End If

This.Post Event wue_postopen()
end event

type p_tsync from pf_u_imagebutton within fw_w_calendar4day2
integer x = 951
integer y = 516
integer width = 96
integer height = 248
string picturename = "..\img\controls\u_icon4btn\btn_calender_to.jpg"
end type

event clicked;call super::clicked;ib_obj4tsync= true
integer	li_year, li_month

li_year		= dw_t.getitemnumber(1, 'year')
li_month	= dw_t.getitemnumber(1, 'month')

Parent.of_drawmonth_f(li_year, li_month)
Parent.of_selectdate_f(is_choosedate_t)
dw_f.setfocus()
//≠
end event

type p_fsync from pf_u_imagebutton within fw_w_calendar4day2
integer x = 951
integer y = 260
integer width = 96
integer height = 248
string picturename = "..\img\controls\u_icon4btn\btn_calender_from.jpg"
end type

event clicked;call super::clicked;ib_obj4fsync= true
integer	li_year, li_month

li_year		= dw_f.getitemnumber(1, 'year')
li_month	= dw_f.getitemnumber(1, 'month')

Parent.of_drawmonth_t(li_year, li_month)
Parent.of_selectdate_t(is_choosedate_f)

dw_t.setfocus()
//≠
end event

type p_close from pf_u_imagebutton within fw_w_calendar4day2
integer x = 951
integer y = 4
integer width = 96
integer height = 248
string picturename = "..\img\controls\u_icon4btn\btn_calender_stop.jpg"
end type

event clicked;call super::clicked;Post Close(Parent)
end event

type dw_t from datawindow within fw_w_calendar4day2
event ue_dwnkey pbm_dwnkey
integer x = 1051
integer width = 951
integer height = 760
integer taborder = 10
string dataobject = "fw_d_calendarday1"
boolean border = false
borderstyle borderstyle = stylelowered!
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
		of_movefocusedcolumn_t('right')
	CASE KeyLeftArrow!
		of_movefocusedcolumn_t('left')
	CASE KeyUpArrow!
		of_movefocusedcolumn_t('up')
	CASE KeyDownArrow!
		of_movefocusedcolumn_t('down')
	CASE KeyEscape!
		post close(parent)
	CASE KeyEnter!
		if is_choosedate_t <> '' then
			of_setallsend4date()
//			String		ls_date			
//			ls_date = dw_f.describe(is_choosedate_t + ".tag")
//			ls_date = fw_f_replaceall(ls_date, '-', '')
//			
//			of_setparentdate_t(ls_date)
//			post close(parent)
		end if
END CHOOSE

end event

event clicked;If row = 0 Then return
String	ls_obj
long	ll_monthcnt
integer	li_year, li_month, li_day

ls_obj = string(dwo.name)
If fw_f_nvls(ls_obj, '') = '' Then ls_obj = 'zzzzz'
// 일자 선택
if left(ls_obj, 4) = "cell" Then
	li_day = Long(right(this.describe(ls_obj + ".tag"), 2))
	if li_day > 0 Then
		parent.of_selectdate_t(string(ls_obj))
		Return
	End If
End If

// 이전월, 다음월
If left(ls_obj, 5) = 'p_pre' or left(ls_obj, 6) = 'p_next' Then
	li_year = this.getitemnumber(row, 'year')
	li_month = this.getitemnumber(row, 'month')
	ll_monthcnt = li_year * 12 + li_month

	choose case ls_obj
		case 'p_preyear'
			ll_monthcnt -= 12
		case 'p_premonth'
			ll_monthcnt -= 1
		case 'p_nextyear'
			ll_monthcnt += 12
		case 'p_nextmonth'
			ll_monthcnt += 1
	end choose
	
	ll_monthcnt --
	li_year = truncate(ll_monthcnt / 12, 0)
	li_month = mod(ll_monthcnt, 12) + 1
	parent.of_drawmonth_t(li_year, li_month)
	Return
End If

// 닫기, 오늘, 선택 버튼 추가
choose case ls_obj
	case 't_close'
		post close(parent)
		Return
	case 'p_today'
		date ld_today
		ld_today = Today()
		of_selectdate_t(year(ld_today), month(ld_today), day(ld_today))
		Return
	case 't_select'
		if is_choosedate_t = '' Then return
		String		ls_date			
		ls_date = dw_f.describe(is_choosedate_t + ".tag")
		ls_date = fw_f_replaceall(ls_date, '-', '')
		
		of_setparentdate_t(ls_date)
		Post Close(parent)
		Return
End choose

// 개별 월 버튼
If left(ls_obj, 7) = 't_month' Then
	li_year = this.getitemnumber(row, 'year')
	li_month = integer(mid(ls_obj, 8))
	Parent.of_drawmonth_t(li_year, li_month)
	Return
End If

end event

event doubleclicked;if row = 0 then return
if left(dwo.name, 4) <> 'cell' then return
if is_choosedate_t = '' then return

of_setallsend4date()
end event

event losefocus;// 포커스 잃는 경우 종료
//post close(parent)
ib_obj4dwt	= false
inv_idle4time.start( ido_idle4time )
end event

event getfocus;ib_obj4dwt	= true
ib_obj4fsync = false
ib_obj4tsync = false
end event

type dw_f from datawindow within fw_w_calendar4day2
event ue_dwnkey pbm_dwnkey
integer width = 951
integer height = 760
integer taborder = 10
string dataobject = "fw_d_calendarday1"
boolean border = false
borderstyle borderstyle = stylelowered!
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
		of_movefocusedcolumn_f('right')
	CASE KeyLeftArrow!
		of_movefocusedcolumn_f('left')
	CASE KeyUpArrow!
		of_movefocusedcolumn_f('up')
	CASE KeyDownArrow!
		of_movefocusedcolumn_f('down')
	CASE KeyEscape!
		post close(parent)
	CASE KeyEnter!
		if is_choosedate_f <> '' then
			of_setallsend4date()
//			String		ls_date			
//			ls_date = dw_f.describe(is_choosedate_f + ".tag")
//			ls_date = fw_f_replaceall(ls_date, '-', '')
//			
//			of_setparentdate_f(ls_date)
//			post close(parent)
		end if
END CHOOSE

end event

event clicked;If row = 0 Then return
String	ls_obj
long	ll_monthcnt
integer	li_year, li_month, li_day

ls_obj = string(dwo.name)
If fw_f_nvls(ls_obj, '') = '' Then ls_obj = 'zzzzz'
// 일자 선택
If left(ls_obj, 4) = "cell" Then
	li_day = Long(right(this.describe(ls_obj + ".tag"), 2))
	If li_day > 0 Then
		parent.of_selectdate_f(string(ls_obj))
		return
	End If
End If

// 이전월, 다음월
If left(ls_obj, 5) = 'p_pre' or left(ls_obj, 6) = 'p_next' Then
	li_year = this.getitemnumber(row, 'year')
	li_month = this.getitemnumber(row, 'month')
	ll_monthcnt = li_year * 12 + li_month

	choose Case ls_obj
		Case 'p_preyear'
			ll_monthcnt -= 12
		Case 'p_premonth'
			ll_monthcnt -= 1
		Case 'p_nextyear'
			ll_monthcnt += 12
		Case 'p_nextmonth'
			ll_monthcnt += 1
	End choose
	
	ll_monthcnt --
	li_year = truncate(ll_monthcnt / 12, 0)
	li_month = mod(ll_monthcnt, 12) + 1
	parent.of_drawmonth_f(li_year, li_month)
	Return
End If

// 닫기, 오늘, 선택 버튼 추가
choose Case ls_obj
	Case 't_close'
		post close(parent)
		Return
	Case 'p_today'
		date ld_today
		ld_today = Today()
		of_selectdate_f(year(ld_today), month(ld_today), day(ld_today))
		Return
	Case 't_select'
		If is_choosedate_f = '' Then return
		String		ls_date			
		ls_date = dw_f.describe(is_choosedate_f + ".tag")
		ls_date = fw_f_replaceall(ls_date, '-', '')
		
		of_setparentdate_f(ls_date)
		Post Close(parent)
		Return
End choose

// 개별 월 버튼
If left(ls_obj, 7) = 't_month' Then
	li_year = this.getitemnumber(row, 'year')
	li_month = integer(mid(ls_obj, 8))
	parent.of_drawmonth_f(li_year, li_month)	
	Return
End If

end event

event doubleclicked;if row = 0 then return
if left(dwo.name, 4) <> 'cell' then return
if is_choosedate_f = '' then return

of_setallsend4date() 
end event

event losefocus;// 포커스 잃는 경우 종료
//post close(parent)
ib_obj4dwf	= false
inv_idle4time.start( ido_idle4time )
end event

event getfocus;ib_obj4dwf	= true
ib_obj4fsync = false
ib_obj4tsync = false
end event

