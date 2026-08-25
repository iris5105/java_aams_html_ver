forward
global type fw_u_splitbarv4frame from pf_u_statictext
end type
end forward

global type fw_u_splitbarv4frame from pf_u_statictext
integer width = 18
integer height = 900
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "..\img\controls\u_splitbar_vertical\splitv.cur"
long backcolor = 255
boolean scaletobottom = true
event mousedown pbm_lbuttondown
event mouseup pbm_lbuttonup
end type
global fw_u_splitbarv4frame fw_u_splitbarv4frame

type prototypes
Function ulong GetSysColor ( &
	integer nindex &
	) Library "user32.dll"

end prototypes

type variables
protected:
	Window iw_parent
	Dragobject idrg_left[]
	Long il_left_gap[]
	Dragobject idrg_right[]
	Long il_right_gap[]
	
private:
	PowerObject ipo_parent
	String is_company
	String is_appname

public:
	Boolean ib_livesizing
	Integer ii_minrange = 100
	Integer ii_maxrange = 100
	string LeftDragObject
	string RightDragObject
	Integer ii_LeftMargin = 0
	Integer ii_RightMargin = 0

end variables

forward prototypes
public function unsignedlong of_get_syscolor (integer ai_index)
public subroutine of_set_livesizing (boolean ab_flag)
public function window of_get_parentwindow ()
public function string of_get_objectname ()
public subroutine of_set_leftobject (ref dragobject adrg_left)
public subroutine of_arrange_objects ()
public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange)
public subroutine of_set_rightobject (ref dragobject adrg_right)
public function string of_thisname ()
public function integer of_setobjectsbyname (string as_direction, string as_objectnames)
public subroutine of_pf_resize ()
end prototypes

event mousedown;// make sure object stays on top
this.SetPosition(ToTop!)

//// set color to button shadow
//If Not ib_livesizing Then
//	this.BackColor = RGB(255,255,255)//of_get_syscolor(16)
//End If
//
end event

event mouseup;// arrange objects
of_arrange_objects()

//// restore color to match background
//If Not ib_livesizing Then
//	this.BackColor = RGB(255,255,255)
//	//this.BackColor = iw_parent.BackColor
//End If

end event

public function unsignedlong of_get_syscolor (integer ai_index);// These are the argument values
//
//        Object          Value         Object          Value
// --------------------- ------- --------------------- -------
// Scroll Bar Background     0
// Desktop Background        1   Inactive Border          11
// Active Title Bar          2   App Work Space           12
// Inactive Title Bar        3   Highlight                13
// Menu                      4   Highlight Text           14
// Window                    5   Button Face              15
// Window Frame              6   Button Shadow            16
// Menu Text                 7   Gray Text                17
// Window Text               8   Button Text              18
// Title Bar Text            9   Inactive Title Bar Text  19
// Active Border            10   Button Highlight         20

// ToolTip Text             23   ToolTip Background       24

Return GetSysColor(ai_index)

end function

public subroutine of_set_livesizing (boolean ab_flag);// set livesizing flag
ib_livesizing = ab_flag

end subroutine

public function window of_get_parentwindow ();PowerObject	lpo_parent
Window lw_window

// loop thru parents until a window is found
lpo_parent = this.GetParent()
Do While lpo_parent.TypeOf() <> Window! and IsValid (lpo_parent)
	lpo_parent = lpo_parent.GetParent()
Loop

// set return to the window or null if not found
If IsValid (lpo_parent) Then
	lw_window = lpo_parent
Else
	SetNull(lw_window)
End If

Return lw_window

end function

public function string of_get_objectname ();PowerObject	lpo_parent
String ls_object

// loop thru parents building object name
lpo_parent = this.GetParent()
ls_object = this.ClassName()
Do While lpo_parent.TypeOf() <> Window! and IsValid (lpo_parent)
	ls_object = lpo_parent.ClassName() + "." + ls_object
	lpo_parent = lpo_parent.GetParent()
Loop

Return ls_object

end function

public subroutine of_set_leftobject (ref dragobject adrg_left);Integer li_max, li_range

li_max = UpperBound(idrg_left) + 1

// set drag left object
idrg_left[li_max] = adrg_left
il_left_gap[li_max] = this.x - (adrg_left.x + adrg_left.width)

// arrange objects
of_arrange_objects()

end subroutine

public subroutine of_arrange_objects ();Integer li_cnt, li_max, li_maxsize
string ls_tag
pf_n_hashtable lnv_opt

If UpperBound(idrg_left) = 0 Then Return
If UpperBound(idrg_right) = 0 Then Return

iw_parent.SetRedraw(False)

// resize the left dragobjects
li_max = UpperBound(idrg_left)
FOR li_cnt = 1 TO li_max
	// 아래 컨트롤들은 리사이즈 안 함
	choose case idrg_left[li_cnt].typeof()
		case commandbutton!, picturebutton!, picture!, statictext!	
			idrg_left[li_cnt].x = this.x - idrg_left[li_cnt].width - ii_LeftMargin - il_left_gap[li_cnt]
			continue
		case else
			ls_tag = idrg_left[li_cnt].tag
			if len(ls_tag) > 0 then
				if pf_f_parsetohashtable(ls_tag, ';', lnv_opt) > 0 then
					choose case lnv_opt.of_get('onVSplitScroll')
						case 'NoResize', 'noresize', 'noResize'
							continue
					end choose
				end if
			end if
	end choose

	// 왼쪽 여백 추가 2015.4.28
	idrg_left[li_cnt].width = this.x - idrg_left[li_cnt].x - ii_LeftMargin - il_left_gap[li_cnt]
	//idrg_left[li_cnt].width = this.x - idrg_left[li_cnt].x
