forward
global type fw_w_exportfile from window
end type
type dw_exportfile from fw_u_dwo within fw_w_exportfile
end type
type dw_excel from fw_u_dwo within fw_w_exportfile
end type
end forward

global type fw_w_exportfile from window
integer x = 1111
integer y = 852
integer width = 1477
integer height = 512
windowtype windowtype = child!
long backcolor = 16777215
event ue_postopen ( )
dw_exportfile dw_exportfile
dw_excel dw_excel
end type
global fw_w_exportfile fw_w_exportfile

type variables
STRING	iscase = '2'
STRING	is_processing
BOOLEAN	CloseCheck = TRUE

window         iw_parentwindow
datawindow  idw_data

fw_s_exportfile   istr_exportfile
end variables

forward prototypes
public subroutine wf_dw2xls ()
public function long wf_getmaxposx ()
public subroutine wf_setcreatedwbyoutobj ()
public function integer of_setinit ()
public subroutine of_setcheckclose ()
end prototypes

event ue_postopen();This.SetRedRaw(TRUE)

IF of_setinit()=-1   Then RETURN

dw_exportfile.Setfocus()
end event

public subroutine wf_dw2xls ();//STRING	ls_xlsxFile, ls_name
//STRING	ls_currentdir
//INTEGER	li_ret
//
//n_dwr_service_parm lnvo_parm
//lnvo_parm = CREATE n_dwr_service_parm
//
//// penta
//lnvo_parm.ib_grid_line = TRUE
///////////////
//lnvo_parm.is_version = 'OOXML'
////lnvo_parm.ib_keep_band_height = true
//lnvo_parm.ib_foreground = FALSE
//lnvo_parm.ib_background = FALSE
//lnvo_parm.ib_hide_grid = FALSE
////lnvo_parm.id_min_width = 0.5
////lnvo_parm.is_title_font = '맑은 고딕'
////lnvo_parm.il_title_font_size = 11
////lnvo_parm.ib_lines = true
////lnvo_parm.ib_rectangles = true
//
////lnvo_parm.ib_background_color = false
//
////lnvo_parm.ib_header = false         //skip header band
////lnvo_parm.ib_summary = false        //skip summary band
////lnvo_parm.ib_footer = false         //skip footer band
////lnvo_parm.ib_group_header = false   //skip all group headers
////lnvo_parm.ib_group_trailer = false  //skip all group trailers
//
//ls_currentdir = GetCurrentDirectory()
//ChangeDirectory('C:\')  /* 특정 폴더로 먼저 이동 할 시 */
//IF GetFileSaveName("Select File",ls_xlsxFile, ls_name, "xlsx","Excel Files (*.xlsx), *.xlsx")<>1 THEN
//   ChangeDirectory(ls_currentdir)
//   RETURN
//End IF
//Choose CASE is_processing
//   CASE '0', '1'
//      li_ret = uf_save_dw_as_excel_parm(dw_excel, ls_xlsxFile, lnvo_parm)
//   CASE Else
//      li_ret = uf_save_dw_as_excel_parm(idw_data, ls_xlsxFile, lnvo_parm)
//End Choose
//
//ChangeDirectory(ls_currentdir)
//IF li_ret=1 Then
//   //success
//   POST CLOSE(THIS)
//else
//   //fail
//   //...
//End IF
//


end subroutine

public function long wf_getmaxposx ();STRING	ls_object, ls_objarr[]
LONG	i, ll_objcnt
LONG	ll_objpos, ll_maxpos = 0
LONG	ll_bandheight, ll_ypos
STRING	ls_band

ls_object = dw_excel.describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])

for i = 1 to ll_objcnt
   IF fw_f_rtnbackgrobjchk(ls_objarr[i])=-1  Then Continue
   ls_band = dw_excel.Describe(ls_objarr[i] + ".Band")
   IF ls_band='header'  Then
      /* to-be controls YPosition이 해당 band 밑에 있으면 Continue */
      ll_bandheight  = long(dw_excel.Describe("DataWindow." + ls_band + ".Height"))
      ll_ypos        = long(dw_excel.Describe(ls_objarr[i] + ".y"))
      IF ll_bandheight<=ll_ypos  Then Continue
      IF dw_excel.Describe(ls_objarr[i] + ".Visible")='1'   Then
         ll_objpos = long(dw_excel.Describe(ls_objarr[i] + ".X")) + long(dw_excel.Describe(ls_objarr[i] + ".Width"))
         IF ll_maxpos<ll_objpos  Then
            ll_maxpos   = ll_objpos
         End IF
      End IF
   End IF
next

RETURN ll_maxpos

end function

public subroutine wf_setcreatedwbyoutobj ();STRING	ls_object, ls_objarr[]
STRING	ls_dwsyntax
LONG	i, ll_objcnt
LONG	ll_objpos, ll_maxpos = 0
LONG	ll_bandheight, ll_ypos

ls_object = dw_excel.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])

for i = 1 to ll_objcnt
   IF fw_f_rtnbackgrobjchk(ls_objarr[i])=-1  Then
      dw_excel.Modify(ls_objarr[i] + ".Width='1'")
      dw_excel.Modify(ls_objarr[i] + ".Visible='0'")
   End IF
next

//ls_dwsyntax = dw_excel.Describe("DataWindow.Syntax")
//If Pos(ls_dwsyntax, ' If(currentRow()=getrow(), 4, 0)') > 0 Then
// ls_dwsyntax = fw_f_replaceall(ls_dwsyntax, ' If(currentRow()=getrow(), 4, 0)', '')
//End If
//
//If dw_excel.Create( ls_dwsyntax ) <> 1 Then
// Messagebox('Error', 'DataWindow Create fail')
// Close(This)
//End If
end subroutine

public function integer of_setinit ();IF not isvalid(idw_data) Then
   Messagebox('Notice(pf_w_exportfile)', 'DataWindow가 없습니다.')
   CLOSE(THIS )
   RETURN -1
End IF

IF idw_data.rowcount ()<1  Then
   Messagebox('Notice(pf_w_exportfile)', '데이터가 없습니다.')
   CLOSE(THIS )
   RETURN -1
End IF

is_processing = idw_data.Describe("DataWindow.Processing")
Choose CASE is_processing
   CASE '0', '1', '4'
      dw_excel.dataobject = idw_data.dataobject
      dw_excel.CREATE(idw_data.Describe("DataWindow.Syntax") )
      dw_excel.of_setcreatehandle()
      idw_data.ShareData(dw_excel)
   CASE Else
      Messagebox('Check', '지원하지 않은 양식입니다.')
End Choose

end function

public subroutine of_setcheckclose ();// CloseCheck ture 종료
IF CloseCheck=TRUE   Then POST CLOSE(THIS)
end subroutine

on fw_w_exportfile.create
this.dw_exportfile=create dw_exportfile
this.dw_excel=create dw_excel
this.Control[]={this.dw_exportfile,&
this.dw_excel}
end on

on fw_w_exportfile.destroy
destroy(this.dw_exportfile)
destroy(this.dw_excel)
end on

event open;LONG	ll_xpos, ll_ypos

istr_exportfile = Message.PowerObjectParm
idw_data = istr_exportfile.dw_obj

IF of_setinit()=-1   Then RETURN

iw_parentwindow = istr_exportfile.w_obj

IF not isvalid(iw_parentwindow)  Then
   Messagebox('Notice(fw_w_exportfile)', '부모 윈도우를 찾을 수 없습니다.')
   RETURN
End IF
IF not isvalid(istr_exportfile.pic_obj)   Then
   Messagebox('Notice', 'Picture상태에서만 진행됩니다.')
   RETURN
End IF

ll_xpos = gw_mdi.st_mdiclient.x + istr_exportfile.pic_obj.x - This.width + istr_exportfile.pic_obj.width
ll_ypos = gw_mdi.st_mdiclient.y + istr_exportfile.pic_obj.y + istr_exportfile.pic_obj.height

IF ll_ypos + This.height>iw_parentwindow.workspaceheight()  Then ll_ypos -= This.height

This.x = ll_xpos
This.y = ll_ypos

IF gnv_vari.getclienttype='WEB'  Then This.Height -= pixelstounits(1, ypixelstounits!)

dw_exportfile.insertrow (0)

POST EVENT ue_postopen()

end event

type dw_exportfile from fw_u_dwo within fw_w_exportfile
integer x = 5
integer y = 4
integer width = 1458
integer height = 496
integer taborder = 30
string dataobject = "fw_d_exportfile"
boolean livescroll = false
end type

event losefocus;call super::losefocus;POST of_setcheckclose()
end event

event clicked;call super::clicked;IF row<1   Then RETURN

Choose CASE dwo.name
   CASE 'p_ok'
      STRING	ls_currentdir, ls_pdfFile, ls_name, ls_pgm_no
      CloseCheck = FALSE /* CloseCheck */
      IF of_setinit()=-1   Then RETURN
      ls_pgm_no = iw_parentwindow.dynamic of_getpgmno()
      Choose CASE iscase
         CASE '1'
            wf_dw2xls()
         CASE '2'
            wf_setcreatedwbyoutobj() // 이미지 및 불필요한 obj 정리
            Choose CASE is_processing
               CASE '0', '1'
                  dw_excel.of_setsaveas4excel(TRUE)
               CASE '4'
                  idw_data.dynamic of_setsaveas4excel(TRUE)
            End Choose

            POST CLOSE(parent)
         CASE '3'
            ls_currentdir = GetCurrentDirectory()
            ChangeDirectory('C:\')  /* 특정 폴더로 먼저 이동 할 시 */

            IF GetFileSaveName("Select File",ls_pdfFile, ls_name, "PDF","PDF Files (*.PDF), *.PDF")<>1 THEN
               ChangeDirectory(ls_currentdir)
               RETURN -1
            End IF
            ChangeDirectory(ls_currentdir)
            IF dw_excel.SaveAs(ls_pdfFile, PDF!, FALSE)<>1  Then
               Messagebox('Error', 'PDF전환 실패')
            End IF

//          dw_excel.Object.DataWindow.Export.PDF.Method = NativePDF!
//          If dw_excel.SaveAs(ls_pdfFile, PDF!, true) <> 1 Then
//             Messagebox('Error', 'PDF전환 실패')
//          End If
            POST CLOSE(parent)
      End Choose
   CASE 'p_close'
      CLOSE(Parent )
End Choose

end event

event itemchanged;call super::itemchanged;IF row < 1 Then Return
IF AncestorReturnValue=1 THEN RETURN 1

Choose Case dwo.name
   Case 'export_gb'
      Choose Case string(data)
         Case '1'
            iscase = '1'
         Case '2'
            iscase = '2'
         Case '3'
            iscase = '3'
      End Choose
End Choose
end event

type dw_excel from fw_u_dwo within fw_w_exportfile
integer x = 101
integer y = 3000
integer width = 229
integer height = 164
boolean hscrollbar = true
boolean applydesign = true
end type

