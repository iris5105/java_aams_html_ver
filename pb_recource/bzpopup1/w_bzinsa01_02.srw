forward
global type w_bzinsa01_02 from w_window1st5cn
end type
type tv_empl from pf_u_treeview within w_bzinsa01_02
end type
type cbx_expand from pf_u_checkbox within w_bzinsa01_02
end type
type dw_empl from fw_u_dwo within w_bzinsa01_02
end type
type cb_2 from pf_u_commandbutton within w_bzinsa01_02
end type
type cb_1 from pf_u_commandbutton within w_bzinsa01_02
end type
type cb_pic_sample from pf_u_commandbutton within w_bzinsa01_02
end type
type uo_title1 from fw_u_dw2title within w_bzinsa01_02
end type
end forward

global type w_bzinsa01_02 from w_window1st5cn
string title = "직원관리"
tv_empl tv_empl
cbx_expand cbx_expand
dw_empl dw_empl
cb_2 cb_2
cb_1 cb_1
cb_pic_sample cb_pic_sample
uo_title1 uo_title1
end type
global w_bzinsa01_02 w_bzinsa01_02

type variables
long				il_parent, il_handle

ads_jTier			ids_empl
treeviewitem		itvi_Source
treeviewitem		itvi_item, itvi_parent

end variables

forward prototypes
public function integer of_expand_treeviewitem (long al_handle)
public function integer of_collapse_treeviewitem (long al_handle)
public subroutine wf_photo_view (string as_emp_id)
public subroutine wf_photo_sample (string as_id)
public function integer of_expand_retrieve ()
end prototypes

public function integer of_expand_treeviewitem (long al_handle);// Expand TreeViewItem
long ll_rc

ll_rc = tv_empl.ExpandAll(al_handle)
tv_empl.SetFirstVisible(al_handle)

return ll_rc

end function

public function integer of_collapse_treeviewitem (long al_handle);Return tv_empl.CollapseItem(al_handle)
end function

public subroutine wf_photo_view (string as_emp_id);String		ls_file_path, ls_file_ext, ls_sys_id
Long		ll_filesizes, ll_handle
Blob		lb_file

ls_sys_id = 'GZ'
select	max(file_path) into :ls_file_path
from	fw_empl_pic
where	sys_id	= :ls_sys_id
and		emp_id	= :as_emp_id;
ls_file_path = SQLCA.getitemstring (1)
If fw_f_nvls(ls_file_path, '') = '' Then
	Post wf_photo_sample('admin')
	Return
End If
ls_file_ext	= right(ls_file_path, 3)
ls_file_path	= gnv_vari.is_tempdirectory +'\' + as_emp_id + '.' + ls_file_ext

If FileExists(ls_file_path) Then FileDelete(ls_file_path)

 /* blob_file Select	*/
Selectblob	blob_file into :lb_file
	from	fw_empl_pic
	where	sys_id	= :ls_sys_id
	and		emp_id	= :as_emp_id ;
//lb_file = mo_.hex2blob(SQLCA.is_hexfile)
If SQLCA.SQLCODE() <> 0 Then
	MessageBox("Error", "Failed to receive file![" + as_emp_id + "] ~r~n" + "[Error Message : " + String(sqlca.sqlerrtext()) +"]", StopSign!)
	Return
End If

ll_filesizes = gnv_file.setfile( ls_file_path, lb_file, 5)
//파일이 없음.
If ll_filesizes < 1 Then Return

dw_empl.SetRedraw( false )
dw_empl.Object.p_emp_pic.Filename = ls_file_path
dw_empl.SetRedraw( true )
end subroutine

public subroutine wf_photo_sample (string as_id);String		ls_file_path, ls_file_ext, ls_sys_id
Long		ll_filesizes, ll_handle
Blob		lb_file

ls_sys_id = 'GZ'

select	max(file_path) into :ls_file_path
from	fw_empl_pic
where	sys_id	= :ls_sys_id
and		emp_id	= :as_id;
ls_file_path = SQLCA.getitemstring (1)
If fw_f_nvls(ls_file_path, '') = '' Then Return
ls_file_ext	= right(ls_file_path, 3)
ls_file_path	= gnv_vari.is_tempdirectory +'\' + as_id + '.' + ls_file_ext

If FileExists(ls_file_path) Then FileDelete(ls_file_path)

 /* blob_file Select	*/
Selectblob	blob_file into :lb_file
	from	fw_empl_pic
	where	sys_id	= :ls_sys_id
	and		emp_id	= :as_id ;

 //ib_content = mo_.hex2blob(SQLCA.is_hexfile)
If SQLCA.SQLCODE() <> 0 Then
	MessageBox("Error", "Failed to receive file![" + as_id + "] ~r~n" + "[Error Message : " + String(sqlca.sqlerrtext()) +"]", StopSign!)
	Return
End If

ll_filesizes = gnv_file.setfile( ls_file_path, lb_file, 5)
//파일이 없음.
If ll_filesizes < 1 Then Return

dw_empl.SetRedraw( false )
dw_empl.Object.p_emp_pic.Filename = ls_file_path
dw_empl.SetRedraw( true )

//ll_handle = handle( this )
//
//func.of_shellexec(as_filepath, 1, ll_handle)
end subroutine

public function integer of_expand_retrieve ();ads_jTier		lds_menu
long			ll_rowcnt, ll_handle, i
long			ll_level, ll_parent[]
string			ls_pgm_no, ls_pgm_id, ls_pgm_nm
treeviewitem	ltvi_item
s_empl		lstr_data

tv_empl.setredraw(false)

ll_handle = tv_empl.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_empl.deleteitem(ll_handle)
	ll_handle = tv_empl.finditem(roottreeitem!, ll_handle)
loop
ll_rowcnt = ids_empl.retrieve(gnv_vari.is_sys_id, gnv_vari.is_lang_type)
ll_parent[1] = 0

for i = 1 to ll_rowcnt
	lstr_data.dept_cd		= ids_empl.getitemstring(i, 'dept_cd')
	lstr_data.dept_nm		= ids_empl.getitemstring(i, 'dept_nm')
	lstr_data.dept_parent	= ids_empl.getitemstring(i, 'dept_parent')
	lstr_data.kind_gb		= ids_empl.getitemstring(i, 'kind_gb')

	ltvi_item.data = lstr_data
	ltvi_item.label = lstr_data.dept_nm
	If Pos(lstr_data.dept_cd, '000000') > 0 Then
		ltvi_item.PictureIndex = 7
		ltvi_item.SelectedPictureIndex = 8
	Else
		If lstr_data.kind_gb = 'E' Then
			ltvi_item.PictureIndex = 3
			ltvi_item.SelectedPictureIndex = 4
		Else
			ltvi_item.PictureIndex = 1
			ltvi_item.SelectedPictureIndex = 2
		End If
	End If
		
	if ids_empl.getitemnumber(i, 'child_cnt') > 0 then
		ltvi_item.Children = true
	else
		ltvi_item.Children = false
	end if
	
	ll_level = ids_empl.getitemnumber(i, 'level_no')
	ll_handle = tv_empl.InsertItemLast(ll_parent[ll_level], ltvi_item)
	ll_parent[ll_level + 1] = ll_handle	
next

// child item이 없는 node삭제
long ll_tvi, ll_nochild[]

ll_rowcnt = 0
ll_tvi = tv_empl.FindItem(RootTreeItem!, 0)

do while ll_tvi > 0
	tv_empl.getitem(ll_tvi, ltvi_item)
	if ltvi_item.pictureindex = 3 then
		if tv_empl.FindItem(ChildTreeItem!, ll_tvi) = -1 then
			ll_rowcnt ++
			ll_nochild[ll_rowcnt] = ll_tvi
		end if
	end if
	ll_tvi = tv_empl.FindItem(NextVisibleTreeItem!, ll_tvi)
loop

for i = 1 to upperbound(ll_nochild)
	tv_empl.deleteitem(ll_nochild[i])
next

//전체  메뉴 펼치기
long ll_root[]

ll_rowcnt = 0
ll_tvi = tv_empl.FindItem(RootTreeItem!, 0)
do while ll_tvi > 0
	ll_rowcnt ++
	ll_root[ll_rowcnt] = ll_tvi
	ll_tvi = tv_empl.FindItem(NextVisibleTreeItem!, ll_tvi)
loop

for i = 1 to ll_rowcnt
	tv_empl.expandall(ll_root[i])
next

if upperbound(ll_root) > 0 then
	tv_empl.post selectitem(ll_root[1])
end if
tv_empl.setredraw(true)

return ll_rowcnt

end function

on w_bzinsa01_02.create
int iCurrent
call super::create
this.tv_empl=create tv_empl
this.cbx_expand=create cbx_expand
this.dw_empl=create dw_empl
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_pic_sample=create cb_pic_sample
this.uo_title1=create uo_title1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_empl
this.Control[iCurrent+2]=this.cbx_expand
this.Control[iCurrent+3]=this.dw_empl
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_pic_sample
this.Control[iCurrent+7]=this.uo_title1
end on

on w_bzinsa01_02.destroy
call super::destroy
destroy(this.tv_empl)
destroy(this.cbx_expand)
destroy(this.dw_empl)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_pic_sample)
destroy(this.uo_title1)
end on

event wue_postopen;call super::wue_postopen;Post Event wue_retrieve2ready()
end event

event wue_retrieve;call super::wue_retrieve;of_expand_retrieve()
end event

event wue_setdddw;call super::wue_setdddw;fw_f_setdddw(dw_empl, 'emp_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP006', '%'})
fw_f_setdddw(dw_empl, 'duty_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP004', '%'})
fw_f_setdddw(dw_empl, 'rank_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP005', '%'})
fw_f_setdddw(dw_empl, 'job_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP008', '%'})
fw_f_setdddw(dw_empl, 'ent_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP010', '%'})
fw_f_setdddw(dw_empl, 'carr_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP009', '%'})
fw_f_setdddw(dw_empl, 'pay_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP007', '%'})
fw_f_setdddw(dw_empl, 'pay_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP007', '%'})
fw_f_setdddw(dw_empl, 'sex_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'EMP011', '%'})
end event

event wue_retrieve4lang;call super::wue_retrieve4lang;of_expand_retrieve()
end event

event wue_update;call super::wue_update;if of_update({dw_empl}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_clear;call super::wue_clear;ids_empl = create ads_jTier
ids_empl.dataobject = 'd_bzinsa01_02_ds1_spc'
ids_empl.settransobject(sqlca)
end event

type lb_dirlist from w_window1st5cn`lb_dirlist within w_bzinsa01_02
end type

type ln_templeft from w_window1st5cn`ln_templeft within w_bzinsa01_02
end type

type ln_tempbuttom from w_window1st5cn`ln_tempbuttom within w_bzinsa01_02
end type

type ln_temptop from w_window1st5cn`ln_temptop within w_bzinsa01_02
end type

type ln_tempbutton from w_window1st5cn`ln_tempbutton within w_bzinsa01_02
end type

type ln_tempstart from w_window1st5cn`ln_tempstart within w_bzinsa01_02
end type

type ln_cond1_yline from w_window1st5cn`ln_cond1_yline within w_bzinsa01_02
end type

type ln_dw1_yline from w_window1st5cn`ln_dw1_yline within w_bzinsa01_02
end type

type ln_cond2_yline from w_window1st5cn`ln_cond2_yline within w_bzinsa01_02
end type

type ln_dw2_yline from w_window1st5cn`ln_dw2_yline within w_bzinsa01_02
end type

type ln_tempright from w_window1st5cn`ln_tempright within w_bzinsa01_02
end type

type uo_navi from w_window1st5cn`uo_navi within w_bzinsa01_02
end type

type ln_temptop_shadow from w_window1st5cn`ln_temptop_shadow within w_bzinsa01_02
end type

type st_windelaytime from w_window1st5cn`st_windelaytime within w_bzinsa01_02
end type

type p_close from w_window1st5cn`p_close within w_bzinsa01_02
end type

type p_excel from w_window1st5cn`p_excel within w_bzinsa01_02
end type

type p_print from w_window1st5cn`p_print within w_bzinsa01_02
end type

type p_delete from w_window1st5cn`p_delete within w_bzinsa01_02
end type

type p_update from w_window1st5cn`p_update within w_bzinsa01_02
end type

type p_input from w_window1st5cn`p_input within w_bzinsa01_02
end type

type p_retrieve from w_window1st5cn`p_retrieve within w_bzinsa01_02
end type

type p_clear from w_window1st5cn`p_clear within w_bzinsa01_02
end type

type dw_cond from w_window1st5cn`dw_cond within w_bzinsa01_02
end type

type tv_empl from pf_u_treeview within w_bzinsa01_02
integer x = 50
integer y = 416
integer width = 1499
integer height = 2348
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 20132659
boolean disabledragdrop = false
string picturename[] = {"..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif","..\img\mainframe\u_treemenu\lvl4close.gif","..\img\mainframe\u_treemenu\lvl4open.gif","..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif"}
long picturemaskcolor = 12632256
boolean scaletobottom = true
end type

event selectionchanged;String	ls_dept_cd
s_empl	lstr_data

il_handle = newhandle
this.getitem(il_handle, itvi_item)
lstr_data = itvi_item.data
ls_dept_cd = lstr_data.dept_cd

dw_empl.retrieve(gnv_vari.is_sys_id, ls_dept_cd)

wf_photo_view(ls_dept_cd)

return 0
end event

type cbx_expand from pf_u_checkbox within w_bzinsa01_02
integer x = 1134
integer y = 336
integer width = 416
integer height = 76
boolean bringtotop = true
long textcolor = 19737901
string text = "확장구분"
boolean righttoleft = true
boolean setsheetcolor = true
end type

type dw_empl from fw_u_dwo within w_bzinsa01_02
integer x = 1573
integer y = 416
integer width = 3858
integer height = 2348
integer taborder = 20
boolean bringtotop = true
string title = "직원상세정보"
string dataobject = "d_bzinsa01_02_1"
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibtitle4datawindow = true
boolean setfocusdw = true
boolean setedittoken = true
end type

event clicked;call super::clicked;Choose Case dwo.name
	Case 'p_dept_cd'
		pf_n_hashtable	lnv_data
		lnv_data = Create pf_n_hashtable
		lnv_data.of_put('title', 'Dept Search')
		
		openwithparm(w_bzdept_pop1, lnv_data)
		lnv_data = Message.PowerObjectparm
		IF IsValid(lnv_data) THEN
			This.setitem(row, 'dept_cd',lnv_data.of_getString('dept_cd'))
			This.setitem(row, 'dept_knm',lnv_data.of_getString('dept_nm'))
		Else
			This.setitem(row, 'dept_cd','')
			This.setitem(row, 'dept_knm','')
		End If
	Case 'p_group_ymd'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.group_ymd, row)
	Case 'p_ent_ymd1'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.ent_ymd1, row)
	Case 'p_ent_ymd2'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.ent_ymd2, row)		
	Case 'p_ret_ymd1'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.ret_ymd1, row)		
	Case 'p_birth_ymd'
		fw_f_calendardwo4day1(iw_parent, This, This.Object.birth_ymd, row)
	Case 'p_post_search'
		fw_s_postalvalue	lstr_postalvalue
		openwithparm(fw_w_postcode, '')
		lstr_postalvalue = message.powerObjectParm
		If IsValid(lstr_postalvalue) Then
			
		End If
		
End Choose
end event

event updatestart;call super::updatestart;Long		ll_rcnt, ll_row, ll_nowseq = 0

dwitemstatus	 ldwstatus

ll_rcnt			= this.rowcount()

Do While ll_row <= ll_rcnt
	ll_row = this.getnextmodified(ll_row, Primary!)
	IF ll_row > 0 THEN
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus
			Case NewModified!
				ll_nowseq ++

				This.setItem(ll_row, 'sys_id', gnv_vari.is_sys_id)
				This.setItem(ll_row, 'use_gb', 'Y')
				This.setItem(ll_row, 'emp_pw', 'uiophjkl')
				This.setItem(ll_row, 'reg_id', gnv_vari.is_user_id)
				This.setItem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
			Case DataModified!
				This.setItem(ll_row, 'upd_id', gnv_vari.is_user_id)
				This.setItem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		End CHoose
	Else
		ll_row = ll_rcnt + 1        
	End If
Loop

end event

event oue_setupdatecheck;call super::oue_setupdatecheck;IF This.Rowcount() > 0 THEN
	String		ls_temp
	Long		ll_rcnt, ll_i, ll_temp	
	DWItemStatus	ItemStatus
		
	ll_rcnt = This.Rowcount()
	
	FOR ll_i = 1 TO ll_rcnt
		ItemStatus = This.GetItemStatus(ll_i, 0, primary!)
		
		IF ItemStatus = NewModified! THEN
			ls_temp = fw_f_nvls(dw_empl.getItemString(ll_i, 'dept_cd'), '')
			IF Len(ls_temp) = 0 Then
				Messagebox("Check", "Department not registered.")
				Return -1
			End IF
			
			ls_temp = fw_f_nvls(This.getItemString(ll_i, 'emp_id'), '')
			IF Len(ls_temp) = 0 Then
				Messagebox("Check", "Employee number has not been registered.")
				Return -1
			End IF
	
			ls_temp = fw_f_nvls(This.getItemString(ll_i, 'emp_reg'), '')
			IF Len(ls_temp) = 0 Then
				Messagebox("Check", "You have not registered the date of your employment.")
				Return -1
			End IF
		End If
			
	NEXT
END IF

Return 1
end event

type cb_2 from pf_u_commandbutton within w_bzinsa01_02
integer x = 4759
integer y = 184
integer width = 325
integer height = 104
integer taborder = 140
boolean bringtotop = true
string text = "Photo U"
boolean fixedtoright = true
end type

event clicked;call super::clicked;String		ls_emp_id, ls_picnm, ls_sys_id, ls_picpath, ls_datetime, ls_SqlErrText
Long		ll_filebytes, ll_tmp_cnt
integer	li_value
Blob		lb_pic_file

dw_empl.AcceptText()
If dw_empl.rowcount() < 1 Then Return

ls_emp_id = dw_empl.GetItemString(1, 'emp_id')
If fw_f_nvls(ls_emp_id, '') = '' Then Return

ls_sys_id = 'GZ'
fw_f_savepath('get', '')
li_value = GetFileOpenName("Select File", &
			ls_picpath, ls_picnm, "jpg", &
			"Picture Files (*.jpg),*.jpg," +  &
			"Picture Files (*.gif),*.gif," +  &
			"Picture Files (*.png),*.png")
If li_value < 1 Then return

select	count(emp_id) Into :ll_tmp_cnt
from	fw_empl_pic
where	sys_id	= :ls_sys_id
and		emp_id	= :ls_emp_id ;
ll_tmp_cnt = SQLCA.getitemnumber (1)
ls_datetime	= fw_f_getymdhh24miss4s()
ll_filebytes = gnv_file.getfile (ls_picpath, lb_pic_file)

If ll_filebytes < 1 Then
	Messagebox('Check', 'There is no capacity.')
	Return
End If

If ll_tmp_cnt > 0 Then	//Update(기존자료 존재)
	update	fw_empl_pic
		Set	file_size		= :ll_filebytes,
			file_path	= :ls_picpath,
			save_date	= :ls_datetime,
			upd_id		= :gnv_vari.is_user_id,
			upd_dt		= :ls_datetime
	where	sys_id		= :ls_sys_id
	and		emp_id		= :ls_emp_id ;
Else //신규등록
	Insert Into fw_empl_pic (sys_id, emp_id, file_size, file_path, save_date, reg_id,  reg_dt)
	Values (:ls_sys_id, :ls_emp_id,  :ll_filebytes, :ls_picpath, :ls_datetime, :gnv_vari.is_user_id, :ls_datetime);
End If

IF Sqlca.Sqlcode() <> 0 Then
	Messagebox('Notice', 'Employee photo registration 1 error. ~r~n' + &
							 'Error code ' + STRING(SQLCA.SQLCODE()) + ' ~r~n' + &	
							 'Error Msg ' + SQLCA.SQLERRTEXT() , StopSign!) 	
	rollbackj()
	Return
End If

LONG		ll_blob
STRING	ls_blob_err

ll_blob = mo_.blob2hex(lb_pic_file, SQLCA.is_updateblob, ls_blob_err)

updateblob	fw_empl_pic
	 set 	blob_file	= :lb_pic_file
	where	sys_id		= :ls_sys_id
	and		emp_id		= :ls_emp_id;
	
If SqlCa.SqlCode() <> 0 Then
	ls_SqlErrText = SqlCa.SqlErrText()
	MessageBox('Error : ' + 'Photo registration error' + String(SqlCa.SqlCode()), ls_SqlErrText)
	rollbackj()
	Return
End If

commitj ()

Post wf_photo_view(ls_emp_id)
end event

type cb_1 from pf_u_commandbutton within w_bzinsa01_02
integer x = 5093
integer y = 184
integer width = 325
integer height = 104
integer taborder = 150
boolean bringtotop = true
string text = "Photo D"
boolean fixedtoright = true
end type

event clicked;call super::clicked;String		ls_emp_id, ls_picnm, ls_picpath, ls_datetime, ls_SqlErrText
Long		ll_filebytes, ll_tmp_cnt
integer	li_value
Blob		lb_pic_file

dw_empl.AcceptText()
If dw_empl.rowcount() < 1 Then Return

ls_emp_id = dw_empl.GetItemString(1, 'emp_id')
If fw_f_nvls(ls_emp_id, '') = '' Then Return

 Select	count(emp_id) Into :ll_tmp_cnt
  From	fw_empl_pic
Where	sys_id		= :gnv_vari.is_sys_id
	and	emp_id	= :ls_emp_id ;
ll_tmp_cnt = SQLCA.getitemnumber (1)
If ll_tmp_cnt < 1 Then Return

Delete	fw_empl_pic
 Where	sys_id		= :gnv_vari.is_sys_id
	and	emp_id	= :ls_emp_id ;

IF Sqlca.Sqlcode() <> 0 Then
	Messagebox('Notice', 'Employee photo Delete Error. ~r~n' + &
							 'Error code ' + STRING(SQLCA.SQLCODE()) + ' ~r~n' + &	
							 'Error Msg ' + SQLCA.SQLERRTEXT() , StopSign!) 	 
	
	rollbackj()
	Return
End If

commitj()

dw_empl.SetRedraw( false )
dw_empl.Object.p_emp_pic.Filename = ''
dw_empl.SetRedraw( true )
end event

type cb_pic_sample from pf_u_commandbutton within w_bzinsa01_02
boolean visible = false
integer x = 1897
integer y = 16
integer width = 361
integer height = 104
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string text = "pic sample"
boolean fixedtoright = true
end type

event clicked;call super::clicked;String	ls_picnm, ls_sys_id, ls_picpath, ls_datetime, ls_SqlErrText
Long	ll_filebytes, ll_tmp_cnt
integer	li_value
Blob	lb_pic_file

ls_sys_id = 'GZ'
fw_f_savepath('get', '')
li_value = GetFileOpenName("Select File", &
			ls_picpath, ls_picnm, "jpg", &
			"Picture Files (*.jpg),*.jpg," +  &
			"Picture Files (*.gif),*.gif," +  &
			"Picture Files (*.png),*.png")
If li_value < 1 Then return

select	count(emp_id) Into :ll_tmp_cnt
from	fw_empl_pic
where	sys_id	= :ls_sys_id
and		emp_id	= 'admin';
ll_tmp_cnt = SQLCA.getitemnumber (1)

ls_datetime	= fw_f_getymdhh24miss4s()
ll_filebytes = gnv_file.getfile (ls_picpath, lb_pic_file)
If ll_filebytes < 1 Then
	Messagebox('Check', 'There is no capacity.')
	Return
End If

If ll_tmp_cnt > 0 Then	//Update(기존자료 존재)
	update	fw_empl_pic
		Set	file_size		= :ll_filebytes,
			file_path	= :ls_picpath,
			save_date	= :ls_datetime,
			upd_id		= :gnv_vari.is_user_id,
			upd_dt		= :ls_datetime
	where	sys_id		= :ls_sys_id
	and		emp_id		= 'admin';
Else //신규등록
	Insert Into fw_empl_pic (sys_id, emp_id, file_size, file_path, save_date, reg_id,  reg_dt)
	Values (:ls_sys_id, 'admin',  :ll_filebytes, :ls_picpath, :ls_datetime, :gnv_vari.is_user_id, :ls_datetime);
End If

IF Sqlca.Sqlcode() <> 0 Then
	Messagebox('Notice', 'Employee photo registration 1 error. ~r~n' + &
							 'Error code ' + STRING(SQLCA.SQLCODE()) + ' ~r~n' + &	
							 'Error Msg ' + SQLCA.SQLERRTEXT() , StopSign!) 	 
	rollbackJ ()
	Return
End If

LONG		ll_blob
STRING	ls_blob_err

ll_blob = mo_.blob2hex(lb_pic_file, SQLCA.is_updateblob, ls_blob_err)

updateblob	fw_empl_pic
	set		blob_file	= :lb_pic_file
	where	sys_id		= :ls_sys_id
	and		emp_id		= 'admin';
//lb_pic_file = mo_.hex2blob(SQLCA.is_hexfile)
If SqlCa.SqlCode() <> 0 Then
	ls_SqlErrText = SqlCa.SqlErrText()
	MessageBox('Error : ' + 'Photo registration error' + String(SqlCa.SqlCode()), ls_SqlErrText)
	rollbackJ ()
	Return
End If

commitJ ()

Post wf_photo_sample('admin')
end event

type uo_title1 from fw_u_dw2title within w_bzinsa01_02
integer x = 50
integer y = 336
integer taborder = 110
boolean bringtotop = true
string istitletext = "조직"
end type

on uo_title1.destroy
call fw_u_dw2title::destroy
end on

