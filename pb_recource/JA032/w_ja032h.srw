forward
global type w_ja032h from wt_list
end type
type cb_load from pf_u_commandbutton within w_ja032h
end type
end forward

global type w_ja032h from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_date_nation = "US"
cb_load cb_load
end type
global w_ja032h w_ja032h

on w_ja032h.create
int iCurrent
call super::create
this.cb_load=create cb_load
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
end on

on w_ja032h.destroy
call super::destroy
destroy(this.cb_load)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve ()
end event

event open;cb_load.visible = gaa.admin
icmdbutton = { cb_load }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja032h
end type

type ln_templeft from wt_list`ln_templeft within w_ja032h
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja032h
end type

type ln_temptop from wt_list`ln_temptop within w_ja032h
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja032h
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja032h
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja032h
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja032h
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja032h
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja032h
end type

type ln_tempright from wt_list`ln_tempright within w_ja032h
end type

type uo_navi from wt_list`uo_navi within w_ja032h
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja032h
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja032h
end type

type st_top_rect from wt_list`st_top_rect within w_ja032h
end type

type p_close from wt_list`p_close within w_ja032h
end type

type p_excel from wt_list`p_excel within w_ja032h
end type

type p_print from wt_list`p_print within w_ja032h
end type

type p_delete from wt_list`p_delete within w_ja032h
end type

type p_update from wt_list`p_update within w_ja032h
end type

type p_input from wt_list`p_input within w_ja032h
end type

type p_retrieve from wt_list`p_retrieve within w_ja032h
end type

type p_clear from wt_list`p_clear within w_ja032h
end type

type p_copy from wt_list`p_copy within w_ja032h
end type

type dw_c from wt_list`dw_c within w_ja032h
boolean visible = false
boolean enabled = false
string title = ""
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, '0,전종목,,1,기준등록종목,', 1, '')
end event

type btn_update from wt_list`btn_update within w_ja032h
end type

type st_count from wt_list`st_count within w_ja032h
end type

type dw_list from wt_list`dw_list within w_ja032h
integer y = 156
integer height = 2608
string dataobject = "d_ja032h"
end type

type cb_load from pf_u_commandbutton within w_ja032h
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
IF GetFileOpenName ("해외업종/지수/환율 코드파일선택", ls_path, ls_file, "업종/지수/환율 파일", " 업종/지수/환율자료,*.mst, 전체,*.*", ls_path, 18) <> 1 THEN RETURN

SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (ls_path, LASTPOS (ls_path, '\')))

st_count.SetPosition (ToTop!)
st_count.VISIBLE = TRUE

lf_num = FileOpen (ls_path, LineMode!, Read!, Shared!)
DO UNTIL FileReadEx (lf_num, ls_rec)= -100
   ll_count ++
   f_st_count (st_count, ls_file + ' : ', ll_count, ll_insert)

   la_data [1] = MidA (ls_rec, 1, 1)
   la_data [2] = TRIM (MidA (ls_rec, 2, 10))
   IF la_data [1]='H' THEN CONTINUE

   SELECT FRID
     INTO :la_data[1]
     FROM API_FRGNCODE t1
    WHERE t1.FRID = :la_data[1]
      AND t1.FRGN = :la_data[2] ;
   IF SQLCA.sqlcode () <> 0   Then
      ll_insert ++

      la_data [3] = MidA (ls_rec, 12, 39)
      la_data [4] = MidA (ls_rec, 51, 40)
      la_data [5] = MidA (ls_rec, 91, 4)
      la_data [6] = MidA (ls_rec, 95, 3)
      la_data [7] = MidA (ls_rec, 98, 4)
      la_data [8] = MidA (ls_rec, 102, 3)

      INSERT INTO API_FRGNCODE
      VALUES ( :la_data[1]        /* _1- */
             , :la_data[2]        /* _2- */
             , TRIM(:la_data[3])  /* _3- */
             , TRIM(:la_data[4])  /* _4- */
             , TRIM(:la_data[5])  /* _5- */
             , TRIM(:la_data[6])  /* _6- */
             , TRIM(:la_data[7])  /* _7- */
             , TRIM(:la_data[8])  /* _8- */
             ) ;
      commitJ ()
   END IF
LOOP

FileClose (lf_num)

F_MESSAGEBOX ('INFO', '해외업종정보 LOAD를 완료했습니다.')

st_count.SetPosition (ToBottom!)
st_count.VISIBLE = FALSE
end event

