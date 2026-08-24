forward
global type fw_w_pgm_help_ent from w_response1st
end type
type st_6 from pf_u_statictext within fw_w_pgm_help_ent
end type
type st_5 from pf_u_statictext within fw_w_pgm_help_ent
end type
type p_update from pf_u_imagebutton within fw_w_pgm_help_ent
end type
type p_close from pf_u_imagebutton within fw_w_pgm_help_ent
end type
type dw_mast from fw_u_dwo within fw_w_pgm_help_ent
end type
type rte_content from pf_u_richtextedit within fw_w_pgm_help_ent
end type
type st_3 from pf_u_statictext within fw_w_pgm_help_ent
end type
type st_2 from pf_u_statictext within fw_w_pgm_help_ent
end type
type st_1 from pf_u_statictext within fw_w_pgm_help_ent
end type
type st_4 from pf_u_statictext within fw_w_pgm_help_ent
end type
type p_1 from pf_u_picture within fw_w_pgm_help_ent
end type
type p_addedit from pf_u_imagebutton within fw_w_pgm_help_ent
end type
type rr_border from pf_u_roundrectangle within fw_w_pgm_help_ent
end type
type dw_list from fw_u_dwo within fw_w_pgm_help_ent
end type
end forward

global type fw_w_pgm_help_ent from w_response1st
integer width = 4489
integer height = 2796
string title = "프로그램 도움말 등록"
st_6 st_6
st_5 st_5
p_update p_update
p_close p_close
dw_mast dw_mast
rte_content rte_content
st_3 st_3
st_2 st_2
st_1 st_1
st_4 st_4
p_1 p_1
p_addedit p_addedit
rr_border rr_border
dw_list dw_list
end type
global fw_w_pgm_help_ent fw_w_pgm_help_ent

type variables
BLOB	ib_content
N_MENU	inv_argmenu
BOOLEAN	ib_head_enter
LONG	il_lastpos, il_head_type
end variables

forward prototypes
public function string uf_text_to_richtext (string as_text)
end prototypes

public function string uf_text_to_richtext (string as_text);STRING	ls_temp

LONG	ll_start, ll_end

rte_content.SelectTextAll()
rte_content.Cut()
::CLIPBOARD (as_text)
rte_content.paste()
rte_content.SelectTextAll()
ls_temp = string (blob (rte_content.copyrtf(FALSE)))
ll_start = LASTPOS (ls_temp, 'nowidctlpar\plain\f1\fs20\loch\f1\hich\f1') + LEN ('nowidctlpar\plain\f1\fs20\loch\f1\hich\f1')
IF ll_start = 41 THEN ll_start = LASTPOS (ls_temp, 'nowidctlpar\plain\f1\fs20 ') + LEN ('nowidctlpar\plain\f1\fs20 ')
ll_end = LASTPOS (ls_temp, '}')
ls_temp = MID (ls_temp, ll_start, ll_end - ll_start)

RETURN ls_temp
end function

on fw_w_pgm_help_ent.create
int iCurrent
call super::create
this.st_6=create st_6
this.st_5=create st_5
this.p_update=create p_update
this.p_close=create p_close
this.dw_mast=create dw_mast
this.rte_content=create rte_content
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.st_4=create st_4
this.p_1=create p_1
this.p_addedit=create p_addedit
this.rr_border=create rr_border
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.p_update
this.Control[iCurrent+4]=this.p_close
this.Control[iCurrent+5]=this.dw_mast
this.Control[iCurrent+6]=this.rte_content
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.p_1
this.Control[iCurrent+12]=this.p_addedit
this.Control[iCurrent+13]=this.rr_border
this.Control[iCurrent+14]=this.dw_list
end on

on fw_w_pgm_help_ent.destroy
call super::destroy
destroy(this.st_6)
destroy(this.st_5)
destroy(this.p_update)
destroy(this.p_close)
destroy(this.dw_mast)
destroy(this.rte_content)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.p_addedit)
destroy(this.rr_border)
destroy(this.dw_list)
end on

event wue_postopen;call super::wue_postopen;IF not isvalid(message.powerobjectparm) Then
   messagebox('Notice', '잘못된 윈도우 호출입니다')
   CLOSE(THIS)
   RETURN
End IF

IF message.powerobjectparm.classname()<>'n_menu'   Then
   messagebox('Notice', '잘못된 윈도우 호출입니다')
   CLOSE(THIS)
   RETURN
End IF

inv_argmenu = message.powerobjectparm

dw_mast.insertrow (0)
dw_mast.setitem(1, 'pgm_no', inv_argmenu.is_pgm_no)
dw_mast.setitem(1, 'pgm_id', inv_argmenu.is_pgm_id)
dw_mast.setitem(1, 'pgm_nm', inv_argmenu.is_pgm_nm)

dw_list.settransobject(SQLCA)
dw_list.retrieve (gnv_vari.is_sys_id, inv_argmenu.is_pgm_no)

IF gaa.aams Then
	p_addedit.of_setenabled (TRUE)
	p_update.of_setenabled (TRUE)
End IF
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_pgm_help_ent
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_pgm_help_ent
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_pgm_help_ent
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_pgm_help_ent
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_pgm_help_ent
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_pgm_help_ent
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_pgm_help_ent
end type

type st_6 from pf_u_statictext within fw_w_pgm_help_ent
integer x = 1504
integer y = 1608
integer width = 2597
integer height = 108
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 268435456
string text = "~'내용 편집하기~' 버튼을 클릭해서 프로그램 도움말을 관리하세요"
end type

type st_5 from pf_u_statictext within fw_w_pgm_help_ent
integer x = 1504
integer y = 1244
integer width = 2597
integer height = 172
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 268435456
string text = "기타 참고할 사항등을 보관하는 "
end type

type p_update from pf_u_imagebutton within fw_w_pgm_help_ent
integer x = 3977
integer y = 28
integer width = 229
integer height = 96
boolean enabled = false
string picturename = "..\img\controls\u_imagebutton\btn_save.jpg"
end type

event clicked;call super::clicked;STRING	ls_pgmno, ls_errtext, ls_blob_err

LONG	ll_help_seq, ll_blob

BOOLEAN	lb_multi_blob, lb_exist=FALSE

BLOB	lb_content, lb_split

IF dw_list.deletedcount()=0 and dw_list.modIfiedcount()=0   Then RETURN

rte_content.ReplaceText("~r~n ")

// set the primary key
ls_pgmno = dw_list.getitemstring(1, 'pgm_no')

SELECT  max(help_seq)
  INTO  :ll_help_seq
FROM    fw_pgm_help t1
WHERE   sys_id = :gnv_vari.is_sys_id
  AND   pgm_no = :ls_pgmno;

ll_help_seq = SQLCA.getitemnumber (1)

IF f_notnull (ll_help_seq) Then
   //이미 있으면 전부삭제하고 1번만 update 시간 추가
   lb_exist= TRUE
   DELETE  fw_pgm_help
   WHERE   sys_id   = :gnv_vari.is_sys_id
     AND   pgm_no   = :ls_pgmno
     AND   help_seq > 1;

   UPDATE  fw_pgm_help
      SET  upd_id = :gnv_vari.is_user_id
         , upd_dt = TO_CHAR(now(),'yyyymmddhh24miss')
   WHERE   sys_id   = :gnv_vari.is_sys_id
     AND   pgm_no   = :ls_pgmno
     AND   help_seq = 1;
End IF

ll_help_seq = 1
	
dw_list.AcceptText()

/* blob vriable 등록 */
rte_content.SelectTextAll()
lb_content = blob(rte_content.copyrtf(FALSE))

DO WHILE len (lb_content) > 0
   IF len (lb_content)>27000  Then
      lb_multi_blob = TRUE
      lb_split = blobmid (lb_content, 1, 27000)
      lb_content = blobmid (lb_content, 27001)
   Else
      IF lb_multi_blob  Then
         lb_split = blob ('[FIRST:'+string (1)+']') + lb_content
      Else
         lb_split = lb_content
      End IF
      lb_content = blob('')
   End IF
   IF ll_help_seq>1 or (not lb_exist)  Then
      INSERT INTO  fw_pgm_help (
                     sys_id                           /* _1: */
                   , pgm_no                           /* _2: */
                   , help_seq                         /* _3: */
                   , reg_id                           /* _4: */
                   , reg_dt )                         /* _5: */
      VALUES ( 'SY'                                       /* _1: */
             , :ls_pgmno                                  /* _2: */
             , :ll_help_seq                               /* _3: */
             , :gnv_vari.is_user_id                       /* _4: */
             , TO_CHAR(now(), 'yyyymmddhh24miss')       /* _5: */
             );
   End IF

   ll_blob  = mo_.blob2hex(lb_split, SQLCA.is_updateblob, ls_blob_err)

   UPDATEBLOB  fw_pgm_help
      SET  help_content = :lb_split
   WHERE   pgm_no   = :ls_pgmno
     AND   help_seq = :ll_help_seq
     AND   sys_id   = :gnv_vari.is_sys_id;

   ll_help_seq ++
LOOP

IF SQLCA.sqlcode ()<>0  Then
   ls_errtext = SQLCA.sqlerrtext()
   rollbackJ ()
   messagebox('Notice1', '자료 저장 실패했습니다!!~r~n' + ls_errtext)
   RETURN
End IF

rte_content.statusbar = FALSE
rte_content.toolbar = FALSE
rte_content.displayonly = TRUE

commitJ ()

messagebox('Notice', '저장 완료!!')

of_setenabled (FALSE)

RETURN
end event

type p_close from pf_u_imagebutton within fw_w_pgm_help_ent
integer x = 4215
integer y = 28
integer width = 229
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
end type

event clicked;call super::clicked;CLOSE(parent)

end event

type dw_mast from fw_u_dwo within fw_w_pgm_help_ent
integer x = 55
integer y = 156
integer width = 4393
integer height = 156
integer taborder = 10
boolean bringtotop = true
string dataobject = "fw_d_pgm_help_ent_01"
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

type rte_content from pf_u_richtextedit within fw_w_pgm_help_ent
integer x = 82
integer y = 428
integer width = 4347
integer height = 2244
integer taborder = 40
boolean bringtotop = true
boolean init_vscrollbar = true
boolean init_wordwrap = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean scaletoright = true
boolean scaletobottom = true
end type

event key;call super::key;STRING ls_text, ls_char=''

LONG	ll_cursor, ll_calc_cursor, ll_cur_cursor=-1, ll_head, ll_bhead, ll

STRING   ls = '■ㆍ∴※…√⇒◈●⊙◇▷‥☞±=【】「」『』《》〔〕〈〉'
STRING	la_head [] = {'■','  ㆍ','    ∴','      ※'}

IF key <> keyEnter! THEN ib_head_enter=FALSE

IF keyflags=2 Then // ctrl
	IF key = keyrightarrow! OR key = keyleftarrow! Then
		setredraw (FALSE)
		ll_cursor = selectedstartpos
		selecttextall ()
		copy ()
		ls_text = clipboard ()
		
		ll_calc_cursor = ll_cursor + 1
		DO
			ll_cur_cursor += 1
			ll_calc_cursor += 1
			ls_char = MID (ls_text, ll_cur_cursor, ll_calc_cursor - ll_cur_cursor)
			ll_cur_cursor += pos (ls_char, '~r~n')
		LOOP WHILE pos (ls_char, '~r~n')>0
		ls_char = MID (ls_text, ll_calc_cursor - 1, 1)
			
		ll_head = POS (ls, ls_char)
		IF ll_head>0 Then
			ll_bhead = len (la_head [ll_head])
			CHOOSE CASE key
				CASE keyrightarrow!
					ll_head ++
				CASE keyleftarrow!
					ll_head --
			END CHOOSE
			
			IF ll_head <= 4 AND ll_head >= 1 Then
				selectedstartpos = ll_cursor - ll_bhead + 1
				selectedtextlength = ll_bhead
				cut()
				::CLIPBOARD (la_head [ll_head])
				paste()
				ll_cursor = selectedstartpos - 1//selectedstartpos + len (la_head [ll_head]) - 1
			End IF
		Else
			selectedstartpos = ll_cursor
			selectedtextlength = 0
			::CLIPBOARD (la_head [1])
			paste()
		End IF
		
		selectedtextlength = 0
		selectedstartpos = ll_cursor
		setredraw (TRUE)
		RETURN 1
	End IF
ElseIF key = keyEnter! Then
	// 줄바꿈 직후 다시 엔터 >> 머리글 삭제
	IF ib_head_enter Then
		ll_cursor = selectedstartpos
		IF il_lastpos <> ll_cursor Then
			ib_head_enter = FALSE		
			RETURN
		End IF
		selectedstartpos = ll_cursor - len (la_head [il_head_type])
		selectedtextlength = len (la_head [il_head_type])
		cut()
		ib_head_enter = FALSE
		RETURN 1
	End IF

	//시작지점에 머리글이 있고 줄바꿈인 경우 머리글 복사
	setredraw (FALSE)
	ll_cursor = selectedstartpos
	selecttextall ()
	copy ()
	ls_text = clipboard ()
	
	selectedstartpos = ll_cursor
	selectedtextlength = 0
	
	ll_calc_cursor = ll_cursor + 1
	DO
		ll_cur_cursor += 1
		ll_calc_cursor += 1
		ls_char = MID (ls_text, ll_cur_cursor, ll_calc_cursor - ll_cur_cursor)
		ll_cur_cursor += pos (ls_char, '~r~n')
	LOOP WHILE pos (ls_char, '~r~n')>0
	ls_char = MID (ls_text, ll_calc_cursor - 1, 1)
	
	IF ls_char='~r' or ls_char='~n' or len(ls_char)=0 Then
		IF ls_char='~n' Then
			selectedstartpos = ll_cursor - 1
		Else
			selectedstartpos = ll_cursor
		End IF
		
		IF ls_char = MID (ls_text, ll_calc_cursor - 3, 1) Then
			setredraw (TRUE)
			RETURN
		End IF
		
		selectTextLine()
		copy()
		ls_text = clipboard()
		IF len (ls_text)=0 Then
			setredraw (TRUE)
			RETURN
		End IF
		
		IF len(ls_char)=0 Then
			ls_text = MID (ls_text, POS (ls_text, '~r~n') + 2)
		End IF
		
		selectedstartpos = ll_cursor
		selectedtextlength = 0
		
		ll_head = 0
		FOR  ll = 1 TO upperbound (la_head)
			IF POS (ls_text, la_head [ll]) = 1 Then
				ll_head = ll
				EXIT
			End IF
		NEXT
		
		IF ll_head> 0 Then
			selectedstartpos = ll_cursor
			selectedtextlength = 0
			ls_char = '~n' + la_head [ll_head]
			::CLIPBOARD (ls_char)
			paste ()
			ib_head_enter = TRUE
			il_head_type = ll_head
			il_lastpos = ll_cursor
			setredraw (TRUE)
			RETURN 1
		End IF
	End IF
End IF

ib_head_enter = FALSE
setredraw (TRUE)
end event

type st_3 from pf_u_statictext within fw_w_pgm_help_ent
integer x = 1504
integer y = 1416
integer width = 2597
integer height = 172
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 268435456
string text = "용도로 사용됩니다."
end type

type st_2 from pf_u_statictext within fw_w_pgm_help_ent
integer x = 1504
integer y = 1072
integer width = 2597
integer height = 172
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 268435456
string text = "또는 프로그램 사용시 주의할 사항, "
end type

type st_1 from pf_u_statictext within fw_w_pgm_help_ent
integer x = 1504
integer y = 900
integer width = 2597
integer height = 172
integer textsize = -18
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 268435456
string text = "이 화면은 프로그램 사용 방법에 대한 내용"
end type

type st_4 from pf_u_statictext within fw_w_pgm_help_ent
integer x = 87
integer y = 332
integer width = 411
integer height = 64
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 22830172
boolean enabled = false
string text = "도움말편집"
end type

type p_1 from pf_u_picture within fw_w_pgm_help_ent
integer x = 59
integer y = 332
integer width = 9
integer height = 56
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4comm\menu_delimiter.jpg"
end type

type p_addedit from pf_u_imagebutton within fw_w_pgm_help_ent
integer x = 3666
integer y = 28
integer width = 302
integer height = 96
boolean bringtotop = true
boolean enabled = false
string picturename = "..\img\controls\u_imagebutton\btn_editRegistration.jpg"
end type

event clicked;call super::clicked;IF rte_content.displayonly=FALSE   Then
   messagebox('Notice', '현재 편집 모드입니다.')
   RETURN
End IF

LONG	ll_new

STRING	ls_user_id, ls_user_nm

ls_user_id = gnv_vari.is_user_id
ls_user_nm = gnv_vari.is_user_nm

ll_new = dw_list.insertrow (1)
dw_list.SelectRow(0, FALSE)
dw_list.SelectRow(1, TRUE)

dw_list.setitem(ll_new, 'sys_id' , gnv_vari.is_sys_id)
dw_list.setitem(ll_new, 'pgm_no' , inv_argmenu.is_pgm_no)
dw_list.setitem(ll_new, 'reg_dt' , fw_f_getymdhh24miss4s())
dw_list.setitem(ll_new, 'reg_id' , ls_user_id)
dw_list.setitem(ll_new, 'user_nm', ls_user_nm)

IF rte_content.visible=FALSE  Then rte_content.visible = TRUE
rte_content.statusbar = TRUE
rte_content.displayonly = FALSE
rte_content.setfocus()
/* to-be */
IF IsNULL(rte_content.SelectedText())  Then
   rte_content.scrolltorow(1)
   rte_content.Pastertf(string(ib_content))
End IF
end event

type rr_border from pf_u_roundrectangle within fw_w_pgm_help_ent
long linecolor = 268435456
integer x = 50
integer y = 404
integer width = 4393
integer height = 2284
end type

type dw_list from fw_u_dwo within fw_w_pgm_help_ent
boolean visible = false
integer x = 4265
integer y = 316
integer width = 206
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "편집히스토리"
string dataobject = "fw_d_pgm_help_ent_02"
boolean ibsetlist4alrowcolor = false
end type

event rowfocuschanged;call super::rowfocuschanged;IF currentrow<1 Then RETURN

STRING	ls_pgm_no, ls_text, ls_blob_err, ls_key

LONG	ll_help_seq, ll_blob, ll

BLOB	lb_help

ls_pgm_no = this.getitemstring(currentrow, 'pgm_no')
ll_help_seq = this.getitemnumber(currentrow, 'help_seq')

SELECTBLOB  help_content
  INTO  :ib_content
FROM    fw_pgm_help t1
WHERE   sys_id   = :gnv_vari.is_sys_id
  AND   pgm_no   = :ls_pgm_no
  AND   help_seq = :ll_help_seq;

IF SQLCA.sqlcode ()=0   Then
   ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, ib_content, ls_blob_err)
   IF ll_blob<0   Then
      f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
   End IF
End IF

ls_text = string (ib_content)

ls_key = string (blobmid (ib_content, 1, 20))
IF POS (ls_key, '[FIRST')>0   Then

   ls_text = ''
   FOR  ll = long (mid (ls_key, 8, POS (ls_key, ']') - 8))  TO  ll_help_seq - 1
      SELECTBLOB  help_content
        INTO  :lb_help
      FROM    fw_pgm_help t1
      WHERE   pgm_no   = :ls_pgm_no
        AND   sys_id   = 'SY'
        AND   help_seq = :ll;

      IF SQLCA.sqlcode ()=0   Then
         ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, lb_help, ls_blob_err)
         IF ll_blob<0   Then
            f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
         End IF
      End IF

      ls_text += string (lb_help)
   NEXT
   ls_text += mid (string (ib_content), POS (ls_key, ']') + 1)
End IF

ib_content = blob (ls_text)

rte_content.SelectTextAll()
rte_content.Cut()   //Clear()
rte_content.statusbar = FALSE
rte_content.toolbar = FALSE
rte_content.displayonly = TRUE
IF rte_content.visible=FALSE  Then rte_content.visible = TRUE
rte_content.pastertf(ls_text)
rte_content.ScrollToRow(1)
end event

event retrieveend;call super::retrieveend;LONG	ll_blob

STRING	ls_blob_err, ls_text, ls_path, ls_pgm_no

IF rowcount=0 Then
	IF gaa.aams Then
		rte_content.visible=FALSE
		
		ls_pgm_no = dw_mast.object.pgm_no [1]
		
		SELECT  fullpgm2
		  INTO  :ls_path
		FROM    fw_pgm_mst
		WHERE   pgm_no = :ls_pgm_no;
		
		ls_path = SQLCA.getitemstring (1)
		
		SELECTBLOB  help_content
		  INTO  :ib_content
		FROM    fw_pgm_help t1
		WHERE   pgm_no = '00101';
		
		IF	SQLCA.sqlcode ()=0	then
			ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, ib_content, ls_blob_err)
			IF	ll_blob < 0	Then
				f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
			End IF
		End IF
	
		ls_text = string (ib_content)
		rte_content.pastertf(ls_text)
		rte_content.SelectTextAll()
		rte_content.Copy()
		ls_text = Clipboard ()
		ls_text = f_replace (ls_text, 'path', ls_path)
		ls_text = f_replace (ls_text, 'user_name', gnv_vari.is_user_nm)
		
		rte_content.SelectTextAll()
		rte_content.Cut()   //Clear()
		
		::CLIPBOARD (ls_text)
		rte_content.Paste()
		rte_content.statusbar = FALSE
		rte_content.toolbar = FALSE
		rte_content.displayonly = TRUE
		IF rte_content.visible=FALSE  Then rte_content.visible = TRUE
		rte_content.ScrollToRow(1)
		
		ib_content = blob (rte_content.copyRTF (FALSE))
		::CLIPBOARD ('')
	Else
		::CLIPBOARD ('등록된 도움말이 없습니다.')
		rte_content.paste()
		::CLIPBOARD ('')
	End IF
End IF
end event

