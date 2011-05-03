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
;- Macros
; --------------------------------------------------------------------

   Macro anz_setShownObjects_loadMesh()
                                  
                                 ; irr_obj ist die ID des irrlicht- objekts (eigendlich: anz_mesh()\nodeID
                                 ; mesh neuladen, wenn gelöscht
                                 debugcounter + 1 :  Debug debugcounter
                                 If  anz_mesh()\nodeID     = 0 Or anz_mesh()\geladen = 0; wenn das node es noch nicht geladen ist.
                                     debugcounter + 1 :  Debug debugcounter
                                     anz_mesh()\meshID     = iLoad3DObject     ( anz_mesh()\pfad )    ; laden
                                     ChangeCurrentElement( anz_Object3d () , anz_mesh()\Object3dID )  ; zur sicherheit.. 
                                     
                                     If anz_mesh()\meshID = 0
                                        
                                        DeleteElement ( anz_Object3d ()) 
                                        DeleteElement ( anz_mesh() )
                                        ProcedureReturn 0
                                     EndIf 
                                     If anz_mesh()\anim_IsAnimMesh 
                                        anz_mesh()\nodeID  = iCreateAnimation  ( anz_mesh()\meshID )
                                     Else 
                                        anz_mesh()\nodeID  = icreatemesh       ( anz_mesh()\meshID )
                                     EndIf 
                                     debugcounter + 1 :  Debug debugcounter
                                     
                                     ; set normal And parallax- Mesh With Tangents:
                                     If Not anz_mesh()\anim_IsAnimMesh And ( anz_mesh()\irr_emt_materialtype   = #EMT_NORMAL_MAP_SOLID Or anz_mesh()\irr_emt_materialtype = #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR Or anz_mesh()\irr_emt_materialtype = #EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA Or anz_mesh()\irr_emt_materialtype = #EMT_PARALLAX_MAP_SOLID Or anz_mesh()\irr_emt_materialtype = #EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR Or anz_mesh()\irr_emt_materialtype = #EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA  )
                                        *NewNodeid                        = iCreateMeshWithTangents  (  anz_mesh()\nodeID )
                                        If *NewNodeid 
                                          iFreeNode                       ( anz_mesh()\nodeID )
                                          anz_mesh()\nodeID               = *NewNodeid 
                                          Debug "Tangentmesh created"
                                        EndIf 
                                     EndIf 
                                     
                                     debugcounter + 1 :  Debug debugcounter
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
                                     debugcounter + 1 :  Debug debugcounter
                                     If irr_obj
                                        
                                        ; mesh verschieben, rotaten, scalieren.
                                        iPositionNode( anz_mesh()\nodeID , anz_Object3d()\x  , anz_Object3d()\y  , anz_Object3d()\z)
                                        irotatenode  ( anz_mesh()\nodeID , anz_mesh()\rotx   , anz_mesh()\roty   , anz_mesh()\rotz)
                                        iScaleNode   ( anz_mesh()\nodeID , anz_mesh()\scalex , anz_mesh()\scaley , anz_mesh()\scalez)
                                        debugcounter + 1 :  Debug debugcounter
                                        ; breite, höhe und tiefe berechnen
                                        v_rad.ivector3 
                                        Debug "Load Object Get Extent: " + Str( irr_obj)
                                        E3D_GetExtentTransformed ( irr_obj , @v_rad\x , @v_rad\y , @v_rad\z) 
                                        anz_mesh()\width   = v_rad\x 
                                        anz_mesh()\height  = v_rad\y 
                                        anz_mesh()\Depth   = v_rad\z
                                        debugcounter + 1 :  Debug debugcounter
                                        ; evtl beim rotieren 3 mal IrrRotateNodeByCenter( 
                                        ; mesh verwaltung
                                        anz_mesh()\geladen      = 1                          
                                        
                                        ; mesh material setzen; wobei: vorerst nur Material 1.. PAUSE: jedes material eines meshs soll extra seine eigenschaften kriegen! (können z.B. 20 versch. texturen sein.)
                                        anz_setMeshMaterial   ( anz_mesh() , anz_mesh()\irr_emt_materialtype ,anz_IsNormalmappingEnabled(),anz_IsParallaxmappingEnabled()) ; setzte materialtype + texturen.

                                        debugcounter + 100 :  Debug debugcounter
                                        
                                        ; collision zum Meta hinzufügen
                                        If anz_mesh()\Collisiontype        = #anz_ColType_solid 
                                              ; objekt ist Gebäude         , berg etc.

                                                 ; mesh collision - setzten
                                                 If     anz_mesh()\Collisiondetail  = #anz_col_mesh  ; wird hier immer neugeladen, weil das node ja auch neu ist ;) 
                                                        iSetCollideForm             (  #COMPLEX_PRIMITIVE_SURFACE )
                                                 ElseIf anz_mesh()\Collisiondetail  =  #anz_col_box 
                                                        iSetCollideForm             (  #BOX_PRIMITIVE )
                                                 EndIf 
                                                 ; anz_mesh()\collisionNodeID         =  iCreateBody(anz_mesh()\nodeID , #False) ; nicht bewegbar, deswegen #false.
                                        ElseIf          anz_mesh()\Collisiontype    = #anz_ColType_movable 
                                                 ; mesh collision - setzten
                                                 If     anz_mesh()\Collisiondetail  = #anz_col_mesh  ; wird hier immer neugeladen, weil das node ja auch neu ist ;) 
                                                        iSetCollideForm             (  #COMPLEX_PRIMITIVE_SURFACE )
                                                 ElseIf anz_mesh()\Collisiondetail  =  #anz_col_box 
                                                        iSetCollideForm             (  #BOX_PRIMITIVE )
                                                 EndIf 
                                                 ; anz_mesh()\collisionNodeID         =  iCreateBody(anz_mesh()\nodeID , #True) ; bewegbar, deswegen true. automatisch ist bounding box außenrum; masse = 1... Pause: später evtl masse einstellbar.
                                        EndIf 
                                        debugcounter + 100 :  Debug debugcounter
                                     Else  ;Objekt war nicht ladbar (evtl falscher pfad usw.)
                                        ; Referenz "kugel" erstellen 
                                        anz_mesh()\nodeID = iCreateSphere ( #meter * 0.5 , 20) ; nur halber meter groß.
                                        ; mesh verschieben, rotaten, scalieren.
                                        iPositionNode          ( anz_mesh()\nodeID , anz_Object3d()\x , anz_Object3d()\y , anz_Object3d()\z)
                                        irotatenode            ( anz_mesh()\nodeID , anz_mesh()\rotx , anz_mesh()\roty , anz_mesh()\rotz)
                                        iScaleNode             ( anz_mesh()\nodeID , anz_mesh()\scalex , anz_mesh()\scaley , anz_mesh()\scalez)
                                        ; evtl beim rotieren 3 mal IrrRotateNodeByCenter( 
                                        ; mesh verwaltung
                                        anz_mesh()\geladen      = 1                          
                                        debugcounter + 10 :  Debug debugcounter
                                        ; mesh material 
                                        anz_setMeshMaterial   ( anz_mesh() , #EMT_SOLID ) ; setzte materialtype + texturen.
                                        ; mesh collision setzen -> frombox, weils nur ne kugel ist ;)
                                        iSetCollideForm             (  #BOX_PRIMITIVE )
                                        ; collision zum Meta hinzufügen
                                        If anz_mesh()\Collisiontype        = #anz_ColType_solid 
                                              ; objekt ist Gebäude         , berg etc.
                                              ; anz_mesh()\collisionNodeID = iCreateBody(anz_mesh()\nodeID , #False )
                                        ElseIf anz_mesh()\Collisiontype    = #anz_ColType_movable 
                                              ; Objekt ist Lebewesen.      -> collisionsanimator ;)
                                              ; anz_mesh()\collisionNodeID = iCreateBody(anz_mesh()\nodeID , #True)
                                        EndIf 
                                        debugcounter + 10 :  Debug debugcounter
                                     EndIf 
                                 EndIf 
                                 debugcounter + 1 :  Debug debugcounter
EndMacro 

   Macro anz_updateinput_UseSchnellwahl ( SchnellwahlKey )
    If GetAsyncKeyState_( #VK_1)
         If anz_key_tipped_#SchnellwahlKey = 0
            anz_key_tipped_#SchnellwahlKey = 1
            gui_UseSchnellWahlItem( SchnellwahlKey )
         EndIf 
      EndIf 
   
   EndMacro 
   
; --------------------------------------------------------------------
; Procedures..
; --------------------------------------------------------------------
   
   ; input-Procedures Mouse 
   
   Procedure anz_mousex () ; get mousex
      ProcedureReturn Int( anz_mousex )
   EndProcedure 
   
   Procedure anz_mousey () ; get mousey 
      ProcedureReturn Int ( anz_mousey )
   EndProcedure 
   
   Procedure anz_MouseDeltaX () ; getmousedeltax 
      ProcedureReturn anz_mousedeltax 
   EndProcedure 
   
   Procedure anz_MouseDeltaY () ; mousedeltay
      ProcedureReturn anz_mousedeltay       
   EndProcedure 
   
   Procedure anz_mouseinbox ( x.w , y.w , width.w , height.w ) ; returns1, if mouse is in box.
      
      If anz_mousex() >= x And anz_mousey() >= y 
         If anz_mousex() < x + width And anz_mousey < y + height 
            ProcedureReturn 1 
         EndIf 
      EndIf 
      
   EndProcedure 
   
   Procedure anz_mousebutton_Mouseevent ( ButtonNR ) ; gibt die mouseevents z.b. #anz_MouseEvent_pressed zurück
      If ButtonNR = 1
            ProcedureReturn anz_mb1 
      ElseIf ButtonNR = 2
            ProcedureReturn anz_mb2
      Else
            ProcedureReturn anz_mb3
      EndIf 
   EndProcedure 
   
   Procedure anz_mousebutton( ButtonNR , anz_mouseevent_art = -1)
      
      If ButtonNR = 1
         If anz_mouseevent_art = anz_mb1 Or anz_mouseevent_art = -1
            ProcedureReturn 1
         EndIf 
      ElseIf ButtonNR = 2
         If anz_mouseevent_art = anz_mb2 Or anz_mouseevent_art = -1
            ProcedureReturn 1
         EndIf 
      Else
         If anz_mouseevent_art = anz_mb3 Or anz_mouseevent_art = -1
            ProcedureReturn 1
         EndIf 
      EndIf 
      
   EndProcedure 
   
   ; alle nodes abfragen (z.b. um allen meshes das material zu setzen.)
   
   Procedure anz_ExamineLoadedNodes( ToSearch_Object_art.w , only_they_in_view.b = 1 , max_distance.f = #meter * 100 , bezugX.f = -1 , bezugY.f=-1, bezugZ.f=-1) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
     Protected *p_obj.anz_Object3d , ObjectArt.w, px.f, py.f, pz.f , irr_obj.i , rasterx.i , rastery.i , rasterz.i    ; wenn OnlyItems1_OnlyWesen2 = 1, dann nur items suchen, wenn =2, dann nur wesen.
     Protected *anz_billboard.anz_billboard , *anz_mesh.anz_mesh , *anz_light.anz_light , *anz_lensflare.anz_lensflare , *anz_particle.anz_particle , *anz_sound3d.anz_sound3d , *anz_terrain.anz_terrain 
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

                  *p_obj               = anz_raster(x,y,z)\node[n]
                  ObjectArt            = *p_obj\art 
                  anz_obj_cam_dist     = math_distance3d    (px,py,pz, *p_obj\x , *p_obj\y , *p_obj\z)   ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)
                  If anz_obj_cam_dist  > max_distance And Not max_distance = #anz_any    ; damit nicht alle, sondern nur die objekte inderr Nähe überprüft werden.
                     Continue 
                  EndIf 
                  
                  If ToSearch_Object_art = ObjectArt Or ToSearch_Object_art = -1
                     
                     If AddElement       ( anz_Examined_node())
                        anz_Examined_node()\Object3dID = *p_obj 
                        anz_Examined_node()\nodeart    = ObjectArt 
                     
                       Select ObjectArt 
                        
                          Case #anz_art_billboard
                           
                             *anz_billboard                 =  *p_obj\id
                             anz_Examined_node()\nodeID     = *anz_billboard \id
                             anz_Examined_node()\AnzID      = *anz_billboard   
                     
                          Case #anz_art_lensflare
                             
                             *anz_lensflare                 = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_lensflare \id 
                             anz_Examined_node()\AnzID      = *anz_lensflare
                            
                           Case #anz_art_light
                           
                             *anz_light                     = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_light \nodeID 
                             anz_Examined_node()\AnzID      = *anz_light
                           
                           Case #anz_art_mesh
                        
                             *anz_mesh                      = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_mesh \nodeID 
                             anz_Examined_node()\AnzID      = *anz_mesh
                            
                           Case #anz_art_particle 
                           
                             *anz_particle                  = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_particle \nodeID 
                             anz_Examined_node()\AnzID      = *anz_particle
                           
                           Case #anz_art_sound3d
                           
                             *anz_sound3d                   = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_sound3d \id 
                             anz_Examined_node()\AnzID      = *anz_sound3d
                           
                           Case #anz_art_terrain
                           
                             *anz_terrain                   = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_terrain \nodeID 
                             anz_Examined_node()\AnzID      = *anz_terrain
                           
                           Case #anz_art_skybox
                              
                              anz_Examined_node()\nodeID     = anz_skybox\nodeID 
                              anz_Examined_node()\AnzID      = @anz_skybox 
                           
                           Case #anz_art_Waypoint
                              
                              anz_Examined_node()\nodeID     = *p_obj\id 
                              anz_Examined_node()\AnzID      = *p_obj\id  ; beides gleich, da wayopints keine 3d-körper haben.
                              
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
                  If anz_obj_cam_dist  > max_distance And Not max_distance = #anz_any   ; damit nicht alle, sondern nur die objekte inderr Nähe überprüft werden.
                     Continue 
                  EndIf 
                  
                  If AddElement       ( anz_Examined_node())
                     anz_Examined_node()\Object3dID = *p_obj 
                     anz_Examined_node()\nodeart    = ObjectArt 
                     
                     If ToSearch_Object_art = ObjectArt Or ToSearch_Object_art = -1
                     
                      Select ObjectArt 
                        
                        Case #anz_art_billboard
                           
                             *anz_billboard                 =  *p_obj\id
                             anz_Examined_node()\nodeID     = *anz_billboard \id
                             anz_Examined_node()\AnzID      = *anz_billboard   
                     
                          Case #anz_art_lensflare
                             
                             *anz_lensflare                 = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_lensflare \id 
                             anz_Examined_node()\AnzID      = *anz_lensflare
                            
                           Case #anz_art_light
                           
                             *anz_light                     = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_light \nodeID 
                             anz_Examined_node()\AnzID      = *anz_light
                           
                           Case #anz_art_mesh
                        
                             *anz_mesh                      = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_mesh \nodeID 
                             anz_Examined_node()\AnzID      = *anz_mesh
                            
                           Case #anz_art_particle 
                           
                             *anz_particle                  = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_particle \nodeID 
                             anz_Examined_node()\AnzID      = *anz_particle
                           
                           Case #anz_art_sound3d
                           
                             *anz_sound3d                   = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_sound3d \id 
                             anz_Examined_node()\AnzID      = *anz_sound3d
                           
                           Case #anz_art_terrain
                           
                             *anz_terrain                   = *p_obj\id 
                             anz_Examined_node()\nodeID     = *anz_terrain \nodeID 
                             anz_Examined_node()\AnzID      = *anz_terrain
                           
                           Case #anz_art_skybox
                              
                              anz_Examined_node()\nodeID     = anz_skybox\nodeID 
                              anz_Examined_node()\AnzID      = @anz_skybox 
                           
                           Case #anz_art_Waypoint
                              
                              anz_Examined_node()\nodeID     = *p_obj\id 
                              anz_Examined_node()\AnzID      = *p_obj\id  ; beides gleich, da wayopints keine 3d-körper haben.
                              
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
         iFreeNode(  anz_skybox\nodeID )
      EndIf 
      anz_skybox\nodeID = iCreateSkybox( iLoadTexture(texture_up) , iLoadTexture ( texture_down), iLoadTexture ( texture_left) , iLoadTexture (texture_right ) , iLoadTexture( texture_front) , iLoadTexture ( texture_back ))
      Debug "Create skybox: " + Str(anz_skybox\nodeID )
      ProcedureReturn anz_skybox\nodeID 
      
   EndProcedure 
   
   Procedure anz_ende  (    ) ; beendet das ganze, ohne jegliches Speichern!!! nicht fürn hausgebraucht"!
      Delay            ( 10 )  ; warten, um error zu vermeiden.
      iFreeEngine      (    )
      Delay            ( 10 )
      IrrKlangStop     (    ) ; 3d klang bleibt von thalius wrapper. (genauso wie xml)
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
   
   Procedure anz_error(text.s , isIrrlichtRunning = 0) ; wenn irrlicht nicht mehr läuft kommt die Fehlermeldung als 
      If isIrrlichtRunning = 0
         ; *element.i = IrrGuiAddMessageBox(#programmname+ " Fehler:" , text )
         MessageRequester( #programmname + "fehler" , text , #MB_ICONINFORMATION)
      Else 
         MessageRequester( #programmname + "fehler" , text , #MB_ICONINFORMATION)
      EndIf 
   EndProcedure 
   
   Procedure anz_pauseGame(Pausenart , Activate = 1)  ; Pausenart = Warum pause gemacht wird (z.b. #anz_pause_gui für inventar etc.)
   
     If Activate 
        anz_pause | Pausenart ; pause an -> Bit setzen.
     Else 
        anz_pause = anz_pause & ~Pausenart ; löschen des pausenbits -> pause aus
     EndIf 
     
   EndProcedure 
   
   Procedure anz_IsPauseGame()
      ProcedureReturn anz_pause 
   EndProcedure 
   
   Procedure.f anz_getObjectScreenHeight ( x.f,y.f,z.f, ObjectHeight.f )
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected distance.f ,pos.IRR_VECTOR 
        iNodePosition                  ( anz_camera        , @pos )
        distance                       = math_distance3d   ( x,y,z,pos\x ,pos\y ,pos\z )      ; versuch mit center statt koordinaten.
       
      ProcedureReturn ObjectHeight     / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
   
   Procedure.f anz_getObjectScreenWidth ( x.f,y.f,z.f, Objectwidth.f )
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected distance.f , pos.IRR_VECTOR 
        iNodePosition          ( anz_camera        , @pos )
        distance                    = math_distance3d   ( x,y,z,pos\x ,pos\y ,pos\z )      ; versuch mit center statt koordinaten.
        
      ProcedureReturn Objectwidth   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
 
   Procedure.f anz_getObjectScreenDepth ( x.f,y.f,z.f, ObjectDepth.f )
      
      ; formel:    height = Figurheight / Figur-Cam Abstand * 133  
      ; bei ungefahr 133-abstand von Oberfläche und Objekt ist die objektgröße mit der Pixel-bildschirmgröße identisch. 
      ;(mit Lineal gemessen; [faktor von 35.71 Pixel pro CM])
      Protected distance.f , pos.IRR_VECTOR 
        
        iNodePosition               ( anz_camera        , @pos)
        distance                    = math_distance3d   ( x,y,z,pos\x ,pos\y ,pos\z )      ; versuch mit center statt koordinaten.
        
      ProcedureReturn ObjectDepth   / distance * 133 ; 133 wegen siehe anfang der Procedure
      
   EndProcedure 
   
   Procedure.w anz_MouseWheelDelta() ; returns the mousewheelvalue.
     x.w = ((EventwParam()>>16)&$FFFF) 
     ProcedureReturn -(x / 120) 
   EndProcedure 
   ; meshes bearbeiten
   
   Procedure anz_getBoneNodeID (*p_anz_mesh.anz_mesh , bonename.s )
      
      ProcedureReturn iAnimationJointNodebyName  ( *p_anz_mesh\nodeID , bonename ) ; heißt bei n3xtd "bone" nicht joint ;) 

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
                  iparentnode             ( anz_getBoneNodeID      ( *Object3dID\id             , ParentID_IS_BONE) , anz_getObject3DIrrNode ( *Object3dID_child   ))
               Else 
                  iparentnode             ( anz_getObject3DIrrNode ( *Object3dID      )         , anz_getObject3DIrrNode ( *Object3dID_child   ))
               EndIf 
            EndIf 
               
               anz_setobjectPos        ( *Object3dID_child , x , y , z)  
               *Object3dID_child       \ ParentID         = *Object3dID 
               *Object3dID_child       \ ParentID_IS_BONE = ParentID_IS_BONE   ; wenn nur ein Knochen von Object3dID das Parentnode sein soll, ist ParentID_IS_BONE > ""
               *Object3dID             \ child [n]        = *Object3dID_child  ; falls dann nämlich Parent gelöscht wird, MUSS der Link vom Child zum Parent ebenfalls gelöschtwerden, wenn nicht gleich die ganze child/parent kette (im Falle eines Wesens)
               *Object3dID             \ anzahl_children   + 1
               
               
            ProcedureReturn 1
         EndIf 
         
      Next 
      
   EndProcedure 
   
   ; Objects 3D bearbeiten
   
   Procedure anz_getMeshPosition( *anz_mesh.anz_mesh ,*px.i , *py.i , *pz.i ) ; @x , @y , @z!! if = 0 -> ignored.
      Protected *obj3d.anz_Object3d ,x1.f,y1.f,z1.f , vector.ivector3 
      
      If *anz_mesh = 0
         ProcedureReturn 0
      EndIf 
      
      If *anz_mesh\nodeID > 0 And *anz_mesh\geladen = 1
         
         iNodePosition  ( *anz_mesh\nodeID , @vector ) ; @x1 , @y1 , @z1 )
         
         If *px > 0
            PokeF ( *px , vector\x )
         EndIf 
         If *py > 0
            PokeF ( *py , vector\y )
         EndIf 
         If *pz > 0
            PokeF ( *pz , vector\z )
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
      Protected *anz_billboard.anz_billboard , *anz_light.anz_light , *anz_particle.anz_particle , *anz_sound3d.anz_sound3d , *anz_terrain.anz_terrain , *anz_mesh.anz_mesh , *anz_lensflare.anz_lensflare 
      If *p_anz_Object3D = 0
         ProcedureReturn 0
      EndIf 
      
      Select *p_anz_Object3D\art 
      
         Case #anz_art_billboard
            
             *anz_billboard = *p_anz_Object3D\id 
            ProcedureReturn *anz_billboard   \id 
            
         Case #anz_art_lensflare
            
            *anz_lensflare  = *p_anz_Object3D\id 
            ProcedureReturn *anz_lensflare   \id 
            
         Case #anz_art_light
            
            *anz_light      = *p_anz_Object3D\id
            ProcedureReturn *anz_light       \nodeID 
            
         Case #anz_art_mesh
         
            *anz_mesh      = *p_anz_Object3D\id
            ProcedureReturn *anz_mesh\nodeID 
            
         Case #anz_art_particle
            
            *anz_particle    = *p_anz_Object3D\id
            ProcedureReturn *anz_particle     \nodeID 
            
         Case #anz_art_skybox
            
            ProcedureReturn anz_skybox\nodeID  ; keine liste.. es gibt nur eine skybox.
           
         Case #anz_art_sound3d
            
            *anz_sound3d    =  *p_anz_Object3D\id 
            ProcedureReturn *anz_sound3d      \id 
            
         Case #anz_art_terrain
            
            *anz_terrain   = *p_anz_Object3D \id
            ProcedureReturn *anz_terrain     \nodeID 
         
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
      Protected x.i , y.i , z.i , x1.i , y1.i , z1.i , px.f , py.f , pz.f , nx.f , ny.f , nz.f , nodepos.ivector3 , newnodepos.ivector3 
      
      ; obacht, es kann sein, dass daas Node ja hängenbleibt. in dem Fall darf man es nicht in den nächsten Rasterblock rüberwerfen.
      If anz_getobject3dIsGeladen( *Object3dID)
         ; werte direkt von Irrlicht holen
         *irrNode          = anz_getObject3DIrrNode(*Object3dID)
         iNodePosition     ( *irrNode , @nodepos);@px , @py , @pz )
         If Posx = #anz_any : Posx = nodepos\x : EndIf 
         If Posy = #anz_any : Posy = nodepos\y : EndIf  
         If Posz = #anz_any : Posz = nodepos\z : EndIf 
         iPositionNode     ( *irrNode , Posx , Posy , Posz )
         iNodePosition     ( *irrNode , @newnodepos); @nx , @ny , @nz )
         px = nodepos\x
         py = nodepos\y
         pz = nodepos\z
         nx = newnodepos\x
         ny = newnodepos\y
         nz = newnodepos\z
         
      Else  
         ; wenn Objekt nicht da, Werte von Referenzen holen.
         px = *Object3dID\x
         py = *Object3dID\y
         pz = *Object3dID\z
         If Posx = #anz_any : Posx = px : EndIf 
         If Posy = #anz_any : Posy = py : EndIf 
         If Posz = #anz_any : Posz = pz : EndIf 
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
      Protected x.f, y.f, z.f , *anz_mesh.anz_mesh , Rotation.ivector3 
      
      If Not *Object3dID\art = #anz_art_mesh 
         ProcedureReturn 0
      EndIf 
      
      *anz_mesh = *Object3dID\id 
      
      If anz_getobject3dIsGeladen( *Object3dID)
         ; werte direkt von Irrlicht holen
         *irrNode          = anz_getObject3DIrrNode(*Object3dID)
         If *irrNode 
            inoderotation  ( *irrNode , @Rotation ) ; @x , @y , @z)
            x              = Rotation\x 
            y              = Rotation\y 
            z              = Rotation\z 
         EndIf 
      Else 
         x                 = *anz_mesh \rotx 
         y                 = *anz_mesh \roty
         z                 = *anz_mesh \rotz
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
         iRotateNode              ( anz_getObject3DIrrNode(*Object3dID) , x , y , z ) ; auf irrlict-ebene aktualisieren
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
         *irrNode                = anz_getObject3DIrrNode(*Object3dID)
         Debug 1096
         E3D_getNodePosition     ( *irrNode , @px , @py , @pz ) ; startposition
         iMoveNode               ( *irrNode , Forward , right , up )
         E3D_getNodePosition     ( *irrNode , @nx , @ny , @nz ) ; endposition für start-endraster berechnung, um zu sehen, ob raster wechselt.
         *Object3dID\x           = px      ; die alte position festlegen.
         *Object3dID\y           = py  
         *Object3dID\z           = pz  
      Else  
         ; wenn Objekt nicht da  , Werte von Referenzen holen.
         If *Object3dID\art      = #anz_art_mesh ; rotscale wird nur bei meshes gespeichert
            *anz_mesh            = *Object3dID\id 
            Rot\x                = *anz_mesh\rotx 
            Rot\y                = *anz_mesh\roty 
            Rot\z                = *anz_mesh\rotz  ; ansonsten wird von einer 0-rotation ausgegangen. 
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
         iScaleNode( *anz_mesh\nodeID , scalex , scaley , scalez) ; scalieren, wenn geladen
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
      
      
      ; prüfen, obs nicht eh schon genau den gewünschten Wert schon hat.
      If Not ( *p_particle\current_max_paritlcles_per_second = max_particles_per_second And *p_particle\current_min_paritlcles_per_second = min_particles_per_second)
      
         iMinPerSecondParticle ( *p_particle\nodeID , min_particles_per_second )
         iMaxPerSecondParticle ( *p_particle\nodeID , max_particles_per_second )
     
      EndIf 
      
      ProcedureReturn *p_particle\nodeID
   EndProcedure 
   
   Procedure anz_particle_changeflags ( *p_particle.anz_particle , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = #anz_any , particleheight.f = #anz_any, max_angle_degrees.f = #anz_any, min_lifetime.i = #anz_any , max_lifetime.i = #anz_any , If_IsRingThickness.f =#anz_any) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
      ; verändert die Flags nur im irrlicht-system
      
      Protected SmokeEmitter.IRR_PARTICLE_EMITTER
   
      ;{ width/height der partikel setzen
   
      If Not particlewidth = #anz_any   ; breite wird neu gesetzt
         If Not particleheight = #anz_any  ; auch höhe wird neu gesetzt
            iMinStartSizeParticle( *p_particle\nodeID , particlewidth , particleheight )
            iMaxStartSizeParticle( *p_particle\nodeID , particlewidth , particleheight )
            *p_particle\particlewidth  = particlewidth 
            *p_particle\particleheight = particleheight 
         Else          ; höhe wird nicht geändert
            iMinStartSizeParticle( *p_particle\nodeID , particlewidth , *p_particle\particleheight )
            iMaxStartSizeParticle( *p_particle\nodeID , particlewidth , *p_particle\particleheight )
            *p_particle\particlewidth = particlewidth 
         EndIf 
      Else ; breite wird nicht verändert
         If Not particleheight = #anz_any  ; aber höhe wird neu gesetzt
            iMinStartSizeParticle( *p_particle\nodeID , *p_particle\particlewidth , particleheight )
            iMaxStartSizeParticle( *p_particle\nodeID , *p_particle\particlewidth , particleheight )
            *p_particle\particleheight = particleheight 
         Else          ; höhe wird nicht geändert
             ; nichts wird verändert
         EndIf 
      EndIf 
   
   ;}
      
      ;{ setzen der smokeEmitter- structur ( also farbe, refreshrate usw. des partikels
      
      ; direction neu setzen...
      If Not direction_x = #anz_any   ; wert wird verändert..
         *p_particle\nodestruct\direction_x  = direction_x 
      EndIf 
      If Not direction_y = #anz_any
         *p_particle\nodestruct\direction_y = direction_y 
      EndIf 
      If Not direction_z = #anz_any
         *p_particle\nodestruct\direction_z  = direction_z 
      EndIf 

      ; particles per second..
      If Not min_particles_per_second = #anz_any     
         *p_particle\nodestruct\min_particles_per_second = min_particles_per_second 
      EndIf 
      If Not max_particles_per_second = #anz_any             
         *p_particle\nodestruct\max_particles_per_second  = max_particles_per_second  
      EndIf  
      
      ; angle degrees
      If Not max_angle_degrees = #anz_any 
         *p_particle\nodestruct\max_angle_degrees  = max_angle_degrees
      EndIf  
      ; lifetime
      If Not min_lifetime = #anz_any 
         *p_particle\nodestruct\min_lifetime       = min_lifetime 
      EndIf  
      If Not max_lifetime = #anz_any 
         *p_particle\nodestruct\max_lifetime       = max_lifetime 
      EndIf  
      
      ;}
      
      ;{ neuen Emitter setzen
     
      ; direction:
      iDirectionParticle       ( *p_particle\nodeID , *p_particle\nodestruct\direction_x , *p_particle\nodestruct\direction_y , *p_particle\nodestruct\direction_z )
      ; part. per second
      iMinPerSecondParticle    ( *p_particle\nodeID , *p_particle\nodestruct\min_particles_per_second)
      iMaxPerSecondParticle    ( *p_particle\nodeID , *p_particle\nodestruct\max_particles_per_second)
      ;angle degrees kann man nicht mehr ändern.. evtl später..
      ; lifetime
      
      If Not max_angle_degrees = #anz_any Or Not min_lifetime = #anz_any Or Not max_lifetime = #anz_any 
         If *p_particle\art = #anz_particle_art_default 
            *em = iCreateParticleBoxEmitter ( *p_particle\nodeID , *p_particle\nodestruct\direction_x , *p_particle\nodestruct\direction_y , *p_particle\nodestruct\direction_z , *p_particle\nodestruct\min_particles_per_second , *p_particle\nodestruct\max_particles_per_second , RGB(*p_particle\nodestruct\min_start_color_red , *p_particle\nodestruct\min_start_color_green , *p_particle\nodestruct\min_start_color_blue) , RGB( *p_particle\nodestruct\max_start_color_red , *p_particle\nodestruct\max_start_color_green , *p_particle\nodestruct\max_start_color_blue) , *p_particle\nodestruct\min_lifetime , *p_particle\nodestruct\max_lifetime , *p_particle\nodestruct\max_angle_degrees )
         ElseIf *p_particle\art = #anz_particle_art_sphere 
            *em =  iCreateParticleSphereEmitter(*p_particle\nodeID ,0,0,0,Size , *p_particle\nodestruct\direction_x , *p_particle\nodestruct\direction_y , *p_particle\nodestruct\direction_z , *p_particle\nodestruct\min_particles_per_second , *p_particle\nodestruct\max_particles_per_second , RGB(*p_particle\nodestruct\min_start_color_red , *p_particle\nodestruct\min_start_color_green , *p_particle\nodestruct\min_start_color_blue) , RGB( *p_particle\nodestruct\max_start_color_red , *p_particle\nodestruct\max_start_color_green , *p_particle\nodestruct\max_start_color_blue) , *p_particle\nodestruct\min_lifetime , *p_particle\nodestruct\max_lifetime , *p_particle\nodestruct\max_angle_degrees )
         ElseIf *p_particle\art = #anz_particle_art_ring 
            iSendLog ( "Error: anz_particle_art_ring gibts bei n3xtd nicht mehr.. stattdessen wird sphere emitter gemacht (ca. line 1256 anz_anzeige.pb")
            *em =  iCreateParticleSphereEmitter(*p_particle\nodeID ,0,0,0,Size , *p_particle\nodestruct\direction_x , *p_particle\nodestruct\direction_y , *p_particle\nodestruct\direction_z , *p_particle\nodestruct\min_particles_per_second , *p_particle\nodestruct\max_particles_per_second , RGB(*p_particle\nodestruct\min_start_color_red , *p_particle\nodestruct\min_start_color_green , *p_particle\nodestruct\min_start_color_blue) , RGB( *p_particle\nodestruct\max_start_color_red , *p_particle\nodestruct\max_start_color_green , *p_particle\nodestruct\max_start_color_blue) , *p_particle\nodestruct\min_lifetime , *p_particle\nodestruct\max_lifetime , *p_particle\nodestruct\max_angle_degrees )
         EndIf 
      EndIf 
      
      ;}
    
      ; fade out, gravity -affektors sind alle noch aktiv, werden also nicht gelöscht, wenn emitter aktualisiert wird.
      
  ProcedureReturn *p_particle\nodeID 
  
  EndProcedure 
  
   ; Anzeige Settings von Preferences
   
   Procedure anz_setresolution(x,y,Depth,ISNeustart=1)
      
      anz_resolutionx     = x    ; die globale variablen setzen
      anz_resolutiony     = y 
      anz_resolutiondepth = Depth
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
   
   Procedure anz_enable_shadow( enable.i)
      Protected *anz_mesh.anz_mesh 
      
      ; SCHAtten ausschalten 
      If anz_IsShadowEnabled() And Not enable 
         anz_ExamineLoadedNodes ( #anz_art_mesh , 1 , #anz_any ) 
         While anz_NextExaminedNode()
            *anz_mesh = anz_ExaminedNodeAnzID()
            If *anz_mesh\geladen 
               iRemoveShadowNodeXEffect( anz_ExaminedNodeIrrID())
            EndIf 
         Wend 
               
      EndIf 
       
       ; schatten einschalten
      If enable
          anz_ExamineLoadedNodes( #anz_art_mesh  , 1 , #anz_any  ); setzt nur bei den inview-objekten den schatten.. der rest kriegts ja beim laden mit ;) 
          While anz_NextExaminedNode()
          
              *anz_mesh =  anz_ExaminedNodeAnzID()
              If *anz_mesh\geladen 
                 iAddShadowToNodeXEffect(anz_ExaminedNodeIrrID() , #EFT_NONE,  #ESM_BOTH)
              EndIf 
              
          Wend 
      EndIf 
      
      anz_isshadow = enable
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
      ProcedureReturn  9.81 / 3600 * #meter ; (Meter pro Sekunde Hoch 2.. 1 Sekunde = 60 fps; sekunde² = 60fps² = 3600 fps etwa)
   EndProcedure 
 
   ; Image management -- complete ;)
   
   Procedure anz_loadimage( NR.i, x.f , y.f , pfad.s, Usealpha.b= 1, ishidden.b = 1 , rectX.f = 0 , rectY.f = 0 , rectwidth.f = -1 , Rectheight.f = -1) ; gibt immer die NR des images heraus! keinen Pointer.
      Protected anz_image_NotFound.i  , width.i , height.i, *anz_texture.anz_texture
      Static    ZufallsNR.i 
      
      ; use list image.image() 
       *anz_texture = anz_loadtexture ( pfad,0) ; id = anz_textureid, nicht irr-textureid!!!!!
       
       If *anz_texture 
       
           If NR = -1 ; wenn der Benutzer sich seine NR selbst festlegen will..
              ZufallsNR + 1
              NR = ZufallsNR 
           Else 
              If ZufallsNR < NR ; sobald der benutzer eine NR festlegt, die größer ist, als die aktuelle zufallsNR, 
                 ZufallsNR = NR ; so wird die zufallsNR genauso groß wie die NR. dadurch wird das nächste ZufallsNR NACH dem vom benutzer festgelegten NR-bild gesetzt.
              EndIf 
           EndIf 
           itexturesize( *anz_texture\id , @width , @height ); größe der textur ermitteln zum späteren richrigen anzeigen.
           LastElement( anz_image ())
           AddElement ( anz_image ())
             anz_image()\x        = x
             anz_image()\y        = y
             anz_image()\width    = width
             anz_image()\height   = height
             anz_image()\Alpha    = Usealpha
             anz_image()\NR       = NR
             anz_image()\id       = *anz_texture
             anz_image()\ishidden = ishidden 
             anz_hideimage        ( NR , ishidden )
             anz_SetImageRect     ( NR , rectX , rectY , rectwidth , Rectheight )
             ProcedureReturn NR
             
       Else 
       
          ;{ wenn nicht geladen,dann Standard texture laden.
          
          anz_loadimage ( NR , x , y , #pfad_texture_standard , Usealpha , ishidden )
          
          ;}
          
       EndIf 
      
   EndProcedure 
   
   Procedure anz_SetImageRect ( NR.i , rectX.f , rectY.f , width.f, height.f ) ; bild wird zugeschnitten und nur ein teil davon angezeigt. wenn width/height = -1, wird das jeweilige teil ignoriert.
       Protected *anz_image.anz_image , imgwidth.l , imgheight.l
       
       *anz_image           = anz_getimageID ( NR ) 
       If *anz_image        = 0 : ProcedureReturn : EndIf 
       If width             > -1 ; falls breite nicht verändert werden soll..
          *anz_image\width  = width
       EndIf 
       If height            > -1 ; falls höhe nicht verändert werden soll. 
          *anz_image\height = height 
       EndIf 
       *anz_image\rectX     = rectX
       *anz_image\rectY     = rectY
       
       ProcedureReturn *anz_image 
   EndProcedure 
   
   Procedure anz_RemoveImageRect ( NR.i ); bild wird wieder komplett angezeigt ( nicht mehr zugeschnitten)
      Protected *anz_image.anz_image , width.l , height.l 
       
       *anz_image           = anz_getimageID ( NR ) 
       If *anz_image        = 0 : ProcedureReturn : EndIf 
       itexturesize         ( anz_GetTextureIrrID( *anz_image\id) , @width , @height )
       *anz_image\width     = width
       *anz_image\height    = height 
       *anz_image\rectX     = 0
       *anz_image\rectY     = 0
       
       ProcedureReturn *anz_image 
   EndProcedure 
   
   Procedure anz_setImageForeground ( NR.i )
      Protected *foregroundImg.i 
      
      If ListSize( anz_image())             ; sind überhaupt elemente vorhanden..
      
         If Not anz_image()\NR = NR         ; schaut, ob's aktuelle bild das gesuchte ist.
         
            ResetList( anz_image())         ; ansonsten wird gesucht..
            
               While NextElement(anz_image())
                  If anz_image()\NR = NR
                     *foregroundImg = anz_image()
                     Start          = ListIndex( anz_image()) +1
                     Listende       = ListSize ( anz_image ())-1
                     
                     For x = Start To Listende 
                        *nextimg       = NextElement (anz_image())
                        SwapElements ( anz_image() , *foregroundImg , *nextimg )
                        *foregroundImg = NextElement ( anz_image())
                     Next 
                  EndIf 
               Wend 
            
         Else 
                     *foregroundImg = anz_image()
                     Start          = ListIndex( anz_image()) +1
                     Listende       = ListSize ( anz_image ()) 
                     
                     For x = Start To Listende 
                        *nextimg       = NextElement (anz_image())
                        If Not *nextimg : Break : EndIf 
                        SwapElements ( anz_image() , *foregroundImg , *nextimg )
                        *foregroundImg = NextElement ( anz_image())
                     Next 
         EndIf 
         
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
                     ProcedureReturn anz_image()
                  EndIf 
               Wend 
            
         Else 
            anz_image()\x = x
            anz_image()\y = y 
            ProcedureReturn anz_image()
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
                      anz_freetexture( anz_image()\id ) ; löschen der Textur (id = anz_textureid)
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
      If Not *anz_image : ProcedureReturn : EndIf 
      ProcedureReturn *anz_image\ishidden 
      
   EndProcedure
   
   Procedure anz_getimageNRbyID( id.i) ; gibt die NR des images anhand des anz_texture Pointers heraus.
      
      ResetList( anz_image())
         While NextElement ( anz_image())
            If anz_image()\id = id 
               ProcedureReturn anz_image()\NR 
            EndIf  
         Wend 
         
   EndProcedure 
   
   ; texture management 
   
   Procedure anz_loadtexture( pfad.s ,returnIrrID = 0)  ; wenn 2*die gleiche textur: zähler mitlaufen lassen. beim löschen wird erst wenn zähler wieder = 0 , wird die textur gelöscht
      Protected *anz_texture.anz_texture 
      If pfad = ""
         ProcedureReturn 
      EndIf 
      
      *anz_texture = AddElement ( anz_texture()) 
         If *anz_texture 
            *anz_texture\pfad = pfad 
            *anz_texture\id = iLoadTexture( pfad)
            If *anz_texture\id = 0
               *anz_texture\id = iLoadTexture ( #pfad_texture_standard )
               If *anz_texture\id = 0
                  DeleteElement ( anz_texture())
                  ProcedureReturn 0 
               EndIf 
            EndIf 
            *anz_texture\counter = 1
            If returnIrrID = 0 ; return anz_texture ID.
               ProcedureReturn *anz_texture  ; der gesamte ifreetexture-befehl causes the game to crash!! o.O
            Else ; dann irrid returnen
               ProcedureReturn *anz_texture\id 
            EndIf 
         EndIf 
         
      
      ; ResetList( anz_texture() )
      ; ; ProcedureReturn iLoadTexture( pfad )
      ; While NextElement ( anz_texture() )
         ; If anz_texture()\pfad           = pfad 
            ; anz_texture()\Counter        + 1
            ; ProcedureReturn anz_texture()\id 
         ; EndIf 
      ; Wend 
      ; 
      ; ; wenns allerdings nicht geladen wurde:
      ; 
      ; 
      ; If AddElement ( anz_texture())
         ; anz_texture()\pfad    = pfad 
         ; anz_texture()\id      = iLoadTexture( pfad )
         ; anz_texture()\Counter = 1
         ; 
         ; If anz_texture()\id  = 0 ; textur konnte nicht geladen werden.... 
            ; 
            ; anz_texture          ()\id      = anz_loadtexture (#pfad_texture_standard)
            ; If Not anz_texture   ()\id 
               ; DeleteElement     ( anz_texture() )
               ; ProcedureReturn 
            ; EndIf 
         ; EndIf 
         ; 
         ; ProcedureReturn anz_texture()\id 
      ; 
      ; EndIf 
   EndProcedure 
   
   Procedure anz_GetTextureIrrID ( *anz_texture.anz_texture ) ; gibt die IrrID der textur aus.
      If *anz_texture > 0 
         ProcedureReturn *anz_texture\id 
      EndIf 
   EndProcedure 
   
   Procedure anz_gettexturebypfad( pfad.s) ; gibt textureID raus! nicht irrlicht texture.
      
      ResetList (anz_texture())
         
         While NextElement( anz_texture())
            
            If anz_texture()\pfad = pfad 
               ProcedureReturn anz_texture()
            EndIf 
         
         Wend 
         
         ProcedureReturn 0 ; wenns nicht gefunden wurde.
         
   EndProcedure 
   
   Procedure anz_GetAnzTextureByIrrTexture ( Irrtexture ) 
      
      ForEach anz_texture()
         If anz_texture()\id = Irrtexture 
            ProcedureReturn anz_texture ()
         EndIf 
      Next 
      
   EndProcedure 
   
   Procedure anz_freetexture (*anz_texture.anz_texture )  ; erst wenn der zähler wieder auf 0 ist wird Textur gelöscht.
      
      If *anz_texture = 0 : ProcedureReturn : EndIf 
     
      ; ifreetexture   ( *anz_texture\id  ) ; Ifreetexture CAUSES CRASH!!!!! FFFF...
      
      ChangeCurrentElement( anz_texture () , *anz_texture )
      DeleteElement ( anz_texture () )
      
      ProcedureReturn 1 
      
      ; ResetList( anz_texture())
         ; 
         ; While NextElement( anz_texture())
            ; 
            ; If anz_texture    ()\id = IrrTextureID
               ; anz_texture    ()\counter - 1 ; ein material weniger braucht diese Textur.
               ; If anz_texture ()\counter = 0
                  ; ifreetexture   ( anz_texture()\id ) ; texture erst löschen, wenn alles weg ist.
                  ; DeleteElement ( anz_texture())
                  ; ; löschen
               ; EndIf 
               ; ProcedureReturn 1 ; konnte gelöscht werden
            ; EndIf 
         ; Wend 
         ; 
         ; ProcedureReturn 0 ; wenns nicht gelöscht werden konnnte
      
   EndProcedure 
   
   ; load things 
   
   Procedure anz_addmesh( pfad.s, x.f,y.f,z.f, texture.s , MaterialType.b , normalmap.s , DirectLoad.b = 0 , IsAnimMesh.i = 0, Collisiondetail.b = #anz_col_box , Collisiontype.b = #anz_ColType_solid , rotx.f=0,roty.f=0,rotz.f=0,scalx.f=1,scaly.f=1,scalz.f=1, islighting.i = 0 , width.f = #meter * 3 , height.f = #meter*4 , Depth.f = #meter * 3)
      Protected currentlistenobject.i , *anz_mesh.anz_mesh , currentobj3d.i
      Protected x1.f , y1.f, z1.f , x2.f , y2.f , z2.f
      
      If ListSize                      ( anz_mesh ()) > 0
         currentlistenobject           = anz_mesh()
         LastElement                   ( anz_mesh()) ; sonst invalid memory access..???!!!! argh ihr macht mich fertig..
      EndIf 
      If ListSize                      ( anz_Object3d() ) > 0
        currentobj3d                   = anz_Object3d()
      EndIf 
      
      ; schaun, ob pfad ladbar, texturen etc da sind.
      
         If ReadFile     ( 0 , pfad ) = 0 ; mesh prüfen
            pfad         = #pfad_meter 
            scalx       = 1 ; damit man das überhaupt erkennt und keinen rießen würfel da hat o.O
            scaly       = 1 
            scalz       = 1 
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
                  \Depth                = Depth
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
                  \anim_IsAnimMesh      = IsAnimMesh 
                  
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
      If currentobj3d > 0
         ChangeCurrentElement( anz_Object3d () , currentobj3d )
      EndIf 
      
      ProcedureReturn *anz_mesh   ; man kann also mit changecurrentelement ( anz_mesh() , anz_addmesh(..) ) aufs aktuelle anz_mesh wechseln, oder gleich *anz_mesh.anz_mesh = anz_addmesh(...)
      
   EndProcedure 
   
   Procedure anz_AddBillboard( pfad.s, x.f,y.f,z.f , width.f , height.f , MaterialType.i = #IRR_EMT_TRANSPARENT_ADD_COLOR , DirectLoad.i = 0)
       
      Protected currentlistenobject.i , newbillboard.i , *anz_billboard.anz_billboard , irr_obj.i , *anz_object3d.anz_Object3d , currentobj3d.i
      
      If ListSize ( anz_billboard() ) > 0
         currentlistenobject = @anz_billboard()
      EndIf 
      If ListSize (anz_Object3d() ) > 0
         currentobj3d       = @anz_Object3d()
      EndIf 
      
         *anz_billboard = AddElement( anz_billboard())
               
            If *anz_billboard
               *anz_billboard\id                   = 0
               *anz_billboard\irr_emt_materialtype = MaterialType 
               *anz_billboard\width                = width
               *anz_billboard\height               = height 
               *anz_billboard\pfad                 = pfad 
               *anz_billboard\lighting             = 0
            Else 
               ProcedureReturn 0
            EndIf 
            
         *anz_object3d = AddElement( anz_Object3d() )
            
            If *anz_object3d 
               *anz_object3d\id = *anz_billboard 
               *anz_object3d\art = #anz_art_billboard
               *anz_object3d\x   = x
               *anz_object3d\y   = y
               *anz_object3d\z   = z
               *anz_billboard\Object3dID = *anz_object3d  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
            Else 
               DeleteElement ( anz_billboard () )
               ProcedureReturn 0
            EndIf
            
          ; directes laden, wenn gleich geladen werden soll / muss.
          If DirectLoad > 0
               irr_obj  = iCreateBillboard      ( *anz_billboard\width , *anz_billboard\height ) ; p_obj ist das anz_objekt3d().
               iPositionNode                    ( irr_obj , x , y , z)
               If irr_obj
                  *anz_billboard\id             = irr_obj
                  ; material setzen
                     iMaterialTextureNode       ( irr_obj , anz_loadtexture( *anz_billboard\pfad , 1) , 0)   ; ---- Pause .. hier muss später noch ein multimaterialsystem rein. für multitextures.. wenn möglich.
                     iMaterialTypeNode          ( irr_obj , *anz_billboard\irr_emt_materialtype )
                     iMaterialFlagNode          ( irr_obj , #IRR_EMF_LIGHTING , *anz_billboard\lighting )

               EndIf 
                                 
          EndIf 
          
      anz_Raster_Register     ( anz_Object3d()) ; ins Raster registrieren
      If currentlistenobject  > 0
         ChangeCurrentElement ( anz_billboard() , currentlistenobject )
      EndIf 
      If currentobj3d         > 0
         ChangeCurrentElement ( anz_Object3d () , currentobj3d  )
      EndIf 
      
      ProcedureReturn *anz_billboard
      
   EndProcedure 
   
   Procedure anz_addlight( RGBcolor.i, x.f,y.f,z.f, range.f )
      
      Protected currentlistenobject.i , *anz_light.anz_light 
      
      If ListSize ( anz_light () ) > 0
         currentlistenobject        = @anz_light()
      EndIf 
      
         AddElement( anz_light())
            
            *anz_light              = anz_light()
               
               *anz_light\nodeID    = iCreateLight ( range) 
               iPositionNode        ( *anz_light\nodeID , x , y , z )
               iAmbientColorLight   ( *anz_light\nodeID , RGBcolor )

         AddElement( anz_Object3d   () )
            
            With anz_Object3d()
               
               \id  = *anz_light
               \art = #anz_art_light
               \x   = x
               \y   = y
               \z   = z
               *anz_light\Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
            EndWith 
            
            ; Set Shadow !!!
            iAddShadowLightXEffect  ( x , y , z ,    -5.0,-1,0  ,$FFFFFF, 1.0, #meter * 8 , 35.0 , 768)
            *anz_light\ShadowID     = iShadowLightXEffectCount  (   )-1  ; die Nummer des schattens. der erste schatten hat NR. 0
            
      anz_Raster_Register           (  anz_Object3d())
      If currentlistenobject        > 0
         ChangeCurrentElement       ( anz_light() , currentlistenobject )
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
   
   Procedure anz_setwater( *p_obj3d.anz_Object3d, waveHeight.f , waveSpeed.f,waveLength.f, MaterialType.i =#IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER)
      Protected *anz_mesh.anz_mesh 
      
      If *p_obj3d\art = #anz_art_mesh  ; *p_obj3d = anz_object3d()
         *anz_mesh    = *p_obj3d\id 
            
            ; - Pause! hier kommt später der Wassershader rein! ;) 
            
            iMaterialTextureNode      (*anz_mesh\nodeID, anz_loadtexture(#pfad_standard_wasser           ,1) , 0)
            iMaterialTextureNode      (*anz_mesh\nodeID, anz_loadtexture(#pfad_standard_wasser_reflexion ,1) , 1)
            iMaterialTypeNode         (*anz_mesh\nodeID, #EMT_TRANSPARENT_REFLECTION_2_LAYER)
            
            If MaterialType 
               iMaterialTypeNode      ( *anz_mesh\nodeID , MaterialType )
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
               
               \nodeID                            = iCreateParticleSystem (0)
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
   
            iMaxStartSizeParticle ( *p_particle\nodeID , particlewidth, particleheight )
            iMinStartSizeParticle ( *p_particle\nodeID , particlewidth, particleheight )
            *p_particle\particlewidth       = particlewidth 
            *p_particle\particleheight      = particleheight 
   
   ;}
      
      ;{ neuen Emitter setzen
      If *p_particle\art = #anz_particle_art_default 
         *em = iCreateParticleBoxEmitter( direction_x , direction_y , direction_z , min_particles_per_second , max_particles_per_second , min_startcolor , max_startcolor , min_lifetime , max_lifetime , max_angle_degrees , particlewidth/2 , particleheight/2 , particlewidth*1.5 , particleheight*1.5 , box_x )
      ElseIf *p_particle\art = #anz_particle_art_sphere 
         *em = iCreateParticleSphereEmitter ( x , y , z , If_IsRingThickness, direction_x , direction_y , direction_z , min_particles_per_second , max_particles_per_second , min_startcolor , max_startcolor , min_lifetime , max_lifetime , max_angle_degrees , particlewidth/2 , particleheight/2 , particlewidth*1.5 , particleheight*1.5 )
      ElseIf *p_particle\art = #anz_particle_art_ring 
             *p_particle\RingThickness = If_IsRingThickness
         *em = iCreateParticleCylinderEmitter ( x,y,z , If_IsRingThickness , 0 , 1 , 0 , #meter , 0 ,  direction_x , direction_y , direction_z , min_particles_per_second , max_particles_per_second , min_startcolor , max_startcolor , min_lifetime , max_lifetime , max_angle_degrees , particlewidth/2 , particleheight/2 , particlewidth*1.5 , particleheight*1.5 )
      EndIf 
      iPositionNode ( *p_particle\nodeID , x , y , z )
      
      ;}
      
      ;{ material setzen
      iMaterialTypeNode ( anz_particle()\nodeID , MaterialType )
      iMaterialFlagNode ( anz_particle()\nodeID , #EMF_LIGHTING , 0)
      If texture > ""
         iMaterialTextureNode ( anz_particle()\nodeID , anz_loadtexture( texture,1),0)
      EndIf 
      If normalmap > ""
         iMaterialTextureNode( anz_particle()\nodeID , anz_loadtexture( normalmap,1),1)
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

          anz_particle()\nodestruct\min_particles_per_second = SmokeEmitter\min_particles_per_second   ; Minimum Spawnrate in Particles/Second
          anz_particle()\nodestruct\max_particles_per_second = SmokeEmitter\max_particles_per_second   ; Maximum Spawnrate in Particles/Second

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
      
      iFadeOutParticleSystem  ( *p_particle\nodeID  )
      
  ProcedureReturn *p_particle\nodeID 
  
  EndProcedure
   
   Procedure anz_addfire (x.f,y.f,z.f, firesize.f = 10, horbarrange = 1000 , texture.s = #pfad_feuer_texture , SoundPfad.s = #pfad_feuer_sound )
   
      Protected feuer
      
      feuer = anz_addparticle       ( x , y , z , texture , "" , #IRR_EMT_TRANSPARENT_ADD_COLOR , #anz_particle_art_default , 0 , 0.3*firesize , 0 , 10 , 10 , 10 , firesize *2 + 10 , firesize * 2.5 + 10 )
      anz_addsound3d                ( SoundPfad , x , y,  z , horbarrange , horbarrange/4)
      
      ProcedureReturn feuer
      
   EndProcedure
   
   Procedure anz_addterrain( pfad.s, x.f,y.f,z.f, texture1.s , texture2.s ,texturescale1.f , texturescale2.f , width.f , height.f , Depth.f , MaterialType.i =#IRR_EMT_DETAIL_MAP , scalx.f=1,scaly.f=1,scalz.f=1, rotx.f=0,roty.f=0,rotz.f=0) ; width, height depth sind die extents.
      
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
               \Depth              = Depth 
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
         anz_staub()\nodeID       = anz_addparticle     ( x ,y , z , #pfad_staub_texture , "" , #EMT_TRANSPARENT_ADD_COLOR , #anz_particle_art_default , 0.03  , 0.02, 0.02 , 10,10,10, 20 , 30 , 30,30,0,0,90,300,500)
         
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
   
   ; Shader Management 
   
			Procedure anz_shader_AddProcessing( name_GL.s, name_DX.s, Value.f)
					; load and create shader
					iVersionShader(#EVST_VS_1_1, #EPST_PS_2_0)
			
					If video = #EDT_DIRECT3D9
							anz_shader_proctest(anz_shader_num_mat)\shad = iCreateShaderHighLevel("gfx/Shader/PP_DX_Vertex.fx","main", name_DX, "main", #EMT_SOLID, @anz_shader_CallbackShader(), #Null)
					Else
							anz_shader_proctest(anz_shader_num_mat)\shad = iCreateShaderHighLevel("GFX/Shader/PP_GL_Vertex.fx","main", name_GL, "main", #EMT_SOLID, @anz_shader_CallbackShader(), #Null)
					EndIf
					
					; surface mesh define
													; define 4 vertices 
					anz_shader_proctest(anz_shader_num_mat)\vv[0]\x = -1  : anz_shader_proctest(anz_shader_num_mat)\vv[0]\y = -1  : anz_shader_proctest(anz_shader_num_mat)\vv[0]\z = 0 : anz_shader_proctest(anz_shader_num_mat)\vv[0]\color = $FF00FFFF : anz_shader_proctest(anz_shader_num_mat)\vv[0]\tu = 0  : anz_shader_proctest(anz_shader_num_mat)\vv[0]\tv = 1
					anz_shader_proctest(anz_shader_num_mat)\vv[1]\x = -1  : anz_shader_proctest(anz_shader_num_mat)\vv[1]\y =  1  : anz_shader_proctest(anz_shader_num_mat)\vv[1]\z = 0 : anz_shader_proctest(anz_shader_num_mat)\vv[1]\color = $FF00FFFF : anz_shader_proctest(anz_shader_num_mat)\vv[1]\tu = 0  : anz_shader_proctest(anz_shader_num_mat)\vv[1]\tv = 0
					anz_shader_proctest(anz_shader_num_mat)\vv[2]\x =  1  : anz_shader_proctest(anz_shader_num_mat)\vv[2]\y =  1  : anz_shader_proctest(anz_shader_num_mat)\vv[2]\z = 0 : anz_shader_proctest(anz_shader_num_mat)\vv[2]\color = $FF00FFFF : anz_shader_proctest(anz_shader_num_mat)\vv[2]\tu = 1  : anz_shader_proctest(anz_shader_num_mat)\vv[2]\tv = 0
					anz_shader_proctest(anz_shader_num_mat)\vv[3]\x =  1  : anz_shader_proctest(anz_shader_num_mat)\vv[3]\y = -1  : anz_shader_proctest(anz_shader_num_mat)\vv[3]\z = 0 : anz_shader_proctest(anz_shader_num_mat)\vv[3]\color = $FF00FFFF : anz_shader_proctest(anz_shader_num_mat)\vv[3]\tu = 1  : anz_shader_proctest(anz_shader_num_mat)\vv[3]\tv = 1
													; indices definition  
					anz_shader_proctest(anz_shader_num_mat)\id[0] = 0 : anz_shader_proctest(anz_shader_num_mat)\id[1] = 1 : anz_shader_proctest(anz_shader_num_mat)\id[2] = 2
					anz_shader_proctest(anz_shader_num_mat)\id[3] = 0 : anz_shader_proctest(anz_shader_num_mat)\id[4] = 2 : anz_shader_proctest(anz_shader_num_mat)\id[5] = 3

					; texture for render
					anz_shader_proctest(anz_shader_num_mat)\firstmap = iCreateRenderTargetTexture( 1024, 1024)
					anz_shader_proctest(anz_shader_num_mat)\secondmap = #Null
					; new material definition
					anz_shader_proctest(anz_shader_num_mat)\material = iCreateMaterial()
			
					iFlagMaterial    ( anz_shader_proctest(anz_shader_num_mat)\material, #EMF_WIREFRAME, #False)
					iFlagMaterial    ( anz_shader_proctest(anz_shader_num_mat)\material, #EMF_LIGHTING, #False)
					iTextureMaterial ( anz_shader_proctest(anz_shader_num_mat)\material, 0, anz_shader_proctest(anz_shader_num_mat)\firstmap)
					iTextureMaterial ( anz_shader_proctest(anz_shader_num_mat)\material, 1, anz_shader_proctest(anz_shader_num_mat)\secondmap)
					iFlagMaterial    ( anz_shader_proctest(anz_shader_num_mat)\material, #EMF_TEXTURE_WRAP, #ETC_CLAMP) 
					iTypeMaterial    ( anz_shader_proctest(anz_shader_num_mat)\material, anz_shader_proctest(anz_shader_num_mat)\shad) 
					
					; shader value
					anz_shader_proctest(anz_shader_num_mat)\shaderparameters[0]=Value
					
					anz_shader_num_mat+1
			EndProcedure
			
			Procedure anz_shader_EffectRender(Index.l)
					iSetMaterial(anz_shader_proctest(Index)\material) 
					If(anz_shader_num_mat>1)
									anz_shader_curent_mat=Index
									iRenderTarget( anz_shader_proctest(Index+1)\firstmap , #True,  #True,  $FF660000)
										iDrawIndexedTriangleList(@anz_shader_proctest(Index)\vv[0]\x, 6, @anz_shader_proctest(Index)\id[0],  2)
									iRenderTarget( #Null , #True,  #True,  0)
									If( Index<anz_shader_num_mat-1) 
											anz_shader_EffectRender(Index+1)
									Else  
											iDrawIndexedTriangleList(@anz_shader_proctest(Index-1)\vv[0]\x, 6, @anz_shader_proctest(Index-1)\id[0],  2)
									EndIf
					Else
									iDrawIndexedTriangleList(@anz_shader_proctest(Index)\vv[0]\x, 6, @anz_shader_proctest(Index)\id[0],  2)
					EndIf
			EndProcedure
			
			ProcedureC anz_shader_CallbackShader(*services.IMaterialServices,  userData.l)
					Protected text1.l, text2.l	
				
					iPixelShaderConstantNMaterialServices(*services,	"vecValues" ,  @anz_shader_proctest(anz_shader_curent_mat)\shaderparameters[0],   8)
			
					If(userData = 1)
							text1 = 0
							iPixelShaderConstantNMaterialServices(*services,	"texture1" ,  @text1,   1)
							text2 = 1
							iPixelShaderConstantNMaterialServices(*services,	"texture2" ,  @text2,   1)
					EndIf
			
			EndProcedure

   ; load map, init 3d engine.
   
   Procedure anz_initstuff(IsFullscreen ) ; auflösung usw. wird aus anzeige_preferences.pref gelesen.
       Protected *skin.CCustomGUISkin 
       
      ; Font laden
      LoadFont(#anz_PBFont , "Papyrus" , 10 )
      
      ; preferences
      anz_loadpreferences      ()
      ; 3d screen
      If Not iCreateScreen     ( #EDT_OPENGL , anz_getscreenwidth() , anz_getscreenheight(), 0 , anz_getscreendepth() , IsFullscreen  , anz_IsShadowEnabled() , 1 )
         MessageRequester      ( #programmname + " Error" , "Konnte die 3D Engine auf ihrem Computer nicht ausführen. Eventuell hilft ein DirectX update von Microsoft. Fragen sie hierzu bitte einen Administrator" , #MB_SYSTEMMODAL )
         End 
      EndIf 
      ; 3d sound
      If Not IrrKlangStart()
         MessageRequester      ( #programmname + " Error" , "Konnte 3D Sound auf ihrem Computer nicht ausführen. Eventuell hilft ein DirectX update von Microsoft oder Sie verfügen nicht über genügend Administrations-Rechte, bzw. Ihr Soundtreiber ist deinstalliert. Fragen sie hierzu bitte einen Administrator" )
         End 
      EndIf
      iInitXEffect             ( "Gfx\shader\XShaders\")
      ; GUI laden..
      iLoadFont                ( "Gfx\GUI\fontlucida.png", #EGDF_WINDOW);  fort caption windows
      iLoadFont                ( "Gfx\GUI\fontlucida.png")
      *skin                    = iCustomSkinGUI("Gfx\GUI\guiskin.cfg")
      ; set differents Skin color
      iColor_GUISkin           ( *skin, #EGDC_3D_FACE        ,  $EECCCCCC)
      iColor_GUISkin           ( *skin, #EGDC_ACTIVE_CAPTION ,  $FFEEAA00)
      iColor_GUISkin           ( *skin, #EGDC_WINDOW_SYMBOL  ,  $FF0000FF)
      iColor_GUISkin           ( *skin, #EGDC_BUTTON_TEXT    ,  $FFFFFFFF)
      gui_LoadImages           ( )  ; GUI images laden.
      ; logfile 
      iLogFile                 ( 1 )
      iVisibleCursorControl    ( 0 )
      anz_shader_AddProcessing ( #pfad_shader_bloom , #pfad_shader_bloom , 1) ; kein dx-shader dabei..... spiel soll auf opengl laufen.
      iFog                     ( $FFFFFFFF , #True , 15*#meter,100*#meter, 0.0005 , 1 , 24*#meter )
      
      ; camera wird in load_map gesetzt
      
   EndProcedure 
   
   Procedure anz_Map_MaterialtypeFromText ( text.s )
      
      text = LCase (text)
      
      Select text  
         
         Case "solid"
            
            ProcedureReturn #EMT_SOLID 
         
         Case "solid_2layer"
            
            ProcedureReturn #EMT_SOLID_2_LAYER
         
         Case "lightmap"
         
            ProcedureReturn #EMT_LIGHTMAP
            
         Case "lightmap_add"
            
            ProcedureReturn #EMT_LIGHTMAP_ADD 
         
         Case "lightmap_m2"
            
            ProcedureReturn #EMT_LIGHTMAP_M2 
         
         Case "lightmap_m4"
            
            ProcedureReturn #EMT_LIGHTMAP_M4
         
         Case "lightmap_light"
            
            ProcedureReturn #EMT_LIGHTMAP_LIGHTING
            
         Case "lightmap_light_m2"
            
            ProcedureReturn #EMT_LIGHTMAP_LIGHTING_M2
            
         Case "lightmap_light_m4"
            
            ProcedureReturn #EMT_LIGHTMAP_LIGHTING_M4
            
         Case "detail_map"
           
            ProcedureReturn #EMT_DETAIL_MAP
            
         Case "sphere_map"
            
            ProcedureReturn #EMT_SPHERE_MAP
         
         Case "reflection_2layer"
            
            ProcedureReturn #EMT_REFLECTION_2_LAYER
         
         Case "trans_add"
            
            ProcedureReturn #EMT_TRANSPARENT_ADD_COLOR
         
         Case "trans_alphach"
            
            ProcedureReturn #EMT_TRANSPARENT_ALPHA_CHANNEL
            
         Case "trans_alphach_ref"
            
            ProcedureReturn #EMT_TRANSPARENT_ALPHA_CHANNEL_REF
         
         Case "trans_vertex_alpha"
            
            ProcedureReturn #EMT_TRANSPARENT_VERTEX_ALPHA
         
         Case "trans_reflection_2layer"
            
            ProcedureReturn #EMT_TRANSPARENT_REFLECTION_2_LAYER
            
         Case "normalmap_solid"
           
            ProcedureReturn #EMT_NORMAL_MAP_SOLID
         
         Case "normalmap_trans_add"
            
            ProcedureReturn #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
         
         Case "normalmap_trans_vertexalpha"
            
            ProcedureReturn #EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA
         
         Case "parallaxmap_solid"
            
            ProcedureReturn #EMT_PARALLAX_MAP_SOLID
         
         Case "parallaxmap_trans_add"
            
            ProcedureReturn #EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
         
         Case "parallaxmap_trans_vertexalpha"
            
            ProcedureReturn #EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA
            
      EndSelect 
      
   EndProcedure 
   
   Procedure.s anz_peeks ( *p_text.i ) ; procedur, die vorher prüft, ob der pointer nicht 0 ist ;) 
      
      If *p_text 
         ProcedureReturn PeekS ( *p_text)
      EndIf 
      
   EndProcedure 
   
   Procedure anz_XMLLoadMap(*CurrentNode.i , map_pfad.s )  ; Funktion für anz_map_load; nicht für eigennutzen gedacht.
      Static anz_reader.i  , nodeName.s , nodeData.s , nodeart.s , Dim map_skybox_texture.s (6) , map_skybox_texture_counter
      Static sound.anz_sound3d 
      Static terrain_x.f , terrain_y.f , terrain_z.f , terrain_rotx.f , terrain_roty.f , terrain_rotz.f , terrain_scalex.f , terrain_scaley.f , terrain_scalez.f , terrain_pfad.s  , terrain_Texturescale1.f , terrain_Texturescale2.f , terrain_materialtype.i , terrain_texture1.s , terrain_texture2.s 
      Static particle_x.f , particle_y.f , particle_z.f , particle_rotx.f , particle_roty.f , particle_rotz.f , particle_scalex.f , particle_scaley.f , particle_scalez.f , particle_width.f , particle_height.f , particle_art.w , particle_boxwidth.f , particle_boxheight.f , particle_boxdepth.f , particle_direction_x.f , particle_direction_y.f , particle_direction_z.f , particle_minpersecond.f , particle_maxpersecond.f , particle_minstartcolor.f , particle_maxstartcolor.f , particle_minlifetime.f , particle_maxlifetime.f , particle_maxangledegrees.f , particle_materialtype.i , particle_texture1.s , particle_texture2.s , particle_lighting.i 
      Static anim_mesh_x.f , anim_mesh_y.f , anim_mesh_z.f , anim_mesh_rotx.f , anim_mesh_roty.f , anim_mesh_rotz.f , anim_mesh_scalex.f , anim_mesh_scaley.f , anim_mesh_scalez.f , anim_mesh_pfad.s  , anim_mesh_materialtype.i , anim_mesh_texture1.s , anim_mesh_texture2.s , anim_mesh_looping.i , *anim_mesh.anz_mesh ,anim_mesh_animationlist.s , anim_mesh_coltype.i , anim_mesh_coldetail.i 
      Static light_x.f , light_y.f , light_z.f , light_rotx.f , light_roty.f , light_rotz.f , light_scalex.f , light_scaley.f , light_scalez.f , light_ambient_r.f , light_ambient_g.f , light_ambient_b.f  , light_ambient_a.f , light_range.f  , light_diffuse_r.f , light_diffuse_g.f , light_diffuse_b.f , light_diffuse_a.f , light_specular_r.f , light_specular_g.f , light_specular_b.f , light_specular_a.f , *anz_light.anz_light 
      Static mesh_directload.i , mesh_no_textures.i , mesh_x.f , mesh_y.f , mesh_z.f , mesh_rotx.f , mesh_roty.f , mesh_rotz.f , mesh_scalex.f , mesh_scaley.f , mesh_scalez.f , mesh_pfad.s  , mesh_materialtype.i , mesh_texture1.s , mesh_texture2.s , *mesh.anz_mesh , mesh_coltype.i , mesh_coldetail.i
      Static sound_path.s , sound_maxdistance.f , sound_mindistance.f , sound_playmode.w , sound_x.f , sound_y.f , sound_z.f 
      Static billboard_height.f , billboard_materialtype.f , billboard_texture1.s , billboard_width.f , billboard_x.f , billboard_y.f , billboard_z.f
      Static camera_aspect.f , camera_fieldofview.f , camera_rotx.f , camera_roty.f , camera_rotz.f , camera_x.f , camera_y.f , camera_z.f , camera_scalex.f , camera_scaley.f , camera_scalez.f , camera_upvector.f , camera_Zfar.f , camera_Znear.f 
      
      ; Ignore anything except normal nodes. See the manual for
      ; XMLNodeType() for an explanation of the other node types.
      ;
      
      If XMLNodeType(*CurrentNode) = #PB_XML_Normal
      
         ; Add this node to the tree. Add name and attributes
         ;
         Text$ = LCase ( GetXMLNodeName ( *CurrentNode) )
         
         If Text$ = "node"
            ExamineXMLAttributes        ( *CurrentNode)
            NextXMLAttribute            ( *CurrentNode)
            nodeart = LCase (XMLAttributeValue ( *CurrentNode))
         EndIf 
         If ExamineXMLAttributes        ( *CurrentNode)
            While NextXMLAttribute      ( *CurrentNode)
                 nodeData               = LCase( XMLAttributeValue( *CurrentNode))
                 
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
                                             NextXMLAttribute               ( *CurrentNode)    ; die Value auslesen.
                                             If XMLAttributeValue           ( *CurrentNode) > "" ; nicht, dass wir eine leere textur erwischen.
                                                map_skybox_texture_counter  + 1
                                                map_skybox_texture          ( map_skybox_texture_counter)  = map_pfad + XMLAttributeValue( *CurrentNode) ; map_pfad ist der ort, an dem die maps gespeichert sind.
                                                ReplaceString               (  map_skybox_texture          ( map_skybox_texture_counter) , "/" , "\" ,#PB_String_InPlace )
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
                                          
                                          
                                          NextXMLAttribute( *CurrentNode)
                                          nodeData.s      = LCase ( XMLAttributeValue(*CurrentNode))
                                          terrain_x       = ValF(StringField( nodeData , 1 , ", "))
                                          terrain_y       = ValF(StringField( nodeData , 2 , ", "))
                                          terrain_z       = ValF(StringField( nodeData , 3 , ", "))
                                       
                                       Case "rotation"
                                       
                                          NextXMLAttribute   ( *CurrentNode)
                                          nodeData.s         = LCase ( XMLAttributeValue(*CurrentNode) )
                                          terrain_rotx       = ValF(StringField( nodeData , 1 , ", "))
                                          terrain_roty       = ValF(StringField( nodeData , 2 , ", "))
                                          terrain_rotz       = ValF(StringField( nodeData , 3 , ", "))
                                          
                                       Case "scale"
                                       
                                          NextXMLAttribute     ( *CurrentNode)
                                          nodeData.s           = LCase ( XMLAttributeValue(*CurrentNode) )
                                          terrain_scalex       = ValF(StringField( nodeData , 1 , ", "))
                                          terrain_scaley       = ValF(StringField( nodeData , 2 , ", "))
                                          terrain_scalez       = ValF(StringField( nodeData , 3 , ", "))
                                          
                                       Case "heightmap"
                                          
                                          NextXMLAttribute     ( *CurrentNode )
                                          terrain_pfad         = map_pfad + XMLAttributeValue(*CurrentNode)
                                          
                                       Case "texturescale1"
                                          
                                          NextXMLAttribute      ( *CurrentNode )
                                          terrain_Texturescale1 = Val (XMLAttributeValue(*CurrentNode))
                                          
                                       Case "texturescale2"
                                       
                                          NextXMLAttribute      ( *CurrentNode )
                                          terrain_Texturescale2 = Val (XMLAttributeValue(*CurrentNode))                                  
                                          
                                       Case "type" ; materialtype
                                       
                                          NextXMLAttribute       ( *CurrentNode )
                                          terrain_materialtype   = anz_Map_MaterialtypeFromText( XMLAttributeValue(*CurrentNode) )
                                          
                                       Case "texture1"
                                          
                                          NextXMLAttribute       ( *CurrentNode )
                                          terrain_texture1       = map_pfad + XMLAttributeValue(*CurrentNode)
                                          
                                       Case "texture2"
                                          
                                          NextXMLAttribute       ( *CurrentNode )
                                          terrain_texture2       = map_pfad + XMLAttributeValue(*CurrentNode)
                                          
                                       Case "lighting" ; belichtigung + erstellen v. terrain
                                          
                                          x                      + 1
                                          If LCase (XMLAttributeValue(*CurrentNode)) = "false"
                                             terrain_lighting    = 0
                                          Else 
                                             terrain_lighting    = 1
                                          EndIf 
                                          ; jetz sin alle Daten da --> erstellen v. Terrain
                                          
                                          ReplaceString  ( terrain_pfad     , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString  ( terrain_texture1 , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString  ( terrain_texture2 , "/" , "\" ,#PB_String_InPlace )
                                          
                                          anz_addterrain ( terrain_pfad , terrain_x , terrain_y , terrain_z , terrain_texture1 , terrain_texture2 , terrain_Texturescale1 , terrain_Texturescale2 , 0 , 0 , 0 , terrain_materialtype , terrain_scalex , terrain_scaley , terrain_scalez , terrain_rotx , terrain_roty , terrain_rotz )
                                          
                                    EndSelect 
                                    
                              ;}
                              
                           Case "particlesystem"
                              
                              ;{ load particlesystem
                                 
                                 Select nodeData 
                                       
                                       Case "position"
                                          
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s       = LCase ( XMLAttributeValue(*CurrentNode))
                                          particle_x       = ValF(StringField( nodeData , 1 , ", "))
                                          particle_y       = ValF(StringField( nodeData , 2 , ", "))
                                          particle_z       = ValF(StringField( nodeData , 3 , ", "))
                                       
                                       Case "rotation"
                                       
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s          = LCase (XMLAttributeValue(*CurrentNode))
                                          particle_rotx       = ValF(StringField( nodeData , 1 , ", "))
                                          particle_roty       = ValF(StringField( nodeData , 2 , ", "))
                                          particle_rotz       = ValF(StringField( nodeData , 3 , ", "))
                                          
                                       Case "scale"
                                       
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s           = LCase ( XMLAttributeValue(*CurrentNode))
                                          particle_scalex      = ValF(StringField( nodeData , 1 , ", "))
                                          particle_scaley      = ValF(StringField( nodeData , 2 , ", "))
                                          particle_scalez      = ValF(StringField( nodeData , 3 , ", "))
                                       
                                       Case "particlewidth"
                                       
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s           = LCase ( XMLAttributeValue(*CurrentNode))
                                          particle_width       = ValF(StringField( nodeData , 1 , ", "))
                                          
                                       Case "particleheight"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s           = XMLAttributeValue(*CurrentNode)
                                          particle_height      = ValF(StringField( nodeData , 1 , ", "))
                                          
                                       Case "emitter" ; z.b. anz_art_particle_box (oder so ähnlich)
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s           = XMLAttributeValue(*CurrentNode)
                                          
                                          If nodeData          = "ring"
                                             particle_art      = #anz_particle_art_ring
                                          ElseIf nodeData      = "sphere"
                                             particle_art      = #anz_particle_art_sphere
                                          Else 
                                             particle_art      = #anz_particle_art_default
                                          EndIf 
                                          
                                       Case "box" ; width height depth
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s           = XMLAttributeValue(*CurrentNode)
                                          particle_boxwidth    = ValF(StringField( nodeData , 1 , ", "))
                                          particle_boxheight   = ValF(StringField( nodeData , 2 , ", "))
                                          particle_boxdepth    = ValF(StringField( nodeData , 3 , ", "))
                                          
                                       Case "direction" 
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          nodeData.s           = XMLAttributeValue(*CurrentNode)
                                          particle_direction_x = ValF(StringField( nodeData , 1 , ", "))
                                          particle_direction_y = ValF(StringField( nodeData , 2 , ", "))
                                          particle_direction_z = ValF(StringField( nodeData , 3 , ", "))
                                          
                                       Case "minparticlespersecond"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_minpersecond= ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "maxparticlespersecond"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_maxpersecond= ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "minstartcolor"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_minstartcolor= ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "maxstartcolor"
                                       
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_maxstartcolor = ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "minlifetime"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_minlifetime = ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "maxlifetime"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_maxlifetime = ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "maxangledegrees"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_maxangledegrees = ValF( XMLAttributeValue(*CurrentNode))
                                          
                                       Case "type" ; materialtype
                                       
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_materialtype = anz_Map_MaterialtypeFromText( XMLAttributeValue(*CurrentNode) )
                                          
                                       Case "texture1"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_texture1      = map_pfad + XMLAttributeValue(*CurrentNode)
                                          
                                       Case "texture2"
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          particle_texture2      = map_pfad + XMLAttributeValue(*CurrentNode)
                                          
                                       Case "lighting" ; belichtigung + erstellen v. particle
                                          
                                          NextXMLAttribute ( *CurrentNode)
                                          If LCase ( XMLAttributeValue(*CurrentNode)) = "false"
                                             particle_lighting    = 0
                                          Else 
                                             particle_lighting    = 1
                                          EndIf 
                                          
                                          ; jetz sin alle Daten da --> erstellen v. particle
                                          ReplaceString           ( particle_texture1 , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString           ( particle_texture2 , "/" , "\" ,#PB_String_InPlace )
                                          
                                          particle_nodeID         = anz_addparticle ( particle_x        , particle_y      , particle_z      , particle_texture1 , particle_texture2 , particle_materialtype , particle_art , particle_direction_x , particle_direction_y , particle_direction_z , particle_boxwidth , particle_boxheight , particle_boxdepth , particle_minpersecond , particle_maxpersecond , particle_width , particle_height , particle_minstartcolor , particle_maxstartcolor , particle_maxangledegrees , particle_minlifetime , particle_maxlifetime )
                                          iScaleNode              ( particle_nodeID , particle_scalex   , particle_scaley , particle_scalez )
                                          iRotateNode             ( particle_nodeID , particle_rotx     , particle_roty   , particle_rotz   )
                                          iMaterialFlagNode       ( particle_nodeID , #EMF_LIGHTING 		  , particle_lighting & anz_islighting)
      
                                          
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
                                          NextXMLAttribute  ( *CurrentNode )
                                          nodeData.s        = LCase( XMLAttributeValue(*CurrentNode) )
                                          
                                          
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
                                       
                                          NextXMLAttribute        ( *CurrentNode )
                                          anim_mesh_animationlist = XMLAttributeValue ( *CurrentNode)
                                          
                                       Case "position"
                                          
                                          NextXMLAttribute        ( *CurrentNode )
                                          nodeData.s          = XMLAttributeValue ( *CurrentNode)
                                          anim_mesh_x         = ValF(StringField( nodeData , 1 , ", "))
                                          anim_mesh_y         = ValF(StringField( nodeData , 2 , ", "))
                                          anim_mesh_z         = ValF(StringField( nodeData , 3 , ", "))
                                       
                                       Case "rotation"
                                       
                                          NextXMLAttribute        ( *CurrentNode )
                                          nodeData.s          = XMLAttributeValue ( *CurrentNode)
                                          anim_mesh_rotx      = ValF(StringField( nodeData , 1 , ", "))
                                          anim_mesh_roty      = ValF(StringField( nodeData , 2 , ", "))
                                          anim_mesh_rotz      = ValF(StringField( nodeData , 3 , ", "))
                                          
                                       Case "scale"
                                       
                                          NextXMLAttribute         ( *CurrentNode )
                                          nodeData.s           = XMLAttributeValue ( *CurrentNode)
                                          anim_mesh_scalex     = ValF(StringField( nodeData , 1 , ", "))
                                          anim_mesh_scaley     = ValF(StringField( nodeData , 2 , ", "))
                                          anim_mesh_scalez     = ValF(StringField( nodeData , 3 , ", "))
                                       
                                       Case "mesh"
                                          
                                          NextXMLAttribute         ( *CurrentNode )
                                          anim_mesh_pfad       = map_pfad + XMLAttributeValue ( *CurrentNode)
                                       
                                       Case "looping"  ; obs ne sich wiederholende Animation ist.
                                          
                                          NextXMLAttribute         ( *CurrentNode ) 
                                          anim_mesh_looping    = Val( XMLAttributeValue ( *CurrentNode))
                                          
                                       Case "type" ; materialtype
                                       
                                          NextXMLAttribute        ( *CurrentNode )
                                          anim_mesh_materialtype   = anz_Map_MaterialtypeFromText( XMLAttributeValue ( *CurrentNode) )
                                          
                                       Case "texture1"
                                          
                                          NextXMLAttribute         ( *CurrentNode )
                                          anim_mesh_texture1       = map_pfad + XMLAttributeValue ( *CurrentNode)
                                          
                                       Case "texture2"
                                          
                                          NextXMLAttribute         ( *CurrentNode )
                                          anim_mesh_texture2       = map_pfad + XMLAttributeValue ( *CurrentNode)
                                          
                                       Case "lighting" ; belichtigung + erstellen v. anim_mesh
                                          
                                          NextXMLAttribute            ( *CurrentNode )
                                          If XMLAttributeValue ( *CurrentNode) = "false"
                                             anim_mesh_lighting    = 0
                                          Else 
                                             anim_mesh_lighting    = 1
                                          EndIf 
                                          ; jetz sin alle Daten da --> erstellen v. anim_mesh
                                          
                                          ReplaceString              ( anim_mesh_pfad         , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString              ( anim_mesh_texture1     , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString              ( anim_mesh_texture2     , "/" , "\" ,#PB_String_InPlace )
                                          *anim_mesh   = anz_addmesh ( anim_mesh_pfad         , anim_mesh_x , anim_mesh_y , anim_mesh_z , anim_mesh_texture1 , anim_mesh_materialtype , anim_mesh_texture2 , 0 , 1 , anim_mesh_coldetail , anim_mesh_coltype , anim_mesh_rotx , anim_mesh_roty , anim_mesh_rotz , anim_mesh_scalex , anim_mesh_scaley , anim_mesh_scalez )
                                          ani_SetAnimSettings        ( *anim_mesh             , 1 , anim_mesh_looping , 0.4 , 1 , anim_mesh_animationlist )
                                       EndSelect 
                              ;}
                              
                           Case "empty" ; spezial scenenode.. z.b. Teleporter etc ;)
                              
                              ;{ load spezial mesh
                              
                              ;}
                              
                           Case "light"
                              
                              ;{ load light..
                              
                                 Select nodeData 
      
                                       Case "position"
                                          
                                          NextXMLAttribute( *CurrentNode )
                                          nodeData.s      = XMLAttributeValue( *CurrentNode )
                                          light_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                          light_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                          light_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "rotation"
                                       
                                          NextXMLAttribute( *CurrentNode )
                                          nodeData.s      = XMLAttributeValue( *CurrentNode )
                                          light_rotx      = ValF  ( StringField( nodeData , 1 , ", "))
                                          light_roty      = ValF  ( StringField( nodeData , 2 , ", "))
                                          light_rotz      = ValF  ( StringField( nodeData , 3 , ", "))
                                          
                                       Case "scale"
                                       
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s       = XMLAttributeValue( *CurrentNode )
                                          light_scalex     = ValF  ( StringField( nodeData , 1 , ", "))
                                          light_scaley     = ValF  ( StringField( nodeData , 2 , ", "))
                                          light_scalez     = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "ambientcolor"
                                          
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s       = XMLAttributeValue( *CurrentNode )
                                          light_ambient_r  = ValF  ( StringField( nodeData , 1 , ", "))
                                          light_ambient_g  = ValF  ( StringField( nodeData , 2 , ", "))
                                          light_ambient_b  = ValF  ( StringField( nodeData , 3 , ", "))
                                          light_ambient_a  = ValF  ( StringField( nodeData , 4 , ", "))
                                          
                                       Case "diffusecolor"
                                          
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s       = XMLAttributeValue( *CurrentNode )
                                          light_diffuse_r  = ValF  ( StringField( nodeData , 1 , ", "))
                                          light_diffuse_g  = ValF  ( StringField( nodeData , 2 , ", "))
                                          light_diffuse_b  = ValF  ( StringField( nodeData , 3 , ", "))
                                          light_diffuse_a  = ValF  ( StringField( nodeData , 4 , ", "))
                                          
                                       Case "specularcolor"
                                          
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s       = XMLAttributeValue( *CurrentNode )
                                          light_specular_r = ValF  ( StringField( nodeData , 1 , ", "))
                                          light_specular_g = ValF  ( StringField( nodeData , 2 , ", "))
                                          light_specular_b = ValF  ( StringField( nodeData , 3 , ", "))
                                          light_specular_a = ValF  ( StringField( nodeData , 4 , ", "))
                                          
                                       Case "radius"
                                          
                                          Debug "neues Light!" 
                                          NextXMLAttribute ( *CurrentNode )
                                          light_range      = ValF(  XMLAttributeValue( *CurrentNode )) 
                                          *anz_light       = anz_addlight ( 0 , light_x , light_y , light_z , light_range )
                                          iAmbientColorLight   ( *anz_light\nodeID , RGBA( light_ambient_a*255 , light_ambient_r*255 , light_ambient_g*255 , light_ambient_b*255 ))
                                          iDiffuseColorLight   ( *anz_light\nodeID , RGBA( light_diffuse_a *255, light_diffuse_r*255 , light_diffuse_g *255, light_diffuse_b *255))
                                          iSpecularColorLight  ( *anz_light\nodeID , RGBA( light_specular_a*255, light_specular_r*255, light_specular_g*255, light_specular_b*255))
                                          
                                    EndSelect 
                                    
                              ;}
                              
                           Case "mesh" , "octtree"
                              
                              ;{ load mesh
      
                              Select nodeData 
                                       
                                       Case "name"
                                          
                                          NextXMLAttribute  ( *CurrentNode ) 
                                          nodeData.s        = LCase( XMLAttributeValue( *CurrentNode ) )
                                          
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
                                          
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s     = XMLAttributeValue( *CurrentNode )
                                          mesh_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                          mesh_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                          mesh_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "rotation"
                                       
                                          NextXMLAttribute (*CurrentNode )
                                          nodeData.s     = XMLAttributeValue( *CurrentNode )
                                          mesh_rotx      = ValF  ( StringField( nodeData , 1 , ", "))
                                          mesh_roty      = ValF  ( StringField( nodeData , 2 , ", "))
                                          mesh_rotz      = ValF  ( StringField( nodeData , 3 , ", "))
                                          
                                       Case "scale"
                                       
                                          NextXMLAttribute( *CurrentNode )
                                          nodeData.s      = XMLAttributeValue( *CurrentNode )
                                          mesh_scalex     = ValF  ( StringField( nodeData , 1 , ", "))
                                          mesh_scaley     = ValF  ( StringField( nodeData , 2 , ", "))
                                          mesh_scalez     = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "mesh"
                                          
                                          If NextXMLAttribute ( *CurrentNode )
                                             mesh_pfad        = map_pfad + XMLAttributeValue( *CurrentNode )
                                          EndIf 
                                          
                                       Case "type" ; materialtype
                                       
                                          NextXMLAttribute ( *CurrentNode )
                                          If Not mesh_no_textures 
                                             mesh_materialtype = anz_Map_MaterialtypeFromText( XMLAttributeValue( *CurrentNode ) )
                                          Else 
                                             mesh_materialtype = -1
                                          EndIf 
                                          
                                       Case "texture1"
                                          
                                             NextXMLAttribute  ( *CurrentNode )
                                          If Not mesh_no_textures ; dann willer textures selber laden.
                                             mesh_texture1     = map_pfad + XMLAttributeValue( *CurrentNode )
                                          Else 
                                             mesh_texture1     = ""
                                          EndIf 
                                          
                                       Case "texture2"
                                          
                                             NextXMLAttribute  ( *CurrentNode )
                                          If Not mesh_no_textures
                                             mesh_texture2     = map_pfad + XMLAttributeValue( *CurrentNode )
                                          Else 
                                             mesh_texture2     = ""
                                          EndIf 
                                       
                                       Case "param1"
                                          
                                          ; für später... param wird im moment einfach auf nen standardwert gesetzt: 263168
                                          
                                       Case "lighting" ; belichtigung + erstellen v. mesh
                                          
                                          NextXMLAttribute   ( *CurrentNode )
                                          If XMLAttributeValue( *CurrentNode ) = "false"
                                             mesh_lighting   = 0
                                          Else 
                                             mesh_lighting   = 1
                                          EndIf 
                                          ; jetz sin alle Daten da --> erstellen v. mesh
                                          
                                          ReplaceString              ( mesh_pfad         , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString              ( mesh_texture1     , "/" , "\" ,#PB_String_InPlace )
                                          ReplaceString              ( mesh_texture2     , "/" , "\" ,#PB_String_InPlace )
                                          
                                          If mesh_pfad  ; bei mehreren texturen überspringt er nämlich sonst das setzen von meshpfad, und es werden pro Textur ein extramesh erstellt !!! o_O!
                                             *mesh            = anz_addmesh      (  mesh_pfad , mesh_x , mesh_y , mesh_z , mesh_texture1 , mesh_materialtype , mesh_texture2 , mesh_directload , 0 , mesh_coldetail , mesh_coltype  , mesh_rotx , mesh_roty , mesh_rotz , mesh_scalex , mesh_scaley , mesh_scalez , mesh_lighting )
                                          EndIf 
                                          mesh_pfad           = ""
                                          nodeData            = ""
                                          mesh_no_textures    = 0 ; muss alles auf 0 gesetzt werden, weils sonst ja immer auf 1 bleibt o.O ;)
                                          mesh_directload     = 0
                                          mesh_coldetail      = 0
                                          mesh_coltype        = 0
                                    EndSelect 
                              
                              ;}
                              
                           Case "irrklangscenenode"
                              
                              ;{ load 3D sound
                              
                              Select nodeData 
      
                                       Case "position"
                                          
                                          NextXMLAttribute( *CurrentNode )
                                          nodeData.s      = XMLAttributeValue( *CurrentNode )
                                          sound_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                          sound_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                          sound_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "soundfilename"
                                       
                                          NextXMLAttribute( *CurrentNode )
                                          sound_path     = map_pfad + XMLAttributeValue( *CurrentNode )
                                          
                                       Case "playmode"
                                          
                                          NextXMLAttribute( *CurrentNode )
                                          nodeData.s      = LCase ( XMLAttributeValue( *CurrentNode ))
                                          
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
                                          
                                          NextXMLAttribute  ( *CurrentNode )
                                          sound_mindistance = ValF( XMLAttributeValue( *CurrentNode ))
                                          
                                       Case "maxdistance" 
                                          
                                          NextXMLAttribute  ( *CurrentNode )
                                          sound_maxdistance = ValF( XMLAttributeValue( *CurrentNode ))
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
                                          
                                          NextXMLAttribute    ( *CurrentNode )
                                          nodeData.s          = XMLAttributeValue( *CurrentNode )
                                          billboard_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                          billboard_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                          billboard_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "width" 
                                          
                                          NextXMLAttribute      ( *CurrentNode )
                                          billboard_width       = ValF ( XMLAttributeValue( *CurrentNode ))
                                       
                                       Case "height" 
                                          
                                          NextXMLAttribute      ( *CurrentNode )
                                          billboard_height      = ValF ( XMLAttributeValue( *CurrentNode ))
                                          
                                       Case "type" ; materialtype
                                       
                                          NextXMLAttribute       ( *CurrentNode )
                                          billboard_materialtype = anz_Map_MaterialtypeFromText( XMLAttributeValue( *CurrentNode ) )
                                          
                                       Case "texture1"
                                          ; billboards haben keine shadereffekte mit Multitexturen..
                                          NextXMLAttribute       ( *CurrentNode )
                                          billboard_texture1     = map_pfad + XMLAttributeValue( *CurrentNode )
                                          
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
                                          
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s       = XMLAttributeValue( *CurrentNode )
                                          camera_x         = ValF  ( StringField( nodeData , 1 , ", "))
                                          camera_y         = ValF  ( StringField( nodeData , 2 , ", "))
                                          camera_z         = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "rotation"
                                       
                                          NextXMLAttribute ( *CurrentNode )
                                          nodeData.s       = XMLAttributeValue( *CurrentNode )
                                          camera_rotx      = ValF  ( StringField( nodeData , 1 , ", "))
                                          camera_roty      = ValF  ( StringField( nodeData , 2 , ", "))
                                          camera_rotz      = ValF  ( StringField( nodeData , 3 , ", "))
                                          
                                       Case "scale"
                                       
                                          NextXMLAttribute  ( *CurrentNode )
                                          nodeData.s        = XMLAttributeValue( *CurrentNode )
                                          camera_scalex     = ValF  ( StringField( nodeData , 1 , ", "))
                                          camera_scaley     = ValF  ( StringField( nodeData , 2 , ", "))
                                          camera_scalez     = ValF  ( StringField( nodeData , 3 , ", "))
                                       
                                       Case "upvector"
                                          
                                          NextXMLAttribute   ( *CurrentNode )
                                          camera_upvector    = ValF( XMLAttributeValue( *CurrentNode ))
                                          
                                       Case "fovy" ; FieldOfView
                                       
                                          NextXMLAttribute   ( *CurrentNode )
                                          camera_fieldofview  = ValF( XMLAttributeValue( *CurrentNode ))
                                          
                                       Case "aspect"
                                          
                                          NextXMLAttribute   ( *CurrentNode )
                                          camera_aspect       = ValF( XMLAttributeValue( *CurrentNode ))
                                          
                                       Case "znear"
                                          
                                          NextXMLAttribute  ( *CurrentNode )
                                          camera_Znear      = ValF( XMLAttributeValue( *CurrentNode ))
                                          
                                       Case "zfar" ; 
                                          
                                          NextXMLAttribute   ( *CurrentNode )
                                          camera_Zfar        = ValF( XMLAttributeValue( *CurrentNode ))
                                          ; jetz sin alle Daten da --> erstellen v. camera
                                          Debug " SUCCESS -- Create Now PlayeR! "
                                          spi_addspieler     ( camera_x , camera_y , camera_z , #spi_standard_leben , #spi_standard_maxleben , #spi_standard_mana , #spi_standard_maxmana , #spi_standard_name , #spi_standard_team , 1 ) 
      
                                          
                                    EndSelect 
      
                              ;}
                              
                        EndSelect 

            Wend
         EndIf

         *ChildNode = ChildXMLNode(*CurrentNode)
         
         ; Loop through all available child nodes and call this procedure again
         ;
         While *ChildNode <> 0
            anz_XMLLoadMap(*ChildNode , map_pfad )      
            *ChildNode = NextXMLNode(*ChildNode)
         Wend        
      
      EndIf
   
   EndProcedure

   Procedure anz_map_load( pfad.s , map_pfad.s = #pfad_maps)
      
      iTextureCreation   ( #ETCF_CREATE_MIP_MAPS       , 1 )
      
      SetCurrentDirectory( map_pfad )
      map_pfad = ""
        If LoadXML(0, pfad )  
           
           If XMLStatus( 0) <> #PB_XML_Success 
              iSendLog( " Error Loading Map: " + XMLError ( anz_reader))
              ProcedureReturn
           EndIf 
           
           anz_reader = MainXMLNode(0) 
           anz_XMLLoadMap( anz_reader , map_pfad)
        
        
        EndIf 
        
        If anz_reader 
           FreeXML ( 0 )
        EndIf
        
   EndProcedure 
   
   Procedure anz_map_save (pfad.s)
      
   EndProcedure 
   
   ; update stuff
   
   Procedure anz_updateDeleteAnimator()  ; manages the deletion of an irrlicht object after XX miliseconds. 
   
      ForEach anz_deleteanimator  ()
         If ElapsedMilliseconds   () > anz_deleteanimator()\TimeTolive 
            iFreeNode             ( anz_deleteanimator()\irrnode )
            DeleteElement         ( anz_deleteanimator())
         EndIf 
      Next 
      
   EndProcedure 
   
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
             If anz_IsPauseGame         () = 0 ; wenn game NICHT pausiert ist.
               DMX_Freelook             (1 , anz_mousedeltax , anz_mousedeltay , 0.6 , 0.00005 , 2 )  ; camera drehen
               spi_ExamineCamera        ()                         ; camera bewegen
             EndIf 
             
             iBeginScene                (255,255,100)
                ; element of scene render 
				         iRenderTarget              ( anz_shader_proctest(0)\firstmap , #True,  #True,  $FF660000)
             iDrawScene                 ()
 
                ; effect render
              iRenderTarget             ( #Null , #True,  #True,  0)
              anz_shader_EffectRender   (0) 
              anz_displayImages         ()    ; 2d images (gui elemente)
              iDrawGUI                  ()
              iEndScene                 ()
  
   EndProcedure 
   
   Procedure anz_updatesound()
      Static x.f , y.f , z.f  ,vectorStart.IRR_VECTOR ,  vectorEnd.IRR_VECTOR , upx.f,upy.f,upz.f 
    
    If anz_camera 
       E3D_getNodePosition             ( anz_camera , @x,@y,@z)
       e3d_cameraupvector              ( anz_camera , @upx , @upy , @upz )
       iCameraTarget                   ( anz_camera , @vectorEnd)
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
         If key_escape = 0
            key_escape = 1
         ; Wenn Ingame:
         ; -> InGameMenu öffnen
         ; wenn schon offen
         ; -> Schließen
         ; wenn im großen Menu:
         ; Endedialog öffnen.
         ; wenn schon offen:
         ; endedialog wieder schließen.
            If gui_IsInventarOpen() > 0
               gui_setGUI( #gui_Status_Inventar )
            Else 
               anz_ende() 
            EndIf 
         Else 
            key_escape = 2
         EndIf 
      Else 
         key_escape = 0
      EndIf 
      
    ; Spielfigur bewegen
    
    ; wenn nichts gedrückt wird steht das Wesen einfach. ;) (sofern es die current animation unterbrechen kann.)
    spi_current_AnimNR = ani_getCurrentAnimationNR( wes_getAnzMeshID( spi_GetSpielerWesenID( spi_getcurrentplayer()) ) )
    
    If spi_current_AnimNR = #ani_animNR_run Or spi_current_AnimNR = #ani_animNR_walk ; die aktionen müssen jede runde erneuert werden, ansonsten werdens gleich abgebrochen!
    
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
               ; PAUSE.. waffeziehen/wegstecken ermöglichen..
            EndIf 
         Else 
            anz_key_tipped_control = 0
         EndIf 
         
         ;}
         
         ;{ zuschlagen links
            
            If anz_mousebutton( 1 , #anz_MouseEvent_tipped )
               wes_AttackGegner( spi_GetSpielerWesenID( spi_getcurrentplayer()), 0 , 0)
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
            gui_setGUI( #gui_Status_questlog )
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
      
      If GetAsyncKeyState_   ( #VK_M) ; map öffnen
         If anz_key_tipped_m = 0
            anz_key_tipped_m = 1
            gui_setGUI       ( #Gui_Status_Map )
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
      
      ;{ inventar öffnen
      
      If GetAsyncKeyState_    ( #VK_I) ; Chatlog öffnen --> Multiplayer.
         If anz_key_tipped_i  = 0
            anz_key_tipped_i  = 1
            gui_setGUI( #gui_Status_Inventar ) 
         EndIf 
      Else 
         anz_key_tipped_i     = 0
         
      EndIf 
      ;}
      
      ;{ Schnellwahlitem benutzen (1-9 und 0)
      
       anz_updateinput_UseSchnellwahl(1)  ; wird taste 1 gedrückt, wird schnellwahl 1 benutzt.
       anz_updateinput_UseSchnellwahl(2)  ; etc.
       anz_updateinput_UseSchnellwahl(3)
       anz_updateinput_UseSchnellwahl(4)
       anz_updateinput_UseSchnellwahl(5)
       anz_updateinput_UseSchnellwahl(6)
       anz_updateinput_UseSchnellwahl(7)
       anz_updateinput_UseSchnellwahl(8)
       anz_updateinput_UseSchnellwahl(9)
       anz_updateinput_UseSchnellwahl(0)
      
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
    anz_mousex      - anz_mousedeltax 
    anz_mousey      - anz_mousedeltay 
    If anz_mousex   > anz_getscreenwidth() : anz_mousex = anz_getscreenwidth() : EndIf 
    If anz_mousex   < 0 : anz_mousex = 0   : EndIf 
    If anz_mousey   > anz_getscreenheight(): anz_mousey = anz_getscreenheight() : EndIf 
    If anz_mousey   < 0 : anz_mousey = 0   : EndIf 
    
    ; mousewheel
      

      anz_mouseWheel.f       = anz_MouseWheelDelta()  ; - Pause.. evtl geht der mousewheelzoom hier nicht.. mal schaun.
      spi_SetCameraDistance  ( spi_GetCameraDistance() + anz_mouseWheel * (anz_mouseWheel - 10) /2) ; mit geschätzten 10 als mindestabstand.

      
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
   
   Procedure anz_setmeshmaterial_setallMaterialNormalMap ( *anz_Mesh_ID.anz_mesh ) ; adds only the normalmap and param1 and texture; not materialtype.
      Protected *material.IMaterial 
      
      If Not *anz_Mesh_ID : ProcedureReturn : EndIf 
      
      For n = 0 To iNodeNumMaterial( *anz_Mesh_ID\nodeID ) -1
         *material             = iNodeMaterial ( anz_getObject3DIrrNode( anz_getobject3dByAnzID( *anz_Mesh_ID)),n)
         iTypeParamMaterial(*material   , 0.035) 
      Next 
      
      If *anz_Mesh_ID\texture_normalmap  > ""
         *NormalmapID                    = anz_loadtexture( *anz_Mesh_ID\texture_normalmap ,1)
         iNormalMapTexture               ( *NormalmapID , 0.9)
         iMaterialTextureNode            ( *anz_Mesh_ID\nodeID , *NormalmapID , 1)    ; normal map setzten.
      EndIf 
      
   EndProcedure 
   
   Procedure anz_setMeshMaterial ( *anz_Mesh_ID.anz_mesh  , MaterialType.i , isparallax.w=1 , isnormal.w=1 ) ; Versucht, Mesh material zu parallax zu schalten, wenn nicht möglich -> andere technik.
      Protected irr_obj.i , irr_shader.i , currentlistenobject.i , *material.IMaterial 
     
                 If *anz_Mesh_ID\geladen     = 1  
                    
                    If Not *anz_Mesh_ID\irr_emt_materialtype = -1
                 
                    irr_obj                  = *anz_Mesh_ID\nodeID                   ; vereinfachen der ID auf ne variable
                    
                    ;{ material setzen
                    
                    Select MaterialType 
                    
                       Case #EMT_PARALLAX_MAP_SOLID
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled          ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_PARALLAX_MAP_SOLID                                       ; welches material das mesh aktuell gerade hat.
                                  iMaterialTypeNode                  ( *anz_Mesh_ID\nodeID , *anz_Mesh_ID\currentmaterialtype )      ; materialnode.
                                  If *anz_Mesh_ID\texture            > ""
                                     iMaterialTextureNode            ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ,1) , 0)              ; solid und 
                                  EndIf 
                                  anz_setmeshmaterial_setallMaterialNormalMap( *anz_Mesh_ID )
                                  
                           ElseIf anz_IsNormalmappingEnabled()       And isnormal ; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_NORMAL_MAP_SOLID      ; welches material das mesh aktuell gerade hat.
                                  If *anz_Mesh_ID\texture            > ""
                                     iMaterialTextureNode            ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  anz_setmeshmaterial_setallMaterialNormalMap( *anz_Mesh_ID )
                                  iMaterialTypeNode                  ( irr_obj , *anz_Mesh_ID\currentmaterialtype )


                                  
                            Else  ; ansonsten solid anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_SOLID      ; welches material das mesh aktuell gerade hat.
                                  If *anz_Mesh_ID\texture            > ""
                                     iMaterialTextureNode       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture ,1) , 0)              ; solid map laden. 
                                  EndIf 
                                  iMaterialTypeNode             ( irr_obj , #EMT_SOLID )                                            ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}

                       Case #EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled        ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                 
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  anz_setmeshmaterial_setallMaterialNormalMap( *anz_Mesh_ID )
                                  iMaterialTypeNode                  ( irr_obj , *anz_Mesh_ID\currentmaterialtype )  
                 
                           ElseIf anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  anz_setmeshmaterial_setallMaterialNormalMap( *anz_Mesh_ID )
                                  iMaterialTypeNode                  ( irr_obj , *anz_Mesh_ID\currentmaterialtype )

                                  
                            Else  ; ansonsten IRR_EMT_TRANSPARENT_ADD_COLOR anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  iMaterialTypeNode           ( irr_obj , #EMT_TRANSPARENT_ADD_COLOR )                        ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}
                       
                       Case #EMT_NORMAL_MAP_SOLID 
                           
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_NORMAL_MAP_SOLID
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  anz_setmeshmaterial_setallMaterialNormalMap( *anz_Mesh_ID )
                                  iMaterialTypeNode                  ( irr_obj , *anz_Mesh_ID\currentmaterialtype )

                                  
                            Else  ; ansonsten solid anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_SOLID 
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  iMaterialTypeNode           ( irr_obj , #EMT_SOLID )                                            ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}
                           
                       Case #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                          
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  anz_setmeshmaterial_setallMaterialNormalMap( *anz_Mesh_ID )
                                  iMaterialTypeNode                  ( irr_obj , *anz_Mesh_ID\currentmaterialtype )

                                  
                            Else  ; ansonsten solid anzeigen. 
                                  
                                  *anz_Mesh_ID\currentmaterialtype   = #EMT_TRANSPARENT_ADD_COLOR
                                  If *anz_Mesh_ID\texture
                                     iMaterialTextureNode        ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                                  EndIf 
                                  iMaterialTypeNode           ( irr_obj , #EMT_TRANSPARENT_ADD_COLOR )                        ; im Moment sin also keine transparenten meshes unterstützt.

                           EndIf 
                           
                           ;}
                           
                       Default  ; alle anderen Techniken sollten unterstützt werden. 
                            
                           ;{
                           
                            *anz_Mesh_ID\currentmaterialtype   = MaterialType 
                            If *anz_Mesh_ID\texture            > ""
                               iMaterialTextureNode       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture,1 ) , 0)              ; solid und 
                            EndIf 
                            If *anz_Mesh_ID\texture_normalmap  > ""
                               iMaterialTextureNode       ( irr_obj , anz_loadtexture( *anz_Mesh_ID\texture_normalmap,1 ) , 1)    ; normal map setzten, bzw. wahrscheinlich isses ja lightmap etc.
                            EndIf   
                            iMaterialTypeNode             ( irr_obj , MaterialType )    
                           
                           ;}
                           
                   EndSelect 
                   
                   
                 ;}
                    
                       iMaterialFlagNode        ( *anz_Mesh_ID\nodeID , #EMF_LIGHTING   , *anz_Mesh_ID\islighting & anz_islighting)
                       iMaterialFlagNode        ( *anz_Mesh_ID\nodeID , #EMF_FOG_ENABLE , anz_isfog      )
                    EndIf 
                EndIf 
                
             ProcedureReturn irr_obj 
             
   EndProcedure 

   Procedure anz_GetMeshMaterialDetail ( *anz_mesh.anz_mesh  , MaterialType.i , isparallax.w=1, isnormal.w=1) ; schaut, ob das Material parallaxmapped ist, wenn das gewünscht ist usw..
      Static currentlistenobject.i 
      
                 If *anz_mesh\geladen        = 1
                 
                    irr_obj                   = *anz_mesh\nodeID                   ; vereinfachen der ID auf ne variable
                    
                    ;{
                    
                    Select MaterialType 
                    
                       Case #EMT_PARALLAX_MAP_SOLID
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled        ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                                  ProcedureReturn #EMT_PARALLAX_MAP_SOLID
                           ElseIf anz_IsNormalmappingEnabled()    And isnormal ; wenn statt parallax wenigstens normalmapping an ist.
                                  ProcedureReturn #EMT_NORMAL_MAP_SOLID
                           Else  ; ansonsten solid anzeigen. 
                                  ProcedureReturn #EMT_SOLID 
                           EndIf 
                           
                           ;}

                       Case #EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                          
                          ;{
                          
                           If anz_IsParallaxmappingEnabled        ( ) And isparallax ; wenn parallaxmapping eingeschaltet ist.
                               ProcedureReturn #EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR
                           ElseIf anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                               ProcedureReturn #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                           Else  ; ansonsten emt_TRANSPARENT_ADD_COLOR anzeigen. 
                               ProcedureReturn #EMT_TRANSPARENT_ADD_COLOR
                           EndIf 
                           
                           ;}
                       
                       Case #EMT_NORMAL_MAP_SOLID 
                           
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                               ProcedureReturn #EMT_NORMAL_MAP_SOLID
                           Else  ; ansonsten solid anzeigen. 
                               ProcedureReturn #EMT_SOLID
                           EndIf 
                           
                           ;}
                           
                       Case #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                          
                           ;{
                           
                           If anz_IsNormalmappingEnabled()     And isnormal; wenn statt parallax wenigstens normalmapping an ist.
                               ProcedureReturn #EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR
                           Else  ; ansonsten solid anzeigen. 
                               ProcedureReturn #EMT_TRANSPARENT_ADD_COLOR
                           EndIf 
                           
                           ;}
                           
                       Default  ; alle anderen Techniken sollten unterstützt werden. 
                            
                           ;{
                           ProcedureReturn MaterialType 
                           ;}
                           
                   EndSelect 
                   
                   
                 ;}
                 
                EndIf 
             
   EndProcedure 
   
   Procedure anz_setShownObjects(irr_Camera) ; lädt und löscht objekte, wenn sie nah bzw. fern sind. (resourceschonung)
      
      Protected *p_obj.anz_Object3d , ObjectArt.w, px.f, py.f, pz.f , isnormalmapping.w , irr_obj.i , rasterx.i , rastery.i , rasterz.i , *anz_mesh.anz_mesh 
      Protected *p_list_bill.anz_billboard , *p_list_mesh.anz_mesh , *p_list_particle.anz_particle , *p_list_terrain.anz_terrain 
      Protected x1.f , y1.f, z1.f , x2.f , y2.f , z2.f , anz_obj_cam_dist.f , radx.f,rady.f,radz.f , vector_pos.ivector3 
      Static    anzahl_zuladendes.f , dist_faktor.f = 90 , key_4_gedruckt.i 
      
      If Not irr_Camera 
         ProcedureReturn 0
      EndIf 
      
      E3D_getNodePosition  ( irr_Camera , @x1 , @y1 , @z1)   ; prüft die Position des spielers. weil aus der include_spieler.pb -> befehle beginnen mit "spi_"
      
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
                  
                  anz_obj_cam_dist     =  math_distance3d    (x1,y1,z1, *p_obj\x , *p_obj\y , *p_obj\z)  ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)
                   
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
                                    If Not iNodeVisible  ( irr_obj)
                                       iVisibleNode      ( irr_obj , 1)
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
                                    If iNodeVisible ( irr_obj) 
                                       If math_iseven( irr_obj) ; nur jedes 2. (also jedes Billb. mit gerader ID wird angezeigt)
                                          iVisibleNode     ( irr_obj , 1)
                                       Else ; jedes ungerade wird ausgeblendet.
                                          iVisibleNode     ( irr_obj , 0)
                                       EndIf 
                                    EndIf 
                                 EndIf 
                               ;}
                               
                            ElseIf anz_obj_cam_dist < anz_distance_ferner        ; ausblenden der billboards nicht textur loeschen, weil die ja nur 1. mal voranden ist (für alle billbaords) bei kleineren karten geht des schon
                               
                               If irr_obj And  Not anz_IsObject3dChild( *p_obj )
                                  If  iNodeVisible    ( irr_obj )     ; wenns angezeigt wird
                                      iVisibleNode    ( irr_obj , 0)  ; ausblenden
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
                               iNodePosition     ( irr_obj , @vector_pos)
                               *p_obj\x          = vector_pos\x 
                               *p_obj\y          = vector_pos\y 
                               *p_obj\z          = vector_pos\z
                               If *anz_mesh\WesenID > 0
                                  If wes_UpdateWesen( *anz_mesh\WesenID ) = #wes_action_die ; wenn eine einheit stirbt wird alles abgebrochen..
                                     ProcedureReturn   
                                  EndIf 
                               EndIf 
                               If *anz_mesh\itemID > 0
                               
                               EndIf 
                            EndIf  
                            
                            ;{ entfernung zum objekt mit radius 
                            
                               If Not anz_IsObject3dChild( *p_obj) ; wenn es ein child ist, wird node nicht gelöscht etc.
                                    If *anz_mesh\geladen 
                                       If GetAsyncKeyState_(#VK_F4) And *anz_mesh\WesenID > 0
                                       Debug "Reload Object 3D "
                                       Debug "ART: " + Str(*p_obj\art)
                                       Debug "wesenid: " + Str( *anz_mesh\WesenID )
                                       Debug "irrnode: " + Str(anz_getObject3DIrrNode( *p_obj ))
                                       EndIf 
                                       E3D_GetExtentTransformed(anz_getObject3DIrrNode( *p_obj) , @radx , @rady , @radz)
                                       If GetAsyncKeyState_(#VK_F4) And *anz_mesh\WesenID > 0
                                       Debug "GOT Extent"
                                       EndIf 
                                       *anz_mesh\width   = radx 
                                       *anz_mesh\height  = rady
                                       *anz_mesh\Depth   = radz
                                    Else 
                                       radx = *anz_mesh\width
                                       rady = *anz_mesh\height
                                       radz = *anz_mesh\Depth
                                    EndIf 
                                    rady    = math_distance3d( radx , rady , radz , 0,0,0) ; sozusagen die 0-vectoren.. somit wird die raumdiagonale berechnet.
                                    rady    / 2                             ; rady ist jetzt radius.. 
                               Else 
                                    rady    = 0 
                               EndIf 
                               
                               If *anz_mesh\WesenID  = spi_GetSpielerWesenID ( spi_getcurrentplayer()) ; der Hauptspieler ist von der Anzeigeengine komplett ausgenommen!..
                                  Continue 
                               EndIf 

                            ;}
                             
                             If *anz_mesh\geladen > 0
                                irr_obj = *anz_mesh\nodeID 
                                E3D_getNodePosition           ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                             EndIf 
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
                                 
                                 E3D_getNodePosition           ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 If GetAsyncKeyState_( #VK_F6) And *anz_mesh\irr_emt_materialtype = #EMT_NORMAL_MAP_SOLID; - DEBUG
                                    Debug "meshmaterialdetail: " + Str(anz_GetMeshMaterialDetail( *anz_mesh , *anz_mesh\irr_emt_materialtype , 1 ,1))  ; irr_shader ist *anz_mesh\materialtype
                                    Debug #EMT_NORMAL_MAP_SOLID 
                                 EndIf 
                                    
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( *anz_mesh , *anz_mesh\irr_emt_materialtype , 1 ,1)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,1,1)
                                 EndIf 
                                 
                                 ; mesh anzeigen, wenn versteckt
                                  If Not anz_IsObject3dChild   ( *p_obj )
                                     If Not iNodeVisible       ( irr_obj )
                                        iVisibleNode           ( irr_obj , 1)
                                     EndIf 
                                  EndIf 
                                  
                                 ; schatten laden, wenn noch nicht vorhanden
                                 If anz_IsShadowEnabled         ( )  
                                    If *anz_mesh\ShadowID       = 0
                                       *anz_mesh\ShadowID       = 1
                                       iAddShadowToNodeXEffect  ( *anz_mesh\nodeID  , #EFT_NONE,  #ESM_BOTH)
                                    Else ; schatten weghauen.
                                       iRemoveShadowNodeXEffect ( *anz_mesh\nodeID )
                                       *anz_mesh\ShadowID       = 0
                                    EndIf 
                                 EndIf 
                                 
                                   ;}
                               
                               ElseIf anz_obj_cam_dist <= anz_distance_fern  * rady / dist_faktor       ; hier noch weniger anzeigen
                               
                                 ;{
                                 
                                 ; laden, wenn gelöscht. 
                                
                                 If Not *anz_mesh\geladen        = 1  
                                    If anzahl_zuladendes < 1 And  Not anz_IsObject3dChild( *p_obj )
                                       anzahl_zuladendes            + 0.2
                                       irr_obj = anz_reload_object3d( *p_obj)
                                    Else
                                       Continue 
                                    EndIf 
                                 EndIf 
                                 
                                 ; XYZ -Werte dem Mesh anpassen  ( irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 If irr_obj > 0
                                    E3D_getNodePosition          ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 Else 
                                    Continue  
                                 EndIf 
                                 
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( *anz_mesh , *anz_mesh\irr_emt_materialtype , 0 ,1)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial        ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,0,1)
                                 EndIf 
                                 
                                 ; mesh anzeigen, wenn versteckt
                                 If Not iNodeVisible            ( irr_obj ) And  Not anz_IsObject3dChild( *p_obj )
                                    iVisibleNode                ( irr_obj , 1)
                                 EndIf
                                 
                                 ; schatten laden, wenn noch nicht vorhanden
                                 If anz_IsShadowEnabled()
                                    If *anz_mesh\ShadowID        = 0
                                       iAddShadowToNodeXEffect   ( *anz_mesh\nodeID , #EFT_NONE,  #ESM_BOTH)
                                       *anz_mesh\ShadowID        = 1
                                    Else
                                       iRemoveShadowNodeXEffect  ( *anz_mesh\nodeID )
                                       *anz_mesh\ShadowID        = 0
                                    EndIf 
                                 EndIf 
                                 
                                 ;}
                               
                            ElseIf anz_obj_cam_dist <= anz_distance_ferner * rady / dist_faktor        ; evtl kleinere Objekte ausblenden.
                                 
                                 ;{
                                 
                                 ; laden, wenn gelöscht. 
                                 If Not *anz_mesh\geladen        = 1 And  Not anz_IsObject3dChild( *p_obj )
                                    If And anzahl_zuladendes < 1 
                                       anzahl_zuladendes            + 0.4
                                       irr_obj = anz_reload_object3d( *p_obj)
                                    Else 
                                       Continue 
                                    EndIf 
                                 EndIf 
                                 
                                 irr_obj                        = *anz_mesh\nodeID  ; sonst stürtzer uns wieder ab..
                                 ; XYZ -Werte dem Mesh anpassen ( irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 If Not irr_obj ; wenns nicht geladen werden konnte.
                                    Continue
                                 EndIf 

                                 E3D_getNodePosition            ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )

                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( *anz_mesh , *anz_mesh\irr_emt_materialtype , 0 ,0)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial         ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,0,0)
                                 EndIf 
                                 
                                 ; mesh anzeigen, wenn versteckt, bzw. ausblenden wenn angezeigt und zu klein.

                                 If Not iNodeVisible            ( irr_obj )  And  Not anz_IsObject3dChild( *p_obj )
                                       iVisibleNode             ( irr_obj , 1)
                                 EndIf 
                                    
                                 ; schatten ausblenden, um leistung zum sparen
                                 If *anz_mesh\ShadowID          > 0 And anz_IsShadowEnabled()
                                    iRemoveShadowNodeXEffect    ( irr_obj )
                                    *anz_mesh\ShadowID          = 0
                                 EndIf 
                                 
                                 ;}
                                 
                            ElseIf anz_obj_cam_dist <= anz_distance_unsichtbar * rady / dist_faktor   ; ausblenden des Meshes
                            
                                 ;{
                                 
                                 ; laden, wenn gelöscht. 
                                 If Not *anz_mesh\geladen       = 1 
                                    If anzahl_zuladendes < 1 And Not anz_IsObject3dChild( *p_obj )
                                       anzahl_zuladendes            + 0.4
                                       irr_obj = anz_reload_object3d( *p_obj)
                                    Else 
                                       Continue 
                                    EndIf 
                                 EndIf 
                                 *anz_mesh = *p_obj\id 
                                 ; XYZ -Werte dem Mesh anpassen ( irrlicht sagt ja, ob es z.b. gegen ne mauer rennt usw.)
                                 If irr_obj <= 0
                                    Continue 
                                 EndIf 
                                 E3D_getNodePosition            ( irr_obj , @*p_obj\x , @*p_obj\y , @*p_obj\z )
                                 
                                 ; material setzen
                                 If Not *anz_mesh\currentmaterialtype = anz_GetMeshMaterialDetail( *anz_mesh , *anz_mesh\irr_emt_materialtype , 0,0)  ; irr_shader ist *anz_mesh\materialtype
                                     anz_setMeshMaterial         ( *p_obj\id , *anz_mesh\irr_emt_materialtype ,0,0)
                                 EndIf 
                                 
                                 If Not iNodeVisible            ( irr_obj ) And  Not anz_IsObject3dChild( *p_obj )
                                       iVisibleNode             ( irr_obj , 0)
                                 EndIf 
                                 
                                 ; schatten ausblenden, falls eingeschaltet... neue Erkenntnis: schatten wird vermutlich von selbst ausgeblendet/gelöscht etc.
                                 If *anz_mesh\ShadowID > 0 And anz_IsShadowEnabled() 
                                    iRemoveShadowNodeXEffect    ( irr_obj )
                                    *anz_mesh\ShadowID          = 0
                                 EndIf 
                                 
                                 ;}
                          
                            ElseIf anz_obj_cam_dist  > anz_distance_unsichtbar * rady / dist_faktor    ; löschen des meshes
                                
                                 ;{
                                 
                                 If *anz_mesh\geladen And Not wes_getSpielerID(*anz_mesh\WesenID ) > 0 ; spieler werden nicht gelöscht! ma kann ja schlecht ohne Körper rumlaufen, als spieler.. 
                                    
                                    If Not anz_IsObject3dChild ( *p_obj ) ; children werden nur von den eltern gelöscht!
                                       anz_freemesh            ( *anz_mesh)
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
                                  If iNodeVisible        ( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     iVisibleNode        ( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate auf voll setzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_particles_per_second , anz_particle()\nodestruct\max_particles_per_second , #anz_meter /2 )
                                  ;}
                                  
                               Case anz_distance_nah To anz_distance_fern             ; bisschen weniger angezeigt
                                  
                                  ;{ ferne particle
                                  
                                  ; wenn hidden: anzeigen
                                  If iNodeVisible        ( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     iVisibleNode        ( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate runtersetzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_particles_per_second *0.6, anz_particle()\nodestruct\max_particles_per_second *0.66 , #anz_meter / 2)
                                  ;}
                                  
                               Case anz_distance_fern To anz_distance_ferner          ; noch weiter
                                  
                                  ;{ fernere particles
                                  
                                  ; wenn hidden: anzeigen
                                  If iNodeVisible        ( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     iVisibleNode        ( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate runtersetzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\min_particles_per_second *0.2, anz_particle()\nodestruct\max_particles_per_second *0.2 , #meter / 2)
                                  
                                  ;}
                                  
                               Case anz_distance_ferner To anz_distance_unsichtbar    ; beinahe unsichtbar
                                  
                                  ;{ ganz ganz ferne particles
                                  
                                  ; wenn hidden: anzeigen
                                  If iNodeVisible        ( anz_particle()\nodeID ) = 0 And Not anz_IsObject3dChild( *p_obj)
                                     iVisibleNode        ( anz_particle()\nodeID , 1 )
                                  EndIf 
                                  
                                  ; particelRefreshRate runtersetzen
                                  anz_particle_Set_Particles_Per_second_temporary ( anz_particle() , anz_particle()\nodestruct\max_particles_per_second *0.01, anz_particle()\nodestruct\max_particles_per_second *0.01 , #meter / 2)
                                  
                                  ;}
                                  
                               Default                                                ; nicht löschen! wird nur gehidden. evtl erst ab 1. beta, wenns sein soll.
                                  
                                  ;{ ausgeblendete particles.
                                  
                                  ; wenn angezeigt: hide.
                                  If iNodeVisible        ( anz_particle()\nodeID ) = 1 And Not anz_IsObject3dChild( *p_obj)
                                     iVisibleNode        ( anz_particle()\nodeID , 0 )
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
                               If  anz_getObjectScreenWidth(*p_obj\x , *p_obj\y , *p_obj\z ,  anz_terrain()\width )  * anz_getObjectScreenHeight( *p_obj\x , *p_obj\y , *p_obj\z , anz_terrain()\height )   * anz_getObjectScreenDepth ( *p_obj\x , *p_obj\y , *p_obj\z , anz_terrain()\Depth ) <= 400*400*75 And Not (anz_terrain()\width  <= 0 Or anz_terrain()\height <= 0 Or anz_terrain()\Depth <= 0)
                                  
                                  If anz_terrain()\width  <= 0 Or anz_terrain()\height <= 0 Or anz_terrain()\Depth <= 0
                                     If anz_terrain()\geladen = 1
                                        E3D_GetExtentTransformed( anz_terrain()\nodeID , @anz_terrain()\width , @anz_terrain()\height , @anz_terrain()\Depth )
                                      EndIf
                                  EndIf 
                                  
                                  If anz_terrain     ()\geladen = 1
                                     iFreeNode       ( irr_obj )
                                     anz_terrain     ()\geladen = 0
                                     anz_freetexture ( anz_gettexturebypfad( anz_terrain()\texture1 ))
                                     anz_freetexture ( anz_gettexturebypfad( anz_terrain()\texture2 ))
                                     ; IrrRemoveCollisionGroupFromCombination( anz_CollisionMeta_solid , anz_terrain     ()\CollisionID ) ; collision von meta löschen.
                                  EndIf 
                                  
                               Else ; nichts tun.. prüfen, ob schon geladen; wenn nicht-> laden.
                                  
                                  If anz_terrain()\geladen        = 0 ; Ansonsten Neuladen,  wenn noch nicht geladen
                                     anz_terrain()\nodeID         =  iCreateTerrain  ( anz_terrain()\terrainmap ,1.0,32,4,1024)
                                     
                                     If anz_terrain()\nodeID      > 0
                                        iPositionNode             ( anz_terrain()\nodeID ,  *p_obj\x , *p_obj\y , *p_obj\z)
                                        iScaleNode                ( anz_terrain()\nodeID , anz_terrain()\scalex , anz_terrain()\scaley , anz_terrain()\scalez)
                                        irotatenode               ( anz_terrain()\nodeID , anz_terrain()\rotx   , anz_terrain()\roty   , anz_terrain()\rotz)
                                        irr_obj                   = anz_terrain()\nodeID ; der vollständigkeit halber..
                                        anz_terrain()\geladen     = 1 
                                        iMaterialTextureNode      ( anz_terrain()\nodeID , iLoadTexture ( anz_terrain()\texture1 ) , 0 ); anz_loadtexture( anz_terrain()\texture1 ),0)
                                        iMaterialTextureNode      ( anz_terrain()\nodeID , iLoadTexture ( anz_terrain()\texture2 ) , 1 ); anz_loadtexture( anz_terrain()\texture2 ),1)
                                        ; IrrScaleTexture           ( anz_terrain()\nodeID , anz_terrain()\texturescalex, anz_terrain()\texturescaley) ; - pause.. vielleicht findet sich irgendwann eine funktion, die das machen kann, in n3xtd.
                                        iMaterialFlagNode         ( anz_terrain()\nodeID , #EMF_LIGHTING , anz_terrain()\islighting & anz_IsLightingEnabled())
                                        iMaterialFlagNode         ( anz_terrain()\nodeID , #EMF_FOG_ENABLE , anz_IsFogEnabled() )
                                        iMaterialTypeNode         ( anz_terrain()\nodeID , anz_terrain()\irr_emt_materialtype )
                                        ; collision: aus., stattdessen kommt dann physik dazu.
                                        ; anz_terrain()\CollisionID = IrrAddCollisionGroupToCombination( anz_CollisionMeta_solid , IrrGetCollisionGroupFromTerrain( anz_terrain()\nodeID , 1 ))
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
       Protected width.i , height.i , *anz_texture.anz_texture 
       ; display 2d alpha images.
       
       ResetList( anz_image())
       
          While NextElement (anz_image())
             If Not anz_image()\ishidden
                *anz_texture     = anz_image ()\id 
                ; itexturesize     ( *anz_texture\id , @width , @height )
                iDrawRectImage2D ( *anz_texture\id , anz_image()\x , anz_image()\y , anz_image()\rectX,anz_image()\rectY, anz_image()\width , anz_image()\height, $FFFFFFFF,0,anz_image()\Alpha )
             EndIf 
          Wend 
          
   EndProcedure 
   
   ; Physics..
   
   Procedure anz_dropstuff()  ; .. 1. BETA Dinge können herunterfallen.
   
   EndProcedure 
   
   ; free Things
   
   Procedure anz_AddDeleteAnimator(Irrmesh, TimeTolive) ; deletes an irrmesh after X milliseconds
      Protected *Obj.anz_deleteanimator 
         *Obj = AddElement( anz_deleteanimator())
         *Obj\TimeTolive = ElapsedMilliseconds() + TimeTolive 
         *Obj\irrnode    = Irrmesh 
         
         ProcedureReturn *Obj 
   EndProcedure 
   
   Procedure anz_freemesh( *p_anz_mesh.anz_mesh ) ; gibt das Mesh frei zum späteren Neuladen (Auslagern)
       
       If *p_anz_mesh\geladen ; wenns noch geladen ist (laut variable)
          
          *p_anz_mesh\geladen    = 0
          If *p_anz_mesh\ShadowID 
             iRemoveShadowNodeXEffect( *p_anz_mesh )
          EndIf 
          *p_anz_mesh\ShadowID   = 0 ; wichtig: schatten als ungeladen markieren
          anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture ))            ; die texturen löschen
          anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture_normalmap))   ; normalmap-texture löschen
          
          ; If *p_anz_mesh\collisionNodeID > 0
             ; iFreeBody         ( *p_anz_mesh\collisionNodeID ) ; löscht body und node automatisch
          ; Else  
             iFreeNode            ( *p_anz_mesh\nodeID ) ; löscht shattennode automatisch mit.
          ; EndIf 
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
                  
                  iparentnode                   ( anz_getObject3DIrrNode( *anz_object3d_child)  , anz_getObject3DIrrNode(*p_anz_Object3D )) ; verbinden
                  iPositionNode                 ( anz_getObject3DIrrNode( *anz_object3d_child)  , *anz_object3d_child\x , *anz_object3d_child\y , *anz_object3d_child\z )
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
                   irr_obj           = iCreateBillboard( *p_list_bill\width , *p_list_bill\height ) ; p_obj ist das anz_objekt3d().
                   iPositionNode     ( irr_obj , *p_anz_Object3D\x , *p_anz_Object3D\y , *p_anz_Object3D\z)
                   If irr_obj
                   
                       iMaterialTextureNode      ( irr_obj , anz_loadtexture( *p_list_bill\pfad,1) , 0)
                       *p_list_bill\id           = irr_obj
                       iMaterialTypeNode         ( irr_obj , *p_list_bill\irr_emt_materialtype )
                       iMaterialFlagNode         ( irr_obj , #EMF_LIGHTING , *p_list_bill\lighting & anz_islighting )
                       
                   Else 
                      ProcedureReturn 0
                   EndIf 
                                 
            ;}

         Case #anz_art_mesh
          
            ;{ mesh laden.
                ChangeCurrentElement         ( anz_Object3d() , *p_anz_Object3D )
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
         ; -------------------------------------------------------------------------------------------------------
         ; ------------- PAUSE --------------
         ; -------------------------------------------------------------------------------------------------------
         ; Questsystem anschauen...
         ; Sonne
         ; Plan @gemusoft.de
         
                     anz_AddDeleteAnimator ( anz_billboard()\id , AfterMsTime)
                  Else 
                     iFreeNode             ( anz_billboard()\id )
                  EndIf 
               EndIf 
               DeleteElement        ( anz_billboard()    )
               DeleteElement        ( anz_Object3d())
            
            Case #anz_art_lensflare
               
               ChangeCurrentElement ( anz_lensflare() , *p_anz_Object3D\id )
                  If AfterMsTime > 0
                     anz_AddDeleteAnimator ( anz_lensflare()\id , AfterMsTime)
                  Else 
                     iFreeNode            ( anz_lensflare()\id  )
                  EndIf 
               DeleteElement        ( anz_lensflare()    )
               DeleteElement        ( anz_Object3d())
            
            Case #anz_art_light
            
               ChangeCurrentElement ( anz_light() , *p_anz_Object3D\id )
                  If AfterMsTime > 0
                     anz_AddDeleteAnimator ( anz_light()\nodeID , AfterMsTime)
                  Else 
                      iFreeNode            ( anz_light()\nodeID  )
                  EndIf 
               DeleteElement        ( anz_light()    )
               DeleteElement        ( anz_Object3d() )
            
            Case #anz_art_mesh
            
               ChangeCurrentElement ( anz_mesh() , *p_anz_Object3D\id )
               
               If anz_mesh()\geladen 
               
                  ; collision löschen
                  If anz_mesh()          \Collisiontype       = #anz_ColType_solid
                     ; IrrRemoveCollisionGroupFromCombination ( anz_CollisionMeta_solid , anz_mesh()\collisionNodeID)
                  ElseIf anz_mesh()      \Collisiontype       = #anz_ColType_movable
                     ; IrrRemoveAnimator   ( anz_mesh() \nodeID , anz_mesh()\collisionanimator )
                  EndIf
                  
                  ; textures löschen
                  anz_freetexture          ( anz_gettexturebypfad( anz_mesh()\texture ))            ; die texturen löschen
                  anz_freetexture          ( anz_gettexturebypfad( anz_mesh()\texture_normalmap))   ; normalmap-texture löschen
                  
                  ; meshes löschen
                  ; If anz_mesh()\collisionNodeID
                     ; iFreeBody             ( anz_mesh()\collisionNodeID ) ; löscht body und node
                  ; Else  
                     If AfterMsTime > 0
                        anz_AddDeleteAnimator ( anz_mesh()\nodeID , AfterMsTime)  
                     Else 
                        iFreeNode             ( anz_mesh()\nodeID  )
                     EndIf
                  ; EndIf 
                  
                  
               EndIf 
               
               DeleteElement               ( anz_mesh()    )
               DeleteElement               ( anz_Object3d())
            Case #anz_art_particle
            
               ChangeCurrentElement ( anz_particle() , *p_anz_Object3D\id )
            
               If anz_particle()\geladen = 1
                  ; IrrAddStopParticleAffector ( anz_particle()\nodeID , 0 ) ; - Pause ... hier den irrlicht befehl evtl selber umcooden. und bei allen irraddstopparticle.. reinwerfen.
                  If AfterMsTime > 0
                     anz_AddDeleteAnimator ( anz_particle()\nodeID , AfterMsTime)
                  Else 
                     anz_AddDeleteAnimator ( anz_particle()\nodeID , 2000)
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
                     anz_AddDeleteAnimator ( anz_particle()\nodeID , AfterMsTime)
                  Else 
                     anz_AddDeleteAnimator ( anz_particle()\nodeID , 2000)
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
               iFreeNode           ( anz_billboard()\id )
               anz_billboard()\id = 0
            EndIf 
            
         Case #anz_art_lensflare
            
            ChangeCurrentElement ( anz_lensflare() , *p_anz_Object3D\id )
            iFreeNode            ( anz_lensflare()\id  )
            anz_lensflare        ()\id          = 0
         Case #anz_art_light
            
            ChangeCurrentElement ( anz_light() , *p_anz_Object3D\id )
            iFreeNode            ( anz_light()\nodeID)
            anz_light            ()\nodeID     = 0
            
         Case #anz_art_mesh
            
             *p_anz_mesh              = *p_anz_Object3D\id 
             
             If *p_anz_mesh\geladen  ; wenns noch geladen ist (laut variable)
                *p_anz_mesh\geladen  = 0
                If *p_anz_mesh\ShadowID 
                   iRemoveShadowNodeXEffect( *p_anz_mesh\ShadowID )
                EndIf 
                *p_anz_mesh\ShadowID = 0 ; wichtig: schatten als ungeladen markieren
                anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture ))            ; die texturen löschen
                anz_freetexture      ( anz_gettexturebypfad( *p_anz_mesh\texture_normalmap))   ; normalmap-texture löschen
                If *p_anz_mesh       \Collisiontype        = #anz_ColType_solid
                   ; IrrRemoveCollisionGroupFromCombination ( anz_CollisionMeta_solid , *p_anz_mesh\collisionNodeID)
                ElseIf *p_anz_mesh   \Collisiontype       = #anz_ColType_movable
                   ; IrrRemoveAnimator ( *p_anz_mesh\nodeID , *p_anz_mesh\collisionanimator )
                EndIf 
                ; If *p_anz_mesh\collisionNodeID
                   ; iFreeBody            ( *p_anz_mesh\collisionNodeID ) ; löscht body und node
                ; Else  
                   iFreeNode            ( *p_anz_mesh\nodeID ) ; löscht shattennode automatisch mit.
                ; EndIf 
                ; IrrRemoveMesh        ( *p_anz_mesh\meshID )
                *p_anz_mesh\nodeID   = 0
                *p_anz_mesh\meshID   = 0
                ProcedureReturn      1
               
            EndIf
            
         Case #anz_art_particle
            
            ChangeCurrentElement ( anz_particle() , *p_anz_Object3D\id )
            
            If anz_particle()\geladen = 1
               ; IrrAddStopParticleAffector ( anz_particle()\nodeID , 0 )
               anz_AddDeleteAnimator       ( anz_particle()\nodeID , 2000 )
               anz_particle()\geladen = 0
               anz_particle()\nodeID  = 0
            EndIf 
            
         Case #anz_art_sound3d
             
             ; kannma nicht removen.... hm.. naj..a..
            
         Case #anz_art_terrain
            
            ChangeCurrentElement ( anz_terrain() , *p_anz_Object3D\id )
            If anz_terrain       ()\geladen = 1
               iFreeNode         ( anz_terrain()\nodeID )
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
; ende ()
; IDE Options = PureBasic 4.40 (Windows - x86)
; CursorPosition = 108
; FirstLine = 77 
; jaPBe Version=3.9.12.818
; FoldLines=008900910099009B009D009F00A100A300A500A700A900B100B300BB00D10198
; FoldLines=019A019C019E01A001A201A401A601A801AA01AC01BB01C201C401DB01EA01F1
; FoldLines=01F301FB01FD01FF020E0219021B02270229022C022F02330235024C024E0263
; FoldLines=02650269026B026F02710294029802C302C502EA02EC034A034C0381038303B3
; FoldLines=03B503FD03FF043D04850494049804B604B804D504D904E604E8054404ED0000
; FoldLines=052900000548055405560558055A055C055E0560056205640566058305850588
; FoldLines=058A058C058E05900592059405960598059A059C059E05A105A305A505A705A9
; FoldLines=05AD05AF05B305DD05D5000005F005FC05FE06230625063D063F06570659066D
; FoldLines=066F06850687069E06A006A706A906B206B606ED06EF06F306F507030705070D
; FoldLines=070F072B079707D607D807FF0801082308250837083908AF083E000008630000
; FoldLines=086C0000087900000884000008B108BA08BC08EE08F009000902090D090F091B
; FoldLines=091F094409460955095709630967098C09F409FA0A1F0A210A250A430A470A49
; FoldLines=0A9E0B2A0B2E0B9D0BA10BA30BA70BEA0C6D0CB00CB40CE20D4E0D500D540D5D
; FoldLines=0D5F0D700D6100000D720D850D870D910DC00DCF0DD10DE80DEA0DF50DF70DFC
; FoldLines=0E030E0D0E0F0E190E1B0E320E340E3F0E410E4C0E4E0E590E5B0E680E6E0EC0
; FoldLines=0EC40ED40ED60F790F7B0FC70F9600000FA400000FB000000FFC103C10080000
; FoldLines=101C00001040104110451046108B10B510B910E210E6110B110F11301134113D
; FoldLines=11491198117F0000118D0000119C119F11A311D311E011EE11F211F411F811FF
; FoldLines=120112171242128212480000126100001303135F
; Build=0
; FirstLine=1079
; CursorPosition=3489
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF