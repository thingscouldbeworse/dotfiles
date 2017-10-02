-- Main XMonad source code.
import XMonad

-- Logging for spawned things
import XMonad.Hooks.DynamicLog

-- Allow management of dock programs.
import XMonad.Hooks.ManageDocks

-- Allow exec of programs (return handle).
import XMonad.Util.Run(spawnPipe)

-- Allow adding or removing keybindings.
import XMonad.Util.EZConfig(additionalKeys)

-- Allow Pointer-Follows-Focus.
import XMonad.Actions.UpdatePointer

-- Allow smart borders on fullscreen windows
import XMonad.Layout.NoBorders

-- Allow interfacing with system (get client info).
import System.IO


main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/kirk/.xmonad/.xmobar.hs"
    xmonad $ defaultConfig
        {
        terminal           = myTerminal

        , handleEventHook = mconcat
                        [ docksEventHook
                        , handleEventHook defaultConfig ]

        , focusFollowsMouse  = myFocusFollowsMouse

        , clickJustFocuses   = myClickJustFocuses

        , borderWidth        = myBorderWidth

        , modMask            = myModMask

        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

        -- hooks, layouts
        , layoutHook         = myLayout
        , manageHook         = myManageHook
        , logHook            = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn xmproc }
        }

myModMask               = mod4Mask

myFocusFollowsMouse     = False
myClickJustFocuses      = False

myBorderWidth           = 0

myTerminal              = "urxvt"

myNormalBorderColor     = "gray"
myFocusedBorderColor    = "blue"

myLayout                = avoidStruts  $  layoutHook defaultConfig
myManageHook            = manageDocks <+> manageHook defaultConfig
myLogHook h             = dynamicLogWithPP $ xmobarPP
                                                {ppTitle = xmobarColor "green" "" . shorten 50
                                                , ppOutput = hPutStrLn h
                                                }
