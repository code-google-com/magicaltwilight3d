;; ----------------------------------------------------------------------------
;; Irrlicht Wrapper For Imperative Languages - Purebasic Examples
;; IrrlichtWrapper and FreeBasic-Example by Frank Dodd (2006)
;; Improved IrrlichtWrapper - Michael Taupitz (2007)
;; PureBasic-Examples by Michael Taupitz (neotoma) & Marius Eckardt (Thalius) 
;; ----------------------------------------------------------------------------
;; Example 24 : Embed Irrlicht
;; This example embeds the IrrlichtScene in a Gadget.
;; ----------------------------------------------------------------------------

;; ////////////////////////////////////////////////////////////////////////////
;; Include the Irr3D-Requester

; -----------constants -----------------------------------------

#GFXpath = "GFX\3D Versuch MD2anim\"

Enumeration
  #Window_0
EndEnumeration

Enumeration  ; gadgets
  #Container_0
  #Button_0
  #Editor_0
  #TrackBar_0
  #Button_1
  #Button_2
  #Button_3
  #Button_4
  #Text_animspeed
  #String_animspeed
  #Text_1
  #String_currentframe
  #Button_9
  #Text_3
  #String_startframe
  #Text_4
  #Text_5
  #String_endframe
  #Button_12
  #Button_14
  #Button_17
  #TrackBar_1
  #TrackBar_2
  #Text_8
EndEnumeration

; ------------includes------------------------------------------

XIncludeFile #PB_Compiler_Home + "Includes\IrrlichtWrapper_Include.pbi"

; irrlicht objects
Define *MD2Mesh.l
Define *MeshTexture.l
Global *camera.l
Global *FPSCamera.l    
Global aktuell_frame.l
Global playanimation.l
Global anzahl_Frames.l = 800
Global speed = 1

Procedure.f pos( zahl.f)
   
   If zahl < 0
      zahl * -1
   EndIf 
   ProcedureReturn zahl
   
EndProcedure 

Procedure.f dist( x1.f,y1.f,z1.f , x2.f,y2.f,z2.f)  ; für distance D
   Protected x.f,y.f,z.f
   
   x = x2-x1
   y = y2-y1
   z = z2-z1
   
   ProcedureReturn Sqr( pos( Pow(x , 2)+ Pow(y,2) + Pow(z,2)))
   
EndProcedure 

