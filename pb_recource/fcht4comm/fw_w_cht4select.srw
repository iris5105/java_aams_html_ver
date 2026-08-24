forward
global type fw_w_cht4select from w_response1st
end type
type rb_y31 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_p14 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_p12 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_p13 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_a01 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_y32 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type p_ok from pf_u_imagebutton within fw_w_cht4select
end type
type p_cancel from pf_u_imagebutton within fw_w_cht4select
end type
type rb_y33 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_a05 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_g01 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_g02 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type rb_g03 from fw_u_cht4radiobutton within fw_w_cht4select
end type
type dw_cht from fw_u_dwo within fw_w_cht4select
end type
type gb_gen2 from groupbox within fw_w_cht4select
end type
type gb_1 from groupbox within fw_w_cht4select
end type
type gb_2 from groupbox within fw_w_cht4select
end type
type gb_bubble from groupbox within fw_w_cht4select
end type
type p_2 from picture within fw_w_cht4select
end type
type p_1 from picture within fw_w_cht4select
end type
end forward

global type fw_w_cht4select from w_response1st
integer width = 4503
integer height = 3684
boolean center = true
rb_y31 rb_y31
rb_p14 rb_p14
rb_p12 rb_p12
rb_p13 rb_p13
rb_a01 rb_a01
rb_y32 rb_y32
p_ok p_ok
p_cancel p_cancel
rb_y33 rb_y33
rb_a05 rb_a05
rb_g01 rb_g01
rb_g02 rb_g02
rb_g03 rb_g03
dw_cht dw_cht
gb_gen2 gb_gen2
gb_1 gb_1
gb_2 gb_2
gb_bubble gb_bubble
p_2 p_2
p_1 p_1
end type
global fw_w_cht4select fw_w_cht4select

type variables
fw_s_cht4property 	istr_cht4property, istr_cht4property_null

end variables

forward prototypes
public subroutine of_setinitvalue ()
public subroutine of_setinitvalue (string as_rbname)
public function string of_getrtnvalue ()
public subroutine of_setproperty (fw_s_cht4property astr_cht4property)
public function integer of_setpropertyupdate ()
end prototypes

public subroutine of_setinitvalue ();string	ls_ctlnm
long	ll_ctlcnt, i
fw_u_cht4radiobutton	lrb_btn

ll_ctlcnt = UpperBound(this.Control)
For i = 1 To ll_ctlcnt
	Choose case this.Control[i].TypeOf()
		case radiobutton!
			lrb_btn = this.Control[i]
			lrb_btn.of_setinit(this)			
			ls_ctlnm = MidA(lrb_btn.classname(), 4)
			if ls_ctlnm = istr_cht4property.ischtkind then
				lrb_btn.Checked = True
			Else
				lrb_btn.Checked = False
			end if
	end Choose
Next
end subroutine

public subroutine of_setinitvalue (string as_rbname);string	ls_ctlname, ls_chtkind
long	ll_ctlcnt, i
fw_u_cht4radiobutton	lrb_btn

ll_ctlcnt = UpperBound(this.Control)
For i = 1 To ll_ctlcnt
	Choose case this.Control[i].TypeOf()
		case radiobutton!
			lrb_btn = this.Control[i]
			if as_rbname = string(lrb_btn.classname()) then
				continue
			end if
			lrb_btn.Checked = false
	end Choose
Next

ls_chtkind = of_getrtnvalue()
dw_cht.setitem(1, 'chtkind', ls_chtkind)
end subroutine

public function string of_getrtnvalue ();string	ls_ctlname
long	ll_ctlcnt, i
fw_u_cht4radiobutton	lrb_btn
ll_ctlcnt = UpperBound(this.Control)
For i = 1 To ll_ctlcnt
	Choose case this.Control[i].TypeOf()
		case radiobutton!
			lrb_btn = this.Control[i]
			if lrb_btn.Checked = True then				
				ls_ctlname = string(this.Control[i].classname())
				ls_ctlname = MidA(ls_ctlname, PosA(ls_ctlname, '_') + 1)
				Return ls_ctlname
			end if
	end Choose
Next

Return ''
end function

public subroutine of_setproperty (fw_s_cht4property astr_cht4property);long	ll_ret

dw_cht.settransobject( sqlca )
ll_ret = dw_cht.retrieve(gnv_vari.is_sys_id, istr_cht4property.pgm_no, istr_cht4property.pgm_id, istr_cht4property.cht_id)
if ll_ret < 1 then
	istr_cht4property = fw_f_cht4defaultvariable(istr_cht4property, dw_cht)
end if
post of_setinitvalue()
end subroutine

public function integer of_setpropertyupdate ();istr_cht4property.cht_id = dw_cht.getitemstring(1, 'cht_id')
istr_cht4property.ischtkind = dw_cht.getitemstring(1, 'chtkind')

if dw_cht.getitemstring(1, 'ibxaxis') = 'Y' then
	istr_cht4property.ibxaxis = true
else
	istr_cht4property.ibxaxis = false
end if
if dw_cht.getitemstring(1, 'ibcommoncolor') = 'Y' then
	istr_cht4property.ibcommoncolor = true
else
	istr_cht4property.ibcommoncolor = false
end if
if dw_cht.getitemstring(1, 'ibchar4datasetgb') = 'Y' then
	istr_cht4property.ibchar4datasetgb = true
else
	istr_cht4property.ibchar4datasetgb = false
end if
if dw_cht.getitemstring(1, 'ibdefaultdata100') = 'Y' then
	istr_cht4property.ibdefaultdata100 = true
else
	istr_cht4property.ibdefaultdata100 = false
end if

if dw_cht.getitemstring(1, 'ibpns2dls2display') = 'Y' then
	istr_cht4property.ibpns2dls2display = true
else
	istr_cht4property.ibpns2dls2display = false
end if
istr_cht4property.ispns2dls2bordercolor = dw_cht.getitemstring(1, 'ispns2dls2bordercolor')
istr_cht4property.ispns2dls2backgroundcolor = dw_cht.getitemstring(1, 'ispns2dls2backgroundcolor')
istr_cht4property.ispns2dls2color = dw_cht.getitemstring(1, 'ispns2dls2color')
istr_cht4property.ispns2dls2colorh = dw_cht.getitemstring(1, 'ispns2dls2colorh')
istr_cht4property.ispns2dls2formatterlabelgb = dw_cht.getitemstring(1, 'ispns2dls2formatterlabelgb')
istr_cht4property.ispns2dls2formatterlabelvalgb = dw_cht.getitemstring(1, 'ispns2dls2formatterlabelvalgb')

istr_cht4property.isdefaultfontstyle = dw_cht.getitemstring(1, 'isdefaultfontstyle')
istr_cht4property.ildefaultfontsize = dw_cht.getitemnumber(1, 'ildefaultfontsize')
istr_cht4property.isdefaultfontfamily = dw_cht.getitemstring(1, 'isdefaultfontfamily')
istr_cht4property.isdefaultfontcolor = dw_cht.getitemstring(1, 'isdefaultfontcolor')

if dw_cht.getitemstring(1, 'iblegenddisplay') = 'Y' then
	istr_cht4property.iblegenddisplay = true
else
	istr_cht4property.iblegenddisplay = false
end if
istr_cht4property.islegendposition = dw_cht.getitemstring(1, 'islegendposition')
if dw_cht.getitemstring(1, 'ibthousandcomma') = 'Y' then
	istr_cht4property.ibthousandcomma = true
else
	istr_cht4property.ibthousandcomma = false
end if

if dw_cht.getitemstring(1, 'ibtooltipsgb') = 'Y' then
	istr_cht4property.ibtooltipsgb = true
else
	istr_cht4property.ibtooltipsgb = false
end if
if dw_cht.getitemstring(1, 'ibtooltipsrangegb') = 'Y' then
	istr_cht4property.ibtooltipsrangegb = true
else
	istr_cht4property.ibtooltipsrangegb = false
end if

istr_cht4property.ilborderwidth = dw_cht.getitemnumber(1, 'ilborderwidth')
if dw_cht.getitemstring(1, 'iblinefillgb') = 'Y' then
	istr_cht4property.iblinefillgb = true
else
	istr_cht4property.iblinefillgb = false
end if

if dw_cht.getitemstring(1, 'ibhoverborder') = 'Y' then
	istr_cht4property.ibhoverborder = true
else
	istr_cht4property.ibhoverborder = false
end if
istr_cht4property.ishoverbordercolor = dw_cht.getitemstring(1, 'ishoverbordercolor')
istr_cht4property.ilhoverborderwidth = dw_cht.getitemnumber(1, 'ilhoverborderwidth')

istr_cht4property.iswaringstep = dw_cht.getitemstring(1, 'iswaringstep')

istr_cht4property.iimultiplication = dw_cht.getitemnumber(1, 'iimultiplication')
istr_cht4property.iidivision = dw_cht.getitemnumber(1, 'iidivision')
istr_cht4property.iiround = dw_cht.getitemnumber(1, 'iiround')

if dw_cht.getitemstring(1, 'iblinebargb') = 'Y' then
	istr_cht4property.iblinebargb = true
else
	istr_cht4property.iblinebargb = false
end if
istr_cht4property.illinebarcnt = dw_cht.getitemnumber(1, 'illinebarcnt')
istr_cht4property.illiney1axiscnt = dw_cht.getitemnumber(1, 'illiney1axiscnt')

if dw_cht.getitemstring(1, 'ibxaxes0display') = 'Y' then
	istr_cht4property.ibxaxes0display = true
else
	istr_cht4property.ibxaxes0display = false
end if
if dw_cht.getitemstring(1, 'ibyaxes0display') = 'Y' then
	istr_cht4property.ibyaxes0display = true
else
	istr_cht4property.ibyaxes0display = false
end if
if dw_cht.getitemstring(1, 'ibyaxes1display') = 'Y' then
	istr_cht4property.ibyaxes1display = true
else
	istr_cht4property.ibyaxes1display = false
end if

if dw_cht.getitemstring(1, 'ibxaxes0gridlinedisplay') = 'Y' then
	istr_cht4property.ibxaxes0gridlinedisplay = true
else
	istr_cht4property.ibxaxes0gridlinedisplay = false
end if
if dw_cht.getitemstring(1, 'ibyaxes0gridlinedisplay') = 'Y' then
	istr_cht4property.ibyaxes0gridlinedisplay = true
else
	istr_cht4property.ibyaxes0gridlinedisplay = false
end if
if dw_cht.getitemstring(1, 'ibyaxes1gridlinedisplay') = 'Y' then
	istr_cht4property.ibyaxes1gridlinedisplay = true
else
	istr_cht4property.ibyaxes1gridlinedisplay = false
end if

if dw_cht.getitemstring(1, 'ibxaxes0gridlinecolor') = 'Y' then
	istr_cht4property.ibxaxes0gridlinecolor = true
else
	istr_cht4property.ibxaxes0gridlinecolor = false
end if
if dw_cht.getitemstring(1, 'ibyaxes0gridlinecolor') = 'Y' then
	istr_cht4property.ibyaxes0gridlinecolor = true
else
	istr_cht4property.ibyaxes0gridlinecolor = false
end if
if dw_cht.getitemstring(1, 'ibyaxes1gridlinecolor') = 'Y' then
	istr_cht4property.ibyaxes1gridlinecolor = true
else
	istr_cht4property.ibyaxes1gridlinecolor = false
end if

if dw_cht.getitemstring(1, 'iblinetension') = 'Y' then
	istr_cht4property.iblinetension = true
else
	istr_cht4property.iblinetension = false
end if
if dw_cht.getitemstring(1, 'iblinepoint') = 'Y' then
	istr_cht4property.iblinepoint = true
else
	istr_cht4property.iblinepoint = false
end if
istr_cht4property.illinepointradius		= dw_cht.getitemnumber(1, 'illinepointradius')
istr_cht4property.illinepointhoverradius	= dw_cht.getitemnumber(1, 'illinepointhoverradius')

istr_cht4property.isxaxeslabelstring		= dw_cht.getitemstring(1, 'isxaxeslabelstring')
istr_cht4property.isyaxeslabelstring1		= dw_cht.getitemstring(1, 'isyaxeslabelstring1')
istr_cht4property.isyaxeslabelstring2		= dw_cht.getitemstring(1, 'isyaxeslabelstring2')
istr_cht4property.isyaxeslabelstring1b	= dw_cht.getitemstring(1, 'isyaxeslabelstring1b')
istr_cht4property.isyaxeslabelstring2b	= dw_cht.getitemstring(1, 'isyaxeslabelstring2b')

if dw_cht.getitemstring(1, 'ibminmax2fixcolor') = 'Y' then
	istr_cht4property.ibminmax2fixcolor = true
else
	istr_cht4property.ibminmax2fixcolor = false
end if

if dw_cht.getitemstring(1, 'ibbeginatzeroleft') = 'Y' then
	istr_cht4property.ibbeginatzeroleft = true
else
	istr_cht4property.ibbeginatzeroleft = false
end if
if dw_cht.getitemstring(1, 'ibbeginatzeroright') = 'Y' then
	istr_cht4property.ibbeginatzeroright = true
else
	istr_cht4property.ibbeginatzeroright = false
end if

if dw_cht.getitemstring(1, 'iblinestacked') = 'Y' then
	istr_cht4property.iblinestacked = true
else
	istr_cht4property.iblinestacked = false
end if
if dw_cht.getitemstring(1, 'iblinelogarithmic') = 'Y' then
	istr_cht4property.iblinelogarithmic = true
else
	istr_cht4property.iblinelogarithmic = false
end if
if dw_cht.getitemstring(1, 'iblinestepped') = 'Y' then
	istr_cht4property.iblinestepped = true
else
	istr_cht4property.iblinestepped = false
end if

if dw_cht.getitemstring(1, 'ibnulldatagb') = 'Y' then
	istr_cht4property.ibnulldatagb = true
else
	istr_cht4property.ibnulldatagb = false
end if
if dw_cht.getitemstring(1, 'ibbtnvisible4cht') = 'Y' then
	istr_cht4property.ibbtnvisible4cht = true
else
	istr_cht4property.ibbtnvisible4cht = false
end if

if dw_cht.getitemstring(1, 'iblinealtercolor2all') = 'Y' then
	istr_cht4property.iblinealtercolor2all = true
else
	istr_cht4property.iblinealtercolor2all = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk2all') = 'Y' then
	istr_cht4property.iblinealterfillbk2all = true
else
	istr_cht4property.iblinealterfillbk2all = false
end if
istr_cht4property.islinealterbkcolor2all = dw_cht.getitemstring(1, 'islinealterbkcolor2all')
istr_cht4property.islinealterbdcolor2all = dw_cht.getitemstring(1, 'islinealterbdcolor2all')

if dw_cht.getitemstring(1, 'iblinealter1st') = 'Y' then
	istr_cht4property.iblinealter1st = true
else
	istr_cht4property.iblinealter1st = false
end if
istr_cht4property.illinealter1st_row = dw_cht.getitemnumber(1, 'illinealter1st_row')
if dw_cht.getitemstring(1, 'iblinealterfill1st') = 'Y' then
	istr_cht4property.iblinealterfill1st = true
else
	istr_cht4property.iblinealterfill1st = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk1st') = 'Y' then
	istr_cht4property.iblinealterfillbk1st = true
else
	istr_cht4property.iblinealterfillbk1st = false
end if
istr_cht4property.islinealterbkcolor1st = dw_cht.getitemstring(1, 'islinealterbkcolor1st')
istr_cht4property.islinealterbdcolor1st = dw_cht.getitemstring(1, 'islinealterbdcolor1st')

if dw_cht.getitemstring(1, 'iblinealter2nd') = 'Y' then
	istr_cht4property.iblinealter2nd = true
else
	istr_cht4property.iblinealter2nd = false
end if
istr_cht4property.illinealter2nd_row = dw_cht.getitemnumber(1, 'illinealter2nd_row')
if dw_cht.getitemstring(1, 'iblinealterfill2nd') = 'Y' then
	istr_cht4property.iblinealterfill2nd = true
else
	istr_cht4property.iblinealterfill2nd = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk2nd') = 'Y' then
	istr_cht4property.iblinealterfillbk2nd = true
else
	istr_cht4property.iblinealterfillbk2nd = false
end if
istr_cht4property.islinealterbkcolor2nd = dw_cht.getitemstring(1, 'islinealterbkcolor2nd')
istr_cht4property.islinealterbdcolor2nd = dw_cht.getitemstring(1, 'islinealterbdcolor2nd')

if dw_cht.getitemstring(1, 'iblinealter3rd') = 'Y' then
	istr_cht4property.iblinealter3rd = true
else
	istr_cht4property.iblinealter3rd = false
end if
istr_cht4property.illinealter3rd_row = dw_cht.getitemnumber(1, 'illinealter3rd_row')
if dw_cht.getitemstring(1, 'iblinealterfill3rd') = 'Y' then
	istr_cht4property.iblinealterfill3rd = true
else
	istr_cht4property.iblinealterfill3rd = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk3rd') = 'Y' then
	istr_cht4property.iblinealterfillbk3rd = true
else
	istr_cht4property.iblinealterfillbk3rd = false
end if
istr_cht4property.islinealterbkcolor3rd = dw_cht.getitemstring(1, 'islinealterbkcolor3rd')
istr_cht4property.islinealterbdcolor3rd = dw_cht.getitemstring(1, 'islinealterbdcolor3rd')

if dw_cht.getitemstring(1, 'iblinealter4th') = 'Y' then
	istr_cht4property.iblinealter4th = true
else
	istr_cht4property.iblinealter4th = false
end if
istr_cht4property.illinealter4th_row = dw_cht.getitemnumber(1, 'illinealter4th_row')
if dw_cht.getitemstring(1, 'iblinealterfill4th') = 'Y' then
	istr_cht4property.iblinealterfill4th = true
else
	istr_cht4property.iblinealterfill4th = false
end if
if dw_cht.getitemstring(1, 'iblinealterfillbk4th') = 'Y' then
	istr_cht4property.iblinealterfillbk4th = true
else
	istr_cht4property.iblinealterfillbk4th = false
end if
istr_cht4property.islinealterbkcolor4th = dw_cht.getitemstring(1, 'islinealterbkcolor4th')
istr_cht4property.islinealterbdcolor4th = dw_cht.getitemstring(1, 'islinealterbdcolor4th')

istr_cht4property.ilpiecutoutpercentage = dw_cht.getitemnumber(1, 'ilpiecutoutpercentage')

if dw_cht.getitemstring(1, 'ibyaxes4l_q') = 'Y' then
	istr_cht4property.ibyaxes4l_q = true
else
	istr_cht4property.ibyaxes4l_q = false
end if
if dw_cht.getitemstring(1, 'ibyaxes4l') = 'Y' then
	istr_cht4property.ibyaxes4l = true
else
	istr_cht4property.ibyaxes4l = false
end if
istr_cht4property.min4left = dw_cht.getitemnumber(1, 'min4left')
istr_cht4property.max4left = dw_cht.getitemnumber(1, 'max4left')
istr_cht4property.ticksstepsize4l = dw_cht.getitemnumber(1, 'ticksstepsize4l')
if dw_cht.getitemstring(1, 'ibyaxes4r_q') = 'Y' then
	istr_cht4property.ibyaxes4r_q = true
else
	istr_cht4property.ibyaxes4r_q = false
end if
if dw_cht.getitemstring(1, 'ibyaxes4r') = 'Y' then
	istr_cht4property.ibyaxes4r = true
else
	istr_cht4property.ibyaxes4r = false
end if
istr_cht4property.min4right = dw_cht.getitemnumber(1, 'min4right')
istr_cht4property.max4right = dw_cht.getitemnumber(1, 'max4right')
istr_cht4property.ticksstepsize4r = dw_cht.getitemnumber(1, 'ticksstepsize4r')

return 1
end function

on fw_w_cht4select.create
int iCurrent
call super::create
this.rb_y31=create rb_y31
this.rb_p14=create rb_p14
this.rb_p12=create rb_p12
this.rb_p13=create rb_p13
this.rb_a01=create rb_a01
this.rb_y32=create rb_y32
this.p_ok=create p_ok
this.p_cancel=create p_cancel
this.rb_y33=create rb_y33
this.rb_a05=create rb_a05
this.rb_g01=create rb_g01
this.rb_g02=create rb_g02
this.rb_g03=create rb_g03
this.dw_cht=create dw_cht
this.gb_gen2=create gb_gen2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_bubble=create gb_bubble
this.p_2=create p_2
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_y31
this.Control[iCurrent+2]=this.rb_p14
this.Control[iCurrent+3]=this.rb_p12
this.Control[iCurrent+4]=this.rb_p13
this.Control[iCurrent+5]=this.rb_a01
this.Control[iCurrent+6]=this.rb_y32
this.Control[iCurrent+7]=this.p_ok
this.Control[iCurrent+8]=this.p_cancel
this.Control[iCurrent+9]=this.rb_y33
this.Control[iCurrent+10]=this.rb_a05
this.Control[iCurrent+11]=this.rb_g01
this.Control[iCurrent+12]=this.rb_g02
this.Control[iCurrent+13]=this.rb_g03
this.Control[iCurrent+14]=this.dw_cht
this.Control[iCurrent+15]=this.gb_gen2
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_bubble
this.Control[iCurrent+19]=this.p_2
this.Control[iCurrent+20]=this.p_1
end on

on fw_w_cht4select.destroy
call super::destroy
destroy(this.rb_y31)
destroy(this.rb_p14)
destroy(this.rb_p12)
destroy(this.rb_p13)
destroy(this.rb_a01)
destroy(this.rb_y32)
destroy(this.p_ok)
destroy(this.p_cancel)
destroy(this.rb_y33)
destroy(this.rb_a05)
destroy(this.rb_g01)
destroy(this.rb_g02)
destroy(this.rb_g03)
destroy(this.dw_cht)
destroy(this.gb_gen2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_bubble)
destroy(this.p_2)
destroy(this.p_1)
end on

event open;call super::open;istr_cht4property = Message.powerobjectparm

if fw_f_nvls(istr_cht4property.ischtkind, '') = '' then
	messagebox('알림', '올바르지 않은 윈도우 호출입니다')
	post close(this)
	return
end if

post of_setproperty(istr_cht4property)
end event

type ln_tempbutton from w_response1st`ln_tempbutton within fw_w_cht4select
end type

type ln_tempstart from w_response1st`ln_tempstart within fw_w_cht4select
end type

type ln_templeft from w_response1st`ln_templeft within fw_w_cht4select
end type

type ln_cond_start from w_response1st`ln_cond_start within fw_w_cht4select
end type

type ln_tempright from w_response1st`ln_tempright within fw_w_cht4select
end type

type ln_cond1_yline from w_response1st`ln_cond1_yline within fw_w_cht4select
integer beginx = -14
integer beginy = 268
integer endx = 4859
integer endy = 268
end type

type ln_dw1_yline from w_response1st`ln_dw1_yline within fw_w_cht4select
integer beginx = -14
integer beginy = 300
integer endx = 4859
integer endy = 300
end type

type rb_y31 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 1120
integer y = 292
integer width = 754
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "bubble (Y only)"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_p14 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 2053
integer y = 488
integer width = 375
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "radar"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_p12 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 2053
integer y = 292
integer width = 375
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "pie"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_p13 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 2053
integer y = 388
integer width = 375
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "polar"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_a01 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 187
integer y = 288
integer width = 754
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "barline(Multi Axis)"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_y32 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 1120
integer y = 396
integer width = 754
integer height = 92
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "scatter (Y only)"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type p_ok from pf_u_imagebutton within fw_w_cht4select
integer x = 3968
integer y = 28
integer width = 229
integer height = 96
integer taborder = 10
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_ok.jpg"
end type

event clicked;if dw_cht.modifiedcount() > 0 then
	if dw_cht.update() = 1 then		
		commitJ ()
		istr_cht4property.ischtkind = of_getrtnvalue()
		
		if fw_f_nvls(istr_cht4property.ischtkind, '') <> '' then
			of_setpropertyupdate()
			closewithreturn(parent, istr_cht4property)
		else
			closewithreturn(parent, istr_cht4property_null)
		end if
	else
		messagebox('check', '구성저장이 실패되었습니다.')
		rollbackJ ()
	end if
else
	closewithreturn(parent, istr_cht4property_null)
end if



end event

type p_cancel from pf_u_imagebutton within fw_w_cht4select
integer x = 4206
integer y = 28
integer width = 229
integer height = 96
integer taborder = 20
boolean bringtotop = true
string picturename = "..\img\controls\u_imagebutton\btn_cancel.jpg"
end type

event clicked;CloseWithReturn(Parent, istr_cht4property_null)
end event

type rb_y33 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 1120
integer y = 496
integer width = 754
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "bubble-timetable(Y)"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_a05 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 187
integer y = 388
integer width = 759
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "horizontal bar"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_g01 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 2656
integer y = 296
integer width = 558
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "gauge1"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_g02 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 2656
integer y = 404
integer width = 558
integer height = 92
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "gauge2"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type rb_g03 from fw_u_cht4radiobutton within fw_w_cht4select
integer x = 2656
integer y = 504
integer width = 558
boolean bringtotop = true
integer textsize = -11
fontcharset fontcharset = hangeul!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 32768
long backcolor = 33225466
string text = "powergauge1"
end type

event fwu_postclicked;call super::fwu_postclicked;if this.Checked = True then Parent.of_setinitvalue(as_classname)
end event

type dw_cht from fw_u_dwo within fw_w_cht4select
integer x = 101
integer y = 808
integer width = 4288
integer height = 2668
integer taborder = 70
boolean bringtotop = true
string dataobject = "fw_d_cht4select_1"
boolean applydesign = true
boolean useborder = true
boolean setbringtotop = true
boolean setedittoken = true
end type

event updatestart;call super::updatestart;String	ls_cntr_sn
Long	ll_rcnt, ll_row
Long	ll_mstrow

dwitemstatus	 ldwstatus
do while ll_row <= ll_rcnt
	ll_row = this.getnextmodified(ll_row, Primary!)
	if ll_row > 0 then
		ldwstatus = this.getitemstatus(ll_row, 0, Primary!)		
		choose case ldwstatus
			case NewModified!
				this.setitem(ll_row, 'use_yn', 'Y')				
				this.setitem(ll_row, 'reg_id', gnv_vari.is_user_id)
				this.setitem(ll_row, 'reg_dt', fw_f_getymdhh24miss4s())
				this.setitem(ll_row, 'upd_id', gnv_vari.is_user_id)
				this.setitem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
			case DataModified!
				this.setitem(ll_row, 'upd_id', gnv_vari.is_user_id)
				this.setitem(ll_row, 'upd_dt', fw_f_getymdhh24miss4s())
		end CHoose
	Else
		ll_row = ll_rcnt + 1        
	end if
loop

end event

event losefocus;call super::losefocus;this.accepttext()
end event

type gb_gen2 from groupbox within fw_w_cht4select
integer x = 110
integer y = 180
integer width = 896
integer height = 448
integer taborder = 30
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217730
long backcolor = 33225466
string text = "barline (A)"
end type

type gb_1 from groupbox within fw_w_cht4select
integer x = 2574
integer y = 176
integer width = 667
integer height = 460
integer taborder = 60
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217730
long backcolor = 33225466
string text = "gauge (G)"
end type

type gb_2 from groupbox within fw_w_cht4select
integer x = 1975
integer y = 180
integer width = 562
integer height = 452
integer taborder = 50
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217730
long backcolor = 33225466
string text = "pie (P)"
end type

type gb_bubble from groupbox within fw_w_cht4select
integer x = 1042
integer y = 180
integer width = 896
integer height = 452
integer taborder = 40
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "맑은 고딕"
long textcolor = 134217730
long backcolor = 33225466
string text = "bubble (Y)"
end type

type p_2 from picture within fw_w_cht4select
integer x = 37
integer y = 148
integer width = 4443
integer height = 568
boolean originalsize = true
string picturename = "..\img\chart\u_cht_bg1.jpg"
boolean focusrectangle = false
end type

type p_1 from picture within fw_w_cht4select
integer x = 37
integer y = 740
integer width = 4443
integer height = 2864
string picturename = "..\img\chart\u_cht_bg2.jpg"
boolean focusrectangle = false
end type

