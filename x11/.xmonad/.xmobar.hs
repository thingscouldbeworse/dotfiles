Config { 

   -- appearance
    font = "xft:Source Han Sans:size=10:style=Regular:antialias=true" 
   , bgColor =      "#161620"
   , fgColor =      "#ddd"
   , position =     Bottom
   , borderColor =  "#646464"

   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "%battery%   %StdinReader% }{ %dynnetwork%  %multicpu%   %memory%   %coretemp%   %date%"

   -- general behavior
   , lowerOnStart =     False   -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)

   -- plugins
   --   Numbers can be automatically colored according to their value. xmobar
   --   decides color based on a three-tier/two-cutoff system, controlled by
   --   command options:
   --     --Low sets the low cutoff
   --     --High sets the high cutoff
   --
   --     --low sets the color below --Low cutoff
   --     --normal sets the color between --Low and --High cutoffs
   --     --High sets the color above --High cutoff
   --
   --   The --template option controls how the plugin is displayed. Text
   --   color can be set by enclosing in <fc></fc> tags. For more details
   --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
   , commands = 

        -- weather monitor
        [ Run Weather "RJTT" [ "--template", "<fc=#4682B4><skyCondition></fc> | <fc=#4682B4><tempC></fc>°C | <fc=#4682B4><rh></fc>% | <fc=#4682B4><pressure></fc>hPa"
                             ] 36000

        -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
                             , "--Low"      , "5000"       -- units: B/s
                             , "--High"     , "10000"       -- units: B/s
                             , "--low"      , "#00b300"
                             , "--normal"   , "orange"
                             , "--high"     , "red"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "-w", "3" 
                             , "--template" , "<total0> <total1> <total2> <total3> "
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#00b300"
                             , "--normal"   , "orange"
                             , "--high"     , "red"
                             ] 10

        -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "<core0>°<core1>°"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#00b300"
                             , "--normal"   , "orange"
                             , "--high"     , "red"
                             ] 50
                          
        -- memory usage monitor
        , Run Memory         [ "--template" ,"<usedratio>%"
                             , "--Low"      , "20"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#00b300"
                             , "--normal"   , "orange"
                             , "--high"     , "red"
                             ] 10

        -- battery monitor
        , Run Battery        [ "--template" , "<acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "50"        -- units: %
                             , "--low"      , "red"
                             , "--normal"   , "orange"
                             , "--high"     , "#00b300"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o" , "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O" , "<fc=#dAA520><left> Charging </fc>"
                                       -- charged status
                                       , "-i"        
                                       , "<fc=#006000><left></fc>"
                             ] 50
        -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date "%r %a, %d" "date" 10

        , Run StdinReader
        
        -- Is the internet on fire?
        , Run Com "/home/kirk/Scripts/fire.sh" ["90"] "fire" 3000
        
        ]
   }
