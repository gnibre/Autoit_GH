#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ImageSearch.au3>

$Amethyst = 0xA56DF1
$Ruby = 0xFA8078
$Emerald = 0x51965B
$Topaz = 0xFFFF59

; find item range.
$Left = 100
$Top = 100
$Right = 600
$Bottom = 530


$ColorRare = 0xFFFF00 ;rare color code ; 0xbbbb00may also work.
$ColorBlue = 0x6969FF ;blue color code    ; my blue like 99,99,239
$ColorLeg = 0xBF642F ;legendary color code; 191-100-47
$ColorLeg2 = 0xBE622E					;0xC46D2A  ; 196,109,42
                               ;239,121,3?
							   ;227,117,5?
                               ;233,119,4;
$ColorLeg3 = 0xE97704

$ColorInvLeg1 = 0x422408  ;66,36,8
$ColorInvLeg2 = 0x4A2C10  ;74 44 16
        


	  ;185,98,45  186, 98,46
	  ;191,100,47
	  ;179,94,44
;	  32 ,a10 b11 c12 d13 e14 f15
	  ;196,109;42
	  
$ColorSet = 0x00FF00 ;SET color ; and 0x02CE01 may also work.
$ColorSet2 = 0x02E002
; set color;    8,227,3
; 6,214,2

$ColorLight = 0xFAFAB2    ; 255-249-176 ;  255-230-162; 255-252-205

$ColorTome = 0x09B0EF; 144 176 239        
$ColorGem =  0x8AA6DF ;138 166 223

;$Color41 = 0x
$Color5 = 0x; 68 72 89 ;;  136,166,226
$slot1x = 538
$slot1y = 367
$offset = 27
	   



; this must be called from battle ground. or we can't find everything. ; maybe we shall use pic recognise.
func goHomeAndPutToStash()
						; one of the backto town may be disrupted by form change back from archon.\\
					   Send("t")
					   sleep(8000)
					   Send("t")
					   Sleep(10000)
					   
					   ; we id every thing here. hope would not kill our self.
					   ;dangerousIdenEveryThing();
					   
					   cainBookIdenEverything();
				
;from cain's book to stash.				
					   
   MouseMove(244,298,3)
   Sleep(50)
   MouseClick("left")
   Sleep(2000)
			   
						DEBUG("SLEEEP END, i find my stash")
						
	  
	  ; first ,put my last thing to make my bag "empty"
	  
   MouseClick("right",780,475,1,3) ; put it. 
   Sleep(50)
   MouseClick("right",780,500,1,3) ; 
	  Sleep(50)
   
   
   For $i = 0 To 9
	  For $j = 0 To 5
		 MouseClick("right", $slot1x + ($i *$offset), $slot1y + ($j *$offset), 1, 3)
		 Sleep(40)
	  Next
   Next
			
			   
   
	   MouseClick("left", 300, 233)  ; second page.
	   Sleep(500)
		
		 MouseClick("right",780,475,1,3) ; put it. 
		 Sleep(50)
		MouseClick("right",780,500,1,3) ; 
		Sleep(50)
	   For $i = 0 To 9
		   For $j = 0 To 5
				   MouseClick("right", $slot1x + ($i *$offset), $slot1y + ($j *$offset), 1, 3)
				   Sleep(40)
		   Next
		Next
		
    Send("{ESCAPE}")
   EndFunc
			   


Func pickupGem($checkLimit)
   Send("{LALT}")
   $x=0
   $y=0
   $res = _ImageSearch(".\img\item-gem.png",1,$x,$y,60);default search whole screen.
   If($res)Then
	  MouseMove($x,$y,3)
	  Sleep(100)
	  MouseClick("left", $x,$y, 1, 10) ;IF
	  $bou = (abs($x-400)+abs($y-300))*4;
	  Sleep(500+$bou)
   Else
	  ;ToolTip("NO GEM!!!!!!!!!!!!!!!!!!!")
	  ;Sleep(3000)
	  
   EndIf

EndFunc


Func pickupTome($checkLimit)
   ToolTip("find tomes!!")
   Sleep(1000)
   Send("{LALT}")
   $x=0
   $y=0
   $res = _ImageSearch(".\img\item-tomeos.png",1,$x,$y,50);default search whole screen.
   If($res)Then
	  MouseMove($x,$y,3)
	  Sleep(100)
	  MouseClick("left", $x,$y, 1, 10) ;IF
	  $bou = (abs($x-400)+abs($y-300))*4;
	  Sleep(500+$bou)
   Else
	  ;ToolTip("NO tome!!!!!!!!!!!!!!!!!!!")
	  ;Sleep(3000)
   EndIf

EndFunc




Func findAndTryPickupItemByColor($forColor,$checkLimit)
   $work = 1
   $checkCount = 0
	  While $work == 1 And $checkCount < $checkLimit
;               DEBUG("Search Item  : $work   "+$work)
               Send("{LALT}")
			   $SearchResult = PixelSearch($Left, $Top, $Right, $Bottom, $forColor,3)
			   If Not @error Then 
					 MouseMove($SearchResult[0],$SearchResult[1],3)
					 Sleep(2)
                       MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10) ;IF
                       Sleep(3500)
                       $work = 1
					Else
					   $work = 0
			   EndIf
			   $checkCount = $checkCount + 1
	  WEnd
   EndFunc
   

Func findLegendary($forColor,$checkLimit)
	  $work = 1
   $checkCount = 0
	  While $work == 1 And $checkCount < $checkLimit
;               DEBUG("Search Item  : $work   "+$work)
               Send("{LALT}")
			   $SearchResult = PixelSearch($Left, $Top, $Right, $Bottom, $forColor,3)
			   If Not @error Then 
				  ; pixel find the legendary color , but it maybe not the item, maybe the fire or the monster. / the worst thing is edge of the map we can't reach.
				  
				  ; so check before we click 
				  
					 $res2 = PixelSearch($SearchResult[0]-15, $SearchResult[1]+30, $SearchResult[0]+15, $SearchResult[1]+10, $ColorLight,20)
					 
					 
					 MouseMove($SearchResult[0],$SearchResult[1],3)
						Sleep(100)
                       MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10) ;IF
					 
					 ; color for light on it is : 255-249-176 
					 ;If Not @error Then 
						;MouseMove($SearchResult[0],$SearchResult[1],3)
						;Sleep(100)
                       ;MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10) ;IF					   
                       ;$work = 1
					;Else
					 ;  MouseMove($SearchResult[0],$SearchResult[1],3)
					  ; Sleep(3500);
					  ; DEBUG("  we find  legend color but we give up up there's no light on it.  ,   ");
					  ; color set changed;
					;EndIf
			   Else
					   $work = 0
			   EndIf
			   $checkCount = $checkCount + 1
	  WEnd	  
EndFunc




; 100 for square gem and tome of secret mask.
; 5  set/legendary only
; 6 default,   rare+set/legend

Func FindItem($type,$checkLimit)
   
   
	  If($checkLimit<2)Then
		 $checkLimit= 2;
	  EndIf
	  
	  
	  If($type>100)Then
		 ;  for tome and gem.
		 
		 $type = $type-100;
	  Else		 
	  EndIf
	  
	  
	  If($type<5)Then
		 $type = 6
	  EndIf
	  ; always set and leg
	  findAndTryPickupItemByColor($ColorSet,2)
	  findAndTryPickupItemByColor($ColorSet2,2)
	  
	  findAndTryPickupItemByColor($ColorLeg,1)
	  findAndTryPickupItemByColor($ColorLeg2,1)
	  findAndTryPickupItemByColor($ColorLeg3,1)
		  ; always want legendary  
	  findLegendary($ColorLeg,3)	  
	  findLegendary($ColorLeg2,3)
	  findLegendary($ColorLeg3,3)

	  If($type>5)Then
		 findAndTryPickupItemByColor($ColorRare,2)
	  EndIf
	  
	  	  ;findAndTryPickupItemByColor($ColorTome,2)
	  findAndTryPickupItemByColor($ColorGem,2)	  

EndFunc   ;==>FindItem

			   
			   

Func cainBookIdenEverything()
   
   ; for act 3
   
   MouseMove(232,129,3)
   Sleep(50)
   MouseClick("left")
   Sleep(9000)
EndFunc


;=======================================================================================
func dangerousThrowAwayNoneLegend()
   for $i=0 to 9
	  for $j = 0 to 5
		 $startx =$slot1x + ($i *$offset)
		 $starty = $slot1y + ($j *$offset)
		 DEBUG("GOING TO CHECK , : "&$startx&"   "&$starty)
		 
		 $unIdColor = PixelSearch($startx,$starty,$startx+$offset,$starty+$offset,0xFFFFFF) ; search for exact white for un identify.
		 
		 If Not @error Then
			; found white.
			;MouseClick("right", $unIdColor[0],$unIdColor[1], 1, 5) ;IF
			;Sleep(390)
			; we click twice in the same place to make sure we would not make a mistake and put something on
			;MouseClick("right", $unIdColor[0],$unIdColor[1], 1, 5)
			;sleep(1600)
		 Else
			; maybe it's not legendary.
			
			
			
			sleep(20)			
		 EndIf
	  Next
   Next


EndFunc



;===================================================================================================================================================================================================
func dangerousIdenEveryThingDONOTUSEANYOMRE()
   
   sleep(100)
   send("{i}");
   sleep(1000)
   
   $found = 0 ;
   
   for $i=0 to 9
	  for $j = 0 to 5
		 $startx =$slot1x + ($i *$offset)
		 $starty = $slot1y + ($j *$offset)
		 DEBUG("GOING TO CHECK , : "&$startx&"   "&$starty)
		 
		 $unIdColor = PixelSearch($startx,$starty,$startx+$offset,$starty+$offset,0xFFFFFF) ; search for exact white for un identify.
		 If Not @error Then
			; found white.
			MouseClick("right", $unIdColor[0],$unIdColor[1], 1, 5) ;IF
			Sleep(390)
			; we click twice in the same place to make sure we would not make a mistake and put something on
			MouseClick("right", $unIdColor[0],$unIdColor[1], 1, 5)
			sleep(1600)
		 Else
			sleep(20)			
		 EndIf
	  Next
   Next
   
   send("{i}");
   
EndFunc
