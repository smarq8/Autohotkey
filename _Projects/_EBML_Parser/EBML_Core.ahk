_Core(ByRef Array, Quick="") {
Static elem := Elem(), file
; array_list(elem)
; msgbox,% Array.___Name
; HL := 1
If HL
	TV_Modify(Array.___TV_ItemID, "Select")

;=====================================
; Get Data if node is not Master and has not yet get Data
;===============================================================================
	If (Array.___Kind != "m") AND (Array.___Kind != "") AND (Array.___Data = "") ; ArrayType.HasKey(array.___Kind)
	{
		EBML_TypeElement(File, Array)
		return
	}

	If (Array.___Kind = "m")
	{
		;=====================================
		; Check each current nodes
		;===============================================================================
		If (Quick = ".*")
		{
			For i, Node in Array.___ItemOrder
			{
				If (Array[Node].___Kind = "m")
					_Core(Array[Node], ".*")
				Else If (Array[Node].___Kind != "m") AND (Array[Node].___Data = "") ; Prevent from get data multiple times
					EBML_TypeElement(File, Array[Node])
				Else If (Array[Node].___Kind = "")
					msgbox, ERROR `n unknow .___Kind
			}
		}
		
		;=====================================
		; Set Offset after last item
		;===============================================================================
		If Array.___ItemsCount
		{
			LastItem := Array.___ItemOrder[Array.___ItemsCount] ; data offset to first nonprocessed segment instad of last+size (to do)
			Offset := Array[LastItem, "___EndOffset"]
		}
		Else
		{
			Offset := Array.___DataOffset
		}

		loop
		{
			If (Offset >= Array.___EndOffset)
			{
				return FALSE
				Break
			}
			pos := Offset
			File.Seek(OffSet, 0)
			File.RawRead(Buffer, 12) ; 4+8 = ID+Size = MaxHeaderSize
			;=====================================
			Header := EBML_ReadHeader(Buffer)
			Offset += Header.Next
			Header_Size := Header.HSize
			ID_Num  := Header.ID
			ID_Name := elem[ID_Num, "Name"]
			ID_Kind := elem[ID_Num, "Kind"]
			mode := ID_Name
			; mode := ID_Num
			ID := ID_Name=""?ID_Num:mode ; String or Hex if missing name
			;=====================================
			If ID_Name in Cluster,Cues
			{
				; =========== -=TV=- ===========
				Array["_ForceReturn", "___TV_ItemID"] := TV_Add("--==FORCE RETURN CAUSE: " ID_Name  "==--", Array.___TV_ItemID, ex)
				return
				; continue
			}
			;=====================================
			{
				Array.___ItemsCounter.HasKey(ID)
				?(Array.___ItemsCounter[ID] ++)
				:(Array.___ItemsCounter[ID] := 1)
			}
			{
				Array.___ItemsCount
				?(Array.___ItemsCount ++)
				:(Array.___ItemsCount := 1)
			}		
			Array_ID := ID "[" Array.___ItemsCounter[ID] "]" ; Name_String
			Array.___ItemOrder[Array.___ItemsCount] := Array_ID
			Array[Array_ID] := {}
			
		;=====================================
		; TreeView
		;===============================================================================
			; TV_ID := ID_Name=""?ID_NumH(ID_Num):ID_Name "[" Array.___ItemsCounter[ID] "]"	; Name[1] - Unknow ID = Hex
			TV_ID := ID_Name=""?ID_NumH(ID_Num):ID_Name								    ; Name    - Unknow ID = Hex
			; TV_ID := ID_NumH(ID_Num) "[" Array.___ItemsCounter[ID] "]"
			; ex := "Expand"
			
			; =========== -=TV=- ===========
			Array[Array_ID].___TV_String  := TV_ID
			Array[Array_ID].___TV_ItemID  := TV_Add(TV_ID, Array.___TV_ItemID, ex)
			
		;=====================================
		; Array build
		;===============================================================================
			Array[Array_ID].___DataOffset := pos + Header_Size
			Array[Array_ID].___DataSize   := Header.DSize
			Array[Array_ID].___ID         := ID_Num
			Array[Array_ID].___HeadOffset := pos
			Array[Array_ID].___HeadSize   := Header_Size
			Array[Array_ID].___Name       := ID
			Array[Array_ID].___Kind       := ID_Kind
			Array[Array_ID].___EndOffset  := pos + Header_Size + Header.DSize
			
			If (ID_Kind = "m")
			{
				Array[Array_ID].___ItemsCounter         := []
				Array[Array_ID].___ItemOrder            := []
				Array[Array_ID].___ItemsCount           := 0
			}
		
			; =========== -=TV=- ===========
			If HL
				TV_Modify(Array[Array_ID].___TV_ItemID, "Select")
		;=====================================
		; Interpretate
		;===============================================================================
			If (Quick = Array_ID)
				return TRUE
			If (Quick = ".*")
			{
				If (ID_Kind = "m")
				{
					_Core(Array[Array_ID], ".*")
				}
				Else
				{
					EBML_TypeElement(File, Array[Array_ID])
				}
			}
		}
	}

	If (Array = "SetFile")
	{
		file := Quick
	}
}