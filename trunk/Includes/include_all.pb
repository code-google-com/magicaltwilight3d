UsePNGImageDecoder()
ExamineDesktops   ()

#programmname  = "Magical Twilight (C)Gemusoft"  ; der name des programms ( wird in der headleiste angezeigt etc.)
IncludePath #PB_Compiler_Home + "includes\"
IncludeFile #PB_Compiler_Home + "includes\irrlichtwrapper_include.pbi" ; irrlicht wrapper für Irrklang und IrrXML von THALIUS
IncludeFile #PB_Compiler_Home + "includes\n3xtD_PB.pbi" ; irrlicht wrapper von T-myke für 3d anzeige und Physik ^^
IncludePath "include structures\"
IncludeFile "include_teams_structure.pb"
IncludeFile "include_GUIs_Structure.pb"
IncludeFile "include_anzeige_structure.pb"
IncludeFile "include_waypoint_structure.pb"
IncludeFile "include_wesen_structure.pb"
IncludeFile "include_wegfindung_structure.pb"
IncludeFile "include_spieler_structure.pb"
IncludeFile "include_kampfsystem_structure.pb"
IncludeFile "include_animation_structure.pb"
IncludeFile "include_math_structure.pb"
IncludeFile "include_item_structure.pb"

;{ Declarations Anzeige
Declare anz_freenode( *p_anz_Object3D.anz_Object3d , ISdeletechildren.i = 1 ) ; löscht nur die Irrlicht sachen, nicht die Nodes. (zum auslagern etc.)
Declare anz_freemesh( *p_anz_mesh.anz_mesh ) ; gibt das Mesh frei zum späteren Neuladen (Auslagern)
Declare anz_updateDeleteAnimator()  ; manages the deletion of an irrlicht object after XX miliseconds. 
Declare anz_AddDeleteAnimator(irrnode, TimeTolive) ; in milliseconds
Declare anz_delete_object3d( *p_anz_Object3D.anz_Object3d , AfterMsTime.i = 0 , ISdeletechildren.i = 1) ; löscht mesh und alles weitere KOMPLETT + das object 3d. (z.b. wenn etwas tot ist.)
Declare anz_dropstuff()  ; .. 1. BETA Dinge können herunterfallen.
Declare anz_displayImages()
Declare anz_setShownObjects(Camera) ; lädt und löscht objekte, wenn sie nah bzw. fern sind. (resourceschonung)
Declare anz_GetMeshMaterialDetail ( ListObjectID.i , MaterialType.i , isparallax.w=1, isnormal.w=1) ; schaut, ob das Material parallaxmapped ist, wenn das gewünscht ist usw..
Declare anz_setMeshMaterial ( ListObjectID.i , MaterialType.i , isparallax.w=1 , isnormal.w=1 ) ; Versucht, Mesh material zu parallax zu schalten, wenn nicht möglich -> andere technik.
Declare anz_updateinput()
Declare anz_updatesound()
Declare anz_updateview()   ; anzeigen der Welt, Gui usw. rendern. (irrlicht-based.)
Declare anz_updateparticles() ; schaut, ob Clouds, Staub, Feuer etc stimmt, oder gelöscht werden bzw. verschoben werden muss.
Declare anz_map_save (pfad.s)
Declare anz_map_load( pfad.s , map_pfad.s = #pfad_maps)
Declare anz_XMLLoadMap(*CurrentNode , map_pfad.s  )  ; Funktion für anz_map_load; nicht für eigennutzen gedacht.
Declare.s anz_peeks ( *p_text.i ) ; procedur, die vorher prüft, ob der pointer nicht 0 ist ;) 
Declare anz_Map_MaterialtypeFromText ( text.s )
Declare anz_initstuff(IsFullscreen ) ; auflösung usw. wird aus anzeige_preferences.pref gelesen.
Declare anz_shader_AddProcessing( name_GL.s, name_DX.s, Value.f) ; add postprocess. 
Declare anz_shader_EffectRender(Index.l)  ; shader renderer für post processing
Declare anz_shader_CallbackShader(*services.IMaterialServices,  userData.l)  ; shader callback für die postprocessing shader
Declare anz_setfog_particle ( enable.w , fogdepth.f= 400)
Declare anz_addstaubwirbel( x.f,y.f,z.f, Lebensdauer.i = 1000, particle_per_second = 80)
Declare anz_addcloud ( x.f,y.f, z.f , bewegx.f =0.001, bewegy.f = 0, bewegz.f= 0.001 )
Declare anz_addterrain( pfad.s, x.f,y.f,z.f, texture1.s , texture2.s ,texturescalex.f , texturescaley.f , width.f , height.f , Depth.f , MaterialType.i =#IRR_EMT_DETAIL_MAP , scalx.f=1,scaly.f=1,scalz.f=1, rotx.f=0,roty.f=0,rotz.f=0) ; width, height depth sind die extents.
Declare anz_addfire (x.f,y.f,z.f, firesize.f = 10, horbarrange = 1000 , texture.s = #pfad_feuer_texture , SoundPfad.s = #pfad_feuer_sound )
Declare anz_addparticle (  x.f,y.f,z.f,texture.s, normalmap.s , MaterialType.i , anz_particle_art = #anz_particle_art_default , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0 , box_x.f = 10, box_y.f = 10, box_z.f = 10, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = 16 , particleheight.f = 16 , min_startcolor.i = 0, max_startcolor.i = 1, max_angle_degrees.f = 45, min_lifetime.i = 1000 , max_lifetime.i = 1500 , If_IsRingThickness.f = 20) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
Declare anz_setwater( *p_obj3d.anz_Object3d, waveHeight.f , waveSpeed.f,waveLength.f, MaterialType.i =#IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER)
Declare anz_addsound3d ( pfad.s, x.f,y.f,z.f,maxdistance.f,mindistance.f , looped.i = 1) 
Declare anz_addlight( RGBcolor.i, x.f,y.f,z.f, range.f)
Declare anz_AddBillboard( pfad.s, x.f,y.f,z.f , width.f , height.f , MaterialType.i = #IRR_EMT_TRANSPARENT_ADD_COLOR , DirectLoad.i = 0)
Declare anz_addmesh( pfad.s, x.f,y.f,z.f, texture.s , MaterialType.b , normalmap.s , DirectLoad.b = 0 , IsAnimMesh.i = 0, Collisiondetail.b = #anz_col_box , Collisiontype.b = #anz_ColType_solid , rotx.f=0,roty.f=0,rotz.f=0,scalx.f=1,scaly.f=1,scalz.f=1, islighting.i = 0 , width.f = #meter * 3 , height.f = #meter*4 , Depth.f = #meter * 3)
Declare anz_freetexture (*anz_texture.anz_texture )  ; erst wenn der zähler wieder auf 0 ist wird Textur gelöscht.
Declare anz_gettexturebypfad( pfad.s) ; gibt anz_textureID raus, nicht irrtexture!
Declare anz_loadtexture( pfad.s,returnIrrID = 0)  ; wenn 2*die gleiche textur: zähler mitlaufen lassen. beim löschen wird erst wenn zähler wieder = 0 -> die textur gelöscht
Declare anz_freeimage(NR.i)
Declare anz_hideimage (NR.i , hide.b)
Declare anz_setImageForeground ( NR.i )
Declare anz_getimageID( NR.i)
Declare anz_getimagepos( NR.i ,*x.f,*y.f)
Declare anz_setimagepos ( NR , x.f,y.f)
Declare anz_loadimage( NR.i, x.f , y.f , pfad.s, Usealpha.b= 1, ishidden.b = 1 , rectX.f = 0 , rectY.f = 0 , rectwidth.f = -1 , Rectheight.f = -1) ; gibt immer die NR des images heraus! keinen Pointer.
Declare anz_RemoveImageRect ( NR.i ); bild wird wieder komplett angezeigt ( nicht mehr zugeschnitten)
Declare anz_SetImageRect( NR.i , rectX.f , rectY.f , width.f, height.f ) ; bild wird zugeschnitten und nur ein teil davon angezeigt. wenn width/height = -1, wird das jeweilige teil ignoriert.
Declare.f anz_getGravity  ()
Declare anz_MeshisGeladen ( *anz_mesh.anz_mesh )
Declare anz_IsParallaxmappingEnabled()
Declare anz_enable_parallaxmapping( enable.w)
Declare anz_IsNormalmappingEnabled()
Declare anz_enable_lighting  ( enable.w)
Declare anz_IsLightingEnabled()
Declare anz_enable_fog ( enable.w)
Declare anz_IsFogEnabled()
Declare anz_enable_normalmapping( enable.w)
Declare anz_enable_shadow( enable.i)
Declare anz_IsShadowEnabled()
Declare.w anz_MouseWheelDelta(); returns the mousewheelvalue.
Declare anz_mousex()
Declare anz_mousey()
Declare anz_MouseDeltaX()
Declare anz_MouseDeltaY()
Declare anz_mouseinbox ( x.w , y.w , width.w , height.w ) ; returns1, if mouse is in box.
Declare.w anz_getscreendepth()
Declare.w anz_getscreenheight()
Declare.w anz_getscreenwidth ()
Declare anz_setresolution(x,y,Depth,ISNeustart=1)
Declare anz_particle_changeflags ( *p_particle.anz_particle , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = #anz_any , particleheight.f = #anz_any, max_angle_degrees.f = #anz_any, min_lifetime.i = #anz_any , max_lifetime.i = #anz_any , If_IsRingThickness.f =#anz_any) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
Declare anz_particle_Set_Particles_Per_second_temporary( *p_particle.anz_particle , min_particles_per_second.f , max_particles_per_second.f , Size.f)
Declare anz_raster_Unregister ( *Object3dID.anz_Object3d) 
Declare anz_Raster_Register ( *Object3dID.anz_Object3d )
Declare anz_turnObject ( *Object3dID.anz_Object3d , rotx.f , roty.f , rotz.f , rotart = #anz_rotart_xyz)
Declare anz_moveObject ( *Object3dID.anz_Object3d , Forward.f , right.f , up.f )   ; bewegt  Object3d, wenn geladen auch IRRNODE. wobei: wenn Irrnode hängt: object3d\xyz = irrnode\xyz
Declare anz_setobjectPos ( *Object3dID.anz_Object3d , Posx.f , Posy.f , Posz.f  )  
Declare anz_setmeshscale ( *anz_mesh.anz_mesh  , scalex.f , scaley.f , scalez.f )
Declare anz_getobject3dIsGeladen ( *p_anz_Object3D.anz_Object3d) ; prüft, ob das IRRNODE geladen ist. 
Declare anz_getObject3DIrrNode ( *p_anz_Object3D.anz_Object3d)
Declare anz_getobject3dByNodeID( nodeID.i  ) ; sucht das zugehörige object 3d zum IRR Node
Declare anz_getobject3dByAnzID( *AnzID.i  , anz_art.i = #anz_art_mesh ) ; sucht das zugehörige object 3d zum Anz_..id ; bsp: anz_art = #anz_art_mesh
Declare anz_getMeshPosition( *anz_mesh.anz_mesh ,*px.i , *py.i , *pz.i ) ; @x , @y , @z!! if = 0 -> ignored.
Declare anz_attachobject (*Object3dID.anz_Object3d  , *Object3dID_child.anz_Object3d , x = 0 , y = 0 , z = 0 , ParentID_IS_BONE.s ="" ) ; Child an Parent festkleben. wenn ParentID_IS_BONe, so wird der hier angegebene Knochen des OBJECT3DIDs als Parent gewählt(standardmäßig somit auf Position 0,0,0)
Declare anz_getBoneNodeID (*p_anz_mesh.anz_mesh , bonename.s )
Declare.f anz_getObjectScreenDepth ( x.f,y.f,z.f, ObjectDepth.f )
Declare.f anz_getObjectScreenWidth ( x.f,y.f,z.f, Objectwidth.f )
Declare.f anz_getObjectScreenHeight ( x.f,y.f,z.f, ObjectHeight.f )
Declare anz_IsPauseGame()
Declare anz_pauseGame(Pausenart , Activate = 1)  ; Pausenart = Warum pause gemacht wird (z.b. #anz_pause_gui für inventar etc.)
Declare anz_error(text.s, isIrrlichtRunning = 0)
Declare anz_loadpreferences()
Declare anz_savepreferences()
Declare anz_ende() ; beendet das ganze, ohne jegliches Speichern!!! nicht fürn hausgebraucht"!
Declare anz_Skybox( texture_up.s, texture_down.s , texture_left.s , texture_right.s, texture_front.s , texture_back.s  )
Declare anz_ExaminedNodeIrrID()
Declare anz_ExaminedNodeObj3DID()
Declare anz_ExaminedNodeArt() ; ob light, mesh, particle usw.
Declare anz_ExaminedNodeAnzID()  ; z.b. ListID von anz_mesh()
Declare anz_NextExaminedNode()
Declare anz_ExamineLoadedNodes( ToSearch_Object_art.w , only_they_in_view.b = 1 , max_distance.f = #meter * 100 , bezugX.f = -1 , bezugY.f=-1, bezugZ.f=-1) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
Declare anz_mousebutton( ButtonNR , anz_mouseevent_art = -1)
Declare anz_mousebutton_Mouseevent ( ButtonNR ) ; gibt die #anz_MouseEvent_pressed zurück.
Declare anz_reload_object3d( *p_anz_Object3D.anz_Object3d ) ; ein object3d wird wieder geladen, wenn es aus'm speicher gefreed wurde; rückgabe: irr_objID -> nur Mesh und billboard..?????? wtf
Declare anz_unchild ( *Object3dID.anz_Object3d , only_one_child.w =1) ; removes every child-parent connection in children and childchildren, if only_one_child = 0 (for example when a wesen dies)
Declare anz_unloadChildren (*Object3dID.anz_Object3d ) 
Declare anz_IsObject3dParent ( *Object3dID.anz_Object3d ) ; prüft, ob obj3d ein PARENT ist.
Declare anz_IsObject3dChild ( *Object3dID.anz_Object3d ) ; prüft, ob obj3d ein child eines andren objektes ist .
Declare anz_ReConnectChildren2Parents( *p_anz_Object3D.anz_Object3d ) ; neuverknüpfung aller child-parent bindungen. (irrlicht-mäßig)
;}


;{ Declarations
Declare E3D_GetExtentTransformed ( nodeID.i , *x.f , *y.f , *z.f)
Declare E3D_getNoderotation( nodeID.i , *x.f , *y.f , *z.f ) ; schreibt die x-y und z- werte direkt in die Variablen xyz. -> Speicheraddresse angeben, nicht x-wert!!! (@-zeichen vor variable)
Declare E3D_getNodePosition( nodeID.i , *x.f , *y.f , *z.f ) ; schreibt die x-y und z- werte direkt in die Variablen xyz. -> Speicheraddresse angeben, nicht x-wert!!! (@-zeichen vor variable)
Declare e3d_cameraupvector ( nodeID.i , *x.f , *y.f , *z.f )
Declare e3d_targetCamera ( CameraID.i , x.f , y.f , z.f )
;}

;{ Declarations wegfindung
Declare.s weg_GetPath( StartID.i , ZielID.i , max_knoten.i ) ; StartID und ZielID sind waypointIDs.
Declare.s weg_outputpath()  ; läufte den pfad rückwärts von ziel zu start.
Declare weg_getleastfwert () ; gibt listenelement mit am wenigsten Fwert aus.
Declare weg_clearknoten()  ; löscht alle knoten-veränderungen. (aufräumen nach wegfindung)
Declare weg_calcneighbours( *waypointid.WAYPOINT ,*way_ZielID.WAYPOINT  ) ; zielid wird für "H-wert" benötigt.. (abstand vom ziel)
Declare weg_addclearknoten ( *knotenID.i ) ; ... die chance, dass die procedur benötigt wird geht gegen null.. man braucht ja nur die gesch und offliste zu clearen..(und deren gespeicherte waypoints)
Declare weg_inserttoopenlist( *waypointid.WAYPOINT , Fwert.f = -1)
Declare weg_inserttogeschlist ( *waypointid.WAYPOINT  , Fwert.f = -1)
Declare weg_remove_from_openlist (*knotenID )
;}
;{ Declarations math
Declare math_IrrFaceTargetPerPos ( *src.irr_node, x.f , y.f , z.f )  ; ist hier  in Mathinclude, weil in irrlicht-include des ganze leicht überschrieben wird (z.b. bei neuer irrlicht vers.)
Declare math_IrrFaceTarget ( *src.irr_node, *target.irr_node)
Declare.f math_FiToRad ( Fi.f)  ; rechnet Grad in RAD um ;)
Declare.f math_RadToFi ( Rad.f)  ; rechnet RAD in Grad um ;)
Declare math_iseven(zahl.i)
Declare.f math_distance3d(x.f,y.f,z.f,x1.f,y1.f,z1.f)
Declare.f math_square_distance3d(x1.f, y1.f, z1.f, x2.f, y2.f, z2.f)
Declare.f math_square_distance2d(x1.f, y1.f, x2.f, y2.f)
Declare.f math_FixFi  ( Fi.f) ; Winkel Fi darf nicht über 360° groß sein -> umrechnen. (auch nicht kleiner als 0..)
Declare.f math_betrag ( zahl.f ) ; gibt den Betrag (positiven wert) der Zahl aus.
Declare   math_IsFiInBereich( Fi.f, Startfi.f , Endfi.f) ; wobei die fis auch richtig umgerechnet  werden (+360,-360) etc.
;}
;{ Declarations spieler
Declare spi_GetCameraDistance()
Declare DMX_Freelook(action.i, MXS.f , MYS.f ,  Velocity.f=1.01, speed.f=0.05, Damping.f=5.0)
Declare spi_ExamineCamera() 
Declare spi_RotateCamera(vertical.f)
Declare spi_SetCameraDistance(distance.f)
Declare spi_FixCamera(*node)
Declare spi_DefinePlayerCamera(spi_camera_)
Declare spi_send_Network()
Declare spi_UpdateNetwork()
Declare spi_setspielermagie( *SpielerID.spi_spieler)
Declare spi_setspielerschwertangriff( *SpielerID.spi_spieler)
Declare spi_setspielerbogenschiessen( *SpielerID.spi_spieler ) ; im spieler-array sind 3d model und bogen gespeichert )
Declare spi_is_Jump ( *SpielerID.spi_spieler , jumpart = #spi_jump_normal)  ; schaut, ob der spieler gerade in der Luft ist. 
Declare spi_jump( *SpielerID.spi_spieler , jumpart = #spi_jump_normal ) ; löst das springen aus. also nur auslöser. + animateion start
Declare spi_setspielerlocate ( *SpielerID.spi_spieler , x.f , y.f , z.f ) ; only move without animate
Declare spi_move_spielerleft ( *SpielerID.spi_spieler , amount.f) ; anim +move
Declare spi_move_spielerright( *SpielerID.spi_spieler,amount.f) ; anim +move
Declare spi_move_spielerforward( *SpielerID.spi_spieler , amount.f)  ; anim spieler + bewegen 
Declare spi_GetPlayerNode( *SpielerID.spi_spieler)  ; gibt das irr_node zurück
Declare spi_GetSpielerWesenID (*SpielerID.spi_spieler )
Declare spi_getcurrentplayer()   ; gibt den eigenen Spieler zurück.
Declare spi_addspieler ( x.f,y.f,z.f, leben.w , maxleben.w , mana.w , maxmana.w , Name.s , Team.s , IsCurrentSpieler.b = 1)  ; erstellt neues 3D Wesen!! und den spieler 
Declare spi_GetSpielerRustung ( *SpielerID.spi_spieler )
Declare spi_setSpielerRustung ( *SpielerID.spi_spieler , *itemID.ITEM )
Declare spi_getspielerSchwert ( *SpielerID.spi_spieler ) ; returns ITEMID of current weapon
Declare spi_setspielerschwert ( *SpielerID.spi_spieler , *itemID.ITEM )
Declare spi_inventar_UseItemPerInventarID ( *SpielerID.spi_spieler , InventarID)
Declare spi_deleteItemOfInventar ( *SpielerID.spi_spieler , InventarID )
Declare spi_inventar_IsSackActive( *SpielerID.spi_spieler , SackNR) ; schaut, ob sack nutzbar ist.
Declare spi_inventar_UseItem ( *SpielerID.spi_spieler , *itemID.ITEM)  ; benutzt die Items.. entweder, wenn Waffe, dann nehmen, Apfel essen etc.
Declare spi_inventar_SwapItems( *SpielerID.spi_spieler , InventarItemNR1 , InventarItemNR2) ; tauscht die items im inventar; inventaritemNR = itemNR*sack.(kein POinter!)
Declare spi_inventar_removeItem ( *SpielerID.spi_spieler , *itemID.ITEM) ; drop a Item again.
Declare spi_Inventar_AddItem ( *SpielerID.spi_spieler , *itemID.ITEM)
Declare spi_inventar_getItem     ( *SpielerID.spi_spieler , InventarItemNR) ; gibt die ItemID des akteullen Items heraus. inventaritemnr ist (gui_itemNR+1)+(Sack-1)*99, kein pointer! 
Declare spi_Inventar_SearchItem ( *SpielerID.spi_spieler , Itemname.s , ItemArt.i ,ExceptionItemID=0) ; sucht bei 1. priorität nach der art, danach nach dem namen.
Declare spi_revive  ( *SpielerID.spi_spieler , x.f , y.f , z.f ) ; Wiederbelebung des spielers .. er darf nicht komplett sterben dürfen.
Declare spi_SetSpielerTargetnodeRot ( Rot.f ) ; dreht das Targetnode des Hauptspielers um XX grad.
Declare.f spi_GetSpielerTargetNodeRot (  ) 
Declare spi_SetSpielerTargetnodeMotion ( speed.f) ; bewegung of the player's main figure 

;}
;{ Declarations wesen
Declare wes_UpdateWesen(*WesenID.wes_wesen) ; regelt Grundverhalten (instinkte) und komplette Animation der Wesen. + bewegen, kämpfen, etc
Declare wes_SetWesenWaypoint(*WesenID.wes_wesen, waypoint)
Declare wes_GetWesenWaypoint(*WesenID.wes_wesen)
Declare wes_FlieFromGegner(*WesenID.wes_wesen , *gegnerid.wes_wesen)
Declare wes_defend             ( *WesenID.wes_wesen , *gegnerid.wes_wesen , callforhelp)
Declare wes_Stand              ( *WesenID.wes_wesen  ) ; direktes Angreifen. 
Declare wes_AttackGegner(*WesenID.wes_wesen  , *GegnerWesenID.wes_wesen , Check_Sichtweite.i = 1) ; direktes Angreifen. 
Declare wes_SetMoveWesenToWaypoint(*WesenID.wes_wesen  , *waypointid.WAYPOINT )
Declare wes_Examine_get_WesenID ()
Declare wes_Examine_get_GegnerID ()
Declare wes_Examine_get_Action ()
Declare wes_Examine_get_Team ()
Declare.s wes_Examine_get_Name ()
Declare wes_Examine_get_Art ()
Declare wes_Examine_get_Mana ()
Declare wes_Examine_get_Leben ()
Declare wes_Examine_get_WaffeItemID ()
Declare wes_Examine_get_IrrNode ()
Declare wes_Examine_get_Object3dID ()
Declare.f wes_Examine_get_Distance () ; gibt die Camera-Distance heraus
Declare wes_Examine_get_AnzMeshID ()
Declare wes_examine_Next()
Declare wes_getAnzMeshID( *WesenID.wes_wesen)
Declare wes_Examine_Reset( IrrZentrumNode.i  , only_they_in_view.b = 1 , max_distance.f = #meter * 10  ) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
Declare wes_getAction ( *WesenID.wes_wesen)
Declare wes_MoveWesenToPosition ( *WesenID.wes_wesen , x.f , y.f , z.f)
Declare wes_MoveWesenToWaypoint( *WesenID.wes_wesen , *waypointid.WAYPOINT ) ; bewegt ein Wesen direkt (irrlicht based) ; prüft vorher die bodenhöhe
Declare wes_is_geladen  ( *WesenID.wes_wesen )
Declare wes_getposition ( *WesenID.wes_wesen , *x.f , *y.f , *z.f) ; needs @*x , @y,@z.f
Declare.s wes_getname ( *WesenID.wes_wesen)
Declare wes_getTeam ( *WesenID.wes_wesen) ; gibt den Pointer zum aktuellen TEAM des wesens aus (falls vorhanden.
Declare wes_setname ( *WesenID.wes_wesen , Name.s)
Declare wes_GetWaypointPfadID ( *WesenID.wes_wesen)  ; gibt die WaypointID des aktuellen Ziel-Waypionts aus.
Declare wes_getNodeID    ( *WesenID.wes_wesen)
Declare wes_getdistance  ( *wesen1.wes_wesen , *wesen2.wes_wesen)
Declare wes_SetWesenCommand(*WesenID.wes_wesen, wes_action_action.i )
Declare wes_SetMana ( *WesenID.wes_wesen ,mana  )
Declare wes_GetMana ( *WesenID.wes_wesen )
Declare wes_SetLeben ( *WesenID.wes_wesen , leben)
Declare wes_GetLeben ( *WesenID.wes_wesen )
Declare wes_GetWesenMaxMana ( *WesenID.wes_wesen )
Declare wes_GetWesenMaxLeben ( *WesenID.wes_wesen)
Declare wes_setWesenWaffe  ( *WesenID.wes_wesen , *itemID.ITEM )
Declare wes_removewaffe ( *WesenID.wes_wesen) ; aktuelle Waffe ohne Anim. aus Hand löschen, sofern vorhanden.
Declare wes_RemoveWesen(*WesenID.wes_wesen)
Declare wes_KillWesen( *WesenID.wes_wesen)
Declare wes_AddWesen ( Name.s, x.f , y.f , z.f , Team.s , maxleben.i , speed.f , pfad.s , texture1.s , texture2.s , MaterialType.i , Isdirectload.i = 0 , SpielerID.i = 0 , art.i =#wes_art_schwert , action.i = #wes_action_stand ,  AnimNR.i = 0 , animlist.s = #ani_Animlist_Standard) ; wobei team: siehe #team_wesen_bundnis_...)
Declare.f wes_getReichweite ( *WesenID.wes_wesen ) ; gibt Reichweite des wesens zurück.
;}
;{ Declarations team
Declare team_AddTeam           ( Name.s ) ; fügt ein neues Team hinzu. bzw. wenn schon vorhanden, wirds nur ergänzt.
Declare team_GetFreundLevel    ( *Team1.team , *Team2.team) ; schaut, wie stark man befreundet ist.
Declare Team_GetFeindLevel     ( *Team1.team , *Team2.team) ; schaut, wie stark man verfeindet ist 
Declare Team_SetTeamVerhaltnis ( *Team1.team , *Team2.team , Verhaltnis = #team_verhaltnis_neutral ); Freund/feind- Level .. siehe  #team_verhaltnis...
Declare team_IsFreund          ( *Team1.team  , *Team2.team ) ; prüft, ob *team2 ein Freund von *team1 ist.. nicht umgekehrt.
;}
;{ Declarations animation
Declare ani_updateanim             ( *p_anz_mesh.anz_mesh )  ; wird direkt bei anzeigeengine eingebaut 
Declare ani_IsAnimationFree        ( *p_anz_mesh.anz_mesh)
Declare ani_getaniminterruptable   ( *p_anz_mesh.anz_mesh) ; schaut, ob die animaton unterbrochen werden kann für eine nächste (z.b bei springen kann man nicht in luft laufen => not interuptable)
Declare ani_setaniminterruptable   ( *p_anz_mesh.anz_mesh , SetInterruptable)
Declare ani_setanimRangeByNR       ( *p_anz_mesh.anz_mesh , AnimationNR.i , Animationname.s , startframe.i , endframe.i ) 
Declare ani_setanimranges          ( *p_anz_mesh.anz_mesh , Animationdata.s ) ; an.data =animname.s + "|"+str(startframe) + "|" + str(endframe)+ "|"
Declare ani_stopanim               (  *p_anz_mesh.anz_mesh ) ; wenn stoppbar, dann result = 1
Declare ani_Setanimlooped          ( *p_anz_mesh.anz_mesh, islooped)
Declare ani_GetAnimByName          ( *p_anz_mesh.anz_mesh, Name.s)  ; 
Declare ani_GetAnimGesch           ( *p_anz_mesh.anz_mesh)
Declare ani_setAnimGesch           ( *p_anz_mesh.anz_mesh , gesch.f)
Declare ani_getCurrentEndframe     ( *p_anz_mesh.anz_mesh) ; benötigt um zu prüfen, ob beim Bogenschießen der bogen schon gespannt ist, etc.
Declare ani_getCurrentStartframe   ( *p_anz_mesh.anz_mesh) ; benötigt um zu prüfen, ob beim Bogenschießen der bogen schon gespannt ist, etc.
Declare ani_getCurrentFrame        ( *p_anz_mesh.anz_mesh)
Declare ani_getCurrentAnimationNR  ( *p_anz_mesh.anz_mesh)
Declare ani_SetAnimSettings        ( *p_anz_mesh.anz_mesh , AnimationNR , islooped.w = 0, animationgesch.f = 1.0 , waitiffinished.w = 0 , animlist.s = "" ) ; p_anz_node = listiD von anz_mesh
Declare ani_SetAnim                ( *p_anz_mesh.anz_mesh , AnimationNR , islooped.w = 0 , animationgesch.f = 1.0 , waitiffinished.w = 0 )
;}
;{ Declarations item
Declare Item_GetGoldwert(*itemID.ITEM)
Declare.s Item_GetName(*itemID.ITEM)
Declare.s Item_getGuiText ( *itemID.ITEM ) ; gibt den gui-beschreibungstext aus.
Declare item_drop_item ( *itemID.ITEM)
Declare item_set_Captured ( *itemID.ITEM ) ; löscht das Item von 3D Welt, für Inventar; fügt sie aber nicht ins Inventar hinzu.
Declare Item_getNode ( *itemID.ITEM)
Declare item_waffe_GetWaffenart ( *itemID.ITEM)  ; gibt waffen/Zauberart aus.. siehe #item_waffe_..)
Declare item_waffe_getangriff( *itemID.ITEM)
Declare item_waffe_getReichweite ( *itemID.ITEM )
Declare item_examine_getDistance()
Declare item_examine_GetItemID() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare item_examine_GetObjID() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare item_examine_GetAnzID() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare item_examine_GetIrrNode() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare Item_examine_Next()
Declare Item_Examine_Reset( only_they_in_view.i = 1 , max_distance.f = 3*#meter  ) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
Declare Item_FocusItem_Reset ()  ; überprüft das Fokus-Item
Declare Item_getFocusItem()   ; gibt das Item, das direkt vor dem Spieler liegt zurück ( also die ItemID)
Declare Item_Delete(*itemID.ITEM)
Declare Item_AddDefined ( Name.s , x.f,y.f,z.f , DefinedItemNR.i )  ; erstellt ein vordeffiniertes Item (wichtig, wenn viele Items gleich sind.
Declare Item_Add (name$, x.f , y.f , z.f , goldwert , ItemArt.w , Betrag.w , Gewicht.f , pfad.s , texture1.s , texture2.s , MaterialType.i , gui_InventarImage.s ,GuiText.s ) ; betrag = z.b. lebensbonus, ; inventarimage = #gui_inventar_image_
Declare Item_AddWaffe ( *itemID.ITEM , angriff , Reichweite, Waffenart, gui_InventarBigImage.s)
;}
;{ Declarations kampfsystem
Declare kam_SchiesSchwert  ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen ) ; schlägt mit dem Schwert einmal zu.(Animation wird hier niht geretelt!!
Declare kam_UpdateKampfSystem()  ; pfeile etc. treffen lassen usw.
Declare kam_SchiesZauber ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen , kam_Zauber_NR.i) 
Declare kam_moveGeschoss ( *geschossID.geschoss ,bewegx.f , bewegy.f,bewegz.f) ; bewegt den Pfeil wieder weiter (fliegen)
Declare kam_getGeschossNodeID (*geschossID.geschoss )
Declare kam_SchiesPfeil ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen) ; schießt einen Pfeil in richtung gegner ab. (kann danebenfliegen)
;}
;{ Declarations waypoints
Declare way_getWegParent ( *waypointid.WAYPOINT) ; ebenfalls für Wegfindung.
Declare.f way_getWegWert  ( *waypointid.WAYPOINT , art ) ; gibt für Wegfindung #way_Weg_wertart_F,..G,..H wert heraus
Declare way_IsWaypointReached ( *WesenID.wes_wesen , *waypointid.WAYPOINT ) ; schaut, ob der Waypoint erreicht wurde.
Declare way_getwaypointPOS ( *waypointid.WAYPOINT , *x.i , *y.i , *z.i ) ; benötigt: @*x , @*y , @*z.
Declare.s way_GetPathByPosition ( *waypointid.WAYPOINT ,  x.f , y.f , z.f )
Declare.s way_getpathByWayPoint( *Waypoint1.WAYPOINT  , *Waypoint2.WAYPOINT) ; berechnet den Pfad von A nach B ( also die Waypoints von dort zu da.)
Declare way_getclosestwaypoint ( x.f , y.f , z.f )
Declare way_connectwaypoints ( *waypointid.WAYPOINT , *childpointID.WAYPOINT ) ; connects both waypoints to each other... also verbinden.. XD my english ^^.
Declare way_RemoveWaypoint(*waypointid.WAYPOINT )
Declare Way_AddWaypoint(x.f, y.f, z.f , *connectionid.i = -1) ; waypoint hinzufügen mit eventuellem Vorgänger-waypoint ( als 1. verbindung..)
Declare way_NextPathElement ( pfad_list.s )
;}

;{ Declarations GuiSystem
Declare gui_closeAll ( Exception.i  = 0) ; the exception will not be closed ;) (z.B. #gui_Status_HUD | #gui_status_map !
Declare gui_open_Map(Status)
Declare gui_openHUD(Status)
Declare gui_openQuestlog( Status ) ; nur wenn status = 0 wird questlog geschlossen.
Declare gui_getGUI ( )
Declare gui_setGUI ( GuiStatus.i = 600 ) ; guistatus = gui_Status_inventar z.b.
Declare Gui_openInventar( Open.i ) ; of open = 0: close it; CLOSE only hides the image!!
Declare gui_LoadImages()
Declare gui_IsInventarOpen()
Declare gui_updateGUI()
Declare gui_UpdateInventarView (*ExceptionItemID.i = 0)  ; updated die aktuell sichtbaren ITEMS, z.B. wenn der Sack gewechselt wurde.  ; exception= item, das nicht ausgeblendet wird (das gerade verschoben wird)
Declare Gui_GetSelectedInventarItem () ; returns the ID of the currently selected inventaritem.
Declare gui_getInventarItemPos ( Itemnr , *itemposx.i , *itemposy.i ) ; pointer zu *itemposx/y werden gebraucht..

;}

IncludePath "includes\"
IncludeFile "include_waypoint.pb"
IncludeFile "include_wesen.pb"
IncludeFile "include_wegfindung.pb"  ; include meien wegfindung.
IncludeFile "include_spieler.pb"
IncludeFile "include_GUIs.pb"
IncludeFile "include_anzeige.pb"
IncludeFile "include_teams.pb"
IncludeFile "include_kampfsystem.pb"
IncludeFile "include_item.pb"
IncludeFile "include_animation.pb"
IncludeFile "include_math.pb"
IncludeFile "include_3DEngine.pb"
 
; jaPBe Version=3.9.12.819
; Build=1
; FirstLine=29
; CursorPosition=36
; ExecutableFormat=Windows
; Executable=H:\GemuSoft\Gemusoft\max level.exe
; DontSaveDeclare
; EOF