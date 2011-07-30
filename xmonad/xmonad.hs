import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W


main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
	xmonad $ defaultConfig
		{
			modMask = mod1Mask,
			manageHook = manageDocks <+> myManageHooks
				<+> manageHook defaultConfig,
			layoutHook = avoidStruts $ layoutHook defaultConfig,
			logHook = dynamicLogWithPP $ xmobarPP
				{
					ppOutput = hPutStrLn xmproc,
					ppTitle = xmobarColor "green" "" . shorten 100
				},
				focusFollowsMouse = False,
				workspaces = myWorkspaces
		} `additionalKeys` myKeys

myManageHooks = composeAll
	[
--		isFullscreen --> (doF W.focusDown <+> doFullFloat)
		isFullscreen --> doFullFloat,
		className =? "Gimp" --> doFloat,
		className =? "Vncviewer" --> doFloat,
		className =? "UTNaoTool" --> doFloat,
		title =? "Pursuit Simulation" --> doFloat,
		className =? "Songbird" --> doF (W.shift "9"),
		className =? "Guayadeque" --> doF (W.shift "9"),
		className =? "Pithos" --> doF (W.shift "9")
	]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myKeys =
	[
		((controlMask .|. mod1Mask, xK_t), spawn "gnome-terminal"),
		((controlMask .|. mod1Mask, xK_f), spawn "firefox")
	]
	++ -- important since ff. is a list itself, can't just put inside above list
	[((otherModMasks .|. mod1Mask, key), windows $ action tag)
		| (tag, key) <- zip myWorkspaces [xK_1 .. xK_9]
		, (action, otherModMasks) <- [(W.greedyView, 0), (W.shift, controlMask)]] 
	++
	[((m .|. mod1Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
		| (key, sc) <- zip [xK_comma, xK_period] [0..]
		, (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

