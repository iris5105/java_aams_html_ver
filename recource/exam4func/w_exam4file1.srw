forward
global type w_exam4file1 from w_window1st5cn
end type
type dw_1 from fw_u_dwo within w_exam4file1
end type
end forward

global type w_exam4file1 from w_window1st5cn
boolean ibconfirmupdate4closequery = true
dw_1 dw_1
end type
global w_exam4file1 w_exam4file1

type variables

Public:
	String		ispath4server	= ''
	String		ispath4client	= ''
end variables

forward prototypes
public function integer of_attachdeleteall ()
public function long of_attachedfileopen (long al_row, boolean ab_boolean)
public subroutine of_setbeonce4event (string as_html)
public subroutine of_setfile (string as_arg1, string as_arg2)
public subroutine of_setreset4upo ()
public subroutine of_setpath4server (string as_gb)
end prototypes

public function integer of_attachdeleteall ();Long		ll_rowcnt, ll_i

ll_rowcnt = dw_1.rowcount()
For ll_i = ll_rowcnt to 1 step -1
	dw_1.deleterow(ll_i)
next

If dw_1.update() = 1 Then
	commitJ ()
	Return 1
Else
	rollbackJ ()
	Return -1
End If
end function

public function long of_attachedfileopen (long al_row, boolean ab_boolean);// 첨부파일 열기
choose case dw_1.getitemstatus(al_row, 0, primary!)
	case newmodified!, new!
		messagebox('Notice', '첨부파일이 아직 업로드 되지 않았습니다')
		return 0
end choose

string		ls_org_filename, ls_mod_filename
string		ls_filepath, ls_filename
string		ls_board_no
long		 ll_attach_seq, ll_file_num

ls_org_filename		= dw_1.getitemstring(al_row, 'org_file_name')
ls_mod_filename	= dw_1.getitemstring(al_row, 'mod_file_name')
ls_board_no			= dw_1.getitemstring(al_row, 'board_no')
ll_attach_seq		= dw_1.getitemnumber(al_row, 'attach_seq')

If ab_boolean = true Then
	ls_filepath			= gnv_extfunc.of_getsystemtemppath() + ls_org_filename
	ls_filename			= ls_org_filename
Else
	ls_filepath			= ls_org_filename
	if getfilesavename("첨부파일을 저장할 위치를 설정하세요", ls_filepath, ls_filename) <= 0 then return 0
End If

fw_n_httpfile lnv_http
lnv_http = create fw_n_httpfile
if lnv_http.of_filedownload(ls_org_filename, ispath4server, ls_filepath) < 0 then
	Messagebox('Check', 'file download fail')
	return -1
end if

destroy lnv_http

If ab_boolean = true Then return gnv_extfunc.of_shellexecute(ls_filepath)
end function

public subroutine of_setbeonce4event (string as_html);
end subroutine

public subroutine of_setfile (string as_arg1, string as_arg2);string	ls_currentdir
string	ls_pathname, ls_filename
integer	li_rtn

li_rtn = getfileopenname("업로드할 파일을 선택하세요", ls_pathname, ls_filename, "*.*", "All Files(*.*), *.*")
if li_rtn < 1 then return

//ll_find = dw_1.find("org_file_name='" + ls_filename + "'", 1, dw_1.rowcount())
//if ll_find > 0 then
//	messagebox('Notice', '[' + ls_filename + '] 해당 파일은 이미 첨부파일 목록에 등록되어 있습니다.')
//	return
//end if

string	ls_board_no
long	ll_file_size, ll_new
ls_board_no = dw_cond.getitemstring(1, 'board_no')
ll_file_size = filelength(ls_pathname)

ll_new = dw_1.insertrow(0)
dw_1.setitem(ll_new, 'sys_id', gnv_vari.is_sys_id)
dw_1.setitem(ll_new, 'board_no', ls_board_no)
dw_1.setitem(ll_new, 'org_file_name', ls_filename)
dw_1.setitem(ll_new, 'mod_file_name', ls_filename)
dw_1.setitem(ll_new, 'file_size', ll_file_size)
dw_1.setitem(ll_new, 'client_path', ls_pathname)
end subroutine

public subroutine of_setreset4upo ();
end subroutine

public subroutine of_setpath4server (string as_gb);ispath4server = '/filetest/' + as_gb + '-' + String(fw_f_getymdhh24miss4d(), 'yyyymmdd') + '-' + gnv_vari.is_user_id
end subroutine

on w_exam4file1.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_exam4file1.destroy
call super::destroy
destroy(this.dw_1)
end on

event wue_retrieve;call super::wue_retrieve;string			ls_docu_no
Long			ll_ret, ll_row

If dw_cond.accepttext() = -1 Then Return

ls_docu_no = dw_cond.getitemstring(1, 'board_no')

ll_ret = dw_1.retrieve(gnv_vari.is_sys_id, ls_docu_no)
end event

event wue_delete;If of_attachdeleteall() = -1 Then
	messagebox('Error ', '첨부파일 삭제가 완료되지 않았습니다.')
	Return -1
End If
end event

event wue_clear;call super::wue_clear;dw_cond.reset()
dw_cond.insertrow(0)
dw_cond.setitem(1, 'board_no', '01')
of_setpath4server('01')


end event

event wue_retrieve2ready;call super::wue_retrieve2ready;dw_1.reset()
end event

event wue_update;call super::wue_update;Return of_update({dw_1})
end event

event wue_input;of_setfile('', '')
return 1
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within w_exam4file1
end type

type ln_templeft from w_window1st5cn`ln_templeft within w_exam4file1
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_exam4file1
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_exam4file1
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_exam4file1
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_exam4file1
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_exam4file1
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_exam4file1
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_exam4file1
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_exam4file1
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_exam4file1
end type

type uo_navi from w_window1st5cn`uo_navi within w_exam4file1
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_exam4file1
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_exam4file1
end type

type st_top_rect from w_window1st5cn`st_top_rect within w_exam4file1
end type

type p_close from w_window1st5cn`p_close within w_exam4file1
end type

type p_excel from w_window1st5cn`p_excel within w_exam4file1
end type

type p_print from w_window1st5cn`p_print within w_exam4file1
end type

type p_delete from w_window1st5cn`p_delete within w_exam4file1
end type

type p_update from w_window1st5cn`p_update within w_exam4file1
end type

type p_input from w_window1st5cn`p_input within w_exam4file1
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_exam4file1
end type

type p_clear from w_window1st5cn`p_clear within w_exam4file1
end type

type dw_cond from w_window1st5cn`dw_cond within w_exam4file1
string dataobject = "d_fileservice_c1"
boolean setfocusdw = true
boolean setedittoken = true
end type

event dw_cond::itemchanged;call super::itemchanged;If row < 1 Then Return
dw_1.reset()
If dwo.name = 'board_no' Then of_setpath4server(data)
end event

type dw_1 from fw_u_dwo within w_exam4file1
integer x = 50
integer y = 348
integer width = 5381
integer height = 2416
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_fileservice_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4clearselect = true
end type

event buttonclicked;call super::buttonclicked;If row < 1 Then Return
ispath4server	= This.Object.server_path[row]
ispath4client	= This.Object.client_path[row]

Choose case string(dwo.name)
	Case 'b_open'
		of_attachedfileopen(row, true)
	Case 'b_save'
		of_attachedfileopen(row, false)
	Case 'b_delete'
		if messagebox('Notice', '선택한 첨부파일을 삭제하시겠습니까?', Question!, YesNo!, 2) = 1 then
			dw_1.deleterow(row)
			dw_1.update()
			fw_f_message('D01', '', '')
		end if
End Choose

end event

event updatestart;call super::updatestart;Long	ll_modified, ll_attach_seq

ll_modified = this.getnextmodified(0, primary!)
do while ll_modified > 0
	If dw_1.getitemstatus(ll_modified, 0, primary!) = newmodified! Then
		ll_attach_seq = long(dw_1.describe("Evaluate('Max(attach_seq for all)', 1)"))
		ll_attach_seq += 1
		dw_1.setitem(ll_modified, 'attach_seq', ll_attach_seq)
	End If
	ll_modified = dw_1.getnextmodified(ll_modified, primary!)
loop

// 저장
String	ls_server_path, ls_client_path, ls_subdir, ls_errmsg
blob	lb_file_content
integer	li_file_num

// 업로드 작업 후 fw_docu_attach 저장 
String		ls_filestobeuploaded[]
String		ls_mod_file_name
long		ll_filecnt, ll_filebytes

ll_modified = dw_1.getnextmodified(0, primary!)
do while ll_modified > 0
	If dw_1.getitemstatus(ll_modified, 0, primary!) = newmodified! Then
		ll_attach_seq	= dw_1.getitemnumber(ll_modified, 'attach_seq')
		ls_client_path	= dw_1.getitemString(ll_modified, 'client_path')
		ll_filecnt ++
		ls_filestobeuploaded[ll_filecnt] = ls_client_path
	End If	
	ll_modified = dw_1.getnextmodified(ll_modified, primary!)
loop

If ll_filecnt > 0 Then
	fw_n_httpfile lnv_http
	lnv_http = create fw_n_httpfile	
	If lnv_http.of_fileupload(ls_filestobeuploaded, ispath4server, false) < 0 Then
		rollbackJ ()
		messagebox('Error', '파일 전송에 실패했습니다!!~r~n' + '첨부파일 전송 오류')
		destroy lnv_http
		Return 1
	End If
	destroy lnv_http
End If

ll_modified = dw_1.getnextmodified(0, primary!)
Do while ll_modified > 0
	If dw_1.getitemstatus(ll_modified, 0, primary!) = newmodified! Then
		dw_1.setitem(ll_modified, 'server_path', ispath4server)
		dw_1.setitem(ll_modified, 'reg_id', gnv_vari.is_user_id)
		dw_1.setitem(ll_modified, 'reg_dt', fw_f_getymdhh24miss4s())
	End If	
	ll_modified = dw_1.getnextmodified(ll_modified, primary!)
Loop
end event

