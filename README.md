# private_mode.fish
Change terminal {fore,back}ground color when entering private mode in fish with `fish --private`.

## TODOs

- [ ] Add video demo
- [ ] Support more terminals

## Terminal Support

|--|--|
|--|--|
|Terminal| Supported|
| `kitty` | yes |
| `alacritty` | yes |
| `wezterm` | Planned |

## Installation

### `fisher`

```fish
fisher install `kpbaks/private_mode.fish`
```

## Configure

| Variable | Default | 
|----------|---------|
| `private_mode_bg_color` | '#25003e' |
| `private_mode_fg_color` | '$fish_color_normal' |

`private_mode_bg_color` is the same, as the background color in firefox private mode's welcome page.


