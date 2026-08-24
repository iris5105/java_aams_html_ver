forward
global type wt_tablist from w_winpage
end type
type tab_subpage from tab within wt_tablist
end type
type tab_subpage from tab within wt_tablist
end type
type dw_list from u_dw within wt_tablist
end type
type uo_tab from pf_u_tab within wt_tablist
end type
type st_tab_move from pf_u_splitbar_horizontal within wt_tablist
end type
end forward

global type wt_tablist from w_winpage
event ue_condchanged ( )
tab_subpage tab_subpage
dw_list dw_list
uo_tab uo_tab
st_tab_move st_tab_move
end type
global wt_tablist wt_tablist

type variables

end variables

forward prototypes
public function integer uf_update (tab atab)
public subroutine of_sethotkey (string as_hotkey)
public subroutine of_initbutton_after ()
end prototypes

event ue_condchanged();// 조건변경시 setredraw 문제 해결을 위해 event 생성
end event

public function integer uf_update (tab atab);INT ll

BOOLEAN	lb_modified=FALSE

FOR  ll=1  TO  UpperBound (aTab.Control [])
   IF aTab.Control [ll].DYNAMIC EVENT ue_subpage_modified ()  Then
		lb_modified = TRUE
      IF aTab.Control [ll].DYNAMIC EVENT ue_subpage_update ()=-1 Then
         aTab.SelectTab (ll)
         RETURN -1
      End IF
   End IF
NEXT

IF lb_modified	THEN gw_mdi.setmicrohelp (string (Now ()) + ' -> [' + TITLE + '] commit')

RETURN 1 // Update_Success
end function

public subroutine of_sethotkey (string as_hotkey);Choose Case as_hotkey
	Case 'A','i','B','D','F','S','T','P','Q'
		of_sethotkey4copy(as_hotkey)
	Case 'F5'
		If p_clear.visible = true Then p_clear.Event Clicked()
	Case 'F6'
		If p_retrieve.visible = true Then p_retrieve.Event Clicked()
End Choose
end subroutine

public subroutine of_initbutton_after ();// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn THEN dw_list.eb_new_false = TRUE
IF	NOT gnv_authorbtn.ib_cpybtn_yn THEN dw_list.eb_copy_false = TRUE
IF	NOT gnv_authorbtn.ib_delbtn_yn THEN dw_list.eb_delete_false = TRUE
end subroutine

on wt_tablist.create
int iCurrent
call super::create
this.tab_subpage=create tab_subpage
this.dw_list=create dw_list
this.uo_tab=create uo_tab
this.st_tab_move=create st_tab_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_subpage
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.uo_tab
this.Control[iCurrent+4]=this.st_tab_move
end on

on wt_tablist.destroy
call super::destroy
destroy(this.tab_subpage)
destroy(this.dw_list)
destroy(this.uo_tab)
destroy(this.st_tab_move)
end on

event ue_activate;call super::ue_activate;uo_tab.of_selecttab (tab_subpage.SelectedTab)
uo_tab.of_activatetab (tab_subpage.SelectedTab)
end event

event ue_wpage_modified;BOOLEAN  lb_update = FALSE

INT   lControl, lTab

IF dw_List.uf_isModified () THEN RETURN TRUE

lControl = UpperBound (tab_subpage.Control [])
FOR  lTab = 1  TO  lControl
   IF tab_subpage.Control [lTab].DYNAMIC EVENT ue_subpage_modified () THEN lb_update = TRUE
NEXT
RETURN   lb_update
end event

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
tab_subpage.TabTriggerEvent ('ue_subpage_reset_flag')
IF dw_c.dataobject>'' And ib_manageData   Then
	tab_subpage.TabTriggerEvent ('ue_subpage_reset')
	dw_list.uf_clear ()

	p_retrieve.of_setenabled (true)
	EVENT ue_setdisabled ()

	IF	dw_c.describe ('p_visible.type')='column' THEN dw_c.setitem (1, 'p_visible', 1)
	dw_c.Enabled = TRUE
	dw_c.SetFocus () ; f_selectText (dw_c)
	RETURN
End IF
IF	eb_direct_retrieve THEN p_retrieve.POST EVENT clicked ()
end event

event wue_lastopen;call super::wue_lastopen;dw_list.post event ue_dddw_retrieve ()
tab_subpage.TabTriggerEvent ('ue_subpage_open')
tab_subpage.TabPostEvent ('ue_dddw_retrieve')
IF	eb_direct_retrieve	Then
   //<임시> 탭화면 오픈중 죽는경우 
	IF	eb_retrievewait=FALSE	Then
		gw_mdi.of_sheetwait (TRUE)
		tab_subpage.enabled = FALSE
	End IF
	p_retrieve.post event clicked ()
Else
	dw_List.uf_clear ()
End IF
end event

event wue_lastinst;call super::wue_lastinst;dw_List.setTransObject (SQLCA)
end event

event wue_copy;call super::wue_copy;RETURN dw_list.EVENT ue_copyrow ()
end event

event wue_update;IF dw_List.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_modified () Then
   IF uf_update (tab_subpage)=-1   THEN RETURN -1
	IF	uf_updateCommit (dw_List)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event ue_setenabled;p_input.of_setenabled ((dw_list.eb_new_false=FALSE And ib_managedata))
