forward
global type fw_w_notice_check from wt_tabvert
end type
type tabpage_1 from fw_u_notice_check_t1 within tab_subpage
end type
type tabpage_1 from fw_u_notice_check_t1 within tab_subpage
end type
type tabpage_2 from fw_u_notice_check_t2 within tab_subpage
end type
type tabpage_2 from fw_u_notice_check_t2 within tab_subpage
end type
end forward

global type fw_w_notice_check from wt_tabvert
boolean eb_direct_retrieve = true
boolean ib_managedata = false
end type
global fw_w_notice_check fw_w_notice_check

type variables
ads_jTier ids_board_mst
STRING	is_board_no, is_corp_gr
end variables

on fw_w_notice_check.create
int iCurrent
call super::create
end on

on fw_w_notice_check.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;ids_board_mst = CREATE ads_jTier
ids_board_mst.dataobject = 'fw_d_notice_ds1'
ids_board_mst.settransobject(SQLCA)
end event

event wue_retrieve;call super::wue_retrieve;Datetime ld_from_dt, ld_to_dt

STRING	ls_docu_title

ld_from_dt     = datetime(date (string (dw_c.object.fymd [1])), time('00:00:00'))
ld_to_dt       = datetime(date (string (dw_c.object.tymd [1])), time('23:59:59'))
ls_docu_title  = dw_c.object.docu_title [1]

Choose CASE inv_menu.is_parameter1
   CASE '01','03','11'
		is_corp_gr = iif (gaa.aams, '%', gaa.corp_gr)
   CASE '02'
		is_corp_gr = iif (gaa.aams, '2200', gaa.corp_gr)
End Choose

IF isnull(ls_docu_title) or len(ls_docu_title)=0   Then
   ls_docu_title = '%'
else
   ls_docu_title = '%' + ls_docu_title + '%'
End IF

dw_list.retrieve (gnv_vari.is_sys_id,is_corp_gr, is_board_no, ld_from_dt, ld_to_dt, ls_docu_title)
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw (dw_list, 'writer_name', {gnv_vari.is_sys_id, gaa.corp_gr})
fw_f_setdddw (dw_c, 'board_no', {gnv_vari.is_sys_id})
end event

event wue_lastopen;call super::wue_lastopen;DATE   ld_now, ld_fr, ld_to

dw_c.insertrow (0)

// 전체 공지사항 / 부서공지사항 자동 세팅
Choose CASE inv_menu.is_parameter1
   CASE '01'
      is_board_no = '0000001'
   CASE '02'
      is_board_no = '0000002'
   CASE '03'
      is_board_no = '0000003'
   CASE '11'
      is_board_no = '0000011'
End Choose
dw_c.object.board_no [1] = is_board_no

// 게시 시작일, 종료일 설정
ld_now = date(fw_f_getymdhh24miss4d())
ld_fr = relativedate(ld_now, -365)
ld_to = relativedate(ld_now, +365)

dw_c.object.fymd [1] = datetime (ld_fr)
dw_c.object.tymd [1] = datetime (ld_to)
end event

type lb_dirlist from wt_tabvert`lb_dirlist within fw_w_notice_check
end type

type ln_templeft from wt_tabvert`ln_templeft within fw_w_notice_check
end type

type ln_tempbuttom from wt_tabvert`ln_tempbuttom within fw_w_notice_check
end type

type ln_temptop from wt_tabvert`ln_temptop within fw_w_notice_check
end type

type ln_tempbutton from wt_tabvert`ln_tempbutton within fw_w_notice_check
end type

type ln_tempstart from wt_tabvert`ln_tempstart within fw_w_notice_check
end type

type ln_cond1_yline from wt_tabvert`ln_cond1_yline within fw_w_notice_check
end type

type ln_dw1_yline from wt_tabvert`ln_dw1_yline within fw_w_notice_check
end type

type ln_cond2_yline from wt_tabvert`ln_cond2_yline within fw_w_notice_check
end type

type ln_dw2_yline from wt_tabvert`ln_dw2_yline within fw_w_notice_check
end type

type ln_tempright from wt_tabvert`ln_tempright within fw_w_notice_check
end type

type uo_navi from wt_tabvert`uo_navi within fw_w_notice_check
end type

