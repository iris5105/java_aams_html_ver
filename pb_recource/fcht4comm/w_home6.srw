forward
global type w_home6 from w_window1st
end type
type cb_1 from pf_u_commandbutton within w_home6
end type
type tab_5 from tab within w_home6
end type
type tabpage_6 from userobject within tab_5
end type
type dw_6 from u_dw within tabpage_6
end type
type tabpage_6 from userobject within tab_5
dw_6 dw_6
end type
type tab_5 from tab within w_home6
tabpage_6 tabpage_6
end type
end forward

global type w_home6 from w_window1st
integer width = 6816
integer height = 3700
long backcolor = 33028087
boolean confirmsheetbackcolor = false
cb_1 cb_1
tab_5 tab_5
end type
global w_home6 w_home6

type variables
STRING	is_customer_gr
end variables

forward prototypes
public subroutine of_bringtotop (boolean ab_value)
public subroutine uf_setcht ()
public subroutine uf_corp_gr ()
end prototypes

public subroutine of_bringtotop (boolean ab_value);this.BringToTop = ab_value
end subroutine

public subroutine uf_setcht ();
end subroutine

public subroutine uf_corp_gr ();
tab_5.tabpage_6.dw_6.retrieve (gaa.CORP_GR)

POST uf_setcht ()
end subroutine

on w_home6.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.tab_5=create tab_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_5
end on

on w_home6.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.tab_5)
end on

event wue_lastopen;call super::wue_lastopen;event wue_retrieve()
end event

event wue_retrieve2ready;POST EVENT wue_retrieve()
end event

event wue_postopen;call super::wue_postopen;is_customer_gr = gaa.customer_gr
end event

event wue_lastinst;call super::wue_lastinst;
tab_5.tabpage_6.dw_6.SetTransObject (SQLCA)

tab_5.tabpage_6.dw_6.retrieve (gaa.corp_gr)

yield ()

post uf_setcht()
end event

type lb_dirlist from w_window1st`lb_dirlist within w_home6
integer x = 6235
integer y = 1964
end type

type ln_templeft from w_window1st`ln_templeft within w_home6
end type

type ln_tempbuttom from w_window1st`ln_tempbuttom within w_home6
end type

type ln_temptop from w_window1st`ln_temptop within w_home6
boolean visible = false
end type

type ln_tempbutton from w_window1st`ln_tempbutton within w_home6
end type

type ln_tempstart from w_window1st`ln_tempstart within w_home6
end type

type ln_cond1_yline from w_window1st`ln_cond1_yline within w_home6
end type

type ln_dw1_yline from w_window1st`ln_dw1_yline within w_home6
end type

type ln_cond2_yline from w_window1st`ln_cond2_yline within w_home6
end type

type ln_dw2_yline from w_window1st`ln_dw2_yline within w_home6
end type

type ln_tempright from w_window1st`ln_tempright within w_home6
end type

type uo_navi from w_window1st`uo_navi within w_home6
boolean visible = false
integer x = 0
integer y = 0
integer width = 82
end type

type ln_temptop_shadow from w_window1st`ln_temptop_shadow within w_home6
boolean visible = false
end type

type st_windelaytime from w_window1st`st_windelaytime within w_home6
boolean visible = false
integer x = 0
end type

type st_top_rect from w_window1st`st_top_rect within w_home6
end type

type cb_1 from pf_u_commandbutton within w_home6
integer x = 6057
integer y = 1620
integer width = 457
integer taborder = 70
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "PBL export"
end type

event clicked;OPEN (w_get_object)
end event

event constructor;call super::constructor;visible = (gaa.login = 'yjs1992@hitel.net')
end event

type tab_5 from tab within w_home6
integer x = 4581
integer y = 144
integer width = 1993
integer height = 1432
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33028087
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_6 tabpage_6
end type

on tab_5.create
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_6}
end on

on tab_5.destroy
destroy(this.tabpage_6)
end on

type tabpage_6 from userobject within tab_5
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = "시스템 개발 및 수정의뢰 현황"
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from u_dw within tabpage_6
integer x = 5
integer y = 12
integer width = 1938
integer height = 1284
integer taborder = 70
boolean bringtotop = true
string title = ""
string dataobject = "d_home06"
boolean vscrollbar = true
boolean border = false
boolean ibdesign4role = false
boolean useborder = false
string setlist4backcolor = "255,255,255"
end type

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event doubleclicked;gnv_rolemenu.of_setopensheet ('00295')
end event

event getfocus;call fw_u_dwo::getfocus
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

