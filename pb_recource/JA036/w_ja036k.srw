forward
global type w_ja036k from wt_list
end type
type dw_xlsx from u_dw within w_ja036k
end type
type cb_1 from pf_u_commandbutton within w_ja036k
end type
type cb_2 from pf_u_commandbutton within w_ja036k
end type
type cb_status from pf_u_commandbutton within w_ja036k
end type
type cb_tr from pf_u_commandbutton within w_ja036k
end type
type cb_siga from pf_u_commandbutton within w_ja036k
end type
type st_1 from pf_u_statictext within w_ja036k
end type
type lb_list from pf_u_listbox within w_ja036k
end type
end forward

global type w_ja036k from wt_list
dw_xlsx dw_xlsx
cb_1 cb_1
cb_2 cb_2
cb_status cb_status
cb_tr cb_tr
cb_siga cb_siga
st_1 st_1
lb_list lb_list
end type
global w_ja036k w_ja036k

type variables
STRING	is_path, ia_file []
DATETIME	idt_sysdate
end variables

forward prototypes
public subroutine wf_load_status (string arg_naye)
public function integer wf_2501_meme ()
public function integer wf_2501 ()
end prototypes

public subroutine wf_load_status (string arg_naye);dw_list.uf_dataobject ('d_ja020n', FALSE)

LONG	lRow

lRow = dw_list.insertrow (0)

dw_list.object.CORP_GR [lRow]             = gaa.CORP_GR
dw_list.object.load_date [lRow]           = f_sysdate ('')
dw_list.object.ip_user [lRow]             = gaa.login
dw_list.object.fw_user_mst_user_nm [lRow] = gnv_vari.is_user_nm
IF POS (arg_naye,'?????') > 0 Then
   dw_list.object.load_ok [lRow] = '1'
ELSE
   dw_list.object.load_ok [lRow] = '0'
END IF
dw_list.object.load_naye [lRow] = arg_naye
dw_list.object.load_ymd [lRow]  = dw_c.object.ymd [1]
dw_list.SETROW (lRow)
dw_list.scrolltorow (lRow)
end subroutine

public function integer wf_2501_meme ();OLEOBJECT   lXls, lSheet

INT   li_con, li_xls, li_file = 0
LONG	ll, ln, ll_sheet, lm_word

DATETIME	ldt_ymd
STRING	la_meme [], la_fund [], la_mg_cd [], la_enc_acct [], ra_word []
STRING	ls_msg, ls_file, ls_temp, ls_acct, ls_fund, ls_mg_cd, ls_enc_acct

ldt_ymd = dw_c.object.ymd [1]

lXls = CREATE OLEOBJECT

li_con = lXls.ConnectToNewObject ("excel.application")
IF li_con <> 0 Then
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
      CASE ELSE
         ls_msg = "If any argument's value is NULL, ConnectToNewObject returns NULL.~r~n"
   END CHOOSE
   DESTROY lXls
   MESSAGEBOX ("ERROR", "엑셀 프로그램을 실행할 수 없습니다.~r~n" + ls_msg, StopSign!)
   RETURN -10
END IF

dw_list.reset ()
dw_list.enabled = TRUE

F_LOADINGRETRIEVE (TRUE)
st_count.VISIBLE = TRUE

li_xls = UPPERBOUND (ia_file)
FOR  ll = 1  TO  li_xls
   IF li_xls = 1  Then
      ls_file = is_path
   ELSE
      ls_file = is_path + '\' + ia_file [ll]
   END IF
   F_ST_COUNT (st_count, ia_file [ll] + '~r~nLOAD File : ', ll, li_xls)

   lXls.WorkBooks.OPEN (ls_file)
   lXls.Application.VISIBLE = FALSE

   ll_sheet = lXls.Application.Workbooks (1).worksheets.COUNT  // Sheet의 갯수
   FOR  ln = 1  TO  ll_sheet
      lSheet = lXls.Application.Workbooks (1).worksheets (ln)
      lSheet.Activate
      ls_temp = TRIM (lSheet.NAME)
      IF ll_sheet = 1 AND lower (LEFT (ls_temp,5)) = 'sheet'   Then
         // 파일명에 관리번호 형식으로 처리
         lm_word = gre.rt_file (ls_file, ra_word)
         IF lm_word < 4 Then
            F_MESSAGEBOX ('ERR', "파일명 형식 '증권사명(#화면번호)_관리번호.xls' 을 확인하십시오.")
            CONTINUE
         END IF

         SELECT fund_cd
              , mg_cd
              , enc_acct_no
           INTO :ls_fund
              , :ls_mg_cd
              , :ls_enc_acct
           FROM SZM0IA ia
          WHERE ia.CORP_GR = :gaa.CORP_GR
            AND ia.fund_cd = :ra_word[lm_word - 2] ;
         IF SQLCA.sqlcode () = 0 Then
            ls_fund     = SQLCA.GETITEMSTRING (1)
            ls_mg_cd    = SQLCA.GETITEMSTRING (2)
            ls_enc_acct = SQLCA.GETITEMSTRING (3)

            DELETE FROM SYT0MG_LOAD tt  
             WHERE CORP_GR   = :gaa.CORP_GR
               AND tr_ymd    = :ldt_ymd
               AND fund_cd   = :ls_fund
               AND load_user = 'JA036K' ;
         ELSE
            F_MESSAGEBOX ('ERR', "파일명 형식 '증권사명(#화면번호)_관리번호.xls' 을 확인하십시오.")
            CONTINUE
         END IF
      ELSE
         SELECT fund_cd
              , mg_cd
              , enc_acct_no
           INTO :ls_fund
              , :ls_mg_cd
              , :ls_enc_acct
           FROM SZM0IA ia
          WHERE ia.CORP_GR = :gaa.CORP_GR
            AND ia.fund_cd = :ls_temp ;
         IF SQLCA.sqlcode () <> 0   Then
            ls_acct = F_REPLACE (ls_temp, '-', '')

            SELECT fund_cd
                 , mg_cd
                 , enc_acct_no
              INTO :ls_fund
                 , :ls_mg_cd
                 , :ls_acct
              FROM SZM0IA ia
             WHERE ia.CORP_GR                                    = :gaa.CORP_GR
               AND REPLACE(TO_DECRYPTS(ia.enc_acct_no), '-','')  = :ls_acct ;
         END IF
         IF SQLCA.sqlcode () = 0 Then
            ls_fund     = SQLCA.GETITEMSTRING (1)
            ls_mg_cd    = SQLCA.GETITEMSTRING (2)
            ls_enc_acct = SQLCA.GETITEMSTRING (3)

            DELETE FROM SYT0MG_LOAD tt  
             WHERE CORP_GR   = :gaa.CORP_GR
               AND tr_ymd    = :ldt_ymd
               AND fund_cd   = :ls_fund
               AND load_user = 'JA036K' ;
         ELSE
            ls_fund     = ''
            ls_mg_cd    = ''
            ls_enc_acct = ''
         END IF
      END IF

      li_file ++

      IF ls_fund = ''   Then
         la_meme [li_file] = gaa.temp + '(' + gaa.CORP_GR + ')' + STRING (ldt_ymd, 'yyyymmdd') + '(' + STRING (li_file) + ').csv'
         wf_load_status (la_meme [li_file] + ' 엑셀시트 LOAD 완료...')
      ELSE
         la_meme [li_file] = gaa.temp + '(' + gaa.CORP_GR + ')' + STRING (ldt_ymd, 'yyyymmdd') + '(' + ls_fund + ').csv'
         wf_load_status (ls_fund + ' 엑셀시트 LOAD 완료...')
      END IF
      IF FileExists (la_meme [li_file]) THEN FileDelete (la_meme [li_file])
      lXls.Application.Workbooks (1).Worksheets (ln).Saveas (la_meme [li_file], 6)

      la_fund [li_file]     = ls_fund
      la_mg_cd [li_file]    = ls_mg_cd
      la_enc_acct [li_file] = ls_enc_acct
   NEXT
   lXls.WorkBooks (1).saved = TRUE
   lXls.WorkBooks.CLOSE ()
