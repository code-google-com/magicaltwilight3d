;============================================================
;  MiniMap Modul [Magical Twilight]
;                                      by Bluedragon
;============================================================



  Procedure MIN_INIT(x=0,y=0)

    *MIN_Init = 1
    
    If x <> 0 Or y<>0
      
      *MIN_Position\x = x
      *MIN_Position\y = y
    
    Else 
    
      x = *MIN_Position\x
      y = *MIN_Position\y
      
    EndIf
    
     MIN_GUI_BG = anz_loadimage(-1,x,y,"Gfx\minimap\MapBG.png",1,0)
     
    ProcedureReturn #True
    
  EndProcedure 
  
  
  ;===================================================================
  ; MIN_Init(X,Y)
  ;                Bereitet alles f�r die Anzeige der MiniMap vor
  ; @Params:
  ;                X : Position X  der MiniMap auf dem Screen 
  ;                Y : Position Y  der MiniMap auf dem Screen 
  ;
  ;_------------------------------------------------------------------
  ;
  ; Wenn X und Y weggelassen werden, ist Y = 10
  ; und X = ScreenWidth - 160
  ;
  ;===================================================================


  Procedure MIN_SetScreenPos(x,y)
    
    If *MIN_Init = 1
      
      *MIN_Position\x = x
      *MIN_Position\y = y
      
      anz_setimagepos(MIN_GUI_BG,x,y)
      
      ProcedureReturn #True
      
    EndIf
    
  EndProcedure 
  
  
  ;===================================================================
  ; MIN_SetScreenPos(X,Y)
  ;                �ndert die Position der MiniMap-Anzeige
  ; @Params:
  ;                X : Position X  der MiniMap auf dem Screen 
  ;                Y : Position Y  der MiniMap auf dem Screen 
  ;
  ;===================================================================
  
  
  Procedure MIN_AddDot(x,y,Type$)
    
    If *MIN_Init = 1
      
      AddElement(*Min_Dots())
          *Min_Dots() = AllocateMemory(SizeOf(MIN_DOT))
          *Min_Dots()\x    = x
          *Min_Dots()\y    = y
          *Min_Dots()\Type = Type$
          *Min_Dots()\id   = *MIN_ID_Counter
          
      *MIN_ID_Counter + 1
          
      ProcedureReturn *MIN_ID_Counter-1
    EndIf

  EndProcedure
  
  
  ;===================================================================
  ; MIN_AddDot(X,Y,Type$)
  ;                F�gt einen Punkt auf der MiniMap ein
  ; @Params:
  ;                X     : Position X  auf der Karte 
  ;                Y     : Position Y  auf der Karte
  ;                Type$ : Type des Punkts (siehe Structures)
  ;
  ; @Return:
  ;           Eindeutige ID des Punkts
  ;===================================================================
  
  
  Procedure MIN_SetDotPos(id,x,y)
    
    If *MIN_Init = 1  
      
      ForEach *Min_Dots()
        
        If *Min_Dots()\id = id
          
          *Min_Dots()\x = x
          *Min_Dots()\y = y
          
          ProcedureReturn #True
        EndIf
        
      Next 
        
    EndIf 
    
  EndProcedure
  
  
  ;===================================================================
  ; MIN_SetDotPos(ID,X,Y)
  ;                �ndert die Position des Dots mit der ID
  ; @Params:
  ;                ID    : ID des Punktes 
  ;                X     : Position X  auf der Karte 
  ;                Y     : Position Y  auf der Karte
  ;
  ;===================================================================
  
  
  Procedure MIN_GetDotPos(id)
    
    If *MIN_Init = 1  
      
      ForEach *Min_Dots()
        
        If *Min_Dots()\id = id
          
          *Pos.POINT = AllocateMemory(SizeOf(POINT))
          
          *Pos\x = *Min_Dots()\x
          *Pos\y = *Min_Dots()\y
          
          ProcedureReturn *Pos
        EndIf
        
      Next 
        
    EndIf 
    
  EndProcedure
  
  
  ;===================================================================
  ; MIN_GetDotPos(ID)
  ;                Gibt die *Position des Dots mit der ID zur�ck
  ; @Params:
  ;                ID    : ID des Punktes 
  ;
  ; @Return Structure Point
  ;            \X = X
  ;            \Y = Y
  ;
  ;===================================================================
  
  
  Procedure MIN_SetDotType(id,Type$)
    
    If *MIN_Init = 1
      
      ForEach *Min_Dots()
        
        If *Min_Dots()\id = id
          
          *Min_Dots()\Type = Type$
          ProcedureReturn 1
          
        EndIf
        
      Next
    
    EndIf
    
   EndProcedure 
   
   
  ;===================================================================
  ; MIN_SetDotType(ID,Type$)
  ;                �ndert den Type des Dots mit der ID
  ; @Params:
  ;                ID    : ID des Punktes 
  ;                Type  : Type des Punktes 
  ;
  ;===================================================================
  
  
    Procedure.s MIN_GetDotType(id)
    
    If *MIN_Init = 1
      
      ForEach *Min_Dots()
        
        If *Min_Dots()\id = id
          
          ProcedureReturn *Min_Dots()\Type
          
        EndIf
        
      Next
    
    EndIf
    
   EndProcedure 
   
   
  ;===================================================================
  ; MIN_SetDotType(ID)
  ;                Gibt den Type des Dots mit der ID zur�ck
  ; @Params:
  ;                ID    : ID des Punktes 
  ;
  ; @Return :
  ;            Type.s
  ;
  ;===================================================================
  
  
  Procedure MIN_Reset()
    
    If *MIN_Init = 1
      
      ClearList(*Min_Dots())
      *MIN_ID_Counter = 0
      
    EndIf
    
  EndProcedure
  
  ;===================================================================
  ; MIN_Reset()
  ;                Setzt alles zur�ck, sollte bei Mapwechsel und Co.
  ;                gemacht werden
  :
  ;===================================================================
  
  Procedure MIN_ExamineMiniMap() ; pr�ft die umgebung auf gegner.
     *playerPos.ivector3 
     
     If *MIN_Init = 1 And spi_getcurrentplayer() > 0 ; wenn die minimap an und ein spieler existent sind.
        
        MIN_Reset()  ; minimap resetten. alles l�schen.
        
        wes_Examine_Reset ( spi_GetPlayerNode     (  spi_getcurrentplayer()) , 1 , #meter * 10)
        wes_getposition   ( spi_GetSpielerWesenID (  spi_getcurrentplayer()) ,@*playerPos\x , @*playerPos\y , @*playerPos\z )
        
         While wes_examine_Next ()
            If team_GetFreundLevel ( wes_Examine_get_Team () , wes_getTeam (spi_GetSpielerWesenID(  spi_getcurrentplayer()))) > 0 ; wesen ist freund
               ; gr�ne kugel anzeigen 
               MIN_AddDot( Min_MapWidth / 2 +  wes_Examine_get_Distance()
            ElseIf team_GetFreundLevel( wes_Examine_get_Team () , wes_getTeam (spi_GetSpielerWesenID(  spi_getcurrentplayer()))) = 0 ; neutral. evtl orange
               ; orange kugel
            ElseIf team_GetFreundLevel( wes_Examine_get_Team () , wes_getTeam (spi_GetSpielerWesenID(  spi_getcurrentplayer()))) < 0  ; gegner
                  ; rote kugel
            EndIf 
         Wend 
     
     EndIf 
  
  EndProcedure 
  
  ;===================================================================
  ; Min_ExamineMinimap()
  ;                Umgebung auf Gegner /items etc. Pr�fen.
  ;                Anzeigen der Gegner etc. als Punkte auf der Karte.
  :
  ;===================================================================
  
  
  Procedure MIN_RenderMiniMap()
    
    If *MIN_Init = 1
      
      anz_setimageforeground(MIN_GUI_BG)
      
      ForEach *Min_Dots()
      
        anz_freeimage(*Min_Dots()\ImgID)
      
        If *Min_Dots()\x > *MIN_Position\x And *Min_Dots()\y > *MIN_Position\y
          If *Min_Dots()\x < *MIN_Position\x + 145 And *Min_Dots()\y < *MIN_Position\y + 150
      
              *Min_Dots()\ImgID = anz_loadimage(-1,*Min_Dots()\x,*Min_Dots()\y,"..\..\minimap\"+ *Min_Dots()\Type +".png",1,0)
              anz_setimageforeground(*Min_Dots()\ImgID)
              
          EndIf
        EndIf
        
      Next
      
    EndIf
    
  EndProcedure
  
  
  ;===================================================================
  ; MIN_RenderMiniMap()
  ;                Rendert die MiniMap =D
  :
  ;===================================================================
  
  
;============================================================
; End of Code

 
; jaPBe Version=3.9.12.819
; Build=0
; FirstLine=238
; CursorPosition=259
; EnableXP
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF