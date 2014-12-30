-- ~/.xmonad/xmonad.hs

-- Imports 

-- Core
import XMonad
import System.IO
import System.Exit
import XMonad.Operations
import Data.Ratio ((%))
import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)

-- Util 
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- Actions
import XMonad.Actions.CycleWS
 
-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
 
-- Layouts
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Tabbed
 
-- Constants
myTerminal = "urxvt"
-- modMask' :: KeyMask
myModMask = mod4Mask

-- Key mapping
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
      -- Prompt
      ((modMask, xK_p), runOrRaisePrompt largeXPConfig) 
      -- Terminal
    , ((modMask .|. shiftMask, xK_Return ), spawn $ XMonad.terminal conf)
    -- kill selected window
    , ((modMask .|. shiftMask, xK_c ), kill)
    -- Programs
    , ((modMask, xK_s  ), spawn "gnome-screenshot -i")
    , ((modMask, xK_F3 ), spawn "keepassx")
    , ((modMask, xK_f  ), spawn "firefox")
    -- Media Keys
    , ((0, 0x1008ff06 ), spawn "kbdlight down") 
    , ((0, 0x1008ff05 ), spawn "kbdlight up") 
    , ((0, 0x1008ff03 ), spawn "xbacklight -10") 
    , ((0, 0x1008ff02 ), spawn "xbacklight +10") 
    , ((0, 0x1008ff4b ), spawn "sxiv -t -f -r ~/Pictures") 
    , ((0, 0x1008ff12 ), spawn "amixer -q sset Master toggle")  
    , ((0, 0x1008ff11 ), spawn "amixer -q sset Master 5%-") 
    , ((0, 0x1008ff13 ), spawn "amixer -q sset Master 5%+")
    , ((0, 0x1008ff14 ), spawn "/home/alrix/bin/cplay")
    , ((0, 0x1008ff17 ), spawn "cmus-remote -n")
    , ((0, 0x1008ff16 ), spawn "cmus-remote -r")
    -- adjust layouts
    , ((modMask, xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_space    ), setLayout $ XMonad.layoutHook conf)  
    -- toggle struts
    , ((modMask, xK_b ), sendMessage ToggleStruts)
    , ((modMask, xK_n ), refresh)
    -- move focus to next window
    , ((modMask, xK_Tab ), windows W.focusDown) 
    , ((modMask, xK_k ), windows W.focusDown)
    , ((modMask, xK_j ), windows W.focusUp  )
    -- swap the focused window 
    , ((modMask .|. shiftMask, xK_j ), windows W.swapDown)   
    , ((modMask .|. shiftMask, xK_k ), windows W.swapUp)    
    , ((modMask, xK_Return   ), windows W.swapMaster)
    -- push window back into tiling
    , ((modMask, xK_t ), withFocused $ windows . W.sink)  
    -- resize the master area
    , ((modMask, xK_h ), sendMessage Shrink)     
    , ((modMask, xK_l ), sendMessage Expand)   
    , ((modMask, xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask, xK_period ), sendMessage (IncMasterN (-1)))
    -- workspaces
    , ((modMask, xK_Right ), nextWS)
    , ((mod1Mask, xK_Tab ), nextWS)
    , ((modMask .|. shiftMask, xK_Right ), shiftToNext)
    , ((modMask, xK_Left ), prevWS)
    , ((modMask .|. shiftMask, xK_Left ), shiftToPrev)
    -- lock, quit, or restart
    , ((modMask .|. shiftMask, xK_l ), spawn "xset dpms foce off && slock")
    , ((modMask .|. shiftMask, xK_q ), io (exitWith ExitSuccess))
    , ((modMask, xK_q ), spawn "killall conky dzen2 tint2 & xmonad --recompile && xmonad --restart")
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
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
-- Hooks

-- Define workspaces
myWorkspaces    = ["1","2","3","4","5","6"]

-- ManageHook 
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [ resource  =? r --> doIgnore  | r <- myIgnores ] 
    , [ className =? c --> doCenterFloat | c <- myFloats  ] 
    , [ name =? n --> doCenterFloat | n  <- myNames ] 
    , [ isFullscreen --> myDoFullFloat ]
    , [ isDialog --> doFloat ]
    ]) 
 
    where
        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"
 
        -- classnames
        myFloats  = ["Xmessage","XFontSel","Downloads","Nm-connection-editor","Gcalctool","Ekiga","Brasero","Save Screenshot","Firefox Preferences","tint2"]
 
        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer","docker","tint2","trayer"]
 
        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]
 
-- a trick for fullscreen but stil allow focusing of other WSs
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat

--Bar
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent = dzenColor "#ebac54" "#1B1D1E" . pad
      , ppVisible = dzenColor "white" "#1B1D1E" . pad
      , ppHidden = dzenColor "white" "#1B1D1E" . pad
      , ppHiddenNoWindows = dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent = dzenColor "#ff0000" "#1B1D1E" . pad
      , ppWsSep = ""
      , ppSep = " | "
      , ppLayout = dzenColor "#ebac54" "#1B1D1E" .
                   (\x -> case x of
                     "SmartSpacing 2 ResizableTall" -> "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                     "SmartSpacing 2 Mirror ResizableTall" -> "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                     "SmartSpacing 2 Full" -> "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                     "SmartSpacing 2 Grid" -> "+"
                     "SmartSpacing 2 Tabbed Simplest" -> "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                     _ -> x
                   )
      , ppTitle =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput =   hPutStrLn h
    }
 
-- Layout
myLayoutHook =  customLayout
myTabConfig = defaultTheme {  inactiveBorderColor = "#1B1D1E"
                            , activeBorderColor = "#1B1D1E"
                            , activeColor = "#1B1D1E"
                            , inactiveColor = "#1B1D1E"
                            , activeTextColor = "#FD971F"
                            , inactiveTextColor = "#7b7b7b"
                            , fontName = "xft:Droid Sans Mono:pixelsize=12:antialias=true:hinting=true"
                            , decoHeight = 24
                           } 

customLayout = avoidStruts $ smartSpacing 2 $ tiled ||| Mirror tiled ||| Grid ||| tabbed shrinkText myTabConfig 
  where
    tiled   = ResizableTall 1 (2/100) (1/2) []
 
-- Theme 
-- Color names are easier to remember:
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorSteelGrey      = "#7b7b7b"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"
barFont             = "terminus"
barXFont            = "inconsolata:size=12"
xftFont             = "xft: inconsolata-10"
 
-- Prompt Config
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = colorDarkGray
                    , fgColor               = colorOrange
                    , bgHLight              = colorOrange
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 0
                    , height                = 14
                    , historyFilter         = deleteConsecutive
                    }
 
-- Run or Raise Menu
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig
                { font = xftFont
                , height = 24
                }

-- Dzen/Conky
myXmonadBar = "dzen2 -geometry '+0+0' -h '24' -w '600' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E' -fn 'xft:DejaVu Sans Mono:pixelsize=12:antialias=true:hinting=true'"
myStatusBar = "conky -c /home/alrix/.xmonad/conky_dzen | dzen2 -geometry '+600+0' -w '670' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -fn 'xft:DejaVu Sans Mono:pixelsize=12:antialias=true:hinting=true'"
myBitmapsDir = "/home/alrix/.xmonad/dzen2"
mySysTray = "tint2 -c /home/alrix/.xmonad/tint2rc"

-- Main: Run the bars and pass config to xmonad 
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    dzenSysTray <- spawnPipe mySysTray
    xmonad $ ewmh defaultConfig
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = myKeys
      , modMask             = myModMask
      , layoutHook          = myLayoutHook
      , manageHook          = manageHook' 
      , handleEventHook    = fullscreenEventHook
      , logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0.8
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
      , borderWidth         = 0
      , focusFollowsMouse   = False
}
 
