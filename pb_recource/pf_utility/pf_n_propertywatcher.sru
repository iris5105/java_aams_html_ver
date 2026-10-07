forward
global type pf_n_propertywatcher from timing
end type
end forward

global type pf_n_propertywatcher from timing
end type
global pf_n_propertywatcher pf_n_propertywatcher

type variables
constant double DEFAULT_WATCH_INTERVAL = 0
constant double DEFAULT_MENU_VISIBLE_TIME = 3000

private:
	dragobject ido_observed
	dragobject ido_callback
	
	boolean ib_mouseover
	string is_callbackevent[]
	string is_propertytype[]
	any ia_initialvalue[]
	long il_startms, il_endms
	double id_visibletime = 0

public:
	pf_s_point istr_point

end variables

forward prototypes
public function integer of_register (string as_propertytype, string as_callbackevent)
public function integer of_unregister (string as_propertytype)
public function integer of_start ()
public function integer of_stop ()
public subroutine of_registerparent (readonly dragobject ado_parent)
public function integer of_start (double adbl_watchinterval)
public subroutine of_setvisibletime (double ad_visibletime)
public function double of_getvisibletime ()
public subroutine of_registerparent (readonly dragobject ado_parent, readonly dragobject ado_callback)
end prototypes

public function integer of_register (string as_propertytype, string as_callbackevent);if not isvalid(ido_observed) then return -1

// 속성 타입 중복 확인
integer i, li_maxarr, li_emptyarr

li_maxarr = upperbound(is_propertytype)
for i = 1 to li_maxarr
	choose case as_propertytype
		case ''
			li_emptyarr = i
			exit
		case is_propertytype[i]
			return -1
	end choose
next

if li_emptyarr = 0 then
	li_emptyarr = li_maxarr + 1
end if

// 초기값 보관
choose case lower(as_propertytype)
	case 'visible'
		ia_initialvalue[li_emptyarr] = ido_observed.visible
	case 'enabled'
		choose case ido_observed.typeof()
			case animation!
				animation lanim_enabled
				lanim_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lanim_enabled.enabled
			case checkbox!
				checkbox lcbx_enabled
				lcbx_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lcbx_enabled.enabled
			case commandbutton!, picturebutton!
				commandbutton lcb_enabled
				lcb_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lcb_enabled.enabled
			case datawindow!
				datawindow ldw_enabled
				ldw_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = ldw_enabled.enabled
			case datepicker!
				datepicker ldp_enabled
				ldp_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = ldp_enabled.enabled
			case dropdownlistbox!, dropdownpicturelistbox!
				dropdownlistbox lddlb_enabled
				lddlb_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lddlb_enabled.enabled
			case graph!
				graph lgr_enabled
				lgr_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lgr_enabled.enabled
			case groupbox!
				groupbox lgb_enabled
				lgb_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lgb_enabled.enabled
			case inkedit!
				inkedit lie_enabled
				lie_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lie_enabled.enabled
			case inkpicture!
				inkpicture lip_enabled
				lip_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lip_enabled.enabled
			case listbox!, picturelistbox!
				listbox llb_enabled
				llb_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = llb_enabled.enabled
			case listview!
				listview llv_enabled
				llv_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = llv_enabled.enabled
			case monthcalendar!
				monthcalendar lmc_enabled
				lmc_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lmc_enabled.enabled
			case multilineedit!, editmask!
				multilineedit lmle_enabled
				lmle_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lmle_enabled.enabled
			case omcontrol!, omcustomcontrol!, omembeddedcontrol!
				omcontrol lomc_enabled
				lomc_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lomc_enabled.enabled
			case picture!, picturehyperlink!
				picture lp_enabled
				lp_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lp_enabled.enabled
			case radiobutton!
				radiobutton lrb_enabled
				lrb_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lrb_enabled.enabled
			case richtextedit!
				richtextedit lrte_enabled
				lrte_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lrte_enabled.enabled
			case singlelineedit!
				singlelineedit lsle_enabled
				lsle_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lsle_enabled.enabled
			case statictext!, statichyperlink!
				statictext lst_enabled
				lst_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lst_enabled.enabled
			case tab!
				tab lt_enabled
				lt_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = lt_enabled.enabled
			case treeview!
				treeview ltv_enabled
				ltv_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = ltv_enabled.enabled
			case userobject!
				userobject luo_enabled
				luo_enabled = ido_observed
				ia_initialvalue[li_emptyarr] = luo_enabled.enabled
		end choose
	case 'picturename'
		choose case ido_observed.typeof()
			case picture!
				picture lp_pic
				lp_pic = ido_observed
				ia_initialvalue[li_emptyarr] = lp_pic.picturename
			case picturebutton!
				picturebutton lpb_pic
				lpb_pic = ido_observed
				ia_initialvalue[li_emptyarr] = lpb_pic.picturename
			case else
				return -1
		end choose
	case 'dataobject'
		choose case ido_observed.typeof()
			case datawindow!
				datawindow ldw_dwo
				ldw_dwo = ido_observed
				ia_initialvalue[li_emptyarr] = ldw_dwo.dataobject
			case else
				return -1
		end choose
	case 'moved'
		pf_s_point lstr_point
		lstr_point.xpos = ido_observed.x
		lstr_point.ypos = ido_observed.y
		ia_initialvalue[li_emptyarr] = lstr_point
	case 'resized'
		pf_s_size lstr_size
		lstr_size.width = ido_observed.width
		lstr_size.height = ido_observed.height
		ia_initialvalue[li_emptyarr] = lstr_size
	case 'mouseover'
	case 'mouseleave'
	case 'nomouseover'
	case 'selectedtab'
		choose case ido_observed.typeof()
			case tab!
				tab lt_tab
				lt_tab = ido_observed
				ia_initialvalue[li_emptyarr] = lt_tab.selectedtab
		end choose
	case else
		// unsupported property type
		return -1