NEXT
lXls.Application.Quit
lXls.DISCONNECTOBJECT ()

DESTROY lXls

LONG	lc [], lm, lRow, lPOS

STRING	ls_col, la_data []

ls_col = '01-매매일자,02-결제일자,03-종목명,04-종목코드,05-시장구분,06-매매구분,07-체결수량,08-체결단가,09-약정금액,10-수수료,11-정산금액,12-통화,13-매매일기준환율,14-결제일기준환율'

DEC	tr_jusu, tr_danga, tr_susu, tr_tax, tr_aek, meme_rt, gyul_rt

// 거래내역 LOAD
FOR  ll = 1  TO  li_file
   IF NOT FileExists (la_meme [ll]) Then
      wf_load_status ('????? ' + la_meme [ll] + ' file check')
      CONTINUE
   END IF

   dw_xlsx.reset ()
   lRow = dw_xlsx.importfile (CSV!, la_meme [ll], 1)
   IF lRow < 2 Then
      wf_load_status ('????? ' + la_meme [ll] + ' data empty')
      CONTINUE
   END IF

   lc = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
   FOR  lm = 1  TO  30
      ls_temp = F_REPLACE (STRING (dw_xlsx.object.data [1,lm]), ' ', '')
      IF f_null (ls_temp) THEN EXIT
      ls_temp = F_REPLACE (ls_temp, '~t', '')
      ls_temp = F_REPLACE (ls_temp, '~r', '')
      ls_temp = F_REPLACE (ls_temp, '~n', '')

      lPOS = POS (ls_col, ls_temp)
      IF lPOS=0 THEN CONTINUE
      lPOS      = dec (MID (ls_col, lPOS - 3, 2))
      lc [lPOS] = lm
   NEXT

   FOR  lm = 2 TO  lRow
      F_ST_COUNT (st_count, la_meme [ll] + '~r~nData LOAD', lm, lRow)

      FOR  ln = 1  TO  14
         la_data [ln] = null_s
         IF lc [ln]>0 THEN la_data [ln] = TRIM (STRING (dw_xlsx.object.data [lm,lc [ln]]))
      NEXT

      IF F_NULL (la_data [3]) THEN CONTINUE    // 빈줄 pass

      IF la_fund [ll] > '' Then
         ls_fund     = la_fund [ll]
         ls_mg_cd    = la_mg_cd [ll]
         ls_enc_acct = la_enc_acct [ll]
//      ELSE
//         IF F_NULL (ls_acct) THEN CONTINUE   // 빈줄 pass
//         ls_acct = F_REPLACE (ls_acct, '-', '')
//
//         SELECT fund_cd
//              , mg_cd
//              , enc_acct_no
//           INTO :ls_fund
//              , :ls_mg_cd
//              , :ls_enc_acct
//           FROM SZM0IA ia
//          WHERE ia.CORP_GR                                    = :gaa.CORP_GR
//            AND REPLACE(TO_DECRYPTS(ia.enc_acct_no), '-','')  = :ls_acct ;
//         IF SQLCA.sqlcode () = 0 Then
//            ls_fund     = SQLCA.GETITEMSTRING (1)
//            ls_mg_cd    = SQLCA.GETITEMSTRING (2)
//            ls_enc_acct = SQLCA.GETITEMSTRING (3)
//         ELSE
//            wf_load_status ('> ' + la_meme [ll] + ' - 계좌번호 확인 (' + F_NVL (ls_acct, 'ls_acct') + ')')
//            CONTINUE
//         END IF
      END IF

      tr_jusu  = dec (la_data[7])
      tr_danga = dec (la_data[8])
      tr_susu  = dec (la_data[10])
      tr_aek   = dec (la_data[11])
      meme_rt  = dec (la_data[13])
      gyul_rt  = dec (la_data[14])

      INSERT INTO SYT0MG_LOAD
      VALUES ( :gaa.CORP_GR  /* _1- */
             , :ldt_ymd      /* _2- */
             , :lm           /* _3- */
             , :ls_fund      /* _4- */
             , :ls_mg_cd     /* _5- */
             , :la_data[4]   /* _6- */
             , :la_data[3]   /* _7- */
             , :la_data[12]  /* _8- */
             , :la_data[5]   /* _9- */
             , :la_data[6]   /* _10- */
             , :la_data[1]   /* _11- */
             , :la_data[2]   /* _12- */
             , :tr_jusu      /* _13- */
             , :tr_danga     /* _14- */
             , :tr_susu      /* _15- */
             , NULL          /* _16- */
             , :tr_aek       /* _17- */
             , :meme_rt      /* _18- */
             , :gyul_rt      /* _19- */
             , 'JA036K'      /* _20- */
             , sysdate       /* _21- */
             ) ;
NEXT
   commitJ ()
NEXT

dw_list.UPDATE ()
F_LOADINGRETRIEVE (FALSE)
st_count.VISIBLE = FALSE

RETURN 1
end function

public function integer wf_2501 ();OLEObject   lXls, lSheet

DATETIME ldt_ymd
STRING	la_siga [], la_fund_cd [], la_fund_nm [], la_mg_cd [], la_sht0ye [], ra_word []
STRING	ls_msg, ls_file, ls_temp, ls_fund_cd, ls_fund_nm, ls_mg_cd, ls_koscom_cd, ls_jm_cd, ls_jm_gr, ls_enc_acct, load_jm

INT   li_con, li_file = 0
LONG	ll, ln, ll_file, ll_sheet, lm, lm_word

ldt_ymd = dw_c.object.ymd [1]

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
      CASE ELSE
         ls_msg = "If any argument's value is NULL, ConnectToNewObject returns NULL.~r~n"
   END CHOOSE
   DESTROY lXls
   MessageBox("ERROR","엑셀 프로그램을 실행할 수 없습니다.~r~n" + ls_msg, StopSign!)
   RETURN -10
End IF

dw_list.reset ()
dw_list.enabled = TRUE

F_LOADINGRETRIEVE (TRUE)
st_count.visible = TRUE

ll_file = UPPERBOUND (ia_file)
FOR  ll = 1  TO  ll_file
   IF ll_file=1 THEN
      ls_file = is_path
   ELSE
      ls_file = is_path + '\' + ia_file [ll]
   End IF
   F_ST_COUNT (st_count, ia_file [ll] + '~r~nLOAD File : ', ll, ll_file)

   lXls.WorkBooks.OPEN (ls_file)
   lXls.Application.Visible = FALSE

   IF POS (ls_file,'#0885')>0 THEN
      // 한투(#0885) 계좌잔고
      ls_file = gaa.temp + '(' + gaa.corp_gr + ')' + STRING (ldt_ymd,'yyyymmdd') + '(#0885).csv'
      IF FileExists (ls_file) THEN FileDelete (ls_file)

      lXls.Application.Workbooks(1).Worksheets(ln).Saveas (ls_file, 6)
      la_sht0ye [UPPERBOUND (la_sht0ye) + 1] = ls_file
   ELSE
      ll_sheet = lXls.Application.Workbooks (1).worksheets.count  // Sheet의 갯수
      FOR  ln = 1  TO  ll_sheet
         lSheet = lXls.Application.Workbooks (1).worksheets (ln)
         lSheet.Activate
         ls_temp = TRIM (lSheet.name)
         IF ll_sheet=1 And lower (LEFT (ls_temp,5))='sheet' THEN
            // 파일 단위 자료처리
            lm_word = gre.rt_file (ls_file, ra_word)
            IF lm_word<4 THEN
               F_MESSAGEBOX ('ERR', "파일명 형식 '증권사명(#화면번호)_관리번호.xls' 을 확인하십시오.")
               CONTINUE
            End IF

            SELECT fund_cd
                 , fund_nm
                 , enc_acct_no
                 , mg_cd
              INTO :ls_fund_cd
                 , :ls_fund_nm
                 , :ls_enc_acct
                 , :ls_mg_cd
              FROM SZM0IA ia
             WHERE ia.corp_gr = :gaa.corp_gr
               AND ia.fund_cd = :ra_word[lm_word - 2];
            IF SQLCA.sqlcode ()=0 THEN
               ls_fund_cd  = SQLCA.getitemstring (1)
               ls_fund_nm  = SQLCA.getitemstring (2)
               ls_enc_acct = SQLCA.getitemstring (3)
               ls_mg_cd    = SQLCA.getitemstring (4)
               IF POS (ls_file,'#0717')>0 THEN
                  ls_file = gaa.temp + '(' + gaa.corp_gr + '_#0717)' + STRING (ldt_ymd,'yyyymmdd') + '(' + ls_fund_cd + ').csv'
               ELSE
                  ls_file = gaa.temp + '(' + gaa.corp_gr + ')' + STRING (ldt_ymd,'yyyymmdd') + '(' + ls_fund_cd + ').csv'
               End IF
               IF FileExists (ls_file) THEN FileDelete (ls_file)

               lXls.Application.Workbooks(1).Worksheets(1).Saveas (ls_file, 6)
               li_file ++
               la_siga [li_file]    = ls_file
               la_fund_cd [li_file] = ls_fund_cd
               la_fund_nm [li_file] = ls_fund_nm
               la_mg_cd [li_file]   = ls_mg_cd
               wf_load_status (la_fund_cd [li_file] + ' ' + la_fund_nm [li_file] + ' 엑셀 LOAD 완료...')
            ELSE
               F_MESSAGEBOX ('ERR', "파일명 형식 '증권사명(#화면번호)_관리번호.xls' 을 확인하십시오.")
               wf_load_status ('????? ' + ia_file [ll] + " : 파일명 형식 '증권사명(#화면번호)_관리번호.xls' 을 확인하십시오. ??????????????'")
            End IF
            EXIT
         ELSE
            SELECT fund_cd
                 , fund_nm
                 , enc_acct_no
                 , mg_cd
              INTO :ls_fund_cd
                 , :ls_fund_nm
                 , :ls_enc_acct
                 , :ls_mg_cd
              FROM SZM0IA ia
             WHERE ia.corp_gr = :gaa.corp_gr
               AND ia.fund_cd = :ls_temp;
            IF SQLCA.sqlcode ()=0 THEN
               ls_fund_cd  = SQLCA.getitemstring (1)
               ls_fund_nm  = SQLCA.getitemstring (2)
               ls_enc_acct = SQLCA.getitemstring (3)
               ls_mg_cd    = SQLCA.getitemstring (4)
               ls_file = gaa.temp + '(' + gaa.corp_gr + ')' + STRING (ldt_ymd,'yyyymmdd') + '(' + ls_fund_cd + ').csv'
               IF FileExists (ls_file) THEN FileDelete (ls_file)

               lXls.Application.Workbooks(1).Worksheets(ln).Saveas (ls_file, 6)
               li_file ++
               la_siga [li_file]    = ls_file
               la_fund_cd [li_file] = ls_fund_cd
               la_fund_nm [li_file] = ls_fund_nm
               la_mg_cd [li_file]   = ls_mg_cd
               wf_load_status (la_fund_cd [li_file] + ' ' + la_fund_nm [li_file] + ' 엑셀시트 LOAD 완료...')
            ELSE
               F_MESSAGEBOX ('ERR', '시트명을 관리번호로 등록해야 합니다')
               wf_load_status ('????? ' + ia_file [ll] + ' sheet name check (관리번호로 수정) ??????????????' )
            End IF
         End IF
      NEXT
   End IF
   lXls.WorkBooks(1).saved = TRUE
   lXls.WorkBooks.close ()
