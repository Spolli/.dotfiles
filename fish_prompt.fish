# name: taktoa
# by taktoa (Remy Goldschmidt) <taktoa@gmail.com>
# License: public domain

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_status_symbol
  set -l git_status (git status --porcelain ^/dev/null)
  if test -n "$git_status"
    if git status --porcelain ^/dev/null | grep '^.[^ ]' >/dev/null
      echo '*' # dirty
    else
      echo '#' # all staged
    end
  else
    echo    '' # clean
  end
end

function _remote_hostname
  echo (whoami)
  if test -n "$SSH_CONNECTION"
    echo " (ssh)"
  end
end

function _get_tmux_window
  tmux lsw | grep active | sed 's/\*.*$//g;s/: / /1' | awk '{ print $2 "-" $1 }' -
end

function _get_screen_window
  set initial (screen -Q windows; screen -Q echo "")
  set middle (echo $initial | sed 's/  /\n/g' | grep '\*' | sed 's/\*\$ / /g')
  echo $middle | awk '{ print $2 "-" $1 }' -
end

function _is_multiplexed
  set multiplexer ""
  if test -z $TMUX
  else
    set multiplexer "tmux"
  end
  if test -z $WINDOW
  else
    set multiplexer "screen"
  end
  echo $multiplexer
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l brown (set_color brown)
  set -l normal (set_color normal)

  set -l arrow "λ"
  set -l cwd (set_color $fish_color_cwd)(prompt_pwd)
  set -l git_status (_git_status_symbol)(_git_branch_name)

  if test -n "$git_status"
    set git_status " $git_status"
  end

  set multiplexer (_is_multiplexed)

  switch $multiplexer
    case screen
      set pane (_get_screen_window)
    case tmux
      set pane (_get_tmux_window)
   end

  if test -z $pane
    set window ""
  else
    set window " ($pane)"
  end

  echo -n -s (_remote_hostname) ' ' $cwd $brown $window $cyan $git_status $normal ' ' $arrow ' '
end

#Alias

alias aggiorna="sudo pacman -Syyu"
alias spengi="shutdown now"
alias ..="cd .."
alias ...="cd ../../../"
alias ....="cd ../../../../"
alias q="exit"
alias grep="grep --color=auto"
alias ll="ls -l"
alias la="ls -al"
alias edit_alias="atom /home/spolli/.config/fish/functions/fish_prompt.fish"
alias write="figlet -f slant"
alias path="pwd"
alias disinstalla="sudo pacman -Rns"
alias installa="sudo pacman -S"

function hotspot
  sudo ip link set dev wlp0s26u1u2 up
  sudo create_ap wlp0s26u1u2 wlp0s26u1u2 "Scuola Dello Scherzo" passworddelloscherzo
end

function add_startup_script
    sudo touch /etc/X11/xinit/xinitrc.d/ $argv'.sh'
    sudo chmod +x '/etc/X11/xinit/xinitrc.d'/$argv'.sh'
    sudo atom '/etc/X11/xinit/xinitrc.d'/$argv'.sh'
end

alias 4chan="python /home/spolli/Dropbox/NetLab/Script/4script.py"

function devilbox
  cd /home/spolli/Programs/devilbox
  docker-compose up httpd php mysql
end

function drive
  cd /home/spolli/GDrive
  grive -V --dry-run
end

alias mkdir="mkdir -p"
alias pacadd="pacaur -S"
alias pacrem="pacaur -Rnsc"
alias pacupd="pacaur -Syu"
alias pacsea="pacaur -Ss"
alias pacinf="pacaur -Qi"


alias piprem="sudo pip uninstall"
alias pipadd="sudo pip install"
alias pipupd="sudo pip install --upgrade"


alias star_wars="telnet towel.blinkenlights.nl"
alias record-screen="ffmpeg -video_size 1366x768 -framerate 60 -f x11grab -i :0.0 -c:v libx264 -crf 0 -preset ultrafast output.mp4"
alias clock="tty-clock -sb -C 4 -f ' %B %-e, %Y ' -d .1"

alias yt-music="youtube-dl -w -x --audio-format 'mp3' --audio-quality 320 -o '~/Musica/%(title)s.%(ext)s' -- "
alias yt-video="youtube-dl -w -o '~/Videos/%(title)s.%(ext)s' --"
alias yt-search="youtube-dl -e --get-duration --get-id --default-search ytsearch10 --"