end choose

is_propertytype[li_emptyarr] = as_propertytype
is_callbackevent[li_emptyarr] = as_callbackevent

return 1

end function

public function integer of_unregister (string as_propertytype);integer i

for i = 1 to upperbound(is_propertytype)
	if is_propertytype[i] = as_propertytype then
		is_propertytype[i] = ''
		is_callbackevent[i] = ''
		return 1
	end if
next

return 0

end function

public function integer of_start ();// debugging 시에는 propertywatcher를 수행하지 않습니다
if gnv_appmgr.is_runningmode = 'debug' then return 0

il_startms = cpu()
if this.running = false then
	this.start(DEFAULT_WATCH_INTERVAL)
end if

return 0

end function

public function integer of_stop ();if this.running = true then
	this.stop()
end if

return 0

end function

public subroutine of_registerparent (readonly dragobject ado_parent);ido_observed = ado_parent
ido_callback = ado_parent

end subroutine

public function integer of_start (double adbl_watchinterval);// debugging 시에는 propertywatcher를 수행하지 않습니다
if gnv_appmgr.is_runningmode = 'debug' then return 0

il_startms = cpu()
if this.running = false then
	this.start(adbl_watchinterval)
end if

return 0

end function

public subroutine of_setvisibletime (double ad_visibletime);id_visibletime = ad_visibletime

end subroutine

public function double of_getvisibletime ();if id_visibletime > 0 then 
	return id_visibletime
else
	return DEFAULT_MENU_VISIBLE_TIME
end if

end function

public subroutine of_registerparent (readonly dragobject ado_parent, readonly dragobject ado_callback);ido_observed = ado_parent
ido_callback = ado_callback

end subroutine

on pf_n_propertywatcher.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_propertywatcher.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;if not isvalid(ido_observed) then return

integer i

for i = 1 to upperbound(is_propertytype)
	choose case is_propertytype[i]
		case 'visible'
			if ia_initialvalue[i] <> ido_observed.visible then
				ido_callback.postevent(is_callbackevent[i])
				ia_initialvalue[i] = ido_observed.visible
			end if
		case 'enabled'
			choose case ido_observed.typeof()
				case animation!
					animation lanim_enabled
					lanim_enabled = ido_observed
					if ia_initialvalue[i] <> lanim_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lanim_enabled.enabled
					end if
				case checkbox!
					checkbox lcbx_enabled
					lcbx_enabled = ido_observed
					if ia_initialvalue[i] <> lcbx_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lcbx_enabled.enabled
					end if
				case commandbutton!, picturebutton!
					commandbutton lcb_enabled
					lcb_enabled = ido_observed
					if ia_initialvalue[i] <> lcb_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lcb_enabled.enabled
					end if
				case datawindow!
					datawindow ldw_enabled
					ldw_enabled = ido_observed
					if ia_initialvalue[i] <> ldw_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = ldw_enabled.enabled
					end if
				case datepicker!
					datepicker ldp_enabled
					ldp_enabled = ido_observed
					if ia_initialvalue[i] <> ldp_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = ldp_enabled.enabled
					end if
				case dropdownlistbox!, dropdownpicturelistbox!
					dropdownlistbox lddlb_enabled
					lddlb_enabled = ido_observed
					if ia_initialvalue[i] <> lddlb_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lddlb_enabled.enabled
					end if
				case graph!
					graph lgr_enabled
					lgr_enabled = ido_observed
					if ia_initialvalue[i] <> lgr_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lgr_enabled.enabled
					end if
				case groupbox!
					groupbox lgb_enabled
					lgb_enabled = ido_observed
					if ia_initialvalue[i] <> lgb_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lgb_enabled.enabled
					end if
				case inkedit!
					inkedit lie_enabled
					lie_enabled = ido_observed
					if ia_initialvalue[i] <> lie_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lie_enabled.enabled
					end if
				case inkpicture!
					inkpicture lip_enabled
					lip_enabled = ido_observed
					if ia_initialvalue[i] <> lip_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lip_enabled.enabled
					end if
				case listbox!, picturelistbox!
					listbox llb_enabled
					llb_enabled = ido_observed
					if ia_initialvalue[i] <> llb_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = llb_enabled.enabled
					end if
				case listview!
					listview llv_enabled
					llv_enabled = ido_observed
					if ia_initialvalue[i] <> llv_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = llv_enabled.enabled
					end if
				case monthcalendar!
					monthcalendar lmc_enabled
					lmc_enabled = ido_observed
					if ia_initialvalue[i] <> lmc_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lmc_enabled.enabled
					end if
				case multilineedit!, editmask!
					multilineedit lmle_enabled
					lmle_enabled = ido_observed
					if ia_initialvalue[i] <> lmle_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lmle_enabled.enabled
					end if
				case omcontrol!, omcustomcontrol!, omembeddedcontrol!
					omcontrol lomc_enabled
					lomc_enabled = ido_observed
					if ia_initialvalue[i] <> lomc_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lomc_enabled.enabled
					end if
				case picture!, picturehyperlink!
					picture lp_enabled
					lp_enabled = ido_observed
					if ia_initialvalue[i] <> lp_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lp_enabled.enabled
					end if
				case radiobutton!
					radiobutton lrb_enabled
					lrb_enabled = ido_observed
					if ia_initialvalue[i] <> lrb_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lrb_enabled.enabled
					end if
				case richtextedit!
					richtextedit lrte_enabled
					lrte_enabled = ido_observed
					if ia_initialvalue[i] <> lrte_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lrte_enabled.enabled
					end if
				case singlelineedit!
					singlelineedit lsle_enabled
					lsle_enabled = ido_observed
					if ia_initialvalue[i] <> lsle_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lsle_enabled.enabled
					end if
				case statictext!, statichyperlink!
					statictext lst_enabled
					lst_enabled = ido_observed
					if ia_initialvalue[i] <> lst_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lst_enabled.enabled
					end if
				case tab!
					tab lt_enabled
					lt_enabled = ido_observed
					if ia_initialvalue[i] <> lt_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lt_enabled.enabled
					end if
				case treeview!
					treeview ltv_enabled
					ltv_enabled = ido_observed
					if ia_initialvalue[i] <> ltv_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = ltv_enabled.enabled
					end if
				case userobject!
					userobject luo_enabled
					luo_enabled = ido_observed
					if ia_initialvalue[i] <> luo_enabled.enabled then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = luo_enabled.enabled
					end if
				end choose
		case 'picturename'
			choose case ido_observed.typeof()
				case picture!
					picture lp_pic
					lp_pic = ido_observed
					if ia_initialvalue[i] <> lp_pic.picturename then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lp_pic.picturename
					end if
				case picturebutton!
					picturebutton lpb_pic
					lpb_pic = ido_observed
					if ia_initialvalue[i] <> lpb_pic.picturename then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lpb_pic.picturename
					end if
			end choose
		case 'dataobject'
			choose case ido_observed.typeof()
				case datawindow!
					datawindow ldw_dwo
					ldw_dwo = ido_observed
					if ia_initialvalue[i] <> ldw_dwo.dataobject then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = ldw_dwo.dataobject
					end if
			end choose
		case 'mouseover'
			if ib_mouseover = false then
				if gnv_extfunc.GetCursorPos(istr_point) then
					if gnv_extfunc.ScreenToClient(handle(ido_observed), istr_point) then
						if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(ido_observed.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(ido_observed.height, yunitstopixels!) then
							ib_mouseover = true
							ido_callback.postevent(is_callbackevent[i])
						end if
					end if
				end if
			end if
		case 'mouseleave'
			//if ib_mouseover = true then
				if gnv_extfunc.GetCursorPos(istr_point) then
					if gnv_extfunc.ScreenToClient(handle(ido_observed), istr_point) then
						if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(ido_observed.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(ido_observed.height, yunitstopixels!) then
						else
							ib_mouseover = false
							ido_callback.postevent(is_callbackevent[i])
						end if
					end if
				end if
			//end if
		case 'nomouseover'
			if gnv_extfunc.GetCursorPos(istr_point) then
				if gnv_extfunc.ScreenToClient(handle(ido_observed), istr_point) then
					if istr_point.xpos >= 0 and istr_point.ypos >= 0 and istr_point.xpos <= unitstopixels(ido_observed.width, xunitstopixels!) and istr_point.ypos <= unitstopixels(ido_observed.height, yunitstopixels!) then
						il_startms = cpu()
					else
						il_endms = cpu()
						if il_endms - il_startms > this.of_getvisibletime() then
							ido_callback.postevent(is_callbackevent[i])
							il_startms = cpu()
						end if
					end if
				end if
			end if
		case 'moved'
			pf_s_point lstr_point
			lstr_point = ia_initialvalue[i]
			if lstr_point.xpos <> ido_observed.x or lstr_point.ypos <> ido_observed.y then
				ido_callback.postevent(is_callbackevent[i])
				lstr_point.xpos = ido_observed.x
				lstr_point.ypos = ido_observed.y
				ia_initialvalue[i] = lstr_point
			end if
		case 'resized'
			pf_s_size lstr_size
			lstr_size = ia_initialvalue[i]
			if lstr_size.width <> ido_observed.width or lstr_size.height <> ido_observed.height then
				ido_callback.postevent(is_callbackevent[i])
				lstr_size.width = ido_observed.width
				lstr_size.height = ido_observed.height
				ia_initialvalue[i] = lstr_size
			end if
		case 'selectedtab'
			choose case ido_observed.typeof()
				case tab!
					tab lt_tab
					lt_tab = ido_observed
					if integer(ia_initialvalue[i]) <> lt_tab.selectedtab then
						ido_callback.postevent(is_callbackevent[i])
						ia_initialvalue[i] = lt_tab.selectedtab
					end if
			end choose
	end choose
next

end event

event constructor;ido_observed = this.getparent()
ido_callback = ido_observed

end event

event destructor;if this.running = true then
	this.stop()
end if

end event

