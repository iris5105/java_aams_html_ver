forward
global type w_wdcs01m_manage from wt_listshare
end type
end forward

global type w_wdcs01m_manage from wt_listshare
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
end type
global w_wdcs01m_manage w_wdcs01m_manage

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ()
end event

on w_wdcs01m_manage.create
int iCurrent
call super::create
end on

on w_wdcs01m_manage.destroy
call super::destroy
end on

type lb_dirlist from wt_listshare`lb_dirlist within w_wdcs01m_manage
end type

type ln_templeft from wt_listshare`ln_templeft within w_wdcs01m_manage
end type

type ln_tempbuttom from wt_listshare`ln_tempbuttom within w_wdcs01m_manage
end type

type ln_temptop from wt_listshare`ln_temptop within w_wdcs01m_manage
end type

type ln_tempbutton from wt_listshare`ln_tempbutton within w_wdcs01m_manage
end type

type ln_tempstart from wt_listshare`ln_tempstart within w_wdcs01m_manage
end type

type ln_cond1_yline from wt_listshare`ln_cond1_yline within w_wdcs01m_manage
end type

type ln_dw1_yline from wt_listshare`ln_dw1_yline within w_wdcs01m_manage
end type

type ln_cond2_yline from wt_listshare`ln_cond2_yline within w_wdcs01m_manage
end type

type ln_dw2_yline from wt_listshare`ln_dw2_yline within w_wdcs01m_manage
end type

type ln_tempright from wt_listshare`ln_tempright within w_wdcs01m_manage
end type

type uo_navi from wt_listshare`uo_navi within w_wdcs01m_manage
end type

type ln_temptop_shadow from wt_listshare`ln_temptop_shadow within w_wdcs01m_manage
end type

type st_windelaytime from wt_listshare`st_windelaytime within w_wdcs01m_manage
end type

type p_close from wt_listshare`p_close within w_wdcs01m_manage
end type

type p_excel from wt_listshare`p_excel within w_wdcs01m_manage
end type

type p_print from wt_listshare`p_print within w_wdcs01m_manage
end type

type p_delete from wt_listshare`p_delete within w_wdcs01m_manage
end type

type p_update from wt_listshare`p_update within w_wdcs01m_manage
end type

type p_input from wt_listshare`p_input within w_wdcs01m_manage
end type

type p_retrieve from wt_listshare`p_retrieve within w_wdcs01m_manage
end type

type p_clear from wt_listshare`p_clear within w_wdcs01m_manage
end type

type p_copy from wt_listshare`p_copy within w_wdcs01m_manage
end type

type dw_c from wt_listshare`dw_c within w_wdcs01m_manage
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_listshare`btn_update within w_wdcs01m_manage
end type

type st_count from wt_listshare`st_count within w_wdcs01m_manage
end type

type dw_list from wt_listshare`dw_list within w_wdcs01m_manage
integer y = 156
integer height = 2608
string dataobject = "d_wdcs01m_manage_list"
end type

event dw_list::itemchanged;STRING	ls_syntax

LONG	ll_rtn

ads_jTier ids_syntax

CHOOSE CASE dwo.name
   CASE 'code_select','edit_select'
      IF f_notnull (data)  Then
			ls_syntax = data
         IF POS (data,'p_corp_gr')>0 THEN ls_syntax = f_replace (ls_syntax,'p_corp_gr',"':corp_gr'")
         ll_rtn = SQLCA.sql2ds (parent.classname(), ls_syntax, ids_syntax, 'xml')
			IF	ll_rtn<0	Then
				::clipboard (ls_syntax)
				uf_itemerr (row, dwo.name, 'item_before')
				post event itemchanged_next (row, dwo.name)
				RETURN 1
         End IF
      End IF
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('column_size', '10:80')

POST SetColumn ('cmnt')

RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;LONG	ll

CHOOSE CASE dwo.name
	CASE 'code_select'
		FOR  ll = 1  TO  rowcount ()
			IF	POS (Object.code_select [ll],'~r~n')=0 And POS (Object.code_select [ll],'~n')>0	Then
				Object.code_select [ll] = f_replace (Object.code_select [ll],'~n','~r~n')
			End IF
		NEXT
	CASE 'edit_select'
		FOR  ll = 1  TO  rowcount ()
			IF	POS (Object.edit_select [ll],'~r~n')=0 And POS (Object.edit_select [ll],'~n')>0	Then
				Object.edit_select [ll] = f_replace (Object.edit_select [ll],'~n','~r~n')
			End IF
		NEXT
END CHOOSE
end event

event dw_list::itemchanged_next;call super::itemchanged_next;setcolumn (name)
settext (TRIM (::clipboard ()))
end event

type dw_master from wt_listshare`dw_master within w_wdcs01m_manage
integer x = 759
integer y = 756
integer width = 4302
integer height = 1872
string dataobject = "d_wdcs01m_manage_detail"
end type

event dw_master::itemchanged;STRING	ls_syntax

LONG	ll_rtn

ads_jTier ids_syntax

CHOOSE CASE dwo.name
   CASE 'code_select','edit_select'
      IF f_notnull (data)  Then
			ls_syntax = data
         IF POS (data,'p_corp_gr')>0 THEN ls_syntax = f_replace (ls_syntax,'p_corp_gr',"':corp_gr'")
         ll_rtn = SQLCA.sql2ds (parent.classname(), ls_syntax, ids_syntax, 'xml')
			IF	ll_rtn<0	Then
				::clipboard (ls_syntax)
				uf_itemerr (row, dwo.name, 'item_before')
				post event itemchanged_next (row, dwo.name)
				RETURN 1
         End IF
      End IF
END CHOOSE
end event

event dw_master::doubleclicked;call super::doubleclicked;STRING   ls_data

CHOOSE CASE dwo.name
   CASE 'code_select','edit_select'
      ls_data = dwo.primary [row]
      IF POS (ls_data,'~r~n')=0 THEN ls_data = f_replace (ls_data,'~n','~r~n')
      ::clipboard (ls_data)
END CHOOSE
end event

event dw_master::itemchanged_next;call super::itemchanged_next;setcolumn (name)
settext (TRIM (::clipboard ()))
end event

