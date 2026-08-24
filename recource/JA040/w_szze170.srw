forward
global type w_szze170 from wt_list
end type
end forward

global type w_szze170 from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_find = "fund_cd=~'~'"
end type
global w_szze170 w_szze170

type variables

end variables

on w_szze170.create
int iCurrent
call super::create
end on

on w_szze170.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"

dw_List.SetFilter ("isnull (haeji_ymd) or haeji_ymd >= date ('" + string (idt_workdate,'yyyy.mm.dd') + "')")
dw_List.retrieve (gaa.corp_gr)
//dw_List.Modify ("DataWindow.HorizontalScrollSplit=" + string (integer (dw_List.Describe ('moja_gb.x')) - 50))
end event

event ue_activate;call super::ue_activate;IF dw_List.enabled THEN dw_List.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_list`lb_dirlist within w_szze170
end type

type ln_templeft from wt_list`ln_templeft within w_szze170
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_szze170
end type

type ln_temptop from wt_list`ln_temptop within w_szze170
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_szze170
end type

type ln_tempstart from wt_list`ln_tempstart within w_szze170
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_szze170
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_szze170
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_szze170
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_szze170
end type

type ln_tempright from wt_list`ln_tempright within w_szze170
end type

type uo_navi from wt_list`uo_navi within w_szze170
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_szze170
end type

type st_windelaytime from wt_list`st_windelaytime within w_szze170
end type

type st_top_rect from wt_list`st_top_rect within w_szze170
end type

type p_close from wt_list`p_close within w_szze170
end type

type p_excel from wt_list`p_excel within w_szze170
end type

type p_print from wt_list`p_print within w_szze170
end type

type p_delete from wt_list`p_delete within w_szze170
end type

type p_update from wt_list`p_update within w_szze170
end type

type p_input from wt_list`p_input within w_szze170
end type

type p_retrieve from wt_list`p_retrieve within w_szze170
end type

type p_clear from wt_list`p_clear within w_szze170
end type

type p_copy from wt_list`p_copy within w_szze170
end type

type dw_c from wt_list`dw_c within w_szze170
boolean visible = false
boolean enabled = false
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = gaa.aams
RETURN TRUE
end event

type btn_update from wt_list`btn_update within w_szze170
end type

type st_count from wt_list`st_count within w_szze170
end type

