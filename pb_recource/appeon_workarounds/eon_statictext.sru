forward
global type eon_statictext from statictext
end type
end forward

global type eon_statictext from statictext
integer width = 457
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type
global eon_statictext eon_statictext

type variables
integer ii_vertical  //When ii_vertical is set to 1, eon_statictext is centered vertically; when set to 0, eon_statictext is consistent with PowerBuilder.
end variables

on eon_statictext.create
end on

on eon_statictext.destroy
end on

