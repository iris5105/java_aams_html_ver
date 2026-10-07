forward
global type fw_w_notice_view from w_response1st
end type
type p_close from pf_u_imagebutton within fw_w_notice_view
end type
type dw_mast from fw_u_dwo within fw_w_notice_view
end type
type uo_viewer from pf_u_webbrowser within fw_w_notice_view
end type
type uo_1 from u_file_manage within fw_w_notice_view
end type
end forward

global type fw_w_notice_view from w_response1st
integer width = 3753
integer height = 3060
string title = "문서보기"
p_close p_close
dw_mast dw_mast
uo_viewer uo_viewer
uo_1 uo_1
end type
global fw_w_notice_view fw_w_notice_view

type variables
String	ispath4server = ''
String	is_rowid, is_log_yn
end variables

forward prototypes
public function long of_attachedfileopen (long al_row, boolean ab_boolean)
public function long of_attachedfileopenall (datawindow ldw, boolean ab_boolean)
end prototypes

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

on fw_w_notice_view.create
int iCurrent
call super::create
this.p_close=create p_close
this.dw_mast=create dw_mast
this.uo_viewer=create uo_viewer
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_close
this.Control[iCurrent+2]=this.dw_mast
this.Control[iCurrent+3]=this.uo_viewer
this.Control[iCurrent+4]=this.uo_1
end on

on fw_w_notice_view.destroy
call super::destroy
destroy(this.p_close)
destroy(this.dw_mast)
destroy(this.uo_viewer)
destroy(this.uo_1)
end on

event open;call super::open;string	ls_mesg, ls_parm[]

ls_mesg = message.stringparm
if fw_f_obj2array(ls_mesg, '~t', ls_parm)<>2	then
	messagebox('Notice', '잘못된 윈도우 호출입니다')
	close(this)
	return
end if

is_rowid  = ls_parm[1]
is_log_yn = ls_parm[2]

uo_viewer.of_navigate (uo_viewer.viewer_url)
end event

event wue_postopen;call super::wue_postopen;dw_mast.settransobject(SQLCA)

LONG	ll_docu_no, ll_read_seq

STRING	ls_board_no, ls_content, ls_corp_gr, ls_save_corp

datetime ldtm_now

SELECT  corp_gr
      , board_no
		, docu_no
      , docu_content
  INTO  :ls_corp_gr
      , :ls_board_no
		, :ll_docu_no
      , :ls_content
FROM    fw_docu_mst t1
WHERE   sys_id || corp_gr || board_no || TO_CHAR(docu_no) = :is_rowid;

IF SQLCA.sqlcode ()=0   Then
	ls_corp_gr = SQLCA.getitemstring(1)
	ls_board_no = SQLCA.getitemstring(2)
	ll_docu_no = SQLCA.getitemnumber(3)
	ls_content = SQLCA.getitemstring(4)
	IF	gaa.aams	Then
		ls_save_corp = '2200'
	ElseIF ls_board_no = '0000001' Then
		ls_save_corp = gaa.corp_gr
	Else
		ls_save_corp = ls_corp_gr
	End IF
	
	uo_viewer.of_viewcontents(ls_content)

	dw_mast.retrieve (gnv_vari.is_sys_id, ls_corp_gr, ls_board_no, ll_docu_no)

	IF is_log_yn='Y'  Then
		SELECT  max(read_seq)
		  INTO  :ll_read_seq
		FROM    fw_docu_log t1
		WHERE   sys_id   = :gnv_vari.is_sys_id
		  AND   corp_gr  LIKE :ls_save_corp
		  AND   board_no = :ls_board_no
		  AND   docu_no  = :ll_docu_no;

		ll_read_seq = SQLCA.getitemnumber (1)
		IF isnull(ll_read_seq) THEN ll_read_seq = 0
		ll_read_seq += 1

		ldtm_now = fw_f_getymdhh24miss4d()

		INSERT INTO  fw_docu_log (
							corp_gr                          /* _1: */
						 , sys_id                           /* _2: */
						 , board_no                         /* _3: */
						 , docu_no                          /* _4: */
						 , read_seq                         /* _5: */
						 , read_user                        /* _6: */
						 , read_dtm )                       /* _7: */
		VALUES ( :ls_save_corp                              /* _1: */
				 , :gnv_vari.is_sys_id                        /* _2: */
				 , :ls_board_no                               /* _3: */
				 , :ll_docu_no                                /* _4: */
				 , :ll_read_seq                               /* _5: */
				 , :gnv_vari.is_user_id                       /* _6: */
				 , :ldtm_now                                  /* _7: */
				 );
		IF SQLCA.sqlcode ()=0   Then
			commitJ ()
		else
			messagebox('Notice', '게시글 로그 생성 오류~r~n' + SQLCA.sqlerrtext ())
			rollbackJ ()
			RETURN
		End IF
	End IF
else
	messagebox('Notice', '게시글 읽기 실패!')
	RETURN
End IF

uo_1.dw_view.setlist4fontpointcolor = 'compression=1=e'
uo_1.event ue_init(ls_corp_gr, '', '00110')
uo_1.dw_view.retrieve (gnv_vari.is_sys_id, ls_corp_gr, ls_board_no, ll_docu_no, '00110')
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_notice_view
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_notice_view
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_notice_view
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_notice_view
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_notice_view
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_notice_view
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_notice_view
end type

type p_close from pf_u_imagebutton within fw_w_notice_view
integer x = 3479
integer y = 28
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;close(parent)

end event

type dw_mast from fw_u_dwo within fw_w_notice_view
integer x = 50
integer y = 156
integer width = 3662
integer height = 160
integer taborder = 10
boolean bringtotop = true
string dataobject = "fw_d_notice_view_c0"
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

type uo_viewer from pf_u_webbrowser within fw_w_notice_view
integer x = 50
integer y = 344
integer width = 3662
integer height = 1860
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylebox!
string binarykey = "fw_w_notice_view.win"
end type

type uo_1 from u_file_manage within fw_w_notice_view
integer x = 50
integer y = 2204
integer width = 3653
integer height = 764
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

event ue_downloadall;of_attachedfileopenall (uo_1.dw_view, false)
end event