NEXT

// resize the right dragobjects
li_max = UpperBound(idrg_right)
FOR li_cnt = 1 TO li_max
	li_maxsize = (idrg_right[li_cnt].x + idrg_right[li_cnt].width)

	// 오른쪽 여백 추가 2015.4.28
	idrg_right[li_cnt].x = this.x + this.width + ii_RightMargin + il_right_gap[li_cnt]
	//idrg_right[li_cnt].x = this.x + this.width
	
	// 아래 컨트롤들은 리사이즈 안 함
	choose case idrg_right[li_cnt].typeof()
		case commandbutton!, picturebutton!, picture!, statictext!
			If not(idrg_right[li_cnt].classname() = 'st_mdiclient') Then continue
		case else
			ls_tag = idrg_right[li_cnt].tag
			if len(ls_tag) > 0 then
				if pf_f_parsetohashtable(ls_tag, ';', lnv_opt) > 0 then
					choose case lnv_opt.of_get('onVSplitScroll')
						case 'NoResize', 'noresize', 'noResize'
							continue
					end choose
				end if
			end if
	end choose

	idrg_right[li_cnt].width = li_maxsize - idrg_right[li_cnt].x
NEXT
iw_parent.SetRedraw(True)

end subroutine

public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange);// set minimum size
ii_minrange = ai_minrange
ii_maxrange = ai_maxrange

end subroutine

public subroutine of_set_rightobject (ref dragobject adrg_right);Integer li_max, li_range

li_max = UpperBound(idrg_right) + 1

// set right drag object
idrg_right[li_max] = adrg_right
il_right_gap[li_max] = adrg_right.x - (this.x + this.width)

// arrange objects
of_arrange_objects()

end subroutine

public function string of_thisname ();return 'pf_u_splitbar_vertical2'

end function

public function integer of_setobjectsbyname (string as_direction, string as_objectnames);// LEFT, RIGHT 오브젝트를 오브젝트 이름으로 등록합니다
// as_direction: left = 왼쪽오브젝트, right=오른쪽 오브젝트 등록
// as_objectnames = 등록할 오브젝트 명(여러개인 경우 ; 로 구분)
// 리턴값: 1=성공, -1=실패

dragobject lwo_control
string ls_object[]
integer li_objcnt, i

if not isvalid(iw_parent) then return 0
if isnull(as_objectnames) then return 0
if as_objectnames = '' then return 0

li_objcnt = fw_f_obj2array(as_objectnames, ';', ls_object)
for i = 1 to li_objcnt
	ls_object[i] = trim(ls_object[i])
	if ls_object[i] = '' then continue

	lwo_control = iw_parent.dynamic of_getwindowobjectbyname(ls_object[i])
	if not isvalid(lwo_control) then
		messagebox('[' + this.classname() + '] 알림', '[' + ls_object[i] + '] 오브젝트명을 찾을 수 없습니다')
		return -1
	end if
	
	choose case as_direction
		case 'left'
			this.of_set_leftobject(lwo_control)
		case 'right'
			this.of_set_rightobject(lwo_control)
	end choose
next

return 1

end function

public subroutine of_pf_resize ();//
end subroutine

event constructor;call super::constructor;Application la_app

// set identification variables
iw_parent = this.of_get_parentwindow()
ipo_parent = this.GetParent()
//is_myname = iw_parent.ClassName() + "." + this.of_get_objectname()

// default appname/company
la_app = GetApplication()
is_appname = la_app.AppName
is_company = "My Company"

// auto register predefined object name
this.post of_setobjectsbyname('left', LeftDragObject)
this.post of_setobjectsbyname('right', RightDragObject)

end event

on fw_u_splitbarv4frame.create
call super::create
end on

on fw_u_splitbarv4frame.destroy
call super::destroy
end on

event mousemove;call super::mousemove;Integer li_pointer, li_minrange, li_maxrange
DragObject ldrg_parent

// if left button pressed, move object
If KeyDown(keyLeftButton!) Then
	// get location of mouse pointer
	If ipo_parent.TypeOf() = Window! Then
		li_pointer = iw_parent.PointerX()
	Else
		ldrg_parent = ipo_parent
		li_pointer = ldrg_parent.PointerX()
	End If
	// calculate the valid range of movement
	li_minrange = idrg_left[1].x + ii_minrange
	li_maxrange = (idrg_right[1].x + idrg_right[1].width) - ii_maxrange
	// move the splitbar if within the range
	If li_pointer > li_minrange And li_pointer < li_maxrange Then
		// move splitbar to mouse location
		this.X = li_pointer
		// resize objects if using livesizing
		If ib_livesizing Then
			of_arrange_objects()
		End If
	End If
End If
end event

