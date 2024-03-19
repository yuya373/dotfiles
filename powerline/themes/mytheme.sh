# Default Theme

if patched_font_in_use; then
    TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
    TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
    TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
    TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
    TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
    TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
    TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
    TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

BASE03="234"
BASE02="235"
BASE01="240"
BASE00="241"
BASE0="244"

BASE1="245"
BASE2="254"
BASE3="230"

YELLOW="136"
ORANGE="166"
RED="160"
MAGENTA="125"
VIOLET="61"
BLUE="33"
CYAN="37"
GREEN="64"

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-${BASE03}}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-${BASE02}}
TMUX_POWERLINE_SEG_AIR_COLOR=$("${TMUX_POWERLINE_DIR_HOME}/segments/air_color.sh")

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_THIN}

# See `man tmux` for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveniences

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
    TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
        "#[$(format inverse)]" \
            "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR" \
            " #I#F " \
            "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
            " #W " \
            "#[$(format regular)]" \
            "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
    )
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
    TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
        "$(format regular)"
    )
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
    TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
        "#[$(format regular)]" \
            "  #I#{?window_flags,#F, } " \
            "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
            " #W "
    )
fi


# Format: segment_name background_color foreground_color [non_default_separator]

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
    TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
        "tmux_session_info ${BASE02} ${GREEN}" \
            # "hostname 33 0" \
            #"ifstat 30 255" \
            #"ifstat_sys 30 255" \
            # "vcs_branch 29 88" \
            # "vcs_compare 60 255" \
            # "vcs_staged 64 255" \
            # "vcs_modified 9 255" \
            # "vcs_others 245 0" \
            )
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
    TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
        "lan_ip ${BASE02} ${BLUE}" \
            "wan_ip ${BASE02} ${BLUE}" \
            #"earthquake 3 0" \
            "pwd ${BASE02} 211" \
            # "mailcount 9 255" \
            # "now_playing 234 37" \
            #"cpu 240 136" \
            # "load 237 167" \
            #"tmux_mem_cpu_load 234 136" \
            # "battery 137 127" \
            # "weather ${BASE02} ${CYAN}" \
            #"rainbarf 0 0" \
            #"xkb_layout 125 117" \
            # "date_day ${BASE02} ${YELLOW}" \
            # "date ${BASE02} ${YELLOW} ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
            # "time ${BASE02} ${YELLOW} ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
            #"utc_time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
            )
fi
