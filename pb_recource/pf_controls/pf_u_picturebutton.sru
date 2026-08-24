forward
global type pf_u_picturebutton from picturebutton
end type
end forward

global type pf_u_picturebutton from picturebutton
integer width = 402
integer height = 104
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "돋움"
string pointer = "HyperLink!"
vtextalign vtextalign = vcenter!
event type boolean oue_components ( )
event oue_postopen ( )
end type
global pf_u_picturebutton pf_u_picturebutton

type prototypes
Function long GetTempPath(long nBufferLength, ref string lpBuffer ) Library "kernel32.dll" Alias For "GetTempPathA;Ansi"

end prototypes

type variables
private:
	window iw_parent
	string is_picturename
	string is_disabledname
	integer ii_referencedobjectcnt

public:
	boolean	i----------------------------------------------------line0	/* empty Object */
	powerobject ipo_referencedobject[]

	string IconPath

	boolean FixedToRight
	boolean FixedToBottom
	boolean ScaleToRight
	boolean ScaleToBottom
	boolean	i----------------------------------------------------line1	/* empty Object */

	string ReferencedObject
	string OnClickCallEvent
	string DatawindowAction

end variables

forward prototypes
public function integer of_setpicturename (string as_iconname)
public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath)
public function string of_thisname ()
end prototypes

event type boolean oue_components();return true

end event

event oue_postopen();// get parent window
iw_parent = fw_f_obj4parentwindow(this)

// get referenced object
string ls_refobj[]
integer li_objcnt, i

if isnull(ReferencedObject) then return
if ReferencedObject = '' then return

li_objcnt = fw_f_obj2array(ReferencedObject, ';', ls_refobj)
for i = 1 to li_objcnt
	if len(ls_refobj[i]) > 0 then
		ii_referencedobjectcnt ++
		choose case lower(ls_refobj[i])
			case 'this'
				ipo_referencedobject[ii_referencedobjectcnt] = this
			case 'parent'
				ipo_referencedobject[ii_referencedobjectcnt] = parent
			case iw_parent.classname()
				ipo_referencedobject[ii_referencedobjectcnt] = iw_parent
			case else
				ipo_referencedobject[ii_referencedobjectcnt] = iw_parent.dynamic of_getwindowobjectbyname(ls_refobj[i])
				if not isvalid(ipo_referencedobject[ii_referencedobjectcnt]) then
					messagebox('[' + this.classname() + '] 알림', '[' + ls_refobj[i] + '] 참조 오브젝트가 존재하지 않습니다')
				end if
		end choose
	end if
next

end event

public function integer of_setpicturename (string as_iconname);long ll_width, ll_height

if isnull(as_iconname) or as_iconname = '' then
	is_picturename = ''
	is_disabledname = ''
	return 0
end if

IconPath = pf_f_getimagepathappeon(as_iconname)
if not fileexists(IconPath) then return -1

is_picturename = gnv_vari.is_tempdirectory + gnv_extfunc.of_getuniqpicturename(this) + ".jpg"
if this.of_checkandcreateimage('picturename', is_picturename) > 0 then
	this.picturename = is_picturename
end if

is_disabledname = gnv_vari.is_tempdirectory + gnv_extfunc.of_getuniqpicturename(this) + "_disabled.jpg"
if this.of_checkandcreateimage('disabledname', is_disabledname) > 0 then
	this.disabledname = is_disabledname
end if

// text alignment & gap
this.htextalign = left!
this.text = space(6) + this.text

return 1

end function

public function integer of_checkandcreateimage (string as_imagetype, string as_imagepath);string ls_orgfilewritetime, ls_newfilewritetime
long ll_width, ll_height

ll_width = unitstopixels(this.width, xunitstopixels!) - 5
ll_height = unitstopixels(this.height, yunitstopixels!) - 5

//// 이미지 캐쉬 기능은 메타데이터로 확인할 수 있도록 나중에 구현한다.
//// 원본파일 수정일자 가져오기
//gnv_extfunc.of_getfilewritetime(IconPath, ls_orgfilewritetime)
//
//// 파일이 존재하면 수정일자 비교, 동일하면 리턴
//if fileexists(as_imagepath) then
//	 gnv_extfunc.of_getfilewritetime(as_imagepath, ls_newfilewritetime)
//	 if ls_orgfilewritetime = ls_newfilewritetime then
//		return 1
//	end if
//end if

// 이미지 타입에 따라 임시파일 신규 생성
choose case as_imagetype
	case 'picturename'
		gnv_extfunc.biz_setpicturebtnimg(iconpath, as_imagepath, ll_width, ll_height, true)
	case 'disabledname'
		gnv_extfunc.biz_setpicturebtnimg(iconpath, as_imagepath, ll_width, ll_height, false)
end choose

//gnv_extfunc.of_setfilewritetime(as_imagepath, ls_orgfilewritetime)
return 1

end function

public function string of_thisname ();return 'pf_u_picturebutton'

end function

on pf_u_picturebutton.create
end on

on pf_u_picturebutton.destroy
end on

event constructor;// init each button picture names
this.of_setpicturename(this.IconPath)

// postopen event
this.post event oue_postopen()

end event

event clicked;integer i

// 참조 오브젝트가 선언된 경우 해당 오브젝트의 이벤트를 호출합니다
if ii_referencedobjectcnt > 0 then
	for i = 1 to ii_referencedobjectcnt
		if len(OnClickCallEvent) > 0 then
			if not isvalid(ipo_referencedobject[i]) then continue
			if ipo_referencedobject[i].triggerevent(OnClickCallEvent) = -1 then exit
		end if
	next
end if

end event

