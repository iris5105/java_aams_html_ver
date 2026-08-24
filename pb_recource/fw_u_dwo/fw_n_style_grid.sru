forward
global type fw_n_style_grid from fw_n_style
end type
end forward

global type fw_n_style_grid from fw_n_style
end type
global fw_n_style_grid fw_n_style_grid

type variables

end variables

forward prototypes
public function integer of_applydesign ()
public function string of_thisname ()
public function long of_resetwidtheditableicon ()
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
public subroutine of_move (long xpos, long ypos)
public subroutine of_drawborderdestoy ()
public subroutine of_setpointheaderstate (boolean ab_boolean)
end prototypes

public function integer of_applydesign ();if not isvalid(idw_target) then return -1

string		ls_createsyntax		= ''
string		ls_modifysyntax		= ''
string		ls_error				= ''
long		ll_rect2cnt = 0
long		ll_objcnt, ll_imgheight, i, ll_j = 0

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.biznode11te(111, handle(this), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

// Header Band Background image
if setheaderbandimage <> '' then
	choose case gnv_vari.getclienttype
		case 'WEB'
			ll_imgheight = il_headerheight - long(PixelstoUnits(1, YPixelstoUnits!))
		case 'PB'
			ll_imgheight = il_headerheight
	end choose
	if il_headerheight > 100 then setheaderbandimage = '..\img\datawindow\img4header2st.jpg'
	ll_rect2cnt ++
	isrect2obj[ ll_rect2cnt ] = 'img4header'
	ls_createsyntax = 'create bitmap(band=header filename="' + setheaderbandimage + '" x="0" y="0" height="' + string(ll_imgheight) + '" width="' + string(idw_target.Width) + '" border="0" name=img4header visible="1" )~r~n'
end if

// ibsetlist4filter2dwo, ibsetlist4sort
ls_createsyntax = of_sethd4syntax2effect(ls_createsyntax)
//if idw_target.ibsetlist4filter2dwo = true then
//	ls_modifysyntax = of_sethd4syntax2filter_1sub(ls_modifysyntax, idw_target.ibsetlist4filtertip)
//	ls_createsyntax = of_sethd4syntax2filter(ls_createsyntax)
//end if
//if idw_target.ibsetlist4sort = true then
//	ls_modifysyntax = of_sethd4syntax2sort_1sub(ls_modifysyntax, idw_target.ibsetlist4sorttip)
//	ls_createsyntax = of_sethd4syntax2sort(ls_createsyntax)
//end if

// detail Row 디자인
ls_modifysyntax = of_setlist4alrowcolor(ls_modifysyntax)

// to-be  'dddw', 'ddlb' column border
string		ls_temp, ls_tempsyntax
string		ls_objtype, ls_editstyle, ls_border, ls_band, ls_visible, ls_objbgcolor
long		ll_summaryheight, ll_footerheight
long		ll_pos, ll_tabseq
long		ll_xpos, ll_ypos, ll_ypos2, ll_width, ll_height, ll_height1, ll_height2, ll_height3, ll_height4
long		ll_robjcnt, ll_tmppos

idw_target.modify(gnv_extfunc.istr_node4value.cstr16 + gnv_vari.is_nodekey + "'")
ll_height3	= long(idw_target.describe(gnv_extfunc.istr_node4value.cstr06))
ls_temp		= idw_target.describe(gnv_extfunc.istr_node4value.cstr01)
ll_objcnt	= fw_f_obj2array(ls_temp, "~t", isobjects[])
for i = 1 to ll_objcnt
	ls_border	= idw_target.describe(isobjects[i] + ".Border")
	ls_band		= idw_target.describe(isobjects[i] + ".Band")
	ls_objtype	= idw_target.describe(isobjects[i] + ".type")
	ls_editstyle	= idw_target.describe(isobjects[i] + ".edit.style")
		
	if (ls_band = gnv_extfunc.istr_node4value.cstr08 or ls_band = gnv_extfunc.istr_node4value.cstr09) then continue
	if Not (ls_objtype = gnv_extfunc.istr_node4value.cstr03 or ls_objtype = gnv_extfunc.istr_node4value.cstr04 or ls_objtype = gnv_extfunc.istr_node4value.cstr05) then continue

	/* to-be controls YPosition이 해당 band 밑에 있으면 continue */
	ll_height2	= long(idw_target.describe(gnv_extfunc.istr_node4value.cstr10 + ls_band + ".height"))
	ll_ypos2		= long(idw_target.describe(isobjects[i] + ".y"))
	
	if ll_height2 <= ll_ypos2 then continue
	
//	if idw_target.ibsetlist4sort = true and ls_band = "detail" then
//		ll_j++
//		is_sort4colnm[ll_j] = idw_target.describe(isobjects[i] + ".name")
//		il_sort4col2xpos[ll_j] = long(idw_target.describe(isobjects[i] + ".x"))
//		il_sort4col2width[ll_j] = long(idw_target.describe(isobjects[i] + ".width"))
//	end if
	
	// column Border 처리
	choose case ls_editstyle
		case gnv_extfunc.istr_node4value.cstr12
			ls_modifysyntax += isobjects[i] + '.edit.focusRectangle=No~r~n'
			if idw_target.setedittoken = true and ls_objtype = gnv_extfunc.istr_node4value.cstr15 then // column Border 처리
				ls_modifysyntax += of_setlist4edittoken(isobjects[i], ls_objtype, ls_editstyle, 0)
			else
				ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
			end if
		case gnv_extfunc.istr_node4value.cstr13, gnv_extfunc.istr_node4value.cstr14
			choose case ls_editstyle
				case gnv_extfunc.istr_node4value.cstr13
					ls_modifysyntax += isobjects[i] + gnv_extfunc.istr_node4value.cstr20 + '~"No~"~r~n'
				case gnv_extfunc.istr_node4value.cstr14
					ls_modifysyntax += isobjects[i] + gnv_extfunc.istr_node4value.cstr19 + '~"No~"~r~n'
			end choose
			ll_height1 = long(idw_target.describe(isobjects[i] + ".height"))
			if idw_target.ibsetlist4orgsizedesign = true then
				ll_height4 = 0
			else
				if idw_target.ibdesign4role = false then
					ll_height4 = ll_height3 - (ll_height1 + ll_ypos2) - long(PixelstoUnits(1, YPixelstoUnits!))
				else
					ll_height4 = long(PixelstoUnits(24, YPixelstoUnits!)) - (ll_height1 + long(PixelstoUnits(3, YPixelstoUnits!))) - long(PixelstoUnits(1, YPixelstoUnits!))
				end if
			end if		
			if idw_target.setedittoken = true and ls_objtype = gnv_extfunc.istr_node4value.cstr02 then 
				ls_modifysyntax += of_setlist4edittoken(isobjects[i], ls_objtype, ls_editstyle, ll_height4)
			else	
				ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
				ls_modifysyntax += isobjects[i] + '.height=~"' + string(ll_height1 + ll_height4) + '~"~r~n'
			end if
		case else
			if idw_target.setedittoken = true and ls_objtype = gnv_extfunc.istr_node4value.cstr15 then
				ls_modifysyntax += of_setlist4edittoken(isobjects[i], ls_objtype, ls_editstyle, 0)
			else				
				ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
			end if
	end choose	
	ls_modifysyntax += of_setlist4bandfontcolor(isobjects[i], ls_band, ls_objtype)
	// to-be column background color syntax
	ls_tempsyntax = of_setobj4bgcolor_syntax(isobjects[i], ls_objtype)
	if not(ls_tempsyntax = 'empty') then ls_createsyntax += ls_tempsyntax
	// to-be column background color
	ls_objbgcolor = of_setobj4bgcolor(isobjects[i], ls_objtype, ls_band)
	ls_modifysyntax += isobjects[i] + '.Background.color="' + ls_objbgcolor + '"~r~n'
	ls_modifysyntax += isobjects[i] + '.Background.mode=~"0~"~r~n'
	/* Background.mode='1' 로는 Background.color 변경 못함  transparent는 script에서 변경 못함 */	
	if idw_target.ibsetlist4clearselect = true then
		ls_visible = idw_target.describe(isobjects[i] + ".visible")
		if left(ls_visible, 1) = '"' and right(ls_visible, 1) = '"' then
			ls_visible = mid(ls_visible, 2, len(ls_visible) - 2)
		end if
		ll_xpos	= long(idw_target.describe(isobjects[i] + ".x")) - long(PixelstoUnits(3, XPixelstoUnits!))
		ll_ypos	=  -1 * long(PixelstoUnits(1, YPixelstoUnits!))
		ll_width	= long(idw_target.describe(isobjects[i] + ".width")) + long(PixelstoUnits(4, XPixelstoUnits!))
		if idw_target.ibdesign4role = true then
			ll_height = ll_height3 + long(PixelstoUnits(2, YPixelstoUnits!))
		else
			ll_height = il_headerheight + long(PixelstoUnits(2, YPixelstoUnits!))
		end if
		
		ll_rect2cnt ++
		isrect2obj[ ll_rect2cnt ] = isobjects[i] + gnv_extfunc.istr_node4value.cstr11
		choose case ls_band
			case 'header'
				if setheaderbandimage = '' and setlist4headercolorgb = true then
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="5" pen.width="5" pen.color="536870912" brush.hatch="6" brush.color="' + string(setlist4headercolor) + '" background.mode="0" background.color="536870912" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
				end if
			case 'detail'
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="5" pen.width="5" pen.color="536870912" brush.hatch="6" brush.color="' + ls_objbgcolor + '" background.mode="0" background.color="536870912" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
			case 'summary'
				if setlist4summarycolorgb = true then 
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="5" pen.width="5" pen.color="536870912" brush.hatch="6" brush.color="' + string(setlist4summarycolor) + '" background.mode="0" background.color="536870912" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
				end if
			case 'footer'
				if setlist4footercolorgb = true then
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="5" pen.width="5" pen.color="536870912" brush.hatch="6" brush.color="' + string(setlist4footercolor) + '" background.mode="0" background.color="536870912" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
				end if
		end choose		
	end if
	// to-be setetc2syntax
	if gnv_vari.getclienttype = 'WEB' then ls_modifysyntax += of_setetc2syntax(isobjects[i])
Next
if setlist4backcolorgb = true then ls_modifysyntax += 'dataWindow.color="' + string(setlist4backcolor) + '"~r~n'

if idw_target.ibsetlist4clearselect = false then
	ll_summaryheight	= long(idw_target.describe("dataWindow.summary.height"))
	ll_footerheight		= long(idw_target.describe("dataWindow.footer.height"))
	if setheaderbandimage = '' and setlist4headercolorgb = true then ls_modifysyntax += 'datawindow.header.color="' + string(setlist4headercolor) + '"~r~n'
	if setlist4summarycolorgb = true and ll_summaryheight > 20 then ls_modifysyntax += 'datawindow.summary.color="' + string(setlist4summarycolor) + '"~r~n'
	if setlist4footercolorgb = true and ll_footerheight > 20 then ls_modifysyntax += 'datawindow.footer.color="' + string(setlist4footercolor) + '"~r~n'
end if

ls_modifysyntax += of_setlist4goupcolorsyntax()
ls_modifysyntax += 'dataWindow.selected.mouse=no~r~ndataWindow.Grid.columnmove=no~r~n'
ls_error = idw_target.modify(ls_createsyntax)
if len(ls_error) > 0 then
	::clipboard(ls_createsyntax)
	messagebox("error", idw_target.classname() + " syntax create failure!! : " + ls_error)
	return -1
end if

of_setrectline4design(isrect2obj, ll_rect2cnt)

ls_error = idw_target.modify(ls_modifysyntax)
if len(ls_error) > 0 then
	::clipboard(ls_modifysyntax)
	messagebox("error", idw_target.classname() + " syntax modification failure!! : " + ls_error)
	return -1
end if

inv_handle.event oue_setobjectsignup(isobjects[], isrect2obj[], is_sort4colnm[], il_sort4col2xpos[], il_sort4col2width[])
//inv_handle.of_setdesignupdate1st(isasissyntax4style)

return 1
end function

public function string of_thisname ();return 'fw_n_style_grid'

end function

public function long of_resetwidtheditableicon ();string ls_object, ls_objarr[]
string ls_syntax
long i, ll_objcnt

ls_object = idw_target.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	if right(ls_objarr[i], 13) = '_editableicon' then
		ls_syntax += ls_objarr[i] + '.width="23"~r~n'
	end if
next

if ls_syntax <> '' then
	idw_target.modify(ls_syntax)
end if

return 0

end function

public subroutine of_resize (integer sizetype, long newwidth, long newheight);// 상단 Border 사이즈
If Isvalid(iln_top) Then
	iln_top.width = newwidth + pixelstounits(2, xpixelstounits!)
End If

// 하단 Border 사이즈
If Isvalid(iln_bottom) Then
	iln_bottom.y = idw_target.y + newheight
	iln_bottom.width = newwidth + pixelstounits(2, xpixelstounits!)
End If

// 좌측 Border 사이즈
If Isvalid(iln_left) Then
	iln_left.height = newheight + pixelstounits(2, ypixelstounits!)
End If

// 우측 Border 사이즈
If Isvalid(iln_right) Then
	iln_right.x = idw_target.x + newwidth
	iln_right.height = newheight + pixelstounits(2, ypixelstounits!)
End If

If Isvalid(iln_top) and Isvalid(iln_bottom) and Isvalid(iln_left) and Isvalid(iln_right) Then This.Post of_drawborderpos() /* to-be */
end subroutine

public subroutine of_move (long xpos, long ypos);If IsValid(iln_top) Then
	iln_top.x = xpos - pixelstounits(1, xpixelstounits!)
	iln_top.y = ypos - pixelstounits(1, ypixelstounits!)
End If

If IsValid(iln_bottom) Then
	iln_bottom.x = xpos - pixelstounits(1, xpixelstounits!)
	iln_bottom.y = ypos + idw_target.height + pixelstounits(1, ypixelstounits!)
End If

If IsValid(iln_left) Then
	iln_left.x = xpos - pixelstounits(1, xpixelstounits!)
	iln_left.y = ypos - pixelstounits(1, ypixelstounits!)
End If

If IsValid(iln_right) Then
	iln_right.x = xpos + idw_target.width + pixelstounits(1, xpixelstounits!)
	iln_right.y = ypos - pixelstounits(1, ypixelstounits!)
End If

If Isvalid(iln_top) and Isvalid(iln_bottom) and Isvalid(iln_left) and Isvalid(iln_right) Then This.Post of_drawborderpos() /* to-be */

end subroutine

public subroutine of_drawborderdestoy ();
end subroutine

public subroutine of_setpointheaderstate (boolean ab_boolean);
end subroutine

on fw_n_style_grid.create
call super::create
end on

on fw_n_style_grid.destroy
call super::destroy
end on

event oue_mouseleave;call super::oue_mouseleave;/* as-is service false */
idw_target.modify('list4alrowcolor_t.text=""')
idw_target.setredraw(true)
end event

event oue_mouseover;call super::oue_mouseover;/* as-is service false */
idw_target.modify('list4alrowcolor_t.text="' + string(al_row) + '"')
idw_target.setredraw(true)
end event

