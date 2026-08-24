forward
global type w_wdddwctl_manage from wt_listshare
end type
end forward

global type w_wdddwctl_manage from wt_listshare
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
end type
global w_wdddwctl_manage w_wdddwctl_manage

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ()
end event

on w_wdddwctl_manage.create
int iCurrent
call super::create
end on

on w_wdddwctl_manage.destroy
call super::destroy
end on

type lb_dirlist from wt_listshare`lb_dirlist within w_wdddwctl_manage
end type

type ln_templeft from wt_listshare`ln_templeft within w_wdddwctl_manage
end type

type ln_tempbuttom from wt_listshare`ln_tempbuttom within w_wdddwctl_manage
end type

type ln_temptop from wt_listshare`ln_temptop within w_wdddwctl_manage
end type

type ln_tempbutton from wt_listshare`ln_tempbutton within w_wdddwctl_manage
end type

type ln_tempstart from wt_listshare`ln_tempstart within w_wdddwctl_manage
end type

type ln_cond1_yline from wt_listshare`ln_cond1_yline within w_wdddwctl_manage
end type

type ln_dw1_yline from wt_listshare`ln_dw1_yline within w_wdddwctl_manage
end type

type ln_cond2_yline from wt_listshare`ln_cond2_yline within w_wdddwctl_manage
end type

type ln_dw2_yline from wt_listshare`ln_dw2_yline within w_wdddwctl_manage
end type

type ln_tempright from wt_listshare`ln_tempright within w_wdddwctl_manage
end type

type uo_navi from wt_listshare`uo_navi within w_wdddwctl_manage
end type

type ln_temptop_shadow from wt_listshare`ln_temptop_shadow within w_wdddwctl_manage
end type

type st_windelaytime from wt_listshare`st_windelaytime within w_wdddwctl_manage
end type

type p_close from wt_listshare`p_close within w_wdddwctl_manage
end type

type p_excel from wt_listshare`p_excel within w_wdddwctl_manage
end type

type p_print from wt_listshare`p_print within w_wdddwctl_manage
end type

type p_delete from wt_listshare`p_delete within w_wdddwctl_manage
end type

type p_update from wt_listshare`p_update within w_wdddwctl_manage
end type

type p_input from wt_listshare`p_input within w_wdddwctl_manage
end type

type p_retrieve from wt_listshare`p_retrieve within w_wdddwctl_manage
end type

type p_clear from wt_listshare`p_clear within w_wdddwctl_manage
end type

type p_copy from wt_listshare`p_copy within w_wdddwctl_manage
end type

type dw_c from wt_listshare`dw_c within w_wdddwctl_manage
boolean visible = false
end type

type btn_update from wt_listshare`btn_update within w_wdddwctl_manage
end type

type st_count from wt_listshare`st_count within w_wdddwctl_manage
end type

type dw_list from wt_listshare`dw_list within w_wdddwctl_manage
integer y = 156
integer height = 2608
string dataobject = "d_wdddwctl_manage_list"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;POST SetColumn ('sql_remark')
RETURN 0
end event

event dw_list::itemchanged_next;call super::itemchanged_next;setcolumn (name)
settext (TRIM (::clipboard ()))
end event

event dw_list::itemchanged;STRING	ls_syntax

LONG	ll_rtn

ads_jTier ids_syntax

CHOOSE CASE dwo.name
   CASE 'sql_where'
      IF f_notnull (data)  Then
	      ls_syntax = 'SELECT~t' + Object.sql_columns [row] + '~r~nFROM~t' + Object.sql_tables [row] + '~r~nWHERE~t' + data
         ll_rtn = SQLCA.sql2ds (parent.classname(), ls_syntax, ids_syntax, 'xml')
			IF	ll_rtn<0	Then
				::clipboard (data)
				uf_itemerr (row, dwo.name, 'item_before')
				post event itemchanged_next (row, dwo.name)
				RETURN 1
         End IF
      End IF
END CHOOSE
end event

type dw_master from wt_listshare`dw_master within w_wdddwctl_manage
integer x = 2592
integer y = 1408
integer width = 2679
integer height = 1212
string dataobject = "d_wdddwctl_manage_detail"
end type

event dw_master::doubleclicked;call super::doubleclicked;STRING   ls_sql

IF dwo.name='sql_where' Then
   ls_sql = 'SELECT~t' + Object.sql_columns [row] + '~r~nFROM~t' + Object.sql_tables [row]
   IF f_nvl (Object.sql_where [row],'')<>'' THEN ls_sql += '~r~nWHERE~t' + Object.sql_where [row]
   ::clipboard (ls_sql)
   gw_mdi.setmicrohelp ('SQL COPY')
End IF
end event

event dw_master::itemchanged;call super::itemchanged;STRING	ls_syntax

LONG	ll_rtn

ads_jTier ids_syntax

CHOOSE CASE dwo.name
   CASE 'sql_where'
      IF f_notnull (data)  Then
	      ls_syntax = 'SELECT~t' + Object.sql_columns [row] + '~r~nFROM~t' + Object.sql_tables [row] + '~r~nWHERE~t' + data
         ll_rtn = SQLCA.sql2ds (parent.classname(), ls_syntax, ids_syntax, 'xml')
			IF	ll_rtn<0	Then
				::clipboard (data)
				uf_itemerr (row, dwo.name, 'item_before')
				post event itemchanged_next (row, dwo.name)
				RETURN 1
         End IF
      End IF
END CHOOSE
end event

