forward
global type w_ja035p from wt_listdetail
end type
end forward

global type w_ja035p from wt_listdetail
string is_date_nation = "US"
end type
global w_ja035p w_ja035p

on w_ja035p.create
int iCurrent
call super::create
end on

on w_ja035p.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja035p
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja035p
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja035p
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja035p
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja035p
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja035p
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja035p
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja035p
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja035p
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja035p
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja035p
end type

type uo_navi from wt_listdetail`uo_navi within w_ja035p
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja035p
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja035p
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja035p
end type

type p_close from wt_listdetail`p_close within w_ja035p
end type

type p_excel from wt_listdetail`p_excel within w_ja035p
end type

type p_print from wt_listdetail`p_print within w_ja035p
end type

type p_delete from wt_listdetail`p_delete within w_ja035p
end type

type p_update from wt_listdetail`p_update within w_ja035p
end type

type p_input from wt_listdetail`p_input within w_ja035p
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja035p
end type

type p_clear from wt_listdetail`p_clear within w_ja035p
end type

type p_copy from wt_listdetail`p_copy within w_ja035p
end type

type dw_c from wt_listdetail`dw_c within w_ja035p
string title = "영업일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listdetail`btn_update within w_ja035p
end type

type st_count from wt_listdetail`st_count within w_ja035p
end type

type dw_list from wt_listdetail`dw_list within w_ja035p
string dataobject = "d_ja035p1"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_cd', gaa.corp_gr, '', 1, "tr_cd in ('E83','E84')")
F_DDDWCTL (THIS, 'gwamok', gaa.corp_gr, '', 1, "gwamok in ('12352','12357')")

end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_cd', 'E83')
uf_setcolumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setcolumn ('tr_seq', '1')
uf_setcolumn ('gwamok', '12352')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'hj_cd'
      rs_where = "t1.ymd='" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' and t1.fund_cd='" + Object.fund_cd [iRow] + "' and hj.CASH_CD <> '90'"
      RETURN 2
END CHOOSE

RETURN 1
end event

event dw_list::itemchanged_next;call super::itemchanged_next;LONG	ll

CHOOSE CASE name
   CASE 'tr_ymd'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.tr_ymd [ll] = Object.tr_ymd [row]
      NEXT
   CASE 'tr_cd'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.tr_cd [ll] = Object.tr_cd [row]
      NEXT
   CASE 'fund_cd'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.fund_cd [ll] = Object.fund_cd [row]
      NEXT
	CASE 'trustee'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.trustee [ll] = Object.trustee [row]
      NEXT	
   CASE 'hj_cd'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.hj_cd [ll] = Object.hj_cd [row]
      NEXT
   CASE 'tr_seq'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.tr_seq [ll] = Object.tr_seq [row]
      NEXT
   CASE 'aek_gb'
      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.aek_gb [ll] = Object.aek_gb [row]
      NEXT
	CASE 'sanghw_aek'
		dw_list.object.jan_aek [iRow] = dw_list.object.aek [iRow] - Object.aek_sum [1]
		IF dw_list.object.jan_aek [iRow]<0 THEN f_messageBox ('ERR', '상환유예액을 초과했습니다.')
		IF dw_list.object.jan_aek [iRow]=0  Then
			dw_list.object.sanghw_ymd [iRow] = Object.sanghw_ymd [iRow]
		Else
			dw_list.object.sanghw_ymd [iRow] = null_dt
		End IF
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

type dw_detail from wt_listdetail`dw_detail within w_ja035p
integer x = 55
string dataobject = "d_ja035p2"
end type

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('tr_ymd', string (dw_list.object.tr_ymd [iRow]))
uf_setcolumn ('tr_cd', dw_list.object.tr_cd [iRow])
uf_setcolumn ('fund_cd', dw_list.object.fund_cd [iRow])
uf_setcolumn ('hj_cd', dw_list.object.hj_cd [iRow])
uf_setcolumn ('tr_seq', string (dw_list.object.tr_seq [iRow]))
uf_setcolumn ('aek_gb', (dw_list.object.aek_gb [iRow]))
uf_setcolumn ('sanghw_ymd', string (idt_workdate))

setcolumn ('sanghw_ymd')

RETURN 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.tr_ymd [iRow], dw_list.object.tr_cd [iRow], dw_list.object.fund_cd [iRow], dw_list.object.hj_cd [iRow], dw_list.object.tr_seq [iRow], dw_list.object.aek_gb [iRow])
end event

type st_move from wt_listdetail`st_move within w_ja035p
end type

