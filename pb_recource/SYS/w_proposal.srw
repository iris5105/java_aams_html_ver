forward
global type w_proposal from w_winpage
end type
type dw_list from u_dw within w_proposal
end type
type rte_func from pf_u_richtextedit within w_proposal
end type
type mle_matter from u_mle within w_proposal
end type
type mle_content from u_mle within w_proposal
end type
type mle_append from u_mle within w_proposal
end type
type dw_2 from u_dw within w_proposal
end type
type ole_rd from u_rd within w_proposal
end type
type st_1 from pf_u_splitbar_vertical within w_proposal
end type
end forward

global type w_proposal from w_winpage
boolean eb_direct_retrieve = true
integer ii_dddw_width = 1000
dw_list dw_list
rte_func rte_func
mle_matter mle_matter
mle_content mle_content
mle_append mle_append
dw_2 dw_2
ole_rd ole_rd
st_1 st_1
end type
global w_proposal w_proposal

type variables
STRING	is_proposer
STRING	is_text = '기타 의견이나 전달사항이 있으면 입력하십시오.~r~n입력 완료 후 Enter를 치면 댓글로 등록됩니다.'

DateTime idt_ymd

str_parameter  sp
end variables

on w_proposal.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rte_func=create rte_func
this.mle_matter=create mle_matter
this.mle_content=create mle_content
this.mle_append=create mle_append
this.dw_2=create dw_2
this.ole_rd=create ole_rd
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rte_func
this.Control[iCurrent+3]=this.mle_matter
this.Control[iCurrent+4]=this.mle_content
this.Control[iCurrent+5]=this.mle_append
this.Control[iCurrent+6]=this.dw_2
this.Control[iCurrent+7]=this.ole_rd
this.Control[iCurrent+8]=this.st_1
end on

on w_proposal.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.rte_func)
destroy(this.mle_matter)
destroy(this.mle_content)
destroy(this.mle_append)
destroy(this.dw_2)
destroy(this.ole_rd)
destroy(this.st_1)
end on

event wue_postopen;call super::wue_postopen;f_memo ('function history', rte_func)

mle_append.TEXT = is_text

IF NOT gaa.aams	THEN f_setprotect (dw_c, TRUE, { 'dddw' })
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
iRow = 0

dw_List.uf_reset (FALSE)
dw_List.Modify (dw_List.ia_protect [4])
dw_List.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)

mle_matter.uf_init ('', ib_ManageData)
mle_content.uf_init ('', ib_ManageData)
mle_append.uf_init ('', ib_ManageData)
dw_2.enabled = FALSE
end event

event ue_activate;call super::ue_activate;IF mle_matter.displayonly  Then mle_matter.backcolor = gnv_vari.setcondbackcolor &
Else                            mle_matter.BackColor = rgb (240,255,255)
IF mle_content.displayonly Then mle_content.backcolor = gnv_vari.setcondbackcolor &
Else                            mle_content.BackColor = rgb (240,255,255)
rte_func.backcolor = gnv_vari.setcondbackcolor
mle_append.BackColor = rgb (240,255,255)
end event

event wue_update;call super::wue_update;IF dw_List.AcceptText ()=-1 OR dw_2.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF

IF mle_matter.ib_update THEN dw_List.object.matter [iRow] = mle_matter.TEXT
IF mle_content.ib_update   Then
   dw_List.object.content [iRow] = mle_content.TEXT
   IF f_null (mle_content.TEXT) THEN dw_List.object.content_ymd [iRow] = null_dt &
   ELSE                              dw_List.object.content_ymd [iRow] = f_sysdate ('')
End IF

IF EVENT ue_wpage_Modified () Then
   IF uf_UpdateCommit (dw_List, dw_2)=-1 THEN RETURN -1
   mle_matter.ib_update = FALSE
   mle_content.ib_update = FALSE
End IF
RETURN 1
end event

event wue_retrieve;call super::wue_retrieve;mle_matter.uf_init ('', ib_ManageData)
mle_content.uf_init ('', ib_ManageData)
mle_append.uf_init ('', ib_ManageData)

IF ib_ManageData  Then
   dw_List.uf_protect (0, dw_List.ia_protect [1]) ; dw_2.uf_protect (0, dw_2.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [3]) ; dw_2.uf_protect (0, dw_2.ia_protect [3])
End IF

dw_2.uf_reset (TRUE)
dw_List.uf_reset (TRUE)
dw_List.retrieve (dw_c.object.dddw [1])
end event

event ue_wpage_modified;IF dw_List.uf_isModified ()=FALSE And dw_2.uf_isModified ()=FALSE And mle_matter.ib_update=FALSE And mle_content.ib_update=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = gaa.corp_gr
IF eb_direct_retrieve THEN p_retrieve.post event clicked()
end event

event ue_setenabled;call super::ue_setenabled;IF dw_list.rowcount() > 0 AND dw_2.ibsetlist4subbtn	Then
	dw_2.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
	dw_2.of_dw2subbtn ({'p_input'}, (dw_2.enabled And dw_2.eb_new_false=FALSE And ib_managedata))
	dw_2.of_dw2subbtn ({'p_copy'}, (dw_2.enabled And dw_2.eb_copy_false=FALSE And ib_managedata))
	dw_2.of_dw2subbtn ({'p_delete'}, (dw_2.enabled And dw_2.eb_delete_false=FALSE And ib_managedata))

ElseIF dw_list.rowcount ()=0 And dw_2.ibsetlist4subbtn	Then
	dw_2.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
End IF
end event

event ue_setdisabled;call super::ue_setdisabled;IF dw_2.ibsetlist4subbtn THEN dw_2.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
end event

type lb_dirlist from w_winpage`lb_dirlist within w_proposal
end type

type ln_templeft from w_winpage`ln_templeft within w_proposal
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_proposal
end type

type ln_temptop from w_winpage`ln_temptop within w_proposal
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_proposal
end type

type ln_tempstart from w_winpage`ln_tempstart within w_proposal
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_proposal
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_proposal
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_proposal
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_proposal
end type

type ln_tempright from w_winpage`ln_tempright within w_proposal
end type

type uo_navi from w_winpage`uo_navi within w_proposal
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_proposal
end type

type st_windelaytime from w_winpage`st_windelaytime within w_proposal
end type

type st_top_rect from w_winpage`st_top_rect within w_proposal
end type

type p_close from w_winpage`p_close within w_proposal
end type

type p_excel from w_winpage`p_excel within w_proposal
end type

type p_print from w_winpage`p_print within w_proposal
end type

type p_delete from w_winpage`p_delete within w_proposal
end type

type p_update from w_winpage`p_update within w_proposal
end type

type p_input from w_winpage`p_input within w_proposal
end type

type p_retrieve from w_winpage`p_retrieve within w_proposal
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return
IF	p_clear.visible	Then
	p_clear.of_setenabled (true)
	of_setenabled (false)
End IF
dw_List.uf_protect (0, dw_List.ia_protect [1])

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_proposal
end type

type p_copy from w_winpage`p_copy within w_proposal
end type

type dw_c from w_winpage`dw_c within w_proposal
string title = "자산운용(자문)사"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | corp_gr', gaa.corp_gr, '', 1, "substrb (company_name,1,1) != '*'")
end event

type btn_update from w_winpage`btn_update within w_proposal
end type

