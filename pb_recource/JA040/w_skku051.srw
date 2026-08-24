forward
global type w_skku051 from wt_vertole
end type
end forward

global type w_skku051 from wt_vertole
integer ii_dddw_position = 1
end type
global w_skku051 w_skku051

on w_skku051.create
int iCurrent
call super::create
end on

on w_skku051.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;f_visible (dw_c, false, 'ymd_t')
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.rcd [1])
end event

event wue_update;call super::wue_update;LONG	ll, ll_list

STRING	sMsg, la_args[]
BOOLEAN	lb_clicked = false

IF	AncestorReturnValue=1	Then
	ll_list = dw_list.rowcount ()
	FOR  ll = 1  TO  ll_list
		IF	idt_workdate >= dw_list.object.medo_ymd [ll] And idt_workdate <= dw_list.object.inchul_ymd [ll]  &
		                                                And dw_list.object.ymd [ll] >= dw_list.object.medo_ymd [ll] &
																		And dw_list.object.ymd [ll] <= dw_list.object.inchul_ymd [ll]	Then
			sMsg = Space (200)
			la_args[1] = gaa.corp_gr
			la_args[2] = string (dw_list.object.ymd [ll],'yyyymmdd')
			la_args[3] = dw_list.object.mc_code [ll]
			la_args[4] = 'KRW'
			la_args[5] = '999'
			la_args[6] = string (dw_list.object.medo_ymd [ll],'yyyymmdd')
			la_args[7] = 'ref'
			SQLCA.singleconnection ()
			SQLCA.SP_CALL(THIS, 'AAMS.SR_SKKP010_950_COM_JM ( ?, ?, ?, ?, ?, ?, ? )', la_args[], sMsg )
			sMsg = f_nvl (SQLCA.getitemplsql (1), 'N')
			lb_clicked = true
		End IF
	NEXT
End IF
IF	lb_clicked THEN p_retrieve.POST EVENT clicked ()
RETURN 1
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_skku051
end type

type ln_templeft from wt_vertole`ln_templeft within w_skku051
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_skku051
end type

type ln_temptop from wt_vertole`ln_temptop within w_skku051
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_skku051
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_skku051
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_skku051
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_skku051
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_skku051
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_skku051
end type

type ln_tempright from wt_vertole`ln_tempright within w_skku051
end type

type uo_navi from wt_vertole`uo_navi within w_skku051
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_skku051
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_skku051
end type

type st_top_rect from wt_vertole`st_top_rect within w_skku051
end type

type p_close from wt_vertole`p_close within w_skku051
end type

type p_excel from wt_vertole`p_excel within w_skku051
end type

type p_print from wt_vertole`p_print within w_skku051
end type

type p_delete from wt_vertole`p_delete within w_skku051
end type

type p_update from wt_vertole`p_update within w_skku051
end type

type p_input from wt_vertole`p_input within w_skku051
end type

type p_retrieve from wt_vertole`p_retrieve within w_skku051
end type

type p_clear from wt_vertole`p_clear within w_skku051
end type

type p_copy from wt_vertole`p_copy within w_skku051
end type

type dw_c from wt_vertole`dw_c within w_skku051
string title = "운용펀드@평가일자"
string dataobject = "dc_xx_ymd"
end type

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;rs_where = "t1.fund_cd in (select mc_code from aams.tjm0aa where corp_gr='" + gaa.corp_gr + "')"
RETURN 50
end event

type btn_update from wt_vertole`btn_update within w_skku051
end type

type st_count from wt_vertole`st_count within w_skku051
end type

type dw_list from wt_vertole`dw_list within w_skku051
boolean visible = true
boolean enabled = true
string dataobject = "d_skku051"
end type

event dw_list::ue_protect;call super::ue_protect;IF	Object.p_visible [row]=1	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

type st_move from wt_vertole`st_move within w_skku051
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_skku051
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;IF	 dw_c.object.rcd [1]='21A02'	Then
	uf_fileopen ('rd_skku051b.mrd', &
								'mc_code[' + dw_c.object.rcd [1] + '] ' + &
								'fund_nm[' + dw_c.object.xx_rcd [1] + '] ' + &
								'jm_cd[' + dw_list.object.jm_cd [row] + '] ' + &
								'jm_nm[' + dw_list.object.xx_jm_cd [row] + '] ' + &
								'ymd[' + string (dw_list.object.ymd [row],'yyyy.mm.dd') + ']' )
Else
	uf_fileopen ('rd_skku051.mrd', &
								'mc_code[' + dw_c.object.rcd [1] + '] ' + &
								'fund_nm[' + dw_c.object.xx_rcd [1] + '] ' + &
								'jm_cd[' + dw_list.object.jm_cd [row] + '] ' + &
								'jm_nm[' + dw_list.object.xx_jm_cd [row] + '] ' + &
								'ymd[' + string (dw_list.object.ymd [row],'yyyy.mm.dd') + ']' )
End IF
end event

type rb_onepage from wt_vertole`rb_onepage within w_skku051
end type

