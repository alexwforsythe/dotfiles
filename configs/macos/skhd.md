# skhd config

features:

- use skhd without disabling SIP -- some are still disabled
  - moving spaces/displays
  - colored borders
  - windows: pip, sticky, top
- easy to remember modal bindings like vim (and to a lesser extent, tmux &
  VSCode)
- unified modal hotkeys and regular shortcuts

@todo

- [x] inject script to brew service via /usr/local/bin symlink
- [x] use /bin/bash (or /bin/dash)

```shell
  brew services start skhd --file="$DOTFILES_DIR/configs/macos/homebrew.mxcl.skhd.plist"
```

## Mode hotkeys

### Syntax

We use modes to construct hotkey "sentences" that use the following syntax to
perform actions:

|         | verb          | noun         | target            |
| ------- | ------------- | ------------ | ----------------- |
| hotkey: | <kbd>^f</kbd> | <kbd>w</kbd> | <kbd>h</kbd>      |
| action: | focus         | window       | left (of current) |

### Vocabulary

The vocabulary is inspired by vim and tmux. I plan to update my bindings for
those programs to match these:

Nouns and verbs are based on yabai:

| noun      | keysym       |
| --------- | ------------ |
| `display` | <kbd>d</kbd> |
| `space`   | <kbd>s</kbd> |
| `window`  | <kbd>w</kbd> |

All hotkey modes must be initiated by our global mode trigger
<kbd>^+\<verb\></kbd>.

- Once a mode is active, it will intercept all keypresses until the mode is
  exited
- A mode can be exited by completing a valid hotkey sequence, or at any time by
  pressing <kbd>esc</kbd>

| supported nouns          | verb                         | keysym        | description                                                                                                                                                 |
| ------------------------ | ---------------------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `display\|space\|window` | `focus`                      | <kbd>^f</kbd> | focuses the target<br/>yabai can't focus spaces with SIP enabled, so we focus them by synthesizing MacOS shortcuts (<kbd>cmd+\<index\></kbd>) via `skhd -k` |
|                          | `toggle`                     | <kbd>^t</kbd> | toggles yabai settings not handled by other verbs                                                                                                           |
|                          | `move` (focused window to)   | <kbd>^m</kbd> | yabai can only swap/move **windows** with SIP enabled, so moves the focused window to the target                                                            |
| `window`                 | `swap` (focused window with) | <kbd>^s</kbd> | swaps the focused window with the target window                                                                                                             |
|                          | `resize`                     | <kbd>^r</kbd> | resizes the focused window                                                                                                                                  |

| matching predicates                                          | target                              | keysym                                                    | notes                                                           |
| ------------------------------------------------------------ | ----------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------- |
| `focus <display\|space\|window>`,<br />`swap\|move <window>` | prev/next                           | <kbd>[</kbd> / <kbd>]</kbd>                               | `focus\|swap`: or last/first target, if it doesn't exist        |
|                                                              | prev/next child                     | <kbd>,</kbd> / <kbd>.</kbd>                               | `display` > `space` > `window` > stacked window                 |
|                                                              | recent                              | <kbd>;</kbd>                                              | `window`: in focused space<br/>like tmux (near positional keys) |
| `toggle <space>`                                             | padding & gap                       | <kbd>p</kbd>                                              |
|                                                              | bsp                                 | <kbd>b</kbd>                                              |
|                                                              | float                               | <kbd>f</kbd>                                              |
|                                                              | stack                               | <kbd>s</kbd>                                              |
|                                                              | show desktop                        | <kbd>d</kbd>                                              |
| `toggle <window>`                                            | border                              | <kbd>b</kbd>                                              |
|                                                              | float & centered                    | <kbd>f</kbd>                                              |
|                                                              | split                               | <kbd>i</kbd>                                              | 'i' for "insertion" point                                       |
|                                                              | quit                                | <kbd>q</kbd>                                              |
| `swap\|move\|grid\|resize <window>`                          | left / down / up / right            | <kbd>h</kbd> / <kbd>j</kbd> / <kbd>k</kbd> / <kbd>l</kbd> | `grid`: half                                                    |
| `swap\|grid <window>`                                        | rotate clockwise / counterclockwise | <kbd>o</kbd> / <kbd>O</kbd>                               | like tmux ('o' like a circle?)                                  |
| `toggle\|grid\|resize <window>`                              | zoom                                | <kbd>z</kbd>                                              |
|                                                              | maximize / full screen              | <kbd>m</kbd> / <kbd>cmd+m</kbd>                           |
|                                                              | balance all in space                | <kbd>e</kbd>                                              | like tmux ('e' for "equal"?)                                    |
|                                                              | float & centered                    | <kbd>c</kbd>                                              |
| `grid <window>`                                              | top / bottom left quarter           | <kbd>alt+h</kbd> / <kbd>alt+j</kbd>                       |
| `grid <window>`                                              | top / bottom right quarter          | <kbd>alt+k</kbd> / <kbd>alt+l</kbd>                       |

## Shortcut hotkeys

Shortcuts are a subset of my frequently used modal hotkeys that can be executed
in the default mode with a single keystroke. For the most part, they use the
same props as modal hotkeys.

Unlike modes, though, shortcuts reference verb/noun predicates via modifier
keys:

| predicate                    | modifiers                 | supported targets                       | notes             |
| ---------------------------- | ------------------------- | --------------------------------------- | ----------------- |
| `focus <window>`             | <kbd>ctrl</kbd>           | all                                     |
| `focus <space>`              | <kbd>ctrl+alt</kbd>       | all                                     |
| `focus <display>`            | <kbd>ctrl+cmd</kbd>       | all                                     |
| `swap <window>`              | <kbd>ctrl+shift</kbd>     | all                                     |
| `move <window> to <space>`   | <kbd>ctrl+alt+shift</kbd> | all                                     | AKA `meh` by skhd |
| `move <window> to <display>` | <kbd>ctrl+cmd+shift</kbd> | all                                     |
| `resize <window>`            | <kbd>alt+shift</kbd>      | `left\|down\|up\|right\|zoom\|maximize` |

Finally, some shortcuts are unrelated to their modal counterparts:

| action                                      | keysym                                | notes                      |
| ------------------------------------------- | ------------------------------------- | -------------------------- |
| focus recent space                          | <kbd>cmd+tab</kbd>                    |
| focus recent window in space                | <kbd>cmd+\`</kbd>                     |
| focus recent item in window stack           | <kbd>alt+\`</kbd>                     |
| rotate windows clockwise / counterclockwise | <kbd>ctrl+o</kbd> / <kbd>ctrl+O</kbd> | because I like using shift |

## Key codes

Key codes Some keys are interpreted as config syntax by skhd, so rules must
reference them by their key codes to avoid a syntax error.

- A list of all built-in modifier and literal keywords can be found
  [here](https://github.com/koekeishiya/skhd/issues/1)
- Or by running `skhd --observe` (make sure to stop the background service
  first)

| Key | Code |
| --- | ---- |
| -   | 0x1B |
| =   | 0x18 |
| [   | 0x21 |
| ]   | 0x1E |
| \   | 0x2A |
| ;   | 0x29 |
| '   | 0x27 |
| ,   | 0x2B |
| .   | 0x2F |
| /   | 0x2C |

## Development

### Debugging skhd

Debug by stopping the skhd service and running it manually with options:

```shell
brew services kill skhd
# print debug logs to stdout
skhd -V
# ...update config, fix errors...
# ...^c to stop skhd...
brew services run skhd
```

The syntax guide and other useful options can be found at
[koekeishiya/skhd](https://github.com/koekeishiya/skhd).

### yabaictl

features:

- focus spaces
- wrapping
- exit mode automatically

notes:

- avoid posix-incompatible commands (use shellcheck)
- avoid non-builtins (other than jq)
- avoid subshell-ing too much

## Inspiration

- [Intro video](https://www.youtube.com/watch?v=Vj6Pz_WUMR0)
- Modal hotkeys:
  [nikhgupta/dotfiles](https://github.com/nikhgupta/dotfiles/blob/osx/config/skhd/skhdrc)
