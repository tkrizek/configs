import XMonad

import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)

import XMonad.Operations
 
import System.IO
import System.Exit
 
import XMonad.Util.Run

import Graphics.X11.ExtraTypes.XF86
 
import XMonad.Actions.CycleWS

import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.NamedWindows

import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid
 
import Data.Ratio ((%))
 
import qualified XMonad.StackSet as W
import qualified Data.Map as M

--- Workspace labels
myWorkspaces = ["1:dev", "2:dev", "3:dev", "4:web", "5:notes", "6:chat", "7:mail", "8:music", "9:etc"]

--- Use Win key instead of Alt key as modifier
modMask' :: KeyMask
modMask' = mod4Mask

-- Theme
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
 
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"
 
-- Font 
barFont  = "terminus"
barXFont = "inconsolata:size=12"
xftFont = "xft: inconsolata-14"

-- Prompt Config
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = colorDarkGray
                    , fgColor               = colorGreen
                    , bgHLight              = colorGreen
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 0
                    , height                = 14
                    , historyFilter         = deleteConsecutive
                    }
 
-- Run or Raise Menu
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig
                { font = xftFont
                , height = 22
                }

--- Define custom key bindings
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,                    xK_r        ), runOrRaisePrompt largeXPConfig)
    , ((modMask,                    xK_t        ), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask,      xK_k        ), kill)
    , ((modMask,                    xK_l        ), spawn "slock")
    , ((modMask .|. shiftMask,      xK_l        ), spawn "systemctl suspend && slock")
    -- Programs
    , ((controlMask,                xK_Print    ), spawn "sleep 0.2; scrot -s -e 'mv $f ~/screenshots/'")
    , ((0,                          xK_Print    ), spawn "scrot -e 'mv $f ~/screenshots/'")
    , ((modMask,                    xK_e        ), spawn "xterm -e '/usr/bin/emacs -nw'")
    , ((modMask,                    xK_i        ), spawn "xterm -e '/usr/bin/irssi'")
    , ((modMask,		    xK_f        ), spawn "firefox")
    -- Media Keys
    , ((0,                          0x1008ff12  ), spawn "amixer -q sset Master toggle")        -- XF86AudioMute
    , ((0,                          0x1008ff11  ), spawn "amixer -q sset Master 10%-")   -- XF86AudioLowerVolume
    , ((0,                          0x1008ff13  ), spawn "amixer -q sset Master 10%+")   -- XF86AudioRaiseVolume
    --, ((0,                          0x1008ff14  ), spawn "rhythmbox-client --play-pause")
    --, ((0,                          0x1008ff17  ), spawn "rhythmbox-client --next")
    --, ((0,                          0x1008ff16  ), spawn "rhythmbox-client --previous")
    -- brightness
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight +20")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -20")
    
    -- layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask,                    xK_0        ), refresh)
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                         -- move focus to next window
    , ((modMask,                    xK_n        ), windows W.focusDown)
    , ((modMask,                    xK_p        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_n        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_p        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_d        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_s        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_x        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))
 
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn "killall conky dzen2 && xmonad --recompile && xmonad --restart")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F1, xK_F2, xK_F3] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

--- Custom log hook for dzen statusbar
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
      , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "#00ffff" "#1B1D1E" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

--- Custom dzen and conky status bar
myXmonadBar = "dzen2 -x '0' -y '0' -h '24' -w '960' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c /home/tkrizek/.xmonad/.conkyrc | dzen2 -x '960' -w '960' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"


main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad
      --- urgency hook for notifications
      $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "black", "-fg", "#00ffff", "-xs", "1"], duration = 2500000 }
      $ defaultConfig
          { workspaces          = myWorkspaces
          , keys                = keys'
          , modMask             = modMask'
          --- avoid struts to not occupy status bar space
          , layoutHook          = avoidStruts $ layoutHook defaultConfig
          --- open new windows below and make them active
          , manageHook          = insertPosition Below Newer <+> manageDocks <+> manageHook defaultConfig
          --- dockEventHook to ignore status bar
          , handleEventHook     = docksEventHook <+> handleEventHook defaultConfig
          , logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
          , borderWidth         = 2
}
