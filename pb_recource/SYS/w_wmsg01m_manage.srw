forward
global type w_wmsg01m_manage from wt_list
end type
end forward

global type w_wmsg01m_manage from wt_list
boolean eb_direct_retrieve = true
end type
global w_wmsg01m_manage w_wmsg01m_manage

on w_wmsg01m_manage.create
int iCurrent
call super::create
end on

on w_wmsg01m_manage.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ()
end event

type ln_templeft from wt_list`ln_templeft within w_wmsg01m_manage
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_wmsg01m_manage
end type

type ln_temptop from wt_list`ln_temptop within w_wmsg01m_manage
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_wmsg01m_manage
end type

type ln_tempstart from wt_list`ln_tempstart within w_wmsg01m_manage
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_wmsg01m_manage
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_wmsg01m_manage
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_wmsg01m_manage
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_wmsg01m_manage
end type

type ln_tempright from wt_list`ln_tempright within w_wmsg01m_manage
end type

type uo_navi from wt_list`uo_navi within w_wmsg01m_manage
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_wmsg01m_manage
end type

type st_windelaytime from wt_list`st_windelaytime within w_wmsg01m_manage
end type

type p_close from wt_list`p_close within w_wmsg01m_manage
end type

type p_excel from wt_list`p_excel within w_wmsg01m_manage
end type

type p_print from wt_list`p_print within w_wmsg01m_manage
end type

type p_delete from wt_list`p_delete within w_wmsg01m_manage
end type

type p_update from wt_list`p_update within w_wmsg01m_manage
end type

type p_input from wt_list`p_input within w_wmsg01m_manage
end type

type p_retrieve from wt_list`p_retrieve within w_wmsg01m_manage
end type

type p_clear from wt_list`p_clear within w_wmsg01m_manage
end type

type p_copy from wt_list`p_copy within w_wmsg01m_manage
end type

type dw_c from wt_list`dw_c within w_wmsg01m_manage
boolean visible = false
boolean enabled = false
boolean scaletoright = false
boolean applydesign = false
boolean useborder = false
end type

type btn_update from wt_list`btn_update within w_wmsg01m_manage
end type

type dw_list from wt_list`dw_list within w_wmsg01m_manage
integer y = 156
integer height = 2608
string dataobject = "d_wmsg01m_manage_list"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;POST SetColumn ('id')
RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;LONG	ll

IF	dwo.name='text'	Then
	FOR  ll = 1  TO  rowcount ()
		IF	POS (Object.text [ll],'~r~n')=0 And POS (Object.text [ll],'~n')>0	Then
			Object.text [ll] = f_replace (Object.text [ll],'~n','~r~n')
		End IF
	NEXT
End IF
end event

