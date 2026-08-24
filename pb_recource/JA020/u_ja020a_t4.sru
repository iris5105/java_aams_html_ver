forward
global type u_ja020a_t4 from utt_listdetail
end type
end forward

global type u_ja020a_t4 from utt_listdetail
string text = "청약"
end type
global u_ja020a_t4 u_ja020a_t4

type variables
STRING	gs_corp_gr, gs_cy_type
DateTime hy_ymd
end variables

forward prototypes
public subroutine wf_setenabled ()
end prototypes

public subroutine wf_setenabled ();iu_wpage.wf_setenabled ()
dw_pagedetail.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
IF	tRow=0	Then
	dw_pagedetail.of_dw2subbtn ({'p_input'}, false)
Else
	IF	string (iu_wpage.idt_workdate,'yyyymmdd')<=string (dw_pagelist.object.nabib_ymd [tRow],'yyyymmdd') And f_notnull (dw_pagelist.object.balh_co [tRow])	Then
		dw_pagedetail.of_dw2subbtn ({'p_input'}, true)
	Else
		dw_pagedetail.of_dw2subbtn ({'p_input'}, false)
	End IF
End IF
dw_pagedetail.of_dw2subbtn ({'p_copy'}, (dw_pagedetail.enabled And dw_pagedetail.eb_copy_false=FALSE And iu_wpage.ib_managedata))
dw_pagedetail.of_dw2subbtn ({'p_delete'}, (dw_pagedetail.enabled And dw_pagedetail.eb_delete_false=FALSE And iu_wpage.ib_managedata))
end subroutine

on u_ja020a_t4.create
call super::create
end on

on u_ja020a_t4.destroy
call super::destroy
end on

type ln_temptop from utt_listdetail`ln_temptop within u_ja020a_t4
end type

type ln_tempstart from utt_listdetail`ln_tempstart within u_ja020a_t4
end type

type ln_templeft from utt_listdetail`ln_templeft within u_ja020a_t4
end type

type ln_cond_start from utt_listdetail`ln_cond_start within u_ja020a_t4
end type

type ln_tempright from utt_listdetail`ln_tempright within u_ja020a_t4
end type

type ln_cond1_yline from utt_listdetail`ln_cond1_yline within u_ja020a_t4
end type

type ln_dw1_yline from utt_listdetail`ln_dw1_yline within u_ja020a_t4
end type

type ln_tempbutton from utt_listdetail`ln_tempbutton within u_ja020a_t4
end type

type dw_pagelist from utt_listdetail`dw_pagelist within u_ja020a_t4
string dataobject = "d_ja020a_t4a"
boolean eb_new_false = true
end type

event dw_pagelist::doubleclicked;call super::doubleclicked;IF dwo.type<>'column' THEN RETURN
IF f_notnull (Object.sj_ymd [row]) And f_notnull (Object.balh_co [row]) Then
   RegistrySet ("HKEY_CURRENT_USER\Software\AAMS\Doubleclicked\RUN", "parameter", 'SJUE200@' + string (Object.sj_ymd [row],'yyyy.mm.dd') + '@' + Object.balh_co [row] + '@' + Object.xx_balh_co [row])
	gnv_rolemenu.of_setopensheet('00941')
End IF
end event

event dw_pagelist::retrieveend;call super::retrieveend;setcolumn ('cy_ymd')
end event

event dw_pagelist::retrieverow;call super::retrieverow;IF f_null (Object.jc_join [row])   Then
   Object.corp_gr [row]     = gs_corp_gr
   Object.jc_join [row]     = Object.jc_jc_join [row]
   Object.jg_tr_co_cd [row] = Object.sjg1jc_jg_tr_co_cd [row]
   IF f_num (Object.cy_danga [row])=0  Then
      IF f_num (Object.sc_danga [row])=0  Then
         Object.cy_danga [row] = Object.tot_g_danga [row]
      Else
         Object.cy_danga [row] = Object.sc_danga [row]
      End IF
   End IF
   Object.cy_type [row]   = gs_cy_type
   Object.nabib_ymd [row] = Object.jc_nabib_ymd [row]
   Object.bigo [row]      = Object.jc_bigo [row]

   SetItemStatus (row, 0, Primary!, New!)
   SetItemStatus (row, 0, Primary!, NotModified!)
End IF
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;IF	string (iu_wpage.idt_workdate,'yyyymmdd')<=string (Object.nabib_ymd [currentrow],'yyyymmdd') And f_notnull (Object.balh_co [currentrow]) And dw_pagedetail.rowcount ()=0	Then
	Object.b_import.visible = true
Else
	Object.b_import.visible = false
End IF
iu_wpage.tab_string [1] = Object.jc_join [currentrow]
RETURN 0
end event

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'jg_tr_co_cd | tr_co_cd', gs_corp_gr, '', 1, "tr_gb='1'")
end event

event dw_pagelist::ue_protect;call super::ue_protect;IF Object.p_visible [row] = 1 Then
   uf_protect (row, ia_protect [1])
Else
   uf_protect (row, ia_protect [2])
End IF
end event

event dw_pagelist::updatestart;call super::updatestart;LONG	ll
FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 0, Primary!)=DataModified! OR GetItemStatus (ll, 0, Primary!)=NewModified!   Then
      IF LEFT (Object.jg_tr_co_cd [ll],1)='('   Then
         f_messageBox ('I000', '매매처를 선택하십시오.')
         SetRow (ll)
         ScrollToRow (ll)
         SetColumn ('jg_tr_co_cd')
         RETURN 1
      End IF
   End IF
NEXT
end event

event dw_pagelist::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1

accepttext ()

LONG	ll, ll_detail

ll_detail = dw_pagedetail.rowcount ()

IF dwo.name='cy_ymd' And Object.sc_jusu [row]>0  Then
   Object.cy_jusu [row] = Object.sc_jusu [row]
   Object.cy_danga [row] = Object.sc_danga [row]
   Object.cy_aek [row] = Object.cy_jusu [row] * Object.cy_danga [row]
   IF f_num (Object.jkm_per [row])>0   Then
      Object.cy_jkm [row] = truncate (Object.cy_aek [row] * Object.jkm_per [row] / 100, 0)
   Else
      Object.cy_jkm [row] = Object.cy_aek [row]
   End IF
   FOR  ll = 1  TO  ll_detail
      dw_pagedetail.object.cy_jusu [ll] = dw_pagedetail.object.sc_jusu [ll]
      dw_pagedetail.object.cy_aek [ll] = dw_pagedetail.object.sc_aek [ll]
      IF f_num (Object.susu_per [row])>0 THEN dw_pagedetail.object.cy_susu [ll] = truncate (dw_pagedetail.object.cy_aek [ll] * Object.susu_per [row] / 100, 0)
      IF f_num (Object.jkm_per [row])>0   Then
         dw_pagedetail.object.cy_jkm [ll] = truncate (dw_pagedetail.object.cy_aek [ll] * Object.jkm_per [row] / 100, 0)
      Else
         dw_pagedetail.object.cy_jkm [ll] = dw_pagedetail.object.cy_aek [ll]
      End IF
   NEXT
End IF

CHOOSE CASE dwo.name
   CASE 'cy_danga','susu_per','jkm_per'
      FOR  ll = 1  TO  ll_detail
         dw_pagedetail.object.cy_aek [ll] = f_num (dw_pagedetail.object.cy_jusu [ll]) * f_num (Object.cy_danga [row])
         IF f_num (Object.susu_per [row])>0 THEN dw_pagedetail.object.cy_susu [ll] = truncate (dw_pagedetail.object.cy_aek [ll] * Object.susu_per [row] / 100, 0)
         IF f_num (Object.jkm_per [row])>0   Then
            dw_pagedetail.object.cy_jkm [ll] = truncate (dw_pagedetail.object.cy_aek [ll] * Object.jkm_per [row] / 100, 0)
         Else
            dw_pagedetail.object.cy_jkm [ll] = dw_pagedetail.object.cy_aek [ll]
         End IF
      NEXT
   CASE 'lock_end'
      FOR  ll = 1  TO  ll_detail
         dw_pagedetail.object.lock_end [ll] = Object.lock_end [row]
      NEXT
   CASE 'jg_tr_co_cd'
      FOR  ll = 1  TO  ll_detail
         dw_pagedetail.object.jg_tr_co_cd [ll] = Object.jg_tr_co_cd [row]
			f_dw_resetstatus (dw_pagedetail, ll, {'jg_tr_co_cd'})
      NEXT
END CHOOSE

object.cy_user [row] = gnv_vari.is_user_id

IF dw_pagelist.object.jc_end_ymd [tRow]<iu_wpage.idt_workdate And ll_detail=0 Then
   dw_pagedetail.EVENT ue_retrieve ()
Else
   Object.cy_jusu [row] = dw_pagedetail.object.sum_jusu [1]
   Object.cy_aek [row] = dw_pagedetail.object.sum_aek [1]
   Object.cy_jkm [row] = dw_pagedetail.object.sum_jkm [1]
End IF
end event

event dw_pagelist::buttonup;call super::buttonup;OLEObject   lXls, lSheet

INT   li_con
LONG	ln, ll_sheet, lm, lm_c [], lc, lRow

BOOLEAN	lb_ok
STRING	ls_path, ls_file, ls_msg, ls_temp
STRING	ls_fund_cd, ls_fund_nm

IF dwo.name='b_import'  Then
   ls_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
   IF GetFileOpenName ("배정내역 엑셀파일 선택", ls_path, ls_file, "배정내역", " 배정내역 자료,*.xls;*.xlsx, All file,*.*", ls_path,18)<>1 THEN RETURN
   SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', f_replace (ls_path, ls_file, ''))

   lXls = CREATE OLEobject

   li_con = lXls.ConnectToNewObject ("excel.application")
   IF li_con<>0 THEN
      CHOOSE CASE li_con
         CASE -1
            ls_msg = "Invalid Call: the argument is the Object property of a control~r~n"
         CASE -2
            ls_msg = "Class name not found~r~n"
         CASE -3
            ls_msg = "Object could not be created~r~n"
         CASE -4
            ls_msg = "ould not connect to object~r~n"
         CASE -9
            ls_msg = "Other error~r~n"
         CASE -15
            ls_msg = "MTS is not loaded on this computer~r~n"
         CASE -16
            ls_msg = "Invalid Call: this function not applicable~r~n"
         CASE Else
            ls_msg = "If any argument's value is NULL, ConnectToNewObject returns NULL.~r~n"
      END CHOOSE
      DESTROY lXls
      MessageBox("ERROR","엑셀 프로그램을 실행할 수 없습니다.~r~n" + ls_msg, StopSign!)
      RETURN -10
   End IF

   dw_pagedetail.enabled = FALSE
   dw_pagedetail.setredraw (FALSE)

   lXls.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기
   lXls.Application.Visible = FALSE
   lXls.windowstate = 2

   ll_sheet = lXls.Application.Workbooks (1).worksheets.count  // Sheet의 갯수
   FOR  ln = 1  TO  ll_sheet
      lSheet = lXls.Application.Workbooks (1).worksheets (ln)
      lSheet.Activate

      IF lSheet.name=Object.jm_nm [tRow]  Then
         // 1-관리번호, 2-확정가격, 3-배정수량, 4-배정금액, 5-청약수수료, 6-납입금액
         lRow = lSheet.UsedRange.Rows.Count
         lm_c = {0,0,0,0,0,0}
         FOR  lm = 1  TO  lRow
            FOR  lc= 1  TO  20
               ls_temp = f_replace (STRING (lSheet.cells (lm, lc).Value), ' ', '')
               CHOOSE CASE LEFT (ls_temp,4)
                  CASE '관리번호'
                     lm_c [1] = lc
                  CASE '확정가격'
                     lm_c [2] = lc
                  CASE '배정수량'
                     lm_c [3] = lc
                  CASE '배정금액'
                     lm_c [4] = lc
                  CASE '청약수수'
                     lm_c [5] = lc
                  CASE '납입금액'
                     lm_c [6] = lc
               END CHOOSE
            NEXT
            IF lm_c [1]=0 OR lm_c [2]=0 THEN CONTINUE

            IF lm_c [2]=0  Then
               f_messagebox ('ERR', '확정가격 항목이 없습니다.')
               RETURN
            End IF
            IF lm_c [3]=0  Then
               f_messagebox ('ERR', '배정수량 항목이 없습니다.')
               RETURN
            End IF
            IF lm_c [4]=0  Then
               f_messagebox ('ERR', '배정금액 항목이 없습니다.')
               RETURN
            End IF
            IF lm_c [5]=0  Then
               f_messagebox ('ERR', '청약수수료 항목이 없습니다.')
               RETURN
            End IF

            // 배정내역 등록

            ls_Fund_cd = TRIM(STRING (lSheet.cells (lm, lm_c [1]).Value))

            SELECT fund_cd
                 , fund_nm
              INTO :ls_fund_cd
                 , :ls_fund_nm
              FROM SZM0IA ia
             WHERE ia.corp_gr = :gaa.corp_gr
               AND ia.fund_cd = :ls_fund_cd;
            IF SQLCA.sqlcode ()<>0 THEN CONTINUE

            ls_fund_cd = SQLCA.getitemstring (1)
            ls_fund_nm = SQLCA.getitemstring (2)

            dw_pagedetail.insertrow (1)
            dw_pagedetail.object.corp_gr [1]      = gaa.corp_gr
            dw_pagedetail.object.jc_join [1]     = dw_pagelist.object.jc_join [tRow]
            dw_pagedetail.object.jg_tr_co_cd [1] = dw_pagelist.object.jg_tr_co_cd [tRow]
            dw_pagedetail.object.fund_cd [1]     = ls_fund_cd
            dw_pagedetail.object.xx_fund_cd [1]  = ls_fund_nm
            dw_pagedetail.object.sc_jusu [1]     = f_num (lSheet.cells (lm, lm_c [3]).Value)
            dw_pagedetail.object.cy_jusu [1]     = f_num (lSheet.cells (lm, lm_c [3]).Value)
            dw_pagedetail.object.cy_aek [1]      = f_num (lSheet.cells (lm, lm_c [4]).Value)
            dw_pagedetail.object.cy_jkm [1]      = f_num (lSheet.cells (lm, lm_c [4]).Value)
            dw_pagedetail.object.cy_susu [1]     = f_num (lSheet.cells (lm, lm_c [5]).Value)
         NEXT
         lb_ok = TRUE
			EXIT
      End IF
   NEXT
	dw_pagelist.object.cy_jusu [tRow] = dw_pagedetail.object.sum_jusu [1]
	dw_pagelist.object.cy_aek [tRow]  = dw_pagedetail.object.sum_aek [1]
	dw_pagelist.object.cy_jkm [tRow]  = dw_pagedetail.object.sum_jkm [1]	
	
   dw_pagedetail.enabled = true
   dw_pagedetail.setredraw (true)

   IF NOT lb_ok THEN f_messagebox ('ERR', '배정 할 종목 시트를 찾을수 없습니다(시트명을 종목명으로 등록)')

   lXls.Application.Quit
   lXls.DisConnectObject ()

   DESTROY lXls
   DESTROY lXls
End IF
end event

type dw_pagedetail from utt_listdetail`dw_pagedetail within u_ja020a_t4
string dataobject = "d_ja020a_t4b"
boolean eb_copy_false = true
end type

event dw_pagedetail::itemchanged_next;call super::itemchanged_next;Object.cy_aek [row] = f_num (Object.cy_jusu [row]) * f_num (dw_pagelist.object.cy_danga [tRow])
IF f_num (dw_pagelist.object.susu_per [tRow])>0 THEN Object.cy_susu [row] = truncate (Object.cy_aek [row] * dw_pagelist.object.susu_per [tRow] / 100, 0)
IF f_num (dw_pagelist.object.jkm_per [tRow])>0  Then
   Object.cy_jkm [row] = truncate (Object.cy_aek [row] * dw_pagelist.object.jkm_per [tRow] / 100, 0)
Else
   Object.cy_jkm [row] = Object.cy_aek [row]
End IF
dw_pagelist.object.cy_jusu [tRow] = Object.sum_jusu [1]
dw_pagelist.object.cy_aek [tRow] = Object.sum_aek [1]
dw_pagelist.object.cy_jkm [tRow] = Object.sum_jkm [1]
end event

event dw_pagedetail::ue_deletestart;call super::ue_deletestart;IF NOT (f_null (Object.f47_ymd [1]) OR Object.f47_ymd [1]=iu_wpage.idt_workdate) Then
   f_messageBox ('ERR', '청약등록된 자료는 삭제 할 수 없습니다.')
   RETURN 1
