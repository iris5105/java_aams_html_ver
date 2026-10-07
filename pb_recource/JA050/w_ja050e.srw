forward
global type w_ja050e from wt_vertole
end type
end forward

global type w_ja050e from wt_vertole
boolean eb_direct_retrieve = true
integer ii_dddw_width = 500
string is_find = "mg_cd=~'~'"
string is_init_value = "00010"
end type
global w_ja050e w_ja050e

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = f_gijunga_ymd ('+1')
end event

on w_ja050e.create
int iCurrent
call super::create
end on

on w_ja050e.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;is_find = "mg_cd='" + ia_value [1] + "'"
dw_List.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja050e
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja050e
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja050e
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja050e
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja050e
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja050e
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja050e
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja050e
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja050e
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja050e
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja050e
end type

type uo_navi from wt_vertole`uo_navi within w_ja050e
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja050e
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja050e
end type

type p_close from wt_vertole`p_close within w_ja050e
end type

type p_excel from wt_vertole`p_excel within w_ja050e
end type

type p_print from wt_vertole`p_print within w_ja050e
end type

type p_delete from wt_vertole`p_delete within w_ja050e
end type

type p_update from wt_vertole`p_update within w_ja050e
end type

type p_input from wt_vertole`p_input within w_ja050e
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja050e
end type

type p_clear from wt_vertole`p_clear within w_ja050e
end type

type p_copy from wt_vertole`p_copy within w_ja050e
end type

type dw_c from wt_vertole`dw_c within w_ja050e
string title = "영업일자"
string dataobject = "dc_ymd"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt_f_value, ldt_f_param1

ldt_f_param1 =  datetime(date(MidA(data,1,10)))
SELECT F_OPEN_YMD( :ldt_f_param1, '-' )
  INTO :ldt_f_value
FROM   DUAL;

ldt_f_value = SQLCA.getitemdatetime (1)

CHOOSE CASE dwo.name
   CASE 'ymd'
      IF ldt_f_value<>datetime(date(MidA(data,1,10)))   Then
         RETURN uf_itemerror ('ymd', '영업일이 아닙니다.')
      End IF
END CHOOSE
end event

type btn_update from wt_vertole`btn_update within w_ja050e
end type

type st_count from wt_vertole`st_count within w_ja050e
end type

type dw_list from wt_vertole`dw_list within w_ja050e
boolean visible = true
string dataobject = "d_ja050e1"
boolean eb_null_line = false
end type

event dw_list::retrieveend;LONG	ll

ll = insertrow (0)
Object.mg_cd [ll] = '%'
Object.tr_co_nm [ll] = '전체'

rowcount += 1

CALL super::retrieveend
end event

type st_move from wt_vertole`st_move within w_ja050e
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja050e
boolean eb_onepage = true
boolean eb_openpagerd = true
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;IF row=0 THEN RETURN

ia_value [1] = dw_List.object.mg_cd [row]

uf_fileopen ('rd_ja050e.mrd', &
               'ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + '] ' + &
            'mg_cd[' + ia_value [1] + '] ' + &
            'title[' + IIF (dw_List.object.mg_cd [row]='%','',dw_List.object.tr_co_nm [row]) + ' 기준가격 명세표] ' + &
               'dt[( 영업일자 : ' + string (dw_c.object.ymd [1], 'yyyy.mm.dd') + ' )]' )

end event

type rb_onepage from wt_vertole`rb_onepage within w_ja050e
end type

