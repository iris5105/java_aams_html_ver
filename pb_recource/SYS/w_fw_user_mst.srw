forward
global type w_fw_user_mst from wt_vertdetail
end type
end forward

global type w_fw_user_mst from wt_vertdetail
boolean eb_direct_retrieve = true
string is_find = "corp_gr=~'~'"
end type
global w_fw_user_mst w_fw_user_mst

type variables

end variables

on w_fw_user_mst.create
int iCurrent
call super::create
end on

on w_fw_user_mst.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;is_find = "corp_gr='" + gaa.corp_gr + "'"
IF	gaa.aams	Then
	dw_list.retrieve ('%')
Else
	dw_list.retrieve (gaa.corp_gr)
End IF
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_fw_user_mst
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_fw_user_mst
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_fw_user_mst
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_fw_user_mst
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_fw_user_mst
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_fw_user_mst
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_fw_user_mst
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_fw_user_mst
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_fw_user_mst
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_fw_user_mst
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_fw_user_mst
end type

type uo_navi from wt_vertdetail`uo_navi within w_fw_user_mst
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_fw_user_mst
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_fw_user_mst
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_fw_user_mst
end type

type p_close from wt_vertdetail`p_close within w_fw_user_mst
end type

type p_excel from wt_vertdetail`p_excel within w_fw_user_mst
end type

type p_print from wt_vertdetail`p_print within w_fw_user_mst
end type

type p_delete from wt_vertdetail`p_delete within w_fw_user_mst
end type

type p_update from wt_vertdetail`p_update within w_fw_user_mst
end type

type p_input from wt_vertdetail`p_input within w_fw_user_mst
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_fw_user_mst
end type

type p_clear from wt_vertdetail`p_clear within w_fw_user_mst
end type

type p_copy from wt_vertdetail`p_copy within w_fw_user_mst
end type

type dw_c from wt_vertdetail`dw_c within w_fw_user_mst
boolean visible = false
boolean enabled = false
string title = ""
end type

event dw_c::ue_valid;RETURN TRUE
end event

type btn_update from wt_vertdetail`btn_update within w_fw_user_mst
end type

type st_count from wt_vertdetail`st_count within w_fw_user_mst
end type

type dw_list from wt_vertdetail`dw_list within w_fw_user_mst
integer y = 156
integer height = 2608
string dataobject = "d_fw_user_mst_corp_gr"
end type

type dw_detail from wt_vertdetail`dw_detail within w_fw_user_mst
integer y = 156
integer height = 2608
string dataobject = "d_fw_user_mst"
string is_encrypts = "enc_e_mail,enc_tel_no"
boolean ib_encrypts = false
end type

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('corp_gr', dw_list.object.corp_gr [iRow])
uf_setcolumn ('symd', f_sysdate_str ('yyyy.mm.dd'))
uf_setcolumn ('admin_yn', 'N')
uf_setcolumn ('watchman_yn', 'N')

POST SetColumn ('user_id')

RETURN 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.corp_gr [iRow])
end event

event dw_detail::ue_protect;call super::ue_protect;uf_protect (row, ia_protect [1])
end event

event dw_detail::doubleclicked;call super::doubleclicked;str_parameter	sp
IF	dwo.name='user_id'	Then
	sp.bo [1]  = true
	sp.str [1] = dw_list.object.corp_gr [iRow]
	sp.str [2] = Object.e_mail [row]
	sp.str [3] = ''
	openwithparm (w_change_pwd, sp)
End IF
end event

type st_move from wt_vertdetail`st_move within w_fw_user_mst
integer y = 156
integer height = 2608
boolean leftmaxsizefixed = true
end type