End IF
RETURN 0
end event

event dw_pagedetail::ue_protect;call super::ue_protect;IF dw_pagelist.object.p_visible [tRow]=1 OR gaa.admin  Then
	uf_protect (row, ia_protect [1])
Else
	uf_protect (row, ia_protect [2])
End IF
end event

event dw_pagedetail::ue_retrieve;call super::ue_retrieve;IF f_null (dw_pagelist.object.sc_ymd [tRow]) Then
   IF f_null (dw_pagelist.object.cy_ymd [tRow]) OR dw_pagelist.object.cy_ymd [tRow]>iu_wpage.idt_workdate   Then
      hy_ymd = iu_wpage.idt_workdate
   Else
      hy_ymd = dw_pagelist.object.cy_ymd [tRow]
   End IF
Else
   IF dw_pagelist.object.sc_ymd [tRow]>iu_wpage.idt_workdate   Then
      hy_ymd = iu_wpage.idt_workdate
   Else
      hy_ymd = dw_pagelist.object.sc_ymd [tRow]
   End IF
End IF
retrieve (gs_corp_gr, dw_pagelist.object.jc_join [tRow], dw_pagelist.object.jg_tr_co_cd [tRow], hy_ymd, iu_wpage.idt_workdate)
end event

event dw_pagedetail::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

FOR  ll = rowcount ()  TO  1  STEP -1
   IF f_num (Object.sc_jusu [ll])=0 And f_num (Object.cy_jusu [ll])=0 THEN deleterow (ll)
NEXT
end event

event dw_pagedetail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('jc_join', dw_pagelist.object.jc_join [tRow])
uf_setcolumn ('jg_tr_co_cd', dw_pagelist.object.jg_tr_co_cd [tRow])

setcolumn ('fund_cd')

RETURN 0
end event

type st_move from utt_listdetail`st_move within u_ja020a_t4
end type

