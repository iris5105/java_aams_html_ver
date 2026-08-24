forward
global type w_ja020f from wt_list
end type
end forward

global type w_ja020f from wt_list
boolean eb_retrievewait = true
string is_init_value = "%@전체"
boolean ib_managedata = false
end type
global w_ja020f w_ja020f

on w_ja020f.create
int iCurrent
call super::create
end on

on w_ja020f.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;IF dw_c.object.ymd [1]>idt_workdate THEN dw_c.object.ymd [1] = idt_workdate
ia_value [1] = dw_c.object.rcd [1]
ia_value [2] = dw_c.object.xx_rcd [1]
dw_list.retrieve (gaa.corp_gr, iif (gaa.aams,'%',gaa.corp_gr), string (dw_c.object.ymd [1],'yyyymmdd'), ia_value [1])
rollbackJ ()
end event

event wue_postopen;call super::wue_postopen;STRING	ls_value, la_value []

RegistryGet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", RegString!, ls_value)

IF LEFT (ls_value,7)<>'SJUE200'  Then
   dw_c.object.ymd [1] = idt_workdate
   dw_c.object.rcd [1] = ia_value [1]
   dw_c.object.xx_rcd [1] = ia_value [2]
Else
   f_get_array (ls_value, '@', la_value)
   dw_c.object.ymd [1] = datetime (date (la_value [2]))
   dw_c.object.rcd [1] = la_value [3]
   dw_c.object.xx_rcd [1] = la_value [4]
   p_retrieve.POST EVENT clicked ()
End IF
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja020f
end type

type ln_templeft from wt_list`ln_templeft within w_ja020f
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja020f
end type

type ln_temptop from wt_list`ln_temptop within w_ja020f
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja020f
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja020f
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja020f
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja020f
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja020f
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja020f
end type

type ln_tempright from wt_list`ln_tempright within w_ja020f
end type

type uo_navi from wt_list`uo_navi within w_ja020f
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja020f
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja020f
end type

type p_close from wt_list`p_close within w_ja020f
end type

type p_excel from wt_list`p_excel within w_ja020f
end type

type p_print from wt_list`p_print within w_ja020f
end type

type p_delete from wt_list`p_delete within w_ja020f
end type

type p_update from wt_list`p_update within w_ja020f
end type

type p_input from wt_list`p_input within w_ja020f
end type

type p_retrieve from wt_list`p_retrieve within w_ja020f
end type

type p_clear from wt_list`p_clear within w_ja020f
end type

type p_copy from wt_list`p_copy within w_ja020f
end type

type dw_c from wt_list`dw_c within w_ja020f
string title = "보유일자@발행기관"
string dataobject = "dc_xx_ymd"
end type

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;RETURN 3
end event

type btn_update from wt_list`btn_update within w_ja020f
end type

type st_count from wt_list`st_count within w_ja020f
end type

type dw_list from wt_list`dw_list within w_ja020f
string dataobject = "d_ja020f1"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'retrieveend')
end event

