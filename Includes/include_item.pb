; -----------------------------------------------------------------------------------------------------
; --- Procedures --------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------

; add / Delete stuff

Procedure Item_AddWaffe ( *itemID.ITEM , angriff , Reichweite, Waffenart, gui_inventar_BigImage_pfad.s )
   If AddElement( item_waffe())
      *itemID\WaffenID = item_waffe  ()
      item_waffe       ()\ angriff    = angriff 
      item_waffe       ()\ Reichweite = Reichweite
      item_waffe       ()\ Waffenart  = Waffenart 
      item_waffe       ()\gui_InventarBigImage = anz_loadimage( -1 , 0 , 0 , gui_inventar_BigImage_pfad , 1 , 1 )
      ProcedureReturn  item_waffe()
   EndIf 
EndProcedure 

Procedure Item_Add (name$, x.f , y.f , z.f , goldwert , ItemArt.w , Betrag.w , Gewicht.f , pfad.s , texture1.s , texture2.s , MaterialType.i , gui_inventar_image_pfad.s ,GuiText.s ) ; betrag = z.b. lebensbonus, ; inventarimage = gui_inventar_image_
  Protected *anz_mesh.anz_mesh , *itemID.ITEM 
  
  *itemID = AddElement( item()) ; deswegen pointer, damit bei evtl multithreading kein Fehler.
  
  If *itemID 
     *itemID            \name          = name$
     *itemID            \GuiText       = GuiText
     *itemID            \price         = goldwert
     *itemID            \Gewicht       = Gewicht
     *itemID            \is_Visible    = 1
     *itemID            \Betrag        = Betrag 
     *itemID            \art           = ItemArt   ; siehe #item_art_..)
     *itemID            \gui_InventarImage = anz_loadimage( -1 , 0 , 0 , gui_inventar_image_pfad , 1 , 1 )
     *itemID            \gui_InventarImage_pfad = gui_inventar_image_pfad 
     *itemID            \anz_Mesh_ID   = anz_addmesh     ( pfad , x , y,  z , texture1 , MaterialType , texture2 , 0 , 0 ,  #anz_col_box , #anz_ColType_movable ) ; bei collision fällt das ding immer durch'n boden..???.. evtl später eigene  collision einbauen.
     *anz_mesh          =  *itemID     \anz_Mesh_ID 
     *anz_mesh          \itemID        = *itemID

     ;{ Alle wichtigen Daten von anz_mesh sammeln. für späteres Dropitem.
   
     *itemID           \Anz_mesh_struct\pfad       = pfad
     *itemID           \Anz_mesh_struct\x          = x
     *itemID           \Anz_mesh_struct\y          = y
     *itemID           \Anz_mesh_struct\z          = z
     *itemID           \Anz_mesh_struct\texture    = texture1 
     *itemID           \Anz_mesh_struct\MaterialType = MaterialType 
     *itemID           \Anz_mesh_struct\normalmap    = texture2
     
     ;}
     
     ProcedureReturn *itemID
  EndIf 
  
EndProcedure

Procedure Item_AddDefined ( name.s , x.f,y.f,z.f , DefinedItemNR.i )  ; erstellt ein vordeffiniertes Item (wichtig, wenn viele Items gleich sind.
   Protected *anz_mesh.anz_mesh 
   
	If AddElement( item())
      d = DefinedItemNR 

      If item_predefined(d)\exist 
         item           () \name        = item_predefined(d)\name 
         item           () \GuiText     = item_predefined(d)\GuiText 
         item           () \price       = item_predefined(d)\price 
         item           () \Gewicht     = item_predefined(d)\Gewicht 
         item           () \art         = item_predefined(d)\art 
         item           () \gui_InventarImage = anz_loadimage ( -1 , 0 , 0 , item_predefined(d)\gui_InventarImage_pfad , 1 , 1 )
         item           () \gui_InventarImage_pfad = item_predefined(d)\gui_InventarImage_pfad
         item           () \is_Visible  = 1
         item           () \Betrag      = item_predefined(d)\Betrag 
         item           () \anz_Mesh_ID = anz_addmesh     ( item_predefined(d)\pfad , x , y,  z , item_predefined(d)\texture1 , item_predefined(d)\MaterialType , item_predefined(d)\texture2 , 0 , 0 , #anz_col_box , #anz_ColType_movable ) 
         *anz_mesh       =  item        ()\anz_Mesh_ID 
         *anz_mesh       \itemID        = item()
         
         If item_predefined (d)\angriff > 0 ; --> = waffe!
            Item_AddWaffe   ( item () , item_predefined(d)\angriff , item_predefined(d)\Reichweite , item_predefined(d)\Waffenart , item_predefined(d)\gui_InventarBigImage_pfad  )
         EndIf 
         
         ProcedureReturn item()
      EndIf 
   
   EndIf 
   
EndProcedure 

Procedure Item_Delete(*itemID.ITEM)
   If *itemID > 0
      If *itemID \ WaffenID > 0
         ChangeCurrentElement(item_waffe(), *itemID\WaffenID )
         anz_freeimage       (item_waffe()\gui_InventarBigImage)
         DeleteElement       (item_waffe())
      EndIf 
      anz_delete_object3d ( anz_getobject3dByAnzID( *itemID\anz_Mesh_ID ))
      anz_freeimage       ( *itemID\gui_InventarImage )
      DeleteElement       ( item() , *itemID )
   EndIf 
EndProcedure

; focus item

Procedure Item_getFocusItem()   ; gibt das Item, das direkt vor dem Spieler liegt zurück ( also die ItemID)
   ProcedureReturn item_FocusItem
EndProcedure 

Procedure Item_FocusItem_Reset ()  ; überprüft das Fokus-Item
   Protected x.f, y.f , z.f , SpielerRoty.f , spieler_item_dist.f , dist.f , itemID.i , OldFocusItem.i , divisioncorrectur.i
   Protected px.f , py.f , pz.f , pix.f , piy.f ,piz.f , ItemWinkel.f , Xdist.f , smallest_Fi.f = 50 ; smallest fi muss schon maximal sein (> 45 °)
   
   OldFocusItem     = item_FocusItem 
   item_FocusItem   = 0
   
   Item_Examine_Reset(1 , #anz_meter * 3) ; alle umliegenden Items überprüfen

      While Item_examine_Next()
         
         If Not anz_getobject3dIsGeladen( anz_getobject3dByAnzID( item_examine_GetAnzID() ,#anz_art_mesh ) ) ; natürlich muss item geladen sein ;)
            Continue 
         EndIf 
         
         E3D_getNoderotation        ( spi_GetPlayerNode( spi_getcurrentplayer() ) ,@x   , @SpielerRoty, @z ) ; spielernode rotation
         E3D_getNodePosition        ( spi_GetPlayerNode( spi_getcurrentplayer() ) ,@px  , @py  , @pz )  ; spielernode position 
         E3D_getNodePosition        ( item_examine_GetIrrNode( )                  ,@pix , @piy , @piz ) ; item position.. in dem fall absolute, weils um abstand item/spieler geht.
         SpielerRoty                = math_FixFi( - SpielerRoty ) ; spielerroty wird umgedreht ( also - spielerroty) weil spieler ja immer zu items schaun soll.
         
         If math_distance3d         ( px,py,pz,pix,piy,piz) < #meter*1.7 ; wenn der abstand von item zu spieler kleiner 1.7 m ist .. ;math_square_distance2d  ( 0 , pz , 0 , piz )     < #meter * 2 And math_square_distance2d( 0 , pz , 0 , piz) > - 1.3* #meter  ; Item darf max. 2m über und 1m unterhalb von spieler sein.
         
             ; Suchen aller im Winkel liegenden Items        ( berechnen des item- und spieler drehwinkels)   
             ; Xdist                  = math_square_distance2d ( px , 0 , pix , 0 ) ; nur der X - Abstand zwischen den beiden Nodes
             ; Ydist                  = math_square_distance2d ( py , 0 , piy , 0 ) ; nur der y - Abstand zwischen den beiden Nodes
             Xdist                  = math_distance3d        ( px , pz , 0 , pix , piz , 0 ) ; Xdist = b des cosinussatzes.
             ; dist                   = math_distance3d        ( px , pz , 0 , pix , piz , 0 ) ; nur die 2D - distance. sonst rechung = falsch.
             dist                   = #meter                 ; beliebigen wert= länge von c 
             Ydist                  = math_distance3d        ( pix , piz , 0 , dist + px , pz , 0) 
             
             If Round( 2* Xdist * dist,0) = 0 : divisioncorrectur = 1 : Else : divisioncorrectur = 0 : EndIf   ; kontrolle, damits nicht division durch null wird.
             ItemWinkel             = math_RadToFi           ( ACos((-(Ydist*Ydist) + (Xdist*Xdist) + (dist*dist)) / ( divisioncorrectur+ 2*Xdist * dist ))) ; cos alpha = -a²+b²+c²/(2*b*c)
             If ItemWinkel >= 2147483648  Or ItemWinkel =< -2147483648   ; wenn leere menge rauskommt, bei acos (was nur bei 180 und 360° der fall ist) 
                If px > pix 
                   ItemWinkel = 180
                Else 
                  ItemWinkel = 360
                EndIf 
             EndIf 
             
             If pz > piz 
                ItemWinkel = math_FixFi( 360 - ItemWinkel  )
             EndIf 
             ; Ob Item In Sichtwinkel - Kontrolle
             If math_IsFiInBereich( ItemWinkel , SpielerRoty-45 , SpielerRoty + 45); ItemWinkel         > SpielerRoty - 45  And ItemWinkel < SpielerRoty + 45 ; wenn der Itemwinkel im Bereich des Spielerwinkels liegt.
                ; herausfinden des am nächsten liegenden Items (nur vom Winkel her!!)
                If math_betrag     ( ItemWinkel- SpielerRoty ) < smallest_Fi 
                   smallest_Fi     = math_betrag     ( ItemWinkel- SpielerRoty )
                   smallest_itemID = item_examine_GetItemID()
                EndIf 
          
             EndIf 
          
          EndIf 
          
      Wend 
   
   
   ; Item als Selektiert setzen.
   
   item_FocusItem = smallest_itemID 
   
   ProcedureReturn item_FocusItem

EndProcedure 

; examine stuff

Procedure Item_Examine_Reset( only_they_in_view.i = 1 , max_distance.f = 3*#meter  ) ; Überprüft, ob Nodes in der Nähe sind (bzw. alle nodes überhaupt z.b. zum material setzen)
     Protected x.i,y.i,z.i,x1.f , y1.f , z1.f ,  *p_obj.anz_Object3d , ObjectArt.w, px.f, py.f, pz.f , irr_obj.i , rasterx.i , rastery.i , rasterz.i , *anz_mesh.anz_mesh    ; wenn OnlyItems1_OnlyWesen2 = 1, dann nur items suchen, wenn =2, dann nur wesen.
      
      ClearList( item_Examined_node() )
      
      If only_they_in_view = 1   ; dann werden nur die gesucht, die in der Nähe des Rasters sind. 
      
      ;{ alle in der nähe überprüfen
      
      E3D_getNodePosition ( spi_GetPlayerNode( spi_getcurrentplayer()) , @x1 , @y1 , @z1)   ; prüft die Position des spielers. weil aus der include_spieler.pb -> befehle beginnen mit "spi_"
   
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
               
               If x < 0 Or y < 0 Or z < 0  Or x > #anz_rasterbreite Or y > #anz_rasterhohe Or z > #anz_rasterbreite ; darf ja nicht -1 sein..
                  Continue  
               EndIf


               For n = 0 To anz_raster ( x,y,z )\anzahl_nodes -1 ; setzt voraus, dass die node-liste sortiert ist ( kein "exist=0" )
                  
                  *p_obj               = anz_raster(x,y,z)\node[n]
                  If Not *p_obj\art    = #anz_art_mesh :  Continue : EndIf  ; nur meshes werden untersucht
                  *anz_mesh.anz_mesh   = *p_obj\id
                  ObjectArt            = *p_obj\art 
                  anz_obj_cam_dist     = math_distance3d    (x1,y1,z1, *p_obj\x , *p_obj\y , *p_obj\z)   ; abstand vom jeweiligen Objekt zur Camera (je weiter weg desto unschärfer objekt)
                  If anz_obj_cam_dist  > max_distance  ; damit nicht alle, sondern nur die objekte inderr Nähe überprüft werden.
                     Continue  
                  EndIf 
                  
                  If *anz_mesh\itemID     > 0  ; wenn es ein Item und ein Mesh ist ..
                     
                     If AddElement        ( item_Examined_node())
                        item_Examined_node()\Object3dID = *p_obj 
                        *anz_mesh.anz_mesh              = *p_obj\id
                        item_Examined_node()\nodeID     = *anz_mesh\nodeID 
                        item_Examined_node()\AnzID      = *anz_mesh
                        item_Examined_node()\distance   = anz_obj_cam_dist 
                     EndIf 
                  EndIf 
               Next 
            Next 
         Next 
      Next 
      
      ;}
      
      EndIf 
      ResetList ( item_Examined_node ())
   EndProcedure 

Procedure Item_examine_Next()
   ProcedureReturn NextElement ( item_Examined_node())
EndProcedure

Procedure item_examine_GetIrrNode() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
   ProcedureReturn item_Examined_node()\nodeID 
EndProcedure 

Procedure item_examine_GetAnzID() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
   ProcedureReturn item_Examined_node()\AnzID  
EndProcedure 

Procedure item_examine_GetObjID() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
   ProcedureReturn item_Examined_node()\Object3dID 
EndProcedure 

Procedure item_examine_GetItemID() ; gibt das nächste Item heraus, das mit reset gesucht und NEXT durchgeschaltet wurde&wird
   Protected       *anz_mesh.anz_mesh 
                   *anz_mesh.anz_mesh   = item_Examined_node()\AnzID  
   ProcedureReturn *anz_mesh\itemID 
EndProcedure 

Procedure item_examine_getDistance()
   ProcedureReturn item_Examined_node()\distance 
EndProcedure 

; get set stuff 

Procedure item_waffe_getReichweite ( *itemID.ITEM )
   Protected *waffe.item_waffe 
   
      If *itemID 
         *waffe                 = *itemID\WaffenID 
            If *waffe
               ProcedureReturn *waffe \ Reichweite 
            EndIf 
      EndIf 
      
EndProcedure 

Procedure item_waffe_getangriff( *itemID.ITEM)
   Protected *waffe.item_waffe 
   
      If *itemID 
         *waffe                 = *itemID\WaffenID 
            If *waffe
               ProcedureReturn *waffe \ angriff 
            EndIf 
      EndIf  
      
EndProcedure 

Procedure item_waffe_GetWaffenart ( *itemID.ITEM)  ; gibt waffen/Zauberart aus.. siehe #item_waffe_..)
  Protected *waffe.item_waffe 
  
      If *itemID 
         *waffe                 = *itemID\WaffenID 
            If *waffe
               ProcedureReturn *waffe \ Waffenart 
            EndIf 
      EndIf 
      
EndProcedure

Procedure Item_getNode ( *itemID.ITEM)
   Protected       *anz_mesh.anz_mesh 
   If Not *itemID 
      ProcedureReturn 0
   EndIf 
                   *anz_mesh = *itemID\anz_Mesh_ID
   ProcedureReturn *anz_mesh \nodeID 
   
EndProcedure 

Procedure.s Item_getGuiText ( *itemID.ITEM )
   If *itemID > 0
      ProcedureReturn *itemID\GuiText 
   EndIf  
EndProcedure 

Procedure item_set_Captured ( *itemID.ITEM ) ; löscht das Item von 3D Welt, für Inventar; fügt sie aber nicht ins Inventar hinzu.
   
   If *itemID    > 0
      If *itemID \is_Visible  = 1   ; überprüft, ob Item überhaupt noch vorhanden.
         *itemID \is_Visible  = 0
         anz_delete_object3d( anz_getobject3dByAnzID( *itemID\anz_Mesh_ID))
         *itemID \anz_Mesh_ID = 0
         ProcedureReturn *itemID  ; Successfull!!
      EndIf
   EndIf 

EndProcedure 

Procedure item_drop_item ( *itemID.ITEM) ; erstellt ein verstecktes Item an der gegbenen Position... 
   Protected *anz_mesh.anz_mesh 
   
   If *itemID > 0
      If *itemID\is_Visible  = 0
         *itemID\is_Visible  = 1
         anz_getMeshPosition( wes_getAnzMeshID( spi_GetSpielerWesenID( spi_getcurrentplayer())) , @*itemID\Anz_mesh_struct\x , @*itemID\Anz_mesh_struct\y , @*itemID\Anz_mesh_struct\z )
         *itemID\Anz_mesh_struct\x + Cos(math_FiToRad( Random(360)))* #meter ; damit die items im Kreis um den spieler liegen (1meter Abstand)
         *itemID\Anz_mesh_struct\z + Sin(math_FiToRad( Random(360)))* #meter 
         *itemID\Anz_mesh_struct\y + #meter 
         *itemID\anz_Mesh_ID = anz_addmesh    ( *itemID\Anz_mesh_struct\pfad ,*itemID\Anz_mesh_struct\x , *itemID\Anz_mesh_struct\y , *itemID\Anz_mesh_struct\z , *itemID\Anz_mesh_struct\texture , *itemID\Anz_mesh_struct\MaterialType , *itemID\Anz_mesh_struct\normalmap  ,  1 , 0 , #anz_col_box , #anz_ColType_movable)
         *anz_mesh           = *itemID        \anz_Mesh_ID 
         *anz_mesh           \itemID        = *itemID 
         ProcedureReturn *itemID ; erfolgreich
      EndIf
   EndIf 
   
EndProcedure

Procedure.s Item_GetName(*itemID.ITEM)
  If *itemID 
     ProcedureReturn *itemID\Name 
  EndIf 
EndProcedure

Procedure Item_GetGoldwert(*itemID.ITEM)
  ProcedureReturn *itemID\price
EndProcedure
 
; jaPBe Version=3.9.12.819
; FoldLines=0006000F0011003300240000003500520054005F00630065006700A700AB00E6
; FoldLines=00E800EA00EC00EE00F000F200F400F600F800FC00FE01000104010E0110011A
; FoldLines=011C012601280130013201360158015C015E0160
; Build=0
; CompileThis=..\Anzeige Tester + MiniMap Test.pb
; FirstLine=34
; CursorPosition=335
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF