forward
global type wt_tab from w_winpage
end type
type tab_subpage from tab within wt_tab
end type
type tab_subpage from tab within wt_tab
end type
type uo_tab from pf_u_tab within wt_tab
end type
end forward

global type wt_tab from w_winpage
event ue_condchanged ( )
tab_subpage tab_subpage
uo_tab uo_tab
end type
global wt_tab wt_tab

type variables

end variables

forward prototypes
public subroutine of_sethotkey (string as_hotkey)
end prototypes

event ue_condchanged();// 조건변경시 setredraw 문제 해결을 위해 event 생성
end event

public subroutine of_sethotkey (string as_hotkey);Choose Case as_hotkey
	Case 'A','i','B','D','F','S','T','P','Q'
		of_sethotkey4copy(as_hotkey)
	Case 'F5'
		If p_clear.visible = true Then p_clear.Event Clicked()
	Case 'F6'
		If p_retrieve.visible = true Then p_retrieve.Event Clicked()
End Choose
end subroutine

on wt_tab.create
int iCurrent
call super::create
this.tab_subpage=create tab_subpage
this.uo_tab=create uo_tab
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_subpage
this.Control[iCurrent+2]=this.uo_tab
end on

on wt_tab.destroy
call super::destroy
destroy(this.tab_subpage)
destroy(this.uo_tab)
end on

event wue_retrieve;IF	dw_c.visible And dw_c.setedittoken And ib_managedata THEN dw_c.EVENT oue_setedittoken44()
// 자료를 조회하기 위한 준비
tab_subpage.TabTriggerEvent ('ue_subpage_reset')
tab_subpage.TabTriggerEvent ('ue_subpage_reset_flag')
//tab_subpage.Control [tab_subpage.SelectedTab].PostEvent ('ue_subpage_selected')
//<임시> 탭화면 오픈중 죽는경우
tab_subpage.Control [tab_subpage.SelectedTab].triggerEvent ('ue_subpage_selected')
IF eb_direct_retrieve AND eb_retrievewait=FALSE	THEN gw_mdi.post of_sheetwait (FALSE)
tab_subpage.enabled = true
end event

event ue_activate;call super::ue_activate;uo_tab.of_selecttab (tab_subpage.SelectedTab)
uo_tab.of_activatetab (tab_subpage.SelectedTab)
end event

event ue_wpage_modified;RETURN tab_subpage.Control [tab_subpage.SelectedTab].DYNAMIC EVENT ue_subpage_modified ()
end event

event wue_clear;call super::wue_clear;IF tab_subpage.Control [tab_subpage.SelectedTab].DYNAMIC EVENT ue_subpage_updatequery ()=1 THEN RETURN
tab_subpage.TabTriggerEvent ('ue_subpage_reset_flag')

IF dw_c.dataobject>'' And ib_manageData   Then
	tab_subpage.TabTriggerEvent ('ue_subpage_reset')

	p_retrieve.of_setenabled (true)
	EVENT ue_setdisabled ()

	IF	dw_c.describe ('p_visible.type')='column' THEN dw_c.setitem (1, 'p_visible', 1)
	dw_c.Enabled = TRUE
	dw_c.SetFocus () ; f_selectText (dw_c)
Else
	IF	eb_direct_retrieve THEN p_retrieve.POST EVENT clicked ()
End IF
end event

event wue_lastopen;call super::wue_lastopen;tab_subpage.TabTriggerEvent ('ue_subpage_open')
tab_subpage.TabPostEvent ('ue_dddw_retrieve')
IF	eb_direct_retrieve	Then
   //<임시> 탭화면 오픈중 죽는경우 
	IF	eb_retrievewait=FALSE	Then
		gw_mdi.of_sheetwait (TRUE)
		tab_subpage.enabled = FALSE
	End IF
	p_retrieve.post event clicked ()
End IF
end event

event wue_input;IF uo_tab.of_selecttab (tab_subpage.SelectedTab)<>-1 THEN tab_subpage.Control [tab_subpage.SelectedTab].PostEvent ('wue_input')
return 0
end event

event wue_copy;IF uo_tab.of_selecttab (tab_subpage.SelectedTab)<>-1 THEN tab_subpage.Control [tab_subpage.SelectedTab].PostEvent ('wue_copy')
RETURN 0
end event

event wue_delete;IF uo_tab.of_selecttab (tab_subpage.SelectedTab)<>-1 THEN tab_subpage.Control [tab_subpage.SelectedTab].PostEvent ('wue_delete')
RETURN 0
end event

event wue_update;IF EVENT ue_wpage_modified ()   Then
   IF tab_subpage.Control [tab_subpage.SelectedTab].dynamic event ue_subpage_update ()=-1 THEN RETURN 1
   gw_mdi.setmicrohelp (string (Now ()) + ' -> ' + TAG + ' commit')
End IF
RETURN 0
end event

event activate;call super::activate;uo_tab.postevent ('ue_activate')
end event

event wue_saveas;IF uo_tab.of_selecttab (tab_subpage.SelectedTab)<>-1 THEN tab_subpage.Control [tab_subpage.SelectedTab].PostEvent ('wue_saveas')
end event

event ue_wpage_updatetable;RETURN tab_subpage.Control [tab_subpage.SelectedTab].DYNAMIC EVENT ue_subpage_updatetable ()
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_tab
end type

type ln_templeft from w_winpage`ln_templeft within wt_tab
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_tab
end type

type ln_temptop from w_winpage`ln_temptop within wt_tab
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_tab
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_tab
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_tab
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_tab
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_tab
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_tab
end type

type ln_tempright from w_winpage`ln_tempright within wt_tab
end type

type uo_navi from w_winpage`uo_navi within wt_tab
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_tab
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_tab
end type

type p_close from w_winpage`p_close within wt_tab
end type

type p_excel from w_winpage`p_excel within wt_tab
end type

type p_print from w_winpage`p_print within wt_tab
end type

type p_delete from w_winpage`p_delete within wt_tab
end type

type p_update from w_winpage`p_update within wt_tab
end type

type p_input from w_winpage`p_input within wt_tab
end type

type p_retrieve from w_winpage`p_retrieve within wt_tab
end type

event p_retrieve::clicked;//<임시> 탭페이지인 경우 로딩속도가 너무길어 처음 실행 시 로딩필요
// direct retrieve로 실행되는 경우에만 락프로세싱 통과
// direct retrieve 실행시 탭 enabled = FALSE로 잠시 상태변환
IF tab_subpage.enabled = TRUE	Then
	IF gw_mdi.of_lock4processing() = -1 Then
		RETURN
	End IF
Else
	tab_subpage.enabled = TRUE
End IF

IF	p_clear.visible=false	Then
	IF tab_subpage.Control [tab_subpage.SelectedTab].DYNAMIC EVENT ue_subpage_updatequery ()=1 THEN RETURN
End IF

IF dw_c.EVENT ue_valid ()=FALSE	Then
   dw_c.SetFocus ()
   RETURN
End IF

IF	ib_managedata	Then
	IF	dw_c.describe ('p_visible.type')='column' THEN dw_c.setitem (1, 'p_visible', 0)
   dw_c.Enabled = FALSE
	IF	p_clear.visible	Then
		p_clear.of_setenabled (true)
		of_setenabled (false)
	End IF
End IF

//call super::clicked
Parent.PostEvent("wue_retrieve2ready")
end event

type p_clear from w_winpage`p_clear within wt_tab
end type

type p_copy from w_winpage`p_copy within wt_tab
end type

type dw_c from w_winpage`dw_c within wt_tab
end type

type btn_update from w_winpage`btn_update within wt_tab
end type

type st_count from w_winpage`st_count within wt_tab
end type

type tab_subpage from tab within wt_tab
string tag = "wt_tab"
integer x = 50
integer y = 348
integer width = 5381
integer height = 2416
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long backcolor = 553648127
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
end type

event selectionchanged;IF newindex>0 And oldindex<>newindex And enabled	Then
   Control [newindex].TriggerEvent ('ue_subpage_selected')
   IF gaa.debug THEN gw_mdi.setmicrohelp (string (Now ()) + 'tab_1 selectionchanged')
End IF
end event

type uo_tab from pf_u_tab within wt_tab
integer x = 59
integer y = 864
integer width = 1001
integer height = 200
integer taborder = 40
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_subpage"
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

