forward
global type pf_u_line from line
end type
end forward

global type pf_u_line from line
long linecolor = 12632256
integer endx = 402
event type boolean oue_components ( )
end type
global pf_u_line pf_u_line

type variables
public:
	boolean	i----------------------------------------------------line0	/* empty Object */
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

public function string of_thisname ();return 'pf_u_line'

end function

on pf_u_line.create
end on

on pf_u_line.destroy
end on

