forward
global type w_ja035b2 from wt_list
end type
type cb_2 from pf_u_commandbutton within w_ja035b2
end type
type cb_3 from pf_u_commandbutton within w_ja035b2
end type
end forward

global type w_ja035b2 from wt_list
integer ii_dddw_width = 700
integer ii_rcd_width = 250
string is_date_nation = "US"
cb_2 cb_2
cb_3 cb_3
end type
global w_ja035b2 w_ja035b2

type variables
LONG	il_tr_seq
end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;cb_2.of_setvisible(FALSE)
cb_3.of_setvisible(FALSE)
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_ja035b2.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_3
end on

on w_ja035b2.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_3)
end on

event wue_clear;call super::wue_clear;cb_2.of_setvisible(TRUE)

cb_3.of_setvisible(TRUE)
end event

event open;icmdbutton = { cb_2, cb_3 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja035b2
end type

type ln_templeft from wt_list`ln_templeft within w_ja035b2
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035b2
end type

type ln_temptop from wt_list`ln_temptop within w_ja035b2
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035b2
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035b2
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035b2
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035b2
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035b2
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035b2
end type

type ln_tempright from wt_list`ln_tempright within w_ja035b2
end type

type uo_navi from wt_list`uo_navi within w_ja035b2
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035b2
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035b2
end type

type st_top_rect from wt_list`st_top_rect within w_ja035b2
end type

type p_close from wt_list`p_close within w_ja035b2
end type

type p_excel from wt_list`p_excel within w_ja035b2
end type

type p_print from wt_list`p_print within w_ja035b2
end type

type p_delete from wt_list`p_delete within w_ja035b2
end type

type p_update from wt_list`p_update within w_ja035b2
end type

type p_input from wt_list`p_input within w_ja035b2
end type

type p_retrieve from wt_list`p_retrieve within w_ja035b2
end type

type p_clear from wt_list`p_clear within w_ja035b2
end type

type p_copy from wt_list`p_copy within w_ja035b2
end type

type dw_c from wt_list`dw_c within w_ja035b2
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'ymd'
      IF DATETIME (DATE (mid (data,1,10))) >= idt_workdate OR gaa.aams Then
         ib_managedata = TRUE
      ELSE
         ib_managedata = FALSE
      END IF
      cb_2.of_setvisible (ib_managedata)
END CHOOSE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT1MG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja035b2
end type

type st_count from wt_list`st_count within w_ja035b2
end type

type dw_list from wt_list`dw_list within w_ja035b2
string dataobject = "d_ja035b2"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_cd', gaa.corp_gr, '', 1, "tr_cd in (select tr_cd from szx1pt where obj_id='W_JA035B2')")
//f_dddwctl (THIS, 'trustee', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'currency', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;STRING	ls_tr_cd, ls_sj_gb

CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      RETURN 1
   CASE 'yj_cd'
      ls_tr_cd = Object.tr_cd [getrow ()]

      SELECT sebu_cd_efnm
        INTO :ls_sj_gb
        FROM SZX0GR t1
       WHERE t1.gr_cd   = 'B4'
         AND t1.sebu_cd = :ls_tr_cd ;
		IF	SQLCA.sqlcode ()=0 THEN ls_sj_gb = SQLCA.GETITEMSTRING (1)

      rs_where = "sj_gb='" + ls_sj_gb + "'"
END CHOOSE
RETURN 3
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt_ymd

STRING	ls_jm_cd, ls_currency

LONG	ll, ll_f_value

ldt_ymd = dw_c.object.ymd [1]

CHOOSE CASE dwo.name
   CASE 'fund_cd'
      FOR  ll = row + 1  TO  rowcount ()
         IF f_null (Object.fund_cd [ll]) THEN Object.fund_cd [ll] = data
      NEXT

//   CASE 'trustee'
//      FOR  ll = row + 1  TO  rowcount ()
//         IF f_null (Object.trustee [ll]) THEN Object.trustee [ll] = data
//      NEXT
//
//      SELECT  currency
//        INTO  :ls_currency
//      FROM    syx2mm t1
//      WHERE   t1.corp_gr = :gaa.corp_gr
//        AND   t1.trustee = :data;
//
//		ls_currency = SQLCA.getitemstring (1)
//
//		SELECT F_CURRENCY_RT( :gaa.corp_gr, :ldt_ymd, :ls_currency )
//		  INTO :ll_f_value
//		FROM   DUAL;
//		ll_f_value = SQLCA.getitemnumber (1)
//
//      Object.currency [row] = ls_currency
//      Object.trans_rt [row] = ll_f_value
//
//      SELECT  jm_cd
//        INTO  :ls_jm_cd
//      FROM    sym0ya t1
//      WHERE   t1.corp_gr   = :gaa.corp_gr
//        AND   t1.currency  = :ls_currency
//        AND   t1.gyulje_jm = 'Y';
//		  
//		ls_jm_cd = SQLCA.getitemstring (1)
//
//      IF SQLCA.sqlcode ()=0 THEN Object.gyulje_jm_cd [row] = ls_jm_cd

   CASE 'tr_jusu'
      Object.tr_aek [row] = truncate (dec (data) * Object.tr_danga [row] * Object.unit_aek [row],2)
   CASE 'tr_danga'
      Object.tr_aek [row] = truncate (dec (data) * Object.tr_jusu [row] * Object.unit_aek [row],2)
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
il_tr_seq ++
uf_setColumn ('tr_seq', string (il_tr_seq))
uf_setColumn ('gyulje_ymd', string (dw_c.object.ymd [1]))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

event dw_list::retrieveend;call super::retrieveend;LONG	r

FOR  r = 1  TO  rowcount
	il_tr_seq = MAX (il_tr_seq, Object.tr_seq [r])
NEXT

end event

type cb_2 from pf_u_commandbutton within w_ja035b2
boolean visible = false
integer x = 2231
integer y = 16
integer width = 654
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "엑셀LOAD(삼성선물)"
end type

event clicked;oleobject	obj_excel, lSheet

Datetime	ldt_ymd, ls_balh_ymd, ldt_lys_ymd

STRING	ls_path, ls_fname, ls_check, ls_gj_jm_cd, ls_jm_cd, ls_jm_nm, ls_tr_cd, ls_fund_cd
STRING	ls_tr_co_cd, ls_trustee, ls_currency, ls_tr_dt, ls_blbg_tckr, ls_isin_cd, ls_balh_nation
STRING	ls_jasan_attr, ls_mic_cd, tmp_s, fund_tmp

DEC	ldc_tr_seq, ldc_tr_jusu, ldc_buy, ldc_sell, ldc_tr_danga, ldc_tr_cost, ldc_tr_aek
DEC	ldc_trans_rt, ldc_unit_aek

LONG	ll, lRC, ll_ret

ldt_ymd = dw_c.object.ymd [1]

//IF	of_getprocesscount ('excel.exe')>0	Then
//	messagebox('알림', '실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
//	of_killprocess ('excel.exe')
//End IF

IF GetFileOpenName ("해외선물파생거래내역엑셀자료 선택", ls_path, ls_fname, 'XLSX', "All Files (*.*),*.*", gaa.excel, 2)<>1 THEN RETURN
IF f_messageBox ('I002', ls_fname + ' 엑셀자료를 LOAD하시겠습니까?')=2 THEN RETURN

f_MicroHelp ('해외선물파생거래내역 엑셀자료 업로드 중...')

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
messagebox('건수확인!','엑셀의 거래내역 건수를 확인하세요 =' + string(lRC - 1) + '건')

DELETE  syt1mg
WHERE   corp_gr = :gaa.corp_gr
  AND   tr_ymd  = :ldt_ymd;

DELETE  syt1mg_each
WHERE   corp_gr   = :gaa.corp_gr
  AND   tr_ymd    = :ldt_ymd
  AND   jango_rec = 'N';

ll = 1
st_count.visible = true
DO WHILE TRUE
   ll ++
   IF lRC<ll THEN EXIT

   f_st_count (st_count, ls_path + ' : ', ll, lRC)

   ls_jm_cd    = TRIM (string (lSheet.cells (ll,3).Value))
   IF f_null (ls_jm_cd) Then
      messageBox ('ISIN종목코드 ERR확인', ls_jm_cd + 'ISIN 종목코드가 없습니다.')
      EXIT
   End IF

   ls_jm_nm = TRIM (string (lSheet.cells (ll,4).Value))
   ls_blbg_tckr  = TRIM (string (lSheet.cells (ll,12).Value))
   IF f_null (ls_blbg_tckr)  Then
      messageBox (string(ll) + '번째 티커코드확인', ls_blbg_tckr + '티커코드가 없습니다.')
      EXIT
   End IF

   ls_isin_cd  = TRIM (string (lSheet.cells (ll,11).Value))
   IF f_null (ls_isin_cd)  Then
      messageBox ('ISIN코드확인', ls_isin_cd + '종목의 ISIN코드가 없습니다.')
      EXIT
   End IF

   //-------------------------------
   //messagebox('종목정보','종목 :' + ls_jm_cd + ' ISIN : ' + ls_isin_cd)

   //sedol코드로 생성함
   ls_mic_cd = TRIM (string (lSheet.cells (ll,17).Value) + '_' + ls_jm_cd)

   //거래일
   //ldt_tr_ymd = datetime (lSheet.cells (ll,32).Value)
//   if  Len(lSheet.cells (ll, 32).Value) < 8 then
//   messagebox('종목정보오류','정산일 YYYYMMDD 오류 :' +Len(lSheet.cells (ll, 32).Value))
//  elseif  Len(lSheet.cells (ll, 32).Value) = 8 then
//   ldt_tr_ymd = datetime (mid(lSheet.cells (ll, 32).Value),1,4) + '-' + mid(lSheet.cells (ll, 32).Value),5,2) + '-' + mid(lSheet.cells (ll, 32).Value),7,2))
//  else
//   if  mid(lSheet.cells (ll, 32).Value),5,1) = '-'  and mid(lSheet.cells (ll, 32).Value),8,1) then
//          ldt_tr_ymd =  datetime (lSheet.cells (ll, 32).Value)
//      else
//    messagebox('종목정보오류','최종결제일 YYYYMMDD 오류 :' +Len(lSheet.cells (ll, 32).Value))
//  end if
//   end if

   //정산일
   //ls_gyulje_ymd = datetime (lSheet.cells (ll, 33).Value)
//   if  Len(lSheet.cells (ll, 33).Value) < 8 then
//   messagebox('종목정보오류','정산일 YYYYMMDD 오류 :' +Len(lSheet.cells (ll, 33).Value))
//  elseif  Len(lSheet.cells (ll, 33).Value) = 8 then
//   ldt_tr_ymd = datetime (mid(lSheet.cells (ll, 33).Value),1,4) + '-' + mid(lSheet.cells (ll, 33).Value),5,2) + '-' + mid(lSheet.cells (ll, 33).Value),7,2))
//  else
//   if  mid(lSheet.cells (ll, 33).Value),5,1) = '-'  and mid(lSheet.cells (ll, 33).Value),8,1) then
//          ldt_tr_ymd =  datetime (lSheet.cells (ll, 33).Value)
//      else
//    messagebox('종목정보오류','최종결제일 YYYYMMDD 오류 :' +Len(lSheet.cells (ll, 33).Value))
//  end if
//   end if

   //최종결제일
   tmp_s =  string(lSheet.cells (ll, 29).Value)

   IF Len(tmp_s)=10  Then
      SELECT  TO_DATE(:tmp_s,'yyyy-mm-dd')
        INTO  :ldt_lys_ymd
      FROM    dual;
		
		ldt_lys_ymd = SQLCA.getitemdatetime (1)

   ElseIF Len(tmp_s)=8  Then
      SELECT  TO_DATE(:tmp_s,'yyyymmdd')
        INTO  :ldt_lys_ymd
      FROM    dual;
		
		ldt_lys_ymd = SQLCA.getitemdatetime (1)

   else
      messagebox('종목정보오류','최종결제일  YYYYMMDD 오류 :' + tmp_s + ' 종목 :' + ls_jm_cd)
      EXIT
   End IF

   //KB증권인경우 0000170000으로 오면 00017로 사용함
   IF gaa.corp_gr='1911' Then
      ls_tr_co_cd = mid(TRIM (string (lSheet.cells (ll,9).Value)),1,5)
   else
      ls_tr_co_cd = mid(TRIM (string (lSheet.cells (ll,9).Value)),2,5)
   End IF

   //펀드코드 구하기
   //원자산의 경우 사무관리 펀드코드로 전송되어서 펀드코드 다시 구함
   fund_tmp  = TRIM (string (lSheet.cells (ll,2).Value))

   IF gaa.corp_gr='1911' Then
      //원자산 펀드코드 구하기
      SELECT  fund_cd
        INTO  :ls_fund_cd
      FROM    szm0fd_excode t1
      WHERE   corp_gr      = :gaa.corp_gr
        AND   samu_fund_cd = :fund_tmp;
		  
		ls_fund_cd = SQLCA.getitemstring (1)

      IF SQLCA.sqlcode ()<>0 THEN
         f_MessageBox ('ERR', '(szm0fd_excode #2630화면)에서 펀드코드를 구할 수 없습니다. 확인바랍니다! 입력펀드 : ' +TRIM (string (lSheet.cells (ll,2).Value)) + ' ' + string (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
			st_count.visible = false
         RETURN
      End IF
   else
      //펀드코드가 있는지 확인
      SELECT  fund_cd
        INTO  :ls_fund_cd
      FROM    szm0fd_excode t1
      WHERE   corp_gr    = :gaa.corp_gr
        AND   fund_cd    = :fund_tmp;
		  
		ls_fund_cd = SQLCA.getitemstring (1)

      IF SQLCA.sqlcode ()<>0 THEN
         f_MessageBox ('ERR', '(szm0fd_excode #2630화면)에서 펀드코드를 구할 수 없습니다. 확인바랍니다! 입력펀드 : ' +TRIM (string (lSheet.cells (ll,2).Value)) + ' ' + string (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
			st_count.visible = false
         RETURN
      End IF
   End IF

   ls_currency = TRIM (string (lSheet.cells (ll,16).Value))
   ls_balh_nation = TRIM (string (lSheet.cells (ll,15).Value))

//    //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_21','종목 21:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if

   //해외보관처 TRUSEE
   SELECT  TRUSTEE
     INTO  :ls_trustee
   FROM    syx2mm t1
   WHERE   t1.corp_gr  = :gaa.corp_gr
     AND   t1.currency = :ls_currency;
	  
	ls_trustee = SQLCA.getitemstring (1)

   IF SQLCA.sqlcode ()<>0 THEN
      f_MessageBox ('ERR', '해외보관처(syx2mm #9210화면)을 확인바랍니다! 종목 : ' + ls_isin_cd + ' 환률 : ' + ls_currency + ' ' + string (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
		st_count.visible = false
      RETURN
   End IF

   IF f_num (lSheet.cells (ll,32).Value)=0 Then
      ldc_tr_seq = ll
      ls_tr_dt  = null_s
   Else
      ldc_tr_seq = dec (lSheet.cells (ll,32).Value)
      ls_tr_dt = TRIM (string (lSheet.cells (ll,33).Value))
   End IF

   ldc_buy  = dec (lSheet.cells (ll,5).Value)
   ldc_sell = dec (lSheet.cells (ll,6).Value)
   IF ldc_buy>0   Then
      ldc_tr_jusu = ldc_buy   //선물매수
      ls_tr_cd    = 'S10'
   Else
      ldc_tr_jusu = ldc_sell  //선물매도
      ls_tr_cd    = 'S20'
   End IF

   IF ldc_tr_jusu<=0 Then
      f_messageBox ('ERR', '엑셀자료LOAD ' + ls_isin_cd + '종목의 매수/매도 수량을 확인바랍니다!.')
      EXIT
   End IF
   IF dec (lSheet.cells (ll,5).Value)>0 and dec (lSheet.cells (ll,6).Value)>0 Then
      f_messageBox ('ERR', '엑셀자료LOAD ' + ls_isin_cd + '종목의 매수/매도 수량이 중복되었습니다!.')
      EXIT
   End IF

//   //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_23','종목 23:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if

   //선물(jasan_gb[62] 구분='A') 거래내역에서 종목정보 생성
   SELECT  unit_aek
     INTO  :ldc_unit_aek
   FROM    sym0ya t1
   WHERE   t1.corp_gr  = :gaa.corp_gr
     AND   t1.jm_cd    = :ls_isin_cd
     AND   t1.jasan_gb = 'A';
	  
	ldc_unit_aek = SQLCA.getitemnumber (1)

   IF SQLCA.sqlcode ()<>0 THEN
      ldc_unit_aek   = dec (lSheet.cells (ll,19).Value)
   End IF

   IF ldc_unit_aek<=0   Then
      f_messageBox ('ERR', ls_isin_cd + '종목의 단위금액을 확인하세요.')
      EXIT
   End IF

   ldc_tr_cost    = dec (lSheet.cells (ll,8).Value)
   ldc_tr_aek     = dec (lSheet.cells (ll,7).Value)
   ldc_tr_danga   = ldc_tr_aek / ldc_tr_jusu / ldc_unit_aek

   //messagebox('','종목:' + ls_isin_cd, '거래금액 :' + string(ldc_tr_aek) + '수량:' + string(ldc_tr_jusu) + '단위:' + string(ldc_unit_aek) +  '지수:' + string(ldc_tr_danga))

//   //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_24','종목 24:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if

   IF ldc_tr_danga<=0   Then
      f_messageBox ('ERR', ls_isin_cd + '종목의 단가를 확인하세요.')
      EXIT
   End IF

   ldc_trans_rt = 0

   //환율
   SELECT  NVL(gijun_rt,0)
     INTO  :ldc_trans_rt
   FROM    syx0hy t1
   WHERE   gijun_ymd = :ldt_ymd - 1
     AND   currency  = :ls_currency;
	  
	ldc_trans_rt = SQLCA.getitemnumber (1)

   IF SQLCA.sqlcode ()<>0 THEN
      f_MessageBox ('ERR', '전일환율(syx0hy)확인! 종목: ' + ls_isin_cd + ' 환율 : ' + ls_currency)
		st_count.visible = false
      RETURN
   End IF

   //결제종목 구함
   SELECT  jm_cd
     INTO  :ls_gj_jm_cd
   FROM    sym0ya t1
   WHERE   t1.corp_gr   = :gaa.corp_gr
     AND   t1.currency  = :ls_currency
     AND   t1.gyulje_jm = 'Y'
     AND   t1.jasan_gb  = '5'
     AND   :ldt_ymd     Between  balh_ymd And sanghw_ymd;
	  
	ls_gj_jm_cd = SQLCA.getitemstring (1)

   IF SQLCA.sqlcode ()<>0 THEN
      f_MessageBox ('ERR', '해외예금(#2900화면)을 확인바랍니다! 종목 : ' + ls_isin_cd + ' 환률 : ' + ls_currency + ' 결제일 : ' + string(ldt_ymd) + ' SQL: ' + string (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
		st_count.visible = false
      RETURN
   End IF

//   //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_26','종목 26:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if


   //매매처의 기초자산유형  01:주식(A13),02:주가지수(A14),03:채권(A11),04:금리(A11),05:통화(A12),06:신용(A11),07:실물(A19)
   //                       08:귀금속(C30),09:농산물(C10),10:비철금속(C30),11:상품(A19),12:식료(C90),13:연료(C40)
   //                      ,14:지수해외 (A14),15:지표해외(A14),16:통화해외(A12),19:기타(A19)

   IF TRIM (string (lSheet.cells (ll,21).Value))='01' Then
      ls_jasan_attr  = 'A13'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='03' or TRIM (string (lSheet.cells (ll,21).Value))='04' or TRIM (string (lSheet.cells (ll,21).Value))='06' THEN
      ls_jasan_attr   = 'A11'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='02' or TRIM (string (lSheet.cells (ll,21).Value))='14' or TRIM (string (lSheet.cells (ll,21).Value))='15' THEN
      ls_jasan_attr   = 'A14'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='05' or TRIM (string (lSheet.cells (ll,21).Value))='16' THEN
      ls_jasan_attr   = 'A12'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='07' or TRIM (string (lSheet.cells (ll,21).Value))='19' THEN
      ls_jasan_attr   = 'A19'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='08' or TRIM (string (lSheet.cells (ll,21).Value))='10' THEN
      ls_jasan_attr   = 'C30'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='13' THEN
      ls_jasan_attr   = 'C40'
   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='12' THEN
      ls_jasan_attr   = 'C90'
   Else
      ls_jasan_attr   = 'A19'
   End IF;

//   //   -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_insert','종목 insert bf :' + ls_jm_cd + 'ISIN=' + ls_isin_cd + 'MIC_CD=' + ls_mic_cd )
//    end if

   //선물(jasan_gb[62] 구분='A') 거래내역에서 종목정보 생성
   SELECT  jm_cd
     INTO  :ls_check
   FROM    sym0ya t1
   WHERE   t1.corp_gr  = :gaa.corp_gr
     AND   t1.jm_cd    = :ls_isin_cd
     AND   t1.jasan_gb = 'A';
	  
	ls_check = SQLCA.getitemstring (1)

   IF SQLCA.sqlcode ()<>0 THEN
      INSERT INTO  sym0ya (
                     CORP_GR                          /* _1: */
                   , JM_CD                            /* _2: */
                   , JM_NM                            /* _3: */
                   , JASAN_GB                         /* _4: */
                   , BALH_NATION                      /* _5: */
                   , CURRENCY                         /* _6: */
                   , SJ_GB                            /* _7: */
                   , blbg_tckr                             /* _8: */
                   , ISIN_CD                          /* _9: */
                   , JASAN_ATTR                       /* _10: */
                   , UNIT_AEK                         /* _11: */
                   , BALH_YMD                         /* _12: */
                   , LSY_YMD                          /* _13: */
                   , JASAN                            /* _14: */
                   , SEDOL                            /* _15: */
                   )
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ls_isin_cd                                /* _2: */
             , :ls_jm_nm                                  /* _3: */
             , 'A'                                        /* _4: */
             , :ls_balh_nation                            /* _5: */
             , :ls_currency                               /* _6: */
             , '1'                                        /* _7: 선물처리 : 옵션등인경우 반영필요함 */
             , :ls_blbg_tckr                                   /* _8: */
             , :ls_isin_cd                                /* _9: */
             , :ls_jasan_attr                             /* _10: */
             , :ldc_unit_aek                              /* _11: */
             , :ls_balh_ymd                               /* _12: */
             , :ldt_lys_ymd                               /* _13: */
             , SUBSTR(:ls_isin_cd,1,2)                    /* _14:  상품분류 (위험평가액 계산등) */
             , :ls_mic_cd                                 /* _15: */
             );
      IF SQLCA.sqlcode ()<>0 THEN
         MessageBox ('ERR','신규종목 종목(sym0ya) INSERT시 오류! 종목 : ' + ls_isin_cd + ' ' + string (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
			st_count.visible = false
         RETURN
      End IF
   End IF

//   //   -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_insert','종목 insert aaaf :' + ls_jm_cd + 'ISIN=' + ls_isin_cd + 'MIC_CD=' + ls_mic_cd )
//    end if

   //거래내역 생성
   IF f_notnull (ls_tr_dt) Then
      INSERT INTO  syt1mg_each
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ldt_ymd                                   /* _2: */
             , :ls_fund_cd                                /* _3: */
             , :ls_tr_co_cd                               /* _4: */
             , :ls_trustee                                /* _5: */
             , :ls_isin_cd                                /* _6: */
             , :ls_currency                               /* _7: */
             , :ldc_tr_seq                                /* _8: */
             , TO_DATE(:ls_tr_dt,'yyyy-mm-dd hh24:mi:ss')  /* _9: */
             , :ldc_buy                                   /* _10: */
             , :ldc_sell                                  /* _11: */
             , :ldc_tr_danga                              /* _12: */
             , :ldc_tr_cost                               /* _13: */
             , :ldc_tr_aek                                /* _14: */
             , NULL                                       /* _15: */
             , NULL                                       /* _16: */
             , NULL                                       /* _17: */
             , NULL                                       /* _18: */
             , 'N'                                        /* _19: */
             , NULL                                       /* _20: */
             );
   Else
      INSERT INTO  syt1mg (
                     CORP_GR                          /* _1: */
                   , TR_YMD                           /* _2: */
                   , TR_CD                            /* _3: */
                   , FUND_CD                          /* _4: */
                   , TR_CO_CD                         /* _5: */
                   , TRUSTEE                          /* _6: */
                   , JM_CD                            /* _7: */
                   , CURRENCY                         /* _8: */
                   , TR_SEQ                           /* _9: */
                   , TR_JUSU                          /* _10: */
                   , TR_DANGA                         /* _11: */
                   , TR_COST                          /* _12: */
                   , TR_AEK                           /* _13: */
                   , GYULJE_YMD                       /* _14: */
                   , GYULJE_JM_CD                     /* _15: */
                   , TRANS_RT                         /* _16: */
                   , UPD_USER )                       /* _17: */
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ldt_ymd                                   /* _2: */
             , :ls_tr_cd                                  /* _3: */
             , :ls_fund_cd                                /* _4: */
             , :ls_tr_co_cd                               /* _5: */
             , :ls_trustee                                /* _6: */
             , :ls_isin_cd                                /* _7: */
             , :ls_currency                               /* _8: */
             , :ldc_tr_seq                                /* _9: */
             , :ldc_tr_jusu                               /* _10: */
             , :ldc_tr_danga                              /* _11: */
             , :ldc_tr_cost                               /* _12: */
             , :ldc_tr_aek                                /* _13: */
             , :ldt_ymd                                   /* _14: */
             , :ls_gj_jm_cd                               /* _15: */
             , :ldc_trans_rt                              /* _16: */
             , 'excel load'                               /* _17: */
             );
   End IF
   IF SQLCA.sqlcode ()<>0 THEN
      f_MessageBox ('ERR', '삼성선물 해외선물파생거래내역(syt1mg)INSERT오류 / 삭제후 재LOAD하세요! 종목 : ' + ls_isin_cd + ' ' + string (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
		st_count.visible = false
      RETURN
   End IF

//   //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_5','종목 555:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if
LOOP
st_count.visible = false

f_messageBox ('INFO', '삼성선물 해외선물파생거래내역 엑셀 LOAD처리 완료! 신규등록종목의 추가정보를 확인히세요!')

DESTROY lSheet
DESTROY obj_excel

commitJ ();

dw_list.reset ()
p_retrieve.POST EVENT clicked ()
end event

type cb_3 from pf_u_commandbutton within w_ja035b2
boolean visible = false
integer x = 2898
integer y = 16
integer width = 654
integer taborder = 30
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "엑셀LOAD(KB증권)"
end type

event clicked;OLEOBJECT   obj_excel, lSheet

DATETIME	ldt_ymd, ls_tr_ymd, ls_gyulje_ymd, ls_lys_ymd, ls_balh_ymd

STRING	ls_path, ls_fname, w_ls_jm_cd, ls_gj_jm_cd, ls_jm_cd, ls_jm_nm, ls_blbg_tckr, ls_isin_cd
STRING	ls_tr_cd, ls_fund_cd, ls_tr_co_cd, ls_trustee, ls_currency, ls_balh_nation, ls_jasan_attr
STRING	ls_mic_cd, tmp_s, acct_no

DEC	ls_tr_seq, ls_tr_jusu, ls_tr_danga, ls_tr_cost, ls_tr_aek, ls_trans_rt, ls_unit_aek

LONG	ll, lRC, ll_ret

// IF  of_getprocesscount ('excel.exe')>0  Then
// messagebox('알림', '실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
// of_killprocess ('excel.exe')
// End IF

ldt_ymd = dw_c.object.ymd [1]

IF GetFileOpenName ("해외선물파생거래내역엑셀자료 선택", ls_path, ls_fname, 'XLSX', "All Files (*.*),*.*", gaa.excel, 2)<>1 THEN RETURN
IF F_MESSAGEBOX ('I002', ls_fname + ' KB증권 엑셀자료를 LOAD하시겠습니까?')=2 THEN RETURN

f_MicroHelp ('KB증권 해외선물파생거래내역 엑셀자료 업로드 중...')

obj_excel = CREATE OLEOBJECT
ll_ret    = obj_excel.ConnectToNewObject ("excel.application")
IF ll_ret < 0  Then
   F_MESSAGEBOX ('XLS1', STRING (ll_ret))
   RETURN
END IF

obj_excel.Application.VISIBLE = TRUE
obj_excel.windowstate         = 3
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE)// 엑셀 읽기전용으로 열기

lSheet                                                                                   = obj_excel.Application.ActiveSheet
lRC                                                                                      = lSheet.UsedRange.Rows.COUNT


DELETE FROM SYT1MG
 WHERE CORP_GR = :gaa.CORP_GR
   AND tr_ymd  = :ldt_ymd ;

ll               = 1
st_count.VISIBLE = true
DO WHILE TRUE
   ll ++
   IF lRC<ll THEN EXIT

   f_st_count (st_count, ls_path + ' : ', ll, lRC)

   ls_jm_cd = TRIM (STRING (lSheet.cells (ll, 6).VALUE))
   IF ls_jm_cd = '' OR Len(ls_jm_cd) < 1  Then
      MESSAGEBOX ('ISIN종목코드 ERR확인', ls_jm_cd + 'ISIN 종목코드가 없습니다.')
      EXIT
   END IF


   ls_jm_nm = TRIM (STRING (lSheet.cells (ll, 7).VALUE))
   ls_blbg_tckr  = ls_jm_cd
   IF f_null (ls_blbg_tckr)  Then
      MESSAGEBOX (STRING(ll) + '번째 티커코드확인', ls_blbg_tckr + '티커코드가 없습니다.')
      EXIT
   END IF

   ls_isin_cd = ls_jm_cd
   IF f_null (ls_isin_cd)  Then
      MESSAGEBOX ('ISIN코드확인', ls_isin_cd + '종목의 ISIN코드가 없습니다.')
      EXIT
   END IF

      //-------------------------------
      //messagebox('종목정보','종목 :' + ls_jm_cd + ' ISIN : ' + ls_isin_cd)

   //sedol코드로 생성함
   ls_mic_cd = ls_jm_cd


   // 입력일 = 거래일 = 정산일이 같아야 합니다.
   ls_tr_ymd     = ldt_ymd
   ls_gyulje_ymd = ldt_ymd

   //발행일
   //ls_balh_ymd = ''

   //최종결제일
   tmp_s =  lSheet.cells (ll, 20).VALUE
   IF Len(tmp_s) < 8 Then
      MESSAGEBOX ('종목정보오류', '최종결제일  YYYYMMDD 오류 :' + tmp_s)
   ELSEIF Len(tmp_s) = 8   Then
      ls_lys_ymd = DATETIME (mid(tmp_s,1,4) + '-' + mid(tmp_s,5,2) + '-' + mid(tmp_s,7,2))
   ELSE
      IF mid(tmp_s,5,1) = '-' AND mid(tmp_s,8,1) = '-'   Then
            ls_lys_ymd =  DATETIME (tmp_s)
      ELSE
         MESSAGEBOX ('종목정보오류', '최종결제일  YYYYMMDD 오류 :' + tmp_s + '종목 : ' + ls_jm_cd)
         EXIT
      END IF
   END IF

   IF ldt_ymd <> ls_tr_ymd Then
      F_MESSAGEBOX ('ERR', ls_jm_cd + '종목의 거래일자(TradeDate)와 현재시스템일자를 확인하세요.')
      EXIT
   END IF

   //KB증권인경우 00017
   ls_tr_co_cd = '00017'

   acct_no =   TRIM (STRING (lSheet.cells (ll, 1).VALUE))
//   SELECT DISTINCT fund_cd
//     INTO :ls_fund_cd
//     FROM SZX2MA t1
//    WHERE CORP_GR                   = :gaa.CORP_GR
//      AND TO_DECRYPTS(enc_acct_no)  = :acct_no ;
   
   ls_fund_cd = SQLCA.GETITEMSTRING (1)

   IF SQLCA.sqlcode () <> 0   Then
      F_MESSAGEBOX ('ERR', '펀드 계좌번호(szx0mm #9210화면 매매처)을 확인바랍니다! 종목 : ' + ls_fund_cd + ' ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
      st_count.VISIBLE = false
      RETURN
   END IF


   ls_currency = TRIM (STRING (lSheet.cells (ll, 11).VALUE))
   //국가코드
   SELECT NATION_CD
     INTO :ls_balh_nation
     FROM SZX0WA t1
    WHERE CURRENCY = :ls_currency ;
  
   ls_balh_nation = SQLCA.GETITEMSTRING (1)

   IF SQLCA.sqlcode () <> 0   Then
      IF ls_currency = 'USD'  Then
         ls_balh_nation = 'US'
      ELSE
            ls_balh_nation = mid (ls_currency, 1, 2)
      END IF
   END IF

   //해외보관처 TRUSEE
   SELECT TRUSTEE
     INTO :ls_trustee
     FROM SYX2MM t1
    WHERE t1.CORP_GR  = :gaa.CORP_GR
      AND t1.currency = :ls_currency ;
   
   ls_trustee = SQLCA.GETITEMSTRING (1)

   IF SQLCA.sqlcode () <> 0   Then
      F_MESSAGEBOX ('ERR', '해외보관처(syx2mm #9210화면)을 확인바랍니다! 종목 : ' + ls_isin_cd + ' 환률 : ' + ls_currency + ' ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
      st_count.VISIBLE = false
      RETURN
   END IF

   ls_tr_seq = ll

   IF dec (lSheet.cells (ll,8).VALUE) <= 0 AND dec (lSheet.cells (ll,9).VALUE) <= 0 Then
      F_MESSAGEBOX ('ERR', '엑셀자료LOAD ' + ls_isin_cd + '종목의 매수/매도 수량이 모두 0입니다!.')
      EXIT
   END IF

   IF dec (lSheet.cells (ll,8).VALUE) > 0 AND dec (lSheet.cells (ll,9).VALUE) > 0   Then
      F_MESSAGEBOX ('ERR', '엑셀자료LOAD ' + ls_isin_cd + '종목의 매수/매도 수량이 중복입력되었습니다!.')
      EXIT
   END IF

   IF dec (lSheet.cells (ll,8).VALUE) > 0 Then
      ls_tr_jusu = dec (lSheet.cells (ll, 8).VALUE)
      //선물매수
      ls_tr_cd   = 'S10'
   END IF

   IF dec (lSheet.cells (ll,9).VALUE) > 0 Then
      ls_tr_jusu =  dec (lSheet.cells (ll, 9).VALUE)
      //선물매도
      ls_tr_cd   = 'S20'
   END IF

   //선물(jasan_gb[62] 구분='A') 거래내역에서 종목정보 생성
   SELECT unit_aek
     INTO :ls_unit_aek
     FROM SYM0YA t1
    WHERE t1.CORP_GR  = :gaa.CORP_GR
      AND t1.jm_cd    = :ls_isin_cd
      AND t1.jasan_gb = 'A' ;
   
   ls_unit_aek = SQLCA.GETITEMNUMBER (1)

   IF SQLCA.sqlcode () <> 0   Then
      //단위 = 약정금액 / 매수매도수량 / 매수매도가격
      ls_unit_aek = dec (lSheet.cells (ll, 12).VALUE) / (dec (lSheet.cells (ll, 8).VALUE) + dec (lSheet.cells (ll, 9).VALUE)) / dec (lSheet.cells (ll, 10).VALUE)
   END IF

   IF ls_unit_aek <= 0  Then
      F_MESSAGEBOX ('ERR', ls_isin_cd + '종목의 단위금액이 0입니다 확인하세요.')
      EXIT
   END IF

   ls_tr_cost  = dec (lSheet.cells (ll, 14).VALUE)
   ls_tr_aek   = dec (lSheet.cells (ll, 12).VALUE)
   ls_tr_danga = dec (lSheet.cells (ll, 10).VALUE)

//   IF dec(ls_tr_danga) = dec(ls_tr_aek / ls_tr_jusu / ls_unit_aek) Then
//      f_messageBox ('ERR', ls_isin_cd + '종목의 엑셀수신단가와 계산한 단가가 다릅니다. 확인하세요. 수신단가:' + string(ls_tr_danga) + '계산단가:' + string(ls_tr_aek / ls_tr_jusu / ls_unit_aek))
//      EXIT
//   End IF
   IF ls_tr_danga <= 0  Then
      
      EXIT
   END IF

   ls_trans_rt = 0

   //환율
   SELECT NVL(gijun_rt,0)
     INTO :ls_trans_rt
     FROM SYX0HY t1
    WHERE gijun_ymd = :ls_tr_ymd - 1
      AND currency  = :ls_currency ;
   
   ls_trans_rt = SQLCA.GETITEMNUMBER (1)

   IF SQLCA.sqlcode () <> 0   Then
      F_MESSAGEBOX ('ERR', '전일환율(syx0hy)확인! 종목: ' + ls_isin_cd + ' 환율 : ' + ls_currency)
      st_count.VISIBLE = false
      RETURN
   END IF

   IF ls_tr_ymd > ls_gyulje_ymd  Then
      F_MESSAGEBOX ('ERR', ls_isin_cd + '종목의 결제일(SettleDate)를 확인하세요.')
      EXIT
   END IF

   //결제종목 구함
   SELECT jm_cd
     INTO :ls_gj_jm_cd
     FROM SYM0YA t1
    WHERE t1.CORP_GR     = :gaa.CORP_GR
      AND t1.currency    = :ls_currency
      AND t1.gyulje_jm   = 'Y'
      AND t1.jasan_gb    = '5'
      AND :ls_gyulje_ymd Between balh_ymd AND sanghw_ymd ;
   
   ls_gj_jm_cd = SQLCA.GETITEMSTRING (1)

   IF SQLCA.sqlcode () <> 0   Then
      F_MESSAGEBOX ('ERR', '해외예금(#2900화면)을 확인바랍니다! 종목 : ' + ls_isin_cd + ' 환률 : ' + ls_currency + ' 결제일 : ' + STRING(ls_gyulje_ymd) + ' SQL: ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
      st_count.VISIBLE = false
      RETURN
   END IF

//   //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_26','종목 26:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if


// 매매처의 기초자산유형  01:주식(A13),02:주가지수(A14),03:채권(A11),04:금리(A11),05:통화(A12),06:신용(A11),07:실물(A19)
//                       08:귀금속(C30),09:농산물(C10),10:비철금속(C30),11:상품(A19),12:식료(C90),13:연료(C40)
//                      ,14:지수해외 (A14),15:지표해외(A14),16:통화해외(A12),19:기타(A19)

// 항상 장내지수선물옵션으로 처리함
   ls_jasan_attr = 'A14'

//


//   IF TRIM (string (lSheet.cells (ll,21).Value))='01' Then
//      ls_jasan_attr  = 'A13'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='03' or TRIM (string (lSheet.cells (ll,21).Value))='04' or TRIM (string (lSheet.cells (ll,21).Value))='06' THEN
//      ls_jasan_attr   = 'A11'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='02' or TRIM (string (lSheet.cells (ll,21).Value))='14' or TRIM (string (lSheet.cells (ll,21).Value))='15' THEN
//      ls_jasan_attr   = 'A14'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='05' or TRIM (string (lSheet.cells (ll,21).Value))='16' THEN
//      ls_jasan_attr   = 'A12'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='07' or TRIM (string (lSheet.cells (ll,21).Value))='19' THEN
//      ls_jasan_attr   = 'A19'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='08' or TRIM (string (lSheet.cells (ll,21).Value))='10' THEN
//      ls_jasan_attr   = 'C30'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='13' THEN
//      ls_jasan_attr   = 'C40'
//   ElseIF TRIM (string (lSheet.cells (ll,21).Value))='12' THEN
//      ls_jasan_attr   = 'C90'
//   Else
//      ls_jasan_attr   = 'A19'
//   End IF;


   //선물(jasan_gb[62] 구분='A') 거래내역에서 종목정보 생성
   SELECT jm_cd
     INTO :w_ls_jm_cd
     FROM SYM0YA t1
    WHERE t1.CORP_GR  = :gaa.CORP_GR
      AND t1.jm_cd    = :ls_isin_cd
      AND t1.jasan_gb = 'A' ;
   
   w_ls_jm_cd = SQLCA.GETITEMSTRING (1)

   IF SQLCA.sqlcode () <> 0   Then
      INSERT INTO SYM0YA
          ( CORP_GR
          , JM_CD
          , JM_NM
          , JASAN_GB
          , BALH_NATION
          , CURRENCY
          , SJ_GB
          , blbg_tckr
          , ISIN_CD
          , JASAN_ATTR
          , UNIT_AEK
          , BALH_YMD
          , LSY_YMD
          , JASAN
          , SEDOL
          )
      VALUES ( :gaa.CORP_GR
             , :ls_isin_cd
             , :ls_jm_nm
             , 'A'
             , :ls_balh_nation
             , :ls_currency
             , '1'                      /* 선물처리 : 옵션등인경우 반영필요함 */
             , :ls_blbg_tckr
             , :ls_isin_cd
             , :ls_jasan_attr
             , :ls_unit_aek
             , :ls_balh_ymd
             , :ls_lys_ymd
             , SUBSTR(:ls_isin_cd,1,2)  /* 상품분류 (위험평가액 계산등) */
             , :ls_mic_cd
             ) ;
      IF SQLCA.sqlcode () <> 0   Then
         MESSAGEBOX ('ERR', '신규종목 종목(sym0ya) INSERT시 오류! 종목 : ' + ls_isin_cd + ' ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
         st_count.VISIBLE = false
         RETURN
      END IF
   END IF

//   //   -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_insert','종목 insert aaaf :' + ls_jm_cd + 'ISIN=' + ls_isin_cd + 'MIC_CD=' + ls_mic_cd )
//    end if

   //거래내역 생성
   INSERT INTO SYT1MG
       ( CORP_GR
       , TR_YMD
       , TR_CD
       , FUND_CD
       , TR_CO_CD
       , TRUSTEE
       , JM_CD
       , CURRENCY
       , TR_SEQ
       , TR_JUSU
       , TR_DANGA
       , TR_COST
       , TR_AEK
       , GYULJE_YMD
       , GYULJE_JM_CD
       , TRANS_RT
       , UPD_USER
       )
   VALUES ( :gaa.CORP_GR
          , :ls_tr_ymd
          , :ls_tr_cd
          , :ls_fund_cd
          , :ls_tr_co_cd
          , :ls_trustee
          , :ls_isin_cd
          , :ls_currency
          , :ls_tr_seq
          , :ls_tr_jusu
          , :ls_tr_danga
          , :ls_tr_cost
          , :ls_tr_aek
          , :ls_gyulje_ymd
          , :ls_gj_jm_cd
          , :ls_trans_rt
          , 'excel load'
          ) ;
   IF SQLCA.sqlcode () <> 0   Then
      F_MESSAGEBOX ('ERR', 'KB증권 해외선물파생거래내역(syt1mg)INSERT오류 / 삭제후 재LOAD하세요! 종목 : ' + ls_isin_cd + ' ' + STRING (SQLCA.SQLDBCode) + SQLCA.SQLErrText())
      st_count.VISIBLE = false
      RETURN
   END IF

//   //  -----------------
//    if ls_isin_cd = 'HOH0'  then
//    messagebox('종목정보_5','종목 555:' + ls_jm_cd + 'ISIN=' + ls_isin_cd)
//    end if
LOOP
st_count.VISIBLE = false

F_MESSAGEBOX ('INFO', 'KB증권 해외선물파생거래내역 엑셀 LOAD처리 완료! 신규등록종목의 추가정보를 확인히세요!')

DESTROY lSheet
DESTROY obj_excel

commitJ ();

dw_list.reset ()
p_retrieve.POST EVENT clicked ()
end event

