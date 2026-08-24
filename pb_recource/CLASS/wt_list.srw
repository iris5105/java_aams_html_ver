forward
global type wt_list from w_winpage
end type
type dw_list from u_dw within wt_list
end type
end forward

global type wt_list from w_winpage
dw_list dw_list
end type
global wt_list wt_list

type variables

end variables

forward prototypes
public subroutine of_initbutton_after ()
end prototypes

public subroutine of_initbutton_after ();// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn THEN dw_list.eb_new_false = TRUE
IF	NOT gnv_authorbtn.ib_cpybtn_yn THEN dw_list.eb_copy_false = TRUE
IF	NOT gnv_authorbtn.ib_delbtn_yn THEN dw_list.eb_delete_false = TRUE
end subroutine

on wt_list.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on wt_list.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
IF	dw_c.dataobject>'' And ib_manageData	Then
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

event wue_update;IF	dw_List.AcceptText ()=-1	Then
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

type lb_dirlist from w_winpage`lb_dirlist within wt_list
end type

type ln_templeft from w_winpage`ln_templeft within wt_list
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_list
end type

type ln_temptop from w_winpage`ln_temptop within wt_list
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_list
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_list
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_list
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_list
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_list
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_list
end type

type ln_tempright from w_winpage`ln_tempright within wt_list
end type

type uo_navi from w_winpage`uo_navi within wt_list
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_list
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_list
end type

type st_top_rect from w_winpage`st_top_rect within wt_list
end type

type p_close from w_winpage`p_close within wt_list
end type

type p_excel from w_winpage`p_excel within wt_list
end type

type p_print from w_winpage`p_print within wt_list
end type

type p_delete from w_winpage`p_delete within wt_list
end type

type p_update from w_winpage`p_update within wt_list
end type

type p_input from w_winpage`p_input within wt_list
end type

type p_retrieve from w_winpage`p_retrieve within wt_list
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF	p_clear.visible=false	Then
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
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
	dw_List.uf_protect (0, dw_List.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2])
End IF

dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within wt_list
end type

type p_copy from w_winpage`p_copy within wt_list
end type

type dw_c from w_winpage`dw_c within wt_list
end type

type btn_update from w_winpage`btn_update within wt_list
end type

type st_count from w_winpage`st_count within wt_list
end type

type dw_list from u_dw within wt_list
integer x = 50
integer y = 348
integer width = 5381
integer height = 2416
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4excelclip = true
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

