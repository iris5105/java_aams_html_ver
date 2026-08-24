forward
global type u_rd from pf_u_olecustomcontrol
end type
end forward

global type u_rd from pf_u_olecustomcontrol
integer width = 411
integer height = 384
boolean border = true
borderstyle borderstyle = stylebox!
string binarykey = "u_rd.udo"
integer textsize = -10
fontcharset fontcharset = hangeul!
long textcolor = 33554432
event downloadfinished ( )
event ocx_clicked ( )
event nextpagebuttonclicked ( )
event lastpagebuttonclicked ( )
event firstpagebuttonclicked ( )
event prevpagebuttonclicked ( )
event filesaveas ( )
event zoomin ( )
event zoomout ( )
event printsetupbuttonclicked ( )
event printbuttonclicked ( )
event firstpagebuttonfinished ( )
event filesaveasfinished ( )
event lastpagebuttonfinished ( )
event nextpagebuttonfinished ( )
event prevpagebuttonfinished ( )
event printbuttonfinished ( long g_pfinish )
event printsetupbuttonfinished ( )
event zoominfinished ( )
event zoomoutfinished ( )
event viewexcelfinished ( )
event fileopenfinished ( )
event httpdatafilesaved ( string filename )
event hlinkclicked ( string sztarget,  string szurl,  string szparams )
event zoomdefault ( )
event zoomdefaultfinished ( )
event zoompage ( )
event zoompagefinished ( )
event serverprintfinished ( long nprintfinish )
event nextdocbuttonclicked ( )
event prevdocbuttonclicked ( )
event nextdocbuttonfinished ( )
event prevdocbuttonfinished ( )
event nodatareturnedfromquery ( )
event reportfinished ( )
event viewhwpfinished ( )
event savefilefinished ( string szfilename,  long ltype )
event printfinished ( )
event savesubpagesfinished ( string szfilename,  long current,  long total )
event viewpdffinished ( )
event viewpptfinished ( )
event viewwordfinished ( )
event printresult ( long lret )
event notmatchprinter ( string szprintername )
event posprintresult ( long lret )
event tfprintresult ( long npage,  long nline )
event toolbarbuttonclicked ( long nbuttonid )
event rdontrace ( string szrdontrace )
event savefirstpagefinished ( string szfilename,  long npageno )
event savelastpagefinished ( string szfilename,  long npageno )
event savepagefinished ( string szfilename,  long npageno )
event chartonmouseseries ( string szlabel,  string szlegend,  string szval )
event chartclickseries ( string szlabel,  string szlegend,  string szval )
event wafocusout ( )
event logtrace ( long nloglevel,  string szlogmessage )
event printfinishedex ( string szprintername,  string szdrivername,  long nnumcopy,  long npagecount,  long nresult,  string szreserved )
event openpopupwindow ( string url,  long top,  long left,  long ocx_width,  long ocx_height )
event submitfinished ( long lret,  string szerror,  string szreserved )
event writemmldocumentmsg ( string szmmlstring )
event writemmlfinished ( long mmlnumpage )
event wafocusoutex ( long keykind,  string szreserved )
event ue_setprint ( )
event ue_print ( )
event ue_retrieve ( integer row )
end type
global u_rd u_rd

type variables
BOOLEAN	eb_OnePage = FALSE      // 한페이지 인쇄
BOOLEAN	eb_MakeTree = FALSE     // 목차
BOOLEAN	eb_DirectPrint = FALSE  // 바로찍기
BOOLEAN	eb_openpagerd = FALSE
//개발자 초기(Early) 설정값

INT   ii_zoomRatio = 120
//INT ii_PageSize = 1    // 용지 크기. 0-A3, 1-A4, 2-B4, 3-B5, 4-LETTER, 5-136, 6-80, 7-A1, 8- A2, 9-A5, 10-사용자정의
INT   ii_PageType = 1 // 페이지 모아찍기. 1-1 페이지, 2-2 페이지, 4-4 페이지, 6-6 페이지, 8-8 페이지

STRING	is_MAKE, is_rt_key

n_menu	inv_menu
window	iw_parent
string	iswindowtype
end variables
forward prototypes
public subroutine uf_fileopen (string file_name, string parm)
public subroutine uf_xls (string arg_file)
public subroutine uf_pdf (string arg_file)
public subroutine uf_xlsx (string arg_file)
end prototypes

event printsetupbuttonclicked();event ue_setprint ()
end event

event fileopenfinished();inv_menu = iw_parent.dynamic of_getwindowmenu()
iswindowtype = iw_parent.dynamic of_getwindowtype()
fw_f_setlog4pgm('sy1001013', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, iswindowtype, '', 'rd')
end event

event reportfinished();IF	eb_openpagerd THEN f_loadingrd (false)
Enabled = TRUE
end event

