forward
global type w_ja035r from wt_listshare
end type
end forward

global type w_ja035r from wt_listshare
boolean eb_direct_retrieve = true
string is_date_nation = "US"
end type
global w_ja035r w_ja035r

on w_ja035r.create
int iCurrent
call super::create
end on

on w_ja035r.destroy
call super::destroy
end on

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gaa.corp_gr)
end event

type lb_dirlist from wt_listshare`lb_dirlist within w_ja035r
end type

type ln_templeft from wt_listshare`ln_templeft within w_ja035r
end type

type ln_tempbuttom from wt_listshare`ln_tempbuttom within w_ja035r
end type

type ln_temptop from wt_listshare`ln_temptop within w_ja035r
end type

type ln_tempbutton from wt_listshare`ln_tempbutton within w_ja035r
end type

type ln_tempstart from wt_listshare`ln_tempstart within w_ja035r
end type

type ln_cond1_yline from wt_listshare`ln_cond1_yline within w_ja035r
end type

type ln_dw1_yline from wt_listshare`ln_dw1_yline within w_ja035r
end type

type ln_cond2_yline from wt_listshare`ln_cond2_yline within w_ja035r
end type

type ln_dw2_yline from wt_listshare`ln_dw2_yline within w_ja035r
end type

type ln_tempright from wt_listshare`ln_tempright within w_ja035r
end type

type uo_navi from wt_listshare`uo_navi within w_ja035r
end type

type ln_temptop_shadow from wt_listshare`ln_temptop_shadow within w_ja035r
end type

type st_windelaytime from wt_listshare`st_windelaytime within w_ja035r
end type

type st_top_rect from wt_listshare`st_top_rect within w_ja035r
end type

type p_close from wt_listshare`p_close within w_ja035r
end type

type p_excel from wt_listshare`p_excel within w_ja035r
end type

type p_print from wt_listshare`p_print within w_ja035r
end type

type p_delete from wt_listshare`p_delete within w_ja035r
end type

type p_update from wt_listshare`p_update within w_ja035r
end type

type p_input from wt_listshare`p_input within w_ja035r
end type

type p_retrieve from wt_listshare`p_retrieve within w_ja035r
end type

type p_clear from wt_listshare`p_clear within w_ja035r
end type

type p_copy from wt_listshare`p_copy within w_ja035r
end type

type dw_c from wt_listshare`dw_c within w_ja035r
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_listshare`btn_update within w_ja035r
end type

type st_count from wt_listshare`st_count within w_ja035r
end type

type dw_list from wt_listshare`dw_list within w_ja035r
integer y = 156
integer height = 2608
string dataobject = "d_ja035r1"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;uf_dddwctl ('balh_nation | nation_cd', dw_master, 'balh_nation', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('currency', dw_master, 'currency', gaa.CORP_GR, '', 1, "")
CHOOSE CASE gaa.corp_gr
	CASE '2502'
		uf_dddwctl ('stock_gb', dw_master, 'stock_gb', gaa.CORP_GR, '', 2, "")
	CASE ELSE
		uf_dddwctl ('stock_gb', dw_master, 'stock_gb', gaa.CORP_GR, '', 1, "")
END CHOOSE
uf_dddwctl ('jasan_attr', dw_master, 'jasan_attr', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('siga_agent', dw_master, 'siga_agent', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('fen0055', dw_master, 'fen0055', gaa.CORP_GR, '', 1, "")
uf_dddwctl ('sj_gb | sj_gubun', dw_master, 'sj_gb', gaa.CORP_GR, '', 1, '')
f_dddwctl (dw_master, 'jasan', gaa.CORP_GR, ",입력없음,", 1, "sebu_cd='ZZ0'")

f_dddw_filter (THIS, 'jasan_attr', "LEFT (cd,1)='3'")
f_dddw_filter (dw_master, 'jasan_attr', "LEFT (cd,1)='3'")
end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setColumn ('jasan_gb', '1')
uf_setColumn ('js_jongryu', '1')
uf_setColumn ('sj_gb', '1')
uf_setColumn ('siga_agent', 'S')

dw_master.POST SetColumn ('jm_cd')

RETURN 0
end event

event dw_list::ue_protect;call super::ue_protect;IF getitemstatus (row, 0, primary!)=new! OR getitemstatus (row, 0, primary!)=newmodified!	Then
   f_setprotect (dw_master, FALSE, { 'balh_nation','jm_cd','jm_nm','currency' })
Else
   f_setprotect (dw_master, TRUE, { 'balh_nation','jm_cd','jm_nm','currency' })
End IF
end event

event dw_list::rowfocuschanged_if;call super::rowfocuschanged_if;CHOOSE CASE Object.sj_gb [currentrow]
   CASE '1', '5', '3'
      f_dddw_filter (THIS, 'fen0055', "fkey='1'")
      f_dddw_filter (dw_master, 'fen0055', "fkey='1'")
   CASE '2'
      f_dddw_filter (THIS, 'fen0055', "fkey='5'")
      f_dddw_filter (dw_master, 'fen0055', "fkey='5'")
   CASE '3'
      f_dddw_filter (THIS, 'fen0055', "fkey='1'")
      f_dddw_filter (dw_master, 'fen0055', "fkey='1'")
   CASE '4'
      f_dddw_filter (THIS, 'fen0055', "fkey='2'")
      f_dddw_filter (dw_master, 'fen0055', "fkey='2'")
   CASE '9'
      f_dddw_filter (THIS, 'fen0055', "fkey='6'")
      f_dddw_filter (dw_master, 'fen0055', "fkey='6'")
   CASE ELSE
      f_dddw_filter (THIS, 'fen0055', "fkey='5'")
      f_dddw_filter (dw_master, 'fen0055', "fkey='5'")
END CHOOSE
RETURN 0
end event

event dw_list::ue_copyrowset;call super::ue_copyrowset;Object.jm_cd [row] = ''
Object.jm_nm [row] = ''
Object.sedol [row] = ''
Object.blbg_tckr [row] = ''
Object.blbg_tckr_text [row] = ''
end event

type dw_master from wt_listshare`dw_master within w_ja035r
integer x = 2030
integer y = 1452
integer width = 3067
integer height = 1000
string dataobject = "d_ja035r2"
end type

event dw_master::itemchanged;call super::itemchanged;STRING	ls_code

CHOOSE CASE dwo.name
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

         IF f_null (Object.sedol [row])           THEN Object.sedol [row] = MID (data, POS (data,':') + 1)
         IF f_null (Object.blbg_tckr [row])       THEN Object.blbg_tckr [row] = MID (data, POS (data,':') + 1)
         Object.blbg_tckr_text [row] = MID (data, POS (data,':') + 1) + ' ' + Object.balh_nation [row]

		ElseIF POS (data,'.')>0	Then
			Object.stock_gb [row] = MID (data, POS (data,'.') + 1)
			IF	f_null (Object.sedol [row]) THEN Object.sedol [row] = LEFT (data, POS (data,'.') - 1)
			IF	f_null (Object.blbg_tckr [row])  THEN Object.blbg_tckr [row] = LEFT (data, POS (data,'.') - 1)
		End IF
   CASE 'blbg_tckr'
      Object.blbg_tckr_text [row] = data + ' ' + Object.balh_nation [row]
   CASE 'balh_nation'
      IF f_null (Object.currency [row])   Then
         SELECT currency
           INTO :ls_code
           FROM SZX0WA t1
          WHERE t1.nation_cd = :data ;
         IF SQLCA.sqlcode ()=0 THEN Object.currency [row] = SQLCA.GETITEMSTRING (1)
      END IF
      Object.blbg_tckr_text [row] = Object.blbg_tckr [row] + ' ' + data
      Object.gbx [row] = 'N'
      IF Object.currency [row]='GBP' THEN Object.gbx [row] = 'Y'
   CASE 'currency'
      IF f_null (Object.balh_nation [row])   Then
         SELECT nation_cd
           INTO :ls_code
           FROM SZX0WA t1
          WHERE t1.currency = :data ;

         Object.balh_nation [row] = SQLCA.GETITEMSTRING (1)
      END IF
      Object.gbx [row] = 'N'
      IF data='GBP' THEN Object.gbx [row] = 'Y'
END CHOOSE
end event

event dw_master::itemfocuschanged;call super::itemfocuschanged;IF dwo.name='sj_gb' Then
   CHOOSE CASE Object.sj_gb [row]
      CASE '1','5','3'
         f_dddw_filter (THIS, 'fen0055', "fkey='1'")
         f_dddw_filter (dw_list, 'fen0055', "fkey='1'")
      CASE '2'
         f_dddw_filter (THIS, 'fen0055', "fkey='5'")
         f_dddw_filter (dw_list, 'fen0055', "fkey='5'")
      CASE '3'
         f_dddw_filter (THIS, 'fen0055', "fkey='1'")
         f_dddw_filter (dw_list, 'fen0055', "fkey='1'")
      CASE '4'
         f_dddw_filter (THIS, 'fen0055', "fkey='2'")
         f_dddw_filter (dw_list, 'fen0055', "fkey='2'")
      CASE '9'
         f_dddw_filter (THIS, 'fen0055', "fkey='6'")
         f_dddw_filter (dw_list, 'fen0055', "fkey='6'")
      CASE ELSE
         f_dddw_filter (THIS, 'fen0055', "fkey='5'")
         f_dddw_filter (dw_list, 'fen0055', "fkey='5'")
   END CHOOSE
End IF
end event

