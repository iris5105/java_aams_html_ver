forward
global type w_manual_report from wt_vertole
end type
end forward

global type w_manual_report from wt_vertole
string is_init_value = "신탁회계"
end type
global w_manual_report w_manual_report

type variables
DateTime	idt_search

STRING	is_rt_key
end variables

event wue_retrieve;call super::wue_retrieve;f_dddwctl (dw_List, 'm_bun', gaa.corp_gr, '', 1, "")
f_dddwctl (dw_List, 'm_time_zone', gaa.corp_gr, '', 1, "")

IF	f_null (dw_c.object.like [1])	Then
	ia_value [1] = dw_c.object.bun [1]
	dw_List.Retrieve ( ia_value [1], gnv_vari.is_user_id )
Else
	dw_List.Retrieve ( is_rt_key, gnv_vari.is_user_id )
End IF
end event

on w_manual_report.create
int iCurrent
call super::create
end on

on w_manual_report.destroy
call super::destroy
end on

event close;call super::close;DELETE  rowid_in
WHERE   rt_key = :is_rt_key;
commitJ ()
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.bun [1] = ia_value [1]
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_manual_report
end type

type ln_templeft from wt_vertole`ln_templeft within w_manual_report
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_manual_report
end type

type ln_temptop from wt_vertole`ln_temptop within w_manual_report
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_manual_report
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_manual_report
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_manual_report
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_manual_report
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_manual_report
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_manual_report
end type

type ln_tempright from wt_vertole`ln_tempright within w_manual_report
end type

type uo_navi from wt_vertole`uo_navi within w_manual_report
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_manual_report
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_manual_report
end type

type st_top_rect from wt_vertole`st_top_rect within w_manual_report
end type

type p_close from wt_vertole`p_close within w_manual_report
end type

type p_excel from wt_vertole`p_excel within w_manual_report
end type

type p_print from wt_vertole`p_print within w_manual_report
end type

type p_delete from wt_vertole`p_delete within w_manual_report
end type

type p_update from wt_vertole`p_update within w_manual_report
end type

type p_input from wt_vertole`p_input within w_manual_report
end type

type p_retrieve from wt_vertole`p_retrieve within w_manual_report
end type

type p_clear from wt_vertole`p_clear within w_manual_report
end type

type p_copy from wt_vertole`p_copy within w_manual_report
end type

type dw_c from wt_vertole`dw_c within w_manual_report
string dataobject = "d_manual_c"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'bun'
      Object.like [1] = null_s
      RETURN
   CASE 'like'
      IF f_null (data) THEN RETURN
END CHOOSE

DateTime ldt_cre

STRING	ls_bun, ls_like, ls_title, ls_bfname, ls_work

STRING	ls_sqlsyntax1, ls_sqlsyntax2
LONG	lR1, lR2, ll1, ll2
aDS_jTier   lds_jtier1, lds_jtier2

idt_search = f_sysdate ('')
ls_bun = Object.bun [1]
ls_like = data

DELETE rowid_in
WHERE  rt_key = :is_rt_key;

ls_sqlsyntax1 = "   SELECT  title " &
              + "         , bfname " &
              + "   FROM    manual t1 " &
              + "   WHERE   bun = '" + ls_bun + "' "

ls_sqlsyntax2 = "   SELECT  cre_dt " &
              + "   FROM    manual_detail t1 " &
              + "   WHERE   bfname = '" + ls_bfname + "'' "

lR1 = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax1, lds_jtier1, 'xml')

is_rt_key = gaa.corp_gr + gnv_vari.is_user_id + f_sysdate_str ('')
FOR  ll1 = 1  TO  lR1
   ls_title  = lds_jtier1.getitemstring (ll1, 1)
   ls_bfname = lds_jtier1.getitemstring (ll1, 2)

   IF POS (ls_title, ls_like)>0  Then
      INSERT INTO rowid_in
      VALUES ( :is_rt_key    /* _1: */
             , :ls_bfname    /* _2: */
             );
   Else
      lR2 = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax2, lds_jtier2, 'xml')
      FOR  ll2 = 1  TO  lR2
         ldt_cre  = DATETIME(lds_jtier2.getitemString (ll2, 1))

         SELECT cwork
           INTO :ls_work
         FROM   manual_detail t1
         WHERE  bfname = :ls_bfname
           AND  cre_dt = :ldt_cre;

         ls_work = SQLCA.getitemstring (1)

         IF SQLCA.SQLCode()=0 And f_notnull (ls_work) Then
            IF POS (ls_work, ls_like)>0   Then
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
commitJ ()
end event

event dw_c::ue_valid;call super::ue_valid;IF	f_null (Object.like [1]) THEN
	dw_List.uf_dataobject ('d_manual', FALSE)
ELSE
	dw_List.uf_dataobject ('d_manual_search', FALSE)
End IF
RETURN TRUE
end event

type btn_update from wt_vertole`btn_update within w_manual_report
end type

type st_count from wt_vertole`st_count within w_manual_report
end type

type dw_list from wt_vertole`dw_list within w_manual_report
boolean visible = true
string dataobject = "d_manual"
end type

event dw_list::clicked;LONG	lRow, lRowCount

IF	dwo.NAME='fseq_all' And uf_getrange ()=FALSE Then
	lRowCount = rowcount ()
	FOR  lRow = 1  TO  lRowCount
		SelectRow (lRow, TRUE)
	NEXT
	uf_setrange (true)
	RETURN
End IF

CALL  super::clicked
end event

event dw_list::doubleclicked;LONG	lRow, lRowCount

STRING	ls

IF	row>0	Then
	CHOOSE CASE	dwo.name
		CASE 'm_bun'
			ls = Object.m_bun [row]
			lRowCount = rowcount ()
			FOR  lRow = 1  TO  lRowCount
				IF	Object.m_bun [lRow]=ls	THEN	SelectRow (lRow, TRUE) &
				ELSE										SelectRow (lRow, FALSE)
			NEXT
			uf_setrange (true)
		CASE 'work_user'
			ls = Object.work_user [row]
			lRowCount = rowcount ()
			FOR  lRow = 1  TO  lRowCount
				IF	Object.work_user [lRow]=ls	THEN	SelectRow (lRow, TRUE) &
				ELSE											SelectRow (lRow, FALSE)
			NEXT
			uf_setrange (true)
	END CHOOSE
	Enabled = FALSE
	ole_rd.EVENT ue_retrieve (row)
	Enabled = TRUE ; SetFocus ()
End IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'm_time_zone', gaa.corp_gr, '', 1, "")
f_dddwctl (THIS, 'work_user', gaa.corp_gr, '', 1, "")
end event

type st_move from wt_vertole`st_move within w_manual_report
end type

type ole_rd from wt_vertole`ole_rd within w_manual_report
integer x = 2638
integer width = 2793
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;IF row=0 THEN RETURN

LONG	ll

STRING	ls_bfname

DELETE rowid_in
WHERE  rt_key = :is_rt_key;

is_rt_key = gaa.corp_gr + gnv_vari.is_user_id + f_sysdate_str ('')

ll = dw_List.GetSelectedRow (0)
DO WHILE ll > 0
   ls_bfname = dw_List.object.bfname [ll]

   INSERT INTO rowid_in
   VALUES ( :is_rt_key    /* _1: */
          , :ls_bfname    /* _2: */
          );

   ll = dw_List.GetSelectedRow (ll)
LOOP
commitJ ()

::clipboard (is_rt_key)
uf_fileopen ('rd_manual.mrd', 'rt_key[' + is_rt_key + ']')
end event

type rb_onepage from wt_vertole`rb_onepage within w_manual_report
end type

