; ------------------------------------------------------------
;   n3xt-D exemples
;
;   Sample 082  :  Physic and environment set
;                  
;   Historique  :
;     27/05/09  19:16    TMyke
;
; ------------------------------------------------------------




; Include files 
IncludePath #PB_Compiler_Home + "includes"   :   IncludeFile "n3xtD_PB.pbi"

;{ Declarations
Declare AddWaypoint (*LevelBody.IBody , *camera.ICamera , screenx =-1, screeny =-1, IsHinzufugen  =0 )
Declare main_MouseSetDeltay( mousedeltay)
Declare main_mouseSetDeltax( mousedeltax)
Declare main_MouseGetDeltay()
Declare main_MouseGetDeltax()
Declare main_mouseSety( mousey)
Declare main_mouseSetx(mousex)
Declare main_mousey()
Declare main_mousex ()
Declare main_mouseUpdate()
Declare main_Examine()
;}

Enumeration 
   #cam_flymodus_freefly ; free fly mode
   #cam_flymodus_fps ; first person
   #cam_flymodus_tps ; third person
EndEnumeration 

Enumeration    ; mouse events.
   #main_mouse_noevent
   #main_mouse_pressed
   #main_mouse_released
   #main_mouse_tipped
EndEnumeration 

#anz_meter            = 4.511627                 ; ein Meter ist demnach XX Pixel groß
#meter                = #anz_meter                ; weil oft aus versehen #Meter eingebaut wurde.. naja kann man nicht verdenken, 
#anz_Walkspeed        = #anz_meter /14            ; im Meter pro 60-tel Sekunde (Frame) . wie weit der spieler pro durchlauf geht.. 
#anz_raster_maxrasterelements = 200    ;
#anz_rasterboxbreite = #anz_meter * 80  ; also 100 pixel pro Rasterblock ; 35 = ungefähr 1 m in 3d welt.. (gerundet)
#anz_rasterboxhohe   = #anz_meter * 83 ; so aehnlich auch hier.. bisschen höher, weil weniger passiert, hier.
#anz_rasterbreite    = 150             ; anzahl der rasterkästen in breite und tiefe
#anz_rasterhohe      = 20              ; anzahl selbiger in der Höhe.
#anz_PBFont          = 0     ; Font zum schreiben von Text auf Texturen.
#anz_max_children    = 5     ; jedes 3d objekt kann 5 child-nodes mit sichverknüpfen.
#anz_any             = -2147483648  ; um z.b. bei rotateanznode ein paar axen nicht bewegen zu wollen.. wie pb_any. 

; structure 

Structure main_line3d
   x.F
   y.F
   z.F
   x1.F
   y1.F
   z1.F
   color.i
EndStructure 

; Globales
Global	anglex.F, angley.F, flagXDown.w
Global	mox.F, omx.F, moy.l, omy.l
Global *app.l, Quit.l
Global camPos.iVECTOR3
Global camDir.iVECTOR3
Global Position.POINT
Global cam_speed.F  = 1
Global cam_speed_fast.F = 3
Global cam_speed_slow.F = 0.5
Global kistenzahl = 0
Global Cam_Velocity.iVECTOR3
Global Cam_FlyMode 
Global *mesh.IMesh 
Global ab.AABBOX
Global *obj.IObject
Global main_mousedeltax 
Global main_mousedeltay 
Global main_mousex
Global main_mousey 
Global main_mousebutton1
Global main_mousebutton2
Global main_mousebutton3
Global main_screenwidth  = 1600
Global main_screenheight = 900
Global NewList main_line3d.main_line3d()

Position\x = 500
Position\y = 500

Procedure main_Examine()
   main_mouseUpdate() ; maus updaten
EndProcedure 

Procedure main_screenwidth()
   ProcedureReturn main_screenwidth 
EndProcedure 

Procedure main_screenheight ()
   ProcedureReturn main_screenheight
EndProcedure 

;{  Mouse Procedures

Procedure main_mouseUpdate()
   GetCursorPos_(Position.POINT ) 
   mousedeltax = (Position\x - main_screenwidth()/2) 
   mousedeltay = (Position\y - main_screenheight()/2) 
   SetCursorPos_(main_screenwidth()/2,main_screenheight()/2)
   mousex = main_mousex()
   mousey = main_mousey()
   
   mousex + mousedeltax
   mousey + mousedeltay
   If mousex > main_screenwidth(): mousex = main_screenwidth() : EndIf 
   If mousex < 0 : mousex = 0 : EndIf 
   If mousey > main_screenheight() : mousey = main_screenheight() : EndIf 
   If mousey < 0 : mousey = 0 : EndIf 
   
   main_mouseSetx ( mousex)
   main_mouseSety ( mousey)
   main_mouseSetDeltax ( mousedeltax)
   main_MouseSetDeltay ( mousedeltay )
   
   If getasynckeystate_(1) 
      If main_mousebutton1 = #main_mouse_noevent
         main_mousebutton1 = #main_mouse_tipped
      ElseIf main_mousebutton1 = #main_mouse_tipped
         main_mousebutton1 = #main_mouse_pressed
      EndIf 
   Else 
      If Not (main_mousebutton1 = #main_mouse_noevent Or main_mousebutton1 = #main_mouse_released )
         main_mousebutton1 = #main_mouse_released 
      Else 
         main_mousebutton1 = #main_mouse_noevent
      EndIf 
   EndIf 
   
   If getasynckeystate_(2) 
      If main_mousebutton2 = #main_mouse_noevent
         main_mousebutton2 = #main_mouse_tipped
      ElseIf main_mousebutton2 = #main_mouse_tipped
         main_mousebutton2 = #main_mouse_pressed
      EndIf 
   Else 
      If Not (main_mousebutton2 = #main_mouse_noevent Or main_mousebutton2 = #main_mouse_released )
         main_mousebutton2 = #main_mouse_released 
      Else 
         main_mousebutton2 = #main_mouse_noevent
      EndIf 
   EndIf 
   
   If getasynckeystate_(3) 
      If main_mousebutton3 = #main_mouse_noevent
         main_mousebutton3 = #main_mouse_tipped
      ElseIf main_mousebutton3 = #main_mouse_tipped
         main_mousebutton3 = #main_mouse_pressed
      EndIf 
   Else 
      If Not (main_mousebutton3 = #main_mouse_noevent Or main_mousebutton3 = #main_mouse_released )
         main_mousebutton3 = #main_mouse_released 
      Else 
         main_mousebutton3 = #main_mouse_noevent
      EndIf 
   EndIf 
EndProcedure 

Procedure main_mousex ()
   ProcedureReturn main_mousex 
EndProcedure 

Procedure main_mousey()
   ProcedureReturn main_mousey
EndProcedure 

Procedure main_mouseSetx(mousex)
   main_mousex = mousex 
EndProcedure 

Procedure main_mouseSety( mousey)
   main_mousey = mousey
EndProcedure 

Procedure main_MouseGetDeltax()
   ProcedureReturn main_mousedeltax
EndProcedure 

Procedure main_MouseGetDeltay()
   ProcedureReturn main_mousedeltay
EndProcedure 

Procedure main_mouseSetDeltax( mousedeltax)
   main_mousedeltax = mousedeltax 
EndProcedure 

Procedure main_MouseSetDeltay( mousedeltay)
   main_mousedeltay = mousedeltay
EndProcedure 

Procedure main_MouseButton(button)
   If button = 1
      ProcedureReturn main_mousebutton1
   ElseIf button = 2
      ProcedureReturn main_mousebutton2
   ElseIf button = 3 
      ProcedureReturn main_mousebutton3
   EndIf 
EndProcedure 

;}

;{ line 3d management:

Procedure main_Line3dDraw( x.F , y.F , z.F , x1.F , y1.F ,z1.F , color ) ; Zeigt eine Runde die Line3d an, wird nachm anzeigen wieder gelöscht
   If AddElement ( main_line3d())
      With main_line3d()
         \x = x 
         \y = y 
         \z = z
         \x1 = x1
         \y1 = y1
         \z1 = z1
         \color = color 
      EndWith 
   EndIf 
EndProcedure 

Procedure main_Line3dDisplay() ; zeigt alle line3ds an. 
   ForEach main_line3d()
      With main_line3d()
         iDrawLine3D (\x ,\y ,\z , \x1,\y1,\z1 ,\color)
      EndWith 
   Next 
   ClearList( main_line3d())
EndProcedure

;}

Procedure AddWaypoint (*LevelBody.IBody , *camera.ICamera , screenx =-1, screeny =-1, IsHinzufugen  =0 ) ; prüft umgebung auf waypoints und fügt diese hinzu (wenn nicht schon da)
    Protected start.iVECTOR3 , eend.iVECTOR3 , *campos.iVECTOR3 , *pickpos.iVECTOR3 
    Static *Previewcube , *previewcube_small
    
    If *Previewcube = 0 ; previewcube basteln
       *Previewcube = iCreateCube( 0.45*#meter )
       iMaterialFlagNode ( *Previewcube , #EMF_LIGHTING , 1 ) 
       iMaterialFlagNode( *Previewcube , #EMF_NORMALIZE_NORMALS , 1 )
       iEmissiveColorNode(*Previewcube , RGB(25,233,23))
       iSpecularColorNode(*Previewcube , RGB(25,233,23))
       iGlobalColorNode  ( *Previewcube , RGB(25,233,23))
    EndIf 
    
    If *previewcube_small = 0 
       *previewcube_small = iCreateCube ( 0.4 * #meter ) 
       iMaterialFlagNode ( *previewcube_small , #EMF_LIGHTING , 1 ) 
       iMaterialFlagNode( *previewcube_small , #EMF_NORMALIZE_NORMALS , 1 )
       iEmissiveColorNode(*previewcube_small , RGB(23,23,233))
       iSpecularColorNode(*previewcube_small , RGB(25,233,23))
       iGlobalColorNode  ( *previewcube_small, RGB(25,233,23))
    EndIf 
    
    *campos  = AllocateMemory( SizeOf ( iVECTOR3))
    *pickpos = AllocateMemory( SizeOf ( iVECTOR3))
    
    If Not ( *camera > 0 And *LevelBody > 0 ) ; prüfen ob cam und body da
       ProcedureReturn 
    EndIf 
    If screenx = -1 
       screenx = main_screenwidth / 2
    EndIf 
    If screeny = -1 
       screeny = main_screenheight / 2
    EndIf 
    
    
    
    ; zuerst -> picked punkt suchen.
    iVisibleNode( *Previewcube , 0 ) ; die previewcubes hiden, damit sie beim picken nicht reinschneien..
    iVisibleNode( *previewcube_small , 0 ) 
    
    iNodePosition( *camera , *campos )
    iPickCamera ( *camera,screenx,screeny, #ENT_PICKFACE, #meter * 20 )
    iPickedPosition( *pickpos )
    ;Debug "pickpos: " + StrF( *pickpos\x ,2) + " " +StrF( *pickpos\y ,2) + " " + StrF( *pickpos\z ,2) + " camPos: " +StrF( *campos\x ,2) + " " +StrF( *campos\y ,2) + " " + StrF( *campos\z ,2) 
    main_Line3dDraw(*campos\x , *campos\y , *campos\z, *pickpos\x , *pickpos\y , *pickpos\z , $FFAAAAFF)
    
    iPositionNode( *previewcube_small , *pickpos\x , *pickpos\y , *pickpos\z ) ; der kleine würfel, der nicht am raster ausgerichtet ist.
    *pickpos\x = Round(*pickpos\x / 10 , #PB_Round_Nearest) * 10
    *pickpos\z= Round(*pickpos\z / 10 , #PB_Round_Nearest ) * 10
    iVisibleNode( *Previewcube , 1 )
    iVisibleNode( *previewcube_small , 1)
    iPositionNode( *Previewcube , *pickpos\x , *pickpos\y , *pickpos\z ) ; eine vorschau, die am raster orientiert ist.
    ; waypoint hinzufuegen:
    
    If IsHinzufugen > 0 
          
          *cube = iCreateCube( #meter * 0.5 )
          iPositionNode( *cube , *pickpos\x , *pickpos\y , *pickpos\z ) 
          ; dann 3D Umgebung checken; mit einer for-next schleife links rechts vorne hinten etc. suchen.
          ; For x = -5 To 5
            ; For y = -5 To 5 
                ; Vec3_AddF(@start, @start, 0,0,0.15)
                ; Vec3_AddF(@eend, @eend, 0,0,0.15)
                ; *res.l = iCollideRayCastAll( start\x, start\y, start\z, eend\x, eend\y, eend\z, 1, @dist)
                ; If *res ; waypoint gefunden sozusagen.
                  ; 
                ; EndIf
              ; 
              ; Next 
          ; Next 
     EndIf 
     
EndProcedure 

Procedure DrawTriangle()  ; zeigt das letzte gepickte Dreieck an.
  Protected Dim tri.iVECTOR3(2)
  Protected Dim terrainMatrix.F(15)
  iPickedtriangle (@tri(0)\x)
  iDrawTriangle3D(@tri(0)\x,  $FFFF0000)
EndProcedure

;{ Raster Management:

Procedure RegisterRaster( Waypoint, x , y , z ); fügt einen neuen waypoints zum raster hinzu.

EndProcedure 

Procedure UnregisterRaster ( Waypoint ) ; löscht einen waypoint aus dem raster.

EndProcedure 

Procedure SaveRasterBlock( x,y,z) ; speichert die heightpoints

EndProcedure 

Procedure LoadRasterBlock ( x,y,z) ; ladet die heightpoints

EndProcedure 

;}

;----------------------------------------------------------
; open n3xt-D screen
iinitengine()

*app = iCreateGraphics3D(main_screenwidth(),main_screenheight(),32,0 ,1,#EDT_DIRECT3D9) ; 32 bit, isfullscreen, double precision, graphics renderer.
; << OR >>
;*app = iCreateGraphics3D(800,600, 32, #False, #True, #EDT_DIRECT3D9)
If *app= #Null
  End
EndIf
 
 
  SetCurrentDirectory("gfx\welteditor\") 


;----------------------------------- 
; add in memory management system a zip file 
 iAddZipFileArchive( "chiropteradm.pk3" )


;-----------------------------------
; load Quake3 scene object
  *obj.IObject = iLoad3DObject("chiropteradm.bsp")
  ; scale object geometry (too big)
  *geo.l = iObjectGeometry(*obj)
  iScaleMeshBuffer(*geo,  0.1,0.1,0.1)

;-----------------------------------
; create a mesh with our 3D object loaded
  iSetPolysPerNode(128)
  *mesh.IMesh = iCreateMeshInOctree(*obj)
  iNodeBoundingBox(*mesh,  @ab)
; set global physical dimension scene 
  iSetWorldSize(ab\MinEdge\x, ab\MinEdge\y, ab\MinEdge\z, ab\MaxEdge\x, ab\MaxEdge\y, ab\MaxEdge\z)
  ;iGravityForce( 0,-9.81*#meter,0)
  
; now, we can set body scene
  ; set collide form
  iSetCollideForm(#COMPLEX_PRIMITIVE_SURFACE)
  ; create body, no dynamique
  iCreateBody(*mesh, #False)
;-----------------------------------



;-----------------------------------------
; create first  camera
Global *cam.ICamera = iCreateCamera( )
iPositionNode(*cam, 0,10,0)
iRotateNode(*cam, 20,160,0)

;-----------------------------------
; load font png
iLoadFont("courriernew.png")
Global *font.IGUIFont = iGetFont()





; ---------------------------------------
;           main loop
; ---------------------------------------
     iNodePosition(*cam, @camPos\x)
     ; create mesh to shoot
     *cam_cubemesh.IMesh = icreatesphere(3 , 10)
     iLoadTextureNode(*cam_cubemesh, "wcrate.bmp") 
     iPositionNode(*cam_cubemesh, camPos\x,camPos\y,camPos\z)
     iRotateNode(*cam_cubemesh, Random(180),Random(180),Random(180))    
     
     ; create body
     iSetCollideForm(#BOX_PRIMITIVE)
     *cam_cube.IBodySceneNode = iCreateBody(*cam_cubemesh)
     iMassBody( *cam_cube , 0.001)
     iPositionNode ( *cam , camPos\x , camPos\y + 20 , camPos\z)
     ; iFrictionPhysicMaterial ( *cam_cube , 
     
     
Repeat

   
   main_Examine()
   
   ;{ Keyboardabfragen:
   
   ;{ Cubelinie schießen
   
   If  iGetKeyUp(#KEY_KEY_1)
     For x = 1 To 6
        kistenzahl + 1 
        iNodePosition(*cam, @camPos\x)
        iNodeDirection(*cam, @camDir\x)
        ; create mesh to shoot
        *cube.IMesh = iCreateCube(5)
        iLoadTextureNode(*cube, "wcrate.bmp") 
        iPositionNode(*cube, camPos\x + x * 10,camPos\y,camPos\z)
        iRotateNode(*cube, Random(180),Random(180),Random(180))    
        ; create body
        iSetCollideForm(#BOX_PRIMITIVE)
        *body.IBodySceneNode = iCreateBody(*cube)
        iMassBody( *body , 10*x+1)
        Debug "lindamp: " + StrF(iBodyLinearDamping ( *body),2)
        iLinearDampingBody( *body , 0.01 + x * 0.6)
        iVelocityBody(*body, camDir\x*5*#meter, camDir\y*5*#meter, camDir\z*5*#meter)
     Next 
   EndIf
   
   ;}
   
   ;{ cubehaufen schießen
   
   If getasynckeystate_(#VK_2 )
     For x = -2 To 2
        For y = -2 To 2
          For z = -2 To 2
            If Random(50) = 1
              kistenzahl + 1 
              iNodePosition(*cam, @camPos\x)
              iNodeDirection(*cam, @camDir\x)
              ; create mesh to shoot
              *cube.IMesh = iCreateCube(1+Random(10)*0.2)
              iLoadTextureNode(*cube, "wcrate.bmp") 
              iPositionNode(*cube, camPos\x+ x * 2,camPos\y+y*2,camPos\z+z*2)
              iRotateNode(*cube, Random(180),Random(180),Random(180))    
              ; create body
              iSetCollideForm(#BOX_PRIMITIVE)
              *body.IBodySceneNode = iCreateBody(*cube)
              iVelocityBody(*body, camDir\x*20, camDir\y*20, camDir\z*20)
            EndIf 
          Next
       Next
     Next 
   EndIf
   ;}
   
   ;{ FPS/Flymode umschalfen
      If iGetKeyUp ( #KEY_F1)
          If Cam_FlyMode = #cam_flymodus_freefly
            Cam_FlyMode = #cam_flymodus_fps
          ElseIf Cam_FlyMode = #cam_flymodus_fps
            Cam_FlyMode = #cam_flymodus_tps 
          ElseIf Cam_FlyMode = #cam_flymodus_tps
            Cam_FlyMode = #cam_flymodus_freefly
          EndIf 
      EndIf 
   ;}
   
   ;{ camera bewegen etc.
 
 If Cam_FlyMode = #cam_flymodus_fps 
      
      ; PAUSE:
      ; --- 
      ; einen gesamtvektor einbauen, in den down/right/left etc. eingebaut wird.
      ; dann soll  ivelocitybody mit diesem vektor laufen. damit man auch schräg vorwärtsgehen kann.
      ; außerdem probieren, dass bewegen mit kollisionsvektor zu machen. kollision gegenüber dem boden....
      
      iNodePosition( *cam_cubemesh , camPos)
      iPositionNode( *cam , camPos\x , camPos\y , camPos\z)
      ibodyvelocity( *cam_cube   , Cam_Velocity )
      ; move camera with dir key and mouse (left click)
      iNodeDirection(*cam, @camDir\x)
      If iGetKeyDown(#KEY_ARROW_UP) Or iGetKeyDown ( #KEY_KEY_W)
        If camDir\y < 0 : camDir\y = 0 : EndIf 
        iVelocityBody(*cam_cube,  camDir\x*cam_speed*20,  Cam_Velocity\y ,  camDir\z*cam_speed*20)
      EndIf
      If iGetKeyDown(#KEY_ARROW_DOWN)  Or iGetKeyDown ( #KEY_KEY_S)
        If camDir\y < 0 : camDir\y = 0 : EndIf 
        camDir\x * -1
        camDir\y * -1
        camDir\z * -1
        iVelocityBody(*cam_cube,  camDir\x*cam_speed*20,  camDir\y*cam_speed*20, camDir\z*cam_speed*20)
      EndIf 
      
      If iGetKeyDown(#KEY_ARROW_right)  Or iGetKeyDown ( #KEY_KEY_D)
        ; iVelocityBody(*cam_cube, Cam_Velocity\x + camDir\x *cam_speed*20, Cam_Velocity\y +camDir\y  , Cam_Velocity\z + camDir\z)
        Debug "camdir: " + StrF(camDir\x ,2) + " y: " + StrF( camDir\y ,2) + " z: " + StrF( camDir\z ,2) 
        iTurnNode ( *cam , 0 , 90 , 0 )
        iNodeDirection(*cam, @camDir\x)
        iVelocityBody(*cam_cube,  camDir\x*cam_speed*20,  Cam_Velocity\y , camDir\z*cam_speed*20)
        iTurnNode ( *cam , 0 , -90 , 0 )
      EndIf 
      If iGetKeyDown(#KEY_ARROW_LEFT) Or iGetKeyDown ( #KEY_KEY_A)
        iTurnNode ( *cam , 0 , -90 , 0 )
        iNodeDirection(*cam, @camDir\x)
        iVelocityBody(*cam_cube,  camDir\x*cam_speed*20,  Cam_Velocity\y , camDir\z*cam_speed*20)
        iTurnNode ( *cam , 0 , 90 , 0 )
      EndIf 
      
      
      If iGetKeyDown( #KEY_SPACE)
        iVelocityBody(*cam_cube, 0,cam_speed*3,0)
      EndIf 
  ElseIf Cam_FlyMode = #cam_flymodus_freefly 
      
      If iGetKeyDown ( #KEY_ARROW_UP) Or iGetKeyDown ( #KEY_KEY_W) 
         iMoveNode ( *cam , 0 , 0 , cam_speed)
      EndIf 
      
      If iGetKeyDown ( #KEY_ARROW_DOWN ) Or iGetKeyDown ( #KEY_KEY_S)
         iMoveNode ( *cam , 0 , 0 , -cam_speed)
      EndIf 
      
      If iGetKeyDown ( #KEY_ARROW_LEFT) Or iGetKeyDown ( #KEY_KEY_A)
         iMoveNode ( *cam , -cam_speed , 0 , 0)
      EndIf 
      
      If iGetKeyDown( #KEY_ARROW_right ) Or iGetKeyDown ( #KEY_KEY_D)
          iMoveNode ( *cam , cam_speed , 0 , 0)
      EndIf 
      
  EndIf 
  ;}
  
  ;}
  
  ; speed umschalten
  If getasynckeystate_( #VK_SHIFT )
     cam_speed = cam_speed_fast 
  Else 
     cam_speed = cam_speed_slow 
  EndIf 
  
  ; camera drehen
  iTurnNode(*cam, main_MouseGetDeltay()/4, main_MouseGetDeltax()/4,0)

  ;3d punkte hinzufügen (waypoints)
  
  If Cam_FlyMode = #cam_flymodus_freefly ; nur wenn die Camera frei fliegt soll soll ding angezeigt werde
      If main_MouseButton(1) = #main_mouse_tipped
         AddWaypoint (*mesh, *cam,-1,-1,1 )
      Else
         AddWaypoint( *mesh, *cam) 
      EndIf 
  EndIf 
  
	; if Escape Key, exit	
  If iGetKeyDown(#KEY_ESCAPE)
    Quit=1
  EndIf


  	; ---------------
  	;      Render
  	; ---------------
  iBeginScene()
    iDrawScene()
    iDrawText(*font, "fps: "+Str(iFPS()),  10,10,0,0)
    iDrawText(*font, "Use SPACE Key for shoot Cube",  10,24,0,0)
    iDrawText(*font, "cam : "+StrF(iNodeY(*cam)),  10,45,0,0)
    iDrawText(*font, "Kistenzahl " + Str( kistenzahl) ,  10,65,0,0)
    main_Line3dDisplay()
    DrawTriangle()
  iEndScene()

Until Quit=1
; end
iFreeEngine()


; IDE Options = PureBasic 4.40 Beta 5 (Windows - x86)
; ExecutableFormat = Console
; CursorPosition = 84
; FirstLine = 81 
; jaPBe Version=3.9.12.819
; FoldLines=006500670069006B006D00D8006F000000AE000000B2000000B6000000BA0000
; FoldLines=00BE000000C2000000C6000000CA000000DA00F300DC000000EA000001B001C6
; FoldLines=01C801E0
; Build=3
; FirstLine=300
; CursorPosition=503
; EnableXP
; ExecutableFormat=Windows
; Executable=G:\Eigene Daten\Documents\Programmierung\Magical Twilight\Waypoint EDITOR.exe
; DontSaveDeclare
; EOF