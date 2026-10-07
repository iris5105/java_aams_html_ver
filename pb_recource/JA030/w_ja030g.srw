forward
global type w_ja030g from wt_listdetail
end type
type cb_other from pf_u_commandbutton within w_ja030g
end type
end forward

global type w_ja030g from wt_listdetail
boolean eb_direct_retrieve = true
integer ii_dddw_width = 750
string is_init_value = "50"
cb_other cb_other
end type
global w_ja030g w_ja030g

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_List.retrieve (gaa.corp_gr, ia_value [1], dw_c.object.ymd [1])
cb_other.of_setenabled(TRUE)
end event

on w_ja030g.create
int iCurrent
call super::create
this.cb_other=create cb_other
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_other
end on

on w_ja030g.destroy
call super::destroy
destroy(this.cb_other)
end on

event wue_clear;call super::wue_clear;cb_other.of_setenabled(FALSE)
end event

event open;icmdbutton = { cb_other }
call super::open
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja030g
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja030g
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja030g
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja030g
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja030g
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja030g
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja030g
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja030g
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja030g
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja030g
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja030g
end type

type uo_navi from wt_listdetail`uo_navi within w_ja030g
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja030g
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja030g
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja030g
end type

type p_close from wt_listdetail`p_close within w_ja030g
end type

type p_excel from wt_listdetail`p_excel within w_ja030g
end type

type p_print from wt_listdetail`p_print within w_ja030g
end type

type p_delete from wt_listdetail`p_delete within w_ja030g
end type

type p_update from wt_listdetail`p_update within w_ja030g
end type

type p_input from wt_listdetail`p_input within w_ja030g
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja030g
end type

type p_clear from wt_listdetail`p_clear within w_ja030g
end type

type p_copy from wt_listdetail`p_copy within w_ja030g
end type

type dw_c from wt_listdetail`dw_c within w_ja030g
string title = "상환기준일@현금종류"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw | cash_cd', gaa.corp_gr, '%,전체,', 1, "sebu_cd != '90'")
end event

type btn_update from wt_listdetail`btn_update within w_ja030g
end type

type st_count from wt_listdetail`st_count within w_ja030g
end type

type dw_list from wt_listdetail`dw_list within w_ja030g
string dataobject = "d_ja030g1"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'cash_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'bojng_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'sunhu_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'meib_mk_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'sunhu_tax_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'tax_offer_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'daeyeo_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'broker_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'bojng_cd | tr_co_cd', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'offer_co_cd', gaa.corp_gr, '', 1, '')
end event

type dw_detail from wt_listdetail`dw_detail within w_ja030g
string title = "이자구간"
string dataobject = "d_shj0ig"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.jm_cd [iRow], dw_list.object.now_ija_hoicha [iRow])
end event

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

Datetime	ldt_bf, ldt, ldt_f_param1, ldt_f_param2

LONG	ll, ll_mm, ll_dd, ll_f_value

CHOOSE CASE dwo.name
   CASE 'bf_ija_ymd'
		
		ldt_f_param1 = datetime(date(MID(data,1,10)))
		ldt_f_param2 = Object.af_ija_ymd[row]
		SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)
		
      Object.gugan_ilsu [row] = ll_f_value
   CASE 'af_ija_ymd'
      ldt_bf = Object.bf_ija_ymd [row]
      ldt = datetime (date (MID (data,1,10)))

      IF f_num (Object.platform_fee [row])>0 THEN Object.platform_ymd [row] = ldt

      SELECT  round(months_between(:ldt, :ldt_bf))
        INTO  :ll_mm
      FROM    dual;
		
		ll_mm = SQLCA.getitemnumber (1)
		
      IF ll_mm=0 THEN ll_mm = 1

		SELECT F_DAYS( :ldt_bf, :ldt )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)

      Object.gugan_ilsu [row] = ll_f_value
      IF f_num (Object.fix_ija_aek [row])=0  Then
         Object.gugan_ija [row] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [row]
      Else
         Object.gugan_ija [row] = Object.fix_ija_aek [row] / dw_list.object.chui_aek [iRow]
      End IF

      FOR  ll = row + 1  TO  rowcount ()
			Object.ip_user [ll] = 'ymd_com'
         Object.ip_ymd [ll] = f_sysdate('')
         Object.bf_ija_ymd [ll] = ldt
         IF ll<= (dw_list.object.now_ija_hoicha [iRow] + 1) Then
				
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]
				SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2  )
				  INTO :ll_f_value
				FROM   DUAL;
				ll_f_value = SQLCA.getitemnumber (1)
				
            ll_dd = ll_f_value
            Object.gugan_ilsu [ll] = ll_dd
            IF f_num (Object.fix_ija_aek [ll])=0   Then
               Object.gugan_ija [ll] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [ll]
            Else
               Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
            End IF
            EXIT
         Else
            Object.af_ija_ymd [ll] = f_add_months (ldt, ll_mm, null_dt)
				
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]
				SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
				  INTO :ll_f_value
				FROM   DUAL;
				ll_f_value = SQLCA.getitemnumber (1)
				
            ll_dd = ll_f_value
            IF Object.af_ija_ymd [ll]>=dw_list.object.sanghw_ymd [iRow] Then
               Object.af_ija_ymd [ll] = dw_list.object.sanghw_ymd [iRow]
					
					ldt_f_param1 =  Object.bf_ija_ymd[ll]
					ldt_f_param2 =  Object.af_ija_ymd[ll]
					SELECT F_DAYS( :ldt_f_param1 , :ldt_f_param2 )
					  INTO :ll_f_value
					FROM   DUAL;
					ll_f_value = SQLCA.getitemnumber (1)
					
               Object.gugan_ilsu [ll] = ll_f_value
               IF f_num (Object.fix_ija_aek [ll])=0   Then
                  Object.gugan_ija [ll] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [ll]
               Else
                  Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
               End IF
               EXIT
            End IF
            Object.gugan_ilsu [ll] = ll_dd
            IF f_num (Object.fix_ija_aek [ll])=0   Then
               Object.gugan_ija [ll] = dw_list.object.pyom_iyul_per [iRow] / 36500 * Object.gugan_ilsu [ll]
            Else
               Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
            End IF
            ldt = Object.af_ija_ymd [ll]
         End IF
      NEXT
   CASE 'platform_fee'
      IF f_null (data)  Then
         Object.platform_ymd [row] = null_dt
      Else
         Object.platform_ymd [row] = Object.af_ija_ymd [row]
      End IF
   CASE 'fix_ija_aek'
      Object.gugan_ija [row] = dec (data) / dw_list.object.chui_aek [iRow]
END CHOOSE

object.ip_user [row] = gnv_vari.is_user_id
Object.ip_ymd [row] = f_sysdate('')
end event

event dw_detail::ue_insert;call super::ue_insert;LONG	ll

FOR  ll = 1  TO  rowcount ()
   Object.gugan_no [ll] = ll
NEXT

RETURN   AncestorReturnVALUE
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('jm_cd', dw_List.object.jm_cd [iRow])
RETURN 0
end event

event dw_detail::doubleclicked;CHOOSE CASE dwo.name
   CASE 'gugan_ilsu_t'
      LONG	ll
      FOR  ll = 1  TO  rowcount ()
         IF f_num (Object.fix_ija_aek [ll])=0   Then
            Object.gugan_ija [ll] = dw_list.object.pyom_iyul [dw_list.getrow ()] / 365 * Object.gugan_ilsu [ll]
         Else
            Object.gugan_ija [ll] = Object.fix_ija_aek [ll] / dw_list.object.chui_aek [iRow]
         End IF
      NEXT
      RETURN
   CASE 'gugan_ilsu'
      IF f_num (Object.fix_ija_aek [row])=0  Then
         Object.gugan_ija [row] = dw_list.object.pyom_iyul [dw_list.getrow ()] / 365 * Object.gugan_ilsu [row]
      Else
         Object.gugan_ija [row] = Object.fix_ija_aek [row] / dw_list.object.chui_aek [iRow]
      End IF
      RETURN
END CHOOSE
CALL super::doubleclicked
end event

type st_move from wt_listdetail`st_move within w_ja030g
end type

type cb_other from pf_u_commandbutton within w_ja030g
integer x = 2231
integer y = 16
integer width = 530
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "구간이자생성"
end type

event clicked;STRING	ls_jm_cd, ls_msg, la_args[]

dw_detail.reset ()

la_args[1] = gaa.corp_gr
la_args[2] = dw_List.object.jm_cd[dw_List.getrow ()]
la_args[3] = 'ok'

SQLCA.singleconnection ()
SQLCA.SP_CALL( THIS, 'SR_SHJ0IG ( ?, ?, ? )', la_args[], ls_msg )

dw_detail.postevent ('ue_retrieve')
end event

