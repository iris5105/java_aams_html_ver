forward
global type w_calendar4mon2 from window
end type
type p_tsync from pf_u_imagebutton within w_calendar4mon2
end type
type p_fsync from pf_u_imagebutton within w_calendar4mon2
end type
type p_close from pf_u_imagebutton within w_calendar4mon2
end type
type dw_t from fw_u_dwo within w_calendar4mon2
end type
type dw_f from fw_u_dwo within w_calendar4mon2
end type
end forward

global type w_calendar4mon2 from window
integer width = 2011
integer height = 716
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
boolean toolbarvisible = false
event ue_close ( )
p_tsync p_tsync
p_fsync p_fsync
p_close p_close
dw_t dw_t
dw_f dw_f
end type
global w_calendar4mon2 w_calendar4mon2

type prototypes
FUNCTION boolean AnimateWindow(long lhWnd, long lTm, long lFlags ) library 'user32.dll'
FUNCTION boolean GetCursorPos(REF pf_s_POINT ipPoint) LIBRARY "user32.dll"
FUNCTION boolean ScreenToClient(ulong hWnd, ref pf_s_POINT lpPoint) Library "USER32.DLL"

end prototypes

type variables
Protected:
	fw_n_custtiming	inv_idle4time

	boolean	ib_obj4dwf = false
	boolean	ib_obj4dwt = false
	boolean	ib_doubleclicked = false

Public:
	s_calendar	istr_calendar

	window	iw_parent
	fw_u_dwo	iwo_parent

	INT	ii_year_f, ii_mon_f, ii_year_t, ii_mon_t

	STRING	is_focused_f, is_focused_t
end variables

forward prototypes
public function string of_getload4style (fw_u_dwo ldw_target)
public subroutine of_drawmonth_f ()
public subroutine of_drawmonth_t ()
public subroutine of_setparentdate_f ()
public subroutine of_setparentdate_t ()
public subroutine of_setallsend4date ()
end prototypes

event ue_close();inv_idle4time.stop ()
If ib_obj4dwf = false and ib_obj4dwt = false	Then
	Post Close(this)
End IF
end event

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

public subroutine of_drawmonth_f ();dw_f.modify (is_focused_f+'.color=10485760 ' + is_focused_f + '.font.weight=700')
dw_f.setitem(1, 'year', ii_year_f)
dw_f.setitem(1, 'month', ii_mon_f)
end subroutine

public subroutine of_drawmonth_t ();dw_t.modify (is_focused_t+'.color=10485760 ' + is_focused_t + '.font.weight=700')
dw_t.setitem(1, 'year', ii_year_t)
dw_t.setitem(1, 'month', ii_mon_t)
end subroutine

public subroutine of_setparentdate_f ();IF IsNull(iwo_parent) OR NOT IsValid(iwo_parent) THEN RETURN
IF LEN(TRIM(istr_calendar.as_col1))=0            THEN RETURN

STRING   ls_input

CHOOSE CASE lower (left(iwo_parent.DESCRIBE(istr_calendar.as_col1 + ".ColType"), 5))
   CASE "char(", "char"
      ls_input = string (ii_year_f, '0000') + string (ii_mon_f, '00')
   CASE "date", "datet"
      ls_input = string (ii_year_f, '0000') + '-' + string (ii_mon_f, '00') + '-01'
END CHOOSE

iwo_parent.SETROW (istr_calendar.al_row)
iwo_parent.SetColumn (istr_calendar.as_col1)

iwo_parent.SetText (ls_input)
IF iwo_parent.ACCEPTTEXT( )=-1 THEN RETURN
end subroutine

public subroutine of_setparentdate_t ();IF IsNull(iwo_parent) OR NOT IsValid(iwo_parent) THEN RETURN
IF LEN(TRIM(istr_calendar.as_col2))=0            THEN RETURN

STRING   ls_input

CHOOSE CASE lower (left(iwo_parent.DESCRIBE(istr_calendar.as_col2 + ".ColType"), 5))
   CASE "char(", "char"
      ls_input = string (ii_year_t, '0000') + string (ii_mon_t, '00')
   CASE "date", "datet"
      ls_input = string (ii_year_t, '0000') + '-' + string (ii_mon_t, '00') + '-01'
END CHOOSE

iwo_parent.SETROW (istr_calendar.al_row)
iwo_parent.SetColumn (istr_calendar.as_col2)

iwo_parent.SetText (ls_input)
IF iwo_parent.ACCEPTTEXT( )=-1 THEN RETURN
end subroutine

public subroutine of_setallsend4date ();IF IsNull (iwo_parent) OR NOT IsValid (iwo_parent) THEN RETURN

of_setparentdate_f( )
of_setparentdate_t( )
end subroutine

on w_calendar4mon2.create
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

on w_calendar4mon2.destroy
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
iw_parent = istr_calendar.w_obj
If IsValid(istr_calendar.dw_obj1) THEN iwo_parent	= istr_calendar.dw_obj1

inv_idle4time = Create fw_n_custtiming
inv_idle4time.Event oue_parentevent(this, "ue_close")

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
STRING	ls_year_f, ls_mon_f, ls_year_t, ls_mon_t

If This.of_getload4style(iwo_parent)='freeform'	Then
	If iwo_parent.titlebar = true Then
		ll_ypos += iwo_parent.y + Long(iwo_parent.describe (istr_calendar.as_col1 + ".y")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) + Pixelstounits(27, YPixelstounits!)
		ll_xpos += iwo_parent.x + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Pixelstounits(3, YPixelstounits!)
	Else
		ll_ypos += iwo_parent.y + Long(iwo_parent.describe (istr_calendar.as_col1 + ".y")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) + Pixelstounits(2, YPixelstounits!)
		ll_xpos += iwo_parent.x + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x"))
	End If
Else
	//<임시>
	//add_x = Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
	add_x = Long(istr_calendar.dw_obj1.x) + iwo_parent.pointerx() + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)//Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".width")) - Long(this.width) + Pixelstounits(2, YPixelstounits!)
	IF	ll_xpos + add_x < 0	Then
		ll_xpos += Long(istr_calendar.dw_obj1.x) + Long(iwo_parent.describe (istr_calendar.as_col1 + ".x")) - Pixelstounits(2, XPixelstounits!)
	Else
		ll_xpos += add_x
	End IF
	ll_ypos += Long(istr_calendar.dw_obj1.y) + (Long(iwo_parent.describe (istr_calendar.as_col1 + ".height")) / 2) + iwo_parent.pointery()
End If
// 부모 윈도우 크기에 맞게 달력 위치 조정합니다.  - gw_mdi.uo_xpmenu.width
//messagebox(string(ll_xpos + This.width), string(idwobj1.width))
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
		ls_year_f = LEFT (iwo_parent.getitemstring (istr_calendar.al_row, istr_calendar.as_col1),4)
		ls_mon_f = RIGHT (iwo_parent.getitemstring (istr_calendar.al_row, istr_calendar.as_col1),2)
		ls_year_t = LEFT (iwo_parent.getitemstring (istr_calendar.al_row, istr_calendar.as_col2),4)
		ls_mon_t = RIGHT (iwo_parent.getitemstring (istr_calendar.al_row, istr_calendar.as_col2),2)
	Case "date"
		ls_year_f = string (iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col1),'yyyy')
		ls_mon_f = string (iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col1),'mm')
		ls_year_t = string (iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col2),'yyyy')
		ls_mon_t = string (iwo_parent.getitemdate(istr_calendar.al_row, istr_calendar.as_col2),'mm')
	Case "datet"
		ls_year_f = string (date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col1)),'yyyy')
		ls_mon_f = string (date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col1)),'mm')
		ls_year_t = string (date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col2)),'yyyy')
		ls_mon_t = string (date(iwo_parent.getitemdatetime(istr_calendar.al_row, istr_calendar.as_col2)),'mm')
	Case Else
		messagebox('Notice', '문자 or 날자 타입 컬럼에만 달력 오브젝트를 사용가능 합니다')
		return
End Choose

IF	f_null (ls_year_f)	Then
	ls_year_f = string (today(), 'yyyy')
	ls_mon_f = string (today(), 'mm')
End IF
IF	f_null (ls_year_t)	Then
	ls_year_t = string (today(), 'yyyy')
	ls_mon_t = string (today(), 'mm')
End IF

// 달력 DRAW
ii_year_f = integer (ls_year_f)
ii_mon_f  = integer (ls_mon_f)
ii_year_t = integer (ls_year_t)
ii_mon_t  = integer (ls_mon_t)

dw_f.reset()
dw_t.reset()
dw_f.insertrow(0)
dw_t.insertrow(0)

is_focused_f = 't_month' + string (ii_mon_f)
is_focused_t = 't_month' + string (ii_mon_t)

of_drawmonth_f ()
of_drawmonth_t ()


dw_f.setredraw(true)
dw_t.setredraw(true)

inv_idle4time.start (0.3)
dw_f.POST setfocus ()
end event

event key;inv_idle4time.stop ()
IF	key=KeyEscape! THEN post close (this)
end event

type p_tsync from pf_u_imagebutton within w_calendar4mon2
integer x = 951
integer y = 456
integer width = 96
integer height = 248
string picturename = "..\img\controls\u_icon4btn\btn_calender_to.jpg"
end type

event clicked;call super::clicked;ii_year_f = dw_t.GETITEMNUMBER (1, 'year')
ii_mon_f  = dw_t.GETITEMNUMBER (1, 'month')

of_drawmonth_f ( )

of_setallsend4date ( )

POST CLOSE (Parent)
end event

type p_fsync from pf_u_imagebutton within w_calendar4mon2
integer x = 951
integer y = 204
integer width = 96
integer height = 248
string picturename = "..\img\controls\u_icon4btn\btn_calender_from.jpg"
end type

event clicked;call super::clicked;ii_year_t = dw_f.GETITEMNUMBER (1, 'year')
ii_mon_t  = dw_f.GETITEMNUMBER (1, 'month')

of_drawmonth_t ( )

of_setallsend4date ( )

POST CLOSE (Parent)
end event

type p_close from pf_u_imagebutton within w_calendar4mon2
integer x = 951
integer y = 4
integer width = 96
integer height = 196
string picturename = "..\img\controls\u_icon4btn\btn_calender_stop02.jpg"
end type

event clicked;call super::clicked;Post Close(Parent)
end event

type dw_t from fw_u_dwo within w_calendar4mon2
integer x = 1051
integer width = 969
integer height = 708
integer taborder = 20
string dataobject = "fw_d_calendarmon1"
boolean border = false
end type

event doubleclicked;IF ROW=0 THEN RETURN
IF left(DWO.NAME,3)='t_m'  THEN
   ib_doubleclicked = TRUE
   of_setparentdate_t ( )
   ib_doubleclicked = FALSE
   POST CLOSE (parent)
END IF
end event

event getfocus;ib_obj4dwt = true
end event

event losefocus;IF	ib_doubleclicked=FALSE	Then
	ib_obj4dwt = false
	inv_idle4time.start (0.3)
End IF
end event

event clicked;IF ROW=0       THEN RETURN
IF isnull(DWO) THEN RETURN

dw_t.modify (is_focused_t + '.color=11842740 ' + is_focused_t + '.font.weight=400')

IF left(DWO.NAME,5)='p_pre' OR left(DWO.NAME,6)='p_next' THEN
   Choose CASE DWO.NAME
      CASE 'p_preyear'
         ii_year_t --
      CASE 'p_nextyear'
         ii_year_t ++
   End Choose
   of_drawmonth_t ( )
ELSEIF  DWO.NAME='p_today' THEN
   ii_year_t = integer (string (Today ( ),'yyyy'))
   ii_mon_t  = integer (string (Today ( ),'mm'))
   of_drawmonth_t ( )
ELSE
   // 개별 월 버튼
   IF left(DWO.NAME,7)='t_month' THEN
      ii_mon_t     = integer (mid(DWO.NAME, 8))
      is_focused_t = 't_month' + string (ii_mon_t)
   ELSEIF left(DWO.NAME,4)='t_mb' OR left(DWO.NAME,4)='t_mn'   THEN
      IF left(DWO.NAME,4)='t_mb' THEN
         ii_year_t = this.GETITEMNUMBER (ROW, 'year') - 1
         ii_mon_t  = integer (mid(DWO.NAME, 5))
      ELSE
         ii_year_t = this.GETITEMNUMBER (ROW, 'year') + 1
         ii_mon_t  = integer (mid(DWO.NAME, 5))
      END IF
      of_setparentdate_t ( )
      POST CLOSE (parent)
   END IF
END IF
end event

event oue_keydown;CHOOSE CASE key
   CASE KeyEscape!
      POST CLOSE(parent)
   CASE KeyEnter!
      of_setparentdate_t ()
      POST CLOSE(parent)
END CHOOSE
end event

type dw_f from fw_u_dwo within w_calendar4mon2
integer width = 969
integer height = 708
integer taborder = 10
string dataobject = "fw_d_calendarmon1"
boolean border = false
end type

event doubleclicked;IF ROW=0 THEN RETURN
IF left(DWO.NAME,3)='t_m'  THEN
   ib_doubleclicked = TRUE
   of_setparentdate_f ( )
   ib_doubleclicked = FALSE
   POST CLOSE (parent)
END IF
end event

event getfocus;ib_obj4dwf = true
end event

event losefocus;IF	ib_doubleclicked=FALSE	Then
	ib_obj4dwf = false
	inv_idle4time.start (0.3)
End IF
end event

event clicked;IF ROW=0       THEN RETURN
IF isnull(DWO) THEN RETURN

dw_f.modify (is_focused_f + '.color=11842740 ' + is_focused_f + '.font.weight=400')

IF left(DWO.NAME,5)='p_pre' OR left(DWO.NAME,6)='p_next' THEN
   Choose CASE DWO.NAME
      CASE 'p_preyear'
         ii_year_f --
      CASE 'p_nextyear'
         ii_year_f ++
   End Choose
   of_drawmonth_f ( )
ELSEIF  DWO.NAME='p_today' THEN
   ii_year_f = integer (string (Today ( ),'yyyy'))
   ii_mon_f  = integer (string (Today ( ),'mm'))
   of_drawmonth_f ( )
ELSE
   // 개별 월 버튼
   IF left(DWO.NAME,7)='t_month' THEN
      ii_mon_f     = integer (mid(DWO.NAME, 8))
      is_focused_f = 't_month' + string (ii_mon_f)
      of_drawmonth_f ( )
   ELSEIF left(DWO.NAME,4)='t_mb' OR left(DWO.NAME,4)='t_mn'   THEN
      IF left(DWO.NAME,4)='t_mb' THEN
         ii_year_f = this.GETITEMNUMBER (ROW, 'year') - 1
         ii_mon_f  = integer (mid(DWO.NAME, 5))
      ELSE
         ii_year_f = this.GETITEMNUMBER (ROW, 'year') + 1
         ii_mon_f  = integer (mid(DWO.NAME, 5))
      END IF
      of_setparentdate_f ( )
      POST CLOSE (parent)
   END IF
END IF
end event

event oue_keydown;CHOOSE CASE key
   CASE KeyEscape!
      POST CLOSE(parent)
   CASE KeyEnter!
      of_setparentdate_f ()
      POST CLOSE(parent)
END CHOOSE
end event

