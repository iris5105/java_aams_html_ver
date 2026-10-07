forward
global type w_ja030a from wt_list
end type
end forward

global type w_ja030a from wt_list
string is_init_value = "J92"
end type
global w_ja030a w_ja030a

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], ia_value [1], dw_c.object.jj_cd [1])
end event

on w_ja030a.create
int iCurrent
call super::create
end on

on w_ja030a.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja030a
end type

type ln_templeft from wt_list`ln_templeft within w_ja030a
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja030a
end type

type ln_temptop from wt_list`ln_temptop within w_ja030a
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja030a
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja030a
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja030a
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja030a
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja030a
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja030a
end type

type ln_tempright from wt_list`ln_tempright within w_ja030a
end type

type uo_navi from wt_list`uo_navi within w_ja030a
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja030a
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja030a
end type

type st_top_rect from wt_list`st_top_rect within w_ja030a
end type

type p_close from wt_list`p_close within w_ja030a
end type

type p_excel from wt_list`p_excel within w_ja030a
end type

type p_print from wt_list`p_print within w_ja030a
end type

type p_delete from wt_list`p_delete within w_ja030a
end type

type p_update from wt_list`p_update within w_ja030a
end type

type p_input from wt_list`p_input within w_ja030a
end type

type p_retrieve from wt_list`p_retrieve within w_ja030a
end type

type p_clear from wt_list`p_clear within w_ja030a
end type

type p_copy from wt_list`p_copy within w_ja030a
end type

type dw_c from wt_list`dw_c within w_ja030a
integer height = 348
string dataobject = "d_ja030a"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'tr_ymd'
      IF DateTime(Date(MidA(data,1,10)))>=idt_workdate   Then
         ib_manageData = TRUE
         Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='" + Object.dddw [1] + "'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA030A' and szx0gc.tr_cd in (select tr_cd from sjt5j1 where corp_gr=':corp_gr' and tr_ymd='"+MidA(data,1,10)+"')")
      End IF
      Object.danc_gb_t.Visible = ib_manageData
      Object.danc_gb.Visible = ib_manageData
      Object.jj_cd [1] = null_s
      Object.xx_jj_cd [1] = null_s

   CASE 'dddw'
      IF ib_manageData THEN Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='" + data + "'")
      Object.jj_cd [1] = null_s
      Object.xx_jj_cd [1] = null_s

   CASE 'danc_gb'  // 시장구분
      Object.jj_cd [1] = null_s
      Object.xx_jj_cd [1] = null_s

//   CASE 'balh_co'
//      IF ib_manageData  Then
//         RETURN uf_itemerror ('balh_co', '입력할수 없습니다. 우측버튼을 사용하십시오.')
//      End IF
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA030A'")
dw_c.object.danc_gb [1] = f_dddwctl (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='" + dw_c.object.dddw [1] + "'")
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'balh_co'
      IF ib_manageData  Then
      ELSE
         rs_Where = "balh_co in (select balh_co from sjt5j1 where tr_ymd='" + string (Object.tr_ymd [1], 'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
   CASE 'jj_cd'
      IF ib_manageData  Then
         rs_where = "danc_gb='" + Object.danc_gb [1] + "' and balh_co='" + Object.balh_co [1] + "'"
      Else
         rs_Where = "jm_cd in (select jm_cd from sjt5j1 where tr_ymd='" + string (Object.tr_ymd [1], 'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
END CHOOSE

RETURN 1
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    sjt5j1 t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :rs_ymd
  AND   ROWNUM = 1;
  li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

event dw_c::ue_valid;call super::ue_valid;IF f_null (Object.balh_co [1])   Then
   f_messageBox ('W007', '발행기관')
   SetColumn ('balh_co')
   RETURN FALSE
End IF

RETURN TRUE
end event

event dw_c::oue_keydown;call super::oue_keydown;IF ib_manageData  Then
	IF getcolumnname() = 'balh_co' Then
		Object.balh_co [1] = ''
		f_messageBox ('I000', '입력할수 없습니다. 우측버튼을 사용하십시오.')
		RETURN -1
	End IF
End IF
end event

type btn_update from wt_list`btn_update within w_ja030a
end type

type st_count from wt_list`st_count within w_ja030a
end type

type dw_list from wt_list`dw_list within w_ja030a
integer y = 520
integer height = 2244
string dataobject = "d_ja030a1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'tr_jusu'
      Object.tr_aek [row] = dec (data) * Object.tr_danga [row]
      Object.gyul_aek [row] = Object.tr_aek [row] + Object.susu [row]

   CASE 'tr_danga'
      Object.tr_aek [row] = dec (data) * Object.tr_jusu [row]
      Object.gyul_aek [row] = Object.tr_aek [row] + Object.susu [row]

   CASE 'susu'
      Object.gyul_aek [row] = Object.tr_aek [row] + dec (data)
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	lRow

lRow = GetRow ()

IF lRow>0 THEN uf_setColumn ('tr_danga', string(object.tr_danga [lRow]))
uf_setColumn ('tr_ymd', string(dw_c.object.tr_ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('jm_cd', dw_c.object.jj_cd [1])
uf_setColumn ('krak_ymd', string(dw_c.object.krak_ymd [1]))
uf_setColumn ('balh_co', dw_c.object.balh_co [1])
uf_setColumn ('balh_ga', string(dw_c.object.balh_ga [1]))
uf_setColumn ('cheng_ymd', string(dw_c.object.cheng_ymd [1]))
uf_setColumn ('type_trench', '00:')
uf_setColumn ('bs_type', '0')

POST SetColumn ("fund_cd")

RETURN 0
end event

