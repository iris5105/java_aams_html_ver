forward
global type u_dept1 from u_ancestor
end type
type st_title from pf_u_statictext within u_dept1
end type
type tv_dept from pf_u_treeview within u_dept1
end type
type p_search from pf_u_imagebutton within u_dept1
end type
type em_findstr from pf_u_editmask within u_dept1
end type
type r_1 from rectangle within u_dept1
end type
end forward

global type u_dept1 from u_ancestor
integer width = 1207
integer height = 1444
event oue_clicked ( string as_dept_cd,  string as_dept_name,  string as_dept_parent )
event oue_nomouseover ( )
st_title st_title
tv_dept tv_dept
p_search p_search
em_findstr em_findstr
r_1 r_1
end type
global u_dept1 u_dept1

type variables
ads_jTier ids_dept

end variables

forward prototypes
public function integer of_drawmenu ()
public subroutine of_clearfindstr ()
end prototypes

public function integer of_drawmenu ();ads_jTier		lds_menu
long			ll_rowcnt, ll_handle, i
long			ll_level, ll_parent[]
string			ls_pgm_no, ls_pgm_id, ls_pgm_nm
treeviewitem		ltvi_item
s_empl			lstr_data

tv_dept.setredraw(false)

ll_handle = tv_dept.finditem(roottreeitem!, 0)
do while ll_handle > 0
	tv_dept.deleteitem(ll_handle)
	ll_handle = tv_dept.finditem(roottreeitem!, ll_handle)
loop

ll_rowcnt = ids_dept.retrieve(gnv_vari.is_sys_id, '0000000', gnv_vari.is_lang_type)

ll_parent[1] = 0

for i = 1 to ll_rowcnt
	lstr_data.dept_cd		= ids_dept.getitemstring(i, 'dept_cd')
	lstr_data.dept_nm		= ids_dept.getitemstring(i, 'dept_nm')
	lstr_data.dept_parent	= ids_dept.getitemstring(i, 'dept_parent')

	ltvi_item.data = lstr_data
	ltvi_item.label = lstr_data.dept_nm
	If lstr_data.dept_cd = '1000000' Then
		ltvi_item.PictureIndex = 7
		ltvi_item.SelectedPictureIndex = 8
	Else
		ltvi_item.PictureIndex = 1
		ltvi_item.SelectedPictureIndex = 2
	End If
		
	if ids_dept.getitemnumber(i, 'child_cnt') > 0 then
		ltvi_item.Children = true
	else
		ltvi_item.Children = false
	end if
	
	ll_level = ids_dept.getitemnumber(i, 'level_cd')
	ll_handle = tv_dept.InsertItemLast(ll_parent[ll_level], ltvi_item)
	ll_parent[ll_level + 1] = ll_handle
next

// child item이 없는 node삭제
long ll_tvi, ll_nochild[]

ll_rowcnt = 0
ll_tvi = tv_dept.FindItem(RootTreeItem!, 0)

do while ll_tvi > 0
	tv_dept.getitem(ll_tvi, ltvi_item)
	if ltvi_item.pictureindex = 3 then
		if tv_dept.FindItem(ChildTreeItem!, ll_tvi) = -1 then
			ll_rowcnt ++
			ll_nochild[ll_rowcnt] = ll_tvi
		end if
	end if
	ll_tvi = tv_dept.FindItem(NextVisibleTreeItem!, ll_tvi)
loop

for i = 1 to upperbound(ll_nochild)
	tv_dept.deleteitem(ll_nochild[i])
next

//전체  메뉴 펼치기
long ll_root[]

ll_rowcnt = 0
ll_tvi = tv_dept.FindItem(RootTreeItem!, 0)
do while ll_tvi > 0
	ll_rowcnt ++
	ll_root[ll_rowcnt] = ll_tvi
	ll_tvi = tv_dept.FindItem(NextVisibleTreeItem!, ll_tvi)
loop

for i = 1 to ll_rowcnt
	tv_dept.expandall(ll_root[i])
next

if upperbound(ll_root) > 0 then
	tv_dept.post selectitem(ll_root[1])
end if
tv_dept.setredraw(true)

return ll_rowcnt

end function

public subroutine of_clearfindstr ();em_findstr.text = ''
end subroutine

on u_dept1.create
int iCurrent
call super::create
this.st_title=create st_title
this.tv_dept=create tv_dept
this.p_search=create p_search
this.em_findstr=create em_findstr
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.tv_dept
this.Control[iCurrent+3]=this.p_search
this.Control[iCurrent+4]=this.em_findstr
this.Control[iCurrent+5]=this.r_1
end on

on u_dept1.destroy
call super::destroy
destroy(this.st_title)
destroy(this.tv_dept)
destroy(this.p_search)
destroy(this.em_findstr)
destroy(this.r_1)
end on

event constructor;call super::constructor;ids_dept = create ads_jTier
Choose Case Parent.dynamic of_gettaskgb()
	Case 'EMP'
		ids_dept.dataobject = 'd_bzinsa01_02_ds1_spc'
	Case 'EAP'
		ids_dept.dataobject = 'd_bzinsa01_01_ds1_spc'
End Choose
ids_dept.settransobject(sqlca)
end event

event destructor;if isvalid(ids_dept) then
	destroy ids_dept
end if
end event

type st_title from pf_u_statictext within u_dept1
integer x = 27
integer y = 36
integer width = 261
integer height = 80
boolean bringtotop = true
long textcolor = 19737901
string text = "부서검색"
alignment alignment = right!
end type

type tv_dept from pf_u_treeview within u_dept1
integer x = 18
integer y = 148
integer width = 1166
integer height = 1280
integer taborder = 20
boolean bringtotop = true
long textcolor = 20395836
string picturename[] = {"..\img\mainframe\u_treemenu\lvl3close.gif","..\img\mainframe\u_treemenu\lvl3open.gif","..\img\mainframe\u_treemenu\clicked_no.gif","..\img\mainframe\u_treemenu\clicked_yes.gif","..\img\mainframe\u_treemenu\lvl4close.gif","..\img\mainframe\u_treemenu\lvl4open.gif","..\img\mainframe\u_treemenu\lvl1close.gif","..\img\mainframe\u_treemenu\lvl1open.gif"}
long picturemaskcolor = 12632256
boolean scaletoright = true
boolean scaletobottom = true
end type

event key;call super::key;choose case key
	case keyEnter!
		p_search.post event clicked()
end choose

end event

event selectionchanged;call super::selectionchanged;treeviewitem		ltvi_item
s_empl			lstr_data

if this.getitem(newhandle, ltvi_item) = -1 then return

lstr_data = ltvi_item.data

Parent.Post Event oue_clicked(lstr_data.dept_cd, lstr_data.dept_nm, lstr_data.dept_parent)
end event

type p_search from pf_u_imagebutton within u_dept1
integer x = 1070
integer y = 24
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_search.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;string ls_findstr
long ll_pos

ls_findstr = em_findstr.text
If isnull(ls_findstr) or len(ls_findstr) = 0 Then
	messagebox('Notice', '메뉴를 검색할 부서 명칭 또는 부서코드를 입력하세요')
	em_findstr.setfocus()
	return
End If

// 검색조건에 해당하는 메뉴 검색
long ll_tvi
treeviewitem ltvi_item
s_empl		 lstr_data

ll_tvi = tv_dept.FindItem(CurrentTreeItem!, 0)
If ll_tvi = -1 Then return

ll_tvi = tv_dept.FindItem(NextVisibleTreeItem!, ll_tvi)
Do While ll_tvi > 0
	tv_dept.getitem(ll_tvi, ltvi_item)
	lstr_data = ltvi_item.data
	
	ll_pos = pos(lstr_data.dept_cd, upper(ls_findstr))
	ll_pos += pos(lstr_data.dept_nm, upper(ls_findstr))
	
	If ll_pos > 0 Then
		tv_dept.setfocus()
		tv_dept.selectitem(ll_tvi)
		Return
	End If

	ll_tvi = tv_dept.FindItem(NextVisibleTreeItem!, ll_tvi)
Loop

If messagebox('Notice', '일치하는 항목이 존재하지 않습니다.~r~n처음부터 다시 검색하시겠습니까?', Question!, YesNo!, 2) = 1 Then
	ll_tvi = tv_dept.finditem(RootTreeItem!, 0)
	If ll_tvi > 0 Then
		tv_dept.finditem(NextVisibleTreeItem!, ll_tvi)
		tv_dept.selectitem(ll_tvi)
		This.Post Event clicked()
	End If
End If

end event

type em_findstr from pf_u_editmask within u_dept1
integer x = 297
integer y = 28
integer width = 763
integer taborder = 10
boolean bringtotop = true
long textcolor = 20395836
maskdatatype maskdatatype = stringmask!
boolean scaletoright = true
end type

event modified;call super::modified;if len(this.text) > 0 then
	p_search.event clicked()
end if

end event

event getfocus;call super::getfocus;pf_f_togglekoreng('k')
end event

type r_1 from rectangle within u_dept1
long linecolor = 134217728
integer linethickness = 4
long fillcolor = 1073741824
integer width = 1202
integer height = 1440
end type

