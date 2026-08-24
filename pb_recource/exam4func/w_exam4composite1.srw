forward
global type w_exam4composite1 from w_window1st5ncn
end type
type dw_1 from fw_u_dwo within w_exam4composite1
end type
end forward

global type w_exam4composite1 from w_window1st5ncn
dw_1 dw_1
end type
global w_exam4composite1 w_exam4composite1

on w_exam4composite1.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_exam4composite1.destroy
call super::destroy
destroy(this.dw_1)
end on

event wue_retrieve;call super::wue_retrieve;dw_1.SetTransObject( sqlca )

dw_1.Retrieve()
end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_exam4composite1
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_exam4composite1
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_exam4composite1
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_exam4composite1
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_exam4composite1
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_exam4composite1
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_exam4composite1
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_exam4composite1
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_exam4composite1
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_exam4composite1
end type

type uo_navi from w_window1st5ncn`uo_navi within w_exam4composite1
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_exam4composite1
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_exam4composite1
end type

type p_close from w_window1st5ncn`p_close within w_exam4composite1
end type

type p_excel from w_window1st5ncn`p_excel within w_exam4composite1
end type

event p_excel::clicked;call super::clicked;//fw_s_xlsx	lstr_xlsx

//lstr_xlsx.w_obj		= iw_iwindow
//lstr_xlsx.pic_obj	= This
//lstr_xlsx.dw_obj	= dw_1

//OpenWithParm(fw_w_xlsx, lstr_xlsx)

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

type p_print from w_window1st5ncn`p_print within w_exam4composite1
end type

type p_delete from w_window1st5ncn`p_delete within w_exam4composite1
end type

type p_update from w_window1st5ncn`p_update within w_exam4composite1
end type

type p_input from w_window1st5ncn`p_input within w_exam4composite1
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_exam4composite1
end type

type p_clear from w_window1st5ncn`p_clear within w_exam4composite1
end type

type dw_1 from fw_u_dwo within w_exam4composite1
integer x = 50
integer y = 252
integer width = 5381
integer height = 2512
integer taborder = 80
boolean bringtotop = true
string title = "test"
string dataobject = "d_exam4composite1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
boolean settooltipdata = true
boolean ibsetlist4subbtn = true
boolean ibsetlist4clearselect = true
string setlist4fontpointcolor = "cmofcd=A4ZFC=a;cmofcd=A2ZGC=d"
string setlist4rowpointcolor = "cmtotcd=BC0=a;cmtotcd=LA3=b;cmtotcd=ZC0=c;bonbcd=A2ZTH=d"
end type

