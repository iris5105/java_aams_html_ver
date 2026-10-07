forward
global type w_ja030d from wt_list
end type
end forward

global type w_ja030d from wt_list
integer ii_dddw_width = 850
string is_init_value = "K13"
end type
global w_ja030d w_ja030d

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1])
end event

on w_ja030d.create
int iCurrent
call super::create
end on

on w_ja030d.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja030d
end type

type ln_templeft from wt_list`ln_templeft within w_ja030d
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030d
end type

type ln_temptop from wt_list`ln_temptop within w_ja030d
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030d
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030d
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030d
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030d
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030d
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030d
end type

type ln_tempright from wt_list`ln_tempright within w_ja030d
end type

type uo_navi from wt_list`uo_navi within w_ja030d
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030d
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030d
end type

type st_top_rect from wt_list`st_top_rect within w_ja030d
end type

type p_close from wt_list`p_close within w_ja030d
end type

type p_excel from wt_list`p_excel within w_ja030d
end type

type p_print from wt_list`p_print within w_ja030d
end type

type p_delete from wt_list`p_delete within w_ja030d
end type

type p_update from wt_list`p_update within w_ja030d
end type

type p_input from wt_list`p_input within w_ja030d
end type

type p_retrieve from wt_list`p_retrieve within w_ja030d
end type

type p_clear from wt_list`p_clear within w_ja030d
end type

type p_copy from wt_list`p_copy within w_ja030d
end type

type dw_c from wt_list`dw_c within w_ja030d
string title = "매도일자@매매구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA030D'")
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

STRING	ls_tr_cd

ls_tr_cd = Object.dddw [1]

SELECT 1
  INTO :li_ret
  FROM SCT0CG t1
 WHERE t1.corp_gr = :gaa.corp_gr
   AND tr_ymd     = :rs_ymd
   AND tr_cd      = :ls_tr_cd
   AND ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN  li_ret
end event

type btn_update from wt_list`btn_update within w_ja030d
end type

type st_count from wt_list`st_count within w_ja030d
end type

type dw_list from wt_list`dw_list within w_ja030d
string dataobject = "d_ja030d"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lSeq

STRING	ls_tr_co_cd, ls_fund_cd, ls_tr_cd
DATETIME ldt

ls_tr_cd = dw_c.object.dddw [1]

CHOOSE CASE dwo.name
   CASE 'tr_ymd'
      ldt = DATETIME (DATE (MidA (data,1,10)))
      IF ldt<dw_c.object.ymd [1] THEN
         RETURN uf_itemerr (row, 'tr_ymd', '매도일 입력오류.')
      End IF

      IF ldt<dw_c.object.ymd [1] THEN
         // 신규생성에 의한 일괄처리를 위해
         Object.sudo_ymd [row] = dw_c.object.ymd [1]
      ELSE
         Object.sudo_ymd [row] = ldt
      End IF

      ls_fund_cd = Object.fund_cd [row]

      SELECT NVL(MAX(seq_no), 0) + 1
        INTO :lSeq
        FROM SCT0CG t1
       WHERE corp_gr = :gaa.corp_gr
         AND tr_ymd  = :ldt
         AND fund_cd = :ls_fund_cd
         AND tr_cd   = :ls_tr_cd;

      Object.seq_no [row] = SQLCA.getitemnumber (1)

   CASE 'fund_cd'
      SELECT mg_cd
        INTO :ls_tr_co_cd
        FROM SZM0IA ia
       WHERE ia.corp_gr = :gaa.corp_gr
         AND ia.fund_cd = :data;

      Object.tr_co_cd [row] = SQLCA.getitemstring (1)

      ldt = Object.tr_ymd [row]

      SELECT NVL(MAX(seq_no), 0) + 1
        INTO :lSeq
        FROM SCT0CG t1
       WHERE corp_gr = :gaa.corp_gr
         AND tr_ymd  = :ldt
         AND fund_cd = :data
         AND tr_cd   = :ls_tr_cd;

      Object.seq_no [row] = SQLCA.getitemnumber (1)

	 CASE 'sudo_ymd'
      IF datetime (date (MidA (data,1,10)))<Object.tr_ymd [row] THEN
         RETURN uf_itemerr (row, 'sudo_ymd', '수도결제일이 매매일보다 작습니다.')
      End IF
		IF	dw_c.object.dddw [1]='K11' And datetime (date (MidA (data,1,10)))=Object.tr_ymd [row]	Then
         RETURN uf_itemerr (row, 'sudo_ymd', '수도결제일이 매매일보다 커야 합니다.')
		End IF

	CASE 'com_danga'
      Object.danga [row]  = dec (data) / 10000
      Object.tr_aek [row] = dec (data) / 10000 * Object.aekm [row]
		Object.cre_user [row] = null_s

	CASE 'soduk_tax'
      Object.jumin_tax [row] = truncate (dec (data) * .1 / 10, 0) * 10
		Object.ija_tax [row] = dec (data) + f_num (Object.jumin_tax [row])

	CASE 'jujmin_tax'
		Object.ija_tax [row] = f_num (Object.soduk_tax [row]) + dec (data)

	CASE 'ija_tax'
      Object.soduk_tax [row] = dec (data)

	CASE 'aekm'
      Object.tr_aek [row] = dec (data) * Object.danga [row]

	CASE 'tr_aek'
      Object.chui_aek [row] = dec (data)
      Object.com_danga [row] = truncate (dec (data) / Object.aekm [row] * 10000, 2)
      Object.danga [row] = dec (data) / Object.aekm [row]
END CHOOSE

end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	ll

DATETIME ldt
string	ls_tr_cd

ldt = dw_c.object.ymd[1]
ls_tr_cd = dw_c.object.dddw [1]

uf_setcolumn ('tr_cd', ls_tr_cd)
uf_setcolumn ('tr_ymd', STRING (dw_c.object.ymd [1]))
uf_setcolumn ('sudo_ymd', STRING (dw_c.object.ymd [1]))

SELECT NVL(MAX(seq_no), 0) + 1
  INTO :ll
  FROM SCT0CG t1
 WHERE corp_gr = :gaa.corp_gr
   AND tr_cd   = :ls_tr_cd
   AND tr_ymd  = :ldt;

ll = SQLCA.getitemnumber (1)
uf_setcolumn ('seq_no', STRING(ll))

POST SetColumn ('tr_ymd')

RETURN 0
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
      CASE 'fund_cd'
         rs_where = "t1.ymd='" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' "
         RETURN 11
END CHOOSE
RETURN 1

end event

