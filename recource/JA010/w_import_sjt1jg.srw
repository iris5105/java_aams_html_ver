forward
global type w_import_sjt1jg from w_response
end type
type st_count from pf_u_statictext within w_import_sjt1jg
end type
type btn_load from pf_u_commandbutton within w_import_sjt1jg
end type
end forward

global type w_import_sjt1jg from w_response
integer width = 7365
integer height = 3416
boolean center = true
boolean eb_direct_retrieve = true
st_count st_count
btn_load btn_load
end type
global w_import_sjt1jg w_import_sjt1jg

type variables
ads_jTier	ids_fund, ids_jj

str_parameter  sp_in, sp_out

BOOLEAN	ib_next = false

STRING	is_path, ia_name [], is_tr_co_cd, is_xls

DateTime	idt_tr_ymd

LONG	il_fund, il_jj
end variables

forward prototypes
public function string wf_load ()
public function string wf_2203 ()
public function string wf_2203_meme ()
public function string wf_f ()
end prototypes

public function string wf_load ();LONG	lr, ll_rowcount, ll_row = 0, lFIND

STRING	ls_fund_err = '', ls_jj = ''
STRING	ls_tr_cd, ls_fund_cd, ls_koscom_cd, ls_koscom = 'not', ls_jm_cd = '', ls_danc, ls_acct_no, ls_acct = 'not', ls_enc_acct_no

BOOLEAN	lb

DEC	ldc_offer_no, ldc_tr_jusu, ldc_tr_aek, ldc_susu, ldc_tax

dw_list.setredraw (false)
ll_rowcount = dw_list.rowcount ()
FOR  lr = ll_rowcount  TO  1  STEP -1
	CHOOSE CASE is_tr_co_cd
		CASE '00010'   // NH
			IF	lr<=2 THEN EXIT
		CASE '00020','00030','00056'  // 미래, 신영, 하나
			IF	lr<=1 THEN EXIT
	END CHOOSE
	ll_row ++
   f_st_count (st_count, sp_in.str [2] + IIF (f_null (is_xls), '', '(' + is_xls + ')') + '~r~n체결내역 LOAD', ll_row, ll_rowcount)

   CHOOSE CASE is_tr_co_cd
      CASE '00010'   // NH
			IF TRIM (dw_list.object.c_09 [2])='수량'	Then  // format 1
            IF f_num (dw_list.object.c_09 [lr])=0	Then  // 체결수량 0
					dw_list.deleterow (lr)
               CONTINUE
            End IF
            ls_acct_no   = dw_list.object.c_13 [lr]
            ls_fund_cd   = ''
            ls_koscom_cd = dw_list.object.c_05 [lr]
            ls_jm_cd     = ''

         Else  // format 2
            IF f_num (dw_list.object.c_10 [lr])=0	Then  // 체결수량 0
					dw_list.deleterow (lr)
               CONTINUE
            End IF
            ls_acct_no   = 'AAAAAAAAAAA='
            ls_fund_cd   = 'fund'
            ls_koscom_cd = dw_list.object.c_05 [lr]
            ls_jm_cd     = ''
         End IF

      CASE '00020'   // 미래
         IF dw_list.object.c_01 [1]='종목코드'	Then  // 1619 미래증권(법인일임)
            IF f_num (dw_list.object.c_04 [lr])=0	Then  // 체결수량 0
					dw_list.deleterow (lr)
               CONTINUE
            End IF
            ls_acct_no   = 'AAAAAAAAAAA='
            ls_fund_cd   = '1619'
            ls_koscom_cd = RIGHT ('00000' + TRIM(dw_list.object.c_01 [lr]),6)
            ls_jm_cd     = ''
         Else
            IF f_num (dw_list.object.c_12 [lr])=0	Then  // 체결수량 0
					dw_list.deleterow (lr)
               CONTINUE
            End IF
            ls_acct_no = dw_list.object.c_04 [lr]
            ls_jm_cd   = TRIM(dw_list.object.c_06 [lr])

				lFIND = ids_jj.FIND ("#1='" + ls_jm_cd + "'", 1, il_jj)
				IF	lFIND=0	Then
               dw_list.object.c_19 [lr] = '(종목확인)'
               ls_jj = '등록되지 않은 종목이 있습니다. 엑셀 시트를 확인하십시오.'
               ls_koscom_cd = ''
               ls_jm_cd = ''
               ls_danc = ''
               lb = FALSE
            Else
               ls_koscom_cd = ids_jj.getitemstring (lFIND, 2)
               ls_jm_cd     = ids_jj.getitemstring (lFIND, 3)
               ls_danc      = ids_jj.getitemstring (lFIND, 4)
               lb = TRUE
            End IF
         End IF

      CASE '00030'   // 신영
         IF f_num (dw_list.object.c_09 [lr])=0 OR POS (dw_list.object.c_06 [lr],'정정')>0	Then  // 체결수량 0
				dw_list.deleterow (lr)
            CONTINUE
         End IF
         ls_acct_no   = dw_list.object.c_03 [lr]
         ls_fund_cd   = ''
         ls_koscom_cd = dw_list.object.c_01 [lr]
         ls_jm_cd     = ''

      CASE '00056'   // 하나
			IF f_num (dw_list.object.c_07 [lr])=0	Then  // 체결수량 0
				dw_list.deleterow (lr)
				CONTINUE
			End IF
			ls_acct_no   = dw_list.object.c_01 [lr]
			ls_jm_cd     = ''
			ls_koscom_cd = MID (TRIM(dw_list.object.c_04 [lr]),2)
   END CHOOSE

	lFIND = ids_fund.FIND ("#1='" + f_replace (ls_acct_no,'-','') + "'", 1, il_fund)
	IF	lFIND=0	Then
		CHOOSE CASE is_tr_co_cd
			CASE '00010'   // NH
				dw_list.object.c_15 [lr] = '(계좌확인)'
			CASE '00020'   // 미래
				dw_list.object.c_18 [lr] = '(계좌확인)'
			CASE '00030'   // 신영
				dw_list.object.c_18 [lr] = '(계좌확인)'
			CASE '00056'   // 하나
				dw_list.object.c_13 [lr] = '(계좌확인)'
		END CHOOSE
		ls_fund_err = '등록되지 않거나 해지처리된 계좌가 있습니다.~r~n엑셀 시트를 확인하십시오.'
		CONTINUE
	End IF

	ls_fund_cd     = ids_fund.getitemstring (lFIND, 2)
	ls_enc_acct_no = ids_fund.getitemstring (lFIND, 3)

	IF f_null (ls_jm_cd) Then
		lFIND = ids_jj.FIND ("#2='" + ls_koscom_cd + "'", 1, il_jj)
		IF	lFIND=0	Then
			CHOOSE CASE is_tr_co_cd
				CASE '00010'   // NH
					dw_list.object.c_16 [lr] = '(종목확인)'
				CASE '00020'   // 미래
					dw_list.object.c_11 [lr] = '(종목확인)'
				CASE '00030'   // 신영
					dw_list.object.c_18 [lr] = '(종목확인)'
				CASE '00056'   // 하나
					dw_list.object.c_13 [lr] = '(종목확인)'
			END CHOOSE
			ls_jj = '등록되지 않은 종목이 있습니다.~r~n엑셀 시트를 확인하십시오.'
			ls_koscom_cd = ''
			ls_jm_cd     = ''
			ls_danc      = ''
			lb = FALSE
		Else
			ls_jm_cd = ids_jj.getitemstring (lFIND, 3)
			ls_danc  = ids_jj.getitemstring (lFIND, 4)
			lb = TRUE
		End IF
	End IF

   CHOOSE CASE is_tr_co_cd
      CASE '00010'   // NH
         IF f_null (dw_list.object.c_05 [lr]) THEN CONTINUE
         IF TRIM (dw_list.object.c_09 [2])='수량'	Then  // format 1
            ldc_offer_no = dec (dw_list.object.c_01 [lr])
            ls_tr_cd     = IIF (POS (dw_list.object.c_03 [lr],'매수')>0,'J','K')
            ldc_tr_jusu  = dec (dw_list.object.c_09 [lr])
            ldc_tr_aek   = dec (dw_list.object.c_09 [lr]) * dec (dw_list.object.c_10 [lr])

         Else  // format 2
            ldc_offer_no = dec (dw_list.object.c_01 [lr])
            ls_tr_cd     = IIF (POS (dw_list.object.c_03 [lr],'매수')>0,'J','K')
            ldc_tr_jusu  = dec (dw_list.object.c_10 [lr])
            ldc_tr_aek   = dec (dw_list.object.c_10 [lr]) * dec (dw_list.object.c_11 [lr])
         End IF

      CASE '00020'   // 미래
         IF TRIM (dw_list.object.c_01 [1])='종목코드'	Then  // 1619 미래증권(법인일임)
            ldc_offer_no = lr
            ls_tr_cd     = IIF (POS (dw_list.object.c_03 [lr],'매수')>0,'J','K')
            ldc_tr_jusu  = dec (dw_list.object.c_04 [lr])
            ldc_tr_aek   = dec (dw_list.object.c_07 [lr])
            ldc_susu     = dec (dw_list.object.c_09 [lr])
            ldc_tax      = dec (dw_list.object.c_08 [lr])
         Else
            ldc_offer_no = dec (dw_list.object.c_02 [lr])
            ls_tr_cd     = IIF (POS (dw_list.object.c_07 [lr],'매수')>0,'J','K')
            ldc_tr_jusu  = dec (dw_list.object.c_12 [lr])
            ldc_tr_aek   = dec (dw_list.object.c_12 [lr]) * dec (dw_list.object.c_13 [lr])
         End IF

      CASE '00030'   // 신영
         ldc_offer_no = dec (dw_list.object.c_05 [lr])
         ls_tr_cd     = IIF (POS (dw_list.object.c_06 [lr],'매수')>0 OR POS (dw_list.object.c_06 [lr],'정정')>0,'J','K')
         ldc_tr_jusu  = dec (dw_list.object.c_09 [lr])
         ldc_tr_aek   = (f_num (dw_list.object.c_11 [lr]) + f_num (dw_list.object.c_12 [lr])) * dec (dw_list.object.c_09 [lr])

      CASE '00056'   // 하나
         ldc_offer_no = lr
         ls_tr_cd     = IIF (POS (dw_list.object.c_06 [lr],'매수')>0 OR POS (dw_list.object.c_06 [lr],'정정')>0,'J','K')
         ldc_tr_jusu  = dec (dw_list.object.c_07 [lr])
         ldc_tr_aek   = dec (dw_list.object.c_09 [lr])
         ldc_susu     = dec (dw_list.object.c_10 [lr])
         ldc_tax      = dec (dw_list.object.c_11 [lr])
   END CHOOSE

	IF	lb	Then
		sp_out.long [1] ++
		sp_out.str [sp_out.long [1]] = gaa.corp_gr + '~t' + string (idt_tr_ymd,'yyyy.mm.dd') + '~t' + ls_tr_cd + '~t' + is_tr_co_cd + '~t' + string (ldc_offer_no) &
																 + '~t' + ls_enc_acct_no + '~t' + ls_jm_cd + '~t' + ls_koscom_cd + '~t' + string (ldc_tr_jusu) &
																 + '~t' + string (ldc_tr_aek) + '~t' + ls_fund_cd + '~t' + '' + '~t' + '' + '~t' + ls_danc &
																 + '~t' + string (ldc_susu) + '~t' + string (ldc_tax) + '~t' + ls_acct_no + '~t' + f_sysdate_str ('yyyy.mm.dd')
		dw_list.deleterow (lr)
		yield ()
	End IF
