forward
global type w_calendar4mon1 from window
end type
type dw_cal from fw_u_dwo within w_calendar4mon1
end type
end forward

global type w_calendar4mon1 from window
integer width = 960
integer height = 716
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
event pfe_postopen ( )
dw_cal dw_cal
end type
global w_calendar4mon1 w_calendar4mon1

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
s_calendar	istr_calendar

window	iw_parent
fw_u_dwo	iwo_parent

fw_n_animate	inv_dropdown

STRING	is_focused

INT	ii_year, ii_mon

BOOLEAN	ib_doubleclicked=FALSE
end variables

forward prototypes
public function string of_getload4style (fw_u_dwo ldw_target)
public subroutine of_drawmonth ()
public subroutine of_setparentdate ()
end prototypes

public function string of_getload4style (fw_u_dwo ldw_target);// 데이터윈도우 오브젝트의 Presentation Style을 리턴한다

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

public subroutine of_drawmonth ();dw_cal.modify (is_focused+'.color=10485760 ' + is_focused + '.font.weight=700')
dw_cal.setitem(1, 'year', ii_year)
dw_cal.setitem(1, 'month', ii_mon)
end subroutine

public subroutine of_setparentdate ();IF IsNull(iwo_parent) OR NOT IsValid(iwo_parent) THEN RETURN
IF LEN(TRIM(istr_calendar.as_col1))=0            THEN RETURN

STRING   ls_input

CHOOSE CASE lower (left(iwo_parent.DESCRIBE(istr_calendar.as_col1 + ".ColType"), 5))
   CASE "char(", "char"
      ls_input = string (ii_year, '0000') + string (ii_mon, '00')
   CASE "date", "datet"
      ls_input = string (ii_year, '0000') + '-' + string (ii_mon, '00') + '-01'
END CHOOSE

iwo_parent.SETROW (istr_calendar.al_row)
iwo_parent.SetColumn (istr_calendar.as_col1)

iwo_parent.SetText (ls_input)
IF iwo_parent.ACCEPTTEXT( )=-1 THEN RETURN
end subroutine

on w_calendar4mon1.create
this.dw_cal=create dw_cal
this.Control[]={this.dw_cal}
end on

on w_calendar4mon1.destroy
destroy(this.dw_cal)
end on

event open;istr_calendar = message.powerobjectparm
If not isvalid(istr_calendar) Then
	Messagebox('Notice(fw_w_calendarmon)', '잘못된 달력 오브젝트 호출입니다')
	Return
End If
iw_parent = istr_calendar.w_obj
If IsValid(istr_calendar.dw_obj1) THEN iwo_parent = istr_calendar.dw_obj1

powerobject	lpo_parent
tab			ltab
userobject	luo

LONG		ll_xpos, ll_ypos, add_x
STRING	ls_type

// 부모 컨트롤의 X,Y 좌표를 구합니다.
lpo_parent = iwo_parent.getparent()
do while isvalid(lpo_parent)
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
STRING	ls_year, ls_mon

If This.of_getload4style(iwo_parent) = 'freeform'	Then
	If iwo_parent.titlebar = true Then
		ll_ypos += iwo_parent.y + Long(iwo_parent.describe (istr_calendar.as_col1 + ".y")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) + Pixelstounits(27, YPixelstounits!)
		ll_xpos += iwo_parent.x + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Pixelstounits(3, YPixelstounits!)
	Else
		ll_ypos += iwo_parent.y + Long(iwo_parent.describe (istr_calendar.as_col1 + ".y")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) + Pixelstounits(2, YPixelstounits!)
		ll_xpos += iwo_parent.x + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x"))
	End If
Else
	//<임시>
	add_x = Long(istr_calendar.dw_obj1.x) + iwo_parent.pointerx() + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
	//add_x = Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
	IF	ll_xpos + add_x < 0	Then
		ll_xpos += Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) - Pixelstounits(2, XPixelstounits!)
	Else
		ll_xpos += add_x
	End IF
	ll_ypos += Long(istr_calendar.dw_obj1.y) + (Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) / 2) + iwo_parent.pointery()
End If
// 부모 윈도우 크기에 맞게 달력 위치 조정합니다.  - gw_mdi.uo_xpmenu.width
//messagebox(string(ll_xpos + This.width), string(idwobj.width))
//<임시>
//If ll_xpos + This.width > gw_mdi.width THEN ll_xpos -= This.width - Long(iwo_parent.describe (istr_calendar.as_col1 + ".width"))
If ll_xpos + This.width > gw_mdi.width THEN ll_xpos -= Long(iwo_parent.describe (istr_calendar.as_col1 + ".width"))
If ll_ypos + This.height > iw_parent.workspaceheight() Then
	If iwo_parent.titlebar = true Then
		ll_ypos -= (This.height + Pixelstounits(23, YPixelstounits!))
	Else
		ll_ypos -= This.height
	End If
End If
This.x = ll_xpos
This.y = ll_ypos

Choose Case lower(left(iwo_parent.describe(istr_calendar.as_col1 + ".ColType"), 5))
	Case "char(", "char"
		ls_year = LEFT (iwo_parent.getitemstring (istr_calendar.al_row, istr_calendar.as_col1),4)
		ls_mon = RIGHT (iwo_parent.getitemstring (istr_calendar.al_row, istr_calendar.as_col1),2)
	Case "date"
		ls_year = string (iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col1),'yyyy')
		ls_mon = string (iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col1),'mm')
	Case "datet"
		ls_year = string (date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col1)),'yyyy')
		ls_mon = string (date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col1)),'mm')
	Case Else
		messagebox('Notice', '문자 or 날자 타입 컬럼에만 달력 오브젝트를 사용가능 합니다')
		return
End Choose
IF	f_null (ls_year)	Then
	ls_year = string (today(), 'yyyy')
	ls_mon = string (today(), 'mm')
End IF

If Not isvalid(inv_dropdown) Then inv_dropdown = Create fw_n_animate

// 달력 DRAW
ii_year = integer (ls_year)
ii_mon  = integer (ls_mon)
dw_cal.reset()
dw_cal.insertrow(0)
of_drawmonth ()

// 풀다운 형태로 윈도우가 오픈됩니다.
If gnv_vari.getclienttype='PB'	Then
//	This.width	= dw_cal.width + Pixelstounits(1, XPixelstounits!)
//	This.height	= dw_cal.height + Pixelstounits(1, YPixelstounits!)
//	inv_dropdown.of_initialize(This, li_direction)
//	inv_dropdown.of_show()
Else
	// Child 윈도우 사이즈가 파워빌더와 달라 사이즈 저장함(2013R2 기준)
	This.width	= dw_cal.width - Pixelstounits(8, XPixelstounits!)
	This.height	= dw_cal.height - Pixelstounits(9, YPixelstounits!)
End If

is_focused = 't_month' + string (ii_mon)
dw_cal.modify (is_focused+'.color=10485760 ' + is_focused + '.font.weight=700')
dw_cal.setredraw(true)
dw_cal.setfocus()

This.Post Event pfe_postopen()
end event

type dw_cal from fw_u_dwo within w_calendar4mon1
integer width = 951
integer height = 708
integer taborder = 10
string dataobject = "fw_d_calendarmon1"
boolean border = false
end type

event clicked;IF ROW=0     THEN RETURN
IF IsNull(DWO) THEN RETURN

STRING   ls_dwo_name, ls_parent_data

ls_dwo_name = string (DWO.NAME)

dw_cal.Modify (is_focused + '.color=11842740 ' + is_focused + '.font.weight=400')

CHOOSE CASE ls_dwo_name
   CASE 'p_preyear'
      ii_year --
      of_drawmonth ( )

   CASE 'p_nextyear'
      ii_year ++
      of_drawmonth ( )

   CASE 'p_today'
      ii_year = Year (Today( ))
      ii_mon  = Month (Today( ))
      of_drawmonth ( )

   CASE ELSE
      IF Left(ls_dwo_name, 7)='t_month' THEN
         ii_mon     = integer (MID(ls_dwo_name, 8))
         is_focused = 't_month' + string (ii_mon)
         of_drawmonth ( )

      ELSEIF Left(ls_dwo_name, 4)='t_mb' OR Left(ls_dwo_name, 4)='t_mn' THEN
         IF Left(ls_dwo_name, 4)='t_mb' THEN
            ii_year = THIS.GETITEMNUMBER (ROW, 'year') - 1
         ELSE
            ii_year = THIS.GETITEMNUMBER (ROW, 'year') + 1
         END IF

         ii_mon = integer (Mid(ls_dwo_name, 5))
         of_setparentdate( )

         IF IsValid(iwo_parent) THEN
            ls_parent_data = iwo_parent.GETITEMSTRING (istr_calendar.al_row, istr_calendar.as_col1)

            iwo_parent.SETROW (istr_calendar.al_row)
            iwo_parent.SetColumn (istr_calendar.as_col1)
            iwo_parent.SetText (ls_parent_data)
            iwo_parent.ACCEPTTEXT ( )   // ItemChanged 이벤트발생
         END IF

         POST CLOSE (PARENT)
      END IF
END CHOOSE
end event

event doubleclicked;IF ROW=0       THEN RETURN
IF IsNull(DWO) THEN RETURN // 방어 코드 추가

STRING   ls_parent_data

IF Left(String(DWO.NAME), 3)='t_m' THEN
   ib_doubleclicked = TRUE
   of_setparentdate ( )

   IF IsValid(iwo_parent) THEN
      ls_parent_data = iwo_parent.GETITEMSTRING (istr_calendar.al_row, istr_calendar.as_col1)

      iwo_parent.SETROW (istr_calendar.al_row)
      iwo_parent.SetColumn (istr_calendar.as_col1)

      iwo_parent.SetText (ls_parent_data)
      iwo_parent.ACCEPTTEXT( )
   END IF

   ib_doubleclicked = FALSE
   POST CLOSE (PARENT)
END IF
end event

event losefocus;// 포커스 잃는 경우 종료
IF ib_doubleclicked=FALSE THEN Post Close(parent)
end event

event oue_keydown;CHOOSE CASE key
   CASE KeyEscape!
      POST CLOSE(parent)
   CASE KeyEnter!
      of_setparentdate ()
      POST CLOSE(parent)
END CHOOSE
end event

