; start from keep of depth waypoint;
Func fightGhomMove()
   ; enter ghom boss fight;
   MouseMove(764,158,3)
   Sleep(400)
   MouseClick("left")
   Sleep(5000)
   
   ; active fight;
   
   MouseMove(657,120,3)
   
   
   For $i=1 to 5
	  send("{space}")
	  Sleep(1530)
   Next
   
   
   send("{E}")
   Sleep(200)
   Send("{Enter}");
   Sleep(3200)
   
   ;begin figh;
   
EndFunc


; enter; 
Func fightGhomCrusader()
   
   fightGhomMove()
   
      ;475,264, right theway;
	  
	  ;this number is much better?
	  
	  
MouseMove(433,293);
Send("{space down}")	
Sleep(2800)
Send("{space up}")

MouseMove(423,299);; almost self
Sleep(100)
send("{SHIFTDOWN}")
Send("{a down}")
; face to face;
;don't move myself, so we both dont' move.
For $i=1 to 73
MouseClick("right")
Sleep(100)
Send("{1}")
Sleep(300)
Send("{2}")	
Sleep(200)
Send("{3}")
Sleep(200)
MouseClick("left")
Sleep(50)
MouseClick("right")
Sleep(500)
Next

MouseClick("right")
Sleep(100)
MouseClick("right")
Sleep(100)

send("{SHIFTUP}")
Send("{A up}")
Sleep(100)
;cause it's ghom, end quest after fight;
Send("{e}")
Send("{e}")
Send("{e}")

EndFunc



Func fightGhomWD()
   fightWD272()
EndFunc






Func fightGhomWZ()
   bufWZ()
fightMAGA272()
   
EndFunc


;1 acid
;2 ritual
;3 gargantuan; do not summon early to make sure that guy come to Me
;4 army; dps
;5 aoe, spirit barrage
;6aoe, bat;
Func fightWD333()

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

Func fightMAGA333()

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

