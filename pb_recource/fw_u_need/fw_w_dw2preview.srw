forward
global type fw_w_dw2preview from w_response1st
end type
type em_copies from editmask within fw_w_dw2preview
end type
type st_copies from statictext within fw_w_dw2preview
end type
type em_zoomrate from editmask within fw_w_dw2preview
end type
type st_zoomrate from statictext within fw_w_dw2preview
end type
type em_prerate from editmask within fw_w_dw2preview
end type
type st_zoomtitle from statictext within fw_w_dw2preview
end type
type st_previewtitle from statictext within fw_w_dw2preview
end type
type p_upsize from pf_u_imagebutton within fw_w_dw2preview
end type
type p_downsize from pf_u_imagebutton within fw_w_dw2preview
end type
type st_p from statictext within fw_w_dw2preview
end type
type p_file from pf_u_imagebutton within fw_w_dw2preview
end type
type p_close from pf_u_imagebutton within fw_w_dw2preview
end type
type p_lastpage from pf_u_imagebutton within fw_w_dw2preview
end type
type p_nextpage from pf_u_imagebutton within fw_w_dw2preview
end type
type p_priorpage from pf_u_imagebutton within fw_w_dw2preview
end type
type p_firstpage from pf_u_imagebutton within fw_w_dw2preview
end type
type uc_printsize from pf_u_commandbutton within fw_w_dw2preview
end type
type uc_preview from pf_u_commandbutton within fw_w_dw2preview
end type
type print_setup from singlelineedit within fw_w_dw2preview
end type
type uc_printersetup from pf_u_commandbutton within fw_w_dw2preview
end type
type r_2 from rectangle within fw_w_dw2preview
end type
type st_title from statictext within fw_w_dw2preview
end type
type st_10 from statictext within fw_w_dw2preview
end type
type st_9 from statictext within fw_w_dw2preview
end type
type cbx_tot from checkbox within fw_w_dw2preview
end type
type ddlb_way from dropdownlistbox within fw_w_dw2preview
end type
type ddlb_paper from dropdownlistbox within fw_w_dw2preview
end type
type st_6 from statictext within fw_w_dw2preview
end type
type sle_rang from singlelineedit within fw_w_dw2preview
end type
type dw_print from fw_u_dwo within fw_w_dw2preview
end type
type hsb_1 from hscrollbar within fw_w_dw2preview
end type
type hsb_zoom from hscrollbar within fw_w_dw2preview
end type
type st_prerate from statictext within fw_w_dw2preview
end type
type st_2 from statictext within fw_w_dw2preview
end type
type st_3 from statictext within fw_w_dw2preview
end type
type r_5 from rectangle within fw_w_dw2preview
end type
type r_6 from rectangle within fw_w_dw2preview
end type
type r_1 from rectangle within fw_w_dw2preview
end type
type r_7 from rectangle within fw_w_dw2preview
end type
type r_3 from rectangle within fw_w_dw2preview
end type
type r_4 from rectangle within fw_w_dw2preview
end type
type p_print from pf_u_imagebutton within fw_w_dw2preview
end type
type r_8 from rectangle within fw_w_dw2preview
end type
type st_pagecnt from statictext within fw_w_dw2preview
end type
type r_9 from rectangle within fw_w_dw2preview
end type
end forward

global type fw_w_dw2preview from w_response1st
integer width = 5467
integer height = 3172
long backcolor = 33554431
event pfe_postopen ( )
em_copies em_copies
st_copies st_copies
em_zoomrate em_zoomrate
st_zoomrate st_zoomrate
em_prerate em_prerate
st_zoomtitle st_zoomtitle
st_previewtitle st_previewtitle
p_upsize p_upsize
p_downsize p_downsize
st_p st_p
p_file p_file
p_close p_close
p_lastpage p_lastpage
p_nextpage p_nextpage
p_priorpage p_priorpage
p_firstpage p_firstpage
uc_printsize uc_printsize
uc_preview uc_preview
print_setup print_setup
uc_printersetup uc_printersetup
r_2 r_2
st_title st_title
st_10 st_10
st_9 st_9
cbx_tot cbx_tot
ddlb_way ddlb_way
ddlb_paper ddlb_paper
st_6 st_6
sle_rang sle_rang
dw_print dw_print
hsb_1 hsb_1
hsb_zoom hsb_zoom
st_prerate st_prerate
st_2 st_2
st_3 st_3
r_5 r_5
r_6 r_6
r_1 r_1
r_7 r_7
r_3 r_3
r_4 r_4
p_print p_print
r_8 r_8
st_pagecnt st_pagecnt
r_9 r_9
end type
global fw_w_dw2preview fw_w_dw2preview

type variables
datawindow	idw_print
fw_s_parent		istr_parent

String			isdefault2processing = '0'
Long 			il_return
Boolean		ib_unicode = false

 /* column width :  max column */
String		iwidthcolumn = ''
Long		iobjcnt	= 0
Long		imaxpos	= 0
end variables

forward prototypes
public subroutine wf_setdddw ()
public subroutine of_getdwomaxwidth ()
public subroutine of_pagecnt ()
public subroutine wf_setobject2process ()
end prototypes

public subroutine wf_setdddw ();STRING	ls_temp, ls_colname, ls_objs
STRING	ls_objects[]
LONG	ll_colcnt, i, ll_objcnt
DataWindowChild   ldc_data

//dw_print.dddw(ls_colname, {''})

fw_n_dso   lds_temp
lds_temp = CREATE fw_n_dso

//column count를 가지고 오면 Copy한 Colum인경우 찾기 힘들다.
//그래서 Objects를 가지고 함.
ls_objs     = dw_print.Object.Datawindow.Objects
ll_objcnt   = fw_f_obj2array(ls_objs, "~t", ls_objects[])

for i = 1 to ll_objcnt
   ls_colname  = ls_objects[i]
   ls_temp     = dw_print.Describe(ls_colname + ".Type")
   IF Not (ls_temp='?' OR ls_temp='!' OR ls_temp='') THEN
      IF ls_temp='column' THEN
         ls_temp = dw_print.Describe(ls_colname +".dddw.name")
         IF Not (ls_temp='?' OR ls_temp='!' OR ls_temp='') THEN
            lds_temp.Dataobject = ls_temp
            ls_temp = lds_temp.Describe("Datawindow.table.arguments")
            IF ls_temp='?' THEN
               IF dw_print.GetChild(ls_colname, ldc_data )=1 THEN
                  IF ldc_data.rowcount ()=0 THEN
                     //ldc_data.Retrieve()

//fw_n_dso ds
//
//ds = Create fw_n_dso
//ds.DataObject = adw_dw.Describe((as_col + ".dddw.name"))
//ds.SetTransObject (sqlca)
//
//ll_RowCount = mo_.jtier_retrieve (ds, as_arg[], sqlca)
//IF  ll_RowCount=0 THEN ll_RowCount = ds.insertRow (0)
//
//ds.RowsCopy (1, ll_RowCount, Primary!, adwc_dddw, 1, Primary!)
//
//Destroy ds


                  End IF
               End IF
            End IF
         End IF
      End IF
   End IF
next
end subroutine

public subroutine of_getdwomaxwidth ();string ls_object, ls_objarr[]
long	i, ll_objcnt
long	ll_objpos, ll_maxpos = 0
Long	ll_bandheight, ll_ypos
string	ls_band

ls_object = dw_print.Describe("Datawindow.Objects")
ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])

iobjcnt = ll_objcnt /*  Column Count Setting */

for i = 1 to iobjcnt
	If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then Continue
	Choose Case dw_print.Describe(ls_objarr[i] + ".Type")
		Case '?', '!'
			Continue
	End Choose
		ll_ypos			= Long(dw_print.Describe(ls_objarr[i] + ".y"))
		If dw_print.Describe(ls_objarr[i] + ".Visible") = '1' Then
			ll_objpos = long(dw_print.Describe(ls_objarr[i] + ".X")) + long(dw_print.Describe(ls_objarr[i] + ".Width")) + Long(PixelsToUnits(1, XPixelsToUnits!))
			If ll_maxpos < ll_objpos Then
				ll_maxpos		= ll_objpos
				iwidthcolumn	= ls_objarr[i]
				imaxpos			= ll_maxpos
			End If
		End If
next
end subroutine

public subroutine of_pagecnt ();st_pagecnt.text = dw_print.Describe("evaluate('PageCount()', 0)")

end subroutine

public subroutine wf_setobject2process ();string		ls_object, ls_objarr[]
string		ls_dwsyntax, ls_error
string		ls_band, ls_objtype, ls_designstyle
long		i, ll_objcnt
long		ll_objpos, ll_maxpos = 0
long		ll_bandheight, ll_ypos
Boolean	lb_setlist4clearselect = false

If idw_print.TriggerEvent('oue_components') = 1 Then
	ls_designstyle = idw_print.dynamic of_getdesignstyle()
	If fw_f_nvls(ls_designstyle, '') = '' Then ls_designstyle = 'empty'
	Choose Case ls_designstyle
		Case 'grid', 'tabular'
			If idw_print.dynamic of_getibsetlist4clearselect() = true Then lb_setlist4clearselect = true
	End Choose
End If
ls_dwsyntax = ''
If lower(dw_print.describe("DataWindow.Print.Preview")) <> 'yes' Then
	ls_dwsyntax += "DataWindow.Print.Preview.Rulers = 'Yes'~r~nDataWindow.Print.Preview = 'Yes'~r~n"
End If
If ls_designstyle <> 'empty' Then
	ls_object = dw_print.Describe("Datawindow.Objects")
	ll_objcnt = fw_f_obj2array(ls_object, '~t', ls_objarr[])
	for i = 1 to ll_objcnt
		If fw_f_rtnbackgrobjchk(ls_objarr[i]) = -1 Then
			ls_dwsyntax += ls_objarr[i] + ".Width='1'~r~n"
			ls_dwsyntax += ls_objarr[i] + ".Visible='0'~r~n"
		End If	
		If lb_setlist4clearselect = false Then
			ls_band = dw_print.describe(ls_objarr[i] + ".Band")
			ls_objtype = dw_print.describe(ls_objarr[i] + ".Type")
			If ls_band =  'header' and (ls_objtype = "column" or ls_objtype = "text" or ls_objtype = "compute") Then
				ls_dwsyntax += ls_objarr[i] + ".Color='" + string(gnv_vari.basefontcolor) + "'~r~n"
			End If
		End If
	next
End If
ls_error = dw_print.modify( ls_dwsyntax )
If len(ls_error) > 0 Then
	Messagebox('Error', 'DataWindow Create fail')
	Close(This)
End If
end subroutine

event resize;SetRedraw(FALSE)

//dw_print.Width = This.Width - 100
//dw_print.Height = This.Height - 350

dw_print.HScrollBar = TRUE
dw_print.VScrollBar = TRUE

SetRedraw(TRUE)

end event

on fw_w_dw2preview.create
int iCurrent
call super::create
this.em_copies=create em_copies
this.st_copies=create st_copies
this.em_zoomrate=create em_zoomrate
this.st_zoomrate=create st_zoomrate
this.em_prerate=create em_prerate
this.st_zoomtitle=create st_zoomtitle
this.st_previewtitle=create st_previewtitle
this.p_upsize=create p_upsize
this.p_downsize=create p_downsize
this.st_p=create st_p
this.p_file=create p_file
this.p_close=create p_close
this.p_lastpage=create p_lastpage
this.p_nextpage=create p_nextpage
this.p_priorpage=create p_priorpage
this.p_firstpage=create p_firstpage
this.uc_printsize=create uc_printsize
this.uc_preview=create uc_preview
this.print_setup=create print_setup
this.uc_printersetup=create uc_printersetup
this.r_2=create r_2
this.st_title=create st_title
this.st_10=create st_10
this.st_9=create st_9
this.cbx_tot=create cbx_tot
this.ddlb_way=create ddlb_way
this.ddlb_paper=create ddlb_paper
this.st_6=create st_6
this.sle_rang=create sle_rang
this.dw_print=create dw_print
this.hsb_1=create hsb_1
this.hsb_zoom=create hsb_zoom
this.st_prerate=create st_prerate
this.st_2=create st_2
this.st_3=create st_3
this.r_5=create r_5
this.r_6=create r_6
this.r_1=create r_1
this.r_7=create r_7
this.r_3=create r_3
this.r_4=create r_4
this.p_print=create p_print
this.r_8=create r_8
this.st_pagecnt=create st_pagecnt
this.r_9=create r_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_copies
this.Control[iCurrent+2]=this.st_copies
this.Control[iCurrent+3]=this.em_zoomrate
this.Control[iCurrent+4]=this.st_zoomrate
this.Control[iCurrent+5]=this.em_prerate
this.Control[iCurrent+6]=this.st_zoomtitle
this.Control[iCurrent+7]=this.st_previewtitle
this.Control[iCurrent+8]=this.p_upsize
this.Control[iCurrent+9]=this.p_downsize
this.Control[iCurrent+10]=this.st_p
this.Control[iCurrent+11]=this.p_file
this.Control[iCurrent+12]=this.p_close
this.Control[iCurrent+13]=this.p_lastpage
this.Control[iCurrent+14]=this.p_nextpage
this.Control[iCurrent+15]=this.p_priorpage
this.Control[iCurrent+16]=this.p_firstpage
this.Control[iCurrent+17]=this.uc_printsize
this.Control[iCurrent+18]=this.uc_preview
this.Control[iCurrent+19]=this.print_setup
this.Control[iCurrent+20]=this.uc_printersetup
this.Control[iCurrent+21]=this.r_2
this.Control[iCurrent+22]=this.st_title
this.Control[iCurrent+23]=this.st_10
this.Control[iCurrent+24]=this.st_9
this.Control[iCurrent+25]=this.cbx_tot
this.Control[iCurrent+26]=this.ddlb_way
this.Control[iCurrent+27]=this.ddlb_paper
this.Control[iCurrent+28]=this.st_6
this.Control[iCurrent+29]=this.sle_rang
this.Control[iCurrent+30]=this.dw_print
this.Control[iCurrent+31]=this.hsb_1
this.Control[iCurrent+32]=this.hsb_zoom
this.Control[iCurrent+33]=this.st_prerate
this.Control[iCurrent+34]=this.st_2
this.Control[iCurrent+35]=this.st_3
this.Control[iCurrent+36]=this.r_5
this.Control[iCurrent+37]=this.r_6
this.Control[iCurrent+38]=this.r_1
this.Control[iCurrent+39]=this.r_7
this.Control[iCurrent+40]=this.r_3
this.Control[iCurrent+41]=this.r_4
this.Control[iCurrent+42]=this.p_print
this.Control[iCurrent+43]=this.r_8
this.Control[iCurrent+44]=this.st_pagecnt
this.Control[iCurrent+45]=this.r_9
end on

on fw_w_dw2preview.destroy
call super::destroy
destroy(this.em_copies)
destroy(this.st_copies)
destroy(this.em_zoomrate)
destroy(this.st_zoomrate)
destroy(this.em_prerate)
destroy(this.st_zoomtitle)
destroy(this.st_previewtitle)
destroy(this.p_upsize)
destroy(this.p_downsize)
destroy(this.st_p)
destroy(this.p_file)
destroy(this.p_close)
destroy(this.p_lastpage)
destroy(this.p_nextpage)
destroy(this.p_priorpage)
destroy(this.p_firstpage)
destroy(this.uc_printsize)
destroy(this.uc_preview)
destroy(this.print_setup)
destroy(this.uc_printersetup)
destroy(this.r_2)
destroy(this.st_title)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.cbx_tot)
destroy(this.ddlb_way)
destroy(this.ddlb_paper)
destroy(this.st_6)
destroy(this.sle_rang)
destroy(this.dw_print)
destroy(this.hsb_1)
destroy(this.hsb_zoom)
destroy(this.st_prerate)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.r_5)
destroy(this.r_6)
destroy(this.r_1)
destroy(this.r_7)
destroy(this.r_3)
destroy(this.r_4)
destroy(this.p_print)
destroy(this.r_8)
destroy(this.st_pagecnt)
destroy(this.r_9)
end on

event open;call super::open;istr_parent = message.powerobjectparm

If not isvalid(istr_parent) Then
	messagebox('Notice(pf_w_popmenufilter)', 'There is no parameter variable value.')
	Close(this)
	Return
End If
idw_print = istr_parent.dw_obj
end event

event key;Choose Case key
	Case KeyEscape!
		p_close.TriggerEvent('Clicked')
End Choose

end event

event wue_postopen;call super::wue_postopen;string	ls_dwsyntax, ls_error

dw_print.dataobject = idw_print.dataobject
ls_dwsyntax = idw_print.describe("datawindow.syntax")

If Pos(ls_dwsyntax, 'currentRow()=getrow(), 4, 0)') > 0 Then
	ls_dwsyntax = fw_f_replaceall(ls_dwsyntax, 'currentRow()=getrow(), 4, 0)', 'currentRow()=getrow(), 0, 0)')
End If
If Pos(ls_dwsyntax, 'processing=1') > 0 Then
	isdefault2processing = '1'
	ls_dwsyntax = fw_f_replaceall(ls_dwsyntax, 'processing=1', 'processing=0')
End If

dw_print.create(ls_dwsyntax, ls_error)
If fw_f_nvls(ls_error, '') <> '' Then
	Messagebox('Error', 'DataWindow 저장 실패')
	Return
End If
Post wf_setobject2process() // 불필요 부분을 제외한 syntax를 Create
end event

event wue_lastopen;call super::wue_lastopen;blob	lb_data

If isdefault2processing = '1' Then
	idw_print.RowsCopy(1, idw_print.RowCount(), Primary!, dw_print, 1, Primary!)
Else
	idw_print.getfullstate(lb_data)
	dw_print.setfullstate(lb_data)
	If dw_print.rowcount() < 1 and idw_print.rowcount() > 0 Then
		idw_print.RowsCopy(1, idw_print.RowCount(), Primary!, dw_print, 1, Primary!)
	End If
End If
dw_print.HscrollBar = True
dw_print.VscrollBar = True

em_prerate.text  = string(hsb_1.position)
//hsb_zoom.position = integer(ls_temp) 등록시 참고
em_zoomrate.text = string(hsb_zoom.position)
cbx_tot.checked = true
print_setup.text = dw_print.Describe("DataWindow.Printer") 

ddlb_paper.SelectItem(1)
Choose Case dw_print.Describe("DataWindow.Print.Orientation")
	Case '0'
		ddlb_way.SelectItem(1)
	Case '1'
		ddlb_way.SelectItem(2)
	Case '2'
		ddlb_way.SelectItem(3)
End Choose

sle_rang.Enabled = False
//st_6.TextColor = RGB(45,45,45)
dw_print.setredraw(false)
dw_print.setredraw(true)

uc_printsize.PostEvent(Clicked!)

Post of_pagecnt()
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_dw2preview
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_dw2preview
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_dw2preview
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_dw2preview
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_dw2preview
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_dw2preview
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_dw2preview
end type

type em_copies from editmask within fw_w_dw2preview
integer x = 5307
integer y = 256
integer width = 96
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20724796
long backcolor = 16777215
string text = "1"
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
end type

type st_copies from statictext within fw_w_dw2preview
integer x = 5147
integer y = 272
integer width = 137
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
boolean enabled = false
string text = "매수"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_zoomrate from editmask within fw_w_dw2preview
integer x = 2272
integer y = 260
integer width = 155
integer height = 88
integer taborder = 130
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "###"
double increment = 1
string minmax = "1~~200"
end type

event modified;String		ls_position

ls_position = This.Text

If Long(ls_position) > 300 Then
	Messagebox('Check', '범위는 300%이하입니다. 다시 지정해 주십시요.')	
	Return
End If

hsb_zoom.position = Long(ls_position)

dw_print.Modify("DataWindow.Zoom = " + ls_position)
end event

type st_zoomrate from statictext within fw_w_dw2preview
integer x = 2432
integer y = 272
integer width = 82
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
boolean enabled = false
string text = "%"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_prerate from editmask within fw_w_dw2preview
integer x = 1010
integer y = 260
integer width = 155
integer height = 88
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "###"
double increment = 1
string minmax = "1~~200"
end type

event modified;String		ls_position

ls_position = This.Text

If Long(ls_position) > 200 Then
	Messagebox('Check', '범위는 200%이하입니다. 다시 지정해 주십시요.')	
	Return
End If
hsb_1.position = Long(ls_position)

dw_print.Modify("DataWindow.Print.Preview.Zoom = "  + ls_position)
end event

type st_zoomtitle from statictext within fw_w_dw2preview
integer x = 1705
integer y = 164
integer width = 306
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 32239871
string text = "확대축소"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_previewtitle from statictext within fw_w_dw2preview
integer x = 379
integer y = 164
integer width = 306
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 32239871
string text = "미리보기"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_upsize from pf_u_imagebutton within fw_w_dw2preview
boolean visible = false
integer x = 2990
integer y = 32
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_minus.jpg"
end type

event clicked;call super::clicked;Long			ll_pagecnt, ll_zoom, ll_zoom_limit, ll_zoomrule
Long			ll_vposmax_tobe, ll_vposmax_limit
decimal{2}	ldc_pagerate, ldc_dwbywidth, ldc_zoom_rate, ldc_vposmax_rate, ldc_zoom_rulerate

If dw_print.Describe("Datawindow.Print.Preview") <> 'yes' then Return

setpointer(hourglass!)

/* to-be */
dw_print.ScrollToRow(1)

ll_pagecnt = Long(dw_print.Describe("evaluate('PageCount()', 0)"))
If ll_pagecnt < 10 Then
	ldc_pagerate = 0.01
Else
	ldc_pagerate = round(ll_pagecnt / 500, 2) * 100
	If ldc_pagerate > 100 Then ldc_pagerate = 99.99
End If
ldc_pagerate			= 100 - ldc_pagerate
ldc_zoom_rate		= 1 + (0.1 + Round(0.5 * (ldc_pagerate / 100), 2))
ldc_zoom_rulerate	= 1 + Round(0.1 + (0.5 * (ldc_pagerate / 100)) / 3.5, 2)
ldc_vposmax_rate	= 1 + Round(0.4 * (ldc_pagerate / 100), 2)

ll_zoom			= Long(dw_print.Describe("DataWindow.Zoom"))
ll_zoom_limit		= round(ll_zoom * ldc_zoom_rate, 0)
ll_zoomrule		= round(ll_zoom * ldc_zoom_rulerate, 0)
ll_vposmax_tobe	= Long(dw_print.Object.DataWindow.VerticalScrollMaximum)
ll_vposmax_limit		= round(ll_vposmax_tobe * ldc_vposmax_rate, 0)
Do While True
	If ll_vposmax_tobe > ll_vposmax_limit and  ll_zoom > ll_zoomrule Then
		p_downsize.Post Event Clicked()
		//If ll_pagecnt = Long(dw_print.Describe("evaluate('PageCount()', 0)")) Then 
		Exit
	End If
	If ll_zoom > ll_zoom_limit Then Exit
	ll_zoom += 1
	dw_print.Modify("DataWindow.Zoom=" + string(ll_zoom))
	Yield ( )
	ll_vposmax_tobe = Long(dw_print.Object.DataWindow.VerticalScrollMaximum)
Loop

hsb_zoom.position = ll_zoom
em_zoomrate.text = string(ll_zoom)
setpointer(Arrow!)

Post of_pagecnt()

//Long	ll_pagecnt, ll_zoom, ll_zoom_limit
//Long	ll_dwbywidth, ll_maxpos, ll_VposMax, ll_VposMax_tobe, ll_VposMax_limit
//
//If dw_print.Describe("Datawindow.Print.Preview") <> 'yes' then Return
//
//setpointer(hourglass!)
//ll_zoom		= long(dw_print.Describe("DataWindow.Zoom"))
//ll_zoom_limit	= round(ll_zoom * 1.4, 0)
///* to-be */
//ll_VposMax_tobe	= Long(dw_print.Object.DataWindow.VerticalScrollMaximum)
//ll_VposMax_limit		= round(ll_VposMax_tobe * 1.15, 0)
//Do Until ll_VposMax_tobe > ll_VposMax_limit
//	If ll_zoom > ll_zoom_limit Then Exit
//	ll_zoom += 1
//	dw_print.Modify("DataWindow.Zoom=" + string(ll_zoom))
//	Yield ( )
//	ll_VposMax_tobe = Long(dw_print.Object.DataWindow.VerticalScrollMaximum)
//Loop
//hsb_2.position = ll_zoom
//st_size_rate.text = string(ll_zoom) + '%'
//setpointer(Arrow!)
end event

type p_downsize from pf_u_imagebutton within fw_w_dw2preview
boolean visible = false
integer x = 2871
integer y = 32
integer width = 110
integer height = 96
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_plus.jpg"
end type

event clicked;call super::clicked;Long			ll_zoom, ll_zoom_limit
Long			ll_vposmax_tobe, ll_vposmax_limit
decimal{2}	ldc_pagecnt, ldc_pagerate, ldc_dwbywidth, ldc_zoom_rate, ldc_vposmax_rate, ldc_revise

If dw_print.Describe("Datawindow.Print.Preview") <> 'yes' then Return

setpointer(hourglass!)

/* to-be */
dw_print.ScrollToRow(1)

ldc_pagecnt = Long(dw_print.Describe("evaluate('PageCount()', 0)"))
If ldc_pagecnt < 10 Then
	ldc_pagerate = 0.01
Else
	ldc_pagerate = round(ldc_pagecnt / 500, 2) * 100
	If ldc_pagerate > 100 Then ldc_pagerate = 99.99
End If
ldc_zoom_rate		= 1 - (0.4 + Round(0.2 * (ldc_pagerate / 100), 2))
ldc_vposmax_rate	= 1 - (0.2 + Round(0.2 * (ldc_pagerate / 100), 2))

ll_zoom			= Long(dw_print.Describe("DataWindow.Zoom"))
ll_zoom_limit		= round(ll_zoom * ldc_zoom_rate, 0)
ll_vposmax_tobe	= Long(dw_print.Object.DataWindow.VerticalScrollMaximum)
ll_vposmax_limit		= round(ll_vposmax_tobe * ldc_vposmax_rate, 0)
//messagebox(string(ll_vposmax_tobe), ll_vposmax_limit)
//messagebox(string(ll_zoom), ll_zoom_limit)
Do Until ll_vposmax_tobe < ll_vposmax_limit
	If ll_zoom < ll_zoom_limit or ll_zoom < 5 Then Exit
	ll_zoom -= 1	
	dw_print.Modify("DataWindow.Zoom=" + string(ll_zoom))
	Yield ( )
	ll_vposmax_tobe = Long(dw_print.Object.DataWindow.VerticalScrollMaximum)
Loop

hsb_zoom.position = ll_zoom
em_zoomrate.text = string(ll_zoom) + '%'
setpointer(Arrow!)

Post of_pagecnt()

/* as-is */
//ldc_dwbywidth	= dw_print.width - ((Long(dw_print.Describe("DataWindow.Print.Margin.Left")) + Long(dw_print.Describe("DataWindow.Print.Margin.Right"))) * 2)
//of_getdwomaxwidth()
//ldc_maxpos = round(imaxpos * (ll_zoom/100), 0)
//Do Until ldc_maxpos < ldc_dwbywidth
//	ll_zoom -= 1
//	dw_print.Modify("DataWindow.Zoom=" + string(ll_zoom))
//	ldc_maxpos = round(imaxpos * (ll_zoom/100), 0)
//	If ldc_maxpos < ldc_dwbywidth Then
//		If gnv_vari.appeongetclienttype = 'WEB' Then ll_zoom -= 1
//		ll_zoom -= 1
//		dw_print.Modify("DataWindow.Zoom=" + string(ll_zoom))
//	End If
//Loop

end event

type st_p from statictext within fw_w_dw2preview
integer x = 2071
integer y = 88
integer width = 466
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
string text = "전체          페이지"
boolean focusrectangle = false
end type

type p_file from pf_u_imagebutton within fw_w_dw2preview
boolean visible = false
integer x = 2638
integer y = 32
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string picturename = "..\img\controls\u_imagebutton\btn_file.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;pf_n_saveas lnv_save
lnv_save.of_saveas(dw_print, true)
end event

type p_close from pf_u_imagebutton within fw_w_dw2preview
integer x = 5193
integer y = 32
integer width = 229
integer height = 96
integer taborder = 90
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_close.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;Close(parent)
end event

type p_lastpage from pf_u_imagebutton within fw_w_dw2preview
integer x = 4585
integer y = 32
integer width = 110
integer height = 96
integer taborder = 80
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_iconend.jpg"
end type

event clicked;call super::clicked;dw_print.ScrollToRow( dw_print.RowCount() )

end event

type p_nextpage from pf_u_imagebutton within fw_w_dw2preview
integer x = 4466
integer y = 32
integer width = 110
integer height = 96
integer taborder = 70
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_right.jpg"
end type

event clicked;call super::clicked;IF dw_print.ScrollNextPage()= -1 THEN
   BEEP(3)
END IF

end event

type p_priorpage from pf_u_imagebutton within fw_w_dw2preview
integer x = 4347
integer y = 32
integer width = 110
integer height = 96
integer taborder = 60
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_left.jpg"
end type

event clicked;call super::clicked;IF dw_print.ScrollpriorPage() = -1 THEN
   BEEP(3)
END IF

end event

type p_firstpage from pf_u_imagebutton within fw_w_dw2preview
integer x = 4229
integer y = 32
integer width = 110
integer height = 96
integer taborder = 50
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4btn\btn_iconstart.jpg"
end type

event clicked;call super::clicked;dw_print.ScrollToRow(1)
end event

type uc_printsize from pf_u_commandbutton within fw_w_dw2preview
boolean visible = false
integer x = 3291
integer y = 28
integer width = 178
integer height = 104
string text = "SIZE"
boolean applydesign = false
end type

event clicked;call super::clicked;dw_print.Modify("DataWindow.Zoom = "  + String(hsb_zoom.position) )
Post of_pagecnt()
end event

type uc_preview from pf_u_commandbutton within fw_w_dw2preview
boolean visible = false
integer x = 3109
integer y = 28
integer width = 178
integer height = 104
string text = "Preview"
boolean applydesign = false
end type

event clicked;call super::clicked;dw_print.Modify("DataWindow.Print.Preview.Zoom = "  + string(hsb_1.position))
end event

type print_setup from singlelineedit within fw_w_dw2preview
integer x = 311
integer y = 76
integer width = 1298
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
boolean border = false
end type

type uc_printersetup from pf_u_commandbutton within fw_w_dw2preview
integer x = 37
integer width = 384
integer height = 76
integer taborder = 20
integer textsize = -9
fontcharset fontcharset = hangeul!
string text = "PrinterSetup"
end type

event clicked;call super::clicked;printsetup()
print_setup.text = dw_print.Describe("DataWindow.Printer")

end event

type r_2 from rectangle within fw_w_dw2preview
long linecolor = 29595236
integer linethickness = 4
long fillcolor = 33090525
integer x = 2546
integer y = 236
integer width = 2875
integer height = 136
end type

type st_title from statictext within fw_w_dw2preview
integer x = 32
integer y = 76
integer width = 251
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
string text = "인쇄준비"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_10 from statictext within fw_w_dw2preview
integer x = 3227
integer y = 272
integer width = 270
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
boolean enabled = false
string text = "출력방향"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_9 from statictext within fw_w_dw2preview
integer x = 2555
integer y = 272
integer width = 270
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
boolean enabled = false
string text = "출력용지"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_tot from checkbox within fw_w_dw2preview
integer x = 4585
integer y = 264
integer width = 206
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
string text = "전체"
end type

event clicked;IF This.Checked THEN
	sle_rang.Enabled = False
	st_6.TextColor = RGB(150,150,150)
ELSE
	sle_rang.Enabled = True
	st_6.TextColor = RGB(0,0,0)
END IF
end event

