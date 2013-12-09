ReadMemory(Address, pOffset = 0, PROGRAM = "", PID = "") 
{ 
			; Process, wait, %PROGRAM%, 0 
			; pid = %ErrorLevel%
			if (PID = "")
				return 0
			VarSetCapacity(MVALUE,4) 
			ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
			; baseaddress:=DllCall("GetWindowLong", "Uint", ProcessHandle, "Uint", -6)
			; msgbox,% baseaddress
			DllCall("ReadProcessMemory", "UInt", ProcessHandle, "UInt", Address+pOffset, "Str", MVALUE, "Uint",4, "Uint *",0)
			DllCall("CloseHandle", "int", ProcessHandle)
			return NumGet(MVALUE, 0, "uint")
}

; ReadMemoryBytes(Address, Offset, Bytes,) {

; }

