forward
global type fw_u_imgbtndefault from commandbutton
end type
end forward

global type fw_u_imgbtndefault from commandbutton
string tag = "defaultbutton"
integer width = 101
integer height = 100
integer textsize = -9
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "none"
boolean default = true
end type
global fw_u_imgbtndefault fw_u_imgbtndefault

type variables
Protected:
	graphicobject	igrh_obj
end variables

forward prototypes
public subroutine setparent (graphicobject ag_obj)
end prototypes

public subroutine setparent (graphicobject ag_obj);igrh_obj = ag_obj
end subroutine

on fw_u_imgbtndefault.create
end on

on fw_u_imgbtndefault.destroy
end on

event clicked;igrh_obj.PostEvent('Clicked')
end event

