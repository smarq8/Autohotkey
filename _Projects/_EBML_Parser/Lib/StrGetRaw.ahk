StrGetRaw(address, length, seperator = " ") {
	A_FormatInteger_prev := A_FormatInteger
	SetFormat, Integer, H
	Loop, % length
		raw .= (strlen(t := RegExReplace(NumGet(address+0, A_Index-1, "uchar"), "0x")) = 1 ? "0" t: t) seperator
	SetFormat, Integer, %A_FormatInteger_prev%
	return raw
}