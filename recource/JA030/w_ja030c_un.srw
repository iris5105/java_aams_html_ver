forward
global type w_ja030c_un from wt_listdetail
end type
end forward

global type w_ja030c_un from wt_listdetail
integer ii_dddw_width = 750
string is_init_value = "J14"
end type
global w_ja030c_un w_ja030c_un

type variables

end variables

on w_ja030c_un.create
int iCurrent
call super::create
end on

on w_ja030c_un.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja030c_un
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja030c_un
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja030c_un
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja030c_un
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja030c_un
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja030c_un
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja030c_un
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja030c_un
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja030c_un
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja030c_un
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja030c_un
end type

type uo_navi from wt_listdetail`uo_navi within w_ja030c_un
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja030c_un
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja030c_un
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja030c_un
end type

type p_close from wt_listdetail`p_close within w_ja030c_un
end type

type p_excel from wt_listdetail`p_excel within w_ja030c_un
end type

type p_print from wt_listdetail`p_print within w_ja030c_un
end type

type p_delete from wt_listdetail`p_delete within w_ja030c_un
end type

type p_update from wt_listdetail`p_update within w_ja030c_un
end type

type p_input from wt_listdetail`p_input within w_ja030c_un
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja030c_un
end type

type p_clear from wt_listdetail`p_clear within w_ja030c_un
end type

type p_copy from wt_listdetail`p_copy within w_ja030c_un
end type

type dw_c from wt_listdetail`dw_c within w_ja030c_un
string title = "영업일자@매매구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA030C'")

end event

event dw_c::ue_valid;call super::ue_valid;ia_value [1] = Object.dddw[1]
ib_manageData = (uf_initdate ('inputdate') <= Object.ymd[1])
RETURN TRUE
end event

event dw_c::ue_getdate;INT   li_ret = 0

STRING	ls_tr_cd

ls_tr_cd = Object.dddw [1]

SELECT  1
  INTO  :li_ret
FROM    sct0ci t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   tr_ymd     = :rs_ymd
  AND   tr_cd      = :ls_tr_cd
  AND   ROWNUM = 1;
  li_ret = SQLCA.getitemnumber (1)

RETURN  li_ret
end event

type btn_update from wt_listdetail`btn_update within w_ja030c_un
end type

type st_count from wt_listdetail`st_count within w_ja030c_un
end type

type dw_list from wt_listdetail`dw_list within w_ja030c_un
string dataobject = "d_ja030c1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, lRowCount

lRowCount = dw_detail.rowcount ()

CHOOSE CASE dwo.name
   CASE 'sudo_ymd'
      IF Datetime (Date (MidA (data,1,10)))<dw_c.object.ymd [1] THEN
         RETURN uf_itemerr (row, 'sudo_ymd', '수도결제일이 거래일보다 작습니다.')
      End IF
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.sudo_ymd [lRow] = Datetime (Date (MidA (data,1,10)))
      NEXT
   CASE 'meib_danga'
      Object.tr_aek [row] = dec (data) * Object.ccom_aekm [row]
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.danga [lRow] = dec (data)
         dw_detail.object.tr_aek [lRow] = truncate (Object.tr_aek [row] * dw_detail.object.com_aekm [lRow] / Object.ccom_aekm [row],0)
         dw_detail.object.ija_aekm [lRow] = 0
      NEXT
   CASE 'tr_co_cd'
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.tr_co_cd [lRow] = data
      NEXT
   CASE 'chasu'
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.seq_no [lRow] = dec (data)
      NEXT

   CASE "ccom_aekm"
      Object.aekm [row] = dec (data) * 10000
      Object.tr_aek [row] = dec (data) * Object.meib_danga [row]
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.com_aekm [lRow] = 0
         dw_detail.object.tr_aek [lRow] = 0
         dw_detail.object.ija_aekm [lRow] = 0
      NEXT
   CASE "ccom_suik_rt"
      Object.suik_rt [row] = dec (data) / 100.0
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.mk_suik_rt [lRow] = dec (data) / 100.0
      NEXT
   CASE 'tr_aek'
      FOR  lRow = 1  TO  lRowCount
         dw_detail.object.tr_aek [lRow] = truncate (dec (data) * dw_detail.object.com_aekm [lRow] / Object.ccom_aekm [row],0)
         dw_detail.object.ija_aekm [lRow] = 0
      NEXT
END CHOOSE
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1   Then RETURN 1

LONG	lRow

FOR  lRow = 1  TO  rowcount ()
//  IF  Object.tr_aek [lRow] < Object.susu [lRow]   THEN
//      f_messagebox ("I000", String(lRow) + " 행에서 수수료 초과")
//      Return 1
//  END IF
      IF Object.sudo_ymd [lRow]<dw_c.object.ymd [1] THEN
         f_messagebox ("I000", string(lRow) + " 행에서 수도결제일 오류")
         RETURN 1
      End IF
NEXT
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;//
CHOOSE CASE GetColumnName()
      CASE 'tr_co_cd'
         rs_Where = "comp_cd is not null and used='1'"
END CHOOSE

RETURN 1

end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	ll
DATETIME	ldt

ldt = dw_c.object.ymd[1]

uf_setcolumn ('tr_cd', dw_c.object.dddw [1])
uf_setcolumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setcolumn ('tr_aek', '0')
IF dw_c.object.dddw [1]='J14' Then
		SELECT F_OPEN_YMD(:ldt, '+1')
		  INTO :ldt
		FROM   DUAL;

		ldt = SQLCA.getitemdatetime (1)
      uf_setcolumn ('sudo_ymd', string (ldt))
Else
      uf_setcolumn ('sudo_ymd', string (dw_c.object.ymd [1]))
End IF
IF iRow>0   Then
   uf_setcolumn ('tr_co_cd', object.tr_co_cd [iRow])
   uf_setcolumn ('xx_tr_co_cd', object.xx_tr_co_cd [iRow])
End IF

select nvl(max(chasu),0) + 1
into :ll
from sct0ci
where corp_gr = :gaa.corp_gr
and tr_ymd = :ldt;

ll = SQLCA.getitemnumber (1)
uf_setcolumn ('chasu', string(ll))

POST SetColumn ('cj_cd')

RETURN 0
end event

type dw_detail from wt_listdetail`dw_detail within w_ja030c_un
string dataobject = "d_ja030c2"
end type

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 Then RETURN 1

