# Hyprland Keybinding Special Characters

When binding special characters in Hyprland, you cannot use the character directly (e.g., `>`). Instead, you must use the XKB keysym name.

## The `>` Character

Use `greater` instead of `>`:

```conf
# Correct
bind = SUPER, greater, exec, firefox

# Incorrect - will not work
bind = SUPER, >, exec, firefox
```

## Common Special Characters Reference

| Character | Keysym Name |
|-----------|-------------|
| `>` | `greater` |
| `<` | `less` |
| `;` | `semicolon` |
| `-` | `minus` |
| `.` | `period` |
| `=` | `equal` |
| `,` | `comma` |
| `/` | `slash` |
| `'` | `apostrophe` |
| `[` | `bracketleft` |
| `]` | `bracketright` |
| `\` | `backslash` |
| `` ` `` | `grave` |
| `~` | `asciitilde` |
| `!` | `exclam` |
| `@` | `at` |
| `#` | `numbersign` |
| `$` | `dollar` |
| `%` | `percent` |
| `^` | `asciicircum` |
| `&` | `ampersand` |
| `*` | `asterisk` |
| `(` | `parenleft` |
| `)` | `parenright` |
| `-` | `minus` |
| `_` | `underscore` |
| `+` | `plus` |
| `{` | `braceleft` |
| `}` | `braceright` |
| `:` | `colon` |
| `"` | `quotedbl` |
| `\|` | `bar` |
| `?` | `question` |

## How It Works

Hyprland uses XKB (X Keyboard Extension) keysyms for keybindings. The keysym names correspond to the constants defined in `xkbcommon-keysyms.h` header file, with the `XKB_KEY_` prefix removed.

For example:
- `XKB_KEY_greater` → use `greater`
- `XKB_KEY_minus` → use `minus`

## Finding Keysyms

If you're unsure about a keysym name:

1. **Use `wev`** - A tool that shows input events and their keysyms:
   ```bash
   wev
   ```
   Press the key you want to bind and look for the `keysym` field.

2. **Check `xkbcommon-keysyms.h`** - The full list of available keysyms is in this header file.

3. **Use keycodes** - If keysym names don't work, you can use keycodes with the `code:` prefix:
   ```conf
   bind = SUPER, code:28, exec, command
   ```
   Find keycodes using `wev` or `evtest`.

## Full Example

```conf
# hyprland.conf

# Basic bind with special character
bind = SUPER SHIFT, greater, workspace, +1

# Multiple special characters
bind = ALT, semicolon, exec, notify-send "Semicolon pressed"

# Keycode alternative
bind = CTRL, code:47, exec, terminal
```

## Resources

- [Hyprland Binds Wiki](https://wiki.hyprland.org/Configuring/Binds/)
- [xkbcommon-keysyms.h](https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h)
