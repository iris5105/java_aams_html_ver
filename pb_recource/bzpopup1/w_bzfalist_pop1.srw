forward
global type w_bzfalist_pop1 from w_response1st5cn
end type
type dw_list from fw_u_dwo within w_bzfalist_pop1
end type
end forward

global type w_bzfalist_pop1 from w_response1st5cn
integer width = 4530
integer height = 2524
string title = "FA"
dw_list dw_list
end type
global w_bzfalist_pop1 w_bzfalist_pop1

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

on w_bzfalist_pop1.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_bzfalist_pop1.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;fw_f_setdddw(dw_cond, 'mjr_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA001', '%'})
fw_f_setdddw(dw_cond, 'mnr_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA002', '%'})
fw_f_setdddw(dw_list, 'mjr_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA001', '%'})
fw_f_setdddw(dw_list, 'mnr_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA002', '%'})
fw_f_setdddw(dw_list, 'pos_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA004', '%'})
fw_f_setdddw(dw_list, 'state_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA003', '%'})
fw_f_setdddw(dw_list, 'calc_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA008', '%'})
fw_f_setdddw(dw_list, 'meth_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA005', '%'})
fw_f_setdddw(dw_list, 'acq_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA007', '%'})
fw_f_setdddw(dw_list, 'crny_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'ACC001', '%'})
fw_f_setdddw(dw_list, 'unit_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'FTA006', '%'})

dw_cond.SetTransObject( sqlca )
dw_list.SetTransObject( sqlca )

dw_cond.Insertrow(0)
of_initsetting(dw_cond, '%', '')

Post Event wue_retrieve();
end event

event wue_ok;call super::wue_ok;String		ls_fa_no, ls_sys_id, ls_mjr_cd, ls_mnr_cd, ls_mjr_nm, ls_mnr_nm, ls_fa_seq, ls_item_lnm, ls_item_enm, ls_item_spec
Long		ll_Row

IF Not IsValid(inv_hash) THEN inv_hash = Create pf_n_hashtable

dw_list.AcceptText()

IF dw_list.rowcount() > 0 THEN
	ll_Row = dw_list.getRow()
	
	ls_sys_id			= dw_list.getItemString(ll_row, 'sys_id')
	ls_mjr_cd			= dw_list.getItemString(ll_row, 'mjr_cd')
	ls_mnr_cd		= dw_list.getItemString(ll_row, 'mnr_cd')
	ls_mjr_nm		= dw_list.getItemString(ll_row, 'mjr_nm')
	ls_mnr_nm		= dw_list.getItemString(ll_row, 'mnr_nm')
	ls_fa_seq			= dw_list.getItemString(ll_row, 'fa_seq')
	ls_item_lnm		= dw_list.getItemString(ll_row, 'item_lnm')
	ls_item_enm		= dw_list.getItemString(ll_row, 'item_enm')
	ls_item_spec		= dw_list.getItemString(ll_row, 'item_spec')
	
	ls_fa_no = ls_sys_id + ls_mjr_cd + ls_mnr_cd + ls_fa_seq
	
	inv_hash.of_put('fa_no'	, ls_fa_no)
	inv_hash.of_put('sys_id'	, ls_sys_id)
	inv_hash.of_put('mjr_cd'	, ls_mjr_cd)
	inv_hash.of_put('mnr_cd'	, ls_mnr_cd)
	inv_hash.of_put('mjr_nm'	, ls_mjr_nm)
	inv_hash.of_put('mnr_nm', ls_mnr_nm)
	inv_hash.of_put('fa_seq'	, ls_fa_seq)
	inv_hash.of_put('item_lnm'	, ls_item_lnm)
	inv_hash.of_put('item_enm'	, ls_item_enm)
	inv_hash.of_put('item_spec'	, ls_item_spec)

	CloseWithReturn(this, inv_hash)
ELSE
	p_close.Event Clicked()
END IF

end event

event wue_retrieve;call super::wue_retrieve;dw_list.reset()

String		ls_mjr_cd, ls_mnr_cd, ls_div_gb, ls_indirt_no
Long		ll_ret, ll_row

dw_cond.AcceptText()

ls_mjr_cd		= dw_cond.GetItemString(1, 'mjr_cd')
ls_mnr_cd	= dw_cond.GetItemString(1, 'mnr_cd')
ls_div_gb		= inv_hash.of_getString('div_gb')
ls_indirt_no	= dw_cond.GetItemString(1, 'indirt_no')
If fw_f_nvls(ls_indirt_no, '') = '' Then
	ls_indirt_no = '%'
Else
	ls_indirt_no = ls_indirt_no + '%'
End If
If ls_div_gb = '1' Then
	ll_ret = dw_list.Retrieve(gnv_vari.is_sys_id, ls_mjr_cd, ls_mnr_cd, ls_div_gb, ls_indirt_no, '%')
Else
	ll_ret = dw_list.Retrieve(gnv_vari.is_sys_id, ls_mjr_cd, ls_mnr_cd, ls_div_gb, ls_indirt_no, gnv_vari.is_dept_cd)
End If

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

type ln_tempbutton from w_response1st5cn`ln_tempbutton within w_bzfalist_pop1
end type

type ln_tempstart from w_response1st5cn`ln_tempstart within w_bzfalist_pop1
end type

type ln_templeft from w_response1st5cn`ln_templeft within w_bzfalist_pop1
end type

type ln_cond_start from w_response1st5cn`ln_cond_start within w_bzfalist_pop1
end type

type ln_tempright from w_response1st5cn`ln_tempright within w_bzfalist_pop1
end type

type ln_cond1_yline from w_response1st5cn`ln_cond1_yline within w_bzfalist_pop1
end type

type ln_dw1_yline from w_response1st5cn`ln_dw1_yline within w_bzfalist_pop1
end type

type p_print from w_response1st5cn`p_print within w_bzfalist_pop1
integer x = 50
end type

type p_delete from w_response1st5cn`p_delete within w_bzfalist_pop1
integer x = 50
end type

type p_new from w_response1st5cn`p_new within w_bzfalist_pop1
integer x = 50
end type

type p_close from w_response1st5cn`p_close within w_bzfalist_pop1
boolean visible = true
integer x = 4247
end type

type p_cancel from w_response1st5cn`p_cancel within w_bzfalist_pop1
integer x = 50
end type

type p_ok from w_response1st5cn`p_ok within w_bzfalist_pop1
boolean visible = true
integer x = 4009
end type

event p_ok::clicked;call super::clicked;Parent.PostEvent("wue_ok")
end event

type p_preview from w_response1st5cn`p_preview within w_bzfalist_pop1
integer x = 50
end type

type p_update from w_response1st5cn`p_update within w_bzfalist_pop1
integer x = 50
end type

type p_excel from w_response1st5cn`p_excel within w_bzfalist_pop1
integer x = 50
end type

type dw_cond from w_response1st5cn`dw_cond within w_bzfalist_pop1
boolean visible = true
integer width = 4425
string dataobject = "d_bzfalist_pop1_0"
end type

event dw_cond::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'mjr_cd'
		Post of_initsetting(This, string(data), '')
	Case 'mnr_cd'
		Parent.Post Event wue_retrieve();
End Choose
end event

type p_clear from w_response1st5cn`p_clear within w_bzfalist_pop1
integer x = 50
end type

type p_modify from w_response1st5cn`p_modify within w_bzfalist_pop1
integer x = 50
end type

type p_retrieve from w_response1st5cn`p_retrieve within w_bzfalist_pop1
boolean visible = true
integer x = 3771
end type

type p_tempsave from w_response1st5cn`p_tempsave within w_bzfalist_pop1
integer x = 50
end type

type p_collect from w_response1st5cn`p_collect within w_bzfalist_pop1
integer x = 50
end type

type dw_list from fw_u_dwo within w_bzfalist_pop1
integer x = 50
integer y = 344
integer width = 4421
integer height = 2056
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_bzfalist_pop1_1"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

Parent.Event wue_ok()
end event

