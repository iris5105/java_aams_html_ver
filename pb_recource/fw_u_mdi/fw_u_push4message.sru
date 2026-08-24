forward
global type fw_u_push4message from u_ancestor
end type
type uo_1 from fw_u_dw2title within fw_u_push4message
end type
type r_1 from rectangle within fw_u_push4message
end type
type p_chart from pf_u_imagebutton within fw_u_push4message
end type
type dw_push from fw_u_dwo within fw_u_push4message
end type
end forward

global type fw_u_push4message from u_ancestor
integer width = 1851
integer height = 1016
long backcolor = 16777215
borderstyle borderstyle = styleraised!
boolean setsheetcolor = true
event losefocus pbm_killfocus
uo_1 uo_1
r_1 r_1
p_chart p_chart
dw_push dw_push
end type
global fw_u_push4message fw_u_push4message

type variables
long	il_orgwidth	= 0
end variables

forward prototypes
public function string of_thisname ()
public function integer of_retrieve ()
public subroutine uf_make_log (string as_rowid)
end prototypes

public function string of_thisname ();return 'fw_u_push4message'
end function

public function integer of_retrieve ();//<임시> 고객사인 경우 사용자회사의 공지와 전체공지만 알림
// 허브리트인 경우 전체, 회사공지, 오류내역 알림
Long	ll_cnt
ll_cnt = dw_push.retrieve(gnv_vari.is_sys_id, iif (gaa.aams, '2200', gaa.corp_gr), gnv_vari.is_user_id)
If ll_cnt < 1 Then this.visible = false
Return ll_cnt

end function

public subroutine uf_make_log (string as_rowid);LONG	ll_docu_no, ll_read_seq

STRING	ls_board_no, ls_content, ls_corp_gr, ls_save_corp

datetime ldtm_now

SELECT  corp_gr
      , board_no
		, docu_no
      , docu_content
  INTO  :ls_corp_gr
      , :ls_board_no
		, :ll_docu_no
      , :ls_content
FROM    fw_docu_mst t1
WHERE   sys_id || corp_gr || board_no || TO_CHAR(docu_no) = :as_rowid;

IF SQLCA.sqlcode ()=0   Then
	ls_corp_gr = SQLCA.getitemstring(1)
	ls_board_no = SQLCA.getitemstring(2)
	ll_docu_no = SQLCA.getitemnumber(3)
	ls_content = SQLCA.getitemstring(4)
	IF	gaa.aams	Then
		ls_save_corp = '2200'
	ElseIF ls_board_no = '0000001' Then
		ls_save_corp = gaa.corp_gr
	Else
		ls_save_corp = ls_corp_gr
	End IF
	
	SELECT  max(read_seq)
	  INTO  :ll_read_seq
	FROM    fw_docu_log t1
	WHERE   sys_id   = :gnv_vari.is_sys_id
	  AND   corp_gr  LIKE :ls_save_corp
	  AND   board_no = :ls_board_no
	  AND   docu_no  = :ll_docu_no;

	ll_read_seq = SQLCA.getitemnumber (1)
	IF isnull(ll_read_seq) THEN ll_read_seq = 0
	ll_read_seq += 1

	ldtm_now = fw_f_getymdhh24miss4d()

	INSERT INTO  fw_docu_log (
						corp_gr                          /* _1: */
					 , sys_id                           /* _2: */
					 , board_no                         /* _3: */
					 , docu_no                          /* _4: */
					 , read_seq                         /* _5: */
					 , read_user                        /* _6: */
					 , read_dtm )                       /* _7: */
	VALUES ( :ls_save_corp                              /* _1: */
			 , :gnv_vari.is_sys_id                        /* _2: */
			 , :ls_board_no                               /* _3: */
			 , :ll_docu_no                                /* _4: */
			 , :ll_read_seq                               /* _5: */
			 , :gnv_vari.is_user_id                       /* _6: */
			 , :ldtm_now                                  /* _7: */
			 );
	IF SQLCA.sqlcode ()=0   Then
		commitJ ()
	else
		messagebox('Notice', '게시글 로그 생성 오류~r~n' + SQLCA.sqlerrtext ())
		rollbackJ ()
		RETURN
	End IF
End IF
end subroutine

on fw_u_push4message.create
int iCurrent
call super::create
this.uo_1=create uo_1
this.r_1=create r_1
this.p_chart=create p_chart
this.dw_push=create dw_push
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.r_1
this.Control[iCurrent+3]=this.p_chart
this.Control[iCurrent+4]=this.dw_push
end on

on fw_u_push4message.destroy
call super::destroy
destroy(this.uo_1)
destroy(this.r_1)
destroy(this.p_chart)
destroy(this.dw_push)
end on

event oue_postopen;call super::oue_postopen;this.visible = false
fw_f_setdddw (dw_push, 'board_no', {gnv_vari.is_sys_id, gaa.corp_gr})
end event

type uo_1 from fw_u_dw2title within fw_u_push4message
integer x = 14
integer y = 20
integer taborder = 40
string istitletext = "전달사항 알람"
end type

on uo_1.destroy
call fw_u_dw2title::destroy
end on

type r_1 from rectangle within fw_u_push4message
long linecolor = 8388608
integer linethickness = 6
long fillcolor = 33225466
integer width = 1851
integer height = 1008
end type

type p_chart from pf_u_imagebutton within fw_u_push4message
integer x = 1605
integer y = 12
integer width = 229
integer height = 96
integer taborder = 20
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;parent.visible = false
gw_mdi.of_set_message (FALSE)
end event

type dw_push from fw_u_dwo within fw_u_push4message
integer x = 18
integer y = 116
integer width = 1815
integer height = 876
integer taborder = 10
string dataobject = "fw_d_push4message"
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4tabudesign = true
string setlist4rowpointcolor = "board_no=0000001=a;board_no=0000002=b;board_no=0000011=c"
end type

event doubleclicked;call super::doubleclicked;if row < 1 then return
string	ls_rowid

ls_rowid = dw_push.getitemstring(row, 'row_id')
IF dw_push.getitemstring(row, 'board_no')='0000003'	Then
	uf_make_log (ls_rowid)
	deleterow (row)
	RETURN
End IF

openwithparm(fw_w_notice_view, ls_rowid + '~tY')

Post of_retrieve()
end event

event losefocus;call super::losefocus;p_chart.event clicked()
end event

event retrieveend;call super::retrieveend;post setfocus()
end event

