# zsh

Startup file load order:

| File          | Interactive Login | Interactive Non-Login | Non-Interactive (Script) |
| ------------- | ----------------- | --------------------- | ------------------------ |
| `/etc/zshenv` | ✅                | ✅                    | ✅                       |
| `~/.zshenv`   | ✅                | ✅                    | ✅                       |
| `~/.zprofile` | ✅                | ❌                    | ❌                       |
| `~/.zshrc`    | ✅                | ✅                    | ❌                       |
| `~/.zlogin`   | ✅                | ❌                    | ❌                       |
