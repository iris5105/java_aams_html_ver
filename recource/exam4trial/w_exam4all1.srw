forward
global type w_exam4all1 from w_window1st5cn
end type
type cb_ie from pf_u_commandbutton within w_exam4all1
end type
type cb_message1 from pf_u_commandbutton within w_exam4all1
end type
type cb_1 from pf_u_commandbutton within w_exam4all1
end type
type cb_2 from pf_u_commandbutton within w_exam4all1
end type
type tab_1 from tab within w_exam4all1
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from fw_u_dwo within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from fw_u_dwo within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from fw_u_dwo within tabpage_3
end type
type dw_4 from fw_u_dwo within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
dw_4 dw_4
end type
type tab_1 from tab within w_exam4all1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_3 from pf_u_commandbutton within w_exam4all1
end type
type uo_tab from pf_u_tab within w_exam4all1
end type
type cb_4 from pf_u_commandbutton within w_exam4all1
end type
type cb_5 from pf_u_commandbutton within w_exam4all1
end type
type cb_6 from pf_u_commandbutton within w_exam4all1
end type
type cb_7 from commandbutton within w_exam4all1
end type
type cb_8 from commandbutton within w_exam4all1
end type
end forward

global type w_exam4all1 from w_window1st5cn
string title = "전체기능구현"
boolean ibconfirmupdate4closequery = true
boolean ibconfirmupdate4message = false
boolean ibconfirmupdate4retrieve = true
cb_ie cb_ie
cb_message1 cb_message1
cb_1 cb_1
cb_2 cb_2
tab_1 tab_1
cb_3 cb_3
uo_tab uo_tab
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
cb_8 cb_8
end type
global w_exam4all1 w_exam4all1

type variables
Datawindow		dw_tab1, dw_tab2, dw_tab3, dw_tab4
end variables

on w_exam4all1.create
int iCurrent
call super::create
this.cb_ie=create cb_ie
this.cb_message1=create cb_message1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.tab_1=create tab_1
this.cb_3=create cb_3
this.uo_tab=create uo_tab
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.cb_8=create cb_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ie
this.Control[iCurrent+2]=this.cb_message1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.uo_tab
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.cb_5
this.Control[iCurrent+10]=this.cb_6
this.Control[iCurrent+11]=this.cb_7
this.Control[iCurrent+12]=this.cb_8
end on

on w_exam4all1.destroy
call super::destroy
destroy(this.cb_ie)
destroy(this.cb_message1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.tab_1)
destroy(this.cb_3)
destroy(this.uo_tab)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.cb_8)
end on

event wue_postopen;call super::wue_postopen;dw_cond.InsertRow(0)
dw_cond.Object.dt_date[1] = string(today(),'yyyymmdd')
dw_cond.Object.dt_month[1] = string(today(),'yyyymm')
dw_cond.Object.tmp_dddw[1] = '%'
dw_cond.SetFocus()
end event

event wue_retrieve;call super::wue_retrieve;dw_tab1.reset()
dw_tab2.reset()
dw_tab3.reset()

dw_tab1.retrieve()
dw_tab2.retrieve()
dw_tab4.retrieve()
//dw_tab4.retrieve()
end event

event open;call super::open;dw_tab1= tab_1.tabpage_1.dw_1
dw_tab2= tab_1.tabpage_2.dw_2
dw_tab3= tab_1.tabpage_3.dw_3
dw_tab4= tab_1.tabpage_3.dw_4
end event

event wue_setdddw;call super::wue_setdddw;isdddwarg[1] = '1'
fw_f_setdddw (dw_cond, 'tmp_dddw', isdddwarg)
fw_f_setdddw (dw_tab1, 'tmp_05', isdddwarg)
fw_f_setdddw (dw_tab2, 'tmp_05', isdddwarg)
fw_f_setdddw (dw_tab3, 'tmp_05', isdddwarg)
fw_f_setdddw (dw_tab4, 'tmp_05', isdddwarg)
fw_f_setdddw (dw_tab4, 'tmp_05_1', isdddwarg)
end event

event wue_update;call super::wue_update;if of_update({dw_tab1, dw_tab4}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_clear;call super::wue_clear;dw_tab4.sharedata(dw_tab3)
end event

event wue_print;call super::wue_print;fw_s_parent	lstr_parent

lstr_parent.w_obj	= iw_iwindow
lstr_parent.dw_obj	= idw_u

OpenWithParm(fw_w_dw2preview, lstr_parent)
end event

type ln_templeft from w_window1st5cn`ln_templeft within w_exam4all1
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_exam4all1
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_exam4all1
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_exam4all1
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_exam4all1
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_exam4all1
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_exam4all1
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_exam4all1
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_exam4all1
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_exam4all1
end type

type uo_navi from w_window1st5cn`uo_navi within w_exam4all1
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_exam4all1
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_exam4all1
end type

type p_close from w_window1st5cn`p_close within w_exam4all1
end type

type p_excel from w_window1st5cn`p_excel within w_exam4all1
boolean visible = true
end type

event p_excel::clicked;fw_s_exportfile	lstr_exportfile

lstr_exportfile.w_obj	= iw_iwindow
lstr_exportfile.pic_obj	= This
lstr_exportfile.dw_obj	= idw_u

OpenWithParm(fw_w_exportfile, lstr_exportfile)

///* 한컴 프린트 있을때는 사용가능 */
//window lwActiveSheet
//long llPrintJob
//
//lwActiveSheet = gw_mdi.GetActiveSheet()
//
//If IsValid(lwActiveSheet) Then
//	llPrintJob = PrintOpen( )
//	
//	Print (llPrintJob, lwActiveSheet.Title)
//	lwActiveSheet.Print (llPrintJob, 1000, PrintY(llPrintJob)+500, 9000, 6500)
//	
//	PrintClose(llPrintJob)
//End If
//
end event

type p_print from w_window1st5cn`p_print within w_exam4all1
boolean visible = true
end type

type p_delete from w_window1st5cn`p_delete within w_exam4all1
end type

type p_update from w_window1st5cn`p_update within w_exam4all1
end type

type p_input from w_window1st5cn`p_input within w_exam4all1
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_exam4all1
end type

type p_clear from w_window1st5cn`p_clear within w_exam4all1
end type

type dw_cond from w_window1st5cn`dw_cond within w_exam4all1
integer height = 272
string dataobject = "d_exam4all1_c1"
boolean ibsettransobject = true
boolean setfocusdw = true
boolean setedittoken = true
end type

event dw_cond::clicked;call super::clicked;Choose Case dwo.name
	Case 'p_calendar'
		fw_f_calendardwo4day1(Parent, This, This.Object.dt_date, row)
	Case 'p_mmcalendar'
		fw_f_calendardwo4mon1(Parent, This, This.Object.dt_month, row)
	Case 'p_ft'
		fw_f_calendardwo4day2(Parent, This, This.Object.f_dt, This.Object.t_dt, row)
End Choose
end event

type cb_ie from pf_u_commandbutton within w_exam4all1
event enchange pbm_enchange
integer x = 4695
integer y = 180
integer width = 338
integer height = 100
integer taborder = 120
boolean bringtotop = true
string text = "naver"
boolean fixedtoright = true
end type

event clicked;call super::clicked;pf_f_browser("http://www.naver.com")

//string ls_null
//setnull(ls_null)
//
//gnv_extfunc.ShellExecute(handle(Parent), 'open', "http://www.naver.com/", ls_null, ls_null, 5)
end event

type cb_message1 from pf_u_commandbutton within w_exam4all1
integer x = 5042
integer y = 296
integer width = 375
integer height = 100
integer taborder = 140
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "PF msg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;gw_mdi.of_setmessagebox('Check', '프레임용 메시지 박스입니다.')

//dw_cond.ibsetlist4singleselect	= false
//dw_cond.of_setdataobject('d_sample_typeall_cond')
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
end event

type cb_1 from pf_u_commandbutton within w_exam4all1
integer x = 4379
integer y = 180
integer width = 306
integer height = 100
integer taborder = 150
boolean bringtotop = true
string text = "bar msg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;gw_mdi.Dynamic SetMicrohelp('Message Test Test Test Test...')
end event

type cb_2 from pf_u_commandbutton within w_exam4all1
integer x = 4695
integer y = 296
integer width = 338
integer height = 100
integer taborder = 130
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "asis msg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;messagebox('Check', '프레임용 메시지 박스입니다.')

//dw_cond.ibsetlist4singleselect	= true
//dw_cond.of_setdataobject('d_sample_typeall_1')
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
//dw_cond.insertrow(0)
end event

type tab_1 from tab within w_exam4all1
integer x = 50
integer y = 460
integer width = 5381
integer height = 2304
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33225466
boolean raggedright = true
boolean focusonbuttondown = true
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
integer x = 18
integer y = 116
integer width = 5344
integer height = 2172
long backcolor = 33225466
string text = "gird디자인"
long tabtextcolor = 134217856
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from fw_u_dwo within tabpage_1
integer x = 50
integer y = 24
integer width = 5266
integer height = 2136
integer taborder = 150
string dataobject = "d_exam4all1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
boolean settooltiphelp = true
boolean settooltipdata = true
boolean ibsetlist4excelclip = true
boolean ibsetlist4clearselect = true
string setlist4fontpointcolor = "tmp_no=09=a;tmp_no=103=d;tmp_no=107=c"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5344
integer height = 2172
long backcolor = 33225466
string text = "tabular디자인"
long tabtextcolor = 255
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from fw_u_dwo within tabpage_2
integer x = 50
integer y = 24
integer width = 5266
integer height = 2136
integer taborder = 150
string dataobject = "d_exam4all1_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5344
integer height = 2172
long backcolor = 33225466
string text = "mst/detail"
long tabtextcolor = 65280
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
dw_3 dw_3
dw_4 dw_4
end type

on tabpage_3.create
this.dw_3=create dw_3
this.dw_4=create dw_4
this.Control[]={this.dw_3,&
this.dw_4}
end on

on tabpage_3.destroy
destroy(this.dw_3)
destroy(this.dw_4)
end on

type dw_3 from fw_u_dwo within tabpage_3
integer x = 50
integer y = 24
integer width = 5266
integer height = 952
integer taborder = 160
string dataobject = "d_exam4all1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean useborder = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
end type

type dw_4 from fw_u_dwo within tabpage_3
integer x = 50
integer y = 1004
integer width = 5266
integer height = 1156
integer taborder = 160
string dataobject = "d_exam4all1_3"
boolean fixedtobottom = true
boolean scaletoright = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean ibresize4objwidth = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
boolean settooltiphelp = true
boolean settooltipdata = true
end type

event clicked;call super::clicked;String		ls_docpath, ls_named
Long		ll_value
Choose Case dwo.name
	Case 'p_find1'
		fw_f_savepath('get', '')
		ll_value = GetFileOpenName("Select File", ls_docpath, ls_named, "모든 Files (*.*)  ,*.*")
		If ll_value > 0 Then This.SetItem(row, 'file_filename', ls_docpath)
	Case 'p_find2'
		fw_f_savepath('get', '')
		ll_value = GetFileOpenName("Select File", ls_docpath, ls_named, "모든 Files (*.*)  ,*.*")
		If ll_value > 0 Then This.SetItem(row, 'file_filename_1', ls_docpath)
End Choose
end event

type cb_3 from pf_u_commandbutton within w_exam4all1
event enchange pbm_enchange
integer x = 5042
integer y = 180
integer width = 375
integer height = 100
integer taborder = 110
boolean bringtotop = true
string text = "temppath"
boolean fixedtoright = true
end type

event clicked;call super::clicked;messagebox(gnv_vari.is_tempdirectory, gnv_extfunc.of_getsystemtemppath())


//gnv_extfunc.of_getsystemtemppath()  ... temp까지
//gnv_vari.is_tempdirectory  .. temp/pentalib/site명


end event

type uo_tab from pf_u_tab within w_exam4all1
integer x = 635
integer y = 412
integer width = 709
integer taborder = 120
boolean bringtotop = true
boolean scaletoright = true
boolean scaletobottom = true
string referencedtab = "tab_1"
boolean ibtextcolor4referencedtab = true
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

type cb_4 from pf_u_commandbutton within w_exam4all1
integer x = 4379
integer y = 296
integer width = 306
integer height = 100
integer taborder = 150
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "temp test"
boolean fixedtoright = true
end type

event clicked;call super::clicked;messagebox('', gnv_vari.ilupdate4error2num)
//dw_cond.enabled = false
//string	ls_error
//ls_error = tab_1.tabpage_1.dw_1.Modify("tmp_03.Values='1번	001/2번	002/3번	003/4번	004/5번	005'")
//uo_tab.of_setenabledtabpage(2,false)
//dw_cond.event wue_setedittoken44()

////uo_tab.of_settabtext(1, '(우리 나라 가나다(((')
//string	ls_url
//long	ll_rc
//
//ls_url = 'http://' + gnv_vari.SetWASSignupIP + '/xml2csv-conv  c:\\Temp\\test.xml c:\\Temp\\test.csv'
//ll_rc = long(ole_xml.object.Navigate2(ls_url))
//messagebox('', ll_rc)

//gnv_rolemenu.of_setopensheet('00048')
end event

type cb_5 from pf_u_commandbutton within w_exam4all1
integer x = 4023
integer y = 180
integer width = 347
integer height = 100
integer taborder = 130
boolean bringtotop = true
string text = "popup"
boolean fixedtoright = true
end type

event clicked;call super::clicked;
openwithparm(w_test4pop1, '')
end event

type cb_6 from pf_u_commandbutton within w_exam4all1
integer x = 4023
integer y = 296
integer width = 347
integer height = 100
integer taborder = 130
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "capture"
boolean fixedtoright = true
end type

event clicked;call super::clicked;gnv_extfunc.biz_setcapture4jpgw(handle(tab_1.tabpage_1.dw_1), gnv_extfunc.of_getsystemtemppath() + '\capture.jpg', 100)
end event

type cb_7 from commandbutton within w_exam4all1
integer x = 3639
integer y = 296
integer width = 375
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "mail test"
end type

event clicked;string		ls_serverurl, ls_from_user_name, ls_from_addr, ls_to_addr
string		ls_subject, ls_content

pf_n_cryptoapi lnv_crypto
lnv_crypto = create pf_n_cryptoapi

ls_serverurl				= 'http://' + gnv_vari.SetWASSignupIP + '/pfservices/SendMailServlet'
ls_from_user_name		= 'bm팀'
ls_from_addr			= 'twsh01@penta.co.kr'
//ls_to_addr				= 'twsh01@penta.co.kr; twsh01@hanmail.net; twsh01@naver.com;'
ls_to_addr				= 'twsh01@naver.com'
ls_subject				= '메일테스트'
ls_content				= lnv_crypto.of_encode64( blob( '안녕하세요.. 우리나라...', EncodingUTF8! ) )

if pf_f_isemptystring(ls_serverurl) then
	messagebox('알림', '서버 URL 정보를 입력하세요')
	Return -1
end if

fw_n_httpfile lnv_http
lnv_http = Create fw_n_httpfile

integer li_rc
li_rc = lnv_http.of_sendmail( ls_serverurl, ls_from_user_name, ls_from_addr, ls_to_addr, ls_subject, ls_content )
messagebox('',li_rc)
Return li_rc
end event

type cb_8 from commandbutton within w_exam4all1
integer x = 3639
integer y = 180
integer width = 375
integer height = 100
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "ppt execute"
end type

event clicked;constant long SW_SHOWNORMARL = 1

String 	ls_nulstring

SetNull(ls_nulstring)
gnv_extfunc.ShellExecute(0, ls_nulstring, "C:\Temp\프레임 특장점.pptx", ls_nulstring, ls_nulstring, SW_SHOWNORMARL)

end event

