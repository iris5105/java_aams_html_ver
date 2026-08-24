forward
global type w_ja032f from wt_vertdetail
end type
type cb_load from pf_u_commandbutton within w_ja032f
end type
end forward

global type w_ja032f from wt_vertdetail
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "jm_cd=~'~'"
cb_load cb_load
end type
global w_ja032f w_ja032f

on w_ja032f.create
int iCurrent
call super::create
this.cb_load=create cb_load
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_load
end on

on w_ja032f.destroy
call super::destroy
destroy(this.cb_load)
end on

event wue_retrieve;call super::wue_retrieve;IF	f_notnull (gaa.jm_cd) THEN is_find = "jm_cd=' + gaa.jm_cd + '"
dw_list.retrieve (gaa.corp_gr)
end event

event open;cb_load.visible = gaa.admin
icmdbutton = { cb_load }
call super::open
end event

event ue_activate;call super::ue_activate;IF	dw_list.enabled And f_notnull (gaa.jm_cd) THEN dw_list.uf_find ("jm_cd=' + gaa.jm_cd + '")
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja032f
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja032f
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja032f
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja032f
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja032f
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja032f
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja032f
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja032f
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja032f
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja032f
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja032f
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja032f
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja032f
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja032f
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja032f
end type

type p_close from wt_vertdetail`p_close within w_ja032f
end type

type p_excel from wt_vertdetail`p_excel within w_ja032f
end type

type p_print from wt_vertdetail`p_print within w_ja032f
end type

type p_delete from wt_vertdetail`p_delete within w_ja032f
end type

type p_update from wt_vertdetail`p_update within w_ja032f
end type

type p_input from wt_vertdetail`p_input within w_ja032f
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja032f
end type

type p_clear from wt_vertdetail`p_clear within w_ja032f
end type

type p_copy from wt_vertdetail`p_copy within w_ja032f
end type

type dw_c from wt_vertdetail`dw_c within w_ja032f
boolean visible = false
boolean enabled = false
string title = ""
end type

type btn_update from wt_vertdetail`btn_update within w_ja032f
end type

type st_count from wt_vertdetail`st_count within w_ja032f
end type

type dw_list from wt_vertdetail`dw_list within w_ja032f
integer y = 156
integer height = 2608
string dataobject = "d_ja032f1"
boolean hscrollbar = true
end type

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

STRING   ls_symb, ls_key1
STRING   la_args [], w_msg = SPACE (200)

