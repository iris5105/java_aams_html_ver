forward
global type w_ja032c from wt_vertdetail
end type
type st_right from pf_u_splitbar_horizontal within w_ja032c
end type
type dw_right from u_dw within w_ja032c
end type
end forward

global type w_ja032c from wt_vertdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
string is_init_value = "변동수준"
boolean ib_managedata = false
st_right st_right
dw_right dw_right
end type
global w_ja032c w_ja032c

type variables
LONG	dRow
STRING	is_put_jm_cd
end variables

forward prototypes
public function double wf_cdf (double arg_x)
public subroutine uf_com (integer row, decimal sigma)
end prototypes

public function double wf_cdf (double arg_x);//double	t, a, result
//double	b1 = 0.319381530;
//double	b2 = -0.356563782;
//double	b3 = 1.781477937;
//double	b4 = -1.821255978;
//double	b5 = 1.330274429;
//double	p = 0.2316419;
//double	c = 0.39894228;
//
//IF	arg_x >= 0	Then
//	t = 1.0 / (1.0 + p * arg_x);
//   a = ((((b5 * t + b4) * t + b3) * t + b2) * t + b1) * t;
//   result = 1.0 - c * EXP(-x * arg_x / 2.0) * a;
//Else
//	result = 1.0 - wf_cdf(-arg_x);
//End IF
//
//RETURN result;


double result
double pi = 3.141592653589793
double erf_value

// 에르미트 함수 계산 (근사 방법)
erf_value = 2 / sqrt(pi) * Exp(-arg_x * arg_x / 2)  // 근사값 계산

// 정규분포 CDF 계산
result = 0.5 * (1 + erf_value)
    
return result
end function

public subroutine uf_com (integer row, decimal sigma);IF	f_num (sigma)=0	Then
	f_messagebox ('ERR','내재변동성 계산오류')
	dw_right.object.call_delta [row] = NULL_DC
	dw_right.object.put_delta [row]  = NULL_DC
	dw_right.object.gamma [row]      = NULL_DC
	dw_right.object.vega [row]       = NULL_DC
	dw_right.object.call_theta [row] = NULL_DC
	dw_right.object.put_theta [row]  = NULL_DC
	dw_right.object.call_rho [row]   = NULL_DC
	dw_right.object.put_rho [row]    = NULL_DC
	dw_right.POST setcolumn ('market_price')
	RETURN 
End IF

DEC	S, K, T, r
DEC	call_delta, put_delta, gamma, vega, call_theta, put_theta, call_rho, put_rho

S = dw_right.object.S [row]
K = dw_right.object.K [row]
T = dw_right.object.T [row]
r = dw_right.object.r [row]

SELECT t1.CALL_DELTA  /* _1- */
	  , t1.PUT_DELTA   /* _2- */
	  , t1.GAMMA       /* _3- */
	  , t1.VEGA        /* _4- */
	  , t1.CALL_THETA  /* _5- */
	  , t1.PUT_THETA   /* _6- */
	  , t1.CALL_RHO    /* _7- */
	  , t1.PUT_RHO     /* _8- */
  INTO :call_delta  /* _1- */
	  , :put_delta   /* _2- */
	  , :gamma       /* _3- */
	  , :vega        /* _4- */
	  , :call_theta  /* _5- */
	  , :put_theta   /* _6- */
	  , :call_rho    /* _7- */
	  , :put_rho     /* _8- */
  FROM TABLE(F_DGTVR_COM (:S, :T, :K, :r, :sigma)) t1 ;

dw_right.object.call_delta [row] = SQLCA.GETITEMNUMBER (1)
dw_right.object.put_delta [row]  = SQLCA.GETITEMNUMBER (2)
dw_right.object.gamma [row]      = SQLCA.GETITEMNUMBER (3)
dw_right.object.vega [row]       = SQLCA.GETITEMNUMBER (4)
dw_right.object.call_theta [row] = SQLCA.GETITEMNUMBER (5)
dw_right.object.put_theta [row]  = SQLCA.GETITEMNUMBER (6)
dw_right.object.call_rho [row]   = SQLCA.GETITEMNUMBER (7)
dw_right.object.put_rho [row]    = SQLCA.GETITEMNUMBER (8)

end subroutine

on w_ja032c.create
int iCurrent
call super::create
this.st_right=create st_right
this.dw_right=create dw_right
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_right
this.Control[iCurrent+2]=this.dw_right
end on

