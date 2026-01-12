#!/bin/sh

function run {
	if (command -v $1 && ! pgrep $1); then
		$@ >/dev/null 2>&1 &
	fi
}

# run nm-applet # Maybe causing Internet disruptions
# run pnmixer
# run cbatticon -n
# run tint2
run sxhkd || pkill -usr1 -x sxhkd

pkill xclock
pkill stalonetray

# height="22"
# stalonetray --geometry 1x1+0+0 --grow-gravity NW --background black &
xclock -digital -strftime '%3a %d-%m %H:%M' -bg black -fg green -padding 0 -geometry +0+0 -update 1  -face 'Liberation Sans-12' &
# sleep 0.5
# xclock -digital -strftime '%3a %d-%m %H:%M' -bg black -fg green -padding 0 -geometry +0+"$height" -update 1  -face 'Liberation Sans-12' &
# stalonetray  --background black  --icon-size "$height" --geometry 1x1+0+18 & disown
# # --dockapp-mode simple
## run (only once) processes which spawn with the same name
# run setbg
# run term-wrapper
# polybar-wrapper
# run tint2
# polybar-wrapper
# run stalonetray --geometry 1x1-0+0 --grow-gravity NW --background black # 1x1+0+19
# run batsignal -p
# run qterminal -d
# run xfce4-panel
# run nm-applet
# run xfsettingsd
# xclock -digital -strftime '%3a %d-%m %H:%M' -bg black -fg green -padding 0 -geometry +0+0 -update 1 &
# run stalonetray --geometry 1x1+112+0 --grow-gravity NW --background black # 1x1+0+19
# run batsignal
# run tint2
# run lxpanel
