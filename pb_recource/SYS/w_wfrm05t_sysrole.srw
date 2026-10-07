forward
global type w_wfrm05t_sysrole from w_window1st1ncn
end type
type lv_object from pf_u_listview within w_wfrm05t_sysrole
end type
type lv_role from pf_u_listview within w_wfrm05t_sysrole
end type
type tv_system from treeview within w_wfrm05t_sysrole
end type
end forward

global type w_wfrm05t_sysrole from w_window1st1ncn
integer width = 3049
integer height = 2104
long backcolor = 67108864
event resize pbm_size
event ue_wpage_open ( )
event type boolean ue_wpage_modified ( )
event type integer wue_confirmupdate4close ( )
lv_object lv_object
lv_role lv_role
tv_system tv_system
end type
global w_wfrm05t_sysrole w_wfrm05t_sysrole

type variables
ads_jTier ids_SubRole
ads_jTier ids_Object

LONG	il_Item, il_System

BOOLEAN	ib_Sort = TRUE
end variables

event resize;tv_System.Height = Height

//st_VBar.X = tv_System.Width
//st_VBar.y = 0
//st_VBar.Height = Height

//lv_Role.X = st_VBar.X + st_VBar.Width
lv_Role.Width = Width - lv_Role.X

//st_HBar.X = tv_System.Width
//st_HBar.Y = lv_Role.Y + lv_Role.Height
//st_HBar.Width = lv_Role.Width

lv_Object.X = lv_Role.X
//lv_Object.Y = st_HBar.Y + st_HBar.Height
lv_Object.Width = lv_Role.Width
lv_Object.Height = Height - lv_Object.Y
end event

event ue_wpage_open();// SubRole정보
ids_SubRole = CREATE ads_jTier
ids_SubRole.DataObject = 'd_wfrm06t_subrole'
ids_SubRole.SetTransObject (SQLCA)

// 오브젝트 정보
ids_Object = CREATE ads_jTier
ids_Object.DataObject = 'd_wfrm07t_roleobject'
ids_Object.SetTransObject (SQLCA)

SetRedraw (FALSE)

STRING	ls_role, ls_nm

TreeViewItem tvi_System

SELECT  t1.role_id
      , t2.role_nm
  INTO  :ls_role
      , :ls_nm
FROM    wfrm05t t1
      , wfrm03m t2
WHERE   t1.corp_gr = :gaa.corp_gr
  AND   t2.role_id = t1.role_id;

ls_role = SQLCA.getitemstring (1)
ls_nm = SQLCA.getitemstring (2)

//System
tvi_System.PictureIndex = 1
tvi_System.SelectedPictureIndex = 1
tvi_System.Children = TRUE
tvi_System.Data  = ls_role
tvi_System.Label = ls_nm

tv_System.InsertItemLast (0, tvi_System)
tv_System.ExpandItem (1)

POST SetRedraw (TRUE)
end event

event type boolean ue_wpage_modified();RETURN FALSE
end event

event type integer wue_confirmupdate4close();RETURN 0
end event

on w_wfrm05t_sysrole.create
int iCurrent
call super::create
this.lv_object=create lv_object
this.lv_role=create lv_role
this.tv_system=create tv_system
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lv_object
this.Control[iCurrent+2]=this.lv_role
this.Control[iCurrent+3]=this.tv_system
end on

on w_wfrm05t_sysrole.destroy
call super::destroy
destroy(this.lv_object)
destroy(this.lv_role)
destroy(this.tv_system)
end on

event open;call super::open;PostEvent ('ue_wpage_Open')
end event

type lb_dirlist from w_window1st1ncn`lb_dirlist within w_wfrm05t_sysrole
end type

type ln_templeft from w_window1st1ncn`ln_templeft within w_wfrm05t_sysrole
end type

type ln_tempbuttom from w_window1st1ncn`ln_tempbuttom within w_wfrm05t_sysrole
end type

type ln_temptop from w_window1st1ncn`ln_temptop within w_wfrm05t_sysrole
end type

type ln_tempbutton from w_window1st1ncn`ln_tempbutton within w_wfrm05t_sysrole
end type

type ln_tempstart from w_window1st1ncn`ln_tempstart within w_wfrm05t_sysrole
end type

type ln_cond1_yline from w_window1st1ncn`ln_cond1_yline within w_wfrm05t_sysrole
end type

type ln_dw1_yline from w_window1st1ncn`ln_dw1_yline within w_wfrm05t_sysrole
end type

type ln_cond2_yline from w_window1st1ncn`ln_cond2_yline within w_wfrm05t_sysrole
end type

type ln_dw2_yline from w_window1st1ncn`ln_dw2_yline within w_wfrm05t_sysrole
end type

type ln_tempright from w_window1st1ncn`ln_tempright within w_wfrm05t_sysrole
end type

type uo_navi from w_window1st1ncn`uo_navi within w_wfrm05t_sysrole
end type

type ln_temptop_shadow from w_window1st1ncn`ln_temptop_shadow within w_wfrm05t_sysrole
end type

type st_windelaytime from w_window1st1ncn`st_windelaytime within w_wfrm05t_sysrole
end type

type st_top_rect from w_window1st1ncn`st_top_rect within w_wfrm05t_sysrole
end type

type p_close from w_window1st1ncn`p_close within w_wfrm05t_sysrole
end type

type p_excel from w_window1st1ncn`p_excel within w_wfrm05t_sysrole
end type

type p_print from w_window1st1ncn`p_print within w_wfrm05t_sysrole
end type

type p_delete from w_window1st1ncn`p_delete within w_wfrm05t_sysrole
end type

type p_update from w_window1st1ncn`p_update within w_wfrm05t_sysrole
end type

type p_input from w_window1st1ncn`p_input within w_wfrm05t_sysrole
end type

type p_retrieve from w_window1st1ncn`p_retrieve within w_wfrm05t_sysrole
end type

type p_clear from w_window1st1ncn`p_clear within w_wfrm05t_sysrole
end type

type p_copy from w_window1st1ncn`p_copy within w_wfrm05t_sysrole
end type

type lv_object from pf_u_listview within w_wfrm05t_sysrole
integer x = 2002
integer y = 1184
integer width = 873
integer height = 792
integer taborder = 20
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string facename = "굴림"
long textcolor = 33554432
long backcolor = 16777215
boolean deleteitems = true
boolean hideselection = false
boolean gridlines = true
boolean fullrowselect = true
listviewview view = listviewreport!
string largepicturename[] = {"UserObject5!"}
integer largepicturewidth = 32
integer largepictureheight = 32
long largepicturemaskcolor = 553648127
string smallpicturename[] = {"UserObject5!"}
integer smallpicturewidth = 16
integer smallpictureheight = 16
long smallpicturemaskcolor = 553648127
long statepicturemaskcolor = 553648127
end type

event begindrag;il_Item= index
end event

event columnclick;IF ib_Sort  Then
   Sort(Ascending! , column) ; ib_Sort = FALSE
Else
   Sort(Descending! , column) ; ib_Sort = TRUE
End IF
end event

event doubleclicked;il_Item= index
tv_system.EVENT dragdrop (THIS, il_System)
end event

event dragdrop;lv_ROLE.EVENT dragdrop (source, index)
end event

event constructor;InsertColumn (1, "오브젝트 ID", Left!, 600 )
InsertColumn (2, "오브젝트 명", Left!, 1200 )
InsertColumn (3, "오브젝트 설명", Left!, 1220 )
InsertColumn (4, "화면No", Center!, 260 )
InsertColumn (5, "ROLE", Left!, 800 )

INT   li_Row, li_RowCount

STRING	ls_obj, ls_role, ls_role_all

STRING		ls_sqlsyntax
LONG			lR, ll
aDS_jTier	lds_jtier

ListViewItem   lvi_Object

ls_sqlsyntax = "   SELECT  role_id " &
             + "   FROM    wfrm07t t1 " &
             + "   WHERE   obj_id = '" + ls_obj + "' "

// Object ListPictureView Setting
ads_jTier ds_Object

ds_Object = CREATE ads_jTier
ds_Object.DataObject = 'd_wfrm04m_manage'
ds_Object.SetTransObject (SQLCA)
li_RowCount = ds_Object.retrieve ()

lvi_Object.PictureIndex = 1
FOR  li_Row = 1  TO  li_RowCount
   ls_obj = ds_Object.object.obj_id [li_Row]
	lR = SQLCA.sql2ds (parent.classname(), ls_sqlsyntax, lds_jtier, 'xml')
	ls_role_all = ''
	
	FOR  ll = 1  TO  lR
   	ls_role = lds_jtier.getitemstring (ll, 1)
      IF ls_role_all='' Then
         ls_role_all = ls_role
      Else
         ls_role_all = ls_role_all + '/' + ls_role
      End IF
	NEXT
	
   lvi_Object.Label = ls_obj + '~t' + ds_Object.object.obj_nm [li_Row] + '~t' + f_nvl (ds_Object.object.obj_cmnt [li_Row],'') + '~t' + f_nvl (ds_Object.object.obj_no [li_Row],'') + '~t' + ls_role_all
   lvi_Object.data = ls_obj
   AddItem (lvi_Object)
NEXT
end event

event rightclicked;INT   li_Row, li_RowCount

ListViewItem   lvi_Object

STRING	ls_obj

INT   li_Count

// Object ListPictureView Setting
ads_jTier ds_Object

ds_Object = CREATE ads_jTier
ds_Object.DataObject = 'd_wfrm04m_manage'
ds_Object.SetTransObject (SQLCA)
li_RowCount = ds_Object.retrieve ()

lvi_Object.PictureIndex = 1
DeleteItems ()
FOR  li_Row = 1  TO  li_RowCount
   ls_obj = ds_Object.object.obj_id [li_Row]

   SELECT  Count( *)
     INTO  :li_Count
   FROM    wfrm07t t1
   WHERE   obj_id = :ls_obj;
	
	li_Count = SQLCA.getitemnumber (1)
	
   IF li_Count=0  Then
      lvi_Object.Label = ds_Object.object.obj_id [li_Row] + '~t' + ds_Object.object.obj_nm [li_Row] + '~t' + f_nvl (ds_Object.object.obj_cmnt [li_Row],'') + '~t' + f_nvl (ds_Object.object.obj_no [li_Row],'')
      lvi_Object.data = ds_Object.object.obj_id [li_Row]
      AddItem (lvi_Object)
   End IF
NEXT
end event

type lv_role from pf_u_listview within w_wfrm05t_sysrole
integer x = 2007
integer y = 156
integer width = 873
integer height = 1012
integer taborder = 60
boolean dragauto = true
boolean bringtotop = true
fontcharset fontcharset = hangeul!
string facename = "굴림"
long textcolor = 33554432
long backcolor = 16777215
boolean hideselection = false
boolean gridlines = true
boolean fullrowselect = true
listviewview view = listviewreport!
string largepicturename[] = {"UserObject5!"}
integer largepicturewidth = 32
integer largepictureheight = 32
long largepicturemaskcolor = 553648127
string smallpicturename[] = {"Library5!"}
integer smallpicturewidth = 16
integer smallpictureheight = 16
long smallpicturemaskcolor = 553648127
long statepicturemaskcolor = 553648127
end type

event begindrag;IF NOT gaa.aams   Then
	f_messageBox ('INFO','ROLE은 등록을 의뢰 하십시오.')
	RETURN 1
End IF
il_Item= index
end event

event columnclick;IF ib_Sort  Then
      Sort(Ascending! , column) ; ib_Sort = FALSE
Else
      Sort(Descending! , column) ; ib_Sort = TRUE
End IF
end event

event dragdrop;LONG  ll_Parent

STRING   ls_System, ls_Role, ls_SubRole, ls_Object

TreeViewItem   tvi_Delete, tvi_Parent

IF lower (Source.ClassName ())<>'tv_system' THEN RETURN

IF tv_System.GetItem (il_System, tvi_Delete)<0  Then
   MessageBox ('삭제 오류', '선택된 삭제항목의 정보가 부정확합니다.', Information!)
   RETURN
End IF

ll_Parent = tv_System.FindItem (ParentTreeItem!, il_System)
IF ll_Parent<0 Then
   MessageBox ('삭제 확인', '시스템 정보는 삭제할수 없습니다.', Information!)
   RETURN
End IF

IF tv_System.GetItem (ll_Parent, tvi_Parent)>0  Then
   // Object
   IF tvi_Delete.PictureIndex>2  Then
      ls_role   = tvi_Parent.Data
      ls_Object = tvi_Delete.Data

      DELETE  wfrm07t
      WHERE   role_id = :ls_role
        AND   obj_id  = :ls_Object;
   Else
      // Role & SubRole
      ls_role    = tvi_Parent.Data
      ls_subrole = tvi_Delete.Data

      DELETE  wfrm06t
      WHERE   role_id    = :ls_role
        AND   subrole_id = :ls_subrole;
   End IF
   IF SQLCA.SQLCode()>-1  Then
      commitJ ()
   Else
      MessageBox ("DELETE ERROR : " + string (SQLCA.SQLDBCode), SQLCA.SQLErrText())
      rollbackJ ()
      RETURN
   End IF
   il_System = ll_Parent
   Parent.SetRedraw (FALSE)
   tv_System.ExpandItem (ll_Parent)
   tv_System.EVENT ItemExpanding (ll_Parent)
   Parent.SetRedraw (TRUE)
End IF
end event

event doubleclicked;il_Item= index
tv_system.EVENT dragdrop (THIS, il_System)
end event

event constructor;InsertColumn (1, "ROLE ID", Left!, 650 )
InsertColumn (2, "ROLE 명", Left!, 650 )
InsertColumn (3, "설 명"  , Left!, 950 )

INT li_Row, li_RowCount

ListViewItem    lvi_Role

// ROLE ListPictureView Setting
ads_jTier ds_Role

ds_Role = CREATE ads_jTier
ds_Role.DataObject = 'd_wfrm03m_manage'
ds_Role.SetTransObject (SQLCA)

li_RowCount = ds_Role.retrieve ()
lvi_ROLE.PictureIndex = 1
FOR  li_Row = 1  TO  li_RowCount
      lvi_ROLE.Label = ds_Role.object.role_id [li_Row] + '~t' + ds_Role.object.role_nm [li_Row] + '~t' + f_nvl(ds_Role.object.role_cmnt [li_Row],'')
      lvi_ROLE.data = ds_Role.object.role_id [li_Row]
      AddItem (lvi_ROLE)
NEXT
end event

type tv_system from treeview within w_wfrm05t_sysrole
integer x = 50
integer y = 156
integer width = 1938
integer height = 1816
integer taborder = 10
boolean dragauto = true
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean disabledragdrop = false
boolean hideselection = false
boolean tooltips = false
boolean trackselect = true
string picturename[] = {"Application5!","Library5!","Project!","DosEdit5!","Window!","Custom074!","Function!","Graph!","Print!"}
long picturemaskcolor = 553648127
long statepicturemaskcolor = 536870912
end type

event begindrag;il_System = handle
end event

event dragdrop;treeviewitem   tvi_This, tvi_Target, tvi_Parent, tvi_Sort, tvi_Next

STRING	ls_Role, ls_subRole, ls_Object, ls_Parent, ls_Next

INT   li_Count, li_Sort=0

listviewitem   lvi_Role, lvi_Object

LONG	ll_Next, ll_Parent

// ERROR Checking
IF GetItem (Handle, tvi_This)<0 THEN
   MessageBox ('error', 'GetItem() Error')
   RETURN -1
End IF

CHOOSE CASE source.ClassName ()
   CASE 'lv_role' // 사용자별 Role 정보 입력
      IF lv_ROLE.GetItem (il_Item, lvi_Role)<0 THEN
         MessageBox ('error', 'ROLE정보가 정확하지 않습니다.', Information!)
         RETURN
      End IF

      IF tvi_This.PictureIndex>3 THEN
         MessageBox ('오브젝트 확인', '오브젝트는 서브ROLE 이나 오브젝트를 가질수 없습니다.', Information!)
         RETURN -1
      End IF

      ls_role    = tvi_This.Data
      ls_subRole = lvi_Role.Data

      SELECT COUNT(role_id)
        INTO :li_Count
        FROM WFRM06T t1
       WHERE role_id    = :ls_role
         AND subrole_id = :ls_subRole;

      li_count = SQLCA.getitemnumber (1)

      IF li_Count>0 THEN
         MessageBox ("시스템별 ROLE 확인", "시스템에 이미 등록된 Role입니다. [" + ls_role + ']', Information!)
         RETURN
      ELSE
         INSERT  INTO WFRM06T
             ( role_id
             , subrole_id
             , sort_id
             )
         VALUES ( :ls_Role
                , :ls_subRole
                , 0
                );
      End IF
      IF SQLCA.SQLCode()>-1 THEN
         commitJ ()
      ELSE
         MessageBox ('INSERT ERROR : ' + STRING (SQLCA.SQLDBCode), SQLCA.SQLERRText(), StopSign!)
         rollbackJ ()
         RETURN
      End IF

   CASE 'lv_object'
      IF lv_Object.GetItem (il_Item, lvi_Object)<0 THEN
         MessageBox ('error', '오브젝트 정보가 정확하지 않습니다.', Information!)
         RETURN
      End IF

      IF tvi_This.PictureIndex<>2 THEN // ROLE이 아니라면
         MessageBox ('등록 확인', '오브젝트는 ROLE에만 등록될수 있습니다.', Information!)
         RETURN
      ELSE // ROLE에 오브젝트 등록
         ls_Role = tvi_This.Data
         ls_Object = lvi_Object.Data

         SELECT COUNT(role_id)
           INTO :li_Count
           FROM WFRM07T t1
          WHERE role_id = :ls_role
            AND obj_id  = :ls_object;

         li_count = SQLCA.getitemnumber (1)

         IF li_Count>0 THEN
            MessageBox ("ROLE별 오브젝트 확인", "선택하신 ROLE에 이미 등록된 오브젝트입니다. [" + ls_Object + ']', Information!)
            RETURN
         ELSE
            INSERT  INTO WFRM07T
                ( role_id
                , obj_id
                , sort_id
                )
            VALUES ( :ls_Role
                   , :ls_Object
                   , 0
                   );
            IF SQLCA.SQLCode()>-1 THEN
               commitJ ()
            ELSE
               MessageBox ('INSERT ERROR : ' + STRING (SQLCA.SQLDBCode), SQLCA.SQLERRText(), StopSign!)
               rollbackJ ()
               RETURN
            End IF
         End IF
      End IF

   CASE ClassName () // Sort & Move Item
      IF GetItem (Handle, tvi_Target)<0 THEN
         MessageBox ('오류 발생', '타겟 아이템 정보가 정확하지 않습니다', Information!)
         RETURN
      ELSE
         ll_Parent = FindItem (ParentTreeItem!, Handle)
         GetItem (ll_Parent, tvi_Parent)
      End IF

      IF GetItem (il_System, tvi_Sort)<0 THEN
         MessageBox ('오류 발생 : ' + STRING (il_System), '정렬 아이템 정보가 정확하지 않습니다', Information!)
         RETURN
      ELSE
         // Parent가 다를경우 ROLE 이동 처리
         IF ll_Parent<>FindItem (ParentTreeItem!, il_System) THEN
            IF tvi_Target.PictureIndex=1 THEN // System
               MessageBox ('System ROLE', '시스템 ROLE에는 이동으로 등록할 수 없습니다.', Information!)
               RETURN -1
            End IF
            IF tvi_Target.PictureIndex>3 THEN
               MessageBox ('오브젝트 이동확인', '오브젝트는 SubRole이나 Object를 가질수 없습니다.', Information!)
               RETURN -1
            End IF

            // 생성처리
            IF tvi_Sort.PictureIndex>3 THEN
               ls_Role = tvi_Target.Data
               ls_Object = tvi_Sort.Data

               SELECT COUNT(role_id)
                 INTO :li_Count
                 FROM WFRM07T t1
                WHERE role_id = :ls_role
                  AND obj_id  = :ls_object;

               li_count = SQLCA.getitemnumber (1)

               IF li_Count>0 THEN
                  MessageBox ("ROLE별 오브젝트 이동확인", "선택하신 ROLE에 이미 등록된 오브젝트입니다. [" + ls_Object + ']', Information!)
                  RETURN
               ELSE
                  INSERT  INTO WFRM07T
                      ( role_id
                      , obj_id
                      , sort_id
                      )
                  VALUES ( :ls_Role
                         , :ls_Object
                         , 0
                         );
                        IF SQLCA.SQLCode()<>0 THEN MessageBox ('wfrm07t INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
               End IF
            ELSE
               ls_role = tvi_Target.Data
               ls_subRole = tvi_Sort.Data

               SELECT COUNT(role_id)
                 INTO :li_Count
                 FROM WFRM06T t1
                WHERE role_id    = :ls_role
                  AND subrole_id = :ls_subRole;

               li_count = SQLCA.getitemnumber (1)

               IF li_Count>0 THEN
                  MessageBox ("시스템별 ROLE 이동확인", "시스템에 이미 등록된 Role입니다. [" + ls_role + ']', Information!)
                  RETURN
               ELSE
                  INSERT  INTO WFRM06T
                      ( role_id
                      , subrole_id
                      , sort_id
                      )
                  VALUES ( :ls_Role
                         , :ls_subRole
                         , 0
                         );
                        IF SQLCA.SQLCode()<>0 THEN MessageBox ('wfrm06t INSERT 실패:' + STRING (SQLCA.SQLDBCode), SQLCA.SQLErrText())
               End IF
            End IF

            // 삭제처리
            ll_Parent = FindItem (ParentTreeItem!, il_System)
            GetItem (ll_Parent, tvi_Parent)
            IF tvi_Sort.PictureIndex>3 THEN
               ls_Role   = tvi_Parent.Data
               ls_Object = tvi_Sort.Data

               DELETE FROM WFRM07T
                WHERE role_id = :ls_Role
                  AND obj_id  = :ls_Object;
            ELSE
               ls_role    = tvi_Parent.Data
               ls_subRole = tvi_Sort.Data

               DELETE FROM WFRM06T
                WHERE role_id    = :ls_role
                  AND subrole_id = :ls_subRole;
            End IF
            commitJ ()

            SetRedraw (FALSE)
            event ItemExpanding (ll_Parent)
            event ItemExpanding (Handle)
            POST SetRedraw (TRUE)
            RETURN
         End IF
      End IF

      ls_Parent = tvi_Parent.Data

      ll_Next = FindItem (ChildTreeItem!, ll_Parent)
      DO WHILE ll_Next>0
         li_Sort ++
         IF GetItem (ll_Next, tvi_Next)<0 THEN
            MessageBox ('아이템 오류', '정렬하기 위한 아이템을 읽는데 실패하였습니다', StopSign!)
            rollbackJ ()
            RETURN
         End IF

         CHOOSE CASE tvi_Parent.PictureIndex
            CASE 1,2 // Role & SubRole or ROLE & Object
               IF tvi_Sort.PictureIndex<3 THEN // SubROLE
                  IF ll_Next=handle THEN // Update_Sort & Target
                     ls_Next = tvi_Sort.Data

                     UPDATE WFRM06T
                        SET sort_id = :li_Sort
                      WHERE role_id    = :ls_Parent
                        AND subrole_id = :ls_Next;

                     li_Sort ++
                  End IF
                  IF ll_Next=il_System THEN
                     // Skip
                  ELSE
                     ls_Next = tvi_Next.Data
                     UPDATE WFRM06T
                        SET sort_id = :li_Sort
                      WHERE role_id    = :ls_Parent
                        AND subrole_id = :ls_next;
                  End IF

               ELSE // ROLE & Object
                  IF ll_Next=handle THEN // Update_Sort & Target
                        ls_Next = tvi_Sort.Data

                        UPDATE WFRM07T
                           SET sort_id = :li_Sort
                         WHERE role_id = :ls_Parent
                           AND obj_id  = :ls_Next;

                        li_Sort ++
                  End IF
                  IF ll_Next=il_System THEN
                     // Skip
                  ELSE
                     ls_Next = tvi_Next.Data
                     UPDATE WFRM07T
                        SET sort_id = :li_Sort
                      WHERE role_id = :ls_Parent
                        AND obj_id  = :ls_Next;
                  End IF
               End IF
            CASE ELSE
               MessageBox ('아이템 확인', '정의되지 않은 아이템입니다., 아이템별 정렬을 할수 없습니다.', Information!)
               rollbackJ ()
               RETURN
         END CHOOSE
         ll_Next = FindItem (NextTreeItem!, ll_Next)
      LOOP
      IF SQLCA.SQLCode()>-1 THEN
         commitJ ()

         event ItemExpanding (ll_Parent)

         ll_Next = FindItem (ChildTreeItem!, ll_Parent)
         DO WHILE (ll_Next > 0)
            GetItem (ll_Next, tvi_Next)
            IF tvi_Sort.Data=tvi_Next.Data THEN
               SetFirstVisible (ll_Next)
               SelectItem (ll_Next)
               EXIT
            End IF
            ll_Next = FindItem (NextTreeItem!, ll_Next)
         LOOP
         RETURN
      ELSE
         MessageBox ('정렬 아이템 저장 오류', SQLCA.SQLErrText())
         rollbackJ ()
         RETURN
      End IF
END CHOOSE

SetRedraw (FALSE)
ExpandItem (Handle)
event ItemExpanding (Handle)
SetRedraw (TRUE)
end event

event itemexpanding;treeviewitem	tvi_THIS, tvi_New

INT	li_RowCount, li_Row

GetItem (handle, tvi_THIS)
IF tvi_THIS.Children Then
   DO WHILE  DeleteItem (FindItem (ChildTreeItem!, handle))>0
   LOOP
End IF

// ROLE Expanding
li_RowCount = ids_SubRole.retrieve (tvi_THIS.Data)
IF li_RowCount>0  Then
   tvi_New.PictureIndex = 2
   tvi_New.SelectedPictureIndex = 2
   tvi_New.Children = TRUE
   FOR  li_Row = 1  TO  li_RowCount
      tvi_New.Data = ids_SubRole.object.subrole_id [li_Row]
      tvi_New.Label = ids_SubRole.object.subrole_nm [li_Row] + '[' + ids_SubRole.object.subrole_id [li_Row] + ']'
      InsertItemLast (Handle, tvi_New)
   NEXT
End IF

// Object Expanding
li_RowCount = ids_Object.retrieve (tvi_THIS.Data) // Obejct
IF li_RowCount>0  Then
   FOR  li_Row = 1  TO  li_RowCount
      tvi_New.PictureIndex = integer (ids_Object.object.obj_type [li_Row])
      tvi_New.SelectedPictureIndex = integer (ids_Object.object.obj_type [li_Row])
      tvi_New.Children = FALSE
      tvi_New.Data = ids_Object.object.obj_id [li_Row]
      tvi_New.Label = f_nvl (ids_Object.object.obj_no [li_Row],'') + ' ' + ids_Object.object.obj_nm [li_Row] + '[' + ids_Object.object.obj_id [li_Row] + ']'
      InsertItemLast (Handle, tvi_New)
   NEXT
End IF
end event

event clicked;il_System = handle
end event

