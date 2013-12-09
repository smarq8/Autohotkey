GetTime(Time) {

	Year := Floor(Time/31536000) + 2001
		Time := Mod(Time, 31536000)
	Month := Floor(Time/2592000)
		Time := Mod(Time, 2592000)
	Day := Floor(Time/86400)
		Time := Mod(Time, 86400)
	Hour := Floor(Time/3600)
		Time := Mod(Time, 3600)
	Min := Floor(Time/60)
		Time := Mod(Time, 60)
	Sec := Time + 0.0 ; 0.0 for floating point
	
	If (Month < 10)
		Month = 0%Month%
	If (Day < 10)
		Day = 0%Day%
	If (Hour < 10)
		Hour = 0%Hour%
	If (Min < 10)
		Min = 0%Min%
	If (Sec < 10)
	Sec = 0%Sec%
	Return "UTC " Year "-" Month "-" day "  " Hour ":" Min ":" Sec
}