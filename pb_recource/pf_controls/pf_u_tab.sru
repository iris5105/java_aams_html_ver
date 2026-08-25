forward
global type pf_u_tab from u_ancestor
end type
type hsb_1 from pf_u_hscrollbar within pf_u_tab
end type
type dw_tab from datawindow within pf_u_tab
end type
end forward

global type pf_u_tab from u_ancestor
integer width = 864
integer height = 116
boolean setsheetcolor = true
event oue_visiblechanged ( )
event oue_enablechanged ( )
event oue_moved ( )
event oue_resized ( )
event oue_selectedtabchanged ( )
hsb_1 hsb_1
dw_tab dw_tab
end type
global pf_u_tab pf_u_tab

type prototypes

end prototypes

type variables
private:
	constant long LEFT_TEXT_MARGIN = 10	// pixel
	constant long RIGHT_TEXT_MARGIN = 10	// pixel
	constant long DW_HSCROLL_UNIT = 100 // pixel
	
	tab			it_referencedtab
	userobject	iuo_tabpage[]
	pf_n_propertywatcher inv_propmon
	
	String		TAB_IMG_SELECTED = "..\img\controls\u_tab\tab2_on.jpg"
	String		TAB_IMG_NOTSELECTED = "..\img\controls\u_tab\tab2_nor.jpg"
	String		TAB_IMG_DISABLED = "..\img\controls\u_tab\tab2_off.jpg"
	
	String		is_tabnotselectedimage
	String		is_tabselectedimage
	String		is_tabdisabledimage
	
	String		isdwasissyntax		= '' /* to-be constructor */
	
	long		il_tabimageheight
	long		il_tabtextheight
	long		il_maxtabwidth
	long		il_selectedtabseq
	long		il_maxtabseq
	long		il_tabmargin	= Long(PixelsToUnits(1, XPixelsToUnits!))
	long		TabStartXpos	= 0
	long		TabOrgPageSeq[], TabOrgPageSeqNull[] /* to-be TabOrgPageSeq */
	
public:
	boolean	i----------------------------------------------------line0	/* empty Object */
	String		referencedtab
	boolean	ApplyDesign = true
	boolean	i----------------------------------------------------line1	/* empty Object */
	
	boolean	ibtextcolor4referencedtab	= false
	long		tabtextcolorSelected	= RGB(45,45,45)
	long		tabtextcolorNormal		= RGB(45,45,45)
	long		tabtextcolorDisabled	= RGB(120,120,120)

end variables

forward prototypes
public function integer of_selecttab (long al_tabseq)
public function string of_thisname ()
public function tab of_getreferencedtab ()
public function integer of_designprocess ()
public function integer of_deselecttab (long al_tabseq)
public function integer of_addtab (userobject auo_tabpage, integer ai_tabseq)
public function integer of_setpropertywatcher (string as_switch)
public function integer of_disabletab (long al_tabseq)
public function integer of_enabletab (long al_tabseq)
public function long of_getfindtabpageseq (long al_tabpage)
public subroutine of_setenabledtabpage (long al_tabpage, boolean ab_boolean)
public subroutine of_dwtabclicked (integer ai_xpos, integer ai_ypos, long al_row, string as_dwoname)
public subroutine of_settabtext (integer al_tabpage, string as_tabtext)
public subroutine of_activatetab (long al_tabseq)
end prototypes

event oue_visiblechanged();this.visible = it_referencedtab.visible

end event

event oue_enablechanged();this.enabled = it_referencedtab.enabled

end event

event oue_moved();this.x = it_referencedtab.x
this.y = it_referencedtab.y

end event

event oue_resized();this.width = it_referencedtab.width
this.height = il_tabtextheight

end event

event oue_selectedtabchanged();if it_referencedtab.selectedtab <> il_selectedtabseq then
	this.of_selecttab(it_referencedtab.selectedtab)
end if
end event

public function integer of_selecttab (long al_tabseq);String	ls_syntax, ls_errmsg
String	ls_tabtext, ls_revisetext

If il_selectedtabseq = al_tabseq Then return 0
If al_tabseq > il_maxtabseq Then return 0

if al_tabseq <> it_referencedtab.selectedtab then
   if it_referencedtab.selecttab(al_tabseq) = -1 then return -1
end if

If il_selectedtabseq > 0 Then
	this.of_deselecttab(il_selectedtabseq)
End If

If ibtextcolor4referencedtab = true Then
	tabtextcolorSelected = it_referencedtab.control[al_tabseq].tabtextcolor
End If

ls_tabtext = it_referencedtab.control[al_tabseq].text
ls_revisetext = fw_f_text2revise(ls_tabtext)
ls_syntax = 'tabbgimg_' + string(al_tabseq, '000') + '.Filename="' + fw_f_replaceall(is_tabselectedimage, "_000.", ls_revisetext + "_" + string(al_tabseq, "000") + ".") + '"'
ls_syntax += '~r~ntabtext_' + string(al_tabseq, '000') + '.Color=' + string(tabtextcolorSelected)
ls_syntax += '~r~ntabtext_' + string(al_tabseq, '000') + '.Font.Weight=700'

ls_errmsg = dw_tab.modify(ls_syntax)
If len(ls_errmsg) > 0 Then
	::clipboard(ls_syntax)
	messagebox('of_selecttab() error', ls_errmsg)
	return -1
End If

il_selectedtabseq = al_tabseq
dw_tab.Setposition('l_underline', '', True)
dw_tab.Post Setposition('tabbgimg_' + string(al_tabseq, '000'), '', True)
dw_tab.Post Setposition('tabtext_' + string(al_tabseq, '000'), '', True)

return 1

end function

public function string of_thisname ();return 'pf_u_tab'

end function

public function tab of_getreferencedtab ();// 윈도우 오브젝트에서 참조되는 탭의 레퍼런스를 리턴합니다
// 리턴값: 참조 탭 레퍼런스

if isvalid(it_referencedtab) then return it_referencedtab

tab lt_referencedtab
integer li_ctrlcnt, i

li_ctrlcnt = upperbound(iw_parent.control)
for i = 1 to li_ctrlcnt
	if iw_parent.control[i].typeof() = tab! then
		if iw_parent.control[i].classname() = referencedtab then
			lt_referencedtab = iw_parent.control[i]
			exit
		end if
	end if
next

return lt_referencedtab

end function

public function integer of_designprocess ();// TABPAGE 갯수
String	ls_tabpage, ls_tabseq
integer	li_tabpagecnt, i

li_tabpagecnt = upperbound(it_referencedtab.control)
for i = 1 to li_tabpagecnt
	if it_referencedtab.control[i].visible = true then
		this.of_addtab(it_referencedtab.control[i], i)
		if it_referencedtab.control[i].enabled = false then
			this.of_disabletab(i)
		end if
	end if
next

// Tab Position 초기화
dw_tab.x = 0

return 0

end function

public function integer of_deselecttab (long al_tabseq);// 해당 탭을 DeSelect 처리한다
string	ls_syntax, ls_errmsg
string	ls_tabtext, ls_revisetext

if al_tabseq > il_maxtabseq then Return 0
If it_referencedtab.control[al_tabseq].enabled = False Then Return 0

ls_tabtext = it_referencedtab.control[al_tabseq].text
ls_revisetext = fw_f_text2revise(ls_tabtext)
ls_syntax = 'tabbgimg_' + string(al_tabseq, '000') + '.Filename="' + fw_f_replaceall(is_tabnotselectedimage, "_000.", ls_revisetext + "_" + string(al_tabseq, "000") + ".") + '"'
ls_syntax += '~r~ntabtext_' + string(al_tabseq, '000') + '.Color=' + string(tabtextcolorNormal)
ls_syntax += '~r~ntabtext_' + string(al_tabseq, '000') + '.Font.Weight=400'

ls_errmsg = dw_tab.modify(ls_syntax)
If len(ls_errmsg) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_deselecttab() error', ls_errmsg)
	Return -1
End if

Return 1

end function

public function integer of_addtab (userobject auo_tabpage, integer ai_tabseq);string		ls_syntax, ls_errmsg
string		ls_tabnotselectedimage, ls_tabselectedimage, ls_tabdisabledimage
string		ls_tabnotselectedimagedt, ls_tabselectedimagedt, ls_tabdisabledimagedt
string		ls_tabtext, ls_revisetext
long		ll_tabbackcolor, ll_tabtextcolor, ll_resizewidth, ll_resizeheight, ll_tabseq
pf_s_size	lstr_textsize

ll_tabseq = ai_tabseq
iuo_tabpage[ll_tabseq] = auo_tabpage
ll_tabbackcolor	= auo_tabpage.tabbackcolor
ll_tabtextcolor	= auo_tabpage.tabtextcolor
ls_tabtext		= auo_tabpage.text
ls_revisetext		= fw_f_text2revise(ls_tabtext)
ls_tabnotselectedimage = fw_f_replaceall(is_tabnotselectedimage, "_000.", ls_revisetext + "_" + String(ll_tabseq, "000") + ".")
ls_tabselectedimage = fw_f_replaceall(is_tabselectedimage, "_000.", ls_revisetext + "_" + String(ll_tabseq, "000") + ".")
ls_tabdisabledimage = fw_f_replaceall(is_tabdisabledimage, "_000.", ls_revisetext + "_" + String(ll_tabseq, "000") + ".")
If fw_f_nvls(ls_tabnotselectedimage, '')	= '' Then Return -1
If fw_f_nvls(ls_tabselectedimage, '')		= '' Then Return -1
If fw_f_nvls(ls_tabdisabledimage, '')		= '' Then Return -1

gnv_extfunc.biz_gettextsize_w(handle(this), ls_tabtext, "맑은 고딕", 10, 700, lstr_textsize)

ll_resizewidth	= LEFT_TEXT_MARGIN + lstr_textsize.width + RIGHT_TEXT_MARGIN
ll_resizeheight	= il_tabimageheight

If FileExists(ls_tabnotselectedimage) Then
	gnv_extfunc.of_getfilewritetime(ls_tabnotselectedimage, ls_tabnotselectedimagedt)
	If gnv_vari.ModifyDT_tab_img_notselected > ls_tabnotselectedimagedt Then gnv_extfunc.biz_setresizeimgw(TAB_IMG_NOTSELECTED, ls_tabnotselectedimage, 4, 4, ll_resizewidth, ll_resizeheight)
Else
	gnv_extfunc.biz_setresizeimgw(TAB_IMG_NOTSELECTED, ls_tabnotselectedimage, 4, 4, ll_resizewidth, ll_resizeheight)
End If
If FileExists(ls_tabselectedimage) Then
	gnv_extfunc.of_getfilewritetime(ls_tabselectedimage, ls_tabselectedimagedt)
	If gnv_vari.ModifyDT_tab_img_selected > ls_tabselectedimagedt Then gnv_extfunc.biz_setresizeimgw(TAB_IMG_SELECTED, ls_tabselectedimage, 4, 4, ll_resizewidth, ll_resizeheight)
Else
	gnv_extfunc.biz_setresizeimgw(TAB_IMG_SELECTED, ls_tabselectedimage, 4, 4, ll_resizewidth, ll_resizeheight)
End If
If fileexists(ls_tabdisabledimage) Then
	gnv_extfunc.of_getfilewritetime(ls_tabdisabledimage, ls_tabdisabledimagedt)
	If gnv_vari.ModifyDT_tab_img_disabled > ls_tabdisabledimagedt Then gnv_extfunc.biz_setresizeimgw(TAB_IMG_DISABLED, ls_tabdisabledimage, 4, 4, ll_resizewidth, ll_resizeheight)
Else
	gnv_extfunc.biz_setresizeimgw(TAB_IMG_DISABLED, ls_tabdisabledimage, 4, 4, ll_resizewidth, ll_resizeheight)
End If

long ll_textwidth, ll_textheight
long ll_imagewidth, ll_imageheight
long ll_textxpos, ll_textypos

ll_textwidth		= PixelsToUnits(lstr_textsize.width, XPixelsToUnits!)
ll_textheight	= PixelsToUnits(lstr_textsize.height, YPixelsToUnits!)

ll_imagewidth	= PixelsToUnits(ll_resizewidth, XPixelsToUnits!)
ll_imageheight	= PixelsToUnits(il_tabimageheight, YPixelsToUnits!)

ll_textxpos = il_MaxTabWidth + Round((ll_imagewidth - ll_textwidth) / 2, 0)
ll_textxpos = Long(PixelsToUnits(UnitsToPixels(ll_textxpos, XUnitsToPixels!), XPixelsToUnits!))
ll_textypos = Round((dw_tab.height - ll_textheight) / 2, 0)
ll_textypos = Long(PixelsToUnits(UnitsToPixels(ll_textypos, YUnitsToPixels!), YPixelsToUnits!))

ls_syntax = 'create bitmap(band=header pointer="HyperLink!" filename="' + ls_tabnotselectedimage + '" x="' + String(il_MaxTabWidth) + '" y="' + '0' + '" height="' + String(dw_tab.height) + '" width="' + String(ll_imagewidth) + '" border="0" name=tabbgimg_' + String(ll_tabseq, '000') + ' visible="1" )~r~n'
ls_syntax += 'create text(band=header alignment="2" pointer="HyperLink!" text="' +  ls_tabtext + '" border="0" color="' + String(tabtextcolorNormal) + '" x="' + String(ll_textxpos) + '" y="' + String(ll_textypos) + '" height="' + String(ll_textheight) + '" width="' + String(ll_textwidth) + '" html.valueishtml="0" name=tabtext_' + String(ll_tabseq, '000') + ' tag="" visible="1" font.face="' + "맑은 고딕" + '" font.height="-' + String(10) + '" font.weight="400" font.family="2" font.pitch="2" font.charset="0" background.mode="0" background.color="553648127" )'
//ll_textxpos
ls_errmsg = dw_tab.modify(ls_syntax)
If len(ls_errmsg) > 0 Then
	messagebox('modify error', ls_errmsg)
	Return -1
End If

il_maxtabwidth += ll_imagewidth + il_tabmargin
il_maxtabseq = ll_tabseq

// DW 스크롤용 HScrollBar 컨트롤 Visible 처리
If il_maxtabwidth > This.width Then
	dw_tab.x = (il_maxtabwidth - This.width + hsb_1.width) * -1
	hsb_1.visible = true
End If

Return ll_tabseq
end function

public function integer of_setpropertywatcher (string as_switch);choose case lower(as_switch)
	case 'true'
		if not isvalid(inv_propmon) then
			inv_propmon = create pf_n_propertywatcher
			inv_propmon.of_registerparent(this)
			inv_propmon.of_start(0.3)
		end if
	case 'false'
		if isvalid(inv_propmon) then
			inv_propmon.of_stop()
			destroy inv_propmon
		end if
	case 'start'
		if isvalid(inv_propmon) then
			inv_propmon.of_start(0.3)
		end if
	case 'stop'
		if isvalid(inv_propmon) then
			inv_propmon.of_stop()
		end if
end choose

return 1

end function

public function integer of_disabletab (long al_tabseq);string	ls_syntax, ls_errmsg
string	ls_tabtext, ls_revisetext
if al_tabseq > il_maxtabseq then return 0

ls_tabtext = it_referencedtab.control[al_tabseq].text
ls_revisetext = fw_f_text2revise(ls_tabtext)
ls_syntax = 'tabbgimg_' + string(al_tabseq, '000') + '.Filename="' + fw_f_replaceall(is_tabdisabledimage, "_000.", ls_revisetext + "_" + string(al_tabseq, "000") + ".") + '"'
ls_syntax += '~r~ntabtext_' + string(al_tabseq, '000') + '.Color=' + string(tabtextcolorDisabled)
ls_syntax += '~r~ntabtext_' + string(al_tabseq, '000') + '.Font.Weight=400'

ls_errmsg = dw_tab.modify(ls_syntax)
if len(ls_errmsg) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_disabletab() error', ls_errmsg)
	return -1
end if

return 1

end function

public function integer of_enabletab (long al_tabseq);return this.of_deselecttab(al_tabseq)

end function

public function long of_getfindtabpageseq (long al_tabpage);String		ls_tabpage
Long		ll_tabpagecnt, ll_i

//Messagebox('',  it_referencedtab.control[al_tabpage].classname())
ls_tabpage = 'tabpage_' + string(al_tabpage)

ll_tabpagecnt = upperbound(it_referencedtab.control)
for ll_i = 1 to ll_tabpagecnt
	If it_referencedtab.control[ll_i].classname() = ls_tabpage Then
		Return ll_i
	End If
next

Return -1
end function

public subroutine of_setenabledtabpage (long al_tabpage, boolean ab_boolean);Long		ll_findseq

ll_findseq = of_getfindtabpageseq(al_tabpage)
If ll_findseq < 0 Then
	Messagebox('Check', String(al_tabpage) + ' tabpage 찾기 실패')
	Return
End If

Choose Case ab_boolean
	Case True
		If it_referencedtab.control[ll_findseq].enabled = False Then it_referencedtab.control[ll_findseq].enabled = True
		If it_referencedtab.selecttab(ll_findseq) = 1 Then Post of_selecttab(ll_findseq)
	Case False
		If it_referencedtab.control[ll_findseq].enabled = True Then it_referencedtab.control[ll_findseq].enabled = False
		Post of_disabletab(ll_findseq)
End Choose
end subroutine

public subroutine of_dwtabclicked (integer ai_xpos, integer ai_ypos, long al_row, string as_dwoname);if pos(as_dwoname, 'tabnotselected_') + pos(as_dwoname, 'tabselected_') + pos(as_dwoname, 'tabtext_') = 0 then Return

long	ll_tabseq

ll_tabseq = long(right(as_dwoname, 3))
If ll_tabseq = 0 Then Return 
If ll_tabseq = il_selectedtabseq then Return
If it_referencedtab.control [ll_tabseq].enabled = false Then Return

If isvalid(it_referencedtab) Then
	IF	it_referencedtab.tag='wt_tab'	Then
		IF it_referencedtab.control [il_selectedtabseq].DYNAMIC EVENT ue_subpage_modified ()	Then
			CHOOSE CASE f_messageBox ('W005', it_referencedtab.control [il_selectedtabseq].TEXT + '(selectionchanging)')
				CASE 1   // Update_OK
					IF it_referencedtab.control [il_selectedtabseq].dynamic EVENT ue_subpage_update ()=-1	Then
						post of_activatetab (il_selectedtabseq)
						RETURN
					End IF
					gw_mdi.setmicrohelp (string (Now ()) + ' -> [' + it_referencedtab.control [il_selectedtabseq].TEXT + '] commit')
				CASE 2   // pass
					rollbackJ ()
				CASE 3   // Cancel
					post of_activatetab (il_selectedtabseq)
					RETURN
			END CHOOSE
		End IF
	End IF
	If it_referencedtab.selecttab(ll_tabseq) = 1 Then
		Post of_selecttab (ll_tabseq)
		post of_activatetab (ll_tabseq)
	End if
End If
end subroutine

public subroutine of_settabtext (integer al_tabpage, string as_tabtext);String	ls_error
dw_tab.create(isdwasissyntax, ls_error)
If fw_f_nvls(ls_error, '') <> '' Then
	messagebox('of_settabtext', ls_error)
	Return
End If
it_referencedtab.control[al_tabpage].text = as_tabtext
il_selectedtabseq	= 0
il_maxtabseq		= 0

Post Event constructor()
end subroutine

public subroutine of_activatetab (long al_tabseq);If al_tabseq > il_maxtabseq Then return
it_referencedtab.control[al_tabseq].TriggerEvent ('ue_activate')

end subroutine

on pf_u_tab.create
int iCurrent
call super::create
this.hsb_1=create hsb_1
this.dw_tab=create dw_tab
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hsb_1
this.Control[iCurrent+2]=this.dw_tab
end on

on pf_u_tab.destroy
call super::destroy
destroy(this.hsb_1)
destroy(this.dw_tab)
end on

event resize;call super::resize;dw_tab.height = newheight
hsb_1.x = newwidth - hsb_1.width
if il_maxtabwidth > newwidth then
	hsb_1.visible = true
else
	dw_tab.x = 0
	hsb_1.visible = false
end if

end event

event constructor;isdwasissyntax = dw_tab.Describe("DataWindow.Syntax")

String	ls_syntax, ls_errmsg
Long		ll_dwheight

// Visible 속성 제거
This.Visible = False

// Get Parent Window
iw_parent = fw_f_obj4parentwindow(this)

If ApplyDesign = true Then
	// 참조탭 구하기
	If referencedtab = '' Then
		messagebox('Notice', '참조할 탭 명칭을 입력하세요')
		return
	End If
	
	it_referencedtab = of_Getreferencedtab()
	If not isvalid(it_referencedtab) Then
		messagebox('Notice', '참조할 탭 명칭을 찾을 수 없습니다')
		return
	End If
	
	// TAB 이미지 파일명
	If gnv_vari.getclienttype = "WEB" Then
		TAB_IMG_SELECTED			= pf_f_getimagepathappeon(TAB_IMG_SELECTED)
		TAB_IMG_NOTSELECTED	= pf_f_getimagepathappeon(TAB_IMG_NOTSELECTED)
		TAB_IMG_DISABLED			= pf_f_getimagepathappeon(TAB_IMG_DISABLED)
	End If
	// 탭이미지 없으면 DO NOTHING
	/* to-be */
	If fw_f_nvls(TAB_IMG_SELECTED, '') = '' Then Return
	If fw_f_nvls(TAB_IMG_NOTSELECTED, '') = '' Then Return
	If fw_f_nvls(TAB_IMG_DISABLED, '') = '' Then Return
	
	/* to-be TAB_IMG 변경일자를 appsession variable 등록 */
	If fw_f_nvls(gnv_vari.ModifyDT_tab_img_notselected, '') = '' Then gnv_extfunc.of_getfilewritetime(TAB_IMG_NOTSELECTED, gnv_vari.ModifyDT_tab_img_notselected)
	If fw_f_nvls(gnv_vari.ModifyDT_tab_img_selected, '') = '' Then gnv_extfunc.of_getfilewritetime(TAB_IMG_SELECTED, gnv_vari.ModifyDT_tab_img_selected)
	If fw_f_nvls(gnv_vari.ModifyDT_tab_img_disabled, '') = '' Then gnv_extfunc.of_getfilewritetime(TAB_IMG_DISABLED, gnv_vari.ModifyDT_tab_img_disabled)

