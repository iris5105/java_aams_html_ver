forward
global type fw_u_dw2zoom from u_ancestor
end type
type p_zoomin from pf_u_imagebutton within fw_u_dw2zoom
end type
type p_zoomout from pf_u_imagebutton within fw_u_dw2zoom
end type
end forward

global type fw_u_dw2zoom from u_ancestor
integer width = 55
integer height = 392
long backcolor = 134217738
p_zoomin p_zoomin
p_zoomout p_zoomout
end type
global fw_u_dw2zoom fw_u_dw2zoom

type variables
UserObject	HsplitObject
end variables

forward prototypes
public function string of_thisname ()
end prototypes

public function string of_thisname ();return 'fw_u_dw2zoom'
end function

on fw_u_dw2zoom.create
int iCurrent
call super::create
this.p_zoomin=create p_zoomin
this.p_zoomout=create p_zoomout
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_zoomin
this.Control[iCurrent+2]=this.p_zoomout
end on

on fw_u_dw2zoom.destroy
call super::destroy
destroy(this.p_zoomin)
destroy(this.p_zoomout)
end on

event constructor;call super::constructor;p_zoomin.show()
p_zoomout.show()
end event

event destructor;call super::destructor;Destroy HsplitObject
end event

type p_zoomin from pf_u_imagebutton within fw_u_dw2zoom
integer width = 55
integer height = 196
integer taborder = 20
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\bt_zoom.jpg"
end type

event clicked;call super::clicked;Long		ll_zoom

ll_zoom = Long(idw_target.Describe("DataWindow.Zoom"))

idw_target.Object.DataWindow.Zoom = ll_zoom + 15

idw_target.Dynamic of_hsplitzoom(ll_zoom, 15) /* hsplit */
end event

type p_zoomout from pf_u_imagebutton within fw_u_dw2zoom
integer y = 196
integer width = 55
integer height = 196
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\bt_zoomout.jpg"
end type

event clicked;call super::clicked;Long		ll_zoom

ll_zoom = Long(idw_target.Describe("DataWindow.Zoom"))

idw_target.Object.DataWindow.Zoom = ll_zoom - 15

idw_target.Dynamic of_hsplitzoom(ll_zoom, -15) /* hsplit */
end event

