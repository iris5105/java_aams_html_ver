forward
global type w_wlog02t_log_list from wt_vertdetail
end type
end forward

global type w_wlog02t_log_list from wt_vertdetail
boolean eb_retrievewait = true
boolean ib_managedata = false
end type
global w_wlog02t_log_list w_wlog02t_log_list

event wue_lastopen;call super::wue_lastopen;dw_c.object.log_user [1] = '%'
dw_c.object.log_table [1] = '%'
dw_c.object.log_stime [1] = datetime(date (string (ToDay (),'yyyy.mm') + '.01') )
dw_c.object.log_etime [1] = datetime(date (string (ToDay (),'yyyy.mm.dd')) )
end event

event ue_wpage_modified;RETURN FALSE
end event

event wue_retrieve;call super::wue_retrieve;datawindowchild	ldwc

STRING	ls_name, ls_LogGB[]

dw_c.AcceptText()

IF dw_c.GetItemString(1, 'insert_yn')='Y' THEN ls_LogGB[1] = 'I'
IF dw_c.GetItemString(1, 'delete_yn')='Y' THEN ls_LogGB[upperbound(ls_LogGB) + 1] = 'D'
IF dw_c.GetItemString(1, 'update_yn')='Y' THEN ls_LogGB[upperbound(ls_LogGB) + 1] = 'U'
IF upperbound(ls_LogGB)<1  Then
   MessageBox ('작업 구분 확인', '선택된 작업구분이 없습니다. 확인하여 주십시요!')
   RETURN
End IF

dw_c.getchild ('log_user', ldwc)

ls_name = ldwc.getitemstring (ldwc.getrow(), 'dscr')

dw_list.retrieve (string(dw_c.object.log_stime [1],'yyyymmdd') + '000000', &
                        STRING	(dw_c.object.log_etime [1],'yyyymmdd') + '245959', &
                        IIF (dw_c.object.log_user[1]='%','%','%'+ls_name+'%'), ls_LogGB, dw_c.object.log_table [1] )

end event

on w_wlog02t_log_list.create
int iCurrent
call super::create
end on

on w_wlog02t_log_list.destroy
call super::destroy
end on

type lb_dirlist from wt_vertdetail`lb_dirlist within w_wlog02t_log_list
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_wlog02t_log_list
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_wlog02t_log_list
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_wlog02t_log_list
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_wlog02t_log_list
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_wlog02t_log_list
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_wlog02t_log_list
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_wlog02t_log_list
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_wlog02t_log_list
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_wlog02t_log_list
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_wlog02t_log_list
end type

type uo_navi from wt_vertdetail`uo_navi within w_wlog02t_log_list
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_wlog02t_log_list
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_wlog02t_log_list
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_wlog02t_log_list
end type

type p_close from wt_vertdetail`p_close within w_wlog02t_log_list
end type

type p_excel from wt_vertdetail`p_excel within w_wlog02t_log_list
end type

type p_print from wt_vertdetail`p_print within w_wlog02t_log_list
end type

type p_delete from wt_vertdetail`p_delete within w_wlog02t_log_list
end type

type p_update from wt_vertdetail`p_update within w_wlog02t_log_list
end type

type p_input from wt_vertdetail`p_input within w_wlog02t_log_list
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_wlog02t_log_list
end type

type p_clear from wt_vertdetail`p_clear within w_wlog02t_log_list
end type

type p_copy from wt_vertdetail`p_copy within w_wlog02t_log_list
end type

type dw_c from wt_vertdetail`dw_c within w_wlog02t_log_list
string dataobject = "d_get_database_log"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'log_user | user', '', '%,전체,', 1, '')
f_dddwctl (THIS, 'log_table', '', '%,전체,', 1, '')
end event

type btn_update from wt_vertdetail`btn_update within w_wlog02t_log_list
end type

type st_count from wt_vertdetail`st_count within w_wlog02t_log_list
end type

type dw_list from wt_vertdetail`dw_list within w_wlog02t_log_list
string title = "테이블로그"
string dataobject = "d_wlog02t_table_log_list"
string is_resize_column = "table_nm"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'corp_gr', '', '', 1, '')
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;IF getcolumnname() = 'corp_gr' Then
	rs_addrow="%,전체,"
End IF

RETURN 1
end event

type dw_detail from wt_vertdetail`dw_detail within w_wlog02t_log_list
string title = "컬럼로그"
string dataobject = "d_wlog02t_log_list"
string islist4subbtnauth = "0010000000"
string is_resize_column = "old_data"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.corp_gr [iRow], dw_list.object.log_ymdt [iRow], dw_list.object.log_user [iRow], dw_list.object.log_gb [iRow], &
            dw_list.object.table_id [iRow], dw_list.object.serial_no [iRow] )
end event

type st_move from wt_vertdetail`st_move within w_wlog02t_log_list
end type

