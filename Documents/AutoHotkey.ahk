#SingleInstance force


; Bring Firefox to the front
#a::
  WinActivate, ahk_class MozillaWindowClass
  return

; Run Windows terminal
^!t::
  Run "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.10.2383.0_x64__8wekyb3d8bbwe\wt.exe"
  return

^!+o::
  Send, https://calendly.com/omgpat
  return