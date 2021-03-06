#!/usr/bin/env  zsh

: << IDEAS
  TODO - Check out http://dotfiles.org/~brendano/.zshrc
IDEAS


#:<<'}'  #  Variables
{
  # It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
  if [ $( \whoami ) = 'root' ];
    then  export  zshdir="$( \dirname $( \dirname $( \realpath  /home/user/.zshrc ) ) )"
    else  export  zshdir="$( \dirname $( \dirname $( \realpath  ~/.zshrc          ) ) )"
  fi
  export  shdir="$( \realpath "$zshdir"/../sh/ )"
  # I don't actually use this variable anyway
  #shell_random="$( \realpath "$zshdir"/../../ )"
}


{  # 'source' additional scripting and settings.

  function sourceallthat() {
    #\echo  "sourcing $1"
    \pushd > /dev/null
    \cd  "$1"
    if [ -f 'lib.sh' ]; then
      \source  'lib.sh'
    fi
    for i in *.sh; do
      if [ "$i" = 'lib.sh' ]; then
        continue
      fi
      \source  "$i"
    done
    # Note that it's intentional that this will generate an error if  suu()  is called by root, when root is currently sitting in an directory that denies permission to the user.
    \popd > /dev/null
  }


  sourceallthat  "$zshdir/../sh/"
  sourceallthat  "$zshdir/../sh/functions/"
  sourceallthat  "$zshdir/"


  case "$this_kernel_release" in
    'Cygwin')
      sourceallthat  "$zshdir/../babun/"
    ;;
    'Windows Subsystem for Linux')
      # I don't understand why doing this will change the directory I'm dropped into:
      #sourceallthat  "$zshdir/../wfl/"
      source  "$zshdir/../wfl/lib.sh"
      source  "$zshdir/../wfl/aliases.sh"
    ;;
  esac


  \unset -f sourceallthat

}



{  #  History
  # Keeping it out of ~/.zsh/ allows that directory's contents to be shared.
  HISTFILE="$HOME/.zsh_histfile"
  HISTSIZE=10000
  SAVEHIST=10000
  # prepend a command with a space and have it not commit a command to the histfile.
  setopt  HIST_IGNORE_SPACE
}


# Change the highlight colour.  Underlining doesn't seem to work.
zle_highlight=(region:bg=red special:underline)

# The default:
# export  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
\export  WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


{  #  Prompt
  # A decent default prompt:
  # autoload -U promptinit && promptinit && prompt suse

  # This block lets me copy this .zshrc for the root user.
  # Test for permission.
  if [ $( \whoami ) = root ];
    then  prompt_end_color='red'
    else  prompt_end_color='blue'
  fi

  # precmd is a zsh function which runs before a prompt.
  precmd() {
    # A vastly more complex example can be found at:
    #   http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/
    # There are other solutions for things like tmux.

    if [ $( \echo  "$PWD"  |  \wc  --chars ) -lt $[($COLUMNS/2)-1] ]; then
      # This is a little odd, to allow copy-paste from whole commandlines without fucking things up.
      PS1="%{$reset_color%}%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$prompt_end_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}"
    else
      # I want to display the full path, but I'm sick of starting off right at the end of a long one.
      PS1="%{$reset_color%}%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$prompt_end_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}
    %{$fg_bold[$prompt_end_color]%}>%{$reset_color%} "
    fi
  }

  # Original, simplified, method:
  #PS1="%~ %{$fg_bold[red]%}> %{$reset_color%}"
  #PS1=%~$'%{\e[31;1m%} > %{\e[0m%}'

  #PS1="%~ %{$fg_bold[blue]%}> %{$reset_color%}"
  #PS1=%~$'%{\e[34;1m%} > %{\e[0m%}'
}



{  #  Update the title of a terminal
  chpwd() {
    [[ -t 1 ]] || return
    print -Pn "\e]2;%~\a"
  }

  :<<'  }'   # I don't think I've ever needed this complexity
  {
    chpwd() {
      case $TERM in
        sun-cmd)
          print -Pn "\e]l%~\e\\"
        ;;
        *xterm*|rxvt(-unicode)|(dt|k|E)term|screen)
          print -Pn "\e]2;%~\a"
        ;;
      esac
    }
  }

  chpwd
}



{  #  Paths

  PATH=\
"$( \realpath  "$zshdir/scripts" )"\
:"$( \realpath  "$zshdir/../bash/scripts" )"\
:"$PATH"

  if [ "$this_kernel_release" = 'Cygwin'                      ] \
  || [ "$this_kernel_release" = 'Windows Subsystem for Linux' ]; then
    PATH=\
"$( \realpath  "$zshdir/../wfl/scripts" )"\
:"$PATH"
    fi

:<<'}'  #  Not used/tested in a while..
{
  # FIXME/TODO - Babun:  Tentative testing suggests there are valid applications within, but Babun is running as user.
  if [ $( \whoami ) = 'root' ]; then
    PATH="$PATH":'/sbin'
    PATH="$PATH":'/usr/sbin'
  fi
}

}



# Syntax highlighting magic
#   https://github.com/zsh-users/zsh-syntax-highlighting
#\source  ${a_drive}/live/OS/bin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#FIXME - a smarter path
\source  /mnt/a/live/OS/bin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



# I so frequently check for disk space that I ought to do it automatically.
# Note this is not  \dd  because I prefer my customized  dd()
df



# ---------------------------------------------------------------------



:<<'OLD'

# 2017-10-26 - Testing with this disabled.
# 
# http://www.zsh.org/mla/workers/1996/msg00191.html
if [[ $( \whoami ) = *\) ]]; then
  # We are remote
  # Do nothing
else
  DISPLAY=${DISPLAY:-:0.0}
fi



# 2017-10-26 - Babun always claims it is the tty.  I don't know when this would have been tested under Linux.
if [[ ${+WINDOWID} = 1 ]]; then
  # We're in X windows
  echo x!
else
  # We're at the tty / console
  echo tty
fi
OLD



:<<'}'
{
if [ -d '/mnt/a' ]; then  local  c_drive='/mnt/a'; fi   # Windows Subsystem for Linux
if [ -d '/mnt/c' ]; then  local  c_drive='/mnt/c'; fi   #
if [ -d '/mnt/d' ]; then  local  d_drive='/mnt/d'; fi   #
if [ -d '/a' ];     then  local  c_drive='/a';     fi   # Babun
if [ -d '/c' ];     then  local  c_drive='/c';     fi   #
if [ -d '/d' ];     then  local  d_drive='/d';     fi   #
}



