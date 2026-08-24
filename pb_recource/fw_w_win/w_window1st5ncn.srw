forward
global type w_window1st5ncn from w_window1st
end type
type p_close from pf_u_imagebutton within w_window1st5ncn
end type
type p_excel from pf_u_imagebutton within w_window1st5ncn
end type
type p_print from pf_u_imagebutton within w_window1st5ncn
end type
type p_delete from pf_u_imagebutton within w_window1st5ncn
end type
type p_update from pf_u_imagebutton within w_window1st5ncn
end type
type p_input from pf_u_imagebutton within w_window1st5ncn
end type
type p_retrieve from pf_u_imagebutton within w_window1st5ncn
end type
type p_clear from pf_u_imagebutton within w_window1st5ncn
end type
end forward

global type w_window1st5ncn from w_window1st
p_close p_close
p_excel p_excel
p_print p_print
p_delete p_delete
p_update p_update
p_input p_input
p_retrieve p_retrieve
p_clear p_clear
end type
global w_window1st5ncn w_window1st5ncn

type variables

end variables

forward prototypes
public function string of_thisname ()
public subroutine of_initbutton ()
public function boolean of_getcommbtnvisible (string as_btnname)
public subroutine of_sethotkey (string as_hotkey)
end prototypes

public function string of_thisname ();return 'w_window1st5cn'
end function

public subroutine of_initbutton ();pf_u_imagebutton	lpcbutton[8]

lpcbutton = { p_close, p_clear, p_retrieve, p_input, p_delete, p_update, p_print, p_excel }

If gnv_authorbtn.ib_clrbtn_yn Then p_clear.visible		= True
If gnv_authorbtn.ib_retbtn_yn Then p_retrieve.visible	= True
If gnv_authorbtn.ib_inpbtn_yn Then p_input.visible		= True
If gnv_authorbtn.ib_updbtn_yn Then p_update.visible	= True
If gnv_authorbtn.ib_delbtn_yn Then p_delete.visible	= True
If gnv_authorbtn.ib_prtbtn_yn Then p_print.visible		= True
If gnv_authorbtn.ib_xlsbtn_yn Then p_excel.visible		= True

Long	xpos = 0, ypos
Integer	li_cnt, i
Boolean	lb_case
String	ls_classname
/* 화면 비율일 125%일 경우 와 그렇지 않을 경우 */
Choose Case gnv_vari.mswindowrate
	Case '100'
		// as-is 변경 없음
	Case '125'
		p_close.width = p_close.width + PixelsToUnits(1, XPixelsToUnits!)
		p_close.height = p_close.height - PixelsToUnits(1, XPixelsToUnits!)
End Choose

xpos += PixelsToUnits(11, XPixelsToUnits!)
ypos = p_close.y

li_cnt = UpperBound(lpcbutton)
//xpos += PixelsToUnits(6, XPixelsToUnits!)
FOR i = 1 TO li_cnt
	IF lpcbutton[i].Visible THEN
		Choose Case gnv_vari.mswindowrate
			Case '100'
				// as-is 변경 없음
			Case '125'
				lpcbutton[i].width = lpcbutton[i].width + PixelsToUnits(1, XPixelsToUnits!)
				lpcbutton[i].height = lpcbutton[i].height - PixelsToUnits(1, XPixelsToUnits!)
		End Choose
		lpcbutton[i].x = xpos
		lpcbutton[i].y = ypos
		xpos += lpcbutton[i].width
		xpos += PixelsToUnits(3, XPixelsToUnits!)
	END IF
NEXT

// user가 지정한 버튼 추가정리
li_cnt = UpperBound (icmdbutton)
xpos += PixelsToUnits(12, XPixelsToUnits!)
FOR i = 1 TO li_cnt
	Choose Case gnv_vari.mswindowrate
		Case '100'
			// as-is 변경 없음
		Case '125'
			icmdbutton[i].width = icmdbutton[i].width + PixelsToUnits(1, XPixelsToUnits!)
			icmdbutton[i].height = icmdbutton[i].height - PixelsToUnits(1, XPixelsToUnits!)
	End Choose
	icmdbutton[i].x = xpos
	icmdbutton[i].y = ypos
	xpos += icmdbutton[i].width
	xpos += PixelsToUnits(3, XPixelsToUnits!)
NEXT
end subroutine

public function boolean of_getcommbtnvisible (string as_btnname);pf_u_imagebutton	lpcbutton[9]
lpcbutton = { p_close, p_clear, p_retrieve, p_input, p_delete, p_update, p_print, p_excel }

Integer	li_cnt, i

li_cnt = UpperBound(lpcbutton)

For i = 1 TO li_cnt
	If lpcbutton[i].Classname() = as_btnname Then
		Return lpcbutton[i].Visible
		Exit
	End If
Next

Return False
end function

public subroutine of_sethotkey (string as_hotkey);Choose Case as_hotkey
	Case 'F2','F3','A','i','B','D','F','S','T','P','Q'
		of_sethotkey4copy(as_hotkey)
	Case 'F5'
		If p_clear.visible = true Then p_clear.Event Clicked()
	Case 'F6'
		If p_retrieve.visible = true Then p_retrieve.Event Clicked()
	Case 'F7'
		If p_input.visible = true Then p_input.Event Clicked()
	Case 'F8'
		If p_update.visible = true Then p_update.Event Clicked()
	Case 'F9'
		If p_delete.visible = true Then p_delete.Event Clicked()
End Choose
end subroutine

on w_window1st5ncn.create
int iCurrent
call super::create
this.p_close=create p_close
this.p_excel=create p_excel
this.p_print=create p_print
this.p_delete=create p_delete
this.p_update=create p_update
this.p_input=create p_input
this.p_retrieve=create p_retrieve
this.p_clear=create p_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_close
this.Control[iCurrent+2]=this.p_excel
this.Control[iCurrent+3]=this.p_print
this.Control[iCurrent+4]=this.p_delete
this.Control[iCurrent+5]=this.p_update
this.Control[iCurrent+6]=this.p_input
this.Control[iCurrent+7]=this.p_retrieve
this.Control[iCurrent+8]=this.p_clear
end on

on w_window1st5ncn.destroy
call super::destroy
destroy(this.p_close)
destroy(this.p_excel)
destroy(this.p_print)
destroy(this.p_delete)
destroy(this.p_update)
destroy(this.p_input)
destroy(this.p_retrieve)
destroy(this.p_clear)
end on

type lb_dirlist from w_window1st`lb_dirlist within w_window1st5ncn
end type

type ln_templeft from w_window1st`ln_templeft within w_window1st5ncn
end type

type ln_tempbuttom from w_window1st`ln_tempbuttom within w_window1st5ncn
end type

type ln_temptop from w_window1st`ln_temptop within w_window1st5ncn
end type

type ln_tempbutton from w_window1st`ln_tempbutton within w_window1st5ncn
end type

type ln_tempstart from w_window1st`ln_tempstart within w_window1st5ncn
end type

type ln_cond1_yline from w_window1st`ln_cond1_yline within w_window1st5ncn
end type

type ln_dw1_yline from w_window1st`ln_dw1_yline within w_window1st5ncn
end type

type ln_cond2_yline from w_window1st`ln_cond2_yline within w_window1st5ncn
end type

type ln_dw2_yline from w_window1st`ln_dw2_yline within w_window1st5ncn
end type

type ln_tempright from w_window1st`ln_tempright within w_window1st5ncn
end type

type uo_navi from w_window1st`uo_navi within w_window1st5ncn
end type

type ln_temptop_shadow from w_window1st`ln_temptop_shadow within w_window1st5ncn
end type

type st_windelaytime from w_window1st`st_windelaytime within w_window1st5ncn
end type

type p_close from pf_u_imagebutton within w_window1st5ncn
integer x = 50
integer y = 16
integer width = 229
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Close(Parent)

end event

type p_excel from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 1746
integer y = 16
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_excel.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_saveas")
end event

type p_print from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 1504
integer y = 16
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_print2.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_print")
end event

type p_delete from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 1262
integer y = 16
integer width = 229
integer height = 96
integer taborder = 40
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_delete.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_delete")
end event

type p_update from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 1019
integer y = 16
integer width = 229
integer height = 96
integer taborder = 50
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_update")
end event

type p_input from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 777
integer y = 16
integer width = 229
integer height = 96
integer taborder = 30
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_input.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_input")
end event

type p_retrieve from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 535
integer y = 16
integer width = 229
integer height = 96
integer taborder = 20
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_lookup.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_retrieve2ready")
end event

type p_clear from pf_u_imagebutton within w_window1st5ncn
boolean visible = false
integer x = 293
integer y = 16
integer width = 229
integer height = 96
integer taborder = 20
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_reset1.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
Parent.PostEvent("wue_clear")
end event

