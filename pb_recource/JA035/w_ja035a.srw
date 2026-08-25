forward
global type w_ja035a from wt_list
end type
end forward

global type w_ja035a from wt_list
boolean eb_direct_retrieve = true
string is_date_nation = "US"
end type
global w_ja035a w_ja035a

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (gaa.corp_gr)
end event

on w_ja035a.create
int iCurrent
call super::create
end on

on w_ja035a.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_ja035a
end type

type ln_templeft from wt_list`ln_templeft within w_ja035a
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja035a
end type

type ln_temptop from wt_list`ln_temptop within w_ja035a
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja035a
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja035a
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja035a
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja035a
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja035a
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja035a
end type

type ln_tempright from wt_list`ln_tempright within w_ja035a
end type

type uo_navi from wt_list`uo_navi within w_ja035a
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja035a
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja035a
end type

type st_top_rect from wt_list`st_top_rect within w_ja035a
end type

type p_close from wt_list`p_close within w_ja035a
end type

type p_excel from wt_list`p_excel within w_ja035a
end type

type p_print from wt_list`p_print within w_ja035a
end type

type p_delete from wt_list`p_delete within w_ja035a
end type

type p_update from wt_list`p_update within w_ja035a
end type

type p_input from wt_list`p_input within w_ja035a
end type

type p_retrieve from wt_list`p_retrieve within w_ja035a
end type

type p_clear from wt_list`p_clear within w_ja035a
end type

type p_copy from wt_list`p_copy within w_ja035a
end type

type dw_c from wt_list`dw_c within w_ja035a
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_list`btn_update within w_ja035a
end type

type st_count from wt_list`st_count within w_ja035a
end type

type dw_list from wt_list`dw_list within w_ja035a
integer y = 156
integer height = 2608
string dataobject = "d_ja035a"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'jasan_gb', gaa.corp_gr, '', 51, "sebu_cd != '1'")
F_DDDWCTL (THIS, 'balh_nation | nation_cd', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'currency', gaa.corp_gr, '', 1, "")
F_DDDWCTL (THIS, 'jasan_attr', gaa.corp_gr, '', 1, "")
f_dddw_filter (THIS, 'jasan_attr', "fkey='유동자산'")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	lRow

uf_setColumn ('balh_ymd', string (idt_workdate))
uf_setColumn ('jasan_gb', '5')
uf_setColumn ('seq_no', '1')
uf_setColumn ('jasan_attr', '100')

lRow = dw_list.getrow ()
IF lRow>0   Then
   uf_setColumn ('balh_nation', Object.balh_nation [lRow])
   uf_setColumn ('currency', Object.currency [lRow])
End IF

POST SetColumn ('balh_nation')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

STRING	ls_cur

CHOOSE CASE DWO.NAME
   CASE 'balh_nation'
      SELECT currency
        INTO :ls_cur
        FROM SZX0WA t1
       WHERE t1.NATION_CD = :data ;
      IF SQLCA.SQLCode () = 0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
END CHOOSE
end event

event dw_list::itemchanged_next;call super::itemchanged_next;STRING	ls_yy, ls_mm

IF GETITEMSTATUS (ROW, 0, PRIMARY!)=NEWMODIFIED!   Then
   ls_yy = f_get_id_dae ('Y', STRING (Object.balh_ymd [row], 'yyyy'))
   ls_mm = f_get_id_dae ('M', STRING (Object.balh_ymd [row], 'mm'))
   Object.jm_cd [row] = f_jm_check (Object.balh_nation [row] + '9' + ls_yy + ls_mm + STRING (Object.balh_ymd [row], 'dd') + Object.jasan_gb [row] + STRING (Object.seq_no [row], '000'))
   Object.sedol [row] = Object.jm_cd [row]
END IF
end event

