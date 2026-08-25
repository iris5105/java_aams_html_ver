forward
global type w_ja032e_call from wt_vertdetail
end type
type st_port from pf_u_splitbar_horizontal within w_ja032e_call
end type
type dw_port from u_dw within w_ja032e_call
end type
type cb_recom from pf_u_commandbutton within w_ja032e_call
end type
type cb_syt0mg from pf_u_commandbutton within w_ja032e_call
end type
end forward

global type w_ja032e_call from wt_vertdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
string is_init_value = "00003"
st_port st_port
dw_port dw_port
cb_recom cb_recom
cb_syt0mg cb_syt0mg
end type
global w_ja032e_call w_ja032e_call

type variables
LONG	il_port
end variables

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

on w_ja032e_call.create
int iCurrent
call super::create
this.st_port=create st_port
this.dw_port=create dw_port
this.cb_recom=create cb_recom
this.cb_syt0mg=create cb_syt0mg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_port
this.Control[iCurrent+2]=this.dw_port
this.Control[iCurrent+3]=this.cb_recom
this.Control[iCurrent+4]=this.cb_syt0mg
end on

on w_ja032e_call.destroy
call super::destroy
destroy(this.st_port)
destroy(this.dw_port)
destroy(this.cb_recom)
destroy(this.cb_syt0mg)
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event ue_wpage_modified;IF	dw_list.uf_isModified ()=FALSE And dw_port.uf_isModified ()=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1]  = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_update;call super::wue_update;IF dw_list.ACCEPTTEXT ()=-1 OR dw_port.ACCEPTTEXT ()=-1	Then
   F_MESSAGEBOX ('W006', '')
   RETURN -1
END IF

IF EVENT ue_wpage_modified () Then
   IF uf_UpdateCommit (dw_list, dw_port)=-1 THEN RETURN -1
END IF

commitJ ()
RETURN 1
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032e_call
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032e_call
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032e_call
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032e_call
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032e_call
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032e_call
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032e_call
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032e_call
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032e_call
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032e_call
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032e_call
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032e_call
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032e_call
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032e_call
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032e_call
end type

type p_close from wt_vertdetail`p_close within w_ja032e_call
end type

type p_excel from wt_vertdetail`p_excel within w_ja032e_call
end type

type p_print from wt_vertdetail`p_print within w_ja032e_call
end type

type p_delete from wt_vertdetail`p_delete within w_ja032e_call
end type

type p_update from wt_vertdetail`p_update within w_ja032e_call
end type

type p_input from wt_vertdetail`p_input within w_ja032e_call
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032e_call
end type

type p_clear from wt_vertdetail`p_clear within w_ja032e_call
end type

type p_copy from wt_vertdetail`p_copy within w_ja032e_call
end type

type dw_c from wt_vertdetail`dw_c within w_ja032e_call
string title = "기준일자@매매처"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] = idt_workdate)
cb_recom.enabled = ib_managedata
RETURN true
end event

type btn_update from wt_vertdetail`btn_update within w_ja032e_call
end type

type st_count from wt_vertdetail`st_count within w_ja032e_call
end type

type dw_list from wt_vertdetail`dw_list within w_ja032e_call
string dataobject = "d_ja032e1_call"
boolean hscrollbar = true
end type

event dw_list::rowfocuschanged_if;iRow = currentrow

dw_port.setredraw (false)
dw_port.uf_reset ()
dw_port.event ue_retrieve ()

uf_enabled (eb_rowchangewait, false)
dw_detail.setredraw (false)
dw_detail.uf_reset ()
dw_detail.event ue_retrieve ()
dw_detail.setredraw (true)
uf_enabled (eb_rowchangewait, true)

RETURN 0
end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF	dw_port.uf_update ()=FALSE OR AncestorReturnValue=1 THEN RETURN 1
RETURN 0
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tt', '', '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

DATETIME	ldt_f, ldt_t

LONG	ll

CHOOSE CASE DWO.NAME
   CASE 'mangi_ymd'
      ldt_f = dw_c.object.ymd [1]
      ldt_t = DATETIME (DATE (MID (data,1,10)))

      SELECT f_days (:ldt_f, :ldt_t) INTO :ll FROM DUAL;

      Object.dt [row] = SQLCA.GETITEMNUMBER (1)

   CASE 'tt'
      ldt_f = dw_c.object.ymd [1]
      ldt_t = Object.mangi_ymd [row]

      SELECT f_days (:ldt_f, :ldt_t) INTO :ll FROM DUAL;

      Object.dt [row] = SQLCA.GETITEMNUMBER (1)
