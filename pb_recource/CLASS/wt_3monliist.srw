forward
global type wt_3monliist from w_winpage
end type
type uo_plan from u_plan within wt_3monliist
end type
type dw_list from u_dw within wt_3monliist
end type
type st_move from pf_u_splitbar_vertical within wt_3monliist
end type
end forward

global type wt_3monliist from w_winpage
boolean confirmsheetbackcolor = false
uo_plan uo_plan
dw_list dw_list
st_move st_move
end type
global wt_3monliist wt_3monliist

type variables
DataStore	ids_scheduler_data
DataStore	ids_scheduler_calendar
end variables

forward prototypes
public subroutine of_bringtotop (boolean ab_value)
end prototypes

public subroutine of_bringtotop (boolean ab_value);this.BringToTop = ab_value
end subroutine

on wt_3monliist.create
int iCurrent
call super::create
this.uo_plan=create uo_plan
this.dw_list=create dw_list
this.st_move=create st_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_plan
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.st_move
end on

on wt_3monliist.destroy
call super::destroy
destroy(this.uo_plan)
destroy(this.dw_list)
destroy(this.st_move)
end on

event wue_update;call super::wue_update;IF	dw_List.AcceptText ()=-1	Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	EVENT ue_wpage_modified ()	Then
	IF	uf_updateCommit (dw_List)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event wue_lastopen;call super::wue_lastopen;dw_list.post event ue_dddw_retrieve ()
IF	eb_direct_retrieve	Then
	p_retrieve.post event clicked ()
Else
	dw_list.uf_clear ()
End IF
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
IF	dw_c.dataobject>'' And ib_manageData	Then
	dw_list.uf_clear ()

	p_retrieve.of_setenabled (true)
	EVENT ue_setdisabled ()

	dw_c.Enabled = TRUE
	dw_c.SetFocus () ; f_selectText (dw_c)
	RETURN
End IF
IF	eb_direct_retrieve THEN p_retrieve.POST EVENT clicked ()
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_3monliist
end type

type ln_templeft from w_winpage`ln_templeft within wt_3monliist
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_3monliist
end type

type ln_temptop from w_winpage`ln_temptop within wt_3monliist
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_3monliist
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_3monliist
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_3monliist
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_3monliist
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_3monliist
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_3monliist
end type

type ln_tempright from w_winpage`ln_tempright within wt_3monliist
end type

type uo_navi from w_winpage`uo_navi within wt_3monliist
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_3monliist
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_3monliist
end type

type st_top_rect from w_winpage`st_top_rect within wt_3monliist
end type

type p_close from w_winpage`p_close within wt_3monliist
end type

type p_excel from w_winpage`p_excel within wt_3monliist
end type

type p_print from w_winpage`p_print within wt_3monliist
end type

type p_delete from w_winpage`p_delete within wt_3monliist
end type

type p_update from w_winpage`p_update within wt_3monliist
end type

type p_input from w_winpage`p_input within wt_3monliist
end type

type p_retrieve from w_winpage`p_retrieve within wt_3monliist
end type

type p_clear from w_winpage`p_clear within wt_3monliist
end type

type p_copy from w_winpage`p_copy within wt_3monliist
end type

type dw_c from w_winpage`dw_c within wt_3monliist
end type

type btn_update from w_winpage`btn_update within wt_3monliist
end type

type st_count from w_winpage`st_count within wt_3monliist
end type

type uo_plan from u_plan within wt_3monliist
integer x = 50
integer y = 348
integer height = 2416
integer taborder = 40
boolean bringtotop = true
boolean scaletobottom = true
end type

on uo_plan.destroy
call u_plan::destroy
end on

type dw_list from u_dw within wt_3monliist
integer x = 1861
integer y = 348
integer width = 3570
integer height = 2416
integer taborder = 50
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean eb_range_delcopy = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
RETURN 0
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type st_move from pf_u_splitbar_vertical within wt_3monliist
integer x = 1833
integer y = 348
integer height = 2416
boolean bringtotop = true
boolean setcondcolor = true
string leftdragobject = "uo_plan"
string rightdragobject = "dw_list"
end type

event constructor;call super::constructor;IF	dw_list.zoominout THEN ii_rightmargin += PixelsToUnits(12, XPixelsToUnits!)
end event

