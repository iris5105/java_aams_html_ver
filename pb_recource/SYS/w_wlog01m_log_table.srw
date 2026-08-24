forward
global type w_wlog01m_log_table from wt_list
end type
type cb_2 from pf_u_commandbutton within w_wlog01m_log_table
end type
end forward

global type w_wlog01m_log_table from wt_list
boolean eb_direct_retrieve = true
cb_2 cb_2
end type
global w_wlog01m_log_table w_wlog01m_log_table

on w_wlog01m_log_table.create
int iCurrent
call super::create
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_wlog01m_log_table.destroy
call super::destroy
destroy(this.cb_2)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr)
end event

event open;icmdbutton = { cb_2 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_wlog01m_log_table
end type

type ln_templeft from wt_list`ln_templeft within w_wlog01m_log_table
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_wlog01m_log_table
end type

type ln_temptop from wt_list`ln_temptop within w_wlog01m_log_table
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_wlog01m_log_table
end type

type ln_tempstart from wt_list`ln_tempstart within w_wlog01m_log_table
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_wlog01m_log_table
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_wlog01m_log_table
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_wlog01m_log_table
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_wlog01m_log_table
end type

type ln_tempright from wt_list`ln_tempright within w_wlog01m_log_table
end type

type uo_navi from wt_list`uo_navi within w_wlog01m_log_table
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_wlog01m_log_table
end type

type st_windelaytime from wt_list`st_windelaytime within w_wlog01m_log_table
end type

type p_close from wt_list`p_close within w_wlog01m_log_table
end type

type p_excel from wt_list`p_excel within w_wlog01m_log_table
end type

type p_print from wt_list`p_print within w_wlog01m_log_table
end type

type p_delete from wt_list`p_delete within w_wlog01m_log_table
end type

type p_update from wt_list`p_update within w_wlog01m_log_table
end type

type p_input from wt_list`p_input within w_wlog01m_log_table
end type

type p_retrieve from wt_list`p_retrieve within w_wlog01m_log_table
end type

type p_clear from wt_list`p_clear within w_wlog01m_log_table
end type

type p_copy from wt_list`p_copy within w_wlog01m_log_table
end type

type dw_c from wt_list`dw_c within w_wlog01m_log_table
boolean visible = false
boolean enabled = false
boolean applydesign = false
end type

type btn_update from wt_list`btn_update within w_wlog01m_log_table
end type

type st_count from wt_list`st_count within w_wlog01m_log_table
end type

type dw_list from wt_list`dw_list within w_wlog01m_log_table
integer y = 156
integer height = 2608
string dataobject = "d_wlog01m_log_table"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_SetColumn ('insert_yn', 'N')
uf_SetColumn ('update_yn', 'N')
uf_SetColumn ('delete_yn', 'N')

POST SetColumn ('table_id')

RETURN 0
end event

event dw_list::doubleclicked;LONG	ll

STRING	ls_yn

CHOOSE CASE dwo.name
	CASE 'insert_yn_t'
		ls_yn = IIF (f_nvl(Object.insert_yn [1],'N')='N','Y','N')
		FOR  ll = 1  TO  rowcount ()
			Object.insert_yn [ll] = ls_yn
		NEXT
	CASE 'update_yn_t'
		ls_yn = IIF (f_nvl(Object.update_yn [1],'N')='N','Y','N')
		FOR  ll = 1  TO  rowcount ()
			Object.update_yn [ll] = ls_yn
		NEXT
	CASE 'delete_yn_t'
		ls_yn = IIF (f_nvl(Object.delete_yn [1],'N')='N','Y','N')
		FOR  ll = 1  TO  rowcount ()
			Object.delete_yn [ll] = ls_yn
		NEXT
END CHOOSE
end event

type cb_2 from pf_u_commandbutton within w_wlog01m_log_table
integer x = 2231
integer y = 16
integer width = 544
integer taborder = 30
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "Table 일괄삽입"
end type

event clicked;STRING	ls_table_id, ls_table_comment, ls_FindSyntax, ls_sqlsyntax

INT	lRow, lRowCount

LONG	lR, ll

aDS_jTier	lds_jtier

lRowCount = dw_List.rowcount ()

ls_sqlsyntax = "   SELECT  t1.table_name " &
             + "         , t2.comments " &
             + "   FROM    user_tables t1 " &
             + "         , user_tab_comments t2 " &
             + "   WHERE   t1.table_name = t2.table_name " &
             + "   ORDER BY  1 "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  ll = 1  TO  lR
   ls_table_id = lds_jtier.getitemstring (ll, 1)
   ls_table_comment   = lds_jtier.getitemstring (ll, 2)
	
	ls_FindSyntax = "table_id='" + ls_table_id + "'"
   lRow = dw_List.Find (ls_FindSyntax, 1, lRowCount)
   IF lRow>0 THEN CONTINUE

   lRow = dw_List.EVENT ue_insert (0)

   dw_List.object.table_id [lRow] = ls_table_id
   dw_List.object.xx_table_id [lRow] = ls_table_comment
NEXT

end event