type ddlb_way from dropdownlistbox within fw_w_dw2preview
integer x = 3534
integer y = 256
integer width = 338
integer height = 380
integer taborder = 120
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20724796
boolean vscrollbar = true
string item[] = {"Default","가로","세로"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;CHOOSE CASE index
	CASE 1
		dw_print.Modify( "datawindow.print.Orientation = 0" )
	CASE 2
		dw_print.Modify( "datawindow.print.Orientation = 1" )
	CASE 3
		dw_print.Modify( "datawindow.print.Orientation = 2" )
END CHOOSE

end event

type ddlb_paper from dropdownlistbox within fw_w_dw2preview
integer x = 2866
integer y = 256
integer width = 338
integer height = 380
integer taborder = 110
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20724796
boolean sorted = false
boolean vscrollbar = true
string item[] = {"Default","136 Col","80 Col","A4","A5","B4","B5"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;CHOOSE CASE index
	CASE 1
		dw_print.Modify( "DataWindow.Print.Paper.Size = 0 " )
	CASE 2
		dw_print.Modify( "DataWindow.Print.Paper.Size = 04 " )
	CASE 3
		dw_print.Modify( "DataWindow.Print.Paper.Size = 01 " )
	CASE 4
		dw_print.Modify( "DataWindow.Print.Paper.Size = 09 " )
	CASE 5
		dw_print.Modify( "DataWindow.Print.Paper.Size = 11 " )
	CASE 6
		dw_print.Modify( "DataWindow.Print.Paper.Size = 12 " )
	CASE 7
		dw_print.Modify( "DataWindow.Print.Paper.Size = 13 " )
END CHOOSE

end event

type st_6 from statictext within fw_w_dw2preview
integer x = 4800
integer y = 264
integer width = 334
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
string text = "Ex) 1, 2, 3-6"
boolean focusrectangle = false
end type

type sle_rang from singlelineedit within fw_w_dw2preview
integer x = 4201
integer y = 256
integer width = 375
integer height = 92
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 20724796
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_print from fw_u_dwo within fw_w_dw2preview
integer x = 41
integer y = 404
integer width = 5381
integer height = 2656
integer taborder = 130
boolean livescroll = false
end type

event clicked;//
end event

event rowfocuschanged;//
end event

type hsb_1 from hscrollbar within fw_w_dw2preview
event lineleft pbm_sbnlineup
event lineright pbm_sbnlinedown
event moved pbm_sbnthumbtrack
integer x = 46
integer y = 256
integer width = 955
integer height = 96
boolean bringtotop = true
boolean stdheight = false
integer minposition = 10
integer maxposition = 200
integer position = 100
end type

event lineleft;this.position -= 1

dw_print.Modify("DataWindow.Print.Preview.Zoom = "  + string(this.position))

em_prerate.text  = string(this.position)

end event

event lineright;this.position += 1

dw_print.Modify("DataWindow.Print.Preview.Zoom = "  + string(this.position))

em_prerate.text  = string(this.position)
end event

event moved;dw_print.Modify("DataWindow.Print.Preview.Zoom = "  + string(this.position))

em_prerate.text  = string(this.position)
//st_prerate.text = string(this.position) + '%'
end event

type hsb_zoom from hscrollbar within fw_w_dw2preview
event lineleft pbm_sbnlineup
event lineright pbm_sbnlinedown
event moved pbm_sbnthumbtrack
integer x = 1307
integer y = 256
integer width = 955
integer height = 96
boolean bringtotop = true
boolean stdheight = false
integer minposition = 1
integer maxposition = 300
integer position = 100
end type

event lineleft;this.position -= 1

dw_print.Modify("DataWindow.Zoom = "  + string(this.position) )
dw_print.setredraw(true)
em_zoomrate.text = string(this.position)

Post of_pagecnt()
end event

event lineright;this.position += 1

dw_print.Modify("DataWindow.Zoom = "  + string(this.position) )

em_zoomrate.text = string(this.position)

Post of_pagecnt()
end event

event moved;dw_print.Modify("DataWindow.Zoom = "  + string(this.position) )

em_zoomrate.text = string(this.position)

Post of_pagecnt()
end event

type st_prerate from statictext within fw_w_dw2preview
integer x = 1170
integer y = 272
integer width = 82
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
boolean enabled = false
string text = "%"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within fw_w_dw2preview
integer x = 2569
integer y = 168
integer width = 951
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 32239871
string text = "인쇄옵션 및 범위"
boolean focusrectangle = false
end type

type st_3 from statictext within fw_w_dw2preview
integer x = 3899
integer y = 272
integer width = 270
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 33090525
boolean enabled = false
string text = "인쇄범위"
alignment alignment = right!
boolean focusrectangle = false
end type

type r_5 from rectangle within fw_w_dw2preview
long linecolor = 29595236
integer linethickness = 4
long fillcolor = 32239871
integer x = 32
integer y = 160
integer width = 2496
integer height = 80
end type

type r_6 from rectangle within fw_w_dw2preview
long linecolor = 29595236
integer linethickness = 4
long fillcolor = 33090525
integer x = 32
integer y = 236
integer width = 2496
integer height = 136
end type

type r_1 from rectangle within fw_w_dw2preview
long linecolor = 29595236
integer linethickness = 4
long fillcolor = 32239871
integer x = 2546
integer y = 160
integer width = 2875
integer height = 80
end type

type r_7 from rectangle within fw_w_dw2preview
long linecolor = 33090525
integer linethickness = 4
long fillcolor = 33090525
integer x = 2551
integer y = 240
integer width = 302
integer height = 128
end type

type r_3 from rectangle within fw_w_dw2preview
long linecolor = 33090525
integer linethickness = 4
long fillcolor = 33090525
integer x = 3886
integer y = 240
integer width = 302
integer height = 128
end type

type r_4 from rectangle within fw_w_dw2preview
long linecolor = 16711680
integer linethickness = 4
long fillcolor = 33554431
integer x = 37
integer y = 400
integer width = 5390
integer height = 2664
end type

type p_print from pf_u_imagebutton within fw_w_dw2preview
integer x = 4955
integer y = 32
integer width = 229
integer height = 96
integer taborder = 40
string picturename = "..\img\controls\u_imagebutton\btn_print.jpg"
boolean fixedtoright = true
end type

event clicked;call super::clicked;String		ls_syntax, ls_error
String		ls_range, ls_copies

ls_syntax = ''

If cbx_tot.Checked = False Then
	ls_range = sle_rang.Text
	If fw_f_nvls(ls_range, '') <> '' Then ls_syntax += "datawindow.print.page.range = '" + ls_range + "'~r~n"
End If
ls_copies = em_copies.text
If fw_f_nvls(ls_copies, '') <> '' Then ls_syntax += "datawindow.print.copies = '" + ls_copies + "'"

If fw_f_nvls(ls_syntax, '') <> '' Then
	ls_error = dw_print.Modify(ls_syntax)
	If len(ls_error) > 0 Then
		::clipboard(ls_syntax)
		messagebox("Error", " preview Syntax Modify Failure!! : " + ls_error)
		return -1
	End If
End If

il_return = dw_print.Print()

end event

type r_8 from rectangle within fw_w_dw2preview
long linecolor = 33090525
integer linethickness = 4
long fillcolor = 33090525
integer x = 3218
integer y = 240
integer width = 302
integer height = 128
end type

type st_pagecnt from statictext within fw_w_dw2preview
integer x = 2185
integer y = 84
integer width = 165
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 19737901
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type r_9 from rectangle within fw_w_dw2preview
long linecolor = 33090525
integer linethickness = 4
long fillcolor = 33090525
integer x = 5138
integer y = 240
integer width = 151
integer height = 128
end type

