#!/usr/bin/bash
updatelist=$(pacman -Qu | wc -l)
list=$(pacman -Qu)
user_list=($(who | grep -E "\(:[0-9](\.[0-9])*\)" | awk '{print $1 "@" $NF}' | sort -u))
if [ $updatelist -eq 0 ]
then
 print="Up-to-date!"
else
 print="$updatelist Updates Available"
fi
for user in $user_list; do
    username=${user%@*}
    display=${user#*@}
    dbus=unix:path=/run/user/$(id -u $username)/bus

    sudo -u $username DISPLAY=${display:1:-1} \
                      DBUS_SESSION_BUS_ADDRESS=$dbus \
                      notify-send "$@" -t 0 "$print" "$list"
done
