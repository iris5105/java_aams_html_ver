forward
global type pf_u_commandbutton from commandbutton
end type
end forward

global type pf_u_commandbutton from commandbutton
integer width = 229
integer height = 96
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string pointer = "HyperLink!"
event type boolean oue_components ( )
event oue_textchanged pbm_settext
event oue_visiblechanged pbm_showwindow
event move pbm_move
event resize pbm_size
event oue_postopen ( )
event oue_enablechanged pbm_enable
event oue_lastopen ( )
end type
global pf_u_commandbutton pf_u_commandbutton

type prototypes
Function long SetWindowRgn(long hWnd, long hRgn, boolean bRedraw) Library "user32.dll"
Function long CreateRectRgn(long x1, long y1, long x2, long y2) Library "gdi32.dll"



//    dc.SetBkColor(RGB(100,100,255));   //Setting the Text Background color
//    dc.SetTextColor(RGB(255,0,0));     //Setting the Text Color

end prototypes

type variables
Private:
	window iw_parent
	pf_u_commandbutton_overlay iuo_overlay
	integer ii_referencedobjectcnt

Public:
	boolean	i----------------------------------------------------line0	/* empty Object */
	powerobject ipo_referencedobject[]

	string	PowerTipText	= ''
	boolean	ApplyDesign		= True

	string	PrefixIconFile		= ''
	string	ButtonImageFile	= '..\img\controls\u_combtn\webst_btn.jpg'

	ulong		FontColor				= 16711680		//RGB(30,65,155)
	ulong		MouseOverFontColor	= RGB(255,255,255)
	ulong		DiabledFontColor		= RGB(128,128,128)
	
	boolean	i----------------------------------------------------line1	/* empty Object */
	boolean	SetBringToTop	= False
	boolean	i----------------------------------------------------line2	/* empty Object */	
	boolean	FixedToRight
	boolean	FixedToBottom
	boolean	ScaleToRight
	boolean	ScaleToBottom
	
	string ReferencedObject
	string OnClickCallEvent
	string DatawindowAction	
end variables

forward prototypes
public function string of_thisname ()
public function unsignedlong of_getfontcolor (string as_mode)
public subroutine of_settext (string as_text)
public subroutine of_setvisible (boolean ab_visible)
public subroutine of_setenabled (boolean ab_enabled)
public function string of_getprefixiconfile ()
end prototypes

event type boolean oue_components();return true

end event

event oue_textchanged;If isvalid(iuo_overlay) Then
	iuo_overlay.of_settext(this.text)
End If

end event

event oue_visiblechanged;if isvalid(iuo_overlay) then
	iuo_overlay.of_setvisible(this.visible)
	this.setposition(Behind!, iuo_overlay)
end if

end event

event move;if isvalid(iuo_overlay) then
	iuo_overlay.x = xpos + PixelsToUnits(1, XPixelsToUnits!)
	iuo_overlay.y = ypos + PixelsToUnits(1, YPixelsToUnits!)
end if

end event

event resize;if isvalid(iuo_overlay) then
	iuo_overlay.post of_settext(this.text)
end if

end event

event oue_postopen();// call oue_lastopen event
This.Post Event oue_lastopen()
end event

event oue_enablechanged;if isvalid(iuo_overlay) then
	iuo_overlay.of_setenabled(this.enabled)
end if

end event

event oue_lastopen();If SetBringToTop = True Then
	This.BringtoTop = True
	If isvalid(iuo_overlay) Then iuo_overlay.Post of_bringtotop(True)
End If

end event

public function string of_thisname ();return 'pf_u_commandbutton'

end function

public function unsignedlong of_getfontcolor (string as_mode);ulong ll_fontcolor

choose case lower(as_mode)
	case 'normal'
		ll_fontcolor = this.FontColor
	case 'mouseover', 'clicked'
		ll_fontcolor = this.MouseOverFontColor
	case 'disabled'
		ll_fontcolor = this.DiabledFontColor
end choose

return ll_fontcolor

end function

public subroutine of_settext (string as_text);this.text = as_text

if gnv_vari.getclienttype = 'WEB' then 
	this.event oue_textchanged(as_text)
end if

end subroutine

public subroutine of_setvisible (boolean ab_visible);This.visible = ab_visible

This.Event oue_visiblechanged(ab_visible, 0)

//If gnv_vari.getclienttype = 'WEB' then 
//	this.event oue_visiblechanged(ab_visible, 0)
//End If
//
end subroutine

public subroutine of_setenabled (boolean ab_enabled);this.enabled = ab_enabled

This.Event oue_enablechanged(ab_enabled)

//If gnv_vari.getclienttype = 'WEB' then 
//	this.event oue_enablechanged(ab_enabled)
//End If

end subroutine

public function string of_getprefixiconfile ();return PrefixIconFile

end function

on pf_u_commandbutton.create
end on

on pf_u_commandbutton.destroy
end on

event constructor;// get parent window
iw_parent = fw_f_obj4parentwindow(This)

// apply design of commandbutton
If ApplyDesign = True Then
	// backup message object before OpenUserObject()
	message lm_backup
	lm_backup = Create message
	lm_backup.Handle = message.Handle
	lm_backup.Number = message.Number
	lm_backup.WordParm = message.WordParm
	lm_backup.LongParm = message.LongParm
	lm_backup.DoubleParm = message.DoubleParm
	lm_backup.StringParm = message.StringParm
	lm_backup.PowerObjectParm = message.PowerObjectParm
	lm_backup.Processed = message.Processed
	lm_backup.ReturnValue = message.ReturnValue
	
	If Not Isvalid(iuo_overlay) Then iuo_overlay = Create pf_u_commandbutton_overlay
	iuo_overlay.of_initialize(This, iw_parent, ButtonImageFile)
	
	iw_parent.OpenUserObject(iuo_overlay, This.x, This.y)
	If parent.typeof() = userobject! Then
		gnv_extfunc.setparent(handle(iuo_overlay), handle(parent))
		iuo_overlay.move(This.x, This.y)
	End If
	If This.bringtotop = true Then
		This.bringtotop = false
		This.setposition(behind!, iuo_overlay)
	End If
	iuo_overlay.bringtotop = true
	
	iuo_overlay.of_setvisible(This.visible)
	iuo_overlay.of_setenabled(This.enabled)
	iuo_overlay.powertiptext = This.powertiptext
	
	// restore message object
	message.Handle = lm_backup.Handle
	message.Number = lm_backup.Number
	message.WordParm = lm_backup.WordParm
	message.LongParm = lm_backup.LongParm
	message.DoubleParm = lm_backup.DoubleParm
	message.StringParm = lm_backup.StringParm
	message.PowerObjectParm = lm_backup.PowerObjectParm
	message.Processed = lm_backup.Processed
	message.ReturnValue = lm_backup.ReturnValue
End If

// postopen event
This.post event oue_postopen()
end event

event clicked;integer i

// 참조 오브젝트가 선언된 경우 해당 오브젝트의 이벤트를 호출합니다
If ii_referencedobjectcnt > 0 Then
	for i = 1 to ii_referencedobjectcnt
		If len(OnClickCallEvent) > 0 Then
			If Not isvalid(ipo_referencedobject[i]) Then Continue
			If ipo_referencedobject[i].triggerevent(OnClickCallEvent) = -1 Then Exit
		End If
	next
End If
end event

event destructor;If IsValid(iuo_overlay) Then
	If gnv_vari.getclienttype = 'PB' then iw_parent.closeuserobject(iuo_overlay)
	Destroy iuo_overlay
End If
end event

event getfocus;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname()) /* sheet mousemove event call */
end event

