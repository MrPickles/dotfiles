prompt_setup_pickles() {
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}○%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}⚡%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"

  if [ $UID -eq 0 ]; then
    NCOLOR="red";
  else
    NCOLOR="green";
  fi

  POSTCOLOR="green"
  if [[ -n $SSH_CONNECTION ]]; then
    name_prompt='%{$fg[$NCOLOR]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:'
    POSTCOLOR="red"
  fi

  dir_prompt='%{$fg[magenta]%}%~'
  base_prompt=$name_prompt$dir_prompt
  post_prompt='%{$fg[$POSTCOLOR]%}%(!.#.»)%{$reset_color%} '

  base_prompt_nocolor=$(echo "$base_prompt" | perl -pe "s/%\{[^}]+\}//g")
  post_prompt_nocolor=$(echo "$post_prompt" | perl -pe "s/%\{[^}]+\}//g")

  precmd_functions+=(prompt_pickles_precmd)
}

prompt_pickles_precmd() {
  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=$(echo "$gitinfo" | perl -pe "s/%\{[^}]+\}//g")
  local exp_nocolor="$(print -P \"$base_prompt_nocolor$gitinfo_nocolor$post_prompt_nocolor\")"
  local prompt_length=${#exp_nocolor}

  local nl=" "
  if [[ $prompt_length -gt 60 ]]; then
    nl=$'\n%{\r%}';
  fi

  PROMPT="$base_prompt$gitinfo$nl$post_prompt"
}

prompt_setup_pickles
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