Procedure examine ()
   Protected x.f,y.f,z.f , Dim keyMap.IRR_KEYMAP(8) , *cam.l , x1.f,y1.f,z1.f , x2.f,y2.f,z2.f
   Static space_pressed.w
   
   ; keyboard 
      If GetActiveWindow() = #Window_0 ; wenn des Programm aktuell dran is.
      
      ;{  die FPS Camera nach SPACE drücken
      
      If GetAsyncKeyState_( #VK_SPACE) 
         If space_pressed = 0
            If Not GetActiveGadget() = #Editor_0 
               space_pressed = 1
            
               ; keyMap(0)\action = #IRR_EKA_MOVE_FORWARD;
               ; keyMap(0)\KeyCode = #IRR_KEY_ARROW_UP;
               ; keyMap(1)\action = #IRR_EKA_MOVE_FORWARD;
               ; keyMap(1)\KeyCode = #IRR_KEY_KEY_W;
               ; keyMap(2)\action = #IRR_EKA_MOVE_BACKWARD;
               ; keyMap(2)\KeyCode = #IRR_KEY_ARROW_DOWN;
               ; keyMap(3)\action = #IRR_EKA_MOVE_BACKWARD;
               ; keyMap(3)\KeyCode = #IRR_KEY_KEY_S;
; 
               ; keyMap(4)\action = #IRR_EKA_STRAFE_LEFT;
               ; keyMap(4)\KeyCode = #IRR_KEY_ARROW_LEFT;
               ; keyMap(5)\action = #IRR_EKA_STRAFE_LEFT;
               ; keyMap(5)\KeyCode = #IRR_KEY_KEY_A;
; 
               ; keyMap(6)\action = #IRR_EKA_STRAFE_RIGHT;
               ; keyMap(6)\KeyCode = #IRR_KEY_ARROW_RIGHT;
               ; keyMap(7)\action = #IRR_EKA_STRAFE_RIGHT;
               ; keyMap(7)\KeyCode = #IRR_KEY_KEY_D;
   
               *FPSCamera = IrrAddFPSCamera(1,100,0.0,8)
               IrrSetCameraNearValue (*FPSCamera , 0.001)
               IrrGetNodePosition(*camera , @x,@y,@z)
               IrrSetNodePosition(*FPSCamera , x , y , z)
               IrrSetActiveCamera(*FPSCamera)
               IrrGetNodeRotation(*camera , @x,@y,@z)
               IrrSetNodeRotation(*FPSCamera , x , y , z)
            EndIf 
          ElseIf space_pressed = 2  
             space_pressed = 3
             IrrSetActiveCamera(*camera)
             IrrGetNodePosition(*FPSCamera , @x,@y,@z)
             IrrSetNodePosition(*camera , x , y , z)
             IrrGetNodeRotation(*FPSCamera , @x,@y,@z)
             IrrSetNodeRotation(*camera , x , y , z)
             IrrDropPointer(*FPSCamera)
          EndIf 
       Else 
          If space_pressed = 1
             space_pressed = 2
          ElseIf space_pressed = 3
             space_pressed = 0
          EndIf 
       EndIf 
       
       If GetAsyncKeyState_(2)  ; rechte maustaste zum abberchen von FPS mode
          If space_pressed = 1 Or space_pressed = 2
             space_pressed = 3
             IrrSetActiveCamera(*camera)
             IrrGetNodePosition(*FPSCamera , @x,@y,@z)
             IrrSetNodePosition(*camera , x , y , z)
             IrrGetNodeRotation(*FPSCamera , @x,@y,@z)
             IrrSetNodeRotation(*camera , x , y , z)
             IrrDropPointer(*FPSCamera)
             space_pressed = 3
          EndIf 
       EndIf 
       
       ;}
       
      ;{ ESC = programme beenden
      
       If GetAsyncKeyState_(#VK_ESCAPE)
          IrrStop()
          CloseWindow(#Window_0)    ; sonst fehlermeldung..
          End
       EndIf 
       
      ;}
      
      ;{ camera mit Pfeiltasten bewegen
         
         If Not GetActiveGadget() = #Editor_0 
         
         *cam = IrrGetActiveCamera()
         
         IrrGetNodePosition( *cam , @x1,@y1,@z1)
         IrrGetCameraTarget( *cam , @x2,@y2,@z2)
         
         If dist( x1,y1,z1,x2,y2,z2) < 8   ; wennman zu nah am Objekt ist, dann bleibtma stehn.
         
            If GetAsyncKeyState_(#VK_RIGHT)  
               IrrMoveNodeForward(*cam , 10) Or GetAsyncKeyState_(#VK_D)
            EndIf 
         
         EndIf 
         
         If GetAsyncKeyState_(#VK_LEFT)
            IrrMoveNodeForward(*cam , -10) Or GetAsyncKeyState_(#VK_A)
         EndIf 
         If GetAsyncKeyState_(#VK_UP) Or GetAsyncKeyState_(#VK_W)
            IrrMoveNodeRight( *cam , 10)
         EndIf 
         If GetAsyncKeyState_(#VK_DOWN) Or GetAsyncKeyState_(#VK_S)
            IrrMoveNodeRight( *cam , -10)
         EndIf 
         
         If GetAsyncKeyState_(#VK_F1)
            IrrSetNodePosition(*cam ,50 , 50 , 0)
            IrrSetNodeRotation(*cam , 0 , 0 , 0)
            IrrSetCameraTarget( *cam , 0 , 0 , 0)
         EndIf 
         
         EndIf 
    EndIf 
    
    ;}
    
EndProcedure 

Procedure getendframe( *node)
   Protected fr.w , frame.w , ende.w , time.l , endtime.l
   
   If *node 
      IrrPlayNodeMD2Animation( *node , 0)
      IrrSetNodeAnimationSpeed( *node , 1000)
   EndIf 
   
   endtime = ElapsedMilliseconds() + 3000
   
   Repeat 
   
   If endtime < ElapsedMilliseconds() Or ( GetAsyncKeyState_(#VK_ESCAPE) And GetActiveWindow() = #Window_0 )
      Break 
   EndIf 
   
   If IrrRunning()
          If *node 
             fr = IrrGetNodeAnimationFrame( *node)
          EndIf 
          
          If fr >= frame 
             frame = fr
          Else 
             ende = frame
          EndIf 
          
          ; IrrBeginScene( 240, 255, 255 )
          ; ; draw the scene
          ; IrrDrawScene()      
          ; ; draw the GUI
          ; IrrDrawGUI()
        ; end drawing the scene and render it
          IrrEndScene()
          
   EndIf
   
   Until ende > 0
   
   ProcedureReturn frame 
   
EndProcedure 


  If OpenWindow(#Window_0, 50, 149, 848, 694, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
    If CreateGadgetList(WindowID(#Window_0))
      ButtonGadget(#Button_0, 10, 50, 130, 30, "Load MD2 Model")
      EditorGadget(#Editor_0, 10, 210, 200, 440)
      TrackBarGadget(#TrackBar_0, 10, 110, 760, 20, 0, 10 , #PB_TrackBar_Ticks )
      ButtonGadget(#Button_1, 190, 70, 40, 30, "<<")
      ButtonGadget(#Button_2, 230, 70, 40, 30, ">")
      ButtonGadget(#Button_3, 310, 70, 40, 30, ">>")
      ButtonGadget(#Button_4, 270, 70, 40, 30, "| |")
      TextGadget(#Text_animspeed, 370, 70, 70, 20, "Animspeed:", #PB_Text_Border)
      StringGadget(#String_animspeed, 450, 70, 100, 20, "", #PB_String_Numeric)
      TextGadget(#Text_1, 560, 70, 80, 20, "Current Frame:", #PB_Text_Border)
      StringGadget(#String_currentframe, 650, 70, 110, 20, "", #PB_String_Numeric)
      ButtonGadget(#Button_9, 10, 180, 50, 30, "Add")
      TextGadget(#Text_3, 10, 150, 110, 20, "Notizbox:")
      TextGadget(#Text_4, 370, 50, 70, 20, "Startframe:", #PB_Text_Border)
      StringGadget(#String_startframe, 450, 50, 100, 20, "", #PB_String_Numeric)
      TextGadget(#Text_5, 560, 50, 80, 20, "Endframe:", #PB_Text_Border)
      StringGadget(#String_endframe, 650, 50, 110, 20, "", #PB_String_Numeric)
      ButtonGadget(#Button_12, 230, 40, 40, 30, "| > |")
      ButtonGadget(#Button_14, 10, 20, 130, 30, "Load Texture")
      ButtonGadget  (#Button_17, 10, 90, 130, 20, "Set Anzahl Frames")
      TrackBarGadget(#TrackBar_1, 780, 140, 30, 550, 0, 550, #PB_TrackBar_Ticks | #PB_TrackBar_Vertical)
      TrackBarGadget(#TrackBar_2, 810, 140, 30, 550, 0, 550, #PB_TrackBar_Ticks | #PB_TrackBar_Vertical)
      TextGadget    (#Text_8, 780, 90, 60, 40, "scale: grob/fein", #PB_Text_Border)
      ; -
      ContainerGadget(#Container_0, 210, 140, 560, 550, #PB_Container_Flat)
      CloseGadgetList()
      
      SetGadgetText ( #String_animspeed , "1")
      SetGadgetText ( #String_currentframe , "0" )
      SetGadgetText ( #String_endframe, Str(endframe))
      SetGadgetText ( #String_startframe , Str(startframe))
      SetGadgetState( #TrackBar_1 , 2)
      SetGadgetState( #TrackBar_2 , 225)
      Debug GetGadgetState(#TrackBar_1)
    EndIf 
  EndIf 
   
  
  If IrrStartEx               (#IRR_EDT_DIRECT3D9 ,560, 550,1,0,0, 32, 1, 1,1,GadgetID(#Container_0) )      
    
    IrrGuiAddStaticText       ( "ESC = END, F1 = Reset View, Arrowkeys or WASD = strange move view", 4,0,500,16, #IRR_GUI_NO_BORDER, #IRR_GUI_NO_WRAP )
    ; IrrSetNodeMaterialTexture ( *SceneNode, *MeshTexture, 0 )
    ; IrrSetNodeMaterialFlag    ( *SceneNode, #IRR_EMF_LIGHTING, #IRR_OFF )
    ; IrrPlayNodeMD2Animation   ( *SceneNode, #IRR_EMAT_STAND )
    
    *camera                = IrrAddCamera( 50,50,0, 0,0,0 )
    IrrSetCameraNearValue (*camera , 0.001)
    ;{ skybox
    
    Dim *textures(6)
    
    *textures(0) = IrrGetTexture(#GFXpath + "irrlicht2_up.jpg")
    *textures(1) = IrrGetTexture(#GFXpath + "irrlicht2_dn.jpg")
    *textures(2) = IrrGetTexture(#GFXpath + "irrlicht2_lf.jpg")
    *textures(3) = IrrGetTexture(#GFXpath + "irrlicht2_rt.jpg")
    *textures(4) = IrrGetTexture(#GFXpath + "irrlicht2_ft.jpg")
    *textures(5) = IrrGetTexture(#GFXpath + "irrlicht2_bk.jpg")
    
    *SkyBox              = IrrAddSkyBoxToScene( *textures(0),*textures(1),*textures(2),*textures(3),*textures(4),*textures(5))
    standardmeshpfad.s   = ProgramParameter()
    standardtexturpfad.s = GetFilePart(StringField(standardmeshpfad,1,".")) + "_texture.jpg"
    ; SetClipboardText(GetFilePart(StringField(standardmeshpfad,1,".")) + "_texture.jpg")
    grobzoomfaktor.f     = 1.01
    zoomfaktor.f         = 2.01
    
    ;}
    
    
    ;{ load md2 model)
    
    pfad.s                   = standardmeshpfad 
                    If pfad                  <> ""
                       *mesh                 = IrrGetMesh           ( pfad   )
                       If Not *mesh          = 0
                          If *node 
                              IrrSetNodeVisibility( *node , 0)
                              IrrSetNodeAnimationSpeed(*node , 0)
                              IrrRemoveNode      ( *node) 
                              *node              = 0
                          EndIf 
                          
                          *node                 = IrrAddMeshToScene    ( *mesh  )
                          
                          If *node 
                             IrrSetNodeMaterialFlag    ( *node, #IRR_EMF_LIGHTING, #IRR_OFF )
                             waitzoom           = 1
                             endframe           = getendframe          ( *node  )
                             anzahl_Frames      = endframe 
                             standardmeshpfad   = pfad 
                             SetGadgetText      ( #String_endframe, Str(endframe))
                             SetGadgetAttribute ( #TrackBar_0 , #PB_TrackBar_Maximum , endframe + 1020)
                             SetGadgetAttribute ( #TrackBar_0 , #PB_TrackBar_Minimum , 1)
                          Else 
                             MessageRequester( "md2 loader error" ," konnte mesh nicht laden" )
                          EndIf 
                       EndIf 
                    EndIf
    
    pfad.s = standardtexturpfad
                          If pfad <> "" And Not *node = 0
                             *MeshTexture = IrrGetTexture( pfad )
                             If Not *MeshTexture = 0
                                standardtexturpfad = pfad 
                                IrrSetNodeMaterialTexture   ( *node , *MeshTexture , 0 )
                             EndIf 
                          EndIf
                          
    ;}
    
            
    
    
    
    ; -----------------------------------------------------------------------------
    ; here is the Window-Mainloop
      Repeat
        Delay(10)
        If Not GetActiveWindow() = #Window_0 
           event = WaitWindowEvent()
        EndIf 
        
        event = WindowEvent()
          Select event
            Case #PB_Event_Gadget
              Select EventGadget()   
                 
                 Case #Button_0 ; load md2 model
                    
                    pfad.s                   = OpenFileRequester    ( "laden von md2 ,.x, b3d, ms3d model.. ich nix deutsch XD" , standardmeshpfad , "3d models (md2,3ds,x,b3d,mesh,ms3d,obj..)|*.md2;*.3ds;*.x;*.b3d;*.ms3d;*.obj;*.mesh|*.*|*.*" , 0 )
                    If pfad                  <> ""
                       *mesh                 = IrrGetMesh           ( pfad   )
                       If Not *mesh          = 0
                          If *node 
                              IrrSetNodeVisibility( *node , 0)
                              IrrSetNodeAnimationSpeed(*node , 0)
                              IrrDropPointer( *node )
                          EndIf 
                          
                          *node                 = IrrAddMeshToScene    ( *mesh  )
                          
                          If *node 
                             IrrSetNodeMaterialFlag    ( *node, #IRR_EMF_LIGHTING, #IRR_OFF )
                             waitzoom           = 1
                             endframe           = getendframe          ( *node  )
                             anzahl_Frames      = endframe 
                             standardmeshpfad   = pfad 
                             SetGadgetText      ( #String_endframe, Str(endframe))
                             SetGadgetAttribute ( #TrackBar_0 , #PB_TrackBar_Maximum , endframe + 20)
                             SetGadgetAttribute ( #TrackBar_0 , #PB_TrackBar_Minimum , 0)
                          Else 
                             MessageRequester( "md2 loader error" ," konnte mesh nicht laden" )
                          EndIf 
                       EndIf 
                    EndIf 
                    
                    If *node 
                    
                       msg = MessageRequester( "frage" ," wollen sie eine textur laden??" , #MB_ICONQUESTION| #MB_YESNO)
                       If msg = 6   ; ja
                          pfad.s = OpenFileRequester( "laden von texture .. ich nix deutsch XD" , standardtexturpfad , "bilder |*.jpg;*.bmp;*.png;*.tiff;*.tga|*.*|*.*" , 0 )
                          If pfad <> "" And Not *node = 0
                             *MeshTexture = IrrGetTexture( pfad )
                             If Not *MeshTexture = 0
                                standardtexturpfad = pfad 
                                IrrSetNodeMaterialTexture   ( *node , *MeshTexture , 0 )
                             EndIf 
                          EndIf 
                       EndIf 
                    aktuell_frame = 0
                    
                    EndIf 
                    
                 Case #Button_1 ; zurückspulen
                     aktuell_frame  - 1
                     SetGadgetText ( #String_animspeed , Str(speed))
                 Case #Button_2 ; Play animation
                     playanimation  = 1
                     If *node 
                        IrrSetNodeAnimationRange ( *node , 0 , anzahl_Frames  )
                     EndIf 
                 Case #Button_3 ; vorspulen  
                     aktuell_frame  + 1
                     SetGadgetText ( #String_animspeed , Str(speed))
                 Case #Button_4 ; stopanimation ; pause
                     playanimation = 0
                 Case #Button_9 ; ADD frame to textgadget
                    AddGadgetItem( #Editor_0 , 0 , " Frame: " + Str(aktuell_frame))
                 Case #String_startframe ; set startframe
                    startframe = Val(GetGadgetText( #String_startframe))
                    If playanimation = 2 And *node > 0
                       IrrSetNodeAnimationRange ( *node , startframe , endframe )
                    EndIf 
                 Case #String_endframe   ; set endframe
                    endframe   = Val(GetGadgetText( #String_endframe))
                    If playanimation = 2 And *node 
                       IrrSetNodeAnimationRange ( *node , startframe , endframe )
                    EndIf 
                 Case #Button_12 ; set play animation
                     playanimation = 2
                 Case #Button_14 ; load texture
                       pfad.s       = OpenFileRequester( "laden von texture .. ich nix deutsch XD" , standardtexturpfad , "bilder |*.jpg;*.bmp;*.png;*.tiff;*.tga|*.*|*.*" , 0 )
                       If Not pfad = "" And *node > 0
                          *MeshTexture        = IrrGetTexture( pfad )
                          If Not *MeshTexture = 0
                             standardtexturpfad  = pfad 
                             IrrSetNodeMaterialTexture   ( *node , *MeshTexture , 0 )
                          EndIf 
                       EndIf 

                 Case #Button_17 ; setanimationframes - anzahl.
                    anzahl_Frames = Val( InputRequester( "anzahl frames setzen" , "bitte nur zahlen eingeben. z.b. 800" , Str(anzahl_Frames)))
                 Case #String_currentframe
                    neueraktuellframe = 1
                 Case #String_animspeed
                    neuanimspeed  = 1
                 Case #TrackBar_0
                    aktuell_frame = GetGadgetState(#TrackBar_0)
                 Case #TrackBar_1  ; grobzoom
                    If *node          > 0
                       zoomfaktor     = GetGadgetState( #TrackBar_2) - GetGadgetState(#TrackBar_2) / 2
                       grobzoomfaktor = GetGadgetState( #TrackBar_1) / 10
                       IrrSetNodeScale ( *node , 0.01 * zoomfaktor + grobzoomfaktor * 0.3 , 0.01 * zoomfaktor+ grobzoomfaktor * 0.3 , 0.01 * zoomfaktor+ grobzoomfaktor * 0.3)
                    EndIf 
                 Case #TrackBar_2  ; feinzoom
                    If *node > 0
                       zoomfaktor     = GetGadgetState( #TrackBar_2) - GetGadgetState(#TrackBar_2) / 2
                       grobzoomfaktor = GetGadgetState( #TrackBar_1) / 10
                       IrrSetNodeScale ( *node , 0.01 * zoomfaktor + grobzoomfaktor * 0.3 , 0.01 * zoomfaktor+ grobzoomfaktor * 0.3 , 0.01 * zoomfaktor+ grobzoomfaktor * 0.3)
                    EndIf 
                    
              EndSelect 
          EndSelect
         
         If GetAsyncKeyState_( #VK_RETURN) And Not GetActiveGadget() = #Editor_0
            SetActiveGadget( #Button_0)
         EndIf 
         ; wenn ne eingabe gemacht WURDE, dass aktueller frame sich änderns soll.
         If neueraktuellframe = 1 
            If Not GetActiveGadget( ) = #String_currentframe
               neueraktuellframe = 0
               aktuell_frame     = Val( GetGadgetText( #String_currentframe))
            EndIf 
         ElseIf neueraktuellframe = 0 
            SetGadgetText ( #String_currentframe , Str(aktuell_frame)  )
            SetGadgetState( #TrackBar_0          , aktuell_frame    )
         EndIf 
         
         If neu_startframe = 0
            neu_startframe = 60
            startframe     = Val(GetGadgetText( #String_startframe))
            endframe       = Val(GetGadgetText( #String_endframe))
            If *node 
               If playanimation = 2
                  IrrSetNodeAnimationRange ( *node , startframe , endframe )
               Else  
                  IrrSetNodeAnimationRange ( *node , 0 , anzahl_Frames  )
               EndIf 
            EndIf 
         Else
            neu_startframe - 1
         EndIf 
         
         ; anemspeed setzen
         If neuanimspeed = 1 
            If Not GetActiveGadget( ) = #String_animspeed
               neuanimspeed = 0
               speed     = Val( GetGadgetText( #String_animspeed))
            EndIf 
         EndIf 
         
         ; zoom setzen
         If waitzoom                 = 0 
            If *node                 <> 0
               waitzoom              = 100
               zoomfaktor            = GetGadgetState( #TrackBar_2) - GetGadgetState(#TrackBar_2) / 2
               grobzoomfaktor        = GetGadgetState( #TrackBar_1) / 10
               IrrSetNodeScale       ( *node , 0.01 * zoomfaktor + grobzoomfaktor * 0.3 , 0.01 * zoomfaktor+ grobzoomfaktor * 0.3 , 0.01 * zoomfaktor+ grobzoomfaktor * 0.3)
               Debug zoomfaktor 
               Debug grobzoomfaktor 
            EndIf 
         ElseIf waitzoom > 0
            waitzoom - 1
         EndIf 
         
        ;This is the main-Irrlicht Loop  
        If IrrRunning()
          
          If GetAsyncKeyState_(#VK_1 )
             Debug aktuell_frame
          EndIf 
          If *node > 0
          IrrSetNodeAnimationFrame( *node , aktuell_frame)
          If playanimation    = 1
             aktuell_frame    + speed
             If aktuell_frame > anzahl_Frames 
                aktuell_frame = 0 
             EndIf 
             If aktuell_frame < 0 
                aktuell_frame = 0
             EndIf 
          ElseIf playanimation = 2
             If aktuell_frame < startframe 
                aktuell_frame = startframe 
             EndIf 
             If aktuell_frame > endframe 
                aktuell_frame = startframe 
             EndIf 
             aktuell_frame + speed
             IrrSetNodeAnimationFrame( *node , aktuell_frame)
          EndIf 
          EndIf 
          
          IrrBeginScene( 240, 255, 255 )
          ; draw the scene
          IrrDrawScene()      
          ; draw the GUI
          IrrDrawGUI()
        ; end drawing the scene and render it
          IrrEndScene()
        EndIf
        examine()
        
      Until event = #PB_Event_CloseWindow 
       
    
    ; -----------------------------------------------------------------------------
    ; Stop the irrlicht engine and release resources
    If IrrRunning()
       IrrStop()
    EndIf 
    CloseWindow(#Window_0)
    End 
  EndIf
  
  ; -----------------------------------------------------------------------------
  ; Close the Window after stopped the Engine
  
 
; jaPBe Version=3.8.8.716
; FoldLines=009B00A3
; Build=13
; Language=0x0000 Language Neutral
; FirstLine=276
; CursorPosition=313
; EnableXP
; EnableOnError
; ExecutableFormat=Windows
; Executable=J:\Programmierung\Versuche\Magical Twilight Smallgame\Modeller\3D Files\MD2 Editor.exe
; DontSaveDeclare
; EOF