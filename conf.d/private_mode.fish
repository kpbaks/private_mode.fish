if set -q fish_private_mode; and test $fish_private_mode -eq 1
    set -l reset (set_color normal)
    # TODO: document in readme
    set -q private_mode_bg_color
    or set -U private_mode_bg_color '#25003e' # same as background color in firefox private mode's welcome page.

    set -q private_mode_fg_color
    or set -g private_mode_fg_color "#$fish_color_normal"
    # set -l private_mode_fg_color '#00ffff'

    set -l jq_program
    if command -q jaq
        set jq_program jaq
    else if command -q jq
        set jq_program jq
    else
        printf '%serror%s: No jq program installed. Install either jq or jaq (recommended)\n' (set_color red) $reset >&2
        return
    end

    if set -q KITTY_PID; and command -q kitten
        # NOTE: adding variables to global is necessary to have access to them in the function scope of the `fish_exit` handler function
        set -g __private_mode_kitty_id (kitten @ ls | command $jq_program 'last(.[].id)')
        set -g __private_mode_existing_bg_color (kitten @ get-colors --match id:$__private_mode_kitty_id | string match --regex --groups-only '^background\s+(.+)')
        set -g __private_mode_existing_fg_color (kitten @ get-colors --match id:$__private_mode_kitty_id | string match --regex --groups-only '^foreground\s+(.+)')

        kitten @ set-colors --match id:$__private_mode_kitty_id background=$private_mode_bg_color foreground=$private_mode_fg_color

        function __private_mode_restore_bg_color_on_fish_exit --on-event fish_exit
            kitten @ set-colors --match id:$__private_mode_kitty_id background=$__private_mode_existing_bg_color
            kitten @ set-colors --match id:$__private_mode_kitty_id foreground=$__private_mode_existing_fg_color
        end

    else if set -q ALACRITTY_WINDOW_ID; and command -q alacritty; and command -q taplo
        command alacritty msg config "colors.primary.background=\"$private_mode_bg_color\""
        command alacritty msg config "colors.primary.foreground=\"$private_mode_fg_color\""

        set -l alacritty_config_file ~/.config/alacritty/alacritty.toml
        if test -f $alacritty_config_file
            # FIXME: what if background color is not set in config?
            # NOTE: adding variables to global is necessary to have access to them in the function scope of the `fish_exit` handler function
            set -g __private_mode_existing_bg_color (command taplo get colors.primary.background < $alacritty_config_file)
            set -g __private_mode_existing_fg_color (command taplo get colors.primary.foreground < $alacritty_config_file)
        else
            # TODO: handle this case
        end

        function __private_mode_restore_bg_color_on_fish_exit --on-event fish_exit
            if set -q __private_mode_existing_bg_color
                command alacritty msg config "colors.primary.background=\"$__private_mode_existing_bg_color\""
                command alacritty msg config "colors.primary.foreground=\"$__private_mode_existing_fg_color\""
            end
        end

    else
        # TODO: list supported terminals
        printf '%s warn%s: You have installed `kpbaks/private_mode.fish` but are not running in a supported terminal\n' (set_color yellow) >&2
    end
    # TODO: support wezterm and konsole
end
