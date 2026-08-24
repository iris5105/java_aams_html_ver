forward
global type u_home5_dimension from u_ancestor
end type
type dw_dimension from u_dw within u_home5_dimension
end type
type p_1 from picture within u_home5_dimension
end type
type st_1 from statictext within u_home5_dimension
end type
type st_2 from statictext within u_home5_dimension
end type
type p_reset from pf_u_imagebutton within u_home5_dimension
end type
type p_add from pf_u_imagebutton within u_home5_dimension
end type
type p_prevpage from pf_u_imagebutton within u_home5_dimension
end type
type p_nextpage from pf_u_imagebutton within u_home5_dimension
end type
end forward

global type u_home5_dimension from u_ancestor
integer width = 2921
integer height = 1188
long backcolor = 553648127
event ue_dbtn_click ( string as_btn_nm )
dw_dimension dw_dimension
p_1 p_1
st_1 st_1
st_2 st_2
p_reset p_reset
p_add p_add
p_prevpage p_prevpage
p_nextpage p_nextpage
end type
global u_home5_dimension u_home5_dimension

type variables
u_dimension_btn	uoa_dimension_btn []
STRING	is_user_id

//동적생성 조절변수
LONG	il_max_col  = 13		//최대 열개수
LONG  il_max_row  = 1		//최대 행개수

//동적생성 좌표변수
LONG	il_x          = 0 	   // 시작 x좌표
LONG  il_y          = 110 		// 시작 y좌표
LONG  il_x_interval = 75	 	// 버튼별 x 간격
LONG  il_y_interval = 50	 	// 버튼별 y 간격
LONG  il_btn_width  = 440	 	// 버튼 길이
LONG  il_btn_height = 530	 	// 버튼 높이

STRING	is_empty_text = ''

//시스템 변수
LONG  	il_cur_line   = 1			// 현재라인 확인용
LONG  	il_dimension_cnt			// 버튼 개수 확인용

BOOLEAN	ib_start = FALSE        // 프로그램 시작 시 설정된 디멘젼 시작
LONG		il_start = -1
LONG		il_user_max_open = 7    // 유저디멘젼의 경우 디멘젼당 최대 오픈 수
end variables

forward prototypes
public subroutine uf_dimension_create ()
public subroutine uf_dimension ()
end prototypes

event ue_dbtn_click(string as_btn_nm);CHOOSE CASE as_btn_nm
	CASE 'p_add'
		gnv_rolemenu.of_setopensheet ('00008')
	CASE 'p_reset'
		//삭제후 재생성
		parent.dynamic uf_set_dimension ()
	CASE 'p_prevpage'
		setredraw (FALSE)
		il_cur_line = il_cur_line - 1
		uf_dimension_create ()
		setredraw (TRUE)
	CASE 'p_nextpage'
		setredraw (FALSE)
		il_cur_line += 1
		uf_dimension_create ()
		setredraw (TRUE)
END CHOOSE
end event

public subroutine uf_dimension_create ();LONG	ll, ll_cnt, ll_start

u_dimension_btn	uo_btn

STRING lstemp=''
//삭제후 재생성
FOR  ll = 1  TO  upperbound (uoa_dimension_btn)
	uo_btn = CREATE u_dimension_btn
	uo_btn.is_title = uoa_dimension_btn [ll].is_title
	lstemp += uoa_dimension_btn [ll].is_title + '~r~n'
	uo_btn.ia_pgm_list = uoa_dimension_btn [ll].ia_pgm_list
	uo_btn.is_corp_gr = uoa_dimension_btn [ll].is_corp_gr
	uo_btn.st_1.textcolor = uoa_dimension_btn [ll].st_1.textcolor
	uo_btn.p_1.picturename = uoa_dimension_btn [ll].p_1.picturename
	CloseUserObject (uoa_dimension_btn [ll]) // closeuserobject 사용 시 완전하게 초기화 되기 때문에 재생성
	uoa_dimension_btn [ll] = uo_btn
NEXT

//생성
ll_start = (il_cur_line - 1) * il_max_col * il_max_row + 1
FOR  ll = ll_start TO il_dimension_cnt
	uo_btn = uoa_dimension_btn [ll]
	ll_cnt = ll - ll_start
	
	IF ll_cnt < il_max_col * il_max_row Then
		//가로로생성
		//OpenUserObject (uo_btn, il_x + (MOD(ll_cnt, il_max_col)) * (il_btn_width + il_x_interval), il_y + (truncate(ll_cnt / il_max_col, 0)) * (il_btn_height + il_y_interval))
		//세로로생성
		OpenUserObject (uo_btn, il_x + (truncate (ll_cnt / il_max_row, 0)) * (il_btn_width + il_x_interval), il_y + (MOD (ll_cnt , il_max_row)) * (il_btn_height + il_y_interval))
		uo_btn.resize (il_btn_width, il_btn_height)
	End IF
	
	uo_btn.uf_init (iif (upperbound (uo_btn.ia_pgm_list)=0, FALSE, TRUE))
NEXT

IF il_cur_line<=1 THEN p_prevpage.visible = FALSE ELSE p_prevpage.visible = TRUE
IF il_cur_line * il_max_col * il_max_row >= il_dimension_cnt THEN p_nextpage.visible = FALSE ELSE p_nextpage.visible = TRUE
st_2.TEXT = 'page (' + string (il_cur_line) + '/' + string(max(truncate (il_dimension_cnt / (il_max_col * il_max_row),0) + iif (MOD (il_dimension_cnt, il_max_col * il_max_row)=0, 0, 1), 1)) + ')'

IF NOT ib_start Then
	ib_start = TRUE
	IF il_start>0 THEN uoa_dimension_btn [il_start].event ue_click_event()
End IF
end subroutine

public subroutine uf_dimension ();// 즐겨찾기 버튼 동적생성
u_dimension_btn	luoa_dimension_btn [], uo_btn

ads_jTier	lds_fullmenu

LONG	ll, lm

STRING	ls_corp_gr

// 데이터 저장 후 필터링되어 필터삭제필요
gnv_rolemenu.ids_fullmenudata.setfilter("")
gnv_rolemenu.ids_fullmenudata.filter()
lds_fullmenu = gnv_rolemenu.ids_fullmenudata

is_user_id = gaa.login
IF gaa.aams Then
	ls_corp_gr = '2200'
Else
	ls_corp_gr = gaa.corp_gr
End IF

// 삭제후 재생성
FOR  ll = 1  TO  upperbound (uoa_dimension_btn)
	CloseUserObject (uoa_dimension_btn [ll])
NEXT

dw_dimension.uf_reset ()
dw_dimension.retrieve (ls_corp_gr, 'SY', '%')

// 전체즐겨찾기
FOR  ll = 1  TO  dw_dimension.rowcount()
	IF dw_dimension.object.pgm_kind_code [ll]<>'M' THEN CONTINUE
	IF dw_dimension.object.use_yn [ll]='N'         THEN CONTINUE
	uo_btn = CREATE u_dimension_btn
	uo_btn.is_title = dw_dimension.object.favor_nm [ll]
	uo_btn.is_all = TRUE
	uo_btn.st_1.textcolor = rgb (45, 55, 85)
	uo_btn.p_1.pictureName = dw_dimension.object.icon_path [ll]
	FOR  lm = 1  TO  dw_dimension.rowcount()
		IF dw_dimension.object.parent_pgm [lm] = dw_dimension.object.pgm_no [ll] Then
			
			//권한체크 후 권한이 없으면 추가안함
			IF lds_fullmenu.FIND ("pgm_no='"+string (dw_dimension.object.pgm_no [lm])+"'", 1, lds_fullmenu.rowcount())>0 Then
				uo_btn.ia_pgm_list [upperbound (uo_btn.ia_pgm_list) + 1] = dw_dimension.object.pgm_no [lm]
			End IF
		End IF
	NEXT
	
	//실행할 메뉴가 없으면 추가안함
	IF upperbound (uo_btn.ia_pgm_list)>0 THEN	luoa_dimension_btn [upperbound (luoa_dimension_btn) + 1] = uo_btn
NEXT

dw_dimension.uf_reset ()
dw_dimension.retrieve (ls_corp_gr, 'SY', ls_corp_gr)

// 회사즐겨찾기
FOR  ll = 1  TO  dw_dimension.rowcount()
	IF dw_dimension.object.pgm_kind_code [ll] <>'M' THEN CONTINUE
	uo_btn = CREATE u_dimension_btn
	uo_btn.is_title = dw_dimension.object.favor_nm [ll]
	uo_btn.is_corp_gr = TRUE
	uo_btn.st_1.textcolor = rgb (96, 124, 160)
	uo_btn.p_1.pictureName = dw_dimension.object.icon_path [ll]
	FOR  lm = 1  TO  dw_dimension.rowcount()
		IF dw_dimension.object.parent_pgm [lm] = dw_dimension.object.pgm_no [ll] Then
			
			//권한체크 후 권한이 없으면 추가안함
			IF lds_fullmenu.FIND ("pgm_no='"+string (dw_dimension.object.pgm_no [lm])+"'", 1, lds_fullmenu.rowcount())>0 Then
				uo_btn.ia_pgm_list [upperbound (uo_btn.ia_pgm_list) + 1] = dw_dimension.object.pgm_no [lm]
			End IF
		End IF
	NEXT
	
	//실행할 메뉴가 없으면 추가안함
	IF upperbound (uo_btn.ia_pgm_list)>0 THEN	luoa_dimension_btn [upperbound (luoa_dimension_btn) + 1] = uo_btn
NEXT

dw_dimension.uf_reset ()
dw_dimension.retrieve (ls_corp_gr, 'SY', gaa.login)
// 개인즐겨찾기
FOR  ll = 1  TO  dw_dimension.rowcount()
	IF dw_dimension.object.pgm_kind_code [ll] <>'M' THEN CONTINUE
	uo_btn = CREATE u_dimension_btn
	uo_btn.is_title = dw_dimension.object.favor_nm [ll]
	uo_btn.st_1.textcolor = rgb (119, 168, 185)
	uo_btn.p_1.pictureName = dw_dimension.object.icon_path [ll]
	FOR  lm = 1  TO  dw_dimension.rowcount()
		IF dw_dimension.object.parent_pgm [lm] = dw_dimension.object.pgm_no [ll] Then
			
			//권한체크 후 권한이 없으면 추가안함
			IF lds_fullmenu.FIND ("pgm_no='"+dw_dimension.object.pgm_no [lm]+"'", 1, lds_fullmenu.rowcount())>0 Then
				uo_btn.ia_pgm_list [upperbound (uo_btn.ia_pgm_list) + 1] = dw_dimension.object.pgm_no [lm]
				IF upperbound (uo_btn.ia_pgm_list)>=il_user_max_open THEN EXIT
			End IF
		End IF
	NEXT
	
	//실행할 메뉴가 없으면 추가안함
	IF upperbound (uo_btn.ia_pgm_list)>0 Then
		luoa_dimension_btn [upperbound (luoa_dimension_btn) + 1] = uo_btn
		IF dw_dimension.object.sopen [ll]='Y' THEN il_start = upperbound (luoa_dimension_btn)
	End IF
NEXT

lm = upperbound (luoa_dimension_btn)
FOR  ll = lm + 1  TO  lm + (il_max_col * il_max_row - MOD (lm, il_max_col * il_max_row))
	uo_btn = CREATE u_dimension_btn
	uo_btn.is_title = is_empty_text
	uo_btn.st_1.textcolor = rgb (119, 168, 185)
	
	luoa_dimension_btn [upperbound (luoa_dimension_btn) + 1] = uo_btn
NEXT

il_dimension_cnt = upperbound (luoa_dimension_btn)
uoa_dimension_btn = luoa_dimension_btn
uf_dimension_create ()
end subroutine

on u_home5_dimension.create
int iCurrent
call super::create
this.dw_dimension=create dw_dimension
this.p_1=create p_1
this.st_1=create st_1
this.st_2=create st_2
this.p_reset=create p_reset
this.p_add=create p_add
this.p_prevpage=create p_prevpage
this.p_nextpage=create p_nextpage
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dimension
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.p_reset
this.Control[iCurrent+6]=this.p_add
this.Control[iCurrent+7]=this.p_prevpage
this.Control[iCurrent+8]=this.p_nextpage
end on

on u_home5_dimension.destroy
call super::destroy
destroy(this.dw_dimension)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.p_reset)
destroy(this.p_add)
destroy(this.p_prevpage)
destroy(this.p_nextpage)
end on

event resize;call super::resize;p_nextpage.x = il_x + il_btn_width * il_max_col + il_max_col * il_x_interval
p_prevpage.x = p_nextpage.x
p_nextpage.y = il_y + il_y_interval
p_prevpage.y = p_nextpage.y + p_nextpage.height + il_y_interval
end event

type dw_dimension from u_dw within u_home5_dimension
boolean visible = false
integer x = 18
integer y = 112
integer width = 325
integer height = 236
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_dimension"
boolean ibdesign4role = false
boolean applydesign = false
boolean useborder = false
end type

type p_1 from picture within u_home5_dimension
boolean visible = false
integer x = 119
integer y = 12
integer width = 14
integer height = 56
boolean bringtotop = true
string picturename = "..\img\controls\u_button4chart\icon4chart.jpg"
boolean focusrectangle = false
end type

type st_1 from statictext within u_home5_dimension
boolean visible = false
integer x = 142
integer width = 827
integer height = 84
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 553648127
boolean enabled = false
boolean focusrectangle = false
end type

type st_2 from statictext within u_home5_dimension
boolean visible = false
integer x = 800
integer y = 8
integer width = 338
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 553648127
boolean enabled = false
boolean focusrectangle = false
end type

type p_reset from pf_u_imagebutton within u_home5_dimension
boolean visible = false
integer x = 1486
integer y = 4
integer width = 110
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\iconbtn_reset2.jpg"
end type

event clicked;call super::clicked;event ue_dbtn_click('p_reset')
//parent.dynamic event uf_set_dimension()
//gw_mdi.iw_home.dynamic uf_set_dimension ()
end event

type p_add from pf_u_imagebutton within u_home5_dimension
boolean visible = false
integer x = 1371
integer y = 4
integer width = 110
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\btn_plus.jpg"
end type

event clicked;call super::clicked;event ue_dbtn_click('p_add')
end event

type p_prevpage from pf_u_imagebutton within u_home5_dimension
boolean visible = false
integer x = 1143
integer y = 4
integer width = 110
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\btn_left.jpg"
end type

event clicked;call super::clicked;event ue_dbtn_click('p_prevpage')
end event

type p_nextpage from pf_u_imagebutton within u_home5_dimension
boolean visible = false
integer x = 1257
integer y = 4
integer width = 110
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\btn_right.jpg"
end type

event clicked;call super::clicked;event ue_dbtn_click('p_nextpage')
end event

