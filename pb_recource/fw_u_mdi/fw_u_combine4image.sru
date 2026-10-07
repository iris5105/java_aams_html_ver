forward
global type fw_u_combine4image from u_ancestor
end type
type p_2 from picture within fw_u_combine4image
end type
type p_3 from picture within fw_u_combine4image
end type
type p_5 from picture within fw_u_combine4image
end type
type p_6 from picture within fw_u_combine4image
end type
type p_7 from picture within fw_u_combine4image
end type
type p_11 from picture within fw_u_combine4image
end type
type p_16 from picture within fw_u_combine4image
end type
type p_17 from picture within fw_u_combine4image
end type
type p_18 from picture within fw_u_combine4image
end type
type p_1 from picture within fw_u_combine4image
end type
type p_4 from picture within fw_u_combine4image
end type
type p_8 from picture within fw_u_combine4image
end type
type p_9 from picture within fw_u_combine4image
end type
end forward

global type fw_u_combine4image from u_ancestor
integer width = 571
integer height = 728
p_2 p_2
p_3 p_3
p_5 p_5
p_6 p_6
p_7 p_7
p_11 p_11
p_16 p_16
p_17 p_17
p_18 p_18
p_1 p_1
p_4 p_4
p_8 p_8
p_9 p_9
end type
global fw_u_combine4image fw_u_combine4image

forward prototypes
public function string of_thisname ()
end prototypes

public function string of_thisname ();return 'fw_u_combine4image'
end function

on fw_u_combine4image.create
int iCurrent
call super::create
this.p_2=create p_2
this.p_3=create p_3
this.p_5=create p_5
this.p_6=create p_6
this.p_7=create p_7
this.p_11=create p_11
this.p_16=create p_16
this.p_17=create p_17
this.p_18=create p_18
this.p_1=create p_1
this.p_4=create p_4
this.p_8=create p_8
this.p_9=create p_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_2
this.Control[iCurrent+2]=this.p_3
this.Control[iCurrent+3]=this.p_5
this.Control[iCurrent+4]=this.p_6
this.Control[iCurrent+5]=this.p_7
this.Control[iCurrent+6]=this.p_11
this.Control[iCurrent+7]=this.p_16
this.Control[iCurrent+8]=this.p_17
this.Control[iCurrent+9]=this.p_18
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.p_4
this.Control[iCurrent+12]=this.p_8
this.Control[iCurrent+13]=this.p_9
end on

on fw_u_combine4image.destroy
call super::destroy
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_5)
destroy(this.p_6)
destroy(this.p_7)
destroy(this.p_11)
destroy(this.p_16)
destroy(this.p_17)
destroy(this.p_18)
destroy(this.p_1)
destroy(this.p_4)
destroy(this.p_8)
destroy(this.p_9)
end on

type p_2 from picture within fw_u_combine4image
integer x = 27
integer y = 28
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\view_btn.jpg"
boolean focusrectangle = false
end type

type p_3 from picture within fw_u_combine4image
integer x = 155
integer y = 28
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\mdi4comm\hide_btn.jpg"
boolean focusrectangle = false
end type

type p_5 from picture within fw_u_combine4image
integer x = 5
integer y = 152
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_tab\tab2_on.jpg"
boolean focusrectangle = false
end type

type p_6 from picture within fw_u_combine4image
integer x = 133
integer y = 152
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_tab\tab2_nor.jpg"
boolean focusrectangle = false
end type

type p_7 from picture within fw_u_combine4image
integer x = 261
integer y = 152
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\u_pgmtab\sheettab_selected.jpg"
boolean focusrectangle = false
end type

type p_11 from picture within fw_u_combine4image
integer x = 407
integer y = 160
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_tab\tab2_off.jpg"
boolean focusrectangle = false
end type

type p_16 from picture within fw_u_combine4image
integer x = 37
integer y = 304
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\u_topmenu4util\top_menu_icon.jpg"
boolean focusrectangle = false
end type

type p_17 from picture within fw_u_combine4image
integer y = 468
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\u_pgmtab\sheettab_normal.jpg"
boolean focusrectangle = false
end type

type p_18 from picture within fw_u_combine4image
integer x = 128
integer y = 468
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\u_pgmtab\sheettab_selected.jpg"
boolean focusrectangle = false
end type

type p_1 from picture within fw_u_combine4image
integer y = 612
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_combtn\webst_btn.jpg"
boolean focusrectangle = false
end type

type p_4 from picture within fw_u_combine4image
integer x = 114
integer y = 612
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_combtn\webst_btn_clicked.jpg"
boolean focusrectangle = false
end type

type p_8 from picture within fw_u_combine4image
integer x = 238
integer y = 612
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_combtn\webst_btn_disabled.jpg"
boolean focusrectangle = false
end type

type p_9 from picture within fw_u_combine4image
integer x = 352
integer y = 612
integer width = 105
integer height = 104
boolean bringtotop = true
string picturename = "..\img\controls\u_combtn\webst_btn_hover.jpg"
boolean focusrectangle = false
end type

