forward
global type w_fw_version_manage from wt_list
end type
type cb_2 from pf_u_commandbutton within w_fw_version_manage
end type
type lb_dir from listbox within w_fw_version_manage
end type
type cb_1 from pf_u_commandbutton within w_fw_version_manage
end type
end forward

global type w_fw_version_manage from wt_list
integer ii_dddw_width = 1000
string is_init_value = "\"
cb_2 cb_2
lb_dir lb_dir
cb_1 cb_1
end type
global w_fw_version_manage w_fw_version_manage

type variables

end variables

forward prototypes
public function integer uf_save (string lib_id)
end prototypes

public function integer uf_save (string lib_id);BLOB	lib_data

STRING	ls_dir, ls_lib_dir

ls_lib_dir = dw_c.object.dddw [1]

IF	ls_lib_dir='..\'	Then
	ls_dir = f_replace (gnv_vari.basepath,'kernel','')
ElseIF POS (ls_lib_dir,'..\')>0	Then
	ls_dir = f_replace (gnv_vari.basepath,'kernel','') + f_replace (ls_lib_dir,'..\','')
Else
	ls_dir = gnv_vari.basepath + ls_lib_dir
End IF

lib_data = BLOB (' ')
// 압축시작
IF	mo_.zip (ls_dir + lib_id, ls_dir + lib_id + '.zip', 'f')<>0	Then
	f_messagebox ('ERR', '압축실패!')
	RETURN -1
End IF
SQLCA.setupdateBLOB_file (ls_dir + lib_id + '.zip')

UPDATEBLOB  fw_version
   SET  lib_file = :lib_data
WHERE   lib_dir = :ls_lib_dir
  AND   lib_id  = :lib_id;
IF SQLCA.sqlcode ()<>0  Then
   f_messageBox ('SQLCA', 'UPDATEBLOB fw_version ERROR')
   RETURN -1
End IF

filedelete (ls_dir + lib_id + '.zip')
gw_mdi.setmicrohelp (lib_id + '...update')

RETURN 0
end function

on w_fw_version_manage.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.lb_dir=create lb_dir
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.lb_dir
this.Control[iCurrent+3]=this.cb_1
end on

on w_fw_version_manage.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.lb_dir)
destroy(this.cb_1)
end on

event wue_retrieve;call super::wue_retrieve;cb_1.Enabled = ib_managedata
cb_2.Enabled = ib_managedata
dw_List.retrieve (dw_c.object.dddw [1], IIF(ib_managedata,1,0))
end event

event wue_clear;call super::wue_clear;cb_1.Enabled = FALSE
cb_2.Enabled = FALSE
end event

event wue_lastopen;call super::wue_lastopen;dw_c.object.dddw [1] = '\'
IF	POS (gnv_vari.basepath,'.client')>0 THEN ib_managedata = false
end event

event open;icmdbutton = { cb_2, cb_1 }
call super::open
end event

type lb_dirlist from wt_list`lb_dirlist within w_fw_version_manage
end type

type ln_templeft from wt_list`ln_templeft within w_fw_version_manage
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_fw_version_manage
end type

type ln_temptop from wt_list`ln_temptop within w_fw_version_manage
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_fw_version_manage
end type

type ln_tempstart from wt_list`ln_tempstart within w_fw_version_manage
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_fw_version_manage
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_fw_version_manage
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_fw_version_manage
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_fw_version_manage
end type

type ln_tempright from wt_list`ln_tempright within w_fw_version_manage
end type

type uo_navi from wt_list`uo_navi within w_fw_version_manage
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_fw_version_manage
end type

type st_windelaytime from wt_list`st_windelaytime within w_fw_version_manage
end type

type st_top_rect from wt_list`st_top_rect within w_fw_version_manage
end type

type p_close from wt_list`p_close within w_fw_version_manage
end type

type p_excel from wt_list`p_excel within w_fw_version_manage
end type

type p_print from wt_list`p_print within w_fw_version_manage
end type

type p_delete from wt_list`p_delete within w_fw_version_manage
end type

type p_update from wt_list`p_update within w_fw_version_manage
end type

type p_input from wt_list`p_input within w_fw_version_manage
end type

type p_retrieve from wt_list`p_retrieve within w_fw_version_manage
end type

type p_clear from wt_list`p_clear within w_fw_version_manage
end type

type p_copy from wt_list`p_copy within w_fw_version_manage
end type

type dw_c from wt_list`dw_c within w_fw_version_manage
string title = "실행파일위치"
string dataobject = "dc_ymd_dddw"
end type

event dw_c::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'dddw | dual', '', "\,실행파일,,\RD\,출력자료파일,,..\img\mainframe\company_logo\,회사LOGO,,..\img\mainframe\right_logo\,회사RIGHT,,..\img\mainframe\login1\,시작LOGO,,..\img\mainframe\u_pgmtab\,TAB이미지,,..\img\mainframe\u_treemenu\,TREE이미지,,..\img\controls\u_calendar\,달력이미지,", 1, "")
end event

