#include <date.au3>






Func FightCellar()
       ;    Click(349, 595) ;choose hydra
       ;    Click(220, 174) ;cast hydra
       ;        MouseClickDrag ( "right", Random(85,89), Random(169,173) ,Random(258,262), Random(104,108), Random(9,12))
       ;    MouseClickDrag ( "right", Random(85,89), Random(169,173) ,Random(258,262), Random(104,108), Random(9,12))
       ;       RightShoot(161, 128)
	   
	   ; move to position
	   
	   DEBUG("first we want to move to position")
	   DEBUG("1")
	   Move(740, 250)
	   sleep(100)
	   send(2) ; spell add attack
	   sleep(1200);
	   
	   DEBUG("2")
	   Move(740, 250)
	   send(3) ; spell add attack .
	   sleep(1200);
	   
	   DEBUG("3")
	   Move(740, 250)
	  
	   sleep(1200);
	   	   
	   DEBUG("3.66666666")
	   Move(660, 250)
	   sleep(900);
	   
	    Send(1) ; spell diamond skin shell .
	   DEBUG("3.88888888888")
	   Move(660, 250)
	   sleep(100);
	   
	   DEBUG("4")
	     ; move 4 times we will get to position.
	   
	      
	   RightClick(700, 270) ; cast my hydra .
	  
	   
	   ; cast archon. we need shift...
	   sleep(200);
	   send("{SHIFTDOWN}")
	   sleep(200);
	   Click(600,280)  
	   sleep(200);
	   send("{SHIFTUP}")
	   
	   DEBUG(" at position and ready?  ")
	   
	   ; begin attacki
	   MouseDown("right")
	   MouseMove(740, 230,1)
	   sleep(3500)
	   Send(1)
	   sleep(4000)
	   Send(1)
	   
	   MouseMove(740, 200,1)
	   sleep(4000)
	   MouseUp("right")
	   
	   
	   DEBUG("====222222222=========")
	   ; another position 
	   Move(750,300)
	   Sleep(1000)
	   Move(600,330)
	   Sleep(500)
	   
	   MouseMove(740,150,0)
	   sleep(100)
	   send(1)
	   sleep(200)
	   MouseDown("right")
	   sleep(3000)
	   MouseMove(740, 200,1)
	   sleep(1000) 
	   MouseMove(740, 130,1)
	   sleep(1000)
	   MouseMove(300,280)
	   sleep(3000)
	   Send(1)
	   MouseUp("right")
	   
	   DEBUG("done!!")

       Return
EndFunc   ;==>FightCellar


 




Func findAllItem()
   findAllItemTyped(1); 0 for Default; 1 for legend
EndFunc

Func findAllItemTyped($type)
   DEBUG("looooooooot~~~~~~~~~~~~~")
                  Sleep(Random(200, 220))
			   Move(725, 300 + $offset)
       Sleep(1200)
               FindItem($type)
			   
			   
      Move(175, 320)
			   
	  Sleep(1100)
	   
	   FindItem($type) 
	  

Move(275, 270 + $offset)
       
	   Sleep(1100)
	   FindItem($type)
	   
	   
	    Move(225, 330)
       Sleep(1100)
	  FindItem($type)
	        
	   MouseDown("right")
	   Sleep(100)
	   MouseUp("right")
	  
	  Move(175,300)
       Sleep(1100)
	  FindItem($type)
   
   EndFunc


Func FindItemDefault()
   
   FindItem(0); 0 for default. 
   
   EndFunc

Func FindItem($type)
       $work = 1
       $checkCount = 0
	   $checkLimit = 20
	   local $checkRareLimit  = 10
	   if($type==1) Then
		  ;for legendonly , because bag is full
		  $checkLimit = 4
		  $checkRareLimit=0
		  DEBUG("IN MODE:  LEGEND ONLY!!")
		  EndIf
		  
       While $work == 1 And $checkCount < $checkLimit
               DEBUG("Search Item  : $work   "+$work)
               $work = 0
               Send("{LALT}")
;             $SearchResult = PixelSearch($Left, $Top, $Right,$Bottom, $Color2)
;searches for magics
;			 If Not @error Then
 ;                    MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10);clicks magic
  ;                  Sleep(Random(2400,2600))
   ;                 $work = 1
    ;                $checkCount = $checkCount +1
     ;        EndIf
			   
			   ; still try to get rare.
			   if ($checkCount<$checkRareLimit) Then
				                 $SearchResult = PixelSearch($Left, $Top, $Right, $Bottom, $Color,3)
;searches for rares
					  If Not @error Then 
                       MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10) ;IF
                       Sleep(3500)
                       $work = 1
                       $checkCount = $checkCount + 1
					EndIf
				 EndIf
				 



              Send("{LALT}")
               $SearchResult = PixelSearch($Left, $Top, $Right, $Bottom, $Color3,3)
;searches for legendarys
               If Not @error Then
				  
						;drop one random thing for can't pickup legend!
						if($checkCount>2)Then ;count>2 mean i can't pick up. 
						   dropOneRandomThingForALegendPickup($checkCount)
						EndIf
						
						   
				  
						MouseMove($SearchResult[0],$SearchResult[1],0)				  				 
							;	 Send("{PRINTSCREEN}") ; do not print... too many similar color on the floor....
					   
                       MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10);clicks legendary
                       Sleep(3500)
					 ;  WriteFileAppend()
					   
                       $work = 1
                        $checkCount = $checkCount + 1
				   EndIf
	             Send("{LALT}")
               $SearchResult = PixelSearch($Left, $Top, $Right,$Bottom, $Color4,3);searches for SETS
               If Not @error Then
				  
				  ;drop one random thing for can't pickup legend!
				  if($checkCount>2)Then ;count>2 mean i can't pick up. 
						   dropOneRandomThingForALegendPickup($checkCount)
						EndIf
				  
					 MouseMove($SearchResult[0],$SearchResult[1],0)
					 Send("{PRINTSCREEN}")
                       MouseClick("left", $SearchResult[0],$SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
                       Sleep(4500)
					   WriteFileAppend()
					   
                       $work = 1
                       $checkCount = $checkCount + 1
               EndIf
       WEnd
       DEBUG("Finish Item Searching")
       Return
EndFunc   ;==>FindItem

Func tryFindLegend()
   
   
   EndFunc

Func dropOneRandomThingForALegendPickup($checkCount)

; it's for the case : find legend, but not enough space ,drop one random thing.
DEBUG("dropOneRandomThingForALegendPickup !!!   "&$checkCount)



EndFunc

Func writeInvColorTest()
   
   ; thankyou.
   
   writeToNamedFileAppend("pix-res.txt",".............................................."&_Now())
		 for $x = 775 to 788
			for $y = 472 to 492
			   $getColor = PixelGetColor($x,$y)
			   MouseMove($x,$y,4)
			   ;writeToNamedFileAppend("pix-res.txt"," [ "&$x&"  ,  "&$y&"  ]  "&Hex($getColor, 6))
			   writeToNamedFileAppend("pix-res.txt",Hex($getColor,6))
			Next
		 Next
   
   writeToNamedFileAppend("pix-res.txt",".====.......try to pixelsearch.."&_Now())
		 $full = PixelSearch(765, 475, 784, 490, 0x130C08, 2) ; color for empty inv.
 	  
	  
	  If @error Then
		 writeToNamedFileAppend("pix-res.txt",".====....... search DID NOT find inv color, guess it's full")
	  Else
		 
		 writeToNamedFileAppend("pix-res.txt",".====....... find target color , like Empty ,loc : "&$full[0]&"  "&$full[1])
		 
		 MouseMove($full[0],$full[1],4)
		 writeToNamedFileAppend("pix-res.txt",Hex(PixelGetColor($full[0],$full[1]),6))
	  EndIf
		 
EndFunc
	  
   

Func CheckInv()
       DEBUG("CheckInv")	   
	   Send("{i}") ;opens inv
       Sleep(Random(200, 220))
	   ; old color 0x130c08
	   ;writeInvColorTest();
; we are not afraid of not go home with inv full. 
	  ; we are really afraid of go home too much. so ,we like res not full.      
	  
	  
	;  Local $colorxy = Hex(PixelGetColor(775,480),6)
;	  DEBUG("color  "&$colorxy)
;	  sleep(5000);
											 ; was 0x130c08
	  $full = PixelSearch(765, 475, 784, 490, 0x130b08, 2) ; color for empty inv.
	  
 	  If @error Then
   
		 DEBUG("FULL INV 111111111111111111111  WTF!    "&@error)
		 sleep(5000)
		 Sleep(Random(20, 25))
		 
		 Send("{i}") ;close inv
		 Return True
	  EndIf
	  
			
			;// if item have same color as blank bag, it would recongnized as not full.
			; so check again to make sure.
			; 0x120c08
;	   $full = PixelSearch(766, 476, 772, 482, 0x130C08, 2) 
;	   If @error Then
 ;              DEBUG("FULL INV 222222222222222222")
 ;              Sleep(Random(20, 25))
  ;             Send("{i}") ;close inv
  ;             Return True
;			EndIf
	  
       Send("{i}") ;close inv
       DEBUG("Not Full inven")
	   
       Sleep(Random(20, 25))
       Return False
EndFunc   ;==>CheckInv

Func InvRepair()
       DEBUG("Going to repair")
       $slot1x = 538
       $slot1y = 367
       $offset = 27
       Send("t")
       Sleep(Random(12000, 12200)) ; sleep longer for slow machine.
       If Random(1, 2, 1) == 1 Then ;2 merchants
               MouseClick("left", 700, 147) ;begin movement towards merchant
               Sleep(Random(2400, 2600))
               MouseClick("left", 531, 51) ;moves to get merchant in screen
               Sleep(Random(3000, 3200))
             ;  For $i = 0 To 9
              ;         For $j = 0 To 3
               ;                MouseClick("right", $slot1x + ($i *$offset), $slot1y + ($j *$offset), 1, 3)
                ;               Sleep(40)
                ;       Next
               ;Next
               ;For $i = 5 To 9
               ;        For $j = 4 To 5
               ;                MouseClick("right", $slot1x + ($i *$offset), $slot1y + ($j *$offset), 1, 3)
                ;               Sleep(40)
                ;       Next
               ;Next
               Click(294, 296) ;button to open up repair menu
       Else
               MouseClick("left", 39, 389) ;begin movement towards merchant
               Sleep(Random(2400, 2600))
               MouseClick("left", 31, 108) ;moves to get merchant in screen
               Sleep(Random(3000, 3200))
               ;For $i = 0 To 9
               ;        For $j = 0 To 3
               ;                MouseClick("right", $slot1x + ($i *$offset), $slot1y + ($j *$offset), 1, 3)
               ;                Sleep(40)
               ;        Next
               ;Next
               ;For $i = 5 To 9
               ;        For $j = 4 To 5
               ;                MouseClick("right", $slot1x + ($i *$offset), $slot1y + ($j *$offset), 1, 3)
               ;                Sleep(40)
               ;        Next
               ;Next
               Click(293, 370) ;button to open up repair menu
       EndIf


       Sleep(Random(1500, 1600))
       MouseClick("left", 186, 326) ;button to pay for repairs
       Sleep(Random(1500, 1600))
       ;       $inBag = PixelSearch(780, 474, 782, 476, 0x130C08,5)
       Send("{ESCAPE}");close menus with merchants
EndFunc   ;==>InvRepair



Func openSpell() ; RANDOM STUFF
       If Random(1, 1, 1) == 1 Then
               Send('s')
               Sleep(Random(300, 800))
               Send('s')
               Sleep(Random(30, 80))
       EndIf
EndFunc   ;==>openSpell

Func _Send($text, $milliseconds)
       $time = TimerInit()
	  Do
               Send($text)
       Until TimerDiff($time) > $milliseconds
EndFunc   ;==>_Send


; for esc:   577,613 , 985d13  , one pixel for esc button
; for esc on my computer. it's 0x6d1c00, lenovo. fix 
Func tryPressEscButton()
for $trytime = 0 to 3
   ; it's 
   
   
   $computerEsc = PixelSearch(575, 611, 579, 615, 0x945e1b, 2)   ;774910
   
   
   if Not @error Then
	  DEBUG("FIND ESC ooooooo OK")
	  MouseClick('left',577,613,1,2)
	  Sleep(Random(300, 450))
	  MouseClick('left',403,358,1,5); click logout
	  
	  sleep(100)
	  MouseClick('left',397,357,1,3); click logout
	  
	  
	  ;MouseMove(397,357,4)
	  ;sleep(190)
	  ;ToolTip("I have moved to 397,357!!"..,0,0)
	  
	  ;MouseClick("left")
	  
	  DEBUG(" sleep for a while after esc")
		  Sleep(Random(12500, 15000))
		  DEBUG(" sleep done after esc")
   Else
	  DEBUG("NOT FOUND < CAN'T press esc. ")
	  sleep(3000)
	  $resume = PixelSearch(63, 255, 83, 269, 0x2C0100, 10)   ; //color for resume game has pressed but screen not changed yet
			If Not @error Then
			   ; OK! we already in resume!
			   DEBUG("OK, we are here. mainmenu. ")
			Else
			   DEBUG("try send escape key , to find escbutton ")
			   Send("{ESCAPE}") ; try close some window to get esc button.
			   sleep(100)
			    MouseClick('left',397,357,1,3); click logout
				Sleep(Random(12500, 15000))
			EndIf	 
			   DEBUG("end , esc send")
   EndIf
Next


;if ingame, try send esc and go press it .

EndFunc


Func NEWESC()

Local $pos = MouseGetPos()
tryPressEscButton();
$resume = PixelSearch(63, 255, 83, 269, 0x2C0100, 10)   ; //color for resume game has pressed but screen not changed yet
   If @error Then
	  DEBUG("=======================================================try again to go to main menu!!")
	  WinActivate('Diablo III')
	  Sleep(1000)
	  tryPressEscButton();
   EndIf
EndFunc



Func ESC()
   NEWESC()
EndFunc   ;==>ESC

Func Pause() ; f10 function.
       $Paused = Not $Paused
       While $Paused
               Sleep(100)
               ToolTip('Paused...', 0, 0)
       WEnd
       ToolTip("")
EndFunc   ;==>Pause

Func ContinueMainLoop()  ; f12 function.
   
   ;$Paused = False
   ;Sleep(150)
   
   ;ContinueLoop   
   EndFunc

Func RegisterGoHome()
   $needGoHome = 1
EndFunc


Func getLocationAndColor()
; for esc:   577,613 , 985d13
Local $pos = MouseGetPos()

Local $colorxy = Hex(PixelGetColor($pos[0],$pos[1]),6)

DEBUG("Mouse x,y: "&$pos[0] & "," & $pos[1] &"   color  "&$colorxy)
sleep(3999)
EndFunc

Func pureTestInstance()

EndFunc

Func Quit() ; f11 function
       Exit
EndFunc   ;==>Quit

Func DEBUG($MESSAGE)
       If $DebugOn Then
               ToolTip($MESSAGE, 0, 0)
       EndIf
EndFunc   ;==>DEBUG

Func Tests()
;getLocationAndColor()
;writeInvColorTest()

;NEWESC()
CheckInv();

;pureTestInstance()
EndFunc ;  Test(), press F8,

