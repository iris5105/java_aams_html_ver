forward
global type w_plan4calendar from wt_list
end type
type cb_create from pf_u_commandbutton within w_plan4calendar
end type
type cb_szx0hl from pf_u_commandbutton within w_plan4calendar
end type
end forward

global type w_plan4calendar from wt_list
boolean eb_direct_retrieve = true
cb_create cb_create
cb_szx0hl cb_szx0hl
end type
global w_plan4calendar w_plan4calendar

type variables
ads_jTier ids_scheduler_data
ads_jTier ids_scheduler_calendar
end variables

forward prototypes
public subroutine of_schedule_retrieve (datawindow adw_current, long row)
end prototypes

public subroutine of_schedule_retrieve (datawindow adw_current, long row);DATE	ld_date

STRING	ls_date, ls_description, ls_importance, ls_daytype

LONG	ll_ret

ld_date = adw_current.getITemDate(row, 'ldtoday')
ls_date = string(ld_date,'yyyymmdd')

//implement
ids_scheduler_data.SetTransObject(SQLCA )
ll_ret = ids_scheduler_data.retrieve (gnv_vari.is_user_id, ls_date)

Choose CASE ll_ret
   CASE 0
      adw_current.SetItem(row, 'schedule', '')
      adw_current.SetItem(row, 'importance', '')
   CASE 1
      ls_description = ids_scheduler_data.GetItemString(1, 'description')
      ls_description = fw_f_replaceall(ls_description, ';', '~r~n')
      ls_importance  = ids_scheduler_data.GetItemString(1, 'importance')
      IF fw_f_nvls(ls_importance, '')=''  Then ls_importance = '1'
      adw_current.SetItem(row, 'schedule', ls_description)
      adw_current.SetItem(row, 'importance', ls_importance)
End Choose

ids_scheduler_calendar.SetTransObject(SQLCA )
ll_ret = ids_scheduler_calendar.retrieve (ls_date)
Choose CASE ll_ret
   CASE 0
      adw_current.SetItem(row, 'day_type', '')
   CASE 1
      ls_daytype = ids_scheduler_calendar.GetItemString(1, 'day_type')
      adw_current.SetItem(row, 'day_type', ls_daytype)
End Choose
end subroutine

on w_plan4calendar.create
int iCurrent
call super::create
this.cb_create=create cb_create
this.cb_szx0hl=create cb_szx0hl
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_create
this.Control[iCurrent+2]=this.cb_szx0hl
end on

on w_plan4calendar.destroy
call super::destroy
destroy(this.cb_create)
destroy(this.cb_szx0hl)
end on

event wue_retrieve;call super::wue_retrieve;STRING	ls_ymd
LONG	ll_ret

ls_ymd = dw_c.object.yyyy [1]
IF fw_f_nvls(ls_ymd, '')=''   Then
   Messagebox('Check', '년도를 확인 하십시요')
End IF

cb_create.enabled = false
cb_szx0hl.enabled = true

ll_ret = dw_list.retrieve (gnv_vari.is_sys_id, ls_ymd)
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.yyyy [1] = mid (f_sysdate_str ('yyyy'), 1, 4)
end event

event wue_clear;call super::wue_clear;cb_create.enabled = false
cb_szx0hl.enabled = false
end event

type lb_dirlist from wt_list`lb_dirlist within w_plan4calendar
end type

type ln_templeft from wt_list`ln_templeft within w_plan4calendar
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_plan4calendar
end type

type ln_temptop from wt_list`ln_temptop within w_plan4calendar
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_plan4calendar
end type

type ln_tempstart from wt_list`ln_tempstart within w_plan4calendar
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_plan4calendar
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_plan4calendar
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_plan4calendar
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_plan4calendar
end type

type ln_tempright from wt_list`ln_tempright within w_plan4calendar
end type

type uo_navi from wt_list`uo_navi within w_plan4calendar
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_plan4calendar
end type

type st_windelaytime from wt_list`st_windelaytime within w_plan4calendar
end type

type st_top_rect from wt_list`st_top_rect within w_plan4calendar
end type

type p_close from wt_list`p_close within w_plan4calendar
end type

type p_excel from wt_list`p_excel within w_plan4calendar
end type

type p_print from wt_list`p_print within w_plan4calendar
end type

type p_delete from wt_list`p_delete within w_plan4calendar
end type

type p_update from wt_list`p_update within w_plan4calendar
end type

type p_input from wt_list`p_input within w_plan4calendar
end type

type p_retrieve from wt_list`p_retrieve within w_plan4calendar
end type

type p_clear from wt_list`p_clear within w_plan4calendar
end type

type p_copy from wt_list`p_copy within w_plan4calendar
end type

type dw_c from wt_list`dw_c within w_plan4calendar
string title = "영업연도"
string dataobject = "dc_yyyy"
end type

type btn_update from wt_list`btn_update within w_plan4calendar
end type

type st_count from wt_list`st_count within w_plan4calendar
end type

type dw_list from wt_list`dw_list within w_plan4calendar
integer taborder = 30
string dataobject = "d_plancalendar_1"
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event updatestart;call super::updatestart;IF this.Rowcount() > 0 THEN
IF AncestorReturnValue=1 THEN RETURN 1

   LONG	ll_rowcount, ll_i
	
   DWItemStatus   ItemStatus

   ll_rowcount = this.rowcount ()

   FOR ll_i = 1 TO ll_rowcount
      ItemStatus = this.GetItemStatus(ll_i,0,primary!)
      Choose CASE ItemStatus
         CASE NewModified!, DataModified!
            IF ItemStatus=NewModified! Then
               This.SetItem(ll_i, 'reg_id', gnv_vari.is_user_id)
               This.SetItem(ll_i, 'reg_dt', fw_f_getymdhh24miss4s())
            End IF
            This.SetItem(ll_i, 'upd_id', gnv_vari.is_user_id)
            This.SetItem(ll_i, 'upd_dt', fw_f_getymdhh24miss4s())
      End Choose
   NEXT
End IF
end event

event dw_list::itemchanged;call super::itemchanged;IF	AncestorReturnValue=1 THEN RETURN 1
IF	dwo.name='remark' And f_notnull (data) THEN Object.day_type [row] = 'HOL'
end event

event dw_list::retrieveend;call super::retrieveend;IF	rowcount=0 THEN cb_create.enabled = true
end event

type cb_create from pf_u_commandbutton within w_plan4calendar
integer x = 1230
integer y = 188
integer width = 361
integer height = 104
integer taborder = 110
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "달력생성"
end type

event clicked;call super::clicked;STRING	ls_yyyy

LONG	ll_cnt, ll_ret

ads_jTier	lds_data

ls_yyyy = dw_c.object.yyyy [1]

IF Messagebox('Notice', ls_yyyy + '년도 달력을 생성 하시겠습니까?', Question!, YesNo!, 2)=2  Then RETURN

SELECT  Count(*)
  INTO  :ll_cnt
FROM    fw_calendar t1
WHERE   sys_id          = :gnv_vari.is_sys_id
  AND   SUBSTR(ymd,1,4) = :ls_yyyy;
ll_cnt = SQLCA.getitemnumber (1)

IF ll_cnt>0 Then
   IF Messagebox('Notice', ls_yyyy + '년도에 자료가 있습니다. 다시 생성하시겠습니까?', Question!, YesNo!, 2)=2 Then RETURN
End IF

dw_list.reset()

lds_data = CREATE ads_jTier

lds_data.DataObject = 'd_plancalendar_ds'
lds_data.SetTransObject(SQLCA)
ll_ret = lds_data.retrieve (gnv_vari.is_sys_id, ls_yyyy, gnv_vari.is_user_id)
IF ll_ret<1 Then
   Messagebox('Error', '달력 데이터를 생성하지 못했습니다. 확인 요망')
   RETURN
End IF
lds_data.RowsCopy(1, lds_data.rowcount (), Primary!, dw_list, 1, Primary!)

end event

type cb_szx0hl from pf_u_commandbutton within w_plan4calendar
integer x = 1614
integer y = 188
integer width = 361
integer height = 104
integer taborder = 120
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "SZX0HL"
end type

event clicked;call super::clicked;STRING	ls_yyyy, ls_holi, ls_nm

LONG	ll_cnt, ll

ls_yyyy = dw_c.object.yyyy [1]

ll_cnt = dw_list.ROWCOUNT ()

FOR  ll= 1  TO  ll_cnt
   IF dw_list.object.day_type [ll] = 'HOL'   Then
      ls_holi = dw_list.object.ymd [ll]
      ls_nm   = dw_list.object.remark [ll]

      UPDATE SZX0HL
         SET holi_nm = :ls_nm
           , iu_dt   = sysdate
       WHERE nation_cd = 'KR'
         AND holi_ymd  = TO_DATE(:ls_holi,'yyyymmdd') ;
      IF SQLCA.sqlnrows () = 0   Then
         INSERT INTO SZX0HL
         VALUES ( 'KR'                          /* _1- */
                , TO_DATE(:ls_holi,'yyyymmdd')  /* _2- */
                , :ls_nm                        /* _3- */
                , NULL                          /* _4- */
                , NULL                          /* _5- */
                , sysdate                       /* _6- */
                ) ;
      END IF
   END IF
NEXT

DELETE FROM SZX0HL
 WHERE nation_cd                 = 'KR'
   AND TO_CHAR(holi_ymd,'yyyy')  = :ls_yyyy
   AND NVL(iu_dt,'2020.01.01')   < trunc(sysdate,'mm') ;

commitJ ()
end event

