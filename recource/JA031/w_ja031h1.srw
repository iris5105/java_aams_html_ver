forward
global type w_ja031h1 from wt_listole
end type
type cb_folder from pf_u_commandbutton within w_ja031h1
end type
end forward

global type w_ja031h1 from wt_listole
integer ii_dddw_width = 900
cb_folder cb_folder
end type
global w_ja031h1 w_ja031h1

event wue_lastopen;call super::wue_lastopen;DATETIME ldt1, ldt2

SELECT trunc (:idt_workdate,'mm') - 1
     , ADD_MONTHS(trunc (:idt_workdate,'mm'), -12)
  INTO :ldt2
     , :ldt1
  FROM DUAL;

ldt2 = SQLCA.getitemdatetime (1)
ldt1 = SQLCA.getitemdatetime (2)

dw_c.object.fymd [1] = ldt1
dw_c.object.tymd [1] = ldt2
dw_c.object.dddw [1] = '%'
end event

on w_ja031h1.create
int iCurrent
call super::create
this.cb_folder=create cb_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_folder
end on

on w_ja031h1.destroy
call super::destroy
destroy(this.cb_folder)
end on

type lb_dirlist from wt_listole`lb_dirlist within w_ja031h1
end type

type ln_templeft from wt_listole`ln_templeft within w_ja031h1
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja031h1
end type

type ln_temptop from wt_listole`ln_temptop within w_ja031h1
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja031h1
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja031h1
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja031h1
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja031h1
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja031h1
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja031h1
end type

type ln_tempright from wt_listole`ln_tempright within w_ja031h1
end type

type uo_navi from wt_listole`uo_navi within w_ja031h1
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja031h1
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja031h1
end type

type st_top_rect from wt_listole`st_top_rect within w_ja031h1
end type

type p_close from wt_listole`p_close within w_ja031h1
end type

type p_excel from wt_listole`p_excel within w_ja031h1
end type

type p_print from wt_listole`p_print within w_ja031h1
end type

type p_delete from wt_listole`p_delete within w_ja031h1
end type

type p_update from wt_listole`p_update within w_ja031h1
end type

type p_input from wt_listole`p_input within w_ja031h1
end type

type p_retrieve from wt_listole`p_retrieve within w_ja031h1
end type

type p_clear from wt_listole`p_clear within w_ja031h1
end type

type p_copy from wt_listole`p_copy within w_ja031h1
end type

type dw_c from wt_listole`dw_c within w_ja031h1
string title = "조회일자@고유계좌"
string dataobject = "dc_ftymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw', gaa.corp_gr, "%,전체,", 10, "")
end event

type btn_update from wt_listole`btn_update within w_ja031h1
end type

type st_count from wt_listole`st_count within w_ja031h1
end type

type dw_list from wt_listole`dw_list within w_ja031h1
end type

type st_move from wt_listole`st_move within w_ja031h1
end type

type ole_rd from wt_listole`ole_rd within w_ja031h1
integer y = 348
integer height = 2416
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;UF_FILEOPEN ('rd_ja031h1.mrd', &
             'fund_cd[' + dw_c.object.dddw [1] + '] fymd[' + STRING (dw_c.object.fymd [1], 'yyyy.mm.dd') + '] tymd[' + STRING (dw_c.object.tymd [1], 'yyyy.mm.dd') + ']')
end event

type rb_onepage from wt_listole`rb_onepage within w_ja031h1
boolean checked = true
end type

type cb_folder from pf_u_commandbutton within w_ja031h1
integer x = 4672
integer y = 192
integer width = 457
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute (gaa.excel)
end event

