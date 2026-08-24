forward
global type w_ja035b from wt_list
end type
end forward

global type w_ja035b from wt_list
string is_date_nation = "US"
string is_init_value = "J20"
end type
global w_ja035b w_ja035b

type variables
LONG	il_tr_seq

STRING	is_tr_co_cd
end variables

forward prototypes
public function string uf_ymdformat (string as_ymd)
end prototypes

public function string uf_ymdformat (string as_ymd);STRING	ls_ymd

IF POS (as_ymd, '-')>0 THEN
   ls_ymd = LEFT (f_replace (as_ymd,'-',''),8)
ElseIF POS (as_ymd, '.')>0 THEN
   ls_ymd = LEFT (f_replace (as_ymd,'.',''),8)
ElseIF POS (as_ymd, '/')>0 THEN
   ls_ymd = LEFT (f_replace (as_ymd,'/',''),8)
Else
   RETURN ls_ymd
End IF

RETURN ls_ymd
end function

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;//IF ib_manageData   Then
//   IF f_messageBox ('XLS0','')=1 Then
//      dw_List.POST EVENT ue_load ()
//      RETURN
//   End IF
//End IF

DATETIME ldt

STRING   ls_fund_cd

ldt        = dw_c.object.ymd [1]
ls_fund_cd = dw_c.object.rcd [1]

SELECT NVL(MAX(tr_seq),0) + 1
  INTO :il_tr_seq
  FROM SYT0MG t1
 WHERE CORP_GR = :gaa.CORP_GR
   AND TR_YMD  = :ldt
   AND FUND_CD = :ls_fund_cd;

ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.CORP_GR, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja035b.create
int iCurrent
call super::create
end on

on w_ja035b.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035b
end type

type ln_templeft from wt_list`ln_templeft within w_ja035b
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035b
end type

type ln_temptop from wt_list`ln_temptop within w_ja035b
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035b
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035b
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035b
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035b
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035b
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035b
end type

type ln_tempright from wt_list`ln_tempright within w_ja035b
end type

type uo_navi from wt_list`uo_navi within w_ja035b
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035b
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035b
end type

type st_top_rect from wt_list`st_top_rect within w_ja035b
end type

type p_close from wt_list`p_close within w_ja035b
end type

type p_excel from wt_list`p_excel within w_ja035b
end type

type p_print from wt_list`p_print within w_ja035b
end type

type p_delete from wt_list`p_delete within w_ja035b
end type

type p_update from wt_list`p_update within w_ja035b
end type

type p_input from wt_list`p_input within w_ja035b
end type

type p_retrieve from wt_list`p_retrieve within w_ja035b
end type

type p_clear from wt_list`p_clear within w_ja035b
end type

type p_copy from wt_list`p_copy within w_ja035b
end type

type dw_c from wt_list`dw_c within w_ja035b
string title = "영업일자@거래코드@펀드코드"
string dataobject = "dc_ymd_dddw_xx"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA035B'")
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] >= idt_workdate)
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SYT0MG t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd 
                        FROM SZX1PT h1
                       WHERE obj_id = 'W_SJA035B')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
CHOOSE CASE DWO.NAME
   CASE 'ymd'
      IF DATETIME (DATE (MID (data,1,10))) >= idt_workdate  Then
         ib_manageData   = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035B'")
      ELSE
         ib_manageData   = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.CORP_GR, '', 1, "szx1pt.obj_id='W_JA035B' and szx0gc.tr_cd in (select tr_cd from syt0mg where corp_gr=':corp_gr' and tr_ymd='" + MID (data, 1, 10) + "')")
      END IF
   CASE 'rcd'
      SELECT mg_cd
        INTO :is_tr_co_cd
        FROM SZM0IA t1
       WHERE CORP_GR = :gaa.CORP_GR
         AND FUND_CD = :data;

      is_tr_co_cd = SQLCA.GETITEMSTRING (1)
END CHOOSE
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;rs_Where = "nvl(HAEJI_YMD, '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "') >= '" + string (idt_workdate,'yyyy.mm.dd') + "'"
RETURN 4
end event

type btn_update from wt_list`btn_update within w_ja035b
end type

type st_count from wt_list`st_count within w_ja035b
end type

type dw_list from wt_list`dw_list within w_ja035b
integer y = 344
string dataobject = "d_ja035b"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt
STRING	ls_data

LONG	lRow, lRowCount
DEC	ldc_trans_rt

lRowCount = ROWCOUNT ()

IF f_null (Object.tr_tax [row])  THEN Object.tr_tax [row] = 0
IF f_null (Object.tr_cost [row]) THEN Object.tr_cost [row] = 0

ldt = dw_c.object.ymd [1]

CHOOSE CASE DWO.NAME
   CASE 'fund_cd'
      ls_data = Object.fund_cd [row]
      FOR  lRow = (ROW + 1) TO  lRowCount
         IF f_null (Object.fund_cd [lRow]) OR Object.fund_cd [lRow]=ls_data THEN Object.fund_cd [lRow] = data
      NEXT
      
   CASE 'trustee'
      SELECT currency
        INTO :ls_data
        FROM SYX2MM t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.trustee = :data ;
      ls_data = SQLCA.GETITEMSTRING (1)
      
       SELECT F_CURRENCY_RT(:gaa.CORP_GR,:ldt,:ls_data) INTO :ldc_trans_rt FROM DUAL;
      ldc_trans_rt = SQLCA.GETITEMNUMBER (1)
      IF ldc_trans_rt <> -1   Then
         Object.trans_rt [row]       = ldc_trans_rt
         Object.won_gyulje_aek [row] = truncate (f_num (Object.gyulje_aek [row]) * ldc_trans_rt,0)
      END IF

      Object.currency [row] = ls_data

   CASE 'currency'
       SELECT F_CURRENCY_RT(:gaa.CORP_GR,:ldt,:data) INTO :ldc_trans_rt FROM DUAL;
      ldc_trans_rt = SQLCA.GETITEMNUMBER (1)
      IF ldc_trans_rt <> -1   Then
         Object.trans_rt [row]       = ldc_trans_rt
         Object.won_gyulje_aek [row] = truncate (f_num (Object.gyulje_aek [row]) * ldc_trans_rt,0)
      END IF
      
   CASE 'tr_jusu'
      Object.tr_aek [row] = dec (data) * Object.tr_danga [row]
      IF dw_c.object.dddw [1] = 'K20'  Then
         Object.gyulje_aek [row] = Object.tr_aek [row] - (Object.tr_tax [row] + Object.tr_cost [row])
      ELSE
         Object.gyulje_aek [row] = Object.tr_aek [row] + (Object.tr_tax [row] + Object.tr_cost [row])
      END IF
   CASE 'tr_danga'
      Object.tr_aek [row] = dec (data) * Object.tr_jusu [row]
      IF dw_c.object.dddw [1] = 'K20'  Then
         Object.gyulje_aek [row] = Object.tr_aek [row] - (Object.tr_tax [row] + Object.tr_cost [row])
      ELSE
         Object.gyulje_aek [row] = Object.tr_aek [row] + (Object.tr_tax [row] + Object.tr_cost [row])
      END IF
   CASE 'tr_tax'
      IF dw_c.object.dddw [1] = 'K20'  Then
         Object.gyulje_aek [row] = Object.tr_aek [row] - (dec (data) + Object.tr_cost [row])
      ELSE
         Object.gyulje_aek [row] = Object.tr_aek [row] + (dec (data) + Object.tr_cost [row])
      END IF
   CASE 'tr_cost'
      IF dw_c.object.dddw [1] = 'K20'  Then
         Object.gyulje_aek [row] = Object.tr_aek [row] - (Object.tr_tax [row] + dec (data))
      ELSE
         Object.gyulje_aek [row] = Object.tr_aek [row] + (Object.tr_tax [row] + dec (data))
      END IF
//   CASE 'count_cost'
//      FOR  lRow = (ROW + 1) TO  lRowCount
//         IF f_null (Object.count_cost [lRow]) OR Object.count_cost [lRow]=ls_data THEN Object.count_cost [lRow] = data
//      NEXT
END CHOOSE
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'trustee' , gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'gyulje_jm_cd', gaa.corp_gr, '', 1, "")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('bs_type', '0')
il_tr_seq ++
uf_setColumn ('tr_seq', string (il_tr_seq))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::ue_load;call super::ue_load;OLEOBJECT   obj_excel, lSheet

LONG	ll_ret, ll_seq=0, lSeq, lRC, r=1

STRING	ls_path, la_filename [], ls_tr_cd, ls_fund_cd, ls_tr_co_cd, ls_trustee, ls_jm_cd, ls_jm_nm
STRING	ls_cur, ls_gyulje_ymd, ls_tr_ymd

DEC	ld_tr_jusu, ld_tr_danga, ld_tr_tax, ld_tr_cost, ld_tr_aek, ld_gyulje_aek, ld_won_gyulje_aek
DEC	ld_trans_rt

dw_List.reset ()

IF GetFileOpenName ("매매내역 파일 선택", ls_path, la_filename, 'XLS', "All Files (*.*),*.*", gaa.excel, 2)<>1 THEN RETURN

f_MicroHelp ('매매내역 자료 업로드 중...')

obj_excel = CREATE OLEOBJECT
ll_ret    = obj_excel.ConnectToNewObject ("excel.application")
IF ll_ret < 0  Then
   F_MESSAGEBOX ('XLS1', STRING (ll_ret))
   RETURN
END IF

obj_excel.Application.VISIBLE = TRUE
obj_excel.windowstate         = 1
obj_excel.WorkBooks.OPEN (ls_path, 0, TRUE)// 엑셀 읽기전용으로 열기

lSheet = obj_excel.Application.ActiveSheet
lRC    = lSheet.UsedRange.Rows.COUNT

