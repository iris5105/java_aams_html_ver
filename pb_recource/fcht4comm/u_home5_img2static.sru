forward
global type u_home5_img2static from u_ancestor
end type
type dw_img2static from fw_u_dwo within u_home5_img2static
end type
end forward

global type u_home5_img2static from u_ancestor
integer width = 6615
integer height = 1268
event oue_retrieve ( long al_imgcnt )
dw_img2static dw_img2static
end type
global u_home5_img2static u_home5_img2static

type variables
Private:
	Integer	maxrow		= 4
	Integer	rowcnt		= 4
	Integer	currentrow	= 0
	
end variables

forward prototypes
public subroutine of_init ()
end prototypes

event oue_retrieve(long al_imgcnt);///retrieve로직을 넣는다. 

Long	ll_row
Choose Case al_imgcnt
	Case 1
		ll_row = dw_img2static.InsertRow(0)
		dw_img2static.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner51.jpg")
		dw_img2static.setItem(ll_row, 'header_txt', "1번 이미지 입니다. " )
	Case 2
		ll_row = dw_img2static.InsertRow(0)
		dw_img2static.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner53.jpg")
		dw_img2static.setItem(ll_row, 'header_txt', "2번 이미지 입니다. " )
	Case 3
		ll_row = dw_img2static.InsertRow(0)
		dw_img2static.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner53.jpg")
		dw_img2static.setItem(ll_row, 'header_txt', "3번 이미지 입니다. " )
	Case 4
		ll_row = dw_img2static.InsertRow(0)
		dw_img2static.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner54.jpg")
		dw_img2static.setItem(ll_row, 'header_txt', "4번 이미지 입니다. " )
End Choose
end event

public subroutine of_init ();
end subroutine

on u_home5_img2static.create
int iCurrent
call super::create
this.dw_img2static=create dw_img2static
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_img2static
end on

on u_home5_img2static.destroy
call super::destroy
destroy(this.dw_img2static)
end on

event constructor;call super::constructor;//post event oue_retrieve(gnv_vari.il_banner)
end event

type dw_img2static from fw_u_dwo within u_home5_img2static
integer width = 6642
integer height = 1276
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_home5_img2loop_1"
boolean border = false
boolean livescroll = false
boolean scaletoright = true
boolean ibdesign4role = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
end type

