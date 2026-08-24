forward
global type fw_w_log_view1 from w_window1st5cn
end type
type tab_1 from tab within fw_w_log_view1
end type
type tabpage_1 from userobject within tab_1
end type
type dw_tab1 from fw_u_dwo within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_tab1 dw_tab1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tab_1 from tab within fw_w_log_view1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type uo_tab from pf_u_tab within fw_w_log_view1
end type
type dw_error_log from fw_u_dwo within fw_w_log_view1
end type
end forward

global type fw_w_log_view1 from w_window1st5cn
tab_1 tab_1
uo_tab uo_tab
dw_error_log dw_error_log
end type
global fw_w_log_view1 fw_w_log_view1

forward prototypes
public subroutine of_attachedfileopen (long al_row)
end prototypes

public subroutine of_attachedfileopen (long al_row);string	ls_filepath, ls_log_seq
//long	ll_log_seq, ll_file_num
//blob	lb_content
//
//ll_log_seq = dw_error_log.getitemnumber(1, 'log_seq')
//ls_log_seq = string(ll_log_seq)
//ls_filepath = gnv_extfunc.of_getsystemtemppath() + ls_log_seq// + '.png'
//
//selectblob err_image into: lb_content
//from	fw_err_log
//where	log_seq = :ll_log_seq;
//
//FileDelete (gaa.temp + ls_filepath + '.zip')
//FileDelete (gaa.temp + ls_filepath)
//lb_return = mo_.hex2file (gaa.temp + ls_filepath + '.zip', SQLCA.is_Hexfile)
//IF	lb_return	Then
//	/* 압축풀기... */
//	mo_.unzip (gaa.temp + ls_filepath + '.zip', gaa.temp)
//	sleep (1) /* 파일 압축풀기 */
//End IF
//IF	NOT lb_return THEN f_messageBox ('ERR', '파일생성오류')
//
//ShellExecute (HANDLE (gw_mdi), 'open', ls_filepath, '', gaa.temp, 1)
//filedelete (gaa.temp + ls_filepath + '.zip')

//ll_file_num = gnv_file.setfile( ls_filepath, lb_content, 5)
//gnv_extfunc.of_shellexecute(ls_filepath)
//fw_f_setdelaytime(500)
//post filedelete (ls_filepath)
end subroutine

on fw_w_log_view1.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.uo_tab=create uo_tab
this.dw_error_log=create dw_error_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.uo_tab
this.Control[iCurrent+3]=this.dw_error_log
end on

on fw_w_log_view1.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.uo_tab)
destroy(this.dw_error_log)
end on

event wue_postopen;call super::wue_postopen;string		ls_fr, ls_to
datetime	ldt_date

dw_cond.Insertrow(0)

ldt_date = fw_f_getymdhh24miss4d()
ls_fr = string( ldt_date, 'yyyymm' ) + '01'
ls_to = string( ldt_date, 'yyyymmdd' )

dw_cond.setitem(1, 'fr_dt', ls_fr)
dw_cond.setitem(1, 'to_dt', ls_to)
dw_cond.setitem(1, 'use_cd', '%')
dw_cond.setitem(1, 'err_yn', '%')

p_retrieve.post event clicked()
end event

event wue_retrieve;call super::wue_retrieve;string	ls_frdt, ls_todt, ls_site_id, ls_use_cd, ls_err_yn, ls_findtext
long	ll_ret

dw_cond.accepttext()

ls_frdt = dw_cond.GetItemString(1, 'fr_dt')
If fw_f_nvls(ls_frdt, '') = '' Then
	Messagebox('Check', '시작일자를 확인 하십시요')
	return
End If

ls_todt = dw_cond.GetItemString(1, 'to_dt')
If fw_f_nvls(ls_todt, '') = '' Then
	Messagebox('Check', '종료일자를 확인 하십시요')
	return
End If

ls_site_id = dw_cond.GetItemString(1, 'site_id')
ls_use_cd = dw_cond.GetItemString(1, 'use_cd')
if fw_f_nvls(ls_use_cd, '') = '' then
	ls_use_cd = '%'
else
	ls_use_cd = ls_use_cd + '%'
end if
ls_err_yn = dw_cond.GetItemString(1, 'err_yn')
if fw_f_nvls(ls_err_yn, '') = '' then
	ls_err_yn = '%'
end if
ls_findtext = dw_cond.GetItemString(1, 'findtext')
if fw_f_nvls(ls_findtext, '') = '' then
	ls_findtext = '%'
else
	ls_findtext = '%' + ls_findtext + '%'
end if
ll_ret = tab_1.tabpage_1.dw_tab1.Retrieve(gnv_vari.is_sys_id, ls_site_id, ls_frdt, ls_todt, ls_use_cd, ls_err_yn, ls_findtext)

