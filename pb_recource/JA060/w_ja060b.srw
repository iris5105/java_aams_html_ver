forward
global type w_ja060b from wt_list
end type
type dw_info from u_dw within w_ja060b
end type
type cb_1 from pf_u_commandbutton within w_ja060b
end type
end forward

global type w_ja060b from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_init_value = "%"
boolean ib_managedata = false
dw_info dw_info
cb_1 cb_1
end type
global w_ja060b w_ja060b

type variables
DateTime	idt_bf, idt_to, idt_last

LONG	il_ok = 0, il_err = 0, il_tot = 0

STRING	is_status
end variables

on w_ja060b.create
int iCurrent
call super::create
this.dw_info=create dw_info
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_info
this.Control[iCurrent+2]=this.cb_1
end on

on w_ja060b.destroy
call super::destroy
destroy(this.dw_info)
destroy(this.cb_1)
end on

event wue_lastopen;call super::wue_lastopen;SELECT  max(ymd)
  INTO  :idt_to
FROM    sics_fund t1
WHERE   t1.corp_gr = :gaa.corp_gr;

idt_last = SQLCA.getitemdatetime (1)

dw_c.object.ym [1] = string (idt_last,'yyyymm')
dw_c.object.dddw [1] = ia_value [1]

dw_info.insertrow (0)
end event

event wue_retrieve;call super::wue_retrieve;STRING	ls_ym

ls_ym = dw_c.object.ym [1]

SELECT  last_day(to_date (:ls_ym,'yyyymm'))
  INTO  :idt_to
FROM    dual;

idt_to = SQLCA.getitemdatetime (1)

SELECT  max(ymd)
  INTO  :idt_bf
FROM    sics_fund t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.ymd     < :idt_to;

idt_bf = SQLCA.getitemdatetime (1)
IF isNull (idt_bf)   Then
   SELECT  min(fst_seolj_ymd)
     INTO  :idt_bf
   FROM    szm0ia t1
   WHERE   t1.corp_gr = :gaa.corp_gr;

   idt_bf = SQLCA.getitemdatetime (1)
	IF	f_null (idt_last) THEN idt_last = idt_bf
	dw_c.modify ("tag_text.text='" + string (idt_bf, '최초설정 yyyy년 mm월') + "에서 부터 생성년월 구간 운용보고서 생성'")
Else
	dw_c.modify ("tag_text.text='" + string (idt_bf, '최종생성 yyyy년 mm월') + "에서 부터 생성년월 구간 운용보고서 생성'")
End IF
cb_1.of_setenabled ((idt_last <= idt_to))

il_ok = 0
il_err = 0
il_tot = 0

ia_value [1] = dw_c.object.dddw [1]

dw_list.retrieve (gaa.corp_gr, idt_to, ia_value [1])
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja060b
end type

type ln_templeft from wt_list`ln_templeft within w_ja060b
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja060b
end type

type ln_temptop from wt_list`ln_temptop within w_ja060b
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja060b
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja060b
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja060b
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja060b
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja060b
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja060b
end type

type ln_tempright from wt_list`ln_tempright within w_ja060b
end type

type uo_navi from wt_list`uo_navi within w_ja060b
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja060b
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja060b
end type

type st_top_rect from wt_list`st_top_rect within w_ja060b
end type

type p_close from wt_list`p_close within w_ja060b
end type

type p_excel from wt_list`p_excel within w_ja060b
end type

type p_print from wt_list`p_print within w_ja060b
end type

type p_delete from wt_list`p_delete within w_ja060b
end type

type p_update from wt_list`p_update within w_ja060b
end type

type p_input from wt_list`p_input within w_ja060b
end type

type p_retrieve from wt_list`p_retrieve within w_ja060b
end type

type p_clear from wt_list`p_clear within w_ja060b
end type

type p_copy from wt_list`p_copy within w_ja060b
end type

type dw_c from wt_list`dw_c within w_ja060b
string tag = "최종생성 : 2021년 01월"
string title = "보고서생성년월@증권사"
string dataobject = "dc_dddw_ym"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw', gaa.corp_gr, "%,전체,", 2, "tr_co_cd in (select mg_cd from szm0ia where corp_gr='" + gaa.corp_gr + "')")
end event

type btn_update from wt_list`btn_update within w_ja060b
end type

type st_count from wt_list`st_count within w_ja060b
end type

type dw_list from wt_list`dw_list within w_ja060b
integer y = 644
integer height = 2120
string dataobject = "d_ja060b2"
boolean ibsetlist4excelclip = false
boolean eb_fund_default_change = false
string is_resize_column = "re_create_bigo"
end type

event dw_list::retrieveend;call super::retrieveend;IF	rowcount=il_ok	Then
	cb_1.text = '계좌재생성'
	dw_info.modify ("t_status.text='생성완료건수 : " + f_ntrim (rowcount,0,0) + " 건'")
Else
	cb_1.text = '일괄생성'
	dw_info.modify ("t_status.text='조회건수 : " + f_ntrim (rowcount,0,0) + ' 건  /  생성완료 : ' + f_ntrim (il_ok,0,0) + ' 건  /  생성대기 : ' + f_ntrim (il_err,0,0) + " 건'" )
End IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'ja_mg_cd | tr_co_cd', gaa.corp_gr, '', 1, '')
end event

event dw_list::retrieverow;call super::retrieverow;IF	f_null (Object.create_dt [row])	Then
	il_err ++
Else
	il_ok ++
End IF
il_tot ++
end event

event dw_list::clicked;call super::clicked;IF	NOT cb_1.enabled THEN RETURN

LONG	ll, ll_cnt

BOOLEAN	lb_check = true
STRING	ls_button

CHOOSE CASE dwo.name
	CASE 'chk_t'
		ll_cnt = rowcount ()
		IF	FIND ("chk='1'", 1, ll_cnt)=0	Then
			FOR  ll = 1  TO  ll_cnt
				Object.chk [ll] = '1'
				IF	f_null (Object.create_dt [ll]) THEN lb_check = false
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
			IF	lb_check THEN
				cb_1.text = '점검재생성'
			Else
				cb_1.text = '일괄생성'
			End IF
		Else
			FOR  ll = 1  TO  ll_cnt
				Object.chk [ll] = '0'
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		End IF
	CASE 'chk'
		cb_1.text = '계좌재생성'
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF	cb_1.enabled THEN uf_protect (row, ia_protect [1])
end event

type dw_info from u_dw within w_ja060b
integer x = 50
integer y = 348
integer width = 5381
integer height = 288
integer taborder = 30
boolean bringtotop = true
boolean enabled = true
string dataobject = "d_ja060b1"
boolean scaletoright = true
boolean ibdesign4cond = true
boolean setfocusdw = false
boolean setedittoken = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
end type

type cb_1 from pf_u_commandbutton within w_ja060b
integer x = 242
integer y = 420
integer width = 471
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "일괄생성"
end type

event clicked;call super::clicked;STRING	ls_sp, w_msg, la_args[]

LONG	ll, ll_list

ls_sp	= 'SR_JA060B ( ?, ?, ?, ?, ?, ? )'

CHOOSE CASE TEXT
	CASE '일괄생성'
		la_args[4] = 'all'
	CASE '계좌재생성'
		la_args[4] = 'force'
	CASE '점검재생성'
		la_args[4] = 'check'
END CHOOSE

ll_list = dw_list.rowcount ()
ll = dw_list.FIND ("chk='1'", 1, ll_list)
IF	ll=0	Then
	f_messageBox ('ERR', '선택계좌가 없습니다.')
	RETURN
End IF

of_setenabled (false)

f_loadingchart (true)

la_args[1] = gaa.corp_gr
la_args[5] = gnv_vari.is_user_nm
la_args[6] = 'ref'
FOR  ll = ll  TO  ll_list
	yield ()
	dw_list.uf_setrow (ll, true)
	IF	dw_list.object.chk [ll]='1'	Then
		la_args[2] = dw_list.object.fund_cd [ll]
		la_args[3] = string (idt_to, 'yyyy.mm.dd')
		SQLCA.singleconnection ('Y')
		SQLCA.SP_CALL (THIS, ls_sp, la_args[], w_msg)
		w_msg = SQLCA.getitemplsql (1)
		IF	POS (w_msg,'no update')=0	Then
			IF	f_null (dw_list.object.create_dt [ll])	Then
				dw_list.object.create_dt [ll] = f_sysdate ('')
			Else
				dw_list.object.re_create_dt [ll] = f_sysdate ('')
			End IF
		End IF
		dw_list.object.re_create_bigo [ll] = w_msg
	End IF
	IF	ll<ll_list	Then
		ll = dw_list.FIND ("chk='1'", ll + 1, ll_list) - 1
		IF	ll<1 THEN EXIT
	End IF
NEXT

of_setenabled (true)
f_loadingchart (false)

commitJ ()

f_messageBox ('INFO', '운용보고서 생성을 완료 했습니다.')
end event

