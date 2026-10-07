forward
global type w_ja031m from wt_list
end type
end forward

global type w_ja031m from wt_list
integer ii_dddw_width = 750
string is_init_value = "H11"
end type
global w_ja031m w_ja031m

type variables
DateTime idt_f, idt_t

end variables

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]

SELECT  trunc(add_months(f_workdate(:gaa.corp_gr), -2),'mm')
      , LAST_DAY(trunc(add_months(F_WORKDATE(:gaa.corp_gr), -1),'mm'))
  INTO  :idt_f
      , :idt_t
FROM    dual;
idt_f = SQLCA.getitemdatetime (1)
idt_t = SQLCA.getitemdatetime (2)

dw_c.MODIFY ("tag_text.text = '발생기간 : " + string (idt_f,'yyyy.mm.dd') + " - " + string (idt_t,'yyyy.mm.dd') + "'")
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

on w_ja031m.create
int iCurrent
call super::create
end on

on w_ja031m.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja031m
end type

type ln_templeft from wt_list`ln_templeft within w_ja031m
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja031m
end type

type ln_temptop from wt_list`ln_temptop within w_ja031m
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja031m
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja031m
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja031m
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja031m
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja031m
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja031m
end type

type ln_tempright from wt_list`ln_tempright within w_ja031m
end type

type uo_navi from wt_list`uo_navi within w_ja031m
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja031m
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja031m
end type

type st_top_rect from wt_list`st_top_rect within w_ja031m
end type

type p_close from wt_list`p_close within w_ja031m
end type

type p_excel from wt_list`p_excel within w_ja031m
end type

type p_print from wt_list`p_print within w_ja031m
end type

type p_delete from wt_list`p_delete within w_ja031m
end type

type p_update from wt_list`p_update within w_ja031m
end type

type p_input from wt_list`p_input within w_ja031m
end type

type p_retrieve from wt_list`p_retrieve within w_ja031m
end type

type p_clear from wt_list`p_clear within w_ja031m
end type

type p_copy from wt_list`p_copy within w_ja031m
end type

type dw_c from wt_list`dw_c within w_ja031m
string tag = "발생기간"
string title = "영업일자@출금거래구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031M'")
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt, ldt_f_value

Date  dDate

LONG	lDay

CHOOSE CASE dwo.name
   CASE 'ymd'
      ldt = datetime (date (MidA (data,1,10)))
		
		SELECT F_OPEN_YMD( :ldt, '-' )
		  INTO :ldt_f_value
		FROM   DUAL;
		ldt_f_value = SQLCA.getitemdatetime (1)

      IF ldt_f_value<>ldt  Then
         RETURN uf_itemerror ('ymd','영업일이 아닙니다.')
      End IF

      IF ldt=idt_workdate  Then
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='w_JA031M'")
      Else
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='w_JA031M' and szx0gc.tr_cd in (select tr_cd from skt0hs where corp_gr=':corp_gr' and tr_ymd='" + MID (data,1,10) + "')")
      End IF

      dDate = date (LeftA (data, 10)) ; lDay = Day (dDate)
      idt_f = f_first_ymd (RelativeDate (dDate,lDay * -1))
      idt_t = f_last_day (idt_f)
      MODIFY ("tag_text.text='발생기간 : " + string (idt_f,'yyyy.mm.dd') + ' - ' + string (idt_t,'yyyy.mm.dd') + "'")
END CHOOSE
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (object.ymd [1]>=idt_workdate or gaa.login='yjs1992@hitel.net')
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT  li_ret = 0

SELECT 1
  INTO :li_ret
  FROM SKT0HS t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :rs_ymd
   AND t1.tr_cd   IN (SELECT tr_cd
                        FROM SZX1PT ta
                       WHERE ta.obj_id = 'W_JA031M')
   AND ROWNUM = 1 ;

li_ret = SQLCA.GETITEMNUMBER (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja031m
end type

type st_count from wt_list`st_count within w_ja031m
end type

type dw_list from wt_list`dw_list within w_ja031m
string dataobject = "d_ja031m"
boolean eb_always_1_insert = true
boolean eb_null_line = false
string is_resize_column = "bigo"
end type

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])

POST SetColumn ("fund_cd")

RETURN 0
end event

