forward
global type w_ja015d from wt_vertole
end type
type cb_text from pf_u_commandbutton within w_ja015d
end type
type cb_folder from pf_u_commandbutton within w_ja015d
end type
end forward

global type w_ja015d from wt_vertole
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
integer ii_dddw_position = 1
string is_find = "fund_cd=~'~'"
string is_init_value = "%"
cb_text cb_text
cb_folder cb_folder
end type
global w_ja015d w_ja015d

type variables

end variables

event wue_lastopen;call super::wue_lastopen;cb_text.visible = (gaa.corp_gr = '2203')
dw_c.object.dddw [1] = ia_value [1]
dw_c.object.ymd [1] = f_gijunga_ymd ('-')
end event

on w_ja015d.create
int iCurrent
call super::create
this.cb_text=create cb_text
this.cb_folder=create cb_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_text
this.Control[iCurrent+2]=this.cb_folder
end on

on w_ja015d.destroy
call super::destroy
destroy(this.cb_text)
destroy(this.cb_folder)
end on

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
is_find = "fund_cd='" + gaa.fund_cd + "'"
dw_list.retrieve (gaa.corp_gr, dw_c.object.dddw [1], dw_c.object.ymd [1])
end event

event ue_activate;call super::ue_activate;IF dw_List.enabled THEN dw_List.uf_find ("fund_cd='" + gaa.fund_cd + "'")
end event

type lb_dirlist from wt_vertole`lb_dirlist within w_ja015d
end type

type ln_templeft from wt_vertole`ln_templeft within w_ja015d
end type

type ln_tempbuttom from wt_vertole`ln_tempbuttom within w_ja015d
end type

type ln_temptop from wt_vertole`ln_temptop within w_ja015d
end type

type ln_tempbutton from wt_vertole`ln_tempbutton within w_ja015d
end type

type ln_tempstart from wt_vertole`ln_tempstart within w_ja015d
end type

type ln_cond1_yline from wt_vertole`ln_cond1_yline within w_ja015d
end type

type ln_dw1_yline from wt_vertole`ln_dw1_yline within w_ja015d
end type

type ln_cond2_yline from wt_vertole`ln_cond2_yline within w_ja015d
end type

type ln_dw2_yline from wt_vertole`ln_dw2_yline within w_ja015d
end type

type ln_tempright from wt_vertole`ln_tempright within w_ja015d
end type

type uo_navi from wt_vertole`uo_navi within w_ja015d
end type

type ln_temptop_shadow from wt_vertole`ln_temptop_shadow within w_ja015d
end type

type st_windelaytime from wt_vertole`st_windelaytime within w_ja015d
end type

type st_top_rect from wt_vertole`st_top_rect within w_ja015d
end type

type p_close from wt_vertole`p_close within w_ja015d
end type

type p_excel from wt_vertole`p_excel within w_ja015d
end type

type p_print from wt_vertole`p_print within w_ja015d
end type

type p_delete from wt_vertole`p_delete within w_ja015d
end type

type p_update from wt_vertole`p_update within w_ja015d
end type

type p_input from wt_vertole`p_input within w_ja015d
end type

type p_retrieve from wt_vertole`p_retrieve within w_ja015d
end type

type p_clear from wt_vertole`p_clear within w_ja015d
end type

type p_copy from wt_vertole`p_copy within w_ja015d
end type

type dw_c from wt_vertole`dw_c within w_ja015d
string title = "증권사@기준일자"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw', gaa.corp_gr, "%,전체,", 2, "tr_co_cd in (select mg_cd from szm0ia where corp_gr='" + gaa.corp_gr + "')")
end event

event dw_c::ue_valid;call super::ue_valid;ia_value [1] = Object.dddw [1]
RETURN TRUE
end event

type btn_update from wt_vertole`btn_update within w_ja015d
end type

type st_count from wt_vertole`st_count within w_ja015d
end type

type dw_list from wt_vertole`dw_list within w_ja015d
boolean visible = true
string dataobject = "d_ja015d1"
boolean eb_null_line = false
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'series_gb', gaa.corp_gr, '', 1, '')
end event

type st_move from wt_vertole`st_move within w_ja015d
boolean leftmaxsizefixed = true
end type

type ole_rd from wt_vertole`ole_rd within w_ja015d
end type

event ole_rd::ue_retrieve;call super::ue_retrieve;gaa.fund_cd = dw_list.object.fund_cd [row]
uf_fileopen ('rd_ja015d_'+gaa.corp_gr+'.mrd', &
                  'ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + '] ' + &
                  'nav_target_yn[' + IIF (gaa.nav_target_jasan='Y','Y','%') + '] ' + &
               'title[( ' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + ' ) 자 산 명 세 표] ' + &
            'fund_cd[' + gaa.fund_cd + ']' )

end event

type rb_onepage from wt_vertole`rb_onepage within w_ja015d
end type

type cb_text from pf_u_commandbutton within w_ja015d
integer x = 2217
integer y = 192
integer width = 521
integer taborder = 90
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "TEXT생성(전송)"
end type

event clicked;uo_wininet  wininet
ads_jTier   lds_data

LONG  ll, ll_data, li_file

STRING   ls_sqlsyntax, ls_ymd, ls_path, ls_save_file, ls_data, ls_qkey, ls_remote_dir, ls_result

ls_ymd = STRING (dw_c.object.ymd [1],'yyyymmdd')

wininet.ii_transfer_type = 1  // 1:ASCII 2:BINARY
wininet.ii_port          = 21
wininet.is_ip            = 'app.aams.kr'
wininet.is_user          = 'aams'
wininet.is_pwd           = 'aams'

IF wininet.uf_FTP_connect ( )>0   Then
   wininet.is_path = '/send/' + ls_ymd
   wininet.uf_FTP_changedirectory ( )
ELSE
   MESSAGEBOX ('ERR', 'upload 접속에러')
   RETURN
END IF

lds_data = CREATE ads_jTier

ls_sqlsyntax = " SELECT TO_CHAR (t1.ymd,'yyyy.mm.dd')            /* _1- */ " + &
               "      , t1.fund_cd                               /* _2- */ " + &
               "      , ia.fund_nm                               /* _3- */ " + &
               "      , t1.jm_cd                                 /* _4- */ " + &
               "      , t1.jm_nm                                 /* _5- */ " + &
               "      , CASE When t1.jm_gr='2' AND SUBSTR(t1.jm_cd,8,2)='90' THEN 0 " + &
               "                                                             ELSE t1.aekm " + &
               "        END                            AS aekm   /* _6- */ " + &
               "      , t1.siga_aek                              /* _7- */ " + &
               "      , t1.sise                                  /* _8- */ " + &
               "   FROM UZM0UI t1 " + &
               "      , SZM0IA ia " + &
               "  WHERE t1.CORP_GR = '" + gaa.corp_gr + "' " + &
               "    AND t1.ymd     = '" + string (dw_c.object.ymd [1],'yyyy.mm.dd') + "' " + &
               "    AND ia.CORP_GR = t1.CORP_GR " + &
               "    AND ia.fund_cd = t1.fund_cd " + &
               "  ORDER BY t1.fund_cd " + &
               "         , t1.jm_gr " + &
               "         , t1.jm_cd "

ls_path = 'c:\up\' + ls_ymd + '\'
IF directoryexists (ls_path)=FALSE THEN createdirectory (ls_path)
ls_save_file = '0' + gaa.CORP_GR + '_0703_' + ls_ymd + '.txt'
FileDelete (ls_path + ls_save_file)

ll_data = SQLCA.sql2ds (classname( ), ls_sqlsyntax, lds_data, 'xml')
IF ll_data=0   Then
   wininet.uf_FTP_disconnect ( )
   MESSAGEBOX ('ERR', '정보계 생성 후 작업하십시오.')
   RETURN
END IF

li_file = FILEOPEN (ls_path + ls_save_file, TextMode!, Write!, LockWrite!, Replace!)

st_count.VISIBLE = true
FOR  ll = 1  TO  ll_data
   f_st_count (st_count, ls_save_file + '~r~n전송 TEXT파일 생성 : ', ll, ll_data)
   ls_data = lds_data.GETITEMSTRING (ll, 1) + ','
   ls_data += lds_data.GETITEMSTRING (ll, 2) + ','
   ls_data += lds_data.GETITEMSTRING (ll, 3) + ','
   ls_data += lds_data.GETITEMSTRING (ll, 4) + ','
   ls_data += lds_data.GETITEMSTRING (ll, 5) + ','
   ls_data += STRING (lds_data.GETITEMNUMBER (ll, 6)) + ','
   ls_data += STRING (lds_data.GETITEMNUMBER (ll, 7)) + ','
   ls_data += STRING (lds_data.GETITEMNUMBER (ll, 8)) + '~r~n'
   FileWriteEX (li_file, ls_data)
NEXT
FileClose (li_file)

IF f_nvl (wininet.is_path,'/')<>'/send/' + ls_ymd  Then
   wininet.is_path = '/send/' + ls_ymd
   wininet.uf_FTP_changedirectory ( )
END IF
wininet.is_local_path = 'c:\up\' + ls_ymd + '\'
wininet.is_name       = ls_save_file

ls_result = wininet.uf_FTP_WriteFile ( )

ls_qkey       = 's1' + f_sysdate_str ('yyyymmddhh24miss')
ls_remote_dir = '/data/' + ls_ymd

f_st_count (st_count, ls_save_file + '~r~nTEXT파일 SEND', 0, 0)

INSERT INTO FTP_QLOG
VALUES ( :ls_qkey                     /* _1- */
       , :gaa.CORP_GR                 /* _2- */
       , TO_DATE(:ls_ymd,'yyyymmdd')  /* _3- */
       , 'SFTP'                       /* _4- */
       , :wininet.is_ip               /* _5- */
       , :gnv_vari.is_user_nm         /* _6- */
       , :gaa.corp_nm || ' 자산잔고'  /* _7- */
       , :wininet.is_name             /* _8- */
       , 'uyjs031_ja'                 /* _9- */
       , '자산잔고'                   /* _10- */
       , :gnv_vari.is_ipaddress       /* _11- */
       ) ;

INSERT INTO SFTP_Q
VALUES ( :ls_qkey                          /* _1- */
       , TO_DATE(:ls_ymd,'yyyymmdd')       /* _2- */
       , 's'                               /* _3- */
       , '183.111.67.26'                   /* _4- */
       , '22'                              /* _5- */
       , 'aams'                            /* _6- */
       , 'aams1!'                          /* _7- */
       , '/home/aams' || :wininet.is_path  /* _8- */
       , :wininet.is_name                  /* _9- */
       , :ls_remote_dir                    /* _10- */
       , '0'                               /* _11- */
       , NULL                              /* _12- */
       , NULL                              /* _13- */
       , NULL                              /* _14- */
       , NULL                              /* _15- */
       , NULL                              /* _16- */
       , NULL                              /* _17- */
       ) ;

wininet.uf_FTP_disconnect ( )

F_MESSAGEBOX ('INFO', '잔고 TEXT파일 발송을 완료했습니다.')
st_count.VISIBLE = false
end event

type cb_folder from pf_u_commandbutton within w_ja015d
integer x = 2793
integer y = 192
integer width = 457
integer taborder = 100
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "저장폴더열기"
end type

event clicked;gnv_extfunc.of_shellexecute ('c:\up\' + string (dw_c.object.ymd [1],'yyyymmdd'))
end event

