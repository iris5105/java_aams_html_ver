forward
global type w_ja035b1 from wt_list
end type
type cb_2 from pf_u_commandbutton within w_ja035b1
end type
type cb_other from pf_u_commandbutton within w_ja035b1
end type
end forward

global type w_ja035b1 from wt_list
integer ii_dddw_width = 750
integer ii_rcd_width = 250
string is_date_nation = "US"
string is_init_value = "J10"
cb_2 cb_2
cb_other cb_other
end type
global w_ja035b1 w_ja035b1

type variables
LONG	il_tr_seq
end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035b1.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_other=create cb_other
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_other
end on

on w_ja035b1.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_other)
end on

event open;icmdbutton = { cb_2, cb_other }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035b1
end type

type ln_templeft from wt_list`ln_templeft within w_ja035b1
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035b1
end type

type ln_temptop from wt_list`ln_temptop within w_ja035b1
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035b1
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035b1
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035b1
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035b1
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035b1
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035b1
end type

type ln_tempright from wt_list`ln_tempright within w_ja035b1
end type

type uo_navi from wt_list`uo_navi within w_ja035b1
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035b1
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035b1
end type

type st_top_rect from wt_list`st_top_rect within w_ja035b1
end type

type p_close from wt_list`p_close within w_ja035b1
end type

type p_excel from wt_list`p_excel within w_ja035b1
end type

type p_print from wt_list`p_print within w_ja035b1
end type

type p_delete from wt_list`p_delete within w_ja035b1
end type

type p_update from wt_list`p_update within w_ja035b1
end type

type p_input from wt_list`p_input within w_ja035b1
end type

type p_retrieve from wt_list`p_retrieve within w_ja035b1
end type

type p_clear from wt_list`p_clear within w_ja035b1
end type

type p_copy from wt_list`p_copy within w_ja035b1
end type

type dw_c from wt_list`dw_c within w_ja035b1
string tag = "대출채권은 경과이자가 계산되지 않습니다."
string title = "영업일자@매매구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035B1'")
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (object.ymd [1]>=idt_workdate OR gaa.aams)
RETURN TRUE
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'ymd'
      IF DATETIME (DATE (MID (data,1,10))) >= idt_workdate  Then
         ib_manageData   = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035B1'")
      ELSE
         ib_manageData   = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035B1' and szx0gc.tr_cd in (select tr_cd from syt0mg where corp_gr=':corp_gr' and tr_ymd='" + MID (data, 1, 10) + "')")
      END IF
END CHOOSE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0MG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT h1
                       WHERE obj_id = 'W_SJA035B1')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035b1
end type

type st_count from wt_list`st_count within w_ja035b1
end type

type dw_list from wt_list`dw_list within w_ja035b1
string dataobject = "d_ja035b1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

Datetime	ldt_ymd

STRING	ls_jm_cd, ls_currency

LONG	ll, ll_f_value

DEC	ldc_aekm, ldc_ija

ldt_ymd = dw_c.object.ymd [1]

CHOOSE CASE dwo.name
   CASE 'fund_cd'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.fund_cd [ll]) THEN Object.fund_cd [ll] = data
      NEXT
   CASE 'trustee'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.trustee [ll]) THEN Object.trustee [ll] = data
      NEXT

      SELECT  currency
        INTO  :ls_currency
      FROM    syx2mm t1
      WHERE   t1.corp_gr = :gaa.corp_gr
        AND   t1.trustee = :data;

		ls_currency = SQLCA.getitemstring (1)

      Object.currency [row] = ls_currency
		
		SELECT F_CURRENCY_RT (:gaa.corp_gr, :ldt_ymd, :ls_currency)
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)

      Object.trans_rt [row] = ll_f_value

      SELECT  jm_cd
        INTO  :ls_jm_cd
      FROM    sym0ya t1
      WHERE   t1.corp_gr   = :gaa.corp_gr
        AND   t1.currency  = :ls_currency
        AND   t1.gyulje_jm = 'Y';
		  
		ls_jm_cd = SQLCA.getitemstring (1)

      IF SQLCA.sqlcode ()=0 THEN Object.gyulje_jm_cd [row] = ls_jm_cd
   CASE 'currency'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.currency [ll]) THEN Object.currency [ll] = data
      NEXT
   CASE 'gyulje_jm_cd'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.gyulje_jm_cd [ll]) THEN Object.gyulje_jm_cd [ll] = data
      NEXT
   CASE 'tr_aek','gyulje_aek'
		// 대출채권/대여금은 경과이자가 없으므로
      IF LEFT (dw_c.object.dddw [1],1)='J' And f_nvl (Object.sj_gb [row],'?')<>'Z'	Then
         ldt_ymd = dw_c.object.ymd [1]
         IF f_notnull (Object.gyulje_ymd [1]) THEN ldt_ymd = Object.gyulje_ymd [row]
         ls_jm_cd = Object.yj_cd [row]
         ldc_aekm = Object.tr_jusu [row]

         SELECT  f_ijay(:gaa.corp_gr, :ldt_ymd, :ls_jm_cd, :ldc_aekm)
           INTO  :ldc_ija
         FROM    dual;

			ldc_ija = SQLCA.getitemnumber (1)

         Object.pass_ija [row] = ldc_ija
      End IF
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'trustee', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'currency', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;STRING	ls_cur

CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      RETURN 1
   CASE 'yj_cd'
      IF f_null (Object.currency [row])   Then
         ls_cur = Object.trustee [row]
      
         SELECT bank_cd
           INTO :ls_cur
           FROM SZX2MM t1
          WHERE t1.CORP_GR  = :gaa.CORP_GR
            AND t1.tr_co_cd = :ls_cur ;
         IF SQLCA.sqlcode ()=0 THEN ls_cur = SQLCA.GETITEMSTRING (1)
      ELSE
         ls_cur = Object.currency [row]
      END IF
      rs_Where = "currency='" + ls_cur + "'"
END CHOOSE
RETURN 2
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
il_tr_seq ++
uf_setColumn ('tr_seq', string (il_tr_seq))
uf_setColumn ('bs_type', '0')
uf_setColumn ('gyulje_ymd', string (dw_c.object.ymd [1]))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;f_setprotect (THIS, (POS ('J10,K10',dw_c.object.dddw [1])<>0), { 'gyulje_ymd' })
f_setprotect (THIS, (POS ('JF',LEFT (dw_c.object.dddw [1],1))=0 OR Object.sj_gb [row]='Z'), { 'pass_ija' })
IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

event dw_list::doubleclicked;call super::doubleclicked;IF	row=0 THEN RETURN
IF	POS ('JF',LEFT (dw_c.object.dddw [1],1))=0 OR Object.sj_gb [row]='Z' THEN RETURN	// 대출채권/대여금은 경과이자가 없으므로 pass 20211216 yjs

STRING	ls_jm_cd

DEC	ldc_aekm, ldc_ija

DateTime ldt

IF dwo.name='pass_ija'	Then
   ls_jm_cd = Object.yj_cd [row]
   ldc_aekm = Object.tr_jusu [row]
   ldt = Object.gyulje_ymd [row]

   SELECT  f_ijay(:gaa.corp_gr, :ldt, :ls_jm_cd, :ldc_aekm)
     INTO  :ldc_ija
   FROM    dual;

	ldc_ija = SQLCA.getitemnumber (1)

   Object.pass_ija [row] = ldc_ija
   Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row]) + ldc_ija
   Object.won_pass_ija [row] = truncate (ldc_ija * f_num (Object.trans_rt [row]),0)
   Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * f_num (Object.trans_rt [row]),0)
End IF
end event

event dw_list::itemchanged_next;call super::itemchanged_next;IF POS ('tr_jusu,tr_danga',name)>0 THEN Object.tr_aek [row] = truncate (f_num (Object.tr_jusu [row]) * f_num (Object.tr_danga [row]) / 100,2)
IF POS ('tr_jusu,tr_danga,tr_aek,tr_tax,tr_cost', name)>0   Then
   IF mid(dw_c.object.dddw [1],1,1)='K' or dw_c.object.dddw [1]='E42'   Then
      Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) - (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row])) + f_num (Object.pass_ija [row])
   Else
      Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + (f_num (Object.tr_tax [row]) + f_num (Object.tr_cost [row])) + f_num (Object.pass_ija [row])
   End IF
End IF
Object.won_pass_ija [row] = truncate (f_num (Object.pass_ija [row]) * f_num (Object.trans_rt [row]),0)
Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * f_num (Object.trans_rt [row]),0)

IF name='today_ija'  Then
   // 당일이자 보정은 외화예금에서 직접 보정 하므로
   IF Object.gyulje_ymd [row]>idt_workdate   Then
      Object.gyulje_aek [row] = f_num (Object.tr_aek [row]) + f_num (Object.tr_tax [row]) + Object.today_ija [row]
      Object.won_today_ija [row] = truncate (Object.today_ija [row] * f_num (Object.trans_rt [row]),0)
      Object.won_gyulje_aek [row] = truncate (Object.gyulje_aek [row] * f_num (Object.trans_rt [row]),0)
   End IF
End IF
end event

event dw_list::retrieveend;call super::retrieveend;LONG	r

FOR  r = 1  TO  rowcount
	il_tr_seq = MAX (il_tr_seq, Object.tr_seq [r])
NEXT

end event

type cb_2 from pf_u_commandbutton within w_ja035b1
boolean visible = false
integer x = 2231
integer y = 16
integer width = 603
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "엑셀LOAD(킹슬리)"
end type

event clicked;OLEOBJECT   obj_excel, lSheet

DATETIME	ldt_ymd, ls_tr_ymd, ls_gyulje_ymd

STRING	ls_path, ls_fname, ls_gj_jm_cd, ls_jm_cd, ls_jm_nm, ls_isin_cd, ls_tr_cd, ls_fund_cd
STRING	w_fund_cd, fund_nm, ls_tr_co_cd, ls_tr_co_nm, ls_trustee, ls_currency, ls_upd_user
STRING	tr_item

DEC	ls_tr_seq, ls_tr_jusu, ls_tr_danga, ls_tr_tax, ls_tr_cost, ls_tr_aek, ls_gyulje_aek
DEC	comp_gyulje_aek, diff_gyulje_aek, ls_won_gyulje_aek, ls_trans_rt, ls_tax_per, ls_pss_ija
DEC	ls_won_pass_ija

LONG	ll, lRC, ll_ret, row_cnt, item_cnt, ll_f_value

INTEGER	net

ldt_ymd = dw_c.object.ymd [1]

IF GetFileOpenName ("해외채권거래내역(킹슬리) 엑셀자료 선택", ls_path, ls_fname, 'XLSX', "All Files (*.*),*.*", gaa.excel, 2)<>1 THEN RETURN
Net = MESSAGEBOX ('엑셀로드파일 200라인초과 확인!', '엑셀로드파일이 200라인초과시 분리후 재LOAD하는경우 취소클릭!.~r~n' + ls_fname + ' 엑셀자료를 LOAD처리하는 경우 획인클릭!', Exclamation!, OKCancel!, 2)
IF Net <> 1 Then
      RETURN
END IF

f_MicroHelp ('해외채권거래내역 엑셀자료 업로드 중...')

obj_excel = CREATE OLEOBJECT
ll_ret    = obj_excel.ConnectToNewObject ("excel.application")
IF ll_ret < 0  Then
   F_MESSAGEBOX ('XLS1', STRING (ll_ret))
   RETURN
END IF

obj_excel.Application.VISIBLE = TRUE
obj_excel.windowstate         = 3
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE)// 엑셀 읽기전용으로 열기

lSheet = obj_excel.Application.ActiveSheet
// lRC = lSheet.UsedRange.Rows.Count

item_cnt = 0
lRC      = 200

// 기존 입역한 외화채권 거래내역이 있는 경우 이어서 LOAD처리 여부
SELECT COUNT(*)
  INTO :row_cnt
  FROM SYT0MG t1
 WHERE jm_cd   IN (SELECT jm_cd
                     FROM SYM0YA t1
                    WHERE t1.CORP_GR = :gaa.CORP_GR
                      AND jasan_gb   = '2')
   AND CORP_GR = :gaa.CORP_GR
   AND tr_ymd  = :ldt_ymd
   AND tr_cd   IN ('E42','F23','J10','J14','K10','K11') ;

row_cnt = SQLCA.GETITEMNUMBER (1)

IF SQLCA.sqlcode () <> 0   Then
      row_cnt = 0
END IF
IF row_cnt > 0 Then
      Net = MESSAGEBOX ('기존에 입력한 해외채권거래 확인!', '기존에 입력한 해외채권거래 ' + STRING(row_cnt) + '건이 있습니다. ~r~n기존입력자료를 삭제하시는 경우 취소를 클릭하시고 삭제후 재로드하시고 ~r~n 삭제없이 이어서 다른엑셀파일을 LOAD고자 하시는 경우 확인클릭 하시기 바랍니다.', Exclamation!, OKCancel!, 2)
   IF Net <> 1 Then
         RETURN
   END IF
END IF

ll               = 1
st_count.VISIBLE = true
DO WHILE TRUE
   ll ++
   IF lRC<ll THEN EXIT

   f_st_count (st_count, ls_path + ' : ', ll, lRC)

   tr_item = TRIM (STRING (lSheet.cells (ll, 2).VALUE))
   //다음 row처리
   IF tr_item <> ''  Then
      IF tr_item = '펀드;' Then
         fund_nm   = TRIM (STRING (lSheet.cells (ll, 3).VALUE))
         w_fund_cd = Right (fund_nm, 9)
         IF Mid(w_fund_cd, 1, 1) = "(" Then
            w_fund_cd = Mid (w_fund_cd, 2, 7)
         END IF
      //  펀드코드 오류 점검
//      SELECT fund_cd
//        INTO :ls_fund_cd
//        FROM SZM0FD_EXCODE t1
//       WHERE t1.CORP_GR = :gaa.CORP_GR
//         AND (samu_fund_cd = :w_fund_cd OR fund_cd = :w_fund_cd) ;

      ls_fund_cd = SQLCA.GETITEMSTRING (1)

      IF SQLCA.sqlcode () <> 0   Then
         F_MESSAGEBOX ('SZM0FD_EXCODE select ERR', '사무관리코드/펀드코드를 확인바랍니다! 펀드코드 : ' + w_fund_cd + ' SQL오류:' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText ())
         st_count.VISIBLE = false
         RETURN
      END IF
      row_cnt = 0
      END IF

   tr_item = TRIM (STRING (lSheet.cells (ll, 2).VALUE))
   IF tr_item = '구분'  Then
      tr_item = TRIM (STRING (lSheet.cells (ll, 3).VALUE))
      IF tr_item <> '종목' Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 종목코드 확인 값:' + tr_item + '행:' + STRING(ll) + '열:3')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 5).VALUE))
      IF tr_item <> '매매처명'   Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 매매처명 확인 값:' + tr_item + '행:' + STRING(ll) + '열:5')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 7).VALUE))
      IF tr_item <> '액면금액'   Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 액면금액 확인 값:' + tr_item + '행:' + STRING(ll) + '열:7')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 8).VALUE))
      IF tr_item <> '매매단가'   Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 매매단가 확인  값:' + tr_item + '행:' + STRING(ll) + '열:8')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 9).VALUE))
      IF tr_item <> '수수료'  Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 수수료 확인  값:' + tr_item + '행:' + STRING(ll) + '열:9')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 10).VALUE))
      IF tr_item <> '경과이자'   Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 경과이자 확인  값:' + tr_item + '행:' + STRING(ll) + '열:10')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 11).VALUE))
      IF tr_item <> '외화결제금액'  Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 외화결제금액 확인  값:' + tr_item + '행:' + STRING(ll) + '열:11')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 12).VALUE))
      IF tr_item <> '통화' Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 통화 확인  값:' + tr_item + '행:' + STRING(ll) + '열:12')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 13).VALUE))
      IF tr_item <> '거래일'  Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 거래일 확인  값:' + tr_item + '행:' + STRING(ll) + '열:13')
         st_count.VISIBLE = false
         RETURN
      END IF
      tr_item = TRIM (STRING (lSheet.cells (ll, 14).VALUE))
      IF tr_item <> '결제일'  Then
         MESSAGEBOX ('킹슬리해외채권거래 약식 오류!', '킹슬리해외채권엑셀거래내역 양식항목 결제일 확인  값:' + tr_item + '행:' + STRING(ll) + '열:14')
         st_count.VISIBLE = false
         RETURN
      END IF
   END IF

   tr_item       = TRIM (STRING (lSheet.cells (ll, 2).VALUE))
   ls_tr_ymd     = DATETIME (lSheet.cells (ll,13).VALUE)
   ls_gyulje_ymd = DATETIME (lSheet.cells (ll,14).VALUE)

   //매매내역이 있는 row처리 시작
   IF tr_item = '외화채권매도' OR tr_item = '외화채권출고' OR tr_item = '외화채권조기상환' OR tr_item = '외화채권매수' OR tr_item = '외화채권매입' OR tr_item = '외화채권입고' OR tr_item = '외화채권펀입'  Then
      row_cnt ++

      IF tr_item = '외화채권매도' OR tr_item = '외화채권출고' OR tr_item = '외화채권조기상환'   Then
         IF ls_tr_ymd = ls_gyulje_ymd  Then
            IF tr_item = '외화채권매도' OR tr_item = '외화채권출고'  Then
               ls_tr_cd = 'K10'  // 당일매도
            ELSE
               ls_tr_cd = 'E42'  // 외화채권조기상환
            END IF
         ELSE
                  ls_tr_cd = 'K11'  // 익일매도
         END IF
      END IF

      IF tr_item = '외화채권매수' OR tr_item = '외화채권매입' OR tr_item = '외화채권입고' OR tr_item = '외화채권펀입'   Then
         IF ls_tr_ymd = ls_gyulje_ymd  Then
            IF tr_item = '외화채권매수' OR tr_item = '외화채권매입'  Then
               ls_tr_cd = 'J10'  // 당일매도
            ELSE
               ls_tr_cd = 'F23'  // 외화채권입고
            END IF
         ELSE
                  ls_tr_cd = 'J14'  // 익일매도
         END IF
      END IF

      ls_jm_cd    = TRIM (STRING (lSheet.cells (ll, 3).VALUE))
      ls_isin_cd  = ls_jm_cd
      ls_currency = TRIM (STRING (lSheet.cells (ll, 12).VALUE))

      //   결제종목 구함
      SELECT jm_cd
           , isin_cd
           , jm_nm
        INTO :ls_jm_cd
           , :ls_isin_cd
           , :ls_jm_nm
        FROM SYM0YA t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND currency   = :ls_currency
         AND jasan_gb   = '2'
         AND jm_cd      = :ls_jm_cd ;

      ls_jm_cd   = SQLCA.GETITEMSTRING (1)
      ls_isin_cd = SQLCA.GETITEMSTRING (2)
      ls_jm_nm   = SQLCA.GETITEMSTRING (3)

      IF SQLCA.sqlcode () <> 0   Then

         st_count.VISIBLE = false
         RETURN
      END IF
      IF ls_jm_cd = '' OR ls_jm_nm = ''   Then
         MESSAGEBOX ('SEDOL종목코드/명 ERR확인', ls_jm_cd + ls_jm_nm + '종목코드/명이 없습니다.')
         EXIT
      END IF
      IF ls_isin_cd = ''   Then
         MESSAGEBOX ('ISIN코드확인', ls_isin_cd + '종목의 ISIN코드가 없습니다.')
         EXIT
      END IF
      ls_tr_co_nm = TRIM (STRING (lSheet.cells (ll, 5).VALUE))

      //   매매처코드 오류 점검
      SELECT MIN(tr_co_cd)
        INTO :ls_tr_co_cd
        FROM SZX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND tr_co_nm   LIKE :ls_tr_co_nm ;

      ls_tr_co_cd = SQLCA.GETITEMSTRING (1)

      IF SQLCA.sqlcode () <> 0   Then
         F_MESSAGEBOX ('szx2mm select ERR', '매매처명(#8006)를 확인바랍니다! 매매처명:' + ls_tr_co_nm + ' SQL오류내역: ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText ())
         st_count.VISIBLE = false
         RETURN
      END IF
      //   환율
       SELECT F_CURRENCY_RT(:gaa.CORP_GR,:ldt_ymd,:ls_currency) INTO :ll_f_value FROM DUAL;
      ll_f_value = SQLCA.GETITEMNUMBER (1)

      ls_trans_rt = ll_f_value

      //   해외보관처 TRUSEE
      SELECT TRUSTEE
        INTO :ls_trustee
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND currency   = :ls_currency ;

      ls_trustee = SQLCA.GETITEMSTRING (1)

      IF SQLCA.sqlcode () <> 0   Then
         F_MESSAGEBOX ('syx2mm select ERR', '해외보관처(syx2mm #9210화면)을 확인바랍니다! 종목 : ' + ls_jm_cd + ' 환률 : ' + ls_currency + ' SQL오류내역: ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText ())
         st_count.VISIBLE = false
         RETURN
      END IF

      ls_tr_jusu    = dec (lSheet.cells (ll, 7).VALUE)
      ls_tr_danga   = dec (lSheet.cells (ll, 8).VALUE)
      ls_tr_cost    = dec (lSheet.cells (ll, 9).VALUE)
      ls_pss_ija    = dec (lSheet.cells (ll, 10).VALUE)
      ls_gyulje_aek = dec (lSheet.cells (ll, 11).VALUE)
      ls_tr_tax     = 0
      ls_tax_per    = 0

      ls_tr_aek = truncate (f_num (ls_tr_jusu) * f_num (ls_tr_danga) / 100,2)
      IF mid(ls_tr_cd,1,1) = 'K' OR ls_tr_cd = 'E42'  Then
         comp_gyulje_aek = ROUND (ls_tr_aek - (ls_tr_cost + ls_tr_tax) + ls_pss_ija,2)   // 매도거래
      ELSE
         comp_gyulje_aek = ROUND (ls_tr_aek + (ls_tr_cost + ls_tr_tax) + ls_pss_ija,2)   // 매수거래
      END IF

      diff_gyulje_aek = ROUND (ls_gyulje_aek - comp_gyulje_aek, 2)

      ls_won_pass_ija   = truncate (ls_pss_ija * ls_trans_rt,0)
      ls_won_gyulje_aek = truncate (ls_gyulje_aek * ls_trans_rt,0)

      //  검증
      IF ls_tr_aek <= 0 Then
         F_MESSAGEBOX ('ERR', ls_jm_cd + '종목의 액면과 단가를 확인하세요.')
         st_count.VISIBLE = false
         RETURN
      END IF
      IF ls_gyulje_aek <= 0   Then
         F_MESSAGEBOX ('ERR', ls_jm_cd + '종목의 외화결제금액을 확인하세요.')
         st_count.VISIBLE = false
         RETURN
      END IF
      IF diff_gyulje_aek <> 0 Then
         F_MESSAGEBOX ('ERR', '펀드: ' + ls_fund_cd + ' 거래코드: ' + ls_tr_cd + '종목 : ' + ls_jm_cd + ' 입력 외화결제금액이 계산금액과 차이가 있습니다!. 차이금액 : ' + STRING(diff_gyulje_aek) + ' 입력결제금액:' + STRING(ls_gyulje_aek) + '계산경제금액: ' + STRING(comp_gyulje_aek))
         st_count.VISIBLE = false
         RETURN
      END IF
      IF ls_tr_ymd > ls_gyulje_ymd  Then
         F_MESSAGEBOX ('ERR', ls_jm_cd + '종목의 거래일과 결제일를 확인하세요.')
         st_count.VISIBLE = false
         RETURN
      END IF
      IF ls_tr_ymd <> ldt_ymd Then
         F_MESSAGEBOX ('ERR', ls_jm_cd + '종목의 거래일과 영업일이 상이합니다 확인하세요.' + STRING(ls_tr_ymd) + '/' + STRING(ldt_ymd))
         st_count.VISIBLE = false
         RETURN
      END IF

      ls_upd_user = 'syue020'
      ls_tr_seq   = row_cnt

      //  결제종목 구함
      SELECT jm_cd
        INTO :ls_gj_jm_cd
        FROM SYM0YA t1
       WHERE t1.CORP_GR     = :gaa.CORP_GR
         AND currency       = :ls_currency
         AND gyulje_jm      = 'Y'
         AND jasan_gb       = '5'
         AND :ls_gyulje_ymd Between balh_ymd AND sanghw_ymd ;

      ls_gj_jm_cd = SQLCA.GETITEMSTRING (1)

      IF SQLCA.sqlcode () <> 0   Then

         RETURN
      END IF
      // //
      // Net = MessageBox('거래LOAD차리중입니다.', '거래처리중.....계속진행하시겠습니까? .~r~n ~r~n 종목 : ' + ls_jm_cd + '거래일: ' + string(ls_tr_ymd) + '거래코드:' + ls_tr_cd + '펀드:' + ls_fund_cd + '매매처:' + ls_tr_co_cd + '보관처:' + ls_trustee + '환율:' + ls_currency + '순번:' + string(ls_tr_seq) + ' 액면:' + string (ls_tr_jusu), Exclamation!, OKCancel!, 2)
      //    IF Net <> 1 THEN
      //        RETURN
      //    End IF

      item_cnt ++

      //  거래내역 생성
      INSERT INTO SYT0MG
          ( CORP_GR         /* _1- */
          , TR_YMD          /* _2- */
          , TR_CD           /* _3- */
          , FUND_CD         /* _4- */
          , TR_CO_CD        /* _5- */
          , TRUSTEE         /* _6- */
          , JM_CD           /* _7- */
          , CURRENCY        /* _8- */
          , TR_SEQ          /* _9- */
          , TR_JUSU         /* _10- */
          , TR_DANGA        /* _11- */
          , TR_TAX          /* _12- */
          , TR_COST         /* _13- */
          , TR_AEK          /* _14- */
          , GYULJE_YMD      /* _15- */
          , GYULJE_AEK      /* _16- */
          , WON_GYULJE_AEK  /* _17- */
          , GYULJE_JM_CD    /* _18- */
          , COUNT_COST      /* _19- */
          , TRANS_RT        /* _20- */
          , PASS_GB         /* _21- */
          , PASS_IJA        /* _22- */
          , WON_PASS_IJA    /* _23- */
          , UPD_USER        /* _24- */
          )
      VALUES ( :gaa.CORP_GR                        /* _1- */
             , :ls_tr_ymd                          /* _2- */
             , :ls_tr_cd                           /* _3- */
             , :ls_fund_cd                         /* _4- */
             , :ls_tr_co_cd                        /* _5- */
             , :ls_trustee                         /* _6- */
             , :ls_jm_cd                           /* _7- */
             , :ls_currency                        /* _8- */
             , :ls_tr_seq                          /* _9- */
             , NVL(:ls_tr_jusu,0)                  /* _10- */
             , ROUND(NVL(:ls_tr_danga,0),2)        /* _11- */
             , ROUND(NVL(:ls_tr_tax,0),2)          /* _12- */
             , ROUND(NVL(:ls_tr_cost,0),2)         /* _13- */
             , ROUND(NVL(:ls_tr_aek,0),2)          /* _14- */
             , :ls_gyulje_ymd                      /* _15- */
             , ROUND(NVL(:ls_gyulje_aek,0),2)      /* _16- */
             , ROUND(NVL(:ls_won_gyulje_aek,0),2)  /* _17- */
             , :ls_gj_jm_cd                        /* _18- */
             , 0                                   /* _19- */
             , ROUND(NVL(:ls_trans_rt,0),2)        /* _20- */
             , 'N'                                 /* _21- */
             , ROUND(NVL(:ls_pss_ija,0),2)         /* _22- */
             , ROUND(NVL(:ls_won_pass_ija,0),2)    /* _23- */
             , :ls_upd_user                        /* _24- */
             ) ;
         IF SQLCA.sqlcode () <> 0   Then

            st_count.VISIBLE = false
            RETURN
         END IF
      //  매매내역이 있는 row처리 종료
   END IF
   //다음row처리 종료
   END IF
LOOP
st_count.VISIBLE = false

F_MESSAGEBOX ('엑셀로드 처리 완료!', '해외채권거래내역 엑셀 LOAD ' + STRING(item_cnt) + '건 차리완료했습니다! 신규등록종목의 추가정보 및 LOAD내역(합계등)을 확인히시기 바랍니다!')

DESTROY lSheet
// obj_excel.Application.QUIT
DESTROY obj_excel

commitJ ()
end event

type cb_other from pf_u_commandbutton within w_ja035b1
integer x = 2848
integer y = 16
integer width = 453
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "환전반올림"
end type

event clicked;LONG	ll

FOR  ll = 1  TO  dw_List.rowcount ()
   dw_List.object.won_gyulje_aek [ll] = truncate (dw_List.object.gyulje_aek [ll] * dw_List.object.trans_rt [ll],0)
   dw_List.object.won_pass_ija [ll] = dw_List.object.won_gyulje_aek [ll] - truncate ((dw_List.object.gyulje_aek [ll] - dw_list.object.pass_ija [ll]) * dw_List.object.trans_rt [ll],0)
NEXT
end event

