ExamineDesktops()

; --------------------------------------------------------------------
; -- Constants   
; --------------------------------------------------------------------

Enumeration ; rotationsarten.. zum rotieren der objekte
   #anz_rotart_x
   #anz_rotart_y
   #anz_rotart_z
   #anz_rotart_xyz
EndEnumeration 

Enumeration ; nodeart
   #anz_art_mesh
   #anz_art_sound3d
   #anz_art_light
   #anz_art_billboard
   #anz_art_particle
   #anz_art_terrain
   #anz_art_lensflare
   #anz_art_collisionsmatrix   ; sind keine Nodearten. werden evtl später eingebaut (wenn physic geht)
   #anz_art_collisionsselector ; sind keine Nodearten. werden evtl später eingebaut (wenn physic geht)
   #anz_art_skybox 
   #anz_art_Waypoint           ; auch wayopints sind 3d-elemente.. wenngleich sie "nur" zum pfadfinding dienen.(warum sollte man sie woanders hinstopfen..)
EndEnumeration

Enumeration ; collisionarten:
   #anz_col_box
   #anz_col_mesh
   #anz_col_terrain
EndEnumeration 

Enumeration ; collisiontypen
   #anz_ColType_Nocollision
   #anz_ColType_solid
   #anz_ColType_movable
EndEnumeration

Enumeration  ; particlearten
   #anz_particle_art_default  ; standard- ein box-emitter. gut für flächennebel usw.
   #anz_particle_art_sphere   ; ein kugel-emitter- gut für feuer
   #anz_particle_art_ring     ; ring-emitter. gut für am... k.a. ^^
EndEnumeration

Enumeration ; mouseevent Arten
   #anz_MouseEvent_no       ; nicht gedrückt.
   #anz_MouseEvent_tipped   ; Ein Durchlauf lang wenn gepresst
   #anz_MouseEvent_pressed  ; dauernd, solange mouse unten
   #anz_MouseEvent_released ; sobald wieder einmal, "mousereleased"
EndEnumeration 

#anz_meter            = 34.511627                 ; ein Meter ist demnach XX Pixel groß
#meter                = #anz_meter                ; weil oft aus versehen #Meter eingebaut wurde.. naja kann man nicht verdenken, 
#anz_Walkspeed        = #anz_meter /14            ; im Meter pro 60-tel Sekunde (Frame) . wie weit der spieler pro durchlauf geht.. 
#anz_raster_maxrasterelements = 151  ; von 0  bis 150 -> 151 elemente
#anz_rasterboxbreite = #anz_meter * 40  ; also 100 pixel pro Rasterblock ; 35 = ungefähr 1 m in 3d welt.. (gerundet)
#anz_rasterboxhohe   = #anz_meter * 43 ; so aehnlich auch hier.. bisschen höher, weil weniger passiert, hier.
#anz_rasterbreite    = 150             ; anzahl der rasterkästen in breite und tiefe
#anz_rasterhohe      = 20              ; anzahl selbiger in der Höhe.
#anz_PBFont          = 0     ; Font zum schreiben von Text auf Texturen.
#anz_max_children    = 5     ; jedes 3d objekt kann 5 child-nodes mit sichverknüpfen.
; pfad constants:

#pfad_feuer_sound     = ""
#pfad_feuer_texture   = ""
#pfad_cloud_texture   = ""
#pfad_staub_texture   = ""
#pfad_meter           = "..\..\meter.3ds"

; für Kampfsystem:
#pfad_pfeil_mesh      = ""
#pfad_pfeil_normalmap = ""
#pfad_pfeil_texture   = ""

; für spielersystem:
#pfad_spieler_mesh    = "..\..\sydney.md2"
#pfad_spieler_texture = "..\..\sydney.jpg"
#pfad_spieler_texture2= "..\..\sydney_normal.jpg"

; für main.pb
#pfad_maps            = "GFX\maps\Max welt\"






; --------------------------------------------------------------------
; -- Strucrures 
; --------------------------------------------------------------------

