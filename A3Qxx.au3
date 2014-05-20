Func bufWZ()
Send("{1}")	
Sleep(100)
Send("{2}")	
Sleep(100)
Send("{3}")	
Sleep(300)
EndFunc


func enterGhomsRoom()



   
EndFunc




; all start from "in cellar"
func moveToFightGhomPosition()
   ; move to ghom's room;
   enterGhomsRoom()
   
   ;move to face ghom, start to prcess e;
   
   
   MouseMove(754,538,3)
   Sleep(1000)
   MouseClick("left")
	Sleep(4000);
	
	;now we are at dahlgur oasis	
	
	MouseMove(741,537,2)
   Sleep(30)
   send("{space}")	;	 maybe config this move hotkey?
   Sleep(1630)
   ;fight about to begin.
   send("{space}")	;	 maybe config this move hotkey?
   Sleep(830)
   ; go further, so hope that inv minion will come earlier
EndFunc



Func fightSSXXWD()
   
   moveToFightSSXXPosition()
   fightWD272()
   
EndFunc

   



Func fightSSXXWZ()
   bufWZ()
moveToFightSSXXPosition()


fightMAGA272()
   
EndFunc


;1 acid
;2 ritual
;3 gargantuan; do not summon early to make sure that guy come to Me
;4 army; dps
;5 aoe, spirit barrage
;6aoe, bat;
Func fightWD272()

   MouseMove(172,450,2)
   Sleep(30)
   send("{space}")	;	 maybe config this move hotkey?
   Sleep(1000)
   Sleep(5000)


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

;Send("{1 down}")	

MouseDown("right")
; some times knockback happens; so;
for $ll=1 to 3
Sleep(9000)
Send("{1}")	
Sleep(300)
Send("{2}")	
Sleep(200)
Send("{3}")
Sleep(200)
Send("{4}")	
Sleep(200)
Next

MouseUp("right")

MouseMove(467,248)
send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
send("{SHIFTUP}")
Sleep(100)

Send("{1}")	
Sleep(300)


   
EndFunc





; use maga/ wizard to fight
;1,2,3 buf
;right, hydra
;4: archon ; last 20s

Func fightMAGA272()

MouseMove(686,492)

MouseClick("right")
Sleep(100)
MouseClick("right")
Sleep(100)

;became man
Send("{4}")	
Sleep(100)
MouseDown("right")

;20s loop
for $iii=1 to 40
   Sleep(500)
   Send("{1}")	
Next

MouseUp("right")

MouseClick("right")
Sleep(100)

EndFunc

