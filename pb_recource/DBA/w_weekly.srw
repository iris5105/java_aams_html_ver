forward
global type w_weekly from w_winpage
end type
type dw_list from u_dw within w_weekly
end type
type rte_func1 from pf_u_richtextedit within w_weekly
end type
type sle_search_text from pf_u_singlelineedit within w_weekly
end type
type cb_2 from pf_u_commandbutton within w_weekly
end type
type rte_func2 from pf_u_richtextedit within w_weekly
end type
type mle_detail from u_mle within w_weekly
end type
type mle_result from u_mle within w_weekly
end type
type ole_1 from u_rd within w_weekly
end type
type dw_1 from fw_u_dwo within w_weekly
end type
type st_1 from pf_u_splitbar_vertical within w_weekly
end type
end forward

global type w_weekly from w_winpage
boolean eb_retrievewait = true
boolean eb_rowchangewait = true
dw_list dw_list
rte_func1 rte_func1
sle_search_text sle_search_text
cb_2 cb_2
rte_func2 rte_func2
mle_detail mle_detail
mle_result mle_result
ole_1 ole_1
dw_1 dw_1
st_1 st_1
end type
global w_weekly w_weekly

type variables
STRING	is_rt_key, is_username, is_bs

DateTime idt_cre_ymd

STR_Parameter  sp
end variables

on w_weekly.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rte_func1=create rte_func1
this.sle_search_text=create sle_search_text
this.cb_2=create cb_2
this.rte_func2=create rte_func2
this.mle_detail=create mle_detail
this.mle_result=create mle_result
this.ole_1=create ole_1
this.dw_1=create dw_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rte_func1
this.Control[iCurrent+3]=this.sle_search_text
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.rte_func2
this.Control[iCurrent+6]=this.mle_detail
this.Control[iCurrent+7]=this.mle_result
this.Control[iCurrent+8]=this.ole_1
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.st_1
end on

on w_weekly.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.rte_func1)
destroy(this.sle_search_text)
destroy(this.cb_2)
destroy(this.rte_func2)
destroy(this.mle_detail)
destroy(this.mle_result)
destroy(this.ole_1)
destroy(this.dw_1)
destroy(this.st_1)
end on

event wue_postopen;call super::wue_postopen;f_memo ('function weekly1', rte_func1)
f_memo ('function weekly2', rte_func2)

dw_List.TAG = TITLE
dw_List.SetTRansObject (SQLCA)
dw_List.EVENT ue_dddw_retrieve ()

dw_1.SetTRansObject (SQLCA)

p_retrieve.POST EVENT Clicked ()
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
mle_detail.uf_reset (FALSE)
mle_result.uf_reset (FALSE)
dw_List.uf_reset (FALSE)
dw_List.Modify (dw_List.ia_protect [4])
dw_List.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)

mle_result.uf_reset(FALSE)
mle_detail.uf_reset(FALSE)
end event

event ue_activate;call super::ue_activate;IF mle_detail.displayonly  Then mle_detail.backcolor = gnv_vari.setcondbackcolor &
ELSE                           mle_detail.BackColor = rgb(240,255,255)
IF mle_result.displayonly  Then mle_result.backcolor = gnv_vari.setcondbackcolor &
ELSE                           mle_result.BackColor = rgb(240,255,255)
rte_func1.backcolor = gnv_vari.setcondbackcolor
rte_func2.backcolor = gnv_vari.setcondbackcolor
end event

event wue_update;call super::wue_update;IF dw_List.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_Modified () Then
   dw_List.EVENT ue_clob_update (mle_detail.TEXT, mle_result.TEXT)
   RETURN   uf_updateCommit (dw_List)
End IF
RETURN 1
end event

event resize;call super::resize;//dw_List.Y = gb_c.Height + 8
//f_auto_width (dw_List, 0, Width, 0)
dw_List.Height = Height - dw_List.Y - 185

//st_VBar.X = dw_List.Width
//st_VBar.Y = dw_List.Y
//st_VBar.Height = dw_List.Height
//
//rte_func1.X = st_VBar.X + st_VBar.Width
rte_func1.Y = dw_List.Y
rte_func1.Width = Width - rte_func1.X - 125

mle_detail.X = rte_func1.X
mle_detail.Y = dw_List.Y + rte_func1.Height + 4
mle_detail.Width = rte_func1.Width
mle_detail.Height = truncate((Height - 185 - mle_detail.Y) * .6, 0)

rte_func2.X = rte_func1.X
rte_func2.Y = mle_detail.Y + mle_detail.Height + 30
rte_func2.Width = rte_func1.Width

mle_result.X = rte_func1.X
mle_result.Y = rte_func2.Y + rte_func2.Height + 4
mle_result.Width = rte_func1.Width
mle_result.Height = Height - 185 - mle_result.Y

dw_List.ScrollToRow (dw_List.getrow ())
end event

event wue_lastopen;call super::wue_lastopen;DateTime  ldt

SELECT  trunc (now(),'mm') - 12
  INTO  :ldt
FROM    dual;
ldt = SQLCA.getitemdatetime (1)

dw_c.object.ymd [1] = ldt
end event

event wue_retrieve;call super::wue_retrieve;STRING	ls1, ls_value = '', ls_sqlsyntax

LONG		lR, lj

aDS_jTier	lds_jtier

IF gaa.aams   Then
   ls_sqlsyntax = "      SELECT  DISTINCT bgroup " &
					 + "      FROM    weekly t1 " &
					 + "      WHERE   t1.corp_gr = '2200' " &
					 + "        AND   t1.sb_nm   = "+f_nvl("'"+gnv_vari.is_user_nm+"'","null")+" " &
					 + "        AND   NOT(substrb(bgroup, 5, 1) ='.' And (substrb(bgroup, 8, 1) ='.' OR substrb(bgroup, 11, 2) ='주')) " &
					 + "      ORDER BY  1 "

   lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')

   FOR  lj = 1  TO  lR
   	ls1 = lds_jtier.getitemString (lj, 1)

      ls_value += ls1 + '~t' + ls1 + '/'
   NEXT
	
Else
	
   ls_sqlsyntax = "      SELECT  DISTINCT bgroup " &
					 + "      FROM    weekly t1 " &
					 + "      WHERE   t1.corp_gr = "+f_nvl("'"+gaa.corp_gr+"'","null")+" " &
					 + "        AND   t1.sb_nm   = "+f_nvl("'"+gnv_vari.is_user_nm+"'","null")+" " &
					 + "        AND   NOT(substrb(bgroup, 5, 1) ='.' And (substrb(bgroup, 8, 1) ='.' OR substrb(bgroup, 11, 2) ='주')) " &
					 + "      ORDER BY  1 "

   lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')

   FOR  lj = 1  TO  lR
   	ls1 = lds_jtier.getitemString (lj, 1)

      ls_value += ls1 + '~t' + ls1 + '/'
   NEXT
End IF

dw_List.modify ("bgroup.Values='" + f_nvl (ls_value, '') + "'")

sle_search_text.TEXT = null_s
is_find = "sb_nm='" + gnv_vari.is_user_nm + "' and ymd>date('" + f_sysdate_str ('yyyy.mm.dd') + "')"
IF gaa.aams   Then
   dw_list.retrieve ('2200', dw_c.object.ymd [1], gnv_vari.is_user_nm)
Else
   dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], gnv_vari.is_user_nm)
End IF
end event

event ue_wpage_modified;RETURN	(dw_list.uf_isModified () OR mle_detail.ib_update OR mle_result.ib_update)
end event

event close;call super::close;DELETE  rowid_in
WHERE   rt_key = :is_rt_key;
commitJ ();
end event

type lb_dirlist from w_winpage`lb_dirlist within w_weekly
end type

type ln_templeft from w_winpage`ln_templeft within w_weekly
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_weekly
end type

type ln_temptop from w_winpage`ln_temptop within w_weekly
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_weekly
end type

type ln_tempstart from w_winpage`ln_tempstart within w_weekly
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_weekly
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_weekly
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_weekly
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_weekly
end type

type ln_tempright from w_winpage`ln_tempright within w_weekly
end type

type uo_navi from w_winpage`uo_navi within w_weekly
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_weekly
end type

type st_windelaytime from w_winpage`st_windelaytime within w_weekly
end type

type st_top_rect from w_winpage`st_top_rect within w_weekly
end type

type p_close from w_winpage`p_close within w_weekly
end type

type p_excel from w_winpage`p_excel within w_weekly
end type

type p_print from w_winpage`p_print within w_weekly
end type

type p_delete from w_winpage`p_delete within w_weekly
end type

type p_update from w_winpage`p_update within w_weekly
end type

type p_input from w_winpage`p_input within w_weekly
end type

type p_retrieve from w_winpage`p_retrieve within w_weekly
end type

event p_retrieve::clicked;ib_managedata = TRUE

dw_List.uf_dataobject ('d_weekly', FALSE)

mle_detail.uf_init ('', TRUE)
mle_result.uf_init ('', TRUE)

IF ib_ManageData  Then
   dw_c.Enabled = FALSE
	IF	p_clear.visible	Then
		p_clear.of_setenabled (true)
		of_setenabled (false)
	End IF
   dw_List.uf_protect (0, dw_List.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2])
End IF

dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_weekly
end type

type p_copy from w_winpage`p_copy within w_weekly
end type

type dw_c from w_winpage`dw_c within w_weekly
integer taborder = 40
string title = "조회기준일자"
string dataobject = "dc_ymd"
end type

type btn_update from w_winpage`btn_update within w_weekly
end type

type st_count from w_winpage`st_count within w_weekly
end type

type dw_list from u_dw within w_weekly
event ue_clob_update ( string adetail,  string aresult )
integer x = 50
integer y = 348
integer width = 3927
integer height = 2356
integer taborder = 55
string dataobject = "d_weekly"
boolean hscrollbar = true
boolean vscrollbar = true
boolean eb_range_delcopy = false
boolean eb_always_1_insert = true
boolean eb_copy_false = true
end type

event ue_clob_update(string adetail, string aresult);IF mle_detail.ib_update=FALSE And mle_result.ib_update=FALSE THEN RETURN

Object.clob_d [iRow] = adetail
Object.clob_r [iRow] = aresult

mle_detail.ib_update = FALSE
mle_result.ib_update = FALSE
end event

event retrieveend;call super::retrieveend;IF f_num (rowcount )=0  Then
   mle_detail.uf_reset (TRUE)
   mle_result.uf_reset (TRUE)
End IF
uf_retrieveend (is_find, rowcount, ib_manageData)
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sb_cd', gaa.corp_gr, '', 1, "corp_gr='1701'")
f_dddwctl (THIS, 'sebu_cd', gaa.corp_gr, '', 1, "")
end event

event ue_print;//IF Parent.EVENT wue_updatequery ()=1 THEN RETURN
ole_1.uf_fileopen ('rd_weekly_1.mrd', &
               'sb_cd[' + Object.sb_cd [iRow] + '] ' + &
               'cre_ymd[' + string (Object.cre_ymd [iRow],'yyyymmddHHmmss') + ']' )

end event

event doubleclicked;call super::doubleclicked;IF row=0 THEN RETURN

DateTime ldt

IF (gaa.admin OR gaa.aams) And dwo.name='tymd'  Then

   ldt = Object.ymd [row]

   SELECT  LAST_DAY(:ldt)
     INTO  :ldt
   FROM    dual;
	ldt = SQLCA.getitemdatetime (1)

   IF f_null (Object.tymd [row]) THEN Object.tymd [row] = ldt &
   ELSE                               Object.tymd [row] = null_dt

ElseIF (gaa.admin OR gaa.aams) And dwo.name='subject' Then
   IF PosA (Object.subject [row], '주간')>0  Then
      mle_detail.TEXT = f_replace (mle_detail.TEXT, 'ㆍ', '…')
      mle_detail.ib_update = TRUE
   End IF

ElseIF dwo.name='fexp'	Then
	STRING	ls_corp_gr, ls_sb_nm, ls_path, ls_local, ls_blob_err

	BLOB	lb_data

	LONG	ll_rtn

	IF f_notnull (Object.fexp [row]) And Object.p_visible [row]=1	Then
		IF parent.EVENT wue_update ()=-1 THEN RETURN
		uf_setrow (row, false)
		ls_corp_gr = Object.corp_gr [row]
		ls_sb_nm = Object.sb_nm [row]
		ldt = Object.cre_ymd [row]

		ll_rtn = f_messageBox ('RUN2', '등록된 파일이 있습니다.~r~n파일을 변경(취소시 삭제)하시겠습니까?')
		IF ll_rtn=2 THEN RETURN
		IF ll_rtn=3 Then
			IF f_messageBox ('INFO2', '파일을 삭제 하시겠습니까?')=2 THEN RETURN
			Object.fexp [row] = null_s
			Object.org_fname [row] = null_s
	
			lb_data = BLOB(" ")
			mo_.blob2hex(lb_data, SQLCA.is_updateblob, ls_blob_err)

			UPDATEBLOB  weekly
				SET  blob_f = :lb_data
			WHERE   corp_gr = :ls_corp_gr
			  AND   sb_nm   = :ls_sb_nm
			  AND   cre_ymd = :ldt;

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

		UPDATEBLOB  weekly
			SET  blob_f = :lb_data
		WHERE   corp_gr = :ls_corp_gr
		  AND   sb_nm   = :ls_sb_nm
		  AND   cre_ymd = :ldt;

		Object.fexp [row] = MID (ls_local, LASTPOS (ls_local,'.') + 1)

		filedelete (ls_path + '.zip')
	End IF
End IF
end event

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt

STRING	ls_group, ls_week = '주간', ls_BFName, ls_data

INT   li

CHOOSE CASE dwo.name
   CASE 'bgroup'
      IF f_null (data)  Then
         RETURN uf_itemerr (row, 'bgroup', '분류를 입력해야 합니다.')
      End IF
   CASE 'subject'
      IF PosA (data,'주간')>0 Then
         ldt = Object.ymd [row]

         SELECT  TO_CHAR(:ldt,'yyyy.mm') || '월' || to_char(:ldt,'w') || '주'
           INTO  :ls_group
         FROM    dual t1;
			ls_group = SQLCA.getitemstring (1)

         Object.bgroup [row] = ls_group
         ls_week = ''
      End IF
      IF PosA (data,'주간')>0 THEN Object.report [row] = '1'
   CASE 'ymd'
      IF PosA (Object.subject [row],'주간')>0   Then
         ldt = datetime (date (Mid (data,1,10)))

         SELECT  TO_CHAR(:ldt,'yyyy.mm') || '월' || to_char(:ldt,'w') || '주'
           INTO  :ls_group
         FROM    dual t1;
			ls_group = SQLCA.getitemstring (1)

         Object.bgroup [row] = ls_group
         ls_week = ''
      End IF
      IF PosA (Object.subject [row],'주간')>0 THEN Object.report [row] = '1'
   CASE 'sebu_cd'
      IF f_messageBox ('I002','이력관리에 생성하시겠습니까?~r~n업무상세내용으로 이력관리를 생성합니다.~r~n추가적인 수정은 이력관리에서 해야 합니다.')=2  Then
         RETURN 1
      End IF
      f_setprotect (THIS, true, { 'sebu_cd' }) ; f_dddwctl (THIS, 'sebu_cd', gaa.corp_gr, '', 1, "")

      ldt = Object.ymd [row]
      ls_week = Object.subject [row]
      ls_bfname = f_sysdate_str ('') +  '_' + gnv_vari.is_user_id
      ls_data = mle_detail.TEXT

      INSERT INTO  history
      VALUES ( :data                                      /* _1: */
             , :ldt                                       /* _2: */
             , NULL                                       /* _3: */
             , NULL                                       /* _4: */
             , :ls_week                                   /* _5: */
             , :ls_BFName                                 /* _6: */
             , NULL                                       /* _7: */
             );
      IF SQLCA.SQLCode()<>0 THEN MessageBox ('history INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())

      INSERT INTO  history_blob (
                     bfname                           /* _1: */
                   , clob_s )                         /* _2: */
      VALUES ( :ls_BFName                                 /* _1: */
             , :ls_data                                   /* _2: */
             );
      IF SQLCA.SQLCode()<>0 THEN MessageBox ('history_blob INSERT 실패:' + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())
END CHOOSE

IF f_null (mle_detail.TEXT) And ls_week=''   Then
   ls_week = '⊙ 주간업무~r~n  ㆍ ~r~n~r~n'
   FOR  li = 1  TO  5
      IF li=5 THEN Object.tymd [row] = ldt

      SELECT  :ldt + 1
            , :ls_week || '■ ' || TO_CHAR(:ldt,'dd') || '일(' || to_char(:ldt,'dy')
        INTO  :ldt
            , :ls_week
      FROM    dual t1;
		ldt     = SQLCA.getitemdatetime (1)
		ls_week = SQLCA.getitemstring (2)
      ls_week += ')~r~n  ㆍ ~r~n~r~n'
   NEXT
   mle_detail.TEXT = ls_week
   mle_detail.ib_update = TRUE
End IF
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;event ue_clob_update (mle_detail.TEXT, mle_result.TEXT)
RETURN 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;iRow = currentrow

is_username = Object.sb_nm [iRow]
idt_cre_ymd = Object.cre_ymd [iRow]

mle_detail.uf_init ('', NOT mle_detail.DisplayOnly)
mle_result.uf_init ('', NOT mle_result.DisplayOnly)

mle_detail.TEXT = Object.clob_d [currentrow]
mle_result.TEXT = Object.clob_r [currentrow]

IF dataobject='d_weekly_search'  Then
LONG	lPos
   lPos = POS (mle_detail.TEXT, mle_detail.is_search) ; mle_detail.SelectText (lPos, Len (mle_detail.is_search))
   lPos = POS (mle_result.TEXT, mle_result.is_search) ; mle_result.SelectText (lPos, Len (mle_result.is_search))
End IF

RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;event ue_clob_update (mle_detail.TEXT, mle_result.TEXT)

IF gaa.aams THEN uf_setColumn ('corp_gr', '2200')
uf_setcolumn ('sb_nm', gnv_vari.is_user_nm)
uf_setColumn ('ymd', f_sysdate_str ('yyyy-mm-dd'))
uf_setColumn ('bgroup', f_sysdate_str ('yyyy-mm-dd'))
uf_setColumn ('cre_ymd', f_sysdate_str ('yyyy-mm-dd hh24:mi:ss'))

POST SetColumn ('subject')

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_detail.uf_reset (TRUE)
mle_result.uf_reset (TRUE)

RETURN 0
end event

event ue_protect;call super::ue_protect;f_setprotect (THIS, true, { 'sebu_cd' })
IF ib_manageData  Then
   IF object.sb_nm [row]=gnv_vari.is_user_nm and (f_null (object.tymd [row]) or object.tymd [row]>=uf_initdate ('inputdate')) Then
      uf_protect (row, ia_protect [1])
      mle_detail.DisplayOnly = FALSE
      mle_result.DisplayOnly = FALSE
   Else
      uf_protect (row, ia_protect [2])
      mle_detail.DisplayOnly = TRUE
      IF Object.tymd [row]<idt_workdate THEN mle_result.DisplayOnly = TRUE &
      ELSE                                   mle_result.DisplayOnly = FALSE
   End IF
   IF NOT mle_detail.DisplayOnly And f_null (Object.sebu_cd [row]) THEN f_setprotect (THIS, false, { 'sebu_cd' })
Else
   uf_protect (row, ia_protect [2])
   mle_detail.DisplayOnly = TRUE
   mle_result.DisplayOnly = TRUE
End IF
f_dddwctl (THIS, 'sebu_cd', gaa.corp_gr, '', 1, "")
end event

event buttonup;call super::buttonup;STRING	ls_corp_gr, ls_sb_nm, ls_path, ls_local, ls_fname

Datetime	ldt

BLOB	lb_data

BOOLEAN	lb_return

CHOOSE CASE dwo.name
	CASE 'p_fexp'
		AcceptText ()
		uf_setrow (row, false)
		event ue_clob_update (mle_detail.TEXT, mle_result.TEXT)

		ls_corp_gr = Object.corp_gr [row]
		ls_sb_nm = Object.sb_nm [row]
		ldt = Object.cre_ymd [row]

		IF parent.EVENT wue_update ()=-1 THEN RETURN

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

		UPDATEBLOB  weekly
			SET  blob_f = :lb_data
		WHERE   corp_gr = :ls_corp_gr
		  AND   sb_nm   = :ls_sb_nm
		  AND   cre_ymd = :ldt;

		Object.fexp [row] = MID (ls_local, LASTPOS (ls_local,'.') + 1)

		filedelete (ls_path + '.zip')

	CASE 'p_fexp_open'
		uf_setrow (row, false)

		ls_corp_gr = Object.corp_gr [row]
		ls_sb_nm = Object.sb_nm [row]
		ldt = Object.cre_ymd [row]

      SELECTBLOB  blob_f
        INTO  :lb_data
      FROM    weekly  t1
		WHERE   t1.corp_gr = :ls_corp_gr
		  AND   t1.sb_nm   = :ls_sb_nm
		  AND   t1.cre_ymd = :ldt;

		enabled = false

		ls_fname = Object.org_fname [row]

		IF	f_notnull (ls_fname)	Then
	      FileDelete (gaa.temp + ls_fname + '.zip')
	      FileDelete (gaa.temp + ls_fname)
			lb_return = mo_.hex2file (gaa.temp + ls_fname + '.zip', SQLCA.is_Hexfile)
			IF	lb_return	Then
				/* 압축풀기... */
				mo_.unzip (gaa.temp + ls_fname + '.zip', gaa.temp)
				filedelete (gaa.temp + ls_fname + '.zip')
			End IF
		Else
			ls_fname = "__tmp" + string (now (),"hhmmssfff") + gnv_vari.is_user_id + '.' + Object.fexp [row]
			lb_return = mo_.Hex2File (gaa.temp + ls_fname, SQLCA.is_HexFile)
		End IF
		IF	NOT lb_return THEN f_messageBox ('ERR', '파일생성오류')

		ShellExecute (HANDLE (gw_mdi), 'open', ls_fname, '', gaa.temp, 1)

		enabled = true
END CHOOSE
end event

type rte_func1 from pf_u_richtextedit within w_weekly
integer x = 4005
integer y = 348
integer width = 1426
integer height = 160
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long init_backcolor = 67108864
boolean enabled = false
boolean border = false
end type

event constructor;backcolor = gnv_vari.setcondbackcolor
end event

type sle_search_text from pf_u_singlelineedit within w_weekly
integer x = 2263
integer y = 188
integer width = 727
integer height = 84
integer taborder = 50
boolean bringtotop = true
long textcolor = 33554432
end type

type cb_2 from pf_u_commandbutton within w_weekly
integer x = 3035
integer y = 180
integer width = 302
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "검색"
end type

event clicked;IF f_null (sle_search_text.TEXT) THEN RETURN
IF Parent.EVENT wue_confirmupdate4close ()=1 THEN RETURN

STRING	ls_like, ls_f_value

ls_like = sle_search_text.TEXT

DELETE rowid_in
WHERE  rt_key = :is_rt_key;

SELECT F_SYSTIMESTAMP()
  INTO :ls_f_value
FROM   DUAL;
ls_f_value = SQLCA.getitemstring (1)

is_rt_key = gaa.corp_gr + gnv_vari.is_user_id + ls_f_value

IF gaa.aams Then
   INSERT INTO rowid_in
     select :is_rt_key
          , corp_gr || TO_CHAR(ymd,'yyyymmdd') || sb_nm || to_char(cre_ymd,'yyyymmddhh24miss')
       from weekly t1
      where t1.corp_gr = '2200'
        and (lower (t1.subject) LIKE '%' || lower (:ls_like) || '%' OR
               lower (t1.clob_d) LIKE '%' || lower (:ls_like) || '%' OR
               lower (t1.clob_r) LIKE '%' || lower (:ls_like) || '%');
Else
   INSERT INTO rowid_in
     select :is_rt_key
          , corp_gr || TO_CHAR(ymd,'yyyymmdd') || sb_nm || to_char(cre_ymd,'yyyymmddhh24miss')
       from weekly t1
      where t1.corp_gr = :gaa.corp_gr
        and (t1.subject LIKE '%' || :ls_like || '%' OR t1.clob_d LIKE '%' || :ls_like || '%' OR t1.clob_r LIKE '%' || :ls_like || '%');
End IF
commitJ ();

mle_detail.uf_init (ls_like, FALSE)
mle_result.uf_init (ls_like, FALSE)

dw_List.uf_dataobject ('d_weekly_search', FALSE)

ib_managedata = FALSE
dw_1.reset ()
dw_1.retrieve (is_rt_key, gnv_vari.is_user_nm)
IF dw_1.ShareData (dw_List)<1 THEN MessageBox ('공유 실패', '자료공유에 실패하였습니다.', StopSign!)

dw_List.POST SetFocus ()
end event

type rte_func2 from pf_u_richtextedit within w_weekly
integer x = 4005
integer y = 1104
integer width = 1426
integer height = 92
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long init_backcolor = 67108864
boolean enabled = false
boolean border = false
end type

event constructor;backcolor = gnv_vari.setcondbackcolor
end event

type mle_detail from u_mle within w_weekly
integer x = 4005
integer y = 520
integer width = 1426
integer height = 576
integer taborder = 60
boolean bringtotop = true
fontcharset fontcharset = hangeul!
end type

event ue_print;call super::ue_print;dw_List.EVENT ue_print ()
end event

type mle_result from u_mle within w_weekly
integer x = 4005
integer y = 1212
integer width = 1426
integer height = 576
integer taborder = 70
boolean bringtotop = true
fontcharset fontcharset = hangeul!
end type

event ue_print;call super::ue_print;dw_List.EVENT ue_print ()
end event

type ole_1 from u_rd within w_weekly
boolean visible = false
integer x = 3250
integer y = 976
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string binarykey = "w_weekly.win"
boolean eb_directprint = true
end type

type dw_1 from fw_u_dwo within w_weekly
boolean visible = false
integer x = 4005
integer y = 1828
integer width = 1426
integer height = 876
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_weekly_search"
end type

type st_1 from pf_u_splitbar_vertical within w_weekly
integer x = 3982
integer y = 352
integer height = 2352
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
boolean leftmaxsizefixed = true
string leftdragobject = "dw_list"
string rightdragobject = "mle_result;mle_detail;rte_func2;rte_func1"
end type

