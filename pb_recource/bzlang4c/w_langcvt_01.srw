forward
global type w_langcvt_01 from w_window1st5cn
end type
type tv_fullmenu from pf_u_treeview within w_langcvt_01
end type
type cbx_expand from pf_u_checkbox within w_langcvt_01
end type
type st_vsplit from pf_u_splitbar_vertical within w_langcvt_01
end type
type dw_list from fw_u_dwo within w_langcvt_01
end type
end forward

global type w_langcvt_01 from w_window1st5cn
tv_fullmenu tv_fullmenu
cbx_expand cbx_expand
st_vsplit st_vsplit
dw_list dw_list
end type
global w_langcvt_01 w_langcvt_01

type variables
datastore			ids_fullmenu
treeviewitem		itvi_item, itvi_parent
datawindowchild	idwc_dddw
boolean			ib_redraw = false
string				is_pgm_no, is_pgm_id, is_dw_nm = ''
long				il_parent, il_handle
end variables

forward prototypes
public function integer of_getcontroltext (windowobject awo_object, ref string as_name, ref string as_type, ref string as_text[])
public function string of_getpuretext (string as_text)
public function integer of_getdscontroltext (datastore ads_name)
public function integer of_setfullretrieve ()
public function long of_getwindowcontrols (windowobject awo_in[], ref windowobject awo_out[])
public function integer of_setlangdata (string as_obj_gb, string as_ctlnm, string as_ctltype, string as_findtext, integer ai_chkcnt)
public function string of_getfinddw ()
end prototypes

public function integer of_getcontroltext (windowobject awo_object, ref string as_name, ref string as_type, ref string as_text[]);string				ls_text[], ls_type, ls_name, ls_temp
integer				li_tabpagecnt, li_i, li_cnt
object				lo_type
commandbutton	lcb_obj
picturebutton		lpb_obj
checkbox			lcbx_obj
radiobutton			lrb_obj
statictext			lst_obj
statichyperlink		lshl_obj
groupbox			lgb_obj
singlelineedit		lsle_obj
editmask			lem_obj
multilineedit		lmle_obj
tab					ltab_obj
/* fw userobject */
fw_u_dw2title		luo_dw2title
fw_u_sheet4navi		luo_sheet4navi
pf_u_tab			luo_tab

li_cnt = 0

//오브젝트 타입
lo_type = awo_object.typeof()
ls_name = awo_object.classname()

//Get Text
choose case lo_type
	case commandbutton!
		lcb_obj = awo_object
		ls_type = 'commandbutton'
		ls_text[1] = fw_f_nvls(trim(lcb_obj.text), '')
	case picturebutton!
		lpb_obj = awo_object
		ls_type = 'picturebutton'
		ls_text[1] = fw_f_nvls(trim(lpb_obj.text), '')
	case checkbox!
		lcbx_obj = awo_object
		ls_type = 'checkbox'
		ls_text[1] = fw_f_nvls(trim(lcbx_obj.text), '')
	case radiobutton!
		lrb_obj = awo_object
		ls_type = 'radiobutton'
		ls_text[1] = fw_f_nvls(trim(lrb_obj.text), '')
	case statictext!
		lst_obj = awo_object
		ls_type = 'statictext'
		ls_text[1] = fw_f_nvls(trim(lst_obj.text), '')
	case statichyperlink!
		lshl_obj = awo_object
		ls_type = 'statichyperlink'
		ls_text[1] = fw_f_nvls(trim(lshl_obj.text), '')
	case groupbox!
		lgb_obj = awo_object
		ls_type = 'groupbox'
		ls_text[1] = fw_f_nvls(trim(lgb_obj.text), '')
	case singlelineedit!
		lsle_obj = awo_object
		ls_type = 'singlelineedit'
		ls_text[1] = fw_f_nvls(trim(lsle_obj.text), '')
	case editmask!
		lem_obj = awo_object
		ls_type = 'editmask'
		ls_text[1] = fw_f_nvls(trim(lem_obj.text), '')
	case multilineedit!
		lmle_obj = awo_object
		ls_type = 'multilineedit'
		ls_text[1] = fw_f_nvls(trim(lmle_obj.text), '')
	case tab!
		ltab_obj = awo_object
		ls_type = 'tab'
		li_tabpagecnt = upperbound(ltab_obj.control)
		
		For li_i = 1 to li_tabpagecnt
			ls_temp = fw_f_nvls(trim(ltab_obj.control[li_i].text), '')			
			if ls_temp = '' then
				continue
			else
				li_cnt++
				ls_text[li_cnt] = ls_temp
			end if
		next
	case userobject!
		if awo_object.triggerevent('wue_components') = 1 then
			choose case awo_object.dynamic of_thisname()
				case 'fw_u_sheet4navi'
					ls_type = 'fw_u_sheet4navi'
					luo_sheet4navi = awo_object
					ls_text[1] = fw_f_nvls(luo_sheet4navi.st_navi.text, '')
				case 'fw_u_dw2title'
					ls_type = 'fw_u_sheet4navi'
					luo_dw2title = awo_object
					ls_text[1] = fw_f_nvls(luo_dw2title.st_title.text, '')
//				case 'pf_u_tab'
//					luo_obj =awo_object
//					ls_text = fw_f_nvls(luo_obj.st_title.text, '')
				case else
					return 0
			end choose
		else			
			return 0
		end if
	case else
		return 0
end choose

if ls_text[1] = '' then
	return 0
else
	//return values
	as_name = ls_name
	as_type = ls_type
	as_text[] = ls_text[]
	return 1
end if
end function

public function string of_getpuretext (string as_text);integer	li_i, li_len
string		ls_char, ls_text, ls_pattern
pf_n_regexp	lnv_exp

if isnull(as_text) or as_text = '' Then return ''

//정규표현식 nvo 생성
lnv_exp = create pf_n_regexp
lnv_exp.of_setignorecase(true)

li_len = Len(as_text)
ls_text = ''													//return 초기값
ls_pattern = "^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-zA-Z0-9]+$"	//한글, 영문, 숫자로만 구성된 패턴

For li_i = 1 to li_len
	ls_char = Mid(as_text, li_i, 1)
	
	if lnv_exp.of_test(ls_char, ls_pattern) = true Then
		ls_text = ls_text + ls_char
	else
		Continue
	end if
Next

return ls_text
end function

public function integer of_getdscontroltext (datastore ads_name);string	ls_ctllist, ls_ctl[]
string	ls_ctlnm, ls_ctltype, ls_findtext, ls_lng_kor, ls_lng_eng, ls_lng_chn, ls_lng_vit, ls_lng_loc, ls_reg_yn
long	ll_ctlcnt, ll_i, ll_find, ll_ret
integer	li_chk

ls_ctllist = ads_name.describe("datawindow.objects")

ll_ctlcnt = fw_f_obj2array(ls_ctllist, '~t', ls_ctl[])

if ll_ctlcnt > 0 then
	for ll_i = 1 to ll_ctlcnt
		ls_ctlnm = ls_ctl[ll_i]
		ls_ctltype = ads_name.describe(ls_ctlnm + ".type")
		
		if ls_ctltype = "text" or ls_ctltype = "button" or ls_ctltype = "groupbox" then
			ls_findtext = ads_name.describe(ls_ctlnm + ".text")
			ls_ctltype = '[ ' + is_dw_nm + ' ] ' + ls_ctltype
			ll_ret = of_setlangdata('01', ls_ctlnm, ls_ctltype, ls_findtext, li_chk)
			if ll_ret = 2 then continue
		end if
	next
	
	if li_chk > 0 then
		return 1
	else
		return 0
	end if
else
	return -1
end if
end function

public function integer of_setfullretrieve ();long	ll_rowcnt, ll_handle, i, ll_roothndl
long	ll_treelevel
treeviewitem ltvi_item

tv_fullmenu.setredraw(false)
tv_fullmenu.post setredraw(true)

ll_handle = tv_fullmenu.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_fullmenu.deleteitem(ll_handle)
	ll_handle = tv_fullmenu.finditem(roottreeitem!, ll_handle)
loop

ll_rowcnt = ids_fullmenu.retrieve(gnv_vari.is_lang_type, gnv_vari.is_sys_id, 'ROOT')

for i = 1 to ll_rowcnt
	ltvi_item.data	= ids_fullmenu.getitemstring(i, 'pgm_no')
	ltvi_item.label	= ids_fullmenu.getitemstring(i, 'pgm_nm')
	ll_treelevel		= ids_fullmenu.getitemnumber(i, 'tree_level')
	
	choose case ids_fullmenu.getitemstring(i, 'pgm_kind_code')
		case 'M'
			choose case ll_treelevel
				case 1
					ltvi_item.PictureIndex = 1
					ltvi_item.SelectedPictureIndex = 2
				case 2
					ltvi_item.PictureIndex = 3
					ltvi_item.SelectedPictureIndex = 4
				case 3
					ltvi_item.PictureIndex = 5
					ltvi_item.SelectedPictureIndex = 6
				case else
					ltvi_item.PictureIndex = 7
					ltvi_item.SelectedPictureIndex = 8
			end choose
		case 'P'
			ltvi_item.PictureIndex = 9
			ltvi_item.SelectedPictureIndex = 10
	end choose
	
	if ids_fullmenu.getitemnumber(i, 'child_cnt') > 0 then
		ltvi_item.children = true
	else
		ltvi_item.children = false
	end if
	
	ll_handle = tv_fullmenu.InsertItemLast(0, ltvi_item)
next

// expand top level items only
ll_handle = tv_fullmenu.finditem(roottreeitem!, 0)
ll_roothndl = ll_handle
do while ll_handle > 0
	if cbx_expand.checked = true then
		tv_fullmenu.expandall(ll_handle)
	else
		tv_fullmenu.expanditem(ll_handle)
	end if
	ll_handle = tv_fullmenu.finditem(NextTreeItem!, ll_handle)
loop

// scroll back to top
tv_fullmenu.SetFirstVisible(ll_roothndl)

// select first treeviewitem
tv_fullmenu.post selectitem(ll_roothndl)

return ll_rowcnt

end function

public function long of_getwindowcontrols (windowobject awo_in[], ref windowobject awo_out[]);long			ll_in, ll_incnt, ll_outcnt, ll_sub, ll_ll_subcnt
userobject		luo_userobj
tab				ltb_tab
windowobject	lwo_empty[], lwo_sub[]

awo_out = lwo_empty

ll_incnt = upperbound (awo_in)
for ll_in = 1 to ll_incnt
	ll_outcnt ++
	awo_out[ll_outcnt] = awo_in[ll_in]

	choose case awo_in[ll_in].typeof()
		case userobject!
			luo_userobj = awo_in[ll_in]
			ll_ll_subcnt = of_getwindowcontrols (luo_userobj.control, lwo_sub)
			for ll_sub = 1 to ll_ll_subcnt
				ll_outcnt ++
				awo_out[ll_outcnt] = lwo_sub[ll_sub]
			next
	
		case tab!
			ltb_tab = awo_in[ll_in]
			ll_ll_subcnt = of_getwindowcontrols (ltb_tab.control, lwo_sub)
			for ll_sub = 1 to ll_ll_subcnt
				ll_outcnt ++
				awo_out[ll_outcnt] = lwo_sub[ll_sub]
			next
	end choose
next

return ll_outcnt
end function

public function integer of_setlangdata (string as_obj_gb, string as_ctlnm, string as_ctltype, string as_findtext, integer ai_chkcnt);string	ls_lng_kor, ls_lng_eng, ls_lng_chn, ls_lng_vit, ls_lng_loc, ls_reg_yn
long	ll_find, ll_new

if lenA(as_findtext) > 500 then return 2

//불필요한 텍스트 제외
choose case as_findtext
	case '', '~~', 'none'	//불필요한 텍스트가 있으면 여기에 추가할 것
		 return 2
	case else
		ll_find = dw_list.find("text_lng_org='" + as_findtext + "'", 1, dw_list.rowcount())
		if ll_find > 0 Then  return 2
		
		//등록 여부 확인
		select	lng_kor, lng_eng, lng_chn, lng_vit, lng_loc
		into		:ls_lng_kor, :ls_lng_eng, :ls_lng_chn, :ls_lng_vit, :ls_lng_loc
		from	fw_lng01
		where	sys_id = :gnv_vari.is_sys_id
		and		lng_gb = '01'
		and		lng_org = :as_findtext
		;
		
		ls_lng_kor = SQLCA.getitemstring (1)
		ls_lng_eng = SQLCA.getitemstring (2)
		ls_lng_chn = SQLCA.getitemstring (3)
		ls_lng_vit = SQLCA.getitemstring (4)
		ls_lng_loc = SQLCA.getitemstring (5)
		
		if sqlca.sqlcode() = 0 and sqlca.sqlnrows() = 1 then
			ls_reg_yn = 'Y'
		else
			ls_lng_kor = ''
			ls_lng_eng = ''
			ls_lng_chn = ''
			ls_lng_vit = ''
			ls_lng_loc = ''
			ls_reg_yn = 'N'
		end if
		
		ll_new = dw_list.InsertRow(0)					
		if fw_f_nvls(ls_lng_kor, '') = '' Then ls_lng_kor = as_findtext
		dw_list.setitem(ll_new, 'control_type', as_ctltype)
		dw_list.setitem(ll_new, 'control_name', as_ctlnm)
		//if as_obj_gb = '01' then as_ctltype = '[dw] ' + as_ctltype
		dw_list.setitem(ll_new, 'text_lng_org', as_findtext)
		dw_list.setitem(ll_new, 'text_lng_kor', ls_lng_kor)
		dw_list.setitem(ll_new, 'text_lng_eng', ls_lng_eng)
		dw_list.setitem(ll_new, 'text_lng_chn', ls_lng_chn)
		dw_list.setitem(ll_new, 'text_lng_vit', ls_lng_vit)
		dw_list.setitem(ll_new, 'text_lng_loc', ls_lng_loc)
		dw_list.setitem(ll_new, 'reg_yn', ls_reg_yn)
		
		ai_chkcnt++
end choose

return 1
end function

public function string of_getfinddw ();string	ls_data
long	ll_i, ll_objcnt

object			lo_type
window			lw_window
datawindow	ldw_obj

ls_data = ''
if is_pgm_id = '' then return ''

try
	lw_window = create using is_pgm_id
catch  (RuntimeError rte)
	//messagebox('Notice', '[' + is_pgm_id + '] The program you selected is currently under development.~r~nPlease check back later')
	return ''
end try
if appeongetclienttype() = 'WEB' Then
	if Not IsValid(lw_window) Then
		//messagebox('Notice', '[' + is_pgm_id + '] The program you selected is currently under development.~r~nPlease check back later')
		return ''
	end if
end if

//Window 오브젝트 가져오기
lw_window = create using is_pgm_id
windowobject lwo_object[]
ll_objcnt = of_getwindowcontrols(lw_window.control[], lwo_object[])
if ll_objcnt > 0 then
	for ll_i = 1 to ll_objcnt
		lo_type = lwo_object[ll_i].typeof()
		if lo_type =  datawindow! then
			ldw_obj	= lwo_object[ll_i]
			
			if pos(ls_data, ldw_obj.classname() + '||' + ldw_obj.classname() + ',') = 0 then
				ls_data += ldw_obj.classname() + '||' + ldw_obj.classname() + ','
			end if
		end if
	next
end if
if fw_f_nvls(ls_data, '') <> '' then
	return ls_data
else
	return ''
end if
end function

on w_langcvt_01.create
int iCurrent
call super::create
this.tv_fullmenu=create tv_fullmenu
this.cbx_expand=create cbx_expand
this.st_vsplit=create st_vsplit
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_fullmenu
this.Control[iCurrent+2]=this.cbx_expand
this.Control[iCurrent+3]=this.st_vsplit
this.Control[iCurrent+4]=this.dw_list
end on

on w_langcvt_01.destroy
call super::destroy
destroy(this.tv_fullmenu)
destroy(this.cbx_expand)
destroy(this.st_vsplit)
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;ids_fullmenu = create ads_jTier
ids_fullmenu.dataobject = 'fw_d_pgm_mst_ds1'
ids_fullmenu.settransobject(sqlca)

dw_cond.insertrow(0)

post of_setfullretrieve()
end event

event wue_update;call super::wue_update;string	ls_lng_org, ls_lng_kor, ls_lng_eng, ls_lng_chn, ls_lng_vit, ls_lng_loc, ls_errtext
string		ls_sysdate
integer		li_chk, li_cnt
long		ll_rowcnt, ll_i
datetime	ldt_sysdate
dwItemStatus	ldwstatus

dw_list.AcceptText()

ll_rowcnt = dw_list.RowCount()

if ll_rowcnt < 1 then return -1

if dw_list.modifiedcount() + dw_list.deletedcount() > 0 then
	ls_sysdate = fw_f_getymdhh24miss4s()
	
	For ll_i = 1 to ll_rowcnt
		ls_lng_org	= fw_f_nvls(trim(dw_list.GetItemString(ll_i, 'text_lng_org')), '')
		ls_lng_kor	= fw_f_nvls(trim(dw_list.GetItemString(ll_i, 'text_lng_kor')), '')
		ls_lng_eng	= fw_f_nvls(trim(dw_list.GetItemString(ll_i, 'text_lng_eng')), '')
		ls_lng_chn	= fw_f_nvls(trim(dw_list.GetItemString(ll_i, 'text_lng_chn')), '')
		ls_lng_vit	= fw_f_nvls(trim(dw_list.GetItemString(ll_i, 'text_lng_vit')), '')
		ls_lng_loc	= fw_f_nvls(trim(dw_list.GetItemString(ll_i, 'text_lng_loc')), '')
		
		if ls_lng_org <> '' and (ls_lng_kor <> '' or ls_lng_eng <> '' or ls_lng_chn <> ''or ls_lng_vit <> '' or ls_lng_loc <> '') then
			ldwstatus = dw_list.GetItemStatus(ll_i, 0, Primary!)
			
			if ldwstatus = DataModified! then
				select	count(*) into :li_cnt
				from	fw_lng01
				where	sys_id = :gnv_vari.is_sys_id
				and		lng_gb = '01'
				and		lng_org = :ls_lng_org
				using sqlca;

				if li_cnt > 0 Then
					update	fw_lng01
						set	lng_kor	= :ls_lng_kor,
							lng_eng	= :ls_lng_eng,
							lng_chn	= :ls_lng_chn,
							lng_vit	= :ls_lng_vit,
							lng_loc	= :ls_lng_loc,
							upd_id = :gnv_vari.is_user_id,
							upd_dt = :ls_sysdate
					where	sys_id = :gnv_vari.is_sys_id
					and		lng_gb = '01'
					and		lng_org = :ls_lng_org
					using sqlca;
				else
					insert into fw_lng01 (sys_id, lng_gb, lng_org, lng_kor, lng_eng, lng_chn, lng_vit, lng_loc, reg_id, reg_dt)
					values (:gnv_vari.is_sys_id, '01', :ls_lng_org, :ls_lng_kor, :ls_lng_eng, :ls_lng_chn, :ls_lng_vit, :ls_lng_loc, :gnv_vari.is_user_id, :ls_sysdate)
					using sqlca;
				end if
				
				if SQLCA.SQLCODE = 0 and SQLCA.SQLNROWS = 1 then
					li_chk++
				else
					ls_errtext = SQLCA.SQLERRTEXT
					rollbackJ ()
					messagebox('ERROR', ls_errtext)
					return -1
				end if
			else
				Continue
			end if
		end if
	Next
	
	if li_chk > 0 then
		Commit Using SQLCA;
		dw_list.ResetUpdate()	//Update Flag 초기화
		Messagebox('Check', String(li_chk, '#,##0') + 'Successfully saved case!')
	else
		Messagebox('Notice', 'There is no content to save.')
	end if
else
	Messagebox('Notice', 'There is no content to save.')
end if

end event

event wue_retrieve;call super::wue_retrieve;if is_pgm_id = '' then return
string	ls_text[]
string	ls_ctlnm, ls_ctltype, ls_dataobject
string	ls_dddw_id, ls_dddw_cd

long	ll_i, ll_j, ll_objcnt, ll_cnt, ll_ret
Integer	li_chk

object			lo_type
window			lw_window
datastore		lds_obj
datawindow	ldw_obj

dw_cond.accepttext()
ls_dddw_cd = dw_cond.getitemstring(1, 'dddw_id')
dw_cond.getchild('dddw_id', idwc_dddw)
ls_dddw_id = idwc_dddw.getitemstring(idwc_dddw.getrow(), 'tbl_nm')

try
	lw_window = create using is_pgm_id
catch  (RuntimeError rte)
	messagebox('Notice', '[' + is_pgm_id + '] The program you selected is currently under development.~r~nPlease check back later')
	return
end try
if appeongetclienttype() = 'WEB' Then
	if Not IsValid(lw_window) Then
		messagebox('Notice', '[' + is_pgm_id + '] The program you selected is currently under development.~r~nPlease check back later')
		return
	end if
end if

//Window 오브젝트 가져오기
lw_window = create using is_pgm_id
windowobject lwo_object[]
ll_objcnt = of_getwindowcontrols(lw_window.control[], lwo_object[])
if ll_objcnt > 0 then
	dw_list.reset()
	if ls_dddw_cd <> '%' then
		for ll_i = 1 to ll_objcnt
			is_dw_nm = ''
			lo_type = lwo_object[ll_i].typeof()
			if lo_type =  datawindow! then
				ldw_obj	= lwo_object[ll_i]
				is_dw_nm = ldw_obj.classname()
				
				if not(ls_dddw_id = is_dw_nm) then continue
				ls_dataobject = string(ldw_obj.dataobject)
				lds_obj	= create datastore
				lds_obj.dataobject = ls_dataobject
				ll_ret = lds_obj.settransobject(sqlca)					
				if ll_ret <> 1 then return
				
				ll_ret = of_getdscontroltext(lds_obj)
				if ll_ret <> 1 then return
				li_chk++
				exit
			end if
		next
	else
		for ll_i = 1 to ll_objcnt
			is_dw_nm = ''
			lo_type = lwo_object[ll_i].typeof()
			
			choose case lo_type
				case datawindow!
					ldw_obj	= lwo_object[ll_i]
					is_dw_nm = ldw_obj.classname()
					
					ls_dataobject = string(ldw_obj.dataobject)
					lds_obj	= create datastore
					lds_obj.dataobject = ls_dataobject
					ll_ret = lds_obj.settransobject(sqlca)					
					if ll_ret <> 1 then continue
					
					ll_ret = of_getdscontroltext(lds_obj)
					if ll_ret <> 1 then continue
					li_chk++
				case else
					//Window control 텍스트 처리
					ll_ret = of_getcontroltext(lwo_object[ll_i], ls_ctlnm, ls_ctltype, ls_text[])
					
					if ll_ret = 1 Then
						ll_cnt = upperbound(ls_text[])
						
						for ll_j = 1 To ll_cnt
							ll_ret = of_setlangdata('02', ls_ctlnm, ls_ctltype, ls_text[ll_j], li_chk)
							if ll_ret = 2 then continue
						next
					else
						continue
					end if
			end choose
		next
	end if
	
	if li_chk > 0 then
		dw_list.resetupdate()
	else
		//messagebox('check', '텍스트가 존재하는 컨트롤이 없습니다.')
		return
	end if
else
	messagebox('check', '윈도우 컨트롤이 없습니다.')
	return
end if
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw2(dw_cond, 'dddw||dual', 'dddw_id', {''})
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within w_langcvt_01
end type

type ln_templeft from w_window1st5cn`ln_templeft within w_langcvt_01
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_langcvt_01
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_langcvt_01
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_langcvt_01
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_langcvt_01
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_langcvt_01
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_langcvt_01
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_langcvt_01
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_langcvt_01
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_langcvt_01
end type

type uo_navi from w_window1st5cn`uo_navi within w_langcvt_01
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_langcvt_01
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_langcvt_01
end type

type st_top_rect from w_window1st5cn`st_top_rect within w_langcvt_01
end type

type p_close from w_window1st5cn`p_close within w_langcvt_01
end type

type p_excel from w_window1st5cn`p_excel within w_langcvt_01
end type

type p_print from w_window1st5cn`p_print within w_langcvt_01
end type

type p_delete from w_window1st5cn`p_delete within w_langcvt_01
end type

type p_update from w_window1st5cn`p_update within w_langcvt_01
end type

type p_input from w_window1st5cn`p_input within w_langcvt_01
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_langcvt_01
end type

type p_clear from w_window1st5cn`p_clear within w_langcvt_01
end type

type dw_cond from w_window1st5cn`dw_cond within w_langcvt_01
string dataobject = "d_langcvt_01_c1"
end type

type tv_fullmenu from pf_u_treeview within w_langcvt_01
integer x = 50
integer y = 456
integer width = 1801
integer height = 2244
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 20132659
long backcolor = 33225466
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl0close.gif","..\img\mainframe\u_treemenu\lvl0open.gif","..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif","..\img\mainframe\u_treemenu\lvl2close.gif","..\img\mainframe\u_treemenu\lvl2open.gif","..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif","..\img\mainframe\u_treemenu\lvl4close.gif","..\img\mainframe\u_treemenu\lvl4open.gif"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event itemexpanding;string	ls_pgm_no
long	ll_rowcnt, ll_child, i, ll_treelevel
treeviewitem ltvi_item

this.getitem(handle, ltvi_item)
if ltvi_item.ExpandedOnce and not ib_redraw then return 0
if this.finditem(ChildTreeItem!, handle) > 0 then return 0

ls_pgm_no = ltvi_item.data
ll_rowcnt = ids_fullmenu.retrieve(gnv_vari.is_lang_type, gnv_vari.is_sys_id, ls_pgm_no)

for i = 1 to ll_rowcnt
	ltvi_item.data	= ids_fullmenu.getitemstring(i, 'pgm_no')
	ltvi_item.label	= ids_fullmenu.getitemstring(i, 'pgm_nm')
	ll_treelevel		= ids_fullmenu.getitemnumber(i, 'tree_level')
	
	choose case ids_fullmenu.getitemstring(i, 'pgm_kind_code')
		case 'M'
			choose case ll_treelevel
				case 1
					ltvi_item.PictureIndex = 1
					ltvi_item.SelectedPictureIndex = 2
				case 2
					ltvi_item.PictureIndex = 3
					ltvi_item.SelectedPictureIndex = 4
				case 3
					ltvi_item.PictureIndex = 5
					ltvi_item.SelectedPictureIndex = 6
				case else
					ltvi_item.PictureIndex = 7
					ltvi_item.SelectedPictureIndex = 8
			end choose
		case 'P'
			if ids_fullmenu.getitemstring(i, 'pgm_use_yn') = 'N' then
				ltvi_item.PictureIndex = 11
				ltvi_item.SelectedPictureIndex = 12
			elseif ids_fullmenu.getitemstring(i, 'menu_use_yn') = 'N' then
				ltvi_item.PictureIndex = 11
				ltvi_item.SelectedPictureIndex = 12
			else
				ltvi_item.PictureIndex = 9
				ltvi_item.SelectedPictureIndex = 10
			end if				
	end choose
	
	if ids_fullmenu.getitemnumber(i, 'child_cnt') > 0 then
		ltvi_item.Children = true
	else
		ltvi_item.Children = false
	end if
	
	ltvi_item.HasFocus = false
	ltvi_item.selected = false
	
	ll_child = this.InsertItemLast(handle, ltvi_item)
next

ib_redraw = false

return 0

end event

event key;//if keyflags = 2 then
//	choose case key
//		case KeyUpArrow!
//			of_treeviewitem_move(il_handle, 'upper')
//		case KeyDownArrow!
//			of_treeviewitem_move(il_handle, 'lower')
////		case KeyLeftArrow!
////			of_treeviewitem_move(il_handle, 'left')
////		case KeyRightArrow!
////			of_treeviewitem_move(il_handle, 'right')
//	end choose
//end if
//
//choose case key
//	case KeyDelete!
//		p_delete.post event clicked()
//	case KeyInsert!
//		p_add.post event clicked()
//end choose
//
//return 1
//
end event

event selectionchanged;il_handle = newhandle
this.getitem(il_handle, itvi_item)

choose case itvi_item.PictureIndex
	case 3, 4
		il_parent = il_handle
		itvi_parent = itvi_item
	case else
		il_parent = this.finditem(ParentTreeItem!, il_handle)
		this.getitem(il_parent, itvi_parent)
end choose

is_pgm_no = itvi_item.data
is_pgm_no = fw_f_nvls(is_pgm_no, '')

if is_pgm_no <> ''  then
	select	pgm_id into :is_pgm_id
	from	fw_pgm_mst
	where	sys_id = :gnv_vari.is_sys_id
	and		pgm_no = :is_pgm_no
	and		pgm_kind_code = 'P'
	;
	
	is_pgm_id = SQLCA.getitemstring (1)
	
	//if sqlca.sqlcode() = 0 and sqlca.sqlnrows() = 1 then
	if fw_f_nvls(is_pgm_id, '') <> '' then
		dw_list.dynamic of_settitle4name(itvi_item.label)
		string		ls_data
		ls_data = of_getfinddw()
		fw_f_setdddw2(dw_cond, 'dddw||dual', 'dddw_id', {ls_data})
		dw_cond.post setitem(1, 'dddw_id', '%')
	else
		is_pgm_id = ''
	end if
end if

return 0

end event

type cbx_expand from pf_u_checkbox within w_langcvt_01
integer x = 1495
integer y = 388
integer width = 357
integer height = 60
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 19737901
string text = "열린 메뉴"
boolean checked = true
boolean setsheetcolor = true
end type

type st_vsplit from pf_u_splitbar_vertical within w_langcvt_01
integer x = 1851
integer y = 456
integer height = 2244
boolean bringtotop = true
string leftdragobject = "tv_fullmenu;cbx_expand"
string rightdragobject = "dw_list"
end type

type dw_list from fw_u_dwo within w_langcvt_01
integer x = 1870
integer y = 368
integer width = 3561
integer height = 2332
integer taborder = 20
string title = "menu empty"
string dataobject = "d_langcvt_01_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
end type

