forward
global type fw_n_style from n_ancestor
end type
end forward

global type fw_n_style from n_ancestor
event clicked pbm_dwnlbuttonclk
event resize pbm_dwnresize
event rowfocuschanged pbm_dwnrowchange
event rowfocuschanging pbm_dwnrowchanging
event itemchanged pbm_dwnitemchange
event itemerror pbm_dwnitemvalidationerror
event itemfocuschanged pbm_dwnitemchangefocus
event losefocus pbm_dwnkillfocus
event getfocus pbm_dwnsetfocus
event rbuttondown pbm_dwnrbuttondown
event columnmove pbm_dwnmousemove
event move pbm_move
event oue_mouseleave ( )
event oue_mouseover ( long al_row,  dwobject ao_dwo )
event oue_clicked ( string as_obj,  string as_objtype,  long al_row,  long al_xpos,  long al_ypos )
end type
global fw_n_style fw_n_style

type variables
protected:
	fw_n_handle		inv_handle
	fw_u_dwo			idw_target
	graphicobject		igo_parent
	window				iw_parent
	windowobject		iwo_parent
	
	//column name variable
	string		isobjects[], isrect2obj[]
	string		setheaderbandimage = '' //'..\img\datawindow\img4header1st.jpg'
	//sort column variable
	string		is_sort4colnm[]
	long		il_sort4colcnt
	long		il_sort4col2xpos[], il_sort4col2width[]
	// instance for border
	pf_u_statictext iln_top
	pf_u_statictext iln_bottom
	pf_u_statictext iln_left
	pf_u_statictext iln_right
	Long	il_borderhndl[4]
	
public:
	string		isasissyntax4style	= ''
	string		isdesignstyle		= ''
	
	Long		il_headerheight	= 0
	Long		il_detailheight	= 0			/* freeform, cond */
	
	string		islistfontpointexpression		= ''
	string		islistrowpointexpression1st	= ''
	string		islistrowpointexpression2nd	= ''
	string		islist4mouseovercolor		= ''
	long		MouseOverRowColor		= RGB(230,226,220)
	
	boolean	setlist4backcolorgb			= False
	Long		setlist4backcolor			= 0
	boolean	setlist4headercolorgb		= False
	Long		setlist4headercolor			= 0
	boolean	setlist4summarycolorgb		= False
	Long		setlist4summarycolor		= 0
	boolean	setlist4footercolorgb		= False
	Long		setlist4footercolor			= 0
	boolean	setlist4goupcolor1gb		= False
	Long		setlist4goupcolor1			= 0
	boolean	setlist4goupcolor2gb		= False
	Long		setlist4goupcolor2			= 0

	string		setgroupcolorsyntax1		= ''				/* Group Band BackGround Color syntax 1   variable 등록 */
	string		setgroupcolorsyntax2		= ''				/* Group Band BackGround Color syntax 2  variable 등록 */
end variables

forward prototypes
public function integer of_applydesign ()
public function string of_thisname ()
public function integer of_drawcustomborder ()
public function boolean of_modify (pf_n_syntaxbuffer anv_syntax)
public function long of_getdwomaxwidth ()
public function string of_getinnersyntax (string as_syntax)
public function string of_fixescapechar (string as_syntax)
public function string of_getexpvalue (string as_exp, long al_row)
public function integer of_resetdwdisplayorder (string as_classname)
public function string of_getlastobject (string as_band)
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
public subroutine of_move (long xpos, long ypos)
public subroutine of_drawborderpos ()
public subroutine of_destructorcustomborder ()
public subroutine of_setborderfocuscolor (boolean ab_boolean)
public function string of_getedityokenbycolor ()
public subroutine of_setlist4backcolor (string as_setlist4backcolor)
public subroutine of_setlist4summarycolor (string as_setlist4summarycolor)
public subroutine of_setlist4footercolor (string as_setlist4footercolor)
public subroutine of_setlist4goupcolor1 (string as_setlist4goupcolor1)
public subroutine of_setlist4goupcolor2 (string as_setlist4goupcolor2)
public subroutine of_setlist4headercolor (string as_setlist4headercolor)
public function string of_setlist4goupcolorsyntax ()
public subroutine of_setlist4rowpointcolor (string as_setlist4rowpointcolor)
public subroutine of_initialize (readonly fw_u_dwo adw_datawindow, window aw_parent, fw_n_handle anv_dwbyhandle)
public function string of_setlist4edittoken (string as_obj, string as_objtype, string as_editstyle, integer al_revise)
public subroutine of_setlist4fontpointcolor (string as_setlist4fontpointcolor)
public function string of_setobj4fontpointcolor (string as_obj, string as_objtype)
public function string of_setrectline4design_1sub (string as_syntax, long al_st4pos)
public function string of_setrectline4design (string as_newcel[], long al_cellcnt)
public function string of_setobj4bgcolor_syntax (string as_obj, string as_objtype)
public subroutine of_drawbordervisible (boolean ab_visible)
public function string of_setobj4bgcolor (string as_obj, string as_objtype, string as_band)
public function string of_setetc2syntax (string as_obj)
public function string of_setlist4bandfontcolor (string as_obj, string as_band, string as_objtype)
public function string of_sethd4syntax2filter (string as_createsyntax)
public function string of_sethd4syntax2effect (string as_createsyntax)
public function string of_sethd4syntax2sort (string as_createsyntax)
public function string of_sethd4syntax2filter_1sub (string as_modifysyntax, boolean ab_tooltip)
public function string of_sethd4syntax2sort_1sub (string as_modifysyntax, boolean ab_tooltip)
public function string of_setlist4alrowcolor (string as_syntax)
end prototypes

event clicked;// Clicked Event
end event

event resize;// Resize Event
end event

event rowfocuschanged;// RowFocuschanged Event
end event

event rowfocuschanging;// RowFocusChanging Event
end event

event itemchanged;// ItemChanged Event
end event

event itemerror;// itemError Event
end event

event losefocus;// losefocus Event
end event

event getfocus;// getFocus Event
end event

event rbuttondown;// rbuttondown Event
end event

event columnmove;// ColumnMove
end event

event move;// move event
end event

event oue_clicked(string as_obj, string as_objtype, long al_row, long al_xpos, long al_ypos);//
end event

public function integer of_applydesign ();return 0
end function

public function string of_thisname ();return 'fw_n_style'
end function

public function integer of_drawcustomborder ();// backup message object before OpenUserObject()
message lm_backup
lm_backup = create message
lm_backup.Handle = message.Handle
lm_backup.Number = message.Number
lm_backup.WordParm = message.WordParm
lm_backup.LongParm = message.LongParm
lm_backup.DoubleParm = message.DoubleParm
lm_backup.StringParm = message.StringParm
lm_backup.PowerObjectParm = message.PowerObjectParm
lm_backup.Processed = message.Processed
lm_backup.ReturnValue = message.ReturnValue

long ll_x, ll_y
long ll_width, ll_height

// top line
If not isvalid(iln_top) Then
	If idw_target.border = True Then
		ll_x = idw_target.x
		ll_y = idw_target.y
		ll_width = idw_target.width
		ll_height = PixelsToUnits(1, YPixelsToUnits!)
	Else
		ll_x = idw_target.x - PixelsToUnits(1, XPixelsToUnits!)
		ll_y = idw_target.y - PixelsToUnits(1, YPixelsToUnits!)
		ll_width = idw_target.width + PixelsToUnits(2, XPixelsToUnits!)
		ll_height = PixelsToUnits(1, YPixelsToUnits!)
	End If
	
	If iw_parent.openuserobject(iln_top, ll_x, ll_y) = 1 Then
		iln_top.width		= ll_width
		iln_top.height		= ll_height
		iln_top.backcolor	= gnv_vari.bordernor2topcolor
	End If
End If

If igo_parent.typeof() = userobject! Then
	il_borderhndl[1] = gnv_extfunc.getparent(handle(iln_top))
	gnv_extfunc.setparent(handle(iln_top), handle(igo_parent))
End If

// bottom line
If not isvalid(iln_bottom) Then
	If idw_target.border = True Then
		ll_x = idw_target.x
		ll_y = idw_target.y + idw_target.height - PixelsToUnits(1, YPixelsToUnits!)
		ll_width = idw_target.width
		ll_height = PixelsToUnits(1, YPixelsToUnits!)
	Else
		ll_x = idw_target.x - PixelsToUnits(1, XPixelsToUnits!)
		ll_y = idw_target.y + idw_target.height
		ll_width = idw_target.width + PixelsToUnits(2, XPixelsToUnits!)
		ll_height = PixelsToUnits(1, YPixelsToUnits!)
	End If
	
	If iw_parent.openuserobject(iln_bottom, ll_x, ll_y) = 1 Then
		iln_bottom.width = ll_width
		iln_bottom.height = ll_height
		iln_bottom.backcolor = gnv_vari.bordernor2bottomcolor
	End If
End If

If igo_parent.typeof() = userobject! Then
	il_borderhndl[2] = gnv_extfunc.getparent(handle(iln_bottom))
	gnv_extfunc.setparent(handle(iln_bottom), handle(igo_parent))
End If

// left line
If not isvalid(iln_left) Then
	If idw_target.border = True Then
		ll_x = idw_target.x
		ll_y = idw_target.y
		ll_width	= PixelsToUnits(1, XPixelsToUnits!)
		ll_height	= idw_target.height
	Else
		ll_x = idw_target.x - PixelsToUnits(1, XPixelsToUnits!)
		ll_y = idw_target.y - PixelsToUnits(1, YPixelsToUnits!)
		ll_width	= PixelsToUnits(1, XPixelsToUnits!)
		ll_height	= idw_target.height + PixelsToUnits(2, YPixelsToUnits!)
	End If
	
	If iw_parent.OpenUserObject(iln_left, ll_x, ll_y) = 1 Then
		iln_left.width	= ll_width
		iln_left.height	= ll_height
		iln_left.backcolor = gnv_vari.bordernor2leftcolor
	End If
End If

If igo_parent.typeof() = userobject! Then
	il_borderhndl[3] = gnv_extfunc.getparent(handle(iln_left))
	gnv_extfunc.setparent(handle(iln_left), handle(igo_parent))
End If

// right line
If not isvalid(iln_right) Then
	If idw_target.border = True Then
		ll_x = idw_target.x + idw_target.width - PixelsToUnits(1, XPixelsToUnits!)
		ll_y = idw_target.y
		ll_width	= PixelsToUnits(1, XPixelsToUnits!)
		ll_height	= idw_target.height
	Else
		ll_x = idw_target.x + idw_target.width
		ll_y = idw_target.y - PixelsToUnits(1, YPixelsToUnits!)
		ll_width	= PixelsToUnits(1, XPixelsToUnits!)
		ll_height	= idw_target.height + PixelsToUnits(2, YPixelsToUnits!)
	End If

	If iw_parent.OpenUserObject(iln_right, ll_x, ll_y) = 1 Then
		iln_right.width	= ll_width
		iln_right.height	= ll_height
		iln_right.backcolor = gnv_vari.bordernor2rightcolor
	End If	
End If

If igo_parent.typeof() = userobject! Then
	il_borderhndl[4] = gnv_extfunc.getparent(handle(iln_right))
	gnv_extfunc.setparent(handle(iln_right), handle(igo_parent))
End If

// restore message object
message.Handle = lm_backup.Handle
message.Number = lm_backup.Number
message.WordParm = lm_backup.WordParm
message.LongParm = lm_backup.LongParm
message.DoubleParm = lm_backup.DoubleParm
message.StringParm = lm_backup.StringParm
message.PowerObjectParm = lm_backup.PowerObjectParm
message.Processed = lm_backup.Processed
message.ReturnValue = lm_backup.ReturnValue

iln_top.visible		= idw_target.visible
iln_bottom.visible	= idw_target.visible
iln_left.visible		= idw_target.visible
iln_right.visible		= idw_target.visible

This.Post of_drawborderpos() /* to-be */

If idw_target.border = True Then
	idw_target.border = False
	idw_target.x += PixelsToUnits(1, XPixelsToUnits!)
	idw_target.y += PixelsToUnits(1, YPixelsToUnits!)
	idw_target.width -= PixelsToUnits(2, XPixelsToUnits!)
	idw_target.height -= PixelsToUnits(2, YPixelsToUnits!)
End If

return 1

end function

public function boolean of_modify (pf_n_syntaxbuffer anv_syntax);string ls_error

ls_error = idw_target.Modify(anv_syntax.of_toString())
if len(ls_error) > 0 then
	::clipboard(idw_target.classname() + "~r~n" + anv_syntax.of_toString())
	messagebox("Error", idw_target.classname() + " Syntax Modification Failure!! : " + ls_error)
	return false
end if

return true
end function

public function long of_getdwomaxwidth ();string ls_object, ls_objarr[]
long i, ll_objcnt
long ll_objpos, ll_maxpos

ls_object = idw_target.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	if ls_objarr[i] = 'p_header_bg' then continue
	if idw_target.describe(ls_objarr[i] + ".Band") = 'header' then
		if idw_target.describe(ls_objarr[i] + ".Visible") = '1' then
			ll_objpos = long(idw_target.describe(ls_objarr[i] + ".X")) + long(idw_target.describe(ls_objarr[i] + ".Width"))
			if ll_maxpos < ll_objpos then
				ll_maxpos = ll_objpos
			end if
		end if
	end if
next

return ll_maxpos
end function

public function string of_getinnersyntax (string as_syntax);long ll_pos
string ls_searchstr[] = { '"', '~"', '~~~"', '~~~~~"', '~~~~~~~~"', '~~~~~~~~~~"', '~~~~~~~~~~~~"', '~~~~~~~~~~~~~~"' }
integer i

// replace double quotation.
for i = 7 to 1 step -1
	ll_pos = pos(as_syntax, ls_searchstr[i])
	do while ll_pos > 0
		as_syntax = replace(as_syntax, ll_pos, len(ls_searchstr[i]), ls_searchstr[i + 1])
		ll_pos = pos(as_syntax, ls_searchstr[i], ll_pos + len(ls_searchstr[i + 1]))
	loop
next

return as_syntax
end function

public function string of_fixescapechar (string as_syntax);long ll_pos
string ls_tilde = "~~"

// double quotation
ll_pos = pos(as_syntax, ls_tilde + ls_tilde + '"')
do while ll_pos > 0
	as_syntax = replace(as_syntax, ll_pos, 3, ls_tilde + ls_tilde + ls_tilde + '"')
	ll_pos = pos(as_syntax, ls_tilde + ls_tilde + '"', ll_pos + 4)
loop

// single quotation
ll_pos = pos(as_syntax, ls_tilde + ls_tilde + "'")
do while ll_pos > 0
	as_syntax = replace(as_syntax, ll_pos, 3, ls_tilde + ls_tilde + ls_tilde + "'")
	ll_pos = pos(as_syntax, ls_tilde + ls_tilde + "'", ll_pos + 4)
loop

return as_syntax
end function

public function string of_getexpvalue (string as_exp, long al_row);string ls_quote = '"', ls_exp

if not isvalid(idw_target) then return ''
if pos(as_exp, '"') > 0 then ls_quote = "'"
ls_exp = 'evaluate(' + ls_quote + as_exp + ls_quote + ',' + string(al_row) + ')'

