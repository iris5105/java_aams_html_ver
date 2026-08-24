forward
global type w_ja051c from wt_vertdetail
end type
type cbx_1 from pf_u_checkbox within w_ja051c
end type
type dw_1 from u_dw within w_ja051c
end type
type cb_1 from pf_u_commandbutton within w_ja051c
end type
type cb_send from pf_u_commandbutton within w_ja051c
end type
end forward

global type w_ja051c from wt_vertdetail
boolean eb_direct_retrieve = true
string is_find = "corp_gr=~'~'"
string is_init_value = "H2O%"
boolean ib_managedata = false
cbx_1 cbx_1
dw_1 dw_1
cb_1 cb_1
cb_send cb_send
end type
global w_ja051c w_ja051c

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = 'H2O%'
f_visible (dw_c, false, 'dddw_t')
end event

on w_ja051c.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_send=create cb_send
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_send
end on

on w_ja051c.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_send)
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
is_find = "corp_gr='" + gaa.corp_gr + "'"
dw_list.retrieve (dw_c.object.ymd [1])
end event

type lb_dirlist from wt_vertdetail`lb_dirlist within w_ja051c
end type

type ln_templeft from wt_vertdetail`ln_templeft within w_ja051c
end type

type ln_tempbuttom from wt_vertdetail`ln_tempbuttom within w_ja051c
end type

type ln_temptop from wt_vertdetail`ln_temptop within w_ja051c
end type

type ln_tempbutton from wt_vertdetail`ln_tempbutton within w_ja051c
end type

type ln_tempstart from wt_vertdetail`ln_tempstart within w_ja051c
end type

type ln_cond1_yline from wt_vertdetail`ln_cond1_yline within w_ja051c
end type

type ln_dw1_yline from wt_vertdetail`ln_dw1_yline within w_ja051c
end type

type ln_cond2_yline from wt_vertdetail`ln_cond2_yline within w_ja051c
end type

type ln_dw2_yline from wt_vertdetail`ln_dw2_yline within w_ja051c
end type

type ln_tempright from wt_vertdetail`ln_tempright within w_ja051c
end type

type uo_navi from wt_vertdetail`uo_navi within w_ja051c
end type

type ln_temptop_shadow from wt_vertdetail`ln_temptop_shadow within w_ja051c
end type

type st_windelaytime from wt_vertdetail`st_windelaytime within w_ja051c
end type

type st_top_rect from wt_vertdetail`st_top_rect within w_ja051c
end type

type p_close from wt_vertdetail`p_close within w_ja051c
end type

type p_excel from wt_vertdetail`p_excel within w_ja051c
end type

type p_print from wt_vertdetail`p_print within w_ja051c
end type

type p_delete from wt_vertdetail`p_delete within w_ja051c
end type

type p_update from wt_vertdetail`p_update within w_ja051c
end type

type p_input from wt_vertdetail`p_input within w_ja051c
end type

type p_retrieve from wt_vertdetail`p_retrieve within w_ja051c
end type

type p_clear from wt_vertdetail`p_clear within w_ja051c
end type

type p_copy from wt_vertdetail`p_copy within w_ja051c
end type

type dw_c from wt_vertdetail`dw_c within w_ja051c
string tag = "주문을 위해 핀케치에 발송할 자료 생성 및 발송"
string title = "발송(기준가계산)일@작업그룹"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_valid;return true
end event

type btn_update from wt_vertdetail`btn_update within w_ja051c
end type

type st_count from wt_vertdetail`st_count within w_ja051c
end type

type dw_list from wt_vertdetail`dw_list within w_ja051c
string dataobject = "d_ja051c1"
end type

event dw_list::clicked;call super::clicked;str_parameter  sp

CHOOSE CASE dwo.name
   CASE 'chk_t'
      STRING	ls_chk = '0'
      LONG	ll
      FOR  ll = 1  TO  rowcount ()
         IF Object.chk [ll]='1'  Then
            ls_chk = '1'
            EXIT
         End IF
      NEXT
      FOR  ll = 1  TO  rowcount ()
         Object.chk [ll] = IIF (ls_chk='1','0','1')
			f_dw_resetstatus (this, ll, {'chk'})
      NEXT
	CASE 'corp_data'
		sp.dt[1]  = dw_c.object.ymd [1]
		sp.str[1] = Object.corp_gr [row]
		sp.str[2] = 'table_conv_aams'
		sp.str[3] = '   핀케치 주문자료 SFTP 전송 LOG'
		OpenWithParm (w_ftp_qlog, sp)
