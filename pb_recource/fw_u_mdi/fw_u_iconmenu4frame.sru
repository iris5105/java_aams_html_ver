forward
global type fw_u_iconmenu4frame from fw_u_dwo
end type
end forward

global type fw_u_iconmenu4frame from fw_u_dwo
integer width = 2112
integer height = 244
string dataobject = "pf_d_iconmenu4frame"
boolean border = false
event ue_menuclicked ( string as_pgm_no,  string as_pgm_id,  string as_pgm_nm )
end type
global fw_u_iconmenu4frame fw_u_iconmenu4frame

type prototypes
function boolean ReleaseCapture() library "user32.dll"
function long SetCapture(long hWnd) library "user32.dll"
function boolean GetCursorPos(ref pf_s_point mousepos) LIBRARY "User32.dll"

function Boolean TrackMouseEvent(Ref pf_s_TRACKMOUSEEVENT lpTrackMouseEvent) Library 'user32.dll' alias for "TrackMouseEvent;Ansi" 

end prototypes

type variables
constant string MOUSEOVER_SURFIX = "_hover"
constant string CLICKED_SURFIX =  "_clicked"
constant string DISABLED_SURFIX = "_disabled"

constant long MOUSEOVER_COLOR = rgb(11,20,115)
constant long CLICKED_COLOR = 0
constant long DISABLED_COLOR = 0
constant long NORMAL_COLOR = rgb(119,119,119)

private:
	long il_prev_seq
	long MENU_GAP = pixelstounits(80, xpixelstounits!)
	long il_max_width

end variables

forward prototypes
public function string of_thisname ()
public function long of_drawtopmenu ()
public subroutine of_highlightmenu (integer ai_menu_seq, boolean ab_highlight)
public function long of_getmaxdwowidth ()
public function integer of_getscrollunit ()
end prototypes

public function string of_thisname ();return 'fw_u_iconmenu4frame'

end function

public function long of_drawtopmenu ();string	ls_syntax, ls_error
string ls_pgm_no, ls_pgm_id, ls_pgm_nm, ls_pgm_icon
pf_n_syntaxbuffer lnv_buffer
long ll_xpos, ll_rowcnt, ll_textwidth, ll_intergap, ll_menugap
integer i
pf_s_size lstr_textsize

ll_rowcnt = gnv_rolemenu.of_getmenudata('parent', '00000')

lnv_buffer = create pf_n_syntaxbuffer
ll_xpos = pixelstounits(4, xpixelstounits!)
ll_intergap = pixelstounits(8, xpixelstounits!)
ll_menugap = pixelstounits(42, xpixelstounits!)

for i = 1 to ll_rowcnt
	ls_pgm_no = gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_no')
	ls_pgm_id = gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_id')
	ls_pgm_nm = gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_nm')
	ls_pgm_icon = gnv_rolemenu.ids_menudata.getitemstring(i, 'pgm_icon')
	
	// 텍스트 사이즈 구하기
	gnv_extfunc.biz_gettextsize_w(handle(this), ls_pgm_nm, "맑은 고딕", 10, 700, lstr_textsize)
	ll_textwidth = pixelstounits(lstr_textsize.width, xpixelstounits!) + ll_intergap
	
	//아이콘명이 없을수도있다. By KYJ 2013.08.28
	if isnull(ls_pgm_icon) or len(ls_pgm_icon) = 0 then continue
	
	// ASA Database 사용 시 '\' 값을 제대로 못 가져옴
	// 따라서 Database 에 경로를 '/'로 구분해서 입력하고 가져와서 '\'로 Replace 한다
	ls_pgm_icon = fw_f_replaceall(ls_pgm_icon, '/', '\')
	
	lnv_buffer.of_append('create bitmap(band=header filename="' + ls_pgm_icon + '" x="' + string(ll_xpos) + '" y="36" height="68" width="82" border="0"  name=p_menu_' + string(i, '00') +  ' tag="' + ls_pgm_no + '" pointer="HyperLink!" visible="1" )')
	ll_xpos += 82
	lnv_buffer.of_append('create text(band=header alignment="2" text="' + ls_pgm_nm + '" border="0" color="7829367" x="' + string(ll_xpos) + '" y="36" height="76" width="' + string(ll_textwidth) + '"  html.valueishtml="0"  name=t_menu_' + string(i, '00') + ' tag="' + ls_pgm_no + '" pointer="HyperLink!" visible="1"  font.face="맑은 고딕" font.height="-10" font.weight="700"  font.family="1" font.pitch="2" font.charset="1" background.mode="2" background.color="553648127" )')
	ll_xpos += ll_textwidth + ll_menugap
	lnv_buffer.of_append('create bitmap(band=header filename="..\img\mainframe\u_mdi_iconmenu\topmenu_dist.jpg"' + ' x="' + string(ll_xpos) + '" y="8" height="128" width="23" border="0"  name=p_menudist_' + string(i, '00') +  ' tag="" visible="1" )')
	
	ll_xpos += ll_menugap
next

if lnv_buffer.of_size() > 0 then
	ls_error = this.modify(lnv_buffer.of_tostring())
	if len(ls_error) > 0 then
		::clipboard(lnv_buffer.of_tostring())
		messagebox('of_draw_topmenu() Error', ls_error)
		return -1
	end if
end if

// get maximum dwo width
if ll_rowcnt > 0 then
	il_max_width = long(this.describe('t_menu_' + string(gnv_rolemenu.ids_menudata.rowcount(), '00') + ".x")) + long(this.describe('t_menu_' + string(gnv_rolemenu.ids_menudata.rowcount(), '00') + ".width"))
else
	il_max_width = 0
end if

return ll_rowcnt

end function

public subroutine of_highlightmenu (integer ai_menu_seq, boolean ab_highlight);//
string ls_bitmap_nm, ls_text_nm
string ls_pgm_icon

ls_bitmap_nm = 'p_menu_' + string(ai_menu_seq, '00')
ls_text_nm = 't_menu_' + string(ai_menu_seq, '00')
ls_pgm_icon = this.describe(ls_bitmap_nm + '.filename')

long ll_lastpos
string ls_filepath, ls_filename
string ls_fileonly, ls_fileext
string ls_filetype, ls_orgfileonly
string ls_highlight_file

ll_lastpos = lastpos(ls_pgm_icon, '\')
if ll_lastpos = 0 then
	ls_filepath = ''
	ls_filename = ls_pgm_icon
else
	ls_filepath = left(ls_pgm_icon, ll_lastpos)
	ls_filename = mid(ls_pgm_icon, ll_lastpos + 1)
end if

ll_lastpos = lastpos(ls_filename, ".")
if ll_lastpos = 0 then
	ls_fileonly = ls_filename
	ls_fileext = ''
else
	ls_fileonly = left(ls_filename, ll_lastpos - 1)
	ls_fileext = mid(ls_filename, ll_lastpos)
end if

if right(ls_fileonly, len(DISABLED_SURFIX)) = DISABLED_SURFIX then
	ls_filetype = "disabled"
	ls_orgfileonly = left(ls_fileonly, len(ls_fileonly) - len(DISABLED_SURFIX))
elseif right(ls_fileonly, len(CLICKED_SURFIX)) = CLICKED_SURFIX then
	ls_filetype = "clicked"
	ls_orgfileonly = left(ls_fileonly, len(ls_fileonly) - len(CLICKED_SURFIX))
elseif right(ls_fileonly, len(MOUSEOVER_SURFIX)) = MOUSEOVER_SURFIX then
	ls_filetype = "mouseover"
	ls_orgfileonly = left(ls_fileonly, len(ls_fileonly) - len(MOUSEOVER_SURFIX))
else
	ls_filetype = "normal"
	ls_orgfileonly = ls_fileonly
end if

choose case ab_highlight
	case true
		choose case ls_filetype
			case "disabled", "mouseover"
			case else
				ls_highlight_file = ls_orgfileonly + MOUSEOVER_SURFIX + ls_fileext
		end choose
	case false
		choose case ls_filetype
			case "disabled", "normal"
			case else
				ls_highlight_file = ls_orgfileonly + ls_fileext
		end choose
end choose

string ls_syntax

if len(ls_highlight_file) > 0 then
	ls_syntax = ls_bitmap_nm + ".filename='" + ls_filepath + ls_highlight_file + "'~r~n"
end if

if ab_highlight = true then
	ls_syntax += ls_text_nm + ".color=" + string(MOUSEOVER_COLOR)
else
	ls_syntax += ls_text_nm + ".color=" + string(NORMAL_COLOR)
end if

string ls_error
ls_error = this.modify(ls_syntax)
if len(ls_error) > 0 then
	::clipboard(ls_syntax)
	messagebox('of_highlight_menu failure!!', ls_error)
end if

this.setredraw(true)

end subroutine

public function long of_getmaxdwowidth ();return il_max_width

end function

public function integer of_getscrollunit ();//return 192 + MENU_GAP
return 192

end function

on fw_u_iconmenu4frame.create
call super::create
end on

on fw_u_iconmenu4frame.destroy
call super::destroy
end on

event clicked;call super::clicked;string	ls_pgm_no, ls_pgm_nm

if pos(dwo.name, 'p_menu_') > 0 or pos(dwo.name, 't_menu_') > 0 then
	ls_pgm_no = string(dwo.tag)
	ls_pgm_nm = this.describe('t_' + mid(string(dwo.name), 3) + '.text')
		
	this.post event ue_menuclicked(ls_pgm_no, '', ls_pgm_nm)
end if

return 0

end event

event oue_mouseover;call super::oue_mouseover;integer li_menu_seq

if pos(ao_dwo.name, 'p_menu_') > 0 or pos(ao_dwo.name, 't_menu_') > 0 then
	li_menu_seq = integer(right(ao_dwo.name, 2))
	this.of_highlightmenu(li_menu_seq, true)
	il_prev_seq = li_menu_seq
else
	if il_prev_seq > 0 then
		this.of_highlightmenu(il_prev_seq, false)
		il_prev_seq = 0
	end if
end if

end event

event oue_mouseleave;call super::oue_mouseleave;if il_prev_seq > 0 then
	this.of_highlightmenu(il_prev_seq, false)
	il_prev_seq = 0
end if

end event

event mousemove;If Isvalid(gw_mdi) Then gw_mdi.of_setmmove4window(this.classname())
end event

