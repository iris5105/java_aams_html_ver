forward
global type w_ja032f_krx from wt_vertdetail
end type
end forward

global type w_ja032f_krx from wt_vertdetail
boolean eb_direct_retrieve = true
end type
global w_ja032f_krx w_ja032f_krx

on w_ja032f_krx.create
int iCurrent
call super::create
end on

on w_ja032f_krx.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, idt_workdate)
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032f_krx
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032f_krx
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032f_krx
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032f_krx
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032f_krx
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032f_krx
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032f_krx
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032f_krx
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032f_krx
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032f_krx
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032f_krx
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032f_krx
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032f_krx
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032f_krx
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032f_krx
end type

type p_close from wt_vertdetail`p_close within w_ja032f_krx
end type

type p_excel from wt_vertdetail`p_excel within w_ja032f_krx
end type

type p_print from wt_vertdetail`p_print within w_ja032f_krx
end type

type p_delete from wt_vertdetail`p_delete within w_ja032f_krx
end type

type p_update from wt_vertdetail`p_update within w_ja032f_krx
end type

type p_input from wt_vertdetail`p_input within w_ja032f_krx
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032f_krx
end type

type p_clear from wt_vertdetail`p_clear within w_ja032f_krx
end type

type p_copy from wt_vertdetail`p_copy within w_ja032f_krx
end type

type dw_c from wt_vertdetail`dw_c within w_ja032f_krx
boolean visible = false
boolean enabled = false
string title = ""
end type

type btn_update from wt_vertdetail`btn_update within w_ja032f_krx
end type

type st_count from wt_vertdetail`st_count within w_ja032f_krx
end type

type dw_list from wt_vertdetail`dw_list within w_ja032f_krx
integer y = 156
integer height = 2608
string dataobject = "d_ja032f_krx"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'woos_ilban_gb', gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'chg_gb'       , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'new_old_gb'   , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'danc_gb'      , gaa.CORP_GR, '', 2, '')
f_dddwctl (THIS, 'kospigubun'   , gaa.CORP_GR, '', 1, '')
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

STRING   ls_koscom_cd

IF DWO.NAME='uspm'   Then
   ls_koscom_cd = Object.koscom_cd [row]

   INSERT INTO USPM_DD
       ( CORP_GR       /* _1- */
       , YMD           /* _2- */
       , JM_CD         /* _3- */
       , OVRS_EXCG_CD  /* _4- */
       )
   VALUES ( :gaa.CORP_GR   /* _1- */
          , :idt_workdate  /* _2- */
          , :ls_koscom_cd  /* _3- */
          , 'KRX'          /* _4- */
          ) ;

   CommitJ ( )
END IF
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja032f_krx
integer y = 156
integer width = 2834
integer height = 2608
string dataobject = "d_ja991a2"
boolean ibsetlist4subbtn = false
string is_resize_column = "fund_list"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (dw_list.object.koscom_cd [iRow], idt_workdate)
end event

type st_move from wt_vertdetail`st_move within w_ja032f_krx
integer y = 156
integer height = 2608
end type

