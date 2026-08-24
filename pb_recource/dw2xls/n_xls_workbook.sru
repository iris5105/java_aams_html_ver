forward
global type n_xls_workbook from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_workbook from nonvisualobject
event type unsignedlong ue_add_string ( string as_value )
event type unsignedlong ue_add_unicode ( blob ab_string )
end type
global n_xls_workbook n_xls_workbook

type variables
public string is_filename
public long il_formatindex = 0
public long il_worksheetindex = 0
public int ii_activesheet = 0
public int ii_firstsheet = 0
public UInt ii_biff_version = 1280

public uint ii_xf_index = 14;

 public n_xls_worksheet invo_worksheets[];

 public n_xls_format invo_formats[];
 public n_cst_hash_long invo_xfs;

 public n_xls_subroutines_v97 invo_sub;


end variables

forward prototypes
public function integer of_create (string as_filename)
public function integer of_close ()
public function n_xls_worksheet of_addworksheet ()
public function n_xls_worksheet of_addworksheet (blob ab_worksheetname)
public function n_xls_worksheet of_addworksheet (string as_worksheetname)
public function n_xls_worksheet of_add_worksheet ()
public function n_xls_worksheet of_add_worksheet (blob ab_worksheetname)
public function n_xls_worksheet of_add_worksheet (string as_worksheetname)
public function n_xls_format of_addformat ()
public function n_xls_format of_add_format ()
public function integer of_set_custom_color (integer ai_index, integer ai_red, integer ai_green, integer ai_blue)
public function integer of_set_temp_dir (string as_tempdir)
public function integer of_set_codepage (unsignedinteger aui_codepage)
public function integer of_set_palette_xl97 ()
public function long of_reg_format (ref n_xls_format anvo_format)
public function long of_get_xf (ref n_xls_format anvo_format)
public function n_xls_format of_get_format (long ai_format)
end prototypes

public function integer of_create (string as_filename);// Generated default script
int retVar;
return retVar;
end function

public function integer of_close ();// Generated default script
int retVar;
return retVar;
end function

public function n_xls_worksheet of_addworksheet ();// Generated default script
return of_add_worksheet()
end function

public function n_xls_worksheet of_addworksheet (blob ab_worksheetname);return of_add_worksheet(AB_WORKSHEETNAME)
end function

public function n_xls_worksheet of_addworksheet (string as_worksheetname);// Generated default script
return of_add_worksheet(AS_WORKSHEETNAME)
end function

public function n_xls_worksheet of_add_worksheet ();// Generated default script
n_xls_worksheet retVar;
return retVar;
end function

public function n_xls_worksheet of_add_worksheet (blob ab_worksheetname);return of_add_worksheet(invo_sub.to_ansi(AB_WORKSHEETNAME))
end function

public function n_xls_worksheet of_add_worksheet (string as_worksheetname);// Generated default script
n_xls_worksheet retVar;
return retVar;
end function

public function n_xls_format of_addformat ();// Generated default script
return of_add_format()
end function

public function n_xls_format of_add_format ();// Generated default script
n_xls_format retVar;
return retVar;
end function

public function integer of_set_custom_color (integer ai_index, integer ai_red, integer ai_green, integer ai_blue);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_temp_dir (string as_tempdir);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_codepage (unsignedinteger aui_codepage);// Generated default script
int retVar;
return retVar;
end function

public function integer of_set_palette_xl97 ();// Generated default script
int retVar;
return retVar;
end function

public function long of_reg_format (ref n_xls_format anvo_format);string ls_key
//n_xls_format lnvo_format_copy
long li_ret

if anvo_format.ii_xf_index > 0 then
	li_ret = anvo_format.ii_xf_index
else
   ls_key = anvo_format.of_get_format_key()
   if invo_xfs.of_key_exists(ls_key) then
   	li_ret = invo_xfs.of_get_value(ls_key)
   else
		ii_xf_index ++
		il_formatindex ++
		invo_formats[il_formatindex] = anvo_format
		invo_xfs.of_set_value(ls_key, ii_xf_index)
		anvo_format.ii_xf_index = ii_xf_index
		li_ret = ii_xf_index
   end if
end if

return li_ret
end function

public function long of_get_xf (ref n_xls_format anvo_format);string ls_key
long li_ret
if anvo_format.ii_xf_index > 0 then return anvo_format.ii_xf_index

ls_key = anvo_format.of_get_format_key()
if invo_xfs.of_key_exists(ls_key) then
	li_ret = invo_xfs.of_get_value(ls_key)
else
	li_ret = 15
end if

return li_ret
end function

public function n_xls_format of_get_format (long ai_format);Return invo_formats[ai_format]
end function

on n_xls_workbook.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_workbook.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_sub = create n_xls_subroutines_v97
invo_xfs = create n_cst_hash_long 
end event

event destructor;destroy invo_sub
destroy invo_xfs
end event