on w_ja032c.destroy
call super::destroy
destroy(this.st_right)
destroy(this.dw_right)
end on

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.CORP_GR, dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_clear;call super::wue_clear;dw_right.uf_clear ()
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1]  = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event ue_setenabled;call super::ue_setenabled;dw_right.of_dw2subbtn ({'p_load','p_save','p_input','p_copy','p_delete','p_priorpage','p_nextpage','p_firstpage','p_lastpage'}, false)
dw_right.of_dw2subbtn ({'p_excel'}, true)
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032c
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032c
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032c
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032c
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032c
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032c
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032c
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032c
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032c
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032c
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032c
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032c
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032c
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032c
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032c
end type

type p_close from wt_vertdetail`p_close within w_ja032c
end type

type p_excel from wt_vertdetail`p_excel within w_ja032c
end type

type p_print from wt_vertdetail`p_print within w_ja032c
end type

type p_delete from wt_vertdetail`p_delete within w_ja032c
end type

type p_update from wt_vertdetail`p_update within w_ja032c
end type

type p_input from wt_vertdetail`p_input within w_ja032c
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032c
end type

type p_clear from wt_vertdetail`p_clear within w_ja032c
end type

type p_copy from wt_vertdetail`p_copy within w_ja032c
end type

type dw_c from wt_vertdetail`dw_c within w_ja032c
string title = "기준일자@조회구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', '', '변동수준,변동수준,,괴리율,괴리율,,베타,베타,,델타/감마/세타/베가/로,델타/감마/세타/베가/로,,상승/하락일수,상승/하락일수,', 1, '')
end event

type btn_update from wt_vertdetail`btn_update within w_ja032c
end type

type st_count from wt_vertdetail`st_count within w_ja032c
end type

type dw_list from wt_vertdetail`dw_list within w_ja032c
integer height = 2412
string dataobject = "d_ja032c1"
boolean hscrollbar = true
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tt', '', '', 1, '')
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;//if dw_list.object.tt[row] = 'A' THEN
//	dw_detail
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja032c
integer height = 1208
string dataobject = "d_ja032c2"
string islist4subbtnauth = "0010001001"
string setlist4fontpointcolor = "line_color=a=a"
string setlist4rowpointcolor = "line_color=a=c"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;STRING	ls_title, ls_gubun
long ll_row

ls_title = dw_list.object.tt [iRow]

ls_gubun = dw_list.object.tt [iRow]

	if ls_gubun = 'A' then
      	uf_dataobject ('d_ja032c2_krx', FALSE)
	else
      	uf_dataobject ('d_ja032c2', FALSE)
	end if
	
SELECT sebu_cd_efnm
  INTO :ls_title
  FROM SZX0GR t1
 WHERE t1.gr_cd   = 'TT'
   AND t1.sebu_cd = :ls_title ;

ls_title = SQLCA.GETITEMSTRING (1)

MODIFY ("tt_volatility_t.text = '" + ls_title + "~r~n변동성'")
MODIFY ("put_price_t.text = '" + ls_title + "PUT~r~n행사가격'")

ll_row = retrieve (gaa.CORP_GR, dw_list.object.tymd[iRow], dw_list.object.fund_cd [iRow], dw_list.object.port_num [iRow])

// 조회된 데이터가 없다면 우측 DW 강제 초기화
IF ll_row = 0 THEN
	dw_right.uf_reset()
END IF

end event

event dw_detail::rowfocuschanged_if;call super::rowfocuschanged_if;dRow = currentrow

IF dRow <= 0 THEN
	dw_right.uf_reset()
	RETURN 0
END IF

gaa.jm_cd = Object.yj_cd [dRow]

dw_right.uf_reset ()
dw_right.POST EVENT ue_retrieve ()

RETURN 0
end event

event dw_detail::doubleclicked;IF	row>0 And dwo.name='xx_yj_cd'	Then
	::Clipboard ( string (Object.srs_cd [row]) )
	gw_mdi.setmicrohelp (string (Object.srs_cd [row]) + '...doubleclicked cllpBoard에 복사 ' + dataobject)
Else
	call super::doubleclicked
End IF
end event

