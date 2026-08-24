forward
global type w_fostkcode from wt_list
end type
type cb_load from pf_u_commandbutton within w_fostkcode
end type
end forward

global type w_fostkcode from wt_list
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_date_nation = "US"
boolean ib_managedata = false
cb_load cb_load
end type
global w_fostkcode w_fostkcode

on w_fostkcode.create
int iCurrent
call super::create
this.cb_load=create cb_load
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
end on

on w_fostkcode.destroy
call super::destroy
destroy(this.cb_load)
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr, dw_c.object.ym [1])
end event

event open;cb_load.visible = gaa.admin
icmdbutton = { cb_load }
call super::open
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ym [1]  = string (idt_workdate, 'yyyymm')
end event

type lb_dirlist from wt_list`lb_dirlist within w_fostkcode
end type

type ln_templeft from wt_list`ln_templeft within w_fostkcode
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_fostkcode
end type

type ln_temptop from wt_list`ln_temptop within w_fostkcode
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_fostkcode
end type

type ln_tempstart from wt_list`ln_tempstart within w_fostkcode
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_fostkcode
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_fostkcode
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_fostkcode
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_fostkcode
end type

type ln_tempright from wt_list`ln_tempright within w_fostkcode
end type

type uo_navi from wt_list`uo_navi within w_fostkcode
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_fostkcode
end type

type st_windelaytime from wt_list`st_windelaytime within w_fostkcode
end type

type st_top_rect from wt_list`st_top_rect within w_fostkcode
end type

type p_close from wt_list`p_close within w_fostkcode
end type

type p_excel from wt_list`p_excel within w_fostkcode
end type

type p_print from wt_list`p_print within w_fostkcode
end type

type p_delete from wt_list`p_delete within w_fostkcode
end type

type p_update from wt_list`p_update within w_fostkcode
end type

type p_input from wt_list`p_input within w_fostkcode
end type

type p_retrieve from wt_list`p_retrieve within w_fostkcode
end type

type p_clear from wt_list`p_clear within w_fostkcode
end type

type p_copy from wt_list`p_copy within w_fostkcode
end type

type dw_c from wt_list`dw_c within w_fostkcode
string title = "만기월"
string dataobject = "dc_dddw_ym"
string icon = "DosEdit5!"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', gaa.corp_gr, 'C,CALL,,P,PUT,', 1, '')
end event

type btn_update from wt_list`btn_update within w_fostkcode
end type

type st_count from wt_list`st_count within w_fostkcode
end type

type dw_list from wt_list`dw_list within w_fostkcode
string dataobject = "d_fostkcode"
end type

type cb_load from pf_u_commandbutton within w_fostkcode
integer x = 2272
integer y = 16
integer width = 389
integer taborder = 50
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "종목LOAD"
end type

event clicked;call super::clicked;LONG	ll, ll_file, lf_num, ll_count, ll_insert

STRING	ls_path, la_file [], la_data [], ls_rec

ls_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gaa.excel)
IF GetFileOpenName ("해외파생 파일선택", ls_path, la_file, "파생종목파일", " 파생자료,*.mst, 전체,*.*", ls_path, 18) <> 1 THEN RETURN

ll_file = UPPERBOUND (la_file)
IF ll_file=1   Then
   SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (ls_path, LASTPOS (ls_path, '\')))
ELSE
   SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', ls_path)
END IF
st_count.SetPosition (ToTop!)
st_count.VISIBLE = TRUE
FOR  ll = 1  TO  ll_file
   IF ll_file=1   Then
      lf_num = FileOpen (ls_path, LineMode!, Read!, Shared!)
   ELSE
      lf_num = FileOpen (ls_path + '\' + la_file [ll], LineMode!, Read!, Shared!)
   END IF
   ll_count  = 0
   ll_insert = 0
   DO UNTIL FileReadEx (lf_num, ls_rec) = -100
      f_MicroHelp (ls_rec)

      ll_count ++
      f_st_count (st_count, la_file [ll] + ' : ', ll_insert, ll_count)

		IF	ll_count<79000 THEN CONTINUE
      la_data [1] = TRIM (MID (ls_rec, 1, 32))

      SELECT SRSCD
        INTO :la_data[1]
        FROM API_FOSTKCODE t1
       WHERE t1.SRSCD = :la_data[1] ;
      IF SQLCA.sqlcode () <> 0   Then
			la_data [02] = TRIM (MID (ls_rec, 33, 1))
			la_data [03] = TRIM (MID (ls_rec, 34, 1))
			la_data [04] = TRIM (MID (ls_rec, 35, 1))
			la_data [05] = TRIM (MID (ls_rec, 36, 2))
			la_data [06] = TRIM (MID (ls_rec, 38, 45))
			la_data [07] = TRIM (MID (ls_rec, 83, 50))
			la_data [08] = TRIM (MID (ls_rec, 133, 10))
			la_data [09] = TRIM (MID (ls_rec, 143, 10))
			la_data [10] = TRIM (MID (ls_rec, 153, 3))
			la_data [11] = TRIM (MID (ls_rec, 156, 5))
			la_data [12] = TRIM (MID (ls_rec, 161, 5))
			la_data [13] = TRIM (MID (ls_rec, 166, 14))
			la_data [14] = TRIM (MID (ls_rec, 180, 14))
			la_data [15] = TRIM (MID (ls_rec, 194, 10))
			la_data [16] = TRIM (MID (ls_rec, 204, 4))
			la_data [17] = TRIM (MID (ls_rec, 208, 10))
			la_data [18] = TRIM (MID (ls_rec, 218, 1))
			la_data [19] = TRIM (MID (ls_rec, 219, 20))
			la_data [20] = TRIM (MID (ls_rec, 239, 10))
			la_data [21] = TRIM (MID (ls_rec, 249, 32))
			la_data [22] = TRIM (MID (ls_rec, 281, 32))
			la_data [23] = TRIM (MID (ls_rec, 313, 19))
			la_data [24] = TRIM (MID (ls_rec, 332, 5))
			la_data [25] = TRIM (MID (ls_rec, 337, 6))
			la_data [26] = TRIM (MID (ls_rec, 343, 1))
			la_data [27] = TRIM (MID (ls_rec, 344, 1))
			
         ll_insert ++
         INSERT INTO API_FOSTKCODE
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
                , :la_data[11]  /* _11- */
                , :la_data[12]  /* _12- */
                , :la_data[13]  /* _13- */
                , :la_data[14]  /* _14- */
                , :la_data[15]  /* _15- */
                , :la_data[16]  /* _16- */
                , :la_data[17]  /* _17- */
                , :la_data[18]  /* _18- */
                , :la_data[19]  /* _19- */
                , :la_data[20]  /* _20- */
                , :la_data[21]  /* _21- */
                , :la_data[22]  /* _22- */
                , :la_data[23]  /* _23- */
                , :la_data[24]  /* _24- */
                , :la_data[25]  /* _25- */
                , :la_data[26]  /* _26- */
                , :la_data[27]  /* _27- */
                , now()         /* _28- */
                ) ;
         commitJ ()
      END IF
   LOOP
   FileClose (lf_num)
NEXT

F_MESSAGEBOX ('INFO', '해외 종목정보 LOAD를 완료했습니다.')

st_count.SetPosition (ToBottom!)
st_count.VISIBLE = FALSE
end event

