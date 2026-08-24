forward
global type w_ja021d from wt_listole
end type
end forward

global type w_ja021d from wt_listole
end type
global w_ja021d w_ja021d

event wue_lastopen;call super::wue_lastopen;dw_c.object.rpt_gb [1] = '10'
dw_c.object.fr_ymd [1] = idt_workdate
dw_c.object.to_ymd [1] = idt_workdate
dw_c.object.balh_co [1] = '%'
dw_c.object.xx_balh_co [1] = '전발행기관'
end event

on w_ja021d.create
int iCurrent
call super::create
end on

on w_ja021d.destroy
call super::destroy
end on

type lb_dirlist from wt_listole`lb_dirlist within w_ja021d
end type

type ln_templeft from wt_listole`ln_templeft within w_ja021d
end type

type ln_tempbuttom from wt_listole`ln_tempbuttom within w_ja021d
end type

type ln_temptop from wt_listole`ln_temptop within w_ja021d
end type

type ln_tempbutton from wt_listole`ln_tempbutton within w_ja021d
end type

type ln_tempstart from wt_listole`ln_tempstart within w_ja021d
end type

type ln_cond1_yline from wt_listole`ln_cond1_yline within w_ja021d
end type

type ln_dw1_yline from wt_listole`ln_dw1_yline within w_ja021d
end type

type ln_cond2_yline from wt_listole`ln_cond2_yline within w_ja021d
end type

type ln_dw2_yline from wt_listole`ln_dw2_yline within w_ja021d
end type

type ln_tempright from wt_listole`ln_tempright within w_ja021d
end type

type uo_navi from wt_listole`uo_navi within w_ja021d
end type

type ln_temptop_shadow from wt_listole`ln_temptop_shadow within w_ja021d
end type

type st_windelaytime from wt_listole`st_windelaytime within w_ja021d
end type

type st_top_rect from wt_listole`st_top_rect within w_ja021d
end type

type p_close from wt_listole`p_close within w_ja021d
end type

type p_excel from wt_listole`p_excel within w_ja021d
end type

type p_print from wt_listole`p_print within w_ja021d
end type

type p_delete from wt_listole`p_delete within w_ja021d
end type

type p_update from wt_listole`p_update within w_ja021d
end type

type p_input from wt_listole`p_input within w_ja021d
end type

type p_retrieve from wt_listole`p_retrieve within w_ja021d
end type

type p_clear from wt_listole`p_clear within w_ja021d
end type

type p_copy from wt_listole`p_copy within w_ja021d
end type

type dw_c from wt_listole`dw_c within w_ja021d
string dataobject = "d_ja021d"
end type

event dw_c::itemchanged;CHOOSE CASE dwo.name
   CASE 'balh_co'
      IF Data='%' Then
         Object.xx_balh_co [1] = '전체'
      Else
         RETURN super::EVENT itemchanged (row, dwo, data)
      End IF
END CHOOSE
end event

type btn_update from wt_listole`btn_update within w_ja021d
end type

type st_count from wt_listole`st_count within w_ja021d
end type

type dw_list from wt_listole`dw_list within w_ja021d
end type

type st_move from wt_listole`st_move within w_ja021d
boolean visible = false
boolean enabled = false
end type

type ole_rd from wt_listole`ole_rd within w_ja021d
integer y = 348
integer height = 2416
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;STRING	ls_gb, ls_tr_cd, ls_title

ls_title = MID (dw_c.describe ("evaluate('LookupDisplay(rpt_gb)',1)"),3) + " 명세표"

CHOOSE CASE dw_c.object.rpt_gb [1]
   CASE '10'
      ls_gb = '1' ; ls_tr_cd = 'G10'
   CASE '20'
      ls_gb = '2' ; ls_tr_cd = 'G10'
   CASE '30'
      ls_gb = '3' ; ls_tr_cd = 'G20'
   CASE '40'
      ls_gb = '4' ; ls_tr_cd = 'G20'
   CASE '50'
      ls_gb = '3' ; ls_tr_cd = 'G15'
   CASE '60'
      ls_gb = '4' ; ls_tr_cd = 'G15'
   CASE '61'
      ls_gb = '3' ; ls_tr_cd = 'G23'
   CASE '62'
      ls_gb = '4' ; ls_tr_cd = 'G23'
   CASE '70'
      ls_gb = '3' ; ls_tr_cd = 'G25'
   CASE '80'
      ls_gb = '4' ; ls_tr_cd = 'G25'
END CHOOSE

uf_fileopen ('rd_ja021d.mrd', &
         'gb[' + ls_gb + '] ' + &
         'tr_cd[' + ls_tr_cd + '] ' + &
         'title[' + ls_title + '] ' + &
         'fr_ymd[' + string (dw_c.object.fr_ymd [1],'yyyy.mm.dd') + '] ' + &
         'to_ymd[' + string (dw_c.object.to_ymd [1],'yyyy.mm.dd') + '] ' + &
         'balh_co[' + dw_c.object.balh_co [1] + ']' )

end event

type rb_onepage from wt_listole`rb_onepage within w_ja021d
end type

