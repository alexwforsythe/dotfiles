# zsh

Startup file load order:

| File          | Interactive Login | Interactive Non-Login | Non-Interactive (Script) |
| ------------- | ----------------- | --------------------- | ------------------------ |
| `/etc/zshenv` | ✅                | ✅                    | ✅                       |
| `~/.zshenv`   | ✅                | ✅                    | ✅                       |
| `~/.zprofile` | ✅                | ❌                    | ❌                       |
| `~/.zshrc`    | ✅                | ✅                    | ❌                       |
| `~/.zlogin`   | ✅                | ❌                    | ❌                       |

## Profiling

Print total startup time:

```sh
time zsh -i -c exit
```

Profile startup time:

```sh
ZPROF_ENABLE=1 zsh -i -c exit
```

Print every file that zsh sources:

```sh
zsh -i --sourcetrace -c exit
```