If ll_ret > 0 Then
//	ll_ret = tab_1.tabpage_2.dw_tab2.Retrieve(ls_frdt, ls_todt, ls_site_id)

//	ll_ret = tab_1.tabpage_3.dw_tab3.Retrieve(ls_frdt, ls_todt, ls_site_id, ls_use_cd)
End If
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw2(dw_cond, 'dddw||empty', 'use_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, '*', 'sy1001000', '%', '%'})
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within fw_w_log_view1
end type

type ln_templeft from w_window1st5cn`ln_templeft within fw_w_log_view1
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within fw_w_log_view1
end type

type ln_temptop from w_window1st5cn`ln_temptop within fw_w_log_view1
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within fw_w_log_view1
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within fw_w_log_view1
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within fw_w_log_view1
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within fw_w_log_view1
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within fw_w_log_view1
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within fw_w_log_view1
end type

type ln_tempright from w_window1st5cn`ln_tempright within fw_w_log_view1
end type

type uo_navi from w_window1st5cn`uo_navi within fw_w_log_view1
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within fw_w_log_view1
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within fw_w_log_view1
end type

type p_close from w_window1st5cn`p_close within fw_w_log_view1
end type

type p_excel from w_window1st5cn`p_excel within fw_w_log_view1
end type

type p_print from w_window1st5cn`p_print within fw_w_log_view1
end type

type p_delete from w_window1st5cn`p_delete within fw_w_log_view1
end type

type p_update from w_window1st5cn`p_update within fw_w_log_view1
end type

type p_input from w_window1st5cn`p_input within fw_w_log_view1
end type

type p_retrieve from w_window1st5cn`p_retrieve within fw_w_log_view1
end type

type p_clear from w_window1st5cn`p_clear within fw_w_log_view1
end type

type dw_cond from w_window1st5cn`dw_cond within fw_w_log_view1
string dataobject = "fw_d_log_view1_c1"
boolean setedittoken = true
end type

event dw_cond::clicked;call super::clicked;Choose Case dwo.name
	Case 'p_fr'
		fw_f_calendardwo4day1(iw_parent, this, this.Object.fr_dt, row)
	Case 'p_to'
		fw_f_calendardwo4day1(iw_parent, this, this.Object.to_dt, row)
End Choose
end event

type tab_1 from tab within fw_w_log_view1
integer x = 50
integer y = 348
integer width = 5385
integer height = 2356
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 116
integer width = 5349
integer height = 2224
string text = "기간별이력"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
dw_tab1 dw_tab1
end type

on tabpage_1.create
this.dw_tab1=create dw_tab1
this.Control[]={this.dw_tab1}
end on

on tabpage_1.destroy
destroy(this.dw_tab1)
end on

type dw_tab1 from fw_u_dwo within tabpage_1
integer x = 50
integer y = 24
integer width = 5266
integer height = 2188
integer taborder = 130
string dataobject = "fw_d_log_view1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
string setlist4fontpointcolor = "start_yn=Y=b"
end type

event itemfocuschanged;call super::itemfocuschanged;Choose Case dwo.name
	Case 'description'
		pf_f_togglekoreng('k')
	Case Else
		pf_f_togglekoreng('e')
End Choose
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
string	ls_err
long	ll_ret, ll_log_seq

ll_log_seq = tab_1.tabpage_1.dw_tab1.getitemnumber(currentrow, 'log_seq')
ls_err = tab_1.tabpage_1.dw_tab1.getitemstring(currentrow, 'err_yn')

dw_error_log.reset()
if ls_err = 'Y' then
	dw_error_log.visible = true
	ll_ret = dw_error_log.retrieve(ll_log_seq)
else
	dw_error_log.visible = false
end if

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5349
integer height = 2224
string text = "empty"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5349
integer height = 2224
string text = "empty"
long tabtextcolor = 33554432
long tabbackcolor = 1073741824
long picturemaskcolor = 536870912
end type

type uo_tab from pf_u_tab within fw_w_log_view1
integer x = 1559
integer y = 340
integer width = 1147
integer taborder = 100
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_1"
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

type dw_error_log from fw_u_dwo within fw_w_log_view1
integer x = 3547
integer y = 1156
integer width = 1810
integer height = 1416
integer taborder = 140
boolean bringtotop = true
boolean titlebar = true
string dataobject = "fw_d_error_log"
boolean livescroll = false
boolean fixedtoright = true
boolean fixedtobottom = true
boolean applydesign = true
end type

event clicked;call super::clicked;choose case string(dwo.name)
	case 'p_folder_true'
		of_attachedfileopen(1)
end choose
end event

