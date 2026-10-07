forward
global type w_ja033b from wt_list
end type
type cb_load from pf_u_commandbutton within w_ja033b
end type
end forward

global type w_ja033b from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
boolean ib_managedata = false
cb_load cb_load
end type
global w_ja033b w_ja033b

on w_ja033b.create
int iCurrent
call super::create
this.cb_load=create cb_load
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
end on

on w_ja033b.destroy
call super::destroy
destroy(this.cb_load)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ('%')
end event

event open;cb_load.visible = gaa.admin
icmdbutton = { cb_load }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja033b
end type

type ln_templeft from wt_list`ln_templeft within w_ja033b
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja033b
end type

type ln_temptop from wt_list`ln_temptop within w_ja033b
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja033b
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja033b
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja033b
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja033b
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja033b
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja033b
end type

type ln_tempright from wt_list`ln_tempright within w_ja033b
end type

type uo_navi from wt_list`uo_navi within w_ja033b
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja033b
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja033b
end type

type st_top_rect from wt_list`st_top_rect within w_ja033b
end type

type p_close from wt_list`p_close within w_ja033b
end type

type p_excel from wt_list`p_excel within w_ja033b
end type

type p_print from wt_list`p_print within w_ja033b
end type

type p_delete from wt_list`p_delete within w_ja033b
end type

type p_update from wt_list`p_update within w_ja033b
end type

type p_input from wt_list`p_input within w_ja033b
end type

type p_retrieve from wt_list`p_retrieve within w_ja033b
end type

type p_clear from wt_list`p_clear within w_ja033b
end type

type p_copy from wt_list`p_copy within w_ja033b
end type

type dw_c from wt_list`dw_c within w_ja033b
boolean visible = false
boolean enabled = false
string title = ""
end type

type btn_update from wt_list`btn_update within w_ja033b
end type

type st_count from wt_list`st_count within w_ja033b
end type

type dw_list from wt_list`dw_list within w_ja033b
integer y = 156
integer height = 2608
string dataobject = "d_ja033b"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'info_type', '', '', 1, '')
end event

type cb_load from pf_u_commandbutton within w_ja033b
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
IF GetFileOpenName ("지수 선물/옵션 종목파일선택", ls_path, ls_file, "지수 선물/옵션 종목", " 지수 선물/옵션 종목,fo_idx*.mst, 전체,*.*", ls_path, 18) <> 1 THEN RETURN

SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (ls_path, LASTPOS (ls_path, '\')))

st_count.SetPosition (ToTop!)
st_count.VISIBLE = TRUE

lf_num = FileOpen (ls_path, LineMode!, Read!, Shared!)
DO UNTIL FileReadEx (lf_num, ls_rec)= -100
   ll_count ++
   f_st_count (st_count, ls_file + ' : ', ll_count, ll_insert)

   ll_count ++
   f_get_array (ls_rec, '|', la_data)
	SELECT STND_ISCD
	  INTO :la_data[3]
	  FROM FO_IDX_CODE t1
	 WHERE t1.INFO_TYPE = :la_data[1]
		AND t1.STND_ISCD = :la_data[3] ;
	IF SQLCA.sqlcode () <> 0   Then
		ll_insert ++
		INSERT INTO FO_IDX_CODE
		VALUES ( :la_data[1]  /* _1- */
				 , :la_data[2]  /* _2- */
				 , :la_data[3]  /* _3- */
				 , :la_data[4]  /* _4- */
				 , :la_data[5]  /* _5- */
				 , :la_data[6]  /* _6- */
				 , :la_data[7]  /* _7- */
				 , :la_data[8]  /* _8- */
				 , :la_data[9]  /* _9- */
				 ) ;
		commitJ ()
	END IF
   f_st_count (st_count, ls_file + ' : ', ll_count, ll_insert)
LOOP

FileClose (lf_num)

F_MESSAGEBOX ('INFO', '지수 선물/옵션 종목 LOAD를 완료했습니다.')

st_count.SetPosition (ToBottom!)
st_count.VISIBLE = FALSE
end event

