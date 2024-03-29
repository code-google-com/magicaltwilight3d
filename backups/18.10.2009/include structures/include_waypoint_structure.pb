; ------------------------------------------------------------------------------------------------------------------------------
; -- Konstants
; ------------------------------------------------------------------------------------------------------------------------------

   #way_max_connections  = 11 ; die maximalen Verbindungen eines waypoints... wobei = 0-10, hier.       
   
   Enumeration                ; zum Ausgeben von F,G oder H-wert. eines Waypoints
      #Way_Weg_wertart_F
      #Way_Weg_wertart_G
      #Way_Weg_wertart_H
   EndEnumeration 
   
; ------------------------------------------------------------------------------------------------------------------------------
; -- structures
; ------------------------------------------------------------------------------------------------------------------------------

   Structure WAYPOINT
      ; f�r Wegfindung: 
      Gwert.f					    ; Geh wert
      Fwert.f				     	 ; g+h wert
      Hwert.f				       ; Distance-knoten-ziel
      parent.i                 ; Pointer zu parent-waypoint.
      liste.b                  ; ob gesch, open oder keine liste.
      
      ; f�r Allgemeines:
      Object3dID.i             ; Verlinkung zu Object3d.  da sind auch jetzt xyz-koords.
      anzahl_connections.i     ; Anzahl der Verbindungen (f�r das Array da drunter)
      connection.i [#way_max_connections] ; also von 0 - 10.. anzahl der Verbindungen.
   EndStructure
   

; ------------------------------------------------------------------------------------------------------------------------------
; -- variables
; ------------------------------------------------------------------------------------------------------------------------------

   Global NewList waypoint.WAYPOINT()
 
; jaPBe Version=3.8.8.716
; Build=0
; FirstLine=0
; CursorPosition=0
; ExecutableFormat=Windows
; DontSaveDeclare
; EOF