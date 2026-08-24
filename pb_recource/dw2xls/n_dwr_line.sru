forward
global type n_dwr_line from n_dwr_field
end type
end forward

global type n_dwr_line from n_dwr_field
end type
global n_dwr_line n_dwr_line

type variables

protected long il_cached_pen_width = -1
protected string is_expr_pen_width = "-"
protected long il_cached_pen_height = -1
protected string is_expr_pen_height = "-"

protected n_dwr_sub inv_sub


end variables

forward prototypes
public function long of_get_y1 (long al_row)
public function long of_get_pen_width (long al_row)
public function long of_get_y2 (long al_row)
public function long of_get_pen_height (long al_row)
public function long of_get_x1 (long al_row)
public function long of_get_x2 (readonly long al_row)
public function long of_get_height (long al_row)
public function long of_get_width (long al_row)
public function any of_getvalue (long al_row)
public function string of_descr_numformat ()
public function integer of_setformat ()
public function integer of_get_visible (long al_row)
public function long of_descr_bg_color2 ()
public function long of_descr_color2 ()
public function string of_get_item_coltype ()
private function integer of_get_column_display_type ()
public function long of_descr_alignment2 ()
public function string of_descr_font_face ()
public function boolean of_descr_font_italic ()
public function integer of_descr_font_underline ()
public function boolean of_descr_font_weight ()
public function long of_get_y2 ()
public function long of_get_x1 ()
public function long of_descr_font_charset ()
public function integer of_descr_font_escapement ()
public function long of_descr_font_family ()
public function integer of_descr_font_weight2 ()
public function long of_get_y1 ()
public function long of_get_x2 ()
public function integer of_init (string as_dwo_name, integer ai_dwo_type)
end prototypes

public function long of_get_y1 (long al_row);long ll_ret 
any la_tmp
al_row = al_row + ii_row_in_detail - 1
if al_row > il_dw_row_count then 
   Return 0
end if

If is_expr_y1 = "" Then
	ll_ret = il_base_y + il_cached_y1 - of_get_pen_height(al_row) / 2 
ElseIf is_expr_y1 = "-" Then
	il_cached_y1 = of_describe_expr(is_dwo_name + '.y1', al_row, is_expr_y1) - il_subband_y
	il_cached_y2 = of_describe_expr(is_dwo_name + '.y2', al_row, is_expr_y2) - il_subband_y
	If il_cached_y1 > il_cached_y2 Then
		la_tmp = il_cached_y1; il_cached_y1 = il_cached_y2; il_cached_y2 = la_tmp
		la_tmp = is_expr_y1; is_expr_y1 = is_expr_y2; is_expr_y2 = la_tmp
	End If
	ll_ret = il_base_y + il_cached_y1 - of_get_pen_height(al_row) / 2
Else 
	ll_ret = il_base_y + of_evaluate0(is_expr_y1, al_row) - of_get_pen_height(al_row) / 2 - il_subband_y
End If

Return ll_ret

end function

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

public function long of_get_y2 (long al_row);long ll_ret 
any la_tmp
al_row = al_row + ii_row_in_detail - 1
if al_row > il_dw_row_count then 
   Return 0
end if

If is_expr_y2 = "" Then
	ll_ret = il_base_y + il_cached_y2 + of_get_pen_height(al_row) / 2 
ElseIf is_expr_y2 = "-" Then
	il_cached_y1 = of_describe_expr(is_dwo_name + '.y1', al_row, is_expr_y1) - il_subband_y
	il_cached_y2 = of_describe_expr(is_dwo_name + '.y2', al_row, is_expr_y2) - il_subband_y
	If il_cached_y1 > il_cached_y2 Then
		la_tmp = il_cached_y1; il_cached_y1 = il_cached_y2; il_cached_y2 = la_tmp
		la_tmp = is_expr_y1; is_expr_y1 = is_expr_y2; is_expr_y2 = la_tmp
	End If
	ll_ret = il_base_y + il_cached_y2 + of_get_pen_height(al_row) / 2
Else 
	ll_ret = il_base_y + of_evaluate0(is_expr_y2, al_row) + of_get_pen_height(al_row) / 2 - il_subband_y
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

public function long of_get_x1 (long al_row);long ll_ret 
Any la_tmp
If is_expr_x1 = "" Then
	ll_ret = il_base_x + il_cached_x1 - of_get_pen_width(al_row) / 2
ElseIf is_expr_x1 = "-" Then
	il_cached_x1 = of_describe_expr(is_dwo_name + '.x1', al_row, is_expr_x1)
	il_cached_x2 = of_describe_expr(is_dwo_name + '.x2', al_row, is_expr_x2)
	If il_cached_x1 > il_cached_x2 Then
		la_tmp = il_cached_x1; il_cached_x1 = il_cached_x2; il_cached_x2 = la_tmp
		la_tmp = is_expr_x1; is_expr_x1 = is_expr_x2; is_expr_x2 = la_tmp
	End If
	ll_ret = il_base_x + il_cached_x1 - of_get_pen_width(al_row) / 2
Else 
	ll_ret = il_base_x + of_evaluate0(is_expr_x1, al_row) - of_get_pen_width(al_row) / 2
End If
Return ll_ret


end function

public function long of_get_x2 (readonly long al_row);long ll_ret 
any la_tmp
If is_expr_x2 = "" Then
	ll_ret = il_base_x + il_cached_x2 + of_get_pen_width(al_row) / 2
ElseIf is_expr_x2 = "-" Then
	il_cached_x1 = of_describe_expr(is_dwo_name + '.x1', al_row, is_expr_x1)
	il_cached_x2 = of_describe_expr(is_dwo_name + '.x2', al_row, is_expr_x2)
	If il_cached_x1 > il_cached_x2 Then
		la_tmp = il_cached_x1; il_cached_x1 = il_cached_x2; il_cached_x2 = la_tmp
		la_tmp = is_expr_x1; is_expr_x1 = is_expr_x2; is_expr_x2 = la_tmp
	End If
	ll_ret = il_base_x + il_cached_x2 + of_get_pen_width(al_row) / 2
Else 
	ll_ret = il_base_x + of_evaluate0(is_expr_x2, al_row) + of_get_pen_width(al_row) / 2
End If
Return ll_ret


end function

public function long of_get_height (long al_row);
Return of_get_y2(al_row) - of_get_y1(al_row)
end function

public function long of_get_width (long al_row);
Return of_get_x2(al_row) - of_get_x1(al_row)
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

	string ls_border_style
	 
	ls_border_style = of_describe(is_dwo_name + '.Border') 
	if isNumber(ls_border_style) and integer(ls_border_style) > 0 then
		inv_format.setBorderStyle(inv_format.handle, 1)
	else
		if integer(of_describe ( 'Datawindow.Processing' )) = 1 then
			inv_format.setBorderStyle(inv_format.handle, 7)
		end if
	end if
	ib_custom_format =  (ib_color_expr          or ib_bg_color_expr    or ib_alignment_expr or &
	                     ib_font_face_expr      or ib_font_height_expr or ib_font_italic_expr or &
								ib_font_underline_expr or ib_font_weight_expr or ib_format_expr or ib_font_escapement_expr)
								
	If Not ib_custom_format Then
		il_format_ix = inv_book.of_AddFormat(inv_format)								
	End If
end if  

return li_ret
end function

public function integer of_get_visible (long al_row);int li_ret = 0

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
    li_ret = of_describe_expr(is_dwo_name + '.pen.style', al_row) 
	 if li_ret = 5 then
		  li_ret = 0
	 else
		  li_ret = 1
	 end if
end if

return li_ret

end function

public function long of_descr_bg_color2 ();integer li_ret 
string ls_str
string ls_value
long ll_color

ll_color = 1073741824 //0x40000000, Window Background
li_ret = of_check_property('Pen.Color', ib_bg_color_expr, is_bg_color_expr, ls_value)
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

public function long of_get_y2 ();Return of_get_y2(1)
end function

public function long of_get_x1 ();Return of_get_x1(1)
end function

public function long of_descr_font_charset ();Return 0
end function

public function integer of_descr_font_escapement ();Return 0
end function

public function long of_descr_font_family ();Return 2
end function

public function integer of_descr_font_weight2 ();Return 400


end function

public function long of_get_y1 ();Return of_get_y1(1)
end function

public function long of_get_x2 ();Return of_get_x2(1)
end function

public function integer of_init (string as_dwo_name, integer ai_dwo_type);integer li_ret = 1

is_dwo_name = as_dwo_name


ii_dwo_type = ai_dwo_type
choose case ii_dwo_type
  	case DT_LINE
     is_coltype = 's'
     is_text = ""
	case else  
		li_ret = -1
end choose

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

on n_dwr_line.create
call super::create
end on

on n_dwr_line.destroy
call super::destroy
end on

