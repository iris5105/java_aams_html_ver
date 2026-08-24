forward
global type w_ja010b from wt_listdetail
end type
type st_1 from pf_u_splitbar_vertical within w_ja010b
end type
type cb_pj from pf_u_commandbutton within w_ja010b
end type
type mle_special_note from u_mle within w_ja010b
end type
type dw_1 from u_dw within w_ja010b
end type
end forward

global type w_ja010b from wt_listdetail
boolean eb_direct_retrieve = true
integer ii_dddw_width = 800
string is_find = "fund_cd=~'~'"
st_1 st_1
cb_pj cb_pj
mle_special_note mle_special_note
dw_1 dw_1
end type
global w_ja010b w_ja010b

on w_ja010b.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_pj=create cb_pj
this.mle_special_note=create mle_special_note
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_pj
this.Control[iCurrent+3]=this.mle_special_note
this.Control[iCurrent+4]=this.dw_1
end on

on w_ja010b.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_pj)
destroy(this.mle_special_note)
destroy(this.dw_1)
end on

event wue_retrieve;call super::wue_retrieve;mle_special_note.uf_init ('', ib_ManageData)
is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (dw_c.object.dddw [1])
end event

event wue_lastopen;call super::wue_lastopen;f_setprotect (dw_c, NOT (gaa.admin OR gaa.aams), { 'dddw' }) ; f_dddwctl (dw_c, 'dddw | corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*'")
dw_c.object.dddw [1] = gaa.corp_gr
p_retrieve.post event clicked ()
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
IF mle_special_note.displayonly Then mle_special_note.backcolor = gnv_vari.setcondbackcolor &
Else                                 mle_special_note.BackColor = rgb (240,255,255)
end event

event ue_wpage_modified;IF	dw_List.uf_isModified ()=FALSE And dw_Detail.uf_isModified ()=FALSE And dw_1.uf_isModified ()=FALSE And mle_special_note.ib_update=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
mle_special_note.uf_init ('', ib_ManageData)
IF	NOT gaa.ADMIN	Then
	p_retrieve.POST EVENT clicked ()
Else
	dw_detail.uf_clear ()
	dw_list.uf_clear ()
	dw_1.uf_clear ()

	p_retrieve.of_setenabled (true)
	EVENT ue_setdisabled ()

	IF	dw_c.describe ('p_visible.type')='column' THEN dw_c.setitem (1, 'p_visible', 1)
	dw_c.Enabled = TRUE
	dw_c.SetFocus () ; f_selectText (dw_c)
End IF
end event

event wue_update;IF	dw_list.AcceptText ()=-1 OR dw_detail.AcceptText ()=-1 OR dw_1.AcceptText ()=-1	Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF	EVENT ue_wpage_modified ()	Then
	IF	uf_UpdateCommit (dw_list, dw_detail)=-1 THEN RETURN -1
	IF	uf_updateCommit (dw_1)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event ue_setenabled;call super::ue_setenabled;IF	dw_1.ibsetlist4subbtn	Then
	IF dw_list.rowcount ()>0	Then
		dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
		dw_1.of_dw2subbtn ({'p_input'}, (dw_1.enabled And dw_1.eb_new_false=FALSE And ib_managedata))
		dw_1.of_dw2subbtn ({'p_copy'}, (dw_1.enabled And dw_1.eb_copy_false=FALSE And ib_managedata))
		dw_1.of_dw2subbtn ({'p_delete'}, (dw_1.enabled And dw_1.eb_delete_false=FALSE And ib_managedata))
	Else
		dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
	End IF
End IF
end event

event open;icmdbutton = { cb_pj }
call super::open
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja010b
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja010b
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja010b
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja010b
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja010b
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja010b
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja010b
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja010b
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja010b
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja010b
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja010b
end type

type uo_navi from wt_listdetail`uo_navi within w_ja010b
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja010b
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja010b
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja010b
end type

type p_close from wt_listdetail`p_close within w_ja010b
end type

type p_excel from wt_listdetail`p_excel within w_ja010b
end type

type p_print from wt_listdetail`p_print within w_ja010b
end type

type p_delete from wt_listdetail`p_delete within w_ja010b
end type

type p_update from wt_listdetail`p_update within w_ja010b
end type

type p_input from wt_listdetail`p_input within w_ja010b
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja010b
end type

type p_clear from wt_listdetail`p_clear within w_ja010b
end type

type p_copy from wt_listdetail`p_copy within w_ja010b
end type

type dw_c from wt_listdetail`dw_c within w_ja010b
string title = "운용사"
string dataobject = "dc_ymd_dddw"
end type

type btn_update from wt_listdetail`btn_update within w_ja010b
end type

type st_count from wt_listdetail`st_count within w_ja010b
end type

type dw_list from wt_listdetail`dw_list within w_ja010b
boolean enabled = true
string dataobject = "d_ja010b1"
boolean ibsettooltiphelp = true
boolean eb_copy_false = true
string is_encrypts = "enc_acct_no"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'type_gb', dw_c.object.dddw [1], '', 9, "")
f_dddwctl (THIS, 'unyong_sabun', dw_c.object.dddw [1], '', 1, "")
f_dddwctl (THIS, 'series_gb', dw_c.object.dddw [1], '', 1, "")
f_dddwctl (THIS, 'target_jasan', dw_c.object.dddw [1], '', 1, "")
f_dddwctl (THIS, 'mg_cd', dw_c.object.dddw [1], '', 1, "")
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

STRING	ls_corp_gr, ls_fund_cd, ls_acct_no

CHOOSE CASE DWO.NAME
	CASE 'pre_basic'
		IF	f_num (data)>0 THEN Object.basic_per [row] = null_dc
	CASE 'basic_per'
		IF	f_num (data)>0 THEN Object.pre_basic [row] = null_dc
   CASE 'acct_no'
		ls_corp_gr = dw_c.object.dddw [1]
      ls_fund_cd = Object.fund_cd [row]
      ls_acct_no = Object.acct_no [row]

      INSERT INTO SZT0IA
      VALUES ( :ls_corp_gr           /* _1- */
             , :ls_fund_cd           /* _2- */
             , 'acct_no'             /* _3- */
             , now()                 /* _4- */
             , :ls_acct_no           /* _5- */
             , NULL                  /* _6- */
             , :gnv_vari.is_user_id  /* _7- */
             ) ;
   CASE 're_seolj_ymd'
      IF GETITEMSTATUS (ROW, 0, PRIMARY!) = NEWMODIFIED! Then
         dw_1.object.tr_ymd [1]   = DATETIME (DATE (MID (data,1,10)))
         Object.bf_gyul_ymd [row] = null_dt
         Object.af_gyul_ymd [row] = null_dt
      ELSE
         IF DATETIME (DATE (MID (data,1,10))) <> dw_1.object.tr_ymd [1] Then
            IF f_num (dw_1.object.wonbon_aek [1]) = 0 Then
               dw_1.object.tr_ymd [1] = DATETIME (DATE (MID (data,1,10)))
            ELSE
               dw_1.insertrow (1)
               dw_1.SETROW (1)
               dw_1.object.CORP_GR [1] = gaa.CORP_GR
               dw_1.object.fund_cd [1] = Object.fund_cd [row]
               dw_1.object.tr_ymd [1]  = DATETIME (DATE (MID (data,1,10)))
            END IF
         END IF
      END IF
   CASE 'order_send'
      IF data = 'N'  Then
         Object.susu_rt [row] = 0.0005
         f_setprotect (THIS, false, { 'susu_rt' })
      ELSE
         Object.susu_rt [row] = null_dc
         f_setprotect (THIS, true, { 'susu_rt' })
      END IF
   CASE 'success_per'
      IF dec(data) = 0  Then
         Object.target_jasan [row] = '--'
      ELSE
         Object.target_jasan [row] = '++'
      END IF
END CHOOSE
end event

event dw_list::retrieveend;uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event dw_list::rowfocuschanged_if;iRow = currentrow

IF mle_special_note.displayonly Then mle_special_note.backcolor = gnv_vari.setcondbackcolor &
Else                                 mle_special_note.BackColor = rgb (240,255,255)
mle_special_note.TEXT = Object.special_note [iRow]

IF	detail_retrieve	Then
	uf_enabled (eb_rowchangewait, false)
	dw_detail.setredraw (false) ; dw_1.setredraw (false)
	dw_detail.uf_reset () ; dw_1.uf_reset ()
	dw_detail.event ue_retrieve () ; dw_1.event ue_retrieve ()
	dw_detail.setredraw (true) ; dw_1.setredraw (true)
	uf_enabled (eb_rowchangewait, true)
End IF
RETURN 0
end event

event dw_list::rowfocuschanging_return;IF mle_special_note.ib_update THEN Object.special_note [iRow] = mle_special_note.TEXT
IF Parent.EVENT wue_update ()=-1 THEN RETURN 1
RETURN 0
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF mle_special_note.ib_update THEN Object.special_note [iRow] = mle_special_note.TEXT

parent.event wue_update ()

STRING	ls_corp_gr

LONG	ll_fund

ll_fund = dec(string(idt_workdate,'yy')) * 100

ls_corp_gr = dw_c.object.dddw [1]

SELECT  NVL(MAX (fund_cd),:ll_fund) + 1
  INTO  :ll_fund
FROM    szm0ia t1
WHERE   corp_gr = :ls_corp_gr
  AND   fund_cd > TO_CHAR(:ll_fund);

ll_fund = SQLCA.getitemnumber (1)

IF	iRow>0	Then
	uf_SetColumn ('mg_cd', string(Object.mg_cd [iRow]))
	uf_SetColumn ('unyong_sabun', string(Object.unyong_sabun [iRow]))
End IF
uf_SetColumn ('sintak_gigan', '12')
uf_SetColumn ('type_gb', '1')
uf_SetColumn ('basic_per', '1')
uf_SetColumn ('bm_per', '0')
uf_SetColumn ('success_per', '0')
uf_SetColumn ('susu_rt', '0.0005')
uf_SetColumn ('fst_seolj_ymd', string(idt_workdate))
uf_SetColumn ('re_seolj_year', '1')
uf_SetColumn ('re_seolj_ymd', string(idt_workdate))
uf_SetColumn ('fund_cd', string(ll_fund,'0000'))
uf_SetColumn ('enc_acct_no', 'AAAAAAAAAAA=')
uf_SetColumn ('order_send', 'N')

mle_special_note.ib_update = FALSE
POST SetColumn ('fund_nm')

RETURN 0
end event

event dw_list::constructor;call super::constructor;CHOOSE CASE gaa.corp_gr
	CASE '2203'
		MODIFY ("alias_code_t.text='주문용~r~n얼리어스코드'")
	CASE ELSE
		MODIFY ("alias_code_t.text='계좌번호~r~n(금융기관포함)'")
END CHOOSE
end event

type dw_detail from wt_listdetail`dw_detail within w_ja010b
integer width = 2779
string dataobject = "d_ja010b2"
boolean hscrollbar = false
boolean scaletoright = false
boolean eb_always_1_insert = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_c.object.dddw [1], dw_List.object.fund_cd [iRow])
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('fund_cd', dw_list.object.fund_cd [iRow])
uf_setcolumn ('gyul_gi', string (f_num (dw_list.object.gyul_gi [iRow]) + 1))

setcolumn ('gyul_gi')

RETURN 0
end event

event dw_detail::itemchanged_next;call super::itemchanged_next;LONG	lDays, ll_gi

DATETIME	ldt1, ldt2

IF NAME <> 'bf_gyul_ymd'   Then
   ldt1 = Object.bf_gyul_ymd [row]
   ldt2 = Object.af_gyul_ymd [row]

   SELECT F_DAYS (:ldt1,:ldt2) INTO :lDays FROM DUAL;

   Object.ilsu [row] = SQLCA.GETITEMNUMBER (1)
   RETURN
END IF

ldt1 = Object.bf_gyul_ymd [row]
ldt2 = f_add_months (Object.bf_gyul_ymd [row], 12, null_dt)

Object.af_gyul_ymd [row] = ldt2

SELECT F_DAYS (:ldt1,:ldt2) INTO :lDays FROM DUAL;

lDays = SQLCA.GETITEMNUMBER (1)

Object.ilsu [row] = lDays

IF ROW = 1  Then
   dw_list.object.gyul_gi [iRow]     = Object.gyul_gi [1]
   dw_list.object.bf_gyul_ymd [iRow] = Object.bf_gyul_ymd [1]
   dw_list.object.af_gyul_ymd [iRow] = Object.af_gyul_ymd [1]