Structure anz_Object3d 
   id.i     ; pointer zum jeweiligen objekt 
   art.i    ; z.b. mesh, light, billboard, sound3d ,lensflare etc.
   x.f      ; jaja, ich weiß, im irrlicht node isses auch gespeichert, aaber:
   y.f      ; das node wird geloescht, wenn spieler weit davon entfernt ist! ;)
   z.f
   rasterx.w  ; die position des rasters.
   rastery.w  ; also rasterposition ;) :) :D ;)
   rasterz.w  ; brauchma, weil sich das mesh unkontrolliert bewegen kann (callback for collision)
   ParentID.i ; Parent, an dem das Object3d festgekittet ist :)
   ParentID_IS_BONE.s ; wenn > "", dann ist der parent ein Bone von ParentID. mit dem namen dieser variable hier. 
   child.i [#anz_max_children]
   anzahl_children.i ; wichtig, um festzustellen, ob node überhaupt parent ist, im moment. 
EndStructure 

Structure anz_skybox ; mehr als existieren muss eine skybox ja nicht....
   nodeID.i
EndStructure 

Structure anz_mesh     ; wenn das 3d object ein mesh ist.
   width.f             ; die breite in Pixeln
   height.f            ; height in pixels
   depth.f             ; and depth
   scalex.f
   scaley.f
   scalez.f
   rotx.f
   roty.f
   rotz.f
   geladen.w           ; schaut, ob mesh geladen ist.
   Object3dID.i        ; Anz_object3d-link zum Upspeeden!!
   meshID.i            ; IRRmeshID
   nodeID.i            ; irrnodeID
   itemID.i            ; wenn das Mesh ein Item ist
   WesenID.i           ; wenn das Mesh ein Wesen ist.. zum leichteren Erkennen beim umgebungsuntersuchen ;)
   ShadowID.i          ; ID of shadowNode.
   pfad.s              ; pfad des meshes.
   texture.s           ; derzeit nur 1. textur pro mesh .. :(
   texture_normalmap.s ; normalmap -pfad.
   anim_aktuell_frame.f     ; aktueller frame
   anim_aktuell_startframe.i; start der aktuellen animation
   anim_aktuell_endframe.i  ; ende der atuellen animation
   anim_gesch.f        ; aktuell_frame + animgesch.
   anim_list.s         ; animationliste der animation Z.B. "stehen,1,155|laufen,162,180|springenstarten,260,268|springenlanden,267,288"
   anim_currentanim.s  ; name der aktuellen Animation (z.b. "laufen")
   anim_try_to_end.w   ; sagt, dass er animation stoppen soll für nächste anim.. geht net, wenns gelocked ist.
   anim_islocked.w     ; wenn =1 -> animation kann nicht durch andere abgebrochen werden. (z.b. sterben nicht durch laufen)
   anim_islooped.w     ; besagt, ob die Animation wiederholt wird (z.b. laufen) oder nur einmal abgespielt (z.b. springen)
   irr_emt_materialtype.w ; aktueller Status des nodes.
   islighting.i        ; schaut, ob mesh lighted wird, oder nicht. 
   currentmaterialtype.i
   collisionNodeID.i   ; evtl. connected collisionnode. if < 0 => then no collision ;----; if =0 , then collision, but unloaded => load it .
   Collisiondetail.w   ; #anz_col_box , #anz_col_mesh , #anz_col_terrain
   Collisiontype.w     ; #anz_ColType_solid -> gebäude, "immobile" , oder #anz_colType_movable -> einheiten, "mobile"
   collisionanimator.i ; link zum animator zum spateren löschen.
EndStructure 

Structure anz_texture 
  id.i
  pfad.s
  Counter.w    ; zählt mit, wie viele nodes die textur nutzen. wenn =0 -> textur kann gelöscht werden.
EndStructure 

Structure anz_raster
   anzahl_nodes.w        ; anzahl der Existierenden Nodes.
   node        .i[#anz_raster_maxrasterelements]   ; pointer zum ListenElement!! nicht Irrlicht node 101 = von 0 bis 100!! nicht bis 101!
EndStructure 

Structure anz_light
  nodeID.i
  Object3dID.i
EndStructure 

Structure anz_billboard 
   id.i
   irr_emt_materialtype.i
   width.f
   height.f
   pfad.s
   lighting.w
   Object3dID.i
EndStructure 

Structure anz_lensflare
   id.i
   Object3dID.i
EndStructure 

Structure anz_sound3d
   id.i
   mindistance.f
   maxdistance.f
   Object3dID.i
EndStructure 

Structure anz_terrain
   nodeID.i
   terrainmap.s
   texture1.s
   texture2.s
   irr_emt_materialtype.i
   scalex.f
   scaley.f
   scalez.f
   rotx.f
   roty.f
   rotz.f
   width.f   ; Editor schreibt diese Werte automatisch, da er ja weiß, wie groß das Terrain ist. 
   height.f  ; wird mit anz_getObjectScreenwidth/heigt/depth(..) festgestellt 
   depth.f
   texturescalex.f
   texturescaley.f
   geladen.w ; ob das terrain schon in irrlicht erstellt ist.
   islighting.w
   Object3dID.i
   CollisionID.i ; pointer zum Collisionnode.
EndStructure 

Structure anz_particle 
   Object3dID.i
   art.i                              ; die art von particleemitter. z.b. #anz_particle_art_default
   nodeID.i
   geladen.w
   particlewidth.f
   particleheight.f
   texture1 .s
   texture2 .s
   irr_emt_materialtype.i
   nodestruct.IRR_PARTICLE_EMITTER
   current_min_paritlcles_per_second.i ; die tatsächliche anzahl der particel per s. wird je nach Entfernung heruntergschraubt.
   current_max_paritlcles_per_second.i ; (basierend auf der tatsächlichen min/max-particles per second -rate.
   anz_particle_art.w                  ; obs ein sphere-particle, oder ein box, oder ring-particle ist.
   RingThickness.f                     ; nur, wenn der emitter des particlenodes ein ring ist. 
EndStructure 

Structure anz_image
   x.f
   y.f
   NR.i         ; Nr. als Hilfe zum löschen und hinzufügen
   id.i         ; textureID
   Alpha.b      ; ob alpha benutzt wird ( bei png-bilder z.b.)
   ishidden.b   ; obs image grad angezeigt wird, oder nicht
EndStructure 

Structure anz_cloud
   x.f
   y.f
   z.f
   nodeID.i
   bewegx.f
   bewegy.f
   bewegz.f
EndStructure 

Structure anz_staub
   nodeID .i
   lebenszeit.i  ; wenn lebenszeit kleiner elapsedmill.. : tot.
EndStructure 

Structure anz_examined_node 
   nodeID.i      ; pointer zu irrlicht-Node.
   Object3dID.i  ; pointer zu anz_object3d()
   AnzID.i       ; z.b. pointer zu anz_mesh()
   nodeart.i     ; #anz_art_mesh /light usw.
EndStructure 

; --------------------------------------------------------------------
; -- Globals  
; --------------------------------------------------------------------

Global anz_camera                .i
Global anz_distance_nah          .f               = #meter * 5   , anz_distance_fern.f = #meter * 16 , anz_distance_ferner.f = #meter * 28, anz_distance_unsichtbar.f = #meter * 40     ; die distances.
Global anz_irrlicht_Started      .w
Global NewList anz_Object3d      .anz_Object3d    ()
Global NewList anz_texture       .anz_texture     ()
Global NewList anz_terrain       .anz_terrain     ()
Global NewList anz_image         .anz_image       ()
Global NewList anz_billboard     .anz_billboard   ()
Global NewList anz_mesh          .anz_mesh        ()
Global NewList anz_light         .anz_light       ()
Global NewList anz_lensflare     .anz_lensflare   ()
Global NewList anz_sound3d       .anz_sound3d     ()
Global NewList anz_particle      .anz_particle    ()
Global NewList anz_cloud         .anz_cloud       ()
Global NewList anz_staub         .anz_staub       ()
Global NewList anz_Examined_node .anz_Examined_node ()
Global         anz_skybox        .anz_skybox      
Global anz_texture_NotFound      .i ; die Defaulttexture, wenn fehler beim ladne.

Global Dim anz_raster            .anz_raster      ( #anz_rasterbreite , #anz_rasterhohe , #anz_rasterbreite )
Global anz_isshadow              .w
Global anz_islighting            .w
Global anz_isfog                 .w 
Global anz_isnormalmapping       .w
Global anz_isparallaxmapping     .w
Global anz_resolutionx           .w
Global anz_resolutiony           .w
Global anz_resolutiondepth       .w
Global anz_CollisionMeta_solid   .i
Global anz_examined_node_ID      .i  ; Pointer zum aktuellen examined Listelement
Global anz_pause.i

; Keyboardglobals
Global anz_key_tipped_space
Global anz_key_tipped_q
Global anz_key_tipped_m
Global anz_key_tipped_i
Global anz_key_tipped_p
Global anz_key_tipped_shift
Global anz_key_tipped_return
Global anz_key_tipped_control
Global  anz_key_tipped_1 , anz_key_tipped_2 , anz_key_tipped_3 , anz_key_tipped_4 , anz_key_tipped_5 , anz_key_tipped_6 , anz_key_tipped_7 , anz_key_tipped_8 , anz_key_tipped_9 , anz_key_tipped_0 ; für die schnellwahl.

; Mouseglobals
Global anz_mb1
Global anz_mb2
Global anz_mb3
Global anz_mousedeltax.f
Global anz_mousedeltay.f 
Global anz_mouseWheel.f 
; jaPBe Version=3.9.12.818
; Build=0
; FirstLine=274
; CursorPosition=303
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF