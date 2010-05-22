; -----------------------------------------------------------------------------------------------------
; --- Include Wesen..----------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------


; Wesen commands
; 
; move%x%y - bewegt das Wesen mit seiner Geschwindigkeit an die angegebene Stelle
; die - das Wesen fällt tot um und verschwindet
; atk%gegnerid - das Wesen greift diesen Gegner an
; esc%gegnerid - das Wesen flüchtet vor diesem Gegner

; -----------------------------------------------------------------------------------------------------
; --- Macros..  ---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------
; --- Procedures---------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

; Add Remove

Procedure wes_AddWesen ( Name.s, x.f , y.f , z.f , Team.s , maxleben.i , speed.f , pfad.s , texture1.s , texture2.s , MaterialType.i , Isdirectload.i = 0 , SpielerID.i = 0 , art.i =#wes_art_schwert , action.i = #wes_action_stand ,  AnimNR.i = 0 , animlist.s = #ani_Animlist_Standard) ; wobei team: siehe #team_wesen_bundnis_...)
  Protected *anz_mesh.anz_mesh , *currentwesen.wes_wesen , *newwesen.wes_wesen 
   
   ; ----------------------------------------------------------------------------------------------------------------------------
   ; PAUSE... addwesen erstellt noch kein anz_mesh.. später einbauen (wenn die verschiedenen wesenarten bekannt sind.
   ; ----------------------------------------------------------------------------------------------------------------------------
   ; --[edit] im moment wirds halt so erstellt ..aber ne #wes_art_fernkampf_... wär nicht schlecht.. also erstellen eines wesens anhand einer ID.
   
   If ListSize   ( wes_wesen()) > 0
      *currentwesen = wes_wesen()
   EndIf 
   
  *newwesen = AddElement(wes_wesen())
  
  If *newwesen 
    
     *newwesen\art            = art
     *newwesen\Name           = Name
     *newwesen\maxleben       = maxleben
     *newwesen\leben          = maxleben
     *newwesen\mana           = maxmana 
     *newwesen\maxmana        = maxmana
     *newwesen\action         = action
     *newwesen\speed          = speed
     *newwesen\SpielerID      = SpielerID 
     *newwesen\Team           = team_AddTeam( Team )
     *newwesen\waypoint       = way_getclosestwaypoint   ( x , y, z )
     *newwesen\anz_Mesh_ID    = anz_addmesh              ( pfad , x , y , z , texture1 , MaterialType , texture2 , Isdirectload , 1 , #anz_col_box , #anz_ColType_movable )
     ani_SetAnimSettings        ( *newwesen\anz_Mesh_ID , AnimNR , 0 , 0.4 , 0 , animlist )
     *anz_mesh                  = *newwesen\anz_Mesh_ID 
     *anz_mesh                  \ WesenID   = *newwesen
     
  EndIf 
  
  If *currentwesen 
     ChangeCurrentElement(wes_wesen() , *currentwesen )
  EndIf 
  
  ProcedureReturn *newwesen ; die aktuelle wesenid, wenn denn ein wesen erstellt wurde.
  
EndProcedure

Procedure wes_KillWesen( *WesenID.wes_wesen)

   Protected x.f , y.f , z.f , *item.ITEM
  
      *WesenID\leben     = 0
      *WesenID\action    = #wes_action_die 
      E3D_getNodePosition( anz_getObject3DIrrNode ( anz_getobject3dByAnzID ( *WesenID\anz_Mesh_ID )), @x , @y , @z )
      ani_SetAnim        ( *WesenID\anz_Mesh_ID   , #ani_animNR_die_back, 0 , 1 , 1  ) 
      *item              = Item_AddDefined        ( "Gold" , x , y , z , #item_predef_geld    )    ; wirft nen Haufen Geld dahin, wo der Gegner vorhin stand
      *item              \ Betrag                 = (*WesenID\maxleben + *WesenID\maxmana ) / 10   ; Goldmenge
  
  ProcedureReturn *WesenID
      
EndProcedure

Procedure wes_RemoveWesen(*WesenID.wes_wesen)

   If *WesenID 
      anz_delete_object3d  ( anz_getobject3dByAnzID ( *WesenID\anz_Mesh_ID), 0 , 1)
      ChangeCurrentElement ( wes_wesen() , *WesenID )
      DeleteElement        ( wes_wesen() )
   EndIf 
   
EndProcedure

Procedure wes_removewaffe ( *WesenID.wes_wesen) ; aktuelle Waffe ohne Anim. aus Hand löschen, sofern vorhanden.
   Protected *Oldwaffe_Item.ITEM , *OldWaffe_Anz.anz_mesh
   
   If *WesenID           ; wenn Wesen existiert
   
      *Oldwaffe_Item     = *WesenID       \ Waffe_Item_ID ; vereinfachungen..
   
      ; Waffe nur aus der Hand weg; aufräumen!! (ist ja schon im Inventar.) 
      If *Oldwaffe_Item        > 0 ; wenn waffe in Hand
         *OldWaffe_Anz         = *Oldwaffe_Item \ anz_Mesh_ID   ; oldwaffe_anz..
         ;anz_mesh+  Obj3d löschen. + UN-registrieren bei Wesen.
         *Oldwaffe_Item        = 0 ; wesenid\waffe_item_id = 0 
         *OldWaffe_Anz\itemID  = 0 ; weil es nicht mehr aufhebbar ist -> = 0
         *OldWaffe_Anz\WesenID = 0 ; weil es ja kein WEsen ist.. nur zur Sicherheit..
         *WesenID\ Waffe_Item_ID= 0
         anz_delete_object3d   ( anz_getobject3dByAnzID(*OldWaffe_Anz  ) )
         ProcedureReturn       *WesenID 
      EndIf 
      
   EndIf 
   
EndProcedure 

Procedure wes_setWesenWaffe     ( *WesenID.wes_wesen , *itemID.ITEM )
   Protected *bone , *Oldwaffe_Item.ITEM , *OldWaffe_Anz
   
   If *WesenID
      *Oldwaffe_Item            = *WesenID       \ Waffe_Item_ID
      If *Oldwaffe_Item         ; wenn wesen überhaupt ne Waffe hatte, vorher
         *OldWaffe_Anz          = *Oldwaffe_Item \ anz_Mesh_ID 
      EndIf 
      
      ; alte Waffe ins       Inventar. aufräumen!!
         If *OldWaffe_Anz       ; wenn wesen vorher schon waffe hatte
            wes_removewaffe     ( *WesenID )
         EndIf 
         *WesenID               \ Waffe_Item_ID  = *itemID ; wenn itemid = 0, dann wird die aktuelle waffe nur gelöscht, keine neue reingesetzt!
         
      ; neues Item im Wesen registrieren, wenn keine waffe da -> leere hand.
      If *itemID                ; wenn die neue waffe existiert.
         
         If *bone 
            ; anz_mesh erstellen
            *itemID\anz_Mesh_ID = anz_addmesh ( *itemID\Anz_mesh_struct\pfad ,*itemID\Anz_mesh_struct\x , *itemID\Anz_mesh_struct\y , *itemID\Anz_mesh_struct\z , *itemID\Anz_mesh_struct\texture , *itemID\Anz_mesh_struct\MaterialType , *itemID\Anz_mesh_struct\normalmap  ,  0 , 0 , #anz_col_box , #anz_ColType_movable )
            ; an Hand kleben.
            anz_attachobject    ( anz_getobject3dByAnzID( wes_getAnzMeshID( *WesenID )) , anz_getobject3dByNodeID ( Item_getNode( *WesenID\Waffe_Item_ID )), 0 , 0 , 0 , "Hand")
            ProcedureReturn     1
         EndIf 
         
      EndIf 
   EndIf 
   
EndProcedure 

Procedure wes_GetWesenMaxLeben ( *WesenID.wes_wesen)
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\ maxleben 
      
EndProcedure

Procedure wes_GetWesenMaxMana ( *WesenID.wes_wesen )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\ maxmana 
   
EndProcedure

Procedure wes_GetLeben ( *WesenID.wes_wesen )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\leben 
   
EndProcedure 

Procedure wes_SetLeben ( *WesenID.wes_wesen , leben)
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   If leben            > *WesenID\maxleben 
      *WesenID\leben   = *WesenID\maxleben 
      ProcedureReturn leben - *WesenID\maxleben  ; return REST.
   Else 
      *WesenID\leben    = leben   ; ansonsten einfach Leben setzen
      If *WesenID\leben < 0    ; kann ja sein, dass leben abgezogen wird z.b. bei Gift.. 
         *WesenID\leben = 0 
      EndIf 
   EndIf 
   
EndProcedure 

Procedure wes_SetmaxLeben ( *WesenID.wes_wesen , maxleben) ; setzt das maxleben.. 
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   *WesenID\maxleben      = maxleben   ;

EndProcedure 

Procedure wes_SetmaxMana  ( *WesenID.wes_wesen , maxmana)  ; setzt das maxmana
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   *WesenID\maxmana = maxmana 
   
EndProcedure 

Procedure wes_GetMana ( *WesenID.wes_wesen )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\ mana  
   
EndProcedure 

Procedure wes_SetMana ( *WesenID.wes_wesen ,mana  )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   If mana          > *WesenID\maxmana 
      *WesenID\mana = *WesenID\maxmana 
      ProcedureReturn mana - *WesenID\maxmana  ; return REST.
   Else 
      *WesenID\mana = *WesenID\maxmana  ; ansonsten einfach blind addieren 
      If *WesenID\mana < 0 ; kann ja sein, dass mana abgezogen wird z.b. bei Gift.. 
         *WesenID\mana = 0 
      EndIf 
   EndIf 
EndProcedure 

Procedure.s wes_getname ( *WesenID.wes_wesen)
   If *WesenID > 0
      ProcedureReturn *WesenID\Name 
   EndIf 
EndProcedure 

Procedure wes_setname ( *WesenID.wes_wesen , Name.s )
   If *WesenID > 0
      *WesenID\Name = Name
      ProcedureReturn 1
   EndIf 
EndProcedure 

Procedure wes_SetWesenCommand(*WesenID.wes_wesen, wes_action_action.i )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
  If Not *WesenID\action = #wes_action_die ; wenn das Wesen nicht gerade stirbt.
         *WesenID\action = wes_action_action
  EndIf 
  
EndProcedure

Procedure wes_getdistance  ( *wesen1.wes_wesen , *wesen2.wes_wesen)
   Protected x1.f , y1.f , z1.f , x.f , y.f, z.f 
      If Not *wesen1 Or Not *wesen2 ; sicherheit, damit pointer nicht = 0
         ProcedureReturn 0 
      EndIf 
      
      anz_getMeshPosition(  wes_getAnzMeshID(*wesen1)  , @x1,@y1,@z1)
      anz_getMeshPosition(  wes_getAnzMeshID(*wesen2)  , @x,@y,@z)
      
      ProcedureReturn  math_distance3d    (x1,y1,z1, x ,y , z ) 
      
EndProcedure 

Procedure wes_getNodeID    ( *WesenID.wes_wesen)
   If *WesenID 
      ProcedureReturn anz_getObject3DIrrNode( anz_getobject3dByAnzID( *WesenID\anz_Mesh_ID ))
   EndIf 
EndProcedure 

Procedure wes_getSpielerID( *WesenID.wes_wesen) ; wenn das Wesen eine spieler ID hat (also eine spieler ist) wird id ausgegeben.
   If *WesenID 
      ProcedureReturn *WesenID\SpielerID 
   EndIf 
EndProcedure 

Procedure wes_GetWaypointPfadID ( *WesenID.wes_wesen)  ; gibt die WaypointID des aktuellen Ziel-Waypionts aus.
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn Val( StringField   ( *WesenID\pfad , *WesenID\pfad_currentWaypoint , "|" ))
EndProcedure 

Procedure wes_GetWesenWaypoint(*WesenID.wes_wesen)
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\waypoint 
EndProcedure

Procedure wes_SetWesenWaypoint(*WesenID.wes_wesen, waypoint)
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   *WesenID\waypoint = waypoint
EndProcedure

Procedure wes_getposition ( *WesenID.wes_wesen , *x.f , *y.f , *z.f) ; needs @*x , @y,@z.f
   Protected  x1.f , y1.f , z1.f , *Object3dID.anz_Object3d
   
   If *WesenID 

      anz_getMeshPosition( *WesenID\anz_Mesh_ID , *x , *y , *z ) ; sind ja schon die Pointer zu Variablen. 
      ProcedureReturn    *WesenID 
      
   EndIf 
   
EndProcedure

Procedure wes_is_geladen  ( *WesenID.wes_wesen )
   If Not *WesenID =< 0
      ProcedureReturn  anz_MeshisGeladen   ( *WesenID\anz_Mesh_ID )
   EndIf 
EndProcedure 

Procedure wes_MoveWesenToWaypoint( *WesenID.wes_wesen , *waypointid.WAYPOINT ) ; bewegt ein Wesen direkt (irrlicht based) ; prüft vorher die bodenhöhe
   Protected  x.f , y.f , z.f , *startvector.ivector3 , *endvector.ivector3 , *Rot.ivector3 , *Collisionvector.ivector3 
      If Not *WesenID > 0  
         ProcedureReturn 0
      EndIf 
      If Not *WesenID\action = #wes_action_die And wes_is_geladen( *WesenID) ; wenn es nicht gerade stirbt.. UND angezeigt wird (nicht zu weit weg ist.)
      
            ; Node Ausrichten
            
            way_getwaypointPOS          ( wes_GetWaypointPfadID ( *WesenID ) , @x , @y , @z)
            math_IrrFaceTargetPerPos    ( wes_getNodeID         ( *WesenID ) , x , y , z ) ; PAUSE hier gehören coordinaten from next wayopint rein.. SIEHE #wes_action_move weiter unten!!!
            
            ; schaun, ob Waypoint schon erreicht..
            If way_IsWaypointReached    ( *WesenID , *WesenID\pfad_currentWaypoint )
               ProcedureReturn *WesenID ; Waypoint erreicht --> success
            EndIf 
            
            ; Boden auf Begehbarkeit prüfen .. Items und Wesen haben keinen Kollisionskörper --> können net stören.
            ; wes_getposition             ( *WesenID     , *startvector\x , *startvector\y , *startvector\z)
            ; E3D_getNoderotation         ( wes_getNodeID( *WesenID) , *Rot\x , *Rot\y , *Rot\z) ; vorher wurde ja ROT in Zielrichtung gesetzt --> jetz in rotrichtung gehen!
            ; - PAUSE.. hier stimmt doch was nicht.. auf direkte Höhenabfrage wechseln!! dafür machma dann schon noch einen schönen editor..
            ; *startvector                \y  - #meter * 2 
            ; *startvector                \x  + Cos ( math_FiToRad(*Rot\y)) * *WesenID  \speed; testet Boden vor sich
            ; *startvector                \z  + Sin ( math_FiToRad(*Rot\y)) * *WesenID  \speed; testet Boden vor sich.
            ; *endvector                  \y  = *startvector  \ y + #meter  * 3.9 ; testet Boden bis 1.9 Meter über Wesen. 
            ; *endvector                  \x  = *startvector  \ x
            ; *endvector                  \z  = *startvector  \ z
            ; IrrGetCollisionPoint        ( *startvector , *endvector , anz_CollisionMeta_solid , *Collisionvector )
               
               ; If *Collisionvector\y < *endvector\y And  *Collisionvector\y > *startvector\y; wenn kein Berg oder Loch vor ihm ist
                  ani_SetAnim       ( *WesenID\anz_Mesh_ID , #ani_animNR_run , 0 ,1,0) ;Animation setzen!
                  If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_run  ; wenn die animation auch tatsächlich abgespielt wird (was z.b. bei springen ja nicht geht) dann bewegen.
                     anz_moveObject ( anz_getobject3dByAnzID( *WesenID\anz_Mesh_ID ) ,*WesenID\speed , 0 , 0 ) ; Cos ( *Rot\y ) * *WesenID\speed , *Collisionvector\y - ( *startvector\y + #meter*2) , Sin ( *Rot\y ) * *WesenID\speed ) ; wegen Y coord: Startvector wurde ja vorher verändert -> zurücksetzen (+#meter*2)
                  EndIf 
               ; Else 
                  ; ani_SetAnim ( *WesenID\anz_Mesh_ID , #ani_animNR_stand , 0 ,1 , 0) ; wenner nicht gehen kann soller stehen... naja NOTLÖSUNG
               ; EndIf 
            
      EndIf 
      
EndProcedure 

Procedure wes_MoveWesenToPosition ( *WesenID.wes_wesen , x.f , y.f , z.f)
   Protected   startvector.ivector3 , endvector.ivector3 , Rot.ivector3 , Collisionvector.ivector3 
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   If Not *WesenID\action = #wes_action_die And wes_is_geladen( *WesenID) ; wenn es nicht gerade stirbt.. UND angezeigt wird (nicht zu weit weg ist.)
      
            ; Node Ausrichten
            math_IrrFaceTargetPerPos    ( wes_getNodeID ( *WesenID ) , x , y , z ) ; PAUSE hier gehören coordinaten from next waypoint rein.. SIEHE #wes_action_move weiter unten!!!
            
            ; ; schaun, ob Ziel schon erreicht..
            ; If way_IsWaypointReached    ( *WesenID , *WesenID\pfad_currentWaypoint )
               ; ProcedureReturn *WesenID ; Waypoint erreicht --> success
            ; EndIf 
            ; 
            ; ; Boden auf Begehbarkeit prüfen .. Items und Wesen haben keinen Kollisionskörper --> können net stören.
            ; wes_getposition             ( *WesenID     , @startvector\x , @startvector\y , @startvector\z)
            ; IrrGetNodeRotation          ( wes_getNodeID( *WesenID) , @Rot\x , @Rot\y , @Rot\z) ; vorher wurde ja ROT in Zielrichtung gesetzt --> jetz in rotrichtung gehen!
            ; 
            ; startvector                \y  - #meter * 4 
            ; startvector                \x  + Cos ( math_FiToRad(Rot\y)) * #meter*2; testet Boden vor sich
            ; startvector                \z  + Sin ( math_FiToRad(Rot\y)) * #meter*2; testet Boden vor sich.
            ; endvector                  \y  = startvector  \ y + #meter * 0.9 ; testet Boden bis 0.9 Meter über Wesen. 
            ; endvector                  \x  = startvector  \ x
            ; endvector                  \z  = startvector  \ z
            ; IrrGetCollisionPoint        ( @startvector , @endvector , anz_CollisionMeta_solid , @Collisionvector )
               ; Debug "starte Laufen.. y"
               ; 
               ; If GetAsyncKeyState_( #VK_3) ; DEBUGG!
                  ; *cube = IrrAddCubeSceneNode( 20)
                  ; IrrSetNodeScale ( *cube , 1,5,1)
                  ; IrrSetNodePosition( *cube , Collisionvector\x , Collisionvector\y , Collisionvector\z )
               ; EndIf 
               
               ; If Collisionvector\y < endvector\y + 1*#meter And  Collisionvector\y > startvector\y; wenn kein Berg oder Loch vor ihm ist
                  ani_SetAnim       ( *WesenID\anz_Mesh_ID , #ani_animNR_run , 0 ,0.4,0) ;Animation setzen!
                  anz_moveObject    ( anz_getobject3dByAnzID( *WesenID\anz_Mesh_ID) , *WesenID\speed , 0 , 0); Startvector wurde ja vorher verändert -> zurücksetzen (+#meter*2)
               ; Else 
                  ; Debug "laufen DENIED"
                  ; Debug "covl   - endv: " + StrF( Collisionvector\y - endvector\y ,2)
                  ; Debug "startv - colv: " + StrF( startvector\y - Collisionvector\y ,2)
                  ; 
                  ; ani_SetAnim ( *WesenID\anz_Mesh_ID , #ani_animNR_stand , 0 ,0.4 , 0) ; wenner nicht gehen kann soller stehen... naja NOTLÖSUNG
               ; EndIf 
               
      EndIf
      
EndProcedure 

Procedure wes_setposition( *WesenID.wes_wesen , x.f , y.f , z.f )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   anz_setobjectPos  ( anz_getobject3dByAnzID    ( *WesenID\anz_Mesh_ID ) , x , y , z)
   *WesenID\waypoint = way_getclosestwaypoint    ( x , y , z )
EndProcedure 

Procedure wes_getAction ( *WesenID.wes_wesen)
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\action 
EndProcedure 

Procedure wes_getAnzMeshID( *WesenID.wes_wesen) ; gibt die anz_mesh_id heraus.
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   ProcedureReturn *WesenID\anz_Mesh_ID 
EndProcedure 

; EXAMINE Wesen 

Procedure.f wes_getReichweite ( *WesenID.wes_wesen ) ; gibt Reichweite des wesens zurück.
   Protected *waffe.item_waffe , *item.ITEM 
   
   If Not *WesenID 
      ProcedureReturn 
   EndIf 
   If *WesenID \Waffe_Item_ID 
      *item    = *WesenID \Waffe_Item_ID 
      *waffe   = *item    \WaffenID 
      ProcedureReturn *waffe 
   Else 
      ProcedureReturn #wes_Standard_Reichweite 
   EndIf 
   
EndProcedure 

Procedure wes_Examine_Reset( IrrZentrumNode.i  , only_they_in_view.b = 1 , max_distance.f = #meter * 10  ) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
   Protected x1.f , y1.f , z1.f ,  *p_obj.anz_Object3d , ObjectArt.w , irr_obj.i , rasterx.i , rastery.i , rasterz.i , *anz_mesh.anz_mesh    ; wenn Onlywess1_OnlyWesen2 = 1, dann nur wess suchen, wenn =2, dann nur wesen.
      
      ClearList( wes_Examined_node() )
      
      If only_they_in_view = 1   ; dann werden nur die gesucht, die in der Nähe des Rasters sind. 
      
      ;{ alle in der nähe überprüfen
      
      E3D_getNodePosition( IrrZentrumNode , @x1 , @y1 , @z1)   ; prüft die Position des IrrNodes , um das herum gesucht wird.
   
      rasterx = Round( x1 / #anz_rasterboxbreite , 1 )
      rastery = Round( y1 / #anz_rasterboxhohe   , 1 )
      rasterz = Round( z1 / #anz_rasterboxbreite , 1 )
      
       For x_for = -4 To 4
         For y_for = -4 To 4
            For z_for = -4 To 4
               
               ; das Raster einstellen - also für anz_raster (x,y,z)
               x         = x_for + rasterx
               y         = y_for + rastery
               z         = z_for + rasterz
               
               If x < 0 Or y < 0 Or z < 0  ; darf ja nicht -1 sein..
                  Continue  
               EndIf


               For n = 0 To anz_raster     ( x,y,z )\anzahl_nodes -1 ; setzt voraus, dass die node-liste sortiert ist ( kein "exist=0" )
                  ; X1, y1 und z1 sin am Anfang schon gesetzt worden (spielerposition)
                  *p_obj.anz_Object3d      = anz_raster(x,y,z)\node[n]
                  ObjectArt                = *p_obj\art
                  
                  If ObjectArt             = #anz_art_mesh 
                     *anz_mesh             = *p_obj\id
                     If  *anz_mesh\WesenID > 0  ; wenn es ein wes und ein Mesh ist ..
                     
                        anz_obj_cam_dist      = math_distance3d    (x1,y1,z1, *p_obj\x , *p_obj\y , *p_obj\z)   ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)
                        If anz_obj_cam_dist   > max_distance  ; damit nicht alle, sondern nur die objekte inderr Nähe überprüft werden.
                            Continue  
                        EndIf 
                     
                        If AddElement       ( wes_Examined_node())
                           wes_Examined_node()\Object3dID       = *p_obj 
                           *anz_mesh                            = *p_obj\id
                           wes_Examined_node()\nodeID           = *anz_mesh\nodeID 
                           wes_Examined_node()\anz_Mesh_ID      = *anz_mesh
                           wes_Examined_node()\distance         = anz_obj_cam_dist 
                        EndIf 
                     EndIf 
                  EndIf 
               Next 
            Next 
         Next 
      Next 
      
      ;}
      
      EndIf 
      ResetList ( wes_Examined_node()) ; WICHTIG, weil sonst ja nextelement nicht klappt ;)
      ProcedureReturn ListSize ( wes_Examined_node ()) 
   EndProcedure 

Procedure wes_examine_Next()
   ProcedureReturn NextElement ( wes_Examined_node())
EndProcedure

Procedure wes_Examine_get_AnzMeshID ()
   ProcedureReturn wes_Examined_node()\anz_Mesh_ID 
EndProcedure

Procedure.f wes_Examine_get_Distance () ; gibt die Camera-Distance heraus
   ProcedureReturn wes_Examined_node()\distance
EndProcedure

Procedure wes_Examine_get_Object3dID ()
   ProcedureReturn wes_Examined_node()\Object3dID 
EndProcedure

Procedure wes_Examine_get_IrrNode ()
   ProcedureReturn wes_Examined_node()\nodeID 
EndProcedure

Procedure wes_Examine_get_WaffeItemID ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ Waffe_Item_ID
EndProcedure

Procedure wes_Examine_get_Leben ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ leben
EndProcedure

Procedure wes_Examine_get_Mana ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ mana 
EndProcedure

Procedure wes_Examine_get_Art ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ art
EndProcedure

Procedure.s wes_Examine_get_Name ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ name
EndProcedure

Procedure wes_Examine_get_Team ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ Team
EndProcedure

Procedure wes_Examine_get_Action ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ action
EndProcedure

Procedure wes_Examine_get_GegnerID ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen \ gegnerid
EndProcedure

Procedure wes_Examine_get_WesenID ()
   Protected *wesen.wes_wesen , *anz_mesh.anz_mesh 
   *anz_mesh = wes_Examine_get_AnzMeshID()
   *wesen    = *anz_mesh  \ WesenID 
   ProcedureReturn *wesen
EndProcedure

; ACTIONS

Procedure wes_SetMoveWesenToWaypoint(*WesenID.wes_wesen  , *waypointid.WAYPOINT )
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   If Not *WesenID\action           = #wes_action_die 
      *WesenID\action               = #wes_action_move 
      *WesenID\pfad                 = way_getpathByWayPoint ( *WesenID\waypoint , *waypointid )
      *WesenID\pfad_currentWaypoint = CountString ( *WesenID\pfad , "|")
      ProcedureReturn *WesenID 
   EndIf 
EndProcedure

Procedure wes_AttackGegner(*WesenID.wes_wesen  , *GegnerWesenID.wes_wesen , Check_Sichtweite.i = 1) ; direktes Angreifen. 
   Protected px.f, py.f,pz.f,x.f,y.f,z.f
   
   If Not *WesenID  ; wenn wesenidpointer = 0, dann abbrechen!. wenn gegnerwesenid = 0, weitermachen.
      ProcedureReturn 0
   EndIf 
   
   If wes_getdistance( *WesenID , *GegnerWesenID ) < item_waffe_getReichweite  ( *WesenID\Waffe_Item_ID ) And Check_Sichtweite; wenn die sichtweite des Wesens zu gering, dann kann nicht angegriffen werden!
      ProcedureReturn 0
   EndIf 
   If Not *WesenID\action = #wes_action_die 
      *WesenID\gegnerid  = *GegnerWesenID 
      *WesenID\action    = #wes_action_attack
      *WesenID\pfad      = way_GetPathByPosition ( *WesenID\waypoint ,  x , y,  z)
      
      If Not *GegnerWesenID ; abbrechen,aber trotzdem successful anzeigen. -> in die Umgebung Hauen; alles treffen, was da ist.
         ProcedureReturn 1
      EndIf 
      
      If Not ( *GegnerWesenID\action    = #wes_action_attack Or *GegnerWesenID\action = #wes_action_moveAttack Or *GegnerWesenID\action = #wes_action_defend ) ; wenn der nicht grad selber kämpft:
         If *GegnerWesenID              \SpielerID <= 0 ; spieler greifen normal nicht an.. wesen sollten also nicht gestört werden (z.b. beim angreifen)
            *GegnerWesenID\action       = #wes_action_defend                                                 
            *GegnerWesenID\gegnerid     = *WesenID                                                           
         EndIf 
      EndIf 
    
      ProcedureReturn 1
   
   EndIf
EndProcedure

Procedure wes_Stand              ( *WesenID.wes_wesen  ) ; wenn nicht tot -> stehen
   If *WesenID <= 0
      ProcedureReturn 0
   EndIf 
   If *WesenID\action = #wes_action_die 
      ProcedureReturn 0
   EndIf 
   
   *WesenID\gegnerid             = 0 
   *WesenID\action               = #wes_action_stand
   *WesenID\pfad                 = ""
   *WesenID\pfad_currentWaypoint = 0
EndProcedure

Procedure wes_defend             ( *WesenID.wes_wesen , *gegnerid.wes_wesen , callforhelp)
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   If Not *WesenID\action = #wes_action_stand  ; verteidigen soll er nur bei 
      ProcedureReturn 0
   EndIf
   
   *WesenID\gegnerid = *gegnerid 
   *WesenID\action   = #wes_action_defend 
   
   If callforhelp ; umgebung nach unterstützung abfragen.
      
      wes_Examine_Reset( wes_getNodeID(*WesenID) )
      
      While wes_examine_Next() ; alle Wesen überprüfen
         
         *newwesen.wes_wesen = wes_Examine_get_WesenID()
         
         If team_IsFreund( *newwesen\Team , *WesenID\Team ) And Not ( team_IsFreund( *newwesen\Team , *gegnerid\Team )) ; wenn freunde in nähe, die nicht mit gegner auch verbündet sind.
            If  *newwesen\action = #wes_action_stand  ; wenn freund grad nichts besseres zu tun hat 
               wes_AttackGegner( *newwesen , *gegnerid)                                                                 ; dann soller beim Verteidigen helfen.
            EndIf 
         EndIf 
       
      Wend 
      
   EndIf 
   
EndProcedure 

Procedure wes_FlieFromGegner(*WesenID.wes_wesen , *gegnerid.wes_wesen)
   Protected x.f , y.f , z.f , vect.ivector3 , gx.f , gy.f , gz.f 
   If Not *WesenID Or Not *gegnerid 
      ProcedureReturn 0
   EndIf 
   If *WesenID\action = #wes_action_die 
      ProcedureReturn 0
   EndIf 
   
      E3D_getNodePosition ( anz_getObject3DIrrNode( anz_getobject3dByAnzID( *WesenID\anz_Mesh_ID ))  , @x  , @y  , @z)
      E3D_getNodePosition ( anz_getObject3DIrrNode( anz_getobject3dByAnzID( *gegnerid\anz_Mesh_ID )) , @gx , @gy , @gz)
      ; erst vector von Gegner zu Wesen berechnen, verlängern * 10m, vector an Pos of Wesen hängen , Wesen vectorentlang wegbewegen.
      vect\x            = (x - gx ) * 10 * #meter + x 
      vect\y            = (y - gy ) * 10 * #meter + y 
      vect\z            = (z - gz ) * 10 * #meter + z 
      *WesenID\action   = #wes_action_fliehen
      *WesenID\gegnerid = *gegnerid  ; flieht vorm Gegner.
      *WesenID\pfad     = way_getpathByWayPoint ( *WesenID\waypoint , way_getclosestwaypoint( vect\x , vect\y , vect\z ))
   ProcedureReturn 1
   
EndProcedure

Procedure wes_jump  ( *WesenID.wes_wesen , jumpart = #wes_action_jump_start )
   
   If Not *WesenID 
      ProcedureReturn 0
   EndIf 
   If *WesenID\action = #wes_action_die 
      ProcedureReturn 0
   EndIf 
   
      *WesenID\action              = jumpart 
   
EndProcedure 

; Update

Procedure wes_collective_attack ( *WesenList.i , amount.i ,  *GegnerWesenID.wes_wesen ) ; die newlist wesenlist = liste von WesenIDs; greifen alle gegnerwesenid an!. amount = anzahl der listenelemente.
   
   For x = 1 To amount 
      
   Next 
   
EndProcedure 

Procedure wes_UpdateWesen(*WesenID.wes_wesen) ; regelt Grundverhalten (instinkte) und komplette Animation der Wesen. + bewegen, kämpfen, etc
   Protected *spielerwesen.wes_wesen , *newwesen.wes_wesen , NewList wes_friendlist.i () , wes_friend_amount.i , x.f , y.f , z.f , x1.f , y1.f , z1.f , *startvector.ivector3 , *endvector.ivector3 , *Rot.ivector3 , *Collisionvector.ivector3 , *GegnerWesenID.wes_wesen , Gegnerdist.f
   If Not *WesenID > 0  
      ProcedureReturn 0
   EndIf 
   If GetAsyncKeyState_(#VK_1) And *WesenID\Name = "tom"
      *spielerwesen = spi_GetSpielerWesenID( spi_getcurrentplayer() )
      Debug "leben: " + StrF( wes_GetLeben( *spielerwesen ) ,2 )
      Debug "isfreund: " + Str(team_IsFreund( *spielerwesen\Team , *WesenID\Team  ))
      Debug (Not team_IsFreund( *spielerwesen\Team , *WesenID\Team  ) And Not ( *WesenID\action = #wes_action_attack Or *WesenID\action = #wes_action_moveAttack Or *WesenID\action = #wes_action_defend ) ) 
   EndIf 
   ; wesen  in richtung nächsten Waypoint verschieben
   ; anim_aktuell_frame.i     ; aktueller frame
   ; anim_aktuell_startframe.i; start der aktuellen animation
   ; anim_aktuell_endframe.i  ; ende der atuellen animation
   ; anim_gesch.w        ; aktuell_frame + animgesch.
   ; anim_list.s         ; animationliste der animation Z.B. "stehen,1,155|laufen,162,180|springenstarten,260,268|springenlanden,267,288"
   ; anim_currentanim.s  ; name der aktuellen Animation (z.b. "laufen")
   ; anim_try_to_end.w   ; sagt, dass er animation stoppen soll für nächste anim.. geht net, wenns gelocked ist.
   ; anim_islocked.w     ; wenn =1 -> animation kann nicht durch andere abgebrochen werden. (z.b. sterben nicht durch laufen)
   ; anim_islooped.w
   
   ;{ Spielerumgebung nach Gegnern prüfen (die ihn evtl angreifen + gegenseitig Verstärkungg holen.
         *spielerwesen = spi_GetSpielerWesenID( spi_getcurrentplayer() )
          
         If *spielerwesen 
            If Not ( *WesenID\action = #wes_action_attack Or *WesenID\action = #wes_action_moveAttack Or *WesenID\action = #wes_action_defend ) ; wenn wesen = gegner, und greift spieler noch nicht an

                   wes_Examine_Reset ( wes_getNodeID( *WesenID ) )
                   
                   While wes_examine_Next()

                      *newwesen = wes_Examine_get_WesenID()
                      
                      If Not *newwesen\action = #wes_action_attack 
                         If team_IsFreund     ( *newwesen\Team , *WesenID\Team ) And team_IsFreund ( *newwesen\Team , *spielerwesen\Team ) = 0 ; wenn neues wesen freund von wesenid und feind von spieler ist:
                            wes_AttackGegner  ( *newwesen , *spielerwesen ,0)  ; neuer bot greift spieler an.
                         ElseIf team_IsFreund ( *newwesen\Team , *spielerwesen\Team) And team_IsFreund ( *newwesen\Team , *WesenID\Team ) = 0 ; dann wesenid angreifen, spieler helfen ;)
                            wes_AttackGegner  ( *newwesen , *WesenID , 0 )
                         EndIf ; ansonsten nichts tun, einfach zuschaun.
                      EndIf 
                   
                   Wend 
                
            EndIf 
         EndIf 
   ;}
   If GetAsyncKeyState_( #VK_F ) And Not *spielerwesen\action = #wes_action_attack
      Debug *spielerwesen\action 
      CallDebugger 
   EndIf 
      
   Select *WesenID \ action 
   
       Case #wes_action_attack, #wes_action_moveAttack
       
         ;{ Angreifen regeln ( Wesen bewegen/drehen + Angriff starten. +fernkampfwafffen fliegen lassen + aufrücken, wenn feind zu weit weg)
            
            ; wenn gegner= tot: stand-prüfung wird weiter unten geregelt ;)
            ; erstmal Hindrehen zum Feind
               math_IrrFaceTarget( wes_getNodeID ( *WesenID ) , wes_getNodeID( *WesenID\gegnerid  )) 
               
            If item_waffe_getReichweite  ( *WesenID\Waffe_Item_ID ) >= wes_getdistance( *WesenID , *WesenID\gegnerid ) Or *WesenID\gegnerid = 0 ; wenn gegner schon in Reichweite
            
               
               ;{ wenn Gegner in Reichweite : KÄMPFEN!
               
               ; dann Kämpfen anfangen.
               If *WesenID\art           = #wes_art_bogen ; fernkampf
                  
                  ;{ Bogenkampf /armbrust/etc.
                  
                  If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_bow_Load
                  
                     ; wenn Laden fertig: Schießen!!
                     If ani_IsAnimationFree    ( *WesenID\anz_Mesh_ID   )
                        ani_SetAnim            ( *WesenID\anz_Mesh_ID   , #ani_animNR_bow_shoot ,0,0.4,1) ; nicht unterbrechbar.. auch nicht durch tot (der muss warten)
                        ; BOGEN auch bewegen lassen... PAUSE ....
                        kam_SchiesPfeil        ( *WesenID , *WesenID\gegnerid )
                     EndIf 
                  
                  Else ; ansonsten, wenn gerade nicht geladen wird ( Schießen lässt sich ja nicht beenden.
                     ani_SetAnim               ( *WesenID\anz_Mesh_ID   , #ani_animNR_bow_Load ) ; sobald animation frei ist: Schießen!!
                  EndIf 
                  
                  ;}
                  
               ElseIf *WesenID\art       = #wes_art_magie ; magierkampf
                  
                  ;{ magiekampf.. bzw. Heilen. halt Zaubern. ;)
                  
                  If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_magic ; solange die Animation nicht frei ist
                  
                     ; wenn Laden fertig: Schießen!!
                     If ani_IsAnimationFree       ( *WesenID\anz_Mesh_ID  )
                        kam_SchiesZauber          ( *WesenID , *WesenID\gegnerid , item_waffe_GetWaffenart( *WesenID\Waffe_Item_ID ))
                        ani_SetAnim               ( *WesenID\anz_Mesh_ID , #ani_animNR_magic ,0,0.4,1) 
                     EndIf 
                  
                  Else ; wenn gerade eine andere Animation lief: mit'm zaubern anfangen, und darauf warten, dass Zauber fertig ist (=animation fertig); dann zauber Frei!!.
                     ani_SetAnim                  ( *WesenID\anz_Mesh_ID , #ani_animNR_magic ,0,0.4,1)  ; sobald animation frei ist: Schießen!!
                  EndIf
                  
                  ;}
                  
               ElseIf *WesenID\art       = #wes_art_schwert Or *WesenID\art = #wes_art_handler Or *WesenID\art = #wes_art_tier ; Nahkampf
                  
                  ;{ Nahkampf, bzw. fliehen etc.
                  
                  If ani_getCurrentAnimationNR    ( *WesenID\anz_Mesh_ID ) = #ani_animNR_sword
                     
                     ; wenn Ausgeholt: Zuschlagen!
                     If ani_IsAnimationFree       ( *WesenID\anz_Mesh_ID  )
                        If *WesenID\gegnerid 
                           Debug "treffer! Leben: " + StrF( wes_GetLeben( *WesenID\gegnerid ))
                        EndIf 
                        ani_SetAnim               ( *WesenID\anz_Mesh_ID , #ani_animNR_sword , 0,0.4,1)
                        
                        kam_SchiesSchwert         ( *WesenID , *WesenID\gegnerid  ) ; wenn gegnerid= 0: in die umgebung haun und allen was abziehen (außer freunden)
                        If *WesenID\SpielerID     = spi_getcurrentplayer()          ; wenns der spieler ist, solls nur einmal kurz zuhaun und dann wieder normal stehen.
                           wes_Stand              ( spi_GetSpielerWesenID( spi_getcurrentplayer()))
                        EndIf 
                     EndIf 
                  
                  Else ; ansonsten, wenn gerade nicht geladen wird ( Schießen lässt sich ja nicht beenden.
                     ani_SetAnim                  ( *WesenID\anz_Mesh_ID , #ani_animNR_sword , 0,0.4,1)  ; sobald animation frei ist: zuschlagen!!
                  EndIf
                  
                  ;}
                  
               EndIf 
               
               ;}
               
            Else  ; wesen muss erst zum Gegner hinlaufen.
               
               ;{ Wenn geg. nicht in Reichweite: Hinlaufen!
                  If *WesenID\SpielerID <= 0  ; spieler laufen nicht von selbst überall hin!!
                  
                     ; schaun, ob noch Waypoint in Liste ist.
                     If  ani_getCurrentAnimationNR( wes_getAnzMeshID( *WesenID)) = #ani_animNR_run  Or ani_IsAnimationFree( wes_getAnzMeshID( *WesenID)) > 0
                        If *WesenID\pfad_currentWaypoint > 0 ; wenn noch mind. 1 Waypoint in Liste ist.
                        
                           If wes_MoveWesenToWaypoint          ( *WesenID , wes_GetWaypointPfadID( *WesenID ) ) ; wenn Waypoint erreicht wurde.
                              *WesenID\waypoint                = wes_GetWaypointPfadID( *WesenID )
                              *WesenID\pfad_currentWaypoint    - 1
                              *GegnerWesenID                   = *WesenID\gegnerid 
                              wes_getposition                  (  *GegnerWesenID , @x , @y , @z )
                              *WesenID\pfad                    = way_GetPathByPosition( *WesenID\waypoint , x , y , z )
                           EndIf 
                           
                        Else ; wenn nicht: querfeldein laufen.!
                           *GegnerWesenID          = *WesenID\gegnerid 
                           wes_getposition         ( *GegnerWesenID , @x , @y ,  @z )
                           wes_MoveWesenToPosition ( *WesenID ,       x , y , z ) ; bewegt sich so lange auf gegner zu, bis er nah genug ist und oberer code  anspringt. (Angriff)
                           wes_AttackGegner        ( *WesenID , *WesenID\gegnerid )  ; versucht, nen neuen waypoint-pfad zu berechnen.
                        EndIf 
                        
                        ; wenn gegner zu weit weg, oder er Flieht : aufhören, anzugreifen.
                        If wes_getdistance ( *WesenID , *WesenID\gegnerid ) > #meter * 10 Or (wes_getdistance( *WesenID , *WesenID\gegnerid ) > 6 *#meter  And wes_getAction( *WesenID\gegnerid) = #wes_action_fliehen ) ;
                           wes_Stand       ( *WesenID )
                           Debug "wesen flieht"
                        ElseIf wes_GetLeben    ( *WesenID\gegnerid ) <= 0 Or wes_getAction( *WesenID\gegnerid ) = #wes_action_die 
                           ; oder wenner tot/sterbend ist
                           Debug "wesen tot"
                           wes_Stand ( *WesenID )
                           
                        EndIf 
                     EndIf 
                  EndIf 
                  ;}
                  
            EndIf 
            
         ;}
         
      Case #wes_action_move
      
         ;{ bewegen regeln (Bodenprüfen, animation, in Bewegrichtung drehen verschieben etc , wenn er GegnerID drin hat, sobald Ziel erreicht: wieder auf ATTACK setzen.)
            ; schaun, ob noch Waypoint in Liste ist.
               If Not *WesenID\SpielerID > 0
                  If *WesenID\pfad_currentWaypoint > 0 ; wenn noch mind. 1 Waypoint in Liste ist.
                     
                     ; Wesen kann nur über waypoints laufen, von sich aus. (nicht querfeld ein.. außer bei angriffen.)
                     If wes_MoveWesenToWaypoint        ( *WesenID , wes_GetWaypointPfadID( *WesenID ) ) ; wenn Waypoint erreicht wurde.
                        *WesenID\pfad_currentWaypoint  - 1
                     EndIf 

                  EndIf
                  
               Else ; wenn ein spieler (dann werden keine waypoints vorhanden bzw. gebraucht)
                  ani_SetAnim( *WesenID\anz_Mesh_ID , #ani_animNR_run , 1 , 0.4 ) 
               EndIf 
         ;}
      
      Case #wes_action_die
      
         ;{ Wesen löschen, wenn TOT, und deleten, wenn sterbeanimation = aus
                  If wes_is_geladen       ( *WesenID ) = 0   ; wenn keine animation gespielt werden kann, da wesen nicht geladen 
                     wes_RemoveWesen      ( *WesenID )       ; -> gleich löschen.
                     ProcedureReturn      #wes_action_die    ; procedure abbrechen , weil der Pointer jetzt nicht mehr geht! ( es wird #wes_action_die erwartet, wenn wesen stirbt!!)
                  EndIf 
                  
                  ; Animation setzen
                  If ani_getCurrentAnimationNR    ( *WesenID\anz_Mesh_ID ) = #ani_animNR_die_back Or ani_getCurrentAnimationNR( *WesenID\anz_Mesh_ID) = #ani_animNR_die_front
                     
                        ; wenn Laden fertig: Schießen!!
                        If ani_IsAnimationFree    ( *WesenID\anz_Mesh_ID  )
                           ; Figur nun löschen.. evtl bei 1. Beta dann liegenlassen.... k.a...im Mom isses wie Diablo 
                            If *WesenID\SpielerID   = spi_getcurrentplayer() ; wenn die Figur derr Hauptspieler ist 
                                spi_revive ( spi_getcurrentplayer() , 0 , 0 , 0)         ; weiderbeleben.... 
                            Else                                             ; wenn figur nicht der Hauptspieler
                                wes_RemoveWesen        ( *WesenID )
                            EndIf 
                           ProcedureReturn      #wes_action_die ; wird #wes_action_die erwartet, wenn wesen stirbt!
                        EndIf 
                     
                  Else ; ansonsten, wenn gerade nicht geladen wird ( Schießen lässt sich ja nicht beenden.
                     ani_setaniminterruptable  ( *WesenID\anz_Mesh_ID   , 1 )
                     ani_SetAnim               ( *WesenID\anz_Mesh_ID   , #ani_animNR_die_back,0,0.4,1 ) 
                  EndIf 
         ;}
      
      Case #wes_action_stand
      
         ;{ STAND-Animaton setzen
            ani_SetAnim            ( *WesenID\anz_Mesh_ID   , #ani_animNR_stand ,1 , 0.4) ; setzt die Stehen animation
         ;}
      
      Case #wes_action_defend  
         
         ;{  verteidigen, wenn wesen angegriffen wird (nur bei Wesen vs Wesen.) dreht sich zu gegner und schlägt zurück, sobald Gegner zu nahe.
         
         If item_waffe_getReichweite  ( *WesenID\Waffe_Item_ID ) >= wes_getdistance( *WesenID , *WesenID\gegnerid ) ; wenn gegner schon in Reichweite
            
            ;{ wenn Gegner in Reichweite : KÄMPFEN!
            
            ; erstmal Hindrehen zum Feind
            math_IrrFaceTarget( wes_getNodeID ( *WesenID ) , wes_getNodeID( *WesenID\gegnerid  ))
            
            ; dann Kämpfen anfangen.
            If *WesenID\art           = #wes_art_bogen ; fernkampf
               
               ;{ Bogenkampf /armbrust/etc.
               
               If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_bow_Load
                  
                  ; wenn Laden fertig: Schießen!!
                  If ani_IsAnimationFree    ( *WesenID\anz_Mesh_ID  )
                     ani_SetAnim            ( *WesenID\anz_Mesh_ID   , #ani_animNR_bow_shoot ,0,0.4,1) ; nicht unterbrechbar.. auch nicht durch tot (der muss warten)
                     ; BOGEN auch bewegen lassen... PAUSE ....
                     kam_SchiesPfeil        ( *WesenID , *WesenID\gegnerid )
                  EndIf 
                  
               Else ; ansonsten, wenn gerade nicht geladen wird ( Schießen lässt sich ja nicht beenden.
                  ani_SetAnim               ( *WesenID\anz_Mesh_ID   , #ani_animNR_bow_Load ) ; sobald animation frei ist: Schießen!!
               EndIf 
               
               ;}
               
            ElseIf *WesenID\art       = #wes_art_magie ; magierkampf
               
               ;{ magiekampf.. bzw. Heilen. halt Zaubern. ;)
               
               If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_magic ; solange die Animation nicht frei ist
                  
                  ; wenn Laden fertig: Schießen!!
                  If ani_IsAnimationFree       ( *WesenID\anz_Mesh_ID  )
                     kam_SchiesZauber          ( *WesenID , *WesenID\gegnerid , item_waffe_GetWaffenart( *WesenID\Waffe_Item_ID ))
                     ani_SetAnim               ( *WesenID\anz_Mesh_ID , #ani_animNR_magic ,0,0.4,1) 
                  EndIf 
                  
               Else ; wenn gerade eine andere Animation lief: mit'm zaubern anfangen, und darauf warten, dass Zauber fertig ist (=animation fertig); dann zauber Frei!!.
                  ani_SetAnim                  ( *WesenID\anz_Mesh_ID , #ani_animNR_magic ,0,0.4,1)  ; sobald animation frei ist: Schießen!!
               EndIf
               
               ;}
               
            ElseIf *WesenID\art       = #wes_art_schwert Or *WesenID\art = #wes_art_handler Or *WesenID\art = #wes_art_tier ; Nahkampf
               
               ;{ Nahkampf, bzw. fliehen etc.
               
               If ani_getCurrentAnimationNR    ( *WesenID\anz_Mesh_ID ) = #ani_animNR_sword
                  ; wenn Ausgeholt: Zuschlagen!
                  If ani_IsAnimationFree       ( *WesenID\anz_Mesh_ID  )
                     kam_SchiesSchwert         ( *WesenID , *WesenID\gegnerid  )
                     ani_SetAnim               ( *WesenID\anz_Mesh_ID , #ani_animNR_sword , 0,0.4,1) 
                  EndIf 
                  
               Else ; ansonsten, wenn gerade nicht geladen wird ( Schießen lässt sich ja nicht beenden.
                  ani_SetAnim                  ( *WesenID\anz_Mesh_ID , #ani_animNR_sword , 0,0.4,1)  ; sobald animation frei ist: Schießen!!
               EndIf
               
               ;}
               
            EndIf 
        
            ;}
         
         EndIf 
         
         ;}
            
      Case #wes_action_fliehen 
      
         ;{ Fliehen setzen, wenn Wesen fast tot. (damit's sich später erholen kann)
         
         ; schaun, ob noch Waypoint in Liste ist.
               
         If *WesenID\pfad_currentWaypoint > 0 ; wenn noch mind. 1 Waypoint in Liste ist.
            
            ; Wesen kann nur über waypoints laufen, von sich aus. (nicht querfeld ein.. außer bei angriffen.)
            If wes_MoveWesenToWaypoint        ( *WesenID , wes_GetWaypointPfadID( *WesenID ) ) ; wenn Waypoint erreicht wurde.
               *WesenID\pfad_currentWaypoint  - 1
            EndIf 
            
         Else  ; wenn nicht: querfeldein laufen.!
               *GegnerWesenID          = *WesenID\gegnerid 
               wes_getposition         ( *WesenID , @x , @y , @z )
               wes_getposition         ( *GegnerWesenID , @x1 , @y1 , @z1 )
               x                       = x - x1 + x ; spitze minus fuß = vector --> plus position = zielcoordinate (möglichst weit weg halt ^^)
               z                       = z - z1 + z
               wes_MoveWesenToPosition ( *WesenID ,  x , y , z )
               wes_FlieFromGegner      ( *WesenID , *WesenID\gegnerid )  ; versucht, nen neuen waypoint-pfad zu berechnen. 
         EndIf 
         
         ; wenn gegner zu weit weg, oder er Flieht : aufhören, wegzulaufen.
           If wes_getdistance ( *WesenID , *WesenID\gegnerid ) > #meter * 15 Or (wes_getdistance( *WesenID , *WesenID\gegnerid ) > 6 *#meter  And wes_getAction( *WesenID\gegnerid) = #wes_action_fliehen ) ;
              wes_Stand       ( *WesenID )
           Else  ; wenn gegnerwesen noch zu nah da ist..
              
           EndIf 
           ; oder wenner tot/sterbend ist
           If wes_GetLeben    ( *WesenID\gegnerid ) <= 0 Or wes_getAction( *WesenID\gegnerid ) = #wes_action_die 
              wes_Stand       ( *WesenID )
           EndIf 
           
         ;}
      
      Case #wes_action_jump_start
         
         ;{ starten des springens
            
            ani_SetAnim                  ( *WesenID\anz_Mesh_ID   , #ani_animNR_jump_start ,0 , 0.4 , 1) ; setzt die sprung anim.. unterbrechbar, damit flugrolle unterbrechen kann!
            If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_jump_start
               anz_moveObject            ( anz_getobject3dByAnzID(*WesenID\anz_Mesh_ID) ,0,0,#meter * 1.3 )
               *WesenID\action           = #wes_action_jump_land 
            EndIf 
         ;}
         
      Case #wes_action_jump_land
         
         ;{ landen nach springen
         
            If ani_IsAnimationFree       ( *WesenID\anz_Mesh_ID ) ; wenn man oben in der luft ist: landen
               ani_SetAnim               ( *WesenID\anz_Mesh_ID   , #ani_animNR_stand ,0 , 0.4 , 0) ; setzt die Stehen animation
               wes_Stand                 ( *WesenID) ;
            EndIf 
         
         ;}
         
      Case #wes_action_jump_flugrolle_start  ; PAUSE.. noch nicht implemented.
         
         ;{ starten des springens

            ani_SetAnim                  ( *WesenID\anz_Mesh_ID   , #wes_action_jump_flugrolle_start ,0 , 0.4 , 1) ; setzt die Stehen animation
            If ani_getCurrentAnimationNR ( *WesenID\anz_Mesh_ID ) = #ani_animNR_jump_flugrolle_start
               Debug "flugrolle start"
               anz_moveObject            ( anz_getobject3dByAnzID(*WesenID\anz_Mesh_ID) ,#meter*0.4,0,#meter * 1.9 )
               *WesenID\action           = #wes_action_jump_land 
            EndIf 
         ;}
         
      Case #wes_action_jump_flugrolle_land
         
         ;{ landen nach springen
         
            If ani_IsAnimationFree       ( *WesenID\anz_Mesh_ID ) ; wenn man oben in der luft ist: landen
               ani_SetAnim               ( *WesenID\anz_Mesh_ID   , #ani_animNR_stand ,0 , 0.4 , 0) ; setzt die Stehen animation
               wes_Stand                 ( *WesenID) ;
            EndIf 
         
         ;}
         
      Case #wes_action_drop_item  ; PAUSE.. noch nicht in use..
      
    EndSelect     
            
         ;{ Prüfen, ob Gegner stirbt! (wenn ja: gegnerid=0 setzen und aufhören zu kämpfen)
         If *WesenID\gegnerid 
            *GegnerWesenID = *WesenID\gegnerid 
            If *GegnerWesenID\action = #wes_action_die 
               wes_Stand ( *WesenID )
            EndIf 
         EndIf 
         ;}
         
         ;{ Prüfen, ob Wesen TOT ist
         
         If *WesenID\leben <= 0 ; TOOT!
             *WesenID\action = #wes_action_die 
             wes_RemoveWesen( *WesenID )
             ProcedureReturn #wes_action_die 
         EndIf 
         
         ;}
         
         ;{ lebensenergie dazurechnen nach ZEIT. 
         ; leben aufladen etc.
         Zeit        = ElapsedMilliseconds() / 1000
         If Zeit     > *WesenID\Ladeinterval And *WesenID\leben > 0
            *WesenID \ Ladeinterval = Zeit + 3                    ; ladeintervall + 3 Minuten
            *WesenID \ leben        + (*WesenID\maxleben / 100 )  * 4 ; + 2% also ;) nach rund 2,5 Minuten is Leben bzw. mana wieder voll.
            *WesenID \ mana         + (*WesenID\maxmana  / 100 ) * 2 ; gleiches hier.
            If *WesenID \leben      > *WesenID\maxleben : *WesenID\leben  = *WesenID\maxleben : EndIf 
            If *WesenID \mana       > *WesenID\maxmana  : *WesenID\mana   = *WesenID\maxmana  : EndIf 
         EndIf 
            
         ;}
   
         ;{ Erdanziehung regeln (nach unten fallen lassen + Erdbeschleunigung )
         
         If wes_is_geladen( *WesenID )
            ; IrrMoveNodeUp ( wes_getNodeID( *WesenID) , - 0.001 * #meter /60)
         EndIf 
         ;}

EndProcedure

 
; jaPBe Version=3.9.12.818
; FoldLines=008F00950097009D009F00A500A700B500B700BD00BF00C500C700CD00CF00DC
; FoldLines=00DE00E200E400E900EB00F300F501000108010C010E01130115011A011C0121
; FoldLines=0123012D012F01330135015D015F018E019001960198019D019F01A401A801B6
; FoldLines=01B801F601F801FA01FC01FE02000202020402060208020A020C021102130218
; FoldLines=021A021F022102260228022D022F02340236023B023D024202440249024D0257
; FoldLines=025902760278028402A502B902BB02C60313035603180000032B0000033D0000
; FoldLines=035A037C03840393039703AF03B303B503B903FF03C5000003D8000004030423
; FoldLines=0427042E04320439043D044504490450
; Build=0
; FirstLine=389
; CursorPosition=1124
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF