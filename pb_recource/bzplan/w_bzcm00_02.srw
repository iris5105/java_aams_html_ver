forward
global type w_bzcm00_02 from w_window1st5ncn
end type
type dw_list from u_dw within w_bzcm00_02
end type
end forward

global type w_bzcm00_02 from w_window1st5ncn
dw_list dw_list
end type
global w_bzcm00_02 w_bzcm00_02

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gnv_vari.is_sys_id)
end event

on w_bzcm00_02.create
int iCurrent
call super::create
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
end on

on w_bzcm00_02.destroy
call super::destroy
destroy(this.dw_list)
end on

event wue_update;call super::wue_update;if of_update({idw_u}) >= 0 then
	return 0
else
	return -1
end if
end event

event wue_postopen;call super::wue_postopen;idw_u = dw_list
Post Event wue_retrieve2ready()
end event

event wue_setdddw;call super::wue_setdddw;//fw_f_setdddw(dw_list, 'rgb_cd', {gnv_vari.is_sys_id, gnv_vari.is_lang_type, 'SYSC001', '%'})
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within w_bzcm00_02
end type

type ln_templeft from w_window1st5ncn`ln_templeft within w_bzcm00_02
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_bzcm00_02
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_bzcm00_02
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_bzcm00_02
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_bzcm00_02
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_bzcm00_02
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_bzcm00_02
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_bzcm00_02
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_bzcm00_02
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_bzcm00_02
end type

type uo_navi from w_window1st5ncn`uo_navi within w_bzcm00_02
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_bzcm00_02
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_bzcm00_02
end type

type st_top_rect from w_window1st5ncn`st_top_rect within w_bzcm00_02
end type

type p_close from w_window1st5ncn`p_close within w_bzcm00_02
end type

type p_excel from w_window1st5ncn`p_excel within w_bzcm00_02
end type

type p_print from w_window1st5ncn`p_print within w_bzcm00_02
end type

type p_delete from w_window1st5ncn`p_delete within w_bzcm00_02
end type

type p_update from w_window1st5ncn`p_update within w_bzcm00_02
end type

type p_input from w_window1st5ncn`p_input within w_bzcm00_02
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_bzcm00_02
end type

type p_clear from w_window1st5ncn`p_clear within w_bzcm00_02
end type

type dw_list from u_dw within w_bzcm00_02
integer x = 50
integer y = 156
integer width = 5381
integer height = 2608
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_bzcm00_02_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibdesign4role = false
boolean ibsetlist4singleselect = false
end type

event updatestart;call super::updatestart;LONG  ll_rcnt, ll_nowseq = 0
LONG  ll_row

STRING   ls_rgb_cd, ls_rgb_seq

DWITEMSTATUS    ldwstatus

ll_rcnt = this.ROWCOUNT ()

DO WHILE ll_row <= ll_rcnt
   ll_row = this.getnextmodified (ll_row, PRIMARY!)
	IF ll_row>0 Then
		ldwstatus = this.GETITEMSTATUS (ll_row, 0, PRIMARY!)
		CHOOSE CASE ldwstatus
			CASE NEWMODIFIED!
				ll_nowseq ++
				ls_rgb_cd = this.GETITEMSTRING (ll_row, 'rgb_cd')
				
				SELECT TRIM(TO_CHAR(TO_NUMBER(NVL(MAX(rgb_seq),'0')) + :ll_nowseq,'000'))
				  INTO :ls_rgb_seq
				  FROM FW_SYS_COLOR_TO t1
				 WHERE sys_id          = :gnv_vari.is_sys_id
					AND NVL(rgb_cd,'')  = :ls_rgb_cd ;
				
				IF SQLCA.sqlcode()=0 Then
					ls_rgb_seq = SQLCA.GETITEMSTRING (1)
				ELSE
					MESSAGEBOX ("ERROR", "중분류 코드를 생성하지 못했습니다. ")
					iiUpdateStart = 1
					RETURN iiUpdateStart
				END IF

				This.setItem (ll_row, 'sys_id', gnv_vari.is_sys_id)
				This.setItem (ll_row, 'rgb_seq', ls_rgb_seq)
				This.setItem (ll_row, 'reg_id', gnv_vari.is_user_id)
				This.setItem (ll_row, 'reg_dt', fw_f_getymdhh24miss4s())

		CASE DATAMODIFIED!
            This.setItem (ll_row, 'upd_id', gnv_vari.is_user_id)
            This.setItem (ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		END CHOOSE
	ELSE
		ll_row = ll_rcnt + 1
	END IF
LOOP
end event

event oue_setupdatecheck;call super::oue_setupdatecheck;String	ls_rgb_cd

Long	ll_rgb_r, ll_rgb_g, ll_rgb_b
Long	ll_row, ll_rcnt

ll_rcnt	= this.rowcount()

Do While ll_row <= ll_rcnt
	ll_row = this.getnextmodified(ll_row, Primary!)
	IF ll_row > 0 THEN
		ls_rgb_cd = this.getitemstring(ll_row, 'rgb_cd')
		If fw_f_nvls(ls_rgb_cd, '') = '' Then
			Messagebox('Notice', '컬러구분을 입력하세요')
			this.setcolumn('rgb_cd')
			Return -1
		End If
		ll_rgb_r = this.getitemnumber(ll_row, 'rgb_r')
		If fw_f_nvll(ll_rgb_r, 0) = 0 Then this.setitem(ll_row, 'rgb_r', 0)
		ll_rgb_g = this.getitemnumber(ll_row, 'rgb_g')
		If fw_f_nvll(ll_rgb_g, 0) = 0 Then this.setitem(ll_row, 'rgb_g', 0)
		ll_rgb_b = this.getitemnumber(ll_row, 'rgb_b')
		If fw_f_nvll(ll_rgb_b, 0) = 0 Then this.setitem(ll_row, 'rgb_b', 0)
	Else
		ll_row = ll_rcnt + 1
	End If
Loop

Return 1

end event

event itemfocuschanged;call super::itemfocuschanged;f_SelectText (THIS)
end event

event retrieverow;call super::retrieverow;IF isNull (Object.rgb_v [row]) THEN Object.rgb_v [row] = Object.display [row]
end event

event retrieveend;call super::retrieveend;uf_retrieveend ('', rowcount, eb_null_line)
end event

event clicked;call super::clicked;IF	row>0 THEN Object.rgb_v [row] = Object.display [row]
end event

event itemchanged_next;call super::itemchanged_next;Object.rgb_v [row] = Object.display [row]
end event

