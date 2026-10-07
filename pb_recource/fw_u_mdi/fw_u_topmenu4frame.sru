forward
global type fw_u_topmenu4frame from u_ancestor
end type
type dw_menubar from fw_u_dwo within fw_u_topmenu4frame
end type
type hsb_1 from pf_u_hscrollbar within fw_u_topmenu4frame
end type
end forward

global type fw_u_topmenu4frame from u_ancestor
integer width = 3163
integer height = 124
long backcolor = 16777215
string text = ""
long tabtextcolor = 0
event oue_clicked4menu ( string as_menu_sn )
event oue_initroleclicked ( )
dw_menubar dw_menubar
hsb_1 hsb_1
end type
global fw_u_topmenu4frame fw_u_topmenu4frame

type variables
private:
	string		is_lang_ins	= 'lng_kor'	/* instance variable temp save */
	integer		ii_selectedmenuseq
	long		il_maxwidth
	
protected:
	boolean	ibsubtopmenu	= true
	
public:
	string		ismenu2fontface		= ''
	long		ilmenu2fontsize			= 0
	long		ilmenu2fontcolor		= 0
	long		ilmenu2fontweight		= 0
	long		ilmenu2space			= 0
	long		ilmenu2startxposition	= 0 // pixels
	
	string		istopmenu2fontface		= "맑은 고딕"
	long		iltopmenu2fontsize		= -13
	long		iltopmenu2fontweight	= 700
	long		iltopmenu2space		= 9
	
	string		issubmenu2fontface		= "맑은 고딕"
	long		ilsubmenu2fontsize		= -10
	long		ilsubmenu2fontweight	= 700
	long		ilsubmenu2space		= 6

	long		ilmenu2transparent		= 553648127 // transparent
	
	string		is_topmenu_round_img	= "..\img\mainframe\u_topmenu4util\top_select_round_gray.png"
	string		is_topmenu_alert_img	= '' 		//"..\image\theme1\u_mdi_menubar\menu_delimiter.jpg"
	long		MenuDelimiterHeight	= 15	// pixels
	long		MenuDelimiterWidth	= 1		// pixels
	long		MenuDelimiterYPos		= 8		// pixels
	
	//long		MenuDelimiterTopHeight		= 2 // pixels
	
	
	boolean	ib_menu_start	= true 
	boolean	ib_menu_icon	= false
end variables

forward prototypes
public function integer of_drawmenu (string as_pgm_up_sn)
public function long of_getmenuwidth ()
public function integer of_initializemenu ()
public subroutine of_menuclicked (long al_row, string as_obj)
public function string of_getlangtype ()
public function string of_getobj4menu (string as_pgmno)
public subroutine of_setfind4menu2course (long al_row, string as_pgmno)
public function string of_thisname ()
end prototypes

event oue_initroleclicked();dw_menubar.event Clicked(1, 1, 1, dw_menubar.object.t_menu_01)
end event

public function integer of_drawmenu (string as_pgm_up_sn);long	ll_menucnt, ll_xpos, ll_ypos, ll_menugap, ll_textwidth, ll_textheight, i, ll_topimgxpos, ll_topimgypos, ll_topimgwidth
long	ll_pgm_xpos
long	ll_bgxpos, ll_bgwidth
string	ls_pgm_no, ls_pgm_id, ls_pgm_nm, ls_pgm_icon
string	ls_syntax

pf_s_size lstr_textsize, lstr_delimg

dw_menubar.setredraw(false)
// 데이터윈도우 초기화
dw_menubar.dataobject = dw_menubar.dataobject
ii_selectedmenuseq = 0
ls_syntax = ''
// Parent PgmNo 가 없는 경우 Default 값 처리(=최상단 메뉴)
if isnull(as_pgm_up_sn) or as_pgm_up_sn = '' then as_pgm_up_sn = '00000'

// 권한이 따른 메뉴 가져오기
ll_menucnt = gnv_rolemenu.of_getmenudata('parent', as_pgm_up_sn)
if ll_menucnt = 0 Then
	Messagebox('Check', '하위 메뉴 권한이 없습니다.(of_drawmenu)')
	return -1
end if

// 데이터윈도우 syntax 작성
ll_xpos		= pixelstoUnits(ilmenu2startxposition, XpixelstoUnits!)
ll_menugap	= pixelstoUnits(ilmenu2space, XpixelstoUnits!)
// 데이터윈도우 백그라운드 컬러
ls_syntax += 'DataWindow.Header.Color="' + string(gnv_vari.mdi2topmenubackcolor) + '"~r~n'
ls_syntax += 'DataWindow.Header.Height="' + string(dw_menubar.height) + '"~r~n'

////to-be submenu만 진행 메뉴 첫 구분자 생성
//if ll_menucnt > 0 and ibsubtopmenu = true Then
//	if ib_menu_start = True Then
//		if len(is_topmenu_alert_img) > 0 Then
//			//ll_xpos	= pf_f_nvll(ll_textwidth, 0) // + ll_menugap as-is
//			ll_ypos	= pixelstoUnits(MenuDelimiterYPos, YpixelstoUnits!) //(dw_menubar.height - pixelstoUnits(MenuDelimiterHeight, YpixelstoUnits!)) / 2
//			ls_syntax += 'create bitmap(band=header filename="' + is_topmenu_alert_img + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(pixelstoUnits(MenuDelimiterHeight, YpixelstoUnits!)) + '" width="' + string(pixelstoUnits(MenuDelimiterWidth, XpixelstoUnits!)) + '" border="0"  name=p_menudist_00 tag="" visible="1" )')
//			// as-is ll_xpos += pixelstoUnits(MenuDelimiterWidth, XpixelstoUnits!)
//		end if
//	end if
//end if

