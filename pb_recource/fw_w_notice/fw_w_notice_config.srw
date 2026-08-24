forward
global type fw_w_notice_config from w_window1st5ncn
end type
type dw_list from fw_u_dwo within fw_w_notice_config
end type
end forward

global type fw_w_notice_config from w_window1st5ncn
dw_list dw_list
end type
global fw_w_notice_config fw_w_notice_config

on fw_w_notice_config.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on fw_w_notice_config.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;dw_list.settransobject(sqlca)
dw_list.retrieve(gnv_vari.is_sys_id)
idw_u = dw_list
end event

event wue_update;call super::wue_update;IF dw_list.accepttext()=-1 THEN RETURN -1

// 필수입력사항 체크
STRING	ls_board_nm

ls_board_nm = dw_list.getitemstring(1, 'board_nm')
IF isnull(ls_board_nm) or len(TRIM(ls_board_nm))=0 Then
   messagebox('Notice', '보드 명칭을 입력하세요')
   RETURN -1
End IF

// Primary Key 생성
STRING	ls_board_no

LONG	ll_modified

ll_modified = dw_list.getnextmodified (0, primary!)
DO WHILE ll_modified > 0
   IF dw_list.getitemstatus(ll_modified, 0, primary!)=newmodified!	Then
      SELECT  max(board_no)
        INTO  :ls_board_no
      FROM    fw_board_mst
      WHERE   sys_id = :gnv_vari.is_sys_id;

		ls_board_no = SQLCA.getitemstring (1)

      IF isnull(ls_board_no) THEN ls_board_no = '0'
      ls_board_no = string(long(ls_board_no) + 1, '0000000')
      dw_list.setitem(ll_modified, 'sys_id', gnv_vari.is_sys_id)
      dw_list.setitem(ll_modified, 'board_no', ls_board_no)
   End IF

   ll_modified = dw_list.getnextmodified(ll_modified, primary!)
loop

if of_update({dw_list}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_delete;call super::wue_delete;long	ll_row
string	ls_board_no, ls_board_nm
string	ls_errtext

ll_row = dw_list.getrow()
if ll_row > 0 then
	ls_board_no = dw_list.getitemstring(ll_row, 'board_no')
	ls_board_nm = dw_list.getitemstring(ll_row, 'board_nm')
	if messagebox('Notice', '선택하신 ' + ls_board_nm + '[' + ls_board_no + '] 보드 기본정보를 삭제하시겠습니까?', Exclamation!, YesNo!, 2) = 1 then
		dw_list.deleterow(ll_row)
		if dw_list.update () = 1 then
			commitJ ()
			fw_f_message('D01', '', '')
		else
			ls_errtext = sqlca.sqlerrtext()
			rollbackJ ()
			messagebox('Notice', 'Role 정보 삭제 실패!!~r~n' + 'Error Text: ' + ls_errtext)
			return -1
		end if
	end if
end if
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_notice_config
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_notice_config
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_notice_config
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_notice_config
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_notice_config
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_notice_config
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_notice_config
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_notice_config
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_notice_config
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_notice_config
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_notice_config
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_notice_config
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_notice_config
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_notice_config
end type

type p_close from w_window1st5ncn`p_close within fw_w_notice_config
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_notice_config
end type

type p_print from w_window1st5ncn`p_print within fw_w_notice_config
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_notice_config
end type

type p_update from w_window1st5ncn`p_update within fw_w_notice_config
end type

type p_input from w_window1st5ncn`p_input within fw_w_notice_config
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_notice_config
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_notice_config
end type

type dw_list from fw_u_dwo within fw_w_notice_config
integer x = 50
integer y = 156
integer width = 5381
integer height = 2608
integer taborder = 10
boolean bringtotop = true
string title = "게시판(Board) 기본정보 리스트"
string dataobject = "fw_d_notice_config_1"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean setedittoken = true
end type

event retrieveend;call super::retrieveend;IF rowcount > 0 THEN uf_setrow (1, FALSE)
end event

