forward
global type fw_n_lang from nonvisualobject
end type
end forward

global type fw_n_lang from nonvisualobject
event oue_setactive4lang ( )
end type
global fw_n_lang fw_n_lang

type variables
ads_jtier	ids_langcvt
string		is_langtype[5] = {'lng_org', 'lng_kor','lng_eng', 'lng_chn', 'lng_vit'}
end variables
forward prototypes
public function integer of_setlangchange (datawindow adw_dw, string as_astype, datastore ads_cvt)
public function string of_exe4lang (datastore ads_cvt, string as_text, string as_astype, string as_totype)
public function integer of_setlangchange (windowobject awo_object, string as_astype, datastore ads_cvt)
public function string of_exe4lang_1sub (datastore ads_cvt, long al_row, string as_totype)
end prototypes

event oue_setactive4lang();gnv_extfunc.biznode1te(150, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
ids_langcvt = create ads_jtier
ids_langcvt.dataobject = gnv_extfunc.is_nodevalue
end event

public function integer of_setlangchange (datawindow adw_dw, string as_astype, datastore ads_cvt);string	ls_obj[]
string	ls_objlist, ls_coltype, ls_text, ls_text4tobe
string	ls_syntax, ls_err
long	ll_objcnt, ll_i

//Object List 가져오기
ls_objlist = adw_dw.describe(gnv_extfunc.istr_node4value.cstr09)
ll_objcnt = fw_f_obj2array(ls_objlist, '~t', ls_obj[])

if ll_objcnt < 1 then
	return 0
else
	for ll_i = 1 to ll_objcnt
		ls_coltype = adw_dw.describe(ls_obj[ll_i] + ".type")		
		choose case ls_coltype
			case 'text', 'button', 'groupbox'
				ls_text = adw_dw.describe(ls_obj[ll_i] + ".text")
						
				ls_text4tobe = of_exe4lang(ads_cvt, ls_text, as_astype, gnv_vari.is_lang_type)
				if fw_f_nvls(ls_text4tobe, '') = '' then continue
				if fw_f_nvls(ls_syntax, '') = '' then ls_syntax = ''
				ls_syntax += ls_obj[ll_i] + '.text="' + ls_text4tobe + '"~r~n'
		end choose
	next
	
	if ls_syntax <> "" then
		ls_err = adw_dw.modify(ls_syntax)
		if len(ls_err) > 0 then
			::clipboard(ls_syntax)
		end if
	end if
end if

return 1
end function

public function string of_exe4lang (datastore ads_cvt, string as_text, string as_astype, string as_totype);string	ls_org4text, ls_tobe4text
Long	ll_find, ll_i, ll_tmp

If fw_f_nvls(as_text, '') = '' then return ''
If Pos(as_astype, '~~') > 0 Then as_astype = ''

If fw_f_nvls(as_astype, '') = '' then return ''
as_astype = lower(as_astype)
ll_find = ads_cvt.find(as_astype + "='" + as_text + "'", 1, ads_cvt.rowcount())
If ll_find > 0 Then
	ls_org4text = ads_cvt.getitemstring(ll_find, lower(gnv_extfunc.istr_node4value.cstr07))
	as_totype = lower(as_totype)
	ls_tobe4text = ads_cvt.getitemstring(ll_find, as_totype)
	If fw_f_nvls(ls_tobe4text, '') = '' Then ls_tobe4text = as_text
	return fw_f_nvls(ls_tobe4text, '')
Else
	as_totype = lower(as_totype)
	for ll_i = 1 to 5
		ll_find = ads_cvt.find(is_langtype[ll_i] + "='" + as_text + "'", 1, ads_cvt.rowcount())
		If ll_find > 0 Then
			ls_tobe4text = of_exe4lang_1sub(ads_cvt, ll_find, as_totype)
			If ls_tobe4text = gnv_extfunc.istr_node4value.cstr08 Then ls_tobe4text = as_text
			return ls_tobe4text
		End If
	next
	return as_text	
End If
end function

public function integer of_setlangchange (windowobject awo_object, string as_astype, datastore ads_cvt);/********************************
 윈도우 컨트롤 텍스트 변경
********************************/
string					ls_text, ls_text4tobe
integer					li_tabpagecnt, li_i
object					lo_type
commandbutton		lcb_obj
pf_u_commandbutton	lcb_pf_obj
picturebutton			lpb_obj
checkbox				lcbx_obj
radiobutton				lrb_obj
statictext				lst_obj
statichyperlink			lshl_obj
groupbox				lgb_obj
singlelineedit			lsle_obj
editmask				lem_obj
multilineedit			lmle_obj
tab						ltab_obj
/* fw userobject */
fw_u_dw2title			luo_dwbytitle
pf_u_tab				luo_tab
//오브젝트 타입
lo_type = awo_object.typeof()

//Get Text
Choose Case lo_type
	Case commandbutton!
		If awo_object.triggerevent('oue_components') = 1 then
			lcb_pf_obj = awo_object
			ls_text = fw_f_nvls(lcb_pf_obj.text, '')
		Else			
			lcb_obj = awo_object
			ls_text = fw_f_nvls(lcb_obj.text, '')
		End If
	Case picturebutton!
		lpb_obj = awo_object
		ls_text = fw_f_nvls(lpb_obj.text, '')
	Case checkbox!
		lcbx_obj = awo_object
		ls_text = fw_f_nvls(lcbx_obj.text, '')
	Case radiobutton!
		lrb_obj = awo_object
		ls_text = fw_f_nvls(lrb_obj.text, '')
	Case statictext!
		lst_obj = awo_object
		ls_text = fw_f_nvls(lst_obj.text, '')
	Case statichyperlink!
		lshl_obj = awo_object
		ls_text = fw_f_nvls(lshl_obj.text, '')
	Case groupbox!
		lgb_obj = awo_object
		ls_text = fw_f_nvls(lgb_obj.text, '')
	Case singlelineedit!
		lsle_obj = awo_object
		ls_text = fw_f_nvls(lsle_obj.text, '')
	Case editmask!
		lem_obj = awo_object
		ls_text = fw_f_nvls(lem_obj.text, '')
	Case multilineedit!
		lmle_obj = awo_object
		ls_text = fw_f_nvls(lmle_obj.text, '')
	Case userobject!
		If awo_object.triggerevent('oue_components') = 1 then
//		Choose Case awo_object.dynamic of_thisname()
//			Case 'fw_u_tab'
////				luo_obj =awo_object
////				ls_text = fw_f_nvls(luo_obj.st_title.text, '')
//		end Choose
		Else
			
		End If	
	Case tab!
		ltab_obj = awo_object
		li_tabpagecnt = upperbound(ltab_obj.control)
		
		For li_i = 1 to li_tabpagecnt
			ls_text = ltab_obj.control[li_i].text
			ls_text = trim(ls_text)
			//Translation
			If ls_text = '' then
				Continue
			Else
				ls_text4tobe = of_exe4lang(ads_cvt, ls_text, as_astype, gnv_vari.is_lang_type)
			End If
			
			ltab_obj.control[li_i].text = ls_text4tobe
		Next
	Case Else
		Return 0
End Choose

//Tab control은 위에서 Loop 돌면서 처리함
If lo_type <> tab! Then
	ls_text = trim(ls_text)
	
	//Translation
	If ls_text = '' then
		Return 0
	Else
		ls_text4tobe = of_exe4lang(ads_cvt, ls_text, as_astype, gnv_vari.is_lang_type)
	End If
	
	//Set Text
	Choose Case lo_type
		Case commandbutton!
			If awo_object.triggerevent('oue_components') = 1 then
				lcb_pf_obj.of_settext(ls_text4tobe)
			Else			
				lcb_obj.text = ls_text4tobe
			End If
		Case picturebutton!
			lpb_obj.text		= ls_text4tobe
		Case checkbox!
			lcbx_obj.text	= ls_text4tobe
		Case radiobutton!
			lrb_obj.text		= ls_text4tobe
		Case statictext!
			lst_obj.text		= ls_text4tobe
		Case statichyperlink!
			lshl_obj.text		= ls_text4tobe
		Case groupbox!
			lgb_obj.text		= ls_text4tobe
		Case singlelineedit!
			lsle_obj.text		= ls_text4tobe
		Case editmask!
			lem_obj.text	= ls_text4tobe
		Case multilineedit!
			lmle_obj.text	= ls_text4tobe
	End Choose
End If

Return 1
end function

public function string of_exe4lang_1sub (datastore ads_cvt, long al_row, string as_totype);string	ls_tobe4text
ls_tobe4text = ads_cvt.GetItemstring(al_row, as_totype)
Return fw_f_nvls(ls_tobe4text, 'null')
end function

on fw_n_lang.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_lang.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;gnv_extfunc.biznode1te(149, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
TriggerEvent(gnv_extfunc.is_nodevalue)
end event

