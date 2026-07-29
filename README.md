# macOS Stuck Window / "Always On Top" Workaround

> **Note**
> This is a workaround for a long-standing macOS WindowServer bug that Apple still hasn't fixed.

> Sorry for the AI picture and the AI description. 


<div align="center"> <img width="768" height="512" alt="ChatGPT Image 29 июл  2026 г , 02_29_34" src="https://github.com/user-attachments/assets/91a1635b-f269-468e-b4a0-4b45d123929a" /> </div>


## The Problem

If you assign applications to **Dock → Options → Assign To → All Desktops**, or you frequently connect and disconnect external monitors, you've probably encountered this issue:

A window becomes permanently **"Always on Top"**, floating above every other application, refusing to go behind other windows even when it isn't focused.

This bug has existed across multiple macOS releases (including **Sonoma** and **Sequoia**). The only reliable workaround is manually forcing WindowServer to rebuild the window hierarchy.

---

## Script

```bash
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
```
---

## How This Script Works

Instead of manually changing desktop assignments every time the bug appears, this script automates the workaround.

It performs two actions:

1. Restarts **Finder**.
2. Cycles selected applications into **Full Screen** mode and back.

Entering and exiting Full Screen forces **WindowServer** to completely recalculate window geometry and z-order, which usually removes the stuck "Always on Top" state.

---

# Setup

## 1. Customize the application list

Edit the following line in the script and replace it with applications that are assigned to all desktops and sometimes become stuck.

```applescript
set targetApps to {"Calendar", "Telegram", "YourAppNameHere"}
```

The names must exactly match the application names shown by macOS.

---

## 2. Add the script to Shortcuts

To launch the fix with a single click:

1. Open **Shortcuts**.
2. Create a **New Shortcut**.
3. Search for **Run Shell Script**.
4. Drag it into the workflow.
5. Paste the script above.
6. Name it something like **Fix Stuck Windows**.
7. (Optional) Pin it to Dock.

Whenever the bug appears, simply run the shortcut.

---

# Permissions

The first time you run the script, macOS will request **Accessibility** permission.

Enable it here:

**System Settings → Privacy & Security → Accessibility**

Allow whichever application runs the script (Terminal or Shortcuts).

---

# Tested On

- macOS Sequoia 15.7.7

---

# Search Keywords

If you found this repository through search, these are common phrases associated with this issue:

- macOS window always on top bug
- macOS stuck window above all apps
- WindowServer always on top issue
- Assign to All Desktops bug
- macOS Sonoma window stuck
- macOS Sequoia WindowServer bug
- macOS external monitor window bug
- ghost window after display disconnect
- window stays above everything macOS
- Mission Control window layering bug
```
