forward
global type w_ja031f from wt_vertdetail
end type
type cb_xls from pf_u_commandbutton within w_ja031f
end type
end forward

global type w_ja031f from wt_vertdetail
integer width = 5499
integer ii_dddw_position = 1
integer ii_dddw_width = 500
integer ii_dddw_width2 = 750
boolean ib_managedata = false
event ue_9001 ( )
cb_xls cb_xls
end type
global w_ja031f w_ja031f

type variables

end variables

on w_ja031f.create
int iCurrent
call super::create
this.cb_xls=create cb_xls
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_xls
end on

on w_ja031f.destroy
call super::destroy
destroy(this.cb_xls)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1])
end event

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

SELECT trunc(:idt_workdate,'mm')
  INTO :ldt
  FROM DUAL;

dw_c.object.fymd [1] = SQLCA.getitemdatetime(1)
dw_c.object.tymd [1] = idt_workdate
end event

event open;icmdbutton = { cb_xls }
call super::open
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja031f
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja031f
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja031f
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja031f
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja031f
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja031f
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja031f
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja031f
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja031f
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja031f
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja031f
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja031f
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja031f
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja031f
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja031f
end type

type p_close from wt_vertdetail`p_close within w_ja031f
end type

type p_excel from wt_vertdetail`p_excel within w_ja031f
end type

type p_print from wt_vertdetail`p_print within w_ja031f
end type

type p_delete from wt_vertdetail`p_delete within w_ja031f
end type

type p_update from wt_vertdetail`p_update within w_ja031f
end type

type p_input from wt_vertdetail`p_input within w_ja031f
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja031f
end type

type p_clear from wt_vertdetail`p_clear within w_ja031f
end type

type p_copy from wt_vertdetail`p_copy within w_ja031f
end type

type dw_c from wt_vertdetail`dw_c within w_ja031f
string title = "매매구간"
string dataobject = "dc_ftymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja031f
end type

type st_count from wt_vertdetail`st_count within w_ja031f
end type

type dw_list from wt_vertdetail`dw_list within w_ja031f
string dataobject = "d_ja031f"
end type

event dw_list::retrieveend;insertrow (1)
Object.fund_cd [1] = '%'
Object.fund_nm [1] = '전체'

rowcount ++

CALL super::retrieveend
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja031f
string dataobject = "d_ja031f1"
boolean ibsetlist4subbtn = false
string setlist4fontpointcolor = "tr_color=J=a;tr_color=K=d"
end type

event dw_detail::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1], dw_list.object.fund_cd [iRow])
end event

type st_move from wt_vertdetail`st_move within w_ja031f
boolean leftmaxsizefixed = true
end type

type cb_xls from pf_u_commandbutton within w_ja031f
integer x = 2231
integer y = 16
integer width = 402
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "엑셀저장"
end type

event clicked;dw_detail.retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1], dw_list.object.fund_cd [iRow])
IF	dw_c.object.fymd [1]=dw_c.object.tymd [1]	Then
	f_xlsx_nosummary (dw_detail, string (dw_c.object.fymd [1],'yyyymmdd') + '채권매매내역', 'Sheet1','','','','')
Else
	f_xlsx_nosummary (dw_detail, string (dw_c.object.fymd [1],'yyyymmdd') + '-' + string (dw_c.object.tymd [1],'yyyymmdd') + '채권매매내역', 'Sheet1','','','','')
End IF
end event

