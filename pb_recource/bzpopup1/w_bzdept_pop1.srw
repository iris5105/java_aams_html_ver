forward
global type w_bzdept_pop1 from w_response1st5cn
end type
type dw_list from fw_u_dwo within w_bzdept_pop1
end type
end forward

global type w_bzdept_pop1 from w_response1st5cn
integer width = 2281
string title = "Department"
dw_list dw_list
end type
global w_bzdept_pop1 w_bzdept_pop1

type variables
Private:
	pf_n_hashtable	inv_hash
	
	String		is_findSyntax
end variables

forward prototypes
public subroutine of_initsetting (datawindow adw_dw, string as_val1, string as_val2)
end prototypes

public subroutine of_initsetting (datawindow adw_dw, string as_val1, string as_val2);adw_dw.SetItem(1, 'mjr_cd', as_val1)

String		ls_filter, ls_detl_cd
Long		ll_rtn

datawindowchild		ldwc_obj
adw_dw.GetChild('mnr_cd', ldwc_obj)

ldwc_obj.SetFilter(ls_filter)
ldwc_obj.Filter( )
ldwc_obj.GroupCalc( )

If as_val1 = '%' Then
	ls_filter = "ref_cd like '%'"
Else
	ls_filter = "ref_cd = '" + as_val1 + "' or ref_cd = '%'"
End If
ll_rtn = ldwc_obj.SetFilter(ls_filter)
ldwc_obj.Filter( )
	
ldwc_obj.SetSort('sort_cd')
ldwc_obj.Sort( )
ldwc_obj.GroupCalc( )
ls_detl_cd = ldwc_obj.GetitemString(1,'detl_cd')

If fw_f_nvls(ls_detl_cd, '') <> '' Then adw_dw.SetItem(1, 'mnr_cd', ls_detl_cd)
end subroutine

on w_bzdept_pop1.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_bzdept_pop1.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;dw_list.SetTransObject( sqlca )

This.PostEvent("wue_retrieve2ready")
end event

event wue_ok;call super::wue_ok;Long		ll_Row
IF Not IsValid(inv_hash) THEN inv_hash = Create pf_n_hashtable

dw_list.AcceptText()
IF dw_list.rowcount() > 0 THEN
	ll_Row = dw_list.getRow()

	inv_hash.of_put('sys_id'		, dw_list.getItemString(ll_row, 'sys_id'))
	inv_hash.of_put('dept_dt'		, dw_list.getItemString(ll_row, 'fr_dt'))
	inv_hash.of_put('dept_cd'	, dw_list.getItemString(ll_row, 'dept_cd'))
	inv_hash.of_put('dept_nm'	, dw_list.getItemString(ll_row, 'dept_nm'))

	CloseWithReturn(this, inv_hash)
ELSE
	p_close.Event Clicked()
END IF

end event

event wue_retrieve;call super::wue_retrieve;dw_list.reset()

Long		ll_ret, ll_row

ll_ret	= dw_list.Retrieve(gnv_vari.is_sys_id, gnv_vari.is_lang_type)

Choose Case ll_ret
	Case is > 0
		If ll_row > 0 Then dw_list.Event RowFocusChanged(1)
		dw_list.Post SetFocus()
	Case 0
		MessageBox("Check", "No data found.")
	Case is < 0
		MessageBox("Error", "Search Error") 
End Choose
end event

event open;call super::open;inv_hash = Create pf_n_hashtable

inv_hash = Message.PowerObjectParm

If not isvalid(inv_hash) Then
	messagebox('Notice', 'There is no parameter variable value.')
	Close(this)
	Return
End If

end event

type ln_tempbutton from w_response1st5cn`ln_tempbutton within w_bzdept_pop1
end type

type ln_tempstart from w_response1st5cn`ln_tempstart within w_bzdept_pop1
end type

type ln_templeft from w_response1st5cn`ln_templeft within w_bzdept_pop1
end type

type ln_cond_start from w_response1st5cn`ln_cond_start within w_bzdept_pop1
end type

type ln_tempright from w_response1st5cn`ln_tempright within w_bzdept_pop1
end type

type ln_cond1_yline from w_response1st5cn`ln_cond1_yline within w_bzdept_pop1
end type

type ln_dw1_yline from w_response1st5cn`ln_dw1_yline within w_bzdept_pop1
end type

type p_print from w_response1st5cn`p_print within w_bzdept_pop1
integer x = 50
end type

type p_delete from w_response1st5cn`p_delete within w_bzdept_pop1
integer x = 50
end type

type p_new from w_response1st5cn`p_new within w_bzdept_pop1
integer x = 50
end type

type p_close from w_response1st5cn`p_close within w_bzdept_pop1
boolean visible = true
integer x = 2007
end type

type p_cancel from w_response1st5cn`p_cancel within w_bzdept_pop1
integer x = 50
end type

type p_ok from w_response1st5cn`p_ok within w_bzdept_pop1
boolean visible = true
integer x = 1769
end type

event p_ok::clicked;call super::clicked;Parent.PostEvent("wue_ok")
end event

type p_preview from w_response1st5cn`p_preview within w_bzdept_pop1
integer x = 50
end type

type p_update from w_response1st5cn`p_update within w_bzdept_pop1
integer x = 50
end type

type p_excel from w_response1st5cn`p_excel within w_bzdept_pop1
integer x = 50
end type

type dw_cond from w_response1st5cn`dw_cond within w_bzdept_pop1
integer x = 846
integer y = 16
integer width = 169
integer height = 116
end type

type p_clear from w_response1st5cn`p_clear within w_bzdept_pop1
integer x = 50
end type

type p_modify from w_response1st5cn`p_modify within w_bzdept_pop1
integer x = 50
end type

type p_retrieve from w_response1st5cn`p_retrieve within w_bzdept_pop1
integer x = 1303
end type

type p_tempsave from w_response1st5cn`p_tempsave within w_bzdept_pop1
integer x = 50
end type

type p_collect from w_response1st5cn`p_collect within w_bzdept_pop1
integer x = 50
end type

type dw_list from fw_u_dwo within w_bzdept_pop1
integer x = 50
integer y = 156
integer width = 2181
integer height = 1836
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_bzdept_pop1_1"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

parent.Event wue_ok()
end event

