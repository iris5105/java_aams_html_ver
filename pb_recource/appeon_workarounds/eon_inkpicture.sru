forward
global type eon_inkpicture from inkpicture
end type
end forward

global type eon_inkpicture from inkpicture
integer width = 411
integer height = 432
event appeon_recognition ( )
end type
global eon_inkpicture eon_inkpicture

type variables
long recognitiontimer
//Specifies the time period in milliseconds between the last ink stroke and the start of text recognition.
//By default, ink is converted to text after two seconds (2000 milliseconds). it is used to trigger the appeon_recognition event.
end variables

on eon_inkpicture.create
end on

on eon_inkpicture.destroy
end on

