forward
global type w_syx2mm from wt_list
end type
end forward

global type w_syx2mm from wt_list
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
end type
global w_syx2mm w_syx2mm

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' })
f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*'")
dw_c.object.dddw [1] = gaa.corp_gr
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (dw_c.object.dddw [1])
end event

on w_syx2mm.create
int iCurrent
call super::create
end on

on w_syx2mm.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_syx2mm
end type

type ln_templeft from wt_list`ln_templeft within w_syx2mm
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_syx2mm
end type

type ln_temptop from wt_list`ln_temptop within w_syx2mm
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_syx2mm
end type

type ln_tempstart from wt_list`ln_tempstart within w_syx2mm
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_syx2mm
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_syx2mm
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_syx2mm
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_syx2mm
end type

type ln_tempright from wt_list`ln_tempright within w_syx2mm
end type

type uo_navi from wt_list`uo_navi within w_syx2mm
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_syx2mm
end type

type st_windelaytime from wt_list`st_windelaytime within w_syx2mm
end type

type st_top_rect from wt_list`st_top_rect within w_syx2mm
end type

type p_close from wt_list`p_close within w_syx2mm
end type

type p_excel from wt_list`p_excel within w_syx2mm
end type

type p_print from wt_list`p_print within w_syx2mm
end type

type p_delete from wt_list`p_delete within w_syx2mm
end type

type p_update from wt_list`p_update within w_syx2mm
end type

type p_input from wt_list`p_input within w_syx2mm
end type

type p_retrieve from wt_list`p_retrieve within w_syx2mm
end type

type p_clear from wt_list`p_clear within w_syx2mm
end type

type p_copy from wt_list`p_copy within w_syx2mm
end type

type dw_c from wt_list`dw_c within w_syx2mm
string title = "자문(운용)사"
string dataobject = "dc_ymd_dddw"
end type

type btn_update from wt_list`btn_update within w_syx2mm
end type

type st_count from wt_list`st_count within w_syx2mm
end type

type dw_list from wt_list`dw_list within w_syx2mm
string dataobject = "d_syx2mm"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'currency', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'keep_currency | currency', gaa.corp_gr, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll, ll_no = 0

CHOOSE CASE dwo.name
   CASE 'currency'
		FOR  ll = 1  TO  rowcount ()
			IF	ll<>row	Then
				IF	LEFT (Object.trustee [ll],3)=data THEN ll_no = dec(RIGHT (Object.trustee [ll],2))
			End IF
		NEXT
		Object.trustee [row] = data + string (ll_no + 1,'00')
   CASE 'fund_currency'
      IF Object.sum_fund_currency [1]>0 And data='Y'  Then
         RETURN uf_itemerr (row, 'fund_currency','기준통화 보관처는 한 곳 이상 지정 할 수 없습니다.')
      End IF
   CASE 'keep_cost'
      Object.keep_cost_mon [row] = null_dc
   CASE 'keep_cost_mon'
      Object.keep_cost [row] = null_dc
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('corp_gr', gaa.corp_gr)
uf_setcolumn ('keep_currency', 'USD')
uf_setColumn ('used', '1')

POST SetColumn ('trustee')

RETURN 0
end event

