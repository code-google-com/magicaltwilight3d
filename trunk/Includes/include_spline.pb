
; +---------------------------+
; | K-NetLib DataBlock Object |
; +---------------------------+

Interface DataBlock
   
   Members.l() ; Returns the number of fields in the DataBlock.
   TotalSize.l() ; Returns the size in bytes of the DataBlock (including heading information).
   DataSize.l(); Returns only the size of the data area (excluding heading information).
   
   GetFldIndex.l(Name.s) ; Returns the index of a DadaBlock field through it's Name.
   GetFldName.s(Index.l) ; Returns the name of a DataBlock field through it's Index.
   
   iGetFldType.l(Index.l) ; Returns the data-type of a DataBlock field through it's Index.
   nGetFldType.l(Name.s) ; Returns the data-type of a DataBlock field through it's Name.
   
   iGetFldSize.l(Index.l) ; Returns the size (in bytes) of a DataBlock field through it's Index.
   nGetFldSize.l(Name.s) ; Returns the size (in bytes) of a DataBlock field through it's Name.
   
   iGetFldPtr.l(Index.l) ; Returns a pointer to a DataBlock field through it's Index.
   nGetFldPtr.l(Name.s) ; Returns a pointer to a DataBlock field through it's Name.
   
   iGetFldObj.l(Index.l) ; Returns a Field object with methods Set/Get for the given field Index.
   nGetFldObj.l(Name.s) ; Returns a Field object with methods Set/Get for the given field Name.
   
   Destroy()
   
EndInterface

Structure DataBlock_Methods
   Members.l
   TotalSize.l
   DataSize.l
   GetFldIndex.l
   GetFldName.l
   iGetFldType.l
   nGetFldType.l
   iGetFldSize.l
   nGetFldSize.l
   iGetFldPtr.l
   nGetFldPtr.l
   iGetFldObj.l
   nGetFldObj.l
   Destroy.l
EndStructure
Structure DataBlock_Properties
   Instance.l
   Members.l
   TotalSize.l
   DataSize.l
   MemoryBlock.l
EndStructure
Structure DataBlock_Object
   *Methods.DataBlock_Methods
   *Properties.DataBlock_Properties
EndStructure
Structure DataBlock_Holder
   Status.l
   Methods.DataBlock_Methods
   Properties.DataBlock_Properties
   Object.DataBlock_Object
EndStructure

; +-------------------------------+
; | K-NetLib Bézier Spline Object |
; +-------------------------------+

Interface Spline
   SetKnot(Knot.l, X.f, Y.f, Z.f)
   Calculate()
   GetX.f(Point.l)
   GetY.f(Point.l)
   GetZ.f(Point.l)
   Destroy()
EndInterface

Structure Spline_Methods
   SetKnot.l
   Calculate.l
   GetX.l
   GetY.l
   GetZ.l
   Destroy.l
EndStructure
Structure Spline_Properties
   Instance.l ; Slot this Spline is occuping in its instance linked list.
   Knots.l ; Number of Knots that influences the spline.
   Blender.l ; Blending Factor: 2 = lines; 3 = curves.
   Whole.f ; Lenght from Knot 1 to Knot N.
   Piece.f ; Segment lenght
   Points.l ; Knots + Blender
   Segments.l ; Total number of segments in the Spline.
   DB.DataBlock ; DataBlock holding the Spline points coordinates.
EndStructure
Structure Spline_Object
   *Methods.Spline_Methods
   *Properties.Spline_Properties
EndStructure
Structure Spline_Holder
   Status.l ; Status of the Spline Object slot within it's instance linked list (In Use / Available).
   Methods.Spline_Methods ; Methods of the Spline Object.
   Properties.Spline_Properties ; Properties of the Spline Object.
   Object.Spline_Object ; Spline Object structure holder.
EndStructure





Procedure.l SafeAlloc(Size.l)
   
   Define.l *Buffer
   
   *Buffer.l = *NullPointer
   
   If KNL_Heap.l
      If Size.l
         EnterCriticalSection_(@MEM_CS) ;/ Critical Section
          *Buffer.l = HeapAlloc_(KNL_Heap.l, $00000008, Size.l)
         LeaveCriticalSection_(@MEM_CS) ;/ Critical Section
      EndIf
   EndIf
   
   ProcedureReturn *Buffer.l
   
EndProcedure

Procedure   SafeFree(*Buffer.l)
   
   If KNL_Heap.l
   
      If *Buffer.l
         
         EnterCriticalSection_(@MEM_CS) ;/ Critical Section
           If HeapValidate_(KNL_Heap.l, 0, *Buffer.l)
              HeapFree_(KNL_Heap.l, 0, *Buffer.l)
           EndIf
         LeaveCriticalSection_(@MEM_CS) ;/ Critical Section
         
         *Buffer.l = *NullPointer.l
         
      EndIf
      
   EndIf
   
EndProcedure

Procedure.l Construct_DataBlock(MemberList.s)
   
   ; +------------------------------------------------------------------------------+
   ; | This Procedure tries to create a new Instance of a DataBlock object. If it   |
   ; | is successfull, then the address of the new DataBlock object is returned,    |
   ; | otherwise 0 (zero) is returned.                                              |
   ; |                                                                              |
   ; | The structure of the DataBlock is defined by the contents of the MemberList  |
   ; | parameter. It must consist of a list of field names and their corresponding  |
   ; | data types, separated by #Pipe:                                              | 
   ; |                                                                              |
   ; | FieldName.Type|FieldName.Type|FieldName.Type...                              |
   ; |                                                                              |
   ; | FieldName can be up to 40 characters long (wich is a bunch of chars, by the  |
   ; | way). Possible Data types are: b,w,l,f and s which are respectively: byte,   |
   ; | word, long, float and string.                                                |
   ; |                                                                              |
   ; | When defining a String-Type (fixed lenght), the syntaxe of its declaration   |
   ; | changes a little: FieldName.s.[L] where [L] is the fixed lenght.             |
   ; | The same goes for Raw-Type (fixed lenght), changing only .s to .r type.      |
   ; |                                                                              |
   ; | Arrays can be defined as: FieldName.Type.[N] where [N] is the number of      |
   ; | elements in the Array. Array indexes will allways range from 0 to [N-1].     |
   ; |                                                                              |
   ; | Arrays of strings will be: FieldName.s.[L].[N] where [L] is the fixed        |
   ; | lenght of each array element and [N] is the number of elements in the array. |
   ; | Again, the same goes for Raw-Type arrays.                                    |
   ; +------------------------------------------------------------------------------+
   
   Define.DataBlock_Object *Object
   Define.DataBlock_Holder *Entry
   Define.l *MemoryBlock
   
   Define.l Index, Members
   Define.l FieldType, FieldLen, Elements, BlockLen
   Define.l DataOffset, HeaderOffset
   
   Define.s TypeList, NameList, SizeList, ArrayList
   Define.s Member, Type, length, FieldName, Array
   
   EnterCriticalSection_(@DBO_CS) ;/ Critical Section
     
     *Entry = SafeAlloc(SizeOf(DataBlock_Holder))
     
     If *Entry
        
        *Entry\Properties\Instance = *Entry
          
        ; Inspect MemberList.s parameter in order
        ; to know how many fields are supposed to
        ; to be hold and their data-types:
        
        EnterCriticalSection_(@STR_CS) ;/ Critical Section
        
           TypeList.s = ""
           NameList.s = ""
           SizeList.s = ""
           ArrayList.s = ""
           
        LeaveCriticalSection_(@STR_CS) ;/ Critical Section
        
        Index.l = 0
        Members.l = 0 
        BlockLen.l = 0
        
        EnterCriticalSection_(@STR_CS) ;/ Critical Section
        
           Repeat
             
             Index.l = Index.l + 1
             
             Member.s = Trim(StringField(MemberList.s, Index.l, #Pipe))
             
             If Member.s = ""
                
                ; We'll consider an empty string
                ; as the end of the member list.
                
                Break
                
                Else
                
                Members.l = Members.l + 1
                
                Type.s = Trim(LCase(StringField(Member.s, 2, #Dot)))
                
                Select Type.s
                  
                  Case "b": FieldType.l = #vByte:   FieldLen.l = 1 ; Byte
                  Case "w": FieldType.l = #vWord:   FieldLen.l = 2 ; Word
                  Case "l": FieldType.l = #vLong:   FieldLen.l = 4 ; Long
                  Case "f": FieldType.l = #vFloat:  FieldLen.l = 4 ; Float
                  Case "d": FieldType.l = #vDouble: FieldLen.l = 8 ; Double
                  
                  ; String fields demmand a little more steps:
                  
                  Case "s"
                    
                    FieldType.l = #vString
                    length.s = Trim(StringField(Member.s,3,#Dot)) ; Capture the length parameter.
                    length.s = Mid(length.s, 2, Len(length.s) - 2) ; Remove the brackets [].
                    FieldLen.l = Val(length.s) + 1 ; Length + Null terminator.
                    
                  Case "r"
                    
                    FieldType.l = #vRawData
                    length.s = Trim(StringField(Member.s,3,#Dot)) ; Capture the length parameter.
                    length.s = Mid(length.s, 2, Len(length.s) - 2) ; Remove the brackets [].
                    FieldLen.l = Val(length.s) ; Crude Length
                    
                  Default: FieldType.l = #vLong: FieldLen.l = 4 ; Long Pointer
                  
                EndSelect
                
                ; Check if we are dealing with an array field. If that
                ; is the Case, then FieldLen must be multiplied by the
                ; number of Elements in the array:
                
                If Type.s = "s"
                   Array.s = Trim(LCase(StringField(Member.s, 4, #Dot)))
                   Else
                   If Type.s <> "r"
                      Array.s = Trim(LCase(StringField(Member.s, 3, #Dot)))
                   EndIf
                EndIf
                
                If Array.s <> ""
                   
                   ; Flip the array indicator of FieldType variable
                   ; in order to indicate that this is an array field:
                   
                   FieldType.l = FieldType.l + #vArray
                   
                   ; Calculate the array size:
                   
                   Array.s = Mid(Array.s, 2, Len(Array.s) - 2) ; Remove the brackets [].
                   Elements.l = Val(Array.s) ; Calculate the number of elements in the array.
                   BlockLen.l = BlockLen.l + (FieldLen.l * Elements.l) ; Compute DataBlock size.
                   ArrayList.s = ArrayList.s + Str(Elements.l) + #Pipe
                   
                   Else
                   
                   BlockLen.l = BlockLen.l + FieldLen.l ; Compute DataBlock size.
                   ArrayList.s = ArrayList.s + "1" + #Pipe
                   
                EndIf
                
                NameList.s = NameList.s + Trim(StringField(Member.s, 1, #Dot)) + #Pipe
                TypeList.s = TypeList.s + Str(FieldType.l)+ #Pipe
                SizeList.s = SizeList.s + Str(FieldLen.l) + #Pipe
                
             EndIf
             
           ForEver
        
        LeaveCriticalSection_(@STR_CS) ;/ Critical Section
        
        ; Calculate the full lenght of the DataBlock including
        ; all the header information we'll need to deal the
        ; stored data. A header item of 50 bytes will be created
        ; for each field in the DataBlock structure, as follows:
        
        ; +----------------------------------------------------------------------------+
        ; |                      DataBlock Header Information                          |
        ; +----------------------------------------------------------------------------+
        ; | Field Type: 1 byte                                                         |
        ; | Field Length: 4 bytes (the size of the field within the block)             |
        ; | Field Offset: 4 bytes (the offset of the field value within the block)     |
        ; | Field Name: 41 bytes (40 chars + Null terminator)                          |
        ; +----------------------------------------------------------------------------+
        
        BlockLen.l = BlockLen.l + (Members.l * 50)
        
        *MemoryBlock.l = SafeAlloc(BlockLen.l)
        
        If *MemoryBlock.l
        
           ; If the memory allocation was OK, then we can procceed.
           ; We'll loop through the collected information in order
           ; to build the DataBlock header:
           
           HeaderOffset.l = 0 ; First header item starts at *MemoryBlock address.
           DataOffset.l = Members.l * 50 ; First field value comes after the last header.
           
           For Index.l = 1 To Members.l
               
               EnterCriticalSection_(@STR_CS) ;/ Critical Section
               
                  FieldType.l = Val(StringField(TypeList.s, Index.l, #Pipe))
                  FieldLen.l = Val(StringField(SizeList.s, Index.l, #Pipe))
                  FieldName.s = StringField(NameList.s, Index.l, #Pipe)
                  Elements.l = Val(StringField(ArrayList.s, Index.l, #Pipe))
                  
               LeaveCriticalSection_(@STR_CS) ;/ Critical Section
               
               PokeB(*MemoryBlock + HeaderOffset.l, FieldType.l)
               PokeL(*MemoryBlock + HeaderOffset.l + 1, FieldLen.l)
               PokeL(*MemoryBlock + HeaderOffset.l + 1 + 4, DataOffset.l)
               PokeS(*MemoryBlock + HeaderOffset.l + 1 + 4 + 4, FieldName.s, 40)
               
               DataOffset.l = DataOffset.l + (FieldLen.l * Elements.l)
               
               HeaderOffset.l = HeaderOffset.l + 50
               
           Next
           
           ; If we got here, then everything has performed OK! So, we can
           ; keep the created instance as "In Use" and set the pointers
           ; to the methods and properties of the DataBlock object:
           
           *Entry\Methods\Members = @DataBlock_Members()
           *Entry\Methods\TotalSize = @DataBlock_TotalSize()
           *Entry\Methods\DataSize = @DataBlock_DataSize()
           *Entry\Methods\GetFldIndex = @DataBlock_GetFldIndex()
           *Entry\Methods\GetFldName = @DataBlock_GetFldName()
           *Entry\Methods\iGetFldType = @DataBlock_iGetFldType()
           *Entry\Methods\nGetFldType = @DataBlock_nGetFldType()
           *Entry\Methods\iGetFldSize = @DataBlock_iGetFldSize()
           *Entry\Methods\nGetFldSize = @DataBlock_nGetFldSize()
           *Entry\Methods\iGetFldPtr = @DataBlock_iGetFldPtr()
           *Entry\Methods\nGetFldPtr = @DataBlock_nGetFldPtr()
           *Entry\Methods\iGetFldObj = @DataBlock_iGetFldObj()
           *Entry\Methods\nGetFldObj = @DataBlock_nGetFldObj()
           *Entry\Methods\Destroy = @DataBlock_Destroy()
           
           *Entry\Properties\Members = Members.l
           *Entry\Properties\TotalSize = DataOffset.l 
           *Entry\Properties\DataSize = DataOffset.l - HeaderOffset.l
           *Entry\Properties\MemoryBlock = *MemoryBlock.l
           
           *Entry\Object\Methods = @*Entry\Methods
           *Entry\Object\Properties = @*Entry\Properties
           
           *Object = @*Entry\Object
           
           *Entry\Status = #lTrue
           
           Else
           
           SafeFree(*Entry)
           
        EndIf
        
        Else
        
        ; Could not create a new element in the DataBlock
        ; instances linked list. Exit returning null pointer.
        
        *Error\Log(#KNL_INT_DBCREATE, "") ; Could not create a DataBlock recipient!
        
     EndIf
     
   LeaveCriticalSection_(@DBO_CS) ;/ Critical Section
   
   ProcedureReturn *Object
   
EndProcedure

;{/ Bézier Spline Object
;{- Methods Definition:
Procedure.l Construct_Spline(Knots.l, Whole.f, Piece.f, Blender.l)
   
   Define.Spline_Object *Object
   Define.Spline_Holder *Entry
   Define.DataBlock DB
   
   Define.l Segments, Points
   Define.s Members, Pts, Knt, Seg
   
   EnterCriticalSection_(@BSO_CS) ;/ Critical Section
     
     If Knots.l > 2
        
        ; Seek for an empty slot within Spline instances
        ; linked list. If no empty slot is found, then
        ; try to create a new one:
        
        *Entry = SafeAlloc(SizeOf(Spline_Holder))
        
        If *Entry 
           
           *Entry\Properties\Instance = *Entry
           
           Points.l = Knots.l + Blender.l
           
           Segments.l = (Whole.f / Piece.f) + 1
           
           EnterCriticalSection_(@STR_CS) ;/ Critical Section
             
             Pts.s = StrU(Points.l, #PB_Long)
             Knt.s = StrU(Knots.l, #PB_Long)
             Seg.s = StrU(Segments.l, #PB_Long)
             
             Members.s = "Knots.l.[" + Pts.s + "]|"
             Members.s + "iX.f.[" + Knt.s + "]|"
             Members.s + "iY.f.[" + Knt.s + "]|"
             Members.s + "iZ.f.[" + Knt.s + "]|"
             Members.s + "oX.f.[" + Seg.s + "]|"
             Members.s + "oY.f.[" + Seg.s + "]|"
             Members.s + "oZ.f.[" + Seg.s + "]"
             
           LeaveCriticalSection_(@STR_CS) ;/ Critical Section
           
           DB = Construct_DataBlock(Members.s)
           
           If DB
              
              *Entry\Methods\SetKnot = @Spline_SetKnot()
              *Entry\Methods\Calculate = @Spline_Calculate()
              *Entry\Methods\GetX = @Spline_GetX()
              *Entry\Methods\GetY = @Spline_GetY()
              *Entry\Methods\GetZ = @Spline_GetZ()
              *Entry\Methods\Destroy = @Spline_Destroy()
              
              *Entry\Properties\Knots = Knots.l
              *Entry\Properties\Blender = Blender.l
              *Entry\Properties\Whole = Whole.f
              *Entry\Properties\Piece = Piece.f
              *Entry\Properties\Points = Points.l
              *Entry\Properties\Segments = Segments.l
              *Entry\Properties\DB = DB
              
              *Entry\Object\Methods = @*Entry\Methods
              *Entry\Object\Properties = @*Entry\Properties
              
              *Object = @*Entry\Object
              
              Else
              
              SafeFree(*Entry)
              
           EndIf
           
           Else
           
           ; Could not create a new element in the Spline
           ; instances linked list. Exit returning null.
           
           *Error\Log(#KNL_INT_BSPLINECREATE, "") ; Could not create a Spline recipient!
           
        EndIf
        
     EndIf
     
   LeaveCriticalSection_(@BSO_CS) ;/ Critical Section
   
   ProcedureReturn *Object
   
EndProcedure

Procedure.f Spline_GetX(*Obj.Spline_Object, Point.l)
   
   Define.DataBlock DB
   Define.Float_Field Fld
   Define.f X
   
   DB = *Obj\Properties\DB
   Fld = DB\iGetFldObj(4)
   
   Fld\SelectElement(Point.l)
   X.f = Fld\Get()
   Fld\Destroy()
   
   ProcedureReturn X.f
   
EndProcedure
Procedure.f Spline_GetY(*Obj.Spline_Object, Point.l)
   
   Define.DataBlock DB
   Define.Float_Field Fld
   Define.f Y
   
   DB = *Obj\Properties\DB
   Fld = DB\iGetFldObj(5)
   
   Fld\SelectElement(Point.l)
   Y.f = Fld\Get()
   Fld\Destroy()
   
   ProcedureReturn Y.f
   
EndProcedure
Procedure.f Spline_GetZ(*Obj.Spline_Object, Point.l)
   
   Define.DataBlock DB
   Define.Float_Field Fld
   Define.f Z
   
   DB = *Obj\Properties\DB
   Fld = DB\iGetFldObj(6)
   
   Fld\SelectElement(Point.l)
   Z.f = Fld\Get()
   Fld\Destroy()
   
   ProcedureReturn Z.f
   
EndProcedure

Procedure.f Spline_Blend(*Obj.Spline_Object, K.l, T.l, V.f)
   
   Define.DataBlock DB
   Define.f Blend
   Define.Long_Field Ka, Kb, Kc, Kd
   
   DB = *Obj\Properties\DB
   
   ; Several references to the array of Knots:
   
   Ka = DB\iGetFldObj(0)
   Kb = DB\iGetFldObj(0)
   Kc = DB\iGetFldObj(0)
   Kd = DB\iGetFldObj(0)
   
   If T.l = 1
      
      Ka\SelectElement(K.l)
      Kb\SelectElement(K.l + 1)
      
      If (Ka\Get() <= Int(V.f)) And (Int(V.f) < Kb\Get())
         Blend.f = 1
         Else
         Blend.f = 0
      EndIf
      
      Else
      
      Ka\SelectElement(K.l)
      Kb\SelectElement(K.l + 1)
      Kc\SelectElement(K.l + T.l - 1)
      Kd\SelectElement(K.l + T.l)
      
      If Ka\Get() = Kc\Get() And Kb\Get() = Kd\Get()
         Blend.f = 0
      ElseIf (Ka\Get() = Kc\Get())
         Blend.f = (Kd\Get() - V.f) / (Kd\Get() - Kb\Get()) * Spline_Blend(*Obj, K.l + 1, T.l - 1, V.f)
      ElseIf (Kb\Get() = Kd\Get())
         Blend.f = (V.f - Ka\Get()) / (Kc\Get() - Ka\Get()) * Spline_Blend(*Obj, K.l, T.l - 1, V.f)
      Else
         Blend.f = (V.f - Ka\Get()) / (Kc\Get() - Ka\Get()) * Spline_Blend(*Obj, K.l, T.l - 1, V.f)
         Blend.f + (Kd\Get() - V.f) / (Kd\Get() - Kb\Get()) * Spline_Blend(*Obj, K.l + 1, T.l - 1, V.f)
      EndIf
      
   EndIf
   
   Ka\Destroy()
   Kb\Destroy()
   Kc\Destroy()
   Kd\Destroy()
   
   ProcedureReturn Blend.f
   
EndProcedure

Procedure Spline_SetKnot(*Obj.Spline_Object, Knot.l, X.f, Y.f, Z.f)
   
   Define.DataBlock DB
   Define.Float_Field iX, iY, iZ
   Define.l K
   
   DB = *Obj\Properties\DB
   
   K.l = Knot.l
   
   iX = DB\iGetFldObj(1) ; iX.f.[Knots]
   iY = DB\iGetFldObj(2) ; iY.f.[Knots]
   iZ = DB\iGetFldObj(3) ; iZ.f.[Knots]
   
   iX\SelectElement(K.l): iX\Set(X.f): iX\Destroy()
   iY\SelectElement(K.l): iY\Set(Y.f): iY\Destroy()
   iZ\SelectElement(K.l): iZ\Set(Z.f): iZ\Destroy()
   
EndProcedure
Procedure Spline_Calculate(*Obj.Spline_Object)
   
   Define.DataBlock DB
   
   Define.Long_Field Knot
   Define.Float_Field iX, iY, iZ
   Define.Float_Field oX, oY, oZ
   
   Define.l Idx, P, n, T, R
   Define.f Interval, Increment
   
   DB = *Obj\Properties\DB
   
   Knot = DB\iGetFldObj(0)
   
   If Knot
      
      P = *Obj\Properties\Points - 1
      N = *Obj\Properties\Knots - 1
      T = *Obj\Properties\Blender
      R = *Obj\Properties\Segments - 1
      
      For Idx.l = 0 To P
          
          Knot\SelectElement(Idx.l)
          
          If Idx.l < T
             Knot\Set(0)
          ElseIf Idx.l <= N
             Knot\Set(Idx.l - T + 1)
          ElseIf Idx.l > N
             Knot\Set(N - T + 2)
          EndIf
          
      Next
      
      Interval.f = 0
      Increment.f = (N - T + 2) / R
      
      For Idx.l = 0 To R
          Spline_Point(*Obj, N, T, Interval.f, Idx.l)
          Interval.f + Increment.f
      Next 
      
      iX = DB\iGetFldObj(1): iX\SelectElement(N)
      iY = DB\iGetFldObj(2): iY\SelectElement(N)
      iZ = DB\iGetFldObj(3): iY\SelectElement(N)
      
      oX = DB\iGetFldObj(4): oX\SelectElement(R): oX\Set(iX\Get())
      oY = DB\iGetFldObj(5): oY\SelectElement(R): oY\Set(iY\Get())
      oZ = DB\iGetFldObj(6): oZ\SelectElement(R): oZ\Set(iZ\Get())
      
      iX\Destroy(): oX\Destroy()
      iY\Destroy(): oY\Destroy()
      iZ\Destroy(): oZ\Destroy()
      
      Knot\Destroy()
      
   EndIf
   
EndProcedure
Procedure Spline_Point(*Obj.Spline_Object, n.l, T.l, V.f, K.l)
   
   Define.l Idx
   Define.f Blend
   
   Define.DataBlock DB
   Define.Float_Field iX, iY, iZ
   Define.Float_Field oX, oY, oZ
   
   DB = *Obj\Properties\DB
   
   iX = DB\iGetFldObj(1)
   iY = DB\iGetFldObj(2)
   iZ = DB\iGetFldObj(3)
   
   oX = DB\iGetFldObj(4): oX\SelectElement(K.l): oX\Set(0)
   oY = DB\iGetFldObj(5): oY\SelectElement(K.l): oY\Set(0)
   oZ = DB\iGetFldObj(6): oZ\SelectElement(K.l): oZ\Set(0)
   
   For Idx.l = 0 To N.l
       
       iX\SelectElement(Idx.l)
       iY\SelectElement(Idx.l)
       iZ\SelectElement(Idx.l)
       
       Blend.f = Spline_Blend(*Obj, Idx.l, T.l, V.f)
       
       oX\Set(oX\Get() + iX\Get() * Blend.f)
       oY\Set(oY\Get() + iY\Get() * Blend.f)
       oZ\Set(oZ\Get() + iZ\Get() * Blend.f)
       
   Next
   
   iX\Destroy(): oX\Destroy()
   iY\Destroy(): oY\Destroy()
   iZ\Destroy(): oZ\Destroy()
   
EndProcedure

Procedure Spline_Destroy(*Obj.Spline_Object)
   
   Define.DataBlock DB
   
   EnterCriticalSection_(@BSO_CS) ;/ Critical Section
     
     DB = *Obj\Properties\DB 
     
     If DB: DB\Destroy(): EndIf
     
     SafeFree(*Obj\Properties\Instance)
     
     *Obj = *NullPointer.l
     
   LeaveCriticalSection_(@BSO_CS) ;/ Critical Section
   
EndProcedure
;}
;}

; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 25
; Folding = ---
; EnableXP