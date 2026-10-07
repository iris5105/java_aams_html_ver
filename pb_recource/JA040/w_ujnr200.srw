forward
global type w_ujnr200 from wt_listole
end type
type rb_1 from pf_u_radiobutton within w_ujnr200
end type
type rb_2 from pf_u_radiobutton within w_ujnr200
end type
type cbx_2 from pf_u_checkbox within w_ujnr200
end type
end forward

global type w_ujnr200 from wt_listole
boolean eb_direct_retrieve = true
string is_init_value = "0"
rb_1 rb_1
rb_2 rb_2
cbx_2 cbx_2
end type
global w_ujnr200 w_ujnr200

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
CHOOSE CASE ia_value [1]
   CASE '0'
      rb_1.checked = TRUE
   CASE '1'
      rb_2.checked = TRUE
END CHOOSE
end event

on w_ujnr200.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_2=create cbx_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.cbx_2
end on

on w_ujnr200.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_2)
end on

type ln_templeft from wt_listole`ln_templeft within w_ujnr200
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ujnr200
end type

type ln_temptop from wt_listole`ln_temptop within w_ujnr200
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ujnr200
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ujnr200
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ujnr200
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ujnr200
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ujnr200
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ujnr200
end type

type ln_tempright from wt_listole`ln_tempright within w_ujnr200
end type

type uo_navi from wt_listole`uo_navi within w_ujnr200
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ujnr200
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ujnr200
end type

type p_close from wt_listole`p_close within w_ujnr200
end type

type p_excel from wt_listole`p_excel within w_ujnr200
end type

type p_print from wt_listole`p_print within w_ujnr200
end type

type p_delete from wt_listole`p_delete within w_ujnr200
end type

type p_update from wt_listole`p_update within w_ujnr200
end type

type p_input from wt_listole`p_input within w_ujnr200
end type

type p_retrieve from wt_listole`p_retrieve within w_ujnr200
end type

type p_clear from wt_listole`p_clear within w_ujnr200
end type

type p_copy from wt_listole`p_copy within w_ujnr200
end type

type dw_c from wt_listole`dw_c within w_ujnr200
string title = "영업일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listole`btn_update within w_ujnr200
end type

type dw_list from wt_listole`dw_list within w_ujnr200
end type

type st_move from wt_listole`st_move within w_ujnr200
boolean visible = false
boolean enabled = false
end type

type ole_rd from wt_listole`ole_rd within w_ujnr200
integer y = 348
integer height = 2416
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;DateTime  ldt

ldt = dw_c.object.ymd [1]

SELECT  :ldt - 1
  INTO  :ldt
FROM    dual;

ldt = SQLCA.getitemdatetime (1)

uf_fileopen ('rd_ujnr200.mrd', &
            'tr_ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + '] ' + &
            'pr[' + ia_value [1] + '] ' + &
            'rep[' + IIF (cbx_2.checked,'2','1') + '] ' + &
            'mo_ymd[' + string (ldt,'yyyy.mm.dd') + ']')

end event

type rb_onepage from wt_listole`rb_onepage within w_ujnr200
end type

type rb_1 from pf_u_radiobutton within w_ujnr200
integer x = 1339
integer y = 208
integer width = 347
integer height = 68
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "펀드별"
boolean setcondcolor = true
end type

event clicked;rb_2.checked = NOT checked
ia_value [1] = '0'
p_retrieve.POST EVENT Clicked ()
end event

type rb_2 from pf_u_radiobutton within w_ujnr200
integer x = 1655
integer y = 208
integer width = 347
integer height = 68
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "모펀드별"
boolean setcondcolor = true
end type

event clicked;rb_1.checked = NOT checked
ia_value [1] = '1'
p_retrieve.POST EVENT Clicked ()

end event

type cbx_2 from pf_u_checkbox within w_ujnr200
integer x = 2085
integer y = 200
integer width = 530
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "비거주과표포함"
boolean setcondcolor = true
end type

event clicked;p_retrieve.POST EVENT Clicked ()
end event

