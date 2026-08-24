forward
global type w_ja051e from wt_vertdetail
end type
type cb_2 from pf_u_commandbutton within w_ja051e
end type
end forward

global type w_ja051e from wt_vertdetail
boolean eb_rowchangewait = true
boolean eb_direct_retrieve = true
string is_find = "table_nm=~'~' and table_seq=0"
string is_init_value = "fii@1"
boolean ib_managedata = false
cb_2 cb_2
end type
global w_ja051e w_ja051e

type variables
DateTime	idt_ymd
STRING	ia_head []
end variables

event wue_retrieve;call super::wue_retrieve;is_find = "table_nm='" + ia_value [1] + "' and table_seq=" + ia_value [2]
idt_ymd = dw_c.object.ymd [1]
dw_list.retrieve (gaa.corp_gr)
end event

on w_ja051e.create
int iCurrent
call super::create
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_ja051e.destroy
call super::destroy
destroy(this.cb_2)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
idt_ymd = idt_workdate
end event

event ue_activate;call super::ue_activate;IF dw_List.enabled THEN EVENT wue_retrieve ()
end event

event open;icmdbutton = { cb_2 }
call super::open
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja051e
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja051e
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja051e
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja051e
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja051e
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja051e
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja051e
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja051e
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja051e
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja051e
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja051e
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja051e
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja051e
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja051e
end type

type p_close from wt_vertdetail`p_close within w_ja051e
end type

type p_excel from wt_vertdetail`p_excel within w_ja051e
end type

type p_print from wt_vertdetail`p_print within w_ja051e
end type

type p_delete from wt_vertdetail`p_delete within w_ja051e
end type

type p_update from wt_vertdetail`p_update within w_ja051e
end type

type p_input from wt_vertdetail`p_input within w_ja051e
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja051e
end type

type p_clear from wt_vertdetail`p_clear within w_ja051e
end type

type p_copy from wt_vertdetail`p_copy within w_ja051e
end type

type dw_c from wt_vertdetail`dw_c within w_ja051e
string tag = "주문을 위해 H2O에 발송할 자료 조회 및 생성(발송)"
string title = "발송(기준가계산)일"
string dataobject = "dc_ymd"
end type

type btn_update from wt_vertdetail`btn_update within w_ja051e
end type

type st_count from wt_vertdetail`st_count within w_ja051e
end type

type dw_list from wt_vertdetail`dw_list within w_ja051e
integer x = 46
string dataobject = "d_ja051e1"
boolean eb_null_line = false
end type

event dw_list::clicked;call super::clicked;LONG	ll
CHOOSE CASE dwo.name
	CASE 'chk_t'
		IF	FIND ("chk='1'", 1, rowcount ())=0	Then
			FOR ll = 1 TO rowcount ()
				Object.chk [ll] = '1'
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		Else
			FOR ll = 1 TO rowcount ()
				Object.chk [ll] = '0'
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		End IF
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;uf_protect (row, ia_protect [1])
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'send_group', '', '', 1, '')
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja051e
boolean setedittoken = false
boolean ibsetlist4subbtn = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;str_dw_base	ldw

STRING	ls_select, errors

LONG	ll_syntax_count, ll, ll_col, lm, ll_max, ll_row

setredraw (false)

ia_value [1] = dw_list.object.table_nm [iRow]
ia_value [2] = string (dw_list.object.table_seq [iRow])

ls_select = dw_list.object.select_sql [iRow]
ls_select = f_replace (ls_select,':corp_gr', gaa.corp_gr)
ls_select = f_replace (ls_select,'2000.01.01', string (idt_ymd,'yyyy.mm.dd'))
ls_select = f_replace (ls_select,'2000.12.31', string (idt_ymd,'yyyy.mm.dd'))

f_get_array (dw_list.object.header_nm [iRow], '@', ldw.header_text)
ia_head = ldw.header_text
FOR ll=1 TO upperbound (ldw.header_text)
	ldw.column_width [ll] = string(long(len (ldw.header_text [ll]) + len (ldw.header_text [ll]) / 4))
NEXT
ldw.fseq = true
ll_syntax_count = SQLCA.sql2dw (ls_select, dw_detail, ldw)
IF f_notnull (SQLCA.sqlerrtext ())	Then
	::CLIPBOARD (SQLCA.sqlerrtext ())
   messagebox ("sqlselect error==>",SQLCA.sqlerrtext ())
End IF
uf_retrieveend ('', ll_syntax_count, false)
end event

event dw_detail::retrieveend;//
end event

type st_move from wt_vertdetail`st_move within w_ja051e
end type

type cb_2 from pf_u_commandbutton within w_ja051e
integer x = 2231
integer y = 16
integer width = 398
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "자료생성"
end type

event clicked;STR_FTP	ftp

LONG	li_file, ll, ll_list, li, lj, li_detail, ll_file = 0

STRING	ls_path, ls_save_file, ls_data, ls_ftp

DateTime	ldt_fymd, ldt_tymd

ldt_fymd = dw_c.object.ymd[1]

SELECT  f_open_ymd(:ldt_fymd, '+1') - 1
  INTO  :ldt_tymd
FROM    DUAL;

ldt_tymd = SQLCA.getitemdatetime (1)

ll_list = dw_list.rowcount ()
ll = dw_list.FIND ("chk='1'", 1, ll_list)
IF	ll=0	Then
	f_messageBox ('ERR', '선택항목이 없습니다.')
	RETURN
End IF

ftp.corp_gr		= gaa.corp_gr
ftp.ip			= dw_list.object.host_ip [1]
ftp.port 		= 21
ftp.user 		= dw_list.object.host_user [1]
ftp.pwd			= dw_list.object.host_pw [1]
ftp.path			= dw_list.object.host_path [1]
ftp.local_path	= 'c:\up\'

f_loadingchart (true)
st_count.visible = true
FOR  ll = ll  TO  ll_list
	IF	dw_list.object.chk [ll]='1'	Then
		yield ()
		ldt_fymd = dw_c.object.ymd [1]
		idt_ymd  = ldt_fymd
		dw_list.uf_setrow (ll, true)
		DO WHILE ldt_fymd <= ldt_tymd
			ls_path = 'c:\up\' + string (ldt_fymd,'yyyymmdd') + '\'
			IF directoryexists (ls_path)=FALSE THEN createdirectory (ls_path)
			ls_save_file = '0' + gaa.corp_gr + '_' + string (dw_List.object.table_nm [ll]) + RIGHT ('00000' + string (dw_List.object.table_seq [ll]),5) + '_' + string (ldt_fymd,'yyyymmdd') + '.txt'
			FileDelete (ls_path + ls_save_file)
			li_file = FILEOPEN (ls_path + ls_save_file, TextMode!, Write!, LockWrite!, Replace!)

			ls_data  = "<?xml version='1.0'  encoding='euc-kr' ?>~r~n"
			ls_data += '<RESULTS>~r~n'
			FileWriteEX (li_file, ls_data)

			li_detail = dw_detail.rowcount ()
			ls_data = ''
			FOR  li = 1  TO  li_detail
				ls_data += '    <ROW>~r~n'
				FOR  lj = 1  TO  UPPERBOUND (ia_head)
					ls_data += '        <COLUMN NAME="'+ia_head [lj]+'"><![CDATA['+f_nvl (string (dw_detail.object.data [li, lj]),'')+']]></COLUMN>~r~n'
				NEXT
				ls_data += '    </ROW>~r~n'
				IF	LenA (ls_data)>32000	Then
					FileWriteEX (li_file, ls_data)
					ls_data = ''
				End IF
				f_st_count (st_count, ls_path + ls_save_file + '~r~n' + string (idt_ymd,'yyyy.mm.dd') + ' filewrite : ', li, li_detail)
			NEXT
			IF	f_notnull (ls_data) THEN FileWriteEX (li_file, ls_data)
			FileWriteEX (li_file, '</RESULTS>')
			FileClose (li_file)

			ll_file ++ ; ftp.local_file [ll_file] = ls_path + ls_save_file

			SELECT  :ldt_fymd + 1
			  INTO  :ldt_fymd
			FROM    DUAL;

			ldt_fymd = SQLCA.getitemdatetime (1)
			IF	ldt_fymd <= ldt_tymd	Then
				idt_ymd	= ldt_fymd
				dw_detail.EVENT ue_retrieve ()
			End IF
		LOOP
	End IF
NEXT
st_count.visible = false
f_loadingchart (false)

//OpenWithParm (w_table_conv_ftp_send, ftp)
ls_ftp = message.stringparm

commitJ ();

f_messageBox ('INFO', '생성이 완료 되었습니다.~r~n' + ls_ftp)
end event

