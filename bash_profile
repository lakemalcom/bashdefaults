#to install, add to ~/.bash_profile:
#todo: make an install.sh
#if [ -f $HOME/bashdefaults/bash_profile ]; then
#  . $HOME/bashdefaults/bash_profile
#  fi

export VISUAL=vi
export EDITOR=vi
export HISTSIZE=50000

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#aliases
alias la='ls -lA'
alias l='ls -l'
alias grep='grep --color=auto'
alias upvim='vim -u ~/.vim/vundle.vim +BundleInstall! +q'

#vi style cli
set -o vi

# Beanshell
function beanshell {
        java bsh.Interpreter
}

function tabname {
      printf "\e]1;$1\a"
}
export -f tabname

function winname {
      printf "\e]2;$1\a"
}
export -f winname



SSH_COMPLETE=( $(cat ~/.ssh/known_hosts | \
                 cut -f 1 -d ' ' | \
                 sed -e s/,.*//g | \
                 uniq \
                 # | egrep -v [0123456789]
                 ) )
complete -o default -W "${SSH_COMPLETE[*]}" ssh

#if [ -f /opt/local/etc/bash_completion ]; then
    #. /opt/local/etc/bash_completion
#fi

source ~/bashdefaults/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWSTASHSTATE=true

PS1='\D{%F %T} \h:\W$(__git_ps1 " (%s)") \u$ '
export MYSQL_PS1="\D \u@\h [\d]> "

MAVEN_OPTS="-Xmx2048m -Xms1024m"
# -Dansi.color -Xdebug -Xrunjdwp:transport=dt_socket,address=1045,server=y,suspend=n" 
export MAVEN_OPTS
export TMP=/tmp/
#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
#export JRE_HOME=`/usr/libexec/java_home -v 1.8`
#export JAVA_OPTS='-Xmx1024m -Xms512m -XX:MaxPermSize=512m'

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
#export JAVA_12_HOME=$(/usr/libexec/java_home -v12)
 
alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'
#alias java12='export JAVA_HOME=$JAVA_12_HOME'
export JAVA_HOME=$JAVA_11_HOME
 
# default to Java 8

export PATH=$(brew --prefix ruby)/bin:$PATH


function pomgrep {
    find . -name pom.xml | xargs ag -B 3 -A 3 $@
}
PATH=$PATH:~/aau/academyart:~/dev-scripts
AAU_WORKSPACE=/Users/luke_mccollum/Documents/42-workspace-july-2014
LESS="-SRXF"


# Cool FZF Shit

#export FZF_COMPLETION_TRIGGER='kk'

fzf-down() {
  fzf --height 50% "$@" --border
}

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

prevw() {
  git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -$LINES
}

export -f prevw

gb_c() {
  is_in_git_repo || return
  _fzf_complete '--height 50% --ansi --multi --tac --preview-window right:70%  --preview "prevw"' "$@"  < <(
      git branch -a --color=always | grep -v '/HEAD\s' | sort
      )
}

#_fzf_complete_git() {
#    ARGS="$@"
#    local branches
#    branches=$(git branch -vv --all)
#    if [[ $3 = 'co' ]]; then
#        gb_c
#    else
#         _fzf_path_completion "$@"
#    fi
#}
#
#
#_fzf_complete_git_post() {
#    printf "$@\n"
#    printf 'git co '
#    awk '{print $1}'
#}

#[ -n "$BASH" ] && complete -F _fzf_complete_git -o default -o bashdefault git


# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
#bind '"\C-i\C-i": "$(gb)\e\C-e\er"'
bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-r": "$(gr)\e\C-e\er"'


alias gco='git co $(gb)'
alias gm='git merge $(gb)'

alias dm='docker-mysql.py'

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

source ~/bashdefaults/bin/activate
