forward
global type fw_n_style_trview from fw_n_style
end type
end forward

global type fw_n_style_trview from fw_n_style
end type
global fw_n_style_trview fw_n_style_trview

type variables

end variables

forward prototypes
public function integer of_applydesign ()
public function string of_thisname ()
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
public subroutine of_move (long xpos, long ypos)
public subroutine of_drawborderdestoy ()
end prototypes

public function integer of_applydesign ();If not isvalid(idw_target) Then return -1

String		ls_createsyntax		= ''
String		ls_modifysyntax	= ''
String		ls_error
string		ls_setdisplayorder[]

// Header Band Background Image
If setheaderbandimage <> '' Then
	Long		ll_imgageheight	
	Choose Case gnv_vari.getclienttype
		Case 'WEB'
			ll_imgageheight = il_headerheight - Long(PixelsToUnits(1, YPixelsToUnits!))
		Case 'PB'
			ll_imgageheight = il_headerheight
	End Choose
	If il_headerheight > 100 Then setheaderbandimage = '..\img\datawindow\img4header2st.jpg'
	ls_setdisplayorder[ upperbound(ls_setdisplayorder) + 1 ] = 'img4header'
	ls_createsyntax = 'create bitmap(band=header filename="' + setheaderbandimage + '" x="0" y="0" height="' + String(ll_imgageheight) + '" width="' + String(idw_target.Width) + '" border="0" name=img4header visible="1" )~r~n'
End If

// ibsetlist4filter2dwo, ibsetlist4sort
ls_createsyntax = of_sethd4syntax2effect(ls_createsyntax)
//If idw_target.ibsetlist4filter2dwo = True Then ls_createsyntax = of_sethd4syntax2filter(ls_createsyntax)
//If idw_target.ibsetlist4sort = True Then ls_createsyntax = of_sethd4syntax2sort(ls_createsyntax)

// to-be  'dddw', 'ddlb' Column border 
long		ll_objcnt, i, ll_pos, ll_tabseq
long		ll_ypos, ll_width, ll_height, ll_tmpheight, ll_bandheight
string		ls_temp
string		ls_objtype, ls_editstyle
string		ls_border, ls_band, ls_visible, ls_bgcolor
String		ls_protect, ls_displayonly, ls_columnmarker
string		ls_tabseq
Long		ll_xposedit, ll_yposedit, ll_widthedit, ll_heightedit, ll_robjcnt

ls_temp = idw_target.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_temp, "~t", isobjects[])
for i = 1 to ll_objcnt
	ls_border	= idw_target.describe(isobjects[i] + ".Border")
	ls_band		= idw_target.describe(isobjects[i] + ".Band")
	ls_objtype	= idw_target.describe(isobjects[i] + ".Type")
	ls_editstyle	= idw_target.describe(isobjects[i] + ".Edit.Style")
	//If ls_band = "header" Then continue
		
	// column, text, compute 컬럼인 경우만 디자인 적용
	If (ls_band = '?' or ls_band = '!') Then Continue /* 화면에 있는 object 만 진행 */
	If Not (ls_objtype = "column" or ls_objtype = "text" or ls_objtype = "compute") Then continue
	
	/* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
	ll_bandheight	= Long(idw_target.describe("DataWindow." + ls_band + ".Height"))
	ll_ypos		= Long(idw_target.describe(isobjects[i] + ".y"))
	
	If ll_bandheight <= ll_ypos Then Continue
	
	If idw_target.ibsetlist4alrowcolor = False Then
		// to-be column background color
		ls_bgcolor = of_setobj4bgcolor(isobjects[i], ls_objtype, ls_band)	
		ls_modifysyntax += isobjects[i] + '.Background.Color="' + ls_bgcolor + '"~r~n'	
	End If
	// Column Border 처리
	Choose Case ls_editstyle
		Case 'edit'
			ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
			ls_modifysyntax += isobjects[i] + '.Edit.FocusRectangle=No~r~n'
		Case 'dddw', 'ddlb'
			ll_height	= Long(idw_target.describe(isobjects[i] + ".height")) + Long(PixelsToUnits(2, YPixelsToUnits!))
			ls_modifysyntax += isobjects[i] + '.Border=~"4~"~r~n'
			ls_modifysyntax += isobjects[i] + '.Height=~"' + String(ll_height) + '~"~r~n'
		Case else
			ls_modifysyntax += isobjects[i] + '.Border=~"0~"~r~n'
	End Choose
	ls_modifysyntax += isobjects[i] + '.Background.Mode="0"~r~n'
	/* Background.Mode='1' 로는 Background.Color 변경 못함  transparent는 script에서 변경 못함 //lnv_syntax.of_appEnd(isobjects[i] + '.Background.Mode="2"') */
Next