CHOOSE CASE dwo.name
   CASE "com_aekm"
         Object.aekm [row] = dec(data) * 10000
         Object.tr_aek [row] = truncate(dw_list.object.tr_aek [iRow] * dec(data) / dw_list.object.ccom_aekm [iRow],0)
//      IF dw_c.object.dddw [1] = 'J14' OR dw_c.object.dddw [1] = 'J15' THEN
//          Object.susu [row] = truncate(dw_list.object.susu [iRow] * Dec(data) / dw_list.object.ccom_aekm [iRow],0)
//      END IF
END CHOOSE

Object.ija_aekm [row] = 0
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, dw_c.object.ymd [1], dw_c.object.dddw [1], dw_list.object.cj_cd [iRow], dw_list.object.tr_co_cd [iRow], dw_list.object.chasu [iRow])
end event

event dw_detail::updatestart;call super::updatestart;IF rowcount ()=0 THEN RETURN
IF AncestorReturnVALUE=1 THEN RETURN 1

IF truncate (Object.sum_com_aekm [1],4)<>truncate (dw_list.object.ccom_aekm [iRow],4)  Then
   f_messagebox ("I000", "매입액면과 배정 액면이 일치하지 않습니다.")
   RETURN 1
End IF
IF truncate (Object.sum_tr_aek [1],0)<>truncate (dw_list.object.tr_aek [iRow],0) Then
   f_messagebox ("I000", "매입액과 배정 매입액이 일치하지 않습니다.")
   RETURN 1
End IF
end event

event dw_detail::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
      CASE 'fund_cd'
         rs_where = "nvl(haeji_ymd,'" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "') >= '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' "
         RETURN 2
END CHOOSE
RETURN 1
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_SetColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_SetColumn ('tr_cd', dw_c.object.dddw [1])
uf_SetColumn ('fund_cd', '')
uf_SetColumn ('jm_cd', dw_list.object.cj_cd [iRow])
uf_SetColumn ('buy_date', string (dw_c.object.ymd [1],'yyyymmdd'))
uf_SetColumn ('tr_co_cd', dw_list.object.tr_co_cd [iRow])
uf_SetColumn ('danga_gb', '0')
uf_SetColumn ('sudo_ymd', string (dw_list.object.sudo_ymd [iRow]))
uf_SetColumn ('mk_suik_rt', string (dw_list.object.suik_rt [iRow]))
uf_SetColumn ('danga', string (dw_list.object.meib_danga [iRow]))
uf_SetColumn ('seq_no', string (dw_list.object.chasu [iRow]))

POST SetColumn ('fund_cd')

RETURN 0
end event

type st_move from wt_listdetail`st_move within w_ja030c_un
end type

