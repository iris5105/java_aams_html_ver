forward
global type pf_u_splitbar_horizontal from pf_u_statictext
end type
end forward

global type pf_u_splitbar_horizontal from pf_u_statictext
integer width = 901
integer height = 16
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "..\img\controls\u_splitbar_horizontal\splith.cur"
long backcolor = 255
boolean scaletoright = true
event mousedown pbm_lbuttondown
event mouseup pbm_lbuttonup
event oue_split4resize ( )
end type
global pf_u_splitbar_horizontal pf_u_splitbar_horizontal

type prototypes
Function ulong GetSysColor ( &
	integer nindex &
	) Library "user32.dll"

end prototypes

type variables
protected:
	Window		iw_parent
	Dragobject idrg_top[]
	Dragobject idrg_bottom[]
	long	il_top_gap[]
	long	il_bottom_gap[]

private:
	PowerObject	ipo_parent
	string		is_profilekey
	string		is_company
	string		is_appname
	boolean		ib_OnceOpened = false
	Integer		il_min_y = 6000, il_max_y = 0

public:
	boolean	i----------------------------------------------------line2	/* empty Object */
	Boolean	ib_livesizing		= true
	Boolean	ib_autoresize		= true
	Integer	ii_minrange = 100
	Integer	ii_maxrange = 100
	string	TopDragObject
	string	BottomDragObject
	long		il_backcolor_org = 0
	Integer	ii_TopMargin = 0
	Integer	ii_BottomMargin = 0
end variables

forward prototypes
public function unsignedlong of_get_syscolor (integer ai_index)
public subroutine of_set_livesizing (boolean ab_flag)
public function window of_get_parentwindow ()
public function string of_getobjectclass ()
public subroutine of_set_topobject (ref dragobject adrg_top)
public subroutine of_set_bottomobject (ref dragobject adrg_bottom)
public subroutine of_get_location ()
public subroutine of_set_location ()
public subroutine of_arrange_objects ()
public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange)
public function string of_thisname ()
public function integer of_setobjectsbyname (string as_direction, string as_objectnames)
public subroutine of_setresize ()
end prototypes

event mousedown;If UpperBound(idrg_top) = 0 Then Return
If UpperBound(idrg_bottom) = 0 Then Return

// make sure object stays on top
this.SetPosition(ToTop!)

if ib_autoresize = true then	// 길이 확대.
	long	ll_i, ll_max_w = 0
	FOR ll_i = 1 TO UpperBound(idrg_top)
		if idrg_top[ll_i].width > ll_max_w then ll_max_w = idrg_top[ll_i].width
	NEXT
	this.width = ll_max_w + long(PixelstoUnits(2, XPixelstoUnits!))
end if

if il_backcolor_org = 255 then	// set color to button shadow
	If Not ib_livesizing Then this.BackColor = of_get_syscolor(16)
else
	this.BackColor = il_backcolor_org
end if


end event

event mouseup;// arrange objects
of_arrange_objects()

// restore color to match background
if Not ib_livesizing then
	this.BackColor = iw_parent.BackColor
end if

this.SetPosition(ToBottom!)
end event

event oue_split4resize();if ib_OnceOpened = false and ib_autoresize = true then
	this.of_setresize()
	ib_OnceOpened = true	
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

public function string of_getobjectclass ();PowerObject	lpo_parent
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

public subroutine of_set_topobject (ref dragobject adrg_top);Integer 	li_max

li_max = UpperBound(idrg_top) + 1

// set drag top object
idrg_top[li_max] = adrg_top
il_top_gap[li_max] = this.y - (adrg_top.y + adrg_top.height)

end subroutine

public subroutine of_set_bottomobject (ref dragobject adrg_bottom);Integer li_max

li_max = UpperBound(idrg_bottom) + 1

// set bottom drag object
idrg_bottom[li_max] = adrg_bottom
if adrg_bottom.y - (this.y + this.height) < 0 OR pos(ipo_parent.classname(), 'tabpage_') > 0 then
	il_bottom_gap[li_max] = Long(PixelsToUnits(2, YPixelsToUnits!))
else	
	il_bottom_gap[li_max] = adrg_bottom.y - (this.y + this.height)
end if
end subroutine

public subroutine of_get_location ();// this function loads current location from the registry

String ls_regkey, ls_value
Long ll_position

ls_regkey  = "HKEY_CURRENT_USER\Software\" + is_company + "\" + is_appname + "\SplitBars"

// set value in registry
RegistryGet(ls_regkey, is_profilekey, RegString!, ls_value)

// move object to prior location
ll_position = Long(ls_value)
If ll_position > 0 Then
	this.Y = ll_position
	of_arrange_objects()
End If

end subroutine

public subroutine of_set_location ();// this function saves current location in the registry

String ls_regkey

ls_regkey  = "HKEY_CURRENT_USER\Software\" + is_company + "\" + is_appname + "\SplitBars"

// set value in registry
RegistrySet(ls_regkey, is_profilekey, String(this.y))

end subroutine

public subroutine of_arrange_objects ();string	ls_tag
Integer	li_cnt, li_max, li_maxsize, li_dw_h
long		ll_dwheightminus1value

pf_n_hashtable	lnv_opt

If UpperBound(idrg_top) = 0    Then Return
If UpperBound(idrg_bottom) = 0 Then Return

// resize the top dragobjects
li_max = UpperBound(idrg_top)
for li_cnt = 1 to li_max
	if pos(ipo_parent.classname(), 'tabpage_') > 0 then
		if idrg_top[li_cnt].GetParent() <> ipo_parent then
			if fw_f_settabpage2objsync(ipo_parent, idrg_top[li_cnt]) = -1 then
				messagebox('check', 'object not find')
				return
			end if
		end if
	end if
	// 아래 컨트롤들은 리사이즈 안 함
	choose case idrg_top[li_cnt].typeof()
		case commandbutton!, picturebutton!, picture!
			idrg_top[li_cnt].y = idrg_top[li_cnt].y - This.y - PixelstoUnits(2, Ypixelstounits!)
			continue
		case else
			ls_tag = idrg_top[li_cnt].tag
			if len(ls_tag) > 0 then
				if pf_f_parsetohashtable(ls_tag, ';', lnv_opt) > 0 then
					if lower (lnv_opt.of_get('onHSplitScroll'))='noresize'	then
						continue
					end if
				end if
			end if
	end choose
	idrg_top[li_cnt].height = This.y - idrg_top[li_cnt].y - PixelstoUnits(2, Ypixelstounits!)
next

// resize the bottom dragobjects
li_max = UpperBound(idrg_bottom)
for li_cnt = 1 to li_max
	if pos(ipo_parent.classname(), 'tabpage_') > 0 then
		if idrg_bottom[li_cnt].GetParent() <> ipo_parent then
			if fw_f_settabpage2objsync(ipo_parent, idrg_bottom[li_cnt]) = -1 then
				messagebox('check', 'object not find')
				return
			end if
		end if
	end if
	li_maxsize = (idrg_bottom[li_cnt].y + idrg_bottom[li_cnt].height)
	// 아래 컨트롤들은 리사이즈 안 함
	choose case idrg_bottom[li_cnt].typeof()
		case commandbutton!, picturebutton!, picture!
			continue
		case datawindow!
			if idrg_bottom [li_cnt].TriggerEvent('oue_components') <> 1 then continue
			ll_dwheightminus1value =  idrg_bottom[li_cnt].dynamic of_dwheightminus1value()
		case else
			ls_tag = idrg_bottom[li_cnt].tag
			if len(ls_tag) > 0 then
				if pf_f_parsetohashtable(ls_tag, ';', lnv_opt) > 0 then
					if lower (lnv_opt.of_get('onHSplitScroll'))='noresize'	then
						continue
					end if
				end if
			end if
	end choose
	idrg_bottom[li_cnt].y = this.y + this.height + ii_BottomMargin + il_bottom_gap[li_cnt] + ll_dwheightminus1value
	idrg_bottom[li_cnt].height = li_maxsize - idrg_bottom[li_cnt].y
