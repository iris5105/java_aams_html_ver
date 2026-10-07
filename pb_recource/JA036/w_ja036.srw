forward
global type w_ja036 from wt_listshare
end type
type cb_ija from pf_u_commandbutton within w_ja036
end type
type dw_1 from u_dw within w_ja036
end type
type cb_kfs from pf_u_commandbutton within w_ja036
end type
type dw_xls from fw_u_dwo within w_ja036
end type
end forward

global type w_ja036 from wt_listshare
boolean eb_direct_retrieve = true
cb_ija cb_ija
dw_1 dw_1
cb_kfs cb_kfs
dw_xls dw_xls
end type
global w_ja036 w_ja036

on w_ja036.create
int iCurrent
call super::create
this.cb_ija=create cb_ija
this.dw_1=create dw_1
this.cb_kfs=create cb_kfs
this.dw_xls=create dw_xls
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ija
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_kfs
this.Control[iCurrent+4]=this.dw_xls
end on

on w_ja036.destroy
call super::destroy
destroy(this.cb_ija)
destroy(this.dw_1)
destroy(this.cb_kfs)
destroy(this.dw_xls)
end on

event ue_setenabled;call super::ue_setenabled;IF dw_list.rowcount ()>0 And dw_1.ibsetlist4subbtn Then
	dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
	dw_1.of_dw2subbtn ({'p_input'}, (dw_1.enabled And dw_1.eb_new_false=FALSE And ib_managedata))
	dw_1.of_dw2subbtn ({'p_copy'}, (dw_1.enabled And dw_1.eb_copy_false=FALSE And ib_managedata))
	dw_1.of_dw2subbtn ({'p_delete'}, (dw_1.enabled And dw_1.eb_delete_false=FALSE And ib_managedata))

ElseIF dw_list.rowcount ()=0 And dw_1.ibsetlist4subbtn	Then
	dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
End IF
end event

event wue_postopen;call super::wue_postopen;dw_1.SetTransObject (SQLCA)
end event

event resize;call super::resize;dw_1.x = dw_list.width + 85
dw_1.height = dw_list.height - 90

dw_master.x = dw_1.x - 4250
end event

event ue_wpage_modified;IF	isvalid (idw_list)	Then
	RETURN   idw_list.uf_ismodified () OR dw_1.uf_isModified ()
Else
	RETURN false
End IF
end event

event wue_update;call super::wue_update;IF AncestorReturnVALUE=-1 THEN RETURN -1
IF dw_1.uf_update ()=FALSE THEN RETURN -1
RETURN 1
end event

event wue_clear;call super::wue_clear;IF dw_1.ibsetlist4subbtn THEN dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
end event

event open;icmdbutton = { cb_ija, cb_kfs }
IF	NOT gaa.aams THEN cb_kfs.of_setvisible (false)
call super::open
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr)
end event

type lb_dirlist from wt_listshare`lb_dirlist within w_ja036
end type

type ln_templeft from wt_listshare`ln_templeft within w_ja036
end type

type ln_tempbuttom from wt_listshare`ln_tempbuttom within w_ja036
end type

type ln_temptop from wt_listshare`ln_temptop within w_ja036
end type

type ln_tempbutton from wt_listshare`ln_tempbutton within w_ja036
end type

type ln_tempstart from wt_listshare`ln_tempstart within w_ja036
end type

type ln_cond1_yline from wt_listshare`ln_cond1_yline within w_ja036
end type

type ln_dw1_yline from wt_listshare`ln_dw1_yline within w_ja036
end type

type ln_cond2_yline from wt_listshare`ln_cond2_yline within w_ja036
end type

type ln_dw2_yline from wt_listshare`ln_dw2_yline within w_ja036
end type

type ln_tempright from wt_listshare`ln_tempright within w_ja036
end type

type uo_navi from wt_listshare`uo_navi within w_ja036
end type

type ln_temptop_shadow from wt_listshare`ln_temptop_shadow within w_ja036
end type

type st_windelaytime from wt_listshare`st_windelaytime within w_ja036
end type

type st_top_rect from wt_listshare`st_top_rect within w_ja036
end type

type p_close from wt_listshare`p_close within w_ja036
end type

type p_excel from wt_listshare`p_excel within w_ja036
end type

type p_print from wt_listshare`p_print within w_ja036
end type

type p_delete from wt_listshare`p_delete within w_ja036
end type

type p_update from wt_listshare`p_update within w_ja036
end type

type p_input from wt_listshare`p_input within w_ja036
end type

type p_retrieve from wt_listshare`p_retrieve within w_ja036
end type

type p_clear from wt_listshare`p_clear within w_ja036
end type

type p_copy from wt_listshare`p_copy within w_ja036
end type

type dw_c from wt_listshare`dw_c within w_ja036
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_listshare`btn_update within w_ja036
end type