NEXT
dw_list.setredraw (true)
f_st_count (st_count, sp_in.str [2] + '~r~n체결내역 LOAD : ', ll_rowcount, ll_rowcount)

RETURN	ls_fund_err + ls_jj
end function

public function string wf_2203 ();// 잔고load

LONG	lr = 1, ll_count, lFIND

STRING	ls_fund_cd, ls_jm_nm = '', ls_koscom_cd, ls_jm_cd = '', ls_danc, ls_acct_no, ls_enc_acct_no

DEC	ldc_offer_no, ldc_jusu, ldc_aek

dw_list.setredraw (false)
ll_count = dw_list.rowcount ()
CHOOSE CASE is_tr_co_cd
	CASE '00002'   // 신한금투
		lr = 21
		ls_acct_no = f_replace (dw_list.object.c_10 [6],'***','011')
	CASE '00021'   // 한화
		ls_acct_no = '500-662563-11'
   CASE '00030'   // 삼성
      ls_acct_no = '7132428916-01'
END CHOOSE

DO WHILE TRUE
   f_st_count (st_count, sp_in.str [2] + IIF (f_null (is_xls), '', '(' + is_xls + ')') + '~r~n체결내역 LOAD : ', lr, ll_count)

   CHOOSE CASE is_tr_co_cd
      CASE '00002'
			lr ++
			IF	lr>ll_count THEN EXIT
			IF LEFT(dw_list.object.c_02 [lr],1)<>'A' THEN CONTINUE
			
			ls_fund_cd   = ''
			ls_koscom_cd = MID (dw_list.object.c_02 [lr],2,6)
			ls_jm_cd     = ''

			ldc_offer_no = lr
			ldc_jusu  = f_num (dw_list.object.c_20 [lr])
			ldc_aek   = f_num (dw_list.object.c_35 [lr]) - f_num (dw_list.object.c_29 [lr])

      CASE '00010'
			lr ++
			IF	lr>ll_count THEN EXIT
			IF f_num (dw_list.object.c_05 [lr])=0 THEN CONTINUE
			
			ls_acct_no   = TRIM (dw_list.object.c_01 [lr])
			ls_fund_cd   = ''
			ls_jm_nm     = dw_list.object.c_04 [lr]
			ls_koscom_cd = ''
			ls_jm_cd     = ''
			IF	LEFT (ls_jm_nm,1)='A'	Then
				ls_koscom_cd = MID (ls_jm_nm,2)
				ls_jm_nm = ''
			End IF

			ldc_offer_no = lr
			ldc_jusu = f_num (dw_list.object.c_05 [lr])
			ldc_aek  = f_num (dw_list.object.c_06 [lr])

      CASE '00021'
			lr ++
			IF	lr>ll_count THEN EXIT
			IF f_num (dw_list.object.c_03 [lr])=0 THEN CONTINUE

			ls_fund_cd   = ''
			ls_koscom_cd = MID (dw_list.object.c_01 [lr],2)
			ls_jm_cd     = ''

			ldc_offer_no = lr
			ldc_jusu = f_num (dw_list.object.c_03 [lr])
			ldc_aek  = f_num (dw_list.object.c_06 [lr])

      CASE '00030'
			lr ++
			IF	lr>ll_count THEN EXIT
			IF f_num (dw_list.object.c_03 [lr])=0 THEN CONTINUE

			ls_fund_cd   = ''
			ls_koscom_cd = MID (dw_list.object.c_01 [lr],2)
			ls_jm_cd     = ''

			ldc_offer_no = lr
			ldc_jusu = f_num (dw_list.object.c_03 [lr])
			ldc_aek  = f_num (dw_list.object.c_12 [lr])
	END CHOOSE

	lFIND = ids_fund.FIND ("#1='" + f_replace (ls_acct_no,'-','') + "'", 1, il_fund)
	IF	lFIND=0 THEN CONTINUE

	ls_fund_cd     = ids_fund.getitemstring (lFIND, 2)
	ls_enc_acct_no = ids_fund.getitemstring (lFIND, 3)

	IF f_null (ls_jm_cd) Then
		IF	f_null (ls_koscom_cd)	Then
			lFIND = ids_jj.FIND ("#1='" + ls_jm_nm + "'", 1, il_jj)
		Else
			lFIND = ids_jj.FIND ("#2='" + ls_koscom_cd + "'", 1, il_jj)
		End IF
		IF	lFIND=0 THEN CONTINUE
		ls_koscom_cd = ids_jj.getitemstring (lFIND, 2)
		ls_jm_cd     = ids_jj.getitemstring (lFIND, 3)
		ls_danc      = ids_jj.getitemstring (lFIND, 4)
	End IF

   CHOOSE CASE is_tr_co_cd
      CASE '00002'
			dw_list.object.c_02 [lr] = 'OK'
      CASE '00010'
			dw_list.object.c_03 [lr] = 'OK'
      CASE '00021'
			dw_list.object.c_02 [lr] = 'OK'
      CASE '00030'
			dw_list.object.c_02 [lr] = 'OK'
	END CHOOSE

	sp_out.long [1] ++
	sp_out.str [sp_out.long [1]] = gaa.corp_gr + '~t' + string (idt_tr_ymd,'yyyy.mm.dd') + '~tF~t' + is_tr_co_cd + '~t' + string (ldc_offer_no) &
															 + '~t' + ls_enc_acct_no + '~t' + ls_jm_cd + '~t' + ls_koscom_cd + '~t' + string (ldc_jusu) &
															 + '~t' + string (ldc_aek) + '~t' + ls_fund_cd + '~t' + '' + '~t' + '' + '~t' + ls_danc &
															 + '~t0~t0~t' + ls_acct_no + '~t' + f_sysdate_str ('yyyy.mm.dd')
LOOP
dw_list.setredraw (true)

f_st_count (st_count, sp_in.str [2] + '~r~n체결내역 LOAD(' + string (sp_out.long [1]) + '건) : ', ll_count, ll_count)

RETURN ''
end function

public function string wf_2203_meme ();// 매매load

LONG	lr, ll_rowcount, lFIND

STRING	ls_tr_ymd, ls_tr_cd, ls_fund_cd = '', ls_koscom_cd, ls_jm_nm, ls_jm_cd = '', ls_danc, ls_acct_no, ls_enc_acct_no
STRING	la []

DEC	ldc_offer_no, ldc_tr_jusu, ldc_tr_aek, ldc_susu, ldc_tax

ls_tr_ymd = STRING (idt_tr_ymd, 'yyyy.mm.dd')

dw_list.SETREDRAW (FALSE)
ll_rowcount = dw_list.ROWCOUNT ()
CHOOSE CASE is_tr_co_cd
   CASE '00002'   // 신금투
      lr         = 1
      ls_acct_no = RIGHT (ia_name [1], 11)
      ls_acct_no = LEFT (ls_acct_no, 6)

      SELECT fund_cd
           , to_decrypts (enc_acct_no)
        INTO :ls_fund_cd
           , :ls_acct_no
        FROM SZM0IA t1
       WHERE t1.CORP_GR                = :gaa.CORP_GR
         AND to_decrypts(enc_acct_no)  LIKE '%'||:ls_acct_no ;
      IF SQLCA.sqlcode () <> 0   Then
         F_MESSAGEBOX ('INFO', '계좌확인')
         RETURN ''
      END IF
      ls_fund_cd = SQLCA.GETITEMSTRING (1)
      ls_acct_no = SQLCA.GETITEMSTRING (2)
//      ls_acct_no = dw_list.object.c_01 [1]
   CASE '00010'   // 메리츠
      lr         = 1
      ls_acct_no = '3017-8738-01'
   CASE '00021'   // 한화
      lr         = 1
      ls_acct_no = '500-662563-11'
   CASE '00030'   // 삼성
      lr         = 1
      ls_acct_no = '7132428916-01'
END CHOOSE

DO WHILE TRUE
   f_st_count (st_count, sp_in.str [2] + IIF (f_null (is_xls), '', '(' + is_xls + ')') + '~r~n체결내역 LOAD : ', lr, ll_rowcount)
   CHOOSE CASE is_tr_co_cd
      CASE '00002'
         lr ++
         IF lr>ll_rowcount THEN EXIT
         IF f_num (dw_list.object.c_05 [lr])=0 THEN CONTINUE

