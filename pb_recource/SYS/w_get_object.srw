forward
global type w_get_object from w_response1st
end type
type dw_1 from fw_u_dwo within w_get_object
end type
type cb_ok from pf_u_commandbutton within w_get_object
end type
type cb_open from pf_u_commandbutton within w_get_object
end type
type cb_gicam from pf_u_commandbutton within w_get_object
end type
type cb_1 from pf_u_commandbutton within w_get_object
end type
type cb_2 from pf_u_commandbutton within w_get_object
end type
type cb_3 from pf_u_commandbutton within w_get_object
end type
type cb_pgsql from pf_u_commandbutton within w_get_object
end type
end forward

global type w_get_object from w_response1st
integer x = 407
integer y = 452
integer width = 2697
integer height = 2996
string title = "Library별 Object 가져오기"
long backcolor = 16777215
string icon = "LibraryList5!"
boolean center = true
dw_1 dw_1
cb_ok cb_ok
cb_open cb_open
cb_gicam cb_gicam
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_pgsql cb_pgsql
end type
global w_get_object w_get_object

type variables
STRING	is_DirName, is_FileName, ia_FileName [], is_Library
end variables

on w_get_object.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_ok=create cb_ok
this.cb_open=create cb_open
this.cb_gicam=create cb_gicam
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_pgsql=create cb_pgsql
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_open
this.Control[iCurrent+4]=this.cb_gicam
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.cb_pgsql
end on

on w_get_object.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_ok)
destroy(this.cb_open)
destroy(this.cb_gicam)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_pgsql)
end on

event open;call super::open;cb_Open.PostEvent (clicked!)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_get_object
end type

type ln_tempstart from w_response1st`ln_tempstart within w_get_object
end type

type ln_templeft from w_response1st`ln_templeft within w_get_object
end type

type ln_cond_start from w_response1st`ln_cond_start within w_get_object
end type

type ln_tempright from w_response1st`ln_tempright within w_get_object
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_get_object
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_get_object
end type

type dw_1 from fw_u_dwo within w_get_object
integer x = 50
integer y = 128
integer width = 2574
integer height = 2716
integer taborder = 50
string dataobject = "d_ex_library_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean applydesign = true
boolean useborder = true
end type

event clicked;SelectRow (0, FALSE)
IF row>0 THEN SelectRow (row, NOT (IsSelected (row)))
end event

event constructor;call super::constructor;Modify ("datawindow.selected.mouse=no datawindow.grid.columnmove=no")
end event

type cb_ok from pf_u_commandbutton within w_get_object
integer x = 393
integer y = 24
integer width = 315
integer taborder = 20
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "CLEAR"
end type

event clicked;STRING	ls_dir, ls_export, la_syntax [], ls_import, ls_error

INT	li_FileNum, lf, li, lw, lw_row, li_import

