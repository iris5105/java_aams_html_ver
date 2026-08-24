forward
global type w_ja990j from wt_list
end type
type cb_2 from pf_u_commandbutton within w_ja990j
end type
end forward

global type w_ja990j from wt_list
boolean eb_direct_retrieve = true
integer ii_dddw_position = 1
cb_2 cb_2
end type
global w_ja990j w_ja990j

on w_ja990j.create
int iCurrent
call super::create
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_ja990j.destroy
call super::destroy
destroy(this.cb_2)
end on

event wue_retrieve;call super::wue_retrieve;dw_List.SetFilter ("holi_ymd >= date('" + string(idt_workdate, 'yyyy') + ".01.01')" )
dw_list.retrieve (dw_c.object.dddw [1])
end event

event open;icmdbutton = { cb_2 }
call super::open
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = 'KR'
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja990j
end type

type ln_templeft from wt_list`ln_templeft within w_ja990j
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja990j
end type

type ln_temptop from wt_list`ln_temptop within w_ja990j
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja990j
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja990j
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja990j
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja990j
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja990j
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja990j
end type

type ln_tempright from wt_list`ln_tempright within w_ja990j
end type

type uo_navi from wt_list`uo_navi within w_ja990j
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja990j
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja990j
end type

type st_top_rect from wt_list`st_top_rect within w_ja990j
end type

type p_close from wt_list`p_close within w_ja990j
end type

type p_excel from wt_list`p_excel within w_ja990j
end type

type p_print from wt_list`p_print within w_ja990j
end type

type p_delete from wt_list`p_delete within w_ja990j
end type

type p_update from wt_list`p_update within w_ja990j
end type

type p_input from wt_list`p_input within w_ja990j
end type

type p_retrieve from wt_list`p_retrieve within w_ja990j
end type

type p_clear from wt_list`p_clear within w_ja990j
end type

type p_copy from wt_list`p_copy within w_ja990j
end type

type dw_c from wt_list`dw_c within w_ja990j
string title = "국가코드"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | nation_cd', gaa.corp_gr, '', 1, '')
end event

type btn_update from wt_list`btn_update within w_ja990j
end type

type st_count from wt_list`st_count within w_ja990j
end type

type dw_list from wt_list`dw_list within w_ja990j
string dataobject = "d_ja990j1"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt, ldt_f, ldt_t

INT   lRow, lRowCount, lDay, lNext

CHOOSE CASE DWO.NAME
   CASE 'lunar'
      ldt   = DATETIME (DATE (MidA(data,1,10)))
      ldt_f = Object.holi_ymd [row]

      lRowCount = ROWCOUNT ()
      FOR  lRow = (ROW + 1)  TO  lRowCount
         ldt_t = Object.holi_ymd [lRow]

         SELECT f_days (:ldt_f,:ldt_t) INTO :lDay FROM DUAL;

         lDay = SQLCA.GETITEMNUMBER (1)

         FOR  lNext = 1  TO  lDay
            SELECT :ldt + 1 INTO :ldt FROM DUAL;

            ldt = SQLCA.GETITEMDATETIME (1)

            IF STRING (ldt,'dd') > '30'   Then
               SELECT trunc(:ldt + 5,'mm') INTO :ldt FROM DUAL t1;

               ldt = SQLCA.GETITEMDATETIME (1)

            END IF
         NEXT

         Object.lunar [lRow] = ldt
         ldt_f               = ldt_t
NEXT
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('nation_cd', dw_c.object.dddw [1])

POST SetColumn ('holi_ymd')

RETURN   0
end event

type cb_2 from pf_u_commandbutton within w_ja990j
integer x = 2231
integer y = 16
integer width = 457
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "일요일생성"
end type

event clicked;OpenwithParm (w_ja990j_popup, string (dw_c.object.dddw [1]))

p_retrieve.POST EVENT Clicked()
end event

