forward
global type pf_u_titletext from statictext
end type
end forward

global type pf_u_titletext from statictext
integer width = 457
integer height = 64
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 25123896
boolean focusrectangle = false
event type boolean oue_components ( )
event oue_visiblechanged pbm_showwindow
event move pbm_move
event oue_enablechanged pbm_enable
end type
global pf_u_titletext pf_u_titletext

type variables
protected:
	window iw_parent
	picture inv_icon
	pf_s_size istr_size

public:
	string PostIconImage = '..\img\controls\u_icon4comm\ico_dot_r4.jpg'
	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom

end variables
forward prototypes
public function string of_thisname ()
public subroutine of_setvisible (boolean ab_visible)
public subroutine of_setenabled (boolean ab_enabled)
end prototypes

event type boolean oue_components();return true

end event

event oue_visiblechanged;if isvalid(inv_icon) then
	inv_icon.visible = this.visible
end if

end event

event move;if isvalid(inv_icon) then
	inv_icon.x = xpos - inv_icon.width - pixelstounits(3, xpixelstounits!)
	inv_icon.y = ypos + (this.height - inv_icon.height) / 2
end if

end event

event oue_enablechanged;if isvalid(inv_icon) then
	inv_icon.enabled = this.enabled
end if

end event

public function string of_thisname ();return 'pf_u_titletext'

end function

public subroutine of_setvisible (boolean ab_visible);this.visible = ab_visible

if gnv_vari.getclienttype = 'WEB' then 
	this.event oue_visiblechanged(ab_visible, 0)
end if

end subroutine

public subroutine of_setenabled (boolean ab_enabled);this.enabled = ab_enabled

if gnv_vari.getclienttype = 'WEB' then 
	this.event oue_enablechanged(ab_enabled)
end if

end subroutine

on pf_u_titletext.create
end on

on pf_u_titletext.destroy
end on

event constructor;if len(PostIconImage) = 0  then return

// backup message object before OpenUserObject()
message lm_backup
lm_backup = create message
lm_backup.Handle = message.Handle
lm_backup.Number = message.Number
lm_backup.WordParm = message.WordParm
lm_backup.LongParm = message.LongParm
lm_backup.DoubleParm = message.DoubleParm
lm_backup.StringParm = message.StringParm
lm_backup.PowerObjectParm = message.PowerObjectParm
lm_backup.Processed = message.Processed
lm_backup.ReturnValue = message.ReturnValue

iw_parent = fw_f_obj4parentwindow(this)

// Appeon 환경일 경우 이미지 경로 변경
if gnv_vari.getclienttype = 'WEB' then
	PostIconImage = pf_f_getimagepathappeon(PostIconImage)
end if

gnv_extfunc.biz_getimgsize(PostIconImage, istr_size)

long ll_height, ll_width
long ll_xpos, ll_ypos

ll_height = pixelstounits(istr_size.height, ypixelstounits!)
ll_width = pixelstounits(istr_size.width, xpixelstounits!)

ll_xpos = this.x
ll_ypos = this.y + (this.height - ll_height) / 2
this.x = this.x + ll_width + pixelstounits(3, xpixelstounits!)

iw_parent.OpenUserObject(inv_icon, ll_xpos, ll_ypos)
if parent.typeof() = userobject! then
	gnv_extfunc.setparent(handle(inv_icon), handle(parent))
end if

inv_icon.picturename = PostIconImage
inv_icon.originalsize = true
//inv_icon.width = ll_width
//inv_icon.height = ll_height
inv_icon.bringtotop = true
if this.bringtotop = true then
	this.bringtotop = false
	this.setposition(behind!, inv_icon)
end if

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

inv_icon.visible = this.visible

end event

event destructor;if isvalid(inv_icon) then
	// Appeon 에서 Popup 윈도우는 CloseUserObject 를 수행하면 
	// 클라이언트가 멈추는 현상 있음
	if gnv_vari.getclienttype = 'PB' then
		iw_parent.CloseUserObject(inv_icon)
	end if
	destroy inv_icon
end if

end event