NEXT
lXls.Application.Quit
lXls.DisConnectObject ()

DESTROY lXls

LONG	lc [], lRow
DEC	ldc_count, ldc_qty, ldc_amt, ldc_danga, ldc_jonga, ldc_siga, ldc_trust, ldc_sonik

// 잔고 LOAD
ll_file = UPPERBOUND (la_siga)
FOR  ll = 1  TO  ll_file
   IF NOT FileExists (la_siga [ll]) THEN
      wf_load_status ('????? ' + la_siga [ll] + ' file check' )
      CONTINUE
   End IF

   dw_xlsx.reset ()
   lRow = dw_xlsx.importfile (la_siga [ll], 1)
   IF lRow<2 THEN
      wf_load_status ('????? ' + la_siga [ll] + ' data empty')
      CONTINUE
   End IF
   // 1-종류, 2-종목코드, 3-수량, 4-취득액(단가), 5-종가, 6-시가액, 7-코드포함종목명, 8-취득단가, 9-평가손익
   lc = {0,0,0,0,0,0,0,0,0}
   FOR  lm = 1  TO  20
      ls_temp = F_REPLACE (STRING (dw_xlsx.object.data [1,lm]), ' ', '')
      CHOOSE CASE ls_temp
         CASE '유가종류','유가구분','종목구분','구분'
            IF lc [1]=0 THEN lc[1] = lm
         CASE '종목번호','종목코드'
            lc[2] = lm
         CASE '보유수량','잔고수량','수량','체결잔고'
            lc[3] = lm
         CASE '매입금액','장부금액','평균매입금액'
            lc[4] = lm
         CASE '취득가격'
            lc[8] = lm
         CASE '평가가격','현재가','종가','평균단가'
            lc[5] = lm
         CASE '평가금액','주식평가금액','원화평가금액'
            lc[6] = lm
         CASE '종목명'
            lc[7] = lm
         CASE '평가손익'
            lc[9] = lm
      END CHOOSE
   NEXT
   IF POS (la_siga [ll],'#0717')>0 THEN
      lc [2] = 9  // 하나증권엑셀 종목코드 타이틀이 없음
      lc [7] = 0
   End IF

   wf_load_status (la_siga [ll] + ' load count = ' + F_N# (lRow,0,0) )

   SELECT SUM(cnt)
     INTO :ldc_count
    FROM (select COUNT(*)  AS cnt
            from SJM0JM_SIGA t1
           where t1.corp_gr = :gaa.corp_gr
             and t1.ymd     = :ldt_ymd
             and t1.fund_cd = :la_fund_cd[ll]
          UNION ALL
          select COUNT(*)  AS cnt
            from SCM0CM_SIGA t1
           where t1.corp_gr = :gaa.corp_gr
             and t1.ymd     = :ldt_ymd
             and t1.fund_cd = :la_fund_cd[ll]
          UNION ALL
          select COUNT(*)  AS cnt
            from SHM0HM_SIGA t1
           where t1.corp_gr = :gaa.corp_gr
             and t1.ymd     = :ldt_ymd
             and t1.fund_cd = :la_fund_cd[ll]
          )  t20;

   ldc_count = SQLCA.getitemnumber (1)
   IF ldc_count>0 THEN
      IF NOT gaa.admin THEN
         IF F_MESSAGEBOX ('INFO', la_fund_nm [ll] + '은(는) 이미 LOAD한 자료가 있습니다.~r~n삭제 후 재 LOAD 하시겠습니까?')=2 THEN CONTINUE
      End IF
      DELETE FROM SJM0JM_SIGA ta
       WHERE ta.corp_gr = :gaa.corp_gr
         AND ta.ymd     = :ldt_ymd
         AND ta.fund_cd = :la_fund_cd[ll];

      DELETE FROM SJM5SM_SIGA ta
       WHERE ta.corp_gr = :gaa.corp_gr
         AND ta.ymd     = :ldt_ymd
         AND ta.fund_cd = :la_fund_cd[ll];

      DELETE FROM SCM0CM_SIGA ta
       WHERE ta.corp_gr = :gaa.corp_gr
         AND ta.ymd     = :ldt_ymd
         AND ta.fund_cd = :la_fund_cd[ll];

      DELETE FROM SHM0HM_SIGA ta
       WHERE ta.corp_gr = :gaa.corp_gr
         AND ta.ymd     = :ldt_ymd
         AND ta.fund_cd = :la_fund_cd[ll];

      commitJ ()
      wf_load_status (la_fund_cd [ll] + ' ' + la_fund_nm [ll] + '님 계좌 삭제 후 재 load')
   End IF

   FOR  lm = 2  TO  lRow
      F_ST_COUNT (st_count, la_siga [ll] + '~r~nData LOAD', lm, lRow)

      IF lc [1]>0 THEN
         ls_jm_gr = TRIM (STRING (dw_xlsx.object.data [lm,lc [1]]))
      ELSE
         ls_jm_gr = ''
      End IF
      IF lc [2]>0 THEN
         load_jm = UPPER (TRIM (STRING (dw_xlsx.object.data [lm,lc [2]])))
      ELSE
         load_jm = TRIM (STRING (dw_xlsx.object.data [lm,lc [7]]))
         load_jm = MID (load_jm, LASTPOS (load_jm,'(') + 1)
         load_jm = UPPER (LEFT (load_jm, LEN (load_jm) - 1))
      End IF
      ldc_qty   = F_NUM (dw_xlsx.object.data [lm,lc [3]])
      IF lc [4]>0 THEN
         ldc_amt = F_NUM (dw_xlsx.object.data [lm,lc [4]])
      ELSE
         ldc_amt = TRUNCATE (ldc_qty * F_NUM (dw_xlsx.object.data [lm,lc [8]]), 0)
      End IF
      IF lc [8]>0 THEN
         ldc_danga = F_NUM (dw_xlsx.object.data [lm,lc [8]])
      ELSE
         ldc_danga = 0
      End IF
      ldc_jonga = F_NUM (dw_xlsx.object.data [lm,lc [5]])
      ldc_siga  = F_NUM (dw_xlsx.object.data [lm,lc [6]])
      IF lc [9]>0 THEN
         ldc_sonik = F_NUM (dw_xlsx.object.data [lm,lc [9]])
      ELSE
         ldc_sonik = 0
      End IF

      IF F_NULL (load_jm) THEN
//       wf_load_status (la_fund_cd [ll] + ' 공란 : ' + load_jm + ',' + string (ldc_amt) + ',' + string (ldc_jonga) + ',' + string (ldc_siga) )
         CONTINUE
      End IF

      ls_jm_cd = ''
      IF LEFT (load_jm,3)='KRZ' OR load_jm='KR' OR load_jm='KRW' &
                                 OR ls_jm_gr='현금' OR ls_jm_gr='신탁' OR POS (ls_jm_gr,'RP')>0 OR ls_jm_gr='발행어음' THEN

         IF load_jm='KR' OR load_jm='KRW' OR load_jm='009902' THEN
            // 예금
            SELECT jm_cd
              INTO :ls_jm_cd
              FROM SHM0HJ t1
             WHERE t1.corp_gr    = :gaa.corp_gr
               AND t1.cash_cd    = '90'
               AND t1.sanghw_ymd >= :ldt_ymd
               AND ROWNUM = 1;
            ls_jm_cd = SQLCA.getitemstring (1)
         ELSE
            // 자문사 현금은 종목별 계좌별 관리
            SELECT jm_cd
              INTO :ls_jm_cd
              FROM SHM0HJ t1
             WHERE t1.corp_gr                       = :gaa.corp_gr
               AND t1.ksd_jm_cd                     = :load_jm
               AND NVL(t1.fund_cd,:la_fund_cd[ll])  = :la_fund_cd[ll]
               AND t1.sanghw_ymd                    < :ldt_ymd;
            IF SQLCA.sqlcode ()=0 THEN ls_jm_cd = SQLCA.getitemstring (1)
         End IF
         IF F_NULL (ls_jm_cd) THEN ls_jm_cd = load_jm

         // 신탁 MMT 관리
         ldc_trust = 0
         IF ls_jm_gr='신탁' THEN ldc_trust = ldc_siga

         IF ldc_siga>0 And ldc_amt=0 THEN
            // 수시형 RP처리
            ldc_qty = ldc_siga - ldc_sonik
            ldc_amt = ldc_siga - ldc_sonik
         End IF

         INSERT  INTO SHM0HM_SIGA tt
             ( CORP_GR    /* _1- */
             , YMD        /* _2- */
             , FUND_CD    /* _3- */
             , JM_CD      /* _4- */
             , AEKM       /* _5- */
             , CHUI_AEK   /* _6- */
             , SIGA_AEK   /* _7- */
             , IP_USER    /* _8- */
             , TRUST_AEK  /* _9- */
             , IP_DT      /* _10- */
             )
         VALUES ( :gaa.corp_gr     /* _1- */
                , :ldt_ymd         /* _2- */
                , :la_fund_cd[ll]  /* _3- */
                , :ls_jm_cd        /* _4- */
                , :ldc_qty         /* _5- */
                , :ldc_amt         /* _6- */
                , :ldc_siga        /* _7- */
                , 'SIGA'           /* _8- */
                , :ldc_trust       /* _9- */
                , sysdate          /* _10- */
                );

         wf_load_status (la_fund_cd [ll] + ' 현금잔고 : ' + ls_jm_cd + F_N# (ldc_qty,20,0))

      ElseIF LEFT (load_jm,1)='A' OR LEN (load_jm)=6 OR ls_jm_gr='주식' THEN
         IF LEFT (load_jm,1)='A' THEN
            ls_koscom_cd = MID (load_jm,2)
         ELSE
            ls_koscom_cd = load_jm
         End IF

         IF LEN (ls_koscom_cd)=12 THEN
            ls_jm_cd = ls_koscom_cd

            SELECT koscom_cd
              INTO :ls_koscom_cd
              FROM SJM0JJ t1
             WHERE t1.jm_cd = :ls_jm_cd;
            IF SQLCA.sqlcode ()=0 THEN
               ls_koscom_cd = SQLCA.getitemstring (1)
            ELSE
               wf_load_status ('????? ' + ls_koscom_cd +' : 주식종목코드 확인 ??????????????')
               CONTINUE
            End IF
         ELSE
            SELECT jm_cd
              INTO :ls_jm_cd
              FROM SJM0JJ t1
             WHERE t1.koscom_cd = :ls_koscom_cd
               AND t1.danc_gb   IN ('A','C','D','G','X');
            IF SQLCA.sqlcode ()=0 THEN
               ls_jm_cd = SQLCA.getitemstring (1)
            ELSE
               wf_load_status ('????? ' + ls_koscom_cd +' : 주식단축코드 확인 ??????????????')
               CONTINUE
            End IF
         End IF

         INSERT  INTO SJM0JM_SIGA tt
             ( CORP_GR   /* _1- */
             , YMD       /* _2- */
             , FUND_CD   /* _3- */
             , JM_CD     /* _4- */
             , JUSU      /* _5- */
             , CHUI_AEK  /* _6- */
             , SIGA_AEK  /* _7- */
             , IP_USER   /* _8- */
             , IP_DT     /* _9- */
             )
         VALUES ( :gaa.corp_gr     /* _1- */
                , :ldt_ymd         /* _2- */
                , :la_fund_cd[ll]  /* _3- */
                , :ls_jm_cd        /* _4- */
                , :ldc_qty         /* _5- */
                , :ldc_amt         /* _6- */
                , :ldc_siga        /* _7- */
                , 'SIGA'           /* _8- */
                , sysdate          /* _9- */
                );

         wf_load_status (la_fund_cd [ll] + ' 주식잔고 : ' + ls_jm_cd + F_N# (ldc_qty,20,0))

         // 주식종가
         SELECT close
           INTO :ldc_jonga
           FROM SJT0TG t1
          WHERE t1.corp_gr   = :gaa.corp_gr
            AND t1.ymd       = :ldt_ymd
            AND t1.koscom_cd = :ls_koscom_cd;
         IF SQLCA.sqlcode ()<>0 THEN
            INSERT  INTO SJT0TG tt
                ( corp_gr    /* _1- */
                , ymd        /* _2- */
                , koscom_cd  /* _3- */
                , close      /* _4- */
					 , mod_dt
                )
            VALUES ( :gaa.corp_gr   /* _1- */
                   , :ldt_ymd       /* _2- */
                   , :ls_koscom_cd  /* _3- */
                   , :ldc_jonga     /* _4- */
						 , sysdate
                   );
         ELSE
            UPDATE SJT0TG tt
               SET close = :ldc_jonga
             WHERE corp_gr   = :gaa.corp_gr
               AND ymd       = :ldt_ymd
               AND koscom_cd = :ls_koscom_cd;
         End IF
      ElseIF LEFT (load_jm,3)='KR5' THEN
         // 펀드
         ls_jm_cd = load_jm

         SELECT jm_cd
           INTO :ls_jm_cd
           FROM SJM5SM_SIGA t1
          WHERE t1.corp_gr = :gaa.corp_gr
            AND t1.ymd     = :ldt_ymd
            AND t1.fund_cd = :la_fund_cd[ll]
            AND t1.jm_cd   = :ls_jm_cd;
         IF SQLCA.sqlcode ()=0 THEN
            UPDATE SJM5SM_SIGA t1
               SET jwa       = NVL(jwa,0) + :ldc_qty
                 , chui_aek  = NVL(chui_aek,0) + :ldc_amt
                 , siga_aek  = NVL(siga_aek,0) + :ldc_siga
                 , ip_dt     = sysdate
             WHERE t1.corp_gr = :gaa.corp_gr
               AND t1.ymd     = :ldt_ymd
               AND t1.fund_cd = :la_fund_cd[ll]
               AND t1.jm_cd   = :ls_jm_cd;
         ELSE
            INSERT  INTO SJM5SM_SIGA tt
                ( CORP_GR   /* _1- */
                , YMD       /* _2- */
                , FUND_CD   /* _3- */
                , JM_CD     /* _4- */
                , JWA       /* _5- */
                , CHUI_AEK  /* _6- */
                , SIGA_AEK  /* _7- */
                , IP_USER   /* _8- */
                , IP_DT     /* _9- */
                )
            VALUES ( :gaa.corp_gr     /* _1- */
                   , :ldt_ymd         /* _2- */
                   , :la_fund_cd[ll]  /* _3- */
                   , :ls_jm_cd        /* _4- */
                   , :ldc_qty         /* _5- */
                   , :ldc_amt         /* _6- */
                   , :ldc_siga        /* _7- */
                   , 'SIGA'           /* _8- */
                   , sysdate          /* _9- */
                   );
         End IF
         wf_load_status (la_fund_cd [ll] + ' 펀드잔고 : ' + ls_jm_cd + F_N# (ldc_qty,20,0))
      ELSE
         IF LEFT (load_jm,1)='B' THEN
            // 채권
            SELECT jm_cd
              INTO :ls_jm_cd
              FROM SCM0CJ t1
             WHERE t1.corp_gr = :gaa.corp_gr
               AND t1.jm_cd   LIKE '%'||SUBSTR(:load_jm,2) ||'%'
               AND ROWNUM = 1;

            ls_jm_cd = SQLCA.getitemstring (1)
         ELSE
            ls_jm_cd = load_jm
         End IF

         // 액면단위
         CHOOSE CASE la_mg_cd [ll]
            CASE '00016'  // 하나증권
               ldc_qty = ldc_qty * 1
            CASE '00003'   // 한투(매입금액 존재)
               ldc_qty = ldc_qty * 1
            CASE '00008','00002'  // 유진,신한
               ldc_qty = ldc_qty * 1000
            CASE '00020'   // 미래에셋
               ldc_qty = ldc_qty * 1
               ldc_amt = ldc_qty * ldc_danga / 10000  // 매입금액이 없는경우
         END CHOOSE

         SELECT jm_cd
           INTO :ls_jm_cd
           FROM SCM0CM_SIGA t1
          WHERE t1.corp_gr  = :gaa.corp_gr
            AND t1.ymd      = :ldt_ymd
            AND t1.fund_cd  = :la_fund_cd[ll]
            AND t1.jm_cd    = :ls_jm_cd
            AND t1.buy_date = '%';
         IF SQLCA.sqlcode ()=0 THEN
            UPDATE SCM0CM_SIGA t1
               SET aekm      = NVL(aekm,0) + :ldc_qty
                 , chui_aek  = NVL(chui_aek,0) + :ldc_amt
                 , siga_aek  = NVL(siga_aek,0) + :ldc_siga
                 , ip_dt     = sysdate
             WHERE t1.corp_gr  = :gaa.corp_gr
               AND t1.ymd      = :ldt_ymd
               AND t1.fund_cd  = :la_fund_cd[ll]
               AND t1.jm_cd    = :ls_jm_cd
               AND t1.buy_date = '%';
         ELSE
            INSERT  INTO SCM0CM_SIGA tt
                ( CORP_GR   /* _1- */
                , YMD       /* _2- */
                , FUND_CD   /* _3- */
                , JM_CD     /* _4- */
                , BUY_DATE  /* _5- */
                , AEKM      /* _6- */
                , CHUI_AEK  /* _7- */
                , SIGA_AEK  /* _8- */
                , IP_USER   /* _9- */
                , IP_DT     /* _10- */
                )
            VALUES ( :gaa.corp_gr     /* _1- */
                   , :ldt_ymd         /* _2- */
                   , :la_fund_cd[ll]  /* _3- */
                   , :ls_jm_cd        /* _4- */
                   , '%'              /* _5- */
                   , :ldc_qty         /* _6- */
                   , :ldc_amt         /* _7- */
                   , :ldc_siga        /* _8- */
                   , 'SIGA'           /* _9- */
                   , sysdate          /* _10- */
                   );
         End IF
         wf_load_status (la_fund_cd [ll] + ' 채권잔고 : ' + ls_jm_cd + F_N# (ldc_qty,20,0))
      End IF
   NEXT
   commitJ ()
NEXT

STRING	ls_acct_no, ls_tr_co_cd
DEC	ldc_map []

// 예수금 LOAD(MAP자료)
ll_file = UPPERBOUND (la_sht0ye)
FOR  ll = 1  TO  ll_file
   IF NOT FileExists (la_sht0ye [ll]) THEN
      wf_load_status ('????? ' + la_sht0ye [ll] + ' file check' )
      CONTINUE
   End IF

   dw_xlsx.reset ()
   lRow = dw_xlsx.importfile (la_sht0ye [ll], 1)
   IF lRow<2 THEN
      wf_load_status ('????? ' + la_sht0ye [ll] + ' data empty')
      CONTINUE
   End IF
   // 1-계좌번호, 2-계약금, 3-순자산금액, 4-예수금, 5-D2예수금, 6-RP금액, 7-주식평가금액, 8-채권평가금액, 9-펀드평가금액, 10-ELS평가금액, 11-파생상품평가금액, 12-기타금융상품평가금액, 13-권리평가금액, 14-투자자산평가총액, 15-순매입금액
   lc = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
   FOR  lm = 1  TO  25
      ls_temp = F_REPLACE (STRING (dw_xlsx.object.data [1,lm]), ' ', '')
      CHOOSE CASE ls_temp
         CASE '계좌번호'
            lc[1] = lm
         CASE '계약금'
            lc[2] = lm
         CASE '순자산금액'
            lc[3] = lm
         CASE '예수금'
            lc[4] = lm
         CASE 'D2예수금'
            lc[5] = lm
         CASE 'RP금액'
            lc[6] = lm
         CASE '주식평가금액'
            lc[7] = lm
         CASE '채권평가금액'
            lc[8] = lm
         CASE '펀드평가금액'
            lc[9] = lm
         CASE 'ELS평가금액'
            lc[10] = lm
         CASE '파생상품평가금액'
            lc[11] = lm
         CASE '기타금융상품평가금액'
            lc[12] = lm
         CASE '권리평가금액'
            lc[13] = lm
         CASE '투자자산평가총액'
            lc[14] = lm
         CASE '순매입금액'
            lc[15] = lm
      END CHOOSE
   NEXT
   wf_load_status (la_sht0ye [ll] + ' load count = ' + F_N# (lRow,0,0) )
   FOR  lm = 2  TO  lRow
      F_ST_COUNT (st_count, la_sht0ye [ll] + '~r~nData LOAD', lm, lRow)

      ls_acct_no = F_REPLACE (TRIM (STRING (dw_xlsx.object.data [lm, lc [1]])),'-','')

      SELECT fund_cd
           , mg_cd
           , enc_acct_no
        INTO :ls_fund_cd
           , :ls_tr_co_cd
           , :ls_enc_acct
        FROM SZM0IA ia
       WHERE ia.corp_gr = :gaa.corp_gr
         AND REPLACE(TO_DECRYPTS(ia.enc_acct_no), '-', '')  = :ls_acct_no;
      IF SQLCA.sqlcode ()=0 THEN
         ls_fund_cd  = SQLCA.getitemstring (1)
         ls_tr_co_cd = SQLCA.getitemstring (2)
         ls_enc_acct = SQLCA.getitemstring (3)
      ELSE
         IF F_NOTNULL (ls_acct_no) THEN
            F_MESSAGEBOX ('ERR', '계좌번호를 확인 하십시오')
            wf_load_status ('????? ' + la_sht0ye [ll] + ' : ' + ls_acct_no + ' 계좌번호 확인 ???????????????????')
         End IF
         CONTINUE
      End IF

      FOR  ln = 1  TO  15
         ldc_map [ln] = F_NUM (dw_xlsx.object.data [lm, lc [ln]])
      NEXT

      SELECT fund_cd
        INTO :ls_fund_cd
        FROM SHT0YE t1
       WHERE t1.corp_gr     = :gaa.corp_gr
         AND t1.tr_ymd      = :ldt_ymd
         AND t1.fund_cd     = :ls_fund_cd
         AND t1.tr_co_cd    = :ls_tr_co_cd
         AND t1.enc_acct_no = :ls_enc_acct;

      IF SQLCA.sqlcode ()=0 THEN
         UPDATE SHT0YE t1
            SET T0_AEK     = :ldc_map[4]
              , T2_AEK     = :ldc_map[5]
              , STOCK_AEK  = :ldc_map[7]
              , BOND_AEK   = :ldc_map[8]
              , RP_AEK     = :ldc_map[9]
              , TOT_AEK    = :ldc_map[14]
              , bigo       = 'w_sht0ye'
          WHERE t1.corp_gr     = :gaa.corp_gr
            AND t1.tr_ymd      = :ldt_ymd
            AND t1.fund_cd     = :ls_fund_cd
            AND t1.tr_co_cd    = :ls_tr_co_cd
            AND t1.enc_acct_no = :ls_enc_acct;
      ELSE
         INSERT  INTO SHT0YE tt
             ( CORP_GR      /* _1- */
             , TR_YMD       /* _2- */
             , FUND_CD      /* _3- */
             , TR_CO_CD     /* _4- */
             , ENC_ACCT_NO  /* _5- */
             , T0_AEK       /* _6- */
             , T1_AEK       /* _7- */
             , T2_AEK       /* _8- */
             , STOCK_AEK    /* _9- */
             , BOND_AEK     /* _10- */
             , RP_AEK       /* _11- */
             , CASH_AEK     /* _12- */
             , TOT_AEK      /* _13- */
             , BIGO         /* _14- */
             , LOAD_DT      /* _15- */
             , FUND_AEK     /* _16- */
             )
         VALUES ( :gaa.corp_gr  /* _1- */
                , :ldt_ymd      /* _2- */
                , :ls_fund_cd   /* _3- */
                , :ls_tr_co_cd  /* _4- */
                , :ls_enc_acct  /* _5- */
                , :ldc_map[4]   /* _6- */
                , 0             /* _7- */
                , :ldc_map[5]   /* _8- */
                , :ldc_map[7]   /* _9- */
                , :ldc_map[8]   /* _10- */
                , :ldc_map[9]   /* _11- */
                , 0             /* _12- */
                , :ldc_map[14]  /* _13- */
                , 'w_sht0ye'    /* _14- */
                , sysdate       /* _15- */
                , 0             /* _16- */
                );
      End IF
   NEXT
   commitJ ()
NEXT

dw_list.update ()
F_LOADINGRETRIEVE (FALSE)
st_count.visible = FALSE

RETURN 1
end function

on w_ja036k.create
int iCurrent
call super::create
this.dw_xlsx=create dw_xlsx
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_status=create cb_status
this.cb_tr=create cb_tr
this.cb_siga=create cb_siga
this.st_1=create st_1
this.lb_list=create lb_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_xlsx
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_status
this.Control[iCurrent+5]=this.cb_tr
this.Control[iCurrent+6]=this.cb_siga
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.lb_list
end on

on w_ja036k.destroy
call super::destroy
destroy(this.dw_xlsx)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_status)
destroy(this.cb_tr)
destroy(this.cb_siga)
destroy(this.st_1)
destroy(this.lb_list)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate

st_1.text  = '             잔고화면   체결화면~r~n'
st_1.text += '삼성증권  #      #3425~r~n'
st_1.text += '            #          #~r~n'

end event

type lb_dirlist from wt_list`lb_dirlist within w_ja036k
end type

type ln_templeft from wt_list`ln_templeft within w_ja036k
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja036k
end type

type ln_temptop from wt_list`ln_temptop within w_ja036k
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja036k
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja036k
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja036k
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja036k
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja036k
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja036k
end type

type ln_tempright from wt_list`ln_tempright within w_ja036k
end type

type uo_navi from wt_list`uo_navi within w_ja036k
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja036k
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja036k
end type

type st_top_rect from wt_list`st_top_rect within w_ja036k
end type

type p_close from wt_list`p_close within w_ja036k
end type

type p_excel from wt_list`p_excel within w_ja036k
end type

type p_print from wt_list`p_print within w_ja036k
end type

type p_delete from wt_list`p_delete within w_ja036k
end type

type p_update from wt_list`p_update within w_ja036k
end type

type p_input from wt_list`p_input within w_ja036k
end type

type p_retrieve from wt_list`p_retrieve within w_ja036k
end type

type p_clear from wt_list`p_clear within w_ja036k
end type

type p_copy from wt_list`p_copy within w_ja036k
end type

type dw_c from wt_list`dw_c within w_ja036k
string title = "LOAD기준일"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_ja036k
end type

type st_count from wt_list`st_count within w_ja036k
end type

type dw_list from wt_list`dw_list within w_ja036k
integer y = 956
integer height = 1808
string dataobject = "d_ja020n"
string setlist4rowpointcolor = "load_ok=1=e"
string is_resize_column = "load_naye"
end type

type dw_xlsx from u_dw within w_ja036k
boolean visible = false
integer x = 1742
integer y = 956
integer width = 3689
integer height = 1892
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_xlsx"
end type

type cb_1 from pf_u_commandbutton within w_ja036k
integer x = 146
integer y = 348
integer width = 494
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "잔고엑셀선택"
end type

event clicked;call super::clicked;f_messageBox ('INFO', '해외 유가증권잔고 엑셀자료 LOAD 준비중 입니다.')
RETURN

LONG	ll

is_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
IF GetFileOpenName ("해외 유가증권잔고 엑셀파일 선택", is_path, ia_file, "HTS화면", " 잔고 HTS 자료,*#2885*.*;*#0717*.*;*#1573*.*;*#0885*.*;*#1716*.*;*#6466*.*, 엑셀,*.xls;*.xlsx;*.csv", is_path,18)<>1 THEN RETURN
lb_list.reset ()
IF	UPPERBOUND (ia_file)=1	Then
	SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (is_path, LASTPOS (is_path,'\')))
	lb_list.additem (is_path)
Else
	SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir',is_path)
	FOR  ll = 1  TO  UPPERBOUND (ia_file)
		lb_list.additem (is_path + '\' + ia_file [ll])
	NEXT
End IF

messagebox('알림', '실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
gfp.killprocess ('excel.exe')

CHOOSE CASE gaa.corp_gr
	CASE '2501'
		wf_2501 ()
END CHOOSE

f_messageBox ('INFO', '해외 유가증권잔고 엑셀자료 LOAD를 완료했습니다.~r~n자문일임에서 원장생성처리 후 고객별 자산현황을 확인하십시오.')

ChangeDirectory (gnv_vari.basepath)
end event

type cb_2 from pf_u_commandbutton within w_ja036k
integer x = 146
integer y = 468
integer width = 494
integer height = 112
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "체결엑셀선택"
end type

event clicked;call super::clicked;LONG	ll

is_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
IF GetFileOpenName ("해외 유가증권 매매 엑셀파일 선택", is_path, ia_file, "HTS화면", " 매매 HTS 자료,*3425*.*;0, 엑셀,*.xls;*.xlsx;*.csv", is_path,18)<>1 THEN RETURN
lb_list.reset ()
IF	UPPERBOUND (ia_file)=1	Then
	SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (is_path, LASTPOS (is_path,'\')))
	lb_list.additem (is_path)
Else
	SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', is_path)
	FOR  ll = 1  TO  UPPERBOUND (ia_file)
		lb_list.additem (is_path + '\' + ia_file [ll])
	NEXT
End IF

idt_sysdate = f_sysdate ('')

messagebox('알림', '실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
gfp.killprocess ('excel.exe')

CHOOSE CASE gaa.corp_gr
	CASE '2501'
		wf_2501_meme ()
END CHOOSE

f_messageBox ('INFO', '해외 유가증권 매매 엑셀자료 LOAD를 완료했습니다.~r~n자문일임에서 원장생성처리 후 고객별 자산현황을 확인하십시오.')

ChangeDirectory (gnv_vari.basepath)
end event

type cb_status from pf_u_commandbutton within w_ja036k
integer x = 146
integer y = 664
integer width = 494
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer weight = 400
string text = "처리결과조회"
end type

event clicked;call super::clicked;dw_list.uf_dataobject ('d_ja020n', FALSE)
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type cb_tr from pf_u_commandbutton within w_ja036k
integer x = 649
integer y = 468
integer width = 494
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "LOAD체결내역"
end type

event clicked;call super::clicked;dw_list.uf_dataobject ('d_ja036k_tr', FALSE)
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type cb_siga from pf_u_commandbutton within w_ja036k
integer x = 649
integer y = 348
integer width = 494
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "LOAD잔고내역"
end type

event clicked;call super::clicked;dw_list.uf_dataobject ('d_ja036k_siga', FALSE)
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type st_1 from pf_u_statictext within w_ja036k
integer x = 1198
integer y = 348
integer width = 1070
integer height = 584
boolean bringtotop = true
end type

type lb_list from pf_u_listbox within w_ja036k
integer x = 2281
integer y = 348
integer width = 3150
integer height = 584
integer taborder = 50
boolean bringtotop = true
boolean hscrollbar = true
boolean sorted = false
boolean scaletoright = true
end type

