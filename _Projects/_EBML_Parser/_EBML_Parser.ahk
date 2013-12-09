#SingleInstance force
#NoEnv

SetBatchLines -1
#Include <array>
#Include <NumGet_>
#Include EBML_Get.ahk
#Include EBML_Core.ahk
#Include EBML_Func.ahk
#Include EBML_TypeElement.ahk
; SetFormat, IntegerFast, hex

Filename := "D:\tnt\ukonczone\[Coalgirls]_Sword_Art_Online_(1280x720_Blu-ray_FLAC)\[Coalgirls]_Sword_Art_Online_05_(1280x720_Blu-ray_FLAC)_[9C0C8099].mkv"
; Filename := "[Coalgirls]_Moretsu_Pirates_NCOP_(1280x720_Blu-Ray_FLAC)_[38F406AF][MID#8917#1#].mkv"
; Filename := "D:\tnt\ukonczone\[DmonHiro] To-Love-Ru - Darkness (BD, 720p)\[DmonHiro] To-Love-Ru - Darkness 12 - Room (BD, 720p) [D14E2C6D].mkv"
; Filename := "i:\Anime\Obejzane\Clannad\[Coalgirls]_Clannad_(1280x720_Blu-Ray_FLAC)\[Coalgirls]_Clannad_11_(1280x720_Blu-Ray_FLAC)_[A12B6D8C].mkv"
; Filename := "D:\tnt\ukonczone\[a-S] Kaze no Stigma (01-24)\[a-s]_kaze_no_stigma_-_01_-_return_of_wind__comradespike__[E55287CC].mkv"

; Filename := "big-buck-bunny_trailer.webm"
; Filename := clipboard

;=============================================================================
QPX(1)

Gui, Font, , Courier New
Gui, Add, TreeView, vMTV w900 r25
; SetBatchLines 2 ; slowmotion for treeview while HL := 1 in _Core
; Gui, Show, x0   ; up
Dir = D:\tnt\ukonczone\[Coalgirls]_Sword_Art_Online_(1280x720_Blu-ray_FLAC)
; Loop, %Dir%\*.mkv 
{
; filename := A_LoopFileLongPath ; uncomment while loop, %dir% used
EBML_New(EBML, FileName)
EBML_GetAll(ebml)
;============================================
; EBML_SearchItem(ebml, "Segment/Info")
; EBML_GetData(ebml, "Segment/Info")
; EBML_GetAll(ebml, "Segment/Info")
;============================================
; EBML_GetData(ebml, "Segment/Info/MuxingApp")
EBML_GetData(ebml, "Segment/Info/WritingApp")
; EBML_GetData(ebml, "Segment/Info/Duration")
; EBML_GetData(ebml, "Segment/Info/dateutc")
; EBML_GetData(ebml, "Segment/Info/SegmentUID")
;============================================
; EBML_GetData(ebml, "Segment/Info/MuxingApp")
; EBML_GetData(ebml, "Segment/Info/WritingApp")
; EBML_GetData(ebml, "Segment/Info/Duration")
EBML_GetData(ebml, "Segment/Info/dateutc")
EBML_GetData(ebml, "Segment/Info/SegmentUID")
;============================================
; EBML_SearchItem(ebml, "Segment/Chapters/EditionEntry/ChapterAtom[22]")
; EBML_GetData(ebml, "Segment/Chapters/EditionEntry[2]/ChapterAtom/ChapterSegmentUID")

EBML_Getdata(ebml, "Segment/seekhead")
EBML_GetAll(ebml, "Segment/seekhead")
EBML_GetAll(ebml, "Segment/Info")
; array_list(EBML_GetAll(ebml, "Segment/Info"))
}
; Tooltip(QPX())
Gui, Show, x0
; array_list(ebml)
Return


f4::reload





