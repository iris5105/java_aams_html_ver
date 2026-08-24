forward
global type w_ja051b from wt_vertdetail
end type
end forward

global type w_ja051b from wt_vertdetail
boolean eb_direct_retrieve = true
integer ii_dddw_width = 500
integer ii_dddw_width2 = 350
end type
global w_ja051b w_ja051b

type variables
DateTime	idt_ymd
STRING	is_work_gb = 'A'
end variables

on w_ja051b.create
int iCurrent
call super::create
end on

on w_ja051b.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ('')
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja051b
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja051b
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja051b
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja051b
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja051b
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja051b
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja051b
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja051b
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja051b
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja051b
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja051b
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja051b
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja051b
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja051b
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja051b
end type

type p_close from wt_vertdetail`p_close within w_ja051b
end type

type p_excel from wt_vertdetail`p_excel within w_ja051b
end type

type p_print from wt_vertdetail`p_print within w_ja051b
end type

type p_delete from wt_vertdetail`p_delete within w_ja051b
end type

type p_update from wt_vertdetail`p_update within w_ja051b
end type

type p_input from wt_vertdetail`p_input within w_ja051b
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja051b
end type

type p_clear from wt_vertdetail`p_clear within w_ja051b
end type

type p_copy from wt_vertdetail`p_copy within w_ja051b
end type

type dw_c from wt_vertdetail`dw_c within w_ja051b
boolean visible = false
boolean enabled = false
string title = ""
end type

type btn_update from wt_vertdetail`btn_update within w_ja051b
end type

type st_count from wt_vertdetail`st_count within w_ja051b
end type

type dw_list from wt_vertdetail`dw_list within w_ja051b
integer y = 156
integer height = 2608
string dataobject = "d_ja051b1"
end type

type dw_detail from wt_vertdetail`dw_detail within w_ja051b
integer y = 156
integer height = 2608
string dataobject = "d_ja051b2"
string islist4subbtnauth = "0011110000"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.corp_gr [iRow])
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'mail_cd'
		CHOOSE CASE LEFT (Object.mail_gb [row],1)
			CASE 'F'
				rs_where = "fd.corp_gr='" + dw_list.object.corp_gr [iRow] + "'"
			CASE 'S'
				rs_where = "fd.corp_gr='" + dw_list.object.corp_gr [iRow] + "'"
				RETURN 2
			CASE 'G'
				rs_where = "pa.corp_gr='" + dw_list.object.corp_gr [iRow] + "'"
				RETURN 3
		END CHOOSE
END CHOOSE
RETURN 1
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('corp_gr', dw_list.object.corp_gr [iRow])
uf_setcolumn ('mail_gb', 'F1')
uf_setcolumn ('to_addr', '@')
RETURN 0
end event

event dw_detail::clicked;call super::clicked;LONG	ll, ll_name
CHOOSE CASE dwo.name
	CASE 'to_cc'
		str_parameter lstr_parm
		STRING	ls_cc
		IF	row>0	Then
			lstr_parm.str[1] = Object.to_cc [row] ; ls_cc = lstr_parm.str[1]
			openwithParm (w_popup_mail_cc, lstr_parm)
			lstr_parm = Message.PowerObjectParm
			IF	UPPERBOUND (lstr_parm.str)=1	Then
				IF	f_nvl(ls_cc,'')<>lstr_parm.str[1]	Then
					Object.to_cc [row] = lstr_parm.str[1]
					IF	f_null (ls_cc)	Then
						IF	f_messagebox ('INFO2', '동일한 발송자 참조주소를 일괄변경 하시겠습니까?')=1	Then
							FOR  ll = 1  TO  rowcount ()
								IF	row<>ll And Object.to_addr [row]=Object.to_addr [ll] THEN Object.to_cc [ll] = lstr_parm.str[1]
							NEXT
						End IF
					Else
						IF	f_messagebox ('INFO2', '동일한 참조주소를 일괄변경 하시겠습니까?')=1	Then
							FOR  ll = 1  TO  rowcount ()
								IF	row<>ll And ls_cc=Object.to_cc [ll] THEN Object.to_cc [ll] = lstr_parm.str[1]
							NEXT
						End IF
					End IF
				End IF
			End IF
		End IF
END CHOOSE
end event

event dw_detail::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mail_gb', '', '', 1, '')
end event

event dw_detail::itemchanged;call super::itemchanged;IF	row>0	Then
	LONG	ll
	CHOOSE CASE dwo.name
		CASE 'to_addr'
			IF	f_notnull (uf_item_before ())	Then
				IF	f_messagebox ('INFO2', '동일한 발송자 주소를 일괄변경 하시겠습니까?')=1	Then
					FOR  ll = 1  TO  rowcount ()
						IF	row<>ll And uf_item_before ()=Object.to_addr [ll] THEN Object.to_addr [ll] = data
					NEXT
				End IF
			End IF
		CASE 'to_name'
			IF	f_messagebox ('INFO2', '동일한 발송자명을 일괄변경 하시겠습니까?')=1	Then
				FOR  ll = 1  TO  rowcount ()
					IF	row<>ll And Object.to_addr [row]=Object.to_addr [ll] THEN Object.to_name [ll] = data
				NEXT
			End IF
	END CHOOSE
End IF
end event

type st_move from wt_vertdetail`st_move within w_ja051b
integer y = 156
integer height = 2608
boolean leftmaxsizefixed = true
end type