type st_count from wt_listshare`st_count within w_ja036
end type

type dw_list from wt_listshare`dw_list within w_ja036
integer y = 156
integer width = 2505
integer height = 2608
string dataobject = "d_ja0361"
string setlist4fontpointcolor = "siga_agent=S=c"
string setlist4rowpointcolor = "days_calc_gb=2=e"
end type

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;dw_1.uf_reset ()
dw_1.EVENT ue_retrieve ()
RETURN 0
end event

event dw_list::rowfocuschanging_return;call super::rowfocuschanging_return;IF dw_1.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;uf_dddwctl ('balh_nation | nation_cd', dw_master, 'balh_nation', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('currency', dw_master, 'currency', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('sj_gb | sj_gubun', dw_master, 'sj_gb', gaa.CORP_GR, '', 2, '')
uf_dddwctl ('ija_bdc', dw_master, 'ija_bdc', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('ija_dcf', dw_master, 'ija_dcf', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('ija_jigub_gb', dw_master, 'ija_jigub_gb', gaa.CORP_GR, '', 1, "sebu_cd in ('1','4','7','Z')")
uf_dddwctl ('jasan_attr', dw_master, 'jasan_attr', gaa.CORP_GR, '', 1, "substr (sebu_cd,1,1) IN ('1','2')")
uf_dddwctl ('fen0055', dw_master, 'fen0055', gaa.CORP_GR, '', 1, "regexp_like(sebu_cd,'^[78]')")
uf_dddwctl ('days_calc_gb', dw_master, 'days_calc_gb', gaa.CORP_GR, '', 1, '')
uf_dddwctl ('siga_agent', dw_master, 'siga_agent', gaa.CORP_GR, '', 1, '')
f_dddwctl (dw_master, 'jasan', gaa.CORP_GR, ",입력없음,", 1, "sebu_cd='ZZ0'")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('jasan_gb', '2')
uf_setColumn ('sj_gubun', '1')
uf_setColumn ('js_jongryu', '1')
uf_setColumn ('ija_BDC', '+')
uf_setColumn ('ija_DCF', '3')
uf_setColumn ('yy_ija_hoisu', '4')
uf_setColumn ('ija_jigub_gb', '7')
uf_setColumn ('tax_per', '0')
uf_setColumn ('siga_agent', 'B')
uf_setColumn ('days_calc_gb', '1')

//POST SetColumn ('jm_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF GETITEMSTATUS (ROW, 0, PRIMARY!) = NEW! OR GETITEMSTATUS (ROW, 0, PRIMARY!) = NEWMODIFIED! OR gaa.aams  Then
//   f_setprotect (THIS, FALSE, { 'balh_nation', 'jm_cd', 'jm_nm', 'seq_no', 'currency' })
   f_setprotect (dw_master, FALSE, { 'balh_nation', 'jm_cd', 'jm_nm', 'seq_no', 'currency' })
ELSE
//   f_setprotect (THIS, TRUE, { 'balh_nation', 'jm_cd', 'jm_nm', 'seq_no', 'currency' })
   f_setprotect (dw_master, TRUE, { 'balh_nation', 'jm_cd', 'jm_nm', 'seq_no', 'currency' })
END IF
end event

type dw_master from wt_listshare`dw_master within w_ja036
integer x = 1271
integer y = 1504
integer width = 4119
integer height = 1120
string dataobject = "d_ja0362"
end type

event dw_master::itemchanged;call super::itemchanged;STRING	ls_cur

IF DWO.NAME = 'balh_nation'   Then
   SELECT currency
     INTO :ls_cur
     FROM SZX0WA t1
    WHERE t1.nation_cd = :data ;
   IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
END IF
end event

type cb_ija from pf_u_commandbutton within w_ja036
integer x = 2272
integer y = 16
integer width = 489
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "구간이자생성"
end type

event clicked;STRING	ls_sr_err_msg, la_args[]

IF dw_1.rowcount ()=0 Then
   IF f_messageBox ('RUN', '구간이자 생성')=2 THEN RETURN
Else
   IF f_messageBox ('RUN', '구간이자 재생성(기존구간 삭제)')=2 THEN RETURN
End IF

la_args[1] = gaa.corp_gr
la_args[2] = string (idt_workdate, 'yyyy.mm.dd')
la_args[3] = dw_list.object.jm_cd [iRow]
SQLCA.singleconnection ()
SQLCA.SP_CALL( THIS, 'SR_SYJ0IG ( ?, ?, ? )', la_args[], ls_sr_err_msg )
dw_1.reset ()
dw_1.postevent ('ue_retrieve')

end event

type dw_1 from u_dw within w_ja036
integer x = 2565
integer y = 156
integer width = 2866
integer height = 436
integer taborder = 110
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_syj0ig"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean ibsetlist4subbtn = true
boolean eb_null_line = false
end type

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt, ldt_2, ldt_f_param1, ldt_f_param2

LONG	ll, lR, ll_dd, ll_f_value

lR = iRow

CHOOSE CASE dwo.name
   CASE 'bf_ija_ymd'
		ldt_f_param1 = datetime(date(MID(data,1,10)))
		ldt_f_param2 = Object.af_ija_ymd[row]

		IF	dw_list.object.days_calc_gb [iRow]='1'	Then
			SELECT F_DAYS (:ldt_f_param1, :ldt_f_param2)
			  INTO :ll_f_value
			FROM   dual;
		Else
			SELECT F_DAYS (:ldt_f_param1 - 1, :ldt_f_param2)
			  INTO :ll_f_value
			FROM   dual;
		End IF
		ll_f_value = SQLCA.getitemnumber (1)
      Object.gugan_ilsu [row] = ll_f_value

	CASE 'af_ija_ymd'
      ldt = datetime (date (MID (data,1,10)))

		ldt_f_param1 = Object.bf_ija_ymd[row]
		IF	dw_list.object.days_calc_gb [iRow]='1'	Then
			SELECT F_DAYS (:ldt_f_param1, :ldt)
			  INTO :ll_f_value
			FROM   dual;
		Else
			SELECT F_DAYS (:ldt_f_param1 - 1, :ldt)
			  INTO :ll_f_value
			FROM   dual;
		End IF

		ll_f_value = SQLCA.getitemnumber (1)

      Object.gugan_ilsu [row] = ll_f_value

      FOR  ll = row + 1  TO  rowcount ()
         Object.ip_user [ll] = 'ymd_com'
         Object.ip_ymd [ll] = f_sysdate ('')

			IF	dw_list.object.days_calc_gb [iRow]='1'	Then
	         Object.bf_ija_ymd [ll] = ldt
			Else
				SELECT :ldt + 1
				  INTO :ldt_2
				FROM   dual;

				ldt_2 = SQLCA.getitemdatetime (1)

	         Object.bf_ija_ymd [ll] = ldt_2
			End IF

         ldt = f_add_months (ldt, 12 / dw_list.object.yy_ija_hoisu [lR], null_dt)
			ldt_f_param1 = Object.bf_ija_ymd[ll]

			IF	dw_list.object.days_calc_gb [iRow]='1'	Then
				SELECT F_DAYS (:ldt_f_param1, :ldt)
				  INTO :ll_f_value
				FROM   dual;
			Else
				SELECT F_DAYS (:ldt_f_param1 - 1, :ldt)
				  INTO :ll_f_value
				FROM   dual;
			End IF

			ll_f_value = SQLCA.getitemnumber (1)

         ll_dd = ll_f_value

         IF ldt>dw_list.object.sanghw_ymd [lR] Then
            Object.af_ija_ymd [ll] = dw_list.object.sanghw_ymd [lR]
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]
				
				IF	dw_list.object.days_calc_gb [iRow]='1'	Then
					SELECT F_DAYS (:ldt_f_param1, :ldt_f_param2)
					  INTO :ll_f_value
					FROM   dual;
				Else
					SELECT F_DAYS (:ldt_f_param1 - 1, :ldt_f_param2)
					  INTO :ll_f_value
					FROM   dual;
				End IF

				ll_f_value = SQLCA.getitemnumber (1)

            Object.gugan_ilsu [ll] = ll_f_value
            IF ll>1 THEN Object.gugan_ija [ll] = Object.gugan_ija [ll - 1] / ll_dd * Object.gugan_ilsu [ll];
            EXIT
         Else
            Object.af_ija_ymd [ll] = ldt
         End IF
         Object.gugan_ilsu [ll] = ll_dd
      NEXT
END CHOOSE
object.ip_user [row] = gnv_vari.is_user_id
Object.ip_ymd [row] = f_sysdate ('')
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_list.object.jm_cd [iRow], dw_list.object.now_gugan_no [iRow])
end event

event ue_insertstart;call super::ue_insertstart;uf_setcolumn ('jm_cd', dw_list.object.jm_cd [iRow])
RETURN 0
end event

event doubleclicked;DateTime  ldt, ldt_f_param1, ldt_f_param2

LONG	ll, lR, ll_f_value

STRING	 ls_f_param1

lR = iRow

CHOOSE CASE dwo.name
   CASE 'gugan_ilsu_t'
      FOR  ll = 1  TO  rowcount ()
         Object.gugan_ija [ll] = dw_list.object.ija_per [iRow] / 36500 * Object.gugan_ilsu [ll]
      NEXT
      RETURN
   CASE 'gugan_ilsu'
      Object.gugan_ija [row] = dw_list.object.ija_per [iRow] / 36500 * Object.gugan_ilsu [row]
      RETURN
   CASE 'af_ija_ymd'
      IF row=rowcount ()   Then
         IF f_num (dw_list.object.now_gugan_no [lR])=0  Then
            f_messageBox ('ERR', '현재구간이 없습니다.(상환일기준 이자구간 변경)')
            RETURN
         End IF
         IF f_messageBox ('I002','상환일기준으로 이자구간 변경작업 하시겠습니까')=2 THEN RETURN

         ldt = Object.af_ija_ymd [row]
         FOR  ll = rowcount ()  TO  dw_list.object.now_gugan_no [lR]  STEP -1
            Object.ip_user [ll] = 'ymd_com'
            Object.ip_ymd [ll] = f_sysdate ('')

            ldt = f_add_months (ldt, (12 / dw_list.object.yy_ija_hoisu [lR]) * -1, null_dt)
            Object.bf_ija_ymd [ll] = ldt
				ls_f_param1  = dw_list.object.ija_dcf[lR]
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]

				IF	dw_list.object.days_calc_gb [iRow]='1'	Then
					SELECT F_DCF_ILSU( :ls_f_param1, :ldt_f_param1, :ldt_f_param2 )
					  INTO :ll_f_value
					FROM   dual;
				Else
					SELECT F_DCF_ILSU( :ls_f_param1, :ldt_f_param1 - 1, :ldt_f_param2 )
					  INTO :ll_f_value
					FROM   dual;
				End IF

				ll_f_value = SQLCA.getitemnumber (1)

            Object.gugan_ilsu [ll] = ll_f_value
            IF ll>1 THEN Object.af_ija_ymd [ll - 1] = ldt
         NEXT
         Object.gugan_ija [row] = Object.gugan_ija [row - 1]
         object.ip_user [row] = gnv_vari.is_user_id
         Object.ip_ymd [row] = f_sysdate ('')
      End IF
		RETURN
END CHOOSE
CALL super::doubleclicked
end event

type cb_kfs from pf_u_commandbutton within w_ja036
integer x = 2775
integer y = 16
integer width = 457
integer taborder = 60
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "종목(KFS)"
end type

event clicked;DELETE FROM SYM0YA_LOAD;
DELETE FROM SYM0YA_KAP_LOAD;
commitJ ()

aDS_jTier   lds_jtier

STRING	ls_kap1, ls_kap2

setJtier ('DBNAME', 'icam_main')
IF setJtier('URL', 'http://183.96.184.1:15700/jtier?') > 0 Then
   SQLCA.sql2ds (this.classname(), "  SELECT * FROM SYM0YA f1 ", lds_jtier, 'xml')
   ls_kap1 = 'c:\temp\SYM0YA_LOAD.txt'
   lds_jtier.SaveAs (ls_kap1, Text!, TRUE, EncodingUTF16LE!)

   SQLCA.sql2ds (this.classname(), "  SELECT * FROM SYM0YA_KAP f1 ", lds_jtier, 'xml')
   ls_kap2 = 'c:\temp\SYM0YA_KAP_LOAD.txt'
   lds_jtier.SaveAs (ls_kap2, Text!, TRUE, EncodingUTF16LE!)
END IF

f_jtier_connect ()

IF FileExists (ls_kap1) Then
   dw_xls.dataobject = 'd_sym0ya_load'
   dw_xls.SETTRANSOBJECT (SQLCA)
   dw_xls.reset ()
   dw_xls.importfile (ls_kap1, 2)
   dw_xls.UPDATE ()
   dw_xls.dataobject = 'd_sym0ya_kap_load'
   dw_xls.SETTRANSOBJECT (SQLCA)
   dw_xls.reset ()
   dw_xls.importfile (ls_kap2, 2)
   dw_xls.UPDATE ()
END IF

DEC	ldc_kap = 0

//INSERT INTO SYM0YA
//  SELECT *
//    FROM SYM0YA_LOAD t1
//   WHERE CORP_GR||JM_CD NOT IN (SELECT CORP_GR || JM_CD FROM SYM0YA ta) ;

//ldc_kap = SQLCA.sqlnrows ()

INSERT INTO SYM0YA_KAP
  SELECT *
    FROM SYM0YA_KAP_LOAD t1
   WHERE BONDID NOT IN (SELECT BONDID FROM SYM0YA_KAP ta) ;

ldc_kap += SQLCA.sqlnrows ()

commitJ ()

F_MESSAGEBOX ('INFO', '채권종목(' + f_n#(ldc_kap, 0, 0) + ' 건) LOAD를 완료했습니다.')
end event

type dw_xls from fw_u_dwo within w_ja036
boolean visible = false
integer x = 3250
integer y = 740
integer width = 2903
integer height = 1704
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_sjx0jb_load"
boolean livescroll = false
end type

