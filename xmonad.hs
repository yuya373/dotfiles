import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.ManageHook
import Control.Monad(liftM2)
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W
import XMonad.Actions.CycleRecentWS
import XMonad.Util.Paste
-- import XMonad.Config.Desktop

-- baseConfig = desktopConfig

main = xmonad =<< statusBar moBar printer toggleStrutsKey myConfig

moBar = "xmobar"
printer = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"}
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myConfig = (ewmh $ defaultConfig) {
  terminal = "urxvt"
  , borderWidth = 3
  , startupHook = myStartupHook
  , manageHook = myManageHook
  , handleEventHook = myEventHook
  , layoutHook =  myLayoutHook
  } `additionalKeys`
  [ ((mod1Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
  -- , ((mod1Mask, xK_space), sendMessage $ Toggle FULL)
  , ((mod1Mask, xK_bracketleft), prevWS)
  , ((mod1Mask, xK_bracketright), nextWS)
  , ((mod1Mask, xK_Right), nextScreen)
  , ((mod1Mask, xK_Left), prevScreen)
  , ((mod1Mask .|. shiftMask, xK_c), kill)
  , ((0, xK_Insert), pasteSelection)
  ]

myStartupHook = do
  spawn "feh ~/Downloads/Xmbindings.png"
  spawnOnce "xremap ~/dotfiles/.xremap"

myManageHook = composeAll
  [ className =? "Emacs" --> doShift "1"
  , className =? "Google-chrome" --> doShift "1"
  , className =? "URxvt" --> doShift "2"
  , className =? "feh" --> doShift "2"
  ]

myEventHook = ewmhDesktopsEventHook <+> fullscreenEventHook

myLayoutHook =  tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

