

; PureBasic Visual Designer v3.95 build 1485 (PB4Code)

Structure gadget
   x.f
   y.f
   x2.f
   y2.f
   name.s ; die Konstante z.b. # button_addmoreSauerstoff (ohne das kreuz)
   art.i  ; z.b. #edit_gadget_art_button
   text.s ; der text, der angezeigt wird.
   min.i  ; für scrollbars: minimum, maximum, seitenlänge..
   max.i 
   pagelengh.i
   Tilewidth.i ; für Listicongadget: Kastenbreite
   Parent.s    ; für Gadgets: Ihr fenster
EndStructure 

;- Window Constants
;
Enumeration
  #Window_0
EndEnumeration

;- Gadget Constants
;
#windows_titelleiste = 20
Enumeration
  #Editor_Input
  #Editor_Output
  #Button_Translate
  #Button_Quit
  #Button_preview
EndEnumeration

Enumeration 
   #edit_gadget_art_button
   #edit_gadget_art_scrollbar
   #edit_gadget_art_text
   #edit_gadget_art_listview
   #edit_gadget_art_image
   #edit_gadget_art_window
   #edit_gadget_art_combobox
   #edit_gadget_art_checkbox
   #edit_gadget_art_editbox
   #edit_gadget_art_menu
   #edit_gadget_art_textline ; eine in den code einzufügende textzeile, z.b. "procedure open_window_1()"
EndEnumeration



Global NewList gadget. gadget()
Global NewList main_global.s() ; eine "global" - Zeile.


Procedure.s translate (text.s)
   Protected anzahl_returns , procedurecount , line.s , Gadgetart.s , Anzahl_windows ,  output.s , id.i = 0
   
   anzahl_returns = CountString ( text , Chr(10 ))
   
   For x = 1 To anzahl_returns +1
      
      line.s = ReplaceString ( RemoveString( RemoveString ( RemoveString ( StringField ( text , x , Chr(10)) , " " ) , "if" , #PB_String_NoCase ) , Chr(34) ) , ")" , "," ) ; replacestring, because then the stringfield runs correctly.
      
      ; schaun, ob neue Procedure losgeht.
      If FindString ( LCase(line) , "endprocedure" , 1)
         AddElement( gadget() )  ; die "open_window_.." procedure beibehalten.
            gadget()\name = "   EndProcedure" + Chr(10)
            gadget()\art  = #edit_gadget_art_textline 
            
         procedurecount - 1
         Continue 
      ElseIf FindString ( LCase (line ) , "procedure" , 1 )
         AddElement( gadget() )
            Debug line 
            gadget()\name = "   Procedure " + Right( line , Len(line)-9)
            gadget()\name = Left(gadget()\name , Len( gadget()\name ) -2 ) + ")" ; das letzte komma mit klammerzu ersetzen
            gadget()\art  = #edit_gadget_art_textline
            
         procedurecount + 1
         Continue 
      EndIf 
      
      Gadgetart.s = LCase (StringField ( line , 1 , "(" )) ; z.b. EditorGadget
      
      Select Gadgetart 
      
         Case "openwindow" ; neues window auf dem die gadgets gezeichnet werden müssen.
         
            AddElement (gadget())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") ) 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y +#windows_titelleiste 
               gadget ()\text   = StringField ( line , 6 , ",")
               gadget ()\art    = #edit_gadget_art_window 
            
            CurrentWindow.s     = "*" + gadget()\name 
            
         Case "buttongadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\text   = StringField ( line , 6 , ",")
               gadget ()\art    = #edit_gadget_art_button
               gadget ()\Parent = CurrentWindow 
            
         Case "stringgadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\text   = StringField ( line , 6 , ",")
               gadget ()\art    = #edit_gadget_art_editbox
               gadget ()\Parent = CurrentWindow 
               
         Case "textgadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\text   = StringField ( line , 6 , ",")
               gadget ()\art    = #edit_gadget_art_text
               gadget ()\Parent = CurrentWindow 
               
         Case "checkboxgadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\text   = StringField ( line , 6 , ",")
               gadget ()\art    = #edit_gadget_art_checkbox
               gadget ()\Parent = CurrentWindow 
               
         Case "comboboxgadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\art    = #edit_gadget_art_combobox
               gadget ()\Parent = CurrentWindow 
               
         Case "listviewgadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\art    = #edit_gadget_art_listview
               gadget ()\Parent = CurrentWindow 
               
         Case "scrollbargadget"
            
            AddElement (gadget    ())
               gadget ()\name      = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x         = Val( StringField ( line , 2 , ",") )
               gadget ()\y         = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2        = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2        = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\max       = Val( StringField ( line , 6 , ",") )
               gadget ()\min       = Val( StringField ( line , 7 , ",") )
               gadget ()\pagelengh = Val( StringField ( line , 8 , ",") )
               gadget ()\art       = #edit_gadget_art_scrollbar
               gadget ()\Parent    = CurrentWindow 
               
         Case "editorgadget"
            
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\art    = #edit_gadget_art_editbox
               gadget ()\Parent = CurrentWindow 
               
               
         Case "imagegadget"
         
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\art    = #edit_gadget_art_button
               gadget ()\Parent = CurrentWindow 
               
         Case "buttonimagegadget"
         
            AddElement (gadget ())
               gadget ()\name   = Mid( line , FindString ( line , "#" , 1 ) +1 , FindString ( line , "," , 1 ) - FindString ( line , "#" , 1 ) -1 )
               gadget ()\x      = Val( StringField ( line , 2 , ",") )
               gadget ()\y      = Val( StringField ( line , 3 , ",") )+#windows_titelleiste 
               gadget ()\x2     = Val( StringField ( line , 4 , ",") ) + gadget()\x
               gadget ()\y2     = Val( StringField ( line , 5 , ",") ) + gadget()\y 
               gadget ()\art    = #edit_gadget_art_button
               gadget ()\Parent = CurrentWindow 
               
      EndSelect 
      
   Next 

   ; output schreiben.
   
   ; erst die globals:
   
   output+ Chr(10)
   output + " ; ---------------------------------------------------------------------------------------------" +Chr(10)
   output + " ; --- Globals"+Chr(10)
   output + " ; ---------------------------------------------------------------------------------------------"+Chr(10)+Chr(10)
   
   ForEach gadget()
      If Not gadget()\art = #edit_gadget_art_textline
          AddElement(main_global())
             output + "  Global *" + gadget()\name  + Chr(10)
      EndIf 
   Next 
   output + Chr(10)
   output + " ; ---------------------------------------------------------------------------------------------"+Chr(10)
   output + " ; --- Commands"+Chr(10)
   output + " ; ---------------------------------------------------------------------------------------------"+Chr(10) +Chr(10)
   
   ; dann die Befehle.
   
   ResetList ( gadget())
   
      While NextElement (gadget())
         
         id     + 1
         output + Chr(10)
         
         Select gadget()\art 
            
            Case #edit_gadget_art_button
               
               output + "      *" +  gadget()\name + " = IrrGuiAddButton( " + Chr(34) + gadget()\text +Chr(34) + " , " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , " + gadget()\Parent + " , " + Str(id)  + " ) "
            
            Case #edit_gadget_art_scrollbar
               
               If gadget()\x2 - gadget()\x > gadget()\y2 - gadget()\y
                  horizontal = 1
               EndIf 
               
               output + "      *" +  gadget()\name + " = IrrGuiAddscrollbar( " + Str(horizontal) +" , " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , " + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_text
            
               output + "      *" +  gadget()\name + " = IrrGuiAddStaticText( " + Chr(34) + gadget()\text +Chr(34) + " , " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , 1 , 1 , 1 , " + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_image

               output + "      *" +  gadget()\name + " = IrrGuiAddImage( " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , " + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_window
               
               If gadget()\Parent = "" : gadget()\Parent = "0" : EndIf 
               output + "      *" +  gadget()\name + " = IrrGuiAddwindow( " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , " + Chr(34) + gadget()\text + Chr(34) + " , 0 , " + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_combobox
            
               output + "      *" +  gadget()\name + " = IrrGuiAddComboBox( " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , " + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_checkbox
               
               output + "      *" +  gadget()\name + " = IrrGuiAddCheckBox( 0 , " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , " + Chr(34) + gadget()\text + Chr(34) +" , "  + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_editbox
               
               output + "      *" +  gadget()\name + " = IrrGuiAddEditBox( "  +Chr(34) +  gadget()\text + Chr(34) + " , " +  Str( gadget()\x) + " , " + Str( gadget()\y ) + " , " + Str( gadget()\x2 ) + " , " + Str( gadget()\y2) + " , 1 , "  + gadget()\Parent + " , " + Str(id) + " ) "
               
            Case #edit_gadget_art_menu
            
               output + "      *" +  gadget()\name + " = irrguiaddmenu( "  + gadget()\Parent + " , " + Str(id) + " ) "
            
            Case #edit_gadget_art_textline
               
               output + gadget()\name
               
         EndSelect 
         
         
      Wend 
      
      ProcedureReturn output 
      
EndProcedure 


Procedure Open_Window_translator()

  If OpenWindow(#Window_0, 452, 205, 600, 521, "PB2Irrlicht translator",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window_0))
      EditorGadget(#Editor_Input, 0, 5, 595, 210)
      SetGadgetText ( #Editor_Input , "Hier kommt der Visual-Designer-Code rein, also einfach irgendein pb-gadgets-code.")
      EditorGadget(#Editor_Output, 0, 215, 595, 230)
      SetGadgetText ( #Editor_Output , "Hier kommt dann der erstellte Code raus, nachdem >>Translate<< gedrückt wurde.")
      ButtonGadget(#Button_Translate, 5, 455, 165, 40, "Translate")
      ; ButtonGadget(#Button_preview, 175, 455, 95, 40, "Preview")
      ButtonGadget(#Button_Quit, 515, 455, 75, 40, "Quit")
      
      Repeat 
         
         evt = WaitWindowEvent()
         
         Select evt
         
            Case #PB_Event_Gadget
               
               Select EventGadget ()
                  
                  Case #Button_Translate
                     
                     SetGadgetText ( #Editor_Output , translate (GetGadgetText ( #Editor_Input)))
                     
                  Case #Button_Quit ;ende
                  
                     End 
               
               EndSelect 
            
            Case #PB_Event_Menu 
            
            Case #PB_Event_CloseWindow 
               
               End 
               
        EndSelect 
     
       ForEver 
    EndIf
  EndIf
EndProcedure

Open_Window_translator() 
; jaPBe Version=3.9.12.819
; FoldLines=0004001100150017
; Build=0
; Language=0x0000 Language Neutral
; FirstLine=290
; CursorPosition=335
; EnableXP
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF