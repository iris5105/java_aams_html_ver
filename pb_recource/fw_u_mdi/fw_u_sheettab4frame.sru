forward
global type fw_u_sheettab4frame from u_ancestor
end type
type p_pgm4close2 from pf_u_imagebutton within fw_u_sheettab4frame
end type
type dw_pgmtab from adw_jtier within fw_u_sheettab4frame
end type
type hsb_1 from pf_u_hscrollbar within fw_u_sheettab4frame
end type
type p_pgm4close1 from pf_u_imagebutton within fw_u_sheettab4frame
end type
type p_pgm4closeall from pf_u_imagebutton within fw_u_sheettab4frame
end type
end forward

global type fw_u_sheettab4frame from u_ancestor
integer width = 3163
integer height = 120
string text = ""
long tabtextcolor = 0
long picturemaskcolor = 0
boolean scaletoright = true
event type integer oue_addsheettab ( n_menu anvo_menudata )
event type integer oue_closesheettab ( n_menu anvo_menudata )
event type integer oue_deselectsheettab ( n_menu anvo_menudata )
event type integer oue_selectsheettab ( n_menu anvo_menudata )
event oue_setband4insert ( )
p_pgm4close2 p_pgm4close2
dw_pgmtab dw_pgmtab
hsb_1 hsb_1
p_pgm4close1 p_pgm4close1
p_pgm4closeall p_pgm4closeall
end type
global fw_u_sheettab4frame fw_u_sheettab4frame

type prototypes

end prototypes

type variables
private:
	constant Long DW_HSCROLL_UNIT = 200 // pixel
	
	window		iw_sheet[]
	datastore	ids_tab
	
	String		isdwasissyntax		= '' /* to-be constructor */
	Long		il_tabimageheight	= 0
	Long		il_maxtabwidth		= 0
	Long		il_selectedtabseq	= 0
	Long		il_deactivetabseq	= 0
	Long		il_closetabseq  	= 0
	Long		il_closeiconwidth
	Long		il_closeiconheight
	Long		il_maxtabseq		= 0
	Long		il_allowmax4xpos	= 0
	Long		TabStartXpos		= 0
	String		isnotselected4preobj	= ''

Public:
	String		NormalTabImageFile	= "..\img\mainframe\u_pgmtab\sheettab_normal.jpg"
	String		SelectedTabImageFile	= "..\img\mainframe\u_pgmtab\sheettab_selected.jpg"
	Long		TabTextLeftMargin		= 10 // pixel
	Long		TabTextRightMargin	= 30 // pixel
	long		il_tabmargin			= Long(PixelsToUnits(2, XPixelsToUnits!))
	Long		UnderLinePenColor		= RGB(0,0,255)
	Long		UnderLinePenWidth		= 1
	
	boolean	ShowUnderLine		= false
	boolean	dynTabWidth		= false
	
end variables

forward prototypes
public function integer of_selecttab (string as_pgm_no)
public function long of_addtab (string as_pgm_no, string as_pgm_id, string as_pgm_nm)
public function integer of_selecttab (long al_tabseq)
public function long of_addtab (string as_pgm_no, string as_pgm_id, string as_pgm_nm, readonly window aw_sheet)
public function integer of_closetab (long al_tabseq)
public function integer of_deselecttab (long al_tabseq)
public function integer of_sheetsetfocus (string as_pgm_no)
public function boolean of_isopenedsheet (string as_pgm_no)
public function string of_thisname ()
public function integer of_popup_addfavorite (string as_pgm_no, string as_pgm_id, string as_pgm_nm)
public function integer of_popup_programhelp (string as_pgm_no, string as_pgm_id, string as_pgm_nm)
public function integer of_popup_closeall ()
public function integer of_closewindow (string as_window)
public function long of_tablimit ()
public function integer of_scrolltab (long al_scrollwidth)
public subroutine of_setthiscreate ()
public subroutine of_setpgmexpression (string as_pgm_no)
public function integer of_popup_closewindow ()
public subroutine of_tabclicked (integer ai_xpos, integer ai_ypos, long al_row, string as_obj)
public function long of_setclosepicrevise (long al_tabseq)
public function long of_getallowmax4xpos (long al_width)
public subroutine of_setactive4hsb (long al_width)
public subroutine of_setdefault4obj ()
public subroutine of_setresize4dw (long al_newwidth, long al_newheight)
public subroutine of_setxpos2move (picture ap_pic)
public subroutine of_setclose22hide ()
public function boolean of_getclose22status ()
public function integer of_deselecttab ()
end prototypes

event type integer oue_addsheettab(n_menu anvo_menudata);string	ls_pgm_no, ls_pgm_id, ls_pgm_nm
long		ll_retval
window	lw_sheet_ref

ls_pgm_no		= anvo_menudata.is_pgm_no
ls_pgm_id		= anvo_menudata.is_pgm_id
ls_pgm_nm		= anvo_menudata.is_pgm_nm
lw_sheet_ref   = anvo_menudata.iw_sheet_ref

ll_retval = this.of_addtab(ls_pgm_no, ls_pgm_id, ls_pgm_nm, lw_sheet_ref)

Return ll_retval
end event

event type integer oue_closesheettab(n_menu anvo_menudata);Long	ll_tab_seq, ll_retval

ll_retval = this.of_closetab(anvo_menudata.ii_tabseq)

Return ll_retval
end event

event type integer oue_deselectsheettab(n_menu anvo_menudata);il_deactivetabseq = anvo_menudata.ii_tabseq

Return il_deactivetabseq
end event

event type integer oue_selectsheettab(n_menu anvo_menudata);Long	ll_retval

// Deactive 된 Tabseq가 있으면 먼저 처리
If il_deactivetabseq > 0 Then
	this.of_deselecttab(il_deactivetabseq)
	il_deactivetabseq = 0
End If

ll_retval = this.of_selecttab(anvo_menudata.ii_tabseq)

Return ll_retval
end event

event oue_setband4insert();dw_pgmtab.Insertrow(0)
end event

public function integer of_selecttab (string as_pgm_no);long ll_find, ll_tabseq

ll_find = ids_tab.find("pgm_no='" + as_pgm_no + "'", 1, ids_tab.rowcount())
if ll_find <= 0 then return -1

ll_tabseq = ids_tab.getitemnumber(ll_find, 'tab_seq')

return this.of_selecttab(ll_tabseq)
end function

public function long of_addtab (string as_pgm_no, string as_pgm_id, string as_pgm_nm);String	ls_syntax, ls_errmsg, ls_pgmtext

Long	ll_new, ll_tabseq, ll_textlen
Long	ll_textwidth, ll_textheight, ll_tabimgxpos

pf_s_size	lstr_imagesize, lstr_textsize, lstr_mintextsize

ll_new = ids_tab.insertrow(0)
ll_tabseq = il_maxtabseq + 1
ids_tab.setitem(ll_new, 'tab_seq', ll_tabseq)
ids_tab.setitem(ll_new, 'pgm_no', as_pgm_no)
ids_tab.setitem(ll_new, 'pgm_id', as_pgm_id)
ids_tab.setitem(ll_new, 'pgm_nm', as_pgm_nm)
If Pos(as_pgm_nm, '&') > 0 Then as_pgm_nm = fw_f_replaceall(as_pgm_nm, '&', '&&')
		
ll_textwidth   = PixelsToUnits(110, XPixelsToUnits!)
ll_textheight	= PixelsToUnits(19, YPixelsToUnits!)
ll_textlen 		= LenA (as_pgm_nm) * PixelsToUnits(7, XPixelsToUnits!)
If gnv_vari.getclienttype = 'WEB' Then
	If ll_textlen > ll_textwidth Then
		ls_pgmtext = left(as_pgm_nm, 8)
		If fw_f_nvls(ls_pgmtext, '') = '' Then
			ls_pgmtext = as_pgm_nm + '...'
		Else
			ls_pgmtext = left(as_pgm_nm, 8) + '...'
		End If
	Else
		ls_pgmtext = as_pgm_nm
	End If
Else
	ls_pgmtext = as_pgm_nm
End If
gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = String(ll_tabseq)
gnv_extfunc.istr_node4value.cstr02 = as_pgm_no
gnv_extfunc.istr_node4value.cstr03 = String(10)
gnv_extfunc.istr_node4value.cstr04 = String(400)
gnv_extfunc.istr_node4value.cstr05 = as_pgm_nm
gnv_extfunc.biznode11te(115, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

// 탭 이미지 생성
String	ls_tabnotselectedimage, ls_tabselectedimage
Long	ll_imagewidth, ll_imageheight
Long	ll_textxpos, ll_textypos

ls_tabnotselectedimage = gnv_vari.is_tempdirectory + "tabnotselectedimage_" + String(ll_tabseq, '000') + ".png"
ls_tabselectedimage = gnv_vari.is_tempdirectory + "tabselectedimage_" + String(ll_tabseq, '000') + ".png"
gnv_extfunc.CopyFileA(NormalTabImageFile, ls_tabnotselectedimage, false)
gnv_extfunc.CopyFileA(SelectedTabImageFile, ls_tabselectedimage, false)

ll_imagewidth	= ll_textwidth + Long(PixelsToUnits(TabTextLeftMargin + TabTextRightMargin * gnv_vari.mswindowratedec, XPixelsToUnits!))   /* 화면 비율일 100%일 경우 와 그렇지 않을 경우 */
ll_imageheight	= PixelsToUnits(il_tabimageheight, YPixelsToUnits!)
//If il_selectedtabseq = 0 Then TabStartXpos -= Long(PixelsToUnits(10, XPixelsToUnits!))

ll_textxpos = TabStartXpos + il_maxtabwidth + PixelsToUnits(TabTextLeftMargin, XPixelsToUnits!)
ll_textxpos = Long(PixelsToUnits(UnitsToPixels(ll_textxpos, XUnitsToPixels!), XPixelsToUnits!))
ll_textypos = Round(ll_imageheight * 0.25, 0)
ll_textypos = Long(PixelsToUnits(UnitsToPixels(ll_textypos, YUnitsToPixels!), YPixelsToUnits!))

ll_tabimgxpos = TabStartXpos + il_maxtabwidth
ls_syntax = "create bitmap(band=detail pointer='HyperLink!' filename='" + ls_tabnotselectedimage + "' x='" + String(ll_tabimgxpos) + "' y='0' height='" + String(ll_imageheight) + "' width='" + String(ll_imagewidth) + "' border='0' name=tabnotselected_" + String(ll_tabseq, '000') + " visible='0' )~r~n"
//<임시> open시 tabselected를 켜두면 클릭된 탭이 두개이상 보이는 버그발생 20211020
//ls_syntax += "create bitmap(band=detail pointer='HyperLink!' filename='" + ls_tabselectedimage + "' x='" + String(ll_tabimgxpos) + "' y='0' height='" + String(ll_imageheight) + "' width='" + String(ll_imagewidth) + "' border='0' name=tabselected_" + String(ll_tabseq, '000') + " visible='1' )~r~n"
ls_syntax += "create bitmap(band=detail pointer='HyperLink!' filename='" + ls_tabselectedimage + "' x='" + String(ll_tabimgxpos) + "' y='0' height='" + String(ll_imageheight) + "' width='" + String(ll_imagewidth) + "' border='0' name=tabselected_" + String(ll_tabseq, '000') + " visible='0' )~r~n"
ls_syntax += gnv_extfunc.istr_node4value.cstr09 + "color='0~trgb(128,128,128)' x='" + String(ll_textxpos) + "' y='" + String(ll_textypos) + "' height='" + String(ll_textheight) + "' width='" + String(ll_textwidth) + "' html.valueishtml='0'  name=menutext_" + String(ll_tabseq, '000') + gnv_extfunc.istr_node4value.cstr11
ls_errmsg = dw_pgmtab.Modify(ls_syntax)
If len(ls_errmsg) > 0 then
	::clipboard(ls_syntax)
	messagebox('modify error', ls_errmsg)
	Return -1
End If

dw_pgmtab.setitem(1, 'menutext_' + string(ll_tabseq, '000'), ls_pgmtext)
ids_tab.setitem(ll_new, 'image_xpos', il_maxtabwidth)
ids_tab.setitem(ll_new, 'image_width', ll_imagewidth)

If il_maxtabwidth = 1 Then il_maxtabwidth = 0
il_maxtabwidth	+= ll_imagewidth + il_tabmargin
il_maxtabseq = ll_tabseq

/* to-be  DW 스크롤용 HScrollBar 컨트롤 Visible 처리 p_pgm4closeall position */
Long	ll_scrollwidth
il_allowmax4xpos = of_getallowmax4xpos(This.width)
If (TabStartXpos + il_maxtabwidth) > 0 Then
	p_pgm4closeall.x = il_allowmax4xpos
	If gnv_vari.getclienttype	= gnv_extfunc.istr_node4value.cstr10 Then p_pgm4closeall.x -= Long(PixelsToUnits(1, XPixelsToUnits!))
	If p_pgm4closeall.visible = False Then p_pgm4closeall.visible = True
End If

If (TabStartXpos + il_maxtabwidth) > il_allowmax4xpos then
	of_setactive4hsb(This.width)
	p_pgm4closeall.x = hsb_1.x - p_pgm4closeall.width - Long(PixelsToUnits(3, XPixelsToUnits!))
	ll_scrollwidth = ((TabStartXpos + il_maxtabwidth) - This.width + hsb_1.width + p_pgm4closeall.width) * -1
	this.of_scrolltab(ll_scrollwidth)
End If
		
Return ll_tabseq
end function

public function integer of_selecttab (long al_tabseq);String	ls_syntax, ls_errmsg
Long		ll_findrow
Long		ll_closexpos, ll_closeypos

If il_selectedtabseq = al_tabseq Then Return 0

ll_findrow = ids_tab.find("tab_seq=" + String(al_tabseq), 1, ids_tab.rowcount())
If ll_findrow <= 0 then Return -1

ll_closexpos = of_setclosepicrevise(al_tabseq)
If ll_closexpos < 0 Then Return 0

ll_closeypos = round((PixelsToUnits(il_tabimageheight, YPixelsToUnits!) - il_closeiconheight) * (3 / 5), 0) - Long(PixelsToUnits(1, YPixelsToUnits!))
//ll_closeypos = Long(PixelsToUnits(UnitsToPixels(ll_closeypos, YUnitsToPixels!), YPixelsToUnits!))// - Long(PixelsToUnits(1, YPixelsToUnits!))

p_pgm4close1.x = ll_closexpos
p_pgm4close1.y = ll_closeypos
p_pgm4close1.visible = True
ls_syntax = 'tabnotselected_' + String(al_tabseq, '000') + '.Visible="0"~r~n'
ls_syntax += 'tabselected_' + String(al_tabseq, '000') + '.Visible="1"~r~n'
ls_syntax += 'menutext_' + String(al_tabseq, '000') + '.Color="0~t' + gnv_vari.sheettab2selected4fontcolor + '"~r~n'
ls_syntax += 'menutext_' + String(al_tabseq, '000') + '.Font.Weight="400"~r~n'

ls_errmsg = dw_pgmtab.modify(ls_syntax)
If len(ls_errmsg) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selecttab() error', ls_errmsg)
	Return -1
End If

p_pgm4close1.show()
p_pgm4closeall.show()
il_selectedtabseq = al_tabseq

Return 1
end function

public function long of_addtab (string as_pgm_no, string as_pgm_id, string as_pgm_nm, readonly window aw_sheet);long	ll_tabseq

ll_tabseq = this.of_addtab(as_pgm_no, as_pgm_id, as_pgm_nm)
If ll_tabseq > 0 Then iw_sheet[ll_tabseq] = aw_sheet
Return ll_tabseq
end function

public function integer of_closetab (long al_tabseq);String	ls_syntax, ls_error

Long	ll_shiftwidth, ll_rownum
long	ll_imagexpos, ll_textxpos, ll_tabseq

integer	i

gnv_extfunc.of_setinitializationapi()
gnv_extfunc.istr_node4value.cstr01 = String(al_tabseq)
gnv_extfunc.biznode11te(113, handle(This), gnv_vari.is_nodekey, gnv_extfunc.istr_node4value)

ll_rownum = ids_tab.find(gnv_extfunc.istr_node4value.cstr05 + string(al_tabseq), 1, ids_tab.rowcount())
If ll_rownum <= 0 Then Return -1

ll_shiftwidth = long(dw_pgmtab.describe(gnv_extfunc.istr_node4value.cstr08 + string(al_tabseq, '000') + ".width")) + il_tabmargin

ls_syntax = "destroy tabnotselected_" + string(al_tabseq, '000') + "~r~n"
ls_syntax += "destroy tabselected_" + string(al_tabseq, '000') + "~r~n"
ls_syntax += "destroy menutext_" + string(al_tabseq, '000') + "~r~n"


For i = ll_rownum + 1 to ids_tab.rowcount()
	ll_tabseq = ids_tab.getitemnumber(i, gnv_extfunc.istr_node4value.cstr07)
	ll_imagexpos = long(dw_pgmtab.describe(gnv_extfunc.istr_node4value.cstr02 + string(ll_tabseq, '000') + ".x")) - ll_shiftwidth
	ll_textxpos = long(dw_pgmtab.describe("menutext_" + string(ll_tabseq, '000') + ".x")) - ll_shiftwidth
	
	ls_syntax += "tabnotselected_" + string(ll_tabseq, '000') + ".X='" + string(ll_imagexpos) + "'~r~n"
	ls_syntax += gnv_extfunc.istr_node4value.cstr04 + string(ll_tabseq, '000') + ".X='" + string(ll_imagexpos) + "'~r~n"
	ls_syntax += "menutext_" + string(ll_tabseq, '000') + ".X='" + string(ll_textxpos) + "'~r~n"
Next

ls_error = dw_pgmtab.Modify(ls_syntax)
If len(ls_error) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_closetab error', ls_error)
	Return -1
End If

il_maxtabwidth -= ll_shiftwidth
ids_tab.deleterow(ll_rownum)
If ids_tab.rowcount() = 0 Then of_setdefault4obj()

If TabStartXpos + ll_shiftwidth > 0 Then
	this.of_scrolltab(-TabStartXpos)
else
	this.of_scrolltab(ll_shiftwidth)
End If

If il_maxtabwidth <= dw_pgmtab.width Then
	hsb_1.Visible = false
	If p_pgm4closeall.Visible = True Then
		p_pgm4closeall.x = This.Width - p_pgm4closeall.Width - Long(PixelsToUnits(3, XPixelsToUnits!))
		If gnv_vari.getclienttype = gnv_extfunc.istr_node4value.cstr12 Then p_pgm4closeall.x -= Long(PixelsToUnits(1, XPixelsToUnits!))
	End If
End If

Return 1
end function

public function integer of_deselecttab (long al_tabseq);long		ll_rownum
string	ls_syntax, ls_errmsg

ll_rownum = ids_tab.find("tab_seq=" + string(al_tabseq), 1, ids_tab.rowcount())
if ll_rownum <= 0 then return -1

ls_syntax = 'tabnotselected_' + string(al_tabseq, '000') + '.Visible="1"~r~n'
ls_syntax += 'tabselected_' + string(al_tabseq, '000') + '.Visible="0"~r~n'
ls_syntax += 'menutext_' + string(al_tabseq, '000') + '.Color="0~t' + gnv_vari.sheettab2notselected4fontcolor + '"~r~n'
ls_syntax += 'menutext_' + string(al_tabseq, '000') + '.Font.Weight="400"~r~n'

p_pgm4close1.visible = False

ls_errmsg = dw_pgmtab.modify(ls_syntax)
if len(ls_errmsg) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_deselect() error', ls_errmsg)
	return -1
end if

il_selectedtabseq = 0

return 1
end function

public function integer of_sheetsetfocus (string as_pgm_no);long ll_find, ll_tabseq

ll_find = ids_tab.find("pgm_no='" + as_pgm_no + "'", 1, ids_tab.rowcount())
if ll_find <= 0 then return -1

ll_tabseq = ids_tab.getitemnumber(ll_find, 'tab_seq')
if not isvalid(iw_sheet[ll_tabseq]) then return -1

gw_mdi.st_mdiclient.show()
iw_sheet[ll_tabseq].dynamic of_ctlssetredraw( False )
iw_sheet[ll_tabseq].Post setfocus()
gw_mdi.st_mdiclient.Post hide()
iw_sheet[ll_tabseq].Post dynamic of_ctlssetredraw( True )
Return 1
end function

public function boolean of_isopenedsheet (string as_pgm_no);long ll_fnd

if isnull(as_pgm_no) then return false
if len(trim(as_pgm_no)) = 0 then return false

ll_fnd = ids_tab.find("pgm_no='" + as_pgm_no + "'", 1, ids_tab.rowcount())
if ll_fnd > 0 then
	return true
else
	return false
end if

end function

public function string of_thisname ();return 'fw_u_sheettab4frame'
end function

public function integer of_popup_addfavorite (string as_pgm_no, string as_pgm_id, string as_pgm_nm);n_menu lnv_menu

lnv_menu = create n_menu
lnv_menu.is_pgm_no = as_pgm_no
lnv_menu.is_pgm_id = as_pgm_id
lnv_menu.is_pgm_nm = as_pgm_nm

openwithparm(fw_w_bookmark, lnv_menu)
if message.stringparm = 'OK' then
	n_menu	lnvo_m
	gw_mdi.of_setdynamicevent('fw_u_bookmark4frame', 'oue_refreshmenu', lnvo_m)
end if

return 1

end function

public function integer of_popup_programhelp (string as_pgm_no, string as_pgm_id, string as_pgm_nm);n_menu	lnv_menu
lnv_menu = Create n_menu

lnv_menu.is_pgm_no	= as_pgm_no
lnv_menu.is_pgm_id	= as_pgm_id
lnv_menu.is_pgm_nm	= as_pgm_nm

Openwithparm(fw_w_pgm_help_ent, lnv_menu)

Return 1
end function

public function integer of_popup_closeall ();// 현재 오픈된 모든 쉬트 윈도우를 모두 종료합니다
string		ls_menu_sn
integer		li_sheetcnt, i
long		ll_close, ll_closequery

p_pgm4close1.visible = false
of_setxpos2move(p_pgm4close1)
gw_mdi.of_loadingwait(true)
li_sheetcnt = upperbound(iw_sheet)
for i = 1 to li_sheetcnt
	if IsValid(iw_sheet[i]) then
		if not(iw_sheet[i].classname() = gnv_vari.w_home) then
			ll_close = close(iw_sheet[i])
			ll_closequery = gw_mdi.il_return4sheetclosequery
			if not(ll_close = 1) or ll_closequery = 1 then
				gw_mdi.of_loadingwait(false)
				ls_menu_sn = iw_sheet[i].dynamic of_getpgmno()
				of_sheetsetfocus(ls_menu_sn)
				return -1
			end if
//		else
//			gw_ezframe.st_mdiclient.hide()
		end if
	end if
	yield ( )
next

of_setdefault4obj()
of_setthiscreate()
gw_mdi.of_loadingwait(false)

return 1
end function

public function integer of_closewindow (string as_window);integer li_sheetcnt, i

li_sheetcnt = upperbound(iw_sheet)
For i = 1 To li_sheetcnt
	If Isvalid(iw_sheet[i]) Then
		If iw_sheet[i].classname() = as_window Then 
			//If MessageBox("Check", 'Menu 비활성화 중입니다. 종료하시겠습니까?', Exclamation!, OKCancel!, 1) = 1 Then Close(iw_sheet[i])
			Close(iw_sheet[i])
			Exit
		End If
	End If
Next

Return 1
end function

public function long of_tablimit ();Return ids_tab.rowcount()
end function

public function integer of_scrolltab (long al_scrollwidth);If al_scrollwidth = 0 Then Return 0

String	ls_objects[]
String	ls_syntax, ls_errmsg
String	ls_objtype, ls_tabseq

Long	i, ll_objcnt, ll_x, ll_x2, ll_find

ll_objcnt = fw_f_obj2array(dw_pgmtab.describe("Datawindow.Objects"), "~t", ls_objects[])

for i = 1 to ll_objcnt
	ls_objtype = dw_pgmtab.describe(ls_objects[i] + ".Type")
	Choose Case ls_objtype
		Case 'column'
			ls_tabseq = string(long(right(ls_objects[i], 3)))
			ll_find = ids_tab.find("tab_seq=" + ls_tabseq, 1, ids_tab.rowcount())
			If ll_find > 0 Then
				ll_x = long(dw_pgmtab.describe(ls_objects[i] + ".x")) + al_scrollwidth
				ls_syntax += ls_objects[i] + '.x=' + string(ll_x) + '~r~n'
			End If
		Case 'text', 'bitmap'
			ll_x = long(dw_pgmtab.describe(ls_objects[i] + ".x")) + al_scrollwidth
			ls_syntax += ls_objects[i] + '.x=' + string(ll_x) + '~r~n'
		Case 'line'
			ll_x = long(dw_pgmtab.describe(ls_objects[i] + ".x1"))
			ll_x2 = long(dw_pgmtab.describe(ls_objects[i] + ".x2"))
			ls_syntax += ls_objects[i] + '.x1=' + string(ll_x + al_scrollwidth) + '~r~n'
			ls_syntax += ls_objects[i] + '.x2=' + string(ll_x2 + al_scrollwidth) + '~r~n'
	End Choose
next

ls_errmsg = dw_pgmtab.modify(ls_syntax)
If len(ls_errmsg) > 0 Then
	::clipboard(ls_syntax)
	messagebox(this.classname() + '.of_scrolltab()', ls_errmsg)
	Return -1
End If

TabStartXpos += al_scrollwidth

Return 0
end function

public subroutine of_setthiscreate ();dw_pgmtab.Create( isdwasissyntax )
gnv_extfunc.biznode1te(152, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
TriggerEvent(gnv_extfunc.is_nodevalue)
end subroutine

public subroutine of_setpgmexpression (string as_pgm_no);If il_selectedtabseq < 1 Then Return
String	ls_pgmno
Long		ll_fnd

ll_fnd = ids_tab.find("tab_seq=" + String(il_selectedtabseq), 1, ids_tab.rowcount())
If ll_fnd > 0 Then
	ls_pgmno = ids_tab.GetItemString(ll_fnd, 'pgm_no')
	If gw_mdi.uo_xpmenu.visible = True Then gw_mdi.uo_xpmenu.of_setpgmexpression(ls_pgmno)
	If gw_mdi.uo_bookmark.visible = True Then gw_mdi.uo_bookmark.of_setpgmexpression(ls_pgmno)
End If
end subroutine

public function integer of_popup_closewindow ();of_tabclicked(0, 0, 0, 'p_close')
Return 1
end function

public subroutine of_tabclicked (integer ai_xpos, integer ai_ypos, long al_row, string as_obj);IF as_obj='p_pgm4close' AND il_selectedtabseq>0 Then
   IF isvalid(iw_sheet[il_selectedtabseq]) THEN CLOSE (iw_sheet[il_selectedtabseq])
END IF

WINDOW   lw_sheet

lw_sheet = gw_mdi.GetActiveSheet ()
IF POS(gnv_vari.w_home, lw_sheet.Classname())>0 Then
   p_pgm4close1.VISIBLE = false
END IF

IF as_obj='p_pgm4close' Then
   IF il_selectedtabseq=0 THEN gw_mdi.of_setpgmexpression ('')
END IF
IF POS(as_obj, 'tabnotselected_') + POS(as_obj, 'tabselected_') + POS(as_obj, 'menutext_')=0 THEN RETURN

LONG	ll_tabseq

ll_tabseq = LONG (right(as_obj, 3))
IF ll_tabseq = 0 THEN RETURN
iw_sheet [ll_tabseq].DYNAMIC of_setsync4topmenu()
IF ll_tabseq=il_selectedtabseq AND POS(gnv_vari.w_home, lw_sheet.Classname())=0 THEN RETURN

IF Isvalid(iw_sheet[ll_tabseq])  Then
   gw_mdi.st_mdiclient.show()
   iw_sheet [ll_tabseq].DYNAMIC of_ctlssetredraw (False)
   iw_sheet [ll_tabseq].Setfocus()
   gw_mdi.st_mdiclient.hide()
   iw_sheet [ll_tabseq].DYNAMIC of_ctlssetredraw (True)
   iw_sheet [ll_tabseq].triggerevent ('ue_activate')

   // 선택 tab 메뉴이동
   STRING	ls_pgm_no, ls_fullpgmlvl4cd, ls_tobelv1, ls_tobemobj
   STRING	ls_pgmarr []
   LONG	ll_pgmcnt, ll_i

   lw_sheet  = gw_mdi.GetActiveSheet ()
   ls_pgm_no = lw_sheet.DYNAMIC of_getpgmno()

   ls_fullpgmlvl4cd = gnv_rolemenu.of_getlevellist4pgm (ls_pgm_no)
   ll_pgmcnt        = fw_f_obj2array (ls_fullpgmlvl4cd, ';', ls_pgmarr[])
   IF ll_pgmcnt<1 THEN RETURN
   FOR ll_i = 1 TO ll_pgmcnt
      IF ls_pgmarr[ll_i]='0'     THEN CONTINUE
      IF ls_pgmarr[ll_i]='00000' THEN CONTINUE
      ls_tobelv1 = ls_pgmarr [ll_i]
      EXIT
   Next
   ls_tobemobj = gw_mdi.uo_topmenu.DYNAMIC of_getobj4menu (ls_tobelv1)
   IF fw_f_nvls(ls_tobemobj, '')<>'' THEN gw_mdi.uo_topmenu.DYNAMIC of_menuclicked (0, ls_tobemobj)
   Yield ()
   gw_mdi.uo_xpmenu.of_setpgmexpression (ls_pgm_no)
END IF
end subroutine

public function long of_setclosepicrevise (long al_tabseq);Long	ll_closexpos, ll_tabtextrightmargin
Long	ll_imagexpos, ll_imagewidth

ll_imagexpos = Long(dw_pgmtab.Describe("tabnotselected_" + string(al_tabseq, '000') + ".x"))
ll_imagewidth = Long(dw_pgmtab.Describe("tabnotselected_" + string(al_tabseq, '000') + ".width"))

ll_tabtextrightmargin = PixelsToUnits(TabTextRightMargin * gnv_vari.mswindowratedec, XPixelsToUnits!)
ll_closexpos = (ll_imagexpos + ll_imagewidth - ll_tabtextrightmargin) + Round((ll_tabtextrightmargin - il_closeiconwidth) / 2, 0)
ll_closexpos = Long(PixelsToUnits(UnitsToPixels(ll_closexpos, XUnitsToPixels!), XPixelsToUnits!)) - Long(PixelsToUnits(2, XPixelsToUnits!))

Return ll_closexpos
end function

public function long of_getallowmax4xpos (long al_width);Return al_width - p_pgm4closeall.width - Long(PixelsToUnits(3, XPixelsToUnits!))
end function

public subroutine of_setactive4hsb (long al_width);hsb_1.x = al_width - hsb_1.width	 - Long(PixelsToUnits(1, XPixelsToUnits!))
If hsb_1.visible = False Then hsb_1.visible = True
end subroutine

public subroutine of_setdefault4obj ();il_maxtabwidth		= 0
il_selectedtabseq	= 0
il_deactivetabseq	= 0
il_maxtabseq		= 0
il_allowmax4xpos	= 0
TabStartXpos		= 0
p_pgm4close1.Visible	= false /* to-be */
p_pgm4close2.Visible	= false /* to-be */
p_pgm4closeall.Visible	= false /* to-be */
fw_f_setsheet2maximized()
gw_mdi.of_setpgmexpression('') /* to-be */
end subroutine

public subroutine of_setresize4dw (long al_newwidth, long al_newheight);dw_pgmtab.x = 0
dw_pgmtab.width = al_newwidth
dw_pgmtab.height = al_newheight
end subroutine

public subroutine of_setxpos2move (picture ap_pic);ap_pic.x = Long(pixelstounits(7000, XPixelsToUnits!))
end subroutine

public subroutine of_setclose22hide ();of_setxpos2move(p_pgm4close2)
p_pgm4close2.hide()
end subroutine

public function boolean of_getclose22status ();//If isnotselected4preobj = ls_obj Then return true
return p_pgm4close2.visible
end function

public function integer of_deselecttab ();if il_selectedtabseq = 0 then return 1

long		ll_rownum
string	ls_syntax, ls_errmsg

ll_rownum = ids_tab.find("tab_seq=" + string(il_selectedtabseq), 1, ids_tab.rowcount())
if ll_rownum <= 0 then return -1

ls_syntax = 'tabnotselected_' + string(il_selectedtabseq, '000') + '.Visible="1"~r~n'
ls_syntax += 'tabselected_' + string(il_selectedtabseq, '000') + '.Visible="0"~r~n'
ls_syntax += 'menutext_' + string(il_selectedtabseq, '000') + '.Color="0~t' + gnv_vari.sheettab2notselected4fontcolor + '"~r~n'
ls_syntax += 'menutext_' + string(il_selectedtabseq, '000') + '.Font.Weight="400"~r~n'

p_pgm4close1.visible = False

ls_errmsg = dw_pgmtab.modify(ls_syntax)
if len(ls_errmsg) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_deselect() error', ls_errmsg)
	return -1
end if

il_selectedtabseq = 0

return 1
end function

on fw_u_sheettab4frame.create
int iCurrent
call super::create
this.p_pgm4close2=create p_pgm4close2
this.dw_pgmtab=create dw_pgmtab
this.hsb_1=create hsb_1
this.p_pgm4close1=create p_pgm4close1
this.p_pgm4closeall=create p_pgm4closeall
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_pgm4close2
this.Control[iCurrent+2]=this.dw_pgmtab
this.Control[iCurrent+3]=this.hsb_1
this.Control[iCurrent+4]=this.p_pgm4close1
this.Control[iCurrent+5]=this.p_pgm4closeall
end on

on fw_u_sheettab4frame.destroy
call super::destroy
destroy(this.p_pgm4close2)
destroy(this.dw_pgmtab)
destroy(this.hsb_1)
destroy(this.p_pgm4close1)
destroy(this.p_pgm4closeall)
end on

event constructor;call super::constructor;string ls_syntax

SelectedTabImageFile = pf_f_getimagepathappeon(SelectedTabImageFile)
NormalTabImageFile = pf_f_getimagepathappeon(NormalTabImageFile)

// 탭페이지 정보 보관용 데이터윈도우
ids_tab = Create datastore
ids_tab.dataobject = 'fw_d_sheettab4frame_ds1'

// 이미지 사이즈를 구해와 데이터윈도우 높이를 맞춘다
If fileexists(SelectedTabImageFile) and fileexists(NormalTabImageFile) Then
	pf_s_size lstr_imagesize
	gnv_extfunc.biz_getimgsize(NormalTabImageFile, lstr_imagesize)
	il_tabimageheight = lstr_imagesize.height * gnv_vari.mswindowratedec /* to-be 화면 비율일 100%일 경우 와 그렇지 않을 경우 */
	
	dw_pgmtab.height = PixelsToUnits(il_tabimageheight, YPixelsToUnits!)
	p_pgm4closeall.y = dw_pgmtab.y
	ls_syntax = "DataWindow.Detail.Height='" + String(dw_pgmtab.height) + "'"
	//dw_pgmtab.modify("DataWindow.Header.Height=" + string(dw_pgmtab.height))
End If

// 탭 Close 아이콘 높이 보관
il_closeiconwidth	= p_pgm4close1.width
il_closeiconheight	= p_pgm4close1.height

// 데이터윈도우 백그라운드 컬러 - MDI 윈도우의 Background Color 를 사용합니다
//long ll_backcolor
//ll_backcolor = iw_parent.dynamic of_getbackgroundcolor()
//ls_syntax += "~r~nDataWindow.Header.Color='" + string(ll_backcolor) + "'"
ls_syntax += "~r~nDataWindow.Color='" + string(gnv_vari.sheetbackcolor) + "'"
ls_syntax += "~r~nDataWindow.Detail.Color='" + string(gnv_vari.framebackcolor) + "'"
//dw_pgmtab.modify("DataWindow.Header.Color=" + string(TabControlBackColor))

// 언더라인 표시
If ShowUnderLine = true Then
	long ll_ypos
	ll_ypos = dw_pgmtab.height - PixelsToUnits(UnderLinePenWidth - 1, yPixelsToUnits!)
	
	ls_syntax += "~r~nl_underline1.Visible='1'"
	ls_syntax += "~r~nl_underline1.Pen.Color='" + string(UnderLinePenColor) + "'"
	ls_syntax += "~r~nl_underline1.Pen.Width='" + string(UnderLinePenWidth) + "'"
	ls_syntax += "~r~nl_underline1.Y1='" + string(ll_ypos) + "'"
	ls_syntax += "~r~nl_underline1.Y2='" + string(ll_ypos) + "'"
End If

string ls_errmsg
ls_errmsg = dw_pgmtab.modify(ls_syntax)
If len(ls_errmsg) > 0 Then
	messagebox(this.classname() + '.constructor', ls_errmsg)
	return -1
End If

// 탭 시작위치
il_maxtabwidth = TabStartXpos

end event

event destructor;//If gnv_vari.getclienttype = 'PB' and IsValid(ids_tab) Then Destroy ids_tab
If IsValid(ids_tab) Then Destroy ids_tab
end event

event resize;call super::resize;of_setresize4dw(newwidth, newheight)
il_allowmax4xpos = of_getallowmax4xpos(newwidth)
If il_maxtabwidth > il_allowmax4xpos Then
	of_setactive4hsb(newwidth)
	p_pgm4closeall.x = hsb_1.x - p_pgm4closeall.width - Long(PixelsToUnits(3, XPixelsToUnits!))
Else
	dw_pgmtab.x	= 0
	hsb_1.visible	= False
	p_pgm4closeall.x = This.width - p_pgm4closeall.width - Long(PixelsToUnits(3, XPixelsToUnits!))
	If TabStartXpos < 0 Then This.of_scrolltab(-TabStartXpos) /* to-be */
End If
If il_selectedtabseq > 0 Then p_pgm4close1.x = of_setclosepicrevise(il_selectedtabseq)
end event

type p_pgm4close2 from pf_u_imagebutton within fw_u_sheettab4frame
boolean visible = false
integer x = 2706
integer y = 44
integer width = 69
integer height = 60
boolean bringtotop = true
string picturename = "..\img\mainframe\u_pgmtab\tab_ico_close2.jpg"
boolean i----------------------------------------------------line1 = true
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
this.visible=false
string	ls_pgm_no

long	ll_seq

ll_seq = long(right(isnotselected4preobj, 3))
If long(ll_seq) > 0 Then
	of_selecttab(ll_seq)
	ls_pgm_no = iw_sheet[il_selectedtabseq].dynamic of_getpgmno()
	of_sheetsetfocus(ls_pgm_no)
End If
of_setxpos2move(this)
il_closetabseq = long(right(isnotselected4preobj, 3))
gnv_extfunc.biznode1te(146, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
Post of_tabclicked(0, 0, 0, gnv_extfunc.is_nodevalue)
end event

type dw_pgmtab from adw_jtier within fw_u_sheettab4frame
event oue_postopen ( )
event mousemove pbm_dwnmousemove
integer width = 3163
integer height = 120
integer taborder = 10
string dataobject = "fw_d_sheettab4frame_2"
boolean border = false
end type

event oue_postopen();isdwasissyntax = This.Describe("DataWindow.Syntax")

gnv_extfunc.biznode1te(152, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
Parent.TriggerEvent(gnv_extfunc.is_nodevalue)
end event

event mousemove;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname() + '-setclose22hide')
string	ls_obj
Long	ll_closexpos, ll_closeypos, ll_pos, ll_seq
ls_obj = string(dwo.name)
If isnotselected4preobj = ls_obj Then Return
ll_pos = Pos(ls_obj, 'tabnotselected_') + pos(ls_obj, 'menutext_')
If ll_pos > 0 Then
	ll_seq = long(right(ls_obj, 3))
	If il_selectedtabseq = ll_seq Then Return
	ll_closexpos = of_setclosepicrevise(ll_seq)
	If ll_closexpos < 0 Then Return
	
	ll_closeypos = p_pgm4close1.y
	
	p_pgm4close2.x = ll_closexpos
	p_pgm4close2.y = ll_closeypos
	p_pgm4close2.show()
	isnotselected4preobj = ls_obj
Else
	of_setclose22hide()
End If
Yield ( )
end event

event rbuttondown;long ll_tabseq
long ll_find
string ls_obj

ls_obj = string(dwo.name)
if pos(ls_obj, 'tabnotselected_') + pos(ls_obj, 'tabselected_') + pos(ls_obj, 'menutext_') = 0 then return -1

ll_tabseq = long(right(ls_obj, 3))
if ll_tabseq = 0 then return -1
if ll_tabseq <> il_selectedtabseq then return 0

// 탭 메뉴
fw_m_mdipgmtab lm_popup
string ls_pgm_no, ls_pgm_id, ls_pgm_nm

ll_find = ids_tab.find("tab_seq=" + string(ll_tabseq), 1, ids_tab.rowcount())
if ll_find <= 0 then return -1

if upper(ids_tab.getitemstring(ll_find, 'pgm_id')) = upper(gnv_vari.w_home) Then return 0
ls_pgm_no	= ids_tab.getitemstring(ll_find, 'pgm_no')
ls_pgm_id	= ids_tab.getitemstring(ll_find, 'pgm_id')
ls_pgm_nm	= ids_tab.getitemstring(ll_find, 'pgm_nm')

lm_popup = Create fw_m_mdipgmtab
lm_popup.of_setparent(parent, ls_pgm_no, ls_pgm_id, ls_pgm_nm)
lm_popup.PopMenu(PointerX(iw_parent), PointerY(iw_parent))

Return 0

end event

event constructor;This.Post Event oue_postopen()
end event

event clicked;of_tabclicked(xpos, ypos, row, string(dwo.name))
end event

type hsb_1 from pf_u_hscrollbar within fw_u_sheettab4frame
boolean visible = false
integer x = 2994
integer width = 178
integer height = 112
boolean bringtotop = true
boolean stdheight = false
integer minposition = 1
integer maxposition = 100
integer position = 1
end type

event lineright;call super::lineright;Long		ll_rightwidth, ll_revisewidth
ll_rightwidth	= TabStartXpos + il_maxtabwidth
ll_revisewidth	= Parent.width - this.width
If ll_rightwidth - DW_HSCROLL_UNIT > ll_revisewidth Then
	Parent.of_scrolltab(-DW_HSCROLL_UNIT)
Else
	Parent.of_scrolltab((ll_rightwidth - ll_revisewidth) * -1)
End If
If il_selectedtabseq > 0 Then p_pgm4close1.x = of_setclosepicrevise(il_selectedtabseq)
end event

event lineleft;call super::lineleft;If TabStartXpos = 0 then Return
If il_selectedtabseq > 0 Then p_pgm4close1.x = of_setclosepicrevise(il_selectedtabseq)
If TabStartXpos + DW_HSCROLL_UNIT > 0 Then
	Parent.of_scrolltab(-TabStartXpos)
Else
	Parent.of_scrolltab(DW_HSCROLL_UNIT)
End If
If il_selectedtabseq > 0 Then p_pgm4close1.x = of_setclosepicrevise(il_selectedtabseq)
end event

type p_pgm4close1 from pf_u_imagebutton within fw_u_sheettab4frame
boolean visible = false
integer x = 2789
integer y = 44
integer width = 69
integer height = 60
boolean bringtotop = true
string picturename = "..\img\mainframe\u_pgmtab\tab_ico_close1.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
this.visible=false
//<임시> 종료버튼클릭시 포커스 줄 필요없음
//string	ls_pgm_no
//
//If il_selectedtabseq > 0 Then
//	If isvalid(iw_sheet[il_selectedtabseq]) Then
//		ls_pgm_no = iw_sheet[il_selectedtabseq].dynamic of_getpgmno()
//		of_sheetsetfocus(ls_pgm_no)
//	End If
//End If
//of_setxpos2move(this)
gnv_extfunc.biznode1te(146, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
Post of_tabclicked(0, 0, 0, gnv_extfunc.is_nodevalue)
end event

type p_pgm4closeall from pf_u_imagebutton within fw_u_sheettab4frame
boolean visible = false
integer x = 2875
integer y = 4
integer width = 119
integer height = 104
boolean bringtotop = true
string picturename = "..\img\mainframe\u_pgmtab\btn_tab_allclose.jpg"
end type

event clicked;call super::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

f_loadingun ()
This.Visible = False
of_popup_closeAll()
end event