//       ls_tr_ymd    = dw_list.object.c_01 [lr]
         ls_tr_cd     = IIF (POS (dw_list.object.c_04 [lr], '매수') > 0, 'J', 'K')
         ls_koscom_cd = MID (dw_list.object.c_02 [lr], 2)
         ls_jm_cd     = ''

         ldc_offer_no = lr
         ldc_tr_jusu  = f_num (dw_list.object.c_05 [lr])
         ldc_tr_aek   = f_num (dw_list.object.c_07 [lr])
         ldc_susu     = f_num (dw_list.object.c_08 [lr])
         ldc_tax      = f_num (dw_list.object.c_09 [lr])

      CASE '00010'
         lr = lr + 2
         IF lr>ll_rowcount THEN EXIT
         IF f_num (dw_list.object.c_05 [lr])=0 THEN CONTINUE

         ls_koscom_cd = MID (dw_list.object.c_02 [lr], 2, 6)
         ls_jm_cd     = ''

         ldc_offer_no = lr

//       ls_tr_ymd = dw_list.object.c_01 [lr]
         ls_tr_cd    = IIF (POS (dw_list.object.c_03 [lr], '매수') > 0, 'J', 'K')
         ldc_tr_jusu = f_num (dw_list.object.c_05 [lr])
         ldc_tr_aek  = f_num (dw_list.object.c_06 [lr])
         ldc_susu    = f_num (dw_list.object.c_06 [lr + 1])
         ldc_tax     = f_num (dw_list.object.c_07 [lr]) + f_num (dw_list.object.c_07 [lr + 1])

      CASE '00021'
         lr = lr + 3
         IF lr>ll_rowcount THEN EXIT
         IF f_num (dw_list.object.c_04 [lr])=0 THEN CONTINUE

         ls_koscom_cd = MID (dw_list.object.c_03 [lr], 2, 6)
         ls_jm_cd     = ''

//       ls_tr_ymd    = dw_list.object.c_01 [lr]
         ls_tr_cd = IIF (POS (dw_list.object.c_03 [lr + 1], '매수') > 0, 'J', 'K')

         ldc_offer_no = lr
         ldc_tr_jusu  = f_num (dw_list.object.c_04 [lr])
         ldc_tr_aek   = f_num (dw_list.object.c_05 [lr])
         ldc_susu     = f_num (dw_list.object.c_05 [lr + 1])
         ldc_tax      = f_num (dw_list.object.c_06 [lr + 2])

      CASE '00030'
         lr = lr + 2
         IF lr>ll_rowcount THEN EXIT

         ls_jm_nm    = dw_list.object.c_03 [lr]
         ldc_tr_jusu = f_num (dw_list.object.c_04 [lr])
         ls_tr_cd    = IIF (POS (dw_list.object.c_02 [lr], '매수') > 0, 'J', 'K')

         ls_koscom_cd = MID (dw_list.object.c_03 [lr + 1], 2, 6)
         ls_jm_cd     = ''

// 2022.12.26 엑셀변경
//         lFIND = ids_jj.FIND ("#1='" + ls_jm_nm + "'", 1, il_jj)
//         IF lFIND=0  Then
//            dw_list.object.c_01 [lr]     = ''
//            dw_list.object.c_01 [lr + 1] = ''
//            CONTINUE
//         Else
//            dw_list.object.c_01 [lr] = 'ok'
//         End IF
//         ls_koscom_cd = ids_jj.getitemstring (lFIND, 2)
//         ls_jm_cd     = ids_jj.getitemstring (lFIND, 3)
//         ls_danc      = ids_jj.getitemstring (lFIND, 4)

         ldc_offer_no = lr
         ldc_tr_aek   = f_num (dw_list.object.c_08 [lr])
         ldc_tax      = f_num (dw_list.object.c_06 [lr]) + f_num (dw_list.object.c_06 [lr + 1])
         ldc_susu     = f_num (dw_list.object.c_05 [lr + 1])
   END CHOOSE

   IF f_null (ls_fund_cd)  Then
      lFIND = ids_fund.FIND ("#1='" + f_replace (ls_acct_no, '-', '') + "'", 1, il_fund)
      IF lFIND=0 THEN CONTINUE
      ls_fund_cd     = ids_fund.GETITEMSTRING (lFIND, 2)
      ls_enc_acct_no = ids_fund.GETITEMSTRING (lFIND, 3)
   END IF

   IF f_null (ls_jm_cd) Then
      lFIND = ids_jj.FIND ("#2='" + ls_koscom_cd + "'", 1, il_jj)
      IF lFIND=0  Then
         dw_list.object.c_01 [lr] = '(종목확인)'
         CONTINUE
      END IF
      ls_jm_cd = ids_jj.GETITEMSTRING (lFIND, 3)
      ls_danc  = ids_jj.GETITEMSTRING (lFIND, 4)

      IF is_tr_co_cd='00002'  Then
         dw_list.object.c_01 [lr] = 'ok'
      ELSE
         dw_list.object.c_01 [lr + 1] = 'ok'
      END IF
   END IF

   sp_out.LONG [1] ++
   sp_out.str [sp_out.long [1]] = gaa.CORP_GR + '~t' + ls_tr_ymd + '~t' + ls_tr_cd + '~t' + is_tr_co_cd + '~t' + STRING (ldc_offer_no)&
                                              + '~t' + ls_enc_acct_no + '~t' + ls_jm_cd + '~t' + ls_koscom_cd + '~t' + string (ldc_tr_jusu)&
                                              + '~t' + string (ldc_tr_aek) + '~t' + ls_fund_cd + '~t' + '' + '~t' + '' + '~t' + ls_danc &
                                              + '~t' + string (ldc_susu) + '~t' + string (ldc_tax) + '~t' + ls_acct_no + '~t' + f_sysdate_str ('yyyy.mm.dd')
   yield ()
LOOP
dw_list.SETREDRAW (TRUE)

f_st_count (st_count, sp_in.str [2] + '~r~n체결내역 LOAD(' + STRING (sp_out.LONG [1]) + '건) : ', ll_rowcount, ll_rowcount)

RETURN ''
end function

public function string wf_f ();LONG	lr, ll_rowcount, ll_row = 0, lFIND

STRING	ls_fund_err = '', ls_jj = ''
STRING	ls_tr_cd, ls_fund_cd, ls_koscom_cd, ls_koscom = 'not', ls_jm_cd = '', ls_danc, ls_acct_no, ls_acct = 'not', ls_enc_acct_no

BOOLEAN	lb

DEC	ldc_offer_no, ldc_tr_jusu, ldc_tr_aek, ldc_susu, ldc_tax

dw_list.setredraw (false)
ll_rowcount = dw_list.rowcount ()
FOR  lr = 22  TO  1  STEP -2
	CHOOSE CASE is_tr_co_cd
		CASE '00056'
			IF	lr<=2 THEN EXIT
	END CHOOSE
	ll_row ++
   f_st_count (st_count, sp_in.str [2] + IIF (f_null (is_xls), '', '(' + is_xls + ')') + '~r~n체결내역 LOAD : ', ll_row, ll_rowcount)

   CHOOSE CASE is_tr_co_cd
      CASE '00056'   // 하나
			IF f_num (dw_list.object.c_04 [lr - 1])=0	Then  // 입고수량 0
				dw_list.deleterow (lr)
				CONTINUE
			End IF
			ls_acct_no   = '39160156010'
			ls_jm_cd     = ''
			ls_koscom_cd = MID (TRIM(dw_list.object.c_03 [lr - 1]),2)
   END CHOOSE

	lFIND = ids_fund.FIND ("#1='" + f_replace (ls_acct_no,'-','') + "'", 1, il_fund)
	ls_fund_cd     = ids_fund.getitemstring (lFIND, 2)
	ls_enc_acct_no = ids_fund.getitemstring (lFIND, 3)

	IF f_null (ls_jm_cd) Then
		lFIND = ids_jj.FIND ("#2='" + ls_koscom_cd + "'", 1, il_jj)
		IF	lFIND=0	Then
			CHOOSE CASE is_tr_co_cd
				CASE '00056'   // 하나
					dw_list.object.c_14 [lr] = '(종목확인)'
			END CHOOSE
			ls_jj = '등록되지 않은 종목이 있습니다.~r~n엑셀 시트를 확인하십시오.'
			ls_koscom_cd = ''
			ls_jm_cd     = ''
			ls_danc      = ''
			lb = FALSE
		Else
			ls_jm_cd = ids_jj.getitemstring (lFIND, 3)
			ls_danc  = ids_jj.getitemstring (lFIND, 4)
			lb = TRUE
		End IF
	End IF

   CHOOSE CASE is_tr_co_cd
      CASE '00056'   // 하나
         ldc_offer_no = lr
         ls_tr_cd     = 'F'
         ldc_tr_jusu  = dec (dw_list.object.c_04 [lr - 1])
         ldc_tr_aek   = dec (dw_list.object.c_04 [lr]) * dec (dw_list.object.c_04 [lr - 1])
         ldc_susu     = 0
         ldc_tax      = 0
   END CHOOSE

	IF	lb	Then
		sp_out.long [1] ++
		sp_out.str [sp_out.long [1]] = gaa.corp_gr + '~t' + string (idt_tr_ymd,'yyyy.mm.dd') + '~t' + ls_tr_cd + '~t' + is_tr_co_cd + '~t' + string (ldc_offer_no) &
																 + '~t' + ls_enc_acct_no + '~t' + ls_jm_cd + '~t' + ls_koscom_cd + '~t' + string (ldc_tr_jusu) &
																 + '~t' + string (ldc_tr_aek) + '~t' + ls_fund_cd + '~t' + '' + '~t' + '' + '~t' + ls_danc &
																 + '~t' + string (ldc_susu) + '~t' + string (ldc_tax) + '~t' + ls_acct_no + '~t' + f_sysdate_str ('yyyy.mm.dd')
		dw_list.deleterow (lr)
		dw_list.deleterow (lr + 1)
		yield ()
	End IF
NEXT
dw_list.setredraw (true)
f_st_count (st_count, sp_in.str [2] + '~r~n체결내역 LOAD : ', ll_rowcount, ll_rowcount)

RETURN	ls_fund_err + ls_jj
end function

on w_import_sjt1jg.create
int iCurrent
call super::create
this.st_count=create st_count
this.btn_load=create btn_load
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_count
this.Control[iCurrent+2]=this.btn_load
end on

