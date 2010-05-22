; ------------------------------------------------------------------------------------------------------------------------------
; -- Procedures
; ------------------------------------------------------------------------------------------------------------------------------


   Procedure Way_AddWaypoint(x.f, y.f, z.f , *connectionid.i = -1) ; waypoint hinzufügen mit eventuellem Vorgänger-waypoint ( als 1. verbindung..)
      Protected *newwaypoint.WAYPOINT 
      
         *newwaypoint           = AddElement ( waypoint () )
         
            If *newwaypoint       
               
               ; create waypoint
                  If connection  > 0
                     way_connectwaypoints( *newwaypoint , *connectionid )
                  EndIf 
               
               ; object 3d       erstellen.. zum verlinken
               AddElement        ( anz_Object3d() )
               With anz_Object3d ()
                  \id            = *newwaypoint
                  \art           = #anz_art_Waypoint
                  \x             = x
                  \y             = y
                  \z             = z
               EndWith   
               
               *newwaypoint   \Object3dID = anz_Object3d()  ; zurückführend zum obj3d. (da man manchmal nur die anz_mesh_id weiß)
                
               
               anz_Raster_Register( anz_Object3d())
               
            EndIf 
            
         ProcedureReturn *newwaypoint 
         
   EndProcedure
   
   Procedure way_RemoveWaypoint(*waypointid.WAYPOINT )
      Protected *newpoint.WAYPOINT  , lastwaypoint.i
      
      lastwaypoint = waypoint()  ; speichern des alten wertes zum unteren wiederherstellen. [um andre proceduren nicht zu stören.] ( PUSH )
      
         ; aus Register der andren Waypoints löschen.
         For x = 0 To (*waypointid\anzahl_connections -1)  ; von 0 bis 10 !!!!
            
            *newpoint = *waypointid\connection [ x ]
            
            For y = 0 To ( *newpoint\anzahl_connections -1 )
               
               If *newpoint\connection [y] = *waypointid  ; wenn zu löschende ID gefunden:
                  *newpoint\connection [y] = *newpoint\connection[ *newpoint\anzahl_connections -1 ] ; überschreiben mit letztem Eintrag 
                  *newpoint\connection [ *newpoint\anzahl_connections -1 ] = 0                       ; letzen eintrag löschen (auf 0 setzen)
                  *newpoint\anzahl_connections - 1                                                   ; und intex -1.
                  Break                                                                              ; und break die schleife.. auf zum nächsten waypoint
               EndIf 
               
            Next 
            
         Next 
         
         ;wenn waypoint aus allen registern befreit:
         ChangeCurrentElement ( waypoint() , *waypointid )
         DeleteElement        ( waypoint ()) 
      
      If lastwaypoint 
         ChangeCurrentElement( waypoint() , lastwaypoint ) ; zurücksetzen des alten ( POP )
      EndIf 
      
   EndProcedure
   
   Procedure way_IsConnected ( *Waypoint1.WAYPOINT , *Waypoint2.WAYPOINT )
      Protected x.i , y.i , Connected_1.i 
      
      For x = 0 To *Waypoint1\ anzahl_connections  -1
         
         If *Waypoint1\connection[x] = *Waypoint2
            Connected_1 = 1
            Break 
         EndIf 
      
      Next 
      
      For x = 0 To *Waypoint2\anzahl_connections -1
            
         If  *Waypoint2\connection[x] = *Waypoint1 
             If Connected_1 = 1
                ProcedureReturn 1
             EndIf 
         EndIf
       
      Next 
         
   EndProcedure 
   
   Procedure way_connectwaypoints ( *waypointid.WAYPOINT , *childpointID.WAYPOINT ) ; connects both waypoints to each other... also verbinden.. XD my english ^^.
      
      If *waypointid = *childpointID  ; soll sich ja net mit sich selbst verbinden ^^..
         ProcedureReturn 0
      EndIf 
      
      If *waypointid And *childpointID 
         
         If *waypointid   \ anzahl_connections < #way_max_connections  And *childpointID \ anzahl_connections < #way_max_connections ; wichtig beim Löschen von waypoints: beide müssen die Verbindung haben. (damit mans von beiden später wieder löschen kann)
            If Not way_IsConnected( *waypointid , *childpointID ) ; wenn es eh schon verbunden ist..
               
               ; 1. waypoint
               *waypointid   \ anzahl_connections + 1
               *waypointid   \ connection [ *waypointid \ anzahl_connections -1] = *childpointID  ; -1, da 1. element = 0.!!!
               ; 2. waypoint
               *childpointID \ anzahl_connections + 1
               *childpointID \ connection [*childpointID  \ anzahl_connections -1] = *waypointid  ; hier gleiches.. -1, da 1. element ja auf null liegt, hier.
               Debug "Connected    " + Str(*waypointid   )
               Debug "Connected To " + Str(*childpointID )
            Else 
               Debug "waypoint ist schon verbunden"
            EndIf 
            
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure way_getclosestwaypoint ( x.f , y.f , z.f )
      Protected *waypointid.WAYPOINT , *object3d.anz_Object3d , dist.f , current_dist.f 
      
      anz_ExamineLoadedNodes( #anz_art_Waypoint , 1 , #meter * 30 , x,y,z ) ; untersucht alle object3d-s in umgebung von xyz.
      
      While anz_NextExaminedNode()
         
         *object3d    = anz_ExaminedNodeObj3DID ( )
         current_dist = math_distance3d         ( x , y , z , *object3d\x , *object3d\y , *object3d\z )
         If dist      < current_dist 
            dist      = current_dist 
            id        = anz_ExaminedNodeAnzID   ( ) ; gibt den waypoint-pointer heraus.
         EndIf 
         
      Wend 
      
      ProcedureReturn id ; die id des aktuellen waypoints
      
   EndProcedure 
   
   Procedure.s way_getpathByWayPoint( *Waypoint1.WAYPOINT  , *Waypoint2.WAYPOINT) ; berechnet den Pfad von A nach B ( also die Waypoints von dort zu da.)
   
      ProcedureReturn weg_GetPath ( *Waypoint1 , *Waypoint2 , 80 ) ; maximal über 80 knoten laufen.. von a nach b.
      
   EndProcedure 
   
   Procedure.s way_GetPathByPosition ( *waypointid.WAYPOINT ,  x.f , y.f , z.f )
      
      ProcedureReturn weg_GetPath ( *Waypoint1 , way_getclosestwaypoint( x,y,z) , 80 ) ; maximal über 80 knoten laufen.. von a nach b.
      
   EndProcedure 
   
   Procedure way_getwaypointPOS ( *waypointid.WAYPOINT , *x.i , *y.i , *z.i ) ; benötigt: @*x , @*y , @*z.
      Protected *Object3dID.anz_Object3d
      
      If *waypointid 
         
         *Object3dID = *waypointid\Object3dID
         
         If *x > 0
            PokeF ( *x , *Object3dID\x )
         EndIf 
         If *y > 0
            PokeF ( *y , *Object3dID\y )
         EndIf 
         If *z > 0
            PokeF ( *z , *Object3dID\z )
         EndIf 
      
      EndIf 
      
   EndProcedure 
   
   Procedure way_IsWaypointReached ( *WesenID.wes_wesen , *waypointid.WAYPOINT ) ; schaut, ob der Waypoint erreicht wurde.
      Protected x.f , y.f , z.f , wx.f , wy.f , wz.f
         
         If Not *WesenID Or Not *waypointid 
            ProcedureReturn 0
         EndIf 
         
         wes_getposition    ( *WesenID    , @x  , @y , @z )
         way_getwaypointPOS ( *waypointid , @wx ,@wy , @wz)
         
         tol = #meter / 2 ; toleranzbereich: halber Meter.
         If x + tol > wx And y +tol > wy And z+tol > wz 
            If x < wx + tol And y < wy + tol And z < wz + tol  ; wenn in BOX
               ProcedureReturn 1
            EndIf 
         EndIf 
          
      
   EndProcedure 
   
   Procedure.f way_getWegWert  ( *waypointid.WAYPOINT , art ) ; gibt für Wegfindung #way_Weg_wertart_F,..G,..H wert heraus
      
      If Not *waypointid
         ProcedureReturn 0
      EndIf 
      
      Select art  ; art des Waypoints.
         
         Case #Way_Weg_wertart_F
            
            ProcedureReturn *waypointid\Fwert 
            
         Case #Way_Weg_wertart_G
            
            ProcedureReturn *waypointid\Gwert 
            
         Case #Way_Weg_wertart_H
            
            ProcedureReturn *waypointid\Hwert 
            
      EndSelect 
      
   EndProcedure 
   
   Procedure way_getWegParent ( *waypointid.WAYPOINT) ; ebenfalls für Wegfindung.
      ProcedureReturn *waypointid\parent 
   EndProcedure 

   Procedure way_NextPathElement ( pfad_list.s ) ; gibt die ID des nächsten Waypoints aus, anhand der PfadList. SCHALTET aber NICHT weiter (den pfad.. muss ma selber machen)
      Protected anzahl_knoten
      
      anzahl_knoten = CountString ( pfad_list , "|" )
      ProcedureReturn Val( StringField ( pfad_list , anzahl_knoten , "|" ))  ; output: WaypointID.
      
   EndProcedure 
    
; jaPBe Version=3.8.8.716
; FoldLines=002600450047005D005F007A009000940096009A00B100C300C500DB00DD00DF
; FoldLines=00E100E7
; Build=0
; FirstLine=42
; CursorPosition=157
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF