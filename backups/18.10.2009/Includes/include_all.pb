UsePNGImageDecoder()
ExamineDesktops   ()

#programmname  = "Magical Twilight (C)Gemusoft"  ; der name des programms ( wird in der headleiste angezeigt etc.)
IncludeFile #PB_Compiler_Home + "includes\irrlichtwrapper_include.pbi"
IncludePath "include structures\"
IncludeFile "include_teams_structure.pb"
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
Declare anz_freenode( *p_anz_Object3D.anz_Object3d , ISdeletechildren.i = 1 ) ; l�scht nur die Irrlicht sachen, nicht die Nodes. (zum auslagern etc.)
Declare anz_delete_object3d( *p_anz_Object3D.anz_Object3d , AfterMsTime.i = 0 , ISdeletechildren.i = 1) ; l�scht mesh und alles weitere KOMPLETT + das object 3d. (z.b. wenn etwas tot ist.)
Declare anz_dropstuff()  ; .. 1. BETA Dinge k�nnen herunterfallen.
Declare anz_displayImages()
Declare anz_setShownObjects(Camera) ; l�dt und l�scht objekte, wenn sie nah bzw. fern sind. (resourceschonung)
Declare anz_GetMeshMaterialDetail ( ListObjectID.i , MaterialType.i , isparallax.w=1, isnormal.w=1) ; schaut, ob das Material parallaxmapped ist, wenn das gew�nscht ist usw..
Declare anz_setMeshMaterial ( ListObjectID.i , MaterialType.i , isparallax.w=1 , isnormal.w=1 ) ; Versucht, Mesh material zu parallax zu schalten, wenn nicht m�glich -> andere technik.
Declare anz_updateinput()
Declare anz_updatesound()
Declare anz_updateview()   ; anzeigen der Welt, Gui usw. rendern. (irrlicht-based.)
Declare anz_updateparticles() ; schaut, ob Clouds, Staub, Feuer etc stimmt, oder gel�scht werden bzw. verschoben werden muss.
Declare anz_map_save (pfad.s)
Declare anz_map_load( pfad.s , map_pfad.s = #pfad_maps)
Declare.s anz_peeks ( *p_text.i ) ; procedur, die vorher pr�ft, ob der pointer nicht 0 ist ;) 
Declare anz_Map_MaterialtypeFromText ( text.s )
Declare anz_initstuff(IsFullscreen ) ; aufl�sung usw. wird aus anzeige_preferences.pref gelesen.
Declare anz_setfog_particle ( enable.w , fogdepth.f= 400)
Declare anz_addstaubwirbel( x.f,y.f,z.f, Lebensdauer.i = 1000, particle_per_second = 80)
Declare anz_addcloud ( x.f,y.f, z.f , bewegx.f =0.001, bewegy.f = 0, bewegz.f= 0.001 )
Declare anz_addterrain( pfad.s, x.f,y.f,z.f, texture1.s , texture2.s ,texturescalex.f , texturescaley.f , width.f , height.f , depth.f , MaterialType.i =#IRR_EMT_DETAIL_MAP , scalx.f=1,scaly.f=1,scalz.f=1, rotx.f=0,roty.f=0,rotz.f=0) ; width, height depth sind die extents.
Declare anz_addfire (x.f,y.f,z.f, firesize.f = 10, horbarrange = 1000 , texture.s = #pfad_feuer_texture , SoundPfad.s = #pfad_feuer_sound )
Declare anz_addparticle (  x.f,y.f,z.f,texture.s, normalmap.s , MaterialType.i , anz_particle_art = #anz_particle_art_default , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0 , box_x.f = 10, box_y.f = 10, box_z.f = 10, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = 16 , particleheight.f = 16 , min_startcolor.i = 0, max_startcolor.i = 1, max_angle_degrees.f = 45, min_lifetime.i = 1000 , max_lifetime.i = 1500 , If_IsRingThickness.f = 20) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
Declare anz_setwater( *p_obj3d.anz_Object3d, waveheight.f , wavespeed.f,wavelength.f, MaterialType.b =#IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER)
Declare anz_addsound3d ( pfad.s, x.f,y.f,z.f,maxdistance.f,mindistance.f , looped.i = 1) 
Declare anz_addlight( RGBcolor.i, x.f,y.f,z.f, range.f)
Declare anz_AddBillboard( pfad.s, x.f,y.f,z.f , width.f , height.f , MaterialType.i = #IRR_EMT_TRANSPARENT_ADD_COLOR , DirectLoad.i = 0)
Declare anz_addmesh( pfad.s, x.f,y.f,z.f, texture.s , MaterialType.b , normalmap.s , DirectLoad.b = 0, Collisiondetail.b = #anz_col_box , Collisiontype.b = #anz_ColType_solid , rotx.f=0,roty.f=0,rotz.f=0,scalx.f=1,scaly.f=1,scalz.f=1, islighting.i = 0 , width.f = #meter * 3 , height.f = #meter*3 , depth.f = #meter * 3)
Declare anz_freetexture (IrrTextureID.i)  ; erst wenn der z�hler wieder auf 0 ist wird Textur gel�scht.
Declare anz_gettexturebypfad( pfad.s) ; wenn pfad nicht vorhanden: 0 herausgeben !
Declare anz_loadtexture( pfad.s)  ; wenn 2*die gleiche textur: z�hler mitlaufen lassen. beim l�schen wird erst wenn z�hler wieder = 0 -> die textur gel�scht
Declare anz_freeimage(NR.i)
Declare anz_hideimage (NR.i , hide.b)
Declare anz_getimageID( NR.i)
Declare anz_getimagepos( NR.i ,*x.f,*y.f)
Declare anz_setimagepos ( NR , x.f,y.f)
Declare anz_loadimage( NR.i, x.f , y.f , pfad.s, Usealpha.b, ishidden.b = 1) 
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
Declare anz_enable_shadow( enable.w)
Declare anz_IsShadowEnabled()
Declare.w anz_getscreendepth()
Declare.w anz_getscreenheight()
Declare.w anz_getscreenwidth ()
Declare anz_setresolution(x,y,depth,ISNeustart=1)
Declare anz_particle_changeflags ( *p_particle.anz_particle , direction_x.f = 0, direction_y.f = 0.3, direction_z.f = 0, min_particles_per_second.f = 340, max_particles_per_second.f = 500, particlewidth.f = -1 , particleheight.f = -1, max_angle_degrees.f = -1, min_lifetime.i = -1 , max_lifetime.i = -1 , If_IsRingThickness.f =-1) ; letzter Parameter wird nur bei partikelringen gebraucht! (ansonsten ignoriert)
Declare anz_particle_Set_Particles_Per_second_temporary( *p_particle.anz_particle , min_particles_per_second.f , max_particles_per_second.f , Size.f)
Declare anz_raster_Unregister ( *Object3dID.anz_Object3d) 
Declare anz_Raster_Register ( *Object3dID.anz_Object3d )
Declare anz_turnObject ( *Object3dID.anz_Object3d , rotx.f , roty.f , rotz.f , rotart = #anz_rotart_xyz)
Declare anz_moveObject ( *Object3dID.anz_Object3d , Forward.f , right.f , up.f )   ; bewegt  Object3d, wenn geladen auch IRRNODE. wobei: wenn Irrnode h�ngt: object3d\xyz = irrnode\xyz
Declare anz_setobjectPos ( *Object3dID.anz_Object3d , Posx.f , Posy.f , Posz.f  )  
Declare anz_setmeshscale ( *anz_mesh.anz_mesh  , scalex.f , scaley.f , scalez.f )
Declare anz_getobject3dIsGeladen ( *p_anz_Object3D.anz_Object3d) ; pr�ft, ob das IRRNODE geladen ist. 
Declare anz_getObject3DIrrNode ( *p_anz_Object3D.anz_Object3d)
Declare anz_getobject3dByNodeID( nodeID.i  ) ; sucht das zugeh�rige object 3d zum IRR Node
Declare anz_getobject3dByAnzID( *AnzID.i  , anz_art.i = #anz_art_mesh ) ; sucht das zugeh�rige object 3d zum Anz_..id ; bsp: anz_art = #anz_art_mesh
Declare anz_getMeshPosition( *anz_mesh.anz_mesh ,*px.i , *py.i , *pz.i ) ; @x , @y , @z!! if = 0 -> ignored.
Declare anz_attachobject (*Object3dID.anz_Object3d  , *Object3dID_child.anz_Object3d , x = 0 , y = 0 , z = 0 , ParentID_IS_BONE.s ="" ) ; Child an Parent festkleben. wenn ParentID_IS_BONe, so wird der hier angegebene Knochen des OBJECT3DIDs als Parent gew�hlt(standardm��ig somit auf Position 0,0,0)
Declare anz_getBoneNodeID (*p_anz_mesh.anz_mesh , bonename.s )
Declare.f anz_getmeshscreendepth( *p_anz_Object3D.anz_Object3d)
Declare.f anz_getmeshscreenwidth( *p_anz_Object3D.anz_Object3d)
Declare.f anz_getMeshScreenheight( *p_anz_Object3D.anz_Object3d  )  ; gibt die aktuelle Pixelh�he des Meshes auf dem Bildschirm zur�ck. (wie gro� es auf dem bildschirm ist.)
Declare.f anz_getObjectScreenDepth ( x.f,y.f,z.f, ObjectDepth.f )
Declare.f anz_getObjectScreenWidth ( x.f,y.f,z.f, Objectwidth.f )
Declare.f anz_getObjectScreenHeight ( x.f,y.f,z.f, ObjectHeight.f )
Declare anz_IsPauseGame()
Declare anz_pauseGame(IsPause)
Declare anz_error(text.s)
Declare anz_loadpreferences()
Declare anz_savepreferences()
Declare anz_ende() ; beendet das ganze, ohne jegliches Speichern!!! nicht f�rn hausgebraucht"!
Declare anz_Skybox( texture_up.s, texture_down.s , texture_left.s , texture_right.s, texture_front.s , texture_back.s  )
Declare anz_ExaminedNodeIrrID()
Declare anz_ExaminedNodeObj3DID()
Declare anz_ExaminedNodeArt() ; ob light, mesh, particle usw.
Declare anz_ExaminedNodeAnzID()  ; z.b. ListID von anz_mesh()
Declare anz_NextExaminedNode()
Declare anz_ExamineLoadedNodes( ToSearch_Object_art.w , only_they_in_view.b = 1 , max_distance.f = #meter * 100 , bezugX.f = -1 , bezugY.f=-1, bezugZ.f=-1) ; �berpr�ft, ob Nodes in der N�he sind (bzw. alle nodes �berhaupt z.b. zum material setzen)
Declare anz_mousebutton( ButtonNR , anz_mouseevent_art = -1)
Declare anz_reload_object3d( *p_anz_Object3D.anz_Object3d ) ; ein object3d wird wieder geladen, wenn es aus'm speicher gefreed wurde; r�ckgabe: irr_objID -> nur Mesh und billboard..?????? wtf
Declare anz_unchild ( *Object3dID.anz_Object3d , only_one_child.w =1) ; removes every child-parent connection in children and childchildren, if only_one_child = 0 (for example when a wesen dies)
Declare anz_unloadChildren (*Object3dID.anz_Object3d ) 
Declare anz_IsObject3dParent ( *Object3dID.anz_Object3d ) ; pr�ft, ob obj3d ein PARENT ist.
Declare anz_IsObject3dChild ( *Object3dID.anz_Object3d ) ; pr�ft, ob obj3d ein child eines andren objektes ist .
Declare anz_ReConnectChildren2Parents( *p_anz_Object3D.anz_Object3d ) ; neuverkn�pfung aller child-parent bindungen. (irrlicht-m��ig)


;}
;{ Declarations wegfindung
Declare.s weg_GetPath( StartID.i , ZielID.i , max_knoten.i ) ; StartID und ZielID sind waypointIDs.
Declare.s weg_outputpath()  ; l�ufte den pfad r�ckw�rts von ziel zu start.
Declare weg_getleastfwert () ; gibt listenelement mit am wenigsten Fwert aus.
Declare weg_clearknoten()  ; l�scht alle knoten-ver�nderungen. (aufr�umen nach wegfindung)
Declare weg_calcneighbours( *waypointid.WAYPOINT ,*way_ZielID.WAYPOINT  ) ; zielid wird f�r "H-wert" ben�tigt.. (abstand vom ziel)
Declare weg_addclearknoten ( *knotenID.i ) ; ... die chance, dass die procedur ben�tigt wird geht gegen null.. man braucht ja nur die gesch und offliste zu clearen..(und deren gespeicherte waypoints)
Declare weg_inserttoopenlist( *waypointid.WAYPOINT , Fwert.f = 0)
Declare weg_inserttogeschlist ( *waypointid.WAYPOINT  , Fwert.f = -1)
Declare weg_remove_from_openlist (*knotenID )
;}
;{ Declarations math
Declare math_IrrFaceTargetPerPos ( *src.irr_node, x.f , y.f , z.f )  ; ist hier  in Mathinclude, weil in irrlicht-include des ganze leicht �berschrieben wird (z.b. bei neuer irrlicht vers.)
Declare math_IrrFaceTarget ( *src.irr_node, *target.irr_node)
Declare.f math_FiToRad ( Fi.f)  ; rechnet Grad in RAD um ;)
Declare.f math_RadToFi ( Rad.f)  ; rechnet RAD in Grad um ;)
Declare math_iseven(zahl.i)
Declare.f math_distance3d(x.f,y.f,z.f,x1.f,y1.f,z1.f)
Declare.f math_square_distance3d(x1.f, y1.f, z1.f, x2.f, y2.f, z2.f)
Declare.f math_square_distance2d(x1.f, y1.f, x2.f, y2.f)
Declare.f math_FixFi  ( Fi.f) ; Winkel Fi darf nicht �ber 360� gro� sein -> umrechnen. (auch nicht kleiner als 0..)
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
Declare spi_jump( *SpielerID.spi_spieler , jumpart = #spi_jump_normal ) ; l�st das springen aus. also nur ausl�ser. + animateion start
Declare spi_setspielerlocate ( *SpielerID.spi_spieler , x.f , y.f , z.f ) ; only move without animate
Declare spi_move_spielerleft ( *SpielerID.spi_spieler , amount.f) ; anim +move
Declare spi_move_spielerright( *SpielerID.spi_spieler,amount.f) ; anim +move
Declare spi_move_spielerforward( *SpielerID.spi_spieler , amount.f)  ; anim spieler + bewegen 
Declare spi_GetPlayerNode( *SpielerID.spi_spieler)  ; gibt das irr_node zur�ck
Declare spi_GetSpielerWesenID (*SpielerID.spi_spieler )
Declare spi_getcurrentplayer()   ; gibt den eigenen Spieler zur�ck.
Declare spi_addspieler ( x.f,y.f,z.f, leben.w , maxleben.w , mana.w , maxmana.w , name.s , Team.s , IsCurrentSpieler.b = 1)  ; erstellt neues 3D Wesen!! und den spieler 
Declare spi_GetSpielerRustung ( *SpielerID.spi_spieler )
Declare spi_setSpielerRustung ( *SpielerID.spi_spieler , *itemID.ITEM )
Declare spi_getspielerSchwert ( *SpielerID.spi_spieler ) ; returns ITEMID of current weapon
Declare spi_setspielerschwert ( *SpielerID.spi_spieler , *itemID.ITEM )
Declare spi_inventar_UseItemPerInventarID ( *SpielerID.spi_spieler , InventarID)
Declare spi_deleteItemOfInventar ( *SpielerID.spi_spieler , InventarID )
Declare spi_inventar_UseItem ( *SpielerID.spi_spieler , *itemID.ITEM)  ; benutzt die Items.. entweder, wenn Waffe, dann nehmen, Apfel essen etc.
Declare spi_inventar_removeItem ( *SpielerID.spi_spieler , *itemID.ITEM) ; drop a Item again.
Declare spi_Inventar_AddItem ( *SpielerID.spi_spieler , *itemID.ITEM)
Declare spi_revive  ( *SpielerID.spi_spieler , x.f , y.f , z.f ) ; Wiederbelebung des spielers .. er darf nicht komplett sterben d�rfen.
Declare spi_SetSpielerTargetnodeRot ( Rot.f ) ; dreht das Targetnode des Hauptspielers um XX grad.
Declare.f spi_GetSpielerTargetNodeRot (  ) 
Declare spi_SetSpielerTargetnodeMotion ( speed.f) ; bewegung of the player's main figure 

;}
;{ Declarations wesen
Declare wes_UpdateWesen(*WesenID.wes_wesen) ; regelt Grundverhalten (instinkte) und komplette Animation der Wesen. + bewegen, k�mpfen, etc
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
Declare wes_Examine_Reset( IrrZentrumNode.i  , only_they_in_view.b = 1 , max_distance.f = #meter * 10  ) ; �berpr�ft, ob Nodes in der N�he sind (bzw. alle nodes �berhaupt z.b. zum material setzen)
Declare wes_getAction ( *WesenID.wes_wesen)
Declare wes_MoveWesenToPosition ( *WesenID.wes_wesen , x.f , y.f , z.f)
Declare wes_MoveWesenToWaypoint( *WesenID.wes_wesen , *waypointid.WAYPOINT ) ; bewegt ein Wesen direkt (irrlicht based) ; pr�ft vorher die bodenh�he
Declare wes_is_geladen  ( *WesenID.wes_wesen )
Declare wes_getposition ( *WesenID.wes_wesen , *x.f , *y.f , *z.f) ; needs @*x , @y,@z.f
Declare.s wes_getname ( *WesenID.wes_wesen)
Declare wes_setname ( *WesenID.wes_wesen , name.s)
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
Declare wes_removewaffe ( *WesenID.wes_wesen) ; aktuelle Waffe ohne Anim. aus Hand l�schen, sofern vorhanden.
Declare wes_RemoveWesen(*WesenID.wes_wesen)
Declare wes_KillWesen( *WesenID.wes_wesen)
Declare wes_AddWesen ( name.s, x.f , y.f , z.f , Team.s , maxleben.i , speed.f , pfad.s , texture1.s , texture2.s , MaterialType.i , Isdirectload.i = 0 , SpielerID.i = 0 , art.i =#wes_art_schwert , action.i = #wes_action_stand ,  AnimNR.i = 0 , animlist.s = #ani_Animlist_Standard) ; wobei team: siehe #team_wesen_bundnis_...)
;}
;{ Declarations team
Declare team_AddTeam           ( name.s ) ; f�gt ein neues Team hinzu. bzw. wenn schon vorhanden, wirds nur erg�nzt.
Declare team_GetFreundLevel    ( *Team1.team , *Team2.team) ; schaut, wie stark man befreundet ist.
Declare Team_GetFeindLevel     ( *Team1.team , *Team2.team) ; schaut, wie stark man verfeindet ist 
Declare Team_SetTeamVerhaltnis ( *Team1.team , *Team2.team , Verhaltnis = #team_verhaltnis_neutral ); Freund/feind- Level .. siehe  #team_verhaltnis...
Declare team_IsFreund          ( *Team1.team  , *Team2.team ) ; pr�ft, ob *team2 ein Freund von *team1 ist.. nicht umgekehrt.
;}
;{ Declarations animation
Declare ani_updateanim             ( *p_anz_mesh.anz_mesh )  ; wird direkt bei anzeigeengine eingebaut 
Declare ani_IsAnimationFree        ( *p_anz_mesh.anz_mesh)
Declare ani_getaniminterruptable   ( *p_anz_mesh.anz_mesh) ; schaut, ob die animaton unterbrochen werden kann f�r eine n�chste (z.b bei springen kann man nicht in luft laufen => not interuptable)
Declare ani_setaniminterruptable   ( *p_anz_mesh.anz_mesh , SetInterruptable)
Declare ani_setanimRangeByNR       ( *p_anz_mesh.anz_mesh , AnimationNR.i , Animationname.s , startframe.i , endframe.i ) 
Declare ani_setanimranges          ( *p_anz_mesh.anz_mesh , Animationdata.s ) ; an.data =animname.s + "|"+str(startframe) + "|" + str(endframe)+ "|"
Declare ani_stopanim               (  *p_anz_mesh.anz_mesh ) ; wenn stoppbar, dann result = 1
Declare ani_Setanimlooped          ( *p_anz_mesh.anz_mesh, islooped)
Declare ani_GetAnimByName          ( *p_anz_mesh.anz_mesh, name.s)  ; 
Declare ani_GetAnimGesch           ( *p_anz_mesh.anz_mesh)
Declare ani_setAnimGesch           ( *p_anz_mesh.anz_mesh , gesch.f)
Declare ani_getCurrentEndframe     ( *p_anz_mesh.anz_mesh) ; ben�tigt um zu pr�fen, ob beim Bogenschie�en der bogen schon gespannt ist, etc.
Declare ani_getCurrentStartframe   ( *p_anz_mesh.anz_mesh) ; ben�tigt um zu pr�fen, ob beim Bogenschie�en der bogen schon gespannt ist, etc.
Declare ani_getCurrentFrame        ( *p_anz_mesh.anz_mesh)
Declare ani_getCurrentAnimationNR  ( *p_anz_mesh.anz_mesh)
Declare ani_SetAnimSettings        ( *p_anz_mesh.anz_mesh , AnimationNR , islooped.w = 0, animationgesch.f = 1.0 , waitiffinished.w = 0 , animlist.s = "" ) ; p_anz_node = listiD von anz_mesh
Declare ani_SetAnim                ( *p_anz_mesh.anz_mesh , AnimationNR , islooped.w = 0 , animationgesch.f = 1.0 , waitiffinished.w = 0 )
;}
;{ Declarations item
Declare Item_GetGoldwert(*itemID.ITEM)
Declare.s Item_GetName(*itemID.ITEM)
Declare item_drop_item ( *itemID.ITEM)
Declare item_set_Captured ( *itemID.ITEM ) ; l�scht das Item von 3D Welt, f�r Inventar; f�gt sie aber nicht ins Inventar hinzu.
Declare Item_getNode ( *itemID.ITEM)
Declare item_waffe_GetWaffenart ( *itemID.ITEM)  ; gibt waffen/Zauberart aus.. siehe #item_waffe_..)
Declare item_waffe_getangriff( *itemID.ITEM)
Declare item_waffe_getReichweite ( *itemID.ITEM )
Declare item_examine_getDistance()
Declare item_examine_GetItemID() ; gibt das n�chste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare item_examine_GetObjID() ; gibt das n�chste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare item_examine_GetAnzID() ; gibt das n�chste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare item_examine_GetIrrNode() ; gibt das n�chste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
Declare Item_examine_Next()
Declare Item_Examine_Reset( only_they_in_view.b = 1 , max_distance.f = 100  ) ; �berpr�ft, ob Nodes in der N�he sind (bzw. alle nodes �berhaupt z.b. zum material setzen)
Declare Item_FocusItem_Reset ()  ; �berpr�ft das Fokus-Item
Declare Item_getFocusItem()   ; gibt das Item, das direkt vor dem Spieler liegt zur�ck ( also die ItemID)
Declare Item_Delete(*itemID.ITEM)
Declare Item_AddDefined ( name.s , x.f,y.f,z.f , DefinedItemNR.i)  ; erstellt ein vordeffiniertes Item (wichtig, wenn viele Items gleich sind.
Declare Item_Add (name$, x.f , y.f , z.f , goldwert , ItemArt.w , Betrag.w , Gewicht.f , pfad.s , texture1.s , texture2.s , MaterialType.i  ) ; betrag = z.b. lebensbonus, 
Declare Item_AddWaffe ( *itemID.ITEM , angriff , Reichweite, Waffenart )
;}
;{ Declarations kampfsystem
Declare kam_SchiesSchwert  ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen ) ; schl�gt mit dem Schwert einmal zu.(Animation wird hier niht geretelt!!
Declare kam_UpdateKampfSystem()  ; pfeile etc. treffen lassen usw.
Declare kam_SchiesZauber ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen , kam_Zauber_NR.i) 
Declare kam_moveGeschoss ( *geschossID.geschoss ,bewegx.f , bewegy.f,bewegz.f) ; bewegt den Pfeil wieder weiter (fliegen)
Declare kam_getGeschossNodeID (*geschossID.geschoss )
Declare kam_SchiesPfeil ( *WesenID.wes_wesen , *ZielwesenID.wes_wesen) ; schie�t einen Pfeil in richtung gegner ab. (kann danebenfliegen)
;}
;{ Declarations waypoints
Declare way_getWegParent ( *waypointid.WAYPOINT) ; ebenfalls f�r Wegfindung.
Declare.f way_getWegWert  ( *waypointid.WAYPOINT , art ) ; gibt f�r Wegfindung #way_Weg_wertart_F,..G,..H wert heraus
Declare way_IsWaypointReached ( *WesenID.wes_wesen , *waypointid.WAYPOINT ) ; schaut, ob der Waypoint erreicht wurde.
Declare way_getwaypointPOS ( *waypointid.WAYPOINT , *x.i , *y.i , *z.i ) ; ben�tigt: @*x , @*y , @*z.
Declare way_GetPathByPosition ( *waypointid.WAYPOINT ,  x.f , y.f , z.f )
Declare way_getpathByWayPoint( *Waypoint1.WAYPOINT  , *Waypoint2.WAYPOINT) ; berechnet den Pfad von A nach B ( also die Waypoints von dort zu da.)
Declare way_getclosestwaypoint ( x.f , y.f , z.f )
Declare way_connectwaypoints ( *waypointid.WAYPOINT , *childpointID.WAYPOINT ) ; connects both waypoints to each other... also verbinden.. XD my english ^^.
Declare way_RemoveWaypoint(*waypointid.WAYPOINT )
Declare Way_AddWaypoint(x.f, y.f, z.f , *connectionid.i = -1) ; waypoint hinzuf�gen mit eventuellem Vorg�nger-waypoint ( als 1. verbindung..)
Declare way_NextPathElement ( pfad_list.s )
;}

IncludePath "includes\"
IncludeFile "include_waypoint.pb"
IncludeFile "include_wesen.pb"
IncludeFile "include_wegfindung.pb"  ; include meien wegfindung.
IncludeFile "include_spieler.pb"
IncludeFile "include_anzeige.pb"
IncludeFile "include_teams.pb"
IncludeFile "include_kampfsystem.pb"
IncludeFile "include_item.pb"
IncludeFile "include_animation.pb"
IncludeFile "include_math.pb"
 
; jaPBe Version=3.7.12.680
; Build=1
; FirstLine=0
; CursorPosition=6
; ExecutableFormat=Windows
; Executable=H:\GemuSoft\Gemusoft\max level.exe
; DontSaveDeclare
; EOF