# bash

Startup file load order:

| File                                      | Interactive Login | Interactive Non-Login | Non-Interactive (Script) |
| ----------------------------------------- | ----------------- | --------------------- | ------------------------ |
| `/etc/profile`                            | ✅                | ❌                    | ❌                       |
| `~/.{bash\_{profile,login},profile}` [^1] | ✅                | ❌                    | ❌                       |
| `/etc/bash.bashrc`                        | ❌                | ✅                    | ❌                       |
| `~/.bashrc`                               | ❌                | ✅                    | ❌                       |
| `$BASH_ENV`                               | ❌                | ❌                    | ✅                       |

[^1]: First match only
