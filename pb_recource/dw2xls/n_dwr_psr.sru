forward
global type n_dwr_psr from nonvisualobject
end type
type st_dwlookup from structure within n_dwr_psr
end type
end forward

type st_dwlookup from structure
	string		dwo_name
	string		dwo_id
end type

shared variables

long ii_recsize = 0
string is_tempdir = ""
long ii_tempid = 0
boolean ib_debug_keep_temp = false


end variables

global type n_dwr_psr from nonvisualobject
end type
global n_dwr_psr n_dwr_psr

type variables
private:
string is_file = ""
OleStorage ipo_storage

st_dwlookup ipo_dwlookup[]
Boolean ib_temporary = false


public:
public constant string BAND_DETAIL = "1"
public constant string BAND_HEADER = "2"
public constant string BAND_FOOTER = "3"
public constant string BAND_SUMMARY = "4"
public constant string BAND_GROUPHEADER = "5"
public constant string BAND_GROUPTRAILER = "6"

end variables

forward prototypes
public function integer of_openfile (string as_file)
public function integer of_close ()
public function integer of_parsepath (string as_path, ref string as_out_dir, ref string as_out_file)
public function string of_gettempfilename (string as_prefix, string as_suffix)
public function integer of_createfromdw (powerobject apo_dw)
private function long of_copystream (olestorage apo_src_root_storage, string as_src_stream_name, olestorage apo_tgt_root_storage, string as_tgt_stream_name)
private function integer of_copystream (olestream apo_src_stream, olestream apo_tgt_stream)
private function string of_finddwoid (string as_dwoname)
private function integer of_makestorage (olestorage apo_root_storage, string as_dir)
private function olestream of_openstream (olestorage apo_storage, string as_name, stgreadmode apo_mode)
private function olestorage of_opensubstorage (string as_name, olestorage apo_parentstorage, stgreadmode apo_mode)
private function integer of_parsedwlookup ()
private function blob of_readstream (olestorage apo_root_storage, string as_stream)
private function integer of_setdwlookuprecsize ()
public function integer of_nested2psr (string as_nested_id, string as_nested_instance_id, string as_parent_band, long al_parent_row, string as_dddw_column_id[], string as_psr_name)
public function integer of_nested2ds (string as_nested_id, string as_dataobject, string as_parent_band, long al_parent_row, string as_dddw_column_id[], ref ads_jTier ads_nested)
public subroutine of_debug_keep_temp (boolean ab_debug_keep_temp)
end prototypes

public function integer of_openfile (string as_file);int li_ret

ipo_storage = Create OleStorage
li_ret = ipo_storage.Open(as_file, stgRead!)
If li_ret <> 0 Then
	SetNull(ipo_storage)
	Return -1
End If
is_file = as_file
of_ParseDWLookUp()


Return 1
end function

public function integer of_close ();int li_ret = -1
If IsValid(ipo_storage) Then
	li_ret = ipo_storage.Close()
	SetNull(ipo_storage)
	If ib_temporary Then
		FileDelete(is_file)
	End If
	is_file = ""
End If
Return li_ret 

end function

public function integer of_parsepath (string as_path, ref string as_out_dir, ref string as_out_file);
Long li_pos
li_pos = Pos(Reverse(as_path), "\")
If li_pos > 0 Then
	as_out_dir = Left(as_path, Len(as_path) - li_pos)
	as_out_file = Right(as_path, li_pos - 1)
Else
	as_out_file = as_path
	as_out_dir = ""
End If

Return 1
end function

public function string of_gettempfilename (string as_prefix, string as_suffix);If is_tempdir = "" Then
	String  ls_values[]

	ContextKeyword lpo_kw 
	Int li_ret
	li_ret = this.GetContextService("Keyword", lpo_kw) 
	lpo_kw.GetContextKeywords ("TEMP", ls_values) 

	If UpperBound(ls_values[]) > 0 Then
		is_tempdir = ls_values[1]
	Else
		is_tempdir = "."
	End If
End If
ii_tempid ++
Return is_tempdir + "\dw2xls_" + as_prefix + String(ii_tempid)  + "_" + String(Handle(GetApplication())) + as_suffix
end function

public function integer of_createfromdw (powerobject apo_dw);String ls_file
ls_file = of_GetTempFileName("dw", ".psr")
If FileExists (ls_file) Then
	If Not FileDelete(ls_file)  Then
		Return -1
	End If
End If
If apo_dw.Dynamic SaveAs(ls_file, PSReport!, True) <> 1 Then
	Return -1
End If
If of_OpenFile(ls_file) <> 1 Then
	FileDelete(ls_file)
	Return -1
End If
ib_temporary = True
Return 1 
end function

private function long of_copystream (olestorage apo_src_root_storage, string as_src_stream_name, olestorage apo_tgt_root_storage, string as_tgt_stream_name);olestorage lpo_src_storage, lpo_tgt_storage
olestream lpo_src_stream, lpo_tgt_stream
long li_ret
String ls_src_dir = "", ls_src_file, ls_tgt_dir = "", ls_tgt_file

SetNull(lpo_src_stream)
SetNull(lpo_tgt_stream)

of_ParsePath(as_src_stream_name, ls_src_dir, ls_src_file)
If ls_src_dir = "" Then
	lpo_src_storage = apo_src_root_storage
Else
	lpo_src_storage = of_OpenSubStorage(ls_src_dir, apo_src_root_storage, stgRead!)
End If

of_ParsePath(as_tgt_stream_name, ls_tgt_dir, ls_tgt_file)
If ls_tgt_dir = "" Then
	lpo_tgt_storage = apo_tgt_root_storage
Else
	lpo_tgt_storage = of_OpenSubStorage(ls_tgt_dir, apo_tgt_root_storage, stgReadWrite!)
End If

If IsNull(lpo_src_storage) Or IsNull(lpo_tgt_storage) Then
	Goto errorcleanup
End If

lpo_src_stream = of_OpenStream(lpo_src_storage, ls_src_file, stgRead!)
If IsNull(lpo_src_stream) Then
	Goto errorcleanup
End If
lpo_tgt_stream = of_OpenStream(lpo_tgt_storage,ls_tgt_file, stgWrite!)
If IsNull(lpo_tgt_stream) Then
	Goto errorcleanup
End If
li_ret = of_CopyStream(lpo_src_stream, lpo_tgt_stream)
If li_ret <> 0 Then
	Goto errorcleanup
End If
lpo_src_stream.Close()
lpo_tgt_stream.Close()

If ls_src_dir <> "" Then lpo_src_storage.Close()
If ls_tgt_dir <> "" Then lpo_tgt_storage.Close()

Return 1

errorcleanup:
If ls_src_dir <> "" Then lpo_src_storage.Close()
If ls_tgt_dir <> "" Then lpo_tgt_storage.Close()
If Not IsNull(lpo_src_stream) Then lpo_src_stream.Close()
If Not IsNull(lpo_tgt_stream) Then lpo_tgt_stream.Close()
Return -1
end function

private function integer of_copystream (olestream apo_src_stream, olestream apo_tgt_stream);long li_ret, li_streamsize, li_chunksize = 30000
blob lb_temp

If apo_src_stream.Length(li_streamsize) <> 0 Then
	Return -1
End If

Do While li_streamsize > 0
	li_ret = apo_src_stream.Read(lb_temp, min(li_chunksize, li_streamsize))
	If li_ret < 0  Then
		Return -1
	End If
	li_ret = apo_tgt_stream.Write(lb_temp)
	If li_ret <= 0 Then
		Return -1
	End If
	li_streamsize -= li_chunksize
Loop
Return 0
end function

private function string of_finddwoid (string as_dwoname);long li_reccount, li_record
li_reccount = UpperBound(ipo_dwlookup[])
as_dwoname = Lower(as_dwoname) 
For li_record = 1 To li_reccount
	If ipo_dwlookup[li_record].dwo_name = as_dwoname Then
		Return ipo_dwlookup[li_record].dwo_id
	End If
Next
Return ""
end function

private function integer of_makestorage (olestorage apo_root_storage, string as_dir);olestorage lpo_tgt_storage

lpo_tgt_storage = of_OpenSubStorage(as_dir, apo_root_storage, stgReadWrite!)
If IsNull(lpo_tgt_storage) Then
	Return -1
End If
lpo_tgt_storage.Close()
Return 1

end function

private function olestream of_openstream (olestorage apo_storage, string as_name, stgreadmode apo_mode);OleStream lpo_stream
int li_ret = -1
lpo_stream = Create OleStream
li_ret = lpo_stream.Open(apo_storage, as_name, apo_mode)
If li_ret <> 0 Then
	SetNull(lpo_stream)
	Return lpo_stream
End If
Return  lpo_stream 
end function

private function olestorage of_opensubstorage (string as_name, olestorage apo_parentstorage, stgreadmode apo_mode);olestorage lpo_storage
int li_ret

lpo_storage = Create OleStorage
li_ret = lpo_storage.Open(as_name, apo_mode, stgExclusive!, apo_parentstorage)
If li_ret <> 0 Then
	SetNull(lpo_storage)
	Return lpo_storage
End If
Return lpo_storage
end function

private function integer of_parsedwlookup ();st_dwlookup e[]
long li_reccount, li_record, li_pos
int li_dw_id
blob lbb_data

ipo_dwlookup[] = e[]
If ii_recsize = 0 Then
	If of_SetDWlookupRecSize() <> 1 Then
		Return -1
	End If
End IF
lbb_data = of_ReadStream(ipo_storage, "dwstg\dwlookup")
If IsNull(lbb_data) Then 
	Return 0
End If

blob{4} lbb_long
BlobEdit(lbb_long, 1, long(0))
li_reccount = Long(BlobMid(lbb_data, 1, 4))
If li_reccount < 0 Or li_reccount > 10000 Then
	// maybe damaged data
	Return -1
End If
For li_record = 1 To li_reccount
	ipo_dwlookup[li_record].dwo_name = &
		Lower(String(BlobMid(lbb_data, 5 + (li_record - 1) * ii_recsize, ii_recsize - 2)))
	BlobEdit(lbb_long, 1, BlobMid(lbb_data, 5 + li_record * ii_recsize - 2 , 2))
	ipo_dwlookup[li_record].dwo_id = String(Long(lbb_long))
Next
Return 1
end function

private function blob of_readstream (olestorage apo_root_storage, string as_stream);long li_ret
String ls_dir = "", ls_file
olestorage lpo_storage
olestream lpo_stream
blob lbb_data
SetNull(lpo_stream)
//SetNull(lbb_data)

of_ParsePath(as_stream, ls_dir, ls_file)
If ls_dir = "" Then
	lpo_storage = apo_root_storage
Else
	lpo_storage = of_OpenSubStorage(ls_dir, apo_root_storage, stgRead!)
End If
If IsNull(lpo_storage) Then Goto ErrorCleanUp

lpo_stream = of_OpenStream(lpo_storage, ls_file, stgRead!)
If IsNull(lpo_stream) Then Goto ErrorCleanUp

li_ret = lpo_stream.Read(lbb_data)
If li_ret < 0  Then
	Goto ErrorCleanUp
End If

Return lbb_data

ErrorCleanUp:
SetNull(lbb_data)
Return lbb_data
end function

private function integer of_setdwlookuprecsize ();ii_recsize = 42 + 2

Environment lenv
GetEnvironment(lenv) 
Choose Case lenv.CharSet
	Case CharSetAnsi!
		ii_recsize = 42 + 2
	Case CharSetUnicode!
		ii_recsize = 84 + 2
	Case Else
		// TODO: support DBCS
		Return -1
End Choose

Return 1
end function

public function integer of_nested2psr (string as_nested_id, string as_nested_instance_id, string as_parent_band, long al_parent_row, string as_dddw_column_id[], string as_psr_name);OleStorage lpo_tgt_storage
long li_ret = 1, li_item, li_column
String ls_nested_data_name
// only for 1st level of nesting
ls_nested_data_name = "datanest_" + String(al_parent_row) + "_" + as_parent_band + "_" + as_nested_id //as_nested_instance_id
lpo_tgt_storage = Create OleStorage
FileDelete(as_psr_name)
li_ret = lpo_tgt_storage.Open(as_psr_name, stgReadWrite! )
If li_ret <> 0 Then
	Return -1
End If

of_MakeStorage(lpo_tgt_storage, "neststg")
of_MakeStorage(lpo_tgt_storage, "dwstg")

li_ret = 1
If li_ret > 0 Then
	li_ret = of_CopyStream(&
		ipo_storage, "neststg\" + ls_nested_data_name, &
		lpo_tgt_storage, "data" &
		)
End If
//If li_ret > 0 Then
//	Blob lbb_source
//	lbb_source = of_ReadStream(ipo_storage, "dwstg\source_" + as_nested_id)
//End If

If li_ret > 0 Then
	li_ret = of_CopyStream(&
		ipo_storage, "dwstg\source_" + as_nested_instance_id, &
		lpo_tgt_storage, "source" &
		)
End If
If li_ret > 0 Then
	li_ret = of_CopyStream(&
		ipo_storage, "dwstg\object_" + as_nested_instance_id, &
		lpo_tgt_storage, "object" &
		)
End If
If li_ret > 0 Then
	li_ret = of_CopyStream(&
		ipo_storage, "dwstg\dwlookup", &
		lpo_tgt_storage, "dwstg\dwlookup" &
		)
End If
// copy nested DWOs
For li_item = 1 To UpperBound(ipo_dwlookup[])
	If ipo_dwlookup[li_item].dwo_id = as_nested_instance_id Then
		Continue
	End If
	If li_ret > 0 Then
		li_ret = of_CopyStream(&
			ipo_storage, "dwstg\source_" + ipo_dwlookup[li_item].dwo_id, &
			lpo_tgt_storage, "dwstg\source_" + ipo_dwlookup[li_item].dwo_id &
			)
	End If
	If li_ret > 0 Then
		li_ret = of_CopyStream(&
			ipo_storage, "dwstg\object_" + ipo_dwlookup[li_item].dwo_id, &
			lpo_tgt_storage, "dwstg\object_" + ipo_dwlookup[li_item].dwo_id &
			)
	End If
Next

//copy  DDDWs for the nested being copied
If li_ret > 0 Then
	For li_item = 1 To UpperBound(as_dddw_column_id[])
		li_ret = of_CopyStream(&
			ipo_storage, "neststg\datadddw_1_" + as_dddw_column_id[li_item] + "_0_" + String(al_parent_row), &
			lpo_tgt_storage, "neststg\datadddw_0_" + as_dddw_column_id[li_item] + "_0" &
			)
	Next
	li_ret = 1
End If

lpo_tgt_storage.Close()

Return li_ret

end function

public function integer of_nested2ds (string as_nested_id, string as_dataobject, string as_parent_band, long al_parent_row, string as_dddw_column_id[], ref ads_jTier ads_nested);
String ls_temppsr, ls_instance_id
int li_ret

ls_instance_id = of_FindDWOId(as_dataobject)
If ls_instance_id = "" Then
	Return -1
End If

ls_temppsr = of_GetTempFileName("nest", ".psr")
li_ret = of_Nested2PSR(as_nested_id, ls_instance_id, as_parent_band, al_parent_row, as_dddw_column_id[], ls_temppsr)
If li_ret <> 1 Then
	Return -1
End If
ads_nested = Create ads_jTier
ads_nested.DataObject = ls_temppsr
If ib_debug_keep_temp Then
Else
	FileDelete(ls_temppsr)
End If
If Not IsValid(ads_nested.Object) Then
	SetNull(ads_nested)
	Return -1
End If
Return 1
end function

public subroutine of_debug_keep_temp (boolean ab_debug_keep_temp);ib_debug_keep_temp = ab_debug_keep_temp

end subroutine

on n_dwr_psr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_psr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;of_Close()
end event

