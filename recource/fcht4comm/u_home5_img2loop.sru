forward
global type u_home5_img2loop from u_ancestor
end type
type p_c8 from picture within u_home5_img2loop
end type
type p_c7 from picture within u_home5_img2loop
end type
type p_c6 from picture within u_home5_img2loop
end type
type p_c5 from picture within u_home5_img2loop
end type
type p_c4 from picture within u_home5_img2loop
end type
type p_c3 from picture within u_home5_img2loop
end type
type p_c2 from picture within u_home5_img2loop
end type
type p_c1 from picture within u_home5_img2loop
end type
type dw_img2loop from fw_u_dwo within u_home5_img2loop
end type
end forward

global type u_home5_img2loop from u_ancestor
integer width = 6615
integer height = 1264
event type long oue_retrieve ( )
event oue_changes ( )
event oue_reset ( )
p_c8 p_c8
p_c7 p_c7
p_c6 p_c6
p_c5 p_c5
p_c4 p_c4
p_c3 p_c3
p_c2 p_c2
p_c1 p_c1
dw_img2loop dw_img2loop
end type
global u_home5_img2loop u_home5_img2loop

type variables
Protected:
	Integer	interval		= 3
	
Private:
	Integer	maxrow		= 4
	Integer	rowcnt		= 4
	Integer	currentrow	= 0
	
	Picture				ip_btns[4]
	fw_n_custtiming		in_timer
end variables

forward prototypes
public subroutine of_init ()
public subroutine setimgcnt (long al_rowcnt)
public subroutine selectcount (integer currow)
end prototypes

event type long oue_retrieve();///retrieve로직을 넣는다. 

Long	ll_row
ll_row = dw_img2loop.InsertRow(0)
dw_img2loop.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner51.jpg")
dw_img2loop.setItem(ll_row, 'header_txt', "1번 이미지 입니다. " )

ll_row = dw_img2loop.InsertRow(0)
dw_img2loop.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner53.jpg")
dw_img2loop.setItem(ll_row, 'header_txt', "2번 이미지 입니다. " )

ll_row = dw_img2loop.InsertRow(0)
dw_img2loop.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner53.jpg")
dw_img2loop.setItem(ll_row, 'header_txt', "3번 이미지 입니다. " )

ll_row = dw_img2loop.InsertRow(0)
dw_img2loop.setItem(ll_row, 'img', "..\img\home\home5\banner5\banner54.jpg")
dw_img2loop.setItem(ll_row, 'header_txt', "4번 이미지 입니다. " )

return rowcnt
end event

event oue_changes();//replace
IF rowcnt > 0 THEN
	currentrow++
	
	ip_btns[currentrow].Event Clicked()
END IF
end event

event oue_reset();dw_img2loop.reset()

this.setimgcnt(this.Event oue_retrieve())
ip_btns[1].Event Clicked()
currentrow = 1
end event

public subroutine of_init ();
end subroutine

public subroutine setimgcnt (long al_rowcnt);Long		i
FOR i = 1 TO maxrow
	IF i <= al_rowcnt THEN
		ip_btns[i].visible = true
		rowcnt = i
	ELSE
		ip_btns[i].visible = false
	END IF
NEXT
end subroutine

public subroutine selectcount (integer currow);Integer i
FOR i = 1 TO rowcnt
	ip_btns[ i ].PictureName = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
NEXT

ip_btns[currow].PictureName = "..\img\controls\u_icon4comm\imagebtn_select.jpg"
dw_img2loop.ScrollToRow(currow)

currentrow = currow

IF currentrow = rowcnt THEN currentrow = 0
end subroutine

on u_home5_img2loop.create
int iCurrent
call super::create
this.p_c8=create p_c8
this.p_c7=create p_c7
this.p_c6=create p_c6
this.p_c5=create p_c5
this.p_c4=create p_c4
this.p_c3=create p_c3
this.p_c2=create p_c2
this.p_c1=create p_c1
this.dw_img2loop=create dw_img2loop
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_c8
this.Control[iCurrent+2]=this.p_c7
this.Control[iCurrent+3]=this.p_c6
this.Control[iCurrent+4]=this.p_c5
this.Control[iCurrent+5]=this.p_c4
this.Control[iCurrent+6]=this.p_c3
this.Control[iCurrent+7]=this.p_c2
this.Control[iCurrent+8]=this.p_c1
this.Control[iCurrent+9]=this.dw_img2loop
end on

on u_home5_img2loop.destroy
call super::destroy
destroy(this.p_c8)
destroy(this.p_c7)
destroy(this.p_c6)
destroy(this.p_c5)
destroy(this.p_c4)
destroy(this.p_c3)
destroy(this.p_c2)
destroy(this.p_c1)
destroy(this.dw_img2loop)
end on

event constructor;call super::constructor;ip_btns	= {p_c1, p_c2, p_c3, p_c4}

this.Event oue_reset()

in_timer = Create fw_n_custtiming
in_timer.event oue_parentevent( this, "oue_changes")
in_timer.start( interval )
end event

type p_c8 from picture within u_home5_img2loop
integer x = 2729
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(8)
end event

type p_c7 from picture within u_home5_img2loop
integer x = 2670
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(7)
end event

type p_c6 from picture within u_home5_img2loop
integer x = 2610
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(6)
end event

type p_c5 from picture within u_home5_img2loop
integer x = 2551
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(5)
end event

type p_c4 from picture within u_home5_img2loop
integer x = 2491
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(4)
end event

type p_c3 from picture within u_home5_img2loop
integer x = 2432
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(3)
end event

type p_c2 from picture within u_home5_img2loop
integer x = 2373
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_nonselect.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(2)
end event

type p_c1 from picture within u_home5_img2loop
integer x = 2313
integer y = 2152
integer width = 55
integer height = 48
string picturename = "..\img\controls\u_icon4comm\imagebtn_select.jpg"
boolean focusrectangle = false
end type

event clicked;parent.selectcount(1)
end event

type dw_img2loop from fw_u_dwo within u_home5_img2loop
integer width = 6642
integer height = 1276
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_home5_img2loop_1"
boolean border = false
boolean livescroll = false
boolean scaletoright = true
boolean ibdesign4role = false
boolean ibsetlist4singleselect = false
boolean ibsetlist4alrowcolor = false
end type

