forward
global type fw_n_dwcache from n_ancestor
end type
end forward

global type fw_n_dwcache from n_ancestor
end type
global fw_n_dwcache fw_n_dwcache

type variables
fw_n_dso	ids_applydesignobj, ids_checkdesignobj, ids_stylesyntax	/* to-be designsyntax */
end variables

forward prototypes
public function string of_thisname ()
public subroutine of_setdesigncachedatastorebyinit ()
public subroutine of_applydesigncreate (string as_pgm_id, string as_dw_id)
public subroutine of_getalldbcache ()
public subroutine of_checkdesignsyntax ()
public subroutine of_setdesignobjsyn ()
public function string of_getdesignsyntaxcs ()
public function string of_setdesignobj (string as_designstyle)
end prototypes

public function string of_thisname ();return 'fw_n_dwcache'
end function

public subroutine of_setdesigncachedatastorebyinit ();gnv_extfunc.biznode1te(132, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
ids_checkdesignobj = Create fw_n_dso
ids_checkdesignobj.dataobject = gnv_extfunc.is_nodevalue

gnv_extfunc.biznode1te(133, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
ids_applydesignobj = Create fw_n_dso
ids_applydesignobj.dataobject = gnv_extfunc.is_nodevalue

gnv_extfunc.biznode1te(134, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
ids_stylesyntax = Create fw_n_dso
ids_stylesyntax.DataObject = gnv_extfunc.is_nodevalue
end subroutine

public subroutine of_applydesigncreate (string as_pgm_id, string as_dw_id);STRING	ls_createsyntax, ls_dwobjnm, ErrorBuffer
STRING	ls_pgmlib, ls_parentid, ls_dataobject, ls_creategb, ls_pgmid, ls_dwid,ls_blob_err

LONG	ll_rtn
LONG	ll_rowcnt, ll_blob
BLOB	lb_syntax

ids_applydesignobj.SetTransObject(SQLCA )
gnv_extfunc.biznode2te(210, gnv_vari.is_nodekey, as_pgm_id, gnv_extfunc.is_nodevalue)
ll_rowcnt = ids_applydesignobj.retrieve (gnv_vari.SetEssSite, gnv_vari.mswindowrate, gnv_extfunc.is_nodevalue, as_pgm_id, as_dw_id)

IF ll_rowcnt<1 THEN RETURN

ls_dataobject  = ids_applydesignobj.GetItemString(1, 'dataobject')
ls_pgmid       = ids_applydesignobj.GetItemString(1, 'pgm_id')
ls_dwid        = ids_applydesignobj.GetItemString(1, 'dw_id')
ls_creategb    = ids_applydesignobj.GetItemString(1, 'creategb')
ls_pgmlib      = ids_applydesignobj.GetItemString(1, 'pgm_lib')
IF fw_f_nvls(ls_pgmlib, '')='' THEN RETURN
ls_pgmlib      = gnv_vari.basepath + "\" + ls_pgmlib

SELECTBLOB  la.createsyntax
  INTO  :lb_syntax
FROM    fw_designsyntax la
WHERE   la.site_id    = :gnv_vari.SetEssSite
  AND   la.dataobject = :ls_dataobject
  AND   la.windowrate = :gnv_vari.mswindowrate
  AND   pgm_id        = :ls_pgmid
  AND   dw_id         = :ls_dwid;

IF	SQLCA.SQLCode ()=0	Then
	ll_blob = mo_.hex2blob(SQLCA.is_hexfile, lb_syntax, ls_blob_err)
	IF	ll_blob<0	Then
		messageBox ('blob err', ls_blob_err)
	End IF
Else
	messageBox ('blob err', ls_blob_err)
End IF

ls_createsyntax = string(lb_syntax, EncodingANSI!)

IF fw_f_nvls(ls_createsyntax, '')='' THEN RETURN

STRING	ls_syntax[]

LONG	ll_syncnt

gnv_extfunc.biznode1te(104, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
ll_syncnt = fw_f_obj2array(ls_createsyntax, "~r~n" + gnv_extfunc.is_nodevalue + "~r~n", ls_syntax[])

IF fw_f_nvls(ls_syntax[9], '')<>''  Then
   ls_dwobjnm  = ls_pgmid + '_' + ls_dwid
   ll_rtn      = LibraryImport(ls_pgmlib, ls_dwobjnm, ImportDataWindow!, ls_syntax[9], ErrorBuffer )

   IF ll_rtn=1 Then
      STRING	ls_datetime
      ls_datetime = fw_f_getymdhh24miss4s()
      gnv_extfunc.biznode1te(106, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
      ids_applydesignobj.SetItem(1, 'creategb', gnv_extfunc.is_nodevalue)
      ids_applydesignobj.SetItem(1, 'upd_id', gnv_vari.is_user_id)
      ids_applydesignobj.SetItem(1, 'upd_dt', ls_datetime)
   End IF
End IF

IF ids_applydesignobj.update ()=1 Then
   commitJ ()
   //This.of_getalldbcache() /* gnv_rolemenu.ids_stylesyntax retrieve */
Else
   rollbackJ ()
End IF
end subroutine

public subroutine of_getalldbcache ();Long	ll_ret
ids_stylesyntax.SetTransObject( sqlca )
ll_ret = ids_stylesyntax.retrieve(gnv_vari.SetEssSite, gnv_vari.mswindowrate)

If ll_ret = -1 Then Messagebox('Error', 'ids_stylesyntax Load fail')
end subroutine

public subroutine of_checkdesignsyntax ();STRING	ls_createsyntax, ls_dwobjnm, ls_designdwobj
STRING	ls_pgmlib, ls_parentid, ls_dataobject, ls_creategb, ls_pgmid, ls_dwid, ls_blob_err

LONG	ll_rtn, ll_rowcnt, ll_i, ll_chkcnt, ll_blob

BLOB	lb_syntax

fw_n_dso lds_libobj

ids_checkdesignobj.SetTransObject(SQLCA)
ll_rowcnt = ids_checkdesignobj.retrieve (gnv_vari.SetEssSite, gnv_vari.mswindowrate)

IF ll_rowcnt<1 THEN RETURN
For ll_i = 1 To ll_rowcnt
   ls_dataobject  = ids_checkdesignobj.GetItemString(ll_i, 'dataobject')
   ls_pgmid       = ids_checkdesignobj.GetItemString(ll_i, 'pgm_id')
   ls_dwid        = ids_checkdesignobj.GetItemString(ll_i, 'dw_id')
   ls_creategb    = ids_checkdesignobj.GetItemString(ll_i, 'creategb')
   ls_pgmlib      = ids_checkdesignobj.GetItemString(ll_i, 'pgm_lib')
   IF fw_f_nvls(ls_pgmlib, '')='' THEN Continue
      ls_pgmlib	= gnv_vari.basepath + "\" + ls_pgmlib

      SELECTBLOB  la.createsyntax
        INTO  :lb_syntax
      FROM    fw_designsyntax la
      WHERE   la.site_id    = :gnv_vari.SetEssSite
        AND   la.dataobject = :ls_dataobject
        AND   la.windowrate = :gnv_vari.mswindowrate
        AND   pgm_id        = :ls_pgmid
        AND   dw_id         = :ls_dwid;
		IF	SQLCA.SQLCode ()=0	Then
			ll_blob = mo_.hex2blob(SQLCA.is_hexfile, lb_syntax, ls_blob_err)
			IF	ll_blob<0	Then
				messageBox ('blob err', ls_blob_err)
			End IF
		Else
			messageBox ('blob err', ls_blob_err)
		End IF

      ls_createsyntax = string(lb_syntax, EncodingANSI!)

      IF fw_f_nvls(ls_createsyntax, '')='' THEN RETURN

      STRING	ls_syntax[]
      STRING	ls_libobjsyntax

      LONG	ll_syncnt

      gnv_extfunc.biznode1te(104, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
      ll_syncnt = fw_f_obj2array(ls_createsyntax, "~r~n" + gnv_extfunc.is_nodevalue + "~r~n", ls_syntax[])

      lds_libobj = CREATE fw_n_dso
      lds_libobj.dataobject = ls_dataobject
      ls_libobjsyntax	= lds_libobj.Describe("DataWindow.Syntax")
      ls_designdwobj		= of_setdesignobj(ls_syntax[1])
      ll_chkcnt = 0
      IF fw_f_nvls(ls_syntax[3], '')<>gnv_vari.setcache4backcolorsyn THEN ll_chkcnt = 1
      IF fw_f_nvls(ls_syntax[5], '')<>ls_designdwobj                 THEN ll_chkcnt = 1
      IF fw_f_nvls(ls_syntax[7], '')<>ls_libobjsyntax                THEN ll_chkcnt = 1

      IF ll_chkcnt=1 Then
         STRING	ls_datetime
         ls_datetime = fw_f_getymdhh24miss4s()
         gnv_extfunc.biznode1te(105, gnv_vari.is_nodekey, gnv_extfunc.is_nodevalue)
         ids_checkdesignobj.SetItem(ll_i, gnv_extfunc.is_nodevalue, '2')
         ids_checkdesignobj.SetItem(ll_i, 'upd_id', gnv_vari.is_user_id)
         ids_checkdesignobj.SetItem(ll_i, 'upd_dt', ls_datetime)
      End IF
Next

IF ids_checkdesignobj.update ()=1 Then
   commitJ ()
//   This.of_getalldbcache() /* gnv_rolemenu.ids_stylesyntax retrieve */
Else
   rollbackJ ()
End IF
end subroutine

public subroutine of_setdesignobjsyn ();gnv_vari.setcachelibdir				= gnv_vari.basepath + '\fw_u_dwo.pbl'		/* DesignCache 관련 variable  gnv_vari.basepath + '\pf_datawindow.pbl' */
gnv_vari.setcache4gridsyn			= LibraryExport(gnv_vari.setcachelibdir, 'fw_n_style_grid', ExportUserObject!)
gnv_vari.setcache4tabularsyn		= LibraryExport(gnv_vari.setcachelibdir, 'fw_n_style_tabu', ExportUserObject!)
gnv_vari.setcache4freesyn			= LibraryExport(gnv_vari.setcachelibdir, 'fw_n_style_free', ExportUserObject!)
gnv_vari.setcache4condsyn			= LibraryExport(gnv_vari.setcachelibdir, 'fw_n_style_cond', ExportUserObject!)
gnv_vari.setcache4backcolorsyn	= LibraryExport(gnv_vari.basepath + '\fw_n_more1.pbl', 'fw_f_cache4backcolor', ExportFunction!)
end subroutine

public function string of_getdesignsyntaxcs ();return '1'
end function

public function string of_setdesignobj (string as_designstyle);Choose Case as_designstyle
	Case 'grid'
		Return gnv_vari.setcache4gridsyn
	Case 'tabular'
		Return gnv_vari.setcache4tabularsyn
	Case 'freeform'
		Return gnv_vari.setcache4freesyn
	Case 'cond'
		Return gnv_vari.setcache4condsyn
	Case Else
		Return 'empty'
End Choose
end function

on fw_n_dwcache.create
call super::create
end on

on fw_n_dwcache.destroy
call super::destroy
end on

