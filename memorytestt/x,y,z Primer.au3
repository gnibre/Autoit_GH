#include "nomadmemorybxyz.au3"
SetPrivilege("SeDebugPrivilege", 1)
global $sModule = "Diablo III.exe"
global $ProcessID = WinGetProcess("Diablo III")
MsgBox(0,"$ProcessID", $ProcessID)
SetPrivilege("SeDebugPrivilege", 1)
global $DllInformation = _MemoryOpen($ProcessID)
;MsgBox(0,"DLL",$DllInformation)


;#RequireAdmin

global $baseADDR = _MemoryModuleGetBaseAddress($ProcessID, $sModule)
;MsgBox(0,"$baseADDR",$baseADDR)
$Base =$baseADDR+0x00E40D94
MsgBox(0,"Base",hex($Base))

Global $offX[6] = [0, 0x10, 0x4, 0x4, 0x50, 0x38]
Global $offY[6] = [0, 0x10, 0x4, 0x4, 0x50, 0x34]
Global $offZ[6] = [0, 0x10, 0x4, 0x4, 0x50, 0x3c]
Global $Coords[3] = ["X", "Y", "Z"]
;MsgBox(0,"Coords Before", "X = "&$Coords[0]&@CR&"Y = "&$Coords[1]&@CR&"Z = "&$Coords[2])

$test = _MemoryPointerRead($Base, $DllInformation,  $offX, "float")
$Coords[0] = $test[1]

ToolTip("try to get test"&$test)
Sleep(3000)

ToolTip("try to get test"&$test[0])
Sleep(3000)

ToolTip("try to get test"&$test[1])
Sleep(3000)


$test = _MemoryPointerRead($Base, $DllInformation,  $offY, "float")
$Coords[1] = $test[1]
$test = _MemoryPointerRead($Base, $DllInformation,  $offZ, "float")
$Coords[2] = $test[1]
MsgBox(0,"$test - Coords",  "X = "&$Coords[0]&@CR&"Y = "&$Coords[1]&@CR&"Z = "&$Coords[2])