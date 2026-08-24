forward
global type w_szt0ck from wt_list
end type
end forward

global type w_szt0ck from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_init_value = "%"
end type
global w_szt0ck w_szt0ck

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = ia_value [1]
dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (dw_c.object.ymd [1], ia_value [1])
end event

on w_szt0ck.create
int iCurrent
call super::create
end on

on w_szt0ck.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_szt0ck
end type

type ln_templeft from wt_list`ln_templeft within w_szt0ck
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_szt0ck
end type

type ln_temptop from wt_list`ln_temptop within w_szt0ck
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_szt0ck
end type

type ln_tempstart from wt_list`ln_tempstart within w_szt0ck
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_szt0ck
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_szt0ck
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_szt0ck
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_szt0ck
end type

type ln_tempright from wt_list`ln_tempright within w_szt0ck
end type

type uo_navi from wt_list`uo_navi within w_szt0ck
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_szt0ck
end type

type st_windelaytime from wt_list`st_windelaytime within w_szt0ck
end type

type st_top_rect from wt_list`st_top_rect within w_szt0ck
end type

type p_close from wt_list`p_close within w_szt0ck
end type

type p_excel from wt_list`p_excel within w_szt0ck
end type

type p_print from wt_list`p_print within w_szt0ck
end type

type p_delete from wt_list`p_delete within w_szt0ck
end type

type p_update from wt_list`p_update within w_szt0ck
end type

type p_input from wt_list`p_input within w_szt0ck
end type

type p_retrieve from wt_list`p_retrieve within w_szt0ck
end type

type p_clear from wt_list`p_clear within w_szt0ck
end type

type p_copy from wt_list`p_copy within w_szt0ck
end type

type dw_c from wt_list`dw_c within w_szt0ck
string title = "영업일자@점검종류"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dddw', gaa.corp_gr, '%,전체,', 11, '')
end event

type btn_update from wt_list`btn_update within w_szt0ck
end type

type st_count from wt_list`st_count within w_szt0ck
end type

type dw_list from wt_list`dw_list within w_szt0ck
string dataobject = "d_szt0ck"
boolean eb_copy_false = true
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;//f_dddwctl (THIS, 'corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*' And f_server (data_file,'" + gaa.jTier_dbname + "')='true'")
f_dddwctl (THIS, 'fund_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'szt0ck_check_yn'
      IF data='N' Then
         object.szt0ck_check_pgmid [row] = gnv_vari.is_user_id
         Object.szt0ck_check_ymd [row] = f_sysdate ('')
      Else
         Object.szt0ck_check_pgmid [row] = null_s
         Object.szt0ck_check_ymd [row] = null_dt
      End IF
END CHOOSE
end event

event dw_list::updatestart;call super::updatestart;LONG	ll_row=0, ll_cnt=0

DO WHILE ll_row <= rowcount()
	ll_row = dw_list.GetNextModified(ll_row, Primary!)
	IF ll_row > 0 Then
		ll_cnt++
		IF dw_list.object.szt0ck_check_yn [ll_row] = 'Y' Then
			IF f_null (dw_list.Object.szt0ck_check_sayu [ll_row]) or dw_list.Object.szt0ck_check_sayu [ll_row] = '미등록' Then
				f_messageBox ('W007', string (ll_row) + '행 사유')
				SetColumn('szt0ck_check_sayu')
				RETURN 1
			End IF
		End if	
	Else
		EXIT
	End IF
LOOP
end event