END CHOOSE
end event

event dw_list::ue_protect;call super::ue_protect;uf_protect (row, ia_protect [1])
end event

type dw_detail from wt_vertdetail`dw_detail within w_ja051c
integer x = 2606
string dataobject = "d_ja051c2"
boolean ibsetlist4subbtn = false
string is_resize_column = "bigo"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve ('H2O%')
end event

event dw_detail::clicked;call super::clicked;LONG	ll
str_parameter lstr_parm
CHOOSE CASE dwo.name
	CASE 'chk_t'
		IF	FIND ("chk='1'", 1, rowcount ())=0	Then
			FOR ll = 1 TO rowcount ()
				Object.chk [ll] = '1'
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		Else
			FOR ll = 1 TO rowcount ()
				Object.chk [ll] = '0'
				f_dw_resetstatus (this, ll, {'chk'})
			NEXT
		End IF
END CHOOSE
end event

event dw_detail::ue_protect;call super::ue_protect;uf_protect (row, ia_protect [1])
end event

type st_move from wt_vertdetail`st_move within w_ja051c
end type

type cbx_1 from pf_u_checkbox within w_ja051c
boolean visible = false
integer x = 1394
integer y = 196
integer width = 270
boolean bringtotop = true
fontcharset fontcharset = hangeul!
long textcolor = 33554432
long backcolor = 67108864
string text = "발송"
boolean checked = true
boolean setcondcolor = true
end type

type dw_1 from u_dw within w_ja051c
boolean visible = false
integer x = 3854
integer y = 984
integer taborder = 20
boolean bringtotop = true
end type

type cb_1 from pf_u_commandbutton within w_ja051c
boolean visible = false
integer x = 4905
integer y = 16
integer width = 457
integer taborder = 100
boolean bringtotop = true
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "자료생성(DB)"
end type

event clicked;LONG	ll, ll_chk = 0

FOR  ll = 1  TO  dw_list.rowcount ()
   IF dw_list.object.chk [ll]<>'1' THEN CONTINUE
   ll_chk = 1
   EXIT
NEXT
IF ll_chk=0 Then
   f_messagebox ('INFO', '선택된 회사가 없습니다.')
   RETURN
End IF

STRING	ls_corp_gr, ls_name, ls_save_file, ls_data, la_data [], ls_result = '', ls_path = '', ls_select, la_head [], ls_line

LONG	li_file, ll_file, ll_list, ld, lj, ll_detail, ll_data, ll_seq

DateTime ldt_start, ldt_f, ldt_t

adw_jTier   lds_data
str_dw_base ldw

ldt_f = dw_c.object.ymd [1]

SELECT now()
     , f_open_ymd(:ldt_f, '+1') - 1
  INTO :ldt_start
     , :ldt_t
FROM   DUAL;

ldt_start = SQLCA.getitemdatetime (1)
ldt_t     = SQLCA.getitemdatetime (2)

dw_list.enabled = FALSE
st_count.visible = TRUE
FOR  ll_list = 1  TO  dw_list.rowcount ()
   dw_list.selectrow (0, FALSE)
   dw_list.selectrow (ll_list, TRUE)
   dw_list.scrolltorow (ll_list)
   IF dw_list.object.chk [ll_list]<>'1' THEN CONTINUE

   ls_corp_gr = dw_list.object.corp_gr [ll_list]

   SELECT CASE WHEN ksd_cd is null THEN '0' || t1.corp_gr
                                   ELSE '0' || ksd_cd || ksd_ref END
     INTO :ls_name
   FROM   szx0aa t1
   WHERE  t1.corp_gr = :ls_corp_gr;

   ls_name = SQLCA.getitemstring (1)

   ll_detail = dw_detail.rowcount ()
   ll = dw_detail.FIND ("chk='1'", 1, ll_detail)
   IF ll=0  Then
      f_messageBox ('ERR', '선택항목이 없습니다.')
      EXIT
   End IF
   FOR  ll = ll  TO  ll_detail
      IF dw_detail.object.chk [ll]='1' Then
         ldt_f = dw_c.object.ymd [1]
         dw_detail.uf_setrow (ll, TRUE)
         DO WHILE ldt_f <= ldt_t
            ls_path = 'c:\up\' + string (ldt_f,'yyyymmdd') + '\'
            IF directoryexists (ls_path)=FALSE THEN createdirectory (ls_path)
            ls_save_file = ls_name + '_' + string (dw_detail.object.table_nm [ll]) + RIGHT ('00000' + string (dw_detail.object.table_seq [ll]),5) + '_' + string (ldt_f,'yyyymmdd') + '.txt'
            FileDelete (ls_path + ls_save_file)
            dw_detail.object.bigo [ll] = dw_list.object.corp_gr [ll_list] + ' : ' + string (ldt_f,'yyyy.mm.dd') + '   ( ' + ls_path + ls_save_file + ' ) ' + f_sysdate_str ('')
            IF dw_detail.object.file_copy [ll]='1' And f_notnull (dw_detail.object.copy_file_name [ll])  Then
               filecopy (dw_detail.object.copy_file_name [ll], ls_path + ls_save_file, TRUE)
               dw_detail.object.bigo [ll] = dw_list.object.corp_gr [ll_list] + ' :   ' + dw_detail.object.copy_file_name [ll] + ' --> ' + ls_path + ls_save_file + ' ' + f_sysdate_str ('')
            Else
               ll_seq = 0

               DELETE h2o
               WHERE  fdir  = TO_CHAR(:ldt_f,'yyyymmdd')
                 AND  fname = :ls_save_file;

               li_file = FILEOPEN (ls_path + ls_save_file, TextMode!, Write!, LockWrite!, Replace!)
               ls_line = "<?xml version='1.0'  encoding='euc-kr' ?>~r~n<RESULTS>"
               ls_data = ls_line + '~r~n'
               FileWriteEX (li_file, ls_data)

               ll_seq ++
               INSERT INTO h2o
               VALUES ( TO_CHAR(:ldt_f,'yyyymmdd')    /* _1: */
                      , :ls_save_file                 /* _2: */
                      , :ll_seq                       /* _3: */
                      , :ls_line                      /* _4: */
                      );

               ls_select = dw_detail.object.select_sql [ll]
               ls_select = f_replace (ls_select,':corp_gr', ls_corp_gr)
               ls_select = f_replace (ls_select,'2000.01.01', string (ldt_f,'yyyy.mm.dd'))
               ls_select = f_replace (ls_select,'2000.12.31', string (ldt_f,'yyyy.mm.dd'))
               f_get_array (dw_detail.object.header_nm [ll], '@', la_head)

               dw_detail.object.bigo [ll] = dw_list.object.corp_gr [ll_list] + ' : ' + string (ldt_f,'yyyy.mm.dd') + '  ( ' + dw_detail.object.select_table [ll] + ' ) select  ' + f_sysdate_str ('')

               ldw.header_text = la_head
               ldw.fseq = FALSE
               ll_data = SQLCA.sql2dw (ls_select, dw_1, ldw)
               IF f_notnull (SQLCA.sqlerrtext ())  Then
                  ::CLIPBOARD (SQLCA.sqlerrtext ())
                  messagebox ("sqlselect error==>",SQLCA.sqlerrtext ())
               End IF
               lds_data = dw_1

               IF ll_data>0   Then
                  FOR  ld = 1  TO  ll_data
                     ls_data = '    <ROW>~r~n'

                     ll_seq ++
                     INSERT INTO h2o
                     VALUES ( TO_CHAR(:ldt_f,'yyyymmdd')    /* _1: */
                            , :ls_save_file                 /* _2: */
                            , :ll_seq                       /* _3: */
                            , '    <ROW>'                   /* _4: */
                            );

                     FOR  lj = 1  TO  UPPERBOUND (la_head)
                        ls_line = '        <COLUMN NAME="' + la_head [lj] + '"><![CDATA[' + f_nvl (string (lds_data.object.data [ld, lj]),'') + ']]></COLUMN>'
                        ls_data += ls_line + '~r~n'

                        ll_seq ++
                        INSERT INTO h2o
                        VALUES ( TO_CHAR(:ldt_f,'yyyymmdd')    /* _1: */
                               , :ls_save_file                 /* _2: */
                               , :ll_seq                       /* _3: */
                               , :ls_line                      /* _4: */
                               );
                     NEXT
                     ls_data += '    </ROW>~r~n'

                     ll_seq ++
                     INSERT INTO h2o
                     VALUES ( TO_CHAR(:ldt_f,'yyyymmdd')    /* _1: */
                            , :ls_save_file                 /* _2: */
                            , :ll_seq                       /* _3: */
                            , '    </ROW>'                  /* _4: */
                            );
		               commitJ ()

                     FileWriteEX (li_file, ls_data)

                     f_st_count (st_count, ls_path + ls_save_file + '~r~n' + string (ldt_f,'yyyy.mm.dd') + ' filewrite : ', ld, ll_data)
                  NEXT
               End IF
               dw_detail.object.bigo [ll] = dw_list.object.corp_gr [ll_list] + ' : ' + string (ldt_f,'yyyy.mm.dd') + ' filewrite : ' + f_ntrim (ll_data,6,0) + '  '

               FileWriteEX (li_file, '</RESULTS>')
               FileClose (li_file)
               IF dw_detail.object.file_copy [ll]='1' And f_null (dw_detail.object.copy_file_name [ll]) THEN dw_detail.object.copy_file_name [ll] = ls_path + ls_save_file

               ll_seq ++
               INSERT INTO h2o
               VALUES ( TO_CHAR(:ldt_f,'yyyymmdd')    /* _1: */
                      , :ls_save_file                 /* _2: */
                      , :ll_seq                       /* _3: */
                      , '</RESULTS>'                  /* _4: */
                      );
               commitJ ()
            End IF

            SELECT :ldt_f + 1
              INTO :ldt_f
            FROM   dual;

            ldt_f = SQLCA.getitemdatetime (1)
         LOOP
      End IF
   NEXT
   IF cbx_1.checked  Then
      ldt_f = dw_c.object.ymd [1]
      DO WHILE ldt_f <= ldt_t
         ls_path = 'FII ' + string (ldt_f,'yyyymmdd') + ' ?????_FII*_' + string (ldt_f,'yyyymmdd') + '.txt'

         INSERT INTO shell_run
         VALUES ( 'FII'                /* _1: */
                , 'S'                  /* _2: */
                , seqval('seq_shell')    /* _3: */
                , :ls_path             /* _4: */
                , '1'                  /* _5: */
                );

         SELECT :ldt_f + 1
           INTO :ldt_f
         FROM   dual;

         ldt_f = SQLCA.getitemdatetime (1)
      LOOP
      commitJ ()
   End IF
   uf_updatecommit (dw_list)
   ll_file = 0
NEXT
st_count.visible = FALSE
dw_list.enabled = TRUE

SELECT f_time (now(), :ldt_start)
  INTO :ls_result
FROM   dual;

ls_result = SQLCA.getitemstring (1)

IF cbx_1.checked  Then
   f_messageBox ('INFO', '생성 및 발송이 완료 되었습니다.~r~n~r~n실행시간 : ' + ls_result)
Else
   f_messageBox ('INFO', '자료 생성이 완료 되었습니다.~r~n실행시간 : ' + ls_result)
End IF
end event

type cb_send from pf_u_commandbutton within w_ja051c
integer x = 1595
integer y = 188
integer width = 457
integer taborder = 80
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "자료생성"
end type

event clicked;adw_jTier   lds_data
str_dw_base ldw

LONG  ll, ll_list, ll_detail, li_file, ld, lj, ll_data

DATETIME ldt_start, ldt_f, ldt_t

STRING   ls_key    , ls_qkey   , ls_remote_dir, la_up_filepath []
STRING   ls_corp_gr, ls_corp_nm, ls_save_file , ls_data          , ls_result, ls_path
STRING   ls_select , la_head []

ez_n_http   lnv_http

lnv_http = CREATE ez_n_http

ll_list = dw_list.ROWCOUNT ( )
ll      = dw_list.FIND ("chk='1'", 1, ll_list)
IF ll=0  Then
   F_MESSAGEBOX ('ERR', '선택된 회사가 없습니다.')
   RETURN
