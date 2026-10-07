forward
global type pf_u_olecontrol from olecontrol
end type
end forward

global type pf_u_olecontrol from olecontrol
integer width = 402
integer height = 400
boolean border = false
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "pf_u_olecontrol.udo"
omactivation activation = activateondoubleclick!
omdisplaytype displaytype = displayascontent!
omcontentsallowed contentsallowed = containsany!
event type boolean oue_components ( )
end type
global pf_u_olecontrol pf_u_olecontrol

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

public function string of_thisname ();return 'pf_u_olecontrol'

end function

on pf_u_olecontrol.create
end on

on pf_u_olecontrol.destroy
end on

