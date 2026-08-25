forward
global type w_ja032n from wt_vertdetail
end type
type dw_right from u_dw within w_ja032n
end type
end forward

global type w_ja032n from wt_vertdetail
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
boolean ib_managedata = false
dw_right dw_right
end type
global w_ja032n w_ja032n

on w_ja032n.create
int iCurrent
call super::create
this.dw_right=create dw_right
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_right
end on

on w_ja032n.destroy
call super::destroy
destroy(this.dw_right)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_saveas;dw_detail.EVENT oue_subbtn_excel ()
end event

event wue_clear;call super::wue_clear;dw_right.uf_clear ()
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032n
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032n
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032n
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032n
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032n
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032n
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032n
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032n
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032n
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032n
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032n
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032n
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032n
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032n
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032n
end type

type p_close from wt_vertdetail`p_close within w_ja032n
end type

type p_excel from wt_vertdetail`p_excel within w_ja032n
end type

type p_print from wt_vertdetail`p_print within w_ja032n
end type

type p_delete from wt_vertdetail`p_delete within w_ja032n
end type

type p_update from wt_vertdetail`p_update within w_ja032n
end type

type p_input from wt_vertdetail`p_input within w_ja032n
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032n
end type

type p_clear from wt_vertdetail`p_clear within w_ja032n
end type

type p_copy from wt_vertdetail`p_copy within w_ja032n
end type

type dw_c from wt_vertdetail`dw_c within w_ja032n
string title = "조회기준일"
string dataobject = "dc_ymd"
end type

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;RETURN 2
end event

type btn_update from wt_vertdetail`btn_update within w_ja032n
end type

type st_count from wt_vertdetail`st_count within w_ja032n
end type

type dw_list from wt_vertdetail`dw_list within w_ja032n
string dataobject = "d_ja032n1"
end type

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;dw_right.setredraw (false)
dw_right.uf_reset ()
dw_right.event ue_retrieve ()
dw_right.setredraw (true)
RETURN 0
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja032n
integer y = 800
integer height = 1964
string dataobject = "d_ja032n2"
boolean ibsetlist4subbtn = false
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.fund_cd [iRow], dw_c.object.ymd [1])
end event

type st_move from wt_vertdetail`st_move within w_ja032n
boolean leftmaxsizefixed = true
string rightdragobject = "dw_detail;dw_right"
end type

type dw_right from u_dw within w_ja032n
integer x = 2601
integer y = 348
integer width = 2830
integer height = 432
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ja032n3"
boolean scaletoright = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_list.object.fund_cd [iRow])
end event

