forward
global type u_exam4uotab1_page2 from u_ancestor
end type
type dw_list from fw_u_dwo within u_exam4uotab1_page2
end type
end forward

global type u_exam4uotab1_page2 from u_ancestor
integer width = 2674
integer height = 1580
string text = "샘플2"
boolean setsheetcolor = true
dw_list dw_list
end type
global u_exam4uotab1_page2 u_exam4uotab1_page2

on u_exam4uotab1_page2.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on u_exam4uotab1_page2.destroy
call super::destroy
destroy(this.dw_list)
end on

event constructor;call super::constructor;long ll_dwheightminus1value
dw_list.width = this.width - Long(PixelsToUnits(10, XPixelsToUnits!))
dw_list.height = this.height - Long(PixelsToUnits(7, XPixelsToUnits!))
ll_dwheightminus1value = dw_list.dynamic of_dwheightminus1value()
if ll_dwheightminus1value > 0 then
	dw_list.height -= ll_dwheightminus1value
end if
end event

type dw_list from fw_u_dwo within u_exam4uotab1_page2
integer x = 23
integer y = 20
integer width = 2629
integer height = 1540
integer taborder = 10
string dataobject = "u_exam4uotab1_page2_1"
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
end type