return string(idw_target.describe(ls_exp))
end function

public function integer of_resetdwdisplayorder (string as_classname);// 윈도우 컨트롤 Display Order를 다시 설정한다
if not isvalid(iw_parent) then return -1

long ll_ctrlcnt
integer i, j
dragobject ldo_upper, ldo_lower, ldo_totop

ll_ctrlcnt = upperbound(iw_parent.control)
for i = 1 to ll_ctrlcnt
	choose case iw_parent.control[i].typeof()
		case line!, oval!, rectangle!, roundrectangle!
			continue
		case else
			ldo_upper = iw_parent.control[i]
	end choose
next

for j = i to ll_ctrlcnt
	choose case iw_parent.control[j].typeof()
		case line!, oval!, rectangle!, roundrectangle!
			continue
	end choose
	
	ldo_lower = iw_parent.control[j]
	ldo_lower.setposition(behind!, ldo_upper)
	ldo_upper = ldo_lower
next

for i = 1 to ll_ctrlcnt
	choose case iw_parent.control[i].typeof()
		case line!, oval!, rectangle!, roundrectangle!
			continue
	end choose
	
	ldo_totop = iw_parent.control[i]
	if ldo_totop.bringtotop = true then
		ldo_totop.bringtotop = true
	end if
next

//ll_ctrlcnt = upperbound(iw_parent.control)
//for i = 1 to ll_ctrlcnt
//	if iw_parent.control[i].classname() = as_classname then
//		if i > 1 then
//			idw_target.setposition(Behind!, iw_parent.control[i - 1])
//		end if
//	end if
//next

return 1

end function

public function string of_getlastobject (string as_band);// 데이터윈도우 오브젝트 중 오른쪽 가장 마지막에 위치한 오브젝트명을 리터합니다
// as_band: 오브젝트를 검색할 밴드(header, detail, summary, footer)
// 리턴값: 오른쪽 가장 마지막 오브젝트명

string ls_object, ls_objarr[]
string ls_lastobj
long i, ll_objcnt
long ll_objpos, ll_maxpos

if isnull(as_band) or as_band = '' then return ''

ls_object = idw_target.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then Continue
	if idw_target.describe(ls_objarr[i] + ".Band") = as_band then
		if idw_target.describe(ls_objarr[i] + ".Visible") = '1' then
			ll_objpos = long(idw_target.describe(ls_objarr[i] + ".X")) + long(idw_target.describe(ls_objarr[i] + ".Width"))
			if ll_maxpos < ll_objpos then
				ll_maxpos = ll_objpos
				ls_lastobj = ls_objarr[i]
			end if
		end if
	end if
next

return ls_lastobj
end function

public subroutine of_resize (integer sizetype, long newwidth, long newheight);
end subroutine

public subroutine of_move (long xpos, long ypos);
end subroutine

public subroutine of_drawborderpos ();iln_top.SetPosition(Behind!, idw_target)
iln_bottom.SetPosition(Behind!, idw_target)
iln_left.SetPosition(Behind!, idw_target)
iln_right.SetPosition(Behind!, idw_target)
end subroutine

public subroutine of_destructorcustomborder ();If IsValid(iln_top) Then
	iln_top.visible = false
	If igo_parent.typeof() = userobject! Then gnv_extfunc.setparent(handle(iln_top), il_borderhndl[1])
	iw_parent.CloseUserObject(iln_top)
	Destroy iln_top
End If

If IsValid(iln_bottom) Then
	iln_bottom.visible = false
	If igo_parent.typeof() = userobject! Then gnv_extfunc.setparent(handle(iln_bottom), il_borderhndl[2])
	iw_parent.CloseUserObject(iln_bottom)
	Destroy iln_bottom
End If

If IsValid(iln_left) Then
	iln_left.visible = false
	If igo_parent.typeof() = userobject! Then gnv_extfunc.setparent(handle(iln_left), il_borderhndl[3])
	iw_parent.CloseUserObject(iln_left)
	Destroy iln_left
End If

If IsValid(iln_right) Then
	iln_right.visible = false
	If igo_parent.typeof() = userobject! Then gnv_extfunc.setparent(handle(iln_right), il_borderhndl[4])
	iw_parent.CloseUserObject(iln_right)
	Destroy iln_right
End If

//If IsValid(iln_top)		Then iln_top.visible = false
//If IsValid(iln_bottom)	Then iln_bottom.visible = false
//If IsValid(iln_left)		Then iln_left.visible = false
//If IsValid(iln_right)		Then iln_right.visible = false
end subroutine

public subroutine of_setborderfocuscolor (boolean ab_boolean);choose case ab_boolean
	case true
		if isvalid(iln_left) then
			iln_top.backcolor		= gnv_vari.borderfocuscolor
			iln_bottom.backcolor	= gnv_vari.borderfocuscolor
			iln_left.backcolor		= gnv_vari.borderfocuscolor
			iln_right.backcolor		= gnv_vari.borderfocuscolor
		end if
	case false
		if isvalid(iln_left) then
			iln_top.backcolor		= gnv_vari.bordernor2topcolor
			iln_bottom.backcolor	= gnv_vari.bordernor2bottomcolor
			iln_left.backcolor		= gnv_vari.bordernor2leftcolor
			iln_right.backcolor		= gnv_vari.bordernor2rightcolor
		end if
end choose
end subroutine

public function string of_getedityokenbycolor ();Return ''
end function

public subroutine of_setlist4backcolor (string as_setlist4backcolor);string	ls_colorarr[]
string	ls_syntax
Long		ll_colorcnt, ll_i
Long		ll_r, ll_g, ll_b

ll_colorcnt = fw_f_obj2array(as_setlist4backcolor, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	setlist4backcolor = gnv_vari.setlist4backcolor
Else
	for ll_i = 1 to ll_colorcnt
		Choose Case ll_i
			Case 1
				ll_r = Long(ls_colorarr[ll_i])
			Case 2
				ll_g = Long(ls_colorarr[ll_i])
			Case 3
				ll_b = Long(ls_colorarr[ll_i])
		End Choose
	next
	setlist4backcolor = rgb(ll_r, ll_g, ll_b)
End If

setlist4backcolorgb = true
end subroutine

public subroutine of_setlist4summarycolor (string as_setlist4summarycolor);string	ls_colorarr[]
string	ls_syntax
Long		ll_colorcnt, ll_i
Long		ll_r, ll_g, ll_b

ll_colorcnt = fw_f_obj2array(as_setlist4summarycolor, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	setlist4summarycolor = gnv_vari.setlist4summarycolor
Else
	for ll_i = 1 to ll_colorcnt
		Choose Case ll_i
			Case 1
				ll_r = Long(ls_colorarr[ll_i])
			Case 2
				ll_g = Long(ls_colorarr[ll_i])
			Case 3
				ll_b = Long(ls_colorarr[ll_i])
		End Choose
	next
	setlist4summarycolor = rgb(ll_r, ll_g, ll_b)
End If

setlist4summarycolorgb	= true
end subroutine

public subroutine of_setlist4footercolor (string as_setlist4footercolor);string	ls_colorarr[]
string	ls_syntax
Long		ll_colorcnt, ll_i
Long		ll_r, ll_g, ll_b

ll_colorcnt = fw_f_obj2array(as_setlist4footercolor, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	setlist4footercolor = gnv_vari.setlist4footercolor
Else
	for ll_i = 1 to ll_colorcnt
		Choose Case ll_i
			Case 1
				ll_r = Long(ls_colorarr[ll_i])
			Case 2
				ll_g = Long(ls_colorarr[ll_i])
			Case 3
				ll_b = Long(ls_colorarr[ll_i])
		End Choose
	next
	setlist4footercolor = rgb(ll_r, ll_g, ll_b)	
End If

setlist4footercolorgb = true
end subroutine

public subroutine of_setlist4goupcolor1 (string as_setlist4goupcolor1);string	ls_colorarr[]
Long		ll_colorcnt, ll_i, ll_StartPos1
Long		ll_r, ll_g, ll_b

ll_StartPos1 = Pos(isasissyntax4style, 'group(level=')
If ll_StartPos1 < 1 Then
	setlist4goupcolor1gb = false
	Return
End If

ll_colorcnt = fw_f_obj2array(as_setlist4goupcolor1, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	setlist4goupcolor1 = gnv_vari.setlist4goupcolor1
Else
	for ll_i = 1 to ll_colorcnt
		Choose Case ll_i
			Case 1
				ll_r = Long(ls_colorarr[ll_i])
			Case 2
				ll_g = Long(ls_colorarr[ll_i])
			Case 3
				ll_b = Long(ls_colorarr[ll_i])
		End Choose
	next
	setlist4goupcolor1 = rgb(ll_r, ll_g, ll_b)
End If
setlist4goupcolor1gb = true
setgroupcolorsyntax1 = 'DataWindow.Trailer.1.color="' + string(setlist4goupcolor1) + '"'
end subroutine

public subroutine of_setlist4goupcolor2 (string as_setlist4goupcolor2);string	ls_colorarr[]
Long		ll_colorcnt, ll_i, ll_StartPos1
Long		ll_r, ll_g, ll_b

ll_StartPos1 = Pos(isasissyntax4style, 'group(level=')
If ll_StartPos1 < 1 Then
	setlist4goupcolor1gb = false
	Return
End If

ll_colorcnt = fw_f_obj2array(as_setlist4goupcolor2, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	setlist4goupcolor2 = gnv_vari.setlist4goupcolor2
Else
	for ll_i = 1 to ll_colorcnt
		Choose Case ll_i
			Case 1
				ll_r = Long(ls_colorarr[ll_i])
			Case 2
				ll_g = Long(ls_colorarr[ll_i])
			Case 3
				ll_b = Long(ls_colorarr[ll_i])
		End Choose
	next
	setlist4goupcolor2 = rgb(ll_r, ll_g, ll_b)
End If
setlist4goupcolor2gb = true
If setlist4goupcolor1gb = false Then setlist4goupcolor1 = 553648127
setgroupcolorsyntax2 = 'DataWindow.Trailer.1.color="' + string(setlist4goupcolor1) + '"~r~n'
setgroupcolorsyntax2 += 'DataWindow.Trailer.2.color="' + string(setlist4goupcolor2) + '"'
end subroutine

public subroutine of_setlist4headercolor (string as_setlist4headercolor);string	ls_colorarr[]
string	ls_syntax
Long		ll_colorcnt, ll_i
Long		ll_r, ll_g, ll_b

ll_colorcnt = fw_f_obj2array(as_setlist4headercolor, ',', ls_colorarr[])
If ll_colorcnt <> 3 Then
	setlist4headercolor = gnv_vari.setlist4headercolor
Else
	for ll_i = 1 to ll_colorcnt
		Choose Case ll_i
			Case 1
				ll_r = Long(ls_colorarr[ll_i])
			Case 2
				ll_g = Long(ls_colorarr[ll_i])
			Case 3
				ll_b = Long(ls_colorarr[ll_i])
		End Choose
	next
	setlist4headercolor = rgb(ll_r, ll_g, ll_b)
End If

setlist4headercolorgb = true
end subroutine

public function string of_setlist4goupcolorsyntax ();Long	ll_StartPos1, ll_StartPos2

ll_StartPos1 = Pos(isasissyntax4style, 'group(level=')
If ll_StartPos1 < 1 Then Return ''

ll_StartPos2	= 0

 /* group 이 2개 이상이면 group 1부터 다지 지정함; group 색 지정은 group 2번까지만 지원하고 그외에는 수작업 처리 */
If ll_StartPos1 > 0 Then
	ll_StartPos2	= Pos(isasissyntax4style, 'group(level=', ll_StartPos1 + 1)		
	If ll_StartPos2 > 0 Then
		If fw_f_nvls(setgroupcolorsyntax2, '') <> '' Then Return setgroupcolorsyntax2
	Else
		If fw_f_nvls(setgroupcolorsyntax1, '') <> '' Then Return setgroupcolorsyntax1
	End If
End If

Return ''
end function

public subroutine of_setlist4rowpointcolor (string as_setlist4rowpointcolor);String	ls_gb1arr[], ls_gb2arr[]
String	ls_tmp1st, ls_tmp2nd
Long		ll_gb1cnt, ll_gb2cnt, ll_i

ll_gb1cnt = fw_f_obj2array(as_setlist4rowpointcolor, ';', ls_gb1arr[])
If ll_gb1cnt > 0 Then
	For ll_i = 1 to ll_gb1cnt
		ll_gb2cnt = fw_f_obj2array(ls_gb1arr[ll_i], '=', ls_gb2arr[])
		If ll_gb2cnt <> 3 Then
			islistrowpointexpression1st	= ''
			islistrowpointexpression2nd	= ''
			ls_tmp1st	= ''
			ls_tmp2nd	= ''
			Return
		End If
		Choose Case ls_gb2arr[3]
			Case 'a'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4row_a)
			Case 'b'					
				ls_gb2arr[3] = String(gnv_vari.pointcolor4row_b)
			Case 'c'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4row_c)
			Case 'd'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4row_d)
			Case 'e'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4row_e)
			Case Else
				islistrowpointexpression1st	= ''
				islistrowpointexpression2nd	= ''
				Return
		End Choose
				
		Choose Case ll_i
			Case 1
				islistrowpointexpression1st	= 'If(' + ls_gb2arr[1] + ' = "' + ls_gb2arr[2] + '", ' + ls_gb2arr[3] + ', ' + String(gnv_vari.alternatefirstrowcolor) + ')'
				islistrowpointexpression2nd	= 'If(' + ls_gb2arr[1] + ' = "' + ls_gb2arr[2] + '", ' + ls_gb2arr[3] + ', ' + String(gnv_vari.alternatesecondrowcolor) + ')'
			Case is > 1
				ls_tmp1st	= 'If(' + ls_gb2arr[1] + ' = "' + ls_gb2arr[2] + '", ' +  ls_gb2arr[3] + ', ' + String(gnv_vari.alternatefirstrowcolor) + ')'
				ls_tmp2nd	= 'If(' + ls_gb2arr[1] + ' = "' + ls_gb2arr[2] + '", ' +  ls_gb2arr[3] + ', ' + String(gnv_vari.alternatesecondrowcolor) + ')'
		End Choose

		If fw_f_nvls(ls_tmp1st, '') <> '' Then
			islistrowpointexpression1st	= fw_f_replaceall(islistrowpointexpression1st, String(gnv_vari.alternatefirstrowcolor), ls_tmp1st)
			islistrowpointexpression2nd	= fw_f_replaceall(islistrowpointexpression2nd, String(gnv_vari.alternatesecondrowcolor), ls_tmp2nd)
		End If
	Next
End If
end subroutine

public subroutine of_initialize (readonly fw_u_dwo adw_datawindow, window aw_parent, fw_n_handle anv_dwbyhandle);// parent datawindow / window 등록
idw_target	= adw_datawindow
igo_parent	= idw_target.getparent()
iw_parent	= aw_parent
inv_handle	= anv_dwbyhandle

isdesignstyle	= idw_target.Dynamic of_getdesignstyle()
isasissyntax4style = idw_target.Describe("DataWindow.Syntax") /* to-be asis syntax sign up */
il_headerheight	= long(idw_target.describe("Datawindow.Header.Height"))

of_resize(0, idw_target.width, idw_target.height)  /* init size */
end subroutine

public function string of_setlist4edittoken (string as_obj, string as_objtype, string as_editstyle, integer al_revise);String	ls_syntax
String	ls_ojbheight, ls_asborder, ls_toborder, ls_protect, ls_colautoheightgb
Long		ll_pos, ll_tmppos, ll_ctlheight
Long		ll_tmpheight

ls_colautoheightgb	= idw_target.Describe(as_obj + ".Height.AutoSize")
ls_ojbheight			= idw_target.Describe(as_obj + ".height")
ll_ctlheight			= 0
ls_syntax				= ''
Choose Case isdesignstyle
	Case 'grid'
		ll_ctlheight = al_revise
	Case 'tabular'
		ll_ctlheight	= al_revise
End Choose
ls_protect = idw_target.Describe(as_obj + ".Protect")
ll_pos = pos(ls_protect, '~t')
ls_asborder = idw_target.Describe(as_obj + ".Border")
ll_tmppos = pos(ls_asborder, '~t')
If ll_tmppos > 0 Then ls_asborder = mid(ls_asborder, 2, ll_tmppos - 2)

Choose Case as_editstyle
	Case 'dddw', 'ddlb'
		ll_tmppos = pos(ls_ojbheight, '~t')
		If ll_tmppos > 0 Then ls_ojbheight = mid(ls_ojbheight, 2, ll_tmppos - 2)
		If ll_pos > 0 Then
			ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)
			ls_syntax += as_obj + '.height="' + ls_ojbheight + of_getinnersyntax('~tIf(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), ' + ls_ojbheight + ', ' + String(long(ls_ojbheight) + ll_ctlheight) + ')') + '"~r~n'
			ls_syntax += as_obj + '.Border="' + ls_asborder + of_getinnersyntax('~tIf(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), 4, 0)') + '"~r~n'
		Else
			ls_syntax += as_obj + '.height="' + ls_ojbheight + of_getinnersyntax('~tIf(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), ' + ls_ojbheight + ', ' + String(long(ls_ojbheight) + ll_ctlheight) + ')') + '"~r~n'
			ls_syntax += as_obj + '.Border="' + ls_asborder + of_getinnersyntax('~tIf(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), 4, 0)') + '"~r~n'
		End If
	Case 'edit'
		If ll_pos > 0 Then
			ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)
			If isdesignstyle = 'tabular' Then ls_syntax += as_obj + '.height="' + ls_ojbheight + of_getinnersyntax('~tIf(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0, If(currentRow()=getrow(), ' + ls_ojbheight + ', ' + ls_ojbheight + '), ' + ls_ojbheight + ')') + '"~r~n'
			ls_syntax += as_obj + '.Border="' + ls_asborder + of_getinnersyntax('~tIf(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0 and Describe("' + as_obj + '.Edit.DisplayOnly") = "no" and currentRow()=getrow(), 4, 0)') + '"~r~n'
		Else
			If isdesignstyle = 'tabular' Then ls_syntax += as_obj + '.height="' + ls_ojbheight + of_getinnersyntax('~tIf(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), ' + ls_ojbheight + ', ' + ls_ojbheight + ')') + '"~r~n'
			ls_syntax += as_obj + '.Border="' + ls_asborder + of_getinnersyntax('~tIf(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and Describe("' + as_obj + '.Edit.DisplayOnly") = "no" and currentRow()=getrow(), 4, 0)') + '"~r~n'
		End If
	Case Else
		If ll_pos > 0 Then
			ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)
			If isdesignstyle = 'tabular' Then ls_syntax += as_obj + '.height="' + ls_ojbheight + of_getinnersyntax('~tIf(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0, If(currentRow()=getrow(), ' + ls_ojbheight + ', ' + ls_ojbheight + '), ' + ls_ojbheight + ')') + '"~r~n'
			ls_syntax += as_obj + '.Border="' + ls_asborder + of_getinnersyntax('~tIf(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), 4, 0)') + '"~r~n'
		Else
			If isdesignstyle = 'tabular' Then ls_syntax += as_obj + '.height="' + ls_ojbheight + of_getinnersyntax('~tIf(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), ' + ls_ojbheight + ', ' + ls_ojbheight + ')') + '"~r~n'
			ls_syntax += as_obj + '.Border="' + ls_asborder + of_getinnersyntax('~tIf(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and currentRow()=getrow(), 4, 0)') + '"~r~n'
		End If
End Choose

Return ls_syntax
end function

public subroutine of_setlist4fontpointcolor (string as_setlist4fontpointcolor);String	ls_gb1arr[], ls_gb2arr[]
String	ls_tmp1st
Long		ll_gb1cnt, ll_gb2cnt, ll_i

ll_gb1cnt = fw_f_obj2array(as_setlist4fontpointcolor, ';', ls_gb1arr[])
If ll_gb1cnt > 0 Then
	For ll_i = 1 to ll_gb1cnt
		ll_gb2cnt = fw_f_obj2array(ls_gb1arr[ll_i], '=', ls_gb2arr[])
		If ll_gb2cnt <> 3 Then
			islistfontpointexpression	= ''
			ls_tmp1st	= ''
			Return
		End If
		Choose Case ls_gb2arr[3]
			Case 'a'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4objfont_a)
			Case 'b'					
				ls_gb2arr[3] = String(gnv_vari.pointcolor4objfont_b)
			Case 'c'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4objfont_c)		
			Case 'd'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4objfont_d)
			Case 'e'
				ls_gb2arr[3] = String(gnv_vari.pointcolor4objfont_e)
			Case Else
				islistfontpointexpression	= ''
				Return		
		End Choose
		
		Choose Case ll_i
			Case 1
				islistfontpointexpression = 'If(' + ls_gb2arr[1] + ' = "' + ls_gb2arr[2] + '", ' + ls_gb2arr[3] + ', ' + String(gnv_vari.basefontcolor) + ')'
			Case is > 1
				ls_tmp1st = 'If(' + ls_gb2arr[1] + ' = "' + ls_gb2arr[2] + '", ' +  ls_gb2arr[3] + ', ' + String(gnv_vari.basefontcolor) + ')'
		End Choose

		If fw_f_nvls(ls_tmp1st, '') <> '' Then
			islistfontpointexpression = fw_f_replaceall(islistfontpointexpression, String(gnv_vari.basefontcolor), ls_tmp1st)
		End If
	Next
End If
end subroutine

public function string of_setobj4fontpointcolor (string as_obj, string as_objtype);String	ls_fontcolor
Long		ll_pos

ls_fontcolor = idw_target.describe(as_obj + ".Color")
If ls_fontcolor = '!' Then ls_fontcolor = String(gnv_vari.basefontcolor)
ll_pos = Pos(ls_fontcolor, '~t')
If ll_pos > 0 Then ls_fontcolor = mid(ls_fontcolor, 2, ll_pos - 1)
Choose Case as_objtype
	Case 'column', 'compute'
		Choose Case isdesignstyle
			Case 'freeform', 'cond'
				//
			Case 'grid', 'tabular'
				ls_fontcolor = ls_fontcolor + of_getinnersyntax('~t' + islistfontpointexpression)
			Case Else
				//
		End Choose
End Choose

Return ls_fontcolor
end function

public function string of_setrectline4design_1sub (string as_syntax, long al_st4pos);String	ls_syntaxsub
Long		ll_lineStart, ll_lineEnd

ll_lineStart = 0; ll_lineEnd = 0

If al_st4pos = 1 Then
	ll_lineStart	= 1
Else
	ll_lineStart	= LastPos(left(as_syntax, al_st4pos), gnv_vari.GetBlock) + gnv_vari.GetBlockLen
