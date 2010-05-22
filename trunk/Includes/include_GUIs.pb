   
   
   Procedure gui_getInventarItemPos ( Itemnr , *itemposx.i , *itemposy.i ) ; pointer zu *itemposx/y werden gebraucht.. itemnr = InventarItemNR - 1 !
      Protected itemposx.i , itemposy.i 
      
      itemposx                  = gui_inventar_FirstSlotX + gui_X + gui_inventar_Slotbreite * ((Itemnr) % gui_inventar_SlotCountX )   
      itemposy                  = gui_inventar_FirstSloty + gui_Y + gui_inventar_Slothohe   * Round((Itemnr) / gui_inventar_SlotCountX ,0)
      itemposy                  - (gui_current_Sack -1 )   * gui_inventar_SlotCountY * gui_inventar_Slothohe 
      
      If *itemposx > 0 And *itemposy >0
         PokeI ( *itemposx , itemposx ) 
         PokeI ( *itemposy , itemposy ) 
      EndIf 
   EndProcedure 
   
   Procedure gui_showQuickHelp ( Posx , Posy , text.s )
       Static *staticText      , lasttext.s , posx2.i , posy2.i
          If *staticText       > 0
             iFreeGUI          ( *staticText ) ; altes Fenster löschen.
             *staticText       = 0
          EndIf 
          
          ;{ Text darf nicht oben oder unten überstehen.
          posx2 = Posx + 200 
          posy2 = Posy + CountString(text , Chr(10))*23 + 23
          If posx2 > anz_getscreenwidth()
             Posx  + anz_getscreenwidth() - posx2 ; verschiebt posx um das am bildschirm überstehende stückchen text nach links
             posx2 = anz_getscreenwidth()
          EndIf 
          If posy2 > anz_getscreenheight()
             Posy  + anz_getscreenheight() - posy2 ; verschiebt posx um das am bildschirm überstehende stückchen text nach links
             posy2 = anz_getscreenheight()
          EndIf 
          ;}
          
          If Trim(text , Chr(10))        <> ""
             *staticText       = iAddStaticText(text, Posx , Posy ,posx2,posy2, #False , #True, #True )
             iBackgroundColor_GUIText  ( *staticText , $AA444444)
          EndIf 
   EndProcedure 
   
   Procedure Gui_SetSchnellWahlItem ( Position, *itemID.ITEM )
      Protected *olditemID.ITEM 
      
      ; altes Item hiden     :) 
      *olditemID             = Gui_SchnellwahlItem ( Position)\itemID 
      If *olditemID 
         anz_freeimage       ( Gui_SchnellwahlItem ( Position)\ImageNR )
         Gui_SchnellwahlItem ( Position)\itemID = 0 ; rauswerfen. evtl ist itemid ja 0, aber das alte soll trotzdem raus.
      EndIf 
      
      ; neues Item reinwerfen
      If *itemID 
         Gui_SchnellwahlItem ( Position)\itemID  = *itemID 
         Gui_SchnellwahlItem ( Position)\ImageNR = anz_loadimage( -1 , Gui_inventar_Schnellrust_x + Gui_Inventar_Schnellrust_SlotBreite*Position , Gui_Inventar_Schnellrust_y , *itemID\gui_InventarImage_pfad , 1 , 0 )
      EndIf 
   EndProcedure 
   
   Procedure Gui_GetSchnellWahlItem ( Position ) ; gibt Itemid des Gui_SchnellwahlItems heraus.
      ProcedureReturn Gui_SchnellwahlItem ( posiiton )\itemID 
   EndProcedure 
   
   Procedure gui_UseSchnellWahlItem ( Position ) ; benutzt item; wenn item dabei verbraucht wird-> search inventar nach gleichem/ähnlichem Item und legs da rein.
      Protected *newitem.ITEM , *itemID.ITEM 
      *itemID     = Gui_SchnellwahlItem(Position)\itemID 
      If *itemID  > 0
         *newitem = spi_Inventar_SearchItem( spi_getcurrentplayer() , *itemID\Name , *itemID\art , *itemID )
         If spi_inventar_UseItem( spi_getcurrentplayer() ,*itemID ) = 0
            Gui_SetSchnellWahlItem( Position , *newitem )
         EndIf 
      EndIf 
   EndProcedure 
   
   Procedure gui_GetSelectedSchnellwahlItem() ; gibt die aktuelle NR heraus (1.Item = 1 )
      Protected ItemX 
      
      ItemX     = Round((anz_mousex ()+1 - Gui_inventar_Schnellrust_x) / Gui_Inventar_Schnellrust_SlotBreite,0)
      If ItemX <= Gui_Inventar_Schnellrust_Slotcount
         ProcedureReturn ItemX 
      EndIf 
      
   EndProcedure 
   
   Procedure gui_updateGUI()
      Static    selected_item.i ,  *itemID.ITEM , selected_item_status 
      Protected sack_image_status1 , sack_image_status2 , sack_image_status3 ; Sackstati für sack_image_selected bild etc.
      Protected *SpielerID.spi_spieler , *inventarID.spi_inventar , *altesschwert.ITEM , *altesschwert_waffe.item_waffe , *alterustung.ITEM , *alterustung_waffe.item_waffe
      Static    itemposx.i , itemposy.i , IsVerschieben.i , Verschieben_Item , *verschieben_item_waffe.item_waffe ,  *verschieben_item.ITEM , verschieben_startx , verschieben_starty , verschieben_mousex , verschieben_mousey ,selected_item_last = -1 , verschieben_Sack
      
      ; do here some inventar based stuff.. select items, use them, throw them away, ausrüsten of the player etc.
      If Not                 ( gui_current_Status = 0 Or gui_current_Status = #Gui_Status_HUD) ; wenn guistatus nicht 0 oder nur HUD ist-> pause game
         anz_pauseGame       ( #anz_pause_GUI  , 1)
         anz_hideimage       ( Gui_Image_Mouse , 0)
         anz_setimagepos     ( Gui_Image_Mouse , anz_mousex() , anz_mousey () )
      Else                   ; wenn INGAME, dann wird vom GUI aus keine pause ausgelöst -> continue game. (unpause)
         anz_hideimage       ( Gui_Image_Mouse , 1)
         anz_pauseGame       ( #anz_pause_GUI  , 0) 
         anz_hideimage       ( Gui_Image_Inventar_Itemback_Pressed   , 1 )
         anz_hideimage       ( Gui_Image_Inventar_Itemback_Selected  , 1 )
      EndIf 
      
      If gui_current_Status & #gui_Status_Inventar = #gui_Status_Inventar ; INventar= offen
         ; position + GUI_x, weil sich gui je nach auflösung verschieben kann.
         
         gui_showQuickHelp      ( 0 , 0 , "" ) ; falls gui_element noch da ist und nicht mehr angezeigt werden soll -> löschen.
         
            ;{ items swappen und verschieben starten
          If anz_mouseinbox              ( gui_inventar_FirstSlotX +gui_X, gui_inventar_FirstSloty + gui_Y , gui_inventar_Slotbereichbreite , gui_inventar_Slotbereichhohe ) ; Buttons verschieben können, und Avatar ausrüsten, Items austauschen/Sortieren, items leuchten auf, wenn mouseover etc. 
             selected_item_status        = #gui_item_status_normal 
             selected_item               = Gui_GetSelectedInventarItem()
             
             If Not selected_item        = selected_item_last 
                selected_item_last       = selected_item    
                gui_getInventarItemPos   ( selected_item , @itemposx , @itemposy )
                anz_setimagepos          ( Gui_Image_Inventar_Itemback_Pressed  , itemposx , itemposy )
                anz_setimagepos          ( Gui_Image_Inventar_Itemback_Selected , itemposx , itemposy )
             EndIf 
             
             ; selected/pressed umschalten; items swappen.
             If anz_mousebutton          ( 1 , #anz_MouseEvent_tipped) > 0
                selected_item_status     = #gui_item_status_pressed
                gui_current_item         = selected_item  
                
             ElseIf anz_mousebutton      ( 1 , #anz_MouseEvent_pressed) 
                
                selected_item_status     = #gui_item_status_pressed 
                ; verschieben starten.
                If IsVerschieben         = 0   
                  IsVerschieben          = 1
                  verschieben_Sack       = gui_current_Sack 
                  verschieben_startx     = 0
                  verschieben_starty     = 0
                  gui_getInventarItemPos ( selected_item , @itemposx , @itemposy )
                  verschieben_mousex     = anz_mousex() - itemposx
                  verschieben_mousey     = anz_mousey() - itemposy
                  Verschieben_Item       = gui_current_item ; das Item. was zuletzt angetippt wurde 
                  *SpielerID             = spi_getcurrentplayer()
                  *inventarID            = *SpielerID\InventarID 
                  *verschieben_item      = *inventarID\itemID[ Verschieben_Item +1 ]
                  If Not *verschieben_item 
                     IsVerschieben       = 0 
                  EndIf 
                  
                EndIf 
             ElseIf anz_mousebutton      ( 1 , #anz_MouseEvent_no ) 
                selected_item_status     = #gui_item_status_selected 
                IsVerschieben            = 0 
             EndIf 
             
             ; items austauschen           -> item wird im Itemfeld gedropped.
             If anz_mousebutton            ( 1 ,  #anz_MouseEvent_released ) > 0
                If IsVerschieben           = 2 ; items jetzt austauschen, falls vorhanden.   
                    spi_inventar_SwapItems ( spi_getcurrentplayer() , selected_item+1, Verschieben_Item +1 )
                    gui_UpdateInventarView ()
                    IsVerschieben          = 0
                EndIf 
             EndIf 
             
             ; Itemhintergrund Animieren
             Select selected_item_status 
                Case #gui_item_status_normal
                Case #gui_item_status_selected
                   anz_hideimage         ( Gui_Image_Inventar_Itemback_Selected   , 1 )
                   anz_hideimage         ( Gui_Image_Inventar_Itemback_Pressed    , 0 )
                Case #gui_item_status_pressed
                   anz_hideimage         ( Gui_Image_Inventar_Itemback_Pressed    , 1 )
                   anz_hideimage         ( Gui_Image_Inventar_Itemback_Selected   , 0 )
             EndSelect  
            
            ; Iteminfos anzeigen
            gui_getInventarItemPos       ( selected_item , @itemposx , @itemposy )
            gui_showQuickHelp            ( anz_mousex () +40   , anz_mousey () + 20 , Item_GetName(spi_inventar_getItem(spi_getcurrentplayer() ,  selected_item +1 )) + Chr(10) +  Item_getGuiText( spi_inventar_getItem(spi_getcurrentplayer() ,  selected_item +1 ) ) )
            
         ; wenn nicht im inventarfeld    -> images hiden.
         Else 
            anz_hideimage                ( Gui_Image_Inventar_Itemback_Pressed   , 1 )
            anz_hideimage                ( Gui_Image_Inventar_Itemback_Selected  , 1 )
            selected_item_last           = -1 ; wird wieder -1, damit ma nicht wieder das gleiche markiert und dann oben nichts passiert.
         EndIf 
         ;}
         
            ;{ Sack wechseln und Ausrüstslots 
         
         If anz_mouseinbox  ( gui_inventar_Sackpos1x +gui_X, gui_inventar_Sackposy + gui_Y , gui_inventar_Sackbreite , gui_inventar_Sackhohe )  ; Sack1
            ; gui_current_Gadget           = gui_image_ ; müssen noch geladen werden: die inventar-buttons etc.
            sack_image_status1             = 1
            If anz_mousebutton             ( 1 , #anz_MouseEvent_tipped  ) And spi_inventar_IsSackActive( spi_getcurrentplayer () , 1 ); wenn draufgeklickt wurde
               gui_current_Sack            = 1
               gui_UpdateInventarView      ()
               sack_image_status1          = 2
            EndIf 
            ; wenn man grad am Verschieben ist.. 
            If anz_mousebutton             ( 1 , #anz_MouseEvent_pressed ) 
               sack_image_status1          = 2
               If  IsVerschieben           > 0
                   gui_current_Sack        = 1
                   gui_UpdateInventarView  ( *verschieben_item)
               EndIf 
            EndIf 
            
            ; sackbilder anzeigen           (selected pressed etc)
            If sack_image_status1           = 1   ; sack ist only selected 
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected1   , 0 )
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed1    , 1 )
            ElseIf sack_image_status1       = 2   ; sack is pressed aswell.
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected1   , 1 )
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed1    , 0 )
            EndIf 
         ElseIf anz_mouseinbox ( gui_inventar_sackpos2x +gui_X, gui_inventar_Sackposy + gui_Y , gui_inventar_Sackbreite , gui_inventar_Sackhohe )  ; Sack2
            sack_image_status2            = 1
            If anz_mousebutton            ( 1 , #anz_MouseEvent_tipped) And spi_inventar_IsSackActive( spi_getcurrentplayer () , 2 ) ; wenn draufgeklickt wurde
               gui_current_Sack           = 2
               sack_image_status2         = 2
               gui_UpdateInventarView     ()
            EndIf 
            ; wenn man grad am Verschieben ist.. 
            If anz_mousebutton             ( 1 , #anz_MouseEvent_pressed ) 
               sack_image_status2          = 2 
               If  IsVerschieben           > 0
                  gui_current_Sack         = 2
                  gui_UpdateInventarView   ( *verschieben_item)
               EndIf 
            EndIf 
            ; sackbilder anzeigen (selected pressed etc)
            If sack_image_status2           = 1 ; sack ist only selected 
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected2   , 0 )
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed2    , 1 )
            ElseIf sack_image_status2       = 2  ; sack is pressed aswell.
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected2   , 1 )
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed2    , 0 )
            EndIf 
         ElseIf anz_mouseinbox  ( gui_inventar_sackpos3x +gui_X, gui_inventar_Sackposy + gui_Y , gui_inventar_Sackbreite , gui_inventar_Sackhohe )  ; Sack3 
            sack_image_status3            = 1
            If anz_mousebutton            ( 1 , #anz_MouseEvent_tipped) And spi_inventar_IsSackActive( spi_getcurrentplayer () , 3 ) ; wenn draufgeklickt wurde
               gui_current_Sack           = 3
               sack_image_status3         = 2
               gui_UpdateInventarView     ()
            EndIf 
            ; wenn man grad am            Verschieben ist.. 
            If anz_mousebutton            ( 1 , #anz_MouseEvent_pressed ) 
               sack_image_status3         = 2
               If IsVerschieben           > 0
                  gui_current_Sack        = 3
                  gui_UpdateInventarView  ( *verschieben_item)
               EndIf 
            EndIf 
            ; sackbilder anzeigen           ( selected pressed etc)
            If sack_image_status3           = 1 ; sack ist only selected 
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected3   , 0 )
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed3    , 1 )
            ElseIf sack_image_status3       = 2 ; sack is pressed aswell.
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected3   , 1 )
               anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed3    , 0 )
            EndIf 
         ElseIf anz_mouseinbox  ( gui_inventar_Ausrust_Waffe_RHX+gui_X , gui_inventar_Ausrust_Waffe_Y + gui_Y , gui_inventar_Ausrust_Waffe_Width , gui_inventar_Ausrust_Waffe_height ) ; Ausrüstslot rechte hand 
           ;}
           
            ;{ Rechte Hand -> Schwert ausrüsten..
            If anz_mousebutton                   ( 1 ,  #anz_MouseEvent_released ) > 0 ; wenn maus released
                If IsVerschieben                 = 2                                   ; 
                    If *verschieben_item         > 0
                        *verschieben_item_waffe  = *verschieben_item\WaffenID 
                        If *verschieben_item_waffe > 0
                           If *verschieben_item_waffe\Waffenart = #item_waffe_fernkampf Or *verschieben_item_waffe\Waffenart = #item_waffe_zauber Or *verschieben_item_waffe\Waffenart = #item_waffe_nahkampf 
                              ; altes Schwert rauswerfen aus dem SLOT
                              *altesschwert         = spi_getspielerSchwert  ( spi_getcurrentplayer())
                              If *altesschwert     
                                 *altesschwert_waffe= *altesschwert\WaffenID 
                                 anz_hideimage      ( *altesschwert_waffe\gui_InventarBigImage   , 1 )
                              EndIf 
                              ; Neues Schwert rein in den Slot.
                              spi_setspielerschwert  ( spi_getcurrentplayer() , *verschieben_item )
                              anz_hideimage          ( *verschieben_item_waffe\gui_InventarBigImage ,0 )
                              anz_setimagepos        ( *verschieben_item_waffe\gui_InventarBigImage , gui_X + gui_inventar_Ausrust_Waffe_RHX , gui_Y + gui_inventar_Ausrust_Waffe_Y  )
                           EndIf 
                        EndIf 
                        gui_UpdateInventarView    ()
                    EndIf 
                    IsVerschieben                 = 0
                EndIf 
             ElseIf anz_mousebutton               ( 2 , #anz_MouseEvent_tipped )
                 *altesschwert                    = spi_getspielerSchwert  ( spi_getcurrentplayer() )
                 If *altesschwert
                    *altesschwert_waffe           = *altesschwert\WaffenID 
                    spi_setspielerschwert         ( spi_getcurrentplayer() , 0 )
                    anz_hideimage                 ( *altesschwert_waffe\gui_InventarBigImage , 1 )
                 EndIf 
             EndIf 
             
            ;}
            
         ElseIf anz_mouseinbox ( gui_inventar_Ausrust_Waffe_LHX+gui_X , gui_inventar_Ausrust_Waffe_Y+ gui_Y  , gui_inventar_Ausrust_Waffe_Width , gui_inventar_Ausrust_Waffe_height ) ; ausrüstslot linke Hand
            
             ; derzeit keine 2. Waffen verfügbar.. später evtl auch nur Schild.
             gui_UpdateInventarView()
             
         ElseIf anz_mouseinbox ( gui_inventar_ausrust_Rustung_X + gui_X , gui_inventar_Ausrust_Rustung_Y + gui_Y , gui_inventar_Ausrust_Rustung_Width , gui_inventar_Ausrust_Rustung_Height ); Ausrüstslot Rüstung
             
             ;{ Slot ausrüsten..
            If anz_mousebutton                    ( 1 ,  #anz_MouseEvent_released ) > 0 ; wenn maus released
                If IsVerschieben                  = 2
                    If *verschieben_item          > 0 
                        If *verschieben_item\WaffenID > 0
                           *verschieben_item_waffe   = *verschieben_item\WaffenID 
                           If *verschieben_item_waffe\Waffenart  = #item_waffe_rustung
                              ; alte Rüstung rauswerfen aus dem SLOT
                              *alterustung           = spi_GetSpielerRustung  ( spi_getcurrentplayer())
                              If *alterustung 
                                 *alterustung_waffe  = *alterustung\WaffenID 
                                 anz_hideimage       ( *alterustung_waffe\gui_InventarBigImage     , 1 )
                              EndIf 
                              ; Neue Rüstung rein in den Slot.
                              spi_setSpielerRustung  ( spi_getcurrentplayer() , *verschieben_item   )
                              anz_hideimage          ( *verschieben_item_waffe\gui_InventarBigImage ,0 )
                              anz_setimagepos        ( *verschieben_item_waffe\gui_InventarBigImage , gui_X + gui_inventar_ausrust_Rustung_X , gui_Y + gui_inventar_Ausrust_Rustung_Y  )
                           EndIf 
                        EndIf 
                        gui_UpdateInventarView ()
                        
                    EndIf 
                    IsVerschieben                 = 0
                EndIf 
             ElseIf anz_mousebutton               ( 2 , #anz_MouseEvent_tipped )
                 *alterustung                    = spi_GetSpielerRustung   ( spi_getcurrentplayer() )
                 If *alterustung
                    *alterustung_waffe           = *alterustung\WaffenID 
                    spi_setSpielerRustung         ( spi_getcurrentplayer() , 0 )
                    anz_hideimage                 ( *alterustung_waffe\gui_InventarBigImage , 1 )
                 EndIf 
             EndIf 
             ;}
             
         ElseIf anz_mouseinbox ( Gui_inventar_Schnellrust_x , Gui_Inventar_Schnellrust_y ,  Gui_Inventar_Schnellrust_SlotBreite * Gui_Inventar_Schnellrust_Slotcount , Gui_Inventar_Schnellrust_SlotHohe * Gui_Inventar_Schnellrust_Slotcount )
            
            ;{ Schnellrust-buttons per drag/drop setzen
             If anz_mousebutton                ( 1 ,  #anz_MouseEvent_released ) > 0 ; wenn maus released
                If IsVerschieben               = 2
                    Gui_SetSchnellWahlItem     ( gui_GetSelectedSchnellwahlItem() , *verschieben_item )
                    gui_UpdateInventarView     ( )
                    IsVerschieben              = 0
                EndIf 
             ElseIf anz_mousebutton            ( 2 , #anz_MouseEvent_no ) <> 1 ; wenn irgendwie rechts geklickt wird
                Gui_SetSchnellWahlItem         ( gui_GetSelectedSchnellwahlItem () , 0 )
             ElseIf anz_mousebutton            ( 1 , #anz_MouseEvent_tipped ) > 0 ; maus drückt drauf 
             
             EndIf 
            ;}
            
         ElseIf anz_mouseinbox ( gui_inventar_Spielerboxx , gui_inventar_Spielerboxy , gui_inventar_Spielerboxbreite , gui_inventar_Spielerboxhohe )
            
            ;{ Items benutzen bei drag/drop in spielerfeld.
              If anz_mousebutton               ( 1 ,  #anz_MouseEvent_released ) > 0 ; wenn maus released
                If IsVerschieben               = 2
                    spi_inventar_UseItem       ( spi_getcurrentplayer() , *verschieben_item ) ; item benutzen -> wenn leer -> wirds gelöscht.
                    gui_UpdateInventarView     ()
                    IsVerschieben              = 0
                EndIf 
             EndIf
           
           ;}
           
         ElseIf Not ( anz_mouseinbox ( gui_inventar_Field_X1+gui_X , gui_inventar_field_Y1+gui_Y , gui_inventar_field_width1 , anz_getscreenheight() ) Or anz_mouseinbox( gui_inventar_Field_X2 +gui_X , gui_inventar_field_Y2+gui_Y , gui_inventar_field_width2 , anz_getscreenheight() ))
          
            ;{ Item Droppen, 
            ; Items können aber nicht unten rausgeworfen werden (wegen der schnellbefehlsleiste)
            If anz_mousebutton                 ( 1 ,  #anz_MouseEvent_released ) > 0 ; wenn maus released
                If IsVerschieben               = 2
                    ;hiden der Item images
                    anz_hideimage              ( *verschieben_item\gui_InventarImage , 1 )
                    If *verschieben_item\WaffenID > 0
                       *verschieben_item_waffe = *verschieben_item\WaffenID 
                       anz_hideimage           ( *verschieben_item_waffe\gui_InventarBigImage ,1)
                    EndIf 
                    ; Rauswerfen der Item images.
                    spi_inventar_removeItem    ( spi_getcurrentplayer() , spi_inventar_getItem( spi_getcurrentplayer() ,  Verschieben_Item +1))
                    gui_UpdateInventarView     ()
                    IsVerschieben              = 0
                EndIf 
             EndIf
             ;}
         
         EndIf 
         
         ;{ Verschieben anzeigen
             If IsVerschieben            = 1 
                verschieben_startx       + Abs(anz_MouseDeltaX())
                verschieben_starty       + Abs(anz_MouseDeltaY())
                
                If verschieben_startx    + verschieben_starty > 5 ; sobald maus zu sehr bewegt:
                   IsVerschieben         = 2                      ; verschieben starten.
                EndIf 
                
             ElseIf IsVerschieben        = 2 ; Zu verschiebenes Item hinter Mauszeiger bewegen!
                anz_setimagepos          ( *verschieben_item\gui_InventarImage , anz_mousex () - verschieben_mousex  , anz_mousey () - verschieben_mousey)
                
                If anz_mousebutton       ( 1 , #anz_MouseEvent_no) ; wenn die maus überhaupt nicht gedrückt /losgelassen wird..
                   IsVerschieben         = 0
                   gui_UpdateInventarView()
                EndIf 
             EndIf 
             
           ;}
         
         ;{ Sack Background anzeigen
         If sack_image_status1 = 0
            anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected1   , 1 )
            anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed1    , 1 )
         EndIf 
         If sack_image_status2 = 0
            anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected2   , 1 )
            anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed2    , 1 )
         EndIf 
         If sack_image_status3 = 0
            anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected3   , 1 )
            anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed3    , 1 )
         EndIf 
         ;}
         
         ;{ Verschieben abbrechen (rechtsklicke)
           
           If IsVerschieben            = 2
             If anz_mousebutton        ( 2 , #anz_MouseEvent_no ) <= 0 ; wenn rechts irgendwie geklickt wird:
                IsVerschieben          = 0
                gui_UpdateInventarView ()
             EndIf 
          EndIf 
         ;}
         
         ; -------------------------------------------------------------------------------------------------
         ; --- PAUSE -----------
         ; -------------------------------------------------------------------------------------------------
         ; Evtl das ganze untere GUI ändern -> wie diablo III (zumindest mit den Maus-belegungsmöglichkeit und tasten 1-9 und 0 lösen direkt das item aus.
         
      EndIf 
      
   EndProcedure 
   
   Procedure Gui_GetSelectedInventarItem() ; returns ID of the Inventaritem currently selected by the mouse.
      Protected ItemX, ItemY , Itemnr 
      
      ItemX     = Round(( anz_mousex() - gui_X - gui_inventar_FirstSlotX ) / gui_inventar_Slotbreite  , 0) ; abrunden! beginnt bei Reihe 0
      ItemY     = Round(( anz_mousey() - gui_Y - gui_inventar_FirstSloty ) / gui_inventar_Slothohe ,0)     ; abrunden! beginnt bei spalte 0
      Itemnr    = ItemY * gui_inventar_SlotCountX + ItemX + (gui_inventar_SlotCountY * gui_inventar_SlotCountX) * (gui_current_Sack -1)
      If Itemnr > 400 : Itemnr = 400 : EndIf 
      If Itemnr < 0   : Itemnr = 0   : EndIf 
      
      ProcedureReturn Itemnr 
   
   EndProcedure 
   
   Procedure gui_UpdateInventarView (*ExceptionItemID.i = 0)  ; updated die aktuell sichtbaren ITEMS, z.B. wenn der Sack gewechselt wurde.  ; exception= item, das nicht ausgeblendet wird (das gerade verschoben wird)
      Protected *SpielerID.spi_spieler , *inventarID.spi_inventar , Itemnr = 1 , *item.ITEM , *waffe.item_waffe 
      
      *SpielerID  = spi_getcurrentplayer ()
      *inventarID = *SpielerID\InventarID 
      
      ; Hide all items first
      For x = 0 To 400
         *item          = *inventarID\itemID[x]
         If *item 
            anz_hideimage  ( *item\gui_InventarImage , 1 ) ; verstecken der ganzen Items fürs spätere anzeigen
         EndIf 
         If *item = *ExceptionItemID And Not *ExceptionItemID = 0
            anz_hideimage  ( *item\gui_InventarImage , 0 ) ; anzeigen des items, das angezeigt bleiben soll.
         EndIf 
      Next 
      
      ; gui_current_Sack = aktueller sack..
      If gui_current_Status & #gui_Status_Inventar = #gui_Status_Inventar ; wenn inventar offen ist; ansonsten solln alle items gehidden bleiben.
         For y = 0 To 10  ; also 11 Zeilen
         For x = 0 To 8  ; also 9 Reihen
         
               *item             = *inventarID\itemID [Itemnr + (gui_current_Sack-1) * 99] ; also bei Sack 2 beginnt Anzeige bei Item 99!! hehe
               If *item 
                  If *item       \gui_InventarImage = 0 : CallDebugger : EndIf 
                  anz_setimagepos( *item\gui_InventarImage , gui_X + gui_inventar_FirstSlotX + x * gui_inventar_Slotbreite , gui_Y + gui_inventar_FirstSloty + y * gui_inventar_Slothohe )
                  anz_hideimage  ( *item\gui_InventarImage , 0 ) ; anzeigen der ganzen Items 
               EndIf 
               
               ; Ausrüstslot-items anzeigen.
               If *item          = spi_GetSpielerRustung( spi_getcurrentplayer()) And *item > 0
                  ; rüstung
                  *waffe         = *item\WaffenID 
                  anz_setimagepos( *waffe\gui_InventarBigImage , gui_X + gui_inventar_ausrust_Rustung_X , gui_Y + gui_inventar_Ausrust_Rustung_Y )
                  anz_hideimage  ( *waffe\gui_InventarBigImage , 0 ) ; anzeigen der ganzen Items 
               ElseIf *item      = spi_getspielerSchwert( spi_getcurrentplayer()) And *item > 0
                  ; schwert 
                  *waffe         = *item\WaffenID 
                  anz_setimagepos( *waffe\gui_InventarBigImage , gui_X + gui_inventar_Ausrust_Waffe_RHX , gui_Y + gui_inventar_Ausrust_Waffe_Y  )
                  anz_hideimage  ( *waffe\gui_InventarBigImage , 0 ) ; anzeigen der ganzen Items 
               EndIf 
               
               Itemnr            + 1 
            Next 
         Next 

      anz_setImageForeground     ( Gui_Image_Mouse )
      
     Else ; die Ausrüstslot-items hiden!
     
        For x = 0 To 400
           *item          = *inventarID\itemID[x]
            If *item 
               *waffe = *item\WaffenID 
               If *waffe 
                  anz_hideimage  ( *waffe\gui_InventarBigImage , 1 ) ; verstecken der ganzen Items fürs spätere anzeigen
               EndIf 
            EndIf 
         Next 
         
         ; die Sackbacks hiden!
         anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected1   , 1 )
         anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed1    , 1 )
         anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected2   , 1 )
         anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed2    , 1 )
         anz_hideimage                ( Gui_Image_Inventar_Sackback_Selected3   , 1 )
         anz_hideimage                ( Gui_Image_Inventar_Sackback_Pressed3    , 1 )
         
         ; die quickhelp hiden:
         gui_showQuickHelp            ( 0 , 0 , "" )
     EndIf
     
   EndProcedure 
   
   Procedure gui_IsInventarOpen()
      If gui_current_Status & #gui_Status_questlog 
         ProcedureReturn 1
      EndIf 
   EndProcedure 
   
   Procedure gui_LoadImages() ; praktisch INIT inventar.. ohne den befehl geht hier gar nichts!
   
      gui_X                = anz_getscreenwidth () / 2 - 1024/2  ; bei 1024 *768 = 0, also kein einrücken der Gui elemente.
      gui_Y                = anz_getscreenheight() / 2 - 768/2   
      Gui_Image_HUD        = anz_loadimage ( -1 , gui_X , anz_getscreenheight()-768  , "GFX\HUD.png"      ,  1 , 1) ; spezialfall: HUD muss immer ganz unten sein.
      Gui_Image_HUD_XP     = anz_loadimage ( -1 , 0     , anz_getscreenheight() - 260,  "GFX\EP balken.png" , 1 , 0 )
      Gui_Image_Inventar   = anz_loadimage ( -1 , gui_X , gui_Y , "GFX\inventar.png" ,  1 , 1)
      Gui_Image_Questlog   = anz_loadimage ( -1 , gui_X , gui_Y , "GFX\Questlog.png" ,  1 , 1)
      Gui_Image_Map        = anz_loadimage ( -1 , gui_X , gui_Y , "GFX\BigMap.png"   ,  1 , 1)
      gui_image_inventar_itemback_normal   = anz_loadimage ( -1 , gui_X , gui_Y , "GFX\Itemback_normal.png"   ,  1 , 1)
      Gui_Image_Inventar_Itemback_Selected = anz_loadimage ( -1 , gui_X , gui_Y , "GFX\Itemback_selected.png"   ,  1 , 1)
      Gui_Image_Inventar_Itemback_Pressed  = anz_loadimage ( -1 , gui_X , gui_Y , "GFX\Itemback_pressed.png"   ,  1 , 1)
      Gui_Image_Mouse      = anz_loadimage ( #anz_image_mouse   , gui_X , gui_Y , "GFX\Mouse.png"    ,  1 , 1)
      Gui_Image_Inventar_Sackback_Selected1 = anz_loadimage ( -1 , gui_inventar_Sackpos1x +gui_X, gui_inventar_Sackposy +gui_Y, "GFX\Inventar_sack_selected.jpg"   ,  1 , 1)
      Gui_Image_Inventar_Sackback_Pressed1  = anz_loadimage ( -1 , gui_inventar_Sackpos1x +gui_X, gui_inventar_Sackposy +gui_Y, "GFX\inventar_sack_pressed.jpg"    ,  1 , 1)
      Gui_Image_Inventar_Sackback_Selected2 = anz_loadimage ( -1 , gui_inventar_sackpos2x +gui_X, gui_inventar_Sackposy +gui_Y, "GFX\Inventar_sack_selected.jpg"   ,  1 , 1)
      Gui_Image_Inventar_Sackback_Pressed2  = anz_loadimage ( -1 , gui_inventar_sackpos2x +gui_X, gui_inventar_Sackposy +gui_Y, "GFX\inventar_sack_pressed.jpg"    ,  1 , 1)
      Gui_Image_Inventar_Sackback_Selected3 = anz_loadimage ( -1 , gui_inventar_sackpos3x +gui_X, gui_inventar_Sackposy +gui_Y, "GFX\Inventar_sack_selected.jpg"   ,  1 , 1)
      Gui_Image_Inventar_Sackback_Pressed3  = anz_loadimage ( -1 , gui_inventar_sackpos3x +gui_X, gui_inventar_Sackposy +gui_Y, "GFX\inventar_sack_pressed.jpg"    ,  1 , 1)
      
   EndProcedure 
   
   Procedure Gui_openInventar( Open.i ) ; of open = 0: close it; CLOSE only hides the image!!
      
      If Open 
         gui_current_Status     | #gui_Status_Inventar 
         Gui_inventar_Schnellrust_x = gui_X + 226
         Gui_Inventar_Schnellrust_y = anz_getscreenheight() - 51 
         If Gui_Image_Inventar  = 0 
            Gui_Image_Inventar  = anz_loadimage              ( -1 , 0 , 0 , "..\..\inventar.png" ,  1 , 0)
         Else  
            anz_hideimage       ( Gui_Image_Inventar, 0)
         EndIf
         gui_UpdateInventarView ()
      Else
         gui_current_Status     & ~#gui_Status_Inventar
         anz_hideimage          ( Gui_Image_Inventar, 1 )
         gui_UpdateInventarView ()
      EndIf 
      
   EndProcedure
   
   Procedure gui_setGUI ( GuiStatus.i = 600 ) ; guistatus = gui_Status_inventar z.b.
      Protected anschalten.i 
      
      Select GuiStatus 
      
          Case #gui_Status_Inventar 
                If gui_current_Status & #gui_Status_Inventar = #gui_Status_Inventar 
                   anschalten = 0
                Else 
                   anschalten = 1 
                EndIf 
                gui_closeAll     ( #gui_Status_Inventar | #Gui_Status_HUD )
                Gui_openInventar ( anschalten )
          Case #gui_Status_questlog
                If gui_current_Status & #gui_Status_questlog = #gui_Status_questlog 
                   anschalten = 0
                Else 
                   anschalten = 1 
                EndIf 
                gui_closeAll     ( #gui_Status_questlog | #Gui_Status_HUD )
                gui_openQuestlog ( anschalten ) 
          Case #gui_Status_None  ; für's outofgame-menü, da soll kein HUD oder sonstiges angezeigt werden. 
                gui_closeAll     ( 1 )
          Case #Gui_Status_HUD
                If gui_current_Status & #Gui_Status_HUD = #Gui_Status_HUD 
                   anschalten = 0
                Else 
                   anschalten = 1 
                EndIf 
                gui_closeAll     (  #Gui_Status_HUD )
                gui_openHUD      ( anschalten )
          Case #Gui_Status_Map
                If gui_current_Status & #Gui_Status_Map = #Gui_Status_Map 
                   anschalten = 0
                Else 
                   anschalten = 1 
                EndIf 
                gui_closeAll     ( #Gui_Status_Map | #Gui_Status_HUD )
                gui_open_Map     ( anschalten )
      EndSelect 
      
   EndProcedure 
   
   Procedure gui_getGUI ( )
      ProcedureReturn gui_current_Status 
   EndProcedure 
   
   Procedure gui_openQuestlog( Status ) ; nur wenn status = 0 wird questlog geschlossen.
      
      If gui_current_Status & #gui_Status_questlog = #gui_Status_questlog  And Status = 0 ; wenn das questlog aktiviertwar und es ausgeschaltet wird
         gui_current_Status & ~ #gui_Status_questlog 
      ElseIf Not gui_current_Status & #gui_Status_questlog = #gui_Status_questlog  And Status = 1; einschalten
         gui_current_Status | #gui_Status_questlog 
      EndIf 
      
      If Status = 0 : Status = 1 : Else : Status = 0 : EndIf 
      anz_hideimage ( Gui_Image_Questlog , Status )
      
   EndProcedure 
   
   Procedure gui_openHUD(Status)
      If gui_current_Status & #Gui_Status_HUD = #Gui_Status_HUD And Status = 0 ; wenn das questlog aktiviertwar und es ausgeschaltet wird
         gui_current_Status & ~ #Gui_Status_HUD 
      ElseIf Not gui_current_Status & #Gui_Status_HUD = #Gui_Status_HUD And Status = 1; einschalten
         gui_current_Status | #Gui_Status_HUD 
      EndIf 
      
      If Status = 0 : Status = 1 : Else : Status = 0 : EndIf 
      anz_hideimage ( Gui_Image_HUD  , Status )
      anz_hideimage ( Gui_Image_HUD_XP , Status )
   EndProcedure 
   
   Procedure gui_open_Map(Status)
      If gui_current_Status & #Gui_Status_Map = #Gui_Status_Map  And Status = 0 ; wenn das questlog aktiviertwar und es ausgeschaltet wird
         gui_current_Status & ~ #Gui_Status_Map 
      ElseIf Not gui_current_Status & #Gui_Status_Map = #Gui_Status_Map And Status = 1; einschalten
         gui_current_Status | #Gui_Status_Map 
      EndIf 
      
      If Status = 0 : Status = 1 : Else : Status = 0 : EndIf 
      anz_hideimage ( Gui_Image_Map  , Status )
   EndProcedure 
   
   Procedure gui_closeAll ( Exception.i = 0) ; the exception will not be closed ;) (z.B. #gui_Status_HUD | #gui_status_map !
      
      gui_openQuestlog ( #gui_Status_questlog & Exception  ) ; wenn das Bit bei Exception gesetzt ist (z.B. $00000001 & $00000001 ergibt 1, also NICHT null!) dann bleibt guielement da.
      gui_openHUD      ( #Gui_Status_HUD      & Exception  ) 
      gui_open_Map     ( #Gui_Status_Map      & Exception  ) 
      Gui_openInventar ( #gui_Status_Inventar & Exception  )
      
   EndProcedure  
; jaPBe Version=3.9.12.818
; FoldLines=0002000D000F00270016000000290038003A003C003E004700490051006A00B3
; FoldLines=00B500FF01010121012A014A015E0167016B017B017F0191019301A001B501C0
; FoldLines=01C2020A020C0210021202260228023A023C026502670269026B027602780282
; FoldLines=0284028D028F0296
; Build=0
; FirstLine=36
; CursorPosition=339
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF