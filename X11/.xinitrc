#!/bin/sh

# xrandr --output HDMI-1 --primary --left-of eDP-1 &
# xrandr --output eDP1 --off &
# mydisplaymanager HDMI1 &

[ -f ~/.Xresources ] && xrdb "$HOME"/.Xresources &
xrdbpid=$!

# redshift -O 3500 &
# sudo ntpd -u ntp:ntp&
# sudo hwclock -w&
setbg &
redshift -l 34.19:35.88 &
xrandr --output eDP-1 --mode 1600x900 &
# weather& # fetch today's weather
# ! pidof -s transmission-daemon >/dev/null 2>&1 && eval $TRANSMISSION_DAEMON >/dev/null 2>&1 &
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/cronsaved ] && crontab - <"${XDG_CONFIG_HOME:-$HOME/.config}"/cronsaved && rm "${XDG_CONFIG_HOME:-$HOME/.config}"/cronsaved &
sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z" &
# mpd-notifyd& # uses a lot of cpu
# syncthing &

xautolock -time 10 -locker 'lock' -detectsleep &
# while true; do
#      sudo e2guardian -QN
# done & disown
# remaps &

# killall xcape 2>/dev/null ; xcape -e 'Control_L=Escape'&
# babysit_mem

autostart="clipmenud dunst picom mpd"

for program in $autostart; do
    pidof -sx "$program" || "$program" &
done >/dev/null 2>&1

[ "$xrdbpid" != "" ] && wait "$xrdbpid"

# # xscreensaver&
# term-wrapper &
# # qbittorrent &
# # emacs &
# # crow &
# # stardict -h &
# # xfce4-terminal -T Ncmpcpp -e ncmpcpp&
# # $BROWSER &
aw-qt &
# xfsettingsd&
# touchpad-trackpoint-toggle -T off
# synclient TouchpadOff=1&
# xinput --set-prop "Synaptics tm2964-001" "libinput Accel Speed" -1.00000&
sudo modprobe -r uvcvideo & # disable camera
# xinput --set-prop "Synaptics tm2964-001" "libinput Accel Speed" -1.00000 &

# xinput disable 12& # disable trackpoint
# thunderbird & # close afterwards. Uses a lot of CPU sometimes

# Activate dbus variables
dbus-update-activation-environment --all

# ssh-agent
# export XDG_SESSION_TYPE=x11
# export GDK_BACKEND=x11
# exec ssh-agent dwm # dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id)

# start herbstluftwm in locked mode (it will be unlocked at the end of your
# autostart)
# exec herbstluftwm --locked

# exec dbus-launch --sh-syntax --exit-with-session  openbox-session
# probably not doing this causes notifications problems

# setxkbmap -option compose:ralt &

exec ssh-agent i3
