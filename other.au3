#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
pressAAAAAAAAA()



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
 
 
 
 func pressAAAAAAAAA()
while 1
$active = WinActive('Diablo III')   
   If Not $active Then	  
   ToolTip(" diablo not active!!!!!!!!!!!!!!!!!!!",0,0)
   WinActivate('Diablo III')
   EndIf
	  
   
   MouseMove(467,248)
send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
send("{SHIFTUP}")
Sleep(100)
Send("{1}")	
Sleep(300)
Send("{2}")	
Sleep(200)
Send("{3}")
Sleep(200)
Send("{4}")	
Sleep(200)

   For $l=1 to 100
	  Send("{4}")	
   Sleep(200)
   Next
	
Sleep(200)	
	  
WEnd
	
EndFunc
 
 