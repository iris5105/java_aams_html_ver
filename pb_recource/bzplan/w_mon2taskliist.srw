forward
global type w_mon2taskliist from w_window1st5cn
end type
type dw_plan from u_dw within w_mon2taskliist
end type
type p_calendar_em from pf_u_picture within w_mon2taskliist
end type
type em_yyyymm from pf_u_editmask within w_mon2taskliist
end type
type dw_list from u_dw within w_mon2taskliist
end type
end forward

global type w_mon2taskliist from w_window1st5cn
boolean confirmsheetbackcolor = false
dw_plan dw_plan
p_calendar_em p_calendar_em
em_yyyymm em_yyyymm
dw_list dw_list
end type
global w_mon2taskliist w_mon2taskliist

type variables
ads_jTier	ids_scheduler_data
ads_jTier	ids_scheduler_calendar

LONG	iRow
end variables

forward prototypes
public subroutine of_bringtotop (boolean ab_value)
end prototypes

public subroutine of_bringtotop (boolean ab_value);this.BringToTop = ab_value
end subroutine

on w_mon2taskliist.create
int iCurrent
call super::create
this.dw_plan=create dw_plan
this.p_calendar_em=create p_calendar_em
this.em_yyyymm=create em_yyyymm
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_plan
this.Control[iCurrent+2]=this.p_calendar_em
this.Control[iCurrent+3]=this.em_yyyymm
this.Control[iCurrent+4]=this.dw_list
end on

on w_mon2taskliist.destroy
call super::destroy
destroy(this.dw_plan)
destroy(this.p_calendar_em)
destroy(this.em_yyyymm)
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;String			ls_date
datetime		ldt_date

ldt_date = fw_f_getymdhh24miss4d()
ls_date	= String( ldt_date, 'yyyy-mm-dd' )

em_yyyymm.text = ls_date

dw_plan.SetTransObject( sqlca )

This.Post Event wue_retrieve2ready()
end event

event wue_retrieve;call super::wue_retrieve;String		ls_ymd
Long		ll_ret

ls_ymd = em_yyyymm.text
ls_ymd = fw_f_replaceall(ls_ymd, '.', '')
If fw_f_nvls(ls_ymd, '') = '' Then
	Messagebox('Check', '년월을 확인 하십시요')
End If

ll_ret = dw_plan.retrieve(gnv_vari.is_sys_id, ls_ymd, 'all')

If ll_ret = 0 Then Messagebox('Check', '달력생성을 확인해 주십시요')
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within w_mon2taskliist
end type

type ln_templeft from w_window1st5cn`ln_templeft within w_mon2taskliist
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_mon2taskliist
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_mon2taskliist
boolean visible = false
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_mon2taskliist
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_mon2taskliist
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_mon2taskliist
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_mon2taskliist
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_mon2taskliist
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_mon2taskliist
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_mon2taskliist
end type

type uo_navi from w_window1st5cn`uo_navi within w_mon2taskliist
boolean visible = false
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_mon2taskliist
boolean visible = false
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_mon2taskliist
boolean visible = false
end type

type p_close from w_window1st5cn`p_close within w_mon2taskliist
end type

type p_excel from w_window1st5cn`p_excel within w_mon2taskliist
end type

type p_print from w_window1st5cn`p_print within w_mon2taskliist
end type

type p_delete from w_window1st5cn`p_delete within w_mon2taskliist
end type

type p_update from w_window1st5cn`p_update within w_mon2taskliist
end type

type p_input from w_window1st5cn`p_input within w_mon2taskliist
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_mon2taskliist
boolean visible = true
end type

type p_clear from w_window1st5cn`p_clear within w_mon2taskliist
end type

type dw_cond from w_window1st5cn`dw_cond within w_mon2taskliist
end type

type dw_plan from u_dw within w_mon2taskliist
integer x = 50
integer y = 348
integer width = 3854
integer height = 2416
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_mon2tasklist_1"
boolean scaletobottom = true
boolean ibdesign4role = false
boolean ibsetlist4singleselect = false
end type

event doubleclicked;call super::doubleclicked;//If row < 1 Then Return
//
//dw_plan.AcceptText()
//String				ls_obj, ls_objtype
//fw_s_home		lstr_home
//
//ls_obj		= fw_f_nvls(lower(dwo.name), 'datawindow')
//If ls_obj	= 'datawindow' Then Return
//ls_objtype	= This.describe(ls_obj + ".Type")
//If Not(ls_objtype = 'column') Then Return
//
//lstr_home.w_obj	= iw_parent
//lstr_home.dw_obj	= This
//lstr_home.dwo_col	= dwo
//lstr_home.row		= row
//
//ls_obj = left(dwo.name, 3) + '_ymd'
//lstr_home.ymd		= This.GetItemString(row, ls_obj)
//
//If fw_f_nvls(lstr_home.ymd, '') = '' Then Return
//
//OpenWithParm(w_planuser_pop, lstr_home)
//
////OpenWithParm(w_planuser_pop, lstr_home.ymd)
////w_planuser_pop.x = this.PointerX()
////w_planuser_pop.y = this.PointerY()
//
end event

event clicked;//
end event

event rowfocuschanged;//
end event

type p_calendar_em from pf_u_picture within w_mon2taskliist
integer x = 439
integer y = 196
integer width = 105
integer height = 92
boolean bringtotop = true
string pointer = "HyperLink!"
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\ib_calendar.jpg"
end type

event clicked;call super::clicked;fw_f_calendarem4mon1(Parent, em_yyyymm)
end event

type em_yyyymm from pf_u_editmask within w_mon2taskliist
integer x = 91
integer y = 196
integer width = 352
integer taborder = 100
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = hangeul!
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

type dw_list from u_dw within w_mon2taskliist
integer x = 3909
integer y = 348
integer width = 1522
integer height = 2416
integer taborder = 40
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean eb_range_delcopy = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event retrievestart;call super::retrievestart;iRow = 0
end event