type st_move from wt_vertdetail`st_move within w_ja032c
boolean leftmaxsizefixed = true
string rightdragobject = "dw_detail;st_right;dw_right"
end type

type st_right from pf_u_splitbar_horizontal within w_ja032c
integer x = 2601
integer y = 1564
integer width = 2830
boolean bringtotop = true
boolean setcondcolor = true
string topdragobject = "dw_detail"
string bottomdragobject = "dw_right"
end type

type dw_right from u_dw within w_ja032c
integer x = 2601
integer y = 1588
integer width = 2830
integer height = 1176
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ja032c3_dgtvr"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0010000000"
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;DEC   ldc_hangsa_ga, ldc_jonga
DEC   S, K, T, r, imp_volatility

DATETIME ldt_mangi, ldt_ymd

STRING   ls_title, ls_gubun

ls_title = dw_list.object.tt [iRow]

SELECT sebu_cd_efnm
  INTO :ls_title
  FROM SZX0GR t1
 WHERE t1.gr_cd   = 'TT'
   AND t1.sebu_cd = :ls_title ;

ls_title = SQLCA.GETITEMSTRING (1)

ls_gubun = dw_list.object.tt[iRow]



CHOOSE CASE dw_c.object.dddw [1]
 CASE '베타'
	ibsetlist4singleselect = false
	if ls_gubun = 'A' then
      	uf_dataobject ('d_ja032c3_beta_krx', FALSE)
      	retrieve (gaa.CORP_GR,'kospi_jisu', dw_detail.object.yj_cd [dRow], dw_list.object.fymd [iRow], dw_list.object.tymd [iRow])
	else
      	uf_dataobject ('d_ja032c3_beta', FALSE)
      	retrieve (gaa.CORP_GR,'S&P500', dw_detail.object.yj_cd [dRow], dw_list.object.fymd [iRow], dw_list.object.tymd [iRow])
	end if
   CASE '델타/감마/세타/베가/로'
      ibsetlist4singleselect = false
	if ls_gubun = 'A' then
		F_MESSAGEBOX('INFO','현재 한국 시장 주식은 옵션이 없습니다.')
//      	uf_dataobject ('d_ja032c3_dgtvr_krx', FALSE)
//      	retrieve (gaa.CORP_GR, dw_list.object.tymd [iRow], dw_list.object.fund_cd [iRow], dw_list.object.port_num [iRow], dw_detail.object.jm_cd [dRow])
//	    is_put_jm_cd = dw_detail.object.jm_cd [dRow]
		RETURN
    else
      	uf_dataobject ('d_ja032c3_dgtvr', FALSE)
      	retrieve (gaa.CORP_GR, dw_list.object.tymd [iRow], dw_list.object.fund_cd [iRow], dw_list.object.port_num [iRow], dw_detail.object.yj_cd [dRow])

		is_put_jm_cd = dw_detail.object.srs_cd [dRow]
	end if
    
	 IF dw_list.object.mangi [iRow]=idt_workdate  Then
         F_MESSAGEBOX ('INFO','당일만기입니다.')
         RETURN
      END IF

      ldt_ymd      = dw_c.object.ymd [1]

      ldt_mangi    = dw_list.object.mangi [iRow]

      SELECT CASE When TO_CHAR (:ldt_mangi,'w')='3' THEN ''
                                                    ELSE TO_CHAR (:ldt_mangi,'w')
             END || :is_put_jm_cd || SRS_MM || TO_CHAR (:ldt_mangi,'yy') || ' P%'
        INTO :is_put_jm_cd
        FROM SZX0YM t1
       WHERE t1.YMD_GB = 'M'
         AND t1.YMD_ID = TO_CHAR(:ldt_mangi,'mm') ;

      is_put_jm_cd = SQLCA.GETITEMSTRING (1)

      ldc_hangsa_ga = Object.k [1]

      SELECT jm_cd
        INTO :is_put_jm_cd
        FROM ( SELECT jm_cd
                    , ABS(hangsa_ga - :ldc_hangsa_ga)  AS diff
                 FROM SYM0YA h1
                WHERE jm_cd LIKE :is_put_jm_cd ) t1
       ORDER BY diff
       FETCH FIRST 1 ROWS ONLY ;

      IF SQLCA.SQLCode ( )=0  Then
         is_put_jm_cd = SQLCA.GETITEMSTRING (1)

         Object.put_jm_cd [1] = is_put_jm_cd

         SELECT JONGA
           INTO :ldc_jonga
           FROM SYT0LP t1
          WHERE t1.YMD     = :ldt_ymd
            AND t1.JM_CD   = :is_put_jm_cd
            AND t1.CORP_GR = :gaa.CORP_GR ;

         ldc_jonga               = SQLCA.GETITEMNUMBER (1)
         Object.market_price [1] = ldc_jonga

         S = Object.S [1]
         K = Object.K [1]
         T = Object.T [1]
         r = Object.r [1]

         SELECT F_IMP_VOLATILITY (:S, :K, :T, :r, :ldc_jonga) INTO :imp_volatility FROM DUAL;
         imp_volatility = SQLCA.GETITEMNUMBER (1)

         Object.imp_volatility [1] = imp_volatility

         uf_com (1, imp_volatility)
		Else
			F_MESSAGEBOX ('INFO', string (dw_detail.object.xx_yj_cd [dRow]) + '종목 옵션 종가가 없습니다.~r~n행사가 또는 시장가를 입력하면 내재변동성이 계산됩니다.')
      END IF

   CASE '상승/하락일수'
	IF ls_gubun = 'A' THEN
		ibsetlist4singleselect = true
     	uf_dataobject ('d_ja032c3_ud_krx', FALSE)
      	retrieve (gaa.CORP_GR, dw_detail.object.yj_cd [dRow], dw_list.object.fymd [iRow], dw_list.object.tymd [iRow])
	ELSE	
      	ibsetlist4singleselect = true
      	uf_dataobject ('d_ja032c3_ud', FALSE)
      	retrieve (gaa.CORP_GR, dw_detail.object.yj_cd [dRow], dw_list.object.fymd [iRow], dw_list.object.tymd [iRow])
	END IF
   CASE ELSE
      ibsetlist4singleselect = true
      uf_dataobject ('d_ja032c3', FALSE)

      retrieve (gaa.CORP_GR, dw_detail.object.yj_cd [dRow], dw_list.object.fymd [iRow], dw_list.object.tymd [iRow], dw_c.object.dddw [1])
 END CHOOSE

end event

event constructor;uf_date_nation (is_date_nation)
call super::constructor
end event

event ue_protect;call super::ue_protect;uf_protect (row, ia_protect [1])
end event

event itemchanged;call super::itemchanged;DEC	S, K, T, r, market_price,imp_volatility
DATETIME	ldt_mangi, ldt_ymd

imp_volatility = Object.imp_volatility [1]

S = Object.S [1]
T = Object.T [1]
K = Object.K [1]
r = Object.r [1]

CHOOSE CASE DWO.NAME
   CASE 'k'
      ldt_ymd      = dw_c.object.ymd [1]
      is_put_jm_cd = dw_detail.object.srs_cd [dRow]
      ldt_mangi    = dw_list.object.mangi [iRow]

      SELECT CASE WHEN TO_CHAR (:ldt_mangi,'w')='3' THEN ''
                                                    ELSE TO_CHAR (:ldt_mangi,'w')
             END || :is_put_jm_cd || SRS_MM || TO_CHAR (:ldt_mangi,'yy') || ' P%'
        INTO :is_put_jm_cd
        FROM SZX0YM t1
       WHERE t1.YMD_GB = 'M'
         AND t1.YMD_ID = TO_CHAR(:ldt_mangi,'mm') ;

      is_put_jm_cd = SQLCA.GETITEMSTRING (1)

      DEC	ldc_hangsa_ga, ldc_jonga

      ldc_hangsa_ga = dec (data)

      SELECT jm_cd
        INTO :is_put_jm_cd
        FROM (SELECT jm_cd
                   , ABS(hangsa_ga - :ldc_hangsa_ga)  AS diff
                FROM SYM0YA h1
               WHERE jm_cd LIKE :is_put_jm_cd) t1 
       ORDER BY diff
       FETCH FIRST 1 ROWS ONLY ;

      is_put_jm_cd = SQLCA.GETITEMSTRING (1)

      Object.put_jm_cd [1] = is_put_jm_cd
      IF f_notnull (is_put_jm_cd)   Then
         SELECT JONGA
           INTO :ldc_jonga
           FROM SYT0LP t1
          WHERE t1.CORP_GR = :gaa.CORP_GR
            AND t1.YMD     = :ldt_ymd
            AND t1.JM_CD   = :is_put_jm_cd ;

         ldc_jonga = SQLCA.GETITEMNUMBER (1)

         Object.market_price [1] = ldc_jonga

			K = dec (data)

         SELECT F_IMP_VOLATILITY (:S, :K, :T, :r, :ldc_jonga) INTO :imp_volatility FROM DUAL;
         imp_volatility = SQLCA.GETITEMNUMBER (1)

         Object.imp_volatility [1] = imp_volatility
      END IF

   CASE 'market_price'
      market_price = dec (data)
      SELECT F_IMP_VOLATILITY (:S, :K, :T, :r, :market_price) INTO :imp_volatility FROM DUAL;
      imp_volatility              = SQLCA.GETITEMNUMBER (1)
      Object.imp_volatility [row] = imp_volatility

   CASE 'imp_volatility'
      imp_volatility = dec (data)
END CHOOSE

IF imp_volatility=0 THEN imp_volatility = Object.year_sigma [1]

uf_com (ROW, imp_volatility)
IF	imp_volatility=-999	Then
	Object.imp_volatility [row] = null_dc
	f_messageBox ('ERR', '시장가격이 0에 수렴하여 내재변동성을 계산 할 수 없습니다.')
End IF
end event

