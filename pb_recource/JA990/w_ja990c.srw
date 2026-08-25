forward
global type w_ja990c from wt_listdetail
end type
end forward

global type w_ja990c from wt_listdetail
boolean eb_direct_retrieve = true
end type
global w_ja990c w_ja990c

event wue_retrieve;call super::wue_retrieve;IF gaa.admin OR gaa.aams Then
   dw_List.retrieve ('%', '0')
Else
   dw_List.retrieve ('%', '2')
End IF
end event

on w_ja990c.create
int iCurrent
call super::create
end on

on w_ja990c.destroy
call super::destroy
end on

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja990c
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja990c
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja990c
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja990c
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja990c
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja990c
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja990c
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja990c
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja990c
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja990c
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja990c
end type

type uo_navi from wt_listdetail`uo_navi within w_ja990c
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja990c
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja990c
end type

type p_close from wt_listdetail`p_close within w_ja990c
end type

type p_excel from wt_listdetail`p_excel within w_ja990c
end type

type p_print from wt_listdetail`p_print within w_ja990c
end type

type p_delete from wt_listdetail`p_delete within w_ja990c
end type

type p_update from wt_listdetail`p_update within w_ja990c
end type

type p_input from wt_listdetail`p_input within w_ja990c
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja990c
end type

type p_clear from wt_listdetail`p_clear within w_ja990c
end type

type p_copy from wt_listdetail`p_copy within w_ja990c
end type

type dw_c from wt_listdetail`dw_c within w_ja990c
boolean visible = false
boolean enabled = false
string title = ""
end type

type btn_update from wt_listdetail`btn_update within w_ja990c
end type

type st_count from wt_listdetail`st_count within w_ja990c
end type

type dw_list from wt_listdetail`dw_list within w_ja990c
integer y = 156
integer height = 1284
string dataobject = "d_ja990c1"
boolean eb_copy_false = true
string is_encrypts = "enc_bubin_no"
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	ll

STRING	ls_cd

CHOOSE CASE dwo.name
   CASE 'balh_co'
      SELECT  balh_co
        INTO  :ls_cd
      FROM    sjx0jb t1
      WHERE   t1.balh_co = :data;

      IF SQLCA.sqlcode ()=0	Then
         RETURN uf_itemerr (row, string (dwo.name), '이미 등록된 발행기관 입니다.')
      End IF

      FOR  ll = 1  TO  dw_detail.rowcount ()
         dw_detail.object.balh_co [ll] = data
      NEXT
   CASE 'gyul_mm'
      IF dec(data)>12   Then
         RETURN uf_itemerr (row, string (dwo.name), '결산월(1-12)을 확인하십시오.')
      End IF
END CHOOSE

IF GetItemStatus (row, 0, Primary!)=New! OR GetItemStatus (row, 0, Primary!)=NewModified! THEN RETURN

ll = dw_detail.insertrow (0)
dw_detail.object.balh_co [ll] = Object.balh_co [row]
dw_detail.object.chg_column [ll] = string (dwo.name)
dw_detail.object.ymd [ll] = f_sysdate ('')
dw_detail.object.bf_data [ll] = string (dwo.primary [row])
dw_detail.object.af_data [ll] = data
dw_detail.object.skt0bu [ll] = 'N'
dw_detail.object.upd_user [ll] = gnv_vari.is_user_nm
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'tr_stop_gb', gaa.corp_gr, '', 1, '')
F_DDDWCTL (THIS, 'sosok_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::constructor;call super::constructor;eb_delete_false = NOT (gaa.admin OR gaa.aams)
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_stop_gb', '1')
uf_setColumn ('sosok_gb', 'B')
uf_setColumn ('gyul_mm','12')
uf_setColumn ('balh_nation','KR')

POST SetColumn ('balh_co')

RETURN 0
end event

type dw_detail from wt_listdetail`dw_detail within w_ja990c
string dataobject = "d_ja990c2"
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.balh_co [iRow])
end event

event dw_detail::constructor;call super::constructor;eb_delete_false = NOT (gaa.admin OR gaa.aams)
end event

type st_move from wt_listdetail`st_move within w_ja990c
end type

