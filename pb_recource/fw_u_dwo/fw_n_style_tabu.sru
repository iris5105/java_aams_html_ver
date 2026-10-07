forward
global type fw_n_style_tabu from fw_n_style
end type
end forward

global type fw_n_style_tabu from fw_n_style
end type
global fw_n_style_tabu fw_n_style_tabu

type variables

end variables

forward prototypes
public function integer of_applydesign ()
public function string of_thisname ()
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
public subroutine of_move (long xpos, long ypos)
public subroutine of_drawborderdestoy ()
end prototypes

public function integer of_applydesign ();if not isvalid(idw_target) then return -1

// header Row 디자인
string		ls_createsyntax	= ''
string		ls_modifysyntax	= ''
string		ls_error			= ''
long		ll_rect2cnt = 0
long		ll_objcnt, i, ll_j = 0

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.biznode11te(111, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

// header Band Background Image
if setheaderbandimage <> '' then
	if il_headerheight > 100 then setheaderbandimage = '..\img\datawindow\img4header2st.jpg'
	ll_rect2cnt ++
	isrect2obj[ ll_rect2cnt ] = 'img4header'
	ls_createsyntax = 'create bitmap(band=header filename="' + setheaderbandimage + '" x="0" y="0" height="' + string(il_headerheight - long(PixelsToUnits(1, YPixelsToUnits!))) + '" width="' + string(idw_target.Width) + '" border="0" name=img4header visible="1" )~r~n'
end if

// ibsetlist4filter2dwo, ibsetlist4sort
ls_createsyntax = of_sethd4syntax2effect(ls_createsyntax)
//if idw_target.ibsetlist4filter2dwo = True then
//	ls_modifysyntax = of_sethd4syntax2filter_1sub(ls_modifysyntax, idw_target.ibsetlist4filtertip)
//	ls_createsyntax = of_sethd4syntax2filter(ls_createsyntax)
//end if
//if idw_target.ibsetlist4sort = True then
//	ls_modifysyntax = of_sethd4syntax2sort_1sub(ls_modifysyntax, idw_target.ibsetlist4sort)
//	ls_createsyntax = of_sethd4syntax2sort(ls_createsyntax)
//end if


// detail Row 디자인
ls_modifysyntax = of_setlist4alrowcolor(ls_modifysyntax)

// Column 디자인
string		ls_temp, ls_tempsyntax
string		ls_objtype, ls_editstyle, ls_border, ls_visible, ls_band, ls_objbgcolor
long		ll_headerheight, ll_summaryheight, ll_footerheight
long		ll_xpos, ll_ypos, ll_ypos2, ll_width, ll_height, ll_height1, ll_height2, ll_height3, ll_height4, ll_tmppos

idw_target.modify(gnv_extfunc.istr_node4value.cstr09 + gnv_vari.is_nodekey + "'")
ll_height3	= long(idw_target.Describe(gnv_extfunc.istr_node4value.cstr06))
ls_temp		= idw_target.describe(gnv_extfunc.istr_node4value.cstr01)
ll_objcnt	= fw_f_obj2array(ls_temp, "~t", isobjects[])
for i = 1 to ll_objcnt
	ls_border	= idw_target.describe(isobjects[i] + ".Border")
	ls_band		= idw_target.describe(isobjects[i] + ".Band")
	ls_objtype	= idw_target.describe(isobjects[i] + ".Type")
	ls_editstyle	= idw_target.describe(isobjects[i] + ".Edit.Style")
	//if ls_band = "header" then continue
	
	if (ls_band = gnv_extfunc.istr_node4value.cstr08 or ls_band = gnv_extfunc.istr_node4value.cstr09) then Continue
	if Not (ls_objtype = gnv_extfunc.istr_node4value.cstr03 or ls_objtype = gnv_extfunc.istr_node4value.cstr04 or ls_objtype = gnv_extfunc.istr_node4value.cstr05) then continue
	
	ll_tmppos = Pos(ls_border, "~t")
	if ll_tmppos > 0 then ls_border = mid(ls_border, 2, ll_tmppos - 2)
	if Not(ls_border = gnv_extfunc.istr_node4value.cstr07) then Continue
	
	/* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
	ll_height2	= long(idw_target.describe(gnv_extfunc.istr_node4value.cstr10 + ls_band + ".height"))
	ll_ypos2		= long(idw_target.describe(isobjects[i] + ".y"))
	
	if ll_height2 <= ll_ypos2 then Continue
	
//	if idw_target.ibsetlist4sort = true and ls_band = "detail" then
//		ll_j++
//		is_sort4colnm[ll_j] = idw_target.describe(isobjects[i] + ".name")
//		il_sort4col2xpos[ll_j] = long(idw_target.describe(isobjects[i] + ".x"))
//		il_sort4col2width[ll_j] = long(idw_target.describe(isobjects[i] + ".width"))
//	end if
	
	if idw_target.ibdesign4role = False then // Column Border 처리
		ll_xpos		= long(idw_target.Describe(isobjects[i] + ".x")) - long(pixelstounits(1, XPixelsToUnits!))
		ll_ypos		= long(idw_target.Describe(isobjects[i] + ".y")) - long(pixelstounits(1, YPixelsToUnits!))
		ll_width		= long(idw_target.Describe(isobjects[i] + ".width")) + long(pixelstounits(2, XPixelsToUnits!))
		ll_height	= long(idw_target.Describe(isobjects[i] + ".height")) + long(pixelstounits(2, YPixelsToUnits!))
	else
		ll_xpos		= long(idw_target.Describe(isobjects[i] + ".x")) - long(pixelstounits(1, XPixelsToUnits!))
		ll_ypos		= long(idw_target.Describe(isobjects[i] + ".y")) - long(pixelstounits(4, YPixelsToUnits!))
		ll_width		= long(idw_target.Describe(isobjects[i] + ".width")) + long(pixelstounits(2, XPixelsToUnits!))
		ll_height	= long(idw_target.Describe(isobjects[i] + ".height")) + long(pixelstounits(6, YPixelsToUnits!))
		if ls_band = "header" then ll_height += long(pixelstounits(1, YPixelsToUnits!))
	end if
	
	ls_visible = idw_target.describe(isobjects[i] + ".visible")
	if left(ls_visible, 1) = '"' and right(ls_visible, 1) = '"' then
		ls_visible = mid(ls_visible, 2, len(ls_visible) - 2)
	end if
	// Column Border 처리
	choose case ls_editstyle
		case gnv_extfunc.istr_node4value.cstr12
			ls_modifysyntax += isobjects[i] + '.Edit.FocusRectangle=No~r~n'
			if idw_target.setedittoken = True and ls_objtype = gnv_extfunc.istr_node4value.cstr15 then // Column Border 처리
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
			ll_height1 = long(idw_target.Describe(isobjects[i] + ".height"))
			if idw_target.ibsetlist4orgsizedesign = true then
				ll_height4 = 0
			else
				if idw_target.ibdesign4role = false then
					ll_height4 = ll_height3 - (ll_height1 + ll_ypos2) - long(PixelsToUnits(1, YPixelsToUnits!))
				else
					ll_height4 = long(PixelsToUnits(24, YPixelsToUnits!)) - (ll_height1 + long(PixelsToUnits(3, YPixelsToUnits!))) - long(PixelsToUnits(1, YPixelsToUnits!))
				end if
			end if
			if idw_target.setedittoken = True and ls_objtype = gnv_extfunc.istr_node4value.cstr02 then 
				ls_modifysyntax += of_setlist4edittoken(isobjects[i], ls_objtype, ls_editstyle, ll_height4)
			else	
				ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
				ls_modifysyntax += isobjects[i] + '.height=~"' + string(ll_height1 + ll_height4) + '~"~r~n'
			end if
		case else
			if idw_target.setedittoken = True and ls_objtype = gnv_extfunc.istr_node4value.cstr15 then
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
	ls_modifysyntax += isobjects[i] + '.Background.Mode="0"~r~n'
	/* Background.Mode='1' 로는 Background.color 변경 못함  transparent는 script에서 변경 못함 */
	// to-be setetc2syntax
	if gnv_vari.getclienttype = 'WEB' then ls_modifysyntax += of_setetc2syntax(isobjects[i])

	ll_rect2cnt ++
	isrect2obj[ ll_rect2cnt ] = isobjects[i] + gnv_extfunc.istr_node4value.cstr11
	if idw_target.ibsetlist4clearselect = true then
		if idw_target.ibdesign4role = false then ll_height = il_headerheight
		
		choose case ls_band
			case 'header'
				if setheaderbandimage = '' and setlist4headercolorgb = True then
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setrectnormalcolor) + '"' + & 
										' brush.hatch="6" brush.color="' + string(setlist4headercolor) + '" background.mode="0" background.color="553648127" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
				end if
			case 'detail'
				ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setrectnormalcolor) + '"' + & 
									' brush.hatch="6" brush.color="' + ls_objbgcolor + '" background.mode="0" background.color="553648127" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
			case 'summary'
				if setlist4summarycolorgb = True then 
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setrectnormalcolor) + '"' + & 
										' brush.hatch="6" brush.color="' + string(setlist4summarycolor) + '" background.mode="0" background.color="553648127" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
				end if
			case 'footer'
				if setlist4footercolorgb = True then
					ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setrectnormalcolor) + '"' + & 
										' brush.hatch="6" brush.color="' + string(setlist4footercolor) + '" background.mode="0" background.color="553648127" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
				end if
		end choose
	else
		ls_createsyntax += 'create rectangle(name=' + isobjects[i] + '_rect visible="' + ls_visible+ '" band=' + ls_band + ' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setrectnormalcolor) + '"' + & 
							' brush.hatch="7" brush.color="553648127" background.mode="0" background.color="553648127" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_height) + '" width="' + string(ll_width) + '")~r~n'
	end if
