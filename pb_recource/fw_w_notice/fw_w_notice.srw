forward
global type fw_w_notice from wt_listshare
end type
type uo_editor from pf_u_webeditor within fw_w_notice
end type
type st_1 from pf_u_splitbar_vertical within fw_w_notice
end type
type uo_1 from u_file_manage within fw_w_notice
end type
end forward

global type fw_w_notice from wt_listshare
string icon = "Application5!"
uo_editor uo_editor
st_1 st_1
uo_1 uo_1
end type
global fw_w_notice fw_w_notice

type variables
Private:
   BOOLEAN	iberr2proc  = FALSE
	BOOLEAN	ibdelete		= FALSE

Public:
   ads_jTier ids_board_mst
   STRING	ispath4server  = ''
   STRING	ispath4client  = ''
   STRING	is_board_no    = ''
   STRING	is_contents    = ''
   LONG		ilhtml4update  = 0
end variables

forward prototypes
public function integer of_attachdeleteall ()
public function long of_attachedfileopen (long al_row, boolean ab_boolean)
public function long of_attachedfileopenall (datawindow ldw, boolean ab_boolean)
public function integer of_confirmupdate4close (datawindow adw_upt[])
public subroutine of_setfile (string as_arg1, string as_arg2)
public subroutine of_load4content (string as_sys_id, string as_corp_gr, string as_board_no, long al_docu_no)
end prototypes

public function integer of_attachdeleteall ();LONG	ll_rowcnt, ll_i

ll_rowcnt = uo_1.dw_view.rowcount ()
For ll_i = ll_rowcnt to 1 step -1
	IF f_server_file_delete (uo_1.dw_view.object.mod_file_name [ll_i], uo_1.dw_view.object.server_path [ll_i])	Then
		uo_1.dw_view.deleterow (ll_i)
	Else
		f_messageBox ('ERR', '파일삭제중 오류가 발생하였습니다.~r~n(f_server_file_delete)')
		RETURN -1
	End IF
next

IF uo_1.dw_view.update () = 1 Then
   commitJ ()
   Return 1
Else
   rollbackJ ()
   Return -1
End IF
end function

public function long of_attachedfileopen (long al_row, boolean ab_boolean);// 첨부파일 열기
CHOOSE CASE uo_1.dw_view.getitemstatus (al_row, 0, primary!)
   CASE newmodified!, new!
      messagebox('Notice', '첨부파일이 아직 업로드 되지 않았습니다')
      RETURN 0
END CHOOSE

BOOLEAN	lb_return

STRING	ls_org_filename, ls_mod_filename, ls_filepath, ls_filename, ls_board_no, ls_board_corp_gr, ls_compression

LONG	ll_docu_no, ll_attach_seq, ll_file_num

BLOB	lb_content

ls_org_filename = uo_1.dw_view.getitemstring(al_row, 'org_file_name')
ls_mod_filename = uo_1.dw_view.getitemstring(al_row, 'mod_file_name')
ls_board_no = uo_1.dw_view.getitemstring(al_row, 'board_no')
ll_docu_no = uo_1.dw_view.getitemnumber(al_row, 'docu_no')
ll_attach_seq = uo_1.dw_view.getitemnumber(al_row, 'attach_seq')
ls_compression = uo_1.dw_view.getitemstring(al_row, 'compression')

IF ab_boolean  Then
   ls_filepath = gnv_extfunc.of_getsystemtemppath() + ls_org_filename
   ls_filename = ls_org_filename
Else
   ls_filepath = ls_org_filename
   IF getfilesavename ("첨부파일을 저장할 위치를 설정하세요", ls_filepath, ls_filename)<=0 THEN RETURN 0
End IF

fw_n_httpfile  lnv_http

lnv_http = CREATE fw_n_httpfile

IF ls_compression='1'	THEN ls_filepath += '.zip'
IF lnv_http.of_filedownload(ls_org_filename+ '|' + ls_mod_filename, ispath4server, ls_filepath)<0 Then
	Messagebox('Check', 'file download fail')
	RETURN -1
End IF

DESTROY lnv_http

//<임시> 압축파일인 경우 압축 풀고 압축파일은 삭제
IF ls_compression='1'	Then
	ls_org_filename = MID (ls_filepath, 1, LASTPOS (ls_filepath, '\'))
	mo_.mipo_unzip (ls_filepath, ls_org_filename)
	filedelete (ls_filepath)
	ls_filepath = MID (ls_filepath, 1, LEN (ls_filepath) - 4)
End IF

IF ab_boolean THEN RETURN gnv_extfunc.of_shellexecute(ls_filepath)
end function

public function long of_attachedfileopenall (datawindow ldw, boolean ab_boolean);BOOLEAN	lb_return

STRING	ls_org_filename, ls_mod_filename, ls_filepath, ls_filename, ls_board_no, ls_board_corp_gr, ls_compression, ls_path

LONG	ll_docu_no, ll_attach_seq, ll_file_num, ll

BLOB	lb_content

fw_n_httpfile  lnv_http

lnv_http = CREATE fw_n_httpfile
IF ldw.rowcount()=0	THEN RETURN -1
IF getfolder ('파일을 저장할 폴더를 선택하십시요', ls_path)<>1	Then
	RETURN -1
End IF
FOR  ll = 1  TO  ldw.rowcount()
	ispath4server = ldw.object.server_path[ll]
	ls_org_filename = ldw.getitemstring(ll, 'org_file_name')
	ls_mod_filename = ldw.getitemstring(ll, 'mod_file_name')
	ls_board_no = ldw.getitemstring(ll, 'board_no')
	ll_docu_no = ldw.getitemnumber(ll, 'docu_no')
	ll_attach_seq = ldw.getitemnumber(ll, 'attach_seq')
	ls_compression = ldw.getitemstring(ll, 'compression')
	
	ls_filepath = ls_path + '\' + ls_org_filename

	IF ls_compression='1'	THEN ls_filepath += '.zip'
	IF lnv_http.of_filedownload(ls_org_filename+ '|' + ls_mod_filename, ispath4server, ls_filepath)<0 Then
		Messagebox('Check', 'file download fail')
		RETURN -1
	End IF
	
	IF ls_compression='1'	Then
		ls_org_filename = MID (ls_filepath, 1, LASTPOS (ls_filepath, '\'))
		mo_.mipo_unzip (ls_filepath, ls_org_filename)
		filedelete (ls_filepath)
	End IF
NEXT

DESTROY lnv_http

messagebox ('INFO', '첨부파일이 모두 다운로드 되었습니다.(' + string (ldw.rowcount()) + '개)')
end function

public function integer of_confirmupdate4close (datawindow adw_upt[]);LONG	ll_cnt, ll_ii, ll_rtn

IF uo_editor.ib_update=TRUE   Then
   ilhtml4update = 1
Else
   ilhtml4update = 0
End IF

ll_cnt = UpperBound(adw_upt)
For ll_ii= 1 To ll_cnt
   Yield ()
   adw_upt[ll_ii].AcceptText()
   IF adw_upt[ll_ii].Modifiedcount() + adw_upt[ll_ii].Deletedcount() + ilhtml4update>0 Then
      IF of_confirmupdate4boolean()=TRUE  Then
         ll_rtn = fw_f_message('Q01', inv_menu.is_pgm_nm, '')
         RETURN ll_rtn
      Else
         RETURN 1
      End IF
      EXIT
   End IF
Next
RETURN 0
end function

public subroutine of_setfile (string as_arg1, string as_arg2);STRING	ls_pathname, ls_filename, la_name []

INTEGER	li_rtn

LONG	ll_max_file_size, ll_file_size, ll_new, ll_name, ll

IF iberr2proc  Then
   ls_pathname = as_arg1
   ls_filename = as_arg2
	la_name [1] = ls_filename
Else
	IF GetFileOpenName ("첨부파일 선택", ls_pathname, la_name, '', "All Files (*.*),*.*", '', 2)<>1 THEN RETURN
	ll_name = upperbound (la_name)
	IF ll_name=0	THEN RETURN
End IF

IF ids_board_mst.rowcount ()=0   Then
   messagebox('Notice', '보드(Board) 정보를 읽어올 수 없습니다')
   RETURN
End IF

ll_max_file_size = ids_board_mst.getitemnumber(1, 'max_file_size')
FOR  ll = 1  TO  upperbound (la_name)
	ll_file_size = filelength(ls_pathname + '\' + la_name [ll])
	IF ll_file_size>ll_max_file_size * 1024 * 1024  Then
		messagebox('Notice', '최대 업로드 가능 사이즈는 ' + string(ll_max_file_size) + 'MByte 입니다~r~n' + la_name [ll])
		CONTINUE
	ElseIF ll_file_size=0	Then
		//<임시>
		// 파일크기가 0인경우 클라이언트에서 서버파일조회 및 삭제불가능
		// 20211015기준 자바에 크기0인 파일 처리 로직없음
		messagebox('ERR', '파일크기가 0입니다.~r~n전산실에 문의하여 주십시오.~r~n' + la_name [ll])
		CONTINUE
	End IF
	
	ll_new = uo_1.dw_view.insertrow (0)
	uo_1.dw_view.setitem(ll_new, 'sys_id', gnv_vari.is_sys_id)
	uo_1.dw_view.setitem(ll_new, 'corp_gr', dw_list.object.corp_gr [iRow]) //보드정보 필요
	uo_1.dw_view.setitem(ll_new, 'board_no', is_board_no)
	uo_1.dw_view.setitem(ll_new, 'org_file_name', la_name [ll])
	uo_1.dw_view.setitem(ll_new, 'file_size', ll_file_size)
	IF	upperbound (la_name)=1	Then
		uo_1.dw_view.setitem(ll_new, 'client_path', ls_pathname)
	Else
		uo_1.dw_view.setitem(ll_new, 'client_path', ls_pathname + '\' + la_name [ll])
	End IF
	uo_1.dw_view.setitem(ll_new, 'auth', '11110')
NEXT
end subroutine

public subroutine of_load4content (string as_sys_id, string as_corp_gr, string as_board_no, long al_docu_no);STRING	ls_html

uo_editor.of_resetcontents ()

SELECT  docu_content
  INTO  :ls_html
FROM    fw_docu_mst t1
WHERE   sys_id   = :as_sys_id
  AND   corp_gr  = :as_corp_gr
  AND   board_no = :as_board_no
  AND   docu_no  = :al_docu_no;

ls_html = SQLCA.getitemstring(1)

IF f_null (ls_html) THEN RETURN

Yield ()
uo_editor.of_setcontents (ls_html, TRUE)
is_contents = ls_html
end subroutine

on fw_w_notice.create
int iCurrent
call super::create
this.uo_editor=create uo_editor
this.st_1=create st_1
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_editor
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_1
end on

on fw_w_notice.destroy
call super::destroy
destroy(this.uo_editor)
destroy(this.st_1)
destroy(this.uo_1)
end on

event ue_wpage_modified;RETURN	(dw_list.uf_ismodified () OR uo_1.dw_view.modifiedcount ()>0 OR uo_1.dw_view.deletedcount ()>0 OR uo_editor.ib_update)
end event

event wue_retrieve;call super::wue_retrieve;STRING	ls_board_no, ls_docu_title, ls_corp_gr

Datetime	ld_from_dt, ld_to_dt

ls_board_no    = dw_c.object.board_no [1]
ld_from_dt     = datetime(date (string (dw_c.object.fymd [1])), time('00:00:00'))
ld_to_dt       = datetime(date (string (dw_c.object.tymd [1])), time('23:59:59'))
ls_docu_title  = f_nvl (dw_c.object.docu_title [1],'%')

IF ls_docu_title<>'%' THEN ls_docu_title = '%' + ls_docu_title + '%'
IF ls_board_no='0000001'  or (gaa.aams and ls_board_no='0000011')	Then
   ls_corp_gr = '%'
ElseIF gaa.aams Then
	ls_corp_gr = '2200'
Else
   ls_corp_gr = gaa.corp_gr
End IF

dw_list.retrieve (gnv_vari.is_sys_id, ls_corp_gr, ls_board_no, ld_from_dt, ld_to_dt, ls_docu_title)
IF iberr2proc THEN p_input.EVENT clicked ()
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw (dw_c, 'board_no', {gnv_vari.is_sys_id})
fw_f_setdddw(dw_master, 'err_type', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'SYSE001', '%'})
end event

event wue_update;IF dw_list.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF

STRING	ls_contents, ls_filestobeuploaded[], ls_corp_gr, la_zippath [], ls_zip

LONG	ll_docu_no, ll_modified, ll_attach_seq, ll_filecnt=0, ll_rtn, ll

IF EVENT ue_wpage_modified () Then
   IF uf_updatecommit (dw_list)=-1 THEN RETURN -1

	IF ibdelete=FALSE	Then
		ls_contents = uo_editor.of_getcontents ()
		ll_docu_no = dw_list.object.docu_no [iRow]
		IF is_contents<>ls_contents Then
			ls_corp_gr = iif (gaa.aams, '2200', gaa.corp_gr)
	
			UPDATE  fw_docu_mst
				SET  docu_content = :ls_contents
			WHERE   corp_gr  = :ls_corp_gr
			  AND   sys_id   = :gnv_vari.is_sys_id
			  AND   board_no = :is_board_no
			  AND   docu_no  = :ll_docu_no;
	
			is_contents = ls_contents
		End IF
	
		ll_attach_seq = f_num (uo_1.dw_view.describe("Evaluate('Max(attach_seq for all)', 1)"))
		ll_modified = uo_1.dw_view.getnextmodified(0, primary!)
		DO WHILE ll_modified > 0
			IF uo_1.dw_view.getitemstatus(ll_modified, 0, primary!)=newmodified! Then
				ll_attach_seq ++
				uo_1.dw_view.setitem(ll_modified, 'docu_no', ll_docu_no)
				uo_1.dw_view.setitem(ll_modified, 'attach_seq', ll_attach_seq)
				uo_1.dw_view.setitem(ll_modified, 'server_path', ispath4server)
				uo_1.dw_view.setitem(ll_modified, 'reg_id', gnv_vari.is_user_id)
				uo_1.dw_view.setitem(ll_modified, 'reg_dt', fw_f_getymdhh24miss4s())
				uo_1.dw_view.setitem(ll_modified, 'mod_file_name', fw_f_getymdhh24miss4s() + '-' + uo_1.dw_view.getitemString(ll_modified, 'corp_gr') + gnv_vari.is_user_id + '-' + string (ll_attach_seq))
				ll_filecnt ++
				
				//<임시> 클라이언트 패스를 보내기 전 압축 후 압축경로 전송
				// 압축실패시 원본경로 전송, 압축여부 0
				// 전송 완료후 압축파일 삭제
				messagebox('', uo_1.dw_view.getitemString(ll_modified, 'client_path'))
				ls_zip = gnv_vari.basepath + '\TEMP\' + uo_1.dw_view.getitemString(ll_modified, 'mod_file_name')
				IF mo_.zip (uo_1.dw_view.getitemString(ll_modified, 'client_path'), ls_zip, 'f')=0	Then
					ls_filestobeuploaded [ll_filecnt] = ls_zip + '|' + uo_1.dw_view.getitemString(ll_modified, 'mod_file_name')				
					la_zippath [upperbound (la_zippath) + 1] = ls_zip
					uo_1.dw_view.setitem(ll_modified, 'compression', '1')
				Else
					ls_filestobeuploaded [ll_filecnt] = uo_1.dw_view.getitemString(ll_modified, 'client_path') + '|' + uo_1.dw_view.getitemString(ll_modified, 'mod_file_name')				
					uo_1.dw_view.setitem(ll_modified, 'compression', '0')
				End IF
			End IF
			ll_modified = uo_1.dw_view.getnextmodified (ll_modified, primary!)
		LOOP
		IF uo_1.dw_view.update ()<>1 Then
			rollbackJ ()
			messagebox('Notice5', '자료 저장 실패했습니다!!~r~n' + uo_1.dw_view.istr_dberror.sqlerrtext)
			RETURN -1
		End IF
	   commitJ ()
	
		IF ll_filecnt>0  Then
			fw_n_httpfile  lnv_http
			lnv_http = CREATE fw_n_httpfile
			ll_rtn = lnv_http.of_fileupload (ls_filestobeuploaded, ispath4server, TRUE)
			//<임시> 전송완료후 성공실패 상관없이 압축파일은 삭제
			FOR  ll = 1  TO upperbound (la_zippath)
				filedelete (la_zippath [ll])
			NEXT
			IF ll_rtn<0 Then
				messagebox('Notice4.1', '자료 저장 실패했습니다!!~r~n' + '첨부파일 전송 오류')
				DESTROY lnv_http
				RETURN -1
			End IF
			DESTROY lnv_http
		End IF
	Else
		ibdelete = FALSE
	End IF
   uo_editor.ib_update = FALSE
End IF
RETURN 1
end event

event open;call super::open;ids_board_mst = CREATE ads_jTier
ids_board_mst.dataobject = 'fw_d_notice_ds1'
ids_board_mst.settransobject(SQLCA)
end event

event resize;call super::resize;dw_master.y = st_1.y

uo_editor.x = dw_master.x
uo_1.x = dw_master.x
uo_editor.width = dw_master.width
uo_1.width = dw_master.width

uo_editor.y = dw_master.y + dw_master.height + 30
uo_1.y = uo_editor.y + uo_editor.height - 100
uo_1.height = dw_list.y + dw_list.height - uo_1.y
end event

event wue_lastinst;call super::wue_lastinst;DATE	ld_now, ld_fr, ld_to

uo_editor.ib_update = FALSE

Choose CASE inv_menu.is_parameter1
   CASE '01'   //전체
      is_board_no = '0000001'
		IF NOT gaa.aams	THEN ib_managedata = FALSE
   CASE '02'   // 회사별
      is_board_no = '0000002'
   CASE '11'   // 에러 > 본인글만 삭제가능해야함
      is_board_no = '0000011'
		IF f_notnull (gnv_vari.iserror2path1) THEN iberr2proc = TRUE
End Choose
ids_board_mst.retrieve (gnv_vari.is_sys_id, is_board_no)

// 파일 업로드 서버 폴더 구성
ispath4server = '/notice/' + is_board_no + '-' + string(fw_f_getymdhh24miss4d(), 'yyyymmdd') + '-' + iif (gaa.aams, '2200', gaa.corp_gr) + gnv_vari.is_user_id

// 게시 시작일, 종료일 설정
ld_now = date (fw_f_getymdhh24miss4d())
ld_fr = relativedate(ld_now, -365)
ld_to = relativedate(ld_now, +365)

dw_c.Object.fymd [1] = datetime (ld_fr)
dw_c.Object.tymd [1] = datetime (ld_to)
dw_c.Object.board_no [1] = is_board_no

// Editor 페이지 오픈
uo_editor.of_openwebeditor ()

// Editor 오픈 대기
DO UNTIL uo_editor.of_getreadystate() = "complete"
	yield()
LOOP
p_retrieve.post event clicked ()
eb_direct_retrieve = TRUE
end event

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
uo_editor.of_resetcontents ()
uo_1.dw_view.reset ()
uo_editor.ib_update = FALSE

IF dw_c.dataobject>'' And ib_manageData   Then
	dw_list.uf_clear ()

	p_retrieve.of_setenabled (true)

	dw_c.Enabled = TRUE
	dw_c.SetFocus () ; f_selectText (dw_c)
	RETURN
End IF
IF	eb_direct_retrieve THEN p_retrieve.POST EVENT clicked ()
end event

event wue_postopen;call super::wue_postopen;uo_1.dw_view.setlist4fontpointcolor = 'compression=1=e'
uo_1.event ue_init(gaa.corp_gr, '', '11110')
end event

type lb_dirlist from wt_listshare`lb_dirlist within fw_w_notice
end type

type ln_templeft from wt_listshare`ln_templeft within fw_w_notice
end type

type ln_tempbuttom from wt_listshare`ln_tempbuttom within fw_w_notice
end type

type ln_temptop from wt_listshare`ln_temptop within fw_w_notice
end type

type ln_tempbutton from wt_listshare`ln_tempbutton within fw_w_notice
end type

type ln_tempstart from wt_listshare`ln_tempstart within fw_w_notice
end type

type ln_cond1_yline from wt_listshare`ln_cond1_yline within fw_w_notice
end type

type ln_dw1_yline from wt_listshare`ln_dw1_yline within fw_w_notice
end type

type ln_cond2_yline from wt_listshare`ln_cond2_yline within fw_w_notice
end type

type ln_dw2_yline from wt_listshare`ln_dw2_yline within fw_w_notice
end type

type ln_tempright from wt_listshare`ln_tempright within fw_w_notice
end type

type uo_navi from wt_listshare`uo_navi within fw_w_notice
end type

type ln_temptop_shadow from wt_listshare`ln_temptop_shadow within fw_w_notice
end type

type st_windelaytime from wt_listshare`st_windelaytime within fw_w_notice
end type

type st_top_rect from wt_listshare`st_top_rect within fw_w_notice
end type

type p_close from wt_listshare`p_close within fw_w_notice
end type

type p_excel from wt_listshare`p_excel within fw_w_notice
end type

type p_print from wt_listshare`p_print within fw_w_notice
end type

type p_delete from wt_listshare`p_delete within fw_w_notice
end type

type p_update from wt_listshare`p_update within fw_w_notice
end type

type p_input from wt_listshare`p_input within fw_w_notice
end type

type p_retrieve from wt_listshare`p_retrieve within fw_w_notice
end type

type p_clear from wt_listshare`p_clear within fw_w_notice
end type

type p_copy from wt_listshare`p_copy within fw_w_notice
end type

type dw_c from wt_listshare`dw_c within fw_w_notice
string dataobject = "fw_d_notice_c0"
end type

type btn_update from wt_listshare`btn_update within fw_w_notice
end type

type st_count from wt_listshare`st_count within fw_w_notice
end type

type dw_list from wt_listshare`dw_list within fw_w_notice
integer width = 2811
string title = "※ 내용이 안보이시면 아래 공지사항 List를 클릭 하십시요."
string dataobject = "fw_d_notice_1"
boolean ibtitle4datawindow = true
boolean eb_fund_default_change = false
boolean eb_copy_false = true
boolean eb_null_line = false
end type

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;of_load4content (Object.sys_id [iRow], Object.corp_gr [iRow], Object.board_no [iRow], Object.docu_no [iRow])
uo_editor.enabled=TRUE
uo_editor.ib_update = FALSE

uo_1.dw_view.reset()
uo_1.dw_view.retrieve (Object.sys_id [iRow], Object.corp_gr [iRow], Object.board_no [iRow], Object.docu_no [iRow], '11110')

RETURN 0
end event

event dw_list::ue_insert;call super::ue_insert;IF AncestorReturnVALUE=-1 THEN RETURN -1

Object.start_dtm [AncestorReturnVALUE] = fw_f_getymdhh24miss4d ()
uo_editor.of_resetcontents ()
dw_master.setcolumn('docu_title')
dw_master.POST SetFocus ()
IF iberr2proc THEN uo_1.post event ue_add()

RETURN AncestorReturnVALUE
end event

event dw_list::ue_deletestart;call super::ue_deletestart;IF of_attachdeleteall ()=-1   Then
   messagebox('Error ', '첨부파일 삭제가 완료되지 않았습니다.')
   RETURN -1
End IF
ibdelete = TRUE
is_contents = uo_editor.of_getcontents ()
RETURN 0
end event

event dw_list::ue_insertstart;LONG	ll_docu_no

dw_master.accepttext()
dw_master.of_setvisible (TRUE)

uf_setcolumn ('sys_id', gnv_vari.is_sys_id)
uf_setcolumn ('board_no', is_board_no)
uf_setcolumn ('corp_gr', iif (gaa.aams, '2200', gaa.corp_gr))
uf_setcolumn ('writer_name', gnv_vari.is_user_nm)

// 전체 공지사항 / 부서공지사항 자동 세팅
Choose CASE inv_menu.is_parameter1
   CASE '02','03'
      uf_setcolumn ('memb_type', 'part')
   CASE '11'
      uf_setcolumn ('memb_type', 'itchk')
   CASE Else
      uf_setcolumn ('memb_type', 'all')
End Choose
uf_setcolumn ('hold_yn', 'N')
uf_setcolumn ('ontop_yn', 'N')

//<임시> 최대값 게시글이 삭제됐을 때 재생성하면 삭제된 게시글의 로그가 출력됩니다.
// 로그삭제 or 고유번호
//IF is_board_no='0000001'   Then
   SELECT  NVL(max(docu_no),0) + 1
     INTO  :ll_docu_no
   FROM    fw_docu_mst t1
   WHERE   sys_id   = :gnv_vari.is_sys_id
     AND   board_no = :is_board_no;
//Else
//   SELECT  NVL(max(docu_no),0) + 1
//     INTO  :ll_docu_no
//   FROM    fw_docu_mst t1
//   WHERE   sys_id   = :gnv_vari.is_sys_id
//     AND   corp_gr  = :gaa.corp_gr
//     AND   board_no = :is_board_no;
//End IF
ll_docu_no = SQLCA.getitemnumber (1)

uf_setcolumn ('docu_no', string (ll_docu_no))
uf_setcolumn ('reg_id', gnv_vari.is_user_id)
uf_setcolumn ('reg_dt', fw_f_getymdhh24miss4s())

IF iberr2proc   Then
   uf_setcolumn ('docu_title', gnv_vari.iserror2navi)
   uf_setcolumn ('linked_pgm_no', gnv_vari.iserror2pgmno)
End IF

uo_editor.of_resetcontents ()

dw_master.setcolumn('docu_title')
dw_master.POST setfocus ()

RETURN 0
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnValue=1	THEN RETURN 1

STRING	ls_contents

ls_contents = uo_editor.of_getcontents ()
IF f_null (ls_contents) Then
   messagebox('Notice', '문서 내용을 입력하세요')
   RETURN 1
End IF
end event

event dw_list::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
dw_Master.Enabled = TRUE ; dw_Master.uf_setrange (false)
IF (rowcount >0 OR eb_null_line) OR NOT dw_Master.Visible	Then
	dw_Master.of_setvisible (TRUE)
End IF
end event

event dw_list::ue_copyrow;dw_master.of_setvisible (TRUE)
dw_master.scrolltorow (dw_list.getrow())
RETURN 0
end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF EVENT ue_wpage_modified ()	Then
	IF	event wue_update ()=-1 THEN return 1
End IF
RETURN 0
end event

event dw_list::updateend;call super::updateend;LONG	ll, ll_docu_no

STRING	ls_sys_id, ls_corp_gr, ls_board_no

FOR ll = 1  TO  rowsdeleted
	ls_sys_id   = GetItemString (ll, 'sys_id', Delete!, TRUE)
	ls_corp_gr  = GetItemString (ll, 'corp_gr', Delete!, TRUE)
	ls_board_no = GetItemString (ll, 'board_no', Delete!, TRUE)
	ll_docu_no  = GetItemNumber (ll, 'docu_no', Delete!, TRUE)
	
	DELETE  fw_docu_log
	WHERE   sys_id   = :ls_sys_id
     AND   corp_gr  = :ls_corp_gr
	  AND   board_no = :ls_board_no
	  AND   docu_no  = :ll_docu_no;
NEXT
end event

type dw_master from wt_listshare`dw_master within fw_w_notice
integer x = 2898
integer y = 348
integer width = 2533
integer height = 592
boolean titlebar = false
string dataobject = "fw_d_notice_2"
end type

event dw_master::itemfocuschanged;call super::itemfocuschanged;IF dwo.name='docu_title' THEN pf_f_togglekoreng('k')
end event

type uo_editor from pf_u_webeditor within fw_w_notice
integer x = 2889
integer y = 940
integer width = 2555
integer height = 1136
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string binarykey = "fw_w_notice.win"
boolean scaletoright = true
boolean scaletobottom = true
end type

type st_1 from pf_u_splitbar_vertical within fw_w_notice
integer x = 2871
integer y = 352
integer height = 2416
boolean bringtotop = true
boolean setcondcolor = true
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list"
string rightdragobject = "dw_master;uo_editor;uo_1"
end type

type uo_1 from u_file_manage within fw_w_notice
integer x = 2889
integer y = 2076
integer width = 2542
integer height = 688
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_file_manage::destroy
end on

event ue_init;call super::ue_init;dw_view.uf_dataobject ('fw_d_notice_view_1', FALSE)
end event

event ue_download;ispath4server = dw_view.object.server_path[row]

of_attachedfileopen(row, false)
end event

event ue_open;ispath4server = dw_view.object.server_path[row]

of_attachedfileopen(row, true)
end event

event ue_add;IF iberr2proc=TRUE Then
   of_setfile(gnv_vari.iserror2path1, right(gnv_vari.iserror2path1, 18))
   of_setfile(gnv_vari.iserror2path2, right(gnv_vari.iserror2path2, 22))
Else
   of_setfile('', '')
End IF
IF iberr2proc Then iberr2proc = FALSE
end event

event ue_deleteall;of_attachdeleteall()
end event

event ue_delete;IF ib_managedata	Then
	IF messagebox('Notice', '선택한 첨부파일을 삭제하시겠습니까?', Question!, YesNo!, 2)=1 Then
		IF f_server_file_delete (uo_1.dw_view.object.mod_file_name [row], uo_1.dw_view.object.server_path [row])	Then
			dw_view.deleterow (row)
			dw_view.update ()
			fw_f_message('D01', '', '')
		Else
			f_messageBox ('ERR', '파일삭제중 오류가 발생하였습니다.~r~n(f_server_file_delete)')
		End IF
	End IF
Else
	f_messageBox ('INFO', '작업할 수 없습니다')
End IF
end event

event ue_downloadall;of_attachedfileopenall (uo_1.dw_view, false)
end event

