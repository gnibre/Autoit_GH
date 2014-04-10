#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func WriteFileAppend()
	
	Local $file = FileOpen("items-record.txt", 1)  ; 1 :append to end of file.
	If $file = -1 Then
    ;  MsgBox(0, "Error", "Unable to open file.")
    Exit
	  EndIf

	FileWriteLine($file, _Now())
	FileClose($file)
 EndFunc
 
 
 
 

func writeToNamedFileAppend($name,$msg)
   Local $file = FileOpen($name, 1)  ; 1 :append to end of file.
	If $file = -1 Then
    ;  MsgBox(0, "Error", "Unable to open file.")
    Exit
	  EndIf

	FileWriteLine($file,$msg)
	FileClose($file)
 EndFunc
 
 