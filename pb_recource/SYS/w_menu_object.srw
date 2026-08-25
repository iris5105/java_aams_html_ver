forward
global type w_menu_object from w_response1st
end type
type dw_1 from fw_u_dwo within w_menu_object
end type
type st_1 from pf_u_statictext within w_menu_object
end type
type cb_close from pf_u_commandbutton within w_menu_object
end type
type cb_ok from pf_u_commandbutton within w_menu_object
end type
type cb_open from pf_u_commandbutton within w_menu_object
end type
end forward

global type w_menu_object from w_response1st
integer x = 407
integer y = 452
integer width = 2720
integer height = 1692
string title = "Library별 Object 가져오기"
long backcolor = 16777215
string icon = "LibraryList5!"
boolean center = true
dw_1 dw_1
st_1 st_1
cb_close cb_close
cb_ok cb_ok
cb_open cb_open
end type
global w_menu_object w_menu_object

type variables
datawindow	dw_insert
end variables

on w_menu_object.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.cb_open=create cb_open
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_open
end on

on w_menu_object.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.cb_open)
end on

event open;call super::open;dw_insert = Message.PowerObjectParm

// 무조건 찾고자하는 pbl을 오픈한다.
cb_Open.PostEvent (clicked!)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_menu_object
end type

type ln_tempstart from w_response1st`ln_tempstart within w_menu_object
end type

type ln_templeft from w_response1st`ln_templeft within w_menu_object
end type

type ln_cond_start from w_response1st`ln_cond_start within w_menu_object
end type

type ln_tempright from w_response1st`ln_tempright within w_menu_object
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_menu_object
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_menu_object
end type

type dw_1 from fw_u_dwo within w_menu_object
integer x = 50
integer y = 128
integer width = 2578
integer height = 1364
integer taborder = 50
string dataobject = "d_ex_library_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
end type

event constructor;call super::constructor;Modify ("datawindow.selected.mouse=no datawindow.grid.columnmove=no")
end event

event doubleclicked;call super::doubleclicked;cb_ok.POST EVENT clicked ()
end event

type st_1 from pf_u_statictext within w_menu_object
integer x = 55
integer y = 1508
integer width = 2217
integer height = 64
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
boolean enabled = false
string text = "★ 입력하기를 원하는 오브젝트를 위의 목록중에 선택하시고 작업확인버튼을 눌러주십시오."
end type

type cb_close from pf_u_commandbutton within w_menu_object
integer x = 2309
integer y = 24
integer width = 315
integer taborder = 10
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "작업취소"
end type

event clicked;CLOSE (Parent)
end event

type cb_ok from pf_u_commandbutton within w_menu_object
integer x = 1984
integer y = 24
integer width = 315
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "작업확인"
end type

event clicked;LONG  ll

STRING   ls_pgm, ls_pgm_nm, ls_parent_pgm

ll = dw_1.GetSelectedRow (0)
DO WHILE ll>0
	dw_insert.SetItemStatus (1, 0, Primary!, New!)

	ls_pgm = UPPER (dw_1.object.name [ll])

	SELECT  parent_pgm
	  INTO  :ls_parent_pgm
	FROM    fw_pgm_mst t1
	WHERE   pgm_id = :ls_pgm;
	IF SQLCA.SQLCode ()=0   Then
		ls_parent_pgm = SQLCA.getitemstring (1)
	
		SELECT  pgm_nm
		  INTO  :ls_pgm_nm
		FROM    fw_pgm_mst l1
		WHERE   pgm_no = :ls_parent_pgm;

		IF SQLCA.SQLCode ()=0	Then
			ls_pgm_nm = SQLCA.getitemstring (1)
			IF f_messageBox ('P001', '(' + ls_pgm_nm + ')에 등록한 프로그램입니다.~r~n추가로 등록 하시겠습니까?')=2 THEN EXIT
		End IF
	End IF
	dw_insert.object.pgm_id [1] = ls_pgm
	dw_insert.object.pgm_nm [1] = dw_1.object.comment [ll]
	dw_insert.object.sort_order [1] = 99
	dw_insert.update ()
	commitJ ()

	dw_1.selectrow (ll, FALSE)
	ll = dw_1.GetSelectedRow (ll)
LOOP

CLOSE (Parent)
end event

type cb_open from pf_u_commandbutton within w_menu_object
integer x = 59
integer y = 24
integer width = 370
integer taborder = 30
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "PBL 열기"
end type

event clicked;STRING	ls_DirName, ls_FileName

INT   li_Return

li_Return = GetFileOpenName ("Select Library File", ls_FileName, ls_DirName, "pbl", "Library files (*.pbl), *.pbl,JA files (JA*.pbl), JA*.pbl,all files(*.*), *.*", gaa.pbr + 'kernel', 2)
IF li_Return=1 THEN
   Parent.Title = ls_DirName

   STRING	ls_Library, ls_Type

   LibDirType ObjectType

   // USerObject & Window정보를 읽어온다.
   ls_library = LibraryDirectory (ls_FileName, dirUserObject!)
   ls_library = ls_Library + LibraryDirectory (ls_FileName, dirWindow!)
   IF f_null (ls_Library)  Then
      MessageBox ('Library Open Error', TEXT, StopSign!)
      RETURN
   Else
      dw_1.Reset ()
      dw_1.ImportString (ls_Library)
      dw_1.Sort ()
      dw_1.GroupCalc ()
   End IF
End IF
end event