END IF

ldt_f = dw_c.object.ymd [1]

SELECT now( ), f_open_ymd(:ldt_f, '+1') - 1 INTO :ldt_start, :ldt_t FROM DUAL;

ldt_start = SQLCA.GETITEMDATETIME (1)
ldt_t     = SQLCA.GETITEMDATETIME (2)

dw_list.enabled  = FALSE
st_count.VISIBLE = TRUE
FOR  ll_list = 1  TO  dw_list.ROWCOUNT ( )
   dw_list.selectrow (0, FALSE)
   dw_list.selectrow (ll_list, TRUE)
   dw_list.scrolltorow (ll_list)
   IF dw_list.object.chk [ll_list]<>'1' THEN CONTINUE

   ls_corp_gr = dw_list.object.CORP_GR [ll_list]
   ls_corp_nm = dw_list.object.company_name [ll_list]
   ls_key     = ls_corp_gr + f_sysdate_str ('yyyymmddhh24miss')

   ll_detail = dw_detail.ROWCOUNT ( )
   ll        = dw_detail.FIND ("chk='1'", 1, ll_detail)
   IF ll=0  Then
      F_MESSAGEBOX ('ERR', '선택항목이 없습니다.')
      CONTINUE
   END IF
   FOR  ll = ll  TO  ll_detail
      IF dw_detail.object.chk [ll]='1' Then
         ldt_f = dw_c.object.ymd [1]
         dw_detail.uf_setrow (ll, TRUE)
         DO WHILE ldt_f <= ldt_t
            ls_path = 'c:\up\' + STRING (ldt_f,'yyyymmdd') + '\'
            IF directoryexists (ls_path)=FALSE THEN createdirectory (ls_path)

            ls_save_file = '0' + ls_corp_gr + '_' + STRING (dw_detail.object.table_nm [ll]) + RIGHT ('00000' + STRING (dw_detail.object.table_seq [ll]),5) + '_' + STRING (ldt_f,'yyyymmdd') + '.txt'
            FileDelete (ls_path + ls_save_file)

            dw_detail.object.bigo [ll] = ls_corp_gr + ' : ' + STRING (ldt_f,'yyyy.mm.dd') + '   ( ' + ls_save_file + ' ) ' + f_sysdate_str ('')
            IF dw_detail.object.file_copy [ll]='1' AND f_notnull (dw_detail.object.copy_file_name [ll])  Then
               filecopy (dw_detail.object.copy_file_name [ll], ls_path + ls_save_file, TRUE)
               dw_detail.object.bigo [ll] = ls_corp_gr + ' :   ' + dw_detail.object.copy_file_name [ll] + ' --> ' + ls_save_file + ' ' + f_sysdate_str ('')
            ELSE
               li_file = FILEOPEN (ls_path + ls_save_file, TextMode!, Write!, LockWrite!, Replace!)
               ls_data = "<?xml version='1.0'  encoding='euc-kr' ?>~r~n<RESULTS>~r~n"
               FileWriteEX (li_file, ls_data)

               ls_select = dw_detail.object.select_sql [ll]
               ls_select = f_replace (ls_select,':corp_gr', ls_corp_gr)
               ls_select = f_replace (ls_select,'2000.01.01', STRING (ldt_f,'yyyy.mm.dd'))
               ls_select = f_replace (ls_select,'2000.12.31', STRING (ldt_f,'yyyy.mm.dd'))
               f_get_array (dw_detail.object.header_nm [ll], '@', la_head)

               dw_detail.object.bigo [ll] = ls_corp_gr + ' : ' + STRING (ldt_f,'yyyy.mm.dd') + '  ( ' + dw_detail.object.select_table [ll] + ' ) select  ' + f_sysdate_str ('')

               ldw.header_text = la_head
               ldw.fseq        = FALSE
               ll_data         = SQLCA.sql2dw (ls_select, dw_1, ldw)
               IF f_notnull (SQLCA.sqlerrtext ( ))  Then
                  ::CLIPBOARD (SQLCA.sqlerrtext ( ))
                  MESSAGEBOX ("sqlselect error==>", SQLCA.sqlerrtext ( ))
               END IF
               lds_data = dw_1

               IF ll_data>0   Then
                  FOR  ld = 1  TO  ll_data
                     ls_data = '    <ROW>~r~n'
                     FOR  lj = 1  TO  UPPERBOUND (la_head)
                        ls_data += '        <COLUMN NAME="' + la_head [lj] + '"><![CDATA[' + f_nvl (STRING (lds_data.object.data [ld, lj]),'') + ']]></COLUMN>~r~n'
                     NEXT
                     ls_data += '    </ROW>~r~n'
                     FileWriteEX (li_file, ls_data)
                     f_st_count (st_count, ls_save_file + '~r~n' + STRING (ldt_f,'yyyy.mm.dd') + ' filewrite : ', ld, ll_data)
                  NEXT
               END IF
               dw_detail.object.bigo [ll] = ls_corp_gr + ' : ' + STRING (ldt_f,'yyyy.mm.dd') + ' filewrite : ' + f_ntrim (ll_data,6,0) + '  '
               FileWriteEX (li_file, '</RESULTS>')
               FileClose (li_file)
               IF dw_detail.object.file_copy [ll]='1' AND f_null (dw_detail.object.copy_file_name [ll]) THEN dw_detail.object.copy_file_name [ll] = ls_path + ls_save_file
            END IF

            la_up_filepath [1] = ls_path + ls_save_file
            ls_remote_dir      = '/data/' + STRING (ldt_f,'yyyymmdd')
            IF lnv_http.of_http_up (la_up_filepath, ls_remote_dir, TRUE, false)<0 Then
               MESSAGEBOX ('FTP 자료전송', '자료 저장 실패했습니다!!~r~n' + la_up_filepath [1] +' 전송 오류')
               DESTROY lnv_http
               RETURN
            END IF

            ls_qkey = 's' + ls_key + STRING (ldt_f,'yyyymmdd') + RIGHT ('00000' + STRING (dw_detail.object.table_seq [ll]),5)

            INSERT INTO FTP_QLOG
            VALUES ( :ls_qkey                                /* _1- */
                   , :ls_corp_gr                             /* _2- */
                   , :ldt_f                                  /* _3- */
                   , 'SFTP'                                  /* _4- */
                   , '175.197.131.230'                       /* _5- */
                   , :gnv_vari.is_user_nm                    /* _6- */
                   , :ls_corp_nm || ' 주문자료 핀케치 발송'  /* _7- */
                   , :ls_save_file                           /* _8- */
                   , 'table_conv_aams'                       /* _9- */
                   , '(H2O) 자료 교환용 자료 생성'           /* _10- */
                   , :gnv_vari.is_ipaddress                  /* _11- */
                   ) ;

            INSERT INTO SFTP_Q
            VALUES ( :ls_qkey                        /* _1- */
                   , :ldt_f                          /* _2- */
                   , 's'                             /* _3- */
                   , '183.111.67.26'                 /* _4- */
                   , '22'                            /* _5- */
                   , 'aams'                          /* _6- */
                   , 'aams1!'                        /* _7- */
                   , '/home/aams' || :ls_remote_dir  /* _8- */
                   , :ls_save_file                   /* _9- */
                   , :ls_remote_dir                  /* _10- */
                   , '0'                             /* _11- */
                   , NULL                            /* _12- */
                   , NULL                            /* _13- */
                   , NULL                            /* _14- */
                   , NULL                            /* _15- */
                   , NULL                            /* _16- */
                   , NULL                            /* _17- */
                   ) ;

            SELECT :ldt_f + 1 INTO :ldt_f FROM DUAL;

            ldt_f = SQLCA.GETITEMDATETIME (1)
         LOOP
      END IF
   NEXT
   dw_list.object.h2o [ll_list] = f_sysdate ('')
NEXT
commitJ ( )
uf_updateCommit (dw_List)

DESTROY lnv_http

F_MESSAGEBOX ('INFO', '핀케치 자료 생성 및 발송을 완료했습니다.')
end event

