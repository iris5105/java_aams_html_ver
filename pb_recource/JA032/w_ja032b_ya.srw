forward
global type w_ja032b_ya from wt_listdetail
end type
type cb_1 from pf_u_commandbutton within w_ja032b_ya
end type
type cbx_2 from pf_u_checkbox within w_ja032b_ya
end type
end forward

global type w_ja032b_ya from wt_listdetail
boolean eb_direct_retrieve = true
integer ii_dddw_width = 750
integer ii_dddw_width2 = 240
string is_date_nation = "US"
boolean ib_managedata = false
cb_1 cb_1
cbx_2 cbx_2
end type
global w_ja032b_ya w_ja032b_ya

type variables
DATETIME	idt_f
end variables

on w_ja032b_ya.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cbx_2=create cbx_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_2
end on

on w_ja032b_ya.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cbx_2)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1]   = idt_workdate
dw_c.object.dddw [1]  = gaa.fund_cd
dw_c.object.dddw2 [1] = '1'

STRING   ls_dddw

SELECT LISTAGG(port_num || ',' || port_num,',,') 
  INTO :ls_dddw
  FROM USPM_PORT t1
 WHERE CORP_GR = :gaa.CORP_GR
   AND fund_cd = :gaa.fund_cd
   AND tymd    = :idt_workdate
 ORDER BY port_num ;

ls_dddw = SQLCA.GETITEMSTRING (1)

f_dddwctl (dw_c, 'dddw2 | dual', gaa.CORP_GR, ls_dddw + ',', 1, "")
end event

event wue_retrieve;call super::wue_retrieve;STRING   ls_fund, ls_port, ls_tt

idt_f   = dw_c.object.ymd [1]
ls_fund = dw_c.object.dddw [1]
ls_port = dw_c.object.dddw2 [1]

SELECT FYMD
     , TT
  INTO :idt_f
     , :ls_tt
  FROM USPM_PORT t1
 WHERE t1.CORP_GR  = :gaa.CORP_GR
   AND t1.FUND_CD  = :ls_fund
   AND t1.PORT_NUM = :ls_port
   AND t1.TYMD     = :idt_f ;

idt_f = SQLCA.GETITEMDATETIME (1)
ls_tt = SQLCA.GETITEMSTRING (2)

dw_list.retrieve (gaa.CORP_GR, idt_f, dw_c.object.ymd [1], ls_tt)
end event

event ue_activate;call super::ue_activate;STRING   ls_dddw

SELECT LISTAGG(port_num || ',' || port_num,',,') 
  INTO :ls_dddw
  FROM USPM_PORT t1
 WHERE CORP_GR = :gaa.CORP_GR
   AND fund_cd = :gaa.fund_cd
   AND tymd    = :idt_workdate
 ORDER BY port_num ;

ls_dddw = SQLCA.GETITEMSTRING (1)

f_dddwctl (dw_c, 'dddw2 | dual', gaa.CORP_GR, ls_dddw + ',', 1, "")
end event

event wue_clear;call super::wue_clear;cbx_2.enabled = false
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032b_ya
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032b_ya
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032b_ya
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032b_ya
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032b_ya
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032b_ya
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032b_ya
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032b_ya
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032b_ya
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032b_ya
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032b_ya
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032b_ya
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032b_ya
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032b_ya
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032b_ya
end type

type p_close from wt_listdetail`p_close within w_ja032b_ya
end type

type p_excel from wt_listdetail`p_excel within w_ja032b_ya
end type

type p_print from wt_listdetail`p_print within w_ja032b_ya
end type

type p_delete from wt_listdetail`p_delete within w_ja032b_ya
end type

type p_update from wt_listdetail`p_update within w_ja032b_ya
end type

type p_input from wt_listdetail`p_input within w_ja032b_ya
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032b_ya
end type

type p_clear from wt_listdetail`p_clear within w_ja032b_ya
end type

type p_copy from wt_listdetail`p_copy within w_ja032b_ya
end type

type dw_c from wt_listdetail`dw_c within w_ja032b_ya
integer x = 46
string title = "조회기준일@일괄등록펀드@포트"
string dataobject = "dc_ymd_dddw2"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | uspm_fund', gaa.corp_gr, '', 1, "t1.CORP_GR='" + gaa.corp_gr + "' And t1.TR_YMD='" + string (idt_workdate,'yyyy.mm.dd') + "'")

end event

event dw_c::itemfocuschanged;call super::itemfocuschanged;DATETIME	ldt
STRING   ls_dddw

IF	dwo.name='dddw2'	Then
	gaa.fund_cd = Object.dddw [1]

	SELECT LISTAGG(port_num || ',' || port_num,',,') 
	  INTO :ls_dddw
	  FROM USPM_PORT t1
	 WHERE CORP_GR = :gaa.CORP_GR
		AND fund_cd = :gaa.fund_cd
		AND tymd    = :idt_workdate
	 ORDER BY port_num ;

	ls_dddw = SQLCA.GETITEMSTRING (1)

	f_dddwctl (dw_c, 'dddw2 | dual', gaa.CORP_GR, ls_dddw + ',', 1, "")
	Object.dddw2 [1] = '1'
End IF
end event

type btn_update from wt_listdetail`btn_update within w_ja032b_ya
end type