on w_import_sjt1jg.destroy
call super::destroy
destroy(this.st_count)
destroy(this.btn_load)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
btn_load.post event clicked ()
end event

event close;call super::close;CloseWithReturn (THIS, sp_out)
end event

event wue_postopen;call super::wue_postopen;sp_in = Message.PowerObjectParm

TITLE = sp_in.str [2] + ' 체결내역 엑셀 LOAD'

dw_cond.object.ymd [1] = sp_in.dt [1]
dw_cond.object.p_visible [1] = 0
dw_cond.tag = "* " + sp_in.str [2] + " 체결내역 LOAD중 입니다."
idt_tr_ymd = sp_in.dt [1]
is_tr_co_cd = sp_in.str [1]

ids_fund = CREATE ads_jTier
ids_jj   = CREATE ads_jTier

STRING	ls_sqlsyntax

ls_sqlsyntax = " SELECT jj_nm " + &
               "      , koscom_cd " + &
               "      , jm_cd " + &
               "      , danc_gb " + &
               " FROM   sjm0jj t1 " + &
               " WHERE  danc_gb IN ('A','C','D') "

il_jj = SQLCA.sql2ds (classname(), ls_sqlsyntax, ids_jj, 'sqlm')

ls_sqlsyntax = " SELECT REPLACE(to_decrypts (t1.enc_acct_no), '-', '') " + &
               "      , t1.fund_cd " + &
               "      , t1.enc_acct_no " + &
               " FROM   szm0ia t1 " + &
               " WHERE  t1.corp_gr = '" + gaa.corp_gr + "' " + &
               "   AND  t1.mg_cd   = '" + is_tr_co_cd + "' " + &
               "   AND  t1.haeji_ymd is null "

il_fund = SQLCA.sql2ds (classname(), ls_sqlsyntax, ids_fund, 'sqlm')

sp_out.long [1] = 0
end event

type ln_tempbutton from w_response`ln_tempbutton within w_import_sjt1jg
end type

type ln_tempstart from w_response`ln_tempstart within w_import_sjt1jg
end type

type ln_templeft from w_response`ln_templeft within w_import_sjt1jg
end type

type ln_cond_start from w_response`ln_cond_start within w_import_sjt1jg
end type

type ln_tempright from w_response`ln_tempright within w_import_sjt1jg
end type

type ln_cond1_yline from w_response`ln_cond1_yline within w_import_sjt1jg
end type

type ln_dw1_yline from w_response`ln_dw1_yline within w_import_sjt1jg
end type

type dw_cond from w_response`dw_cond within w_import_sjt1jg
string tag = "* 체결내역 LOAD 중입니다."
boolean visible = true
integer width = 7237
boolean enabled = false
string title = "LOAD기준일"
string dataobject = "dc_ymd"
end type

type p_retrieve from w_response`p_retrieve within w_import_sjt1jg
end type

type p_clear from w_response`p_clear within w_import_sjt1jg
end type

type p_new from w_response`p_new within w_import_sjt1jg
end type

type p_delete from w_response`p_delete within w_import_sjt1jg
end type

type p_update from w_response`p_update within w_import_sjt1jg
end type

type p_ok from w_response`p_ok within w_import_sjt1jg
end type

type p_close from w_response`p_close within w_import_sjt1jg
boolean visible = true
integer x = 7017
end type

event p_close::clicked;CloseWithReturn (parent, sp_out)
end event

type p_print from w_response`p_print within w_import_sjt1jg
end type

type p_copy from w_response`p_copy within w_import_sjt1jg
end type

type dw_list from w_response`dw_list within w_import_sjt1jg
integer width = 7237
integer height = 2936
string dataobject = "d_xlsx"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean eb_null_line = false
end type

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'c_01','c_05','c_06'
		rs_where = "danc_gb IN ('A','C')"
	CASE 'C_04','c_03','c_13'
		rs_where = "tr_co_cd = '" + is_tr_co_cd + "'"
END CHOOSE
RETURN 1
end event

event dw_list::rbuttondown;STRING	ls_old, ls_new, ls_data

LONG	ll, ll_row

ls_old = string (dwo.primary [row])

call super::rbuttondown

IF	row>0	Then
	ls_new = string (dwo.primary [row])
	IF	ls_old<>ls_new	Then
		ls_new = getitemstring (row, 'xx_' + string (dwo.name))
		FOR  ll = 1  TO  rowcount ()
			ls_data = getitemstring (ll, string (dwo.name))
			IF	ls_old=ls_data OR ll=row THEN SetItem (ll, string (dwo.name), ls_new)
		NEXT
	End IF
End IF
end event

