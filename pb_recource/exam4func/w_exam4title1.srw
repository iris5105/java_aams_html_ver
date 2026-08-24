forward
global type w_exam4title1 from w_window1st5ncn
end type
type dw_1 from fw_u_dwo within w_exam4title1
end type
type dw_2 from fw_u_dwo within w_exam4title1
end type
type dw_3 from fw_u_dwo within w_exam4title1
end type
type cb_1 from commandbutton within w_exam4title1
end type
type st_1 from pf_u_splitbar_vertical within w_exam4title1
end type
type st_2 from pf_u_splitbar_horizontal within w_exam4title1
end type
end forward

global type w_exam4title1 from w_window1st5ncn
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
cb_1 cb_1
st_1 st_1
st_2 st_2
end type
global w_exam4title1 w_exam4title1

on w_exam4title1.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
end on

on w_exam4title1.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
end on

event wue_retrieve;call super::wue_retrieve;dw_1.SetTransObject( sqlca )

dw_1.Retrieve()
end event

type ln_templeft from w_window1st5ncn`ln_templeft within w_exam4title1
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_exam4title1
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_exam4title1
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_exam4title1
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_exam4title1
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_exam4title1
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_exam4title1
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_exam4title1
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_exam4title1
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_exam4title1
end type

type uo_navi from w_window1st5ncn`uo_navi within w_exam4title1
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_exam4title1
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_exam4title1
end type

type p_close from w_window1st5ncn`p_close within w_exam4title1
end type

type p_excel from w_window1st5ncn`p_excel within w_exam4title1
end type

event p_excel::clicked;call super::clicked;//fw_s_xlsx	lstr_xlsx

//lstr_xlsx.w_obj	= iw_parent
//lstr_xlsx.pic_obj	= This
//lstr_xlsx.dw_obj	= idw_u

//OpenWithParm(fw_w_xlsx, lstr_xlsx)
end event

type p_print from w_window1st5ncn`p_print within w_exam4title1
end type

type p_delete from w_window1st5ncn`p_delete within w_exam4title1
end type

type p_update from w_window1st5ncn`p_update within w_exam4title1
end type

type p_input from w_window1st5ncn`p_input within w_exam4title1
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_exam4title1
end type

type p_clear from w_window1st5ncn`p_clear within w_exam4title1
end type

type dw_1 from fw_u_dwo within w_exam4title1
integer x = 50
integer y = 152
integer width = 2281
integer height = 1244
integer taborder = 80
boolean bringtotop = true
string title = "우리나라1TEST"
string dataobject = "d_exam4group1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean zoominout = true
boolean setfocusdw = true
boolean setedittoken = true
boolean settooltipdata = true
boolean ibsetlist4subbtn = true
string setlist4fontpointcolor = "cmofcd=A4ZFC=a;cmofcd=A2ZGC=d"
string setlist4rowpointcolor = "cmtotcd=BC0=a;cmtotcd=LA3=b;cmtotcd=ZC0=c;bonbcd=A2ZTH=d"
end type

type dw_2 from fw_u_dwo within w_exam4title1
integer x = 2359
integer y = 152
integer width = 3072
integer height = 2612
integer taborder = 90
boolean bringtotop = true
string title = "우리나라2TEST"
string dataobject = "d_exam4group1_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsettransobject = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setfocusdw = true
boolean setedittoken = true
boolean settooltipdata = true
boolean ibsetlist4subbtn = true
string setlist4fontpointcolor = "cmofcd=A4ZFC=a;cmofcd=A2ZGC=d"
string setlist4rowpointcolor = "cmtotcd=BC0=a;cmtotcd=LA3=b;cmtotcd=ZC0=c;bonbcd=A2ZTH=d"
end type

type dw_3 from fw_u_dwo within w_exam4title1
integer x = 50
integer y = 1424
integer width = 2277
integer height = 1340
integer taborder = 90
boolean bringtotop = true
string title = "우리나라3TEST"
string dataobject = "d_exam4group1_1"
boolean hscrollbar = true
boolean vscrollbar = true
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
string setlist4fontpointcolor = "cmofcd=A4ZFC=a;cmofcd=A2ZGC=d"
string setlist4rowpointcolor = "cmtotcd=BC0=a;cmtotcd=LA3=b;cmtotcd=ZC0=c;bonbcd=A2ZTH=d"
end type

type cb_1 from commandbutton within w_exam4title1
integer x = 2226
integer y = 12
integer width = 402
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "타이틀변경"
end type

event clicked;//dw_1.of_settitle4name('ABCDE')
//dw_2.of_settitle4name('미국')
//dw_3.of_settitle4name('한라산 백두산 태백산 등등')
end event

type st_1 from pf_u_splitbar_vertical within w_exam4title1
integer x = 2336
integer y = 152
integer height = 2612
boolean bringtotop = true
boolean setmainframecolor = true
string leftdragobject = "dw_1;dw_3"
string rightdragobject = "dw_2"
end type

type st_2 from pf_u_splitbar_horizontal within w_exam4title1
integer x = 50
integer y = 1404
integer width = 2281
boolean bringtotop = true
boolean setmainframecolor = true
boolean scaletoright = false
string topdragobject = "dw_1"
string bottomdragobject = "dw_3"
end type

