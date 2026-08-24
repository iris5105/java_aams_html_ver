forward
global type w_ja990h from wt_tab
end type
type tabpage_1 from u_ja990h_t1 within tab_subpage
end type
type tabpage_1 from u_ja990h_t1 within tab_subpage
end type
type tabpage_2 from u_ja990h_t2 within tab_subpage
end type
type tabpage_2 from u_ja990h_t2 within tab_subpage
end type
type cb_other from pf_u_commandbutton within w_ja990h
end type
type dw_xls from fw_u_dwo within w_ja990h
end type
type cb_api from pf_u_commandbutton within w_ja990h
end type
end forward

global type w_ja990h from wt_tab
string is_init_value = "1"
cb_other cb_other
dw_xls dw_xls
cb_api cb_api
end type
global w_ja990h w_ja990h

on w_ja990h.create
int iCurrent
call super::create
this.cb_other=create cb_other
this.dw_xls=create dw_xls
this.cb_api=create cb_api
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_other
this.Control[iCurrent+2]=this.dw_xls
this.Control[iCurrent+3]=this.cb_api
end on

on w_ja990h.destroy
call super::destroy
destroy(this.cb_other)
destroy(this.dw_xls)
destroy(this.cb_api)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = ia_value [1]
end event

event open;icmdbutton = { cb_other }
call super::open
end event

type lb_dirlist from wt_tab`lb_dirlist within w_ja990h
end type

type ln_templeft from wt_tab`ln_templeft within w_ja990h
end type

type ln_tempbuttom from wt_tab`ln_tempbuttom within w_ja990h
end type

type ln_temptop from wt_tab`ln_temptop within w_ja990h
end type

type ln_tempbutton from wt_tab`ln_tempbutton within w_ja990h
end type

type ln_tempstart from wt_tab`ln_tempstart within w_ja990h
end type

type ln_cond1_yline from wt_tab`ln_cond1_yline within w_ja990h
end type

type ln_dw1_yline from wt_tab`ln_dw1_yline within w_ja990h
end type

type ln_cond2_yline from wt_tab`ln_cond2_yline within w_ja990h
end type

type ln_dw2_yline from wt_tab`ln_dw2_yline within w_ja990h
end type

type ln_tempright from wt_tab`ln_tempright within w_ja990h
end type

type uo_navi from wt_tab`uo_navi within w_ja990h
end type

type ln_temptop_shadow from wt_tab`ln_temptop_shadow within w_ja990h
end type

type st_windelaytime from wt_tab`st_windelaytime within w_ja990h
end type

type st_top_rect from wt_tab`st_top_rect within w_ja990h
end type

type p_close from wt_tab`p_close within w_ja990h
end type

type p_excel from wt_tab`p_excel within w_ja990h
end type

type p_print from wt_tab`p_print within w_ja990h
end type

type p_delete from wt_tab`p_delete within w_ja990h
end type

type p_update from wt_tab`p_update within w_ja990h
end type

type p_input from wt_tab`p_input within w_ja990h
end type

type p_retrieve from wt_tab`p_retrieve within w_ja990h
end type

type p_clear from wt_tab`p_clear within w_ja990h
end type

type p_copy from wt_tab`p_copy within w_ja990h
end type

type dw_c from wt_tab`dw_c within w_ja990h
string title = "채권속성"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | bond_attr', gaa.corp_gr, '', 1, '' )
end event

type btn_update from wt_tab`btn_update within w_ja990h
end type

type st_count from wt_tab`st_count within w_ja990h
end type

type tab_subpage from wt_tab`tab_subpage within w_ja990h
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_subpage.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_subpage.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type uo_tab from wt_tab`uo_tab within w_ja990h
end type

type tabpage_1 from u_ja990h_t1 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2288
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1  Then	
   IF ib_ManageData   Then
      dw_1.uf_protect (0, dw_1.ia_protect [1])
   Else
      dw_1.uf_protect (0, dw_1.ia_protect [2])
   End IF

	DataWindowChild	ldwc

	dw_pagelist.getChild ('bond_cd', ldwc)
	ldwc.reset()
	fw_f_setdddw (dw_pagelist, 'bond_cd', {string (dw_c.Object.dddw[1])})
	ldwc.setSort ('bond_cd')
	ldwc.sort ()

   ia_value [1] = dw_c.object.dddw [1]
   dw_pagelist.SetFilter ("sanghw_ymd >= date('" + string(idt_workdate, 'yyyy.mm.dd') + "')" )
   dw_pagelist.retrieve (gaa.corp_gr, dw_c.object.dddw [1], idt_workdate)
End IF

RETURN 1
end event

type tabpage_2 from u_ja990h_t2 within tab_subpage
integer x = 18
integer y = 112
integer width = 5344
integer height = 2288
end type

event ue_subpage_selected;call super::ue_subpage_selected;IF AncestorReturnVALUE=1 THEN dw_pagelist.retrieve (dw_c.object.dddw [1])
RETURN 1
end event

type cb_other from pf_u_commandbutton within w_ja990h
integer x = 2231
integer y = 16
integer width = 398
integer taborder = 40
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string text = "말일점검"
end type

event clicked;tab_subpage.tabpage_1.dw_pagelist.setfilter ("string (balh_ymd,'dd')>'27' OR string (balh_ymd,'dd')<>string (sanghw_ymd,'dd')")
tab_subpage.tabpage_1.dw_pagelist.filter ()
end event

type dw_xls from fw_u_dwo within w_ja990h
boolean visible = false
integer x = 2555
integer y = 252
integer width = 2903
integer height = 1704
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_sjx0jb_load"
boolean livescroll = false
end type

type cb_api from pf_u_commandbutton within w_ja990h
integer x = 1339
integer y = 188
integer width = 430
integer taborder = 32
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "API종목생성"
end type

event clicked;call super::clicked;DEC   ldc_gugan

STRING   ls_jm_cd

ls_jm_cd = tab_subpage.tabpage_1.dw_pagelist.object.as_cj_cd [tab_subpage.tabpage_1.dw_pagelist.getrow ()]

SELECT NOW_GUGAN_NO
  INTO :ldc_gugan
  FROM SCM0CJ t1
 WHERE CORP_GR = :gaa.CORP_GR
   AND JM_CD   = :ls_jm_cd ;

IF SQLCA.SQLCode ( )=0   Then
   ldc_gugan = SQLCA.GETITEMNUMBER (1)
   IF f_num (ldc_gugan)=0  Then
      INSERT INTO SCM0CJ_API_BACK
        SELECT CORP_GR              /* _1- */
             , JM_CD                /* _2- */
             , CJ_FNM               /* _3- */
             , CJ_NM                /* _4- */
             , CJ_ENM               /* _5- */
             , BOND_ATTR            /* _6- */
             , BOND_CD              /* _7- */
             , BALH_SEQ             /* _8- */
             , BALH_AEK             /* _9- */
             , BALH_GA              /* _10- */
             , BALH_YMD             /* _11- */
             , MEDO_YMD             /* _12- */
             , SANGHW_YMD           /* _13- */
             , BUNHAL_GB            /* _14- */
             , YDONG_GB             /* _15- */
             , SANGJ_GB             /* _16- */
             , SUNHU_GB             /* _17- */
             , HALIN_GB             /* _18- */
             , IJA_JIGUB_GB         /* _19- */
             , IJA_YY_SU            /* _20- */
             , YY_IJA_HOISU         /* _21- */
             , TOT_IJA_HOICHA       /* _22- */
             , PYOM_IYUL            /* _23- */
             , HALIN_IYUL           /* _24- */
             , NOW_GUGAN_NO         /* _25- */
             , SUNME_IJA_YMD        /* _26- */
             , BF_IJA_YMD           /* _27- */
             , AF_IJA_YMD           /* _28- */
             , BUDO_YMD             /* _29- */
             , BOJNG_CO             /* _30- */
             , JACH_CD              /* _31- */
             , BALH_CO              /* _32- */
             , HALJ_IYUL            /* _33- */
             , NOW ( )              /* _34-BACKUP 일시 */
             , AS_CJ_CD             /* _35- */
             , SLIP_ATTR            /* _36- */
             , SUN_TAX_NAPBU_GB     /* _37- */
             , HOLI_IJA_SU          /* _38- */
             , MOJIB_GB             /* _39- */
             , MANGI_IYUL           /* _40- */
             , SANGHW_IJA_GB1       /* _41- */
             , SANGHW_IJA_GB2       /* _42- */
             , SANGHW_IJA_IYUL      /* _43- */
             , SANGHW_AEKM_GB1      /* _44- */
             , SANGHW_AEKM_GB2      /* _45- */
             , SANGHW_AEKM_IYUL     /* _46- */
             , MANGI_SANGHW_PER     /* _47- */
             , FRN_INTR             /* _48- */
             , BOND_CLSF_CD         /* _49- */
             , BOND_CLSF_KOR_NAME   /* _50- */
             , BOND_GRTE_ISTT_NAME  /* _51- */
          FROM SCM0CJ t1
         WHERE CORP_GR = :gaa.CORP_GR
           AND JM_CD   = :ls_jm_cd ;

      DELETE FROM SCM0CJ
       WHERE CORP_GR = :gaa.CORP_GR
         AND JM_CD   = :ls_jm_cd ;
   ELSE
      F_MESSAGEBOX ('INFO','이미 등록된 종목입니다')
      RETURN
   END IF
END IF

INSERT INTO SCM0CJ
  SELECT :gaa.CORP_GR                                                                           AS CORP_GR           /* _1- */
       , t1.PDNO                                                                                AS jm_cd             /* _2- */
       , t1.KSD_BOND_ITEM_NAME                                                                  AS cj_fnm            /* _3- */
       , t2.PRDT_ABRV_NAME                                                                      AS cj_nm             /* _4- */
       , t1.KSD_BOND_ITEM_ENG_NAME                                                              AS cj_enm            /* _5- */
       , CASE When SUBSTR (t1.PDNO,3,1)='C' THEN '1'
                                            ELSE SUBSTR (t1.PDNO,3,1)
         END                                                                                    AS bond_attr         /* _6- */
       , CASE SUBSTR (t1.PDNO,3,1) When '1' THEN SUBSTR (t1.PDNO,4,3)
                                   When '2' THEN SUBSTR (t1.PDNO,9,1)
                                   When '3' THEN SUBSTR (t1.PDNO,4,3)
                                   When '6' THEN CASE When t1.BOND_CLSF_KOR_NAME LIKE '%전환%'     THEN '5'
                                                      When t1.BOND_CLSF_KOR_NAME LIKE '%신주인수%' THEN '6'
                                                      When t1.BOND_CLSF_KOR_NAME LIKE '%교환%'     THEN '7'
                                                      When t1.BOND_CLSF_KOR_NAME LIKE '%옵션%'     THEN '8'
                                                      When t2.BOND_GRTE_ISTT_NAME IS NOT NULL      THEN '1'
                                                                                                   ELSE '4' END
                                            ELSE NULL
         END                                                                                    AS bond_cd           /* _7- */
       , SUBSTR (t1.PDNO,7,2)                                                                   AS balh_seq          /* _8- */
       , t2.ISSU_AMT                                                                            AS balh_aek          /* _9- */
       , CASE t1.PNIA_INT_CALC_UNPR When 0 THEN 9
                                           ELSE t1.PNIA_INT_CALC_UNPR
         END                                                                                    AS balh_ga           /* _10- */
       , TO_DATE(t1.ISSU_DT,'yyyymmdd')                                                         AS balh_ymd          /* _11- */
       , TO_DATE (t1.RVNU_DT,'yyyymmdd')                                                        AS medo_ymd          /* _12- */
       , TO_DATE (t1.RDPT_DT,'yyyymmdd')                                                        AS sanghw_ymd        /* _13- */
       , CASE t1.BOND_INT_DFRM_MTHD_CD When '07' THEN '1'
                                                 ELSE '2'
         END                                                                                    AS bunhal_gb         /* _14- */
       , CASE When t2.ASST_RQDI_DVSN_CD IS NULL THEN '2'
                                                             ELSE '1'
         END                                                                                    AS ydong_gb          /* _15- */
       , CASE When t1.LSTG_DT='00000000' THEN 'B'
                                                      ELSE 'A'
         END                                                                                    AS sangj_gb          /* _16- */
       , '2'                                                                                    AS sunhu_gb          /* _17- */
       , '2'                                                                                    AS halin_gb          /* _18- */
       , CASE SUBSTR (t1.PDNO,3,1)
              When '1' THEN SUBSTR (t1.PDNO,9,1)
              When '3' THEN CASE When SUBSTR (t1.PDNO,4,3)='101' THEN '0'
                                                                 ELSE SUBSTR (t1.PDNO,9,1) END
                       ELSE CASE t1.BOND_INT_DFRM_MTHD_CD When '01' THEN '1'  /* 할인채 */
                                                          When '02' THEN '4'  /* 복리채 */
                                                          When '03' THEN '7'  /* 이표채.확정금리 */
                                                          When '04' THEN '8'  /* 이표채.금리연동 */
                                                          When '05' THEN 'G'  /* 이표채.변동금리 */
                                                          When '06' THEN '9'  /* 단리채 */
                                                          When '07' THEN '9'  /* 분할채 */
                                                          When '09' THEN 'D'  /* 복5단2 */
                                                          When '19' THEN 'H'  /* 기타.고정금리|기타.변동금리 */
                                                          When '29' THEN 'G' END
         END                                                                                    AS ija_jigub_gb      /* _19- */
       , months_between (TO_DATE (t1.RDPT_DT,'yyyymmdd'), TO_DATE(t1.ISSU_DT,'yyyymmdd')) / 12  AS ija_yy_su         /* _20- */
       , CASE t1.BOND_INT_DFRM_MTHD_CD When '03' THEN 4  /* 이표채.확정금리 */
                                       When '04' THEN 4  /* 이표채.금리연동 */
                                       When '05' THEN 4  /* 이표채.변동금리 */
                                                 ELSE 1
																 END                                     AS yy_ija_hoisu      /* _21- */
       , months_between (TO_DATE (t1.RDPT_DT,'yyyymmdd'), TO_DATE(t1.ISSU_DT,'yyyymmdd')) 
         / 12 * CASE t1.BOND_INT_DFRM_MTHD_CD When '03' THEN 4  /* 이표채.확정금리 */
                                              When '04' THEN 4  /* 이표채.금리연동 */
                                              When '05' THEN 4  /* 이표채.변동금리 */
                                                        ELSE 1
                END                                                                             AS tot_ija_hoicha    /* _22- */
       , t2.SRFC_INRT / 100                                                                     AS pyom_iyul         /* _23- */
       , CASE t1.BOND_INT_DFRM_MTHD_CD When '01' THEN t2.DSCT_EC_RT / 100
                                                 ELSE 0
         END                                                                                    AS halin_iyul        /* _24- */
       , NULL                                                                                   AS now_gugan_no      /* _25- */
       , NULL                                                                                   AS sunme_ija_ymd     /* _26- */
       , NULL                                                                                   AS bf_ija_ymd        /* _27- */
       , NULL                                                                                   AS af_ija_ymd        /* _28- */
       , NULL                                                                                   AS budo_ymd          /* _29- */
       , NULL                                                                                   AS bojng_cd          /* _30- */
       , CASE When SUBSTR (t1.PDNO,3,1)='2' THEN SUBSTR (t1.PDNO,4,3)
                                            ELSE NULL END                                       AS jach_cd           /* _31- */
       , t2.ISSU_ISTT_CD                                                                        AS balh_co           /* _32- */
       , CASE t1.BOND_INT_DFRM_MTHD_CD When '01' THEN 0
                                                 ELSE t2.DSCT_EC_RT / 100
         END                                                                                    AS halj_iyul         /* _33- */
       , NOW ( )                                                                                AS JM_CRE_DT         /* _34- */
       , t1.PDNO                                                                                AS sj_cj_cd          /* _35- */
       , CASE When SUBSTR (t1.PDNO,3,1)='C' THEN '1'
                                            ELSE SUBSTR (t1.PDNO,3,1)
         END                                                                                    AS slip_attr         /* _36- */
       , 'N'                                                                                    AS sun_tax_napbu_gb  /* _37- */
       , 'A'                                                                                    AS holi_ija_su       /* _38- */
       , NULL                                                                                   AS mojib_gb          /* _39- */
       , t1.EXPD_ASRC_ERNG_RT / 100                                                             AS mangi_iyul        /* _40- */
       , NULL                                                                                   AS sanghw_ija_gb1    /* _41- */
       , NULL                                                                                   AS sanghw_ija_gb2    /* _42- */
       , NULL                                                                                   AS sanghw_ija_iyul   /* _43- */
       , NULL                                                                                   AS sanghw_aekm_gb1   /* _44- */
       , NULL                                                                                   AS sanghw_aekm_gb2   /* _45- */
       , NULL                                                                                   AS sanghw_aekm_iyul  /* _46- */
       , t1.EXPD_RDPT_RT                                                                        AS mangi_sanghw_per  /* _47- */
       , t1.frn_intr                                                                                                 /* _48- */
       , t1.bond_clsf_cd                                                                                             /* _49- */
       , t1.bond_clsf_kor_name                                                                                       /* _50- */
       , t2.BOND_GRTE_ISTT_NAME                                                                                      /* _51- */
    FROM API_BOND_INFO  t1
       , API_ISSUE_INFO t2
   WHERE t1.PDNO = :ls_jm_cd
     AND t2.PDNO = t1.PDNO ;
IF SQLCA.sqlnrows( )=1  Then
   F_MESSAGEBOX ('INFO','종목생성 정상처리')
   commitJ ( )
ELSE
   rollbackJ ( )
   F_MESSAGEBOX ('DATA','API 종목요청내용 확인 후 다시 실행')
END IF
end event

