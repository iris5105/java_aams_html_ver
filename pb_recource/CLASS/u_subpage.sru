forward
global type u_subpage from u_ancestor
end type
type ln_temptop from line within u_subpage
end type
type ln_tempstart from line within u_subpage
end type
type ln_templeft from line within u_subpage
end type
type ln_cond_start from line within u_subpage
end type
type ln_tempright from line within u_subpage
end type
type ln_cond1_yline from line within u_subpage
end type
type ln_dw1_yline from line within u_subpage
end type
type ln_tempbutton from line within u_subpage
end type
end forward

global type u_subpage from u_ancestor
integer width = 3625
integer height = 2856
long backcolor = 16777215
string text = "Tab page"
string picturename = "Custom009!"
long picturemaskcolor = 553648127
event wue_input ( )
event wue_copy ( )
event wue_delete ( )
event ue_subpage_reset ( )
event type integer ue_subpage_selected ( )
event type integer ue_subpage_update ( )
event type integer ue_subpage_updatequery ( )
event ue_subpage_reset_flag ( )
event ue_subpage_copyall ( )
event ue_subpage_deleteall ( )
event ue_subpage_doubleclicked ( )
event ue_subpage_initall ( string name,  string data )
event type boolean ue_subpage_modified ( )
event wue_saveas ( )
event wue_print ( )
event ue_dddw_retrieve ( )
event ue_activate ( )
event ue_subpage_open ( )
event ue_parent_event ( )
event type boolean ue_subpage_updatetable ( )
ln_temptop ln_temptop
ln_tempstart ln_tempstart
ln_templeft ln_templeft
ln_cond_start ln_cond_start
ln_tempright ln_tempright
ln_cond1_yline ln_cond1_yline
ln_dw1_yline ln_dw1_yline
ln_tempbutton ln_tempbutton
end type
global u_subpage u_subpage

type variables
BOOLEAN  tb_rowchangewait = FALSE

w_winpage   iu_wpage

LONG	tRow

STRING   ts_find  // 조회시 Column 위치 재설정용 Find 문 (retrieveend에서 사용하므로 조회조건 초기값을 주어야 함)

Protected:
	BOOLEAN  tbTabpageSelected = TRUE
end variables

forward prototypes
public subroutine wf_setenabled ()
public function integer uf_updatenocommit (u_dw adw_1, u_dw adw_2)
end prototypes

event ue_subpage_reset();/* 1.데이타윈도우 자료를 초기화 시킨다.(초기자료로 재 조회 않함)
	2.subPage 재 조회 flag는 ue_subpage_reset_flag로 이동
*/
tbTabpageSelected = TRUE
end event

event type integer ue_subpage_selected();/*	1. 선택된적이 있다면 자료 조회없이 통과
	2. 처음으로 선택되었다면
		subPage안 데이타윈도우 자료를 조회하기 위하여 사용한다.
	3. ue_subpage_reset에서 tbTabpageSelected 값을 변경한다.

	RETURN : 자료의조회(1), 자료를 조회하지않음(0)
*/
IF	NOT isValid (iu_wpage) THEN RETURN 0	// open 전이므로 return
iu_wpage.dynamic EVENT ue_condchanged ()
IF	tbTabpageSelected	Then	// 선택된적이 있다. 자료 재조회가 필요없다.
	RETURN 0
Else								// 처음 선택되었다. 자료 재조회가 필요하다.
	tbTabpageSelected = TRUE
	RETURN 1
End IF
end event

event type integer ue_subpage_update();/*	subpage 내에 변경된 데이타윈도우 혹은 페이지 자료를 저장한다. 
   RETURN Value 
		 1 : 자료저장에 성공하였다.
	 	-1 : 자료저장에 실패하였다.
*/
RETURN 0
end event

event type integer ue_subpage_updatequery();RETURN iu_wpage.DYNAMIC EVENT wue_confirmupdate4close ()
end event

event ue_subpage_reset_flag();// subPage안 데이타윈도우 자료를 재 조회하기 위하여 사용
tbTabpageSelected = FALSE
end event

event type boolean ue_subpage_modified();/* subpage 내에 변경된 데이타윈도우 혹은 페이지가 있는지를 확인
		TRUE  : 자료가 변경된 데이타윈도우 혹은 페이지가 있다.
		FALSE : 자료가 변경된 데이타윈도우 혹은 페이지가 없다.
*/
RETURN iu_wpage.ib_manageData
end event

event wue_print();fw_s_parent	lstr_parent

lstr_parent.w_obj	= iw_parent
lstr_parent.dw_obj = idw_target

OpenWithParm(fw_w_dw2preview, lstr_parent)
end event

event ue_subpage_open();iu_wpage = parent.GetParent ()
end event

event type boolean ue_subpage_updatetable();/* subpage 내에 변경된 데이타윈도우 혹은 페이지가 있는지를 확인
		TRUE  : 자료가 변경된 데이타윈도우 혹은 페이지가 있다.
		FALSE : 자료가 변경된 데이타윈도우 혹은 페이지가 없다.
*/
RETURN iu_wpage.ib_manageData
end event

public subroutine wf_setenabled ();
end subroutine

public function integer uf_updatenocommit (u_dw adw_1, u_dw adw_2);IF	adw_1.uf_update ()=false THEN RETURN -1
IF	adw_2.uf_update ()=false THEN RETURN -1
RETURN 1
end function

on u_subpage.create
int iCurrent
call super::create
this.ln_temptop=create ln_temptop
this.ln_tempstart=create ln_tempstart
this.ln_templeft=create ln_templeft
this.ln_cond_start=create ln_cond_start
this.ln_tempright=create ln_tempright
this.ln_cond1_yline=create ln_cond1_yline
this.ln_dw1_yline=create ln_dw1_yline
this.ln_tempbutton=create ln_tempbutton
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ln_temptop
this.Control[iCurrent+2]=this.ln_tempstart
this.Control[iCurrent+3]=this.ln_templeft
this.Control[iCurrent+4]=this.ln_cond_start
this.Control[iCurrent+5]=this.ln_tempright
this.Control[iCurrent+6]=this.ln_cond1_yline
this.Control[iCurrent+7]=this.ln_dw1_yline
this.Control[iCurrent+8]=this.ln_tempbutton
end on

on u_subpage.destroy
call super::destroy
destroy(this.ln_temptop)
destroy(this.ln_tempstart)
destroy(this.ln_templeft)
destroy(this.ln_cond_start)
destroy(this.ln_tempright)
destroy(this.ln_cond1_yline)
destroy(this.ln_dw1_yline)
destroy(this.ln_tempbutton)
end on

type ln_temptop from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 24
integer endx = 4722
integer endy = 24
end type

type ln_tempstart from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 128
integer endx = 4722
integer endy = 128
end type

type ln_templeft from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 18
integer endx = 18
integer endy = 3140
end type

type ln_cond_start from line within u_subpage
boolean visible = false
long linecolor = 255
integer linethickness = 4
integer beginy = 156
integer endx = 4722
integer endy = 156
end type

type ln_tempright from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 2
integer beginx = 3602
integer endx = 3602
integer endy = 3140
end type

type ln_cond1_yline from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 316
integer endx = 4873
integer endy = 316
end type

type ln_dw1_yline from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 348
integer endx = 4873
integer endy = 348
end type

type ln_tempbutton from line within u_subpage
boolean visible = false
long linecolor = 134217857
integer linethickness = 4
integer beginy = 2836
integer endx = 4722
integer endy = 2836
end type

