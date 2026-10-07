forward
global type w_object_help from w_response1st
end type
type cbx_1 from pf_u_checkbox within w_object_help
end type
type mle_1 from u_mle within w_object_help
end type
type rte_function from pf_u_richtextedit within w_object_help
end type
type cb_print from pf_u_commandbutton within w_object_help
end type
type cb_ok from pf_u_commandbutton within w_object_help
end type
end forward

global type w_object_help from w_response1st
integer width = 3621
integer height = 2532
string title = "도움말 작성"
cbx_1 cbx_1
mle_1 mle_1
rte_function rte_function
cb_print cb_print
cb_ok cb_ok
end type
global w_object_help w_object_help

type variables
STRING   is_ObjectID, is_WHLP00M

end variables

on w_object_help.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.mle_1=create mle_1
this.rte_function=create rte_function
this.cb_print=create cb_print
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.mle_1
this.Control[iCurrent+3]=this.rte_function
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_ok
end on

on w_object_help.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.mle_1)
destroy(this.rte_function)
destroy(this.cb_print)
destroy(this.cb_ok)
end on

event open;call super::open;STRING	ls_pass='no', ls_obj_nm, ls_path, ls_rolenm, ls_subrole

is_ObjectID = Message.StringParm

IF ls_pass='no'   Then
   SELECT  CASE WHEN obj_no IS NULL THEN obj_nm ELSE obj_nm || '(' || obj_no || ')' END
     INTO  :ls_obj_nm
   FROM    WFRM04M t1
   WHERE   OBJ_ID = :is_ObjectID;
	
	ls_obj_nm = SQLCA.getitemstring (1)
	
End IF
IF SQLCA.SQLCode ()=0 Then
   TITLE = ls_obj_nm + ' 도움말'

   SELECT  OBJ_HELP
     INTO  :mle_1.TEXT
   FROM    WHLP00M t1
   WHERE   OBJ_ID = :is_ObjectID;
	
	mle_1.TEXT = SQLCA.getitemstring (1)
   IF SQLCA.SQLCode ()=0 Then
      is_WHLP00M = 'update'
   Else
      is_WHLP00M = 'insert'   // insertrow

      SELECT  OBJ_HELP
        INTO  :mle_1.TEXT
      FROM    WHLP00M t1
      WHERE   OBJ_ID = 'u_whlp00m_help_list';
		
		mle_1.TEXT = SQLCA.getitemstring (1)

      SELECT  t2.role_nm
            , t1.role_id
        INTO  :ls_rolenm
            , :ls_subrole
      FROM    wfrm07t t1
            , wfrm03m t2
      WHERE   t1.obj_id  = :is_objectid
        AND   t2.role_id = t1.role_id
        AND   ROWNUM = 1;
		
		ls_rolenm  = SQLCA.getitemstring (1)
		ls_subrole = SQLCA.getitemstring (2)

      ls_path = ls_rolenm
      DO
         SELECT  t2.role_nm
               , t1.role_id
           INTO  :ls_rolenm
               , :ls_subrole
         FROM    wfrm06t t1
               , wfrm03m t2
         WHERE   t1.subrole_id = :ls_subrole
           AND   t2.role_id    = t1.role_id;
			
			ls_rolenm  = SQLCA.getitemstring (1)
			ls_subrole = SQLCA.getitemstring (2)

         IF SQLCA.SQLCode ()=0 THEN ls_path = ls_rolenm + '  ▶  ' + ls_path
      LOOP UNTIL  SQLCA.SQLCode ()<>0

      mle_1.TEXT = f_replace (f_replace (string (mle_1.TEXT), 'path', ls_path), 'user_name', gnv_vari.is_user_nm)
   End IF
   mle_1.SetFocus ()
   f_memo ('function history', rte_function)
Else // Not Found Object ID
   MessageBox ("오브젝트 확인", "등록된 오브젝트가 아니거나, SQL오류입니다.", StopSign!)
   CLOSE (THIS)
End IF
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_object_help
end type

type ln_tempstart from w_response1st`ln_tempstart within w_object_help
end type

type ln_templeft from w_response1st`ln_templeft within w_object_help
end type

type ln_cond_start from w_response1st`ln_cond_start within w_object_help
end type

type ln_tempright from w_response1st`ln_tempright within w_object_help
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_object_help
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_object_help
end type

type cbx_1 from pf_u_checkbox within w_object_help
integer x = 2761
integer y = 2340
integer width = 361
integer weight = 700
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "출력"
boolean lefttext = true
boolean righttoleft = true
end type

type mle_1 from u_mle within w_object_help
integer x = 50
integer y = 24
integer width = 3520
integer height = 2188
integer taborder = 20
boolean enabled = true
end type

event getfocus;//
end event

type rte_function from pf_u_richtextedit within w_object_help
integer x = 55
integer y = 2224
integer width = 3502
integer height = 88
integer taborder = 60
integer textsize = -9
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
long init_backcolor = 67108864
boolean enabled = false
boolean border = false
end type

type cb_print from pf_u_commandbutton within w_object_help
integer x = 2546
integer y = 2020
integer width = 425
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "저장 후 출력"
end type

event clicked;IF f_null (mle_1.text)   Then
   IF is_WHLP00M='update'  Then
      DELETE  WHLP00M
      WHERE   OBJ_ID = :is_ObjectID;
   End IF
   CloseWithReturn (PARENT, 1)
Else
   IF is_WHLP00M='insert'  Then
      INSERT INTO  WHLP00M
      VALUES ( :is_ObjectID                               /* _1: */
             , :mle_1.text                                /* _2: */
             );
   Else
      UPDATE  WHLP00M
         SET  OBJ_HELP = :mle_1.text
      WHERE   OBJ_ID = :is_ObjectID;
   End IF
   IF SQLCA.SQLCode ()=0 Then
      commitJ ()
      CloseWithReturn (PARENT, 1)
   Else
		rollbackJ ()
      MessageBox ('저장 오류', '입력하신 도움말 저장에 실패하였습니다~r~n' + SQLCA.SQLErrText, StopSign!)
   End IF
End IF
end event

type cb_ok from pf_u_commandbutton within w_object_help
integer x = 3145
integer y = 2332
integer width = 334
integer height = 100
integer taborder = 30
integer weight = 400
string text = "확 인"
end type

event clicked;INT li_rtn

li_rtn = IIF (cbx_1.Checked, 1, 0)

IF f_null (mle_1.text)  Then
   IF is_WHLP00M='update'  Then
      DELETE  WHLP00M
      WHERE   OBJ_ID = :is_ObjectID;
   End IF
   CloseWithReturn (PARENT, li_rtn)
Else
   IF is_WHLP00M='insert'  Then
      INSERT INTO  WHLP00M
      VALUES ( :is_ObjectID                               /* _1: */
             , :mle_1.text                                /* _2: */
             );
   Else
      UPDATE  WHLP00M
         SET  OBJ_HELP = :mle_1.text
      WHERE   OBJ_ID = :is_ObjectID;
   End IF
   IF SQLCA.SQLCode ()=0 Then
      commitJ ();
      CloseWithReturn (PARENT, li_rtn)
   Else
      rollbackJ ();
      MessageBox ('저장 오류', '입력하신 도움말 저장에 실패하였습니다~r~n' + SQLCA.SQLErrText, StopSign!)
   End IF
End IF
end event