End If
ll_lineEnd = Pos(as_syntax, gnv_vari.GetBlock, al_st4pos)
ls_syntaxsub = mid(as_syntax, ll_lineStart, ll_lineEnd - ll_lineStart)

Return ls_syntaxsub
end function

public function string of_setrectline4design (string as_newcel[], long al_cellcnt);// cell border position 조정
string	ls_rectstring[]
string	ls_stcstring[]

string	ls_besyntax, ls_error
string	ls_stc2syntax
string	ls_findstr[] = { "text(name", "column(name", "compute(name", "groupbox(name", "bitmap(name" }
string	ls_stsstr[] = { "sethpbc_stc", "setfilasc_stc", "sethpbcdesc_stc", "sethpbcasc_stc" }

long	ll_minpos = 214748364, ll_text2pos = 214748364, ll_htmltable2pos = 214748364
long	ll_rect2pos, ll_rect2cnt = 0
long	ll_stc2pos, ll_stc2cnt = 0
long	i, ll_i, ll_startpos

// create가 있으므로 retrieve 자료가 있으면 pass
// 20210913 yjs
IF	idw_target.rowcount ()>0	Then
	RETURN 'empty'
End IF

ls_besyntax = idw_target.describe("datawindow.syntax")

for i = 1 to al_cellcnt
	ll_rect2pos = pos(ls_besyntax, trim('rectangle(name=' + as_newcel[i]))
	if ll_rect2pos > 0 then
		ll_rect2cnt ++
		ls_rectstring[ll_rect2cnt] = of_setrectline4design_1sub(ls_besyntax, ll_rect2pos) + gnv_vari.getblock
	end if
next

ll_stc2pos = pos(ls_besyntax, 'text(name=sethpbc_stc')
if ll_stc2pos > 0 then
	for i = 1 to upperbound(ls_stsstr)
		ll_stc2pos = pos(ls_besyntax, ls_stsstr[i])
		if ll_stc2pos > 0 then
			ll_stc2cnt++
			ls_stcstring[ll_stc2cnt] = of_setrectline4design_1sub(ls_besyntax, ll_stc2pos) + gnv_vari.getblock
		end if
	next
end if

if ll_rect2cnt > 0 or ll_stc2cnt > 0	then
	for i = 1 to upperbound(ls_findstr)
		ll_startpos = pos(ls_besyntax, ls_findstr[i])
		if ll_startpos > 0 then
			if ll_startpos < ll_minpos then ll_minpos = ll_startpos
		end if
	next
	for ll_i = 1 to ll_rect2cnt
		 ls_besyntax = fw_f_replaceall(ls_besyntax, ls_rectstring[ll_i], '')
		 ls_besyntax = replace(ls_besyntax, ll_minpos, 0, ls_rectstring[ll_i])
	next
	//<임시> syntax 오류발생
	// 2021.11.09 / 4702
	if ll_stc2cnt > 0 then
		ls_besyntax = fw_f_replaceall(ls_besyntax, ls_stcstring[1], '')
		ll_text2pos = pos(ls_besyntax, "text(name")
		ls_besyntax = replace(ls_besyntax, ll_text2pos, 0, ls_stcstring[1])
		for ll_i = 2 to ll_stc2cnt
			ls_besyntax = fw_f_replaceall(ls_besyntax, ls_stcstring[ll_i], '')
			ll_htmltable2pos = pos(ls_besyntax, "htmltable(border=")
			ls_besyntax = replace(ls_besyntax, ll_htmltable2pos, 0, ls_stcstring[ll_i])
		next
	end if
	
	if idw_target.create(ls_besyntax, ls_error) = -1 then
		::clipboard(idw_target.classname() + "~r~n" + ls_besyntax)
		messagebox("error", idw_target.classname() + " syntax modification(create) failure!! : " + ls_error)
		return ''
	end  if
	idw_target.setfocus()
else
	return 'empty'
end if
end function

public function string of_setobj4bgcolor_syntax (string as_obj, string as_objtype);String	ls_syntax, ls_bgcolor, ls_protect
Long		ll_pos, ll_i, ll_row

ls_syntax = 'empty'
Choose Case as_objtype
	Case 'column'
		ls_protect = idw_target.Describe(as_obj + ".Protect")
		ll_pos = pos(ls_protect, '~t')
		If ll_pos > 0 Then
			ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)
			ls_protect = fw_f_replaceall(ls_protect, '"', "'")
			Choose Case isdesignstyle
				Case 'freeform', 'cond'
					ls_syntax = 'create compute(band=detail alignment="0" expression="' + ls_protect + '" border="0" color="19737901" x="-5" y="32768" height="4" width="0" format="[GENERAL]" html.valueishtml="0" name=' + as_obj + '_compute visible="0" font.face="맑은 고딕" font.height="-10" font.weight="400" font.family="3" font.pitch="2" font.charset="129" background.mode="2" background.color="553648127" )~r~n'
				Case 'tabular', 'grid'
					ls_syntax = 'create compute(band=detail alignment="0" expression="' + ls_protect + '" border="0" color="19737901" x="-5" y="32768" height="4" width="0" format="[GENERAL]" html.valueishtml="0" name=' + as_obj + '_compute visible="0" font.face="맑은 고딕" font.height="-10" font.weight="400" font.family="3" font.pitch="2" font.charset="129" background.mode="2" background.color="553648127" )~r~n'
			End Choose
		End If
End Choose

Return ls_syntax
end function

public subroutine of_drawbordervisible (boolean ab_visible);If Isvalid(iln_top) Then
	iln_top.visible		= ab_visible
	iln_bottom.visible	= ab_visible
	iln_left.visible		= ab_visible
	iln_right.visible		= ab_visible
End If
end subroutine

public function string of_setobj4bgcolor (string as_obj, string as_objtype, string as_band);string		ls_bgcolor, ls_protect
long		ll_pos, ll_i, ll_row

ls_bgcolor = idw_target.describe(as_obj + ".Background.Color")
if ls_bgcolor = '!' then ls_bgcolor = string(553648127)
if left(ls_bgcolor, 1) = '"' and right(ls_bgcolor, 1) = '"' then
	ls_bgcolor = of_fixescapechar(mid(ls_bgcolor, 2, len(ls_bgcolor) - 2))
end if

ls_protect = idw_target.Describe(as_obj + ".Protect")
ll_pos = pos(ls_protect, '~t')
if ll_pos > 0 then ls_protect = mid(ls_protect, ll_pos + 1, len(ls_protect) - ll_pos - 1)

