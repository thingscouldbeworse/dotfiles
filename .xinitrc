# set cursor
xsetroot -cursor_name left_ptr

# turn off system beep
xset -b

# set the background
sh ~/.fehbg &

# restart xorg-db to use .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# allow custom bindings (volume and screen lock controlled through here)
xbindkeys

# start xmobar, for a statusbar
exec xmobar &

# tell all programs I'm using LG3D instead of xmonad because Sun Microsystems
# are a bunch of incompetent assholes who have no idea how the fuck to comply with 
# other people's regulations and Java still violates ICCCM and anything written in 
# Java will fuck up with text, windows, dialogue boxes, colors, and just generally
# everything if you let it find out you're using xmonad
wmname LG3D

# set mouse acceleration to 9/4 after 2 ms
xset m 9/10 2

# swap esc and caps-lock
setxkbmap -option caps:swapescape

# start compositor
compton -b -C -G --xrender-sync --xrender-sync-fence

# start xmonad
exec xmonad

