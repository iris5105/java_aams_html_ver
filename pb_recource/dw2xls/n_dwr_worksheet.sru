forward
global type n_dwr_worksheet from nonvisualobject
end type
end forward

global type n_dwr_worksheet from nonvisualobject
end type
global n_dwr_worksheet n_dwr_worksheet

type prototypes
//DLLEXPORT static int PBCALL ws_addCellDrawing(CWorksheet *ws, const TCHAR* path, int x1, int x2, int y1, int y2, int format, int unit)


Function long addCellDrawing(LongPtr ws, string path, long x1, long x2, long y1, long y2, long format, long unit) &
	Alias For "ws_addCellDrawing" Library "pb2xls.dll"

	
//DLLEXPORT static int PBCALL ws_addCellDouble(CWorksheet *ws, double value, int x1, int x2, int y1, int y2, int format, int unit)


Function long addCellDouble(LongPtr ws, double value, long x1, long x2, long y1, long y2, long format, long unit) &
	Alias For "ws_addCellDouble" Library "pb2xls.dll"


//DLLEXPORT static int PBCALL ws_addCellString(CWorksheet *ws, const TCHAR* value, int x1, int x2, int y1, int y2, int format, int unit) {


Function long addCellString(LongPtr ws, readonly string value, long x1, long x2, long y1, long y2, long format, long unit) &
	Alias For "ws_addCellString" Library "pb2xls.dll"


//DLLEXPORT static int PBCALL ws_addHBreak(CWorksheet *ws, int y, int unit) 	


Function long addHBreak(LongPtr ws, long y, long unit) &
	Alias For "ws_addHBreak" Library "pb2xls.dll"


//DLLEXPORT static int PBCALL ws_updateX(CWorksheet *ws, bool commit_only) {


Function long updateX(LongPtr ws, boolean commit_only) &
	Alias For "ws_updateX" Library "pb2xls.dll"


//DLLEXPORT static int PBCALL ws_updateY(CWorksheet *ws, bool merge_cells) {


Function long updateY(LongPtr ws, boolean merge_cells) &
	Alias For "ws_updateY" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_beginBand(CWorksheet *ws)


Subroutine beginBand(LongPtr ws) &
	Alias For "ws_beginBand" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_setPrintGridLines(CWorksheet *ws, bool value) {


Subroutine setPrintGridLines(LongPtr ws, boolean value) &
	Alias For "ws_setPrintGridLines" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_setScreenGridLines(CWorksheet *ws, bool value) {


Subroutine setScreenGridLines(LongPtr ws, boolean value) &
	Alias For "ws_setScreenGridLines" Library "pb2xls.dll"



//DLLEXPORT static int PBCALL ws_endBand(CWorksheet *ws, int units) {


Function long endBand(LongPtr ws, long units) &
	Alias For "ws_endBand" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_setAlign(CWorksheet *ws, double x, double y) {


Subroutine setAlign(LongPtr ws, double x, double y) &
	Alias For "ws_setAlign" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_setUnitXCoef(CWorksheet *ws, int unit, double coef) {


Subroutine setUnitXCoef(LongPtr ws, long unit, double coef) &
	Alias For "ws_setUnitXCoef" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_setUnitYCoef(CWorksheet *ws, int unit, double coef) {


Subroutine setUnitYCoef(LongPtr ws, long unit, double coef) &
	Alias For "ws_setUnitYCoef" Library "pb2xls.dll"


//DLLEXPORT static int PBCALL ws_getCellCount(CWorksheet *ws)


Function long getCellCount(LongPtr ws) &
	Alias For "ws_getCellCount" Library "pb2xls.dll"


//DLLEXPORT static int PBCALL ws_writeCells(CWorksheet *ws, int begin, int end, int millisecs)


Function long writeCells(LongPtr ws, long al_begin, long al_end, long millisecs, boolean merge) &
	Alias For "ws_writeCells" Library "pb2xls.dll"


//DLLEXPORT static void ws_setColWidth(CWorksheet *ws, int col, double width){


Subroutine setColWidth(LongPtr ws, long col, double width) &
	Alias For "ws_setColWidth" Library "pb2xls.dll"

	
//DLLEXPORT static void ws_setRowHeight(CWorksheet *ws, int row, double height) {


Subroutine setRowHeight(LongPtr ws, long row, double height) &
	Alias For "ws_setRowHeight" Library "pb2xls.dll"

	
//DLLEXPORT static void ws_setOrientation(CWorksheet *ws, Orientation orientation) {


Subroutine setOrientation(LongPtr ws, long orientation) &
	Alias For "ws_setOrientation" Library "pb2xls.dll"


//DLLEXPORT static void ws_setHeader(CWorksheet *ws, const TCHAR* value, double height) {


Subroutine setHeader(LongPtr ws, readonly string value, double height) &
	Alias For "ws_setHeader" Library "pb2xls.dll"


//DLLEXPORT static void ws_setFooter(CWorksheet *ws, const TCHAR* value, double height) {


Subroutine setFooter(LongPtr ws, readonly string value, double height) &
	Alias For "ws_setFooter" Library "pb2xls.dll"


//DLLEXPORT static void ws_setMarginLeft(CWorksheet *ws, double value)  { 


Subroutine setMarginLeft(LongPtr ws, double value) &
	Alias For "ws_setMarginLeft" Library "pb2xls.dll"


//DLLEXPORT static void ws_setMarginRight(CWorksheet *ws, double value)  { 


Subroutine setMarginRight(LongPtr ws, double value) &
	Alias For "ws_setMarginRight" Library "pb2xls.dll"


//DLLEXPORT static void ws_setMarginTop(CWorksheet *ws, double value)  { 


Subroutine setMarginTop(LongPtr ws, double value) &
	Alias For "ws_setMarginTop" Library "pb2xls.dll"


//DLLEXPORT static void ws_setMarginBottom(CWorksheet *ws, double value)  { 


Subroutine setMarginBottom(LongPtr ws, double value) &
	Alias For "ws_setMarginBottom" Library "pb2xls.dll"


//DLLEXPORT void PBCALL ws_fillBandBackground(CWorksheet *ws, CBandBackground *bb, int format, int unit) {


Subroutine fillBandBackground(LongPtr ws, LongPtr bb, long format, long unit) &
	Alias For "ws_fillBandBackground" Library "pb2xls.dll"

	
//DLLEXPORT static void PBCALL ws_addXPoint(CWorksheet *ws, int x, int unit)


Subroutine addXPoint(LongPtr ws, long x, long unit) &
	Alias For "ws_addXPoint" Library "pb2xls.dll"


//DLLEXPORT static void PBCALL ws_addXInterval(CWorksheet *ws, int x1, int x2, int unit) {


Subroutine addXInterval(LongPtr ws, long x1, long x2, long unit) &
	Alias For "ws_addXInterval" Library "pb2xls.dll"


// The following legacy declarations are subject to 
// future changes/removal. 

//	DLLEXPORT static bool PBCALL ws_hasImagesSupport(CWorksheet *ws) { 


Function boolean hasImagesSupport(LongPtr ws) &
	Alias For "ws_hasImagesSupport" Library "pb2xls.dll"


//DLLEXPORT void PBCALL ws_excel97_appendData(void *buf, size_t len) {


Subroutine excel97_appendData(LongPtr ws, readonly blob buf, LongPtr len) &
	Alias For "ws_excel97_appendData" Library "pb2xls.dll"


//DLLEXPORT void PBCALL ws_excel97_appendHeaderData(void *buf, size_t len) {


Subroutine excel97_appendHeaderData(LongPtr ws, readonly blob buf, LongPtr len) &
	Alias For "ws_excel97_appendHeaderData" Library "pb2xls.dll"


//DLLEXPORT uint PBCALL ws_excel97_getRowHeight(int row);


Function ulong excel97_getRowHeight(LongPtr ws, long al_row) &
	Alias For "ws_excel97_getRowHeight" Library "pb2xls.dll"


//DLLEXPORT uint PBCALL ws_excel97_getColWidth(int col);


Function ulong excel97_getColWidth(LongPtr ws, long al_col) &
	Alias For "ws_excel97_getColWidth" Library "pb2xls.dll"


end prototypes

type variables
public:
	LongPtr handle = 0
	n_xls_subroutines_v97 invo_sub

	constant long ORN_LANDSCAPE = 0
	constant long ORN_PORTRAIT = 1

	boolean ib_fixDateBase = false
end variables
forward prototypes
public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, double aa_value, long al_format, integer ai_units)
public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, string aa_value, long al_format, integer ai_units)
public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, time aa_value, long al_format, integer ai_units)
public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, datetime aa_value, long al_format, integer ai_units)
public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, date aa_value, long al_format, integer ai_units)
public function integer of_insert_bitmap (readonly long ai_row, readonly long ai_col, readonly string as_bitmap_filename)
public function integer of_insert_bitmap (readonly long ai_row, readonly long ai_col, readonly string as_bitmap_filename, readonly long ai_x, readonly long ai_y)
public function integer of_insert_bitmap (readonly long ai_row, readonly long ai_col, readonly string as_bitmap_filename, readonly long ai_x, readonly long ai_y, readonly double ad_scale_width, readonly double ad_scale_height)
public function integer of_position_image (long ai_col_start, long ai_row_start, long ai_x1, long ai_y1, long ai_width, long ai_height)
public function unsignedlong of_size_row (unsignedlong ai_row)
public function unsignedlong of_size_col (unsignedlong ai_col)
protected function integer of_store_obj_picture (readonly long ai_col_start, readonly long ai_x1, readonly long ai_row_start, readonly long ai_y1, readonly long ai_col_end, readonly long ai_x2, readonly long ai_row_end, readonly long ai_y2)
public subroutine of_initunitconvertor ()
protected function integer of_process_bitmap (readonly string as_bitmap_filename, ref long al_width, ref long al_height, ref long al_size, ref blob ab_data)
public function integer of_set_header (readonly string as_text, double ad_height)
public function integer of_set_footer (readonly string as_text, double ad_height)
public function integer of_set_margin_bottom (double ad_value)
public function integer of_set_margin_left (double ad_value)
public function integer of_set_margin_right (double ad_value)
public function integer of_set_margin_top (double ad_value)
public function integer of_set_orientation (long al_orientation)
public function integer of_set_landscape ()
public function integer of_set_portrait ()
public function integer of_create_cell_drawing (long ai_x1, long ai_x2, long ai_y1, long ai_y2, string as_imagepath, long al_format, integer ai_units)
end prototypes

public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, double aa_value, long al_format, integer ai_units)
long lul_cell
lul_cell = addCellDouble(handle, aa_value, ai_x1, ai_x2, ai_y1, ai_y2, al_format, ai_units)
Return 1
end function

public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, string aa_value, long al_format, integer ai_units)
long lul_cell
lul_cell = addCellString(handle, aa_value, ai_x1, ai_x2, ai_y1, ai_y2, al_format, ai_units)
Return 1
end function

public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, time aa_value, long al_format, integer ai_units);double ld_val
int li_hour, li_minute, li_second

li_hour   = hour(aa_value)
li_minute = minute(aa_value)
li_second = second(aa_value)

ld_val = (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)
// ***WORKAROUD*** for appeon
ld_val = ld_val + 0.0000000001
// ***END***

long lul_cell
lul_cell = addCellDouble(handle, ld_val, ai_x1, ai_x2, ai_y1, ai_y2, al_format, ai_units)

Return 1
end function

public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, datetime aa_value, long al_format, integer ai_units);double ld_val, ld_add = 0
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

// workaround for Excel
if ib_fixDateBase and date(aa_value) <= 1900-02-28 then ld_add = -1
ld_val = daysafter(1899-12-30, date(aa_value)) + ld_add + (li_second + li_minute * 60 + li_hour * 3600) / (24 * 3600)

// ***WORKAROUD*** for appeon
ld_val = ld_val + 0.0000000001
// ***END***
	
long lul_cell
lul_cell = addCellDouble(handle, ld_val, ai_x1, ai_x2, ai_y1, ai_y2, al_format, ai_units)

Return 1
end function

public function integer of_create_cell (long ai_x1, long ai_x2, long ai_y1, long ai_y2, date aa_value, long al_format, integer ai_units);double ld_val = 0, ld_add = 0      

// workaround for Excel
if ib_fixDateBase and aa_value <= 1900-02-28 then ld_add = -1
ld_val = daysafter(1899-12-30, aa_value) + ld_add	

// ***WORKAROUD*** for appeon
ld_val = ld_val + 0.0000000001
// ***END***

long lul_cell
lul_cell = addCellDouble(handle, ld_val, ai_x1, ai_x2, ai_y1, ai_y2, al_format, ai_units)

Return 1
end function

public function integer of_insert_bitmap (readonly long ai_row, readonly long ai_col, readonly string as_bitmap_filename);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_insert_bitmap
//
//	Access: 			public
//
//	Arguments:	   ai_row              uint    The unsigned integer whose value is the row
//                                            where top left corner of the image will be placed    
//                ai_col              uint    The unsigned integer whose value is the column 
//                                            where top left corner of the image will be placed 
//                as_bitmap_filename  string  A string whose value is the name of the 
//                                            bitmap file you want to insert. 
//                                            If filename is not on the operating system's search
//                                            path, you must enter the fully qualified name
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  This method can be used to insert a bitmap into a worksheet.
//               The bitmap must be a 24 bit, true color bitmap without optimization
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_insert_bitmap(ai_row, ai_col, as_bitmap_filename, 0, 0, 1, 1)
end function

public function integer of_insert_bitmap (readonly long ai_row, readonly long ai_col, readonly string as_bitmap_filename, readonly long ai_x, readonly long ai_y);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_insert_bitmap
//
//	Access: 			public
//
//	Arguments:	   ai_row              uint    The unsigned integer whose value is the row
//                                            where top left corner of the image will be placed    
//                ai_col              uint    The unsigned integer whose value is the column 
//                                            where top left corner of the image will be placed 
//                as_bitmap_filename  string  A string whose value is the name of the 
//                                            bitmap file you want to insert. 
//                                            If filename is not on the operating system's search
//                                            path, you must enter the fully qualified name
//                ai_x                uint    The unsigned integer whose value is the horizontal
//                                            offset from the top left hand corner of the the cell
//                                            specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//                ai_y                uint    The unsigned integer whose value is the vertical
//                                            offset from the top left hand corner of the the
//                                            cell specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  This method can be used to insert a bitmap into a worksheet.
//               The bitmap must be a 24 bit, true color bitmap without optimization
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

return of_insert_bitmap(ai_row, ai_col, as_bitmap_filename, ai_x, ai_y, 1, 1)
end function

public function integer of_insert_bitmap (readonly long ai_row, readonly long ai_col, readonly string as_bitmap_filename, readonly long ai_x, readonly long ai_y, readonly double ad_scale_width, readonly double ad_scale_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_insert_bitmap
//
//	Access: 			public
//
//	Arguments:	   ai_row              uint    The unsigned integer whose value is the row
//                                            where top left corner of the image will be placed    
//                ai_col              uint    The unsigned integer whose value is the column 
//                                            where top left corner of the image will be placed 
//                as_bitmap_filename  string  A string whose value is the name of the 
//                                            bitmap file you want to insert. 
//                                            If filename is not on the operating system's search
//                                            path, you must enter the fully qualified name
//                ai_x                uint    The unsigned integer whose value is the horizontal
//                                            offset from the top left hand corner of the the cell
//                                            specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//                ai_y                uint    The unsigned integer whose value is the vertical
//                                            offset from the top left hand corner of the the
//                                            cell specified by ai_row and ai_col. The offset value
//                                            is in pixels.
//                ad_scale_width      double  The double whose value is the horizontal scale factor.
//                ad_scale_height     double  The double whose value is the vertical scale factor. 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//	Description:  This method can be used to insert a bitmap into a worksheet.
//               The bitmap must be a 24 bit, true color bitmap without optimization
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////
integer li_ret = 1
long li_width, li_height, li_size
blob lb_data
blob lb_header

LongLong len

if hasImagesSupport(handle) then
	//Only in Excel97 format
	li_ret = of_process_bitmap(as_bitmap_filename, li_width, li_height, li_size, lb_data)
		
	if li_ret = 1 then
		li_width = li_width * ad_scale_width
		li_height = li_height * ad_scale_height
		li_ret = of_position_image(ai_col, ai_row, ai_x, ai_y, li_width , li_height)
	end if
	if li_ret = 1 then
		lb_header = invo_sub.of_pack('v', 127)           /*record 0x007F*/ +&
						invo_sub.of_pack('v', 8 + li_size)   /*length*/ +&
						invo_sub.of_pack('v', 9)             /*cf*/ +&
						invo_sub.of_pack('v', 1)             /*env*/ +&
						invo_sub.of_pack('V', li_size)       /*size*/ 
		len = Len(lb_header) + Len(lb_data)
		excel97_appendData(handle, lb_header + lb_data, len)				
	end if
else
	li_ret = -1
	MessageBox("Error", "Images are not supported yet", StopSign!)
end if
return li_ret
end function

public function integer of_position_image (long ai_col_start, long ai_row_start, long ai_x1, long ai_y1, long ai_width, long ai_height);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_position_image
//
//	Access: 			public
//
//	Arguments:	   ai_col_start   uint
//                ai_row_start   uint
//                ai_x1          uint 
//                ai_y1          uint
//                ai_width       uint
//                ai_height      uint 
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret = 1
uint li_col_end
uint li_row_end
uint li_x2, li_y2

li_col_end = ai_col_start
li_row_end = ai_row_start

if ai_x1 >= of_size_col(ai_col_start) then ai_x1 = 0
if ai_y1 >= of_size_row(ai_row_start) then ai_y1 = 0

ai_width = ai_width + ai_x1 - 1
ai_height = ai_height + ai_y1 - 1

//Subtract the underlying cell widths to find the end cell of the image
do while ai_width >= of_size_col(li_col_end)
   ai_width -= of_size_col(li_col_end)
   li_col_end ++
loop

//Subtract the underlying cell heights to find the end cell of the image
do while ai_height >= of_size_row(li_row_end)
   ai_height -= of_size_row(li_row_end)
   li_row_end ++
loop

//Bitmap isn't allowed to start or finish in a hidden cell, i.e. a cell
//with zero eight or width.

if of_size_col(ai_col_start) = 0 then return -1
if of_size_col(li_col_end) = 0 then return -1
if of_size_row(ai_row_start) = 0 then return -1
if of_size_row(li_row_end) = 0 then return -1

//Convert the pixel values to the percentage value expected by Excel
ai_x1 = (ai_x1 / of_size_col(ai_col_start)) * 1024
ai_y1 = (ai_y1 / of_size_row(ai_row_start)) *  256;
li_x2 = (ai_width / of_size_col(li_col_end)) * 1024
li_y2 = (ai_height / of_size_row(li_row_end)) *  256;

li_ret = of_store_obj_picture(ai_col_start, ai_x1, ai_row_start, ai_y1, li_col_end, li_x2, li_row_end, li_y2)

return li_ret
end function

public function unsignedlong of_size_row (unsignedlong ai_row);return excel97_getRowHeight(handle, ai_row)

end function

public function unsignedlong of_size_col (unsignedlong ai_col);return excel97_getColWidth(handle, ai_col)

end function

protected function integer of_store_obj_picture (readonly long ai_col_start, readonly long ai_x1, readonly long ai_row_start, readonly long ai_y1, readonly long ai_col_end, readonly long ai_x2, readonly long ai_row_end, readonly long ai_y2);//////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_store_obj_picture
//
//	Access: 			protected
//
//	Arguments:	   ai_col_start  uint
//                ai_x1         uint 
//                ai_row_start  uint
//                ai_y1         uint
//                ai_col_end    uint
//                ai_x2         uint
//                ai_row_end    uint
//                ai_y2         uint
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////

integer li_ret = 1
blob lb_header

LongLong len

  lb_header = invo_sub.of_pack('v', 93)           /*record 0x005D*/ +&
              invo_sub.of_pack('v', 60)           /*length 0x003С*/ +&
              invo_sub.of_pack('V', 1)            /*Count of objects in file (set to 1)*/ +&
              invo_sub.of_pack('v', 8)            /*Object type. 8 = Picture*/ +&
              invo_sub.of_pack('v', 1)            /*Object ID*/ +&
              invo_sub.of_pack('v', 1556)         /*Option flags 0x0614 */ +&
              invo_sub.of_pack('v', ai_col_start) /*Col containing upper left corner of object */ +&
              invo_sub.of_pack('v', ai_x1)        /*Distance from left side of cell*/ +&
              invo_sub.of_pack('v', ai_row_start) /*Row containing top left corner of object*/ +&
              invo_sub.of_pack('v', ai_y1)        /*Distance from top of cell*/ +&
              invo_sub.of_pack('v', ai_col_end)   /*Col containing lower right corner of object*/ +&
              invo_sub.of_pack('v', ai_x2)        /*Distance from right of cell*/ +&
              invo_sub.of_pack('v', ai_row_end)   /*Row containing bottom right corner of object*/ +&
              invo_sub.of_pack('v', ai_y2)        /*Distance bottom top of cell*/ +&
              invo_sub.of_pack('v', 0)            /*Length of FMLA structure*/ +&
              invo_sub.of_pack('V', 0)            /*Reserved*/ +&
              invo_sub.of_pack('v', 0)            /*Reserved*/ +&
              invo_sub.of_pack('C', 9)            /*Background colour*/ +&
              invo_sub.of_pack('C', 9)            /*Foreground colour*/ +&
              invo_sub.of_pack('C', 0)            /*Fill pattern*/ +&
              invo_sub.of_pack('C', 0)            /*Automatic fill*/ +&
              invo_sub.of_pack('C', 8)            /*Line colour*/ +&
              invo_sub.of_pack('C', 255)          /*Line style*/ +&
              invo_sub.of_pack('C', 1)            /*Line weight*/ +&
              invo_sub.of_pack('C', 0)            /*Automatic border*/ +&
              invo_sub.of_pack('v', 0)            /*Frame style*/ +&
              invo_sub.of_pack('V', 9)            /*Image format, 9 = bitmap*/ +&
              invo_sub.of_pack('v', 0)            /*Reserved*/ +&
              invo_sub.of_pack('v', 0)            /*Length of FMLA structure*/ +&
              invo_sub.of_pack('v', 0)            /*Reserved*/ +&
              invo_sub.of_pack('v', 1)            /*Option flags*/ +&
              invo_sub.of_pack('V', 0)            /*Reserved*/ 

len = Len(lb_header)
excel97_appendData(handle, lb_header, len)	

return li_ret
end function

public subroutine of_initunitconvertor ();n_dwr_sub lsub 
lsub = Create n_dwr_sub

long li_unit
For li_unit = 0 To 3
//	set_unit_x_coef(iul_cellstorage, li_unit, inv_unitsub.of_get_coef_x(0) / inv_unitsub.of_get_coef_x(li_unit))
//	set_unit_y_coef(iul_cellstorage, li_unit, inv_unitsub.of_get_coef_y(0) / inv_unitsub.of_get_coef_y(li_unit))
	setUnitXCoef(handle, li_unit, lsub.of_get_coef_x(li_unit))
	setUnitYCoef(handle, li_unit, lsub.of_get_coef_y(li_unit))
Next
end subroutine

protected function integer of_process_bitmap (readonly string as_bitmap_filename, ref long al_width, ref long al_height, ref long al_size, ref blob ab_data);//TODO: move this code to DLL

////////////////////////////////////////////////////////////////////////////
//
//	Function: 		of_process_bitmap
//
//	Access: 			protected
//
//	Arguments:	   as_bitmap_filename string
//                al_width           long
//                al_height          long
//                al_size            long
//                ab_data            blob
//	
//	Returns:  		Integer
//						 1 - if it succeeds
//						-1 - if an error occurs
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2003 Desta Ltd. All rights reserved.
// Author: Nikulitsa A.V.
//
//////////////////////////////////////////////////////////////////////////////
integer li_ret = 1
integer li_file
blob lb_data_item
blob lb_data
ulong ll_size
uint li_planes, li_bitcount
ulong ll_compression
blob lb_header

//read bitmap into blob
li_file = FileOpen(as_bitmap_filename, StreamMode!, Read!, LockWrite!)
if li_file <> -1 then
	setnull(lb_data)
	
	do while FileRead(li_file, lb_data_item) > 0 
		if isNull(lb_data) then 
			lb_data = lb_data_item
		else
			lb_data +=  lb_data_item
		end if
	loop

   if isNull(lb_data) then li_ret = -1

	FileClose(li_file)
else
	li_ret = -1
	MessageBox('Error', 'Couldn~'t open ' + as_bitmap_filename, StopSign!)
end if


if li_ret = 1 then
	//check data size
   if len(lb_data) <= 54 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ' doesn~'t contain enough data', StopSign!)
	end if
end if

if li_ret = 1 then
	//check bitmap header
	if string(blobmid(lb_data, 1, 2)) <> 'BM' then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ' doesn~'t appear to to be a valid bitmap image', StopSign!)
	end if
end if

if li_ret = 1 then
	//read bitmap size
	ll_size = long(blobmid(lb_data, 3, 4)) 
	ll_size -= 54 - 12  //subtract size of bitmap header and add size of biff header
	
   
	//Read bitmap width and height
	al_width = long(blobmid(lb_data, 19, 4))
	al_height = long(blobmid(lb_data, 23, 4))
	
	if al_width > 65535 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': largest image width supported is 65535', StopSign!)
   end if
end if

if li_ret = 1 then
	if al_height > 65535 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': largest image height supported is 65535', StopSign!)
   end if
end if

if li_ret = 1 then
	li_planes = integer(blobmid(lb_data, 27, 2))
	li_bitcount = integer(blobmid(lb_data, 29, 2))

   if li_bitcount <> 24 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ' isn~'t a 24bit true color bitmap', StopSign!)
   end if
end if

if li_ret = 1 then
   if li_planes <> 1 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': only 1 plane supported in bitmap image', StopSign!)
   end if
end if

if li_ret = 1 then
	ll_compression = long(blobmid(lb_data, 31, 4))
   if ll_compression <> 0 then
		li_ret = -1
		MessageBox('Error', as_bitmap_filename + ': compression not supported in bitmap image', StopSign!)
   end if
end if

if li_ret = 1 then
	lb_header = invo_sub.of_pack('V', 12)  /*0x000C*/ +&
	            invo_sub.of_pack('v', al_width) +&
	            invo_sub.of_pack('v', al_height) +&
	            invo_sub.of_pack('v', 1)  /*0x01*/ +&    
	            invo_sub.of_pack('v', 24) /*0x18*/ 
   ab_data = lb_header + blobmid(lb_data, 55, len(lb_data) - 55 + 1)
	al_size = ll_size
end if

return li_ret

end function

public function integer of_set_header (readonly string as_text, double ad_height);int li_ret = 1

if len(as_text) >= 255 then
	MessageBox('Error', 'Header string must be less than 255 characters', StopSign!)
   li_ret = -1
end if  

if li_ret = 1 then
	setHeader(handle, as_text, ad_height)
end if

return li_ret
end function

public function integer of_set_footer (readonly string as_text, double ad_height);int li_ret = 1

if len(as_text) >= 255 then
	MessageBox('Error', 'Footer string must be less than 255 characters', StopSign!)
   li_ret = -1
end if  

if li_ret = 1 then
	setFooter(handle, as_text, ad_height)
end if

return li_ret
end function

public function integer of_set_margin_bottom (double ad_value);int li_ret = 1

setMarginBottom(handle, ad_value)

return li_ret
end function

public function integer of_set_margin_left (double ad_value);int li_ret = 1

setMarginLeft(handle, ad_value)

return li_ret
end function

public function integer of_set_margin_right (double ad_value);int li_ret = 1

setMarginRight(handle, ad_value)

return li_ret
end function

public function integer of_set_margin_top (double ad_value);int li_ret = 1

setMarginTop(handle, ad_value)

return li_ret
end function

public function integer of_set_orientation (long al_orientation);setOrientation(handle, al_orientation)
Return 1
end function

public function integer of_set_landscape ();return of_set_orientation(ORN_LANDSCAPE)
end function

public function integer of_set_portrait ();return of_set_orientation(ORN_PORTRAIT)
end function

public function integer of_create_cell_drawing (long ai_x1, long ai_x2, long ai_y1, long ai_y2, string as_imagepath, long al_format, integer ai_units);long lul_cell
lul_cell = addCellDrawing(handle, as_imagePath, ai_x1, ai_x2, ai_y1, ai_y2, al_format, ai_units)

Return 1
end function

on n_dwr_worksheet.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_worksheet.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;/*
We don't call destroy(handle) here.
Workbook will do that on its destruction.
*/
end event

event constructor;invo_sub = create n_xls_subroutines_v97


end event