type dw_list from wt_list`dw_list within w_szze170
event ue_fst_gijun_ga ( integer lrow )
integer y = 156
integer height = 2608
string dataobject = "d_szze170_1"
string setlist4rowpointcolor = "unit_gb=3=a"
boolean eb_range_delcopy = false
boolean eb_copy_false = true
end type

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow

FOR  lRow = 1  TO  rowcount ()
   IF GetItemStatus (lRow, 0, Primary!)=DataModified! OR GetItemStatus (lRow, 0, Primary!)=NewModified!  Then
      IF f_num (Object.sintak_gigan [lRow])=0   Then
         f_messageBox ("I000", string (lRow) + ' 행에서 신탁계산기간(월) 오류')
         RETURN 1
      End IF
      IF IsNull (Object.bf_bosu_ymd1 [lRow]) Then
         f_messageBox ("I000", string (lRow) + ' 행에서 전보수인출일1 오류')
         RETURN 1
      End IF
      IF f_null (Object.bosu_gb [lRow])   Then
         f_messageBox ("I000", string (lRow) + ' 행에서 보수구분 오류')
         RETURN 1
      End IF
      IF f_num (Object.bosu_gigan1 [lRow])=0 Then
         f_messageBox ("I000", string (lRow) + ' 행에서 보수계산기간1 오류')
         RETURN 1
      End IF
      IF f_null (Object.kukje_gb [lRow])  Then
         f_messageBox ("I000", string (lRow) + ' 행에서 국내외구분 오류')
         RETURN 1
      End IF
      IF f_null (Object.dist_calc [lRow]) Then
         f_messageBox ("I000", string (lRow) + ' 행에서 당기분배금계산식  오류')
         RETURN 1
      End IF
      IF f_null (Object.sangj_gb [lRow])  Then
         f_messageBox ("I000", string (lRow) + ' 행에서 상장여부 오류')
         RETURN 1
      End IF
      IF Object.sintak_gigan [lRow]=0  Then
         IF IsNull (Object.af_gyul_ymd [lRow])  Then
            f_messageBox ("I000", string (lRow) + ' 행에서 최초설정일 오류')
            RETURN 1
         End IF
      End IF
   End IF

   IF (GetItemStatus (lRow, 'bosu_gigan1', Primary!)=DataModified! OR &
         GetItemStatus (lRow, 'bf_bosu_ymd1', Primary!)=DataModified!) And &
         GetItemNumber (lRow, 'bosu_gigan1')=0  Then
      IF IsNull (Object.bf_bosu_ymd1 [lRow]) Then
         f_messageBox ("I000", string (lRow) + ' 행에서 전보수인출일 오류')
         RETURN 1
      End IF
   End IF
NEXT
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;//F_DDDWCTL (dw_master, 'dist_calc', gaa.corp_gr, '', 1, '')
//F_DDDWCTL (dw_master, 'fund_siga_gb | siga_gb', gaa.corp_gr, '', 1, '')
//F_DDDWCTL (dw_master, 'mc_code', gaa.corp_gr, '', 1, '')
//F_DDDWCTL (dw_master, 'tax_gb', gaa.corp_gr, '', 2, '')
//F_DDDWCTL (dw_master, 'kukje_gb', gaa.corp_gr, '', 1, '')
//F_DDDWCTL (dw_master, 'witak_gb', gaa.corp_gr, '', 1, '')
//F_DDDWCTL (dw_master, 'sangj_gb', gaa.corp_gr, '', 1, '')

F_DDDWCTL (THIS, 'sutak_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'type_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'unit_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'series_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'samu_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'moja_gb', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'sutak_bank', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'bosu_gb', gaa.corp_gr, '', 1, "sebu_cd>'50'")
F_DDDWCTL (THIS, 'fund_currency | currency', gaa.corp_gr, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll_fund

DateTime ldt_fst_seolj_ymd, ldt_fst_gyul_ymd

STRING	ls_mc, ls_fund, ls_bosu_gb

DEC	ldc_sintak_gigan, ldc_bosu_gigan

ls_mc = Object.mc_code [row]  // Multi Class 펀드처리
IF isNull (ls_mc) Then
   ldt_fst_seolj_ymd = Object.fst_seolj_ymd [row]
Else
   SELECT  fst_seolj_ymd
     INTO  :ldt_fst_seolj_ymd
   FROM    aams.szm0fd t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.fund_cd = :ls_mc;
	  ldt_fst_seolj_ymd = SQLCA.getitemdatetime (1)
   IF SQLCA.sqlcode ()=100 THEN ldt_fst_seolj_ymd = Object.fst_seolj_ymd [row]
End IF
// 최초결산일 - 다음결산일을 위해 최초설정일 전일
SELECT  :ldt_fst_seolj_ymd - 1
  INTO  :ldt_fst_gyul_ymd
FROM    dual;
ldt_fst_gyul_ymd = SQLCA.getitemdatetime (1)

CHOOSE CASE dwo.name
   CASE 'fst_seolj_ymd'
      ldt_fst_seolj_ymd = Datetime (Date (LeftA (data,10)))
      Object.bf_bosu_ymd1 [row] = ldt_fst_seolj_ymd
      Object.af_bosu_ymd1 [row] = f_add_months (ldt_fst_seolj_ymd, Object.bosu_gigan1 [row], ldt_fst_seolj_ymd)
      Object.bf_gyul_ymd [row] = datetime (RelativeDate (date (ldt_fst_seolj_ymd), -1))
      Object.af_gyul_ymd [row] = f_add_months (Object.bf_gyul_ymd [row], Object.sintak_gigan [row], ldt_fst_seolj_ymd)
   CASE 'fund_fnm'
      Object.fund_nm [row] = data
   CASE 'sintak_gigan'  // 신탁계산기간 (월)
      Object.af_gyul_ymd [row] = f_add_months (Object.bf_gyul_ymd [row], dec (data), ldt_fst_gyul_ymd)
   CASE 'seolj_aek'     // 설정액
      Object.wonbon_aek [row] = dec (data)
      Object.seolj_jwa [row] = dec (data)
   CASE 'bosu_gb'       // 보수구분
      IF f_null (data)  Then
         RETURN uf_itemerr (row, 'bosu_gb', '보수구분이 선택되지 않았습니다!')
      End IF
      IF f_null (Object.fund_cd [row]) Then
         RETURN uf_itemerr (row, 'bosu_gb', '펀드코드가 입력되지 않았습니다!')
      End IF
   CASE 'bf_bosu_ymd1'
      Object.af_bosu_ymd1 [row] = f_add_months (datetime (date (MID (data,1,10))), Object.bosu_gigan1 [row], ldt_fst_seolj_ymd)
   CASE 'bosu_gigan1'      //보수계산기간1
      Object.af_bosu_ymd1 [row] = f_add_months (Object.bf_bosu_ymd1 [row], integer (data), ldt_fst_seolj_ymd)
   CASE 'trans_unit'    //거래단위
      IF dec (data)=1 THEN
         Object.fst_gijun_ga [row] = 5000
         IF (IsNull (Object.seolj_aek [row]) OR IsNull (Object.seolj_jwa [row]) OR (Object.seolj_aek [row]<>Object.seolj_jwa [row] * dec (data) * Object.fst_gijun_ga [row])) Then
            f_messageBox ('I000', '설정좌수 * 거래단위 * 최초기준가격 = 설정액')
         End IF
      Else
         Object.fst_gijun_ga [row] = IIF (Object.fund_currency [row]='KRW',1000,10)
         IF (IsNull (Object.seolj_aek [row]) OR IsNull (Object.seolj_jwa [row]) OR (Object.seolj_aek [row]<>Object.seolj_jwa [row]))   Then
            f_messageBox ('I000', '설정액 = 설정좌수 ')
         End IF
      End IF
   CASE 'type_gb'
      IF (data='M' OR data='V') THEN Object.bosuinchul_gb [row] = '2' &
      Else                           Object.bosuinchul_gb [row] = '1'
   CASE 'mc_code'
      SELECT  fst_seolj_ymd
        INTO  :ldt_fst_seolj_ymd
      FROM    aams.szm0fd t1
      WHERE   t1.corp_gr = :gaa.corp_gr
        AND   t1.fund_cd = :data;
		  ldt_fst_seolj_ymd = SQLCA.getitemdatetime (1)
      IF SQLCA.sqlcode ()=100 THEN ldt_fst_seolj_ymd = Object.fst_seolj_ymd [row]

      Object.bf_bosu_ymd1 [row] = ldt_fst_gyul_ymd
      Object.af_bosu_ymd1 [row] = f_add_months (ldt_fst_gyul_ymd, Object.bosu_gigan1 [row], ldt_fst_seolj_ymd)

      IF GetItemStatus (row, 0, Primary!)=NewModified!   Then
         SELECT  ASCII(nvl(max(substr(fund_cd,length (fund_cd),1)),0))
           INTO  :ll_fund
         FROM    aams.szm0fd t1
         WHERE   t1.corp_gr = :gaa.corp_gr
           AND   t1.fund_cd LIKE SUBSTR(:data,1,length(:data) - 1)||'%';
			  ll_fund = SQLCA.getitemnumber (1)

         IF ll_fund=48  Then
            ll_fund = 65
         Else
            ll_fund ++
         End IF
         Object.fund_cd [row] = MID (data,1,LEN (data) - 1) + char (ll_fund);
      End IF
   CASE 'unit_gb'
      IF data='3' THEN Object.dist_calc [row] = '1'
END CHOOSE
end event

event dw_list::updateend;call super::updateend;LONG	ll, ll_ilsu, ll_f_value

STRING	ls_fund, ls_old, ls_new

Datetime	ldt, ldt_bf, ldt_af, ldt_f_param1, ldt_f_param2, ldt_fst_seolj_ymd

DEC	ld_seolj_aek

ldt = idt_workdate

FOR  ll = 1  TO  rowsdeleted
   // 설정해지 내역 삭제
   ls_fund = GetItemstring (ll, 'fund_cd', Delete!, TRUE)

   DELETE  aams.szm0gi
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   DELETE  aams.skt0bn
   WHERE   corp_gr = :gaa.corp_gr
     AND   tr_cd   = 'A11'
     AND   fund_cd = :ls_fund;

   DELETE  aams.skt5bn
   WHERE   corp_gr = :gaa.corp_gr
     AND   tr_cd   = 'A11'
     AND   fund_cd = :ls_fund;

   // 보수율 내용 삭제
   DELETE  aams.szx0bs
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   // 설정해지 (판매사별) 마스타 삭제
   DELETE  aams.skm0bt
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund
     AND   ymd     = :ldt;

   DELETE  aams.skm5bt
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund
     AND   ymd     = :ldt;

   // 변경관리
   DELETE  aams.szt0fd
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   // 추가정보
   DELETE  aams.szm0fd_excode
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   DELETE  aams.szm1fd
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   DELETE  aams.szm0fd_ja
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   DELETE  aams.sat0bn
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   DELETE  aams.sjm0sm_mc
   WHERE   corp_gr = :gaa.corp_gr
     AND   fund_cd = :ls_fund;

   DELETE  aams.sjm0sm_mc
   WHERE   corp_gr = :gaa.corp_gr
     AND   mc_code = :ls_fund;
	
	//투자대상여부 삭제
	DELETE  aams.sjx0pf
	WHERE   corp_gr = :gaa.corp_gr
	  AND   fund_cd = :ls_fund;
NEXT

FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 0, Primary!)=NewModified! Then  // 펀드별 처리현황 생성
      ls_fund           = Object.fund_cd [ll]
      ldt_fst_seolj_ymd = Object.fst_seolj_ymd [ll]
		
		ldt_f_param1 = Object.bf_gyul_ymd[ll]
		ldt_f_param2 = Object.af_gyul_ymd[ll]
		
		SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)
      ll_ilsu = ll_f_value
      ldt_bf  = Object.bf_gyul_ymd [ll]
      ldt_af  = Object.af_gyul_ymd [ll]

      DELETE  aams.szm0gi
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_fund;

      INSERT INTO  aams.szm0gi
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ls_fund                                   /* _2: */
             , 1                                          /* _3: */
             , :ldt_bf                                    /* _4: */
             , :ldt_af                                    /* _5: */
             , :ll_ilsu                                   /* _6: */
             , NULL                                       /* _7: */
             , NULL                                       /* _8: */
             , NULL                                       /* _9: */
             , NULL                                       /* _10: */
             , NULL                                       /* _11: */
             , '0'                                        /* _12: */
             );
      IF SQLCA.SQLCode()<>0 THEN MessageBox ('szm0gi INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())

		INSERT INTO  aams.szm0fd_excode
		VALUES ( :gaa.corp_gr                             /* _1: */
				 , :ls_fund                                   /* _2: */
				 , NULL                                       /* _3: */
				 , NULL                                       /* _4: */
				 , 'KRZ'                                      /* _5: */
				 , SUBSTR(F_SAFE_NEW (:gaa.corp_gr, '', 'U'),1,10)  /* _6: */
				 , NULL                                       /* _7: */
				 , 'K5'                                       /* _8: */
				 , 'N'                                        /* _9: */
				 , 'Y'                                        /* _10: */
				 , NULL                                       /* _11: */
				 , '1'                                        /* _12: */
				 , 'N'                                        /* _13: */
				 , NULL                                       /* _14: */
				 , NULL                                       /* _15: */
				 , NULL                                       /* _16: */
				 , NULL                                       /* _17: */
				 , NULL                                       /* _18: */
				 , NULL                                       /* _19: */
				 , NULL                                       /* _20: */
				 , NULL                                       /* _21: */
				 , NULL                                       /* _22: */
				 , NULL                                       /* _23: */
				 );
      IF SQLCA.SQLCode()<>0 THEN MessageBox ('szm0fd_excode INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())

      INSERT INTO  aams.szm1fd (
                     corp_gr                          /* _1: */
                   , fund_cd )                        /* _2: */
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ls_fund                                   /* _2: */
             );
      IF SQLCA.SQLCode()<>0 THEN MessageBox ('szm1fd INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())

      // 연관 테이블 생성처리
      INSERT INTO  aams.szm0fd_ja (
                     corp_gr                          /* _1: */
                   , fund_cd                          /* _2: */
                   , mg_uy_yn )                       /* _3: */
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ls_fund                                   /* _2: */
             , 'Y'                                        /* _3: */
             );
      IF SQLCA.SQLCode()<>0 THEN MessageBox ('szm0fd_ja INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())

      ld_seolj_aek = Object.seolj_aek [ll]
   End IF

   IF GetItemStatus (ll, 'bunryu_cd', Primary!)=DataModified!  Then
      ls_fund = Object.fund_cd [ll]
      ls_old = GetItemstring (ll, 'bunryu_cd', Primary!, TRUE)
      ls_new = Object.bunryu_cd [ll]

      INSERT INTO  aams.szt0fd
      VALUES ( :gaa.corp_gr                             /* _1: */
             , :ls_fund                                   /* _2: */
             , 'bunryu_cd'                                /* _3: */
             , :idt_workdate                              /* _4: */
             , :ls_old                                    /* _5: */
             , NULL                                       /* _6: */
             , :ls_new                                    /* _7: */
             , NULL                                       /* _8: */
             , now()                                    /* _9: */
             , :gnv_vari.is_user_id                       /* _10: */
             );
      IF SQLCA.sqlcode ()<>0  Then
         UPDATE  aams.szt0fd
            SET  af_data = :ls_new
         WHERE   corp_gr    = :gaa.corp_gr
           AND   fund_cd    = :ls_fund
           AND   chg_column = 'bunryu_cd'
           AND   start_ymd  = :idt_workdate;
      End IF
   End IF

   IF GetItemStatus (ll, 'fund_cd', Primary!)=DataModified! Then
      ls_old = GetItemstring (ll, 'fund_cd', Primary!, TRUE)
      ls_new = Object.fund_cd [ll]

      UPDATE  aams.szm0gi
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.szm0fd_excode
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.szm1fd
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.szm0fd_ja
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.szx0bs
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.skm5bt
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.skm0bt
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.skt5bn
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.skt0bn
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;

      UPDATE  aams.sjm0sm_mc
         SET  fund_cd = :ls_new
      WHERE   corp_gr = :gaa.corp_gr
        AND   fund_cd = :ls_old;
   End IF
NEXT
end event

event dw_list::ue_insertstart;call super::ue_insertstart;IF uf_update ()=false THEN RETURN 1

LONG	ll_fund

STRING	ls_series = '', ls_bosu_gb

DEC	ldc_sintak_gigan, ldc_bosu_gigan

ll_fund = dec (string (idt_workdate,'yy')) * 10000

SELECT  NVL(MAX(f_num (fund_cd)),:ll_fund) + 10
  INTO  :ll_fund
FROM    szm0fd t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.fund_cd > TO_CHAR(:ll_fund);
  ll_fund = SQLCA.getitemnumber (1)

IF getrow ()>0 THEN ls_series = Object.series_gb [getrow ()]

SELECT  sintak_gigan
      , bosu_gb
      , bosu_gigan
  INTO  :ldc_sintak_gigan
      , :ls_bosu_gb
      , :ldc_bosu_gigan
FROM    aams.szx0se t1
WHERE   t1.corp_gr   = :gaa.corp_gr
  AND   t1.series_gb = :ls_series;
  ldc_sintak_gigan = SQLCA.getitemnumber (1)
  ls_bosu_gb       = SQLCA.getitemstring (2)
  ldc_bosu_gigan   = SQLCA.getitemnumber (3)
IF SQLCA.sqlcode ()<>0  Then
   ls_bosu_gb        = null_s
   ldc_sintak_gigan  = null_dc
   ldc_bosu_gigan    = null_dc
End IF

uf_SetColumn ("series_gb", ls_series)
uf_SetColumn ("sintak_gigan", f_nvl (string (ldc_sintak_gigan),''))
uf_SetColumn ("bosu_gb", f_nvl (ls_bosu_gb,''))
uf_SetColumn ("bosu_gigan1", f_nvl (string (ldc_bosu_gigan),''))

uf_SetColumn ("fund_cd", string (ll_fund))
uf_SetColumn ("fst_seolj_ymd", string (idt_workdate))
uf_SetColumn ("bf_bosu_ymd1",  string (idt_workdate))
uf_SetColumn ('bf_gyul_ymd', string (datetime (RelativeDate (date (idt_workdate), -1))))
uf_SetColumn ('af_bosu_ymd1', string (f_add_months (idt_workdate, ldc_bosu_gigan, null_dt)))
uf_SetColumn ('af_gyul_ymd', string (f_add_months (datetime (RelativeDate (date (idt_workdate), -1)), ldc_sintak_gigan, null_dt)))
uf_SetColumn ("gyul_gi", '1')
uf_SetColumn ("unit_gb", '1')
uf_SetColumn ("moja_gb", '1')
uf_SetColumn ("kukje_gb", '1')
uf_SetColumn ("sangj_gb", 'B')
uf_SetColumn ("witak_gb", '1')
uf_SetColumn ("bosuinchul_gb", '2')
uf_SetColumn ("fund_siga_gb", 'Y')
uf_SetColumn ('low_apply', '2')
uf_SetColumn ('seolj_g','1')
uf_SetColumn ('seolj_t','1')
uf_SetColumn ('haeji_g','1')
uf_SetColumn ('haeji_t','1')
uf_SetColumn ('haeji_g3','1')
uf_SetColumn ('haeji_t3','1')
uf_SetColumn ('samu_cd','80005')
uf_SetColumn ('fund_currency','KRW')
uf_SetColumn ('rowprotect','0')

POST SetColumn ('fund_nm')

RETURN 0
end event

event dw_list::itemchanged_next;call super::itemchanged_next;CHOOSE CASE name
   CASE 'seolj_aek'
      IF Object.fund_currency [row]='KRW' Then
         IF Object.seolj_jwa [row]=Object.seolj_aek [row]   Then
            Object.trans_unit [row] = 1000
            Object.fst_gijun_ga [row] = 1000
         Else
            Object.trans_unit [row] = 1
            Object.fst_gijun_ga [row] = Object.jwa_danga [row]
         End IF
      Else
         Object.trans_unit [row] = 1000
         Object.fst_gijun_ga [row] = 10
      End IF
END CHOOSE
end event