for i = 1 to ll_menucnt
	ll_bgxpos = ll_xpos
	If i = 1 Then
		ll_bgxpos += PixelsToUnits(MenuDelimiterWidth, XPixelsToUnits!)		
	end if
	ll_xpos += ll_menugap
	ll_topimgxpos	= ll_xpos
	ls_pgm_no		= gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_no')
	ls_pgm_id		= gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_id')
	ls_pgm_nm		= gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_nm')
	ls_pgm_icon	= gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_icon')
	
	// 텍스트 사이즈 구하기
	if ilmenu2fontsize < 0 Then ilmenu2fontsize *= -1
	gnv_extfunc.biz_gettextsize_w(handle(this), ls_pgm_nm, ismenu2fontface, ilmenu2fontsize, ilmenu2fontweight, lstr_textsize)
	ll_textwidth = round(pixelstoUnits(lstr_textsize.width, XpixelstoUnits!) * 1.15, 0)
	ll_textheight = pixelstoUnits(lstr_textsize.height, YpixelstoUnits!)
	
	// 텍스트 사이즈를 기준으로 상하 가운데 정렬	
	if ibsubtopmenu = true then
		ll_ypos = round(dw_menubar.height * (1 / 5), 0)
	else
		ll_ypos = round(dw_menubar.height * (1 / 3.7), 0)
	end if
	
	// 메뉴 아이콘 생성
	if len(ls_pgm_icon) > 0 and ib_menu_icon = true Then
		// ASA Database 사용 시 '\' 값을 제대로 못 가져옴
		// 따라서 Database 에 경로를 '/'로 구분해서 입력하고 가져와서 '\'로 Replace 한다
		ls_pgm_icon = fw_f_replaceall(ls_pgm_icon, '/', '\')
		ls_syntax += 'create bitmap(band=header filename="' + ls_pgm_icon + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(ll_textheight) + '" width="' + string(ll_textheight * 4 / 3) + '" border="0"  name=p_pgm_' + string(i, '00') +  ' tag="' + ls_pgm_no + '" pointer="HyperLink!" visible="1" )~r~n'
		ll_xpos += long(pixelstoUnits(UnitsToPixels((ll_textheight * 4 / 3) * 1.2, XUnitsToPixels!), XpixelstoUnits!)) //(ll_textheight * 4 / 3) * 1.2
	end if
	
	// font.charset : 0 = ANSI;1 = The default character set for the specified font;2 = Symbol;128 = Shift JIS;255 = OEM
	// font.family : 0 = AnyFont;1 = Roman;2 = Swiss;3 = Modern;4 = Script;5 = Decorative
	// font.pitch : 0 = The default pitch for your system;1 = Fixed;2 = Variable
	if ilmenu2fontsize > 0 Then ilmenu2fontsize *= -1
	ll_pgm_xpos = ll_xpos
	ll_xpos += ll_textwidth + ll_menugap
	
	// 백그라운드용 텍스트 생성
	ll_bgwidth = ll_xpos - ll_bgxpos
	ls_syntax += 'create text(band=header alignment="2" text="" border="0" color="33554432" x="' + string(ll_bgxpos) + '" y="' + string(pixelstoUnits(1, YpixelstoUnits!)) + '" height="' + string(dw_menubar.height) + '" width="' + string(ll_bgwidth) + '" html.valueishtml="0"  name=t_menubg_' + string(i, '00') + ' tag="' + ls_pgm_no + '" visible="1"  font.face="맑은 고딕" font.height="-11" font.weight="700"  font.family="1" font.pitch="2" font.charset="129" background.mode="0" background.color="' + string(ilmenu2transparent) + '" )~r~n'
	
	//to-be submenu만 진행 메뉴 첫 구분자 생성
	//if ibsubtopmenu = false then
		ll_topimgypos	= pixelstoUnits(5, XpixelstoUnits!) //as-is text 밑에 이미지 구성 ll_ypos + ll_textheight + pixelstoUnits(6, YpixelstoUnits!)
		ll_topimgwidth	= ll_textwidth - pixelstoUnits(1, XpixelstoUnits!)
		ls_syntax += 'create bitmap(band=header filename="' + is_topmenu_round_img + '" x="' + string(ll_bgxpos) + '" y="' + string(ll_topimgypos) + '" height="' + string(dw_menubar.height - pixelstoUnits(12, XpixelstoUnits!)) + '" width="' + string(ll_bgwidth) + '" border="0"  name=p_menudisttop_' + string(i, '00') +  ' tag="" visible="0" )~r~n'
		ll_xpos += pixelstoUnits(MenuDelimiterWidth, XpixelstoUnits!)			
	//end if
	// 메뉴 텍스트 생성
	ls_syntax += 'create text(band=header alignment="2" text="' + ls_pgm_nm + '" border="0" color="' + string(ilmenu2fontcolor) + '" x="' + string(ll_pgm_xpos) + '" y="' + string(ll_ypos) + '" height="84" width="' + string(ll_textwidth) + '"  html.valueishtml="0"  name=t_menu_' + string(i, '00') + ' tag="' + ls_pgm_no + '" pointer="HyperLink!" visible="1"  font.face="' + ismenu2fontface + '" font.height="' + string(ilmenu2fontsize) + '" font.weight="' + string(ilmenu2fontweight) + '"  font.family="0" font.pitch="0" font.charset="129" background.mode="0" background.color="' + string(ilmenu2transparent) + '" )~r~n'

//	//to-be submenu만 진행 메뉴 첫 구분자 생성
//	if len(is_topmenu_alert_img) > 0 Then
//		if NOT (ibsubtopmenu = false or i = ll_menucnt) Then
//			ll_ypos = pixelstoUnits(MenuDelimiterYPos, YpixelstoUnits!) //(dw_menubar.height - pixelstoUnits(MenuDelimiterHeight, YpixelstoUnits!)) / 2
//			ls_syntax += 'create bitmap(band=header filename="' + is_topmenu_alert_img + '" x="' + string(ll_xpos) + '" y="' + string(ll_ypos) + '" height="' + string(pixelstoUnits(MenuDelimiterHeight, YpixelstoUnits!)) + '" width="' + string(pixelstoUnits(MenuDelimiterWidth, XpixelstoUnits!)) + '" border="0"  name=p_menudist_' + string(i, '00') +  ' tag="" visible="1" )')
//		Else
//			/* to-be 상단 이미지 생성 */
//			ll_topimgypos	= ll_ypos + ll_textheight + pixelstoUnits(6, YpixelstoUnits!)
//			ll_topimgwidth	= ll_textwidth - pixelstoUnits(1, XpixelstoUnits!)
//			ls_syntax += 'create bitmap(band=header filename="' + is_topmenu_round_img + '" x="' + string(ll_topimgxpos) + '" y="' + string(ll_topimgypos) + '" height="' + string(pixelstoUnits(MenuDelimiterTopHeight, YpixelstoUnits!)) + '" width="' + string(ll_topimgwidth) + '" border="0"  name=p_menudisttop_' + string(i, '00') +  ' tag="" visible="0" )')
//			ll_xpos += pixelstoUnits(MenuDelimiterWidth, XpixelstoUnits!)			
//		end if
//	end if
Next

// 메뉴 길이(width) 보관
il_maxwidth = ll_xpos

// 데이터윈도우 생성
string	ls_error
ls_error = dw_menubar.modify(ls_syntax)
if len(ls_error) > 0 then
	::clipboard(ls_syntax)
	messagebox(dw_menubar.classname() + '.of_drawmenu() Error!!', ls_error)
	return -1
end if
// 다국어 타입 저장
is_lang_ins = gnv_vari.is_lang_type
// 메뉴 좌표 초기화
if dw_menubar.x <> 0 Then dw_menubar.x = 0

// 리사이즈 수행
this.event resize(0, this.width, this.height)

dw_menubar.setredraw(true)

return ll_menucnt

end function

public function long of_getmenuwidth ();return il_maxwidth

end function

public function integer of_initializemenu ();// 현재 표시된 메뉴를 초기화 합니다

// 데이터윈도우 초기화
dw_menubar.dataobject = dw_menubar.dataobject

// 현재 선택된 메뉴 초기화
ii_selectedmenuseq = 0

// 컨트롤 좌표 초기화
if hsb_1.visible = true then hsb_1.visible = false
if dw_menubar.x <> 0 then dw_menubar.x = 0

return 0

end function

public subroutine of_menuclicked (long al_row, string as_obj);string	ls_pgm_no, ls_menutext, ls_icon
string	ls_syntax, ls_error
long	ll_textypos
integer	li_colseq

ls_syntax = ''
if left(as_obj, 7) = "p_menu_" or left(as_obj, 7) = "t_menu_" or left(as_obj, 9) = "t_menubg_" or left(as_obj, 14) = "p_menudisttop_" then
	if ii_selectedmenuseq > 0 then
		ls_syntax += "t_menu_" + string(ii_selectedmenuseq, '00') + ".background.Color=" + string(ilmenu2transparent) + "~r~n"
		ls_syntax += "t_menubg_" + string(ii_selectedmenuseq, '00') + ".background.Color=" + string(ilmenu2transparent) + "~r~n"
		ls_syntax += "t_menu_" + string(ii_selectedmenuseq, '00') + ".Color=" + string(ilmenu2fontcolor) + "~r~n"
		ls_syntax += "t_menu_" + string(ii_selectedmenuseq, '00') + ".Font.Height=" + string(ilmenu2fontsize) + "~r~n"
		//if ibsubtopmenu = false then ls_syntax += "p_menudisttop_" + string(ii_selectedmenuseq, '00') + ".visible='0'" + "~r~n"
		ls_syntax += "p_menudisttop_" + string(ii_selectedmenuseq, '00') + ".visible='0'" + "~r~n"
		/* font size가 11 넘어가면 y position 조정 */
		//ll_textypos = Long(dw_menubar.Describe('t_menu_" + string(ii_selectedmenuseq, '00') + ".Y'))
		//lnv_syntax.of_append('t_menu_" + string(ii_selectedmenuseq, '00') + ".Y=" + string(ll_textypos + PixelsToUnits(1, YPixelsToUnits!))) /* to-be */
		
		/* to-be 아이콘 초기화 */
		if ib_menu_icon = true then
			ls_icon = dw_menubar.describe("p_menu_" + string(ii_selectedmenuseq, '00') + ".Filename")
			if Pos(ls_icon, '_clicked.jpg') > 0 then ls_icon = left(ls_icon, LastPos(ls_icon, '_clicked.') - 1) + '.jpg'
			ls_syntax += "p_menu_" + string(ii_selectedmenuseq, '00') + ".filename='" + ls_icon + "'~r~n"
		end if
		ii_selectedmenuseq = 0
	end if
	
	li_colseq = integer(right(as_obj, 2))
	
	//if ibsubtopmenu = false then ls_syntax += "p_menudisttop_" + string(li_colseq, '00') + ".visible='1'~r~n" /* to-be 상단 이미지 visible = TRUE */
	ls_syntax += "p_menudisttop_" + string(li_colseq, '00') + ".visible='1'~r~n" /* to-be 상단 이미지 visible = TRUE */
	
	if ib_menu_icon = true then
		ls_icon = dw_menubar.describe("p_menu_" + string(li_colseq, '00') + ".Filename")
		if Pos(ls_icon, '_clicked.') = 0 then ls_icon = left(ls_icon, LastPos(ls_icon, '.') - 1) + '_clicked.jpg'
		ls_syntax += "p_menu_" + string(li_colseq, '00') + ".filename='" + ls_icon + "'~r~n"
	end if	
	ls_syntax += "t_menu_" + string(li_colseq, '00') + ".background.Mode=0" + "~r~n"
	ls_syntax += "t_menubg_" + string(li_colseq, '00') + ".background.Mode=0" + "~r~n"
	if ibsubtopmenu = false then
		ls_syntax += "t_menubg_" + string(li_colseq, '00') + ".background.Color=" + string(gnv_vari.mdi2topmenuselected4backcolor) + "~r~n"
		ls_syntax += "t_menu_" + string(li_colseq, '00') + ".background.Color=" + string(ilmenu2transparent) + "~r~n"
		ls_syntax += "t_menu_" + string(li_colseq, '00') + ".Color=" + string(gnv_vari.mdi2topmenuselected4fontcolor) + "~r~n"
	else
		ls_syntax += "t_menubg_" + string(li_colseq, '00') + ".background.Color=" + string(gnv_vari.mdi2submenuselected4backcolor) + "~r~n"
		ls_syntax += "t_menu_" + string(li_colseq, '00') + ".background.Color=" + string(ilmenu2transparent) + "~r~n"
		ls_syntax += "t_menu_" + string(li_colseq, '00') + ".Color=" + string(gnv_vari.mdi2submenuselected4fontcolor) + "~r~n"
	end if
	ls_syntax += "t_menu_" + string(li_colseq, '00') + ".Font.Height='" + string(ilmenu2fontsize) + "'~r~n" /* to-be */
	/* font size가 11 넘어가면 y position 조정 */
	//ll_textypos = Long(dw_menubar.Describe('t_menu_" + string(li_colseq, '00') + ".Y'))
	//lnv_syntax.of_append('t_menu_" + string(li_colseq, '00') + ".Y=" + string(ll_textypos - PixelsToUnits(1, YPixelsToUnits!))) /* to-be */

	ls_error = dw_menubar.modify(ls_syntax)
	if len(ls_error) > 0 then
		if gw_mdi.ibbeonce4menu = true then
			if ibsubtopmenu = false then
				gnv_vari.is_last4topmenu = 't_menu_01'
				of_menuclicked(0, gnv_vari.is_last4topmenu)
				return
			else
				gnv_vari.is_last4submenu = 't_menu_01'
				of_menuclicked(0, gnv_vari.is_last4submenu)
				return
			end if
		end if
		::clipboard(ls_syntax)
		messagebox("Error", "topmenu clicked Error"+ ls_error)
	end if
	yield ( )
	ii_selectedmenuseq = li_colseq
	ls_pgm_no = dw_menubar.describe("t_menu_" + string(li_colseq, '00') + ".Tag")
	IF ibsubtopmenu Then
		gnv_vari.isprev4submenu = ls_pgm_no
	Else
		gnv_vari.isprev4topmenu = ls_pgm_no
	End IF
	this.event oue_clicked4menu(ls_pgm_no)
end if
	
if ibsubtopmenu = false then
	gnv_vari.of_setprofile("frame.last.topmenu", as_obj)
	gw_mdi.dynamic of_setmenu4top('01', as_obj)
else
	gnv_vari.of_setprofile("frame.last.submenu", as_obj)
	gw_mdi.dynamic of_setmenu4top('02', as_obj)
end if
end subroutine

public function string of_getlangtype ();Return is_lang_ins
end function

public function string of_getobj4menu (string as_pgmno);String		ls_object, ls_objarr[]
String		ls_tag, ls_objtype, ls_band
long		i, ll_objcnt
long		ll_objpos
Long		ll_bandheight, ll_ypos

ls_object = dw_menubar.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])

for i = 1 to ll_objcnt
	If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then Continue
	ls_objtype = dw_menubar.describe(ls_objarr[i] + ".Type")
	
	// text 컬럼인 경우만 디자인 적용
	If not (ls_objtype = "text") Then continue	
	ls_tag	= dw_menubar.describe(ls_objarr[i] + ".Tag")
	ls_band	= dw_menubar.describe(ls_objarr[i] + ".Band")	
	// 화면에 위치 하지 않는 컨트롤 제외
	If ls_band = "?" or ls_band = "!" Then continue
	If ls_tag = as_pgmno Then
		Return ls_objarr[i]
		Exit
	End If
Next

Return ''
end function

public subroutine of_setfind4menu2course (long al_row, string as_pgmno);string	ls_obj[]
string	ls_temp, ls_tag
long	ll_objcnt, i
ls_temp	= dw_menubar.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_temp, "~t", ls_obj[])
for i = 1 to ll_objcnt
	If Pos(ls_obj[i], 't_menubg_') = 1 Then Continue
	If Pos(ls_obj[i], 't_pgm_') = 0 Then Continue
	ls_tag = dw_menubar.describe(ls_obj[i] + ".tag")
	If as_pgmno = ls_tag Then
		of_menuclicked(0, ls_obj[i])
		exit
	End If
next

end subroutine

public function string of_thisname ();return 'fw_u_topmenu4frame'
end function

on fw_u_topmenu4frame.create
int iCurrent
call super::create
this.dw_menubar=create dw_menubar
this.hsb_1=create hsb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_menubar
this.Control[iCurrent+2]=this.hsb_1
end on

on fw_u_topmenu4frame.destroy
call super::destroy
destroy(this.dw_menubar)
destroy(this.hsb_1)
end on

event constructor;call super::constructor;MenuDelimiterHeight = MenuDelimiterHeight * gnv_vari.mswindowratedec /* to-be 화면 비율일 100%일 경우 와 그렇지 않을 경우 */

if ibsubtopmenu = true then
	ismenu2fontface	= issubmenu2fontface
	ilmenu2fontsize		= ilsubmenu2fontsize
	ilmenu2fontcolor	= gnv_vari.mdi2submenunotselected4fontcolor
	ilmenu2fontweight	= ilsubmenu2fontweight
	ilmenu2space		= ilsubmenu2space
else
	ismenu2fontface	= istopmenu2fontface
	ilmenu2fontsize		= iltopmenu2fontsize
	ilmenu2fontcolor	= gnv_vari.mdi2topmenunotselected4fontcolor
	ilmenu2fontweight	= iltopmenu2fontweight
	ilmenu2space		= iltopmenu2space
end if
end event

event resize;call super::resize;dw_menubar.height = newheight
hsb_1.x = newwidth - hsb_1.width

if il_maxwidth > newwidth then
	hsb_1.y = (newheight - hsb_1.height) / 2
	hsb_1.visible = true
else
	dw_menubar.x = 0
	hsb_1.visible = false
end if
end event

type dw_menubar from fw_u_dwo within fw_u_topmenu4frame
integer width = 29938
integer height = 124
integer taborder = 10
boolean bringtotop = true
string dataobject = "fw_d_topmenu4frame"
boolean border = false
end type

event clicked;call super::clicked;of_menuclicked(row, string(dwo.name))

gw_mdi.post dynamic of_setpgmexpression('')
end event

event mousemove;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname())
end event

type hsb_1 from pf_u_hscrollbar within fw_u_topmenu4frame
integer x = 2994
integer y = 12
integer width = 165
integer height = 100
boolean bringtotop = true
boolean stdheight = false
integer minposition = 1
integer maxposition = 100
integer position = 1
end type

event lineleft;call super::lineleft;If dw_menubar.x + 500 > 0 Then
	dw_menubar.x = 0
Else
	dw_menubar.x += 500
End If

end event

event lineright;call super::lineright;long ll_max

ll_max = (il_maxwidth - parent.width + this.width) * -1
if dw_menubar.x - 500 > ll_max then
	dw_menubar.x -= 500
else
	dw_menubar.x = ll_max
end if

end event

