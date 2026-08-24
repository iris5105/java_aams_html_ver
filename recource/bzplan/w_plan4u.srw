forward
global type w_plan4u from wt_list
end type
end forward

global type w_plan4u from wt_list
boolean confirmsheetbackcolor = false
boolean eb_direct_retrieve = true
boolean ib_managedata = false
end type
global w_plan4u w_plan4u

on w_plan4u.create
int iCurrent
call super::create
end on

on w_plan4u.destroy
call super::destroy
end on

event wue_postopen;call super::wue_postopen;dw_c.object.ym [1] = string (idt_workdate,'yyyymm')
end event

event wue_retrieve;call super::wue_retrieve;STRING	ls_ymd

LONG	ll_ret

ls_ymd = dw_c.object.ym [1]
ls_ymd = fw_f_replaceall(ls_ymd, '.', '')
If fw_f_nvls(ls_ymd, '') = '' Then
	Messagebox('Check', '년월을 확인 하십시요')
End If

ll_ret = dw_list.retrieve(iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_sys_id, ls_ymd, 'all')

If ll_ret = 0 Then Messagebox('Check', '달력생성을 확인해 주십시요')
end event

type ln_templeft from wt_list`ln_templeft within w_plan4u
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_plan4u
end type

type ln_temptop from wt_list`ln_temptop within w_plan4u
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_plan4u
end type

type ln_tempstart from wt_list`ln_tempstart within w_plan4u
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_plan4u
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_plan4u
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_plan4u
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_plan4u
end type

type ln_tempright from wt_list`ln_tempright within w_plan4u
end type

type uo_navi from wt_list`uo_navi within w_plan4u
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_plan4u
end type

type st_windelaytime from wt_list`st_windelaytime within w_plan4u
end type

type p_close from wt_list`p_close within w_plan4u
end type

type p_excel from wt_list`p_excel within w_plan4u
end type

type p_print from wt_list`p_print within w_plan4u
end type

type p_delete from wt_list`p_delete within w_plan4u
end type

type p_update from wt_list`p_update within w_plan4u
end type

type p_input from wt_list`p_input within w_plan4u
end type

type p_retrieve from wt_list`p_retrieve within w_plan4u
end type

type p_clear from wt_list`p_clear within w_plan4u
end type

type p_copy from wt_list`p_copy within w_plan4u
end type

type dw_c from wt_list`dw_c within w_plan4u
string title = "영업년월"
string dataobject = "dc_dddw_ym"
end type

type btn_update from wt_list`btn_update within w_plan4u
end type

type dw_list from wt_list`dw_list within w_plan4u
integer taborder = 30
string dataobject = "d_plan4u_1"
boolean ibdesign4role = false
boolean ibsetlist4singleselect = false
end type

event dw_list::doubleclicked;call super::doubleclicked;IF row<1 or gaa.admin=FALSE	THEN RETURN

dw_list.AcceptText()

STRING	ls_obj, ls_objtype

fw_s_home	lstr_home

ls_obj		= fw_f_nvls(lower(dwo.name), 'datawindow')
If ls_obj	= 'datawindow' Then Return
ls_objtype	= This.describe(ls_obj + ".Type")
If Not(ls_objtype = 'column') Then Return

lstr_home.w_obj	= iw_parent
lstr_home.dw_obj	= This
lstr_home.dwo_col	= dwo
lstr_home.row		= row

ls_obj = left(dwo.name, 3) + '_ymd'
lstr_home.ymd		= This.GetItemString(row, ls_obj)
lstr_home.str[1]  = 'all'

If fw_f_nvls(lstr_home.ymd, '') = '' Then Return

OpenWithParm(w_plan4u_pop, lstr_home)
IF message.stringparm='save' THEN event wue_retrieve()
end event

