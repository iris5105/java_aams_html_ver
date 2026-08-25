forward
global type fw_u_dw2title from u_ancestor
end type
type p_icon from pf_u_picture within fw_u_dw2title
end type
type st_title from statictext within fw_u_dw2title
end type
end forward

global type fw_u_dw2title from u_ancestor
integer width = 800
integer height = 80
long backcolor = 16777215
boolean setsheetcolor = true
p_icon p_icon
st_title st_title
end type
global fw_u_dw2title fw_u_dw2title

type variables
private:
	string	ismenu2fontface = "맑은 고딕"
	long	ilmenu2fontsize = -10
	long	ilmenu2fontweight = 400
	
public:
	string	istitletext	= ''
end variables

forward prototypes
public function string of_thisname ()
public subroutine of_settitle4name (string arg_title)
end prototypes

public function string of_thisname ();return 'fw_u_dw2title'
end function

public subroutine of_settitle4name (string arg_title);istitletext = arg_title
if fw_f_nvls(istitletext, '') <> '' then
	long	ll_titlewidth
	pf_s_size lstr_textsize
	
	st_title.text = istitletext
	gnv_extfunc.biz_gettextsize_w(handle(this), istitletext, ismenu2fontface, ilmenu2fontsize, ilmenu2fontweight, lstr_textsize)
	//ll_titlewidth = Round(PixelsToUnits(lstr_textsize.width, XPixelsToUnits!) * 1.2, 0)
	//<임시> 끝부분이 살짝 잘리는 경우 한글이 있으면 뒤쪽글자가 사라지는 현상 > w_dblink
	ll_titlewidth = ceiling(PixelsToUnits(lstr_textsize.width, XPixelsToUnits!) * 1.3)
		
	st_title.width = ll_titlewidth
	this.width = st_title.width + p_icon.width + PixelsToUnits(11, XPixelsToUnits!)
end if

end subroutine

on fw_u_dw2title.create
int iCurrent
call super::create
this.p_icon=create p_icon
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_icon
this.Control[iCurrent+2]=this.st_title
end on

on fw_u_dw2title.destroy
call super::destroy
destroy(this.p_icon)
destroy(this.st_title)
end on

event constructor;call super::constructor;post of_settitle4name(istitletext)
end event

type p_icon from pf_u_picture within fw_u_dw2title
integer y = 8
integer width = 9
integer height = 64
boolean bringtotop = true
boolean originalsize = false
string picturename = "..\img\controls\u_icon4comm\menu_delimiter.jpg"
end type

type st_title from statictext within fw_u_dw2title
integer x = 32
integer y = 4
integer width = 704
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