choose case as_objtype
	case 'column', 'compute', 'text'
		if left(ls_bgcolor, 9) = '553648127' or left(ls_bgcolor, 9) = '536870912' then
			choose case isdesignstyle
				case  'freeform', 'cond'
					if as_objtype = 'text'then return ls_bgcolor
					if pos(ls_bgcolor, '~t') = 0 then
						if idw_target.setedittoken = true then
							if ll_pos > 0 then
								ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0, if(Describe("' + gnv_extfunc.istr_node4value.cstr18 + '") = ~"' + as_obj + '~" and currentrow()=getrow(), ' + string(gnv_vari.setcolfocusbackcolor) + ', ' + string(gnv_vari.editablecolbgcolor) + '), ' + string(gnv_vari.disabledcolbgcolor) + ')')
							else
								ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0, if(Describe("' + gnv_extfunc.istr_node4value.cstr18 + '") = ~"' + as_obj + '~" and currentrow()=getrow(), ' + string(gnv_vari.setcolfocusbackcolor) + ', ' + string(gnv_vari.editablecolbgcolor) + '), ' + string(gnv_vari.disabledcolbgcolor) + ')')
							end if
						else
							if ll_pos > 0 then
								ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0 and currentrow()=getrow(), ' + string(gnv_vari.editablecolbgcolor) + ', ' + string(gnv_vari.disabledcolbgcolor) + ')')
							else
								ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0 and currentrow()=getrow(), ' + string(gnv_vari.editablecolbgcolor) + ', ' + string(gnv_vari.disabledcolbgcolor) + ')')
							end if
						end if
					end if
				case 'grid', 'tabular'
					if idw_target.ibsetlist4mouseovercolor = false then
						if fw_f_nvls(islistrowpointexpression1st, '') <> '' then
							islist4mouseovercolor = 'if(mod(getrow(), 2) = 0, ' + string(islistrowpointexpression2nd) + ', ' + string(islistrowpointexpression1st) + ')'
						else
							islist4mouseovercolor = 'if(mod(getrow(), 2) = 0, ' + string(gnv_vari.alternatesecondrowcolor) + ', ' + string(gnv_vari.alternatefirstrowcolor) + ')'
						end if
						//islist4mouseovercolor = string(536870912)
					else
						if fw_f_nvls(islistrowpointexpression1st, '') <> '' then
							islist4mouseovercolor = 'if(long(describe(~"datawindow.detail.pointer~")) = getrow(), ' + string(gnv_vari.setlist4mouseovercolor) + ', if(mod(getrow(), 2) = 0, ' + string(islistrowpointexpression2nd) + ', ' + string(islistrowpointexpression1st) + '))'
						else
							islist4mouseovercolor = 'if(long(describe(~"datawindow.detail.pointer~")) = getrow(), ' + string(gnv_vari.setlist4mouseovercolor) + ', if(mod(getrow(), 2) = 0, ' + string(gnv_vari.alternatesecondrowcolor) + ', ' + string(gnv_vari.alternatefirstrowcolor) + '))'
						end if
					end if
					if not ( as_band = 'detail') then return ls_bgcolor
					if idw_target.ibsetlist4alrowcolor = true then
						if pos(ls_bgcolor, '~t') = 0 then
							if idw_target.ibsetlist4clearselect = true then
								if ll_pos > 0 then
									ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(currentrow()=getrow(), if(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0 and Describe("' + gnv_extfunc.istr_node4value.cstr18 + '") = "' + as_obj + '", ' + string(gnv_vari.setcolfocusbackcolor) + ', ' + string(gnv_vari.setclearselectcolor) + '), '+ islist4mouseovercolor + ')')
								else
									ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(currentrow()=getrow(), if(Describe("' + gnv_extfunc.istr_node4value.cstr18 + '") = "' + as_obj + '", ' + string(gnv_vari.setcolfocusbackcolor) + ', ' + string(gnv_vari.setclearselectcolor) + '), '+ islist4mouseovercolor + ')')
								end if
							else
								if ll_pos > 0 then
									ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0, if(currentrow()=getrow() and Describe("' + gnv_extfunc.istr_node4value.cstr18 + '") = "' + as_obj + '", ' + string(gnv_vari.setcolfocusbackcolor) + ', ' + islist4mouseovercolor + '), '+ islist4mouseovercolor + ')')
								else
									ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0, if(currentrow()=getrow() and Describe("' + gnv_extfunc.istr_node4value.cstr18 + '") = "' + as_obj + '", ' + string(gnv_vari.setcolfocusbackcolor) + ', ' + islist4mouseovercolor + ') , '+ islist4mouseovercolor + ')')
								end if
							end if
						end if
					else
						if pos(ls_bgcolor, '~t') = 0 then
							if ll_pos > 0 then
								ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0, ' + string(gnv_vari.editablecolbgcolor) + ', ' + string(gnv_vari.disabledcolbgcolor) + ')')
							else
								ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0, ' + string(gnv_vari.editablecolbgcolor) + ', ' + string(gnv_vari.disabledcolbgcolor) + ')')
							end if
						end if
					end if
				case else
					if pos(ls_bgcolor, '~t') = 0 then
						if ll_pos > 0 then
							ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(' + as_obj + gnv_extfunc.istr_node4value.cstr17 + '"' + as_obj + '.TabSequence")) > 0, ' + string(gnv_vari.editablecolbgcolor) + ', ' + string(gnv_vari.disabledcolbgcolor) + ')')
						else
							ls_bgcolor = ls_bgcolor + of_getinnersyntax('~tif(Long(Describe("' + as_obj + '.Protect")) = 0 and Long(Describe("' + as_obj + '.TabSequence")) > 0, ' + string(gnv_vari.editablecolbgcolor) + ', ' + string(gnv_vari.disabledcolbgcolor) + ')')
						end if
					end if
			end choose
		end if
end choose

return ls_bgcolor
end function

public function string of_setetc2syntax (string as_obj);String	ls_syntax
String	ls_useellipsis, ls_tooltip, ls_tooltiphelp

ls_syntax = ''
ls_useellipsis	= idw_target.describe(as_obj + ".Edit.UseEllipsis")
ls_tooltip		= idw_target.describe(as_obj + ".Tooltip.Enabled")

If ls_useellipsis	= 'yes' Then ls_syntax += as_obj + '.Edit.UseEllipsis=Yes~r~n'
If ls_tooltip = '1' Then
	ls_tooltiphelp = idw_target.Describe(as_obj + ".Tooltip.Tip")
	ls_syntax += as_obj + '.Tooltip.Enabled=1~r~n'
	ls_syntax += as_obj + '.Tooltip.tip="' + ls_tooltiphelp + '"~r~n'
End If

Return ls_syntax
end function

public function string of_setlist4bandfontcolor (string as_obj, string as_band, string as_objtype);string	ls_syntax, ls_fontcolor
string	ls_fontcolor4header, ls_fontcolor4summary, ls_fontcolor4footer

ls_syntax = ''

If as_band = 'detail' and fw_f_nvls(islistfontpointexpression, '') <> '' Then
	ls_fontcolor = of_setobj4fontpointcolor(as_obj, as_objtype)
	ls_syntax = as_obj + '.Color="' + ls_fontcolor + '"~r~n'
End If
If as_objtype = 'text' Then
	 Choose Case as_band
		Case 'header'
			ls_fontcolor4header = idw_target.describe(as_obj + ".Color")
			If ls_fontcolor4header = string(gnv_vari.basefontcolor + gnv_vari.iladditives2numcolor) Then ls_syntax += as_obj + '.Color="' + string(gnv_vari.setlist4headerfontcolor) + '"~r~n'
		Case 'summary'
			ls_fontcolor4summary = idw_target.describe(as_obj + ".Color")
			If ls_fontcolor4summary = string(gnv_vari.basefontcolor + gnv_vari.iladditives2numcolor) Then ls_syntax += as_obj + '.Color="' + string(gnv_vari.setlist4summaryfontcolor) + '"~r~n'
		Case 'footer'
			ls_fontcolor4footer = idw_target.describe(as_obj + ".Color")
			If ls_fontcolor4footer = string(gnv_vari.basefontcolor + gnv_vari.iladditives2numcolor) Then ls_syntax += as_obj + '.Color="' + string(gnv_vari.setlist4footerfontcolor) + '"~r~n'
	End Choose
End If

return ls_syntax
end function

public function string of_sethd4syntax2filter (string as_createsyntax);// ibsetlist4sort으로 통합 <- SetHeaderPoint
Long	ll_markwidth, ll_markheight
ll_markwidth	= Long(PixelsToUnits(1, XPixelsToUnits!))
ll_markheight	= Long(PixelsToUnits(1, YPixelsToUnits!))

