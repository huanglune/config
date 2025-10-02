# .config


Personal dotfiles repository

copy dotfiles to home dir
```bash
cp -r .* ~/
```

## bash shells 

### proxy.sh
Proxy management script

```bash
source proxy.sh set [URL]    # Set proxy
source proxy.sh unset         # Unset proxy
bash proxy.sh show            # Show current proxy status
```

### install_omz.sh
Oh My Zsh installation script, includes:
- Oh My Zsh installation
- Powerlevel10k theme installation
- Plugin installation (git, jsontools, z, sudo, zsh-autosuggestions, zsh-syntax-highlighting,you-should-use)
- Change default shell to zsh

## dotfiles

### .vimrc
Vim editor configuration file, includes:
- Syntax highlighting
- Line numbers (absolute + relative)
- Search optimization (smart case, incremental search)
- Mouse support
- CtrlP plugin integration

### .tmux.conf
Tmux terminal multiplexer configuration with vi mode key bindings

### .gitconfig
Git global configuration file, includes:
- User information
- Performance optimizations (for large repositories)
- Safe directory configuration

### .config/uv/uv.toml
uv config
Modify to mirror source `https://mirrors.sustech.edu.cn/pypi/web/simple`
