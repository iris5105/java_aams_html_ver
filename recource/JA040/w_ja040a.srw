forward
global type w_ja040a from wt_listdetail
end type
type dw_1 from u_dw within w_ja040a
end type
type st_1 from pf_u_splitbar_vertical within w_ja040a
end type
end forward

global type w_ja040a from wt_listdetail
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
string is_find = "fund_cd=~'~'"
dw_1 dw_1
st_1 st_1
end type
global w_ja040a w_ja040a

type variables

end variables

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_List.retrieve (dw_c.object.dddw [1])
end event

on w_ja040a.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
end on

on w_ja040a.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_1)
end on

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' })
f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*'")
dw_c.object.dddw [1] = gaa.corp_gr
end event

event wue_postopen;call super::wue_postopen;dw_1.SetTransObject (SQLCA)
dw_1.insertrow (0)
end event

event ue_wpage_modified;IF dw_List.uf_isModified ()=FALSE And dw_Detail.uf_isModified ()=FALSE And dw_1.uf_isModified ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_clear;dw_1.uf_reset (FALSE)
dw_1.Modify (dw_1.ia_protect [4])
dw_1.insertrow (0)
call super::wue_clear
end event

event wue_update;IF dw_List.AcceptText ()=-1 OR dw_Detail.AcceptText ()=-1 OR dw_1.AcceptText ()=-1   Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_Modified () Then
   IF uf_UpdateCommit (dw_List, dw_Detail)=-1 THEN RETURN -1
   RETURN uf_UpdateCommit (dw_1)
End IF
RETURN 1
end event

event ue_setenabled;call super::ue_setenabled;IF dw_detail.rowcount ()>0 And dw_1.ibsetlist4subbtn	Then
	dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
	dw_1.of_dw2subbtn ({'p_input'}, (dw_1.enabled And dw_1.eb_new_false=FALSE And ib_managedata))
	dw_1.of_dw2subbtn ({'p_copy'}, (dw_1.enabled And dw_1.eb_copy_false=FALSE And ib_managedata))
	dw_1.of_dw2subbtn ({'p_delete'}, (dw_1.enabled And dw_1.eb_delete_false=FALSE And ib_managedata))

ElseIF dw_detail.rowcount ()=0  And dw_1.ibsetlist4subbtn Then
	dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
End IF
end event

event ue_setdisabled;call super::ue_setdisabled;IF dw_1.ibsetlist4subbtn THEN dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja040a
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja040a
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja040a
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja040a
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja040a
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja040a
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja040a
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja040a
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja040a
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja040a
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja040a
end type

type uo_navi from wt_listdetail`uo_navi within w_ja040a
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja040a
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja040a
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja040a
end type

type p_close from wt_listdetail`p_close within w_ja040a
end type

type p_excel from wt_listdetail`p_excel within w_ja040a
end type

type p_print from wt_listdetail`p_print within w_ja040a
end type

type p_delete from wt_listdetail`p_delete within w_ja040a
end type

type p_update from wt_listdetail`p_update within w_ja040a
end type

type p_input from wt_listdetail`p_input within w_ja040a
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja040a
end type

event p_retrieve::clicked;call super::clicked;dw_1.enabled = FALSE
IF ib_ManageData  Then
   dw_1.uf_protect (0, dw_1.ia_protect [1])
Else
   dw_1.uf_protect (0, dw_1.ia_protect [2])
End IF
dw_1.uf_reset (TRUE)
end event

type p_clear from wt_listdetail`p_clear within w_ja040a
end type

type p_copy from wt_listdetail`p_copy within w_ja040a
end type

type dw_c from wt_listdetail`dw_c within w_ja040a
string title = "운용사"
string dataobject = "dc_ymd_dddw"
end type

type btn_update from wt_listdetail`btn_update within w_ja040a
end type

type st_count from wt_listdetail`st_count within w_ja040a
end type

type dw_list from wt_listdetail`dw_list within w_ja040a
string dataobject = "d_ja040a1"
end type

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_where = "nvl(mc_code,fund_cd) != fund_cd"
   CASE 'mc_fund_cd'
      rs_where = "mc_code is not null and mc_code=fund_cd and haeji_ymd is null"
END CHOOSE
RETURN 1
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('above_gb', '11')
uf_setcolumn ('above_yn', '2')
uf_setcolumn ('b0313_yn', 'Y')
uf_setcolumn ('y365', 'N')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'above_gb', gaa.corp_gr, '', 1, '')
f_dddwctl (THIS, 'above_yn', gaa.corp_gr, '', 1, '')

f_dddw_filter (THIS, 'above_gb', "cd<>'12'")	// 12-유형은 마일스톤 인도펀드에만 적용
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

CHOOSE CASE dwo.name
   CASE 'above_gb'
      FOR  ll = 1  TO  rowcount ()
         IF row<>ll And Object.mc_code [ll]=Object.mc_code [row]  Then
            Object.above_gb [ll] = data
         End IF
      NEXT
   CASE 'b0313_yn'
      FOR  ll = 1  TO  rowcount ()
         IF row<>ll And Object.mc_code [ll]=Object.mc_code [row]  Then
            Object.b0313_yn [ll] = data
         End IF
      NEXT
END CHOOSE
end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF dw_1.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;IF	row>0 And dwo.name='above_gb' THEN OpenWithParm (w_popup_szze180_above, parent)
end event

type dw_detail from wt_listdetail`dw_detail within w_ja040a
integer y = 1472
integer width = 3131
integer height = 1292
string dataobject = "d_ja040a2"
boolean scaletoright = false
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;dw_1.uf_reset (TRUE)
dw_1.retrieve (dw_List.object.corp_gr [iRow], dw_List.object.mc_code [iRow])
retrieve (dw_List.object.corp_gr [iRow], dw_List.object.mc_code [iRow])
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;IF rowcount ()=0   Then
   uf_setcolumn ('jekyo_ymd', string (dw_List.object.fst_seolj_ymd [iRow]))
Else
   uf_setcolumn ('jekyo_ymd', string (idt_workdate))
End IF
uf_setcolumn ('mc_code', dw_List.object.mc_code [iRow])

POST SetColumn ('jekyo_ymd')

RETURN 0
end event

event dw_detail::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'currency', gaa.corp_gr, '', 1, '')
end event

type st_move from wt_listdetail`st_move within w_ja040a
string bottomdragobject = "dw_detail;dw_1;st_1"
end type

type dw_1 from u_dw within w_ja040a
integer x = 3209
integer y = 1472
integer width = 2222
integer height = 1292
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ja040a3"
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
boolean eb_null_line = false
end type

event ue_insertstart;call super::ue_insertstart;uf_setcolumn ('jekyo_ymd', string (dw_detail.object.jekyo_ymd [dw_detail.getrow ()]))
uf_setcolumn ('mc_code', dw_List.object.mc_code [iRow])

POST SetColumn ('jekyo_ymd')

RETURN 0
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'fund_cd'
      rs_where = "t1.mc_code = '" + dw_list.object.mc_code [iRow] + "' And t1.fund_cd != t1.mc_code"
END CHOOSE
RETURN 1
end event

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'jekyo_ymd'
      IF datetime (date(MID (data,1,8)))<idt_workdate Then
         RETURN uf_itemerr (row, 'jekyo_ymd', '적용시작일이 당일 이전입니다.')
      End IF
END CHOOSE
end event

type st_1 from pf_u_splitbar_vertical within w_ja040a
integer x = 3186
integer y = 1472
integer height = 1292
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_detail"
string rightdragobject = "dw_1"
end type

