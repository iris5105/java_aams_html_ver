forward
global type w_sqlrun from w_winpage
end type
type rte_func1 from pf_u_richtextedit within w_sqlrun
end type
type mle_sql from u_mle within w_sqlrun
end type
type ole_1 from u_rd within w_sqlrun
end type
type st_move from pf_u_splitbar_vertical within w_sqlrun
end type
type dw_list from u_dw within w_sqlrun
end type
type cb_run from pf_u_commandbutton within w_sqlrun
end type
type st_1 from pf_u_splitbar_horizontal within w_sqlrun
end type
type dw_result from u_dw within w_sqlrun
end type
type cb_resql from pf_u_commandbutton within w_sqlrun
end type
end forward

global type w_sqlrun from w_winpage
boolean eb_direct_retrieve = true
string is_find = "sql_title=~'~'"
string is_init_value = "run"
rte_func1 rte_func1
mle_sql mle_sql
ole_1 ole_1
st_move st_move
dw_list dw_list
cb_run cb_run
st_1 st_1
dw_result dw_result
cb_resql cb_resql
end type
global w_sqlrun w_sqlrun

type variables
STRING	is_rt_key, is_userid, is_bs

DateTime idt_cre_ymd

STR_Parameter  sp
end variables

on w_sqlrun.create
int iCurrent
call super::create
this.rte_func1=create rte_func1
this.mle_sql=create mle_sql
this.ole_1=create ole_1
this.st_move=create st_move
this.dw_list=create dw_list
this.cb_run=create cb_run
this.st_1=create st_1
this.dw_result=create dw_result
this.cb_resql=create cb_resql
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rte_func1
this.Control[iCurrent+2]=this.mle_sql
this.Control[iCurrent+3]=this.ole_1
this.Control[iCurrent+4]=this.st_move
this.Control[iCurrent+5]=this.dw_list
this.Control[iCurrent+6]=this.cb_run
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_result
this.Control[iCurrent+9]=this.cb_resql
end on

on w_sqlrun.destroy
call super::destroy
destroy(this.rte_func1)
destroy(this.mle_sql)
destroy(this.ole_1)
destroy(this.st_move)
destroy(this.dw_list)
destroy(this.cb_run)
destroy(this.st_1)
destroy(this.dw_result)
destroy(this.cb_resql)
end on

event wue_postopen;call super::wue_postopen;f_memo ('function sqlrun', rte_func1)

dw_List.TAG = TITLE
dw_List.SetTRansObject (SQLCA)
dw_List.EVENT ue_dddw_retrieve ()
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
mle_sql.uf_reset (FALSE)
dw_List.uf_reset (FALSE)
end event

event ue_activate;call super::ue_activate;IF mle_sql.displayonly  Then mle_sql.backcolor = gnv_vari.setcondbackcolor &
ELSE                         mle_sql.BackColor = rgb(240,255,255)
rte_func1.backcolor = gnv_vari.setcondbackcolor
end event

event wue_update;call super::wue_update;IF dw_list.AcceptText ()=-1 Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wPage_Modified ()  Then
   dw_list.EVENT ue_clob_update (mle_sql.TEXT)
   uf_updateCommit (dw_list)
End IF
RETURN 1
end event

event resize;call super::resize;dw_list.height = newheight - dw_result.height - 212
mle_sql.height = newheight - dw_result.height - rte_func1.height - 212
st_1.Y = dw_result.y - 8
end event

event wue_retrieve;call super::wue_retrieve;is_find = "sql_title='" + ia_value [1] + "'"
dw_List.retrieve ()
end event

event ue_wpage_modified;RETURN	(dw_list.uf_isModified () OR mle_sql.ib_update)
end event

event wue_lastopen;call super::wue_lastopen;p_retrieve.event clicked()
end event

event open;icmdbutton = { cb_run, cb_resql }
call super::open
end event

event ue_setenabled;call super::ue_setenabled;dw_result.of_dw2subbtn ({'p_excel'}, true)
end event

type lb_dirlist from w_winpage`lb_dirlist within w_sqlrun
end type

type ln_templeft from w_winpage`ln_templeft within w_sqlrun
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_sqlrun
end type

type ln_temptop from w_winpage`ln_temptop within w_sqlrun
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_sqlrun
end type

type ln_tempstart from w_winpage`ln_tempstart within w_sqlrun
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_sqlrun
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_sqlrun
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_sqlrun
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_sqlrun
end type

type ln_tempright from w_winpage`ln_tempright within w_sqlrun
end type

type uo_navi from w_winpage`uo_navi within w_sqlrun
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_sqlrun
end type

type st_windelaytime from w_winpage`st_windelaytime within w_sqlrun
end type

type st_top_rect from w_winpage`st_top_rect within w_sqlrun
end type

type p_close from w_winpage`p_close within w_sqlrun
end type

type p_excel from w_winpage`p_excel within w_sqlrun
end type

type p_print from w_winpage`p_print within w_sqlrun
end type

type p_delete from w_winpage`p_delete within w_sqlrun
end type

type p_update from w_winpage`p_update within w_sqlrun
end type

type p_input from w_winpage`p_input within w_sqlrun
end type

type p_retrieve from w_winpage`p_retrieve within w_sqlrun
end type

event p_retrieve::clicked;If gw_mdi.of_lock4processing() = -1 Then Return

IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
dw_list.of_setdestroy2filter('')
dw_list.of_setdestroy2sort('')

dw_List.uf_protect (0, dw_List.ia_protect [1])
dw_List.Enabled = FALSE ; dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_sqlrun
end type

type p_copy from w_winpage`p_copy within w_sqlrun
end type

type dw_c from w_winpage`dw_c within w_sqlrun
boolean visible = false
integer taborder = 40
boolean enabled = false
string title = ""
end type

type btn_update from w_winpage`btn_update within w_sqlrun
end type

type st_count from w_winpage`st_count within w_sqlrun
end type

type rte_func1 from pf_u_richtextedit within w_sqlrun
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

type mle_sql from u_mle within w_sqlrun
integer x = 3854
integer y = 328
integer width = 1577
integer height = 1192
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

event constructor;//
end event

type ole_1 from u_rd within w_sqlrun
boolean visible = false
integer y = 2060
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_sqlrun.win"
boolean eb_directprint = true
end type

type st_move from pf_u_splitbar_vertical within w_sqlrun
integer x = 3826
integer y = 156
integer height = 1368
boolean bringtotop = true
boolean setbringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_list"
string rightdragobject = "rte_func1;mle_sql"
integer ii_leftmargin = 10
integer ii_rightmargin = 10
end type

type dw_list from u_dw within w_sqlrun
event ue_clob_update ( string asql )
integer x = 50
integer y = 156
integer width = 3762
integer height = 1368
integer taborder = 55
boolean bringtotop = true
string dataobject = "d_sqlrun"
boolean hscrollbar = true
boolean vscrollbar = true
boolean eb_range_delcopy = false
end type

event ue_clob_update(string asql);IF mle_sql.ib_update=FALSE THEN RETURN

Object.run_sql [iRow] = asql

mle_sql.ib_update = FALSE
end event

event retrieveend;call super::retrieveend;IF f_num (rowcount )=0  Then
   mle_sql.uf_reset (TRUE)
End IF
uf_retrieveend (is_find, rowcount, ib_manageData)
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;event ue_clob_update (mle_sql.TEXT)
RETURN 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow

mle_sql.uf_init ('', NOT mle_sql.DisplayOnly)
mle_sql.TEXT = Object.run_sql [currentrow]

ia_value [1] = Object.sql_title [iRow]

RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;event ue_clob_update (mle_sql.TEXT)

STRING	ls_key

SELECT  TO_CHAR (now(),'yyyymmddhh24misssss')
  INTO  :ls_key
FROM    dual;

ls_key = SQLCA.getitemstring (1)

uf_setcolumn ('sql_key', ls_key)

POST SetColumn ('sql_title')

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_sql.uf_reset (TRUE)
RETURN 0
end event

event ue_protect;call super::ue_protect;IF ib_manageData Then
   uf_protect (row, ia_protect [1])
   mle_sql.DisplayOnly = FALSE
Else
   uf_protect (row, ia_protect [2])
   mle_sql.DisplayOnly = TRUE
End IF
end event

event ue_copyrowset;call super::ue_copyrowset;STRING	ls_key

SELECT  TO_CHAR (now(),'yyyymmddhh24misssss')
  INTO  :ls_key
FROM    dual;

ls_key = SQLCA.getitemstring (1)

Object.sql_key [row] = ls_key
end event

event doubleclicked;call super::doubleclicked;STRING	ls_table, ls_key
IF dwo.name='title_table'  Then
   ls_table = Object.title_table [row]
   SELECT  LISTAGG (id.column_name, '@') WITHIN GROUP (order by id.column_position)
     INTO  :ls_key
   FROM    user_indexes t1
         , user_ind_columns id
   WHERE   t1.table_name = :ls_table
     AND   t1.index_name = t1.table_name||'_PK'
     AND   id.index_name = t1.index_name
     AND   id.table_name = t1.table_name;

   Object.key_column [row] = lower (SQLCA.getitemstring (1))
End IF
end event

type cb_run from pf_u_commandbutton within w_sqlrun
integer x = 2231
integer y = 16
integer width = 462
integer taborder = 20
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "SQL실행"
end type

event clicked;call super::clicked;LONG	lRow

STRING	ls_text, ls_sr_err_msg, la_args[]

ls_text = TRIM (mle_sql.TEXT)
ls_text = f_replace (ls_text, ':corp_gr', gaa.corp_gr)
ls_text = f_replace (ls_text, ':workdate', string (idt_workdate, 'yyyy.mm.dd'))
ls_text = f_replace (ls_text, ':yyyymmdd', string (idt_workdate, 'yyyymmdd'))

IF	POS (lower (ls_text),'@')>0 THEN messagebox (gaa.jTier_dbname, 'DB간 자료생성이므로 접속을 확인하십시오.')

CHOOSE CASE lower (LEFT (ls_text,6))
	CASE 'declar'
		IF	POS (lower(ls_text),'insert')>0 OR POS (lower(ls_text),'update')>0 OR POS (lower(ls_text),'delete')>0	Then
			IF	gaa.login<>'yjs1992@hitel.net'	Then
				messagebox ('작업권한없음', 'DBA에게 작업의뢰 하십시오.')
				RETURN
			End IF
		End IF
		la_args[1] = ls_text
		SQLCA.singleconnection ()
		SQLCA.SP_CALL (THIS, 'SR_DDL ( ? )', la_args[], ls_sr_err_msg)
		IF SQLCA.SQLErrText()<>''	Then
			messagebox ('comment Error', SQLCA.SQLErrText())
		Else
			IF	f_null (dw_list.object.ddl_syntax [iRow]) THEN dw_list.object.ddl_syntax [iRow] = 'DECLARE'
		End IF

	CASE 'select'
		dw_result.event ue_retrieve ()
		dw_result.enabled = true
		IF	f_null (dw_list.object.ddl_syntax [iRow])                      THEN dw_list.object.ddl_syntax [iRow] = 'SELECT'
		IF	POSA (lower (ls_text),'@kfsdb')>0 And POSA (ls_text,'AS rc')>0 THEN dw_list.object.ddl_syntax [iRow] = 'DBLINK'

	CASE 'insert','update','delete'
		IF	gaa.login<>'yjs1992@hitel.net'	Then
			messagebox ('작업권한없음', 'DBA에게 작업의뢰 하십시오.')
			RETURN
		End IF
		SQLCA.dynamicsql (this, ls_text)
		IF	SQLCA.sqlcode ()=0	Then
			lRow = SQLCA.sqlnrows ( )
			messagebox ('SQL실행', 'SQL문 실행을 완료 했습니다.~r~n실행건수 : ' + f_ntrim (lRow, 0, 0))
			IF	f_null (dw_list.object.ddl_syntax [iRow]) THEN dw_list.object.ddl_syntax [iRow] = UPPER (LEFT (ls_text,6))
		Else
			messagebox('SQL실행에러', SQLCA.sqlerrtext ())
		End IF
END CHOOSE
dw_list.uf_update ()
commitJ ()
end event

type st_1 from pf_u_splitbar_horizontal within w_sqlrun
integer x = 50
integer y = 1532
integer width = 5381
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletoright = false
string topdragobject = "dw_list;st_move;mle_sql"
string bottomdragobject = "dw_result"
end type

type dw_result from u_dw within w_sqlrun
integer x = 50
integer y = 1556
integer width = 5381
integer height = 1208
integer taborder = 70
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0010000000"
end type

event ue_retrieve;call super::ue_retrieve;str_dw_base ldw

STRING	ls_select, errors, ls_table_name, ls_column_name, ls_comments, ls_length, ls_modify = ''

LONG	ll_result, ll, ll_col, lm, ll_max, ll_row

ls_select = mle_sql.TEXT
ls_select = f_replace (ls_select,':corp_gr', gaa.corp_gr)
ls_select = f_replace (ls_select, ':workdate', string (idt_workdate, 'yyyy.mm.dd'))
ls_select = f_replace (ls_select, ':yyyymmdd', string (idt_workdate, 'yyyymmdd'))

ldw.fseq = TRUE

IF dw_list.object.ddl_syntax [iRow]='DBLINK' Then
   ls_table_name = dw_list.object.title_table [iRow]
   IF f_notnull (ls_table_name)  Then
      SELECT  LISTAGG (nvl(t2.comments,t1.column_name), '@') WITHIN GROUP (order by t1.column_id)
				, LISTAGG (CASE when t1.data_type='NUMBER' And t1.data_length=22 THEN 0 ELSE t1.data_length END, '@') WITHIN GROUP (order by t1.column_id)
        INTO  :ls_comments
		      , :ls_length
      FROM    user_tab_columns t1
            , user_col_comments t2
      WHERE   t1.table_name  = :ls_table_name
        AND   t2.table_name  = t1.table_name
        AND   t2.column_name = t1.column_name;

      ls_comments = 'row_color@' + SQLCA.getitemstring (1)
      ls_length = '-1@' + SQLCA.getitemstring (2)
      f_get_array (ls_comments, '@', ldw.header_text)
      f_get_array (ls_length, '@', ldw.column_width)
   Else
      ldw.header_text = null_a
   End IF
End IF

ll_result = SQLCA.sql2dw (ls_select, dw_result, ldw)
IF LenA (SQLCA.sqlerrtext ())>0  Then
   ::CLIPBOARD (SQLCA.sqlerrtext ())
   messagebox ("sqlselect error==>",SQLCA.sqlerrtext ())
   RETURN
End IF

IF dw_list.object.ddl_syntax [iRow]<>'DBLINK'   Then
   ls_table_name = dw_list.object.title_table [iRow]
   ll_col = integer (Object.DataWindow.Column.Count)
   FOR  ll = 1  TO  ll_col
      ls_column_name = UPPER (describe ("#" + string (ll) + ".name"))
      ll_max = long (describe ('#'+string (ll)+".width"))
      IF f_notnull (ls_table_name)  Then
         SELECT  comments
           INTO  :ls_comments
         FROM    user_col_comments t1
         WHERE   t1.table_name  = :ls_table_name
           AND   t1.column_name = :ls_column_name;
         IF SQLCA.sqlcode ()=0   Then
            ls_comments = SQLCA.getitemstring (1)
            IF POS (ls_comments,'~r')>0   Then
               ls_comments = MID (ls_comments, POS (ls_comments,'~r') - 1)
            ElseIF POS (ls_comments,'~n')>0  Then
               ls_comments = MID (ls_comments, POS (ls_comments,'~n') - 1)
            End IF
            IF f_notnull (ls_comments) Then
               ls_modify += ls_column_name + "_t.text='" + ls_comments + "' "
               ll_max = MAX (LenA(ls_comments) * PixelsToUnits(8, XPixelsToUnits!), ll_max)
            End IF
         End IF
      End IF
      ll_row = MIN (100, ll_result)
      CHOOSE CASE LEFT (describe ('#'+string (ll)+".coltype"), 4)
         CASE 'date'
            CONTINUE
         CASE 'numb','deci'
            FOR  lm = 1  TO  ll_row
               ll_max = MAX ((LenA(string (f_nvl (string (getitemnumber (lm, ll)), ''))) + 2) * PixelsToUnits(8, XPixelsToUnits!), ll_max)
            NEXT
         CASE ELSE
            FOR  lm = 1  TO  ll_row
               ll_max = MAX ((LenA(string (f_nvl (getitemstring (lm, ll), ''))) + 2) * PixelsToUnits(8, XPixelsToUnits!), ll_max)
            NEXT
      END CHOOSE
      ls_modify += '#' + string (ll) + ".width=" + string (ll_max) + ' '
   NEXT
   MODIFY (ls_modify)
End IF

uf_retrieveend ('', ll_result, eb_null_line)
end event

event oue_subbtn_excel;f_saveas_new (this)
end event

type cb_resql from pf_u_commandbutton within w_sqlrun
integer x = 2706
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

ls_text = TRIM (mle_sql.TEXT)

//sql_ii_step = 0
ls_text = gre.nf_0 ('', ls_text, false)

::Clipboard (mle_sql.TEXT)
mle_sql.TEXT = ls_text
mle_sql.ib_update = TRUE
end event

event constructor;call super::constructor;of_setvisible ((gaa.login = 'yjs1992@hitel.net'))
end event

