forward
global type fw_n_animation from nonvisualobject
end type
end forward

global type fw_n_animation from nonvisualobject autoinstantiate
event oue_movingslide ( )
event oue_push4slidedown ( )
event oue_push4slideup ( )
event oue_idle4time ( )
event oue_slide_down ( )
event oue_slide_up ( )
event oue_idle4slidedown ( )
end type

type variables
CONSTANT INTEGER	FADEOUT 			= 0
CONSTANT INTEGER	FADEIN 			= 1
CONSTANT INTEGER	MOVELEFT			= 2
CONSTANT INTEGER	MOVERIGHT 		= 4
CONSTANT INTEGER	MOVEUP			= 6
CONSTANT INTEGER	MOVEDOWN		= 8

Private:
	fw_n_custtiming		in_time, in_idle
	double				idle4time = 1.5
	
	dragobject	idrag_in
	dragobject	idrag_out
	integer		ii_secondframe	= 60
	integer		ii_movemode
	integer		ii_lrterm, ii_udterm
	integer		ii_minpos
	dragobject	idrag_target
	integer		ii_slide_start, ii_slide_end
	dec{2}		idc_slidetime = 0
end variables

forward prototypes
public subroutine uf_ani_moveslide (dragobject adrg_out, dragobject adrg_in, double ad_time, integer ai_movemode, integer ai_minpos)
public subroutine of_refresh (dragobject adrg_target)
public subroutine of_visible (boolean ab_boolean)
public subroutine of_push4slidedown (dragobject adrg_target, integer ai_y_start, integer ai_y_end, double ad_time)
public subroutine of_push4slideup (dragobject adrg_target, integer ai_y_start, integer ai_y_end, double ad_time)
public subroutine of_push4refresh (dragobject adrg_target)
public subroutine of_slide_up (dragobject adrg_target, integer ai_y_start, integer ai_y_end, decimal ad_time)
public subroutine of_idle4time ()
end prototypes

event oue_movingslide();Choose Case ii_movemode
	Case MOVELEFT
		IF IsValid(idrag_out) THEN
			idrag_in.visible = true
			idrag_out.x 	-= ii_lrterm
			idrag_in.x 	= idrag_out.x + idrag_out.width + PixelsToUnits(2, XPixelsToUnits!)
			IF idrag_in.x < ii_minpos THEN
				idrag_in.x = ii_minpos
				idrag_out.visible = false
				in_time.stop()
			END IF
		ELSE
			in_time.stop()
		END IF
	Case MOVERIGHT
		IF IsValid(idrag_out) THEN
			idrag_in.visible = true
			idrag_out.x 	+= ii_lrterm
			idrag_in.x 	= idrag_out.x - idrag_in.width - PixelsToUnits(2, XPixelsToUnits!)
			IF idrag_in.x > ii_minpos THEN
				idrag_in.x = ii_minpos
				idrag_out.visible = false
				in_time.stop()
			END IF
		ELSE
			in_time.stop()
		END IF
	Case MOVEUP
		IF IsValid(idrag_target) THEN
			idrag_target.visible = true
			
			IF idrag_target.y < ( ii_slide_end + ii_udterm) THEN
				in_time.stop()
				idrag_target.y = ii_slide_end
			ELSE
				idrag_target.y -= ii_udterm
			END IF
		ELSE
			in_time.stop()
		END IF		
End Choose
end event

event oue_push4slidedown();if isvalid(idrag_target) then
	integer	li_change

	if idrag_target.y > ( ii_slide_end - ii_udterm) then
		in_time.stop()
		idrag_target.y = ii_slide_end
		li_change	= ii_slide_start
		ii_slide_start	= ii_slide_end
		ii_slide_end	= li_change
	else
		yield ( )
		idrag_target.y += ii_udterm
	end if
else
	in_time.stop()
end if


end event

event oue_push4slideup();IF IsValid(idrag_target) THEN
	integer	li_change
	idrag_target.visible = true
	
	IF idrag_target.y < ii_slide_end THEN
		in_time.stop()
		idrag_target.y = ii_slide_end
		li_change	= ii_slide_start
		ii_slide_start	= ii_slide_end
		ii_slide_end	= li_change
	ELSE
		Yield ( )
		idrag_target.y -= ii_udterm
	END IF
ELSE
	in_time.stop()
END IF
end event

event oue_idle4time();in_idle.stop( )
post event oue_idle4slidedown()
end event

event oue_slide_down();IF IsValid(idrag_target) THEN
	idrag_target.visible = true
	
	IF idrag_target.y > ( ii_slide_end - ii_udterm) THEN
		in_time.stop()
		idrag_target.y = ii_slide_end
		idrag_target.visible = false
	ELSE
		idrag_target.y += ii_udterm
	END IF
ELSE
	in_time.stop()
END IF
end event

event oue_slide_up();IF IsValid(idrag_target) THEN
	integer	li_change
	idrag_target.visible = true
	
	IF idrag_target.y < ii_slide_end THEN
		in_time.stop()
		idrag_target.y = ii_slide_end
		li_change	= ii_slide_start
		ii_slide_start	= ii_slide_end
		ii_slide_end	= li_change
		Yield ( )
		in_idle.event oue_parentevent( this, "oue_idle4time")
		in_idle.start( idle4time )
	ELSE
		Yield ( )
		idrag_target.y -= ii_udterm
	END IF
ELSE
	in_time.stop()
END IF
end event

event oue_idle4slidedown();in_time.event oue_parentevent( this, "oue_slide_down" )
in_time.start( (idc_slidetime * 12) / ii_secondframe )
end event

public subroutine uf_ani_moveslide (dragobject adrg_out, dragobject adrg_in, double ad_time, integer ai_movemode, integer ai_minpos);Decimal	ldc_time

idrag_in	= adrg_in
idrag_out	= adrg_out

ii_movemode 	= ai_movemode
ii_minpos		= ai_minpos

ldc_time	= ad_time / ii_secondframe

ii_lrterm	= adrg_out.width 	/ (ad_time * ii_secondframe)
ii_udterm	= adrg_out.height / (ad_time * ii_secondframe)

in_time.event oue_parentevent( this, "oue_movingslide")
in_time.start( ldc_time )
end subroutine

public subroutine of_refresh (dragobject adrg_target);This.of_slide_up(adrg_target, gw_mdi.Workspaceheight( ), (gw_mdi.Workspaceheight( ) - adrg_target.Height), 0.5)
end subroutine

public subroutine of_visible (boolean ab_boolean);idrag_target.visible = ab_boolean

end subroutine

public subroutine of_push4slidedown (dragobject adrg_target, integer ai_y_start, integer ai_y_end, double ad_time);dec{2}		ldc_time

idrag_target	= adrg_target
ii_slide_start		= ai_y_start
ii_slide_end		= ai_y_end
ii_movemode	= MOVEDOWN

idc_slidetime	= ad_time
ldc_time	= idc_slidetime / ii_secondframe
ii_udterm	= ( ai_y_end - ai_y_start) / (idc_slidetime * ii_secondframe)

idrag_target.y = ai_y_start

in_time.event oue_parentevent( this, "oue_push4slidedown")
in_time.start( ldc_time )
end subroutine

public subroutine of_push4slideup (dragobject adrg_target, integer ai_y_start, integer ai_y_end, double ad_time);dec{2}		ldc_time

idrag_target	= adrg_target
ii_slide_start		= ai_y_start
ii_slide_end		= ai_y_end
ii_movemode	= MOVEUP

idc_slidetime	= ad_time
ldc_time	= idc_slidetime / ii_secondframe
ii_udterm	= ( ai_y_start - ai_y_end) / (idc_slidetime * ii_secondframe)

idrag_target.y = ai_y_start

in_time.event oue_parentevent( this, "oue_push4slideup")
in_time.start( ldc_time )
end subroutine

public subroutine of_push4refresh (dragobject adrg_target);
end subroutine

public subroutine of_slide_up (dragobject adrg_target, integer ai_y_start, integer ai_y_end, decimal ad_time);dec{2}	ldc_time

idrag_target	= adrg_target
ii_slide_start		= ai_y_start
ii_slide_end		= ai_y_end
ii_movemode	= MOVEUP

idc_slidetime	= ad_time
ldc_time	= (idc_slidetime * 12)/ ii_secondframe
ii_udterm	= ( ai_y_start - ai_y_end) / (idc_slidetime * ii_secondframe)

idrag_target.y = ai_y_start

in_time.event oue_parentevent( this, "oue_slide_up")
in_time.start( ldc_time )
end subroutine

public subroutine of_idle4time ();
end subroutine

on fw_n_animation.create
call super::create
TriggerEvent( this, "constructor" )
end on

on fw_n_animation.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;in_time = create fw_n_custtiming
in_idle = create fw_n_custtiming

end event

