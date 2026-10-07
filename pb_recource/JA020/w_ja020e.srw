forward
global type w_ja020e from wt_list
end type
end forward

global type w_ja020e from wt_list
boolean ib_managedata = false
end type
global w_ja020e w_ja020e

on w_ja020e.create
int iCurrent
call super::create
end on

on w_ja020e.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.krak_ymd [1] = idt_workdate
dw_c.object.chyung_ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;STRING	ls_gubun, ls_balh_co

DateTime ldt_1, ldt_2

ldt_1 = dw_c.object.krak_ymd [1]
ldt_2 = dw_c.object.chyung_ymd [1]
ls_gubun = dw_c.object.tr_arg [1]
ls_balh_co = dw_c.object.balh_co [1]

IF dw_c.object.tr_arg [1]<>'1'   Then
   ls_balh_co = '%'
   IF dw_c.object.tr_arg [1]='2' Then
      ldt_2 = null_dt
   Else
      ldt_1 = null_dt
   End IF
Else
   ldt_1 = null_dt
   ldt_2 = null_dt
End IF

dw_list.retrieve (gaa.corp_gr, ls_balh_co, ldt_1, ldt_2)
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja020e
end type

type ln_templeft from wt_list`ln_templeft within w_ja020e
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja020e
end type

type ln_temptop from wt_list`ln_temptop within w_ja020e
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja020e
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja020e
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja020e
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja020e
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja020e
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja020e
end type

type ln_tempright from wt_list`ln_tempright within w_ja020e
end type

type uo_navi from wt_list`uo_navi within w_ja020e
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja020e
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja020e
end type

type p_close from wt_list`p_close within w_ja020e
end type

type p_excel from wt_list`p_excel within w_ja020e
end type

type p_print from wt_list`p_print within w_ja020e
end type

type p_delete from wt_list`p_delete within w_ja020e
end type

type p_update from wt_list`p_update within w_ja020e
end type

type p_input from wt_list`p_input within w_ja020e
end type

type p_retrieve from wt_list`p_retrieve within w_ja020e
end type

type p_clear from wt_list`p_clear within w_ja020e
end type

type p_copy from wt_list`p_copy within w_ja020e
end type

type dw_c from wt_list`dw_c within w_ja020e
string dataobject = "d_ja020e"
end type

type btn_update from wt_list`btn_update within w_ja020e
end type

type st_count from wt_list`st_count within w_ja020e
end type

type dw_list from wt_list`dw_list within w_ja020e
string dataobject = "d_ja020e1"
end type

