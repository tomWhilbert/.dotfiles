#* Declare some path variables
DOTS=$HOME/.dotfiles
PLUGINS=$HOME/bin/plugins
OMZ=$PLUGINS/ohmyzsh
ZDOTDIR=$DOTS

#* Add to PATH
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="$HOME/bin/scripts/:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/lsof/bin:$PATH"
# Created by `pipx` on 2024-04-09 15:09:26
export PATH="$PATH:/Users/tom/.local/bin"

#* Environment Variables
export RCLONE_PASSWORD_COMMAND="security find-generic-password -a $USER -s rclone -w"
export BAT_THEME="gruvbox-dark"
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications caskroom=$HOME/Applications"

#* Golang environment variables
export GOROOT=/opt/homebrew/bin/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH:

# #* brew zsh completions init
 if type brew &>/dev/null
 then
  #  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
   FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
   autoload -Uz compinit
   compinit
 fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile    
HISTSIZE=50000
SAVEHIST=50000
setopt autocd beep extendedglob nomatch notify inc_append_history_time sharehistory
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
bindkey -e #* use emacs mode

#* Bindkey for line word jump
#* Tab Autocomplete

bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word

bindkey '^[^[[A' history-substring-search-up
bindkey '^[^[[B' history-substring-search-down

# #* Pyenv Config (put before ohmyzsh plugin to avoid error)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Source paths for zsh plugins
source $OMZ/lib/directories.zsh #* enables 'd' directory stack
source $OMZ/plugins/z/z.plugin.zsh
source $PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh

#* load ssh keys into the macOS ssh agent using passphrase from keychain
ssh-add --apple-load-keychain 2> /dev/null  

#* Source aliases and functions
source $DOTS/.zshrc_aliases
source $DOTS/.zshrc_functions

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tom/.lmstudio/bin"

export STARSHIP_CONFIG=/Users/tom/.config/starship/starship.toml
eval "$(starship init zsh)"



