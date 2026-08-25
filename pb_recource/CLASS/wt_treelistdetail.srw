forward
global type wt_treelistdetail from w_winpage
end type
type dw_list from u_dw within wt_treelistdetail
end type
type dw_detail from u_dw within wt_treelistdetail
end type
type st_hmove from pf_u_splitbar_horizontal within wt_treelistdetail
end type
type st_3 from pf_u_statictext within wt_treelistdetail
end type
type p_2 from pf_u_picture within wt_treelistdetail
end type
type tv_tree from pf_u_treeview within wt_treelistdetail
end type
type st_vmove from pf_u_splitbar_vertical within wt_treelistdetail
end type
end forward

global type wt_treelistdetail from w_winpage
event ue_treeview ( )
dw_list dw_list
dw_detail dw_detail
st_hmove st_hmove
st_3 st_3
p_2 p_2
tv_tree tv_tree
st_vmove st_vmove
end type
global wt_treelistdetail wt_treelistdetail

type variables
TreeViewItem	itvi_item, itvi_parent

LONG	ihandle, ihandle_parent
end variables

forward prototypes
public subroutine of_initbutton_after ()
end prototypes

public subroutine of_initbutton_after ();// (입력,복사,삭제)버튼 비활성화시 자동 초기화
IF	NOT gnv_authorbtn.ib_inpbtn_yn THEN dw_list.eb_new_false = TRUE
IF	NOT gnv_authorbtn.ib_cpybtn_yn THEN dw_list.eb_copy_false = TRUE
IF	NOT gnv_authorbtn.ib_delbtn_yn THEN dw_list.eb_delete_false = TRUE
end subroutine

on wt_treelistdetail.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.st_hmove=create st_hmove
this.st_3=create st_3
this.p_2=create p_2
this.tv_tree=create tv_tree
this.st_vmove=create st_vmove
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_hmove
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.tv_tree
this.Control[iCurrent+7]=this.st_vmove
end on

on wt_treelistdetail.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.st_hmove)
destroy(this.st_3)
destroy(this.p_2)
destroy(this.tv_tree)
destroy(this.st_vmove)
end on

event ue_wpage_modified;IF	dw_List.uf_isModified ()=FALSE And dw_Detail.uf_isModified ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
IF	dw_c.dataobject>'' And ib_manageData	Then
	dw_detail.uf_clear ()
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
dw_detail.post event ue_dddw_retrieve ()
IF	eb_direct_retrieve	Then
	p_retrieve.post event clicked ()
Else
	dw_List.uf_clear ()
	dw_Detail.uf_clear ()
End IF
IF	f_nvl (dw_detail.title,'none')='none' THEN dw_detail.title = inv_menu.is_pgm_nm + f_nvl (dw_detail.title,' 상세')
end event

event ue_setenabled;call super::ue_setenabled;IF dw_list.ibsetlist4subbtn	Then
	dw_list.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
	dw_list.of_dw2subbtn ({'p_input'}, (dw_list.enabled And dw_list.eb_new_false=FALSE And ib_managedata))
	dw_list.of_dw2subbtn ({'p_copy'}, (dw_list.enabled And dw_list.eb_copy_false=FALSE And ib_managedata))
	dw_list.of_dw2subbtn ({'p_delete'}, (dw_list.enabled And dw_list.eb_delete_false=FALSE And ib_managedata))
End IF
IF	dw_detail.ibsetlist4subbtn	Then
	IF dw_list.rowcount ()>0	Then
		dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
		dw_detail.of_dw2subbtn ({'p_input'}, (dw_detail.enabled And dw_detail.eb_new_false=FALSE And ib_managedata))
		dw_detail.of_dw2subbtn ({'p_copy'}, (dw_detail.enabled And dw_detail.eb_copy_false=FALSE And ib_managedata))
		dw_detail.of_dw2subbtn ({'p_delete'}, (dw_detail.enabled And dw_detail.eb_delete_false=FALSE And ib_managedata))
	Else
		dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
	End IF
End IF
end event

event wue_update;IF	dw_List.AcceptText ()=-1 OR dw_Detail.AcceptText ()=-1	Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	EVENT ue_wpage_modified ()	Then
	IF	uf_UpdateCommit (dw_list, dw_detail)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event wue_setdddw;call super::wue_setdddw;ihandle = -1
end event

event ue_wpage_updatetable;IF	dw_List.uf_isupdatetable ()=FALSE And dw_Detail.uf_isupdatetable ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

type lb_dirlist from w_winpage`lb_dirlist within wt_treelistdetail
end type

type ln_templeft from w_winpage`ln_templeft within wt_treelistdetail
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within wt_treelistdetail
end type

type ln_temptop from w_winpage`ln_temptop within wt_treelistdetail
end type

type ln_tempbutton from w_winpage`ln_tempbutton within wt_treelistdetail
end type

type ln_tempstart from w_winpage`ln_tempstart within wt_treelistdetail
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within wt_treelistdetail
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within wt_treelistdetail
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within wt_treelistdetail
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within wt_treelistdetail
end type

type ln_tempright from w_winpage`ln_tempright within wt_treelistdetail
end type

type uo_navi from w_winpage`uo_navi within wt_treelistdetail
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within wt_treelistdetail
end type

type st_windelaytime from w_winpage`st_windelaytime within wt_treelistdetail
end type

type st_top_rect from w_winpage`st_top_rect within wt_treelistdetail
end type

type p_close from w_winpage`p_close within wt_treelistdetail
end type

type p_excel from w_winpage`p_excel within wt_treelistdetail
end type

type p_print from w_winpage`p_print within wt_treelistdetail
end type

type p_delete from w_winpage`p_delete within wt_treelistdetail
end type

type p_update from w_winpage`p_update within wt_treelistdetail
end type