END CHOOSE
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja032e_call
integer y = 1236
integer height = 1528
string dataobject = "d_ja032e3_call"
string islist4subbtnauth = "0010000000"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;LONG	ll_p

STRING	ls_jm_cd
DATETIME	ldt_mangi

ll_p = dw_port.GETROW ()

ls_jm_cd = dw_port.object.srs_cd [ll_p]

ldt_mangi = dw_list.object.mangi_ymd [iRow]

SELECT CASE WHEN TO_CHAR (:ldt_mangi,'w')='3' THEN ''
                                              ELSE TO_CHAR (:ldt_mangi,'w')
       END || :ls_jm_cd || SRS_MM || TO_CHAR (:ldt_mangi,'yy')
  INTO :ls_jm_cd
  FROM SZX0YM t1
 WHERE t1.YMD_GB = 'M'
   AND t1.YMD_ID = TO_CHAR(:ldt_mangi,'mm') ;

ls_jm_cd = SQLCA.GETITEMSTRING (1) + ' C%'

retrieve (gaa.CORP_GR, dw_c.object.ymd [1], ls_jm_cd, dw_port.object.target_return_per [ll_p], dw_port.object.jonga [ll_p], STRING (ldt_mangi, 'yyyymmdd'))
end event

event dw_detail::clicked;call super::clicked;LONG	ll
CHOOSE CASE dwo.name
	CASE 'tr_su'
		ll = dw_port.getrow ()
		Object.tr_su [row] = truncate (dw_port.object.stock_jusu [ll] * dw_port.object.rt [ll] / 100, 0)
END CHOOSE
end event

event dw_detail::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1
CHOOSE CASE dwo.name
	CASE 'order_gb'
		IF	data='매도'	Then
			Object.bid_ask [row] = Object.bid [row]
		Else
			Object.bid_ask [row] = Object.ask [row]
		End IF
END CHOOSE
end event

event dw_detail::move;call super::move;cb_syt0mg.x = X + 156
cb_syt0mg.y = Y - 106
end event

event dw_detail::rowfocuschanged_if;call super::rowfocuschanged_if;gaa.opt_cd = Object.opt_jm_cd [currentrow]
RETURN 0
end event

