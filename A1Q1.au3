;A1Q1 . upgrade.

Func selectA1Q1()
 
Sleep(10) 

MouseMove(156,308,3)
Sleep(109)
MouseClick("left")
Sleep(540)

MouseMove(132,238,3)
Sleep(109)
MouseClick("left")
Sleep(240)

MouseMove(555,515,3)
Sleep(109)
MouseClick("left")
Sleep(240)


MouseMove(344,383,3)
Sleep(109)
MouseClick("left")
Sleep(540)

; ok, select this level
MouseMove(344,383,3)
Sleep(109)
MouseClick("left")
Sleep(540)


;
; we get this as we are from just finished this quest.

EndFunc



Func moveToQuestA1Q1()
   
   MouseMove(445,310 ) ; tomove east
   
   For $i= 0 to 300	; 50s total.
   MouseClick("right") ; zombie hand.
   Sleep(30)
   Send("{1}"); 
   Sleep(30)
Next


MouseMove(437,250)

For $i= 0 to 430	; 50s total.
   MouseClick("right") ; zombie hand.
   Sleep(30)
   Send("{1}"); 
   Sleep(30)
   
Next
   
   
   local $x
   local $y
   For $i = 0 to 1
	  
	  $offx = $i*100
	  $offy = $i*50
	  
   MouseMove(276+$offx,426+$offy,3)
   Sleep(400)
   
   
   $res = _ImageSearch(".\img\ig-captain-nam.png",1,$x,$y,50)
   If($res)Then
	  MouseClick("left")
	  Sleep(3000)
	  ExitLoop
   EndIf
Next

   ;if nothing found.
   
   MouseMove(276,426,3)
   Sleep(400)
   
   MouseClick("left")
	  Sleep(3000)
	  
	  
EndFunc



Func moveToQuestA1Q1_old_obsolete_deprecated()

MoveExact(786,305,1611)

MoveExact(761,360,1611)
   
MoveExact(782,248,1211)


MoveExact(791,255,1211)

MoveExact(795,309,1211)
MoveExact(791,167,2211)



pause()

MoveExact(623,168,1711)
; dont' know why, differnt machine have different move... sucked. ; seems taht different class matters?

pause()

MoveExact(398,160,511)
pause()
;sleep for quest guy finish beat zombie.
Sleep(4000)
EndFunc


Func blindClickQuest()

MouseMove(352,251,3)
Sleep(300)
MouseClick("left")


Send("{e}")
Sleep(40)
MoveFast(265,230)

Send("{e}")
Sleep(40)
Send("{e}")
Sleep(40)
Send("{e}")
Sleep(40)
Send("{e}")
Sleep(40)


   
EndFunc



; quest icon flows / changes rapidly, not easy to find.
Func findQuestClick()
   	  
$x=0
$y=0

   $res = _ImageSearch(".\img\quest-ig-mid.png",1,$x,$y,40);default search whole screen. ; set option, not clicked.
ToolTip(" [fight]  , find normal enemy full hp bar, top ?  "&$res,0,0)
;Sleep(1000)
If($res)Then
   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   MouseMove($x,$y,3)
   
   ; move to body
   MouseMove($x,$y+50,3)
   Sleep(1000)
   MouseClick("left")
   
EndIf

return $res;

EndFunc


; (400,311 ) going up
; (400,315) going down
Func fightZombiesMK()
   
   DEBUG("fight begin")
   Sleep(3000)
   MouseMove(511,368,3)
   Sleep(30)
   ;MouseDown("left")   
   
   MouseMove(420,314)
   
   For $j=0 to 14
	  MouseClick("right") ;  light of heal
	  Sleep(100)
	  Send("{3}");
	  Sleep(20)
	  Send("{1 down}");
	  
	  
   For $i= 0 to 30	; 50s total.
   MouseClick("right") ; 
   Sleep(50)
   MouseClick("left") ; 
   Sleep(50)
Next

   Send("{1 up}");
Next

   
   MouseClick("right") ; 
   Sleep(100)
   Send("{4}");
   MouseMove(99,99,3)
     Send("{1 down}");
	 Sleep(5000)
	 Send("{1 up}");
   
EndFunc

Func fightZombiesWD()
   DEBUG("fight begin")
   Sleep(3000)
   MouseMove(511,368,3)
   Sleep(30)
   send("{SHIFTDOWN}")
   
   MouseDown("left")   
   
   For $i= 0 to 50
   MouseClick("right") ; zombie hand.
   Sleep(1000)
   Next
   
   MouseUp("left")
   send("{SHIFTUP}")

   ; make sure every zombie out.
   MoveFast(511,368)
   MoveFast(511,368)
   MoveFast(511,368)
   
   MouseClick("right",400,300)
   Sleep(2000)
 EndFunc
 



   