next

if isvalid(iw_parent) and ib_autoresize = true then
	iw_parent.dynamic of_setsplit4position()

	string	ls_key
	dec{4}	ldec_val	

	ldec_val = (this.y / gw_mdi.of_getmdiclientheight()) * 100
	ls_key = 'split.' + is_profilekey + '.y'
	gnv_vari.of_setprofile( ls_key, string(ldec_val) )
end if
end subroutine

public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange);// set minimum size
ii_minrange = ai_minrange
ii_maxrange = ai_maxrange

end subroutine

public function string of_thisname ();return 'pf_u_splitbar_horizontal'

end function

public function integer of_setobjectsbyname (string as_direction, string as_objectnames);// TOP, BOTTOM 오브젝트를 오브젝트 이름으로 등록합니다
// as_direction: top = 위쪽 오브젝트, bottom=아래쪽 오브젝트 등록
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
		case 'top'
			if il_min_y > lwo_control.y then il_min_y = lwo_control.y
			this.of_set_topobject(lwo_control)
			
		case 'bottom'
			if il_max_y < (lwo_control.y + lwo_control.height) then il_max_y = (lwo_control.y + lwo_control.height)
			this.of_set_bottomobject(lwo_control)
	end choose
next

return 1

end function

public subroutine of_setresize ();long	ll_mdiheight
long	ll_i, ll_max_w = 0
dec{4}	ldec_val

ldec_val = dec(gnv_vari.of_getprofile ('split.' + is_profilekey + '.y', '0'))

if ldec_val > 1 and ib_autoresize = true then
	for ll_i = 1 to UpperBound(idrg_top)
		if idrg_top[ll_i].width>ll_max_w then ll_max_w = idrg_top[ll_i].width
	next
	this.width = ll_max_w + long(PixelstoUnits(2, XPixelstoUnits!))
	
	ll_mdiheight= gw_mdi.of_getmdiclientheight()
	ldec_val = ll_mdiheight * (ldec_val / 100)
	if ll_mdiheight > ldec_val then
		this.y = ldec_val
		this.of_arrange_objects()
		this.setposition(ToBottom!)
	end if
else	
	this.of_arrange_objects()
	this.setposition(ToBottom!)
end if
end subroutine

event constructor;call super::constructor;il_backcolor_org = this.BackColor
Application la_app

// set identification variables
iw_parent = this.of_get_parentwindow()
ipo_parent = this.GetParent()
is_profilekey = iw_parent.ClassName() + "." + this.of_getobjectclass()

// default appname/company ---
la_app = GetApplication()
is_appname = la_app.AppName
is_company = "My Company"

this.of_setobjectsbyname('top', TopDragObject)
this.of_setobjectsbyname('bottom', BottomDragObject)

end event

on pf_u_splitbar_horizontal.create
call super::create
end on

on pf_u_splitbar_horizontal.destroy
call super::destroy
end on

event mousemove;call super::mousemove;Integer li_pointer, li_minrange, li_maxrange

DragObject ldrg_parent

// if left button pressed, move object
if KeyDown(keyLeftButton!) then
	// get location of mouse pointer
	if ipo_parent.TypeOf() = Window! then
		li_pointer = iw_parent.PointerY()
		li_maxrange = iw_parent.height
	Else
		ldrg_parent = ipo_parent
		li_pointer = ldrg_parent.PointerY()
		li_maxrange = ldrg_parent.height
	end if
	li_minrange = idrg_top[1].y + ii_minrange
//	// move the splitbar if within the range
	if li_pointer > li_minrange and li_pointer < li_maxrange then
//		 move splitbar to mouse location
		this.Y = li_pointer
//		 resize objects if using livesizing
		if ib_livesizing then
			of_arrange_objects()
		end if
	end if
end if

end event

