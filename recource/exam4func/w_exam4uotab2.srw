forward
global type w_exam4uotab2 from w_window1st5ncn
end type
type tab_uopage from tab within w_exam4uotab2
end type
type tabpage_2 from u_exam4uotab1_page3 within tab_uopage
end type
type tabpage_2 from u_exam4uotab1_page3 within tab_uopage
end type
type tab_uopage from tab within w_exam4uotab2
tabpage_2 tabpage_2
end type
type uo_tab from pf_u_tab within w_exam4uotab2
end type
end forward

global type w_exam4uotab2 from w_window1st5ncn
tab_uopage tab_uopage
uo_tab uo_tab
end type
global w_exam4uotab2 w_exam4uotab2

on w_exam4uotab2.create
int iCurrent
call super::create
this.tab_uopage=create tab_uopage
this.uo_tab=create uo_tab
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_uopage
this.Control[iCurrent+2]=this.uo_tab
end on

on w_exam4uotab2.destroy
call super::destroy
destroy(this.tab_uopage)
destroy(this.uo_tab)
end on

event wue_retrieve;call super::wue_retrieve;//tab_tabpage.tabpage_4.dw_list.SetTransObject( sqlca )
//tab_object.tabpage_2.dw_list.SetTransObject( sqlca )

//tab_tabpage.tabpage_4.dw_list.Retrieve()
//tab_object.tabpage_2.dw_list.Retrieve()
end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_exam4uotab2
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_exam4uotab2
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_exam4uotab2
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_exam4uotab2
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_exam4uotab2
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_exam4uotab2
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_exam4uotab2
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_exam4uotab2
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_exam4uotab2
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_exam4uotab2
end type

type uo_navi from w_window1st5ncn`uo_navi within w_exam4uotab2
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_exam4uotab2
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_exam4uotab2
end type

type p_close from w_window1st5ncn`p_close within w_exam4uotab2
end type

type p_excel from w_window1st5ncn`p_excel within w_exam4uotab2
end type

event p_excel::clicked;call super::clicked;//fw_s_xlsx	lstr_xlsx

//lstr_xlsx.w_obj	= iw_parent
//lstr_xlsx.pic_obj	= This
//lstr_xlsx.dw_obj	= idw_u

//OpenWithParm(fw_w_xlsx, lstr_xlsx)
end event

type p_print from w_window1st5ncn`p_print within w_exam4uotab2
end type

type p_delete from w_window1st5ncn`p_delete within w_exam4uotab2
end type

type p_update from w_window1st5ncn`p_update within w_exam4uotab2
end type

type p_input from w_window1st5ncn`p_input within w_exam4uotab2
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_exam4uotab2
end type

type p_clear from w_window1st5ncn`p_clear within w_exam4uotab2
end type

type tab_uopage from tab within w_exam4uotab2
event create ( )
event destroy ( )
integer x = 55
integer y = 168
integer width = 5376
integer height = 2596
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_2 tabpage_2
end type

on tab_uopage.create
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_2}
end on

on tab_uopage.destroy
destroy(this.tabpage_2)
end on

type tabpage_2 from u_exam4uotab1_page3 within tab_uopage
integer x = 18
integer y = 116
integer width = 5339
integer height = 2464
string text = "tabpage 2"
end type

type uo_tab from pf_u_tab within w_exam4uotab2
event destroy ( )
integer x = 320
integer y = 72
integer taborder = 20
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_uopage"
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

