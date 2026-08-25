forward
global type w_ja033c from wt_list
end type
type cb_load from pf_u_commandbutton within w_ja033c
end type
end forward

global type w_ja033c from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
integer ii_dddw_position = 1
string is_init_value = "1"
boolean ib_managedata = false
cb_load cb_load
end type
global w_ja033c w_ja033c

on w_ja033c.create
int iCurrent
call super::create
this.cb_load=create cb_load
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
end on

on w_ja033c.destroy
call super::destroy
destroy(this.cb_load)
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (ia_value [1], '%')
end event

event open;cb_load.visible = gaa.admin
icmdbutton = { cb_load }
call super::open
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = ia_value [1]
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja033c
end type

type ln_templeft from wt_list`ln_templeft within w_ja033c
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja033c
end type

type ln_temptop from wt_list`ln_temptop within w_ja033c
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja033c
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja033c
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja033c
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja033c
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja033c
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja033c
end type

type ln_tempright from wt_list`ln_tempright within w_ja033c
end type

type uo_navi from wt_list`uo_navi within w_ja033c
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja033c
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja033c
end type

type st_top_rect from wt_list`st_top_rect within w_ja033c
end type

type p_close from wt_list`p_close within w_ja033c
end type

type p_excel from wt_list`p_excel within w_ja033c
end type

type p_print from wt_list`p_print within w_ja033c
end type

type p_delete from wt_list`p_delete within w_ja033c
end type

type p_update from wt_list`p_update within w_ja033c
end type

type p_input from wt_list`p_input within w_ja033c
end type

type p_retrieve from wt_list`p_retrieve within w_ja033c
end type

type p_clear from wt_list`p_clear within w_ja033c
end type

type p_copy from wt_list`p_copy within w_ja033c
end type

type dw_c from wt_list`dw_c within w_ja033c
string title = "상품구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, '1,금리,,2,통화,,3,상품,', 1, '')
end event

type btn_update from wt_list`btn_update within w_ja033c
end type

type st_count from wt_list`st_count within w_ja033c
end type

type dw_list from wt_list`dw_list within w_ja033c
string dataobject = "d_ja033c"
end type

type cb_load from pf_u_commandbutton within w_ja033c
integer x = 2272
integer y = 16
integer width = 389
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "종목LOAD"
end type

event clicked;call super::clicked;LONG	ll, lf_num, ll_count = 0, ll_insert = 0

STRING	ls_path, ls_file, la_data [], ls_rec

ls_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
IF GetFileOpenName ("상품 선물/옵션 종목파일선택", ls_path, ls_file, "상품 선물/옵션 종목", " 상품 선물/옵션 종목,fo_com*.mst, 전체,*.*", ls_path, 18) <> 1 THEN RETURN

SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (ls_path, LASTPOS (ls_path, '\')))

st_count.SetPosition (ToTop!)
st_count.VISIBLE = TRUE

lf_num = FileOpen (ls_path, LineMode!, Read!, Shared!)
DO UNTIL FileReadEx (lf_num, ls_rec)= -100
   ll_count ++
   f_st_count (st_count, ls_file + ' : ', ll_count, ll_insert)

   ll_count ++
   la_data [1] = MidA (ls_rec, 1, 1)
   la_data [2] = MidA (ls_rec, 2, 1)
   la_data [3] = TRIM (MidA (ls_rec, 3, 9))
   la_data [4] = TRIM (MidA (ls_rec, 12, 12))

   SELECT STND_ISCD
     INTO :la_data[4]
     FROM FO_COM_CODE t1
    WHERE t1.COM_TYPE  = :la_data[1]
      AND t1.INFO_TYPE = :la_data[2]
      AND t1.STND_ISCD = :la_data[4] ;
   IF SQLCA.sqlcode () <> 0   Then
      ll_insert ++

      la_data [5]  = TRIM (MidA (ls_rec, 24, 40))
      la_data [6]  = TRIM (MidA (ls_rec, 64, 1))
      la_data [7]  = TRIM (MidA (ls_rec, 65, 8))
      la_data [8]  = TRIM (MidA (ls_rec, 73, 1))
      la_data [9]  = TRIM (MidA (ls_rec, 74, 3))
      la_data [10] = TRIM (MidA (ls_rec, 77, 40))
      INSERT INTO FO_COM_CODE
      VALUES ( :la_data[1]   /* _1- */
             , :la_data[2]   /* _2- */
             , :la_data[3]   /* _3- */
             , :la_data[4]   /* _4- */
             , :la_data[5]   /* _5- */
             , :la_data[6]   /* _6- */
             , :la_data[7]   /* _7- */
             , :la_data[8]   /* _8- */
             , :la_data[9]   /* _9- */
             , :la_data[10]  /* _10- */
             ) ;
      commitJ ()
   END IF
   f_st_count (st_count, ls_file + ' : ', ll_count, ll_insert)
LOOP

FileClose (lf_num)

F_MESSAGEBOX ('INFO', '상품 선물/옵션 종목 LOAD를 완료했습니다.')

st_count.SetPosition (ToBottom!)
st_count.VISIBLE = FALSE
end event

