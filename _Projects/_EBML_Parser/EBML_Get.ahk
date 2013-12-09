;==============================================
; EBML_GetAll
;==============================================
EBML_GetAll(ByRef EBML, Path="") {
	SearchItems := _PathParser(Path)
	n := SearchItems.MaxIndex()
	If EBML_SearchItem(EBML, SearchItems)
		_Core(n?EBML[SearchItems*]:EBML, ".*")
	Else
		return FALSE
	;================================================
	
	; return "OBJECT (TO DO)"
	return n?EBML[SearchItems*]:EBML
	; array_list(n?EBML[SearchItems*]:EBML)
}

;==============================================
; EBML_GetData
;==============================================
EBML_GetData(ByRef EBML, Path) {
	SearchItems := _PathParser(Path)
	n := SearchItems.MaxIndex()
	If EBML_SearchItem(EBML, SearchItems)
		_Core(n?EBML[SearchItems*]:EBML)
	Else
		return FALSE
	;================================================
	If (EBML[SearchItems*].___Kind = "m")
		; return "MASTER LIST (TO DO)"
		return n?EBML[SearchItems*]:EBML
	Else
		return EBML[SearchItems*].___Data
}

;==============================================
; EBML_SearchItem
;==============================================
EBML_SearchItem(ByRef EBML, SearchItems) {
If not IsObject(SearchItems)
	SearchItems := _PathParser(SearchItems)
	ee := ebml
	Loop,% SearchItems.MaxIndex() 
	{
		key := SearchItems[A_Index]
		If not ee.haskey(key)
		{
			If not _Core(ee, key)
			{
				tooltip("Not found: " Key)
				return FALSE
			}
		}
		ee := ee[key]
	}
	return TRUE
}