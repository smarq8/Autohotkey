Flag(Bytes, Mode="SimplePF", direction="R") {
	Flag := []
	
	;================================
	; Pos[Flag]
	;================================
	If (Mode = "SimplePF")
	{
		Loop,% Bytes
		{
			If (Direction = "L")
				Flag[A_Index] := 1<<(Bytes-A_Index) ; 100k smaples, 8 bytes - 0.54  ; Flag pos from Left
			If (Direction = "R")
				Flag[A_Index] := 1<<(A_Index-1)     ; 100k smaples, 8 bytes - 0.54  ; Flag pos from Right
		}
	}
	
	;================================
	; Flag[Pos]
	;================================
	If (Mode = "SimpleFP")
	{
		Loop,% Bytes
		{
			If (Direction = "L")
				Flag[1<<(A_Index-1)] := Bytes-A_Index+1    ; 100k smaples, 8 bytes - 0.54  ; Flag pos from Left
			If (Direction = "R")
				Flag[1<<(A_Index-1)] := A_Index            ; 100k smaples, 8 bytes - 0.54  ; Flag pos from Right
		}
	}
			
	Else If (Mode = "Full")
	{
		f := 0
		loop := (2**(Bytes))
		Loop,% loop -1
		{
			i := A_Index
			If not (i & (1<<f-1))
				f++
			If (Direction = "L")
				Flag[i] := Bytes-f+1    ; Flag pos. from left
			If (Direction = "R")
				Flag[i] := f            ; Flag pos. from righ
		}
	}
	; array_list(Flag)
	return Flag
}

; ================================
; Benchmark
; ================================
; QPX(1)
; loop, 100000
; flag(8)
; msgbox,% QPX()