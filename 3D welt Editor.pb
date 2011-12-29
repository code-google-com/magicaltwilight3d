
; --------------------------------------------------------------------------------------------------------------------
; --- Includes 
; --------------------------------------------------------------------------------------------------------------------
XIncludeFile #PB_Compiler_Home + "includes\irrlichtWrapper_include.pbi"


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

; windows:

Global *Window_0
Global *Window_Eigenschaften
Global *Window_kombinationen
Global *Window_layer
Global *Window_newObjects
Global *Window_opensave
Global *Window_Outliner
Global *Window_textures
Global *Window_toolbox

Global *window_0_NR = 0
Global *window_eigenschaften_NR = 11
Global *window_kombinationen_NR = 65
Global *window_layer_NR         = 68
Global *Window_newObjects_NR    = 53
Global *Window_opensave_NR      = 84
Global *window_Outliner_NR      = 31
Global *window_textures_NR      = 79
Global *window_toolbox_NR       = 35

; Gadgets:

  ; window main.
  Global *Button_Main_Outliner 
  Global *Button_Main_AddStuff 
  Global *Button_Main_Eigenschaften 
  Global *Button_Main_kombis 
  Global *Button_Main_Toolbox 
  Global *Button_Main_Textures 
  Global *Button_Main_Layers 
  Global *Button_Main_openSave 
  Global *Button_Main_Quit 
  ; 
  Global *Image_Texture1 
  Global *Image_Texture2 
  Global *Combo_materialtype 
  Global *Combo_col_art 
  Global *Combo_col_type
  Global *Text_eigenschaften_pos 
  Global *String_eigenschaften_pos 
  Global *Text_eigenschaften_rot 
  Global *String_eigenschaften_rot 
  Global *Text_eigenschaften_rot 
  Global *String_eigenschaften_scale 
  Global *Text_eigenschaften_name 
  Global *String_eigenschaften_name 
  Global *Text_eigenschaften_animlist 
  Global *String_eigenschaften_animlist 
  Global *Text_eigenschaften_startanim 
  Global *Combo_eigenschaften_startanim 
  Global *Image_Texture3 
  Global *Button_eigenschaften_details 
  Global *Button_outliner_example 
  Global *CheckBox_outliner_example_isobjectvisible 
  Global *Text_outliner_example_objectname 
  Global *Button_toolbox_terrain_heben 
  Global *Button_toolbox_platzieren 
  Global *Button_toolbox_waypointsverbinden 
  Global *Text_toolbox_waypoints 
  Global *Button_toolbox_waypointstrennen 
  Global *ButtonImage_move 
  Global *ButtonImage_scale
  Global *ButtonImage_rotate 
  Global *ButtonImage_select 
  Global *Button_toolbox_edit
  Global *Button_toolbox_texturepaint 
  Global *ScrollBar_toolbox_hohenfaktor 
  Global *ScrollBar_toolbox_grosse 
  Global *ScrollBar_toolbox_yverschiebung 
  Global *Text_toolbox_hohenfaktor 
  Global *Text_toolbox_pinselgrosse 
  Global *Text_toolbox_yverschieb 
  Global *Button_newobj_addwaypoint 
  Global *Button_newobj_addmesh 
  Global *Button_newobj_ 
  Global *Button_newobj_addsky 
  Global *Button_newobj_addterrain 
  Global *Button_newobj_addparticles 
  Global *Button_newobj_Billboard 
  Global *Button_newobj_addsound 
  Global *Button_newobj_music 
  Global *Button_newobj_addplayer 
  Global *Button_newobj_addnpc 
  Global *Button_kombis_example 
  Global *ScrollBar_kombinationen_scrollbar 
  Global *Text_layer_brush 
  Global *ScrollBar_layer_brushsize 
  Global *ScrollBar_layer_brushelementabstand 
  Global *Text_layer_pinselsize 
  Global *Text_layer_elementabstand 
  Global *Button_layer_addlayer 
  Global *Button_layer_deletelayer 
  Global *Text_layer_Layers 
  Global *Button_layer_examplelayer 
  Global *Button_selectlayer 
  Global *Button_texture_add 
  Global *Button_texture_delete 
  Global *ScrollBar_texture_scroll 
  Global *Image_textures_example 
  Global *Button_opensave_save 
  Global *Button_opensave_saveas 
  Global *Button_opensave_Open 
  Global *Button_opensave_new 
  
  
  Global main_window_main_Isopen.i  
  Global main_window_eigenschaften_Isopen.i  
  Global main_window_outliner_Isopen.i  
  Global main_window_toolbox_Isopen.i  
  Global main_window_newobjects_Isopen.i  
  Global main_window_kombinationslist_isopen
  Global main_window_layer_isopen
  Global main_window_texturewindow_isopen
  Global main_window_opensave_isopen
  

; --------------------------------------------------------------------------------------------------------------------
; --- Procedures 
; --------------------------------------------------------------------------------------------------------------------
Procedure open_window_main(Doopen= 1)
 
 If main_window_main_Isopen = 0
   *Window_0 = 0; IrrGuiAddWindow( -9 , -13 , 1015 , 775 , "Newwindow(0" , 0 , 0 , 1 ) 
   *Button_Main_Outliner = IrrGuiAddButton( "Outliner" , 5 , 30 , 75 , 60 , *Window_0 , 2 ) 
   *Button_Main_AddStuff = IrrGuiAddButton( "Newthings" , 80 , 30 , 150 , 60 , *Window_0 , 3 ) 
   *Button_Main_Eigenschaften = IrrGuiAddButton( "Eigenschaften" , 230 , 30 , 300 , 60 , *Window_0 , 4 ) 
   *Button_Main_kombis = IrrGuiAddButton( "kombis" , 155 , 30 , 225 , 60 , *Window_0 , 5 ) 
   *Button_Main_Toolbox = IrrGuiAddButton( "Toolbox" , 305 , 30 , 375 , 60 , *Window_0 , 6 ) 
   *Button_Main_Textures = IrrGuiAddButton( "Textures" , 455 , 30 , 525 , 60 , *Window_0 , 7 ) 
   *Button_Main_Layers = IrrGuiAddButton( "Layer" , 380 , 30 , 450 , 60 , *Window_0 , 8 ) 
   *Button_Main_openSave = IrrGuiAddButton( "Open/Save" , 530 , 30 , 600 , 60 , *Window_0 , 9 ) 
   *Button_Main_Quit = IrrGuiAddButton( "Quit" , 645 , 30 , 715 , 55 , *Window_0 , 10 ) 
    main_window_main_Isopen = 1
  EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_main_Isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_eigenschaften(Doopen = 1)

  If main_window_eigenschaften_Isopen = 0
      Debug "open eigenschafnten"
      main_window_eigenschaften_Isopen = 1
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
      *Text_eigenschaften_rot = IrrGuiAddStaticText( "Rot:" , 5 , 165 , 40 , 185 , 1 , 1 , 1 , *Window_Eigenschaften , 21 ) 
      *String_eigenschaften_scale = IrrGuiAddEditBox( "" , 40 , 185 , 185 , 205 , 1 , *Window_Eigenschaften , 22 ) 
      *Text_eigenschaften_name = IrrGuiAddStaticText( "Name:" , 5 , 205 , 40 , 225 , 1 , 1 , 1 , *Window_Eigenschaften , 23 ) 
      *String_eigenschaften_name = IrrGuiAddEditBox( "" , 40 , 205 , 185 , 225 , 1 , *Window_Eigenschaften , 24 ) 
      *Text_eigenschaften_animlist = IrrGuiAddStaticText( "Animlist" , 5 , 225 , 40 , 245 , 1 , 1 , 1 , *Window_Eigenschaften , 25 ) 
      *String_eigenschaften_animlist = IrrGuiAddEditBox( "" , 40 , 225 , 185 , 245 , 1 , *Window_Eigenschaften , 26 ) 
      *Text_eigenschaften_startanim = IrrGuiAddStaticText( "startanim" , 5 , 245 , 40 , 265 , 1 , 1 , 1 , *Window_Eigenschaften , 27 ) 
      *Combo_eigenschaften_startanim = IrrGuiAddComboBox( 40 , 245 , 185 , 265 , *Window_Eigenschaften , 28 ) 
      *Image_Texture3 = IrrGuiAddButton( "" , 125 , 25 , 180 , 80 , *Window_Eigenschaften , 29 ) 
      *Button_eigenschaften_details = IrrGuiAddButton( "Details" , 5 , 270 , 85 , 290 , *Window_Eigenschaften , 30 ) 
      
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
      
      ; die textures
      
      *Image_Texture1_texture = IrrGetTexture( "GFX\Welteditor\no_texture.jpg" )
      IrrGuiButtonSetImage     ( *Image_Texture1 , *Image_Texture1_texture )
      *Image_Texture2_texture = IrrGetTexture( "GFX\Welteditor\no_texture.jpg" )
      IrrGuiButtonSetImage     ( *Image_Texture2 , *Image_Texture2_texture )
      *Image_Texture3_texture = IrrGetTexture( "GFX\Welteditor\no_texture.jpg" )
      IrrGuiButtonSetImage     ( *Image_Texture3 , *Image_Texture3_texture )
  EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_eigenschaften_Isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_outliner(Doopen=1)

  If main_window_outliner_Isopen = 0
      main_window_outliner_Isopen = 1
      *Window_Outliner = IrrGuiAddWindow( 1 , 504 , 189 , 786 , "Outliner" , 0 , 0 , 31 ) 
      *Button_outliner_example = IrrGuiAddButton( "beispiel" , 35 , 25 , 90 , 45 , *Window_Outliner , 32 ) 
      *CheckBox_outliner_example_isobjectvisible = IrrGuiAddCheckBox( 0 , 5 , 25 , 30 , 45 , "" , *Window_Outliner , 33 ) 
      *Text_outliner_example_objectname = IrrGuiAddStaticText( "ObjektName" , 95 , 25 , 165 , 45 , 1 , 1 , 1 , *Window_Outliner , 34 ) 
  EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_outliner_Isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_toolbox(Doopen=1)
  If main_window_toolbox_Isopen = 0
      main_window_toolbox_Isopen = 1
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
      *Button_toolbox_texturepaint = IrrGuiAddButton( "Texturepaint" , 10 , 155 , 175 , 175 , *Window_toolbox , 46 ) 
      *ScrollBar_toolbox_hohenfaktor = IrrGuiAddScrollBar( 1 , 235 , 30 , 500 , 50 , *Window_toolbox , 47 ) 
      *ScrollBar_toolbox_grosse = IrrGuiAddScrollBar( 1 , 235 , 50 , 500 , 70 , *Window_toolbox , 48 ) 
      *ScrollBar_toolbox_yverschiebung = IrrGuiAddScrollBar( 1 , 235 , 70 , 500 , 90 , *Window_toolbox , 49 ) 
      *Text_toolbox_hohenfaktor = IrrGuiAddStaticText( "Höhenfaktor" , 180 , 30 , 230 , 50 , 1 , 1 , 1 , *Window_toolbox , 50 ) 
      *Text_toolbox_pinselgrosse = IrrGuiAddStaticText( "Pinselgroße" , 180 , 50 , 230 , 70 , 1 , 1 , 1 , *Window_toolbox , 51 ) 
      *Text_toolbox_yverschieb = IrrGuiAddStaticText( "y-verschieb" , 180 , 70 , 230 , 90 , 1 , 1 , 1 , *Window_toolbox , 52 ) 
      
      ; images 
      
      *image_buttonimage_move = IrrGetTexture( "GFX\Welteditor\move.jpg" )
      IrrGuiButtonSetImage     ( *ButtonImage_move , *image_buttonimage_move )
      *image_buttonimage_scale = IrrGetTexture( "GFX\Welteditor\scale.jpg" )
      IrrGuiButtonSetImage     ( *ButtonImage_scale , *image_buttonimage_scale )
      *image_buttonimage_rotate = IrrGetTexture( "GFX\Welteditor\rotate.jpg" )
      IrrGuiButtonSetImage     ( *ButtonImage_rotate , *image_buttonimage_rotate )
      *image_buttonimage_select = IrrGetTexture( "GFX\Welteditor\select.jpg" )
      IrrGuiButtonSetImage     ( *ButtonImage_select , *image_buttonimage_select )
  EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_toolbox_Isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_newobjects(Doopen=1)
  If main_window_newobjects_Isopen = 0
      main_window_newobjects_Isopen = 1
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
  EndIf 
   
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_newobjects_Isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_kombinationslist(Doopen=1)
  If main_window_kombinationslist_isopen = 0
      main_window_kombinationslist_isopen = 1
      *Window_kombinationen = IrrGuiAddWindow( 905 , -12 , 1067 , 716 , "Kombinationslist" , 0 , 0 , 65 ) 
      *Button_kombis_example = IrrGuiAddButton( "examplecombi" , 0 , 25 , 140 , 45 , *Window_kombinationen , 66 ) 
      *ScrollBar_kombinationen_scrollbar = IrrGuiAddScrollBar( 1 , 145 , 25 , 160 , 725 , *Window_kombinationen , 67 ) 
  EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_kombinationslist_isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_layer(Doopen=1)
   If main_window_layer_isopen = 0
      main_window_layer_isopen = 1
      *Window_layer = IrrGuiAddWindow( 740 , 501 , 918 , 787 , "Layer" , 0 , 0 , 68 ) 
      *Text_layer_brush = IrrGuiAddStaticText( "Brush" , 5 , 30 , 60 , 45 , 1 , 1 , 1 , *Window_layer , 69 ) 
      *ScrollBar_layer_brushsize = IrrGuiAddScrollBar( 1 , 35 , 50 , 170 , 65 , *Window_layer , 70 ) 
      *ScrollBar_layer_brushelementabstand = IrrGuiAddScrollBar( 1 , 35 , 65 , 170 , 80 , *Window_layer , 71 ) 
      *Text_layer_pinselsize = IrrGuiAddStaticText( "size" , 0 , 50 , 30 , 65 , 1 , 1 , 1 , *Window_layer , 72 ) 
      *Text_layer_elementabstand = IrrGuiAddStaticText( "lücke" , 0 , 65 , 30 , 80 , 1 , 1 , 1 , *Window_layer , 73 ) 
      *Button_layer_addlayer = IrrGuiAddButton( "Add_layer" , 0 , 105 , 80 , 120 , *Window_layer , 74 ) 
      *Button_layer_deletelayer = IrrGuiAddButton( "del_layer" , 90 , 105 , 165 , 120 , *Window_layer , 75 ) 
      *Text_layer_Layers = IrrGuiAddStaticText( "Layers:" , 5 , 85 , 60 , 100 , 1 , 1 , 1 , *Window_layer , 76 ) 
      *Button_layer_examplelayer = IrrGuiAddButton( "Examplelayer" , 0 , 145 , 165 , 160 , *Window_layer , 77 ) 
      *Button_selectlayer = IrrGuiAddButton( "Select_layer" , 0 , 120 , 80 , 135 , *Window_layer , 78 ) 
  EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_layer_isopen = 0
  EndIf 
EndProcedure 

Procedure open_window_texturewindow(Doopen=1)
   If main_window_texturewindow_isopen = 0
      main_window_texturewindow_isopen = 1
      *Window_textures = IrrGuiAddWindow( 206 , 693 , 788 , 778 , "texturewindow" , 0 , 0 , 79 ) 
      *Button_texture_add = IrrGuiAddButton( "add" , 5 , 65 , 80 , 80 , *Window_textures , 80 ) 
      *Button_texture_delete = IrrGuiAddButton( "del" , 80 , 65 , 155 , 80 , *Window_textures , 81 ) 
      *ScrollBar_texture_scroll = IrrGuiAddScrollBar( 1 , 155 , 65 , 575 , 80 , *Window_textures , 82 ) 
      *Image_textures_example = IrrGuiAddButton( "" , 5 , 25 , 50 , 65 , *Window_textures , 83 ) 
   EndIf 
   
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_texturewindow_isopen = 0
  EndIf 
  
EndProcedure 

Procedure open_window_opensave(Doopen=1)
   If main_window_opensave_isopen = 0
      main_window_opensave_isopen = 1
      *Window_opensave = IrrGuiAddWindow( 687 , -7 , 894 , 157 , "OpenSave" , 0 , 0 , 84 ) 
      *Button_opensave_save = IrrGuiAddButton( "Save" , 5 , 25 , 200 , 50 , *Window_opensave , 85 ) 
      *Button_opensave_saveas = IrrGuiAddButton( "SaveAs" , 5 , 50 , 200 , 75 , *Window_opensave , 86 ) 
      *Button_opensave_Open = IrrGuiAddButton( "Open" , 5 , 85 , 200 , 110 , *Window_opensave , 87 ) 
      *Button_opensave_new = IrrGuiAddButton( "New" , 5 , 110 , 200 , 135 , *Window_opensave , 88 ) 
      *Button_opensave_import = IrrGuiAddButton( "Import" , 5 , 135 , 200 , 160 , *Window_opensave , 89 ) 
   EndIf 
  
  If Doopen = 0 ; wieder freigeben zum neuöffnen (das alte wurde von irrlicht geclosed)
     main_window_opensave_isopen = 0
  EndIf 
  
EndProcedure 

Procedure open_window_all()
   open_window_main()
   open_window_eigenschaften()
   open_window_kombinationslist()
   open_window_layer()
   open_window_newobjects()
   open_window_opensave()
   open_window_outliner()
   open_window_texturewindow()
   open_window_toolbox()
EndProcedure 

; --------------------------------------------------------------------------------------------------------------------
; --- Schleife 
; --------------------------------------------------------------------------------------------------------------------







; --------------------------------------------------------------------------------------------------------------------
; --- test nur zum gui anzeigen
; --------------------------------------------------------------------------------------------------------------------

ScreenWidth.l = 1240
ScreenHeight.l = 900

If IrrStartEx(#IRR_EDT_DIRECT3D9 , ScreenWidth , ScreenHeight , 0, 1,1,32,1,0,1,0)
  ; Set the title of the display
  IrrSetWindowCaption( "Example 26: Using the Irrlicht-GUI" )
  
  ; add a static text object to the graphical user interface, at the moment
  ; this is the only interface object we support. The text will be drawn inside
  ; the defined rectangle, the box will not have a border and the text will not
  ; be wrapped around if it runs off the end


  open_window_all() 
  ; Alpha der Buttons/windows
  IrrGuiSetAlpha( 200)
  
  
  ; load the Scene, which was created with IrrEdit. So we have a complete Scene, with
  ; Objects, Animator and Lights. 
  SetCurrentDirectory("gfx\maps\max welt\")
  IrrLoadScene("Max_welt.irr");
  
  ; add a first person perspective camera into the scene that is controlled with
  ; the mouse and the cursor keys. if however you capture events when starting
  ; irrlicht this will become a normal camera that can only be moved by code
  *OurCamera = IrrAddCamera( 2901.004883, 3066.408691, 3381.165039, 2901.004883, 3066.408691,0 )
  
  ; while the scene is still running
  While IrrRunning()
  
      ; begin the scene, erasing the canvas to white before rendering
      IrrBeginScene( 255,255,255 )
  
      ; draw the scene
      
    While IrrGuiEventAvailable()
      *guievent.IRR_GUI_EVENT = IrrReadGuiEvent()
        Debug(Str(*guievent\EventType))
      If *guievent\EventType > 0
      EndIf
        If  *guievent\EventType = #IRR_EGET_BUTTON_CLICKED
          Select *guievent\Caller 
             Case *Button_Main_Quit
                  End 
             Case *Button_Main_AddStuff
                open_window_newobjects()
             Case *Button_Main_Eigenschaften
               open_window_eigenschaften( 1)
             Case *Button_Main_kombis
                open_window_kombinationslist(1)
             Case *Button_Main_Layers
                open_window_layer(1)
             Case *Button_Main_openSave
                open_window_opensave(1)
             Case *Button_Main_Outliner
                open_window_outliner(1) 
             Case *Button_Main_Textures
                open_window_texturewindow(1)
             Case *Button_Main_Toolbox
                open_window_toolbox(1)
             
          EndSelect 
          
        ElseIf *guievent\EventType = #IRR_EGET_ELEMENT_CLOSED
            Debug *guievent\itemID
            
            Select *guievent\itemID  ; close the windows.
               Case *window_eigenschaften_NR
                  open_window_eigenschaften( 0)
               Case *window_kombinationen_NR
                  open_window_kombinationslist(0)
               Case *window_layer_NR
                  open_window_layer(0)
               Case *Window_newObjects_NR
                  open_window_newobjects(0)
               Case *Window_opensave_NR
                  open_window_opensave(0)
               Case *window_Outliner_NR
                  open_window_outliner(0)
               Case *window_textures_NR
                  open_window_texturewindow(0)
               Case *window_toolbox_NR
                  open_window_toolbox(0)
            EndSelect 
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
; jaPBe Version=3.9.12.819
; Build=1
; FirstLine=0
; CursorPosition=27
; ExecutableFormat=Windows
; Executable=G:\Eigene Daten\Documents\Programmierung\Magical Twilight\Welteditor.exe
; DontSaveDeclare
; EOF