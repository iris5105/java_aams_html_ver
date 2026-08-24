forward
global type w_ja051d from w_winpage
end type
type rte_func1 from pf_u_richtextedit within w_ja051d
end type
type rte_func2 from pf_u_richtextedit within w_ja051d
end type
type mle_select from u_mle within w_ja051d
end type
type mle_head from u_mle within w_ja051d
end type
type ole_1 from u_rd within w_ja051d
end type
type st_move from pf_u_splitbar_vertical within w_ja051d
end type
type dw_list from u_dw within w_ja051d
end type
type cb_resql from pf_u_commandbutton within w_ja051d
end type
end forward

global type w_ja051d from w_winpage
boolean eb_direct_retrieve = true
string is_find = "table_nm=~'~' and table_seq=0"
string is_init_value = "fii@1"
rte_func1 rte_func1
rte_func2 rte_func2
mle_select mle_select
mle_head mle_head
ole_1 ole_1
st_move st_move
dw_list dw_list
cb_resql cb_resql
end type
global w_ja051d w_ja051d

type variables
STRING	is_rt_key, is_userid, is_bs

DateTime idt_cre_ymd

STR_Parameter  sp
end variables

on w_ja051d.create
int iCurrent
call super::create
this.rte_func1=create rte_func1
this.rte_func2=create rte_func2
this.mle_select=create mle_select
this.mle_head=create mle_head
this.ole_1=create ole_1
this.st_move=create st_move
this.dw_list=create dw_list
this.cb_resql=create cb_resql
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rte_func1
this.Control[iCurrent+2]=this.rte_func2
this.Control[iCurrent+3]=this.mle_select
this.Control[iCurrent+4]=this.mle_head
this.Control[iCurrent+5]=this.ole_1
this.Control[iCurrent+6]=this.st_move
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.cb_resql
end on

on w_ja051d.destroy
call super::destroy
destroy(this.rte_func1)
destroy(this.rte_func2)
destroy(this.mle_select)
destroy(this.mle_head)
destroy(this.ole_1)
destroy(this.st_move)
destroy(this.dw_list)
destroy(this.cb_resql)
end on

event wue_postopen;call super::wue_postopen;f_memo ('function table_conv', rte_func1)
f_memo ('function table_head', rte_func2)

dw_List.TAG = TITLE
dw_List.SetTRansObject (SQLCA)
dw_List.EVENT ue_dddw_retrieve ()
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
mle_select.uf_reset (FALSE)
mle_head.uf_reset (FALSE)
p_retrieve.POST EVENT clicked ()
end event

event ue_activate;call super::ue_activate;IF mle_select.displayonly  Then mle_select.backcolor = gnv_vari.setcondbackcolor &
ELSE                            mle_select.BackColor = rgb(240,255,255)
IF mle_head.displayonly Then mle_head.backcolor = gnv_vari.setcondbackcolor &
ELSE                         mle_head.BackColor = rgb(240,255,255)
rte_func1.backcolor = gnv_vari.setcondbackcolor
rte_func2.backcolor = gnv_vari.setcondbackcolor
end event

event wue_update;call super::wue_update;IF dw_List.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wPage_Modified ()  Then
   dw_List.EVENT ue_clob_update (mle_select.TEXT, mle_head.TEXT)
   IF	uf_updateCommit (dw_List)=-1 THEN RETURN -1
End IF
RETURN 1
end event

event resize;call super::resize;dw_List.Height = Height - dw_List.Y - 185

rte_func1.Y = dw_List.Y

mle_select.X = rte_func1.X
mle_select.Y = dw_List.Y + rte_func1.Height + 4
mle_select.Height = truncate((Height - mle_select.Y) * .7, 0)

rte_func2.X = rte_func1.X
rte_func2.Y = mle_select.Y + mle_select.Height + 4

mle_head.X = rte_func1.X
mle_head.Y = rte_func2.Y + rte_func2.Height + 4
mle_head.Height = Height - mle_head.Y - 185
end event

event wue_retrieve;call super::wue_retrieve;is_find = "table_nm='" + ia_value [1] + "' and table_seq=" + ia_value [2]
dw_List.retrieve ()
end event

event ue_wpage_modified;RETURN	(dw_List.uf_isModified () OR mle_select.ib_update OR mle_head.ib_update)
end event

event wue_lastopen;call super::wue_lastopen;p_retrieve.post event clicked()
end event

event open;icmdbutton = { cb_resql }
call super::open
end event

type lb_dirlist from w_winpage`lb_dirlist within w_ja051d
end type

type ln_templeft from w_winpage`ln_templeft within w_ja051d
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_ja051d
end type

