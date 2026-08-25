forward
global type fw_n_file from nonvisualobject
end type
end forward

global type fw_n_file from nonvisualobject
end type
global fw_n_file fw_n_file

type prototypes

end prototypes

type variables
Constant 	Integer		WRITE_LINE_BLOB_REPLACE 		= 1
Constant 	Integer		WRITE_LINE_STRING_APEND 		= 2
Constant 	Integer		WRITE_STREAM_BLOB_APEND 		= 3
Constant 	Integer		WRITE_LINE_BLOB_APEND 			= 4
Constant	Integer		OTHER 								= 5

statictext	ist_msg
end variables

forward prototypes
public function long getfile (string path, ref blob data)
public function long setfile (string path, ref blob data, integer filemode)
end prototypes

public function long getfile (string path, ref blob data);blob lb_blob
long ll_file_handle, ll_loop_count, i
long ll_file_length, ll_bytes_read

pointer lp_pointer
lp_pointer = SetPointer(HourGlass!)

ll_file_length = FileLength(path)
ll_file_handle = FileOpen(path, StreamMode!)
IF ll_file_handle < 0 THEN 
	Return -1
END IF

ll_bytes_read = FileReadEX(ll_file_handle, data)
FileClose(ll_file_handle)
SetPointer(lp_pointer)

RETURN ll_bytes_read
end function

public function long setfile (string path, ref blob data, integer filemode);/* ------------------------------------------------------------------- //

	Access		: Public
	Function		: setFile
	Return Type	: Long		(File Bytes)
	Argument Type					Name						Command
	------------------------------------------------------------
	value		String				Path						화일의 Path와 Name
	ref	   Blob					data						화일의 Blob형태
	value		Integer				filemode					1/LineMode, 2/StreamMode
	
	Command  : 화일을 만든다.
	
// ------------------------------------------------------------------- */
blob lb_blob
long ll_file_handle, ll_loop_count, i
long ll_blob_length, ll_bytes_read, ll_new_pos

pointer lp_pointer
lp_pointer = SetPointer(HourGlass!)

IF filemode = WRITE_LINE_BLOB_REPLACE THEN
	ll_file_handle = FileOpen(path, LineMode!, Write!, LockWrite!, Replace!)
	FileWriteEX(ll_file_handle, data)
ELSEIF filemode = WRITE_LINE_STRING_APEND THEN
	ll_file_handle = FileOpen(path, LineMode!, Write!, LockWrite!, Append! )
	FileWriteEX(ll_file_handle, String(data))
ELSEIF filemode = WRITE_STREAM_BLOB_APEND THEN
	ll_file_handle = FileOpen(path, StreamMode!, Write!, LockWrite!, Append! )
	FileWriteEX(ll_file_handle, data)
ELSE
	ll_blob_length = len(data)
	ll_file_handle = FileOpen(path, StreamMode!, Write!, LockWrite!, Replace!)
	if ll_file_handle = -1 then
		//messagebox('Notice', '컴퓨터를 찾을 수 없습니다.')
		return -1
	end if
	
	IF ll_blob_length > 32765 THEN
		IF Mod(ll_blob_length, 32765) = 0 THEN
			ll_loop_count = ll_blob_length / 32765
		ELSE
			ll_loop_count = (ll_blob_length / 32765) + 1
		END IF
	ELSE
		ll_loop_count = 1
	END IF
	
	ll_new_pos = 0
	//au_scroll.hpb_1.maxposition = ll_loop_count
	FOR i = 1 TO ll_loop_count
		lb_blob = blobmid(data, ll_new_pos * 32765 + 1, 32765)
		FileWriteEX(ll_file_handle, lb_blob)
		//au_scroll.wf_setposition( i )
		ll_new_pos ++
	NEXT
END IF
FileClose(ll_file_handle)
SetPointer(lp_pointer)

RETURN ll_blob_length
end function

on fw_n_file.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_file.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

