forward
global type n_dwr_service_parm from nonvisualobject
end type
end forward

shared variables

end variables

global type n_dwr_service_parm from nonvisualobject
end type
global n_dwr_service_parm n_dwr_service_parm

type variables
public boolean ib_header = true
public boolean ib_foreground = true
public boolean ib_background = true
public boolean ib_detail = true
public boolean ib_summary = true
public boolean ib_footer = true
public boolean ib_group_header = true
public boolean ib_group_trailer = true
public boolean ib_keep_band_height = false
public boolean ib_enable_merge_cells = true
public boolean ib_show_progress = true
public boolean ib_hide_grid = false
public string is_version = '97' // 97, OOXML
public string is_sheet_name = 'Sheet1'
public boolean ib_group_pagebreak = false
public boolean ib_group_pageheader = true
public boolean ib_nested = true
public double id_min_width = 0.5 /* Excel units */
public double id_min_height = 4.0 /* Excel units */
public boolean ib_font_height_expression = true // Switch On/Off font height expression calculation
public boolean ib_trim_overlapped = true // Switch On/Off trimming of overlapped objects
public boolean ib_export_invisible = false // Switch On/Off export of invisible objects
public boolean ib_always_export_grid_header = true // If false, then objects in header will not be exported if they are positioned behind max detail column X-coordinate
public boolean ib_grid_columns_by_rowheight = true // If true, then for Grid DWs columns will have height = RowHeight()
public boolean ib_export_hidden_treeview_levels = true // If true, then for TreeView DWs collapsed levels will be exported too
public boolean ib_nested_workaround = false // If true, then for nested reports will modify source DW directly to obtain child reports. For Appeon only.
public boolean ib_check_suppressed = false // If true, then will consider Suppress Repeating Values setting
public boolean ib_draw_dw_grid_lines = true // If true, then will draw dash border for fields with invisible border when exporting Grid DW
public boolean ib_fix_date_base = false // If true, then will apply workaround for dates before 1900-03-01 which are calculated in Excel in a different way in comparison to OpenOffice and LibreOffice
public boolean ib_nonvisual_calc_height = false // If true, then will use nonvisual object to calculate height for autoheight columns. Doesn't work on Appeon
public boolean ib_ignore_autosizeheight = false // If true, then will ignore column height autosize

//internal use only
public long il_nested_instance_count = 0
public int ii_nested_extract_method = 1 // 0, 1

// <XLS header support>

// The text to be added in top of XLS
// If is_title_text = "" then the rest of header parameters are ignored 
// and the header is not generated. 
String is_title_text = ""
String is_title_sub1 = ""
String is_title_sub2 = ""
String is_title_sub3 = ""

//The font
String is_title_font = "맑은 고딕"
Long il_title_font_family = 0
Long il_title_font_charset = 0
//The font size
Long il_title_font_size = 10

//The colors. Use RGB()
ULong il_title_fg_color = 33554432
ULong il_title_bg_color = 1073741824 

//The alignment of the text inside the header cell. 
String is_title_text_align = "center" //("center"|"left"|"right")

//The alignment of the header cell inside the page. 
String is_title_align = "left" //("center"|"left"|"right")


//The font is bold/italic/underlined 
Boolean ib_title_font_bold = True
Boolean ib_title_font_underline = False
Boolean ib_title_font_italic = False

//The size of header cell (DW units).
Long il_title_height = 100
Long il_title_width = 2800

//The height of empty row separating the header from the rest of data
Long il_title_separator_height = 100

// Export lines (except inclined)
Boolean ib_lines = false
// Export rectangles
Boolean ib_rectangles = false

// Export pictures
Boolean ib_pictures = false

Boolean ib_background_color = false

Long il_max_progress_rows_per_change = 20

// </XLS header support>



end variables
forward prototypes

end prototypes

on n_dwr_service_parm.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_service_parm.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

