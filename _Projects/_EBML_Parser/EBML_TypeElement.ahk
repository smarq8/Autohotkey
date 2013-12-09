/*
i - Signed Integer    - Big-endian, any size from 1 to 8 octets
u - Unsigned Integer  - Big-endian, any size from 1 to 8 octets
f - Float             - Big-endian, defined for 4 and 8 octets (32, 64 bits)
s - String            - Printable ASCII (0x20 to 0x7E), zero-padded when needed
8 - UTF-8             - Unicode string, zero padded when needed (RFC 2279)
d - Date              - signed 8 octets integer in nanoseconds with 0 indicating the precise beginning of the millennium (at 2001-01-01T00:00:00,000000000 UTC)
m - Master-Element    - contains other EBML sub-elements of the next lower level
b - Binary            - not interpreted by the parser
*/
EBML_TypeElement(Byref File, ByRef Array)
{
Static elem := Elem()
File.Seek(Array.___DataOffset, 0)
VarSetCapacity(Buffer, Array.___DataSize+1, 0)
File.RawRead(Buffer, Array.___DataSize)
	; array_list(array)	
	; msgbox,% Array.___Name
		;=====================================
		; Signed Integer - Big-endian, any size from 1 to 8 octets
		;=====================================
		If (Array.___Kind = "i")
		{
			Array.___Data := NumGet_BE_Bytes(Buffer, 0, "Int", Array.___DataSize)
		}
		;=====================================
		; Unsigned Integer - Big-endian, any size from 1 to 8 octets
		;=====================================
		Else If (Array.___Kind = "u")
		{
			String := NumGet_BE_Bytes(Buffer, 0, "UInt", Array.___DataSize)
			q := elem[Array.___ID, "name"]
			If q contains UID
			{
				; String := Dec2Hex(String)
				String := StrGetRaw(&Buffer, Array.___DataSize)
			}
			Array.___Data := String
		}
		;=====================================
		; Float - Big-endian, defined for 4 and 8 octets (32, 64 bits)
		;=====================================
		Else If (Array.___Kind = "f")
		{
			Array.___Data := NumGet_BE_Bytes(Buffer, 0, "Float", Array.___DataSize)
		}
		;=====================================
		; String - Printable ASCII (0x20 to 0x7E), zero-padded when needed
		;=====================================
		Else If (Array.___Kind = "s")
		{
			Array.___Data := StrGet(&Buffer, "cp0")
		}
		;=====================================
		; UTF-8 - Unicode string, zero padded when needed (RFC 2279)
		;=====================================
		Else If (Array.___Kind = "8")
		{
			Array.___Data := StrGet(&Buffer, "UTF-8")
		}
		;=====================================
		; Date - signed 8 octets integer in nanoseconds with 0 indicating the
		; precise beginning of the millennium (at 2001-01-01T00:00:00,000000000 UTC)
		;=====================================
		Else If (Array.___Kind = "d")
		{
			Array.___Data := GetTime(NumGet_BE_Bytes(Buffer, 0, "int64", Array.___DataSize)/10**9)
		}
		;=====================================
		; Binary - not interpreted by the parser
		;=====================================
		Else If (Array.___Kind = "b")
		{
			If (Array.___DataSize > 32)
			{
				Array.___Data := "-==binary==-"
				; Array.___Data := strgetraw(&Buffer, Array.___DataSize)
				; clipboard := strgetraw(&Buffer, Array.___DataSize)
			}
			Else
			{
				Array.___Data := StrGetRaw(&Buffer, Array.___DataSize)
			}
		}		
		;=====================================
		; --==UNKNOWN ID==--
		;=====================================
		Else
		{
			msgbox,% "Unknown Data Type!!!`n" Array.___Kind
			; array_list(array)
			If (Array.___Kind != "m")
			{
				Array.___Data := "--==Unknown Data Type==--"
			}
		}
		
		;=====================================
		; SeekID - ID to Name
		;=====================================
		If (Array.___Kind = "b") AND (Array.___Name = "SeekID")
		{
			Array.___Data := elem[BEint64(Buffer, Array.___DataSize), "Name"]
		}
	
	; =========== -=TV=- ===========
	TV_Modify(Array.___TV_ItemID, "", Array.___TV_String ": " Array.___Data)
	return
}

Elem() {
Static	Array
If IsObject(Array)
	return Array
	
	File := "EBML_Element.csv"
	Array := {}
	Loop, Read, %File%
	{
		Result := LTrim(A_LoopReadLine)
		
		StringSplit, Out, Result, `t, %A_Space%
		; Array[ID]
		Array[Out3, "Name"] := Out1
		Array[Out3, "Kind"] := Out8
		
		; Array[Name]
		Array["Name", Out1, "ID"]   := Out3
		Array["Name", Out1, "Kind"] := Out8
	}
	; array_list(array)
	return array
}