CHOOSE CASE DWO.NAME
	CASE 'opt_1unit'
		Object.opt_2unit [row] = dec(data)
		Object.opt_4unit [row] = dec(data)
		Object.opt_5unit [row] = dec(data)
	CASE 'used'
		ls_symb                     = Object.symb [row]
		Object.CORP_GR [row]        = gaa.CORP_GR
		Object.jm_nm [row]          = Object.enam [row]
		Object.srs_cd [row]         = ls_symb
		Object.jasan_gb [row]       = '1'
		Object.sj_gb [row]          = '1'
		Object.seq_no [row]         = 1
		Object.balh_nation [row]    = Object.ncod [row]
		Object.blbg_tckr [row]      = ls_symb
		Object.blbg_tckr_text [row] = ls_symb + ' ' + Object.ncod [row]
		Object.sym0ya_excd [row]    = Object.excd [row]
		IF Object.excd [row]='AMS' Then
			Object.stock_gb [row] = 'ARCX'
		ELSE
			Object.stock_gb [row] = 'X' + Object.excd [row]
		END IF
		ls_key1               = Object.stock_gb [row] + ':' + ls_symb
		Object.jm_cd [row]    = ls_key1
		Object.uspm_ymd [row] = f_sysdate ('')
		SetItemStatus (ROW, 0, PRIMARY!, NEWMODIFIED!)
	
		UPDATE ()
		gw_mdi.setmicrohelp (STRING (Now ( )) + ' -> ' + ls_symb + ' commit')
		f_dw_resetstatus (THIS, row, {''})
		CommitJ ( )
	
		INSERT INTO API_Q
			 ( COMPANY        /* _1- */
			 , URL            /* _2- */
			 , HEADERS        /* _3- */
			 , QUERYPARAMS    /* _4- */
			 , TABLENAME      /* _5- */
			 , SUBTABLE       /* _6- */
			 , REQUEST        /* _7- */
			 , API_KEY        /* _8- */
			 , KEY_VALUE      /* _9- */
			 , SUB_KEY_VALUE  /* _10- */
			 , CORP_GR        /* _11- */
			 , TR_YMD         /* _12- */
			 , KEY1           /* _13- */
			 )
		  SELECT COMPANY                                                          /* _1- */
				 , URL                                                              /* _2- */
				 , HEADERS                                                          /* _3- */
				 , REPLACE (REPLACE (QUERYPARAMS,'@prdt','512'),'@pdno', :ls_symb)  /* _4- */
				 , TABLENAME                                                        /* _5- */
				 , SUBTABLE                                                         /* _6- */
				 , '0'                                                              /* _7- */
				 , TO_CHAR(sysdate,'yyyymmdd') || '-' || RAWTOHEX(SYS_GUID( ))      /* _8- */
				 , KEY_VALUE                                                        /* _9- */
				 , SUB_KEY_VALUE                                                    /* _10- */
				 , :gaa.CORP_GR                                                     /* _11- */
				 , sysdate                                                          /* _12- */
				 , :ls_key1                                                         /* _13- */
			 FROM API_PARAMS t1
			WHERE t1.TR_CO_CD = '00003'
			  AND t1.GR_CD    = '13'
			  AND t1.SCD      = '09'
			  AND t1.COMPANY  = 'KB_REAL' ;
	
			INSERT INTO API_Q
				 ( COMPANY        /* _1- */
				 , URL            /* _2- */
				 , HEADERS        /* _3- */
				 , QUERYPARAMS    /* _4- */
				 , TABLENAME      /* _5- */
				 , SUBTABLE       /* _6- */
				 , REQUEST        /* _7- */
				 , API_KEY        /* _8- */
				 , KEY_VALUE      /* _9- */
				 , SUB_KEY_VALUE  /* _10- */
				 , CORP_GR        /* _11- */
				 , TR_YMD         /* _12- */
				 , KEY1           /* _13- */
				 )
			  SELECT COMPANY                                                          /* _1- */
					 , URL                                                              /* _2- */
					 , HEADERS                                                          /* _3- */
					 , REPLACE (REPLACE (QUERYPARAMS,'@prdt','513'),'@pdno', :ls_symb)  /* _4- */
					 , TABLENAME                                                        /* _5- */
					 , SUBTABLE                                                         /* _6- */
					 , '0'                                                              /* _7- */
					 , TO_CHAR(sysdate,'yyyymmdd') || '-' || RAWTOHEX(SYS_GUID( ))      /* _8- */
					 , KEY_VALUE                                                        /* _9- */
					 , SUB_KEY_VALUE                                                    /* _10- */
					 , :gaa.CORP_GR                                                     /* _11- */
					 , sysdate                                                          /* _12- */
					 , :ls_key1                                                         /* _13- */
				 FROM API_PARAMS t1
				WHERE t1.TR_CO_CD = '00003'
				  AND t1.GR_CD    = '13'
				  AND t1.SCD      = '09'
				  AND t1.COMPANY  = 'KB_REAL' ;
	
			INSERT INTO API_Q
				 ( COMPANY        /* _1- */
				 , URL            /* _2- */
				 , HEADERS        /* _3- */
				 , QUERYPARAMS    /* _4- */
				 , TABLENAME      /* _5- */
				 , SUBTABLE       /* _6- */
				 , REQUEST        /* _7- */
				 , API_KEY        /* _8- */
				 , KEY_VALUE      /* _9- */
				 , SUB_KEY_VALUE  /* _10- */
				 , CORP_GR        /* _11- */
				 , TR_YMD         /* _12- */
				 , KEY1           /* _13- */
				 )
			  SELECT COMPANY                                                          /* _1- */
					 , URL                                                              /* _2- */
					 , HEADERS                                                          /* _3- */
					 , REPLACE (REPLACE (QUERYPARAMS,'@prdt','529'),'@pdno', :ls_symb)  /* _4- */
					 , TABLENAME                                                        /* _5- */
					 , SUBTABLE                                                         /* _6- */
					 , '0'                                                              /* _7- */
					 , TO_CHAR(sysdate,'yyyymmdd') || '-' || RAWTOHEX(SYS_GUID( ))      /* _8- */
					 , KEY_VALUE                                                        /* _9- */
					 , SUB_KEY_VALUE                                                    /* _10- */
					 , :gaa.CORP_GR                                                     /* _11- */
					 , sysdate                                                          /* _12- */
					 , :ls_key1                                                         /* _13- */
				 FROM API_PARAMS t1
				WHERE t1.TR_CO_CD = '00003'
				  AND t1.GR_CD    = '13'
				  AND t1.SCD      = '09'
				  AND t1.COMPANY  = 'KB_REAL' ;
	
				INSERT INTO USPM_DD
					 ( CORP_GR  /* _1- */
					 , YMD      /* _2- */
					 , JM_CD    /* _3- */
					 )
				VALUES ( :gaa.CORP_GR   /* _1- */
						 , :idt_workdate  /* _2- */
						 , :ls_key1       /* _3- */
						 ) ;
	
		CommitJ ( )
	
		la_args [1] = gaa.CORP_GR
		la_args [2] = f_sysdate_str ('yyyymmdd')
		la_args [3] = 'ref'
		SQLCA.singleconnection ( )
		SQLCA.SP_CALL (THIS,'API_13_02_200 ( ?, ?, ? )', la_args[], w_msg)
	
		w_msg = f_nvl (SQLCA.GETITEMPLSQL (1),'N')
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;IF	string (Object.used [row])='2'	Then
   f_setprotect (THIS, TRUE, {'used','jm_cd','stock_gb'})
   f_setprotect (THIS, FALSE, {'opt_unit','opt_1unit'})
Else
   f_setprotect (THIS, FALSE, {'used'})
END IF
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'sj_gb | sj_gubun', '', '', 1, '')
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja032f
integer y = 156
integer height = 2608
string dataobject = "d_ja032f2"
boolean ibsetlist4subbtn = false
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, idt_workdate, dw_list.object.jm_cd [iRow])
end event

type st_move from wt_vertdetail`st_move within w_ja032f
integer y = 156
integer height = 2608
end type

type cb_load from pf_u_commandbutton within w_ja032f
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
IF GetFileOpenName ("해외종목 파일선택", ls_path, la_file, "종목파일", " 종목자료,*.cod, 전체,*.*", ls_path, 18) <> 1 THEN RETURN

ll_file = UPPERBOUND (la_file)
IF ll_file=1   Then
   SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', LEFT (ls_path, LASTPOS (ls_path, '\')))
ELSE
   SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', ls_path)
END IF
st_count.SetPosition (ToTop!)
st_count.visible = TRUE
FOR  ll = 1  TO  ll_file
   IF ll_file=1   Then
      lf_num = FileOpen (ls_path, LineMode!, Read!, Shared!)
   ELSE
      lf_num = FileOpen (ls_path + '\' + la_file [ll], LineMode!, Read!, Shared!)
   END IF
	ll_count = 0
	ll_insert = 0
   DO UNTIL FileReadEx (lf_num, ls_rec) = -100
      f_MicroHelp (ls_rec)

		ll_count ++
      f_get_array (ls_rec, '~t', la_data)

      SELECT RSYM
        INTO :la_data[6]
        FROM API_GLOBAL_MASTCODE t1
       WHERE t1.RSYM = :la_data[6] ;
      IF SQLCA.sqlcode () <> 0   Then
			ll_insert ++

			la_data[16] = RIGHT ('0' + la_data[16], 4)
			IF	f_notnull (la_data[23]) THEN la_data[23] = RIGHT ('000' + la_data[23], 3)

         INSERT INTO API_GLOBAL_MASTCODE
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
                ) ;
			commitJ ()
      END IF
		f_st_count (st_count, la_file [ll] + ' : ', ll_count, ll_insert)
   LOOP
   FileClose (lf_num)
NEXT

F_MESSAGEBOX ('INFO', '해외 종목정보 LOAD를 완료했습니다.')

st_count.SetPosition (ToBottom!)
st_count.visible = FALSE
end event

