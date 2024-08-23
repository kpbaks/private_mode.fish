if set -q fish_private_mode; and test $fish_private_mode -eq 1
    # TODO: make user configurable
    set -l private_mode_bg_color '#25023E' # same as firefox private mode
    set -l jq_program
    if command -q jaq
        set jq_program jaq
    else if command -q jq
        set jq_program jq
    else
        # TODO: log error about missing dependencies
        return
    end

    if set -q KITTY_PID; and command -q kitten
        set -g __fish_private_mode_bg_color_kitty_id (kitten @ ls | command $jq_program 'last(.[].id)')
        set -g __fish_private_mode_existing_bg_color (kitten @ get-colors --match id:$__fish_private_mode_bg_color_kitty_id | string match --regex --groups-only '^background\s+(.+)')
        kitten @ set-colors --match id:$__fish_private_mode_bg_color_kitty_id background=$private_mode_bg_color

        function __private_mode_restore_bg_color_on_fish_exit --on-event fish_exit
            kitten @ set-colors --match id:$__fish_private_mode_bg_color_kitty_id background=$__fish_private_mode_existing_bg_color
        end

    else if set -q ALACRITTY_WINDOW_ID; and command -q alacritty; and command -q taplo
        command alacritty msg config "colors.primary.background=\"$private_mode_bg_color\""
        set -l alacritty_config_file ~/.config/alacritty/alacritty.toml
        if test -f $alacritty_config_file
            # FIXME: what if background color is not set in config?
            set -g __private_mode_existing_bg_color (command taplo get colors.primary.background < $alacritty_config_file)
        end

        function __private_mode_restore_bg_color_on_fish_exit --on-event fish_exit
            if set -q __private_mode_existing_bg_color
                command alacritty msg config "colors.primary.background=\"$__private_mode_existing_bg_color\""
            end
        end

    end

    # TODO: support wezterm and konsole
end