event ue_print();IF eb_onepage   Then
   f_messageBox ('I001','OnePage 설정을 해제 하십시오.')
   POST SetFocus ()
   RETURN
End IF

inv_menu = iw_parent.dynamic of_getwindowmenu()
iswindowtype = iw_parent.dynamic of_getwindowtype()
fw_f_setlog4pgm('sy1001012', inv_menu.is_pgm_no, inv_menu.is_pgm_id, inv_menu.is_pgm_nm, 'main', '', 'rd')

event ue_setprint ()
Object.CMPrint ()
POST SetFocus ()
end event

event ue_retrieve(integer row);setredraw (false)
IF	eb_openpagerd THEN f_loadingrd (true)
//uf_fileopen ('rd_.mrd', &
//                 'ymd[' + string (dw_c.object.ymd [1],'yyyy.mm.dd') + '] ' + &
//             'fund_cd[' + dw_list.object.fund_cd [row] + '] ' + &
//             'work_gb[' + f_nvl(dw_list.object.work_gb [row],'A') + ']' )

end event

public subroutine uf_fileopen (string file_name, string parm);IF f_null (parm) THEN RETURN

STRING	default_parm = '/rpguideline [1] /rprnjangopt ', ls_open_file

IF eb_OnePage  THEN default_parm += '/ronepgrpt /rremakerpt '
IF eb_MakeTree THEN default_parm += '/rmaketree '

ls_open_file = file_name
IF NOT FileExists (gnv_vari.basepath + '\RD\' + ls_open_file)  Then
   IF POS (lower (ls_open_file),'_' + LEFT (gaa.CORP_GR,4) + '.mrd')>0 THEN ls_open_file=f_replace (ls_open_file,'_' + LEFT (gaa.CORP_GR,4),'_common')
END IF

default_parm += '/rv footer[kfp:' + ls_open_file + ' ' + gnv_vari.is_user_nm + '] company[' + gaa.CORP_NM + '] '
IF POS (parm,'corp_gr[')=0 THEN default_parm += 'corp_gr[' + gaa.CORP_GR + '] '
IF POS (parm,'rt_key[')=0  Then
   IF f_null (is_rt_key)   Then
      SELECT f_systimestamp INTO :is_rt_key FROM DUAL;
      is_rt_key = SQLCA.GETITEMSTRING (1)
   END IF
   default_parm += 'rt_key[' + gaa.CORP_GR + gnv_vari.is_user_id + is_rt_key + '] '
END IF
default_parm += parm

// DataBase Connect 정보
Object.fileopen (gnv_vari.basepath + '\RD\' + ls_open_file, '/rcontype [Data Server] /rf [http://app.aams.kr:8080/DataServer/rdagent.jsp] /rsn [KFP] ' + default_parm)
// IF  gaa.login='yjs1992@hitel.net' THEN ::clipboard (gnv_vari.basepath + '\RD\' + ls_open_file + ' :: /rcontype [Data Server] /rf [http://app.aams.kr:8080/DataServer/rdagent.jsp] /rsn [KFP] ' + default_parm)

Object.FirstPage ()

IF eb_DirectPrint Then // default_parm += '/rop '
   IF Object.GetTotalPageNo ()=1 THEN Object.SetPrint2 (1, 1, 1, 100) &
     ELSE Object.SetPrint2 (1, ii_PageType, 1, 100)
   EVENT ue_print ()
END IF
end subroutine

public subroutine uf_xls (string arg_file);Object.SetSaveExcelOption (1)
IF	FileExists(arg_file) THEN FileDelete(arg_file)
Object.SaveAsXlsFile (arg_file)
end subroutine

public subroutine uf_pdf (string arg_file);Object.SetSaveExcelOption (1)
IF	FileExists(arg_file) THEN FileDelete(arg_file)
Object.SaveAsPdfFile (arg_file)
end subroutine

public subroutine uf_xlsx (string arg_file);Object.SetSaveExcelOption (1)
IF	FileExists(arg_file) THEN FileDelete(arg_file)
Object.SaveAsXlsxFile (arg_file)
end subroutine

on u_rd.create
call super::create
end on

on u_rd.destroy
call super::destroy
end on

event constructor;Object.ApplyLicense ('http://app.aams.kr:8080/DataServer/rdagent.jsp')
Object.AutoAdjust = 0
Object.HideStatusBar ()
Object.ViewShowMode (1)
IF NOT eb_MakeTree THEN Object.DisableToolbar (3)
IF eb_MakeTree     THEN Object.ShowTreeWindow = 1  // 목차필드 지정 RD

Object.IsShowDlg = 0
Object.ZoomRatio = ii_zoomRatio

// Get Parent Window
iw_parent = fw_f_obj4parentwindow(this)
end event

