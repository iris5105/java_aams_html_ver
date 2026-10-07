forward
global type w_designcache from w_window1st5ncn
end type
type dw_list from u_dw within w_designcache
end type
type dw_detail from u_dw within w_designcache
end type
type st_notice from pf_u_statictext within w_designcache
end type
type cb_init2all from pf_u_commandbutton within w_designcache
end type
end forward

global type w_designcache from w_window1st5ncn
dw_list dw_list
dw_detail dw_detail
st_notice st_notice
cb_init2all cb_init2all
end type
global w_designcache w_designcache

forward prototypes
public subroutine of_deleteobject (string as_pgm_id, string as_lib)
public subroutine of_librarydelete (string as_dwid, string as_lib1, string as_lib2)
end prototypes

public subroutine of_deleteobject (string as_pgm_id, string as_lib);String		ls_dwid, ls_objnm
Long		ll_rowcnt, ll_i

dw_detail.AcceptText()

ll_rowcnt	= dw_detail.Rowcount()
If ll_rowcnt < 1 Then Return
Choose Case as_lib
	Case 'designcache1.pbl'
		For ll_i = 1 To ll_rowcnt
			ls_dwid	= dw_detail.GetItemString(ll_i, 'dw_id')
			ls_objnm	= lower(as_pgm_id + '_' + ls_dwid)
			of_librarydelete(ls_objnm, 'designcache2.pbl', 'designcache3.pbl')
		Next
	Case 'designcache2.pbl'
		For ll_i = 1 To ll_rowcnt
			ls_dwid	= dw_detail.GetItemString(ll_i, 'dw_id')
			ls_objnm	= lower(as_pgm_id + '_' + ls_dwid)
			of_librarydelete(ls_objnm, 'designcache1.pbl', 'designcache3.pbl')
		Next		
	Case 'designcache3.pbl'
		For ll_i = 1 To ll_rowcnt
			ls_dwid	= dw_detail.GetItemString(ll_i, 'dw_id')
			ls_objnm	= lower(as_pgm_id + '_' + ls_dwid)
			of_librarydelete(ls_objnm, 'designcache1.pbl', 'designcache2.pbl')
		Next		
End Choose
end subroutine

public subroutine of_librarydelete (string as_dwid, string as_lib1, string as_lib2);String		ls_path
Long		ll_rtn

ls_path = gnv_vari.basepath + "\" + as_lib1
ll_rtn = LibraryDelete ( ls_path , as_dwid, ImportDataWindow!)

If ll_rtn = -1 Then
	ls_path = gnv_vari.basepath + "\" + as_lib2
	ll_rtn = LibraryDelete ( ls_path , as_dwid, ImportDataWindow!)
End If
end subroutine

on w_designcache.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_detail=create dw_detail
this.st_notice=create st_notice
this.cb_init2all=create cb_init2all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_notice
this.Control[iCurrent+4]=this.cb_init2all
end on

on w_designcache.destroy
call super::destroy
destroy(this.dw_list)
destroy(this.dw_detail)
destroy(this.st_notice)
destroy(this.cb_init2all)
end on

event wue_retrieve;call super::wue_retrieve;Long	ll_rtn, ll_row

dw_list.AcceptText()

ll_row	= dw_list.GetRow()
ll_rtn	= dw_list.Retrieve (gnv_vari.SetEssSite, gnv_vari.mswindowrate)

If ll_row > 1 and ll_rtn > ll_row Then dw_list.Event RowFocusChanged (ll_row)

gnv_dwcache.of_getalldbcache ()
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within w_designcache
end type

type ln_templeft from w_window1st5ncn`ln_templeft within w_designcache
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_designcache
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_designcache
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_designcache
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_designcache
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_designcache
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_designcache
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_designcache
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_designcache
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_designcache
end type

type uo_navi from w_window1st5ncn`uo_navi within w_designcache
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_designcache
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_designcache
end type

type p_close from w_window1st5ncn`p_close within w_designcache
end type

type p_excel from w_window1st5ncn`p_excel within w_designcache
end type

type p_print from w_window1st5ncn`p_print within w_designcache
end type

type p_delete from w_window1st5ncn`p_delete within w_designcache
end type

type p_update from w_window1st5ncn`p_update within w_designcache
end type

type p_input from w_window1st5ncn`p_input within w_designcache
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_designcache
end type

type p_clear from w_window1st5ncn`p_clear within w_designcache
end type

type dw_list from u_dw within w_designcache
integer x = 50
integer y = 348
integer width = 5381
integer height = 1476
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_designcache_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
end type

event clicked;call super::clicked;IF row<1 Then RETURN
Choose CASE dwo.name
   CASE 'b_update'
      IF gnv_vari.getclienttype<>'PB' or gnv_vari.is_ipaddress<>gnv_vari.SetCacheSignupIP Then
         Messagebox('Check', '기능은 지정된 PC의 C/S에서만 진행 가능 합니다.')
         RETURN
      End IF
      STRING	ls_siteid, ls_pgmid, ls_windowrate, ls_creategb, ls_createview, ls_pgm_nm, ls_pgm_lib, ls_objnm, ls_sqlerrtext

      LONG	ll_row

      DWItemStatus   ItemStatus

      This.AcceptText()

      ls_siteid      = This.GetItemString(row, 'site_id')
      ls_pgmid    	= This.GetItemString(row, 'pgm_id')
      ls_windowrate  = This.GetItemString(row, 'windowrate')
      ls_creategb    = This.GetItemString(row, 'creategb')
      ls_createview  = This.GetItemString(row, 'creategb_view')
      ls_pgm_nm      = This.GetItemString(row, 'pgm_nm')
      ls_pgm_lib     = This.GetItemString(row, 'pgm_lib')

      ItemStatus = this.GetItemStatus(row,0,primary!)

      IF ItemStatus=DataModified! THEN
         IF fw_f_nvls(ls_pgm_lib, '')=''  Then
            Messagebox('Check', '라이브러리는 필수 선택입니다.')
            RETURN
         End IF

         IF fw_f_nvls(ls_creategb, '')='' Then
            Messagebox('Check', '진행상태는  필수 선택입니다.')
            RETURN
         End IF

         DateTime ldt_dtm
         ldt_dtm  = fw_f_getymdhh24miss4d()

         UPDATE  fw_designsyntax
            SET  creategb = :ls_creategb
               , pgm_nm   = :ls_pgm_nm
               , pgm_lib  = :ls_pgm_lib
               , upd_id   = :gnv_vari.is_user_id
               , upd_dt   = :ldt_dtm
         WHERE   site_id    = :ls_siteid
           AND   pgm_id     = :ls_pgmid
           AND   creategb   = :ls_createview
           AND   windowrate = :ls_windowrate;

         IF SQLCA.sqlcode ()<>0  Then
            ls_sqlerrtext = SQLCA.sqlerrtext ()
            rollbackJ ()
            MessageBox('Error : ' + 'designcache 저장 오류' + string(SQLCA.SqlCode()), ls_SqlErrText)
            RETURN
         End IF

         COMMITJ()
         gw_mdi.Dynamic SetMicroHelp('DesignCache 저장 성공')

         of_deleteobject(ls_pgmid, ls_pgm_lib)
         Yield ()
         p_retrieve.POST EVENT Clicked()
      End IF

   CASE 'b_view'
      Window   lw_window
      STRING	ls_pgm_id

      /* delaytime start; windelaytime init */
      gnv_vari.windelaytime = 0
      gnv_vari.windelaytime = cpu()

      ls_pgm_id = This.GetItemString(row, 'pgm_id')
      OpenSheet(lw_window, ls_pgm_id, gw_mdi, 1, Original!)
End Choose
end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return
String		ls_site_id, ls_pgm_id, ls_windowrate
Long		ll_ret, ll_row

This.AcceptText()

ls_site_id			= This.GetItemString(currentrow, 'site_id')
ls_pgm_id		= This.GetItemString(currentrow, 'pgm_id')
ls_windowrate	= This.GetItemString(currentrow, 'windowrate')

ll_row = dw_detail.getrow( )
ll_ret = dw_detail.Retrieve(ls_site_id, ls_pgm_id, ls_windowrate)
If ll_row = 1 Then dw_detail.Post Event rowfocuschanged(1)
end event

type dw_detail from u_dw within w_designcache
integer x = 50
integer y = 1844
integer width = 5381
integer height = 920
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_designcache_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibsetlist4subbtn = true
string islist4subbtnauth = "0000010000"
end type

event clicked;call super::clicked;Choose Case dwo.name
	Case 'b_design'
		String		ls_pgm_id
		Window	lw_window
		
		ls_pgm_id = This.GetItemString(row, 'pgm_id')
		OpenSheet(lw_window, ls_pgm_id, gw_mdi, 1, Original!)
End Choose
end event

event constructor;call super::constructor;SetTransObject( sqlca )
end event

event oue_subbtn_delete;call super::oue_subbtn_delete;AcceptText()
deleterow (getrow ())
end event

type st_notice from pf_u_statictext within w_designcache
integer x = 101
integer y = 200
integer width = 2638
boolean bringtotop = true
long textcolor = 33512448
string text = "PBL 변경 후 저장시 반드시 상태값을 처리로 진행하고 DESIGN BUTTON을 클릭 하십시요"
boolean setsheetcolor = true
end type

type cb_init2all from pf_u_commandbutton within w_designcache
integer x = 4955
integer y = 192
integer width = 393
integer taborder = 90
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "전체초기화"
boolean fixedtoright = true
end type

event clicked;call super::clicked;STRING	ls_datetime, ls_sqlerrtext

LONG	ll_rtn

ll_rtn = messagebox("Question", "전체 초기화를 진행 하시겠습니까?", question!, OKCancel!, 1)

IF ll_rtn=1 Then
   ls_datetime = fw_f_getymdhh24miss4s()

   UPDATE  fw_designsyntax
      SET  creategb = '2'
         , upd_id   = :gnv_vari.is_user_id
         , upd_dt   = :ls_datetime
   WHERE   windowrate = :gnv_vari.mswindowrate;

   IF SQLCA.sqlcode ()<>0  Then
      ls_sqlerrtext = SQLCA.sqlerrtext ()
      rollbackJ ()
      MessageBox('Error : ' + '전체 초기화 상태 변경 오류' + string(SQLCA.SqlCode()), ls_SqlErrText)
      RETURN
   End IF
   commitJ ()
   MessageBox('Success', '전체 초기화가 정상적으로 되었습니다.')
End IF
end event

