forward
global type pf_n_saveas from nonvisualobject
end type
end forward

global type pf_n_saveas from nonvisualobject autoinstantiate
end type

type prototypes

end prototypes

type variables
Private:
String	is_syntax = 'release 10.5;' + &
							'~ndatawindow(units=0 timer_interval=0 color=1073741824 processing=1 HTMLDW=no print.printername="" print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 96 print.margin.bottom = 96 print.paper.source = 0 print.paper.size = 0 print.canusedefaultprinter=yes print.prompt=no print.buttons=no print.preview.buttons=no print.cliptext=no print.overrideprintjob=no print.collate=yes print.preview.outline=yes hidegrayline=no grid.lines=0 )' + &
							'~nheader(height=84 color="536870912" )' + &
							'~nsummary(height=0 color="536870912" )' + &
							'~nfooter(height=0 color="536870912" )' + &
							'~ndetail(height=96 color="536870912" )' + &
							'~ntable({1}' + &
							'~n)' + &
							'~nhtmlgen(clientevents="1" clientvalidation="1" clientcomputedfields="1" clientformatting="0" clientscriptable="0" generatejavascript="1" encodeselflinkargs="1" netscapelayers="0" pagingmethod=0 generatedddwframes="1" )' + &
							'~nxhtmlgen() cssgen(sessionspecific="0" )' + &
							'~nxmlgen(inline="0" )' + &
							'~nxsltgen()' + &
							'~njsgen()' + &
							'~nexport.xml(headgroups="1" includewhitespace="0" metadatatype=0 savemetadata=0 )' + &
							'~nimport.xml()' + &
							'~nexport.pdf(method=0 distill.custompostscript="0" xslfop.print="0" )' + &
							'~nexport.xhtml()'

end variables

forward prototypes
private function string of_saveasex (string path, fw_u_dwo adw_source, string as_type)
public function string of_saveas (ref datawindow adw_source, boolean ab_tf)
public subroutine of_runexcel (string as_filepath)
end prototypes

private function string of_saveasex (string path, fw_u_dwo adw_source, string as_type);fw_n_dso	lds_excel, lds_sort
String		ls_colsyntax, ls_name, ls_temp, ls_visible
String		ls_coldata, ls_objects, ls_type, ls_coltype
Long			ll_cnt, i, j, ll_colcnt, ll_rtn, ll_cpu, ll_pos
Integer		li_row
Boolean		lb_edt

//-----------------------------------------------------------------------------
//	fw_n_dso를 설정한다.
//-----------------------------------------------------------------------------
ll_cpu = CPU()
lds_excel = CREATE fw_n_dso

fw_n_dso	lds_source 
lds_source = Create fw_n_dso

lds_sort	= Create fw_n_dso
lds_sort.DataObject = 'pf_d_saveas'

Blob	lblb_data
adw_source.getFullState(lblb_data)
lds_source.setFullState(lblb_data)
SetNull(lblb_data)

//Column Syntax 생성
adw_source.setRedRaw(false)
ls_objects = lds_source.Object.DataWindow.Objects 
IF ls_objects = "!" THEN
	MessageBox("Error", "관련 Object가 없습니다.")
	return ""
ELSE
	do while Len(ls_objects) > 0
		ll_pos = Pos(ls_objects, '~t')
		IF ll_pos = 0 THEN
			ls_temp		= ls_objects
			ls_objects 	= ''
		ELSE
			ls_temp 		= Left(ls_objects, ll_pos - 1)
			ls_objects	= Mid(ls_objects, ll_pos + Len('~t'))
		END IF
		
		ls_visible = lds_source.Describe(ls_temp + ".visible")
		ls_visible = fw_f_replaceall(ls_visible, '"', '')
		ls_visible = fw_f_replaceall(ls_visible, "'", "")
		ls_visible = Left(ls_visible, 1)
		
		If 	(lds_source.Describe(ls_temp + ".type") 	= "column" 	Or lds_source.Describe(ls_temp + ".type") 	= "compute"	) And (lds_source.Describe(ls_temp + ".band") 	= "detail" 	) And ( ls_visible = "1"	) Then
			li_row = lds_sort.Insertrow(0)
			lds_sort.SetItem(li_row, "objectname", ls_temp)
			lds_sort.SetItem(li_row, "objectpositionx", Long(lds_source.Describe(ls_temp + ".x")))
			
			ls_name = ls_temp
			
			//column일때..
			ls_temp = lds_source.Describe(ls_name + ".type")
			IF ls_temp = "column" THEN
				//++++++++++++++++++++++
				//dddw일때 length 주기
				ls_temp = Trim(lds_source.Describe(ls_name + ".DDDW.Name"))
				IF IsNull(ls_temp) THEN ls_temp = ''
				CHOOSE CASE ls_temp
					CASE '','!','?'
					CASE ELSE
						lb_edt = TRUE
						Datawindowchild	ldwc
						ls_temp 	= lds_source.Describe(ls_name + ".name")
						lds_source.GetChild(ls_temp, ldwc)
						ls_temp	= lds_source.Describe(ls_temp + ".DDDW.DisplayColumn")
						ls_temp  = ldwc.Describe(ls_temp + "ColType")
						CHOOSE CASE TRUE
							CASE Pos(Upper(ls_temp), 'CHAR', 1) > 0
								ls_temp	= Mid(ls_temp, Pos(ls_temp, "("), Pos(ls_temp, ")"))
							CASE Pos(Upper(ls_temp), 'ULONG', 1) > 0 OR Pos(Upper(ls_temp), 'INT', 1) > 0 OR Pos(Upper(ls_temp), 'LONG', 1) > 0 OR Pos(Upper(ls_temp), 'REAL', 1) > 0 OR Pos(Upper(ls_temp), 'NUMB', 1) > 0 
								ls_temp	= "23"
							CASE Pos(Upper(ls_temp), 'DATETIME', 1) = 0 AND Pos(Upper(ls_temp), 'DATE', 1) > 0
								ls_temp	= "10"
							CASE Pos(Upper(ls_temp), 'DATETIME', 1) > 0 
								ls_temp	= "23"
							CASE Pos(Upper(ls_temp), 'DECIMAL', 1) > 0
								ls_temp	= "23"
							CASE Pos(Upper(ls_temp), 'TIME', 1) > 0 OR Pos(Upper(ls_temp), 'TIMESTAMP', 1) > 0 
								ls_temp	= "12"
							CASE ELSE
								ls_temp = "100"
						END CHOOSE
				END CHOOSE
				
				//ddlb일때 length 주기
				IF Not lb_edt THEN
					ls_temp = Trim(lds_source.Describe(ls_name + ".DDLB.VScrollBar"))
					IF IsNull(ls_temp) THEN ls_temp = ''
					CHOOSE CASE ls_temp
						CASE '','!','?'
						CASE ELSE
							lb_edt = TRUE
							ls_temp = '50'
					END CHOOSE
				END IF
				
				//ddlb일때 length 주기
				IF Not lb_edt THEN
					ls_temp = Lower(Trim(lds_source.Describe(ls_name + ".Edit.CodeTable")))
					CHOOSE CASE ls_temp
						CASE 'yes','1'
							lb_edt = TRUE
							ls_temp = '50'
					END CHOOSE
				END IF
				
				//ddlb일때 length 주기
				IF Not lb_edt THEN
					ls_temp = Lower(Trim(lds_source.Describe(ls_name + ".EditMask.CodeTable")))
					CHOOSE CASE ls_temp
						CASE 'yes','1'
							lb_edt = TRUE
							ls_temp = '50'
					END CHOOSE
				END IF
				
				IF Not lb_edt THEN
					ls_coltype = upper(lds_source.Describe(ls_name + ".Coltype"))
					CHOOSE CASE TRUE
						CASE Pos(ls_coltype, 'CHAR', 1) > 0
							ls_temp	= Mid(ls_temp, Pos(ls_coltype, "(") + Len("("))
							ls_temp 	= Left(ls_temp, Pos(ls_coltype, ")") - Len(")"))
						CASE Pos(ls_coltype, 'ULONG', 1) > 0 OR Pos(ls_coltype, 'INT', 1) > 0 OR Pos(ls_coltype, 'LONG', 1) > 0 OR Pos(ls_coltype, 'REAL', 1) > 0 OR Pos(ls_coltype, 'NUMB', 1) > 0 
							ls_temp	= "23"
						CASE Pos(ls_coltype, 'DATETIME', 1) = 0 AND Pos(ls_coltype, 'DATE', 1) > 0
							ls_temp	= "10"
						CASE Pos(ls_coltype, 'DATETIME', 1) > 0 
							ls_temp	= "23"
						CASE Pos(ls_coltype, 'DECIMAL', 1) > 0 
							ls_temp	= "23"
						CASE Pos(ls_coltype, 'TIME', 1) > 0 OR Pos(ls_coltype, 'TIMESTAMP', 1) > 0 
							ls_temp	= "12"
						CASE ELSE
							ls_temp = "100"
					END CHOOSE
					lds_sort.setitem(li_row, 'columntype', ls_coltype)
					lds_sort.setItem(li_row, 'objecttype', 0)
				ELSE
					lds_sort.setItem(li_row, 'objecttype', 1)
				END IF
				//++++++++++++++++++++++
			ELSE
				lds_sort.setItem(li_row, 'objecttype', 0)
				ls_temp = "100"
			END IF
			lds_sort.setItem(li_row, 'objectlength', Long(ls_temp))
		End if
		
		lb_edt = false
	loop

	lds_sort.SetSort("objectpositionx asc")
	lds_sort.Sort()
	
	ll_colcnt = lds_sort.rowcount()
	for i = 1 to ll_colcnt
		ls_name = lds_sort.Object.objectname[i]
		IF lds_source.Describe(ls_name + "_t.text") <> "!" THEN 
			ls_name = lds_source.Describe(ls_name + "_t.text")
			ls_name = fw_f_replaceall(ls_name, " ", "")
			ls_name = fw_f_replaceall(ls_name, "~r", "")
			ls_name = fw_f_replaceall(ls_name, "~n", "")
			ls_name = fw_f_replaceall(ls_name, '"', "")
			ls_name = fw_f_replaceall(ls_name, "'", "")
			ls_name = fw_f_replaceall(ls_name, '(', "_")
			ls_name = fw_f_replaceall(ls_name, ')', "_")
			ls_name = fw_f_replaceall(ls_name, '.', "")
			ls_name = fw_f_replaceall(ls_name, "/", "_")
			ls_name = fw_f_replaceall(ls_name, "[", "_")
			ls_name = fw_f_replaceall(ls_name, "]", "_")
			
			// 숫자로 시작하는 타이틀의 경우 Create 할 때 Syntax 오류 발생됩니다
			if isnumber(left(ls_name, 1)) then
				ls_name = 'A' + ls_name
			end if
		END IF
		IF Len(Trim(ls_name)) = 0 THEN
			ls_name = lds_sort.Object.objectname[i]
		END IF
		ls_coltype = lds_sort.getitemstring(i, 'columntype')
		choose case left(ls_coltype, 4)
			case 'ULON', 'INT', 'INTE', 'LONG', 'REAL', 'NUMB', 'DEC', 'DECI'
				ls_colsyntax += '~ncolumn=(type=number updatewhereclause=yes name=' + ls_name + ' dbname="' + ls_name + '" )'
			case else
				ls_colsyntax += '~ncolumn=(type=char(' + String(lds_sort.object.objectlength[i]) + ') updatewhereclause=yes name=' + ls_name + ' dbname="' + ls_name + '" )'
		end choose
	next
