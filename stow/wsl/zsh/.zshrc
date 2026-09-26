export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

export COREPACK_HOME="$HOME/.cache/node/corepack"
FNM_PATH="$HOME/.local/share/fnm"
if [[ -x "$FNM_PATH/fnm" ]]; then
  export PATH="$FNM_PATH:$PATH"
  runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  if ! mkdir -p "$runtime_dir" 2>/dev/null || ! { : > "$runtime_dir/.fnm-write-test"; } 2>/dev/null; then
    export XDG_RUNTIME_DIR="/tmp/user-$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
  else
    rm -f "$runtime_dir/.fnm-write-test"
  fi
  unset runtime_dir
  eval "$(fnm env --shell zsh)"
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
export CUSTOM_PATTERNS_DIRECTORY="$HOME/.config/fabric/custom-patterns"
alias fabric='fabric-ai'

_tmux_project_dir() { git rev-parse --show-toplevel 2>/dev/null || pwd; }
_tmux_project_session_name() {
  local project_dir="$(_tmux_project_dir)"
  print -r -- "${${project_dir:t}//[^[:alnum:]_.-]/_}"
}
t() {
  local project_dir="$(_tmux_project_dir)" session_name="$(_tmux_project_session_name)"
  if [[ -n "$TMUX" ]]; then
    tmux has-session -t "$session_name" 2>/dev/null || tmux new-session -d -s "$session_name" -c "$project_dir"
    tmux switch-client -t "$session_name"
  else
    tmux new-session -A -s "$session_name" -c "$project_dir"
  fi
}
ta() {
  local session_name
  session_name="$(tmux list-sessions -F '#S' 2>/dev/null | fzf --prompt='tmux session> ')" || return
  [[ -z "$session_name" ]] && return
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}
tl() { tmux list-sessions; }
tk() {
  local session_name
  session_name="$(tmux list-sessions -F '#S' 2>/dev/null | fzf --prompt='kill tmux session> ')" || return
  [[ -n "$session_name" ]] && tmux kill-session -t "$session_name"
}
