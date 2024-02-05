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
import XMonad.Util.WorkspaceCompare
import XMonad.Actions.DynamicWorkspaces
import Data.Maybe ( isNothing, isJust )
-- import XMonad.Config.Desktop

-- baseConfig = desktopConfig

main = xmonad =<< statusBar moBar printer toggleStrutsKey myConfig

moBar = "xmobar"
printer = xmobarPP {
  ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"
  , ppOrder = \(ws:_) -> [ws]
  }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myWorkspaces = ["Emacs", "Terminal", "WebBrowser", "Messages", "Hidden"]

myConfig = (ewmh . ewmhFullscreen $ def) {
  terminal = "urxvt"
  , borderWidth = 3
  , startupHook = myStartupHook
  , manageHook = myManageHook
  , layoutHook =  myLayoutHook
  , workspaces = myWorkspaces
  } `additionalKeys`
  [ ((mod1Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
  -- , ((mod1Mask, xK_space), sendMessage $ Toggle FULL)
  , ((mod1Mask, xK_bracketleft), prevNonEmptyWS)
  , ((mod1Mask, xK_bracketright), nextNonEmptyWS)
  , ((mod1Mask, xK_Right), nextScreen)
  , ((mod1Mask, xK_Left), prevScreen)
  , ((mod1Mask, xK_Tab), nextScreen)
  , ((mod1Mask, xK_i), toggleWS' ["Hidden"])
  , ((mod1Mask .|. shiftMask, xK_Tab), prevScreen)
  , ((mod1Mask .|. shiftMask, xK_c), kill)
  , ((0, xK_Insert), pasteSelection)
  , ((mod1Mask, xK_p), spawn "dmenu_run -l 10 -fn 'HackGen:size=14'")
  ]

myStartupHook = do
  spawnOnce "feh ~/Downloads/Xmbindings.png"


myManageHook = composeAll
  [ className =? "Emacs" --> doShift "Emacs"
  , className =? "URxvt" --> doShift "Terminal"
  , className =? "feh" --> doShift "Terminal"
  , className =? "Google-chrome" --> doShift "WebBrowser"
  , className =? "Electron" --> doShift "WebBrowser"
  , className =? "MPlayer"        --> doShift "Hidden"
  , className =? "mplayer2"       --> doShift "Hidden"
  , className =? "Wine" --> doShift "Hidden"
  , className =? "Genymotion" --> doShift "Hidden"
  , className =? "Genymotion Player" --> doShift "Hidden"
  , className =? "Slack" --> doShift "Messages"
  ]


myLayoutHook =  tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100


visibleWs :: X (WindowSpace -> Bool)
visibleWs = do
  hs <- gets (map W.tag . W.hidden . windowset)
  return (\w -> (not ((W.tag w) `elem` hs)))

visibleNonEmptyWs :: X (WindowSpace -> Bool)
visibleNonEmptyWs = do ne <- isNonEmptyWs
                       vi <- visibleWs
                       return (\w -> ne w && vi w)

  where isNonEmptyWs = return (isJust . W.stack)


nonEmptyWsBy :: Int -> X (WorkspaceId)
nonEmptyWsBy = findWorkspace getSortByIndex Next (Not emptyWS)

switchNonEmptyWorkspace :: Int ->  X ()
switchNonEmptyWorkspace d = do
  id <- nonEmptyWsBy d
  if id == "Hidden"
  then if d < 0
       then switchNonEmptyWorkspace (d - 1)
       else switchNonEmptyWorkspace (d + 1)
  else (windows . W.greedyView) id

nextNonEmptyWS :: X ()
nextNonEmptyWS = switchNonEmptyWorkspace 1

prevNonEmptyWS :: X ()
prevNonEmptyWS = switchNonEmptyWorkspace (-1)
