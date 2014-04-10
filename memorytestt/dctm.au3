;;================================================================================
;;================================================================================
;;	Diablo 3 Memory UDF - Retriving data and interacting with Diablo 3
;;		Made to better understand diablo 3's actor structure.
;;  	-For personal study purposes only.
;;
;;	Version 2.1
;;
;;  Written By UnknOwned 2012
;;================================================================================
;;================================================================================
  
;;--------------------------------------------------------------------------------
;;	Includes
;;--------------------------------------------------------------------------------
#include <nomadmemory.au3> ;THIS IS EXTERNAL, GET IT AT THE AUTOIT WEBSITE
#Include <math.au3>
#Include <String.au3>
#Include <Array.au3>
;#Include <WinAPI.au3>

;;================================================================================
;; FUNCTIONS
;;================================================================================

;;================================================================================
; Function:			GetDistance($_x,$_y,$_z)
; Description:		Check distance between you and a desired position.
; Parameter(s):		$_x,$_y and $_z - the target position
;								 
; Note(s):			Returns a distance in float
;==================================================================================
func GetDistance($_x,$_y,$_z)
	$CurrentLoc = GetCurrentPos()
	$xd = $_x-$CurrentLoc[0]
	$yd = $_y-$CurrentLoc[1]
	$zd = $_z-$CurrentLoc[2]
	$Distance = Sqrt($xd*$xd + $yd*$yd + $zd*$zd)	
	Return $Distance
EndFunc

;;================================================================================
; Function:			GetCurrentPos($_offset)
; Description:		Returns your current offset in a array
; Parameter(s):		none
;								 
; Note(s):			This will return your current position as a array.
;					[0] = X, [1] = Y, [2] = Z
;==================================================================================
Func GetCurrentPos()
	dim $return[3]
	$return[0] = _MemoryRead($ClickToMoveCurX, $d3, 'float')
	$return[1] = _MemoryRead($ClickToMoveCurY, $d3, 'float')
	$return[2] = _MemoryRead($ClickToMoveCurZ, $d3, 'float')
	return $return
EndFunc

;;================================================================================
; Function:			MoveToPos($_x,$_y,$_z[,$neardist = 2])
; Description:		Move to a desired position.
; Parameter(s):		$_x,$_y and $_z - the target position
;					$neardist - the distance from the target position
;								that the move function will stop
;								 
; Note(s):			You can use $neardist to make the movement more fluid.
;					If the function stop before the desired position
;						is reached it won't stop between each point,
;						this is why the default $neardist is 2
;==================================================================================
func MoveToPos($_x,$_y,$_z,$neardist = 2)
	_MemoryWrite($ClickToMoveToX , $d3,$_x, 'float')
	_MemoryWrite($ClickToMoveToY , $d3,$_y, 'float')
	_MemoryWrite($ClickToMoveToZ , $d3,$_z, 'float')
	_MemoryWrite($ClickToMoveToggle , $d3,1, 'int')
	_MemoryWrite($ClickToMoveFix , $d3,69736, 'int')
	while 1
		$CurrentLoc = GetCurrentPos()
		$xd = $_x-$CurrentLoc[0]
		$yd = $_y-$CurrentLoc[1]
		$zd = $_z-$CurrentLoc[2]
		$Distance = Sqrt($xd*$xd + $yd*$yd + $zd*$zd)	
		if $Distance < $neardist then ExitLoop
		if _MemoryRead($ClickToMoveToggle, $d3, 'float') = 0 then ExitLoop
		sleep(10)
	WEnd
EndFunc						

;;================================================================================
; Function:			PowerUseGUID($_guid,$_snoPower)
; Description:		Use a Power on a GUID
; Parameter(s):		$_guid - GUID you want to use the power on.
;					$_snoPower - the ID of the power you want to use
;								 
; Note(s):			To interact with NPC's use $_snoPower = 7546
;					To Pick up loot use $_snoPower = 7545
;					To cast a townportal use $_snoPower = 02EC66 and your GUID
;==================================================================================
func PowerUseGUID($_guid,$_snoPower)
		$CurrentLocX = _MemoryRead($ClickToMoveCurX, $d3, 'float')
		$CurrentLocY = _MemoryRead($ClickToMoveCurY, $d3, 'float')
		$CurrentLocZ = _MemoryRead($ClickToMoveCurZ, $d3, 'float')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK1 , $d3, 0x777C, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK2 , $d3, 0x1, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK3 , $d3, $_snoPower, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK4 , $d3, $_snoPower, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetMousestate , $d3, 0x1, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetGUID , $d3, $_guid, 'ptr')	
		_MemoryWrite($ClickToMoveToX , $d3,$CurrentLocX+1, 'float')
		_MemoryWrite($ClickToMoveToY , $d3,$CurrentLocY, 'float')
		_MemoryWrite($ClickToMoveToZ , $d3,$CurrentLocZ, 'float')
		_MemoryWrite($ClickToMoveToggle , $d3,1, 'int')
		_MemoryWrite($ClickToMoveFix , $d3,69736, 'int')	
	$tempvalue = _MemoryRead($_itrInteractE+$ofs__InteractOffsetUNK2, $d3, 'int')
	while $tempvalue = 1
		$tempvalue = _MemoryRead($_itrInteractE+$ofs__InteractOffsetUNK2, $d3, 'int')
		sleep(10)
	WEnd
EndFunc

;;================================================================================
; Function:			LinkActors
; Note(s):			This function is used by the OffsetList to 
;						get the current player data.
;==================================================================================
func LocateMyToon()
	$_CurOffset = $_itrObjectManagerD
	$_Count = _MemoryRead($_itrObjectManagerCount, $d3, 'int')
	for $i = 0 to $_Count step +1 
		$_GUID = _MemoryRead($_CurOffset+0x4, $d3, 'ptr')
		$_NAME = _MemoryRead($_CurOffset+0x8, $d3, 'char[64]')
		if $_GUID = 0x77BC0000 Then
			global $_Myoffset = $_CurOffset
			return True
			ExitLoop
		EndIf
		$_CurOffset = $_CurOffset + $_ObjmanagerStrucSize
	Next
	return False
EndFunc	

;;================================================================================
; Function:			IterateLocalActor
; Note(s):			Iterates through all the local actors.
;						Used by IterateActorAtribs
;					This is bad use of variables, should be fixed!
;==================================================================================
func IterateLocalActor()
	$_Count = _MemoryRead($_LocalActor_Count, $d3, 'int')
	$CurrentOffset = $_LocalActor_3
	Global $__ACTOR[$_Count+1][4]
	for $i = 0 to $_Count
		$__ACTOR[$i][1] = _MemoryRead($CurrentOffset, $d3, 'ptr')
		$__ACTOR[$i][2] = _MemoryRead($CurrentOffset+0x4, $d3, 'char[64]')
		$__ACTOR[$i][3] = _MemoryRead($CurrentOffset+$ofs_LocalActor_atribGUID, $d3, 'ptr')
		$CurrentOffset = $CurrentOffset + $ofs_LocalActor_StrucSize
	Next
EndFunc

;;================================================================================
; Function:			IterateActorAtribs($_GUID,$_REQ)
; Description:		Read the requested attribute data from a actor defined by GUID
; Parameter(s):		$_GUID - The GUID of the object you want the data from
;					$_REQ - The data you want to request (the variable)
;
; Note(s):			You can find a list of all the $_REQ variables in the Constants() function
;					It should be noted that i have not checked them all through 
;						so the type ("float" or "int") might be wrong.
;					This function will always return "false" if the requested atribute does not exsist
;==================================================================================
func IterateActorAtribs($_GUID,$_REQ)
	IterateLocalActor()
	$ACDIndex = _ArraySearch($__ACTOR,"0x"&hex($_GUID), 0 , 0 , 0 , 1 , 1 , 1)	;this bitch is slow as hell

	$_Count = _MemoryRead($_ActorAtrib_Count, $d3, 'int')
	$CurrentOffset = $_ActorAtrib_4
	dim $ACTORatrib
	for $i = 0 to $_Count
		$ACTORatrib = _MemoryRead($CurrentOffset, $d3, 'ptr')
		if $ACTORatrib = $__ACTOR[$ACDIndex][3] Then
				$test = _MemoryRead($CurrentOffset+0x10, $d3, 'ptr')
				$CurretOffset = $test
				for $i = 0 to 825
					$data = _MemoryRead($CurretOffset, $d3, 'ptr')
					$CurretOffset = $CurretOffset +0x4
					if $data <> 0x0 Then
						$AtribData =_MemoryRead($data+0x4, $d3, 'ptr')
						if StringLeft($AtribData,7)="0xFFFFF" Then
							;ConsoleWrite("Debug :" &$data+0x4 & " : " & _MemoryRead($data+0x4, $d3, 'ptr') &@crlf) ;FOR DEBUGGING
							if "0x"&stringright($AtribData,3) = $_REQ[0] Then
								return _MemoryRead($data+0x8, $d3, $_REQ[1])
							EndIf
						EndIf
					EndIf
				Next
			return False	
		EndIf
		$CurrentOffset = $CurrentOffset + $ofs_ActorAtrib_StrucSize
	Next
	return False
EndFunc

;;================================================================================
; Function:			LinkActors
; Description:		Read and index data from the specified offset
; Parameter(s):		$_offset - The offset linking to the file def
;								be in hex format (0x00000000).
;					$_displayInfo - Setting this to 1 will make the function spit 
;								out the results while running
; Note(s):			This function is used to index data from the MPQ files that 
;					that have been loaded into memory.
;					Im not sure why the count doesnt go beyond 256.
;					So for the time being if the count goes beyond 256 the size
;					is set to a specified count and then the array will be scaled
;					after when data will stop being available.
;==================================================================================
func LinkActors($Object, $_displayInfo = 0)
	global $OBject_Mem_Actor = 			$Object
	global $Object_File_Actor = 		IndexSNO($ofs_ActorDef,0)	
	global $Object_File_Monster = 		IndexSNO($ofs_MonsterDef,0)
	dim $__outputdata[ubound($OBject_Mem_Actor,1)-1][2]
	for $i = 0 to ubound($OBject_Mem_Actor,1)-1
		if $OBject_Mem_Actor[$i][9] <> -1 Then
			$ItemIndex = _ArraySearch($Object_File_Actor,$OBject_Mem_Actor[$i][9], 0 , 0 , 0 , 1 , 1 , 1)
			if $ItemIndex > 0 then 
				$MonsterID = _MemoryRead($Object_File_Actor[$ItemIndex][0] + 0x6c, $d3, 'ptr')
				$ItemIndex = _ArraySearch($Object_File_Monster,$MonsterID, 0 , 0 , 0 , 1 , 1 , 1)
				if $ItemIndex > 0 then 
					$Type =  _MemoryRead($Object_File_Monster[$ItemIndex][0] + $_ofs_FileMonster_MonsterType, $d3, 'int')
					$MonsterType = $_Const_MonsterType[$Type+1]
					$Race =  _MemoryRead($Object_File_Monster[$ItemIndex][0] + $_ofs_FileMonster_MonsterRace, $d3, 'int')
					$MonsterRace = $_Const_MonsterRace[$Race+1]
				
					;$LevelNormal =  _MemoryRead($Object_File_Monster[$ItemIndex][0] + $_ofs_FileMonster_LevelNormal, $d3, 'int')			;//Here are some data you can use if you want, 
					;$LevelNightmare =  _MemoryRead($Object_File_Monster[$ItemIndex][0] + $_ofs_FileMonster_LevelNightmare, $d3, 'int')		;//...it gives info about levels based on dificulty
					;$LevelHell =  _MemoryRead($Object_File_Monster[$ItemIndex][0] + $_ofs_FileMonster_LevelHell, $d3, 'int')
					;$LevelInferno =  _MemoryRead($Object_File_Monster[$ItemIndex][0] + $_ofs_FileMonster_LevelInferno, $d3, 'int')			

					$OBject_Mem_Actor[$i][11] = $Type
					$OBject_Mem_Actor[$i][12] = $Race
					if $_displayInfo = 1 Then ConsoleWrite($i & " " & $Object_File_Actor[$ItemIndex][0] & @tab & " " &$MonsterType &@tab & " " & $MonsterRace &@tab & " Level Normal:" $LevelNormal &@tab & " " & $StringListDB[$Name][1] &" " & @TAB & &$OBject_Mem_Actor[$i][2] &@crlf) 
				EndIf
			EndIf	
		EndIf
	Next
	return $OBject_Mem_Actor
EndFunc

;;================================================================================
; Function:			IndexSNO($_offset[,$_displayInfo = 0])
; Description:		Read and index data from the specified offset
; Parameter(s):		$_offset - The offset linking to the file def
;								be in hex format (0x00000000).
;					$_displayInfo - Setting this to 1 will make the function spit 
;								out the results while running
; Note(s):			This function is used to index data from the MPQ files that 
;					that have been loaded into memory.
;					Im not sure why the count doesnt go beyond 256.
;					So for the time being if the count goes beyond 256 the size
;					is set to a specified count and then the array will be scaled
;					after when data will stop being available.
;==================================================================================
func IndexSNO($_offset,$_displayInfo = 0)
	local $CurrentSnoOffset = 0x0
	$_MainOffset = 	_MemoryRead($_offset, $d3, 'ptr')
	$_Pointer = 	_MemoryRead($_MainOffset + $_defptr, $d3, 'ptr')
	$_SnoCount = 	_MemoryRead($_Pointer + $_defcount, $d3, 'ptr') 	;//Doesnt seem to go beyond 256 for some wierd reason
	if $_SnoCount >= 256 Then											;//So incase it goes beyond...
		$ignoreSNOcount = 1												;//This enables a redim after the for loop
		$_SnoCount = 4056 												;//We put a limit to avoid overflow here
	Else
		$ignoreSNOcount = 0
	EndIf
	$_SnoIndex = _MemoryRead($_Pointer + $_deflink, $d3, 'ptr')			;//Moving from the static into the index
	$_SNOName =  _MemoryRead($_Pointer, $d3, 'char[64]')				;//Usually something like "Something" + Def
	$TempWindex = $_SnoIndex +0xC										;//The header is 0xC in size
	if $_displayInfo = 1 then ConsoleWrite("-----* Indexing "&$_SNOName& " *-----"&@crlf)
	dim $_OutPut[$_SnoCount+1][2]										;//Setting the size of the output array
	for $i = 1 to $_SnoCount step + 1									;//Iterating through all the elements
		$_CurSnoOffset = _MemoryRead($TempWindex, $d3, 'ptr')			;//Getting the offset for the item
		$_CurSnoID = _MemoryRead($_CurSnoOffset, $d3, 'ptr')			;//Going into the item and grapping the GUID which is located at 0x0
		if $ignoreSNOcount = 1 and $_CurSnoOffset = 0x00000000 and $_CurSnoID = 0x00000000 then ExitLoop ;//Untill i find a way to get the real count we do this instead.
		if $ignoreSNOcount = 1 then $CurIndex = $i
		$_OutPut[$i][0] = $_CurSnoOffset								;//Poping the data into the output array
		$_OutPut[$i][1] = $_CurSnoID	
		if $_displayInfo = 1 then ConsoleWrite($i & " Offset: " & $_CurSnoOffset & " SNOid: " & $_CurSnoID &@crlf)
		$TempWindex = $TempWindex + 0x10								;//Next item is located 0x10 later
	Next
	if $ignoreSNOcount = 1 then redim $_OutPut[$CurIndex][2]			;//Here we do the resizing of the array, to minimize memory footprint!?.
	return $_OutPut
EndFunc

;;================================================================================
; Function:			IndexStringList($_offset)
; Description:		Read and index data from the specified offset
; Parameter(s):		$_offset - The offset linking to the file def
;								  be in hex format (0x00000000).
;					$_displayInfo - Setting this to 1 will make the function spit 
;								out the results while running
;								 
; Note(s):			This function is made specificly to index string lists.
;					This is usefull for getting real localized names from the
;					proxy names you get from the objectmanager strucs.
;					i have only test this on monster names but it should work for all.
;==================================================================================
func IndexStringList($_offset,$_displayInfo=0)
	$_offset_FileMonster_StrucSize = 0x50
	$_StringCount = _MemoryRead($_offset + 0xc, $d3, 'int')
	$_CurrentOffset = $_offset + 0x28
	dim $_OutPut[$_StringCount][2]
	for $i = 0 to $_StringCount-1
		$_OutPut[$i][0] = _MemoryRead(_MemoryRead($_CurrentOffset, $d3, 'int'), $d3, 'char[32]')		;Proxy Name, like "Priest_Male_B_NoLook"
		$_OutPut[$i][1] = _MemoryRead(_MemoryRead($_CurrentOffset+0x10, $d3, 'int'), $d3, 'char[34]')	;Localized name, like "Brother Malachi the Healer"
		Assign ( "__"&$_OutPut[$i][0], $_OutPut[$i][1],2 )
		$_CurrentOffset = $_CurrentOffset + $_offset_FileMonster_StrucSize
		if $_displayInfo = 1 Then ConsoleWrite($_CurrentOffset & " ProxyName: " & $_OutPut[$i][0] & @tab & " LocalizedName: " & $_OutPut[$i][1]&@crlf)
	Next
	return $_OutPut
EndFunc
	
;;--------------------------------------------------------------------------------
;;	OffsetList()
;;--------------------------------------------------------------------------------
func offsetlist()
	Constants()	
	
	;//FILE DEFS
	
Global $ofs_MonsterDef = 0x15DBE00 ;0x015DCE00 ;0x15DBE00
Global $ofs_StringListDef = 0x015E8808 ;0x015E9808
Global $ofs_ActorDef = 0x15EC108 ;0x015ED108 ;0x15EC108
Global $ofs_ActorAtrib_Base = 0x15A1EA4 ;0x015A2EA4;0x015A1EA4
Global $ofs_ObjectManager =  0x1543B9C ;0x015A1BEC;0x15A0BEC; 0x1543B9C
Global $ofs_InteractBase = 0x15A0BD4 ;0x015A1BD4;0x15A0BD4

	;global $ofs_MonsterDef = 					0x015DCE00
	;global $ofs_StringListDef =					0x015E9808	
	;global $ofs_ActorDef =						0x015ED108	
	
	global $_defptr = 							0x3c
	global $_defcount = 						0x10C
	global $_deflink = 							0x148

	global $_ofs_FileMonster_StrucSize = 0x50

	global $_ofs_FileActor_LinkToMonster = 0x6C

	global $_ofs_FileMonster_MonsterType 	= 0x18
	global $_ofs_FileMonster_MonsterRace 	= 0x1C
	global $_ofs_FileMonster_LevelNormal 	= 0x44
	global $_ofs_FileMonster_LevelNightmare = 0x48
	global $_ofs_FileMonster_LevelHell 		= 0x4c
	global $_ofs_FileMonster_LevelInferno	= 0x50

	;//GET ACTORATRIB
	;global $ofs_ActorAtrib_Base	= 				0x015A2EA4;0x015A1EA4
	global $ofs_ActorAtrib_ofs1	= 				0x390
	global $ofs_ActorAtrib_ofs2	= 				0x2E8
	global $ofs_ActorAtrib_ofs3	= 				0x148
	global $ofs_ActorAtrib_Count =	 			0x108 	; 0x0 0x0

	global $ofs_ActorAtrib_Indexing_ofs1 = 		0x10
	global $ofs_ActorAtrib_Indexing_ofs2 = 		0x8
	global $ofs_ActorAtrib_Indexing_ofs3 = 		0x250
	global $ofs_ActorAtrib_StrucSize = 			0x180
	
	global $ofs_LocalPlayer_HPBARB =			0x34
	global $ofs_LocalPlayer_HPWIZ =				0x38

	
	;//GET LOCAL ACTOR STRUC
	global $ofs_LocalActor_ofs1 = 				0x378 	;instead of $ofs_ActorAtrib_ofs2
	global $ofs_LocalActor_ofs2 = 				0x148
	global $ofs_LocalActor_Count = 				0x108
	global $ofs_LocalActor_atribGUID =			0x120
	global $ofs_LocalActor_StrucSize = 			0x2D0 	; 0x0 0x0


	;//OBJECT MANAGER
	;global $ofs_ObjectManager = 				0x015A1BEC ;0x15A0BEC
	global $ofs__ObjmanagerActorOffsetA = 		0x8b0
	global $ofs__ObjmanagerActorCount = 		0x108
	global $ofs__ObjmanagerActorOffsetB = 		0x148
	global $ofs__ObjmanagerActorLinkToCTM = 	0x380
	global $_ObjmanagerStrucSize = 				0x428	



	;//CameraDef
	Global $VIewStatic = 						0x015A0BEC
	Global $DebugFlags = $VIewStatic + 			0x20
	Global $vftableSubA = _MemoryRead($VIewStatic, $d3, 'ptr')
	Global $vftableSubA = _MemoryRead($vftableSubA + 0x928, $d3, 'ptr')
	Global $ViewOffset = $vftableSubA

	Global $Ofs_CameraRotationA = $ViewOffset + 0x4
	Global $Ofs_CameraRotationB = $ViewOffset + 0x8
	Global $Ofs_CameraRotationC = $ViewOffset + 0xC
	Global $Ofs_CameraRotationD = $ViewOffset + 0x10
	Global $Ofs_CameraPosX = $ViewOffset + 		0x14
	Global $Ofs_CameraPosY = $ViewOffset + 		0x18
	Global $Ofs_CameraPosZ = $ViewOffset + 		0x1C
	Global $Ofs_CameraFOV = $ViewOffset + 		0x30
	Global $Ofs_CameraFOVB = $ViewOffset + 		0x30	
	

	;global $ofs_InteractBase =					0x015A1BD4;0x15A0BD4
	global $ofs__InteractOffsetA =	 			0xA8
	global $ofs__InteractOffsetB = 				0x58
	global $ofs__InteractOffsetUNK1 = 			0x7F20 ;Set to 777c
	global $ofs__InteractOffsetUNK2 = 			0x7F44 ;Set to 1 for NPC interaction
	global $ofs__InteractOffsetUNK3 = 			0x7F7C ;Set to 7546 for NPC interaction, 7545 for loot interaction
	global $ofs__InteractOffsetUNK4 = 			0x7F80 ;Set to 7546 for NPC interaction, 7545 for loot interaction
	global $ofs__InteractOffsetMousestate = 	0x7F84 ;Mouse state 1 = clicked, 2 = mouse down
	global $ofs__InteractOffsetGUID = 			0x7F88 ;Set to the GUID of the actor you want to interact with
	
	$FixSpeed = 								0x20 ;69736
	$ToggleMove = 								0x34
	$MoveToXoffset = 							0x40
	$MoveToYoffset = 							0x44
	$MoveToZoffset = 							0x48
	$CurrentX = 								0xA8
	$CurrentY = 								0xAc
	$CurrentZ = 								0xb0
	$RotationOffset =							0x174

	global $_ActorAtrib_Base  = _MemoryRead($ofs_ActorAtrib_Base, $d3, 'ptr')	
	global $_ActorAtrib_1  = _MemoryRead($_ActorAtrib_Base+$ofs_ActorAtrib_ofs1, $d3, 'ptr')
	global $_ActorAtrib_2  = _MemoryRead($_ActorAtrib_1+$ofs_ActorAtrib_ofs2, $d3, 'ptr')
	global $_ActorAtrib_3  = _MemoryRead($_ActorAtrib_2+$ofs_ActorAtrib_ofs3, $d3, 'ptr')
	global $_ActorAtrib_4  = _MemoryRead($_ActorAtrib_3, $d3, 'ptr')
	global $_ActorAtrib_Count  = $_ActorAtrib_2+$ofs_ActorAtrib_Count

	global $_LocalActor_1  = _MemoryRead($_ActorAtrib_1+$ofs_LocalActor_ofs1, $d3, 'ptr')
	global $_LocalActor_2  = _MemoryRead($_LocalActor_1+$ofs_LocalActor_ofs2, $d3, 'ptr')
	global $_LocalActor_3  = _MemoryRead($_LocalActor_2, $d3, 'ptr')
	global $_LocalActor_Count  = $_LocalActor_1+$ofs_LocalActor_Count

	global $_itrObjectManagerA  = _MemoryRead($ofs_ObjectManager, $d3, 'ptr')		
	global $_itrObjectManagerB  = _MemoryRead($_itrObjectManagerA+$ofs__ObjmanagerActorOffsetA, $d3, 'ptr')	
	global $_itrObjectManagerCount  = $_itrObjectManagerB+$ofs__ObjmanagerActorCount
	global $_itrObjectManagerC  = _MemoryRead($_itrObjectManagerB+$ofs__ObjmanagerActorOffsetB, $d3, 'ptr')	
	global $_itrObjectManagerD  = _MemoryRead($_itrObjectManagerC, $d3, 'ptr')	
	global $_itrObjectManagerE  = _MemoryRead($_itrObjectManagerD, $d3, 'ptr')	
	
	global $_itrInteractA  = _MemoryRead($ofs_InteractBase, $d3, 'ptr')	
	global $_itrInteractB  = _MemoryRead($_itrInteractA, $d3, 'ptr')	
	global $_itrInteractC  = _MemoryRead($_itrInteractB, $d3, 'ptr')	
	global $_itrInteractD  = _MemoryRead($_itrInteractC+$ofs__InteractOffsetA, $d3, 'ptr')	
	global $_itrInteractE  = $_itrInteractD+$ofs__InteractOffsetB


	global $Object_File_StringList = 	IndexSNO($ofs_StringListDef,0) 		;//THIS LIST IS HUGE, NO NEED TO DO IT MORE OFTEN THAN ONCE =) 
	$index = _ArraySearch($Object_File_StringList,hex($_MonsterNameStringListID), 0 , 0 , 0 , 1 , 1 , 1)
	
	;;global $Object_File_StringList = IndexSNO($ofs_StringListDef,0) 		;//THIS LIST IS HUGE, NO NEED TO DO IT MORE OFTEN THAN ONCE =) 
	;;$index = _ArraySearch($Object_File_StringList, hex($_MonsterNameStringListID), 0 , 0 , 0 , 1 , 1 , 1)
	;;global $StringListDB = IndexStringList($Object_File_StringList[$index][0])	;$StringListDB is debricated in this code
	;;$index = _ArraySearch($Object_File_StringList,hex($_GizmoNameStringListID), 0 , 0 , 0 , 1 , 1 , 1)
	;;IndexStringList($Object_File_StringList[$index][0])
	if LocateMyToon() Then 
	
	global $ClickToMoveMain = _MemoryRead($_Myoffset + $ofs__ObjmanagerActorLinkToCTM, $d3, 'ptr')
	global $ClickToMoveRotation = $ClickToMoveMain + $RotationOffset
	global $ClickToMoveCurX = $ClickToMoveMain + $CurrentX
	global $ClickToMoveCurY = $ClickToMoveMain + $CurrentY
	global $ClickToMoveCurZ = $ClickToMoveMain + $CurrentZ
	global $ClickToMoveToX = $ClickToMoveMain + $MoveToXoffset
	global $ClickToMoveToY = $ClickToMoveMain + $MoveToYoffset
	global $ClickToMoveToZ = $ClickToMoveMain + $MoveToZoffset
	global $ClickToMoveToggle = $ClickToMoveMain + $ToggleMove
	global $ClickToMoveFix= $ClickToMoveMain + $FixSpeed
		return true
	Else
		Return false
	EndIf
	
EndFunc

;;--------------------------------------------------------------------------------
;;	IterateObjectList()
;;--------------------------------------------------------------------------------
func IterateObjectList($_displayINFO = 0)

	if $_displayINFO = 1 then ConsoleWrite("-----Iterating through Actors------" &@crlf)
	if $_displayINFO = 1 then ConsoleWrite("First Actor located at: "& $_itrObjectManagerD &@crlf)
	$_CurOffset = $_itrObjectManagerD
	$_Count = _MemoryRead($_itrObjectManagerCount, $d3, 'int')
	dim $OBJ[$_Count+1][13]
	if $_displayINFO = 1 then ConsoleWrite("Number of Actors : " & $_Count &@crlf)
	;$init = TimerInit()	
	for $i = 0 to $_Count step +1 
		$_GUID = _MemoryRead($_CurOffset+0x4, $d3, 'ptr')
		; if $_GUID = 0xffffffff Then ;no need to go through objects without a GUID!
			; $_PROXY_NAME = -1
			; $_REAL_NAME = -1
			; $_ACTORLINK = -1
			; $_POS_X = -1
			; $_POS_Y = -1	
			; $_POS_Z = -1	
			; $_DATA = -1
			; $_DATA2 = -1
		; Else
			$_PROXY_NAME = _MemoryRead($_CurOffset+0x8, $d3, 'char[64]')
			$TmpString = StringSplit($_PROXY_NAME,"-")
			if IsDeclared("__"&$TmpString[1]) Then
				$_REAL_NAME = eval("__"&$TmpString[1])
			Else 
				$_REAL_NAME = $_PROXY_NAME
			EndIf
			$_ACTORLINK = _MemoryRead($_CurOffset+0x88, $d3, 'ptr')
			$_POS_X = _MemoryRead($_CurOffset+0xB0, $d3, 'float')	
			$_POS_Y = _MemoryRead($_CurOffset+0xB4, $d3, 'float')	
			$_POS_Z = _MemoryRead($_CurOffset+0xB8, $d3, 'float')	
			$_DATA = _MemoryRead($_CurOffset+0x1FC, $d3, 'int')
			$_DATA2 = _MemoryRead($_CurOffset+0x1Cc, $d3, 'int')
		if $_displayINFO = 1 then ConsoleWrite($i & @TAB&" : " & $_CurOffset & " " & $_GUID & " " &  $_ACTORLINK &" : " & $_DATA & " "& $_DATA2 & " " & @TAB& $_POS_X &" "& $_POS_Y&" "& $_POS_Z & @TAB& $_REAL_NAME &@crlf)
		;EndIf
		
			;Im too lazy to do this but the following code needs cleanup and restructure more than anything.
			;You want to include all the data into this one structure rather than having it at multiple locations
			;and the useless things should be removed.
			
			$Distance = GetDistance($_POS_X,$_POS_Y,$_POS_Z)
			$OBJ[$i][0] = $_CurOffset
			$OBJ[$i][1] = $_GUID
			$OBJ[$i][2] = $_PROXY_NAME
			$OBJ[$i][3] = $_POS_X
			$OBJ[$i][4] = $_POS_Y
			$OBJ[$i][5] = $_POS_Z
			$OBJ[$i][6] = $_DATA
			$OBJ[$i][7] = $_DATA2
			$OBJ[$i][8] = $Distance
			$OBJ[$i][9] = $_ACTORLINK	
			$OBJ[$i][10] = $_REAL_NAME
			$OBJ[$i][11] = -1	
			$OBJ[$i][12] = -1			
		$_CurOffset = $_CurOffset + $_ObjmanagerStrucSize

	Next
	$OBJv2 = LinkActors($OBJ)	;//Would be a waste to do this in the main operation so we add more data to the object here after the main operation.
	IterateLocalActor()
	return $OBJv2
EndFunc

