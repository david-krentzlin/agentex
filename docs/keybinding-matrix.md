# Keybinding Matrix

## Ownership policy

- WezTerm owns `SUPER` window and tab keys.
- Zellij owns `Alt` pane, tab, and session keys.
- Helix owns editor-local keys, including `Ctrl`-based workflow keys.

## Matrix

| Layer | Context/Mode | Key | Action |
| --- | --- | --- | --- |
| WezTerm | global | `CMD+c` | Copy to clipboard |
| WezTerm | global | `CMD+v` | Paste from clipboard |
| WezTerm | global | `SUPER+SHIFT+l` | Activate tab 1 |
| WezTerm | global | `SUPER+SHIFT+d` | Activate tab 2 |
| WezTerm | global | `SUPER+SHIFT+n` | Next tab |
| WezTerm | global | `SUPER+SHIFT+p` | Previous tab |
| WezTerm | global | `SUPER+SHIFT+c` | New tab |
| WezTerm | global | `SUPER+SHIFT+r` | Prompt and set tab title |
| WezTerm | global | `SUPER++` | Increase font size |
| WezTerm | global | `SUPER+-` | Decrease font size |
| Zellij | `normal` | `Alt+l` | Switch to `locked` mode |
| Zellij | `locked` | `Alt+a` | Switch to `normal` mode |
| Zellij | shared except `locked` | `Alt+a` | Switch to `locked` mode |
| Zellij | `normal`, `locked` | `Alt+F` | Open floating shell |
| Zellij | `normal`, `locked` | `Alt+G` | Open floating lazygit |
| Zellij | `normal`, `locked` | `Alt+E` | Open floating yazi |
| Zellij | `normal`, `locked` | `Alt+R` | Open floating scooter |
| Zellij | `normal`, `locked` | `Alt+W` | Open floating task popup (conditional) |
| Zellij | `normal`, `locked` | `Alt+?` | Open floating cheatsheet |
| Zellij | `normal`, `locked` | `Alt+H` | Move focus left |
| Zellij | `normal`, `locked` | `Alt+J` | Move focus down |
| Zellij | `normal`, `locked` | `Alt+K` | Move focus up |
| Zellij | `normal`, `locked` | `Alt+L` | Move focus right |
| Zellij | `normal`, `locked` | `Alt+V` | New pane on right |
| Zellij | `normal`, `locked` | `Alt+O` | Toggle pane embedded/floating |
| Zellij | `normal`, `locked` | `Alt+Z` | Toggle fullscreen focus |
| Zellij | `normal`, `locked` | `Alt+T` | New tab |
| Zellij | `normal`, `locked` | `Alt+M` | Rename tab mode |
| Zellij | `normal`, `locked` | `Alt+N` | Next tab |
| Zellij | `normal`, `locked` | `Alt+P` | Previous tab |
| Zellij | `normal`, `locked` | `Alt+Q` | Close tab |
| Zellij | `normal`, `locked` | `Alt+D` | Detach session |
| Zellij | `normal`, `locked` | `Alt+1` | Go to tab 1 |
| Zellij | `normal`, `locked` | `Alt+2` | Go to tab 2 |
| Zellij | `normal`, `locked` | `Alt+3` | Go to tab 3 |
| Zellij | `normal`, `locked` | `Alt+4` | Go to tab 4 |
| Zellij | `normal`, `locked` | `Alt+5` | Go to tab 5 |
| Zellij | `normal`, `locked` | `Alt+6` | Go to tab 6 |
| Zellij | `normal`, `locked` | `Alt+7` | Go to tab 7 |
| Zellij | `normal`, `locked` | `Alt+8` | Go to tab 8 |
| Zellij | `normal`, `locked` | `Alt+9` | Go to tab 9 |
| Zellij | `renametab` | `Ctrl+c` | Exit rename tab mode to `locked` |
| Zellij | `renametab` | `Enter` | Confirm rename and return to `locked` |
| Zellij | `renametab` | `Esc` | Undo rename and return to `locked` |
| Helix | normal | `{` | Previous paragraph |
| Helix | normal | `}` | Next paragraph |
| Helix | normal | `*` | Search selection under cursor |
| Helix | normal | `D` | Delete to end of line |
| Helix | normal | `Ctrl+e` | File picker workflow via yazi |
| Helix | normal | `Ctrl+r` | Write all, run scooter, reload |
| Helix | normal | `Ctrl+g` | Open lazygit workflow |
| Helix | normal | `Ctrl+p` | Write all and run markdown preview |
| Helix | select | `{` | Previous paragraph |
| Helix | select | `}` | Next paragraph |
| Helix | normal (space) | `Space+*` | Global search for selection |

## Conflict review

- No cross-layer ownership conflicts found: WezTerm custom navigation keys are `SUPER`-based, Zellij control keys are `Alt`-based, and Helix workflow keys are editor-local with `Ctrl` and mode-local mappings.
- Zellij reuses `Alt+a` in different mode scopes (`locked` vs shared-except-`locked`) intentionally, so behavior is mode-dependent rather than conflicting.
- Helix `Ctrl+g` does not conflict with Zellij because `Ctrl+g` is explicitly unbound in Zellij.

## Notes

- Save uses `:w`.
- There is no custom `Ctrl+s` binding.
- There is no custom `Space w` binding.