Next
if setlist4backcolorgb = True then ls_modifysyntax += 'datawindow.color="' + string(setlist4backcolor) + '"~r~n'
//tabular issue
ll_headerheight = long(idw_target.Describe("datawindow.header.height"))
ls_modifysyntax += 'datawindow.header.height="' + string(ll_headerheight + long(pixelstounits(1, YPixelsToUnits!))) + '"~r~n'

if idw_target.ibsetlist4clearselect = false then
	ll_summaryheight	= long(idw_target.Describe("datawindow.summary.height"))
	ll_footerheight		= long(idw_target.Describe("datawindow.footer.height"))
	if setheaderbandimage = '' and setlist4headercolorgb = True then ls_modifysyntax += 'datawindow.header.color="' + string(setlist4headercolor) + '"~r~n'
	if setlist4summarycolorgb = True and ll_summaryheight > 20 then ls_modifysyntax += 'datawindow.summary.color="' + string(setlist4summarycolor) + '"~r~n'
	if setlist4footercolorgb = True and ll_footerheight > 20 then ls_modifysyntax += 'datawindow.footer.color="' + string(setlist4footercolor) + '"~r~n'
end if

ls_modifysyntax += of_setlist4goupcolorsyntax()
//ls_modifysyntax += 'dataWindow.selected.mouse=no~r~ndataWindow.Grid.columnmove=no~r~n'

/* to-be */
ls_error = idw_target.modify(ls_createsyntax)
if len(ls_error) > 0 then
	::clipboard(ls_createsyntax)
	messagebox("Error", idw_target.classname() + " Syntax Create Failure!! : " + ls_error)
	return -1
end if

of_setrectline4design(isrect2obj, ll_rect2cnt)

ls_error = idw_target.modify(ls_modifysyntax)
if len(ls_error) > 0 then
	::clipboard(ls_modifysyntax)
	messagebox("Error", idw_target.classname() + " Syntax Modification Failure!! : " + ls_error)
	return -1
end if

inv_handle.event oue_setobjectsignup(isobjects[], isrect2obj[], is_sort4colnm[], il_sort4col2xpos[], il_sort4col2width[])
//inv_handle.of_setdesignupdate1st(isasissyntax4style)

Return 1

end function

public function string of_thisname ();return 'fw_n_style_tabu'

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

on fw_n_style_tabu.create
call super::create
end on

on fw_n_style_tabu.destroy
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

