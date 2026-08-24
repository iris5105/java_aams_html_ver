forward
global type w_cron_recvfile_look from wt_list
end type
type rb_1 from pf_u_radiobutton within w_cron_recvfile_look
end type
type rb_2 from pf_u_radiobutton within w_cron_recvfile_look
end type
type rb_3 from pf_u_radiobutton within w_cron_recvfile_look
end type
end forward

global type w_cron_recvfile_look from wt_list
boolean eb_direct_retrieve = true
boolean ib_managedata = false
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_cron_recvfile_look w_cron_recvfile_look

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
rb_1.checked = TRUE
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (dw_c.object.ymd [1])
end event

on w_cron_recvfile_look.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
end on

on w_cron_recvfile_look.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
end on

type lb_dirlist from wt_list`lb_dirlist within w_cron_recvfile_look
end type

type ln_templeft from wt_list`ln_templeft within w_cron_recvfile_look
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_cron_recvfile_look
end type

type ln_temptop from wt_list`ln_temptop within w_cron_recvfile_look
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_cron_recvfile_look
end type

type ln_tempstart from wt_list`ln_tempstart within w_cron_recvfile_look
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_cron_recvfile_look
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_cron_recvfile_look
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_cron_recvfile_look
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_cron_recvfile_look
end type

type ln_tempright from wt_list`ln_tempright within w_cron_recvfile_look
end type

type uo_navi from wt_list`uo_navi within w_cron_recvfile_look
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_cron_recvfile_look
end type

type st_windelaytime from wt_list`st_windelaytime within w_cron_recvfile_look
end type

type st_top_rect from wt_list`st_top_rect within w_cron_recvfile_look
end type

type p_close from wt_list`p_close within w_cron_recvfile_look
end type

type p_excel from wt_list`p_excel within w_cron_recvfile_look
end type

type p_print from wt_list`p_print within w_cron_recvfile_look
end type

type p_delete from wt_list`p_delete within w_cron_recvfile_look
end type

type p_update from wt_list`p_update within w_cron_recvfile_look
end type

type p_input from wt_list`p_input within w_cron_recvfile_look
end type

type p_retrieve from wt_list`p_retrieve within w_cron_recvfile_look
end type

type p_clear from wt_list`p_clear within w_cron_recvfile_look
end type

type p_copy from wt_list`p_copy within w_cron_recvfile_look
end type

type dw_c from wt_list`dw_c within w_cron_recvfile_look
string title = "수신일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_cron_recvfile_look
end type

type st_count from wt_list`st_count within w_cron_recvfile_look
end type

type dw_list from wt_list`dw_list within w_cron_recvfile_look
string dataobject = "d_cron_recvfile_look"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_null_line = false
end type

type rb_1 from pf_u_radiobutton within w_cron_recvfile_look
integer x = 1573
integer y = 196
integer width = 293
integer height = 84
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 553648127
string text = "전체"
boolean setcondcolor = true
end type

event clicked;dw_List.uf_dataobject ("d_cron_recvfile_look", FALSE)
dw_List.retrieve (dw_c.object.ymd [1])
end event

type rb_2 from pf_u_radiobutton within w_cron_recvfile_look
integer x = 1815
integer y = 196
integer width = 475
integer height = 84
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 553648127
string text = "KOSCOM종가"
boolean setcondcolor = true
end type

event clicked;dw_List.uf_dataobject ("d_cron_recvfile_look_koscom", FALSE)
dw_List.retrieve (dw_c.object.ymd [1])
end event

type rb_3 from pf_u_radiobutton within w_cron_recvfile_look
integer x = 2304
integer y = 196
integer width = 475
integer height = 84
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 553648127
string text = "컷오프종가"
boolean setcondcolor = true
end type

event clicked;dw_List.uf_dataobject ("d_cron_recvfile_look_cutoff", FALSE)
dw_List.retrieve (dw_c.object.ymd [1])
end event

