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

#vi style cli
set -o vi

# Beanshell
function beanshell {
        java bsh.Interpreter
}


SSH_COMPLETE=( $(cat ~/.ssh/known_hosts | \
                 cut -f 1 -d ' ' | \
                 sed -e s/,.*//g | \
                 uniq \
                 # | egrep -v [0123456789]
                 ) )
complete -o default -W "${SSH_COMPLETE[*]}" ssh

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

source ~/bashdefaults/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWSTASHSTATE=true

PS1='\h:\W$(__git_ps1 " (%s)") \u$ '

MAVEN_OPTS="-Xmx768m -Xms768m -XX:MaxPermSize=256m -Dansi.color -Xdebug -Xrunjdwp:transport=dt_socket,address=1045,server=y,suspend=n" 
export MAVEN_OPTS
export TMP=/tmp/
export JAVA_HOME=`/usr/libexec/java_home`
export JRE_HOME=`/usr/libexec/java_home`


function pomgrep {
    find . -name pom.xml | xargs grep $@
}
