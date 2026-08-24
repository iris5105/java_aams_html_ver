forward
global type fw_u_cht4radiobutton from radiobutton
end type
end forward

global type fw_u_cht4radiobutton from radiobutton
integer width = 457
integer height = 96
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
event fwu_postclicked ( string as_classname )
end type
global fw_u_cht4radiobutton fw_u_cht4radiobutton

type variables
Window	iw_parent
end variables

forward prototypes
public subroutine of_setinit (window aw_window)
end prototypes

public subroutine of_setinit (window aw_window);iw_parent = aw_window
end subroutine

on fw_u_cht4radiobutton.create
end on

on fw_u_cht4radiobutton.destroy
end on

event clicked;This.Post Event fwu_postclicked(String(this.classname()))
end event

