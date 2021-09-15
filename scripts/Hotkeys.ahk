#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force     ; Force only a single instance running, so you don't get hotkey conflicts
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#NoTrayIcon

^!m::
Run "D:\MusicBee\MusicBee.exe"
return

#+n::
Run "D:\foobar2000\foobar2000.exe"
return

; ^SPACE::  Winset, Alwaysontop, , A

CoordMode, Mouse, Screen  ; Use absolute mouse coordinates

#n::
  WinGet, DesktopVar, ID, ahk_class WorkerW      ; Get the ID of the desktop window pane
  MouseGetPos, MouseX, MouseY, MouseVar, , 2     ; Get the mouse location and the ID of the window under the mouse
  If MouseVar = %DesktopVar%                     ; If you're currently moused over the desktop
  {                                              ;   This prevents the desktop from thinking you're click and dragging
    MouseMove 0, 0, 0                            ;   Instantly move the mouse to the upper left corner
  }                                              ; End If
  ControlClick , x0 y0, ahk_id %DesktopVar%, , R ; Right click the desktop
  ControlSend , , n, ahk_id %DesktopVar%         ; Send n to the desktop
  MouseMove %MouseX%, %MouseY%, 0                ; Instantly move the mouse to where it was
Return  

$Capslock::Esc
$Esc::Capslock

!Up::Send {Media_Play_Pause} ;Alt/Up Arrow to toggle mute
#Enter::
Run wt.exe