# Set up $PATH with .local/bin and .fzf/bin directories
# Ensures binaries in these directories are accessible globally
export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$PATH"

# Check if zoxide is installed; if not, install it
# zoxide is a smarter `cd` command, allowing quick directory navigation
if ! command -v zoxide &> /dev/null; then
    echo "zoxide not found, installing..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Check if Starship prompt is installed; if not, install it
# Starship is a customizable, minimal, and fast prompt for any shell
if ! command -v starship &> /dev/null; then
    echo "starship not found, installing..."
    curl -sS https://starship.rs/install.sh | sh
fi

# Check if fzf (fuzzy finder) is installed; if not, clone and install it
# fzf is a general-purpose command-line fuzzy finder
if [ ! -d "$HOME/.fzf" ]; then
    echo "fzf not found, installing..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all  # Installs fzf with all optional features enabled
fi

# Ensure fzf shell configuration is sourced if the file exists
# This enables fzf-related keybindings and functions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set the directory to store zinit and plugins
# Zinit is a plugin manager for zsh, allowing us to load various plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Check if zinit is installed; if not, clone it to the specified directory
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"  # Create parent directory if necessary
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit to enable plugin management
source "${ZINIT_HOME}/zinit.zsh"

# Load zsh plugins with zinit
# Each plugin adds specific functionality to zsh, like syntax highlighting and autocompletion
zinit light zsh-users/zsh-syntax-highlighting       # Adds syntax highlighting for zsh commands
zinit light zsh-users/zsh-completions               # Provides additional command-line completions
zinit light zsh-users/zsh-autosuggestions           # Suggests commands based on history as you type
zinit light Aloxaf/fzf-tab                          # Integrates fzf with tab completion

# Load additional zsh snippets with zinit
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git               # Provides useful git aliases and functions
zinit snippet OMZP::sudo              # Allows easy re-execution of last command with sudo
zinit snippet OMZP::command-not-found # Suggests installation of missing commands

# Load zsh completion system
# Provides advanced autocompletion capabilities for commands
autoload -Uz compinit && compinit

# Enable zinit's command replay to remember plugin history
zinit cdreplay -q

# Initialize Starship prompt to customize shell prompt appearance
eval "$(starship init zsh)"

# Keybindings for easier navigation and command editing
# Adjusts certain keys to enhance command history search and editing
bindkey -e                             # Sets Emacs keybindings mode
bindkey '^p' history-search-backward   # Binds Ctrl+p to search history backward
bindkey '^n' history-search-forward    # Binds Ctrl+n to search history forward
bindkey '^[w' kill-region              # Binds Alt+w to cut selected text

# History settings to manage zsh command history behavior
HISTSIZE=5000                          # Number of lines to keep in memory
HISTFILE=~/.zsh_history                # File to store history across sessions
SAVEHIST=$HISTSIZE                     # Ensures file keeps as many lines as in-memory history
HISTDUP=erase                          # Removes duplicates from history
setopt appendhistory                   # Appends commands to history file rather than overwriting
setopt sharehistory                    # Shares history across multiple sessions
setopt hist_ignore_space               # Ignores commands starting with a space in history
setopt hist_ignore_all_dups            # Removes all duplicate entries from history
setopt hist_save_no_dups               # Prevents duplicate entries when saving history
setopt hist_ignore_dups                # Ignores duplicates from adjacent commands in history
setopt hist_find_no_dups               # Prevents duplicates in history search results

# Completion styling and behavior
# Configures zsh autocompletion appearance and matching behavior
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'      # Case-insensitive matching for autocompletion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Uses LS_COLORS for completion listing colors
zstyle ':completion:*' menu no                              # Disables menu-based completion
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'    # Shows preview for cd completions
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' # Preview for zoxide completions

# Aliases for commonly used commands
alias ls='ls --color'                   # Adds color to 'ls' command output
alias c='clear'                         # Shortcut to clear terminal screen

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"      # Initializes zoxide to enhance `cd` command functionality
