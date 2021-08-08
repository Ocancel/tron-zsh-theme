THEME="Normal"

# Color shortcuts
R=$fg_no_bold[red]
G=$fg_no_bold[green]
M=$fg_no_bold[magenta]
Y=$fg_no_bold[yellow]
B=$fg_no_bold[blue]
C=$fg_no_bold[cyan]
U=$fg_no_bold[white]
D=$fg_no_bold[black]
RESET=$reset_color

if [ "$THEME" = "Normal" ]; then
    SEPARATOR="%{$R%}%B:"
    PROMPTROOTNAME="%{$R%}%B%n$SEPARATOR"
    PROMPTUSERNAME="%{$C%}%B%n$SEPARATOR"
    PROMPTHOSTNAME="%{$U%}%B%m"
    PROMPTPATH="%{$Y%}%B %2~"
    PROMPTTODO="%{$U%}%B $"
    PROMPTTIME="%{$U%}%B%*"
    PROMPTLINE="%{$U%}%B%I$SEPARATOR"
    PROMPTRECORD="%{$Y%}%B!%!$SEPARATOR"
    PROMPTSTATUS="%{$R%}%B‡%?‡ "
    GITPREFIX=" %{$R%}%B["
    GITSUFFIX="%{$R%}%B]"
    GITHEADS="%{$B%}%B"
    GITSHABEFORE="%{$U%}%U"
    GTISHAAFTER="%u"
    GITPARTITION="%{$U%}%B▸"
    GITTIMEBEFORE="%U"
    GITTIMEAFTER="%u"

elif [ "$THEME" = "Background" ]; then
    PROMPTROOTNAME="%K{red}%{$C%}%B %n %k"
    PROMPTUSERNAME="%K{cyan}%{$R%}%B %n %k"
    PROMPTHOSTNAME="%K{white}%{$D%} %m %k"
    PROMPTPATH="%K{yellow}%{$D%}%B %2~ %k"
    PROMPTTODO="%K{white}%{$R%} $ %k"
    PROMPTTIME="%K{white}%{$D%} %* %k"
    PROMPTLINE="%K{green}%{$D%} %I %k"
    PROMPTRECORD="%K{yellow}%{$D%} !%! %k"
    PROMPTSTATUS="%K{black}%{$R%} ‡%?‡ %k"
    GITPREFIX="%K{blue} "
    GITSUFFIX=" %k"
    GITHEADS="%{$Y%}%B"
    GITSHABEFORE="%{$Y%}%U"
    GTISHAAFTER="%u"
    GITPARTITION="%{$U%}%B•"
    GITTIMEBEFORE="%K{white} %U"
    GITTIMEAFTER="%u %k"

    
fi

custom_git_prompt_status() {
    INDEX=$(git status --porcelain 2> /dev/null)
    STATUS=""
    # Non-staged
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^.M ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi
    # Staged
    if $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_RENAMED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^M' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_ADDED$STATUS"
    fi

    if $(echo -n "$STATUS" | grep '.*' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_STATUS_PREFIX$STATUS"
    fi

    echo $STATUS
}


ZSH_THEME_GIT_PROMPT_PREFIX="$GITPREFIX"
ZSH_THEME_GIT_PROMPT_SUFFIX="$GITSUFFIX"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$R%} ●"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$G%} ●"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$Y%} ●"
ZSH_THEME_GIT_STATUS_PREFIX=""

# Staged
ZSH_THEME_GIT_PROMPT_STAGED_ADDED="%{$U%} ●%{$G%}●"
ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED="%{$U%} ●%{$Y%}●"
ZSH_THEME_GIT_PROMPT_STAGED_RENAMED="%{$U%} ●%{$C%}●"
ZSH_THEME_GIT_PROMPT_STAGED_DELETED="%{$U%} ●%{$R%}●"

# Not-staged
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$U%} ○%{$U%}●"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$U%} ○%{$Y%}●"
ZSH_THEME_GIT_PROMPT_DELETED="%{$U%} ○%{$R%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$U%} ○%{$C%}●"

function custom_git_prompt() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  GIT_SHORT_SHA="$GITSHABEFORE$(git_prompt_short_sha)$GTISHAAFTER$GITPARTITION"
  GIT_REF="$GITHEADS${ref#refs/heads/}"
  GIT_STATUS_ALL="$GIT_SHORT_SHA$GIT_REF$(parse_git_dirty)$(git_prompt_ahead)$(custom_git_prompt_status)"
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$GIT_STATUS_ALL$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$G%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$Y%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$R%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$C%}"

function git_time_since_commit() {
    local COLOR MINUTES HOURS DAYS SUB_HOURS SUB_MINUTES
    local last_commit seconds_since_last_commit

    if ! last_commit=$(command git log --pretty=format:'%at' -1 2>/dev/null); then
        # echo "[$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL~%{$reset_color%}]"
        return
    fi

    seconds_since_last_commit=$(( EPOCHSECONDS - last_commit ))
    MINUTES=$(( seconds_since_last_commit / 60 ))
    HOURS=$(( MINUTES / 60 ))

    DAYS=$(( HOURS / 24 ))
    SUB_HOURS=$(( HOURS % 24 ))
    SUB_MINUTES=$(( MINUTES % 60 ))

    if [[ -z "$(command git status -s 2>/dev/null)" ]]; then
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
    else
        if [[ "$MINUTES" -gt 30 ]]; then
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
        elif [[ "$MINUTES" -gt 10 ]]; then
            COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
        fi
    fi

    if [ "$USER" = "root" ]; then
        return
    else
        if [[ "$HOURS" -gt 24 ]]; then
            echo "$GITTIMEBEFORE${COLOR}${DAYS}d${SUB_HOURS}H${SUB_MINUTES}m$GITTIMEAFTER$SEPARATOR"
        elif [[ "$MINUTES" -gt 60 ]]; then
            echo "$GITTIMEBEFORE${COLOR}${HOURS}H${SUB_MINUTES}m$GITTIMEAFTER$SEPARATOR"
        else
            echo "$GITTIMEBEFORE${COLOR}${MINUTES}m$GITTIMEAFTER$SEPARATOR"
        fi
    fi
    
}

if [ "$USER" = "root" ]; then
    PROMPTPREFIX="$PROMPTROOTNAME$PROMPTHOSTNAME";
else
    PROMPTPREFIX="$PROMPTUSERNAME$PROMPTHOSTNAME";
fi

PROMPT='$PROMPTPREFIX$PROMPTPATH$(custom_git_prompt)$PROMPTTODO%{$RESET%} '
RPROMPT='%(?..$PROMPTSTATUS%{$RESET%})$(git_time_since_commit)$PROMPTTIME'