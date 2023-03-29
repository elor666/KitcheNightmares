IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
;Music variables:
;Apurple	dw	27D6	;117

;Fpurple	dw	32A9	;92

;Fgreen 	dw	1931	;185	

;Agreen		dw	1400	;233

;fpurple	dw	3592	;87

;fgreen		dw	1AA2	;175

;apurple	dw	2A5F	;110

;agreen		dw	152F	;220

Tavs	dw	27D6h,27D6h,1400h,27D6h,27D6h,1400h
		dw	32A9h,32A9h,1931h,32A9h,32A9h,1931h
		dw	3592h,3592h,1AA2h,3592h,3592h,1AA2h
		dw	2A5Fh,2A5Fh,152Fh,2A5Fh,2A5Fh,152Fh

index	dw 0

Zman	dw	2,1,1,2,1,1,2,1,1,2,1,1,2,1,1,2,1,1,2,1,1,2,1,1

Zman0	dw	5,0,5,10,5,20,5,0,5,10,5,20,5,0,5,10,5,20,5,0,5,10,5,20

;Ap ->0.05-> Ap ->0.0-> Ag ->0.05-> Ap ->0.1-> Ap ->0.05-> Ag
;0.2 , 0.1 , 0.1 , 0.2 , 0.1 , 0.1

;---------------------------
;BMP variables:
		BmpLeft 	dw 	?
		BmpTop 		dw 	?
		BmpColSize 	dw 	?
		BmpRowSize 	dw 	?
		
		Palette 	db 	400h dup (0)
		
		ScrLine 	db 	320 dup (0)  ; One picture line read buffer

		ErrorFile  	db 	0
		
		Header 	    db 	54 dup(0)
		
		matrix 		dw ?
		
		FileHandle	dw 	?
		
		MatrixOfATKB	db	320 dup (0)

;---------------------------
;Lobby variables
		kitchen	db	'Pictures/Kitch.bmp',0

		Level1B	db	0 ;if won or not
		
		level2B db  0 ;if won or not
		
		findfo	db	"Find Food!",'$'
		
		
;---------------------------
;MiniGame1 variables:
		
		Tant	db	'Pictures/tantc.bmp',0
		
		Spear	db	'Pictures/spear.bmp',0
		SpearX	dw	220
		SpearY	dw  120
	
		SpearXMax = 80
		
		SpearStartX = 220
		SpearY1 = 120
		SpearY2 = 144
		SpearY3 = 169
		
		MiniGameEnd		db	0
		
		count 	dw	0
		
		RndCurrentPos 	dw 	?
		
		Time	db	0
		
		hit db 0
		
		indistractable db	0
		
		Victory		db 	"Victory",'$'
		
		Defeat		db 	"Defeat",'$'
		
		enterpls	db	"Press Enter",'$'
;---------------------------
;Monsters variables:

		CurrentMonster	dw	?
		
		MonsterHealth	db	0
		
		StringMonster	db	"Monster Health:$"
		
		
		RMBmp	db 	'Pictures/RM.bmp',0
		
		RMHealth = 45
		
		DonaHealth = 42
		
		DonaBMP	db	'Pictures/Dona.bmp',0
		
		

;---------------------------
;Player variables:

		ColorIndex	dw 0

		StringPlayer	db	254,65,8,12

		Player 		db	254,254,254,254,254
					db  254,254,254,254,254
					db  254,254,254,254,254
					db  254,254,254,254,254
					db  254,254,254,254,254
					
		BGPlay 		db 25 dup (0)
					
					
		XposPlayer	dw	100
		YposPlayer	dw	130
					
		Health	db 	3
		
		PHealth = 3
		
		
		Lev 	db	'Pictures/Lev.bmp',0
		LevLength = 25
		
;---------------------------
;Palette File
		Pall	db	'Pictures/Pall.bmp',0

;---------------------------
;AttackBar variables:
		AttackBarN 		db	'Pictures/ATKB.bmp',0
		XposAttack	= 5
		YposAttack	= 130
;---------------------------
;Credits:
		;"Music:Shoמ"
		;"Monsters Drawing:Haim"


CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------
;Main Loop:
		call GraphicMod
		call Drawkitchen
		
		call ResetShowMouse
MainLoop:
		mov ah,1
		int 16h
		jz NoESC
		mov ah,0
		int 16h
		cmp ah,1h
		je EndOfLoop
NoESC:
		call MouseLobby
		call MakeTav
		call MouseLobby
		jmp MainLoop
EndOfLoop:
		call TextMod
		


exit:
	mov ax, 4c00h
	int 21h	

; --------------------------
;Procs
; --------------------------
;Music Procs:
;output 1Tav from arr Tavs in duration of arr zman 
;with waitTime between Tavs with time of zman0
proc MakeTav
		xor cx,cx
		mov si,[index]

		call AudioOn
		call GetEcxess
		
		mov bx,[Tavs+si]
		
		mov al,bl
		out 42h,al
		mov al,bh
		out 42h,al
		
		mov cx,[Zman+si]
;Zman Hashma'a
@@loopDelay:
		call DoDelay
		call MouseLobby
		loop @@loopDelay
		
		call AudioOff

;Zman ShtokTaPe
		mov cx,[Zman0+si]
		cmp cx,0
		je EndOfTav
@@loopDelay5:
		call DoDelay01
		call MouseLobby
		loop @@loopDelay5
		
		
EndOfTav:
		cmp [index],48
		je @@Reset
		jmp NoReset
@@Reset:	
		mov [index],0
		jmp @@EndTavProc
NoReset:		
		add [index],2
@@EndTavProc:
	ret
endp MakeTav

;Delay of 0.01 sec(for music only)
proc DoDelay01;=0.01
	push cx
	mov cx, 10
	@@Delay1:
		push cx
		mov cx, 6000
		@@Delay2:
			loop @@Delay2
		pop cx
	loop @@Delay1
	pop cx
	ret
endp DoDelay01


proc AudioOn
		in		al,61h
		or		al,00000011B
		out 	61h,al
	ret
endp AudioOn
	
	
proc AudioOff
		in		al,61h
		and 		al,11111100B
		out 	61h,al
	ret
endp AudioOff	
	
	
	
proc GetEcxess
		mov 	al,0B6h
		out 	43h,al
	ret
endp GetEcxess

;Moving the index of the music arr to 0 (reset)
proc resetMusic
		
		mov [index],0
ret
endp resetMusic


;Procs:
;dl=X  dh=Y ;Set the cruserPosition
proc set_cursor
      mov  ah, 2                  
      mov  bh, 0                  
      int  10h                    
      ret
endp set_cursor

proc GraphicMod
		push ax
		
		mov 	ax,13h
		int 10h
		
		pop ax
	ret
endp GraphicMod

proc TextMod
		push ax

		mov 	ax,2h
		int 10h
		
		pop ax
	ret
endp TextMod	


proc ResetShowMouse

		mov ax,0
		int 33h
		
		mov ax,1
		int 33h

	ret
endp ResetShowMouse

;showes the palette (debug only)
proc ShowPallete

		push cx
		push ax
		push bx
		push dx
		
		
		mov cx,256
		xor ax,ax
		mov bx,0 ;XPos
		mov dx,0 ;Ypos
		
PutPixel:
		push 4 ;Rochav
		push bx	;XPos
		push dx 	;YPos
		push 4 ;Length
		push ax ;Color
		call DrawFullRect
		
		cmp bx,60
		JE	NextROWInc
		JL	IncX
		jmp loopPixel
		
NextROWInc:
		mov bx,0
		add dx,4
		jmp loopPixel
IncX:
		add bx,4

loopPixel:
		inc ax
		loop PutPixel
		
		pop dx
		pop bx
		pop ax
		pop cx
		
	ret
endp ShowPallete

; --------------------------
;Lobby procs:
;Shows the bmp of the kitchen


proc Drawkitchen
		
		push dx
		
		mov dl,0
		mov dh,0
		call set_cursor
		
		lea dx,[findfo]

		mov ah,9
		int 21h
		
		mov dx, offset Kitchen
		mov [BmpLeft],0
		mov [BmpTop],20
		mov [BmpColSize],320
		mov [BmpRowSize],180
		call OpenShowBmp
		
		pop dx
		
	ret
endp Drawkitchen

;Checks if Player clicked on fridge
;if he did checks which level he is at by var Level1B & Level2B
;and if he won all the levels he can't continue
proc MouseLobby 
		push cx

		mov ax,3h
		int 33h
		
		cmp bx,1
		jne @@End
		
		shr cx,1
		cmp ax,1h
		je @@End
		
		cmp cx,224
		jb @@End
		cmp cx,270
		ja @@End
		cmp dx,43
		jb @@End
		cmp dx,133
		ja @@End
		
;clicked on fridge:
@@Level1:

		cmp [Level1B],1
		je @@Level2
		
		push ax
		mov ax,2
		int 33h
		pop ax
		
		call AudioOff
		call resetMusic
		call Level1
		jmp @@End
		
@@Level2:
		cmp [Level2B],1
		je @@End

		push ax
		mov ax,2
		int 33h
		pop ax

		call AudioOff
		call resetMusic
		call Level2
		jmp @@End
@@End:
		pop cx
	ret
endp MouseLobby

;AttackProcs:
;showing beam on the screen and the player has to stop it
;by the position of the "Beam" dmg current Monster
proc Attack
		push ax
		push cx
		mov cx,10;151 Center 10 Start
		call AttackBar
		call AttackBeam

MoveBeam:
		;call DoDelay05
		cmp 	cx,307;307
		jae @@EndOfMoving
		
		call AttackBar
		add 	cx,10
		call AttackBeam
		
		mov 	ah,1
		int 	16h
		jz	MoveBeam
		
		mov 	ah,0
		int 16h
		cmp 	ah,1Ch
		jne	MoveBeam
		
@@EndOfMoving:
		cmp cx,60
		jbe lowDmg
		cmp cx,140
		jbe medDmg
		cmp cx,170
		jbe highDmg
		cmp cx,250
		jbe medDmg
		jmp lowDmg
lowDmg:
	push 3
	call DMGmonster
	jmp @@endofAttack
medDmg:
	push 6
	call DMGmonster
	jmp @@endofAttack

highDmg:
	push 10
	call DMGmonster
@@endofAttack:
		call UnDrawAttackBar
		pop cx
		pop ax
	ret
endp Attack

;Gets by stack The number of damage
proc DMGmonster
		
		push bp
		mov bp,sp
		push ax
		mov ax,[bp+4]
		cmp [MonsterHealth],al
		jb	ZeroHealth
		sub [MonsterHealth],al
		jmp @@End
ZeroHealth:
		mov [MonsterHealth],0
@@End:	
		pop ax
		pop bp
	ret	2
endp DMGmonster

;Draws the AttackBeam
proc AttackBeam
		
		push 64 ;Rochav
		push cx	;XPos
		push 131 	;YPos
		push 5 ;Length
		push 8 ;Color
		call DrawFullRect
	ret
endp AttackBeam

;Draws the AttackBar
proc AttackBar

		push dx
		push ax

		mov dx, offset AttackBarN
		mov [BmpLeft],XposAttack
		mov [BmpTop],YposAttack
		mov [BmpColSize],310
		mov [BmpRowSize],64
		call OpenShowBmp	
		
		pop ax
		pop dx
	ret
endp AttackBar

;UnDraws the AttackBar
proc UnDrawAttackBar
		
		push 64 ;Rochav
		push 5	;XPos
		push 131 	;YPos
		push 310 ;Length
		push 0 ;Color
		call DrawFullRect
		
		
	ret
endp UnDrawAttackBar
; --------------------------
;Levels:
;activating Level1 with Attack and minigame procs
;level1 : RM Monster,Level1B,with minigamed exclusive for RM
;in the END wait for enter, return to var Level1b if won or not; and return to the kitchen
proc Level1
		mov dx,0
		call putColorInScreen
		mov [MonsterHealth],RMHealth
		
		mov [Health],PHealth
		
		push ax
		lea ax,[RMBmp]
		mov [CurrentMonster],ax
		call MonsterDraw
		pop ax
		
Level1Loop:	
		call Attack
		call MiniGame1Tant
		cmp [MonsterHealth],0
		je 	@@MonsrLose
		cmp [Health],0
		je	@@PlayerLose
		jmp Level1Loop
		
@@PlayerLose:
		mov [level1B],2
		call ShowDefeat
		jmp @@EndLevel1
		
@@MonsrLose:
		mov [level1B],1
		call ShowVictory
@@EndLevel1:

	call Drawkitchen
	mov ax,1
	int 33h
	
	ret
endp Level1

;activating Level2 with Attack and minigame procs
;level1 : Donut Monster,Level2B
;in the END wait for enter, return to var Level1b if won or not; and return to the kitchen
proc Level2
		mov dx,0
		call putColorInScreen
		mov [MonsterHealth],DonaHealth
		
		mov [Health],PHealth
		
		push ax
		lea ax,[DonaBMP]
		mov [CurrentMonster],ax
		call MonsterDraw
		pop ax
		
Level2Loop:	
		call Attack
		call MiniGame1
		cmp [MonsterHealth],0
		je 	@@MonsrLose
		cmp [Health],0
		je	@@PlayerLose
		jmp Level2Loop
		
@@PlayerLose:
		mov [level2B],2
		call ShowDefeat
		jmp @@EndLevel2
		
@@MonsrLose:
		mov [level2B],1
		call ShowVictory
@@EndLevel2:

	call Drawkitchen
	mov ax,1
	int 33h
	
	ret
endp Level2


;show on screen DefeatTXT in red and wait for EnterKey
proc ShowDefeat

		mov dl,16 ;XPos
		mov dh,12 ;Ypos
		mov  ah, 2                  
		mov  bh, 0                  
		int  10h                    


		mov dx, offset Defeat 
		mov ah, 9 
		int 21h
		
		
		mov dl,16
		mov dh,13
		call set_cursor
		mov dx, offset enterpls
		mov ah,9
		int 21h
		
@@Wait2Enter:
		mov ah,0
		int 16h
		cmp ah,1Ch
		jne @@Wait2Enter

	ret
endp ShowDefeat

;show on screen VictoryTXT in green and wait for EnterKey
proc ShowVictory
                    
		mov  dl,16 ;X  
		mov  dh,12 ;Y 
		call set_cursor 
		mov  dx,offset Victory ;STRING TO DISPLAY.
		mov ah,9
		int 21h
		
				mov dl,16
		mov dh,13
		call set_cursor
		mov dx, offset enterpls
		mov ah,9
		int 21h

@@Wait2Enter:
		mov ah,0
		int 16h
		cmp ah,1Ch
		jne @@Wait2Enter

	ret
endp ShowVictory

; --------------------------
;Mini Games procs:
;draws the miniGame Template
proc MiniGameTemplate
		
		push 76  ;Rochav
		push 79 ;XPos
		push 119	;YPos
		push 166 ;Length
		push 255  ;Color
		call DrawMalben
	ret
endp MiniGameTemplate

;Moves the player according to the input
proc MovePlayer
		push ax
		
		mov ah,1
		int 16h
		jz @@nothing
		mov ah,0
		int 16h

@@CheckPress:	
		cmp ah,11h
		je	@@MovW
		cmp ah,1Eh
		je	@@MovA
		cmp ah,1Fh
		je	@@MovS
		cmp ah,20h
		je	@@MovD
		
@@nothing:
		jmp @@NoKey


@@MovW:
	cmp [YposPlayer],120
	je @@NoKey
	call UnDrawPlayer
	sub [YposPlayer],10
	call DrawPlayer
	jmp @@NoKey
	
@@MovA:
	cmp [XposPlayer],80
	je @@NoKey
	call UnDrawPlayer
	sub [XposPlayer],10
	call DrawPlayer
	jmp @@NoKey

@@MovS:
	cmp [YposPlayer],190
	je @@NoKey
	call UnDrawPlayer
	add [YposPlayer],10
	call DrawPlayer
	jmp @@NoKey
	
@@MovD:
	cmp [XposPlayer],240
	je @@NoKey
	call UnDrawPlayer
	add [XposPlayer],10
	call DrawPlayer
	jmp @@NoKey
@@NoKey:	
	pop ax
	ret
endp MovePlayer

;draws the player
proc DrawPlayer
		push ax
		push di
		push cx
		push dx


		mov ax,320
		mov di,[YposPlayer]
		mul di
		mov di,ax
		add di,[XposPlayer]
		
@@Draw:
		mov dx,5
		mov cx,5
		lea ax,[Player]
		mov [matrix],ax
		call putMatrixInScreen

		pop dx
		pop cx
		pop di
		pop ax
	ret
endp DrawPlayer

;Undraws the player
proc UnDrawPlayer
		push ax
		push di
		push cx
		push dx


		mov ax,320
		mov di,[YposPlayer]
		mul di
		mov di,ax
		add di,[XposPlayer]
		
@@Draw:
		mov dx,5
		mov cx,5
		lea ax,[BGPlay]
		mov [matrix],ax
		call putMatrixInScreen

		pop dx
		pop cx
		pop di
		pop ax
	ret
endp UnDrawPlayer

;Draws the monster
proc MonsterDraw		
		push dx
		
		mov dx, [CurrentMonster]
		mov [BmpLeft],122
		mov [BmpTop],20
		mov [BmpColSize],75
		mov [BmpRowSize],75
		call OpenShowBmp
		
		pop dx
	ret
endp MonsterDraw


;Shows the health of both monster and player
proc ShowHealth	
		push dx
		push ax
		push cx
		;Monster Health:
		mov dl,25
		mov dh,4
		call set_cursor
		
		mov ah,9
		mov dx,offset StringMonster
		int 21h
		
		mov dl,30
		mov dh,5
		call set_cursor
		
		xor ax,ax
		cmp [MonsterHealth],9
		ja @@Above9
		call ShowAxDecimal
@@Above9:
		mov al,[MonsterHealth]
		call ShowAxDecimal
		
		xor cx,cx
		xor ax,ax
		cmp [Health],0
		je @@Undraw0
		jmp @@UndrawLev
@@Undraw0:
		push 26 ;Rochav
		push 0	;XPos
		push 30 ;YPos
		push 75 ;Length
		push 0 ;Color
		call DrawFullRect
@@ENDD:
		pop cx
		pop ax
		pop dx	
	ret
		
@@UndrawLev:
		
		push 26 ;Rochav
		push 0	;XPos
		push 30 ;YPos
		push 75 ;Length
		push 0 ;Color
		call DrawFullRect
		
		mov cl,[Health]
@@DrawLev:		

		push cx
		lea dx,[Lev]
		mov [BmpLeft],ax
		mov [BmpTop],30
		mov [BmpColSize],LevLength
		mov [BmpRowSize],LevLength
		call OpenShowBmp
		add ax,25
		pop cx
		loop @@DrawLev
		
		
@@EndOfDraw:
		pop cx
		pop ax
		pop dx	
	ret
endp ShowHealth

; --------------------------
;MiniGame1 procs
;Same as minigame1 but with RM tentacle
proc MiniGame1Tant

		mov [Time],0
		call MiniGameTemplate
		mov [count],0
		call DrawTant
		call DrawPlayer
		call ShowHealth
Reset:
		call CheckPlayerHit
		call ResetSpear	
		call MiniGameTemplate
		inc [Time]
		mov [count],0
		mov [indistractable],0
		call DrawPlayer
	
@@GameLoop:
		inc [count]
		call CheckPlayerHit
		call MiHealth
		;call ShowHealth
		cmp [hit],0
		jne	@@Hit
AfterHit:
		call MovePlayer
		
		cmp [count],4
		ja	@@ReDraw
		call DrawTant
		jmp CheckEnd
@@ReDraw:		
		call UnDrawSpear
		sub [SpearX],35
		call DrawTant
CheckEnd:
		call DoDelay
		cmp [SpearX],SpearXMax
		jbe Reset
		cmp [Time],4
		ja	@@EndOfGame
		jmp @@GameLoop

@@Hit:
		mov [indistractable],1
		jmp AfterHit

@@EndOfGame:
		
	ret
endp MiniGame1Tant



;Minigame1 
;the whole loop for the minigame
;spear is attacking the player
;each time the player is hit he can't be hurt again until the spear resets
proc MiniGame1

		mov [Time],0
		call MiniGameTemplate
		mov [count],0
		call DrawSpear
		call DrawPlayer
		call ShowHealth
@@Reset:
		call CheckPlayerHit
		call ResetSpear	
		call MiniGameTemplate
		inc [Time]
		mov [count],0
		mov [indistractable],0
		call DrawPlayer
	
@@GameLoop:
		inc [count]
		call CheckPlayerHit
		call MiHealth
		;call ShowHealth
		cmp [hit],0
		jne	@@Hit
@@AfterHit:
		call MovePlayer
		
		cmp [count],4
		ja	@@ReDraw
		call DrawSpear
		jmp @@CheckEnd
@@ReDraw:		
		call UnDrawSpear
		sub [SpearX],35
		call DrawSpear
@@CheckEnd:
		call DoDelay
		cmp [SpearX],SpearXMax
		jbe @@Reset
		cmp [Time],4
		ja	@@EndOfGame
		jmp @@GameLoop

@@Hit:
		mov [indistractable],1
		jmp @@AfterHit

@@EndOfGame:
		
	ret
endp MiniGame1


;checks if the player hit by spear 
;if he does, moves to [hit],1
proc CheckPlayerHit
		
		push ax
		push bx
		
		
		
		cmp [indistractable],1
		je @@EndCheck
		
		
CheckY: ;Y= Ypos ;1 or 2= Ypos1 or Ypos2 ;P= Player ;S=Spear
Y1PY1S:
		mov ax,[YposPlayer]
		cmp ax,[SpearY]
		jae Y1PY2S
		
Y2PY1S:		
		mov ax,[YposPlayer]
		add ax,5
		cmp ax,[SpearY]
		jae	Y2PY2S
		jmp @@EndCheck
		
Y1PY2S:
		mov ax,[YposPlayer]
		mov bx,[SpearY]
		add bx,25
		cmp ax,bx
		jbe	@@XPos
		
Y2PY2S:	
		mov ax,[YposPlayer]
		add ax,5
		mov bx,[SpearY]
		add bx,25
		cmp ax,bx
		jbe	@@XPos
		jmp @@EndCheck
		
	
@@Xpos:
		
		mov ax,[XposPlayer]
		add ax,5
		cmp ax,[SpearX]
		jb @@EndCheck
		
		inc [ColorIndex]
		call ChangeColor
		mov [hit],1
		mov [indistractable],1
		
		pop bx
		pop ax
		ret
		
@@EndCheck:

		pop bx
		pop ax
	ret
endp CheckPlayerHit


proc ChangeColor
		push cx
		push si
		push ax
		
		mov cx,25
		mov si,[ColorIndex]
		xor ax,ax
		mov al,[StringPlayer+si]
		mov si,0
ColorChange:
		mov [Player+si],al
		inc si
		loop ColorChange
		
		
		pop ax
		pop si
		pop cx

	ret
endp ChangeColor



;-1 to levs of player if hit is 1
proc MiHealth
		push ax
		cmp [hit],0
		je	@@EndOfHealth
		cmp [Health],0
		je @@EndOfHealth
		sub [Health],1
		call ShowHealth
		
@@EndOfHealth:
		mov [hit],0
		pop ax
	ret 
endp MiHealth


proc DrawSpear
		
		push dx
		push ax

		mov dx, offset Spear
		mov ax,[SpearX]
		mov [BmpLeft],ax
		mov ax,[SpearY]
		mov [BmpTop],ax
		mov [BmpColSize],165
		mov [BmpRowSize],25
		call OpenShowBmp	
		
		pop ax
		pop dx
		
	ret
endp DrawSpear

proc DrawTant
		
		push dx
		push ax

		mov dx, offset Tant
		mov ax,[SpearX]
		mov [BmpLeft],ax
		mov ax,[SpearY]
		mov [BmpTop],ax
		mov [BmpColSize],165
		mov [BmpRowSize],25
		call OpenShowBmp	
		
		pop ax
		pop dx
		
	ret
endp DrawTant


proc UnDrawSpear

		push 25 ;Rochav
		push [SpearX]	;XPos
		push [SpearY]	;YPos
		push 165 ;Length
		push 0 ;Color
		call DrawFullRect
		
		
	ret
endp UnDrawSpear

;reset spear to its starting position but in 1 of 3 different Ylevel(random)
proc ResetSpear

		push ax
		push bx
		
		xor ax,ax
		
		call UnDrawSpear
		mov [SpearX],SpearStartX
		mov bl,1
		mov bh,3
		call RandomByCs
		cmp ax,1
		je	@@1
		cmp ax,2
		je @@2
		jmp @@3
		
@@1:
	mov [SpearY],SpearY1
	jmp	@@EndOfReset

@@2:
	mov [SpearY],SpearY2
	jmp	@@EndOfReset

@@3:
	mov [SpearY],SpearY3

@@EndOfReset:
		pop bx
		pop ax

	ret
endp ResetSpear

;---------------------------

proc LoadPallete
		
		mov dx, offset Pall
		mov [BmpLeft],0
		mov [BmpTop],0
		mov [BmpColSize],130
		mov [BmpRowSize],130
		
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call CloseBmpFile

@@ExitProc:
		
		
	ret
endp LoadPallete


;---------------------------
proc DrawFullRect
		push bp
		mov bp,sp
		push cx
		push ax
		
		mov cx,[bp+12]
		mov ax,[bp+8]
DrawLines:
		push [bp+10] ;XPos
		push ax	;YPos
		push [bp+6]	 ;Length
		push [bp+4]	  ;Color
		call DrawHorizontalLine
		
		inc ax
		loop DrawLines
		
		pop ax
		pop cx
		pop bp
	ret 10
endp DrawFullRect


proc DrawHorizontalLine
		
		push bp
		mov bp,sp
		
		push ax
		push cx
		push dx
		push si
		push bx
		
		xor cx,cx
		xor	si,si
		xor dx,dx
		xor bx,bx
		xor	ax,ax
		
		
		mov 	cx,[bp+10] 	;XPos
		mov 	si,[bp+6] 	;Length
		mov 	dx,[bp+8]	;Ypos
		
		
@@DrawLine:
		mov 	bh,0h
		mov 	al,[bp+4]	;Color
		mov 	ah,0Ch
		int 10h
		
		
		inc cx
		dec si
		cmp si,0
		jne @@DrawLine
		
		
		pop bx
		pop si
		pop dx
		pop cx
		pop ax
		
		pop bp
	ret 8
endp DrawHorizontalLine

proc DrawVerticalLine
		
		push bp
		mov bp,sp
		
		push ax
		push cx
		push dx
		push si
		push bx
		
		
		mov 	cx,[bp+10] 	;XPos
		mov 	si,[bp+6] 	;Length
		mov 	dx,[bp+8]	;Ypos
		
		
@@DrawLine:
		mov 	bh,0h
		mov 	al,[bp+4]	;Color
		mov 	ah,0Ch
		int 10h
		
		
		inc dx
		dec si
		cmp si,0
		jne @@DrawLine
		
		
		pop bx
		pop si
		pop dx
		pop cx
		pop ax
		
		pop bp
	ret 8
endp DrawVerticalLine

proc DrawMalben

		push bp
		mov bp,sp
		
		xor ax,ax
				
		push [bp+10] ;XPos
		push [bp+8]	;YPos
		push [bp+6]	 ;Length
		push [bp+4]	  ;Color
		call DrawHorizontalLine
		
		mov ax,[bp+12]
		add ax,[bp+8]
		
		push [bp+10] ;XPos
		push ax	;YPos
		mov ax,[bp+6]
		inc ax
		push ax	 ;Length
		push [bp+4]	  ;Color
		call DrawHorizontalLine
		
		
		push [bp+10] ;XPos
		push [bp+8]	;YPos
		push [bp+12]	 ;Rochav
		push [bp+4]	  ;Color
		call DrawVerticalLine
		
		mov ax,[bp+6]
		add ax,[bp+10]
		
		push ax ;XPos
		push [bp+8]	;YPos
		push [bp+12]	 ;Rochav
		push [bp+4]	  ;Color
		call DrawVerticalLine
		
		pop bp
		
	ret 10
endp DrawMalben

; in dx - new color 
proc putColorInScreen
	push ds
	push es
	push ax
	push si
	
	mov ax, 0A000h
	mov es, ax
	mov ds, ax
	cld ; for movsb direction ds:si --> es:di
	mov cx, 64000	; full screen
	mov si, 0 ; starts from the first pixel
	mov [si], dx ; put color in [si]
	mov di, 1 ; copies prev pixel to the next one, [0]-->[1], [1]-->[2], 
	
	rep movsb ; Copy whole line to the screen, si and di advances in movsb
	
	pop si
	pop ax
	pop es
	pop ds
    ret
endp putColorInScreen
;---------------------------
proc putMatrixInScreen
; in dx how many cols 
; in cx how many rows
; in matrix - the bytes
; in di start byte in screen (0 64000 -1)
	push es
	push ax
	push si
	
	mov ax, 0A000h
	mov es, ax
	cld ; for movsb direction si --> di
	
	
	push dx ; save dx since mul changes it...
	mov ax,cx
	mul dx  ; ax = cx*dx rows*columns = total pixels
	mov bp,ax
	pop dx ; restores dx
	
	
	mov si,[matrix]
	
NextRow:	
	push cx
	
	mov cx, dx
	rep movsb ; Copy line to the screen
	sub di,dx
	add di, 320
	
	
	pop cx
	loop NextRow
	
		
	pop si
	pop ax
	pop es
    ret
endp putMatrixInScreen


proc OpenShowBmp near
	
	 push ax
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	 
	call CloseBmpFile

@@ExitProc:
	pop ax
	ret
endp OpenShowBmp

 

; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

; input [FileHandle]
proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile


; Read and skip first 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader

; Read BMP file color palette, 256 colors * 4 bytes (400h)
; 4 bytes for each color BGR (3 bytes) + null(transparency byte not supported)	
proc ReadBmpPalette near 		
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the pallete colors
; video ports are 3C8h for number of first color (usually Black, default)
; and 3C9h for all rest colors of the Pallete, one after the other
; in the bmp file pallete - each color is defined by BGR = Blue, Green and Red
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.(4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette

 
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	
	pop dx
	pop cx
	 
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP 

proc DoDelay
	push cx
	mov cx, 100
	Delay1:
		push cx
		mov cx, 6000
		Delay2:
			loop Delay2
		pop cx
	loop Delay1
	pop cx
	ret
endp DoDelay

proc DoDelay05
	push cx
	mov cx, 50
	@@Delay1:
		push cx
		mov cx, 6000
		@@Delay2:
			loop @@Delay2
		pop cx
	loop @@Delay1
	pop cx
	ret
endp DoDelay05


; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs

;make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask
	
	
proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   ;mov dl, ','
       ;mov ah, 2h
	   ;int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal
	
EndOfCsLbl:
END start