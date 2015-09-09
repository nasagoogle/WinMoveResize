;Written by TJCodeMaster
;Script that lets you move around windows with the arrow keys while holding down the windows key
;Hold Ctrl to resize instead of move
;Hold Shift to resize opposing corner
;Hold Ctrl+Shift for resizing different
;Hold Alt to slow it down

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force

Menu, Tray, Icon, shell32.dll, 44
SetWinDelay, -1

LWinLeft := false
LWinRight := false
LWinUp := false 
LWinDown := false 
MinMoveAmount := 1
MaxMoveAmount := 5
FirstMoved := false
ActivateDelay := 100

MainLoop()

; For moving windows
LWin & Left:: 
	if (!FirstMoved) {
		HandleLeft()
		FirstMoved := true
	}
	LWinLeft := true 					
	return
LWin & Left Up:: LWinLeft := false

LWin & Right:: 
	if (!FirstMoved) {
		HandleRight()
		FirstMoved := true
	}
	LWinRight := true 				
	return
LWin & Right Up:: LWinRight := false

LWin & Up:: 
	if (!FirstMoved) {
		HandleUp()
		FirstMoved := true
	}
	LWinUp := true						
	return
LWin & Up Up:: LWinUp := false

LWin & Down:: 
	if (!FirstMoved) {
		HandleDown()
		FirstMoved := true
	}
	LWinDown := true					
	return
LWin & Down Up:: LWinDown := false

;To reload script
LWin & .:: 
	Reload
	Sleep 2000
	return

MainLoop() { 
	global LWinLeft
	global LWinRight
	global LWinUp
	global LWinDown
	global FirstMoved
	global ActivateDelay

	ActivateStart := 0
	ActivateAmount := 0
	KeyTriggered := false
	WaitDelay := 50
	LoopDelay := 0
	LoopDelayStart := A_TickCount

	While (true) {
		if (LWinLeft OR LWinRight OR LWinUp OR LWinDown) {
			if (!KeyTriggered) {
				ActivateStart := A_TickCount
				LoopDelayStart := A_TickCount
				KeyTriggered := true
			}

			if (A_TickCount - LoopDelayStart < LoopDelay) {
				Continue
			} else {
				LoopDelayStart := A_TickCount
			}

			ActivateAmount := A_TickCount - ActivateStart
		} else {
			KeyTriggered := false
			ActivateAmount := 0
			MoveAmount := 0
			FirstMoved := false
			Sleep, WaitDelay		
		}
		
		if (ActivateAmount >= ActivateDelay) {
			if (LWinLeft) {
				HandleLeft()
			} 
			if (LWinRight) {
				HandleRight()
			} 
			if (LWinUp) {
				HandleUp()
			}
			if (LWinDown) {
				HandleDown()
			}
		}
	}
}

GetMoveAmount() {
	global MinMoveAmount
	global MaxMoveAmount
	MoveAmount := 0
	
	if (GetKeyState("LAlt")) {
		MoveAmount := MaxMoveAmount
	} else {
		MoveAmount := MinMoveAmount
	}
		
	return MoveAmount
}

HandleLeft() {
	StretchFromLeft(GetMoveAmount()) 
}

HandleRight() {
	StretchFromLeft(-1 * GetMoveAmount()) 
}

HandleUp() {
	StretchFromTop(-1 * GetMoveAmount()) 
}

HandleDown() {
	StretchFromTop(GetMoveAmount()) 
}

StretchFromLeft(Amount) {
	WinGetActiveTitle, ActiveTitle
	WinGetPos, Left, Top, Width, Height, %ActiveTitle%

	if (GetKeyState("LCtrl")) {
		if (GetKeyState("LShift")) {
			WinMove, %ActiveTitle%,, Left, Top, Width - Amount, Height
		} else {
			WinMove, %ActiveTitle%,, Left - Amount, Top, Width + Amount, Height
		}
	} else {
		WinMove, %ActiveTitle%,, Left - Amount, Top, Width, Height
	}
}

StretchFromTop(Amount) {
	WinGetActiveTitle, ActiveTitle
	WinGetPos, Left, Top, Width, Height, %ActiveTitle%

	if (GetKeyState("LCtrl")) {
		if (GetKeyState("LShift")) {
			WinMove, %ActiveTitle%,, Left, Top, Width, Height + Amount
		} else {
			WinMove, %ActiveTitle%,, Left, Top + Amount, Width, Height - Amount
		}
	} else {
		WinMove, %ActiveTitle%,, Left, Top + Amount, Width, Height
	}
}
