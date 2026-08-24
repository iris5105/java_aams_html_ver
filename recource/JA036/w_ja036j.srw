forward
global type w_ja036j from wt_list
end type
type rb_1 from pf_u_radiobutton within w_ja036j
end type
type rb_2 from pf_u_radiobutton within w_ja036j
end type
type rb_a from pf_u_radiobutton within w_ja036j
end type
type cb_2 from pf_u_commandbutton within w_ja036j
end type
type cb_4 from pf_u_commandbutton within w_ja036j
end type
type cb_5 from pf_u_commandbutton within w_ja036j
end type
type cb_3 from pf_u_commandbutton within w_ja036j
end type
end forward

global type w_ja036j from wt_list
string is_init_value = "1"
rb_1 rb_1
rb_2 rb_2
rb_a rb_a
cb_2 cb_2
cb_4 cb_4
cb_5 cb_5
cb_3 cb_3
end type
global w_ja036j w_ja036j

type variables
STRING	ls_title, ls_pathname, ls_filename
BOOLEAN	ib_phase52

end variables

on w_ja036j.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_a=create rb_a
this.cb_2=create cb_2
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_a
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_4
this.Control[iCurrent+6]=this.cb_5
this.Control[iCurrent+7]=this.cb_3
end on

on w_ja036j.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_a)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_3)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
CHOOSE CASE ia_value [1]
   CASE '2'
      rb_2.checked = TRUE
   CASE 'A'
      rb_a.checked = TRUE
   CASE ELSE
      rb_1.checked = TRUE
END CHOOSE
end event

event wue_clear;call super::wue_clear;rb_1.enabled = TRUE
rb_2.enabled = TRUE
rb_a.enabled = TRUE
end event

event open;icmdbutton = { cb_2, cb_3, cb_4, cb_5 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja036j
end type

type ln_templeft from wt_list`ln_templeft within w_ja036j
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja036j
end type

type ln_temptop from wt_list`ln_temptop within w_ja036j
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja036j
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja036j
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja036j
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja036j
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja036j
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja036j
end type

type ln_tempright from wt_list`ln_tempright within w_ja036j
end type

type uo_navi from wt_list`uo_navi within w_ja036j
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja036j
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja036j
end type

type st_top_rect from wt_list`st_top_rect within w_ja036j
end type

type p_close from wt_list`p_close within w_ja036j
end type

type p_excel from wt_list`p_excel within w_ja036j
end type

type p_print from wt_list`p_print within w_ja036j
end type

type p_delete from wt_list`p_delete within w_ja036j
end type

type p_update from wt_list`p_update within w_ja036j
end type

type p_input from wt_list`p_input within w_ja036j
end type

type p_retrieve from wt_list`p_retrieve within w_ja036j
end type

type p_clear from wt_list`p_clear within w_ja036j
end type

type p_copy from wt_list`p_copy within w_ja036j
end type

type dw_c from wt_list`dw_c within w_ja036j
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;IF idt_workdate=Object.ymd [1] OR gaa.admin THEN ib_manageData = TRUE ELSE ib_manageData = FALSE

rb_1.enabled = FALSE
rb_2.enabled = FALSE
rb_a.enabled = FALSE
dw_list.uf_dataobject ('d_ja036j_'+ia_value [1], FALSE)

RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_ja036j
end type

type st_count from wt_list`st_count within w_ja036j
end type

type dw_list from wt_list`dw_list within w_ja036j
string dataobject = "d_ja036j_1"
boolean eb_null_line = false
end type

event dw_list::retrieveend;call super::retrieveend;IF ib_manageData=FALSE THEN RETURN

DateTime ldt

LONG	ll, lR, lj

STRING	ls_yj_cd, ls_yj_nm, ls_blbg_tckr, ls_sqlsyntax

aDS_jTier	lds_jtier

ldt = dw_c.object.ymd [1]

ls_sqlsyntax = "   SELECT  DISTINCT t2.jm_cd " &
             + "         , t2.jm_nm " &
             + "         , t2.blbg_tckr " &
             + "   FROM    sym0yz t1 " &
             + "         , sym0ya t2 " &
             + "   WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " &
             + "     AND   t1.ymd      = '" + STRING(ldt,'yyyy.mm.dd') + "' " &
             + "     AND   NVL(t1.tr_bfil_jusu,0)+nvl(t1.tr_up_jusu,0)-nvl(t1.tr_dw_jusu,0) > 0 " &
             + "     AND   t2.corp_gr  = t1.corp_gr " &
             + "     AND   t2.jm_cd    = t1.jm_cd " &
             + "     AND   t2.jasan_gb = '" + ia_value[1] + "' " &
             + "   ORDER BY  t2.jm_cd "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_yj_cd = lds_jtier.getitemString (lj, 1)
   ls_yj_nm = lds_jtier.getitemString (lj, 2)
   ls_blbg_tckr  = lds_jtier.getitemString (lj, 3)

   ll = FIND ("yj_cd='" + ls_yj_cd + "'", 1, rowcount )
   IF ll=0  Then
      ll = insertrow (0)
      Object.corp_gr [ll] = gaa.corp_gr
		Object.p_visible [ll] = 1
      Object.jasan_gb [ll] = ia_value [1]
      Object.ymd [ll] = ldt
      Object.yj_cd [ll] = ls_yj_cd
      Object.xx_yj_cd [ll] = ls_yj_nm
   End IF
   Object.blbg_tckr [ll] = ls_blbg_tckr
NEXT

end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('ymd', string (dw_c.object.ymd [1]))

POST SetColumn ('yj_cd')

RETURN 0
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'jasan_gb', gaa.corp_gr, '', 51, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
Object.load_time [row] = f_sysdate ('')
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'yj_cd'
      CHOOSE CASE ia_value [1]
         CASE '1'
            RETURN 1
         CASE '2'
            RETURN 2
         CASE 'A'
            RETURN 3
      END CHOOSE
END CHOOSE
RETURN 1 // 순번
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

type rb_1 from pf_u_radiobutton within w_ja036j
integer x = 3333
integer y = 208
integer width = 320
integer height = 68
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "주식종가"
boolean setcondcolor = true
end type

event clicked;ia_value [1] = '1'
end event

type rb_2 from pf_u_radiobutton within w_ja036j
integer x = 3662
integer y = 208
integer width = 320
integer height = 68
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "채권단가"
boolean setcondcolor = true
end type

event clicked;ia_value [1] = '2'
end event

type rb_a from pf_u_radiobutton within w_ja036j
integer x = 3991
integer y = 208
integer width = 320
integer height = 68
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "파생종가"
boolean setcondcolor = true
end type

event clicked;ia_value [1] = 'A'
end event

type cb_2 from pf_u_commandbutton within w_ja036j
integer x = 2231
integer y = 16
integer width = 393
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "UPLOAD"
end type

event clicked;OLEObject  obj_excel, lSheet

DateTime ldt_ymd, ldc_date, ldc_px_dt_1d, ldc_load_time, ldc_px_close_dt

STRING	ls_path, ls_fname, ls_jm_cd, ls_blbg_tckr, ls_isin_cd, ls_currency, jasan_txt, ls_ins

DEC	ldc_jonga, ldc_px_last, ldc_px_close_1d, ldc_px_yest_close_exch_unadj

LONG	ll, lRC, ll_ret

ldt_ymd = dw_c.object.ymd [1]

IF ia_value [1]='1'  Then
   jasan_txt = '해외주식종가_'
ElseIF ia_value [1]='2' THEN
   jasan_txt = '해외채권종가_'
ElseIF ia_value [1]='A' THEN
   jasan_txt = '해외파생종가_'
Else
   jasan_txt = '업무담당자문의_'
End IF

IF GetFileOpenName ("해외종가 주식/파생/채권 파일 선택", ls_path, ls_fname, 'XLSX', "All Files (*.*),*.*", gaa.excel, 2)<>1 THEN RETURN
IF f_messageBox ('I002', jasan_txt + gaa.corp_gr + '_' + string (ldt_ymd,'yyyy.mm.dd')+'.xlsx FILE을 LOAD 하시겠습니까?')=2 THEN RETURN

//IF f_messageBox ('I002','해외주식종가_' + gaa.corp_gr + '_' + string (ldt_ymd,'yyyy.mm.dd')+'.xlsx FILE을 LOAD 하시겠습니까?')=2 THEN RETURN

//f_MicroHelp ('해외종가 엑셀자료 업로드 중...')

obj_excel = CREATE OLEObject
ll_ret = obj_excel.ConnectToNewObject ("excel.application")
IF ll_ret<0 Then
   f_messageBox ('XLS1', string (ll_ret))
   RETURN
End IF

obj_excel.Application.Visible = TRUE
obj_excel.windowstate = 3
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE) //엑셀 읽기전용으로 열기

lSheet = obj_excel.Application.ActiveSheet
lRC = lSheet.UsedRange.Rows.Count

ll = 1
st_count.visible = TRUE
DO WHILE TRUE
   ll ++
   IF lRC<ll THEN EXIT
   f_st_count (st_count, ls_path + ' : ', ll, lRC)

   ldc_date = datetime (lSheet.cells (ll,1).Value)

   ldc_load_time = datetime (lSheet.cells (ll, 10).Value)
   ldc_px_close_dt = datetime (lSheet.cells (ll, 11).Value)
   ldc_px_dt_1d = datetime (lSheet.cells (ll, 13).Value)

   ls_jm_cd   = TRIM (string (lSheet.cells (ll,3).Value))
   IF f_null (ls_jm_cd) THEN EXIT
   ls_blbg_tckr    = TRIM (string (lSheet.cells (ll,4).Value))
   ls_isin_cd = TRIM (string (lSheet.cells (ll,5).Value))
   ls_currency = TRIM (string (lSheet.cells (ll,7).Value))

   //ldc_jonga = dec (lSheet.cells (ll,9).Value)
   ldc_px_last = dec (lSheet.cells (ll,12).Value)
   ldc_px_close_1d = dec (lSheet.cells (ll,14).Value)
   ldc_px_yest_close_exch_unadj = dec (lSheet.cells (ll,15).Value)

   //종가
   ldc_jonga = ldc_px_last

   //검증
   IF ldt_ymd<>ldc_date Then
      f_messageBox ('ERR', ls_jm_cd + '종목의 로드일자와 현재일자를 확인하세요.')
      st_count.visible = FALSE
      RETURN
   End IF

   IF ldt_ymd<ldc_px_close_dt Then
      f_messageBox ('ERR', ls_jm_cd + '종목의 최종가격적용일를 확인하세요.')
      st_count.visible = FALSE
      RETURN
   End IF

   IF ldt_ymd<ldc_px_dt_1d Then
      f_messageBox ('ERR', ls_jm_cd + '종목의 전일종가적용일를 확인하세요.')
      st_count.visible = FALSE
      RETURN
   End IF

   IF ldc_jonga<>ldc_px_last  Then
      f_messageBox ('ERR', ls_jm_cd + '종목의 최종가격과 종가를 확인하세요.')
      st_count.visible = FALSE
      RETURN
   End IF

   IF ls_jm_cd='US200406F101' Then
      SELECT  f_yjonga(:gaa.corp_gr, :ls_jm_cd, :ldt_ymd - 1)
        INTO  :ldc_jonga
      FROM    dual;
      ldc_jonga = SQLCA.getitemnumber (1)
   End IF

   SELECT  'N'
     INTO  :ls_ins
   FROM    syt0lp t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.ymd     = :ldt_ymd
     AND   t1.jm_cd   = :ls_jm_cd;
   IF SQLCA.sqlcode ()<>0  Then
      ls_ins = 'Y'
   Else
      ls_ins = 'N'
   End IF

   IF ls_ins='Y'  Then
      INSERT INTO  syt0lp
      VALUES ( :gaa.corp_gr                             /* _1:운용(자문)사 */
             , :ldt_ymd                                   /* _2:금융기준일자 */
             , :ls_jm_cd                                  /* _3:종목코드 */
             , :ldc_jonga                                 /* _4: */
             , 0                                          /* _5: */
             , :ldc_load_time                             /* _6: */
             , :ldc_px_close_dt                           /* _7: */
             , :ldc_px_last                               /* _8: */
             , :ldc_px_dt_1d                              /* _9: */
             , :ldc_px_close_1d                           /* _10: */
             , :ldc_px_yest_close_exch_unadj              /* _11: */
             , :ls_blbg_tckr                                   /* _12: */
             , :ls_isin_cd                                /* _13: */
             , :ls_currency                               /* _14: */
             );
   Else
      UPDATE  syt0lp
         SET  jonga                    = :ldc_jonga
            , danga                    = 0
            , load_time                = :ldc_load_time
            , px_close_dt              = :ldc_px_close_dt
            , px_last                  = :ldc_px_last
            , px_dt_1d                 = :ldc_px_dt_1d
            , px_close_1d              = :ldc_px_close_1d
            , px_yest_close_exch_unadj = :ldc_px_yest_close_exch_unadj
            , blbg_tckr                     = :ls_blbg_tckr
            , isin_cd                  = :ls_isin_cd
            , currency                 = :ls_currency
      WHERE   corp_gr = :gaa.corp_gr
        AND   jm_cd   = :ls_jm_cd
        AND   ymd     = :ldt_ymd;
   End IF
LOOP

f_messageBox ('INFO', '해외종가 주식/채권/파생 LOAD를 완료 했습니다.')

DESTROY lSheet
//obj_excel.Application.QUIT
DESTROY obj_excel

UPDATE  link_gr
   SET  syt0lp = sysdate;

st_count.visible = FALSE
commitJ ()

p_retrieve.POST EVENT clicked ()
end event

type cb_4 from pf_u_commandbutton within w_ja036j
integer x = 3045
integer y = 16
integer width = 457
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "주식(Down)"
end type

event clicked;DateTime ldt, ldt_apy, ldt_apy_1d

STRING	ls_file, ls_sqlsyntax, ls_corp_gr, ls_jm_cd, ls_blbg_tckr, ls_isin_cd, ls_jm_nm,  ls_currancy, ls_jasan_gb

LONG	ll_sheet, ll, lj, lk = 0, lR

DEC	ldc_jun_jonga

aDS_jTier	lds_jtier

ldt = dw_c.object.ymd [1]

OLEObject   obj_excel, lSheet

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.excel  + '해외주식종가_' + gaa.corp_gr + '_' + string (ldt,'yyyy.mm.dd') + '.xlsx'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   End IF
End IF

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.workbooks.open (gnv_vari.basepath + '\해외주식종가.xlsx', 0, FALSE)   // 읽기전용

lSheet = obj_excel.Application.ActiveSheet

ll_sheet = obj_excel.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기

//해외주식 종가수신 대상 종목 생성
ls_sqlsyntax = "   SELECT  corp_gr " &
             + "         , jm_cd " &
             + "         , blbg_tckr " &
             + "         , isin_cd " &
             + "         , jm_nm " &
             + "         , currency " &
             + "         , NVL(F_YJONGA(corp_gr, jm_cd, to_date('" + STRING(ldt,'yyyy.mm.dd') + "') - 1),0)  AS jun_jonga " &
             + "         , jasan_gb " &
             + "   FROM    sym0ya t1 " &
             + "   WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " &
             + "     AND   t1.jasan_gb IN ('1','3') " &
             + "   ORDER BY  jm_cd " 

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

ll = 2

FOR  lj = 1  TO  lR
   ls_corp_gr    = lds_jtier.getitemString (lj, 1)
   ls_jm_cd      = lds_jtier.getitemString (lj, 2)
   ls_blbg_tckr       = lds_jtier.getitemString (lj, 3)
   ls_isin_cd    = lds_jtier.getitemString (lj, 4)
   ls_jm_nm      = lds_jtier.getitemString (lj, 5)
   ls_currancy   = lds_jtier.getitemString (lj, 6)
   ldc_jun_jonga = lds_jtier.getitemnumber (lj, 7)
   ls_jasan_gb   = lds_jtier.getitemString (lj, 8)

   lSheet.cells (ll, 1).value = ldt
   lSheet.cells (ll, 2).value = ls_corp_gr
   lSheet.cells (ll, 3).value = ls_jm_cd
   lSheet.cells (ll, 4).value = ls_blbg_tckr
   lSheet.cells (ll, 5).value = ls_isin_cd
   lSheet.cells (ll, 6).value = ls_jm_nm
   lSheet.cells (ll, 7).value = ls_currancy
   lSheet.cells (ll, 8).value = ldc_jun_jonga
   lSheet.cells (ll,10).value = '=NOW()'

   IF ls_jasan_gb='1' THEN
      ldt_apy = ldt
   Else
      SELECT  :ldt - 1
        INTO  :ldt_apy
      FROM    dual;
		ldt_apy = SQLCA.getitemdatetime (1)
   End IF

   SELECT  :ldt_apy - 1
     INTO  :ldt_apy_1d
   FROM    dual;
	ldt_apy_1d = SQLCA.getitemdatetime (1)

   lSheet.cells (ll,11).value = '=BDP($P' + string (ll) + ', "PX_CLOSE_DT")'
   lSheet.cells (ll,12).value = '=BDP($P' + string (ll) + ', "PX_LAST" )'
   lSheet.cells (ll,13).value = '=BDP($P' + string (ll) + ', "PX_DT_1D" )'
   lSheet.cells (ll,14).value = '=BDH($P' + string(ll) + ', "PX_LAST", $A' + string(ll) + ')'
   lSheet.cells (ll,15).value = '=BDP($P' + string (ll) + ', "PX_YEST_CLOSE_EXCH_UNADJ")'
   lSheet.cells (ll,16).value = ls_blbg_tckr + " Equity"
   lk = lk + 1
   ll = ll + 1
NEXT

f_loadingyield ('stop')
TRY
   obj_excel.activeworkbook.SaveAS (ls_file)
   f_messageBox ('INFO', '해외주식종가수신 종목' + string (lk) +'건 엑셀화일 생성이 완료되었습니다.~r~n~r~n('+ls_file+')')
CATCH (runtimeerror er)
   f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
END TRY

obj_excel.DisConnectObject ()
DESTROY obj_excel
end event

type cb_5 from pf_u_commandbutton within w_ja036j
integer x = 3515
integer y = 16
integer width = 457
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "파생(Down)"
end type

event clicked;DateTime ldt

STRING	ls_file

LONG	ll_sheet, ll, lj, lk = 0

ldt = dw_c.object.ymd [1]

OLEObject   obj_excel, lSheet

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.excel  + '해외파생종가_' + gaa.corp_gr + '_' + string (ldt,'yyyy.mm.dd') + '.xlsx'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   End IF
End IF

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.workbooks.open (gnv_vari.basepath + '\해외파생종가.xlsx', 0, FALSE)   // 읽기전용

lSheet = obj_excel.Application.ActiveSheet

ll_sheet = obj_excel.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기

lj = 1
ll = 2
DO WHILE lj <= dw_List.rowcount ()
   lSheet.cells (ll, 1).value = ldt
   lSheet.cells (ll, 2).value = gaa.corp_gr
   lSheet.cells (ll, 3).value = dw_List.Object.yj_cd [lj]
   lSheet.cells (ll, 4).value = dw_List.Object.blbg_tckr [lj]
   lSheet.cells (ll, 5).value = dw_List.Object.isin_cd [lj]
   lSheet.cells (ll, 6).value = dw_List.Object.xx_yj_cd [lj]
   lSheet.cells (ll, 7).value = dw_List.Object.currency [lj]
   lSheet.cells (ll, 8).value = dw_List.Object.px_close_1d [lj]
   lSheet.cells (ll,10).value = '=NOW()'

   lSheet.cells (ll,11).value = '=BDP($D' + string (ll) + ', "PX_CLOSE_DT")'
   lSheet.cells (ll,12).value = '=BDP($D' + string (ll) + ', "PX_LAST" )'
   lSheet.cells (ll,13).value = '=BDP($D' + string (ll) + ', "PX_DT_1D" )'
   lSheet.cells (ll,14).value = '=BDP($D' + string (ll) + ', "PX_CLOSE_1D")'
   lSheet.cells (ll,15).value = '=BDP($D' + string (ll) + ', "PX_YEST_CLOSE_EXCH_UNADJ")'
   lk ++
   ll ++
   lj ++
LOOP

f_loadingyield ('stop')
TRY
   obj_excel.activeworkbook.SaveAS (ls_file)
   f_messageBox ('INFO', '해외 <<파생>>  종가수신 종목' + string (lk) +'건 엑셀화일 생성이 완료되었습니다.~r~n~r~n('+ls_file+')')
CATCH (runtimeerror er)
   f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
END TRY

obj_excel.DisConnectObject ()
DESTROY obj_excel
end event

type cb_3 from pf_u_commandbutton within w_ja036j
integer x = 2638
integer y = 16
integer width = 393
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "엑셀저장"
end type

event clicked;DateTime ldt, ldt_apy, ldt_apy_1d

STRING	ls_file, ls_sqlsyntax, ls_corp_gr, ls_jm_cd, ls_blbg_tckr, ls_isin_cd, ls_jm_nm,  ls_currancy, ls_jasan_gb

LONG	ll_sheet, ll, lj, lk = 0, lR

DEC	ldc_jun_jonga

aDS_jTier	lds_jtier

ldt = dw_c.object.ymd [1]

OLEObject   obj_excel, lSheet

obj_excel = CREATE oleobject

IF obj_excel.ConnectToNewObject ('Excel.Application')<>0 Then   // 엑셀실행
   f_messageBox ('XLS1', '')
   RETURN
End IF

ls_file = gaa.excel  + '해외파생종가_' + gaa.corp_gr + '_' + string (ldt,'yyyy.mm.dd') + '.xlsx'
IF FileExists (ls_file) Then
   IF NOT FileDelete (ls_file)   Then
      f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
      RETURN
   End IF
End IF

f_loadingyield ('start')

obj_excel.Application.displayalerts = FALSE  // 경고창무시
obj_excel.Application.Visible = TRUE
obj_excel.Application.CutCopyMode = FALSE
obj_excel.windowstate = 3

obj_excel.workbooks.open (gnv_vari.basepath + '\해외파생종가.xlsx', 0, FALSE)   // 읽기전용

lSheet = obj_excel.Application.ActiveSheet

ll_sheet = obj_excel.Application.Workbooks (1).worksheets.count  // Sheet의 갯수 읽기

//해외파생 종가수신 대상 종목 생성
ls_sqlsyntax = "   SELECT  t1.corp_gr " &
             + "         , t1.jm_cd " &
             + "         , t2.blbg_tckr " &
             + "         , t2.isin_cd " &
             + "         , t2.jm_nm " &
             + "         , t2.currency " &
             + "         , NVL(F_YJONGA(t1.corp_gr, t1.jm_cd, to_date ('" + STRING(ldt,'yyyy.mm.dd') + "') - 1),0)  AS jun_jonga " &
             + "         , t2.jasan_gb " &
             + "   FROM    syt0lp t1 " &
             + "         , sym0ya t2 " &
             + "   WHERE   t1.corp_gr  = '" + gaa.corp_gr + "' " &
             + "     AND   t1.YMD      = '" + STRING(ldt,'yyyy.mm.dd') + "' " &
             + "     AND   t2.corp_gr  = t1.corp_gr " &
             + "     AND   t2.JM_CD    = t1.JM_CD " &
             + "     AND   t2.CORP_GR  = t1.CORP_GR " &
             + "     AND   t2.JASAN_GB = 'A' " &
             + "   ORDER BY  jm_cd " 
				 
lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

ll = 2

FOR  lj = 1  TO  lR
   ls_corp_gr    = lds_jtier.getitemString (lj, 1)
   ls_jm_cd      = lds_jtier.getitemString (lj, 2)
   ls_blbg_tckr       = lds_jtier.getitemString (lj, 3)
   ls_isin_cd    = lds_jtier.getitemString (lj, 4)
   ls_jm_nm      = lds_jtier.getitemString (lj, 5)
   ls_currancy   = lds_jtier.getitemString (lj, 6)
   ldc_jun_jonga = lds_jtier.getitemnumber (lj, 7)
   ls_jasan_gb   = lds_jtier.getitemString (lj, 8)

   lSheet.cells (ll, 1).value = ldt
   lSheet.cells (ll, 2).value = ls_corp_gr
   lSheet.cells (ll, 3).value = ls_jm_cd
   lSheet.cells (ll, 4).value = ls_blbg_tckr
   lSheet.cells (ll, 5).value = ls_isin_cd
   lSheet.cells (ll, 6).value = ls_jm_nm
   lSheet.cells (ll, 7).value = ls_currancy
   lSheet.cells (ll, 8).value = ldc_jun_jonga
   lSheet.cells (ll,10).value = '=NOW()'

   IF ls_jasan_gb='1' THEN
      ldt_apy = ldt
   Else
      SELECT  :ldt - 1
        INTO  :ldt_apy
      FROM    dual;
		ldt_apy = SQLCA.getitemdatetime (1)
   End IF

   SELECT  :ldt_apy - 1
     INTO  :ldt_apy_1d
   FROM    dual;
	ldt_apy_1d = SQLCA.getitemdatetime (1)

   lSheet.cells (ll,11).value = '=BDP($D' + string (ll) + ', "PX_CLOSE_DT")'
   lSheet.cells (ll,12).value = '=BDP($D' + string (ll) + ', "PX_LAST" )'
   lSheet.cells (ll,13).value = '=BDP($D' + string (ll) + ', "PX_DT_1D" )'
   lSheet.cells (ll,14).value = '=BDP($D' + string (ll) + ', "PX_CLOSE_1D")'
   lSheet.cells (ll,15).value = '=BDP($D' + string (ll) + ', "PX_YEST_CLOSE_EXCH_UNADJ")'
   lk ++
   ll ++
NEXT

f_loadingyield ('stop')
TRY
   obj_excel.activeworkbook.SaveAS (ls_file)
   f_messageBox ('INFO', '해외 <<파생>>  종가수신 종목' + string (lk) +'건 엑셀화일 생성이 완료되었습니다.~r~n~r~n('+ls_file+')')
CATCH (runtimeerror er)
   f_messageBox ('ERR', '파일(' + ls_file + ')이 열려있습니다.~r~n~r~n엑셀을 종료 후 다시 작업 하십시오.')
END TRY

obj_excel.DisConnectObject ()
DESTROY obj_excel
end event

