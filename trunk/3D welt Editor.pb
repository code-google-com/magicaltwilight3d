
; --------------------------------------------------------------------------------------------------------------------
; --- Includes 
; --------------------------------------------------------------------------------------------------------------------

; --------------------------------------------------------------------------------------------------------------------
; --- Constants 
; --------------------------------------------------------------------------------------------------------------------
   

; --------------------------------------------------------------------------------------------------------------------
; --- Structures 
; --------------------------------------------------------------------------------------------------------------------

   Structure Button
      id.i       ; irrlicht ID
      NR.i       ; Zugewiesene NR, um einen Befehl auszuführen.
   EndStructure 

; --------------------------------------------------------------------------------------------------------------------
; --- Globals
; --------------------------------------------------------------------------------------------------------------------


; --------------------------------------------------------------------------------------------------------------------
; --- Procedures 
; --------------------------------------------------------------------------------------------------------------------

; --------------------------------------------------------------------------------------------------------------------
; --- Schleife 
; --------------------------------------------------------------------------------------------------------------------







; --------------------------------------------------------------------------------------------------------------------
; --- test nur zum gui anzeigen
; --------------------------------------------------------------------------------------------------------------------


XIncludeFile #PB_Compiler_Home + "includes\irrlichtWrapper_include.pbi"


ScreenWidth.l = 1240
ScreenHeight.l = 1024

If IrrStartEx(#IRR_EDT_DIRECT3D9 , ScreenWidth , ScreenHeight , 0, 1,0,32,1,0,1,0)
  ; Set the title of the display
  IrrSetWindowCaption( "Example 26: Using the Irrlicht-GUI" )
  
  ; add a static text object to the graphical user interface, at the moment
  ; this is the only interface object we support. The text will be drawn inside
  ; the defined rectangle, the box will not have a border and the text will not
  ; be wrapped around if it runs off the end

 
  
  
  *Window_0 = 0; IrrGuiAddWindow( -9 , -13 , 1015 , 775 , "Newwindow(0" , 0 , 0 , 1 ) 
  *Button_0 = IrrGuiAddButton( "Outliner" , 5 , 30 , 75 , 60 , *Window_0 , 2 ) 
  *Button_1 = IrrGuiAddButton( "Newthings" , 80 , 30 , 150 , 60 , *Window_0 , 3 ) 
  *Button_2 = IrrGuiAddButton( "Eigenschaften" , 230 , 30 , 300 , 60 , *Window_0 , 4 ) 
  *Button_4 = IrrGuiAddButton( "kombis" , 155 , 30 , 225 , 60 , *Window_0 , 5 ) 
  *Button_5 = IrrGuiAddButton( "Outliner" , 305 , 30 , 375 , 60 , *Window_0 , 6 ) 
  *Button_7 = IrrGuiAddButton( "Textures" , 455 , 30 , 525 , 60 , *Window_0 , 7 ) 
  *Button_9 = IrrGuiAddButton( "Layer" , 380 , 30 , 450 , 60 , *Window_0 , 8 ) 
  *Button_55 = IrrGuiAddButton( "Open/Save" , 530 , 30 , 600 , 60 , *Window_0 , 9 ) 
  *Button_Quit = IrrGuiAddButton( "Quit" , 645 , 30 , 715 , 55 , *Window_0 , 10 ) 
  *Window_Eigenschaften = IrrGuiAddWindow( -1 , 202 , 188 , 501 , "Éigenschaften" , 0 , 0 , 11 ) 
  *Image_Texture1 = IrrGuiAddButton( "" , 5 , 25 , 60 , 80 , *Window_Eigenschaften , 12 ) 
  *Image_Texture2 = IrrGuiAddButton( "" , 65 , 25 , 120 , 80 , *Window_Eigenschaften , 13 ) 
  *Combo_materialtype = IrrGuiAddComboBox( 0 , 80 , 190 , 100 , *Window_Eigenschaften , 14 ) 
  *Combo_col_art = IrrGuiAddComboBox( 0 , 100 , 190 , 120 , *Window_Eigenschaften , 15 ) 
  *Combo_col_type = IrrGuiAddComboBox( 0 , 120 , 190 , 140 , *Window_Eigenschaften , 16 ) 
  *Text_eigenschaften_pos = IrrGuiAddStaticText( "XYZ:" , 5 , 145 , 40 , 165 , 1 , 1 , 1 , *Window_Eigenschaften , 17 ) 
  *String_eigenschaften_pos = IrrGuiAddEditBox( "" , 40 , 145 , 185 , 165 , 1 , *Window_Eigenschaften , 18 ) 
  *Text_eigenschaften_rot = IrrGuiAddStaticText( "Scale:" , 5 , 185 , 40 , 205 , 1 , 1 , 1 , *Window_Eigenschaften , 19 ) 
  *String_eigenschaften_rot = IrrGuiAddEditBox( "" , 40 , 165 , 185 , 185 , 1 , *Window_Eigenschaften , 20 ) 
  *Text_3 = IrrGuiAddStaticText( "Rot:" , 5 , 165 , 40 , 185 , 1 , 1 , 1 , *Window_Eigenschaften , 21 ) 
  *String_eigenschaften_scale = IrrGuiAddEditBox( "" , 40 , 185 , 185 , 205 , 1 , *Window_Eigenschaften , 22 ) 
  *Text_5 = IrrGuiAddStaticText( "Name:" , 5 , 205 , 40 , 225 , 1 , 1 , 1 , *Window_Eigenschaften , 23 ) 
  *String_eigenschaften_name = IrrGuiAddEditBox( "" , 40 , 205 , 185 , 225 , 1 , *Window_Eigenschaften , 24 ) 
  *Text_7 = IrrGuiAddStaticText( "Animlist" , 5 , 225 , 40 , 245 , 1 , 1 , 1 , *Window_Eigenschaften , 25 ) 
  *String_eigenschaften_animlist = IrrGuiAddEditBox( "" , 40 , 225 , 185 , 245 , 1 , *Window_Eigenschaften , 26 ) 
  *Text_9 = IrrGuiAddStaticText( "startanim" , 5 , 245 , 40 , 265 , 1 , 1 , 1 , *Window_Eigenschaften , 27 ) 
  *Combo_eigenschaften_startanim = IrrGuiAddComboBox( 40 , 245 , 185 , 265 , *Window_Eigenschaften , 28 ) 
  *Image_Texture3 = IrrGuiAddButton( "" , 125 , 25 , 180 , 80 , *Window_Eigenschaften , 29 ) 
  *Button_eigenschaften_details = IrrGuiAddButton( "Details" , 5 , 270 , 85 , 290 , *Window_Eigenschaften , 30 ) 
  *Window_Outliner = IrrGuiAddWindow( 1 , 504 , 189 , 786 , "Outliner" , 0 , 0 , 31 ) 
  *Button_outliner_example = IrrGuiAddButton( "beispiel" , 35 , 25 , 90 , 45 , *Window_Outliner , 32 ) 
  *CheckBox_outliner_example_isobjectvisible = IrrGuiAddCheckBox( 0 , 5 , 25 , 30 , 45 , "" , *Window_Outliner , 33 ) 
  *Text_outliner_example_objectname = IrrGuiAddStaticText( "ObjektName" , 95 , 25 , 165 , 45 , 1 , 1 , 1 , *Window_Outliner , 34 ) 
  *Window_toolbox = IrrGuiAddWindow( -2 , -12 , 511 , 174 , "Toolbox" , 0 , 0 , 35 ) 
  *Button_toolbox_terrain_heben = IrrGuiAddButton( "terrainheben" , 5 , 25 , 170 , 45 , *Window_toolbox , 36 ) 
  *Button_toolbox_platzieren = IrrGuiAddButton( "Platzieren" , 5 , 45 , 170 , 65 , *Window_toolbox , 37 ) 
  *Button_toolbox_waypointsverbinden = IrrGuiAddButton( "verbinden" , 10 , 85 , 90 , 105 , *Window_toolbox , 38 ) 
  *Text_toolbox_waypoints = IrrGuiAddStaticText( "waypoints" , 10 , 65 , 85 , 85 , 1 , 1 , 1 , *Window_toolbox , 39 ) 
  *Button_toolbox_waypointstrennen = IrrGuiAddButton( "trennen" , 90 , 85 , 170 , 105 , *Window_toolbox , 40 ) 
  *ButtonImage_move = IrrGuiAddButton( "" , 10 , 120 , 45 , 150 , *Window_toolbox , 41 ) 
  *ButtonImage_scale = IrrGuiAddButton( "" , 45 , 120 , 80 , 150 , *Window_toolbox , 42 ) 
  *ButtonImage_rotate = IrrGuiAddButton( "" , 80 , 120 , 115 , 150 , *Window_toolbox , 43 ) 
  *ButtonImage_select = IrrGuiAddButton( "" , 115 , 120 , 150 , 150 , *Window_toolbox , 44 ) 
  *Button_toolbox_edit = IrrGuiAddButton( "Edit" , 150 , 120 , 190 , 150 , *Window_toolbox , 45 ) 
  *Button_19 = IrrGuiAddButton( "Texturepaint" , 10 , 155 , 175 , 175 , *Window_toolbox , 46 ) 
  *ScrollBar_toolbox_hohenfaktor = IrrGuiAddScrollBar( 1 , 235 , 30 , 500 , 50 , *Window_toolbox , 47 ) 
  *ScrollBar_toolbox_grosse = IrrGuiAddScrollBar( 1 , 235 , 50 , 500 , 70 , *Window_toolbox , 48 ) 
  *ScrollBar_toolbox_yverschiebung = IrrGuiAddScrollBar( 1 , 235 , 70 , 500 , 90 , *Window_toolbox , 49 ) 
  *Text_toolbox_hohenfaktor = IrrGuiAddStaticText( "Höhenfaktor" , 180 , 30 , 230 , 50 , 1 , 1 , 1 , *Window_toolbox , 50 ) 
  *Text_toolbox_pinselgrosse = IrrGuiAddStaticText( "Pinselgroße" , 180 , 50 , 230 , 70 , 1 , 1 , 1 , *Window_toolbox , 51 ) 
  *Text_16 = IrrGuiAddStaticText( "y-verschieb" , 180 , 70 , 230 , 90 , 1 , 1 , 1 , *Window_toolbox , 52 ) 
  *Window_newObjects = IrrGuiAddWindow( 526 , -8 , 673 , 158 , "NewObjects" , 0 , 0 , 53 ) 
  *Button_newobj_addwaypoint = IrrGuiAddButton( "waypoint" , 0 , 25 , 50 , 60 , *Window_newObjects , 54 ) 
  *Button_newobj_addmesh = IrrGuiAddButton( "Mesh" , 50 , 25 , 100 , 60 , *Window_newObjects , 55 ) 
  *Button_newobj_ = IrrGuiAddButton( "" , 100 , 25 , 150 , 60 , *Window_newObjects , 56 ) 
  *Button_newobj_addsky = IrrGuiAddButton( "Sky" , 0 , 60 , 50 , 95 , *Window_newObjects , 57 ) 
  *Button_newobj_addterrain = IrrGuiAddButton( "Terrain" , 50 , 60 , 100 , 95 , *Window_newObjects , 58 ) 
  *Button_newobj_addparticles = IrrGuiAddButton( "Particles" , 100 , 60 , 150 , 95 , *Window_newObjects , 59 ) 
  *Button_newobj_Billboard = IrrGuiAddButton( "Billboard" , 0 , 95 , 50 , 130 , *Window_newObjects , 60 ) 
  *Button_newobj_addsound = IrrGuiAddButton( "3D-Sound" , 50 , 95 , 100 , 130 , *Window_newObjects , 61 ) 
  *Button_newobj_music = IrrGuiAddButton( "Music" , 100 , 95 , 150 , 130 , *Window_newObjects , 62 ) 
  *Button_newobj_addplayer = IrrGuiAddButton( "Player" , 0 , 130 , 50 , 165 , *Window_newObjects , 63 ) 
  *Button_newobj_addnpc = IrrGuiAddButton( "NPC" , 50 , 130 , 100 , 165 , *Window_newObjects , 64 ) 
  *Window_kombinationen = IrrGuiAddWindow( 905 , -12 , 1067 , 716 , "Kombinationslist" , 0 , 0 , 65 ) 
  *Button_kombis_example = IrrGuiAddButton( "examplecombi" , 0 , 25 , 140 , 45 , *Window_kombinationen , 66 ) 
  *ScrollBar_4 = IrrGuiAddScrollBar( 1 , 145 , 25 , 160 , 725 , *Window_kombinationen , 67 ) 
  *Window_layer = IrrGuiAddWindow( 740 , 501 , 918 , 787 , "Layer" , 0 , 0 , 68 ) 
  *Text_18 = IrrGuiAddStaticText( "Brush" , 5 , 30 , 60 , 45 , 1 , 1 , 1 , *Window_layer , 69 ) 
  *ScrollBar_layer_brushsize = IrrGuiAddScrollBar( 1 , 35 , 50 , 170 , 65 , *Window_layer , 70 ) 
  *ScrollBar_layer_brushelementabstand = IrrGuiAddScrollBar( 1 , 35 , 65 , 170 , 80 , *Window_layer , 71 ) 
  *Text_layer_pinselsize = IrrGuiAddStaticText( "size" , 0 , 50 , 30 , 65 , 1 , 1 , 1 , *Window_layer , 72 ) 
  *Text_layer_elementabstand = IrrGuiAddStaticText( "lücke" , 0 , 65 , 30 , 80 , 1 , 1 , 1 , *Window_layer , 73 ) 
  *Button_layer_addlayer = IrrGuiAddButton( "Add_layer" , 0 , 105 , 80 , 120 , *Window_layer , 74 ) 
  *Button_layer_deletelayer = IrrGuiAddButton( "del_layer" , 90 , 105 , 165 , 120 , *Window_layer , 75 ) 
  *Text_23 = IrrGuiAddStaticText( "Layers:" , 5 , 85 , 60 , 100 , 1 , 1 , 1 , *Window_layer , 76 ) 
  *Button_layer_examplelayer = IrrGuiAddButton( "Examplelayer" , 0 , 145 , 165 , 160 , *Window_layer , 77 ) 
  *Button_selectlayer = IrrGuiAddButton( "Select_layer" , 0 , 120 , 80 , 135 , *Window_layer , 78 ) 
  *Window_textures = IrrGuiAddWindow( 206 , 693 , 788 , 778 , "texturewindow" , 0 , 0 , 79 ) 
  *Button_texture_add = IrrGuiAddButton( "add" , 5 , 65 , 80 , 80 , *Window_textures , 80 ) 
  *Button_texture_delete = IrrGuiAddButton( "del" , 80 , 65 , 155 , 80 , *Window_textures , 81 ) 
  *ScrollBar_texture_scroll = IrrGuiAddScrollBar( 1 , 155 , 65 , 575 , 80 , *Window_textures , 82 ) 
  *Image_textures_example = IrrGuiAddButton( "" , 5 , 25 , 50 , 65 , *Window_textures , 83 ) 
  *Window_opensave = IrrGuiAddWindow( 687 , -7 , 894 , 157 , "OpenSave" , 0 , 0 , 84 ) 
  *Button_opensave_save = IrrGuiAddButton( "Save" , 5 , 25 , 200 , 50 , *Window_opensave , 85 ) 
  *Button_opensave_saveas = IrrGuiAddButton( "SaveAs" , 5 , 50 , 200 , 75 , *Window_opensave , 86 ) 
  *Button_opensave_Open = IrrGuiAddButton( "Open" , 5 , 85 , 200 , 110 , *Window_opensave , 87 ) 
  *Button_opensave_new = IrrGuiAddButton( "New" , 5 , 110 , 200 , 135 , *Window_opensave , 88 ) 
  *Button_opensave_import = IrrGuiAddButton( "Import" , 5 , 135 , 200 , 160 , *Window_opensave , 89 ) 
  
  ; set Images.
  
  *Image_Texture1_texture = IrrGetTexture( "GFX\Welteditor\no_texture.jpg" )
  IrrGuiButtonSetImage     ( *Image_Texture1 , *Image_Texture1_texture )
  *Image_Texture2_texture = IrrGetTexture( "GFX\Welteditor\no_texture.jpg" )
  IrrGuiButtonSetImage     ( *Image_Texture2 , *Image_Texture2_texture )
  *Image_Texture3_texture = IrrGetTexture( "GFX\Welteditor\no_texture.jpg" )
  IrrGuiButtonSetImage     ( *Image_Texture3 , *Image_Texture3_texture )
  *image_buttonimage_move = IrrGetTexture( "GFX\Welteditor\move.jpg" )
  IrrGuiButtonSetImage     ( *ButtonImage_move , *image_buttonimage_move )
  *image_buttonimage_scale = IrrGetTexture( "GFX\Welteditor\scale.jpg" )
  IrrGuiButtonSetImage     ( *ButtonImage_scale , *image_buttonimage_scale )
  *image_buttonimage_rotate = IrrGetTexture( "GFX\Welteditor\rotate.jpg" )
  IrrGuiButtonSetImage     ( *ButtonImage_rotate , *image_buttonimage_rotate )
  *image_buttonimage_select = IrrGetTexture( "GFX\Welteditor\select.jpg" )
  IrrGuiButtonSetImage     ( *ButtonImage_select , *image_buttonimage_select )
  
  ; die Comboboxes
  
  IrrGuiComboBoxAddItem( *Combo_col_art , "Col_detail_box")
  IrrGuiComboBoxAddItem( *Combo_col_art , "Col_detail_Mesh")
  IrrGuiComboBoxAddItem( *Combo_col_art , "Col_detail_terrain")
  IrrGuiComboBoxAddItem( *Combo_col_type , "coltype_Nocollision")
  IrrGuiComboBoxAddItem( *Combo_col_type , "coltype_Solid")
  IrrGuiComboBoxAddItem( *Combo_col_type , "coltype_movable")
  IrrGuiComboBoxAddItem( *Combo_eigenschaften_startanim , "NoEntry" ) ; wird je nach Mesh angepasst. die Meshes haben ja eine animliste, bei dene die animationen vermerkt sind.
  IrrGuiComboBoxAddItem( *Combo_materialtype, "Irr_emt_solid")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_SOLID_2_LAYER")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_LIGHTMAP")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_LIGHTMAP_ADD")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_LIGHTMAP_M2")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_LIGHTMAP_LIGHTING")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_LIGHTMAP_LIGHTING_M2")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_DETAIL_MAP")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_SPHERE_MAP")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_REFLECTION_2_LAYER")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_TRANSPARENT_ADD_COLOR")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_TRANSPARENT_ALPHA_CHANNEL")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_TRANSPARENT_VERTEX_ALPHA")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_NORMAL_MAP_SOLID")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_PARALLAX_MAP_SOLID")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR")
  IrrGuiComboBoxAddItem( *Combo_materialtype, "IRR_EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA")
  
  ; Alpha der Buttons/windows
  IrrGuiSetAlpha( 200)
  
  
  ; load the Scene, which was created with IrrEdit. So we have a complete Scene, with
  ; Objects, Animator and Lights. 
  IrrLoadScene("media\example.irr");
  
  ; add a first person perspective camera into the scene that is controlled with
  ; the mouse and the cursor keys. if however you capture events when starting
  ; irrlicht this will become a normal camera that can only be moved by code
  *OurCamera = IrrAddCamera( 50,0,0, 0,0,0 )
  
  ; while the scene is still running
  While IrrRunning()
  
      ; begin the scene, erasing the canvas to white before rendering
      IrrBeginScene( 255,255,255 )
  
      ; draw the scene
      
    While IrrGuiEventAvailable()
      *guievent.IRR_GUI_EVENT = IrrReadGuiEvent()
  ;;      Debug(Str(*guievent\eventtype))
      If *guievent\EventType > 0
      EndIf
      If *guievent\EventType > 0 
        If *guievent\Caller = *button And *guievent\EventType = #IRR_EGET_BUTTON_CLICKED
          Debug("Button !")
          IrrGuiSetText(*caption, "Button was pressed")
          mytext.s = IrrGuiGetText(*button)
          Debug(mytext)
        EndIf
        If *guievent\Caller = *scrollbar
          Debug("Scrollbar !")
          v.l = IrrGuiScrollBarGetPos(*scrollbar)
          IrrGuiSetAlpha(v )
         EndIf
      EndIf
    Wend
    
      ; while there are key events waiting to be processed
      While IrrKeyEventAvailable()
  
          ; read the key event out. the key event has three parameters the key
          ; scan code, the direction of the key and flags that indicate whether
          ; the control key or the shift keys were also pressed
          *KeyEvent.IRR_KEY_EVENT = IrrReadKeyEvent()
          Debug( "Key="+ Str(*KeyEvent\key))
       Wend
  
      IrrDrawScene()      
  
      ; draw the Graphical User Interface
      IrrDrawGUI()
  
      ; end drawing the scene and render it
      IrrEndScene()
      
  Wend
  
  ; -----------------------------------------------------------------------------
  ; Stop the irrlicht engine and release resources
  IrrStop()
EndIf

End 
; jaPBe Version=3.8.8.716
; Build=0
; FirstLine=162
; CursorPosition=181
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF