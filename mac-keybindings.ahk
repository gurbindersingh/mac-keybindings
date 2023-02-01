; ##############################################################################
; ########################### Mac style key bindings ###########################
; ##############################################################################

; =============================================================================
; Global variables
; =============================================================================
WindowSwitching := False
OriginalSize := Map()

; =============================================================================
; Functions
; =============================================================================
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

  OffsetY := -15 ; The height of the task bar is 30 px 
  OffsetX := 0

  WinMove (A_ScreenWidth/2)-(Width/2)+OffsetX, (A_ScreenHeight/2)-(Height/2)+OffsetY,,, WinTitle
}

AlmostMaximize(WinTitle) {
  global OriginalSize

  WinGetPos &PosX, &PosY, &Width, &Height, WinTitle
  OriginalSize[WinActive(WinTitle)] := [PosX, PosY, Width, Height]

  Width := A_ScreenWidth * 0.9
  Height := A_ScreenHeight * 0.9
  OffsetY := -15 ; The height of the task bar is 30 px 
  OffsetX := 0

  WinMove (A_ScreenWidth/2)-(Width/2)+OffsetX, (A_ScreenHeight/2)-(Height/2)+OffsetY, Width, Height, WinTitle
}

; NOTE: Always write the hotkeys at the end. Otherwise, global variables will not be 
; initialized. For details see: https://www.autohotkey.com/docs/v1/Scripts.htm#auto.

; =============================================================================
; Characters remappings
; =============================================================================
; There is no way to disable Win+L, so instead it's just Alt/AltGr+L for @
; !l::@ ; this conflicts with the Reformat Code command in VS Code
>^l::@

#n::Send "~"
#5::Send "["
#6::Send "]"
#7::Send "|"
; For the following two use Powertoys to remap the keys
; #8::Send "{"
; #9::Send "}" 

; =============================================================================
; Basic shortcuts like copy, paste, cut, etc
; =============================================================================
!a::^a
!c::^c
!f::^f
!n::^n
!p::^p
!r::^r
!s::^s
!t::^t
!v::^v
!w::^w
!x::^x
!z::^z
!+p::^+p
!Enter::^Enter
; Hotkeys using AltGr
<^>!a::^a
<^>!c::^c
<^>!f::^f
<^>!n::^n
<^>!p::^p
<^>!r::^r
<^>!s::^s
<^>!t::^t
<^>!v::^v
<^>!w::^w
<^>!x::^x
<^>!z::^z
<^>!Enter::^Enter

; No second hotkey necessary, RCtrl+Backspace already does what it's supposed to
#BackSpace::^BackSpace
#+Left::^+Left
#+Right::^+Right
#+Up::^+Up
#+Down::^+Down
#Up::Return
#Down::Return

; Conditional hotkeys
#HotIf !WindowSwitching
; Only allow these when not window switching, otherwise navigation in the 
; Alt+Tab menu using arrow keys does not work.
!Left::Home
!Right::End
<^>!Left::Home
<^>!Right::End
#HotIf

#HotIf WinActive("Firefox")
!l::^l
<^>!l::^l
#HotIf

; =============================================================================
; Window Management
; =============================================================================
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

; =============================================================================
; Detect keys to override certain hotkeys
; =============================================================================
; The following two keys are used to detect when we are using Alt+Tab
~!Tab::{
  global WindowSwitching
  WindowSwitching := True
}
~Alt Up::{
  global WindowSwitching
  WindowSwitching := False
}