// Detail Row 디자인 
If idw_target.ibsetlist4alrowcolor = False Then
	ls_modifysyntax += 'Datawindow.Detail.Color="' + string(gnv_vari.alternatesecondrowcolor) +'"~r~n'
Else
	ls_createsyntax += 'create text(band=header alignment="2" text="" border="0" color="33554432" x="841" y="8" height="76" width="2633" html.valueishtml="0" name=list4alrowcolor_t visible="0" font.face="Tahoma" font.height="-9" font.weight="400" font.family="2" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" )~r~n'	
	If fw_f_nvls(islistrowpointexpression1st, '') <> '' Then
		ls_modifysyntax += 'Datawindow.Detail.Color="536870912~tif(long(describe(~~~"list4alrowcolor_t.text~~~")) = getrow(), ' + String(MouseOverRowColor) + ', if(mod(getrow(), 2) = 0, ' + islistrowpointexpression2nd + ', ' + islistrowpointexpression1st + '))"~r~n'
	Else
		ls_modifysyntax += 'Datawindow.Detail.Color="536870912~tif(long(describe(~~~"list4alrowcolor_t.text~~~")) = getrow(), ' + String(MouseOverRowColor) + ', if(mod(getrow(), 2) = 0, ' + String(gnv_vari.alternatesecondrowcolor) + ', ' + String(gnv_vari.alternatefirstrowcolor) + '))"~r~n'
	End If
End If

// datawindow background color 설정// Header Band Color
If setheaderbandimage = '' and setlist4headercolorgb = True Then ls_modifysyntax += 'Datawindow.Header.Color="' + string(setlist4headercolor) + '"~r~n'
If setlist4backcolorgb = True Then ls_modifysyntax += 'DataWindow.Color="' + string(setlist4backcolor) + '"~r~n'
If setlist4summarycolorgb = True Then ls_modifysyntax += 'DataWindow.Summary.Color="' + string(setlist4summarycolor) + '"~r~n'
If setlist4footercolorgb = True Then ls_modifysyntax += 'DataWindow.Footer.Color="' + string(setlist4footercolor) + '"~r~n'

ls_modifysyntax += of_setlist4goupcolorsyntax()

ls_error = idw_target.Modify(ls_createsyntax)
If len(ls_error) > 0 Then
	::clipboard(ls_createsyntax)
	messagebox("Error", idw_target.classname() + " Syntax Create Failure!! : " + ls_error)
	return -1
End If

ls_error = idw_target.Modify(ls_modifysyntax)
If len(ls_error) > 0 Then
	::clipboard(ls_modifysyntax)
	messagebox("Error", idw_target.classname() + " Syntax ModIfication Failure!! : " + ls_error)
	return -1
End If

inv_handle.event oue_setobjectsignup(isobjects[], isrect2obj[], is_sort4colnm[], il_sort4col2xpos[], il_sort4col2width[])
ll_robjcnt = upperbound(ls_setdisplayorder)
For i = ll_robjcnt to 1 Step -1
	idw_target.setposition(ls_setdisplayorder[i], '', False)
Next

inv_handle.of_setdesignupdate1st(isasissyntax4style)

return 1
end function

public function string of_thisname ();return 'fw_n_style_trview'

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

on fw_n_style_trview.create
call super::create
end on

on fw_n_style_trview.destroy
call super::destroy
end on

event move;call super::move;///* as-is */
//if isvalid(iln_top) then
//	iln_top.x = xpos - pixelstounits(1, xpixelstounits!)
//	iln_top.y = ypos - pixelstounits(1, ypixelstounits!)
//end if
//
//if isvalid(iln_bottom) then
//	iln_bottom.x = xpos - pixelstounits(1, xpixelstounits!)
//	iln_bottom.y = ypos + idw_target.height + pixelstounits(1, ypixelstounits!)
//end if
//
//if isvalid(iln_left) then
//	iln_left.x = xpos - pixelstounits(1, xpixelstounits!)
//	iln_left.y = ypos - pixelstounits(1, ypixelstounits!)
//end if
//
//if isvalid(iln_right) then
//	iln_right.x = xpos + idw_target.width + pixelstounits(1, xpixelstounits!)
//	iln_right.y = ypos - pixelstounits(1, ypixelstounits!)
//end if
//
end event

event clicked;call super::clicked;//if row > 0 and row <> idw_target.getrow() then
//	idw_target.setrow(row)
//end if

end event

event oue_mouseleave;call super::oue_mouseleave;idw_target.modify('list4alrowcolor_t.text=""')
idw_target.setredraw(true)

end event

event oue_mouseover;call super::oue_mouseover;idw_target.modify('list4alrowcolor_t.text="' + string(al_row) + '"')
idw_target.setredraw(true)

end event

