forward
global type w_pbdupdate from w_window1st5ncn
end type
type uo_tab from pf_u_tab within w_pbdupdate
end type
type dw_sheet from u_dw within w_pbdupdate
end type
type tab_1 from tab within w_pbdupdate
end type
type tabpage_1 from userobject within tab_1
end type
type dw_2 from u_dw within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_2 from userobject within tab_1
end type
type cb_upload from commandbutton within tabpage_2
end type
type cb_1 from commandbutton within tabpage_2
end type
type cb_reset from commandbutton within tabpage_2
end type
type st_7 from statictext within tabpage_2
end type
type st_6 from statictext within tabpage_2
end type
type st_5 from statictext within tabpage_2
end type
type st_4 from statictext within tabpage_2
end type
type st_3 from statictext within tabpage_2
end type
type sle_path from singlelineedit within tabpage_2
end type
type mle_chango from multilineedit within tabpage_2
end type
type mle_enroll_file from multilineedit within tabpage_2
end type
type sle_subsystem from singlelineedit within tabpage_2
end type
type sle_system from singlelineedit within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_upload cb_upload
cb_1 cb_1
cb_reset cb_reset
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
sle_path sle_path
mle_chango mle_chango
mle_enroll_file mle_enroll_file
sle_subsystem sle_subsystem
sle_system sle_system
end type
type tab_1 from tab within w_pbdupdate
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_pbdupdate from w_window1st5ncn
string title = "버젼관리"
uo_tab uo_tab
dw_sheet dw_sheet
tab_1 tab_1
end type
global w_pbdupdate w_pbdupdate

type variables
long	il_select_cnt
string	is_filename_select []		//화일명
string	is_filename2_select[]		//경로 및 화일명
end variables

on w_pbdupdate.create
int iCurrent
call super::create
this.uo_tab=create uo_tab
this.dw_sheet=create dw_sheet
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_tab
this.Control[iCurrent+2]=this.dw_sheet
this.Control[iCurrent+3]=this.tab_1
end on

on w_pbdupdate.destroy
call super::destroy
destroy(this.uo_tab)
destroy(this.dw_sheet)
destroy(this.tab_1)
end on

event wue_postopen;call super::wue_postopen;p_retrieve.Post Event Clicked()
end event

event wue_clear;call super::wue_clear;tab_1.tabpage_1.dw_2.InsertRow(0)
end event

type lb_dirlist from w_window1st5ncn`lb_dirlist within w_pbdupdate
end type

type ln_templeft from w_window1st5ncn`ln_templeft within w_pbdupdate
end type

type ln_tempbuttom from w_window1st5ncn`ln_tempbuttom within w_pbdupdate
end type

type ln_temptop from w_window1st5ncn`ln_temptop within w_pbdupdate
end type

type ln_tempbutton from w_window1st5ncn`ln_tempbutton within w_pbdupdate
end type

type ln_tempstart from w_window1st5ncn`ln_tempstart within w_pbdupdate
end type

type ln_cond1_yline from w_window1st5ncn`ln_cond1_yline within w_pbdupdate
end type

type ln_dw1_yline from w_window1st5ncn`ln_dw1_yline within w_pbdupdate
end type

type ln_cond2_yline from w_window1st5ncn`ln_cond2_yline within w_pbdupdate
end type

type ln_dw2_yline from w_window1st5ncn`ln_dw2_yline within w_pbdupdate
end type

type ln_tempright from w_window1st5ncn`ln_tempright within w_pbdupdate
end type

type uo_navi from w_window1st5ncn`uo_navi within w_pbdupdate
end type

type ln_temptop_shadow from w_window1st5ncn`ln_temptop_shadow within w_pbdupdate
end type

type st_windelaytime from w_window1st5ncn`st_windelaytime within w_pbdupdate
end type

type st_top_rect from w_window1st5ncn`st_top_rect within w_pbdupdate
end type

type p_close from w_window1st5ncn`p_close within w_pbdupdate
end type

type p_excel from w_window1st5ncn`p_excel within w_pbdupdate
end type

type p_print from w_window1st5ncn`p_print within w_pbdupdate
end type

type p_delete from w_window1st5ncn`p_delete within w_pbdupdate
end type

type p_update from w_window1st5ncn`p_update within w_pbdupdate
end type

type p_input from w_window1st5ncn`p_input within w_pbdupdate
end type

type p_retrieve from w_window1st5ncn`p_retrieve within w_pbdupdate
boolean visible = true
end type

event p_retrieve::clicked;call super::clicked;String ls_file_id

If dw_sheet.Retrieve(gnv_vari.SetEssSite) < 1 Then
	Messagebox('확인','조회된 건이 없습니다.')
	Return
End If

ls_file_id = dw_sheet.object.file_id[1]
tab_1.tabpage_1.dw_2.Retrieve(gnv_vari.SetEssSite, ls_file_id)
end event

type p_clear from w_window1st5ncn`p_clear within w_pbdupdate
end type

type uo_tab from pf_u_tab within w_pbdupdate
integer x = 750
integer y = 148
integer width = 590
integer taborder = 40
boolean bringtotop = true
boolean scaletoright = true
string referencedtab = "tab_1"
end type

on uo_tab.destroy
call pf_u_tab::destroy
end on

type dw_sheet from u_dw within w_pbdupdate
integer x = 50
integer y = 1036
integer width = 5381
integer height = 1728
integer taborder = 50
string title = "UPDATE PBD LIST"
string dataobject = "d_pbdupdate_1"
boolean vscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean ibtitle4datawindow = true
end type

event rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

tab_1.tabpage_1.dw_2.reset()

String	ls_file

Long	ll_ret

ls_file = dw_sheet.getItemString(currentrow, "file_id")

tab_1.tabpage_1.dw_2.retrieve(gnv_vari.SetEssSite, ls_file)
end event

type tab_1 from tab within w_pbdupdate
integer x = 50
integer y = 152
integer width = 5381
integer height = 872
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5344
integer height = 740
long backcolor = 16777215
string text = "버젼정보"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_1.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_1.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw within tabpage_1
string tag = "settrans=true"
integer x = 9
integer y = 24
integer width = 5312
integer height = 700
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pbdupdate_2"
boolean scaletoright = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 116
integer width = 5344
integer height = 740
long backcolor = 16777215
string text = "File Upload"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_upload cb_upload
cb_1 cb_1
cb_reset cb_reset
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
sle_path sle_path
mle_chango mle_chango
mle_enroll_file mle_enroll_file
sle_subsystem sle_subsystem
sle_system sle_system
end type

on tabpage_2.create
this.cb_upload=create cb_upload
this.cb_1=create cb_1
this.cb_reset=create cb_reset
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.sle_path=create sle_path
this.mle_chango=create mle_chango
this.mle_enroll_file=create mle_enroll_file
this.sle_subsystem=create sle_subsystem
this.sle_system=create sle_system
this.Control[]={this.cb_upload,&
this.cb_1,&
this.cb_reset,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.sle_path,&
this.mle_chango,&
this.mle_enroll_file,&
this.sle_subsystem,&
this.sle_system}
end on

on tabpage_2.destroy
destroy(this.cb_upload)
destroy(this.cb_1)
destroy(this.cb_reset)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_path)
destroy(this.mle_chango)
destroy(this.mle_enroll_file)
destroy(this.sle_subsystem)
destroy(this.sle_system)
end on

type cb_upload from commandbutton within tabpage_2
integer x = 786
integer y = 52
integer width = 384
integer height = 104
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "UpLoad"
end type

event clicked;STRING	ls_filename, ls_filename2, ls_tmp_filenm, ls_date, ls_blob_err

LONG	ll_FileLen, ll_tmp_FileLen, ll_tmp_ver, ll_blob_length, ll_blob

INTEGER	li_file_pointer, li_Loops, li_start

BLOB	lbb_blob_pict, lbb_Temp, lbb_File

INT   ll_rows, i, flag = 0

LONG	ll_i, ll_select_row

SELECT  TO_CHAR(now(),'yyyymmddhh24miss')
  INTO  :ls_date
FROM    dual;

ls_date = SQLCA.getitemstring (1)

for ll_i = 1 to il_select_cnt
   ls_filename    = is_filename_select[ll_i]          // 화일명
   ls_filename2   = is_filename2_select[ll_i]         // 상대디렉토리 + 화일명
   sle_path.text  = "파일명 (" + ls_filename2 + ")"   // 상대디렉토리 + 화일명
   ls_tmp_filenm  = ls_filename
   ll_FileLen     = FileLength(ls_filename2)          // 화일크기
   ll_tmp_FileLen = ll_FileLen                        // 임시화일크기보관

   // 파일별로 version 번호 생성하기
   SELECT  NVL(max(ver_cnt),0) + 1
     INTO  :ll_tmp_ver
   FROM    fw_csupdate t1
   WHERE   site_id = :gnv_vari.SetEssSite
     AND   file_id = :ls_filename;

   ll_tmp_ver = SQLCA.getitemnumber (1)
   IF ll_tmp_ver>1   Then //Update(기존자료 존재)
      UPDATE  fw_csupdate
         SET  ver_cnt    = :ll_tmp_ver
            , file_size  = :ll_tmp_filelen
            , file_path  = :ls_filename2
            , down_count = 0
            , save_date  = :ls_date
            , upd_id     = :gnv_vari.is_user_id
            , upd_dt     = :ls_date
      WHERE   site_id = :gnv_vari.SetEssSite
        AND   file_id = :ls_filename;
   Else        //신규등록
		INSERT INTO  fw_csupdate (
							site_id                          /* _1: */
						 , file_id                          /* _2: */
						 , ver_cnt                          /* _3: */
						 , file_size                        /* _4: */
						 , file_path                        /* _5: */
						 , save_date                        /* _6: */
						 , down_count                       /* _7: */
						 , reg_id                           /* _8: */
						 , reg_dt )                         /* _9: */
		VALUES ( :gnv_vari.SetEssSite                       /* _1: */
				 , :ls_filename                               /* _2: */
				 , :ll_tmp_ver                                /* _3: */
				 , :ll_tmp_FileLen                            /* _4: */
				 , :ls_filename2                              /* _5: */
				 , :ls_date                                   /* _6: */
				 , 0                                          /* _7: */
				 , :gnv_vari.is_user_id                       /* _8: */
				 , :ls_date                                   /* _9: */
				 );
   End IF
   IF SQLCA.SQLCODE ()<>0 THEN
      Messagebox('Notice', '프로그램관리등록테이블 저장에러. ~r~n' + &
                           '에러코드는 ' + string(SQLCA.SQLCODE() ) + '입니다. ~r~n' + &
                           '에러메세지 ' + SQLCA.SQLERRTEXT() , StopSign!)
      sle_path.text = SQLCA.SQLERRTEXT ()
      RollbackJ ()
      RETURN
   End IF
   sle_path.text = "파일명 (" + ls_tmp_filenm + ")  버젼NO ("  + string(ll_tmp_ver) + ")"

   li_file_pointer = FileOpen(ls_filename2,  StreamMode!)             // 상대디렉토리 + 화일명
   /* 파일의 블록수 계산 : Loops */
   IF ll_FileLen>32765 THEN //1Block process unit = 32765
      IF MOD(ll_FileLen,32765)=0 THEN
         li_Loops = (ll_FileLen / 32765 )
      ELSE
         li_Loops = (ll_FileLen / 32765 ) + 1
      End IF
   ELSE
      li_Loops = 1
   End IF
   IF li_file_pointer<>-1 THEN
      FOR li_start =  1 TO li_Loops
         FileRead(li_file_pointer,lbb_Temp)
         IF li_start=1 THEN
            lbb_File = lbb_Temp
         ELSE
            lbb_File = lbb_File + lbb_Temp
         End IF
      NEXT
      FileClose(li_file_pointer)

      ll_blob_length = LenA(lbb_File)

      sle_path.text = "파일명 (" + ls_tmp_filenm + ")  버젼NO ("  + string(ll_tmp_ver) + ") " + &
                        "파일크기 (" + string(ll_blob_length, '###,###,###,###') + ' Byte)'

      ll_blob = mo_.blob2hex(lbb_file, SQLCA.is_updateblob, ls_blob_err)

      UPDATEBLOB  fw_csupdate
         SET  blob_file = :lbb_file
            , file_size = :ll_blob_length
      WHERE   site_id = :gnv_vari.SetEssSite
        AND   file_id = :ls_filename;
      IF SQLCA.SQLCODE()<>0 THEN
         Messagebox('Notice', '프로그램관리등록테이블 BLOB저장에러. ~r~n' + &
                              '에러코드는 ' + string(SQLCA.SQLCODE()) + '입니다. ~r~n' + &
                              '에러메세지 ' + SQLCA.SQLERRTEXT() , StopSign!)
         sle_path.text = SQLCA.SQLERRTEXT ()
         RollbackJ ()
         RETURN
      Else
         CommitJ ()
      End IF
   Else
      MessageBox('Notice',"파일 (" + ls_tmp_filenm + ")는 사용 중이거나 삭제 되었습니다. ~r~n" + &
                        '파일을 확인 하세요', StopSign!)
      RollbackJ ()
      RETURN
   End IF
Next
CommitJ ()

This.Enabled = FALSE

Messagebox('Notice', string(il_select_cnt)  + '건의 자료를 Load시켰습니다.', Information!)

p_retrieve.POST EVENT Clicked()
cb_reset.POST EVENT Clicked()
end event

type cb_1 from commandbutton within tabpage_2
integer x = 393
integer y = 52
integer width = 384
integer height = 104
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "파일등록"
end type

event clicked;STRING	named[], docpath, click_check, ls_currentdir

INTEGER	value, i, li_start, li_max

// 초기화
cb_reset.TriggerEvent(Clicked!)

fw_f_savepath('get', '')
value = GetFileOpenName("Select File", &
         docpath, named[],"pbd", &
         "파워빌더 Files (*.pbd),*.pbd," + &
         "실행 Files (*.exe),*.exe," +  &
         "설정 Files (*.ini),*.ini," +  &
         "그림 Files (*.bmp),*.bmp," +  &
         "그림 Files (*.jpg),*.jpg," +  &
         "그림 Files (*.gif),*.gif," +  &
         "그림 Files (*.png),*.png," +  &
         "DLL  Files (*.dll),*.dll")

IF value<1  Then RETURN
value = Upperbound(named)

IF value=1  Then
   il_select_cnt ++
   is_filename_select [1] = named[1]		//화일명
   is_filename2_select[1] = docpath       //경로 및 화일명
else
   for i = 1 to value
      il_select_cnt ++
      is_filename_select [il_select_cnt] = named[il_select_cnt]						//화일명
      is_filename2_select[il_select_cnt] = docpath + "\" + named[il_select_cnt]	//경로 및 화일명
   next
End IF

li_max = value
IF li_max>0 Then
   Tab_1.Tabpage_2.mle_chango.text = ' ♣ 등 록 화 일 List ' + '~r~n'

   For li_start = 1 To li_max
      mle_enroll_file.text += (is_filename_select[li_start] + ', ')
      mle_chango.text += ('   ㆍ' + is_filename2_select[li_start] + '~r~n')
   Next
   mle_enroll_file.text = LeftA(mle_enroll_file.text, LenA(mle_enroll_file.text) - 2) + '...'
End IF

messagebox('Notice',' ~r~n' + &
         '-------------------------------------------~r~n' + &
         '          ' + string(il_select_cnt) + &
                  '개 파일을 선택했습니다~r~n' + &
         '-------------------------------------------~r~n' + &
         '버젼을 올리기 위한 upload버튼을 누르십시오~r~n' + ' ')

IF il_select_cnt>0   Then
   tab_1.tabpage_2.cb_upload.Enabled = TRUE
End IF
end event

type cb_reset from commandbutton within tabpage_2
integer y = 52
integer width = 384
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재 설 정"
end type

event clicked;INTEGER	li_start

Tab_1.Tabpage_2.mle_enroll_file.text	= ''
Tab_1.Tabpage_2.mle_chango.text = ' ♣ 등 록 화 일 List ' + '~r~n'

IF il_select_cnt > 0 THEN				
	For li_start = 1 To il_select_cnt
		is_filename_select[li_start] = ''
		is_filename2_select[li_start] = ''
	NEXT
	
END IF
il_select_cnt = 0

tab_1.tabpage_2.cb_upload.Enabled = false
end event

type st_7 from statictext within tabpage_2
integer x = 5
integer y = 560
integer width = 366
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
string text = "UpLoad File"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within tabpage_2
integer x = 2363
integer y = 16
integer width = 160
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
string text = "참고"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within tabpage_2
integer x = 5
integer y = 444
integer width = 366
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
string text = "등록할파일"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within tabpage_2
integer x = 5
integer y = 324
integer width = 366
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
boolean enabled = false
string text = "서브시스템"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within tabpage_2
integer x = 5
integer y = 208
integer width = 366
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
string text = "시  스  템"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_path from singlelineedit within tabpage_2
integer x = 384
integer y = 556
integer width = 2002
integer height = 84
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 23356516
borderstyle borderstyle = stylelowered!
end type

type mle_chango from multilineedit within tabpage_2
integer x = 2546
integer y = 12
integer width = 2766
integer height = 720
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 23356516
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type mle_enroll_file from multilineedit within tabpage_2
integer x = 384
integer y = 436
integer width = 2002
integer height = 84
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 23356516
borderstyle borderstyle = stylelowered!
end type

type sle_subsystem from singlelineedit within tabpage_2
integer x = 384
integer y = 316
integer width = 2002
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 23356516
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_system from singlelineedit within tabpage_2
integer x = 384
integer y = 200
integer width = 2002
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