gnv_extfunc.biznode1te(117, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
as_createsyntax += "create text(band=header alignment='2' border='0' color='" + string(gnv_vari.filter2font4color) + "' x='" + String(PixelsToUnits(-5, XPixelsToUnits!)) + "' y='" + String(PixelsToUnits(-5, YPixelsToUnits!)) + "' height='" + string(ll_markheight) + "' width='" + string(ll_markwidth) + gnv_extfunc.is_nodevalue + "~r~n"

Return as_createsyntax
end function

public function string of_sethd4syntax2effect (string as_createsyntax);// ibsetlist4sort으로 통합 <- SetHeaderPoint
Long	ll_markwidth, ll_markheight
ll_markwidth	= Long(PixelsToUnits(1, XPixelsToUnits!))
ll_markheight	= Long(PixelsToUnits(1, YPixelsToUnits!))

gnv_extfunc.biznode1te(127, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
as_createsyntax += "create text(band=header alignment='2' border='6' color='" + string(gnv_vari.sort2back4color) + "' x='" + String(PixelsToUnits(-5, XPixelsToUnits!)) + "' y='" + String(PixelsToUnits(-5, YPixelsToUnits!)) + "' height='" + string(ll_markheight) + "'" + " width='" + string(ll_markwidth) + gnv_extfunc.is_nodevalue + string(gnv_vari.sort2back4color) + "')~r~n"

return as_createsyntax
end function

public function string of_sethd4syntax2sort (string as_createsyntax);// ibsetlist4sort으로 통합 <- SetHeaderPoint
Long	ll_markwidth, ll_markheight
ll_markwidth	= Long(PixelsToUnits(1, XPixelsToUnits!))
ll_markheight	= Long(PixelsToUnits(1, YPixelsToUnits!))

gnv_extfunc.biznode1te(129, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
as_createsyntax += "create text(band=header alignment='2' border='0' color='" + string(gnv_vari.sort2asc4color) + "' x='" + String(PixelsToUnits(-5, XPixelsToUnits!)) + "' y='" + String(PixelsToUnits(-5, YPixelsToUnits!)) + "' height='" + string(ll_markheight) + "' width='" + string(ll_markwidth) + gnv_extfunc.is_nodevalue + "~r~n"

gnv_extfunc.biznode1te(131, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
as_createsyntax += "create text(band=header alignment='2' border='0' color='" + string(gnv_vari.sort2desc4color) + "' x='" + String(PixelsToUnits(-5, XPixelsToUnits!)) + "' y='" + String(PixelsToUnits(-5, YPixelsToUnits!)) + "' height='" + string(ll_markheight) + "' width='" + string(ll_markwidth) + gnv_extfunc.is_nodevalue + "~r~n"

Return as_createsyntax
end function

public function string of_sethd4syntax2filter_1sub (string as_modifysyntax, boolean ab_tooltip);IF	ab_tooltip	Then
	as_modifysyntax += 'setfilasc_stc.tooltip.delay.initial="1"~r~n'
	as_modifysyntax += 'setfilasc_stc.tooltip.delay.visible="32000"~r~n'
	as_modifysyntax += 'setfilasc_stc.tooltip.enabled="1"~r~n'
	as_modifysyntax += 'setfilasc_stc.tooltip.isbubble="1"~r~n'
	as_modifysyntax += 'setfilasc_stc.tooltip.textcolor="19737901"~r~n'
	as_modifysyntax += 'setfilasc_stc.tooltip.tip="filter"~r~n'
Else
	as_modifysyntax += 'setfilasc_stc.tooltip.enabled="0"~r~n'
End IF

return as_modifysyntax
end function

public function string of_sethd4syntax2sort_1sub (string as_modifysyntax, boolean ab_tooltip);IF	ab_tooltip	Then
	as_modifysyntax += 'sethpbcasc_stc.tooltip.delay.initial="1"~r~n'
	as_modifysyntax += 'sethpbcasc_stc.tooltip.delay.visible="32000"~r~n'
	as_modifysyntax += 'sethpbcasc_stc.tooltip.enabled="1"~r~n'
	as_modifysyntax += 'sethpbcasc_stc.tooltip.isbubble="1"~r~n'
	as_modifysyntax += 'sethpbcasc_stc.tooltip.textcolor="19737901"~r~n'
	as_modifysyntax += 'sethpbcasc_stc.tooltip.tip="ASC"~r~n'

	as_modifysyntax += 'sethpbcdesc_stc.tooltip.delay.initial="1"~r~n'
	as_modifysyntax += 'sethpbcdesc_stc.tooltip.delay.visible="32000"~r~n'
	as_modifysyntax += 'sethpbcdesc_stc.tooltip.enabled="1"~r~n'
	as_modifysyntax += 'sethpbcdesc_stc.tooltip.isbubble="1"~r~n'
	as_modifysyntax += 'sethpbcdesc_stc.tooltip.textcolor="19737901"~r~n'
	as_modifysyntax += 'sethpbcdesc_stc.tooltip.tip="DESC"~r~n'
Else
	as_modifysyntax += 'sethpbcasc_stc.tooltip.enabled="0"~r~n'
	as_modifysyntax += 'sethpbcdesc_stc.tooltip.enabled="0"~r~n'
End IF

Return as_modifysyntax
end function

public function string of_setlist4alrowcolor (string as_syntax);if idw_target.ibsetlist4alrowcolor = false then
	as_syntax += 'datawindow.detail.color="' + string(setlist4backcolor) +'"~r~n'
else
	if idw_target.ibsetlist4clearselect = false then
		if fw_f_nvls(islistrowpointexpression1st, '') <> '' then
			as_syntax += 'datawindow.detail.color="536870912~tif(mod(getrow(), 2) = 0, ' + of_getinnersyntax(islistrowpointexpression2nd) + ', ' + of_getinnersyntax(islistrowpointexpression1st) + ')"~r~n'
		else
			as_syntax += 'datawindow.detail.color="536870912~tif(mod(getrow(), 2) = 0, ' + string(gnv_vari.alternatesecondrowcolor) + ', ' + string(gnv_vari.alternatefirstrowcolor) + ')"~r~n'
		end if
	end if
end if

return as_syntax

//	if idw_target.ibsetlist4clearselect = false then
//		if fw_f_nvls(islistrowpointexpression1st, '') <> '' then
//			if idw_target.ibsetlist4mouseovercolor = true then
//				as_syntax += 'datawindow.detail.color="536870912~tif(long(describe(~~~"datawindow.detail.pointer~~~")) = getrow(), ' + string(gnv_vari.setlist4mouseovercolor) + ', if(mod(getrow(), 2) = 0, ' + of_getinnersyntax(islistrowpointexpression2nd) + ', ' + of_getinnersyntax(islistrowpointexpression1st) + '))"~r~n'
//			else
//				as_syntax += 'datawindow.detail.color="536870912~tif(mod(getrow(), 2) = 0, ' + of_getinnersyntax(islistrowpointexpression2nd) + ', ' + of_getinnersyntax(islistrowpointexpression1st) + ')"~r~n'
//			end if
//		else
//			if idw_target.ibsetlist4mouseovercolor = true then
//				as_syntax += 'datawindow.detail.color="536870912~tif(long(describe(~~~"datawindow.detail.pointer~~~")) = getrow(), ' + string(gnv_vari.setlist4mouseovercolor) + ', if(mod(getrow(), 2) = 0, ' + string(gnv_vari.alternatesecondrowcolor) + ', ' + string(gnv_vari.alternatefirstrowcolor) + '))"~r~n'
//			else
//				as_syntax += 'datawindow.detail.color="536870912~tif(mod(getrow(), 2) = 0, ' + string(gnv_vari.alternatesecondrowcolor) + ', ' + string(gnv_vari.alternatefirstrowcolor) + ')"~r~n'
//			end if
//		end if
//	end if
end function

on fw_n_style.create
call super::create
end on

on fw_n_style.destroy
call super::destroy
end on

event destructor;call super::destructor;This.of_destructorcustomborder() /* to-be border destroy */
end event

