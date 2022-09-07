#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
InfoText =
(

   writte by

   ██████╗ ███╗   ██╗██╗  ██╗██████╗ ██████╗ ██████╗  ██████╗ ██╗   ██╗
   ██╔══██╗████╗  ██║██║ ██╔╝╚════██╗██╔══██╗██╔══██╗██╔═══██╗╚██╗ ██╔╝
   ██████╔╝██╔██╗ ██║█████╔╝  █████╔╝██████╔╝██████╔╝██║   ██║ ╚████╔╝
   ██╔══██╗██║╚██╗██║██╔═██╗  ╚═══██╗██╔══██╗██╔══██╗██║   ██║  ╚██╔╝
   ██████╔╝██║ ╚████║██║  ██╗██████╔╝██║  ██║██████╔╝╚██████╔╝   ██║
   ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝

   on September 2👽22                                                 
)

If !FileExist(A_ScriptDir . "\triggercontainer20220904.txt")
	FileInstall, triggercontainer20220904.txt, %A_ScriptDir%\triggercontainer20220904.txt, 0

Loop, %A_ScriptDir%\triggercontainer*.txt, 0, 1
	Global vURLFile := A_LoopFileFullPath

Global TriggerArray := Object()
Global TempArray := Object()
Global RandomTriggerArray := Object()
Global HitArray := Object()
Global Bingo
Global ticketID
Global ticketTime
Global ShowHide := 1

FormatTime, ticketTime ,, HH:mm:ss

Menu, Tray, Icon, Shell32.dll, 37
Menu, Tray, NoStandard
Menu, Tray, Add, Info, Info
Menu, Tray, Add, Show / Hide, ShowHide
Menu, Tray, Add, Exit, Exit
Menu, Tray, Default, Show / Hide
Menu, Tray, Tip, Streamer Bingo
Gui, Bingo: Destroy
Gui, Bingo: Font, s10 cBlack, Arial Nova
Gui, Bingo: Add, Button, x2 y3 w510 h30 vb11 gReload, Reload / Neuer Spielschein
Gui, Bingo: Add, Edit, x2 y35 w510 h30 Center r1 ve1,
Gui, Bingo: Font, s13 w1000 cBlack, Arial Nova
Gui, Bingo: Add, Text, x2 y89 w169 h139 Center border vb1 gb1,
Gui, Bingo: Add, Text, x2 yp140 w169 h139 Center border vb2 gb2,
Gui, Bingo: Add, Text, x2 yp140 w169 h139 Center border vb3 gb3,
Gui, Bingo: Add, Text, x172 y89 w169 h139 Center border vb4 gb4,
Gui, Bingo: Add, Text, x172 yp140 w169 h139 Center border vb5 gb5,
Gui, Bingo: Add, Text, x172 yp140 w169 h139 Center border vb6 gb6,
Gui, Bingo: Add, Text, x342 y89 w169 h139 Center border vb7 gb7,
Gui, Bingo: Add, Text, x342 yp140 w169 h139 Center border vb8 gb8,
Gui, Bingo: Add, Text, x342 yp140 w169 h139 Center border vb9 gb9,
Gui, Bingo: Font, s10 w400 cBlack, Arial Nova
Gui, Bingo: Add, Button, x2 y519 w510 h60 vb10 gBingo, Noch kein Bingo
Gui, Bingo: Show, h580 w514, Streamer Bingo
ShowHide := 1


Loop, 9
	HitArray[A_Index] := "0"

Loop Read, %vURLFile%
{
	TriggerArray.Insert(A_LoopReadLine)
	TempArray.Insert(A_LoopReadLine)
}

While TempArray.Haskey(1) {
    RandomTriggerArray.Push(TempArray.RemoveAt(MyRandom(1, TempArray.MaxIndex())))
}

If (A_Args[1]) {
	BCT := StrSplit(A_Args[1], ":::")
	CT := StrSplit(BCT[1], ":")
	CTST := BCT[2]
	CTHK := StrSplit(BCT[3], ":")
	CTET := BCT[4]
	Loop, 9
		If (CTHK[A_Index])
			GoSub, b%A_Index%
	Resault := BCT[1] . " ‖ ‖ " . CTST  . " => " . CTET
    ticketTime := CTST
}

Loop, 9 { 										; Build TicketID && Buttons
		k := "b" . A_Index
		If (!A_Args[1])
			v := RandomTriggerArray[A_Index]
		Else {
			v := TriggerArray[CT[A_Index]]
		}

		l := (A_Index != 9) ? ":" : ""
        ticketID .= GetTriggerIDbyTrigger(v) . l
		GuiControl, Bingo: Text, %k%, `n`n%v%
}

GuiControl, Bingo: Text, e1, % (!Resault) ? ticketID : Resault


Return

MyRandom(from, to, quality := 100) {
	FormatTime, time ,, HHmmss
	Random, , %time%
	Loop, quality {
		Random, rand, 0, 999999
		Random, , %rand%
	}
	Random, rand, %from%, %to%
	Return rand
}

GetTriggerIDbyTrigger(trigger) {
	Loop, % TriggerArray.length() {
		If (TriggerArray[A_Index] == trigger)
			Return A_Index
	}
	Return False
}

CheckBingo(b) {
	If (!HitArray[b]) {
		Gui, Bingo: Font, s14 w1000 cGreen, Arial Nova
		GuiControl, Bingo: Font, b%b%
		HitArray[b] := 1
	} Else {
		Gui, Bingo: Font, s13 w1000 cBlack, Arial Nova
		GuiControl, Bingo: Font, b%b%
		HitArray[b] := 0
	}
	Bingo := 0
	If (HitArray[1] && HitArray[2] && HitArray[3]) ; horizonal
		Bingo++
	If (HitArray[4] && HitArray[5] && HitArray[6]) ; horizonal
		Bingo++
	If (HitArray[7] && HitArray[8] && HitArray[9]) ; horizonal
		Bingo++
	If (HitArray[1] && HitArray[4] && HitArray[7]) ; vertikal
		Bingo++
	If (HitArray[2] && HitArray[5] && HitArray[8]) ; vertikal
		Bingo++
	If (HitArray[3] && HitArray[6] && HitArray[9]) ; vertikal
		Bingo++
	If (HitArray[1] && HitArray[5] && HitArray[9]) ; diagonal
		Bingo++
	If (HitArray[3] && HitArray[5] && HitArray[7]) ; diagonal
		Bingo++

	If Bingo {
		Gui, Bingo: Font, s13 w1000 cBlack, Arial Nova
		GuiControl, Bingo: Font, b10
		GuiControl, Bingo: Text, b10, %Bingo%x BINGO!
		hk := ""
		Loop, 9 {
			l := (A_Index != 9) ? ":" : ""
			hk .= HitArray[A_Index] . l
		}
		FormatTime, time ,, HH:mm:ss
		m := "Bingo! Spielscheinnummer: " . ticketID . ":::" . ticketTime . ":::" . hk . ":::" . time
		GuiControl, Bingo: Text, e1, %m%
	} Else {
		Gui, Bingo: Font, s10 w400 cBlack, Arial Nova
		GuiControl, Bingo: Font, b10
		GuiControl, Bingo: Text, b10, Noch kein Bingo
		GuiControl, Bingo: Text, e1, %ticketID%
	}
}

Info:
	Gui, Info: Destroy
	Gui, Info: Font, s8 w300, Courier New
	Gui, Info: Add, Text, x0 y0 h180 w514 vit1, %InfoText%
	Gui, Info: Show, h180 w514, Streamer Bingo
Return

b1:
b2:
b3:
b4:
b5:
b6:
b7:
b8:
b9:
	CheckBingo(StrReplace(A_ThisLabel, "b", ""))
Return

ShowHide:
	If (ShowHide) {
		Gui, Bingo: Hide
        ShowHide := 0
	} Else {
		Gui, Bingo: Show
        ShowHide := 1
	}
Return

Bingo:
	If Bingo {
        GuiControlGet, cb,, e1
		ClipBoard := cb
	}
Return

Reload:
	MsgBox, 4, Reload / Neuer Spielschein, Bist du Sicher?
	IfMsgBox, Yes
		Reload
Return

BingoGuiClose:
	TrayTip, Streamer Bingo, Streamer Bingo wurde in den Infobereich minimiert. , 5
	Gui, Bingo: Hide
    ShowHide := 0
Return

Exit:
	ExitApp