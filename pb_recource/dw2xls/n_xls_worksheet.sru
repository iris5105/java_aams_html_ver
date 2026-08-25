forward
global type n_xls_worksheet from nonvisualobject
end type
type cell_coord from structure within n_xls_worksheet
end type
type cell_info from structure within n_xls_worksheet
end type
end forward

type CELL_COORD from structure
	long		x1
	long		x2
	long		y1
	long		y2
end type

type cell_info from structure
	long		valuetype
	long		valuesize
end type

shared variables

end variables

global type n_xls_worksheet from nonvisualobject
end type
global n_xls_worksheet n_xls_worksheet

type prototypes
protected:
function long add_cell_double (ulong storage, double value, long x1, long x2, long y1, long y2, long format, long unit) &
	library "pb2xls" alias for "add_cell_double"
function long add_cell_string (ulong storage, readonly string value, long x1, long x2, long y1, long y2, long format, long unit) &
	library "pb2xls" alias for "add_cell_string"
function long add_h_break (ulong storage, long y, long unit) &
	library "pb2xls" alias for "add_h_break"
	
function long get_cell_info(ulong storage, long ix, ref CELL_INFO info) &
	library "pb2xls" alias for "get_cell_info"

function long get_cell_double(ulong storage, long ix, ref double value, ref long format, ref CELL_COORD coord) &
	library "pb2xls" alias for "get_cell_double"
	
function long get_cell_string(ulong storage, long ix, ref string value, ref long format, ref CELL_COORD coord) &
	library "pb2xls" alias for "get_cell_string"

subroutine get_y_info(ulong storage, ref long baseRow, ref long maxRow) &
	library "pb2xls" alias for "get_y_info"

subroutine get_x_info(ulong storage, ref long baseCol, ref long maxCol) &
	library "pb2xls" alias for "get_x_info"

function double get_row_height(ulong storage, long row) &
	library "pb2xls" alias for "get_row_height"

function double get_col_width(ulong storage, long col) &
	library "pb2xls" alias for "get_col_width"

function long update_x(ulong storage) &
	library "pb2xls" alias for "update_x"

function long update_y(ulong storage) &
	library "pb2xls" alias for "update_y"

subroutine prepare_x(ulong storage) &
	library "pb2xls" alias for "prepare_x"

subroutine prepare_y(ulong storage) &
	library "pb2xls" alias for "prepare_y"

function long get_cell_count(ulong storage) &
	library "pb2xls" alias for "get_cell_count"


subroutine begin_band(ulong storage) &
	library "pb2xls" alias for "begin_band"

//subroutine end_band(ulong storage, ref CELL_COORD coord) &
//	library "pb2xls" alias for "end_band"
Function long end_band(ulong storage, long units) &
	library "pb2xls" alias for "end_band"

function ulong create_cell_storage() library "pb2xls" alias for "create_cell_storage"
subroutine free_cell_storage(ulong storage) library "pb2xls" alias for "free_cell_storage"



Function ulong GetModuleFileNameA (LongPtr hinstModule, ref string lpszPath, ulong cchPath ) Library "KERNEL32.DLL" 




Function ulong GetModuleFileNameW (LongPtr hinstModule, ref string lpszPath, ulong cchPath ) Library "KERNEL32.DLL" 




Function LongPtr LoadLibraryA (ref string lpLibFileName) Library "KERNEL32.DLL"




Function LongPtr LoadLibraryW (ref string lpLibFileName) Library "KERNEL32.DLL"




Function boolean FreeLibrary (ref LongPtr hLibModule) Library "KERNEL32.DLL"



subroutine set_align(ulong storage, double x, double y) library "pb2xls" alias for "set_align"
subroutine set_unit_x_coef(ulong storage, long unit, double coef) library "pb2xls" alias for "set_unit_x_coef"
subroutine set_unit_y_coef(ulong storage, long unit, double coef) library "pb2xls" alias for "set_unit_y_coef"

end prototypes

type variables
public string is_worksheetname
public n_xls_subroutines_v97 invo_sub;

protected:
ulong iul_cellstorage = 0
constant long TYPE_NONE = 0
constant long TYPE_DOUBLE = 1 
constant long TYPE_STRING = 2
constant long TYPE_BLOB = 3
constant long TYPE_HBREAK = 4

Double id_x_zoom = 1.0
Double id_y_zoom = 1.0

private String _is_value

protected n_dwr_sub inv_unitsub
end variables

forward prototypes
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date, n_xls_format anvo_format)
public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format anvo_format)
public function integer of_set_row_height (long al_row, long al_height)
public function integer of_set_row_format (long al_row, n_xls_format anvo_format)
public function integer of_set_row_hidden (long al_row, boolean ab_hidden)
public function integer of_set_column_width (long al_col, long al_width)
public function integer of_set_column_format (long al_col, n_xls_format anvo_format)
public function integer of_set_column_hidden (long al_col, boolean ab_hidden)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, double adb_num, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, blob ab_unicode_str, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, string as_str, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, time at_time, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, datetime adt_datetime, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, date ad_date, n_xls_format anvo_format)
public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, n_xls_format anvo_format)
public function string of_get_name ()
public function blob of_get_name_unicode ()
public function integer of_select ()
public function integer of_activate ()
public function integer of_set_first_sheet ()
public function integer of_protect (string as_password)
public function integer of_set_column (unsignedinteger ai_firstcol, unsignedinteger ai_lastcol, double ad_width, n_xls_format anvo_format, boolean ab_hidden)
public function integer of_set_selection (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col)
public function integer of_set_selection (unsignedinteger ai_row, unsignedinteger ai_col)
public function integer of_thaw_panes (double ad_y, double ad_x, unsignedinteger ai_rowtop, unsignedinteger ai_colleft)
public function integer of_freeze_panes (unsignedinteger ai_row, unsignedinteger ai_col, unsignedinteger ai_rowtop, unsignedinteger ai_colleft)
public function integer of_set_portrait ()
public function integer of_set_landscape ()
public function integer of_set_paper (unsignedinteger ai_paper_size)
public function integer of_set_paper ()
public function integer of_set_header (string as_header, double ad_margin_head)
public function integer of_set_footer (string as_footer, double ad_margin_foot)
public function integer of_set_header (blob ab_header, double ad_margin_head)
public function integer of_set_footer (blob ab_footer, double ad_margin_foot)
public function integer of_center_horizontally ()
public function integer of_center_horizontally (boolean ab_option)
public function integer of_center_vertically ()
public function integer of_center_vertically (boolean ab_option)
public function integer of_set_margins (double ad_margin)
public function integer of_set_margins_lr (double ad_margin)
public function integer of_set_margins_tb (double ad_margin)
public function integer of_set_margin_left (double ad_margin)
public function integer of_set_margin_right (double ad_margin)
public function integer of_set_margin_top (double ad_margin)
public function integer of_set_margin_bottom (double ad_margin)
public function integer of_repeat_rows (unsignedinteger ai_first_row, unsignedinteger ai_last_row)
public function integer of_repeat_columns (unsignedinteger ai_first_col, unsignedinteger ai_last_col)
public function integer of_print_area (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col)
public function integer of_hide_gridlines (unsignedinteger ai_option)
public function integer of_print_row_col_headers (boolean ab_print_headers)
public function integer of_fit_to_pages (unsignedinteger ai_width, unsignedinteger ai_height)
public function integer of_add_h_pagebreak (unsignedinteger ai_hbreak)
public function integer of_add_v_pagebreak (unsignedinteger ai_vbreak)
public function integer of_set_zoom (unsignedinteger ai_scale)
public function integer of_set_print_scale (unsignedinteger ai_scale)
public function integer of_set_row_height (long al_row, double ad_height)
public function integer of_set_column_width (long al_col, double ad_width)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y, readonly double ad_scale_width, readonly double ad_scale_height)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename)
public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y)
protected function integer of_xf (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format anvo_format)
public function integer of_update_x ()
public function long of_get_cell_count ()
public function integer of_write_cell (long ai_cell, boolean ab_merge)
public function integer of_write (long ai_row, long ai_col, double aa_value, long ai_format)
public function integer of_write (long ai_row, long ai_col, string aa_value, long ai_format)
public function integer of_write (long ai_row, long ai_col, blob aa_value, long ai_format)
public subroutine of_set_merge_range (long ai_format)
protected function integer of_merge_cells (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col)
public function long of_get_row_count ()
public function long of_get_column_count ()
public function long of_update_y ()
public subroutine of_set_point_to_row_zoom (double ad_x, double ad_y)
public subroutine of_begin_band ()
private function string of_getexedir ()
public function boolean of_iswidepb ()
public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, double aa_value, n_xls_format anvo_format, integer ai_units)
public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, string aa_value, n_xls_format anvo_format, integer ai_units)
public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, time aa_value, n_xls_format anvo_format, integer ai_units)
public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, datetime aa_value, n_xls_format anvo_format, integer ai_units)
public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, date aa_value, n_xls_format anvo_format, integer ai_units)
private subroutine of_initunitconvertor ()
public subroutine of_add_y_pagebreak (long al_y, integer ai_unit)
public function long of_end_band (integer ai_units)
public subroutine of_setalign (double ad_x, double ad_y)
public subroutine of_initdata ()
end prototypes

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str);return of_write(ai_row, ai_col, invo_sub.to_ansi(ab_unicode_str))
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, double adb_num, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, string as_str, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, blob ab_unicode_str, n_xls_format anvo_format);return of_write(ai_row, ai_col, invo_sub.to_ansi(ab_unicode_str), anvo_format)
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, time at_time, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, datetime adt_datetime, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, date ad_date, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_write (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_row_height (long al_row, long al_height);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_row_format (long al_row, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_row_hidden (long al_row, boolean ab_hidden);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_column_width (long al_col, long al_width);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_column_format (long al_col, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_column_hidden (long al_col, boolean ab_hidden);// Generated default script
int retVar;
return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, double adb_num, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, blob ab_unicode_str, n_xls_format anvo_format);return of_merge_write(ai_first_row, ai_first_col, ai_last_row, ai_last_col, invo_sub.to_ansi(ab_unicode_str), anvo_format)
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, string as_str, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, time at_time, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, datetime adt_datetime, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, date ad_date, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function integer of_merge_write (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col, n_xls_format anvo_format);// Generated default script
int retVar;
return retVar;
end function

public function string of_get_name ();// Generated default script
string retVar;
return retVar;
end function

public function blob of_get_name_unicode ();return invo_sub.to_unicode(of_get_name());
end function

public function integer of_select ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_activate ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_first_sheet ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_protect (string as_password);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_column (unsignedinteger ai_firstcol, unsignedinteger ai_lastcol, double ad_width, n_xls_format anvo_format, boolean ab_hidden);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_selection (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_selection (unsignedinteger ai_row, unsignedinteger ai_col);// Generated default script
int retVar;
return retVar;
end function

public function integer of_thaw_panes (double ad_y, double ad_x, unsignedinteger ai_rowtop, unsignedinteger ai_colleft);// Generated default script
int retVar;
return retVar;
end function

public function integer of_freeze_panes (unsignedinteger ai_row, unsignedinteger ai_col, unsignedinteger ai_rowtop, unsignedinteger ai_colleft);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_portrait ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_landscape ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_paper (unsignedinteger ai_paper_size);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_paper ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_header (string as_header, double ad_margin_head);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_footer (string as_footer, double ad_margin_foot);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_header (blob ab_header, double ad_margin_head);return of_set_header(invo_sub.to_ansi(ab_header), ad_margin_head)
end function

public function integer of_set_footer (blob ab_footer, double ad_margin_foot);return of_set_footer(invo_sub.to_ansi(ab_footer), ad_margin_foot)
end function

public function integer of_center_horizontally ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_center_horizontally (boolean ab_option);// Generated default script
int retVar;
return retVar;
end function

public function integer of_center_vertically ();// Generated default script
int retVar;
return retVar;
end function

public function integer of_center_vertically (boolean ab_option);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margins (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margins_lr (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margins_tb (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margin_left (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margin_right (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margin_top (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_margin_bottom (double ad_margin);// Generated default script
int retVar;
return retVar;
end function

public function integer of_repeat_rows (unsignedinteger ai_first_row, unsignedinteger ai_last_row);// Generated default script
int retVar;
return retVar;
end function

public function integer of_repeat_columns (unsignedinteger ai_first_col, unsignedinteger ai_last_col);// Generated default script
int retVar;
return retVar;
end function

public function integer of_print_area (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col);// Generated default script
int retVar;
return retVar;
end function

public function integer of_hide_gridlines (unsignedinteger ai_option);// Generated default script
int retVar;
return retVar;
end function

public function integer of_print_row_col_headers (boolean ab_print_headers);// Generated default script
int retVar;
return retVar;
end function

public function integer of_fit_to_pages (unsignedinteger ai_width, unsignedinteger ai_height);// Generated default script
int retVar;
return retVar;
end function

public function integer of_add_h_pagebreak (unsignedinteger ai_hbreak);// Generated default script
int retVar;
return retVar;
end function

public function integer of_add_v_pagebreak (unsignedinteger ai_vbreak);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_zoom (unsignedinteger ai_scale);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_print_scale (unsignedinteger ai_scale);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_row_height (long al_row, double ad_height);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_column_width (long al_col, double ad_width);// Generated default script
int retVar;
return retVar;
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y, readonly double ad_scale_width, readonly double ad_scale_height);integer li_ret = 1

return li_ret
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename);integer li_ret = 1

return li_ret
end function

public function integer of_insert_bitmap (readonly unsignedinteger ai_row, readonly unsignedinteger ai_col, readonly string as_bitmap_filename, readonly unsignedinteger ai_x, readonly unsignedinteger ai_y);integer li_ret = 1

return li_ret
end function

protected function integer of_xf (unsignedinteger ai_row, unsignedinteger ai_col, n_xls_format anvo_format);return -1
end function

public function integer of_update_x ();long li_base_col, li_max_col, li_col
double ld_col_w

prepare_x(iul_cellstorage)

get_x_info(iul_cellstorage, li_base_col, li_max_col)

For li_col = li_base_col To li_max_col 
	ld_col_w = get_col_width(iul_cellstorage, li_col)
	of_set_column_width(li_col, ld_col_w)
Next

Return update_x(iul_cellstorage)
// returns max Y
end function

public function long of_get_cell_count ();Return get_cell_count(iul_cellstorage)
end function

public function integer of_write_cell (long ai_cell, boolean ab_merge);CELL_INFO info
CELL_COORD coord
long li_format
long li_ret = 1, li_row, li_col

ai_cell --
info.valueSize = -1
li_ret = get_cell_info(iul_cellstorage, ai_cell, info)
If li_ret < 0 Then 
	Return -1
End If

Choose Case info.valueType
	Case TYPE_STRING
		String ls_value
		ls_value = Space(info.valueSize)
		li_ret = get_cell_string(iul_cellstorage, ai_cell, ls_value, li_format, coord)
		If li_ret < 0 Then
			Return -1
		End If
		li_ret = of_write(coord.y1, coord.x1, ls_value, li_format)
	Case TYPE_DOUBLE
		double ld_value
		li_ret = get_cell_double(iul_cellstorage, ai_cell, ld_value, li_format, coord)
		If li_ret < 0 Then
			Return -1
		End If
		li_ret = of_write(coord.y1, coord.x1, ld_value, li_format)
	Case TYPE_HBREAK
		li_ret = of_add_h_pagebreak(info.valueSize)
	Case Else
		Return -1
End Choose

If Not ab_merge Then
	Return 1
End If

// in coord X2 
coord.y2 --
coord.x2 --

If coord.y1 >= coord.y2 And coord.x1 >= coord.x2 Then
	Return 1
End If

//Pad out the rest of the area with formatted blank cells
For li_row = coord.y1 To coord.y2
	For li_col = coord.x1 To coord.x2
		If li_row = coord.y1 And li_col = coord.x1 Then Continue
   	of_write(li_row, li_col, "", li_format)
   Next
Next

of_merge_cells(coord.y1, coord.x1, coord.y2, coord.x2)

Return 1
end function

public function integer of_write (long ai_row, long ai_col, double aa_value, long ai_format);Return 1
end function

public function integer of_write (long ai_row, long ai_col, string aa_value, long ai_format);Return 1
end function

public function integer of_write (long ai_row, long ai_col, blob aa_value, long ai_format);Return 1
end function

public subroutine of_set_merge_range (long ai_format);

end subroutine

protected function integer of_merge_cells (unsignedinteger ai_first_row, unsignedinteger ai_first_col, unsignedinteger ai_last_row, unsignedinteger ai_last_col);Return 1
end function

public function long of_get_row_count ();Return 0
end function

public function long of_get_column_count ();Return 0
end function

public function long of_update_y ();long li_base_row, li_max_row, li_row
double ld_row_h

prepare_y(iul_cellstorage)

get_y_info(iul_cellstorage, li_base_row, li_max_row)

For li_row = li_base_row To li_max_row 
	ld_row_h = get_row_height(iul_cellstorage, li_row)
	of_set_row_height(li_row, ld_row_h)
Next

Return update_y(iul_cellstorage)
// returns max Y
end function

public subroutine of_set_point_to_row_zoom (double ad_x, double ad_y);id_x_zoom = ad_x
id_y_zoom = ad_y

end subroutine

public subroutine of_begin_band ();begin_band(iul_cellstorage)
end subroutine

private function string of_getexedir ();String ls_path
Long li_max = 1024, li_pos

LongPtr appHandle

appHandle = Handle(GetApplication())
If appHandle = 0 Then
	//IDE
	ClassDefinition lcd
	lcd = this.ClassDefinition
	ls_path = lcd.LibraryName
Else
	//Run-time
	ls_path = Space(li_max)
	If of_IsWidePB() Then
		GetModuleFileNameW(appHandle, ls_path, li_max)
	Else
		GetModuleFileNameA(appHandle, ls_path, li_max)
	End If
End If
li_pos = Pos(Reverse(ls_path), "\")
If li_pos > 0 Then
	ls_path = Left(ls_path, Len(ls_path) - li_pos)
Else
	ls_path = "."
End If

Return ls_path
end function

public function boolean of_iswidepb ();Return Len(blob("*")) = 2
end function

public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, double aa_value, n_xls_format anvo_format, integer ai_units);long li_xf = 0
If Not IsNull(anvo_format) And IsValid(anvo_format) Then
	li_xf = of_xf(-1, -1, anvo_format)
Else
	// not supported yet
	Return -1
End If
	
long lul_cell
lul_cell = add_cell_double(iul_cellstorage, aa_value, ai_x1, ai_x2, ai_y1, ai_y2, li_xf, ai_units)

Return 1
end function

public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, string aa_value, n_xls_format anvo_format, integer ai_units);long li_xf = 0
If Not IsNull(anvo_format) And IsValid(anvo_format) Then
	li_xf = of_xf(-1, -1, anvo_format)
Else
	// not supported yet
	Return -1
End If
	
long lul_cell
lul_cell = add_cell_string(iul_cellstorage, aa_value, ai_x1, ai_x2, ai_y1, ai_y2, li_xf, ai_units)

Return 1
end function

public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, time aa_value, n_xls_format anvo_format, integer ai_units);long li_xf = 0
If Not IsNull(anvo_format) And IsValid(anvo_format) Then
	li_xf = of_xf(-1, -1, anvo_format)
Else
	// not supported yet
	Return -1
End If

double ld_val
int li_hour, li_minute, li_second

li_hour   = hour(aa_value)
li_minute = minute(aa_value)
li_second = second(aa_value)

ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)

long lul_cell
lul_cell = add_cell_double(iul_cellstorage, ld_val, ai_x1, ai_x2, ai_y1, ai_y2, li_xf, ai_units)

Return 1
end function

public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, datetime aa_value, n_xls_format anvo_format, integer ai_units);long li_xf = 0
If Not IsNull(anvo_format) And IsValid(anvo_format) Then
	li_xf = of_xf(-1, -1, anvo_format)
Else
	// not supported yet
	Return -1
End If

double ld_val
time lt_time
string ls_time 
int li_hour, li_minute, li_second

lt_time = time(aa_value)
//-- 09.09.2004 bug fixed function time(...)
ls_time = string(lt_time)
lt_time = time(ls_time)
//--
li_hour   = hour(lt_time)
li_minute = minute(lt_time)
li_second = second(lt_time)

ld_val = daysafter(1899-12-30, date(aa_value)) + (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
	
long lul_cell
lul_cell = add_cell_double(iul_cellstorage, ld_val, ai_x1, ai_x2, ai_y1, ai_y2, li_xf, ai_units)

Return 1
end function

public function integer of_create_cell (unsignedinteger ai_x1, unsignedinteger ai_x2, unsignedinteger ai_y1, unsignedinteger ai_y2, date aa_value, n_xls_format anvo_format, integer ai_units);long li_xf = 0
If Not IsNull(anvo_format) And IsValid(anvo_format) Then
	li_xf = of_xf(-1, -1, anvo_format)
Else
	// not supported yet
	Return -1
End If

double ld_val = 0        
ld_val = daysafter(1899-12-30, aa_value)

long lul_cell
lul_cell = add_cell_double(iul_cellstorage, ld_val, ai_x1, ai_x2, ai_y1, ai_y2, li_xf, ai_units)

Return 1
end function

private subroutine of_initunitconvertor ();inv_unitsub = Create n_dwr_sub

long li_unit
For li_unit = 0 To 3
//	set_unit_x_coef(iul_cellstorage, li_unit, inv_unitsub.of_get_coef_x(0) / inv_unitsub.of_get_coef_x(li_unit))
//	set_unit_y_coef(iul_cellstorage, li_unit, inv_unitsub.of_get_coef_y(0) / inv_unitsub.of_get_coef_y(li_unit))
	set_unit_x_coef(iul_cellstorage, li_unit, inv_unitsub.of_get_coef_x(li_unit))
	set_unit_y_coef(iul_cellstorage, li_unit, inv_unitsub.of_get_coef_y(li_unit))
Next
end subroutine

public subroutine of_add_y_pagebreak (long al_y, integer ai_unit);add_h_break(iul_cellstorage, al_y, ai_unit)
end subroutine

public function long of_end_band (integer ai_units);return end_band(iul_cellstorage, ai_units)
end function

public subroutine of_setalign (double ad_x, double ad_y);set_align(iul_cellstorage, ad_x, ad_y)
end subroutine

public subroutine of_initdata ();of_update_y()
of_update_x()
end subroutine

on n_xls_worksheet.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_worksheet.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_sub = create n_xls_subroutines_v97

// String as_dll = "pb2xls.dll"
// String ls_dll
// 
// 
// LongPtr hModule
// 
// 
// ls_dll = of_GetEXEDir() +"\" + as_dll
// If of_IsWidePB() Then
// 	hModule = LoadLibraryW(ls_dll)
// Else
// 	hModule = LoadLibraryA(ls_dll)
// End If
// 
// If hModule = 0 Then
// 	Return
// End If
// iul_cellstorage = create_cell_storage()
// FreeLibrary(h)
// 
// of_InitUnitConvertor()
// //of_InitData()
// //MessageBox("iul_cellstorage", iul_cellstorage)
end event

event destructor;If iul_cellstorage <> 0 Then
	free_cell_storage(iul_cellstorage)
	iul_cellstorage = 0
End If
destroy invo_sub
end event

