forward
global type w_ja020r from wt_vertdetail
end type
end forward

global type w_ja020r from wt_vertdetail
integer ii_dddw_width = 700
string is_init_value = "d_ja020r2c"
end type
global w_ja020r w_ja020r

on w_ja020r.create
int iCurrent
call super::create
end on

on w_ja020r.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

event wue_lastopen;call super::wue_lastopen;DATETIME ldt

IF	gaa.corp_gr='2402'	Then
	SELECT JUNYONG_YMD
	  INTO :ldt
	  FROM SZX0AA aa
	 WHERE aa.corp_gr = :gaa.corp_gr;

	dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)
Else
	dw_c.object.ymd [1] = idt_workdate
End IF
dw_c.object.dddw [1] = ia_value [1]
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja020r
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja020r
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja020r
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja020r
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja020r
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja020r
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja020r
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja020r
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja020r
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja020r
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja020r
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja020r
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja020r
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja020r
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja020r
end type

type p_close from wt_vertdetail`p_close within w_ja020r
end type

type p_excel from wt_vertdetail`p_excel within w_ja020r
end type

type p_print from wt_vertdetail`p_print within w_ja020r
end type

type p_delete from wt_vertdetail`p_delete within w_ja020r
end type

type p_update from wt_vertdetail`p_update within w_ja020r
end type

type p_input from wt_vertdetail`p_input within w_ja020r
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja020r
end type

type p_clear from wt_vertdetail`p_clear within w_ja020r
end type

type p_copy from wt_vertdetail`p_copy within w_ja020r
end type

type dw_c from wt_vertdetail`dw_c within w_ja020r
string title = "수정기준일@유가증권구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', '', 'd_ja020r2c,채권취득액,,d_ja020r2h,현금(전단채)취득액,,d_ja020r2j,주식취득액,', 1, '')
end event

type btn_update from wt_vertdetail`btn_update within w_ja020r
end type

type st_count from wt_vertdetail`st_count within w_ja020r
end type

type dw_list from wt_vertdetail`dw_list within w_ja020r
string dataobject = "d_ja020r1"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sec_cd | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::ue_retrieve;call super::ue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja020r
string dataobject = "d_ja020r2h"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;uf_dataobject (ia_value [1], FALSE)
retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_list.object.fund_cd [iRow])
end event

event dw_detail::itemchanged;call super::itemchanged;IF	f_num (data)=0	Then
	Object.ip_user [row] = null_s
Else
	Object.ip_user [row] = gaa.login
End IF
end event

type st_move from wt_vertdetail`st_move within w_ja020r
boolean leftmaxsizefixed = true
end type

