forward
global type w_bzcm00_01 from w_window1st5ncn
end type
type dw_mast from u_dw within w_bzcm00_01
end type
type dw_detl from u_dw within w_bzcm00_01
end type
type cb_1 from commandbutton within w_bzcm00_01
end type
type cb_2 from commandbutton within w_bzcm00_01
end type
end forward

global type w_bzcm00_01 from w_window1st5ncn
boolean ibconfirmupdate4closequery = true
boolean ibconfirmupdate4message = false
dw_mast dw_mast
dw_detl dw_detl
cb_1 cb_1
cb_2 cb_2
end type
global w_bzcm00_01 w_bzcm00_01

type variables

end variables

on w_bzcm00_01.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
this.dw_detl=create dw_detl
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
this.Control[iCurrent+2]=this.dw_detl
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
end on

on w_bzcm00_01.destroy
call super::destroy
destroy(this.dw_mast)
destroy(this.dw_detl)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event wue_retrieve;call super::wue_retrieve;Long	ll_ret, ll_row

dw_mast.AcceptText()

ll_row	= dw_mast.Getrow()
ll_ret	= dw_mast.Retrieve(gnv_vari.is_sys_id)

Choose Case ll_ret
	Case is > 0
		If ll_row = 1 Then dw_mast.Event RowFocusChanged(1)
		dw_mast.Post SetFocus()
	Case 0
		MessageBox("Check", "No data found.")
	Case is < 0
		MessageBox("Error", "Search Error")
End Choose
end event

event wue_postopen;call super::wue_postopen;This.PostEvent("wue_retrieve2ready")
end event

event wue_update;call super::wue_update;Return of_update({dw_mast, dw_detl})
end event

event wue_retrieve2ready;call super::wue_retrieve2ready;dw_mast.reset()
dw_detl.reset()
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within w_bzcm00_01
end type

type ln_templeft from w_window1st5ncn`ln_templeft within w_bzcm00_01
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_bzcm00_01
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_bzcm00_01
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_bzcm00_01
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_bzcm00_01
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_bzcm00_01
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_bzcm00_01
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_bzcm00_01
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_bzcm00_01
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_bzcm00_01
end type

type uo_navi from w_window1st5ncn`uo_navi within w_bzcm00_01
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_bzcm00_01
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_bzcm00_01
end type

type p_close from w_window1st5ncn`p_close within w_bzcm00_01
end type

type p_excel from w_window1st5ncn`p_excel within w_bzcm00_01
end type

type p_print from w_window1st5ncn`p_print within w_bzcm00_01
end type

type p_delete from w_window1st5ncn`p_delete within w_bzcm00_01
end type

type p_update from w_window1st5ncn`p_update within w_bzcm00_01
end type

type p_input from w_window1st5ncn`p_input within w_bzcm00_01
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_bzcm00_01
end type

