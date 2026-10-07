forward
global type w_ja990b from wt_listdetail
end type
type cb_add from pf_u_commandbutton within w_ja990b
end type
end forward

global type w_ja990b from wt_listdetail
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
cb_add cb_add
end type
global w_ja990b w_ja990b

type variables
str_parameter  sp
end variables

on w_ja990b.create
int iCurrent
call super::create
this.cb_add=create cb_add
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add
end on

on w_ja990b.destroy
call super::destroy
destroy(this.cb_add)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (dw_c.object.dddw [1])
end event

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' }) ; f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*'")
dw_c.object.dddw [1] = gaa.corp_gr
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja990b
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja990b
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja990b
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja990b
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja990b
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja990b
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja990b
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja990b
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja990b
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja990b
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja990b
end type

type uo_navi from wt_listdetail`uo_navi within w_ja990b
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja990b
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja990b
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja990b
end type

type p_close from wt_listdetail`p_close within w_ja990b
end type

type p_excel from wt_listdetail`p_excel within w_ja990b
end type

type p_print from wt_listdetail`p_print within w_ja990b
end type

type p_delete from wt_listdetail`p_delete within w_ja990b
end type

type p_update from wt_listdetail`p_update within w_ja990b
end type

type p_input from wt_listdetail`p_input within w_ja990b
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja990b
end type

type p_clear from wt_listdetail`p_clear within w_ja990b
end type

type p_copy from wt_listdetail`p_copy within w_ja990b
end type

type dw_c from wt_listdetail`dw_c within w_ja990b
string title = "운용사"
string dataobject = "dc_ymd_dddw"
end type

type btn_update from wt_listdetail`btn_update within w_ja990b
end type

type st_count from wt_listdetail`st_count within w_ja990b
end type

type dw_list from wt_listdetail`dw_list within w_ja990b
boolean enabled = true
string dataobject = "d_ja990b1"
string is_resize_column = "bigo"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_gb', '1')
uf_setColumn ('used', '1')

POST SetColumn ('tr_gb')

RETURN 0
end event

type dw_detail from wt_listdetail`dw_detail within w_ja990b
string dataobject = "d_ja990b2"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.ksd_cd [iRow])
end event

event dw_detail::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1
CHOOSE CASE dwo.name
	CASE 'csusu_rt'
		Object.susu_rt [row] = dec (data) / 100
END CHOOSE
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_co_cd', dw_list.object.ksd_cd [iRow])
RETURN 0
end event

type st_move from wt_listdetail`st_move within w_ja990b
end type

type cb_add from pf_u_commandbutton within w_ja990b
integer x = 2231
integer y = 20
integer width = 407
integer taborder = 50
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "코드추가"
end type

event clicked;str_parameter  open_sp

open_sp.str [1] = '매매처 추가정보'
open_sp.str [2] = dw_c.object.dddw [1]

OpenwithParm (w_szx2mm_add, open_sp)
TRY
   sp = Message.PowerObjectParm
   IF sp.str [1]='insert'  Then
		p_retrieve.event clicked ()
   End IF
CATCH (runtimeerror er)
   f_microHelp ('추가취소')
END TRY
end event