type st_move from wt_vertdetail`st_move within w_ja032e_call
boolean leftmaxsizefixed = true
string rightdragobject = "dw_detail;dw_port;st_port"
end type

type st_port from pf_u_splitbar_horizontal within w_ja032e_call
integer x = 2601
integer y = 1196
integer width = 2830
boolean bringtotop = true
boolean setcondcolor = true
string topdragobject = "dw_port"
string bottomdragobject = "dw_detail"
end type

type dw_port from u_dw within w_ja032e_call
integer x = 2601
integer y = 348
integer width = 2830
integer height = 840
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_ja032e2_call"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
string setlist4fontpointcolor = "line_color=a=a"
string setlist4rowpointcolor = "line_color=a=c"
boolean eb_range_delcopy = false
end type

event retrieveend;call super::retrieveend;IF	rowcount=0 THEN dw_detail.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;STRING	ls_title

ls_title = dw_list.object.tt [iRow]

SELECT sebu_cd_efnm
  INTO :ls_title
  FROM SZX0GR t1
 WHERE t1.gr_cd   = 'TT'
   AND t1.sebu_cd = :ls_title ;

ls_title = SQLCA.GETITEMSTRING (1)

MODIFY ("call_price_t.text = '" + ls_title + "CALL~r~n행사가격'")
retrieve (gaa.CORP_GR, dw_list.object.tymd [iRow], dw_list.object.fund_cd [iRow], dw_list.object.port_num [iRow])
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;LONG	ll

il_port = currentrow
gaa.jm_cd = Object.yj_cd [il_port]

dw_detail.setredraw (false)
dw_detail.uf_reset ()
dw_detail.event ue_retrieve ()
dw_detail.setredraw (true)
RETURN 0
end event

event itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1

LONG	ll

CHOOSE CASE dwo.name
	CASE 'target_return_per'
		IF	f_messagebox ('INFO2', '일괄 적용하시겠습니까?')=1	Then
			FOR  ll = 1  TO  rowcount ()
				IF row=ll THEN CONTINUE
				Object.target_return_per [ll] = dec (data)
			NEXT
		End IF
END CHOOSE

end event

event doubleclicked;IF	row>0 And dwo.name='xx_yj_cd'	Then
	::Clipboard ( string (Object.srs_cd [row]) )
	gw_mdi.setmicrohelp (string (Object.srs_cd [row]) + '...doubleclicked cllpBoard에 복사 ' + dataobject)
Else
	call super::doubleclicked
End IF
end event

event constructor;uf_date_nation (is_date_nation)
call super::constructor
end event

type cb_recom from pf_u_commandbutton within w_ja032e_call
integer x = 2382
integer y = 188
integer width = 530
integer taborder = 130
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "변동성재계산"
unsignedlong mouseoverfontcolor = 65535
end type

event clicked;enabled = false

f_loadingretrieve (TRUE)

EVENT wue_update ()

STRING	p_msg = SPACE (200), la_args []

la_args [1] = gaa.CORP_GR
la_args [2] = STRING (dw_c.object.ymd[1], 'yyyy.mm.dd')
la_args [3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'SR_JA032A ( ?, ?, ? )', la_args[], p_msg)

f_loadingretrieve (false)

p_msg = f_nvl (SQLCA.GETITEMPLSQL (1), 'N')
IF LEFT (p_msg,1) <> 'Y'   Then
   F_MESSAGEBOX ('SP00', STRING (SQLCA.SQLDBCode) + '~r~n' + SQLCA.SQLErrText())
ELSE
	F_MESSAGEBOX ('P000', '변경된 조건으로 ' + MID (p_msg, 3) + ' 완료!!!')
END IF

p_retrieve.POST EVENT clicked ()
enabled = true
end event

type cb_syt0mg from pf_u_commandbutton within w_ja032e_call
integer x = 2757
integer y = 1216
integer width = 471
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "CALL 배분생성"
end type

event clicked;call super::clicked;DEC   ldc_hangsa_ga, ldc_tr_seq, ldc_su, ldc_aek

LONG  ll, ll_cnt

STRING   ls_tr_co_cd, ls_tr_cd, ls_fund_cd, ls_yj_cd, ls_trustee, ls_jm_cd, ls_currency, ls_jm_nm

ls_tr_co_cd = dw_c.object.dddw [1]
ls_fund_cd  = dw_list.object.fund_cd [iRow]
ls_trustee  = '(' + dw_port.object.port_num [il_port] + ')'

ll_cnt = dw_detail.ROWCOUNT ()
FOR  ll =1  TO  ll_cnt
   IF f_notnull (dw_detail.object.order_gb [ll]) AND f_num (dw_detail.object.tr_su [ll])>0 AND f_num(dw_detail.object.bid_ask [ll])>0  Then
      ls_jm_cd      = dw_detail.object.opt_jm_cd [ll]
      ldc_hangsa_ga = dw_detail.object.hangsa_ga [ll]
      ls_yj_cd      = dw_port.object.yj_cd [il_port]
      ls_currency   = dw_port.object.currency [il_port]
      CHOOSE CASE dw_detail.object.order_gb [ll]
         CASE '매도'
				ls_tr_cd = 'S80'
         CASE '매수'
            ls_tr_cd = 'S70'
      END CHOOSE
      ldc_su  = dw_detail.object.tr_su [ll]
      ldc_aek = dw_detail.object.bid_ask [ll]

      SELECT NVL(MAX(tr_seq),0) + 1
        INTO :ldc_tr_seq
        FROM SYT1MG t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.TR_yMD  = :idt_workdate
         AND t1.FUND_CD = :ls_fund_cd
         AND t1.JM_CD   = :ls_jm_cd
         AND t1.TR_CD   = :ls_tr_cd ;

      ldc_tr_seq = SQLCA.GETITEMNUMBER (1)

      INSERT INTO SYT1MG
          ( CORP_GR     /* _1- */
          , TR_YMD      /* _2- */
          , TR_CD       /* _3- */
          , FUND_CD     /* _4- */
          , TR_CO_CD    /* _5- */
          , TRUSTEE     /* _6- */
          , JM_CD       /* _7- */
          , CURRENCY    /* _8- */
          , TR_SEQ      /* _9- */
          , TR_JUSU     /* _10- */
          , TR_DANGA    /* _11- */
          , TR_AEK      /* _12- */
          , TR_COST     /* _13- */
          , GYULJE_YMD  /* _14- */
          )
      VALUES ( :gaa.CORP_GR        /* _1- */
             , :idt_workdate       /* _2- */
             , :ls_tr_cd           /* _3- */
             , :ls_fund_cd         /* _4- */
             , :ls_tr_co_cd        /* _5- */
             , :ls_trustee         /* _6- */
             , :ls_jm_cd           /* _7- */
             , :ls_currency        /* _8- */
             , :ldc_tr_seq         /* _9- */
             , :ldc_su             /* _10- */
             , :ldc_aek            /* _11- */
             , :ldc_su * :ldc_aek  /* _12- */
             , 4                   /* _13- */
             , :idt_workdate       /* _14- */
             ) ;

      CHOOSE CASE LEFT (ls_jm_cd, 1)
         CASE '1'
            ls_jm_nm = f_replace (MID (ls_jm_cd, 2), ' C', '(1W) C')
         CASE '2'
            ls_jm_nm = f_replace (MID (ls_jm_cd, 2), ' C', '(2W) C')
         CASE '4'
            ls_jm_nm = f_replace (MID (ls_jm_cd, 2), ' C', '(4W) C')
         CASE '5'
            ls_jm_nm = f_replace (MID (ls_jm_cd, 2), ' C', '(5W) C')
         CASE ELSE
            ls_jm_nm = ls_jm_cd
      END CHOOSE
      ls_jm_nm = ls_jm_nm + '-' + dw_detail.object.mm [ll]

      // 파생종목정보 생성용
      INSERT INTO API_Q
          ( COMPANY        /* _1- */
          , URL            /* _2- */
          , HEADERS        /* _3- */
          , QUERYPARAMS    /* _4- */
          , TABLENAME      /* _5- */
          , SUBTABLE       /* _6- */
          , REQUEST        /* _7- */
          , API_KEY        /* _8- */
          , KEY_VALUE      /* _9- */
          , SUB_KEY_VALUE  /* _10- */
          , CORP_GR        /* _11- */
          , TR_YMD         /* _12- */
          , KEY1           /* _13- */
          , KEY2           /* _14- */
          , KEY3           /* _15- */
          , KEY4           /* _16- */
          , NUM1           /* _17- */
          )
        SELECT COMPANY                                                    /* _1- */
             , URL                                                        /* _2- */
             , HEADERS                                                    /* _3- */
             , '{ QRY_CNT: "1", SRS_CD_01: "' || :ls_jm_cd || '" }'       /* _4- */
             , TABLENAME                                                  /* _5- */
             , SUBTABLE                                                   /* _6- */
             , '0'                                                        /* _7- */
             , TO_CHAR(now (),'yyyymmdd') || '-' || RAWTOHEX(SYS_GUID())  /* _8- */
             , KEY_VALUE                                                  /* _9- */
             , SUB_KEY_VALUE                                              /* _10- */
             , :gaa.CORP_GR                                               /* _11- */
             , now ()                                                     /* _12- */
             , :ls_jm_cd                                                  /* _13- */
             , :ls_jm_nm                                                  /* _14- */
             , :ls_yj_cd                                                  /* _15- */
             , 'CALL'                                                     /* _16- */
             , :ldc_hangsa_ga                                             /* _17- */
          FROM API_PARAMS t1
         WHERE t1.GR_CD    = '17'
           AND t1.SCD      = '20'
           AND t1.TR_CO_CD = '00003'
           AND t1.COMPANY  = 'KB_REAL' ;

      dw_detail.object.order_gb [ll] = null_s
      dw_detail.object.tr_su [ll]    = null_dc
      dw_detail.object.bid_ask [ll]  = null_dc
   END IF
NEXT
commitJ ()

F_MESSAGEBOX ('INFO', '배분생성을 완료 했습니다.')
end event

