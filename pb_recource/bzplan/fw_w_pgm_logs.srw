forward
global type fw_w_pgm_logs from w_window1st5cn
end type
type tab_1 from tab within fw_w_pgm_logs
end type
type tabpage_1 from userobject within tab_1
end type
type dw_tab1 from u_dw within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_tab1 dw_tab1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_tab2 from u_dw within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_tab2 dw_tab2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_tab3 from u_dw within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_tab3 dw_tab3
end type
type tab_1 from tab within fw_w_pgm_logs
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type uo_tab from pf_u_tab within fw_w_pgm_logs
end type
end forward

global type fw_w_pgm_logs from w_window1st5cn
tab_1 tab_1
uo_tab uo_tab
end type
global fw_w_pgm_logs fw_w_pgm_logs

on fw_w_pgm_logs.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.uo_tab=create uo_tab
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.uo_tab
end on

on fw_w_pgm_logs.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.uo_tab)
end on

event wue_retrieve;call super::wue_retrieve;String		ls_frdt, ls_todt, ls_site_id
Long		ll_ret

dw_cond.AcceptText()

ls_frdt = dw_cond.GetItemString(1, 'fr_dt')
If fw_f_nvls(ls_frdt, '') = '' Then
	Messagebox('Check', '시작일자를 확인 하십시요')
	Return
End If

ls_todt = dw_cond.GetItemString(1, 'to_dt')
If fw_f_nvls(ls_todt, '') = '' Then
	Messagebox('Check', '종료일자를 확인 하십시요')
	Return
End If

ls_site_id = dw_cond.GetItemString(1, 'site_id')

ll_ret = tab_1.tabpage_1.dw_tab1.Retrieve(ls_frdt, ls_todt, ls_site_id)

If ll_ret > 0 Then
	ll_ret = tab_1.tabpage_2.dw_tab2.Retrieve(ls_frdt, ls_todt, ls_site_id)
	ll_ret = tab_1.tabpage_3.dw_tab3.Retrieve(ls_frdt, ls_todt, ls_site_id)
End If
end event

event wue_lastinst;call super::wue_lastinst;String	ls_fr, ls_to
datetime	ldt_date

dw_cond.Insertrow(0)

ldt_date = fw_f_getymdhh24miss4d()
ls_fr		= String( ldt_date, 'yyyymm' ) + '01'
ls_to	= String( ldt_date, 'yyyymmdd' )

dw_cond.SetItem(1, 'fr_dt', ls_fr)
dw_cond.SetItem(1, 'to_dt', ls_to)

p_retrieve.Post Event Clicked()
end event

type ln_templeft from w_window1st5cn`ln_templeft within fw_w_pgm_logs
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within fw_w_pgm_logs
end type

type ln_temptop from w_window1st5cn`ln_temptop within fw_w_pgm_logs
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within fw_w_pgm_logs
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within fw_w_pgm_logs
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within fw_w_pgm_logs
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within fw_w_pgm_logs
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within fw_w_pgm_logs
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within fw_w_pgm_logs
end type

type ln_tempright from w_window1st5cn`ln_tempright within fw_w_pgm_logs
end type

type uo_navi from w_window1st5cn`uo_navi within fw_w_pgm_logs
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within fw_w_pgm_logs
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within fw_w_pgm_logs
end type

type p_close from w_window1st5cn`p_close within fw_w_pgm_logs
end type

type p_excel from w_window1st5cn`p_excel within fw_w_pgm_logs
end type

type p_print from w_window1st5cn`p_print within fw_w_pgm_logs
end type

type p_delete from w_window1st5cn`p_delete within fw_w_pgm_logs
end type

type p_update from w_window1st5cn`p_update within fw_w_pgm_logs
end type

type p_input from w_window1st5cn`p_input within fw_w_pgm_logs
end type

type p_retrieve from w_window1st5cn`p_retrieve within fw_w_pgm_logs
end type

type p_clear from w_window1st5cn`p_clear within fw_w_pgm_logs
end type

type dw_cond from w_window1st5cn`dw_cond within fw_w_pgm_logs
string dataobject = "fw_d_pgm_logs_c0"
end type

event dw_cond::clicked;call super::clicked;Choose Case dwo.name
	Case 'p_fr'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.fr_dt, row)
	Case 'p_to'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.to_dt, row)
End Choose
end event

type tab_1 from tab within fw_w_pgm_logs
integer x = 46
integer y = 356
integer width = 5385
integer height = 2408
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 116
integer width = 5349
integer height = 2276
string text = "기간별통계"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
dw_tab1 dw_tab1
end type

on tabpage_1.create
this.dw_tab1=create dw_tab1
this.Control[]={this.dw_tab1}
end on

on tabpage_1.destroy
destroy(this.dw_tab1)
end on

type dw_tab1 from u_dw within tabpage_1
integer x = 50
integer y = 24
integer width = 5266
integer height = 2236
integer taborder = 130
boolean bringtotop = true
string dataobject = "fw_d_pgm_logs_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
end type

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'description'
		pf_f_togglekoreng('k')
	Case Else
		pf_f_togglekoreng('e')
End Choose
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 116
integer width = 5349
integer height = 2276
string text = "일자별통계"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
dw_tab2 dw_tab2
end type

on tabpage_2.create
this.dw_tab2=create dw_tab2
this.Control[]={this.dw_tab2}
end on

on tabpage_2.destroy
destroy(this.dw_tab2)
end on

type dw_tab2 from u_dw within tabpage_2
integer x = 50
integer y = 24
integer width = 5266
integer height = 2236
integer taborder = 120
boolean bringtotop = true
string dataobject = "fw_d_pgm_logs_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
end type

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'description'
		pf_f_togglekoreng('k')
	Case Else
		pf_f_togglekoreng('e')
End Choose
end event

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 116
integer width = 5349
integer height = 2276
string text = "기간별리스트"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
dw_tab3 dw_tab3
end type

on tabpage_3.create
this.dw_tab3=create dw_tab3
this.Control[]={this.dw_tab3}
end on

on tabpage_3.destroy
destroy(this.dw_tab3)
end on

type dw_tab3 from u_dw within tabpage_3
integer x = 50
integer y = 24
integer width = 5266
integer height = 2236
integer taborder = 110
boolean bringtotop = true
string dataobject = "fw_d_pgm_logs_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
end type

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'description'
		pf_f_togglekoreng('k')
	Case Else
		pf_f_togglekoreng('e')
End Choose
end event

type uo_tab from pf_u_tab within fw_w_pgm_logs
integer x = 1559
integer y = 340
integer width = 1147
integer taborder = 100
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_1"
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

