forward
global type n_dwr_band from nonvisualobject
end type
end forward

shared variables

end variables

global type n_dwr_band from nonvisualobject
end type
global n_dwr_band n_dwr_band

type prototypes
protected:

//	DLLEXPORT int PBCALL addObject(CELL_COORD &obj);


Function Long addOverlappedObject(LongPtr inst, ref ST_RECT c) library "pb2xls"  Alias For "oo_addObject"


//	DLLEXPORT static  COverlappedObjects* PBCALL g_createOverlappedObjects() {


Function LongLong createOverlappedStorage() library "pb2xls" Alias For "g_createOverlappedObjects"


//	DLLEXPORT static  void PBCALL oo_destroy(COverlappedObjects* inst) {


Subroutine destroyOverlappedStorage(LongPtr inst) library "pb2xls" Alias For "oo_destroy"


//DLLEXPORT static  CBandBackground* PBCALL g_createBandBackground() {


Function LongLong createBandBackground() library "pb2xls" Alias For "g_createBandBackground"


//DLLEXPORT static  void PBCALL bb_destroy(CBandBackground* inst) {


Subroutine destroyBandBackground(LongPtr inst) library "pb2xls" Alias For "bb_destroy"


//DLLEXPORT void PBCALL bb_init(CELL_COORD &initMin, CELL_COORD &initMax) {


Subroutine initBandBackground(LongPtr inst, ref ST_RECT initMin, ref ST_RECT initMax) library "pb2xls"  Alias For "bb_init"


//DLLEXPORT void PBCALL bb_clear() {


Subroutine clearBandBackground(LongPtr inst) library "pb2xls"  Alias For "bb_clear"


//DLLEXPORT void PBCALL bb_addObject(CBandBackground *bb, CWorksheet *ws, int x1, int x2, int y1, int y2) {


Subroutine addObjectToBand(LongPtr bandInst, LongPtr wsInst, long x1, long x2, long y1, long y2) library "pb2xls" Alias For "bb_addObject"


end prototypes

type variables
public boolean ib_variable_band_height = FALSE
public boolean ib_autosize_band_height = FALSE
public long il_row_cnt
public string is_band_name
public INT ii_band_type
public INT ii_group_level
public boolean ib_newpage = FALSE
public long il_ysplit_ind_from
public long il_ysplit_ind_to
public boolean ib_enabled = TRUE

//public datawindow idw_dw
private powerobject ipo_requestor
private object ipo_requestortype
private DataWindow idw_requestor
private ads_jTier ids_requestor
private DataWindowChild idwc_requestor

public INT ii_fields_count = 0

public long il_groupchangerow = 1
public long il_dw_row_count
private INT ii_band_height
public boolean ib_yield_enable = FALSE
public boolean ib_cancel = FALSE
public double id_x_coef
public double id_y_coef
public double id_conv

public n_dwr_grid invo_hgrid
public n_dwr_grid invo_parent_hgrid
public long il_band_y = 0

public n_dwr_grid invo_vgrid

public n_dwr_field invo_fields[]

//public n_xls_workbook invo_writer

//public n_xls_worksheet invo_cur_sheet;

public n_dwr_workbook inv_book

public n_dwr_worksheet inv_sheet

public n_dwr_service_parm invo_parm
public n_dwr_nested_service_parm invo_nested_parm

public n_dwr_colors invo_colors
private n_cst_hash_long invo_row_in_detail
public integer ii_rows_per_detail = 1
public integer ii_dw_processing
private boolean ib_has_reports = FALSE
public long il_base_x = 0
public long il_base_y = 0
public long il_subband_y = 0
public boolean ib_nested = FALSE
private string is_skip_key = "dw2xls=skip"
constant string BAND_DETAIL = "1"
constant string BAND_HEADER = "2"
constant string BAND_FOOTER = "3"
constant string BAND_SUMMARY = "4"
constant string BAND_GROUPHEADER = "5"
constant string BAND_GROUPTRAILER = "6"
private string is_band_id = BAND_DETAIL

public string is_sparseList[]
private n_dwr_field invo_sparse_fields[]

public long il_x1 = -1
public long il_x2 = -1
//public long il_y1 = 0
//public long il_y2 = 0
public boolean ib_has_autosize_height_objects = FALSE
public n_dwr_progress ipo_progress
public integer ii_units = 0



private LongPtr iul_oostorage = 0


private boolean ib_trim_overlapped = TRUE
protected boolean ib_has_custom_renderers = FALSE
protected boolean ib_has_rectangles = FALSE



protected LongPtr iul_bg = 0


protected boolean ib_background_color = FALSE
public boolean ib_bg_color_expr = FALSE
public string is_bg_color_expr = ''

protected boolean ib_custom_format = FALSE

protected n_dwr_format inv_bg_format
protected long il_bg_format_ix
protected long il_bg_x1 = 0
protected long il_bg_x2 = 0
protected long il_bg_y1 = 0
protected long il_bg_y2 = 0

//dwo type
public constant INT DT_COLUMN = 1
public constant INT DT_COMPUTE = 2
public constant INT DT_TEXT = 3
public constant INT DT_REPORT = 4

protected boolean ib_grid = FALSE
protected INT ii_processing = 0
public long il_grid_detail_width = 0

protected n_dwr_rect inv_rect[]
protected n_dwr_field inv_field_const
end variables

forward prototypes
public function integer of_dynamic_horisontal_layout (long al_row)
private function integer of_set_row_height (long al_writer_row)
public subroutine of_find_row_in_detail ()
public function string of_describe (readonly string as_expr)
public function integer of_register_dynamic (powerobject apo_requestor)
public function integer of_add_field (string as_name)
private function integer of_sort_fields ()
public function integer of_add_field (string as_name, long al_instance_id, ref n_dwr_field anvo_field)
public function integer of_process_row (long al_row, long al_base_y, n_dwr_progress apo_progress)
public function integer of_check_process_row (long al_row, long al_base_y, boolean ab_newpage, n_dwr_progress apo_progress)
public subroutine of_cancel ()
public function integer of_add_line (string as_name, ref n_dwr_field anvo_field)
public function integer of_add_rect (string as_name, ref n_dwr_field anvo_field)
public subroutine of_init_bg_fillers ()
public function long of_countnested ()
public function long of_getformat (long al_row)
public subroutine of_set_bg_x (long al_x1, long al_x2)
public function integer of_check_property (string as_property_name, ref boolean ab_is_expression, ref string as_expression, ref string as_value)
public function long of_descr_bg_color ()
public function integer of_eval_bg_color (long al_row)
public function integer of_init (string as_band_name, integer ai_band_type, integer ai_group_level, boolean ab_newpage, n_dwr_grid anvo_vgrid)
public function integer of_register (powerobject apo_requestor, n_dwr_workbook anv_book, n_dwr_worksheet anv_sheet, n_dwr_service_parm anvo_parm, n_dwr_colors anvo_colors, integer ai_rows_per_detail, long al_base_x, long al_base_y, long al_subband_y)
public subroutine of_copyfrom (n_dwr_band anv_band)
public subroutine of_initbgstorage ()
public subroutine of_getbgrect (ref st_rect ast_rect, long al_row)
public subroutine of_dispose ()
public function integer of_do_static_x_markup (n_dwr_worksheet anv_sheet)
public function boolean of_istreelevelvisible (long al_row, long al_level)
public function integer of_register_dynamic2 (powerobject apo_requestor, long al_rowcount)
public function boolean of_isrowsuppressed (long al_row)
public function integer of_add_picture (string as_name, ref n_dwr_field anvo_field)
end prototypes

public function integer of_dynamic_horisontal_layout (long al_row);integer li_ret = 1
integer li_i
//invo_hgrid = create n_dwr_grid
//invo_hgrid.ii_round_ratio = invo_hgrid.ii_round_init_ratio * id_conv

if ib_variable_band_height and ii_band_type = 3 then
   ii_band_height = integer(of_describe("evaluate('rowheight()'," + string(al_row) + ')'))
else
   ii_band_height = integer(of_describe('datawindow.' + is_band_name + '.height'))
end if

if ii_band_height > 0 then
   if invo_parm.ib_keep_band_height then
      il_ysplit_ind_from = invo_hgrid.of_add_split(il_base_y + 0)
      il_ysplit_ind_to = invo_hgrid.of_add_split(il_base_y + ii_band_height)

	/*bug fix 15.04.2004*/	
	elseif (ii_dw_processing = 1) and (ib_variable_band_height) then  
		il_ysplit_ind_to = invo_hgrid.of_add_split(il_base_y + ii_band_height)
	/*bug fixed 15.04.2004*/	
   end if
	
   if ii_fields_count > 0 then
       for li_i = 1 to ii_fields_count
			 if invo_fields[li_i].ii_dwo_type = inv_field_const.DT_REPORT then
				 continue
			 //bug fix 24.11.2003
		    elseif invo_fields[li_i].of_get_y1() <= (il_base_y + ii_band_height + invo_hgrid.ii_round_ratio) then 
             invo_fields[li_i].il_ysplit_ind_from = invo_hgrid.of_add_split( invo_fields[li_i].of_get_y1(al_row) )
  			    //bug fix 17.03.2004
				 /*if (invo_fields[li_i].of_get_y2(al_row) >= il_base_y + ii_band_height - 10) and (integer(idw_dw.describe ( 'Datawindow.Processing' )) = 1) then*/
				 if (ii_dw_processing = 1) and (ib_variable_band_height) and ii_band_type = 3 then  //15.04.2004
	             invo_fields[li_i].il_ysplit_ind_to = il_ysplit_ind_to
  		       else
	             invo_fields[li_i].il_ysplit_ind_to = invo_hgrid.of_add_split( invo_fields[li_i].of_get_y2(al_row) )
				 end if
  			    //bug fixed 17.03.2004
          end if
			 //bug fixed 24.11.2003
       next
   end if
//  il_row_cnt = invo_hgrid.of_get_split_count() - 1
//   if il_row_cnt < 0 then il_row_cnt = 0
end if

return li_ret

end function

private function integer of_set_row_height (long al_writer_row);//TODO remove unused

long  ll_i
integer li_ret = 1
//for ll_i = 1 to il_row_cnt
//   invo_cur_sheet.of_set_row_height(al_writer_row + ll_i - 1, &
//   invo_hgrid.of_get_col_width(ll_i) / id_y_coef )
//next

return li_ret



end function

public subroutine of_find_row_in_detail ();string ls_syntax
long ll_pos, ll_pos_end
long ll_start_pos = 1
string ls_column
string ls_name, ls_row_in_detail
integer li_row_in_detail
ls_syntax = of_describe("Datawindow.Syntax")
invo_row_in_detail = create n_cst_hash_long

do while ll_start_pos >= 0
  ll_pos = pos(ls_syntax, '~r~ncolumn(', ll_start_pos)
  if ll_pos > 0 then
     ll_pos_end = pos(ls_syntax, '~r~n', ll_pos + 7)
     if ll_pos_end > 0 then 
        ll_start_pos = ll_pos_end - 2 
     else 
        ll_start_pos = -1
        ll_pos_end = Len(ls_syntax) + 1
     end if
     ls_column = mid(ls_syntax, ll_pos, ll_pos_end - ll_pos)
     //find name
     ll_pos = pos(ls_column, 'name=')
     if ll_pos > 0 then
        ll_pos_end = pos(ls_column, ' ', ll_pos + 5)
        if ll_pos_end > 0 then
           ls_name = mid(ls_column, ll_pos + 5, ll_pos_end - ll_pos - 5)
           ll_pos = pos(ls_column, 'row_in_detail=')
           if ll_pos > 0 then
              ll_pos_end = pos(ls_column, ' ', ll_pos + 14)
              if ll_pos_end > 0 then
                 ls_row_in_detail = mid(ls_column, ll_pos + 14, ll_pos_end - ll_pos - 14)
                 li_row_in_detail = integer(ls_row_in_detail) 
                 invo_row_in_detail.of_set_value(ls_name, li_row_in_detail)
            end if
          end if
        end if
     end if
  else
     ll_start_pos = -1
  end if 
loop

end subroutine

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

Long li_i
For li_i = 1 To ii_fields_count
	invo_fields[li_i].of_register_dynamic (ipo_requestor)
Next

Return 1
end function

public function integer of_add_field (string as_name);n_dwr_field lnvo_field
SetNull(lnvo_field)
Return of_add_field(as_name, 0, lnvo_field)

end function

private function integer of_sort_fields ();n_dwr_field lnv_col[]
n_dwr_field lnv_rep[]
int li_field, li_fieldn, li_base
For li_field = 1 To ii_fields_count
	If invo_fields[li_field].ii_dwo_type = inv_field_const.DT_REPORT Then
		lnv_rep[UpperBound(lnv_rep[]) + 1] = invo_fields[li_field]
	Else
		lnv_rep[UpperBound(lnv_col[]) + 1] = invo_fields[li_field]
	End If
Next
li_fieldn = UpperBound(lnv_col[])
For li_field = 1 To li_fieldn
	invo_fields[li_field] = lnv_col[li_field]
Next
li_base = li_fieldn
li_fieldn = UpperBound(lnv_rep[])
For li_field = 1 To li_fieldn
	invo_fields[li_base + li_field] = lnv_rep[li_field]
Next
Return 1
end function

public function integer of_add_field (string as_name, long al_instance_id, ref n_dwr_field anvo_field);string ls_field_class
string ls_coltype
integer li_ret = 1
integer li_row_in_detail
long ll_i
n_dwr_field lnvo_field
n_dwr_field lnb
if not(ib_enabled) then return 1
ls_field_class = of_describe(as_name + '.type')
If IsNull(anvo_field) Then
	if of_describe(as_name + '.visible') = '0' and (not invo_parm.ib_export_invisible) then return 1
	if of_describe(as_name + '.width') = '0' then return 1
	if pos(of_describe(as_name + '.tag'), is_skip_key) > 0 then return 1
	
	//penta
	choose case ls_field_class
//		  case 'datawindow'
//			  li_ret = -1
//		  case 'bitmap'
//			  if invo_parm.ib_pictures then
//	  			  li_ret = of_add_picture(as_name, anvo_field)
//				else
//					li_ret = -1
//			  end if
//		  case 'button'
//			  li_ret = -1
		  case 'column'
			  anvo_field = create n_dwr_field
			  anvo_field.inv_parm = invo_parm
			  anvo_field.of_SetParentBand(this)
			  anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
			  anvo_field.of_init(as_name, inv_field_const.DT_COLUMN)	  
		  case 'compute'
			  anvo_field = create n_dwr_field
			  anvo_field.inv_parm = invo_parm
			  anvo_field.of_SetParentBand(this)
			  anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
			  anvo_field.of_init(as_name, inv_field_const.DT_COMPUTE)		  
//		  case 'graph'
//			  li_ret = -1
//		  case 'groupbox'
//			  li_ret = -1
		  case 'line'
			  li_ret = of_add_line(as_name, anvo_field)
//		  case 'ole'
//			  li_ret = -1
//		  case 'ellipse'
//			  li_ret = -1
		  case 'rectangle'
			  li_ret = of_add_rect(as_name, anvo_field)
		  case 'report'
				if invo_parm.ib_nested then
					anvo_field = create n_dwr_field
					anvo_field.inv_parm = invo_parm
					anvo_field.of_SetParentBand(this)
					anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
					anvo_field.of_init(as_name, inv_field_const.DT_REPORT)
				else
					li_ret = -1
				end if
