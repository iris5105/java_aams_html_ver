forward
global type w_ja032g from wt_listdetail
end type
end forward

global type w_ja032g from wt_listdetail
boolean eb_retrievewait = true
boolean eb_direct_retrieve = true
string is_date_nation = "US"
string is_find = "jm_cd=~'~'"
end type
global w_ja032g w_ja032g

on w_ja032g.create
int iCurrent
call super::create
end on

on w_ja032g.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;IF	f_notnull (gaa.opt_cd) THEN is_find = "jm_cd=' + gaa.opt_cd + '"
dw_list.retrieve (gaa.corp_gr, dw_c.object.ymd [1])
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.ymd [1] = idt_workdate
end event

event ue_activate;call super::ue_activate;IF	dw_list.enabled And f_notnull (gaa.opt_cd) THEN dw_list.uf_find ("jm_cd=' + gaa.opt_cd + '")
end event

type lb_dirlist from wt_listdetail`lb_dirlist within w_ja032g
end type

type ln_templeft from wt_listdetail`ln_templeft within w_ja032g
end type

type ln_tempbuttom from wt_listdetail`ln_tempbuttom within w_ja032g
end type

type ln_temptop from wt_listdetail`ln_temptop within w_ja032g
end type

type ln_tempbutton from wt_listdetail`ln_tempbutton within w_ja032g
end type

type ln_tempstart from wt_listdetail`ln_tempstart within w_ja032g
end type

type ln_cond1_yline from wt_listdetail`ln_cond1_yline within w_ja032g
end type

type ln_dw1_yline from wt_listdetail`ln_dw1_yline within w_ja032g
end type

type ln_cond2_yline from wt_listdetail`ln_cond2_yline within w_ja032g
end type

type ln_dw2_yline from wt_listdetail`ln_dw2_yline within w_ja032g
end type

type ln_tempright from wt_listdetail`ln_tempright within w_ja032g
end type

type uo_navi from wt_listdetail`uo_navi within w_ja032g
end type

type ln_temptop_shadow from wt_listdetail`ln_temptop_shadow within w_ja032g
end type

type st_windelaytime from wt_listdetail`st_windelaytime within w_ja032g
end type

type st_top_rect from wt_listdetail`st_top_rect within w_ja032g
end type

type p_close from wt_listdetail`p_close within w_ja032g
end type

type p_excel from wt_listdetail`p_excel within w_ja032g
end type

type p_print from wt_listdetail`p_print within w_ja032g
end type

type p_delete from wt_listdetail`p_delete within w_ja032g
end type

type p_update from wt_listdetail`p_update within w_ja032g
end type

type p_input from wt_listdetail`p_input within w_ja032g
end type

type p_retrieve from wt_listdetail`p_retrieve within w_ja032g
end type

type p_clear from wt_listdetail`p_clear within w_ja032g
end type

type p_copy from wt_listdetail`p_copy within w_ja032g
end type

type dw_c from wt_listdetail`dw_c within w_ja032g
string tag = "만기월 기준"
string title = "만기일자"
string dataobject = "dc_ymd"
end type

type btn_update from wt_listdetail`btn_update within w_ja032g
end type

type st_count from wt_listdetail`st_count within w_ja032g
end type

type dw_list from wt_listdetail`dw_list within w_ja032g
string dataobject = "d_ja032g1"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'balh_nation | nation_cd', gaa.CORP_GR, '', 1, "")
f_dddwctl (THIS, 'currency', gaa.CORP_GR, '', 1, "")
f_dddwctl (THIS, 'change_currency | currency', gaa.CORP_GR, '', 1, "")
f_dddwctl (THIS, 'sj_gb', gaa.CORP_GR, '', 1, "")
f_dddwctl (THIS, 'jasan', gaa.CORP_GR, '', 1, "")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('seq_no', '1')
uf_setColumn ('jasan_gb', 'A')
uf_setColumn ('sj_gubun', '1')
uf_setColumn ('js_jongryu', '1')
uf_setColumn ('siga_agent', 'B')
uf_setColumn ('unit_aek', '100')

POST SetColumn ('jm_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF getitemstatus (row, 0, primary!)=new! or getitemstatus (row, 0, primary!)=newmodified! OR gaa.aams   Then
   f_setprotect (THIS, FALSE, { 'balh_nation','jm_cd','jm_nm','currency' })
Else
   f_setprotect (THIS, TRUE, { 'balh_nation','jm_cd','jm_nm','currency' })
End IF
end event

event dw_list::itemchanged;call super::itemchanged;IF AncestorReturnVALUE=1 THEN RETURN 1

DATETIME	ldt_lsy_ymd, ldt_chk_ymd
STRING	ls_code

CHOOSE CASE DWO.NAME
   CASE 'jm_cd'
      IF POS (data,':') > 0   Then
         ls_code               = LEFT (data, POS (data, ':') - 1)
         Object.stock_gb [row] = ls_code

         SELECT SEBU_CD_EFNM
           INTO :ls_code
           FROM SZX0GR t1
          WHERE t1.gr_cd   = 'Q0'
            AND t1.sebu_cd = :ls_code ;
         IF SQLCA.SQLCode () = 0 Then
            ls_code                  = SQLCA.GETITEMSTRING (1)
            Object.balh_nation [row] = ls_code

            SELECT currency
              INTO :ls_code
              FROM SZX0WA t1
             WHERE t1.nation_cd = :ls_code ;
            IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
         END IF

         IF f_null (Object.sedol [row]) THEN Object.sedol [row] = MID (data, POS (data,':') + 1)
         IF f_null (Object.blbg_tckr [row])  THEN Object.blbg_tckr [row] = MID (data, POS (data,':') + 1)
      END IF
   CASE 'balh_nation'
      IF f_null (Object.currency [row])   Then
         SELECT currency
           INTO :ls_code
           FROM SZX0WA t1
          WHERE t1.nation_cd = :data ;
         IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
      END IF
   CASE 'currency'
      IF f_null (Object.balh_nation [row])   Then
         SELECT nation_cd
           INTO :ls_code
           FROM SZX0WA t1
          WHERE t1.currency = :data ;
         IF SQLCA.SQLCode ()=0 THEN Object.balh_nation [row] = SQLCA.GETITEMSTRING (1)
      END IF
   CASE 'sj_gb'
      CHOOSE CASE data
         CASE '0'
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row]  = null_dc
            Object.lsy_ymd [row]   = null_dt
         CASE '1'
            Object.hangsa_ga [row] = null_dc
            Object.unit_aek [row]  = 100
         CASE '2', '3'
            Object.unit_aek [row] = 100
      END CHOOSE
   CASE 'lsy_ymd'
      ldt_lsy_ymd = DATETIME (DATE (MidA (data,1,10)))

      IF ldt_lsy_ymd < idt_workdate Then
         RETURN uf_itemerr (ROW, 'lsy_ymd', '작업일전의 최종결제일은 입력할 수 없습니다.')
      END IF

      IF Object.sj_gb [row] = '1' AND PosA ('75,76', STRING (object.jasan [row])) = 0  Then
         IF PosA ('03,06,09,12',STRING (ldt_lsy_ymd,'mm')) = 0 Then
            RETURN uf_itemerr (ROW, 'lsy_ymd', '선물 최종결제월은 3,6,9,12월만 가능합니다.')
         END IF
      END IF

      CHOOSE CASE Object.jasan [row]
         CASE '75', '76'
             SELECT next_day(trunc(:ldt_lsy_ymd,'mm') - 1,'월') + 16 INTO :ldt_chk_ymd FROM DUAL;
            ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd <> ldt_chk_ymd Then
               F_MESSAGEBOX ('I001', '셋째주 수요일이 아닙니다.' + STRING (ldt_chk_ymd))
            END IF
         CASE '01' TO '79'
             SELECT next_day(trunc(:ldt_lsy_ymd,'mm'), '목') + 7 INTO :ldt_chk_ymd FROM DUAL;
            ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd <> ldt_chk_ymd Then
               F_MESSAGEBOX ('I001', '둘째주 목요일이 아닙니다.')
            END IF
         CASE 'XX', 'X1'
             SELECT next_day(trunc(:ldt_lsy_ymd,'mm') - 1,'수') + 14 INTO :ldt_chk_ymd FROM DUAL;
            ldt_chk_ymd = SQLCA.getitemdatetime (1)

            IF ldt_lsy_ymd <> ldt_chk_ymd Then
               F_MESSAGEBOX ('I001', '셋째주 수요일이 아닙니다.')
            END IF
      END CHOOSE
END CHOOSE
end event

type dw_detail from wt_listdetail`dw_detail within w_ja032g
string dataobject = "d_ja032g2"
end type

event dw_detail::ue_retrieve;call super::ue_retrieve;retrieve (gaa.corp_gr, idt_workdate, dw_list.object.jm_cd [iRow])
end event

event dw_detail::updatestart;call super::updatestart;long ll_row, ll_rowcount, ll_master_row
string ls_jm_cd, ls_corp_gr
datetime ldt_now

// 1. 현재 일자와 시간을 가져옵니다.
ldt_now = datetime(today(), now())

// 2. DataWindow의 load_time 컬럼 디스플레이 포맷을 강제 지정합니다.
This.Object.load_time.Format = "yyyy-mm-dd hh:mm:ss"

// 3. 상단 dw_list의 현재 선택된 행(Row)에서 마스터 Key 정보를 미리 가져옵니다.
ll_master_row = dw_list.GetRow()
IF ll_master_row > 0 THEN
    ls_corp_gr   = dw_list.Object.corp_gr[ll_master_row]
    ls_jm_cd     = dw_list.Object.jm_cd[ll_master_row]

END IF

ll_rowcount = This.RowCount()

// 4. 전체 Row를 돌면서 신규 입력(INSERT) 대상만 찾아 일괄 세팅합니다.
FOR ll_row = 1 TO ll_rowcount
    
    // 상태가 'NewModified!' (신규 행이 추가되고 값이 세팅되어 저장이 필요한 상태)인 경우만 실행
    IF This.GetItemStatus(ll_row, 0, Primary!) = NewModified! THEN
       
        IF ll_master_row > 0 THEN
            This.Object.corp_gr[ll_row] = ls_corp_gr
            This.Object.jm_cd[ll_row]   = ls_jm_cd
        END IF
        
        // 신규 행의 load_time에 포맷팅된 현재 시간 세팅
        This.Object.load_time[ll_row] = ldt_now
        
    END IF
NEXT

// 0을 리턴해야 정상적으로 DB 저장이 진행됩니다.
RETURN 0
end event

event dw_detail::ue_insertstart;call super::ue_insertstart;string ls_jasan, ls_change_jm_cd
long ll_master_row

ll_master_row = dw_list.GetRow()

IF ll_master_row > 0 THEN
	
    ls_jasan    = dw_list.Object.jasan[ll_master_row]
    ls_change_jm_cd = dw_list.Object.change_jm_cd[ll_master_row]
	 
    uf_setColumn('isin_cd', ls_change_jm_cd)
    uf_setColumn('blbg_tckr', ls_jasan)

END IF

return 0	
end event

type st_move from wt_listdetail`st_move within w_ja032g
end type

