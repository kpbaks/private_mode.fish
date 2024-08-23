# private_mode.fish

Change terminal {fore,back}ground color when entering private mode in fish with `fish --private`, to make
it more apparent which mode your in! 
Color settings before entering will be restored upon leaving private mode.

> [!TIP]
> What is private mode?
> It is a feature built into `fish` that can be activated with the `--private` flag when spawning the shell.
> When in private mode, no typed commands are persisted to the `$history` variable.
> This means that any command you type, will not be suggested in future sessions or stored in plain text on your disk.
> A place where this is useful is if you have commands where sensitive information such as a password is passed to a command
> through a flag like `--password=[PASSWORD]` instead of an environment variable or a file.
> You can read more about it [here](https://fishshell.com/docs/current/interactive.html#private-mode).

## TODOs

- [ ] Add video demo
- [ ] Support more terminals
- [ ] Come up with a funnier name

## Terminal Support

|--|--|
|:--|:--:|
|Terminal| Supported|
| `kitty` | yes |
| `alacritty` | yes |
| `wezterm` | Planned |

## Installation

### `fisher`

```fish
fisher install kpbaks/private_mode.fish
```

## Configure

| Variable | Default | 
|----------|---------|
| `private_mode_bg_color` | '#25003e' |
| `private_mode_fg_color` | '$fish_color_normal' |

`private_mode_bg_color` is the same, as the background color in firefox private mode's welcome page.


