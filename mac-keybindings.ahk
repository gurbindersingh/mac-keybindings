﻿; ##############################################################################
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

  IsMinimized := -1
  IsMaximized := 1
  WindowState := WinGetMinMax(WinTitle)

  if(WindowState == IsMaximized) {
    WinRestore WinTitle
  } else {
    WinGetPos &PosX, &PosY, &Width, &Height, WinTitle
    OriginalSize[WinActive(WinTitle)] := [PosX, PosY, Width, Height]
  }

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
; There is no way to disable Win+L, so instead it's just RCtrl+L for @
>^l::@

#n::Send "~"
#5::Send "["
#6::Send "]"
#7::Send "|"

>^n::Send "~"
>^5::Send "["
>^6::Send "]"
>^7::Send "|"
; For the following two use Powertoys to remap the keys
; #8::Send "{"
; #9::Send "}" 
<^>!7::Return
<^>!0::Return
<^>!8::Return
<^>!9::Return

; =============================================================================
; Shortcut remappings
; =============================================================================
; Hotkey using Alt
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

#BackSpace::^BackSpace

#+Up::!+Up
#+Down::!+Down
#+Left::^+Left
#+Right::^+Right

#Up::!Up
#Down::!Down

; ^a::Return
^Left::Return
^Right::Return
#Left::^Left
#Right::^Right

; Conditional hotkeys
#HotIf !WindowSwitching
; Only allow these when not window switching, otherwise navigation in the 
; Alt+Tab menu using arrow keys does not work.
!Up::Return
!Down::Return
!Left::Home
!Right::End
<^>!Left::Home
<^>!Right::End
#HotIf

#HotIf WinActive("Firefox")
!l::^l
<^>!l::^l
#!i::^+i
#HotIf

; =============================================================================
; Window Management
; =============================================================================
; Alt+q to close the active window
!+w::WinClose "A"

; <^>!q::WinClose "A"
<^>!q::Return ;disable AltGr+Q for quitting to prevent accidents

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
; The following two keys are used to detect when we are using Alt+Tab. The 
; Tilde operator allows the keys to perform its normal function.
~!Tab::{
  global WindowSwitching
  WindowSwitching := True
}
~Alt Up::{
  global WindowSwitching
  WindowSwitching := False
}
