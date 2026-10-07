forward
global type w_ja032o from wt_listdetail
end type
type cb_syt0mg from pf_u_commandbutton within w_ja032o
end type
end forward

global type w_ja032o from wt_listdetail
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "fund_cd=~'~'"
cb_syt0mg cb_syt0mg
end type
global w_ja032o w_ja032o

type variables

end variables

event wue_retrieve;call super::wue_retrieve;is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.CORP_GR, dw_c.object.ymd [1])
end event

on w_ja032o.create
int iCurrent
call super::create
this.cb_syt0mg=create cb_syt0mg
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_syt0mg
end on

on w_ja032o.destroy
call super::destroy
destroy(this.cb_syt0mg)
end on

event ue_activate;call super::ue_activate;IF dw_list.enabled THEN dw_list.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

event wue_postopen;call super::wue_postopen;dw_c.object.ymd [1] = idt_workdate
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032o
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032o
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032o
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032o
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032o
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032o
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032o
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032o
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032o
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032o
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032o
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032o
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032o
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032o
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032o
end type

type p_close from wt_listdetail`p_close within w_ja032o
end type

type p_excel from wt_listdetail`p_excel within w_ja032o
end type

type p_print from wt_listdetail`p_print within w_ja032o
end type

type p_delete from wt_listdetail`p_delete within w_ja032o
end type

type p_update from wt_listdetail`p_update within w_ja032o
end type

type p_input from wt_listdetail`p_input within w_ja032o
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032o
end type

type p_clear from wt_listdetail`p_clear within w_ja032o
end type

type p_copy from wt_listdetail`p_copy within w_ja032o
end type

type dw_c from wt_listdetail`dw_c within w_ja032o
string title = "기준일자"
string dataobject = "dc_ymd"
end type

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.ymd [1] = idt_workdate)
RETURN true
end event

type btn_update from wt_listdetail`btn_update within w_ja032o
end type

type st_count from wt_listdetail`st_count within w_ja032o
end type

type dw_list from wt_listdetail`dw_list within w_ja032o
string dataobject = "d_ja032o1"
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tt', '', '', 1, '')
end event

type dw_detail from wt_listdetail`dw_detail within w_ja032o
string dataobject = "d_ja032o2"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.CORP_GR, dw_list.object.tr_ymd [iRow], dw_list.object.fund_cd [iRow], dw_list.object.port_num [iRow], string (dw_list.object.mangi [iRow],'yyyymmdd'))
end event

event dw_detail::clicked;call super::clicked;CHOOSE CASE dwo.name
	CASE 'order_su'
		Object.order_su [row] = Object.tr_jusu [row]
END CHOOSE
end event

type st_move from wt_listdetail`st_move within w_ja032o
end type

type cb_syt0mg from pf_u_commandbutton within w_ja032o
integer x = 1202
integer y = 188
integer width = 375
integer taborder = 60
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "주문생성"
end type

event clicked;call super::clicked;DEC   ldc_tr_seq, ldc_su, ldc_aek
LONG  ll, ll_cnt

STRING   ls_tr_co_cd, ls_tr_cd, ls_fund_cd, ls_yj_cd, ls_trustee, ls_jm_cd, ls_currency

ls_tr_co_cd = dw_c.object.dddw [1]
ls_fund_cd  = dw_list.object.fund_cd [iRow]
ls_trustee  = '(' + dw_list.object.port_num [iRow] + ')'

ll_cnt = dw_detail.ROWCOUNT ( )
FOR  ll =1  TO  ll_cnt
   IF f_notnull (dw_detail.object.order_gb [ll]) AND f_num (dw_detail.object.order_su [ll])>0 AND f_num(dw_detail.object.order_aek [ll])>0   Then
      ls_jm_cd    = dw_detail.object.jm_cd [ll]
      ls_yj_cd    = dw_detail.object.yj_cd [ll]
      ls_currency = dw_detail.object.currency [ll]
      ls_tr_cd    = dw_detail.object.tr_cd [ll]
      ldc_su      = dw_detail.object.order_su [ll]
      ldc_aek     = dw_detail.object.order_aek [ll]

      SELECT NVL(MAX(tr_seq),0) + 1
        INTO :ldc_tr_seq
        FROM SYT1MG t1
       WHERE t1.TR_yMD  = :idt_workdate
         AND t1.FUND_CD = :ls_fund_cd
         AND t1.JM_CD   = :ls_jm_cd
         AND t1.TR_CD   = :ls_tr_cd
         AND t1.CORP_GR = :gaa.CORP_GR ;

      ldc_tr_seq = SQLCA.GETITEMNUMBER (1)

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
          , TR_AEK
          , TR_COST
          , GYULJE_YMD
          )
      
      VALUES ( :gaa.CORP_GR
             , :idt_workdate
             , :ls_tr_cd
             , :ls_fund_cd
             , :ls_tr_co_cd
             , :ls_trustee
             , :ls_jm_cd
             , :ls_currency
             , :ldc_tr_seq
             , :ldc_su
             , :ldc_aek
             , :ldc_su * :ldc_aek
             , 4
             , :idt_workdate
             ) ;

      dw_detail.object.order_jusu [ll] = null_dc
      dw_detail.object.order_aek [ll]  = null_dc
   END IF
NEXT
commitJ ( )

F_MESSAGEBOX ('INFO','환매수 생성을 완료 했습니다.')
end event

