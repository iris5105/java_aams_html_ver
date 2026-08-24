forward
global type w_history from w_winpage
end type
type dw_list from u_dw within w_history
end type
type rte_func from pf_u_richtextedit within w_history
end type
type mle_blob from u_mle within w_history
end type
type sle_search_text from pf_u_singlelineedit within w_history
end type
type cb_2 from pf_u_commandbutton within w_history
end type
type st_1 from pf_u_splitbar_vertical within w_history
end type
end forward

global type w_history from w_winpage
dw_list dw_list
rte_func rte_func
mle_blob mle_blob
sle_search_text sle_search_text
cb_2 cb_2
st_1 st_1
end type
global w_history w_history

type variables
DateTime idt_gijun

STRING	is_BFname, is_rt_key

STR_Parameter  sp
end variables

on w_history.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rte_func=create rte_func
this.mle_blob=create mle_blob
this.sle_search_text=create sle_search_text
this.cb_2=create cb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rte_func
this.Control[iCurrent+3]=this.mle_blob
this.Control[iCurrent+4]=this.sle_search_text
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_1
end on

on w_history.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.rte_func)
destroy(this.mle_blob)
destroy(this.sle_search_text)
destroy(this.cb_2)
destroy(this.st_1)
end on

event ue_activate;call super::ue_activate;IF mle_blob.DisplayOnly THEN mle_blob.BackColor = 15790320 &
Else                         mle_blob.BackColor = rgb (240,255,255)
end event

event resize;call super::resize;rte_func.X = dw_List.X + dw_List.width + 12
rte_func.Width = Width - rte_func.X - 116

mle_blob.X = rte_func.X
mle_blob.Width = rte_func.Width

dw_List.ScrollToRow (dw_List.getrow ())
end event

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve (dw_c.object.ymd [1])
end event

event ue_wpage_modified;RETURN	(dw_list.uf_isModified () OR mle_blob.ib_update)
end event

event close;call super::close;DELETE  rowid_in
WHERE   rt_key = :is_rt_key;
commitJ ()
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
mle_blob.uf_reset (FALSE)
dw_List.uf_reset (FALSE)
dw_List.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)
end event

event wue_lastinst;call super::wue_lastinst;f_memo ('function history', rte_func)

dw_List.SetTRansObject (SQLCA)
dw_List.EVENT ue_dddw_retrieve ()

SELECT  :idt_workdate - 7
  INTO  :idt_gijun
FROM    dual;

idt_gijun = SQLCA.getitemdatetime (1)

dw_c.object.ymd [1] = f_add_months (idt_workdate, -12, null_dt)

p_retrieve.POST EVENT clicked ()
end event

event wue_delete;RETURN dw_list.EVENT ue_delete ()
end event

event wue_update;call super::wue_update;IF dw_List.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_modified () Then
   IF mle_blob.EVENT ue_blob_update (iRow)=1 THEN RETURN -1
   RETURN uf_updateCommit (dw_List)
End IF
RETURN 1
end event

type lb_dirlist from w_winpage`lb_dirlist within w_history
end type

type ln_templeft from w_winpage`ln_templeft within w_history
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_history
end type

type ln_temptop from w_winpage`ln_temptop within w_history
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_history
end type

type ln_tempstart from w_winpage`ln_tempstart within w_history
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_history
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_history
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_history
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_history
end type

type ln_tempright from w_winpage`ln_tempright within w_history
end type

type uo_navi from w_winpage`uo_navi within w_history
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_history
end type

type st_windelaytime from w_winpage`st_windelaytime within w_history
end type

type st_top_rect from w_winpage`st_top_rect within w_history
end type

type p_close from w_winpage`p_close within w_history
end type

type p_excel from w_winpage`p_excel within w_history
end type

type p_print from w_winpage`p_print within w_history
end type

type p_delete from w_winpage`p_delete within w_history
end type

type p_update from w_winpage`p_update within w_history
end type

type p_input from w_winpage`p_input within w_history
end type

type p_retrieve from w_winpage`p_retrieve within w_history
end type

event p_retrieve::clicked;dw_List.uf_DataObject ('d_history', FALSE)

IF	ib_managedata	Then
   dw_c.Enabled = FALSE
	IF	p_clear.visible	Then
		p_clear.of_setenabled (true)
		of_setenabled (false)
	End IF
	dw_List.uf_protect (0, dw_List.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2])
End IF

dw_List.Enabled = FALSE

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_history
end type

type p_copy from w_winpage`p_copy within w_history
end type

type dw_c from w_winpage`dw_c within w_history
string tag = "시스템 수정내역을 관리 합니다."
string title = "조회기준일"
string dataobject = "dc_ymd"
end type

type btn_update from w_winpage`btn_update within w_history
end type

type st_count from w_winpage`st_count within w_history
end type

type dw_list from u_dw within w_history
integer x = 50
integer y = 348
integer width = 4087
integer height = 2356
boolean bringtotop = true
string dataobject = "d_history"
boolean vscrollbar = true
boolean scaletobottom = true
boolean eb_always_1_insert = true
boolean eb_copy_false = true
end type

event retrieveend;call super::retrieveend;IF f_num (rowcount )=0 THEN mle_blob.uf_reset (TRUE)
uf_retrieveend (is_find, rowcount, ib_manageData)
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;RETURN  mle_blob.EVENT ue_blob_update (iRow)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;DateTime ldt

STRING	ls_data = ''

iRow = currentrow

is_BFname = Object.bfname [iRow]

SELECT  clob_s
  INTO  :ls_data
FROM    history_blob t1
WHERE   bfname = :is_BFname;

ls_data = SQLCA.getitemstring (1)

mle_blob.uf_init ('', NOT mle_blob.DisplayOnly)
mle_blob.TEXT = ls_data

IF dataobject='d_history_search' Then
   LONG	lPos
   lPos = POS (mle_blob.TEXT, mle_blob.is_search) ; mle_blob.SelectText (lPos, Len (mle_blob.is_search))
End IF

RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF mle_blob.EVENT ue_blob_update (iRow)=1 THEN RETURN 1

is_BFname = f_sysdate_str ('') + '_' + gnv_vari.is_user_id

IF getrow ()>0 THEN uf_SetColumn ('sebu_cd', object.sebu_cd [getrow ()])
uf_SetColumn ('ymd', string (idt_workdate))
uf_SetColumn ('bfname', is_BFname)

POST SetColumn ('sebu_cd')

RETURN 0
end event

event ue_protect;call super::ue_protect;IF ib_manageData Then
   IF gaa.admin OR gaa.aams	Then
      uf_protect (row, ia_protect [1])
      mle_blob.DisplayOnly = FALSE
   Else
      IF Object.ymd [row]<idt_gijun Then
         uf_protect (row, ia_protect [2])
         mle_blob.DisplayOnly = TRUE
         gw_mdi.setmicrohelp ('작업일자가 수정가능한 일수(7일)를 넘었습니다.')
      Else
         uf_protect (row, ia_protect [1])
         mle_blob.DisplayOnly = FALSE
      End IF
   End IF
Else
   uf_protect (row, ia_protect [2])
   mle_blob.DisplayOnly = TRUE
End IF
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sebu_cd', gaa.corp_gr, '', 1, '')
end event

event ue_deleterow;call super::ue_deleterow;is_BFname = Object.bfname [row]

DELETE  history_blob
WHERE   bfname = :is_BFname;
IF SQLCA.SQLCode()<>0  Then
   f_messageBox ('SQLCA', 'DELETE history_lob')
   RETURN
End IF
end event

event buttonup;call super::buttonup;STRING	ls_path, ls_local, ls_bfname, ls_open

BLOB	lb_data

BOOLEAN	lb_return

LONG	li_count

CHOOSE CASE dwo.name
	CASE 'p_fexp'
		AcceptText ()
		uf_setrow (row, false)
		IF parent.EVENT wue_update ()=-1 THEN RETURN

		ls_bfname = Object.BFname [row]

		IF GetFileOpenName ("Select File", ls_path, ls_local, "pdf", "PDF File/Word 문서/HWP 문서/Excel 통합 문서,*.pdf;*.doc?;*.hwp;*.xls?,모든 자료 (*.*),*.*" )<>1 THEN RETURN

      SELECT COUNT (*)
		  INTO :li_count
		FROM   history_blob
      WHERE  bfname = :ls_bfname;

		li_count = SQLCA.getitemnumber (1)

		IF li_count=0	Then
         INSERT INTO  history_blob (
                  bfname )                         /* _1: */
         VALUES ( :ls_bfname                        /* _1: */
                );
      End IF

		lb_data = BLOB(" ")

		filedelete (ls_path + '.zip')
		IF	mo_.zip (ls_path, ls_path + '.zip', 'f')<>0	Then
			f_messagebox ('압축실패!','자료를 다시 LOAD하십시오.')
			RETURN
		Else
			SQLCA.setupdateBLOB_file (ls_path + '.zip')
			Object.org_fname [row] = ls_local
		End IF

		UPDATEBLOB  history_blob
			SET  blob_f = :lb_data
		WHERE   bfname = :ls_bfname;

		Object.fexp [row] = MID (ls_local, LASTPOS (ls_local,'.') + 1)

		filedelete (ls_path + '.zip')

	CASE 'p_fexp_open'
		uf_setrow (row, false)

		ls_bfname = Object.BFname [row]

      SELECTBLOB  blob_f
        INTO  :lb_data
      FROM    history_blob  t1
		WHERE   t1.bfname = :ls_bfname;

		enabled = false

		ls_open = Object.org_fname [row]

		IF	f_notnull (ls_open)	Then
	      filedelete (gaa.temp + ls_open + '.zip')
	      filedelete (gaa.temp + ls_open)
			lb_return = mo_.hex2file (gaa.temp + ls_open + '.zip', SQLCA.is_Hexfile)
			IF	lb_return	Then
				/* 압축풀기... */
				mo_.unzip (gaa.temp + ls_open + '.zip', gaa.temp)
				filedelete (gaa.temp + ls_open + '.zip')
			End IF
		Else
			ls_open = "__tmp" + string (now (),"hhmmssfff") + gnv_vari.is_user_id + '.' + Object.fexp [row]
			lb_return = mo_.Hex2File (gaa.temp + ls_open, SQLCA.is_HexFile)
		End IF

		ShellExecute (HANDLE (gw_mdi), 'open', ls_open, '', gaa.temp, 1)

		enabled = true
END CHOOSE
end event

event doubleclicked;call super::doubleclicked;IF row=0 THEN RETURN

IF	dwo.name='fexp'	Then
	STRING	ls_bfname, ls_path, ls_local

	BLOB	lb_data

	LONG	ll_rtn

	IF f_notnull (Object.fexp [row]) And Object.p_visible [row]=1	Then
		IF parent.EVENT wue_update ()=-1 THEN RETURN
		uf_setrow (row, false)
		ls_bfname = Object.bfname [row]

		ll_rtn = f_messageBox ('RUN2', '등록된 파일이 있습니다.~r~n파일을 변경(취소시 삭제)하시겠습니까?')
		IF ll_rtn=2 THEN RETURN
		IF ll_rtn=3 Then
			IF f_messageBox ('INFO2', '파일을 삭제 하시겠습니까?')=2 THEN RETURN
			Object.fexp [row] = null_s
			Object.org_fname [row] = null_s
	
			DELETE history_blob t1
			WHERE   t1.bfname = :ls_bfname;

			commitJ ()

			RETURN
		End IF

		IF GetFileOpenName ("Select File", ls_path, ls_local, "pdf", "PDF File/Word 문서/HWP 문서/Excel 통합 문서,*.pdf;*.doc?;*.hwp;*.xls?,모든 자료 (*.*),*.*" )<>1 THEN RETURN

		lb_data = BLOB(" ")

		filedelete (ls_path + '.zip')
		IF	mo_.zip (ls_path, ls_path + '.zip', 'f')<>0	Then
			f_messagebox ('압축실패!','자료를 다시 LOAD하십시오.')
			RETURN
		Else
			SQLCA.setupdateBLOB_file (ls_path + '.zip')
			Object.org_fname [row] = ls_local
		End IF

		UPDATEBLOB  history_blob
			SET  blob_f = :lb_data
		WHERE   bfname = :ls_bfname;

		Object.fexp [row] = MID (ls_local, LASTPOS (ls_local,'.') + 1)

		filedelete (ls_path + '.zip')
	End IF
End IF
end event

type rte_func from pf_u_richtextedit within w_history
integer x = 4165
integer y = 348
integer width = 1266
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long init_backcolor = 16777215
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
boolean scaletoright = true
end type

type mle_blob from u_mle within w_history
integer x = 4165
integer y = 456
integer width = 1266
integer height = 2248
integer taborder = 40
boolean bringtotop = true
borderstyle borderstyle = stylebox!
boolean scaletoright = true
boolean scaletobottom = true
end type

event ue_blob_update;call super::ue_blob_update;IF NOT ib_update THEN RETURN 0

INT li_count

SELECT COUNT (*)
  INTO :li_count
FROM   history_blob
WHERE  bfname = :is_bfname;

li_count = SQLCA.getitemnumber (1)

IF li_count > 0 THEN
	UPDATE  history_blob
		SET  clob_s = :TEXT
	WHERE   bfname = :is_bfname;
ELSE
   gw_mdi.setmicrohelp (is_bfname + ' 생성')
   INSERT INTO  history_blob (
                  bfname                           /* _1: */
                , clob_s )                         /* _2: */
   VALUES ( :is_bfname                                 /* _1: */
          , :TEXT                                      /* _2: */
          );
   IF SQLCA.SQLCode()<>0 THEN MessageBox ('history_blob INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())
End IF

ib_update = FALSE

RETURN 0
end event

type sle_search_text from pf_u_singlelineedit within w_history
integer x = 1975
integer y = 192
integer width = 1175
integer height = 92
integer taborder = 60
boolean bringtotop = true
long textcolor = 33554432
end type

type cb_2 from pf_u_commandbutton within w_history
integer x = 3168
integer y = 188
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "검색"
end type

event clicked;call super::clicked;IF f_null (sle_search_text.TEXT) THEN RETURN
IF Parent.EVENT wue_confirmupdate4close ()=1 THEN RETURN

STRING	ls_bun, ls_title, ls_subject, ls_bfname, ls_like, ls_sqlsyntax

LONG	lR, ll

aDS_jTier   lds_jtier

DELETE rowid_in
WHERE  rt_key = :is_rt_key;

is_rt_key = gaa.corp_gr + gnv_vari.is_user_id + f_sysdate_str ('')

ls_sqlsyntax = "   SELECT  t1.title " &
             + "         , t2.clob_s " &
             + "         , t1.bfname " &
             + "   FROM    history t1 " &
             + "         , history_blob t2 " &
             + "   WHERE   t2.bfname = t1.bfname "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

ls_like = sle_search_text.TEXT

FOR  ll = 1  TO  lR
   ls_title   = lds_jtier.getitemstring (ll, 1)
   ls_subject = lds_jtier.getitemstring (ll, 2)
   ls_bfname  = lds_jtier.getitemstring (ll, 3)

   IF POS (lower (ls_title), lower (ls_like))>0 OR POS (lower (ls_subject), lower (ls_like))>0  Then
      INSERT INTO rowid_in
      VALUES ( :is_rt_key    /* _1: */
             , :ls_bfname    /* _2: */
             );
   End IF
NEXT

mle_blob.uf_init (ls_like, FALSE)

ib_managedata = FALSE
dw_List.uf_DataObject ('d_history_search', FALSE)
IF dw_List.retrieve (is_rt_key)=0   Then
   sle_search_text.POST SetFocus ()
Else
   dw_List.POST SetFocus ()
End IF
end event

type st_1 from pf_u_splitbar_vertical within w_history
integer x = 4142
integer y = 352
integer height = 2352
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_list"
string rightdragobject = "rte_func;mle_blob"
end type

