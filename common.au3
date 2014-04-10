; commone

Func getLocationAndColor()
; for esc:   577,613 , 985d13
Local $pos = MouseGetPos()

Local $colorxy = Hex(PixelGetColor($pos[0],$pos[1]),6)

DEBUG("Mouse x,y: "&$pos[0] & "," & $pos[1] &"   color  "&$colorxy)
sleep(3999)
EndFunc


Func Click($x, $y)
       MouseClick('left', Random($x - 5, $x + 5), Random($y - 3, $y + 3), 1,Random(0, 1))
       Sleep(Random(20, 200))
EndFunc   ;==>Click


Func RightClick($x, $y)
       MouseClick('right', Random($x - 5, $x + 5), Random($y - 3, $y + 3),1, Random(0, 1))
       Sleep(Random(20, 200))
	EndFunc   ;==>RightClick
	

Func Move($x, $y)
       ;   MouseClick('middle', Random($x - 3, $x + 3), Random($y - 3, $y +3), 1, Random(0, 1))
      ; MouseClick('middle', $x, $y, 1, Random(0, 1));random(0,1) controls the moving mouse speed
      DEBUG("about to move to :   "&$x&"-"&$y)
	  MouseMove($x,$y,3)
	  Sleep(50)
	  ; i use space to move.
	  send("{space}")	;	 maybe config this move hotkey?
	  sleep((abs($x-400)+abs($y-300))*9) ; for sometimes it's too lag.

;   Sleep(Abs($x-400)/800 + Abs($y-300)/600)*1000
       ;   Sleep(Random(1500,1800))

EndFunc   ;==>Move

Func MoveFast($x,$y)
   MouseMove($x,$y,2)
   Sleep(30)
   send("{space}")	;	 maybe config this move hotkey?
   sleep((abs($x-400)+abs($y-300))*5) ; for sometimes it's too lag.
EndFunc

func MoveExact($x,$y,$delay)
   Move($x,$y)
   Sleep($delay)
EndFunc
   