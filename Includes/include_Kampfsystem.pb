; -----------------------------------------------------------------------------------------------------------------
; --- Kampfsystem -------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------
; verwaltet fliegende Pfeile, Magie etc.
; Hat nichts mit Animationsverwaltung am hut!!! des macht include_wesen bzw. etc.
; -----------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------
; --- Procedures --------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------

   Procedure kam_SchiesPfeil ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen) ; schießt einen Pfeil in richtung gegner ab. (kann danebenfliegen)
      ; vorher Reichweite der Wesenwaffe prüfen *wesenid\Waffen_Anz_ID
      Protected *waffe.item_waffe , *item.ITEM , x.f , y.f , z.f , x1.f , y1.f , z1.f, vect.ivector3 , distance.f , rotx.f ,roty.f , rotz.f 

         *item                 = *WesenID          \ Waffe_Item_ID
         *waffe                = *item             \ WaffenID 
         wes_getposition       ( *WesenID          , @x    , @y      , @z  )
         wes_getposition       ( *WesenID\gegnerid , @x1   , @y1     , @z1 )
         E3D_getNoderotation   ( wes_getNodeID( *WesenID ) , @rotx   , @roty , @rotz ) ; roty für Pfeilroty.
         distance              = math_distance3d( x , y , z , x1 , y1 , z1)
         vect                  \x = ( x1 - x ) / distance ; einheitsvector .. "normalize" berechnen
         vect                  \y = ( y1 - y ) / distance 
         vect                  \y = ( z1 - z ) / distance 
         
         
         *geschoss.geschoss = AddElement ( geschoss())
         
         If Not *geschoss  ; wenn RAM voll.
            ProcedureReturn 0
         EndIf 
         
            With *geschoss 
               \WesenID  = *WesenID 
               \bewegx   = vect\x * #meter ; 60 Meter pro Sekunde (pfeildurchschnittsgeschwindigkeit für 20g-pfeil) .. wir gehen von 60 FPS aus. 
               \bewegy   = vect\y * #meter 
               \bewegz   = vect\z * #meter 
               \schaden  = *waffe\angriff
               \anz_mesh = anz_addmesh ( #pfad_pfeil_mesh , x , y , z ,#pfad_pfeil_texture, #EMT_PARALLAX_MAP_SOLID , #pfad_pfeil_normalmap ,0,0,#anz_col_box , #anz_ColType_movable , 0,roty )
            EndWith 
            ;
            ; SOUND Nicht vergessen!!
   
   EndProcedure 
   
   Procedure kam_getGeschossNodeID (*geschossID.geschoss )
      If *geschossID 
         ProcedureReturn anz_getObject3DIrrNode( anz_getobject3dByAnzID( *geschossID ))
      EndIf 
   EndProcedure 
   
   Procedure kam_moveGeschoss ( *geschossID.geschoss ,bewegx.f , bewegy.f,bewegz.f) ; bewegt den Pfeil wieder weiter (fliegen)
      Protected x.f , y.f , z.f
      
      ; NODEID des Pfeiles
      *node  = kam_getGeschossNodeID( *geschossID ) ; prüft gleichzeitig, ob geschossID überhaupt existiert.

      If *node                ; wenn vorhanden (evtl trotzdem aber nicht geladen=1):
         
         anz_getMeshPosition  ( anz_getobject3dByAnzID( *anz_mesh ) , @x , @y , @z )
         anz_setobjectPos     ( *node , x + bewegx , y + bewegy , z + bewegz )
         ProcedureReturn      *geschossID   ; successfull
      EndIf 
      
   EndProcedure 
   
   Procedure kam_SchiesZauber ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen , kam_Zauber_NR.i) 
      If *WesenID = 0 
         ProcedureReturn 0
      EndIf 
      
      ; vorher Reichweite des Zaubers prüfen *wesenid\Waffen_Anz_ID
      ; SOUND Nicht vergessen!!
      
      If *ZielwesenID = 0 ; wenn pointer = 0, dann Zauber einfach in die gegend schießen. (nicht speziell auf ein wesen.)
         ProcedureReturn 0
      EndIf 
      
   EndProcedure 
   
   ; focus wesen
   
   Procedure kam_nextfocuswesen()
      ProcedureReturn NextElement ( kam_focuswesen() )
   EndProcedure 

    Procedure kam_getFocuswesen()   ; gibt eine Liste von Wesen zurück, die im Visier des Spielers sind.
        ProcedureReturn kam_focuswesen()
    EndProcedure 
    
    Procedure kam_Focuswesen_Reset (*PruefWesenID.wes_wesen , Abstand.f , Treffwinkel.f = 90 , OnlyGegner.i = 1 )  ; überprüft alle fokussierten Wesen des Pruefwesenid ; abstand = maximalentfernung der gegner, treffwinkel ist der (tatsächliche) maximalwinkel zu dem sie zur wesenrotation stehen.
        Protected x.f, y.f , z.f , SpielerRoty.f , spieler_wesen_dist.f , dist.f , WesenID.i , OldFocuswesen.i , divisioncorrectur.i, *p_focuswesen.wes_wesen 
        Protected px.f , py.f , pz.f , pix.f , piy.f ,piz.f , wesenWinkel.f , Xdist.f , smallest_Fi.f = 50  ; smallest fi muss schon maximal sein (> 45 °)
        
        OldFocuswesen     = wes_Focuswesen 
        wes_Focuswesen    = 0
        
        If Not wes_is_geladen( *PruefWesenID )
           ProcedureReturn 0
        EndIf 
        ClearList        ( kam_focuswesen())
        Debug "anzahl einheiten im Ziel: " + Str( wes_Examine_Reset( wes_getNodeID( *PruefWesenID)) ); alle umliegenden wesens überprüfen
        
            While wes_examine_Next()
                
                If Not anz_getobject3dIsGeladen( anz_getobject3dByAnzID( wes_Examine_get_AnzMeshID() ,#anz_art_mesh ) ) ; natürlich muss wesen geladen sein ;)
                    Continue 
                EndIf 
                E3D_getNoderotation        ( wes_getNodeID ( *PruefWesenID)  ,@x   , @SpielerRoty, @z ) ; spielernode rotation
                E3D_getNodePosition        ( wes_getNodeID ( *PruefWesenID)  ,@px  , @py  , @pz )  ; spielernode position 
                E3D_getNodePosition        ( wes_Examine_get_IrrNode( )       ,@pix , @piy , @piz ) ; wesen position.. in dem fall absolute, weils um abstand wesen/spieler geht.
                SpielerRoty                = math_FixFi( - SpielerRoty ) ; spielerroty wird umgedreht ( also - spielerroty) weil spieler ja immer zu wesens schaun soll.
                iMaterialTypeNode          ( wes_Examine_get_IrrNode( ) , #EMT_SOLID_2_LAYER)
                If math_distance3d         ( px,py,pz,pix,piy,piz)  < Abstand  ; wenn der abstand von wesen zu spieler kleiner 1.7 m ist .. ;math_square_distance2d  ( 0 , pz , 0 , piz )     < #meter * 2 And math_square_distance2d( 0 , pz , 0 , piz) > - 1.3* #meter  ; wesen darf max. 2m über und 1m unterhalb von spieler sein.
                
                    ; Suchen aller im Winkel liegenden wesens        ( berechnen des wesen- und spieler drehwinkels)   
                    Xdist                  = math_distance3d         ( px , pz , 0 , pix , piz , 0 ) ; Xdist = b des cosinussatzes.
                    dist                   = #meter                  ; beliebigen wert= länge von c 
                    Ydist                  = math_distance3d         ( pix , piz , 0 , dist + px , pz , 0) 
                    
                    If Round( 2* Xdist * dist,0) = 0 : divisioncorrectur = 1 : Else : divisioncorrectur = 0 : EndIf   ; kontrolle, damits nicht division durch null wird.
                    wesenWinkel             = math_RadToFi           ( ACos((-(Ydist*Ydist) + (Xdist*Xdist) + (dist*dist)) / ( divisioncorrectur+ 2*Xdist * dist ))) ; cos alpha = -a²+b²+c²/(2*b*c)
                    If wesenWinkel >= 2147483648  Or wesenWinkel =< -2147483648   ; wenn leere menge rauskommt, bei acos (was nur bei 180 und 360° der fall ist) 
                        If px > pix 
                        wesenWinkel = 180
                        Else 
                        wesenWinkel = 360
                        EndIf 
                    EndIf 
                    
                    If pz > piz 
                        wesenWinkel        = math_FixFi( 360 - wesenWinkel  )
                    EndIf 
                    Debug "wesenwinkel: "  + StrF( wesenWinkel , 1)
                    Debug " spielerrot:"   + StrF( SpielerRoty , 1)
                    
                    ; Ob wesen In Sichtwinkel - Kontrolle
                    If math_IsFiInBereich   ( wesenWinkel , SpielerRoty-(Treffwinkel/2) , SpielerRoty + (Treffwinkel/2)); wesenWinkel         > SpielerRoty - 45  And wesenWinkel < SpielerRoty + 45 ; wenn der wesenwinkel im Bereich des Spielerwinkels liegt.
                        ; herausfinden des  am nächsten liegenden wesens (nur vom Winkel her!!)
                        *p_focuswesen       = wes_Examine_get_WesenID()
                        If Team_GetFeindLevel(*PruefWesenID\Team , *p_focuswesen\Team) > 0 And Not *p_focuswesen = *PruefWesenID 
                        
                              If AddElement ( kam_focuswesen() )
                                    kam_focuswesen() = wes_Examine_get_WesenID()
                              EndIf 
                              iMaterialTypeNode  ( wes_getNodeID( wes_Examine_get_WesenID()) , #EMT_TRANSPARENT_ADD_COLOR)
                         EndIf 
                    EndIf 
                
                EndIf 
                
            Wend 
            ResetList ( kam_focuswesen())
        
        ; Anzahl der Listenmembers ausgeben.
        ProcedureReturn ListSize ( kam_focuswesen())
    
    EndProcedure 

   Procedure kam_UpdateKampfSystem()  ; pfeile etc. treffen lassen usw.
       Protected vector.ivector3 , endvector.ivector3  ; beides mehrmals benutzt..
       Protected *node.i , *anz_object3d.anz_Object3d , *anz_mesh.anz_mesh ,*wes_wesen.wes_wesen , *wes_absender.wes_wesen
       
       
       ResetList ( geschoss())  
       
          While NextElement ( geschoss())
             
             With geschoss()
                
                kam_moveGeschoss( geschoss() , geschoss()\bewegx , geschoss()\bewegy , geschoss()\bewegz )
                
                ;{ prüfen, ob und wenn, welches node getroffen wurde
                   
                   anz_getMeshPosition           ( geschoss()\anz_mesh ,@vector\x , @vector\y , @vector\z )
                   endvector\x = vector\x + geschoss()\bewegx 
                   endvector\y = vector\y + geschoss()\bewegy 
                   endvector\z = vector\z + geschoss()\bewegz 
                   ; - PAUSE ... 
                   ; hier wird weitergemacht. icollisionpoint geht so nicht. erst das collidierende mesh ausfindig machen, dann per icollisionpoint die collisionposition finden. (evtl neuer befehl in der n3d_ - include.)
                   *node = iCollisionPointNode  ( vector\x, vector\y , vector\z , endvector\x , endvector\y , endvector\z , #ENT_PICKFACE )
                   
                   If *node ; Irgendetwas wurde getroffen. wenn= wesen: abziehen. ansonsten kurz stecken bleiben, nach zeit verschwinden.
                      
                      *anz_object3d         = anz_getobject3dByNodeID ( *node )
                      
                      If *anz_object3d      ; wenn object3d überhaupt existiert..
                      
                           *anz_mesh        = *anz_object3d\id                      ; anz_mesh id auslesen.
                           
                           If *anz_object3d And *anz_object3d\art = #anz_art_mesh   ; wenns ein anz_mesh ist ( standard)
                           
                              If *anz_mesh\WesenID > 0                          ; wenns ein lebewesen ist(war
                                 
                                 *wes_wesen            = *anz_mesh\WesenID 
                                 *wes_absender         = geschoss()\WesenID 
                                 
                                 If Not team_IsFreund  ( *wes_wesen\Team  ,  *wes_absender\Team ) ; wenn ein gegner getroffen wurde:
                                       
                                       wes_SetLeben    ( *wes_wesen , *wes_wesen\leben - geschoss()\schaden ) ; leben v. Wesen reduzieren.
                                       
                                 EndIf 
                                 
                              EndIf 
                           EndIf 
                              
                              anz_attachobject    ( geschoss()\anz_mesh , *node ) ; am Wesen, das getroffen wurde festmachen. PAUSE.. k.a., wie irr_setparten funktioniert... hoffe, er berechnet relative posiiton automatisch (andernfalls hauts den pfeil sonstwo hin..)
                              anz_delete_object3d ( anz_getobject3dByAnzID ( geschoss()\anz_mesh ) , 10000 ) ; löscht nach 10 sekunden das teilens.
                              DeleteElement       ( geschoss())
                       EndIf 
                       
                   EndIf 
                   
                ;}
               
                ;{ Schaun, dass Pfeil nicht ewig fliegt --> löschen nach 170 m. dist zu Absender
                   ; benutzt vector\x,y,z [= pfeilpos] von "prüfen, ob +welches node getroffen" 
                   ; benutzt endvector\xyz
                   
                   *wes_absender          = geschoss()\WesenID 
                   anz_getMeshPosition    ( *wes_absender\anz_Mesh_ID , @endvector\x , @endvector\y , @endvector\z )
                   If math_distance3d     ( vector\x , vector\y , vector\z , endvector\x , endvector\y , endvector\z ) > #meter * 170 ; wenns mehr als 170 meter entfernt ist (pfeil)
                      anz_delete_object3d ( anz_getobject3dByAnzID ( geschoss()\anz_mesh ) , 10000 )                               ; löscht nach 10 sekunden das teilens.
                      DeleteElement       ( geschoss())
                   EndIf 
                
                ;}
                
             EndWith 
             
          Wend  
       
   EndProcedure 
   
   Procedure kam_SchiesSchwert  ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen ) ; schlägt mit dem Schwert einmal zu.(Animation wird hier niht geretelt!! WENN *zielwesenid = 0; automatisches Treffen.
      Protected *waffe_item.ITEM , *waffe.item_waffe , angriff.f 
      
      ; SOUND Nicht vergessen!!
      ; zieht dem gegnerween einfach den schadenswert ab, ohne irgendwas zu werfen! (name nur wegen gleichheit mit Rest)
         If *WesenID\Waffe_Item_ID 
            *waffe_item.ITEM          = *WesenID   \Waffe_Item_ID 
            *waffe.item_waffe         = *waffe_item\WaffenID
            angriff                   = *waffe     \angriff 
         Else 
            angriff                   = #wes_Standard_angriff
         EndIf 
         
      If *ZielwesenID 
         wes_SetLeben                 ( *ZielwesenID  , *ZielwesenID \leben - angriff )
      Else ; trifft alle gegner im Einzugsgebiet der Waffe. 
         kam_Focuswesen_Reset         ( *WesenID , wes_getReichweite( *WesenID ) , 90 , 1 )
         While kam_nextfocuswesen     ( )
               *ZielwesenID           = kam_getFocuswesen() ; es können ja mehrere zielwesen sein. 
               wes_SetLeben           ( *ZielwesenID, *ZielwesenID \leben - angriff )
               Debug "Gegner getroffen!! Leben: " + StrF( *ZielwesenID \leben  ,1)
         Wend 
      EndIf 
      
   EndProcedure
   
; Wenn Gegner = in nähe    ; zum Ressourcensparen
; Figur1 bewegt sich über die Bewegpunkte zum nächsten Punkt, der an Figur2 grenzt.
; Figur1 geht "Querfeldein" auf Figur2 zu
; 
; Wenn in Figur in Reichweite
; 
	; Wenn Figur1 = Fernkampf
		; Figur1 macht Bogenangriff:
		; => Animation der Figur+ Element Pfeil wird erstellt, mit Ziel: Figur2.position
		; Pfeil bekommt 3d Sound + isanimiert (dreht sich im Wind, etc) + schatten.
		; + kleiner partikeleffekt, Luft wird um ihn herum geteilt.
	; Wenn Figur1 = Zauber
		; Figur1 macht Angriffszauber (härtesten habenden)	
		; => Zauberanimation, wenn erledigt: Objekt Zauberkugel wird erstellt mit Ziel Figur2.position.
		; Zauberkugel bekommt 3d sound + particeleffekt
	; Wenn Figur1 = Nahkampf
		; Figur1 macht Nahkampf => Graphische Animation + sound d. Schwertes.
		; Gegner kann per zufall mit schild verteidigen
		; falls nicht:
; 
			; kritischer Treffer        = getcriticaltreffer          (Figur1\kritischertrefferchange)	   	; Rückgabewert = entweder 3, oder, wenn fehlgeschlagen: 1.
			; ausweichechange     = getausweichechange  (Figur2\ausweichchange) 		 	; rückgabewert = 0, wenn successfull, oder 1, wenn fehlgeschlagen!
			; Figur2\lebensenergie = Figur2\lebensenergie - (Figur1\Angriff (der waffe) + Figur1\stärke *2 + Figur1\Geschicklichkeit/3) /    (Figur2\Rustungsklasse / 5) * kritischerTreffer * ausweichechange
; 
		; endfalls
	; endwenn 
; 
; Wenn Pfeil collision mit Figur2 
 	; Figur2\lebensenergie = Figur2\lebensenergie - (Figur1\Angriff (des bogens) + Figur1\Geschicklichkeit*2 + Figur1\stärke/3) /    (Figur2\schild)
	; deleteelement Pfeil
; 
; Wenn aber Zauber collision mit Figur2
	; Figur2\lebensenergie = Figur2\lebensenergie - Zauber\angriff * Figur1\zauberlevel (der art der Kugel) /    (Figur2\schild / 3)
	; Wenn Zauber = eis:
		; Figur2 = eingeeist für Zauber\wirkungsdauer (in Sekunden.f) => kann sich nicht bewegen; wird leicht durchsichtig + Eiskristalle
		; Figur2\Dauerschaden = Zauber\angriff * Figur1\zauberlevel( von eis) / 3
		; Geräusch von belastet werdendem eis.
	; Wenn Zauber = feuer
		; Figur2 = verbrannt für Zauber\wirkungsdauer (in Sekunden.f) => bekommt rote Feuerpartikel und rotes Glühen.
		; Figur2\Dauerschaden = Zauber\angriff * Figur1\zauberlevel( von eis) / 3
		; Geräusch von Brand.
	; Wenn Zauber = Stein
		; beim Aufprall fliegen Steine durch die Gegend => partikel.
		; Splittergräusch
	; Wenn Zauber = Nekromantie
		; Schwarzer Rauch mit rosarotem schein steigt giftig auf.
		; Zischendes Geräusch von geplatztem Gasrohr
		; Spezialwirkung der Zauber unterschiedlich..
	; Wenn Zauber = Blutmagie
		; Kurz wird Bildschirm rotgetönt, und alles verlangsamt sich für eine halbe Sekunde, da bei der Blutmagie der Spieler mit seinen Zaubern direkt verbunden ist.
		; ebenfalls ein Zischendes Geräusch
	; endwenn
; endwenn
; 
; Wenn Figur2\lebensenergie > 0
 	; Figur2 macht gegenangriff
	; alles von forn.
; ansonsten:
	; Figur2 = tot.
; endwenn
 
; jaPBe Version=3.9.12.819
; FoldLines=0033004000D700E2
; Build=0
; CompileThis=..\Wegfindung TESTER.pb
; FirstLine=14
; CursorPosition=46
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF