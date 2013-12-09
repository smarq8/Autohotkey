MCode(ByRef code, hex) { ; allocate memory and write Machine Code there
VarSetCapacity(code,StrLen(hex)//2)
	Loop % StrLen(hex)//2
		NumPut("0x" . SubStr(hex,2*A_Index-1,2), code, A_Index-1, "Char")
	return &code
}

MCode(BSwap16,"8AE18AC5C3")
MCode(BSwap32,"8BC10FC8C3") ; Byte Swap (little <--> big endian)
MCode(BSwap64,"8B5424088B4424040FCA0FC88BC88BC28BD1C3")

; dllcall(&BSwap64, "short",0x1234, "cdecl ushort")

; UINT uint32_to_le(UINT arg)
; {
    ; UINT res;
 
    ; res =  ((arg >> 24) & 0xFF) +
          ; (((arg >> 16) & 0xFF) <<  8) +
          ; (((arg >>  8) & 0xFF) << 16)+
          ; ( (arg        & 0xFF) << 24);
 
    ; return(res);
; }
 
; ULONGLONG uint64_to_le(ULONGLONG arg)
; {
    ; ULONGLONG res;
    ; UINT lhs, rhs;
 
    ; lhs = (UINT)((arg & (LONGLONG)0xFFFFFFFF00000000) >> 32);
    ; rhs = (UINT)(arg & (LONGLONG)0x00000000FFFFFFFF);
 
    ; res = ((ULONGLONG)uint32_to_le(rhs) << 32) + (ULONGLONG)uint32_to_le(lhs);
 
    ; return(res);
; }

; inline void endian_swap(unsigned short& x)
; {
    ; x = (x>>8) | 
        ; (x<<8);
; }

; inline void endian_swap(unsigned int& x)
; {
    ; x = (x>>24) | 
        ; ((x<<8) & 0x00FF0000) |
        ; ((x>>8) & 0x0000FF00) |
        ; (x<<24);
; }

; // __int64 for MSVC, "long long" for gcc
; inline void endian_swap(unsigned __int64& x)
; {
    ; x = (x>>56) | 
        ; ((x<<40) & 0x00FF000000000000) |
        ; ((x<<24) & 0x0000FF0000000000) |
        ; ((x<<8)  & 0x000000FF00000000) |
        ; ((x>>8)  & 0x00000000FF000000) |
        ; ((x>>24) & 0x0000000000FF0000) |
        ; ((x>>40) & 0x000000000000FF00) |
        ; (x<<56);
; }