# Powerlevel10k config (classic). Tokyo Night palettes + custom git/jj segments.
# `p10k configure` will overwrite this file; re-apply those customizations after.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # Tokyo Night Storm named palette from
  # https://github.com/folke/tokyonight.nvim/blob/5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd/extras/lua/tokyonight_storm.lua
  typeset -gA TOKYONIGHT_STORM=(
    [bg]='#24283b'
    [bg_dark]='#1f2335'
    [bg_highlight]='#292e42'
    [fg]='#c0caf5'
    [fg_dark]='#a9b1d6'
    [fg_gutter]='#3b4261'
    [comment]='#565f89'
    [dark3]='#545c7e'
    [dark5]='#737aa2'
    [blue]='#7aa2f7'
    [blue1]='#2ac3de'
    [cyan]='#7dcfff'
    [green]='#9ece6a'
    [green1]='#73daca'
    [teal]='#1abc9c'
    [yellow]='#e0af68'
    [orange]='#ff9e64'
    [red]='#f7768e'
    [red1]='#db4b4b'
    [magenta]='#bb9af7'
    [purple]='#9d7cd8'
    [black]='#1d202f'
    [terminal_black]='#414868'
  )

  # Tokyo Night Day named palette from
  # https://github.com/folke/tokyonight.nvim/blob/5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd/extras/lua/tokyonight_day.lua
  typeset -gA TOKYONIGHT_DAY=(
    [bg]='#e1e2e7'
    [bg_dark]='#d0d5e3'
    [bg_highlight]='#c4c8da'
    [fg]='#3760bf'
    [fg_dark]='#6172b0'
    [fg_gutter]='#a8aecb'
    [comment]='#848cb5'
    [dark3]='#8990b3'
    [dark5]='#68709a'
    [blue]='#2e7de9'
    [blue1]='#188092'
    [cyan]='#007197'
    [green]='#587539'
    [green1]='#387068'
    [teal]='#118c74'
    [yellow]='#8c6c3e'
    [orange]='#b15c00'
    [red]='#f52a65'
    [red1]='#c64343'
    [magenta]='#9854f1'
    [purple]='#7847bd'
    [black]='#b4b5b9'
    [terminal_black]='#a1a6c5'
  )

  typeset -gA TOKYONIGHT
  if [[ ${DOTFILES_TOKYONIGHT_STYLE:-storm} == day ]]; then
    TOKYONIGHT=("${(@kv)TOKYONIGHT_DAY}")
  else
    TOKYONIGHT=("${(@kv)TOKYONIGHT_STORM}")
  fi

  # The list of segments shown on the left. Fill it with the most important segments.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    os_icon                 # os identifier
    context                 # user@hostname
    vcs                     # git status
    jj                      # jj status
    dir                     # current directory
    # =========================[ Line #2 ]=========================
    newline                 # \n
  )

  # The list of segments shown on the right. Fill it with less important segments.
  # Right prompt on the last prompt line (where you are typing your commands) gets
  # automatically hidden when the input line reaches it. Right prompt above the
  # last prompt line gets hidden if it would overlap with left prompt.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    terraform               # terraform workspace (https://www.terraform.io)
    vi_mode                 # vi mode
    time                    # current time
    # =========================[ Line #2 ]=========================
    newline                 # \n
  )

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{${TOKYONIGHT[comment]}}╭─"
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%F{${TOKYONIGHT[comment]}}├─"
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{${TOKYONIGHT[comment]}}╰─"
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX="%F{${TOKYONIGHT[comment]}}─╮"
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX="%F{${TOKYONIGHT[comment]}}─┤"
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX="%F{${TOKYONIGHT[comment]}}─╯"

  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='·'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND="${TOKYONIGHT[comment]}"
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi

  typeset -g POWERLEVEL9K_BACKGROUND="${TOKYONIGHT[bg_highlight]}"

  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{${TOKYONIGHT[dark5]}}"'\uE0B1'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{${TOKYONIGHT[dark5]}}"'\uE0B3'
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  #################################[ os_icon: os identifier ]##################################
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="${TOKYONIGHT[fg]}"

  ##################################[ dir: current directory ]##################################
  typeset -g POWERLEVEL9K_DIR_FOREGROUND="${TOKYONIGHT[blue]}"
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND="${TOKYONIGHT[dark5]}"
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND="${TOKYONIGHT[blue1]}"
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  local anchor_files=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .go-version
    .ruby-version
    .lua-version
    .java-version
    .perl-version
    .php-version
    .tool-version
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
    stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  #####################################[ vcs: git status ]######################################
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '

  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
      # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    if (( $1 )); then
      # Styling for up-to-date Git status.
      local       meta="%F{${TOKYONIGHT[comment]}}"  # grey foreground
      local      clean="%F{${TOKYONIGHT[green]}}"   # green foreground
      local   modified="%F{${TOKYONIGHT[yellow]}}"  # yellow foreground
      local  untracked="%F{${TOKYONIGHT[blue1]}}"   # blue foreground
      local conflicted="%F{${TOKYONIGHT[red]}}"  # red foreground
    else
      # Styling for incomplete and stale Git status.
      local       meta="%F{${TOKYONIGHT[dark5]}}"  # grey foreground
      local      clean="%F{${TOKYONIGHT[dark5]}}"  # grey foreground
      local   modified="%F{${TOKYONIGHT[dark5]}}"  # grey foreground
      local  untracked="%F{${TOKYONIGHT[dark5]}}"  # grey foreground
      local conflicted="%F{${TOKYONIGHT[dark5]}}"  # grey foreground
    fi

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      # If local branch name is at most 32 characters long, show it in full.
      # Otherwise show the first 12 … the last 12.
      (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG
          # Show tag only if not on a branch.
          && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
        ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      # If tag name is at most 32 characters long, show it in full.
      # Otherwise show the first 12 … the last 12.
      (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    # Display the current Git commit if there is no branch and no tag.
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    # Show tracking branch name if it differs from local branch.
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    # Display "wip" if the latest commit's summary contains "wip" or "WIP".
    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    # ⇣42 if behind the remote.
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    # ⇠42 if behind the push remote.
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    # 'merge' if the repo is in an unusual state.
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    # ~42 if have merge conflicts.
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    # +42 if have staged changes.
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    # !42 if have unstaged changes.
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    # ?42 if have untracked files. It's really a question mark, your font isn't broken.
    # Remove the next line if you don't want to see untracked files at all.
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    # "─" if the number of unstaged files is unknown. This can happen due to
    # than the number of files in the Git index, or due to bash.showDirtyState being set to false
    # in the repository config. The number of staged and untracked files may also be unknown
    # in this case.
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  # jj prompt table of contents:
  # jj_add     | add changes to jj for this prompt   | (no output)
  # jj_at      | bookmark name and distance from @   | main›1
  # jj_remote  | count changes ahead/behind remote   | 2⇡1⇣
  # jj_change  | the current jj change ID            | kkor
  # jj_desc    | current change description          | first line of description (or  )
  # jj_status  | counts of added, removed, modified  | +1 -4 ^2
  # jj_op      | the current jj operation ID         | b44825e56a5a

  # Additional workspaces store a relative path in .jj/repo instead of a directory.
  function .dotfiles_jj_repo_dir() {
    emulate -L zsh
    local repo=$1/.jj/repo
    if [[ -d $repo ]]; then
      print -r -- $repo
      return 0
    fi
    [[ -f $repo ]] || return 1
    local target
    # Pointer file often has no trailing newline; `read` then returns 1.
    IFS= read -r target < $repo
    [[ -n $target ]] || return 1
    [[ $target == /* ]] || target=${repo:A:h}/$target
    print -r -- ${target:A}
  }

  function .dotfiles_jj_op_head() {
    emulate -L zsh
    local repo heads
    repo=$(.dotfiles_jj_repo_dir $1) || return
    heads=$repo/op_heads/heads
    [[ -d $heads ]] && print -r -- $heads/*(N:t)
  }

  typeset -gA p10k_jj_skip_snapshot
  typeset -g p10k_jj_query_key p10k_jj_pending_root

  function jj_status_query() {
    emulate -L zsh
    # $1 = workspace root, $2 = 1 if Watchman snapshots this workspace,
    # $3 = op head from the previous successful query (may be empty).
    cd "$1"
    if (( ! $2 )); then
      jj util snapshot >/dev/null 2>&1
    fi

    local op_head
    op_head=$(.dotfiles_jj_op_head $1)
    if [[ -n $3 && $op_head == $3 ]]; then
      print -r -- __P10K_JJ_UNCHANGED__
      return 0
    fi

    ## jj_at
    local branch=$(jj --ignore-working-copy --at-op=@ --no-pager log --no-graph --limit 1 -r "
      coalesce(
        heads(::@ & (bookmarks() | remote_bookmarks() | tags())),
        heads(@:: & (bookmarks() | remote_bookmarks() | tags())),
        trunk()
      )" -T "separate(' ', bookmarks, tags)" 2> /dev/null | cut -d ' ' -f 1)
    if [[ -n $branch ]]; then
      [[ $branch =~ "\*$" ]] && branch=${branch::-1}

      local JJ_STATUS_COMMITS_AFTER=$(jj --ignore-working-copy --at-op=@ --no-pager log --no-graph -r "$branch..@ & (~empty() | merges())" -T '"n"' 2> /dev/null | wc -c | tr -d ' ')
      local JJ_STATUS_COMMITS_BEFORE=$(jj --ignore-working-copy --at-op=@ --no-pager log --no-graph -r "@..$branch & (~empty() | merges())" -T '"n"' 2> /dev/null | wc -c | tr -d ' ')

      ## jj_remote
      local counts=($(jj --ignore-working-copy --at-op=@ --no-pager bookmark list -r $branch -T '
        if(remote,
          separate(" ",
            name ++ "@" ++ remote,
            coalesce(tracking_ahead_count.exact(), tracking_ahead_count.lower()),
            coalesce(tracking_behind_count.exact(), tracking_behind_count.lower()),
            if(tracking_ahead_count.exact(), "0", "+"),
            if(tracking_behind_count.exact(), "0", "+"),
          ) ++ "\n"
        )
      '))
      local JJ_STATUS_LOCAL_BRANCH=$branch
      local JJ_STATUS_COMMITS_AHEAD=$counts[2]
      local JJ_STATUS_COMMITS_BEHIND=$counts[3]
      local JJ_STATUS_COMMITS_AHEAD_PLUS=$counts[4]
      local JJ_STATUS_COMMITS_BEHIND_PLUS=$counts[5]
    fi

    ## jj_change + jj_desc + jj_status (one `jj log -r @`)
    local raw
    local -a at_info
    raw=$(
      jj --ignore-working-copy --at-op=@ --no-pager log --no-graph --limit 1 -r @ -T '
        concat(
          change_id.shortest(4).prefix() ++ "#" ++ coalesce(change_id.shortest(4).rest(), "") ++ "\n",
          commit_id.shortest(4).prefix() ++ "#" ++ coalesce(commit_id.shortest(4).rest(), "") ++ "\n",
          concat(
            if(conflict, "💥"),
            if(divergent, "🚧"),
            if(hidden, "👻"),
            if(immutable, "🔒"),
          ) ++ "\n",
          coalesce(description.first_line(), "") ++ "\n",
          diff.summary(),
        )' 2>/dev/null
    )
    at_info=("${(@f)raw}")
    local -a JJ_STATUS_CHANGE=(${(s:#:)at_info[1]})
    local -a JJ_STATUS_COMMIT=(${(s:#:)at_info[2]})
    local JJ_STATUS_ACTION=$at_info[3]
    local JJ_STATUS_MESSAGE=$at_info[4]
    local -a JJ_STATUS_CHANGES=(0 0 0 0 0)
    local line
    for line in ${at_info[5,-1]}; do
      case $line in
        'A '*) (( JJ_STATUS_CHANGES[1]++ ));;
        'D '*) (( JJ_STATUS_CHANGES[2]++ ));;
        'M '*) (( JJ_STATUS_CHANGES[3]++ ));;
        'R '*) (( JJ_STATUS_CHANGES[4]++ ));;
        'C '*) (( JJ_STATUS_CHANGES[5]++ ));;
      esac
    done

    # Run the JJ status formatter twice. Once normally and the second time to get the greyed-out version.
    jj_status_formatter 1
    jj_status_formatter
  }

  function jj_status_formatter() {
    if (( $1 )); then
      local grey="%F{${TOKYONIGHT[comment]}}"
      local green="%F{${TOKYONIGHT[green]}}"
      local blue="%F{${TOKYONIGHT[blue1]}}"
      local red="%F{${TOKYONIGHT[red]}}"
      local yellow="%F{${TOKYONIGHT[yellow]}}"
      local cyan="%F{${TOKYONIGHT[cyan]}}"
      local magenta="%F{${TOKYONIGHT[magenta]}}"
    else
      # Make all the colors grey to represent the stale segment.
      local grey="%F{${TOKYONIGHT[dark5]}}"
      local green="%F{${TOKYONIGHT[dark5]}}"
      local blue="%F{${TOKYONIGHT[dark5]}}"
      local red="%F{${TOKYONIGHT[dark5]}}"
      local yellow="%F{${TOKYONIGHT[dark5]}}"
      local cyan="%F{${TOKYONIGHT[dark5]}}"
      local magenta="%F{${TOKYONIGHT[dark5]}}"
    fi

    local res="${green}"

    ## jj_at
    local status_color=${green}
    (( JJ_STATUS_COMMITS_AHEAD )) && status_color=${cyan}
    (( JJ_STATUS_COMMITS_BEHIND )) && status_color=${magenta}
    (( JJ_STATUS_COMMITS_AHEAD && JJ_STATUS_COMMITS_BEHIND )) && status_color=${red}

    local where=${(V)JJ_STATUS_LOCAL_BRANCH}
    # If local branch name or tag is at most 32 characters long, show it in full.
    # Otherwise show the first 12 … the last 12.
    (( $#where > 32 )) && where[13,-13]="…"
    (( $#where > 0 )) && res+="${status_color} ${where//\%/%%}"

    # ‹42 if before the local bookmark
    (( JJ_STATUS_COMMITS_BEFORE )) && res+="‹${JJ_STATUS_COMMITS_BEFORE}"
    # ›42 if beyond the local bookmark
    (( JJ_STATUS_COMMITS_AFTER )) && res+="›${JJ_STATUS_COMMITS_AFTER}"

    ## jj_remote
    # ⇣42 if behind the remote.
    (( JJ_STATUS_COMMITS_BEHIND )) && res+=" ${green}⇣${JJ_STATUS_COMMITS_BEHIND}"
    (( JJ_STATUS_COMMITS_BEHIND_PLUS )) && res+="${JJ_STATUS_COMMITS_BEHIND_PLUS}"
    # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
    (( JJ_STATUS_COMMITS_AHEAD && !JJ_STATUS_COMMITS_BEHIND )) && res+=" "
    (( JJ_STATUS_COMMITS_AHEAD )) && res+="${green}⇡${JJ_STATUS_COMMITS_AHEAD}"
    (( JJ_STATUS_COMMITS_AHEAD_PLUS )) && res+="${JJ_STATUS_COMMITS_AHEAD_PLUS}"

    ## jj_change
    # 'zyxw' with the standard jj color coding for shortest name
    [[ -n $JJ_STATUS_CHANGE ]] && res+=" ${blue}${JJ_STATUS_CHANGE[1]}${grey}${JJ_STATUS_CHANGE[2]}"
    # '💥🚧👻🔒' if the repo is in an unusual state.
    [[ -n $JJ_STATUS_ACTION ]] && res+=" ${red}${JJ_STATUS_ACTION}"

    ## jj_desc
    # Show a symbol if the working copy has a message.
    [[ -n $JJ_STATUS_MESSAGE ]] && res+=" ${magenta}"
 
    ## jj_status
    (( JJ_STATUS_CHANGES[1] )) && res+=" ${green}+${JJ_STATUS_CHANGES[1]}"
    (( JJ_STATUS_CHANGES[2] )) && res+=" ${red}-${JJ_STATUS_CHANGES[2]}"
    (( JJ_STATUS_CHANGES[3] )) && res+=" ${yellow}±${JJ_STATUS_CHANGES[3]}"
    (( JJ_STATUS_CHANGES[4] )) && res+=" ${magenta}↻${JJ_STATUS_CHANGES[4]}"
    (( JJ_STATUS_CHANGES[5] )) && res+=" ${cyan}⧉${JJ_STATUS_CHANGES[5]}"

    echo $res
  }

  function jj_status_callback() {
    emulate -L zsh
    local p10k_jj_statuses=( ${(f)3} )

    if [[ $2 -ne 0 ]]; then
      typeset -g p10k_jj_status=
    elif [[ $p10k_jj_statuses[1] != __P10K_JJ_UNCHANGED__ ]]; then
      typeset -g p10k_jj_status="$p10k_jj_statuses[1]"
      typeset -g p10k_jj_status_greyed_out="$p10k_jj_statuses[2]"
    fi
    if [[ $2 -eq 0 && -n $p10k_jj_pending_root ]]; then
      typeset -g p10k_jj_query_key="${p10k_jj_pending_root}"$'\0'"$(.dotfiles_jj_op_head $p10k_jj_pending_root)"
    fi
    typeset -g p10k_jj_status_stale= p10k_jj_status_updated=1
    p10k display -r
  }

  async_start_worker        jj_status_worker -u
  async_unregister_callback jj_status_worker
  async_register_callback   jj_status_worker jj_status_callback

  function prompt_jj() {
    emulate -L zsh -o extended_glob

    # Default to showing normal VCS prompts, not JJ.
    p10k display "*/jj=hide"
    p10k display "*/vcs=show"

    # Walk for `.jj` instead of spawning `jj workspace root`.
    local dir=${PWD:A} jj_root git_root
    while true; do
      if [[ -d $dir/.jj ]]; then
        jj_root=$dir
        break
      fi
      [[ $dir == / ]] && return
      dir=${dir:h}
    done
    (( $+commands[jj] )) || return

    # Git submodule nested in a JJ workspace: prefer the git prompt.
    dir=${PWD:A}
    while true; do
      if [[ -e $dir/.git ]]; then
        git_root=$dir
        break
      fi
      [[ $dir == / ]] && break
      dir=${dir:h}
    done
    [[ -n $git_root && ${#jj_root} -lt ${#git_root} ]] && return

    if (( ! $+p10k_jj_skip_snapshot[$jj_root] )); then
      local skip_snap
      skip_snap=$(jj --ignore-working-copy -R $jj_root config get fsmonitor.watchman.register-snapshot-trigger 2>/dev/null) || skip_snap=false
      [[ $skip_snap == true ]] && p10k_jj_skip_snapshot[$jj_root]=1 || p10k_jj_skip_snapshot[$jj_root]=0
    fi

    local op_head key last_op=
    op_head=$(.dotfiles_jj_op_head $jj_root)
    key="${jj_root}"$'\0'"${op_head}"

    p10k display "*/jj=show"
    p10k display "*/vcs=hide"
    typeset -g p10k_jj_pending_root=$jj_root

    if [[ -n $p10k_jj_status && $p10k_jj_query_key == $key ]]; then
      typeset -g p10k_jj_status_stale= p10k_jj_status_updated=1
      p10k segment -c '$p10k_jj_status_updated' -e -t '$p10k_jj_status'
      # Watchman trigger: background snapshot already ran; nothing to do.
      (( p10k_jj_skip_snapshot[$jj_root] )) && return
      last_op=$op_head
    else
      typeset -g p10k_jj_status_stale=1 p10k_jj_status_updated=
      p10k segment -f "${TOKYONIGHT[comment]}" -c '$p10k_jj_status_stale' -e -t '$p10k_jj_status_greyed_out'
      p10k segment -c '$p10k_jj_status_updated' -e -t '$p10k_jj_status'
    fi
    async_job jj_status_worker jj_status_query $jj_root $p10k_jj_skip_snapshot[$jj_root] $last_op
  }

  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR="${TOKYONIGHT[green]}"
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR="${TOKYONIGHT[dark5]}"

  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # Powerlevel10k has to fall back to using vcs_info.
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND="${TOKYONIGHT[green]}"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="${TOKYONIGHT[green]}"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="${TOKYONIGHT[yellow]}"

  ##########################[ status: exit code of the last command ]###########################
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="${TOKYONIGHT[green]}"
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'

  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND="${TOKYONIGHT[green]}"
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'

  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="${TOKYONIGHT[red]}"
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND="${TOKYONIGHT[red]}"
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'

  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND="${TOKYONIGHT[red]}"
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'

  ###################[ command_execution_time: duration of the last command ]###################
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="${TOKYONIGHT[fg_dark]}"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  #######################[ background_jobs: presence of background jobs ]#######################
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="${TOKYONIGHT[teal]}"

  ######################################[ vi_mode: vi mode ]####################################
  typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING=NORMAL
  typeset -g POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND="${TOKYONIGHT[green]}"
  typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING=VISUAL
  typeset -g POWERLEVEL9K_VI_MODE_VISUAL_FOREGROUND="${TOKYONIGHT[blue]}"
  typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING=OVERTYPE
  typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_FOREGROUND="${TOKYONIGHT[orange]}"
  typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=
  typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND="${TOKYONIGHT[dark5]}"


  ##################################[ context: user@hostname ]##################################
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="${TOKYONIGHT[yellow]}"
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND="${TOKYONIGHT[fg_dark]}"
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND="${TOKYONIGHT[fg_dark]}"

  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'

  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  ###[ virtualenv: python virtual environment (https://docs.python.org/3/library/venv.html) ]###
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND="${TOKYONIGHT[teal]}"
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=


  ################[ terraform: terraform workspace (https://www.terraform.io) ]#################
  typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false
  typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
      '*'         OTHER)
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND="${TOKYONIGHT[blue1]}"

  #############[ kubecontext: current kubernetes context (https://kubernetes.io/) ]#############
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|skaffold|kubent|kubecolor'

  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
      '*'       DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND="${TOKYONIGHT[purple]}"

  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  ####################################[ time: current time ]####################################
  typeset -g POWERLEVEL9K_TIME_FOREGROUND="${TOKYONIGHT[dark5]}"
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%I:%M:%S %p}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  typeset -g POWERLEVEL9K_INSTANT_PROMPT=${DOTFILES_INSTANT_PROMPT:-verbose}

  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # If p10k is already loaded, reload configuration.
  (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
