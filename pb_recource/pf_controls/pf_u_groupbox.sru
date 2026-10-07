forward
global type pf_u_groupbox from groupbox
end type
end forward

global type pf_u_groupbox from groupbox
integer width = 549
integer height = 476
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 22172242
event type boolean oue_components ( )
end type
global pf_u_groupbox pf_u_groupbox

type variables
public:
	boolean	SetMainFrameColor	= False
	boolean	SetSheetColor		= False
	boolean	SetCondColor		= False
	boolean	SetFreeFormColor	= False
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables

forward prototypes
public function string of_thisname ()
public subroutine of_setbgcolor ()
end prototypes

event type boolean oue_components();return true

end event

public function string of_thisname ();return 'pf_u_groupbox'

end function

public subroutine of_setbgcolor ();If SetMainFrameColor		= True Then fw_f_setcontrolbackcolor(This, gnv_vari.framebackcolor)
If SetSheetColor		= True Then fw_f_setcontrolbackcolor(This, gnv_vari.sheetbackcolor)
If SetCondColor		= True Then fw_f_setcontrolbackcolor(This, gnv_vari.setcondbackcolor)
If SetFreeFormColor	= True Then fw_f_setcontrolbackcolor(This, gnv_vari.setfreebackcolor)
end subroutine

on pf_u_groupbox.create
end on

on pf_u_groupbox.destroy
end on

event constructor;This.of_setbgcolor() /* to-be */
end event

