forward
global type w_dblink from wt_list
end type
type st_1 from pf_u_splitbar_vertical within w_dblink
end type
type dw_dblink from u_dw within w_dblink
end type
type cb_run from pf_u_commandbutton within w_dblink
end type
type dw_this from u_dw within w_dblink
end type
type st_move from pf_u_splitbar_horizontal within w_dblink
end type
end forward

global type w_dblink from wt_list
boolean eb_direct_retrieve = true
boolean ib_managedata = false
st_1 st_1
dw_dblink dw_dblink
cb_run cb_run
dw_this dw_this
st_move st_move
end type
global w_dblink w_dblink

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

on w_dblink.create
int iCurrent
call super::create
this.st_1=create st_1
this.dw_dblink=create dw_dblink
this.cb_run=create cb_run
this.dw_this=create dw_this
this.st_move=create st_move
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_dblink
this.Control[iCurrent+3]=this.cb_run
this.Control[iCurrent+4]=this.dw_this
this.Control[iCurrent+5]=this.st_move
end on

on w_dblink.destroy
call super::destroy
destroy(this.st_1)
destroy(this.dw_dblink)
destroy(this.cb_run)
destroy(this.dw_this)
destroy(this.st_move)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
dw_this.of_settitle4datawindow ()
dw_dblink.of_settitle4datawindow ()
end event

event open;icmdbutton = { cb_run }
call super::open
end event

event wue_update;call super::wue_update;IF	AncestorReturnValue=-1 THEN RETURN -1
dw_this.update ()
dw_dblink.update ()
commitJ ()
RETURN 1
end event

type lb_dirlist from wt_list`lb_dirlist within w_dblink
end type

type ln_templeft from wt_list`ln_templeft within w_dblink
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_dblink
end type

type ln_temptop from wt_list`ln_temptop within w_dblink
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_dblink
end type

type ln_tempstart from wt_list`ln_tempstart within w_dblink
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_dblink
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_dblink
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_dblink
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_dblink
end type

type ln_tempright from wt_list`ln_tempright within w_dblink
end type

type uo_navi from wt_list`uo_navi within w_dblink
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_dblink
end type

type st_windelaytime from wt_list`st_windelaytime within w_dblink
end type

type st_top_rect from wt_list`st_top_rect within w_dblink
end type

type p_close from wt_list`p_close within w_dblink
end type

type p_excel from wt_list`p_excel within w_dblink
end type

type p_print from wt_list`p_print within w_dblink
end type

type p_delete from wt_list`p_delete within w_dblink
end type

type p_update from wt_list`p_update within w_dblink
end type

type p_input from wt_list`p_input within w_dblink
end type

type p_retrieve from wt_list`p_retrieve within w_dblink
end type

type p_clear from wt_list`p_clear within w_dblink
end type

type p_copy from wt_list`p_copy within w_dblink
end type

type dw_c from wt_list`dw_c within w_dblink
string title = "점검일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_list`btn_update within w_dblink
end type

type st_count from wt_list`st_count within w_dblink
end type

type dw_list from wt_list`dw_list within w_dblink
integer height = 1092
string dataobject = "d_dblink_1"
boolean scaletobottom = false
end type

event dw_list::doubleclicked;call super::doubleclicked;STRING	ls_table, ls_key
CHOOSE CASE dwo.name
	CASE 'title_table'
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
	CASE 'dblink_dt'
		Object.dblink_dt [row] = null_dt
END CHOOSE
end event

type st_1 from pf_u_splitbar_vertical within w_dblink
integer x = 2734
integer y = 1476
integer height = 1288
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_this"
string rightdragobject = "dw_dblink"
end type

type dw_dblink from u_dw within w_dblink
integer x = 2757
integer y = 1476
integer width = 2674
integer height = 1288
integer taborder = 40
boolean bringtotop = true
string title = "DBLINK서버자료@kfsdb"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibtitle4datawindow = true
boolean ibsetlist4excelclip = true
string setlist4rowpointcolor = "rc=1=a;rc=2=b;rc=3=c"
boolean eb_null_line = false
end type

event doubleclicked;call super::doubleclicked;choose case getitemstatus (row, 0, Primary!)
	case New!
		messagebox (string (row), 'New!')
	case NewModified!
		messagebox (string (row), 'NewModified!')
	case NotModified!
		messagebox (string (row), 'NotModified!')
	case DataModified!
		messagebox (string (row), 'DataModified!')
end choose
IF	f_notnull (dwo.name)	Then
	choose case getitemstatus (row, string (dwo.name), Primary!)
		case New!
			messagebox (string (row) + ':' + string (dwo.name), 'New!')
		case NewModified!
			messagebox (string (row) + ':' + string (dwo.name), 'NewModified!')
		case NotModified!
			messagebox (string (row) + ':' + string (dwo.name), 'NotModified!')
		case DataModified!
			messagebox (string (row) + ':' + string (dwo.name), 'DataModified!')
	end choose
End IF
end event

event updatestart;call adw_jTier::updatestart
end event

type cb_run from pf_u_commandbutton within w_dblink
integer x = 2231
integer y = 16
integer width = 462
integer taborder = 100
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "SQL실행"
end type

event clicked;call super::clicked;str_dw_base ldw

BOOLEAN	lb_delete

DateTime	ldt_start

LONG	ll_this, ll_dblink, ll_col, ll, lj, lk = 0, ll_key, ll_find, ll_delete = 0, ll_insert = 0

STRING	ls_select, ls_table_name, ls_update, ls_comments, ls_length, ls_edit, ls_run, ls_check_column = ''
STRING	la_key [], la_format [], ls_column, ls_data, ls_sort = '#1 as', ls_find = "#1='0'", ls_find_data

ll_key = f_get_array (dw_list.object.key_column [iRow], '@', la_key)
la_format = la_key
ls_select = TRIM (dw_list.object.run_sql [iRow])
ls_table_name = dw_list.object.title_table [iRow]
ls_select = f_replace (ls_select, ':workdate', string (idt_workdate, 'yyyy.mm.dd'))
ls_select = f_replace (ls_select, ':yyyymmdd', string (idt_workdate, 'yyyymmdd'))

CHOOSE CASE ls_table_name
	CASE 'KSDCODE'
		dw_this.set_space_asc160_use (true)
		dw_dblink.set_space_asc160_use (true)
END CHOOSE

SELECT  LISTAGG (nvl(t2.comments,t1.column_name), '@') WITHIN GROUP (order by t1.column_id)
		, LISTAGG (CASE when t1.data_type='NUMBER' And t1.data_length=22 THEN 0 ELSE t1.data_length END, '@') WITHIN GROUP (order by t1.column_id)
		, LISTAGG ('0', '@') WITHIN GROUP (order by t1.column_id)
		, LISTAGG (t1.column_name, ',') WITHIN GROUP (order by t1.column_id)
		, now()
  INTO  :ls_comments
		, :ls_length
		, :ls_edit
		, :ls_update
		, :ldt_start
FROM    user_tab_columns t1
		, user_col_comments t2
WHERE   t1.table_name  = :ls_table_name
  AND   t2.table_name  = t1.table_name
  AND   t2.column_name = t1.column_name;

ls_comments = 'rc@' + SQLCA.getitemstring (1)
ls_length   = '-1@' + SQLCA.getitemstring (2)
ls_edit     = '0@' + SQLCA.getitemstring (3)
ls_update   = SQLCA.getitemstring (4)
ldt_start   = SQLCA.getitemdatetime (5)
f_get_array (ls_comments, '@', ldw.header_text)
f_get_array (ls_length, '@', ldw.column_width)
f_get_array (ls_edit, '@', ldw.column_edit)

ldw.fseq = TRUE
dw_dblink.setupdatetable (ls_table_name + '@kfsdb')
dw_dblink.setkeycolumn (f_replace (dw_list.object.key_column [iRow],'@',','))
dw_dblink.setupdatecolumn (ls_update)
ll_dblink = SQLCA.sql2dw (ls_select, dw_dblink, ldw)
IF LenA (SQLCA.sqlerrtext ())>0  Then
   ::CLIPBOARD (SQLCA.sqlerrtext ())
   messagebox ("sqlselect error==>",SQLCA.sqlerrtext ())
   RETURN
End IF
dw_list.object.dblink_count [iRow] = ll_dblink

ll_col = integer (dw_dblink.object.DataWindow.Column.Count)
FOR  ll = 1  TO  ll_col
	ls_column = dw_dblink.describe ("#" + string (ll) + ".name")
	FOR  lj = 1  TO  ll_key
		IF	ls_column = la_key [lj]	Then
			ls_check_column += ls_check_column + '[' + string (ll) + ']'
			ls_sort += ", #" + string (ll) + ' as'
			la_format [lj] = LEFT (dw_dblink.describe ('#'+string (ll)+".coltype"), 4)
			CHOOSE CASE la_format [lj]
				CASE 'date'
					ls_find += " And string (#" + string (ll) + ",'yyyymmddHHmmss')='" + la_key [lj] + "'"
				CASE 'numb','deci'
					ls_find += " And #" + string (ll) + "=" + la_key [lj]
				CASE ELSE
					ls_find += " And #" + string (ll) + "='" + la_key [lj] + "'"
			END CHOOSE
		End IF
	NEXT
NEXT

ls_select = f_replace (ls_select,'@kfsdb','')
dw_this.setupdatetable (ls_table_name)
dw_this.setkeycolumn (f_replace (dw_list.object.key_column [iRow],'@',','))
dw_this.setupdatecolumn (ls_update)
ll_this = SQLCA.sql2dw (ls_select, dw_this, ldw)
IF LenA (SQLCA.sqlerrtext ())>0  Then
   ::CLIPBOARD (SQLCA.sqlerrtext ())
   messagebox ("sqlselect error==>",SQLCA.sqlerrtext ())
   RETURN
End IF
dw_list.object.this_count [iRow] = ll_this

st_count.visible = true
FOR  ll = ll_this  TO  1  STEP -1
	lk ++
   f_st_count (st_count, 'dblink server와 차이자료 확인~r~n', lk, ll_this)
	ls_find_data = ls_find
	FOR  lj = 1  TO  ll_key
		CHOOSE CASE la_format [lj]
			CASE 'date'
				ls_data = string (dw_this.getitemdatetime (ll, la_key [lj]), 'yyyymmddHHmmss')
			CASE 'numb','deci'
				ls_data = string (dw_this.getitemnumber (ll, la_key [lj]))
			CASE ELSE
				ls_data = dw_this.getitemstring (ll, la_key [lj])
		END CHOOSE
		IF	POS (ls_data,'~~')>0 THEN ls_data = f_replace (ls_data,'~~','~~~~')
		ls_find_data = f_replace (ls_find_data, la_key [lj], ls_data)
	NEXT
	ll_find = dw_dblink.FIND (ls_find_data, 1, ll_dblink)
	IF	ll_find>0	Then
		lb_delete = true
		IF	POS (dw_list.object.sql_title [iRow],'(KEY)')>0	Then
			FOR  lj = 2  TO  ll_col
				IF	POS (ls_check_column, string (lj))>0	Then
					IF	dw_this.object.data [ll, lj]<>dw_dblink.object.data [ll_find, lj]	Then
						ll_delete ++
						dw_this.deleterow (ll)
						lb_delete = false
						EXIT
					End IF
				End IF
			NEXT
		Else
			FOR  lj = 2  TO  ll_col
				IF	dw_this.object.data [ll, lj]<>dw_dblink.object.data [ll_find, lj]	Then
					ll_delete ++
					dw_this.deleterow (ll)
					lb_delete = false
					EXIT
				End IF
			NEXT
		End IF
		IF	lb_delete	Then
			dw_this.object.rc [ll]        = '2' ; f_dw_resetstatus (dw_this, ll, { 'rc' })
			dw_dblink.object.rc [ll_find] = '2' ; f_dw_resetstatus (dw_dblink, ll_find, { 'rc' })
		End IF
	End IF
NEXT
dw_list.object.delete_count [iRow] = ll_delete

dw_dblink.setsort (ls_sort)
dw_dblink.sort ()
dw_dblink.uf_retrieveend ('', ll_dblink, false)

FOR  ll = 1  TO  ll_dblink
	IF	dw_dblink.object.rc [ll]='2' THEN EXIT
	ll_insert ++
	ll_this = dw_this.rowcount () + 1
	dw_dblink.rowscopy (ll, ll, primary!, dw_this, ll_this, primary!)
	dw_this.object.rc [ll_this] = '1'
NEXT
dw_list.object.new_count [iRow] = ll_insert

dw_this.setsort (ls_sort)
dw_this.sort ()
dw_this.uf_retrieveend ('', ll_this, false)

ll_this = dw_this.rowcount ()
FOR  ll = 1  TO  ll_this
	IF	dw_this.object.rc [ll]<>'0' THEN EXIT
	ll_dblink = dw_dblink.rowcount () + 1
	dw_this.rowscopy (ll, ll, primary!, dw_dblink, ll_dblink, primary!)
	dw_dblink.object.rc [ll_dblink] = '1'
NEXT

dw_dblink.sort ()

dw_list.object.dblink_dt [iRow] = f_sysdate ('')

SELECT  f_time (now(), :ldt_start)
  INTO  :ls_run
FROM    dual;

ls_run = SQLCA.getitemstring (1)

messagebox ('저장확인', '서버간 자료 확인이 완료 되었습니다.~r~n반드시 저장버튼을 클릭해야 작업이 완료됩니다.~r~n실행시간 : ' + ls_run)
st_count.visible = false
end event

type dw_this from u_dw within w_dblink
integer x = 50
integer y = 1476
integer width = 2674
integer height = 1288
integer taborder = 50
boolean bringtotop = true
string title = "현재서버자료"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletobottom = true
boolean ibtitle4datawindow = true
boolean ibsetlist4excelclip = true
string setlist4rowpointcolor = "rc=1=a;rc=2=b;rc=3=c"
boolean eb_null_line = false
end type

event doubleclicked;call super::doubleclicked;choose case getitemstatus (row, 0, Primary!)
	case New!
		messagebox (string (row), 'New!')
	case NewModified!
		messagebox (string (row), 'NewModified!')
	case NotModified!
		messagebox (string (row), 'NotModified!')
	case DataModified!
		messagebox (string (row), 'DataModified!')
end choose
IF	f_notnull (dwo.name)	Then
	choose case getitemstatus (row, string (dwo.name), Primary!)
		case New!
			messagebox (string (row) + ':' + string (dwo.name), 'New!')
		case NewModified!
			messagebox (string (row) + ':' + string (dwo.name), 'NewModified!')
		case NotModified!
			messagebox (string (row) + ':' + string (dwo.name), 'NotModified!')
		case DataModified!
			messagebox (string (row) + ':' + string (dwo.name), 'DataModified!')
	end choose
End IF
end event

event updatestart;call adw_jTier::updatestart
end event

type st_move from pf_u_splitbar_horizontal within w_dblink
integer x = 50
integer y = 1452
integer width = 5381
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletoright = false
string topdragobject = "dw_list"
string bottomdragobject = "dw_this;dw_dblink;st_1"
end type

