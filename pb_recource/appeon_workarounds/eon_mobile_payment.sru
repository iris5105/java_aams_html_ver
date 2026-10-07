forward
global type eon_mobile_payment from nonvisualobject
end type
end forward

global type eon_mobile_payment from nonvisualobject
event oe_error ( )
event oe_paymentcancel ( )
event oe_paymentfailed ( )
event oe_paymentok ( )
end type
global eon_mobile_payment eon_mobile_payment

forward prototypes
public function integer of_init (eon_mobile_str_paymentinit astr_paymentinit)
public function integer of_submit (eon_mobile_str_paymentsubmit astr_paymentsubmit)
end prototypes

event oe_error();//==============================================================================
// 
// Copyright ? 2001-2013 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_payment::oe_error
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
end event

event oe_paymentcancel();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_payment::oe_paymentcancel
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
end event

event oe_paymentfailed();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_payment::oe_paymentfailed
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
//===============================================================================
end event

event oe_paymentok();//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Event: eon_mobile_payment::oe_paymentok
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
end event

public function integer of_init (eon_mobile_str_paymentinit astr_paymentinit);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_payment::of_init
//------------------------------------------------------------------------------
// Description: 
// initializes the client record.
// Supported on mobile client only.		
// 
// Arguments:
//		value eon_mobile_str_paymentinit     astr_paymentinit
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
return -1
end function

public function integer of_submit (eon_mobile_str_paymentsubmit astr_paymentsubmit);//==============================================================================
// 
// Copyright ? 2001-2014 Appeon, Inc. and its subsidiaries. All rights reserved.
// 
//------------------------------------------------------------------------------
// Function: eon_mobile_payment::of_submit
//------------------------------------------------------------------------------
// Description: 
// submits the payment record.
// Supported on mobile client only.		
// 
// Arguments:
//		values    eon_mobile_str_paymentsubmit    astr_paymentsubmit
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
return -1
end function

on eon_mobile_payment.create
call super::create
TriggerEvent( this, "constructor" )
end on

on eon_mobile_payment.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