FOR  lf = 1  TO  UPPERBOUND (ia_FileName)
	yield ()
	IF	UPPERBOUND (ia_FileName)=1	Then
		is_FileName = is_DirName
	Else
		is_FileName = is_DirName + '\' + ia_FileName [lf]
	End IF
   Parent.Title = is_FileName
   is_library = LibraryDirectory (is_FileName, dirUserObject!)
   is_library = is_Library + LibraryDirectory (is_FileName, dirWindow!)
   IF f_null (is_Library) THEN CONTINUE

	dw_1.Reset ()
	dw_1.ImportString (is_Library)
	dw_1.Sort ()
	dw_1.GroupCalc ()

	ls_dir = 'c:\aams\export\' + f_replace (ia_FileName [lf],'.pbl','')

	// Export the DataWindow object to string
	FOR  li = 1  TO  dw_1.rowcount ()
		dw_1.setrow (li)
		dw_1.scrolltorow (li)
		CHOOSE CASE LEFT (dw_1.object.name [li],2)
			CASE 'w_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportWindow!)
			CASE 'u_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportUserObject!)
		END CHOOSE

		IF	POS (ls_export,'ibsetlist4filter2dwo =')>0 OR POS (ls_export,'ibsetlist4filter2uo =')>0 OR POS (ls_export,'ibsetlist4filtertip =')>0 &
																	 OR POS (ls_export,'ibsetlist4sort =')>0 OR POS (ls_export,'ibsetlist4sorttip =')>0	Then
			IF NOT DirectoryExists (ls_dir) THEN CreateDirectory (ls_dir)
			li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li], TextMode!, Write!, LockWrite!, Replace!)
			FileWriteEx (li_FileNum, ls_export)
			FileClose (li_FileNum)

			lw_row = f_get_array (ls_export, '~r~n', la_syntax)
			FOR  lw = lw_row  TO  1  STEP -1
				IF	f_null (la_syntax [lw])	Then
					lw_row --
				Else
					EXIT
				End IF
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'w_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.srw~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
				CASE 'u_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.sru~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
			END CHOOSE
			FOR  lw = 1  TO  lw_row
				IF	NOT (POS (la_syntax [lw],'ibsetlist4filter2dwo =')>0 OR POS (la_syntax [lw],'ibsetlist4filter2uo =')>0 OR POS (la_syntax [lw],'ibsetlist4filtertip =')>0 &
																						  OR POS (la_syntax [lw],'ibsetlist4sort =')>0 OR POS (la_syntax [lw],'ibsetlist4sorttip =')>0)	Then
					ls_import += RightTRIM (la_syntax [lw]) + '~r~n'
				End IF
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'w_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.srw', TextMode!, Write!, LockWrite!, Replace!)
				CASE 'u_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.sru', TextMode!, Write!, LockWrite!, Replace!)
			END CHOOSE
			FileWriteEx (li_FileNum, ls_import)
			FileClose (li_FileNum)
		End IF
	NEXT
NEXT
end event

type cb_open from pf_u_commandbutton within w_get_object
integer x = 59
integer y = 24
integer width = 315
integer taborder = 30
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "PBL열기"
end type

event clicked;INT	li_Return
	
li_Return = GetFileOpenName ("Select Library File", is_DirName, ia_FileName, "pbl", "Library files (*.pbl), *.pbl,all files(*.*), *.*", 'c:\aams\kernel', 2)
IF li_Return=1 THEN
   Parent.Title = is_DirName

   // USerObject & Window정보를 읽어온다.
	IF	UPPERBOUND (ia_FileName)=1	Then
		is_FileName = is_DirName
	Else
		is_FileName = is_DirName + '\' + ia_FileName [1]
	End IF
   is_library = LibraryDirectory (is_FileName, dirUserObject!)
   is_library = is_Library + LibraryDirectory (is_FileName, dirWindow!)
   IF f_notnull (is_Library)  Then
      dw_1.Reset ()
      dw_1.ImportString (is_Library)
      dw_1.Sort ()
      dw_1.GroupCalc ()
   End IF
End IF
end event

type cb_gicam from pf_u_commandbutton within w_get_object
integer x = 727
integer y = 24
integer width = 315
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "GICAM"
end type

event clicked;STRING	ls_dir, ls_export, la_syntax [], ls_import, ls_error

INT	li_FileNum, lf, li, lw, lw_row, li_import

FOR  lf = 1  TO  UPPERBOUND (ia_FileName)
	yield ()
	IF	UPPERBOUND (ia_FileName)=1	Then
		is_FileName = is_DirName
	Else
		is_FileName = is_DirName + '\' + ia_FileName [lf]
	End IF
   Parent.Title = is_FileName
   is_library = LibraryDirectory (is_FileName, dirUserObject!)
   is_library = is_Library + LibraryDirectory (is_FileName, dirWindow!)
   IF f_null (is_Library) THEN CONTINUE

	dw_1.Reset ()
	dw_1.ImportString (is_Library)
	dw_1.Sort ()
	dw_1.GroupCalc ()

	ls_dir = 'c:\aams\export\' + f_replace (ia_FileName [lf],'.pbl','')

	// Export the DataWindow object to string
	FOR  li = 1  TO  dw_1.rowcount ()
		dw_1.setrow (li)
		dw_1.scrolltorow (li)
		CHOOSE CASE LEFT (dw_1.object.name [li],2)
			CASE 'w_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportWindow!)
			CASE 'u_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportUserObject!)
		END CHOOSE

		IF	POS (ls_export,'gicam')>0 OR POS (ls_export,'1700')>0	Then
			IF NOT DirectoryExists (ls_dir) THEN CreateDirectory (ls_dir)
			li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li], TextMode!, Write!, LockWrite!, Replace!)
			FileWriteEx (li_FileNum, ls_export)
			FileClose (li_FileNum)

			lw_row = f_get_array (ls_export, '~r~n', la_syntax)
			FOR  lw = lw_row  TO  1  STEP -1
				IF	f_null (la_syntax [lw])	Then
					lw_row --
				Else
					EXIT
				End IF
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'w_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.srw~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
				CASE 'u_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.sru~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
			END CHOOSE
			FOR  lw = 1  TO  lw_row
				IF	POS (la_syntax [lw],'gicam')>0 OR POS (la_syntax [lw],'1700')>0	Then
					la_syntax [lw] = f_replace (la_syntax [lw],'gicam.','gaa.')
					IF	POS (la_syntax [lw],"'1700'")>0    THEN la_syntax [lw] = f_replace (la_syntax [lw],"'1700'","'2200'")
					IF	POS (la_syntax [lw],'gicam.kfs')>0 THEN la_syntax [lw] = f_replace (la_syntax [lw],'gicam.kfs','gaa.aams')
				End IF
				ls_import += RightTRIM (la_syntax [lw]) + '~r~n'
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'w_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.srw', TextMode!, Write!, LockWrite!, Replace!)
				CASE 'u_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.sru', TextMode!, Write!, LockWrite!, Replace!)
			END CHOOSE
			FileWriteEx (li_FileNum, ls_import)
			FileClose (li_FileNum)
		End IF
	NEXT
NEXT
end event

type cb_1 from pf_u_commandbutton within w_get_object
integer x = 1061
integer y = 24
integer width = 357
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "receivetype"
end type

event clicked;STRING	ls_dir, ls_export, la_syntax [], ls_import, ls_error

INT	li_FileNum, lf, li, lw, lw_row, li_import

FOR  lf = 1  TO  UPPERBOUND (ia_FileName)
	yield ()
	IF	UPPERBOUND (ia_FileName)=1	Then
		is_FileName = is_DirName
	Else
		is_FileName = is_DirName + '\' + ia_FileName [lf]
	End IF
   Parent.Title = is_FileName
   is_library = LibraryDirectory (is_FileName, dirUserObject!)
   is_library = is_Library + LibraryDirectory (is_FileName, dirWindow!)
   IF f_null (is_Library) THEN CONTINUE

	dw_1.Reset ()
	dw_1.ImportString (is_Library)
	dw_1.Sort ()
	dw_1.GroupCalc ()

	ls_dir = 'c:\aams\export\' + f_replace (ia_FileName [lf],'.pbl','')

	// Export the DataWindow object to string
	FOR  li = 1  TO  dw_1.rowcount ()
		dw_1.setrow (li)
		dw_1.scrolltorow (li)
		CHOOSE CASE LEFT (dw_1.object.name [li],2)
			CASE 'w_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportWindow!)
			CASE 'u_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportUserObject!)
		END CHOOSE

		IF	POS (ls_export,'string is_receivetype = "xml" =')>0	Then
			IF NOT DirectoryExists (ls_dir) THEN CreateDirectory (ls_dir)
			li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li], TextMode!, Write!, LockWrite!, Replace!)
			FileWriteEx (li_FileNum, ls_export)
			FileClose (li_FileNum)

			lw_row = f_get_array (ls_export, '~r~n', la_syntax)
			FOR  lw = lw_row  TO  1  STEP -1
				IF	f_null (la_syntax [lw])	Then
					lw_row --
				Else
					EXIT
				End IF
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'w_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.srw~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
				CASE 'u_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.sru~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
			END CHOOSE
			FOR  lw = 1  TO  lw_row
				IF	NOT (POS (la_syntax [lw],'string is_receivetype = "xml" ='))>0	Then
					ls_import += RightTRIM (la_syntax [lw]) + '~r~n'
				End IF
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'w_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.srw', TextMode!, Write!, LockWrite!, Replace!)
				CASE 'u_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.sru', TextMode!, Write!, LockWrite!, Replace!)
			END CHOOSE
			FileWriteEx (li_FileNum, ls_import)
			FileClose (li_FileNum)
		End IF
	NEXT
NEXT
end event

type cb_2 from pf_u_commandbutton within w_get_object
integer x = 2286
integer y = 24
integer width = 315
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "IMAGE"
end type

event clicked;STRING	ls_export, la_syntax [], ls_img = ''

INT	li_FileNum, lf, li, lw, lw_row

FOR  lf = 1  TO  UPPERBOUND (ia_FileName)
	yield ()
	IF	UPPERBOUND (ia_FileName)=1	Then
		is_FileName = is_DirName
	Else
		is_FileName = is_DirName + '\' + ia_FileName [lf]
	End IF
   Parent.Title = is_FileName
   is_library = LibraryDirectory (is_FileName, dirUserObject!)
   is_library = is_Library + LibraryDirectory (is_FileName, dirWindow!)
   IF f_null (is_Library) THEN CONTINUE

	dw_1.Reset ()
	dw_1.ImportString (is_Library)
	dw_1.Sort ()
	dw_1.GroupCalc ()

	// Export the DataWindow object to string
	FOR  li = 1  TO  dw_1.rowcount ()
		dw_1.setrow (li)
		dw_1.scrolltorow (li)
		CHOOSE CASE LEFT (dw_1.object.name [li],2)
			CASE 'w_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportWindow!)
			CASE 'u_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportUserObject!)
		END CHOOSE

		lw_row = f_get_array (ls_export, '~r~n', la_syntax)
		FOR  lw = lw_row  TO  1  STEP -1
			IF	POS (la_syntax [lw],'\img')>0 THEN ls_img += la_syntax [lw]
		NEXT
	NEXT
NEXT

::clipboard (ls_img)
messagebox ('', 'PBR 자료를 클립보드에 복사했습니다.')
end event

type cb_3 from pf_u_commandbutton within w_get_object
integer x = 1435
integer y = 24
integer width = 315
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "ICAM.SR"
end type

event clicked;STRING	ls_dir, ls_export, la_syntax [], ls_import, ls_error

INT	li_FileNum, lf, li, lw, lw_row, li_import

FOR  lf = 1  TO  UPPERBOUND (ia_FileName)
	yield ()
	IF	UPPERBOUND (ia_FileName)=1	Then
		is_FileName = is_DirName
	Else
		is_FileName = is_DirName + '\' + ia_FileName [lf]
	End IF
   Parent.Title = is_FileName
   is_library = LibraryDirectory (is_FileName, DirDataWindow!)
   IF f_null (is_Library) THEN CONTINUE

	dw_1.Reset ()
	dw_1.ImportString (is_Library)
	dw_1.Sort ()
	dw_1.GroupCalc ()

	ls_dir = 'c:\aams\export\' + f_replace (ia_FileName [lf],'.pbl','')

	// Export the DataWindow object to string
	FOR  li = 1  TO  dw_1.rowcount ()
		dw_1.setrow (li)
		dw_1.scrolltorow (li)
		CHOOSE CASE LEFT (dw_1.object.name [li],2)
			CASE 'd_'
				ls_export = LibraryExport (is_FileName, dw_1.object.name [li], ExportDataWindow!)
		END CHOOSE

		IF	POS (ls_export,'ICAM.SR')>0	Then
			IF NOT DirectoryExists (ls_dir) THEN CreateDirectory (ls_dir)
			li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li], TextMode!, Write!, LockWrite!, Replace!)
			FileWriteEx (li_FileNum, ls_export)
			FileClose (li_FileNum)

			lw_row = f_get_array (ls_export, '~r~n', la_syntax)
			FOR  lw = lw_row  TO  1  STEP -1
				IF	f_null (la_syntax [lw])	Then
					lw_row --
				Else
					EXIT
				End IF
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'd_'
					ls_import = '$PBExportHeader$' + dw_1.object.name [li] + '.srd~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li],'') + '~r~n'
			END CHOOSE
			FOR  lw = 1  TO  lw_row
				IF	POS (la_syntax [lw],'ICAM.SR')>0 THEN la_syntax [lw] = f_replace (la_syntax [lw],'ICAM.SR','AAMS.SR')
				ls_import += RightTRIM (la_syntax [lw]) + '~r~n'
			NEXT
			CHOOSE CASE LEFT (dw_1.object.name [li],2)
				CASE 'd_'
					li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.name [li] + '.srd', TextMode!, Write!, LockWrite!, Replace!)
			END CHOOSE
			FileWriteEx (li_FileNum, ls_import)
			FileClose (li_FileNum)
		End IF
	NEXT
NEXT
end event

type cb_pgsql from pf_u_commandbutton within w_get_object
integer x = 1861
integer y = 20
integer width = 315
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
string text = "pgSQL"
end type

event clicked;call super::clicked;INT   li_FileNum, lf, li, lw, lw_row, ld, ld_cnt
LONG  lm, lm_word, in_bracket

BOOLEAN  lb_change

STRING   ls_dir, ls_export, la_syntax [], ls_import
STRING   ra_word [], ls_line, la_datetime []

la_datetime = {'seal_use.cre_dt','evaluate_emp.book_ip','seal_use.put_time','card_traffic.conf','evaluate_type_book.ip','holiday_plan.ymd','fw_docu_log.read_dtm','seal_bank.cre_dt','fw_user_mst.last_connect','holiday_plan.conf','seal_bank.req_time','seal_corp.put_time','seal_corp.cre_dt','card_traffic.ymd'}
ld_cnt      = UPPERBOUND (la_datetime)

IF NOT DirectoryExists ('c:\pgAFMS\export') THEN CreateDirectory ('c:\pgAFMS\export')

FOR  lf = 1  TO  UPPERBOUND (ia_FileName)
   yield ()
   IF UPPERBOUND (ia_FileName)=1 Then
      is_FileName = is_DirName
   ELSE
      is_FileName = is_DirName + '\' + ia_FileName [lf]
   END IF
   Parent.Title = is_FileName
   is_library   = LibraryDirectory (is_FileName, dirUserObject!)
   is_library   = is_Library + LibraryDirectory (is_FileName, dirWindow!)
   IF f_null (is_Library) THEN CONTINUE

   dw_1.Reset ()
   dw_1.ImportString (is_Library)
   dw_1.Sort ()
   dw_1.GroupCalc ()

   ls_dir = 'c:\pgAFMS\export\' + f_replace (ia_FileName [lf], '.pbl', '')

   // Export the DataWindow object to string
   FOR  li = 1  TO  dw_1.ROWCOUNT ()
      dw_1.SETROW (li)
      dw_1.scrolltorow (li)
      CHOOSE CASE LEFT (dw_1.object.NAME [li], 2)
         CASE 'u_'
            ls_export = LibraryExport (is_FileName, dw_1.object.NAME [li], ExportUserObject!)
         CASE 'w_'
            ls_export = LibraryExport (is_FileName, dw_1.object.NAME [li], ExportWindow!)
         CASE 'd_'
            ls_export = LibraryExport (is_FileName, dw_1.object.NAME [li], ExportDataWindow!)
      END CHOOSE

      IF NOT DirectoryExists (ls_dir) THEN CreateDirectory (ls_dir)
      li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.NAME [li], TextMode!, Write!, LockWrite!, Replace!)
      FileWriteEx (li_FileNum, ls_export)
      FileClose (li_FileNum)

      lw_row = f_get_array (ls_export, '~r~n', la_syntax)
      FOR  lw = lw_row  TO  1  STEP -1
         IF f_null (la_syntax [lw]) Then
            lw_row --
         ELSE
            EXIT
         END IF
      NEXT
      CHOOSE CASE LEFT (dw_1.object.NAME [li], 2)
         CASE 'w_'
            ls_import = '$PBExportHeader$' + dw_1.object.NAME [li] + '.srw~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li], '') + '~r~n'
         CASE 'u_'
            ls_import = '$PBExportHeader$' + dw_1.object.NAME [li] + '.sru~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li], '') + '~r~n'
         CASE 'd_'
            ls_import = '$PBExportHeader$' + dw_1.object.NAME [li] + '.srd~r~n$PBExportComments$' + f_nvl (dw_1.object.comment [li], '') + '~r~n'
      END CHOOSE
      FOR  lw = 1  TO  lw_row
         lm_word = gre.rt_line (la_syntax [lw], ra_word)
         IF LEFT (dw_1.object.NAME [li],2)='d_' Then
               IF POS (la_syntax [lw],'column=(type=datetime')>0  Then
                  lb_change = true
                  FOR  ld = 1  TO  ld_cnt
                     IF POS (la_syntax [lw], la_datetime [ld])>0  Then
                        lb_change = false
                        EXIT
                     END IF
                  NEXT
                  IF lb_change   Then
                     ls_import += f_replace (la_syntax [lw], 'column=(type=datetime', 'column=(type=date')
                  ELSE
                     ls_import += la_syntax [lw]
                  END IF
               ELSEIF POS (la_syntax [lw],', datetime)')>0  Then
                  ls_import += f_replace (la_syntax [lw], ', datetime)', ', date)')
               ELSE
                  ls_import += la_syntax [lw]
               END IF
         ELSE
            ls_line = ''
            FOR  lm = 1  TO  lm_word
               CHOOSE CASE lower (ra_word [lm])
                  CASE 'datetime'
                        ls_import += 'DATE'
                  CASE 'getitemdatetime'
                        ls_import += 'GETITEMDATE'
                  CASE 'nvl'
                        ls_import += 'coalesce'
                  CASE 'trunc'
                        ls_line    = ra_word [lm]
                        in_bracket = 0
                        FOR  lm = lm + 1  TO  lm_word
                           ls_line += ra_word [lm]
                           CHOOSE CASE lower (ra_word [lm])
                              CASE "'dd'", "'mm'", "'yy'"
                                 ls_line = f_replace1 (ls_line, 'trunc', 'F_DTRUNC')
                              CASE '('
                                 in_bracket ++
                              CASE ')'
                                 in_bracket --
                                 IF in_bracket=0 THEN EXIT
                           END CHOOSE
                        NEXT
                        ls_import += ls_line
                        ls_line   = ''
                     CASE ELSE
                        IF LEFT (ra_word [lm],4)='ldt_'  Then
                           ls_import += 'date_' + MID (ra_word [lm],5)
                        ELSE
                           ls_import += ra_word [lm]
                        END IF
               END CHOOSE
            NEXT
            IF f_notnull (ls_line)  Then
               ls_import += RIGHTTRIM (ls_line) + '~r~n'
            ELSE
               ls_import += '~r~n'
            END IF
         END IF
      NEXT
      CHOOSE CASE LEFT (dw_1.object.NAME [li], 2)
         CASE 'w_'
            li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.NAME [li] + '.srw', TextMode!, Write!, LockWrite!, Replace!)
         CASE 'u_'
            li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.NAME [li] + '.sru', TextMode!, Write!, LockWrite!, Replace!)
         CASE 'd_'
            li_FileNum = FileOpen (ls_dir + '\' + dw_1.object.NAME [li] + '.srd', TextMode!, Write!, LockWrite!, Replace!)
      END CHOOSE
      FileWriteEx (li_FileNum, ls_import)
      FileClose (li_FileNum)
   NEXT
NEXT
end event

