forward
global type fw_u_sheet4navi from u_ancestor
end type
type p_icon from pf_u_picture within fw_u_sheet4navi
end type
type st_navi from pf_u_statictext within fw_u_sheet4navi
end type
end forward

global type fw_u_sheet4navi from u_ancestor
integer width = 3698
integer height = 88
long backcolor = 32238571
event oue_addsheet ( )
event ue_closesheet ( )
event oue_selectsheet ( )
event ue_deselectsheet ( )
p_icon p_icon
st_navi st_navi
end type
global fw_u_sheet4navi fw_u_sheet4navi

type variables
private:
   window iw_sheet[]
   fw_n_dso ids_sheetdata
   LONG	il_maxsheetseq
   LONG	il_selectedsheetseq
end variables

forward prototypes
public subroutine of_setsheetnavi (string as_sheetnavi)
public function string of_thisname ()
public function integer of_selectsheet (long al_sheetseq)
public function integer of_deselectsheet (long al_sheetseq)
public function long of_closesheet (long al_sheetseq)
public function integer of_addsheet (string as_pgm_no, string as_pgm_id, string as_pgm_nm, string as_pgm_path, window aw_sheet)
public subroutine of_setposition ()
end prototypes

public subroutine of_setsheetnavi (string as_sheetnavi);
end subroutine

public function string of_thisname ();return 'fw_u_sheet4navi'

end function

public function integer of_selectsheet (long al_sheetseq);String		ls_pgmpath
long		ll_rownum

p_icon.visible = true
st_navi.visible = true

if il_selectedsheetseq = al_sheetseq then return 0
ll_rownum = ids_sheetdata.find("sheet_seq=" + string(al_sheetseq), 1, ids_sheetdata.rowcount())
if ll_rownum <= 0 then return -1

ls_pgmpath = ids_sheetdata.getitemstring(ll_rownum, 'pgm_path')
/* to-be */
If Pos(ls_pgmpath, '&') > 0 Then ls_pgmpath = fw_f_replaceall(ls_pgmpath, '&', '&&')

st_navi.text = ls_pgmpath // as-is ids_sheetdata.getitemstring(ll_rownum, 'pgm_path')

il_selectedsheetseq = al_sheetseq

return 1

end function

public function integer of_deselectsheet (long al_sheetseq);long ll_rownum

p_icon.visible = false
st_navi.visible = false

il_selectedsheetseq = 0
return 1

end function

public function long of_closesheet (long al_sheetseq);long ll_rownum

ll_rownum = ids_sheetdata.find("sheet_seq=" + string(al_sheetseq), 1, ids_sheetdata.rowcount())
if ll_rownum <= 0 then return -1

p_icon.visible = false
st_navi.visible = false

ids_sheetdata.deleterow(ll_rownum)
if ids_sheetdata.rowcount() = 0 then
	il_selectedsheetseq = 0
end if

return 1

end function

public function integer of_addsheet (string as_pgm_no, string as_pgm_id, string as_pgm_nm, string as_pgm_path, window aw_sheet);long ll_new, ll_seq

ll_new = ids_sheetdata.insertrow(0)
ll_seq = il_maxsheetseq + 1

ids_sheetdata.setitem(ll_new, 'sheet_seq', ll_seq)
ids_sheetdata.setitem(ll_new, 'pgm_no', as_pgm_no)
ids_sheetdata.setitem(ll_new, 'pgm_id', as_pgm_id)
ids_sheetdata.setitem(ll_new, 'pgm_nm', as_pgm_nm)
ids_sheetdata.setitem(ll_new, 'pgm_path', as_pgm_path)
iw_sheet[ll_seq] = aw_sheet

il_maxsheetseq = ll_seq
return ll_seq

end function

public subroutine of_setposition ();pf_s_size lstr_textsize
string	ls_text
long	ll_textwidth

ls_text = st_navi.text
If fw_f_nvls(ls_text, '') = '' Then ls_text = 'location empty'
//gnv_extfunc.biz_gettextsize_w(handle(this), ls_text, '맑은 고딕', 10, 400, lstr_textsize)
gnv_extfunc.biz_gettextsize_w(handle(this), ls_text, '맑은 고딕', 9, 400, lstr_textsize)
ll_textwidth = PixelsToUnits(lstr_textsize.width, XPixelsToUnits!)

st_navi.width = ll_textwidth
st_navi.x = this.width - st_navi.width// - PixelsToUnits(1, XPixelsToUnits!)
p_icon.x = st_navi.x - p_icon.width - PixelsToUnits(4, XPixelsToUnits!)
end subroutine

on fw_u_sheet4navi.create
int iCurrent
call super::create
this.p_icon=create p_icon
this.st_navi=create st_navi
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_icon
this.Control[iCurrent+2]=this.st_navi
end on

on fw_u_sheet4navi.destroy
call super::destroy
destroy(this.p_icon)
destroy(this.st_navi)
end on

event constructor;call super::constructor;// 탭페이지 정보 보관용 데이터윈도우
ids_sheetdata = CREATE fw_n_dso
ids_sheetdata.dataobject = 'fw_d_sheet4navi_ds1'
end event

event destructor;call super::destructor;If gnv_vari.getclienttype = 'PB' and IsValid(ids_sheetdata) Then Destroy ids_sheetdata
end event

type p_icon from pf_u_picture within fw_u_sheet4navi
boolean visible = false
integer x = 5
integer y = 12
integer width = 59
integer height = 48
boolean bringtotop = true
string picturename = "..\img\controls\u_icon4comm\icon_home2.png"
end type

type st_navi from pf_u_statictext within fw_u_sheet4navi
integer x = 87
integer y = 8
integer width = 3611
boolean bringtotop = true
integer textsize = -9
fontcharset fontcharset = hangeul!
long textcolor = 19737901
long backcolor = 32238571
alignment alignment = right!
boolean scaletoright = true
end type

event rbuttondown;call super::rbuttondown;string ls_data
ls_data = st_navi.text
::Clipboard(ls_data)
end event

