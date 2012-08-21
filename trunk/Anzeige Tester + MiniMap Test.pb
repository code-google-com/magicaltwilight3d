
Global *debug_terrain.i

IncludeFile "includes\include_all.pb"

; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ constants ------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------
#Main_Release = 0

; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ Structures------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------


; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ Globals   ------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------

test_x.f = 0 : test_y.f = 0: test_z.f = 0
; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ Teamb�ndnisse --------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------------
       
   *team_mensch  = team_AddTeam( #team_wesen_bundnis_mensch )      ; menschen des guten etc.
   *team_monster = team_AddTeam( #team_wesen_bundnis_monster)      ; monster aus der Parallelwelt 
   *team_jagttier= team_AddTeam( #team_wesen_bundnis_tiere_jagt )  ; jagende tiere.. w�lfe etc.
   *team_ruhtier = team_AddTeam( #team_wesen_bundnis_tiere_ruhig)  ; ruhige tiere, ziegen, mietzikatzen etc.
   
   Team_SetTeamVerhaltnis( *team_mensch   , *team_monster  , #team_verhaltnis_totfeinde )
   Team_SetTeamVerhaltnis( *team_mensch   , *team_jagttier , #team_verhaltnis_feinde )
   Team_SetTeamVerhaltnis( *team_mensch   , *team_ruhtier  , #team_verhaltnis_anerkennend )
   Team_SetTeamVerhaltnis( *team_monster  , *team_ruhtier  , #team_verhaltnis_feinde )
   Team_SetTeamVerhaltnis( *team_monster  , *team_jagttier , #team_verhaltnis_feinde )
   Team_SetTeamVerhaltnis( *team_jagttier , *team_ruhtier  , #team_verhaltnis_feinde )
   
; -----------------------------------------------------------------------------------------------------------------------
; ------------------------------------------------------ MAIN      ------------------------------------------------------
; ----------------------------------------------------------------------------------------------------------------------- 
   
   CompilerIf #Main_Release = 1
      MessageRequester( "Willkommen" , "WICHTIG: geh nicht in den raum rechts! man kommt nicht mehr raus." + Chr(10) + "Keyboard: " + Chr(10) + Chr(9) + "WASD-ARROWS: Move" +Chr(10)+ Chr(9) + "Space: Jump" + Chr(10) + Chr(9) + "E: pick up Item" +Chr(10) + Chr(9) + "1-5: Quickuse Item" +Chr(10) + Chr(9) + "M: Map" +Chr(10) + Chr(9) + "I-> Inventar" +Chr(10) + Chr(9) + "Q: Questlog" +Chr(10) + Chr(9) + "F1: 3rd-First Person cam"  +Chr(10) + Chr(9) + "F2: Activate BLOOM"+ Chr(10) + Chr(10) + "Viel Spa� =) Sourcecode liegt bei." , #MB_ICONINFORMATION )
   CompilerEndIf 
   
   anz_setresolution          ( 1240 , 768, 32 , 0 )

    
   anz_enable_normalmapping   ( 0 )
   anz_enable_parallaxmapping ( 0 )
   anz_enable_shadow          ( 1 )
   anz_enable_fog             ( 1 )
   anz_enable_lighting        ( 1 )
   anz_savepreferences        (   )
   anz_isPostProcessing       = 1
   anz_initstuff              ( 1 )
   MIN_INIT                   ( anz_getscreenwidth() -Min_width(),anz_getscreenheight() - Min_height() - 10)
   
   
   ; iInitPhysic  (   )  
   ; iSetPolysPerNode(128)
   ; iSetWorldSize(- #meter*50 , -#meter * 10 , -#meter*50 , #meter*500,#meter*10 , #meter*500)
   iTextureCreation ( #ETCF_CREATE_MIP_MAPS ,1)
   ; IrrSetTextureCreationFlag  ( #IRR_ETCF_CREATE_MIP_MAPS       , 1 )  ; bei mx_world: 1/33*#meter
   anz_map_load               ( "level_kim.irr" , "Gfx\maps\level_kim\" , 1/80*#meter) ;fr�her war der meter ca. 34.. dewegen ist die alte welt zu gro� --> also rescalieren!!!!! 
   spi_SetCameraFirstPerson   ( 1 ) 
   gui_setGUI                 ( #Gui_Status_HUD )
   *nodeid = spi_GetPlayerNode( spi_getcurrentplayer () )
   Position.ivector3 
   iNodePositionP             ( *nodeid  , @Position )
   anz_setobjectPos           ( spi_getObject3DID( spi_getcurrentplayer())  , Position\x , Position\y -#meter*2.1 , Position\z)
   
   ; IrrSetTextureCreationFlag  ( #IRR_ETCF_OPTIMIZED_FOr_speed , 1 )
   ; IrrSetTextureCreationFlag  ( #IRR_ETCF_CREATE_MIP_MAPS       , 1 )
   ; *text = IrrGuiAddStaticText        ( "text" , 10,10,100,23)
   
   ; *cam = iCameraActive()
   ; iLoadIrrScene( "max_welt.irr")
   ; iActiveCamera( *cam)
   ; pos.ivector3 
   ; E3D_getNodePosition( *cam , @pos\x , @pos\y , @pos\z )
   ; anz_addmesh( #pfad_spieler_mesh , pos\x , pos\y , pos\z , #pfad_spieler_texture , #EMT_PARALLAX_MAP_SOLID , #pfad_spieler_texture2 , 1 , 0 )
   
   For x = 1  To 10
      item                   = Item_Add( "Gruselig-gr�ner Geistbrecher" , test_x , test_y , test_z , 23, #item_art_nahkampf , 23, 23,"..\..\maps\standard stabwaffe.3ds" , "..\..\maps\stabwaffe standard.tga" , "" , #EMT_SOLID , Gui_Inventar_Image_EinfachesSchwert , "Gr�ner Geistbrecher" + Chr(10) + "ben�tigt:" + Chr(10) + " St�rke 10"  + Chr(10) + " Intelligenz: 5" + Chr(10) + " Spezialeffekt: setzt Gegner kurz ausser Gefecht.")
      Item_AddWaffe          ( item , 10 , #meter*2 , #item_waffe_nahkampf , Gui_Inventar_Image_EinfachesSchwert)
      spi_Inventar_AddItem   ( spi_getcurrentplayer() , item )
   Next 
   
   *item.ITEM =Item_Add( "Seifenblasenwaffe" , test_x +#meter / 2, test_y , test_z +#meter / 2, 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\Items\seifenblasenwaffe.b3d" , "" , "" , #EMT_SOLID , Gui_Inventar_Image_Brot ,"Kinderspielzeug, dass Seifenblasen verschie�t" +Chr(10) + "Kann Monster t�ten")
   Item_AddWaffe ( *item , 12 , #meter*2 , #item_waffe_fernkampf , Gui_Inventar_Image_Brot )
   spi_Inventar_AddItem   ( spi_getcurrentplayer() , *item )
   
   For x = 1 To 20
      item = Item_Add         ( "Schriftrolle" , test_x + #meter , test_y , test_z , 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\items\schriftrolle.3ds" , "..\..\maps\Max Welt\items\schriftrolle_texture.jpg" , "..\..\maps\Max Welt\items\schriftrolle_normal.jpg" , #EMT_NORMAL_MAP_SOLID , Gui_Inventar_Image_Schriftrolle ,"Brief an Genesis..")
       spi_Inventar_AddItem   ( spi_getcurrentplayer() , item )
   Next 
   item = Item_Add         ( "Ibot" , test_x + #meter , test_y , test_z , 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\items\schriftrolle.3ds" , "..\..\maps\Max Welt\items\schriftrolle_texture.jpg" , "..\..\maps\Max Welt\items\schriftrolle_normal.jpg" , #EMT_NORMAL_MAP_SOLID , Gui_Inventar_Image_Schriftrolle ,"Spezialitem -> " + Chr(10) + "Gibt f�r 10s +200 leben" + Chr(10) + "Nebeneffekt: kann zu Verdauungsproblemen f�hren hehe" )
   spi_Inventar_AddItem    ( spi_getcurrentplayer() , item )
   *item.ITEM =Item_Add    ( "Pacman Geist" , test_x +#meter / 2, test_y , test_z +#meter / 2, 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\Items\Pacman_ghost.b3d" , "" , "" , #EMT_SOLID , Gui_Inventar_Image_Brot ,"Pacmantier")
   spi_Inventar_AddItem    ( spi_getcurrentplayer() , *item )
   *FPSgadget              = iAddStaticText     ("fps" ,5,5,150,20,1,1,1)
   
; ----------------------------------------------------------------------------------------------   
; -- Hauptschleife
; ----------------------------------------------------------------------------------------------
   
   iTimerUpdatePhysic (30) 
   
   Repeat 
      ;{ wegen spi_SetCameraDistance schauen..
      If GetAsyncKeyState_(#VK_ADD )
        spi_SetCameraDistance ( spi_GetCameraDistance( ) + 0.01 )
        Debug spi_GetCameraDistance( )/#meter
      EndIf 
      If GetAsyncKeyState_(#VK_SUBTRACT )
        spi_SetCameraDistance ( spi_GetCameraDistance( ) - 0.01 )
        Debug spi_GetCameraDistance( )/#meter
      EndIf 
      
      If item_check_waiter    < ElapsedMilliseconds() 
         Item_FocusItem_Reset ( )
         item_check_waiter    = ElapsedMilliseconds() + 100
      EndIf 
      anz_updateinput         ( )
      anz_updateparticles     ( )
      anz_updatesound         ( )
      anz_updateDeleteAnimator( )
      anz_setShownObjects     ( spi_GetPlayerNode( spi_getcurrentplayer()) )
      MIN_RenderMiniMap       ( )
      anz_updateview          ( )
      itextgui                ( *FPSgadget , Str(ifps()))
      gui_updateGUI           ( )
      
      
      
   If GetAsyncKeyState_       ( #VK_F5)
      If key_f5 = 0
         key_f5 = 1
         If anz_IsParallaxmappingEnabled()
            anz_enable_parallaxmapping(0 )
         Else 
            anz_enable_parallaxmapping(1)
         EndIf 
      EndIf 
   Else 
      key_f5 = 0
   EndIf 
      ; shoot with cube
   If GetAsyncKeyState_(#VK_F8)
     *cam = anz_camera 
     campos.ivector3
     camDir.ivector3 
     iNodePosition(*cam, @campos\x)
     iNodeDirection(*cam, @camDir\x)
     wes_getposition        ( spi_GetSpielerWesenID( spi_getcurrentplayer()) , @test_x , @test_y , @test_z)
     *item.ITEM =Item_Add( "Seifenblasenwaffe" , test_x +#meter / 2, test_y , test_z +#meter / 2, 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\Items\seifenblasenwaffe.b3d" , "" , "" , #EMT_SOLID , Gui_Inventar_Image_Brot ,"Seifenblasenwaffe")
     
     ;*item.ITEM = Item_Add( "Brot" , test_x +#meter / 2, test_y , test_z +#meter / 2, 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\Items\Brot.3ds" , "..\..\maps\Max Welt\items\Brot_texture.jpg" , "..\..\maps\Max Welt\items\brot_normal.jpg" , #EMT_PARALLAX_MAP_SOLID , Gui_Inventar_Image_Brot ,"Brot mit bisschen Salz")
     
     Debug "pos: " + Str( campos\x ) + " y " + Str( campos\y ) + " z " + Str( campos\z )
     ; create mesh to shoot
     *cube.IMesh = iCreateCube(#meter /2)
     *texture = iLoadTextureNode(*cube, "..\..\maps\Max Welt\items\Brot_texture.jpg") 
     iPositionNode(*cube, campos\x,campos\y,campos\z)
     irotatenode(*cube, Random(180),Random(180),Random(180))    
     ; create body
     anz_AddDeleteAnimator( *cube , 3000)
     
   EndIf
      
      If GetAsyncKeyState_(#VK_F3)
         anz_updateview()
      EndIf 
      
      If GetAsyncKeyState_(#VK_F1)
         If key_f1 = 0
            key_f1 = 1 
            If spi_IsCameraFirstPerson()
               spi_SetCameraFirstPerson (0)
            Else 
               spi_SetCameraFirstPerson (1)
            EndIf  
         EndIf 
      Else 
         key_f1 = 0
      EndIf 
      
      If GetAsyncKeyState_(#VK_F2)
         If key_f2 = 0
            key_f2 = 1 
            If anz_isPostProcessing       = 1 
               anz_isPostProcessing       = 0
            Else 
               anz_isPostProcessing       = 1 
            EndIf 
         EndIf 
      Else 
         key_f2 = 0
      EndIf 
      
      If GetAsyncKeyState_    ( #VK_RETURN )
         If key_return        = 0
            key_return        = 1
            irrnode           = spi_GetPlayerNode( spi_getcurrentplayer())
            test_x.f = 0 : test_y.f = 0: test_z.f = 0
            If irrnode
               wes_getposition        ( spi_GetSpielerWesenID( spi_getcurrentplayer()) , @test_x , @test_y , @test_z)
               *WesenID.wes_wesen     = wes_AddWesen ( "tom" , test_x +#meter , test_y  , test_z , Str( Random(1000)), 1,#meter / 30,"..\..\sydney.md2" ,"..\..\sydney.jpg" , "", #EMT_SOLID , 1, 0 , #wes_art_schwert , #wes_action_stand , #ani_animNR_stand , #spi_standard_animationlist )
               
               ; Waffenitem hinzuf�gen. 
               item                   = Item_Add( "Gruselig-gr�ner Geistbrecher" , test_x , test_y , test_z , 23, #item_art_nahkampf , 23, 23,"..\..\maps\standard stabwaffe.3ds" , "..\..\maps\stabwaffe standard.tga" , "" , #EMT_SOLID , Gui_Inventar_Image_EinfachesSchwert, "Das weist leichte Scharten auf" )
               Item_AddWaffe          ( item , 10 , #meter*2 , #item_waffe_nahkampf , Gui_Inventar_Image_EinfachesSchwert)
               wes_setWesenWaffe      ( *WesenID , item )
               
               
               ; If Random (1)
                  ; Item_Add( "Brot" , test_x +#meter / 2, test_y , test_z +#meter / 2, 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\Items\Brot.3ds" , "..\..\maps\Max Welt\items\Brot_texture.jpg" , "..\..\maps\Max Welt\items\brot_normal.jpg" , #EMT_NORMAL_MAP_SOLID , Gui_Inventar_Image_Brot , "Leicht angebratenes Brot")
               ; Else 
                  ; Item_Add( "Schriftrolle" , test_x + #meter , test_y , test_z , 23, #item_art_kram , 23, 23,"..\..\maps\Max Welt\items\schriftrolle.3ds" , "..\..\maps\Max Welt\items\schriftrolle_texture.jpg" , "..\..\maps\Max Welt\items\schriftrolle_normal.jpg" , #EMT_NORMAL_MAP_SOLID , Gui_Inventar_Image_Schriftrolle , "Gelbliches Dokument")
               ; EndIf 
               ; iTextGUI ( *text , Str( ListSize ( wes_wesen())))
               wes_SetmaxMana         ( *WesenID , 20 )  ; mana setzen + maxmana.
               wes_SetMana            ( *WesenID , 10 )
               *wesen2.wes_wesen      = spi_GetSpielerWesenID( spi_getcurrentplayer())
               bundnis                = Random(#team_verhaltnis_feinde)
               Team_SetTeamVerhaltnis ( *WesenID\Team , *wesen2\Team ,  bundnis )
               
               ; Select bundnis
                  ; Case #team_verhaltnis_feinde , #team_verhaltnis_rivalen , #team_verhaltnis_totfeinde
                     ; *anz_billboard.anz_billboard = anz_AddBillboard       ( "..\..\test\orange.png" , 0 , 0 , 0 ,10,10 , #EMT_TRANSPARENT_ALPHA_CHANNEL , 1)
                  ; Case #team_verhaltnis_neutral 
                     ; *anz_billboard.anz_billboard = anz_AddBillboard       ( "..\..\test\blau.png" , 0 , 0 , 0,10,10 , #EMT_TRANSPARENT_ALPHA_CHANNEL,1 )
                  ; Case #team_verhaltnis_anerkennend To #team_verhaltnis_liebend  
                     ; *anz_billboard.anz_billboard = anz_AddBillboard       ( "..\..\test\gr�n.png" , 0 , 0 , 0,10,10 , #EMT_TRANSPARENT_ALPHA_CHANNEL,1 )
               ; EndSelect 
               ; anz_attachobject( anz_getobject3dByAnzID (wes_getAnzMeshID(*WesenID) ) ,anz_getobject3dByAnzID( *anz_billboard , #anz_art_billboard ) , iNodeX(*anz_billboard\id )  , iNodeY(*anz_billboard\id )+#meter*1.5 , iNodeZ(*anz_billboard\id ))
            EndIf 
         EndIf 
      Else 
        key_return = 0
      EndIf 
      
   ForEver 
; jaPBe Version=3.9.12.819
; Build=11
; FirstLine=42
; CursorPosition=52
; ExecutableFormat=Windows
; Executable=C:\Users\Max\Documents\!Programmierung\Magical Twilight\abenthum 1.0.exe
; DontSaveDeclare
; EOF