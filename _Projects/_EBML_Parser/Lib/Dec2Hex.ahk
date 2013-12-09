Dec2Hex(p_num) {
A_FormatInteger_bkp:=A_FormatInteger
SetFormat, IntegerFast, H
p_num+=0
SetFormat, Integer, %A_FormatInteger_bkp%
return p_num
}