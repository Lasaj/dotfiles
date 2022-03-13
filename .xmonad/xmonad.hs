import System.IO
import System.Exit

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Config.Azerty
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.SpawnOn
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens


import XMonad.Layout.CenteredMaster(centerMaster)

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad ( liftM2, forM_, join, liftM, when, (>=>) )
import qualified DBus as D
import qualified DBus.Client as D
import Data.Maybe (maybeToList, fromJust)
import XMonad.Util.SpawnOnce

myTerm = "alacritty"
myBrowser = "firefox"
myFileMan = "nautilus"

colours = [
    "#3C3836",  -- color 0 gruvbox bg1
    "#3C3836",  -- color 1 gruvbox bg1
    "#c0c5ce",  -- color 2
    "#fba922",  -- color 3
    "#3384d0",  -- color 4
    "#FBF1C7",  -- color 5 gruvbox fg0
    "#cd1f3f",  -- color 6
    "#458588",  -- color 7 gruvbox blue
    "#d65d0e",  -- color 8 gruvbox orange
    "#A89984",  -- color 9 gruvbox fg4
    "#2b5355",  -- color 10 gruvbox dark blue
    "#783508",  -- color 11 gruvbox dark orange
    "#fabd2f",  -- color 12 gruvbox yellow
    "#d3869b"  -- color 13 gruvbox purple
    ]

myStartupHook = do
    spawn "killall trayer &"
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    setWMName "LG3D"

