#!/bin/bash

killall Finder

osascript -e '
set targetApps to {"Finder", "Calendar", "Telegram"}

tell application "System Events"
    repeat with appName in targetApps
        if exists (process appName) then
            try
                tell process appName
                    set frontmost to true
                    delay 0.2
                    
                    set theWindow to front window
                    if (exists attribute "AXFullScreen" of theWindow) then
                        set value of attribute "AXFullScreen" of theWindow to true
                        delay 0.7 
                        
                        set value of attribute "AXFullScreen" of theWindow to false
                        delay 0.7
                    end if
                end tell
            end try
        end if
    end repeat
end tell'
