forward
global type w_wfrm04m from w_response1st
end type
type ddplb_1 from pf_u_dropdownpicturelistbox within w_wfrm04m
end type
end forward

global type w_wfrm04m from w_response1st
integer width = 2089
integer height = 1756
string title = "오브젝트명 찾기"
ddplb_1 ddplb_1
end type
global w_wfrm04m w_wfrm04m

type variables
STRING   is_obj_no, is_obj_nm, is_obj_id, is_obj_type
end variables

on w_wfrm04m.create
int iCurrent
call super::create
this.ddplb_1=create ddplb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddplb_1
end on

on w_wfrm04m.destroy
call super::destroy
destroy(this.ddplb_1)
end on

event open;STRING		ls_sqlsyntax
LONG			lR, ll
aDS_jTier	lds_jtier

IF gaa.admin OR gaa.aams	Then
  ls_sqlsyntax = "      SELECT  obj_no " &
             	+ "            , obj_nm " &
             	+ "            , obj_id " &
            	+ "            , obj_type " &
            	+ "      FROM    wfrm04m t1 " &
            	+ "      ORDER BY  obj_no "
	lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
Else
   ls_sqlsyntax = "      SELECT  t1.obj_no       /* _1: */ " &
                + "            , t1.obj_nm       /* _2: */ " &
                + "            , t1.obj_id       /* _3: */ " &
                + "            , t1.obj_type     /* _4: */ " &
                + "      FROM    wfrm08t t0 " &
                + "            , wfrm04m t1 " &
                + "      WHERE   t0.corp_gr  = SUBSTR('" + gaa.corp_gr + "',1,4) " &
                + "        AND   t0.user_id  = '" + gnv_vari.is_user_id  + "' " &
                + "        AND   t1.obj_id   = t0.roleobj_id " &
                + "        AND   t1.right_yn = 'Y' " &
                + "      UNION ALL " &
                + "      SELECT  t1.obj_no       /* _1: */ " &
                + "            , t1.obj_nm       /* _2: */ " &
                + "            , t1.obj_id       /* _3: */ " &
                + "            , t1.obj_type     /* _4: */ " &
                + "      FROM    wfrm04m t1 " &
                + "      WHERE   t1.right_yn = 'N' " &
                + "      ORDER BY  1 "
	lR = SQLCA.sql2ds (this.classname(), ls_sqlsyntax, lds_jtier, 'xml')
End IF

FOR  ll = 1  TO  lR
   is_obj_no   = lds_jtier.getitemstring (ll, 1)
   is_obj_nm   = lds_jtier.getitemstring (ll, 2)
   is_obj_id   = lds_jtier.getitemstring (ll, 3)
   is_obj_type = lds_jtier.getitemstring (ll, 4)
	ddplb_1.AddItem (f_nvl (is_obj_no,'....') + ' ' + is_obj_nm + '|' + is_obj_id, dec (is_obj_type))
NEXT

ddplb_1.POST SetFocus ()
end event

event key;CHOOSE CASE key
   CASE KeyEnter!
      IF POSA (ddplb_1.TEXT,'|')>0 THEN ddplb_1.POST EVENT doubleclicked ()
   CASE KeyEscape!
      CLOSE (THIS)
END CHOOSE
end event

type ln_tempbutton from w_response1st`ln_tempbutton within w_wfrm04m
end type

type ln_tempstart from w_response1st`ln_tempstart within w_wfrm04m
end type

type ln_templeft from w_response1st`ln_templeft within w_wfrm04m
end type

type ln_cond_start from w_response1st`ln_cond_start within w_wfrm04m
end type

type ln_tempright from w_response1st`ln_tempright within w_wfrm04m
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within w_wfrm04m
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within w_wfrm04m
end type

type ddplb_1 from pf_u_dropdownpicturelistbox within w_wfrm04m
integer x = 50
integer y = 24
integer width = 1979
integer height = 1608
integer taborder = 20
fontcharset fontcharset = hangeul!
long textcolor = 33554432
boolean allowedit = true
boolean sorted = false
boolean showlist = true
boolean vscrollbar = true
borderstyle borderstyle = stylebox!
string picturename[] = {"Application5!","..\img\controls\u_favicon\favicon_04.ico","Project!","DosEdit5!","Window!","Custom074!","Function!","Graph!","Print!"}
end type

event modified;IF POSA (TEXT,'|')>0 THEN RETURN
LONG			lR, ll
aDS_jTier	lds_jtier
STRING   	ls, ls_sqlsyntax

DO WHILE  DeleteItem (1)>-1
LOOP

ls = '%' + lower (TEXT) + '%'

IF gaa.admin OR gaa.aams	Then
   ls_sqlsyntax = "      SELECT  obj_no " &
                + "            , obj_nm " &
                + "            , obj_id " &
                + "            , obj_type " &
                + "      FROM    wfrm04m t1 " &
                + "      WHERE   (lower(replace(t1.obj_nm,' ','')) like '" + ls + "' OR t1.obj_id like '" + ls + "' OR t1.obj_no like '" + ls + "') " &
                + "      ORDER BY  obj_no "
Else
   ls_sqlsyntax = "      SELECT  t1.obj_no       /* _1: */ " &
                + "            , t1.obj_nm       /* _2: */ " &
                + "            , t1.obj_id       /* _3: */ " &
                + "            , t1.obj_type     /* _4: */ " &
                + "      FROM    wfrm08t t0 " &
                + "            , wfrm04m t1 " &
                + "      WHERE   t0.corp_gr  = SUBSTR('" + gaa.corp_gr + "',1,4) " &
                + "        AND   t0.user_id  = '" + gnv_vari.is_user_id + "' " &
                + "        AND   t1.obj_id   = t0.roleobj_id " &
                + "        AND   t1.right_yn = 'Y' " &
                + "        AND   (lower(replace(t1.obj_nm,' ','')) like '" + ls + "' OR t1.obj_id like '" + ls + "' OR t1.obj_no like '" + ls + "') " &
                + "      UNION ALL " &
                + "      SELECT  t1.obj_no       /* _1: */ " &
                + "            , t1.obj_nm       /* _2: */ " &
                + "            , t1.obj_id       /* _3: */ " &
                + "            , t1.obj_type     /* _4: */ " &
                + "      FROM    wfrm04m t1 " &
                + "      WHERE   t1.right_yn = 'N' " &
                + "        AND   (lower(replace(t1.obj_nm,' ','')) like '" + ls + "' OR t1.obj_id like '" + ls + "' OR t1.obj_no like '" + ls + "') " &
                + "      ORDER BY  obj_no "
End IF


lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')
FOR  ll = 1  TO  lR
   is_obj_no   = lds_jtier.getitemstring (ll, 1)
   is_obj_nm   = lds_jtier.getitemstring (ll, 2)
   is_obj_id   = lds_jtier.getitemstring (ll, 3)
   is_obj_type = lds_jtier.getitemstring (ll, 4)
   ddplb_1.AddItem (f_nvl (is_obj_no,'....') + ' ' + is_obj_nm + '|' + is_obj_id, dec (is_obj_type))
NEXT

SelectText (1, LenA (TEXT))
end event

event doubleclicked;STRING ls_ID, ls_NM, ls_TY, ls_NO

Window   w_open

ls_ID = MidA (TEXT, PosA (TEXT, '|') + 1)

SELECT  obj_id
      , obj_nm
      , obj_type
      , obj_no
  INTO  :ls_ID
      , :ls_NM
      , :ls_TY
      , :ls_NO
FROM    wfrm04m t1
WHERE   obj_id = :ls_ID;

ls_ID	= SQLCA.getitemString (1)
ls_NM	= SQLCA.getitemString (2)
ls_TY	= SQLCA.getitemString (3)
ls_NO	= SQLCA.getitemString (4)

TreeViewItem   tvi_Role

STRING   la_role []

INT   li_role = 1, li

LONG  ll_tvi

SELECT  role_id
  INTO  :la_role[li_role]
FROM    wfrm07t t1
WHERE   obj_id = :ls_ID;

la_role[li_role] = SQLCA.getitemstring (1)

DO WHILE li_role > 0
   SELECT  role_id
     INTO  :la_role[li_role + 1]
   FROM    wfrm06t t1
   WHERE   subrole_id = :la_role[li_role];
	
	la_role[li_role + 1] = SQLCA.getitemstring (1)
	
   IF SQLCA.SQLCode()<>0 THEN EXIT
   li_role ++
LOOP

//ll_tvi = w_main.uo_treemenu.tv_menu.FINDItem (RootTreeItem!, 0)
//FOR  li = li_role - 1  TO  1  STEP -1
//   DO WHILE  ll_tvi > 0
//      w_main.uo_treemenu.tv_menu.GetItem (ll_tvi, tvi_Role)
//      IF tvi_Role.Data=la_role [li]   Then
//         IF NOT tvi_Role.Expanded   Then
//            tvi_Role.PictureIndex = 2
//            tvi_Role.SelectedPictureIndex = 2
//            w_main.uo_treemenu.tv_menu.SetItem (ll_tvi, tvi_Role)
//            w_main.uo_treemenu.tv_menu.ExpandItem (ll_tvi)
//         End IF
//         EXIT
//      End IF
//      ll_tvi = w_main.uo_treemenu.tv_menu.FINDItem (NextTreeItem!, ll_tvi)
//   LOOP
//   ll_tvi = w_main.uo_treemenu.tv_menu.FINDItem (ChildTreeItem!, ll_tvi)
//NEXT
//IF ll_tvi>0   Then
//   DO WHILE  ll_tvi > 0
//      w_main.uo_treemenu.tv_menu.GetItem (ll_tvi, tvi_Role)
//      IF tvi_Role.Data=ls_ID   Then
//         tvi_Role.Bold = TRUE
//         w_main.uo_treemenu.tv_menu.SetItem (ll_tvi, tvi_Role)
//         w_main.uo_treemenu.tv_menu.SelectItem (ll_tvi)
//         EXIT
//      End IF
//      ll_tvi = w_main.uo_treemenu.tv_menu.FINDItem (NextTreeItem!, ll_tvi)
//   LOOP
//End IF

//CHOOSE CASE lower (LeftA (ls_ID,1))
//   CASE 'u'
//      w_main.POST EVENT ue_Open_Tabpage (ls_ID, ls_NM + '(' + f_nvl (ls_NO,'....') + ')',    w_main.uo_treemenu.tv_menu.picturename [long (ls_TY)] )
//   CASE 'w'
//      OPEN (w_Open, string (ls_ID))
//END CHOOSE

CLOSE (PARENT)
end event

