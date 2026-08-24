forward
global type w_whlp00m_help_list from wt_list
end type
type st_1 from pf_u_splitbar_vertical within w_whlp00m_help_list
end type
type rte_1 from pf_u_richtextedit within w_whlp00m_help_list
end type
type cb_1 from pf_u_commandbutton within w_whlp00m_help_list
end type
type cb_2 from pf_u_commandbutton within w_whlp00m_help_list
end type
type cb_3 from pf_u_commandbutton within w_whlp00m_help_list
end type
end forward

global type w_whlp00m_help_list from wt_list
boolean eb_direct_retrieve = true
boolean ib_managedata = false
st_1 st_1
rte_1 rte_1
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type
global w_whlp00m_help_list w_whlp00m_help_list

type variables
BOOLEAN	ib_head_enter=FALSE
LONG		il_head_type=0, il_lastpos
end variables

on w_whlp00m_help_list.create
int iCurrent
call super::create
this.st_1=create st_1
this.rte_1=create rte_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rte_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_3
end on

on w_whlp00m_help_list.destroy
call super::destroy
destroy(this.st_1)
destroy(this.rte_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gnv_vari.is_sys_id, dw_c.object.recv_gb [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.recv_gb [1] = '%'
end event

type lb_dirlist from wt_list`lb_dirlist within w_whlp00m_help_list
end type

type ln_templeft from wt_list`ln_templeft within w_whlp00m_help_list
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_whlp00m_help_list
end type

type ln_temptop from wt_list`ln_temptop within w_whlp00m_help_list
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_whlp00m_help_list
end type

type ln_tempstart from wt_list`ln_tempstart within w_whlp00m_help_list
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_whlp00m_help_list
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_whlp00m_help_list
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_whlp00m_help_list
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_whlp00m_help_list
end type

type ln_tempright from wt_list`ln_tempright within w_whlp00m_help_list
end type

type uo_navi from wt_list`uo_navi within w_whlp00m_help_list
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_whlp00m_help_list
end type

type st_windelaytime from wt_list`st_windelaytime within w_whlp00m_help_list
end type

type st_top_rect from wt_list`st_top_rect within w_whlp00m_help_list
end type

type p_close from wt_list`p_close within w_whlp00m_help_list
end type

type p_excel from wt_list`p_excel within w_whlp00m_help_list
end type

type p_print from wt_list`p_print within w_whlp00m_help_list
end type

type p_delete from wt_list`p_delete within w_whlp00m_help_list
end type

type p_update from wt_list`p_update within w_whlp00m_help_list
end type

type p_input from wt_list`p_input within w_whlp00m_help_list
end type

type p_retrieve from wt_list`p_retrieve within w_whlp00m_help_list
end type

type p_clear from wt_list`p_clear within w_whlp00m_help_list
end type

type p_copy from wt_list`p_copy within w_whlp00m_help_list
end type

type dw_c from wt_list`dw_c within w_whlp00m_help_list
string dataobject = "d_whlp00m_help_list_c"
end type

type btn_update from wt_list`btn_update within w_whlp00m_help_list
end type

type st_count from wt_list`st_count within w_whlp00m_help_list
end type

type dw_list from wt_list`dw_list within w_whlp00m_help_list
integer y = 340
integer width = 2473
string dataobject = "d_whlp00m_help_list"
boolean eb_range_delcopy = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
boolean eb_null_line = false
end type

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;BLOB	lb_help

STRING	ls_pgm_no, ls_key, ls_last, ls_text
LONG		ll_blob, ll_seq=1, ll_start, ll
STRING	ls_blob_err

cb_1.of_setenabled (FALSE)
IF dw_list.object.regist [currentrow] = 'Y' THEN cb_3.of_setenabled (TRUE) ELSE cb_3.of_setenabled (FALSE)
rte_1.visible = FALSE
f_loadingrd (TRUE)

ls_pgm_no = dw_list.object.pgm_no [currentrow]

SELECT  max (help_seq)
  INTO  :ll_seq
FROM    fw_pgm_help t1
WHERE   pgm_no = :ls_pgm_no
  AND   sys_id = :gnv_vari.is_sys_id;

IF SQLCA.sqlcode()=0 THEN ll_seq = SQLCA.getitemnumber (1)
IF f_null (ll_seq) THEN ll_seq = 1

SELECTBLOB  help_content
  INTO  :lb_help
FROM    fw_pgm_help t1
WHERE   pgm_no   = :ls_pgm_no
  AND   sys_id   = :gnv_vari.is_sys_id
  AND   help_seq = :ll_seq;

IF	SQLCA.sqlcode ()=0	then
	ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, lb_help, ls_blob_err)
	IF	ll_blob < 0	Then
		f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
	End IF
End IF

ls_text = string (lb_help)

ls_key = string (blobmid (lb_help, 1, 20))
IF pos (ls_key, '[FIRST')>0 Then
	ll_start = long (mid (ls_key, 8, pos (ls_key, ']') - 8))
	
	ls_last = mid (string (lb_help), pos (ls_key, ']') + 1)
	
	ls_text = ''
	FOR  ll = ll_start  TO  ll_seq - 1
		SELECTBLOB  help_content
		  INTO  :lb_help
		FROM    fw_pgm_help t1
		WHERE   pgm_no   = :ls_pgm_no
		  AND   sys_id   = :gnv_vari.is_sys_id
		  AND   help_seq = :ll;
		  
	  IF	SQLCA.sqlcode ()=0	then
			ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, lb_help, ls_blob_err)
			IF	ll_blob < 0	Then
				f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
			End IF
		End IF
		
		ls_text += string (lb_help)
	NEXT
	ls_text += ls_last
End IF

rte_1.SelectTextAll()
rte_1.Cut()   //Clear()
rte_1.pastertf(ls_text)
rte_1.ScrollToRow(1)

f_loadingrd (FALSE)
rte_1.visible = TRUE
RETURN 0
end event

type st_1 from pf_u_splitbar_vertical within w_whlp00m_help_list
integer x = 2533
integer y = 348
integer height = 2416
boolean bringtotop = true
boolean setsheetcolor = true
boolean scaletobottom = false
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list"
string rightdragobject = "rte_1"
end type

type rte_1 from pf_u_richtextedit within w_whlp00m_help_list
integer x = 2555
integer y = 452
integer width = 2875
integer height = 2312
integer taborder = 110
boolean bringtotop = true
boolean init_wordwrap = true
boolean scaletoright = true
boolean scaletobottom = true
end type

event key;call super::key;STRING ls_text, ls_char=''

LONG	ll_cursor, ll_calc_cursor, ll_cur_cursor=-1, ll_head, ll_bhead, ll

STRING   ls = '■ㆍ∴※…√⇒◈●⊙◇▷‥☞±=【】「」『』《》〔〕〈〉'
STRING	la_head [] = {'■','  ㆍ','    ∴','      ※'}

cb_1.of_setenabled (TRUE)

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

type cb_1 from pf_u_commandbutton within w_whlp00m_help_list
integer x = 4480
integer y = 348
integer width = 315
integer taborder = 110
boolean bringtotop = true
integer weight = 400
boolean enabled = false
string text = "저장"
end type

event clicked;call super::clicked;STRING	ls_pgmno, ls_errtext, ls_blob_err

LONG	ll_help_seq, ll_blob

BOOLEAN	lb_multi_blob, lb_exist=FALSE

BLOB	lb_content, lb_split

rte_1.SelectTextAll ()
IF f_null (rte_1.SelectedText ()) THEN rte_1.ReplaceText("~r~n ")

// set the primary key
ls_pgmno = dw_list.Object.pgm_no [iRow]

SELECT max(help_seq)
  INTO :ll_help_seq
FROM   fw_pgm_help t1
WHERE  sys_id = :gnv_vari.is_sys_id
  AND  pgm_no = :ls_pgmno;

ll_help_seq = SQLCA.getitemnumber (1)

IF f_notnull (ll_help_seq) Then
   //이미 있으면 전부삭제하고 1번만 update 시간 추가
   lb_exist= TRUE
   DELETE fw_pgm_help
   WHERE  sys_id   = :gnv_vari.is_sys_id
     AND  pgm_no   = :ls_pgmno
     AND  help_seq > 1;

   UPDATE fw_pgm_help
      SET upd_id = :gnv_vari.is_user_id
        , upd_dt = TO_CHAR(now(),'yyyymmddhh24miss')
   WHERE  sys_id   = :gnv_vari.is_sys_id
     AND  pgm_no   = :ls_pgmno
     AND  help_seq = 1;

End IF

ll_help_seq = 1

/* blob vriable 등록 */
rte_1.SelectTextAll()
lb_content = blob(rte_1.copyrtf(FALSE))

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
      INSERT INTO fw_pgm_help (
                  sys_id      /* _1: */
                , pgm_no      /* _2: */
                , help_seq    /* _3: */
                , reg_id      /* _4: */
                , reg_dt )    /* _5: */
      VALUES ( 'SY'                                    /* _1: */
             , :ls_pgmno                               /* _2: */
             , :ll_help_seq                            /* _3: */
             , :gnv_vari.is_user_id                    /* _4: */
             , TO_CHAR(now(), 'yyyymmddhh24miss')    /* _5: */
             );
   End IF

   ll_blob  = mo_.blob2hex(lb_split, SQLCA.is_updateblob, ls_blob_err)

   UPDATEBLOB fw_pgm_help
      SET help_content = :lb_split
   WHERE  pgm_no   = :ls_pgmno
     AND  help_seq = :ll_help_seq
     AND  sys_id   = :gnv_vari.is_sys_id;

   ll_help_seq ++
LOOP
commitJ ()

//messagebox('Notice', '저장 완료!!')
f_microhelp ('저장 완료!!')

dw_list.object.regist [iRow] = 'Y'

of_setenabled (FALSE)
cb_3.of_setenabled (TRUE)
end event

type cb_2 from pf_u_commandbutton within w_whlp00m_help_list
integer x = 3941
integer y = 348
integer width = 530
integer taborder = 120
boolean bringtotop = true
integer weight = 400
string text = "기본형식가져오기"
end type

event clicked;call super::clicked;LONG	ll_blob

STRING	ls_blob_err, ls_text, ls_path, ls_pgm_no

BLOB	lb_blob

rte_1.visible = FALSE
cb_1.of_setenabled (TRUE)

ls_pgm_no = dw_list.object.pgm_no [iRow]

SELECT fullpgm2
  INTO :ls_path
FROM   fw_pgm_mst  t1
WHERE  pgm_no = :ls_pgm_no;

ls_path = SQLCA.getitemstring (1)

rte_1.SelectTextAll ()
IF f_null (rte_1.SelectedText ())	Then
	SELECTBLOB help_content
	  INTO :lb_blob
	FROM   fw_pgm_help t1
	WHERE  pgm_no = '00101';
	IF SQLCA.sqlcode ()=0   Then
		ll_blob = mo_.Hex2Blob (SQLCA.is_hexFile, lb_blob, ls_blob_err)
		IF ll_blob<0   Then
			f_messageBox ('ERR', 'blob 변환 오류 : ' + ls_blob_err)
		End IF
	End IF
	ls_text = string (lb_blob)
	rte_1.pastertf (ls_text)
	rte_1.SelectTextAll()
	rte_1.Copy()
	ls_text = Clipboard ()
Else
	rte_1.Copy()
	ls_text = Clipboard ()
End IF

IF	POS (ls_text,'pgm_nm')>0 THEN ls_text = f_replace (ls_text, 'pgm_nm', dw_list.object.pgm_nm [iRow])
IF	POS (ls_text,'path')>0	Then
	ls_text = f_replace (ls_text, 'path', ls_path)
Else
	IF	POS (ls_text,'    ' + ls_path)=0 THEN ls_text = f_replace (ls_text, '■ 경로', '■ 경로~r~n    ' + ls_path)
End IF
IF	POS (ls_text,'user_name')>0 THEN ls_text = f_replace (ls_text, 'user_name', gnv_vari.is_user_nm)

rte_1.SelectTextAll()
rte_1.Cut()   //Clear()

::CLIPBOARD (ls_text)
rte_1.Paste()
rte_1.ScrollToRow(1)
rte_1.visible = TRUE

::CLIPBOARD ('')
end event

type cb_3 from pf_u_commandbutton within w_whlp00m_help_list
integer x = 4805
integer y = 348
integer width = 315
integer taborder = 130
boolean bringtotop = true
integer weight = 400
string text = "삭제"
end type

event clicked;call super::clicked;//help_seq 전부삭제 >> 분할순서로 사용

STRING	ls_pgm_no

ls_pgm_no = dw_list.object.pgm_no [iRow]

DELETE fw_pgm_help
WHERE  sys_id = :gnv_vari.is_sys_id
  AND  pgm_no = :ls_pgm_no;

commitJ ()

f_messageBox ('INFO', '삭제되었습니다. (' + ls_pgm_no + ')')
end event