type st_count from wt_listdetail`st_count within w_ja032b_ya
end type

type dw_list from wt_listdetail`dw_list within w_ja032b_ya
integer height = 820
string dataobject = "d_ja032b_ya"
string setlist4fontpointcolor = "tuja_yn=Y=a"
string setlist4rowpointcolor = "tuja_yn=Y=c"
end type

event dw_list::ue_protect;call super::ue_protect;SetTabOrder ('chk',10)
end event

event dw_list::retrieveend;call super::retrieveend;cbx_2.enabled = true
end event

type dw_detail from wt_listdetail`dw_detail within w_ja032b_ya
integer y = 1192
integer height = 1572
string dataobject = "d_ja032b_dd"
string islist4subbtnauth = "0010001001"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;IF	POS (dw_list.object.yj_cd [iRow],':')=0	Then
	uf_dataobject ('d_ja032b_dd_krx', FALSE)
Else
	uf_dataobject ('d_ja032b_dd', FALSE)
End IF
retrieve (gaa.CORP_GR, dw_list.object.yj_cd [iRow], idt_f, dw_c.object.ymd [1])

end event

type st_move from wt_listdetail`st_move within w_ja032b_ya
integer y = 1172
end type

type cb_1 from pf_u_commandbutton within w_ja032b_ya
integer x = 3113
integer y = 184
integer width = 562
integer height = 108
integer taborder = 110
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "선택종목일괄등록"
end type

event clicked;call super::clicked;LONG  ll, ll_list, ll_col

DATETIME fymd

BOOLEAN  lb_chk

STRING   ls_fund, ls_port, ls_jm_cd, ls_cd

ls_fund = dw_c.object.dddw [1]
ls_port = dw_c.object.dddw2 [1]

ll_list = dw_list.ROWCOUNT ( )

FOR  ll = 1  TO  ll_list
   IF dw_list.object.chk [ll]='1'   Then
      IF lb_chk=false   Then
         IF F_MESSAGEBOX ('INFO2', ls_fund + ' 펀드 포트 ' + ls_port + ' 에 선택한 종목을 등록 하시겠습니까?')=2 THEN RETURN
         lb_chk = true
      END IF

      SELECT NVL(MAX(col),0) 
        INTO :ll_col
        FROM USPM t1
       WHERE t1.CORP_GR  = :gaa.CORP_GR
         AND t1.FUND_CD  = :ls_fund
         AND t1.YMD      = :idt_workdate
         AND t1.PORT_NUM = :ls_port ;

      ll_col   = SQLCA.GETITEMNUMBER (1)
      ls_jm_cd = dw_list.object.yj_cd [ll]
      ls_cd    = dw_list.object.ovrs_excg_cd [ll]

      INSERT INTO USPM
          ( CORP_GR       /* _1- */
          , YMD           /* _2- */
          , FUND_CD       /* _3- */
          , PORT_NUM      /* _4- */
          , JM_CD         /* _5- */
          , COL           /* _6- */
          , OVRS_EXCG_CD  /* _7- */
          )
      VALUES ( :gaa.CORP_GR   /* _1- */
             , :idt_workdate  /* _2- */
             , :ls_fund       /* _3- */
             , :ls_port       /* _4- */
             , :ls_jm_cd      /* _5- */
             , :ll_col + 1    /* _6- */
             , :ls_cd         /* _7- */
             ) ;

      dw_list.object.chk [ll] = '0'
   END IF
NEXT

IF lb_chk   Then
   F_MESSAGEBOX ('INFO','선택한 종목을 일괄등록 했습니다.~r~n(중복된 종목은 제외됨)')
   commitJ ( )
ELSE
   F_MESSAGEBOX ('ERR','종목을 선택 후 일괄등록 처리 하십시오')
END IF
end event

type cbx_2 from pf_u_checkbox within w_ja032b_ya
integer x = 3771
integer y = 196
integer width = 558
boolean bringtotop = true
boolean enabled = false
string text = "기준정보등록종목"
boolean setcondcolor = true
end type

event clicked;call super::clicked;IF	Checked	Then
	dw_list.setfilter ("tuja_yn = 'Y'")
Else
	dw_list.setfilter ("")
End IF
dw_list.filter ()
end event

