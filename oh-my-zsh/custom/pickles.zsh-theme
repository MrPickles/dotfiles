prompt_setup_pickles() {
  # Set git prompts.
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}○%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}⚡%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"

  # Make username red if root.
  if [ $UID -eq 0 ]; then
    NCOLOR="red";
  else
    NCOLOR="green";
  fi

  # Set the user@hostname part. If the environment variable HUSH_LOCALHOST is
  # defined, this part will be ignored to non-SSH logins.
  name_prompt='%{$fg[$NCOLOR]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}%{$fg[red]%}:'
  if [[ -n $SSH_CONNECTION ]]; then
    name_prompt='%{$fg[yellow]%}[%{$fg[$NCOLOR]%}%n@%{$fg[cyan]%}%m%{$fg[yellow]%}]%{$fg[red]%}:'
  elif [[ -n $HUSH_LOCALHOST ]]; then
    name_prompt=' '
  fi

  # Combine the name part of the prompt with the directory part.
  dir_prompt='%{$fg[magenta]%}%~'
  base_prompt=$name_prompt$dir_prompt

  # Set the post prompt (the part after the git status).
  post_prompt='%{$fg[yellow]%}%(!.#.»)%{$reset_color%} '

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

