forward
global type w_wfrm04m_manage from wt_list
end type
type cb_getobject from pf_u_commandbutton within w_wfrm04m_manage
end type
end forward

global type w_wfrm04m_manage from wt_list
boolean eb_direct_retrieve = true
cb_getobject cb_getobject
end type
global w_wfrm04m_manage w_wfrm04m_manage

on w_wfrm04m_manage.create
int iCurrent
call super::create
this.cb_getobject=create cb_getobject
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_getobject
end on

on w_wfrm04m_manage.destroy
call super::destroy
destroy(this.cb_getobject)
end on

event wue_retrieve;call super::wue_retrieve;dw_List.retrieve ()
end event

event open;icmdbutton = { cb_getobject }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_wfrm04m_manage
end type

type ln_templeft from wt_list`ln_templeft within w_wfrm04m_manage
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_wfrm04m_manage
end type

type ln_temptop from wt_list`ln_temptop within w_wfrm04m_manage
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_wfrm04m_manage
end type

type ln_tempstart from wt_list`ln_tempstart within w_wfrm04m_manage
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_wfrm04m_manage
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_wfrm04m_manage
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_wfrm04m_manage
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_wfrm04m_manage
end type

type ln_tempright from wt_list`ln_tempright within w_wfrm04m_manage
end type

type uo_navi from wt_list`uo_navi within w_wfrm04m_manage
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_wfrm04m_manage
end type

type st_windelaytime from wt_list`st_windelaytime within w_wfrm04m_manage
end type

type p_close from wt_list`p_close within w_wfrm04m_manage
end type

type p_excel from wt_list`p_excel within w_wfrm04m_manage
end type

type p_print from wt_list`p_print within w_wfrm04m_manage
end type

type p_delete from wt_list`p_delete within w_wfrm04m_manage
end type

type p_update from wt_list`p_update within w_wfrm04m_manage
end type

type p_input from wt_list`p_input within w_wfrm04m_manage
end type

type p_retrieve from wt_list`p_retrieve within w_wfrm04m_manage
end type

type p_clear from wt_list`p_clear within w_wfrm04m_manage
end type

type p_copy from wt_list`p_copy within w_wfrm04m_manage
end type

type dw_c from wt_list`dw_c within w_wfrm04m_manage
boolean visible = false
boolean applydesign = false
boolean useborder = false
end type

type btn_update from wt_list`btn_update within w_wfrm04m_manage
end type

type dw_list from wt_list`dw_list within w_wfrm04m_manage
integer y = 156
integer height = 2608
string dataobject = "d_wfrm04m_manage"
end type

event dw_list::updateend;call super::updateend;LONG   ll

STRING   ls_new, ls_old

FOR  ll = 1  TO  rowcount ()
   IF GetItemStatus (ll, 'obj_id', Primary!)=DataModified!  Then
      ls_new = GetItemString (ll, 'obj_id')
      ls_old = GetItemString (ll, 'obj_id', Primary!, TRUE)

      UPDATE  wfrm07t
         SET  obj_id = :ls_new
      WHERE   obj_id = :ls_old;

      UPDATE  wfrm08t
         SET  roleobj_id = :ls_new
      WHERE   roleobj_id = :ls_old;

      UPDATE  wfrm09t
         SET  obj_id = :ls_new
      WHERE   obj_id = :ls_old;

      UPDATE  whlp00m
         SET  obj_id = :ls_new
      WHERE   obj_id = :ls_old;

      UPDATE  manual_detail
         SET  obj_id = :ls_new
      WHERE   obj_id = :ls_old;

      UPDATE  szx1pt
         SET  obj_id = :ls_new
      WHERE   obj_id = :ls_old;
   End IF

   IF GetItemStatus (ll, 'obj_no', Primary!)=DataModified!  Then
      ls_old = GetItemString (ll, 'obj_no', Primary!, TRUE)
      IF NOT f_null (ls_old)  Then
         UPDATE  obj_no
            SET  obj_id = NULL
         WHERE   obj_no = :ls_old;
      End IF

      ls_old = Object.obj_id [ll]
      ls_new = Object.obj_no [ll]
      IF f_notnull (ls_new)   Then
         UPDATE  obj_no
            SET  obj_id = :ls_old
         WHERE   obj_no = :ls_new;
      End IF
   End IF
NEXT

FOR  ll = 1  TO  rowsdeleted
   ls_old = GetItemString (ll, 'obj_id', Delete!, TRUE)

   DELETE  wfrm07t
   WHERE   obj_id = :ls_old;

   DELETE  wfrm08t
   WHERE   roleobj_id = :ls_old;

   DELETE  wfrm09t
   WHERE   obj_id = :ls_old;

   DELETE  whlp00m
   WHERE   obj_id = :ls_old;

   DELETE  obj_use
   WHERE   obj_id = :ls_old;

   UPDATE  obj_no
      SET  obj_id = NULL
   WHERE   obj_id = :ls_old;
NEXT
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1
IF f_null (data) THEN RETURN

LONG  ll

STRING   ls

CHOOSE CASE dwo.name
   CASE 'obj_no'
      FOR  ll = 1  TO  rowcount ()
         IF ll<>row  Then
            IF Object.obj_no [ll]=data Then
               RETURN uf_itemerr (row, 'obj_no', '사용하고 있는 화면번호 입니다.')
            End IF
         End IF
      NEXT

      SELECT  '1'
        INTO  :ls
      FROM    obj_no t1
      WHERE   obj_no = :data
        AND   obj_id is not null;
		  
		ls = SQLCA.getitemstring (1)
		  
      IF SQLCA.SQLCode()=0   Then
         RETURN uf_itemerr (row, 'obj_no', '사용하고 있는 화면번호 입니다.')
      End IF
   CASE 'obj_nm'
      ls = Object.obj_id [row]
END CHOOSE
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_SetColumn ('right_yn','N')

POST SetColumn ('obj_id')

RETURN 0
end event

event dw_list::doubleclicked;call super::doubleclicked;IF row<1 THEN RETURN

//Window   w_open
//
//IF dwo.BAND='detail'	Then
//	CHOOSE CASE LEFT (lower (Object.obj_id [row]),1)
//		CASE 'u'
//			w_main.POST EVENT ue_Open_Tabpage (Object.obj_id [row], Object.obj_nm [row] + IIF (f_null (Object.obj_no [row]),'','('+Object.obj_no [row]+')'), w_main.uo_treemenu.tv_menu.picturename [long (Object.obj_type [row])])
//		CASE 'w'
//			OPEN (w_Open, string (Object.obj_id [row]))
//	END CHOOSE
//End IF
end event

event dw_list::ue_copyrowset;call super::ue_copyrowset;Object.obj_no [row] = ''
end event

type cb_getobject from pf_u_commandbutton within w_wfrm04m_manage
integer x = 2231
integer y = 16
integer width = 585
integer taborder = 30
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "오브젝트가져오기"
end type

event clicked;OpenWithParm (w_get_Object, dw_List)
dw_list.SetFocus ()
end event

