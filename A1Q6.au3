;A1Q6


;Sleep(5000);

;moveToPositionA1Q6Fast();
;fightBrokenBladeCS60()

;fightBrokenBladeMonk60();




Func moveToPositionA1Q6Fast()
   
   ;729,247
    MouseMove(740,250)      ;; opsite to back.  60,350
    Send("{1 down}")	
	Sleep(4000);	
	Send("{1 up}")	
	
EndFunc



;1, main attack, generater
;2, protect
;3 arua, protect
;4/A  man
;left damage 
;right damage aoe;

Func fightBrokenBladeCS60()

ToolTip("fight begin. crus ");
; keep mouse at right.?
MouseMove(740,250)

$count = 0;
Send("{1 down}")	


For $k = 1 to 45  ; 5 s
;  go before fight
;Send("{3}")	
Sleep(100)
Next



For $k=1 to 2 ; 40s total fight time.
;   ToolTip(" round ......"&$k);
; rebuf
MouseClick("right")
Sleep(1000)
; we got man!
Send("{4}")	
Sleep(50)
send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
send("{SHIFTUP}")
Send("{2}")	
Sleep(100)

MouseClick("right")
Sleep(100)
MouseMove(430,310)

for $iii=1 to 10
   Sleep(1000)
	  MouseClick("Right")
     Send("{2}")	
	 Next

For $kk=1 to 3;  30s rebuf.
   MouseMove(430,275)
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
   send("{SHIFTUP}")
   MouseClick("right")
   
   Send("{2}")	
   Sleep(100)	
   
   For $righ = 1 to 36 ; 7 right
	  MouseClick("Right")
	  Send("{2}")	
	  Sleep(100)	  
   Next
   
   Send("{3}")	
     Sleep(100)	  
   MouseMove(360,325)
   
   
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
   send("{SHIFTUP}")
   MouseClick("right")
   
   For $left = 1 to 12  ; 3s left
	  Send("{2}")	
	  Sleep(100)
	  MouseClick("Right")
	  ;MouseClick("right")
   Next
   
  ; Send("{4}")	
  ; Sleep(50)
  ; Send("{3}")	
  ; Sleep(50)
   MouseClick("right")
   Sleep(50)
   Send("{2}")	
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(100);
   send("{SHIFTUP}")
Next

   MouseClick("right")
   Sleep(50)
   Send("{2}")	
Next

MouseMove(740,250)

Sleep(4000)
MouseMove(430,265)
Sleep(4000)

MoveFast(200,340)

send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(100);
   send("{SHIFTUP}")
   
   Send("{1 up}")	  


EndFunc


; 1 main attack
;2 wudi
; mirror fighter
; arua
;wave of light
; sweeping wind
Func fightBrokenBladeMonk60()

ToolTip("fight begin. monk60");
; keep mouse at right.?
MouseMove(740,250)

$count = 0;
Send("{1 down}")	

Sleep(100)  
Send("{3}")	


For $k = 1 to 45  ; 5 s
;  go before fight
;Send("{3}")	
Sleep(100)
Next



For $k=1 to 2 ; 40s total fight time.
;   ToolTip(" round ......"&$k);
; rebuf
MouseClick("right")
Sleep(1000)
; we got man!
Send("{2}")	
Sleep(50)
send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
send("{SHIFTUP}")

Send("{3}")	
Sleep(50)	  

Send("{2}")	
Sleep(100)

MouseClick("right")
Sleep(100)
MouseMove(430,295)

for $iii=1 to 10
   Sleep(1000)
     Send("{2}")	
	 Next




For $kk=1 to 3;  30s rebuf.
   MouseMove(430,265)
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
   send("{SHIFTUP}")
   MouseClick("right")
   
   For $righ = 1 to 46 ; 7 right
	  Send("{2}")	
	  Sleep(100)	  
   Next
   
   MouseMove(360,320)
   
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(50);
   send("{SHIFTUP}")
   MouseClick("right")
   
   For $left = 1 to 18  ; 3s left
	  Send("{2}")	
	  Sleep(100)
	  ;MouseClick("right")
   Next
   
  ; Send("{4}")	
  ; Sleep(50)
  ; Send("{3}")	
  ; Sleep(50)
   MouseClick("right")
   Sleep(50)
   Send("{2}")	
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(100);
   send("{SHIFTUP}")
Next

   MouseClick("right")
   Sleep(50)
   Send("{2}")	
Next

MouseMove(740,250)

Sleep(4000)
MouseMove(430,265)
Sleep(4000)

MoveFast(200,340)

   Send("{1 up}")	   
EndFunc



; 1 main attack

; 2,3 buf, 
; 4: aura
;
;left : man*3 
; right,  super man
Func fightBrokenBladeBB60()

ToolTip("fight begin. bb60");
; keep mouse at right.?
MouseMove(740,250)

$count = 0;
Send("{1 down}")	

Sleep(100)
Send("{4}")	
Sleep(100)

For $k = 1 to 70  ; 5 s
Send("{3}")	
Sleep(100)
Next

Send("{4}")	
Sleep(100)

For $k=1 to 3 ; 60s total fight time.
;   ToolTip(" round ......"&$k);
; rebuf

Send("{4}")	
Sleep(100)
MouseClick("right")
Sleep(1000)
; we got man!
Send("{4}")	
Sleep(50)
send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(100);
send("{SHIFTUP}")
Send("{3}")	
Sleep(50)	  

Send("{2}")	
Sleep(100)

For $kk=1 to 2;  30s rebuf.
   
   MouseMove(740,250)
   For $righ = 1 to 40  ; 7 right
	  Send("{3}")	
	  Sleep(100)	  
   Next
   
   MouseMove(360,320)
   For $left = 1 to 18  ; 3s left
	  Send("{3}")	
	  Sleep(100)
	  ;MouseClick("right")
   Next
   
   Send("{4}")	
   
   Sleep(50)
   MouseClick("right")
   Sleep(50)
   send("{SHIFTDOWN}")
	   sleep(50);
	   MouseClick("left")
	   sleep(100);
   send("{SHIFTUP}")
   

Next

   MouseClick("right")
   Sleep(50)
   
Next
MouseMove(740,250)


Sleep(4000)

MoveFast(200,340)

   Send("{1 up}")	   
EndFunc




Func moveToPositionA1Q6()
	  Move(740, 250)
	   sleep(100)
	   ;send(2) ; spell add attack
	   sleep(1200);
	   
	   DEBUG("2")
	   Move(740, 250)
	   send(3) ; spell add attack .
	   sleep(1200);
	   
	   DEBUG("3")
	   Move(740, 250)
	  
	   sleep(1200);
	   	   
	   DEBUG("3.66666666")
	   Move(750, 200)
	   sleep(900);
	   
	   Move(765, 234)
	   sleep(600);
	   Move(600,250)
	   Sleep(100)
EndFunc



func fightBrokenBladeWDLevel($level)
   
   
   If($level<25)Then
	  ; for normal, under nightmare
	  
   Else
	  
   EndIf
   
   
   ; this is for normal,
   ;1 : spider, 2 : zombie dog   left: soul havest right: zombie hand.
   DEBUG("fight begin")
   ;Sleep(3000)
   
   send("{SHIFTDOWN}")
   
   MouseDown("left")   
   
   ;For $i= 0 to 2 ; total 60  second. or close.
	  For $j = 1 to 3	; switch range.			;7*3 = 21 second.
		 If($j==1)Then
			MouseMove(730,265,3) ; aggrasive
		 ElseIf ($j==2)Then
			MouseMove(420,300,3) ; protect
		 Else
			MouseMove(620,285,3)
		 EndIf
			Sleep(30)
		 For $k = 1 to 6 ; 6 second. actually sleep don't work so wel, it' like 7 second  or more.
		 MouseClick("right") ; zombie hand.
		 Sleep(1000)
		 Send("{1}")
		 Next
		 Move(430,300)
		 Send("{4}")
	  Next
   ;Next

   MouseMove(400,300,3)
   
   For $i= 0 to 4
   MouseClick("right") ; zombie hand.
   Next
   
   MouseUp("left")
   send("{SHIFTUP}")
   
   FindItem(6,2) ; 6for legend and rare, 2 for check time.
   Move(600,300)
   Sleep(1000)
   FindItem(6,2)
   


EndFunc


