RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

Tooltip(Text, Time=3000) {
	ToolTip,% Text
	SetTimer, RemoveToolTip,% Time
}