//		  case 'roundrectangle'
//			  li_ret = -1
//		  case 'tableblob'
//			  li_ret = -1
		  case 'text'
			  anvo_field = create n_dwr_field
			  anvo_field.inv_parm = invo_parm
			  anvo_field.of_SetParentBand(this)
			  anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
			  anvo_field.of_init(as_name, inv_field_const.DT_TEXT)
		case else
			//penta
			return 1
	end choose
				  
	if li_ret < 1 then return li_ret
	
	if anvo_field.ii_sparse > 0 then
		invo_sparse_fields[anvo_field.ii_sparse] = anvo_field
	end if
	
	if ib_grid /*and is_band_name <> "detail"*/ then
		if anvo_field.of_get_x2() > il_base_x + il_grid_detail_width and (not invo_parm.ib_always_export_grid_header) then
			// don't export grid column's header if the column is hidden
			li_ret = -1
		end if
	end if
	
	if li_ret < 1 then return li_ret

	ST_RECT coord
	if ib_trim_overlapped Or ib_has_rectangles then
		coord.x1 = anvo_field.of_get_x1()
		coord.y1 = anvo_field.of_get_y1()
		coord.x2 = anvo_field.of_get_x2()
		coord.y2 = anvo_field.of_get_y2()
	end if
	if ib_has_rectangles then
		for ll_i = 1 to UpperBound(inv_rect[])
			// ***WORKAROUND*** for .NET and appeon
			lnvo_field = inv_rect[ll_i]
			// ***END***				
			if lnvo_field <> anvo_field then
				if inv_rect[ll_i].of_IsInside(coord.x1, coord.y1, coord.x2, coord.y2) then
					inv_rect[ll_i].of_add_field(as_name, al_instance_id)
					return 2
				end if
			end if
		next
	end if
	if ib_trim_overlapped then
		long ll_status
		ll_status = addOverlappedObject(iul_oostorage, ref coord)
		if ll_status < 0 then // object is completely inside other object and will not be exported
			li_ret = -1
		elseif ll_status > 0 then // object partially overlaps with other object and was trimmed
			anvo_field.of_SetRect(coord.x1, coord.y1, coord.x2, coord.y2)
		end if
	end if
	
	if li_ret < 1 then return li_ret
	
	If anvo_field.of_get_x1() >= il_x2 Or anvo_field.of_get_x2() <= il_x1 Then
		// do not split band, just extend
	Else
		If ib_has_autosize_height_objects Then
			//split band
			Return -3
		End If
	End If
End If
If anvo_field.ib_autosize_height And anvo_field.ii_dwo_type = inv_field_const.DT_REPORT Then
	If il_x1 = -1 Then
		il_x1 = anvo_field.of_get_x1()
	Else
		il_x1 = min(il_x1, anvo_field.of_get_x1())
	End If
	If il_x2 = -1 Then
		il_x2 = anvo_field.of_get_x2()
	Else
		il_x2 = min(il_x2, anvo_field.of_get_x2())
	End If
	ib_has_autosize_height_objects = True
End If

choose case ls_field_class
	  case 'report'
			n_dwr_nested_service_parm lnvo_nested_parm
			lnvo_nested_parm = Create n_dwr_nested_service_parm
			lnvo_nested_parm.inv_sheet = inv_sheet
			lnvo_nested_parm.invo_colors = invo_colors
			lnvo_nested_parm.is_parent_band_id = is_band_id
			lnvo_nested_parm.ipo_progress = ipo_progress
			anvo_field.is_nested_instance_id = String(al_instance_id)
			li_ret = anvo_field.of_CreateNestedService(lnvo_nested_parm, invo_parm)
end choose


if li_ret = 1 then
   if not(ib_variable_band_height) then
      if anvo_field.of_get_band_y1() > (ii_band_height + invo_hgrid.ii_round_ratio) then li_ret = -1
      if li_ret = 1 then
         ii_fields_count ++
         invo_fields[ ii_fields_count ] = anvo_field
      end if
   else
      ii_fields_count ++
      invo_fields[ ii_fields_count ] = anvo_field
   end if
end if

if li_ret = 1 then
   if (ii_band_type = 3) and (ii_rows_per_detail > 1) then
		li_row_in_detail = invo_row_in_detail.of_get_value(as_name)
		if li_row_in_detail > 0 then
			anvo_field.ii_row_in_detail = li_row_in_detail
		end if	
   end if 	
	if anvo_field.ii_dwo_type = inv_field_const.DT_REPORT	then
		ib_has_reports = True
	end if
end if

return li_ret
end function

public function integer of_process_row (long al_row, long al_base_y, n_dwr_progress apo_progress);integer li_i
integer li_ret = 1
integer li_res = 1
long ll_band_row, ll_obj_written = 0
integer li_merge_row
long ll_band_col
integer li_merge_col
any la_val
time lt_time
datetime ldt_dtime
date ld_date
string ls_picture

long ll_nested_rows = 0, ll_nested_ret, ll_current_hsplit_values[]
long ll_x1, ll_x2, ll_y1, ll_y2
boolean lb_row_height_set = false
boolean lb_suppressedRow = false


if not invo_parm.ib_export_hidden_treeview_levels then
	// For TreeView skip collapsed levels
	if ii_dw_processing = 8 or ii_dw_processing = 9 then
		choose case ii_band_type
			case 2, 4 // Tree level Header, Tree level Trailer
				if not of_isTreeLevelVisible(al_row, ii_group_level - 1) then
					return ll_obj_written
				end if
			case 3 // Detal
				if not of_isTreeLevelVisible(al_row, ii_group_level) then
					return ll_obj_written
				end if
		end choose
	end if
end if


// for nested with 0 rows: skip invalid summary and footer
If al_row = 0 and il_dw_row_count = 0 And ib_nested Then
	Return ll_obj_written
End If

If ib_background_color Then
	ST_RECT cInit, cMax
	of_GetBgRect(ref cInit, al_row)
	cMax.x1 = -1
	cMax.x2 = -1
	cMax.y1 = -1
	cMax.y2 = -1	
	initBandBackground(iul_bg, ref cInit, ref cMax)
End If

if ib_has_reports then
	for li_i = 1 to ii_fields_count
		if invo_fields[li_i].ii_dwo_type = inv_field_const.DT_REPORT then
			ll_nested_ret = invo_fields[li_i].of_process_nested(al_row, al_base_y, invo_hgrid, apo_progress)
			if ll_nested_ret > ll_nested_rows then
				ll_nested_rows = ll_nested_ret
			end if
			ll_obj_written ++
			continue
		end if
	next
end if

lb_suppressedRow = of_isRowSuppressed(al_row)

