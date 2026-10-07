forward
global type w_ja050b from wt_list
end type
end forward

global type w_ja050b from wt_list
end type
global w_ja050b w_ja050b

type variables

end variables

on w_ja050b.create
int iCurrent
call super::create
end on

on w_ja050b.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.tr_ymd [1], dw_c.object.work_gb [1], &
                           dw_c.object.fund_cd [1], dw_c.object.upmu_gb [1], &
                           dw_c.object.tr_cd [1], dw_c.object.seq_no [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
dw_c.object.seq_no [1] = 0
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja050b
end type

type ln_templeft from wt_list`ln_templeft within w_ja050b
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja050b
end type

type ln_temptop from wt_list`ln_temptop within w_ja050b
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja050b
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja050b
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja050b
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja050b
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja050b
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja050b
end type

type ln_tempright from wt_list`ln_tempright within w_ja050b
end type

type uo_navi from wt_list`uo_navi within w_ja050b
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja050b
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja050b
end type

type st_top_rect from wt_list`st_top_rect within w_ja050b
end type

type p_close from wt_list`p_close within w_ja050b
end type

type p_excel from wt_list`p_excel within w_ja050b
end type

type p_print from wt_list`p_print within w_ja050b
end type

type p_delete from wt_list`p_delete within w_ja050b
end type

type p_update from wt_list`p_update within w_ja050b
end type

type p_input from wt_list`p_input within w_ja050b
end type

type p_retrieve from wt_list`p_retrieve within w_ja050b
end type

type p_clear from wt_list`p_clear within w_ja050b
end type

type p_copy from wt_list`p_copy within w_ja050b
end type

type dw_c from wt_list`dw_c within w_ja050b
string dataobject = "d_ja050b"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;dw_c.object.work_gb [1] = F_DDDWCTL (THIS, 'work_gb', gaa.corp_gr, '', 1, '')
dw_c.object.upmu_gb [1] = F_DDDWCTL (THIS, 'upmu_gb', gaa.corp_gr, '', 1, '')
end event

event dw_c::ue_valid;call super::ue_valid;IF f_null (Object.tr_cd [1])  Then
   f_messageBox ('I000','거래코드를 입력하십시오.')
   SetColumn ('tr_cd')
   RETURN FALSE
End IF

IF f_null (Object.fund_cd [1])   Then
   f_messageBox ('I000','펀드코드를 입력하십시오.')
   SetColumn ('fund_cd')
   RETURN FALSE
End IF

IF gaa.Admin OR gaa.aams   Then
   ib_managedata = TRUE
Else
   ib_managedata = (dw_c.object.tr_ymd [1] >= uf_initdate ('inputdate'))
End IF

IF dw_c.object.seq_no [1]=0   Then
   DateTime dTr_ymd

   STRING	sWork_gb, sFund_cd, sUpmu_gb, sTr_cd

   LONG	lSeq_no

   dTr_ymd  = dw_c.object.tr_ymd [1]
   sWork_gb = dw_c.object.work_gb [1]
   sFund_cd = dw_c.object.fund_cd [1]
   sUpmu_gb = dw_c.object.upmu_gb [1]
   sTr_cd   = dw_c.object.tr_cd [1]

   SELECT  NVL(MAX(t1.seq_no),0)
     INTO  :lSeq_no
   FROM    skt0bu t1
   WHERE   t1.corp_gr = :gaa.corp_gr
     AND   t1.tr_ymd  = :dTr_ymd
     AND   t1.tr_cd   = :sTr_cd
     AND   t1.fund_cd = :sFund_cd
     AND   t1.work_gb = :sWork_gb
     AND   t1.upmu_gb = :sUpmu_gb;
	  lSeq_no = SQLCA.getitemnumber (1)

   lSeq_no ++
   dw_c.object.seq_no [1] = lSeq_no
End IF

RETURN TRUE
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fund_cd'
      rs_Where = "(haeji_ymd is null or haeji_ymd >= '" + string (Object.tr_ymd [1],'yyyy.mm.dd') + "')"
      RETURN 2
END CHOOSE
RETURN 1
end event

event dw_c::ue_getdate;INT   li_rtn

SELECT sign(count(*))
  INTO :li_rtn
FROM   skt0bu t1
WHERE  corp_gr   = :gaa.corp_gr
  AND  tr_ymd    = :rs_ymd
  AND  proc_step = 9;

li_rtn = SQLCA.getitemnumber (1)

RETURN li_rtn
end event

type btn_update from wt_list`btn_update within w_ja050b
end type

type st_count from wt_list`st_count within w_ja050b
end type

type dw_list from wt_list`dw_list within w_ja050b
string dataobject = "d_ja050b1"
boolean eb_copy_false = true
string is_resize_column = "bigo"
end type

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1
IF rowcount ()=0 THEN RETURN

IF (dw_list.object.d_sum [1] - dw_list.object.c_sum [1])<>0 Then
   f_messagebox ("I000", "대차 금액차이 오류")
   RETURN 1
End IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'jasan_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

CHOOSE CASE dwo.name
   CASE 'd_aek'
      IF dec (data)<>0 THEN
         SetItem (row, "c_aek", 0)
         SetItem (row, "chadae_gb", 'D')
         SetItem (row, "aek", dec (data))
      End IF
   CASE 'c_aek'
      IF dec (data)<>0 THEN
         SetItem (row, "d_aek", 0)
         SetItem (row, "chadae_gb", 'C')
         SetItem (row, "aek", dec (data))
      End IF
   CASE 'bigo'
      uf_SetColumn ('bigo', data)
      FOR  ll = 1  TO  rowcount ()
         IF f_null (Object.bigo [ll]) THEN Object.bigo [ll] = data
      NEXT
END CHOOSE
end event

event dw_list::retrieverow;call super::retrieverow;IF Object.chadae_gb [row]='D' THEN
   Object.d_aek [row] = Object.aek [row]
   Object.c_aek [row] = 0
ElseIF Object.chadae_gb [row]='C' THEN
   Object.d_aek [row] = 0
   Object.c_aek [row] = Object.aek [row]
End IF
f_dw_resetstatus (THIS, row, {'c_aek','d_aek'})
end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	lFind

uf_SetColumn ('tr_ymd',  string (dw_c.object.tr_ymd [1]))
uf_SetColumn ('work_gb', dw_c.object.work_gb [1])
uf_SetColumn ('fund_cd', dw_c.object.fund_cd [1])
uf_SetColumn ('upmu_gb', dw_c.object.upmu_gb [1])
uf_SetColumn ('tr_cd',   dw_c.object.tr_cd [1])
uf_SetColumn ('jeokyo_cd',  dw_c.object.tr_cd [1])
uf_SetColumn ('xx_jeokyo_cd',  dw_c.object.xx_tr_cd [1])
uf_SetColumn ('seq_no',  string (dw_c.object.seq_no [1]))
uf_SetColumn ('chasu',  '0')
uf_SetColumn ('proc_step',  '9')
uf_SetColumn ('fund_currency', dw_c.object.fund_currency [1])

INT   iRow_no = 0

lFind =  Find ('row_no > ' + string (iRow_no), 1, rowcount ())
DO UNTIL lFind = 0
   iRow_no = GetItemNumber (lFind, 'row_no')
   lFind = Find ('row_no > ' + string (iRow_no), lFind, rowcount () + 1)
LOOP
iRow_no ++
uf_SetColumn ('row_no', string (iRow_no))

POST SetColumn ('gwamok')

RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'd_aek'
      Object.d_aek [row] = f_num (Object.c_sum [1]) - f_num (Object.d_sum [1])
      Object.chadae_gb [row] = 'D'
      Object.aek [row] = Object.d_aek [row]
   CASE 'c_aek'
      Object.c_aek [row] = f_num (Object.d_sum [1]) - f_num (Object.c_sum [1])
      Object.chadae_gb [row] = 'C'
      Object.aek [row] = Object.c_aek [row]
END CHOOSE
end event

event dw_list::ue_setcodesearch;CHOOSE CASE	GetColumnName()
	CASE 'gwamok'
		IF	gaa.corp_gr='2204' THEN RETURN 9
END CHOOSE
RETURN 1
end event