-- colours
normBord = "#4c566a"
focdBord = "#5e81ac"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 2
-- myWorkspaces    = ["\61612","\61899","\61947","\61635","\61502","\61501","\61705","\61564","\62150","\61872"]
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]
myWorkspaces    = ["LTOP", "DESK", "CHAT", "CODE", "MAIL", "RMTE", "MSIC", "JUNK", "HIDE", "VOLM"]
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    , [isFullscreen --> doFullFloat]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    ]
    where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["Arandr", "Arcolinux-calamares-tool.py", "Arcolinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "feh", "mpv", "Xfce4-terminal", "arcolinux-logout"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = []
    myIgnores = ["desktop_window"]


myLayout = spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| full
    where
        tiled = avoidStruts $ smartBorders $ Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2
        full = noBorders $ fullscreenFull Full


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)

    ]


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS

  [ ((modMask, xK_b), spawn myBrowser )
  , ((modMask, xK_c), spawn "code" )
  , ((modMask, xK_d), spawn "rofi -show drun" )
  , ((modMask, xK_e ), spawn myFileMan)
  , ((modMask, xK_f), sendMessage $ Toggle NBFULL)
  , ((modMask, xK_p ), spawn "pycharm")
  , ((modMask, xK_q), kill )
  , ((modMask, xK_r), spawn "rofi-theme-selector" )
  , ((modMask, xK_t), spawn myTerm)
  , ((modMask, xK_v), spawn "pavucontrol" )
  , ((modMask, xK_y), spawn "polybar-msg cmd toggle" )
  , ((modMask, xK_x), spawn "arcolinux-logout" )
  , ((modMask, xK_z), spawn "zoom" )
  , ((modMask, xK_Escape), spawn "xkill" )
  , ((modMask, xK_Return), spawn myTerm)
  , ((modMask, xK_F6), spawn "vlc --video-on-top" )
  , ((modMask, xK_F7), spawn "virtualbox" )
  , ((modMask, xK_F8), spawn myFileMan )
  , ((modMask, xK_F9), spawn "evolution" )
  , ((modMask, xK_F11), spawn "rofi -show drun -fullscreen" )
  , ((modMask, xK_F12), spawn "rofi -show drun" )

  -- FUNCTION KEYS
  , ((0, xK_F12), spawn "xfce4-terminal --drop-down" )

  -- SUPER + SHIFT KEYS

  , ((modMask .|. shiftMask , xK_Return ), spawn myFileMan)
  , ((modMask .|. shiftMask , xK_d ), spawn "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")
  , ((modMask .|. shiftMask , xK_r ), spawn "xmonad --recompile && xmonad --restart")
  , ((modMask .|. shiftMask , xK_q ), kill)
  , ((modMask .|. shiftMask , xK_s ), spawn "~/.xmonad/scripts/toggle_suspend.sh")
  , ((modMask .|. shiftMask , xK_m ), spawn "~/.xmonad/scripts/desktop.sh && xmonad --restart")
  , ((modMask .|. shiftMask , xK_n ), spawn "~/.xmonad/scripts/laptop.sh && xmonad --restart")
  -- , ((modMask .|. shiftMask , xK_x ), io (exitWith ExitSuccess))

  -- SUPER + CONTROL KEYS

  , ((modMask .|. controlMask , xK_s ), spawn "~/.xmonad/scripts/suspend.sh")


  -- CONTROL + ALT KEYS

  , ((controlMask .|. mod1Mask , xK_Next ), spawn "conky-rotate -n")
  , ((controlMask .|. mod1Mask , xK_Prior ), spawn "conky-rotate -p")
  , ((controlMask .|. mod1Mask , xK_a ), spawn "xfce4-appfinder")
  , ((controlMask .|. mod1Mask , xK_b ), spawn myFileMan)
  , ((controlMask .|. mod1Mask , xK_c ), spawn "catfish")
  , ((controlMask .|. mod1Mask , xK_e ), spawn "arcolinux-tweak-tool")
  , ((controlMask .|. mod1Mask , xK_f ), spawn myBrowser)
  , ((controlMask .|. mod1Mask , xK_g ), spawn "chromium -no-default-browser-check")
  , ((controlMask .|. mod1Mask , xK_i ), spawn "nitrogen")
  , ((controlMask .|. mod1Mask , xK_k ), spawn "arcolinux-logout")
  , ((controlMask .|. mod1Mask , xK_l ), spawn "arcolinux-logout")
  , ((controlMask .|. mod1Mask , xK_m ), spawn "xfce4-settings-manager")
  , ((controlMask .|. mod1Mask , xK_o ), spawn "$HOME/.xmonad/scripts/picom-toggle.sh")
  , ((controlMask .|. mod1Mask , xK_p ), spawn "pamac-manager")
  , ((controlMask .|. mod1Mask , xK_r ), spawn "rofi-theme-selector")
  , ((controlMask .|. mod1Mask , xK_s ), spawn "spotify")
  , ((controlMask .|. mod1Mask , xK_t ), spawn "urxvt")
  , ((controlMask .|. mod1Mask , xK_u ), spawn "pavucontrol")
  , ((controlMask .|. mod1Mask , xK_v ), spawn "vivaldi-stable")
  , ((controlMask .|. mod1Mask , xK_w ), spawn "arcolinux-welcome-app")
  , ((controlMask .|. mod1Mask , xK_Return ), spawn "urxvt")

  -- ALT + ... KEYS

  , ((mod1Mask, xK_f), spawn "variety -f" )
  , ((mod1Mask, xK_n), spawn "variety -n" )
  , ((mod1Mask, xK_p), spawn "variety -p" )
  , ((mod1Mask, xK_r), spawn "xmonad --restart" )
  , ((mod1Mask, xK_t), spawn "variety -t" )
  , ((mod1Mask, xK_Up), spawn "variety --pause" )
  , ((mod1Mask, xK_Down), spawn "variety --resume" )
  , ((mod1Mask, xK_Left), spawn "variety -p" )
  , ((mod1Mask, xK_Right), spawn "variety -n" )
  , ((mod1Mask, xK_F2), spawn "xfce4-appfinder --collapsed" )
  , ((mod1Mask, xK_F3), spawn "xfce4-appfinder" )

  --VARIETY KEYS WITH PYWAL

  , ((mod1Mask .|. shiftMask , xK_f ), spawn "variety -f && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_n ), spawn "variety -n && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_p ), spawn "variety -p && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_t ), spawn "variety -t && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")
  , ((mod1Mask .|. shiftMask , xK_u ), spawn "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&")

  --CONTROL + SHIFT KEYS

  , ((controlMask .|. shiftMask , xK_Escape ), spawn "xfce4-taskmanager")

  --SCREENSHOTS

  , ((0, xK_Print), spawn "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")
  , ((controlMask, xK_Print), spawn "xfce4-screenshooter" )
  , ((controlMask .|. shiftMask , xK_Print ), spawn "gnome-screenshot -i")
  , ((modMask .|. shiftMask , xK_p ), spawn "gnome-screenshot -i")


  --MULTIMEDIA KEYS

  -- Mute volume
  , ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")

  -- Decrease volume
  , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")

  -- Increase volume
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")

  -- Increase brightness
  , ((0, xF86XK_MonBrightnessUp),  spawn "light -A 5")

  -- Decrease brightness
  , ((0, xF86XK_MonBrightnessDown), spawn "light -U 5")

--  , ((0, xF86XK_AudioPlay), spawn $ "mpc toggle")
--  , ((0, xF86XK_AudioNext), spawn $ "mpc next")
--  , ((0, xF86XK_AudioPrev), spawn $ "mpc prev")
--  , ((0, xF86XK_AudioStop), spawn $ "mpc stop")

  , ((0, xF86XK_AudioPlay), spawn "playerctl play-pause")
  , ((0, xF86XK_AudioNext), spawn "playerctl next")
  , ((0, xF86XK_AudioPrev), spawn "playerctl previous")
  , ((0, xF86XK_AudioStop), spawn "playerctl stop")


  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  --Focus selected desktop
  , ((mod1Mask, xK_Tab), nextWS)

  --Focus selected desktop
  , ((modMask, xK_Tab), nextWS)

  --Focus selected desktop
  , ((controlMask .|. mod1Mask , xK_Left ), prevWS)

  --Focus selected desktop
  , ((controlMask .|. mod1Mask , xK_Right ), nextWS)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k), windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_h), windows W.focusMaster  )

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )

  -- Swap the focused window with the next window.
  , ((controlMask .|. modMask, xK_Down), windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )

  -- Swap the focused window with the previous window.
  , ((controlMask .|. modMask, xK_Up), windows W.swapUp  )

  -- Shrink the master area.
  , ((modMask .|. shiftMask , xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((modMask .|. shiftMask , xK_l), sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask .|. shiftMask , xK_space), withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N and shift focus
  -- mod-control-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (W.shift, controlMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

  ++
  -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_comma, xK_period] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- join . maybeToList <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]


main :: IO ()
main = do

    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc"
    xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc"
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


    xmonad . ewmh $ myBaseConfig
        { startupHook = myStartupHook >> addEWMHFullscreen
        , layoutHook = gaps [(U,35), (D,5), (R,5), (L,5)] $ myLayout ||| layoutHook myBaseConfig
        , manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
        , modMask = myModMask
        , borderWidth = myBorderWidth
        , handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook
        , focusFollowsMouse = myFocusFollowsMouse
        , workspaces = myWorkspaces
        , focusedBorderColor = focdBord
        , normalBorderColor = normBord
        , keys = myKeys
        , mouseBindings = myMouseBindings
        , logHook = dynamicLogWithPP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
                              >> hPutStrLn xmproc1 x                          -- xmobar on monitor 2
              , ppCurrent = xmobarColor (colours!!5) "" . wrap "<box type=VBoth width=2 mb=2 color=#d65d0e>" "</box>"         -- Current workspace
              , ppVisible = xmobarColor (colours!!5) "" . wrap "<box type=VBoth width=2 mb=2 color=#458588>" "</box>" . clickable              -- Visible but not current workspace
              , ppVisibleNoWindows = Just $ xmobarColor (colours!!9) "" . wrap "<box type=VBoth width=2 mb=2 color=#458588>" "</box>" . clickable              -- Visible but not current workspace
              , ppHidden = xmobarColor (colours!!5) "" . clickable -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor (colours!!9) ""  . clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor (colours!!5) "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }

}
