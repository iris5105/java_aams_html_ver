forward
global type pf_u_splitbar_vertical from pf_u_statictext
end type
end forward

global type pf_u_splitbar_vertical from pf_u_statictext
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
event oue_split4resize ( )
end type
global pf_u_splitbar_vertical pf_u_splitbar_vertical

type prototypes
Function ulong GetSysColor ( &
	integer nindex &
	) Library "user32.dll"

end prototypes

type variables
protected:
	Window		iw_parent
	Dragobject	idrg_left[]
	Dragobject	idrg_right[]
	long		il_left_gap[]
	long		il_right_gap[]

private:
	PowerObject	ipo_parent
	string	is_profilekey
	string	is_company
	string	is_appname
	boolean	ib_onceopened		= false
	long		il_backcolor_org	= 0

public:
	boolean	i----------------------------------------------------line2	/* empty Object */
	boolean	ib_livesizing		= true
	boolean	ib_autoresize		= true
	boolean	leftmaxsizefixed	= false
	boolean	rightmaxsizefixed	= false
	integer	ii_minrange		= 100
	integer	ii_maxrange		= 100
	string	LeftDragObject
	string	RightDragObject
	integer	ii_LeftMargin	= 0
	integer	ii_RightMargin	= 0
end variables

forward prototypes
public function unsignedlong of_get_syscolor (integer ai_index)
public subroutine of_set_livesizing (boolean ab_flag)
public function window of_get_parentwindow ()
public function string of_getobjectclass ()
public subroutine of_set_leftobject (ref dragobject adrg_left)
public subroutine of_get_location ()
public subroutine of_set_location ()
public subroutine of_arrange_objects ()
public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange)
public subroutine of_set_rightobject (ref dragobject adrg_right)
public function string of_thisname ()
public function integer of_setobjectsbyname (string as_direction, string as_objectnames)
public subroutine of_setresize ()
end prototypes

event mousedown;If UpperBound(idrg_left) = 0  Then Return
If UpperBound(idrg_right) = 0 Then Return

// make sure object stays on top
this.SetPosition(ToTop!)

if ib_autoresize = true then	// 길이 확대.
	long	ll_i, ll_max_h = 0
	FOR ll_i = 1 TO UpperBound(idrg_right)
		if idrg_right[ll_i].height > ll_max_h then ll_max_h = idrg_right[ll_i].height
	NEXT
end if
if il_backcolor_org = 255 then
	// set color to button shadow
	If Not ib_livesizing Then this.BackColor = of_get_syscolor(16)
else
	this.BackColor = il_backcolor_org
end if
end event

event mouseup;of_arrange_objects()
this.post setPosition(ToBottom!)
end event

event oue_split4resize();//pf_n_resize에서 post
if ib_onceopened = false and ib_autoresize = true then
	this.of_setresize()
	ib_onceopened = true
end if
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

Window	lw_window

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

public function string of_getobjectclass ();PowerObject	lpo_parent

String	ls_object

// loop thru parents building object name
lpo_parent = this.GetParent()
ls_object = this.ClassName()
Do While lpo_parent.TypeOf() <> Window! and IsValid (lpo_parent)
	ls_object = lpo_parent.ClassName() + "." + ls_object
	lpo_parent = lpo_parent.GetParent()
Loop

Return ls_object
end function

public subroutine of_set_leftobject (ref dragobject adrg_left);Integer	li_max, li_range

li_max = UpperBound(idrg_left) + 1

// set drag left object
idrg_left[li_max] = adrg_left
if this.x - (adrg_left.x + adrg_left.width) > 0 then
	il_left_gap[li_max] = Long(PixelsToUnits(2, XPixelsToUnits!))
else
	il_left_gap[li_max] = this.x - (adrg_left.x + adrg_left.width)
end if
end subroutine

public subroutine of_get_location ();// this function loads current location from the registry

String	ls_regkey, ls_value
Long		ll_position

ls_regkey  = "HKEY_CURRENT_USER\Software\" + is_company + "\" + is_appname + "\SplitBars"

// set value in registry
RegistryGet(ls_regkey, is_profilekey, RegString!, ls_value)

// move object to prior location
ll_position = Long(ls_value)
If ll_position > 0 Then
	this.X = ll_position
	of_arrange_objects()
End If
end subroutine

public subroutine of_set_location ();// this function saves current location in the registry

String	ls_regkey

ls_regkey  = "HKEY_CURRENT_USER\Software\" + is_company + "\" + is_appname + "\SplitBars"

// set value in registry
RegistrySet(ls_regkey, is_profilekey, String(this.x))
end subroutine

public subroutine of_arrange_objects ();integer	li_cnt, li_max, li_maxsize = 0
long		ll_parentwidth, ll_gapwidth
string	ls_tag

pf_n_hashtable	lnv_opt

If UpperBound(idrg_left) = 0  Then Return
If UpperBound(idrg_right) = 0 Then Return

// resize the left dragobjects
li_max = UpperBound(idrg_left)
for li_cnt = 1 to li_max
	if pos(ipo_parent.classname(), 'tabpage_') > 0 then
		if idrg_left[li_cnt].GetParent() <> ipo_parent then
			if fw_f_settabpage2objsync(ipo_parent, idrg_left[li_cnt]) = -1 then
				messagebox('check', 'object not find')
				return
			end if
		end if
	end if
	// 아래 컨트롤들은 리사이즈 안 함
	choose case idrg_left[li_cnt].typeof()
		case commandbutton!, picturebutton!, picture!, checkbox!
			idrg_left[li_cnt].x = this.x - idrg_left[li_cnt].width - ii_LeftMargin - il_left_gap[li_cnt]
			continue			
		case else
			ls_tag = idrg_left[li_cnt].tag
			if len(ls_tag) > 0 then
				if pf_f_parsetohashtable(ls_tag, ';', lnv_opt) > 0 then
					if lower (lnv_opt.of_get('onVSplitScroll'))='noresize'	Then
						continue
					end if
				end if
			end if
	end choose
	idrg_left[li_cnt].width = this.x - idrg_left[li_cnt].x - PixelstoUnits(2, Xpixelstounits!)
next

// resize the right dragobjects
li_max = UpperBound(idrg_right)
for li_cnt = 1 TO li_max
	if pos(ipo_parent.classname(), 'tabpage_') > 0 then
		if idrg_right[li_cnt].GetParent() <> ipo_parent then
			if fw_f_settabpage2objsync(ipo_parent, idrg_right[li_cnt]) = -1 then
				messagebox('check', 'object not find')
				return
			end if
		end if
	end if
	if li_maxsize = 0 then li_maxsize = (idrg_right[li_cnt].x + idrg_right[li_cnt].width)

	idrg_right[li_cnt].x = this.x + this.width + ii_RightMargin + il_right_gap[li_cnt]

	// 아래 컨트롤들은 리사이즈 안 함
	choose case idrg_right[li_cnt].typeof()
		case commandbutton!, picturebutton!, picture!, checkbox! //, statictext!
			If not(idrg_right[li_cnt].classname() = 'st_mdiclient') Then continue
		case else
			ls_tag = idrg_right[li_cnt].tag
			if len(ls_tag) > 0 then
				if pf_f_parsetohashtable(ls_tag, ';', lnv_opt) > 0 then
					if lower (lnv_opt.of_get('onVSplitScroll'))='noresize'	then
						continue
					end if
				end if
			end if
	end choose
	idrg_right[li_cnt].width = li_maxsize - idrg_right[li_cnt].x
next

if isvalid(iw_parent) and ib_autoresize = true then
	iw_parent.dynamic of_setsplit4position()

	string	ls_key
	dec{4}	ldec_val

	ldec_val = (this.x / gw_mdi.of_getmdiclientwidth()) * 100
	ls_key = 'split.' + is_profilekey + '.x'
	gnv_vari.of_setprofile( ls_key, string(ldec_val) )
end if
end subroutine

public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange);// set minimum size
ii_minrange = ai_minrange
ii_maxrange = ai_maxrange
end subroutine

public subroutine of_set_rightobject (ref dragobject adrg_right);Integer	li_max, li_range

li_max = UpperBound(idrg_right) + 1

// set right drag object
idrg_right[li_max] = adrg_right
if adrg_right.x - (this.x + this.width) < 0 then
	il_right_gap[li_max] = Long(PixelsToUnits(2, XPixelsToUnits!))
else
	il_right_gap[li_max] = adrg_right.x - (this.x + this.width)
end if
end subroutine

public function string of_thisname ();return 'pf_u_splitbar_vertical'

end function

public function integer of_setobjectsbyname (string as_direction, string as_objectnames);// LEFT, RIGHT 오브젝트를 오브젝트 이름으로 등록합니다
// as_direction: left = 왼쪽오브젝트, right=오른쪽 오브젝트 등록
// as_objectnames = 등록할 오브젝트 명(여러개인 경우 ; 로 구분)
// 리턴값: 1=성공, -1=실패

dragobject	lwo_control

string	ls_object[]
integer	li_objcnt, i

if not isvalid(iw_parent) then return 0
if isnull(as_objectnames) then return 0
if as_objectnames = ''    then return 0

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

public subroutine of_setresize ();string	ls_key
long		ll_mdiwidth
dec{4}	ldec_val

if leftmaxsizefixed	then
	// resize the left dragobjects
	if	UpperBound(idrg_left) > 0	then
		if pos(ipo_parent.classname(), 'tabpage_') > 0 then
			if idrg_left[1].GetParent() <> ipo_parent then
				if fw_f_settabpage2objsync(ipo_parent, idrg_left[1]) = -1 then
					messagebox('check', 'object not find')
					return
				end if
			end if
		end if
		this.x = idrg_left [1].dynamic of_getmax4xpos()
		this.of_arrange_objects()
		this.setposition(ToBottom!)
		return
	end if

elseif rightmaxsizefixed	then
	// resize the left dragobjects
	if	UpperBound(idrg_right) > 0	then
		if pos(ipo_parent.classname(), 'tabpage_') > 0 then
			if idrg_right[1].GetParent() <> ipo_parent then
				if fw_f_settabpage2objsync(ipo_parent, idrg_right[1]) = -1 then
					messagebox('check', 'object not find')
					return
				end if
			end if
		end if
		this.x = gw_mdi.of_getmdiclientwidth() - idrg_right[1].dynamic of_getmax4xpos() - 40 //- 132
		this.of_arrange_objects()
		this.setposition(ToBottom!)
		return
	end if
end if

ls_key = 'split.' + is_profilekey + '.x'
ldec_val = dec( gnv_vari.of_getprofile( ls_key, '0' ) )
if ldec_val > 1 and ib_autoresize = true then
	ll_mdiwidth= gw_mdi.of_getmdiclientwidth()
	ldec_val = ll_mdiwidth * (ldec_val / 100)
	if ll_mdiwidth > ldec_val	then
		this.x = ldec_val
		this.of_arrange_objects()
		this.setposition(ToBottom!)
	end if
end if
end subroutine

event constructor;call super::constructor;il_backcolor_org = this.BackColor

Application	la_app

// set identification variables
iw_parent = this.of_get_parentwindow()
ipo_parent = this.GetParent()
is_profilekey = iw_parent.ClassName() + "." + this.of_getobjectclass()

// default appname/company 000
la_app = GetApplication()
is_appname = la_app.AppName
is_company = "My Company"

this.of_setobjectsbyname('left', LeftDragObject)
this.of_setobjectsbyname('right', RightDragObject)
end event

on pf_u_splitbar_vertical.create
call super::create
end on

on pf_u_splitbar_vertical.destroy
call super::destroy
end on

event mousemove;call super::mousemove;Integer	li_pointer, li_minrange, li_maxrange

DragObject	ldrg_parent

// if left button pressed, move object
if KeyDown(keyLeftButton!) then
	// get location of mouse pointer
	if ipo_parent.TypeOf() = Window! then
		li_pointer = iw_parent.PointerX()
	else
		ldrg_parent = ipo_parent
		li_pointer = ldrg_parent.PointerX()
	end if
	// calculate the valid range of movement
	li_maxrange = (idrg_right[1].x + idrg_right[1].width) - ii_maxrange
	// move the splitbar if within the range
	if li_pointer > li_minrange and li_pointer < li_maxrange then
		// move splitbar to mouse location
		this.X = li_pointer
		// resize objects if using livesizing
		if ib_livesizing then of_arrange_objects()
	end if
end if
end event

