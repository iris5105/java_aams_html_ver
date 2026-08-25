forward
global type w_ja021e from wt_listdetail
end type
end forward

global type w_ja021e from wt_listdetail
end type
global w_ja021e w_ja021e

type variables
LONG	max_seq_no
DEC	idc_jonga
end variables

on w_ja021e.create
int iCurrent
call super::create
end on

on w_ja021e.destroy
call super::destroy
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.tr_ymd [1] = idt_workdate
end event

event wue_retrieve;call super::wue_retrieve;IF dw_list.retrieve (f_nvl (dw_c.object.cj_cd [1],'%'))=0 Then
   dw_list.insertrow (0)
End IF
dw_detail.POST EVENT ue_retrieve ()
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja021e
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja021e
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja021e
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja021e
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja021e
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja021e
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja021e
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja021e
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja021e
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja021e
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja021e
end type

type uo_navi from wt_listdetail`uo_navi within w_ja021e
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja021e
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja021e
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja021e
end type

type p_close from wt_listdetail`p_close within w_ja021e
end type

type p_excel from wt_listdetail`p_excel within w_ja021e
end type

type p_print from wt_listdetail`p_print within w_ja021e
end type

type p_delete from wt_listdetail`p_delete within w_ja021e
end type

type p_update from wt_listdetail`p_update within w_ja021e
end type

type p_input from wt_listdetail`p_input within w_ja021e
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja021e
end type

type p_clear from wt_listdetail`p_clear within w_ja021e
end type

type p_copy from wt_listdetail`p_copy within w_ja021e
end type

type dw_c from wt_listdetail`dw_c within w_ja021e
string dataobject = "d_ja021e"
end type

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'dddw'
      Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='"+data+"'")

      SetItem (1, "cj_cd", '')
      SetItem (1, "xx_cj_cd", '')
      SetItem (1, "koscom_cd", '')
      SetItem (1, "xx_koscom_cd", '')
   CASE 'koscom_cd'
      SELECT  close
        INTO  :idc_jonga
      FROM    sjt1tg t1
      WHERE   t1.ymd       = f_trade_ymd(:idt_workdate - 1, '-')
        AND   t1.koscom_cd = :data;
		  idc_jonga = SQLCA.getitemnumber (1)
		
      IF SQLCA.sqlcode ()<>0 THEN idc_jonga = 0
END CHOOSE
end event

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA021E'")
Object.ija_baedang_gb [1] = F_DDDWCTL (THIS, 'ija_baedang_gb', gaa.corp_gr, '', 1, '')
Object.danc_gb [1] = F_DDDWCTL (THIS, 'danc_gb', gaa.corp_gr, '', 1, "szx0gd.tr_cd='"+Object.dddw[1]+"'")
end event

event dw_c::ue_setcodesearch;call super::ue_setcodesearch;CHOOSE CASE GetColumnName ()
      CASE 'koscom_cd'
         IF Object.dddw [1]='F55' Then
            rs_where = "danc_gb='" + Object.danc_gb [1] + "'"
         Else
            rs_where = "danc_gb='" + Object.danc_gb [1] + "' and balh_co in (select balh_co from scm0cj where corp_gr='" + gaa.corp_gr + "' and bond_attr='6')"
         End IF
      CASE 'cj_cd'
         rs_where = "t1.bond_attr='6' and t1.bond_cd in ('7','S','T','5','6','N','P')"
END CHOOSE
RETURN 1
end event

event dw_c::ue_valid;call super::ue_valid;ib_managedata = (Object.tr_ymd [1]>=idt_workdate And f_notnull (Object.cj_cd [1]))
RETURN TRUE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

STRING	ls_tr_cd

ls_tr_cd = Object.dddw [1]

SELECT  1
  INTO  :li_ret
FROM    sct0cg t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :rs_ymd
  AND   t1.tr_cd   = :ls_tr_cd
  AND   ROWNUM = 1;
  li_ret = SQLCA.getitemnumber (1)

RETURN  li_ret
end event

type btn_update from wt_listdetail`btn_update within w_ja021e
end type

type st_count from wt_listdetail`st_count within w_ja021e
end type

type dw_list from wt_listdetail`dw_list within w_ja021e
integer height = 168
string dataobject = "d_ja021e1"
boolean hscrollbar = false
boolean vscrollbar = false
boolean ibsetlist4singleselect = false
boolean eb_new_false = true
boolean eb_copy_false = true
boolean eb_delete_false = true
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'chg_stock_gb', gaa.corp_gr, '', 1, '')
end event

event dw_list::rowfocuschanging_return;RETURN 0
end event

event dw_list::rowfocuschanged_if;iRow = currentrow
RETURN 0
end event

type dw_detail from wt_listdetail`dw_detail within w_ja021e
integer y = 540
integer height = 2224
string dataobject = "d_ja021e2"
boolean eb_new_false = true
boolean eb_copy_false = true
end type

event dw_detail::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
	CASE 'aekm'
		IF dec(data)>Object.com_aekm [row] * 10000 Then
			RETURN uf_itemerr (row, 'aekm', '행사액면이 보유액면을 초과합니다.')
		End IF
		IF f_num (dw_list.object.chg_ga [1])<>0 Then
			Object.jusic_jusu [row] = truncate(dec (data) / dw_list.object.chg_ga [1], 0)
			Object.jusic_aek [row] = Object.jusic_jusu [row] * idc_jonga
			Object.jusic_danga [row] = idc_jonga
		End IF
	CASE 'sury_chk'
		IF	data='1'	Then
			Object.sury_ymd [row] = f_sysdate ('dd')
		Else
			Object.sury_ymd [row] = null_dt
		End IF
END CHOOSE
end event

event dw_detail::ue_retrieve;IF f_null (dw_c.object.cj_cd [1])   Then
   retrieve (gaa.CORP_GR, dw_c.object.tr_ymd [1], dw_c.object.dddw [1], '%')
   RETURN
END IF

LONG	ll = 0, ll_cnt

ll_cnt = retrieve (gaa.CORP_GR, dw_c.object.tr_ymd [1], dw_c.object.dddw [1], dw_c.object.cj_cd [1])
IF ll_cnt = 0  Then
   DATETIME	ldt_tr_ymd, ldt_sury_ymd

   STRING	ls_cj_cd, fund_cd, xx_fund_cd, ls_sutak_cd, ls_sqlsyntax, ls_chk

   DEC	aekm, aek, ll_aek, ll_protect

   LONG	lR, lj
   
   aDS_jTier   lds_jtier

   ldt_tr_ymd = dw_c.object.tr_ymd [1]
   ls_cj_cd   = dw_c.object.cj_cd [1]

   ls_sqlsyntax = " WITH with_cg AS ( " + &
                  "      SELECT DISTINCT t1.fund_cd " + &
                  "           , t1.jm_cd " + &
                  "           , t1.aek " + &
                  "           , t1.jan_aek " + &
                  "           , t1.sanghw_ymd " + &
                  "           , t1.tr_co_cd " + &
                  "           , t2.sanghw_aek " + &
                  "           , COUNT(*) OVER (PARTITION BY t1.corp_gr " + &
                  "                                       ,t1.tr_ymd " + &
                  "                                       ,t1.tr_cd " + &
                  "                                       ,t1.fund_cd " + &
                  "                                       ,t1.jm_cd " + &
                  "                                       ,t1.seq_no)  AS cnt " + &
                  "        FROM SCT1CG t1 " + &
                  "        LEFT OUTER JOIN sct1cg_tr t2  ON t2.corp_gr    = t1.corp_gr " + &
                  "                                     AND t2.tr_ymd     = t1.tr_ymd " + &
                  "                                     AND t2.tr_cd      = t1.tr_cd " + &
                  "                                     AND t2.fund_cd    = t1.fund_cd " + &
                  "                                     AND t2.jm_cd      = t1.jm_cd " + &
                  "                                     AND t2.buy_date   = t1.buy_date " + &
                  "                                     AND t2.aek_gb     = t1.aek_gb " + &
                  "                                     AND t2.seq_no     = t1.seq_no " + &
                  "                                     AND t2.sanghw_aek > 0 " + &
                  "       WHERE t1.corp_gr = '" + gaa.CORP_GR + "' " + &
                  "         AND t1.gwamok  = '12049' " + &
                  "         AND t1.aek_gb  = '3' " + &
                  "         AND t1.tr_ymd  = '" + string (ldt_tr_ymd, 'yyyy.mm.dd') + "' " + &
                  "   ) " + &
                  "   SELECT t2.fund_cd " + &
                  "        , t2.fund_nm " + &
                  "        , t2.mg_cd " + &
                  "        , NVL(t1.bfil_aekm,0) + NVL(t1.meib_aekm,0) - NVL(t1.medo_aekm,0) " + &
                  "        , NVL(t1.bfil_chui_aek,0) + NVL(t1.meib_aek,0) - NVL(t1.medo_aek,0) " + &
                  "        , CASE WHEN t3.sanghw_ymd IS NOT NULL THEN '1' " + &
                  "                                              ELSE '0' END " + &
                  "        , t3.sanghw_ymd " + &
                  "        , t3.aek " + &
                  "        , CASE WHEN t3.sanghw_ymd < t1.ymd THEN 1 " + &
                  "               WHEN t3.cnt > 1             THEN 1 " + &
                  "                                           ELSE 0 END " + &
                  "     FROM SCM0CM t1 " + &
                  "     LEFT OUTER JOIN with_cg t3  ON t3.fund_cd = t1.fund_cd " + &
                  "                                AND t3.jm_cd   = t1.jm_cd " + &
                  "        , SZM0IA t2 " + &
                  "    WHERE t1.corp_gr = '" + gaa.CORP_GR + "' " + &
                  "      AND t1.jm_cd   = '" + ls_cj_cd + "' " + &
                  "      AND t1.ymd     = '" + string (ldt_tr_ymd, 'yyyy.mm.dd') + "' " + &
                  "      AND t2.corp_gr = t1.corp_gr " + &
                  "      AND t2.fund_cd = t1.fund_cd " + &
                  "    ORDER BY t2.fund_cd "

   lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')

   FOR  lj = 1  TO  lR
      fund_cd      = lds_jtier.GETITEMSTRING (lj, 1)
      xx_fund_cd   = lds_jtier.GETITEMSTRING (lj, 2)
      ls_sutak_cd  = lds_jtier.GETITEMSTRING (lj, 3)
      aekm         = lds_jtier.GETITEMNUMBER (lj, 4)
      aek          = lds_jtier.GETITEMNUMBER (lj, 5)
      ls_chk       = lds_jtier.GETITEMSTRING (lj, 6)
      ldt_sury_ymd = lds_jtier.getitemdatetime (lj,7)
      ll_aek       = lds_jtier.GETITEMNUMBER (lj, 8)
      ll_protect   = lds_jtier.GETITEMNUMBER (lj, 9)

      ll = insertrow (0)

      Object.CORP_GR [ll]      = gaa.CORP_GR
      Object.p_visible [ll]    = 1
      Object.sury_chk [ll]     = ls_chk
      Object.sury_ymd [ll]     = ldt_sury_ymd
      Object.aek [ll]          = ll_aek
      Object.sury_protect [ll] = ll_protect
      Object.tr_ymd [ll]       = dw_c.object.tr_ymd [1]
      Object.tr_cd [ll]        = dw_c.object.dddw [1]
      Object.jm_cd [ll]        = dw_c.object.cj_cd [1]
      Object.buy_date [ll]     = '%'
      Object.tr_co_cd [ll]     = ls_sutak_cd
      Object.koscom_cd [ll]    = dw_c.object.koscom_cd [1]
      Object.ija_baed_gb [ll]  = dw_c.object.ija_baedang_gb [1]
      Object.danc_gb [ll]      = dw_c.object.danc_gb [1]
      Object.danga [ll]        = dec (dw_list.object.chg_ga [1])
      Object.fund_cd [ll]      = fund_cd
      Object.xx_fund_cd [ll]   = xx_fund_cd
      Object.com_aekm [ll]     = aekm / 10000
      Object.chg_jm_cd [ll]    = dw_c.object.xx_jm_cd [1]
      IF f_num (dw_list.object.chg_ga [1]) <> 0 Then
         Object.jusic_jusu [ll]  = truncate (aek / dw_list.object.chg_ga [1],0)
         Object.jusic_aek [ll]   = Object.jusic_jusu [ll] * dw_list.object.chg_ga [1]
         Object.jusic_danga [ll] = aek - Object.jusic_aek [ll]
      ELSE
         Object.jusic_aek [ll] = aek
      END IF
      setitemstatus (ll, 0, PRIMARY!, notmodified!)
   NEXT
   
   IF ll = 0   Then
      F_MESSAGEBOX ('U000', '자료가 없습니다.')
      rollbackJ ()
      RETURN
   END IF
