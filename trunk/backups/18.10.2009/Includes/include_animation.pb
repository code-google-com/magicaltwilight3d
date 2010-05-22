   
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; -- include animation.
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; -- (c) Aigner, Max --  Gemusoft http://www.gemusoft.de.ms
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; -- Funktionsweise: Wenn Animation läuft bis Ende durch; wird freigegeben für nächste Animation. (frei: wenn anim_try_to_end = 2)
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; -- Relevante #anz_art_mesh Structure elemente:
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; ------------------------------------------------------------------------------------------------------------------------------
   ; anim_aktuell_frame.i     ; aktueller frame
   ; anim_aktuell_startframe.i; start der aktuellen animation
   ; anim_aktuell_endframe.i  ; ende der atuellen animation
   ; anim_gesch.w             ; aktuell_frame + animgesch.
   ; anim_list.s              ; animationliste der animation Z.B. "stehen,1,155|laufen,162,180|springenstarten,260,268|springenlanden,267,288"
   ; anim_currentanim.s       ; name der aktuellen Animation (z.b. "laufen")
   ; anim_try_to_end.w        ; sagt, dass er animation stoppen soll für nächste anim.
   ; anim_islocked.w          ; wenn =1 -> animation kann nicht durch andere abgebrochen werden. (z.b. sterben nicht durch laufen)
   ; anim_islooped.w          ; besagt, ob die Animation wiederholt wird (z.b. laufen) oder nur einmal abgespielt (z.b. springen)

; ------------------------------------------------------------------------------------------------------------------------------
; -- Procedures
; ------------------------------------------------------------------------------------------------------------------------------

   ; settings setzen
   
   Procedure ani_SetAnim                ( *p_anz_mesh.anz_mesh , AnimationNR , islooped.w = 0 , animationgesch.f = 1.0 , waitiffinished.w = 0 )
      
       If ( Not *p_anz_mesh\anim_currentanim     = StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  1 , ",") ) Or *p_anz_mesh\anim_try_to_end = 2; wenn die animation gerade noch NICHT läuft oder sie schon beendet ist:
          If *p_anz_mesh\anim_islocked           And  *p_anz_mesh\anim_try_to_end         <> 2 ; wenn animation gesperrt und nicht freigegeben, kann man keine andere einwerfen
             *p_anz_mesh\anim_try_to_end         = 1 ; sagt, dass animation gestoppt werden soll, wenn möglich
          Else                                       ; wenn aber nicht gesperrt, oder freigegeben -> neue animation.
             *p_anz_mesh\anim_aktuell_startframe = Val(StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  2 , ",")) ; damits auf startframe kommt AnimationNR+ 2
             *p_anz_mesh\anim_aktuell_frame      = *p_anz_mesh\anim_aktuell_startframe
             *p_anz_mesh\anim_aktuell_endframe   = Val(StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  3 , ","))
             *p_anz_mesh\anim_gesch              = animationgesch
             *p_anz_mesh\anim_islocked           = waitiffinished
             *p_anz_mesh\anim_islooped           = islooped
             *p_anz_mesh\anim_currentanim        = StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  1 , ",")
             *p_anz_mesh\anim_try_to_end         = 0 ; er will ja die animation nicht gleich wieder abbrechen
             If *p_anz_mesh\geladen And *p_anz_mesh\nodeID >0 
                IrrSetNodeAnimationRange( *p_anz_mesh\nodeID , *p_anz_mesh\anim_aktuell_startframe, *p_anz_mesh\anim_aktuell_endframe) ; rundet die enden und anfänge der Animation ab, damit es rund läuft.
             EndIf 
          EndIf 
       Else 
          *p_anz_mesh\anim_islooped               = islooped 
       EndIf 
       
   EndProcedure 
   
   Procedure ani_SetAnimSettings        ( *p_anz_mesh.anz_mesh , AnimationNR , islooped.w = 0, animationgesch.f = 1.0 , waitiffinished.w = 0 , animlist.s = "" ) ; p_anz_node = listiD von anz_mesh
      
       If animlist > ""
          *p_anz_mesh\anim_list            = animlist ;evt lstandardlist? 
       ElseIf *p_anz_mesh\anim_list        = ""       ; wenn aber noch gar keine anim gesetzt ist
          *p_anz_mesh\anim_list            = #ani_Animlist_Standard
       EndIf 
       *p_anz_mesh\anim_aktuell_startframe = Val(StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  2 , ",")) ; damits auf startframe kommt AnimationNR+ 2
       *p_anz_mesh\anim_aktuell_frame      = *p_anz_mesh\anim_aktuell_startframe
       *p_anz_mesh\anim_aktuell_endframe   = Val(StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  3 , ","))
       *p_anz_mesh\anim_gesch              = animationgesch
       *p_anz_mesh\anim_islocked           = waitiffinished
       *p_anz_mesh\anim_islooped           = islooped
       *p_anz_mesh\anim_currentanim        = StringField(StringField( *p_anz_mesh\anim_list ,AnimationNR , "|") ,  1 , ",")
       *p_anz_mesh\anim_try_to_end         = 0 ; er will ja die animation nicht gleich wieder abbrechen
       If *p_anz_mesh\geladen And *p_anz_mesh\nodeID >0 
          IrrSetNodeAnimationRange( *p_anz_mesh\nodeID , *p_anz_mesh\anim_aktuell_startframe, *p_anz_mesh\anim_aktuell_endframe) ; rundet die enden und anfänge der Animation ab, damit es rund läuft.

       EndIf 
       
   EndProcedure 
   
   ; ani get/set
   
   Procedure ani_setAllAnimationSpeed   ( speed.f ) ; setzt den Faktor der geschwindigkeit. ist evtl beeinflusst durch spezifische gesch-faktoren einzelner Wesen. (manche wesen bewegen sich schneller als andere ;) )
      ani_all_animspeed                 = speed 
   EndProcedure 
   
   Procedure ani_getallanimationspeed   ( )
      ProcedureReturn ani_all_animspeed
   EndProcedure 
   
   Procedure ani_getCurrentAnimationNR  ( *p_anz_mesh.anz_mesh)
      ProcedureReturn ani_GetAnimByName ( *p_anz_mesh , *p_anz_mesh\anim_currentanim )
   EndProcedure 
   
   Procedure ani_getCurrentFrame        ( *p_anz_mesh.anz_mesh)
      ProcedureReturn Int( *p_anz_mesh\anim_aktuell_frame)
   EndProcedure 
   
   Procedure ani_getCurrentStartframe   ( *p_anz_mesh.anz_mesh) ; benötigt um zu prüfen, ob beim Bogenschießen der bogen schon gespannt ist, etc.
      ProcedureReturn *p_anz_mesh\anim_aktuell_startframe
   EndProcedure 
   
   Procedure ani_getCurrentEndframe     ( *p_anz_mesh.anz_mesh) ; benötigt um zu prüfen, ob beim Bogenschießen der bogen schon gespannt ist, etc.
      ProcedureReturn *p_anz_mesh\anim_aktuell_endframe
   EndProcedure 
   
   Procedure ani_setAnimGesch           ( *p_anz_mesh.anz_mesh , gesch.f)
      
      *p_anz_mesh\anim_gesch            = gesch 
      
   EndProcedure 
   
   Procedure ani_GetAnimGesch           ( *p_anz_mesh.anz_mesh)
      
      ProcedureReturn *p_anz_mesh\anim_gesch 
      
   EndProcedure 
   
   Procedure ani_GetAnimByName          ( *p_anz_mesh.anz_mesh, name.s)  ; 
      
      For x = 1 To CountString( *p_anz_mesh\anim_list,"|") Step 1
         If name = StringField( StringField ( *p_anz_mesh\anim_list , x , "|") , 1 , "," )
            ProcedureReturn x
         EndIf 
      Next
      
   EndProcedure 
   
   Procedure ani_Setanimlooped          ( *p_anz_mesh.anz_mesh, islooped)
       
      *p_anz_mesh\anim_islooped = islooped 
      
   EndProcedure 
   
   Procedure ani_stopanim               (  *p_anz_mesh.anz_mesh ) ; wenn stoppbar, dann result = 1
       
       *p_anz_mesh\anim_try_to_end = 1 
       
   EndProcedure 
   
   Procedure ani_setanimranges          ( *p_anz_mesh.anz_mesh , Animationdata.s ) ; an.data =animname.s + "|"+str(startframe) + "|" + str(endframe)+ "|"
      
      *p_anz_mesh\anim_list = Animationdata 
      
   EndProcedure 
   
   Procedure ani_setanimRangeByNR       ( *p_anz_mesh.anz_mesh , AnimationNR.i , Animationname.s , startframe.i , endframe.i ) 
      Protected StrToReplace.s , x.i , pos.i , anim_list.s ,StrToFind.s
         
         ; zur Sicherheit.. wenns des mehs gar net gibt..
         If Not *p_anz_mesh 
            ProcedureReturn 0
         EndIf 
         
         ; wenn aber doch:
         StrToFind                  = StringField( *p_anz_mesh\anim_list , AnimationNR , "|" )
         StrToReplace               = Animationname + "," + Str(startframe) + "," + Str(endframe)
         If CountString             ( *p_anz_mesh\anim_list , StrToFind ) > 1 ; wenn der zu ersetzende Wert 2 mal da ist..
               
               ; dann muss ich sichergehen, dass der richtige Wert ersetzt wird.. -> position suchen, wertlänge feststellen;  neustring.s = leftSchnitt + newstring + rightSchnitt
               If Not AnimationNR   <= 1
                  Repeat 
                     
                     pos + 1                ; verschieben der Startpositon um 1 (damit es nicht dauernd über des gleiche "|" drüberfällt
                     pos = FindString       ( *p_anz_mesh\anim_list , "|" , pos )
                     x   + 1                ; X zählt die Runden
                  
                  Until x >= AnimationNR -1
               EndIf 
               
               *p_anz_mesh\anim_list = Left ( *p_anz_mesh\anim_list , pos) +  StrToReplace + Right( *p_anz_mesh\anim_list , Len(*p_anz_mesh\anim_list) - pos - Len( StrToFind ))
               ProcedureReturn *p_anz_mesh  ; success!!
               
         Else ; wenn es eh nur 1-mal vorhanden ist.. 
            
            *p_anz_mesh\anim_list           = ReplaceString ( *p_anz_mesh\anim_list  , StrToFind , StrToReplace )
            ProcedureReturn *p_anz_mesh     ; success!!
            
         EndIf 
         
   EndProcedure 
   
   Procedure ani_setaniminterruptable   ( *p_anz_mesh.anz_mesh , SetInterruptable)
      
      *p_anz_mesh\anim_islocked = SetInterruptable
      
   EndProcedure 
   
   Procedure ani_getaniminterruptable   ( *p_anz_mesh.anz_mesh) ; schaut, ob die animaton unterbrochen werden kann für eine nächste (z.b bei springen kann man nicht in luft laufen => not interuptable)
      
      ProcedureReturn *p_anz_mesh\anim_islocked 
      
   EndProcedure 
   
   Procedure ani_IsAnimationFree        ( *p_anz_mesh.anz_mesh)
      
      If *p_anz_mesh\anim_try_to_end    = 2  ; animation = frei.
         ProcedureReturn 1
      EndIf 
      
   EndProcedure 
   
   ; animation updates.
   
   Procedure ani_updateanim             ( *p_anz_mesh.anz_mesh )  ; wird direkt bei anzeigeengine eingebaut 
           
            If *p_anz_mesh\geladen = 1 And *p_anz_mesh\anim_list > ""
              If Not (*p_anz_mesh\anim_aktuell_frame   + *p_anz_mesh\anim_gesch) > *p_anz_mesh\anim_aktuell_endframe  ; wenns normal läuft
                 *p_anz_mesh\anim_aktuell_frame        + *p_anz_mesh\anim_gesch 
                 If *p_anz_mesh\anim_try_to_end        = 1
                    If *p_anz_mesh\anim_islocked       = 0
                       *p_anz_mesh\anim_try_to_end     = 2
                    EndIf 
                 EndIf 
              Else      ; wenn es am endframe angelangt ist
                 If *p_anz_mesh\anim_try_to_end        = 1
                    *p_anz_mesh\anim_try_to_end        = 2
                 Else  
                     If *p_anz_mesh\anim_islooped      = 1
                        *p_anz_mesh\anim_aktuell_frame  = *p_anz_mesh\anim_aktuell_startframe
                     Else 
                        *p_anz_mesh\anim_aktuell_frame = *p_anz_mesh\anim_aktuell_endframe
                        *p_anz_mesh\anim_try_to_end    = 2 ; animation = freigegeben.. allerdings nur versuchsweise. k.a., obs funkt, so..
                     EndIf 
                 EndIf 
              EndIf 
              If *p_anz_mesh\nodeID 
                 IrrSetNodeAnimationFrame              ( *p_anz_mesh\nodeID  , Int( *p_anz_mesh\anim_aktuell_frame)  )
              EndIf 
           EndIf 
         
      
   EndProcedure 

 
; jaPBe Version=3.8.8.716
; FoldLines=001C003200340048004C004E00500052005400560058005A005C005E00600062
; FoldLines=00640068006A006E00700078007A007E008000840086008A00B000B400B600BA
; FoldLines=00BC00C2
; Build=0
; FirstLine=8
; CursorPosition=141
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF