
CompilerIf 0 
  
Declare iAddShadowLightXEffect(x.F, y.F, z.F, tx.F=0, ty.F=0, tz.F=0, color.l=$FFFFFFFF, nearValue.F=10.0,  farValue.F=230.0, fov.F=90.0, shadowDimen.l=512, directionnal.b=#False)
Declare.s NameNumeric( val.l)
Declare.s iText(*adr)
Declare.l iCreateGraphics3DWin(width.l, height.l, VSync.c=#True, dType.l = #EDT_OPENGL , title.s = "N3XTD Engine",const.l= #PB_Window_SystemMenu | #PB_Window_ScreenCentered , physic.b=#True)
Declare.l iGraphics3DGadget(width.l, height.l, hWnd.l, dType.l = #EDT_OPENGL, VSync.c=#True, physic.b=#True )
Declare.l iCreateGraphics3D(width.l, height.l, Depth.l=32, fullscreen.c=#False, sync.c=#True, dType.l = #EDT_OPENGL, DepthBufferFormat.c = #True, physic.b=#True )
Declare.F Plane_getDistance(*plane.iPLANE, *p1.iVECTOR3)
Declare Plane_setPlane(*plane.iPLANE, *p1.iVECTOR3,  *n.iVECTOR3)
Declare Plane_recalculateD(*plane.iPLANE, *MPoint.iVECTOR3)
Declare Plane_getMemberPoint(*vec.iVECTOR3, *plan.iPLANE)
Declare PLANE_(dest,  dd, nx, ny, nz)
Declare.l Matrix_Transpose( *out.iMATRIX) 
Declare.l Matrix_GetInverse( *out.iMATRIX, *M.iMATRIX) 
Declare Matrix_TranslateVect(*M.iMATRIX, *vect.iVECTOR3 )
Declare Matrix_TransformPlane( *plane.iPLANE, *M.iMATRIX)
Declare Matrix_TransformVectV(*out.iVECTOR3, *in.iVECTOR3, *M.iMATRIX )
Declare Matrix_TransformVect(*vect.iVECTOR3, *M.iMATRIX )
Declare Matrix_RotateVect(*M.iMATRIX, *rotation.iVECTOR3)
Declare Matrix_GetRotation(*rotation.iVECTOR3, *M.iMATRIX)
Declare Matrix_SetRotationDegrees(*M.iMATRIX, *rotation.iVECTOR3)
Declare Matrix_SetRotation(*M.iMATRIX, *rotation.iVECTOR3)
Declare Matrix_SetScale(*M.iMATRIX, *des.iVECTOR3)
Declare Matrix_GetScale(*des.iVECTOR3, *M.iMATRIX)
Declare Matrix_SetTranslation(*M.iMATRIX, *des.iVECTOR3)
Declare Matrix_GetTranslation(*des.iVECTOR3, *M.iMATRIX)
Declare Matrix_Mul(*m3.iMATRIX, *m1.iMATRIX, *m2.iMATRIX)
Declare Matrix_MulF(*des.iMATRIX, *m1.iMATRIX, scalar.F)
Declare Matrix_Sub(*des.iMATRIX, *m1.iMATRIX, *m2.iMATRIX)
Declare Matrix_Add(*des.iMATRIX, *m1.iMATRIX, *m2.iMATRIX)
Declare Matrix_Equals(*des.iMATRIX, *m1.iMATRIX)
Declare Matrix_Identity(*mat.iMATRIX)
Declare Vec2_Rotate(angle.F, *vec.iVECTOR2, *center.iVECTOR2)
Declare Vec2_Invert(*vec1.iVECTOR2)
Declare Vec2_SetLength(*vec1.iVECTOR2, newLength.F)
Declare Vec2_Normalize(*vec1.iVECTOR2)
Declare.F Vec2_GetDistanceFrom(*vec1.iVECTOR2, *vec2.iVECTOR2)
Declare.F Vec2_GetLength(*vec1.iVECTOR2)
Declare.F Vec2_DotProduct(*vec1.iVECTOR2, *vec2.iVECTOR2)
Declare Vec2_MulF(*res.iVECTOR2, *vec1.iVECTOR2, length.F)
Declare Vec2_Mul(*res.iVECTOR2, *vec1.iVECTOR2, *vec2.iVECTOR2)
Declare Vec2_Sub(*res.iVECTOR2, *vec1.iVECTOR2, *vec2.iVECTOR2)
Declare Vec2_Add(*res.iVECTOR2, *vec1.iVECTOR2, *vec2.iVECTOR2)
Declare.l Vec2_isEquals(*vec1.iVECTOR2, *vec2.iVECTOR2)
Declare.l Vec2_Equals(*vec1.iVECTOR2, *vec2.iVECTOR2)
Declare VECTOR2_(dest,v1,v2)
Declare AABBox_xform( *out.AABBOX, *in.AABBOX, *M.iMATRIX)
Declare.l AABBox_isPointInside( *box.AABBOX, x.f, y.f, z.f)
Declare AABBox_AddPoint( *box.AABBOX, x.f, y.f, z.f)
Declare AABBox_Extend(*ext.iVECTOR3, *box.AABBOX)
Declare AABBox_Center(*center.iVECTOR3, *box.AABBOX)
Declare AABBox_Set( *box.AABBOX, xmin.f, ymin.f, zmin.f, xmax.f, ymax.f, zmax.f)
Declare.f ATan2(y.f, x.f)
Declare RAD2DEG(val)	
Declare DEG2RAD(val)
Declare Vec3_RotationToDirection(*res.iVECTOR3, *vec.iVECTOR3, *forwards.iVECTOR3)
Declare Vec3_GetHorizontalAngle(*angle.iVECTOR3, *vec.iVECTOR3)
Declare Vec3_RotateYZ(angle.f, *vec.iVECTOR3, *center.iVECTOR3)
Declare Vec3_RotateXY(angle.f, *vec.iVECTOR3, *center.iVECTOR3)
Declare Vec3_RotateXZ(angle.f, *vec.iVECTOR3, *center.iVECTOR3)
Declare Vec3_Invert(*vec1.iVECTOR3)
Declare Vec3_SetLength(*vec1.iVECTOR3, newLength.f)
Declare Vec3_Normalize(*vec1.iVECTOR3)
Declare.F Vec3_GetDistanceFrom(*vec1.iVECTOR3, *vec2.iVECTOR3)
Declare.F Vec3_GetLength(*vec1.iVECTOR3)
Declare.F Vec3_DotProduct(*vec1.iVECTOR3, *vec2.iVECTOR3)
Declare Vec3_CrossProduct(*res.iVECTOR3, *vec1.iVECTOR3, *vec2.iVECTOR3)
Declare Vec3_MulF(*res.iVECTOR3, *vec1.iVECTOR3, length.F)
Declare Vec3_Div(*res.iVECTOR3, *vec1.iVECTOR3, *vec2.iVECTOR3)
Declare Vec3_Mul(*res.iVECTOR3, *vec1.iVECTOR3, *vec2.iVECTOR3)
Declare Vec3_Sub(*res.iVECTOR3, *vec1.iVECTOR3, *vec2.iVECTOR3)
Declare Vec3_AddF(*res.iVECTOR3, *vec1.iVECTOR3, x.F, y.F, z.F)
Declare Vec3_Add(*res.iVECTOR3, *vec1.iVECTOR3, *vec2.iVECTOR3)
Declare.l Vec3_isEquals(*vec1.iVECTOR3, *vec2.iVECTOR3)
Declare.l Vec3_Equals(*vec1.iVECTOR3, *vec2.iVECTOR3)
Declare Vec3_Zero(*res.iVECTOR3)

; ------------------------------------------------------------
;
;   PureBasic - n3xt-D 1.0 version
;
;    (c) 2009 - www.n3xt-D.org
;
; revision 010 date: 28-mars-09 by TMyke
; ------------------------------------------------------------




;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Rendering Device Types
Enumeration ;DEVICE_TYPES
    #EDT_NULL = 0            ; a NULL device With no display
    #EDT_SOFTWARE            ; Irrlichts Default software renderer
    #EDT_SOFTWARE2           ; An improved quality software renderer
    #EDT_DIRECT3D8           ; not use, obselet
    #EDT_DIRECT3D9           ; hardware accelerated DirectX 9 renderer
    #EDT_OPENGL              ; hardware accelerated OpenGL renderer
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; An enumeration for all types of automatic culling for built-in scene nodes. 
  #EAC_OFF = 0
  #EAC_BOX = 1
  #EAC_FRUSTUM_BOX = 2
  #EAC_FRUSTUM_SPHERE = 4 ; not used
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Vertex type
Enumeration
#EVT_STANDART = 0
#EVT_2TCOORDS
#EVT_TANGENTS
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; MOUSE Type Event
Enumeration ;MOUSE_EVENT
    #MOUSE_BUTTON_NULL = 0             
    #MOUSE_BUTTON_LEFT
    #MOUSE_BUTTON_RIGHT
    #MOUSE_BUTTON_MIDDLE
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;Enumeration For key actions. Used For example in the fps Camera.  
Enumeration       
#EKA_MOVE_FORWARD   
#EKA_MOVE_BACKWARD   
#EKA_STRAFE_LEFT   
#EKA_STRAFE_RIGHT   
#EKA_COUNT   
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*



;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enumeration ; EKEY_CODE
#KEY_LBUTTON          = $01  ; Left mouse button  
#KEY_RBUTTON          = $02  ; Right mouse button  
#KEY_CANCEL           = $03  ; Control-Break processing  
#KEY_MBUTTON          = $04  ; Middle mouse button (three-button mouse)  
#KEY_XBUTTON1         = $05  ; Windows 2000/XP: X1 mouse button 
#KEY_XBUTTON2         = $06  ; Windows 2000/XP: X2 mouse button 
#KEY_BACK             = $08  ; BACKSPACE key  
#KEY_TAB              = $09  ; TAB key  
#KEY_CLEAR            = $0C  ; CLEAR key  
#KEY_RETURN           = $0D  ; ENTER key  
#KEY_SHIFT            = $10  ; SHIFT key  
#KEY_CONTROL          = $11  ; CTRL key  
#KEY_MENU             = $12  ; ALT key  
#KEY_PAUSE            = $13  ; PAUSE key  
#KEY_CAPITAL          = $14  ; CAPS LOCK key  
#KEY_KANA             = $15  ; IME Kana mode 
#KEY_HANGUEL          = $15  ; IME Hanguel mode (maintained For compatibility use KEY_HANGUL) 
#KEY_HANGUL           = $15  ; IME Hangul mode 
#KEY_JUNJA            = $17  ; IME Junja mode 
#KEY_FINAL            = $18  ; IME final mode 
#KEY_HANJA            = $19  ; IME Hanja mode 
#KEY_KANJI            = $19  ; IME Kanji mode 
#KEY_ESCAPE           = $1B  ; ESC key  
#KEY_CONVERT          = $1C  ; IME convert 
#KEY_NONCONVERT       = $1D  ; IME nonconvert 
#KEY_ACCEPT           = $1E  ; IME accept 
#KEY_MODECHANGE       = $1F  ; IME mode change request 
#KEY_SPACE            = $20  ; SPACEBAR  
#KEY_PRIOR            = $21  ; PAGE UP key  
#KEY_NEXT             = $22  ; PAGE DOWN key  
#KEY_END              = $23  ; End key  
#KEY_HOME             = $24  ; HOME key  
#KEY_ARROW_LEFT       = $25  ; LEFT ARROW key  
#KEY_ARROW_UP         = $26  ; UP ARROW key  
#KEY_ARROW_right      = $27  ; RIGHT ARROW key  
#KEY_ARROW_DOWN       = $28  ; DOWN ARROW key  
#KEY_SELECT           = $29  ; Select key  
#KEY_PRINT            = $2A  ; PRINT key
#KEY_EXECUT           = $2B  ; EXECUTE key  
#KEY_SNAPSHOT         = $2C  ; PRINT SCREEN key  
#KEY_INSERT           = $2D  ; INS key  
#KEY_DELETE           = $2E  ; DEL key  
#KEY_HELP             = $2F  ; HELP key  
#KEY_KEY_0            = $30  ; 0 key  
#KEY_KEY_1            = $31  ; 1 key  
#KEY_KEY_2            = $32  ; 2 key  
#KEY_KEY_3            = $33  ; 3 key  
#KEY_KEY_4            = $34  ; 4 key  
#KEY_KEY_5            = $35  ; 5 key  
#KEY_KEY_6            = $36  ; 6 key  
#KEY_KEY_7            = $37  ; 7 key  
#KEY_KEY_8            = $38  ; 8 key  
#KEY_KEY_9            = $39  ; 9 key  
#KEY_KEY_A            = $41  ; A key  
#KEY_KEY_B            = $42  ; B key  
#KEY_KEY_C            = $43  ; C key  
#KEY_KEY_D            = $44  ; D key  
#KEY_KEY_E            = $45  ; E key  
#KEY_KEY_F            = $46  ; F key  
#KEY_KEY_G            = $47  ; G key  
#KEY_KEY_H            = $48  ; H key  
#KEY_KEY_I            = $49  ; I key  
#KEY_KEY_J            = $4A  ; J key  
#KEY_KEY_K            = $4B  ; K key  
#KEY_KEY_L            = $4C  ; L key  
#KEY_KEY_M            = $4D  ; M key  
#KEY_KEY_N            = $4E  ; N key  
#KEY_KEY_O            = $4F  ; O key  
#KEY_KEY_P            = $50  ; P key  
#KEY_KEY_Q            = $51  ; Q key  
#KEY_KEY_R            = $52  ; R key  
#KEY_KEY_S            = $53  ; S key  
#KEY_KEY_T            = $54  ; T key  
#KEY_KEY_U            = $55  ; U key  
#KEY_KEY_V            = $56  ; V key  
#KEY_KEY_W            = $57  ; W key  
#KEY_KEY_X            = $58  ; X key  
#KEY_KEY_Y            = $59  ; Y key  
#KEY_KEY_Z            = $5A  ; Z key  
#KEY_LWIN             = $5B  ; Left Windows key (Microsoft® Natural® keyboard)  
#KEY_RWIN             = $5C  ; Right Windows key (Natural keyboard)  
#KEY_APPS             = $5D  ; Applications key (Natural keyboard)  
#KEY_SLEEP            = $5F  ; Computer Sleep key 
#KEY_NUMPAD0          = $60  ; Numeric keypad 0 key  
#KEY_NUMPAD1          = $61  ; Numeric keypad 1 key  
#KEY_NUMPAD2          = $62  ; Numeric keypad 2 key  
#KEY_NUMPAD3          = $63  ; Numeric keypad 3 key  
#KEY_NUMPAD4          = $64  ; Numeric keypad 4 key  
#KEY_NUMPAD5          = $65  ; Numeric keypad 5 key  
#KEY_NUMPAD6          = $66  ; Numeric keypad 6 key  
#KEY_NUMPAD7          = $67  ; Numeric keypad 7 key  
#KEY_NUMPAD8          = $68  ; Numeric keypad 8 key  
#KEY_NUMPAD9          = $69  ; Numeric keypad 9 key  
#KEY_MULTIPLY         = $6A  ; Multiply key  
#KEY_ADD              = $6B  ; Add key  
#KEY_SEPARATOR        = $6C  ; Separator key  
#KEY_SUBTRACT         = $6D  ; Subtract key  
#KEY_DECIMAL          = $6E  ; Decimal key  
#KEY_DIVIDE           = $6F  ; Divide key  
#KEY_F1               = $70  ; F1 key  
#KEY_F2               = $71  ; F2 key  
#KEY_F3               = $72  ; F3 key  
#KEY_F4               = $73  ; F4 key  
#KEY_F5               = $74  ; F5 key  
#KEY_F6               = $75  ; F6 key  
#KEY_F7               = $76  ; F7 key  
#KEY_F8               = $77  ; F8 key  
#KEY_F9               = $78  ; F9 key  
#KEY_F10              = $79  ; F10 key  
#KEY_F11              = $7A  ; F11 key  
#KEY_F12              = $7B  ; F12 key  
#KEY_F13              = $7C  ; F13 key  
#KEY_F14              = $7D  ; F14 key  
#KEY_F15              = $7E  ; F15 key  
#KEY_F16              = $7F  ; F16 key  
#KEY_F17              = $80  ; F17 key  
#KEY_F18              = $81  ; F18 key  
#KEY_F19              = $82  ; F19 key  
#KEY_F20              = $83  ; F20 key  
#KEY_F21              = $84  ; F21 key  
#KEY_F22              = $85  ; F22 key  
#KEY_F23              = $86  ; F23 key  
#KEY_F24              = $87  ; F24 key  
#KEY_NUMLOCK          = $90  ; NUM LOCK key  
#KEY_SCROLL           = $91  ; SCROLL LOCK key  
#KEY_LSHIFT           = $A0  ; Left SHIFT key 
#KEY_RSHIFT           = $A1  ; Right SHIFT key 
#KEY_LCONTROL         = $A2  ; Left CONTROL key 
#KEY_RCONTROL         = $A3  ; Right CONTROL key 
#KEY_LMENU            = $A4  ; Left MENU key 
#KEY_RMENU            = $A5  ; Right MENU key 
#KEY_PLUS             = $BB  ; Plus Key   (+)
#KEY_COMMA            = $BC  ; Comma Key  (,)
#KEY_MINUS            = $BD  ; Minus Key  (-)
#KEY_PERIOD           = $BE  ; Period Key (.)
#KEY_ATTN             = $F6  ; Attn key 
#KEY_CRSEL            = $F7  ; CrSel key 
#KEY_EXSEL            = $F8  ; ExSel key 
#KEY_EREOF            = $F9  ; Erase EOF key 
#KEY_PLAY             = $FA  ; Play key 
#KEY_ZOOM             = $FB  ; Zoom key 
#KEY_PA1              = $FD  ; PA1 key 
#KEY_OEM_CLEAR        = $FE   ; Clear key 

#KEY_KEY_CODES_COUNT  = $FF ; this is Not a key, but the amount of keycodes there are.
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; type of node
#ESNT_CUBE                = 1700951395;('c','u','b','e'),
#ESNT_SPHERE              = 1919447155;('s','p','h','r'),
#ESNT_TEXT                = 1954047348;('t','e','x','t'),
#ESNT_WATER_SURFACE       = 1920229751;('w','a','t','r'), 
#ESNT_TERRAIN             = 1920099700;('t','e','r','r'),
#ESNT_SKY_BOX             = 1601792883;('s','k','y','_'),
#ESNT_SHADOW_VOLUME       = 2003069043;('s','h','d','w'),
#ESNT_OCT_TREE            = 1953784687;('o','c','t','t'),
#ESNT_MESH                = 1752393069;('m','e','s','h'),
#ESNT_LIGHT               = 1952999276;('l','g','h','t'),
#ESNT_EMPTY               = 2037673317;('e','m','t','y'),
#ESNT_DUMMY_TRANSFORMATION= 2037214564;('d','m','m','y'),
#ESNT_CAMERA              = 1601003875;('c','a','m','_'),
#ESNT_BILLBOARD           = 1819044194;('b','i','l','l'),
#ESNT_ANIMATED_MESH       = 1752395105;('a','m','s','h'),
#ESNT_PARTICLE_SYSTEM     = 1818457200;('p','t','c','l'),
#ESNT_MD3_SCENE_NODE      = 1597203565;('m','d','3','_'),
#ESNT_UNKNOWN             = 1852534389;('u','n','k','n'),
#ESNT_ANY                 = 1601793633;('a','n','y','_')
#ESNT_CONE                = 1701736291;('c','o','n','e'),
#ESNT_CYLINDER            = 1600944483;('c','y','l','_'),
#ESNT_CONSTRUCT           = 1936617315;('c','o','n','s')
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; type picking 
#ENT_PICKBOX				=	$00
#ENT_PICKFACE				= $01
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Hardware Mapping type
Enumeration
#EHM_NEVER  = 0   ;Don't load in hardware.  
#EHM_STATIC       ;Rarely changed.  
#EHM_DYNAMIC      ;Sometimes changed.  
#EHM_STREAM       ;Always changed.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Hardware Mapping type
Enumeration
#EJUOR_NONE = 0  ;do nothing  
#EJUOR_READ      ;get joints positions from the mesh (For attached nodes, etc)  
#EJUOR_CONTROL   ;control joint positions in the mesh (eg. ragdolls, Or set the animation from animateJoints() )  
#EJUOR_COUNT     ;count of all available interpolation modes  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; text alignment
Enumeration
#EGUIA_UPPERLEFT=0  ;Aligned To parent's top or left side (default).  
#EGUIA_LOWERRIGHT  ;Aligned To parent's bottom or right side.  
#EGUIA_CENTER  ;Aligned To the center of parent.  
#EGUIA_SCALE  ;Stretched To fit parent.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Dirty type 
Enumeration
#EBT_NONE   = 0
#EBT_VERTEX 
#EBT_INDEX
#EBT_VERTEX_AND_INDEX
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; 
Enumeration
#EGBS_BUTTON_UP=0  ;The button is Not pressed.  
#EGBS_BUTTON_DOWN  ;The button is currently pressed down.  
#EGBS_BUTTON_MOUSE_OVER  ;The mouse cursor is over the button.  
#EGBS_BUTTON_MOUSE_OFF  ;The mouse cursor is Not over the button.  
#EGBS_BUTTON_FOCUSED  ;The button has the focus.  
#EGBS_BUTTON_NOT_FOCUSED  ;The button doesn't have the focus.  
#EGBS_COUNT  ;Not used, counts the number of enumerated items  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; type of node object
#ENT_CUBE                = $01
#ENT_SPHERE              = $02
#ENT_TEXT                = $03
#ENT_CONE                = $04
#ENT_CYLINDER            = $05
#ENT_WATER_SURFACE       = $07
#ENT_MESH                = $08
#ENT_EMPTY               = $09
#ENT_BILLBOARD           = $0A
#ENT_PARTICLE_SYSTEM     = $0B
#ENT_MD3_SCENE_NODE      = $0F
#ENT_TERRAIN             = $10
#ENT_SKY_BOX             = $20
#ENT_SHADOW_VOLUME       = $30
#ENT_OCT_TREE            = $50
#ENT_LIGHT               = $60
#ENT_CAMERA              = $70
#ENT_ANIMATED_MESH       = $80
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; debug mode
#EDS_OFF                = 0 ;No Debug Data ( Default )<br>  
#EDS_BBOX               = 1 ;Show Bounding Boxes of SceneNode<br>  
#EDS_NORMALS            = 2 ;Show Vertex Normals<br>  
#EDS_SKELETON           = 4 ;Shows Skeleton/Tags<br>  
#EDS_MESH_WIRE_OVERLAY  = 8 ;Overlays Mesh Wireframe<br>  
#EDS_HALF_TRANSPARENCY  = 16;Temporary use transparency Material Type<br>  
#EDS_BBOX_BUFFERS       = 32;Show Bounding Boxes of all MeshBuffers<br>
#EDS_BBOX_ALL           = 33;EDS_BBOX | EDS_BBOX_BUFFERS<br>  
#EDS_FULL               = $FFFFFFFF; Show all Debug infos.  
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; MATERIAL flag
#EMF_WIREFRAME            = 0
#EMF_POINTCLOUD           = 2 
#EMF_GOURAUD_SHADING      = 4
#EMF_LIGHTING             = 8
#EMF_ZBUFFER              = $10
#EMF_ZWRITE_ENABLE        = $20
#EMF_BACK_FACE_CULLING    = $40
#EMF_FRONT_FACE_CULLING   = $80
#EMF_BILINEAR_FILTER      = $100
#EMF_TRILINEAR_FILTER     = $200
#EMF_ANISOTROPIC_FILTER   = $400
#EMF_FOG_ENABLE           = $800
#EMF_NORMALIZE_NORMALS    = $1000
#EMF_TEXTURE_WRAP         = $2000
#EMF_ANTI_ALIASING        = $4000
#EMF_COLOR_MASK           = $8000
#EMF_COLOR_MATERIAL       = $10000
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;Compiletarget for Pixel-Shader
Enumeration
#EFT_FOG_EXP   = 0
#EFT_FOG_LINEAR   
#EFT_FOG_EXP2   
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; TEXTURE CLAMP
#ETC_REPEAT = 0
#ETC_CLAMP=1
#ETC_CLAMP_TO_EDGE=2
#ETC_CLAMP_TO_BORDER=3
#ETC_MIRROR=4
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; MATERIAL TYPES
#EMT_SOLID                                  =0
#EMT_SOLID_2_LAYER                          =1
#EMT_LIGHTMAP                               =2
#EMT_LIGHTMAP_ADD                           =3
#EMT_LIGHTMAP_M2                            =4
#EMT_LIGHTMAP_M4                            =5
#EMT_LIGHTMAP_LIGHTING                      =6
#EMT_LIGHTMAP_LIGHTING_M2                   =7
#EMT_LIGHTMAP_LIGHTING_M4                   =8
#EMT_DETAIL_MAP                             =9
#EMT_SPHERE_MAP                             =10
#EMT_REFLECTION_2_LAYER                     =11
#EMT_TRANSPARENT_ADD_COLOR                  =12
#EMT_TRANSPARENT_ALPHA_CHANNEL              =13
#EMT_TRANSPARENT_ALPHA_CHANNEL_REF          =14
#EMT_TRANSPARENT_VERTEX_ALPHA               =15
#EMT_TRANSPARENT_REFLECTION_2_LAYER         =16
#EMT_NORMAL_MAP_SOLID                       =17
#EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR       =18
#EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA    =19
#EMT_PARALLAX_MAP_SOLID                     =20
#EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR     =21
#EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA  =22
#EMT_ONETEXTURE_BLEND                       =23
#EMT_FORCE_32BIT                            =$7FFFFFFF
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; light types
#ELT_POINT        = 0 
#ELT_SPOT         = 1 
#ELT_DIRECTIONAL  = 2 
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; light types
#ECF_A1R5G5B5 = 0
#ECF_R5G6B5   = 1
#ECF_R8G8B8   = 2
#ECF_A8R8G8B8 = 3
#ECF_R16F = 4
#ECF_G16R16F = 5
#ECF_A16B16G16R16F = 6
#ECF_R32F = 7
#ECF_G32R32F = 8
#ECF_A32B32G32R32F = 9
#ECF_UNKNOWN = 10
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;Compiletarget for Pixel-Shader
Enumeration
#EPST_PS_1_1  = 0 
#EPST_PS_1_2   
#EPST_PS_1_3   
#EPST_PS_1_4   
#EPST_PS_2_0   
#EPST_PS_2_a   
#EPST_PS_2_b   
#EPST_PS_3_0  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;Compiletarget for Vertex-Shader
Enumeration
#EVST_VS_1_1  = 0 
#EVST_VS_2_0   
#EVST_VS_2_a   
#EVST_VS_3_0  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enumeration 
#ETS_VIEW       ;View transformation.  
#ETS_WORLD      ;World transformation.  
#ETS_PROJECTION ;Projection transformation.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enumeration
#EGDC_3D_DARK_SHADOW  ;Dark shadow For three-dimensional display elements.  
#EGDC_3D_SHADOW  ;Shadow color For three-dimensional display elements (For edges facing away from the light source).  
#EGDC_3D_FACE  ;Face color For three-dimensional display elements And For dialog box backgrounds.  
#EGDC_3D_HIGH_LIGHT  ;Highlight color For three-dimensional display elements (For edges facing the light source.).  
#EGDC_3D_LIGHT  ;Light color For three-dimensional display elements (For edges facing the light source.).  
#EGDC_ACTIVE_BORDER  ;Active window border.  
#EGDC_ACTIVE_CAPTION  ;Active window title bar text.  
#EGDC_APP_WORKSPACE  ;Background color of multiple document Interface (MDI) applications.  
#EGDC_BUTTON_TEXT  ;Text on a button.  
#EGDC_GRAY_TEXT  ;Grayed (disabled) text.  
#EGDC_HIGH_LIGHT  ;tem(s) selected in a control.  
#EGDC_HIGH_LIGHT_TEXT  ;Text of item(s) selected in a control.  
#EGDC_INACTIVE_BORDER  ;Inactive window border.  
#EGDC_INACTIVE_CAPTION  ;Inactive window caption.  
#EGDC_TOOLTIP  ;Tool tip text color.  
#EGDC_TOOLTIP_BACKGROUND  ;Tool tip background color.  
#EGDC_SCROLLBAR  ;Scrollbar gray area.  
#EGDC_WINDOW  ;Window background.  
#EGDC_WINDOW_SYMBOL  ;Window symbols like on close buttons, scroll bars And check boxes.  
#EGDC_ICON  ;Icons in a list Or tree.  
#EGDC_ICON_HIGH_LIGHT  ;Selected icons in a list Or tree.  
#EGDC_COUNT  ;this value is Not used, it only specifies the amount of Default colors available.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; type of FONT
Enumeration
#EGDF_DEFAULT  ;For Static text, edit boxes, lists And most other places.  
#EGDF_BUTTON  ;Font For buttons.  
#EGDF_WINDOW  ;Font For window title bars.  
#EGDF_MENU  ;Font For menu items.  
#EGDF_TOOLTIP  ;Font For tooltips.  
#EGDF_COUNT  ;this value is Not used, it only specifies the amount of Default fonts available.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*




;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; type of GUI
Enumeration
#EGUIET_BUTTON =0     ; A button (IGUIButton).  
#EGUIET_CHECK_BOX     ;A check Box (IGUICheckBox).  
#EGUIET_COMBO_BOX     ;A combo Box (IGUIComboBox).  
#EGUIET_CONTEXT_MENU  ;A context menu (IGUIContextMenu).  
#EGUIET_MENU          ; A menu (IGUIMenu).  
#EGUIET_EDIT_BOX      ;An edit Box (IGUIEditBox).  
#EGUIET_FILE_OPEN_DIALOG  ;A file open dialog (IGUIFileOpenDialog).  
#EGUIET_COLOR_SELECT_DIALOG  ;A color Select open dialog (IGUIColorSelectDialog).  
#EGUIET_IN_OUT_FADER  ;A in/out fader (IGUIInOutFader).  
#EGUIET_IMAGE         ;An image (IGUIImage).  
#EGUIET_LIST_BOX      ;A List Box (IGUIListBox).  
#EGUIET_MESH_VIEWER   ;A mesh viewer (IGUIMeshViewer).  
#EGUIET_MESSAGE_BOX   ;A message Box (IGUIWindow).  
#EGUIET_MODAL_SCREEN  ;A modal screen.  
#EGUIET_SCROLL_BAR    ;A scroll bar (IGUIScrollBar).  
#EGUIET_SPIN_BOX      ;A spin Box (IGUISpinBox).  
#EGUIET_STATIC_TEXT   ;A Static text (IGUIStaticText).  
#EGUIET_TAB           ;A tab (IGUITab).  
#EGUIET_TAB_CONTROL   ;A tab control.  
#EGUIET_TABLE         ;A Table.  
#EGUIET_TOOL_BAR      ;A tool bar (IGUIToolBar).  
#EGUIET_TREE_VIEW     ;A Tree View.  
#EGUIET_WINDOW        ;A window.  
#EGUIET_COUNT         ;Not an element, amount of elements in there.  
#EGUIET_ELEMENT       ;Unknown type.  
#EGUIET_FORCE_32_BIT  ;This enum is never used, it only forces the compiler To compile this Enumeration To 32 bit.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enumeration
#EGEIT_BUTTON_PANE_STANDARD = 0
#EGEIT_BUTTON_PANE_PRESSED
#EGEIT_SUNKEN_PANE_FLAT
#EGEIT_SUNKEN_PANE_SUNKEN
#EGEIT_WINDOW_BACKGROUND
#EGEIT_WINDOW_BACKGROUND_TITLEBAR
#EGEIT_MENU_PANE
#EGEIT_TOOLBAR
#EGEIT_TAB_BUTTON
#EGEIT_TAB_BODY
#EGEIT_COUNT
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
Enumeration ;enum EGUI_EVENT_TYPE
#EGET_ELEMENT_FOCUS_LOST = 0  ;0 A gui element has lost its focus. GUIEvent.Caller is losing the focus To GUIEvent.Element. If the event is absorbed then the focus will Not be changed. 
#EGET_ELEMENT_FOCUSED  ;1 A gui element has got the focus.If the event is absorbed then the focus will Not be changed. 
#EGET_ELEMENT_HOVERED  ;2 The mouse cursor hovered over a gui element.  
#EGET_ELEMENT_LEFT      ;3 The mouse cursor left the hovered element.  
#EGET_ELEMENT_CLOSED      ;4 An element would like To close. Windows And context menus use This event when they would like To close, This can be cancelled by absorbing the event. 

#EGET_BUTTON_CLICKED    ;5 A button was clicked.  
#EGET_SCROLL_BAR_CHANGED  ;6 A scrollbar has changed its position.  
#EGET_CHECKBOX_CHANGED    ;7 A checkbox has changed its check state.  
#EGET_LISTBOX_CHANGED     ;8 A new item in a listbox was seleted.  
#EGET_LISTBOX_SELECTED_AGAIN ;9 An item in the listbox was selected, which was already selected.  
#EGET_DIRECTORY_SELECTED   ; 10 directory has been selected in the file dialog.  
#EGET_FILE_SELECTED       ;11 A file has been selected in the file dialog.  
#EGET_FILE_CHOOSE_DIALOG_CANCELLED  ;12 A file open dialog has been closed without choosing a file.  
#EGET_MESSAGEBOX_YES        ;13 'Yes' was clicked on a messagebox  
#EGET_MESSAGEBOX_NO         ;14 'No' was clicked on a messagebox  
#EGET_MESSAGEBOX_OK         ;15 'OK' was clicked on a messagebox  
#EGET_MESSAGEBOX_CANCEL     ;16 'Cancel' was clicked on a messagebox  
#EGET_EDITBOX_ENTER         ;17 In an editbox was pressed 'ENTER'.  
#EGET_EDITBOX_CHANGED         ; 18
#EGET_EDITBOX_MARKING_CHANGED ; 19
#EGET_TAB_CHANGED           ;20 The tab was changed in an tab control.  
#EGET_MENU_ITEM_SELECTED    ;21 A menu item was selected in a (context) menu.  
#EGET_COMBO_BOX_CHANGED     ;22 The selection in a combo box has been changed.  
#EGET_SPINBOX_CHANGED       ;23 The value of a spin box has changed.  
#EGET_TABLE_CHANGED         ;24 A table has changed.  
#EGET_TABLE_HEADER_CHANGED  ;25   
#EGET_TABLE_SELECTED_AGAIN  ;26
#EGET_TREEVIEW_NODE_DESELECT;27 A tree view node lost selection. See IGUITreeView::getLastEventNode().  
#EGET_TREEVIEW_NODE_SELECT  ;28 A tree view node was selected. See IGUITreeView::getLastEventNode().  
#EGET_TREEVIEW_NODE_EXPAND  ;29 A tree view node was expanded. See IGUITreeView::getLastEventNode().  
#EGET_TREEVIEW_NODE_COLLAPS ;30 A tree view node was collapsed. See IGUITreeView::getLastEventNode().  
#EGET_COUNT 

EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Enumeration for listbox colors. 
Enumeration 
#EGUI_LBC_TEXT=0  ;Color of text.  
#EGUI_LBC_TEXT_HIGHLIGHT  ;Color of selected text.  
#EGUI_LBC_ICON  ;Color of icon.  
#EGUI_LBC_ICON_HIGHLIGHT  ;Color of selected icon.  
#EGUI_LBC_COUNT  ;Not used, just counts the number of available colors.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; for messagebox flag.  
#EMBF_OK = 1 ;Flag For the ok button.  
#EMBF_CANCEL=2  ;Flag For the cancel button.  
#EMBF_YES =4 ;Flag For the yes button.  
#EMBF_NO =8 ;Flag For the no button.  
#EMBF_FORCE_32BIT=$7FFFFFFF  ;This value is Not used. It only forces This Enumeration To compile in 32 bit.  
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Enumeration for listbox colors. 
Enumeration 
#EGOM_NONE  = 0 ;No element ordering.  
#EGOM_ASCENDING  ;Elements are ordered from the smallest To the largest.  
#EGOM_DESCENDING  ;Elements are ordered from the largest To the smallest.  
#EGOM_COUNT  ;This value is Not used, it only specifies the amount of Default ordering types available.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Enumeration   EGUI_COLUMN_ORDERING 
Enumeration 
#EGCO_NONE = 0 ;Do Not use ordering.  
#EGCO_CUSTOM  ;Send a EGET_TABLE_HEADER_CHANGED message when a column header is clicked.  
#EGCO_ASCENDING  ;Sort it ascending by it's ascii value like: a,b,c,...  
#EGCO_DESCENDING  ;Sort it descending by it's ascii value like: z,x,y,...  
#EGCO_FLIP_ASCENDING_DESCENDING  ;Sort it ascending on first click, descending on Next, etc.  
#EGCO_COUNT  ;Not used As mode, only To get maximum value For this enum.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; EGUI_TABLE_DRAW_FLAGS, which influence the layout. 
#EGTDF_ROWS  = 1 
#EGTDF_COLUMNS   =2 
#EGTDF_ACTIVE_ROW = 4  
#EGTDF_COUNT  = 0
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; MD2 Animation sequences
Enumeration ;IRR_MD2_ANIM_SEQUENCES
#EMAT_STAND = 0
#EMAT_RUN
#EMAT_ATTACK
#EMAT_PAIN_A
#EMAT_PAIN_B
#EMAT_PAIN_C
#EMAT_JUMP
#EMAT_FLIP
#EMAT_SALUTE
#EMAT_FALLBACK
#EMAT_WAVE
#EMAT_POINT
#EMAT_CROUCH_STAND
#EMAT_CROUCH_WALK
#EMAT_CROUCH_ATTACK
#EMAT_CROUCH_PAIN
#EMAT_CROUCH_DEATH
#EMAT_DEATH_FALLBACK
#EMAT_DEATH_FALLFORWARD
#EMAT_DEATH_FALLBACKSLOW
#EMAT_BOOM
#EMAT_COUNT  ;Not an animation, but amount of animation types.  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Particle definitions
#NO_EMITTER      =0
#DEFAULT_EMITTER =1
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; GUI Interface definitions
#GUI_NO_BORDER  = 0
#GUI_BORDER     = 1
#GUI_NO_WRAP    = 0
#GUI_WRAP       = 1
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Type of emitter particles
Enumeration 
#EPET_POINT   = 0 
#EPET_ANIMATED_MESH   
#EPET_BOX   
#EPET_CYLINDER   
#EPET_MESH   
#EPET_RING   
#EPET_SPHERE   
#EPET_COUNT  
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; 
#ETCF_ALWAYS_16_BIT  = 1
#ETCF_ALWAYS_32_BIT  = 2
#ETCF_OPTIMIZED_FOR_QUALITY = 4
#ETCF_OPTIMIZED_FOR_SPEED   = 8
#ETCF_CREATE_MIP_MAPS = 16
#ETCF_NO_ALPHA_CHANNEL = 32
#ETCF_ALLOW_NON_POWER_2 = 64 ;Allow the Driver To use Non-Power-2-Textures. 
#ETCF_FORCE_32_BIT_DO_NOT_USE = $7FFFFFF
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; enumeration for querying features of the video driver. 
Enumeration 
#EVDF_RENDER_TO_TARGET = 0  ;Is driver able To render To a surface?  
#EVDF_HARDWARE_TL           ;Is hardeware transform And lighting supported?  
#EVDF_MULTITEXTURE          ;Are multiple textures per material possible?  
#EVDF_BILINEAR_FILTER       ;Is driver able To render With a bilinear filter applied?  
#EVDF_MIP_MAP               ;Can the driver handle mip maps?  
#EVDF_MIP_MAP_AUTO_UPDATE   ;Can the driver update mip maps automatically?  
#EVDF_STENCIL_BUFFER        ;Are stencilbuffers switched on And does the device support stencil buffers?  
#EVDF_VERTEX_SHADER_1_1     ;Is Vertex Shader 1.1 supported?  
#EVDF_VERTEX_SHADER_2_0     ;Is Vertex Shader 2.0 supported?  
#EVDF_VERTEX_SHADER_3_0     ;Is Vertex Shader 3.0 supported?  
#EVDF_PIXEL_SHADER_1_1      ;Is Pixel Shader 1.1 supported?  
#EVDF_PIXEL_SHADER_1_2      ;Is Pixel Shader 1.2 supported?  
#EVDF_PIXEL_SHADER_1_3      ;Is Pixel Shader 1.3 supported?  
#EVDF_PIXEL_SHADER_1_4      ;Is Pixel Shader 1.4 supported?  
#EVDF_PIXEL_SHADER_2_0      ;Is Pixel Shader 2.0 supported?  
#EVDF_PIXEL_SHADER_3_0      ;Is Pixel Shader 3.0 supported?  
#EVDF_ARB_VERTEX_PROGRAM_1  ;Are ARB vertex programs v1.0 supported?  
#EVDF_ARB_FRAGMENT_PROGRAM_1;Are ARB fragment programs v1.0 supported?  
#EVDF_ARB_GLSL            ;Is GLSL supported?  
#EVDF_HLSL                ;Is HLSL supported?  
#EVDF_TEXTURE_NSQUARE     ;Are non-square textures supported?  
#EVDF_TEXTURE_NPOT        ;Are non-power-of-two textures supported?  
#EVDF_FRAMEBUFFER_OBJECT  ;Are framebuffer objects supported?  
#EVDF_VERTEX_BUFFER_OBJECT;Are vertex buffer objects supported?  
#EVDF_ALPHA_TO_COVERAGE   ;Supports Alpha To Coverage.  
#EVDF_COLOR_MASK          ;Supports Color masks (disabling color planes in output).  
#EVDF_COUNT               ;Only used For counting the elements of this enum. 
EndEnumeration 
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; collide and physic
#BOX_PRIMITIVE				=1
#CONE_PRIMITIVE				=2
#SPHERE_PRIMITIVE			=3
#CYLINDER_PRIMITIVE			=4
#CAPSULE_PRIMITIVE			=5
#CHAMFER_CYLINDER_PRIMITIVE	=6
#HULL_PRIMITIVE				=7
#HULL_PRIMITIVE_SURFACE = 8
#COMPLEX_PRIMITIVE_SURFACE = 9
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; E_EFFECT_TYPE
Enumeration
#EET_ANISO = 0
#EET_MRWIGGLE
#EET_GOOCH
#EET_PHONG
#EET_BRDF
#EET_COUNT
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; E_SHADOW_MODE
Enumeration
#ESM_RECEIVE = 0
#ESM_CAST
#ESM_BOTH
#ESM_COUNT
EndEnumeration
;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
; Various filter types, up To 16 samples PCF.
; E_FILTER_TYPE
Enumeration
#EFT_NONE=0
#EFT_4PCF
#EFT_8PCF
#EFT_12PCF
#EFT_16PCF
#EFT_COUNT
#EFT_OUT = -1
EndEnumeration
; 
Enumeration
#AXIS_X = 0     ;e.g. analog stick 1 left To right
#AXIS_Y         ;e.g. analog stick 1 top To bottom
#AXIS_Z         ;e.g. throttle, Or analog 2 stick 2 left To right
#AXIS_R         ;e.g. rudder, Or analog 2 stick 2 top To bottom
#AXIS_U
#AXIS_V
EndEnumeration

iSetAntiAlias( value=#False)
iSetInputEvent( value = #False)
iInitEngine()
iCreateScreen(dType.l, dwWidth.l, dwHeight.l, VSync.b=#True, Depth.l=32, fullscreen.b=#False, stencil.c=#True, physic.b=#True)
iCreateEngineGadget(hWnd.l, dType.l, dwWidth.l, dwHeight.l, VSync.b=#True, stencil.c=#False, physic.b=#True)
iFreeEngine()
iBeginScene.l( red.c=0,  green.c=0,  blue.c =0, alpha.c=255, backbuffer.b=#True,  zbuffer.b=#True)
iDrawScene()
iDrawGUI()
iEndScene()
iSendLog(logtext.s)
iLogFile(flag.l=#True)
iFPS.l()
iRenderTarget.l( *target.ITexture , clearBackBuffer.b=#True,  clearZBuffe.b=#True,  color.l=0)
iSetViewPort( x.l,  y.l,  dx.l,  dy.l )
iTextureCreation( flag.l, enabled.b )
iClipPlane.l(index.l, *iplane.iPLANE, enable.b=#True)
iEnableClipPlane(index.l,  enable.b=#True)
iGetProjectionTransform(*mat.iMATRIX)
iGetViewTransform(*mat.iMATRIX)
iGetWorldTransform(*mat.l)
iQueryFeature( feature.l )
iRegisterNodeForRendering( *node.INode , pass.l )
iFog( color.l=$00FFFFFF, FogType.l=#EFT_FOG_LINEAR,  start.F=50.0, FEnd.F=100.0,  density.F=0.01,  pixelFog.b=#False,  rangeFog.b=#False )
iShadowColor( color.l=$96000000)
iDistanceLOD(  d0.F,  d1.F,  d2.F,  d3.F,  d4.F,  d5.F)
iCreateSceneManager.l()
iCurentSceneManager.l(*scenemanager.l)
iDrawSceneManager(*smgr0.l)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- NODE Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iPositionNode(*node.INode,  x.F,  y.F,  z.F)
iXNode(*node.INode,  x.F)
iYNode(*node.INode,  y.F)
iZNode(*node.INode,  z.F)
iRotateNode(*node.INode, x.F,  y.F,  z.F)
iScaleNode(*node.INode, x.F,  y.F,  z.F)
iTurnNode(*node.INode, x.F,  y.F,  z.F)
iTranslateNode(*node.INode, x.F,  y.F,  z.F)
iMoveNode(*node.INode, x.F,  y.F,  z.F)
iAddChildNode(*node.INode, *child.INode)
iCloneNode.l(*node.INode, *parent.INode=#Null)  ; return *INode
iNodePosition(*node.INode, *vect.iVECTOR3)
iNodePositionP(*node.INode, *vect.iVECTOR3)
inoderotation(*node.INode, *vect.iVECTOR3)
iNodeAbsoluteRotation(*node.INode, *vect.iVECTOR3)
iNodeScale(*node.INode, *vect.iVECTOR3)
iNodeX.F(*node.INode)
iNodeY.F(*node.INode)
iNodeZ.F(*node.INode)
iNodeTransformation(*node.INode, *mat.iMATRIX)
iNodeChildren.l(*node.INode, num.l=0) ; return *INode
iNodeFindChildren.l(*node.INode, *child.INode) ; return bool
iNodeNumChildren.l(*node.INode)
iNodeNumMaterial.l(*node.INode)
iNodeMaterial.l(*node.INode,  num.l=0)
iMaterialNode(*node.INode, *mat.IMaterial, num.l=0)
iNodeParent.l(*node.INode)
iNodeBoundingBox(*node.INode,  *box.AABBOX)
iNodeTransformedBoundingBox(*node.INode,  *box.AABBOX)
iNodeType.l(*node.INode)
iNodeVisible.l(*node.INode)
iNodeName.l(*node.INode)
iNodeNametype.l(*node.INode)
iVisibleNode(*node.INode,  flag.b=#True)
iNodeBoxIsVisible.l(*node.INode, *cam.ICamera)
iFreeNode(*node.INode)
iFreeAllChildrenNode(*node.INode)
iFreeChildrenNode(*node.INode, *child.INode)
iRenderNode(*node.INode)
iDebugModeNode(*node.INode,  state.l)
iMaterialFlagNode(*node.INode,  flag.l,  newvalue.b=#True)
iMaterialTextureNode(*node.INode, *texture.ITexture , Layer.l=0)
iParentNode(*node.INode, *parent.INode)
iUpdateAbsolutePositionNode(*node.INode)
iSpecularColorNode(*node.INode, color.l)
iAmbientColorNode(*node.INode, color.l)
iDiffuseColorNode(*node.INode, color.l)
iEmissiveColorNode(*node.INode, color.l)
iShininessColorNode(*node.INode, shin.F=20.0)
iGlobalColorNode(*node.INode, color.l)
iLoadTextureNode.l(*node.INode, filename.s, num.l=0,  Layer.l=0) ; return ITexture*  
iProjectedX.l(*node.INode, *camera.ICamera=#Null)
iProjectedY.l(*node.INode, *camera.ICamera=#Null)
iMaterialTypeNode(*node.INode,  type.l )
iPointNode(*node.INode, *target.INode,  roll.F=0)
iPointTargetNode(*node.INode, px.F=0, py.F=0, pz.F=0,  roll.F=0)
iTurnAirNode(*node.INode, px.F=0, py.F=0, pz.F=0)
iAutomaticCullingNode(state.l=#EAC_BOX  )
iNodeRootScene.l()
iNodeDirection(*node.INode, *vect.iVECTOR3)
iPickingNode(*node.INode,  pickFlag.l=#True)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- Object Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iLoad3DObject.l(filename.s) ; return *IObjet
iObjectGeometry(*object.IObject, frame.l=0, detail.l=0, startFrameloop.l=-1,  endFrameLoop.l=-1)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- COLLIDE Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iOverPickCamera.l(*camera.ICamera)
iPickCamera.l(*camera.ICamera, mx.l,  my.l, pickType.l=#ENT_PICKBOX, distance.F=5000.0 )
iCollisionPoint.l(sx.F, sy.F, sz.F, ex.F, ey.F, ez.F, *mesh.IMesh)
iCollisionPointNode.l(sx.F, sy.F, sz.F, ex.F, ey.F, ez.F, pickType.l=#ENT_PICKBOX)

iPickedPosition(*pos.F)
iPickedNormal(*norm.F)
iPickedtriangle(*triangles.F)

iCreateCollisionResponseAnimator.l(*world.IMesh, *node.INode, elRadiusX.F, elRadiusY.F, elRadiusZ.F, elTransX.F=0, elTransY.F=0, elTransZ.F=0, gravityPerSecondX.F=0, gravityPerSecondY.F=-10, gravityPerSecondZ.F=0, slidingValue.F=0.0005)
iAddCollisionResponse(*node.INode, *anim.IAnimatorCollisionResponse)
iCollisionResponseEllipsoidRadius(*anim.IAnimatorCollisionResponse, *radius.F)
iCollisionResponseEllipsoidTranslation(*anim.IAnimatorCollisionResponse, *Translation.F)
iCollisionResponseGravity(*anim.IAnimatorCollisionResponse, *gravity.F)
iCollisionResponseFalling.l(*anim.IAnimatorCollisionResponse)
iJumpCollisionResponse(*anim.IAnimatorCollisionResponse,  jumpSpeed.F)
iEllipsoidRadiusCollisionResponse(*anim.IAnimatorCollisionResponse,  x.F,  y.F,  z.F)
iEllipsoidTranslationCollisionResponse(*anim.IAnimatorCollisionResponse,  x.F,  y.F,  z.F)
iGravityCollisionResponse(*anim.IAnimatorCollisionResponse,  x.F,  y.F,  z.F)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- OCTREE  Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iSetPolysPerNode(num.l=256)
iCreateMeshInOctree.l(*model.IObject,  *parent.l=#Null, frame.l=0, detail.l=0, startFrameloop.l=-1, endFrameLoop.l=-1) ; return *IMesh


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- TIMER  Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iGetTime.l()
iGetRealTime.l()
iGetSpeed.F()
iIsStopped.l()
iSetSpeed( speed.F =1.0)
iSetTime( tt.l )
iStartTime()
iStoptTime()
iTickTime()

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- MESH Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateMesh.l(*model.IObject,  *parent.l=#Null, frame.l=0, detail.l=0, startFrameloop.l=-1, endFrameLoop.l=-1) ; return *IMesh
iCreateCube.l( ssize.F=1.0, *parent.l=#Null) ; return *INode
icreatesphere.l(radius.F=1.0,  polyCount.l=16, *parent.l=#Null) ; return *INode
iCreateEmptyMesh.l(*parent.l=#Null)
iCreateCylinder.l(radius.F=1.0, length.F=5.0, color.l=$FFFFFFFF, tesselation.l=8, closeTop.b=#True,  oblique.F=0, *parent.l=#Null)
iCreateCone.l(radius.F=1.0, length.F=5.0, colorTop.l=$FFFFFFFF, colorBottom.l=$FFFFFFFF, tesselation.l=8,  oblique.F=0, *parent.l=#Null)
iCreateArrow.l(tesselationCylinder.l=4, tesselationCone.l=8, height.F=1.0, cylinderHeight.F=0.6, width0.F=0.05, width1.F=0.3, vtxColor0.l=$FFFFFFFF, vtxColor1.l=$FFFFFFFF , *parent.l=#Null)
iCreateHillPlane(tileSizeW.F=10.0, tileSizeH.F=10.0, tileCountW.l=10, tileCountH.l=10, *material.IMaterial=#Null,	 hillHeight.F=0, countHillsW.F=0, countHillsH.F=0, textureRepeatCountW.F=1, textureRepeatCountH.F=1,	*parent.l=#Null)
iCreateText.l(*font.IGUIFont, text.s,	color.l=$FFFFFFFF, *parent.l=#Null)
iCreateMeshCopy.l(*mesh.IMesh)
iCloneMesh.l(*mesh.IMesh)
iCreateMeshWithTangents.l(*mesh.IMesh,  recalculateNormals.b=#False,  smooth.b=#False,  angleWeighted.b=#False)
iCreateMeshWith2TCoords.l(*mesh.IMesh)
iMeshGeometry.l(*mesh.IMesh)
iDrawIndexedTriangleList(*vertices.l, vertexCount.l, *indexList.w,  triangleCount.l)
iDrawIndexedTriangleList2T(*vertices.l, vertexCount.l, *indexList.w,  triangleCount.l)
iDrawIndexedTriangleListTan(*vertices.l, vertexCount.l, *indexList.w,  triangleCount.l)
; 
iAddBufferMesh(*mesh.IMesh,  vertex_type.l=#EVT_STANDART)
iAddVertexMesh.l(*mesh.IMesh,  x.F,  y.F,  z.F, color.l=$FFFFFFFF,  u.F=0,  v.F=0 ,  num_buffer.l=0)
iAddFaceMesh.l(*mesh.IMesh,  p1.l,  p2.l,  p3.l , num_buffer.l=0)
iAddCVertexMesh.l(*mesh.IMesh, *buf.l , num_buffer.l=0)
iAddMVerticesMesh(*mesh.IMesh, *buf.l,  numVert.l, num_buffer.l=0)
iAddMFacesMesh(*mesh.IMesh, *id.l,  numId.l, num_buffer.l=0)
; geometry instructions change
iMeshBufferNumBuffer.l(*mesh.IMeshBuffer)
iMeshBufferVertexType.l(*mesh.IMeshBuffer,  num_buffer.l=0)
iFlipSurfacesMeshBuffer(*mesh.IMeshBuffer )
iVertexColorAlphaMeshBuffer(*mesh.IMeshBuffer,  alpha.l)
iCalculateNormalsMeshBuffer(*mesh.IMeshBuffer,  smooth.b=#False,  angleWeighted.b=#False)
iTransformMeshBuffer(*mesh.IMeshBuffer, *mat.iMATRIX)
iScaleMeshBuffer(*mesh.IMeshBuffer, factorx.F, factory.F, factorz.F)
iRotateMeshBuffer(*mesh.IMeshBuffer, rotx.F, roty.F, rotz.F)
iTranslateMeshBuffer(*mesh.IMeshBuffer, tx.F, ty.F, tz.F)
iScaleTCoordsMeshBuffer(*mesh.IMeshBuffer, factorx.F, factory.F, Layer.l=0)
iPlanarTextureMappingMeshBuffer(*mesh.IMeshBuffer,  resolution.F=0.01 )
iHardwareMapMeshBuffer(*mesh.IMeshBuffer, NewMappingHint.l=#EHM_STATIC)
iDirtyMeshBuffer(*mesh.IMeshBuffer,  BufferType.l=#EBT_VERTEX_AND_INDEX)
iMeshBuffer.l(*mesh.IMeshBuffer,  num_buffer.l=0)
iMeshBufferNumVertex.l(*mesh.IMeshBuffer,  num_buffer.l=0)
iMeshBufferVertex(*mesh.IMeshBuffer, *vert.iVECTOR3,  num_vert.l=0, num_buffer.l=0)
iVertexMeshBuffer(*mesh.IMeshBuffer, x.F ,y.F ,z.F,  num_vert.l=0, num_buffer.l=0)
iMeshBufferNormal(*mesh.IMeshBuffer, *norm.iVECTOR3,  num_vert.l=0, num_buffer.l=0)
iNormalMeshBuffer(*mesh.IMeshBuffer, x.F ,y.F ,z.F,  num_vert.l=0, num_buffer.l=0)
iVertexColorMeshBuffer(*mesh.IMeshBuffer, color.l,  num_vert.l=0, num_buffer.l=0)
iMeshBufferTexCoord(*mesh.IMeshBuffer, *tex.iVECTOR2,  num_vert.l=0, num_buffer.l=0)
iTexCoordMeshBuffer(*mesh.IMeshBuffer, u.F, v.F,  num_vert.l=0, num_buffer.l=0)
iMeshBufferTexCoord2(*mesh.IMeshBuffer, *tex.iVECTOR2,  num_vert.l=0, num_buffer.l=0)
iTexCoord2MeshBuffer(*mesh.IMeshBuffer, u.F, v.F,  num_vert.l=0, num_buffer.l=0)
iMeshBufferVerticesBuffer.l(*mesh.IMeshBuffer, num_buffer.l=0)
iMeshBufferVertexColor(*mesh.IMeshBuffer, *color.l,  num_vert.l=0, num_buffer.l=0)
iMeshBufferIndicesBuffer.l(*mesh.IMeshBuffer, num_buffer.l=0)
iMeshBufferFace(*mesh.IMeshBuffer, numface.l, *v0.w, *v1.w, *v2.w, num_buffer.l=0)
iMeshBufferPolyCount.l(*mesh.IMeshBuffer,  num_buffer.l=0)
iMeshBufferGetVertex(*mesh.IMeshBuffer, *vert.l, num_vert.l, num_buffer.l=0)
iCalculBoundingBoxMeshBuffer(*mesh.IMeshBuffer)
iBoundingBoxMeshBuffer(*mesh.IMeshBuffer, *min.iVECTOR3, *max.iVECTOR3)
iVertexMemoryMeshBuffer(*mesh.IMeshBuffer, *vertices.l, startVert.l, endVert.l, num_buffer.l=0)
iFaceMemoryMeshBuffer(*mesh.IMeshBuffer, *indice.l, startVert.l, endVert.l, num_buffer.l=0)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- IRRSCENE Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iLoadIrrScene(filename.s, *userDataSerializer.l=#Null)
iSaveIrrScene(filename.s, *userDataSerializer.l=#Null)
iSceneNodesFromType(*arr.IArray, type.l=#ESNT_ANY, *start.INode=#Null)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- LOD Mesh Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateLOD.l( *parent=#Null)
iAddMeshLOD.l( *lod.l,  index.l, *node.INode)
iSetMeshLOD( *lod.l,  *node1.INode, *node2.INode, *node3.INode, *node4.INode, *node5.INode, *node6.INode)
iLODCurent.l( *lod.l)
iLODSceneNode( *lod.l,  index.l=0)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- SPRITE3D Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateSprite3D.l( texturename.s, ssize.f=1.0, color.l=$ffffffff, *parent.l=#Null) ; return ISpriteSceneNode
iOrientationSprite3D(*sp.ISpriteSceneNode, Orientation.l=0)
iCenterSprite3D(*sp.ISpriteSceneNode,  x.f=0,  y.f=0,  z.f=0) 



; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- PIVOT Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreatePivot.l(*parent.l=#Null)



; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- SKY/BOLT/WATER Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateSkybox.l(*top.ITexture,*bottom.ITexture,	*left.ITexture,	*right.ITexture,*front.ITexture,*back.ITexture, *parent.l=#Null)
iSkyboxVerticesZone.l( *sky.IMesh)
iCreateSkydome.l(*texture.ITexture, horiRes.l=16, vertRes.l=8, texturePercentage.F=0.9,  spherePercentage.F=2.0, radius.F=1000.0, *parent.l=#Null)
iCreateBolt.l(filename.s, startx.F,  starty.F, startz.F, endx.F,  endy.F,  endz.F,  updateTime.l=300,  height.l=10,  parts.l=10,  bolts.l=1,  steddyend.b=#True,  thick.F=5.0,  col.l=$FFFF0000, *parent.l=#Null)  ; return IBolt*
iCreateWater.l(  waveHeight.F=2.0,   waveSpeed.F=300.0,   waveLength.F=10.0, *parent.l=#Null)
iSetWater( tileSizeX.F=20.0,  tileSizeY.F=20.0, tileCountX.l=40, tileCountY.l=40,	 countHillsX.F=0, countHillsY.F=0, textureRepeatCountX.F=10.0, textureRepeatCountY.F=10.0 )


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- BILLBOARD Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateBillboard.l(  sizex.F=10.0, sizey.F=10.0, colorTop.l=$FFFFFFFF, colorBottom.l=$FFFFFFFF, *parent.l=#Null) ; return *IBillboard
iBillboardColor(*bill.IBillboard, *colorTop.l,  *colorBottom.l)
iColorBillboard(*bill.IBillboard,  colorTop.l, colorBottom.l)
iBillboardSize(*bill.IBillboard,  *xx.F,  *yy.F)
iSizeBillboard(*bill.IBillboard,  xx.F,  yy.F)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- TERRAIN Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateTerrain.l(filename.s, scale.F=1.5, numQuads.l=8, numFaces.l=8, sizeTerrain.l=1024, *parent.l=#Null)
iLoadTextureTerrain.l(*terrain.ITerrain, filename.s, textureLayer.l=0)
iMaterialTypeTerrain(*terrain.ITerrain, newType.l)
iMaterialTextureTerrain(*terrain.ITerrain, *texture.ITexture, Layer.l=0 )
iMaterialFlagTerrain(*terrain.ITerrain, flag.l,  newvalue.b)
iFreeTerrain(*terrain.ITerrain)
iTerrainBoundingBox(*terrain.ITerrain, *box.AABBOX)
iTerrainHeight.F(*terrain.ITerrain,  x.F,  z.F)
iTerrainQuadNode.l(*terrain.ITerrain, num.l)    ; return IQuadNode* 
iTerrainQuadNodeXZ.l(*terrain.ITerrain,  x.l,  z.l)    ; return IQuadNode* 
iTextureMappingTerrain(*terrain.ITerrain,  nquad.l,  Layer.l,  n.l,  *texture.ITexture)
iTerrainPickedPosition(*terrain.ITerrain, *pos.iVECTOR3)
iTerrainPickedNormal(*terrain.ITerrain, *norm.iVECTOR3)
iTerrainPickedQuad.l(*terrain.ITerrain)
iTerrainPickedtriangle(*terrain.ITerrain, *triangles.F)
iPickTerrain.l(*terrain.ITerrain, x.l, y.l,  DistBase.l)
iHeightTerrain(*terrain.ITerrain, x.l, y.l,  hh.F)
iTerrainTransformation(*terrain.ITerrain,  *mat.iMATRIX)
iHardwareMapTerrain(*terrain.ITerrain, NewMappingHint.l=#EHM_STATIC)
iDirtyTerrain(*terrain.ITerrain,  BufferType.l=#EBT_VERTEX_AND_INDEX)
; for debug
iTerrainNQuad.l(*terrain.ITerrain)
iQuadDebugTerrain(*terrain.ITerrain, quaddebug.b=#True)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- PRIMITIVES 3D Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iDrawTriangle3D(*tri.F,  color.l=$FFFFFFFF)
iDrawBox3D(*box.AABBOX, color.l=$FFFFFFFF)
iDrawLine3D(startx.F,  starty.F,  startz.F,  endx.F,  endy.F,  endz.F, color.l=$FFFFFFFF)
iSituatePrimitive3D( px.F=0,  py.F=0,  pz.F=0,  rx.F=0,  ry.F=0,  rz.F=0)
iMatrixPrimitive3D( *mdraw.iMATRIX )


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- MATERIAL Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateMaterial.l(flag.l=#Null) ; return IMaterial
iMaterialFlag.l(*material.IMaterial, flag.l) 
iMaterialTexture.l(*material.IMaterial,  i.l) ; return ITexture*
iMaterialTextureMatrix(*material.IMaterial,  i.l, *matrix.iMATRIX) 
iMaterialTransparent.l(*material.IMaterial) 
iFlagMaterial(*material.IMaterial, flag.l,  value.b) 
iTextureMaterial(*material.IMaterial,  i.l, *tex.ITexture) 
iTextureMatrixMaterial(*material.IMaterial, i.l,  *matrix.iMATRIX) 
iMaterialAmbientColor.l(*material.IMaterial) 
iAmbientColorMaterial(*material.IMaterial,  col.l) 
iMaterialDiffuseColor.l(*material.IMaterial) 
iDiffuseColorMaterial(*material.IMaterial,  col.l) 
iMaterialEmissiveColor.l(*material.IMaterial) 
iEmissiveColorMaterial(*material.IMaterial,  col.l) 
iMaterialBackfaceCulling.l(*material.IMaterial) 
iMaterialFogEnable.l(*material.IMaterial) 
iMaterialFrontfaceCulling.l(*material.IMaterial) 
iMaterialGouraudShading.l(*material.IMaterial) 
iMaterialShininess.f(*material.IMaterial) 
iShininessMaterial(*material.IMaterial,  shin.f) 
iMaterialSpecularColor.l(*material.IMaterial) 
iSpecularColorMaterial(*material.IMaterial,  col.l) 
iMaterialThickness.F(*material.IMaterial) 
iThicknessMaterial(*material.IMaterial, thick.F) 
iTypeParamMaterial(*material.IMaterial, param.F) 
iTypeParam2Material(*material.IMaterial, param.F) 
iTypeMaterial(*material.IMaterial,  type.l) 
iSetMaterial(*material.IMaterial) 
iCopyMaterial( *src.IMaterial, *dest.IMaterial) 
iTextureWrapMaterial(*material.IMaterial, value.l=0, Layer.l=0) 

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- LIGHT Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateLight.l(  col.l=$FFFFFFFF, radius.F=20, *parent.l=#Null) ; return *ILight
iCastShadowLight( *lgt.ILight, flag.b=#True)
iLightType.l( *lgt.ILight)
iTypeLight( *lgt.ILight, type.l)
iLightRadius.F( *lgt.ILight)
iRadiusLight( *lgt.ILight,  radius.F=100)
iAmbientColorLight( *lgt.ILight, col.l)
iLightAmbientColor.l( *lgt.ILight)
iSpecularColorLight( *lgt.ILight,  col.l)
iLightSpecularColor.l( *lgt.ILight)
iDiffuseColorLight( *lgt.ILight,  col.l)
iLightDiffuseColor.l( *lgt.ILight)
iAttenuationLight( *lgt.ILight,  constant.F,  linear.F,  quadratic.F)
iLightAttenuation( *lgt.ILight, *ret.iVECTOR3)
iLightDirection( *lgt.ILight, *ret.iVECTOR3)
iFalloffLight( *lgt.ILight,  falloff.F)
iLightFalloff.F( *lgt.ILight)
iInnerConeLight( *lgt.ILight,  InnerCone.F )
iLightInnerCone.F( *lgt.ILight)
iOuterConeLight( *lgt.ILight, OuterCone.F )
iLightOuterCone.F( *lgt.ILight)
iAmbientLight( color.l=$FFFFFFFF)
iLightAmbient.l()
iCreateVolumeLight.l( tailcolor.l=$0, footcolor.l=$3300F090,  subdivU.l=32, subdivV.l=32, *parent.l=#Null ); return *IVolumeLight
iParametersVolumeLight( *vlight.IVolumeLight, tailcolor.l=0, footcolor.l=$3300F090,  subdivU.l=32,  subdivV.l=32)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- TEXTURE Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iTextureColorFormat.l( *tex.ITexture) 
iTextureOriginalSize(*tex.ITexture,  *width.l,  *height.l) 
iTexturePitch.l(*tex.ITexture) 
iTextureSize(*tex.ITexture, *width.l,  *height.l) 
iTextureMipMaps.l(*tex.ITexture) 
iTextureRenderTarget.l(*tex.ITexture) 
iLockTexture.l(*tex.ITexture,  readonly.b=#False) 
iUnlockTexture(*tex.ITexture) 
iMipMapLevelTexture(*tex.ITexture) 
iCreateRenderTargetTexture.l( width.l, height.l, format.l=#ECF_UNKNOWN)  ; return ITexture*
iCreateTexture.l( width.l=128,  height.l=128,  format.l=#ECF_A8R8G8B8)   ; return ITexture*
iCreateTextureWithImage.l( name.s, *img.IImage)   ; return ITexture*
iFindTexture.l(name.s)   ; return ITexture*
iLoadTexture.l(name.s)  ; return ITexture* 
iTextureCount.l() 
iColorKeyTexture(*tex.ITexture,  col.l) 
iNormalMapTexture(*tex.ITexture,  ampli.F= 1.0) 
iFreeTexture(*tex.ITexture) 
iFlagCreationTexture( flag.l,    enabled.b) 
iCreateListTexture.l(filename.s,  width.l, height.l) 

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- TEXTURE ANIMATOR Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateTextureAnimator.l( *texture.IArray,  timePerFrame.l,  loop.b=#True) ; return *INodeAnimator
iAddAnimatorTexture(*node.INode, *anim.INodeAnimator)
iFreeAnimatorTexture(*node.INode, *anim.INodeAnimator)
iAnimatorTextureIndex.l(*anim.INodeAnimator)
iAnimatorTextureStartTime.l(*anim.INodeAnimator)
iAnimatorTextureEndTime.l(*anim.INodeAnimator)
iAnimatorTextureSize.l(*anim.INodeAnimator)
iNodeAnimators.l(*node.INode,  num.l=0)
iRemoveAnimatorNode(*node.INode,  *anim.INodeAnimator)
iRemoveAnimatorsNode(*node.INode)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- IMAGES Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iLoadImage.l( filename.s )
iFreeImage( *img.IImage )
iCreateSubImage.l( *src.IImage,  posx.l,  posy.l, sizex.l,  sizey.l )
iCreateEmptyImage.l( format.l, sizex.l,  sizey.l )
iCreateScreenShot.l()
iSaveImage.l( *img.IImage, filename.s,  param.l=0)
iCopyRecImage( *src.IImage, *target.IImage,  posx.l,  posy.l,  orx.l,  ory.l,  w.l,  h.l)
iCopyImage( *src.IImage, *target.IImage)
iCopyWithAlphaImage( *src.IImage, *target.IImage, posx.l,  posy.l,  orx.l,  ory.l,  w.l,  h.l, color.l=$FFFFFFFF)
iFillImage( *img.IImage,  color.l)
iImageAlphaMask.l( *img.IImage)
iImageBitsPerPixel.l( *img.IImage)
iImageBytesPerPixel.l( *img.IImage)
iImageBlueMask.l( *img.IImage)
iImageGreenMask.l( *img.IImage)
iImageRedMask.l( *img.IImage)
iImageColorFormat.l( *img.IImage)
iImageDimension( *img.IImage,  *w.l,  *h.l)
iImageSize.l( *img.IImage)
iImageSizeInPixels.l( *img.IImage)
iImagePitch.l( *img.IImage)
iImagePixel.l( *img.IImage,  x.l,  y.l)
iPixelImage( *img.IImage,  x.l,  y.l,  color.l=$FFFFFFFF)
iLockImage.l( *img.IImage)
iUnlockImage( *img.IImage)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- ANIMATION Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateAnimation.l(*model.IObject, *parent.l=#Null) ; return *IAnimatedMesh
iSpeedAnimation(*anim.IAnimatedMesh,  speed.F )
iAnimateJointAnimation(*anim.IAnimatedMesh, CalculateAbsolutePositions.b=#True )
iCloneAnimation.l(*anim.IAnimatedMesh, *parent.l=#Null) ; return *IAnimatedMesh
iAnimationEndFrame(*anim.IAnimatedMesh)
iAnimationFrameNumber.F(*anim.IAnimatedMesh)
iFrameLoopAnimation(*anim.IAnimatedMesh,  Fbegin.l=0, FEnd.l=0)
iAnimationJointCount.l(*anim.IAnimatedMesh)
iAnimationJointNode.l(*anim.IAnimatedMesh, jointID.l=0) ; return *IBoneNode
iAnimationJointNodebyName.l(*anim.IAnimatedMesh, name.s)
iAnimationStartFrame.l(*anim.IAnimatedMesh)
iCurrentFrameAnimation(*anim.IAnimatedMesh,  frame.F)
iJointModeAnimation(*anim.IAnimatedMesh, mode.l=#EJUOR_NONE )
iLoopModeAnimation(*anim.IAnimatedMesh, mode.b=#True)
iRenderFromIdentityAnimation(*anim.IAnimatedMesh, mode.b=#True)
iTransitionTimeAnimation(*anim.IAnimatedMesh,  ttime.F)
; shadowVolume
iShadowVolumeAnimation.l(*anim.IAnimatedMesh,  zfailmethod.b=#True, infinity.F=10000.0 )
iUpdateShadowVolume(*shad.IShadowVolumeNode)
; Bones 
iBoneAnimationMode.l(*bone.IBoneNode)
iBoneIndex.l(*bone.IBoneNode)
iBoneName.l(*bone.IBoneNode) ; return char*
iBoneBoundingBox(*bone.IBoneNode, *bound.AABBOX)
iBoneSkinningSpace.l(*bone.IBoneNode)
iOnAnimateBone(*bone.IBoneNode, timeMS.l)
iAnimationModeBone(*bone.IBoneNode, mode.l)
iSkinningSpaceBone(*bone.IBoneNode, space.l)
iUpdateAbsolutePositionOfAllChildrenBone(*bone.IBoneNode)
iBonePositionHint.l(*bone.IBoneNode)
iBoneScaleHint.l(*bone.IBoneNode)
iBoneRotationHint.l(*bone.IBoneNode)
iBoneAnimationParent.l(*bone.IBoneNode)
iPositionHintBone(*bone.IBoneNode,  hint.l=-1)
; MD2
iAnimationMD2(*anim.IAnimatedMesh,  type.l=#EMAT_STAND )
iAnimationMD2byName(*anim.IAnimatedMesh,  animationName.s )
iMD2AnimationCount.l(*anim.IAnimatedMesh)
iMD2AnimationName.l(*anim.IAnimatedMesh, nr.l=0) ; return char*
iMD2FrameLoopName(*anim.IAnimatedMesh, name.s, *outBegin.l,*outEnd.l, *outFPS.l)   
iMD2FrameLoopType(*anim.IAnimatedMesh, type.l, *outBegin.l,*outEnd.l, *outFPS.l)   
; MD3
iInterpolationShiftMD3(*anim.IAnimatedMesh,  shift.l,  loopMode.l)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- CAMERA Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateCamera.l(*parent.l=#Null) ; return *ICamera
iCameraTarget(*cam.ICamera, *res.F)
iTargetCamera(*cam.ICamera,  x.F,  y.F,  z.F)
iTargetAndRotationCamera(*cam.ICamera, flag.b=#True)
iCameraAspectRatio.F(*cam.ICamera )
iCameraFarValue.F(*cam.ICamera )
iCameraNearValue.F(*cam.ICamera )
iCameraFOV.F(*cam.ICamera )
iCameraProjectionMatrix(*cam.ICamera, *mat.iMATRIX)
iCameraUpVector(*cam.ICamera, *vect.iVECTOR3 )
iCameraViewMatrix(*cam.ICamera, *mat.iMATRIX)
iAspectRatioCamera(*cam.ICamera, aspect.F)
iFarValueCamera(*cam.ICamera,  farv.F)
iFOVCamera(*cam.ICamera,  fov.F)
iNearValueCamera(*cam.ICamera,  nearv.F)
iUpVectorCamera(*cam.ICamera,   x.F,  y.F,  z.F)
iCameraBoxInside(*cam.ICamera,  *box.AABBOX)
iActiveCamera(*cam.ICamera)
iCameraActive.l()
iProjectionMatrixCamera(*cam.ICamera,  *projection.iMATRIX,  isOrthogonal.b=#False)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- PARTICLE Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateParticleSystem( withDefaultEmitter.b=#False, *parent.l=#Null )
iCreateParticleBoxEmitter.l(*part.IParticleSystem, dirx.F=0, diry.F=0.03, dirz.F=0, minParticlesPerSecond.l=5, maxParticlesPerSecond.l=10, mnStartColor.l=$FF000000, mxStartColor.l=$FFFFFFFF, lifeTimeMin.l=2000, lifeTimeMax.l=4000, maxAngleDegrees.l=0,  dimminx.F=5.0, dimminy.F=5.0, dimmaxx.F=5.0, dimmaxy.F=5.0, *bbox.AABBOX=#Null) ; return IParticleBox*
iCreateParticleCylinderEmitter.l(*part.IParticleSystem, centerx.F,  centery.F,  centerz.F, radius.F, normalx.F, normaly.F, normalz.F, length.F, outlineOnly.b=#False, dirx.F=0, diry.F=0.03, dirz.F=0, minParticlesPerSecond.l=5, maxParticlesPerSecond.l=10, minStartCol.l=$FF000000, maxStartCol.l=$FFFFFFFF,lifeTimeMin.l=2000, lifeTimeMax.l=4000, maxAngleDegrees.l=0, minStartSx.F=5.0, minStartSy.F=5.0, maxStartSx.F=5.0,  maxStartSy.F=5.0) 
iCreateParticleSphereEmitter.l(*part.IParticleSystem, centerx.F,  centery.F,  centerz.F, radius.F,  dirx.F=0, diry.F=0.03, dirz.F=0, minParticlesPerSecond.l=5, maxParticlesPerSecond.l=10, minStartCol.l=$FF000000, maxStartCol.l=$FFFFFFFF,lifeTimeMin.l=2000, lifeTimeMax.l=4000, maxAngleDegrees.l=0, minStartSx.F=5.0, minStartSy.F=5.0, maxStartSx.F=5.0,  maxStartSy.F=5.0) 
iCreateParticleMeshEmitter.l(*part.IParticleSystem, *mesh.IMesh, useNormalDirection.b=#True, dirx.F=0, diry.F=0.03, dirz.F=0, normalDirectionModifier.F=100.0, mbNumber.l=-1, everyMeshVertex.b = #False,minParticlesPerSecond.l=5, maxParticlesPerSecond.l=10, minStartCol.l=$FF000000, maxStartCol.l=$FFFFFFFF,lifeTimeMin.l=2000, lifeTimeMax.l=4000, maxAngleDegrees.l=0, minStartSx.F=5.0, minStartSy.F=5.0, maxStartSx.F=5.0,  maxStartSy.F=5.0) 																			 
																			 
iScaleParticleSystem(*part.IParticleSystem, spx.F=1.0, spy.F=1.0)
iRotationParticleSystem(*part.IParticleSystem, spx.F=5.0,  spy.F=5.0, spz.F=5.0, px.F=0, py.F=0, pz.F=0)
iAttractionParticleSystem(*part.IParticleSystem, pointx.F, pointy.F, pointz.F, speed.F=1.0, attract.b=#True,  affectX.b=#True,  affectY.b=#True,  affectZ.b=#True )
iAddEmitterParticleSystem(*part.IParticleSystem, *em.IParticle )
iFadeOutParticleSystem(*part.IParticleSystem,  targetColor.l=0,   timeNeededToFadeOut.l=1000 )
iParticleSystemEmitter.l(*part.IParticleSystem)
iGlobalParticleSystem(*part.IParticleSystem, Glob.b=#True)
iParticleSizeParticleSystem(*part.IParticleSystem, sx.F=1.0, sy.F=1.0)
; IParticle functions
iMinStartSizeParticle(*em.IParticle,  dimx.F,  dimy.F  )
iMaxStartSizeParticle(*em.IParticle,  dimx.f,  dimy.f  )
iParticleDirection(*em.IParticle,  *dirx.f,  *diry.f,  *dirz.f  )
iParticleMaxPerSecond.l(*em.IParticle)
iParticleMinPerSecond.l(*em.IParticle )
iDirectionParticle(*em.IParticle,  dirx.f, diry.f, dirz.f  )
iMinPerSecondParticle(*em.IParticle,  minPPS.l )
iMaxPerSecondParticle(*em.IParticle,  maxPPS.l )
iParticleType.l(*em.IParticle )
iParticleMaxStartColor.l(*em.IParticle)
iParticleMinStartColor.l(*em.IParticle )
iParticleMaxStartSize(*em.IParticle,  *dimx.f,  *dimy.f )
iParticleMinStartSize(*em.IParticle,  *dimx.f,  *dimy.f )
iMaxStartColorParticle(*em.IParticle,  col.l )
iMinStartColorParticle(*em.IParticle,  col.l )



; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- FileSystem Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iAddZipFileArchive(filename.s)
iAddFolderFileArchive(filename.s,  ignoreCase.b=#True,   ignorePaths.b=#True)  
iAddPakFileArchive(filename.s, ignoreCase.b=#True,   ignorePaths.b=#True)  
iChangeWorkingDirectory(filename.s) 
iCreateAndOpenFile.l(filename.s) 
iCreateAndWriteFile.l(filename.s, append.b=#False)
iCreateFileList.l()  
iFreeFileList(*list.IFileList)  
iCreateMemoryReadFile(*memory.l , len.l, fileName.s, deleteMemoryWhenDropped.b=#False) 
iExistFile(fileName.s)  
iWorkingDirectory.l() ; return char *
; IReadFile
iReadFileFileName.l(*rf.IReadFile) ; return char *  
iReadFilePos.l(*rf.IReadFile)  
iReadFileSize.l(*rf.IReadFile)  
iReadFileRead.l(*rf.IReadFile, *buffer.l, sizeToRead.l)  
iReadFileSeek.l(*rf.IReadFile, finalPos.l,  relativeMovement.b=#False) 
iCloseReadFile(*rf.IReadFile)  
; IWriteFile
iWriteFileName.l(*wf.IWriteFile)  ; return char *  
iWriteFilePos.l(*wf.IWriteFile) 
iWriteFileSeek.l(*wf.IWriteFile, finalPos.l,  relativeMovement.b=#False) 
iWriteFileWrite.l(*wf.IWriteFile, *buffer.l, sizeToWrite.l)  
iCloseWriteFile(*wf.IWriteFile)  
; IFileList
iFileListCount.l(*fl.IFileList)  
iFileListName.l(*fl.IFileList, index.l)  
iFileListFullName.l(*fl.IFileList, index.l)  
iFileListisDirectory.l(*fl.IFileList, index.l)  

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- 2D Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iDrawLine2D(sx.l,  sy.l, ex.l,  ey.l,  color.l=$FFFFFFFF)
iDrawPolygon2D(sx.l,  sy.l, radius.F,  color.l=$FFFFFFFF,  vertexCount.l=10)
iDrawRectangle2D(sx.l,  sy.l, ex.l,  ey.l,  colorLUp.l=$FFFFFFFF,  colorRUp.l=$FFFFFFFF,  colorLDown.l=$FFFFFFFF,  colorRDown.l=$FFFFFFFF, *clip.l=#Null)
iDrawRect2D(sx.l,  sy.l, ex.l,  ey.l,  color.l=$FFFFFFFF,  *clip.l=#Null)
iDrawSubRectImage2D(*text.ITexture ,destx.l,  desty.l, destex.l,  destey.l, srcx.l,  srcy.l, srcex.l,  srcey.l,  *color.l=#Null,  *clip.l=#Null, useAlphaChannelOfTexture.b=#False )
iDrawRectImage2D(*text.ITexture ,posx.l,  posy.l, srcx.l,  srcy.l, srcex.l,  srcey.l,  color.l=$FFFFFFFF,  *clip.l=#Null, useAlphaChannelOfTexture.b=#False )
iDrawImage2D(*text.ITexture ,posx.l,  posy.l)
iBegin2D( width.l=0, height.l=0)
iEnd2D()
; sprite2D
iCreateSprite2D.l(texturename.s, ssize.F=1.0, color.l=$FFFFFFFF, *parent.l=#Null)
iCenterSprite2D(*sp.ISprite2D,  x.F,  y.F) 
iRenderSprite2D(*sp.ISprite2D) 


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- GUI Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iTextGUI(*gui.IGUIElement, text.s)
iToolTipTextGUI(*gui.IGUIElement, text.s)
iVisibleGUI(*gui.IGUIElement, flag.b)
iRelativePositionGUI(*gui.IGUIElement, posx.l,  posy.l)
iRelativeRectGUI(*gui.IGUIElement, posx.l,  posy.l,  ox.l,  oy.l)
iGUIAbsoluteRect(*gui.IGUIElement, *posx.l,  *posy.l,  *ox.l,  *oy.l)
iGUIAbsoluteClippingRect(*gui.IGUIElement, *posx.l,  *posy.l,  *ox.l,  *oy.l)
iGUIChildren.l(*gui.IGUIElement,  num.l=0)
iChildrenGUI(*gui.IGUIElement, *child.IGUIElement)
iBringToFrontGUI.l(*gui.IGUIElement)
iGUIElementFromId.l(*gui.IGUIElement,  Id.l, searchchildren.b=#False)
iGUIID.l(*gui.IGUIElement)
iGUIParent.l(*gui.IGUIElement)
iGUIType.l(*gui.IGUIElement)
iGUIisEnabled.l(*gui.IGUIElement)
iGUIisPointInside.l(*gui.IGUIElement,  posx.l,  posy.l)
iGUIVisible.l(*gui.IGUIElement)
iMoveGUI(*gui.IGUIElement,  posx.l,  posy.l)
iFreeGUI(*gui.IGUIElement)
iFreeChildGUI(*gui.IGUIElement, *child.IGUIElement)
iEnabledGUI(*gui.IGUIElement,  enable.b=#True)
iIDGUI(*gui.IGUIElement,  Id.l=-1)
iMaxSizeGUI(*gui.IGUIElement, posx.l,  posy.l)
iMinSizeGUI(*gui.IGUIElement, posx.l,  posy.l)
iGUIText.l(*gui.IGUIElement)
iGUIEventCallBack(*procedureGUIEventCallBack.l)
iGUIColor.l( index.l)
iColorGUI(index.l, color.l)

; text and font
iAddStaticText.l(text.s,  x.l,  y.l,  rx.l,  ry.l, border.b=#False, wordWrap.b=#True, fillBackground.b=#False, *parent.l=#Null, Id.l=-1)
iLoadFont(filename.s, egui.l = #EGDF_DEFAULT )
iGetFont.l()
iDrawText(*font.IGUIFont, text.s,  x.l,  y.l,  rx.l,  ry.l, color.l=$FF9999FF)
iGUIText_EnableOverrideColor(*text.IGUIStaticText, enable.b)
iGUIText_OverrideColor.l(*text.IGUIStaticText)
iGUIText_OverrideFont.l(*text.IGUIStaticText)  ; return IGUIFont*
iGUIText_Height.l(*text.IGUIStaticText)
iGUIText_Width.l(*text.IGUIStaticText)
iBackgroundColor_GUIText(*text.IGUIStaticText, color.l=$FFFFFFFF)
iDrawBackground_GUIText(*text.IGUIStaticText,  draw.b)
iDrawBorder_GUIText(*text.IGUIStaticText,  draw.b)
iOverrideColor_GUIText(*text.IGUIStaticText,  color.l=$FFFFFFFF)
iOverrideFont_GUIText(*text.IGUIStaticText, *font.IGUIFont)
iAlignment_GUIText(*text.IGUIStaticText, h.l, v.l)
iWordWrap_GUIText(*text.IGUIStaticText,  enable.b)
; button
iAddButtonGUI.l(orx.l, ory.l, sx.l, sy.l,  text.s, tooltiptext.s="", *parent.IGUIElement=#Null , Id.l=-1  )
iGUIButton_AlphaChannel.l(*button.IGUIElement )
iGUIButton_DrawingBorder.l(*button.IGUIElement )
iGUIButton_Pressed.l(*button.IGUIElement )
iGUIButton_PushButton.l(*button.IGUIElement )
iDrawBorder_GUIButton(*button.IGUIElement, border.b=#True)
iImage_GUIButton(*button.IGUIElement, *image.ITexture=#Null)
iPushButton_GUIButton(*button.IGUIElement, isPushButton.b=#False )
iOverrideFont_GUIButton(*button.IGUIElement, *font.IGUIFont  )
iPressed_GUIButton(*button.IGUIElement,  pressed.b=#True  )
iPressedImage_GUIButton(*button.IGUIElement,  *image.ITexture=#Null)
iSprite_GUIButton(*button.IGUIElement, state.l, index.l, color.l=$FFFFFFFF, loop.b=#False )
iSpriteBank_GUIButton(*button.IGUIElement,  *bank.IGUISpriteBank )
iAlphaChannel_GUIButton(*button.IGUIElement,  useAlphaChannel.b=#False )
; CursorControl
iCursorControlPosition( *posx.l, *posy.l)
iCursorControlRelativePosition( *posx.F, *posy.F)
iCursorControlVisible.l()
iPositionCursorControl( x.l, y.l)
iReferenceRectCursorControl( orx.l, ory.l, sx.l, sy.l)
iVisibleCursorControl( visible.b=#True )
iCursorControlX.l()
iCursorControlY.l()
; CheckBox
iAddCheckBoxGUI.l( checked.b, orx.l, ory.l, sx.l, sy.l,  text.s, *parent.IGUIElement=#Null , Id.l=-1  )
iGUICheckBox_Check.l( *check.IGUICheckBox )
iCheck_GUICheckBox(*check.IGUICheckBox , checked.b=#True  )
; EditBox
iAddEditBox.l(text.s, x.l,  y.l,  rx.l,  ry.l, border.b=#True, *parent.IGUIElement=#Null , Id.l=-1  )
iEnableOverrideColor_GUIEditBox(*gui.IGUIEditBox , enable.b)
iGUIEditBox_Max.l(*gui.IGUIEditBox)
iGUIEditBox_AutoScrollEnabled.l(*gui.IGUIEditBox)
iGUIEditBox_TextDimension(*gui.IGUIEditBox, *dimx.l, *dimy.l)
iGUIEditBox_MultiLineEnabled.l(*gui.IGUIEditBox)
iAutoScroll_GUIEditBox(*gui.IGUIEditBox, enable.b=#True)
iDrawBorder_GUIEditBox(*gui.IGUIEditBox, enable.b=#True)
iMax_GUIEditBox(*gui.IGUIEditBox, mm.l=128)
iMultiline_GUIEditBox(*gui.IGUIEditBox, enable.b=#True)
iOverrideColor_GUIEditBox(*gui.IGUIEditBox, color.l=$FFFFFFFF)
iOverrideFont_GUIEditBox(*gui.IGUIEditBox, *font.IGUIFont  )
iTextAlignment_GUIEditBox(*gui.IGUIEditBox, h.l, v.l)
; GUI Image
iAddImageGUI.l(*img.ITexture, posx.l, posy.l, useAlphaChannel.b=#True, text.s="text", *parent.IGUIElement=#Null , Id.l=-1 )
iAddEmptyImageGUI.l(posx.l, posy.l, osx.l, osy.l, text.s, *parent.IGUIElement=#Null , Id.l=-1 )
iGUIImage_AlphaChannelUsed.l( *img.IGUIImage )
iGUIImage_ImageScaled.l(*img.IGUIImage)
iColor_GUIImage(*img.IGUIImage, color.l=$FFFFFFFF )
iImage_GUIImage(*img.IGUIImage,  *image.ITexture )
iScale_GUIImage(*img.IGUIImage, enable.b )
iAlphaChannel_GUIImage(*img.IGUIImage, enable.b=#True )
; ComboBox
iAddComboBoxGUI.l( x.l,  y.l,  rx.l,  ry.l, *parent.IGUIElement=#Null , Id.l=-1 )
iAddItem_GUIComboBox.l( *combo.IGUIComboBox, text.s)
iClear_GUIComboBox(*combo.IGUIComboBox)
iGUIComboBox_Item.l(*combo.IGUIComboBox,  idx.l=0)
iGUIComboBox_ItemCount.l(*combo.IGUIComboBox)
iGUIComboBox_Selected.l(*combo.IGUIComboBox)
iRemoveItem_GUIComboBox(*combo.IGUIComboBox, idx.l=0)
iSelected_GUIComboBox(*combo.IGUIComboBox, idx.l=0)
iTextAlignment_GUIComboBox(*combo.IGUIComboBox, h.l, v.l)
; ContextMenu
iAddContexMenuGUI.l(x.l,  y.l,  rx.l,  ry.l, *parent.IGUIElement=#Null , Id.l=-1 )
iAddItem_GUIContexMenu.l(*menu.IGUIContextMenu, text.s, commandId.l=-1, enable.b=#True, hasSubMenu.b=#False , checked.b=#False )
iAddSeparator_GUIContexMenu(*menu.IGUIContextMenu)
iGUIContexMenu_ItemCommandId.l(*menu.IGUIContextMenu, idx.l=0)
iGUIContexMenu_ItemCount.l(*menu.IGUIContextMenu)
iGUIContexMenu_ItemText.l(*menu.IGUIContextMenu, idx.l=0)
iGUIContexMenu_ItemSelected.l(*menu.IGUIContextMenu)
iGUIContexMenu_SubMenu.l(*menu.IGUIContextMenu, idx.l=0)
iGUIContexMenu_ItemChecked.l(*menu.IGUIContextMenu, idx.l=0)
iGUIContexMenu_ItemEnabled.l(*menu.IGUIContextMenu, idx.l=0)
iRemoveAll_GUIContexMenu(*menu.IGUIContextMenu)
iRemoveItem_GUIContexMenu(*menu.IGUIContextMenu, idx.l=0)
iItemChecked_GUIContexMenu(*menu.IGUIContextMenu, idx.l=0, enable.b=#True)
iItemCommanId_GUIContexMenu(*menu.IGUIContextMenu, idx.l=0, Id.l=-1)
iItemEnabled_GUIContexMenu(*menu.IGUIContextMenu, idx.l=0, enable.b=#True)
iItemText_GUIContexMenu(*menu.IGUIContextMenu, idx.l, text.s)
; Sprite Bank
iAddEmptySpriteBankGUI.l(name.s)
iAddTexture_GUISpriteBank(  *sp.IGUISpriteBank,  *texture.ITexture  )
iDraw2D_GUISpriteBank( *sp.IGUISpriteBank, index.l, posx.l, posy.l, color.l=$FFFFFFFF, starttime.l=0,	currenttime.l=0, loop.b=#True, center.b=#False, *clipox.l=#Null ) 
iGUISpriteBank_Texture( *sp.IGUISpriteBank, idx.l=0)
iGUISpriteBank_TextureCount( *sp.IGUISpriteBank)
iTexture_GUISpriteBank( *sp.IGUISpriteBank, idx.l, *texture.ITexture)
; FileOpenDialog
iAddFileOpenDialogGUI( title.s, modal.b=#True, *parent.IGUIElement=#Null , Id.l=-1 )
iGUIFileOpenDialog_FileName.l( *dial.IGUIFileOpenDialog )
; InOutFader
iAddInOutFaderGUI.l(*rect.l, *parent.IGUIElement=#Null , Id.l=-1 ); return IGUIInOutFader*
iFadeIn_GUIInOutFader( *inout.IGUIInOutFader,  time.l)
iFadeOut_GUIInOutFader(*inout.IGUIInOutFader, time.l)
iGUIInOutFader_Color.l(*inout.IGUIInOutFader)
iGUIInOutFader_Ready.l(*inout.IGUIInOutFader)
iColor_GUIInOutFader(*inout.IGUIInOutFader,  color.l=$FFFFFFFF)
; ListBox
iAddListBoxGUI.l( orx.l,  ory.l,  sx.l,  sy.l,  drawBackground.b=#True, *parent.IGUIElement=#Null , Id.l=-1 )
iAddItem_GUIListBox(*lbox.IGUIListBox, item.s, icon.l=-1)
iClear_GUIListBox(*lbox.IGUIListBox)
iClearItemOverrideColor_GUIListBox(*lbox.IGUIListBox,  idx.l)
iGUIListBox_Icon.l(*lbox.IGUIListBox,  idx.l)
iGUIListBox_ItemCount.l(*lbox.IGUIListBox)
iGUIListBox_ItemDefaultColor.l(*lbox.IGUIListBox,  colorType.l )
iGUIListBox_ItemOverrideColor.l(*lbox.IGUIListBox,  idx.l,  colorType.l )
iGUIListBox_ListItem.l(*lbox.IGUIListBox,  idx.l)
iGUIListBox_Selected.l(*lbox.IGUIListBox)
iGUIListBox_HasItemOverrideColor.l(*lbox.IGUIListBox,  idx.l,  colorType.l )
iInsertItem_GUIListBox.l(*lbox.IGUIListBox,  idx.s, item.s,  icon.l )
iGUIListBox_AutoScrollEnabled.l(*lbox.IGUIListBox)
iRemoveItem_GUIListBox(*lbox.IGUIListBox,  idx.l)
iAutoScrollEnabled_GUIListBox(*lbox.IGUIListBox,  scroll.b=#True)
iItem_GUIListBox(*lbox.IGUIListBox,  idx.l, item.s,  icon.l )
iItemOverrideColor_GUIListBox(*lbox.IGUIListBox,  idx.l,  colorType.l,  color.l )
iSelected_GUIListBox(*lbox.IGUIListBox,  idx.l)
iSpriteBank_GUIListBox(*lbox.IGUIListBox,   *bank.IGUISpriteBank  )
iSwapItems_GUIListBox(*lbox.IGUIListBox,  idx1.l,  idx2.l)
; Menu
iAddMenuGUI.l(*parent.IGUIElement=#Null , Id.l=-1 )
; messagebox
iAddMessageBoxGUI.l(caption.s, text.s, modal.b=#True, flag.l=#EMBF_OK, *parent.IGUIElement=#Null , Id.l=-1 )
iGUIMessageBox_CloseButton.l( *mb.IGUIWindow)
iGUIMessageBox_MaximizeButton.l(*mb.IGUIWindow)
iGUIMessageBox_MinimizeButton.l(*mb.IGUIWindow)
; modal screen
iAddModalScreenGUI.l(*parent.IGUIElement=#Null)
; scroll bar
iAddScrollBarGUI.l( horizontal.b, orx.l,  ory.l,  sx.l,  sy.l, *parent.IGUIElement=#Null , Id.l=-1 )
iGUIScrollBar_LargeStep.l( *sb.IGUIScrollBar)
iGUIScrollBar_Max.l(*sb.IGUIScrollBar)
iGUIScrollBar_Pos.l(*sb.IGUIScrollBar)
iGUIScrollBar_SmallStep.l(*sb.IGUIScrollBar)
iLargeStep_GUIScrollBar(*sb.IGUIScrollBar,  value.l)
iMax_GUIScrollBar(*sb.IGUIScrollBar,  value.l)
iPos_GUIScrollBar(*sb.IGUIScrollBar,  value.l)
iSmallStep_GUIScrollBar(*sb.IGUIScrollBar,  value.l)
; spin box
iAddSpinBoxGUI.l(text.s, orx.l,  ory.l,  sx.l,  sy.l, border.b=#True, *parent.IGUIElement=#Null , Id.l=-1 )
iGUISpinBox_EditBox.l( *spb.IGUISpinBox)
iGUISpinBox_Max.F(*spb.IGUISpinBox)
iGUISpinBox_Min.F(*spb.IGUISpinBox)
iGUISpinBox_StepSize.F(*spb.IGUISpinBox)
iGUISpinBox_Value.F(*spb.IGUISpinBox)
iDecimalPlaces_GUISpinBox(*spb.IGUISpinBox, value.l)
iRange_GUISpinBox(*spb.IGUISpinBox,  min.F,  max.F)
iStepSize_GUISpinBox(*spb.IGUISpinBox, sStep.F)
iValue_GUISpinBox(*spb.IGUISpinBox, value.F)
; tabcontrol 
iAddTabControlGUI(orx.l,  ory.l,  sx.l,  sy.l, fillBackground.b=#False,	border.b=#True, *parent.IGUIElement=#Null , Id.l=-1 )
iAddTab_GUITabControl.l(*tabc.IGUITabControl, caption.s, Id.l=-1)
iGUITabControl_ActiveTab.l(*tabc.IGUITabControl)
iGUITabControl_Tab.l(*tabc.IGUITabControl, idx.l=-1)
iGUITabControl_TabCount.l(*tabc.IGUITabControl)
iGUITabControl_TabExtraWidth.l(*tabc.IGUITabControl)
iGUITabControl_TabHeight.l(*tabc.IGUITabControl)
iGUITabControl_TabVerticalAlignment.l(*tabc.IGUITabControl)
iActiveTab_GUITabControl.l(*tabc.IGUITabControl,  *tab.IGUIElement )
iActiveTabId_GUITabControl.l(*tabc.IGUITabControl, idx.l=0 )
iTabExtraWidth_GUITabControl(*tabc.IGUITabControl,  extraWidth.l  )
iTabHeight_GUITabControl(*tabc.IGUITabControl, height.l )
iTabVerticalAlignment_GUITabControl(*tabc.IGUITabControl, align.l )
; tab functions
iAddTabGUI(orx.l,  ory.l,  sx.l,  sy.l, *parent.IGUIElement=#Null , Id.l=-1 )
iBackgroundColor_GUITab( *tab.IGUITab, color.l=$FFFFFFFF)
iGUITab_BackgroundColor.l(*tab.IGUITab)
iGUITab_Number.l(*tab.IGUITab)
iGUITab_TextColor.l(*tab.IGUITab)
iGUITab_isDrawingBackground.l(*tab.IGUITab)
iDrawBackground_GUITab(*tab.IGUITab, flag.b=#True)
iTextColor_GUITab(*tab.IGUITab,  color.l=$FFFFFFFF)
; Table
iAddTableGUI.l(orx.l,  ory.l,  sx.l,  sy.l, drawBackground.b=#True, *parent.IGUIElement=#Null , Id.l=-1 )
iAddColumn_GUITable(*table.IGUITable, caption.s, columnIndex.l=-1 )
iAddRow_GUITable(*table.IGUITable,  rowIndex.l )
iClear_GUITable(*table.IGUITable)
iClearRows_GUITable(*table.IGUITable)
iGUITable_ActiveColumn.l(*table.IGUITable)
iGUITable_ActiveColumnOrdering.l(*table.IGUITable)
iGUITable_CellData.l(*table.IGUITable,  rowIndex.l,  columnIndex.l)
iGUITable_CellText.l(*table.IGUITable,  rowIndex.l,  columnIndex.l)   
iGUITable_ColumnCount.l(*table.IGUITable)   
iGUITable_DrawFlags.l(*table.IGUITable)   
iGUITable_RowCount.l(*table.IGUITable)   
iGUITable_Selected.l(*table.IGUITable)   
iGUITable_hasResizableColumns.l(*table.IGUITable)
iOderRows_GUITable(*table.IGUITable,  columnIndex.l=-1, mode.l=#EGOM_NONE ) 
iRemoveColumn_GUITable(*table.IGUITable, columnIndex.l=-1)
iRemoveRow_GUITable(*table.IGUITable, columnIndex.l=-1)
iActiveColumn_GUITable(*table.IGUITable,  index.l,  doOrder.b=#False)   
iCellColor_GUITable(*table.IGUITable, rowIndex.l, columnIndex.l, color.l=$FFFFFFFF)
iCellData_GUITable(*table.IGUITable, rowIndex.l, columnIndex.l, *ddata.l)
iCellText_GUITable(*table.IGUITable, rowIndex.l, columnIndex.l, text.s, color.l=$FFFFFFFF)
iColumnOrdering_GUITable(*table.IGUITable, columnIndex.l, mode.l=#EGCO_NONE  ) 
iColumnWidth_GUITable(*table.IGUITable, columnIndex.l,  width.l) 
iDrawFlags_GUITable(*table.IGUITable, flag.l)
iResizableColumns_GUITable(*table.IGUITable, flag.b) 
iSwapRows_GUITable(*table.IGUITable, rowindexA.l, rowindexB.l) 
; ToolBar
iAddToolBarGUI.l(*parent.IGUIElement=#Null , Id.l=-1 )
iAddButton_GUIToolBar(*tb.IGUIToolBar, text.s, tooltiptext.s, *img.ITexture=#Null,*pressedimg.ITexture=#Null,  isPushButton.b=#False,  useAlphaChannel.b=#False, Id.l=-1)
; GUI Window
iAddWindowGUI.l(orx.l,  ory.l,  sx.l,  sy.l, text.s="window", modal.b=#False, *parent.IGUIElement=#Null , Id.l=-1 )
iGUIWindow_CloseButton.l( *win.IGUIWindow )
iGUIWindow_MaximizeButton.l( *win.IGUIWindow )
iGUIWindow_MinimizeButton.l( *win.IGUIWindow )
; GUI Environement, to be continued....
iSetSkinGUI.l( type.l )
iClearGUI()
iGUI_BuiltInFont.l()
iGUI_Focus.l()
iGUI_SpriteBank.l(filename.s)
iGUI_VideoDriver.l()
iFocus_GUI.l( *element.IGUIElement )
iGUI_HasFocus.l( *element.IGUIElement )
iLoad_GUI.l( filename.s, *parent.IGUIElement=#Null )
iSave_GUI.l( filename.s, *start.IGUIElement=#Null  )
;  Skin GUI
iCustomSkinGUI.l(configSkinname.s)
iColor_GUISkin(*skin.IGUISkin, which.l=#EGDC_3D_FACE ,  color.l=$FFFFFFFF)
iGUISkin_Color.l(*skin.IGUISkin, which.l=#EGDC_3D_FACE)
iSkinGUI_Curent.l()
iSize_GUISkin(*skin.IGUISkin, which.l,  size.l)
iGUISkin_Size.l(*skin.IGUISkin, which.l)
iDefaultText_GUISkin(*skin.IGUISkin, which.l, text.s)
; progress bar (only with Custum Skin loaded
iAddProgressBarGUI.l(orx.l,  ory.l,  sx.l,  sy.l, *parent.IGUIElement=#Null)
iValue_ProgressBarGUI(*bar.IGUIProgressBar,  progress.F=0.5)
iProgressBarGUI_Value.F(*bar.IGUIProgressBar)
iGUIProgressBar_Color.l(*bar.IGUIProgressBar)
iColor_GUIProgressBar(*bar.IGUIProgressBar,  color.l=$FFFFFFFF)
iAutomaticText_GUIProgressBar(*bar.IGUIProgressBar,  format.s)
iEmptyColor_GUIProgressBar(*bar.IGUIProgressBar, color.l=$FFFFFFFF)
iGUIProgressBar_EmptyColor(*bar.IGUIProgressBar)

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- Event Input Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iGetKey.l()
iMouseEvent.l()
iGetKeyDown.l( keyCode.l)
iGetKeyUp.l( keyCode.l)
iGetMouseX.l()
iGetMouseY.l()
iGetDeltaMouseX.l(fcursor.b=#False)
iGetDeltaMouseY.l(fcursor.b=#False)
iGetMouseEvent.l(event.l)
iGetLastKey.l()
iPositionCursor( x.F,  y.F)
iCursorX.l()
iCursorY.l()
; Joystick
iActivateJoysticks()
iJoysticksAxis.l(axis.l)
iJoysticksButtonStates.l()
iJoysticksPOV.l()
iJoysticksJoy.l()

; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-CORE Utils Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iCreateArray.l() ; return IArray
iPushbackArray( *arr.IArray,  *el.l) 
iPushfrontArray( *arr.IArray,  *el.l) 
iArrayElement.l( *arr.IArray,  i.l)
iArraySize.l( *arr.IArray )  
iFreeArray( *arr.IArray) 
iProjectionMatrixOrthoLH(w.F,  h.F, *projection.iMATRIX, zNear.F=0.1,  zFar.F=100.0)
iProjectionMatrixOrthoRH(w.F,  h.F, *projection.iMATRIX, zNear.F=0.1,  zFar.F=100.0)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- SHADER Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iVersionShader(VSType.l=#EVST_VS_1_1, PSType.l=#EPST_PS_1_1)
iCreateShaderHighLevel.l(vsFileName.s, EntryNameVS.s, psFileName.s, EntryNamePS.s, videottype.l, *constantshaderFnt.l, *materialshaderFnt.l )
iCreateShader.l(vsFileName.s, psFileName.s, videottype.l, *constantshaderFnt.l, *materialshaderFnt.l)

iBasicRenderStatesMaterialServices(*services.IMaterialServices, *material.IMaterial, *lastMaterial.IMaterial,   resetAllRenderstates.b  )
iPixelShaderConstantMaterialServices(*services.IMaterialServices,		*fData.F,  startRegister.l,   constantAmount.l=1  )
iPixelShaderConstantNMaterialServices(*services.IMaterialServices,	name.s,  *float.F,   count.l)
iVertexShaderConstantMaterialServices(*services.IMaterialServices,	*fData.F,  startRegister.l,   constantAmount.l=1  )
iVertexShaderConstantNMaterialServices(*services.IMaterialServices, name.s,  *float.F,   count.l)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- PHYSIC 
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

iFreePhysic()
iInitPhysic()
iUpdatePhysic(timer.F=60.0)
iSetWorldSize(minx.F, miny.F, minz.F, maxx.F, maxy.F, maxz.F)
iGravityForce(x.F, y.F, z.F)
iSetCollideForm(form.l=1)
iTimerUpdatePhysic(timer.F = 60.0)
; rigid body
iCreateBody.l(*ent.IMesh, dynamique.b=#True, vx.F=0, vy.F=0, vz.F=0, mass.F=1.0)
iCreateTerrainBody.l(*terrain.ITerrain)
iBodyRestoreCallbacks(*ebody.IBodySceneNode) 
iFreeBody(*ebody.IBodySceneNode)
;iCoriolisForcesModeBody(*ebody.IBodySceneNode, value.b) 
iMatrixBody(*ebody.IBodySceneNode, *mat.F)
iMomentOfInertiaBody(*ebody.IBodySceneNode, x.F, y.F, z.F) 
;iAutoFreezeBody(*ebody.IBodySceneNode,  value.b)
iMassCenterBody(*ebody.IBodySceneNode, x.F, y.F, z.F)
iBodyCentreOfMass(*ebody.IBodySceneNode, *mass_center.F) 
iMassBody(*ebody.IBodySceneNode,  mass.F)
iLinearDampingBody(*ebody.IBodySceneNode, value.F)
iBodyMomentOfInertia(*ebody.IBodySceneNode, *res.F) 
;iFreezeBody(*ebody.IBodySceneNode,  value.b)
iBodyMass.F(*ebody.IBodySceneNode)
iAddForceBody(*ebody.IBodySceneNode, x.F, y.F, z.F)
iForceBody(*ebody.IBodySceneNode, x.F, y.F, z.F)
iAddDirectForceBody(*body.l, x.F, y.F, z.F)
iDirectForceBody(*body.l, x.F, y.F, z.F)
iAddForceContinuousBody(*ebody.IBodySceneNode, x.F, y.F, z.F) 
iAddTorqueBody(*ebody.IBodySceneNode, x.F, y.F, z.F)
iTorqueBody(*ebody.IBodySceneNode, x.F, y.F, z.F)
iOmegaBody(*ebody.IBodySceneNode, x.F, y.F, z.F) 
iVelocityBody(*ebody.IBodySceneNode, x.F, y.F, z.F) 
iCalculateMomentOfInertiaBody(*ebody.IBodySceneNode) 
iPositionBody(*ebody.IBodySceneNode, posx.F, posy.F, posz.F) 
iBodyX.F(*ebody.IBodySceneNode) 
iBodyY.F(*ebody.IBodySceneNode) 
iBodyZ.F(*ebody.IBodySceneNode) 
iTranslateBody(*ebody.IBodySceneNode, posx.F, posy.F, posz.F) 
iRotateBody(*ebody.IBodySceneNode, rotx.F, roty.F, rotz.F) 
iBodyOmega(*ebody.IBodySceneNode, *omega.F) 
iAngularDampingBody(*ebody.IBodySceneNode, x.F, y.F, z.F)
ibodyvelocity(*ebody.IBodySceneNode, *velocity.F) 
iContinuousCollisionModeBody(*ebody.IBodySceneNode,  value.b) 
iBodyContinuousCollisionMode.l(*ebody.IBodySceneNode) 
iBodyPosition(*ebody.IBodySceneNode, *pos.F) 
iBodyRotation(*ebody.IBodySceneNode, *rot.F) 
iPulseBody(*ebody.IBodySceneNode, delta_velocityx.F, delta_velocityy.F, delta_velocityz.F, impulse_centerx.F=0,  impulse_centery.F=0,  impulse_centerz.F=0)
iCollisionBody(*ebody.IBodySceneNode, *newCollision.l) 
iBodyNode.l(*ebody.IBodySceneNode)
iApplyForceAndTorqueBody(*ebody.IBodySceneNode, *callback.l)
iBodyIBodySceneNode.l(*body.l)
iBodyCollideBody.l(*ebody.IBodySceneNode)
iBodyNumCollideBody.l(*ebody.IBodySceneNode)
iCalculateAABBBody(*ebody.IBodySceneNode, *box.AABBOX) 
iMatrixRecursiveBody(*ebody.IBodySceneNode, *matrix.F)
iJointRecursiveCollisionBody(*ebody.IBodySceneNode, state.l)
iBodySleepState.l(*ebody.IBodySceneNode)
iBodyAutoSleep.l(*ebody.IBodySceneNode)
iAutoSleepBody(*ebody.IBodySceneNode, state.l)
iBodyCollision.l(*ebody.IBodySceneNode)
iBodyJointRecursiveCollision.l(*ebody.IBodySceneNode) 
iBodyMatrix(*ebody.IBodySceneNode, *matrix.F) 
iBodyForce(*ebody.IBodySceneNode, *force.F) 
iBodyTorque(*ebody.IBodySceneNode, *torque.F) 
iBodyLinearDamping.F(*ebody.IBodySceneNode) 
iBodyAngularDamping(*ebody.IBodySceneNode, *tt.F) 
iBodyAABB(*ebody.IBodySceneNode, *p0.F, *p1.F)
; collision instruction
iCollideNodeType(*ent.IMesh,  type.l,  vx.F=0, vy.F=0, vz.F=0)
iCollideTerrainType(*terrain.ITerrain, type.l)
iNodeCollide.l(*entA.IMesh, *entB.IMesh)
iNodeCollideAll.l(*ent.IMesh)
iCollidePointDistance.l(*ent.IMesh, x.F, y.F, z.F)
iCollideRayCast.F(*ent.IMesh, x.F, y.F, z.F, dx.F, dy.F, dz.F, type.l=1)
iCollideRayCastAll.l( x.F, y.F, z.F, dx.F, dy.F, dz.F, type.l, *dist.F)
iCollidePoint(*tri.F,  index.l)
iCollideNormal(*tri.F,  index.l)
iCollideNode.l(index.l=0)
; material
iCreatePhysicMaterial.l()
iCreatePhysicMaterialPair.l( mat1.l,  mat2.l)
iElasticityPhysicMaterial(*pr.IMaterialPair , val.F)
iFrictionPhysicMaterial(*pr.IMaterialPair, valstatic.F,  valdynamic.F)
iSoftnessPhysicMaterial(*pr.IMaterialPair,  val.F)
iGroupPhysicMaterialBody(*ebody.IBodySceneNode,  mat.l)
iBodyPhysicMaterialGroup.l(*ebody.IBodySceneNode)
iCollidablePhysicMaterial(*pr.IMaterialPair,  state.l)
iCollisionMemPhysicMaterial(*pr.IMaterialPair, flag.b=#True)
; Joints 
iFreeJoint(*joint.IJoint)
iCreateBallJoint.l(*eBody1.IBodySceneNode, *eBody2.IBodySceneNode ,  x.F,  y.F,  z.F)
iBallSetConeLimits(*ball.IJoint,  x.F,  y.F,  z.F,  maxConeAngle.F,  maxTwistAngle.F)
iCreateHingeJoint.l(*eBody1.IBodySceneNode, *eBody2.IBodySceneNode, x.F,  y.F,  z.F, dirx.F,  diry.F,  dirz.F)
iCreateSliderJoint.l(*eBody1.IBodySceneNode, *eBody2.IBodySceneNode, x.F,  y.F,  z.F, dirx.F,  diry.F,  dirz.F)
iCreateCorkScrewJoint.l(*eBody1.IBodySceneNode, *eBody2.IBodySceneNode, x.F,  y.F,  z.F, dirx.F,  diry.F,  dirz.F)
iCreateUniversalJoint.l(*eBody1.IBodySceneNode, *eBody2.IBodySceneNode, x.F,  y.F,  z.F, dirx.F,  diry.F,  dirz.F, diox.F,  dioy.F,  dioz.F)
iCreateUpVectorJoint.l(*ebody.IBodySceneNode, x.F,  y.F,  z.F)
iCreateUserJoint.l(*child.IBodySceneNode, *parent.IBodySceneNode,  maxDOF.l,  *callback.l)
iJointCollisionState.l(*joint.IJoint)
iCollisionStateJoint(*joint.IJoint,  state.l)
iJointStiffness.F(*joint.IJoint)
iStiffnessJoint(*joint.IJoint,  state.F)
iUserCallbackBallJoint(*joint.IJoint,  *callback.l)
iBallJointAngle(*joint.IJoint, *angle.F)
iBallJointOmega(*joint.IJoint, *angle.F)
iBallJointForce(*joint.IJoint, *force.F)
iUserCallbackHingeJoint(*joint.IJoint,  *callback.l)
iHingeJointAngle.F(*joint.IJoint)
iHingeJointOmega.F(*joint.IJoint)
iHingeJointForce(*joint.IJoint, *force.F)
iUserCallbackSliderJoint(*joint.IJoint,  *callback.l)
iSliderJointForce(*joint.IJoint, *force.F)
iSliderJointPosit.F(*joint.IJoint)
iSliderJointVeloc.F(*joint.IJoint)
iUserCallbackCorkscrewJoint(*joint.IJoint,  *callback.l)
iCorkscrewJointPosit.F(*joint.IJoint)
iCorkscrewJointAngle.F(*joint.IJoint)
iCorkscrewJointVeloc.F(*joint.IJoint)
iCorkscrewJointOmega.F(*joint.IJoint)
iCorkscrewJointForce(*joint.IJoint, *force.F)
iUserCallbackUniversalJoint(*joint.IJoint,  *callback.l)
iUniversalJointAngle0.F(*joint.IJoint)
iUniversalJointAngle1.F(*joint.IJoint)
iUniversalJointOmega0.F(*joint.IJoint)
iUniversalJointOmega1.F(*joint.IJoint)
iUniversalJointForce(*joint.IJoint, *force.F)
iUpVectorGetPin(*joint.IJoint, *pin.F)
iSetPinUpVector(*joint.IJoint, *pin.F)
iAddLinearRowUserJoint(*joint.IJoint, *pivot0.F, *pivot1.F, *dir.F)
iAddAngularRowUserJoint(*joint.IJoint,  relativeAngle.F,  *dir.F)
iAddGeneralRowUserJoint(*joint.IJoint,  *jacobian0.F,  *jacobian1.F)
iRowMinimumFrictionUserJoint(*joint.IJoint,  friction.F)
iRowMaximumFrictionUserJoint(*joint.IJoint,  friction.F)
iRowAccelerationUserJoint(*joint.IJoint,  acceleration.F)
iRowSpringDamperAccelerationUserJoint(*joint.IJoint,  springK.F, springD.F)
iRowStiffnessUserJoint(*joint.IJoint,  stiffness.F)
iUserJointRowForce.F(*joint.IJoint,  row.l)
; specific Newton 2.0
iFreezeBody(*ebody.IBodySceneNode,  value.b)
iPhysicThreadsCount.l()
iThreadsCountPhysic(threads.l=1)

; material inside call back
iPhysicMaterialEventCallBack(*pr.IMaterialPair, *materialCallBack.l)
iPhysicMaterialCallBackAABBOverlap(*pr.IMaterialPair, *materialCallBack.l)
iPhysicMaterialPairUserData.l(*material.IPMaterial)
iPhysicMaterialContactFaceAttribute.l(*material.IPMaterial)
iPhysicMaterialBodyCollisionID.l(*material.IPMaterial, *ebody.IBodySceneNode)
iPhysicMaterialContactNormalSpeed.F(*material.IPMaterial)
iPhysicMaterialContactForce(*material.IPMaterial, *force.F)
iPhysicMaterialContactPositionAndNormal(*material.IPMaterial, *posit.F,  *normal.F)
iPhysicMaterialContactTangentDirections(*material.IPMaterial, *dir0.F, *dir1.F)
iPhysicMaterialContactTangentSpeed.F(*material.IPMaterial,  index.l)
iContactSoftnessPhysicMaterial(*material.IPMaterial,  softness.F)
iContactElasticityPhysicMaterial(*material.IPMaterial,  restitution.F)
iContactFrictionStatePhysicMaterial(*material.IPMaterial,  state.l,  index.l)
iContactFrictionCoefPhysicMaterial(*material.IPMaterial,  staticFrictionCoef.F,  kineticFrictionCoef.F,  index.l)
iContactNormalAccelerationPhysicMaterial(*material.IPMaterial,  accel.F)
iContactNormalDirectionPhysicMaterial(*material.IPMaterial, *directionVector.F)
iContactTangentAccelerationPhysicMaterial(*material.IPMaterial,  accel.F,  index.l)
iContactRotateTangentDirectionsPhysicMaterial(*material.IPMaterial, *directionVector.F)


; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;- XEFFECTS Functions v1.0
; ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
iInitXEffect( folder.s="XShaders")
iAddShadowToNodeXEffect(*node.IMesh, filterType.l=#EFT_NONE,  shadowMode.l=#ESM_BOTH)
iRemoveShadowNodeXEffect(*node.IMesh)
iAddToNodeXEffect(*node.IMesh, EffectType.l=3)
iAmbientColorXEffect(color.l=$FFFFFFFF)
iClearColorXEffect(color.l=$FFFFFFFF)
iUpdateXEffect()
iAddShadowLightXEffect(x.F, y.F, z.F, tx.F=0, ty.F=0, tz.F=0, color.l=$FFFFFFFF, nearValue.F=10.0,  farValue.F=230.0, fov.F=90.0, shadowDimen.l=512, directionnal.b=#False)
iPostProcessingUserTextureXEffect(*userTexture.ITexture)
iAddFilePostProcessingXEffect.l(filename.s)
iRemovePostProcessingXEffect( MaterialType.l)
iAddPostProcessingXEffect.l(MaterialType.l)
iAddNodeToDepthPassXEffect(*node.IMesh)
iDepthPassXEffect( flag.b = #True)
iPositionShadowLightXEffect( index.l,  x.F,  y.F,  z.F)
iTargetShadowLightXEffect( index.l, x.F,  y.F,  z.F)
iColorShadowLightXEffect( index.l,  color.l=$FFFFFFFF)
iResolutionShadowLightXEffect( index.l,  res.l=512)
iShadowLightXEffectCount()

EndImport

; ------------------------------------------------------------
;
;   PureBasic - n3xt-D 1.0 version
;
;    (c) 2009 - www.PureBasic3D.com
;
; revision 001 date: 08-mars-09 by TMyke
; ------------------------------------------------------------

Structure iLOGBRUSH
  lbStyle.l
  lbColor.l
  lbHatch.l
EndStructure

Structure S3DVertex
  x.F
  y.F
  z.F
  nx.F
  ny.F
  nz.F
  color.l
  tu.F
  tv.F
EndStructure

Structure S3DVertex2TCoords
  x.F
  y.F
  z.F
  nx.F
  ny.F
  nz.F
  color.l
  tu1.F
  tv1.F
  tu2.F
  tv2.F
EndStructure

Structure S3DVertexTangents
  x.F
  y.F
  z.F
  nx.F
  ny.F
  nz.F
  color.l
  tu.F
  tv.F
  tangx.F
  tangy.F
  tangz.F
  binormx.F
  binormy.F 
  binormz.F   
EndStructure


Structure NewtonHingeSliderUpdateDesc
	m_accel.F
	m_minFriction.F
	m_maxFriction.F
	m_timestep.F
EndStructure



Structure IObject
EndStructure

Structure INode
EndStructure

  Structure IPivot Extends INode
  EndStructure

  Structure IMesh Extends INode
  EndStructure

  Structure IMMesh Extends INode
  EndStructure

  Structure IBolt
  EndStructure

  Structure ICamera Extends INode
  EndStructure

  Structure ILight Extends INode
  EndStructure

  Structure IVolumeLight Extends INode
  EndStructure

  Structure IText Extends INode
  EndStructure

  Structure IParticleSystem Extends INode
  EndStructure

      Structure IParticle Extends IParticleSystem
      EndStructure

  Structure IBillboard Extends INode
  EndStructure

  Structure ITerrain Extends INode
  EndStructure

  Structure IAnimatedMesh Extends INode
  EndStructure

  Structure IBoneNode Extends INode
  EndStructure

  Structure IShadowVolumeNode Extends INode
  EndStructure

  Structure ISpriteSceneNode Extends INode
  EndStructure

  Structure ISprite2D Extends INode
  EndStructure

Structure IMeshBuffer
EndStructure


Structure INodeAnimator
EndStructure

Structure IAnimatorCollisionResponse
EndStructure

Structure IMaterial
EndStructure

Structure ITexture
EndStructure

Structure IImage
EndStructure

Structure IArray
EndStructure

Structure IMaterialServices
EndStructure

Structure IReadFile
EndStructure

Structure IWriteFile
EndStructure

Structure IFileList
EndStructure

;-----------------------------
; GUI
Structure IGUIFont
EndStructure

Structure IGUIElement
EndStructure

    Structure IGUICheckBox Extends IGUIElement
    EndStructure
    Structure IGUIButton Extends IGUIElement
    EndStructure
    Structure IGUIEditBox Extends IGUIElement
    EndStructure
    Structure IGUIImage Extends IGUIElement
    EndStructure
    Structure IGUIComboBox Extends IGUIElement
    EndStructure
    Structure IGUIContextMenu Extends IGUIElement
    EndStructure
    Structure IGUIFileOpenDialog Extends IGUIElement
    EndStructure
    Structure IGUIInOutFader Extends IGUIElement
    EndStructure
    Structure IGUIListBox Extends IGUIElement
    EndStructure
    Structure IGUIWindow Extends IGUIElement
    EndStructure
    Structure IGUIScrollBar Extends IGUIElement
    EndStructure
    Structure IGUISpinBox Extends IGUIElement
    EndStructure
    Structure IGUITab Extends IGUIElement
    EndStructure
    Structure IGUITabControl Extends IGUIElement
    EndStructure
    Structure IGUIStaticText Extends IGUIElement
    EndStructure
    Structure IGUITable Extends IGUIElement
    EndStructure
    Structure IGUIToolBar Extends IGUIElement
    EndStructure
    Structure IGUIProgressBar Extends IGUIElement
    EndStructure

 
Structure IGUISkin
EndStructure

Structure CCustomGUISkin Extends IGUISkin
EndStructure

Structure IGUISpriteBank
EndStructure

; physic part
Structure IBodySceneNode
EndStructure

Structure IMaterialPair
EndStructure

Structure IPMaterial
EndStructure

Structure IJoint
EndStructure

; physic body
Structure IBody
	setting_force.l

	*collision.l            ;// specific collision newton pointeur
	*body.l                 ;// body newton pointer

	*body_entity.IMesh      ;// entity associate to this body
	*user_data.l

	force.iVECTOR3 
	force_continuos.iVECTOR3
	torque.iVECTOR3
	box_size.iVECTOR3

	collide_body_info.l[36]   ; private information
EndStructure

; IDE Options = PureBasic 4.30 Beta 5 (Windows - x86)
; CursorPosition = 133
; FirstLine = 104

CompilerEndIf 
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 3