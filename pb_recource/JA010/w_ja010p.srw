forward
global type w_ja010p from wt_vertole
end type
type cb_xls from commandbutton within w_ja010p
end type
type cb_pdf from pf_u_commandbutton within w_ja010p
end type
type cb_folder from pf_u_commandbutton within w_ja010p
end type
type cbx_1 from pf_u_checkbox within w_ja010p
end type
end forward

global type w_ja010p from wt_vertole
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
cb_xls cb_xls
cb_pdf cb_pdf
cb_folder cb_folder
cbx_1 cbx_1
end type
global w_ja010p w_ja010p

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
cbx_1.visible = gaa.admin
end event

on w_ja010p.create
int iCurrent
call super::create
this.cb_xls=create cb_xls
this.cb_pdf=create cb_pdf
this.cb_folder=create cb_folder
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_xls
this.Control[iCurrent+2]=this.cb_pdf
this.Control[iCurrent+3]=this.cb_folder
this.Control[iCurrent+4]=this.cbx_1
end on

on w_ja010p.destroy
call super::destroy
destroy(this.cb_xls)
destroy(this.cb_pdf)
destroy(this.cb_folder)
destroy(this.cbx_1)
end on

event wue_retrieve;call super::wue_retrieve;cb_xls.Enabled = TRUE
cb_pdf.Enabled = TRUE
is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_clear;call super::wue_clear;cb_xls.Enabled = FALSE
cb_pdf.Enabled = FALSE
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja010p
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja010p
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja010p
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja010p
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja010p
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja010p
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja010p
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja010p
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja010p
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja010p
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja010p
end type

type uo_navi from wt_vertole`uo_navi within w_ja010p
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja010p
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja010p
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja010p
end type

type p_close from wt_vertole`p_close within w_ja010p
end type

type p_excel from wt_vertole`p_excel within w_ja010p
end type

type p_print from wt_vertole`p_print within w_ja010p
end type

type p_delete from wt_vertole`p_delete within w_ja010p
end type

type p_update from wt_vertole`p_update within w_ja010p
end type

type p_input from wt_vertole`p_input within w_ja010p
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja010p
end type

type p_clear from wt_vertole`p_clear within w_ja010p
end type

type p_copy from wt_vertole`p_copy within w_ja010p
end type

type dw_c from wt_vertole`dw_c within w_ja010p
string title = "조회일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertole`btn_update within w_ja010p
end type

type st_count from wt_vertole`st_count within w_ja010p
end type

type dw_list from wt_vertole`dw_list within w_ja010p
boolean visible = true
string dataobject = "d_szm0ia"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sec_cd | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::retrieveend;insertrow (1)
Object.fund_cd [1] = '%'
Object.fund_nm [1] = '전체'

CALL super::retrieveend
end event

type st_move from wt_vertole`st_move within w_ja010p
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja010p
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;IF cbx_1.checked  Then
   UF_FILEOPEN ('rd_ja010p_admin.mrd' &
                ,'fund_cd[' + dw_list.object.fund_cd [row] + '] ymd[' + STRING (dw_c.object.ymd [1], 'yyyymmdd') + ']')
ELSE
   IF dw_list.object.fund_cd [row] = '%'  Then
      UF_FILEOPEN ('rd_ja010p_all.mrd' &
                   ,'ymd[' + STRING (dw_c.object.ymd [1], 'yyyymmdd') + ']')
   ELSE
      UF_FILEOPEN ('rd_ja010p.mrd' &
                   ,'fund_cd[' + dw_list.object.fund_cd [row] + '] ymd[' + STRING (dw_c.object.ymd [1], 'yyyymmdd') + ']')
   END IF
END IF
end event

type rb_onepage from wt_vertole`rb_onepage within w_ja010p
boolean checked = true
end type

type cb_xls from commandbutton within w_ja010p
integer x = 3314
integer y = 192
integer width = 393
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
boolean enabled = false
string text = "엑셀저장"
end type

event clicked;long   ll, lOld

STRING	ls_file

ll = dw_list.GetSelectedRow (0)
dw_list.uf_setrange (true)
DO WHILE TRUE
	ole_rd.eb_onepage = TRUE
   ls_file = dw_list.object.fund_nm [ll] + '(' + dw_list.object.fund_cd [ll] + ')'
   ole_rd.EVENT ue_retrieve (ll)
	ole_rd.uf_xls (gaa.xlsx + string(dw_c.object.ymd [1],'yyyymmdd') + '_' + ls_file + '.xls')

   dw_list.selectrow (ll, FALSE) ; lOld = ll
   ll = dw_list.GetSelectedRow (ll) ; IF ll=0 THEN EXIT
	dw_list.scrolltorow (ll)
LOOP
dw_list.uf_setrow (lOld, TRUE)

f_messageBox ('INFO', '자료생성을 완료했습니다.~r~n~r~n' + gaa.xlsx + '~r~nDirectory에서 자료를 확인하십시오.')
end event

type cb_pdf from pf_u_commandbutton within w_ja010p
integer x = 3758
integer y = 192
integer width = 393
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "PDF저장"
end type

event clicked;LONG	ll, lOld

ll = dw_list.GetSelectedRow (0)
dw_list.uf_setrange (true)
DO WHILE TRUE
   ole_rd.EVENT ue_retrieve (ll)
	ole_rd.uf_pdf (gaa.xlsx + string(dw_c.object.ymd [1],'yyyymmdd') + '_' + dw_list.object.fund_nm [ll] + '(' + dw_list.object.fund_cd [ll] + ').pdf')

   dw_list.SelectRow (ll, FALSE) ; lOld = ll
   ll = dw_list.GetSelectedRow (ll) ; IF ll=0 THEN EXIT
	dw_list.scrolltorow (ll)
LOOP
dw_list.uf_setrow (lOld, TRUE)

f_messageBox ('INFO', '자료생성을 완료했습니다.~r~n~r~n' + gaa.xlsx + '~r~nDirectory에서 자료를 확인하십시오.')
end event

type cb_folder from pf_u_commandbutton within w_ja010p
integer x = 4672
integer y = 192
integer width = 457
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute (gaa.xlsx)
end event

type cbx_1 from pf_u_checkbox within w_ja010p
integer x = 1330
integer y = 192
boolean bringtotop = true
string text = "ADMIN"
boolean setcondcolor = true
end type