type st_count from w_winpage`st_count within w_proposal
end type

type dw_list from u_dw within w_proposal
integer x = 50
integer y = 348
integer width = 3296
integer height = 2216
integer taborder = 55
string dataobject = "d_proposal_list"
boolean vscrollbar = true
string is_receivetype = "sqlm"
boolean ibsettooltiphelp = true
boolean eb_range_delcopy = false
boolean eb_always_1_insert = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event retrieveend;call super::retrieveend;IF rowcount=0 THEN dw_2.uf_retrieveend ('detail', 0, FALSE)
uf_retrieveend (is_find, rowcount, eb_null_line)
end event

event constructor;call super::constructor;eb_delete_false = NOT (gaa.admin OR gaa.aams)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow

idt_ymd = Object.ymd [iRow]
is_proposer = Object.proposer [iRow]

mle_matter.TEXT = Object.matter [iRow]
mle_content.TEXT = Object.content [iRow]

dw_2.uf_reset ()
dw_2.EVENT ue_retrieve ()

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_matter.uf_reset (TRUE)
mle_content.uf_reset (TRUE)
dw_2.uf_deleteall ()
RETURN 0
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;IF mle_matter.ib_update Then
   Object.matter [iRow] = mle_matter.TEXT
End IF

IF mle_content.ib_update   Then
   Object.content [iRow] = mle_content.TEXT
   IF f_null (mle_content.TEXT) THEN Object.content_ymd [iRow] = null_dt &
   ELSE                              Object.content_ymd [iRow] = f_sysdate ('')
End IF
IF GetItemStatus (iRow, 0, Primary!)=New! THEN Object.ymd [iRow] = f_sysdate ('')
IF parent.EVENT wue_update ()=-1 THEN RETURN 1

RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF dw_2.uf_Update ()=FALSE THEN RETURN 1

IF mle_matter.ib_update THEN Object.matter [iRow] = mle_matter.TEXT
IF mle_content.ib_update   Then
   Object.content [iRow] = mle_content.TEXT
   IF f_null (mle_content.TEXT) THEN dw_List.object.content_ymd [iRow] = null_dt &
   ELSE                              dw_List.object.content_ymd [iRow] = f_sysdate ('')
End IF
mle_matter.ib_update = FALSE
mle_content.ib_update = FALSE

uf_SetColumn ('ymd', f_sysdate_str ('yyyy-mm-dd hh24:mi:ss'))
uf_setcolumn ('proposer', gnv_vari.is_user_nm)

mle_append.TEXT = is_text

POST SetColumn ('title')

RETURN 0
end event

event ue_protect;call super::ue_protect;IF object.proposer [row]<>gnv_vari.is_user_nm OR string (object.ymd [row], 'yyyymmdd')<>f_sysdate_str ('yyyymmdd') Then
   uf_protect (row, ia_protect [2])
   mle_matter.DisplayOnly = TRUE
Else
   uf_protect (row, ia_protect [1])
   mle_matter.DisplayOnly = FALSE
End IF
mle_content.DisplayOnly = NOT (gaa.admin OR gaa.aams)
end event

event doubleclicked;STRING	ls_corp_gr, ls_proposer, ls_path, ls_local, ls_blob_err

Datetime	ldt

BLOB	lb_data

LONG	ll_rtn

IF	dwo.name='fexp'	Then
	IF f_notnull (Object.fexp [row]) And (Object.save_visible [row]=1 OR gaa.admin)	Then
		IF parent.EVENT wue_update ()=-1 THEN RETURN
		uf_setrow (row, false)
		ls_corp_gr = dw_c.object.dddw [1]
		ldt = Object.ymd [row]
		ls_proposer = Object.proposer [row]

		ll_rtn = f_messageBox ('RUN2', '등록된 파일이 있습니다.~r~n파일을 변경(취소시 삭제)하시겠습니까?')
		IF ll_rtn=2 THEN RETURN
		IF ll_rtn=3 Then
			IF f_messageBox ('INFO2', '파일을 삭제 하시겠습니까?')=2 THEN RETURN
			Object.fexp [row] = null_s
			Object.org_fname [row] = null_s
	
			lb_data = BLOB(" ")
			mo_.blob2hex(lb_data, SQLCA.is_updateblob, ls_blob_err)

			UPDATEBLOB  proposal
				SET  data = :lb_data
			WHERE   corp_gr  = :ls_corp_gr
			  AND   ymd      = :ldt
			  AND   proposer = :ls_proposer;

			commitJ ()

			RETURN
		End IF

		IF GetFileOpenName ("Select File", ls_path, ls_local, "pdf", "PDF File/Word 문서/HWP 문서/Excel 통합 문서,*.pdf;*.doc?;*.hwp;*.xls?,모든 자료 (*.*),*.*" )<>1 THEN RETURN

		lb_data = BLOB(" ")
		
		filedelete (ls_path + '.zip')
		IF	mo_.zip (ls_path, ls_path + '.zip', 'f')<>0	Then
			f_messagebox ('INFO','자료를 다시 LOAD하십시오.')
			RETURN
		Else
			SQLCA.setupdateBLOB_file (ls_path + '.zip')
			Object.org_fname [row] = ls_local
		End IF

		UPDATEBLOB  proposal
			SET  data = :lb_data
		WHERE   corp_gr  = :ls_corp_gr
		  AND   ymd      = :ldt
		  AND   proposer = :ls_proposer;

		commitJ ()

		Object.fexp [row] = MID (ls_local, LASTPOS (ls_local,'.') + 1)

		filedelete (ls_path + '.zip')
	Else
		f_messagebox ('DATA','파일은 당일만 가능합니다.')
	End IF
End IF
end event

event ue_print;IF f_notnull (Object.row_id [getrow ()])  Then
   ole_rd.uf_fileopen ('rd_proposal.mrd' &
	                               , "ymd[" + string (Object.ymd [getrow ()],'yyyymmddHHmmss') + "] " + &
	                                 "proposer[" + string (Object.proposer [getrow ()]) + "]" )
   RETURN
End IF
CALL super::ue_print
end event

event rowfocuschanged;call super::rowfocuschanged;IF mle_matter.displayonly   Then mle_matter.backcolor = gnv_vari.setcondbackcolor &
Else                             mle_matter.BackColor = rgb (240,255,255)
IF mle_content.displayonly Then mle_content.backcolor = gnv_vari.setcondbackcolor &
Else                            mle_content.BackColor = rgb (240,255,255)

mle_append.TEXT = is_text
end event

event buttonup;STRING	ls_corp_gr, ls_proposer, ls_path, ls_local, ls_fname

Datetime ldt

BLOB	lb_data

BOOLEAN	lb_return

CHOOSE CASE dwo.name
   CASE 'p_save'
      AcceptText ()
      uf_setrow (row, FALSE)

		p_update.event clicked()

      ls_corp_gr = dw_c.object.dddw [1]
      ldt = Object.ymd [row]
      ls_proposer = Object.proposer [row]

      IF mle_matter.ib_update THEN Object.matter [iRow] = mle_matter.TEXT
      IF mle_content.ib_update   Then
         Object.content [iRow] = mle_content.TEXT
         IF f_null (mle_content.TEXT) THEN Object.content_ymd [iRow] = null_dt ELSE Object.content_ymd [iRow] = f_sysdate ('')
      End IF
      IF f_null (Object.title [iRow]) THEN Object.title [iRow] = '... 의뢰내용을 간략하게 기재하십시오 ...'
      IF parent.EVENT wue_update ()=-1 THEN RETURN

      IF GetFileOpenName ("Select File", ls_path, ls_local, "pdf", "PDF File/Word 문서/HWP 문서/Excel 통합 문서,*.pdf;*.doc?;*.hwp;*.xls?,모든 자료 (*.*),*.*" )<>1 THEN RETURN

      lb_data = blob(" ")

		filedelete (ls_path + '.zip')
		//<임시> 파일을 잡고있는경우 빈 압축파일이 생성
		mo_.zip (ls_path, ls_path + '.zip', 'f')
		IF fileexists (ls_path + '.zip')	And FileLength64(ls_path + '.zip')>22	Then //엑셀을 잡고있는경우 사이즈 22 > 다른문서형식은 테스트필요
			SQLCA.setupdateBLOB_file (ls_path + '.zip')
			Object.org_fname [row] = ls_local
		Else
			filedelete (ls_path + '.zip')
			messagebox ('압축실패!','자료를 다시 LOAD하십시오.~r~n파일을 열고있는 경우 종료하여 주십시요', stopsign!)
			RETURN
		End IF

      UPDATEBLOB  proposal
         SET  data = :lb_data
      WHERE   corp_gr  = :ls_corp_gr
        AND   ymd      = :ldt
        AND   proposer = :ls_proposer;

      Object.fexp [row] = MID (ls_local, LASTPOS (ls_local,'.') + 1)

      filedelete (ls_path + '.zip')

	CASE 'p_open'
      ls_corp_gr = dw_c.object.dddw [1]
      ldt = Object.ymd [row]

      SELECTBLOB  data
        INTO  :lb_data
      FROM    proposal t1
      WHERE   corp_gr = :ls_corp_gr
        AND   ymd     = :ldt;

      enabled = FALSE

      ls_fname = Object.org_fname [row]
      IF f_notnull (ls_fname) Then
         filedelete (gaa.temp + ls_fname + '.zip')
         filedelete (gaa.temp + ls_fname)
         lb_return = mo_.hex2file (gaa.temp + ls_fname + '.zip', SQLCA.is_Hexfile)
         IF lb_return   Then
            /* 압축풀기... */
            mo_.unzip (gaa.temp + ls_fname + '.zip', gaa.temp)
	         sleep (1) /* 파일 압축풀기 */
         End IF
      Else
         ls_fname = "__tmp" + string (now (),"hhmmssfff") + gnv_vari.is_user_id + '.' + Object.fexp [row]
         lb_return = mo_.Hex2File (gaa.temp + ls_fname, SQLCA.is_HexFile)
      End IF
      IF NOT lb_return THEN f_messageBox ('ERR', '파일생성오류')
      filedelete (gaa.temp + ls_fname + '.zip')

      ShellExecute (HANDLE (gw_mdi), 'open', ls_fname, '', gaa.temp, 1)
      enabled = TRUE
END CHOOSE
end event

type rte_func from pf_u_richtextedit within w_proposal
integer x = 3383
integer y = 348
integer width = 2048
integer height = 92
boolean bringtotop = true
long init_backcolor = 67108864
boolean enabled = false
boolean border = false
boolean scaletoright = true
end type

event constructor;backcolor = gnv_vari.setcondbackcolor
end event

type mle_matter from u_mle within w_proposal
integer x = 3383
integer y = 452
integer width = 2048
integer height = 1124
integer taborder = 60
boolean bringtotop = true
boolean scaletoright = true
end type

type mle_content from u_mle within w_proposal
integer x = 3383
integer y = 1592
integer width = 2048
integer height = 700
integer taborder = 70
boolean bringtotop = true
boolean scaletoright = true
end type

type mle_append from u_mle within w_proposal
integer x = 50
integer y = 2576
integer width = 3296
integer height = 188
integer taborder = 80
boolean bringtotop = true
long textcolor = 268435456
boolean scaletobottom = true
end type

event key;IF keyflags=0 And key=KeyEnter! Then
   POST EVENT key_post (TEXT)
   send(handle(THIS),256,9,long(0,0))
	TEXT = is_text
   RETURN 1
End IF
call super::key
end event

event getfocus;TEXTCOLOR = 0
IF	POS(TEXT,is_text)>0	Then
	SelectText (1, Len (TEXT))
	ReplaceText ('')
End IF
end event

event losefocus;call super::losefocus;TEXTCOLOR = 268435456
end event

event key_post;call super::key_post;IF NOT f_null (arg_text)   Then
   dw_2.setfocus ()
   dw_2.insertrow (1)
   dw_2.object.corp_gr [1] = dw_c.object.dddw [1]
   dw_2.object.p_ymd [1] = idt_ymd
   dw_2.object.p_proposer [1] = is_proposer
   dw_2.object.ymd [1] = f_sysdate ('')
   dw_2.object.sb_nm [1] = gnv_vari.is_user_nm
   dw_2.object.appending [1] = arg_text
   dw_2.uf_setrow (1, true)
End IF
end event

type dw_2 from u_dw within w_proposal
integer x = 3383
integer y = 2304
integer width = 2048
integer height = 460
integer taborder = 90
boolean bringtotop = true
string title = "댓글현황"
string dataobject = "d_proposal_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibtitle4datawindow = true
boolean ibsetlist4subbtn = true
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_null_line = false
string is_resize_column = "appending"
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('detail', rowcount, FALSE)
end event

event ue_retrieve;call super::ue_retrieve;retrieve (dw_c.object.dddw [1], dw_list.object.ymd [irow], dw_list.object.proposer [irow], gnv_vari.is_user_nm)
end event

event clicked;IF (row>0) And (dwo.type='column')   Then
   SelectRow (0, FALSE)
   SelectRow (row, TRUE)
End IF
end event

type ole_rd from u_rd within w_proposal
boolean visible = false
integer x = 1417
integer y = 484
integer width = 2222
integer height = 2224
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_proposal.win"
end type

type st_1 from pf_u_splitbar_vertical within w_proposal
integer x = 3355
integer y = 348
integer height = 2412
boolean bringtotop = true
boolean setcondcolor = true
string leftdragobject = "dw_list;mle_append"
string rightdragobject = "rte_func;mle_matter;mle_content;dw_2"
end type

