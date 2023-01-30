;==============================================================================
; Mac style key bindings
;==============================================================================

OriginalSize := Map()

RestoreWindow(WinTitle){
  KeyOfWindow := WinExist(WinTitle)
  
  if(OriginalSize.Count > 0 && OriginalSize.Has(KeyOfWindow)) {
    ; Manually restore the window size
    PosSize := OriginalSize.Delete(WinActive(WinTitle))
    WinMove PosSize[1], PosSize[2], PosSize[3], PosSize[4], WinTitle
  } else {
    WinRestore WinTitle
  }
}

CenterWindow(WinTitle) {
  global OriginalSize
  
  WinGetPos &PosX, &PosY, &Width, &Height, WinTitle
  OriginalSize[WinActive(WinTitle)] := [PosX, PosY, Width, Height]
  
  OffsetY := -15  ; The height of the task bar is 30 px 
  OffsetX := 0
  
  WinMove (A_ScreenWidth/2)-(Width/2)+OffsetX, (A_ScreenHeight/2)-(Height/2)+OffsetY,,, WinTitle
}

AlmostMaximize(WinTitle) {
  global OriginalSize

  WinGetPos &PosX, &PosY, &Width, &Height, WinTitle
  OriginalSize[WinActive(WinTitle)] := [PosX, PosY, Width, Height]

  Width := A_ScreenWidth * 0.9
  Height := A_ScreenHeight * 0.9
  OffsetY := -15  ; The height of the task bar is 30 px 
  OffsetX := 0
  
  WinMove (A_ScreenWidth/2)-(Width/2)+OffsetX, (A_ScreenHeight/2)-(Height/2)+OffsetY, Width, Height, WinTitle
}


; NOTE: Always write the hotkeys at the end. Otherwise, global variables will not be initialized. For details see: https://www.autohotkey.com/docs/v1/Scripts.htm#auto.

; Characters remappings
; There is no way to disable Win+L, so instead it's just Alt/AltGr+L for @
; !l::@ ; this conflicts with the Reformat Code command in VS Code
<^>!l::@

#n::Send "~"
#5::Send "["
#6::Send "]"
#7::Send "|"
; For the following two use Powertoys to remap the keys
; #8::Send "{"
; #9::Send "}" 


; Map most commonly used shortcuts like copy, paste, cut, from Ctrl+KEY to Alt/AltGr+KEY
!a::^a
!c::^c
!s::^s
!t::^t
!v::^v
!w::^w
!x::^x
!z::^z
<^>!c::^c
<^>!v::^v
<^>!x::^x
<^>!s::^s
<^>!z::^z



; Alt+q to close the active window
!q::WinClose "A"
<^>!q::WinClose "A"
; Alt+M/H to minimize the active window
!m:: WinMinimize "A"
!h:: WinMinimize "A"
; Ctrl+Alt+F to toggle full screen
^!f::F11


; Rectanlge keybindings
^#Enter::WinMaximize "A"
^#Backspace::RestoreWindow("A")
^#c::CenterWindow("A")
^#b::AlmostMaximize("A")