type p_clear from w_window1st5ncn`p_clear within w_bzcm00_01
end type

type dw_mast from u_dw within w_bzcm00_01
integer x = 50
integer y = 160
integer width = 2363
integer height = 2604
integer taborder = 20
boolean bringtotop = true
string title = "대분류"
string dataobject = "d_bzcm00_01_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletobottom = true
boolean ibconfirmupdate4rowchanged = true
string isrowcheck4objdelete = "dw_detl"
boolean ibtitle4datawindow = true
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow=0 or enabled=false then return

String	ls_mast_cd

Long	ll_ret, ll_row, ll_rtn

ls_mast_cd = this.GetItemString(currentrow, 'mast_cd')

If fw_f_nvls(ls_mast_cd, '') = '' Then
	dw_detl.Reset()
	Return
End If

dw_detl.reset()
ll_ret = dw_detl.Retrieve(gnv_vari.is_sys_id, ls_mast_cd)

Choose Case ll_ret
	Case 0
		of_setfocusdw (dw_detl)
		Post Event wue_input()
	Case is < 0
		MessageBox("Error", "Error")
	Case Else
		//Post of_setfocusdw(this)
End Choose
end event

event itemchanged;call super::itemchanged;IF row = 0 THEN return
Long 		i, ll_cnt	
	
Choose Case dwo.name
	Case 'mast_cd'
		ll_cnt = dw_detl.rowcount()
		FOR i = 1 TO ll_cnt
			dw_detl.setItem(i, 'mast_cd', String(data))
		NEXT
	Case 'mast_nm'
		ll_cnt = dw_detl.rowcount()
		FOR i = 1 TO ll_cnt
			dw_detl.setItem(i, 'mast_nm', String(data))
		NEXT
End CHoose
end event

event insertrowend;call super::insertrowend;If row < 1 Then Return
This.SetFocus( )
This.ScrollToRow(row)
This.SetItem(row, 'detl_cd', '000')
This.SetItem(row, 'sort_cd', '000')
This.SetItem(row, 'use_gb', 'Y')

This.Post SetColumn('mast_cd')

end event

event updatestart;call super::updatestart;Long		ll_rcnt, ll_row
dwitemstatus	 ldwstatus

ll_rcnt = this.rowcount()

do while ll_row <= ll_rcnt        
	ll_row = this.getnextmodified(ll_row, Primary!)        
	IF ll_row > 0 THEN
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
		Choose Case ldwstatus 
			Case NewModified!
				this.setItem(ll_row, 'sys_id', gnv_vari.is_sys_id)
				this.setItem(ll_row, 'reg_id', gnv_vari.is_user_id)
				this.setItem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
			Case DataModified!
				this.setItem(ll_row, 'upd_id', gnv_vari.is_user_id)
				this.setItem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		End CHoose
	Else
		ll_row = ll_rcnt + 1        
	End If
Loop

end event

event retrieveend;call super::retrieveend;event rowfocuschanged (1)
end event

type dw_detl from u_dw within w_bzcm00_01
integer x = 2432
integer y = 160
integer width = 2999
integer height = 2604
integer taborder = 30
string title = "중분류"
string dataobject = "d_bzcm00_01_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
string isrowcheck4objupdate = "dw_mast"
boolean ibtitle4datawindow = true
boolean ibsetlist4excelclip = true
boolean ibsetlist4clearselect = true
end type

event updatestart;call super::updatestart;STRING	ls_mast_cd, ls_mast_nm, ls_mast_enm, ls_detl_cd
LONG	ll_rcnt, ll_row, ll_nowseq = 0
LONG	ll_mastrow

dwitemstatus    ldwstatus

ll_mastrow  = dw_mast.getrow()
ll_rcnt     = this.rowcount ()
//this.object.sys_id = 0000
ls_mast_cd  = dw_mast.getItemString(ll_mastrow, 'mast_cd')
ls_mast_nm  = dw_mast.getItemString(ll_mastrow, 'mast_nm')
ls_mast_enm = dw_mast.getItemString(ll_mastrow, 'mast_enm')

DO WHILE ll_row <= ll_rcnt
   ll_row = this.getnextmodified(ll_row, Primary!)
   IF ll_row>0 THEN
      ldwstatus = this.getitemstatus(ll_row, 0, Primary!)
      Choose CASE ldwstatus
         CASE NewModified!
            ll_nowseq ++

               SELECT  TRIM(to_char(to_number(nvl(max(detl_cd),'0')) + :ll_nowseq,'000'))
                 INTO  :ls_detl_cd
               FROM    fw_cmcd01m t1
               WHERE   sys_id          = :gnv_vari.is_sys_id
                 AND   NVL(mast_cd,'') = :ls_mast_cd
                 AND   NVL(detl_cd,'') != '000';

            IF SQLCA.sqlcode ()<>0  Then
               messagebox("ERROR", "중분류 코드를 생성하지 못했습니다. ")
               iiUpdateStart = 1
               RETURN iiUpdateStart
            End IF

				ls_detl_cd = SQLCA.getitemstring (1)

            This.setItem(ll_row, 'sys_id', gnv_vari.is_sys_id)
            This.setItem(ll_row, 'mast_cd', ls_mast_cd)
            This.setItem(ll_row, 'mast_nm', ls_mast_nm)
            This.setItem(ll_row, 'mast_enm', ls_mast_enm)
            This.setItem(ll_row, 'detl_cd', ls_detl_cd)
            This.setItem(ll_row, 'sort_cd', ls_detl_cd)
            This.setItem(ll_row, 'send_gb', '2')
            This.setItem(ll_row, 'reg_id', gnv_vari.is_user_id)
            This.setItem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
         CASE DataModified!
            This.setItem(ll_row, 'upd_id', gnv_vari.is_user_id)
            This.setItem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
      End CHoose
   Else
      ll_row = ll_rcnt + 1
   End IF
Loop
end event

event insertrowstart;call super::insertrowstart;String	ls_mast_cd, ls_mast_name

dw_mast.AcceptText()

IF dw_mast.rowcount() = 0 THEN
	messagebox("ERROR", "마스터 코드에 데이터가 없습니다. ")
	return -1
END IF

ls_mast_cd = dw_mast.getItemString(dw_mast.getRow(), 'mast_cd' )
IF IsNull(ls_mast_cd) THEN ls_mast_cd = ""
IF Len(Trim(ls_mast_cd)) = 0 THEN 
	messagebox("ERROR", "마스터 코드를 입력하지 않았습니다.")
	return -1
END IF

return 1
end event

event insertrowend;call super::insertrowend;If row < 1 Then Return

This.Post SetColumn('detl_cd')

end event

event oue_setupdatecheck;call super::oue_setupdatecheck;long 		NbrRows, ll_row = 0, count = 0
Long		ll_rowcnt, ll_r, ll_mstrow, ll_mstcnt
String	ls_temp, ls_busi_sumy
String	ls_apr_no
DWItemStatus		ldwstate

dw_mast.AcceptText()
dw_detl.AcceptText()
ll_mstcnt	= dw_mast.rowcount()
ll_mstrow	= dw_mast.getrow()

If ll_mstcnt < 1 Then
	Messagebox('Check', '대분류 항목이 없습니다.')
	Return -1
End If

ls_temp = fw_f_nvls(dw_mast.getItemString(ll_mstrow, 'mast_cd'), '')
NbrRows = this.RowCount()
Do While ll_row <= NbrRows        
	ll_row = this.GetNextModified(ll_row, Primary!)
	
	IF ll_row > 0 Then
		IF Len(ls_temp) = 0 Then
			Messagebox("ERROR", "대분류 코드가 없습니다. ")
			Return -1
		End IF
		
		ls_temp = fw_f_nvls(this.getItemString(ll_row, 'detl_nm'), '')
		IF Len(ls_temp) = 0 Then
			Messagebox("ERROR", "중분류명이 없습니다. ")
			Return -1
		End IF
	ELSE            
		ll_row = NbrRows + 1
	End IF
LOOP

Return 1
end event

type cb_1 from commandbutton within w_bzcm00_01
integer x = 2606
integer y = 20
integer width = 288
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "cs error"
end type

event clicked;string	ls_tmp
ls_tmp = dw_mast.getitemstring(100, '11')
end event

type cb_2 from commandbutton within w_bzcm00_01
integer x = 2907
integer y = 20
integer width = 329
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
string text = "web error"
end type

event clicked;string	ls_errormsg
ls_errormsg = 'error issue'

fw_f_collect4error(ls_errormsg)
end event

