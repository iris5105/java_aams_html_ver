forward
global type u_exam4uotab1_page5 from u_ancestor
end type
type st_h from pf_u_splitbar_horizontal within u_exam4uotab1_page5
end type
type dw_list2 from fw_u_dwo within u_exam4uotab1_page5
end type
type dw_list from fw_u_dwo within u_exam4uotab1_page5
end type
end forward

global type u_exam4uotab1_page5 from u_ancestor
integer width = 2674
integer height = 1580
string text = "샘플5"
st_h st_h
dw_list2 dw_list2
dw_list dw_list
end type
global u_exam4uotab1_page5 u_exam4uotab1_page5

on u_exam4uotab1_page5.create
int iCurrent
call super::create
this.st_h=create st_h
this.dw_list2=create dw_list2
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_h
this.Control[iCurrent+2]=this.dw_list2
this.Control[iCurrent+3]=this.dw_list
end on

on u_exam4uotab1_page5.destroy
call super::destroy
destroy(this.st_h)
destroy(this.dw_list2)
destroy(this.dw_list)
end on

event constructor;call super::constructor;long ll_dwheightminus1value
dw_list.width = this.width - Long(PixelsToUnits(7, XPixelsToUnits!))
//ll_dwheightminus1value = dw_list.dynamic of_dwheightminus1value()
//if ll_dwheightminus1value > 0 then
//	dw_list.height -= ll_dwheightminus1value
//end if

st_h.width = dw_list.width

dw_list2.y = st_h.y+ Long(PixelsToUnits(12, XPixelsToUnits!))
dw_list2.width = dw_list.width
dw_list2.height = this.height - dw_list.height - st_h.height - Long(PixelsToUnits(12, XPixelsToUnits!))
//ll_dwheightminus1value = dw_list2.dynamic of_dwheightminus1value()
//if ll_dwheightminus1value > 0 then
//	dw_list2.height -= ll_dwheightminus1value
//end if
end event

type st_h from pf_u_splitbar_horizontal within u_exam4uotab1_page5
integer x = 23
integer y = 880
integer width = 2629
boolean setmainframecolor = true
string topdragobject = "dw_list"
string bottomdragobject = "dw_list2"
end type

type dw_list2 from fw_u_dwo within u_exam4uotab1_page5
integer x = 23
integer y = 900
integer width = 2629
integer height = 660
integer taborder = 10
string title = "test4"
string dataobject = "u_exam4uotab1_page2_1"
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

type dw_list from fw_u_dwo within u_exam4uotab1_page5
integer x = 23
integer y = 20
integer width = 2629
integer height = 856
integer taborder = 10
string title = "test27"
string dataobject = "u_exam4uotab1_page2_1"
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