il_row_cnt = 0 
for li_i = 1 to ii_fields_count
	if invo_fields[li_i].ii_dwo_type = inv_field_const.DT_REPORT then
		continue
	end if
	//check visible 
	if invo_fields[li_i].of_get_visible(al_row) <> 1 and &
			(not invo_parm.ib_export_invisible) then continue
	ll_obj_written ++ 
	
	ll_x1 = invo_fields[li_i].of_get_x1(al_row)
	ll_x2 = invo_fields[li_i].of_get_x2(al_row)
	ll_y1 = invo_fields[li_i].of_get_y1(al_row) + al_base_y
	ll_y2 = invo_fields[li_i].of_get_y2(al_row) + al_base_y
	
	If ib_background_color Then
		AddObjectToBand(iul_bg, inv_sheet.handle, ll_x1, ll_x2, ll_y1, ll_y2)
	End If
	
	if ib_has_custom_renderers then
		if invo_fields[li_i].of_render(inv_sheet, al_row, al_base_y, ii_units, apo_progress) then
			continue
		end if
	end if
	
	// check if it is a picture object
	if invo_fields[li_i].ii_dwo_type = inv_field_const.DT_PICTURE then
		ls_picture = invo_fields[li_i].DYNAMIC of_descr_filename()
		if ls_picture <> "" then
			inv_sheet.of_create_cell_drawing(&
				ll_x1, &
				ll_x2, &
				ll_y1, &
				ll_y2, &
				ls_picture, &
				invo_fields[li_i].of_get_format(al_row), &
				ii_units &
				)		
		end if
	else
		la_val = invo_fields[li_i].of_getvalue(al_row)
		if lb_suppressedRow and invo_fields[li_i].ii_sparse > 0 then
			SetNull(la_val)
		end if
		
		// check if it is a bitmap column
		if invo_fields[li_i].of_descr_bitmapname() and invo_parm.ib_pictures then
			ls_picture = string(la_val)
			
			if ls_picture <> "" and not isNull(ls_picture) then
				inv_sheet.of_create_cell_drawing(&
					ll_x1, &
					ll_x2, &
					ll_y1, &
					ll_y2, &
					ls_picture, &
					invo_fields[li_i].of_get_format(al_row), &
					ii_units &
					)		
			end if
		else
			CHOOSE CASE ClassName(la_val)
				// penta
				CASE "decimal"
					IF	POS (string (la_val),'.')>0	Then
						inv_sheet.of_create_cell (ll_x1, ll_x2, ll_y1, ll_y2, string (la_val), invo_fields[li_i].of_get_format(al_row), ii_units)
					Else
						inv_sheet.of_create_cell (ll_x1, ll_x2, ll_y1, ll_y2, double (la_val), invo_fields[li_i].of_get_format(al_row), ii_units)
					End IF
				CASE "integer","double","number","real"
					inv_sheet.of_create_cell(&
						ll_x1, &
						ll_x2, &
						ll_y1, &
						ll_y2, &
						double(la_val), &
						invo_fields[li_i].of_get_format(al_row), &
						ii_units &
						)						
				CASE "string","char"
					inv_sheet.of_create_cell(&
						ll_x1, &
						ll_x2, &
						ll_y1, &
						ll_y2, &
						string(la_val), &
						invo_fields[li_i].of_get_format(al_row), &
						ii_units &
						)
				CASE "date"
					ld_date = la_val	  
					inv_sheet.of_create_cell(&
						ll_x1, &
						ll_x2, &
						ll_y1, &
						ll_y2, &
						ld_date, &
						invo_fields[li_i].of_get_format(al_row) , &
						ii_units &
						)
				CASE "datetime"
					ldt_dtime = la_val	  
					inv_sheet.of_create_cell(&
						ll_x1, &
						ll_x2, &
						ll_y1, &
						ll_y2, &
						ldt_dtime, &
						invo_fields[li_i].of_get_format(al_row) , &
						ii_units &
						)
				CASE "time"
					lt_time = la_val
					inv_sheet.of_create_cell(&
						ll_x1, &
						ll_x2, &
						ll_y1, &
						ll_y2, &
						lt_time, &
						invo_fields[li_i].of_get_format(al_row) , &
						ii_units &
						)
				CASE ELSE
					inv_sheet.of_create_cell(&
						ll_x1, &
						ll_x2, &
						ll_y1, &
						ll_y2, &
						"", &
						invo_fields[li_i].of_get_format(al_row) , &
						ii_units &
						)
			END CHOOSE
		end if
	end if
	if ib_yield_enable then 
	  Yield()
	end if
	if ib_cancel then
	  li_ret = -1
	  exit
	end if
next
If ib_background_color Then
	inv_sheet.fillBandBackground(inv_sheet.Handle, iul_bg, of_GetFormat(al_row), ii_units)
End If


return ll_obj_written

end function

public function integer of_check_process_row (long al_row, long al_base_y, boolean ab_newpage, n_dwr_progress apo_progress);
long ll_obj_written = 0
if not(ib_enabled) and not(ii_band_type=2 or ii_band_type = 3) then return 0

choose case ii_band_type
   case 1 //header
     //if (al_row = 1) or ((ab_newpage) and invo_parm.ib_group_pageheader) then
     if (al_row = 1) or ((ab_newpage) and invo_parm.ib_group_pageheader) then
        ll_obj_written = of_process_row(al_row, al_base_y, apo_progress)
     end if
   case 2 //group.header
     if ((al_row = il_groupchangerow) and (il_dw_row_count > 0)) or (ab_newpage) then
		  if ib_enabled then ll_obj_written = of_process_row(al_row, al_base_y, apo_progress)
		  if ((al_row = il_groupchangerow) and (il_dw_row_count > 0)) then
				Choose Case ipo_requestortype 
					Case DataWindow!
						il_groupchangerow = idw_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataStore!
						il_groupchangerow = ids_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataWindowChild!
						il_groupchangerow = idwc_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case Else
						Return -1
				End Choose  
	         if il_groupchangerow <= 0 then il_groupchangerow = il_dw_row_count + 1
		  end if
     end if
   case 3 //detail
     if al_row <=  il_dw_row_count then
        ll_obj_written = of_process_row(al_row, al_base_y, apo_progress)
     end if
   case 4 //group.trailer
     if (al_row = il_groupchangerow) or (ab_newpage) then	
			if (al_row > 1) and (ib_enabled) then
				ll_obj_written = of_process_row(al_row - 1, al_base_y, apo_progress)
			end if
			if invo_parm.ib_group_pagebreak and ib_newpage then
				if (al_row > 1) and (al_row <= il_dw_row_count + 1) and (ab_newpage) then 
					inv_sheet.addHBreak(inv_sheet.handle, al_base_y, ii_units)
				end if
			end if
		  
		  if al_row = il_groupchangerow then
				Choose Case ipo_requestortype 
					Case DataWindow!
						il_groupchangerow = idw_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataStore!
						il_groupchangerow = ids_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case DataWindowChild!
						il_groupchangerow = idwc_requestor.findgroupchange(il_groupchangerow + 1, ii_group_level)
					Case Else
						Return 0
				End Choose  
	        if il_groupchangerow <= 0 then il_groupchangerow = il_dw_row_count + 1
   	  end if
		  
     end if
	  
   case 5 //summary
     if al_row =  (il_dw_row_count + 1) then
        ll_obj_written = of_process_row(al_row - 1, al_base_y, apo_progress)
     end if
	  
   case 6 //footer
     if ((al_row =  (il_dw_row_count + 1)) or (ab_newpage)) then
        ll_obj_written = of_process_row(al_row - 1, al_base_y, apo_progress)
     end if
end choose


return ll_obj_written

end function

public subroutine of_cancel ();ib_cancel = true

long li_i
for li_i = 1 to ii_fields_count
	if invo_fields[li_i].ii_dwo_type = inv_field_const.DT_REPORT then
		invo_fields[li_i].of_cancel_nested()
	end if
next
end subroutine

public function integer of_add_line (string as_name, ref n_dwr_field anvo_field);int li_ret = 1

if not invo_parm.ib_lines then
	li_ret = -1 
end if

if li_ret = 1 then
	if of_describe(as_name + ".x1") <> of_describe(as_name + ".x2") and &
	   of_describe(as_name + ".y1") <> of_describe(as_name + ".y2") then
		// line is inclined: not supported
		li_ret = -1
	end if
end if

if li_ret = 1 then
	anvo_field = create n_dwr_line
	anvo_field.of_SetParentBand(this)
	anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
	li_ret = anvo_field.of_init(as_name, inv_field_const.DT_LINE)
end if

Return li_ret
end function

public function integer of_add_rect (string as_name, ref n_dwr_field anvo_field);int li_ret = 1
long ll_rect
if not invo_parm.ib_rectangles then
	li_ret = -1 
end if
if li_ret = 1 then
	anvo_field = create n_dwr_rect
	anvo_field.of_SetParentBand(this)
	anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
	li_ret = anvo_field.of_init(as_name, inv_field_const.DT_RECT)
end if
if li_ret = 1 then
	ib_has_custom_renderers = true
	ll_rect = UpperBound(inv_rect[]) + 1
	inv_rect[ll_rect] = anvo_field
	inv_rect[ll_rect].of_InitBand(this)
	ib_has_rectangles = true
end if

Return li_ret
end function

public subroutine of_init_bg_fillers ();
If invo_parm.ib_background_color Then
	ib_background_color = true
End If
If ib_background_color And ib_nested Then
	//If Not invo_nested_parm.ib_multidw Then  //TODO fix multidw BG color support
		ib_background_color = false  // band BG color is not supported for nested DW 
	//End If
End If
If ib_background_color Then
	If of_CountNested() > 0 Then
		ib_background_color = false  // band BG color is not supported for DW with nested 
	End If
End If

If ib_background_color Then
	of_InitBgStorage()
	inv_bg_format.setBgColor(inv_bg_format.handle, of_descr_bg_color())
	ib_custom_format =  ib_bg_color_expr
	If Not ib_custom_format Then
		il_bg_format_ix = inv_book.of_AddFormat(inv_bg_format)
	End If
End If

end subroutine

public function long of_countnested ();Long li_band, li_bandn, li_field, li_fieldn, li_nestedn = 0
li_fieldn = UpperBound(invo_fields[])
For li_field = 1 To li_fieldn
	If invo_fields[li_field].ii_dwo_type = DT_REPORT Then
		li_nestedn ++
	End If
Next
Return li_nestedn
end function

public function long of_getformat (long al_row);long ll_format_ix

if not ib_custom_format then
	return il_bg_format_ix
end if

if ib_bg_color_expr       then of_eval_bg_color(al_row)

il_bg_format_ix = inv_book.of_AddFormat(inv_bg_format)

Return il_bg_format_ix

end function

public subroutine of_set_bg_x (long al_x1, long al_x2);il_bg_x1 = al_x1
il_bg_x2 = al_x2

end subroutine

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
			ls_str = idw_requestor.describe("Datawindow." + is_band_name + '.' + as_property_name)
		Case DataStore!
			ls_str = ids_requestor.describe("Datawindow." + is_band_name + '.' + as_property_name)
		Case DataWindowChild!
			ls_str = idwc_requestor.describe("Datawindow." + is_band_name + '.' + as_property_name)
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

public function long of_descr_bg_color ();integer li_ret 
string ls_str, ls_bgmode, ls_band
string ls_value
long ll_color

ll_color = 1073741824 //0x40000000, Window Background
//553648127 or 536870912 - transparent
// if band bg color is transparent then
//    use dw color  
// else
//    use band bg color
// end

li_ret = of_check_property('Color', ref ib_bg_color_expr, ref is_bg_color_expr, ref ls_value)
if (Not ib_bg_color_expr and (ls_value = "553648127" or ls_value = "536870912")) or &
	li_ret <> 1 or Not isNumber(ls_value)  then 
	// use dw color
	li_ret = of_check_property("::Datawindow.Color", ref ib_bg_color_expr, ref is_bg_color_expr, ref ls_value)
end if
ll_color = long(ls_value) 
return ll_color



end function

public function integer of_eval_bg_color (long al_row);integer li_color_index 
string ls_value
long ll_color

if al_row <= il_dw_row_count then 
	ll_color = Long(of_describe('evaluate("' + is_bg_color_expr + '", ' + string(al_row) + ')'))
	inv_bg_format.setBgColor(inv_bg_format.handle, ll_color)
	return 1
end if

return -1

end function

public function integer of_init (string as_band_name, integer ai_band_type, integer ai_group_level, boolean ab_newpage, n_dwr_grid anvo_vgrid);integer li_ret = 1
boolean lb_vgrid_def = false

is_band_name = as_band_name
ii_band_type = ai_band_type
ii_group_level = ai_group_level
ib_newpage = ab_newpage

ib_autosize_band_height = of_describe('datawindow.' + is_band_name + '.height.autosize') = "yes"
ii_processing = long(of_describe('datawindow.processing'))
ib_grid = (ii_processing = 1)

//if ii_band_type = 3 then ib_variable_band_height = true
if ib_autosize_band_height then ib_variable_band_height = true

ii_dw_processing = integer(of_describe ( 'Datawindow.Processing' ))

if Not(isNull(ANVO_VGRID)) then
   if isValid(ANVO_VGRID) then lb_vgrid_def = true 
end if

if lb_vgrid_def then
   invo_vgrid = anvo_vgrid
else
   invo_vgrid = create n_dwr_grid
   invo_vgrid.ii_round_ratio = invo_vgrid.ii_round_init_ratio * id_conv
end if

if (ai_band_type = 3) and (ii_rows_per_detail > 1) then
	of_find_row_in_detail()
end if

if not(ib_variable_band_height) then
    invo_hgrid = create n_dwr_grid
    invo_hgrid.ii_round_ratio = invo_hgrid.ii_round_init_ratio * id_conv
    
    ii_band_height = integer(of_describe('datawindow.' + is_band_name + '.height'))
	 If il_base_y < 0 Then
	     ii_band_height += il_base_y
	 End If
    if ii_band_height > 0 then
       ib_enabled = true
       if invo_parm.ib_keep_band_height then
           il_ysplit_ind_from = invo_hgrid.of_add_split(0)
           il_ysplit_ind_to = invo_hgrid.of_add_split(ii_band_height)
       end if
       
       il_row_cnt = invo_hgrid.of_get_split_count() - 1
       
       if il_row_cnt < 0 then il_row_cnt = 0
       ib_enabled = true
    else
      ib_enabled = false
    end if
else
    ib_enabled = true
end if
Choose Case ai_band_type
	Case 1; is_band_id = BAND_HEADER
	Case 2; is_band_id = BAND_GROUPHEADER
	Case 3; is_band_id = BAND_DETAIL
	Case 4; is_band_id = BAND_GROUPTRAILER
	Case 5; is_band_id = BAND_SUMMARY
	Case 6; is_band_id = BAND_FOOTER
End Choose

if is_band_id = BAND_DETAIL and invo_parm.ib_check_suppressed then
	// Check if it is in SPARSE list
	long ll_cnt
	string ls_sparse
	n_dwr_string s
	ls_sparse = of_describe('Datawindow.Sparse')
	ll_cnt = s.of_ParseToArray(ls_sparse, '~t', is_sparseList[])
end if

of_sort_fields()

of_init_bg_fillers()
return li_ret

end function

public function integer of_register (powerobject apo_requestor, n_dwr_workbook anv_book, n_dwr_worksheet anv_sheet, n_dwr_service_parm anvo_parm, n_dwr_colors anvo_colors, integer ai_rows_per_detail, long al_base_x, long al_base_y, long al_subband_y);//idw_dw = adw_dw
il_base_x = al_base_x
il_base_y = al_base_y
il_subband_y = al_subband_y
ipo_requestor = apo_requestor
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

//invo_writer = anvo_writer
inv_book = anv_book
//invo_cur_sheet = anvo_sheet
inv_sheet = anv_sheet
invo_parm = anvo_parm
invo_colors = anvo_colors
ii_rows_per_detail = ai_rows_per_detail
ib_trim_overlapped = invo_parm.ib_trim_overlapped 
return 1
end function

public subroutine of_copyfrom (n_dwr_band anv_band);// ***
this.ib_variable_band_height = anv_band.ib_variable_band_height
this.ib_autosize_band_height = anv_band.ib_autosize_band_height
//

this.id_x_coef = anv_band.id_x_coef
this.id_y_coef = anv_band.id_y_coef
this.id_conv = anv_band.id_conv
this.ii_units = anv_band.ii_units
this.ib_nested = anv_band.ib_nested
this.ipo_progress = anv_band.ipo_progress
this.invo_nested_parm = anv_band.invo_nested_parm
this.il_grid_detail_width = anv_band.il_grid_detail_width

//li_ret = this.of_register (  ipo_requestor, inv_book, inv_sheet, invo_parm, invo_colors, ii_rows_per_detail, il_base_x, 0, al_subband_y )
this.il_base_x = anv_band.il_base_x
this.il_base_y = anv_band.il_base_y
this.il_subband_y = anv_band.il_subband_y
this.ipo_requestor = anv_band.ipo_requestor
this.ipo_requestortype = anv_band.ipo_requestortype
this.idw_requestor = anv_band.idw_requestor
this.il_dw_row_count = anv_band.il_dw_row_count
this.ids_requestor = anv_band.ids_requestor
this.idwc_requestor = anv_band.idwc_requestor
this.inv_book = anv_band.inv_book
this.inv_sheet = anv_band.inv_sheet
this.invo_parm = anv_band.invo_parm
this.invo_colors = anv_band.invo_colors
this.ii_rows_per_detail = anv_band.ii_rows_per_detail

//li_ret = lnvo_band.of_init (  as_band_name, ai_band_type, ai_group_level, lb_newpage, invo_global_vgrid )
this.is_band_name = anv_band.is_band_name
this.ii_band_type = anv_band.ii_band_type
this.ii_group_level = anv_band.ii_group_level
this.ib_newpage = anv_band.ib_newpage
this.ib_autosize_band_height = anv_band.ib_autosize_band_height
this.ii_processing = anv_band.ii_processing
this.ib_grid = anv_band.ib_grid
this.ii_dw_processing = anv_band.ii_dw_processing
this.invo_vgrid = anv_band.invo_vgrid
this.invo_hgrid = anv_band.invo_hgrid
this.ii_band_height = anv_band.ii_band_height
this.ib_enabled = anv_band.ib_enabled
this.il_row_cnt = anv_band.il_row_cnt
this.is_band_id = anv_band.is_band_id




end subroutine

public subroutine of_initbgstorage ();
iul_bg = createBandBackground()
inv_bg_format = inv_book.of_CreateFormat()

end subroutine

public subroutine of_getbgrect (ref st_rect ast_rect, long al_row);ast_rect.x1 = il_bg_x1
ast_rect.x2 = il_bg_x2
ast_rect.y1 = il_base_y + il_subband_y + il_bg_y1
ast_rect.y2 = il_base_y + il_subband_y + il_bg_y2 

end subroutine

public subroutine of_dispose ();// force GC to destroy objects with mutual referrences

long ll_i
For ll_i = 1 to UpperBound(invo_fields[])
  	If IsValid(invo_fields[ll_i]) Then
  		invo_fields[ll_i].of_dispose()
	End If
Next
n_dwr_field e[]
invo_fields[] = e[]


end subroutine

public function integer of_do_static_x_markup (n_dwr_worksheet anv_sheet);// Records all static (without expressions) X coordinates of all 
// nested objects.
// Returns 1 if all X coordinates of all nested objects are static 
// Otherwise returns -1 and some of X might be not recorded
//

Int li_ret = 1
Int li_field

If ii_rows_per_detail > 1 Then
	Return -1
End If

For li_field = 1 To UpperBound(invo_fields[])
	If invo_fields[li_field].of_do_static_x_markup(anv_sheet) <> 1 Then 
		li_ret = -1
		Exit
	End If
Next

Return li_ret
end function

public function boolean of_istreelevelvisible (long al_row, long al_level);
if al_level > 0 then	
	Choose Case ipo_requestortype 
		Case DataWindow!
			do while al_level > 0
				if not idw_requestor.isExpanded(al_row, al_level) then return false
				al_level --
			loop	
		Case DataStore!
			Return ids_requestor.isExpanded(al_row, al_level)
		Case DataWindowChild!
			Return idwc_requestor.isExpanded(al_row, al_level)
		Case Else
			Return true
	End Choose   
end if


return true
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

Long li_i
For li_i = 1 To ii_fields_count
	invo_fields[li_i].of_register_dynamic2(ipo_requestor, al_rowcount)
Next

Return 1
end function

public function boolean of_isrowsuppressed (long al_row);integer li_i, li_suppress = 0
any la_val, la_val_prev

if is_band_id = BAND_DETAIL then
	if UpperBound(invo_sparse_fields) > 0 then
		if al_row > 1 then
			for li_i = 1 to UpperBound(invo_sparse_fields)
				la_val_prev = invo_sparse_fields[li_i].of_getvalue(al_row - 1)
				la_val = invo_sparse_fields[li_i].of_getvalue(al_row)
				if (la_val_prev = la_val) or (isNull(la_val_prev) and isNull(la_val)) then
					li_suppress ++
				end if
			next
			return (li_suppress = UpperBound(invo_sparse_fields))
		end if
	end if
end if

return false
end function

public function integer of_add_picture (string as_name, ref n_dwr_field anvo_field);int li_ret = 1

if not invo_parm.ib_pictures then
	li_ret = -1 
end if

if li_ret = 1 then
	anvo_field = create n_dwr_picture
	anvo_field.of_SetParentBand(this)
	anvo_field.of_register(ipo_requestor, inv_book, invo_colors, il_base_x, il_base_y, il_subband_y, ib_background_color)
	li_ret = anvo_field.of_init(as_name, inv_field_const.DT_PICTURE)
end if

Return li_ret
end function

on n_dwr_band.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_band.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;inv_field_const = create n_dwr_field
If ib_trim_overlapped Then
	iul_oostorage = createOverlappedStorage()
End If

end event

event destructor;
If iul_oostorage <> 0 Then
	destroyOverlappedStorage(iul_oostorage)
	iul_oostorage = 0
End If

If iul_bg <> 0 Then
	destroyBandBackground(iul_bg)
	iul_bg = 0
End If

end event

