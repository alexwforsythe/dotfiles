# chezmoi

Tool used to manage deployment of user dotfiles and external packages.

- [Guide](https://www.chezmoi.io/user-guide/command-overview/)
- [Reference](https://www.chezmoi.io/reference/)

## Directory structure

- `.chezmoiroot`: specifies the source dir of dotfiles to deploy to `$HOME` (i.e. src/)
- `src/`: contains all user dotfiles to deploy and represents desired state of `$HOME` directory
  - `.chezmoiexternals`: contains toml files describing external dependencies, mostly from Github
    - [Guide](https://www.chezmoi.io/user-guide/include-files-from-elsewhere)
    - [Reference](https://www.chezmoi.io/reference/special-files/chezmoiexternal-format)
  - `dot_config`: represents `$XDG_CONFIG_HOME`
  - `dot_local`: represents `$XDG_DATA_HOME`
