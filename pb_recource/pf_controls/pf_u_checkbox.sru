forward
global type pf_u_checkbox from checkbox
end type
end forward

global type pf_u_checkbox from checkbox
integer width = 302
integer height = 84
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
event type boolean oue_components ( )
event oue_lastopen ( )
event oue_postopen ( )
end type
global pf_u_checkbox pf_u_checkbox

type variables
Public:	
	boolean	i----------------------------------------------------line0	/* empty Object */
	boolean	SetBringToTop		= False
	boolean	SetMainFrameColor	= False
	boolean	SetSheetColor		= False
	boolean	SetCondColor		= False
	boolean	SetFreeFormColor	= False
	boolean	i----------------------------------------------------line1	/* empty Object */
	boolean	FixedToRight
	boolean	FixedToBottom
	boolean	ScaleToRight
	boolean	ScaleToBottom

end variables

forward prototypes
public function string of_thisname ()
public subroutine of_setbgcolor ()
end prototypes

event type boolean oue_components();return true

end event

event oue_lastopen();If SetBringToTop = True Then This.BringtoTop = True
end event

event oue_postopen();// call oue_lastopen event
This.Post Event oue_lastopen()
end event

public function string of_thisname ();return 'pf_u_checkbox'

end function

public subroutine of_setbgcolor ();If SetMainFrameColor	= True Then fw_f_setcontrolbackcolor(This, gnv_vari.framebackcolor)
If SetSheetColor			= True Then fw_f_setcontrolbackcolor(This, gnv_vari.sheetbackcolor)
If SetCondColor			= True Then fw_f_setcontrolbackcolor(This, gnv_vari.setcondbackcolor)
If SetFreeFormColor		= True Then fw_f_setcontrolbackcolor(This, gnv_vari.setfreebackcolor)
end subroutine

on pf_u_checkbox.create
end on

on pf_u_checkbox.destroy
end on

event constructor;This.of_setbgcolor() /* to-be */

// call oue_postopen event
This.Post Event oue_postopen()
end event