type ln_temptop from w_winpage`ln_temptop within w_ja051d
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_ja051d
end type

type ln_tempstart from w_winpage`ln_tempstart within w_ja051d
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_ja051d
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_ja051d
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_ja051d
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_ja051d
end type

type ln_tempright from w_winpage`ln_tempright within w_ja051d
end type

type uo_navi from w_winpage`uo_navi within w_ja051d
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_ja051d
end type

type st_windelaytime from w_winpage`st_windelaytime within w_ja051d
end type

type st_top_rect from w_winpage`st_top_rect within w_ja051d
end type

type p_close from w_winpage`p_close within w_ja051d
end type

type p_excel from w_winpage`p_excel within w_ja051d
end type

type p_print from w_winpage`p_print within w_ja051d
end type

type p_delete from w_winpage`p_delete within w_ja051d
end type

type p_update from w_winpage`p_update within w_ja051d
end type

type p_input from w_winpage`p_input within w_ja051d
end type

type p_retrieve from w_winpage`p_retrieve within w_ja051d
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

p_clear.of_setenabled (true)
of_setenabled (false)
dw_List.uf_protect (0, dw_List.ia_protect [1])

dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_ja051d
end type

type p_copy from w_winpage`p_copy within w_ja051d
end type

type dw_c from w_winpage`dw_c within w_ja051d
boolean visible = false
integer taborder = 40
boolean enabled = false
string title = ""
end type

type btn_update from w_winpage`btn_update within w_ja051d
end type

type st_count from w_winpage`st_count within w_ja051d
end type

type rte_func1 from pf_u_richtextedit within w_ja051d
integer x = 3854
integer y = 156
integer width = 1577
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

type rte_func2 from pf_u_richtextedit within w_ja051d
integer x = 3854
integer y = 936
integer width = 1577
integer height = 92
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

type mle_select from u_mle within w_ja051d
integer x = 3854
integer y = 324
integer width = 1577
integer height = 576
integer taborder = 60
boolean bringtotop = true
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
string facename = "D2Coding"
boolean hscrollbar = true
boolean scaletoright = true
end type

event ue_print;call super::ue_print;dw_List.EVENT ue_print ()
end event

event losefocus;call super::losefocus;STRING	ls_sqlsyntax

LONG	lR

ads_jTier lds_userinfo

IF f_notnull (TEXT)  Then
   //SQLCA.SyntaxFromSQL (TEXT, 'style(type=grid)', ls_error)
	ls_sqlsyntax = TEXT

	//<임시> 조회시간이 너무 긴 경우 일부처리
	IF pos (lower (ls_sqlsyntax), 'order') > 0 Then
		IF pos (lower (ls_sqlsyntax), 'where') > 0 Then
			ls_sqlsyntax = MID (ls_sqlsyntax, 1, pos(lower (ls_sqlsyntax), 'order') - 1) + ' AND rownum = 1~r~n' + MID (ls_sqlsyntax, pos(lower (ls_sqlsyntax), 'order'))
		Else
			ls_sqlsyntax = MID (ls_sqlsyntax, 1, pos(lower (ls_sqlsyntax), 'order') - 1) + ' WHERE rownum = 1~r~n' + MID (ls_sqlsyntax, pos(lower (ls_sqlsyntax), 'order'))
		End IF	
	End IF
	
	lR = SQLCA.sql2ds (parent.classname(), TEXT, lds_userinfo, 'xml')
	
   IF lR < 0 THEN MessageBox ('DataWindow Syntax Error', SQLCA.sqlErrText())
   dw_List.SetFocus ()
End IF
end event

event constructor;//
end event

type mle_head from u_mle within w_ja051d
integer x = 3854
integer y = 1044
integer width = 1577
integer height = 576
integer taborder = 70
boolean bringtotop = true
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
string facename = "D2Coding"
boolean vscrollbar = false
boolean autovscroll = false
boolean scaletoright = true
end type

event ue_print;call super::ue_print;dw_List.EVENT ue_print ()
end event

event constructor;//
end event

event key;IF NOT ib_update Then
   ib_update = TRUE
End IF
end event

type ole_1 from u_rd within w_ja051d
boolean visible = false
integer y = 2060
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_ja051d.win"
boolean eb_directprint = true
end type

type st_move from pf_u_splitbar_vertical within w_ja051d
integer x = 3826
integer y = 156
integer height = 2608
boolean bringtotop = true
boolean setbringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_list"
string rightdragobject = "rte_func1;mle_select;rte_func2;mle_head"
integer ii_leftmargin = 10
integer ii_rightmargin = 10
end type

event constructor;call super::constructor;IF	dw_list.zoominout THEN ii_rightmargin += PixelsToUnits(12, XPixelsToUnits!)
end event

type dw_list from u_dw within w_ja051d
event ue_clob_update ( string asql,  string aheader )
integer x = 50
integer y = 156
integer width = 3762
integer height = 2608
integer taborder = 55
boolean bringtotop = true
string dataobject = "d_ja051d1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean eb_range_delcopy = false
boolean eb_copy_false = true
end type

event ue_clob_update(string asql, string aheader);IF mle_select.ib_update=FALSE And mle_head.ib_update=FALSE THEN RETURN

DEC	ldc_seq, ldc

STRING	ls_sql1 = '', ls_sql2 = '', ls_sql3 = '', ls_sql4 = '', ls_sql5 = ''

IF LenA (asql)>3000  Then
   ldc_seq = Object.table_seq [iRow]

   FOR  ldc = 1  TO truncate (LenA (asql) / 3000, 0) + 1
      CHOOSE CASE ldc
         CASE 1
            ls_sql1 = MidA (asql, 1, 3000)
         CASE 2
            ls_sql2 = MidA (asql, 3001, 3000)
         CASE 3
            ls_sql3 = MidA (asql, 6001, 3000)
         CASE 4
            ls_sql4 = MidA (asql, 9001, 3000)
         CASE 5
            ls_sql5 = MidA (asql, 12001, 3000)
         CASE ELSE
            messagebox ('15000 byte ', ' ')
            EXIT
      END CHOOSE
   NEXT

   UPDATE table_conv
      SET select_sql = TO_CLOB (:ls_sql1) || TO_CLOB (:ls_sql2) || TO_CLOB (:ls_sql3) || TO_CLOB (:ls_sql4) || TO_CLOB (:ls_sql5)
        , header_nm  = :aheader
   WHERE  table_nm  = 'FII'
     AND  table_seq = :ldc_seq;

   commitJ ()
Else
   uf_setColumn ('table_nm', 'FII')

   Object.select_sql [iRow] = asql
   Object.header_nm [iRow] = aheader
End IF

mle_select.ib_update = FALSE
mle_head.ib_update = FALSE
end event

event retrieveend;call super::retrieveend;IF f_num (rowcount )=0  Then
   mle_select.uf_reset (TRUE)
   mle_head.uf_reset (TRUE)
End IF
uf_retrieveend (is_find, rowcount, ib_manageData)
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;event ue_clob_update (mle_select.TEXT, mle_head.TEXT)
RETURN 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow

mle_select.uf_init ('', NOT mle_select.DisplayOnly)
mle_head.uf_init ('', NOT mle_head.DisplayOnly)

mle_select.TEXT = Object.select_sql [currentrow]
mle_head.TEXT = Object.header_nm [currentrow]

ia_value [1] = Object.table_nm [iRow]
ia_value [2] = string (Object.table_seq [iRow])
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;event ue_clob_update (mle_select.TEXT, mle_head.TEXT)

LONG	ll

uf_setColumn ('table_nm', 'FII')
IF rowcount ()>0  Then
   ll = dec (Object.table_seq [rowcount ()])
   uf_setcolumn ('table_seq', RIGHT ('00000'+string (ll + 1),5))
End IF
uf_setColumn ('file_copy', '0')
uf_setColumn ('send_group', 'H2O01')

POST SetColumn ('cmnt')

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_select.uf_reset (TRUE)
mle_head.uf_reset (TRUE)
RETURN 0
end event

event ue_protect;call super::ue_protect;IF ib_manageData Then
   uf_protect (row, ia_protect [1])
   mle_select.DisplayOnly = FALSE
   mle_head.DisplayOnly = FALSE
Else
   uf_protect (row, ia_protect [2])
   mle_select.DisplayOnly = TRUE
   mle_head.DisplayOnly = TRUE
End IF
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'send_group', '', '', 1, '')
end event

type cb_resql from pf_u_commandbutton within w_ja051d
integer x = 2258
integer y = 16
integer width = 384
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "SQL정리"
end type

event clicked;call super::clicked;BOOLEAN	lb_first = TRUE

LONG	ll_select, ll, ll_before, ll_first

STRING	ls_text, la_space [], ls_textace

//sql_ii_step_comment = 2

ls_text = TRIM (mle_select.TEXT)

//sql_ii_step = 0
ls_text = gre.nf_0 ('', ls_text, false)

::Clipboard (mle_select.TEXT)
mle_select.TEXT = ls_text
mle_select.ib_update = TRUE
end event

event constructor;call super::constructor;of_setvisible (gaa.aams)
end event

