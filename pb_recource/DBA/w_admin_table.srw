forward
global type w_admin_table from wt_listdetail
end type
type ole_rd from u_rd within w_admin_table
end type
type cb_3 from pf_u_commandbutton within w_admin_table
end type
type cb_other from pf_u_commandbutton within w_admin_table
end type
type cb_java from pf_u_commandbutton within w_admin_table
end type
end forward

global type w_admin_table from wt_listdetail
integer width = 6578
integer height = 3336
boolean eb_direct_retrieve = true
boolean ib_managedata = false
ole_rd ole_rd
cb_3 cb_3
cb_other cb_other
cb_java cb_java
end type
global w_admin_table w_admin_table

type variables
STRING	is_Select, is_table_in
end variables

on w_admin_table.create
int iCurrent
call super::create
this.ole_rd=create ole_rd
this.cb_3=create cb_3
this.cb_other=create cb_other
this.cb_java=create cb_java
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_rd
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_other
this.Control[iCurrent+4]=this.cb_java
end on

on w_admin_table.destroy
call super::destroy
destroy(this.ole_rd)
destroy(this.cb_3)
destroy(this.cb_other)
destroy(this.cb_java)
end on

event wue_retrieve;call super::wue_retrieve;STRING	ls_name = '', ls_comments = ''

IF f_notnull (dw_c.object.column_name [1]) THEN ls_name = "~t and t2.table_name in (select table_name from user_tab_columns where column_name like '%" + dw_c.object.column_name [1] + "%')"
IF f_notnull (dw_c.object.column_comments [1]) THEN ls_comments = "~t and t2.table_name in (select table_name from user_col_comments where comments like '%" + dw_c.object.column_comments [1] + "%')"

dw_List.Modify ("DataWindow.Table.Select = ~" " + is_Select + ls_name + ls_comments + "~" " )

dw_List.retrieve ('%' + dw_c.object.Table_name[1] + '%')
end event

event wue_postopen;call super::wue_postopen;is_Select = dw_List.describe ("DataWindow.Table.Select")

dw_c.object.owner [1] = gaa.jtier_dbname
dw_c.object.Table_name[1] = '%'
dw_c.object.column_name [1] = ''
dw_c.object.column_comments [1] = ''

dw_c.SetFocus ()
dw_c.SetColumn ('table_name')
end event

event open;ib_managedata = (gaa.login='yjs1992@hitel.net' or gaa.login='boddoc@nate.com')
icmdbutton = { cb_3, cb_other, cb_java }
call super::open
end event

event resize;call super::resize;ole_rd.x = dw_list.x + dw_list.width - ole_rd.width - 10
ole_rd.y = dw_detail.y + dw_detail.height - ole_rd.height - 10
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_admin_table
end type

type ln_templeft from wt_listdetail`ln_templeft within w_admin_table
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_admin_table
end type

type ln_temptop from wt_listdetail`ln_temptop within w_admin_table
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_admin_table
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_admin_table
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_admin_table
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_admin_table
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_admin_table
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_admin_table
end type

type ln_tempright from wt_listdetail`ln_tempright within w_admin_table
end type

type uo_navi from wt_listdetail`uo_navi within w_admin_table
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_admin_table
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_admin_table
end type

type st_top_rect from wt_listdetail`st_top_rect within w_admin_table
end type

type p_close from wt_listdetail`p_close within w_admin_table
end type

type p_excel from wt_listdetail`p_excel within w_admin_table
end type

type p_print from wt_listdetail`p_print within w_admin_table
end type

type p_delete from wt_listdetail`p_delete within w_admin_table
end type

type p_update from wt_listdetail`p_update within w_admin_table
end type

type p_input from wt_listdetail`p_input within w_admin_table
end type

type p_retrieve from wt_listdetail`p_retrieve within w_admin_table
end type

type p_clear from wt_listdetail`p_clear within w_admin_table
end type

type p_copy from wt_listdetail`p_copy within w_admin_table
end type

type dw_c from wt_listdetail`dw_c within w_admin_table
string dataobject = "d_admin_table_c"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'table_name'
      Object.column_name [1] = ''
      Object.column_comments [1] = ''
END CHOOSE
end event

type btn_update from wt_listdetail`btn_update within w_admin_table
end type

type st_count from wt_listdetail`st_count within w_admin_table
end type

type dw_list from wt_listdetail`dw_list within w_admin_table
string dataobject = "d_admin_table_l"
boolean eb_null_line = false
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE>0 THEN RETURN AncestorReturnVALUE
IF row=0 THEN RETURN

IF gaa.login='yjs1992@hitel.net' and dwo.name='comments'  Then
	
	STRING	ls_sr_err_msg, la_args[]

	la_args[1] = "comment on table " + dw_c.object.Owner[1] + '.' + Object.table_name[row] + " is '" + data + "'"
	SQLCA.SP_CALL (THIS, 'SR_DDL ( ? )', la_args[], ls_sr_err_msg)
   IF f_notnull (SQLCA.SQLerrtext ()) THEN MessageBox ('comment Error', SQLCA.SQLerrtext() + '/' + string (SQLCA.sqlcode()))
End IF
post setfocus ()
end event

event dw_list::ue_print;LONG	ll

IF uf_getrange () Then
   ll = GetSelectedRow(0) ; is_table_in = ''
   DO WHILE ll > 0
      IF is_table_in<>'' THEN is_table_in = is_table_in + ","
      is_table_in = is_table_in + "'" + Object.table_name [ll] + "'"
      ll = GetSelectedRow (ll)
   LOOP
   ole_rd.uf_fileopen ('rd_admin_table_a4.mrd', "table_in[" + is_table_in + "]" )
Else
   dw_Detail.EVENT ue_print ()
End IF
end event

event dw_list::retrieveend;call super::retrieveend;dw_c.POST SetFocus ()
end event

type dw_detail from wt_listdetail`dw_detail within w_admin_table
string dataobject = "d_admin_table_d"
boolean ibsetlist4subbtn = false
string is_resize_column = "comments"
end type

event dw_detail::itemchanged;IF row=0 THEN RETURN
IF gaa.login='yjs1992@hitel.net' and dwo.name='comments'  Then
	STRING	ls_sr_err_msg, la_args []

	la_args [1] = "comment on column " + dw_c.Object.Owner[1] + '.' + dw_List.Object.table_name [iRow] + "." + Object.column_name[row] + " is '" + f_nvl (data,'') + "'"
	SQLCA.SP_CALL (THIS, 'SR_DDL ( ? )', la_args[], ls_sr_err_msg)
   IF f_notnull (SQLCA.SQLerrtext()) THEN MessageBox ('comment Error', SQLCA.SQLerrtext() + '/' + string (SQLCA.sqlcode()))
End IF
post setfocus ()
end event

event dw_detail::ue_print;is_table_in = "'" + dw_List.object.table_name [iRow] + "'"
ole_rd.uf_fileopen ('rd_admin_table_a4.mrd', "table_in[" + is_table_in + "]" )
end event

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_List.object.table_name [iRow])
end event

event dw_detail::retrieverow;call super::retrieverow;IF NOT f_null(dw_c.object.column_name [1]) OR NOT f_null(dw_c.object.column_comments [1])  Then
   IF PosA (Object.column_name [row], dw_c.object.column_name [1])>0 THEN Object.color [row] = 16711680
   IF PosA (Object.comments [row], dw_c.object.column_comments [1])>0 THEN Object.color [row] = 16711680
End IF
end event

event dw_detail::doubleclicked;LONG  ll

STRING   ls_msg, ls_para, ls_column_name, ls_comments, ls_comment, la_args[]

IF DWO.NAME='comments_t'   Then
   FOR  ll = 1  TO  rowcount ( )
      IF POS (Object.comments [ll], '~r~n')>0   Then
         CONTINUE
      ElseIF POS (Object.comments [ll], '~r')>0 Then
         Object.comments [ll] = F_REPLACE (Object.comments [ll], '~r', '~r~n')
      ElseIF POS (Object.comments [ll], '~n')>0 Then
         Object.comments [ll] = F_REPLACE (Object.comments [ll], '~n', '~r~n')
      END IF
      IF F_NOTNULL (ls_para)  Then
         ls_comment += "comment on column " + dw_c.object.owner [1] + '.' + dw_List.object.table_name [iRow] + "." + Object.column_name [ll] + " is '" + Object.comments [ll] + "'~r~n"
//         la_args[1] = "comment on column " + dw_c.object.owner [1] + '.' + dw_List.object.table_name [iRow] + "." + Object.column_name [ll] + " is '" + Object.comments [ll] + "'"
//         SQLCA.SP_CALL (THIS, 'SR_DDL ( ? )', la_args, ls_msg)
      END IF
   NEXT
   ::clipboard (ls_comment)
   RETURN
END IF
call super::doubleclicked
//IF gaa.login='yjs1992@hitel.net' And dwo.name='comments'  Then
IF DWO.NAME='comments'  Then
   IF F_NULL (Object.comments [row])   Then
      ls_column_name = UPPER (Object.column_name [row])
      SELECT comments
        INTO :ls_comments
        FROM USER_COL_COMMENTS t1
       WHERE column_name = :ls_column_name
         AND comments IS NOT NULL
         AND ROWNUM = 1;
      IF SQLCA.sqlcode ( )=0   Then
         ls_comments = SQLCA.GETITEMSTRING (1)
         Object.comments [row] = ls_comments
         la_args[1]            = "comment on column " + dw_c.object.owner [1] + '.' + dw_list.object.table_name [iRow] + "." + ls_column_name + " is '" + ls_comments + "'"
         SQLCA.SP_CALL (THIS, 'SR_DDL ( ? )', la_args, ls_msg)
         POST setfocus ( )
      END IF
   ELSE
      F_GR_CD (gaa.CORP_GR, Object.comments [row])
   END IF
END IF
end event

event dw_detail::rbuttondown;call super::rbuttondown;IF gaa.login='yjs1992@hitel.net' And dwo.name='comments'	Then
   IF f_null (Object.comments [row]) THEN f_gr_cd (gaa.corp_gr, Object.comments [row])
End IF
end event

type st_move from wt_listdetail`st_move within w_admin_table
end type

type ole_rd from u_rd within w_admin_table
boolean visible = false
integer x = 1541
integer y = 652
integer width = 3470
integer height = 2108
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
borderstyle borderstyle = styleraised!
string binarykey = "w_admin_table.win"
boolean eb_directprint = true
end type

event doubleclicked;call super::doubleclicked;LONG	ll
IF dw_list.uf_getrange () Then
   ll = dw_list.GetSelectedRow(0) ; is_table_in = ''
   DO WHILE ll > 0
      IF is_table_in<>'' THEN is_table_in = is_table_in + ","
      is_table_in = is_table_in + "'" + dw_list.Object.table_name [ll] + "'"
      ll = dw_list.GetSelectedRow (ll)
   LOOP
Else
	is_table_in = "'" + dw_list.Object.table_name [iRow] + "'"
End IF
uf_fileopen ('rd_admin_table.mrd', "table_in[" + is_table_in + "]" )
end event

type cb_3 from pf_u_commandbutton within w_admin_table
integer x = 2240
integer y = 16
integer width = 389
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "SELECT"
end type

event clicked;LONG	ll, ll_count, ll_len

STRING	ls_select, ls_from, ls_str, ls_dec, ls_date, ls_fetch
STRING	ls_table, ls_update, ls_set, ls_where
STRING	ls_loader, ls_eng_header = '', ls_kor_header = '', ls_comment = ''

ls_table = dw_List.object.table_name [iRow]

ls_select = '   SELECT  ROWIDTOCHAR (rowid)~r~n'
ls_from = '   FROM    ' + ls_table + ' t1~r~n   WHERE   t1.corp_gr = :gaa.corp_gr~r~n     AND   t1.ymd     = :ldt~r~n   ORDER BY  1;'
ls_str = 'STRING  ls_rowid'
ls_dec = 'DEC     ldc_seq'
ls_date = 'DateTime  ldt'
ls_fetch = '   FETCH c1 INTO :ls_rowid'

ls_update = 'UPDATE ' + ls_table
ls_set =    '   SET '
ls_where = 'WHERE  '

ls_loader = "LOAD DATA~r~nINFILE  'ia.txt'~r~nLOGFILE 'ia.log'~r~nBADFILE 'ia.bad'~r~nTRUNCATE~r~nINTO TABLE " + ls_table + "~r~nFIELDS TERMINATED BY '|'~r~nTRAILING NULLCOLS~r~n( "

ll_count = dw_Detail.rowcount ()
FOR  ll = 1  TO  ll_count
   ls_select += '         , ' + lower (dw_Detail.object.column_name [ll]) + '          /* ' + f_nvl (dw_Detail.object.comments [ll],'') + ' */~r~n'
   IF ll=1  Then
      ls_loader += dw_Detail.object.column_name [ll]
   Else
      ls_loader += ',~r~n  ' + dw_Detail.object.column_name [ll]
   End IF
   CHOOSE CASE lower (dw_Detail.object.data_type [ll])
      CASE 'date'
         ls_date += ', ldt_' + lower (dw_Detail.object.column_name [ll])
         ls_fetch += ', :ldt_' + lower (dw_Detail.object.column_name [ll])
         ls_loader += " date 'yyyy.mm.dd hh24:mi:ss'"
      CASE 'number'
         ls_dec += ', ldc_' + lower (dw_Detail.object.column_name [ll])
         ls_fetch += ', :ldc_' + lower (dw_Detail.object.column_name [ll])
      CASE Else
         ls_str += ', ls_' + lower (dw_Detail.object.column_name [ll])
         ls_fetch += ', :ls_' + lower (dw_Detail.object.column_name [ll])
   END CHOOSE
   IF ll=1  Then
      ls_set += lower (dw_Detail.object.column_name [ll]) + ' =          /* ' + f_nvl (dw_Detail.object.comments [ll],'') + ' */~r~n'
   Else
      ls_set += '     , ' + lower (dw_Detail.object.column_name [ll]) + ' =         /* ' + f_nvl (dw_Detail.object.comments [ll],'') + ' */~r~n'
   End IF

   ls_eng_header += f_nvl (dw_Detail.object.column_name [ll],'') + '@'
   ll_len = POS (dw_Detail.object.comments [ll],'~r')
   IF ll_len=0 THEN POS (dw_Detail.object.comments [ll],'~n')
   IF ll_len>0 Then
      ll_len --
   Else
      ll_len = LENA (dw_Detail.object.comments [ll])
   End IF
   ls_kor_header += f_nvl (MIDA (dw_Detail.object.comments [ll],1,ll_len),'') + '@'
   ls_comment += 'comment on column ' + ls_table + '.' + dw_Detail.object.column_name [ll] + " is '" + f_nvl (dw_Detail.object.comments [ll],'') + "';~r~n"
NEXT

STRING		ls_sqlsyntax

LONG		lR, lj

aDS_jTier	lds_jtier

ls_sqlsyntax = "   SELECT  lower(t2.column_name) " &
             + "   FROM    user_indexes t1 " &
             + "         , user_ind_columns t2 " &
             + "   WHERE   t1.table_name = '" + ls_table + "' " &
             + "     AND   t1.index_name LIKE '%_PK' " &
             + "     AND   t2.index_name = t1.index_name " &
             + "   ORDER BY  t2.column_position "

lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

FOR  lj = 1  TO  lR
   ls_str = lds_jtier.getitemString (lj, 1)

   IF ls_where='WHERE  '   Then
      ls_where += ls_str + ' = '
   Else
      ls_where += '~r~n  AND  ' + ls_str + ' = '
   End IF
NEXT

ls_loader = f_replace (ls_loader, 'ia.txt',lower (ls_table)+'.txt')
ls_loader = f_replace (ls_loader, 'ia.log',lower (ls_table)+'.log')
ls_loader = f_replace (ls_loader, 'ia.bad',lower (ls_table)+'.bad')

::Clipboard (ls_date + '~r~n' + ls_str + '~r~n' + ls_dec + '~r~n~r~n~r~n' + &
               'DECLARE c1 CURSOR FOR~r~n' + ls_select + ls_from + '~r~n~r~nOPEN  c1;~r~n~r~nDO WHILE TRUE~r~n' + &
               ls_fetch + ';~r~n   IF SQLCA.sqlcode ()<>0 THEN EXIT~r~n~r~n~r~nLOOP~r~n~r~nCLOSE c1;~r~n~r~n' + &
               ls_update + '~r~n' + ls_set + ls_where + ';~r~n~r~n' + &
               ls_loader + ' )~r~n~r~n' + ls_eng_header + '~r~n~r~n' + ls_kor_header + '~r~n~r~n' + ls_comment)
f_messageBox ('INFO', 'SQL문을 클립보드에 복사했습니다.')
end event

type cb_other from pf_u_commandbutton within w_admin_table
integer x = 2656
integer y = 16
integer width = 389
integer taborder = 60
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "RD View"
end type

event clicked;ole_rd.visible = NOT ole_rd.visible
ole_rd.enabled = NOT ole_rd.enabled
ole_rd.eb_directprint = NOT ole_rd.eb_directprint
end event

type cb_java from pf_u_commandbutton within w_admin_table
integer x = 3072
integer y = 16
integer width = 457
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "JAVA Column"
end type

event clicked;LONG	ll, lm, ll_count

STRING	ls_java, ls_col1 = '', ls_col2 = '', ls_type, ls_space

ll_count = dw_detail.rowcount ()
FOR  ll = 1  TO  ll_count
	ls_java = ''
	FOR  lm = 1  TO  LenA(dw_detail.object.column_name [ll])
		IF	MidA(dw_detail.object.column_name [ll],lm,1)='_'	Then
			ls_java += UPPER (MidA(dw_detail.object.column_name [ll],lm + 1,1))
			lm ++
		Else
			ls_java += lower (MidA(dw_detail.object.column_name [ll],lm,1))
		End IF
	NEXT
	IF	LenA(ls_java)>13	Then
		ls_java += ';  '
	Else
		ls_java = LeftA (ls_java + ';' + SPACE (15), 15)
	End IF
	CHOOSE CASE lower (dw_detail.object.data_type [ll])
		CASE 'date'
			ls_type = 'Date'
			ls_space = '  '
		CASE 'number'
			ls_type = 'Long'
			ls_space = '  '
		CASE ELSE
		   ls_type = 'String'
			ls_space = ''
	END CHOOSE
	ls_col1 += '@Column(naem="' + dw_detail.object.column_name [ll] + '")~r~nprivate ' + ls_type + ls_space + ' ' + TRIM (ls_java) + IIF (f_notnull(dw_detail.object.comments [ll]),' // ' + dw_detail.object.comments [ll],'') + '~r~n~r~n'
	ls_col2 += ls_java + ls_type + ';' + ls_space + IIF (f_notnull(dw_detail.object.comments [ll]),' // ' + dw_detail.object.comments [ll],'') + '~r~n'
NEXT

::Clipboard (ls_col1 + '~r~n~r~n' + ls_col2)

f_messageBox ('INFO', 'JAVA Column을 클립보드에 복사했습니다.')
end event

