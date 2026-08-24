forward
global type pf_u_rectangle from rectangle
end type
end forward

global type pf_u_rectangle from rectangle
long linecolor = 12632256
integer linethickness = 4
long fillcolor = 1073741824
integer width = 402
integer height = 400
event type boolean oue_components ( )
end type
global pf_u_rectangle pf_u_rectangle

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

public function string of_thisname ();return 'pf_u_rectangle'

end function

on pf_u_rectangle.create
end on

on pf_u_rectangle.destroy
end on

