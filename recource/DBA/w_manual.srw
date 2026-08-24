forward
global type w_manual from w_winpage
end type
type dw_list from u_dw within w_manual
end type
type dw_detail from u_dw within w_manual
end type
type rte_func1 from pf_u_richtextedit within w_manual
end type
type rte_func2 from pf_u_richtextedit within w_manual
end type
type mle_job from u_mle within w_manual
end type
type mle_no from u_mle within w_manual
end type
type cb_other from pf_u_commandbutton within w_manual
end type
type st_1 from pf_u_splitbar_vertical within w_manual
end type
end forward

global type w_manual from w_winpage
string is_init_value = "신탁회계"
dw_list dw_list
dw_detail dw_detail
rte_func1 rte_func1
rte_func2 rte_func2
mle_job mle_job
mle_no mle_no
cb_other cb_other
st_1 st_1
end type
global w_manual w_manual

type variables
LONG	tRow = 0

STRING	is_BFname, is_rt_key

DateTime idt_cre, idt_search

end variables

on w_manual.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.rte_func1=create rte_func1
this.rte_func2=create rte_func2
this.mle_job=create mle_job
this.mle_no=create mle_no
this.cb_other=create cb_other
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.rte_func1
this.Control[iCurrent+4]=this.rte_func2
this.Control[iCurrent+5]=this.mle_job
this.Control[iCurrent+6]=this.mle_no
this.Control[iCurrent+7]=this.cb_other
this.Control[iCurrent+8]=this.st_1
end on

on w_manual.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.rte_func1)
destroy(this.rte_func2)
destroy(this.mle_job)
destroy(this.mle_no)
destroy(this.cb_other)
destroy(this.st_1)
end on

event wue_postopen;call super::wue_postopen;f_memo ('function manual1', rte_func1)
f_memo ('function manual2', rte_func2)

dw_List.TAG = TITLE
dw_List.SetTransObject (SQLCA)
dw_List.EVENT ue_dddw_retrieve ()

dw_Detail.TAG = TITLE + ' 세부사항'
dw_Detail.SetTransObject (SQLCA)
dw_Detail.EVENT ue_dddw_retrieve ()

p_retrieve.POST EVENT Clicked ()
end event

event wue_clear;call super::wue_clear;IF EVENT wue_confirmupdate4close ()=1 THEN RETURN
iRow = 0
mle_job.uf_reset (FALSE)
mle_no.uf_reset (FALSE)
dw_Detail.uf_reset (FALSE)
dw_List.uf_reset (FALSE)
dw_Detail.Modify (dw_Detail.ia_protect [4])
dw_Detail.insertrow (0)
dw_List.Modify (dw_List.ia_protect [4])
dw_List.insertrow (0)

p_retrieve.of_setenabled (true)
EVENT ue_setdisabled ()

dw_c.object.like [1] = null_s
dw_c.Enabled = TRUE
dw_c.SetFocus () ; f_selectText (dw_c)
end event

event ue_activate;call super::ue_activate;rte_func1.backcolor = gnv_vari.setcondbackcolor
rte_func2.backcolor = gnv_vari.setcondbackcolor
IF mle_job.displayonly  Then mle_job.backcolor = gnv_vari.setcondbackcolor &
ELSE                        mle_no.BackColor = rgb(240,255,255)
IF mle_no.displayonly   Then mle_no.backcolor = gnv_vari.setcondbackcolor &
ELSE                        mle_no.BackColor = rgb(240,255,255)
end event

event wue_update;call super::wue_update;IF dw_List.AcceptText ()=-1 OR dw_Detail.AcceptText ()=-1  Then
   f_messageBox ('W006', '')
   RETURN -1
End IF
IF EVENT ue_wpage_Modified () Then
   IF mle_no.EVENT ue_blob_update (0)=1 THEN RETURN -1
   IF mle_job.EVENT ue_blob_update (0)=1 THEN RETURN -1
   RETURN   uf_updateCommit (dw_List, dw_Detail)
End IF
RETURN 1
end event

event resize;call super::resize;//dw_List.Y = gb_c.Height + 8
//f_auto_width (dw_List, 0, Width, 0)
dw_List.Height = truncate ((Height - dw_list.y - 185) * .6,0)

dw_Detail.Y = dw_List.Y + dw_List.Height + 30 + 80
dw_Detail.Width = dw_List.Width
dw_Detail.Height = Height - 185 - dw_Detail.Y

//st_VBar.X = dw_List.Width
//st_VBar.Y = dw_List.Y
//st_VBar.Height = Height - st_VBar.Y
//
//rte_func1.X = st_VBar.X + st_VBar.Width
rte_func1.Y = dw_List.Y
rte_func1.Width = Width - rte_func1.X - 125

mle_job.X = rte_func1.X
mle_job.Y = dw_List.Y + rte_func1.Height + 4
mle_job.Width = rte_func1.Width
mle_job.Height = dw_List.Height - rte_func1.Height - 4

rte_func2.X = rte_func1.X
rte_func2.Y = mle_job.Y + mle_job.Height + 30
rte_func2.Width = rte_func1.Width

mle_no.X = rte_func1.X
mle_no.Y = rte_func2.Y + rte_func2.Height + 4
mle_no.Width = rte_func1.Width
mle_no.Height = (Height - 185) - mle_no.Y

cb_other.of_setVisible (gaa.admin OR gaa.aams)

dw_List.ScrollToRow (iRow)
dw_Detail.ScrollToRow (dw_Detail.GetRow ())
end event

event wue_retrieve;call super::wue_retrieve;f_dddw_filter (dw_List, 'm_bun', "rt_key='" + dw_c.object.bun [1] + "'")
IF f_null (dw_c.object.like [1]) Then
   dw_list.retrieve (ia_value [1], gnv_vari.is_user_id )
Else
   dw_list.retrieve (is_rt_key, gnv_vari.is_user_id )
End IF
end event

event ue_wpage_modified;call super::ue_wpage_modified;RETURN	(dw_list.uf_isModified () OR dw_detail.uf_isModified () OR mle_job.ib_update OR mle_no.ib_update)
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.bun [1] = ia_value [1]
end event

event close;call super::close;DELETE  rowid_in
WHERE   rt_key = :is_rt_key;
CommitJ()
end event

event ue_setenabled;call super::ue_setenabled;IF dw_list.rowcount ()>0 And dw_detail.ibsetlist4subbtn	Then
	dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, true)
	dw_detail.of_dw2subbtn ({'p_input'}, (dw_detail.enabled And dw_detail.eb_new_false=FALSE And ib_managedata))
	dw_detail.of_dw2subbtn ({'p_copy'}, (dw_detail.enabled And dw_detail.eb_copy_false=FALSE And ib_managedata))
	dw_detail.of_dw2subbtn ({'p_delete'}, (dw_detail.enabled And dw_detail.eb_delete_false=FALSE And ib_managedata))

ElseIF dw_list.rowcount ()=0  And dw_detail.ibsetlist4subbtn Then
	IF dw_detail.ibsetlist4subbtn THEN dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
End IF
end event

event ue_setdisabled;call super::ue_setdisabled;IF dw_detail.ibsetlist4subbtn THEN dw_detail.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
end event

event open;icmdbutton = { cb_other }
call super::open
end event

type lb_dirlist from w_winpage`lb_dirlist within w_manual
end type

type ln_templeft from w_winpage`ln_templeft within w_manual
end type

type ln_tempbuttom from w_winpage`ln_tempbuttom within w_manual
end type

type ln_temptop from w_winpage`ln_temptop within w_manual
end type

type ln_tempbutton from w_winpage`ln_tempbutton within w_manual
end type

type ln_tempstart from w_winpage`ln_tempstart within w_manual
end type

type ln_cond1_yline from w_winpage`ln_cond1_yline within w_manual
end type

type ln_dw1_yline from w_winpage`ln_dw1_yline within w_manual
end type

type ln_cond2_yline from w_winpage`ln_cond2_yline within w_manual
end type

type ln_dw2_yline from w_winpage`ln_dw2_yline within w_manual
end type

type ln_tempright from w_winpage`ln_tempright within w_manual
end type

type uo_navi from w_winpage`uo_navi within w_manual
end type

type ln_temptop_shadow from w_winpage`ln_temptop_shadow within w_manual
end type

type st_windelaytime from w_winpage`st_windelaytime within w_manual
end type

type st_top_rect from w_winpage`st_top_rect within w_manual
end type

type p_close from w_winpage`p_close within w_manual
end type

type p_excel from w_winpage`p_excel within w_manual
end type

type p_print from w_winpage`p_print within w_manual
end type

type p_delete from w_winpage`p_delete within w_manual
end type

type p_update from w_winpage`p_update within w_manual
end type

type p_input from w_winpage`p_input within w_manual
end type

type p_retrieve from w_winpage`p_retrieve within w_manual
end type

event p_retrieve::clicked;IF f_null (dw_c.object.like [1])   Then
   ib_manageData = TRUE
   dw_c.Enabled = FALSE
	IF	p_clear.visible	Then
		p_clear.of_setenabled (true)
		of_setenabled (false)
	End IF

   IF gaa.admin THEN
		dw_List.uf_dataobject ('d_manual_admin', TRUE) 
   ELSE   
		dw_List.uf_dataobject ('d_manual', TRUE)
	End IF

   mle_job.uf_init ('', TRUE)
   mle_no.uf_init ('', TRUE)
Else
   ib_manageData = FALSE

   gw_mdi.setmicrohelp (string (Now ()) + ':조회 화면입니다.')
   dw_List.uf_dataobject ('d_manual_search', FALSE)

   mle_job.uf_init (dw_c.object.like [1], FALSE)
   mle_no.uf_init (dw_c.object.like [1], FALSE)
End IF

IF ib_ManageData  Then
   dw_List.uf_protect (0, dw_List.ia_protect [1]) ; dw_Detail.uf_protect (0, dw_Detail.ia_protect [1])
Else
   dw_List.uf_protect (0, dw_List.ia_protect [2]) ; dw_Detail.uf_protect (0, dw_Detail.ia_protect [2])
End IF

dw_Detail.uf_reset (TRUE)
dw_List.uf_reset (TRUE)

call super::clicked
end event

type p_clear from w_winpage`p_clear within w_manual
end type

type p_copy from w_winpage`p_copy within w_manual
end type

type dw_c from w_winpage`dw_c within w_manual
integer taborder = 40
string dataobject = "d_manual_c"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'bun'
      Object.like [1] = null_s
      ia_value [1] = data
      RETURN
   CASE 'like'
      IF f_null (data) THEN RETURN
END CHOOSE

DateTime ldt_cre

STRING	ls_bun, ls_like, ls_title, ls_bfname, ls_work, ls_sqlsyntax1, ls_sqlsyntax2

LONG	lR1, lm1, lR2, lm2

aDS_jTier   lds_jtier1, lds_jtier2

idt_search = f_sysdate ('')
ls_bun = Object.bun [1]
ls_like = data

IF EVENT wue_confirmupdate4close ()=1 THEN RETURN 1

DELETE rowid_in
WHERE  rt_key = :is_rt_key;

is_rt_key = gaa.corp_gr + gnv_vari.is_user_id + f_sysdate_str ('')

ls_sqlsyntax1 = "   SELECT  title " &
              + "         , bfname " &
              + "   FROM    manual t1 " &
              + "   WHERE   bun = "+f_nvl("'"+ls_bun+"'","null")+" "

ls_sqlsyntax2 = "   SELECT  cre_dt " &
              + "   FROM    manual_detail t1 " &
              + "   WHERE   bfname = "+f_nvl("'"+ls_bfname+"'","null")+" "


lR1 = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax1, lds_jtier1, 'xml')

FOR  lm1 = 1  TO  lR1
      ls_title  = lds_jtier1.getitemstring (lm1, 1)
      ls_bfname = lds_jtier1.getitemstring (lm1, 2)

   SELECT cwork
     INTO :ls_work
   FROM   manual t1
   WHERE  bfname = :ls_bfname;

   ls_work = SQLCA.getitemstring (1)

   IF SQLCA.SQLCode()=0 And NOT f_null (ls_work) THEN ls_title += ls_work

   IF POS (lower (ls_title), lower (ls_like))>0 Then
      INSERT INTO rowid_in
      VALUES ( :is_rt_key    /* _1: */
             , :ls_bfname    /* _2: */
             );
   Else
      lR2 = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax2, lds_jtier2, 'xml')
      FOR  lm2 = 1  TO  lR2
            ldt_cre = DATETIME(lds_jtier2.getitemString (lm2, 1))

         SELECT cwork
           INTO :ls_work
         FROM   manual_detail t1
         WHERE  bfname = :ls_bfname
           AND  cre_dt = :ldt_cre;

         ls_work = SQLCA.getitemstring (1)

         IF SQLCA.SQLCode()=0 And NOT f_null (ls_work)   Then
            IF POS (lower (ls_work), lower (ls_like))>0  Then
               INSERT INTO rowid_in
               VALUES ( :is_rt_key    /* _1: */
                      , :ls_bfname    /* _2: */
                      );
               EXIT
            End IF
         End IF
      NEXT
   End IF
NEXT
end event

type btn_update from w_winpage`btn_update within w_manual
end type

type st_count from w_winpage`st_count within w_manual
end type

type dw_list from u_dw within w_manual
integer x = 50
integer y = 348
integer width = 3173
integer height = 848
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_manual"
boolean vscrollbar = true
boolean eb_range_delcopy = false
boolean eb_always_1_insert = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event retrieveend;call super::retrieveend;IF f_num (rowcount )=0  Then
   mle_no.uf_reset (TRUE)
   mle_no.DisplayOnly = TRUE
   dw_Detail.uf_retrieveend ('detail', 0, FALSE)
   mle_job.uf_reset (TRUE)
   mle_job.DisplayOnly = TRUE
End IF
uf_retrieveend (is_find, rowcount, ib_manageData)
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'm_bun', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'm_time_zone', gaa.corp_gr, '', 1, "")
end event

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

STRING	ls_old

LONG	lRow, lRowCount

lRowCount = rowcount ()

//CHOOSE CASE  dwo.name
// CASE 'work_user'
//    IF gaa.admin Then
//       ls_old = dwo.primary [row]
//       IF f_messageBox ('I002', '이후 자료 작업자를 일괄 변경하시겠습니까?')=1 Then
//          FOR  lRow = row + 1  TO  lRowCount
//             IF Object.work_user [lRow]=ls_old   THEN Object.work_user [lRow] = data
//          NEXT
//       End IF
//    End IF
//
// CASE 'update_user'
//    IF gaa.admin Then
//       ls_old = dwo.primary [row]
//       IF f_messageBox ('I002', '이후 자료 작업자를 일괄 변경하시겠습니까?')=1 Then
//          FOR  lRow = row + 1  TO  lRowCount
//             IF Object.update_user [lRow]=ls_old THEN Object.update_user [lRow] = data
//          NEXT
//       End IF
//    End IF
//END CHOOSE
end event

event constructor;call super::constructor;eb_delete_false = NOT (gaa.admin OR gaa.aams)
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;IF mle_no.EVENT ue_blob_update (0)=1 THEN RETURN 1
IF mle_job.EVENT ue_blob_update (0)=1 THEN RETURN 1

IF dw_detail.uf_update ()=FALSE THEN RETURN 1
IF uf_update ()=FALSE           THEN RETURN 1

RETURN 0
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;LONG	lPos

iRow = currentrow

is_BFname = Object.bfname [iRow]

mle_job.uf_init ('', NOT mle_job.DisplayOnly)
mle_no.uf_init ('', NOT mle_job.DisplayOnly)

mle_job.TEXT = Object.cwork [iRow]

dw_Detail.uf_reset ()
dw_Detail.EVENT ue_retrieve ()

IF dataobject='d_manual_search'  Then
   lPos = POS (mle_job.TEXT, mle_job.is_search) ; mle_job.SelectText (lPos, Len (mle_job.is_search))
End IF
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;IF mle_no.EVENT ue_blob_update (0)=1 THEN RETURN 1
IF mle_job.EVENT ue_blob_update (0)=1 THEN RETURN 1

is_bfname = string (f_sysdate ('')) + '_' + gnv_vari.is_user_id

uf_setColumn ('bfname',is_BFname)
uf_setColumn ('bun', dw_c.object.bun [1])
uf_setcolumn ('work_user', gnv_vari.is_user_nm)
uf_setcolumn ('update_user', gnv_vari.is_user_nm)
uf_setColumn ('update_dt', string (idt_workdate))

IF iRow>0   Then
   uf_setColumn ('m_bun', object.m_bun [iRow])
   uf_setColumn ('m_time_zone', object.m_time_zone [iRow])
   uf_setColumn ('work_time', string (object.work_time [iRow]))
End IF

POST SetColumn ('work_time')

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_job.uf_reset (TRUE)
mle_no.uf_reset (TRUE)
dw_Detail.uf_deleteall ()
RETURN 0
end event

event ue_protect;call super::ue_protect;IF ib_manageData Then
   IF gaa.admin or gaa.aams or object.work_user [row]=gnv_vari.is_user_nm or object.update_user [row]=gnv_vari.is_user_nm or object.update_user [row]='%' Then
      uf_protect (row, ia_protect [1]) ; dw_Detail.uf_protect (row, dw_Detail.ia_protect [1])
      mle_job.DisplayOnly = FALSE
   Else
      uf_protect (row, ia_protect [2]) ; dw_Detail.uf_protect (row, dw_Detail.ia_protect [2])
      mle_job.DisplayOnly = TRUE
   End IF
Else
   uf_protect (row, ia_protect [2]) ; dw_Detail.uf_protect (row, dw_Detail.ia_protect [2])
   mle_job.DisplayOnly = TRUE
End IF
end event

type dw_detail from u_dw within w_manual
integer x = 50
integer y = 1212
integer width = 3173
integer height = 1492
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_manual_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean ibsetlist4subbtn = true
boolean eb_copy_false = true
boolean eb_delete_false = true
string is_resize_column = "xx_obj_id"
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('detail', rowcount, FALSE)
IF rowcount=0  Then
   tRow = 0
   mle_no.uf_reset (TRUE)
   mle_no.DisplayOnly = TRUE
End IF
end event

event ue_retrieve;call super::ue_retrieve;retrieve (is_BFname, dw_c.object.bun [1])
end event

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
IF	dwo.name='point'	Then
   IF data='1' THEN Object.color [row] = 16711680 ELSE Object.color [row] = 33554432
End IF
end event

event constructor;call super::constructor;eb_delete_false = NOT (gaa.admin OR gaa.aams)
end event

event rowfocuschanged_if;call super::rowfocuschanged_if;mle_no.DisplayOnly = mle_job.DisplayOnly

tRow = currentrow

idt_cre = Object.cre_dt [tRow]

mle_no.uf_init ('', NOT mle_no.DisplayOnly)
mle_no.TEXT = Object.cwork [tRow]

IF dw_List.dataobject='d_manual_search'   Then
   LONG	lPos
   lPos = POS (mle_no.TEXT, mle_no.is_search) ; mle_no.SelectText (lPos, Len (mle_no.is_search))
End IF
RETURN 0
end event

event rowfocuschanging_return;call super::rowfocuschanging_return;mle_no.EVENT ue_blob_update (0)
RETURN 0
end event

event ue_insertstart;call super::ue_insertstart;mle_no.EVENT ue_blob_update (0)

IF tRow=0   Then
   uf_SetColumn ('work_time', dw_list.object.work_time [iRow])
Else
   uf_SetColumn ('work_time', Object.work_time [tRow])
End IF

idt_cre = f_sysdate ('')

uf_setColumn ('bfname', is_BFname)
uf_setColumn ('cre_dt', string (idt_cre))

POST SetColumn ('obj_id')

RETURN 0
end event

event ue_deletestart;call super::ue_deletestart;mle_no.uf_reset (TRUE)
RETURN 0
end event

event ue_protect;call super::ue_protect;mle_no.DisplayOnly = mle_job.DisplayOnly
end event

event ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'obj_id'
      CHOOSE CASE dw_c.object.bun [1]
         CASE '재무회계'
            RETURN 2
         CASE '전자결재'
            RETURN 3
      END CHOOSE
END CHOOSE
RETURN 1 // 순번
end event

type rte_func1 from pf_u_richtextedit within w_manual
integer x = 3255
integer y = 348
integer width = 1358
integer height = 160
integer taborder = 40
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

type rte_func2 from pf_u_richtextedit within w_manual
integer x = 3255
integer y = 1100
integer width = 1358
integer height = 92
integer taborder = 40
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

type mle_job from u_mle within w_manual
integer x = 3255
integer y = 520
integer width = 1358
integer height = 576
integer taborder = 70
boolean bringtotop = true
end type

event ue_print;call super::ue_print;dw_List.EVENT ue_print ()
end event

event ue_blob_update;call super::ue_blob_update;IF NOT ib_update THEN RETURN 0

dw_List.object.cwork [iRow] = TEXT
dw_List.object.update_dt [iRow] = f_sysdate ('')

RETURN 0
end event

type mle_no from u_mle within w_manual
integer x = 3250
integer y = 1208
integer width = 1358
integer height = 576
integer taborder = 80
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = hangeul!
end type

event ue_print;call super::ue_print;dw_List.EVENT ue_print ()
end event

event ue_blob_update;call super::ue_blob_update;IF NOT ib_update THEN RETURN 0

dw_Detail.object.cwork [tRow] = TEXT
dw_List.object.update_dt [iRow] = f_sysdate ('')

RETURN 0
end event

type cb_other from pf_u_commandbutton within w_manual
integer x = 2231
integer y = 16
integer width = 343
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "화면전환"
end type

event clicked;IF EVENT wue_confirmupdate4close ()=1	THEN RETURN
IF ib_managedata = FALSE					THEN RETURN

CHOOSE CASE dw_List.dataobject
   CASE 'd_manual'
      dw_List.uf_dataobject ('d_manual_admin', FALSE)
   CASE 'd_manual_admin'
      dw_List.uf_dataobject ('d_manual', FALSE)
END CHOOSE

dw_list.retrieve (dw_c.object.bun [1], gnv_vari.is_user_id )
end event

type st_1 from pf_u_splitbar_vertical within w_manual
integer x = 3227
integer y = 348
integer height = 2416
boolean bringtotop = true
boolean setcondcolor = true
boolean scaletobottom = false
string leftdragobject = "dw_list;dw_detail"
string rightdragobject = "rte_func1;rte_func2;mle_job;mle_no"
end type

