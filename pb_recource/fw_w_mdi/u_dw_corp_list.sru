forward
global type u_dw_corp_list from datawindow
end type
end forward

global type u_dw_corp_list from datawindow
integer width = 686
integer height = 400
string title = "none"
boolean livescroll = true
event mousemove pbm_dwnmousemove
event pfe_mouseover ( long row,  dwobject dwo )
event pfe_mouseleave ( )
event timer pbm_timer
event lbuttondown pbm_lbuttondown
event lbuttonup pbm_lbuttonup
end type
global u_dw_corp_list u_dw_corp_list

type prototypes
function boolean GetCursorPos(Ref pf_s_point mousepos) library "User32.dll"
function boolean ScreenToClient(ulong hWnd, Ref pf_s_point lpPoint) library "user32.dll"

end prototypes

type variables
constant string MOUSEOVER_SURFIX = "_hover"
constant string CLICKED_SURFIX =  "_clicked"
constant string DISABLED_SURFIX = "_disabled"

constant long MOUSEOVER_COLOR = rgb(11,20,115)
constant long CLICKED_COLOR = 0
constant long DISABLED_COLOR = 0
constant long NORMAL_COLOR = rgb(119,119,119)

// mouseover checking
pf_s_point istr_point
pf_n_timing inv_timer
boolean ib_mouseover
string is_mouseover
long	il_mouseover = -1

end variables

forward prototypes
public function integer of_highlight_menu (string as_colname, long al_row, boolean ab_switch)
public function integer of_clicked_menu (string as_colname, long al_row, boolean ab_switch)
public function string of_getimgfile (string as_colname, long al_row)
public function integer of_retrieve (string as_gubun, ref ads_jtier as_jtier)
end prototypes

event mousemove;if il_mouseover <> row or is_mouseover <> string(dwo.name) then
	if inv_timer.running = true then
		this.event pfe_mouseleave()
	end if
	ib_mouseover = true
	inv_timer.of_start()
	this.event pfe_mouseover(row, dwo)
end if
end event

event timer;if GetCursorPos(istr_point) then
	if ScreenToClient(handle(this), istr_point) then
		if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(this.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(this.height, yunitstopixels!) then
		else
			ib_mouseover = false
			inv_timer.stop()
			this.event pfe_mouseleave()
			il_mouseover = -1
			is_mouseover = ''
		end if
	end if
end if
end event

public function integer of_highlight_menu (string as_colname, long al_row, boolean ab_switch);string ls_imagefile, ls_colName

long	ll_row

ls_colName = as_colName
ll_row = al_row

if ab_switch = false then
	ls_colName = this.is_mouseover
	ll_row = this.il_mouseover
end if

if (ls_colName="corp_gr_img_1st" or ls_colName="corp_gr_img_2nd") = false then
	return 0
end if

ls_imagefile = this.getItemString( ll_row, ls_colName )

long ll_lastpos
string ls_filepath, ls_filename
string ls_fileonly, ls_fileext
string ls_filetype, ls_orgfileonly
string ls_highlight_file

// get filename
ll_lastpos = lastpos(ls_imagefile, '\')
if ll_lastpos = 0 then
	ls_filepath = ''
	ls_filename = ls_imagefile
else
	ls_filepath = left(ls_imagefile, ll_lastpos)
	ls_filename = mid(ls_imagefile, ll_lastpos + 1)
end if

// get file extension
ll_lastpos = lastpos(ls_filename, ".")
if ll_lastpos = 0 then
	ls_fileonly = ls_filename
	ls_fileext = ''
else
	ls_fileonly = left(ls_filename, ll_lastpos - 1)
	ls_fileext = mid(ls_filename, ll_lastpos)
end if

// get normal filename
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

choose case ab_switch
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
				ll_row = il_mouseover
		end choose
end choose

string ls_syntax

this.setredraw(false)

if len(ls_highlight_file) > 0 then
	ls_syntax = ls_filepath + ls_highlight_file
	this.setitem( ll_row, ls_colName, ls_syntax )
end if

this.setredraw(true)
this.il_mouseover = ll_row
this.is_mouseover = ls_colName

return 1
end function

public function integer of_clicked_menu (string as_colname, long al_row, boolean ab_switch);string ls_imagefile

if (as_colName="corp_gr_img_1st" or as_colName="corp_gr_img_2nd") = false then
	return 0
end if

ls_imagefile = this.getItemString( al_row, as_colName )

long ll_lastpos
string ls_filepath, ls_filename
string ls_fileonly, ls_fileext
string ls_filetype, ls_orgfileonly
string ls_highlight_file

// get filename
ll_lastpos = lastpos(ls_imagefile, '\')
if ll_lastpos = 0 then
	ls_filepath = ''
	ls_filename = ls_imagefile
else
	ls_filepath = left(ls_imagefile, ll_lastpos)
	ls_filename = mid(ls_imagefile, ll_lastpos + 1)
end if

// get file extension
ll_lastpos = lastpos(ls_filename, ".")
if ll_lastpos = 0 then
	ls_fileonly = ls_filename
	ls_fileext = ''
else
	ls_fileonly = left(ls_filename, ll_lastpos - 1)
	ls_fileext = mid(ls_filename, ll_lastpos)
end if

// get normal filename
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

choose case ab_switch
	case true
		choose case ls_filetype
			case "clicked"
			case else
				ls_highlight_file = ls_orgfileonly + CLICKED_SURFIX + ls_fileext
		end choose
	case false
		choose case ls_filetype
			case "normal"
			case else
				ls_highlight_file = ls_orgfileonly + ls_fileext
		end choose
end choose

string ls_syntax

if len(ls_highlight_file) > 0 then
	ls_syntax = ls_filepath + ls_highlight_file
	this.setitem( al_row, as_colName, ls_syntax )
end if

return 1
end function

public function string of_getimgfile (string as_colname, long al_row);string ls_imagefile

long	ll_row

if al_row < 1 then return ""

if (as_colname="corp_gr_img_1st" or as_colname="corp_gr_img_2nd") = false then return ""

ls_imagefile = this.getItemString( al_row, as_colname )

long ll_lastpos
string ls_filepath, ls_filename
string ls_fileonly, ls_fileext
string ls_filetype, ls_orgfileonly
string ls_highlight_file

// get filename
ll_lastpos = lastpos(ls_imagefile, '\')
if ll_lastpos = 0 then
	ls_filepath = ''
	ls_filename = ls_imagefile
else
	ls_filepath = left(ls_imagefile, ll_lastpos)
	ls_filename = mid(ls_imagefile, ll_lastpos + 1)
end if

// get file extension
ll_lastpos = lastpos(ls_filename, ".")
if ll_lastpos = 0 then
	ls_fileonly = ls_filename
	ls_fileext = ''
else
	ls_fileonly = left(ls_filename, ll_lastpos - 1)
	ls_fileext = mid(ls_filename, ll_lastpos)
end if

// get normal filename
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

return (ls_filepath + ls_orgfileonly + ls_fileext)
end function

public function integer of_retrieve (string as_gubun, ref ads_jtier as_jtier);string	ls_corp_gr, ls_corp_gr_nm, ls_img_file
string	ls_sql

LONG	ll, ll_rc, ll_row

this.reset()

ls_sql = " select corp_gr, company_name from szx0aa order by corp_gr "

ll_rc = SQLCA.sql2ds (this.classname(), ls_sql, as_jtier, 'xml')
FOR  ll = 1  TO  ll_rc
   ls_corp_gr    = as_jtier.getitemstring (ll, 1)
   ls_corp_gr_nm = as_jtier.getitemstring (ll, 2)
	ls_img_file   =  "..\img\mainframe\company_logo\logo_" + ls_corp_gr + ".jpg"

	if(mod(ll,2) = 1) then
		ll_row = this.insertrow(0)
		IF	FileExists (ls_img_file) THEN
			this.setitem( ll_row, 'corp_gr_img_1st', ls_img_file )
			this.setitem( ll_row, 'corp_gr_1st', ls_corp_gr )
			this.setitem( ll_row, 'corp_gr_nm_1st', ls_corp_gr_nm )
		ELSE
			this.setitem( ll_row, 'corp_gr_nm_1st', ls_corp_gr_nm )
			//<임시> 이미지가 없더라도 로그인이 가능하도록
			this.setitem( ll_row, 'corp_gr_1st', ls_corp_gr )
		END IF
	else
		IF	FileExists (ls_img_file) THEN
			this.setitem( ll_row, 'corp_gr_img_2nd', ls_img_file )
			this.setitem( ll_row, 'corp_gr_2nd', ls_corp_gr )
			this.setitem( ll_row, 'corp_gr_nm_2nd', ls_corp_gr_nm )
		ELSE
			this.setitem( ll_row, 'corp_gr_nm_2nd', ls_corp_gr_nm )
			//<임시> 이미지가 없더라도 로그인이 가능하도록
			this.setitem( ll_row, 'corp_gr_2nd', ls_corp_gr )
		END IF		
	end if 
NEXT

return ll_rc
end function

on u_dw_corp_list.create
end on

on u_dw_corp_list.destroy
end on

event constructor;// properties monitor
inv_timer = create pf_n_timing
inv_timer.of_initialize(this)
end event

event destructor;if isvalid(inv_timer) then
	destroy inv_timer
end if
end event