ELSE
   max_seq_no = 0
   FOR  ll = 1  TO  ll_cnt
      max_seq_no = MAX (f_num (Object.seq_no [ll]), max_seq_no)
   NEXT
END IF
end event

event dw_detail::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, ls_aekm

FOR  lRow = 1  TO  rowcount ()
   ls_aekm = this.GetItemNumber(lRow, "aekm")
   IF ls_aekm=0 or f_null(ls_aekm)  Then
      f_messagebox('ERR','행사액면을 확인하세요.')
      RETURN
   End IF
   IF GetItemStatus (lRow, 0, Primary!)=NewModified!  Then
         max_seq_no ++
         Object.seq_no [lRow] = max_seq_no
   End IF
NEXT
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;uf_setColumn ('tr_ymd', string(dw_c.object.tr_ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('jm_cd', dw_c.object.cj_cd [1])
uf_setColumn ('buy_date', string (dw_c.object.tr_ymd [1],'yyyymmdd'))
uf_setColumn ('koscom_cd', dw_c.object.koscom_cd [1])
uf_setColumn ('ija_baed_gb', dw_c.object.ija_baedang_gb [1])
uf_setColumn ('danc_gb', dw_c.object.danc_gb [1])
uf_setColumn ('danga', string(dw_list.object.chg_ga [1]))
uf_setColumn ('lock_end', string(dw_list.object.lock_end [1]))

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_detail::updateend;call super::updateend;STRING	ls_corp_gr, ls_tr_cd, ls_fund_cd, ls_buy_date, ls_aek_gb, ls_jm_cd, la_type[], ls_exist

DATETIME ldt_tr_ymd, ldt_sanghw_ymd

LONG	ll_seq_no, ll_aek, ll, lm

FOR  ll = 1  TO  rowsdeleted
   //삭제
   ls_corp_gr = getitemstring (ll, 'corp_gr', delete!, TRUE)
   ldt_tr_ymd = getitemdatetime (ll, 'tr_ymd', delete!, TRUE)
   ls_tr_cd   = getitemstring (ll, 'tr_cd', delete!, TRUE)
   ls_fund_cd = getitemstring (ll, 'fund_cd', delete!, TRUE)
   ls_jm_cd   = getitemstring (ll, 'jm_cd', delete!, TRUE)

   DELETE FROM SCT1CG t1
    WHERE t1.corp_gr = :ls_corp_gr
      AND t1.tr_ymd  = :ldt_tr_ymd
      AND t1.tr_cd   = :ls_tr_cd
      AND t1.fund_cd = :ls_fund_cd
      AND t1.jm_cd   = :ls_jm_cd
      AND t1.aek_gb  = '3'
      AND t1.gwamok  = '12049';

   DELETE FROM SCT1CG_TR t1
    WHERE t1.corp_gr = :ls_corp_gr
      AND t1.tr_ymd  = :ldt_tr_ymd
      AND t1.tr_cd   = :ls_tr_cd
      AND t1.fund_cd = :ls_fund_cd
      AND t1.jm_cd   = :ls_jm_cd
      AND t1.aek_gb  = '3';

NEXT


FOR  ll = 1  TO  rowcount ()
   IF getitemstatus (ll, 'aek', primary!)=DataModified!      OR &
      getitemstatus (ll, 'aek', primary!)=NewModified!       OR &
      getitemstatus (ll, 'sury_ymd', primary!)=DataModified! OR &
      getitemstatus (ll, 'sury_ymd', primary!)=NewModified! THEN

      ls_corp_gr = gaa.corp_gr
      ldt_tr_ymd = dw_c.object.tr_ymd [1]
      ls_tr_cd = dw_c.object.dddw [1]
      ls_fund_cd = Object.fund_cd [ll]
      ll_aek    = Object.aek [ll]
      ldt_sanghw_ymd = Object.sury_ymd [ll]
      ls_jm_cd = dw_c.Object.cj_cd [1]
      ll_seq_no = Object.seq_no [ll]
      la_type[1] = 'N'
      la_type[2] = 'N'

      SELECT t1.buy_date
           , t1.aek_gb
           , t1.seq_no
           , '1'
        INTO :ls_buy_date
           , :ls_aek_gb
           , :ll_seq_no
           , :ls_exist
        FROM SCT1CG t1
       WHERE t1.corp_gr = :ls_corp_gr
         AND t1.tr_ymd  = :ldt_tr_ymd
         AND t1.tr_cd   = :ls_tr_cd
         AND t1.fund_cd = :ls_fund_cd
         AND t1.gwamok  = '12049'
         AND t1.jm_cd   = :ls_jm_cd
         AND t1.aek_gb  = '3';

      IF SQLCA.sqlcode()=0 THEN
         ls_buy_date = SQLCA.getitemstring (1)
         ls_aek_gb   = SQLCA.getitemstring (2)
         ll_seq_no   = SQLCA.getitemnumber (3)
         ls_exist    = SQLCA.getitemstring (4)
      ELSE
         ll_seq_no = 1
         ls_exist = '0'
         ls_buy_date = '%'
      End IF

      IF getitemstatus (ll, 'aek', primary!)=DataModified! OR getitemstatus (ll, 'aek', primary!)=NewModified! THEN
         IF F_NUM (ll_aek)=0 THEN
            DELETE FROM SCT1CG t1
             WHERE t1.corp_gr = :ls_corp_gr
               AND t1.tr_ymd  = :ldt_tr_ymd
               AND t1.tr_cd   = :ls_tr_cd
               AND t1.fund_cd = :ls_fund_cd
               AND t1.jm_cd   = :ls_jm_cd
               AND t1.aek_gb  = '3'
               AND t1.gwamok  = '12049';

            DELETE FROM SCT1CG_TR t1
             WHERE t1.corp_gr = :ls_corp_gr
               AND t1.tr_ymd  = :ldt_tr_ymd
               AND t1.tr_cd   = :ls_tr_cd
               AND t1.fund_cd = :ls_fund_cd
               AND t1.jm_cd   = :ls_jm_cd
               AND t1.aek_gb  = '3';

            Object.sury_ymd [ll] = null_dt
            Object.sury_chk [ll] = '0'
            CONTINUE
         End IF

         IF SQLCA.sqlcode()=0 THEN la_type[1] = iif(F_NOTNULL (ldt_sanghw_ymd), 'U', 'C') ELSE la_type[1] = 'I'
      End IF

      IF getitemstatus (ll, 'sury_ymd', primary!)=DataModified! OR getitemstatus (ll, 'sury_ymd', primary!)=NewModified! THEN
         IF F_NOTNULL (ldt_sanghw_ymd) And F_NUM (ll_aek)=0 THEN
            F_MESSAGEBOX ('ERR', STRING (ll) + '행 단주대금이 입력되지 않았습니다.~r~n단주대금을 먼저 입력해주십시오.')
            Object.sury_ymd [ll] = null_dt
            Object.sury_chk [ll] = '0'
            RETURN
         End IF

         IF F_NOTNULL (ldt_sanghw_ymd) THEN la_type[2] = 'U' ELSE la_type[2] = 'C'
         IF la_type [2]=la_type [1] THEN la_type [2] = 'N'
      End IF

      SELECT '1'
        INTO :ls_exist
        FROM SCT1CG_TR t1
       WHERE t1.corp_gr  = :ls_corp_gr
         AND t1.tr_ymd   = :ldt_tr_ymd
         AND t1.tr_cd    = :ls_tr_cd
         AND t1.fund_cd  = :ls_fund_cd
         AND t1.jm_cd    = :ls_jm_cd
         AND t1.buy_date = :ls_buy_date
         AND t1.aek_gb   = '3'
         AND t1.seq_no   = :ll_seq_no;

      IF SQLCA.sqlcode()<>0 And F_NUM (ll_aek)>0 THEN
         INSERT  INTO SCT1CG_TR
             ( corp_gr     /* _1- */
             , tr_ymd      /* _2- */
             , tr_cd       /* _3- */
             , seq_no      /* _4- */
             , buy_date    /* _5- */
             , fund_cd     /* _6- */
             , jm_cd       /* _7- */
             , aek_gb      /* _8- */
             , sanghw_aek  /* _9- */
             , sanghw_ymd  /* _10- */
             )
         VALUES ( :ls_corp_gr   /* _1- */
                , :ldt_tr_ymd   /* _2- */
                , :ls_tr_cd     /* _3- */
                , :ll_seq_no    /* _4- */
                , :ls_buy_date  /* _5- */
                , :ls_fund_cd   /* _6- */
                , :ls_jm_cd     /* _7- */
                , '3'           /* _8- */
                , 0             /* _9- */
                , :ldt_tr_ymd   /* _10- */
                );
      End IF

      //tr처리
      FOR lm=1 TO 2
         commitJ ()
         IF la_type[lm]<>'N' THEN
            CHOOSE CASE la_type[lm]
               CASE 'I' //신규입력
                  INSERT  INTO SCT1CG
                      ( corp_gr   /* _1- */
                      , tr_ymd    /* _2- */
                      , tr_cd     /* _3- */
                      , seq_no    /* _4- */
                      , buy_date  /* _5- */
                      , gwamok    /* _6- */
                      , fund_cd   /* _7- */
                      , jm_cd     /* _8- */
                      , aek_gb    /* _9- */
                      , aek       /* _10- */
                      , jan_aek   /* _11- */
                      )
                  VALUES ( :ls_corp_gr  /* _1- */
                         , :ldt_tr_ymd  /* _2- */
                         , :ls_tr_cd    /* _3- */
                         , :ll_seq_no   /* _4- */
                         , '%'          /* _5- */
                         , '12049'      /* _6- */
                         , :ls_fund_cd  /* _7- */
                         , :ls_jm_cd    /* _8- */
                         , '3'          /* _9- */
                         , :ll_aek      /* _10- */
                         , :ll_aek      /* _11- */
                         );
               CASE 'U' //전부수령
                  UPDATE SCT1CG t1
                     SET t1.sanghw_ymd = :ldt_sanghw_ymd
                       , t1.aek        = :ll_aek
                       , t1.jan_aek    = 0
                   WHERE t1.corp_gr = :ls_corp_gr
                     AND t1.tr_ymd  = :ldt_tr_ymd
                     AND t1.tr_cd   = :ls_tr_cd
                     AND t1.fund_cd = :ls_fund_cd
                     AND t1.jm_cd   = :ls_jm_cd
                     AND t1.aek_gb  = '3'
                     AND t1.gwamok  = '12049';

                  UPDATE SCT1CG_TR t1
                     SET t1.sanghw_ymd  = :ldt_sanghw_ymd
                       , t1.sanghw_aek  = :ll_aek
                       , t1.bigo        = '전액상환'
                   WHERE t1.corp_gr  = :ls_corp_gr
                     AND t1.tr_ymd   = :ldt_tr_ymd
                     AND t1.tr_cd    = :ls_tr_cd
                     AND t1.fund_cd  = :ls_fund_cd
                     AND t1.jm_cd    = :ls_jm_cd
                     AND t1.buy_date = :ls_buy_date
                     AND t1.aek_gb   = '3'
                     AND t1.seq_no   = :ll_seq_no;
               CASE 'C' //초기화
                  UPDATE SCT1CG t1
                     SET t1.sanghw_ymd = NULL
                       , t1.jan_aek    = :ll_aek
                       , t1.aek        = :ll_aek
                   WHERE t1.corp_gr = :ls_corp_gr
                     AND t1.tr_ymd  = :ldt_tr_ymd
                     AND t1.tr_cd   = :ls_tr_cd
                     AND t1.fund_cd = :ls_fund_cd
                     AND t1.jm_cd   = :ls_jm_cd
                     AND t1.aek_gb  = '3'
                     AND t1.gwamok  = '12049';

                  UPDATE SCT1CG_TR t1
                     SET t1.sanghw_ymd  = :ldt_tr_ymd
                       , t1.sanghw_aek  = 0
                       , t1.bigo        = NULL
                   WHERE t1.corp_gr  = :ls_corp_gr
                     AND t1.tr_ymd   = :ldt_tr_ymd
                     AND t1.tr_cd    = :ls_tr_cd
                     AND t1.fund_cd  = :ls_fund_cd
                     AND t1.jm_cd    = :ls_jm_cd
                     AND t1.buy_date = :ls_buy_date
                     AND t1.aek_gb   = '3'
                     AND t1.seq_no   = :ll_seq_no;
            END CHOOSE
         End IF
      NEXT
   End IF
NEXT

commitJ ()
end event

type st_move from wt_listdetail`st_move within w_ja021e
integer y = 520
end type

