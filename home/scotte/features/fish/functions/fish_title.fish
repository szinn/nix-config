function _thepath --description 'Shorten given path with substitutions'
  set -l subs "$HOME:~"

  set -l the_path $argv
  for i in $subs
    set -l parts (string split ':' $i)
    set the_path (string replace $parts[1] $parts[2] $the_path) 
  end

  echo $the_path
end

set -f command (echo $_)

if test $command = "fish"
    # we are sitting at the fish prompt
    if git rev-parse --git-dir > /dev/null 2>&1
      set -f git_dir (git rev-parse --git-dir)
      if test $git_dir = ".git"
        set -f git_repo (basename (pwd))
        set -f git_root (pwd)
      else
        set -f git_repo (basename (dirname $git_dir))
        set -f git_root (dirname $git_dir)/
      end
      set -l current_git_branch (git -C "$1" branch | sed  '/^\*/!d;s/\* //')
      if test $current_git_branch = "main"
        echo "$(hostname -s): $(string replace $git_root "" $PWD)"
      else
        echo "$(hostname -s): $(string replace $git_root "" $PWD) ($current_git_branch)"
      end
      # echo "$(hostname -s): $(string replace $git_root "" $PWD) ($git_repo: $current_git_branch)"
      # echo "$(hostname -s): $(string replace $git_root "" $PWD)"
    else
      echo "$(hostname -s): $(_thepath $PWD)"
    end
else
    # we are busy running some non-fish command, so use the command name
    echo "$(hostname -s): $command"
end
