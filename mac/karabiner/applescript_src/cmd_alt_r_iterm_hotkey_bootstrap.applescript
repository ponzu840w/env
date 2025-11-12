(* iTerm2 のホットキーがiTerm2未起動でも動作するようにする *)
tell application "iTerm" to launch
repeat 20 times
  if application "iTerm" is running then exit repeat
  delay 0.2
end repeat
if application "iTerm" is running then
  tell application "System Events" to tell process "iTerm" to keystroke "r" using {command down, option down}
end if