END IF

ls_temp = is_syntax
ls_temp = fw_f_replaceall(ls_temp, "{1}", ls_colsyntax)

string ls_error
IF lds_excel.Create(ls_temp, ls_error) < 0 THEN
	::ClipBoard(ls_temp)
	MessageBox("Error", "SaveAs Data Create Failed : " + ls_error)
	adw_source.setRedRaw(true)
	return ""
END IF

//Data 생성
ll_cnt = lds_source.rowcount()
ll_colcnt = lds_sort.rowcount()

Integer li_filenum
String	ls_file

//ls_file = pf_f_getcurrentdir() + "\plugin\" + adw_source.dataobject + ".txt"
ls_file = pf_f_getcurrentdir() + "\" + adw_source.dataobject + ".txt"
li_filenum = FileOpen(ls_file, LineMode!, Write!, LockWrite!, Replace!)

FOR i = 1 TO ll_cnt
	String data
	//각 column별로 data를 넣는다.
	FOR j = 1 TO ll_colcnt
		ls_name = lds_sort.Object.objectname[j]
		IF lds_sort.Object.objecttype[j] = 1 THEN  //edit가 특수한 경우.
			ls_temp = lds_source.of_getEvaluate("LookupDisplay(" + lds_sort.Object.objectname[j] + ")", i)
		ELSE
			ls_temp = Upper(lds_source.Describe(lds_sort.Object.objectname[j] + ".Coltype"))
			CHOOSE CASE TRUE
				CASE Pos(Upper(ls_temp), 'CHAR', 1) > 0
					ls_temp	= lds_source.getItemString(i, string(lds_sort.Object.objectname[j]))
				CASE Pos(Upper(ls_temp), 'ULONG', 1) > 0 OR Pos(Upper(ls_temp), 'INT', 1) > 0 OR Pos(Upper(ls_temp), 'LONG', 1) > 0 OR Pos(Upper(ls_temp), 'REAL', 1) > 0 OR Pos(Upper(ls_temp), 'NUMB', 1) > 0 
					ls_temp	= String(lds_source.getItemNumber(i, string(lds_sort.Object.objectname[j])))
				CASE Pos(Upper(ls_temp), 'DATETIME', 1) = 0 AND Pos(Upper(ls_temp), 'DATE', 1) > 0
					ls_temp	= String(lds_source.getItemDate(i, string(lds_sort.Object.objectname[j])))
				CASE Pos(Upper(ls_temp), 'DATETIME', 1) > 0 
					ls_temp	= String(lds_source.getItemDateTime(i, string(lds_sort.Object.objectname[j])))
				CASE Pos(Upper(ls_temp), 'DECIMAL', 1) > 0
					ls_temp	= String(lds_source.getItemDecimal(i, string(lds_sort.Object.objectname[j])))
				CASE Pos(Upper(ls_temp), 'TIME', 1) > 0 OR Pos(Upper(ls_temp), 'TIMESTAMP', 1) > 0 
					ls_temp	= String(lds_source.getItemTime(i, string(lds_sort.Object.objectname[j])))
				CASE ELSE
					ls_temp = lds_source.getItemString(i, string(lds_sort.Object.objectname[j]))
			END CHOOSE
		END IF
		
		IF IsNull(ls_temp) THEN ls_Temp = ""
		ls_temp = fw_f_replaceall(ls_temp, '"', "'")
		ls_temp = '"' + ls_Temp + '"'
		IF j = 1 THEN
			ls_coldata = ls_temp
		ELSE
			ls_coldata += "~t" + ls_temp
		END IF
		Yield()
	NEXT
	
	FileWrite(li_filenum, ls_coldata)
	Yield()
	//f_set_message("Complete Row : " + String(i) + " / " + String(ll_cnt), "INFO", gw_mdi)
NEXT
FileClose(li_filenum)

adw_source.setRedRaw(true)

ll_rtn = lds_excel.importFile(ls_file)
FileDelete(ls_file)

IF ll_rtn < 0 THEN
	MessageBox("Error", "SaveAS Import File Failed : " + String(ll_cnt))
	return ""
END IF

//saveas
choose case as_type
		case 'TXT'
			lds_excel.SaveAs(Path, Text!,true)
		case 'XLS'
			lds_excel.SaveAs(path , Excel8! , true) // 테스트용으로 인쇄를 했다.
end choose	

DESTROY lds_excel
DESTROY lds_source

//f_set_message("Complete Success : " + String((CPU() - ll_cpu) / 1000) , "INFO", gw_mdi)

return path

end function

public function string of_saveas (ref datawindow adw_source, boolean ab_tf);///////////////////////////////////////////////////////////////////////////////
//
//	FUNCTION		:	of_DwToExcel
//
//	DESCRIPTION : Excel파일로 자료를 저장한다.
//
//  RETURN			: String , Excel 파일경로 (정상적으로 처리되지 않으면 공백)
//
//	ARGUMENTS							  DESCRIPTION
//  -----------------------------------------------------------------------
//	adw_source							source datawindow
//
///////////////////////////////////////////////////////////////////////////////
//
//
///////////////////////////////////////////////////////////////////////////////
String	path, file, ls_type
Integer	li_rc
Boolean	lb_fileexist

String ls_current
//---------------------------------------------------------------------------------
ls_current = getcurrentdirectory()
li_rc =  GetFileSaveName('저장할 파일명', path, File, 'xls', &
						 'Excel Files (*.xls),*.xls,' + &
						 'Text Files (*.txt),*.txt,'  + &
                   'wmf Files (*.Wmf),*.wmf,'  + &	
                   'html Files (*.html),*.html,'  + &	
                    'Psr Files (*.psr),*.psr') 
changedirectory(ls_current)						  
IF li_rc = 1 THEN
   lb_fileexist = FileExists(path)
	 
	 IF lb_fileexist THEN
		
		  li_rc = MessageBox("파일저장" , path + "파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
			
			IF li_rc = 2 THEN 
				 RETURN ""
			END IF
 	 END IF
	 
	 SetPointer(HourGlass!)
	 //TXT or EXCEL로 처리시 2000건 이상인경우는 해당dw의 내용 그대로 처리
	 //2000이하의 경우 한글 타이틀,dddw,ddlb등의 한글처리함.
	 ls_type = upper(trim(right(path,3))) 
	 choose case ls_type
		case 'TXT'
			IF adw_source.rowcount() > 2000 OR (Not ab_tf) THEN
				adw_source.SaveAs(Path, TEXT!, TRUE)
			ELSE
				path = of_saveasex(path, adw_source, ls_type)
			END IF
		CASE 'XLS'
			IF adw_source.rowcount() > 2000 OR (Not ab_tf) THEN
				adw_source.SaveAs(Path, Excel8!, TRUE)
			ELSE
				path = of_saveasex(path, adw_source, ls_type)
			END IF
		case 'PSR'
			adw_source.SaveAs(Path, PSReport!, false)
		case 'WMF'
			adw_source.SaveAs(Path, WMF!, false)
		case 'TML'
			adw_source.SaveAs(Path, HTMLTABLE!, false)
	end choose	
	 RETURN path
ELSE
	 RETURN ""
END IF

RETURN path

end function

public subroutine of_runexcel (string as_filepath);///////////////////////////////////////////////////////////////////////////////
//
//	FUNCTION		:	of_RunExcel
//
//	DESCRIPTION : Excel 프로그램을 실행한다.
//
//  RETURN			: Int , 결과값 ( 1 - 성공 , -1 - 실패 )
//
//	ARGUMENTS							  DESCRIPTION
//  -----------------------------------------------------------------------
//  as_filepath							실행시킬 파일경로
//
///////////////////////////////////////////////////////////////////////////////
//
//	last modified at 2000-07-07 by karma223 (karma223@netsgo.com)
//
///////////////////////////////////////////////////////////////////////////////
constant long SW_SHOWNORMARL = 1

String 	ls_nulstring

SetNull(ls_nulstring)
gnv_extfunc.ShellExecute(0, ls_nulstring, as_filepath, ls_nulstring, ls_nulstring, SW_SHOWNORMARL)

end subroutine

on pf_n_saveas.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pf_n_saveas.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