type btn_update from wt_list`btn_update within w_fw_version_manage
end type

type st_count from wt_list`st_count within w_fw_version_manage
end type

type dw_list from wt_list`dw_list within w_fw_version_manage
string dataobject = "d_fw_version_manage"
string setlist4fontpointcolor = "compression=1=e"
string is_resize_column = "lib_cmnt"
end type

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'mod_user | user', gaa.corp_gr, '', 1, '')
end event

event dw_list::clicked;IF	ib_managedata=false	Then
	f_messagebox ('INFO', '실행모듈에서는 작업불가')
	RETURN
End IF

BOOLEAN	lb_return
STRING	ls_lib_dir, ls_lib_ver, ls_lib_id

LONG	ll, ll_count, ll_size
BLOB	lb_file

SELECT CASE WHEN MAX(SUBSTR(lib_ver,1,4)) <> TO_CHAR(sysdate,'yyyy')
            THEN 1
            ELSE NVL(MAX(SUBSTR(lib_ver,5,4)), 0) + 1
       END
  INTO :ll
  FROM FW_VERSION t1
 WHERE t1.lib_ver > TO_CHAR(:idt_workdate,'yyyy');

ll = SQLCA.GETITEMNUMBER (1)

ls_lib_ver = STRING (today (), 'yyyy') + STRING (ll,'0000')

CHOOSE CASE DWO.NAME
   CASE 'fseq_all'
      ll_count = ROWCOUNT ()
      FOR  ll= 1  TO  ll_count
         IF uf_getrange () = false  Then
            IF POS (lower (Object.lib_id [ll]),'.dll') > 0 OR POS (lower (Object.lib_id [ll]),'.msi') > 0 OR POS (lower (Object.lib_id [ll]),'.ini') > 0 &
               OR lower (Object.lib_id [ll]) = 'vcredist_x86.exe' OR POS (lower (Object.lib_id [ll]),'.xls') > 0 OR POS (lower (Object.lib_id [ll]),'.pbx') > 0 &
               OR POS (Object.lib_id [ll],'OCX_setup') > 0 OR POS (lower (Object.lib_id [ll]),'jtier') > 0 &
               OR POS (lower (Object.lib_id [ll]),'pbdom126') > 0 OR POS (lower (Object.lib_id [ll]),'wininet') > 0  Then
               SelectRow (ll,FALSE)
            ELSE
               SelectRow (ll,TRUE)
            END IF
            ELSE
            SelectRow (ll,TRUE)
            END IF
      NEXT
      uf_setrange (true)

   CASE 'file_size_t'
      ll_count = ROWCOUNT ()
      FOR  ll = 1  TO  ll_count
         ll_size = Object.file_size [ll]
         IF Object.lib_dir [ll] = '..\'   Then
	         Object.file_size [ll]  = FileLength (f_replace (gnv_vari.basepath,'kernel','') + Object.lib_id [ll])
         ELSEIF POS (Object.lib_dir [ll],'..\') > 0   Then
            Object.file_size [ll] = FileLength (f_replace (gnv_vari.basepath,'kernel','') + f_replace (Object.lib_dir [ll],'..\','') + Object.lib_id [ll])
         ELSE
            Object.file_size [ll] = FileLength (gnv_vari.basepath + Object.lib_dir [ll] + Object.lib_id [ll])
         END IF
         IF ll_size <> Object.file_size [ll] THEN Object.lib_cmnt [ll] = f_ntrim (ll_size,10,0) + ' --> ' + f_ntrim (Object.file_size [ll],0,0) + ' ( ' + f_sysdate_str ('yyyy.mm.dd') + ' )'
      NEXT

   CASE 'p_all'
      // 엑셀이 존재하는 경우 엑셀 오픈여부 체크
      ll = GetSelectedRow (0)
      DO WHILE ll > 0
         IF MID (Object.lib_id [ll], LASTPOS (Object.lib_id [ll], '.') + 1) = 'xlsx'   Then
            IF gfp.getprocesscount ('excel.exe') > 0  Then
               MESSAGEBOX ('알림','실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
               gfp.killprocess ('excel.exe')
               EXIT
            END IF
         END IF
         ll = GetSelectedRow (ll)
      LOOP

      SETROW (1)
      scrolltorow (1)
      Parent.EVENT wue_update ()

      f_loadingyield ('start')
      ll = GetSelectedRow (0)
      DO WHILE ll > 0
         IF f_loadingyield ('exit') Then
            f_messageBox ('INFO','UPLOAD 작업을 취소 했습니다.')
            RETURN
         END IF
         scrolltorow (ll)
         IF uf_save (Object.lib_id [ll]) = -1 THEN EXIT

         Object.compression [ll] = '1'
         Object.lib_ver [ll]     = ls_lib_ver
         ll_size                 = Object.file_size [ll]

         IF Object.lib_dir [ll]  = '..\'   Then
	         Object.file_size [ll] = FileLength (f_replace (gnv_vari.basepath,'kernel','') + Object.lib_id [ll])
         ELSEIF POS (Object.lib_dir [ll],'..\') > 0   Then
            Object.file_size [ll] = FileLength (f_replace (gnv_vari.basepath,'kernel','') + f_replace (Object.lib_dir [ll],'..\','') + Object.lib_id [ll])
         ELSE
            Object.file_size [ll] = FileLength (gnv_vari.basepath + Object.lib_dir [ll] + Object.lib_id [ll])
         END IF
         IF ll_size <> Object.file_size [ll] THEN Object.lib_cmnt [ll] = f_ntrim (ll_size,10,0) + ' --> ' + f_ntrim (Object.file_size [ll],0,0) + ' ( ' + f_sysdate_str ('yyyy.mm.dd') + ' )'
         Object.mod_user [ll] = gnv_vari.is_user_nm
         Object.mod_ymdt [ll] = DATETIME (today (), now ())
         selectrow (ll,FALSE)
         ll = GetSelectedRow (ll)
      LOOP
      f_loadingyield ('stop')
      parent.POST EVENT wue_update ()
      f_messageBox ('INFO','UPLOAD 저장을 완료 했습니다.')

   CASE 'p_upload'
      uf_setrow (ROW,TRUE)
      parent.EVENT wue_update ()

      // 엑셀인 경우 엑셀 오픈여부 체크
      IF MID (Object.lib_id [row], LASTPOS (Object.lib_id [row], '.') + 1) = 'xlsx' Then
         IF gfp.getprocesscount ('excel.exe') > 0  Then
            MESSAGEBOX ('알림','실행 중인 excel을 모두 강제종료 합니다.~r~n작업중인 excel sheet는 저장하십시오.')
            gfp.killprocess ('excel.exe')
         END IF
     END IF

      IF uf_save (Object.lib_id [row]) = -1 THEN RETURN

      Object.compression [row] = '1'
      Object.lib_ver [row]     = ls_lib_ver
      ll_size                  = Object.file_size [row]

      IF Object.lib_dir [row]  = '..\'  Then
	      Object.file_size [row] = FileLength (f_replace (gnv_vari.basepath,'kernel','') + Object.lib_id [row])
      ELSEIF POS (Object.lib_dir [row],'..\') > 0  Then
         Object.file_size [row] = FileLength (f_replace (gnv_vari.basepath,'kernel','') + f_replace (Object.lib_dir [row],'..\','') + Object.lib_id [row])
      ELSE
         Object.file_size [row] = FileLength (gnv_vari.basepath + Object.lib_dir [row] + Object.lib_id [row])
      END IF
      IF ll_size <> Object.file_size [row] THEN Object.lib_cmnt [row] = f_ntrim (ll_size,10,0) + ' --> ' + f_ntrim (Object.file_size [row],0,0) + ' ( ' + f_sysdate_str ('yyyy.mm.dd') + ' )'
      object.mod_user [row] = gnv_vari.is_user_nm
      Object.mod_ymdt [row] = DATETIME (today (), now ())

   CASE 'p_temp'
      uf_setrow (ROW,TRUE)
      ls_lib_dir = Object.lib_dir [row]
      ls_lib_id  = Object.lib_id [row]

      SELECTBLOB lib_file
        INTO :lb_file
        FROM FW_VERSION t1
       WHERE lib_dir = :ls_lib_dir
         AND lib_id  = :ls_lib_id ;

      IF gaa.login = 'yjs1992@hitel.net' AND Object.lib_dir [row] = '\RD\' Then
         IF Object.compression [row] = '1'   Then
            lb_return = mo_.hex2file (gnv_vari.basepath + Object.lib_dir [row] + Object.lib_id [row] + '.zip',SQLCA.is_Hexfile)
            IF lb_return   Then
					 /* 압축풀기... */
               mo_.unzip (gnv_vari.basepath + Object.lib_dir [row] + Object.lib_id [row] + '.zip',gnv_vari.basepath + Object.lib_dir [row])
               filedelete (gnv_vari.basepath + Object.lib_dir [row] + Object.lib_id [row] + '.zip')
            END IF
         ELSE
            lb_return = mo_.hex2file (gnv_vari.basepath + Object.lib_dir [row] + Object.lib_id [row],SQLCA.is_hexfile)
         END IF
         IF lb_return   Then
            MESSAGEBOX ('write OK',gnv_vari.basepath + STRING (Object.lib_dir [row] + Object.lib_id [row]) + '(저장)')
         ELSE
            MESSAGEBOX ('write error',gnv_vari.basepath + STRING (Object.lib_dir [row] + Object.lib_id [row]) + '(저장오류)')
         END IF
         gnv_extfunc.of_shellexecute (gnv_vari.basepath + Object.lib_dir [row])
      ELSE
         IF Object.compression [row] = '1'   Then
            lb_return = mo_.hex2file ('c:\temp\' + Object.lib_id [row] + '.zip',SQLCA.is_Hexfile)
            IF lb_return   Then
					/* 압축풀기... */
               mo_.unzip ('c:\temp\' + Object.lib_id [row] + '.zip','c:\temp')
					// filedelete ('c:\temp\' + Object.lib_id [row] + '.zip')
            END IF
         ELSE
            lb_return = mo_.hex2file ('c:\temp\' + Object.lib_id [row],SQLCA.is_hexfile)
         END IF
         IF lb_return   Then
            MESSAGEBOX ('write OK','c:\temp\' + STRING (Object.lib_id [row]) + '(저장)')
         ELSE
            MESSAGEBOX ('write error','c:\temp\' + STRING (Object.lib_id [row]) + '(저장오류)')
         END IF
         gnv_extfunc.of_shellexecute ('c:\temp')
      END IF
   CASE ELSE
      CAll super::clicked
END CHOOSE
end event

event dw_list::ue_retrieve;call super::ue_retrieve;INT   lRow, value

STRING	docname, named

lRow = GetRow ()

value = GetFileOpenName("Select File", + docname, named, "DOC", + "PBD Files (*.PBD),*.PBD," &
                                                                  + "PBL Files (*.PBL),*.PBL," &
                                                                  + "BMP Files (*.BMP),*.BMP," &
                                                                  + "INI Files (*.INI),*.INI," &
                                                                  + "DLL Files (*.DLL),*.DLL," &
                                                                  + "DLL Files (*.EXE),*.EXE," &
                                                                  + "DLL Files (*.mrd),*.mrd," &
                                                                  + "ALL Files (*.*),*.*")
IF value=1 THEN SetItem(lRow, 'lib_id', named)

end event

event dw_list::ue_insertstart;call super::ue_insertstart;uf_setcolumn ('lib_dir', dw_c.object.dddw [1])
uf_setcolumn ('mod_user', gnv_vari.is_user_nm)
uf_setcolumn ('mod_ymdt', string (f_sysdate ('')))
uf_setcolumn ('compression', '0')

POST SetColumn ('lib_id')

RETURN 0
end event

type cb_2 from pf_u_commandbutton within w_fw_version_manage
integer x = 2231
integer y = 16
integer width = 457
integer taborder = 30
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "변경분선택"
end type

event clicked;LONG	ll, ll_count, ll_size

dw_list.SelectRow (0, false)

ll_count = dw_list.rowcount ()
FOR  ll = 1  TO  ll_count
	IF	dw_list.object.lib_dir [ll]='..\'	Then
		ll_size = FileLength (f_replace (gnv_vari.basepath,'kernel','') + dw_list.object.lib_id [ll])
	ElseIF POS (dw_list.object.lib_dir [ll],'..\')>0	Then
		ll_size = FileLength (f_replace (gnv_vari.basepath,'kernel','') + f_replace (dw_list.object.lib_dir [ll],'..\','') + dw_list.object.lib_id [ll])
	Else
		ll_size = FileLength (gnv_vari.basepath + dw_list.object.lib_dir [ll] + dw_list.object.lib_id [ll])
	End IF
	IF	ll_size<>dw_list.object.file_size [ll] THEN dw_list.SelectRow (ll, TRUE)
NEXT
dw_list.uf_setrange (true)
end event

type lb_dir from listbox within w_fw_version_manage
boolean visible = false
integer x = 4425
integer y = 368
integer width = 480
integer height = 424
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 33554432
boolean enabled = false
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type cb_1 from pf_u_commandbutton within w_fw_version_manage
integer x = 2702
integer y = 16
integer width = 457
integer taborder = 40
boolean bringtotop = true
integer weight = 400
fontcharset fontcharset = hangeul!
boolean enabled = false
string text = "일괄추가"
end type

event clicked;LONG	ll, lCount, lFind

STRING	ls_dir, ls_exp

lCount = dw_List.rowcount ()

IF	dw_c.object.dddw [1]='..\'	Then
	ls_dir = f_replace (gnv_vari.basepath,'kernel','')
ElseIF POS (dw_c.object.dddw [1],'..\')>0	Then
	ls_dir = f_replace (gnv_vari.basepath,'kernel','') + f_replace (dw_c.object.dddw [1],'..\','')
Else
	ls_dir = gnv_vari.basepath + dw_c.object.dddw [1]
End IF
lb_dir.DirList (ls_dir + "*.*", 0)
FOR  ll = 1  TO  lb_dir.totalitems ()
   ls_exp = MID (lb_dir.TEXT (ll), LASTPOS (lb_dir.TEXT (ll), '.') + 1)
   CHOOSE CASE lower (ls_exp)
      CASE 'bak'
         CONTINUE
      CASE 'mrd'
         IF dw_c.object.dddw [1]<>'\RD\' THEN CONTINUE
      CASE 'gif','jpg','png','bmp','ico'
         IF POS (dw_c.object.dddw [1],'..\img\')=0 THEN CONTINUE
      CASE 'pbd','exe','pbx','msi','xls','xlsx','xlsm'
         IF dw_c.object.dddw [1]<>'\' THEN CONTINUE
      CASE 'dll'
         IF dw_c.object.dddw [1]<>'\' THEN CONTINUE
      CASE Else
         IF LEFT (lower (lb_dir.TEXT (ll)),9)='fw_config' OR LEFT (lower (lb_dir.TEXT (ll)),6)='config'	Then
            IF dw_c.object.dddw [1]<>'\' THEN CONTINUE
         Else
            CONTINUE
         End IF
   END CHOOSE
   lFind = dw_List.FIND ("lib_id='" + lb_dir.TEXT (ll) + "'", 1, lCount)
   IF lFind=0  Then
      lCount ++
      lFind = dw_List.EVENT ue_insert (0)
      dw_List.object.lib_id [lFind] = lb_dir.TEXT (ll)
      dw_List.object.lib_ver [lFind] = string (today (),'yyyy') + '0000'
   End IF
NEXT

changedirectory (gnv_vari.basepath)
end event

