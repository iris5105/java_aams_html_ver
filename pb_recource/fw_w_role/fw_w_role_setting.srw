forward
global type fw_w_role_setting from w_window1st5ncn
end type
type dw_role_cat_mst from fw_u_dwo within fw_w_role_setting
end type
end forward

global type fw_w_role_setting from w_window1st5ncn
string title = "권한유형관리"
dw_role_cat_mst dw_role_cat_mst
end type
global fw_w_role_setting fw_w_role_setting

on fw_w_role_setting.create
int iCurrent
call super::create
this.dw_role_cat_mst=create dw_role_cat_mst
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_role_cat_mst
end on

on fw_w_role_setting.destroy
call super::destroy
destroy(this.dw_role_cat_mst)
end on

event wue_postopen;call super::wue_postopen;Event wue_retrieve2ready()
end event

event wue_retrieve;call super::wue_retrieve;dw_role_cat_mst.retrieve(gnv_vari.is_sys_id)
end event

event wue_update;call super::wue_update;long	ll_row
string	ls_role_cat_no

ll_row = dw_role_cat_mst.getrow()
if ll_row > 0 then
	ls_role_cat_no = dw_role_cat_mst.getitemstring(ll_row, 'role_cat_no')
	OpenWithParm(fw_w_role_setting_config, '수정~t' + ls_role_cat_no)
	if message.stringparm = 'OK' then
		dw_role_cat_mst.retrieve(gnv_vari.is_sys_id)
	end if
end if

Return 0
end event

event wue_delete;long	ll_row
string	ls_role_cat_no, ls_role_cat_nm
string	ls_errtext

ll_row = dw_role_cat_mst.getrow()
if ll_row > 0 then
	ls_role_cat_no = dw_role_cat_mst.getitemstring(ll_row, 'role_cat_no')
	ls_role_cat_nm = dw_role_cat_mst.getitemstring(ll_row, 'role_cat_nm')
	if messagebox('Notice', '선택하신 ' + ls_role_cat_nm + '[' + ls_role_cat_no + '] 권한 카테고리를 삭제하시겠습니까?', Exclamation!, YesNo!, 2) = 1 then
		dw_role_cat_mst.deleterow(ll_row)
		if dw_role_cat_mst.update () = 1 then
			commitJ ()
			fw_f_message('U01', '', '')
		else
			ls_errtext = sqlca.sqlerrtext()
			rollbackJ ()
			messagebox('Notice', 'Role 정보 삭제 실패!!~r~n' + 'Error Text: ' + ls_errtext)
			return -1
		end if
	end if
end if

Return 1
end event

event wue_clear;call super::wue_clear;idw_u = dw_role_cat_mst
end event

event wue_input;OpenWithParm(fw_w_role_setting_config, '추가')
if message.stringparm = 'OK' then
	dw_role_cat_mst.retrieve(gnv_vari.is_sys_id)
end if
Return 1
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within fw_w_role_setting
end type

type ln_templeft from w_window1st5ncn`ln_templeft within fw_w_role_setting
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within fw_w_role_setting
end type

type ln_temptop from w_window1st5ncn`ln_temptop within fw_w_role_setting
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within fw_w_role_setting
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within fw_w_role_setting
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within fw_w_role_setting
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within fw_w_role_setting
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within fw_w_role_setting
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within fw_w_role_setting
end type

type ln_tempright from w_window1st5ncn`ln_tempright within fw_w_role_setting
end type

type uo_navi from w_window1st5ncn`uo_navi within fw_w_role_setting
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within fw_w_role_setting
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within fw_w_role_setting
end type

type p_close from w_window1st5ncn`p_close within fw_w_role_setting
end type

type p_excel from w_window1st5ncn`p_excel within fw_w_role_setting
end type

type p_print from w_window1st5ncn`p_print within fw_w_role_setting
end type

type p_delete from w_window1st5ncn`p_delete within fw_w_role_setting
end type

type p_update from w_window1st5ncn`p_update within fw_w_role_setting
end type

type p_input from w_window1st5ncn`p_input within fw_w_role_setting
end type

type p_retrieve from w_window1st5ncn`p_retrieve within fw_w_role_setting
end type

type p_clear from w_window1st5ncn`p_clear within fw_w_role_setting
end type

type dw_role_cat_mst from fw_u_dwo within fw_w_role_setting
integer x = 50
integer y = 156
integer width = 5381
integer height = 2612
integer taborder = 10
boolean bringtotop = true
string title = "Role 카테고리 리스트"
string dataobject = "fw_d_role_setting_1"
boolean hscrollbar = true
boolean hsplitscroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setedittoken = true
boolean ibsetlist4clearselect = true
end type

event doubleclicked;call super::doubleclicked;// 더블클릭 시 수정 윈도우 오픈
if row = 0 then return
Post Event wue_update()

end event

