forward
global type n_dwr_picture from n_dwr_field
end type
end forward

global type n_dwr_picture from n_dwr_field
end type
global n_dwr_picture n_dwr_picture

type variables
protected string is_picture = ""

boolean ib_picture_expr = false
string is_picture_expr = ""

protected n_dwr_sub inv_sub
end variables

forward prototypes
public function string of_descr_filename ()
public function integer of_init (string as_dwo_name, integer ai_dwo_type)
public function integer of_setformat ()
end prototypes

public function string of_descr_filename ();integer li_ret 
string ls_value

li_ret = of_check_property('filename', ib_picture_expr, is_picture_expr, ls_value)
if li_ret = 1 then
   return ls_value
else
	return ""
end if

end function

public function integer of_init (string as_dwo_name, integer ai_dwo_type);integer li_ret = 1

is_dwo_name = as_dwo_name


ii_dwo_type = ai_dwo_type
choose case ii_dwo_type
  	case DT_PICTURE
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

public function integer of_setformat ();integer li_ret = 1
string ls_format
integer li_color_index
long ll_color


inv_format = inv_book.of_CreateFormat()
	 
string ls_border_style
 
ls_border_style = of_describe(is_dwo_name + '.Border') 
if isNumber(ls_border_style) and integer(ls_border_style) > 0 then
	inv_format.setBorderStyle(inv_format.handle, 1)
else
	if integer(of_describe ( 'Datawindow.Processing' )) = 1 then
		inv_format.setBorderStyle(inv_format.handle, 7)
	end if
end if

il_format_ix = inv_book.of_AddFormat(inv_format)								


return li_ret
end function

on n_dwr_picture.create
call super::create
end on

on n_dwr_picture.destroy
call super::destroy
end on

