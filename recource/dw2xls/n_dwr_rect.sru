forward
global type n_dwr_rect from n_dwr_field
end type
end forward

global type n_dwr_rect from n_dwr_field
end type
global n_dwr_rect n_dwr_rect

type variables

protected long il_cached_pen_width = -1
protected string is_expr_pen_width = "-"
protected long il_cached_pen_height = -1
protected string is_expr_pen_height = "-"

protected n_dwr_sub inv_sub

protected constant long RT_SOLID_NO_BORDER = 1
protected constant long RT_SOLID_WITH_BORDER = 2  
protected constant long RT_ONLY_BORDER = 3

protected long il_rect_type

protected constant int BH_SOLID = 6
protected constant int BH_TRANSPARENT = 7

protected constant int PS_INVISIBLE = 5
protected constant int PS_SOLID = 6

protected n_dwr_rect inv_border

protected n_dwr_rect_band inv_band // band for nested objects
end variables

forward prototypes
public function long of_get_pen_width (long al_row)
public function long of_get_pen_height (long al_row)
public function any of_getvalue (long al_row)
public function string of_descr_numformat ()
public function integer of_setformat ()
public function long of_descr_bg_color2 ()
public function long of_descr_color2 ()
public function string of_get_item_coltype ()
private function integer of_get_column_display_type ()
public function long of_descr_alignment2 ()
public function string of_descr_font_face ()
public function boolean of_descr_font_italic ()
public function integer of_descr_font_underline ()
public function boolean of_descr_font_weight ()
public function long of_descr_font_charset ()
public function integer of_descr_font_escapement ()
public function long of_descr_font_family ()
public function integer of_descr_font_weight2 ()
public function integer of_init (string as_dwo_name, integer ai_dwo_type)
public function integer of_register_dynamic (powerobject apo_requestor)
public function boolean of_render (n_dwr_worksheet anv_sheet, long al_row, long al_base_y, long al_units, n_dwr_progress apo_progress)
public function long of_get_x1 (long al_row)
public function long of_get_y1 (long al_row)
public function long of_get_width (long al_row)
public function long of_get_height (long al_row)
public function integer of_add_field (readonly string as_name, long al_instance_id)
public function boolean of_isinside (long al_x1, long al_y1, long al_x2, long al_y2)
public subroutine of_getbgrect (ref st_rect ast_rect, long al_row)
public subroutine of_dispose ()
public function integer of_initband (powerobject anv_parent_band)
public function integer of_do_static_x_markup (n_dwr_worksheet anv_sheet)
end prototypes

public function long of_get_pen_width (long al_row);long ll_ret 
If is_expr_pen_width = "" Then
	ll_ret = il_cached_pen_width
ElseIf is_expr_pen_width = "-" Then
	il_cached_pen_width = of_describe_expr(is_dwo_name + '.pen.width', al_row, is_expr_pen_width)
	il_cached_pen_width = il_cached_pen_width * inv_sub.of_get_pen_width_coef(ii_units)
	ll_ret = il_cached_pen_width
Else 
	ll_ret = of_evaluate0(is_expr_pen_width, al_row)
End If
Return ll_ret

end function

public function long of_get_pen_height (long al_row);long ll_ret 
If is_expr_pen_height = "" Then
	ll_ret = il_cached_pen_height
ElseIf is_expr_pen_height = "-" Then
	il_cached_pen_height = of_describe_expr(is_dwo_name + '.pen.width', al_row, is_expr_pen_height)
	il_cached_pen_height = il_cached_pen_height * inv_sub.of_get_pen_height_coef(ii_units)
	ll_ret = il_cached_pen_height
Else 
	ll_ret = of_evaluate0(is_expr_pen_height, al_row)
End If
Return ll_ret
end function

public function any of_getvalue (long al_row);
Return ""
end function

public function string of_descr_numformat ();Return "[General]"
end function

public function integer of_setformat ();integer li_ret = 1
string ls_format
integer li_color_index
long ll_color


inv_format = inv_book.of_CreateFormat()
    
if li_ret = 1 then
	ls_format = of_descr_numformat()
	if ls_format = '' then ls_format = '[General]'
	ls_format = of_change_format(ls_format, is_coltype)

   inv_format.SetNumFormat(inv_format.handle, ls_format)  
	inv_format.SetFontName(inv_format.handle, of_descr_font_face())
	inv_format.SetFontSize(inv_format.handle, of_descr_font_height())
   if of_descr_font_italic() then inv_format.SetFontItalic(inv_format.handle, 1)
   inv_format.SetFontUnderline(inv_format.handle, of_descr_font_underline())
   inv_format.setFontWeight(inv_format.handle, of_descr_font_weight2())
   inv_format.setHAlign(inv_format.handle, of_descr_alignment2())
   inv_format.setVAlign(inv_format.handle, inv_const.ALIGN_TOP) 
   if is_coltype = 's' then inv_format.setWrap(inv_format.handle, 1) 
	ll_color = of_descr_color2()
	inv_format.setFgColor(inv_format.handle, ll_color)
	ll_color = of_descr_bg_color2()
   inv_format.setBgColor(inv_format.handle, ll_color)
	inv_format.SetFontCharset(inv_format.handle, of_descr_font_charset())
	inv_format.SetFontFamily(inv_format.handle, of_descr_font_family())
	inv_format.SetRotation(inv_format.handle, of_descr_font_escapement())
end if
	 
if li_ret = 1 then
	ib_custom_format =  (ib_color_expr          or ib_bg_color_expr    or ib_alignment_expr or &
	                     ib_font_face_expr      or ib_font_height_expr or ib_font_italic_expr or &
								ib_font_underline_expr or ib_font_weight_expr or ib_format_expr or ib_font_escapement_expr)
								
	If Not ib_custom_format Then
		il_format_ix = inv_book.of_AddFormat(inv_format)								
	End If
end if  

return li_ret
end function

public function long of_descr_bg_color2 ();integer li_ret 
string ls_str
string ls_value
long ll_color

ll_color = 1073741824 //0x40000000, Window Background
if il_rect_type = RT_ONLY_BORDER then
	li_ret = of_check_property('Pen.Color', ib_bg_color_expr, is_bg_color_expr, ls_value)
else
	li_ret = of_check_property('Brush.Color', ib_bg_color_expr, is_bg_color_expr, ls_value)
end if
if li_ret = 1 then
	 if isNumber(ls_value) then
		 ll_color = long(ls_value) 
	 end if
end if

return ll_color



end function

public function long of_descr_color2 ();Long ll_color = 1073741824 //0x40000000, Window Background
// this is just dummy method,
// bgcolor is used as color for lines or rectangles
Return ll_color

end function

public function string of_get_item_coltype ();Return "s"
end function

private function integer of_get_column_display_type ();Return CDT_TEXT

end function

public function long of_descr_alignment2 ();Return inv_const.ALIGN_LEFT
end function

public function string of_descr_font_face ();Return 'Arial'
end function

public function boolean of_descr_font_italic ();Return false
end function

public function integer of_descr_font_underline ();Return 0
end function

public function boolean of_descr_font_weight ();Return false
end function

public function long of_descr_font_charset ();Return 0
end function

public function integer of_descr_font_escapement ();Return 0
end function

public function long of_descr_font_family ();Return 2
end function

public function integer of_descr_font_weight2 ();Return 400


end function

public function integer of_init (string as_dwo_name, integer ai_dwo_type);int li_ret = 1
int li_brush_hatch, li_pen_style

is_dwo_name = as_dwo_name
ii_dwo_type = ai_dwo_type
is_coltype = 's'
is_text = ""

if li_ret = 1 then
	Choose Case ipo_requestortype 
		Case DataWindow!
			il_dw_row_count = idw_requestor.RowCount()
		Case DataStore!
			il_dw_row_count = ids_requestor.RowCount()
		Case DataWindowChild!
			il_dw_row_count = idwc_requestor.RowCount()
		Case Else
			li_ret = -1
	End Choose  
end if


if li_ret = 1 then
	choose case ii_dwo_type
		case DT_RECT
			li_brush_hatch = integer(of_describe(is_dwo_name + '.brush.hatch'))
			li_pen_style = integer(of_describe(is_dwo_name + '.pen.style'))
			if li_brush_hatch <> BH_SOLID and li_pen_style <> PS_INVISIBLE then
				il_rect_type = RT_ONLY_BORDER
			elseif li_brush_hatch = BH_SOLID and li_pen_style <> PS_INVISIBLE then
				il_rect_type = RT_SOLID_WITH_BORDER
				inv_border = create n_dwr_rect	
				inv_border.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_band_bg)
				inv_border.of_init(is_dwo_name, /*n_dwr_field.*/DT_RECT_BORDER)
			elseif li_brush_hatch = BH_SOLID and li_pen_style = PS_INVISIBLE then
				il_rect_type = RT_SOLID_NO_BORDER
			else
				li_ret = -1
			end if
		case DT_RECT_BORDER
			il_rect_type = RT_ONLY_BORDER
		case else  
			li_ret = -1
	end choose
end if

if li_ret = 1 then
	ii_column_display_type = of_get_column_display_type()
   li_ret = of_setformat()
end if

if li_ret = 1 then
	ii_units = integer(of_describe('Datawindow.Units'))
	inv_sub = create n_dwr_sub
	inv_sub.of_set_cur_units(ii_units) 
end if

return li_ret
end function

public function integer of_register_dynamic (powerobject apo_requestor);
super::of_register_dynamic(apo_requestor)
If il_rect_type = RT_SOLID_WITH_BORDER Then
	inv_border.of_register_dynamic(apo_requestor)
End If
Return 1
end function

public function boolean of_render (n_dwr_worksheet anv_sheet, long al_row, long al_base_y, long al_units, n_dwr_progress apo_progress);long ll_x1, ll_x2, ll_y1, ll_y2, ll_format, ll_pen_width, ll_pen_height

If il_rect_type = RT_SOLID_WITH_BORDER Then
	inv_border.of_Render(anv_sheet, al_row, al_base_y, al_units, apo_progress)
End If

ll_x1 = of_get_x1(al_row)
ll_x2 = of_get_x2(al_row)
ll_y1 = of_get_y1(al_row) + al_base_y
ll_y2 = of_get_y2(al_row) + al_base_y
ll_pen_width = of_get_pen_width(al_row)
ll_pen_height = of_get_pen_height(al_row)
ll_format = of_get_format(al_row)

Choose Case il_rect_type 
	Case RT_ONLY_BORDER
		/*
				  top
				--------
		left  |      | right
				--------
				 bottom
		*/
		//top
		anv_sheet.of_create_cell(&
			ll_x1, &
			ll_x2, &
			ll_y1, &
			ll_y1 + ll_pen_height, &
			"", &
			ll_format, &
			al_units &
			)
		//bottom
		anv_sheet.of_create_cell(&
			ll_x1, &
			ll_x2, &
			ll_y2 - ll_pen_height, &
			ll_y2, &
			"", &
			ll_format, &
			al_units &
			)
		//left			
		anv_sheet.of_create_cell(&
			ll_x1, &
			ll_x1 + ll_pen_width, &
			ll_y1 + ll_pen_height, &
			ll_y2 - ll_pen_height, &
			"", &
			ll_format, &
			al_units &
			)
		//right			
		anv_sheet.of_create_cell(&
			ll_x2 - ll_pen_width, &
			ll_x2, &
			ll_y1 + ll_pen_height, &
			ll_y2 - ll_pen_height, &
			"", &
			ll_format, &
			al_units &
			)
			
	Case RT_SOLID_NO_BORDER
//		anv_sheet.of_create_cell(&
//			ll_x1, &
//			ll_x2, &
//			ll_y1, &
//			ll_y2, &
//			"", &
//			ll_format, &
//			al_units &
//			)
//	Case RT_SOLID_WITH_BORDER
//		anv_sheet.of_create_cell(&
//			ll_x1 + ll_pen_width, &
//			ll_x2 - ll_pen_width, &
//			ll_y1 + ll_pen_height, &
//			ll_y2 - ll_pen_height, &
//			"", &
//			ll_format, &
//			al_units &
//			)
End Choose

If IsValid(inv_band) Then
	inv_band.of_process_row(al_row, al_base_y, apo_progress)
End If

Return True
end function

public function long of_get_x1 (long al_row);long ll_x1

ll_x1 = super::of_get_x1(al_row)

Choose Case il_rect_type 
	Case RT_ONLY_BORDER, RT_SOLID_WITH_BORDER
		ll_x1 -= of_get_pen_width(al_row) / 2
End Choose

Return ll_x1

end function

public function long of_get_y1 (long al_row);long ll_y1

ll_y1 = super::of_get_y1(al_row)

Choose Case il_rect_type 
	Case RT_ONLY_BORDER, RT_SOLID_WITH_BORDER
		ll_y1 -= of_get_pen_height(al_row) / 2
End Choose

Return ll_y1

end function

public function long of_get_width (long al_row);long ll_width

ll_width = super::of_get_width(al_row)

Choose Case il_rect_type 
	Case RT_ONLY_BORDER, RT_SOLID_WITH_BORDER
		ll_width += of_get_pen_width(al_row) 
End Choose

Return ll_width

end function

public function long of_get_height (long al_row);long ll_height

ll_height = super::of_get_height(al_row)

Choose Case il_rect_type 
	Case RT_ONLY_BORDER, RT_SOLID_WITH_BORDER
		ll_height += of_get_pen_height(al_row)
End Choose

Return ll_height

end function

public function integer of_add_field (readonly string as_name, long al_instance_id);int li_ret
n_dwr_field lnvo_field

SetNull(lnvo_field)
li_ret = inv_band.of_add_field(as_name, al_instance_id, lnvo_field)

Return li_ret
end function

public function boolean of_isinside (long al_x1, long al_y1, long al_x2, long al_y2);long ll_x1, ll_x2, ll_y1, ll_y2

ll_x1 = of_get_x1()
ll_x2 = of_get_x2()
ll_y1 = of_get_y1()
ll_y2 = of_get_y2()


Return (ll_x1 <= al_x1 And al_x2 <= ll_x2 And ll_y1 <= al_y1 And al_y2 <= ll_y2)
end function

public subroutine of_getbgrect (ref st_rect ast_rect, long al_row);long ll_x1, ll_x2, ll_y1, ll_y2, ll_pen_width, ll_pen_height


ll_x1 = of_get_x1(al_row)
ll_x2 = of_get_x2(al_row)
ll_y1 = of_get_y1(al_row)
ll_y2 = of_get_y2(al_row)
ll_pen_width = of_get_pen_width(al_row)
ll_pen_height = of_get_pen_height(al_row)

Choose Case il_rect_type 
	Case RT_ONLY_BORDER, RT_SOLID_WITH_BORDER
		ast_rect.x1 = ll_x1 + ll_pen_width
		ast_rect.x2 = ll_x2 - ll_pen_width
		ast_rect.y1 = ll_y1 + ll_pen_height
		ast_rect.y2 = ll_y2 - ll_pen_height
			
	Case RT_SOLID_NO_BORDER
		ast_rect.x1 = ll_x1
		ast_rect.x2 = ll_x2
		ast_rect.y1 = ll_y1
		ast_rect.y2 = ll_y2
End Choose


end subroutine

public subroutine of_dispose ();
call super::of_dispose

SetNull(inv_band)
SetNull(inv_border)


end subroutine

public function integer of_initband (powerobject anv_parent_band);int li_ret = 1

inv_band = Create n_dwr_rect_band
inv_band.of_SetParent(this)

inv_band.of_CopyFrom(anv_parent_band)


Choose Case il_rect_type 
	Case RT_ONLY_BORDER
		// no BG
	Case RT_SOLID_NO_BORDER, RT_SOLID_WITH_BORDER
		inv_band.of_Init_Bg_Fillers()
	Case Else
		// error
End Choose

Return li_ret
end function

public function integer of_do_static_x_markup (n_dwr_worksheet anv_sheet);// Records all static X coordinates 
// Returns 1 if all X coordinates are static 
// Otherwise returns -1 and some of X might be not recorded
//

Int li_ret = 1

long ll_x1, ll_x2, ll_pen_width

ll_x1 = of_get_x1(1)
ll_x2 = of_get_x2(1)
ll_pen_width = of_get_pen_width(1)

If is_expr_x1 <> "" Or is_expr_x2 <> "" Or is_expr_pen_width <> "" Then
	Return -1
End If

If il_rect_type = RT_SOLID_WITH_BORDER Then
	inv_border.of_do_static_x_markup(anv_sheet)
End If

Choose Case il_rect_type 
	Case RT_ONLY_BORDER
		// 4 points
		anv_sheet.AddXInterval(anv_sheet.Handle, ll_x1, ll_x1 + ll_pen_width, ii_units)
		anv_sheet.AddXInterval(anv_sheet.Handle, ll_x2 - ll_pen_width, ll_x2, ii_units)
	Case RT_SOLID_NO_BORDER
		// 2 point
		// disabled because corresponding case in of_render is disabled too
		// anv_sheet.AddXInterval(anv_sheet.Handle, ll_x1, ll_x2, ii_units)
	Case RT_SOLID_WITH_BORDER
		// Do nothing as inv_border will do it
End Choose

If IsValid(inv_band) Then
	li_ret = inv_band.of_do_static_x_markup(anv_sheet)
End If

Return li_ret

end function

on n_dwr_rect.create
call super::create
end on

on n_dwr_rect.destroy
call super::destroy
end on