p_copy.of_setenabled ((dw_list.eb_copy_false=FALSE And ib_managedata))
p_update.of_setenabled (EVENT ue_wpage_updatetable ())
p_delete.of_setenabled ((dw_list.eb_delete_false=FALSE And ib_managedata))
end event

event wue_retrieve;call super::wue_retrieve;//<임시> 탭화면 오픈중 죽는경우 
IF eb_direct_retrieve AND eb_retrievewait=FALSE	THEN gw_mdi.post of_sheetwait (FALSE)
end event

event resize;call super::resize;uo_tab.y = tab_subpage.y
uo_tab.width = newwidth
end event

event ue_wpage_updatetable;BOOLEAN  lb_update = FALSE

INT   lControl, lTab

IF dw_List.uf_isupdatetable () THEN RETURN TRUE

lControl = UpperBound (tab_subpage.Control [])
FOR  lTab = 1  TO  lControl
   IF tab_subpage.Control [lTab].DYNAMIC EVENT ue_subpage_updatetable () THEN lb_update = TRUE
NEXT
RETURN   lb_update
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_tablist
end type

type ln_templeft from w_winpage`ln_templeft within wt_tablist
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_tablist
end type

type ln_temptop from w_winpage`ln_temptop within wt_tablist
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_tablist
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_tablist
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_tablist
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_tablist
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_tablist
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_tablist
end type

type ln_tempright from w_winpage`ln_tempright within wt_tablist
end type

type uo_navi from w_winpage`uo_navi within wt_tablist
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_tablist
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_tablist
end type

type st_top_rect from w_winpage`st_top_rect within wt_tablist
end type

type p_close from w_winpage`p_close within wt_tablist
end type

type p_excel from w_winpage`p_excel within wt_tablist
end type

type p_print from w_winpage`p_print within wt_tablist
end type

type p_delete from w_winpage`p_delete within wt_tablist
end type

type p_update from w_winpage`p_update within wt_tablist
end type

type p_input from w_winpage`p_input within wt_tablist
end type

type p_retrieve from w_winpage`p_retrieve within wt_tablist
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
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
End IF

IF	dw_c.EVENT ue_valid ()=FALSE	Then
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
	dw_List.uf_protect (0, dw_List.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2])
End IF

dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

//call super::clicked
Parent.PostEvent("wue_retrieve2ready")
end event

type p_clear from w_winpage`p_clear within wt_tablist
end type

type p_copy from w_winpage`p_copy within wt_tablist
end type

type dw_c from w_winpage`dw_c within wt_tablist
end type

type btn_update from w_winpage`btn_update within wt_tablist
end type

type st_count from w_winpage`st_count within wt_tablist
end type

type tab_subpage from tab within wt_tablist
string tag = "wt_tablist"
integer x = 50
integer y = 1536
integer width = 5381
integer height = 1228
integer taborder = 30
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
   control [newindex].TriggerEvent ('ue_subpage_selected')
   IF gaa.debug THEN gw_mdi.setmicrohelp (string (Now ()) + 'tab_subpage selectionchanged')
End IF
end event

type dw_list from u_dw within wt_tablist
integer x = 50
integer y = 348
integer width = 5381
integer height = 1148
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

INT   lControl, lTab

lControl = UpperBound (tab_subpage.Control [])
FOR  lTab = 1  TO  lControl
   tab_subpage.Control [lTab].DYNAMIC EVENT ue_subpage_initall (dwo.name, data)
NEXT
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
uf_enabled (eb_rowchangewait, false)
tab_subpage.setredraw (false)
tab_subpage.TabTriggerEvent ('ue_subpage_reset_flag')
tab_subpage.TabTriggerEvent ('ue_subpage_selected')
tab_subpage.setredraw (true)
iw_parent.dynamic of_setfocusdw (this)
uf_enabled (eb_rowchangewait, true)
RETURN 0
end event

event rowfocuschanging_return;IF uf_update (tab_subpage)=-1	Then
	RETURN 1
End IF
RETURN 0
end event

event ue_copystart;IF uf_Update (tab_subpage)=-1 THEN RETURN 1
RETURN 0
end event

event ue_deletestart;INT   lTab

FOR  lTab = 1  TO  UpperBound (tab_subpage.Control [])
   tab_subpage.Control [lTab].DYNAMIC EVENT ue_subpage_deleteall ()
NEXT

RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF uf_Update (tab_subpage)=-1 THEN RETURN 1
tab_subpage.TabTriggerEvent ('ue_subpage_reset')
tab_subpage.TabTriggerEvent ('ue_subpage_reset_flag')
RETURN 0
end event

event ue_copyrow;INT   lControl, lTab

Enabled = FALSE
iRow = rowcount () + 1 ; RowsCopy (GetRow (), GetRow (),  Primary!, THIS, iRow, Primary!)
uf_setrow (iRow, true)
lControl = UpperBound (tab_subpage.Control [])
FOR  lTab = 1  TO  lControl
   tab_subpage.Control [lTab].DYNAMIC EVENT ue_subpage_copyall ()
NEXT

RETURN 0
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type uo_tab from pf_u_tab within wt_tablist
integer x = 59
integer y = 1752
integer width = 1001
integer height = 200
integer taborder = 30
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_subpage"
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

type st_tab_move from pf_u_splitbar_horizontal within wt_tablist
integer x = 55
integer y = 1504
integer width = 5381
boolean setcondcolor = true
string topdragobject = "dw_list"
string bottomdragobject = "tab_subpage;uo_tab"
end type

