

; -----------------------------------------------------------------------------------------------------------------------------------------
      ; ---------------------------------------------------------- PAuse -----------------------------------------------------------------------
      ; -----------------------------------------------------------------------------------------------------------------------------------------
      ; --  spi_setspielerbogenschiessen, schwertangriff, spieler_magie(animationen + nächstliegende gegner angreifen etc. , getnextwaypoint, waypoints mit raster verknüpfen, Antiruckelschutz, Zwischensequenz-library einbauen + planen......  , neues Ausblendesystem bei Meshes.. also anz_setshownobjects (sobald mesh auf display kleiner als XX oder am äußersten Raster -> löschen)
      ; -- Referat Include: ref_playmovie(); spielt intros über dx-pb ab.. muss vor irrlicht aufgerufen werden. ;) auf Codecs  aufpassen! ,ref_createall() , ref_updateflight() , ref_addpoint3d(xyz,lookxyz), ref_animateobject(mesh.s , texture1.s, texture2.s, materialtype.i,animationlist.s,animation.i) , ref_addpause(); benötigt mausklick zum weitermachen., ref_end() ; zum beenden., ref_blendout() , ref_blendin(), ref_playsound(sound.s, islooped)
      ; -- Für Editor: schaun, wie schwer script ist...
      ; -- Evtl:  * skript lernen, Billboardpinsel, Waypointkanone,Waypoint+billobard eraser, Objekt-Kanone (object placer), Tür-skript, Wasser-skript, Wesen-Skript. item skript.
      ; -- OOder: * eigener Editor: Objektmanagement, für alle objekte includemöglichkeit, mesh,terrain,light,sound3d,wesen,item, tür etc. einfügen, wasser converter etc. verschieben, skalieren, rotieren, objekt- billboard etc-kanonen wie oben, mayacamera, terrainpinsel.... wenn möglich.
      ; -----------------------------------------------------------------------------------------------------------------------------------------
      
      
; -----------------------------------------------------------------------------------------------------------------------------------------
; constants
; -----------------------------------------------------------------------------------------------------------------------------------------
      
    Enumeration 
       #ref_art_points3d
       #ref_art_image
       #ref_art_object3d
       #ref_art_pause
       #ref_art_end
       #ref_art_blendout
       #ref_art_blendin
       #ref_art_sound
       #ref_art_setanimation
       #ref_art_hideobject  
    EndEnumeration
    
    #ref_maxblatter = 100
; -----------------------------------------------------------------------------------------------------------------------------------------
; structures
; -----------------------------------------------------------------------------------------------------------------------------------------
   
   Structure ref_blatt 
      geladen.i
      anzahl_items.i  ; anzahl der referatitems auf diesem Blatt.
      finished_items.i ; items, die schon plaziert wurden, bzw. abgespielt. (solln ja nicht dauernd neu erstellt wrden)
      art.i [50]
      id.i  [50]
   EndStructure 
   
   Structure ref_point3d
      current_point.i          ; der aktuelle punkt.. wenn = anzahl_points: abgespielt fertig.
      current_reached.i        ; NR des aktuell schon erreichten punkts. für speedkontrolle
      speed.f                  ; distanz, die er pro durchlaufzurücklegt. damit kann man überall punkte setzen, er fliegt immer im gleichen speed, egal wie dicht punkte beieinander.
      anzahl_points.i
      Position.IRR_VECTOR [50] ; also \x,yz... ;) maximal 100 punkte für ne spline
      Rotation.IRR_VECTOR [50] ; wohin gerade geschaut wird. Drehwinkel der camera
   EndStructure 
   
   Structure ref_image
      pfad.s
      NR.i ; NR des Images. nicht pointer!
      x.f
      y.f
   EndStructure 
   
   Structure ref_pause
      maus_gedruckt.i ; wenns weiterlaufen darf.. solang = 0-> anhalten des weiterladens
      exist.i ; was braucht das schon für daten??.. 
   EndStructure
   
   Structure ref_blendout
      IsFinished.i ; schaut, ob er schon fertig ist, also nicht mehr nochmal faden muss.
   EndStructure 
   
   Structure ref_blendin
      IsFinished.i ; gleiches hier .
   EndStructure 
   
   Structure ref_sound
      abgespielt.i ; obs schonabgespielt wurde.
      anz_sound3d.anz_sound3d 
   EndStructure 
   
   Structure ref_object3d
      name.s            ; ein spezieller Name zur Identifikation des 3d-models.. z.b. wenn es nun bewegt wird etc.  das ganze ist für spezialprogrammierung, damit man mit diversen 3d models alles mögliche machen kann. 
      id.i              ; das object 3d wird erstellt und hier die ID eingetragen. 
   EndStructure 
   
; -----------------------------------------------------------------------------------------------------------------------------------------
; globals
; -----------------------------------------------------------------------------------------------------------------------------------------

      Global Dim     ref_blatt.ref_blatt       ( #ref_maxblatter )
      Global NewList ref_point3d.ref_point3d   ( )
      Global NewList ref_image.ref_image       ( )
      Global NewList ref_pause.ref_pause       ( )
      Global NewList ref_blendout.ref_blendout ( )
      Global NewList ref_blendin.ref_blendin   ( )
      Global NewList ref_sound.ref_sound       ( )
      Global NewList ref_object3d.ref_object3d ( )
      Global ref_camera.i                              ; die camera für 3d-scenes.!
      
; -----------------------------------------------------------------------------------------------------------------------------------------
; procedures 
; -----------------------------------------------------------------------------------------------------------------------------------------

      Procedure ref_playmovies() ; spielt die ganzen intros ab.
      
      EndProcedure 
      
      Procedure ref_createall() ; das ganze referat erstellen, bilder etc.. auch die ref_camera..!
         ; ref_camera setzen mit irraddcamera()
         
      EndProcedure 
      
      Procedure ref_updateflight() ; das umherfliegen von scene zu scene updaten 
      
      EndProcedure 
      
      Procedure ref_addpoint3d( SplineID, x.f,y.f,z.f,rotx.f,roty.f,rotz.f) ; fügt einen 3d punkt für die splines hinzu... wenn splineID = 0 : neue spline erstellen + Ausgabe der SplineID.
      
      EndProcedure 
      
      Procedure ref_addimage ( x.f, y.f , imagepfad.s) ; ein bild wird da dann eingeblendet.
      
      EndProcedure 
      
      Procedure ref_animateobject( pfad.s, texture1.s , texture2.s , irr_emt_materialtype , animationlist.s , current_animation.i , islooped.i ) ; fügt ein neues animatedObject hinzu. z.b. photovoltaikzelle, die sich auseinanderbaut. returnwert = anz_mesh_id. 
         ; es wird auch einfach ein anz_mesh erstellt. 
         
      EndProcedure 
      
      Procedure ref_addpause() ; man muss klicken, um fortzufahren.. mehr macht pause nicht ^^ ;) 
      
      EndProcedure 
      
      Procedure ref_end() ; beenden des ganzen.. evtl wieder mit Explosion XDD.
      
      EndProcedure 
      
      Procedure ref_blendout() ; ausblenden
         
      EndProcedure 
      
      Procedure ref_blendin() ; einblenden
         ; added fader-element + addpause zum warten auf Tastenklick..
      EndProcedure 
      
      Procedure ref_playsound(sound.s, WaittimeMS.i , islooped) ; 2D Sound abspielen. evtl sogar looped. waittime ist die  Zeit, die bis zum abspieln noch gewartet wird.
      
      EndProcedure 
      
      Procedure ref_nextblatt()    ; blättert eine Seite weiter.
      
      EndProcedure 
      
      Procedure ref_previousblatt() ; blättert eine seite zurück
      
      EndProcedure 
      
      Procedure ref_updateReferat( blatt ) ; flug und rest updaten.. jenachdem, ws kommt. auf mausklick waretn, um weiterzuschalten.
         Protected *ref_blendout.ref_blendout , *ref_blendin.ref_blendin , *ref_image.ref_image , *ref_point3d.ref_point3d , spitze.IRR_VECTOR , fus.IRR_VECTOR, vector.IRR_VECTOR
         Static *fader.i 
         Static FaderIsFading.i ; es kann immer nur 1 fader gleichzeitig arbeiten.. wenn faderisfading = 0 -> fader = frei.
         
         If blatt > #ref_maxblatter 
            ProcedureReturn
         EndIf 
         
         For x = ref_blatt(blatt)\finished_items To ref_blatt(blatt)\anzahl_items
            
            ; erst schaun, wenn ende erreicht ist, dann nächste folie nach mausklick.
            If ref_blatt            ( blatt )\finished_items = ref_blatt(blatt)\anzahl_items + 1
               If GetAsyncKeyState_ ( #VK_SPACE ) Or GetAsyncKeyState_(1) Or GetAsyncKeyState_(#VK_RETURN)  ; wenn maus, return etc gedrückt: fortsetzen des anzeigens der präsentation etc.
                    ref_nextblatt   ()
                EndIf 
            EndIf 
            
            ; ansonsten erstellen der follienelemente.
            
            Select ref_blatt(blatt)\art[x]
               
               Case #ref_art_blendin     ; irrblendin animator..
                  
                  ;{ fade in.. von schwarz zu unsichtbar.
                  
                     ; wenn noch kein fader da: neuen erstellen.
                        If Not *fader 
                           *fader              = IrrGuiAddInOutFader    ()
                           IrrGuiFaderSetColor ( *fader , 0,0,0,0)
                        EndIf 
                     
                     ; wenn er noch nicht aktiviert wurde: aktivieren.
                        If Not FaderIsFading
                           FaderIsFading       = 1
                           IrrGuiFaderFadeIn   ( *fader , 1200 )
                        EndIf 
                     
                     ; element weiterschalten, wenn fader fertig.. fader-element als deaktiviertz speichern.. und nicht mehr faden..... hmhm... tja..
                        If IrrGuiFaderIsReady  ( *fader )
                           FaderIsFading       = 0
                           ref_blatt           ( blatt )\finished_items + 1  ; wenn vorher bilder erstellt wurden, sind die ja schon da.. also ist kein element mehr vorm fader..
                        EndIf 
                  
                  ;}
                  
               Case #ref_art_blendout    ; irrrblendout animator
                  
                  ;{ fade out.. 
                  
                  ; wenn noch kein fader da: neuen erstellen.
                     If Not *fader 
                        *fader              = IrrGuiAddInOutFader()
                        IrrGuiFaderSetColor ( *fader , 255,0,0,0)
                     EndIf 
                  
                  ; wenn er noch nicht aktiviert wurde: aktivieren.
                     If Not FaderIsFading 
                        IrrGuiFaderFadeOut  ( *fader , 1200 )
                     EndIf 
                     
                  ; element weiterschalten, wenn fader fertig.. fader-element als deaktiviertz speichern.. und nicht mehr faden..... hmhm... tja..
                        If IrrGuiFaderIsReady  ( *fader )
                           FaderIsFading       = 0
                           ref_blatt           ( blatt )\finished_items + 1  ; wenn vorher bilder erstellt wurden, sind die ja schon da.. also ist kein element mehr vorm fader..
                        EndIf 
                  ;}
                  
               Case #ref_art_end         ; beenden des programms
                  
                  ref_end()
                  
               Case #ref_art_image       ; bild anzeigen auf xy
                  
                  ;{ image erstellen.
                  
                  *ref_image             = ref_blatt(blatt)\id[x]
                  anz_loadimage          ( *ref_image\NR , *ref_image\x , *ref_image\y , *ref_image\pfad , 1 , 0)
                  ref_blatt              ( blatt )\finished_items + 1
                  ;}
                  
               Case #ref_art_object3d    ; 3d  objekt anzeigen + animieren, wenn möglich
                  
                  ;{ object 3d speziell bearbeiten
                  
                  *ref_object3d.ref_object3d ; wenn man einige object3d-s speziell programmieren möchte..
                  ; structure:
                  ; name.s  ; name zum erkennen.
                  ; id.i    ; pointer zu object3d.
                  
                  ;}
                  
               Case #ref_art_pause       ; wenn nicht mausrelease, dann keine weiteren elemente.
                  
                  *ref_pause = ref_blatt(blatt)\id[x]
                  ; maus_gedruckt.i ; wenns weiterlaufen darf.. solang = 0-> anhalten des weiterladens
                  ; exist.i ; was braucht das schon für daten??.. 
                  If *ref_pause\maus_gedruckt = 0
                     If GetAsyncKeyState_( #VK_SPACE) Or GetAsyncKeyState_(1) Or GetAsyncKeyState_(#VK_RETURN)  ; wenn maus, return etc gedrückt: fortsetzen des anzeigens der präsentation etc.
                        *ref_pause\maus_gedruckt = 1
                     Else  
                        Break ; solange maus_gedruckt noch 0 ist, wird ab hier das abarbeiten der einzelnen blattelemente abgebrochen.
                     EndIf 
                  EndIf 
                  
               Case #ref_art_points3d    ; splinekurve fliegen..
                  
                  ; current_point.i          ; der aktuelle punkt.. wenn = anzahl_points: abgespielt fertig.
      ; speed.f                   ; speed des ganzen haufens.
      ; anzahl_points.i
      ; Position.IRR_VECTOR [50] ; also \x,yz... ;) maximal 100 punkte für ne spline
      ; Rotation.IRR_VECTOR [50] ; wohin gerade geschaut wird. Drehwinkel der camera
      
                  *ref_point3d = ref_blatt(blatt)\id[x]  ; zum pointer switchen
                  spitze\x     = 
                  fus\x        = 
                  vector\x     = 
                  *ref_point3d \ current_point + *ref_point3d\speed 
                  
                  If ref_camera > 0 
                     IrrSetNodePosition( ref_camera , *ref_point3d\Position\x , *ref_point3d\Position\y , *ref_point3d\Position\z )
                  EndIf 
                  
               Case #ref_art_sound       ; sound abspielen.
               
               Case #ref_art_setanimation; zum starten/stoppen von animationen
               
               Case #ref_art_hideobject  ; verstecken eines aktuellen 3dobjekts.
               
            EndSelect 
            
         Next 
         
      EndProcedure 
      
       
; jaPBe Version=3.8.8.716
; FoldLines=00B200C600CA00DC00E400E900ED00F4
; Build=0
; FirstLine=183
; CursorPosition=272
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF