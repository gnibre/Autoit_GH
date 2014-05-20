#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------


#include <ImageSearch.au3>
#include <Color.au3>


;Opt('MouseCoordMode', 0) ; 0 : relative relative coords to the active window

;Opt('PixelCoordMode', 0)  ;relative coords to the defined window

;640, 150, 800, 600
Global $windowl = 100
Global $windowt = 60
Global $GameWidth = 800
Global $GameHeight = 600
;Global $d3Width
;Global $d3Height
Global $titleSize = 36;			title size is 36
Global $boarder =9; ;   this is result of caculation, but also we can just made it the right value there.
Global $d3wx ; game window start from x ( no boarder)	; 109  (windowl+boarder)
Global $d3wy ; game window start from y ( no boarder)	;  96  (windowt+title)

Global $mid[2]				; midx = d3wx+ gwidth/2 = 109+400  = 509
						   ;   midy =  d3wy + gheight/2 = 96+300 = 396
Global $d3Window; window's handler




;getScreenStatus()
;getScreenStatus()

; Script Start - Add your code below here

;getPlayerStatus()

;$pS = getPlayerStatus()
;ToolTip("get status is : "&$pS);
;Sleep(1000);


;prepareForFight()

#cs

while 0
   
   If(isEHPBarStillThere())Then
	ToolTip("found!!!!")
	   Sleep(300)
 EndIf
 

   
   
   WEnd
   

#Ce







Func prepareForFight()


$active = WinActive('Diablo III')   
   If Not $active Then	  
   ToolTip(" diablo not active!!!!!!!!!!!!!!!!!!!",0,0)
   WinActivate('Diablo III')
   EndIf
	  
$x=0
$y=0

Sleep(2000)


For $i = 0 To 99

tooltip("loop  begin,   : "&$i,0,0)
Sleep(3000)

$res = _ImageSearch(".\img\f-ehpb-ful-n.png",1,$x,$y,30);default search whole screen. ; set option, not clicked.
ToolTip(" [fight]  , find normal enemy full hp bar, top ?  "&$res,0,0)
;Sleep(1000)
If($res)Then
   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   MouseMove($x,$y,3)
   sleep(1000)
EndIf



$res = _ImageSearch(".\img\f-ehp-tinyb-n.png",1,$x,$y,30);default search whole screen. ; set option, not clicked.
ToolTip(" [fight]  , find normal enemy tiny hp bar, on it ?  "&$res,0,0)
;Sleep(1000)
If($res)Then
   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   MouseMove($x,$y,3)
   sleep(1000)
EndIf





Next



EndFunc




;_ImageSearch(img,1,return_x,return_y,tolerance) ;  default search whole screen
;_ImageSearchArea(img,1, start_l,start_t,end_right,end_bottom, return_x,return_y,$tolerance)



; <10,in game;  >10 , main menu + ohter
;  9(ingame-ESC)
;  7(ingame, other, screen blocked
;	4(ingame-dead)
;	0 (normal)

; 11 main=resume
; 12 main=play
; 18, main= can still press setting , 
;19 , main= setting already pressed.
Func getPlayerStatus()   
   
   ; have to active or will get all nothing.
   activeD3Window()
$x=0
$y=0

MouseMove(400,300,3)

$res = _ImageSearch(".\img\st-ig-dead.png",1,$x,$y,25);default search whole screen. ; set option, not clicked.
;ToolTip(" got result from img search,  in game,  dead??   "&$res,0,0)
;Sleep(3000)
If($res)Then
   ;ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   ;MouseMove($x,$y,3)
   ;sleep(4000)
   return 4
EndIf


; move this very first because it's the most normal form , but main be confused while player dead.
$res = _ImageSearch(".\img\st-ig-set-n.png",1,$x,$y,35);default search whole screen. ; set option, not clicked.
;ToolTip(" got result from img search,  in game,  menu clear ?   "&$res,0,0)
;Sleep(3000)
If($res)Then
;   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
  ; MouseMove($x,$y,3)
  ; Sleep(5000)
 ;  sleep(1000)
 return 0
EndIf





$res = _ImageSearch(".\img\st-ig-esc-p.png",1,$x,$y,20);default search whole screen. ; set option, not clicked.
;ToolTip(" got result from img search,  in game, escpressed and paused  "&$res,0,0)
;Sleep(3000)
If($res)Then
   ; new leave game when esc pressed in game is 233,355
   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   MouseMove($x,$y,3)
   sleep(3000)
   return 9
EndIf


; blocked by something.
; can find it with lower tolerance, but not suggested to do so.
$res = _ImageSearch(".\img\st-ig-set-c.png",1,$x,$y,10);default search whole screen. ; set option, not clicked.
;ToolTip(" got result from img search,  in game,  menu clicked right ?   "&$res,0,0)
;Sleep(3000)
If($res)Then
   ;ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   ;MouseMove($x,$y,3)
   ;sleep(1000) 
   return 7
EndIf


; can press resume
$res = _ImageSearch(".\img\st-mm-resume.png",1,$x,$y,30);default search whole screen.
;ToolTip(" got result from img search,  in resume?   "&$res,0,0)
;sleep(2000)

If($res)Then
   ; new resume at 225,374
   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   ;MouseMove($x,$y,3)
   ; if we want to move from a result of imgsearch, we shall change it from global to relative.
   ;sleep(15000)
   
   return 11
EndIf



$res = _ImageSearch(".\img\st-mm-start.png",1,$x,$y,50);default search whole screen.

;ToolTip(" got result from img search,  in resume?   "&$res,0,0)
;sleep(2000)

If($res)Then
   
   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   MouseMove($x,$y,3)
   ; if we want to move from a result of imgsearch, we shall change it from global to relative.
   sleep(1000)
   
   return 12
EndIf


$res = _ImageSearch(".\img\st-mm-set-n.png",1,$x,$y,30);default search whole screen. ; set option, not clicked.
;ToolTip(" got result from img search,  in main menu ?   "&$res,0,0)
;Sleep(3000)
If($res)Then
   ;ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
   ;MouseMove($x,$y,3)
   ;sleep(1000)
   return 18 ;
EndIf


;$res = _ImageSearchArea(".\img\st-mm-set-c.png",1,$x,$y,10);default search whole screen. ; set option, clicked.
   


$res = _ImageSearch(".\img\st-esc-p.png",1,$x,$y,30);default search whole screen. ; set option, not clicked.
;ToolTip(" got result from img search,  in main menu , clicked??  ?   "&$res,0,0)
;Sleep(3000)
If($res)Then
;   ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
;   MouseMove($x,$y,3)
;   sleep(1000)
   return 19;
EndIf



return 29;  for other case, return , like we dont' really know where we are....

EndFunc


;sleep(3000);

Func getScreenStatus()
   activeD3Window()
   
   $size = WinGetClientSize("[TITLE:Diablo III; CLASS:D3 Main Window Class]")
   ToolTip("got client size of window info , :  "&$size[0]&" - "&$size[1],0,0)   
   
   
   sleep(100);
;   ToolTip(" desktop info : "&@DesktopWidth&"    -    "&@DesktopHeight)
;sleep(1500);
   
   
   
   
    ;WinMove( "Diablo III", "", 20, 20, 816, 638)
	
	WinMove( "Diablo III", "", $windowl, $windowt, $GameWidth, $GameHeight)
	
	sleep(100);
	
	$wSize = WinGetPos("Diablo III")
	
;	ToolTip("got winget pos of DIII  x,y :  "&$wSize[0]&" - "&$wSize[1]&"    and width-height :  "&$wSize[2]&"-"&$wSize[3],0,20)  
;	Sleep(3000)
	
	$boardsize = ($wSize[2]-$GameWidth)/2
	;ToolTip("got boarder size is : "&$boardsize,0,0)
;	Sleep(3000)
	
	;9
	
	$titleSize = ($wSize[3]-$GameHeight)-$boardsize;   height-bottom_board = title.
	
	;ToolTip("got $titlesize size is : "&$titlesize,0,0)
;	MouseMove($windowl,$windowt,3)
	;Sleep(5000)
   
   ;36
   
   ;start from is :
   
   $d3wx = $windowl+$boardsize;
   $d3wy = $windowt+$titlesize;
	
	
	
	$mid[0] = $d3wx+$GameWidth/2;
	$mid[1] = $d3wy+$GameHeight/2;
	
	;ToolTip("got real game start position is  : "&$d3wx&"  -  "&$d3wy,0,0)
	
	;109, 96
	
	;Sleep(5000)
	
	;ToolTip("got mid,of game play is : "&$mid[0]&"-"&$mid[1],0,0)
	
	;509 396
	
	;Sleep(5000)
	
;	MouseMove($d3wx,$d3wy,4)
;	Sleep(4000)
;	MouseMove($windowl,$windowt,4)
	
;	ToolTip(" IS mouse at the  very begining of the game window?????!!  l: "&$windowl&"-"&$windowt,10,10)
	
	
	
	
	
	
; if the botmain is set as coord relative to game window, every thing here is relative except $x,$y from search picture	
;	sleep(5000)
	
;	$pos = MouseGetPos()
;	ToolTip(" IS mouse pos return : !!  l: "&$pos[0]&"-"&$pos[1],10,10)
	
;   sleep(11000)
   
EndFunc



func activeD3Window()
   $active = WinActive('Diablo III')   
   If Not $active Then	  
   ToolTip(" diablo not active!!!!!!!!!!!!!!!!!!!",0,0)
   $d3Window = WinActivate('Diablo III')
   EndIf
EndFunc


;========================================content maybe for fighting.


Func tryFindEnemy($focusEnemy,ByRef $x,ByRef $y)

$tx=0
$ty=0

$res = _ImageSearch(".\img\f-ehp-tinyb-n.png",1,$tx,$ty,30);default search whole screen. ; set option, not clicked.
;ToolTip(" [fight]  , find normal enemy tiny hp bar, on it ?  "&$res,0,0)


If($ty>$windowt+450 )Then  ;  minimap from (815,304
   ;what you focused is not tiny bar, it's yourself's hp bar;
   $res=0
EndIf   

If($tx>$d3wx+700 And $ty<$d3wy+200) Then ; in  mini map
   $res = 0
EndIf


;Sleep(1000)
If($res)Then
   MouseMove($tx+20,$ty+30,1)
   ToolTip(" got target FROM TINY BAR!!!!  x, y is : "&$tx&" - "&$ty,$tx,$ty+10)
;Sleep(3000)

;   If($focusEnemy)Then
;	  MouseMove($tx+20,$ty+30,1); tiny bit below that bar./ right to that bar,
;   EndIf

;   sleep(1000)
   $x=$tx
   $y=$ty
   return 1
EndIf



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; loooking for the numbers of their current hp value.
;159-129-80 159  129 81 159 129 82 161 131 84 161 131 85   163 132 87   160 125 72    72 133 75  161 126  73   157 126 82

; i guess  will be  160-129-80  +-5

$coor = PixelSearch($windowl,$windowt,$windowl+700,$windowt+500,0xA08150,6) ; don't want minimap and bottom target,
If(Not @error ) Then
;   ToolTip(" got  0xA10F07 (489,136) at this position   : ("&$coor[0]&","&$coor[1]&") ",10,10)
   ; real mid is 509,
   $x = $coor[0]+10
   $y=$coor[1]+40
   MouseMove($x,$y,1)
   return 1;
EndIf



If(Random(0,100)>50)Then
    $x=$mid[0]
   $y=$mid[1]-50
   MouseMove($x,$y,1)
;If( tryFindEnemyAtThisPosition($mid[0],$mid[1]-50) )Then
;   $x=$mid[0]
;   $y=$mid[1]-50
   return 1
EndIf

#cs
; so , just try to find enemy around you is ok..
$step =25;

; as char's foot "stand" on mid of screen
If(tryFindEnemyAtThisPosition($mid[0]+$step,$mid[1]-$step-40))Then
   $x=$mid[0]+$step
   $y=$mid[1]-$step-40
			return 1
		 EndIf


If(tryFindEnemyAtThisPosition($mid[0]-$step,$mid[1]-$step-40))Then
   $x=$mid[0]-$step
   $y=$mid[1]-$step-40
			return 1
		 EndIf

If(tryFindEnemyAtThisPosition($mid[0]-$step,$mid[1]+$step-10))Then
   $x=$mid[0]-$step
   $y=$mid[1]+$step-10
			return 1
		 EndIf
		 
If(tryFindEnemyAtThisPosition($mid[0]+$step,$mid[1]+$step-10))Then
   $x=$mid[0]+$step
   $y=$mid[1]+$step-10
			return 1
		 EndIf
		 
#ce

return 0
EndFunc


#cs

search for the whole screen would not work, search picture is too slow.

$step =20
$stepy = $step
$stepx = $stepy*4/3 

   for $n = 2 to 13
	  If(Mod($n,2)==1)Then
		 ContinueLoop
	  EndIf
	  
	  
	 ToolTip("looking for enemy,  loop : "&$n,10,10);
	  ; | _ |  -
	  
	  ; draw line of square ,left 
	  ;x = -1*$sx , $y = 
	  
	  $x =  $mid[0]- $n*$stepx
	  for $line1= -$n to $n
		 
		 $y =  $loc[1] +$line1*$stepy  ;  up to down draw the  |
		 if(tryFindEnemyAtThisPosition($x,$y))Then
			return 1
		 EndIf
		; sleep(50) ; sleep before keep moving
	  Next
	  
	  
	  $y = $mid[1]+$n*$stepy
	  for $line2 = -$n to $n
		 $x = $loc[0] +$line2*$stepx			;   left to right ,   draw the _
		 if(tryFindEnemyAtThisPosition($x,$y))Then
			return 1
		 EndIf
		 ;sleep(50) ; sleep before keep moving
	  Next
	  
	  
	  $x =  $mid[0]+ $n*$stepx
	  for $line3= -$n to $n
		 $y =  $loc[1] -$line3*$stepy  ;  down to up , draw the  |
		 if(tryFindEnemyAtThisPosition($x,$y))Then
			return 1
		 EndIf
		 ;sleep(50) ; sleep before keep moving
	  Next
	  
	  
	  
	  $y = $mid[1]-$n*$stepy
	  for $line4 = -$n to $n
		 $x = $loc[0] -$line4*$stepx			;   right to  left ,   draw the - top lane
		 if(tryFindEnemyAtThisPosition($x,$y))Then
			return 1
		 EndIf
		 ;sleep(50) ; sleep before keep moving
	  Next
   Next


#ce


Func tryFindEnemyAtThisPosition($x,$y)
   MouseMove($x,$y,1) ; 1 is almost fastest, 0 is instant, slowest is 100;
   sleep(50) ; sleep before can identify 
   return isEHPBarStillThere()
   
;   $rr= isEHPBarStillThere()
;   If($rr)Then
;	  ToolTip("got enemy from WHERE I MOVE MOUSE AND FOUND STANDARD HP BAR ,  mouse is here : ",$x,$y)
;   EndIf
;   return $rr
EndFunc


; calc time for running a pic search is like , cost, 60ms,  you can do roughly 16times, in a second.
func isEHPBarStillThereOld()
;	$res = _ImageSearch(".\img\f-ehpb-ful-n.png",1,$x,$y,50);default search whole screen. ; set option, not clicked.
   
   ; narrow the search area.  200,150,
 ;  MouseMove($windowl+400,$windowt+300,4);
   $xx=0
   $yy=0

   
;Next

;$res = _ImageSearchArea(".\img\f-ehpb-ful-n2.png",1, $windowl+100,$windowt+40,$windowl+400,$windowt+120,$xx,$yy,40); ;560,230 like +200,

;it's the exact loc of enemy hp pic sample position, we don't change to speed up search ; toleration of 40 is neccesary

   ;$rt = TimerInit()
  ; For $i= 0 to 99
	  ; the problem is that, no matter how small you make your picture and your seach range, the function will take like 160ms to cal once. TOOOOOOO SLOW
;$res = _ImageSearchArea(".\img\f-ehpb-mid-red.png",1,$d3wx+379,$d3wy+34,$d3wx+381,$d3wy+46,$xx,$yy,40); ;560,230 like +200,
;Next


$posx = $d3wx+380;
$posy = $d3wy+40;




$decimal = PixelGetColor($posx,$posy)
$colorxy = Hex($decimal,6)
ToolTip(" got from location (489,136), value is   :  d: "&$decimal&"   hex:  "&$colorxy,  0,30)

;if have hp, it's :  A10F07 
;if don't have hp,  it's 2a2b2a



$decimal = PixelGetColor($posx,$posy)
$colorxy = Hex($decimal,6)
ToolTip(" got from location (489,137), value is   :  d: "&$decimal&"   hex:  "&$colorxy,  0,40)


$decimal = PixelGetColor($posx,$posy)
$colorxy = Hex($decimal,6)
ToolTip(" got from location (489,137), value is   :  d: "&$decimal&"   hex:  "&$colorxy,  0,40)

Sleep(3000)


 ; the mid of pic found is loc at : 489,136,  so the picture of 2*12 is range from ( 488, 130,490,142)

; windowl = 100 , windowt = 60, title = 
;found at position : 489 136.
; d3wx = 109, d3wy= 96 ,   the position is d3wx+380,  d3wy+40



; color compre time each calc is about  20-40 ms, much faster than 
$rt = TimerInit()
  For $i= 0 to 99
   $decimal = PixelGetColor($posx,$posy)
   $colorxy = Hex($decimal,6)
   
   $allColor = _ColorGetRGB($decimal)
   
  
   $red = $allColor[0]
   $green = $allColor[1]
    $blue = $allColor[2]
	
Next

$srt = TimerDiff($rt)
ToolTip(" 100 time's found ehpbar- pixar an compare value, cost time in mili : "&$srt,0,0)
Sleep(5000)






#cs
   If($res)Then
	  ToolTip(" ehp bar found here: ",$xx,$yy)
	  
	  ToolTip("write this down:   ehp-red found position  :    x-y : "&$xx&"-"&$yy)
	  Sleep(10000)
   Else
	  ToolTip("not found",0,0)
	  Sleep(300)
   EndIf
   
#ce


	  
   ;report location found it.
   
   ;640, 150
   ;ToolTip(" [fight]  , find normal enemy full hp bar, top ?  "&$res,0,0)
;Sleep(1000)
   ;If($res)Then
	  ;ToolTip(" got target x, y is : "&$x&" - "&$y,0,0)
	  ;MouseMove($x,$y,3)
	  ;sleep(1000)
   ;EndIf
  ; return $res;
   
EndFunc




Func isEHPBarStillThereOld2()
   
   
$posx = $d3wx+380;
$posy = $d3wy+40;
$decimal = PixelGetColor($posx,$posy)

$allColor = _ColorGetRGB($decimal)
      $red = $allColor[0]
   $green = $allColor[1]
    $blue = $allColor[2]

If( $red==161 ) Then
   If($green==15 ) Then
	  if($blue==7 )Then		 
		 return True
	  EndIf
   EndIf
EndIf

If( $red==42 ) Then
   If($green==43 ) Then
	  if($blue==42 )Then		 
		 return True
	  EndIf
   EndIf
EndIf


If( $red==193 ) Then
   If($green==46 ) Then
	  if($blue==41 )Then		 
		 return True
	  EndIf
   EndIf
EndIf


ToolTip(" NOT FOUND!! color(n161-15-7)(r193-46-41)((42,43,42) at (489,136) is  :   "&$allColor[0]&"-"&$allColor[1]&"-"&$allColor[2],10,10)
			;( r empty , 55-58-55
sleep(3000)


; if we take (508,132)--verymid, value for rare empty is 22-14-5 ; normal empty is 0-0-0 (full and empty)


$coor = PixelSearch($posx-5,$posy-10,$posx+5,$posy+10,0xA10F07,0)
If(Not @error ) Then
   ToolTip(" got  0xA10F07 (489,136) at this position   : ("&$coor[0]&","&$coor[1]&") ",10,10)
   ; real mid is 509,
EndIf

$coor = PixelSearch($posx-5,$posy-10,$posx+5,$posy+10,0x2a2b2a,0)
If(Not @error ) Then
   ToolTip(" got  0x2a2b2a (489,136) at this position   : ("&$coor[0]&","&$coor[1]&") ",10,10)
EndIf


return False
;ToolTip("got ALL color, (A1 0F 07) /(161-15-7) ||(2A 2B 2A) /(42,43,42)  red-blue-green are:    "&$allColor[0]&"-"&$allColor[1]&"-"&$allColor[2],10,10)
;Sleep(1000)

;if have hp, it's :  A10F07 
;if don't have hp,  it's 2a2b2a
EndFunc





Func isEHPBarStillThere()
;for normal, at (509,131) ,   bar side (hp full)/hp-empty  color is 57-48-41
;for normal , at (509,132) , bar side (hp full)/hp-empty  color is 0-0-0
; use both to make sure it's an normal creap.


; for rare at (509,131),  empty/hp full, is : 144-104-44
; for rare at (509,132),  empty/hp full , is : 22-14-5 ,

; for champion at (509,132) , empty/			is 23-25-28
;for champion at (509,131) empty /				is 108-115-129

; maybe we can try 509,140...?

$posx = $d3wx+400;   509 ; d3wx = 109
$posy = $d3wy+36;	132	; d3wy = 96 ,
$decimal = PixelGetColor($posx,$posy)

if($decimal==0)Then
   $dec2 = PixelGetColor($posx,$posy-1)  ; (509,131)
   If($dec2==0x393029)Then	  ;57-48-41
	  Return True
   EndIf
EndIf


if($decimal==0x160E05)Then			;22-14-5
   $dec2 = PixelGetColor($posx,$posy-1)  ; (509,131)
   If($dec2==0x90682c)Then	  ;144-104-44
	  Return True
   EndIf
EndIf

ToolTip(" NOT FOUND!! at (509,132) is  :   "&Hex($decimal,6),10,10)
sleep(3000)

Return False
   
EndFunc




Func transferFromRelativeToRealWindowPosition($relative)
   Local $real[2]
   $real[0] = $relative[0]+$d3wx
   $real[1] = $relative[1]+$d3wy
   return $real
EndFunc


Func transferFromRealWindowToRelativePosition($real)
   Local $relative[2]
   $relative[0] = $real[0]- $d3wx
   $relative[1] = $real[1]- $d3wy
   return $relative
EndFunc