//	// 데이터윈도우 백그라운드 컬러 설정
//	choose case parent.typeof()
//		case window!
//			window lw_parent
//			lw_parent = parent
//			dw_tab.modify("DataWindow.Header.Color=" + string(lw_parent.backcolor))
//		case userobject!
//			userobject luo_parent
//			luo_parent = parent
//			dw_tab.modify("DataWindow.Header.Color=" + string(luo_parent.backcolor))
//			gnv_extfunc.setparent(handle(this), handle(parent))
//	End choose
	
	// 탭 시작위치
	il_maxtabwidth = TabStartXpos
	
	// 탭 이미지 사이즈를 구해와 높이를 맞춘다
	pf_s_size lstr_imagesize
	gnv_extfunc.biz_getimgsize(TAB_IMG_NOTSELECTED, lstr_imagesize)
	il_tabimageheight	= lstr_imagesize.height * gnv_vari.mswindowratedec
	il_tabtextheight		= it_referencedtab.height - it_referencedtab.control[1].height
	If gnv_vari.getclienttype = 'PB' Then il_tabtextheight -= PixelsToUnits(5, YPixelsToUnits!)
	
	this.x = it_referencedtab.x
	this.y = it_referencedtab.y - PixelsToUnits(3, YPixelsToUnits!)
	If gnv_vari.getclienttype = 'PB' Then this.y += PixelsToUnits(3, YPixelsToUnits!)
	
	this.width = it_referencedtab.width
	this.height = il_tabtextheight
	
	choose case il_tabtextheight - PixelsToUnits(il_tabimageheight, YPixelsToUnits!)
		case is > 0
			dw_tab.y = il_tabtextheight - PixelsToUnits(il_tabimageheight, YPixelsToUnits!)
			dw_tab.height = PixelsToUnits(il_tabimageheight, YPixelsToUnits!)
		case 0
			dw_tab.y = 0
			dw_tab.height = PixelsToUnits(il_tabimageheight, YPixelsToUnits!)
		case is < 0
			dw_tab.y = 0
			dw_tab.height = il_tabtextheight
	End choose
	
	ll_dwheight = dw_tab.height// + PixelsToUnits(1, YPixelsToUnits!)
	dw_tab.modify("DataWindow.Header.Height=" + string(ll_dwheight))
	ll_dwheight = ll_dwheight - PixelsToUnits(1, YPixelsToUnits!)
	dw_tab.modify("l_underline.y1=" + String(ll_dwheight))
	dw_tab.modify("l_underline.y2=" + String(ll_dwheight))
	dw_tab.Modify("DataWindow.Color='" + String(gnv_vari.sheetbackcolor) + "'")

	String	ls_framepath, ls_parentnm, ls_tabnm
	ls_framepath	= gnv_vari.is_tempdirectory
	ls_parentnm		= iw_parent.classname()
	ls_tabnm		= it_referencedtab.classname()
	
	is_tabnotselectedimage	= ls_framepath
	is_tabnotselectedimage += gnv_vari.mswindowrate + ls_parentnm + "_" + ls_tabnm + "_"
	is_tabnotselectedimage += "notselect_000.bmp"
	
	is_tabselectedimage = ls_framepath
	is_tabselectedimage += gnv_vari.mswindowrate + ls_parentnm + "_" + ls_tabnm + "_"
	is_tabselectedimage += "tabselect_000.bmp"
	
	is_tabdisabledimage = ls_framepath
	is_tabdisabledimage += gnv_vari.mswindowrate + ls_parentnm + "_" + ls_tabnm + "_"
	is_tabdisabledimage += "tabdisabled_000.bmp"
	
	// 탭 디자인
	this.of_designprocess()
	// 탭페이지 선택
	this.of_selecttab(it_referencedtab.selectedtab)
	
	// Position
	this.setPosition(Behind!, it_referencedtab)
	it_referencedtab.setPosition(Behind!, this)
	
	// set visible, enabled
	this.visible = it_referencedtab.visible
	this.enabled = it_referencedtab.enabled
	
	// properties monitor
	this.of_setpropertywatcher('true')
	inv_propmon.of_registerparent(it_referencedtab, this)
	inv_propmon.of_register('moved', 'oue_moved')
	inv_propmon.of_register('resized', 'oue_resized')
	inv_propmon.of_register('visible', 'oue_visiblechanged')
	inv_propmon.of_register('enabled', 'oue_enablechanged')
	//inv_propmon.of_register('selectedtab', 'oue_selectedtabchanged')
End If
// PostOpen 이벤트 호출
This.Post Event oue_postopen()
end event

event oue_postopen;call super::oue_postopen;This.of_setbgcolor() /* to-be */
end event

type hsb_1 from pf_u_hscrollbar within pf_u_tab
boolean visible = false
integer x = 699
integer width = 165
integer height = 100
boolean bringtotop = true
boolean stdheight = false
integer minposition = 1
integer maxposition = 100
integer position = 1
boolean fixedtoright = true
end type

event lineleft;call super::lineleft;if dw_tab.x + 100 > 0 then
	dw_tab.x = 0
else
	dw_tab.x += 100
end if

end event

event lineright;call super::lineright;long ll_max

ll_max = (il_maxtabwidth - parent.width + this.width) * -1
if dw_tab.x - 100 > ll_max then
	dw_tab.x -= 100
else
	dw_tab.x = ll_max
end if

end event

type dw_tab from datawindow within pf_u_tab
event ue_post_open ( )
integer width = 16379
integer height = 116
integer taborder = 10
string title = "none"
string dataobject = "pf_d_tab_disp"
boolean border = false
boolean livescroll = true
end type

event clicked;of_dwtabclicked(xpos, ypos, row, dwo.name)
end event

