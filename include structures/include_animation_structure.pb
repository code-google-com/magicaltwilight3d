; ------------------------------------------------------------------------------------------------------------------------------
; -- konstants
; ------------------------------------------------------------------------------------------------------------------------------

; -- Animliste nicht komplett.. wird auch so noch evtl angepasst oder ganz verworfen.
#ani_Animlist_Standard = "stehen,1,150|nahkampf,151,300|fernkampf,301,450|magiekampf,451,600|sprungstarten,601,750|sprunglanden,751,900|laufen,901,1050|gehen,1051,1200|benutzen,1201,1350|die_front,1351,1500|die_back,1501,1650|trank,1651,1800|"  ; PAUSE muss noch dem Standard (#ani_animNR_:..) angepasst werden.

Enumeration 1 ; animationsarten.. (standardm��ig)
   #ani_animNR_stand 
   #ani_animNR_sword
   #ani_animNR_bow_Load
   #ani_animNR_bow_shoot
   #ani_animNR_magic
   #ani_animNR_jump_land   ; landen
   #ani_animNR_jump_start  ; losspringen
   #ani_animNR_jump_flugrolle_start
   #ani_animNR_jump_flugrolle_land
   #ani_animNR_run
   #ani_animNR_walk
   #ani_animNR_use
   #ani_animNR_talk
   #ani_animNR_die_back
   #ani_animNR_die_front
   #ani_animNR_trank
EndEnumeration

; ------------------------------------------------------------------------------------------------------------------------------
; -- structures
; ------------------------------------------------------------------------------------------------------------------------------

; ------------------------------------------------------------------------------------------------------------------------------
; -- variables
; ------------------------------------------------------------------------------------------------------------------------------

   Global ani_all_animspeed.f ; standard-animationsgeschwindigkeit. 
; jaPBe Version=3.9.12.818
; Build=0
; FirstLine=0
; CursorPosition=10
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF