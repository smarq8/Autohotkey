;=======================================
; EBML_New
;=======================================
EBML_New(ByRef Array, Filename) {
Static File
SplitPath, FileName, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
File.Close()
File := FileOpen(Filename, "r")
_Core("SetFile", File)
Array := {}

	Array.___DataOffset    := 0
	Array.___DataSize      := File.Length
	; Array.___ID          := ID_Num
	; Array.___HeadOffset  := pos	
	; Array.___HeadSize    := Header_Size
	Array.___Name          := OutFileName
	Array.___Kind          := "m"
	
	Array.___EndOffset     := File.Length
	
	Array.___ItemsCounter  := []
	Array.___ItemOrder     := []
	Array.___ItemsCount    := 0
	
	;=================================================
	Array.___TV_String     := OutFileName
	Array.___TV_ItemID     := TV_Add(OutFileName)
}

;=======================================
; Path parser
;=======================================
_PathParser(Path) {
	StringSplit, OutputArray, Path, /
	SearchItems := {}	
	Loop,% OutputArray0
	{
		If not RegExMatch(OutputArray%A_Index%, "(.*)\[.*\]", out)
			SearchItems.Insert(OutputArray%A_Index% "[1]")
		Else
			SearchItems.Insert(OutputArray%A_Index%)
	}
	return SearchItems
}

;=======================================
; EBML_ReadHeader
;=======================================
EBML_ReadHeader(ByRef Var) {
ID_Size := GetFlagPosLeft(Var)
ID      := BEint64(Var, ID_Size)
FlagPos := GetFlagPosLeft(Var, ID_Size)

size       := {}
size.Value := FlagPos
size.Data  := NumGet_BE_Bytes(Var, ID_Size, "int64", FlagPos) ^ ((2**(8-FlagPos))<<8*(FlagPos-1))

H := {}
H.ID    := ID					; ID
H.DSize := Size.Data			; DataSize
H.HSize := ID_Size + Size.Value	; HeaderSize
H.Next  := H.HSize + H.DSize	; NextHeader = HeaderSize + DataSize
return H
}

GetFlagPosLeft(ByRef Var, offset=0) {
Static f := Flag(8, "full", "l")
s := NumGet(Var, Offset, "UChar")
return s?f[s]:0
}

ID_NumH(Num) {
	id := Dec2Hex(num)
	StringReplace, id, id, 0x
	return id
}