st_count.VISIBLE = true
DO WHILE TRUE
   r ++
   IF lRC<r THEN EXIT
   f_st_count (st_count, ls_path + ' : ', r, lRC)

   ls_tr_co_cd       = STRING (lSheet.cells (r, 1).VALUE)
   ls_fund_cd        = STRING (lSheet.cells (r, 2).VALUE)
   ls_tr_ymd         = uf_ymdformat (STRING (lSheet.cells (r, 4).VALUE))
   ls_tr_cd          = f_replace (STRING (lSheet.cells (r, 5).VALUE), ' ', '')
   ls_gyulje_ymd     = uf_ymdformat (STRING (lSheet.cells (r, 6).VALUE))
   ls_jm_cd          = f_replace (STRING (lSheet.cells (r, 7).VALUE), ' ', '')
   ls_jm_nm          = f_replace (STRING (lSheet.cells (r, 8).VALUE), ' ', '')
   ld_tr_jusu        = dec (lSheet.cells (r, 9).VALUE)
   ld_tr_danga       = dec (lSheet.cells (r, 10).VALUE)
   ld_tr_aek         = dec (lSheet.cells (r, 11).VALUE)
   ld_tr_cost        = f_num (dec (lSheet.cells (r, 12).VALUE))
   ld_tr_tax         = f_num (dec (lSheet.cells (r, 13).VALUE))
   ld_gyulje_aek     = dec (lSheet.cells (r, 14).VALUE)
   ls_cur            = f_replace (STRING (lSheet.cells (r, 15).VALUE), ' ', '')
   ls_trustee        = ls_cur + '01'
   ld_trans_rt       = dec (lSheet.cells (r, 16).VALUE)
   ld_won_gyulje_aek = dec (lSheet.cells (r, 17).VALUE)

   IF ls_tr_cd = '매수' Then
      ls_tr_cd = 'J20'
   ELSEIF ls_tr_cd = '매도'   Then
      ls_tr_cd = 'K20'
   ELSE
      MESSAGEBOX ('ERR', '거래구분을 확인하여 주십시오. [' + ls_tr_cd + ']')
      rollbackJ ()
      EXIT
   END IF

   SELECT CASE WHEN :ls_cur='CNY' THEN LPAD (TRIM (:ls_jm_cd), 6,'0') ELSE LPAD (TRIM (:ls_jm_cd), 5,'0') END
     INTO :ls_jm_cd
     FROM DUAL ;
   
   ls_jm_cd = SQLCA.GETITEMSTRING (1)

   SELECT jm_cd
     INTO :ls_jm_cd
     FROM SYM0YA t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND CORP_GR    = :gaa.CORP_GR
      AND jm_cd      = :ls_jm_cd ;
   
   ls_jm_cd = SQLCA.GETITEMSTRING (1)
   
   IF SQLCA.SQLCode() = 100   Then
      MESSAGEBOX ('', '종목정보 생성. [' + ls_jm_cd + '][' + ls_jm_nm + ']')
      INSERT INTO SYM0YA
          ( CORP_GR
          , jm_cd
          , jm_nm
          , jasan_gb
          , balh_nation
          , currency
          , sangj_ymd
          )
      VALUES ( :gaa.CORP_GR
             , :ls_jm_cd
             , TRIM(:ls_jm_nm) 
             , '1'
             , SUBSTR(:ls_cur,1,2) 
             , :ls_cur
             , sysdate
             ) ;
      IF SQLCA.SQLCode()<>0 THEN MESSAGEBOX ('sym0ya INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
   END IF

   SELECT NVL(MAX(tr_seq), 0) + 1
     INTO :lSeq
     FROM SYT0MG t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND t1.tr_ymd  = :ls_tr_ymd ;

   lSeq = SQLCA.GETITEMNUMBER (1)

   ll_seq ++

   INSERT INTO SYT0MG
       ( CORP_GR         /* 운용(자문)사 */
       , tr_ymd          /* 매매일자 */
       , tr_cd           /* 거래코드 */
       , fund_cd         /* 펀드코드 */
       , tr_co_cd        /* 매매처코드 */
       , trustee         /* 해외보관처 */
       , jm_cd           /* 종목코드 */
       , bs_type
       , currency        /* 통화[89] */
       , tr_seq          /* 거래순번 */
       , tr_jusu         /* 매매주수(액면) */
       , tr_danga        /* 매매단가 */
       , tr_tax          /* 거래세 */
       , tr_cost         /* 거래비용 */
       , tr_aek          /* 매매금액 */
       , gyulje_ymd      /* 결제일자 */
       , gyulje_aek      /* 결제금액 */
       , won_gyulje_aek  /* 결제금액(매매일자 환율 원화) */
       , trans_rt        /* 거래환율 */
       )
   VALUES ( :gaa.CORP_GR                          /* 운용(자문)사 */
          , TO_DATE(:ls_tr_ymd,'yyyy.mm.dd')      /* 매매일자 */
          , :ls_tr_cd                             /* 거래코드 */
          , :ls_fund_cd                           /* 펀드코드 */
          , :ls_tr_co_cd                          /* 매매처코드 */
          , :ls_trustee                           /* 해외보관처 */
          , :ls_jm_cd                             /* 종목코드 */
          , 0
          , :ls_cur                               /* 통화[89] */
          , :lSeq                                 /* 거래순번 */
          , :ld_tr_jusu                           /* 매매주수(액면) */
          , :ld_tr_danga                          /* 매매단가 */
          , :ld_tr_tax                            /* 거래세 */
          , :ld_tr_cost                           /* 거래비용 */
          , :ld_tr_aek                            /* 매매금액 */
          , TO_DATE(:ls_gyulje_ymd,'yyyy.mm.dd')  /* 결제일자 */
          , :ld_gyulje_aek                        /* 결제금액 */
          , :ld_won_gyulje_aek                    /* 결제금액(매매일자 환율 원화) */
          , :ld_trans_rt                          /* 거래환율 */
          ) ;
   IF SQLCA.SQLCode()<>0 THEN MESSAGEBOX ('syt0mg INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
LOOP
st_count.VISIBLE = false

commitJ ()
MESSAGEBOX ('P000', '매매내역이 저장되었습니다. [' + STRING (ll_seq) + '건]')

lSheet.DISCONNECTOBJECT ()
DESTROY lSheet

obj_excel.Application.QUIT
DESTROY obj_excel
end event

event dw_list::ue_protect;call super::ue_protect;IF ib_managedata  Then
   Object.p_visible [row] = 1
ELSE
   Object.p_visible [row] = 0
END IF
f_dw_resetstatus (THIS, ROW, {'p_visible'})
end event

event dw_list::retrieveend;call super::retrieveend;IF dw_c.object.dddw [1]<>'K20'  THEN RETURN
IF F_NULL (dw_c.object.rcd [1]) THEN RETURN

aDS_jTier lds_jtier

LONG  lR, lm, ll

STRING   ls_sqlsyntax

ls_sqlsyntax = " SELECT t1.jm_cd " + &
               "      , t1.trustee " + &
               "      , t1.currency " + &
               "      , ya.jm_nm " + &
               "      , NVL(t1.tr_bfil_jusu,0) + NVL(t1.tr_up_jusu,0) - NVL(t1.tr_dw_jusu,0) " + &
               "                               + NVL(t1.RIGHT_JUSU,0) + NVL(t1.msd_meib_aekm,0) - NVL(t1.msd_medo_aekm,0) " + &
               "      , NVL(t1.tr_bfil_chui_aek,0) + NVL(t1.tr_up_chui_aek,0) - NVL(t1.tr_dw_chui_aek,0) " + &
               "                                   + NVL(t1.RIGHT_AEK,0) + NVL(t1.msd_meib_aek,0) " + &
               "   FROM SYM0YZ t1 " + &
               "      , SYM0YA ya " + &
               "  WHERE 1 = 1 " + &
               "    AND t1.corp_gr  = '" + gaa.CORP_GR + "' " + &
               "    AND t1.fund_cd  = '" + string (dw_c.object.rcd [1]) + "' " + &
               "    AND t1.ymd      = '" + string (dw_c.object.ymd [1], 'yyyy.mm.dd') + "' " + &
               "    AND ya.JASAN_GB = '1' " + &
               "    AND ya.corp_gr  = t1.corp_gr " + &
               "    AND ya.jm_cd    = t1.jm_cd "

lR = SQLCA.sql2ds (parent.classname( ), ls_sqlsyntax, lds_jtier, 'xml')

FOR lm = 1 TO lR
   il_tr_seq ++

   ll = dw_list.insertrow (0)

   dw_list.object.CORP_GR    [ll] = gaa.CORP_GR
   dw_list.object.tr_ymd     [ll] = dw_c.object.ymd [1]
   dw_list.object.tr_cd      [ll] = dw_c.object.dddw [1]
   dw_list.object.tr_seq     [ll] = il_tr_seq
   dw_list.object.xx_mg_cd   [ll] = is_tr_co_cd
   dw_list.object.fund_cd    [ll] = dw_c.object.rcd [1]
   dw_list.object.xx_fund_cd [ll] = dw_c.object.xx_rcd [1]
   dw_list.object.yj_cd      [ll] = lds_jtier.GETITEMSTRING (lm, 1)  // ya.jm_cd
   dw_list.object.trustee    [ll] = lds_jtier.GETITEMSTRING (lm, 2)
   dw_list.object.bs_type    [ll] = 0
   dw_list.object.currency   [ll] = lds_jtier.GETITEMSTRING (lm, 3)  // ya.currency
   dw_list.object.xx_yj_cd   [ll] = lds_jtier.GETITEMSTRING (lm, 4)  // ya.jm_nm (검색 값)
   dw_list.object.tr_jusu    [ll] = lds_jtier.GETITEMNUMBER (lm, 5)  // jusu
   dw_list.object.tr_cost    [ll] = 0
   dw_list.object.tr_tax     [ll] = 0
   dw_list.object.tr_danga   [ll] = 0
   dw_list.object.gyulje_ymd [ll] = dw_c.object.ymd [1]
   dw_list.object.p_visible  [ll] = 1

	dw_list.SetItemStatus (ll, 0, Primary!, NotModified!)
	dw_list.SetItemStatus (ll, 0, Primary!, New!)
NEXT

end event

