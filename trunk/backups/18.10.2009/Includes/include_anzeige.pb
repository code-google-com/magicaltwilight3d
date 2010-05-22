; --------------------------------------------------------------------
; -- Copyright by Aigner, Max.   
; -- All rights reserved.
; -- No.
; -- Date: 24.12.2008 -Weihnachten ;).
; -- 
; -- Displaying and Loading of 3D Objekts (Meshes), Particles, etc. 
; -- And loading map usw.
; --------------------------------------------------------------------

; --------------------------------------------------------------------
; anmerkung zu evelntuellen Bugs:
; bei Macro anz_setShownObjects_loadMesh() kann evtl beim Rotieren von Objekten der Befehl irrrotatenodebycenter() verwendet werden müssen statt irrsetnoderotation()

; --------------------------------------------------------------------
;-Macros
; --------------------------------------------------------------------

Macro anz_setShownObjects_loadMesh()
                                  
                                 ; irr_obj ist die ID des irrlicht- objekts (eigendlich: anz_mesh()\nodeID
                                 ; mesh neuladen, wenn gelöscht
                                 If  anz_mesh()\nodeID     = 0 Or anz_mesh()\geladen = 0; wenn das node es noch nicht geladen ist.

                                     anz_mesh()\meshID     = IrrGetMesh        ( anz_mesh()\pfad )    ; laden
                                     anz_mesh()\nodeID     = IrrAddMeshToScene ( anz_mesh()\meshID )  ; in die scene werfen
                                     irr_obj               = anz_mesh()\nodeID 
                                     radx.f = 0
                                     rady.f = 0
                                     radz.f = 0
                                     x1.f   = 0
                                     y1.f   = 0
                                     z1.f   = 0
                                     x2.f   = 0
                                     y2.f   = 0
                                     z2.f   = 0
                                     
                                     If irr_obj
                                        
                                        ; mesh verschieben, rotaten, scalieren.
                                        IrrSetNodePosition( anz_mesh()\nodeID , anz_Object3d()\x  , anz_Object3d()\y  , anz_Object3d()\z)
                                        IrrSetNodeRotation( anz_mesh()\nodeID , anz_mesh()\rotx   , anz_mesh()\roty   , anz_mesh()\rotz)
                                        IrrSetNodeScale   ( anz_mesh()\nodeID , anz_mesh()\scalex , anz_mesh()\scaley , anz_mesh()\scalez)
                                        
                                        ; breite, höhe und tiefe berechnen
                                        IrrGetNodeExtentTransformed( irr_obj , @radx,@rady,@radz) 
                                        anz_mesh()\width   = radx 
                                        anz_mesh()\height  = rady 
                                        anz_mesh()\depth   = radz
                                        
                                        ; evtl beim rotieren 3 mal IrrRotateNodeByCenter( 
                                        ; mesh verwaltung
                                        anz_mesh()\geladen      = 1                          
                                        
                                        ; mesh material 
                                        anz_setMeshMaterial   (  anz_mesh() , anz_mesh()\irr_emt_materialtype ,anz_IsNormalmappingEnabled(),anz_IsParallaxmappingEnabled()) ; setzte materialtype + texturen.
                                        IrrSetNodeMaterialFlag( anz_mesh()\nodeID , #IRR_EMF_TRILINEAR_FILTER , 1 )
                                        IrrSetNodeMaterialFlag( anz_mesh()\nodeID , #IRR_EMF_GOURAUD_SHADING  , 1 )
                                        If anz_islighting 
                                           IrrSetNodeMaterialFlag( anz_mesh()\nodeID , #IRR_EMF_LIGHTING         , anz_mesh()\islighting )
                                        Else 
                                           IrrSetNodeMaterialFlag( anz_mesh()\nodeID , #IRR_EMF_LIGHTING         , anz_islighting )
                                        EndIf 
                                        IrrSetNodeMaterialFlag( anz_mesh()\nodeID , #IRR_EMF_FOG_ENABLE       , anz_isfog )

                                        ; collision zum Meta hinzufügen
                                        If anz_mesh()\Collisiontype        = #anz_ColType_solid 
                                              ; objekt ist Gebäude         , berg etc.
                                              
                                                 ; mesh collision - setzten
                                                 If     anz_mesh()\Collisiondetail = #anz_col_mesh  ; wird hier immer neugeladen, weil das node ja auch neu ist ;) 
                                                        anz_mesh()\collisionNodeID = IrrGetCollisionGroupFromComplexMesh( anz_mesh()\meshID  , anz_mesh()\nodeID )
                                                 ElseIf anz_mesh()\Collisiondetail = #anz_col_box 
                                                        anz_mesh()\collisionNodeID = IrrGetCollisionGroupFromBox( anz_mesh()\nodeID ) 
                                                 EndIf 
                                                 
                                              ; collisionnode zum Collision-Meta hinzufügen (wo alle festen objecte drin sind)
                                              IrrAddCollisionGroupToCombination( anz_CollisionMeta_solid   , anz_mesh()\collisionNodeID ) ; hier sind alle unbeweglichen teile drin. [häuser.., immobilien halt ;)]
                                        ElseIf anz_mesh()\Collisiontype    = #anz_ColType_movable 
                                              ; Objekt ist Lebewesen.      -> collisionsanimator ;)
                                              IrrGetNodeExtentTransformed  ( anz_mesh()\nodeID       , @x1 , @y1 , @z1)
                                              IrrGetNodeCenterTransformed  ( anz_mesh()\nodeID       , @x2 , @y2 , @z2)
                                              anz_mesh()\collisionanimator = IrrAddCollisionAnimator ( anz_CollisionMeta_solid , anz_mesh()\nodeID , x1 *0.48 , y1 *0.48 , z1 *0.48 , 0 , -anz_getGravity() , 0 , x2 , y2 , z2  )
                                        EndIf 
                                     Else  ;Objekt war nicht ladbar (evtl falscher pfad usw.)
                                        ; Referenz "kugel" erstellen 
                                        anz_mesh()\nodeID = IrrAddSphereSceneNode( #meter * 0.5 , 20) ; nur halber meter groß.
                                        ; mesh verschieben, rotaten, scalieren.
                                        IrrSetNodePosition( anz_mesh()\nodeID , anz_Object3d()\x , anz_Object3d()\y , anz_Object3d()\z)
                                        IrrSetNodeRotation( anz_mesh()\nodeID , anz_mesh()\rotx , anz_mesh()\roty , anz_mesh()\rotz)
                                        IrrSetNodeScale   ( anz_mesh()\nodeID , anz_mesh()\scalex , anz_mesh()\scaley , anz_mesh()\scalez)
                                        ; evtl beim rotieren 3 mal IrrRotateNodeByCenter( 
                                        ; mesh verwaltung
                                        anz_mesh()\geladen      = 1                          
                                        
                                        ; mesh material 
                                        anz_setMeshMaterial   ( anz_mesh() , #IRR_EMT_NORMAL_MAP_SOLID ) ; setzte materialtype + texturen.
                                        ; mesh collision setzen -> frombox, weils nur ne kugel ist ;)
                                        anz_mesh()\collisionNodeID = IrrGetCollisionGroupFromBox( anz_mesh()\nodeID ) 
                                        ; collision zum Meta hinzufügen
                                        If anz_mesh()\Collisiontype        = #anz_ColType_solid 
                                              ; objekt ist Gebäude         , berg etc.
                                              IrrAddCollisionGroupToCombination( anz_CollisionMeta_solid   , anz_mesh()\collisionNodeID ) ; hier sind alle unbeweglichen teile drin. [häuser.., immobilien halt ;)]
                                        ElseIf anz_mesh()\Collisiontype    = #anz_ColType_movable 
                                              ; Objekt ist Lebewesen.      -> collisionsanimator ;)
                                              IrrGetNodeExtentTransformed  ( anz_mesh()\nodeID       , @x1 , @y1 , @z1)
                                              IrrGetNodeCenterTransformed  ( anz_mesh()\nodeID       , @x2 , @y2 , @z2)
                                              anz_mesh()\collisionanimator = IrrAddCollisionAnimator ( anz_CollisionMeta_solid , anz_mesh()\nodeID , x1 *0.48 , y1 *0.48 , z1 *0.48 , 0 , -anz_getGravity() , 0 , x2 , y2 , z2  )
                                        EndIf 
                                        
                                     EndIf 
                                 EndIf 
                                 
EndMacro 

; --------------------------------------------------------------------
; Procedures..
; --------------------------------------------------------------------
   
   ; input-Procedures Mouse 
   
   Procedure anz_mousebutton( ButtonNR , anz_mouseevent_art = -1)
      
      If ButtonNR = 1
         If anz_mouseevent_art = anz_mb1 Or anz_mouseevent_art = -1
            ProcedureReturn anz_mb1
         EndIf 
      ElseIf ButtonNR = 2
         If anz_mouseevent_art = anz_mb2 Or anz_mouseevent_art = -1
            ProcedureReturn anz_mb2
         EndIf 
      Else
         If anz_mouseevent_art = anz_mb3 Or anz_mouseevent_art = -1
            ProcedureReturn anz_mb3
         EndIf 
      EndIf 
      
   EndProcedure 
   
   ; alle nodes abfragen (z.b. um allen meshes das material zu setzen.)
   
   Procedure anz_ExamineLoadedNodes( ToSearch_Object_art.w , only_they_in_view.b = 1 , max_distance.f = #meter * 100 , bezugX.f = -1 , bezugY.f=-1, bezugZ.f=-1) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
     Protected *p_obj.anz_Object3d , ObjectArt.w, px.f, py.f, pz.f , irr_obj.i , rasterx.i , rastery.i , rasterz.i    ; wenn OnlyItems1_OnlyWesen2 = 1, dann nur items suchen, wenn =2, dann nur wesen.
      
      ClearList( anz_Examined_node() )
      
      ; Position des Bezugspunktes.
      
      If Not ( bezugX =-1 And bezugY= -1 And bezugZ = -1) ; wenn die umgebung eines speziellen nodes abgesucht werden soll.
         px =  bezugX : py = bezugY : pz = bezugZ 
      Else  ; ansonsten einfach den spieler hernehmen.
         anz_getMeshPosition          ( spi_GetPlayerNode( spi_getcurrentplayer())   , @px , @py , @pz )
         anz_getMeshPosition          ( spi_GetPlayerNode( spi_getcurrentplayer()) , @x1 , @y1 , @z1)   ; prüft die Position des spielers. weil aus der include_spieler.pb -> befehle beginnen mit "spi_"
      EndIf 
                  
      If only_they_in_view = 1   ; dann werden nur die gesucht, die in der Nähe des Rasters sind. 
      
      ;{ alle in der nähe überprüfen
   
      rasterx = Round( px / #anz_rasterboxbreite , 1 )
      rastery = Round( py / #anz_rasterboxhohe   , 1 )
      rasterz = Round( pz / #anz_rasterboxbreite  , 1 )
      
       For x_for = -3 To 3
         For y_for = -2 To 2
            For z_for = -3 To 3
               
               ; das Raster einstellen - also für anz_raster (x,y,z)
               x         = x_for + rasterx
               y         = y_for + rastery
               z         = z_for + rasterz
               
               If x < 0 Or y < 0 Or z < 0  Or x > #anz_rasterbreite Or y > #anz_rasterhohe Or z > #anz_rasterbreite; array index darf nicht out of bounds sein!
                  Continue 
               EndIf


               For n = 0 To anz_raster ( x,y,z )\anzahl_nodes -1 ; setzt voraus, dass die node-liste sortiert ist ( kein "exist=0" )

                  ChangeCurrentElement ( anz_Object3d  () , anz_raster(x,y,z)\node[n] )  
                  *p_obj               = @anz_Object3d ()
                  ObjectArt            = *p_obj\art 
                  anz_obj_cam_dist     = math_distance3d    (px,py,pz, *p_obj\x , *p_obj\y , *p_obj\z)   ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)
                  If anz_obj_cam_dist  > max_distance  ; damit nicht alle, sondern nur die objekte inderr Nähe überprüft werden.
                     Continue 
                  EndIf 
                  
                  If ToSearch_Object_art = ObjectArt Or ToSearch_Object_art = -1
                     
                     If AddElement       ( anz_Examined_node())
                        anz_Examined_node()\Object3dID = *p_obj 
                        anz_Examined_node()\nodeart    = ObjectArt 
                     
                       Select ObjectArt 
                        
                          Case #anz_art_billboard
                           
                             ChangeCurrentElement           ( anz_billboard() , anz_Object3d()\id)
                             anz_Examined_node()\nodeID     = anz_billboard    ()\id
                             anz_Examined_node()\AnzID      = @anz_billboard   ()
                     
                          Case #anz_art_lensflare
                             
                             ChangeCurrentElement           ( anz_lensflare () , anz_Object3d()\id )
                             anz_Examined_node()\nodeID     = anz_lensflare ()\id 
                             anz_Examined_node()\AnzID      = @anz_lensflare()
                            
                           Case #anz_art_light
                           
                             ChangeCurrentElement           ( anz_light () , anz_Object3d()\id )
                             anz_Examined_node()\nodeID     = anz_light ()\nodeID 
                             anz_Examined_node()\AnzID      = @anz_light()
                           
                           Case #anz_art_mesh
                        
                             ChangeCurrentElement           ( anz_mesh () , anz_Object3d()\id )
                             anz_Examined_node()\nodeID     = anz_mesh ()\nodeID 
                             anz_Examined_node()\AnzID      = @anz_mesh()
                            
                           Case #anz_art_particle 
                           
                             ChangeCurrentElement           ( anz_particle () , anz_Object3d()\id )
                             anz_Examined_node()\nodeID     = anz_particle ()\nodeID 
                             anz_Examined_node()\AnzID      = @anz_particle()
                           
                           Case #anz_art_sound3d
                           
                             ChangeCurrentElement           ( anz_sound3d () , anz_Object3d()\id )
                             anz_Examined_node()\nodeID     = anz_sound3d ()\id 
                             anz_Examined_node()\AnzID      = @anz_sound3d()
                           
                           Case #anz_art_terrain
                           
                             ChangeCurrentElement           ( anz_terrain () , anz_Object3d()\id )
                             anz_Examined_node()\nodeID     = anz_terrain ()\nodeID 
                             anz_Examined_node()\AnzID      = @anz_terrain()
                           
                           Case #anz_art_skybox
                              
                              anz_Examined_node()\nodeID     = anz_skybox\nodeID 
                              anz_Examined_node()\AnzID      = @anz_skybox 
                           
                           Case #anz_art_Waypoint
                              
                              anz_Examined_node()\nodeID     = anz_Object3d()\id 
                              anz_Examined_node()\AnzID      = anz_Object3d()\id  ; beides gleich, da wayopints keine 3d-körper haben.
                              
                       EndSelect 
                     EndIf 
                  EndIf 
               Next 
            Next 
         Next 
      Next 
      
      ;}
      
      Else ; wenn alle nodes überhaupt gesucht werdne sollen
         
         ;{ suche aller nodes überhaupt
            
            ResetList( anz_Object3d())
            
               While NextElement(anz_Object3d())
            
                  *p_obj               = @anz_Object3d ()
                  ObjectArt            = *p_obj\art 
                  anz_obj_cam_dist     = math_distance3d    (px,py,pz, *p_obj\x , *p_obj\y , *p_obj\z)   ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)
                  If anz_obj_cam_dist  > max_distance  ; damit nicht alle, sondern nur die objekte inderr Nähe überprüft werden.
                     Continue 
                  EndIf 
                  
                  If AddElement       ( anz_Examined_node())
                     anz_Examined_node()\Object3dID = *p_obj 
                     anz_Examined_node()\nodeart    = ObjectArt 
                     
                     If ToSearch_Object_art = ObjectArt Or ToSearch_Object_art = -1
                     
                      Select ObjectArt 
                        
                        Case #anz_art_billboard
                           
                           ChangeCurrentElement           ( anz_billboard() , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_billboard   ()\id
                           anz_Examined_node()\AnzID      = @anz_billboard  ()
                     
                        Case #anz_art_lensflare
                           
                           ChangeCurrentElement           ( anz_lensflare () , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_lensflare ()\id 
                           anz_Examined_node()\AnzID      = @anz_lensflare()
                           
                        Case #anz_art_light
                           
                           ChangeCurrentElement           ( anz_light () , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_light ()\nodeID 
                           anz_Examined_node()\AnzID      = @anz_light()
                           
                        Case #anz_art_mesh
                        
                           ChangeCurrentElement           ( anz_mesh () , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_mesh ()\nodeID 
                           anz_Examined_node()\AnzID      = @anz_mesh()
                           
                        Case #anz_art_particle 
                           
                           ChangeCurrentElement           ( anz_particle () , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_particle ()\nodeID 
                           anz_Examined_node()\AnzID      = @anz_particle()
                           
                        Case #anz_art_sound3d
                           
                           ChangeCurrentElement           ( anz_sound3d () , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_sound3d ()\id 
                           anz_Examined_node()\AnzID      = @anz_sound3d()
                           
                        Case #anz_art_terrain
                           
                           ChangeCurrentElement           ( anz_terrain () , anz_Object3d()\id )
                           anz_Examined_node()\nodeID     = anz_terrain ()\nodeID 
                           anz_Examined_node()\AnzID      = @anz_terrain()
                         
                         Case #anz_art_skybox
                              
                            anz_Examined_node()\nodeID     = anz_skybox\nodeID 
                            anz_Examined_node()\AnzID      = @anz_skybox 
                         
                         Case #anz_art_Waypoint
                              
                            anz_Examined_node()\nodeID     = anz_Object3d()\id 
                            anz_Examined_node()\AnzID      = anz_Object3d()\id  ; beides gleich, da wayopints keine 3d-körper haben.
                              
                     EndSelect 
                   EndIf 
                 EndIf 
              Wend 
      
      ;}
      
      EndIf 
      
   EndProcedure 
   
   Procedure anz_NextExaminedNode()
      ProcedureReturn NextElement( anz_Examined_node())
   EndProcedure 
   
   Procedure anz_ExaminedNodeAnzID()  ; z.b. ListID von anz_mesh()
      ProcedureReturn anz_Examined_node()\AnzID 
   EndProcedure 
   
   Procedure anz_ExaminedNodeArt() ; ob light, mesh, particle usw.
      ProcedureReturn anz_Examined_node()\nodeart 
   EndProcedure 
   
   Procedure anz_ExaminedNodeObj3DID()
      ProcedureReturn anz_Examined_node()\Object3dID 
   EndProcedure 
   
   Procedure anz_ExaminedNodeIrrID()
      ProcedureReturn anz_Examined_node()\nodeID 
   EndProcedure 

   ; Basics
      
   Procedure anz_Skybox( texture_up.s, texture_down.s , texture_left.s , texture_right.s, texture_front.s , texture_back.s  )
       
      If anz_skybox\nodeID 
         IrrRemoveNode ( anz_skybox\nodeID )
      EndIf 
      
      anz_skybox\nodeID = IrrAddSkyBoxToScene( IrrGetTexture(texture_up.s), IrrGetTexture(texture_down.s ), IrrGetTexture(texture_left.s ), IrrGetTexture(texture_right.s), IrrGetTexture(texture_front.s ), IrrGetTexture(texture_back.s  ))
      
      ProcedureReturn anz_skybox\nodeID 
      
   EndProcedure 
   
   Procedure anz_ende  (    ) ; beendet das ganze, ohne jegliches Speichern!!! nicht fürn hausgebraucht"!
      Delay            ( 10 )  ; warten, um error zu vermeiden.
      IrrStop          (    )
      Delay            ( 10 )
      IrrKlangStop     (    )
      Delay            ( 10 )
      End
   EndProcedure 
   
   Procedure anz_savepreferences()
   
      If OpenPreferences     ("anzeige_preferences.pref") ; die allgemeine anzeigepreferencedatei
         WritePreferenceLong ("resolutionx"       , anz_getscreenwidth()) ; auflösung x
         WritePreferenceLong ("resolutiony"       , anz_getscreenheight()) ; auflösungy speichern, zum auflösung ändern
         WritePreferenceLong ("resolutiondepth"   , anz_getscreendepth()) ; farbtiefen, standard =32 bit.
         WritePreferenceLong ("IsShadow"          , anz_IsShadowEnabled()) ; geometrie-schatten, = 1
         WritePreferenceLong ("isnormalmapping"   , anz_IsNormalmappingEnabled()) ; normalmapping
         WritePreferenceLong ("isparallaxmapping" , anz_IsParallaxmappingEnabled()) ; wenn parallaxmapping an, dann für alle objekte, auch wenn normalmapping an is.
         WritePreferenceLong ("islighting"        , anz_IsLightingEnabled() )
         WritePreferenceLong ("isfog"             , anz_IsFogEnabled() )
      Else
         CreatePreferences   ("anzeige_preferences.pref")   ; die allgemeine anzeigepreferencedatei
         WritePreferenceLong ("resolutionx"       , anz_getscreenwidth()) ; auflösung x
         WritePreferenceLong ("resolutiony"       , anz_getscreenheight()) ; auflösungy speichern, zum auflösung ändern
         WritePreferenceLong ("resolutiondepth"   , anz_getscreendepth()) ; farbtiefen, standard =32 bit.
         WritePreferenceLong ("IsShadow"          , anz_IsShadowEnabled()) ; geometrie-schatten, = 1
         WritePreferenceLong ("isnormalmapping"   , anz_IsNormalmappingEnabled()) ; normalmapping
         WritePreferenceLong ("isparallaxmapping" , anz_IsParallaxmappingEnabled()) ; wenn parallaxmapping an, dann für alle objekte, auch wenn normalmapping an is.
         WritePreferenceLong ("islighting"        , anz_IsLightingEnabled() )
         WritePreferenceLong ("isfog"             , anz_IsFogEnabled() )
      EndIf 
      
   EndProcedure 
   
   Procedure anz_loadpreferences()
   
      If OpenPreferences            ( "anzeige_preferences.pref")
         anz_setresolution          ( ReadPreferenceLong( "resolutionx" , 1024) , ReadPreferenceLong( "resolutiony" , 768), ReadPreferenceLong( "resolutiondepth",32),0)
         anz_enable_shadow          ( ReadPreferenceLong( "IsShadow" , 1))         ; schatten machen manchmal probleme..
         anz_enable_normalmapping   ( ReadPreferenceLong( "isnormalmapping" , 1))  ; wenns technisch nicht geht, gehts net.
         anz_enable_parallaxmapping ( ReadPreferenceLong( "isparallaxmapping", 1)) ; auch hier.
         anz_enable_lighting        ( ReadPreferenceLong( "islighting" , 0 ))      ; licht.. sollte immer aus sein.
         anz_enable_fog             ( ReadPreferenceLong( "isfog" , 0 ))           ; nebel.. sollte auch immer aus sein.
      EndIf 
      
   EndProcedure 
   
   Procedure anz_error(text.s)
      If IrrRunning()
         *element.i = IrrGuiAddMessageBox(#programmname+ " Fehler:" , text )
      Else 
         MessageRequester( #programmname + "fehler" , text , #MB_ICONINFORMATION)
      EndIf 
   EndProcedure 
   
   Procedure anz_pauseGame(IsPause)
      anz_pause = IsPause    
   EndProcedure 
   
   Procedure anz_IsPauseGame()
      ProcedureReturn IsPause 
   EndProcedure 
   
   Procedure.f anz_getObjectScreenHeight ( x.f,y.f,z.f, ObjectHeight.f )
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected x1.f , y1.f , z1.f ,distance.f 
        
        IrrGetNodeAbsolutePosition          ( anz_camera        , @x1, @y1 , @z1 )
        distance                    = math_distance3d   ( x,y,z,x1 ,y1 ,z1 )      ; versuch mit center statt koordinaten.
        
      ProcedureReturn ObjectHeight   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
   
   Procedure.f anz_getObjectScreenWidth ( x.f,y.f,z.f, Objectwidth.f )
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected x1.f , y1.f , z1.f, distance.f 
        
        IrrGetNodeAbsolutePosition          ( anz_camera        , @x1, @y1 , @z1 )
        distance                    = math_distance3d   ( x,y,z,x1 ,y1 ,z1 )      ; versuch mit center statt koordinaten.
        
      ProcedureReturn Objectwidth   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
 
   Procedure.f anz_getObjectScreenDepth ( x.f,y.f,z.f, ObjectDepth.f )
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected x1.f , y1.f , z1.f ,distance.f 
        
        IrrGetNodeAbsolutePosition          ( anz_camera        , @x1, @y1 , @z1 )
        distance                    = math_distance3d   ( x,y,z,x1 ,y1 ,z1 )      ; versuch mit center statt koordinaten.
        
      ProcedureReturn ObjectDepth   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
   
   ; meshes bearbeiten
   
   Procedure.f anz_getMeshScreenheight( *p_anz_Object3D.anz_Object3d  )  ; gibt die aktuelle Pixelhöhe des Meshes auf dem Bildschirm zurück. (wie groß es auf dem bildschirm ist.)
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected x.f , y.f , z.f , Figurheight.f , x1.f , y1.f , z1.f , sizex.f,sizey.f,sizez.f ,distance.f , currentobject.i
        
        currentobject               = @anz_mesh()                                  ; falls etwas von dem aktuellen object des anz_mesh abhängig ist 
        ChangeCurrentElement        ( anz_mesh()        , *p_anz_Object3D\id )     ; -> wird am ende wieder zum hier aktuellen geschaltet
        IrrGetNodeExtentTransformed ( anz_mesh()\nodeID , @sizex ,@Figurheight ,@sizez)
        IrrGetNodeAbsolutePosition          ( anz_camera        , @x, @y , @z )
        IrrGetNodeCenterTransformed ( anz_mesh()\nodeID , @x1,@y1,@z1)
        distance                    = math_distance3d   ( x,y,z,x1 ,y1 ,z1 )      ; versuch mit center statt koordinaten.
        ChangeCurrentElement        ( anz_mesh()        , currentobject )         ; rücksetzen des anfangs current objects.
        
      ProcedureReturn Figurheight   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
   
   Procedure.f anz_getmeshscreenwidth( *p_anz_Object3D.anz_Object3d)
      
      ; formel:    width = Figurwidth / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      
      Protected x.f , y.f , z.f , Figurewidth.f , x1.f , y1.f , z1.f , distance.f 
      
        currentobject               = @anz_mesh()                           ; falls etwas von dem aktuellen object des anz_mesh abhängig ist 
        ChangeCurrentElement        ( anz_mesh() , *p_anz_Object3D\id )     ; -> wird am ende wieder zum hier aktuellen geschaltet
        IrrGetNodeExtentTransformed ( anz_mesh()\nodeID , @Figurewidth,@y,@z)
        IrrGetNodeAbsolutePosition          ( anz_camera , @x, @y , @z )
        distance                    = math_distance3d ( x,y,z,*p_anz_Object3D\x , *p_anz_Object3D\y , *p_anz_Object3D\z )
        ChangeCurrentElement        ( anz_mesh() , currentobject )         ; rücksetzen des anfangs current objects.
      
      ProcedureReturn Figurewidth   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
      
   EndProcedure 
   
   Procedure.f anz_getmeshscreendepth( *p_anz_Object3D.anz_Object3d)
      
            ; formel:    width = Figurwidth / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      
      Protected x.f , y.f , z.f , Figurewidth.f , x1.f , y1.f , z1.f , distance.f 
      
        currentobject               = @anz_mesh()                           ; falls etwas von dem aktuellen object des anz_mesh abhängig ist 
        ChangeCurrentElement        ( anz_mesh() , *p_anz_Object3D\id )     ; -> wird am ende wieder zum hier aktuellen geschaltet
        IrrGetNodeExtentTransformed ( anz_mesh()\nodeID , @Figurewidth,@y,@z)
        IrrGetNodeAbsolutePosition          ( anz_camera , @x, @y , @z )
        distance                    = math_distance3d ( x,y,z,*p_anz_Object3D\x , *p_anz_Object3D\y , *p_anz_Object3D\z )
        ChangeCurrentElement        ( anz_mesh() , currentobject )         ; rücksetzen des anfangs current objects.
      
      ProcedureReturn Figurewidth   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
      
   EndProcedure 
   
   Procedure anz_getBoneNodeID (*p_anz_mesh.anz_mesh , bonename.s )
      
      ProcedureReturn IrrGetB3DJointNode ( *p_anz_mesh\nodeID , bonename ) 
      
   EndProcedure 
   
   Procedure anz_unchild ( *Object3dID.anz_Object3d , only_one_child.w =1) ; removes every child-parent connection in children and childchildren, if only_one_child = 0 (for example when a wesen dies)
       Protected *Object3dID_child.anz_Object3d ,x
       If Not  *Object3dID    ; prüfen, ob werte stimmen
          ProcedureReturn 0
       EndIf 
      
       ; schaun, ob mesh geladen, wenn ja: irrlichtwise das ding unlinken.
       
       For x = 0 To #anz_max_children -1
          If *Object3dID\child[x]              > 0
            *Object3dID_child                  = *Object3dID\child[x]
            If anz_IsObject3dParent            ( *Object3dID_child )  ; wenn es parent ist
               anz_unchild                     ( *Object3dID_child )  ; seine children auch löschen.
            EndIf 
            *Object3dID_child\ParentID         = 0                    ; danach gehts mit DEssen parent weiter ^^ ;) (rekursive aufruf-technik :P ;) )
            *Object3dID_child\ParentID_IS_BONE = ""
            *Object3dID\child[x]               = 0
            *Object3dID\ anzahl_children       - 1
            anz_delete_object3d                ( *Object3dID_child,0,0) ; damn wichtig! irrremoveallchilds löscht einfch alle irrnodes --> vorher entregistriern
          EndIf 
          
       Next 

   EndProcedure 
   
   Procedure anz_unloadChildren (*Object3dID.anz_Object3d ) ; deletes only the Irrnode-IDS and unloads every child, but the connection will survive
       Protected *Object3dID_child.anz_Object3d ,x

       If Not  *Object3dID    ; prüfen, ob werte stimmen
          ProcedureReturn 0
       EndIf 
       ; schaun, ob mesh geladen, wenn ja: irrlichtwise das ding unlinken.
       
       For x = 0 To #anz_max_children -1
          If *Object3dID\child[x]                 > 0
            *Object3dID_child                     = *Object3dID\child[x]
            If anz_getobject3dIsGeladen           ( *Object3dID_child )
               If anz_IsObject3dParent            ( *Object3dID_child )
                  anz_unloadChildren              ( *Object3dID_child )
               EndIf 
               anz_freenode                       ( *Object3dID_child ,0) ; damn wichtig! irrremoveallchilds löscht einfch alle irrnodes --> vorher entregistriern
            EndIf 
          EndIf 
          
       Next 
       
   EndProcedure 
   
   Procedure anz_IsObject3dChild ( *Object3dID.anz_Object3d ) ; prüft, ob obj3d ein child eines andren objektes ist .
      If *Object3dID\ParentID > 0
          ProcedureReturn 1
      EndIf 
   EndProcedure 
   
   Procedure anz_IsObject3dParent ( *Object3dID.anz_Object3d ) ; prüft, ob obj3d ein PARENT ist.
      If *Object3dID\anzahl_children > 0
         ProcedureReturn 1
      EndIf 
   EndProcedure
   
   Procedure anz_attachobject (*Object3dID.anz_Object3d  , *Object3dID_child.anz_Object3d , x = 0 , y = 0 , z = 0 , ParentID_IS_BONE.s ="" ) ; Child an Parent festkleben. wenn ParentID_IS_BONe, so wird der hier angegebene Knochen des OBJECT3DIDs als Parent gewählt(standardmäßig somit auf Position 0,0,0) 
      Protected n.i 
      
      If Not ( *Object3dID And *Object3dID_child )    ; prüfen, ob werte stimmen
         ProcedureReturn 0
      EndIf 
      
      If *Object3dID\anzahl_children > #anz_max_children 
          ProcedureReturn 
      EndIf 
      
      For n = 0 To #anz_max_children -1   ; obacht, so musses da stehen!! ( n= 0 to #anz_max_children -1)
         
         If *Object3dID \ child[n] = 0          ; wenn noch ein Platz für child-nodes frei ist 
            
            If anz_getobject3dIsGeladen   ( *Object3dID )          And anz_getobject3dIsGeladen ( *Object3dID_child )  ; prüfen, ob irrlichtnodes geladen. wenn ja: irrparent setzen.
               If ParentID_IS_BONE        > ""
                  IrrAddChildToParent     ( anz_getObject3DIrrNode ( *Object3dID_child   )      , anz_getBoneNodeID      ( *Object3dID\id   , ParentID_IS_BONE) )
               Else 
                  IrrAddChildToParent     ( anz_getObject3DIrrNode ( *Object3dID_child   )      , anz_getObject3DIrrNode ( *Object3dID      ) )
               EndIf 
            EndIf 
               
               anz_setobjectPos        ( *Object3dID_child , x , y , z)  
               *Object3dID_child       \ ParentID         = *Object3dID 
               *Object3dID_child       \ ParentID_IS_BONE = ParentID_IS_BONE   ; wenn nur ein Knochen von Object3dID das Parentnode sein soll, ist ParentID_IS_BONE > ""
               *Object3dID             \ child [n]        = *Object3dID_child  ; falls dann nämlich Parent gelöscht wird, MUSS der Link vom Child zum Parent ebenfalls gelöschtwerden, wenn nicht gleich die ganze child/parent kette (im Falle eines Wesens)
               *Object3dID             \ anzahl_children   + 1
               
               ; ------------------------ PAUSE!!! -----------------------
               ; ------------------------------------------------------------------------
               ; Die Koordinaten von Childs solln nicht die globalen variablen sein.
               ; beim Neuladen werden die children ziemlich durcheinandergeworfen, weil Irrlicht die direkten Koordinaten dem child gibt!! (also: bei child soll nicht irrgetnodeabsoluteposition() sondern irrgetnodeposition gemacht werden!)
               ; eXTREM WICHTIG: alle anz_mesh() mit *p_anz_mesh - pointern ersetzen, sonst vermischen sich die Mesh-eigenschaften!
               
               
            ProcedureReturn 1
         EndIf 
         
      Next 
      
   EndProcedure 
   
   ; Objects 3D bearbeiten
   
   Procedure anz_getMeshPosition( *anz_mesh.anz_mesh ,*px.i , *py.i , *pz.i ) ; @x , @y , @z!! if = 0 -> ignored.
      Protected *obj3d.anz_Object3d ,x1.f,y1.f,z1.f
      
      If *anz_mesh = 0
         ProcedureReturn 0
      EndIf 
      
      If *anz_mesh\nodeID > 0 And *anz_mesh\geladen = 1
         
         IrrGetNodePosition ( *anz_mesh\nodeID , @x1 , @y1 , @z1 )
         
         If *px > 0
            PokeF ( *px , x1 )
         EndIf 
         If *py > 0
            PokeF ( *py , y1 )
         EndIf 
         If *pz > 0
            PokeF ( *pz , z1 )
         EndIf 
         
      Else ; wenns nicht geladen ist
      
         *obj3d = anz_getobject3dByAnzID( *anz_mesh)
         If Not *obj3d
            ProcedureReturn 0
         EndIf 
         x1     = *obj3d\x
         y1     = *obj3d\y 
         z1     = *obj3d\z 
         
         If *px > 0
            PokeF ( *px , x1 )
         EndIf 
         If *py > 0
            PokeF ( *py , y1 )
         EndIf 
         If *pz > 0
            PokeF ( *pz , z1 )
         EndIf 
         
      EndIf 
            
   EndProcedure 
   
   Procedure anz_getobject3dByAnzID( *AnzID.i  , anz_art.i = #anz_art_mesh ) ; sucht das zugehörige object 3d zum Anz_..id ; bsp: anz_art = #anz_art_mesh
      Protected *anz_billboard.anz_billboard , *anz_lensflare.anz_lensflare , *anz_light.anz_light , *anz_mesh.anz_mesh , *anz_particle.anz_particle, *anz_sound3d.anz_sound3d,*anz_terrain.anz_terrain, *way_waypoint.WAYPOINT  
      
      If *AnzID = 0
         ProcedureReturn 0
      EndIf 
      
      Select anz_art 
         
         Case #anz_art_billboard
            *anz_billboard        = *AnzID 
            ProcedureReturn      *anz_billboard\Object3dID 
         Case #anz_art_lensflare
            *anz_lensflare        = *AnzID 
            ProcedureReturn      *anz_lensflare\Object3dID 
         Case #anz_art_light
            *anz_light            = *AnzID 
            ProcedureReturn      *anz_light\Object3dID 
         Case #anz_art_mesh
            *anz_mesh             = *AnzID 
            ProcedureReturn      *anz_mesh\Object3dID 
         Case #anz_art_particle
            *anz_particle         = *AnzID 
            ProcedureReturn      *anz_particle\Object3dID 
         Case #anz_art_skybox    ; kein output; skybox hat kein object3d und keine position
         Case #anz_art_sound3d
            *anz_sound3d          = *AnzID 
            ProcedureReturn      *anz_sound3d\Object3dID 
         Case #anz_art_terrain
            *anz_terrain          = *AnzID 
            ProcedureReturn      *anz_terrain\Object3dID 
         Case #anz_art_Waypoint
            *way_waypoint         = *AnzID 
            ProcedureReturn      *way_waypoint\Object3dID 
            
      EndSelect 
      
   EndProcedure
   
   Procedure anz_getobject3dByNodeID( nodeID.i  ) ; sucht das zugehörige object 3d zum IRR Node
      Protected anz_save_object3d.i ; saves the previous list element 
      Protected *p_anz_Object3D.anz_Object3d  , *waypoint.WAYPOINT
      
      If nodeID = 0 ; zur Sicherheit.
         ProcedureReturn 0
      EndIf 
      
      ; gibt die Object3d-nummer zurück, wenn man nur die nodeid hat.
      anz_save_object3d     = anz_Object3d()
      
      ResetList            ( anz_Object3d())
               
        While NextElement  ( anz_Object3d())
           
           *p_anz_Object3D = anz_Object3d()
           
           If Not *p_anz_Object3D
              ProcedureReturn 0
           EndIf 
           
           art             = anz_Object3d()\art 
                  
              Select art 
         
                 Case #anz_art_billboard
                    
                    ChangeCurrentElement( anz_billboard() , *p_anz_Object3D\id )
                    If anz_billboard()\id = nodeID 
                       Break 
                    EndIf 
                    
                 Case #anz_art_lensflare
                    
                    ChangeCurrentElement( anz_lensflare() , *p_anz_Object3D\id )
                    If anz_lensflare()\id = nodeID 
                       Break
                    EndIf 
                    
                 Case #anz_art_light
                    
                    ChangeCurrentElement( anz_light() , *p_anz_Object3D\id )
                    If anz_light()\nodeID = nodeID 
                       Break
                    EndIf 
                    
                 Case #anz_art_mesh
                    
                    ChangeCurrentElement( anz_mesh() , *p_anz_Object3D\id )
                    If anz_mesh()\nodeID = nodeID 
                       Break
                    EndIf 
                    
                 Case #anz_art_particle
                    
                    ChangeCurrentElement( anz_particle() , *p_anz_Object3D\id )
                    If anz_particle()\nodeID = nodeID 
                       Break
                    EndIf 
                    
                 Case #anz_art_terrain
                    
                    ChangeCurrentElement( anz_terrain() , *p_anz_Object3D\id )
                    If anz_terrain()\nodeID = nodeID 
                       Break
                    EndIf 
                    
                 Case #anz_art_sound3d
                    
                    ChangeCurrentElement( anz_sound3d() , *p_anz_Object3D\id )
                    If anz_sound3d()\id = nodeID 
                       Break 
                    EndIf 
                 
                 Case #anz_art_Waypoint
                    
                    If *waypointid = nodeID ; da wayopoint ja kein eigenes 3d-objekt ist könnte stattdessen der Pointer zum waypoint gemeint gewesen sein.
                       Break 
                    EndIf 
              EndSelect 
      
        Wend 
        
        
        ; Alte ID wieder als aktuelles Element setzen. 
        If anz_save_object3d > 0 ; wenn überhaupt ein element vorhanden war
           ChangeCurrentElement( anz_Object3d() , anz_save_object3d)
        EndIf 
        
        ; wird ja abgebrochen, sobald ID gefunden -> gefundene ID zurückgeben = letzte ID.
        If *p_anz_Object3D > 0
           ProcedureReturn *p_anz_Object3D
        EndIf 
        
   EndProcedure
   
   Procedure anz_getObject3DIrrNode ( *p_anz_Object3D.anz_Object3d)
      
      If *p_anz_Object3D = 0
         ProcedureReturn 0
      EndIf 
      
      Select *p_anz_Object3D\art 
      
         Case #anz_art_billboard
            
            ChangeCurrentElement           ( anz_billboard() , *p_anz_Object3D\id )
            ProcedureReturn anz_billboard()\id 
            
         Case #anz_art_lensflare
            
            ChangeCurrentElement           ( anz_lensflare() , *p_anz_Object3D\id )
            ProcedureReturn anz_lensflare()\id 
            
         Case #anz_art_light
            
            ChangeCurrentElement           ( anz_light() , *p_anz_Object3D\id )
            ProcedureReturn anz_light()\nodeID 
            
         Case #anz_art_mesh
         
            ChangeCurrentElement           ( anz_mesh() , *p_anz_Object3D\id )
            ProcedureReturn anz_mesh()\nodeID 
            
         Case #anz_art_particle
            
            ChangeCurrentElement           ( anz_particle() , *p_anz_Object3D\id )
            ProcedureReturn anz_particle()\nodeID 
            
         Case #anz_art_skybox
            
            ProcedureReturn anz_skybox\nodeID  ; keine liste.. es gibt nur eine skybox.
           
         Case #anz_art_sound3d
            
            ChangeCurrentElement           ( anz_sound3d() , *p_anz_Object3D\id )
            ProcedureReturn anz_sound3d()\id 
            
         Case #anz_art_terrain
            
            ChangeCurrentElement           ( anz_terrain() , *p_anz_Object3D\id )
            ProcedureReturn anz_terrain()\nodeID 
         
         Case #anz_art_Waypoint
            
            ProcedureReturn 0
            
      EndSelect 
      
   EndProcedure 
   
   Procedure anz_getobject3dIsGeladen ( *p_anz_Object3D.anz_Object3d) ; prüft, ob das IRRNODE geladen ist. 
      Protected *anz_billboard.anz_billboard 
      
      If *p_anz_Object3D = 0
         ProcedureReturn 0
      EndIf 
      
      Select *p_anz_Object3D\art 
      
         Case #anz_art_terrain
            
            ChangeCurrentElement           ( anz_terrain() , *p_anz_Object3D\id )
            If anz_terrain()\geladen And anz_terrain()\nodeID > 0
                ProcedureReturn 1
            EndIf 
            
         Case #anz_art_mesh
            
            ChangeCurrentElement           ( anz_mesh() , *p_anz_Object3D\id )
            If anz_mesh()\geladen And anz_mesh()\nodeID > 0
                ProcedureReturn 1
            EndIf 
            
         Case #anz_art_particle
            
            ChangeCurrentElement           ( anz_particle() , *p_anz_Object3D\id )
            If anz_particle()\geladen 
                ProcedureReturn 1
            EndIf 
         
         Case #anz_art_billboard 
           
           *anz_billboard = *p_anz_Object3D\id 
           
           If *anz_billboard\id > 0
              ProcedureReturn 1
           EndIf 
            
         Case #anz_art_Waypoint  ; wayopints sind nie "geladen". ihre existenz ist am pointer abzulesen. (sind kein irrlicht objekt)
         
            ProcedureReturn 0
            
         Default 
         
            ProcedureReturn 1 ; der Rest ist immer geladen, also von irrlicht her vorhanbden.
         
      EndSelect
      
   EndProcedure 
   
   Procedure anz_setobjectPos ( *Object3dID.anz_Object3d , Posx.f , Posy.f , Posz.f  )  
      Protected x.i , y.i , z.i , x1.i , y1.i , z1.i , px.f , py.f , pz.f , nx.f , ny.f , nz.f 
      
      ; obacht, es kann sein, dass daas Node ja hängenbleibt. in dem Fall darf man es nicht in den nächsten Rasterblock rüberwerfen.
      If anz_getobject3dIsGeladen( *Object3dID)
         ; werte direkt von Irrlicht holen
         *irrNode          = anz_getObject3DIrrNode(*Object3dID)
         IrrGetNodePosition( *irrNode , @px , @py , @pz )
         IrrSetNodePosition( *irrNode , Posx , Posy , Posz )
         IrrGetNodePosition( *irrNode , @nx , @ny , @nz )
         
      Else  
         ; wenn Objekt nicht da, Werte von Referenzen holen.
         px = *Object3dID\x
         py = *Object3dID\y
         pz = *Object3dID\z
         *Object3dID\x = Posx 
         *Object3dID\y = Posy 
         *Object3dID\z = Posz
         nx = Posx 
         ny = Posy 
         nz = Posz
      EndIf 
      
      ; die alte Rasterposition suchen
      
      x = Round( (px) / #anz_rasterboxbreite  , 1 )  ; x = rasterx 
      y = Round( (py) / #anz_rasterboxhohe    , 1 )  ; y = rasterx ...
      z = Round( (pz) / #anz_rasterboxbreite  , 1 )
      
      ; die tatsächliche neue Rasterposition suchen
      
      x1 = Round( (nx) / #anz_rasterboxbreite  , 1 )  ; x = rasterx 
      y1 = Round( (ny) / #anz_rasterboxhohe   , 1 )  ; y = rasterx ...
      z1 = Round( (nz) / #anz_rasterboxbreite  , 1 )
      
      If Not ( x = x1 And y = y1 And z = z1 ); wenn der spieler aus einem Rasterstein geht (bzw. das Objekt)
         
         ; 1. Schritt: aus dem Alten Rasterblock rausschneiden
         
         anz_raster_Unregister (*Object3dID)
         
         ; 2. Schritt: BEWEGEN (wenn obj3d nicht geladen isses oben schon passiert. )
         
         *Object3dID\x = nx ; ist nx, da posx ja nur die gewünschte Position ist.  
         *Object3dID\y = ny
         *Object3dID\z = nz
         
         ; 3. Schritt: im neuen rasterblock reinwerfen 
         
         anz_Raster_Register  ( *Object3dID )
         
         ; 4. Schritt: Rückgabe, ob neupos setzen geglückt, oder nicht.
         
         If ( nx = Posx And ny = Posy And nz = Posz)
            ProcedureReturn 1
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_turnObject ( *Object3dID.anz_Object3d , rotx.f , roty.f , rotz.f , rotart = #anz_rotart_xyz) ; bisher NUR Anz_mesh! rotart = #anz_rotart_x z.b.
      Protected x.f, y.f, z.f , *anz_mesh.anz_mesh
      
      If Not *Object3dID\art = #anz_art_mesh 
         ProcedureReturn 0
      EndIf 
      
      *anz_mesh = *Object3dID\id 
      
      If anz_getobject3dIsGeladen( *Object3dID)
         ; werte direkt von Irrlicht holen
         *irrNode          = anz_getObject3DIrrNode(*Object3dID)
         If *irrNode 
            IrrGetNodeRotation ( *irrNode , @x , @y , @z)
         EndIf 
      Else 
         x = *anz_mesh \rotx 
         y = *anz_mesh \roty
         z = *anz_mesh \rotz
      EndIf 
      
      Select rotart 
         
         Case #anz_rotart_x
            
            x + rotx ; nur die x koordinate neu setzen.. der rest kommt vom aktuellen drehwinkel des meshes.
            
         Case #anz_rotart_y
            y + roty 
         Case #anz_rotart_z
            
            z + rotz ; rotation - z....! ;) (nicht dass verwechslungen auftreten)
            
         Case #anz_rotart_xyz , #anz_rotart_x | #anz_rotart_y | #anz_rotart_z 
            
            x + rotx : y + roty : z + rotz
            
         Case #anz_rotart_x |#anz_rotart_y
         
            x + rotx : y + roty 
            
         Case #anz_rotart_x|#anz_rotart_z
         
            x + rotx : z + rotz 
            
         Case #anz_rotart_y|#anz_rotart_z
         
            y + roty : z + rotz
            
      EndSelect 
      
      If anz_getobject3dIsGeladen ( *Object3dID ) ; wenn geladen 
         IrrSetNodeRotation       ( anz_getObject3DIrrNode(*Object3dID) , x , y , z ) ; auf irrlict-ebene aktualisieren
      EndIf 
      
      *anz_mesh\rotx = x  ; auf anz_object3d ebene aktualisieren.
      *anz_mesh\roty = y
      *anz_mesh\rotz = z 
         
   EndProcedure 
   
   Procedure anz_moveObject ( *Object3dID.anz_Object3d , Forward.f , right.f , up.f )   ; bewegt  Object3d, wenn geladen auch IRRNODE. wobei: wenn Irrnode hängt: object3d\xyz = irrnode\xyz
      ; prüft, in welchem Rasterblock das Objekt gerade ist (bei beweglichen Objekten z.b. Held)
      Protected x.i , y.i , z.i , x1.i , y1.i , z1.i , px.f , py.f , pz.f , nx.f , ny.f , nz.f , Rot.IRR_VECTOR , *anz_mesh.anz_mesh , piover180.f , bewegx.f , bewegy.f , bewegz.f
      
      ; obacht, es kann sein, dass daas Node ja hängenbleibt. in dem Fall darf man es nicht in den nächsten Rasterblock rüberwerfen.
      If anz_getobject3dIsGeladen( *Object3dID)
         ; werte direkt von Irrlicht holen
         *irrNode          = anz_getObject3DIrrNode(*Object3dID)

         IrrGetNodePosition( *irrNode , @px , @py , @pz ) ; startposition
         IrrMoveNodeForward( *irrNode , Forward )  ; bewegen des nodes.
         IrrMoveNodeRight  ( *irrNode , right   )
         IrrMoveNodeUp     ( *irrNode , up      )
         IrrGetNodePosition( *irrNode , @nx , @ny , @nz ) ; endposition für start-endraster berechnung, um zu sehen, ob raster wechselt.
         *Object3dID\x = px  ; die alte position festlegen.
         *Object3dID\y = py  
         *Object3dID\z = pz  
      Else  
         ; wenn Objekt nicht da, Werte von Referenzen holen.
         If *Object3dID\art = #anz_art_mesh ; rotscale wird nur bei meshes gespeichert
            *anz_mesh  = *Object3dID\id 
            Rot\x     = *anz_mesh\rotx 
            Rot\y     = *anz_mesh\roty 
            Rot\z     = *anz_mesh\rotz  ; ansonsten wird von einer 0-rotation ausgegangen. 
         EndIf 
         
         px            = *Object3dID\x
         py            = *Object3dID\y
         pz            = *Object3dID\z
         piover180     = (ATan(1)*4)/180 
         bewegx        = -Sin(Rot\y*piover180)*right 
         bewegy        =  Sin(Rot\x*piover180)*up    ; bei diesem bin ich mir net sicher.. wenn fehler dann hier. 
         bewegz        = -Cos(Rot\y*piover180)*Forward 
         nx            = px + bewegx  
         ny            = py + bewegy 
         nz            = pz + bewegz 
      EndIf 
      
      ; die alte Rasterposition suchen
      
      x = *Object3dID\rasterx ; Round( (px) / #anz_rasterboxbreite  , 1 )  ; x = rasterx 
      y = *Object3dID\rastery ; Round( (py) / #anz_rasterboxhohe    , 1 )  ; y = rasterx ...
      z = *Object3dID\rasterz ; Round( (pz) / #anz_rasterboxbreite  , 1 )
      
      ; die tatsächliche neue Rasterposition suchen
      
      x1 = Round( (nx) / #anz_rasterboxbreite  , 1 )  ; x = rasterx 
      y1 = Round( (ny) / #anz_rasterboxhohe    , 1 )  ; y = rasterx ...
      z1 = Round( (nz) / #anz_rasterboxbreite  , 1 )
      
      ; schauen, ob er jetzt in nem neuen Raster ist

      If Not ( x = x1 And y = y1 And z = z1 ); wenn das Objekt aus einem Rasterbereich geht (bzw. der spieler)
         
         ; 1. Schritt: aus dem Alten Rasterblock rausschneiden
         
         anz_raster_Unregister (*Object3dID)
         ; 2. Schritt: BEWEGEN
         
         *Object3dID\x = nx  ; die tatsächliche Position des Objekts (wenn er irgenwo dagegengestoßen ist, dann ist bewegxyz ja kleiner etc)
         *Object3dID\y = ny  
         *Object3dID\z = nz 
         
         ; 3. Schritt: im neuen rasterblock reinwerfen 
         
         anz_Raster_Register  ( *Object3dID )
         
         
      EndIf 
      
   EndProcedure
   
   Procedure anz_setmeshscale ( *anz_mesh.anz_mesh  , scalex.f , scaley.f , scalez.f )
      
      If Not *anz_mesh
         ProcedureReturn 0
      EndIf 
      
      *anz_mesh\scalex = scalex  ; scalierung setzen
      *anz_mesh\scaley = scaley
      *anz_mesh\scalez = scalez
      If *anz_mesh\geladen And *anz_mesh\nodeID > 0
         IrrSetNodeScale( *anz_mesh\nodeID , scalex , scaley , scalez) ; scalieren, wenn geladen
      EndIf 
      
      ProcedureReturn 1
      
   EndProcedure 
   
   ; Raster
   
   Procedure anz_Raster_Register ( *Object3dID.anz_Object3d )
      Protected x.i,y.i,z.i , px.f , py.f , pz.f 
      
         ; wenn Objekt nicht da, Werte von Referenzen holen.
         px = *Object3dID\x
         py = *Object3dID\y
         pz = *Object3dID\z
      
      x = Round( (px) / #anz_rasterboxbreite  , 1 )  ; x = rasterx 
      y = Round( (py) / #anz_rasterboxhohe    , 1 )  ; y = rasterx ...
      z = Round( (pz) / #anz_rasterboxbreite  , 1 )
      
      ; prüfen, ob das objekt noch im raster-array.
      If x < 0 Or y < 0 Or z < 0 Or x > #anz_rasterbreite Or y > #anz_rasterhohe Or z > #anz_rasterbreite ; wenn durch die Bewegung das Objekt nicht mehr im Raster ist
         ProcedureReturn 0  ; sofort abbrechen, sonst invalid memory access!
      EndIf 
      
      For n = 0 To #anz_raster_maxrasterelements -1
         
         If anz_raster ( x,y,z) \node[n]       = 0
            anz_raster ( x,y,z) \node[n]       = *Object3dID 
            anz_raster ( x,y,z )\anzahl_nodes  + 1
            *Object3dID\rasterx                = x
            *Object3dID\rastery                = y
            *Object3dID\rasterz                = z
            ProcedureReturn 1
         EndIf 
         
      Next 
      
   EndProcedure 
   
   Procedure anz_raster_Unregister ( *Object3dID.anz_Object3d) 
      Protected x.i , y.i , z.i , px.f , py.f , pz.f
      
         ; darf nicht auf irrlicht zugreifen, weil objekt zum berechnen schn versetzt wurde.,  -> Werte von Referenzen holen.
         
      x = *Object3dID\rasterx 
      y = *Object3dID\rastery 
      z = *Object3dID\rasterz 
      
      If x < 0 Or y < 0 Or z < 0 Or x > #anz_rasterbreite Or y > #anz_rasterhohe Or z > #anz_rasterbreite ; wenn durch die Bewegung das Objekt nicht mehr im Raster ist
         ProcedureReturn 0  ; sofort abbrechen, sonst invalid memory access!
      EndIf 
      
      ; durchsuchen der Nodes des Rasterblockes nach dem zu löschenden Node
      For n = 0 To anz_raster ( x,y,z )\anzahl_nodes -1
         
         If anz_raster( x,y,z) \node[n]     = *Object3dID 
            
            anz_raster( x,y,z) \node[n]     = 0
            removed                         = n                                    ; das zu löschende speichern
            n                               = anz_raster ( x,y,z )\anzahl_nodes -1 ; zum letzen element springen
            anz_raster(x,y,z)\node[removed] = anz_raster ( x,y,z )\node[n]       ; das existierende übers  alte drüberschreiben. ( wenn nur 1 element vorhanden war, wird null=null gesetzt)
            anz_raster ( x,y,z )\node[n]    = 0
            anz_raster(x,y,z)\anzahl_nodes  - 1
            ProcedureReturn 1
         EndIf 

      Next
      
   EndProcedure 
   
   ; particles bearbeiten
   
   Procedure anz_particle_Set_Particles_Per_second_temporary( *p_particle.anz_particle , min_particles_per_second.f , max_particles_per_second.f , Size.f)
      Protected SmokeEmitter.IRR_PARTICLE_EMITTER
      
      ; prüfen, obs nicht genau den gewünschten Wert schon hat.
      If Not ( *p_particle\current_max_paritlcles_per_second = max_particles_per_second And *p_particle\current_min_paritlcles_per_second = min_particles_per_second)
      
      ;{ setzen der neuen min_particles

      If Not min_particles_per_second = -1
         *p_particle\nodestruct\min_paritlcles_per_second = min_particles_per_second
      Else 
         *p_particle\nodestruct\min_paritlcles_per_second = *p_particle\nodestruct\min_paritlcles_per_second
      EndIf 
      
      If Not max_particles_per_second = -1
         *p_particle\nodestruct\max_paritlcles_per_second = max_particles_per_second
      Else 
         *p_particle\nodestruct\max_paritlcles_per_second = *p_particle\nodestruct\max_paritlcles_per_second
      EndIf 
      
      ;}
      
      ;{ setzen der smokeEmitter- structur ( also farbe, refreshrate usw. des emitters )
      
      SmokeEmitter\min_box_x                 = *p_particle\nodestruct\min_box_x 
      SmokeEmitter\min_box_y                 = *p_particle\nodestruct\min_box_y 
      SmokeEmitter\min_box_z                 = *p_particle\nodestruct\min_box_z
      SmokeEmitter\max_box_x                 = *p_particle\nodestruct\max_box_x 
      SmokeEmitter\max_box_y                 = *p_particle\nodestruct\max_box_y 
      SmokeEmitter\max_box_z                 = *p_particle\nodestruct\max_box_z
      SmokeEmitter\direction_x               = *p_particle\nodestruct\direction_x 
      SmokeEmitter\direction_y               = *p_particle\nodestruct\direction_y 
      SmokeEmitter\direction_z               = *p_particle\nodestruct\direction_z
      SmokeEmitter\min_paritlcles_per_second = *p_particle\nodestruct\min_paritlcles_per_second
      SmokeEmitter\max_paritlcles_per_second = *p_particle\nodestruct\max_paritlcles_per_second 
      SmokeEmitter\max_angle_degrees         = *p_particle\nodestruct\max_angle_degrees
      SmokeEmitter\min_lifetime              = *p_particle\nodestruct\min_lifetime
      SmokeEmitter\max_lifetime              = *p_particle\nodestruct\max_lifetime
      SmokeEmitter\min_start_color_red       = *p_particle\nodestruct\min_start_color_red
      SmokeEmitter\min_start_color_green     = *p_particle\nodestruct\min_start_color_green
      SmokeEmitter\min_start_color_blue      = *p_particle\nodestruct\min_start_color_blue
      SmokeEmitter\max_start_color_red       = *p_particle\nodestruct\max_start_color_red
      SmokeEmitter\max_start_color_green     = *p_particle\nodestruct\max_start_color_green
      SmokeEmitter\max_start_color_blue      = *p_particle\nodestruct\max_start_color_blue
      
      ;}
      
      ;{ irrlicht -> Emitter aktualisieren
         
      If *p_particle\art = #anz_particle_art_default 
         *em = IrrAddParticleEmitter( *p_particle\nodeID , @SmokeEmitter)
      ElseIf *p_particle\art = #anz_particle_art_sphere 
         *em =  IrrAddParticleSphereEmitter(*p_particle\nodeID , @SmokeEmitter, 0,0,0,Size)
      ElseIf *p_particle\art = #anz_particle_art_ring 
         If If_IsRingThickness = -1
            If_IsRingThickness = *p_particle\RingThickness
         Else 
            *p_particle\RingThickness = If_IsRingThickness
         EndIf 
         *em =  IrrAddParticleRingEmitter(*p_particle\nodeID , @SmokeEmitter, 0,0,0,Size , If_IsRingThickness)
      EndIf 
      
      ;}
      
      ; fade out, gravity -affektors sind alle noch aktiv, werden also nicht gelöscht, wenn emitter aktualisiert wird.
      
      EndIf 
      
      ProcedureReturn *p_particle\nodeID
   EndProcedure 
   
   Procedure anz_particle_changeflags ( *p_particle.anz_particle , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = -1 , particleheight.f = -1, max_angle_degrees.f = -1, min_lifetime.i = -1 , max_lifetime.i = -1 , If_IsRingThickness.f =-1) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
      ; verändert die Flags nur im irrlicht-system, nicht im 
      
      Protected SmokeEmitter.IRR_PARTICLE_EMITTER
   
      ;{ width/height der partikel setzen
   
      If particlewidth > -1  ; breite wird neu gesetzt
         If particleheight > -1 ; auch höhe wird neu gesetzt
            IrrSetParticleSize( *p_particle\nodeID , particlewidth, particleheight )
            *p_particle\particlewidth  = particlewidth 
            *p_particle\particleheight = particleheight 
         Else          ; höhe wird nicht geändert
            IrrSetParticleSize( *p_particle\nodeID , particlewidth , *p_particle\particleheight)
            *p_particle\particlewidth = particlewidth 
         EndIf 
      Else ; breite wird nicht verändert
         If particleheight > -1 ; aber höhe wird neu gesetzt
            IrrSetParticleSize( *p_particle\nodeID , *p_particle\particlewidth, particleheight )
            *p_particle\particleheight = particleheight 
         Else          ; höhe wird nicht geändert
             ; nichts wird verändert
         EndIf 
      EndIf 
   
   ;}
      
      ;{ setzen der smokeEmitter- structur ( also farbe, refreshrate usw. des partikels
      
      SmokeEmitter\min_box_x = *p_particle\nodestruct\min_box_x 
      SmokeEmitter\min_box_y = *p_particle\nodestruct\min_box_y 
      SmokeEmitter\min_box_z = *p_particle\nodestruct\min_box_z
      SmokeEmitter\max_box_x = *p_particle\nodestruct\max_box_x 
      SmokeEmitter\max_box_y = *p_particle\nodestruct\max_box_y 
      SmokeEmitter\max_box_z = *p_particle\nodestruct\max_box_z
      
      ; wenn auch nur 1 Parameter = -1 - ist, dann wird diese eigenschaft nicht verändert.  
      ; ( sieht übel aus, wenn mans für jeden parameter extra coden muss..)
      If Not direction_x = -1
         SmokeEmitter\direction_x = direction_x 
      Else
         SmokeEmitter\direction_x = *p_particle\nodestruct\direction_x 
      EndIf 
      If Not direction_y = -1
         SmokeEmitter\direction_y = direction_y 
      Else 
         SmokeEmitter\direction_y = *p_particle\nodestruct\direction_y 
      EndIf 
      If Not direction_z = -1
         SmokeEmitter\direction_z = direction_z 
      Else 
         SmokeEmitter\direction_z = *p_particle\nodestruct\direction_z
      EndIf 
      If Not min_particles_per_second = -1     
         SmokeEmitter\min_paritlcles_per_second = min_particles_per_second
      Else 
         SmokeEmitter\min_paritlcles_per_second = *p_particle\nodestruct\min_paritlcles_per_second
      EndIf 
      If Not max_particles_per_second = -1 ; die eigenen heißen "particles", die irrlichten heißen "paritcles".
         SmokeEmitter\max_paritlcles_per_second = max_particles_per_second  ; buchstabendreher vonseiten irrlicht tsts.
      Else 
         SmokeEmitter\max_paritlcles_per_second = *p_particle\nodestruct\max_paritlcles_per_second 
      EndIf  
      If Not max_angle_degrees = -1
         SmokeEmitter\max_angle_degrees  = max_angle_degrees
      Else 
         SmokeEmitter\max_angle_degrees  = *p_particle\nodestruct\max_angle_degrees
      EndIf  
      If Not min_lifetime = -1
         SmokeEmitter\min_lifetime       = min_lifetime 
      Else 
         SmokeEmitter\min_lifetime = *p_particle\nodestruct\min_lifetime
      EndIf  
      If Not max_lifetime = -1
         SmokeEmitter\max_lifetime       = max_lifetime 
      Else 
         SmokeEmitter\max_lifetime = *p_particle\nodestruct\max_lifetime
      EndIf  
      SmokeEmitter\min_start_color_red   = *p_particle\nodestruct\min_start_color_red
      SmokeEmitter\min_start_color_green = *p_particle\nodestruct\min_start_color_green
      SmokeEmitter\min_start_color_blue  = *p_particle\nodestruct\min_start_color_blue
      SmokeEmitter\max_start_color_red   = *p_particle\nodestruct\max_start_color_red
      SmokeEmitter\max_start_color_green = *p_particle\nodestruct\max_start_color_green
      SmokeEmitter\max_start_color_blue  = *p_particle\nodestruct\max_start_color_blue
      
      ;}
      
      ;{ neuen Emitter setzen
     
      If *p_particle\art = #anz_particle_art_default 
         *em = IrrAddParticleEmitter( *p_particle\nodeID , @SmokeEmitter)
      ElseIf *p_particle\art = #anz_particle_art_sphere 
         *em =  IrrAddParticleSphereEmitter(*p_particle\nodeID , @SmokeEmitter, 0,0,0,Size)
      ElseIf *p_particle\art = #anz_particle_art_ring 
         If If_IsRingThickness = -1
            If_IsRingThickness = *p_particle\RingThickness
         Else 
            *p_particle\RingThickness = If_IsRingThickness
         EndIf 
         *em =  IrrAddParticleRingEmitter(*p_particle\nodeID , @SmokeEmitter, 0,0,0,Size , If_IsRingThickness.f)
      EndIf 
      
      ;}
    
      ; fade out, gravity -affektors sind alle noch aktiv, werden also nicht gelöscht, wenn emitter aktualisiert wird.
      
  ProcedureReturn *p_particle\nodeID 
  
  EndProcedure 
  
   ; Anzeige Settings von Preferences
   
   Procedure anz_setresolution(x,y,depth,ISNeustart=1)
      
      anz_resolutionx     = x    ; die globale variablen setzen
      anz_resolutiony     = y 
      anz_resolutiondepth = depth
      anz_savepreferences ()     ; und hier dann speichern
      
      If ISNeustart = 1 ; wichtig, damit die auflösung auch gleich geändert wird.
         RunProgram( "neustart.exe")  ; es muss eine neustart.exe gemacht werden, die unser programm nach Xsekunden wieder startet.
         anz_ende()
      EndIf 
      
   EndProcedure 
   
   Procedure.w anz_getscreenwidth ()
      ProcedureReturn anz_resolutionx
   EndProcedure 
   
   Procedure.w anz_getscreenheight()
      ProcedureReturn anz_resolutiony
   EndProcedure
   
   Procedure.w anz_getscreendepth()
      ProcedureReturn anz_resolutiondepth
   EndProcedure 
   
   Procedure anz_IsShadowEnabled()
      ProcedureReturn anz_isshadow
   EndProcedure 
   
   Procedure anz_enable_shadow( enable.w)
      anz_isshadow = enable
       
      If enable ; wenns angeschaltet wird, und nicht ausgeschaltet
          anz_ExamineLoadedNodes( #anz_art_mesh )
          While anz_NextExaminedNode()
              
              ChangeCurrentElement ( anz_mesh (), anz_ExaminedNodeAnzID())
              If anz_mesh()\geladen 
                 IrrAddNodeShadow     ( anz_ExaminedNodeIrrID())
              EndIf 
              
          Wend 
      EndIf 
   EndProcedure    
   
   Procedure anz_enable_normalmapping( enable.w)
      anz_isnormalmapping = enable
      ; enable normalmapping for all objects
   EndProcedure 
   
   Procedure anz_enable_lighting  ( enable.w)
      anz_islighting = enable 
   EndProcedure 
    
   Procedure anz_IsLightingEnabled()
      ProcedureReturn anz_islighting 
   EndProcedure 
   
   Procedure anz_enable_fog ( enable.w)
      anz_isfog = enable 
   EndProcedure 
   
   Procedure anz_IsFogEnabled()
      ProcedureReturn anz_isfog 
   EndProcedure
   
   Procedure anz_IsNormalmappingEnabled()
      ProcedureReturn anz_isnormalmapping 
   EndProcedure 
   
   Procedure anz_enable_parallaxmapping( enable.w)
      anz_isparallaxmapping = enable
      ; enable parallaxmapping for all objects
   EndProcedure 
      
   Procedure anz_IsParallaxmappingEnabled()
      ProcedureReturn anz_isparallaxmapping
   EndProcedure 
   
   Procedure anz_MeshisGeladen ( *anz_mesh.anz_mesh )
      ProcedureReturn *anz_mesh\geladen 
   EndProcedure 
   
   ; Welt Management 
   
   Procedure.f anz_getGravity  ()
      ProcedureReturn  9.81 / 360 * #meter ; (Meter pro Sekunde Hoch 2.. 1 Sekunde = 60 fps etwa)
   EndProcedure 
 
   ; Image management -- complete ;)
   
   Procedure anz_loadimage( NR.i, x.f , y.f , pfad.s, Usealpha.b, ishidden.b = 1) 
      Protected anz_image_NotFound.i , id.i 
      Static    ZufallsNR.i
      
      ; use list image.image()
      
       id = anz_loadtexture ( pfad)
       
       If id 
       
           If NR = -1 ; wenn der Benutzer sich seine NR selbst festlegen will..
              ZufallsNR + 1
              NR = ZufallsNR 
           Else 
              If ZufallsNR < NR ; sobald der benutzer eine NR festlegt, die größer ist, als die aktuelle zufallsNR, 
                 ZufallsNR = NR ; so wird die zufallsNR genauso groß wie die NR. dadurch wird das nächste ZufallsNR NACH dem vom benutzer festgelegten NR-bild gesetzt.
              EndIf 
           EndIf 
           
           AddElement( anz_image())
             anz_image()\x        = x
             anz_image()\y        = y
             anz_image()\Alpha    = Usealpha
             anz_image()\NR       = NR
             anz_image()\id       = id
             anz_image()\ishidden = 0
             ProcedureReturn NR
             
       Else 
          
          ;{ wenn nicht geladen,dann selber zeichnen ;)
          
          anz_image_NotFound = CreateImage( #PB_Any , 128,128)
          
          If StartDrawing   ( ImageOutput( anz_image_NotFound))
                DrawingMode ( 1 )
                DrawingFont ( FontID ( #anz_PBFont ))
                DrawText    ( 2 ,26 ,"Image Not Found" + Chr(10) + "" + GetFilePart(pfad) , RGB(255,255,255) , 0)
             StopDrawing    ()
          EndIf 
          
          IrrPBImage2Texture ( anz_image_NotFound , "Image Not Found")
          anz_error          ( "Konnte bild " + pfad + "  nicht laden!")
          FreeImage          ( anz_image_NotFound )  ; wieder rauslöschen. ham ja jetz die Textur.
          
          ;}
          
       EndIf 
      
   EndProcedure 
   
   Procedure anz_setimagepos ( NR , x.f,y.f)
      
      If ListSize( anz_image())             ; sind überhaupt elemente vorhanden..
      
         If Not anz_image()\NR = NR         ; schaut, ob's aktuelle bild das gesuchte ist.
         
            ResetList( anz_image())         ; ansonsten wird gesucht..
            
               While NextElement(anz_image())
                  If anz_image()\NR = NR
                     anz_image()\x = x
                     anz_image()\y = y 
                     ProcedureReturn @anz_image()
                  EndIf 
               Wend 
            
         Else 
            anz_image()\x = x
            anz_image()\y = y 
            ProcedureReturn @anz_image()
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_getimagepos( NR.i ,*x.f,*y.f)
   
      If ListSize( anz_image())             ; sind überhaupt elemente vorhanden..
      
         If Not anz_image()\NR = NR         ; schaut, ob's aktuelle bild das gesuchte ist.
         
            ResetList( anz_image())         ; ansonsten wird gesucht..
            
               While NextElement(anz_image())
                  If anz_image()\NR = NR
                     *x = anz_image()\x 
                     *y = anz_image()\y 
                  EndIf 
               Wend 
            
         Else 
            *x = anz_image()\x
            *y = anz_image()\y 
            ProcedureReturn @anz_image()
         EndIf 
         
      Else 
         ProcedureReturn 0
      EndIf 
   EndProcedure 
   
   Procedure anz_getimageID( NR.i) ; gibt nen pointer zu anz_image heraus.
      
      If ListSize( anz_image())             ; sind überhaupt elemente vorhanden..
      
         If Not anz_image()\NR = NR         ; schaut, ob's aktuelle bild das gesuchte ist.
         
            ResetList( anz_image())         ; ansonsten wird gesucht..
            
               While NextElement(anz_image())
                  If anz_image()\NR = NR
                      ProcedureReturn @anz_image()
                  EndIf 
               Wend 
            
         Else 
            ProcedureReturn @anz_image()
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_hideimage (NR.i , hide.b)
      
      If ListSize( anz_image())             ; sind überhaupt elemente vorhanden..
      
         If Not anz_image()\NR = NR         ; schaut, ob's aktuelle bild das gesuchte ist.
         
            ResetList( anz_image())         ; ansonsten wird gesucht..
            
               While NextElement(anz_image())
                  If anz_image()\NR = NR
                      anz_image()\ishidden = hide 
                      ProcedureReturn @anz_image()
                  EndIf 
               Wend 
            
         Else 
            anz_image()\ishidden = hide 
            ProcedureReturn @anz_image()
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_freeimage(NR.i)
      
      If ListSize( anz_image())             ; sind überhaupt elemente vorhanden..
      
         If Not anz_image()\NR = NR         ; schaut, ob's aktuelle bild das gesuchte ist.
         
            ResetList( anz_image())         ; ansonsten wird gesucht..
            
               While NextElement(anz_image())
                  If anz_image()\NR = NR                ; wenn die Nummer gefunden ist.
                      anz_freetexture( anz_image()\id ) ; löschen der Textur (id = TextureID)
                      DeleteElement(anz_image())        ; löschen der kennung (des listenelementes)
                      ProcedureReturn 1
                  EndIf 
               Wend 
            
         Else 
            anz_freetexture( anz_image()\id )
            DeleteElement(anz_image())
            ProcedureReturn 1
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_isimagehidden( NR.i)
      Protected *anz_image.anz_image 
      
      *anz_image      = anz_getimageID ( NR )
      ProcedureReturn *anz_image\ishidden 
      
   EndProcedure
   
   Procedure anz_getimageNRbyID( id.i) ; gibt die NR des images anhand des irrlichtpointers heraus.
      
      ResetList( anz_image())
         While NextElement ( anz_image())
            If anz_image()\id = id 
               ProcedureReturn anz_image()\NR 
            EndIf  
         Wend 
         
   EndProcedure 
   
   ; texture management 
   
   Procedure anz_loadtexture( pfad.s)  ; wenn 2*die gleiche textur: zähler mitlaufen lassen. beim löschen wird erst wenn zähler wieder = 0 -> die textur gelöscht
      
      ResetList( anz_texture() )
      ; ProcedureReturn IrrGetTexture( pfad )
      While NextElement ( anz_texture() )
         If anz_texture()\pfad           = pfad 
            anz_texture()\Counter        + 1
            ProcedureReturn anz_texture()\id 
         EndIf 
      Wend 
      
      ; wenns allerdings nicht geladen wurde:
      
      
      If AddElement ( anz_texture())
         anz_texture()\pfad    = pfad 
         anz_texture()\id      = IrrGetTexture( pfad )
         anz_texture()\Counter = 1
         
         If anz_texture()\id  = 0
            
            anz_texture_NotFound = CreateImage       ( -1 , 512 , 512 , 32)
            If StartDrawing      ( ImageOutput( anz_texture_NotFound))
                  DrawingMode    ( 1 )
                  Box            ( 0 , 0 , ImageWidth ( anz_texture_NotFound ) , ImageHeight ( anz_texture_NotFound ) , RGB ( 255,255,255))
                  DrawingFont    ( FontID ( #anz_PBFont ))
                  DrawText       ( 2 ,26 ,"Image Not Found" + Chr(10) + "" + GetFilePart(pfad) , RGB(255,255,255) , 0)
               StopDrawing       ()
            EndIf 
            anz_texture()\id      = IrrPBImage2Texture   ( anz_texture_NotFound , "Image Not Found")
          
         EndIf 
         
         ProcedureReturn anz_texture()\id 
      
      EndIf 
   EndProcedure 
   
   Procedure anz_gettexturebypfad( pfad.s) ; wenn pfad nicht vorhanden: 0 herausgeben !
      
      ResetList (anz_texture())
         
         While NextElement( anz_texture())
            
            If anz_texture()\pfad = pfad 
               ProcedureReturn anz_texture()\id 
            EndIf 
         
         Wend 
         
         ProcedureReturn 0 ; wenns nicht gefunden wurde.
         
   EndProcedure 
   
   Procedure anz_freetexture (IrrTextureID.i)  ; erst wenn der zähler wieder auf 0 ist wird Textur gelöscht.
      
      ResetList( anz_texture())
         
         While NextElement( anz_texture())
            
            If anz_texture    ()\id = IrrTextureID
               anz_texture    ()\Counter - 1 ; ein material weniger braucht diese Textur.
               ; IrrDropPointer ( anz_texture()\id ) ; irrlicht selbst zählt auch mit.. mit droppointer wird textur abgemeldet. (hoffe ich o_O)
               If anz_texture ()\Counter = 0
                  DeleteElement ( anz_texture())
                  ; löschen
               EndIf 
               ProcedureReturn 1 ; konnte gelöscht werden
            EndIf 
         Wend 
         
         ProcedureReturn 0 ; wenns nicht gelöscht werden konnnte
      
   EndProcedure 
   
   ; load things 
   
   Procedure anz_addmesh( pfad.s, x.f,y.f,z.f, texture.s , MaterialType.b , normalmap.s , DirectLoad.b = 0, Collisiondetail.b = #anz_col_box , Collisiontype.b = #anz_ColType_solid , rotx.f=0,roty.f=0,rotz.f=0,scalx.f=1,scaly.f=1,scalz.f=1, islighting.i = 0 , width.f = #meter * 3 , height.f = #meter*4 , depth.f = #meter * 3)
      Protected currentlistenobject.i , *anz_mesh.anz_mesh 
      Protected x1.f , y1.f, z1.f , x2.f , y2.f , z2.f
      
      If ListSize                      ( anz_mesh ()) > 0
         currentlistenobject           = anz_mesh()
         LastElement                   ( anz_mesh()) ; sonst invalid memory access..???!!!! argh ihr macht mich fertig..
      EndIf 
      
      ; schaun, ob pfad ladbar, texturen etc da sind.
      
         If ReadFile     ( 0 , pfad ) = 0 ; mesh prüfen
            pfad         = #pfad_meter 
         Else 
            CloseFile    ( 0 )
         EndIf 
         
         ; TEXTURE NICHT PRÜFEN.. evtl soll irrlicht das alles laden.
         ; If Not ReadFile ( 0 , texture )  ; Texture 1 prüfen
            ; texture      = "gfx\standard_texture.jpg"
         ; Else 
            ; CloseFile    ( 0 )
         ; EndIf 
         ; 
         ; If Not ReadFile ( 0 , normalmap ) ; Texture 2 prüfen
            ; normalmap    = "gfx\standard_texture.jpg"
         ; Else 
            ; CloseFile    ( 0 )
         ; EndIf 
      
      
      ; mesh laden 
      
         *anz_mesh                     =  AddElement( anz_mesh())
          
            If *anz_mesh
            
               With *anz_mesh
                  
                  \width                = width
                  \height               = height
                  \depth                = depth
                  \pfad                 = pfad 
                  \scalex               = scalx 
                  \scaley               = scaly
                  \scalez               = scalz
                  \rotx                 = rotx
                  \roty                 = roty
                  \rotz                 = rotz
                  \geladen              = 0
                  \meshID               = 0
                  \nodeID               = 0
                  \texture              = texture     ; evtl müssma hierfür parameter bei der procedure einfügen.
                  \texture_normalmap    = normalmap
                  \irr_emt_materialtype = MaterialType
                  \collisionNodeID      = 0
                  \Collisiondetail      = Collisiondetail
                  \Collisiontype        = Collisiontype
                  \islighting           = islighting 
                  
               EndWith 

            AddElement( anz_Object3d() )
               
               With anz_Object3d()
                  
                  \id = *anz_mesh
                  \art = #anz_art_mesh 
                  \x   = x
                  \y   = y
                  \z   = z
                  *anz_mesh\Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
               EndWith 
               
         If DirectLoad = 1  ; gleich in irrlicht einladen.
            
            anz_setShownObjects_loadMesh()
         
         EndIf 
         
         ; noch im Raster registrieren...
         anz_Raster_Register(anz_Object3d())
       
       EndIf 
       
       ; altes anz_mesh wiederherstellen.
       If currentlistenobject
          ChangeCurrentElement( anz_mesh() , currentlistenobject )
       EndIf
      
      ProcedureReturn *anz_mesh   ; man kann also mit changecurrentelement ( anz_mesh() , anz_addmesh(..) ) aufs aktuelle anz_mesh wechseln, oder gleich *anz_mesh.anz_mesh = anz_addmesh(...)
      
   EndProcedure 
   
   Procedure anz_AddBillboard( pfad.s, x.f,y.f,z.f , width.f , height.f , MaterialType.i = #IRR_EMT_TRANSPARENT_ADD_COLOR , DirectLoad.i = 0)
       
      Protected currentlistenobject.i , newbillboard.i , *anz_billboard.anz_billboard , irr_obj.i
      If ListSize ( anz_billboard() ) > 0
         currentlistenobject = @anz_billboard()
      EndIf 
      
         AddElement( anz_billboard())
            
            *anz_billboard = anz_billboard()
            With anz_billboard()
               
               \id                   = 0
               \irr_emt_materialtype = MaterialType 
               \width                = width
               \height               = height 
               \pfad                 = pfad 
               \lighting             = 0
            EndWith 

         AddElement( anz_Object3d() )
            
            With anz_Object3d()
            
               \id = @anz_billboard()
               \art = #anz_art_billboard
               \x   = x
               \y   = y
               \z   = z
               *anz_billboard\Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
            EndWith 
         
          ; directes laden, wenn gleich geladen werden soll / muss.
          If DirectLoad > 0
               irr_obj  = IrrAddBillBoardToScene( *anz_billboard\width , *anz_billboard\height , x,y,z) ; p_obj ist das anz_objekt3d().
               If irr_obj
                  IrrSetNodeMaterialTexture     ( irr_obj , anz_loadtexture( *anz_billboard\pfad) , 0)
                  *anz_billboard\id             = irr_obj
                  ; material setzen
                     IrrSetNodeMaterialType     ( irr_obj , *anz_billboard\irr_emt_materialtype )
                     IrrSetNodeMaterialTexture  ( irr_obj , anz_loadtexture (*anz_billboard\pfad), 0)
                     IrrSetNodeMaterialFlag     ( irr_obj , #IRR_EMF_LIGHTING , *anz_billboard\lighting )

               EndIf 
                                 
          EndIf 
          
      anz_Raster_Register     ( anz_Object3d()) ; ins Raster registrieren
      If currentlistenobject  > 0
         ChangeCurrentElement ( anz_billboard() , currentlistenobject )
      EndIf 
      
      ProcedureReturn *anz_billboard
      
   EndProcedure 
   
   Procedure anz_addlight( RGBcolor.i, x.f,y.f,z.f, range.f)
      
      Protected currentlistenobject.i , *anz_light.anz_light 
      
      If ListSize ( anz_light () ) > 0
         currentlistenobject = @anz_light()
      EndIf 
      
         AddElement( anz_light())
            
            *anz_light             = anz_light()
            With anz_light()
               
               \nodeID             = IrrAddLight( x,y,z,Red(RGBcolor) / 255 , Green(RGBcolor) / 255 , Blue(RGBcolor) / 255 , range)
            
            EndWith 
         
         AddElement( anz_Object3d() )
            
            With anz_Object3d()
               
               \id  = @anz_light()
               \art = #anz_art_light
               \x   = x
               \y   = y
               \z   = z
               *anz_light\Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
            EndWith 
      
      anz_Raster_Register(anz_Object3d())
      If currentlistenobject > 0
         ChangeCurrentElement( anz_light() , currentlistenobject )
      EndIf 
      
      ProcedureReturn *anz_light ; die ID der List. 
      
   EndProcedure 
   
   Procedure anz_addsound3d ( pfad.s, x.f,y.f,z.f,maxdistance.f,mindistance.f , looped.i = 1) 
      
      Protected currentlistenobject.i 
      If ListSize ( anz_sound3d()) > 0
         currentlistenobject = @anz_sound3d()
      EndIf 
      
         AddElement( anz_sound3d())
            
            With anz_sound3d()
               
               \id            = IrrKlangPlay3D(@pfad,x,y,z,looped,0,1)
               \mindistance.f = mindistance
               \maxdistance.f = maxdistance
               
            EndWith 
         
         AddElement( anz_Object3d() )
            
            With anz_Object3d()
               
               \id  = @anz_sound3d()
               \art = #anz_art_sound3d
               \x   = x
               \y   = y
               \z   = z
               anz_sound3d()\Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
            EndWith 
            
      anz_Raster_Register  ( anz_Object3d())
      If currentlistenobject
         ChangeCurrentElement ( anz_sound3d () , currentlistenobject )
      EndIf 
      
   EndProcedure 
   
   Procedure anz_setwater( *p_obj3d.anz_Object3d, waveheight.f , wavespeed.f,wavelength.f, MaterialType.b =#IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER)
      Protected *anz_mesh.anz_mesh , mesh_static
      
      If *p_obj3d\art = #anz_art_mesh  ; *p_obj3d = anz_object3d()
         *anz_mesh    = *p_obj3d\id 
         mesh_static  = IrrGetStaticFromMesh( *anz_mesh\meshID )
         
         If mesh_static 
            IrrAddWaterSceneNode( mesh_static , waveheight , wavespeed , wavelength )
            If MaterialType 
               IrrSetNodeMaterialType( *anz_mesh\nodeID , MaterialType )
            EndIf 
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_addparticle (  x.f,y.f,z.f,texture.s, normalmap.s , MaterialType.i , anz_particle_art = #anz_particle_art_default , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0 , box_x.f = 10, box_y.f = 10, box_z.f = 10, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = 16 , particleheight.f = 16 , min_startcolor.i = 0, max_startcolor.i = 1, max_angle_degrees.f = 45, min_lifetime.i = 1000 , max_lifetime.i = 1500 , If_IsRingThickness.f = 20) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
      ; verändert die Flags nur im irrlicht-system, nicht im 
      
      Protected SmokeEmitter.IRR_PARTICLE_EMITTER , currentlistenobject.i , *p_particle.anz_particle 
      
      ;{ neues particlenode erstellen
         
         If ListSize ( anz_particle()) > 0
            currentlistenobject = @anz_particle()
         EndIf 
      
         AddElement( anz_particle())
            
            With anz_particle()
               
               \nodeID                            = IrrAddParticleSystemToScene(0)
               \particlewidth                     = particlewidth 
               \particleheight                    = particleheight 
               \texture1                          = texture 
               \texture2                          = normalmap 
               \irr_emt_materialtype              = MaterialType 
               \anz_particle_art                  = anz_particle_art ; obs ein sphere-particle, oder ein box, oder ring-particle ist.
               \RingThickness                     = If_IsRingThickness
               \geladen                           = 0
            EndWith 
         
         AddElement( anz_Object3d() )
            
            With anz_Object3d()
               
               \id  = @anz_particle()
               \art = #anz_art_particle
               \x   = x
               \y   = y
               \z   = z
               anz_particle()\Object3dID = anz_Object3d()
            EndWith 
            
            *p_particle = anz_particle() ; für die folgenden aufrufe wird *p_particle verwendet.
     
      ;}
      
      ;{ width/height der partikel setzen
   
            IrrSetParticleSize( *p_particle\nodeID , particlewidth, particleheight )
            *p_particle\particlewidth       = particlewidth 
            *p_particle\particleheight      = particleheight 
   
   ;}
      
      ;{ setzen der smokeEmitter- structur ( also farbe, refreshrate usw. des partikels
      
      SmokeEmitter\min_box_x = box_x
      SmokeEmitter\min_box_y = box_y
      SmokeEmitter\min_box_z = box_z
      SmokeEmitter\max_box_x = box_x
      SmokeEmitter\max_box_y = box_y
      SmokeEmitter\max_box_z = box_z
      
      ; wenn auch nur 1 Parameter = -1 - ist, dann wird diese eigenschaft nicht verändert.  
      ; ( sieht übel aus, wenn mans für jeden parameter extra coden muss..)
         SmokeEmitter\direction_x = direction_x 
         SmokeEmitter\direction_y = direction_y 
         SmokeEmitter\direction_z = direction_z  
         SmokeEmitter\min_paritlcles_per_second = min_particles_per_second
         SmokeEmitter\max_paritlcles_per_second = max_particles_per_second
         SmokeEmitter\max_angle_degrees     = max_angle_degrees
         SmokeEmitter\min_lifetime          = min_lifetime 
         SmokeEmitter\max_lifetime          = max_lifetime 
         SmokeEmitter\min_start_color_red   = Red  ( min_startcolor) / 255
         SmokeEmitter\min_start_color_green = Green( min_startcolor) / 255
         SmokeEmitter\min_start_color_blue  = Blue ( min_startcolor) / 255
         SmokeEmitter\max_start_color_red   = Red  ( max_startcolor) / 255
         SmokeEmitter\max_start_color_green = Green( max_startcolor) / 255
         SmokeEmitter\max_start_color_blue  = Blue ( max_startcolor) / 255
      
      ;}
      
      ;{ neuen Emitter setzen
      If *p_particle\art = #anz_particle_art_default 
         *em = IrrAddParticleEmitter( *p_particle\nodeID , @SmokeEmitter)
      ElseIf *p_particle\art = #anz_particle_art_sphere 
         *em =  IrrAddParticleSphereEmitter(*p_particle\nodeID , @SmokeEmitter, 0,0,0,If_IsRingThickness)
      ElseIf *p_particle\art = #anz_particle_art_ring 
             *p_particle\RingThickness = If_IsRingThickness
         *em =  IrrAddParticleRingEmitter(*p_particle\nodeID , @SmokeEmitter, 0,0,0,If_IsRingThickness , If_IsRingThickness.f)
      EndIf 
      
      ;}
      
      ;{ material setzen
      IrrSetNodeMaterialType( anz_particle()\nodeID , MaterialType )
      IrrSetNodeMaterialFlag( anz_particle()\nodeID , #IRR_EMF_LIGHTING , 0)
      If texture > ""
         IrrSetNodeMaterialTexture( anz_particle()\nodeID , anz_loadtexture( texture),0)
      EndIf 
      If normalmap > ""
         IrrSetNodeMaterialTexture( anz_particle()\nodeID , anz_loadtexture( normalmap),1)
      EndIf 
      ;}
      
      ;{ Daten auf anz_particle übertragen
      
          anz_particle()\nodestruct\min_box_x = SmokeEmitter\min_box_x                  ; The bounding box For the emitter
          anz_particle()\nodestruct\min_box_y = SmokeEmitter\min_box_y 
          anz_particle()\nodestruct\min_box_z = SmokeEmitter\min_box_z 

          anz_particle()\nodestruct\max_box_x = SmokeEmitter\max_box_x                   ; The Maximum Dimension of the Bounding Box for the Emitter
          anz_particle()\nodestruct\max_box_y = SmokeEmitter\max_box_y
          anz_particle()\nodestruct\max_box_z = SmokeEmitter\max_box_z

          anz_particle()\nodestruct\direction_x = SmokeEmitter\direction_x                ; Emitter Direction
          anz_particle()\nodestruct\direction_y = SmokeEmitter\direction_y
          anz_particle()\nodestruct\direction_z = SmokeEmitter\direction_z

          anz_particle()\nodestruct\min_paritlcles_per_second = SmokeEmitter\min_paritlcles_per_second   ; Minimum Spawnrate in Particles/Second
          anz_particle()\nodestruct\max_paritlcles_per_second = SmokeEmitter\max_paritlcles_per_second   ; Maximum Spawnrate in Particles/Second

          anz_particle()\nodestruct\min_start_color_red   = SmokeEmitter\min_start_color_red 
          anz_particle()\nodestruct\min_start_color_green = SmokeEmitter\min_start_color_green
          anz_particle()\nodestruct\min_start_color_blue  = SmokeEmitter\min_start_color_blue

          anz_particle()\nodestruct\max_start_color_red   = SmokeEmitter\max_start_color_red
          anz_particle()\nodestruct\max_start_color_green = SmokeEmitter\max_start_color_green
          anz_particle()\nodestruct\max_start_color_blue  = SmokeEmitter\max_start_color_blue
    
          anz_particle()\nodestruct\min_lifetime = SmokeEmitter\min_lifetime                 ; Minimal lifetime of a particle, in milliseconds.
          anz_particle()\nodestruct\max_lifetime = SmokeEmitter\max_lifetime                 ; Maximal lifetime of a particle, in milliseconds.
    
          anz_particle()\nodestruct\max_angle_degrees = SmokeEmitter\max_angle_degrees
    
      ;}
     
    anz_Raster_Register  ( anz_Object3d())
    If currentlistenobject
       ChangeCurrentElement ( anz_particle() , currentlistenobject )
    EndIf 
      ; fade out, gravity -affektors sind alle noch aktiv, werden also nicht gelöscht, wenn emitter aktualisiert wird.
      
      IrrAddFadeOutParticleAffector ( *p_particle\nodeID  )
      IrrSetNodePosition( *anz_particle\nodeID , x , y , z )
  ProcedureReturn *p_particle\nodeID 
  
  EndProcedure
   
   Procedure anz_addfire (x.f,y.f,z.f, firesize.f = 10, horbarrange = 1000 , texture.s = #pfad_feuer_texture , SoundPfad.s = #pfad_feuer_sound )
   
      Protected feuer
      
      feuer = anz_addparticle       ( x , y , z , texture , "" , #IRR_EMT_TRANSPARENT_ADD_COLOR , #anz_particle_art_default , 0 , 0.3*firesize , 0 , 10 , 10 , 10 , firesize *2 + 10 , firesize * 2.5 + 10 )
      anz_addsound3d                ( SoundPfad , x , y,  z , horbarrange , horbarrange/4)
      
      ProcedureReturn feuer
      
   EndProcedure
   
   Procedure anz_addterrain( pfad.s, x.f,y.f,z.f, texture1.s , texture2.s ,texturescale1.f , texturescale2.f , width.f , height.f , depth.f , MaterialType.i =#IRR_EMT_DETAIL_MAP , scalx.f=1,scaly.f=1,scalz.f=1, rotx.f=0,roty.f=0,rotz.f=0) ; width, height depth sind die extents.
      
      Protected currentlistenobject.i , *anz_terrain.anz_terrain , *anz_object_3D.anz_Object3d
      
      If ListSize ( anz_terrain() ) > 0 ; push-pop. für späteres aktuell listenelement wiederherstellen speichern
         currentlistenobject = @anz_terrain()
         FirstElement        ( anz_terrain())
      EndIf 
      
         *anz_terrain     = AddElement( anz_terrain())
            
            With *anz_terrain
               
               \nodeID             = 0  ; nicht previous laden.!
               \terrainmap         = pfad 
               \texture1           = texture1 
               \texture2           = texture2 
               \irr_emt_materialtype = MaterialType 
               \scalex             = scalx 
               \scaley             = scaly 
               \scalez             = scalz 
               \rotx               = rotx 
               \roty               = roty 
               \rotz               = rotz 
               \width              = width       ; Editor schreibt diese Werte automatisch, da er ja weiß, wie groß das Terrain ist. 
               \height             = height        ; wird mit anz_getObjectScreenwidth/heigt/depth(..) festgestellt 
               \depth              = depth 
               \texturescalex      = texturescale1
               \texturescaley      = texturescale2 
               \geladen            = 0
               \islighting         = 0
            EndWith 
            
         AddElement( anz_Object3d() )
            
            With anz_Object3d()
               
               \id  = *anz_terrain
               \art = #anz_art_terrain
               \x   = x
               \y   = y
               \z   = z
               *anz_terrain\Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
            EndWith 
      
      anz_Raster_Register ( anz_Object3d())
      
      If currentlistenobject
         ChangeCurrentElement( anz_terrain() , currentlistenobject )
      EndIf 
      
   EndProcedure 
   
   Procedure anz_addcloud ( x.f,y.f, z.f , bewegx.f =0.001, bewegy.f = 0, bewegz.f= 0.001 )
   
      If AddElement( anz_cloud())
      
         anz_cloud()\x = x 
         anz_cloud()\y = y
         anz_cloud()\z = z
         anz_cloud()\bewegx = bewegx
         anz_cloud()\bewegy = bewegy
         anz_cloud()\bewegz = bewegz 
         anz_cloud()\nodeID = anz_addparticle( x ,y , z , #pfad_cloud_texture , "" , #IRR_EMT_TRANSPARENT_ADD_COLOR , #anz_particle_art_default , bewegx  , bewegy, bewegz , 30 , 30 , 30 , 20 , 30 , 30,30, RGB(255,0,0) , RGB(255,255,255) , 90,10000,20000)
         
      EndIf 
      
      ProcedureReturn anz_cloud()\nodeID 
      
   EndProcedure 
   
   Procedure anz_addstaubwirbel( x.f,y.f,z.f, Lebensdauer.i = 1000, particle_per_second = 80)
      
      If AddElement( anz_staub())
         
         anz_staub()\lebenszeit   = ElapsedMilliseconds ( ) + 500  ; halbe sekunde lebt der Staubbatzen.
         anz_staub()\nodeID       = anz_addparticle     ( x ,y , z , #pfad_staub_texture , "" , #IRR_EMT_TRANSPARENT_ADD_COLOR , #anz_particle_art_default , 0.03  , 0.02, 0.02 , 10,10,10, 20 , 30 , 30,30,0,0,90,300,500)
         
      EndIf 
      
      ProcedureReturn anz_cloud()\nodeID 
      
   EndProcedure 
   
   Procedure anz_setfog_particle ( enable.w , fogdepth.f= 400)
   
      ; ----------------------------------------------------------------------------------------
      ; ---- Cancelled, da unwichtig!!! --------------------------------------------------------
      ; ----------------------------------------------------------------------------------------
      
      ; Static x.f,y.f,z.f 
      ; 
      ; IrrGetNodePosition( anz_camera , @x,@y,@z)
      ; 
      ; anz_attachobject ( anz_camera , anz_addmesh( #anz_fog_pfad ,0,x,y,z, 0 , 0 , 0 , 0 ))
      
   EndProcedure 
   
   ; load map, init 3d engine.
   
   Procedure anz_initstuff(IsFullscreen ) ; auflösung usw. wird aus anzeige_preferences.pref gelesen.
   
      ; Font laden
      LoadFont(#anz_PBFont , "Papyrus" , 10 )
      ; preferences
      anz_loadpreferences()
      ; 3d screen
      If Not IrrStartEx   ( #IRR_EDT_DIRECT3D9 , anz_getscreenwidth() , anz_getscreenheight(), IsFullscreen  , anz_IsShadowEnabled() , 1 , anz_getscreendepth() , 1 , 0 , 1 , 0)      
         MessageRequester ( #programmname + " Error" , "Konnte die 3D Engine auf ihrem Computer nicht ausführen. Eventuell hilft ein DirectX update von Microsoft. Fragen sie hierzu bitte einen Administrator" , #MB_SYSTEMMODAL )
         End 
      EndIf 
      ; 3d sound
      If Not IrrKlangStart()
         MessageRequester ( #programmname + " Error" , "Konnte 3D Sound auf ihrem Computer nicht ausführen. Eventuell hilft ein DirectX update von Microsoft oder Sie verfügen nicht über genügend Administrations-Rechte, bzw. Ihr Soundtreiber ist deinstalliert. Fragen sie hierzu bitte einen Administrator" )
         End 
      EndIf 
      ; title
      IrrSetWindowCaption( #programmname ) 
      ; Metaselector
      anz_CollisionMeta_solid = IrrCreateCombinedCollisionGroup()
      IrrDisplayMouse( 0 ) 
      IrrSetFog      ( 255,111,144,144, #True , 15*#meter,100*#meter, 0.0005 , 1 , 24*#meter )
      ; camera setzen
                                    
   EndProcedure 
   
   Procedure anz_Map_MaterialtypeFromText ( text.s )
      
      text = LCase (text)
      
      Select text  
         
         Case "solid"
            
            ProcedureReturn #IRR_EMT_SOLID 
         
         Case "solid_2layer"
            
            ProcedureReturn #IRR_EMT_SOLID_2_LAYER
         
         Case "lightmap"
         
            ProcedureReturn #IRR_EMT_LIGHTMAP
            
         Case "lightmap_add"
            
            ProcedureReturn #IRR_EMT_LIGHTMAP_ADD 
         
         Case "lightmap_m2"
            
            ProcedureReturn #IRR_EMT_LIGHTMAP_M2 
         
         Case "lightmap_m4"
            
            ProcedureReturn #IRR_EMT_LIGHTMAP_M4
         
         Case "lightmap_light"
            
            ProcedureReturn #IRR_EMT_LIGHTMAP_LIGHTING
            
         Case "lightmap_light_m2"
            
            ProcedureReturn #IRR_EMT_LIGHTMAP_LIGHTING_M2
            
         Case "lightmap_light_m4"
            
            ProcedureReturn #IRR_EMT_LIGHTMAP_LIGHTING_M4
            
         Case "detail_map"
           
            ProcedureReturn #IRR_EMT_DETAIL_MAP
            
         Case "sphere_map"
            
            ProcedureReturn #IRR_EMT_SPHERE_MAP
         
         Case "reflection_2layer"
            
            ProcedureReturn #IRR_EMT_REFLECTION_2_LAYER
         
         Case "trans_add"
            
            ProcedureReturn #IRR_EMT_TRANSPARENT_ADD_COLOR
         
         Case "trans_alphach"
            
            ProcedureReturn #IRR_EMT_TRANSPARENT_ALPHA_CHANNEL
            
         Case "trans_alphach_ref"
            
            ProcedureReturn #IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF
         
         Case "trans_vertex_alpha"
            
            ProcedureReturn #IRR_EMT_TRANSPARENT_VERTEX_ALPHA
         
         Case "trans_reflection_2layer"
            
            ProcedureReturn #IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER
            
         Case "normalmap_solid"
           
            ProcedureReturn #IRR_EMT_NORMAL_MAP_SOLID
         
         Case "normalmap_trans_add"
            
            ProcedureReturn #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
         
         Case "normalmap_trans_vertexalpha"
            
            ProcedureReturn #IRR_EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA
         
         Case "parallaxmap_solid"
            
            ProcedureReturn #IRR_EMT_PARALLAX_MAP_SOLID
         
         Case "parallaxmap_trans_add"
            
            ProcedureReturn #IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
         
         Case "parallaxmap_trans_vertexalpha"
            
            ProcedureReturn #IRR_EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA
            
      EndSelect 
      
   EndProcedure 
   
   Procedure.s anz_peeks ( *p_text.i ) ; procedur, die vorher prüft, ob der pointer nicht 0 ist ;) 
      
      If *p_text 
         ProcedureReturn PeekS ( *p_text)
      EndIf 
      
   EndProcedure 
   
   Procedure anz_map_load( pfad.s , map_pfad.s = #pfad_maps)
      
      Protected anz_reader.i  , nodeName.s , nodeData.s , nodeart.s , Dim map_skybox_texture.s (6) , map_skybox_texture_counter
      Protected sound.anz_sound3d 
      Protected terrain_x.f , terrain_y.f , terrain_z.f , terrain_rotx.f , terrain_roty.f , terrain_rotz.f , terrain_scalex.f , terrain_scaley.f , terrain_scalez.f , terrain_pfad.s  , terrain_Texturescale1.f , terrain_Texturescale2.f , terrain_materialtype.i , terrain_texture1.s , terrain_texture2.s 
      Protected particle_x.f , particle_y.f , particle_z.f , particle_rotx.f , particle_roty.f , particle_rotz.f , particle_scalex.f , particle_scaley.f , particle_scalez.f , particle_width.f , particle_height.f , particle_art.w , particle_boxwidth.f , particle_boxheight.f , particle_boxdepth.f , particle_direction_x.f , particle_direction_y.f , particle_direction_z.f , particle_minpersecond.f , particle_maxpersecond.f , particle_minstartcolor.f , particle_maxstartcolor.f , particle_minlifetime.f , particle_maxlifetime.f , particle_maxangledegrees.f , particle_materialtype.i , particle_texture1.s , particle_texture2.s , particle_lighting.i 
      Protected anim_mesh_x.f , anim_mesh_y.f , anim_mesh_z.f , anim_mesh_rotx.f , anim_mesh_roty.f , anim_mesh_rotz.f , anim_mesh_scalex.f , anim_mesh_scaley.f , anim_mesh_scalez.f , anim_mesh_pfad.s  , anim_mesh_materialtype.i , anim_mesh_texture1.s , anim_mesh_texture2.s , anim_mesh_looping.i , *anim_mesh.anz_mesh ,anim_mesh_animationlist.s , anim_mesh_coltype.i , anim_mesh_coldetail.i 
      Protected light_x.f , light_y.f , light_z.f , light_rotx.f , light_roty.f , light_rotz.f , light_scalex.f , light_scaley.f , light_scalez.f , light_ambient_r.f , light_ambient_g.f , light_ambient_b.f  , light_ambient_a.f , light_range.f  , light_diffuse_r.f , light_diffuse_g.f , light_diffuse_b.f , light_diffuse_a.f , light_specular_r.f , light_specular_g.f , light_specular_b.f , light_specular_a.f , *anz_light.anz_light 
      Protected mesh_directload.i , mesh_no_textures.i , mesh_x.f , mesh_y.f , mesh_z.f , mesh_rotx.f , mesh_roty.f , mesh_rotz.f , mesh_scalex.f , mesh_scaley.f , mesh_scalez.f , mesh_pfad.s  , mesh_materialtype.i , mesh_texture1.s , mesh_texture2.s , *mesh.anz_mesh , mesh_coltype.i , mesh_coldetail.i
      Protected sound_path.s , sound_maxdistance.f , sound_mindistance.f , sound_playmode.w , sound_x.f , sound_y.f , sound_z.f 
      Protected billboard_height.f , billboard_materialtype.f , billboard_texture1.s , billboard_width.f , billboard_x.f , billboard_y.f , billboard_z.f
      Protected camera_aspect.f , camera_fieldofview.f , camera_rotx.f , camera_roty.f , camera_rotz.f , camera_x.f , camera_y.f , camera_z.f , camera_scalex.f , camera_scaley.f , camera_scalez.f , camera_upvector.f , camera_Zfar.f , camera_Znear.f 
      
      IrrSetTextureCreationFlag  ( #IRR_ETCF_CREATE_MIP_MAPS       , 1 )
      
      SetCurrentDirectory( map_pfad )
      map_pfad = ""
      anz_reader = IrrXmlCreateReader(pfad ) 

        If anz_reader 
        
           While IrrXmlRead ( anz_reader) 
              
              If IrrXmlGetNodeType( anz_reader ) = #IRR_EXN_ELEMENT
                 
                 nodeName       = anz_peeks ( IrrXmlGetNodeName   ( anz_reader ) )
                 attributecount = IrrXmlGetAttributeCount         ( anz_reader ) 
                 
                 For x = 0 To attributecount -1  ; da er ja die wirkliche anzahl zurückgibt: -1
                    
                    nodeData     = LCase ( anz_peeks ( IrrXmlGetAttributeValue ( anz_reader , x ))) ; alles kleingeschrieben.
                    
                    If nodeName    = "node" ; wenn ein neues Element startet
                       nodeart     =  nodeData ; alles kleingeschrieben, da Lcase
                    EndIf 
                    
                    Select nodeart 
                       
                       Case "cube"
                          
                          ;{ load cube
                             ; not yet supportet... wer braucht schon cubes..  o_O ;)
                          ;}
                          
                       Case "skybox"
                          
                          ;{ load skybox 
                          
                             Select nodeData 
                                
                                Case "texture1" ; von den Skyboxes brauchen wir nur die Texturen.
                                   
                                   For z = 1 To 6                     ; die 6 Texturen laden..
                                   
                                      If map_skybox_texture(z)          = ""   ; wenn da noch keine Textur ist..
                                      
                                         ; texturen laden
                                         x                              + 1    ; die Value auslesen.
                                         If anz_peeks                   ( IrrXmlGetAttributeValue( anz_reader, x)) > "" ; nicht, dass wir eine leere textur erwischen.
                                            map_skybox_texture_counter  + 1
                                            map_skybox_texture          ( map_skybox_texture_counter)  = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader, x)) ; map_pfad ist der ort, an dem die maps gespeichert sind.
                                            ReplaceString               (  map_skybox_texture          ( map_skybox_texture_counter) , "/" , "\" ,#pb_string_inplace )
                                         EndIf 
                                         ; skybox erstellen
                                         If map_skybox_texture_counter  = 6 ; alle Texturen sind jetz geladen
                                            sky = anz_Skybox                  ( map_skybox_texture(5) , map_skybox_texture(6) , map_skybox_texture(2) , map_skybox_texture(4) , map_skybox_texture(1) , map_skybox_texture(3))
                                            map_skybox_texture_counter  = 0
                                         EndIf 
                                         
                                         ; zurückkehren.
                                         Break  ; früher hätte man z  = 6 + 1 gesagt..
                                      EndIf 
                                   Next 
                             
                             EndSelect 

                          ;}
                          
                       Case "sphere"
                          
                          ;{ load sphere
                            ; rausgeworfen.. wer braucht schon kugeln.. ;)
                          ;}
                          
                       Case "terrain"
                          
                          ;{ load terrain
                             
                              Select nodeData 
                                    
                                 Case "position"
                                    
                                    
                                    x               + 1
                                    nodeData.s      = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    terrain_x       = ValF(StringField( nodeData , 1 , ", "))
                                    terrain_y       = ValF(StringField( nodeData , 2 , ", "))
                                    terrain_z       = ValF(StringField( nodeData , 3 , ", "))
                                 
                                 Case "rotation"
                                 
                                    x                  + 1
                                    nodeData.s         = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)) )
                                    terrain_rotx       = ValF(StringField( nodeData , 1 , ", "))
                                    terrain_roty       = ValF(StringField( nodeData , 2 , ", "))
                                    terrain_rotz       = ValF(StringField( nodeData , 3 , ", "))
                                    
                                 Case "scale"
                                 
                                    x                    + 1
                                    nodeData.s           = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)) )
                                    terrain_scalex       = ValF(StringField( nodeData , 1 , ", "))
                                    terrain_scaley       = ValF(StringField( nodeData , 2 , ", "))
                                    terrain_scalez       = ValF(StringField( nodeData , 3 , ", "))
                                    
                                 Case "heightmap"
                                    
                                    x                    + 1
                                    terrain_pfad         = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "texturescale1"
                                    
                                    x                     + 1
                                    terrain_Texturescale1 = Val (anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )))
                                    
                                 Case "texturescale2"
                                 
                                    x                     + 1
                                    terrain_Texturescale2 = Val (anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )))                                  
                                    
                                 Case "type" ; materialtype
                                 
                                    x                     + 1
                                    terrain_materialtype   = anz_Map_MaterialtypeFromText( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) )
                                    
                                 Case "texture1"
                                    
                                    x                      + 1
                                    terrain_texture1       = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "texture2"
                                    
                                    x                      + 1
                                    terrain_texture2       = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "lighting" ; belichtigung + erstellen v. terrain
                                    
                                    x                      + 1
                                    If anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) = "false"
                                       terrain_lighting    = 0
                                    Else 
                                       terrain_lighting    = 1
                                    EndIf 
                                    ; jetz sin alle Daten da --> erstellen v. Terrain
                                    
                                    ReplaceString  ( terrain_pfad     , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString  ( terrain_texture1 , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString  ( terrain_texture2 , "/" , "\" ,#pb_string_inplace )
                                    
                                    anz_addterrain ( terrain_pfad , terrain_x , terrain_y , terrain_z , terrain_texture1 , terrain_texture2 , terrain_Texturescale1 , terrain_Texturescale2 , 0 , 0 , 0 , terrain_materialtype , terrain_scalex , terrain_scaley , terrain_scalez , terrain_rotx , terrain_roty , terrain_rotz )
                                    
                              EndSelect 
                              
                          ;}
                          
                       Case "particlesystem"
                          
                          ;{ load particlesystem
                             
                             Select nodeData 
                                 
                                 Case "position"
                                    
                                    
                                    x                + 1
                                    nodeData.s       = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    particle_x       = ValF(StringField( nodeData , 1 , ", "))
                                    particle_y       = ValF(StringField( nodeData , 2 , ", "))
                                    particle_z       = ValF(StringField( nodeData , 3 , ", "))
                                 
                                 Case "rotation"
                                 
                                    x                   + 1
                                    nodeData.s          = LCase (anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    particle_rotx       = ValF(StringField( nodeData , 1 , ", "))
                                    particle_roty       = ValF(StringField( nodeData , 2 , ", "))
                                    particle_rotz       = ValF(StringField( nodeData , 3 , ", "))
                                    
                                 Case "scale"
                                 
                                    x                    + 1
                                    nodeData.s           = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    particle_scalex      = ValF(StringField( nodeData , 1 , ", "))
                                    particle_scaley      = ValF(StringField( nodeData , 2 , ", "))
                                    particle_scalez      = ValF(StringField( nodeData , 3 , ", "))
                                 
                                 Case "particlewidth"
                                 
                                    x                    + 1
                                    nodeData.s           = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    particle_width       = ValF(StringField( nodeData , 1 , ", "))
                                    
                                 Case "particleheight"
                                    
                                    x                    + 1
                                    nodeData.s           = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    particle_height      = ValF(StringField( nodeData , 1 , ", "))
                                    
                                 Case "emitter" ; z.b. anz_art_particle_box (oder so ähnlich)
                                    
                                    x                    + 1
                                    nodeData.s           = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                    If nodeData          = "ring"
                                       particle_art      = #anz_particle_art_ring
                                    ElseIf nodeData      = "sphere"
                                       particle_art      = #anz_particle_art_sphere
                                    Else 
                                       particle_art      = #anz_particle_art_default
                                    EndIf 
                                    
                                 Case "box" ; width height depth
                                    
                                    x                    + 1
                                    nodeData.s           = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    particle_boxwidth    = ValF(StringField( nodeData , 1 , ", "))
                                    particle_boxheight   = ValF(StringField( nodeData , 2 , ", "))
                                    particle_boxdepth    = ValF(StringField( nodeData , 3 , ", "))
                                    
                                 Case "direction" 
                                    
                                    x                    + 1
                                    nodeData.s           = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    particle_direction_x = ValF(StringField( nodeData , 1 , ", "))
                                    particle_direction_y = ValF(StringField( nodeData , 2 , ", "))
                                    particle_direction_z = ValF(StringField( nodeData , 3 , ", "))
                                    
                                 Case "minparticlespersecond"
                                    
                                    x                    + 1
                                    particle_minpersecond= ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "maxparticlespersecond"
                                    
                                    x                    + 1
                                    particle_maxpersecond= ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "minstartcolor"
                                    
                                    x                    + 1
                                    particle_minstartcolor= ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "maxstartcolor"
                                 
                                    x                    + 1
                                    particle_maxstartcolor = ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "minlifetime"
                                    
                                    x                    + 1
                                    particle_minlifetime = ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "maxlifetime"
                                    
                                    x                    + 1
                                    particle_maxlifetime = ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "maxangledegrees"
                                    
                                    x                    + 1
                                    particle_maxangledegrees = ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "type" ; materialtype
                                 
                                    x                     + 1
                                    particle_materialtype = anz_Map_MaterialtypeFromText( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) )
                                    
                                 Case "texture1"
                                    
                                    x                      + 1
                                    particle_texture1      = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "texture2"
                                    
                                    x                      + 1
                                    particle_texture2      = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "lighting" ; belichtigung + erstellen v. particle
                                    
                                    x                      + 1
                                    If LCase ( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))) = "false"
                                       particle_lighting    = 0
                                    Else 
                                       particle_lighting    = 1
                                    EndIf 
                                    
                                    ; jetz sin alle Daten da --> erstellen v. particle
                                    ReplaceString           ( particle_texture1 , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString           ( particle_texture2 , "/" , "\" ,#pb_string_inplace )
                                    
                                    particle_nodeID         = anz_addparticle ( particle_x        , particle_y      , particle_z      , particle_texture1 , particle_texture2 , particle_materialtype , particle_art , particle_direction_x , particle_direction_y , particle_direction_z , particle_boxwidth , particle_boxheight , particle_boxdepth , particle_minpersecond , particle_maxpersecond , particle_width , particle_height , particle_minstartcolor , particle_maxstartcolor , particle_maxangledegrees , particle_minlifetime , particle_maxlifetime )
                                    IrrSetNodeScale         ( particle_nodeID , particle_scalex   , particle_scaley , particle_scalez )
                                    IrrSetNodeRotation      ( particle_nodeID , particle_rotx     , particle_roty   , particle_rotz   )
                                    IrrSetNodeMaterialFlag  ( particle_nodeID , #IRR_EMF_LIGHTING , particle_lighting )

                                    
                              EndSelect 
                          ;}
                          
                       Case "animatedmesh"
                          
                          ;{ load animated mesh
                             
                             Select nodeData 
                                 
                                 Case "name"
                                    
                                    ; befehle werden beim Feld "name" eingegeben. groß und KLeinshreibung ist hierbei wurst.. (egal.. nichtig. unwichtig.)
                                    ; folgende Befehle sind verfügbar:
                                    ; --------------
                                    ; --- Für Mesh:
                                    ; 
                                    x                 + 1
                                    nodeData.s        = LCase( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)) )
                                    
                                    
                                    ; coltype
                                    If FindString          ( nodeData , "coltype_movable" , 1 )
                                       anim_mesh_coltype   = #anz_ColType_Nocollision
                                    ElseIf FindString      ( nodeData , "coltype_nocollision" , 1)
                                       anim_mesh_coltype   = #anz_ColType_movable
                                    Else
                                       anim_mesh_coltype   = #anz_ColType_solid 
                                    EndIf 
                                    
                                    ; coldetail
                                    If FindString          ( nodeData , "coldetail_mesh" , 1 )
                                       anim_mesh_coldetail = #anz_col_mesh
                                    ElseIf FindString      ( nodeData , "coldetail_terrain" , 1 )
                                       anim_mesh_coldetail = #anz_col_terrain
                                    Else 
                                       anim_mesh_coldetail = #anz_col_box
                                    EndIf 
                                    
                                    animlistpos            = FindString          ( nodeData , "animlist" , 1  )          ; 
                                    firstelement           = FindString          ( nodeData , Chr(34) , animlistpos )     ; das erste anführungszeichen
                                    endelement             = FindString          ( nodeData , Chr(34) , firstelement +1 ) ; das zweite anführungszeichen, welches das Ende markiert.
                                    
                                       If animlistpos 
                                          anim_mesh_animationlist = Trim( Mid (nodeData , firstelement  , endelement - firstelement  ) )
                                       EndIf 
                                    
                                 Case "name"  ; der Name ist immer die Animationlist.
                                 
                                    x                   + 1 
                                    anim_mesh_animationlist = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    
                                 Case "position"
                                    
                                    x                   + 1
                                    nodeData.s          = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    anim_mesh_x         = ValF(StringField( nodeData , 1 , ", "))
                                    anim_mesh_y         = ValF(StringField( nodeData , 2 , ", "))
                                    anim_mesh_z         = ValF(StringField( nodeData , 3 , ", "))
                                 
                                 Case "rotation"
                                 
                                    x                   + 1
                                    nodeData.s          = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    anim_mesh_rotx      = ValF(StringField( nodeData , 1 , ", "))
                                    anim_mesh_roty      = ValF(StringField( nodeData , 2 , ", "))
                                    anim_mesh_rotz      = ValF(StringField( nodeData , 3 , ", "))
                                    
                                 Case "scale"
                                 
                                    x                    + 1
                                    nodeData.s           = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    anim_mesh_scalex     = ValF(StringField( nodeData , 1 , ", "))
                                    anim_mesh_scaley     = ValF(StringField( nodeData , 2 , ", "))
                                    anim_mesh_scalez     = ValF(StringField( nodeData , 3 , ", "))
                                 
                                 Case "mesh"
                                    
                                    x                    + 1
                                    anim_mesh_pfad       = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                 
                                 Case "looping"  ; obs ne sich wiederholende Animation ist.
                                    
                                    x                    + 1 
                                    anim_mesh_looping    = Val( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "type" ; materialtype
                                 
                                    x                     + 1
                                    anim_mesh_materialtype   = anz_Map_MaterialtypeFromText( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) )
                                    
                                 Case "texture1"
                                    
                                    x                      + 1
                                    anim_mesh_texture1       = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "texture2"
                                    
                                    x                      + 1
                                    anim_mesh_texture2       = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "lighting" ; belichtigung + erstellen v. anim_mesh
                                    
                                    x                         + 1
                                    If anz_peeks             ( IrrXmlGetAttributeValue( anz_reader , x )) = "false"
                                       anim_mesh_lighting    = 0
                                    Else 
                                       anim_mesh_lighting    = 1
                                    EndIf 
                                    ; jetz sin alle Daten da --> erstellen v. anim_mesh
                                    
                                    ReplaceString              ( anim_mesh_pfad         , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString              ( anim_mesh_texture1     , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString              ( anim_mesh_texture2     , "/" , "\" ,#pb_string_inplace )
                                    *anim_mesh   = anz_addmesh (  anim_mesh_pfad , anim_mesh_x , anim_mesh_y , anim_mesh_z , anim_mesh_texture1 , anim_mesh_materialtype , anim_mesh_texture2 , 0 , anim_mesh_coldetail , anim_mesh_coltype , anim_mesh_rotx , anim_mesh_roty , anim_mesh_rotz , anim_mesh_scalex , anim_mesh_scaley , anim_mesh_scalez )
                                    ani_SetAnimSettings        ( *anim_mesh , 1 , anim_mesh_looping , 0.4 , 1 , anim_mesh_animationlist )
                                 EndSelect 
                          ;}
                          
                       Case "empty" ; spezial scenenode.. z.b. Teleporter etc ;)
                          
                          ;{ load spezial mesh
                          
                          ;}
                          
                       Case "light"
                          
                          ;{ load light..
                          
                             Select nodeData 

                                 Case "position"
                                    
                                    x               + 1
                                    nodeData.s      = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    light_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                    light_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                    light_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "rotation"
                                 
                                    x               + 1
                                    nodeData.s      = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    light_rotx      = ValF  ( StringField( nodeData , 1 , ", "))
                                    light_roty      = ValF  ( StringField( nodeData , 2 , ", "))
                                    light_rotz      = ValF  ( StringField( nodeData , 3 , ", "))
                                    
                                 Case "scale"
                                 
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    light_scalex     = ValF  ( StringField( nodeData , 1 , ", "))
                                    light_scaley     = ValF  ( StringField( nodeData , 2 , ", "))
                                    light_scalez     = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "ambientcolor"
                                    
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    light_ambient_r  = ValF  ( StringField( nodeData , 1 , ", "))
                                    light_ambient_g  = ValF  ( StringField( nodeData , 2 , ", "))
                                    light_ambient_b  = ValF  ( StringField( nodeData , 3 , ", "))
                                    light_ambient_a  = ValF  ( StringField( nodeData , 4 , ", "))
                                    
                                 Case "diffusecolor"
                                    
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    light_diffuse_r  = ValF  ( StringField( nodeData , 1 , ", "))
                                    light_diffuse_g  = ValF  ( StringField( nodeData , 2 , ", "))
                                    light_diffuse_b  = ValF  ( StringField( nodeData , 3 , ", "))
                                    light_diffuse_a  = ValF  ( StringField( nodeData , 4 , ", "))
                                    
                                 Case "specularcolor"
                                    
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    light_specular_r = ValF  ( StringField( nodeData , 1 , ", "))
                                    light_specular_g = ValF  ( StringField( nodeData , 2 , ", "))
                                    light_specular_b = ValF  ( StringField( nodeData , 3 , ", "))
                                    light_specular_a = ValF  ( StringField( nodeData , 4 , ", "))
                                    
                                 Case "radius"
                                    
                                    Debug "neues Light!" 
                                    x                + 1
                                    light_range      = ValF(  anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))) 
                                    *anz_light       = anz_addlight ( 0 , light_x , light_y , light_z , light_range )
                                    IrrSetLightAmbientColor  ( *anz_light\nodeID , light_ambient_a , light_ambient_r , light_ambient_g , light_ambient_b )
                                    IrrSetLightDiffuseColor  ( *anz_light\nodeID , light_diffuse_a , light_diffuse_r , light_diffuse_g , light_diffuse_b )
                                    IrrSetLightSpecularColor ( *anz_light\nodeID , light_specular_a, light_specular_r, light_specular_g, light_specular_b)
                                    
                              EndSelect 
                              
                          ;}
                          
                       Case "mesh" , "octtree"
                         
                          ;{ load mesh

                          Select nodeData 
                                 
                                 Case "name"
                                    
                                    x                 + 1
                                    nodeData.s        = LCase( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)) )
                                    
                                    ; coltype
                                    If FindString     ( nodeData , "coltype_movable" , 1 )
                                       mesh_coltype   = #anz_ColType_Nocollision
                                    ElseIf FindString ( nodeData , "coltype_nocollision" , 1)
                                       mesh_coltype   = #anz_ColType_movable
                                    Else
                                       mesh_coltype   = #anz_ColType_solid 
                                    EndIf 
                                    
                                    ; coldetail
                                    If FindString   ( nodeData , "coldetail_mesh" , 1 )
                                       mesh_coldetail = #anz_col_mesh
                                    ElseIf FindString   ( nodeData , "coldetail_terrain" , 1 )
                                       mesh_coldetail = #anz_col_terrain
                                    Else 
                                       mesh_coldetail = #anz_col_box
                                    EndIf 
                                    
                                    ; Textures
                                    If FindString  ( nodeData , "no_textures" , 1)
                                       mesh_no_textures = 1
                                    EndIf 
                                    
                                    ; directload
                                    If FindString ( nodeData, "directload" , 1)
                                       mesh_directload = 1
                                    EndIf 
                                     
                                 Case "position"
                                    
                                    x              + 1
                                    nodeData.s     = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    mesh_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                    mesh_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                    mesh_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "rotation"
                                 
                                    x               + 1
                                    nodeData.s      = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    mesh_rotx      = ValF  ( StringField( nodeData , 1 , ", "))
                                    mesh_roty      = ValF  ( StringField( nodeData , 2 , ", "))
                                    mesh_rotz      = ValF  ( StringField( nodeData , 3 , ", "))
                                    
                                 Case "scale"
                                 
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    mesh_scalex     = ValF  ( StringField( nodeData , 1 , ", "))
                                    mesh_scaley     = ValF  ( StringField( nodeData , 2 , ", "))
                                    mesh_scalez     = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "mesh"
                                    
                                    x                + 1
                                    mesh_pfad        = map_pfad + anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    
                                 Case "type" ; materialtype
                                 
                                    x                 + 1
                                    If Not mesh_no_textures 
                                       mesh_materialtype = anz_Map_MaterialtypeFromText( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) )
                                    Else 
                                       mesh_materialtype = -1
                                    EndIf 
                                    
                                 Case "texture1"
                                    
                                       x                 + 1
                                    If Not mesh_no_textures ; dann willer textures selber laden.
                                       mesh_texture1     = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    Else 
                                       mesh_texture1     = ""
                                    EndIf 
                                    
                                 Case "texture2"
                                    
                                       x                 + 1
                                    If Not mesh_no_textures
                                       mesh_texture2     = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    Else 
                                       mesh_texture2     = ""
                                    EndIf 
                                 
                                 Case "param1"
                                    
                                    ; für später... param wird im moment einfach auf nen standardwert gesetzt: 263168
                                    
                                 Case "lighting" ; belichtigung + erstellen v. mesh
                                    
                                    x                  + 1
                                    If anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) = "false"
                                       mesh_lighting   = 0
                                    Else 
                                       mesh_lighting   = 1
                                    EndIf 
                                    ; jetz sin alle Daten da --> erstellen v. mesh
                                    
                                    ReplaceString              ( mesh_pfad         , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString              ( mesh_texture1     , "/" , "\" ,#pb_string_inplace )
                                    ReplaceString              ( mesh_texture2     , "/" , "\" ,#pb_string_inplace )
                                    If mesh_pfad  ; bei mehreren texturen überspringt er nämlich sonst das setzen von meshpfad, und es werden pro Textur ein extramesh erstellt !!! o_O!
                                       *mesh   = anz_addmesh      (  mesh_pfad , mesh_x , mesh_y , mesh_z , mesh_texture1 , mesh_materialtype , mesh_texture2 , mesh_directload , mesh_coldetail , mesh_coltype  , mesh_rotx , mesh_roty , mesh_rotz , mesh_scalex , mesh_scaley , mesh_scalez , mesh_lighting )
                                    EndIf 
                                    mesh_pfad = ""
                              EndSelect 
                          
                          ;}
                          
                       Case "irrklangscenenode"
                          
                          ;{ load 3D sound
                          
                          Select nodeData 

                                 Case "position"
                                    
                                    x              + 1
                                    nodeData.s     = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    sound_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                    sound_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                    sound_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "soundfilename"
                                 
                                    x              + 1
                                    sound_path     = map_pfad + anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    
                                 Case "playmode"
                                    
                                    x               + 1
                                    nodeData.s      = LCase ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                    Select nodeData 
                                       
                                       Case "nothing"
                                          
                                          sound_playmode = -1
                                          
                                       Case "play_once"
                                          
                                          sound_playmode = 0
                                          
                                       Case "looping"
                                          
                                          sound_playmode = 1
                                        
                                        Default 
                                           
                                          sound_playmode = 0
                                          
                                    EndSelect 
                                 
                                 Case "mindistance"
                                    
                                    x                 + 1
                                    sound_mindistance = ValF(anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "maxdistance" 
                                    
                                    x                 + 1
                                    sound_maxdistance = ValF( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    anz_addsound3d    ( sound_path , sound_x , sound_y , sound_z , sound_maxdistance , sound_mindistance , sound_playmode)
                                    
                                 Case "mintimemsinterval"  ; wie lange es mindestens dauert, bis sound wiederholt wird. (bei loop)
                                    
                                    ; INAKTIV; evtl ab 1. Beta oder ähnlich....
                                    ; x                 + 1
                                    ; sound_MinTimeMsInterval     = anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "maxtimemsinterval" ; wie lange es max. dauert, bis sound wiederholt wird.
                                    
                                    ; INAKTIV; siehe oben.
                                    ; x                 + 1
                                    ; sound_MaxTimeMsInterval     = anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))

                              EndSelect 
                              
                          ;}
                          
                       Case "billboard"
                          
                          ;{ load billboard
                          
                          Select nodeData 

                                 Case "position"
                                    
                                    x                   + 1
                                    nodeData.s          = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    billboard_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                    billboard_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                    billboard_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "width" 
                                    
                                    x                     + 1
                                    billboard_width       = ValF ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                 
                                 Case "height" 
                                    
                                    x                     + 1
                                    billboard_height      = ValF ( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "type" ; materialtype
                                 
                                    x                      + 1
                                    billboard_materialtype = anz_Map_MaterialtypeFromText( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) )
                                    
                                 Case "texture1"
                                    ; billboards haben keine shadereffekte mit Multitexturen..
                                    x                      + 1
                                    billboard_texture1     = map_pfad + anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x ))
                                    
                                 Case "lighting" ; belichtigung + erstellen v. billboard
                                    
                                    ; x                       + 1
                                    ; If anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )) = "false"
                                       ; billboard_lighting   = 0
                                    ; Else 
                                       ; billboard_lighting   = 1
                                    ; EndIf 
                                    ; Lighting wird an und für sich ignoriert...
                                    
                                   anz_AddBillboard(  billboard_texture1 , billboard_x , billboard_y , billboard_z , billboard_width , billboard_height , billboard_materialtype )
                                    
                              EndSelect 
                          
                          ;}
                          
                       Case "camera"
                          
                          ;{ load camera
                          
                          Select nodeData 

                                 Case "position"
                                    
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    camera_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                    camera_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                    camera_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "rotation"
                                 
                                    x                + 1
                                    nodeData.s       = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    camera_rotx      = ValF  ( StringField( nodeData , 1 , ", "))
                                    camera_roty      = ValF  ( StringField( nodeData , 2 , ", "))
                                    camera_rotz      = ValF  ( StringField( nodeData , 3 , ", "))
                                    
                                 Case "scale"
                                 
                                    x                 + 1
                                    nodeData.s        = anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x))
                                    camera_scalex     = ValF  ( StringField( nodeData , 1 , ", "))
                                    camera_scaley     = ValF  ( StringField( nodeData , 2 , ", "))
                                    camera_scalez     = ValF  ( StringField( nodeData , 3 , ", "))
                                 
                                 Case "upvector"
                                    
                                    x                  + 1
                                    camera_upvector    = ValF( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "fovy" ; FieldOfView
                                 
                                    x                   + 1
                                    camera_fieldofview  = ValF( anz_peeks ( IrrXmlGetAttributeValue(anz_reader, x)))
                                    
                                 Case "aspect"
                                    
                                    x                   + 1
                                    camera_aspect       = ValF( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )))
                                    
                                 Case "znear"
                                    
                                    x                 + 1
                                    camera_Znear      = ValF( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )))
                                    
                                 Case "zfar" ; 
                                    
                                    x                  + 1
                                    camera_Zfar        = ValF( anz_peeks ( IrrXmlGetAttributeValue( anz_reader , x )))
                                    ; jetz sin alle Daten da --> erstellen v. camera
                                    spi_addspieler     ( camera_x , camera_y , camera_z , #spi_standard_leben , #spi_standard_maxleben , #spi_standard_mana , #spi_standard_maxmana , #spi_standard_name , #spi_standard_team , 1 ) 

                                    
                              EndSelect 

                          ;}
                          
                    EndSelect 
                       
                       
                 Next 
                 
              
              ElseIf IrrXmlGetNodeType ( anz_reader) = #IRR_EXN_ELEMENT_END
              
              
              EndIf 
           Wend 
        
        EndIf 
        
        If anz_reader 
           IrrXmlFreeReader( anz_reader )
        EndIf
        
   EndProcedure 
   
   Procedure anz_map_save (pfad.s)
      
   EndProcedure 
   
   ; update stuff
   
   Procedure anz_updateparticles() ; schaut, ob Clouds, Staub, Feuer etc stimmt, oder gelöscht werden bzw. verschoben werden muss.
      
      ;{ staub überprüfen, evtl löschen, wenn seine lebenszeit < elapsedmilliseconds()
      
      ResetList( anz_staub())
         
         While NextElement(anz_staub())
         
            If anz_staub()\lebenszeit < ElapsedMilliseconds()
               anz_freenode ( anz_getobject3dByNodeID ( anz_staub()\nodeID))
               DeleteElement ( anz_staub())
            EndIf 
         
         Wend 
      
      ;}
      
   EndProcedure 
   
   Procedure anz_updateview()   ; anzeigen der Welt, Gui usw. rendern. (irrlicht-based.)
             ; setzt voraus, dass irrrunning() erfolgreich aufgerufen wird!!
             DMX_Freelook               (1 , anz_mousedeltax , anz_mousedeltay )  ; camera drehen
             spi_ExamineCamera          ()                         ; camera bewegen
             IrrBeginScene              (240, 255, 255)            ; startdrawing
             IrrDrawScene               ()                         ; Drawscene
             anz_displayImages          ()                         ; 2d images (gui elemente)
             IrrDrawGUI                 ()                         ; Irrlicht-gui
             IrrEndScene                ()                         ; stopdrawing
  
   EndProcedure 
   
   Procedure anz_updatesound()
      Static x.f , y.f , z.f  ,vectorStart.IRR_VECTOR ,  vectorEnd.IRR_VECTOR , upx.f,upy.f,upz.f 
    
    If anz_camera 
       IrrGetNodeAbsolutePosition      ( anz_camera , @x,@y,@z)
       IrrGetCameraUpVector            ( anz_camera , @upx , @upy , @upz )
       IrrGetRayFromScreenCoordinates  ( 500, 400, anz_camera, @vectorStart, @vectorEnd)
       IrrKlangListenerPosition        ( x, y, z, vectorEnd\x, vectorEnd\y, vectorEnd\z, 0, 0, 0, upx, upy, upz)
    EndIf 
    
   EndProcedure 
   
   Procedure anz_updateinput() ; mouse and keyboard management
      Static *MouseEvent.IRR_MOUSE_EVENT 
      Protected spi_current_AnimNR.i , *waffe_item.ITEM , *waffe.item_waffe , *itemID.ITEM
      
   ; ----------------------------------------------------------------------------------------
   ; keyboard
   ; ----------------------------------------------------------------------------------------
      
      If GetAsyncKeyState_(#VK_ESCAPE)
         ; Wenn Ingame:
         ; -> InGameMenu öffnen
         ; wenn schon offen
         ; -> Schließen
         ; wenn im großen Menu:
         ; Endedialog öffnen.
         ; wenn schon offen:
         ; endedialog wieder schließen.
         anz_ende() 
      EndIf 
      
    ; Spielfigur bewegen
    
    ; wenn nichts gedrückt wird seht das Wesen einfach. ;) (sofern es die current animation unterbrechen kann.)
    spi_current_AnimNR = ani_getCurrentAnimationNR( wes_getAnzMeshID( spi_GetSpielerWesenID( spi_getcurrentplayer()) ) )
    
    If Not ( spi_current_AnimNR = #ani_animNR_jump_start Or spi_current_AnimNR = #ani_animNR_jump_flugrolle_start)
    
        wes_Stand( spi_GetSpielerWesenID( spi_getcurrentplayer()))
    
    EndIf 
    
    
    If wes_GetLeben ( spi_GetSpielerWesenID( spi_getcurrentplayer())) > 0
    
         ;{ spielfigur bewegen 
         
         If GetAsyncKeyState_( #VK_LEFT) Or GetAsyncKeyState_(#VK_A) ; nach links
            spi_move_spielerleft ( spi_getcurrentplayer() , #anz_Walkspeed )
         EndIf 
         If GetAsyncKeyState_(#VK_RIGHT) Or GetAsyncKeyState_(#VK_D) ; nach rechts
            spi_move_spielerright ( spi_getcurrentplayer() , #anz_Walkspeed )
         EndIf 
         If GetAsyncKeyState_( #VK_UP) Or GetAsyncKeyState_(#VK_W) ; nach forne gehen
            spi_move_spielerforward( spi_getcurrentplayer() , #anz_Walkspeed )
         EndIf 
         If GetAsyncKeyState_( #VK_DOWN) Or GetAsyncKeyState_(#VK_S) ; nach hinten gehen
            spi_move_spielerforward( spi_getcurrentplayer() , - #anz_Walkspeed *0.8 )
         EndIf 
         
         ;}
         
         ;{ springen 
         
         If GetAsyncKeyState_(#VK_SPACE) ; springen
            
            If anz_key_tipped_space = 0 ; nur wenn wir einmal drauftippen starteterspringen.
               anz_key_tipped_space = 1
               
               If spi_is_Jump( spi_getcurrentplayer() , #spi_jump_not  ) ; wenner nicht springt
                  
                  spi_jump( spi_getcurrentplayer() , #spi_jump_normal)
               ElseIf spi_is_Jump( spi_getcurrentplayer() , #spi_jump_normal)
            
                  spi_jump( spi_getcurrentplayer() , #spi_jump_flugrolle)
               EndIf 
               
            EndIf 
            
            
            
         Else 
            anz_key_tipped_space = 0
         EndIf 
         
         ;}
         
         ;{ waffe ziehen/wegstecken
         
         If GetAsyncKeyState_(#VK_CONTROL) ; zum Waffe ziehen/wegstecken, falls möglich.
            If anz_key_tipped_control = 0
               anz_key_tipped_control = 1
               
            EndIf 
         Else 
            anz_key_tipped_control = 0
         EndIf 
         
         ;}
         
      EndIf 
    ; sonstige ingame controlls
     
      ;{ pause 
      
      If GetAsyncKeyState_(#VK_P) ; pause
         If anz_key_tipped_p = 0
            anz_key_tipped_p = 1
            
         EndIf 
      Else 
         anz_key_tipped_p = 0
      EndIf 
      ;}
      
      ;{ questlog öffnen 
      If GetAsyncKeyState_(#VK_Q) ; questlog öffnen/schließen
         If anz_key_tipped_q = 0
            anz_key_tipped_q = 1
         
         EndIf 
      Else 
         anz_key_tipped_q = 0
      EndIf 
      
      ;}
      
      ;{ items benutzen
      
      If GetAsyncKeyState_(#VK_SHIFT) ; Zum Benutzen bzw. öffnen, Item aufnehmen usw.
         If anz_key_tipped_shift = 0
            anz_key_tipped_shift = 1
            
            *itemID = Item_getFocusItem()
            If *itemID 
               ; Select *itemID\art  ; später muss unbedingt noch zwischen TÜR etc. unterschieden werden! also item\uberart z.b. mit #item_uberart_inventar z.b. für bewegliche items.
               ; 
                  ; Default 
                     
                     spi_Inventar_AddItem ( spi_getcurrentplayer() , *itemID )
                     
               ; EndSelect 
               
            EndIf 
         
         EndIf 
      Else 
         anz_key_tipped_shift = 0
      EndIf 
      
      ;}
      
      ;{ map öffnen
      
      If GetAsyncKeyState_(#VK_M) ; map öffnen
      If anz_key_tipped_m = 0
            anz_key_tipped_m = 1
         
         EndIf 
      Else 
         anz_key_tipped_m = 0
      EndIf 
      
      ;}
      
      ;{ chatlog öffnen
      
      If GetAsyncKeyState_(#VK_RETURN) ; Chatlog öffnen --> Multiplayer.
      If anz_key_tipped_return = 0
            anz_key_tipped_return = 1
         
         EndIf 
      Else 
         anz_key_tipped_return = 0
      EndIf 
      
      ;}
      
      
   ; ---------------------------------------------------------------------------------------------
   ; ---- MOUSE ----------------------------------------------------------------------------------
   ; ---------------------------------------------------------------------------------------------
      
      ;{ Mouse:
    
   ; linke Taste
   If GetAsyncKeyState_(1) 
      If anz_mb1 = 0      ; tipped
         anz_mb1 = 1
      ElseIf anz_mb1 = 1  ; pressed
         anz_mb1 = 2
      EndIf 
   Else 
      If Not anz_mb1 = 3 And Not anz_mb1 = 0
         anz_mb1 = 3      ; mousereleased
      Else 
         anz_mb1 = 0      ; no event
      EndIf 
   EndIf 
   
   ; rechte Taste
   
   If GetAsyncKeyState_(2)
      If anz_mb2 = 0
         anz_mb2 = 1
      Else 
         anz_mb2 = 2
      EndIf 
   Else 
      If Not anz_mb2 = 3 And Not anz_mb2 = 0
         anz_mb2 = 3
      Else 
         anz_mb2 = 0
      EndIf 
   EndIf 
   
   ; Mitteltaste
   
   If GetAsyncKeyState_(#VK_MBUTTON) Or ( GetAsyncKeyState_(#VK_CONTROL) And anz_mb1 > 0)
      If anz_mb3 = 0 
         anz_mb3 = 1
      Else 
         anz_mb3 = 2
      EndIf 
   Else 
      If Not anz_mb3 = 3 And Not anz_mb3 = 0
         anz_mb3 = 3
      Else 
         anz_mb3 = 0
      EndIf 
   EndIf 
   
   
   ; Mousedeltaxy: + MouseWheel
      
    anz_mousedeltax = 500 - DesktopMouseX()
    anz_mousedeltay = 500 - DesktopMouseY()
    SetCursorPos_   ( 500 , 500)
    
    ; mousewheel
      
       While IrrMouseEventAvailable()

          ; read the mouse event out.
          *MouseEvent.IRR_MOUSE_EVENT = IrrReadMouseEvent()

          ; find out the mouse-action
          Select *MouseEvent\action
                
             Case #IRR_EMIE_MOUSE_WHEEL
                anz_mouseWheel.f       = *MouseEvent\wheel
                spi_SetCameraDistance  ( spi_GetCameraDistance() + anz_mouseWheel * (anz_mouseWheel - 10) /2) ; mit geschätzten 10 als mindestabstand.
          EndSelect

      Wend
      
      ;MOUSEBUTTONs pressed etc.
      
      If anz_mb1 = 1 ; angriff
         ; PAUSE vor spieler prüfen, welches wesen in Target ist -> dann angreifen ;)
         ; je nach Pfeiltaste + maustaste -> andere angriffsrichtung. 
         ; schläge können abgewehrt werden, wenn gegner entgegengesette angriffsrichtung. (links gegen rechts, oben blockt unten etc.)
         ; *WesenID    = spi_GetSpielerWesenID( spi_getcurrentplayer()) 
      EndIf 
      
      If anz_mb2 > 0 ; gedrückt rechte taste -> schild 
         ; wenn schild hoch: pfeile/schläge/magie . werden geblockt, aber nur in blickrichtung kommendes. schild nimmt schaden!
      EndIf
      
   ;}

   EndProcedure 
   
   Procedure anz_setMeshMaterial ( *anz_Mesh_ID.anz_mesh  , MaterialType.i , isparallax.w=1 , isnormal.w=1 ) ; Versucht, Mesh material zu parallax zu schalten, wenn nicht möglich -> andere technik.
      Protected irr_obj.i , irr_shader.i , currentlistenobject.i
     
                 If *anz_Mesh_ID\geladen     = 1  
                    
                    For n = 1 To IrrGetNodeMaterialCount( *anz_Mesh_ID\nodeID )
                       *material             = IrrGetNodeMaterial( anz_getObject3DIrrNode( anz_getobject3dByAnzID( *anz_Mesh_ID)),n)
                       IrrSetMaterialParam   ( *material , 263168)
                    Next 
                    
                    If Not *anz_Mesh_ID\irr_emt_materialtype = -1
                 
                    irr_obj                  = *anz_Mesh_ID\nodeID                   ; vereinfachen der ID auf ne variable
                    
                    ;{ material setzen
                    
                    Select MaterialType 
                    
                       Case #IRR_EMT_PARALLAX_MAP_SOLID
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled          ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_PARALLAX_MAP_SOLID                                       ; welches material das mesh aktuell gerade hat.
                                  If *anz_Mesh_ID\texture            > ""
                                     IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  If *anz_Mesh_ID\texture_normalmap  > ""
                                     IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                                  EndIf 
                                  IrrSetNodeMaterialType             ( irr_obj , #IRR_EMT_PARALLAX_MAP_SOLID )                               ; im Moment sin also keine transparenten meshes unterstützt.
                 
                           ElseIf anz_IsNormalmappingEnabled()       And isnormal ; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_NORMAL_MAP_SOLID      ; welches material das mesh aktuell gerade hat.
                                  If *anz_Mesh_ID\texture            > ""
                                     IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  If *anz_Mesh_ID\texture_normalmap  > ""
                                     IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                                  EndIf  
                                  IrrSetNodeMaterialType             ( irr_obj , #IRR_EMT_NORMAL_MAP_SOLID )                                 ; im Moment sin also keine transparenten meshes unterstützt.

                                  
                            Else  ; ansonsten solid anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_SOLID      ; welches material das mesh aktuell gerade hat.
                                  If *anz_Mesh_ID\texture            > ""
                                     IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid map laden. 
                                  EndIf 
                                  IrrSetNodeMaterialType             ( irr_obj , #IRR_EMT_SOLID )                                            ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}

                       Case #IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled        ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                 
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  If *anz_Mesh_ID\texture_normalmap
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR )       
                 
                           ElseIf anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  If *anz_Mesh_ID\texture_normalmap
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR )             ; im Moment sin also keine transparenten meshes unterstützt.

                                  
                            Else  ; ansonsten IRR_EMT_TRANSPARENT_ADD_COLOR anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_TRANSPARENT_ADD_COLOR )                        ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}
                       
                       Case #IRR_EMT_NORMAL_MAP_SOLID 
                           
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_NORMAL_MAP_SOLID
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  If *anz_Mesh_ID\texture_normalmap
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_NORMAL_MAP_SOLID )                                 ; im Moment sin also keine transparenten meshes unterstützt.

                                  
                            Else  ; ansonsten solid anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_SOLID 
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_SOLID )                                            ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}
                           
                       Case #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                          
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  If *anz_Mesh_ID\texture_normalmap
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR )             ; im Moment sin also keine transparenten meshes unterstützt.

                                  
                            Else  ; ansonsten solid anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #IRR_EMT_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     IrrSetNodeMaterialTexture        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                                  EndIf 
                                  IrrSetNodeMaterialType           ( irr_obj , #IRR_EMT_TRANSPARENT_ADD_COLOR )                        ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}
                           
                       Default  ; alle anderen Techniken sollten unterstützt werden. 
                            
                           ;{
                           
                            *anz_Mesh_ID\currentmaterialtype   = MaterialType 
                            If *anz_Mesh_ID\texture            > ""
                               IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ) , 0)              ; solid und 
                            EndIf 
                            If *anz_Mesh_ID\texture_normalmap  > ""
                               IrrSetNodeMaterialTexture       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap ) , 1)    ; normal map setzten.
                            EndIf   
                            IrrSetNodeMaterialType             ( irr_obj , MaterialType )    
                           
                           ;}
                           
                   EndSelect 
                   
                   
                 ;}
                    
                    If anz_islighting
                       IrrSetNodeMaterialFlag( *anz_Mesh_ID\nodeID , #IRR_EMF_LIGHTING   ,  *anz_Mesh_ID)
                    Else 
                       IrrSetNodeMaterialFlag( *anz_Mesh_ID\nodeID , #IRR_EMF_LIGHTING   ,  *anz_Mesh_ID)
                    EndIf 
                    
                    IrrSetNodeMaterialFlag( *anz_Mesh_ID\nodeID , #IRR_EMF_FOG_ENABLE , anz_isfog      )
                    EndIf 
                EndIf 
                
             ProcedureReturn irr_obj 
             
   EndProcedure 

   Procedure anz_GetMeshMaterialDetail ( ListObjectID.i , MaterialType.i , isparallax.w=1, isnormal.w=1) ; schaut, ob das Material parallaxmapped ist, wenn das gewünscht ist usw..
      Static currentlistenobject.i 
      
      ; -----------------------------------------------------------------------------------------
      ; ----- auskommentiert, da Im moment kein Nutzen. sollte prüfen, ob man beim mesh z.b. das material überhaupt wechseln soll. 
      ; ----- Im moment wird pro durchlauf das Meshmaterial neu gesetzt. 
      ; -----------------------------------------------------------------------------------------
      
      
      currentlistenobject = @anz_mesh()   ; speichern des aktuellen elements zum späteren zurucksetzen..
             
             ChangeCurrentElement         ( anz_mesh() , ListObjectID )           ; setzten des als gewunschte gespeicherten Listenelements
                 
                 If anz_mesh()\geladen        = 1
                 
                    irr_obj                   = anz_mesh()\nodeID                   ; vereinfachen der ID auf ne variable
                    
                    ;{
                    
                    Select MaterialType 
                    
                       Case #IRR_EMT_PARALLAX_MAP_SOLID
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled        ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                                  ProcedureReturn #IRR_EMT_PARALLAX_MAP_SOLID
                           ElseIf anz_IsNormalmappingEnabled()    And isnormal ; wenn statt parallax wenigstens normalmapping an ist.
                                  ProcedureReturn #IRR_EMT_NORMAL_MAP_SOLID
                           Else  ; ansonsten solid anzeigen. 
                                  ProcedureReturn #IRR_EMT_SOLID 
                           EndIf 
                           
                           ;}

                       Case #IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled        ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                               ProcedureReturn #IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                           ElseIf anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                               ProcedureReturn #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                           Else  ; ansonsten IRR_EMT_TRANSPARENT_ADD_COLOR anzeigen. 
                               ProcedureReturn #IRR_EMT_TRANSPARENT_ADD_COLOR
                           EndIf 
                           
                           ;}
                       
                       Case #IRR_EMT_NORMAL_MAP_SOLID 
                           
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                               ProcedureReturn #IRR_EMT_NORMAL_MAP_SOLID
                           Else  ; ansonsten solid anzeigen. 
                               ProcedureReturn #IRR_EMT_SOLID
                           EndIf 
                           
                           ;}
                           
                       Case #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                          
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                               ProcedureReturn #IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                           Else  ; ansonsten solid anzeigen. 
                               ProcedureReturn #IRR_EMT_TRANSPARENT_ADD_COLOR
                           EndIf 
                           
                           ;}
                           
                       Default  ; alle anderen Techniken sollten unterstützt werden. 
                            
                           ;{
                           ProcedureReturn MaterialType 
                           ;}
                           
                   EndSelect 
                   
                   
                 ;}
                 
                EndIf 
                
            ChangeCurrentElement( anz_mesh() , currentlistenobject ) ; wieder zum vorherigen listenelement zurückschalten .
             
             ProcedureReturn irr_obj 
             
   EndProcedure 
   
   Procedure anz_setShownObjects(irr_Camera) ; lädt und löscht objekte, wenn sie nah bzw. fern sind. (resourceschonung)
      
      Protected *p_obj.anz_Object3d , ObjectArt.w, px.f, py.f, pz.f , isnormalmapping.w , irr_obj.i , rasterx.i , rastery.i , rasterz.i , *anz_mesh.anz_mesh 
      Protected *p_list_bill.anz_billboard , *p_list_mesh.anz_mesh , *p_list_particle.anz_particle , *p_list_terrain.anz_terrain 
      Protected x1.f , y1.f, z1.f , x2.f , y2.f , z2.f , anz_obj_cam_dist.f , radx.f,rady.f,radz.f
      Static    anzahl_zuladendes.f , dist_faktor.f = 90 , key_4_gedruckt.i
      
      If Not irr_Camera 
         ProcedureReturn 0
      EndIf 
      
      IrrGetNodeAbsolutePosition( irr_Camera , @x1 , @y1 , @z1)   ; prüft die Position des spielers. weil aus der include_spieler.pb -> befehle beginnen mit "spi_"
      
      rasterx = Round( x1 / #anz_rasterboxbreite  , 1 )
      rastery = Round( y1 / #anz_rasterboxhohe    , 1 )
      rasterz = Round( z1 / #anz_rasterboxbreite  , 1 )
      anzahl_zuladendes -0.4 ; man darf nur maximal einen Wert von 1 neuladen (= 1 Mesh pro Zyklus)

    For x_for = -5 To 5
         For y_for = -4 To 4
            For z_for = -5 To 5
               
                
               ; das Raster einstellen - also für anz_raster (x,y,z)
               x         = x_for + rasterx
               y         = y_for + rastery
               z         = z_for + rasterz
               
               If x < 0 Or y < 0 Or z < 0  ; darf ja nicht -1 sein..
                  Continue  
               EndIf
               
               If x > #anz_rasterbreite Or y > #anz_rasterhohe Or z > #anz_rasterbreite  ; darf auch nicht oben aus dem raster fallen.
                  Continue 
               EndIf 
               
               For n = 0 To anz_raster ( x,y,z )\anzahl_nodes -1 ; setzt voraus, dass die node-liste sortiert ist ( kein "exist=0" )
 
                  ChangeCurrentElement ( anz_Object3d  () , anz_raster(x,y,z)\node[n] )  ; nur zur sicherheit noch nicht rausgehauen.
                  *p_obj               = anz_raster(x,y,z)\node[n]
                  If *p_obj = 0
                    Continue 
                  EndIf 
                  ObjectArt            = *p_obj\art 
                  
                  anz_obj_cam_dist     =  math_distance3d    (x1,y1,z1, *p_obj\x , *p_obj\y , *p_obj\z) - rady  ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)

                  Select ObjectArt 
                     
                     Case #anz_art_billboard  ; das aktuelle element ist ein billboard (z.b. graß usw.
                         
                         ;{  billboard
                            
                            ChangeCurrentElement ( anz_billboard() , *p_obj\id)
                            *p_list_bill         = *p_obj\id              ; *p_obj\id  ist die ID des Billboard Listenelements. soll hier direkt ausgewählt werden.
                            irr_obj              = *p_list_bill\id
                            irr_shader           = *p_list_bill\irr_emt_materialtype
                            If anz_IsObject3dChild( *p_obj ) ; wenns ein child ist, ist der abstand zur kamera nicht ausschlaggebend! der parent bestimmt dann alles.
                               anz_obj_cam_dist  = 0
                            EndIf 
                            
                            If anz_obj_cam_dist < anz_distance_nah             ; nahe objekte, neuladen, wenn gelöscht usw.
                               
                               ;{
                                
                                 ; billboard neuladen, wenn gelöscht
                                 If  irr_obj         <= 0
                                     irr_obj         = anz_reload_object3d( *p_obj )
                                     If Not irr_obj
                                        Continue ; wenn arbeits bzw. grafikkartenspeicher voll
                                     EndIf 
                                 EndIf 
                                 
                                 ; billboard anzeigen, wenn versteckt
                                 If irr_obj And  Not anz_IsObject3dChild( *p_obj )
                                    If Not IrrGetNodeVisibility  ( irr_obj)
                                       IrrSetNodeVisibility      ( irr_obj , 1)
                                    EndIf 
                                 EndIf 
                               ;}
                               
                            ElseIf anz_obj_cam_dist < anz_distance_fern        ; hier noch weniger anzeigen
                               
                                 ;{
                                
                                 ; billboard neuladen, wenn gelöscht
                                 If  irr_obj         <= 0
                                     irr_obj         = anz_reload_object3d( *p_obj )
                                     If Not irr_obj
                                        Continue ; wenn arbeits bzw. grafikkartenspeicher voll
                                     EndIf 
                                 EndIf 
                                 
                                 ; billboard anzeigen, wenn versteckt
                                 If irr_obj >0 And  Not anz_IsObject3dChild( *p_obj )
                                    If IrrGetNodeVisibility ( irr_obj) 
                                       If math_iseven( irr_obj) ; nur jedes 2. (also jedes Billb. mit gerader ID wird angezeigt)
                                          IrrSetNodeVisibility     ( irr_obj , 1)
                                       Else ; jedes ungerade wird ausgeblendet.
                                          IrrSetNodeVisibility     ( irr_obj , 0)
                                       EndIf 
                                    EndIf 
                                 EndIf 
                               ;}
                               
                            ElseIf anz_obj_cam_dist < anz_distance_ferner        ; ausblenden der billboards nicht textur loeschen, weil die ja nur 1. mal voranden ist (für alle billbaords) bei kleineren karten geht des schon
                               
                               If irr_obj And  Not anz_IsObject3dChild( *p_obj )
                                  If  IrrGetNodeVisibility    ( irr_obj )     ; wenns angezeigt wird
                                      IrrSetNodeVisibility    ( irr_obj , 0)  ; ausblenden
                                  EndIf 
                               EndIf 
                               
                            EndIf 
                         
                         ;}
                         
                     Case #anz_art_collisionsmatrix   ; nothing to do.. ;)
                        
                         ;{  collisonsmatirx
                         ;}
                         
                     Case #anz_art_light   ; nothing to do.. either ;)
                         
                         ;{  light         ; werden von irrlicht selbst geregelt
                         ;}
                         
                     Case #anz_art_mesh
                            
                         ;{  mesh
                            
                             *anz_mesh           = *p_obj\id                         ; setzten des als *p_obj_id gespeicherten Listenelements
                            irr_obj              = *anz_mesh\nodeID                  ; vereinfachen der ID auf ne variable
                            irr_shader           = *anz_mesh\irr_emt_materialtype    ; vereinfachen von materialtyp (normalmap, solid , parallaxmap etc)
                            irr_current_shader   = *anz_mesh\currentmaterialtype     ; welches Material er im Moment z.b. aus spargründen hat. (weit entferntes ist solid)
                            ani_updateanim       ( *anz_mesh )                      ; animiert die (geladenen) meshes. ;) :)
                            
                            If *anz_mesh\geladen = 1         ; WICHTIG: die Irrlicht Instanz ist die tiefste --> irrlicht gibt die Position an.!
                               IrrGetNodePosition( irr_obj , @*p_obj\x  , @*p_obj\y , @*p_obj\z) 
                               If *anz_mesh\WesenID > 0
                                  wes_UpdateWesen( *anz_mesh\WesenID )
                               EndIf 
                               If *anz_mesh\itemID > 0
                               
                               EndIf 
                            EndIf  
                              
                            ;{ entfernung zum objekt mit radius 
                            
                               If Not anz_IsObject3dChild( *p_obj) ; wenn es ein child ist, wird node nicht gelöscht etc.
                                    If *anz_mesh\geladen 
                                       IrrGetNodeExtentTransformed( anz_getObject3DIrrNode( *p_obj ) , @radx,@rady,@radz) 
                                       *anz_mesh\width   = radx
                                       *anz_mesh\height  = rady
                                       *anz_mesh\depth   = radz
                                    Else 
                                       radx = *anz_mesh\width
                                       rady = *anz_mesh\height
                                       radz = *anz_mesh\depth
                                    EndIf 
                                    rady    = math_distance3d( radx , rady , radz , 0,0,0) ; sozusagen die 0-vectoren.. somit wird die raumdiagonale berechnet.
                                    rady    / 2                             ; rady ist jetzt radius.. 
                               Else 
                                    rady    = 0 
                               EndIf 
                               
                            ;}
                            
                            ; rady / #meter ist der Faktor, um den alles verkürzt/längert werden muss..
                            
                            If anz_obj_cam_dist  <= anz_distance_nah * rady / dist_faktor                  ; nahe objekte, neuladen, wenn gelöscht usw.
                               
                                 ;{
                                 ; mesh neuladen, wenn gelöscht
                                 If Not *anz_mesh\geladen = 1 And anzahl_zuladendes < 1 And  Not anz_IsObject3dChild( *p_obj )
                                    anzahl_zuladendes + 0.2
                                    irr_obj = anz_reload_object3d( *p_obj)
                                 EndIf 
                                 
                                 ; XYZ -Werte dem Mesh anpassen (irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 irr_obj = *anz_mesh\nodeID 
                                 If Not irr_obj  ; wenn trotzdem nicht geladen werden konnte
                                    Continue 
                                 EndIf 
                                 
                                 IrrGetNodePosition       ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( *anz_mesh , *anz_mesh\irr_emt_materialtype , 1 ,1)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,1,1)
                                 EndIf 
                                 
                                 ; mesh anzeigen, wenn versteckt
                                  If Not anz_IsObject3dChild( *p_obj )
                                     If Not IrrGetNodeVisibility     ( irr_obj ) = 1 
                                        IrrSetNodeVisibility         ( irr_obj , 1)
                                     EndIf 
                                  EndIf 
                                  
                                 ; schatten laden, wenn noch nicht vorhanden
                                 If anz_IsShadowEnabled() 
                                    If *anz_mesh\ShadowID = 0
                                       *anz_mesh\ShadowID = IrrAddNodeShadow( *anz_mesh\nodeID )
                                    Else
                                       ; If IrrGetNodeVisibility( *anz_mesh\ShadowID) = 0
                                          IrrSetNodeVisibility( *anz_mesh\ShadowID, 1)
                                       ; EndIf 
                                    EndIf 
                                 EndIf 
                                 
                               ;}
                               
                            ElseIf anz_obj_cam_dist <= anz_distance_fern  * rady / dist_faktor       ; hier noch weniger anzeigen
                               
                                 ;{
                                 
                                 ; laden, wenn gelöscht. 
                                
                                 If Not *anz_mesh\geladen       = 1 And anzahl_zuladendes < 1 And  Not anz_IsObject3dChild( *p_obj )
                                    anzahl_zuladendes            + 0.3
                                    irr_obj = anz_reload_object3d( *p_obj)
                                 EndIf 
                                 
                                 ; XYZ -Werte dem Mesh anpassen ( irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 If irr_obj 
                                    IrrGetNodePosition            ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 Else 
                                    Continue  
                                 EndIf 
                                 
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( @*anz_mesh , *anz_mesh\irr_emt_materialtype , 0 ,1)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial        ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,0,1)
                                 EndIf 
                                 
                                 ; mesh anzeigen, wenn versteckt
                                 If Not IrrGetNodeVisibility    ( irr_obj ) And  Not anz_IsObject3dChild( *p_obj )
                                    IrrSetNodeVisibility        ( irr_obj , 1)
                                 EndIf
                                 
                                 ; schatten laden, wenn noch nicht vorhanden
                                 If anz_IsShadowEnabled()
                                    If *anz_mesh\ShadowID = 0
                                       *anz_mesh\ShadowID = IrrAddNodeShadow( *anz_mesh\nodeID )
                                    Else
                                       If IrrGetNodeVisibility( *anz_mesh\ShadowID) = 0
                                          IrrSetNodeVisibility( *anz_mesh\ShadowID ,1 )
                                       EndIf 
                                    EndIf 
                                 EndIf 
                                 
                                 ;}
                               
                            ElseIf anz_obj_cam_dist <= anz_distance_ferner * rady / dist_faktor        ; evtl kleinere Objekte ausblenden.
                                 
                                 ;{
                                 
                                 ; laden, wenn gelöscht. 
                                 If Not *anz_mesh\geladen       = 1 And anzahl_zuladendes < 1 And  Not anz_IsObject3dChild( *p_obj )
                                    anzahl_zuladendes            + 0.4
                                    irr_obj = anz_reload_object3d( *p_obj)
                                 EndIf 
                                
                                 ; XYZ -Werte dem Mesh anpassen ( irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 If Not irr_obj ; wenns nicht geladen werden konnte.
                                    Continue
                                 EndIf 
                                 
                                 irr_obj                        = *anz_mesh\nodeID  ; sonst stürtzer uns wieder ab..
                                 IrrGetNodePosition             ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( @*anz_mesh , *anz_mesh\irr_emt_materialtype , 0 ,0)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial         ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,0,0)
                                 EndIf 
                                 
                                 ; mesh anzeigen, wenn versteckt, bzw. ausblenden wenn angezeigt und zu klein.

                                 If Not IrrGetNodeVisibility    ( irr_obj )  And  Not anz_IsObject3dChild( *p_obj )
                                       IrrSetNodeVisibility     ( irr_obj , 1)
                                 EndIf 
                                    
                                 ; schatten ausblenden, um leistung zum sparen
                                 If *anz_mesh\ShadowID > 0 And anz_IsShadowEnabled()
                                    If Not IrrGetNodeVisibility( *anz_mesh\ShadowID) = 0 ; wenn angezeigt
                                       IrrSetNodeVisibility( *anz_mesh\ShadowID,0)
                                    EndIf 
                                 EndIf 
                                 
                                 ;}
                                 
                            ElseIf anz_obj_cam_dist <= anz_distance_unsichtbar * rady / dist_faktor   ; ausblenden des Meshes
                            
                                 ;{
                                 
                                 ; laden, wenn gelöscht. 
                                 If Not *anz_mesh\geladen       = 1 And anzahl_zuladendes < 1 And  Not anz_IsObject3dChild( *p_obj )
                                    anzahl_zuladendes            + 0.4
                                    irr_obj = anz_reload_object3d( *p_obj)
                                 EndIf 
                                
                                 ; XYZ -Werte dem Mesh anpassen ( irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 If irr_obj = 0
                                    Continue 
                                 EndIf 
                                 
                                 irr_obj                        = *anz_mesh\nodeID  ; sonst stürtzer uns wieder ab..
                                 IrrGetNodePosition             ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( @*anz_mesh , *anz_mesh\irr_emt_materialtype , 0,0)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial         ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,0,0)
                                 EndIf 
                                 
                                 If Not IrrGetNodeVisibility    ( irr_obj ) And  Not anz_IsObject3dChild( *p_obj )
                                       IrrSetNodeVisibility     ( irr_obj , 0)
                                 EndIf 
                                 
                                 ; schatten ausblenden, falls eingeschaltet... neue Erkenntnis: schatten wird vermutlich von selbst ausgeblendet/gelöscht etc.
                                 ; If *anz_mesh\ShadowID > 0 And anz_IsShadowEnabled() 
                                    ; If Not IrrGetNodeVisibility( *anz_mesh\ShadowID) = 0 ; wenn angezeigt
                                       ; IrrSetNodeVisibility( *anz_mesh\ShadowID,0)
                                    ; EndIf 
                                 ; EndIf 
                                 
                                 ;}
                                 
                            ElseIf anz_obj_cam_dist  > anz_distance_unsichtbar * rady / dist_faktor    ; löschen des meshes
                                
                                 ;{
                                 
                                 If *anz_mesh\geladen And Not wes_getSpielerID(*anz_mesh\WesenID ) > 0 ; spieler werden nicht gelöscht! ma kann ja schlecht ohne Körper rumlaufen, als spieler.. 
                                    
                                    If Not anz_IsObject3dChild ( *p_obj ) ; children werden nur von den eltern gelöscht!
                                       IrrSetNodeVisibility    ( irr_obj , 0 ) 
                                       anz_freenode            ( *p_obj )
                                    EndIf 
                                    
                                 EndIf 
                                 ;}
                                
                            EndIf 
                            
                            
                         ;}
                         
                     Case #anz_art_particle
                     
                         ;{  particle
                             
                            ChangeCurrentElement ( anz_particle () , *p_obj\id)          ; setzten des als *p_obj_id gespeicherten Listenelements
                            irr_obj              = anz_particle()\nodeID                     ; vereinfachen der ID auf ne variable
                            irr_shader           = anz_particle()\irr_emt_materialtype   ; vereinfachen von materialtyp (normalmap, solid , parallaxmap etc)
                            
                            If anz_IsObject3dChild( *p_obj ) ; wenns ein child ist, ist der abstand zur kamera nicht ausschlaggebend! der parent bestimmt dann alles.
                               anz_obj_cam_dist  = 0
                            EndIf 
                            
                            Select anz_obj_cam_dist 
                               
                               Case 0 To anz_distance_nah                             ; voll angezeigt
                                  
                                  ;{ Nahe particle
                                  
                                  ; wenn hidden: anzeigen
                                  If IrrGetNodeVisibility( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     IrrSetNodeVisibility( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate auf voll setzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_paritlcles_per_second , anz_particle()\nodestruct\max_paritlcles_per_second , #anz_meter /2 )
                                  ;}
                                  
                               Case anz_distance_nah To anz_distance_fern             ; bisschen weniger angezeigt
                                  
                                  ;{ ferne particle
                                  
                                  ; wenn hidden: anzeigen
                                  If IrrGetNodeVisibility( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     IrrSetNodeVisibility( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate runtersetzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_paritlcles_per_second *0.6, anz_particle()\nodestruct\max_paritlcles_per_second *0.66 , #anz_meter / 2)
                                  ;}
                                  
                               Case anz_distance_fern To anz_distance_ferner          ; noch weiter
                                  
                                  ;{ fernere particles
                                  
                                  ; wenn hidden: anzeigen
                                  If IrrGetNodeVisibility( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     IrrSetNodeVisibility( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate runtersetzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_paritlcles_per_second *0.2, anz_particle()\nodestruct\max_paritlcles_per_second *0.2 , #meter / 2)
                                  
                                  ;}
                                  
                               Case anz_distance_ferner To anz_distance_unsichtbar    ; beinahe unsichtbar
                                  
                                  ;{ ganz ganz ferne particles
                                  
                                  ; wenn hidden: anzeigen
                                  If IrrGetNodeVisibility( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     IrrSetNodeVisibility( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate runtersetzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_paritlcles_per_second *0.01, anz_particle()\nodestruct\max_paritlcles_per_second *0.01 , #meter / 2)
                                  
                                  ;}
                                  
                               Default                                                ; nicht löschen! wird nur gehidden. evtl erst ab 1. beta, wenns sein soll.
                                  
                                  ;{ ausgeblendete particles.
                                  
                                  ; wenn angezeigt: hide.
                                  If IrrGetNodeVisibility( anz_particle()\nodeID ) = 1 And Not anz_IsObject3dChild( *p_obj)
                                     IrrSetNodeVisibility( anz_particle()\nodeID , 0 )
                                  EndIf 
                                  
                                  ;}
                                  
                            EndSelect 
                                  
                         ;}
                         
                     Case #anz_art_sound3d
                     
                         ;{  sound3d   soundsource laden/löschen usw.
                         
                         
                         ;}
                         
                     Case #anz_art_terrain
                     
                         ;{  Terrain
   
                               
                            ChangeCurrentElement ( anz_terrain() , *p_obj\id)          ; setzten des als *p_obj_id gespeicherten Listenelements
                            irr_obj              = anz_terrain()\nodeID                 ; vereinfachen der ID auf ne variable
                               ; Terrain wird ausgeblendet, wenn es auf dem Bildschirm nur noch 400 * 400 * 75 pixel groß ist.
                               If  anz_getObjectScreenWidth(*p_obj\x , *p_obj\y , *p_obj\z ,  anz_terrain()\width )  * anz_getObjectScreenHeight( *p_obj\x , *p_obj\y , *p_obj\z , anz_terrain()\height )   * anz_getObjectScreenDepth ( *p_obj\x , *p_obj\y , *p_obj\z , anz_terrain()\depth ) <= 400*400*75 And Not (anz_terrain()\width  <= 0 Or anz_terrain()\height <= 0 Or anz_terrain()\depth <= 0)
                                  
                                  If anz_terrain()\width  <= 0 Or anz_terrain()\height <= 0 Or anz_terrain()\depth <= 0
                                     If anz_terrain()\geladen = 1
                                        IrrGetNodeExtentTransformed( anz_terrain()\nodeID , anz_terrain()\width , anz_terrain()\height , anz_terrain()\depth )
                                      EndIf
                                  EndIf 
                                  
                                  If anz_terrain     ()\geladen = 1
                                     IrrRemoveNode   ( irr_obj )
                                     anz_terrain     ()\geladen = 0
                                     anz_freetexture ( anz_gettexturebypfad( anz_terrain()\texture1 ))
                                     anz_freetexture ( anz_gettexturebypfad( anz_terrain()\texture2 ))
                                     IrrRemoveCollisionGroupFromCombination( anz_CollisionMeta_solid , anz_terrain     ()\CollisionID ) ; collision von meta löschen.
                                  EndIf 
                                  
                               Else ; nichts tun.. prüfen, ob schon geladen; wenn nicht-> laden.
                                  
                                  If anz_terrain()\geladen        = 0 ; Ansonsten Neuladen,  wenn noch nicht geladen
                                     anz_terrain()\nodeID         = IrrAddTerrain  ( anz_terrain()\terrainmap )
                                     
                                     If anz_terrain()\nodeID      > 0
                                        IrrSetNodePosition        ( anz_terrain()\nodeID ,  *p_obj\x , *p_obj\y , *p_obj\z)
                                        IrrSetNodeScale           ( anz_terrain()\nodeID , anz_terrain()\scalex , anz_terrain()\scaley , anz_terrain()\scalez)
                                        IrrSetNodeRotation        ( anz_terrain()\nodeID , anz_terrain()\rotx   , anz_terrain()\roty   , anz_terrain()\rotz)
                                        irr_obj                   = anz_terrain()\nodeID ; der vollständigkeit halber..
                                        anz_terrain()\geladen     = 1 
                                        IrrSetNodeMaterialTexture ( anz_terrain()\nodeID , IrrGetTexture( anz_terrain()\texture1 ) , 0 ); anz_loadtexture( anz_terrain()\texture1 ),0)
                                        IrrSetNodeMaterialTexture ( anz_terrain()\nodeID , IrrGetTexture( anz_terrain()\texture2 ) , 1 ); anz_loadtexture( anz_terrain()\texture2 ),1)
                                        IrrScaleTexture           ( anz_terrain()\nodeID , anz_terrain()\texturescalex, anz_terrain()\texturescaley)
                                        IrrSetNodeMaterialFlag    ( anz_terrain()\nodeID , #IRR_EMF_LIGHTING , anz_terrain()\islighting)
                                        IrrSetNodeMaterialType    ( anz_terrain()\nodeID , anz_terrain()\irr_emt_materialtype )
                                        ; collision: ausgeblendet, da sonst zu viel leistung braucht.. 
                                        anz_terrain()\CollisionID = IrrAddCollisionGroupToCombination( anz_CollisionMeta_solid , IrrGetCollisionGroupFromTerrain( anz_terrain()\nodeID , 1 ))
                                     EndIf 
                                  EndIf 
                                  
                                  ; oder nichts weiter tun.
                                  
                               EndIf 
                         
                         ;}
                         
                  EndSelect 
                  
               Next  
                  
            
            Next 
         Next 
      Next 

   EndProcedure 
   
   Procedure anz_displayImages()
       ; display 2d alpha images.
       
       ResetList( anz_image())
       
          While NextElement (anz_image())
             If Not anz_image()\ishidden
                IrrDraw2DImageElement(anz_image()\id , anz_image()\x , anz_image()\y , 0 , 0 , IrrTextureWidth(anz_image()\id) , IrrTextureHeight(anz_image()\id) , anz_image()\Alpha )
             EndIf 
          Wend 
          
   EndProcedure 
   
   
   ; Physics..
   
   Procedure anz_dropstuff()  ; .. 1. BETA Dinge können herunterfallen.
   
   EndProcedure 
   
   ; free Things

   Procedure anz_freemesh( *p_anz_mesh.anz_mesh ) ; gibt das Mesh frei zum späteren Neuladen (Auslagern)
       
       If *p_anz_mesh\geladen ; wenns noch geladen ist (laut variable)
          
          *p_anz_mesh\geladen    = 0
          *p_anz_mesh\ShadowID   = 0 ; wichtig: schatten als ungeladen markieren
          anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture ))            ; die texturen löschen
          anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture_normalmap))   ; normalmap-texture löschen
          If *p_anz_mesh       \Collisiontype        = #anz_ColType_solid
             IrrRemoveCollisionGroupFromCombination ( anz_CollisionMeta_solid , *p_anz_mesh\collisionNodeID)
          ElseIf *p_anz_mesh   \Collisiontype       = #anz_ColType_movable
             IrrRemoveAnimator ( *p_anz_mesh\nodeID , *p_anz_mesh\collisionanimator )
          EndIf 
          
          IrrRemoveNode        ( *p_anz_mesh\nodeID ) ; löscht shattennode automatisch mit.
          IrrRemoveMesh        ( *p_anz_mesh\meshID )
          *p_anz_mesh\nodeID   = 0
          *p_anz_mesh\meshID   = 0
          ProcedureReturn      1
       EndIf 
       
   EndProcedure                                   
   
   Procedure anz_ReConnectChildren2Parents( *p_anz_Object3D.anz_Object3d ) ; neuverknüpfung aller child-parent bindungen. (irrlicht-mäßig)
      Protected *anz_object3d_child.anz_Object3d 
      
      If Not *p_anz_Object3D
         ProcedureReturn 0
      EndIf 
      
      ;{ alle children solln auch neugeladen werden 
      
      If anz_IsObject3dParent   ( *p_anz_Object3D ) ; wenn das 3d objekt children hat:
         For n = 0 To #anz_max_children -1   
         ; liste absuchen
            *anz_object3d_child                 = *p_anz_Object3D\child[n]
            If *anz_object3d_child              > 0 ; wenn = children
               
               If anz_getobject3dIsGeladen      ( *anz_object3d_child) And anz_getobject3dIsGeladen( *p_anz_Object3D ); wenn beides geladen (irrlicht-mäßig)
                  
                  IrrAddChildToParent           ( anz_getObject3DIrrNode( *anz_object3d_child)  , anz_getObject3DIrrNode(*p_anz_Object3D )) ; verbinden
                  IrrSetNodePosition            ( anz_getObject3DIrrNode( *anz_object3d_child)  , *anz_object3d_child\x , *anz_object3d_child\y , *anz_object3d_child\z )
                  Debug "coordinaten: "
                  Debug "art: " + Str( *p_anz_Object3D\art )
                  Debug *anz_object3d_child\x
                  Debug *anz_object3d_child\y
                  Debug *anz_object3d_child\z
               EndIf 
               
               If anz_IsObject3dParent          ( *anz_object3d_child ) ; wenn das auch noch children hat:
                  anz_ReConnectChildren2Parents ( *anz_object3d_child) ; DEREN children auch absuchen , sozusagen in die Warteschleife legen.
               EndIf 
               
            EndIf 
            
         Next 
      EndIf 
      ; schlussendlich laufen dann alle Proceduren hier weiter..
      ; Und die erste, die angefangen hat gibt den irr_obj-wert aus (was wichtig ist für anz_setshownobjects)
      
      ;}
      
   EndProcedure 
   
   Procedure anz_reload_object3d( *p_anz_Object3D.anz_Object3d ) ; ein object3d wird wieder geladen, wenn es aus'm speicher gefreed wurde; rückgabe: irr_objID
      Protected irr_obj.i , *p_list_bill.anz_billboard , *p_list_mesh.anz_mesh , irr_shader
      
      If Not *p_anz_Object3D
         ProcedureReturn 0
      EndIf 
      ;{ alle children solln auch neugeladen werden 
      
      If anz_IsObject3dParent   ( *p_anz_Object3D ) ; wenn das 3d objekt children hat:
         For n = 0 To #anz_max_children -1             ; liste absuchen
            
            If *p_anz_Object3D\child [n] > 0 ; wenn = children
            
               If anz_IsObject3dParent( *p_anz_Object3D\child[n] ) ; wenn das auch noch children hat:
                  anz_reload_object3d ( *p_anz_Object3D\child[n] ) ; DEREN children auch absuchen , sozusagen in die Warteschleife legen.
               EndIf 
               
            EndIf 
            
         Next 
      EndIf 
      ; schlussendlich laufen dann alle Proceduren hier weiter..
      ; Und die erste, die angefangen hat gibt den irr_obj-wert aus (was wichtig ist für anz_setshownobjects)
      
      ;}
      
      
      Select *p_anz_Object3D\art 
      
         Case #anz_art_billboard
            
            ;{ billbaord loaden
                  
                   *p_list_bill      = *p_anz_Object3D\id 
                   irr_obj           = IrrAddBillBoardToScene( *p_list_bill\width , *p_list_bill\height , *p_anz_Object3D\x , *p_anz_Object3D\y , *p_anz_Object3D\z) ; p_obj ist das anz_objekt3d().
                   If irr_obj
                   
                       IrrSetNodeMaterialTexture ( irr_obj , anz_loadtexture( *p_list_bill\pfad) , 0)
                       *p_list_bill\id           = irr_obj
                       IrrSetNodeMaterialType    ( irr_obj , *p_list_bill\irr_emt_materialtype )
                       IrrSetNodeMaterialFlag    ( irr_obj , #IRR_EMF_LIGHTING , *p_list_bill\lighting )
                       
                   Else 
                      ProcedureReturn 0
                   EndIf 
                                 
            ;}

         Case #anz_art_mesh
          
            ;{ mesh laden.
                
                ChangeCurrentElement         ( anz_mesh() , *p_anz_Object3D\id )
                anz_setShownObjects_loadMesh ( )  ; lädt das node, wenn noch nicht geladen und setzt dann materials
                                 
             ;}
      
      EndSelect 
      
      ; parent/children wieder neu über irrlicht verknüpfen:
      anz_ReConnectChildren2Parents( *p_anz_Object3D )
      
      ProcedureReturn irr_obj 
   EndProcedure 
   
   Procedure anz_delete_object3d( *p_anz_Object3D.anz_Object3d , AfterMsTime.i = 0 , ISdeletechildren.i = 1) ; löscht mesh und alles weitere KOMPLETT + das object 3d. (z.b. wenn etwas tot ist.)
      
      
      If *p_anz_Object3D > 0
      
         ChangeCurrentElement ( anz_Object3d() , *p_anz_Object3D )
         anz_raster_Unregister( *p_anz_Object3D )     ; aus dem raster werfen, da ja deleted wird.
         If ISdeletechildren  ; wenn die children auch gelöscht wer den sollen (standard)
            anz_unchild          ( *p_anz_Object3D )     ; alle Children ebenfalls komplett löschen.
         EndIf 
         
         Select *p_anz_Object3D\art 
      
            Case #anz_art_billboard
               
               ChangeCurrentElement ( anz_billboard() , *p_anz_Object3D\id )
               If anz_billboard()\id > 0
                  If AfterMsTime > 0
                     IrrAddDeleteAnimator ( anz_billboard()\id , AfterMsTime)
                  Else 
                     IrrRemoveNode        ( anz_billboard()\id )
                  EndIf 
               EndIf 
               DeleteElement        ( anz_billboard()    )
               DeleteElement        ( anz_Object3d())
            
            Case #anz_art_lensflare
               
               ChangeCurrentElement ( anz_lensflare() , *p_anz_Object3D\id )
                  If AfterMsTime > 0
                     IrrAddDeleteAnimator ( anz_lensflare()\id , AfterMsTime)
                  Else 
                     IrrRemoveNode        ( anz_lensflare()\id  )
                  EndIf 
               DeleteElement        ( anz_lensflare()    )
               DeleteElement        ( anz_Object3d())
            
            Case #anz_art_light
            
               ChangeCurrentElement ( anz_light() , *p_anz_Object3D\id )
                  If AfterMsTime > 0
                     IrrAddDeleteAnimator ( anz_light()\nodeID , AfterMsTime)
                  Else 
                     IrrRemoveNode        ( anz_light()\nodeID  )
                  EndIf 
               DeleteElement        ( anz_light()    )
               DeleteElement        ( anz_Object3d() )
            
            Case #anz_art_mesh
            
               ChangeCurrentElement ( anz_mesh() , *p_anz_Object3D\id )
               If anz_mesh()\geladen 
               
                  IrrRemoveMesh        ( anz_mesh()\meshID )
                  ; collision löschen
                  If anz_mesh()          \Collisiontype       = #anz_ColType_solid
                     IrrRemoveCollisionGroupFromCombination ( anz_CollisionMeta_solid , anz_mesh()\collisionNodeID)
                  ElseIf anz_mesh()      \Collisiontype       = #anz_ColType_movable
                     IrrRemoveAnimator   ( anz_mesh() \nodeID , anz_mesh()\collisionanimator )
                  EndIf 
                  ; meshes löschen
                  If AfterMsTime > 0
                     IrrAddDeleteAnimator ( anz_mesh()\nodeID , AfterMsTime)
                  Else 
                     IrrRemoveNode        ( anz_mesh()\nodeID  )
                  EndIf 
                  ; textures löschen
                  anz_freetexture      ( anz_gettexturebypfad( anz_mesh()\texture ))            ; die texturen löschen
                  anz_freetexture      ( anz_gettexturebypfad( anz_mesh()\texture_normalmap))   ; normalmap-texture löschen
               EndIf 
            
               DeleteElement        ( anz_mesh()    )
               DeleteElement        ( anz_Object3d())
            Case #anz_art_particle
            
               ChangeCurrentElement ( anz_particle() , *p_anz_Object3D\id )
            
               If anz_particle()\geladen = 1
                  IrrAddStopParticleAffector ( anz_particle()\nodeID , 0 )
                  If AfterMsTime > 0
                     IrrAddDeleteAnimator ( anz_particle()\nodeID , AfterMsTime)
                  Else 
                     IrrAddDeleteAnimator ( anz_particle()\nodeID , 2000)
                  EndIf 
               EndIf 
            
               DeleteElement        ( anz_particle()    )
               DeleteElement        ( anz_Object3d()    )
            
            Case #anz_art_sound3d
             
                ; kannma nicht removen.... hm.. naj..a..
               
            Case #anz_art_terrain
            
               ChangeCurrentElement ( anz_terrain() , *p_anz_Object3D\id )
               If anz_terrain       ()\geladen = 1
                  If AfterMsTime > 0
                     IrrAddDeleteAnimator ( anz_particle()\nodeID , AfterMsTime)
                  Else 
                     IrrAddDeleteAnimator ( anz_particle()\nodeID , 2000)
                  EndIf 
               EndIf 
               DeleteElement        ( anz_terrain()    )
               DeleteElement        ( anz_Object3d()   )
            
         EndSelect 
         
      EndIf 
      
   EndProcedure 
   
   Procedure anz_freenode( *p_anz_Object3D.anz_Object3d , ISdeletechildren.i = 1 ) ; löscht nur die Irrlicht sachen, nicht die Nodes.
      Protected *p_anz_mesh.anz_mesh 
      
      ; anz_raster_unregister halte ich für einen Codefehler hier! dann wäre ja das object3d okmplett aus'm raster geworfen, was nicht gewollt sein kann.
      ; anz_raster_Unregister( *p_anz_Object3D ) 
      
      If *p_anz_Object3D = 0
         ProcedureReturn 0
      EndIf 
      
      
      If ISdeletechildren
         anz_unloadChildren  ( *p_anz_Object3D ) ; wenn es children hat, werden die ebenfalls gelöscht (wobei nur die irrlicht-daten)
      EndIf 
      
      Select *p_anz_Object3D\art 
      
         Case #anz_art_billboard
            
            ChangeCurrentElement ( anz_billboard() , *p_anz_Object3D\id )
            Debug anz_billboard()\id 
            If anz_billboard()\id > 0
               IrrRemoveNode        ( anz_billboard()\id )
               anz_billboard()\id = 0
            EndIf 
            
         Case #anz_art_lensflare
            
            ChangeCurrentElement ( anz_lensflare() , *p_anz_Object3D\id )
            IrrRemoveNode        ( anz_lensflare()\id  )
            anz_lensflare        ()\id          = 0
         Case #anz_art_light
            
            ChangeCurrentElement ( anz_light() , *p_anz_Object3D\id )
            IrrRemoveNode        ( anz_light()\nodeID)
            anz_light            ()\nodeID     = 0
            
         Case #anz_art_mesh
            
             *p_anz_mesh              = *p_anz_Object3D\id 
             
             If *p_anz_mesh\geladen  ; wenns noch geladen ist (laut variable)
                *p_anz_mesh\geladen  = 0
                *p_anz_mesh\ShadowID = 0 ; wichtig: schatten als ungeladen markieren
                anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture ))            ; die texturen löschen
                anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture_normalmap))   ; normalmap-texture löschen
                If *p_anz_mesh       \Collisiontype        = #anz_ColType_solid
                   IrrRemoveCollisionGroupFromCombination ( anz_CollisionMeta_solid , *p_anz_mesh\collisionNodeID)
                ElseIf *p_anz_mesh   \Collisiontype       = #anz_ColType_movable
                   IrrRemoveAnimator ( *p_anz_mesh\nodeID , *p_anz_mesh\collisionanimator )
                EndIf 
                
                IrrRemoveNode        ( *p_anz_mesh\nodeID ) ; löscht shattennode automatisch mit.
                IrrRemoveMesh        ( *p_anz_mesh\meshID )
                *p_anz_mesh\nodeID   = 0
                *p_anz_mesh\meshID   = 0
                ProcedureReturn      1
               
            EndIf
            
         Case #anz_art_particle
            
            ChangeCurrentElement ( anz_particle() , *p_anz_Object3D\id )
            
            If anz_particle()\geladen = 1
               IrrAddStopParticleAffector ( anz_particle()\nodeID , 0 )
               IrrAddDeleteAnimator       ( anz_particle()\nodeID , 2000 )
               anz_particle()\geladen = 0
               anz_particle()\nodeID  = 0
            EndIf 
            
         Case #anz_art_sound3d
             
             ; kannma nicht removen.... hm.. naj..a..
            
         Case #anz_art_terrain
            
            ChangeCurrentElement ( anz_terrain() , *p_anz_Object3D\id )
            If anz_terrain       ()\geladen = 1
               IrrRemoveNode     ( anz_terrain()\nodeID )
               anz_terrain       ()\geladen = 0
               anz_terrain       ()\nodeID  = 0
            EndIf 
            
      EndSelect 
     
   EndProcedure 
   
   
; --------------------------------------------------------------------
; -- Main   SCHEMA
; --------------------------------------------------------------------


; initstuff()
; initmenu()
; 
; repeat 
;    examinemenu()
; Repeat 
; 
   ; examine      ()
   ; displaystuff ()
; 
; Until ende = 1
; 
; ende () 
; jaPBe Version=3.9.12.818
; FoldLines=00790089009D00FF0103015101570159015B015D015F01610163016501670169
; FoldLines=016D01770179018001820199019B01A601A801AE01B001B201B401B601B801C4
; FoldLines=01C601D201D401E001E401F501F70209020B021D021F02230225023C023E0253
; FoldLines=02550259025B025F0261028A028E02B902BB02E002E2034003420377037903A9
; FoldLines=03AB03E703E904240426046C046E047D0481049F04A104BE04C2050704C80000
; FoldLines=050905750579058505870589058B058D058F059105930595059705A505A705AA
; FoldLines=05AC05AE05B005B205B405B605B805BA05BC05BE05C005C305C505C705C905CB
; FoldLines=05D5060605F30000060806200622063A063C065006520668066A06820684068A
; FoldLines=068C0695069906BD06BF06CD06CF06E206E607420744077A077C07A007A207C4
; FoldLines=07C607D608020808080A0824083D085B08690872087408A708A908B908BB08C6
; FoldLines=08C808D408D808F008F209560958095E09600C9609880000098E000009B00000
; FoldLines=09B600000A0700000A9700000B0A00000B1000000B5700000BCF00000C160000
; FoldLines=0C4800000C980C9A0C9E0CAF0CB10CBB0CBD0CC70CEB0CFA0CFC0D130D150D20
; FoldLines=0D250D2F0D310D3B0D560D610D630D6E0DCF0E870DDD00000DE300000E0A0000
; FoldLines=0E3100000E890EE30E9A00000EA000000EAE00000EBC00000EC800000ED40000
; FoldLines=0F180F580F2400000F3800000F5C0F5D0F610F620F780F8B0F910FB70FBB0FE0
; FoldLines=0FE41006100A102A102E1038104F1058105C106510691073107710811085108C
; FoldLines=10941097109B10CA10D710E210E710E910ED11021104112B112D116C115F0000
; FoldLines=116E11DC11DE1234
; Build=0
; Language=0x0000 Language Neutral
; CompileThis=..\Anzeige Tester.pb
; FirstLine=344
; CursorPosition=2148
; EnableXP
; EnableOnError
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF