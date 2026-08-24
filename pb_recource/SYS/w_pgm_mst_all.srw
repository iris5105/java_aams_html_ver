forward
global type w_pgm_mst_all from wt_list
end type
end forward

global type w_pgm_mst_all from wt_list
boolean eb_direct_retrieve = true
end type
global w_pgm_mst_all w_pgm_mst_all

event wue_retrieve;call super::wue_retrieve;dw_list.retrieve (gnv_vari.is_sys_id)
end event

on w_pgm_mst_all.create
int iCurrent
call super::create
end on

on w_pgm_mst_all.destroy
call super::destroy
end on

type lb_dirlist from wt_list`lb_dirlist within w_pgm_mst_all
end type

type ln_templeft from wt_list`ln_templeft within w_pgm_mst_all
end type

type ln_tempbuttom from wt_list`ln_tempbuttom within w_pgm_mst_all
end type

type ln_temptop from wt_list`ln_temptop within w_pgm_mst_all
end type

type ln_tempbutton from wt_list`ln_tempbutton within w_pgm_mst_all
end type

type ln_tempstart from wt_list`ln_tempstart within w_pgm_mst_all
end type

type ln_cond1_yline from wt_list`ln_cond1_yline within w_pgm_mst_all
end type

type ln_dw1_yline from wt_list`ln_dw1_yline within w_pgm_mst_all
end type

type ln_cond2_yline from wt_list`ln_cond2_yline within w_pgm_mst_all
end type

type ln_dw2_yline from wt_list`ln_dw2_yline within w_pgm_mst_all
end type

type ln_tempright from wt_list`ln_tempright within w_pgm_mst_all
end type

type uo_navi from wt_list`uo_navi within w_pgm_mst_all
end type

type ln_temptop_shadow from wt_list`ln_temptop_shadow within w_pgm_mst_all
end type

type st_windelaytime from wt_list`st_windelaytime within w_pgm_mst_all
end type

type p_close from wt_list`p_close within w_pgm_mst_all
end type

type p_excel from wt_list`p_excel within w_pgm_mst_all
end type

type p_print from wt_list`p_print within w_pgm_mst_all
end type

type p_delete from wt_list`p_delete within w_pgm_mst_all
end type

type p_update from wt_list`p_update within w_pgm_mst_all
end type

type p_input from wt_list`p_input within w_pgm_mst_all
end type

type p_retrieve from wt_list`p_retrieve within w_pgm_mst_all
end type

type p_clear from wt_list`p_clear within w_pgm_mst_all
end type

type p_copy from wt_list`p_copy within w_pgm_mst_all
end type

type dw_c from wt_list`dw_c within w_pgm_mst_all
boolean visible = false
boolean enabled = false
end type

type btn_update from wt_list`btn_update within w_pgm_mst_all
end type

type st_count from wt_list`st_count within w_pgm_mst_all
end type

type dw_list from wt_list`dw_list within w_pgm_mst_all
integer y = 156
integer height = 2608
string dataobject = "d_pgm_mst_all"
end type

event dw_list::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
   CASE 'parent_pgm'
      Object.sort_order [row] = 99
   CASE 'io_type'
      Choose CASE data
         CASE '01'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_search_hover.jpg')
         CASE '02'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_add_hover.jpg')
         CASE '03'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_exec_hover.jpg')
         CASE '04'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_setting_hover.jpg')
         CASE '05'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_print_rd_hover.jpg')
         CASE '10'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_ftp_hover.jpg')
         CASE '11'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_chart_hover.jpg')
         CASE '12'
            this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_excel_hover.jpg')
			Case '13'
				this.SetItem(row, 'pgm_icon', '..\img\mainframe\mdi4subicon\ico_fundnet_hover.jpg')
      End Choose
end choose
end event

event dw_list::ue_dddw_retrieve;call super::ue_dddw_retrieve;f_dddwctl (THIS, 'parent_pgm', '', '', 1, '')
end event

event dw_list::doubleclicked;call super::doubleclicked;CHOOSE CASE dwo.name
	CASE 'pgm_go','pgm_id'
		gnv_rolemenu.of_setopensheet (Object.pgm_no [row])
END CHOOSE
end event

