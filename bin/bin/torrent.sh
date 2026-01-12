#!/bin/bash
######################################################################
#Copyright (C) 2023  Kris Occhipinti
#https://filmsbykris.com

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
######################################################################
url="https://thepiratebay.party/search"

[[ $1 ]] && q="$*" || read -p "Enter Search Query: " q

echo "$url/$q" | sed 's/ /%20/g'
page="$(wget -qO- "$url/$q" | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf "%b")"
list="$(echo "$page" | grep magnet | grep -v '<meta' | sed 's/href="magnet/\nmagnet/g' | grep magnet | cut -d\" -f1 | awk -F\& '{print $2 "|" $1}' | tr "+" " " | sed 's/dn=//g')"
#selection="$(echo -e "$list"|cut -d\| -f1|fzf)"
selection="$(echo -e "$list" | fzf)"
[[ $selection ]] || exit 1

#display File Size and Seeds
title="$(echo -e "$selection" | cut -d\| -f1)"
echo "$title"
#echo -n "$page"|grep "$title" -A2|tail -n2 |sed 's/&nbsp;/ /g'|cut -d\> -f2|cut -d\< -f1|tr "\n" " "
echo -e "Size \t\t Seeds"
echo -n "$page" |
	grep "$title" -A2 |
	tail -n2 |
	sed 's/<td align="right">//g;s/<\/td>//g;s/&nbsp;/ /g' |
	dos2unix |
	sed ':a;N;$!ba;s/\n/ \t /g'

magnet="$(echo -e "$selection" | cut -d\| -f2)"

[[ $magnet ]] || exit 1
echo ": $(date +%s):0;aria2c --seed-time=1 '$magnet'" >>$HOME/.zsh_history
aria2c --seed-time=1 "$magnet"