type p_excel from w_response`p_excel within w_import_sjt1jg
end type

type st_count from pf_u_statictext within w_import_sjt1jg
integer x = 5737
integer y = 180
integer width = 1458
integer height = 116
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean setbringtotop = true
boolean setcondcolor = true
boolean fixedtoright = true
end type

type btn_load from pf_u_commandbutton within w_import_sjt1jg
integer x = 55
integer y = 28
integer width = 402
integer taborder = 10
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "체결LOAD"
end type

event clicked;call super::clicked;oleobject	ole_excel

BOOLEAN	lb_first

LONG	ll, lFIND, lr, lt, lf, lRow

STRING	ls_path, ls_file, ls_txt, ls_return, ls_err

IF	ib_next	Then
	ls_return = wf_load ()
Else
	ls_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
	IF GetFileOpenName ("체결내역 엑셀파일 선택", is_path, ia_name, 'XLS', "Excel Files (*.xls;*.xlsx;*.csv),*.xls;*.xlsx;*.csv", ls_path, 2)<>1 THEN RETURN
	IF	UPPERBOUND (ia_name)=1	Then
		SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', f_replace (is_path,ia_name [1],''))
	Else
		SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir',is_path)
	End IF

	f_loadingretrieve (TRUE)

	ls_return = ''
	FOR  ll = 1  TO  UPPERBOUND (ia_name)
		IF	UPPERBOUND (ia_name)=1	then
			ls_file = is_path
			is_xls  = ''
		Else
			ls_file = is_path + '\' + ia_name [ll]
			is_xls  = ia_name [ll]
		End IF

		ole_excel = CREATE OLEobject

		lFIND = ole_excel.ConnectToNewObject ("excel.application")
		IF	lFIND<>0	Then
			DESTROY ole_excel
			MessageBox("ERROR","엑셀 프로그램을 실행할 수 없습니다.", StopSign!)
			RETURN
		End IF

		ole_excel.WorkBooks.OPEN (ls_file)
		ole_excel.Application.Visible = false
		ole_excel.WorkSheets(1).Activate 

		ls_txt = gaa.temp + 'w_import_temp(' + string (ll) + ').txt'
		IF	FileExists (ls_txt) THEN FileDelete (ls_txt)

		ole_excel.Application.Workbooks(1).Saveas (ls_txt, -4158)
		ole_excel.WorkBooks(1).saved = TRUE
		ole_excel.quit ()

		DESTROY ole_excel

		dw_list.reset ()
		dw_list.importfile (ls_txt, 1)
		CHOOSE CASE gaa.corp_gr
			CASE '2201','2202'
				ls_err = wf_load ()
			CASE '2203'
				IF	string (dw_cond.object.ymd [1],'yyyymmdd')='20221226'	Then
					ls_err = wf_2203 ()	// 잔고
				Else
					ls_err = wf_2203_meme ()
				End IF
		END CHOOSE
		IF	f_notnull (ls_err)	Then
			ls_return += ls_err + '~r~n'
			ls_err = ''
			FOR  lr= 1  TO  dw_list.rowcount ()
				FOR  lt = 1  TO  Long(dw_list.object.datawindow.column.count)
					IF	lt=1	Then
						ls_err += dw_list.object.data [lr, lt]
					Else
						ls_err += '~t' + dw_list.object.data [lr, lt]
					End IF
				NEXT
				ls_err += '~r~n'
			NEXT
			ls_file = gaa.temp + 'w_import_temp(' + string (ll) + ')err.txt' ; FileDelete (ls_file)
			lf = FILEOPEN (ls_file, TextMode!, Write!, LockWrite!, Replace!, EncodingUTF8!)
			FileWriteEX (lf, ls_err) ; FileClose (lf)
		Else
			ls_file = gaa.temp + 'w_import_temp(' + string (ll) + ')err.txt' ; FileDelete (ls_file)
		End IF
	NEXT
	dw_list.enabled = TRUE

	f_loadingretrieve (FALSE)
End IF

IF	f_null (ls_return)	Then
	ib_next = false
	f_messageBox ('INFO', '체결자료 Load를 완료했습니다.~r~n추가 LOAD시 체결LOAD 버튼을 클릭하십시오.')
Else
	CHOOSE CASE gaa.corp_gr
		CASE '2201','2202'
			ib_next = true
			lb_first = true
			dw_list.reset ()
			lRow = 0
			FOR  ll = 1  TO  UPPERBOUND (ia_name)
				ls_txt = gaa.temp + 'w_import_temp(' + string (ll) + ')err.txt'
				lf = FILEOPEN (ls_txt, TextMode!, Read!, Shared!)
				IF	lf>0	Then
					FileClose (lf)
					dw_list.importfile (ls_txt, lRow + 1)
					IF	NOT lb_first	Then
						CHOOSE CASE is_tr_co_cd
							CASE '00010'   // NH
								dw_list.deleterow (lRow + 1)
								dw_list.deleterow (lRow + 1)
							CASE '00020','00030'  // 미래, 신영
								dw_list.deleterow (lRow + 1)
						END CHOOSE
					End IF
					lb_first = false
				End IF
				lRow = dw_list.rowcount ()
			NEXT
		CASE '2203'
			//
		END CHOOSE
	f_messageBox ('INFO', '체결자료 Load를 완료했습니다.~r~n' + f_nvl(ls_return,'') + '~r~n더블클릭으로 계좌와 종목 선택 후 체결LOAD 버튼을 클릭하십시오.')
End IF

ChangeDirectory (gnv_vari.basepath)
end event

