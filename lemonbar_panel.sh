#! /bin/sh
#
# Example panel for LemonBoy's bar

source ./panel_colors

num_mon=$(bspc query -M | wc -l)
PADDING=" "
SEP="//"

while read -r line ; do
  case $line in
    D*)
      # date output
      date="$PADDING${line#?}$PADDING"
      ;;
    R*)
      # music info
      music="%{B$COLOR_FOCUSED_OCCUPIED_BG}%{F$COLOR_FOCUSED_OCCUPIED_FG}$PADDING${line#?}$PADDING%{F-}%{B-}"
      ;;
    C*)
      # clock output
      clock="$PADDING${line#?}$PADDING"
      ;;

    B*)
      # battery percent output
      # battery="%{A:bat.sh:}$PADDING${line#?}$PADDING%{A}"
      battery="$PADDING${line#?}$PADDING"
      ;;
    T*)
      # xtitle output
      title="${line#?}$PADDING$SEP"
      ;;

    V*)
      # alsa volume
      volume="$PADDING${line#?}$PADDING"
      ;;
    L*)
      # wifi link
      wifi="$PADDING${line#?}$PADDING"
      ;;
    F*)
      # free space /home
      free="$PADDING${line#?}$PADDING"
      ;;
    P*)
      # power
      power="%{A2:poweroff.sh:}%{A3:reboot.sh:}$PADDING${line#?}$PADDING%{A}%{A}"
      ;;

    W*)
      # bspwm internal state
      wm_infos=""
      IFS=':'
      set -- ${line#?}
      while [ $# -gt 0 ] ; do
        item=$1
        name=${item#?}
        case $item in
          M*)
            # active monitor
            if [ $num_mon -gt 1 ] ; then
              wm_infos="$wm_infos %{F$COLOR_ACTIVE_MONITOR_FG}%{B$COLOR_ACTIVE_MONITOR_BG}$PADDING${name}$PADDING%{B-}%{F-}  "
            fi
            ;;
          m*)
            # inactive monitor
            if [ $num_mon -gt 1 ] ; then
              wm_infos="$wm_infos %{F$COLOR_INACTIVE_MONITOR_FG}%{B$COLOR_INACTIVE_MONITOR_BG}$PADDING${name}$PADDING%{B-}%{F-}  "
            fi
            ;;
          O*)
            # focused occupied desktop
            wm_infos="${wm_infos}%{F$COLOR_FOCUSED_OCCUPIED_FG}%{B$COLOR_FOCUSED_OCCUPIED_BG}%{U$COLOR_FOREGROUND}%{+u}$PADDING${name}$PADDING%{-u}%{B-}%{F-}"
            ;;
          F*)
            # focused free desktop
            wm_infos="${wm_infos}%{F$COLOR_FOCUSED_FREE_FG}%{B$COLOR_FOCUSED_FREE_BG}%{U$COLOR_FOREGROUND}%{+u}$PADDING${name}$PADDING%{-u}%{B-}%{F-}"
            ;;
          U*)
            # focused urgent desktop
            wm_infos="${wm_infos}%{F$COLOR_FOCUSED_URGENT_FG}%{B$COLOR_FOCUSED_URGENT_BG}%{U$COLOR_FOREGROUND}%{+u}$PADDING${name}$PADDING%{-u}%{B-}%{F-}"
            ;;
          o*)
            # occupied desktop
            wm_infos="${wm_infos}%{F$COLOR_OCCUPIED_FG}%{B$COLOR_OCCUPIED_BG}%{A:bspc desktop -f ${name}:}$PADDING${name}$PADDING%{A}%{B-}%{F-}"
            ;;
          f*)
            # free desktop
            wm_infos="${wm_infos}%{F$COLOR_FREE_FG}%{B$COLOR_FREE_BG}%{A:bspc desktop -f ${name}:}$PADDING${name}$PADDING%{A}%{B-}%{F-}"
            ;;
          u*)
            # urgent desktop
            wm_infos="${wm_infos}%{F$COLOR_URGENT_FG}%{B$COLOR_URGENT_BG}$PADDING${name}$PADDING%{B-}%{F-}"
            ;;
        esac
        shift
      done
      ;;
  esac
  printf "%s\n" "%{l}${wm_infos}%{r}${title}${free}${wifi}${battery}${date}${clock}${volume}${power}"
done
