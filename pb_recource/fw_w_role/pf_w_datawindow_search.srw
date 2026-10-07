forward
global type pf_w_datawindow_search from w_response1st
end type
type dw_dwlist from fw_u_dwo within pf_w_datawindow_search
end type
type st_1 from statictext within pf_w_datawindow_search
end type
type ddlb_list from dropdownlistbox within pf_w_datawindow_search
end type
type p_cancel from pf_u_imagebutton within pf_w_datawindow_search
end type
type p_ok from pf_u_imagebutton within pf_w_datawindow_search
end type
type r_1 from rectangle within pf_w_datawindow_search
end type
end forward

global type pf_w_datawindow_search from w_response1st
integer width = 3237
integer height = 1676
string title = "Datawindow 선택 창"
dw_dwlist dw_dwlist
st_1 st_1
ddlb_list ddlb_list
p_cancel p_cancel
p_ok p_ok
r_1 r_1
end type
global pf_w_datawindow_search pf_w_datawindow_search

type variables
string is_appname
end variables

forward prototypes
public subroutine of_get_pbl_list (ref string as_pbl_list[])
public subroutine of_insert_pbl_list (string as_path, string as_data)
public subroutine of_library_list ()
public subroutine of_pbl_list (string as_full_path, ref string as_pbl_list[])
end prototypes

public subroutine of_get_pbl_list (ref string as_pbl_list[]);Integer 				li_lastpos, li_pos1, li_pos2, li_x, li_index, li_len
String 				ls_librarylist
Boolean 			lb_init = True

ls_librarylist = getlibrarylist()

li_lastpos = 1
li_index = 1
li_len = Len(ls_librarylist)
DO 
	li_pos1 = Pos(ls_librarylist, ",", li_lastpos)
	IF lb_init = True THEN
		IF li_pos1 = 0 THEN
			as_pbl_list[li_index] = Mid(ls_librarylist, li_lastpos, li_len)
		ELSE
			as_pbl_list[li_index] = Mid(ls_librarylist, li_lastpos, li_pos1 - li_lastpos)
		END IF
		lb_init = False
	ELSE
		IF li_pos1 = 0 THEN
			as_pbl_list[li_index] = Mid(ls_librarylist, li_lastpos, li_len - li_lastpos + 1)
		ELSE
			as_pbl_list[li_index] = Mid(ls_librarylist, li_lastpos, li_pos1 - li_lastpos)
		END IF
	END IF
	li_index ++
	li_lastpos = li_pos1 + 1
LOOP UNTIL li_pos1 = 0
end subroutine

public subroutine of_insert_pbl_list (string as_path, string as_data);String 			ls_pbllist[], ls_item, ls_filetime
Integer 			li_num, li_x, li_pos, li_lastpos = 1

// Argument 예
// as_path : e:\support\eas41\
// as_data : test.pbt

This.of_pbl_list( as_path, ls_pbllist )
li_num = UpperBound(ls_pbllist)

FOR li_x = 1 TO li_num
	ls_item = ls_pbllist[li_x]
	
	DO 
		li_pos = Pos(ls_item, "\\", li_lastpos)
		IF li_pos > 0 THEN
			ls_item = Replace(ls_item, li_pos, 2, "\")
			li_lastpos = li_pos + 2
		END IF	
	LOOP UNTIL li_pos = 0  	 	
	
	ddlb_list.additem( ls_item)
	
	li_lastpos = 1 // 찾는위치 초기화!
NEXT

end subroutine

public subroutine of_library_list ();String 			ls_pbllist[], ls_item, ls_filetime
Integer 			li_num, li_x, li_pos, li_lastpos = 1

This.of_get_pbl_list( ls_pbllist )
li_num = UpperBound(ls_pbllist)

FOR li_x = 1 TO li_num
	ls_item = ls_pbllist[li_x]
	
	DO 
		li_pos = Pos(ls_item, "\\", li_lastpos)
		IF li_pos > 0 THEN
			ls_item = Replace(ls_item, li_pos, 2, "\")
			li_lastpos = li_pos + 2
		END IF	
	LOOP UNTIL li_pos = 0  	 	
	
	ddlb_list.additem( ls_item)
	
	li_lastpos = 1 // 찾는위치 초기화!
NEXT

end subroutine

public subroutine of_pbl_list (string as_full_path, ref string as_pbl_list[]);Integer 			li_filenum,  li_loop, li_lastpos, li_pos1, li_pos2, li_x, li_index, li_len
Long 				ll_filelen
String 			ls_filepath, ls_pblinfo, ls_fileseg, ls_liblist
Boolean 			lb_init = True

ll_filelen = FileLength(as_full_path)
li_filenum = FileOpen(as_full_path, StreamMode!, Read!, LockWrite!)
IF ll_filelen > 32765 THEN
	IF Mod(ll_filelen, 32765) = 0 THEN
		li_loop = ll_filelen/32765
	ELSE
		li_loop = (ll_filelen/32765) + 1
	END IF
ELSE
	li_loop = 1 
END IF

FOR li_x = 1 TO li_loop
	 FileRead(li_filenum, ls_fileseg)
	 ls_pblinfo = ls_pblinfo + ls_fileseg
NEXT

FileClose(li_filenum)

li_lastpos = Pos(Lower(ls_pblinfo), "appname", 1)
IF li_lastpos = 0 THEN 
	MessageBox('Notice!', "Web Target 입니다!")
	Return
END IF

li_pos1 = Pos(ls_pblinfo, '"', li_lastpos)
li_pos2 = Pos(ls_pblinfo, '"', li_pos1 + 1)

is_appname = Mid(ls_pblinfo, li_pos1 + 1, li_pos2 - (li_pos1 + 1) ) //Application 오브젝트명 저장

//LastPos() 함수는 대소문자를 가린다.
li_lastpos = LastPos(Lower(ls_pblinfo), "liblist") //8.0
IF li_lastpos = 0 THEN 
	li_lastpos = LastPos(Lower(ls_pblinfo), "LibList") //9.0
END IF
li_pos1 = Pos(ls_pblinfo, '"', li_lastpos)
li_pos2 = Pos(ls_pblinfo, '"', li_pos1 + 1)

ls_liblist = Mid(ls_pblinfo, li_pos1 + 1, li_pos2 - (li_pos1 + 1) ) //Library List 저장

li_lastpos = 1
li_index = 1
li_len = Len(ls_liblist)
DO 
	li_pos1 = Pos(ls_liblist, ";", li_lastpos)
	IF lb_init = True THEN
		IF li_pos1 = 0 THEN
			as_pbl_list[li_index] = Mid(ls_liblist, li_lastpos, li_len)
		ELSE
			as_pbl_list[li_index] = Mid(ls_liblist, li_lastpos, li_pos1 - li_lastpos)
		END IF
		lb_init = False
	ELSE
		IF li_pos1 = 0 THEN
			as_pbl_list[li_index] = Mid(ls_liblist, li_lastpos, li_len - li_lastpos + 1)
		ELSE
			as_pbl_list[li_index] = Mid(ls_liblist, li_lastpos, li_pos1 - li_lastpos)
		END IF
	END IF
	li_index ++
	li_lastpos = li_pos1 + 1
LOOP UNTIL li_pos1 = 0
end subroutine

on pf_w_datawindow_search.create
int iCurrent
call super::create
this.dw_dwlist=create dw_dwlist
this.st_1=create st_1
this.ddlb_list=create ddlb_list
this.p_cancel=create p_cancel
this.p_ok=create p_ok
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dwlist
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_list
this.Control[iCurrent+4]=this.p_cancel
this.Control[iCurrent+5]=this.p_ok
this.Control[iCurrent+6]=this.r_1
end on

on pf_w_datawindow_search.destroy
call super::destroy
destroy(this.dw_dwlist)
destroy(this.st_1)
destroy(this.ddlb_list)
destroy(this.p_cancel)
destroy(this.p_ok)
destroy(this.r_1)
end on

event open;call super::open;this.post of_library_list()

end event

type ln_tempbutton from w_response1st`ln_tempbutton within pf_w_datawindow_search
end type

type ln_tempstart from w_response1st`ln_tempstart within pf_w_datawindow_search
end type

type ln_templeft from w_response1st`ln_templeft within pf_w_datawindow_search
end type

type ln_cond_start from w_response1st`ln_cond_start within pf_w_datawindow_search
end type

type ln_tempright from w_response1st`ln_tempright within pf_w_datawindow_search
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within pf_w_datawindow_search
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within pf_w_datawindow_search
end type

type dw_dwlist from fw_u_dwo within pf_w_datawindow_search
integer x = 50
integer y = 144
integer width = 3136
integer height = 1420
integer taborder = 20
string title = "none"
string dataobject = "pf_d_datawindow_search"
boolean hscrollbar = true
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4singleselect = true
end type

event doubleclicked;p_ok.post event clicked()

end event

type st_1 from statictext within pf_w_datawindow_search
integer x = 101
integer y = 44
integer width = 329
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 21382726
long backcolor = 32501743
string text = "Library List"
boolean focusrectangle = false
end type

type ddlb_list from dropdownlistbox within pf_w_datawindow_search
integer x = 443
integer y = 32
integer width = 2002
integer height = 512
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 21382726
boolean autohscroll = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_entries, ls_win

ls_entries = LibraryDirectory( This.Text(index), DirDataWindow!)
dw_dwlist.reset()
dw_dwlist.importstring(ls_entries)

end event

type p_cancel from pf_u_imagebutton within pf_w_datawindow_search
integer x = 2958
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;call super::clicked;pf_n_hashtable lnv_retval

lnv_retval = create pf_n_hashtable

lnv_retval.of_put('classname', '')
lnv_retval.of_put('comment', '')
	
closewithreturn(parent, lnv_retval)

end event

type p_ok from pf_u_imagebutton within pf_w_datawindow_search
integer x = 2720
integer y = 28
integer width = 229
integer height = 96
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

event clicked;call super::clicked;pf_n_hashtable lnv_retval
long ll_row
string ls_classname, ls_comment

lnv_retval = create pf_n_hashtable
ll_row = dw_dwlist.getrow()
if ll_row > 0 then
	ls_classname = dw_dwlist.getitemstring(ll_row, 'classname')
	if isnull(ls_classname) then ls_classname = ''
	lnv_retval.of_put('classname', ls_classname)
	
	ls_comment = dw_dwlist.getitemstring(ll_row, 'comment')
	if isnull(ls_comment) then ls_comment = ''
	lnv_retval.of_put('comment', ls_comment)
	
	closewithreturn(parent, lnv_retval)
end if

end event

type r_1 from rectangle within pf_w_datawindow_search
long linecolor = 30527953
integer linethickness = 4
long fillcolor = 32501743
integer x = 50
integer y = 24
integer width = 2409
integer height = 104
end type