END IF
end event

event dw_detail::doubleclicked;call super::doubleclicked;DATETIME	ldt

IF	row=0 THEN RETURN
IF Object.gyul_gi [row] = 1   Then
   ldt = Object.bf_gyul_ymd [row]
   SELECT :ldt + 1 INTO :ldt FROM DUAL;
   dw_list.object.fst_seolj_ymd [iRow] = SQLCA.getitemdatetime (1)
END IF

dw_list.object.gyul_gi [iRow]     = Object.gyul_gi [1]
dw_list.object.bf_gyul_ymd [iRow] = Object.bf_gyul_ymd [1]
dw_list.object.af_gyul_ymd [iRow] = Object.af_gyul_ymd [1]
end event

event dw_detail::resize;call super::resize;mle_special_note.y = y
end event

event dw_detail::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1
IF	dwo.name='wm_seolj_aek' THEN Object.wm_dt [row] = f_sysdate ('')
end event

type st_move from wt_listdetail`st_move within w_ja010b
string bottomdragobject = "dw_detail;st_1;dw_1;mle_special_note"
end type

type st_1 from pf_u_splitbar_vertical within w_ja010b
integer x = 2843
integer y = 1476
integer height = 1288
boolean bringtotop = true
boolean setcondcolor = true
boolean leftmaxsizefixed = true
string leftdragobject = "dw_detail"
string rightdragobject = "dw_1;mle_special_note"
end type

type cb_pj from pf_u_commandbutton within w_ja010b
integer x = 2245
integer y = 16
integer width = 457
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "평잔재계산"
end type

event clicked;STRING	sMsg, la_args[]

IF	f_messagebox ('INFO2', dw_list.object.fund_nm [iRow] + '계좌 평잔 재계산 작업을 하시겠습니까?')=2 THEN RETURN

sMsg = space (200)
la_args [1] = dw_c.object.dddw [1]
la_args [2] = dw_list.object.fund_cd [iRow]
la_args [3] = string(idt_workdate,'yyyy.mm.dd')
SQLCA.singleconnection ()
SQLCA.SP_CALL (parent, 'SR_PYUNGJAN ( ?, ?, ? )', la_args[], sMsg)

f_messagebox ('INFO', '평잔 재계산 작업을 완료 했습니다.')

end event

type mle_special_note from u_mle within w_ja010b
integer x = 2866
integer y = 1476
integer width = 2565
integer height = 376
integer taborder = 80
boolean bringtotop = true
borderstyle borderstyle = stylebox!
boolean scaletoright = true
end type

type dw_1 from u_dw within w_ja010b
integer x = 2866
integer y = 1960
integer width = 2565
integer height = 804
integer taborder = 70
string dataobject = "d_szt0io"
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
boolean ibsetlist4excelclip = true
string setlist4fontpointcolor = "mod_yn=Y=d"
boolean eb_range_delcopy = false
boolean eb_always_1_insert = true
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, TRUE)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (dw_c.object.dddw [1], dw_list.object.fund_cd [iRow])
end event

event ue_insertstart;call super::ue_insertstart;uf_SetColumn ('tr_ymd', string(idt_workdate))
uf_SetColumn ('fund_cd', dw_List.object.fund_cd [iRow])

POST SetColumn ('tr_ymd')

RETURN 0
end event

event ue_protect;call super::ue_protect;IF	Object.tr_ymd [row]>=dw_list.object.re_seolj_ymd [iRow] OR GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified!	Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'wonbon_aek'
      IF gaa.customer_gr='자산운용' AND ROW=1 AND ROWCOUNT ()>1   Then
         Object.io_jo [row] = dec (data) - (Object.wonbon_aek [row + 1] + f_num (Object.in_aek [row]) - f_num (Object.out_aek [row]))
      ELSE
         Object.io_jo [row] = null_dc
      END IF
      Object.mod_dt [row]   = f_sysdate ('')
      Object.mod_user [row] = gaa.login
		Object.mod_yn [row]   = 'Y'
END CHOOSE
end event

