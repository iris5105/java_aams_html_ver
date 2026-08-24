forward
global type fw_w_syncmanager from w_window1st
end type
type dw_project from fw_u_dwo within fw_w_syncmanager
end type
type cb_close from pf_u_commandbutton within fw_w_syncmanager
end type
type dw_liblist from fw_u_dwo within fw_w_syncmanager
end type
type cb_addproj from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_delproj from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_updproj from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_addfile from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_delfile from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_upload from pf_u_commandbutton within fw_w_syncmanager
end type
type dw_cond from datawindow within fw_w_syncmanager
end type
type cb_zipfile from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_zipall from pf_u_commandbutton within fw_w_syncmanager
end type
type cb_refresh from pf_u_commandbutton within fw_w_syncmanager
end type
end forward

global type fw_w_syncmanager from w_window1st
dw_project dw_project
cb_close cb_close
dw_liblist dw_liblist
cb_addproj cb_addproj
cb_delproj cb_delproj
cb_updproj cb_updproj
cb_addfile cb_addfile
cb_delfile cb_delfile
cb_upload cb_upload
dw_cond dw_cond
cb_zipfile cb_zipfile
cb_zipall cb_zipall
cb_refresh cb_refresh
end type
global fw_w_syncmanager fw_w_syncmanager

type variables
constant string ApplicationContextFile = "pf_syncapplication.xml"
constant string UploadSubDir = "/SyncProject/"

end variables

forward prototypes
public function integer of_setprojectlistddlb ()
public function integer of_setlibrarylist (long al_row, string as_filepath)
public function integer of_compresslibrarylist (long al_row)
end prototypes

public function integer of_setprojectlistddlb ();long ll_row
string ls_project_name
string ls_values

for ll_row = 1 to dw_project.rowcount()
	ls_project_name = dw_project.getitemstring(ll_row, 'project_name')
	if len(trim(ls_project_name)) > 0 then
		ls_values += ls_project_name + "~t" + ls_project_name + "/"
	end if
next

dw_cond.modify("project_name.values='" + ls_values + "'")
return ll_row

end function

public function integer of_setlibrarylist (long al_row, string as_filepath);datetime ldtm_modified
ulong lul_filesize
string ls_filename

// pbl --> pbd 변경
if lower(right(as_filepath, 4)) = '.pbl' then
	as_filepath = left(as_filepath, len(as_filepath) - 4) + ".pbd"
end if

dw_liblist.setitem(al_row, 'path', as_filepath)

gnv_extfunc.of_getfilewritetime(as_filepath, ldtm_modified)
lul_filesize = gnv_extfunc.biz_getfilesize(as_filepath)

dw_liblist.setitem(al_row, 'src_lastmodifydate', ldtm_modified)
dw_liblist.setitem(al_row, 'src_size', lul_filesize)

ls_filename = gnv_extfunc.of_pathstrippath(as_filepath)
dw_liblist.setitem(al_row, 'src_filename', ls_filename)

return 1

end function

public function integer of_compresslibrarylist (long al_row);// 배포할 파일을 압축처리 합니다.

integer li_rc
string ls_project_name, ls_orgfile
string ls_zipfile
long ll_proj_row

ll_proj_row = dw_project.getrow()
if ll_proj_row = 0 then return -1
ls_project_name = dw_project.getitemstring(ll_proj_row, 'project_name')

ls_orgfile = dw_liblist.getitemstring(al_row, 'path')
ls_zipfile = gnv_vari.basepath  + "\SyncProject\" + ls_project_name + "\" + gnv_extfunc.of_pathstrippath(ls_orgfile) + ".z"

li_rc = gnv_extfunc.of_compressfile(ls_orgfile, ls_zipfile)
if li_rc < 0 then return -1

//dw_liblist.setitem(al_row, 'zip_name', gnv_extfunc.of_pathstrippath(ls_zipfile))
//
//li_filenum = fileopen(ls_orgfile, StreamMode!, Read!, LockRead!)
//if li_filenum = -1 then
//	messagebox('Notice', ls_orgfile + ' 파일을 열 수 없습니다~r~n해당 파일을 사용 중인 프로그램을 닫고 다시 시도해 보세요')
//	return -1
//end if
//
//if filereadex(li_filenum, lb_contents) = -1 then
//	messagebox('Notice', ls_orgfile + ' 파일을 읽을 수 없습니다~r~n해당 파일을 사용 중인 프로그램을 닫고 다시 시도해 보세요')
//	return -1
//end if
//
//fileclose(li_filenum)
//
//ls_filenameonly = gnv_extfunc.of_pathstrippath(ls_orgfile)
//ls_zipfile = gnv_vari.is_currentdir  + "\SyncProject\" + ls_project_name + "\" + ls_filenameonly + ".z"
//
//if gnv_extfunc.of_compress(lb_contents, lb_zipped) < 1 then
//	messagebox('Notice', ls_orgfile + '~r~n파일 압축 실패!')
//	return -1
//end if
//
//li_filenum = fileopen(ls_zipfile, StreamMode!, Write!, LockWrite!, Replace!)
//if li_filenum = -1 then
//	messagebox('Notice', ls_zipfile + ' 파일을 열 수 없습니다~r~n해당 파일을 사용 중인 프로그램을 닫고 다시 시도해 보세요')
//	return -1
//end if
//
//if filewriteex(li_filenum, lb_zipped) = -1 then
//	messagebox('Notice', ls_zipfile + ' 파일에 데이터 쓰기를 할 수 없습니다~r~n해당 파일을 사용 중인 프로그램을 닫고 다시 시도해 보세요')
//	return -1
//end if
//
//fileclose(li_filenum)

datetime ldtm_modified
long lul_filesize, lul_orgfilesize
decimal ld_comp_raito

dw_liblist.setitem(al_row, 'zip_name', gnv_extfunc.of_pathstrippath(ls_zipfile))

gnv_extfunc.of_getfilewritetime(ls_zipfile, ldtm_modified)
lul_filesize = gnv_extfunc.biz_getfilesize(ls_zipfile)

dw_liblist.setitem(al_row, 'dest_lastmodifydate', ldtm_modified)
dw_liblist.setitem(al_row, 'dest_size', lul_filesize)

lul_orgfilesize = dw_liblist.getitemnumber(al_row, 'src_size')
if lul_orgfilesize > 0 then
	ld_comp_raito = (lul_orgfilesize - lul_filesize) / lul_orgfilesize * 100
	dw_liblist.setitem(al_row, 'comp_ratio', ld_comp_raito)
end if

dw_liblist.setitem(al_row, 'file_trans', 'Y')

return 1

end function

on fw_w_syncmanager.create
int iCurrent
call super::create
this.dw_project=create dw_project
this.cb_close=create cb_close
this.dw_liblist=create dw_liblist
this.cb_addproj=create cb_addproj
this.cb_delproj=create cb_delproj
this.cb_updproj=create cb_updproj
this.cb_addfile=create cb_addfile
this.cb_delfile=create cb_delfile
this.cb_upload=create cb_upload
this.dw_cond=create dw_cond
this.cb_zipfile=create cb_zipfile
this.cb_zipall=create cb_zipall
this.cb_refresh=create cb_refresh
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_project
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.dw_liblist
this.Control[iCurrent+4]=this.cb_addproj
this.Control[iCurrent+5]=this.cb_delproj
this.Control[iCurrent+6]=this.cb_updproj
this.Control[iCurrent+7]=this.cb_addfile
this.Control[iCurrent+8]=this.cb_delfile
this.Control[iCurrent+9]=this.cb_upload
this.Control[iCurrent+10]=this.dw_cond
this.Control[iCurrent+11]=this.cb_zipfile
this.Control[iCurrent+12]=this.cb_zipall
this.Control[iCurrent+13]=this.cb_refresh
end on

on fw_w_syncmanager.destroy
call super::destroy
destroy(this.dw_project)
destroy(this.cb_close)
destroy(this.dw_liblist)
destroy(this.cb_addproj)
destroy(this.cb_delproj)
destroy(this.cb_updproj)
destroy(this.cb_addfile)
destroy(this.cb_delfile)
destroy(this.cb_upload)
destroy(this.dw_cond)
destroy(this.cb_zipfile)
destroy(this.cb_zipall)
destroy(this.cb_refresh)
end on

event wue_postopen;call super::wue_postopen;// 어플리케이션 정보를 읽어 옵니다
string ls_appctx

ls_appctx = gnv_vari.basepath + "\" + ApplicationContextFile
if fileexists(ls_appctx) then
	dw_project.reset()
	dw_project.importfile( XML!, ls_appctx )
	//dw_project.resetupdate()
end if

if dw_project.rowcount() = 0 then
	dw_cond.insertrow(0)
	cb_addproj.post event clicked()
	return
end if

// Search조건 추가
this.of_setprojectlistddlb()
dw_cond.insertrow(0)
dw_cond.setfocus()

// 최종 사용된 프로젝트 선택
long ll_row
string ls_lastused

for ll_row = 1 to dw_project.rowcount()
	if dw_project.getitemstring(ll_row, 'last_used') = 'Y' then
		ls_lastused = dw_project.getitemstring(ll_row, 'project_name')
	end if
next

if ls_lastused = '' then
	ls_lastused = dw_project.getitemstring(1, 'project_name')
end if

dw_cond.setitem(1, 'project_name', ls_lastused)
dw_cond.post event itemchanged(1, dw_cond.object.project_name, ls_lastused)
dw_project.post resetupdate()

// 배포 파일 생성 폴더 확인
string ls_syncfolder

ls_syncfolder = gnv_vari.basepath + "\SyncProject"
if not fileexists(ls_syncfolder) then
	createdirectory(ls_syncfolder)
end if

end event

type lb_dirlist from w_window1st`lb_dirlist within fw_w_syncmanager
end type

type ln_templeft from w_window1st`ln_templeft within fw_w_syncmanager
end type

type ln_tempbuttom from w_window1st`ln_tempbuttom within fw_w_syncmanager
end type

type ln_temptop from w_window1st`ln_temptop within fw_w_syncmanager
end type

type ln_tempbutton from w_window1st`ln_tempbutton within fw_w_syncmanager
end type

type ln_tempstart from w_window1st`ln_tempstart within fw_w_syncmanager
end type

type ln_cond1_yline from w_window1st`ln_cond1_yline within fw_w_syncmanager
end type

type ln_dw1_yline from w_window1st`ln_dw1_yline within fw_w_syncmanager
end type

type ln_cond2_yline from w_window1st`ln_cond2_yline within fw_w_syncmanager
end type

type ln_dw2_yline from w_window1st`ln_dw2_yline within fw_w_syncmanager
end type

type ln_tempright from w_window1st`ln_tempright within fw_w_syncmanager
end type

type uo_navi from w_window1st`uo_navi within fw_w_syncmanager
end type

type ln_temptop_shadow from w_window1st`ln_temptop_shadow within fw_w_syncmanager
end type

type st_windelaytime from w_window1st`st_windelaytime within fw_w_syncmanager
end type

type dw_project from fw_u_dwo within fw_w_syncmanager
integer x = 50
integer y = 224
integer width = 4878
integer height = 264
integer taborder = 10
boolean bringtotop = true
string dataobject = "fw_d_syncmanager_01"
boolean scaletoright = true
boolean applydesign = true
boolean useborder = true
boolean ibdesign4cond = true
end type

event buttonclicked;call super::buttonclicked;// 타겟 선택
integer li_cnt, i
string ls_fullname, ls_filename
string ls_appname, ls_liblist[]
pf_n_pbtliblist lnv_pbtlib

// accepttext
if this.accepttext() = -1 then return

choose case dwo.name
	case 'b_target'
			if GetFileOpenName("Open", ls_fullname, ls_filename, "pbt", "PowerBuilder Target Files(*.pbt), *.pbt", "", 512) < 1 then return
			if dw_liblist.rowcount() > 0 then
				if messagebox('Notice', '기 등록된 배포대상은 클리어 됩니다.~r~n계속 진행하시겠습니까?', Question!, YesNo!, 2) = 2 then return
			end if
			
			lnv_pbtlib = create pf_n_pbtliblist
			li_cnt = lnv_pbtlib.of_parsetarget( ls_fullname )
			if li_cnt < 1 then
				MessageBox("확인", ls_fullname + "-파워빌더 타켓 파일이 아니거나, 파일이 존재하지 않습니다.")
				return
			end if
			
			ls_appname = lnv_pbtlib.is_appname
			ls_liblist = lnv_pbtlib.is_liblist
			
			this.setitem(row, 'pb_target', ls_fullname)
			
			dw_liblist.reset()
			
			for i = 1 to li_cnt
				dw_liblist.insertrow(i)
				parent.of_setlibrarylist(i, ls_liblist[i])
			next
		case 'b_ping'
			string ls_url
			
			ls_url = this.getitemstring(row, 'server_url')
			if isnull(ls_url) or len(trim(ls_url)) = 0 then
				messagebox('Notice', '먼저 배포서버 URL을 입력하세요')
				return
			end if
			
			if gnv_extfunc.biz_http_ping(ls_url, 5) then
				messagebox('URL 호출 성공!', ls_url + '~r~n페이지 호출 성공했습니다.')
			else
				messagebox('URL 호출 실패!', ls_url + '~r~n페이지 호출 실패했습니다.~r~n~r~n입력하신 URL 을 다시 확인하세요.')
			end if
end choose

end event

event rowfocuschanged;//

end event

event rowfocuschanging;//

end event

type cb_close from pf_u_commandbutton within fw_w_syncmanager
integer x = 4622
integer y = 16
integer width = 311
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "닫기"
boolean fixedtoright = true
end type

event clicked;call super::clicked;close(parent)

end event

type dw_liblist from fw_u_dwo within fw_w_syncmanager
integer x = 50
integer y = 520
integer width = 4878
integer height = 2108
integer taborder = 20
boolean bringtotop = true
string dataobject = "fw_d_syncmanager_02"
boolean hscrollbar = true
boolean scaletoright = true
boolean scaletobottom = true
boolean applydesign = true
boolean useborder = true
boolean ibsetlist4multiselect = true
end type

type cb_addproj from pf_u_commandbutton within fw_w_syncmanager
integer x = 1509
integer y = 16
integer width = 402
integer height = 108
integer taborder = 10
boolean bringtotop = true
string text = "프로젝트 추가"
boolean fixedtoright = true
end type

event clicked;call super::clicked;long ll_new

ll_new = dw_project.insertrow(0)
dw_project.scrolltorow(ll_new)
dw_project.setrow(ll_new)
dw_project.setfocus()

dw_liblist.reset()
dw_cond.setitem(1, 'project_name', '')

end event

type cb_delproj from pf_u_commandbutton within fw_w_syncmanager
integer x = 1920
integer y = 16
integer width = 402
integer height = 108
integer taborder = 10
boolean bringtotop = true
string text = "프로젝트 삭제"
boolean fixedtoright = true
end type

event clicked;call super::clicked;string ls_project_name
string ls_appctx, ls_libctx
long i

ls_project_name = dw_cond.getitemstring(1, 'project_name')
if pf_f_isemptystring(ls_project_name) then return

if messagebox('삭제 확인', '정말로 [' + ls_project_name + '] 프로젝트 정보와 라이브러리 정보를 삭제하시겠습니까?', Question!, YesNo!, 2) = 2 then return

// 프로젝트 정보 삭제
dw_project.deleterow(dw_project.getrow())

// 라이브러리 정보 삭제
for i = dw_liblist.rowcount() to 1 step -1
	dw_liblist.deleterow(i)
next

// 프로젝트 정보 저장
ls_appctx = gnv_vari.basepath + "\" + ApplicationContextFile
if dw_project.saveas(ls_appctx, xml!, false) = -1 then
	messagebox('Notice', '프로젝트 정보를 저장할 수 없습니다')
	return
end if

// 라이브러리 정보 저장
ls_libctx = gnv_vari.basepath + "\SyncProject\" + ls_project_name + "\" + ls_project_name + ".xml"
if filedelete(ls_libctx) = false then
	messagebox('Notice', '[' + ls_libctx + '] 라이브러리 정보를 삭제할 수 없습니다')
	return
end if

// 조회조건 재설정
parent.of_setprojectlistddlb()

dw_project.resetupdate()
dw_liblist.resetupdate()

// GetFocus 프로젝트로 이동
long ll_row

ll_row = dw_project.getrow()
if ll_row > 0 then
	ls_project_name = dw_project.getitemstring(ll_row, 'project_name')
	dw_cond.setitem(1, 'project_name', ls_project_name)
	dw_cond.event itemchanged(1, dw_cond.object.project_name, ls_project_name)
end if

dw_project.setredraw(true)
messagebox('Notice', '프로젝트 정보를 삭제했습니다')
return

end event

type cb_updproj from pf_u_commandbutton within fw_w_syncmanager
integer x = 2331
integer y = 16
integer width = 402
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "프로젝트 저장"
boolean fixedtoright = true
end type

event clicked;call super::clicked;long ll_row
string ls_project_name, ls_pb_target, ls_server_url

if dw_project.accepttext() = -1 then return
ll_row = dw_project.getrow()
if  ll_row = 0 then return

if dw_project.modifiedcount() + dw_liblist.modifiedcount() = 0 then return

// 필수입력사항 확인
ls_project_name = dw_project.getitemstring(ll_row, 'project_name')
ls_pb_target = dw_project.getitemstring(ll_row, 'pb_target')
ls_server_url = dw_project.getitemstring(ll_row, 'server_url')

if pf_f_isemptystring(ls_project_name) then
	messagebox('Notice', '프로젝트 명을 입력하세요')
	return
end if

if pf_f_isemptystring(ls_pb_target) then
	messagebox('Notice', '배포할 파워빌더 타겟 파일을 선택하세요')
	return
end if

if pf_f_isemptystring(ls_server_url) then
	messagebox('Notice', '배포할 서버 URL 정보를 입력하세요')
	return
end if

// 프로젝트 명칭 중복확인
long i

for i = 1 to dw_project.rowcount()
	if i = ll_row then continue
	if ls_project_name = dw_project.getitemstring(i, 'project_name') then
		messagebox('Notice', '[' + ls_project_name + '] 프로젝트 명칭은 이미 사용중입니다.')
		return
	end if
next

// 최종 사용된 어플리케이션 등록
string ls_appctx, ls_libctx

for i = 1 to dw_project.rowcount()
	if i = ll_row then
		dw_project.setitem(i, 'last_used', 'Y')
	else
		dw_project.setitem(i, 'last_used', 'N')
	end if
next

if dw_project.getitemstatus(ll_row, 0, primary!) = newmodified! then
	parent.of_setprojectlistddlb()
	dw_cond.setitem(1, 'project_name', ls_project_name)
end if

// 빈 프로젝트 제거
for i = dw_project.rowcount() to 1 step -1
	if dw_project.getitemstatus(i, 0, primary!) = new! or pf_f_isemptystring(dw_project.getitemstring(i, 'project_name')) then
		dw_project.deleterow(i)
	end if
next

// 프로젝트 정보 저장
ls_appctx = gnv_vari.basepath + "\" + ApplicationContextFile
if dw_project.saveas(ls_appctx, xml!, false) = -1 then
	messagebox('Notice', '프로젝트 정보를 저장할 수 없습니다')
	return
end if

// 배포용 폴더 검사
string ls_syncfolder

ls_syncfolder = gnv_vari.basepath + "\SyncProject\" + ls_project_name
if not fileexists(ls_syncfolder) then
	createdirectory(ls_syncfolder)
end if

// 라이브러리 정보 저장
ls_libctx = gnv_vari.basepath + "\SyncProject\" + ls_project_name + "\" + ls_project_name + ".xml"
if dw_liblist.saveas(ls_libctx, xml!, false) = -1 then
	messagebox('Notice', '라이브러리 정보를 저장할 수 없습니다')
	return
end if

dw_project.resetupdate()
dw_liblist.resetupdate()

dw_project.setredraw(true)
messagebox('Notice', '프로젝트 정보를 저장했습니다')

end event

type cb_addfile from pf_u_commandbutton within fw_w_syncmanager
integer x = 3026
integer y = 16
integer width = 311
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "파일 추가"
boolean fixedtoright = true
end type

event clicked;call super::clicked;// 배포할 라이브러리 추가
string ls_pb_target, ls_initpath
string ls_docpath, ls_docname[]
long ll_row, ll_new
integer i, li_cnt, li_rtn

ll_row = dw_project.getrow()
if ll_row = 0 then return

ls_pb_target = dw_project.getitemstring(ll_row, 'pb_target')
ls_initpath = gnv_extfunc.of_pathremovefilespec(ls_pb_target)
li_rtn = GetFileOpenName("Select File", ls_docpath, ls_docname[], "*", "All Files (*.*), *.*", ls_initpath)
if li_rtn < 1 then return

if upperbound(ls_docname) = 1 then
	ls_docname[1] = ls_docpath
else
	for i = 1 to upperbound(ls_docname)
		ls_docname[i] = ls_docpath + '\' + ls_docname[i]
	next
end if

ll_row = dw_liblist.getrow()
li_cnt = Upperbound(ls_docname)
for i = li_cnt to 1 step -1
	ll_new = dw_liblist.insertrow(ll_row)
	parent.of_setlibrarylist(ll_new, ls_docname[i])
next

messagebox('Notice', "선택하신 파일을 배포대상으로 추가했습니다.~r~n'프로젝트 저장' 버튼을 클릭해 변경 내역을 저장하세요.")
return

end event

type cb_delfile from pf_u_commandbutton within fw_w_syncmanager
integer x = 3346
integer y = 16
integer width = 311
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "파일 삭제"
boolean fixedtoright = true
end type

event clicked;call super::clicked;long ll_cnter
long ll_row, ll_selected[]
string ls_selected

ll_row = dw_liblist.getselectedrow(0)
do while ll_row > 0
	ll_cnter++
	ll_selected[ll_cnter] = ll_row
	ls_selected += dw_liblist.getitemstring(ll_row, 'path') + '~r~n'
	
	ll_row = dw_liblist.getselectedrow(ll_row)
loop

if ll_cnter = 0 then
	messagebox('Notice', '먼저 삭제할 파일들을 선택하세요')
	return
end if

if messagebox("삭제 확인", "선택하신 파일= ~r~n" + ls_selected + "위 라이브러리를 배포대상에서 제외합니다.", Question!, YesNo!, 2) = 2 then
	return
end if

for ll_row = ll_cnter to 1 step -1
	dw_liblist.deleterow(ll_selected[ll_row])
next

messagebox('Notice', "선택하신 파일을 삭제했습니다.~r~n'프로젝트 저장' 버튼을 클릭해 변경 내역을 저장하세요.")
return

end event

type cb_upload from pf_u_commandbutton within fw_w_syncmanager
integer x = 4306
integer y = 16
integer width = 311
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "파일 전송"
boolean fixedtoright = true
end type

event clicked;call super::clicked;// 압축 파일 서버에 전송

long i, ll_row, ll_cnter
string ls_project_name
string ls_uploadfiles[]
string ls_uploadurl, ls_subdir
fw_n_httpfile lnv_http

lnv_http = create fw_n_httpfile

if dw_project.accepttext() = -1 then return
ll_row = dw_project.getrow()
if  ll_row = 0 then return

ls_project_name = dw_project.getitemstring(ll_row, 'project_name')
if pf_f_isemptystring(ls_project_name) then return

ls_uploadurl = dw_project.getitemstring(ll_row, 'server_url')
if pf_f_isemptystring(ls_uploadurl) then return

ls_subdir = UploadSubDir + ls_project_name

// ZIP 파일 경로
string ls_zipfolder
string ls_zipfile

ls_zipfolder = gnv_vari.basepath  + "\SyncProject\" + ls_project_name + "\" 

for i = 1 to dw_liblist.rowcount()
	if fw_f_nvls(dw_liblist.getitemstring(i, 'file_trans'), '') <> 'Y' then continue
	
	ls_zipfile = dw_liblist.getitemstring(i, 'zip_name')
	if pf_f_isemptystring(ls_zipfile) then
		dw_liblist.scrolltorow(i)
		dw_liblist.setrow(i)
		messagebox('Notice', dw_liblist.getitemstring(i, 'path') + '~r~n파일은 아직 압축되지 않았습니다~r~n먼저 압축작업을 진행 후 배포하세요')
		return -1
	end if
	
	ll_cnter ++
	ls_uploadfiles[ll_cnter] = ls_zipfolder + ls_zipfile
next

// 버전파일 추가 및 배포
string ls_libctx

if ll_cnter > 0 then
	ls_libctx = gnv_vari.basepath + "\SyncProject\" + ls_project_name + "\" + ls_project_name + ".xml"
	if dw_liblist.saveas(ls_libctx, xml!, false) = -1 then
		messagebox('Notice', '라이브러리 정보를 저장할 수 없습니다')
		return
	end if
	
	ll_cnter ++
	ls_uploadfiles[ll_cnter] = ls_libctx
	
	if lnv_http.of_fileupload(ls_uploadfiles, ls_uploadurl, ls_subdir) = 0 then
		for i = 1 to dw_liblist.rowcount()
			if dw_liblist.getitemstring(i, 'file_trans') = 'Y' then
				dw_liblist.setitem(i, 'file_trans', 'N')
			end if
		next
		
		if dw_liblist.saveas(ls_libctx, xml!, false) = -1 then
			messagebox('Notice', '라이브러리 정보를 저장할 수 없습니다')
			return
		end if
	end if
else
	messagebox('Notice', "전송할 파일이 없습니다.~r~n전송할 파일들은 '전송 CheckBox'를 클릭하세요")
	return
end if

//if messagebox('Notice', '파일 전송이 완료됐습니다.~r~n프로젝트 파일을 저장하시겠습니까?', Question!, YesNo!, 2) = 1 then
//	cb_updproj.post event clicked()
//end if

end event

type dw_cond from datawindow within fw_w_syncmanager
integer x = 50
integer y = 124
integer width = 1038
integer height = 96
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "fw_d_syncmanager_cond"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if row = 0 then return

string ls_project_name, ls_libctx
long ll_find, i

choose case dwo.name
	case 'project_name'
		ls_project_name = data
		
		ll_find = dw_project.find("project_name='" + ls_project_name + "'", 1, dw_project.rowcount())
		if ll_find > 0 then
			dw_project.scrolltorow(ll_find)
			dw_project.setrow(ll_find)
			dw_project.post setredraw(true)
			
			ls_libctx = gnv_vari.basepath + "\SyncProject\" + ls_project_name + "\" + ls_project_name + ".xml"
			dw_liblist.reset()
			dw_liblist.importfile(xml!, ls_libctx)
			dw_liblist.resetupdate()
			
			// Refresh 라이브러리 리스트
			cb_refresh.post event clicked()
			
			// Default 프로젝트 설정
			for i = 1 to dw_project.rowcount()
				if i = ll_find then
					dw_project.setitem(i, 'last_used', 'Y')
				else
					dw_project.setitem(i, 'last_used', 'N')
				end if
			next
		end if
end choose

return 0

end event

type cb_zipfile from pf_u_commandbutton within fw_w_syncmanager
integer x = 3666
integer y = 16
integer width = 311
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "파일압축"
boolean fixedtoright = true
end type

event clicked;call super::clicked;// 선택 파일 압축
long ll_row, ll_cnter

setpointer(hourglass!)
post setpointer(arrow!)

ll_row = dw_liblist.getselectedrow(0)
do while ll_row > 0
	if parent.of_compresslibrarylist(ll_row) = -1 then return
	ll_cnter ++
	ll_row = dw_liblist.getselectedrow(ll_row)
loop

if ll_cnter > 0 then
	if messagebox('Notice', '파일 압축이 끝났습니다.~r~n압축한 파일을 서버에 전송하시겠습니까?', Question!, YesNo!, 2) = 1 then
		cb_upload.post event clicked()
	end if
else
	messagebox('Notice', '압축할 파일을 선택하세요.~r~n다중행 선택은 Shift 또는 Ctrl 키를 누른상태에서~r~n여러행을 선택하세요')
end if

end event

type cb_zipall from pf_u_commandbutton within fw_w_syncmanager
integer x = 3986
integer y = 16
integer width = 311
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "전체압축"
boolean fixedtoright = true
end type

event clicked;call super::clicked;// 전체 파일 압축
long ll_row, ll_cnter

setpointer(hourglass!)
post setpointer(arrow!)

if messagebox('Notice', '정말로 모든 파일을 압축 후 전송하시겠습니까?', Exclamation!, YesNo!, 2) = 2 then return

for ll_row = 1 to dw_liblist.rowcount()
	if parent.of_compresslibrarylist(ll_row) = -1 then return
	ll_cnter ++
next

if ll_cnter > 0 then
	if messagebox('Notice', '파일 압축이 모두 끝났습니다.~r~n압축한 파일을 서버에 전송하시겠습니까?', Question!, YesNo!, 2) = 1 then
		cb_upload.post event clicked()
	end if
end if

end event

type cb_refresh from pf_u_commandbutton within fw_w_syncmanager
integer x = 2743
integer y = 16
integer width = 274
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "리프레시"
boolean fixedtoright = true
end type

event clicked;call super::clicked;// Refresh LibraryList

long ll_row, ll_null
string ls_filename, ls_null
datetime ldtm_modified, ldtm_null
long lul_filesize

setnull(ls_null)
setnull(ll_null)
setnull(ldtm_null)

for ll_row = 1 to dw_liblist.rowcount()
	ls_filename = dw_liblist.getitemstring(ll_row, 'path')
	
	// 라이브러리 파일 일자 및 크기 비교
	gnv_extfunc.of_getfilewritetime(ls_filename, ldtm_modified)
	lul_filesize = gnv_extfunc.biz_getfilesize(ls_filename)
	
	// 파일변경일이 바뀌거나 사이즈가 바뀐경우
	if ldtm_modified <> dw_liblist.getitemdatetime(ll_row, 'src_lastmodifydate') or &
		lul_filesize <> dw_liblist.getitemnumber(ll_row, 'src_size') then
		
		dw_liblist.setitem(ll_row, 'src_lastmodifydate', ldtm_modified)
		dw_liblist.setitem(ll_row, 'src_size', lul_filesize)
		
		dw_liblist.setitem(ll_row, 'zip_name', ls_null)
		dw_liblist.setitem(ll_row, 'dest_lastmodifydate', ldtm_null)
		dw_liblist.setitem(ll_row, 'dest_size', ll_null)
		dw_liblist.setitem(ll_row, 'comp_ratio', ll_null)
		dw_liblist.setitem(ll_row, 'file_trans', ls_null)
		
		// 변경된 파일은 자동으로 '전송' 체크 및 SelectRow
		dw_liblist.setitem(ll_row, 'file_trans', 'Y')
		dw_liblist.SelectRow(ll_row, True)
	end if
next

return 0

end event