;;================================================================================
; Function:			Constants()
; Description:		Defines all the constants (they are not constants, just variables for now, you might want to change this =)!)
; Parameter(s):		none
;								 
; Note(s):			This info is NOT complete, you might want to change the types!.
;==================================================================================
func Constants()
	global $_Const_MonsterType[10] = ["Unknown","Undead","Demon","Beast","Human","Breakable","Scenery","Ally","Team","Helper"]
	global $_Const_MonsterRace[12] = ["Unknown","Unknown(INDEX ME!)","Fallen","GoatMen","Rogue","Skeleton","Zombie","Spider","Triune","WoodWraith","Human","Animal"]
	global $_MonsterNameStringListID = 0x0000CB35 ;We use this to get local Names on monsters and NPC's
	global $_GizmoNameStringListID = 0x0000CB23 ;We use this to get local Names on Gizmos
	global $Atrib_Axe_Bad_Data[2] = [0x0,"float"]
	global $Atrib_Attribute_Timer[2] = [0x1,"int"]
	global $Atrib_Attribute_Pool[2] = [0x2,"int"]
	global $Atrib_Death_Count[2] = [0x3,"int"]
	global $Atrib_DualWield_Hand[2] = [0x4,"int"]
	global $Atrib_DualWield_Hand_Next[2] = [0x5,"int"]
	global $Atrib_DualWield_Hands_Swapped[2] = [0x6,"int"]
	global $Atrib_Respawn_Game_Time[2] = [0x7,"int"]
	global $Atrib_Backpack_Slots[2] = [0x8,"int"]
	global $Atrib_Shared_Stash_Slots[2] = [0x9,"int"]
	global $Atrib_Strength[2] = [0xa,"float"]
	global $Atrib_Dexterity[2] = [0xb,"float"]
	global $Atrib_Intelligence[2] = [0xc,"float"]
	global $Atrib_Vitality[2] = [0xd,"float"]
	global $Atrib_Strength_Total[2] = [0xe,"float"]
	global $Atrib_Dexterity_Total[2] = [0xf,"float"]
	global $Atrib_Intelligence_Total[2] = [0x10,"float"]
	global $Atrib_Vitality_Total[2] = [0x11,"float"]
	global $Atrib_Strength_Bonus[2] = [0x12,"float"]
	global $Atrib_Dexterity_Bonus[2] = [0x13,"float"]
	global $Atrib_Intelligence_Bonus[2] = [0x14,"float"]
	global $Atrib_Vitality_Bonus[2] = [0x15,"float"]
	global $Atrib_Strength_Bonus_Percent[2] = [0x16,"float"]
	global $Atrib_Dexterity_Bonus_Percent[2] = [0x17,"float"]
	global $Atrib_Intelligence_Bonus_Percent[2] = [0x18,"float"]
	global $Atrib_Vitality_Bonus_Percent[2] = [0x19,"float"]
	global $Atrib_Strength_Reduction_Percent[2] = [0x1A,"float"]
	global $Atrib_Dexterity_Reduction_Percent[2] = [0x1B,"float"]
	global $Atrib_Intelligence_Reduction_Percent[2] = [0x1C,"float"]
	global $Atrib_Vitality_Reduction_Percent[2] = [0x1D,"float"]
	global $Atrib_Primary_Damage_Attribute[2] = [0x1E,"int"]
	global $Atrib_Attack[2] = [0x1F,"float"]
	global $Atrib_Precision[2] = [0x20,"float"]
	global $Atrib_Defense[2] = [0x21,"float"]
	global $Atrib_Attack_Total[2] = [0x22,"float"]
	global $Atrib_Precision_Total[2] = [0x23,"float"]
	global $Atrib_Defense_Total[2] = [0x24,"float"]
	global $Atrib_Attack_Bonus[2] = [0x25,"float"]
	global $Atrib_Precision_Bonus[2] = [0x26,"float"]
	global $Atrib_Defense_Bonus[2] = [0x27,"float"]
	global $Atrib_Attack_Bonus_Percent[2] = [0x28,"float"]
	global $Atrib_Precision_Bonus_Percent[2] = [0x29,"float"]
	global $Atrib_Defense_Bonus_Percent[2] = [0x2A,"float"]
	global $Atrib_Attack_Reduction_Percent[2] = [0x2B,"float"]
	global $Atrib_Precision_Reduction_Percent[2] = [0x2C,"float"]
	global $Atrib_Defense_Reduction_Percent[2] = [0x2D,"float"]
	global $Atrib_Armor[2] = [0x2E,"float"]
	global $Atrib_Armor_Bonus_Percent[2] = [0x2F,"float"]
	global $Atrib_Armor_Item[2] = [0x30,"float"]
	global $Atrib_Armor_Bonus_Item[2] = [0x31,"float"]
	global $Atrib_Armor_Item_Percent[2] = [0x32,"float"]
	global $Atrib_Armor_Item_SubTotal[2] = [0x33,"float"]
	global $Atrib_Armor_Item_Total[2] = [0x34,"float"]
	global $Atrib_Armor_Total[2] = [0x35,"float"]
	global $Atrib_Experience_Granted[2] = [0x36,"int"]
	global $Atrib_Experience_Next[2] = [0x37,"int"]
	global $Atrib_Gold_Granted[2] = [0x39,"int"]
	global $Atrib_Gold[2] = [0x3a,"int"]
	global $Atrib_Gold_Find[2] = [0x3b,"float"]
	global $Atrib_Level[2] = [0x40,"int"]
	global $Atrib_Level_Cap[2] = [0x41,"int"]
	global $Atrib_Magic_Find[2] = [0x43,"float"]
	global $Atrib_Magic_And_Gold_Find_Suppressed[2] = [0x48,"int"]
	global $Atrib_Treasure_Find[2] = [0x49,"float"]
	global $Atrib_Resource_Cost_Reduction_Amount[2] = [0x4a,"int"]
	global $Atrib_Resource_Cost_Reduction_Total[2] = [0x4b,"float"]
	global $Atrib_Resource_Set_Point_Bonus[2] = [0x4c,"float"]
	global $Atrib_Faster_Healing_Percent[2] = [0x4d,"float"]
	global $Atrib_Spending_Resource_Heals_Percent[2] = [0x4f,"float"]
	global $Atrib_Bonus_Healing_Received_Percent[2] = [0x4f,"float"]
	global $Atrib_Reduced_Healing_Received_Percent[2] = [0x50,"float"]
	global $Atrib_Experience_Bonus[2] = [0x51,"float"]
	global $Atrib_Experience_Bonus_Percent[2] = [0x52,"float"]
	global $Atrib_Health_Globe_Bonus_Chance[2] = [0x53,"float"]
	global $Atrib_Health_Globe_Bonus_Mult_Chance[2] = [0x54,"float"]
	global $Atrib_Health_Globe_Bonus_Health[2] = [0x55,"float"]
	global $Atrib_Increased_Health_From_Globes_Percent[2] = [0x56,"float"]
	global $Atrib_Increased_Health_From_Globes_Percent_Total[2] = [0x57,"float"]
	global $Atrib_Bonus_Health_Percent_Per_Second_From_Globes[2] = [0x58,"float"]
	global $Atrib_Bonus_Health_Percent_Per_Second_From_Globes_Total[2] = [0x59,"float"]
	global $Atrib_Mana_Gained_From_Globes_Percent[2] = [0x5a,"float"]
	global $Atrib_Mana_Gained_From_Globes[2] = [0x5b,"float"]
	global $Atrib_Resistance[2] = [0x5c,"float"]
	global $Atrib_Resistance_Percent[2] = [0x5d,"float"]
	global $Atrib_Resistance_Total[2] = [0x5e,"float"]
	global $Atrib_Resistance_All[2] = [0x5f,"float"]
	global $Atrib_Resistance_Percent_All[2] = [0x60,"float"]
	global $Atrib_Resistance_From_Intelligence[2] = [0x61,"float"]
	global $Atrib_Class_Damage_Reduction_Percent[2] = [0x62,"float"]
	global $Atrib_Skill[2] = [0x63,"int"]
	global $Atrib_Skill_Total[2] = [0x64,"int"]
	global $Atrib_TeamID[2] = [0x65,"int"]
	global $Atrib_Team_Override[2] = [0x66,"int"]
	global $Atrib_Invulnerable[2] = [0x67,"int"]
	global $Atrib_Loading[2] = [0x68,"int"]
	global $Atrib_Loading_Player_ACD[2] = [0x69,"int"]
	global $Atrib_Loading_Power_SNO[2] = [0x6a,"int"]
	global $Atrib_Loading_Anim_Tag[2] = [0x6b,"int"]
	global $Atrib_Loading_NewGame[2] = [0x6c,"int"]
	global $Atrib_Auto_Porting_To_Save_Point[2] = [0x6d,"int"]
	global $Atrib_No_Damage[2] = [0x6e,"int"]
	global $Atrib_No_AutoPickup[2] = [0x6f,"int"]
	global $Atrib_Light_Radius_Percent_Bonus[2] = [0x70,"float"]
	global $Atrib_Hitpoints_Cur[2] = [0x71,"float"]
	global $Atrib_Hitpoints_Factor_Level[2] = [0x72,"float"]
	global $Atrib_Hitpoints_Factor_Vitality[2] = [0x73,"float"]
	global $Atrib_Hitpoints_Total_From_Vitality[2] = [0x74,"float"]
	global $Atrib_Hitpoints_Total_From_Level[2] = [0x75,"float"]
	global $Atrib_Hitpoints_Granted[2] = [0x76,"float"]
	global $Atrib_Hitpoints_Granted_Duration[2] = [0x77,"int"]
	global $Atrib_Hitpoints_Max[2] = [0x78,"float"]
	global $Atrib_Hitpoints_Max_Bonus[2] = [0x79,"float"]
	global $Atrib_Hitpoints_Max_Total[2] = [0x7a,"float"]
	global $Atrib_Hitpoints_Percent[2] = [0x7b,"float"]
	global $Atrib_Hitpoints_Regen_Per_Second[2] = [0x7c,"float"]
	global $Atrib_Hitpoints_Max_Percent_Bonus[2] = [0x7d,"float"]
	global $Atrib_Hitpoints_Max_Percent_Bonus_Item[2] = [0x7e,"float"]
	global $Atrib_Hitpoints_Healed_Target[2] = [0x7f,"float"]
	global $Atrib_Resource_Type_Primary[2] = [0x80,"int"]
	global $Atrib_Resource_Type_Secondary[2] = [0x81,"int"]
	global $Atrib_Resource_Cur[2] = [0x82,"float"]
	global $Atrib_Resource_Max[2] = [0x83,"float"]
	global $Atrib_Resource_Max_Bonus[2] = [0x84,"float"]
	global $Atrib_Resource_Max_Total[2] = [0x85,"float"]
	global $Atrib_Resource_Factor_Level[2] = [0x86,"float"]
	global $Atrib_Resource_Granted[2] = [0x87,"float"]
	global $Atrib_Resource_Granted_Duration[2] = [0x88,"int"]
	global $Atrib_Resource_Percent[2] = [0x89,"float"]
	global $Atrib_Resource_Regen_Per_Second[2] = [0x8a,"float"]
	global $Atrib_Resource_Regen_Bonus_Percent[2] = [0x8b,"float"]
	global $Atrib_Resource_Regen_Total[2] = [0x8c,"float"]
	global $Atrib_Resource_Max_Percent_Bonus[2] = [0x8d,"float"]
	global $Atrib_Resource_Capacity_Used[2] = [0x8e,"float"]
	global $Atrib_Resource_Effective_Max[2] = [0x8f,"float"]
	global $Atrib_Resource_Regen_Percent_Per_Second[2] = [0x90,"float"]
	global $Atrib_Resource_Degeneration_Stop_Point[2] = [0x91,"float"]
	global $Atrib_Movement_Scalar[2] = [0x92,"float"]
	global $Atrib_Walking_Rate[2] = [0x93,"float"]
	global $Atrib_Running_Rate[2] = [0x94,"float"]
	global $Atrib_Sprinting_Rate[2] = [0x95,"float"]
	global $Atrib_Strafing_Rate[2] = [0x96,"float"]
	global $Atrib_Walking_Rate_Total[2] = [0x97,"float"]
	global $Atrib_Running_Rate_Total[2] = [0x98,"float"]
	global $Atrib_Last_Running_Rate[2] = [0x99,"float"]
	global $Atrib_Sprinting_Rate_Total[2] = [0x9a,"float"]
	global $Atrib_Strafing_Rate_Total[2] = [0x9b,"float"]
	global $Atrib_Movement_Bonus_Total[2] = [0x9c,"float"]
	global $Atrib_Movement_Scalar_Subtotal[2] = [0x9d,"float"]
	global $Atrib_Movement_Scalar_Capped_Total[2] = [0x9e,"float"]
	global $Atrib_Movement_Scalar_Uncapped_Bonus[2] = [0x9f,"float"]
	global $Atrib_Movement_Scalar_Total[2] = [0xa0,"float"]
	global $Atrib_Movement_Bonus_Run_Speed[2] = [0xa1,"float"]
	global $Atrib_Casting_Speed[2] = [0xa2,"float"]
	global $Atrib_Casting_Speed_Bonus[2] = [0xa3,"float"]
	global $Atrib_Casting_Speed_Total[2] = [0xa4,"float"]
	global $Atrib_Always_Hits[2] = [0xa5,"int"]
	global $Atrib_Hit_Chance[2] = [0xa6,"float"]
	global $Atrib_Attacks_Per_Second_Item[2] = [0xa7,"float"]
	global $Atrib_Attacks_Per_Second_Item_Percent[2] = [0xa8,"float"]
	global $Atrib_Attacks_Per_Second_Item_Subtotal[2] = [0xa9,"float"]
	global $Atrib_Attacks_Per_Second_Item_Bonus[2] = [0xaa,"float"]
	global $Atrib_Attacks_Per_Second_Item_Total[2] = [0xab,"float"]
	global $Atrib_Attacks_Per_Second[2] = [0xac,"float"]
	global $Atrib_Attacks_Per_Second_Bonus[2] = [0xad,"float"]
	global $Atrib_Attacks_Per_Second_Total[2] = [0xae,"float"]
	global $Atrib_Attacks_Per_Second_Percent[2] = [0xbf,"float"]
	global $Atrib_AI_Cooldown_Reduction_Percent[2] = [0xb0,"float"]
	global $Atrib_Power_Cooldown_Reduction_Percent[2] = [0xb1,"float"]
	global $Atrib_Damage_Delta[2] = [0xb2,"float"]
	global $Atrib_Damage_Delta_Total[2] = [0xb3,"float"]
	global $Atrib_Damage_Min[2] = [0xb4,"float"]
	global $Atrib_Damage_Bonus_Min[2] = [0xb5,"float"]
	global $Atrib_Damage_Min_Total[2] = [0xb6,"float"]
	global $Atrib_Damage_Min_Subtotal[2] = [0xb7,"float"]
	global $Atrib_Damage_Percent_All_From_Skills[2] = [0xbb,"float"]
	global $Atrib_Damage_Weapon_Delta[2] = [0xbc,"float"]
	global $Atrib_Damage_Weapon_Delta_SubTotal[2] = [0xbd,"float"]
	global $Atrib_Damage_Weapon_Max[2] = [0xbe,"float"]
	global $Atrib_Damage_Weapon_Max_Total[2] = [0xbf,"float"]
	global $Atrib_Damage_Weapon_Max_Total_All[2] = [0xc0,"float"]
	global $Atrib_Damage_Weapon_Delta_Total[2] = [0xc1,"float"]
	global $Atrib_Damage_Weapon_Delta_Total_All[2] = [0xc2,"float"]
	global $Atrib_Damage_Weapon_Bonus_Delta[2] = [0xc3,"float"]
	global $Atrib_Damage_Weapon_Min[2] = [0xc4,"float"]
	global $Atrib_Damage_Weapon_Min_Total[2] = [0xc5,"float"]
	global $Atrib_Damage_Weapon_Min_Total_All[2] = [0xc6,"float"]
	global $Atrib_Damage_Weapon_Bonus_Min[2] = [0xca,"float"]
	global $Atrib_Damage_Weapon_Percent_Bonus[2] = [0xcb,"float"]
	global $Atrib_Damage_Weapon_Percent_All[2] = [0xcc,"float"]
	global $Atrib_Damage_Weapon_Percent_Total[2] = [0xcd,"float"]
	global $Atrib_Damage_Type_Percent_Bonus[2] = [0xce,"float"]
	global $Atrib_Damage_Percent_Bonus_Witchdoctor[2] = [0xd0,"float"]
	global $Atrib_Damage_Percent_Bonus_Wizard[2] = [0xd1,"float"]
	global $Atrib_Crit_Percent_Base[2] = [0xd2,"float"]
	global $Atrib_Crit_Percent_Bonus_Capped[2] = [0xd3,"float"]
	global $Atrib_Crit_Percent_Bonus_Uncapped[2] = [0xd4,"float"]
	global $Atrib_Crit_Percent_Cap[2] = [0xd5,"float"]
	global $Atrib_Crit_Damage_Percent[2] = [0xd6,"float"]
	global $Atrib_Crit_Effect_Time[2] = [0xd7,"int"]
	global $Atrib_Pierce_Chance[2] = [0xd8,"float"]
	global $Atrib_Damage_Absorb_Percent[2] = [0xd9,"float"]
	global $Atrib_Damage_Reduction_Total[2] = [0xda,"float"]
	global $Atrib_Damage_Reduction_Current[2] = [0xdb,"float"]
	global $Atrib_Damage_Reduction_Last_Tick[2] = [0xdc,"int"]
	global $Atrib_Block_Chance[2] = [0xdd,"float"]
	global $Atrib_Block_Chance_Total[2] = [0xde,"float"]
	global $Atrib_Block_Chance_Bonus_Item[2] = [0xdf,"float"]
	global $Atrib_Block_Chance_Item[2] = [0xe0,"float"]
	global $Atrib_Block_Chance_Item_Total[2] = [0xe1,"float"]
	global $Atrib_Block_Amount[2] = [0xe2,"float"]
	global $Atrib_Block_Amount_Bonus_Percent[2] = [0xe3,"float"]
	global $Atrib_Block_Amount_Total_Min[2] = [0xe4,"float"]
	global $Atrib_Block_Amount_Total_Max[2] = [0xe5,"float"]
	global $Atrib_Block_Amount_Item_Min[2] = [0xe6,"float"]
	global $Atrib_Block_Amount_Item_Delta[2] = [0xe7,"float"]
	global $Atrib_Block_Amount_Item_Bonus[2] = [0xe8,"float"]
	global $Atrib_Dodge_Chance_Bonus[2] = [0xe9,"float"]
	global $Atrib_Dodge_Chance_Bonus_Melee[2] = [0xea,"float"]
	global $Atrib_Dodge_Chance_Bonus_Ranged[2] = [0xeb,"float"]
	global $Atrib_Get_Hit_Current[2] = [0xec,"float"]
	global $Atrib_Get_Hit_Max_Base[2] = [0xed,"float"]
	global $Atrib_Get_Hit_Max_Per_Level[2] = [0xee,"float"]
	global $Atrib_Get_Hit_Max[2] = [0xef,"float"]
	global $Atrib_Get_Hit_Recovery_Base[2] = [0xf0,"float"]
	global $Atrib_Get_Hit_Recovery_Per_Level[2] = [0xf1,"float"]
	global $Atrib_Get_Hit_Recovery[2] = [0xf2,"float"]
	global $Atrib_Get_Hit_Damage[2] = [0xf3,"float"]
	global $Atrib_Get_Hit_Damage_Scalar[2] = [0xf4,"float"]
	global $Atrib_Last_Damage_MainActor[2] = [0xf5,"int"]
	global $Atrib_Last_ACD_Attacked[2] = [0xf6,"int"]
	global $Atrib_Ignores_Critical_Hits[2] = [0xf7,"int"]
	global $Atrib_Immunity[2] = [0xf8,"int"]
	global $Atrib_Untargetable[2] = [0xf9,"int"]
	global $Atrib_Immobolize[2] = [0xfa,"int"]
	global $Atrib_Immune_To_Knockback[2] = [0xfb,"int"]
	global $Atrib_Power_Immobilize[2] = [0xfc,"int"]
	global $Atrib_Stun_Chance[2] = [0xfd,"float"]
	global $Atrib_Stun_Length[2] = [0xfe,"float"]
	global $Atrib_Stun_Recovery[2] = [0xff,"float"]
	global $Atrib_Stun_Recovery_Speed[2] = [0x100,"float"]
	global $Atrib_Stunned[2] = [0x101,"int"]
	global $Atrib_Stun_Immune[2] = [0x102,"int"]
	global $Atrib_Poison_Length_Reduction[2] = [0x103,"float"]
	global $Atrib_Poisoned[2] = [0x104,"int"]
	global $Atrib_Bleeding[2] = [0x105,"int"]
	global $Atrib_Bleed_Duration[2] = [0x106,"float"]
	global $Atrib_Chilled[2] = [0x107,"int"]
	global $Atrib_Freeze_Length_Reduction[2] = [0x108,"float"]
	global $Atrib_Freeze_Immune[2] = [0x109,"int"]
	global $Atrib_Webbed[2] = [0x10a,"int"]
	global $Atrib_Slow[2] = [0x10b,"int"]
	global $Atrib_FireAura[2] = [0x10c,"int"]
	global $Atrib_LightningAura[2] = [0x10d,"int"]
	global $Atrib_ColdAura[2] = [0x10e,"int"]
	global $Atrib_PoisonAura[2] = [0x10f,"int"]
	global $Atrib_Blind[2] = [0x110,"int"]
	global $Atrib_Enraged[2] = [0x111,"int"]
	global $Atrib_Slowdown_Immune[2] = [0x112,"int"]
	global $Atrib_Gethit_Immune[2] = [0x113,"int"]
	global $Atrib_Suffocation_Per_Second[2] = [0x114,"float"]
	global $Atrib_Suffocation_Unit_Value[2] = [0x115,"float"]
	global $Atrib_Thorns_Percent[2] = [0x116,"float"]
	global $Atrib_Thorns_Percent_All[2] = [0x117,"float"]
	global $Atrib_Thorns_Percent_Total[2] = [0x118,"float"]
	global $Atrib_Thorns_Fixed[2] = [0x119,"float"]
	global $Atrib_Steal_Health_Percent[2] = [0x11a,"float"]
	global $Atrib_Steal_Mana_Percent[2] = [0x1b,"float"]
	global $Atrib_Resource_On_Hit[2] = [0x11c,"float"]
	global $Atrib_Resource_On_Kill[2] = [0x11d,"float"]
	global $Atrib_Resource_On_Crit[2] = [0x11e,"float"]
	global $Atrib_Hitpoints_On_Hit[2] = [0x11f,"float"]
	global $Atrib_Hitpoints_On_Kill[2] = [0x120,"float"]
	global $Atrib_Damage_To_Mana[2] = [0x121,"float"]
	global $Atrib_Last_Proc_Time[2] = [0x122,"int"]
	global $Atrib_Damage_Power_Delta[2] = [0x123,"float"]
	global $Atrib_Damage_Power_Min[2] = [0x124,"float"]
	global $Atrib_Rope_Overlay[2] = [0x125,"int"]
	global $Atrib_General_Cooldown[2] = [0x126,"int"]
	global $Atrib_Power_Cooldown[2] = [0x127,"int"]
	global $Atrib_Power_Cooldown_Start[2] = [0x128,"int"]
	global $Atrib_Proc_Cooldown[2] = [0x129,"int"]
	global $Atrib_Emote_Cooldown[2] = [0x12a,"int"]
	global $Atrib_Projectile_Speed[2] = [0x12b,"float"]
	global $Atrib_Projectile_Speed_Increase_Percent[2] = [0x12c,"float"]
	global $Atrib_Destroy_When_Path_Blocked[2] = [0x12d,"int"]
	global $Atrib_Skill_Toggled_State[2] = [0x12e,"int"]
	global $Atrib_Act[2] = [0x12f,"int"]
	global $Atrib_Difficulty[2] = [0x130,"int"]
	global $Atrib_Last_Damage_Amount[2] = [0x131,"float"]
	global $Atrib_In_Knockback[2] = [0x132,"int"]
	global $Atrib_Amplify_Damage_Type_Percent[2] = [0x133,"float"]
	global $Atrib_Amplify_Damage_Percent[2] = [0x134,"float"]
	global $Atrib_Durability_Cur[2] = [0x135,"int"]
	global $Atrib_Durability_Max[2] = [0x136,"int"]
	global $Atrib_Durability_Last_Damage[2] = [0x137,"int"]
	global $Atrib_Item_Quality_Level[2] = [0x138,"int"]
	global $Atrib_Item_Cost_Percent_Bonus[2] = [0x13a,"float"]
	global $Atrib_Item_Equipped[2] = [0x13b,"int"]
	global $Atrib_Requirement[2] = [0x13c,"float"]
	global $Atrib_Requirements_Ease_Percent[2] = [0x13d,"float"]
	global $Atrib_Requirement_When_Equipped[2] = [0x13e,"float"]
	global $Atrib_Sockets[2] = [0x13f,"int"]
	global $Atrib_Sockets_Filled[2] = [0x140,"int"]
	global $Atrib_Stats_All_Bonus[2] = [0x141,"float"]
	global $Atrib_Item_Bound_To_ACD[2] = [0x142,"int"]
	global $Atrib_Item_Locked_To_ACD[2] = [0x143,"int"]
	global $Atrib_Item_Binding_Level_Override[2] = [0x144,"int"]
	global $Atrib_ItemStackQuantityHi[2] = [0x145,"int"]
	global $Atrib_ItemStackQuantityLo[2] = [0x146,"int"]
	global $Atrib_Run_Speed_Granted[2] = [0x147,"float"]
	global $Atrib_Run_Speed_Duration[2] = [0x148,"int"]
	global $Atrib_IdentifyCost[2] = [0x149,"int"]
	global $Atrib_Seed[2] = [0x14a,"int"]
	global $Atrib_IsCrafted[2] = [0x14b,"int"]
	global $Atrib_DyeType[2] = [0x14c,"int"]
	global $Atrib_EnchantAffix[2] = [0x14d,"int"]
	global $Atrib_EnchantRangeVal[2] = [0x14e,"int"]
	global $Atrib_HighlySalvageable[2] = [0x14f,"int"]
	global $Atrib_ItemUnlockTimeHi[2] = [0x150,"int"]
	global $Atrib_ItemUnlockTimeLo[2] = [0x151,"int"]
	global $Atrib_Always_Plays_GetHit[2] = [0x152,"int"]
	global $Atrib_Hidden[2] = [0x153,"int"]
	global $Atrib_RActor_Fade_Group[2] = [0x154,"int"]
	global $Atrib_Quest_Range[2] = [0x155,"int"]
	global $Atrib_Attack_Cooldown_Min[2] = [0x156,"int"]
	global $Atrib_Attack_Cooldown_Delta[2] = [0x157,"int"]
	global $Atrib_InitialCooldownMinTotal[2] = [0x158,"int"]
	global $Atrib_InitialCooldownDeltaTotal[2] = [0x159,"int"]
	global $Atrib_Attack_Cooldown_Min_Total[2] = [0x15a,"int"]
	global $Atrib_Attack_Cooldown_Delta_Total[2] = [0x15b,"int"]
	global $Atrib_Closing_Cooldown_Min_Total[2] = [0x15c,"int"]
	global $Atrib_Closing_Cooldown_Delta_Total[2] = [0x15d,"int"]
	global $Atrib_Quest_Monster[2] = [0x15e,"int"]
	global $Atrib_Quest_Monster_Effect[2] = [0x15f,"int"]
	global $Atrib_Treasure_Class[2] = [0x160,"int"]
	global $Atrib_Removes_Body_On_Death[2] = [0x161,"int"]
	global $Atrib_InitialCooldownMin[2] = [0x162,"int"]
	global $Atrib_InitialCooldownDelta[2] = [0x163,"int"]
	global $Atrib_Knockback_Weight[2] = [0x164,"float"]
	global $Atrib_UntargetableByPets[2] = [0x165,"int"]
	global $Atrib_Damage_State_Current[2] = [0x166,"int"]
	global $Atrib_Damage_State_Max[2] = [0x167,"int"]
	global $Atrib_Is_Player_Decoy[2] = [0x168,"int"]
	global $Atrib_Custom_Target_Weight[2] = [0x169,"float"]
	global $Atrib_Gizmo_State[2] = [0x16a,"int"]
	global $Atrib_Gizmo_Charges[2] = [0x61b,"int"]
	global $Atrib_Chest_Open[2] = [0x16c,"int"]
	global $Atrib_Door_Locked[2] = [0x16d,"int"]
	global $Atrib_Door_Timer[2] = [0x16e,"int"]
	global $Atrib_Gizmo_Disabled_By_Script[2] = [0x16f,"int"]
	global $Atrib_Gizmo_Operator_ACDID[2] = [0x170,"int"]
	global $Atrib_Triggering_Count[2] = [0x171,"int"]
	global $Atrib_Gate_Position[2] = [0x172,"float"]
	global $Atrib_Gate_Velocity[2] = [0x173,"float"]
	global $Atrib_Gizmo_Has_Been_Operated[2] = [0x174,"int"]
	global $Atrib_Pet_Owner[2] = [0x175,"int"]
	global $Atrib_Pet_Creator[2] = [0x176,"int"]
	global $Atrib_Pet_Type[2] = [0x177,"int"]
	global $Atrib_DropsNoLoot[2] = [0x178,"int"]
	global $Atrib_GrantsNoXP[2] = [0x179,"int"]
	global $Atrib_Hireling_Class[2] = [0x17a,"int"]
	global $Atrib_Summoned_By_SNO[2] = [0x17b,"int"]
	global $Atrib_Is_NPC[2] = [0x17c,"int"]
	global $Atrib_NPC_Is_Operatable[2] = [0x17d,"int"]
	global $Atrib_NPC_Is_Escorting[2] = [0x17e,"int"]
	global $Atrib_NPC_Has_Interact_Options[2] = [0x17f,"int"]
	global $Atrib_Conversation_Icon[2] = [0x180,"int"]
	global $Atrib_Callout_Cooldown[2] = [0x181,"int"]
	global $Atrib_Banter_Cooldown[2] = [0x182,"int"]
	global $Atrib_Conversation_Heard_Count[2] = [0x183,"int"]
	global $Atrib_Last_Tick_Shop_Entered[2] = [0x184,"int"]
	global $Atrib_Is_Helper[2] = [0x185,"int"]
	global $Atrib_Axe[2] = [0x186,"float"]
	global $Atrib_Axe2H[2] = [0x187,"float"]
	global $Atrib_ThrowingAxe[2] = [0x188,"float"]
	global $Atrib_AxeAny[2] = [0x189,"float"]
	global $Atrib_Bow[2] = [0x18a,"float"]
	global $Atrib_Crossbow[2] = [0x18b,"float"]
	global $Atrib_BowAny[2] = [0x18c,"float"]
	global $Atrib_Club[2] = [0x18d,"float"]
	global $Atrib_Club2H[2] = [0x18e,"float"]
	global $Atrib_ClubAny[2] = [0x18f,"float"]
	global $Atrib_Dagger[2] = [0x17E,"float"]
	global $Atrib_Mace[2] = [0x17F,"float"]
	global $Atrib_Mace2H[2] = [0x180,"float"]
	global $Atrib_MaceAny[2] = [0x181,"float"]
	global $Atrib_Sword[2] = [0x182,"float"]
	global $Atrib_Sword2H[2] = [0x183,"float"]
	global $Atrib_SwordAny[2] = [0x184,"float"]
	global $Atrib_Polearm[2] = [0x185,"float"]
	global $Atrib_Spear[2] = [0x186,"float"]
	global $Atrib_Wand[2] = [0x187,"float"]
	global $Atrib_ColdStaff[2] = [0x188,"float"]
	global $Atrib_FireStaff[2] = [0x189,"float"]
	global $Atrib_LightningStaff[2] = [0x18A,"float"]
	global $Atrib_PoisonStaff[2] = [0x18B,"float"]
	global $Atrib_StaffAny[2] = [0x18C,"float"]
	global $Atrib_Weapon1H[2] = [0x18D,"float"]
	global $Atrib_Weapon2H[2] = [0x18E,"float"]
	global $Atrib_WeaponMelee[2] = [0x18F,"float"]
	global $Atrib_WeaponRanged[2] = [0x190,"float"]
	global $Atrib_Quiver[2] = [0x191,"float"]
	global $Atrib_Reincarnation_Buff[2] = [0x192,"int"]
	global $Atrib_Dead_Body_AnimTag[2] = [0x193,"int"]
	global $Atrib_Spawned_by_ACDID[2] = [0x194,"int"]
	global $Atrib_Summoned_By_ACDID[2] = [0x195,"int"]
	global $Atrib_Summoner_ID[2] = [0x196,"int"]
	global $Atrib_Banner_ACDID[2] = [0x197,"int"]
	global $Atrib_Breakable_Shield_HP[2] = [0x198,"float"]
	global $Atrib_Current_WeaponClass[2] = [0x199,"int"]
	global $Atrib_Weapons_Sheathed[2] = [0x19A,"int"]
	global $Atrib_Held_In_OffHand[2] = [0x19B,"int"]
	global $Atrib_Attacks_Per_Second_Item_MainHand[2] = [0x19C,"float"]
	global $Atrib_Attacks_Per_Second_Item_OffHand[2] = [0x19D,"float"]
	global $Atrib_Attacks_Per_Second_Item_Total_MainHand[2] = [0x19E,"float"]
	global $Atrib_Attacks_Per_Second_Item_Total_OffHand[2] = [0x19F,"float"]
	global $Atrib_Damage_Weapon_Min_Total_MainHand[2] = [0x1A0,"float"]
	global $Atrib_Damage_Weapon_Min_Total_OffHand[2] = [0x1A1,"float"]
	global $Atrib_Damage_Weapon_Delta_Total_MainHand[2] = [0x1A2,"float"]
	global $Atrib_Damage_Weapon_Delta_Total_OffHand[2] = [0x1A3,"float"]
	global $Atrib_Attacks_Per_Second_Item_CurrentHand[2] = [0x1A4,"float"]
	global $Atrib_Damage_Weapon_Min_Total_CurrentHand[2] = [0x1A5,"float"]
	global $Atrib_Damage_Weapon_Delta_Total_CurrentHand[2] = [0x1A6,"float"]
	global $Atrib_Has_Special_Death_AnimTag[2] = [0x1A7,"int"]
	global $Atrib_Death_Type_Override[2] = [0x1A8,"int"]
	global $Atrib_In_Combat[2] = [0x1A9,"int"]
	global $Atrib_In_Conversation[2] = [0x1AA,"int"]
	global $Atrib_Last_Tick_Potion_Used[2] = [0x1AB,"int"]
	global $Atrib_Potion_Dilution_Percent[2] = [0x1AC,"float"]
	global $Atrib_Out_Of_Combat_Health_Regen_Percent[2] = [0x1AD,"float"]
	global $Atrib_Out_Of_Combat_Mana_Regen_Percent[2] = [0x1AE,"float"]
	global $Atrib_Potion_Dilution_Duration[2] = [0x1AF,"int"]
	global $Atrib_Potion_Dilution_Scalar[2] = [0x1B0,"float"]
	global $Atrib_Feared[2] = [0x1B1,"int"]
	global $Atrib_Fear_Immune[2] = [0x1B2,"int"]
	global $Atrib_Last_Damage_ACD[2] = [0x1B3,"int"]
	global $Atrib_Attached_To_ACD[2] = [0x1B4,"int"]
	global $Atrib_Attachment_ACD[2] = [0x1B5,"int"]
	global $Atrib_Normal_Attack_Replacement_Power_SNO[2] = [0x1B6,"int"]
	global $Atrib_Damage_Type_Override[2] = [0x1B7,"float"]
	global $Atrib_Minion_Count_Bonus_Percent[2] = [0x1B8,"float"]
	global $Atrib_Champion_Teleport_Next_Tick[2] = [0x1B9,"int"]
	global $Atrib_Champion_Teleport_Time_Min_In_Seconds[2] = [0x1BA,"float"]
	global $Atrib_Champion_Teleport_Time_Delta_In_Seconds[2] = [0x1BB,"float"]
	global $Atrib_Champion_Clone_Next_Tick[2] = [0x1BC,"int"]
	global $Atrib_Champion_Clone_Time_Min_In_Seconds[2] = [0x1BD,"float"]
	global $Atrib_Champion_Clone_Time_Delta_In_Seconds[2] = [0x1BE,"float"]
	global $Atrib_Champion_Clone_Hitpoint_Bonus_Percent[2] = [0x1BF,"float"]
	global $Atrib_Champion_Clone_Damage_Bonus_Percent[2] = [0x1C0,"float"]
	global $Atrib_Champion_Ghostly_Next_Tick[2] = [0x1C1,"int"]
	global $Atrib_Champion_Ghostly_Inactive_Time_Min_In_Seconds[2] = [0x1C2,"float"]
	global $Atrib_Champion_Ghostly_Inactive_Time_Delta_In_Seconds[2] = [0x1C3,"float"]
	global $Atrib_Champion_Ghostly_Active_Time_Min_In_Seconds[2] = [0x1C4,"float"]
	global $Atrib_Champion_Ghostly_Active_Time_Delta_In_Seconds[2] = [0x1C5,"float"]
	global $Atrib_Champion_Ghostly_Saved_Dodge_Chance[2] = [0x1C6,"float"]
	global $Atrib_Champion_Ghostly[2] = [0x1C7,"int"]
	global $Atrib_Base_Element[2] = [0x1C8,"int"]
	global $Atrib_Projectile_Amount_Bonus_Percent[2] = [0x1C9,"float"]
	global $Atrib_Projectile_Reflect_Chance[2] = [0x1CA,"float"]
	global $Atrib_Attack_Fear_Chance[2] = [0x1CB,"float"]
	global $Atrib_Attack_Fear_Time_Min[2] = [0x1CC,"float"]
	global $Atrib_Attack_Fear_Time_Delta[2] = [0x1CD,"float"]
	global $Atrib_Buff_Visual_Effect[2] = [0x1CE,"int"]
	global $Atrib_Buff_Icon_Start_Tick0[2] = [0x1CF,"int"]
	global $Atrib_Buff_Icon_Start_Tick1[2] = [0x1D0,"int"]
	global $Atrib_Buff_Icon_Start_Tick2[2] = [0x1D1,"int"]
	global $Atrib_Buff_Icon_Start_Tick3[2] = [0x1D2,"int"]
	global $Atrib_Buff_Icon_Start_Tick4[2] = [0x1D3,"int"]
	global $Atrib_Buff_Icon_Start_Tick5[2] = [0x1D4,"int"]
	global $Atrib_Buff_Icon_Start_Tick6[2] = [0x1D5,"int"]
	global $Atrib_Buff_Icon_Start_Tick7[2] = [0x1D6,"int"]
	global $Atrib_Buff_Icon_End_Tick0[2] = [0x1D7,"int"]
	global $Atrib_Buff_Icon_End_Tick1[2] = [0x1D8,"int"]
	global $Atrib_Buff_Icon_End_Tick2[2] = [0x1D9,"int"]
	global $Atrib_Buff_Icon_End_Tick3[2] = [0x1DA,"int"]
	global $Atrib_Buff_Icon_End_Tick4[2] = [0x1DB,"int"]
	global $Atrib_Buff_Icon_End_Tick5[2] = [0x1DC,"int"]
	global $Atrib_Buff_Icon_End_Tick6[2] = [0x1DD,"int"]
	global $Atrib_Buff_Icon_End_Tick7[2] = [0x1DE,"int"]
	global $Atrib_Could_Have_Ragdolled[2] = [0x1DF,"int"]
	global $Atrib_Ambient_Damage_Effect_Last_Time[2] = [0x1E0,"int"]
	global $Atrib_Scale_Bonus[2] = [0x1E1,"float"]
	global $Atrib_Deleted_On_Server[2] = [0x1E2,"int"]
	global $Atrib_Scripted_Fade_Time[2] = [0x1E3,"int"]
	global $Atrib_Does_No_Damage[2] = [0x1E4,"int"]
	global $Atrib_Does_Fake_Damage[2] = [0x1E5,"int"]
	global $Atrib_SlowTime_Debuff[2] = [0x1E6,"float"]
	global $Atrib_Blocks_Projectiles[2] = [0x1E7,"int"]
	global $Atrib_Frozen[2] = [0x1E8,"int"]
	global $Atrib_Freeze_Damage_Percent_Bonus[2] = [0x1E9,"float"]
	global $Atrib_Buff_Active[2] = [0x1EA,"int"]
	global $Atrib_DualWield_BothAttack_Chance[2] = [0x1EB,"float"]
	global $Atrib_Summon_Expiration_Tick[2] = [0x1EC,"int"]
	global $Atrib_Summon_Count[2] = [0x1ED,"int"]
	global $Atrib_Uninterruptible[2] = [0x1EE,"int"]
	global $Atrib_Queue_Death[2] = [0x1EF,"int"]
	global $Atrib_CantStartDisplayedPowers[2] = [0x1F0,"int"]
	global $Atrib_Wizard_Slowtime_Proxy_ACD[2] = [0x1F1,"int"]
	global $Atrib_DPS[2] = [0x1F2,"float"]
	global $Atrib_Resurrection_Power[2] = [0x1F3,"int"]
	global $Atrib_Freeze_Damage[2] = [0x1F4,"float"]
	global $Atrib_Freeze_Capacity[2] = [0x1F5,"float"]
	global $Atrib_Thaw_Rate[2] = [0x1F6,"float"]
	global $Atrib_Chilled_Dur_Bonus_Percent[2] = [0x1F7,"float"]
	global $Atrib_DOT_DPS[2] = [0x1F8,"float"]
	global $Atrib_DamageCap_Percent[2] = [0x1F9,"float"]
	global $Atrib_Item_Time_Sold[2] = [0x1FA,"int"]
	global $Atrib_Forced_Hireling_Power[2] = [0x1FB,"int"]
	global $Atrib_IsRooted[2] = [0x1FC,"int"]
	global $Atrib_RootTargetACD[2] = [0x1FD,"int"]
	global $Atrib_RootAutoDecayPerSecond[2] = [0x1FE,"float"]
	global $Atrib_RootUnitValue[2] = [0x1FF,"float"]
	global $Atrib_RootTotalTicks[2] = [0x200,"int"]
	global $Atrib_Hide_Affixes[2] = [0x201,"int"]
	global $Atrib_Rune_A[2] = [0x202,"int"]
	global $Atrib_Rune_B[2] = [0x203,"int"]
	global $Atrib_Rune_C[2] = [0x204,"int"]
	global $Atrib_Rune_D[2] = [0x205,"int"]
	global $Atrib_Rune_E[2] = [0x206,"int"]
	global $Atrib_Resistance_Stun[2] = [0x207,"float"]
	global $Atrib_Resistance_Stun_Total[2] = [0x208,"float"]
	global $Atrib_Resistance_Root[2] = [0x209,"float"]
	global $Atrib_Resistance_Root_Total[2] = [0x20A,"float"]
	global $Atrib_Resistance_Freeze[2] = [0x20B,"float"]
	global $Atrib_Resistance_Freeze_Total[2] = [0x20C,"float"]
	global $Atrib_Resistance_StunRootFreeze[2] = [0x20D,"float"]
	global $Atrib_CrowdControl_Reduction[2] = [0x20E,"float"]
	global $Atrib_Displays_Team_Effect[2] = [0x20F,"int"]
	global $Atrib_Cannot_Be_Added_To_AI_Target_List[2] = [0x210,"int"]
	global $Atrib_SkillKit[2] = [0x211,"int"]
	global $Atrib_Immune_To_Charm[2] = [0x212,"int"]
	global $Atrib_Immune_To_Blind[2] = [0x213,"int"]
	global $Atrib_Damage_Shield[2] = [0x214,"int"]
	global $Atrib_Silenced[2] = [0x215,"int"]
	global $Atrib_Diseased[2] = [0x216,"int"]
	global $Atrib_Guard_Object_ACDID[2] = [0x217,"int"]
	global $Atrib_Follow_Target_ACDID[2] = [0x218,"int"]
	global $Atrib_Follow_Target_Type[2] = [0x219,"int"]
	global $Atrib_Forced_Enemy_ACDID[2] = [0x21A,"int"]
	global $Atrib_NPC_Talk_Target_ANN[2] = [0x21B,"int"]
	global $Atrib_NPC_Conv_Target_ANN[2] = [0x21C,"int"]
	global $Atrib_Script_Target_ACDID[2] = [0x21D,"int"]
	global $Atrib_Look_Target_Server_ANN[2] = [0x21E,"int"]
	global $Atrib_Look_Target_Broadcast_Intensity[2] = [0x21F,"float"]
	global $Atrib_Look_Target_Broadcast_Radius[2] = [0x220,"float"]
	global $Atrib_Stealthed[2] = [0x221,"int"]
	global $Atrib_GemQuality[2] = [0x222,"int"]
	global $Atrib_ItemBuffIcon[2] = [0x223,"int"]
	global $Atrib_ScrollDuration[2] = [0x224,"float"]
	global $Atrib_Gizmo_Actor_SNO_To_Spawn[2] = [0x225,"int"]
	global $Atrib_Gizmo_Actor_To_Spawn_Scale[2] = [0x226,"float"]
	global $Atrib_Death_Replacement_Power_SNO[2] = [0x227,"int"]
	global $Atrib_Attachment_Handled_By_Client[2] = [0x228,"int"]
	global $Atrib_AI_In_Special_State[2] = [0x229,"int"]
	global $Atrib_AI_Used_Scripted_Spawn_Anim[2] = [0x22A,"int"]
	global $Atrib_AI_Spawned_By_Inactive_Marker[2] = [0x22B,"int"]
	global $Atrib_Headstone_Player_ANN[2] = [0x22C,"int"]
	global $Atrib_Resource_Cost_Reduction_Percent[2] = [0x22D,"float"]
	global $Atrib_Resistance_Penetration[2] = [0x22E,"float"]
	global $Atrib_Resistance_Penetration_Total[2] = [0x22F,"float"]
	global $Atrib_Resistance_Penetration_All[2] = [0x230,"float"]
	global $Atrib_Resistance_Penetration_Percent_All[2] = [0x231,"float"]
	global $Atrib_Fury_Effect_Level[2] = [0x232,"int"]
	global $Atrib_Health_Potion_Bonus_Heal_Percent[2] = [0x233,"float"]
	global $Atrib_Free_Cast[2] = [0x234,"int"]
	global $Atrib_Free_Cast_All[2] = [0x235,"int"]
	global $Atrib_Movement_Scalar_Reduction_Percent[2] = [0x236,"float"]
	global $Atrib_Movement_Scalar_Reduction_Resistance[2] = [0x237,"float"]
	global $Atrib_Damage_Absorb_Percent_All[2] = [0x238,"float"]
	global $Atrib_World_Seed[2] = [0x239,"int"]
	global $Atrib_Kill_Count_Record[2] = [0x23A,"int"]
	global $Atrib_Object_Destruction_Record[2] = [0x23B,"int"]
	global $Atrib_Single_Attack_Record[2] = [0x23C,"int"]
	global $Atrib_Environment_Attack_Record[2] = [0x23D,"int"]
	global $Atrib_Root_Immune[2] = [0x23E,"int"]
	global $Atrib_Monster_Play_Get_Hit_Bonus[2] = [0x23F,"float"]
	global $Atrib_Stored_Contact_Frame[2] = [0x240,"int"]
	global $Atrib_Buff_Icon_Count0[2] = [0x241,"int"]
	global $Atrib_Buff_Icon_Count1[2] = [0x242,"int"]
	global $Atrib_Buff_Icon_Count2[2] = [0x243,"int"]
	global $Atrib_Buff_Icon_Count3[2] = [0x244,"int"]
	global $Atrib_Buff_Icon_Count4[2] = [0x245,"int"]
	global $Atrib_Buff_Icon_Count5[2] = [0x246,"int"]
	global $Atrib_Buff_Icon_Count6[2] = [0x247,"int"]
	global $Atrib_Buff_Icon_Count7[2] = [0x248,"int"]
	global $Atrib_Observer[2] = [0x249,"int"]
	global $Atrib_Resurrect_As_Observer[2] = [0x24A,"int"]
	global $Atrib_Combo_Level[2] = [0x24B,"int"]
	global $Atrib_Combo_Time_Last_Move[2] = [0x24C,"int"]
	global $Atrib_Burrowed[2] = [0x24D,"int"]
	global $Atrib_Death_Replacement_Effect_Group_SNO[2] = [0x24E,"int"]
	global $Atrib_Checkpoint_Resurrection_Allowed_Game_Time[2] = [0x24F,"int"]
	global $Atrib_Checkpoint_Resurrection_Forced_Game_Time[2] = [0x250,"int"]
	global $Atrib_Controlling_TimedEvent_SNO[2] = [0x251,"int"]
	global $Atrib_Casting_Speed_Percent[2] = [0x252,"float"]
	global $Atrib_Using_Bossbar[2] = [0x253,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect[2] = [0x254,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect[2] = [0x255,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect[2] = [0x256,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect[2] = [0x257,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect[2] = [0x258,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect[2] = [0x259,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect[2] = [0x25A,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect[2] = [0x25B,"int"]
	global $Atrib_Store_SNO[2] = [0x25C,"int"]
	global $Atrib_Busy[2] = [0x25D,"int"]
	global $Atrib_Afk[2] = [0x25E,"int"]
	global $Atrib_Last_Action_Timestamp[2] = [0x25F,"int"]
	global $Atrib_Portal_Next_Time[2] = [0x260,"int"]
	global $Atrib_Repair_Discount_Percent[2] = [0x261,"float"]
	global $Atrib_Resource_Degeneration_Prevented[2] = [0x262,"int"]
	global $Atrib_Operatable[2] = [0x263,"int"]
	global $Atrib_Look_Override[2] = [0x264,"int"]
	global $Atrib_Spawner_Concurrent_Count_ID[2] = [0x265,"int"]
	global $Atrib_Disabled[2] = [0x266,"int"]
	global $Atrib_Skill_Override[2] = [0x267,"int"]
	global $Atrib_Skill_Override_Active[2] = [0x268,"int"]
	global $Atrib_Skill_Override_Ended[2] = [0x269,"int"]
	global $Atrib_Skill_Override_Ended_Active[2] = [0x26A,"int"]
	global $Atrib_Is_Power_Proxy[2] = [0x26B,"int"]
	global $Atrib_Force_No_Death_Animation[2] = [0x26C,"int"]
	global $Atrib_Player_WeaponClass_Anim_Override[2] = [0x26D,"int"]
	global $Atrib_Operatable_Story_Gizmo[2] = [0x26E,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect_None[2] = [0x26F,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect_A[2] = [0x270,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect_B[2] = [0x271,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect_C[2] = [0x272,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect_D[2] = [0x273,"int"]
	global $Atrib_Power_Buff_0_Visual_Effect_E[2] = [0x274,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect_None[2] = [0x275,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect_A[2] = [0x276,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect_B[2] = [0x277,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect_C[2] = [0x278,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect_D[2] = [0x279,"int"]
	global $Atrib_Power_Buff_1_Visual_Effect_E[2] = [0x27A,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect_None[2] = [0x27B,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect_A[2] = [0x27C,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect_B[2] = [0x27D,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect_C[2] = [0x27E,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect_D[2] = [0x27F,"int"]
	global $Atrib_Power_Buff_2_Visual_Effect_E[2] = [0x280,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect_None[2] = [0x281,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect_A[2] = [0x282,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect_B[2] = [0x283,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect_C[2] = [0x284,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect_D[2] = [0x285,"int"]
	global $Atrib_Power_Buff_3_Visual_Effect_E[2] = [0x286,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect_None[2] = [0x287,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect_A[2] = [0x288,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect_B[2] = [0x289,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect_C[2] = [0x28A,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect_D[2] = [0x28B,"int"]
	global $Atrib_Power_Buff_4_Visual_Effect_E[2] = [0x28C,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect_None[2] = [0x28D,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect_A[2] = [0x28E,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect_B[2] = [0x28F,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect_C[2] = [0x290,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect_D[2] = [0x291,"int"]
	global $Atrib_Power_Buff_5_Visual_Effect_E[2] = [0x292,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect_None[2] = [0x293,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect_A[2] = [0x294,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect_B[2] = [0x295,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect_C[2] = [0x296,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect_D[2] = [0x297,"int"]
	global $Atrib_Power_Buff_6_Visual_Effect_E[2] = [0x298,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect_None[2] = [0x299,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect_A[2] = [0x29A,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect_B[2] = [0x29B,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect_C[2] = [0x29C,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect_D[2] = [0x29D,"int"]
	global $Atrib_Power_Buff_7_Visual_Effect_E[2] = [0x29E,"int"]
	global $Atrib_Walk_Passability_Power_SNO[2] = [0x29F,"int"]
	global $Atrib_Passability_Power_SNO[2] = [0x2A0,"int"]
	global $Atrib_Flippy_ID[2] = [0x2A1,"int"]
	global $Atrib_Summoning_Machine_Num_Casters[2] = [0x2A2,"int"]
	global $Atrib_Summoning_Machine_Spawn_Count[2] = [0x2A3,"int"]
	global $Atrib_Summoning_Machine_Next_Spawn_Ticks[2] = [0x2A4,"int"]
	global $Atrib_Summoning_Machine_Spawn_Team[2] = [0x2A5,"int"]
	global $Atrib_Screen_Attack_Radius_Constant[2] = [0x2A6,"float"]
	global $Atrib_Damage_Done_Reduction_Percent[2] = [0x2A7,"float"]
	global $Atrib_Set_Item_Count[2] = [0x2A8,"int"]
	global $Atrib_Spawner_Countdown_Percent[2] = [0x2A9,"float"]
	global $Atrib_Attack_Slow[2] = [0x2AA,"int"]
	global $Atrib_Power_Disabled[2] = [0x2AB,"int"]
	global $Atrib_Weapon_Effect_Override[2] = [0x2AC,"int"]
	global $Atrib_Debuff_Duration_Reduction_Percent[2] = [0x2AD,"float"]
	global $Atrib_Uses_PvP_Power_Tags[2] = [0x2AE,"int"]
	global $Atrib_Trait[2] = [0x2AF,"int"]
	global $Atrib_Last_ACD_Attacked_By[2] = [0x2B0,"int"]
	global $Atrib_Gold_PickUp_Radius[2] = [0x2B1,"float"]
	global $Atrib_Client_Only_Effect[2] = [0x2B2,"int"]
	global $Atrib_Has_Doppelganger_Cloned[2] = [0x2B3,"int"]
	global $Atrib_Resource_Gain_Bonus_Percent[2] = [0x2B4,"float"]
	global $Atrib_Looping_Animation_Start_Time[2] = [0x2B5,"int"]
	global $Atrib_Looping_Animation_End_Time[2] = [0x2B6,"int"]
	global $Atrib_Looping_Animation_Suppress_Item_Tooltips[2] = [0x2B7,"int"]
	global $Atrib_Heal_Effect_Last_Played_Tick[2] = [0x2B8,"int"]
	global $Atrib_Resource_Effect_Last_Played_tick[2] = [0x2B9,"int"]
	global $Atrib_Thorns_Effect_Last_Played_tick[2] = [0x2BA,"int"]
	global $Atrib_PVP_Kills[2] = [0x2BB,"int"]
	global $Atrib_PVP_Deaths[2] = [0x2BC,"int"]
	global $Atrib_PVP_Assists[2] = [0x2BD,"int"]
	global $Atrib_PVP_Progression_Points_Gained[2] = [0x2BE,"int"]
	global $Atrib_PVP_Current_Kill_Streak[2] = [0x2BF,"int"]
	global $Atrib_PVP_Current_Death_Streak[2] = [0x2C0,"int"]
	global $Atrib_PVP_Longest_Kill_Streak[2] = [0x2C1,"int"]
	global $Atrib_PVP_Longest_Death_Streak[2] = [0x2C2,"int"]
	global $Atrib_Turn_Rate_Scalar[2] = [0x2C3,"float"]
	global $Atrib_Turn_Accel_Scalar[2] = [0x2C4,"float"]
	global $Atrib_Turn_Deccel_Scalar[2] = [0x2C5,"float"]
	global $Atrib_No_Health_Drop[2] = [0x2C6,"int"]
	global $Atrib_Leader[2] = [0x2C7,"int"]
	global $Atrib_IsContentRestrictedActor[2] = [0x2C8,"int"]
	global $Atrib_InBossEncounter[2] = [0x2C9,"int"]
	global $Atrib_God[2] = [0x2CA,"int"]
	global $Atrib_MinimapActive[2] = [0x2CB,"int"]
	global $Atrib_MinimapIconOverride[2] = [0x2CC,"int"]
	global $Atrib_MinimapDisableArrow[2] = [0x2CD,"int"]
	global $Atrib_Last_Blocked_ACD[2] = [0x2CE,"int"]
	global $Atrib_Last_Blocked_Time[2] = [0x2CF,"int"]
	global $Atrib_Deactivate_Lure[2] = [0x2D0,"int"]
	global $Atrib_Weapons_Hidden[2] = [0x2D1,"int"]
	global $Atrib_Actor_Updates_Attributes_From_Owner[2] = [0x2D2,"int"]
	global $Atrib_Taunt_Target_ACD[2] = [0x2D3,"int"]
	global $Atrib_UI_Only_Percent_Damage_Increase[2] = [0x2D4,"float"]
	global $Atrib_Projectile_Effect_SNO[2] = [0x2D5,"int"]
	global $Atrib_On_Hit_Fear_Proc_Chance[2] = [0x2D6,"float"]
	global $Atrib_On_Hit_Stun_Proc_Chance[2] = [0x2D7,"float"]
	global $Atrib_On_Hit_Blind_Proc_Chance[2] = [0x2D8,"float"]
	global $Atrib_On_Hit_Freeze_Proc_Chance[2] = [0x2D9,"float"]
	global $Atrib_On_Hit_Chill_Proc_Chance[2] = [0x2DA,"float"]
	global $Atrib_On_Hit_Slow_Proc_Chance[2] = [0x2DB,"float"]
	global $Atrib_On_Hit_Immobilize_Proc_Chance[2] = [0x2DC,"float"]
	global $Atrib_On_Hit_Knockback_Proc_Chance[2] = [0x2DD,"float"]
	global $Atrib_On_Hit_Bleed_Proc_Chance[2] = [0x2DE,"float"]
	global $Atrib_On_Hit_Bleed_Proc_Damage_Base[2] = [0x2DF,"float"]
	global $Atrib_On_Hit_Bleed_Proc_Damage_Delta[2] = [0x2E0,"float"]
	global $Atrib_Damage_Percent_Reduction_From_Ranged[2] = [0x2E1,"float"]
	global $Atrib_Damage_Percent_Reduction_From_Melee[2] = [0x2E2,"float"]
	global $Atrib_Damage_Percent_Reduction_Turns_Into_Heal[2] = [0x2E3,"float"]
	global $Atrib_Damage_Percent_Reduction_From_Elites[2] = [0x2E4,"float"]
	global $Atrib_Damage_Percent_Reduction_From_Type[2] = [0x2E5,"float"]
	global $Atrib_Damage_Percent_Bonus_Vs_Monster_Type[2] = [0x2E6,"float"]
	global $Atrib_Damage_Percent_Bonus_Vs_Elites[2] = [0x2E7,"float"]
	global $Atrib_Item_Manipulation_Timeout[2] = [0x2E8,"int"]
	global $Atrib_Picked_Up_Time[2] = [0x2E9,"int"]
	global $Atrib_Unequipped_Time[2] = [0x2EA,"int"]
	global $Atrib_Last_ACD_Killed_Time[2] = [0x2EB,"int"]
	global $Atrib_CannotDieDuring[2] = [0x2EC,"int"]
	global $Atrib_Weapon_On_Hit_Fear_Proc_Chance[2] = [0x2ED,"float"]
	global $Atrib_Weapon_On_Hit_Stun_Proc_Chance[2] = [0x2EE,"float"]
	global $Atrib_Weapon_On_Hit_Blind_Proc_Chance[2] = [0x2EF,"float"]
	global $Atrib_Weapon_On_Hit_Freeze_Proc_Chance[2] = [0x2F0,"float"]
	global $Atrib_Weapon_On_Hit_Chill_Proc_Chance[2] = [0x2F1,"float"]
	global $Atrib_Weapon_On_Hit_Slow_Proc_Chance[2] = [0x2F2,"float"]
	global $Atrib_Weapon_On_Hit_Immobilize_Proc_Chance[2] = [0x2F3,"float"]
	global $Atrib_Weapon_On_Hit_Knockback_Proc_Chance[2] = [0x2F4,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Chance[2] = [0x2F5,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Base[2] = [0x2F6,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Delta[2] = [0x2F7,"float"]
	global $Atrib_Weapon_On_Hit_Fear_Proc_Chance_MainHand[2] = [0x2F8,"float"]
	global $Atrib_Weapon_On_Hit_Fear_Proc_Chance_OffHand[2] = [0x2F9,"float"]
	global $Atrib_Weapon_On_Hit_Fear_Proc_Chance_CurrentHand[2] = [0x2FA,"float"]
	global $Atrib_Weapon_On_Hit_Stun_Proc_Chance_MainHand[2] = [0x2FB,"float"]
	global $Atrib_Weapon_On_Hit_Stun_Proc_Chance_OffHand[2] = [0x2FC,"float"]
	global $Atrib_Weapon_On_Hit_Stun_Proc_Chance_CurrentHand[2] = [0x2FD,"float"]
	global $Atrib_Weapon_On_Hit_Blind_Proc_Chance_MainHand[2] = [0x2FE,"float"]
	global $Atrib_Weapon_On_Hit_Blind_Proc_Chance_OffHand[2] = [0x2FF,"float"]
	global $Atrib_Weapon_On_Hit_Blind_Proc_Chance_CurrentHand[2] = [0x300,"float"]
	global $Atrib_Weapon_On_Hit_Freeze_Proc_Chance_MainHand[2] = [0x301,"float"]
	global $Atrib_Weapon_On_Hit_Freeze_Proc_Chance_OffHand[2] = [0x302,"float"]
	global $Atrib_Weapon_On_Hit_Freeze_Proc_Chance_CurrentHand[2] = [0x303,"float"]
	global $Atrib_Weapon_On_Hit_Chill_Proc_Chance_MainHand[2] = [0x304,"float"]
	global $Atrib_Weapon_On_Hit_Chill_Proc_Chance_OffHand[2] = [0x305,"float"]
	global $Atrib_Weapon_On_Hit_Chill_Proc_Chance_CurrentHand[2] = [0x306,"float"]
	global $Atrib_Weapon_On_Hit_Slow_Proc_Chance_MainHand[2] = [0x307,"float"]
	global $Atrib_Weapon_On_Hit_Slow_Proc_Chance_OffHand[2] = [0x308,"float"]
	global $Atrib_Weapon_On_Hit_Slow_Proc_Chance_CurrentHand[2] = [0x309,"float"]
	global $Atrib_Weapon_On_Hit_Immobilize_Proc_Chance_MainHand[2] = [0x30A,"float"]
	global $Atrib_Weapon_On_Hit_Immobilize_Proc_Chance_OffHand[2] = [0x30B,"float"]
	global $Atrib_Weapon_On_Hit_Immobilize_Proc_Chance_CurrentHand[2] = [0x30C,"float"]
	global $Atrib_Weapon_On_Hit_Knockback_Proc_Chance_MainHand[2] = [0x30D,"float"]
	global $Atrib_Weapon_On_Hit_Knockback_Proc_Chance_OffHand[2] = [0x30E,"float"]
	global $Atrib_Weapon_On_Hit_Knockback_Proc_Chance_CurrentHand[2] = [0x30F,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Chance_MainHand[2] = [0x310,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Chance_OffHand[2] = [0x311,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Chance_CurrentHand[2] = [0x312,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Base_MainHand[2] = [0x313,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Base_OffHand[2] = [0x314,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Base_CurrentHand[2] = [0x315,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Delta_MainHand[2] = [0x316,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Delta_OffHand[2] = [0x317,"float"]
	global $Atrib_Weapon_On_Hit_Bleed_Proc_Damage_Delta_CurrentHand[2] = [0x318,"float"]
	global $Atrib_Power_Damage_Percent_Bonus[2] = [0x319,"float"]
	global $Atrib_Power_Resource_Reduction[2] = [0x31A,"float"]
	global $Atrib_Power_Cooldown_Reduction[2] = [0x31B,"float"]
	global $Atrib_Power_Duration_Increase[2] = [0x31C,"float"]
	global $Atrib_Power_Crit_Percent_Bonus[2] = [0x31D,"float"]
	global $Atrib_Weapon_Crit_Chance[2] = [0x31E,"float"]
	global $Atrib_Weapon_Crit_Chance_MainHand[2] = [0x31F,"float"]
	global $Atrib_Weapon_Crit_Chance_OffHand[2] = [0x320,"float"]
	global $Atrib_Weapon_Crit_Chance_CurrentHand[2] = [0x321,"float"]
	global $Atrib_Strength_Item[2] = [0x322,"float"]
	global $Atrib_Dexterity_Item[2] = [0x323,"float"]
	global $Atrib_Intelligence_Item[2] = [0x324,"float"]
	global $Atrib_Vitality_Item[2] = [0x325,"float"]
	global $Atrib_Item_Level_Requirement_Reduction[2] = [0x326,"int"]
	global $Atrib_Item_Durability_Percent_Bonus[2] = [0x327,"float"]
	global $Atrib_Item_Indestructible[2] = [0x328,"int"]
	global $Atrib_Core_Attributes_From_Item_Bonus_Multiplier[2] = [0x329,"float"]
	global $Atrib_Waiting_To_Accept_Resurrection[2] = [0x32A,"int"]
	global $Atrib_Ghosted[2] = [0x32B,"int"]
	global $Atrib_Special_Inventory_Has_Sold[2] = [0x32C,"int"]
	global $Atrib_Power_Channel_Lockout_Time[2] = [0x32D,"int"]
	global $Atrib_Power_Buff_0_Lockout_Time[2] = [0x32E,"int"]
	global $Atrib_Power_Buff_1_Lockout_Time[2] = [0x32F,"int"]
	global $Atrib_Power_Buff_2_Lockout_Time[2] = [0x330,"int"]
	global $Atrib_Power_Buff_3_Lockout_Time[2] = [0x331,"int"]
	global $Atrib_Power_Buff_4_Lockout_Time[2] = [0x332,"int"]
	global $Atrib_Power_Buff_5_Lockout_Time[2] = [0x333,"int"]
	global $Atrib_Power_Buff_6_Lockout_Time[2] = [0x334,"int"]
	global $Atrib_Power_Buff_7_Lockout_Time[2] = [0x335,"int"]
	global $Atrib_Known_By_Owner[2] = [0x336,"int"]
	global $Atrib_Never_Deactivates[2] = [0x337,"int"]
	global $Atrib_Account_Under_Review[2] = [0x338,"int"]
	global $Atrib_Projectile_Detonate_Time[2] = [0x339,"int"]
EndFunc



;;================================================================================
;;Debug__IterateActorAtribsAll ;NOT INTENDED FOR USE!!
;;================================================================================
func Debug__IterateActorAtribsAll($GUID)
	IterateLocalActor()
	$_Count = _MemoryRead($_ActorAtrib_Count, $d3, 'int')
	$CurrentOffset = $_ActorAtrib_4
	dim $ACTORatrib[9]
	for $i = 0 to $_Count
		$ACTORatrib[1] = _MemoryRead($CurrentOffset, $d3, 'ptr')
		$result = _ArraySearch($__ACTOR,$ACTORatrib[1], 0 , 0 , 0 , 1 , 1 , 3)
		$ACTORatrib[2] = $result
		if $result > -1 Then
			$ACTORatrib[2] = $__ACTOR[$result][2]
			$test = _MemoryRead($CurrentOffset+0x10, $d3, 'ptr')
			$test = _MemoryRead($test+0x270, $d3, 'ptr')
			$test = _MemoryRead($test, $d3, 'ptr')
			$ACTORatrib[3] = _MemoryRead($test+0x14, $d3, 'float')
			ConsoleWrite($i  & " " &$CurrentOffset & " " & $CurrentOffset+0x10 & @TAB &" Name: " & $ACTORatrib[2]& @crlf)
		EndIf
		$CurrentOffset = $CurrentOffset + $ofs_ActorAtrib_StrucSize
		
	Next
EndFunc

;;=================================================================================================================================================================================================
;Best Regards,
;8 8888      88 b.             8 8 8888     ,88' b.             8     ,o888888o.  `8.`888b                 ,8' b.             8 8 8888888888   8 888888888o.       .-----.   .----.  .---. .-----.  		  
;8 8888      88 888o.          8 8 8888    ,88'  888o.          8  . 8888     `88. `8.`888b               ,8'  888o.          8 8 8888         8 8888    `^888.   / ,-.   \ /  ..  \/_   |/ ,-.   \ 
;8 8888      88 Y88888o.       8 8 8888   ,88'   Y88888o.       8 ,8 8888       `8b `8.`888b             ,8'   Y88888o.       8 8 8888         8 8888        `88. '-'  |  |.  /  \  .|   |'-'  |  | 
;8 8888      88 .`Y888888o.    8 8 8888  ,88'    .`Y888888o.    8 88 8888        `8b `8.`888b     .b    ,8'    .`Y888888o.    8 8 8888         8 8888         `88    .'  / |  |  '  ||   |   .'  /
;8 8888      88 8o. `Y888888o. 8 8 8888 ,88'     8o. `Y888888o. 8 88 8888         88  `8.`888b    88b  ,8'     8o. `Y888888o. 8 8 888888888888 8 8888          88  .'  /__ '  \  /  '|   | .'  /__ 
;8 8888      88 8`Y8o. `Y88888o8 8 8888 88'      8`Y8o. `Y88888o8 88 8888         88   `8.`888b .`888b,8'      8`Y8o. `Y88888o8 8 8888         8 8888          88 |       | \  `'  / |   ||       |
;8 8888      88 8   `Y8o. `Y8888 8 888888<       8   `Y8o. `Y8888 88 8888        ,8P    `8.`888b8.`8888'       8   `Y8o. `Y8888 8 8888         8 8888         ,88 `-------'  `---''  `---'`-------'
;` 8888     ,8P 8      `Y8o. `Y8 8 8888 `Y8.     8      `Y8o. `Y8 `8 8888       ,8P      `8.`888`8.`88'        8      `Y8o. `Y8 8 8888         8 8888        ,88' 
;  8888   ,d8P  8         `Y8o.` 8 8888   `Y8.   8         `Y8o.`  ` 8888     ,88'        `8.`8' `8,`'         8         `Y8o.` 8 8888         8 8888    ,o88P'   
;   `Y88888P'   8            `Yo 8 8888     `Y8. 8            `Yo     `8888888P'           `8.`   `8'          8            `Yo 8 888888888888 8 888888888P'  
;;=================================================================================================================================================================================================