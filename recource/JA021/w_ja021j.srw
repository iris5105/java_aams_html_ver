forward
global type w_ja021j from wt_list
end type
type cb_2 from pf_u_commandbutton within w_ja021j
end type
end forward

global type w_ja021j from wt_list
string is_init_value = "F18"
cb_2 cb_2
end type
global w_ja021j w_ja021j

on w_ja021j.create
int iCurrent
call super::create
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_ja021j.destroy
call super::destroy
destroy(this.cb_2)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
dw_c.object.xx_balh_ga [1] = 0
end event

event wue_retrieve;call super::wue_retrieve;cb_2.of_setenabled(ib_managedata)
ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], ia_value [1], dw_c.object.xx_jm_cd [1])
end event

event wue_clear;call super::wue_clear;cb_2.of_setenabled(FALSE)
end event

event open;icmdbutton = { cb_2 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja021j
end type

type ln_templeft from wt_list`ln_templeft within w_ja021j
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja021j
end type

type ln_temptop from wt_list`ln_temptop within w_ja021j
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja021j
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja021j
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja021j
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja021j
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja021j
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja021j
end type

type ln_tempright from wt_list`ln_tempright within w_ja021j
end type

type uo_navi from wt_list`uo_navi within w_ja021j
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja021j
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja021j
end type

type st_top_rect from wt_list`st_top_rect within w_ja021j
end type

type p_close from wt_list`p_close within w_ja021j
end type

type p_excel from wt_list`p_excel within w_ja021j
end type

type p_print from wt_list`p_print within w_ja021j
end type

type p_delete from wt_list`p_delete within w_ja021j
end type

type p_update from wt_list`p_update within w_ja021j
end type

type p_input from wt_list`p_input within w_ja021j
end type

type p_retrieve from wt_list`p_retrieve within w_ja021j
end type

type p_clear from wt_list`p_clear within w_ja021j
end type

type p_copy from wt_list`p_copy within w_ja021j
end type

type dw_c from wt_list`dw_c within w_ja021j
integer height = 196
string dataobject = "d_ja021j"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA021J'")
Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='F18'")
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'koscom_cd'
      IF ib_manageData  Then
         rs_Where = "danc_gb='" + Object.danc_gb [1] + "'"
      Else
         rs_Where = "jm_cd in (select jm_cd from sjt0cy where corp_gr='" + gaa.corp_gr + "' and tr_ymd='" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "' and tr_cd='" + Object.dddw [1] + "')"
      End IF
      RETURN 2
END CHOOSE

RETURN 1
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

STRING	ls_tr_cd

ls_tr_cd = Object.dddw [1]

SELECT  1
  INTO  :li_ret
FROM    sjt0cy t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :rs_ymd
  AND   t1.tr_cd   = :ls_tr_cd
  AND   ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'tr_ymd'
      IF datetime (date (mida (data,1,10)))>=idt_workdate OR gaa.aams Then
         ib_manageData = TRUE
      Else
         ib_manageData = FALSE
      End IF
      Object.danc_gb_t.visible = ib_manageData
      Object.danc_gb.visible = ib_manageData
      Object.danc_gb_rect.visible = ib_manageData
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s

   CASE 'danc_gb'  // 시장구분
      Object.koscom_cd [1] = null_s
      Object.xx_koscom_cd [1] = null_s
      Object.xx_jm_cd [1] = null_s
END CHOOSE
end event

event dw_c::ue_valid;call super::ue_valid;IF f_null (Object.koscom_cd [1]) Then
   f_messageBox ('W007', '단축코드')
   SetColumn ('koscom_cd')
   RETURN FALSE
End IF

RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja021j
end type

type st_count from wt_list`st_count within w_ja021j
end type

type dw_list from wt_list`dw_list within w_ja021j
integer y = 388
integer height = 2372
string dataobject = "d_ja021j1"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'cheng_jusu'
      Object.cheng_aek [row] = dec (data) * dw_c.object.xx_balh_ga [1]
END CHOOSE
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_Where = "haeji_ymd is null"
END CHOOSE
RETURN 1
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'sutak_cd', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.tr_ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('koscom_cd', dw_c.object.koscom_cd [1])
uf_setColumn ('jm_cd', dw_c.object.xx_jm_cd [1])
uf_setColumn ('danga', string (dw_c.object.xx_balh_ga [1]))

POST SetColumn ("fund_cd")

RETURN 0
end event

type cb_2 from pf_u_commandbutton within w_ja021j
integer x = 2263
integer y = 16
integer width = 457
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "보유수량생성"
end type

event clicked;DateTime ldt_tr_ymd

STRING	ls_jm_cd, ls_sqlsyntax

LONG		lR, lm

aDS_jTier	lds_jtier

ldt_tr_ymd = dw_c.object.tr_ymd [1]
ls_jm_cd = dw_c.object.xx_jm_cd [1]

ls_sqlsyntax = "   SELECT  t1.fund_cd " &
             + "         , t2.fund_nm " &
             + "         , t1.sury_aek " &
             + "         , t1.jm_cd " &
             + "         , t2.mg_cd " &
             + "   FROM    sjt0fs t1 " &
             + "         , szm0ia t2 " &
             + "   WHERE   t1.corp_gr = '" + gaa.corp_gr + "' " &
             + "     AND   t1.tr_ymd  Between  ( to_date ('" + string (ldt_tr_ymd,'yyyy.mm.dd') + "') - 1) And '" + string (ldt_tr_ymd,'yyyy.mm.dd') + "' " &
             + "     AND   t1.tr_cd   = 'F17' " &
             + "     AND   t1.jm_cd   = '" + ls_jm_cd + "' " &
             + "     AND   t2.corp_gr = t1.corp_gr " &
             + "     AND   t2.fund_cd = t1.fund_cd " &
             + "   ORDER BY  t2.mg_cd " &
             + "           , t1.fund_cd "

LONG	ll

STRING	sFund_cd, sFund_nm, sJm_cd, sSutak_cd

DEC	dBoyu_jusu, ld_sinju  // 신주인수권 수량

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lm = 1  TO  lR
    sFund_cd   = lds_jtier.getitemstring (lm, 1)
    sFund_nm   = lds_jtier.getitemstring (lm, 2)
    dBoyu_jusu = lds_jtier.getitemnumber (lm, 3)
    sJm_cd     = lds_jtier.getitemstring (lm, 4)
    sSutak_cd  = lds_jtier.getitemstring (lm, 5)

   SELECT  NVL(sum(tr_jusu),0)
     INTO  :ld_sinju
   FROM    sjt5j1 t1
   WHERE   t1.corp_gr   = :gaa.corp_gr
     AND   t1.fund_cd   = :sFund_cd
     AND   t1.jm_cd     = :sJm_cd
     AND   t1.cheng_ymd = :ldt_tr_ymd;
	
	ld_sinju = SQLCA.getitemnumber (1)
	
   ll = dw_list.FIND ("mg_cd='" + ssutak_cd + "' and fund_cd='" + sFund_cd + "' and jm_cd='" + dw_c.object.xx_jm_cd [1] + "'", 1, dw_list.rowcount ())
   IF ll=0 THEN ll = dw_list.insertrow (0)
   dw_list.object.corp_gr [ll] = gaa.corp_gr
   dw_list.object.sutak_cd [ll] = sSutak_cd
   dw_list.object.fund_cd [ll] = sFund_cd
   dw_list.object.xx_fund_cd [ll] = sFund_nm
   dw_list.object.tr_ymd [ll] = dw_c.object.tr_ymd [1]
   dw_list.object.tr_cd [ll] = dw_c.object.dddw [1]
   dw_list.object.koscom_cd [ll] = dw_c.object.koscom_cd [1]
   dw_list.object.jm_cd [ll] = dw_c.object.xx_jm_cd [1]
   dw_list.object.danga [ll] = dw_c.object.xx_balh_ga [1]
   dw_list.object.hwakj_jusu [ll] = dBoyu_jusu + ld_sinju
   dw_list.object.cheng_jusu [ll] = dBoyu_jusu + ld_sinju
   dw_list.object.cheng_aek [ll] = dBoyu_jusu * dw_c.object.xx_balh_ga [1]
NEXT

messageBox ('msg', '작업이 완료되었습니다')
end event

