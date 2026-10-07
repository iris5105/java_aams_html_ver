forward
global type w_planuser from wt_list
end type
end forward

global type w_planuser from wt_list
boolean confirmsheetbackcolor = false
boolean eb_direct_retrieve = true
boolean ib_managedata = false
end type
global w_planuser w_planuser

type variables
ads_jTier	ids_scheduler_data
ads_jTier	ids_scheduler_calendar

end variables

forward prototypes
public subroutine of_schedule_retrieve (datawindow adw_current, long row)
public subroutine of_gyulje_retrieve ()
public subroutine of_bringtotop (boolean ab_value)
end prototypes

public subroutine of_schedule_retrieve (datawindow adw_current, long row);//Schedule Retrieve Function
Date		ld_date
String		ls_date
String		ls_description, ls_importance, ls_daytype
Long		ll_ret

ld_date = adw_current.getITemDate(row, 'ldtoday')
ls_date = string(ld_date,'yyyymmdd')

//implement			
ids_scheduler_data.SetTransObject( sqlca )
ll_ret = ids_scheduler_data.retrieve(gnv_vari.is_user_id, ls_date)

Choose Case ll_ret
	Case 0
		adw_current.SetItem(row, 'schedule', '')
		adw_current.SetItem(row, 'importance', '')
	Case 1
		ls_description	= ids_scheduler_data.GetItemString(1, 'description')
		ls_description	= fw_f_replaceall(ls_description, ';', '~r~n')
		ls_importance	= ids_scheduler_data.GetItemString(1, 'importance')
		If fw_f_nvls(ls_importance, '') = '' Then ls_importance = '1'
		adw_current.SetItem(row, 'schedule', ls_description)
		adw_current.SetItem(row, 'importance', ls_importance)
End Choose

ids_scheduler_calendar.SetTransObject( sqlca )
ll_ret = ids_scheduler_calendar.retrieve(ls_date)
Choose Case ll_ret
	Case 0
		adw_current.SetItem(row, 'day_type', '')
	Case 1
		ls_daytype = ids_scheduler_calendar.GetItemString(1, 'day_type')
		adw_current.SetItem(row, 'day_type', ls_daytype)
End Choose
end subroutine

public subroutine of_gyulje_retrieve ();//Long		ll_cnt1, ll_cnt2, ll_cnt3, ll_cnt4
//Long		ll_cntreceive, ll_cntnoaccept
//
////결재예정
//select trim(to_char(nvl(count(*),0),'99,999')) Into :ll_cnt1
//   from sanc_proc_ready
// where user_id = :gnv_vari.is_user_id ;
//
//dw_1.setItem(1, 'cnt1', ll_cnt1)
//
////미결
//select trim(to_char(nvl(count(*),0),'99,999')) Into :ll_cnt2
//   from sanc_proc_arrive
// where user_id = :gnv_vari.is_user_id ;
//
//dw_1.setItem(1, 'cnt2', ll_cnt2)
//
////결재진행
//select trim(to_char(nvl(count(*),0), '99,999')) Into :ll_cnt3
//   from sanc_proc_doing
// where user_id = :gnv_vari.is_user_id ;
//
//dw_1.setItem(1, 'cnt3', ll_cnt3)
//
////결재완료
//select trim(to_char(nvl(count(*),0),'99,999')) Into :ll_cnt4
//   from sanc_proc_done
// where user_id = :gnv_vari.is_user_id ;
//
//dw_1.setItem(1, 'cnt4', ll_cnt4)
//
////수신대장
//select nvl(count(*),0) Into :ll_cntreceive
//   from sanc_proc_accept
// where dept_id = :gnv_vari.is_dept_code ;
//
//dw_1.setItem(1, 'cntreceive', ll_cntreceive)
//
// //미열람
//select nvl(count(*),0) Into :ll_cntnoaccept
//   from sanc_pass_receive a,
//        sanc_pass_receive_user b,
//        sanc_pass_send c,
//        sanc_doc_master d
//  where a.pass_id = b.pass_id
//    and a.pass_id = c.pass_id
//    and c.doc_id = d.doc_id
//    and a.receive_user_id = b.user_id
//    and a.receive_user_id = :gnv_vari.is_user_id
//    and a.receive_date is null ;
//
//dw_1.setItem(1, 'cntnoaccept', ll_cntnoaccept)
end subroutine

public subroutine of_bringtotop (boolean ab_value);this.BringToTop = ab_value
end subroutine

on w_planuser.create
int iCurrent
call super::create
end on

on w_planuser.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;String		ls_ymd
Long		ll_ret

ls_ymd = dw_c.object.ym [1]
ls_ymd = fw_f_replaceall(ls_ymd, '.', '')
If fw_f_nvls(ls_ymd, '') = '' Then
	Messagebox('Check', '년월을 확인 하십시요')
End If

//ll_ret = dw_list.retrieve(gnv_vari.is_sys_id, ls_ymd, gnv_vari.is_user_id)
ll_ret = dw_list.retrieve(iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_sys_id, ls_ymd, gaa.login)

If ll_ret = 0 Then Messagebox('Check', '달력생성을 확인해 주십시요')
end event

event wue_postopen;call super::wue_postopen;dw_c.object.ym [1] = string (idt_workdate,'yyyymm')
end event

type lb_dirlist from wt_list`lb_dirlist within w_planuser
end type

type ln_templeft from wt_list`ln_templeft within w_planuser
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_planuser
end type

type ln_temptop from wt_list`ln_temptop within w_planuser
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_planuser
end type

type ln_tempstart from wt_list`ln_tempstart within w_planuser
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_planuser
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_planuser
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_planuser
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_planuser
end type

type ln_tempright from wt_list`ln_tempright within w_planuser
end type

type uo_navi from wt_list`uo_navi within w_planuser
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_planuser
end type

type st_windelaytime from wt_list`st_windelaytime within w_planuser
end type

type p_close from wt_list`p_close within w_planuser
end type

type p_excel from wt_list`p_excel within w_planuser
end type

type p_print from wt_list`p_print within w_planuser
end type

type p_delete from wt_list`p_delete within w_planuser
end type

type p_update from wt_list`p_update within w_planuser
end type

type p_input from wt_list`p_input within w_planuser
end type

type p_retrieve from wt_list`p_retrieve within w_planuser
end type

type p_clear from wt_list`p_clear within w_planuser
end type

type p_copy from wt_list`p_copy within w_planuser
end type

type dw_c from wt_list`dw_c within w_planuser
string title = "기준일자"
string dataobject = "dc_dddw_ym"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

type btn_update from wt_list`btn_update within w_planuser
end type

type st_count from wt_list`st_count within w_planuser
end type

type dw_list from wt_list`dw_list within w_planuser
integer taborder = 30
string dataobject = "d_planuser_1"
boolean ibdesign4role = false
boolean ibsetlist4singleselect = false
end type

event dw_list::doubleclicked;call super::doubleclicked;If row < 1 Then Return

dw_list.AcceptText()
String				ls_obj, ls_objtype
fw_s_home		lstr_home

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
lstr_home.str[1]  = gaa.login

If fw_f_nvls(lstr_home.ymd, '') = '' Then Return

//OpenWithParm(w_planuser_pop, lstr_home)
OpenWithParm(w_plan4u_pop, lstr_home)

IF message.stringparm='save' THEN event wue_retrieve()
//OpenWithParm(w_planuser_pop, lstr_home.ymd)
//w_planuser_pop.x = this.PointerX()
//w_planuser_pop.y = this.PointerY()

end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
object.update_user_id [row] = gnv_vari.is_user_id
Object.update_time [row] = f_sysdate ('')
end event

