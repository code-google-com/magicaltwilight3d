   

   
   Procedure.f math_square_distance2d(x1.f, y1.f, x2.f, y2.f)
      Protected x.f, y.f, z.f, d.f
         x = x2-x1
         y = y2-y1
         d = Abs ( x ) + Abs( y )
      ProcedureReturn d
   EndProcedure
   
   Procedure.f math_square_distance3d(x1.f, y1.f, z1.f, x2.f, y2.f, z2.f)
      Protected x.f, y.f, z.f, d.f
         x = x2-x1
         y = y2-y1
         z = z2-z1
         d = Abs( x ) + Abs( y ) + Abs( z )
      ProcedureReturn d
   EndProcedure
   
   Procedure.f math_betrag ( zahl.f ) ; gibt den Betrag (positiven wert) der Zahl aus.
      If zahl < 0
         zahl * -1
      EndIf 
      ProcedureReturn zahl 
   EndProcedure 
   
   Procedure.f math_FixFi  ( Fi.f) ; Winkel Fi darf nicht �ber 360� gro� sein -> umrechnen. (auch nicht kleiner als 0..)
      Protected faktor.i
      
      If Fi > 360
         faktor = Round( Fi / 360 ,0)  ; schauen, wie oft 360 abgezogen werden muss
         Fi - faktor * 360             ; und abziehen, um den restwert zu haben.
      EndIf 
      
      If Fi < 0
         faktor = Round ( -1* Fi / 360 , 1 )
         Fi + faktor * 360
      EndIf 
      
      ProcedureReturn Fi 
   EndProcedure 
   
   Procedure.f math_distance3d(x.f,y.f,z.f,x1.f,y1.f,z1.f)
      ProcedureReturn Sqr( (x1-x)*(x1-x) + (y1-y)*(y1-y) + (z1-z)*(z1-z))
   EndProcedure 
   
   Procedure math_IsFiInBereich( Fi.f, Startfi.f , Endfi.f) ; wobei die fis auch richtig umgerechnet  werden (+360,-360) etc.
      Protected differenz.f , faktor.f ,speicher.f
      ; Endfi   = math_FixFi ( Endfi)
      ; Startfi = math_FixFi ( Startfi )
      ; Fi      = math_FixFi ( Fi )
      
         If Not Endfi > Startfi ; endfi muss immer der groessere WErt sein.
             speicher  = Startfi 
             Startfi   = Endfi
             Endfi     = speicher
         EndIf 
      
         If (Endfi - Startfi) >= 360 ; dann muasa drinliegen.
            ProcedureReturn 1
         EndIf 
         
         faktor = Round ( Fi / 360 , 0) ; mit der faktortechnik hier sollte es gehen, dass vergleiche m�glich sind....
         If Not Round ( Startfi / 360 ,0) = faktor 
            Startfi   + faktor * 360
         EndIf 
         If Not Round ( Endfi / 360 , 0) = faktor 
            Endfi     + faktor * 360
         EndIf 
         
         If Fi > Startfi And Fi < Endfi 
            ProcedureReturn 1
         EndIf 
            
   EndProcedure 
   
   Procedure math_iseven(zahl.i)
      ProcedureReturn (Not (zahl % 2))
   EndProcedure
   
   Procedure.f math_RadToFi ( Rad.f)  ; rechnet RAD in Grad um ;)
      ProcedureReturn (180 / 3.14) * Rad 
   EndProcedure 
   
   Procedure.f math_FiToRad ( Fi.f)  ; rechnet Grad in RAD um ;)
      ProcedureReturn (Fi / 180 * 3.14 )
   EndProcedure 
   
   Procedure math_IrrFaceTargetPerPos ( *src.irr_node, x.f , y.f , z.f )  ; ist hier  in Mathinclude, weil in irrlicht-include des ganze leicht �berschrieben wird (z.b. bei neuer irrlicht vers.)
      Protected ndiff.IRR_VECTOR, targetPos.IRR_VECTOR, srcPos.IRR_VECTOR, degree.f
      
      ; Check Pointers
      If *src
         ; Get Source Position
         IrrGetNodePosition(*src, @srcPos\x, @srcPos\y, @srcPos\z)
         ; Get Target Position
          targetPos\x = x
          targetPos\y = y 
          targetPos\z = z
         ; Calculate Diff
         ndiff\x = targetPos\x - srcPos\x
         ndiff\y = targetPos\y - srcPos\y
         ndiff\z = targetPos\z - srcPos\z
         
         ; Check X
         If ndiff\x = 0.0
            ProcedureReturn #False
         Else
            ; Calculate Degree
            degree.f = (ATan(ndiff\z / ndiff\x) * (180.0 / #PI))
            
            ; Fix Delta
            If srcPos\x - targetPos\x > 0
            degree.f = 90 - degree.f
            Else
            degree.f = -90 - degree.f
            EndIf
            ; Rotate
            IrrSetNodeRotation(*src ,0.0, degree.f +90, 0.0)
            ProcedureReturn #True
         EndIf
      Else
         ProcedureReturn #False
      EndIf
      
   EndProcedure
   
   Procedure math_IrrFaceTarget ( *src.irr_node, *target.irr_node)  ; ist hier  in Mathinclude, weil in irrlicht-include des ganze leicht �berschrieben wird (z.b. bei neuer irrlicht vers.)
      Protected ndiff.IRR_VECTOR, targetPos.IRR_VECTOR, srcPos.IRR_VECTOR, degree.f
      
      ; Check Pointers
      If *target And *src
         ; Get Source Position
         IrrGetNodePosition(*src   , @srcPos\x, @srcPos\y, @srcPos\z)
         ; Get Target Position
         IrrGetNodePosition(*target, @targetPos\x, @targetPos\y, @targetPos\z)
         ; Calculate Diff
         ndiff\x = targetPos\x - srcPos\x
         ndiff\y = targetPos\y - srcPos\y
         ndiff\z = targetPos\z - srcPos\z
         
         ; Check X
         If ndiff\x = 0.0
            ProcedureReturn #False
         Else
            ; Calculate Degree
            degree.f = (ATan(ndiff\z / ndiff\x) * (180.0 / #PI))
            
            ; Fix Delta
            If srcPos\x - targetPos\x > 0
            degree.f = 90 - degree.f
            Else
            degree.f = -90 - degree.f
            EndIf
            ; Rotate
            IrrSetNodeRotation(*src ,0.0, degree.f +90, 0.0)
            ProcedureReturn #True
         EndIf
      Else
         ProcedureReturn #False
      EndIf
      
   EndProcedure 
; jaPBe Version=3.7.12.680
; Build=0
; FirstLine=45
; CursorPosition=63
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF