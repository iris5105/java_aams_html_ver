forward
global type n_dwr_field from nonvisualobject
end type
end forward

shared variables

//boolean ib_system_format_cached = false
//String is_system_date_format
//String is_system_shortdate_format
//String is_system_longdate_format
//String is_system_time_format
//String is_system_currency_format
//String is_system_currency_format_parts[]


end variables

global type n_dwr_field from nonvisualobject
end type
global n_dwr_field n_dwr_field

type variables
public int ii_dwo_type
public string is_dwo_name
public string is_coltype
public integer ii_colsize
public long il_xsplit_ind_from
public long il_xsplit_ind_to
public long il_ysplit_ind_from
public long il_ysplit_ind_to
public long il_base_x = 0
public long il_base_y = 0
public long il_subband_y = 0

protected long il_cached_y1 = -1000000000
protected string is_expr_y1 = "-"

protected long il_cached_x1 = -1
protected string is_expr_x1 = "-"

protected long il_cached_height = -1
protected string is_expr_height = "-"

protected long il_cached_y2 = -1000000000
protected string is_expr_y2 = "-"

protected long il_cached_width = -1
protected string is_expr_width = "-"

protected long il_cached_x2 = -1
protected string is_expr_x2 = "-"

public string is_text

//public datawindow idw_dw
public powerobject ipo_requestor
protected object ipo_requestortype
protected DataWindow idw_requestor
protected ads_jTier ids_requestor
protected DataWindowChild idwc_requestor
protected int ii_column_display_type

//public n_xls_format invo_format
//public n_xls_workbook invo_writer
public n_dwr_workbook inv_book
public n_dwr_colors invo_colors

boolean ib_color_expr = false
boolean ib_bg_color_expr = false
boolean ib_format_expr = false
boolean ib_font_face_expr = false
boolean ib_font_height_expr = false
boolean ib_font_italic_expr = false
boolean ib_font_underline_expr = false
boolean ib_font_weight_expr = false
boolean ib_font_escapement_expr = false
boolean ib_alignment_expr = false

string is_text_expr = ''
string is_color_expr = ''
string is_bg_color_expr = ''
string is_format_expr = ''
string is_font_face_expr = ''
string is_font_height_expr = ''
string is_font_italic_expr = ''
string is_font_underline_expr = ''
string is_font_weight_expr = ''
string is_font_escapement_expr = ''
string is_alignment_expr = ''


boolean ib_custom_format = false
integer ii_row_in_detail = 1
long il_dw_row_count
protected boolean ib_usetrc = false

protected n_dwr_service_base inv_nestedservice
protected n_dwr_nested_service_parm inv_nested_service_parm
public n_dwr_service_parm inv_parm
protected ads_jTier ids_reportdata
protected DataWindowChild idwc_child_cache

// workaround for nested on Appeon
protected long il_child_cache_rowcount = -1
protected long il_requestor_rowcount = -1

protected long il_child_cache_row = -1
//protected ads_jTier ids_child_cache


//column display type
public constant int CDT_TEXT = 1
public constant int CDT_CHECKBOX = 2
public constant int CDT_DDDW = 3
public constant int CDT_DDLB = 4
public constant int CDT_CODETABLE = 5
public constant int CDT_REPORT = 6
public constant int CDT_PICTURE = 7

//dwo type
public constant int DT_COLUMN = 1
public constant int DT_COMPUTE = 2
public constant int DT_TEXT = 3
public constant int DT_REPORT = 4
public constant int DT_LINE = 5
public constant int DT_RECT = 6
public constant int DT_RECT_BORDER = 7
public constant int DT_PICTURE = 8

protected boolean ib_disable_lookup_display = false
protected long il_id = 0

public string is_nested_dataobject = "" 
public string is_nested_instance_id = "" 
protected n_dwr_psr inv_nested_data
protected string is_nested_dddw_column_ids[]
protected String is_parent_band_id
protected String is_nested_processing = ""
protected long ii_units = 0

public constant string BAND_DETAIL = "1"
public constant string BAND_HEADER = "2"
public constant string BAND_FOOTER = "3"
public constant string BAND_SUMMARY = "4"
public constant string BAND_GROUPHEADER = "5"
public constant string BAND_GROUPTRAILER = "6"
public boolean ib_autosize_height = false

public n_dwr_format inv_format
public long il_format_ix = 0
//public boolean ib_registered = false
public boolean ib_use_general_for_large_cols = true

protected boolean ib_band_bg = false

public integer ii_sparse = 0

public n_dwr_band inv_parent_band

//protected w_sys ws
protected uo_dw2xls_service uo_app 

protected n_dwr_const inv_const

end variables

forward prototypes
public function any of_getvalue (long al_row)
public function integer of_setformat ()
public function long of_get_x1 ()
public function long of_get_y1 (long al_row)
public function long of_get_y2 (long al_row)
public function long of_get_y1 ()
public function integer of_get_visible (long al_row)
public function long of_get_y2 ()
public function string of_get_item_coltype ()
public function long of_describe_expr (string as_expr, long al_row)
private function string of_unquote (string as_str)
public function string of_change_format (ref string as_format, string as_type)
public function integer of_set_color (n_xls_format a_format, long al_row)
public function integer of_set_bg_color (n_xls_format a_format, long al_row)
public function integer of_check_property (string as_property_name, ref boolean ab_is_expression, ref string as_expression, ref string as_value)
public function string of_descr_numformat ()
public function string of_descr_font_face ()
public function long of_descr_font_height ()
public function boolean of_descr_font_italic ()
public function integer of_descr_font_underline ()
public function boolean of_descr_font_weight ()
public function string of_descr_alignment ()
public function integer of_descr_bg_color ()
public function integer of_descr_color ()
public function integer of_eval_bg_color (n_xls_format anvo_format, long al_row)
public function integer of_eval_color (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_face (n_xls_format anvo_format, long al_row)
public function integer of_eval_numformat (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_height (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_italic (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_underline (n_xls_format anvo_format, long al_row)
public function integer of_eval_font_weight (n_xls_format anvo_format, long al_row)
public function integer of_eval_alignment (n_xls_format anvo_format, long al_row)
public function long of_get_x1 (long al_row)
public function long of_get_x2 ()
public function long of_get_x2 (readonly long al_row)
public function string of_describe (readonly string as_expr)
public function any of_getvalue_dw (long al_row)
public function any of_getvalue_ds (long al_row)
public function any of_getvalue_dwc (long al_row)
public function integer of_createnestedservice (n_dwr_nested_service_parm anvo_nested_parm, n_dwr_service_parm anvo_parm)
public function integer of_dynamic_horisontal_layout (long al_row, n_dwr_grid anvo_hgrid)
public function integer of_register_dynamic (powerobject apo_requestor)
public function integer of_init (string as_dwo_name, integer ai_dwo_type)
private function ads_jTier of_dwc2ds (datawindowchild adwc_src, boolean ab_copydata)
public function long of_get_band_y1 ()
public function long of_get_band_y2 ()
public function string of_describe_str_expr (string as_expr, long al_row)
public function string of_get_system_currency_format ()
public function long of_describe_expr (string as_expr, long al_row, ref string as_prop_expr)
public function long of_evaluate0 (readonly string as_expr, long al_row)
public function long of_get_width (long al_row)
public function long of_get_height (long al_row)
public function string of_evaluate_str0 (readonly string as_expr, long al_row)
public function string of_describe_str_expr (string as_expr, long al_row, ref string as_prop_expr)
private function integer of_getdddwcolumnids (datawindowchild adw, ref string as_id[])
public subroutine of_setsubbandy (long ai_subband_y)
public function long of_process_nested (long al_row, long al_writer_row, n_dwr_grid anvo_hgrid, n_dwr_progress apo_progress)
public function integer of_descr_font_weight2 ()
public function long of_descr_alignment2 ()
public function long of_descr_color2 ()
public function long of_descr_bg_color2 ()
public function long of_get_format (long al_row)
public function integer of_eval_alignment (long al_row)
public function integer of_eval_bg_color (long al_row)
public function integer of_eval_color (long al_row)
public function integer of_eval_font_face (long al_row)
public function integer of_eval_font_height (long al_row)
public function integer of_eval_font_italic (long al_row)
public function integer of_eval_font_underline (long al_row)
public function integer of_eval_font_weight (long al_row)
public function integer of_eval_numformat (long al_row)
public function long of_descr_font_charset ()
public function long of_descr_font_family ()
public subroutine of_cancel_nested ()
public function integer of_descr_font_escapement ()
public function integer of_eval_font_escapement (long al_row)
public function integer of_setrect (long al_x1, long al_y1, long al_x2, long al_y2)
public function boolean of_render (n_dwr_worksheet anv_sheet, long al_row, long al_base_y, long al_units, n_dwr_progress apo_progress)
public function long of_get_band_bg_color (long al_row)
public function integer of_use_band_bg (boolean ab_enable)
public function integer of_register (powerobject apo_requestor, n_dwr_workbook anv_book, n_dwr_colors anvo_colors, long al_base_x, long al_base_y, long al_subband_y, boolean ab_band_background)
public subroutine of_getbgrect (ref st_rect ast_rect, long al_row)
public subroutine of_dispose ()
public subroutine of_setparentband (powerobject anv_band)
public function long of_get_col_height_font (integer ai_col_width, string str, string font_name, boolean font_italic, integer font_underline, integer font_weight, integer font_size)
public function integer of_do_static_x_markup (n_dwr_worksheet anv_sheet)
protected function integer of_get_column_display_type ()
public function integer of_register_dynamic2 (powerobject apo_requestor, long al_rowcount)
public function boolean of_descr_bitmapname ()
end prototypes

public function any of_getvalue (long al_row);Choose Case ipo_requestortype 
	Case DataWindow!
		return of_GetValue_DW(al_row)
	Case DataStore!
		return of_GetValue_DS(al_row)
	Case DataWindowChild!
		return of_GetValue_DWC(al_row)
	Case Else
		// should not be here, see checks in of_register
End Choose   

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
   inv_format.setVAlign(inv_format.handle, inv_const.ALIGN_VCENTER) 
   if is_coltype = 's' then inv_format.setWrap(inv_format.handle, 1) 
	// penta
	ll_color = of_descr_color2()
	inv_format.setFgColor(inv_format.handle, ll_color)
	//ll_color = of_descr_bg_color2()
     //inv_format.setBgColor(inv_format.handle, ll_color)
	inv_format.SetFontCharset(inv_format.handle, of_descr_font_charset())
	inv_format.SetFontFamily(inv_format.handle, of_descr_font_family())
	inv_format.SetRotation(inv_format.handle, of_descr_font_escapement())
	
end if
	 
if li_ret = 1 then

	string ls_border_style
	 
	ls_border_style = of_describe(is_dwo_name + '.Border') 
	//penta
	if integer(of_describe ( 'Datawindow.Processing' )) = 1 then
		inv_format.setBorderStyle(inv_format.handle, 1)
	else
		if isNumber(ls_border_style) and integer(ls_border_style) > 0 then	
			inv_format.setBorderStyle(inv_format.handle, 1)
		end if
	end if
		
//	if isNumber(ls_border_style) and integer(ls_border_style) > 0 then	
//		inv_format.setBorderStyle(inv_format.handle, 1)
//
//	else
//		if integer(of_describe ( 'Datawindow.Processing' )) = 1 then
//			if inv_parm.ib_draw_dw_grid_lines then
//				inv_format.setBorderStyle(inv_format.handle, 1)
//			end if
//		end if
//	end if
	ib_custom_format =  (ib_color_expr          or ib_bg_color_expr    or ib_alignment_expr or &
	                     ib_font_face_expr      or ib_font_height_expr or ib_font_italic_expr or &
								ib_font_underline_expr or ib_font_weight_expr or ib_format_expr or ib_font_escapement_expr)
								
	If Not ib_custom_format Then
		il_format_ix = inv_book.of_AddFormat(inv_format)								
	End If
end if  

return li_ret
end function

public function long of_get_x1 ();If il_cached_x1 = -1 Then 
	Return of_get_x1(1)
Else
	Return il_base_x + il_cached_x1
End If

end function

public function long of_get_y1 (long al_row);long ll_ret 

al_row = al_row + ii_row_in_detail - 1
if al_row > il_dw_row_count then 
   Return 0
end if

If is_expr_y1 = "" Then
	ll_ret = il_base_y + il_cached_y1
ElseIf is_expr_y1 = "-" Then
	il_cached_y1 = of_describe_expr(is_dwo_name + '.y', al_row, is_expr_y1) - il_subband_y
	ll_ret = il_base_y + il_cached_y1
Else 
	ll_ret = il_base_y + of_evaluate0(is_expr_y1, al_row) - il_subband_y
End If

Return ll_ret


end function

public function long of_get_y2 (long al_row);long ll_ret = 0

al_row = al_row + ii_row_in_detail - 1
if al_row > il_dw_row_count then 
   Return 0
end if

If is_expr_y2 = "" Then
	ll_ret = il_base_y + il_cached_y2
ElseIf is_expr_y2 = "-" Then
	ll_ret = of_get_y1(al_row) + of_get_height(al_row)
	il_cached_y2 = ll_ret - il_base_y
	If is_expr_y1 <> "" Or is_expr_height <> "" Then
		is_expr_y2 = "*" // this will not be used as an expression
	Else
		is_expr_y2 = ""
	End If
Else 
	ll_ret = of_get_y1(al_row) + of_get_height(al_row)
End If

Return ll_ret

end function

public function long of_get_y1 ();If il_cached_y1 = -1000000000 Then 
	Return of_get_y1(1)
Else
	Return il_base_y + il_cached_y1
End If

end function

public function integer of_get_visible (long al_row);int li_ret = 0

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
    li_ret = of_describe_expr(is_dwo_name + '.visible', al_row)
end if

return li_ret

end function

public function long of_get_y2 ();If il_cached_y2 = -1000000000 Then 
	Return of_get_y2(1)
Else
	Return il_base_y + il_cached_y2
End If

end function

public function string of_get_item_coltype ();string ls_coltype
long ll_pos, ll_pos_dec

ls_coltype = trim(lower(of_describe(is_dwo_name + '.coltype')))
ll_pos = pos(ls_coltype, '(')
if ll_pos > 0 then 
	ll_pos_dec  = pos(ls_coltype, ',', ll_pos)
	if ll_pos_dec <= 0 then ll_pos_dec = pos(ls_coltype, ')', ll_pos)
	ii_colsize = integer(mid(ls_coltype, ll_pos + 1, ll_pos_dec - ll_pos - 1))
	ls_coltype = trim(left(ls_coltype, ll_pos - 1))
end if

choose case ls_coltype
	case 'char', 'string'
		ls_coltype = 's'
	case 'decimal','int','long','ulong','number','real','integer'
		ls_coltype = 'n'
	case 'date'
		ls_coltype = 'd'
	case 'datetime', 'timestamp'
		ls_coltype = 'dt'
	case 'time'
		ls_coltype = 't'
	case else 
		ls_coltype = '-'
end choose

return ls_coltype

end function

public function long of_describe_expr (string as_expr, long al_row);string ls_val
long ll_pos
n_dwr_string lnvo_str
Choose Case ipo_requestortype //idw_requestor
	Case DataWindow!
		ls_val = idw_requestor.describe(as_expr)
	Case DataStore!
		ls_val = ids_requestor.describe(as_expr)
	Case DataWindowChild!
		ls_val = idwc_requestor.describe(as_expr)
	Case Else
		Return -1
End Choose   

ll_pos = pos(ls_val, '~t')
if ll_pos > 0 then
   ls_val = mid(ls_val, ll_pos + 1, len(ls_val) - ll_pos - 1)
   ls_val = lnvo_str.of_globalreplace(ls_val, "'", "~~~'")
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_val = idw_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataStore!
			ls_val = ids_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataWindowChild!
			ls_val = idwc_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case Else
			Return -1
	End Choose   
	if isNumber(ls_val) then return long(ls_val)
else
  if isNumber(ls_val) then return long(ls_val)
end if

return -1
end function

private function string of_unquote (string as_str);long ll_pos

if left(as_str, 1) = '"' and right(as_str, 1) = '"' then as_str = mid(as_str, 2, len(as_str) - 2)

ll_pos = pos(as_str, '~~"')
do while ll_pos > 0 
   as_str = replace(as_str, ll_pos, 2, '"')
   ll_pos = pos(as_str, '~~"')
loop

return as_str
end function

public function string of_change_format (ref string as_format, string as_type);//TODO move to DLL

long ll_pos
n_dwr_string lnvo_str
string ls_arr[], ls_emp[]
long ll_cnt, ll_i, ll_ret

as_format = Lower(as_format)

// ***WORKAROUND*** for .NET and appeon
// inv_book. - is a workaround for shared variables of this object. Now these variablies are in n_dwr_workbook as instance variables
// ***END***

// acquire user regional settings
If Not inv_book.ib_system_format_cached Then
	
	ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sShortDate", RegString!, inv_book.is_system_shortdate_format)
	If ll_ret <> 1 Then inv_book.is_system_shortdate_format = "dd.MM.yyyy"
	
	ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sLongDate", RegString!, inv_book.is_system_longdate_format)
	If ll_ret <> 1 Then inv_book.is_system_longdate_format = "dd MMMM yyyy"
	
	ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sTimeFormat", RegString!, inv_book.is_system_time_format)
	If ll_ret <> 1 Then inv_book.is_system_time_format = "HH:mm"

	inv_book.is_system_time_format = lnvo_str.of_GlobalReplace(inv_book.is_system_time_format, "tt", "AM/PM")
	inv_book.is_system_date_format = inv_book.is_system_shortdate_format

	//inv_book.is_system_currency_format = '$#,##0.00'
	inv_book.is_system_currency_format = of_get_system_currency_format()
	ll_cnt = lnvo_str.of_parsetoarray(inv_book.is_system_currency_format, ';', inv_book.is_system_currency_format_parts[])
	For ll_i = UpperBound(inv_book.is_system_currency_format_parts[]) + 1 To 3
		inv_book.is_system_currency_format_parts[ll_i] = inv_book.is_system_currency_format_parts[1]
	Next
	inv_book.ib_system_format_cached = True
End If

//check text format with @
ll_pos = pos(as_format, '@')
if ll_pos > 0 then as_format = '[general]'

//check multipart format
ll_cnt = lnvo_str.of_parsetoarray(as_format, ';', ls_arr)

choose case as_type
	case 'n'
		if (ll_cnt > 3) then ll_cnt = 3
	case else
		if (ll_cnt > 1) then ll_cnt = 1
end choose      
for ll_i = 1 to ll_cnt
	//change single qoutes to double
	ls_emp[ll_i] = lnvo_str.of_globalreplace(ls_arr[ll_i], '~'', '"')
	//change number format to General
	ls_emp[ll_i] = lnvo_str.of_globalreplace(ls_emp[ll_i], '@', 'General')
	ls_emp[ll_i] = lnvo_str.of_GlobalReplace(ls_emp[ll_i], "[currency]", inv_book.is_system_currency_format_parts[ll_i])
next
lnvo_str.of_arraytostring(ls_emp, ';', as_format)

//replace [general] to @
if is_coltype = 'd' then
	as_format = lnvo_str.of_GlobalReplace(as_format, "[general]", "[shortdate]")
elseif is_coltype = 'dt' then
	as_format = lnvo_str.of_GlobalReplace(as_format, "[general]", "[shortdate]")
elseif is_coltype = 't' then
	as_format = lnvo_str.of_GlobalReplace(as_format, "[general]", "[time]")
else
	as_format = lnvo_str.of_GlobalReplace(as_format, "[general]", "General")
end if

as_format = lnvo_str.of_GlobalReplace(as_format, "[shortdate]", inv_book.is_system_shortdate_format)
as_format = lnvo_str.of_GlobalReplace(as_format, "[longdate]", inv_book.is_system_longdate_format)
as_format = lnvo_str.of_GlobalReplace(as_format, "[date]", inv_book.is_system_date_format)
as_format = lnvo_str.of_GlobalReplace(as_format, "[time]", inv_book.is_system_time_format)

if ii_colsize > 255 Or ii_dwo_type = DT_COMPUTE And as_type = "s" then 
	if ib_use_general_for_large_cols then
		as_format = 'General'
	else
		as_format = ''
	end if
end if

return as_format
end function

public function integer of_set_color (n_xls_format a_format, long al_row);long ll_color
integer li_color_index

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = long(of_describe('evaluate("' + is_color_expr + '", ' + string(al_row) + ')'))
	if ll_color >= 0 then
		li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		if li_color_index > 0 then
			 a_format.of_set_color(li_color_index)
		end if
	end if
end if

return 1

end function

public function integer of_set_bg_color (n_xls_format a_format, long al_row);long ll_color
integer li_color_index

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = long(of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')'))
	if ll_color >= 0 then
		li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		if li_color_index > 0 then
			 a_format.of_set_bg_color(li_color_index)
		end if
	end if
end if

return 1

end function

public function integer of_check_property (string as_property_name, ref boolean ab_is_expression, ref string as_expression, ref string as_value);integer li_ret
string ls_str
long ll_pos

If Left(as_property_name, 2) = "::" Then
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_str = idw_requestor.describe(Mid(as_property_name, 3))
		Case DataStore!
			ls_str = ids_requestor.describe(Mid(as_property_name, 3))
		Case DataWindowChild!
			ls_str = idwc_requestor.describe(Mid(as_property_name, 3))
		Case Else
			Return -1
	End Choose   
Else
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_str = idw_requestor.describe(is_dwo_name + '.' + as_property_name)
		Case DataStore!
			ls_str = ids_requestor.describe(is_dwo_name + '.' + as_property_name)
		Case DataWindowChild!
			ls_str = idwc_requestor.describe(is_dwo_name + '.' + as_property_name)
		Case Else
			Return -1
	End Choose   
End If
if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
   //check for expression
   ll_pos = pos(lower(ls_str), '~t')
   if ll_pos > 0 then
		 as_expression = right(ls_str, len(ls_str) - ll_pos) 
		 if right(as_expression, 1) = '"' then 
			 as_expression = left(as_expression, len(as_expression) - 1) 
//		 else
//			n_dwr_string s
//			as_expression = s.of_GlobalReplace(as_expression, "~~", "~~~~")
//			as_expression = s.of_GlobalReplace(as_expression, "~'", "~'~'")
//			as_expression = s.of_GlobalReplace(as_expression, "~"", "~"~"")
		 end if
		 ab_is_expression = (trim(as_expression) <> '')

      ls_str = left(ls_str, ll_pos - 1) 
      if left(ls_str, 1) = '"' then
         ls_str = right(ls_str, len(ls_str) - 1) 
      end if
   end if
	
	as_value = ls_str
	li_ret = 1
else
   li_ret = -1
end if

return li_ret
end function

public function string of_descr_numformat ();integer li_ret 
string ls_value

li_ret = of_check_property('Format', ib_format_expr, is_format_expr, ls_value)
if li_ret = 1 then
	return ls_value
else
	return ''
end if
end function

public function string of_descr_font_face ();integer li_ret 
string ls_value

li_ret = of_check_property('Font.Face', ib_font_face_expr, is_font_face_expr, ls_value)
if li_ret = 1 then
   return ls_value
else
	return '맑은 고딕'
end if
end function

public function long of_descr_font_height ();integer li_ret 
string ls_value

li_ret = of_check_property('Font.Height', ib_font_height_expr, is_font_height_expr, ls_value)
if li_ret = 1 then
   if isNumber(ls_value) then
		return abs(integer(ls_value))
   else
      return 10
   end if
else
	return 10
end if

end function

public function boolean of_descr_font_italic ();integer li_ret 
string ls_value

li_ret = of_check_property('Font.Italic', ib_font_italic_expr, is_font_italic_expr, ls_value)
if li_ret = 1 then
	return ((lower(ls_value) = 'yes') or (ls_value = '1'))
else
	return false
end if
end function

public function integer of_descr_font_underline ();integer li_ret 
string ls_value

li_ret = of_check_property('font.underline', ib_font_underline_expr, is_font_underline_expr, ls_value)
if li_ret = 1 then
	if ((lower(ls_value) = 'yes') or (ls_value = '1')) then 
		return 1
	else
		return 0
	end if
else
	return 0
end if

end function

public function boolean of_descr_font_weight ();integer li_ret 
string ls_value

li_ret = of_check_property('font.weight', ib_font_weight_expr, is_font_weight_expr, ls_value)
if li_ret = 1 then
	if isNumber(ls_value) then
		return (abs(integer(ls_value)) = 700)
	else
		return false
	end if
else
	return false
end if

end function

public function string of_descr_alignment ();integer li_ret 
string ls_value = '-1'

li_ret = of_check_property('alignment', ib_alignment_expr, is_alignment_expr, ls_value)
if li_ret <> 1 then ls_value = '-1'
choose case ls_value
     case '0'
   		return 'left'
     case '1'
		   return 'right'
     case '2'
		   return 'center'
     case '3'
		   return 'justified'
	case else
		   if is_coltype = 'n' then
				return 'right'
			else
				return 'left'
			end if
end choose

end function

public function integer of_descr_bg_color ();integer li_ret 
string ls_str
string ls_value
long ll_color

ls_str = of_describe(is_dwo_name + '.Background.Mode')
if ls_str <> '1' then
   li_ret = of_check_property('Background.Color', ib_bg_color_expr, is_bg_color_expr, ls_value)
	if li_ret = 1 then
       if isNumber(ls_value) then
			 ll_color = invo_colors.of_get_color(long(ls_value))
			 return invo_colors.of_get_custom_color_index(ll_color) 
       else
          return -1
       end if
	else
		return -1
	end if
else
	return -1
end if

end function

public function integer of_descr_color ();integer li_ret 
string ls_value
long ll_color

li_ret = of_check_property('Color', ib_color_expr, is_color_expr, ls_value)
if li_ret = 1 then
   if isNumber(ls_value) then
		ll_color = invo_colors.of_get_color(long(ls_value))
		return invo_colors.of_get_custom_color_index(ll_color) 
   else
      return -1
   end if
else
	return -1
end if

end function

public function integer of_eval_bg_color (n_xls_format anvo_format, long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')')
   if isNumber(ls_value) then
       ll_color = invo_colors.of_get_color(long(ls_value))
		 li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		 if li_color_index > 0 then 
			 anvo_format.of_set_bg_color(li_color_index)
			 return 1
		end if
   end if
end if

return -1

end function

public function integer of_eval_color (n_xls_format anvo_format, long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_color_expr + '", ' + string(al_row) + ')')
   if isNumber(ls_value) then
       ll_color = invo_colors.of_get_color(long(ls_value))
		 li_color_index = invo_colors.of_get_custom_color_index(ll_color) 
		 if li_color_index > 0 then 
			 anvo_format.of_set_color(li_color_index)
			 return 1
		end if
   end if
end if

return -1

end function

public function integer of_eval_font_face (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_font_face_expr + '", ' + string(al_row) + ')'))
	if ls_value <> '' then
		anvo_format.of_set_font(ls_value)
		return 1
	end if
end if

return -1

end function

public function integer of_eval_numformat (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_format_expr + '", ' + string(al_row) + ')'))
 	if ls_value = '' then ls_value = '[General]'
	ls_value = of_change_format(ls_value, is_coltype)
	anvo_format.of_set_num_format(ls_value)
	return 1
end if

return -1

end function

public function integer of_eval_font_height (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_height_expr + '", ' + string(al_row) + ')')
   if isNumber(ls_value) then
      anvo_format.of_set_size(abs(integer(ls_value)))
      return 1
   end if
end if

return -1

end function

public function integer of_eval_font_italic (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_italic_expr + '", ' + string(al_row) + ')')
   anvo_format.of_set_italic((lower(ls_value) = 'yes') or (ls_value = '1'))
	return 1
end if

return -1

end function

public function integer of_eval_font_underline (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_underline_expr + '", ' + string(al_row) + ')')
	if ((lower(ls_value) = 'yes') or (ls_value = '1')) then
		anvo_format.of_set_underline(1)
	else
		anvo_format.of_set_underline(0)
	end if
	return 1
end if

return -1

end function

public function integer of_eval_font_weight (n_xls_format anvo_format, long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_weight_expr + '", ' + string(al_row) + ')')
	if isNumber(ls_value) then
		//TODO: don't convert number to boolean
	   anvo_format.of_set_bold(abs(integer(ls_value)) = 700)
	else
		anvo_format.of_set_bold(false)
	end if
	
	return 1
end if

return -1

end function

public function integer of_eval_alignment (n_xls_format anvo_format, long al_row);string ls_value
string ls_align

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_alignment_expr + '", ' + string(al_row) + ')'))
	choose case ls_value
		  case '0'
				ls_align = 'left'
		  case '1'
				ls_align = 'right'
		  case '2'
				ls_align = 'center'
		  case '3'
				ls_align = 'justified'
		case else
				if is_coltype = 'n' then
					ls_align = 'right'
				else
					ls_align = 'left'
				end if
	end choose
	anvo_format.of_set_align(ls_align)
	return 1
end if

return -1

end function

public function long of_get_x1 (long al_row);long ll_ret 
If is_expr_x1 = "" Then
	ll_ret = il_base_x + il_cached_x1
ElseIf is_expr_x1 = "-" Then
	il_cached_x1 = of_describe_expr(is_dwo_name + '.x', al_row, is_expr_x1)
	ll_ret = il_base_x + il_cached_x1
Else 
	ll_ret = il_base_x + of_evaluate0(is_expr_x1, al_row)
End If
Return ll_ret

end function

public function long of_get_x2 ();If il_cached_x2 = -1 Then 
	Return of_get_x2(1)
Else
	Return il_base_x + il_cached_x2
End If

end function

public function long of_get_x2 (readonly long al_row);Long ll_ret
If is_expr_x2 = "" Then
	ll_ret = il_base_x + il_cached_x2
ElseIf is_expr_x2 = "-" Then
	ll_ret = of_get_x1(al_row) + of_get_width(al_row)
	il_cached_x2 = ll_ret - il_base_x
	If is_expr_x1 <> "" Or is_expr_width <> "" Then
		is_expr_x2 = is_expr_x1 + " + " + is_expr_width
	Else
		is_expr_x2 = ""
	End If
Else 
	ll_ret = of_get_x1(al_row) + of_get_width(al_row)
End If

Return ll_ret

end function

public function string of_describe (readonly string as_expr);Choose Case ipo_requestortype 
	Case DataWindow!
		Return idw_requestor.describe(as_expr)
	Case DataStore!
		Return ids_requestor.describe(as_expr)
	Case DataWindowChild!
		Return idwc_requestor.describe(as_expr)
	Case Else
		Return "!"
End Choose   

end function

public function any of_getvalue_dw (long al_row);DataWindow lpo_requestor
// the code below is common for of_getvalue_dwc, of_getvalue_dw, of_getvalue_ds
// any changes should be replicated by copy & paste method
lpo_requestor = ipo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val


SetNull(la_val)
al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	choose case ii_dwo_type
	case DT_COLUMN, DT_COMPUTE 
		 if ii_column_display_type = CDT_TEXT then
			choose case is_coltype
				case 's'
					integer li_id
					li_id = integer(lpo_requestor.describe(is_dwo_name+'.id'))
					if li_id > 0 then
						//la_val = string(lpo_requestor.object.data[al_row, li_id])
						// DataWindowChild has no Object property
						la_val = lpo_requestor.GetItemString(al_row, li_id) 
					else	  
						//2)la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						//пришлось заменить на describe так как GetItemString возвращал сторку с применением формата
						//1)la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
						la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
					end if	
				case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
				case 'd'
					la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
				case 'dt'
					la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
				case 't'
					la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			end choose
		elseif ii_column_display_type = CDT_CHECKBOX then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if isNull(la_val) then la_val = ''
		elseif ii_column_display_type = CDT_DDDW then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				
				If ib_disable_lookup_display Then
					if isNull(la_val) then 
						la_val = ''
					end if
				Else
					if not isNull(la_val) then 
						la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
					else
						la_val = ''
					end if
				End If	
		else
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if not isNull(la_val) then 
					la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
				else
					la_val = ''
				end if
		 end if
	case DT_TEXT 
	  //-- 04.10.2004
	  //support expression in text object
		 if is_text_expr <> '' then
			 //la_val = string(of_describe_expr(is_dwo_name + '.Text', al_row))
			 // bugfix: use of_describe_str_expr
			 // of_describe_expr supports only numeric expressions
			 la_val = of_describe_str_expr(is_dwo_name + '.Text', al_row)
		 else
			 la_val = is_text
		 end if
	  //--
	case DT_REPORT 
		la_val = "{" + is_dwo_name + "}"
		
	end choose

end if

return la_val

end function

public function any of_getvalue_ds (long al_row);ads_jTier lpo_requestor
// the code below is common for of_getvalue_dwc, of_getvalue_dw, of_getvalue_ds
// any changes should be replicated by copy & paste method
lpo_requestor = ipo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val


SetNull(la_val)
al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	choose case ii_dwo_type
	case DT_COLUMN, DT_COMPUTE 
		 if ii_column_display_type = CDT_TEXT then
			choose case is_coltype
				case 's'
					integer li_id
					li_id = integer(lpo_requestor.describe(is_dwo_name+'.id'))
					if li_id > 0 then
						//la_val = string(lpo_requestor.object.data[al_row, li_id])
						// DataWindowChild has no Object property
						la_val = lpo_requestor.GetItemString(al_row, li_id) 
					else	  
						//2)la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						//пришлось заменить на describe так как GetItemString возвращал сторку с применением формата
						//1)la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
						la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
					end if	
				case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
				case 'd'
					la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
				case 'dt'
					la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
				case 't'
					la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			end choose
		elseif ii_column_display_type = CDT_CHECKBOX then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if isNull(la_val) then la_val = ''
		elseif ii_column_display_type = CDT_DDDW then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				
				If ib_disable_lookup_display Then
					if isNull(la_val) then 
						la_val = ''
					end if
				Else
					if not isNull(la_val) then 
						la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
					else
						la_val = ''
					end if
				End If	
		else
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if not isNull(la_val) then 
					la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
				else
					la_val = ''
				end if
		 end if
	case DT_TEXT 
	  //-- 04.10.2004
	  //support expression in text object
		 if is_text_expr <> '' then
			 //la_val = string(of_describe_expr(is_dwo_name + '.Text', al_row))
			 // bugfix: use of_describe_str_expr
			 // of_describe_expr supports only numeric expressions
			 la_val = of_describe_str_expr(is_dwo_name + '.Text', al_row)
		 else
			 la_val = is_text
		 end if
	  //--
	case DT_REPORT 
		la_val = "{" + is_dwo_name + "}"
		
	end choose

end if

return la_val

end function

public function any of_getvalue_dwc (long al_row);DataWindowChild lpo_requestor
// the code below is common for of_getvalue_dwc, of_getvalue_dw, of_getvalue_ds
// any changes should be replicated by copy & paste method
lpo_requestor = ipo_requestor
any la_val
string ls_val
double ldb_val
datetime ldt_val
date ld_val
time lt_val


SetNull(la_val)
al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	choose case ii_dwo_type
	case DT_COLUMN, DT_COMPUTE 
		 if ii_column_display_type = CDT_TEXT then
			choose case is_coltype
				case 's'
					integer li_id
					li_id = integer(lpo_requestor.describe(is_dwo_name+'.id'))
					if li_id > 0 then
						//la_val = string(lpo_requestor.object.data[al_row, li_id])
						// DataWindowChild has no Object property
						la_val = lpo_requestor.GetItemString(al_row, li_id) 
					else	  
						//2)la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
						//пришлось заменить на describe так как GetItemString возвращал сторку с применением формата
						//1)la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
						la_val = string(lpo_requestor.describe("Evaluate('" + is_dwo_name + "', " + string(al_row) + ")"))
					end if	
				case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
				case 'd'
					la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
				case 'dt'
					la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
				case 't'
					la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			end choose
		elseif ii_column_display_type = CDT_CHECKBOX then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if isNull(la_val) then la_val = ''
		elseif ii_column_display_type = CDT_DDDW then
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				
				If ib_disable_lookup_display Then
					if isNull(la_val) then 
						la_val = ''
					end if
				Else
					if not isNull(la_val) then 
						la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
					else
						la_val = ''
					end if
				End If	
		else
			 	choose case is_coltype
					case 's'
						la_val = lpo_requestor.GetItemString(al_row, is_dwo_name)
					case 'n'
					la_val = lpo_requestor.GetItemDecimal(al_row, is_dwo_name)
					case 'd'
						la_val = lpo_requestor.GetItemDate(al_row, is_dwo_name)
					case 'dt'
						la_val = lpo_requestor.GetItemDateTime(al_row, is_dwo_name)
					case 't'
						la_val = lpo_requestor.GetItemTime(al_row, is_dwo_name)
			 	end choose
				if not isNull(la_val) then 
					la_val = string(lpo_requestor.describe("Evaluate('LookUpDisplay(" + is_dwo_name + ")', " + string(al_row) + ")"))
				else
					la_val = ''
				end if
		 end if
	case DT_TEXT 
	  //-- 04.10.2004
	  //support expression in text object
		 if is_text_expr <> '' then
			 //la_val = string(of_describe_expr(is_dwo_name + '.Text', al_row))
			 // bugfix: use of_describe_str_expr
			 // of_describe_expr supports only numeric expressions
			 la_val = of_describe_str_expr(is_dwo_name + '.Text', al_row)
		 else
			 la_val = is_text
		 end if
	  //--
	case DT_REPORT 
		la_val = "{" + is_dwo_name + "}"
		
	end choose

end if

return la_val

end function

public function integer of_createnestedservice (n_dwr_nested_service_parm anvo_nested_parm, n_dwr_service_parm anvo_parm);int li_ret = -1
long ll_parent_rowcount
inv_nested_service_parm = anvo_nested_parm
inv_parm = anvo_parm
//is_nested_instance_id = String(inv_parm.il_nested_instance_count)
// see n_dwr_band.of_add_field

is_parent_band_id = inv_nested_service_parm.is_parent_band_id

ids_reportdata = Create ads_jTier
// 
String ls_dwo = ""
Choose Case ipo_requestortype 
	Case DataWindow!
		ls_dwo = idw_requestor.DataObject
		ll_parent_rowcount = idw_requestor.RowCount()
	Case DataStore!
		ls_dwo = ids_requestor.DataObject
		ll_parent_rowcount = ids_requestor.RowCount()
	Case Else
		Return -1
End Choose  
If ll_parent_rowcount = 0 Then
	// PB does not display nested DWs (even in header) if parent has no rows 
	// so we don't export them
	Return -1
End If
If ls_dwo <> "" Then
	ids_reportdata.DataObject = ls_dwo  
End If


blob lblob_1
Choose Case ipo_requestortype
Case DataWindow!, DataStore!
	Environment e
	GetEnvironment(e)
	If e.PbMajorRevision < 6 Then
		String ls_tmpfile = "dw2xls_tmp.psr"
		If ipo_requestor.Dynamic SaveAs(ls_tmpfile, PSReport!, True) <> 1 Then
			Return -1
		End If
		ids_reportdata.DataObject = ls_tmpfile
		FileDelete(ls_tmpfile)
	Else
		// if workaround for nested is ON then change source DW directly to obtain nested reports
		if inv_parm.ib_nested_workaround then
			ids_reportdata = ipo_requestor
		else
			ipo_requestor.Dynamic GetFullState(lblob_1)
			ids_reportdata.Dynamic SetFullState(lblob_1)
		end if
	End If
	// if workaround for nested is ON then don't change processing (Appeon does not requre this)
	if not inv_parm.ib_nested_workaround then	
		ids_reportdata.Modify("Datawindow.Processing=5")
	end if
Case Else // DWC
	 // GetFullState, GetChild, SaveAs not supported
	 Return -1
End Choose

DataWindowChild ldwc_nested
//ads_jTier lds_nested

// special trick for Appeon
if inv_parm.ib_nested_workaround then	
	ids_reportdata.RowsMove(1, 1, Primary!, ids_reportdata, 1, Primary!)
end if

li_ret = ids_reportdata.GetChild(is_dwo_name, ldwc_nested)
If li_ret = 1 Then
	/* [1]
	SetNull(lds_nested)
	is_nested_processing = ldwc_nested.Describe("Datawindow.Processing")
	If is_nested_processing = "4" Then
		// disable method1 for nested crosstab due to gpf
		inv_parm.ii_nested_extract_method = 0
	End If
	If inv_parm.ii_nested_extract_method = 1 Then
		inv_nested_data = Create n_dwr_psr
		If inv_nested_data.of_CreateFromDW(ipo_requestor) = 1 Then
			of_GetDDDWColumnIDs(ldwc_nested, is_nested_dddw_column_ids[])
			If inv_nested_data.of_Nested2DS(is_nested_instance_id, is_nested_dataobject, is_parent_band_id, 1, is_nested_dddw_column_ids[] ,lds_nested) = 1 Then
				lds_nested.GroupCalc()
			End If
		Else
			Destroy inv_nested_data
			SetNull(inv_nested_data)
			inv_parm.ii_nested_extract_method = 0
		End If
	End If
	If IsNull(lds_nested) Then
		lds_nested = of_dwc2ds(ldwc_nested, True) // should be TRUE
	End If
	*/
	il_child_cache_row = 1
	idwc_child_cache = ldwc_nested
	
	// workaround for nested on Appeon
	if inv_parm.ib_nested_workaround then
		il_child_cache_rowcount = idwc_child_cache.RowCount()
		anvo_nested_parm.il_requestor_rowcount = il_child_cache_rowcount
	end if
	
	anvo_nested_parm.il_nested_x = of_get_x1()
	anvo_nested_parm.il_nested_y = of_get_y1()
	inv_nestedservice = Create Using "n_dwr_service"
	li_ret = inv_nestedservice.of_create(idwc_child_cache, inv_book, ":not applicable:", anvo_parm, anvo_nested_parm)
End If
If li_ret = 1 Then
	li_ret = inv_nestedservice.of_Analyse_DW(0)
End If

Return li_ret
end function

public function integer of_dynamic_horisontal_layout (long al_row, n_dwr_grid anvo_hgrid);Return 1
end function

public function integer of_register_dynamic (powerobject apo_requestor);ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = idw_requestor.RowCount()
	Case DataStore!
		ids_requestor = ipo_requestor
		il_dw_row_count = ids_requestor.RowCount()
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = idwc_requestor.RowCount()
	Case Else
		Return -1
End Choose  

Return 1
end function

public function integer of_init (string as_dwo_name, integer ai_dwo_type);integer li_ret = 1

is_dwo_name = as_dwo_name


ii_dwo_type = ai_dwo_type
choose case ii_dwo_type
  case DT_COLUMN  //column
     is_coltype = of_get_item_coltype()
	  il_id = Long(of_describe(as_dwo_name + '.id'))
	  
	  // Ther reason of doing this in the past is unknown. We do not access DDDW field value by ID and this flag is used only for DDDW fields in of_getValue
	  //If il_id > 0 And of_describe("#" + String(il_id) + '.name') <> as_dwo_name Then
	  //   ib_disable_lookup_display = True
	  //End If
  case DT_COMPUTE  //expression
     is_coltype = of_get_item_coltype()
  case DT_TEXT  //text
     is_coltype = 's'
     is_text = of_describe(as_dwo_name + '.text')
     is_text = of_unquote(is_text)
	  //-- 04.10.2004
	  //support expression in text object
	  if pos(is_text, '~t') > 0 then is_text_expr = is_text
	  //--
  case DT_REPORT  // report
      is_coltype = 'r'
		is_nested_dataobject = of_describe(is_dwo_name + '.DataObject')
	  
end choose

if li_ret = 1 then
	//MessageBox(as_dwo_name, idw_dw.describe(as_dwo_name + '.attributes'))
	//MessageBox(as_dwo_name, idw_dw.describe(as_dwo_name + '.row_in_detail'))
	//ii_row_in_detail = integer(idw_dw.describe(as_dwo_name + '.row_in_detail'))
	//if (ii_row_in_detail < 1) or isNull(ii_row_in_detail) then ii_row_in_detail = 1
	
	Choose Case ipo_requestortype 
		Case DataWindow!
			il_dw_row_count = idw_requestor.RowCount()
		Case DataStore!
			il_dw_row_count = ids_requestor.RowCount()
		Case DataWindowChild!
			il_dw_row_count = idwc_requestor.RowCount()
		Case Else
			Return -1
	End Choose  

   ib_autosize_height = of_describe(as_dwo_name + ".height.autosize") = "yes"
	ii_column_display_type = of_get_column_display_type()
   li_ret = of_setformat()
	ii_units = integer(of_describe('Datawindow.Units'))
	
	if inv_parm.ib_check_suppressed then
		integer li_i
		for li_i = 1 to UpperBound(inv_parent_band.is_sparseList)
			if inv_parent_band.is_sparseList[li_i] = as_dwo_name then
				ii_sparse = li_i
			end if
		next
	end if	
end if

return li_ret
end function

private function ads_jTier of_dwc2ds (datawindowchild adwc_src, boolean ab_copydata);ads_jTier lds_res
lds_res = Create ads_jTier

//TODO: check for processing=4 and cache the result
adwc_src.Modify('DataWindow.Crosstab.StaticMode=Yes') 
// Don't set to TRUE, experimental mode
Boolean lb_copy_using_psr = False //False, True
If Not lb_copy_using_psr Then
	lds_res.Create(adwc_src.Describe("Datawindow.Syntax"))
	If ab_copydata Then
		adwc_src.RowsCopy(1, adwc_src.RowCount(), Primary!, lds_res, 1, Primary!)
		lds_res.GroupCalc()
	End If
Else
	If ab_copydata Then
		String ls_tmpfile = "dw2xls_tmp.psr"
		FileDelete(ls_tmpfile)
		If adwc_src.SaveAs(ls_tmpfile, PSReport!, True) <> 1 Then
			lds_res.Create(adwc_src.Describe("Datawindow.Syntax"))
			adwc_src.RowsCopy(1, adwc_src.RowCount(), Primary!, lds_res, 1, Primary!)
			lds_res.GroupCalc()
		Else
			lds_res.DataObject = ls_tmpfile
			FileDelete(ls_tmpfile)
		End If
	Else
		lds_res.Create(adwc_src.Describe("Datawindow.Syntax"))
	End If
End If
Return lds_res
end function

public function long of_get_band_y1 ();If il_cached_y1 = -1000000000 Then 
	Return of_get_y1(1) - il_base_y
Else
	Return il_cached_y1
End If

end function

public function long of_get_band_y2 ();If il_cached_y2 = -1000000000 Then 
	Return of_get_y2(1) - il_base_y
Else
	Return il_cached_y2
End If

end function

public function string of_describe_str_expr (string as_expr, long al_row);string ls_val
long ll_pos
//n_dwr_string lnvo_str
Choose Case ipo_requestortype //idw_requestor
	Case DataWindow!
		ls_val = idw_requestor.describe(as_expr)
	Case DataStore!
		ls_val = ids_requestor.describe(as_expr)
	Case DataWindowChild!
		ls_val = idwc_requestor.describe(as_expr)
	Case Else
		Return ""
End Choose   

ll_pos = pos(ls_val, '~t')
if ll_pos > 0 then
   ls_val = mid(ls_val, ll_pos + 1, len(ls_val) - ll_pos - 1)
	//
   //ls_val = lnvo_str.of_globalreplace(ls_val, '~~', '~~~~')
   //ls_val = lnvo_str.of_globalreplace(ls_val, '"', '~~~"')
   //ls_val = lnvo_str.of_globalreplace(ls_val, "'", "~~~'")
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_val = idw_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataStore!
			ls_val = ids_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataWindowChild!
			ls_val = idwc_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case Else
			Return ""
	End Choose   
	return ls_val
else
  return ls_val
end if

end function

public function string of_get_system_currency_format ();long ll_ret, ll_MonGrouping
String ls_sCurrency, ls_sMonDecimalSep /*"."*/, ls_sMonThousandSep /*","*/ 
String ls_sMonGrouping /*"3;0"*/ 
String ls_numFormat, ls_iCurrency, ls_iNegCurr
String ls_positive, ls_negative
n_dwr_string s


ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sCurrency", RegString!, ls_sCurrency)
If ll_ret <> 1 Then ls_sCurrency = "$"
ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "iCurrency", RegString!, ls_iCurrency)
If ll_ret <> 1 Then ls_iCurrency = "0"
ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "iNegCurr", RegString!, ls_iNegCurr)
If ll_ret <> 1 Then ls_iNegCurr = "0"
ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sMonDecimalSep", RegString!, ls_sMonDecimalSep)
If ll_ret <> 1 Then ls_sMonDecimalSep = "."
ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sMonThousandSep", RegString!, ls_sMonThousandSep)
If ll_ret <> 1 Then ls_sMonThousandSep = ","
ll_ret = RegistryGet("HKEY_CURRENT_USER\Control Panel\International", "sMonGrouping", RegString!, ls_sMonGrouping)
If ll_ret <> 1 Then ls_sMonGrouping = "3;0"


Choose Case ls_iCurrency
	Case "0"; ls_positive = "$n"
	Case "1"; ls_positive = "n$"
	Case "2"; ls_positive = "$ n"
	Case "3"; ls_positive = "n $"
	Case Else 
		ls_positive = "$n"
End Choose


Choose Case ls_iNegCurr
	Case "0" ; 	ls_negative = "($n)"
	Case "1" ; 	ls_negative = "-$n"
	Case "2" ;  ls_negative = "$-n"
	Case "3" ;	ls_negative = "$n-"
	Case "4" ;	ls_negative = "(n$)"
	Case "5" ;	ls_negative = "-n$"
	Case "6" ;	ls_negative = "n-$"
	Case "7" ;	ls_negative = "n$-"
	Case "8" ;	ls_negative = "-n $"
	Case "9" ;	ls_negative = "-$ n"
	Case "10";	ls_negative = "n $-"
	Case "11";	ls_negative = "$ n-"
	Case "12";	ls_negative = "$ -n"
	Case "13";	ls_negative = "n- $"
	Case "14";	ls_negative = "($ n)"
	Case "15";	ls_negative = "(n $)"
	Case Else 
		ls_negative = "-$n"
End Choose

// using only the first number from sMonGrouping
// TODO: full parse
ll_ret = Pos(ls_sMonGrouping, ";")
If ll_ret > 0 Then ls_sMonGrouping = Left(ls_sMonGrouping, ll_ret - 1)
ll_MonGrouping = Long(ls_sMonGrouping)  
If ll_MonGrouping <> 0 Then
	ls_numFormat = "#" + ls_sMonThousandSep + Fill("#", ll_MonGrouping - 1) + "0.00"
Else
	ls_numFormat = "#0.00"
End If
ls_numFormat = s.of_GlobalReplace(ls_positive + ";" + ls_negative, "n", ls_numFormat)
ls_numFormat = s.of_GlobalReplace(ls_numFormat, "$", ls_sCurrency)

Return ls_numFormat
end function

public function long of_describe_expr (string as_expr, long al_row, ref string as_prop_expr);string ls_val
long ll_pos
n_dwr_string lnvo_str
Choose Case ipo_requestortype //idw_requestor
	Case DataWindow!
		ls_val = idw_requestor.describe(as_expr)
	Case DataStore!
		ls_val = ids_requestor.describe(as_expr)
	Case DataWindowChild!
		ls_val = idwc_requestor.describe(as_expr)
	Case Else
		Return -1
End Choose   

ll_pos = pos(ls_val, '~t')
if ll_pos > 0 then
	ls_val = mid(ls_val, ll_pos + 1, len(ls_val) - ll_pos - 1)
   ls_val = lnvo_str.of_globalreplace(ls_val, "'", "~~~'")
	as_prop_expr = ls_val
   
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_val = idw_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataStore!
			ls_val = ids_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataWindowChild!
			ls_val = idwc_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case Else
			Return -1
	End Choose   
	if isNumber(ls_val) then return long(ls_val)
else
  as_prop_expr = ""
  if isNumber(ls_val) then return long(ls_val)
end if

return -1
end function

public function long of_evaluate0 (readonly string as_expr, long al_row);/**
 as_expr must be already escaped expression (" -> ~", ~ => ~~ )
*/

String ls_val
Choose Case ipo_requestortype 
	Case DataWindow!
		ls_val = idw_requestor.describe('evaluate("' + as_expr + '", ' + string(al_row) + ')')
	Case DataStore!
		ls_val = ids_requestor.describe('evaluate("' + as_expr + '", ' + string(al_row) + ')')
	Case DataWindowChild!
		ls_val = idwc_requestor.describe('evaluate("' + as_expr + '", ' + string(al_row) + ')')
	Case Else
		Return -1
End Choose   

If IsNumber(ls_val) Then 
	Return long(ls_val)
Else
	Return -1
End If

end function

public function long of_get_width (long al_row);long ll_ret 
If is_expr_width = "" Then
	ll_ret = il_cached_width
ElseIf is_expr_width = "-" Then
	il_cached_width = of_describe_expr(is_dwo_name + '.width', al_row, is_expr_width)
	ll_ret = il_cached_width
Else 
	ll_ret = of_evaluate0(is_expr_width, al_row)
End If

Return ll_ret

end function

public function long of_get_height (long al_row);long ll_ret, ll_pos, ll_lines_cnt = 1, ll_row_height, ll_row_width = 0, ll_i = 1, ll_start = 1, ll_val, ll_col_width
string ls_type, ls_val, ls_str_array[]
If is_expr_height = "" Then
	ll_ret = il_cached_height
ElseIf is_expr_height = "-" Then
	il_cached_height = of_describe_expr(is_dwo_name + '.height', al_row, is_expr_height)	
	if (ii_dwo_type = DT_COLUMN or ii_dwo_type = DT_COMPUTE or ii_dwo_type = DT_TEXT) then 		
		// Checking if  AutosizeHeight is ON
		if inv_parm.ib_enable_merge_cells then
			// If Grid DW and field in detail band and this corresponding flag in parameters switched on
			if inv_parent_band.ii_dw_processing = 1 and inv_parent_band.ii_band_type = 3 and inv_parm.ib_grid_columns_by_rowheight then
				// Fit column height to the rowheight
				ll_val = long(of_describe("evaluate('rowheight()', " + string(al_row) + ")"))
				ll_ret = ll_val - of_get_y1()
				is_expr_height = "-"			
			else // Other DW style
				if ib_autosize_height  and not inv_parm.ib_ignore_autosizeheight then	
					ls_val = string(of_getvalue(al_row))
					ll_col_width = of_get_width(al_row)
					ll_val = of_get_col_height_font(ll_col_width, ls_val, of_descr_font_face(), of_descr_font_italic(), &
												of_descr_font_underline(), of_descr_font_weight2(), &
												of_descr_font_height())
					ll_ret = ll_val
					is_expr_height = "-"			
				else
					ll_ret = il_cached_height	
				end if
			end if
		else
			ll_ret = il_cached_height	
		end if
	else
		ll_ret = il_cached_height	
	end if
	//ll_ret = il_cached_height	
Else 
	ll_ret = of_evaluate0(is_expr_height, al_row)
End If

Return ll_ret
end function

public function string of_evaluate_str0 (readonly string as_expr, long al_row);/**
 as_expr must be already escaped expression (" -> ~", ~ => ~~ )
*/

String ls_val
Choose Case ipo_requestortype 
	Case DataWindow!
		ls_val = idw_requestor.describe('evaluate("' + as_expr + '", ' + string(al_row) + ')')
	Case DataStore!
		ls_val = ids_requestor.describe('evaluate("' + as_expr + '", ' + string(al_row) + ')')
	Case DataWindowChild!
		ls_val = idwc_requestor.describe('evaluate("' + as_expr + '", ' + string(al_row) + ')')
	Case Else
		Return ""
End Choose   

Return ls_val

end function

public function string of_describe_str_expr (string as_expr, long al_row, ref string as_prop_expr);string ls_val
long ll_pos
n_dwr_string lnvo_str
Choose Case ipo_requestortype //idw_requestor
	Case DataWindow!
		ls_val = idw_requestor.describe(as_expr)
	Case DataStore!
		ls_val = ids_requestor.describe(as_expr)
	Case DataWindowChild!
		ls_val = idwc_requestor.describe(as_expr)
	Case Else
		Return ""
End Choose   

ll_pos = pos(ls_val, '~t')
if ll_pos > 0 then
	ls_val = mid(ls_val, ll_pos + 1, len(ls_val) - ll_pos - 1)
   ls_val = lnvo_str.of_globalreplace(ls_val, "'", "~~~'")
	as_prop_expr = ls_val
   
	Choose Case ipo_requestortype 
		Case DataWindow!
			ls_val = idw_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataStore!
			ls_val = ids_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case DataWindowChild!
			ls_val = idwc_requestor.describe('evaluate("' + ls_val + '", ' + string(al_row) + ')')
		Case Else
			Return ""
	End Choose   
	Return ls_val
else
	as_prop_expr = ""
	Return ls_val
end if

end function

private function integer of_getdddwcolumnids (datawindowchild adw, ref string as_id[]);String ls_empty[], ls_objects, ls_object[], ls_str, ls_id
n_dwr_string s
Long ll_objectcount, ll_i
as_id[] = ls_empty[]

ls_objects = adw.Describe('DataWindow.Objects')
ll_objectcount = s.of_parsetoarray ( ls_objects, '~t', ls_object )
For ll_i = 1 To ll_objectcount
	ls_id = adw.Describe ( ls_object[ll_i] + '.id' )
	If Long(ls_id) > 0 Then
   	ls_str = adw.Describe(ls_object[ll_i] + '.DDDW.Name')
      If (ls_str <> '!') And (ls_str <> '?') And (ls_str <> '') Then
         as_id[UpperBound(as_id[]) + 1] = ls_id
      End If
	End If
Next

Return 1
end function

public subroutine of_setsubbandy (long ai_subband_y);il_subband_y = ai_subband_y
//reset cache
il_cached_y1 = -1000000000
is_expr_y1 = "-"

il_cached_x1 = -1
is_expr_x1 = "-"

end subroutine

public function long of_process_nested (long al_row, long al_writer_row, n_dwr_grid anvo_hgrid, n_dwr_progress apo_progress);
// returns written rows count 

long ll_rown = 0, li_ret = 1
boolean lb_restoreOriginalRowOrder = false
If ib_usetrc Then
	// some trick code for PB :-)
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 1
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	ll_rown = 0
	
End If

//DataWindowChild ldwc_nested
If il_child_cache_row <> al_row Then
	/* [1]
	SetNull(ids_child_cache)
	il_child_cache_row = -1 // prepare for failure	
	If inv_parm.ii_nested_extract_method = 1 Then
		inv_nested_data.of_Nested2DS(is_nested_instance_id, is_nested_dataobject, is_parent_band_id, al_row, is_nested_dddw_column_ids[], ids_child_cache)
	End If	
	If IsNull(ids_child_cache) Then
		inv_parm.ii_nested_extract_method = 0
	*/	
		il_child_cache_row = -1 // prepare for failure	
		If al_row > 1 Then
			ids_reportdata.RowsMove(al_row, al_row,  Primary!, ids_reportdata, 1, Primary!)
			
			// if workaround for nested is ON then restore original row order
			lb_restoreOriginalRowOrder = inv_parm.ib_nested_workaround
		End IF
		li_ret = ids_reportdata.GetChild(is_dwo_name, idwc_child_cache)				
		If li_ret <> 1 Then
			Return 0
		End IF
	/* [1]
		ids_child_cache = of_dwc2ds(ldwc_nested, True)
	Else
		ids_child_cache.GroupCalc()
	End If
	*/
	il_child_cache_row = al_row
	
	// workaround for nested on Appeon
	il_child_cache_rowcount = idwc_child_cache.RowCount()		
End If

inv_nested_service_parm.il_writer_row = al_writer_row
inv_nested_service_parm.il_parent_row = al_row
inv_nested_service_parm.ipo_dynamic_requestor = idwc_child_cache
inv_nested_service_parm.invo_dynamic_hgrid = anvo_hgrid

// workaround for nested on Appeon
if inv_parm.ib_nested_workaround then
	inv_nested_service_parm.il_requestor_rowcount = il_child_cache_rowcount
end if

inv_nested_service_parm.ipo_progress = apo_progress
//inv_nested_service_parm.il_change_progress_each = al_change_progress_each
//inv_nested_service_parm.il_cur_change_progress = al_cur_change_progress

li_ret = inv_nestedservice.of_process_work()
If li_ret = 1 Then
	ll_rown = inv_nested_service_parm.il_writer_row - al_writer_row
	//al_cur_change_progress = inv_nested_service_parm.il_cur_change_progress
else
End IF

// if workaround for nested is ON then restore original row order
If lb_restoreOriginalRowOrder Then
	// if workaround for nested is ON then restore original row order
	ids_reportdata.RowsMove(1, 1,  Primary!, ids_reportdata, al_row + 1, Primary!)
End If
		
Return ll_rown

end function

public function integer of_descr_font_weight2 ();integer li_ret 
string ls_value

li_ret = of_check_property('font.weight', ib_font_weight_expr, is_font_weight_expr, ls_value)
if li_ret = 1 then
	if isNumber(ls_value) then
		return abs(integer(ls_value))
	else
		return 400
	end if
else
	return 400
end if

end function

public function long of_descr_alignment2 ();integer li_ret 
string ls_value = '-1'

li_ret = of_check_property('alignment', ib_alignment_expr, is_alignment_expr, ls_value)
if li_ret <> 1 then 
	if is_coltype = 'n' then
		return inv_const.ALIGN_RIGHT
	else
		return inv_const.ALIGN_LEFT
	end if
else
	return Long(ls_value)
end if

end function

public function long of_descr_color2 ();integer li_ret 
string ls_value
long ll_color

li_ret = of_check_property('Color', ib_color_expr, is_color_expr, ls_value)
if li_ret = 1 then
   if isNumber(ls_value) then
		ll_color = long(ls_value)
		return ll_color
   else
      return 0
   end if
else
	return 0
end if

end function

public function long of_descr_bg_color2 ();integer li_ret 
string ls_str, ls_bgmode, ls_band
string ls_value
long ll_color

ll_color = 1073741824 //0x40000000, Window Background
If Not ib_band_bg Then
	ls_str = of_describe(is_dwo_name + '.Background.Mode')
	if ls_str <> '1' then
		li_ret = of_check_property('Background.Color', ref ib_bg_color_expr, ref is_bg_color_expr, ref ls_value)
		if li_ret = 1 then
			 if isNumber(ls_value) then
				 ll_color = long(ls_value) 
			 else
			 end if
		else
		end if
	else
	end if
Else
	//553648127 or 536870912 - transparent
	
	// if bg mode = transparent or (Background.Color is transparent and not expr) or Background.Color is invalid then      
	//    use band bg color 
	//    if band bg color is transparent then
	//       use dw color  
	//    end
	// else
	//    use obj bg color
	// end
	
	ls_bgmode = of_describe(is_dwo_name + '.Background.Mode')
	li_ret = of_check_property('Background.Color', ref ib_bg_color_expr, ref is_bg_color_expr, ref ls_value)
	if ls_bgmode = '1' or &
	   (Not ib_bg_color_expr and (ls_value = "553648127" or ls_value = "536870912")) or &
		li_ret <> 1 or Not isNumber(ls_value)  then 
		//use band bg color  
		ls_value = String(inv_parent_band.of_descr_bg_color())
		ib_bg_color_expr = inv_parent_band.ib_bg_color_expr
		is_bg_color_expr = inv_parent_band.is_bg_color_expr
		if (Not ib_bg_color_expr and (ls_value = "553648127" or ls_value = "536870912")) or &
			li_ret <> 1 or Not isNumber(ls_value)  then 
			// use dw color
			li_ret = of_check_property("::Datawindow.Color", ref ib_bg_color_expr, ref is_bg_color_expr, ref ls_value)
		end if
	else
		//use obj bg color
	end if
	ll_color = long(ls_value) 
End if
return ll_color
end function

public function long of_get_format (long al_row);integer li_ret =1
long ll_format_ix
n_xls_format lnvo_temp_format

if not ib_custom_format then
	return il_format_ix
end if
	
al_row = al_row + ii_row_in_detail - 1
if al_row > il_dw_row_count then 
	return il_format_ix
end if

if ib_bg_color_expr       then of_eval_bg_color(al_row)
if ib_color_expr          then of_eval_color(al_row)
if ib_format_expr         then of_eval_numformat( al_row)
if ib_font_face_expr      then of_eval_font_face(al_row)
if ib_font_underline_expr then of_eval_font_underline(al_row)
if ib_font_italic_expr    then of_eval_font_italic(al_row)
if ib_font_weight_expr    then of_eval_font_weight(al_row)
if ib_alignment_expr      then of_eval_alignment(al_row)

// TODO process font height units properly
if isValid(inv_parm) and not(isNull(inv_parm)) then
	if (inv_parm.ib_font_height_expression) then
		if ib_font_height_expr    then of_eval_font_height(al_row)
	end if
else
	if ib_font_height_expr    then of_eval_font_height(al_row)
end if

if ib_font_escapement_expr    then of_eval_font_escapement(al_row)

ll_format_ix = inv_book.of_AddFormat(inv_format)
return ll_format_ix
end function

public function integer of_eval_alignment (long al_row);long ll_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_value = Long(Trim(of_describe('evaluate("' + is_alignment_expr + '", ' + string(al_row) + ')')))
	inv_format.setHAlign(inv_format.handle, ll_value)
	return 1
end if

return -1

end function

public function integer of_eval_bg_color (long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = Long(of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')'))
	inv_format.setBgColor(inv_format.handle, ll_color)
	return 1
end if

return -1

end function

public function integer of_eval_color (long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = Long(of_describe('evaluate("' + is_color_expr + '", ' + string(al_row) + ')'))
	inv_format.setFgColor(inv_format.handle, ll_color)
 	return 1
end if

return -1

end function

public function integer of_eval_font_face (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_font_face_expr + '", ' + string(al_row) + ')'))
	if ls_value <> '' then
		inv_format.SetFontName(inv_format.handle, ls_value)
		return 1
	end if
end if

return -1

end function

public function integer of_eval_font_height (long al_row);long ll_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_value = Long(of_describe('evaluate("' + is_font_height_expr + '", ' + string(al_row) + ')'))
   inv_format.SetFontSize(inv_format.handle, abs(ll_value))
   return 1
end if

return -1

end function

public function integer of_eval_font_italic (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_italic_expr + '", ' + string(al_row) + ')')
   if (lower(ls_value) = 'yes') or (ls_value = '1') then
		inv_format.SetFontItalic(inv_format.handle, 1)
	else
		inv_format.SetFontItalic(inv_format.handle, 0)
	end if
	return 1
end if

return -1

end function

public function integer of_eval_font_underline (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_underline_expr + '", ' + string(al_row) + ')')
	if ((lower(ls_value) = 'yes') or (ls_value = '1')) then
   	inv_format.SetFontUnderline(inv_format.handle, 1)
	else
		inv_format.SetFontUnderline(inv_format.handle, 0)
	end if
	return 1
end if

return -1

end function

public function integer of_eval_font_weight (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = of_describe('evaluate("' + is_font_weight_expr + '", ' + string(al_row) + ')')
	if isNumber(ls_value) then
   	inv_format.setFontWeight(inv_format.handle, abs(integer(ls_value)))
	else
   	inv_format.setFontWeight(inv_format.handle, 400)
	end if
	return 1
end if

return -1

end function

public function integer of_eval_numformat (long al_row);string ls_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ls_value = trim(of_describe('evaluate("' + is_format_expr + '", ' + string(al_row) + ')'))
 	if ls_value = '' then ls_value = '[General]'
	ls_value = of_change_format(ls_value, is_coltype)
	inv_format.SetNumFormat(inv_format.handle, ls_value)
	return 1
end if

return -1

end function

public function long of_descr_font_charset ();integer li_ret 

li_ret = Long(of_describe(is_dwo_name + '.Font.Charset'))
return li_ret

end function

public function long of_descr_font_family ();integer li_ret 

li_ret = Long(of_describe(is_dwo_name + '.Font.Family'))
return li_ret

end function

public subroutine of_cancel_nested ();if ii_dwo_type = DT_REPORT then
	inv_nestedservice.of_cancel()
end if
end subroutine

public function integer of_descr_font_escapement ();integer li_ret 
string ls_value
integer li_value = 0

li_ret = of_check_property('font.escapement', ib_font_escapement_expr, is_font_escapement_expr, ls_value)
if li_ret = 1 then
	if isNumber(ls_value) then
		li_value = integer(ls_value) / 10
	end if
end if
return li_value
end function

public function integer of_eval_font_escapement (long al_row);long ll_value

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_value = Long(of_describe('evaluate("' + is_font_escapement_expr + '", ' + string(al_row) + ')'))
   inv_format.SetRotation(inv_format.handle, Long(ll_value / 10))
   return 1
end if

return -1

end function

public function integer of_setrect (long al_x1, long al_y1, long al_x2, long al_y2);
int ll_x1, ll_w, ll_y1, ll_h, ll_x2, ll_y2

ll_x1 = of_get_x1(1)
ll_x2 = of_get_x2(1)
ll_w = of_get_width(1)
ll_y1 = of_get_y1(1)
ll_y2 = of_get_y2(1)
ll_h = of_get_height(1)

il_cached_x1 += al_x1 - ll_x1
il_cached_y1 += al_y1 - ll_y1
il_cached_x2 += al_x2 - ll_x2
il_cached_y2 += al_y2 - ll_y2

il_cached_width += al_x2 - al_x1 - ll_w
il_cached_height += al_y2 - al_y1 - ll_h

Return 1
end function

public function boolean of_render (n_dwr_worksheet anv_sheet, long al_row, long al_base_y, long al_units, n_dwr_progress apo_progress);Return False
end function

public function long of_get_band_bg_color (long al_row);integer li_color_index 
string ls_value
long ll_color

al_row = al_row + ii_row_in_detail - 1
if al_row <= il_dw_row_count then 
	ll_color = Long(of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')'))
	inv_format.setBgColor(inv_format.handle, ll_color)
	return 1
end if

return -1

end function

public function integer of_use_band_bg (boolean ab_enable);ib_band_bg = ab_enable
Return 1
end function

public function integer of_register (powerobject apo_requestor, n_dwr_workbook anv_book, n_dwr_colors anvo_colors, long al_base_x, long al_base_y, long al_subband_y, boolean ab_band_background);il_base_x = al_base_x
il_base_y = al_base_y
il_subband_y = al_subband_y
ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
	Case DataStore!
		ids_requestor = ipo_requestor
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
	Case Else
		Return -1
End Choose   

//invo_writer = anvo_writer
inv_book = anv_book
invo_colors = anvo_colors
of_use_band_bg(ab_band_background)
return 1
end function

public subroutine of_getbgrect (ref st_rect ast_rect, long al_row);
end subroutine

public subroutine of_dispose ();
// force GC to destroy objects with mutual referrences

SetNull(inv_nestedservice)
SetNull(inv_parent_band)
end subroutine

public subroutine of_setparentband (powerobject anv_band);inv_parent_band = anv_band
end subroutine

public function long of_get_col_height_font (integer ai_col_width, string str, string font_name, boolean font_italic, integer font_underline, integer font_weight, integer font_size);if inv_parm.ib_nonvisual_calc_height then
	return inv_book.invo_height.of_get_col_height_font(ai_col_width, str, font_name, font_italic, font_underline, font_weight, font_size, ii_units)
else
	return inv_book.ws.wf_get_col_height_font(ai_col_width, str, font_name, font_italic, font_underline, font_weight, font_size, ii_units)
end if
end function

public function integer of_do_static_x_markup (n_dwr_worksheet anv_sheet);// Records all static X coordinates 
// Returns 1 if all X coordinates are static 
// Otherwise returns -1 and some of X might be not recorded
//

Int li_ret = 1
Long ll_x1, ll_x2

If ii_dwo_type = DT_REPORT Then
	If IsValid(inv_nestedservice) Then
		li_ret = inv_nestedservice.of_do_static_x_markup(anv_sheet)
	Else
		li_ret = -1
	End If
	Return li_ret
End If

ll_x1 = of_get_x1(1)
ll_x2 = of_get_x2(1)
If is_expr_x1 = "" and is_expr_x2 = "" Then 
	anv_sheet.AddXInterval(anv_sheet.Handle, ll_x1, ll_x2, ii_units)
Else
	li_ret = -1
End If

Return li_ret
end function

protected function integer of_get_column_display_type ();string ls_str

choose case ii_dwo_type
   case 1 // column

      ls_str = of_describe(is_dwo_name + '.CheckBox.On')
      if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_CHECKBOX
      end if

      ls_str = of_describe(is_dwo_name + '.DDDW.Name')
      if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_DDDW
      end if

      ls_str = of_describe(is_dwo_name + '.DDLB.Required')
      if (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_DDLB
      end if

      ls_str = of_describe(is_dwo_name + '.RadioButtons.Columns')
      if (ls_str <> '0') and (ls_str <> '!') and (ls_str <> '?') and (ls_str <> '') then
         return CDT_TEXT
      end if
    
      ls_str = of_describe(is_dwo_name + '.Edit.CodeTable')
      if (lower(ls_str) = 'yes') then
         return CDT_CODETABLE
      end if
      return CDT_TEXT
    
   case 2,3 // compute, text
     return CDT_TEXT
   case 4   // report
     return CDT_REPORT
   case else
	  return CDT_TEXT
end choose

end function

public function integer of_register_dynamic2 (powerobject apo_requestor, long al_rowcount);ipo_requestor = apo_requestor
ipo_requestortype = ipo_requestor.TypeOf()
Choose Case ipo_requestortype 
	Case DataWindow!
		idw_requestor = ipo_requestor
		il_dw_row_count = al_rowcount
	Case DataStore!
		ids_requestor = ipo_requestor
		il_dw_row_count = al_rowcount
	Case DataWindowChild!
		idwc_requestor = ipo_requestor
		il_dw_row_count = al_rowcount
	Case Else
		Return -1
End Choose  

Return 1
end function

public function boolean of_descr_bitmapname ();integer li_ret 
string ls_value, ls_dummy = ""
boolean lb_dummy

li_ret = of_check_property('bitmapname', lb_dummy, ls_dummy, ls_value)
if li_ret = 1 then
	return ((lower(ls_value) = 'yes') or (ls_value = '1'))
else
	return false
end if
end function

on n_dwr_field.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_field.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;inv_const = create n_dwr_const
end event

