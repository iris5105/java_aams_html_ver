forward
global type fw_n_style_free from fw_n_style
end type
end forward

global type fw_n_style_free from fw_n_style
end type
global fw_n_style_free fw_n_style_free

type variables

end variables

forward prototypes
public function integer of_applydesign ()
public function string of_thisname ()
public subroutine of_move (long xpos, long ypos)
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
end prototypes

public function integer of_applydesign ();if not isvalid(idw_target) Then return -1

string	ls_createsyntax = ''
string	ls_modifysyntax = ''
string	ls_error
string	ls_temp, ls_tempsyntax
Long		ll_objcnt, i, ll_pos

// column border 및 background color 설정
Long		ll_xpos, ll_ypos, ll_width, ll_height
string	ls_border, ls_objtype, ls_editstyle
string	ls_visible, ls_protect
string	ls_objbgcolor, ls_band, ls_bandheight, ls_bandcolor
Long		ll_rect2cnt = 0, ll_setrectfocuscolor
Long		ll_cellxpos, ll_cellypos, ll_cellwidth, ll_cellheight

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.biznode11te(111, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

idw_target.Modify(gnv_extfunc.istr_node4value.cstr16 + gnv_vari.is_nodekey + "'")
ls_temp		= idw_target.Describe(gnv_extfunc.istr_node4value.cstr01)
ll_objcnt	= fw_f_obj2array(ls_temp, "~t", isobjects[])
for i = 1 to ll_objcnt
	ls_objtype = idw_target.describe(isobjects[i] + ".Type")
	ls_editstyle = idw_target.describe(isobjects[i] + ".Edit.Style")
	
	if Not (ls_objtype = gnv_extfunc.istr_node4value.cstr03 or ls_objtype = gnv_extfunc.istr_node4value.cstr04 or ls_objtype = gnv_extfunc.istr_node4value.cstr05) Then continue

	ls_border		= idw_target.describe(isobjects[i] + ".Border")
	ls_band			= idw_target.describe(isobjects[i] + ".Band")
	ls_bandcolor	= idw_target.describe("Datawindow." + ls_band + ".Color")
	ls_bandheight	= idw_target.describe("DataWindow." + ls_band + ".Height")
	ll_ypos			= Long(idw_target.describe(isobjects[i] + ".y"))
	// 화면에 위치 하지 않는 컨트롤 제외
	if ls_band = "?" or ls_band = "!" Then continue
	if ls_border <> "2" Then Continue
	if ls_bandheight = "?" or ls_bandheight = "!" Then continue
	if  ll_ypos > Long(ls_bandheight) Then continue
	/* to-be */
	ll_xpos		= Long(idw_target.describe(isobjects[i] + ".x"))
	ll_width		= Long(idw_target.describe(isobjects[i] + ".width"))
	ll_height	= Long(idw_target.describe(isobjects[i] + ".height"))
	
	// visible property
	ls_visible = idw_target.describe(isobjects[i] + ".Visible")
	if left(ls_visible, 1) = '"' and right(ls_visible, 1) = '"' Then
		ls_visible = mid(ls_visible, 2, len(ls_visible) - 2)
	end if
	
	/* 화면 비율일 100%일 경우 와 그렇지 않을 경우 */
	// Cell Border 처리 to-be band별로 별도 처리
	ll_cellxpos	= ll_xpos - Long(PixelsToUnits(1, XPixelsToUnits!))
	ll_cellypos	= ll_ypos - Long(PixelsToUnits(1, YPixelsToUnits!))
	ll_cellwidth	= ll_width + Long(PixelsToUnits(2, XPixelsToUnits!))
	ll_cellheight	= ll_height + Long(PixelsToUnits(2, YPixelsToUnits!))
	// to-be column background color syntax
	ls_tempsyntax = of_setobj4bgcolor_syntax(isobjects[i], ls_objtype)
	if not(ls_tempsyntax = 'empty') Then ls_createsyntax += ls_tempsyntax
	// to-be column background color
	ls_objbgcolor = of_setobj4bgcolor(isobjects[i], ls_objtype, ls_band)
	ls_modifysyntax += isobjects[i] + '.Background.Color="' + ls_objbgcolor + '"~r~n'
	ls_modifysyntax += isobjects[i] + '.Background.Mode="0"~r~n'
	/* Background.Mode='1' 로는 Background.Color 변경 못함  transparent는 script에서 변경 못함 */
	// to-be setetc2syntax
	if gnv_vari.getclienttype = 'WEB' Then ls_modifysyntax += of_setetc2syntax(isobjects[i])
	
	// Column Border 처리
	choose case ls_editstyle
		case gnv_extfunc.istr_node4value.cstr12
			ls_modifysyntax += isobjects[i] + '.Edit.FocusRectangle=No~r~n'
			ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
		case gnv_extfunc.istr_node4value.cstr13, gnv_extfunc.istr_node4value.cstr14
			ls_modifysyntax += isobjects[i] + '.Border=~"5~"~r~n'
		case 'checkbox', 'radiobuttons'
			ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
		case else
			ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
	end choose
	
	choose case ls_band
		case 'detail'
			choose case ls_objtype
				case 'text' //gnv_vari.ObjectBackGroundColor[4] gnv_vari.setfreebackcolor
					choose case idw_target.describe(isobjects[i] + ".text")
						case '~~', '/', '-', '.'
							ls_createsyntax += 'create rectangle(band=' + ls_band + ' x="' + string(ll_cellxpos) + '" y="' + string(ll_cellypos) + '" height="' + string(ll_cellheight) + '"' + ' width="' + string(ll_cellwidth) + '" name='  + isobjects[i] + '_rect visible="' + ls_visible + '" brush.hatch="6" brush.color="' + string(gnv_vari.setfreebackcolor) + '"' +  &
												' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setfreebackcolor) + '" background.mode="1" background.color="553648127" )~r~n'
						case else
							ls_createsyntax += 'create rectangle(band=' + ls_band + ' x="' + string(ll_cellxpos) + '" y="' + string(ll_cellypos) + '" height="' + string(ll_cellheight) + '"' + ' width="' + string(ll_cellwidth) + '" name='  + isobjects[i] + '_rect visible="' + ls_visible + '" brush.hatch="6" brush.color="' + string(gnv_vari.setfreebackcolor) + '"' +  &
												' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824~t' + string(gnv_vari.setrectnormalcolor) + '" background.mode="0" background.color="553648127" )~r~n'
					end choose
				case 'column', 'compute' //if ls_editstyle = "checkbox" or ls_editstyle = "radiobuttons" Then
					if idw_target.setedittoken = true Then
						ll_setrectfocuscolor = gnv_vari.setrectfocuscolor
					else
						ll_setrectfocuscolor = gnv_vari.setrectnormalcolor
					end if
					choose case ls_editstyle
						case 'checkbox', 'radiobuttons'
							ls_createsyntax += 'create rectangle(band=' + ls_band + ' x="' + string(ll_cellxpos) + '" y="' + string(ll_cellypos) + '" height="' + string(ll_cellheight) + '"' + ' width="' + string(ll_cellwidth) + '" name='  + isobjects[i] + '_rect visible="' + ls_visible + '" brush.hatch="6" brush.color="' + string(ls_objbgcolor) + '"' +  &
												' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824' + of_getinnersyntax('~tif(currentRow() = getrow() and Describe("DataWindow.Footer.Pointer") = "' + isobjects[i] + '", ' + string(ll_setrectfocuscolor) + ', ' + string(gnv_vari.setrectnormalcolor) + ')') + '" background.mode="0" background.color="553648127" )~r~n'
						case else
							ls_createsyntax += 'create rectangle(band=' + ls_band + ' x="' + string(ll_cellxpos) + '" y="' + string(ll_cellypos) + '" height="' + string(ll_cellheight) + '"' + ' width="' + string(ll_cellwidth) + '" name='  + isobjects[i] + '_rect visible="' + ls_visible + '" brush.hatch="6" brush.color="' + string(ls_objbgcolor) + '"' +  &
												' pen.style="0" pen.width="' + string(PixelsToUnits(1, XPixelsToUnits!)) + '" pen.color="1073741824' + of_getinnersyntax('~tif(currentRow() = getrow() and Describe("DataWindow.Footer.Pointer") = "' + isobjects[i] + '", ' + string(ll_setrectfocuscolor) + ', ' + string(gnv_vari.setrectnormalcolor) + ')') + '" background.mode="0" background.color="553648127" )~r~n'
					end choose
			end choose
			ll_rect2cnt ++
			isrect2obj[ll_rect2cnt] = isobjects[i] + '_rect'
	end choose
next

ls_modifysyntax += 'datawindow.color="' + string(gnv_vari.setfreebackcolor) + '"'

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
inv_handle.of_setdesignupdate1st(isasissyntax4style)

return 1
end function

public function string of_thisname ();return 'fw_n_style_free'

end function

public subroutine of_move (long xpos, long ypos);If IsValid(iln_top) Then
	iln_top.x = xpos - PixelsToUnits(1, XPixelsToUnits!)
	iln_top.y = ypos - PixelsToUnits(1, YPixelsToUnits!)
End If

If IsValid(iln_bottom) Then
	iln_bottom.x = xpos - PixelsToUnits(1, XPixelsToUnits!)
	iln_bottom.y = ypos + idw_target.height + PixelsToUnits(1, YPixelsToUnits!)
End If

If IsValid(iln_left) Then
	iln_left.x = xpos - PixelsToUnits(1, XPixelsToUnits!)
	iln_left.y = ypos - PixelsToUnits(1, YPixelsToUnits!)
End If

If IsValid(iln_right) Then
	iln_right.x = xpos + idw_target.width + PixelsToUnits(1, XPixelsToUnits!)
	iln_right.y = ypos - PixelsToUnits(1, YPixelsToUnits!)
End If

If Isvalid(iln_top) and Isvalid(iln_bottom) and Isvalid(iln_left) and Isvalid(iln_right) Then This.Post of_drawborderpos() /* to-be */

end subroutine

public subroutine of_resize (integer sizetype, long newwidth, long newheight);// 상단 Border 사이즈
If Isvalid(iln_top) Then
	iln_top.width = newwidth + PixelsToUnits(2, XPixelsToUnits!)
End If

// 하단 Border 사이즈
If Isvalid(iln_bottom) Then
	iln_bottom.y = idw_target.y + newheight
	iln_bottom.width = newwidth + PixelsToUnits(2, XPixelsToUnits!)
End If

// 좌측 Border 사이즈
If Isvalid(iln_left) Then
	iln_left.height = newheight + PixelsToUnits(2, YPixelsToUnits!)
End If

// 우측 Border 사이즈
If Isvalid(iln_right) Then
	iln_right.x = idw_target.x + newwidth
	iln_right.height = newheight + PixelsToUnits(2, YPixelsToUnits!)
End If

If Isvalid(iln_top) and Isvalid(iln_bottom) and Isvalid(iln_left) and Isvalid(iln_right) Then This.Post of_drawborderpos() /* to-be */

end subroutine

on fw_n_style_free.create
call super::create
end on

on fw_n_style_free.destroy
call super::destroy
end on

