
   
; -----------------------------------------------------------------------------------------------------------------
; --- Procedures  -------------------------------------------------------------------------------------------------
; -----------------------------------------------------------------------------------------------------------------
   
   ; spieler - Inventar befehle
   
   Procedure spi_Inventar_AddItem ( *SpielerID.spi_spieler , *itemID.ITEM) ; fügt item ins inventar; löscht item-node aus Welt (item_set_captured)
      Protected *inventar.spi_inventar
      
      *inventar                         = *SpielerID \ InventarID 
      
      If *inventar\anzahl               < 400 ; wenn inventar nicht schon voll ist
         If item_set_Captured           ( *itemID ) ; überprüft gleichzeitig, ob das Item exisitiert
         
            For x                        = 1 To 400
               If *inventar\itemID[x]    = 0
                  *inventar\itemID[x]    = *itemID 
                  *inventar\anzahl       + 1
                  Break 
               EndIf 
            Next
            
         EndIf 
      EndIf 
      
   EndProcedure 
   
   Procedure spi_inventar_removeItem ( *SpielerID.spi_spieler , *itemID.ITEM) ; drop a Item again.
      Protected *inventar.spi_inventar
      
      *inventar                         = *SpielerID \ InventarID 
      
         If *itemID
         
            For x                       = 1 To 400
               If *inventar\itemID[x]   = *itemID   ; es soll nicht nachsortiert werden, denn: sonst geht die Reihenfolge im Inventar ja verloren.
                  *inventar\itemID[x]   = 0        
                  *inventar\anzahl      - 1         ; anzahl hat hier nur die Bedeutung, dass inventar nicht überfüllt wird.
                  item_drop_item        ( *itemID )
                  Break 
               EndIf 
            Next
            
         EndIf 

   EndProcedure 
   
   ; Procedure spi_inventar_UseItem ( *SpielerID.spi_spieler , *itemID.ITEM)  ; benutzt die Items.. entweder, wenn Waffe, dann nehmen, Apfel essen etc.
      ; 
      ; ; Itemart nachschauen, je nach Itemart dann verwenden, wenn ausrüstungsgegenstand, dann austauschen und anderes wieder ins Inventar werfen. 
      ; ; auskommentiert, da mans ja wohl nicht braucht... lieber spi_inventar_useitemperinventarid hernehmen.
      ; 
      ; 
   ; EndProcedure 
   
   Procedure spi_deleteItemOfInventar ( *SpielerID.spi_spieler , InventarID ) ; löscht ein Item im Inventar unwiederruflich.
      Protected *item.ITEM , *WesenID.wes_wesen , *inventar.spi_inventar 
      
      If InventarID > 0 And InventarID < 400
         
         *inventar    = *SpielerID \InventarID
         *item        = *inventar  \itemID[InventarID]
         *WesenID     = *SpielerID \WesenID 
         
         If *item
            *inventar\itemID [InventarID ] = 0
            Item_Delete      ( *item )
         EndIf 
      EndIf 
      
   EndProcedure 
   
   Procedure spi_inventar_UseItemPerInventarID ( *SpielerID.spi_spieler , InventarID)
      Protected *item.ITEM , *WesenID.wes_wesen , *inventar.spi_inventar , Rest.i , Rest1.i , Rest2.i
      
      If InventarID > 0 And InventarID < 400
         
         *inventar    = *SpielerID \InventarID
         *item        = *inventar  \itemID[InventarID]
         *WesenID     = *SpielerID \WesenID 
         
         If Not *item ; wenn gar kein item da ist
            ProcedureReturn 0
         EndIf 
         
         Select *item\art 
            
            
            Case #item_art_leben  ; heiltrank.. soll leben aufladen
               
                  Rest = wes_SetLeben         ( *WesenID , wes_GetLeben ( *WesenID ) + *item\Betrag  ) ; wes_setleben schaut schon, dass Wesen maximal maxleben haben kann ;) (also kein "lebenoverflow" da ist.
                  
                  If Rest                     ; heiltrank ist nicht ganz aufgebraucht! ;)
                     *item\Betrag             = Rest *0.8 ; -20%. ;)
                  Else                        ; trank removen!!
                     spi_deleteItemOfInventar ( *SpielerID , InventarID )
                     *inventar                \ itemID[InventarID] = 0
                  EndIf 
                  
            Case #item_art_mana   ; soll mana aufladen
               
               Rest = wes_SetMana            ( *WesenID , wes_GetMana ( *WesenID ) + *item\Betrag  ) ; wes_setmana schaut schon, dass Wesen maximal maxmana haben kann ;) (also kein "manaoverflow" da ist.
                  
                  If Rest                     ; manatrank ist nicht ganz aufgebraucht! ;)
                     *item\Betrag             = Rest *0.8 ; -20%. ;)
                  Else                        ; trank removen!!
                     spi_deleteItemOfInventar ( *SpielerID , InventarID )
                     *inventar                \ itemID[InventarID] = 0
                  EndIf 
               
            Case #item_art_fernkampf ; Fernkampfwaffe als primar waffe benutzen
               
               wes_setWesenWaffe             ( *WesenID , *itemID )
               
            Case #item_art_lebenmana ; leben + mana aufladen
               
               ; LEBEN + mana aufladen
               Rest1 = wes_SetLeben         ( *WesenID , wes_GetLeben ( *WesenID ) + *item\Betrag  ) ; wes_setleben schaut schon, dass Wesen maximal maxleben haben kann ;) (also kein "lebenoverflow" da ist.
               Rest2 = wes_SetMana          ( *WesenID , wes_GetMana  ( *WesenID ) + *item\Betrag  )
               
                  If Rest1 > Rest2  ; der größere Rest gilt.
                     Rest  = Rest1
                  Else 
                     Rest  = Rest2
                  EndIf 
                  
                  If Rest                     ; heiltrank ist nicht ganz aufgebraucht! ;)
                     *item\Betrag             = Rest *0.8 ; -20%. ;)
                  Else                        ; trank removen!!
                     spi_deleteItemOfInventar ( *SpielerID , InventarID )
                     *inventar                \ itemID[InventarID] = 0
                  EndIf 
                  
            Case #item_art_nahkampf  ; nahkampfwaffe ziehen
               
               wes_setWesenWaffe             ( *WesenID , *itemID )
               
            Case #item_art_quest     ; nichts tun.. evtl was sagen
               ; PAUSE
               ; Item wird  dann schon ne spezialID haben, je nach spezialid wird dann was andres gemacht.
            Case #item_art_geld      ; nichts tun.
               
            Case #item_art_magie     ; magie als 1. waffe setzen
               ; PAUSE . später dann MAGIE als 1. waffe setzen. je nach Zauber.
            Case #item_art_kram      ; nichts tun.
            
         EndSelect 
               
      EndIf
      
   EndProcedure 
   
   ; spieler - Ausrüstung
   
   Procedure spi_setspielerschwert ( *SpielerID.spi_spieler , *itemID.ITEM )
      wes_setWesenWaffe            ( *SpielerID\WesenID     , *itemID )
   EndProcedure 
   
   Procedure spi_getspielerSchwert ( *SpielerID.spi_spieler ) ; returns ITEMID of current weapon (nicht Itemwaffe!!)
      Protected *WesenID.wes_wesen 
      *WesenID = *SpielerID\WesenID
      ProcedureReturn *WesenID\Waffe_Item_ID 
   EndProcedure 
   
   
   Procedure spi_setSpielerRustung ( *SpielerID.spi_spieler , *itemID.ITEM )
      ; PAUSE. sobald die Rüstungen des Spielers bekannt sind -> je nach rüstung wird der komplette spieler neugeladen.
   EndProcedure 
   
   Procedure spi_GetSpielerRustung ( *SpielerID.spi_spieler )
      ; gibt die Rüstungsart des spielers heraus.
   EndProcedure 
   
   ; spieler -verwaltung
   
   Procedure spi_SetSpielerTargetnodeRot ( Rot.f ) ; dreht das Targetnode des Hauptspielers um XX grad.
   
      If spi_camera\targetnode > 0
         spi_camera\relative_rotation = Rot 
      EndIf
      
   EndProcedure 
   
   Procedure.f spi_GetSpielerTargetNodeRot ( ) ; Gibt die relative Rotation des spielertargetnodes aus (also deines Helden)
         If spi_camera\targetnode > 0
            ProcedureReturn spi_camera\relative_rotation 
         EndIf 
   EndProcedure 
   
   Procedure spi_SetSpielerTargetnodeMotion ( speed.f) ; bewegung of the player's main figure 
      spi_camera\motionspeed = speed 
   EndProcedure 
   
   Procedure spi_addspieler ( x.f,y.f,z.f, leben.w , maxleben.w , mana.w , maxmana.w , name.s , Team.s , IsCurrentSpieler.b = 1) ; erstellt neues 3D Wesen!! und den spieler 
      Protected *spieler.spi_spieler , *WesenID.wes_wesen , *light 
      *spieler                        = AddElement   ( spi_spieler ())
         
         If *spieler                  ; wenn noch genug ram da.
            *spieler\InventarID       = AddElement   ( spi_inventar())
            *spieler\WesenID          = wes_AddWesen ( name , x , y , z , Team , maxleben , #spi_standard_speed , #pfad_spieler_mesh , #pfad_spieler_texture , #pfad_spieler_texture2 , #IRR_EMT_NORMAL_MAP_SOLID ,1 , *spieler) ; wesen hinzufügen.
            *spieler\exist            = 1
            *WesenID                  = *spieler\WesenID 
            ani_SetAnimSettings       ( *WesenID\anz_Mesh_ID , #ani_animNR_stand , 1 , 0.4 , 0 , #spi_standard_animationlist )
            wes_SetmaxMana            ( *spieler\WesenID , maxmana )  ; mana setzen + maxmana.
            wes_SetMana               ( *spieler\WesenID , mana    )
            *light                    = IrrAddLight               ( 0,#meter * 2,0 , 0.9,0.9,0.9,#meter * 3) ; 2 meter überm boden soll's licht sein. und 10 meter weit leuchten
            IrrAddChildToParent       ( *light , anz_getObject3DIrrNode( anz_getobject3dByAnzID(*WesenID\anz_Mesh_ID ))) 
         
            ; wenn spieler = current spieler (camera erstellen)
         
            If IsCurrentSpieler 
               
               If Not anz_camera 
                  anz_camera                = IrrAddCamera ( x , y , z , 10,10,10) ; obacht! global verwendet! anz_camera ist die Standardcamera für alles
               Else 
                  IrrSetNodePosition     ( anz_camera , x , y , z )
               EndIf 
               IrrSetNodeRotation        ( anz_camera   , rotx , roty , rotz)
               spi_DefinePlayerCamera    ( anz_camera ) 
               spi_FixCamera             ( wes_getNodeID( *spieler\WesenID ))
               spi_SetCameraDistance     ( 3.5 * #anz_meter )                
               IrrSetCameraClipDistance  ( anz_camera                 , 150 * #meter)
               
            EndIf
            
            ProcedureReturn *spieler 
         EndIf 
         
   EndProcedure 
   
   Procedure spi_getcurrentplayer()   ; gibt den eigenen Spieler zurück. ( Den Pointer zum Spi_spieler() )
      
      ResetList ( spi_spieler())     ; prüfen, ob spi_camera\targetnode das IrrNode eines Spielers ist -> und herausgeben.
         
         While NextElement    ( spi_spieler())
             
            If wes_getNodeID  ( spi_spieler ()\WesenID ) = spi_camera\targetnode  
               ProcedureReturn spi_spieler  ()
            EndIf 
            
         Wend 
         
   EndProcedure 

   Procedure spi_GetSpielerWesenID (*SpielerID.spi_spieler )
      If Not *SpielerID 
         ProcedureReturn 0
      Else 
         ProcedureReturn *SpielerID\WesenID 
      EndIf 
   EndProcedure 
   
   Procedure spi_GetPlayerNode( *SpielerID.spi_spieler)  ; gibt das irr_node zurück
      If *SpielerID 
         ProcedureReturn wes_getNodeID ( *SpielerID\WesenID )
      EndIf 
   EndProcedure 
   
   ; spieler - MOVE
   
   Procedure spi_move_spielerforward   ( *SpielerID.spi_spieler , amount.f)  ; anim spieler + bewegen 
      Protected *WesenID.wes_wesen     , *anz_Mesh_ID.anz_mesh , drehgrad.f
      *WesenID                         = *SpielerID \WesenID
      *WesenID\action                  = #wes_action_move
      
      If amount < 0 ; spielerfigur um 180° drehen, beim rückwärtsgehen.
         drehgrad                      = spi_GetSpielerTargetNodeRot()
         If drehgrad                   < 0 : drehgrad - 180 : Else : drehgrad + 180 : EndIf  ; muss gemacht werden, zur drehkorrektor etc. (mathe halt)
         spi_SetSpielerTargetnodeRot   ( drehgrad / 2  ) ; wenn = 90, dann nur noch = 45 ;) :) 
         amount                        = -amount ; amount ist ja negativ; muss aber positiv sein ;) (bzw. gesetzt werden, sonst läuft figur falschrum)
      Else         
         spi_SetSpielerTargetnodeRot   ( spi_GetSpielerTargetNodeRot() / 2 ) ; wenn = 90, dann nur noch = 45 ;) :) 
      EndIf 
      
      spi_SetSpielerTargetnodeMotion   ( amount )
      ; PAUSE im Zuge der Rastertechnologie dann schaun, von wegen Rastermäßiges Höhenmessen.. Im Moment läfut alles über collision.
   EndProcedure 
   
   Procedure spi_move_spielerright     ( *SpielerID.spi_spieler,amount.f) ; anim +move
      Protected *WesenID.wes_wesen     , *anz_Mesh_ID.anz_mesh 
      *WesenID                         = *SpielerID \WesenID
      *WesenID\action                  = #wes_action_move
      spi_SetSpielerTargetnodeRot      ( 90 )
      spi_SetSpielerTargetnodeMotion   ( amount )
      ; PAUSE im Zuge der Rastertechnologie dann schaun, von wegen Rastermäßiges Höhenmessen (er will ja nicht in abgründe fallen.).. Im Moment läfut alles über collision. 
   EndProcedure 

   Procedure spi_move_spielerleft      ( *SpielerID.spi_spieler , amount.f) ; anim +move 
      Protected *WesenID.wes_wesen     , *anz_Mesh_ID.anz_mesh 
      *WesenID                         = *SpielerID \WesenID
      *WesenID\action                  = #wes_action_move
      spi_SetSpielerTargetnodeRot      ( -90 )
      spi_SetSpielerTargetnodeMotion   ( amount )
     ; PAUSE im Zuge der Rastertechnologie dann schaun, von wegen Rastermäßiges Höhenmessen.. Im Moment läfut alles über collision.
   EndProcedure 
 
   Procedure spi_setspielerlocate      ( *SpielerID.spi_spieler , x.f , y.f , z.f ) ; only locate without animate
      wes_Stand                        ( *WesenID )
      wes_setposition                  ( *SpielerID\WesenID , x , y, z ) 
   EndProcedure 

   Procedure spi_jump ( *SpielerID.spi_spieler , jumpart = #spi_jump_normal ) ; löst das springen aus. also nur auslöser. + animateion start
      If jumpart = #spi_jump_normal 
         wes_jump        ( *SpielerID\WesenID , #wes_action_jump_start)
      ElseIf jumpart = #spi_jump_flugrolle
         wes_jump        ( *SpielerID\WesenID , #wes_action_jump_flugrolle_start )
      ElseIf jumpart = #spi_jump_not 
         wes_Stand       ( *SpielerID\WesenID )
      EndIf 
   EndProcedure 

   Procedure spi_is_Jump ( *SpielerID.spi_spieler , jumpart = #spi_jump_normal)  ; schaut, ob der spieler gerade in der Luft ist. 
      
      If jumpart = #spi_jump_normal ; prüft, ob spieler normal springt 
         If ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_start Or ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_land 
            ProcedureReturn 1
            Debug "SPRUNG Normal --------------------"
         EndIf 
      ElseIf jumpart = #spi_jump_flugrolle ; prüft, ob spieler flugrolle schon macht
         If ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_flugrolle_start Or ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_flugrolle_land
            ProcedureReturn 1
         EndIf 
      ElseIf jumpart = #spi_jump_not    ; prüft, ob spieler gar nicht springt! also return 1, wenn er NICHT springt!
          If Not( ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_start Or ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_land Or ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_flugrolle_start Or ani_getCurrentAnimationNR ( wes_getAnzMeshID(*SpielerID\WesenID )) = #ani_animNR_jump_flugrolle_land)
             ProcedureReturn 1
          EndIf 
      EndIf 
      
   EndProcedure 
   
      ; spielerspezifisches
   
   Procedure spi_setspielerbogenschiessen( *SpielerID.spi_spieler ) ; im spieler-array sind 3d model und bogen gespeichert )
      
   EndProcedure 
   
   Procedure spi_setspielerschwertangriff( *SpielerID.spi_spieler)
   
   EndProcedure 
   
   Procedure spi_setspielermagie( *SpielerID.spi_spieler)
   
   EndProcedure 
   
   Procedure spi_revive  ( *SpielerID.spi_spieler , x.f , y.f , z.f ) ; Wiederbelebung des spielers .. er darf nicht komplett sterben dürfen.
      End ; PAUSE.. vorerst wird spiel beendet, wenn spieler tot.
   EndProcedure 
   
   
   ; die alte Include "inc_camera" von Scara -> leicht umgeschreiben, damit rundes bewegen.
   
   Procedure spi_DefinePlayerCamera(spi_camera_)
     spi_camera\pointer = spi_camera_
   EndProcedure
   
   ; Diese Funktion fixiert die spi_camera auf den angegebenen Scene Knoten
   Procedure spi_FixCamera(*node)
     Protected px.f, py.f, pz.f
     spi_camera\targetnode = *node
   EndProcedure

   ; Diese Funktion ändert die Entfernung der spi_camera zum Modell
   Procedure spi_SetCameraDistance(distance.f)
     If distance < 10
        distance = ( distance + 10 ) / 2
     ElseIf distance > 300
        distance = ( distance + 300 ) / 2
     EndIf
     spi_camera\distance = distance
   EndProcedure

   ; Rotiert die spi_camera auf und ab
   Procedure spi_RotateCamera(vertical.f)
     If spi_camera\anglevert > 85
        If  - vertical < 0
           spi_camera\anglevert - vertical 
        EndIf 
     ElseIf spi_camera\anglevert < 1
        If  - vertical > 0
           spi_camera\anglevert - vertical 
        EndIf 
     Else  
        spi_camera\anglevert - vertical 
     EndIf 
  
     If spi_camera\anglevert > 85
       spi_camera\anglevert  = 85
     ElseIf spi_camera\anglevert < 1
          spi_camera\anglevert  = 1
     EndIf
   EndProcedure
   
   Procedure spi_ExamineCamera() 
    
     Protected ax.f, ay.f, az.f, px.f, py.f, pz.f, camx.f, camy.f, camz.f
     ; Drehung des Zielnodes ermitteln
     If spi_camera\targetnode
         IrrGetNodeRotation(spi_camera\targetnode, @ax, @ay, @az)
         ay - spi_camera\relative_rotation  ; wenn spielerfigur sich nach rechts/links dreht, ist winkel ja anders !
         ; Position des Zielnodes ermitteln
         IrrGetNodePosition(spi_camera\targetnode, @px, @py, @pz)
         ; neue Position der spi_camera bestimmen
         ay - 90 
         ; Debug spi_camera\anglevert
         camx = Sin(ay*#PI/180)              *           spi_camera\distance+px
         camy = Sin(spi_camera\anglevert     * #PI/180)* spi_camera\distance+py
         camz = Cos(ay*#PI/180)              *           spi_camera\distance+pz
         ; spi_camera an neue Position bewegen
         IrrSetNodePosition(spi_camera\pointer, camx, camy, camz)
         ; spi_camera auf das Ziel ausrichten
         IrrSetCameraTarget(spi_camera\pointer, px, py, pz)
         ; IrrGetNodeRotation(spi_camera\pointer, @ax, @ay, @az)
     EndIf 
     
   EndProcedure

   Procedure.i DMX_Freelook(action.i, MXS.f , MYS.f ,  Velocity.f=1.01, speed.f=0.05, Damping.f=5.0) ; bewegt den Spiel-helden auch vorwärts, dreht ihn, dreht die camera etcetc ;)
      
       Protected x.f,y.f,z.f
       ; Static MXS.f, MYS.f
       Static Pitch.f, Yaw.f , firststart.w
       Static UpDown.f, LeftRight.f
       Static VelocityX.f, VelocityZ.f
       
       MXS * -1
       MYS * -0.4
       
       If firststart
          IrrGetNodeRotation ( spi_camera\targetnode , @x, @y, @z)
          LeftRight          = y 
       EndIf 
    
       If (action = #True)        
        
           ;-Camera rotation
        
        ; Pitch                       / 2.5
           spi_camera\anglevert    + ( ( Pitch - spi_camera\anglevert   ) / (Damping))
        
           Yaw                         + ( MXS / 1.5)
           LeftRight                   + ( ( Yaw   - LeftRight                  ) / (Damping))
           
           If spi_camera\targetnode    ; wenn überhaupt ein node deffiniert ist.
           
               IrrGetNodeRotation ( spi_camera\targetnode , @x, @y        , @z)
               IrrSetNodeRotation ( spi_camera\targetnode ,  x, LeftRight + spi_camera\relative_rotation ,  z)
               If Not spi_camera      \ motionspeed =0
                  anz_moveObject  ( anz_getobject3dByNodeID( spi_camera\targetnode ) , spi_camera\motionspeed  , 0 ,0)
                  spi_camera      \motionspeed = 0
               EndIf 
               
           EndIf 
           
    ; camera rauf/runter
   
     If spi_camera\anglevert > 80
        If MYS   < 0
           Pitch + ( MYS / 1.5)
        Else 
           Pitch = spi_camera\anglevert
        EndIf 
     ElseIf spi_camera\anglevert < 0
        If MYS  > 0
           Pitch+(MYS / 1.5)
        Else 
           Pitch = 0
        EndIf 
     Else  ; wenn istgleich
        Pitch+(MYS / 1.5)
     EndIf 
     
     If spi_camera\anglevert     > 85
       spi_camera\anglevert      = 85
     ElseIf spi_camera\anglevert < 0
       spi_camera\anglevert      = 0
     EndIf
     
       EndIf
   EndProcedure 

   ; Diese Funktion ermittelt die Entfernung der spi_camera zum Modell
   Procedure spi_GetCameraDistance()
     ProcedureReturn spi_camera\distance
   EndProcedure
 
; jaPBe Version=3.8.8.716
; FoldLines=001D002F00390048004A009800A700A900AB00AD00B100B700B900BD00C300E6
; FoldLines=00E800F400F600FC00FE0102010601160118011F01210128012A012D012F0137
; FoldLines=0139014A01610163016C01730176018801E301E5
; Build=0
; FirstLine=100
; CursorPosition=404
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF