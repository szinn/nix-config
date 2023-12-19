function __ssh_agent_is_started -d "check if ssh agent is already started"
  if test -f $SSH_ENV
    source $SSH_ENV > /dev/null
  else
    return 1
  end

  if test -z "$SSH_AGENT_PID"
    return 1
  end

  ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -v defunct | grep -q ssh-agent
  return $status
end

function __ssh_agent_start -d "start a new ssh agent"
  if ! test -z (pidof ssh-agent)
    for i in (string split ' ' (pidof ssh-agent))
      kill -9 $i
    end
  end
  ssh-agent -c | grep -v echo > $SSH_ENV
  chmod 600 $SSH_ENV
  source $SSH_ENV > /dev/null
  true  # suppress errors from setenv, i.e. set -gx
end

if test -z "$SSH_ENV"
  set -xg SSH_ENV $HOME/.ssh/environment
end

if not __ssh_agent_is_started
  __ssh_agent_start
  ssh-add
end
