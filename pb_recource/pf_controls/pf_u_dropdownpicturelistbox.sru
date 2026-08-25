forward
global type pf_u_dropdownpicturelistbox from dropdownpicturelistbox
end type
end forward

global type pf_u_dropdownpicturelistbox from dropdownpicturelistbox
integer width = 402
integer height = 476
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
borderstyle borderstyle = stylelowered!
long picturemaskcolor = 536870912
event type boolean oue_components ( )
end type
global pf_u_dropdownpicturelistbox pf_u_dropdownpicturelistbox

type variables
public:
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public function string of_thisname ()
end prototypes

event type boolean oue_components();return true

end event

public function string of_thisname ();return 'pf_u_dropdownpicturelistbox'

end function

on pf_u_dropdownpicturelistbox.create
end on

on pf_u_dropdownpicturelistbox.destroy
end on

