forward
global type u_dimension_btn from u_ancestor
end type
type p_1 from pf_u_imagebutton within u_dimension_btn
end type
type st_1 from pf_u_statictext within u_dimension_btn
end type
end forward

global type u_dimension_btn from u_ancestor
integer width = 443
integer height = 504
long backcolor = 16250871
event ue_click_event ( )
p_1 p_1
st_1 st_1
end type
global u_dimension_btn u_dimension_btn

type variables
STRING is_title, ia_pgm_list []

BOOLEAN	is_corp_gr = FALSE
BOOLEAN	is_all     = FALSE
end variables

forward prototypes
public subroutine uf_init (boolean ab_enabled)
public subroutine uf_setcolor (long al_color)
public subroutine uf_opensheet (string as_pgm_no, string as_pgm_id, string as_pgm_nm, string as_parameter1, string as_parameter2, string as_parameter3, ref string as_last_pgmno)
end prototypes

event ue_click_event();IF gw_mdi.of_lock4processing()=-1 THEN RETURN

STRING	ls_pgm_id, ls_pgm_nm, ls_parameter1, ls_parameter2, ls_parameter3, ls_fullpgmlvl4cd
STRING	ls_tobelv1, ls_tobelv2, ls_tobemobj, ls_pgmarr[], ls_last_pgmno=''

LONG	ll_pgmcnt, ll

// 화면 오픈
FOR ll=1 TO upperbound (ia_pgm_list)
	ls_pgm_id = gnv_rolemenu.of_getpgmid(ia_pgm_list [ll])
	IF f_null (ls_pgm_id) THEN CONTINUE
	ls_pgm_nm = gnv_rolemenu.of_getpgmnm(ia_pgm_list [ll])
	ls_parameter1 = gnv_rolemenu.of_getpgmparameter(ia_pgm_list [ll], '1')
	ls_parameter2 = gnv_rolemenu.of_getpgmparameter(ia_pgm_list [ll], '2')
	ls_parameter3 = gnv_rolemenu.of_getpgmparameter(ia_pgm_list [ll], '3')
	
	uf_opensheet(ia_pgm_list [ll], ls_pgm_id, ls_pgm_nm, ls_parameter1, ls_parameter2, ls_parameter3, ls_last_pgmno)
	yield ()
NEXT

// 마지막 화면 메뉴찾기
IF f_notnull (ls_last_pgmno)	Then
	IF is_corp_gr OR is_all	OR p_1.pictureName = '..\img\home\home5\dim_empty.jpg'	Then
		gw_mdi.p_menu.event clicked ()
		f_set_menu (ls_last_pgmno)
	Else
		gw_mdi.p_bookmark.event clicked ()
		gw_mdi.uo_bookmark.post of_setpgmexpression(ls_last_pgmno)
	End IF
End IF
end event

public subroutine uf_init (boolean ab_enabled);IF is_title = '' Then
	p_1.pictureName = '..\img\home\home5\dim_empty.jpg'
	ia_pgm_list [1] = '00840'
End IF

IF f_null (p_1.pictureName) Then
	p_1.pictureName = '..\img\home\home5\dim_icon1.jpg'
End IF

p_1.event oue_picturenamechanged()

st_1.text = is_title
end subroutine

public subroutine uf_setcolor (long al_color);
end subroutine

public subroutine uf_opensheet (string as_pgm_no, string as_pgm_id, string as_pgm_nm, string as_parameter1, string as_parameter2, string as_parameter3, ref string as_last_pgmno);IF gw_mdi.uo_sheettab.of_isopenedsheet (as_pgm_no)	THEN RETURN //이미 켜져있는 화면인경우 SKIP
IF gw_mdi.uo_sheettab.of_tablimit ()>9	            THEN RETURN //탭 최대개수 초과시 SKIP

IF gw_mdi.of_opensheet(as_pgm_no, as_pgm_id, as_pgm_nm, as_parameter1, as_parameter2, as_parameter3)=1	THEN as_last_pgmno=as_pgm_no
end subroutine

on u_dimension_btn.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_1
end on

on u_dimension_btn.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_1)
end on

type p_1 from pf_u_imagebutton within u_dimension_btn
integer x = 18
integer height = 332
string picturename = "..\img\home\home5\dim_empty.jpg"
end type

event clicked;call super::clicked;event ue_click_event ()
end event

type st_1 from pf_u_statictext within u_dimension_btn
integer y = 352
integer width = 443
integer height = 136
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
long backcolor = 553648127
string text = "텍스트"
alignment alignment = center!
end type

event clicked;call super::clicked;event ue_click_event ()
end event

