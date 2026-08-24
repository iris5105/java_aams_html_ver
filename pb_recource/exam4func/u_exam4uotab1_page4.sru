forward
global type u_exam4uotab1_page4 from u_ancestor
end type
type dw_list2 from fw_u_dwo within u_exam4uotab1_page4
end type
type st_v from pf_u_splitbar_vertical within u_exam4uotab1_page4
end type
type dw_list from fw_u_dwo within u_exam4uotab1_page4
end type
end forward

global type u_exam4uotab1_page4 from u_ancestor
integer width = 2674
integer height = 1580
string text = "샘플4"
boolean setsheetcolor = true
dw_list2 dw_list2
st_v st_v
dw_list dw_list
end type
global u_exam4uotab1_page4 u_exam4uotab1_page4

on u_exam4uotab1_page4.create
int iCurrent
call super::create
this.dw_list2=create dw_list2
this.st_v=create st_v
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list2
this.Control[iCurrent+2]=this.st_v
this.Control[iCurrent+3]=this.dw_list
end on

on u_exam4uotab1_page4.destroy
call super::destroy
destroy(this.dw_list2)
destroy(this.st_v)
destroy(this.dw_list)
end on

event constructor;call super::constructor;long ll_dwheightminus1value
dw_list.height = this.height - Long(PixelsToUnits(7, XPixelsToUnits!))
ll_dwheightminus1value = dw_list.dynamic of_dwheightminus1value()
if ll_dwheightminus1value > 0 then
	dw_list.height -= ll_dwheightminus1value
end if

st_v.y = dw_list.y
st_v.height = this.height - Long(PixelsToUnits(7, XPixelsToUnits!))

dw_list2.width = (this.width - dw_list2.x) - Long(PixelsToUnits(7, XPixelsToUnits!))
dw_list2.height = this.height - Long(PixelsToUnits(7, XPixelsToUnits!))
ll_dwheightminus1value = dw_list2.dynamic of_dwheightminus1value()
if ll_dwheightminus1value > 0 then
	dw_list2.height -= ll_dwheightminus1value
end if
end event

type dw_list2 from fw_u_dwo within u_exam4uotab1_page4
integer x = 965
integer y = 20
integer width = 1691
integer height = 1540
integer taborder = 10
string title = "test4"
string dataobject = "u_exam4uotab1_page2_1"
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean ibsetlist4subbtn = true
end type

type st_v from pf_u_splitbar_vertical within u_exam4uotab1_page4
integer x = 942
integer y = 20
integer height = 1540
boolean setmainframecolor = true
string leftdragobject = "dw_list"
string rightdragobject = "dw_list2"
end type

type dw_list from fw_u_dwo within u_exam4uotab1_page4
integer x = 23
integer y = 20
integer width = 914
integer height = 1540
integer taborder = 10
string title = "test2"
string dataobject = "u_exam4uotab1_page2_1"
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
end type

