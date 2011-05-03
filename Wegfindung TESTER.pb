
;{ Declarations
Declare displaystuff()
Declare test_spieler_move( )
Declare test_getWaypointXYbyID ( waypoint.i , *output.POINT  )
Declare test_set_ziel( )
Declare examine  ()
Declare initstuff()
Declare test_Setwertebystring( pfad.s )
Declare test_Setwerte ( waypointid.i, Fwert.f, Gwert.f , Hwert.f) ; setzt die  Debug-werte für alle waypoints eines pfades.
Declare create_waypoints()
Declare createmap ()
Declare displaymap ()
Declare test_launch_window ()
;}

IncludeFile "includes\include_all.pb"

; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ constants ------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------

   Enumeration 0; sprites 
      #sprite_mouse 
      #sprite_spieler
      #sprite_Waypoint
      #sprite_boden
      #sprite_wall
   EndEnumeration 
   #rasterbreite = 64
   
   Enumeration 
      #nutz_art_waypoint
   EndEnumeration 
   
   Enumeration  ; die gamemodes.. 
      #test_gamemode_Createwaypoints ; man kann wayponits erstellen + connecten
      #test_gamemode_setZiel         ; man kann's bewegziel des spielers festlegen.
      #test_gamemode_move_init       ; Wegfindung laufen lassen..
      #test_gamemode_move            ; man kann 'n spieler bewegen
   EndEnumeration
   
   Enumeration  ; Fenster
      #Window_0
   EndEnumeration
   
   ;- Gadget Constants
   ;
   Enumeration ; Gadgets
      #Text_0
      #Button_0
      #Button_1
      #Button_2
      #Hyperlink_0
   EndEnumeration
   
   #menu_return  = 0; Menugadgets..
   
; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ structures ------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------
   
   Structure boden
      sprite.i  [3] ; 3 layer.. 1,2,3
      begehbar.w
      NutzID.i
      NutzArt.i ; z.b. #nutz_art_waypoint
   EndStructure 
   
   Structure spieler 
      x.f 
      y.f
      Name.s 
      pfad.s
   EndStructure 
   
   Structure linie 
      rasterx.i
      rastery.i
      rasterzielx.i
      rasterziely.i
   EndStructure
   
   Structure werte 
      x.f
      y.f
      waypointid.i
      Fwert.f
      Gwert.f
      Hwert.f
   EndStructure 
   
; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ Globals ------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------
   
   Global Dim raster.boden (100,20,100)
   Global spieler.spieler 
   Global mouse_1.i
   Global mouse_2.i
   Global mouse_3.i
   Global *test_current_raster.boden ; im moment markierter WaypointID. wichtig für connextion.
   Global *test_current_rasterx.i
   Global *test_current_rastery.i
   Global test_spieler_x.i           ; position des spielers.
   Global test_spieler_y.i
   Global test_spieler_waypointy.i   ; die Bodenplatte des waypoints, zu dem der Spieler gerade connected ist
   Global test_spieler_waypointx.i   ; die Bodenplatte des waypoints, zu dem der Spieler gerade connected ist
   Global test_spieler_zielx.i
   Global test_spieler_ziely.i
   Global test_spieler_pfad.s
   Global Gamemode.w
   Global test_debugmodus.i
   Global NewList linie .linie()
   Global NewList werte.werte ()
   
   LoadFont ( 0 , "arial" , 10)
   
; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ Procedures ------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------
    
   Procedure test_launch_window ()
      Protected evt.i
      
      If OpenWindow(#Window_0, 367, 227, 600, 300, #programmname,  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
         If CreateGadgetList(WindowID(#Window_0))
            TextGadget          ( #Text_0, 10, 10, 570, 100, "Mitteltaste macht neue Waypoints"+Chr(10)+"Linksklick auf Waypoint: markiert ihn; Rechtsklick auf 2. Waypoint: Verbindet Waypoint1 mit Waypoint2"+Chr(10)+"ENTER Wechselt Modus (Modus2 = Start/Ziel setzen.. Start=Rechtsklick; Ziel=Linksklick"+Chr(10)+"Nochmal ENTER, dann läuft die Figur den Pfad einmal durch ;)."+Chr(10)+Chr(10)+"Viel Erfolg; ihr Aigner, Max ( www.Draufwalker.de.ms )", #PB_Text_Border)
            ButtonGadget        ( #Button_0, 220, 120, 140, 40, "Text vorlesen")
            ButtonGadget        ( #Button_1, 440, 250, 140, 40, "Programm starten")
            ButtonGadget        ( #Button_2, 20, 250, 140, 40, "Programm Beenden")
            HyperLinkGadget     ( #Hyperlink_0, 220, 180, 200, 20, "  http://www.gemusoft.de.ms", RGB(0, 0, 0))
            AddKeyboardShortcut ( #Window_0 , #PB_Shortcut_Return , #menu_return )
            
            Repeat 
            
               evt = WaitWindowEvent( 100)
               
               Select evt 
                  
                  Case #PB_Event_Gadget
                  
                     Select EventGadget()
                       
                        Case #Button_0 ; text vorlesen
                           
                           PlayWaveDirect( "GFX Wegfindung\anleitung.wav")
                           
                        Case #Button_1 ; programm starten
                           
                           ende = 1
                           
                        Case #Button_2 ; beenden
                           
                           End 
                           
                        Case #Hyperlink_0 ; gemusoft homepage.
                           
                           RunProgram ( "http://www.gemusoft.de.ms")
                           
                     EndSelect 
                     
                  Case #PB_Event_Menu
                     
                     If EventMenu() = #menu_return  
                        ende        = 1   ; program mstarten
                     EndIf 
                     
                  Case #PB_Event_CloseWindow 
                     
                     End  ; programm beenden.
                     
               EndSelect 
               
               
            Until ende = 1
            
         EndIf
      EndIf
   EndProcedure

   Procedure displaymap ()
      Protected sprite.i
      
      If Start3D()
      
         For x = 0 To 20
            For z = 0 To 20
               
               ; layer 1 anzeigen, wenn da
               sprite    = raster ( x , 0 , z )\sprite[1]
               If sprite > 0
                  DisplaySprite3D ( sprite , x * 64 , z * 64 )
               EndIf 
               
               ; layer 2 anzeigen, wenn vorhanden 
               sprite    = raster ( x , 0 , z )\sprite[2]
               If sprite > 0
                  DisplaySprite3D ( sprite , x * 64 , z * 64  )
               EndIf 
               
            Next 
         Next 
         
         Stop3D()
         
      EndIf 
      
   EndProcedure 
   
   Procedure createmap ()
      
      For x = 0 To 20
         For z = 0 To 20
            
            If Random ( 10 ) = 0
               raster ( x , 0 , z )\sprite [1]  = #sprite_boden  ; draufsicht..
               raster ( x , 0 , z )\sprite [2]  = #sprite_wall   ; draufsicht..
               raster ( x , 0 , z )\begehbar    = 0
            Else 
               raster ( x , 0 , z )\sprite [1]  = #sprite_boden  ; draufsicht..
               raster ( x , 0 , z )\begehbar    = 1
            EndIf 
            
         Next 
      Next 
      
   EndProcedure 
   
   Procedure create_waypoints()
   
      Protected mouse_rasterx.i , mouse_rastery.i 
      
      ; create them
      
      If mouse_3        = 1
         mouse_rasterx      = Round( MouseX() / #rasterbreite , 0 )
         mouse_rastery      = Round( MouseY() / #rasterbreite , 0 )
         
         If Not raster      ( mouse_rasterx , 0 , mouse_rastery )\sprite[2] = #sprite_Waypoint
            
            raster          ( mouse_rasterx , 0 , mouse_rastery )\sprite[2] = #sprite_Waypoint
            raster          ( mouse_rasterx , 0 , mouse_rastery )\begehbar  = 1
            raster          ( mouse_rasterx , 0 , mouse_rastery )\NutzArt   = #nutz_art_waypoint
            raster          ( mouse_rasterx , 0 , mouse_rastery )\NutzID    = Way_AddWaypoint ( mouse_rasterx , mouse_rastery , 0 ) ; wayopintID übergeben.
            AddElement      ( werte())
               werte        ()\x = mouse_rasterx * #rasterbreite +#rasterbreite/2
               werte        ()\y = mouse_rastery * #rasterbreite +#rasterbreite/2
               werte        ()\waypointid        = raster          ( mouse_rasterx , 0 , mouse_rastery )\NutzID 
               
         EndIf 
         
      EndIf 
      
      ; select them
      
      If mouse_1            = 1
         mouse_rasterx      = Round( MouseX() / #rasterbreite , 0 )
         mouse_rastery      = Round( MouseY() / #rasterbreite , 0 )
         
         If raster                 ( mouse_rasterx , 0 , mouse_rastery )\sprite[2] = #sprite_Waypoint ; wenn ein waypoint selected
            *test_current_raster   = raster ( mouse_rasterx , 0 , mouse_rastery )
            *test_current_rasterx  = mouse_rasterx 
            *test_current_rastery  = mouse_rastery 
         EndIf 
         
      EndIf 
      
      ; connect them
      
      If mouse_2            = 1 And *test_current_raster > 0
         If *test_current_raster\NutzArt = #nutz_art_waypoint
            mouse_rasterx      = Round( MouseX() / #rasterbreite , 0 )
            mouse_rastery      = Round( MouseY() / #rasterbreite , 0 )
         
            If raster                 ( mouse_rasterx , 0 , mouse_rastery )\sprite[2] = #sprite_Waypoint ; wenn ein waypoint selected
               way_connectwaypoints   ( *test_current_raster\NutzID , raster ( mouse_rasterx , 0 , mouse_rastery )\NutzID )
               AddElement             ( linie ())
                  linie               ()\rasterx     = mouse_rasterx
                  linie               ()\rastery     = mouse_rastery 
                  linie               ()\rasterzielx = *test_current_rasterx
                  linie               ()\rasterziely = *test_current_rastery
                  
            EndIf 
         EndIf 
      EndIf 
      
   EndProcedure 
   
   Procedure test_Setwerte ( waypointid.i, Fwert.f, Gwert.f , Hwert.f) ; setzt die  Debug-werte für alle waypoints eines pfades.
        Protected *waypointid.WAYPOINT 
        
        *waypointid = waypointid 
       ResetList  ( werte())
            
            While NextElement ( werte())
               
               If werte()\waypointid = *waypointid 
                  werte()\Fwert      = *waypointid\Fwert 
                  werte()\Gwert      = *waypointid\Gwert 
                  werte()\Hwert      = *waypointid\Hwert 
                  Break 
               EndIf 
               
           Wend 
           
   EndProcedure 
   
   Procedure test_Setwertebystring( pfad.s )
   
      Protected *waypointid.WAYPOINT 
      
      For x = 1 To CountString ( pfad , "|")
         
         *waypointid = Val( StringField ( pfad , x , "|"))
         ; dem waypointid die  Werte zuweisen.
         ResetList  ( werte())
            
            While NextElement ( werte())
               
               If werte()\waypointid = *waypointid 
                  werte()\Fwert      = *waypointid\Fwert 
                  werte()\gwert      = *waypointid\gwert 
                  werte()\hwert      = *waypointid\hwert 
                  Break 
               EndIf 
               
           Wend  
           
      Next 
   
   EndProcedure 
   
   Procedure initstuff()
      ; setup program
      
         InitSprite()
         InitSprite3D()
         InitKeyboard()
         InitMouse()
         OpenWindow ( 0 , 0 , 0 , 1024 , 768 , "3D Waypointsystem example" ,#PB_Window_ScreenCentered )
         OpenWindowedScreen( WindowID(0) , 0 , 0 , 1024 , 768, 0 , 0 , 0)
         Sprite3DQuality( 1 )
         
      ;load sprites 
         
         LoadSprite ( #sprite_mouse    , "GFX Wegfindung\pfeil.png"    , #PB_Sprite_AlphaBlending | #PB_Sprite_Texture )
         LoadSprite ( #sprite_boden    , "GFX Wegfindung\boden.png"    , #PB_Sprite_AlphaBlending | #PB_Sprite_Texture )
         LoadSprite ( #sprite_Waypoint , "GFX Wegfindung\waypoint.png" , #PB_Sprite_AlphaBlending | #PB_Sprite_Texture )
         LoadSprite ( #sprite_spieler  , "GFX Wegfindung\spieler.png"  , #PB_Sprite_AlphaBlending | #PB_Sprite_Texture )
         LoadSprite ( #sprite_wall     , "GFX Wegfindung\wall.png"     , #PB_Sprite_AlphaBlending | #PB_Sprite_Texture )
      
      ; create sprite 3ds
         
         For x = 0 To 4
            CreateSprite3D ( x , x )
         Next 
         
   EndProcedure 
   
   Procedure examine  ()
      
      WindowEvent     ()
      ExamineMouse    ()
      ExamineKeyboard ()
      FlipBuffers     ()
      ClearScreen     ( 233 )
      
      If KeyboardReleased  (#PB_Key_Escape ) 
         End 
      EndIf 
      
      ; mouse aktualisieren
      
      If MouseButton(1) = 1 
      
         If mouse_1 = 0
            mouse_1 = 1
         Else 
            mouse_1 = 2
         EndIf 
      Else 
         mouse_1 = 0
      EndIf 
      
      If MouseButton(2) = 1 
      
         If mouse_2 = 0
            mouse_2 = 1
         Else 
            mouse_2 = 2
         EndIf 
      Else 
         mouse_2 = 0
      EndIf 
      
      If MouseButton(3) = 1 
      
         If mouse_3 = 0
            mouse_3 = 1
         Else 
            mouse_3 = 2
         EndIf 
      Else 
         mouse_3 = 0
      EndIf 
      
      If KeyboardReleased( #PB_Key_Return)
         
         If Gamemode < #test_gamemode_move 
         
            Gamemode + 1 ; zum nächten nodus umschalten.. #test_gamemode_setZiel.
         
         Else 
         
            Gamemode = 0
            
         EndIf 
         
      EndIf 
      
      ; debugmodus anmachen..
      
      If KeyboardReleased( #PB_Key_F1 )
      
         If test_debugmodus = 0
            test_debugmodus = 1
         Else 
            test_debugmodus = 0
         EndIf 
         
      EndIf 
      
   EndProcedure 
   
   Procedure test_set_ziel( )
      
      ; ZielID setzen
      
      If mouse_1 = 1
         
         x                     = Round( MouseX() / #rasterbreite , 0 )
         y                     = Round( MouseY() / #rasterbreite , 0 )
         If raster(x , 0 , y ) \NutzArt = #nutz_art_waypoint 
            test_spieler_zielx = Round( MouseX() / #rasterbreite , 0 )
            test_spieler_ziely = Round( MouseY() / #rasterbreite , 0 )
         EndIf 
         
      EndIf 
      
      ; SpielerWaypoint setzen
      
      If mouse_2 = 1 
         
         test_spieler_waypointx = Round( MouseX() / #rasterbreite , 0 )
         test_spieler_waypointy = Round( MouseY() / #rasterbreite , 0 )
      
      EndIf 
      
   EndProcedure 
   
   Procedure test_getWaypointXYbyID ( waypoint.i , *output.POINT  )
      Protected x.i , z.i
      
      For x = 0 To 20
         For z = 0 To 20
            
            If raster ( x , 0 , z )\NutzArt = #nutz_art_waypoint
              If raster ( x , 0 , z )\NutzID = waypoint
                 *output\x = x
                 *output\y = z
                 ProcedureReturn 1
              EndIf 
            EndIf 
            
         Next 
      Next  
      
   EndProcedure 
   
   Procedure test_spieler_move( )
      Protected Point.POINT 
      Static warten.f 
         
         If warten < ElapsedMilliseconds() / 1000  ; pro halbe oder XX sekunde den Spieler bisschen weiter bewegen.
            warten = ElapsedMilliseconds() / 1000 + 0.5
            
            waypointid = way_NextPathElement ( test_spieler_pfad)
            
            If test_getWaypointXYbyID ( waypointid , Point )
               test_spieler_x         = Point\x
               test_spieler_y         = Point\y
               test_spieler_pfad      = RemoveString(test_spieler_pfad , StringField ( test_spieler_pfad , CountString ( test_spieler_pfad , "|")  , "|") + "|" )
            EndIf 

         EndIf 
      
   EndProcedure 
   
   Procedure displaystuff()
      
      ; verbidungen von Waypoints anzeigen.
      
      ResetList ( linie () )
      ResetList ( werte () )
      
         If StartDrawing( ScreenOutput())
         
            While NextElement ( linie()) 
               
               LineXY  ( linie()\rasterx * #rasterbreite + #rasterbreite/2 , linie()\rastery * #rasterbreite+ #rasterbreite/2, linie()\rasterzielx * #rasterbreite+ #rasterbreite/2 , linie()\rasterziely *#rasterbreite + #rasterbreite/2)
               
            Wend 
            
            ; anzeigen der Waypoint-werte.. (auswertung)
            
            If test_debugmodus = 1
               While NextElement( werte ())
                  
                  DrawingMode ( #PB_2DDrawing_Default ) 
                  DrawingFont ( FontID ( 0)) 
                  DrawText    ( werte  ()\x , werte()\y    , "h: "  + StrF(werte()\hwert,1))
                  DrawText    ( werte  ()\x , werte()\y +14, "G: "  + StrF(werte()\gwert,1))
                  DrawText    ( werte  ()\x , werte()\y +28, "f: "  + StrF(werte()\Fwert,1))
                  
               Wend 
            EndIf 
            
            ; Linie von Spieler zum aktuellen SpielerWaypoint anzeigen.
            LineXY       ( test_spieler_x * #rasterbreite + #rasterbreite/2 , test_spieler_y *#rasterbreite + #rasterbreite/2 , test_spieler_waypointx *#rasterbreite + #rasterbreite/2 , test_spieler_waypointy *#rasterbreite + #rasterbreite/2 , RGB( 0,244,244))
            StopDrawing  ( )
         EndIf 
      
      ; Mauscursor anzeigen.
      
      If Start3D ()
         DisplaySprite3D ( #sprite_spieler , test_spieler_x *#rasterbreite, test_spieler_y *#rasterbreite)
         DisplaySprite3D ( #sprite_mouse   , MouseX()       , MouseY()       )
         Stop3D()
      EndIf 
       
            
   EndProcedure 
   
   test_launch_window() ; launchrer.. mit vorlesen ;)
   initstuff()
   createmap ()
   create_waypoints()
   
   Repeat 
     
     examine            ()
     displaymap         ()
     displaystuff       ()
     
     If Gamemode        = #test_gamemode_Createwaypoints
        create_waypoints   ()  ; updated die Waypoints.. neue bauen, verbinden von waypoints etc.
     ElseIf Gamemode    = #test_gamemode_setZiel
        test_set_ziel   ()
     ElseIf Gamemode    = #test_gamemode_move_init ; bewegung initieren
        test_spieler_pfad  = way_getpathByWayPoint( raster( test_spieler_waypointx ,0 , test_spieler_waypointy  )\NutzID  ,raster( test_spieler_zielx , 0 , test_spieler_ziely )\NutzID )
        Gamemode        + 1
     ElseIf Gamemode    = #test_gamemode_move      ; richtig bewegn
        test_spieler_move()
     EndIf 
     
     
   ForEver  
; jaPBe Version=3.9.12.818
; FoldLines=007A00B300B500D000D200E3014D016601B301CB01CD01DE
; Include=SoundPlus.pbi
; Build=8
; Manual Parameter S=DX9
; Language=0x0000 Language Neutral
; FirstLine=292
; CursorPosition=460
; EnableUnicode
; EnableXP
; ExecutableFormat=Windows
; Executable=C:\Users\Krieger Drauf\Desktop\Gemusoft\waypoint example.exe
; DontSaveDeclare
; EOF