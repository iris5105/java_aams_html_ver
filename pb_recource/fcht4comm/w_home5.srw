forward
global type w_home5 from w_window1st
end type
type p_intro4 from picture within w_home5
end type
type uo_cht1 from fw_u_v3cview within w_home5
end type
type tab_1 from tab within w_home5
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tab_1 from tab within w_home5
tabpage_1 tabpage_1
end type
type cb_1 from pf_u_commandbutton within w_home5
end type
type p_intro5 from picture within w_home5
end type
type tab_2 from tab within w_home5
end type
type tabpage_2 from userobject within tab_2
end type
type dw_2 from u_dw within tabpage_2
end type
type tabpage_2 from userobject within tab_2
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_2
end type
type dw_3 from u_dw within tabpage_3
end type
type tabpage_3 from userobject within tab_2
dw_3 dw_3
end type
type tab_2 from tab within w_home5
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type uo_plan1 from u_plan4u2sc within w_home5
end type
type p_intro6 from picture within w_home5
end type
type cb_2 from commandbutton within w_home5
end type
type dw_cht9 from fw_u_dwo within w_home5
end type
type p_excel from pf_u_imagebutton within w_home5
end type
type p_intro3 from picture within w_home5
end type
type uo_allnotice from u_home5_notice within w_home5
end type
type p_intro1 from picture within w_home5
end type
type p_intro2 from picture within w_home5
end type
type tab_4 from tab within w_home5
end type
type tabpage_5 from userobject within tab_4
end type
type dw_5 from u_dw within tabpage_5
end type
type tabpage_5 from userobject within tab_4
dw_5 dw_5
end type
type tab_4 from tab within w_home5
tabpage_5 tabpage_5
end type
type tab_3 from tab within w_home5
end type
type tabpage_4 from userobject within tab_3
end type
type dw_4 from u_dw within tabpage_4
end type
type tabpage_4 from userobject within tab_3
dw_4 dw_4
end type
type tab_3 from tab within w_home5
tabpage_4 tabpage_4
end type
type tab_5 from tab within w_home5
end type
type tabpage_6 from userobject within tab_5
end type
type dw_6 from u_dw within tabpage_6
end type
type tabpage_6 from userobject within tab_5
dw_6 dw_6
end type
type tab_5 from tab within w_home5
tabpage_6 tabpage_6
end type
end forward

global type w_home5 from w_window1st
integer width = 6816
integer height = 3700
long backcolor = 33028087
boolean confirmsheetbackcolor = false
p_intro4 p_intro4
uo_cht1 uo_cht1
tab_1 tab_1
cb_1 cb_1
p_intro5 p_intro5
tab_2 tab_2
uo_plan1 uo_plan1
p_intro6 p_intro6
cb_2 cb_2
dw_cht9 dw_cht9
p_excel p_excel
p_intro3 p_intro3
uo_allnotice uo_allnotice
p_intro1 p_intro1
p_intro2 p_intro2
tab_4 tab_4
tab_3 tab_3
tab_5 tab_5
end type
global w_home5 w_home5

type variables
STRING	is_customer_gr
end variables

forward prototypes
public subroutine of_bringtotop (boolean ab_value)
public subroutine uf_setcht ()
public subroutine uf_corp_gr ()
end prototypes

public subroutine of_bringtotop (boolean ab_value);this.BringToTop = ab_value
end subroutine

public subroutine uf_setcht ();long	ll_ret
uo_cht1.visible = TRUE
ll_ret = dw_cht9.retrieve(gaa.corp_gr, string(Today(), 'yyyymmdd'))
uo_cht1.of_default4cht(dw_cht9)
//uo_cht1.of_setchton_step1(dw_cht9, {'itemchanged', 'cht_yn', 'N'}, '순자산 및 계좌현황', 0)
//uo_cht1.bringtotop = TRUE

cb_2.postevent("clicked")

end subroutine

public subroutine uf_corp_gr ();tab_1.tabpage_1.dw_1.retrieve (gaa.CORP_GR)
tab_2.tabpage_2.dw_2.retrieve (gaa.CORP_GR)
tab_2.tabpage_3.dw_3.retrieve (gaa.CORP_GR)
tab_3.tabpage_4.dw_4.retrieve (gaa.CORP_GR)
tab_4.tabpage_5.dw_5.retrieve (gaa.CORP_GR)
tab_5.tabpage_6.dw_6.retrieve (gaa.CORP_GR)

POST uf_setcht ()
end subroutine

on w_home5.create
int iCurrent
call super::create
this.p_intro4=create p_intro4
this.uo_cht1=create uo_cht1
this.tab_1=create tab_1
this.cb_1=create cb_1
this.p_intro5=create p_intro5
this.tab_2=create tab_2
this.uo_plan1=create uo_plan1
this.p_intro6=create p_intro6
this.cb_2=create cb_2
this.dw_cht9=create dw_cht9
this.p_excel=create p_excel
this.p_intro3=create p_intro3
this.uo_allnotice=create uo_allnotice
this.p_intro1=create p_intro1
this.p_intro2=create p_intro2
this.tab_4=create tab_4
this.tab_3=create tab_3
this.tab_5=create tab_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_intro4
this.Control[iCurrent+2]=this.uo_cht1
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.p_intro5
this.Control[iCurrent+6]=this.tab_2
this.Control[iCurrent+7]=this.uo_plan1
this.Control[iCurrent+8]=this.p_intro6
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.dw_cht9
this.Control[iCurrent+11]=this.p_excel
this.Control[iCurrent+12]=this.p_intro3
this.Control[iCurrent+13]=this.uo_allnotice
this.Control[iCurrent+14]=this.p_intro1
this.Control[iCurrent+15]=this.p_intro2
this.Control[iCurrent+16]=this.tab_4
this.Control[iCurrent+17]=this.tab_3
this.Control[iCurrent+18]=this.tab_5
end on

on w_home5.destroy
call super::destroy
destroy(this.p_intro4)
destroy(this.uo_cht1)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.p_intro5)
destroy(this.tab_2)
destroy(this.uo_plan1)
destroy(this.p_intro6)
destroy(this.cb_2)
destroy(this.dw_cht9)
destroy(this.p_excel)
destroy(this.p_intro3)
destroy(this.uo_allnotice)
destroy(this.p_intro1)
destroy(this.p_intro2)
destroy(this.tab_4)
destroy(this.tab_3)
destroy(this.tab_5)
end on

event activate;call super::activate;//<임시> 처음 실행 시 차트실행 방지
IF uo_cht1.visible	Then
	IF	is_customer_gr<>gaa.customer_gr	Then
		is_customer_gr = gaa.customer_gr
		uo_allnotice.p_refresh.PostEvent ('clicked')	// 전체 공지사항
		post event wue_retrieve2ready()
	End IF
End IF

uo_cht1.setredraw(true)

if ib_onceopened = true then
	uo_plan1.em_ymd.PostEvent('modified')
end if
end event

event wue_lastopen;call super::wue_lastopen;event wue_retrieve()

//<임시> 차트 생성중 종료해도 오류안나도록 버튼블락
p_intro6.bringtotop = TRUE
gw_mdi.setredraw (FALSE)

p_intro6.bringtotop = TRUE

gw_mdi.setredraw (TRUE)
end event

event wue_retrieve2ready;POST EVENT wue_retrieve()
end event

event wue_postopen;call super::wue_postopen;is_customer_gr = gaa.customer_gr
end event

event wue_lastinst;call super::wue_lastinst;tab_1.tabpage_1.dw_1.SetTransObject (SQLCA)
tab_2.tabpage_2.dw_2.SetTransObject (SQLCA)
tab_2.tabpage_3.dw_3.SetTransObject (SQLCA)
tab_3.tabpage_4.dw_4.SetTransObject (SQLCA)
tab_4.tabpage_5.dw_5.SetTransObject (SQLCA)
tab_5.tabpage_6.dw_6.SetTransObject (SQLCA)

tab_1.tabpage_1.dw_1.event ue_dddw_retrieve()

//IF	uo_allnotice.of_rowcount ()<1 THEN uo_allnotice.p_refresh.PostEvent('clicked')	// 전체 공지사항

tab_1.tabpage_1.dw_1.retrieve (gaa.corp_gr)
tab_2.tabpage_2.dw_2.retrieve (gaa.corp_gr)
tab_2.tabpage_3.dw_3.retrieve (gaa.corp_gr)
tab_3.tabpage_4.dw_4.retrieve (gaa.corp_gr)
tab_4.tabpage_5.dw_5.retrieve (gaa.corp_gr)
tab_5.tabpage_6.dw_6.retrieve (gaa.corp_gr)

yield ()

post uf_setcht()
end event

type lb_dirlist from w_window1st`lb_dirlist within w_home5
integer x = 6235
integer y = 1964
end type

type ln_templeft from w_window1st`ln_templeft within w_home5
end type

type ln_tempbuttom from w_window1st`ln_tempbuttom within w_home5
end type

type ln_temptop from w_window1st`ln_temptop within w_home5
boolean visible = false
end type

type ln_tempbutton from w_window1st`ln_tempbutton within w_home5
end type

type ln_tempstart from w_window1st`ln_tempstart within w_home5
end type

type ln_cond1_yline from w_window1st`ln_cond1_yline within w_home5
end type

type ln_dw1_yline from w_window1st`ln_dw1_yline within w_home5
end type

type ln_cond2_yline from w_window1st`ln_cond2_yline within w_home5
end type

type ln_dw2_yline from w_window1st`ln_dw2_yline within w_home5
end type

type ln_tempright from w_window1st`ln_tempright within w_home5
end type

type uo_navi from w_window1st`uo_navi within w_home5
boolean visible = false
integer x = 0
integer y = 0
integer width = 82
end type

type ln_temptop_shadow from w_window1st`ln_temptop_shadow within w_home5
boolean visible = false
end type

type st_windelaytime from w_window1st`st_windelaytime within w_home5
boolean visible = false
integer x = 0
end type

type st_top_rect from w_window1st`st_top_rect within w_home5
end type

type p_intro4 from picture within w_home5
integer x = 69
integer y = 1764
integer width = 2167
integer height = 1600
string picturename = "..\img\home\home5\intro_cut.jpg"
boolean focusrectangle = false
end type

type uo_cht1 from fw_u_v3cview within w_home5
boolean visible = false
integer x = 4626
integer y = 1852
integer width = 1966
integer height = 1432
integer taborder = 40
boolean bringtotop = true
end type

on uo_cht1.destroy
call fw_u_v3cview::destroy
end on

type tab_1 from tab within w_home5
integer x = 151
integer y = 1852
integer width = 1993
integer height = 1432
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33028087
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = " 당일거래현황 "
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw within tabpage_1
integer y = 20
integer width = 1938
integer height = 1284
integer taborder = 60
boolean bringtotop = true
string title = ""
string dataobject = "d_home01"
boolean vscrollbar = true
boolean border = false
boolean ibdesign4role = false
boolean useborder = false
string setlist4backcolor = "255,255,255"
end type

event doubleclicked;IF ROW=0 THEN RETURN

STRING	ls_tr_cd, ls_pgm_no, ls_aams, ls_gr_tr_cd

ls_tr_cd = STRING (Object.tr_cd [row])
ls_aams  = iif (gaa.aams, '1', '0')

ls_gr_tr_cd = ls_tr_cd
IF STRING (Object.jasan_gb [row]) = '타사펀드'  Then
   IF POS ('J61,K61', ls_tr_cd)>0 THEN ls_gr_tr_cd = 'T_' + ls_tr_cd
END IF

// 출력할 화면이 등록되어 있으면 출력
SELECT CASE WHEN INSTR (t1.sebu_cd_efnm,'|')=0
            THEN t1.sebu_cd_efnm
            ELSE CASE WHEN :ls_aams='1' 
                      THEN SUBSTR (t1.sebu_cd_efnm,INSTR (t1.sebu_cd_efnm,'|') + 1)
                      ELSE SUBSTR (t1.sebu_cd_efnm,1,INSTR (t1.sebu_cd_efnm,'|') - 1) END END
  INTO :ls_pgm_no
  FROM SZX0GR t1
 WHERE t1.gr_cd   = '57'
   AND t1.sebu_cd = :ls_gr_tr_cd ;

ls_pgm_no = SQLCA.GETITEMSTRING (1)
IF f_notnull (ls_pgm_no)   Then
   gnv_rolemenu.of_setopensheet (ls_pgm_no)
   RETURN
END IF

// 등록된 화면이 없는경우 찾아서 실행
SELECT no.pgm_no
  INTO :ls_pgm_no
  FROM SZX1PT     t1
     , FW_PGM_MST no
     , (SELECT NVL(SUM(1), 0)  AS aams
          FROM SZX1PT tt
         WHERE tt.tr_cd               = :ls_tr_cd
           AND SUBSTR(tt.obj_id,1,1)  = 'w'
           AND SUBSTR(tt.obj_id,LENGTH(tt.obj_id) - 4)  = '_aams'
        ) t2
 WHERE t1.tr_cd               = :ls_tr_cd
   AND SUBSTR(t1.obj_id,1,1)  = 'w'
   AND ((:ls_aams ='1' AND t2.aams =1 AND SUBSTR(t1.obj_id,LENGTH(t1.obj_id) - 4) = '_aams')
         OR ((:ls_aams ='0' OR t2.aams <> 1) AND SUBSTR(t1.obj_id,LENGTH(t1.obj_id) - 4) <> '_aams'))
   AND lower(no.pgm_id)       = lower(t1.obj_id) ;

// 화면이 여러개 등록되어있는경우 실행안함
IF SQLCA.sqlcode() = 0  Then
   ls_pgm_no = SQLCA.GETITEMSTRING (1)
   IF f_notnull (ls_pgm_no)   Then
      gnv_rolemenu.of_setopensheet (ls_pgm_no)
      RETURN
   END IF
END IF

// 화면을 찾을수 없는경우 분개장실행
ls_pgm_no = iif (gaa.aams, '00656', '00966')
gnv_rolemenu.of_setopensheet (ls_pgm_no)
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'tr_cd', '', '', 1, '')
end event

event rbuttondown;call super::rbuttondown;IF	gnv_vari.is_user_id='001'	Then
	LONG	li

	STRING   ls_path, la_local[], ls_pbr = ''
	
	IF GetFileOpenName ("Select", ls_path, la_local, "*", "모든 자료 (*.*),*.*", 'C:\AAMS\img\')<>1 THEN RETURN
	
	IF	UPPERBOUND (la_local)=1	Then
		ls_pbr = ls_path
	Else
		FOR  li = 1  TO  UPPERBOUND (la_local)
			ls_pbr += f_replace (ls_path,'C:\AAMS','..') + '\' + la_local [li] + '~r~n'
		NEXT
	End IF
	
	::clipboard (ls_pbr)
	messagebox(ls_path, '복사')
End IF
end event

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

event getfocus;call fw_u_dwo::getfocus
end event

type cb_1 from pf_u_commandbutton within w_home5
integer x = 114
integer y = 1660
integer width = 457
integer taborder = 70
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "PBL export"
end type

event clicked;OPEN (w_get_object)
end event

event constructor;call super::constructor;visible = (gaa.login = 'yjs1992@hitel.net')
end event

type p_intro5 from picture within w_home5
integer x = 2290
integer y = 1764
integer width = 2167
integer height = 1600
boolean bringtotop = true
string picturename = "..\img\home\home5\intro_cut.jpg"
boolean focusrectangle = false
end type

type tab_2 from tab within w_home5
event create ( )
event destroy ( )
integer x = 2382
integer y = 1852
integer width = 1993
integer height = 1432
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33028087
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_2.create
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_2,&
this.tabpage_3}
end on

on tab_2.destroy
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_2 from userobject within tab_2
event create ( )
event destroy ( )
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = " 당월결산계좌LIST "
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw within tabpage_2
integer x = 9
integer y = 12
integer width = 1938
integer height = 1284
integer taborder = 80
boolean bringtotop = true
string title = ""
string dataobject = "d_home02"
boolean vscrollbar = true
boolean border = false
boolean ibdesign4role = false
boolean useborder = false
string setlist4backcolor = "255,255,255"
end type

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event doubleclicked;IF	row=0 THEN RETURN
gnv_rolemenu.of_setopensheet('00661')
gnv_rolemenu.of_setopensheet('00978')
end event

event getfocus;call fw_u_dwo::getfocus
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

type tabpage_3 from userobject within tab_2
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = " 당월이자(만기)"
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from u_dw within tabpage_3
integer y = 8
integer width = 1938
integer height = 1284
integer taborder = 90
boolean bringtotop = true
string title = ""
string dataobject = "d_home03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
boolean ibdesign4role = false
boolean useborder = false
string setlist4fontpointcolor = "line_color=red=a"
string setlist4backcolor = "255,255,255"
end type

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event doubleclicked;IF	row=0 THEN RETURN
gnv_rolemenu.of_setopensheet('00661')
gnv_rolemenu.of_setopensheet('00978')
end event

event getfocus;call fw_u_dwo::getfocus
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

type uo_plan1 from u_plan4u2sc within w_home5
boolean visible = false
integer x = 2587
integer y = 3476
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
end type

on uo_plan1.destroy
call u_plan4u2sc::destroy
end on

type p_intro6 from picture within w_home5
integer x = 4526
integer y = 1764
integer width = 2167
integer height = 1600
string picturename = "..\img\home\home5\intro_cut.jpg"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_home5
boolean visible = false
integer x = 4343
integer y = 1676
integer width = 206
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
boolean enabled = false
string text = "cht"
end type

event clicked;long	ll_ret
ll_ret = dw_cht9.retrieve(gaa.corp_gr, string(Today(), 'yyyymmdd'))
uo_cht1.post of_setchton_step1(dw_cht9, {'itemchanged', 'cht_yn', 'N'}, '순자산 및 계좌현황', 0)
end event

type dw_cht9 from fw_u_dwo within w_home5
boolean visible = false
integer x = 4576
integer y = 1668
integer width = 2048
integer height = 108
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "순자산 & 보수"
string dataobject = "d_home5_cht"
boolean livescroll = false
end type

event constructor;call super::constructor;settransobject (sqlca)
end event

type p_excel from pf_u_imagebutton within w_home5
integer x = 4238
integer y = 1872
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
boolean originalsize = true
string picturename = "..\img\controls\u_icon4btn\ico_exel.jpg"
end type

event clicked;call super::clicked;IF	tab_2.tabpage_2.dw_2.retrieve (gaa.corp_gr)>0 THEN f_xlsx (tab_2.tabpage_2.dw_2, '주간계좌LIST', '주간결산계좌LIST', '', '', '', '')
IF	tab_2.tabpage_3.dw_3.retrieve (gaa.corp_gr)>0 THEN f_xlsx (tab_2.tabpage_3.dw_3, '주간계좌LIST', '주간이자수령', '', '', '', '')

end event

type p_intro3 from picture within w_home5
integer x = 4498
integer y = 52
integer width = 2167
integer height = 1600
boolean bringtotop = true
string picturename = "..\img\home\home5\intro_cut.jpg"
boolean focusrectangle = false
end type

type uo_allnotice from u_home5_notice within w_home5
boolean visible = false
integer x = 489
integer y = 3476
integer width = 2034
integer height = 1432
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
end type

on uo_allnotice.destroy
call u_home5_notice::destroy
end on

type p_intro1 from picture within w_home5
integer x = 69
integer y = 52
integer width = 2167
integer height = 1600
boolean bringtotop = true
string picturename = "..\img\home\home5\intro_cut.jpg"
boolean focusrectangle = false
end type

type p_intro2 from picture within w_home5
integer x = 2290
integer y = 52
integer width = 2167
integer height = 1600
boolean bringtotop = true
string picturename = "..\img\home\home5\intro_cut.jpg"
boolean focusrectangle = false
end type

type tab_4 from tab within w_home5
integer x = 2377
integer y = 144
integer width = 1993
integer height = 1432
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33028087
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_5 tabpage_5
end type

on tab_4.create
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_5}
end on

on tab_4.destroy
destroy(this.tabpage_5)
end on

type tabpage_5 from userobject within tab_4
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = "수여예측참여내역(최근1개월)"
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw within tabpage_5
integer x = 5
integer y = 20
integer width = 1938
integer height = 1284
integer taborder = 70
boolean bringtotop = true
string title = ""
string dataobject = "d_home05"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ibdesign4role = false
boolean useborder = false
string setlist4backcolor = "255,255,255"
end type

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event doubleclicked;gnv_rolemenu.of_setopensheet ('00353')
end event

event getfocus;call fw_u_dwo::getfocus
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

type tab_3 from tab within w_home5
integer x = 146
integer y = 144
integer width = 1993
integer height = 1432
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33028087
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_4 tabpage_4
end type

on tab_3.create
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_4}
end on

on tab_3.destroy
destroy(this.tabpage_4)
end on

type tabpage_4 from userobject within tab_3
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = "공모기본정보"
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from u_dw within tabpage_4
integer x = 9
integer y = 20
integer width = 1938
integer height = 1280
integer taborder = 70
boolean bringtotop = true
string title = ""
string dataobject = "d_home04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ibdesign4role = false
boolean useborder = false
string setlist4backcolor = "255,255,255"
end type

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event doubleclicked;gnv_rolemenu.of_setopensheet ('00353')
end event

event getfocus;call fw_u_dwo::getfocus
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

type tab_5 from tab within w_home5
integer x = 4581
integer y = 144
integer width = 1993
integer height = 1432
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 33028087
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_6 tabpage_6
end type

on tab_5.create
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_6}
end on

on tab_5.destroy
destroy(this.tabpage_6)
end on

type tabpage_6 from userobject within tab_5
integer x = 18
integer y = 116
integer width = 1957
integer height = 1300
long backcolor = 33028087
string text = "시스템 개발 및 수정의뢰 현황"
long tabtextcolor = 33554432
long tabbackcolor = 33028087
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from u_dw within tabpage_6
integer x = 5
integer y = 12
integer width = 1938
integer height = 1284
integer taborder = 70
boolean bringtotop = true
string title = ""
string dataobject = "d_home06"
boolean vscrollbar = true
boolean border = false
boolean ibdesign4role = false
boolean useborder = false
string setlist4backcolor = "255,255,255"
end type

event clicked;If string(dwo.name)='datawindow' Then return 0
IF	row>0 THEN uf_setrow (row, true)
end event

event doubleclicked;gnv_rolemenu.of_setopensheet ('00295')
end event

event getfocus;call fw_u_dwo::getfocus
end event

event retrieveend;call fw_u_dwo::retrieveend
Enabled = TRUE
setredraw (true)
end event

event rowfocuschanged;call fw_u_dwo::rowfocuschanged
end event

