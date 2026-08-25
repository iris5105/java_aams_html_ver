forward
global type fw_n_style_crtab from fw_n_style
end type
end forward

global type fw_n_style_crtab from fw_n_style
end type
global fw_n_style_crtab fw_n_style_crtab

type variables
public:
	/* to-be */
	string		crosstabheader
	
	long HeaderBandColor			= RGB(255,253,253) 
	long SummaryBandColor		= RGB(245,245,245)
	long FooterBandColor			= RGB(245,245,245)
	long DatawindowColor			= RGB(255,255,255)

	long EditableColumnBorderColor	= RGB(255,255,255)
end variables

forward prototypes
public function integer of_applydesign ()
public function string of_thisname ()
public function long of_resetwidtheditableicon ()
public function long of_getdwomaxwidth ()
public subroutine of_resize (integer sizetype, long newwidth, long newheight)
public subroutine of_move (long xpos, long ypos)
public subroutine of_drawborderdestoy ()
end prototypes

public function integer of_applydesign ();If not isvalid(idw_target) Then return -1

string		ls_newsyntax, ls_syntax, ls_error, ls_setdisplayorder[]
long		ll_headerheight, ll_detailheight, i, ll_pos

// Header Row 디자인
//il_maxwidth = this.of_getdwomaxwidth()
If long(idw_target.describe("Datawindow.header[1].Height")) >= 80 Then CrosstabHeader = 'header[1]'
If long(idw_target.describe("Datawindow.header[2].Height")) >= 80 Then CrosstabHeader = 'header[2]'
If long(idw_target.describe("Datawindow.header[3].Height")) >= 80 Then CrosstabHeader = 'header[3]'

If fw_f_nvls(CrosstabHeader, '') = '' Then return -1
ll_headerheight = long(idw_target.describe("Datawindow." + crosstabheader + ".Height"))

// Header Band Background Image
If setheaderbandimage <> '' Then
	If ll_headerheight > 100 Then setheaderbandimage = '..\img\datawindow\img4header2st.jpg'

	If gnv_vari.getclienttype = 'PB' Then
		ls_setdisplayorder[ upperbound(ls_setdisplayorder) + 1 ] = 'img4header'
		ls_newsyntax = 'create bitmap(band=' + CrosstabHeader + ' filename="' + setheaderbandimage + '" x="0" y="0" height="' + string(ll_headerheight) + '" width="' + String(idw_target.Width) + '" border="0"  name=img4header visible="1" )~r~n'
	else
		ls_newsyntax = 'bitmap(band=' + CrosstabHeader + ' filename="' + setheaderbandimage + '" x="0" y="0" height="' + string(ll_headerheight) + '" width="' + String(idw_target.Width) + '" border="0"  name=img4header visible="1" )~r~n'
	End If	
End If

// Detail Row 디자인  33554432
ls_syntax += 'create text(band=header alignment="2" text="" border="0" color="33554432" x="841" y="8" height="76" width="2633" html.valueishtml="0" name=list4alrowcolor_t visible="0" font.face="Tahoma" font.height="-9" font.weight="400" font.family="2" font.pitch="1" font.charset="129" background.mode="1" background.color="536870912" )~r~n'
ls_syntax += 'Datawindow.Detail.Color="536870912~tIf(long(describe(~~~"list4alrowcolor_t.text~~~")) = getrow(), ' + string(MouseOverRowColor) + ', If(mod(getrow(), 2) = 0, ' + string(gnv_vari.AlternateSecondRowcolor) + ', ' + string(gnv_vari.alternatefirstrowcolor) + '))"~r~n'

// Column Border 디자인
long ll_objcnt, ll_tabseq
long ll_xpos, ll_ypos
long ll_width, ll_height
string ls_temp, ls_objname
string ls_band, ls_visible
string ls_bgcolor
boolean lb_editable

ll_objcnt = long(idw_target.describe("Datawindow.Column.Count"))

// datawindow background color 설정// Header Band Color
If setheaderbandimage = '' Then ls_syntax += 'Datawindow.' + CrosstabHeader + '.Color="' + string(HeaderBandColor) + '"~r~n'

ls_syntax += 'DataWindow.Summary.Color="' + string(SummaryBandColor) + '"~r~n'
ls_syntax += 'DataWindow.Footer.Color="' + string(FooterBandColor) + '"~r~n'

ls_syntax += of_setlist4goupcolorsyntax()

If gnv_vari.getclienttype = 'PB' Then
	ls_newsyntax += ls_syntax
	
	ls_error = idw_target.modify(ls_newsyntax)
	If ls_error <> '' Then
		::clipboard(ls_newsyntax)
		messagebox("syntax modify", "fw_n_style_crtab, syntax modIfication failed!~r~n" + ls_error)
		return -1
	End If
	
	//for i = 1 to upperbound(ls_setdisplayorder)
	//	idw_target.setposition(ls_setdisplayorder[i], '', false)
	//next
	
	return 1
End If

ls_error = idw_target.modify(ls_syntax)
If ls_error <> '' Then
	::clipboard(ls_syntax)
	messagebox("syntax modify", "fw_n_style_crtab, syntax modIfication failed!~r~n" + ls_error)
	return -1
End If

// create background image
string ls_dwsyntax
string ls_findstr[] = { "column(name", "compute(name", "text(name" }
long ll_minpos = 2147483647

If ls_newsyntax <> '' Then
	ls_dwsyntax = idw_target.describe("datawindow.syntax")
	for i = 1 to upperbound(ls_findstr)
		ll_pos = pos(ls_dwsyntax, ls_findstr[i])
		If ll_pos > 0 Then
			If ll_pos < ll_minpos Then ll_minpos = ll_pos
		End If
	next
	
	If ll_minpos > 0 Then
		ls_dwsyntax = replace(ls_dwsyntax, ll_minpos, 0, ls_newsyntax)
		If idw_target.Create(ls_dwsyntax, ls_error) = -1 Then
			::clipboard(idw_target.classname() + "~r~n" + ls_dwsyntax)
			messagebox("Error", idw_target.classname() + " Syntax ModIfication(Create) Failure!! : " + ls_error)
			return -1
		End If
		this.of_resetdwdisplayorder(idw_target.classname())
	End If
End If

return 1
end function

public function string of_thisname ();return 'fw_n_style_crtab'

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

public function long of_getdwomaxwidth ();string ls_object, ls_objarr[]
long i, ll_objcnt
long ll_objpos, ll_maxpos

ls_object = idw_target.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
for i = 1 to ll_objcnt
	if fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 then continue
	if idw_target.describe(ls_objarr[i] + ".Band") = CrosstabHeader then
		if idw_target.describe(ls_objarr[i] + ".Visible") = '1' then
			idw_target.SetPosition(ls_objarr[i],'', true)  /* to-be */
			
//			ll_objpos = long(idw_target.describe(ls_objarr[i] + ".X")) + long(idw_target.describe(ls_objarr[i] + ".Width"))
//			if ll_maxpos < ll_objpos then
//				ll_maxpos = ll_objpos
//			end if
		end if
	end if
next

return ll_maxpos

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

on fw_n_style_crtab.create
call super::create
end on

on fw_n_style_crtab.destroy
call super::destroy
end on

event move;call super::move;/* as-is */
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

