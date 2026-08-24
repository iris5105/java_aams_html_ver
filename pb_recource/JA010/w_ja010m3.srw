forward
global type w_ja010m3 from wt_vertole
end type
type mle_cond from u_mle within w_ja010m3
end type
end forward

global type w_ja010m3 from wt_vertole
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
string is_init_value = "1"
mle_cond mle_cond
end type
global w_ja010m3 w_ja010m3

type variables

end variables

event wue_retrieve;call super::wue_retrieve;DATETIME	ldt
STRING	ls_chk = 'a'

IF	gaa.admin THEN ls_chk = 'b'

is_find = "fund_cd='" + gaa.fund_cd + "'"
ia_value [1] = dw_c.object.dddw [1]
IF	ia_value [1]='1'	Then
	dw_list.setsort ("xx_fund_cd asc, gyul_ymd desc, tbl_gb")
	dw_list.retrieve (gaa.corp_gr, ldt, ls_chk)
Else
	dw_list.setsort ("gyul_ymd desc, xx_fund_cd asc, tbl_gb")
	dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ls_chk)
End IF

end event

on w_ja010m3.create
int iCurrent
call super::create
this.mle_cond=create mle_cond
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_cond
end on

on w_ja010m3.destroy
call super::destroy
destroy(this.mle_cond)
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_add_months (idt_workdate, -36, null_dt)
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_update;IF dw_list.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	mle_cond.ib_update THEN dw_list.object.contract_condition [iRow] = mle_cond.text
IF EVENT ue_wpage_modified ()	Then
	IF	uf_updateCommit (dw_list)=-1 THEN RETURN -1
	mle_cond.ib_update = FALSE
End IF
RETURN 1
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja010m3
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja010m3
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja010m3
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja010m3
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja010m3
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja010m3
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja010m3
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja010m3
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja010m3
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja010m3
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja010m3
end type

type uo_navi from wt_vertole`uo_navi within w_ja010m3
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja010m3
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja010m3
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja010m3
end type

type p_close from wt_vertole`p_close within w_ja010m3
end type

type p_excel from wt_vertole`p_excel within w_ja010m3
end type

type p_print from wt_vertole`p_print within w_ja010m3
end type

type p_delete from wt_vertole`p_delete within w_ja010m3
end type

type p_update from wt_vertole`p_update within w_ja010m3
end type

type p_input from wt_vertole`p_input within w_ja010m3
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja010m3
end type

event p_retrieve::clicked;call super::clicked;dw_c.Enabled = true
dw_List.uf_protect (0, dw_List.ia_protect [1])

end event

type p_clear from wt_vertole`p_clear within w_ja010m3
end type

type p_copy from wt_vertole`p_copy within w_ja010m3
end type

type dw_c from wt_vertole`dw_c within w_ja010m3
string tag = "고객명순으로 조회시 최초설정일부터 조회"
string title = "결산기준일@정렬구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, "1,고객명순,,2,결산일순,", 1, "")
end event

type btn_update from wt_vertole`btn_update within w_ja010m3
end type

type st_count from wt_vertole`st_count within w_ja010m3
end type

type dw_list from wt_vertole`dw_list within w_ja010m3
boolean visible = true
string dataobject = "d_ja010m3"
boolean hscrollbar = true
string setlist4rowpointcolor = "tbl_gb=b=b"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1
CHOOSE CASE dwo.name
	CASE 'basic_bosu'
		Object.total_bosu [row] = DEC (data) + f_num (Object.success_bosu [row])
	CASE 'success_bosu'
		Object.total_bosu [row] = DEC (data) + f_num (Object.basic_bosu [row])
	CASE 'wm_seolj_aek','wm_sonik','doc_no'
		Object.send_dt [row] = f_sysdate ('')
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF	Object.tbl_gb [row]='a'	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF

end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF mle_cond.ib_update THEN Object.contract_condition [currentrow] = mle_cond.TEXT
RETURN 0
end event

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;mle_cond.backcolor = gnv_vari.setcondbackcolor
mle_cond.uf_init ('', (gaa.corp_gr = '2402'))
mle_cond.TEXT = Object.contract_condition [currentrow]
RETURN 0
end event

type st_move from wt_vertole`st_move within w_ja010m3
string rightdragobject = "mle_cond;ole_rd"
end type

type ole_rd from wt_vertole`ole_rd within w_ja010m3
integer y = 676
integer height = 2088
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;f_microhelp (dw_list.object.mrd_nm [row] + ' 출력...')
IF	dw_list.object.tbl_gb [row]='b' THEN RETURN
uf_fileopen (dw_list.object.mrd_nm [row], &
								  'fund_cd[' + string(dw_list.object.fund_cd [row]) + '] ' + &
								  'gyul_ymd[' + string(dw_list.object.gyul_ymd [row],'yyyy.mm.dd') + ']' )

end event

type rb_onepage from wt_vertole`rb_onepage within w_ja010m3
end type

type mle_cond from u_mle within w_ja010m3
integer x = 2647
integer y = 348
integer width = 2784
integer height = 316
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean enabled = true
boolean scaletoright = true
end type