type ln_temptop_shadow from wt_tabvert`ln_temptop_shadow within fw_w_notice_check
end type

type st_windelaytime from wt_tabvert`st_windelaytime within fw_w_notice_check
end type

type p_close from wt_tabvert`p_close within fw_w_notice_check
end type

type p_excel from wt_tabvert`p_excel within fw_w_notice_check
end type

type p_print from wt_tabvert`p_print within fw_w_notice_check
end type

type p_delete from wt_tabvert`p_delete within fw_w_notice_check
end type

type p_update from wt_tabvert`p_update within fw_w_notice_check
end type

type p_input from wt_tabvert`p_input within fw_w_notice_check
end type

type p_retrieve from wt_tabvert`p_retrieve within fw_w_notice_check
end type

type p_clear from wt_tabvert`p_clear within fw_w_notice_check
end type

type p_copy from wt_tabvert`p_copy within fw_w_notice_check
end type

type dw_c from wt_tabvert`dw_c within fw_w_notice_check
integer height = 272
string dataobject = "fw_d_board_doc_check_01"
end type

event dw_c::itemchanged;call super::itemchanged;STRING	ls_log_yn

choose CASE string(dwo.name)
   CASE 'board_no'
      is_board_no = data
      IF ids_board_mst.retrieve (gnv_vari.is_sys_id, is_board_no)>0  Then
         ls_log_yn = ids_board_mst.object.make_log_yn [1]
         IF isnull(ls_log_yn) Then ls_log_yn = 'N'
         IF ls_log_yn<>'Y' Then
            messagebox('알림', '선택하신 게시판(Board)은 로그생성을 하지않기 때문에 조회자를 확인할 수 없습니다')
            RETURN
         End IF
      End IF
end choose
end event

type btn_update from wt_tabvert`btn_update within fw_w_notice_check
end type

type tab_subpage from wt_tabvert`tab_subpage within fw_w_notice_check
integer y = 456
integer height = 2308
integer textsize = -10
string facename = "맑은 고딕"
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type dw_list from wt_tabvert`dw_list within fw_w_notice_check
integer y = 456
integer height = 2308
string title = "공지사항 리스트"
string dataobject = "fw_d_board_doc_check_02"
end type

type uo_tab from wt_tabvert`uo_tab within fw_w_notice_check
end type

type st_tab_move from wt_tabvert`st_tab_move within fw_w_notice_check
integer y = 456
integer height = 2308
end type

type tabpage_1 from fw_u_notice_check_t1 within tab_subpage
integer x = 18
integer y = 116
integer width = 3049
integer height = 2176
string text = "열람자"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then

   STRING	ls_sys_id, ls_board_no, ls_memb_type, ls_role_no

   LONG	ll_docu_no

   ls_sys_id    = dw_list.Object.sys_id [iRow]
   ls_board_no  = dw_list.Object.board_no [iRow]
   ll_docu_no   = dw_list.Object.docu_no [iRow]
   ls_memb_type = dw_list.Object.memb_type [iRow]
   ls_role_no   = dw_list.Object.role_no [iRow]
	
   dw_pagelist.retrieve (ls_sys_id, is_corp_gr, ls_board_no, ll_docu_no)
End IF
RETURN 1
end event

type tabpage_2 from fw_u_notice_check_t2 within tab_subpage
integer x = 18
integer y = 116
integer width = 3049
integer height = 2176
string text = "미열람자"
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then
   // 공지사항 미 열람자 조회
   STRING	ls_select, ls_innerselect, ls_sys_id, ls_board_no, ls_memb_type, ls_role_no

   LONG	ll_docu_no

   ls_sys_id    = dw_list.Object.sys_id [iRow]
   ls_board_no  = dw_list.Object.board_no [iRow]
   ll_docu_no   = dw_list.Object.docu_no [iRow]
   ls_memb_type = dw_list.Object.memb_type [iRow]
   ls_role_no   = dw_list.Object.role_no [iRow]

   dw_pagelist.retrieve (gnv_vari.is_sys_id, is_corp_gr, ls_board_no, ll_docu_no)
End IF
RETURN 1
end event

