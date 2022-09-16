#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance off
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

If !FileExist(A_ScriptDir . "\triggercontainer20220916Yvraldis.txt")
	FileInstall, triggercontainer20220916Yvraldis.txt, %A_ScriptDir%\triggercontainer20220916Yvraldis.txt, 0

Global AppName := "StreamerBingo"
Global Version := "1.5"
Global TriggerArray := Object()
Global TempArray := Object()
Global RandomTriggerArray := Object()
Global HitArray := Object()
Global Bingo
Global ticketID
Global ticketTime
Global ShowHide := 1
Global CutOffUnixtime := 1663354751
ticketTime := Human2Unix(A_Now)

CheckAPPUpdate(1)
OnExit("FinalExit")

Loop, 9
	HitArray[A_Index] := "0"

If (InStr(ClipBoard, "::") && !A_Args.length()) {
	A_Args := StrSplit((InStr(ClipBoard, "::")) ? FromReplaceTillTrim(ClipBoard) : "", " ")
}

If (A_Args.length()) {                                ; A_Args Sort
	Loop, % A_Args.length()
	{
		If (InStr(A_Args[A_Index], "triggercontainer") && InStr(A_Args[A_Index], ".txt"))
	        vURLFile := A_ScriptDir . "\" . A_Args[A_Index]

		If (InStr(A_Args[A_Index], "::")) {
			Temp_Args := StrSplit((InStr(A_Args[A_Index], "::")) ? FromReplaceTillTrim(A_Args[A_Index]) : "", " ")
		}
	}
	A_Args := Temp_Args
}

Menu, Tray, Icon, Shell32.dll, 37
Menu, Tray, NoStandard
Menu, Tray, Add, Info, Info
Menu, Tray, Add, Show / Hide, ShowHide
Menu, Tray, Add, Check for Updates, CfU
Menu, Tray, Add, Exit, Exit
Menu, Tray, Default, Show / Hide
Menu, Tray, Tip, Streamer Bingo

If (!vURLFile)
	FileSelectFile, vURLFile, 3, triggercontainerDatumStreamer.txt, Datei öffnen, Text-Dokumente (*.txt)

SplitPath, vURLFile, OutFileName

Menu, Tray, Tip, Streamer Bingo - %OutFileName%

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
Gui, Bingo: Show, h580 w514, Streamer Bingo v%Version% - %OutFileName%
ShowHide := 1

Loop Read, %vURLFile%
{
	TriggerArray.Insert(A_LoopReadLine)
	TempArray.Insert(A_LoopReadLine)
}

While TempArray.Haskey(1) {
    RandomTriggerArray.Push(TempArray.RemoveAt(MyRandom(1, TempArray.MaxIndex())))
}

If (A_Args.length()) {								; SNr. Checker
	Loop, % A_args.length() {
		If InStr(A_Args[A_Index], "::") {
   			BCT := StrSplit(FromReplaceTillTrim(A_Args[A_Index]), "::")
			Break
		}
	}
	CT := StrSplit(BCT[1], ":")
	SP := StrSplit(BCT[2], ":")
	CTST := Unix2Human(CutOffUnixtime + SP[1])
    ticketTime := CutOffUnixtime + SP[1]
	CTHK := StrSplit(dec2bin(SP[3]), "")
	CTET := GetFormatedTime(SP[2] - 1337)
	Loop, 9
		If (CTHK[A_Index])
			GoSub, b%A_Index%
	Resault := "Start: " . CTST  . " - Länge: " . CTET
	CheckingBingo := IsBingo()
	If CheckingBingo {
		Loop, 9 {
			b := "b" . A_Index
			If (!HitArray[A_Index])
				GuiControl, Bingo: Disable, %b%
		}
		GuiControl, Bingo: Disable, e1
		GuiControl, Bingo: Disable, b10
		Menu, Tray, Tip, Streamer Bingo (Check) - %OutFileName%
	}
}

Loop, 9 { 										; Build TicketID && Buttons
		k := "b" . A_Index
		If (!A_Args[1])
			v := RandomTriggerArray[A_Index]
		Else {
			v := TriggerArray[CT[A_Index]]
		}

		l := (A_Index != 9) ? ":" : ""
		tid := GetTriggerIDbyTrigger(v)
        ticketID .= tid . l
		GuiControl, Bingo: Text, %k%, `n`n%v%
}

GuiControl, Bingo: Text, e1, % (Resault) ? Resault : "SNr: " . ticketID
Return

CheckAPPUpdate(m = 0) {
	Loop, 3 {
		Try nv := GetWebData("https://raw.githubusercontent.com/BNK3R-Boy/" . AppName . "/main/version")
		If nv
			Break
	}

	If (InStr(nv, "404: Not Found") || (!nv)) {
		MsgBox,, %AppName% - Prüfung auf Update gescheitert, %nv%
		Return
	} Else If nv && (nv > Version) {
        MsgBox, 4, %AppName% - Ein neues Update ist verfügbar, %Version% aktuelle Version`n%nv% neue Version`n`nDownload auf Github anzeigen?
		IfMsgBox Yes
		    Run, https://bnk3r-boy.github.io/StreamerBingo/
		Return
	}
	If (!m)
        MsgBox,, %AppName% - Prüfung auf Update Abgeschlossen, Kein Update verfügbar.
}

GetWebData(url="") {
	Page := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	Page.Open("GET", url, true)
	Page.Send()
	Page.WaitForResponse()
	Return Page.ResponseText
}

FromReplaceTillTrim(str) {
	Return Trim(StrReplace(StrReplace(StrReplace(StrReplace(StrReplace(str, "`r", " "), "`n", " "), "-"), "BINGO!"), "SNr:"))
}

dec2bin(dec) {
    bin := ""
    count := 0
	While (dec > 0) {
		rest := Mod(dec, 2)
		dec := Floor(dec / 2)
		bin := rest . bin
		count++
	}
	While, (StrLen(bin) < 9)
		bin := 0 . bin
	return bin
}

bin2dec(bin) {
	dec := 0
	count := 0
	while(bin > 0) {
		rest := Mod(bin, 2)
		bin := Floor(bin / 10)
		dec += rest * (2 ** count)
		count++
	}
	return dec
}

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

Unix2Human(unixTimestamp) {
	returnDate = 19700101000000
	returnDate += unixTimestamp, s
	FormatTime, returnDate , %returnDate%, dd.MM.yyyy HH:mm:ss
	return returnDate
}

Human2Unix(humanTime) {
	humanTime -= 1970, s
	return humanTime
}

GetFormatedTime(s) {
   w = Tg.-Std.-Min.-Sek.
   Loop Parse, w, -
   {
      x := 60**(4-A_Index) - (A_Index=1)*129600
      t := s // x
      s -= t * x
      If (t or A_Index = 4)
         m:=m t " " A_LoopField " "
   }
   Return m
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
	
	Bingo := IsBingo()

	If Bingo {
		Gui, Bingo: Font, s13 w1000 cBlack, Arial Nova
		GuiControl, Bingo: Font, b10
		GuiControl, Bingo: Text, b10, %Bingo%x BINGO!
		GuiControl, Bingo: Text, e1, % "SNr: " . BuildTicketString()
	} Else {
		Gui, Bingo: Font, s10 w400 cBlack, Arial Nova
		GuiControl, Bingo: Font, b10
		GuiControl, Bingo: Text, b10, Noch kein Bingo
		GuiControl, Bingo: Text, e1, SNr: %ticketID%
	}
}

IsBingo() {
	h := 0
	If (HitArray[1] && HitArray[2] && HitArray[3]) ; horizonal
		h++
	If (HitArray[4] && HitArray[5] && HitArray[6]) ; horizonal
		h++
	If (HitArray[7] && HitArray[8] && HitArray[9]) ; horizonal
		h++
	If (HitArray[1] && HitArray[4] && HitArray[7]) ; vertikal
		h++
	If (HitArray[2] && HitArray[5] && HitArray[8]) ; vertikal
		h++
	If (HitArray[3] && HitArray[6] && HitArray[9]) ; vertikal
		h++
	If (HitArray[1] && HitArray[5] && HitArray[9]) ; diagonal
		h++
	If (HitArray[3] && HitArray[5] && HitArray[7]) ; diagonal
		h++
	Return h
}

BuildTicketString() {
		hk := ""
		Loop, 9
			hk .= HitArray[A_Index]
		time := Human2Unix(A_Now) - ticketTime + 1337
		sTT := ticketTime - CutOffUnixtime
		m := ticketID . "::" . sTT . ":" . time . ":" . bin2dec(hk)
		Return m
}

FinalExit(exit_reason, exit_code) {
	GoSub, FinalExit
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
		ClipBoard := "BINGO! - " . cb
		MsgBox, 0, BINGO!, %cb%`n`nDein Spielscheinnr wurde in der Zwischenablage gespeichert.`nDu kannst ihn nun mit STRG+V in ein Texteingabefeld deiner Wahl einfügen.
	}
Return

Reload:
	cb := ClipBoard
	msg := "Bist du Sicher?"
	(cb) ? msg := "Dazu wird deine Zwischenablage geleert.`nBist du Sicher?`n`nAktueller Inhalt:`n "" " . cb . " """
	MsgBox, 4, Reload / Neuer Spielschein, %msg%
	IfMsgBox, Yes
	{
		ClearReload := 1
		ClipBoard := ""
		Reload
	}
Return

CfU:
	CheckAPPUpdate()
Return

BingoGuiClose:
	TrayTip, Streamer Bingo, Streamer Bingo wurde in den Infobereich minimiert. , 5
	Gui, Bingo: Hide
    ShowHide := 0
Return

FinalExit:
	If (!ClearReload && !CheckingBingo) {
		ClipBoard := BuildTicketString()
		MsgBox, Spielscheinnr %ClipBoard% wurde in der Zwischenablage gespeichert.
	}
Return

Exit:
	ExitApp