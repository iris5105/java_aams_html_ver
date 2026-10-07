forward
global type eon_mobile_paymentex from eon_mobile_payment
end type
end forward

global type eon_mobile_paymentex from eon_mobile_payment
end type
global eon_mobile_paymentex eon_mobile_paymentex

type variables
powerobject ipo_bindevent
string is_paymentok,is_paymentcancel,is_paymentfailed,is_bindwitherrorevent
string is_errortext
integer ii_errorcode
integer ii_appplatformtype
end variables

forward prototypes
public subroutine of_triggerevent (string as_event)
public function integer of_register (powerobject apb_bind, string as_paymentok, string as_paymentcancel, string as_paymentfailed, string as_error)
public function integer of_setappplatform (integer ai_appplatform)
public function integer of_submit (eon_mobile_str_paymentsubmit astr_paymentsubmit)
public function integer of_init (eon_mobile_str_paymentinit astr_paymentinit)
public function integer of_getappplatform ()
end prototypes

public subroutine of_triggerevent (string as_event);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_paymentex::of_triggerevent
//------------------------------------------------------------------------------
// Description: 
// Triggers the object events that are bound with oe_error or the other events.
//	Supported on mobile client only.
// 
// Arguments:
//		value    string    as_event
//								 The event name bound with oe_error or the other events.
//	
// Returns:  (none).
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//================================================================================

if isvalid(ipo_bindevent)  and isnull(ipo_bindevent) = false and isnull(as_event) = false and trim(as_event)<> "" then
	ipo_bindevent.dynamic triggerevent(as_event)
end if
end subroutine

public function integer of_register (powerobject apb_bind, string as_paymentok, string as_paymentcancel, string as_paymentfailed, string as_error);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_paymentex::of_register
//------------------------------------------------------------------------------
// Description: 
//	Registers the object and the event to be bound with the oe_paymentok, oe_paymentcancel, oe_paymentfailed, and oe_error events.
//	Supported on mobile client only.
// 
// Arguments:
//		value    powerobject    apb_bind
//					The object to be bound with the oe_paymentok, oe_paymentcancel, oe_paymentfailed, and oe_error events.
//		value    string         as_paymentok
//					The event to be bound with the oe_paymentok event.
//		value    string         as_paymentcancel
//					The event to be bound with the oe_paymentcancel event.
//		value    string         as_paymentfailed
//					The event to be bound with the oe_paymentfailed event.
//		value    string         as_error
//					The event to be bound with the oe_error event.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isvalid(apb_bind)= false or isnull(apb_bind) then	
		li_return =  -1		
else		
		ipo_bindevent = apb_bind
		is_paymentok = as_paymentok
		is_paymentcancel = as_paymentcancel
		is_paymentfailed = as_paymentfailed
		is_bindwitherrorevent = as_error		
		li_return =  1		
end if

return li_return
end function

public function integer of_setappplatform (integer ai_appplatform);//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_paymentex::of_setappplatform
//------------------------------------------------------------------------------
// Description: 
//		Sets the type of the payment platform on which the application will run.
//		Supported on mobile client only.		
// 
// Arguments:
//		value    integer    ai_appplatform	
//					0 - Unknown.
//					1 - Paypal.
//					2 - AppStore.
//					3 - AliPay.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//	
// Returns:  Integer.
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(ai_appplatform) then
	li_return =  -1
else
	if appeongetclienttype() = "MOBILE" then
		if ai_appplatform = 1 then
			ii_appplatformtype = ai_appplatform
			li_return = 1
		else
			li_return = -1
		end if
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_submit (eon_mobile_str_paymentsubmit astr_paymentsubmit);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_paymentex::of_submit
//------------------------------------------------------------------------------
// Description: 
// submits the payment record.
// Supported on mobile client only.		
// 
// Arguments:
//		value    eon_mobile_str_paymentsubmit    astr_paymentsubmit
//
//    	Variable list of the eon_mobile_str_paymentsubmit struct
//					double		dbl_countmoney;
//						Total amount of money.
//					string		s_currency;
//						Currency.
//					string		s_productname;
//						Product name.
//	
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(astr_paymentsubmit) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		if ii_appplatformtype = 1 then
			li_return = super:: of_submit(astr_paymentsubmit)
		else
			li_return = -1
		end if
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_init (eon_mobile_str_paymentinit astr_paymentinit);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_paymentex::of_init
//------------------------------------------------------------------------------
// Description: 
// initializes the client record.
// Supported on mobile client only.		
// 
// Arguments:
//			value    eon_mobile_str_paymentinit     astr_paymentinit
//
//    	Variable list of the eon_mobile_str_paymentinit struct
//					string		s_clientid;
//						Client ID.
// Returns:  integer. 
//					 1 - Success.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if isnull(astr_paymentinit) then
	li_return = -1
else	
	if appeongetclienttype() = "MOBILE" then
		if  ii_appplatformtype =  1 then
			li_return = super:: of_init(astr_paymentinit)
		else
			li_return = -1
		end if
	else
		li_return = -1
	end if
end if

return li_return
end function

public function integer of_getappplatform ();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_paymentex::of_geapptplatform
//------------------------------------------------------------------------------
// Description: 
//		Detects which payment platform the application is currently running on. 
//		Supported on mobile client only.	
// 
// Arguments: None
//	
// Returns:  integer
//					0 - Unknown.
//					1 - Paypal.
//					2 - AppStore.
//					3 - AliPay.
//					-1 - It is called in PowerBuilder or Appeon Web, or there is an error.
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
integer li_return

if appeongetclienttype() = "MOBILE" then
	if  ii_appplatformtype  = 1 then
		li_return = ii_appplatformtype
	else
		li_return = -1
	end if
else
	li_return = -1
end if

return li_return
end function

on eon_mobile_paymentex.create
call super::create
end on

on eon_mobile_paymentex.destroy
call super::destroy
end on

event oe_error;call super::oe_error;//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_paymentex::oe_error
//------------------------------------------------------------------------------
// Description: 
// Occurs when there is any error in this functionality.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================

of_triggerevent(is_bindwitherrorevent)
end event

event oe_paymentcancel;call super::oe_paymentcancel;//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_paymentex::oe_paymentcancel
//------------------------------------------------------------------------------
// Description: 
// Occurs when the payment is cancelled or terminated.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
of_triggerevent(is_paymentcancel)
end event

event oe_paymentfailed;call super::oe_paymentfailed;//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_paymentex::oe_paymentfailed
//------------------------------------------------------------------------------
// Description: 
// Occurs when the payment failed.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
of_triggerevent(is_paymentfailed)
end event

event oe_paymentok;call super::oe_paymentok;//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_paymentex::oe_paymentok
//------------------------------------------------------------------------------
// Description: 
// Occurs when the payment is successful.
// Supported on mobile client only.		
// 
// Arguments: (None)
//	
// Returns:  (None)
//------------------------------------------------------------------------------
// Author:	APPEON		Date: 2014-07
//------------------------------------------------------------------------------
// Revision History: 
//				1.0   Initial version
//==============================================================================
of_triggerevent(is_paymentok)
end event