type p_input from w_winpage`p_input within wt_treelistdetail
end type

type p_retrieve from w_winpage`p_retrieve within wt_treelistdetail
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF	p_clear.visible=false	Then
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
	dw_detail.of_setdestroy2filter('')
	dw_detail.of_setdestroy2sort('')
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
   dw_List.uf_protect (0, dw_List.ia_protect [1]) ; dw_Detail.uf_protect (0, dw_Detail.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2]) ; dw_Detail.uf_protect (0, dw_Detail.ia_protect [2])
End IF

dw_Detail.uf_reset (TRUE)
dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within wt_treelistdetail
end type

type p_copy from w_winpage`p_copy within wt_treelistdetail
end type

type dw_c from w_winpage`dw_c within wt_treelistdetail
end type

type btn_update from w_winpage`btn_update within wt_treelistdetail
end type

type st_count from w_winpage`st_count within wt_treelistdetail
end type

type dw_list from u_dw within wt_treelistdetail
integer x = 2158
integer y = 456
integer width = 3273
integer height = 988
integer taborder = 30
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean ibsetlist4subbtn = true
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;IF	rowcount=0 THEN dw_Detail.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
uf_enabled (eb_rowchangewait, false)
dw_detail.setredraw (false)
dw_detail.uf_reset ()
dw_detail.EVENT ue_retrieve ()
dw_detail.setredraw (true)
uf_enabled (eb_rowchangewait, true)
RETURN 0
end event

event rowfocuschanging_return;IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copystart;IF dw_detail.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event ue_copyrow;call super::ue_copyrow;IF AncestorReturnVALUE=-1 THEN RETURN -1

LONG	lRow, lRowCount

lRowCount=dw_Detail.rowcount ()
IF	lRowCount>0	Then
   IF	f_messageBox ('W014','')=1	Then
      FOR  lRow = 1  TO  lRowCount
         dw_Detail.SetItemStatus (lRow, 0, Primary!, New!)
         dw_Detail.SetItemStatus (lRow, 0, Primary!, NotModified!)
      NEXT
   Else
      dw_Detail.uf_reset ()
   End IF
End IF

RETURN 0
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

event ue_delete;IF	rowcount ()=0 THEN RETURN -1
IF	uf_getrange ()	Then
	f_messageBox ('RANG','삭제')
	RETURN -1
End IF
IF	f_MessageBox ('W004', dw_Detail.Tag)=2 THEN RETURN 0	// delete Cancel

IF EVENT ue_deletestart ()=1 THEN RETURN -1
IF	dw_Detail.uf_deleteall ()=-1 THEN RETURN -1

enabled = false
EVENT ue_deleterow (iRow)
IF	deleterow (iRow)=-1	Then
	f_messageBox ('D000', TAG+'(no rollback)')
	RETURN -1
End IF
IF	iRow>rowcount () THEN iRow = rowcount ()
IF	iRow=0	Then
	IF	dw_detail.ibsetlist4subbtn THEN dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
Else
	uf_setrow (iRow, true)
	POST SetFocus ()
End IF

RETURN 1
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type dw_detail from u_dw within wt_treelistdetail
integer x = 2158
integer y = 1476
integer width = 3273
integer height = 1288
integer taborder = 20
boolean bringtotop = true
string title = "상세자료"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
boolean ibsetlist4excelclip = true
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('detail', rowcount, eb_null_line)
end event

event constructor;call super::constructor;uf_date_nation (is_date_nation)
end event

type st_hmove from pf_u_splitbar_horizontal within wt_treelistdetail
integer x = 2158
integer y = 1452
integer width = 3273
boolean setcondcolor = true
string topdragobject = "dw_list"
string bottomdragobject = "dw_detail"
end type

type st_3 from pf_u_statictext within wt_treelistdetail
integer x = 155
integer y = 360
integer width = 549
integer height = 92
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = hangeul!
string text = "tree title"
boolean setsheetcolor = true
end type

type p_2 from pf_u_picture within wt_treelistdetail
integer x = 59
integer y = 368
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\icon_breadcrumb2.jpg"
end type

type tv_tree from pf_u_treeview within wt_treelistdetail
integer x = 50
integer y = 456
integer width = 2080
integer height = 2308
integer taborder = 60
boolean bringtotop = true
long textcolor = 19737901
boolean linesatroot = true
string picturename[] = {"..\img\controls\u_icon4comm\imagebtn_fund.jpg","..\img\controls\u_favicon\favicon_04.ico"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event itemcollapsed;call super::itemcollapsed;IF	ihandle=handle THEN getitem(handle, itvi_item)
end event

event itemexpanded;call super::itemexpanded;IF	ihandle=handle THEN getitem(handle, itvi_item)
end event

event selectionchanged;call super::selectionchanged;IF	getitem(newhandle, itvi_item)>0	Then
	ihandle_parent = FindItem (ParentTreeItem!, newhandle)
	ihandle = newhandle
	itvi_item.bold = true
	setitem (newhandle, itvi_item)
End IF
end event

event selectionchanging;call super::selectionchanging;IF	ihandle=-1 THEN RETURN 1
IF	ihandle=oldhandle	Then
	itvi_item.bold = false
	itvi_item.selected = false
	setitem (ihandle, itvi_item)
End IF
end event

type st_vmove from pf_u_splitbar_vertical within wt_treelistdetail
integer x = 2135
integer y = 456
integer height = 2308
boolean setcondcolor = true
string leftdragobject = "tv_tree"
string rightdragobject = "dw_list;dw_detail;st_hmove"
end type

event constructor;call super::constructor;IF	dw_list.zoominout THEN ii_rightmargin += PixelsToUnits(12, XPixelsToUnits!)
end event

