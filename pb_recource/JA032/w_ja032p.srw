forward
global type w_ja032p from wt_vertdetail
end type
type st_day from pf_u_splitbar_horizontal within w_ja032p
end type
type dw_day from u_dw within w_ja032p
end type
end forward

global type w_ja032p from wt_vertdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
st_day st_day
dw_day dw_day
end type
global w_ja032p w_ja032p

on w_ja032p.create
int iCurrent
call super::create
this.st_day=create st_day
this.dw_day=create dw_day
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_day
this.Control[iCurrent+2]=this.dw_day
end on

on w_ja032p.destroy
call super::destroy
destroy(this.st_day)
destroy(this.dw_day)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032p
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032p
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032p
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032p
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032p
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032p
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032p
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032p
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032p
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032p
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032p
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032p
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032p
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032p
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032p
end type

type p_close from wt_vertdetail`p_close within w_ja032p
end type

type p_excel from wt_vertdetail`p_excel within w_ja032p
end type

type p_print from wt_vertdetail`p_print within w_ja032p
end type

type p_delete from wt_vertdetail`p_delete within w_ja032p
end type

type p_update from wt_vertdetail`p_update within w_ja032p
end type

type p_input from wt_vertdetail`p_input within w_ja032p
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032p
end type

type p_clear from wt_vertdetail`p_clear within w_ja032p
end type

type p_copy from wt_vertdetail`p_copy within w_ja032p
end type

type dw_c from wt_vertdetail`dw_c within w_ja032p
string title = "조회일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja032p
end type

type st_count from wt_vertdetail`st_count within w_ja032p
end type

type dw_list from wt_vertdetail`dw_list within w_ja032p
string dataobject = "d_ja032m1"
end type

type dw_detail from wt_vertdetail`dw_detail within w_ja032p
integer height = 908
string dataobject = "d_ja032p2"
boolean scaletobottom = false
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_list.object.fund_cd [iRow])
end event

event dw_detail::rowfocuschanged_if;call super::rowfocuschanged_if;dw_day.setredraw (false)
dw_day.uf_reset ()
dw_day.event ue_retrieve ()
dw_day.setredraw (true)
RETURN 0
end event

type st_move from wt_vertdetail`st_move within w_ja032p
boolean leftmaxsizefixed = true
string rightdragobject = "dw_detail;st_day;dw_day"
end type

type st_day from pf_u_splitbar_horizontal within w_ja032p
integer x = 2601
integer y = 1272
integer width = 2830
boolean bringtotop = true
boolean setcondcolor = true
string topdragobject = "dw_detail"
string bottomdragobject = "dw_day"
end type

type dw_day from u_dw within w_ja032p
integer x = 2601
integer y = 1304
integer width = 2830
integer height = 1460
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_ja032p3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean eb_range_delcopy = false
end type

event constructor;uf_date_nation (is_date_nation)
call super::constructor
end event

event retrieveend;call super::retrieveend;IF	rowcount=0 THEN dw_detail.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (gaa.CORP_GR, dw_c.object.ymd [1], dw_list.object.fund_cd [iRow], dw_detail.object.sym0yz_jm_cd [dw_detail.getrow ()], dw_detail.object.trustee [dw_detail.getrow ()])
end event

