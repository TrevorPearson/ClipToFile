#Include <File.au3>
#include <ClipBoard.au3>
#include <GDIPlus.au3>

#include <Array.au3>

$lastHex = ""
monitorClip()


Func monitorClip()
   $past = ""
   $current = ""
   while 1
	  $current = ClipGet()
	  if StringCompare($current,$past)<>0 Then
;~ 		clipChangedEvent($current)
	 Else
		_saveClipImage()
	  EndIf
	  $past = $current
	  sleep(500)
   WEnd
EndFunc



; this will save the image if there is an image in the clipboard
Func _saveClipImage($Path = "C:\temp\clipboard.jpg")
   local $iFormat
;~ 	MsgBox(0,"path",$Path)


	_ClipBoard_Open(0)

	Local $aFormats[3] = [2, $CF_OEMTEXT,$CF_BITMAP]
	;ConsoleWrite("Priority formats .:. " & _ClipBoard_GetPriorityFormat($aFormats) & @CRLF)
	if (_ClipBoard_GetPriorityFormat($aFormats)<>2) Then
	   _ClipBoard_Close()
	   Return
	EndIf

	$hBitmap = _ClipBoard_GetDataEx( $CF_BITMAP)
   $thisHex = Hex($hBitmap)

	if ($thisHex==$lastHex) Then
	   _ClipBoard_Close()
	   Return
    EndIf
   $lastHex = $thisHex
   ;ConsoleWrite("saved again " & $thisHex &@CRLF)
   _GDIPlus_Startup()
    $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
   _GDIPlus_ImageSaveToFile($hImage, $Path)

	_GDIPlus_ImageDispose($hImage)

	_ClipBoard_Close()
	_GDIPlus_Shutdown()
	Return 1
 EndFunc

