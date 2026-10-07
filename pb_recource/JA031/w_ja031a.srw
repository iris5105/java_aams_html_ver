forward
global type w_ja031a from wt_list
end type
type cb_other from pf_u_commandbutton within w_ja031a
end type
end forward

global type w_ja031a from wt_list
string is_init_value = "S10"
cb_other cb_other
end type
global w_ja031a w_ja031a

on w_ja031a.create
int iCurrent
call super::create
this.cb_other=create cb_other
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_other
end on

on w_ja031a.destroy
call super::destroy
destroy(this.cb_other)
end on

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
dw_c.object.dddw [1] = ia_value [1]
end event

event wue_retrieve;call super::wue_retrieve;ia_value [1] = dw_c.object.dddw [1]
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1], ia_value [1])
end event

event wue_clear;call super::wue_clear;IF idt_workdate=dw_c.object.ymd [1]  Then
   cb_other.of_setenabled(TRUE)
End IF
end event

type lb_dirlist from wt_list`lb_dirlist within w_ja031a
end type

type ln_templeft from wt_list`ln_templeft within w_ja031a
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_ja031a
end type

type ln_temptop from wt_list`ln_temptop within w_ja031a
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_ja031a
end type

type ln_tempstart from wt_list`ln_tempstart within w_ja031a
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_ja031a
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_ja031a
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_ja031a
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_ja031a
end type

type ln_tempright from wt_list`ln_tempright within w_ja031a
end type

type uo_navi from wt_list`uo_navi within w_ja031a
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_ja031a
end type

type st_windelaytime from wt_list`st_windelaytime within w_ja031a
end type

type st_top_rect from wt_list`st_top_rect within w_ja031a
end type

type p_close from wt_list`p_close within w_ja031a
end type

type p_excel from wt_list`p_excel within w_ja031a
end type

type p_print from wt_list`p_print within w_ja031a
end type

type p_delete from wt_list`p_delete within w_ja031a
end type

type p_update from wt_list`p_update within w_ja031a
end type

type p_input from wt_list`p_input within w_ja031a
end type

type p_retrieve from wt_list`p_retrieve within w_ja031a
end type

type p_clear from wt_list`p_clear within w_ja031a
end type

type p_copy from wt_list`p_copy within w_ja031a
end type

type dw_c from wt_list`dw_c within w_ja031a
string title = "영업일자@매매구분"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031A'")
end event

event dw_c::ue_valid;call super::ue_valid;cb_other.of_setenabled(FALSE)

RETURN TRUE
end event

event dw_c::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

CHOOSE CASE dwo.name
   CASE 'ymd'
      IF datetime (date (mida (data,1,10)))>=idt_workdate OR gaa.aams Then
         ib_manageData = TRUE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031A'")
      Else
         ib_manageData = FALSE
         Object.dddw [1] = F_DDDWCTL (THIS, 'dddw', gaa.corp_gr, '', 1, "szx1pt.obj_id='W_JA031A' and szx0gc.tr_cd in (select tr_cd from sst1kt where corp_gr=':corp_gr' and tr_ymd='"+MidA (data, 1, 10)+"')")
      End IF
      cb_other.of_setenabled(ib_manageData)
END CHOOSE
end event

event dw_c::ue_getdate;call super::ue_getdate;INT   li_ret = 0

SELECT  1
  INTO  :li_ret
FROM    sst1kt t1
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t1.tr_ymd  = :rs_ymd
  AND   t1.tr_cd   IN ( select tr_cd
                          from szx1pt ta
                        where  ta.obj_id = 'W_JA031A' )
  AND   ROWNUM = 1;

li_ret = SQLCA.getitemnumber (1)

RETURN   li_ret
end event

type btn_update from wt_list`btn_update within w_ja031a
end type

type st_count from wt_list`st_count within w_ja031a
end type

type dw_list from wt_list`dw_list within w_ja031a
event ue_load ( )
string dataobject = "d_ja031a1"
end type

event dw_list::ue_load;LONG	lRow, li_num, lseq_no = 0

STRING	ls_path, ls_file, ls_rec, ls_date
STRING	tr_cd, fund_cd, sj_cd, tr_su, tr_jisu, tr_co_cd, susu_tr_co_cd

// Set a wait cursor
SetPointer (HourGlass!)

ls_path = profilestring (gaa.config, "DIR value", parent.classname() + 'dir', gnv_vari.basepath)
IF GetFileOpenName ('UP Load File', ls_path, ls_file, "TXT", " TEXT Files (*.TXT),*.TXT, ALL Files (*.*),*.*", ls_path, 2) <> 1 THEN RETURN
SetProfileString (gaa.config, "DIR value", parent.classname() + 'dir', f_replace (ls_path, ls_file, ''))

Reset ()

li_num = FileOpen (ls_path, LineMode!, Read!, Shared!)

DO UNTIL FileReadEx (li_num, ls_rec)= -100
   f_MicroHelp (ls_rec)

   ls_date       = f_get_token (ls_rec, '~t')
   tr_cd         = f_get_token (ls_rec, '~t')
   fund_cd       = f_get_token (ls_rec, '~t')
   sj_cd         = f_get_token (ls_rec, '~t')
   tr_su         = f_get_token (ls_rec, '~t')
   tr_jisu       = f_get_token (ls_rec, '~t')
   tr_co_cd      = f_get_token (ls_rec, '~t')
   susu_tr_co_cd = TRIM (ls_rec)

   IF ls_date <> STRING (dw_c.object.ymd [1], 'yyyymmdd')   Then
      F_MESSAGEBOX ('U000', '매매일자를 확인하십시오.')
      EXIT
   END IF

   SELECT sj_cd
     INTO :sj_cd
     FROM SSX0KJ t1
    WHERE t1.CORP_GR = :gaa.CORP_GR
      AND t1.sj_cd   LIKE (SUBSTR (:sj_cd,1,11) || '_') ;

   sj_cd = SQLCA.GETITEMSTRING (1)

   IF lseq_no=0   Then
      SELECT NVL (MAX (tr_seq_no),1000)
        INTO :lseq_no
        FROM SST1KT t1
       WHERE t1.CORP_GR = :gaa.CORP_GR
         AND t1.tr_ymd  = TO_DATE(:ls_date,'yyyymmdd')
         AND t1.tr_cd   = :tr_cd ;

      lseq_no = SQLCA.GETITEMNUMBER (1)

   END IF

   lRow = EVENT ue_insert (0)

   Object.tr_cd [lRow]     = tr_cd
   Object.gyey_su [lRow]   = dec (tr_su)
   Object.gyey_jisu [lRow] = dec (tr_jisu)
   IF lRow=1   Then
      Object.fund_cd [lRow]       = fund_cd ; uf_setcodename (lRow, 'fund_cd', gaa.CORP_GR)
      Object.sj_cd [lRow]         = sj_cd ; uf_setcodename (lRow, 'sj_cd', gaa.CORP_GR)
      Object.tr_co_cd [lRow]      = tr_co_cd ; uf_setcodename (lRow, 'tr_co_cd', gaa.CORP_GR)
      Object.susu_tr_co_cd [lRow] = susu_tr_co_cd ; uf_setcodename (lRow, 'susu_tr_co_cd', gaa.CORP_GR)
   ELSE
      IF Object.fund_cd [lRow] <> fund_cd Then
         Object.fund_cd [lRow] = fund_cd ; uf_setcodename (lRow, 'fund_cd', gaa.CORP_GR)
      END IF
      IF Object.sj_cd [lRow] <> sj_cd  Then
         Object.sj_cd [lRow] = sj_cd ; uf_setcodename (lRow, 'sj_cd', gaa.CORP_GR)
      END IF
      IF Object.tr_co_cd [lRow] <> tr_co_cd  Then
         Object.tr_co_cd [lRow] = tr_co_cd ; uf_setcodename (lRow, 'tr_co_cd', gaa.CORP_GR)
      END IF
      IF Object.susu_tr_co_cd [lRow] <> susu_tr_co_cd Then
         Object.susu_tr_co_cd [lRow] = susu_tr_co_cd ; uf_setcodename (lRow, 'susu_tr_co_cd', gaa.CORP_GR)
      END IF
   END IF
   lseq_no ++
   Object.tr_seq_no [lRow] = lseq_no
LOOP

FileClose (li_num)
end event

event dw_list::updatestart;call super::updatestart;IF AncestorReturnVALUE=1 THEN RETURN 1

LONG	lRow, lRowCnt

DEC	dOffer_no

lRowCnt = ROWCOUNT ()
IF lRowCnt <= 0 THEN RETURN

DATETIME	ldt_tr_ymd

STRING	ls_tr_cd

ldt_tr_ymd = dw_c.object.ymd [1]
ls_tr_cd   = dw_c.object.dddw [1]

SELECT NVL (MAX (tr_seq_no),1000)
  INTO :dOffer_no
  FROM SST1KT t1
 WHERE t1.CORP_GR = :gaa.CORP_GR
   AND t1.tr_ymd  = :ldt_tr_ymd
   AND t1.tr_cd   = :ls_tr_cd ;

dOffer_no = SQLCA.GETITEMNUMBER (1)

FOR  lRow = 1  TO  lRowCnt
   IF (GETITEMSTATUS (lRow, 0, PRIMARY!)=NEWMODIFIED!) AND IsNull (Object.tr_seq_no [lRow])  Then
      dOffer_no ++
      Object.tr_seq_no [lRow] = dOffer_no
   END IF
NEXT
end event

event dw_list::ue_setcodesearch;call super::ue_setcodesearch;STRING	ls_tr_cd, ls_sj_gb

CHOOSE CASE GetColumnName ()
   CASE 'susu_tr_co_cd'
      rs_where = "used='1' and tr_co_cd in (select tr_co_cd from ssm0ss where corp_gr='" + gaa.CORP_GR + "')"
   CASE 'sj_cd'
      ls_tr_cd = dw_c.object.dddw [1]

      SELECT sebu_cd_efnm
        INTO :ls_sj_gb
        FROM SZX0GR t1
       WHERE t1.gr_cd   = 'B4'
         AND t1.sebu_cd = :ls_tr_cd ;

      ls_sj_gb = SQLCA.GETITEMSTRING (1)

      rs_where = "sj_gb='" + ls_sj_gb + "'"
END CHOOSE

RETURN 1
end event

event dw_list::ue_insertstart;call super::ue_insertstart;LONG	lRow

lRow = GETROW ()

IF lRow>0   Then
   uf_setColumn ('sj_cd', Object.sj_cd [lRow])
   uf_setColumn ('xx_sj_cd', Object.xx_sj_cd [lRow])
   uf_setColumn ('fund_cd', Object.fund_cd [lRow])
   uf_setColumn ('xx_fund_cd', Object.xx_fund_cd [lRow])
   uf_setColumn ('xx_unit_aek', STRING (Object.xx_unit_aek [lRow]))
   uf_setColumn ('gyey_jisu', STRING (Object.gyey_jisu [lRow]))
   uf_setColumn ('susu_tr_co_cd', Object.susu_tr_co_cd [lRow])
   uf_setColumn ('xx_susu_tr_co_cd', Object.xx_susu_tr_co_cd [lRow])
   uf_setColumn ('xx_mg_cd', Object.xx_mg_cd [lRow])
END IF
uf_setColumn ('tr_ymd', STRING (dw_c.object.ymd [1]))
uf_setColumn ('tr_cd', dw_c.object.dddw [1])
uf_setColumn ('chasu', '1')

POST SetColumn ('fund_cd')

RETURN 0
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnValue=1 THEN RETURN 1

CHOOSE CASE dwo.name
	CASE 'sj_cd'
		CHOOSE CASE dw_c.object.dddw [1]
			CASE 'S10', 'S11', 'S12', 'S20', 'S21', 'S22'
				IF MidA (data,4,1) <> '1'  Then
					RETURN uf_itemerr (row, dwo.name, '선물종목을 확인하십시오')
				END IF
			CASE 'S70', 'S71', 'S72', 'S80', 'S81', 'S82'
				IF MidA (data,4,1) <> '2'  Then
					RETURN uf_itemerr (row, dwo.name, '선물종목을 확인하십시오')
				END IF
			CASE 'S90', 'S91', 'S92', 'SA0', 'SA1', 'SA2'
				IF MidA (data,4,1) <> '3'  Then
					RETURN uf_itemerr (row, dwo.name, '선물종목을 확인하십시오')
				END IF
		END CHOOSE
END CHOOSE
end event

type cb_other from pf_u_commandbutton within w_ja031a
integer x = 4910
integer y = 192
integer width = 471
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "만기거래생성"
end type

event clicked;STRING	p_msg = SPACE (200), la_args[]

p_msg = space (200)
la_args[1] = gaa.corp_gr
la_args[2] = STRING(dw_c.object.ymd[1], 'yyyy.mm.dd')
la_args[3] = 'ref'
SQLCA.singleconnection ()
SQLCA.SP_CALL (THIS, 'SR_JA031A ( ?, ?, ? )', la_args[], p_msg)
p_msg = f_nvl (SQLCA.getitemplsql (1), 'N')
IF SQLCA.sqlcode()>=0  Then
   IF p_msg<>'Y'  Then
      f_messageBox ('I002', p_msg)
   Else
      f_messageBox ('P000', '거래내역 생성처리를 완료 했습니다')
   End IF
Else
   f_messageBox ('SP00', string (SQLCA.SQLDBCode) + '~r~n' + SQLCA.SQLErrText())
End IF
end event

