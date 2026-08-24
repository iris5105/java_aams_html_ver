forward
global type w_cron_q from w_winpage
end type
type mle_in_param from u_mle within w_cron_q
end type
type st_move from pf_u_splitbar_horizontal within w_cron_q
end type
type dw_list from u_dw within w_cron_q
end type
type st_1 from pf_u_splitbar_vertical within w_cron_q
end type
type dw_status from u_dw within w_cron_q
end type
end forward

global type w_cron_q from w_winpage
boolean eb_direct_retrieve = true
integer ii_dddw_width = 1000
mle_in_param mle_in_param
st_move st_move
dw_list dw_list
st_1 st_1
dw_status dw_status
end type
global w_cron_q w_cron_q

type variables
//BOOLEAN	ib_update = FALSE
end variables

on w_cron_q.create
int iCurrent
call super::create
this.mle_in_param=create mle_in_param
this.st_move=create st_move
this.dw_list=create dw_list
this.st_1=create st_1
this.dw_status=create dw_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_in_param
this.Control[iCurrent+2]=this.st_move
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_status
end on

on w_cron_q.destroy
call super::destroy
destroy(this.mle_in_param)
destroy(this.st_move)
destroy(this.dw_list)
destroy(this.st_1)
destroy(this.dw_status)
end on

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN

iRow = 0

dw_list.uf_reset (FALSE)
dw_list.Modify (dw_List.ia_protect [4])
dw_list.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)

mle_IN_PARAM.uf_init ('', ib_ManageData)
end event

event ue_activate;call super::ue_activate;mle_IN_PARAM.BACKCOLOR = RGB (240, 255, 255)
end event

event wue_update;call super::wue_update;IF dw_list.ACCEPTTEXT () = -1 Then
   F_MESSAGEBOX ('W006', '')
   RETURN -1
END IF

IF mle_IN_PARAM.ib_update THEN dw_list.object.IN_PARAM [iRow] = mle_IN_PARAM.TEXT

IF EVENT ue_wpage_Modified () Then
   IF uf_UpdateCommit (dw_list)=-1 THEN RETURN -1
   mle_IN_PARAM.ib_update  = FALSE
END IF
RETURN 1
end event

event wue_retrieve;call super::wue_retrieve;mle_IN_PARAM.uf_init ('', ib_ManageData)
dw_list.retrieve ()
end event

event ue_wpage_modified;IF dw_list.uf_isModified ()=FALSE And mle_in_param.ib_update=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_lastopen;call super::wue_lastopen;p_retrieve.post event clicked ()
end event

type lb_dirlist from w_winpage`lb_dirlist within w_cron_q
end type

type ln_templeft from w_winpage`ln_templeft within w_cron_q
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_cron_q
end type

type ln_temptop from w_winpage`ln_temptop within w_cron_q
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_cron_q
end type

type ln_tempstart from w_winpage`ln_tempstart within w_cron_q
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_cron_q
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_cron_q
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_cron_q
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_cron_q
end type

type ln_tempright from w_winpage`ln_tempright within w_cron_q
end type

type uo_navi from w_winpage`uo_navi within w_cron_q
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_cron_q
end type

type st_windelaytime from w_winpage`st_windelaytime within w_cron_q
end type

type st_top_rect from w_winpage`st_top_rect within w_cron_q
end type

type p_close from w_winpage`p_close within w_cron_q
end type

type p_excel from w_winpage`p_excel within w_cron_q
end type

type p_print from w_winpage`p_print within w_cron_q
end type

type p_delete from w_winpage`p_delete within w_cron_q
end type

type p_update from w_winpage`p_update within w_cron_q
end type

type p_input from w_winpage`p_input within w_cron_q
end type

type p_retrieve from w_winpage`p_retrieve within w_cron_q
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
IF	p_clear.visible	Then
	p_clear.of_setenabled (true)
	of_setenabled (false)
End IF
dw_List.uf_protect (0, dw_List.ia_protect [1])

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_cron_q
end type

type p_copy from w_winpage`p_copy within w_cron_q
end type

type dw_c from w_winpage`dw_c within w_cron_q
boolean visible = false
boolean enabled = false
string title = ""
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

type btn_update from w_winpage`btn_update within w_cron_q
end type

type st_count from w_winpage`st_count within w_cron_q
end type

type mle_in_param from u_mle within w_cron_q
integer x = 50
integer y = 2256
integer width = 5381
integer height = 508
integer taborder = 70
boolean bringtotop = true
fontpitch fontpitch = fixed!
string facename = "D2Coding"
string text = "IN_PARAM"
boolean hscrollbar = true
boolean autovscroll = false
boolean scaletoright = true
boolean scaletobottom = true
end type

event constructor;//
end event

event key;ib_update = TRUE

STRING	ls_data

LONG	lPos

lPos = Position ()

IF keyflags=2	Then
	CHOOSE CASE key
		CASE KeyRightArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,true))
			RETURN 1
		CASE KeyLeftArrow!
			SelectText (1, lPos - 1)
			COPY ()
			ls_data = Clipboard ()
			ReplaceText (f_tab (2,ls_data,false))
			RETURN 1
		CASE KeyY!
			SelectText (POS (TEXT, TextLine ()), Len (TextLine ()) + 1)
			clear ()
			RETURN
		CASE KeyZ!
			undo ()
			RETURN
	END CHOOSE
	RETURN 1
END IF
end event

type st_move from pf_u_splitbar_horizontal within w_cron_q
integer x = 50
integer y = 2236
integer width = 5381
boolean bringtotop = true
boolean setcondcolor = true
string topdragobject = "dw_list;st_1;dw_status"
string bottomdragobject = "mle_in_param"
end type

type dw_list from u_dw within w_cron_q
integer x = 50
integer y = 152
integer width = 3525
integer height = 2076
integer taborder = 55
boolean bringtotop = true
string dataobject = "d_cron_q"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
string is_receivetype = "sqlm"
boolean scaletoright = true
boolean ibsettooltiphelp = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;mle_in_param.BACKCOLOR = RGB (240, 255, 255)

iRow = currentrow

STRING ls_data

ls_data = Object.in_param [iRow]  ; mle_in_param.TEXT  = f_tab (2,ls_data, false)

dw_status.setredraw (false)
dw_status.uf_reset ()
dw_status.event ue_retrieve ()

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_IN_PARAM.uf_reset (TRUE)
RETURN 0
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;IF mle_IN_PARAM.ib_update THEN Object.IN_PARAM [iRow] = mle_IN_PARAM.TEXT
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF mle_IN_PARAM.ib_update THEN Object.IN_PARAM [iRow] = mle_IN_PARAM.TEXT

mle_IN_PARAM.ib_update  = FALSE

POST SetColumn ('cron_key')

RETURN 0
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow=0 OR NOT Enabled THEN RETURN
iRow = currentrow
end event

type st_1 from pf_u_splitbar_vertical within w_cron_q
integer x = 3579
integer y = 156
integer height = 2076
boolean bringtotop = true
boolean setcondcolor = true
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list"
string rightdragobject = "dw_status"
end type

type dw_status from u_dw within w_cron_q
integer x = 3602
integer y = 152
integer width = 1829
integer height = 2076
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_cron_status"
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean eb_range_delcopy = false
string is_resize_column = "out_param"
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.cron_key [iRow])
end event

