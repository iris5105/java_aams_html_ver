forward
global type w_notice_file from wt_list
end type
type cb_2 from pf_u_commandbutton within w_notice_file
end type
type cb_3 from pf_u_commandbutton within w_notice_file
end type
end forward

global type w_notice_file from wt_list
cb_2 cb_2
cb_3 cb_3
end type
global w_notice_file w_notice_file

type variables
STRING	is_url
end variables

on w_notice_file.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_3
end on

on w_notice_file.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_3)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.status [1] = '1'
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

type lb_dirlist from wt_list`lb_dirlist within w_notice_file
end type

type ln_templeft from wt_list`ln_templeft within w_notice_file
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_notice_file
end type

type ln_temptop from wt_list`ln_temptop within w_notice_file
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_notice_file
end type

type ln_tempstart from wt_list`ln_tempstart within w_notice_file
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_notice_file
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_notice_file
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_notice_file
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_notice_file
end type

type ln_tempright from wt_list`ln_tempright within w_notice_file
end type

type uo_navi from wt_list`uo_navi within w_notice_file
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_notice_file
end type

type st_windelaytime from wt_list`st_windelaytime within w_notice_file
end type

type st_top_rect from wt_list`st_top_rect within w_notice_file
end type

type p_close from wt_list`p_close within w_notice_file
end type

type p_excel from wt_list`p_excel within w_notice_file
end type

type p_print from wt_list`p_print within w_notice_file
end type

type p_delete from wt_list`p_delete within w_notice_file
end type

type p_update from wt_list`p_update within w_notice_file
end type

type p_input from wt_list`p_input within w_notice_file
end type

type p_retrieve from wt_list`p_retrieve within w_notice_file
end type

type p_clear from wt_list`p_clear within w_notice_file
end type

type p_copy from wt_list`p_copy within w_notice_file
end type

type dw_c from wt_list`dw_c within w_notice_file
string dataobject = "d_notice_file"
end type

event dw_c::ue_valid;call super::ue_valid;CHOOSE CASE object.status [1]
	CASE '1'
		cb_2.TEXT = '선택데이터삭제'
		cb_2.of_setvisible (FALSE)
		cb_3.TEXT = '작업할파일 일괄선택'
		
		ib_managedata = TRUE
		dw_list.uf_dataobject ('d_notice_file_list', FALSE)
	CASE '2'
		cb_2.TEXT = '선택파일삭제'
		cb_2.of_setvisible (TRUE)
		cb_3.TEXT = '작업할파일 일괄선택'
		
		ib_managedata = FALSE
		dw_list.uf_dataobject ('d_notice_file_list2', FALSE)
	CASE '3'
		cb_2.TEXT = '스크립트생성'
		cb_2.of_setvisible (TRUE)
		
		ib_managedata = FALSE
		cb_3.TEXT = '작업할폴더 일괄선택'
		dw_list.uf_dataobject ('d_notice_file_list3', FALSE)
END CHOOSE

RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_notice_file
end type

type st_count from wt_list`st_count within w_notice_file
end type

type dw_list from wt_list`dw_list within w_notice_file
string dataobject = "d_notice_file_list"
string setlist4fontpointcolor = "compression=1=e"
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_list::retrieveend;call super::retrieveend;STRING	ls_result

LONG	ll

CHOOSE CASE dw_list.dataobject
	CASE 'd_notice_file_list', 'd_notice_file_list2'
		f_loadingrd (TRUE)
		ls_result = ''
		FOR ll = 1 TO rowcount
			IF dw_list.object.status [ll]='4'	THEN CONTINUE //공지글이 삭제된 경우 패스 - DB삭제 선행
			IF f_server_file_exist (dw_list.object.file_name [ll], dw_list.object.server_path [ll])	Then
				dw_list.object.status [ll] = '1'
			Else
				dw_list.object.status [ll] = '2'
			End IF
			dw_list.setitemstatus (ll, 0, primary!, notmodified!)
		NEXT
		dw_list.selectrow (0, FALSE)
		f_loadingrd (FALSE)
End CHOOSE
end event

event dw_list::doubleclicked;call super::doubleclicked;STRING	ls_org_filename, ls_mod_filename, ls_filepath, ls_filename, ls_board_no, ls_server_path
STRING	ls_compression

LONG	ll_docu_no, ll_attach_seq

fw_n_httpfile lnv_http

CHOOSE CASE dw_list.dataobject
	CASE 'd_notice_file_list'
		
		ls_org_filename	= dw_list.getitemstring(row, 'org_file_name')
		ls_mod_filename   = dw_list.getitemstring(row, 'file_name')
		ls_board_no       = dw_list.getitemstring(row, 'board_no')
		ll_docu_no        = dw_list.getitemnumber(row, 'docu_no')
		ll_attach_seq     = dw_list.getitemnumber(row, 'attach_seq')
		ls_server_path    = dw_list.getitemstring(row, 'server_path')
		ls_compression    = dw_list.getitemstring(row, 'compression')
		
		ls_filepath = gnv_extfunc.of_getsystemtemppath() + ls_org_filename
		ls_filename = ls_org_filename
		
		lnv_http = CREATE fw_n_httpfile
		
		IF ls_compression='1'	THEN ls_filepath += '.zip'
		IF lnv_http.of_filedownload(ls_org_filename + '|' + ls_mod_filename, ls_server_path, ls_filepath)<0 Then
			Messagebox('Check', 'file download fail')
			RETURN -1
		End IF
		
		DESTROY lnv_http
		
		IF ls_compression='1'	Then
			ls_org_filename = MID (ls_filepath, 1, LASTPOS (ls_filepath, '\'))
			mo_.mipo_unzip (ls_filepath, ls_org_filename)
			filedelete (ls_filepath)
			ls_filepath = MID (ls_filepath, 1, LEN (ls_filepath) - 4)
		End IF
		
		gnv_extfunc.of_shellexecute(ls_filepath)
End CHOOSE
end event

type cb_2 from pf_u_commandbutton within w_notice_file
integer x = 1824
integer y = 192
integer width = 471
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "선택파일삭제"
end type

event clicked;call super::clicked;STRING	ls_rm_script

LONG	ll_row

CHOOSE CASE dw_list.dataobject
   CASE 'd_notice_file_list2'
      ll_row = dw_list.getselectedrow (0)
      DO WHILE ll_row>0
			IF f_server_file_delete (dw_list.object.file_name [ll_row], dw_list.object.server_path [ll_row])	Then
				dw_list.object.status [ll_row] = 'S'
			Else
				dw_list.object.status [ll_row] = 'F'
			End IF
         dw_list.selectRow (ll_row, FALSE)
         ll_row = dw_list.getselectedrow (ll_row)
      LOOP
   CASE 'd_notice_file_list3'
		ls_rm_script = 'rm -rf'
      ll_row = dw_list.getselectedrow (0)
      DO WHILE ll_row>0
			ls_rm_script += " '" + string (f_replace (dw_list.object.server_path [ll_row], '/notice/', '')) + "'"
         dw_list.selectRow (ll_row, FALSE)
         ll_row = dw_list.getselectedrow (ll_row)
		LOOP
		::CLIPBOARD (ls_rm_script)
		messageBox ('INFO', '삭제스크립트가 클립보드에 복사되었습니다.~r~n하위폴더도 모두 삭제되므로 주의하시기 바랍니다.', stopsign!)
END CHOOSE
end event

type cb_3 from pf_u_commandbutton within w_notice_file
integer x = 1184
integer y = 192
integer width = 635
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "작업할파일 일괄선택"
end type

event clicked;call super::clicked;LONG	ll

dw_list.selectRow (0, FALSE)

CHOOSE CASE dw_list.dataobject
	CASE 'd_notice_file_list'
		// 공지글이 사라졌거나 서버에 파일이 없는 경우 DB에서 삭제
		FOR ll = 1 TO dw_list.rowcount()
			IF dw_list.object.status [ll]='4' OR dw_list.object.status [ll]='2'	THEN dw_list.selectRow (ll, TRUE)
		NEXT
	CASE 'd_notice_file_list2'
		//파일이 존재하면 체크
		FOR ll = 1 TO dw_list.rowcount()
			IF dw_list.object.status [ll]='1'	THEN dw_list.selectRow (ll, TRUE)
		NEXT
	CASE 'd_notice_file_list3'
		//디렉토리내의 파일이 전부삭제되면 체크
		FOR ll = 1 TO dw_list.rowcount()
			IF dw_list.object.exist [ll]='0'	THEN dw_list.selectRow (ll, TRUE)
		NEXT
END CHOOSE
end event

