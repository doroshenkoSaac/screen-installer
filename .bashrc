# add these lines to .bashrc
# start screen on SSH login
if [ "$PS1" != "" -a $TERM != "screen" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
  STARTED_SCREEN=1
  export STARTED_SCREEN
  sleep 1
  screen -RR
  #screen -qRD
fi
# end screen on SSH login