forward
global type w_ja060a from w_winpage
end type
type ole_1 from u_rd within w_ja060a
end type
type dw_list from u_dw within w_ja060a
end type
type rte_func from pf_u_richtextedit within w_ja060a
end type
type mle_detail from u_mle within w_ja060a
end type
type st_1 from pf_u_splitbar_vertical within w_ja060a
end type
end forward

global type w_ja060a from w_winpage
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
ole_1 ole_1
dw_list dw_list
rte_func rte_func
mle_detail mle_detail
st_1 st_1
end type
global w_ja060a w_ja060a

type variables
LONG	il_count
end variables

on w_ja060a.create
int iCurrent
call super::create
this.ole_1=create ole_1
this.dw_list=create dw_list
this.rte_func=create rte_func
this.mle_detail=create mle_detail
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rte_func
this.Control[iCurrent+4]=this.mle_detail
this.Control[iCurrent+5]=this.st_1
end on

on w_ja060a.destroy
call super::destroy
destroy(this.ole_1)
destroy(this.dw_list)
destroy(this.rte_func)
destroy(this.mle_detail)
destroy(this.st_1)
end on

event wue_postopen;call super::wue_postopen;dw_c.setfocus ()
f_memo ('function sics040', rte_func)

dw_list.TAG = TITLE
dw_list.SetTRansObject (SQLCA)
dw_list.EVENT ue_dddw_retrieve ()

IF eb_direct_retrieve THEN p_retrieve.post event clicked()
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
mle_detail.uf_reset (FALSE)

dw_list.uf_reset (FALSE)
dw_list.of_setdestroy2filter('')
dw_list.of_setdestroy2sort('')
dw_list.Modify (dw_list.ia_protect [4])
dw_list.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)
RETURN
end event

event ue_activate;call super::ue_activate;IF mle_detail.displayonly  Then mle_detail.backcolor = gnv_vari.setcondbackcolor &
ELSE                           mle_detail.BackColor = rgb(240,255,255)
rte_func.backcolor = gnv_vari.setcondbackcolor
end event

event wue_update;call super::wue_update;IF dw_List.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_Modified () Then
   dw_List.EVENT ue_clob_update (mle_detail.TEXT)
   IF uf_updateCommit (dw_List)=-1	THEN RETURN -1
End IF
RETURN 1
end event

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.fymd [1], dw_c.object.tymd [1])
end event

event ue_wpage_modified;IF dw_List.uf_isModified ()=FALSE And mle_detail.ib_update=FALSE THEN RETURN FALSE
RETURN TRUE
end event

event wue_lastopen;call super::wue_lastopen;DateTime ldt_f, ldt_t

SELECT  f_bungi_ymd (:idt_workdate, -13)
      , f_bungi_ymd (:idt_workdate, -1)
  INTO  :ldt_f
      , :ldt_t
FROM    dual;

ldt_f = SQLCA.getitemdatetime (1)
ldt_t = SQLCA.getitemdatetime (2)

dw_c.object.fymd [1] = ldt_f
dw_c.object.tymd [1] = ldt_t

end event

event wue_copy;STRING	ls_text
INT	li_rtn = 0

IF	POS ('51,52,8',dw_list.object.text_gb [iRow])>0 THEN ls_text = mle_detail.text

li_rtn = dw_list.EVENT ue_copyrow ()

IF	POS ('51,52,8',dw_list.object.text_gb [iRow])>0	Then
	mle_detail.text = ls_text
	dw_List.EVENT ue_clob_update (ls_text)
End IF

dw_list.object.ymd [iRow] = dw_c.object.tymd [1]
dw_list.object.load_exp [iRow] = null_s
dw_list.object.p_visible [iRow] = 1

RETURN li_rtn
end event

type lb_dirlist from w_winpage`lb_dirlist within w_ja060a
end type

type ln_templeft from w_winpage`ln_templeft within w_ja060a
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_ja060a
end type

type ln_temptop from w_winpage`ln_temptop within w_ja060a
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_ja060a
end type

type ln_tempstart from w_winpage`ln_tempstart within w_ja060a
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_ja060a
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_ja060a
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_ja060a
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_ja060a
end type

type ln_tempright from w_winpage`ln_tempright within w_ja060a
end type

type uo_navi from w_winpage`uo_navi within w_ja060a
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_ja060a
end type

type st_windelaytime from w_winpage`st_windelaytime within w_ja060a
end type

type st_top_rect from w_winpage`st_top_rect within w_ja060a
end type

type p_close from w_winpage`p_close within w_ja060a
end type

type p_excel from w_winpage`p_excel within w_ja060a
end type

type p_print from w_winpage`p_print within w_ja060a
end type

type p_delete from w_winpage`p_delete within w_ja060a
end type

type p_update from w_winpage`p_update within w_ja060a
end type

type p_input from w_winpage`p_input within w_ja060a
end type

type p_retrieve from w_winpage`p_retrieve within w_ja060a
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF	p_clear.visible=false	Then
	IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
	dw_list.of_setdestroy2filter('')
	dw_list.of_setdestroy2sort('')
End IF

dw_c.Enabled = FALSE
IF	p_clear.visible	Then
	p_clear.of_setenabled (true)
	of_setenabled (false)
End IF
dw_List.uf_protect (0, dw_List.ia_protect [1])

dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_ja060a
end type

type p_copy from w_winpage`p_copy within w_ja060a
end type

type dw_c from w_winpage`dw_c within w_ja060a
string tag = " "
integer taborder = 40
string title = "명세서기준구간"
string dataobject = "dc_ftymd"
end type

type btn_update from w_winpage`btn_update within w_ja060a
end type

type st_count from w_winpage`st_count within w_ja060a
end type

type ole_1 from u_rd within w_ja060a
boolean visible = false
integer y = 2060
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_ja060a.win"
boolean eb_directprint = true
end type

type dw_list from u_dw within w_ja060a
event ue_clob_update ( string adetail )
integer x = 41
integer y = 348
integer width = 3689
integer height = 2416
integer taborder = 55
boolean bringtotop = true
string dataobject = "d_ja060a1"
boolean hscrollbar = true
boolean vscrollbar = true
string is_receivetype = "sqlm"
boolean scaletobottom = true
boolean eb_range_delcopy = false
boolean eb_always_1_insert = true
end type

event ue_clob_update(string adetail);IF mle_detail.ib_update=FALSE THEN RETURN
Object.text [iRow] = adetail
mle_detail.ib_update = FALSE
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, ib_manageData)
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;IF mle_detail.ib_update	Then
	Object.text [currentrow] = mle_detail.TEXT
	Object.text_gr [currentrow] = f_sysdate ('')
End IF

RETURN 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow
IF GetItemStatus (currentrow, 0, Primary!)=New! OR GetItemStatus (currentrow, 0, Primary!)=NewModified! OR Object.p_visible [currentrow]=1	Then
   uf_protect (currentrow, ia_protect [1], TRUE, FALSE, TRUE)
   mle_detail.BackColor = RGB (240,255,255)
   mle_detail.uf_init ('', TRUE)
Else
   uf_protect (currentrow, ia_protect [2], TRUE, TRUE, FALSE)
   mle_detail.backcolor = gnv_vari.setcondbackcolor
   mle_detail.uf_init ('', FALSE)
End IF
mle_detail.TEXT = Object.text [currentrow]

RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;event ue_clob_update (mle_detail.TEXT)

uf_setColumn ('fs_gb', 'F')
IF rowcount ()=0  Then
   uf_setColumn ('text_gb', '')
   uf_setColumn ('ymd', string (f_last_day (idt_workdate)))
Else
   uf_setColumn ('text_gb', Object.text_gb [iRow])
   uf_setColumn ('ymd', string (Object.ymd [iRow]))
End IF

POST SetColumn ('fs_cd')

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_detail.uf_reset (TRUE)
RETURN 0
end event

event ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
   CASE 'fs_cd'
      rs_addrow = "%,전체"
END CHOOSE
RETURN 1
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'text_gb', gaa.corp_gr, '', 1, "sebu_cd not like '9%'")
end event

event oue_keydown;IF	KeyDown(KeyControl!) THEN RETURN 1
call super::oue_keydown
end event

event updatestart;call super::updatestart;LONG	ll_row=0

DO WHILE ll_row <= rowcount()
	ll_row = dw_list.GetNextModified(ll_row, Primary!)
	IF ll_row > 0 Then
		IF f_null (dw_list.Object.text_gb [ll_row]) Then
			f_messageBox ('W007', string (ll_row) + '행 자료구분')
			SetColumn('text_gb')
			RETURN 1
		End IF
		
		IF f_null (dw_list.Object.fs_cd [ll_row]) Then
			f_messageBox ('W007', string (ll_row) + '행 MP코드')
			SetColumn('fs_cd')
			RETURN 1
		End IF
	Else
		EXIT
	End IF
LOOP
end event

event buttonup;call super::buttonup;IF ROW=0 THEN RETURN

STRING	ls_fname, ls_path, ls_fund_cd, ls_local, ls_blob_err
STRING	ls_fs_gb, ls_fs_cd, ls_text_gb

BOOLEAN	lb_return

BLOB	lb_data

INT   file_no, ll_blob

DATETIME	ldt_ymd

CHOOSE CASE DWO.NAME
   CASE 'p_load_exp'
      uf_setrow (ROW, FALSE)
      ls_fname = gaa.pdf + '(' + STRING (Object.ymd [row], 'yyyy.mm') + ').' + Object.load_exp [row]

      parent.EVENT wue_update ()

      FileDelete (ls_fname)

      ls_fs_gb   = Object.fs_gb [row]
      ls_fs_cd   = Object.fs_cd [row]
      ldt_ymd    = Object.ymd [row]
      ls_text_gb = Object.text_gb [row]

      SELECTBLOB load_file
        INTO :lb_data
        FROM SPT1TX t1
       WHERE CORP_GR = :gaa.CORP_GR
         AND fs_gb   = :ls_fs_gb
         AND fs_cd   = :ls_fs_cd
         AND ymd     = :ldt_ymd
         AND text_gb = :ls_text_gb ;
      IF SQLCA.SQLCode () <> 0   Then
         F_MESSAGEBOX ('I002', '  .')
      ELSE
         lb_return = mo_.Hex2File (ls_fname, SQLCA.is_HexFile)
         IF NOT lb_return  Then
            F_MESSAGEBOX ('ERR', '')
         END IF
         gnv_extfunc.of_shellexecute (ls_fname)
      END IF
      ChangeDirectory (gnv_vari.basepath)

   CASE 'p_add_exp'
      uf_setrow (ROW, FALSE)

      ls_fund_cd = Object.fs_cd [row]
      ldt_ymd    = Object.ymd [row]
      ls_text_gb = Object.text_gb [row]

      IF GetFileOpenName ("Select File", ls_path, ls_local, "pdf", "PDF File,*.pdf;  (*.*),*.*" )<>1 THEN RETURN
      file_no = FileOpen (ls_path, StreamMode!, Read!, Shared!)
      FileReadEx (file_no, lb_data); FileClose (file_no)

      ll_blob = mo_.blob2hex (lb_data,SQLCA.is_updateblob,ls_blob_err)
      lb_data = blob (" ")

      UPDATEBLOB SPT1TX
         SET load_file = :lb_data
       WHERE CORP_GR = :gaa.CORP_GR
         AND fs_gb   = 'F'
         AND fs_cd   = :ls_fund_cd
         AND ymd     = :ldt_ymd
         AND text_gb = :ls_text_gb ;
      IF SQLCA.SQLCode () <> 0   Then
         MESSAGEBOX ('ERR', 'UPDATEBLOB ' + ls_local)
         RETURN
      END IF
      commitJ ()

      Object.load_exp [row] = f_replace (RightA (ls_local, 4), '.', '')

      ChangeDirectory (gnv_vari.basepath)

      IF uf_update ()=FALSE THEN RETURN
END CHOOSE
end event

type rte_func from pf_u_richtextedit within w_ja060a
integer x = 3781
integer y = 348
integer width = 1650
integer height = 160
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long init_backcolor = 67108864
boolean enabled = false
boolean border = false
boolean scaletoright = true
end type

event constructor;backcolor = gnv_vari.setcondbackcolor
end event

type mle_detail from u_mle within w_ja060a
integer x = 3781
integer y = 524
integer width = 1650
integer height = 2240
integer taborder = 60
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean scaletoright = true
boolean scaletobottom = true
end type

type st_1 from pf_u_splitbar_vertical within w_ja060a
integer x = 3749
integer y = 348
integer height = 2416
boolean bringtotop = true
boolean setcondcolor = true
string leftdragobject = "dw_list"
string rightdragobject = "rte_func;mle_detail"
end type

