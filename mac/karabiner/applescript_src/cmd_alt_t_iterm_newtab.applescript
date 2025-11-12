(* iTerm2 の新規タブを通常ウィンドウで開く *)
 tell application "iTerm" to launch
   repeat 20 times
   if application "iTerm" is running then exit repeat
     delay 0.2
   end repeat
 if application "iTerm" is running then
   tell application "iTerm"
     set normalWindow to missing value
     try
       set normalWindow to (first window whose is hotkey window is false)
       on error
     end try
     activate
     if normalWindow is not missing value then
       tell normalWindow
         select
         create tab with default profile
       end tell
     else
       create window with default profile
     end if
   end tell
 end if
