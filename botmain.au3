#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         gnibrE
 Script Function:
	main function of a bot,   will call other auto-function for :
	0 [done] window move.?
	1 [done] game status detect: mainscreen/ingame/dead/other
    2  charater's common job
		 2.1 differ classes? found different script?			
		 2.2 repair /check bag, and trash sell?  
		 2.3 
	================  stuff will vary for the task we run, use different files to run.=========================
	3 fight-common / fight specified route
	  2.1 find enemy near by.  
			a, by tiny hp bar,  find from the entire screen,slow, but when we find , it's easy to locate the enemy,
			   the good thing is that: as long as you got a pet alive with you, pet will find enemy and make this happen and keep going.
			b, by searching nearby , use auto attack nearby enemy skill for melee, aoe fight for ranged.
			c, by moving your corsor randomly/brutal , but we shall check the pixel value near top of the screen to make sure if it's a hp bar (thus an enemy), 
			   it's too slow , when we found it , it's almost gone( can't catched by left click as a melee)
	4 loot, find item / collect 
	  3.1 find legendary and Set
	  3.2 fidn rare and things we want,
	  3.3 put them to stash.

   5 route
	  5.1 for the targeted route. never changed.
   6 config ini for everything. keep them clean.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#include <sub.au3>			; body of the au3 will be called at the time they are included. 
#include <allStatus.au3>	; so,keep these libs clean.
#include <lootAndItems.au3>
#include<A1Q1.au3>
#include<A1Q6.au3>
#include<A1Q32.au3>
#include<A2Q72.au3>
#include<A3Q33Ghom.au3>
#include<common.au3>

Opt('MouseCoordMode', 0) ; 0 : relative relative coords to the active window
Opt('PixelCoordMode', 0)  ;relative coords to the defined window

HotKeySet('{F11}', 'Pause')
HotKeySet('{F6}', 'Quit')
HotKeySet('{F8}','Tests')
HotKeySet('{F7}','getLocationAndColor')

Global $DebugOn = True
Global $Paused=False;
Global $class = 3;  -1 unknow;  0 bar, 1 wizard , 2 dh , 3 wd , 4 monk
Global $playerStatus = 29; don't know where we are.
Global $repairError = 0;
Global $Level = 10; lowlevel
Global $repairTooMuchError = 0

Global $machineID = 1; 1 for pc at cacs.
; begins here.

getScreenStatus();  prepare our workign screen before start.

; <10,in game;  >10 , main menu + ohter
;  9(ingame-ESC)
;  7(ingame, other, screen blocked
;	4(ingame-dead)
;	0 (normal)
 
; 11 main=resume
; 12 main=play
; 18, main= can still press setting , 
;19 , main= setting already pressed.  
;getPlayerStatus()

;loadInIConfigs() ;  before this is done , we manual config ....
$class = 3;  1 for wizard. 3=wd
  
;   fightBridgeAndLoot()
 

Pause()  ;


;ManglemawStay();
;A2Q72SSXXGO()

;BBShuaA1Q6()
;WDUPA1Q6ZL()
;MKUpGradeA1Q1()
 ;moveToQuest()
 
;WDUpGradeA1Q1()

;3330, ghom, champaign mode, start from last time killed ghom better, all need picture recg
Global $selectedContentType =3330;  say: 3330 means act 3, chapter3, quest 3, code 0;
Global $act=2; // related to gear repair,  teleport entrance;
Global $needselectQuest=False;
Global $startGameResumeOnly = 0; 0 for anything, 1 for yes,resume only;
Global $needWayPoint=False;
$needStash = 5;
$runBeforeNextStash=24;




;================================================================================run selected contnet;
mainEntryForAllLoop();


; common loop for most target, use selected content;
Func mainEntryForAllLoop()
   initWithSelectedContent()
While 1
   ; sometimes we need to select some task, so we have to select certain quest like Ghom.
   makeSureWeAreInMainMenu()

   If($needselectQuest) Then
	  selectRightQuest()
   EndIf

   makeSureWeAreInGame($startGameResumeOnly)
	  
   If($needStash<1) Then
	  
	SellAndIDAndStash()
	tryQuitGameToMenuFromInGame()
	$needStash =$runBeforeNextStash
	ContinueLoop
   EndIf
 
 ; most of time, cause we do stash and repair, we don't need this.
   ;If(tryCheckFixGearFromBornPlace())Then
	  ; we shall got repair done here.
	;  tryQuitGameToMenuFromInGame()
	;  ContinueLoop
   ;EndIf 
   
   
   
   $needStash = $needStash -1;
   
   If($needWayPoint)Then
	  goWayPoint()
   Else
      ; to the portal; this name is saved .. move to cellar => use checked point tp;
	  MoveToCellar()
   EndIf

   
   Sleep(200) ; wait  for slow tp
   
   DEBUG("begin fight---------")
   Sleep(3000)
   
   ; use select content fight, check function content to see what do we fight;
   fightCommon()
   ;106 for all, 105 for legonly;
   pickupCommon(106)
   
   tryQuitGameToMenuFromInGame()   
WEnd

   
EndFunc


Func fightCommon()
   If($selectedContentType==3330) Then
	  fightGhomCrusader();
   EndIf
EndFunc

;530,425


;3330 for ghom.
Func initWithSelectedContent()
   
   If($selectedContentType==3330) Then
	  $needselectQuest = True;
	  $startGameResumeOnly = 0;
	  $needWayPoint = True
	  $runBeforeNextStash = 9;
	  DEBUG(" ghom quest found; ")
	  Sleep(100)
   EndIf
   
   $act = Int($selectedContentType/1000)
   ;Mod($selectedContentType,1000);
   DEBUG(" act to go is "&$act&" rest is :"&$selectedContentType)
   Sleep(100)   
EndFunc


Func selectRightQuest()
   ;common one, hit game setting first;
   MouseMove(168,350,3)
   MouseClick("left")
   Sleep(200)
   ; common #2, hit act Select
   MouseMove(424,213,3)
   MouseClick("left")
   Sleep(200)
   
   If($selectedContentType==3330) Then
	  DEBUG(" ghom quest found;; let's do it; ")
	  mainMenuSelectGhomQuestUniversal()
   EndIf
   
   Sleep(200)
   ; for all quest select,  we click ok and save here;
   MouseMove(346,460,3); ok button
   Sleep(200)
   MouseClick("left")
   Sleep(200)
   Send("{Enter}")
   Sleep(200)
   
   MouseMove(322,510,3); save&close button
   Sleep(200)
   MouseClick("left")
   Sleep(200)
   
EndFunc

Func goWayPoint()
   
   DEBUG(" ghom wya point")
   Sleep(1000)
   
   Send("{M}")
   
   If($selectedContentType==3330) Then
	  DEBUG(" ghom quest         way piont;")
	  Sleep(200)
	  
	  ;keep of depth: 
	  MouseMove(256,462,300)
	  Sleep(1500)
	  MouseClick("left")
	  Sleep(5000)
   EndIf
   
EndFunc



; try use pic found so even when we can't use hard code, we still find the quest;
Func mainMenuSelectGhomQuestUniversal()
   $qx=-1
   $qy=-1
   
   ; when using picture search, we have "shift" for these position in this package;
   ; cause pick search use global position for x,y;
   $res = _ImageSearch(".\img\quest33n-ghom1.png",1,$qx,$qy,30);default search whole screen. ; set option, not clicked.
   If($res)Then
	  ToolTip(" got target x, y is (GLOBAL/absolute): "&$qx&" - "&$qy,0,0)
	  Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
	  MouseMove($qx,$qy,3)
	  ;switch back, for latter develop;
	  Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
	  Local $pos = MouseGetPos()
	  $qx=$pos[0]
	  $qy=$pos[1]
	  DEBUG("back to main Mouse x,y: "&$qx & "," & $qx)	  
	  sleep(1000)
	  
	  ; click q3,
	  MouseClick("left")
	  Sleep(400)
   Else
		 MouseMove(530,425,3)
		 Sleep(200)
		 MouseClick("left")
		 Sleep(200)
		 MouseClick("left")
		 Sleep(200)
		 MouseClick("left")
		 Sleep(200)
		 
		 ; we search q32, cause if q33 finished, q34 will be highlight, if not finished, q33 is highlighted
		 ; only q32 is always stable, 		 
		 $res = _ImageSearch(".\img\quest33a-ghom1.png",1,$qx,$qy,30);default search whole screen. ; set option, not clicked.
		 If($res)Then
			ToolTip(" got target x, y is (GLOBAL/absolute): "&$qx&" - "&$qy,0,0)
			Opt("MouseCoordMode", 1) ;1=absolute, 0=relative, 2=client
			MouseMove($qx,$qy,3)
			;switch back, for latter develop;
			Opt("MouseCoordMode", 0) ;1=absolute, 0=relative, 2=client
			Local $pos = MouseGetPos()
			$qx=$pos[0]
			$qy=$pos[1]
			DEBUG("back to main Mouse x,y: "&$qx & "," & $qx)
		 EndIf
   EndIf
	  
	  
	  If($qx<0)Then
		 ; hard code it?
	  DEBUG(" have to go hard coded ghome quest.  ")
	  Sleep(1000)  
	  $qx=402
	  $qy=370
   Else
	  EndIf
   
   ;click q3 only when q3 is not active
   
   ; click q3-3
   $qy=$qy+60;    402,430;
   MouseMove($qx,$qy,3)
   sleep(400)
   MouseClick("left")
   Sleep(400)
   
EndFunc



Func A2Q72SSXXGO()


   ; make sure act 
   $act=2
   
While 1
   
   makeSureWeAreInGame(1)

   If(tryCheckFixGearFromBornPlace())Then
	  ; we shall got repair done here.
	  tryQuitGameToMenuFromInGame()
	  ContinueLoop
   EndIf 
   
   
   If($needStash<1) Then
	  
	SellAndIDAndStash()
	tryQuitGameToMenuFromInGame()
	$needStash =20
	ContinueLoop
   EndIf
   
   $needStash = $needStash -1;
   
      ; to the portal
   MoveToCellar()   
   Sleep(200) ; wait  for slow tp
   fightSSXXWZ(); // in a2q72 file;
   
   ;106 for all, 105 for legonly;
   MoveFast(506,376);
   ; beam legendary only: 5
   pickupNoMove(106)
   tryQuitGameToMenuFromInGame()   
WEnd
EndFunc



;a3,q2, save the checkpoint at chancellor's tomb ;stable cause it don't change;
; in file A1Q32.au3;
Func ManglemawStay()
   
While 1
   makeSureWeAreInGame(1)

   If(tryCheckFixGearFromBornPlace())Then
	  ; we shall got repair done here.
	  tryQuitGameToMenuFromInGame()
	  ContinueLoop
   EndIf 
   
      ; to the portal
   MoveToCellar()   
   Sleep(200) ; wait  for slow tp
   
   moveToPositionDoorLevel2()
   Sleep(1000) ; wait  for slow tp
   
   
   fightManglemawWZ()
   ;fightManglemawWD()
   
   
;106 for all, 105 for legonly;
   pickupNoMove(105);
   tryQuitGameToMenuFromInGame()   
WEnd
EndFunc


Func BBShuaA1Q6()
While 1
   
   makeSureWeAreInGame(1)
   
   If(tryCheckFixGearFromBornPlace())Then
	  ; we shall got repair done here.
	  tryQuitGameToMenuFromInGame()
	  ContinueLoop
   EndIf 
   
   ; to the portal
   MoveToCellar()   
   
   Sleep(5000) ; wait  for slow tp
   
   ; buf.   
   ;Send("{4}")
   ;Sleep(600)
   ;Send("{2}")
   ;Sleep(100)
   
   ;
   moveToPositionA1Q6Fast()
   
   ;fightBrokenBladeBB60()
   fightBrokenBladeMonk60()
   ;fightBrokenBladeWDLevel($level)
   
   ;fightBrokenBladeCS60()
   
   ToolTip("fight over! loot",0,0);
	  Sleep(1000)
   
   
   
   ;find items incude rare...
     
   pickupAll()
   
   ;pickupLegOnly();
   
   ;goHomeAndPutToStash()
   tryQuitGameToMenuFromInGame()
WEnd

EndFunc



   
Func pickupCommon($c)
   
   ; pickup where we are;
   FindItem($c,2)
   
   FindItem($c,2)
   
   ; addtional pickup, move to potential position.
   If($selectedContentType==3330) Then
	  FindItem($c,3)
	  FindItem($c,3)
	  FindItem($c,3)
	  MoveFast(296,364)
	  FindItem($c,3)
   Else
	  ;106 for all, 105 for legonly;
	  MoveFast(506,376);
	  ; beam legendary only: 5
	  FindItem($c,2)	  
	  MoveFast(400,290)
	  FindItem($c,2)
   EndIf
   
EndFunc

   

Func pickupAll()
   
   FindItem(106,2)   
   MoveFast(120,420)
   FindItem(106,2)
   MoveFast(120,420)
   FindItem(106,2)
   MoveFast(120,420)
   FindItem(106,2)
   MoveFast(120,420)
   FindItem(106,2)
   
   

EndFunc


Func pickupLegOnly()
     FindItem(105,2)   
   MoveFast(120,420)
   FindItem(105,2)
   MoveFast(120,420)
   FindItem(105,2)
   MoveFast(120,420)
   FindItem(105,2)
   MoveFast(120,420)
   FindItem(105,2)
EndFunc

Func WDUPA1Q6ZL()

While 1
   
   makeSureWeAreInGame(1)
   
   If(tryCheckFixGearFromBornPlace())Then
	  ; we shall got repair done here.
	  tryQuitGameToMenuFromInGame()
	  ContinueLoop
   EndIf 
   
   ; to the portal
   MoveToCellar()
   
   
   ; dogs.
   Sleep(5000) ; wait for slow tp
   Send("{2}")
   Sleep(60)
   
   ;
   moveToPositionA1Q6()
   
   fightBrokenBladeWDLevel($level)
   
   ;goHomeAndPutToStash()
   tryQuitGameToMenuFromInGame()
WEnd
EndFunc


 
Func D3AutoWZA1Q6zlMain()
; main loop
While 1
   ;DEBUG("entering while loop, we don't have count....")
   
   ; each loop is a complete run , 
   ; if we are not sure we are ingame, we will not get out of this function.
   ; and we all ways try to make sure it's a new loop,

   makeSureWeAreInGame(1)
   
   If(tryCheckFixGearFromBornPlace())Then
	  ; we shall got repair done here.
	  tryQuitGameToMenuFromInGame()
	  ContinueLoop
   EndIf 
   
   
   ; make sure we are at the right place by location/picture search? 
   ; find config to load the function we want? 
  ; fightBrokenBlade() ; my very first script can do this. this one.
      
   buffYourSelf()
   findBridgeBeforeFight()
   fightBridgeAndLoot()

   ; we can put here because when we repair things , it's alwasy end of the loop.
      
   goHomeAndPutToStash()
   tryQuitGameToMenuFromInGame()
WEnd

EndFunc



Func fightBrokenBlade()
If($class==1)Then
   fightBrokenBladeWizard()
Else 
   If($class==3)Then
   fightBrokenBladeWDLevel($level)
   Else
   EndIf
   
   ;fightBrokenBladeBarbar()
EndIf
EndFunc

Func fightBrokenBladeWizard()
   
    MoveToCellar()
	
	MoveToFightingFrontLIneAndBuffed()
	;fightBridgeAndLoot()
EndFunc

Func fightAnyTrialAccountFight()

$loopCount =1
$pstatus =1
$punchBegined = 0
$enemyHPBarExist = 0
$ex = $windowl+400;
$ey = $windowt+300;

While 0
   ; we try to do 1-4 loops in each real world second time
    Send("{1 DOWN}")
   If(Mod($loopCount,100)==1)Then
	  activeD3Window()
   EndIf
   
   ToolTip("loop ,  count:  "&$loopCount,0,0);
   
   If(Mod($loopCount,50)==0)	  Then
	  ; check player status each 5 loop,	  
	  
	  ; <10,in game;  >10 , main menu + ohter
;  9(ingame-ESC pressed.)
;  7(ingame, other, screen blocked)
;	4(ingame-dead)
;	0 (normal)
	  $pstatus = getPlayerStatus();
	  ToolTip("player playing status is :  "&$pstatus,0,0);
	  sleep(2000)
   EndIf   
   $enemyHPBarExist = isEHPBarStillThere()
      
   If($enemyHPBarExist)Then
	  ToolTip(" target still found, (maybe not near mouse course) !!  ",10,10)
	  
	If($punchBegined)Then
		 ToolTip(" keep punching... dont' move mouse !  ",10,30)
		 ; left mouse keep , pressed
;		 sleep(100);
		; send("{1 5}" )	; press 1 key for 5 times
		; Sleep(50)
	  Else
		 
		;  send("{1 3}" )
		; Sleep(50)
		
;		 MouseDown("left")
		; MouseMove($mid[0],$mid[1],5) ; click fight and move mouse back to mid , as we dont' want to control movement of character.
;		 sleep(50)

	  EndIf
   Else
	  ToolTip(" target can't found, need to fidn new one , start from already exsit tiny hp bar, then search from nearby !!!",10,10)
	  MouseUp("left"); incase.
	  $punchBegined = 0;
	  $enemyHPBarExist =0
	  
	  ;Sleep(3000)

		 ;Sleep(200)
		 
		 If(tryFindEnemy(True,$ex,$ey))Then ;
			
			; enemy found is a suspect, as we can't make sure by img search ,kinda too slow, we do again to make sure.
			
			MouseMove($ex,$ey,1)
			Sleep(50)
			
			If(isEHPBarStillThere())Then
			   MouseDown("left")
			   $punchBegined=1;
			   $enemyHPBarExist=1;
			   ;   EndIf
			   ToolTip(" enemy found!!!!    punching. begin.. ,here:  ",$ex,$ey)	
			   Sleep(50)
			   
			Else
			   ; for melee hero like bar and monk , we got ability that will auto attack near by enemy, or even enemy near the play where the cursor is when skill pressed.
			   ; so , it's kind of easy to do so if the skill is energy consumeless
			   
			   send("{1 DOWN}");  we dont' like "left click" because it will make us move and pickup and something .
			   Sleep(300)
			   Send("{1 UP}")			
			EndIf
		 EndIf
		 
		 If($punchbegined==0)Then
			ToolTip(" enemy NOT found!!!!============================",10,30)
	   ;	 $punchBegined=0;
	   ;	 $enemyHPBarExist=0;
			
			If(Mod($loopCount,5)==0)Then
			   MouseMove(600,200,3)
			;   Send("{space}")
			   Sleep(500)
			EndIf
		 
		 EndIf
   
   
   EndIf

; no enemy found yet, got find one.
	
;	$enemyHPBarExist = isEHPBarStillThere()
	
	
	
   
  ; Sleep(500)
 ;  Sleep(5000)
   $loopCount = $loopCount+1
   
   Sleep(50)
   
   Send("{1 UP}")
   
WEnd
EndFunc


;======================================================================================================
;==================================  common functions below   =========================================
;======================================================================================================

; <10,in game;  >10 , main menu + ohter
;  9(ingame-ESC) ; !! or maybe main menu esc.
;  7(ingame, other, screen blocked
;	4(ingame-dead)
;	0 (normal)

; 11 main=resume
; 12 main=play (not implement , will actully return 18)
; 18, main= can still press setting , 
;19 , main= setting already pressed.
;getPlayerStatus()

; input 0 as default, 1 as only resume.
Func makeSureWeAreInGame($resumeOnly)
   DEBUG("run:  --makeSureWeAreInGame() , $playerStatus: "&$playerStatus)
   Sleep(200)
   
   $inMenu =0;
   ; resume are always ok.
   If($playerStatus==11)Then
		 $inMenu = 1;
   EndIf
   
   If Not ($resumeOnly==1)Then
	  ; resume or play
	  ; play	  
	  If($playerStatus==12)Then
		 $inMenu = 1;
	  EndIf
   EndIf
   
   
   While Not ($inMenu==1)
	  makeSureWeAreInMainMenu()
	  
	  If($playerStatus==11)Then
		 $inMenu = 1;
	  Else
		 $inMenu = 0;
	  EndIf
   
	  If Not ($resumeOnly==1)Then
	  ; resume or play
	  ; play
	  If($playerStatus==12)Then
		 $inMenu = 1;
	  EndIf
	  EndIf
   
   WEnd   
   
   
   DEBUG("run:  status 11!!! we are confirmed to be in main menu!!! $playerStatus: "&$playerStatus)
   Sleep(1000)
   
   ; now we are in main menu and everything is clear. we try to click resume.   
   While Not ($playerStatus==0)
	  DEBUG("run:  --try to click resuem and wait to be ingame.,  $playerStatus :"&$playerStatus)
	  Sleep(4000)	  
    If($playerStatus==29)Then
	   Sleep(4000)
	EndIf
	If($playerStatus==29)Then
	   Sleep(3000)
	EndIf
	If($playerStatus==29)Then
	   Sleep(2000)
	EndIf
	
	If($playerStatus==0)Then
	   ExitLoop
	EndIf
	  
	If($playerStatus==11 Or $playerStatus==12)Then
	   
	   
	   ;Click(134, 255) ;resume ; new position is 
	   Click(143, 318) 
	   Sleep(15000)	; slow machine need 10 sec to be in game.
	   $playerStatus = getPlayerStatus()
	Else
	   
	   DEBUG("WARNING, WE ARE SENDING BACK TO MAIN> !!  $playerStatus :"&$playerStatus)
	   Sleep(3000)
	   makeSureWeAreInMainMenu()
	EndIf
   WEnd ; while loop waiting to be ingame.
   
   Sleep(2500) ; even we are ingame, try to sleep or maybe we still can't move.
EndFunc



Func makeSureWeAreInMainMenu()
$playerStatus = getPlayerStatus()
; supposted to be in main ,11,  as when this function si called , we supposted to just end another success running.
DEBUG("run:  --makeSureWeAreInMainMenu() , $playerStatus(11 is ): "&$playerStatus)
Sleep(600)

$count =3;
While Not ($playerStatus==11 Or $playerStatus==12)
   $playerStatus = getPlayerStatus()
		 DEBUG("run:  --makeSureWeAreInMainMenu() , $playerStatus(in while ): "&$playerStatus)
		 Sleep(3000)
		 
   ; can 12(play) work?   if it can i guess when can config this.
   ; here jsut suppose not.
   
   ;ToolTip("makeSureWeAreInMainMenu;got current playing status, it's :  "&$playerStatus,0,0)
   ;Sleep(3000)
   If($playerStatus==29)Then
	  ;as we dont' know the status it is , we try to wait
	  If($count>0)Then
		 Sleep(3000)		 
		 $count=$count-1;
	  Else
		 Send("{ESCAPE}")
		 Sleep(1000)
	  EndIf
	  ;Sleep(100)
 EndIf
 
   If($playerStatus==9)Then
   ; we got esc pressed. we dont' know where it's from, we press esc agian to see.
	  ;Send("{ESCAPE}")
	; Sleep(1000)
 EndIf
 
   
   If($playerStatus>17)Then
	  ; for case 18 or 19 or even 29, anyway , we are safe to press ESC and we will not exit game(not 11,12).
	  Send("{ESCAPE}")
	  Sleep(1000)
	  $playerStatus = getPlayerStatus() ; got status again after short sleep
	  ;ContinueLoop ; continue after we pressedagain.
   Else
	  ; for case under 11,  it's already in game,
	  ; ingame is our target, but not now, we want a new loop, we dont' want previous one.	  
	  DEBUG("this game is not what we want, we try exit to create new one! ")
	  Sleep(3000)
	  tryQuitGameToMenuFromInGame()
   EndIf
   
   Sleep(100)
   $playerStatus = getPlayerStatus()
   
WEnd   
EndFunc   ; =>makeSureWeAreInMainMenu()


Func tryCheckFixGearFromBornPlace()
   ;$repair2 = PixelSearch(569, 39, 597, 84, 0xFFEF00)
   
   $repair = PixelSearch(569, 39, 597, 84, 0xFFF000,3)
   ;searches top right screen for yellow of broken armor
              ;If ((Not @error) Or CheckInv()) Then
            If(Not @error ) Then; Not check inv every certain time
			   ;DEBUG("need repair , "&$repairTooMuchError)
			   ;Sleep(5999);
			   
			   ; if this function got error, i still want it to run, ; so use this to prevent from repair and quit game each time.
			   If($repairTooMuchError >1)Then
			   ; if this value >0, it's still in cool down
				  $repairTooMuchError = $repairTooMuchError-1;
				  return 0
			   EndIf
			   
			   ;DEBUG("doing repair")
			   ;Sleep(5999);
			   
			   $repairTooMuchError =8;			   
			   InvRepairFromBorn()             
			   ;at least we moved.
			   return 1
			EndIf
			
			 ;testthis.
			   ;cool down in process if don't need repeir.
			$repairTooMuchError = 0;
			return 0
EndFunc


Func InvRepairFromBorn()
   fromBornToVendor()
   
      Click(295, 365)  ; click repair button.
   Sleep(Random(800, 1600))
   
      Click(186, 326) ;button to pay for repairs
   Sleep(Random(100, 600))
   
   Send("{ESCAPE}")
   Sleep(Random(100, 200))
   
   
EndFunc

Func fromVendorToStash()
If($act==1) Then
	  fromVendorToStash1()
   ElseIf($act==2) Then
	  fromVendorToStash2();
   ElseIf($act==3) Then
	  fromVendorToStash3();
   EndIf
EndFunc


Func fromVendorToStash1()
   DEBUG("--------------------------------------------NO fromVendorToStash1 FUNCTION");
   Sleep(200000000)
EndFunc


Func fromVendorToStash2()
   MoveExact(35,151,2000)
   Sleep(3000)
   mouseMove(250,371,3)
   Sleep(500)
   MouseClick("left")
   Sleep(1500)

EndFunc

Func fromVendorToStash3()
   MoveExact(794,386,2000)
   Sleep(4000)
   
   mouseMove(752,250,3)
   Sleep(500)
   MouseClick("left")
   Sleep(6500)
EndFunc



; stash anything that can't be sold, so after this we will be fine.
; idon't even care if bag is full or not, just go do this every like 20 round;;
Func SellAndIDAndStash()
   If($act==1) Then
	  fromBornToVendorAct1()
   ElseIf($act==2) Then
	  fromBornToVendorAct2();
   ElseIf($act==3) Then
	  fromBornToVendorAct3();
   EndIf
   ; got repair done?. 
   
   MouseMove(293,368,3)
   Sleep(500)
   MouseClick("left");
   
   MouseMove(175,328,3)
   Sleep(500)
   MouseClick("left");
   
   MouseMove(293,154,3)
   Sleep(500)
   MouseClick("left");
   
   Sleep(200)
   
   ; sell everything,  these can't sell are leg, sorry to the plans;
   rightClickEverySlotToSellOrToStash(2)
   Send("{ESCAPE}")
   Sleep(1000)
   
   ;from  vender to stash;
   fromVendorToStash()
   ;now use default stash page2:  shall be changed here.
   MouseMove(292,219,3)
   Sleep(500)
   MouseClick("left");
   Sleep(300)
   
   ;stash everything;
   rightClickEverySlotToSellOrToStash(2)
   Send("{ESCAPE}")
   Sleep(200)
EndFunc


func fromBornToVendorAct3()
   ; act3 fuking far
   MouseMove(36,184,3)
   Sleep(400)
   MouseClick("left")
   Sleep(4500)
   
   MouseMove(35,257,3)
   Sleep(400)
   MouseClick("left")
   Sleep(4500)
   
   MouseMove(145,266,3)
   Sleep(400)
   MouseClick("left")
   Sleep(4500)
EndFunc


Func fromBornToVendorAct2()
   MouseMove(358,98,3)
Sleep(1000)
   
   MouseClick("left")
   Sleep(4500)
EndFunc


Func fromBornToVendorAct1()
   
   MoveExact(260,74,1000)
   Sleep(1000) ; ok to sleep longer we are selling stuff   
   MoveExact(561,112,1000)
   Sleep(5000)
   
   ; on this pc, we have to change this to : 
   If($machineID==1)Then
	  MouseMove(388,160,3)
	  Sleep(1000)
   Else
	  MouseMove(387,199,3)
	  Sleep(500)
   EndIf
   
   MouseClick("left")
   Sleep(2500)


EndFunc


Func tryQuitGameToMenuFromInGameTPFIRST()
   DEBUG("try quit game , we want teh main menu;  ");
   Send("T"); //tp;
   Sleep(8000)
   
$playerStatus = getPlayerStatus();
If($playerStatus==9)Then
   ;esc have been pressed. ingame.
Else
   ;esc not pressed. got this
   Send("{ESCAPE}")
   Sleep(1000)
EndIf

;; have shift in this program;

MouseMove(154,296);

;233,355
;MouseClick('left',403,358,1,5); click logout
MouseClick('left',154,296,1,5); click logout

; ten seconds for quiting the game in a fight,
; 6 seconds for loading main menu.
sleep(4000)
EndFunc
   


; tyr to do this without any garantee. ; works on 
Func tryQuitGameToMenuFromInGame()
   DEBUG("try quit game , we want teh main menu;  ");
   Sleep(3000)
$playerStatus = getPlayerStatus();
If($playerStatus==9)Then
   ;esc have been pressed. ingame.
Else
   ;esc not pressed. got this
   Send("{ESCAPE}")
   Sleep(1000)
EndIf


;; have shift in this program;

MouseMove(154,296);

;233,355
;MouseClick('left',403,358,1,5); click logout
MouseClick('left',154,296,1,5); click logout


;Sleep(3000)

; ten seconds for quiting the game in a fight,
; 6 seconds for loading main menu.
sleep(16000)

EndFunc



Func Pause() ; f10 function.
       $Paused = Not $Paused
       While $Paused
               Sleep(500)
               ToolTip('Paused...', 0, 0)
				getLocationAndColor()
			   ;test();
			   
       WEnd
       ToolTip("")
	EndFunc   ;==>Pause
	
Func Quit() ; f11 function
       Exit
	EndFunc   ;==>Quit
	
	
	
   Func test()
	  $loc = MouseGetPos()
	  
	  
	  If(isEHPBarStillThere())Then
		 ToolTip("foudn!!!!!!!!!!!!!!! enemy! need ! killing!! , ",10,20)
	  Else
		 ToolTip("not  ",10,20)
	  EndIf
	  
	  ToolTip("mouse position ,  "&$loc[0]&"-"&$loc[1],20,30)
	  Sleep(1000)	    
   EndFunc
   
Func DEBUG($MESSAGE)
       If $DebugOn Then
               ToolTip($MESSAGE, 0, 0)
       EndIf
EndFunc   ;==>DEBUG
	
   Func Tests()
	  
   EndFunc ;=>Tests, F8  
   
Func MoveToCellar()
If($act==1) Then
	  MoveToCellarACT1()
   ElseIf($act==2) Then
	  MoveToCellarACT2();
   EndIf

EndFunc

   
Func MoveToCellarACT1()
	       ;4,176 5,268 5,271 84,159
       Sleep(Random(100, 200))
	   
	   Move(43,133)
	   Sleep(Random(1200, 1900))
	   
	   ; click to use purtal
	   MouseMove(315,253,4)
	   sleep(820)
	   MouseClick("left",315,253,1,1) ;  speed = 1 to give system time to change mouse to hand for tp
	   ToolTip(" move to cellar clicked",0,0)
	   Sleep(4100)   

EndFunc   ;==>MoveToCellar


Func MoveToCellarACT2()
   Sleep(Random(100, 200))
	   
	   ; click to use purtal
	   MouseMove(202,103,4)
	   sleep(820)
	   MouseClick("left") ;  speed = 1 to give system time to change mouse to hand for tp
	   ToolTip(" move to cellar clicked",0,0)
	   Sleep(4100)   
EndFunc

;202,103 for tp;



Func findBridgeBeforeFight()
   MouseMove(241,314,3)
   Sleep(250)
   MouseClick("left")
   Sleep(3000)
   click(118,323)
   Sleep(5000)
EndFunc


;as mage don't really need to fight as long as you got buf, it's bearly moving and looting.
; for the coming expand. 

Func fightBridgeAndLoot()
     
   ; move to the right, down,  move to the left ,down,  move to the right. 
   ; or rather, move random? 
   
   ; 1, go to right most corner,
   ; 2, loop several times of :  "go one screen down,  go to right most ,  got to left most."
   
   ;; will loot after each move
   
   ; to right top

   DEBUG(" going to right most top corner.   ")
   
   buffYourSelf()   
   moveOneDirectionTilEnd(420,50,1)
   buffYourSelf()
   moveOneDirectionTilEnd(700,300,1)
   buffYourSelf()
   moveOneDirectionTilEnd(420,50,1)
   buffYourSelf()
   moveOneDirectionTilEnd(700,300,1)
   buffYourSelf()
   moveOneDirectionTilEnd(600,400,1)
   buffYourSelf()
   moveOneDirectionTilEnd(420,50,1)
   buffYourSelf()
   moveOneDirectionTilEnd(700,300,1)
   buffYourSelf()
   
   moveOneDirectionTilEnd(150,750,1)
   buffYourSelf()
   moveOneDirectionTilEnd(10,50,1)
   buffYourSelf()
   moveOneDirectionTilEnd(150,750,1)
   buffYourSelf()
   moveOneDirectionTilEnd(10,50,1)
   buffYourSelf()
   
   For $l=0 To 2
	  DEBUG(" loot run begin.   "&$l)
	  moveOneScreenDown()
	  ; left run
	  buffYourSelf()
	  moveOneDirectionTilEnd(40,300,1)
	  ; down
	  moveOneScreenDown()
	  buffYourSelf()
	  ; right Run
	  moveOneDirectionTilEnd(760,300,1)
	  
   Next
   
   
   
EndFunc

Func buffYourSelf()
Send("{1}")
Sleep(60)
Send("{2}")
Sleep(50)
Send("{3}")
Sleep(50)
EndFunc



Func moveOneScreenDown()
   DEBUG("moveOneScreenDown")
   Move(400,550)
   
   Move(600,550)
   Move(200,550)
   Move(700,550)
   Move(100,550)

   FindItem(6,2)	; 6 for rare+leg ; 2 for check time 
EndFunc



Func moveOneDirectionTilEnd($givex,$givey,$doloot)
   DEBUG("moveOneDirectionTilEnd  :  "&$givex&"-"&$giveY)
   $confirmNotMoving = False;
   $rightTopX = $givex
   $rightTopY = $givey
   $checkRootCount = 0;
   $checkSumPos =0
   $notMoveStack =0;
   $debugCount =0
 ;  $newCheckSum =-1;
   
   $success=0
   $total=0
;   $newCheckSumPos = 0;
   While Not $confirmNotMoving And $debugCount <500
	  MoveFast($rightTopX,$rightTopY)
	  ;$newCheckSumPos = getCheckSum()
	  
	  $newCheckSumPos = -1
	  
	  If ($newCheckSumPos==$checkSumPos)Then
		 DEBUG("seems not moving!            sum: "&$newCheckSumPos&"   : $notMoveStack   :"&$notMoveStack&"    step cout: "&$debugCount&"         curretn rate:  "&$success&"/"&$total)
		 Sleep(1000)
		 ; seems not moving.
		$notMoveStack += 1;
		
		If($notMoveStack==6)Then
		   ; we are sure we are not moving.
		   DEBUG("not moving,  we arrive corner")
		   $confirmNotMoving = True
		   $notMoveStack = 0
		EndIf
	  
	  Else
	  
		; still moving.
		$notMoveStack = 0
		$checkSumPos = $newCheckSumPos
		DEBUG("moving,  set $checkSumPos to new  : "&$checkSumPos)
	  EndIf
	  
	  
	  If($doloot)Then
		; If(Mod($checkRootCount,3)==0)Then
		 ; try loot
		 FindItem(6,2)	; 6 for rare+leg ; 2 for check time 
		; EndIf
		; $checkRootCount = $checkRootCount+1;
	  EndIf
	  
   $debugCount = $debugCount+1
   
   WEnd
   
   
   ;when we stuck at some where, we have to do this : back a little for the place we stuck
   $backx = 800-$givex
   $backy = 600-$givey
   MoveFast($rightTopX,$rightTopY) 
   MoveFast($rightTopX,$rightTopY)    
EndFunc




Func getCheckSum()
#cs 
$ix = 721
$iy = 138

$res=0
For $x=$ix to $ix+3
   For $y = $iy to $iy+3
	  $res+=PixelGetColor($x,$y)
   Next
Next
DEBUG("res got  is now  :"&$res)
Sleep(3 000)
 return $res  
#ce
MouseMove(721,138,3)
return PixelChecksum(721,138,722,139)

EndFunc




;===========================================sub targets

Func WDUpGradeA1Q1()
; just dont' like to leveling
UpGradgeA1Q1Common(3)   
EndFunc

Func MKUpGradeA1Q1()
; just dont' like to leveling
UpGradgeA1Q1Common(4)   
EndFunc

;-1 unknow;  0 bar, 1 wizard , 2 dh , 3 wd , 4 monk
Func UpGradgeA1Q1Common($classa)

While 1
   ; in game check.
   ;makeSureWeAreInGame(1)
   makeSureWeAreInMainMenu()
   selectA1Q1()
   ; 0/default for resume/start, 1 for resume only
   makeSureWeAreInGame(0) ; start game.
   ; move to position.
   
   If($classa==4) Then
	  ;buf mk
	  Send("{2}") ; handsome double.
	  Sleep(1000);
	  ;MouseClick("right") ; zombie hand.
	  Send("{4}") ; aruna
	  Sleep(100)
   EndIf
   
   
   moveToQuestA1Q1()
   Sleep(1000)
   ; find quest, click /start quest
   blindClickQuest()
   Sleep(50)
   
   ; go fight
   
   If($classa ==3)Then
	  
   fightZombiesWD()
   
   ElseIf($classa==4) Then
   fightZombiesMK()
   
   EndIf
   Sleep(3000)
   tryQuitGameToMenuFromInGame();
WEnd

EndFunc



