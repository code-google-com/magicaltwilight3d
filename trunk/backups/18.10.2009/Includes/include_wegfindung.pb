; ------------------------------------------------------------------------------------------------------------------------------
; -- Include Wegfindung. berechnet den WEg für's waypointsystem.
; ------------------------------------------------------------------------------------------------------------------------------


; ------------------------------------------------------------------------------------------------------------------------------
; -- Procedures 
; ------------------------------------------------------------------------------------------------------------------------------
   
   Procedure weg_inserttogeschlist ( *waypointid.WAYPOINT  , Hwert.f = -1)
      Protected *f_element.WAYPOINT , eingefugt.i
      
      ; hier muss das ERSTE! element das mit dem niedrigsten f-wert sein (wie auch bei openlist)
      ; --> jedes neue element 
      If *waypointid         = 0
         ProcedureReturn     0
      EndIf 
      
      If *waypointid         = weg_zielID  ; SUCCESS! Weg gefunden. make ready for output.
         weg_gefunden        = #Weg_status_gefunden
      EndIf 
      
      If Not ListSize        ( weg_geschlist()) = 0
      
         ; wenn schon ein Element da: dann neues in F-wert inserten.
         
         ResetList           ( weg_geschlist())
         
         While NextElement   ( weg_geschlist ())          
            *f_element       = weg_geschlist ()
            Hwert            = *f_element    \ Hwert
            If *waypointid   \Hwert          < Hwert          ; sobald der Hwert des einzufügenden teils kleiner ist, als der der (sortiertn) liste, 
               InsertElement ( weg_geschlist ())              ; Einfügen des neuen Objektes.
               weg_geschlist ( ) = *waypointid                ; Übergabe der ID zur Liste..
               *waypointid   \liste = #Weg_Liste_Gesch        ; waypoint sagen, welche liste es jetzt ist.
               Break  
               eingefugt     = 1
            EndIf 
         Wend 
      
      Else ; wenn noch kein andres Element vorhanden            
            If AddElement    ( weg_geschlist())             ; Einfügen des ersten (neuen) Objektes.
               weg_geschlist () = *waypointid               ; Übergabe der ID zur Liste.. 
               *waypointid    \liste = #Weg_Liste_Gesch      ; waypoint sagen, welche liste es jetzt ist.
               eingefugt     = 1
            EndIf 
      EndIf 
      
      ; wenn neues element das listengrößte ist.
      
      If Not eingefugt ; wenns größer als alle andren elemente ist ->konnte nicht eingefügt werden -> jetzt machen!
         LastElement        ( weg_geschlist())
      
         If AddElement      ( weg_geschlist())                 ; Einfügen des neuen Objektes.
            weg_geschlist   ( ) = *waypointid                  ; Übergabe der ID zur Liste..
            *waypointid     \ liste = #Weg_Liste_Gesch         ; waypoint sagen, welche liste es jetzt ist.
            eingefugt       = 1                                ; es kann ja auch das listengrößte element sein.. in dem fall unten extra adden. ;)
         EndIf  
      EndIf 
      
      weg_remove_from_openlist ( *waypointid )                 ; aus dem Verzeichnis der offenen Liste löschen -> sonst endlosschleife o_O..
      If *waypointid        \Hwert > 0
         *waypointid        \Hwert = Hwert                         ; waypoint Hwert setzen.
      EndIf 
      
      If ListSize           ( weg_geschlist())                            ; kann ja sein, dass kein geschelement erstellt werden konnte (z.b. wegen ram= voll)
         ProcedureReturn    @weg_geschlist()
      EndIf 
      
   EndProcedure 
   
   Procedure weg_inserttoopenlist( *waypointid.WAYPOINT , Fwert.f = -1)
      Protected *f_element.WAYPOINT , eingefugt.i
      
      ; hier muss das ERSTE! element das mit dem niedrigsten F-wert sein (wie auch bei Geschlist)
      ; --> jedes neue element 
      If *waypointid = 0
         ProcedureReturn 0
      EndIf 
      
      If Not ListSize( weg_openlist()) = 0
         ; wenn schon ein Element da: dann neues in F-wert inserten.
         
         ResetList ( weg_openlist())
         
         While NextElement   ( weg_openlist())          
            *f_element       = weg_openlist()
            Fwert            = *f_element    \Fwert 
            If *waypointid   \Fwert                  < Fwert  ; sobald der Fwert des einzufügenden teils kleiner ist, als der der (sortiertn) liste, 
               InsertElement ( weg_openlist())                ; Einfügen des neuen Objektes.
               weg_openlist  ( ) = *waypointid                ; Übergabe der ID zur Liste..
               *waypointid   \liste = #Weg_liste_Open         ; waypoint sagen, welche liste es jetzt ist.
               eingefugt     = 1                              ; es kann ja auch das listengrößte element sein.. in dem fall unten extra adden. ;)
               Break 
            EndIf 
         Wend 
      
      Else ; wenn noch kein andres Element vorhanden            
            If AddElement    ( weg_openlist())                ; Einfügen des ersten (neuen) Objektes.
               weg_openlist  () = *waypointid                 ; Übergabe der ID zur Liste.. 
               *waypointid   \liste = #Weg_liste_Open         ; waypoint sagen, welche liste es jetzt ist.
               eingefugt     = 1
            EndIf 
      EndIf 
      
      ; wenn neues element das llitengrößte ist.
      
      If Not eingefugt ; wenns größer als alle andren elemente ist ->konnte nicht eingefügt werden -> jetzt machen!
         LastElement        ( weg_openlist())
      
         If AddElement      ( weg_openlist())                  ; Einfügen des neuen Objektes.
            weg_openlist    ( ) = *waypointid                  ; Übergabe der ID zur Liste..
            *waypointid     \ liste = #Weg_liste_Open          ; waypoint sagen, welche liste es jetzt ist.
            eingefugt       = 1                                ; es kann ja auch das listengrößte element sein.. in dem fall unten extra adden. ;)
         EndIf 
      EndIf 
      
      
      If Not *waypointid\Fwert = -1
         *waypointid    \Fwert = Fwert                          ; waypoint fwert setzen.
      EndIf 
      
      If ListSize (weg_openlist())
         ProcedureReturn @weg_openlist()
      EndIf 
      
   EndProcedure 
   
   Procedure weg_remove_from_openlist ( *knotenID )
      Protected *oldopenlist.i
      
      *oldopenlist = weg_openlist ()            ; openliste schützen
      ResetList    ( weg_openlist ())     
         
         While NextElement ( weg_openlist ())    ; alle elemente durchsuchen, ob die ID nicht drin ist.. 
            
            If weg_openlist () = *knotenID 
               DeleteElement (weg_openlist ())   ; wenn gefunden: rauswerfen und ende.
               Break 
            EndIf 
         Wend 
      
      If *oldopenlist > 0
         ChangeCurrentElement ( weg_openlist() ,*oldopenlist)
      EndIf 
      
   EndProcedure 
   
   Procedure weg_addclearknoten ( *knotenID.i ) ; ... die chance, dass die procedur benötigt wird geht gegen null.. man braucht ja nur die gesch und offliste zu clearen..(und deren gespeicherte waypoints)
      Protected *aufraumlist.i
      
         ; *aufraumlist = AddElement ( aufraumlist())
         ; *aufraumlist = *knotenID 
         
   EndProcedure 
   
   Procedure weg_calcneighbours( *waypointid.WAYPOINT ,*way_ZielID.WAYPOINT  ) ; zielid wird für "H-wert" benötigt.. (abstand vom ziel)
      ; überprüft alle verbundenen Knoten unseres ID-knotens, und berechnet g-h-f-werte.
      Protected AlternativerGWERT.f , *waypoint_aktiv.WAYPOINT , Posx.f , Posy.f , Posz.f , Pos_activ_x.f , Pos_activ_y.f , Pos_activ_z.f , pos_zielx.f , pos_ziely.f , pos_zielz.f
      
      If *waypointid = 0 Or *way_ZielID = 0
         ProcedureReturn 0
      EndIf 
      
      For x = 0 To *waypointid\anzahl_connections -1  ; das erste Waypoint element ist auf 0!!
         
         *waypoint_aktiv              = *waypointid\connection [x]

         If *waypoint_aktiv\liste     = #Weg_liste_None                   ; in open list hinzufügen
            
            way_getwaypointPOS        ( *waypointid     , @Posx             , @Posy             , @Posz        )
            way_getwaypointPOS        ( *waypoint_aktiv , @Pos_activ_x      , @Pos_activ_y      , @Pos_activ_z )
            way_getwaypointPOS        ( *way_ZielID     , @pos_zielx        , @pos_ziely        , @pos_zielz   )
            *waypoint_aktiv\Gwert     = math_distance3d ( Posx,Posy,Posz    , Pos_activ_x       , Pos_activ_y  , Pos_activ_z)   + *waypointid\Gwert ; abstand vom ausgehenden waypoint zum neu berechnenden. + alter Geh-Wert. (ausgehend vom Startpunkt-Wert)
            *waypoint_aktiv\Hwert     = math_distance3d ( Pos_activ_x       , Pos_activ_y       , Pos_activ_z  , pos_zielx      , pos_ziely         , pos_zielz)
            *waypoint_aktiv\Fwert     = *waypoint_aktiv \ Gwert             + *waypoint_aktiv   \ Hwert 
            ; test_Setwerte           ( *waypoint_aktiv , *waypoint_aktiv   \ Fwert ,*waypoint_aktiv \Gwert , *waypoint_aktiv \Hwert )
            *waypoint_aktiv\parent    = *waypointid                                  ; zum späteren zurückverfolgen: pointer zum alten Waypoint.
            weg_addclearknoten        ( *waypoint_aktiv     )                        ; alle veränderten knoten werden zum späteren aufräumen gespeichert.
            weg_inserttoopenlist      ( *waypoint_aktiv , *waypoint_aktiv\Fwert)    ; einfügen in die Open-Liste..
            
         ElseIf *waypoint_aktiv\liste = #Weg_liste_Open                              ; schaun, ob nicht besser über *waypointiD gehen, als den, dem waypoint_aktiv zugewiesen ist)
            
            AlternativerGWERT         = math_distance3d( Posx     , Posy     , Posz     , Pos_activ_x , Pos_activ_y , Pos_activ_z) + *waypointid\Gwert ; abstand vom ausgehenden waypoint zum neu berechnenden. + alter Geh-Wert. (ausgehend vom Startpunkt-Wert)
            If *waypoint_aktiv\Gwert  > AlternativerGWERT
               *waypoint_aktiv\parent = *waypointid                                  ; wenn man über *waypointid leichter zum Aktiv-knoten kommt, wird über *waypointid gegangen (*waypointid wird dann parent)
               *waypoint_aktiv\Gwert  = AlternativerGWERT
               *waypoint_aktiv\Fwert  = *waypoint_aktiv\Gwert   + *waypoint_aktiv\Hwert
               ; test_Setwerte          ( *waypoint_aktiv , *waypoint_aktiv \Fwert ,*waypoint_aktiv \gwert , *waypoint_aktiv \hwert )
            EndIf 
            
         EndIf 
      
      Next 
      
   EndProcedure 
   
   Procedure weg_clearknoten()  ; löscht alle knoten-veränderungen. (aufräumen nach wegfindung)
      Protected *waypointid.WAYPOINT 
      
   ; openlist aufräumen (falls nicht eh leer) 
   
      ResetList ( weg_openlist())
      
         If ListSize ( weg_openlist()) > 0
         
            While NextElement ( weg_openlist ())
               
               *waypointid        = weg_openlist ()
               *waypointid\Gwert  = 0
               *waypointid\Fwert  = 0
               *waypointid\Hwert  = 0
               *waypointid\parent = 0
               *waypointid\liste  = 0
            Wend 
            
         EndIf 
      
      ; Geschliste clearen. (evtl is die ja auch leer.. kann ja sein..)
      
      ResetList ( weg_geschlist())
      
         If ListSize ( weg_geschlist()) > 0
         
            While NextElement ( weg_geschlist ())
               
               *waypointid        = weg_geschlist ()
               *waypointid\Gwert  = 0
               *waypointid\Fwert  = 0
               *waypointid\Hwert  = 0
               *waypointid\parent = 0
               *waypointid\liste  = 0
            Wend 
            
         EndIf 
      
      ; nur noch die Listen selbst leeren.
      
      ClearList ( weg_openlist ())
      ClearList ( weg_geschlist()) 
      
      ; fertig 
      
   EndProcedure 
   
   Procedure weg_getleastfwert () ; gibt listenelement mit am wenigsten Fwert aus.
   
      If FirstElement     ( weg_openlist()) ; da schon vorsortiert.. kleinster f-wert ist am Anfang.
         ProcedureReturn    weg_openlist()
      EndIf 
      
   EndProcedure 

   Procedure.s weg_outputpath()  ; läufte den pfad rückwärts von ziel zu start.
               
      ; zurückgehen vom ziel zum start, und so auch speichern; also Knoten, wo Mensch als nächstes hin muss ist ganz rechts im string.
      Protected  pfad.s , *element.WAYPOINT
      
      If ListSize ( weg_geschlist()) > 0
      
         If LastElement  ( weg_geschlist ())
         
            *element = weg_geschlist( )
            
               If *element 
               
                  Repeat 
                     
                     pfad            + Str ( *element ) + "|"    ; das element mit dem kleinesten F-wert.. (=zielID) ist ganz links; der start ist ganz rechts im string.
                     *element        = *element \ parent         ; bis dann endlich das Ziel-element erreicht ist. 
                  Until *element      = 0 
               
               EndIf 
            
          EndIf 
          
      EndIf 
      
      ProcedureReturn pfad 
      
   EndProcedure 
   
   Procedure.s weg_GetPath( StartID.i , ZielID.i , max_knoten.i ) ; StartID und ZielID sind waypointIDs.
   
               ; --------------------------------------------------------------------------------------------------------------------
               ; -----------------------------------------------  PAUSE  ------------------------------------------------------------
               ; --------------------------------------------------------------------------------------------------------------------
               ;  Not-GUI anfangen, Debuggen.. und Referattechnik einbaun.....hm.. Spieler Zauber aus Item aufnehmen + dann anzeigen fertig. , 1*Zauber einbauen , SOUND EINBAUN. Debugger infos einbaun.
               ; --------------------------------------------------------------------------------------------------------------------
               
      ; pfadfinding nach Waypoints (hier "Knoten")
      ; Gwert.f					; Geh wert ("beweg-wert)
      ; Fwert.f					; g+h wert
      ; Hwert.f					; math_distance-knoten-ziel
      ; pfad:                 ; "23231|23432|4345335|2325" einfach Reihe von WaypointIDs.. wobei: ganz rechts = start; ganz links = ziel.
      Static    newelement.i         , anzahl_knoten.i 
      Protected pfad.s
      weg_zielID                     = ZielID                        ; setzt die neue Ziel ID.
      weg_inserttoopenlist           ( StartID )                     ; in die offene liste einfügen 
      
      ; ---
      ; schleife
      ; ---
      
      Repeat 
      
         newelement                   = weg_getleastfwert ()         ; Knoten, der am nähsten am ziel ist.
         If Not newelement            = 0                            ; wenn noch ein element in offliste ist.
            
            If max_knoten             = -1     Or anzahl_knoten <= max_knoten; wenn die maximale knotenanzahl noch nicht erreicht ist.
               
               anzahl_knoten          + 1
               weg_calcneighbours     ( newelement , ZielID )        ; umliegende knoten überprüfen
               weg_inserttogeschlist  ( newelement      )            ; vor nochmaligem berechnen schützen.
            Else 
               weg_gefunden           = #Weg_status_delay            ; Maximale Anzahl von Waypoints erreicht. -> aktuelles Ergebnis zum späteren weiterrechnen.
            EndIf  
            
         Else                         ; ziel unerreichbar..
            weg_gefunden              = #Weg_status_unerreichbar
         EndIf  
         
      Until weg_gefunden              > #Weg_status_laufend 
      
      
      ; --------
      ; aufräumen
      ; --------
      
      If weg_gefunden          = #Weg_status_gefunden
         pfad.s                = weg_outputpath( )
         Isresume              = 0
         newelement            = 0
         weg_gefunden          = 0
         anzahl_knoten         = 0
         weg_clearknoten       ()           ; knotendaten wieder alle auf 0 setzen.
      ElseIf weg_gefunden      = #Weg_status_unerreichbar  ; einfach den nächstliegenden ausgeben (das Geschlistelement mit geringstem F-wert)
         pfad.s                = weg_outputpath()
         Isresume              = 0
         newelement            = 0
         weg_gefunden          = 0
         anzahl_knoten         = 0
         weg_clearknoten       ()           ; knotendaten wieder alle auf 0 setzen.
      ElseIf weg_gefunden      = #Weg_status_delay  ; maximale Wayponitanzahl erreicht -> einfach den nächstliegenden punkt übergeben, zum späteren eventuellen weiterrechnen. (sobald er am ziel ist)
         pfad.s                = weg_outputpath()
         Isresume              = 0
         newelement            = 0
         weg_gefunden          = 0
         anzahl_knoten         = 0
      EndIf
      
      ProcedureReturn pfad.s  ; pfad ausgeben  -- quest complete.
      
   EndProcedure 

; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 131
; FirstLine = 74
; Folding = p-
; EnableUnicode
; EnableXP
; CurrentDirectory = C:\Programme MAX\PureBasic 4.3 BETA\ 
; jaPBe Version=3.8.8.716
; FoldLines=00090045008000920094009A00C500F300F500FB
; Build=0
; CompileThis=..\Wegfindung TESTER.pb
; FirstLine=82
; CursorPosition=266
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF