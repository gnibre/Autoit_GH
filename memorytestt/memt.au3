#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include<nomadmemory.au3>


; Script Start - Add your code below here
HotKeySet('{F10}', 'Pause')
HotKeySet('{F11}', 'Quit')

global $ClickToMoveCurX
global $ClickToMoveCurY
global $ClickToMoveCurZ

Opt("WinTitleMatchMode", -1)
SetPrivilege("SeDebugPrivilege", 1)
$D3Exefile = "Diablo III.exe"


$list = ProcessList()
for $i = 1 to $list[0][0]
	if $list[$i][0] = $D3Exefile Then
		Global $ProcessID = $list[$i][1]
		ToolTip("got process id "&$ProcessID)
		Sleep(1000)
		
		ExitLoop
	EndIf
next
Local $d3 = _MemoryOpen($ProcessID)
If @Error Then
	MsgBox(4096, "ERROR", "Failed to open memory for process;" & $ProcessID)
    Exit
EndIf

;MsgBox(0,"DLL",$d3)

GetCurrentPos()


Func GetCurrentPos()
	dim $return[3]
	$return[0] = _MemoryRead($ClickToMoveCurX, $d3, 'float')
	$return[1] = _MemoryRead($ClickToMoveCurY, $d3, 'float')
	$return[2] = _MemoryRead($ClickToMoveCurZ, $d3, 'float')
	
	ToolTip("got three position value:  "&$return[0]&"-"&$return[1]&"-"&$return[2])
	Sleep(10000)
	
	
	return $return
EndFunc




Func Pause() ; f10 function.
       $Paused = Not $Paused
       While $Paused
               Sleep(500)
               ToolTip('Paused...', 0, 0)
			    
			;   test();
			   
       WEnd
       ;ToolTip("")
	EndFunc   ;==>Pause
	
Func Quit() ; f11 function
       Exit
	EndFunc   ;==>Quit