forward
global type u_ja990h_t1 from utt_list
end type
type dw_kap from u_dw within u_ja990h_t1
end type
type cb_1 from pf_u_commandbutton within u_ja990h_t1
end type
type dw_1 from u_dw within u_ja990h_t1
end type
type dw_2 from u_dw within u_ja990h_t1
end type
end forward

global type u_ja990h_t1 from utt_list
integer width = 6112
string text = "채권종목"
event ue_danga ( )
dw_kap dw_kap
cb_1 cb_1
dw_1 dw_1
dw_2 dw_2
end type
global u_ja990h_t1 u_ja990h_t1

on u_ja990h_t1.create
int iCurrent
call super::create
this.dw_kap=create dw_kap
this.cb_1=create cb_1
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_kap
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
end on

on u_ja990h_t1.destroy
call super::destroy
destroy(this.dw_kap)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event ue_subpage_open;call super::ue_subpage_open;dw_2.insertrow (0)
end event

event resize;call super::resize;dw_pageList.width = dw_pageList.width - dw_1.width - 30
dw_1.X = dw_pageList.x + dw_pageList.width + 30
dw_1.height = dw_pageList.Y + dw_pageList.height - dw_1.Y - dw_2.height - 30
dw_2.y = dw_1.y + dw_1.height + 30
dw_2.x = dw_1.x
dw_2.width = dw_1.width

cb_1.X = dw_1.x
cb_1.width = dw_1.width
end event

event ue_subpage_modified;call super::ue_subpage_modified;IF AncestorReturnVALUE THEN RETURN TRUE
RETURN   dw_1.uf_isModified ()
end event

event ue_subpage_update;call super::ue_subpage_update;IF AncestorReturnVALUE=-1 THEN RETURN -1
IF dw_1.uf_update ()=FALSE THEN RETURN -1
RETURN 1
end event

event ue_subpage_reset;call super::ue_subpage_reset;IF dw_1.ibsetlist4subbtn THEN dw_1.of_dw2subbtn ({'p_load','p_save','p_excel','p_input','p_copy','p_delete','p_firstpage','p_priorpage','p_nextpage','p_lastpage'}, false)
dw_1.uf_reset()
end event

type ln_temptop from utt_list`ln_temptop within u_ja990h_t1
end type

type ln_tempstart from utt_list`ln_tempstart within u_ja990h_t1
end type

type ln_templeft from utt_list`ln_templeft within u_ja990h_t1
end type

type ln_cond_start from utt_list`ln_cond_start within u_ja990h_t1
end type

type ln_tempright from utt_list`ln_tempright within u_ja990h_t1
end type

type ln_cond1_yline from utt_list`ln_cond1_yline within u_ja990h_t1
end type

type ln_dw1_yline from utt_list`ln_dw1_yline within u_ja990h_t1
end type

type ln_tempbutton from utt_list`ln_tempbutton within u_ja990h_t1
end type

type dw_pagelist from utt_list`dw_pagelist within u_ja990h_t1
integer width = 2144
string dataobject = "d_ja990h_t1a"
end type

event dw_pagelist::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'ija_jigub_gb'   , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'budo_gb'        , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'chg_frn_gb'     , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'danbok_gb'      , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'halin_gb'       , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'sangj_gb'       , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'sunhu_gb'       , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'bunhal_gb'      , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'ydong_gb'       , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'mojib_gb'       , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'sanghw_ija_gb1' , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'sanghw_ija_gb2' , gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'sanghw_aekm_gb1', gaa.CORP_GR, '', 1, '')
f_dddwctl (THIS, 'sanghw_aekm_gb2', gaa.CORP_GR, '', 1, '')
end event

event dw_pagelist::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

DEC   ldc_rf_ga

LONG  ll

DATETIME ldt

STRING   ls_cd

FOR  ll = 1  TO  rowcount ()
   IF GETITEMSTATUS (ll, 0, PRIMARY!)=NotModified! THEN CONTINUE
//   IF Object.bond_attr [ll]='2'  Then
//      IF f_null (Object.jach_cd [ll])  Then
//         f_messageBox ("I000", string (ll) + " 행에서 자치단체 오류")
//         RETURN 1
//      End IF
//   End IF
   IF Object.sanghw_ymd [ll]<Object.balh_ymd [ll]  Then
      F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 상환일 오류")
      RETURN 1
   END IF
   IF Object.medo_ymd [ll]<Object.balh_ymd [ll] Then
      IF IsNull (Object.sunme_ija_ymd [ll])  Then
         F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 선이자수령일 오류")
         RETURN 1
      END IF
   END IF
   IF IsNull (Object.sunme_ija_ymd [ll])=FALSE  Then
      IF Object.sunme_ija_ymd [ll]<Object.medo_ymd [ll]  Then
         F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 선이자수령일(매출일) 오류")
         RETURN 1
      END IF
      IF Object.sunme_ija_ymd [ll]>Object.sanghw_ymd [ll]   Then
         F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 선이자수령일(상환일) 오류")
         RETURN 1
      END IF
   END IF
   IF (Object.bond_attr [ll]='6') AND PosA ('1ABCD',Object.bond_cd [ll])>0 Then
      IF f_null (Object.bojng_cd [ll]) Then
         F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 보증기관 오류")
         RETURN 1
      END IF
   END IF
   IF Object.halin_gb [ll]='1'   Then
      IF f_num (Object.halin_iyul [ll])=0 Then
         F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 할인이율 오류")
         RETURN 1
      END IF
   END IF
   IF f_num (Object.ija_yy_su [ll])=0  Then
      F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 이자년수 오류")
      RETURN 1
   END IF
   IF Object.ija_jigub_gb [ll] <> '4' AND f_num (Object.yy_ija_hoisu [ll])=0  Then
      F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 연횟수 오류")
      RETURN 1
   END IF
   IF f_num (Object.tot_ija_hoicha [ll])=0   Then
      F_MESSAGEBOX ("I000", STRING (ll) + " 행에서 총이자회차 오류")
      RETURN 1
   END IF

   IF GETITEMSTATUS (ll, 'balh_ymd', PRIMARY!)=DATAMODIFIED! OR &
      GETITEMSTATUS (ll, 'ija_jigub_gb', PRIMARY!)=DATAMODIFIED! OR &
      GETITEMSTATUS (ll, 'bond_cd', PRIMARY!)=DATAMODIFIED! OR &
      GETITEMSTATUS (ll, 'halin_gb', PRIMARY!)=DATAMODIFIED! OR &
      GETITEMSTATUS (ll, 'halin_iyul', PRIMARY!)=DATAMODIFIED! OR &
      GETITEMSTATUS (ll, 'yy_ija_hoisu', PRIMARY!)=DATAMODIFIED! OR &
      GETITEMSTATUS (ll, 'pyom_iyul', PRIMARY!)=DATAMODIFIED! OR GETITEMSTATUS (ll, 'halj_iyul', PRIMARY!)=DATAMODIFIED!  Then

      ls_cd = Object.jm_cd [ll]

      DELETE FROM SCJ0IG
       WHERE CORP_GR = :gaa.CORP_GR
         AND jm_cd   = :ls_cd ;
   END IF

   IF GETITEMSTATUS (ll, 'as_cj_cd', PRIMARY!)=NEWMODIFIED! Then
      ls_cd = Object.jm_cd [ll]
      IF dw_kap.retrieve (ls_cd)=1  Then
         ldt       = f_to_date (dw_kap.object.chg_start_il [1], '')
         ldc_rf_ga = dec (dw_kap.object.chg_ga [1])
         INSERT INTO SCJ0RF
         VALUES ( :gaa.CORP_GR  /* _1- */
                , :ls_cd        /* _2- */
                , :ldt          /* _3- */
                , :ldc_rf_ga    /* _4- */
                , NULL          /* _5- */
                , 0             /* _6- */
                ) ;
         IF SQLCA.sqlcode () <> 0   Then
            MESSAGEBOX ('scj0rf INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
            RETURN 1
         END IF
      END IF
   END IF
NEXT
end event

event dw_pagelist::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG  tot_ija_hoicha, ija_yy_su

DATE  balh_yy, sanghw_yy

DATETIME ldt_balh_ymd, ldt_sanghw_ymd

STRING   ls_bond_nm, jm_cd, bj_jm_cd

CHOOSE CASE DWO.NAME
   CASE 'as_cj_cd'   // KAP 종목정목 복사처리
      IF f_null (data)  Then
         F_MESSAGEBOX ('INFO', '장부가 평가 종목으로 처리됩니다.')
         RETURN
      END IF
      IF dw_kap.retrieve (data)=0   Then
         F_MESSAGEBOX ('ERR', '한국채권평가 종목자료가 없습니다.(' + data + ')')
      ELSE
         Object.CORP_GR [row] = gaa.CORP_GR
         Object.jm_cd [row]   = data
         Object.cj_fnm [row]  = dw_kap.object.cj_nm [1]
         Object.cj_nm [row]   = dw_kap.object.cj_nm [1]
         Object.cj_enm [row]  = dw_kap.object.cj_enm [1]
         CHOOSE CASE MID (data, 3, 1)
            CASE 'C'
               Object.bond_attr [row] = '1'
            CASE ELSE
               Object.bond_attr [row] = MID (data, 3, 1)
         END CHOOSE
         CHOOSE CASE MID (data, 3, 1)
            CASE "1", "3"   // 국채,특수채,금융채
               Object.bond_cd [row]  = MID (data, 4, 3)
               Object.balh_seq [row] = MID (data, 7, 2)
               IF Object.bond_cd [row]='101' Then
                  // 통안채
                  Object.ija_jigub_gb [row] = '0'
                  Object.amt_unit [row]     = 1000000
               ELSE
                  Object.ija_jigub_gb [row] = MID (data, 9, 1)
                  Object.amt_unit [row]     = 9
               END IF
            CASE "2"  // 지방채
               Object.jach_cd [row]  = MID (data, 4, 3)
               Object.balh_seq [row] = MID (data, 7, 2)
               Object.bond_cd [row]  = MID (data, 9, 1)
               Object.amt_unit [row] = 9
               CHOOSE CASE dw_kap.object.ija_jigub_gb [1]
                  CASE '11'
                     Object.ija_jigub_gb [row] = '1'
                  CASE '12', '22'
                     IF MID(data, 9,1)='D'   Then
                           Object.ija_jigub_gb [row] = 'D'
                     ELSE
                        Object.ija_jigub_gb [row] = '4'
                     END IF
                  CASE '13', '21'
                     Object.ija_jigub_gb [row] = '7'
                  CASE '14', '23'
                     Object.ija_jigub_gb [row] = '9'
                  CASE '15'
                     Object.ija_jigub_gb [row] = '4'
                     Object.holi_ija_su [row]  = 'S'
               END CHOOSE
            CASE "6"  // 회사채
               Object.balh_co [row]  = MID (data, 4, 3)
               Object.balh_seq [row] = MID (data, 7, 2)
               Object.balh_ga [row]  = 10000
               CHOOSE CASE dw_kap.object.ija_jigub_gb [1]
                  CASE '11'
                     Object.ija_jigub_gb [row] = '1'
                  CASE '12', '22'
                     IF MID(data, 9,1)='D'   Then
                           Object.ija_jigub_gb [row] = 'D'
                     ELSE
                        Object.ija_jigub_gb [row] = '4'
                     END IF
                  CASE '13', '21'
                     Object.ija_jigub_gb [row] = '7'
                  CASE '14', '23'
                     Object.ija_jigub_gb [row] = '9'

               END CHOOSE
               CHOOSE CASE dw_kap.object.kweonri_gb [1]
                  CASE '10', '11'
                     Object.bond_cd [row] = '5'
                  CASE '21', '22', '23'
                     Object.bond_cd [row] = '6'
                  CASE '31', '32'
                     Object.bond_cd [row] = '7'
                  CASE ELSE
                     CHOOSE CASE dw_kap.object.bojng_gb [1]
                        CASE '1', '2', '5'
                           Object.bond_cd [row] = '1'
                        CASE '3'
                           Object.bond_cd [row] = '3'
                        CASE '4'
                           Object.bond_cd [row] = '4'
                        CASE ELSE
                           Object.bond_cd [row] = '8'
                     END CHOOSE
               END CHOOSE
         END CHOOSE
         Object.balh_aek [row] = dw_kap.object.balh_aek [1]
         Object.balh_ymd [row] = f_to_date (dw_kap.object.balh_il [1], '')
         IF f_num (dw_kap.object.medo_il [1])=0 Then
            Object.medo_ymd [row] = Object.balh_ymd [row]
         ELSE
            Object.medo_ymd [row] = f_to_date (dw_kap.object.medo_il [1], '')
         END IF
         Object.sanghw_ymd [row] = f_to_date (dw_kap.object.sanghw_il [1], '')
         CHOOSE CASE dw_kap.object.bunhal_gb [1]
            CASE '1', '2', '3'
               Object.bunhal_gb [row] = '1'
            CASE ELSE
               Object.bunhal_gb [row] = '2'
         END CHOOSE
         Object.ydong_gb [row] = '2'
         CHOOSE CASE dw_kap.object.sangj_gb [1]
            CASE '1'
               Object.sangj_gb [row] = 'A'
            CASE ELSE
               Object.sangj_gb [row] = 'B'
         END CHOOSE
         CHOOSE CASE dw_kap.object.balh_type [1]
            CASE '001'
               Object.mojib_gb [row] = '2'
            CASE ELSE
               Object.mojib_gb [row] = '1'
         END CHOOSE

         Object.sunhu_gb [row] = dw_kap.object.sunhu_gb [1]
         ldt_balh_ymd          = Object.balh_ymd [row]
         ldt_sanghw_ymd        = Object.sanghw_ymd [row]
         SELECT TRUNC(months_between(:ldt_sanghw_ymd + 1, :ldt_balh_ymd) / 12 + .9)
           INTO :ija_yy_su
           FROM DUAL ;

         ija_yy_su = SQLCA.GETITEMNUMBER (1)

         Object.ija_yy_su [row]      = ija_yy_su
         Object.yy_ija_hoisu [row]   = 12 / f_num (dw_kap.object.ija_cal_mm [1])
         Object.tot_ija_hoicha [row] = f_num (Object.ija_yy_su [row]) * f_num (Object.yy_ija_hoisu [row])
         Object.com_pyom_iyul [row]  = dw_kap.object.pyom_per [1]
         Object.pyom_iyul [row]      = f_num (dw_kap.object.pyom_per [1]) / 100
         CHOOSE CASE dw_kap.object.sunme_ija_gb [1]
            CASE '1', '4'
               Object.sunme_ija_ymd [row] = Object.medo_ymd [row]
            CASE '2'
               Object.sunme_ija_ymd [row] = f_add_months (ldt_balh_ymd, f_num (dw_kap.object.ija_cal_mm [1]), null_dt)
            CASE '3'
               Object.sunme_ija_ymd [row] = Object.sanghw_ymd [row]
         END CHOOSE
         Object.bojng_cd [row]        = dw_kap.object.bojng_co [1]
         Object.balh_co [row]         = dw_kap.object.balh_co [1]
         Object.sanghw_ija_gb1 [row]  = dw_kap.object.sanghw_ija_gb1 [1]
         Object.sanghw_ija_gb2 [row]  = dw_kap.object.sanghw_ija_gb2 [1]
         Object.sanghw_aekm_gb1 [row] = dw_kap.object.sanghw_aekm_gb1 [1]
         Object.sanghw_aekm_gb2 [row] = dw_kap.object.sanghw_aekm_gb2 [1]
      END IF

      IF GETITEMSTATUS (ROW, 0, PRIMARY!)=NEWMODIFIED!   Then
         // 채권종목정보
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
           SELECT COMPANY                                                    /* _1- */
                , URL                                                        /* _2- */
                , HEADERS                                                    /* _3- */
                , '{ PDNO: "' || :data || '", PRDT_TYPE_CD: "302" }'         /* _4- */
                , TABLENAME                                                  /* _5- */
                , SUBTABLE                                                   /* _6- */
                , '0'                                                        /* _7- */
                , TO_CHAR(now (),'yyyymmdd') || '-' || RAWTOHEX(SYS_GUID())  /* _8- */
                , KEY_VALUE                                                  /* _9- */
                , SUB_KEY_VALUE                                              /* _10- */
                , :gaa.CORP_GR                                               /* _11- */
                , now ()                                                     /* _12- */
                , :data                                                      /* _13- */
             FROM API_PARAMS t1
            WHERE t1.GR_CD    = '20'
              AND t1.SCD      = '08'
              AND t1.TR_CO_CD = '00003'
              AND t1.COMPANY  = 'KB_REAL' ;
         commitJ ()
      END IF

   CASE 'balh_seq', 'ija_jigub_gb', 'balh_co', 'balh_ymd', 'jach_cd', 'bond_cd' // 국채,지방채,특수채,금융채,회사채
      IF DWO.NAME='bond_cd'   Then
         ls_bond_nm = f_dddw_find (THIS, 'bond_cd', "bond_cd='" + data + "'", 'bond_nm')
         IF iu_wpage.dw_c.object.dddw [1] <> '6'   Then
            Object.cj_nm [row]  = ls_bond_nm
            Object.cj_fnm [row] = ls_bond_nm
         END IF
         IF iu_wpage.dw_c.object.dddw [1]='3'   Then
            Object.balh_co [row] = data ; uf_setcodename (ROW, 'balh_co', gaa.CORP_GR)  // 통안채
            IF data='101' THEN Object.amt_unit [row]=1000000
         END IF
      END IF
      IF DWO.NAME='balh_co'   Then
         IF iu_wpage.dw_c.object.dddw [1]='6'   Then
            Object.cj_nm [row]  = Object.xx_balh_co [row]
            Object.cj_fnm [row] = Object.xx_balh_co [row]
         END IF
      END IF
      IF DWO.NAME='ija_jigub_gb' Then
         IF data='4' AND Object.yy_ija_hoisu [row]=0  Then  // 복리
            tot_ija_hoicha = 1
         ELSE
            tot_ija_hoicha = Object.ija_yy_su [row] * Object.yy_ija_hoisu [row]
         END IF
         IF tot_ija_hoicha >= 1  Then
            IF data>'3' THEN Object.tot_ija_hoicha [row]=tot_ija_hoicha &
              ELSE Object.tot_ija_hoicha [row] = 1
         END IF
         IF Match (data,'[0-3]') Then
            Object.halin_gb [row]       = '2'
            Object.com_halin_iyul [row] = null_dc
            Object.halin_iyul [row]     = null_dc
         END IF
      END IF

      IF DWO.NAME='balh_ymd'  Then
         Object.medo_ymd [row] = DATETIME (DATE (LEFT (data,10)))

         balh_yy   = DATE (LEFT (data,10))
         sanghw_yy = DATE (Object.sanghw_ymd [row])

         IF Day (sanghw_yy) <> Day (balh_yy) THEN F_MESSAGEBOX ("I000", "상환일과 발행일의 일자가 다릅니다.")

         ija_yy_su = (Year (sanghw_yy) - Year (balh_yy))
         IF Month (sanghw_yy)>Month (balh_yy)   Then
            ija_yy_su ++
         ELSEIF Month (sanghw_yy)=Month (balh_yy)  Then
            IF Day (sanghw_yy)>Day (balh_yy) THEN ija_yy_su ++
         END IF

         Object.ija_yy_su [row] = MAX (ija_yy_su, 1)
         IF Object.ija_jigub_gb [row]='4' AND Object.yy_ija_hoisu [row]=0  Then  // 복리
            tot_ija_hoicha = 1
         ELSE
            tot_ija_hoicha = Object.ija_yy_su [row] * Object.yy_ija_hoisu [row]
         END IF
         IF tot_ija_hoicha >= 1  Then
            IF Object.ija_jigub_gb [row]>'3' THEN Object.tot_ija_hoicha [row]=tot_ija_hoicha &
              ELSE Object.tot_ija_hoicha [row] = 1
         END IF
      END IF
   CASE "halin_gb"
      Object.com_halin_iyul [row] = null_dc
      Object.halin_iyul [row]     = null_dc

   CASE "com_pyom_iyul"
      Object.pyom_iyul [row] = dec (data) / 100.0
   CASE "com_halin_iyul"
      Object.halin_iyul [row] = dec (data) / 100.0
   CASE "com_halj_iyul"
      Object.halj_iyul [row] = dec (data) / 100.0
   CASE "com_mangi_iyul"
      Object.mangi_iyul [row] = dec (data) / 100.0

   CASE "cj_nm"
      Object.cj_fnm [row] = data

   CASE "bunhal_gb"
      IF data='1' Then
         OpenWithParm (w_ja990hs, THIS)
      ELSE
         jm_cd = Object.jm_cd [row]

         SELECT jm_cd
           INTO :bj_jm_cd
           FROM SCM0BJ t1
          WHERE t1.CORP_GR = :gaa.CORP_GR
            AND t1.jm_cd   = :jm_cd ;

         bj_jm_cd = SQLCA.GETITEMSTRING (1)

         IF SQLCA.sqlcode ()=0   Then
            IF F_MESSAGEBOX ('I002', '분할채자료가 존재합니다.~r~n자료를 삭제하시겠습니까?')=1  Then
               DELETE FROM SCM0BJ
                WHERE CORP_GR = :gaa.CORP_GR
                  AND jm_cd   = :jm_cd ;
            ELSE
               Object.bunhal_gb [row] = '1'
            END IF
         END IF
      END IF

   CASE 'yy_ija_hoisu'
      IF Object.ija_jigub_gb [row]='4' AND dec (data)=0  Then  // 복리
         tot_ija_hoicha = 1
      ELSE
         tot_ija_hoicha = Object.ija_yy_su [row] * dec (data)
      END IF
      IF tot_ija_hoicha >= 1  Then
         IF Object.ija_jigub_gb [row]>'3' THEN Object.tot_ija_hoicha [row]=tot_ija_hoicha &
           ELSE Object.tot_ija_hoicha [row] = 1
      END IF

   CASE 'sanghw_ymd' // 이자년수계산
      sanghw_yy = DATE (LEFT (data,10))
      balh_yy   = DATE (Object.balh_ymd [row])

      IF Day (sanghw_yy) <> Day (balh_yy) THEN F_MESSAGEBOX ('I000', '상환일과 발행일의 일자가 다릅니다.')

      ija_yy_su = (Year (sanghw_yy) - Year (balh_yy))
      IF Month (sanghw_yy)>Month (balh_yy)   Then
         ija_yy_su ++
      ELSEIF Month (sanghw_yy)=Month (balh_yy)  Then
         IF Day (sanghw_yy)>Day (balh_yy) THEN ija_yy_su ++
      END IF

      Object.ija_yy_su [row] = MAX (ija_yy_su, 1)
      tot_ija_hoicha         = Object.ija_yy_su [row] * Object.yy_ija_hoisu [row]
      IF tot_ija_hoicha >= 1  Then
         IF Object.ija_jigub_gb [row]>'3' THEN Object.tot_ija_hoicha [row]=tot_ija_hoicha &
           ELSE Object.tot_ija_hoicha [row] = 1
      END IF

   CASE "sanghw_ija_gb2"
      IF data='1' Then
         Object.com_sanghw_ija_iyul [row] = Object.com_pyom_iyul [row]
         Object.sanghw_ija_iyul [row]     = Object.pyom_iyul [row]
      END IF
   CASE "sanghw_aekm_gb2"
      IF data='1' Then
         Object.com_sanghw_aekm_iyul [row] = Object.com_pyom_iyul [row]
         Object.sanghw_aekm_iyul [row]     = Object.pyom_iyul [row]
      END IF
   CASE "com_sanghw_ija_iyul"
      Object.sanghw_ija_iyul [row] = dec (data) / 100.0
   CASE "com_sanghw_aekm_iyul"
      Object.sanghw_aekm_iyul [row] = dec (data) / 100.0

   CASE 'holi_ija_su'
      IF PosA ('78',Object.ija_jigub_gb [row])>0 AND ((Object.bond_attr [row]='1' OR PosA ('101,526',Object.bond_cd [row])>0))   Then
         F_MESSAGEBOX ('INFO', '휴일 이자수령 여부를 다시한번 확인 하십시오.')
      ELSE
         IF data='B' Then
            IF F_MESSAGEBOX ('INFO2','선수령 하지 않은 채권입니다.~r~n선수령으로 입력 하시겠습니까?')=2 THEN RETURN uf_itemerr (ROW, DWO.NAME, '')
         END IF
      END IF
END CHOOSE
end event

event dw_pagelist::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName()
   CASE 'balh_co'
      IF iu_wpage.dw_c.object.dddw [1]='3'   Then  rs_where = "length(balh_co)=3" &
      Else                                         rs_where = "length(balh_co)=5"
   CASE 'bojng_cd'
      rs_where = "used='1'"
   CASE 'jach_cd'
      rs_where = "jach_cd in ('001','004','005','007','003','006','008','044','002','033','022','055','066','077','088','099')"
END CHOOSE
RETURN 1
end event

event dw_pagelist::ue_insertstart;call super::ue_insertstart;STRING   ls_bond_cd, ls_bond_nm

uf_setColumn ('halin_gb'    , '2')
uf_setColumn ('sangj_gb'    , 'A')
uf_setColumn ('sunhu_gb'    , '2')
uf_setColumn ('yy_ija_hoisu', '12')
uf_setColumn ('bunhal_gb'   , '2')
uf_setColumn ('ydong_gb'    , '2')

uf_setColumn ('bond_attr'  , iu_wpage.dw_c.object.dddw [1])
uf_setColumn ('balh_ymd'   , STRING(iu_wpage.idt_workdate))
uf_setColumn ('JM_CRE_DT', STRING(iu_wpage.idt_workdate))
uf_setColumn ('medo_ymd'   , STRING(iu_wpage.idt_workdate))
uf_setColumn ('balh_ga'    , '10000')
uf_setColumn ('balh_co'    , '')
CHOOSE CASE iu_wpage.dw_c.object.dddw [1]
   CASE '1'  // 국채
      ls_bond_cd = '015'
   CASE '2'  // 지방채
      ls_bond_cd = '4'
      uf_setColumn ('jach_cd'   , '001')
      uf_setColumn ('xx_jach_cd', f_getCodename (SQLCA, 'jach_cd', 1, '001', gaa.CORP_GR))
   CASE '3'  // 특수채
      ls_bond_cd = '101'
      uf_setColumn ('balh_co'   , '101')
      uf_setColumn ('xx_balh_co', f_getCodename (SQLCA, 'balh_co', 1, '101', gaa.CORP_GR))
   CASE '6'  // 회사채
      ls_bond_cd = '4'
END CHOOSE
uf_setColumn ('bond_cd'     , ls_bond_cd)
uf_setColumn ('ija_jigub_gb', '1')
uf_setColumn ('holi_ija_su' , 'A')

IF iu_wpage.dw_c.object.dddw [1] <> '6'   Then
   ls_bond_nm = f_dddw_find (THIS, 'bond_cd', "bond_cd='" + ls_bond_cd + "'", 'bond_nm')
   uf_setColumn ("cj_nm", ls_bond_nm)
   uf_setColumn ("cj_fnm", ls_bond_nm)
END IF

uf_setColumn ('mojib_gb', '1')

POST SetColumn ('as_cj_cd')

RETURN 0
end event

event dw_pagelist::updateend;call super::updateend;LONG	ll

STRING	ls_cd

FOR  ll = 1  TO  rowsdeleted
   ls_cd = GETITEMSTRING (ll, 'jm_cd', Delete!, TRUE)

   DELETE FROM SCM0BJ
    WHERE CORP_GR = :gaa.CORP_GR
      AND jm_cd   = :ls_cd ;

   DELETE FROM SCJ0IG
    WHERE CORP_GR = :gaa.CORP_GR
      AND jm_cd   = :ls_cd ;
NEXT
end event

event dw_pagelist::itemfocuschanged;call super::itemfocuschanged;IF dwo.name='ija_jigub_gb'  Then
   DataWindowChild   ldwc

   IF PosA('13',Object.bond_attr [row])=0 Then
      GetChild ('ija_jigub_gb', ldwc)

      ldwc.SetDetailHeight (1, ldwc.rowcount (), long(ldwc.Describe("DataWindow.Detail.Height")))

      ldwc.SetFilter ("cd not in ('1','4','7','8','9')") ; ldwc.Filter ()
      ldwc.SetDetailHeight (1, ldwc.rowcount (), 0)

      ldwc.SetFilter ('') ; ldwc.Filter ()
   End IF
End IF
end event

event dw_pagelist::rowfocuschanged_if;call super::rowfocuschanged_if;dw_1.uf_reset ()
dw_1.EVENT ue_retrieve ()

dw_2.uf_reset ()
dw_2.EVENT ue_retrieve ()

RETURN 0
end event

event dw_pagelist::rowfocuschanging_return;call super::rowfocuschanging_return;IF dw_1.uf_update ()=FALSE THEN RETURN 1
RETURN 0
end event

event dw_pagelist::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
   CASE 'bf_ija_ymd','af_ija_ymd'
      Object.bf_ija_ymd [row] = dw_1.object.bf_ija_ymd [dw_1.getrow ()]
      Object.af_ija_ymd [row] = dw_1.object.af_ija_ymd [dw_1.getrow ()]
END CHOOSE
end event

event dw_pagelist::itemchanged_next;call super::itemchanged_next;STRING	ls_old, jm_cd, yy, m

IF GetItemStatus (row, 0, Primary!)=NewModified!   Then
   CHOOSE CASE name
      CASE 'balh_seq','ija_jigub_gb','balh_co','balh_ymd','jach_cd','bond_cd' //국채,지방채,특수채,금융채,회사채
         ls_old = Object.jm_cd [row]
         IF iu_wpage.dw_c.object.dddw [1]='1' And Object.ija_jigub_gb [row]='C'  Then
            jm_cd = "KRC"
         Else
            jm_cd = "KR" + iu_wpage.dw_c.object.dddw [1]   // 국가코드, 채권속성 SET
         End IF
         CHOOSE CASE iu_wpage.dw_c.object.dddw [1]
            CASE "1","3"   // 국채,특수채,금융채
               jm_cd = jm_cd + Object.bond_cd [row] + string (dec (Object.balh_seq [row]),'00')
               // 통화재,이자지급방법 SET
               IF (Object.bond_cd [row]='101') And (Object.ija_jigub_gb [row]='0') THEN jm_cd = jm_cd + '1' &
               Else                                                                      jm_cd = jm_cd + Object.ija_jigub_gb [row]
               yy = f_get_id_dae ('Y', string (Object.balh_ymd [row],'yyyy') )  // 발행년도 SET
               m  = f_get_id_dae ('M', string (Object.balh_ymd [row],'mm') ) // 발행월 SET

               Object.jm_cd [row] = jm_cd + yy + m
            CASE "2"  //지방채
               jm_cd = jm_cd + Object.jach_cd [row] + string (dec (Object.balh_seq [row]),'00') + Object.bond_cd [row]
               yy = f_get_id_dae ('Y', string (Object.balh_ymd [row],'yyyy') )  // 발행년도 SET
               m  = f_get_id_dae ('M', string (Object.balh_ymd [row],'mm') ) // 발행월 SET

               Object.jm_cd [row] = jm_cd + yy + m
            CASE "6"  //회사채
               jm_cd = jm_cd + Object.balh_co [row] + Object.balh_seq [row]
               yy = f_get_id_dae ('Y', string (Object.balh_ymd [row],'yyyy') )  // 발행년도 SET
               IF Object.ija_jigub_gb [row]='8' Then
                  m  = f_get_id_dae ('M2', string (Object.balh_ymd [row],'mm') ) // 발행월 SET
               Else
                  m  = f_get_id_dae ('M', string (Object.balh_ymd [row],'mm') ) // 발행월 SET
               End IF

               Object.jm_cd [row] = jm_cd + yy + m
         END CHOOSE
         Object.jm_cd [row] = f_jm_check (Object.jm_cd [row])
         IF f_null (Object.as_cj_cd [row]) OR Object.as_cj_cd [row]=ls_old THEN Object.as_cj_cd [row] = Object.jm_cd [row]
   END CHOOSE
End IF
end event

type dw_kap from u_dw within u_ja990h_t1
boolean visible = false
integer x = 5344
integer y = 256
integer height = 400
integer taborder = 22
boolean bringtotop = true
string dataobject = "d_ja990h_kap"
boolean border = false
boolean livescroll = true
end type

type cb_1 from pf_u_commandbutton within u_ja990h_t1
integer x = 2190
integer y = 24
integer width = 489
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "구간이자생성"
end type

event clicked;IF dw_1.rowcount ()=0 Then
   IF f_messageBox ('RUN', '구간이자 생성')=2 THEN RETURN
Else
   IF f_messageBox ('RUN', '구간이자 재생성(기존구간 삭제)')=2 THEN RETURN
End IF

STRING	ls_sr_err_msg, la_args[]

dw_1.reset ()

la_args[1] = gaa.corp_gr
la_args[2] = string (iu_wpage.idt_workdate, 'yyyy.mm.dd')
IF f_null (dw_pageList.object.jm_cd[dw_pageList.getrow ()]) Then
	SQLCA.singleconnection ()
   SQLCA.SP_CALL( THIS, 'SR_SCJ0IG ( ?, ? )', la_args[], ls_sr_err_msg )
Else
   la_args[3] = dw_pageList.object.jm_cd[dw_pageList.getrow ()]
	SQLCA.singleconnection ()
   SQLCA.SP_CALL( THIS, 'SR_SCJ0IG ( ?, ?, ? )', la_args[], ls_sr_err_msg )
End IF

dw_1.postevent ('ue_retrieve')
end event

type dw_1 from u_dw within u_ja990h_t1
integer x = 2190
integer y = 156
integer width = 2437
integer height = 1768
integer taborder = 22
boolean enabled = true
string dataobject = "d_scj0ig"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
boolean ibsetlist4subbtn = true
boolean eb_null_line = false
end type

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event ue_retrieve;call super::ue_retrieve;LONG	ll
ll = dw_pageList.getrow ()
f_dddwctl (THIS, 'com_ija_gb', gaa.corp_gr, '', 1, '')
retrieve (gaa.corp_gr, dw_pageList.object.jm_cd [ll], dw_pageList.object.now_gugan_no [ll])
end event

event ue_insertstart;call super::ue_insertstart;LONG	lR

lR = dw_pageList.getrow ()

uf_setcolumn ('jm_cd', dw_pageList.object.jm_cd [lR])
uf_setcolumn ('gugan_iyul', string (dw_pageList.object.pyom_iyul [lR]))
uf_setcolumn ('ija_gb', 'B')
uf_setcolumn ('com_ija_gb', '7')

RETURN 0
end event

event itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DateTime ldt, ldt_f_param1, ldt_f_param2

LONG	ll, lR, ll_dd, ll_f_value

lR = dw_pageList.getrow ()

CHOOSE CASE dwo.name
   CASE 'bf_ija_ymd'
		ldt_f_param1 = datetime(date(MID(data,1,10)))
		ldt_f_param2 = Object.af_ija_ymd[row]
		SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)

      Object.gugan_ilsu [row] = ll_f_value
   CASE 'af_ija_ymd'
      ldt = datetime (date (MID (data,1,10)))
		
		ldt_f_param1 = Object.bf_ija_ymd[row]
		SELECT F_DAYS( :ldt_f_param1, :ldt )
		  INTO :ll_f_value
		FROM   DUAL;
		ll_f_value = SQLCA.getitemnumber (1)

      Object.gugan_ilsu [row] = ll_f_value
      FOR  ll = row + 1  TO  rowcount ()
			
         Object.ip_user [ll] = 'ymd_com'
         Object.ip_ymd [ll] = f_sysdate ('')
         Object.bf_ija_ymd [ll] = ldt
         ldt = f_add_months (ldt, 12 / dw_pageList.object.yy_ija_hoisu [lR], null_dt)
			
			ldt_f_param1 = Object.bf_ija_ymd[ll]
			SELECT F_DAYS( :ldt_f_param1, :ldt )
			  INTO :ll_f_value
			FROM   DUAL;
			ll_f_value = SQLCA.getitemnumber (1)

         ll_dd = ll_f_value
         IF ldt>dw_pageList.object.sanghw_ymd [lR] Then
            Object.af_ija_ymd [ll] = dw_pageList.object.sanghw_ymd [lR]
				
				ldt_f_param1 = Object.bf_ija_ymd[ll]
				ldt_f_param2 = Object.af_ija_ymd[ll]
				SELECT F_DAYS( :ldt_f_param1, :ldt_f_param2 )
				  INTO :ll_f_value
				FROM   DUAL;
				ll_f_value = SQLCA.getitemnumber (1)

            Object.gugan_ilsu [ll] = ll_f_value
            IF ll>1 THEN Object.gugan_ija [ll] = Object.gugan_ija [ll - 1] / ll_dd * Object.gugan_ilsu [ll];
            EXIT
         Else
            Object.af_ija_ymd [ll] = ldt
         End IF
         Object.gugan_ilsu [ll] = ll_dd
      NEXT
END CHOOSE

object.ip_user [row] = gnv_vari.is_user_id
Object.ip_ymd [row] = f_sysdate ('')
end event

event ue_insert;call super::ue_insert;LONG	ll

FOR  ll = 1  TO  rowcount ()
   Object.gugan_no [ll] = ll
NEXT

RETURN   AncestorReturnVALUE
end event

event doubleclicked;CHOOSE CASE dwo.name
   CASE 'gugan_ilsu_t'
      LONG	ll
      FOR  ll = 1  TO  rowcount ()
         Object.gugan_ija [ll] = dw_pageList.object.pyom_iyul [dw_pageList.getrow ()] / 365 * Object.gugan_ilsu [ll]
      NEXT
      RETURN
   CASE 'gugan_ilsu'
      Object.gugan_ija [row] = dw_pageList.object.pyom_iyul [dw_pageList.getrow ()] / 365 * Object.gugan_ilsu [row]
      RETURN
END CHOOSE
CALL super::doubleclicked
end event

type dw_2 from u_dw within u_ja990h_t1
integer x = 2190
integer y = 2032
integer width = 2039
integer height = 808
integer taborder = 32
boolean bringtotop = true
string dataobject = "d_danga"
end type

event ue_retrieve;call super::ue_retrieve;LONG	ll_aekm, ll_aek, ll_danga

STRING	ls_ldt

ll_aekm = 100000000
ll_aek = 100000000
ll_danga = 10000
ls_ldt = string (iu_wpage.idt_workdate,'yyyymmdd')

uf_setcolumn ('aekm', string (ll_aekm))
uf_setcolumn ('aek', string (ll_aek))
uf_setcolumn ('s_danga', string (ll_danga))

retrieve (gaa.corp_gr, ls_ldt, dw_pagelist.object.jm_cd [tRow], ll_aekm, ll_danga, ll_aek)
end event

event itemchanged_next;call super::itemchanged_next;uf_setcolumn ('aekm', string (Object.aekm [1]))
uf_setcolumn ('aek', string (Object.aek [1]))
uf_setcolumn ('s_danga', string (Object.s_danga [1]))

retrieve (gaa.corp_gr, string (Object.d0 [1], 'yyyymmdd'), dw_pagelist.object.jm_cd [tRow], Object.aekm [1], Object.s_danga [1], Object.aek [1])
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

