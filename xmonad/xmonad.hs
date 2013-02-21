import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W


main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc --screen=1"
	xmonad $ defaultConfig
		{
			modMask = mod1Mask,
			manageHook = manageDocks <+> myManageHooks
				<+> manageHook defaultConfig,
			layoutHook = avoidStruts $ layoutHook defaultConfig,
			{-startupHook = startup,-}
			logHook = dynamicLogWithPP $ xmobarPP
				{
					ppOutput = hPutStrLn xmproc,
					ppTitle = xmobarColor "green" "" . shorten 100
				},
				focusFollowsMouse = False,
				workspaces = myWorkspaces
		} `additionalKeys` myKeys

myManageHooks = composeAll . concat $
	[
		[ isFullscreen --> doFullFloat],
		[ className =? c --> doFloat | c <- classFloats],
		[ title =? t --> doFloat | t <- titleFloats],
		[ className =? c --> doF (W.shift "9") | c <- musicPlayers],
		[ className =? c --> doIgnore | c <- classIgnores]
	]
	where
		classFloats = ["Gimp","Vncviewer","Webots-bin","UTNaoTool","Tk"]
		titleFloats = ["Pursuit Simulation","Gesture Trainer", "Gesture Tester", "Teleop", "Figure 1", "Config Editor"]
		musicPlayers = ["Songbird","Guayadeque","Pithos"]
		classIgnores = ["stalonetray","trayer"]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myKeys =
	[
		((controlMask .|. mod1Mask, xK_t), spawn "gnome-terminal"),
		((controlMask .|. mod1Mask, xK_f), spawn "firefox"),
		((mod1Mask, xK_u), spawn "python /home/sam/programming/gestures/test.py"),
		((mod1Mask,xK_Print), spawn "sleep 0.2; scrot -s '/home/sam/.screenshot/%Y-%m-%d-%H-%M-%S-scrot.png'"),
		((0,xK_Print), spawn "scrot '/home/sam/.screenshot/%Y-%m-%d-%H-%M-%S-scrot.png'"),
    ((mod1Mask, xK_q), spawn "/usr/bin/xmonad --recompile; /usr/bin/xmonad --restart")
	]
	++ -- important since ff. is a list itself, can't just put inside above list
	[((otherModMasks .|. mod1Mask, key), windows $ action tag)
		| (tag, key) <- zip myWorkspaces [xK_1 .. xK_9]
		, (action, otherModMasks) <- [(W.greedyView, 0), (W.shift, controlMask)]] 
	++
	[((m .|. mod1Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
		| (key, sc) <- zip [xK_comma, xK_period] [0..]
		, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

{-startup :: X()-}
{-startup = do-}
  {---spawn "stalonetray"-}
  {-[>spawn "dbus-launch nm-applet --sm-disable"<]-}
  {---spawn "gnome-settings-daemon"-}
  {-spawn "trayer --edge bottom --align right --SetDockType true --widthtype pixel --width 190 --heighttype pixel --height 20"-}
  {-spawn "dropbox start"-}
  {-spawn "gnome-screensaver"-}
  {-spawn "gnome-volume-control-applet"-}
  {-spawn "gnome-power-manager"-}
  {-spawn "nm-applet --sm-disable"-}
  {-spawn "workrave"-}

