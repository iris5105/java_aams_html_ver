forward
global type wt_listole from w_winpage
end type
type dw_list from u_dw within wt_listole
end type
type st_move from pf_u_splitbar_horizontal within wt_listole
end type
type ole_rd from u_rd within wt_listole
end type
type rb_onepage from pf_u_radiobutton within wt_listole
end type
end forward

global type wt_listole from w_winpage
boolean ib_managedata = false
dw_list dw_list
st_move st_move
ole_rd ole_rd
rb_onepage rb_onepage
end type
global wt_listole wt_listole

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

on wt_listole.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.st_move=create st_move
this.ole_rd=create ole_rd
this.rb_onepage=create rb_onepage
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.st_move
this.Control[iCurrent+3]=this.ole_rd
this.Control[iCurrent+4]=this.rb_onepage
end on

on wt_listole.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.st_move)
destroy(this.ole_rd)
destroy(this.rb_onepage)
end on

event open;call super::open;IF	gaa.aams THEN rb_onepage.checked = ole_rd.eb_onepage
end event

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
IF dw_c.dataobject>'' And ib_manageData   Then
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

event wue_lastopen;call super::wue_lastopen;IF dw_list.dataobject>''	Then
	dw_list.uf_clear ()
	dw_list.event ue_dddw_retrieve ()
End IF
IF	eb_direct_retrieve THEN p_retrieve.post event clicked ()
end event

event wue_update;IF dw_list.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_modified ()	Then
	IF	uf_updateCommit (dw_list)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event resize;call super::resize;rb_onepage.X = ole_rd.X + 1236
rb_onepage.Y = ole_rd.Y + 24
end event

event wue_postopen;call super::wue_postopen;rb_onepage.X = ole_rd.X + 1236
rb_onepage.Y = ole_rd.Y + 24
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_listole
end type

type ln_templeft from w_winpage`ln_templeft within wt_listole
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_listole
end type

type ln_temptop from w_winpage`ln_temptop within wt_listole
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_listole
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_listole
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_listole
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_listole
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_listole
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_listole
end type

type ln_tempright from w_winpage`ln_tempright within wt_listole
end type

type uo_navi from w_winpage`uo_navi within wt_listole
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_listole
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_listole
end type

type st_top_rect from w_winpage`st_top_rect within wt_listole
end type

type p_close from w_winpage`p_close within wt_listole
end type

type p_excel from w_winpage`p_excel within wt_listole
end type

type p_print from w_winpage`p_print within wt_listole
end type

type p_delete from w_winpage`p_delete within wt_listole
end type

type p_update from w_winpage`p_update within wt_listole
end type

type p_input from w_winpage`p_input within wt_listole
end type

type p_retrieve from w_winpage`p_retrieve within wt_listole
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF	p_clear.visible=false	Then
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
End IF

IF	dw_c.EVENT ue_valid ()=FALSE	Then
   dw_c.SetFocus ()
   RETURN
End IF

IF	dw_List.Visible	Then
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
Else
   ole_rd.EVENT ue_retrieve (1)
	ole_rd.POST setredraw (true)
End IF
end event

type p_clear from w_winpage`p_clear within wt_listole
end type

type p_copy from w_winpage`p_copy within wt_listole
end type

type dw_c from w_winpage`dw_c within wt_listole
end type

type btn_update from w_winpage`btn_update within wt_listole
end type

type st_count from w_winpage`st_count within wt_listole
end type

type dw_list from u_dw within wt_listole
boolean visible = false
integer x = 50
integer y = 348
integer width = 5381
integer height = 1252
integer taborder = 30
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean ibsetlist4excelclip = true
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;iRow = currentrow
uf_enabled (eb_rowchangewait, false)
ole_rd.event ue_retrieve (currentrow)
ole_rd.POST setredraw (true)
uf_enabled (eb_rowchangewait, true)
RETURN 0
end event

event ue_print;LONG	lRow, lOld

Boolean  lb1, lb2

IF	uf_getrange ()	Then
   lb1 = ole_rd.eb_DirectPrint ; lb2 = ole_rd.eb_OnePage
   ole_rd.eb_DirectPrint = TRUE ; ole_rd.eb_OnePage = FALSE // OnePage설정시 대화상자가 뜨므로
   lRow = GetSelectedRow (0)
   DO WHILE TRUE
      ole_rd.EVENT ue_retrieve (lRow)
      SelectRow (lRow, FALSE) ; lOld = lRow
      lRow = GetSelectedRow (lRow) ; IF lRow=0 THEN EXIT
   LOOP
   ole_rd.eb_DirectPrint = lb1 ; ole_rd.eb_OnePage = lb2
   uf_setrow (lOld, true)
Else
   ole_rd.object.CMPrint ()
End IF
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type st_move from pf_u_splitbar_horizontal within wt_listole
integer x = 55
integer y = 1604
integer width = 5381
boolean setcondcolor = true
string topdragobject = "dw_list"
string bottomdragobject = "ole_rd"
end type

event mousemove;call super::mousemove;IF	visible	Then
	rb_onepage.X = ole_rd.X + 1236
	rb_onepage.Y = ole_rd.Y + 24
End IF
end event

event constructor;visible = dw_list.visible
IF	visible THEN call super::constructor
end event

type ole_rd from u_rd within wt_listole
integer x = 50
integer y = 1632
integer width = 5381
integer height = 1132
integer taborder = 50
boolean bringtotop = true
string binarykey = "wt_listole.win"
boolean scaletoright = true
boolean scaletobottom = true
end type

event reportfinished;call super::reportfinished;rb_onepage.Checked = eb_OnePage
end event

type rb_onepage from pf_u_radiobutton within wt_listole
integer x = 4850
integer y = 1636
integer width = 315
integer height = 80
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 32567536
string text = "OnePage"
boolean automatic = false
boolean setbringtotop = true
boolean setcondcolor = true
end type

event clicked;Checked = NOT Checked
ole_rd.eb_OnePage = Checked
p_retrieve.post event clicked ()
end event

